namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GeneralLedger.Journal;

tableextension 50103 FSONBCGenLedSetup extends "General Ledger Setup"
{
    fields
    {
        field(50100; "Gen. Jnl. Template Safe Jrnl."; Code[10])
        {
            Caption = 'Gen. Jnl. Template Safe Jrnl.';
            TableRelation = "Gen. Journal Template".Name where("Page ID" = const(39));
            DataClassification = CustomerContent;
        }
        field(50101; "Gen. Jnl. Batch Safe Jrnl."; Code[10])
        {
            Caption = 'Gen. Jnl. Batch Safe Jrnl.';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Gen. Jnl. Template Safe Jrnl."), "Bal. Account Type" = const("G/L Account"));
            DataClassification = CustomerContent;
        }
        field(50102; "Default Shop Payment Journal"; Code[10])
        {
            Caption = 'Gen. Jnl. Batch Safe Jrnl.';
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
        }
        field(50103; "Default Shop Payment Batch"; Code[10])
        {
            Caption = 'Gen. Jnl. Batch Safe Jrnl.';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Default Shop Payment Journal"));
            DataClassification = CustomerContent;
        }
        field(50104; "Create Shop Inv DateFilter"; DateFormula)
        {
            Caption = 'Create Shop Invoices DateFilter';
            DataClassification = CustomerContent;
        }
    }
}
