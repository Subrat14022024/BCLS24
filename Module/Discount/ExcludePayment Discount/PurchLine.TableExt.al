namespace BCLS.BCLS;

using Microsoft.Purchases.Document;

tableextension 50109 PurchLine extends "Purchase Line"
{
    fields
    {
        field(50100; "Exclude from Payment Discount"; Boolean)
        {
            Caption = 'Exclude from Payment Discount';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether this line is excluded from payment discount calculations.';
        }
    }
}
