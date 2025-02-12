namespace FINBC.FINBC;

using Microsoft.Purchases.Posting;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Purchases.Document;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.VAT.Calculation;
using Microsoft.Finance.Currency;

codeunit 58000 TESTVATDISCOUNT
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnDivideAmountOnBeforeTempVATAmountLineRemainderModify, '', false, false)]
    local procedure "Purch.-Post_OnDivideAmountOnBeforeTempVATAmountLineRemainderModify"(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var TempVATAmountLine: Record "VAT Amount Line" temporary; var TempVATAmountLineRemainder: Record "VAT Amount Line" temporary; Currency: Record Currency)
    var
        PaymentTerm: Record "Payment Terms";
        PmtDiscountBase: Decimal;
    begin
        if TempVATAmountLine.CalcLineAmount() <> 0 then begin
            if PaymentTerm.Get(PurchHeader."Payment Terms Code") then;
            if PaymentTerm."Cash Discount Excl. VAT" then
                PmtDiscountBase := TempVATAmountLine."Line Amount"
            else
                PmtDiscountBase := TempVATAmountLine."Amount Including VAT";
            TempVATAmountLineRemainder."Pmt. Discount Amount" +=
              PmtDiscountBase * PurchHeader."Payment Discount %" / 100 *
              PurchLine.CalcLineAmount() / TempVATAmountLine.CalcLineAmount();
            PurchLine."Pmt. Discount Amount" :=
              Round(TempVATAmountLineRemainder."Pmt. Discount Amount", Currency."Amount Rounding Precision");
            TempVATAmountLineRemainder."Pmt. Discount Amount" :=
              TempVATAmountLineRemainder."Pmt. Discount Amount" - PurchLine."Pmt. Discount Amount";
        end;
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnBeforeValidatePrepmtPaymentDiscountPercent, '', false, false)]
    // local procedure "Purchase Header_OnBeforeValidatePrepmtPaymentDiscountPercent"(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    // var
    //     GLSetup: Record "General Ledger Setup";
    //     PaymentTerm: Record "Payment Terms";
    // begin
    //     if PaymentTerm.Get(PurchaseHeader."Payment Terms Code") then
    //         if PaymentTerm."Cash Discount Excl. VAT" then begin
    //             IsHandled := true;
    //             if not (CurrentFieldNo in [0, PurchaseHeader.FieldNo("Posting Date"), PurchaseHeader.FieldNo("Document Date")]) then
    //                 PurchaseHeader.TestStatusOpen();
    //             GLSetup.Get();
    //             if PurchaseHeader."Payment Discount %" < PaymentTerm."Discount %" then
    //                 PurchaseHeader."VAT Base Discount %" := PurchaseHeader."Payment Discount %"
    //             else
    //                 PurchaseHeader."VAT Base Discount %" := PaymentTerm."Discount %";
    //             PurchaseHeader.Validate("VAT Base Discount %");
    //         end;

    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnValidateVATBaseDiscountOnBeforeConfirm, '', false, false)]
    // local procedure "Purchase Header_OnValidateVATBaseDiscountOnBeforeConfirm"(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean; var Confirmed: Boolean)
    // var
    //     PurchLine: Record "Purchase Line";
    // begin
    //     IsHandled := true;
    //     Confirmed := true;
    //     // PurchLine.Reset();
    //     // PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
    //     // PurchLine.SetRange("Document No.", PurchaseHeader."No.");
    //     // PurchLine.SetFilter(Type, '<>%1', PurchLine.Type::" ");
    //     // PurchLine.SetFilter(Quantity, '<>0');
    //     // PurchLine.LockTable();
    //     // if PurchLine.FindSet() then begin
    //     //     PurchLine.Modify();
    //     //     repeat
    //     //         PurchLine.UpdateAmounts();
    //     //         PurchLine.Modify();
    //     //     until PurchLine.Next() = 0;
    //     // end;
    // end;
}

