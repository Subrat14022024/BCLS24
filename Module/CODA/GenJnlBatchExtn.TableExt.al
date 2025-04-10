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
    }
}
