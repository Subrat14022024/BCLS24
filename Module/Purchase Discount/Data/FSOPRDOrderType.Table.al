namespace FSO_Purchase.Discount;

table 50301 "FSO PRD Order Type"
{
    Caption = 'Order Type';
    DataClassification = CustomerContent;
    LookupPageId = "FSO PRD Order Type";

    fields
    {
        field(1; "Order Type"; Code[20])
        {
            Caption = 'Order Type';
            ToolTip = 'Specifies the Order Type.';
        }
        field(2; "Sub Order Type"; Code[20])
        {
            Caption = 'Sub Order Type';
            ToolTip = 'Specifies the Sub Order Type.';
        }
        field(3; Blocked; Boolean)
        {
            Caption = 'Blocked';
            ToolTip = 'Indicates whether this Order Type is blocked from use.';
        }
    }
    keys
    {
        key(PK; "Order Type", "Sub Order Type")
        {
            Clustered = true;
        }
    }
    procedure IsBlocked(OrderType: Code[20]; SubOrderType: Code[20]): Boolean
    begin
        Rec.ReadIsolation(IsolationLevel::ReadUncommitted);
        if Rec.Get(OrderType, SubOrderType) then
            exit(Rec.Blocked)
    end;
}
