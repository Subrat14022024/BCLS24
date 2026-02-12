namespace BlankVAT.CBEImporter;
table 54700 "FSO CBE Company"
{
    Caption = 'CBE Company';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Guid; Guid)
        {
            Caption = 'GUID';
            DataClassification = SystemMetadata;
        }
        field(2; "Search Name"; Text[250])
        {
            Caption = 'Search Name';
        }
        field(3; "Search City"; Text[100])
        {
            Caption = 'Search City';
        }
        field(4; "Search Post Code"; Text[50])
        {
            Caption = 'Search Post Code';
        }
        field(5; "CBE No."; Code[20])
        {
            Caption = 'CBE Number';
        }
        field(6; "CBE No. Formatted"; Text[30])
        {
            Caption = 'CBE Number Formatted';
        }
        field(7; "Denomination"; Text[100])
        {
            Caption = 'Denomination';
        }
        field(8; "Denomination With Legal Form"; Text[120])
        {
            Caption = 'Denomination With Legal Form';
        }
        field(9; "Juridical Form"; Text[80])
        {
            Caption = 'Juridical Form';
        }
        field(10; "Juridical Form Code"; Text[20])
        {
            Caption = 'Juridical Form Code';
        }
        field(11; "Status"; Text[50])
        {
            Caption = 'Status';
        }
        field(12; "Juridical Situation"; Text[120])
        {
            Caption = 'Juridical Situation';
        }
        field(13; "Type"; Text[30])
        {
            Caption = 'Type';
        }
        field(14; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }

        // Primary address fields (from "address")
        field(20; "Street"; Text[100]) { Caption = 'Street'; }
        field(21; "House No."; Text[30]) { Caption = 'House No.'; }
        field(22; "Box"; Text[20]) { Caption = 'Box'; }
        field(23; "Post Code"; Text[20]) { Caption = 'Post Code'; }
        field(24; "City"; Text[60]) { Caption = 'City'; }
        field(25; "Country Code"; Code[10]) { Caption = 'Country Code'; }
        field(26; "Full Address"; Text[250]) { Caption = 'Full Address'; }

        // Contact info
        field(30; "Email"; Text[100]) { Caption = 'Email'; }
        field(31; "Phone"; Text[50]) { Caption = 'Phone'; }
        field(32; "Web"; Text[150]) { Caption = 'Web'; }

        // Metadata / audit
        field(9900; "Source JSON"; Text[250]) { Caption = 'Source JSON'; }
    }

    keys
    {
        key(PK; Guid)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        Guid := CreateGuid();
    end;
}