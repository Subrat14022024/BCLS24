namespace BCLS.BCLS;

using Microsoft.Pricing.PriceList;

table 50507 "Price List Sync Setup"
{
    Caption = 'Price List Sync Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Source Price List Code"; Code[20])
        {
            Caption = 'Source Price List Code';
            TableRelation = "Price List Header"."Code";
            trigger OnValidate()
            var
                Header: Record "Price List Header";
            begin
                if ("Source Price List Code" <> '') and not Header.Get("Source Price List Code") then
                    Error('Price List %1 does not exist.', "Source Price List Code");
            end;
        }
        field(2; "Target Price List Code"; Code[20])
        {
            Caption = 'Target Price List Code';
            TableRelation = "Price List Header"."Code";
            trigger OnValidate()
            var
                Header: Record "Price List Header";
            begin
                if ("Target Price List Code" <> '') and not Header.Get("Target Price List Code") then
                    Error('Price List %1 does not exist.', "Target Price List Code");
            end;
        }
        field(3; Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = SystemMetadata;
            InitValue = true;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Optional description of the synchronization rule';
        }
    }

    keys
    {
        key(PK; "Source Price List Code", "Target Price List Code")
        {
            Clustered = true;
        }
    }
}