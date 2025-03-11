namespace BCLS.BCLS;

using Microsoft.Bank.Payment;

tableextension 50104 EBPaymentJoExtnesion extends "Payment Journal Line"
{
    fields
    {
        field(50100; "Due Date VLE"; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;
        }
        field(50101; "Pmt. Discount Date VLE"; Date)
        {
            Caption = 'Pmt. Discount Date VLE';
            DataClassification = CustomerContent;
        }
    }
}
