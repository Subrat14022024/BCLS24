namespace FSO_NAVBCConnector.Shoppayment;

enum 50100 FSONBCShopPaymentType
{
    Extensible = true;

    value(0; Payment)
    {
        Caption = 'Payment';
    }
    value(1; "G/L Account")
    {
        Caption = 'G/L Account';
    }
}
