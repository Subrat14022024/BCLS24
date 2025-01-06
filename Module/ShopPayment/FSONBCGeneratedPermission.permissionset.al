namespace FSO_NAVBCConnector.Shoppayment;
permissionset 50100 FSONBCGenPermission
{
    Assignable = true;
    Permissions = tabledata "FSONBCShopPaymentEntries" = RIMD,
        table "FSONBCShopPaymentEntries" = X,
        page "FSONBCShopPaymentEntries" = X;
}