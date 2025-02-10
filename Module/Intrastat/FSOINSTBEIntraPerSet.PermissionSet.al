namespace BCLS.BCLS;

permissionset 50103 FSOINSTBEIntraPerSet
{
    Assignable = true;
    Permissions = tabledata "TCOGINGL Intrastat Report Line" = RIMD, tabledata "FSOINSTBEIntrastat Purchase" = RIMD,
        table "TCOGINGL Intrastat Report Line" = X,
        table "fSOINSTBEIntrastat Purchase" = X;
}
