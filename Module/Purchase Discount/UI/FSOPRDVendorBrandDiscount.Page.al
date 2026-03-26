namespace FSO_Purchase.Discount;

page 50652 "FSO PRD Vendor Brand Discount"
{
    ApplicationArea = All;
    Caption = 'Commercial Discounts';
    PageType = List;
    SourceTable = "FSO PRD Commercial Discount";
    UsageCategory = Tasks;
    DelayedInsert = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Brand"; Rec."Brand")
                {
                }
                field("Order Type"; Rec."Order Type")
                {
                }
                field("Sub Order Type"; Rec."Sub Order Type")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Discount %"; Rec."Discount %")
                {
                }
            }
        }
    }
}
