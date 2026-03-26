namespace FSO_Purchase.Discount;

table 50309 "FSO PUR Brand"
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
        field(3; "eCommerce Active"; Boolean)
        {
            Caption = 'eCommerce Active';
            ToolTip = 'Specifies whether the brand is active for eCommerce.';
        }
        field(4; "No Stock Posting"; Boolean)
        {
            Caption = 'No Stock Posting';
            ToolTip = 'Specifies whether the brand is not allowed to post stock transactions.';
        }
        field(5; "PO First Expected Receipt Date"; DateFormula)
        {
            Caption = 'First Expected Receipt Date Formula';
            ToolTip = 'Specifies First Expected Date(Re-Order) for the Brand';
        }
        field(6; "PO Last Expected Receipt Date"; DateFormula)
        {
            Caption = 'PO Last Expected Receipt Date Formula';
            ToolTip = 'Specifies Last Expected Date(Re-Order) for the Brand';
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
