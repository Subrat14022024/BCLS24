namespace FINBC.FINBC;

using Microsoft.Finance.GeneralLedger.Journal;

tableextension 50127 GenJnlBatchExtn extends "Gen. Journal Batch"
{
    fields
    {
        field(50101; CODA; Boolean)
        {
            Caption = 'CODA';
            DataClassification = ToBeClassified;
        }
        field(50102; "Statement Ending Balance"; Decimal)
        {
            Caption = 'Statement Ending Balance';
            DataClassification = ToBeClassified;
        }
        field(50103; "Balance Last Statement"; Decimal)
        {
            Caption = 'Balance Last Statement';
            DataClassification = ToBeClassified;
        }
    }
}
