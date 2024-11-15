namespace BCLS.BCLS;

enum 50100 ShopPaymentType
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
