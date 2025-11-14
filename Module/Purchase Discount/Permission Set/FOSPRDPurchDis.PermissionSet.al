namespace FSO_Purchase.Discount;

permissionset 50650 "FOS PRD Purch Dis"
{
    Assignable = true;
    Caption = 'Purchase Discount Permissions', MaxLength = 30;
    Permissions =
        table "FSO PRD Order Type" = X,
        tabledata "FSO PRD Order Type" = RMID,
        table "FSO PRD Branch" = X,
        tabledata "FSO PRD Branch" = RMID,
        table "FSO PRD Commercial Discount" = X,
        tabledata "FSO PRD Commercial Discount" = RMID,
        table "FSO Brand" = X,
        tabledata "FSO Brand" = RMID;
}
