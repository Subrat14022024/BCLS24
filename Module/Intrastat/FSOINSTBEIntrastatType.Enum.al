namespace BCLS.BCLS;

enum 50102 "FSOINSTBEIntrastatType"
{
    Extensible = true;

    value(0; Invoice)
    {
        Caption = 'Invoice', Locked = true;
    }
    value(1; "Credit Memo")
    {
        Caption = 'Credit Memo', Locked = true;
    }
}
