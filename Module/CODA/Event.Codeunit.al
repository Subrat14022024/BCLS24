namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;

codeunit 56000 "Event"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnBeforeShowPostResultMessage, '', false, false)]
    local procedure "Gen. Jnl.-Post_OnBeforeShowPostResultMessage"(var GenJnlLine: Record "Gen. Journal Line"; TempJnlBatchName: Code[10]; var IsHandled: Boolean)
    var
        GeneralJournalBatch: Record "Gen. Journal Batch";
        GeneralJournalTemplate: Record "Gen. Journal Template";
    begin
        if GeneralJournalTemplate.Get(GenJnlLine."Journal Template Name") then
            if GeneralJournalTemplate.Type <> GeneralJournalTemplate.Type::Financial then
                exit;
        GeneralJournalBatch.Setrange("Template Type", GeneralJournalBatch."Template Type"::Financial);
        GeneralJournalBatch.SetRange(CODA, true);
        if GeneralJournalBatch.FindLast() then begin
            TempJnlBatchName := GeneralJournalBatch.Name;
            if GenJnlLine.IsEmpty then begin
                GenJnlLine."Journal Batch Name" := GeneralJournalBatch.Name;
                GenJnlLine."Line No." := 1;
            end
        end else begin
            GeneralJournalBatch.SetRange(CODA);
            if GeneralJournalBatch.FindLast() then
                TempJnlBatchName := GeneralJournalBatch.Name;
            if GenJnlLine.IsEmpty then begin
                GenJnlLine."Journal Batch Name" := GeneralJournalBatch.Name;
                GenJnlLine."Line No." := 1;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnCodeOnAfterGenJnlPostBatchRun, '', false, false)]
    local procedure "Gen. Jnl.-Post_OnCodeOnAfterGenJnlPostBatchRun"(var GenJnlLine: Record "Gen. Journal Line")
    var
        GeneralJournalBatch: Record "Gen. Journal Batch";
    begin
        if GeneralJournalBatch.get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") then
            if GeneralJournalBatch.CODA then
                GeneralJournalBatch.Delete();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnBeforeCode, '', false, false)]
    local procedure "Gen. Jnl.-Post_OnBeforeCode"(var HideDialog: Boolean)
    begin
        if GuiAllowed then
            HideDialog := true;
    end;


}
