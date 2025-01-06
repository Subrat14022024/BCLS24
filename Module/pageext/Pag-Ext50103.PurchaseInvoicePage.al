namespace BCLS.BCLS;

using Microsoft.Purchases.Document;

pageextension 50103 PurchaseInvoicePage extends "Purchase Invoice"
{
    layout
    {
        addafter("Payment Terms Code")
        {
            field("FSONBCVAT Base Discount %"; Rec."VAT Base Discount %")
            {
                ApplicationArea = All;
                Caption = 'VAT Base Discount %';
                ToolTip = 'VAT Base Discount %';
                Editable = true;
            }
        }
    }
}
