namespace FSFINBELTEST.FSFINBELTEST;

permissionset 59100 ImportGeneralJournal
{
    Assignable = true;
    Caption = 'ImportGeneralJournal', MaxLength = 30;
    Permissions =
        table "Import General Journal Lines" = X,
        table "Import Gen Jnl Conversion" = X,
        tabledata "Import General Journal Lines" = RMID,
        tabledata "Import Gen Jnl Conversion" = RMID;
}
