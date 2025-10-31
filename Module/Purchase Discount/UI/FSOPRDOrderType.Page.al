namespace FSO_Purchase.Discount;

using FSO_Purchase.Discount;

page 50301 "FSO PRD Order Type"
{
    ApplicationArea = All;
    Caption = 'Order Type';
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
