namespace FSO_Purchase.Discount;

table 50304 "FSO Brand"
{
    Caption = 'Brand';
    DataClassification = CustomerContent;
    LookupPageId = "FSO Brand";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the brand code.';
            NotBlank = true;
            OptimizeForTextSearch = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the brand description.';
            OptimizeForTextSearch = true;
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
