namespace FSO_Purchase.Discount;

using Microsoft.Purchases.Document;

pageextension 50651 "FSO PRD Retail Purchase Order" extends "LSC Retail Purchase Order"
{
    layout
    {
        addafter("Buy-from City")
        {
            field("FSO PRD Branch"; Rec."FSO PRD Branch")
            {
                ApplicationArea = all;
            }
            field("FSO PRD Brand"; Rec."FSO PRD Brand")
            {
                ApplicationArea = all;
            }
        }
        addafter("Buyer Group Code")
        {
            field("FSO PRD Order Type"; Rec."FSO PRD Order Type")
            {
                ApplicationArea = all;
                trigger OnAfterLookup(Selected: RecordRef)
                var
                    OrderTypeFieldRef: FieldRef;
                    SubOrderTypeFieldRef: FieldRef;
                    IsModified: Boolean;
                    Txt001_Lbl: Label 'you cannot change because there are received lines in this purchase order.', Locked = true;
                begin
                    if Rec.ReceivedPurchLinesExist() then
                        Rec.FieldError("FSO PRD Order Type", Txt001_Lbl);
                    OrderTypeFieldRef := Selected.Field(1);
                    SubOrderTypeFieldRef := Selected.Field(2);
                    if Format(OrderTypeFieldRef.Value) <> '' then
                        if Rec."FSO PRD Order Type" <> Format(OrderTypeFieldRef.Value) then begin
                            Rec.Validate("FSO PRD Order Type", Format(OrderTypeFieldRef.Value));
                            IsModified := true;
                        end;

                    if Format(SubOrderTypeFieldRef.Value) <> '' then
                        if Rec."FSO PRD Sub Order Type" <> Format(SubOrderTypeFieldRef.Value) then begin
                            Rec.Validate("FSO PRD Sub Order Type", Format(SubOrderTypeFieldRef.Value));
                            IsModified := true;
                        end;
                    if IsModified then
                        Rec.Modify(true);
                    xRec := Rec;
                end;
            }
            field("FSO PRD Sub Order Type"; Rec."FSO PRD Sub Order Type")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast("P&osting")
        {
            action(ApplyCommercialDiscount)
            {
                Caption = 'Apply Commercial Discount';
                ApplicationArea = all;
                ToolTip = 'Calculate the discount that can ne granted based on all lines in the purchase document';
                Image = CalculateDiscount;
                trigger OnAction()
                var
                    PurchaseDiscountHandler: Codeunit "FSO PRD Purchase Discount Mgmt";
                begin
                    PurchaseDiscountHandler.ApplyCommercialDiscount(Rec);
                end;
            }
        }
        addlast(Promoted)
        {
            group(Discounts)
            {
                actionref(FSOSApplyBrandDiscount_Promoted; ApplyCommercialDiscount)
                {
                }
            }
        }
    }
}
