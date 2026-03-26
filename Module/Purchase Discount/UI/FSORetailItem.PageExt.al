namespace BCLS.BCLS;
#if not FSOCLEAN27
pageextension 50301 "FSO Retail Item" extends "LSC Retail Item Card"
#endif
pageextension 50301 "FSO Retail Item" extends "LSC Retail Item"
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
