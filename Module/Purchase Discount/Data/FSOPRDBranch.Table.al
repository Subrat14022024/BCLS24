namespace FSO_Purchase.Discount;

table 50650 "FSO PRD Branch"
{
    Caption = 'Branch';
    DataClassification = CustomerContent;
    LookupPageId = "FSO PRD Branch";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Specicies the Branch Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            ToolTip = 'Specicies the Branch Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
