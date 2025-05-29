namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.Dimension;

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
            if GenJnlLine.IsEmpty then
                if GeneralJournalBatch.CODA then
                    GeneralJournalBatch.Delete();
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnBeforeCode, '', false, false)]
    // local procedure "Gen. Jnl.-Post_OnBeforeCode"(var HideDialog: Boolean)
    // begin
    //     if GuiAllowed then
    //         HideDialog := true;
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Dimension Set Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure MyProcedure(var Rec: Record "Dimension Set Entry" temporary)
    var
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimensionValue: Record "Dimension Value";
        GLSetUp: Record "General Ledger Setup";
    begin
        GLSetUp.get();
        if DimensionValue.Get(Rec."Dimension Code", Rec."Dimension Value Code") then begin
            TempDimensionSetEntry.Init();
            TempDimensionSetEntry."Dimension Code" := GLSetUp."Shortcut Dimension 5 Code";
            TempDimensionSetEntry."Dimension Value Code" := DimensionValue.Entity;
            if not TempDimensionSetEntry.Insert(true) then
                TempDimensionSetEntry.Modify(true);
        end;
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Dimension Set Entry", 'OnAfterInsertEvent', '', false, false)]
    // local procedure MyProcedure1(var Rec: Record "Dimension Set Entry")
    // var
    //     DimensionSetEntry: Record "Dimension Set Entry";
    //     DimensionValue: Record "Dimension Value";
    //     GLSetUp: Record "General Ledger Setup";
    //     DimMgt: Codeunit DimensionManagement;
    // begin
    //     GLSetUp.Get();
    //     if DimensionValue.Get(Rec."Dimension Code", Rec."Dimension Value Code") then
    //         if not DimensionSetEntry.Get(Rec."Dimension Set ID", Rec."Dimension Code") then begin
    //             DimensionSetEntry.Init();
    //             DimensionSetEntry."Dimension Set ID" := DimMgt.GetDimensionSetID(Rec);
    //             DimensionSetEntry.Validate("Dimension Code", GLSetUp."Shortcut Dimension 5 Code");
    //             DimensionSetEntry.Validate("Dimension Value Code", DimensionValue.Entity);
    //             DimensionSetEntry.Validate("Global Dimension No.", Rec.GetGlobalDimNo());
    //             if DimensionSetEntry.Insert(true) then
    //                 DimensionSetEntry.Modify(true);
    //         end;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, OnBeforeEditDimensionSet2, '', false, false)]
    // local procedure DimensionManagement_OnBeforeEditDimensionSet2(DimSetID: Integer; NewCaption: Text[250]; var GlobalDimVal1: Code[20]; var GlobalDimVal2: Code[20]; var NewDimSetID: Integer; var IsHandled: Boolean; RecVariant: Variant)
    // var
    // RecRef : RecordRef;
    // begin
    //     if RecVariant.IsRecord then
    //         RecRef.GetTable(RecVariant);
    //         RecRef.tra
    // end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, OnGetDefaultDimIDOnBeforeFindNewDimSetIDProcedure, '', false, false)]
    local procedure DimensionManagement_OnGetDefaultDimIDOnBeforeFindNewDimSetIDProcedure(var TempDimensionBuffer: Record "Dimension Buffer" temporary; DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]; var GlobalDim1Code: Code[20]; var GlobalDim2Code: Code[20]; SourceCode: Code[20]; GLSetupShortcutDimCode: array[8] of Code[20]; var TempDimensionSetEntry0: Record "Dimension Set Entry" temporary; InheritFromDimSetID: Integer; InheritFromTableNo: Integer)
    var
        GLSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
    begin
        GLSetup.Get();
        if TempDimensionBuffer."Dimension Code" = GLSetup."Shortcut Dimension 1 Code" then
            if DimensionValue.Get(TempDimensionBuffer."Dimension Code", TempDimensionBuffer."Dimension Value Code") then
                InsertTempDimBufEntry(TempDimensionBuffer, InheritFromTableNo, 0, GLSetup."Shortcut Dimension 5 Code", DimensionValue.Entity)
    end;


    local procedure InsertTempDimBufEntry(var TempDimBuf: Record "Dimension Buffer" temporary; TableId: Integer; EntryNo: Integer; DimCode: Code[20]; DimValueCode: Code[20])
    begin
        TempDimBuf.Init();
        TempDimBuf."Table ID" := TableId;
        TempDimBuf."Entry No." := EntryNo;
        TempDimBuf."Dimension Code" := DimCode;
        TempDimBuf."Dimension Value Code" := DimValueCode;
        TempDimBuf.Insert();
    end;


}
