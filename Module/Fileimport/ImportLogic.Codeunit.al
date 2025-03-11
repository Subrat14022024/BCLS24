namespace FSFINBELTEST.FSFINBELTEST;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.Dimension;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Account;
using System.Reflection;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Utilities;
codeunit 59100 ImportLogic
{
    internal procedure ImportGenJnlLineData()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        // Check General Journal Line Path existing
        GLSetup.get();
        GLSetup.TestField("Path Import Gen. Jnl Line");
        GLSetup.TestField("Path Import Gen. Jnl Line Save");

    end;

    internal procedure Updatedata()
    var
        ImportGenJnlLine: Record "Import General Journal Lines";
        GenLedgSetup: Record "General Ledger Setup";
        Lrec_GLAcc: Record "G/L Account";
        Lrec_DimValue: Record "Dimension Value";
    begin
        GenLedgSetup.Get();
        ImportGenJnlLine.Reset();
        ImportGenJnlLine.SETCURRENTKEY(LineNo);
        if ImportGenJnlLine.FindFirst() then
            repeat
                ImportGenJnlLine.Veld_01 := GetConvertedValue(ImportGenJnlLine.FIELDNO(Veld_01), ImportGenJnlLine.Veld_01);

                ImportGenJnlLine.Veld_02 := GetConvertedValue(ImportGenJnlLine.FIELDNO(Veld_02), ImportGenJnlLine.Veld_02);

                if not Lrec_GLAcc.GET(ImportGenJnlLine.Veld_02) then
                    ImportGenJnlLine.Veld_13 := 'Rekening Onbekend'
                else
                    ImportGenJnlLine.Veld_13 := '';

                ImportGenJnlLine.Veld_03 := GetConvertedValue(ImportGenJnlLine.FIELDNO(Veld_03), ImportGenJnlLine.Veld_03);

                ImportGenJnlLine.Veld_04 := GetConvertedValue(ImportGenJnlLine.FIELDNO(Veld_04), ImportGenJnlLine.Veld_04);

                if ImportGenJnlLine.Veld_04 <> '' then
                    if not Lrec_DimValue.GET(GenLedgSetup."Global Dimension 1 Code", ImportGenJnlLine.Veld_04) THEN
                        ImportGenJnlLine.Veld_14 := 'Dimensie SHOP Onbekend'
                    else
                        ImportGenJnlLine.Veld_14 := '';
                if (ImportGenJnlLine.Veld_03 = '000') then begin
                    if ImportGenJnlLine.Veld_04 <> '' then
                        ImportGenJnlLine.veld_15 := 'VERK'
                    else
                        ImportGenJnlLine.veld_15 := '';
                end else
                    ImportGenJnlLine.veld_15 := CopyStr(ImportGenJnlLine.Veld_03, 1, MaxStrLen(ImportGenJnlLine.veld_15));

                ImportGenJnlLine.Veld_05 := GetConvertedValue(ImportGenJnlLine.FIELDNO(Veld_05), ImportGenJnlLine.Veld_05);
                ImportGenJnlLine.Veld_06 := GetConvertedValue(ImportGenJnlLine.FIELDNO(Veld_06), ImportGenJnlLine.Veld_06);
                ImportGenJnlLine.Veld_07 := GetConvertedValue(ImportGenJnlLine.FIELDNO(Veld_07), ImportGenJnlLine.Veld_07);
                ImportGenJnlLine.Veld_12 := GetConvertedValue(ImportGenJnlLine.FIELDNO(Veld_12), ImportGenJnlLine.Veld_12);
                ImportGenJnlLine.modify(true);
            until ImportGenJnlLine.next() = 0;

    end;

    local procedure GetConvertedValue(PFieldNo: Integer; PTextValue: Text[30]): Code[30]
    var
        GenJnlConversion: Record "Import Gen Jnl Conversion";
    begin
        GenJnlConversion.SETRANGE("Table ID", DATABASE::"Import General Journal Lines");
        GenJnlConversion.SETRANGE("Field No.", PFieldNo);
        GenJnlConversion.SETRANGE(Value, PTextValue);
        if GenJnlConversion.FindFirst() then
            exit(GenJnlConversion."New Value");
    end;

    internal procedure CreateGenJnlLine()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        GenLedgSetup: Record "General Ledger Setup";
        ImportGenJnlLines: Record "Import General Journal Lines";
        NoSeriesMgt: Codeunit "No. Series";
        LineNoStep: Integer;
        Gint_Indicator: Integer;
        Gdlg_DialogBox: Dialog;
        Gint_RefCount: Integer;
        Gint_TotalCount: Integer;
        Text001_Lbl: Label 'error';
        Text002_Lbl: Label 'Error';
        NextLineNo: Integer;

    begin
        if GuiAllowed() then
            Gdlg_DialogBox.OPEN('Transfer to General Journal \' +
                                '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', Gint_Indicator);

        GenLedgSetup.GET();
        if (GenLedgSetup."Import Gen. Jnl. Template" = '') OR (GenLedgSetup."Import Gen. Jnl. Batch" = '') then
            ERROR(Text001_Lbl);
        if GenLedgSetup."No. Series Import Gen. Journal" = '' then
            ERROR(Text002_Lbl);

        LineNoStep := 10000;
        GenJournalLine.reset();
        GenJournalLine.setrange("Journal Template Name", GenLedgSetup."Import Gen. Jnl. Template");
        GenJournalLine.setrange("Journal Batch Name", GenLedgSetup."Import Gen. Jnl. Batch");
        if GenJournalLine.FindLast() then
            NextLineNo := GenJournalLine."Line No." + LineNoStep
        else
            NextLineNo := LineNoStep;

        Gint_TotalCount := ImportGenJnlLines.COUNT;
        Gint_RefCount := 0;

        GenJournalLine2."Document No." := NoSeriesMgt.GetNextNo(GenLedgSetup."No. Series Import Gen. Journal", WorkDate());

        ImportGenJnlLines.reset();
        ImportGenJnlLines.SETCURRENTKEY(LineNo);
        ImportGenJnlLines.SETFILTER(ImportGenJnlLines.Veld_08, '<>%1', 0);
        if ImportGenJnlLines.FindSet() then
            repeat
                if GuiAllowed() THEN begin
                    Gint_RefCount += 1;
                    Gint_Indicator := ROUND(Gint_RefCount / Gint_TotalCount * 10000, 1);
                    Gdlg_DialogBox.update();
                end;
                GenJournalLine.init();
                GenJournalLine."Journal Template Name" := GenLedgSetup."Import Gen. Jnl. Template";
                GenJournalLine."Journal Batch Name" := GenLedgSetup."Import Gen. Jnl. Batch";
                GenJournalLine."Line No." := NextLineNo;
                GenJournalLine.insert(true);

                GenJournalLine.validate("Posting Date", workdate());
                GenJournalLine."Document No." := GenJournalLine2."Document No.";

                GenJournalLine.validate("Document Type", 0); // 0 : Blanco
                GenJournalLine.validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
                GenJournalLine.validate("Account No.", ImportGenJnlLines.Veld_02);
                GenJournalLine.Description := ImportGenJnlLines.Veld_07;

                case ImportGenJnlLines.Veld_06 of
                    'D':
                        GenJournalLine.VALIDATE("Debit Amount", ImportGenJnlLines.Veld_08);
                    'C':
                        GenJournalLine.VALIDATE("Credit Amount", ImportGenJnlLines.Veld_08);
                end;

                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                GenJournalLine."Gen. Bus. Posting Group" := '';
                GenJournalLine."Gen. Prod. Posting Group" := '';
                GenJournalLine."VAT Bus. Posting Group" := '';
                GenJournalLine."VAT Prod. Posting Group" := '';
                GenJournalLine."Source Code" := 'FDAGB';


                if ImportGenJnlLines.Veld_04 <> '' then
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", ImportGenJnlLines.Veld_04);

                if ImportGenJnlLines.veld_15 <> '' then
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", ImportGenJnlLines.veld_15);


                GenJournalLine.modify(true);
                NextLineNo += 10000;

            until ImportGenJnlLines.NEXT() = 0;

        if GUIALLOWED then
            Gdlg_DialogBox.CLOSE();
    end;

}
