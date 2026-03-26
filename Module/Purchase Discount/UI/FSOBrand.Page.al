namespace FSO_Purchase.Discount;

using FSO_Purchase.Discount;

page 50302 "FSO Brand"
{
    ApplicationArea = All;
    Caption = 'Brands';
    PageType = List;
    SourceTable = "FSO PUR Brand";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("eCommerce Active"; Rec."eCommerce Active")
                {
                }
                field("No Stock Posting"; Rec."No Stock Posting")
                {
                }
                field("PO First Expected Receipt Date"; Rec."PO First Expected Receipt Date")
                {
                }
                field("PO Last Expected Receipt Date"; Rec."PO Last Expected Receipt Date")
                {
                }
            }
        }
    }
}
