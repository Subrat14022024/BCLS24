namespace FSOFIN.PayrollFileImport;

permissionset 50151 FSOFINImpGenJournal
{
    Assignable = true;
    Caption = 'ImportGeneralJournal', MaxLength = 30;
    Permissions =
        table "FSOFINImport Gen Journal Lines" = X,
        table "FSOFINImportGenJnl Conversion" = X,
        tabledata "FSOFINImport Gen Journal Lines" = RMID,
        tabledata "FSOFINImportGenJnl Conversion" = RMID;
}
