namespace BCLS.BCLS;

using Microsoft.Inventory.Posting;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Inventory.Journal;


codeunit 56000 "Event"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnAfterCode, '', false, false)]
    local procedure "Gen. Jnl.-Post Batch_OnAfterCode"(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean)
    var
        GeneralJournalBatch: Record "Gen. Journal Batch";
    begin
        if GeneralJournalBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then
            if GeneralJournalBatch.CODA then
                if not GenJournalLine.IsEmpty then
                    if GenJournalLine.FindSet() then
                        if GenJournalLine."Account No." = '' then
                            if GeneralJournalBatch.Delete(true) then
                                OnAfterIncrementBatchName(GeneralJournalBatch);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnAfterIncrementBatchName, '', false, false)]
    local procedure "Gen. Jnl.-Post Batch_OnAfterIncrementBatchName"(var GenJournalBatch: Record "Gen. Journal Batch"; OldBatchName: Code[10])
    begin
        OnAfterIncrementBatchName(GenJournalBatch);
    end;

    procedure OnAfterIncrementBatchName(var GenJournalBatch: Record "Gen. Journal Batch")
    begin
        GenJournalBatch.Find('=><');
    end;
}
