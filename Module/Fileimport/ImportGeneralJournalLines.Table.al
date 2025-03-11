table 59001 "Import General Journal Lines"
{
    Caption = 'Import General Journal Lines';
    fields
    {
        field(1; LineNo; Integer)
        {
            Caption = 'LineNo';
            DataClassification = CustomerContent;
        }
        field(2; Veld_01; Text[30])
        {
            Caption = 'Veld_01';
            DataClassification = CustomerContent;
        }
        field(3; Veld_02; Text[30])
        {
            Caption = 'Veld_02';
            DataClassification = CustomerContent;
        }
        field(4; Veld_03; Text[30])
        {
            Caption = 'Veld_03';
            DataClassification = CustomerContent;
        }
        field(5; Veld_04; Code[30])
        {
            Caption = 'Veld_04';
            DataClassification = CustomerContent;
        }
        field(6; Veld_05; Text[30])
        {
            Caption = 'Veld_05';
            DataClassification = CustomerContent;
        }
        field(7; Veld_06; Text[30])
        {
            Caption = 'Veld_06';
            DataClassification = CustomerContent;
        }
        field(8; Veld_07; Text[30])
        {
            Caption = 'Veld_07';
            DataClassification = CustomerContent;
        }
        field(9; Veld_08; Decimal)
        {
            Caption = 'Veld_08';
            DataClassification = CustomerContent;
        }
        field(10; Veld_09; Decimal)
        {
            Caption = 'Veld_09';
            DataClassification = CustomerContent;
        }
        field(11; Veld_10; Decimal)
        {
            Caption = 'Veld_10';
            DataClassification = CustomerContent;
        }
        field(12; Veld_11; Decimal)
        {
            Caption = 'Veld_11';
            DataClassification = CustomerContent;
        }
        field(13; Veld_12; Text[30])
        {
            Caption = 'Veld_12';
            DataClassification = CustomerContent;
        }
        field(14; Veld_13; Text[30])
        {
            Caption = 'Veld_13';
            DataClassification = CustomerContent;
        }
        field(15; Veld_14; Text[30])
        {
            Caption = 'Veld_14';
            DataClassification = CustomerContent;
        }
        field(16; Veld_15; Code[20])
        {
            Caption = 'Veld_15';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; LineNo)
        {
            Clustered = true;
        }
    }
}
