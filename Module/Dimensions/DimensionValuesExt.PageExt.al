namespace BCLS.BCLS;

using Microsoft.Finance.Dimension;

pageextension 50109 DimensionValuesExt extends "Dimension Values"
{
    layout
    {
        addafter(Blocked)
        {
            field(Entity; Rec.Entity)
            {
                ApplicationArea = all;
            }
        }
    }
}
