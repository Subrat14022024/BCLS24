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
            }
        }
    }
}
