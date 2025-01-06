namespace FSO_NAVBCConnector.Shoppayment;

enum 50101 FSONBCShopPmtTypeofPosting
{
    Extensible = true;

    value(0; DayClosing)
    {
        Caption = 'DayClosing', Locked = true;
    }
    value(1; Vault)
    {
        Caption = 'Vault', Locked = true;
    }
}
