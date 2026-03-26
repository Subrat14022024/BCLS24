namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Document;
using Microsoft.Utilities;

pageextension 50201 "Retail Purch Line" extends "LSC Retail PO Subpage"
{
    layout
    {
        addbefore("No.")
        {
            field("Vendor Item Color"; Rec."Vendor Item Color")
            {
                ApplicationArea = all;
            }
        }
        movebefore("Vendor Item Color"; "Vendor Item No.")
        modify("Vendor Item No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                LSCItemDistribution: Record "LSC Item Distribution";
                Item: Record Item;
                LSCRetailSetup: Record "LSC Retail Setup";
                PurchHeader: Record "Purchase Header";
                LSCBOUtils: Codeunit "LSC BO Utils";
            begin
                case Rec.Type of
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
                                            Text := Item."Vendor Item No.";
                                            OnValidateVendorItemNo(Item);
                                            exit(true);
                                        end;
                                    end;
                                LSCRetailSetup."PO Item Lookup Method"::"Store Distribution":
                                    begin
                                        LSCItemDistribution.Reset();
                                        LSCItemDistribution.SetRange(Status, LSCItemDistribution.Status::Active);
                                        if Page.RunModal(Page::"LSC Item Distribution Lookup", LSCItemDistribution) = Action::LookupOK then begin
                                            if Item.Get(LSCItemDistribution."Item No.") then;
                                            Text := Item."Vendor Item No.";
                                            OnValidateVendorItemNo(Item);
                                            exit(true);
                                        end;
                                    end;
                                LSCRetailSetup."PO Item Lookup Method"::None:
                                    exit;
                            end;
                        end;
                end;
            end;

            trigger OnAfterValidate()
            var
                lPurchHeaderRec: Record "Purchase Header";
                lItemRec: Record Item;
                Barcodes: Record "LSC Barcodes";
                lItemsInStoreRec: Record "LSC Item Distribution";
                lISUserRec: Record "LSC Retail User";
                lRetailSetup: Record "LSC Retail Setup";
                Item: Record Item;
                BarcodeMgmt: Codeunit "LSC Barcode Management";
                Amount: Decimal;
                Qty: Decimal;
                Text001Err: Label 'This Item is not in distribution.';
            begin
                if Rec."Vendor Item No." = '' then
                    exit;

                if lPurchHeaderRec.Get(Rec."Document Type", Rec."Document No.") then;
                lItemRec.Reset();
                lItemRec.SetCurrentKey("Vendor Item No.");
                lItemRec.SetRange("Vendor Item No.", Rec."Vendor Item No.");
                lItemRec.SetRange("Vendor No.", lPurchHeaderRec."Buy-from Vendor No.");
                if lItemRec.FindFirst() then begin
                    Rec.Validate("No.", lItemRec."No.");
                    Rec."Vendor Item No." := lItemRec."Vendor Item No.";
                end;
                // end else
                //     if StrLen(Rec."Vendor Item No.") <= MaxStrLen(Barcodes."Barcode No.") then
                //         if BarcodeMgmt.FindBarcodeDetails(, Item, Barcodes, Amount, Qty) then begin
                //             Rec.Validate("No.", Barcodes."Item No.");
                //             Rec."Vendor Item No." := Item."Vendor Item No.";
                //         end;

                if Rec.Type = Rec.Type::Item then begin
                    lRetailSetup.Get();
                    if lRetailSetup."PO Item Lookup Method" = lRetailSetup."PO Item Lookup Method"::"Store Distribution" then begin
                        lItemsInStoreRec.Reset();
                        if lItemsInStoreRec.getItemDistribution(Rec."No.", lISUserRec."Store No.", lItemsInStoreRec) then begin
                            if lItemsInStoreRec.Status <> lItemsInStoreRec.Status::Active then
                                Error(Text001Err);
                        end else
                            Error(Text001Err);
                    end;
                end;
                NoOnAfterValidate()
            end;
        }
    }

    local procedure OnValidateVendorItemNo(Item: Record Item)
    var
        PurchaseLine: Record "Purchase Line";
        TempPurchLine: Record "Purchase Line" temporary;
    begin
        TempPurchLine := Rec;
        Rec.Init();
        Rec.SystemId := TempPurchLine.SystemId;
        if xRec."Line Amount" <> 0 then
            Rec."Recalculate Invoice Disc." := xRec."Allow Invoice Disc.";
        Rec.Type := TempPurchLine.Type;
        Rec."No." := TempPurchLine."No.";
        if Rec.HasTypeToFillMandatoryFields() then begin
            Rec.Quantity := TempPurchLine.Quantity;
            Rec."Outstanding Qty. (Base)" := TempPurchLine."Outstanding Qty. (Base)";
        end;

        Rec."System-Created Entry" := TempPurchLine."System-Created Entry";


        if Rec.Type = Rec.Type::Item then
            if PurchaseLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.") then begin
                PurchaseLine.Validate("Vendor Item Color", Item."Vendor Item Color");
                PurchaseLine.Validate("No.", Item."No.");
                PurchaseLine.Modify(true)
            end;
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);
        if (Rec.Type = Rec.Type::"Charge (Item)") and (Rec."No." <> xRec."No.") and
           (xRec."No." <> '')
        then
            CurrPage.SaveRecord();
    end;
}
