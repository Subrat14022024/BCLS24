namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50108 GeneraljournalBatchExt extends "General Journal Batches"
{
    layout
    {
        addafter("Bal. Account Type")
        {
            field(CODA; Rec.CODA)
            {
                ApplicationArea = all;
                ToolTip = 'dslkdj';
            }
        }
    }
}
