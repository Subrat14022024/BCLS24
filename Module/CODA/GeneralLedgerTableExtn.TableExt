tableextension 50106 "General Ledger TableExtn" extends "General Ledger Setup"
{
    fields
    {
        field(50001; "CODA Import Folder"; Text[250])
        {
            Caption = 'CODA Import Folder';
            DataClassification = ToBeClassified;
        }
        field(50002; "CODA Archive Folder"; Text[250])
        {
            Caption = 'CODA Archive Folder';
            DataClassification = ToBeClassified;
        }
        field(50003; "CODA ERROR Folder"; Text[250])
        {
            Caption = 'CODA ERROR Folder';
            DataClassification = ToBeClassified;
        }
        field(50004; "File Share Name"; Code[20])
        {
            Caption = 'File Share Name';
            DataClassification = ToBeClassified;
            TableRelation = "FSOINTAzure File Service Setup".FileShareName;
        }
    }
}
