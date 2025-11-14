namespace BCLS.BCLS;

pageextension 50302 "FSO PUR LSC Retail Item List" extends "LSC Retail Item List"
{
    layout
    {
        addafter(BarcodeNo)
        {
            field("FSO Brand"; Rec."FSO Brand")
            {
                ApplicationArea = All;
            }
        }
    }
}
