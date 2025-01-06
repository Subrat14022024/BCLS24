namespace FSO_NAVBCConnector.Shoppayment;

using Microsoft.Inventory.Location;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Account;
table 50101 "FSONBCShopPaymentEntries"
{
    Caption = 'Shop Payment Entries';
    DataClassification = CustomerContent;
    Permissions = tabledata "FSONBCShopPaymentEntries" = rmid;

    fields
    {
        field(1; "FSONBCEntry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(5; "FSONBCType"; Enum FSONBCShopPaymentType)
        {
            Caption = 'Type';
        }
        field(6; "FSONBCDate"; Date)
        {
            Caption = 'Date';
        }
        field(7; "FSONBCLocation Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(10; "FSONBCTender Type"; Code[10])
        {
            Caption = 'Tender type';
            TableRelation = "LSC Tender Type Setup".Code;
        }
        field(11; "FSONBCTender Subtype"; Code[10])
        {
            Caption = 'Tender subtype';
            TableRelation = "LSC Tender Type Card Setup"."Card No." where("Tender Type Code" = field("FSONBCTender Type"));
        }
        field(12; "FSONBCG/L Account No."; Code[20])
        {
            Caption = 'G/L account no.';
            TableRelation = "G/L Account"."No.";

        }
        field(15; "FSONBCTotal Amount Trans"; Decimal)
        {
            Caption = 'Total amount transactions';
        }
        field(20; "FSONBCExported to Sales Subs."; Boolean)
        {
            Caption = 'Exported to sales subsidiary';
        }
        field(21; "FSONBCSynchronization Date Exp"; Date)
        {
            Caption = 'Synchronization date export';
        }
        field(22; "FSONBCSynchronization Time Exp"; Time)
        {
            Caption = 'Synchronization time export';
        }
        field(23; "FSONBCSynchronization Date Imp"; Date)
        {
            Caption = 'Synchronization date import';
        }
        field(24; "FSONBCSynchronization Time Imp"; Time)
        {
            Caption = 'Synchronization time import';
        }
        field(30; "FSONBCGen. Journal Template"; Code[10])
        {
            Caption = 'Gen. journal template';
            TableRelation = "Gen. Journal Template".Name;
        }
        field(31; "FSONBCGen. Journal Batch"; Code[10])
        {
            Caption = 'Gen. journal batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("FSONBCGen. Journal Template"));
        }
        field(32; "FSONBCGen. Journal Line No."; Integer)
        {
            Caption = 'Gen. journal line no.';
        }
        field(33; "FSONBCGen. Journal Amount"; Decimal)
        {
            Caption = 'Gen. journal amount';
        }
        field(40; FSONBCProcessed; Boolean)
        {
            Caption = 'Processed';
        }
        field(41; FSONBCPosted; Boolean)
        {
            Caption = 'Posted';
        }
        field(50; "FSONBCInvoice No."; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(60; FSONBCDescription; Text[50])
        {
            Caption = 'Description';
        }
        field(61; "FSONBCType of Posting"; Enum FSONBCShopPmtTypeofPosting)
        {
            Caption = 'Type of Posting';
        }
    }
    keys
    {
        key(PK; "FSONBCEntry No.")
        {
            Clustered = true;
        }
        key(Key1; FSONBCType, FSONBCDate, "FSONBCLocation Code", "FSONBCTender Type", "FSONBCTender Subtype")
        {

        }
        key(Key2; FSONBCType, FSONBCDate, "FSONBCLocation Code", "FSONBCG/L Account No.")
        {

        }
        key(key3; FSONBCProcessed, FSONBCDate, "FSONBCLocation Code")
        {

        }

    }
}
