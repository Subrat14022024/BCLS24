namespace BCLS.BCLS;

using Microsoft.Bank.Payment;
using Microsoft.Purchases.Payables;
using Microsoft.Finance.GeneralLedger.Journal;

codeunit 50105 EBSuggestPaymentEvents
{
    [EventSubscriber(ObjectType::Report, Report::"Suggest Vendor Payments EB", OnSetPaymJnlLineOnBeforePaymJnlLineInsert, '', false, false)]
    local procedure "Suggest Vendor Payments EB_OnSetPaymJnlLineOnBeforePaymJnlLineInsert"(var PaymJnlLine: Record "Payment Journal Line"; VendorLedgEntry: Record "Vendor Ledger Entry")
    begin
        InsertDueDateAndPmtDiscountDateVLE(PaymJnlLine, VendorLedgEntry)
    end;

    local procedure InsertDueDateAndPmtDiscountDateVLE(var PaymJnlLine: Record "Payment Journal Line"; VendorLedgEntry: Record "Vendor Ledger Entry")
    begin
        PaymJnlLine."Pmt. Discount Date VLE" := VendorLedgEntry."Pmt. Discount Date";
        PaymJnlLine."Due Date VLE" := VendorLedgEntry."Due Date";
    end;


    [EventSubscriber(ObjectType::Report, Report::"Suggest Vendor Payments", OnMakeGenJnlLinesOnBeforeVendorPaymentBufferInsertNonSummarize, '', false, false)]
    local procedure "Suggest Vendor Payments_OnMakeGenJnlLinesOnBeforeVendorPaymentBufferInsertNonSummarize"(var TempVendorPaymentBuffer: Record "Vendor Payment Buffer" temporary; VendorLederEntry: Record "Vendor Ledger Entry"; var SummarizePerVend: Boolean; var NextDocNo: Code[20]; var TempPayableVendorLedgerEntry: Record "Payable Vendor Ledger Entry" temporary)
    begin
        InsertDueDateAndPmtDiscountDateVLEBuffer(TempVendorPaymentBuffer, VendorLederEntry);
    end;

    local procedure InsertDueDateAndPmtDiscountDateVLEBuffer(var TempVendorPaymentBuffer: Record "Vendor Payment Buffer" temporary; VendorLederEntry: Record "Vendor Ledger Entry")
    begin
        TempVendorPaymentBuffer."Due Date VLE" := VendorLederEntry."Due Date";
        TempVendorPaymentBuffer."Pmt. Discount Date VLE" := VendorLederEntry."Pmt. Discount Date";
        TempVendorPaymentBuffer."Payment Discount Amount" := -VendorLederEntry."Remaining Pmt. Disc. Possible"
    end;

    [EventSubscriber(ObjectType::Report, Report::"Suggest Vendor Payments", OnBeforeUpdateGnlJnlLineDimensionsFromVendorPaymentBuffer, '', false, false)]
    local procedure "Suggest Vendor Payments_OnBeforeUpdateGnlJnlLineDimensionsFromVendorPaymentBuffer"(var GenJournalLine: Record "Gen. Journal Line"; TempVendorPaymentBuffer: Record "Vendor Payment Buffer" temporary; SummarizePerVend: Boolean; DocNoPerLine: Boolean; var NextDocNo: Code[20])
    begin
        InsertIntoPaymentJournal(GenJournalLine, TempVendorPaymentBuffer);
    end;

    local procedure InsertIntoPaymentJournal(var GenJournalLine: Record "Gen. Journal Line"; TempVendorPaymentBuffer: Record "Vendor Payment Buffer" temporary)
    begin

        GenJournalLine."Due Date" := TempVendorPaymentBuffer."Due Date VLE";
        GenJournalLine."Orig. Pmt. Disc. Possible" := TempVendorPaymentBuffer."Payment Discount Amount";
        // if GenJournalLine."Orig. Pmt. Disc. Possible" <> 0 then
        //     GenJournalLine."Pmt. Discount Date" := TempVendorPaymentBuffer."Pmt. Discount Date VLE";
    end;
}
