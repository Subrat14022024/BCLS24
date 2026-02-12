namespace FSO_Purchase.Discount;

using System.Text;

page 50651 "FSO PRD Order Type"
{
    ApplicationArea = All;
    Caption = 'Order Types';
    PageType = List;
    SourceTable = "FSO PRD Order Type";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Order Type"; Rec."Order Type")
                {
                }
                field("Sub Order Type"; Rec."Sub Order Type")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
            }
        }
    }
}
