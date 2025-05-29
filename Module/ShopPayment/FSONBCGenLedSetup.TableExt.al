namespace FSO_NAVBCConnector.Shoppayment;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Account;

tableextension 50103 FSONBCGenLedSetup extends "General Ledger Setup"
{
    fields
    {
        field(50100; "FSONBCGenJnlTemplate Safe Jrnl"; Code[10])
        {
            Caption = 'Gen. Jnl. Template Safe Jrnl.';
            TableRelation = "Gen. Journal Template".Name where("Page ID" = const(39));
            DataClassification = CustomerContent;
        }
        field(50101; "FSONBCGenJnlBatch Safe Jrnl."; Code[10])
        {
            Caption = 'Gen. Jnl. Batch Safe Jrnl.';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("FSONBCGenJnlTemplate Safe Jrnl"), "Bal. Account Type" = const("G/L Account"));
            DataClassification = CustomerContent;
        }
        field(50102; "FSONBCDefault Shop Pmt. Jrnl"; Code[10])
        {
            Caption = 'Default Shop Payment Journal';
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
        }
        field(50103; "FSONBCDefault Shop Pmt. Batch"; Code[10])
        {
            Caption = 'Default Shop Payment Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("FSONBCDefault Shop Pmt. Jrnl"));
            DataClassification = CustomerContent;
        }
        field(50104; "FSONBCCreate Shop Inv DFilter"; DateFormula)
        {
            Caption = 'Create Shop Invoices DateFilter';
            DataClassification = CustomerContent;
        }
        field(50106; "FSONBCProcess Difference"; Boolean)
        {
            Caption = 'Process Difference';
            DataClassification = CustomerContent;
        }
        field(50107; "FSONBCMax. Difference Allowed"; Decimal)
        {
            Caption = 'Max. Difference Allowed';
            DataClassification = CustomerContent;
        }
        field(50108; "FSONBCDifference GL A/c"; Code[20])
        {
            Caption = 'Difference GL A/c';
            TableRelation = "G/L Account"."No.";
            DataClassification = CustomerContent;
        }
        field(50109; "FSONBCAuto Post Journals"; Boolean)
        {
            Caption = 'Auto Post Journals';
            DataClassification = CustomerContent;
        }
    }
}
