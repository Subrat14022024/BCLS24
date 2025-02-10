table 50109 "TCOGINGL Intrastat Report Line"
{
    Caption = 'Intrastat Report Line';

    fields
    {
        field(1; "GUID entry No."; Guid)
        {
            Caption = 'GUID entry No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Type; Enum Microsoft.Inventory.Intrastat."Intrastat Report Line Type")
        {
            Caption = 'Type';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; "Tariff No."; Code[20])
        {
            Caption = 'Tariff No.';
        }
        field(6; "Tariff Description"; Text[250])
        {
            Caption = 'Tariff Description';
        }
        field(7; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
        }
        field(8; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
        }
        field(9; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
        }
        field(10; "Source Type"; Enum Microsoft.Inventory.Intrastat."Intrastat Report Source Type")
        {
            Caption = 'Source Type';
        }
        field(11; "Source Entry No."; Integer)
        {
            Caption = 'Source Entry No.';
        }
        field(12; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(14; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(15; "Cost Regulation %"; Decimal)
        {
            Caption = 'Cost Regulation %';
        }
        field(16; "Indirect Cost"; Decimal)
        {
            Caption = 'Indirect Cost';
        }
        field(17; "Statistical Value"; Decimal)
        {
            Caption = 'Statistical Value';
        }
        field(18; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(19; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(20; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
        }
        field(21; "Total Weight"; Decimal)
        {
            Caption = 'Total Weight';
        }
        field(22; "Supplementary Units"; Boolean)
        {
            Caption = 'Supplementary Units';
        }
        field(23; "Internal Ref. No."; Text[10])
        {
            Caption = 'Internal Ref. No.';
        }
        field(24; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
        }
        field(25; "Entry/Exit Point"; Code[10])
        {
            Caption = 'Entry/Exit Point';
        }
        field(26; "Area"; Code[10])
        {
            Caption = 'Area';
        }
        field(27; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
        }
        field(28; "Shpt. Method Code"; Code[10])
        {
            Caption = 'Shpt. Method Code';
        }
        field(29; "Partner VAT ID"; Text[50])
        {
            Caption = 'VAT Reg. No.';
        }
        field(30; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(31; Counterparty; Boolean)
        {
            Caption = 'Counterparty';
        }
        field(32; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(33; "Suppl. Conversion Factor"; Decimal)
        {
            Caption = 'Supplementary Unit Conversion Factor';
        }
        field(34; "Suppl. Unit of Measure"; Text[10])
        {
            Caption = 'Supplementary Unit of Measure';
        }
        field(35; "Supplementary Quantity"; Decimal)
        {
            Caption = 'Supplementary Quantity';
        }
        field(36; "Statistical System"; Enum Microsoft.Inventory.Intrastat."Intrastat Report Stat. System")
        {
            Caption = 'Statistical System';
        }
        field(37; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(38; "Source Currency Amount"; Decimal)
        {
            Caption = 'Source Currency Amount';
        }
        field(39; "Corrective entry"; Boolean)
        {
            Caption = 'Corrective entry';
        }
        field(40; "Group Code"; Code[10])
        {
            Caption = 'Group Code';
        }
        field(41; "Statistics Period"; Code[10])
        {
            Caption = 'Statistics Period';
        }
        field(42; "Reference Period"; Code[10])
        {
            Caption = 'Reference Period';
        }
        field(43; "Payment Method"; Code[10])
        {
            Caption = 'Payment Method';
        }
        field(44; "Corrected Intrastat Report No."; Code[20])
        {
            Caption = 'Corrected Intrastat Report No.';
        }
        field(45; "Country/Region of Payment Code"; Code[10])
        {
            Caption = 'Country/Region of Payment Code';
        }
        field(46; "Progressive No."; Code[5])
        {
            Caption = 'Progressive No.';
        }
        field(47; "Obligation Level"; Code[20])
        {
            Caption = 'Obligation Level';
        }
        field(48; "Corrected Document No."; Code[20])
        {
            Caption = 'Corrected Document No.';
        }
        field(100; "Record ID Filter"; Text[250])
        {
        }
        field(80535; "Pre Record Id"; RecordId)
        {
        }
        field(80536; "Post Record Id"; RecordId)
        {
        }
        field(80537; Processed; Boolean)
        {
        }
        field(80538; "Created by User Id"; Text[100])
        {
        }
        field(80539; "Modified by User Id"; Text[100])
        {
        }
    }
    keys
    {
        key(Key1; "GUID entry No.", "Line No.")
        {
        }
        key(Key2; "Source Type", "Source Entry No.")
        {
        }
        key(Key3; "Document No.")
        {
        }
        key(Key4; "GUID entry No.", Type, "Internal Ref. No.")
        {
        }
        key(Key5; "GUID entry No.", Type, "Country/Region Code", "Tariff No.", "Transaction Type", "Transport Method", "Country/Region of Origin Code", "Partner VAT ID")
        {
        }
        key(Key6; "GUID entry No.", Type, "Country/Region Code", "Tariff No.", "Transaction Type", "Transport Method", "Area", "Transaction Specification", "Country/Region of Origin Code", "Partner VAT ID")
        {
        }
        key(Key7; "GUID entry No.", Type, "Country/Region Code", "Tariff No.", "Transaction Type", "Transport Method", "Transaction Specification", "Area", "Country/Region of Origin Code", "Partner VAT ID")
        {
        }
        key(Key8; Type, "Country/Region Code", "Partner VAT ID", "Transaction Type", "Tariff No.", "Group Code", "Transport Method", "Transaction Specification", "Country/Region of Origin Code", "Area", "Corrective entry")
        {
        }
        key(Key9; "GUID entry No.", Type)
        {
        }
        key(Key10; "Partner VAT ID", "Transaction Type", "Tariff No.", "Group Code", "Transport Method", "Transaction Specification", "Country/Region of Origin Code", "Area", "Corrective entry")
        {
        }
    }
}