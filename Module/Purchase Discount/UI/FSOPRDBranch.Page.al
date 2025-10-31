namespace FSO_Purchase.Discount;

page 50505 "FSO PRD Branch"
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
            group(General)
            {
                field("Code"; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }
}
