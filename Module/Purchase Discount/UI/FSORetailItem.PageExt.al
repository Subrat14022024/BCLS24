namespace BCLS.BCLS;

pageextension 50301 "FSO Retail Item" extends "LSC Retail Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("FSO Brand"; Rec."FSO Brand")
            {
                ApplicationArea = All;
            }
        }
    }
}
