namespace BCLS.BCLS;

pageextension 50301 "FSO Retail Item" extends "LSC Retail Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("FSOPUR Brand"; Rec."FSOPUR Brand")
            {
                ApplicationArea = All;
            }
        }
    }
}
