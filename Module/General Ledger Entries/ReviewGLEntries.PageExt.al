namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Review;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.GeneralLedger.Account;

pageextension 50117 "Review G/L Entries" extends "Review G/L Entries"
{
    DataCaptionExpression = FSOGetCaption();
    layout
    {
        addfirst(Overview)
        {
            field(Selected; Rec."FOS Selected")
            {
                ApplicationArea = All;

            }
            field("Selected By User"; Rec."FSO Selected By User")
            {
                ApplicationArea = All;
            }
        }
        modify(Debit)
        {
            Visible = false;
        }
        modify(Credit)
        {
            Visible = false;
        }
        modify(Balance)
        {
            Visible = false;
        }
        addfirst(CalculatedFields)
        {
            field(FSODebit; FSODebit)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Debit (LCY)';
                Editable = false;
                ToolTip = 'Specifies the accumulated debit amount of all the lines applied to this line.';
            }
            field(FSOCredit; FSOCredit)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Credit (LCY)';
                Editable = false;
                ToolTip = 'Specifies the accumulated credit amount of all the lines applied to this line.';
            }
            field(FSOBalance; FSOBalance)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Balance';
                Editable = false;
                ToolTip = 'Specifies the accumulated balance of all the lines applied to this line.';
                AboutTitle = 'About Balance?';
                AboutText = 'Based on the selected records, the balance displays the sum of debit and credit';
            }
        }
    }
    actions
    {
        modify(SetSelectedAsReviewed)
        {
            Visible = false;
            Enabled = false;
        }
        modify(SetSelectedAsNotReviewed)
        {
            Visible = false;
            Enabled = false;
        }

        addfirst(Processing)
        {
            action(FSOSetSelectedAsReviewed)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set selected as reviewed';
                Enabled = ReviewPolicy <> "G/L Account Review Policy"::None;
                Image = SelectLineToApply;
                ShortCutKey = 'F9';
                ToolTip = 'This action can only be selected when the G/L Account''s Review Policy is either "Review Allowed" or "Review Allowed and Match Balance". For selected G/L Entries, field Reviewer is set to the current user, field Review Status is set to Reviewed, field Reviewed On is set to current date, field Review Id is to a number which all the marked entries share';
                AboutTitle = 'About review and unreview entries';
                AboutText = 'Set selected as reviewed updates the fields related to reviews and marks the entry as reviewed, set selected as not reviewed clears these fields';
                trigger OnAction()
                begin
                    FSOSetSelectedRecordsAsReviewed();
                end;
            }
            action(FSOSetSelectedAsNotReviewed)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set selected as not reviewed';
                Enabled = ReviewPolicy <> "G/L Account Review Policy"::None;
                Image = SelectLineToApply;
                ShortCutKey = 'F10';
                ToolTip = 'This action can only be selected when the G/L Account''s Review Policy is either "Review Allowed" or "Review Allowed and Match Balance". For selected G/L Entries, field Reviewer is set to blank, field Review Status is set to Not Reviewed, field Reviewed On is set to blank, field Review Id is to blank';
                trigger OnAction()
                begin
                    FSOSetSelectedRecordsAsNotReviewed();
                end;
            }
            action(SelectDeselect)
            {
                ApplicationArea = All;
                Caption = 'Select/Deselect';
                Image = SelectMore;
                ToolTip = 'Select G/L Entries for further processing.';
                ShortcutKey = 'F7';
                trigger OnAction()
                begin
                    ToggleGLEntrySelection();
                end;
            }
            action(DeselectAll)
            {
                ApplicationArea = All;
                Caption = 'Deselect All';
                Image = RemoveFilterLines;
                ToolTip = 'Deselect G/L Entries.';
                trigger OnAction()
                begin
                    DeselectAllGLEntries();
                end;
            }
        }
        addfirst(Promoted)
        {
            actionref(FSOSetSelectedAsReviewed_Promoted; FSOSetSelectedAsReviewed)
            {
            }
            actionref(FSOSetSelectedAsNotReviewed_Promoted; FSOSetSelectedAsNotReviewed)
            {
            }
            actionref(Select_Promoted; Selectdeselect)
            {
            }
            actionref(Deselectall_Promoted; Deselectall)
            {
            }
        }
    }
    trigger OnOpenPage()
    var
        GLEntry: Record "G/L Entry";
        GLEntryReviewSetup: Record "G/L Entry Review Setup";
        InitialRecordsLoaded: Text;
    begin
        GLEntryReviewSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        GLEntryReviewSetup.SetLoadFields(GLEntryReviewer);
        GLEntryReviewSetup.Get();
        GLEntryReviewer := GLEntryReviewSetup.GLEntryReviewer;
        InitialRecordsLoaded := Rec.GetView();
        GLEntry.Reset();
        GLEntry.SetView(InitialRecordsLoaded);
        GLEntry.SetRange(Reviewed, false);
        CurrPage.SetTableView(GLEntry);
    end;

    local procedure FSOSetSelectedRecordsAsNotReviewed()
    var
        GLEntry: record "G/L Entry";
    begin
        SelectedGLEntries(GLEntry);
        GLEntryReviewer.UnreviewEntries(GLEntry);
        UnSelectGLEntries();
    end;

    local procedure FSOSetSelectedRecordsAsReviewed()
    var
        GLEntry: Record "G/L Entry";
    begin
        SelectedGLEntries(GLEntry);
        Message('%1', GLEntry.Count());
        GLEntryReviewer.ReviewEntries(GLEntry);
        UnSelectGLEntries();
    end;

    local procedure UnSelectGLEntries()
    var
        GLEntryToUpdate: record "G/L Entry";
    begin
        GLEntryToUpdate.SetRange("FSO Selected By User", CopyStr(UserId(), 1, MaxStrLen(Rec."FSO Selected By User")));
        GLEntryToUpdate.SetRange("FOS Selected", true);
        if GLEntryToUpdate.FindSet(true) then
            repeat
                GLEntryToUpdate."FOS Selected" := false;
                GLEntryToUpdate."FSO Selected By User" := '';
                GLEntryToUpdate.Modify(true);
            until GLEntryToUpdate.Next() = 0;
    end;

    local procedure SelectedGLEntries(var GLEntry: record "G/L Entry")
    begin
        GLEntry.SetRange("FOS Selected", true);
        GLEntry.SetRange("FSO Selected By User", CopyStr(UserId(), 1, MaxStrLen(Rec."FSO Selected By User")));
    end;

    local procedure DeSelectAllGLEntries()
    var
        GLE: Record "G/L Entry";
        InitialRecordsLoaded: Text;
    begin
        InitialRecordsLoaded := Rec.GetView();
        UnSelectGLEntries();
        GLE.Reset();
        GLE.SetView(InitialRecordsLoaded);
        GLE.SetRange(Reviewed, false);
        CurrPage.SetTableView(GLE);
        CurrPage.Update(false);
    end;

    local procedure ToggleGLEntrySelection()
    var
        GLEntry: Record "G/L Entry";
        InitialRecordsLoaded: Text;
    begin
        InitialRecordsLoaded := Rec.GetView();
        CurrPage.SetSelectionFilter(GLEntry);

        if GLEntry.FindSet() then
            repeat
                if (GLEntry."FSO Selected By User" <> '') and (GLEntry."FSO Selected By User" <> CopyStr(UserId(), 1, MaxStrLen(GLEntry."FSO Selected By User"))) then
                    Error('G/L Entries already selected by user: %1', GLEntry."FSO Selected By User");
                if GLEntry."FOS Selected" then
                    GLEntry."FOS Selected" := false
                else
                    GLEntry."FOS Selected" := true;
                if not GLEntry."FOS Selected" then
                    GLEntry."FSO Selected By User" := ''
                else
                    GLEntry."FSO Selected By User" := CopyStr(UserId(), 1, MaxStrLen(GLEntry."FSO Selected By User"));
                GLEntry.Modify();
            until GLEntry.Next() = 0;

        GLEntry.Reset();
        GLEntry.SetRange(Reviewed, false);
        CurrPage.SetTableView(GLEntry);
        CurrPage.Update(false);
    end;

    local procedure FSOCalcAmount()
    var
        GLEntry: Record "G/L Entry";
    begin
        FSOBalance := 0;
        FSODebit := 0;
        FSOCredit := 0;
        SelectedGLEntries(GLEntry);
        GLEntry.CalcSums("Debit Amount", "Credit Amount");
        FSODebit := GLEntry."Debit Amount";
        FSOCredit := GLEntry."Credit Amount";
        FSOBalance := FSOCredit - FSODebit;
        CurrPage.Update(false);
    end;

    local procedure FSOGetCaption(): Text[250]
    var
        GLAccount: record "G/L Account";
        CaptionLbl: Label '%1 %2', Comment = '%1 is the G/L Account No. and %2 is the G/L Account Name';
    begin
        GLAccount.ReadIsolation(IsolationLevel::ReadUncommitted);
        GLAccount.SetLoadFields("No.", Name, "Review Policy");
        if not GLAccount.Get(Rec."G/L Account No.") then
            if Rec.GetFilter(Rec."G/L Account No.") <> '' then
                GLAccount.Get(Rec.GetRangeMin(Rec."G/L Account No."));
        ReviewPolicy := GLAccount."Review Policy";
        exit(StrSubstNo(CaptionLbl, GLAccount."No.", GLAccount.Name));
    end;

    trigger OnAfterGetCurrRecord()
    begin
        FSOCalcAmount();
    end;

    var
        ReviewPolicy: Enum "Review Policy Type";
        GLEntryReviewer: Interface "G/L Entry Reviewer";
        FSODebit: Decimal;
        FSOCredit: Decimal;
        FSOBalance: Decimal;
}
