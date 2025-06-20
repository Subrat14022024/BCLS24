namespace FSOFIN.PayrollFileImport;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.Dimension;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Foundation.AuditCodes;
using System.Azure.Storage.Files;
using FSO_Integration.AFS;

codeunit 50156 "FSOFINPayroll File Import"
{
    internal procedure ImportGenJnlLineData()
    var
        FileText: Text;
        FileInStream: InStream;
        TextRead: Text;
        LineIdentifier_Lbl: Label 'BB', Locked = true;
    begin
        // GLSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        // GLSetup.SetLoadFields("FSOFINPath Import Gen Jnl Line", "FSOFINPath Import Gen Jnl Save", "FSOFINFile Import File Share");
        // GLSetup.Get();
        // GLSetup.TestField("FSOFINPath Import Gen Jnl Line");
        // GLSetup.TestField("FSOFINPath Import Gen Jnl Save");
        // if CheckCreateDirectory(GLSetup."FSOFINPath Import Gen Jnl Line", CompanyName, GLSetup."FSOFINPath Import Gen Jnl Line" + '\' + CompanyName) then begin
        //     FSOINTAzureFileService.SetFileShare(GLSetup."FSOFINFile Import File Share");
        //     FSOINTAzureFileService.ReadListFromShare(GLSetup."FSOFINPath Import Gen Jnl Line" + '\' + CompanyName, AFSDirectoryContent);
        //     AFSDirectoryContent.SetRange("Resource Type", AFSDirectoryContent."Resource Type"::File);
        //     if AFSDirectoryContent.FindSet() then
        //         repeat
        //             FSOINTAzureFileService.ReadFileFromShare(AFSDirectoryContent."Full Name", FileText, FileInStream);
        //             while not FileInStream.EOS do begin
        //                 FileInStream.ReadText(TextRead);
        //                 if TrimSpaces(CopyStr(TextRead, 1, 9)) = LineIdentifier_Lbl then
        //                     Import_GenJnlLine_Message(TextRead);
        //             end;
        //             if CheckCreateDirectory(GLSetup."FSOFINPath Import Gen Jnl Save", CompanyName, GLSetup."FSOFINPath Import Gen Jnl Save" + '\' + CompanyName) then
        //                 MoveFileFromShare(AFSDirectoryContent."Full Name", GLSetup."FSOFINPath Import Gen Jnl Save" + '\' + CompanyName, AFSDirectoryContent.Name, FileText)
        //         until AFSDirectoryContent.Next() = 0;
        // end;
        UploadIntoStream('', '', '', FileText, FileInStream);
        while not FileInStream.EOS do begin
            FileInStream.ReadText(TextRead);
            if TrimSpaces(CopyStr(TextRead, 1, 9)) = LineIdentifier_Lbl then
                Import_GenJnlLine_Message(TextRead);
        end;
    end;

    internal procedure UpdateData()
    var
        FSOFINImportGenJnlLine: Record "FSOFINImport Gen Journal Lines";
        GLSetup: Record "General Ledger Setup";
        GLAccount: Record "G/L Account";
        DimensionValue: Record "Dimension Value";
        UnknownAccount_Lbl: Label 'Unknown Account', Locked = true;
        UnknownDimension_Lbl: Label 'Unknown Dimension SHOP', Locked = true;
        Zero_Lbl: Label '000', Locked = true;
    begin
        GLSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        GLSetup.SetLoadFields("Global Dimension 2 Code", "FSOFINDef Dimension 1 Code");
        GLSetup.Get();

        FSOFINImportGenJnlLine.Reset();
        FSOFINImportGenJnlLine.SETCURRENTKEY("Line No.");
        if FSOFINImportGenJnlLine.FindSet() then
            repeat
                FSOFINImportGenJnlLine.Field_01 := GetConvertedValue(FSOFINImportGenJnlLine.FIELDNO(Field_01), FSOFINImportGenJnlLine.Field_01);
                FSOFINImportGenJnlLine.Field_02 := GetConvertedValue(FSOFINImportGenJnlLine.FIELDNO(Field_02), FSOFINImportGenJnlLine.Field_02);

                if not GLAccount.GET(FSOFINImportGenJnlLine.Field_02) then
                    FSOFINImportGenJnlLine.Field_13 := UnknownAccount_Lbl
                else
                    FSOFINImportGenJnlLine.Field_13 := '';

                FSOFINImportGenJnlLine.Field_03 := GetConvertedValue(FSOFINImportGenJnlLine.FIELDNO(Field_03), FSOFINImportGenJnlLine.Field_03);
                FSOFINImportGenJnlLine.Field_04 := GetConvertedValue(FSOFINImportGenJnlLine.FIELDNO(Field_04), FSOFINImportGenJnlLine.Field_04);
                DimensionValue.ReadIsolation(IsolationLevel::ReadUncommitted);
                if FSOFINImportGenJnlLine.Field_04 <> '' then
                    if not DimensionValue.get(GLSetup."Global Dimension 2 Code", FSOFINImportGenJnlLine.Field_04) then
                        FSOFINImportGenJnlLine.Field_14 := UnknownDimension_Lbl
                    else
                        FSOFINImportGenJnlLine.Field_14 := '';
                if (FSOFINImportGenJnlLine.Field_03 = Zero_Lbl) then begin
                    if FSOFINImportGenJnlLine.Field_04 <> '' then
                        FSOFINImportGenJnlLine.Field_15 := GLSetup."FSOFINDef Dimension 1 Code"
                    else
                        FSOFINImportGenJnlLine.Field_15 := '';
                end else
                    FSOFINImportGenJnlLine.Field_15 := CopyStr(FSOFINImportGenJnlLine.Field_03, 1, MaxStrLen(FSOFINImportGenJnlLine.Field_15));

                FSOFINImportGenJnlLine.Field_05 := GetConvertedValue(FSOFINImportGenJnlLine.FIELDNO(Field_05), FSOFINImportGenJnlLine.Field_05);
                FSOFINImportGenJnlLine.Field_06 := GetConvertedValue(FSOFINImportGenJnlLine.FIELDNO(Field_06), FSOFINImportGenJnlLine.Field_06);
                FSOFINImportGenJnlLine.Field_07 := GetConvertedValue(FSOFINImportGenJnlLine.FIELDNO(Field_07), FSOFINImportGenJnlLine.Field_07);
                FSOFINImportGenJnlLine.Field_12 := GetConvertedValue(FSOFINImportGenJnlLine.FIELDNO(Field_12), FSOFINImportGenJnlLine.Field_12);
                FSOFINImportGenJnlLine.modify(true);
            until FSOFINImportGenJnlLine.next() = 0;
    end;

    local procedure GetConvertedValue(FieldNo: Integer; TextValue: Text[30]): Code[30]
    var
        FSOFINImporGenJnlConversion: Record "FSOFINImportGenJnl Conversion";
    begin
        FSOFINImporGenJnlConversion.SETRANGE("Table ID", Database::"FSOFINImport Gen Journal Lines");
        FSOFINImporGenJnlConversion.SETRANGE("Field No.", FieldNo);
        FSOFINImporGenJnlConversion.SETRANGE(Value, TextValue);
        FSOFINImporGenJnlConversion.ReadIsolation(IsolationLevel::ReadUncommitted);
        FSOFINImporGenJnlConversion.SetLoadFields("New Value");
        if FSOFINImporGenJnlConversion.FindFirst() then
            if FSOFINImporGenJnlConversion."New Value" <> '' then
                exit(FSOFINImporGenJnlConversion."New Value")
            else
                exit(TextValue)
        else
            exit(TextValue);
    end;

    internal procedure CreateGenJnlLine()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        GLSetup: Record "General Ledger Setup";
        FSOFINImportGenJnlLines: Record "FSOFINImport Gen Journal Lines";
        SourceCodeSetup: Record "Source Code Setup";
        NoSeriesMgt: Codeunit "No. Series";
        LineNoStep: Integer;
        Indicator: Integer;
        DialogBox: Dialog;
        RefCount: Integer;
        TotalCount: Integer;
        NextLineNo: Integer;
        Text001_Lbl: Label 'You must enter a Journal Template and a Journal Batch', Locked = true;
        Text002_Lbl: Label 'You must enter no. series for Import Gen.Jnl Lines', Locked = true;
        DialogBoxText_Lbl: Label 'Transfer to General Journal \', Locked = true;
        DialogBoxText1_Lbl: Label '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', Locked = true;
        CreditIndentifier_Lbl: Label 'C', Locked = true;
        DebitIndentifier_Lbl: Label 'D', Locked = true;
    begin
        if GuiAllowed() then
            DialogBox.OPEN(DialogBoxText_Lbl + DialogBoxText1_Lbl, Indicator);

        GLSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        GLSetup.SetLoadFields("FSOFINImport Gen. Jnl. Templat", "FSOFINImport Gen. Jnl. Batch", "FSOFINNo. Ser. Import Gen. Jnl");
        GLSetup.Get();

        if (GLSetup."FSOFINImport Gen. Jnl. Templat" = '') or (GLSetup."FSOFINImport Gen. Jnl. Batch" = '') then
            ERROR(Text001_Lbl);
        if GLSetup."FSOFINNo. Ser. Import Gen. Jnl" = '' then
            ERROR(Text002_Lbl);

        LineNoStep := 10000;
        GenJournalLine.reset();
        GenJournalLine.setrange("Journal Template Name", GLSetup."FSOFINImport Gen. Jnl. Templat");
        GenJournalLine.setrange("Journal Batch Name", GLSetup."FSOFINImport Gen. Jnl. Batch");
        if GenJournalLine.FindLast() then
            NextLineNo := GenJournalLine."Line No." + LineNoStep
        else
            NextLineNo := LineNoStep;

        TotalCount := FSOFINImportGenJnlLines.Count();
        RefCount := 0;

        GenJournalLine2."Document No." := NoSeriesMgt.GetNextNo(GLSetup."FSOFINNo. Ser. Import Gen. Jnl", WorkDate());

        FSOFINImportGenJnlLines.reset();
        FSOFINImportGenJnlLines.setcurrentkey("Line No.");
        FSOFINImportGenJnlLines.setfilter(FSOFINImportGenJnlLines.Field_08, '<>%1', 0);
        if FSOFINImportGenJnlLines.FindSet() then
            repeat
                if GuiAllowed() then begin
                    RefCount += 1;
                    Indicator := ROUND(RefCount / TotalCount * 10000, 1);
                    DialogBox.update();
                end;
                GenJournalLine.init();
                GenJournalLine."Journal Template Name" := GLSetup."FSOFINImport Gen. Jnl. Templat";
                GenJournalLine."Journal Batch Name" := GLSetup."FSOFINImport Gen. Jnl. Batch";
                GenJournalLine."Line No." := NextLineNo;
                GenJournalLine.insert(true);

                GenJournalLine.validate("Posting Date", workdate());
                GenJournalLine."Document No." := GenJournalLine2."Document No.";
                GenJournalLine.validate("Document Type", 0); // 0 : Blank
                GenJournalLine.validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
                GenJournalLine.validate("Account No.", FSOFINImportGenJnlLines.Field_02);
                GenJournalLine.Description := FSOFINImportGenJnlLines.Field_07;
                case FSOFINImportGenJnlLines.Field_06 of
                    DebitIndentifier_Lbl:
                        GenJournalLine.validate("Debit Amount", FSOFINImportGenJnlLines.Field_08);
                    CreditIndentifier_Lbl:
                        GenJournalLine.validate("Credit Amount", FSOFINImportGenJnlLines.Field_08);
                end;
                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."VAT Bus. Posting Group" := '';
                GenJournalLine."VAT Prod. Posting Group" := '';
                SourceCodeSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
                SourceCodeSetup.SetLoadFields("General Journal");
                if SourceCodeSetup.Get() then
                    GenJournalLine."Source Code" := SourceCodeSetup."General Journal"
                else
                    GenJournalLine."Source Code" := '';
                if FSOFINImportGenJnlLines.Field_15 <> '' then
                    GenJournalLine.validate("Shortcut Dimension 1 Code", FSOFINImportGenJnlLines.Field_15);
                if FSOFINImportGenJnlLines.Field_04 <> '' then
                    GenJournalLine.validate("Shortcut Dimension 2 Code", FSOFINImportGenJnlLines.Field_04);
                GenJournalLine.modify(true);
                NextLineNo += 10000;
            until FSOFINImportGenJnlLines.NEXT() = 0;

        if GuiAllowed() then
            DialogBox.close();

        OpenGenenalJournal(GLSetup."FSOFINImport Gen. Jnl. Templat", GLSetup."FSOFINImport Gen. Jnl. Batch");
    end;

    local procedure TrimSpaces(TrimText: Text): Text
    begin
        exit(DelChr(TrimText, '<>', ' '));
    end;

    Internal procedure DeleteProcessedLine()
    var
        FSOFINImportGenJnlLine: Record "FSOFINImport Gen Journal Lines";
    begin
        FSOFINImportGenJnlLine.DeleteAll();
    end;

    local procedure Import_GenJnlLine_Message(FileContentText: Text)
    var
        FSOFINImportGenJnlLines: Record "FSOFINImport Gen Journal Lines";
        FSOFINImportGenJnlLines1: Record "FSOFINImport Gen Journal Lines";
        GLAccount: Record "G/L Account";
        DimensiomValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        LineNo: Integer;
        UnknownAccount_Lbl: Label 'Unknown Account', Locked = true;
        UnknownDimension_Lbl: Label 'Unknown Dimension SHOP', Locked = true;
        Zero_Lbl: Label '000', Locked = true;
    begin
        GLSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        GLSetup.SetLoadFields("Global Dimension 2 Code", "FSOFINDef Dimension 1 Code");
        GLSetup.Get();
        if FileContentText <> '' then begin
            FSOFINImportGenJnlLines.init();
            if FSOFINImportGenJnlLines1.FindLast() then
                LineNo := FSOFINImportGenJnlLines1."Line No." + 100
            else
                LineNo := 100;

            FSOFINImportGenJnlLines."Line No." := LineNo;
            FSOFINImportGenJnlLines.Insert();
            FSOFINImportGenJnlLines.Field_01 := CopyStr(TrimSpaces(COPYSTR(FileContentText, 1, 9)), 1, MaxStrLen(FSOFINImportGenJnlLines.Field_01));   // BB
            FSOFINImportGenJnlLines.Field_01 := GetConvertedValue(FSOFINImportGenJnlLines.FIELDNO(Field_01), FSOFINImportGenJnlLines.Field_01);

            FSOFINImportGenJnlLines.Field_02 := CopyStr(TrimSpaces(COPYSTR(FileContentText, 10, 6)), 1, MaxStrLen(FSOFINImportGenJnlLines.Field_02));  // 620249
            FSOFINImportGenJnlLines.Field_02 := GetConvertedValue(FSOFINImportGenJnlLines.FIELDNO(Field_02), FSOFINImportGenJnlLines.Field_02);

            if not GLAccount.Get(FSOFINImportGenJnlLines.Field_02) then
                FSOFINImportGenJnlLines.Field_13 := UnknownAccount_Lbl
            else
                FSOFINImportGenJnlLines.Field_13 := '';

            FSOFINImportGenJnlLines.Field_03 := CopyStr(TrimSpaces(COPYSTR(FileContentText, 16, 5)), 1, MaxStrLen(FSOFINImportGenJnlLines.Field_03));  // 000
            FSOFINImportGenJnlLines.Field_03 := GetConvertedValue(FSOFINImportGenJnlLines.FIELDNO(Field_03), FSOFINImportGenJnlLines.Field_03);

            FSOFINImportGenJnlLines.Field_04 := CopyStr(TrimSpaces(COPYSTR(FileContentText, 21, 4)), 1, MaxStrLen(FSOFINImportGenJnlLines.Field_04));  // HOOG
            FSOFINImportGenJnlLines.Field_04 := GetConvertedValue(FSOFINImportGenJnlLines.FIELDNO(Field_04), FSOFINImportGenJnlLines.Field_04);

            if FSOFINImportGenJnlLines.Field_04 <> '' then
                if not DimensiomValue.Get(GLSetup."Global Dimension 2 Code", FSOFINImportGenJnlLines.Field_04) THEN
                    FSOFINImportGenJnlLines.Field_14 := UnknownDimension_Lbl
                else
                    FSOFINImportGenJnlLines.Field_14 := '';

            if (FSOFINImportGenJnlLines.Field_03 = Zero_Lbl) then begin
                if FSOFINImportGenJnlLines.Field_04 <> '' then
                    FSOFINImportGenJnlLines.Field_15 := GLSetup."FSOFINDef Dimension 1 Code"
                else
                    FSOFINImportGenJnlLines.Field_15 := '';
            end else
                FSOFINImportGenJnlLines.Field_15 := CopyStr(FSOFINImportGenJnlLines.Field_03, 1, MaxStrLen(FSOFINImportGenJnlLines.Field_15));

            FSOFINImportGenJnlLines.Field_05 := CopyStr(TrimSpaces(COPYSTR(FileContentText, 24, 5)), 1, MaxStrLen(FSOFINImportGenJnlLines.Field_05));  // 8260
            FSOFINImportGenJnlLines.Field_05 := GetConvertedValue(FSOFINImportGenJnlLines.FIELDNO(Field_05), FSOFINImportGenJnlLines.Field_05);

            FSOFINImportGenJnlLines.Field_06 := CopyStr(TrimSpaces(COPYSTR(FileContentText, 29, 4)), 1, MaxStrLen(FSOFINImportGenJnlLines.Field_06));  // C (Credit) - D (Debit)
            FSOFINImportGenJnlLines.Field_06 := GetConvertedValue(FSOFINImportGenJnlLines.FIELDNO(Field_06), FSOFINImportGenJnlLines.Field_06);

            FSOFINImportGenJnlLines.Field_07 := CopyStr(TrimSpaces(COPYSTR(FileContentText, 33, 30)), 1, MaxStrLen(FSOFINImportGenJnlLines.Field_07)); // AANWEND. PROV. VAKGELD BED.
            FSOFINImportGenJnlLines.Field_07 := GetConvertedValue(FSOFINImportGenJnlLines.FIELDNO(Field_07), FSOFINImportGenJnlLines.Field_07);

            FSOFINImportGenJnlLines.Field_08 := TextToDecimal(COPYSTR(FileContentText, 63, 11)); //00000004003
            if FSOFINImportGenJnlLines.Field_08 <> 0 then
                FSOFINImportGenJnlLines.Field_08 := FSOFINImportGenJnlLines.Field_08 / 100;

            FSOFINImportGenJnlLines.Field_09 := TextToDecimal(COPYSTR(FileContentText, 75, 11)); // 00000000000
            if FSOFINImportGenJnlLines.Field_09 <> 0 then
                FSOFINImportGenJnlLines.Field_09 := FSOFINImportGenJnlLines.Field_09 / 100;

            FSOFINImportGenJnlLines.Field_10 := TextToDecimal(COPYSTR(FileContentText, 87, 9));  // 000000000
            if FSOFINImportGenJnlLines.Field_10 <> 0 then
                FSOFINImportGenJnlLines.Field_10 := FSOFINImportGenJnlLines.Field_10 / 100;

            FSOFINImportGenJnlLines.Field_11 := TextToDecimal(COPYSTR(FileContentText, 97, 9));  // 000000000
            if FSOFINImportGenJnlLines.Field_11 <> 0 then
                FSOFINImportGenJnlLines.Field_11 := FSOFINImportGenJnlLines.Field_11 / 100;

            FSOFINImportGenJnlLines.Field_12 := CopyStr(TrimSpaces(COPYSTR(FileContentText, 107, 15)), 1, MaxStrLen(FSOFINImportGenJnlLines.Field_12));// 1WZ000820121209
            FSOFINImportGenJnlLines.Field_12 := GetConvertedValue(FSOFINImportGenJnlLines.FIELDNO(Field_12), FSOFINImportGenJnlLines.Field_12);
            FSOFINImportGenJnlLines.modify(true);
        end;
    end;

    local procedure TextToDecimal(DecimalAsTextForCheck: Text[15]) ReturnDecimal: Decimal
    var
        DecimalAsText: Text[15];
    begin
        DecimalAsText := CopyStr(CONVERTSTR(TrimSpaces(DecimalAsTextForCheck), '.', ','), 1, MaxStrLen(DecimalAsText));
        if DecimalAsText <> '' then
            Evaluate(ReturnDecimal, DecimalAsText);
    end;

    local procedure OpenGenenalJournal(TemplateCode: Code[10]; BatchCode: Code[10])
    var
        GenJournalLine: Record "Gen. Journal Line";
        OpenTransferedJournal_Lbl: Label 'Do you want to open General Journal', Locked = true;
    begin
        GenJournalLine.SetRange("Journal Template Name", TemplateCode);
        GenJournalLine.SetRange("Journal Batch Name", BatchCode);
        if not GenJournalLine.IsEmpty() then
            if Confirm(OpenTransferedJournal_Lbl) then
                Page.Run(Page::"General Journal", GenJournalLine);
    end;
}
