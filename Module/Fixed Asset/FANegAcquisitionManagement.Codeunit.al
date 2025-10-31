namespace BCLS.BCLS;

using Microsoft.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.Journal;
using Microsoft.FixedAssets.Ledger;
using Microsoft.FixedAssets.Depreciation;
using Microsoft.FixedAssets.Posting;
codeunit 50107 "FA Neg. Acquisition Management"
{
    Access = Internal;
    local procedure BypassCreatePostingTypeError(FAJnlLine: Record "FA Journal Line"; FALedgEntry2: Record "FA Ledger Entry"; var IsHandled: Boolean)
    var
        FixedAsset: Record "Fixed Asset";
        Text000_Lbl: Label 'Negative Acquisition Fixed Asset %1 cannot have positive Amount %2.', Comment = 'Error message when a FA with Negative Acquisition is posted with a positive amount.', Locked = true;
    begin
        if FixedAsset.Get(FALedgEntry2."FA No.") then
            if FixedAsset."FSOBEF Neg. Acquisition Value" then begin
                if FALedgEntry2.Amount > 0 then
                    if FALedgEntry2."FA Posting Type" <> FALedgEntry2."FA Posting Type"::Depreciation then
                        Error(Text000_Lbl, FALedgEntry2."FA No.", FALedgEntry2.Amount);
                IsHandled := true;
                FAJnlLine."FA Posting Type" := "FA Journal Line FA Posting Type".FromInteger(FALedgEntry2.ConvertPostingType());
            end;
    end;

    local procedure BypassCreateBookValueError(FALedgerEntry2: Record "FA Ledger Entry"; BookValue: Decimal; var IsHandled: Boolean)
    var
        FixedAsset: Record "Fixed Asset";
        text000_Lbl: Label 'Negative Acquisition Fixed Asset %1 cannot have positive Amount %2.', Comment = 'Error message when a FA with Negative Acquisition is posted with a positive amount.', Locked = true;
    begin
        if FixedAsset.Get(FALedgerEntry2."FA No.") then
            if FixedAsset."FSOBEF Neg. Acquisition Value" then begin
                if BookValue > 0 then
                    if FALedgerEntry2."FA Posting Type" <> FALedgerEntry2."FA Posting Type"::Depreciation then
                        Error(text000_Lbl, FALedgerEntry2."FA No.", BookValue);
                IsHandled := true;
            end;
    end;

    local procedure SkipRecord(FixedAsset: Record "Fixed Asset"; var ReturnValue: Boolean; var IsHandled: Boolean)
    begin
        if FixedAsset."FSOBEF Neg. Acquisition Value" then begin
            IsHandled := true;
            ReturnValue := false;
        end;

    end;

    local procedure SkipOnZeroValueWithNegativeAcquisitionValue(FANo: Code[20]; var Sign: Integer; var BookValue: Decimal; var DeprBasis: Decimal; var SalvageValue: Decimal; var MinusBookValue: Decimal; var SkipOnZero: Boolean; var IsHandled: Boolean)
    var
        FixedAsset: Record "Fixed Asset";
    begin
        if FixedAsset.Get(FANo) then
            if FixedAsset."FSOBEF Neg. Acquisition Value" then begin
                IsHandled := true;
                SkipOnZero := false;
                Sign := -1;
                if BookValue < 0 then
                    BookValue := -BookValue;
                if DeprBasis < 0 then
                    DeprBasis := -DeprBasis;
                if SalvageValue < 0 then
                    SalvageValue := -SalvageValue;
                if MinusBookValue < 0 then
                    MinusBookValue := -MinusBookValue;
            end;
    end;

    local procedure PostFixedAsset(FANo: Code[20]; FAPostingType: Enum "FA Journal Line FA Posting Type"; FALedgEntry: Record "FA Ledger Entry")
    var
        FixedAsset: Record "Fixed Asset";
        txt000_Lbl: Label 'Negative Acquisition Fixed Asset %1 cannot have positive Amount %2.', Comment = 'Error message when a FA with Negative Acquisition is posted with a positive amount.', Locked = true;
    begin
        if FixedAsset.Get(FANo) then
            if FixedAsset."FSOBEF Neg. Acquisition Value" then
                if FAPostingType = FAPostingType::"Acquisition Cost" then
                    if FALedgEntry.Amount > 0 then
                        Error(txt000_Lbl, FANo, FALedgEntry.Amount);
    end;

    local procedure BypassCreateDeprBasisError(FALedgerEntry2: Record "FA Ledger Entry"; DeprBasis: Decimal; var IsHandled: Boolean)
    var
        FixedAsset: Record "Fixed Asset";
        Text000_Lbl: Label 'Negative Acquisition Fixed Asset %1 cannot have positive Amount %2.', Comment = 'Error message when a FA with Negative Acquisition is posted with a positive amount.', Locked = true;
    begin
        if FixedAsset.Get(FALedgerEntry2."FA No.") then
            if FixedAsset."FSOBEF Neg. Acquisition Value" then begin
                if DeprBasis > 0 then
                    if FALedgerEntry2."FA Posting Type" <> FALedgerEntry2."FA Posting Type"::Depreciation then
                        Error(Text000_Lbl, FALedgerEntry2."FA No.", DeprBasis);
                IsHandled := true;
            end;
    end;

    local procedure BypassCreateAcquisitionCostError(var FALedgerEntry2: Record "FA Ledger Entry"; var IsHandled: Boolean)
    var
        FixedAsset: Record "Fixed Asset";
        Text000_Lbl: Label 'Negative Acquisition Fixed Asset %1 cannot have positive Amount %2.', Comment = 'Error message when a FA with Negative Acquisition is posted with a positive amount.', Locked = true;
    begin
        if FixedAsset.Get(FALedgerEntry2."FA No.") then
            if FixedAsset."FSOBEF Neg. Acquisition Value" then begin
                if FALedgerEntry2.Amount > 0 then
                    if FALedgerEntry2."FA Posting Type" <> FALedgerEntry2."FA Posting Type"::Depreciation then
                        Error(Text000_Lbl, FALedgerEntry2."FA No.", FALedgerEntry2.Amount);
                IsHandled := true
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Normal Depreciation", OnCalculateOnBeforeAssignSkipOnZeroValue, '', false, false)]
    local procedure CalculateNormalDepreciationOnCalculateOnBeforeAssignSkipOnZeroValue(FANo: Code[20]; FADepreciationBook: Record "FA Depreciation Book"; var Sign: Integer; var BookValue: Decimal; var DeprBasis: Decimal; var SalvageValue: Decimal; var MinusBookValue: Decimal; var SkipOnZero: Boolean; EndingBookValue: Decimal; var IsHandled: Boolean)
    begin
        if FADepreciationBook.IsTemporary then
            exit;
        this.SkipOnZeroValueWithNegativeAcquisitionValue(FANo, Sign, BookValue, DeprBasis, SalvageValue, MinusBookValue, SkipOnZero, IsHandled);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Jnl.-Post Line", OnBeforePostFixedAsset, '', false, false)]
    local procedure FAJnlPostLineOnBeforePostFixedAsset(FANo: Code[20]; DeprBookCode: Code[10]; FAPostingType: Enum "FA Journal Line FA Posting Type"; FALedgEntry: Record "FA Ledger Entry"; var IsHandled: Boolean)
    begin
        if FALedgEntry.IsTemporary then
            exit;
        this.PostFixedAsset(FANo, FAPostingType, FALedgEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Normal Depreciation", OnBeforeSkipRecord, '', false, false)]
    local procedure CalculateNormalDepreciationOnBeforeSkipRecord(FixedAsset: Record "Fixed Asset"; DeprBook: Record "Depreciation Book"; DisposalDate: Date; AcquisitionDate: Date; UntilDate: Date; FADeprMethod: Enum "FA Depreciation Method"; BookValue: Decimal; DeprBasis: Decimal; SalvageValue: Decimal; MinusBookValue: Decimal; var ReturnValue: Boolean; var IsHandled: Boolean)
    begin
        if FixedAsset.IsTemporary then
            exit;
        if DeprBook.IsTemporary then
            exit;
        this.SkipRecord(FixedAsset, ReturnValue, IsHandled);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Check Consistency", OnBeforeCreatePostingTypeError, '', false, false)]
    local procedure FACheckConsistencyOnBeforeCreatePostingTypeError(FAJnlLine: Record "FA Journal Line"; FALedgEntry2: Record "FA Ledger Entry"; DeprBook: Record "Depreciation Book"; var IsHandled: Boolean; NewAmount: Decimal)
    begin
        if FAJnlLine.IsTemporary then
            exit;
        if FALedgEntry2.IsTemporary then
            exit;
        if DeprBook.IsTemporary then
            exit;
        this.BypassCreatePostingTypeError(FAJnlLine, FALedgEntry2, IsHandled);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Check Consistency", OnBeforeCreateBookValueError, '', false, false)]
    local procedure FACheckConsistencyOnBeforeCreateBookValueError(FALedgerEntry2: Record "FA Ledger Entry"; BookValue: Decimal; SalvageValue: Decimal; var IsHandled: Boolean)
    begin
        if FALedgerEntry2.IsTemporary then
            exit;
        this.BypassCreateBookValueError(FALedgerEntry2, BookValue, IsHandled);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Check Consistency", OnBeforeCreateDeprBasisError, '', false, false)]
    local procedure FACheckConsistencyOnBeforeCreateDeprBasisError(FALedgerEntry2: Record "FA Ledger Entry"; DeprBasis: Decimal; var IsHandled: Boolean)
    begin
        if FALedgerEntry2.IsTemporary then
            exit;
        this.BypassCreateDeprBasisError(FALedgerEntry2, DeprBasis, IsHandled);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Check Consistency", OnBeforeCreateAcquisitionCostError, '', false, false)]
    local procedure FACheckConsistencyOnBeforeCreateAcquisitionCostError(FAJournalLine: Record "FA Journal Line"; var FALedgerEntry2: Record "FA Ledger Entry"; var IsHandled: Boolean)
    begin
        if FAJournalLine.IsTemporary then
            exit;
        if FALedgerEntry2.IsTemporary then
            exit;
        this.BypassCreateAcquisitionCostError(FALedgerEntry2, IsHandled);
    end;
}
