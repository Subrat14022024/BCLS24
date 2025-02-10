namespace FINBC.FINBC;

using Microsoft.Foundation.PaymentTerms;

tableextension 58000 PaymentTermExtn extends "Payment Terms"
{
    fields
    {
        field(58000; "Cash Discount Excl. VAT"; Boolean)
        {
            Caption = 'Cash Discount Excl. VAT';
            DataClassification = CustomerContent;
        }
    }
}
