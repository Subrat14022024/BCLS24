namespace FSO_Purchase.Discount;

using FSO_Purchase.Discount;

page 50302 "FSO Brand"
{
    ApplicationArea = All;
    Caption = 'Brand';
    PageType = List;
    SourceTable = "FSO Brand";
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
            }
        }
    }
}
