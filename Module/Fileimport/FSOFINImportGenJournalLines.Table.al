namespace FSOFIN.PayrollFileImport;

table 50152 "FSOFINImport Gen Journal Lines"
{
    Caption = 'Import General Journal Lines';
    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Line No. field.';
        }
        field(2; Field_01; Text[30])
        {
            Caption = 'Field_01';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_01 field.';
        }
        field(3; Field_02; Text[30])
        {
            Caption = 'Field_02';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_02 field.';
        }
        field(4; Field_03; Text[30])
        {
            Caption = 'Field_03';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_03 field.';
        }
        field(5; Field_04; Code[30])
        {
            Caption = 'Field_04';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_04 field.';
        }
        field(6; Field_05; Text[30])
        {
            Caption = 'Field_05';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_05 field.';
        }
        field(7; Field_06; Text[30])
        {
            Caption = 'Field_06';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_06 field.';
        }
        field(8; Field_07; Text[30])
        {
            Caption = 'Field_07';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_07 field.';
        }
        field(9; Field_08; Decimal)
        {
            Caption = 'Field_08';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_08 field.';
        }
        field(10; Field_09; Decimal)
        {
            Caption = 'Field_09';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_09 field.';
        }
        field(11; Field_10; Decimal)
        {
            Caption = 'Field_10';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_10 field.';
        }
        field(12; Field_11; Decimal)
        {
            Caption = 'Field_11';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_11 field.';
        }
        field(13; Field_12; Text[30])
        {
            Caption = 'Field_12';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_12 field.';
        }
        field(14; Field_13; Text[30])
        {
            Caption = 'Field_13';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_13 field.';
        }
        field(15; Field_14; Text[30])
        {
            Caption = 'Field_14';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_14 field.';
        }
        field(16; Field_15; Code[20])
        {
            Caption = 'Field_15';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Field_15 field.';
        }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}
