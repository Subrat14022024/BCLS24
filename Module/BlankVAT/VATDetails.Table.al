namespace BlankVAT.CBEImporter;
table 54706 "VAT Details"
{
    Caption = 'VAT Details';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Search Name"; Text[250])
        {
            Caption = 'Search Name';
        }
        field(2; "Search City"; Text[100])
        {
            Caption = 'Search City';
        }
        field(3; "Search Post Code"; Text[50])
        {
            Caption = 'Search Post Code';
        }
        field(4; "Data Fetched"; Boolean)
        {
            Caption = 'Data Fetched';
        }
        field(5; "Full Address"; Text[250])
        {
            Caption = 'Full Address';
        }
    }
    keys
    {
        key(PK; "search Name", "Search City", "Search Post Code", "Full Address")
        {
            Clustered = true;
        }
    }
}
