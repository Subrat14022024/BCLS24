namespace FSO.Dimension;

using Microsoft.Finance.Dimension;

tableextension 50158 "FSOFIN DimensionValue" extends "Dimension Value"
{
    fields
    {
        field(50150; "FSOFIN Enseigne"; Code[20])
        {
            Caption = 'Enseigne';
            ToolTip = 'Specifies the entity associated with this dimension value';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("FSOFIN Link Dimension"), Blocked = const(false));
        }
        field(50151; "FSOFIN Link Dimension"; Code[20])
        {
            Caption = 'Link Dimension';
            ToolTip = 'Specifies the dimension to which this value is linked';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }
    }
}
