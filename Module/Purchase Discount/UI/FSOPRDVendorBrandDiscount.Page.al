namespace FSO_Purchase.Discount;

page 50303 "FSO PRD Vendor Brand Discount"
{
    ApplicationArea = All;
    Caption = 'Vendor Brand Discount';
    PageType = List;
    SourceTable = "FSO PRD Vendor Brand Discount";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field(Branch; Rec.Branch)
                {
                }
                field("Attribute Code"; Rec."Attribute Code")
                {
                }
                field("Attribute Description"; Rec."Attribute Description")
                {
                }
                field("Attribute Code Value"; Rec."Attribute Code Value")
                {
                }
                field("Order Type"; Rec."Order Type")
                {
                }
                field("Sub Order Type"; Rec."Sub Order Type")
                {
                }
                field("Discount %"; Rec."Discount %")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
            }
        }
    }
}
