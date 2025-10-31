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
            ToolTip = 'If this is set to true, the system will process differences when they occur during shop payment processing.';
            trigger OnValidate()
            begin
                if Rec."FSONBCProcess Difference" then begin
                    Rec.TestField("FSONBCMax. Difference Allowed");
                    Rec.TestField("FSONBCDifference GL A/c");
                end;
            end;
        }
        field(50107; "FSONBCMax. Difference Allowed"; Decimal)
        {
            Caption = 'Max. Difference Allowed';
            DataClassification = CustomerContent;
            ToolTip = 'Maximum difference allowed when processing the difference. If the difference exceeds this amount, it will not be processed.';
            trigger OnValidate()
            begin
                Rec."FSONBCMax. Difference Allowed" := Abs(Rec."FSONBCMax. Difference Allowed");
            end;
        }
        field(50108; "FSONBCDifference GL A/c"; Code[20])
        {
            Caption = 'Difference GL A/c';
            TableRelation = "G/L Account"."No.";
            DataClassification = CustomerContent;
            ToolTip = 'G/L Account to post the difference amount to when processing the difference.';
        }
        field(50109; "FSONBCAuto Post Journals"; Boolean)
        {
            Caption = 'Auto Post Journals';
            DataClassification = CustomerContent;
            ToolTip = 'If this is set to true, the journals will be posted automatically after the entries are created.';
        }
    }
}
