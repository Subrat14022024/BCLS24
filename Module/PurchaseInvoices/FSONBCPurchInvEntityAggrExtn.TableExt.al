namespace FSO_NAVBCConnector.PurchaseInv;

using Microsoft.Integration.Entity;
tableextension 50102 FSONBCPurchInvEntityAggrExtn extends "Purch. Inv. Entity Aggregate"
{
    fields
    {
        field(50100; "FSONBCPosting No."; Code[20])
        {
            Caption = 'Posting No.';
            DataClassification = CustomerContent;
        }
        field(50101; "FSONBCVAT Base Discount"; Decimal)
        {
            Caption = 'VAT Base Discount';
            DataClassification = CustomerContent;
        }
        field(50102; "FSONBCPayment Discount"; Decimal)
        {
            Caption = 'Payment Discount';
            DataClassification = CustomerContent;
        }
    }
}
