namespace FSO.Dimension;

using Microsoft.Finance.Dimension;

pageextension 50158 "FSOFIN DimensionValues" extends "Dimension Values"
{
    layout
    {
        addafter(Blocked)
        {
            field("FSOFIN Link Dimension"; Rec."FSOFIN Link Dimension")
            {
                ApplicationArea = all;
            }
            field("FSOFIN Enseigne"; Rec."FSOFIN Enseigne")
            {
                ApplicationArea = all;
            }
        }
    }
}
