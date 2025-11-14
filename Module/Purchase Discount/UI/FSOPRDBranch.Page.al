namespace FSO_Purchase.Discount;

page 50650 "FSO PRD Branch"
{
    ApplicationArea = All;
    Caption = 'Branch';
    PageType = List;
    SourceTable = "FSO PRD Branch";
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
