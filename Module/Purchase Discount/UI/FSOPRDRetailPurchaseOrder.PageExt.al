namespace FSO_Purchase.Discount;

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
            action(ApplyBrandDiscount)
            {
                Caption = 'Apply Brand Discount';
                ApplicationArea = all;
                ToolTip = 'Calculate the discount that can ne granted based on all lines in the purchase document';
                Image = CalculateDiscount;
                trigger OnAction()
                var
                    PurchaseDiscountHandler: Codeunit "FSO PRD Purchase Discount Mgmt";
                begin
                    PurchaseDiscountHandler.ApplyBrandDiscount(Rec);
                end;
            }
        }
        addlast(Promoted)
        {
            group(Discounts)
            {
                actionref(FSOSApplyBrandDiscount_Promoted; ApplyBrandDiscount)
                {
                }
            }
        }
    }
}
