namespace FSO_FINBE.CustomerCreation;

table 50206 "FSO BEF Customer Data"
{
    DataClassification = CustomerContent;
    Caption = 'Customer Data';

    fields
    {
        field(1; "Enterprise No."; Code[20])
        {
            Caption = 'Enterprise No.';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Street; Text[100])
        {
            Caption = 'Street';
        }
        field(4; "Street No"; Code[20])
        {
            Caption = 'Street No';
        }
        field(5; Box; Text[50])
        {
            Caption = 'Box';
        }
        field(6; "Postal Code"; Code[20])
        {
            Caption = 'Post Code';
        }
        field(7; City; Text[100])
        {
            Caption = 'City';
        }
        field(8; Country; Text[50])
        {
            Caption = 'Country';
        }
        field(9; Info; Text[250])
        {
            Caption = 'Info';
        }
        field(10; "Type"; Text[50])
        {
            Caption = 'Type';
        }
    }

    keys
    {
        key(PK; "Enterprise No.")
        {
            Clustered = true;
        }

    }
}