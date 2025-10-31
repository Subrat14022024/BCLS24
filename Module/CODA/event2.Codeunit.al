namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.FixedAssets.FixedAsset;

codeunit 50106 event2
{
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnBeforeShowPostResultMessage, '', false, false)]
    // local procedure "GenJnlPostOnBeforeShowPostResultMessage"(var GenJnlLine: Record "Gen. Journal Line"; TempJnlBatchName: Code[10]; var IsHandled: Boolean)
    // begin
    //     if GenJnlLine.IsTemporary then
    //         exit;

    //     this.ChangeCodaBatchAfterPosting(GenJnlLine);
    // end;

    // local procedure ChangeCodaBatchAfterPosting(var GenJnlLine: Record "Gen. Journal Line")
    // var
    //     GeneralJournalBatch: Record "Gen. Journal Batch";
    //     GeneralJournalTemplate: Record "Gen. Journal Template";
    // begin
    //     if GeneralJournalBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") then
    //         if not GeneralJournalBatch.CODA then
    //             exit;

    //     if GeneralJournalTemplate.Get(GenJnlLine."Journal Template Name") then
    //         if GeneralJournalTemplate.Type <> GeneralJournalTemplate.Type::Financial then
    //             exit;

    //     if this.TryGetNextBatch(GenJnlLine, GeneralJournalBatch) then begin
    //         GenJnlLine."Journal Batch Name" := GeneralJournalBatch.Name;
    //         GenJnlLine."Line No." := 1;
    //     end else
    //         if this.TryGetPreviousBatch(GenJnlLine, GeneralJournalBatch) then begin
    //             GenJnlLine."Journal Batch Name" := GeneralJournalBatch.Name;
    //             GenJnlLine."Line No." := 1;
    //         end else
    //             if this.TryGetFallbackBatch(GenJnlLine, GeneralJournalBatch) then begin
    //                 GenJnlLine."Journal Batch Name" := GeneralJournalBatch.Name;
    //                 GenJnlLine."Line No." := 1;
    //             end;
    // end;

    // local procedure TryGetNextBatch(GenJnlLine: Record "Gen. Journal Line"; var GeneralJournalBatch: Record "Gen. Journal Batch"): Boolean
    // begin
    //     //GeneralJournalBatch.Reset();
    //     GeneralJournalBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
    //     GeneralJournalBatch.SetLoadFields(CODA);
    //     GeneralJournalBatch.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
    //     GeneralJournalBatch.SetFilter(Name, '>%1', GenJnlLine."Journal Batch Name");
    //     GeneralJournalBatch.SetRange(CODA, true);
    //     exit(GeneralJournalBatch.FindFirst());
    // end;

    // local procedure TryGetPreviousBatch(GenJnlLine: Record "Gen. Journal Line"; var GeneralJournalBatch: Record "Gen. Journal Batch"): Boolean
    // begin
    //     //GeneralJournalBatch.Reset();
    //     GeneralJournalBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
    //     GeneralJournalBatch.SetLoadFields(CODA);
    //     GeneralJournalBatch.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
    //     GeneralJournalBatch.SetFilter(Name, '<%1', GenJnlLine."Journal Batch Name");
    //     GeneralJournalBatch.SetRange(CODA, true);
    //     exit(GeneralJournalBatch.FindLast());
    // end;

    // local procedure TryGetFallbackBatch(GenJnlLine: Record "Gen. Journal Line"; var GeneralJournalBatch: Record "Gen. Journal Batch"): Boolean
    // begin
    //     //GeneralJournalBatch.Reset();
    //     GeneralJournalBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
    //     GeneralJournalBatch.SetLoadFields(CODA);
    //     GeneralJournalBatch.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
    //     GeneralJournalBatch.SetRange(CODA, false);
    //     exit(GeneralJournalBatch.FindFirst());
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnCodeOnAfterGenJnlPostBatchRun, '', false, false)]
    // local procedure GenJnlPostOnCodeOnAfterGenJnlPostBatchRun(var GenJnlLine: Record "Gen. Journal Line")
    // var
    // begin
    //     if GenJnlLine.IsTemporary then
    //         exit;

    //     this.DeleteTempCodaBatch(GenJnlLine)
    // end;

    // local procedure DeleteTempCodaBatch(var GenJnlLine: Record "Gen. Journal Line")
    // var
    //     GeneralJournalBatch: Record "Gen. Journal Batch";
    // begin
    //     GeneralJournalBatch.SetLoadFields("CODA");
    //     GeneralJournalBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
    //     if GeneralJournalBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") then
    //         if GeneralJournalBatch.CODA then
    //             GeneralJournalBatch.Delete(true);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnGenJnlLineSetFilter, '', false, false)]
    // local procedure "Gen. Jnl.-Post_OnGenJnlLineSetFilter"(var GenJournalLine: Record "Gen. Journal Line")
    // begin
    //     if GenJournalLine.IsTemporary then
    //         exit;

    //     GenJournalLine.Reset();
    //     //Message('Batch :%1\n Template :%2\n GetLastErrorText-%3 \n GetLastErrorCallStack-%4', GenJournalLine."Journal Batch Name", GenJournalLine."Journal Template Name", GetLastErrorText(), GetLastErrorCallStack);
    // end;

    // [EventSubscriber(ObjectType::Page, Page::"Financial Journal", 'OnOpenPageEvent', '', false, false)]
    // local procedure "FinancialJournal_OnOpenPageEvent"(var rec: Record "Gen. Journal Line")
    // begin
    //     // Add your event handling code here if needed
    // end;


}
