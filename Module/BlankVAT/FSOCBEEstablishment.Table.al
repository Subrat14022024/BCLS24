namespace BlankVAT.CBEImporter;
table 54701 "FSO CBE Establishment"
{
    Caption = 'CBE Establishment';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Company CBE No."; Code[20])
        {
            Caption = 'Company CBE No.';
            TableRelation = "FSO CBE Company"."CBE No.";
        }
        field(2; "Establishment No."; Text[50])
        {
            Caption = 'Establishment Number';
        }
        field(3; "Street"; Text[100]) { Caption = 'Street'; }
        field(4; "House No."; Text[30]) { Caption = 'House No.'; }
        field(5; "Box"; Text[20]) { Caption = 'Box'; }
        field(6; "Post Code"; Text[20]) { Caption = 'Post Code'; }
        field(7; "City"; Text[60]) { Caption = 'City'; }
        field(8; "Country Code"; Code[10]) { Caption = 'Country Code'; }
        field(9; "Full Address"; Text[250]) { Caption = 'Full Address'; }
        field(10; "Type Of Address"; Text[50]) { Caption = 'Type Of Address'; }
    }

    keys
    {
        key(PK; "Company CBE No.", "Establishment No.")
        {
            Clustered = true;
        }
        key(ByCompany; "Company CBE No.")
        {
        }
    }
}