namespace BCLS.BCLS;

using Microsoft.Finance.Dimension;

tableextension 50106 "DimensionValueExt" extends "Dimension Value"
{
    fields
    {
        field(50100; Entity; Code[20])
        {
            Caption = 'Entity';
            ToolTip = 'Specifies entity of the dimension values';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                          Blocked = const(false));
        }
    }
}
