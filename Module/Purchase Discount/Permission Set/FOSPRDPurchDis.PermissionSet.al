namespace FSO_Purchase.Discount;

permissionset 50301 "FOS PRD Purch Dis"
{
    Assignable = true;
    Caption = 'Purchase Discount Permissions', MaxLength = 30;
    Permissions =
        table "FSO PRD Order Type" = X,
        tabledata "FSO PRD Order Type" = RMID,
        table "FSO PRD Branch" = X,
        tabledata "FSO PRD Branch" = RMID,
        table "FSO PRD Vendor Brand Discount" = X,
        tabledata "FSO PRD Vendor Brand Discount" = RMID;
}
