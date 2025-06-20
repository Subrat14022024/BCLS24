namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;

codeunit 50106 event2
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnBeforeShowPostResultMessage, '', false, false)]
    local procedure "GenJnlPostOnBeforeShowPostResultMessage"(var GenJnlLine: Record "Gen. Journal Line"; TempJnlBatchName: Code[10]; var IsHandled: Boolean)
    begin
        if GenJnlLine.IsTemporary then
            exit;

        this.ChangeCodaBatchAfterPosting(GenJnlLine);
    end;

    local procedure ChangeCodaBatchAfterPosting(var GenJnlLine: Record "Gen. Journal Line")
    var
        GeneralJournalBatch: Record "Gen. Journal Batch";
        GeneralJournalTemplate: Record "Gen. Journal Template";
    begin
        if GeneralJournalBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") then
            if not GeneralJournalBatch.CODA then
                exit;

        if GeneralJournalTemplate.Get(GenJnlLine."Journal Template Name") then
            if GeneralJournalTemplate.Type <> GeneralJournalTemplate.Type::Financial then
                exit;

        if this.TryGetNextBatch(GenJnlLine, GeneralJournalBatch) then begin
            GenJnlLine."Journal Batch Name" := GeneralJournalBatch.Name;
            GenJnlLine."Line No." := 1;
        end else
            if this.TryGetPreviousBatch(GenJnlLine, GeneralJournalBatch) then begin
                GenJnlLine."Journal Batch Name" := GeneralJournalBatch.Name;
                GenJnlLine."Line No." := 1;
            end else
                if this.TryGetFallbackBatch(GenJnlLine, GeneralJournalBatch) then begin
                    GenJnlLine."Journal Batch Name" := GeneralJournalBatch.Name;
                    GenJnlLine."Line No." := 1;
                end;
    end;

    local procedure TryGetNextBatch(GenJnlLine: Record "Gen. Journal Line"; var FoundBatch: Record "Gen. Journal Batch"): Boolean
    begin
        FoundBatch.Reset();
        FoundBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
        FoundBatch.SetLoadFields(CODA);
        FoundBatch.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        FoundBatch.SetFilter(Name, '>%1', GenJnlLine."Journal Batch Name");
        FoundBatch.SetRange(CODA, true);
        exit(FoundBatch.FindFirst());
    end;

    local procedure TryGetPreviousBatch(GenJnlLine: Record "Gen. Journal Line"; var FoundBatch: Record "Gen. Journal Batch"): Boolean
    begin
        FoundBatch.Reset();
        FoundBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
        FoundBatch.SetLoadFields(CODA);
        FoundBatch.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        FoundBatch.SetFilter(Name, '<%1', GenJnlLine."Journal Batch Name");
        FoundBatch.SetRange(CODA, true);
        exit(FoundBatch.FindLast());
    end;

    local procedure TryGetFallbackBatch(GenJnlLine: Record "Gen. Journal Line"; var FoundBatch: Record "Gen. Journal Batch"): Boolean
    begin
        FoundBatch.Reset();
        FoundBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
        FoundBatch.SetLoadFields(CODA);
        FoundBatch.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        FoundBatch.SetRange(CODA, false);
        exit(FoundBatch.FindFirst());
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnCodeOnAfterGenJnlPostBatchRun, '', false, false)]
    local procedure GenJnlPostOnCodeOnAfterGenJnlPostBatchRun(var GenJnlLine: Record "Gen. Journal Line")
    var
    begin
        if GenJnlLine.IsTemporary then
            exit;

        this.DeleteTempCodaBatch(GenJnlLine)
    end;

    local procedure DeleteTempCodaBatch(var GenJnlLine: Record "Gen. Journal Line")
    var
        GeneralJournalBatch: Record "Gen. Journal Batch";
    begin
        GeneralJournalBatch.SetLoadFields("CODA");
        GeneralJournalBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
        if GeneralJournalBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") then
            if GeneralJournalBatch.CODA then
                GeneralJournalBatch.Delete(true);
    end;
}
