namespace FSO_Purchase.Discount;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Document;
using Microsoft.Utilities;
pageextension 50650 "FSO PRD LSC Retail PO Subpage" extends "LSC Retail PO Subpage"
{
    layout
    {
        addfirst(Control1)
        {
            field("FSO PRD Order Type"; Rec."FSO PRD Order Type")
            {
                ApplicationArea = all;
            }
            field("FSO PRD Sub Order Type"; Rec."FSO PRD Sub Order Type")
            {
                ApplicationArea = all;
            }
            field("FSO PRD Branch"; Rec."FSO PRD Branch")
            {
                ApplicationArea = all;
            }
        }
        modify("No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                LSCItemDistribution: Record "LSC Item Distribution";
                Item: Record Item;
                LSCRetailSetup: Record "LSC Retail Setup";
                StandardText: Record "Standard Text";
                GLAccount: Record "G/L Account";
                FixedAsset: Record "Fixed Asset";
                ItemCharge: Record "Item Charge";
                PurchHeader: Record "Purchase Header";
                LSCBOUtils: Codeunit "LSC BO Utils";
            begin
                case Rec.Type of
                    Rec.Type::" ":
                        begin
                            if StandardText.Get(Rec."No.") then;
                            if Page.RunModal(0, StandardText) = Action::LookupOK then begin
                                Text := StandardText.Code;
                                exit(true);
                            end else
                                exit(false);
                        end;
                    Rec.Type::"G/L Account":
                        begin
                            if GLAccount.Get(Rec."No.") then;
                            if Page.RunModal(0, GLAccount) = Action::LookupOK then begin
                                Text := GLAccount."No.";
                                exit(true);
                            end else
                                exit(false);
                        end;
                    Rec.Type::Item:
                        begin
                            LSCRetailSetup.Get();
                            case LSCRetailSetup."PO Item Lookup Method" of
                                LSCRetailSetup."PO Item Lookup Method"::"Item Master":
                                    begin
                                        if Item.Get(Rec."No.") then;
                                        if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then
                                            if PurchHeader."FSO PRD Brand" <> '' then
                                                Item.SetRange("FSOPUR Brand", PurchHeader."FSO PRD Brand");
                                        if Page.RunModal(LSCBOUtils.getLookupPage(Database::Item), Item) = Action::LookupOK then begin
                                            Text := Item."No.";
                                            exit(true);
                                        end;
                                    end;
                                LSCRetailSetup."PO Item Lookup Method"::"Store Distribution":
                                    begin
                                        LSCItemDistribution.Reset();
                                        LSCItemDistribution.SetRange(Status, LSCItemDistribution.Status::Active);
                                        if Page.RunModal(Page::"LSC Item Distribution Lookup", LSCItemDistribution) = Action::LookupOK then begin
                                            Text := LSCItemDistribution."Item No.";
                                            exit(true);
                                        end;
                                    end;
                                LSCRetailSetup."PO Item Lookup Method"::None:
                                    exit;
                            end;
                        end;
                    Rec.Type::"Fixed Asset":
                        begin
                            if FixedAsset.Get(Rec."No.") then;
                            if Page.RunModal(0, FixedAsset) = Action::LookupOK then begin
                                Text := FixedAsset."No.";
                                exit(true);
                            end else
                                exit(false);
                        end;
                    Rec.Type::"Charge (Item)":
                        begin
                            if ItemCharge.Get(Rec."No.") then;
                            if Page.RunModal(0, ItemCharge) = Action::LookupOK then begin
                                Text := ItemCharge."No.";
                                exit(true);
                            end else
                                exit(false);
                        end;
                end;
            end;
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        PurchaseDiscountHandler: Codeunit "FSO PRD Purchase Discount Mgmt";
    begin
        if Rec."Document No." <> '' then
            PurchaseDiscountHandler.NotifyAboutMissingDiscountonLines(Rec.GetPurchHeader());
    end;
}