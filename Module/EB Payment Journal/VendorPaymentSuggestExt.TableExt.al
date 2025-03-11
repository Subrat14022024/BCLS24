namespace BCLS.BCLS;

using Microsoft.Purchases.Payables;

tableextension 50105 VendorPaymentSuggestExt extends "Vendor Payment Buffer"
{
    fields
    {
        field(50100; "Pmt. Discount Date VLE"; Date)
        {
            Caption = 'Pmt. Discount Date VLE';
            DataClassification = ToBeClassified;
        }
        field(50101; "Due Date VLE"; Date)
        {
            Caption = 'Due Date VLE';
            DataClassification = ToBeClassified;
        }
        field(50102; "Payment Discount Amount"; Decimal)
        {
            Caption = 'Payment Discount Amount';
            DataClassification = ToBeClassified;
        }
    }
}
