namespace BCLS.BCLS;

using Microsoft.Foundation.PaymentTerms;

pageextension 58000 PaymentTermExtn extends "Payment Terms"
{
    layout
    {
        addafter(Description)
        {
            field("Cash Discount Excl. VAT"; Rec."Cash Discount Excl. VAT")
            {
                ApplicationArea = all;
                ToolTip = 'kjdfk';
            }

        }
    }
}
