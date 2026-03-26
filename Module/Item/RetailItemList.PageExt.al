namespace FSO_Purchase.VendorItemColor;
pageextension 58403 "Retail Item List" extends "LSC Retail Item List"
{
    layout
    {
        addafter(Description)
        {
            field("Vendor Item Color"; Rec."Vendor Item Color")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor item colour';
            }
        }
    }
}