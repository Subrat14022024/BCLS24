table 50106 "FSOINSTBEIntrastat Purchase"
{
    Caption = 'Intrastat';
    DataClassification = ToBeClassified;
    Access = Internal;

    fields
    {
        field(50101; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No.';
        }
        field(50102; "Posted Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posted Document No.';
        }
        field(50103; "Type"; Enum "FSOINSTBEIntrastatType")
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
        }
        field(50104; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No.';
        }
        field(50105; "Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date';
        }
        field(50106; "Tariff No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tariff No.';
        }
        field(50107; "Tariff No. Description"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tariff No. Description';
        }
        field(50108; "Country Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Country Code';
        }
        field(50109; "Transaction Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transaction Type';
        }
        field(50110; "Transport Method"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transport Method';
        }
        field(50111; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';
        }
        field(50112; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity';
        }
        field(50115; "Statistical Value"; Decimal)
        {

            DataClassification = ToBeClassified;
            Caption = 'Statistical Value';
        }
        field(50117; "Total Weight"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Weight';
        }
        field(50118; "Supplementary Units"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Supplementary Units';
        }
        field(50119; "Country of Origin Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Country of Origin Code';
        }
        field(50120; "Entry Point"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry Point';
        }
        field(50121; "Area"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Area';
        }
        field(50122; "Transaction Specification"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transaction Specification';
        }
        field(50123; "Partner VAT ID"; text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Partner VAT ID';
        }
        field(50130; "Unit of Measure"; text[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit of Measure';
        }
        field(50131; "Exported to Sales Subs."; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Exported to Sales Subs.';
        }
        field(50132; "Synchronization Date Export"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Synchronization Date Export';
        }
        field(50133; "Synchronization Time Export"; Time)
        {
            DataClassification = ToBeClassified;
            Caption = 'Synchonization time export';
        }
        field(50134; "Synchronization Date Import"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Synchonization date import';
        }
        field(50135; "Synchronization Time Import"; Time)
        {
            DataClassification = ToBeClassified;
            Caption = 'Synchonization time import';
        }
        field(50140; "Processed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Processed';
        }
    }
    keys
    {
        key(PK; "Document No.", "Posted Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Pk1; "Country Code", "Date")
        {
            Clustered = false;
        }
        key(Pk2; "Exported to Sales Subs.", "Posted Document No.")
        {
            Clustered = false;
        }
    }
}