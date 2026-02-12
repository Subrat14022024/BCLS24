namespace FINBC.FINBC;

using Microsoft.Finance.Currency;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.VAT.Calculation;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Posting;

#pragma warning disable AA0215
codeunit 58000 TESTVATDISCOUNT
#pragma warning restore AA0215
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnDivideAmountOnBeforeTempVATAmountLineRemainderModify, '', false, false)]
    local procedure "Purch.-Post_OnDivideAmountOnBeforeTempVATAmountLineRemainderModify"
#pragma warning disable AL0432
(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var TempVATAmountLine: Record "VAT Amount Line" temporary; var TempVATAmountLineRemainder: Record "VAT Amount Line" temporary; Currency: Record Currency)
#pragma warning restore AL0432
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

            if not PurchLine."Exclude from Payment Discount" then begin
                TempVATAmountLineRemainder."Pmt. Discount Amount" += PmtDiscountBase * PurchHeader."Payment Discount %" / 100 * PurchLine.CalcLineAmount() / TempVATAmountLine.CalcLineAmount();
                PurchLine."Pmt. Discount Amount" := Round(TempVATAmountLineRemainder."Pmt. Discount Amount", Currency."Amount Rounding Precision");
                TempVATAmountLineRemainder."Pmt. Discount Amount" := TempVATAmountLineRemainder."Pmt. Discount Amount" - PurchLine."Pmt. Discount Amount";
            end else begin
                TempVATAmountLineRemainder."Pmt. Discount Amount" := 0;
                PurchLine."Pmt. Discount Amount" := 0;
            end;
        end;
    end;
}

