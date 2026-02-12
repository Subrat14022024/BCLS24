namespace BlankVAT.CBEImporter;
table 54702 "FSO CBE NACE Activity"
{
    Caption = 'CBE NACE Activity';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Company CBE No."; Code[20])
        {
            Caption = 'Company CBE No.';
            TableRelation = "FSO CBE Company"."CBE No.";
        }
        field(2; "Activity Code"; Code[20]) { Caption = 'Activity Code'; }
        field(3; "Description"; Text[200]) { Caption = 'Description'; }
        field(4; "Classification"; Text[50]) { Caption = 'Classification'; }
        field(5; "NACE Version"; Text[30]) { Caption = 'NACE Version'; }
    }

    keys
    {
        key(PK; "Company CBE No.", "Activity Code")
        {
            Clustered = true;
        }
        key(ByCompany; "Company CBE No.")
        {
        }
    }
}