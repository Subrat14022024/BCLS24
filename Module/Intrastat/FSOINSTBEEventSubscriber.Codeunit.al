namespace BCLS.BCLS;

using Microsoft.Purchases.Posting;
using Microsoft.Purchases.Document;
using Microsoft.Finance.GeneralLedger.Posting;

codeunit 50104 FSOINSTBEEventSubscriber
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterPostPurchaseDoc, '', false, false)]
    local procedure "Purch.-Post_OnAfterPostPurchaseDoc"(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        IntrastatPurchase: Record "FSOINSTBEIntrastat Purchase";
        IntrastatReportLine: Record "TCOGINGL Intrastat Report Line";
    begin
        IntrastatPurchase.SetRange("Posted Document No.", PurchInvHdrNo);
        IntrastatPurchase.SetRange(Processed, false);
        if IntrastatPurchase.FindFirst() then begin
            IntrastatReportLine.SetRange("Document No.", IntrastatPurchase."Posted Document No.");
            IntrastatReportLine.SetRange(Processed, false);
            if IntrastatReportLine.FindFirst() then
                modifyIntrastatLines(IntrastatPurchase, IntrastatReportLine)
            else begin
                IntrastatReportLine.SetRange(Processed, true);
                if not IntrastatReportLine.FindFirst() then begin
                    IntrastatReportLine.Init();
                    IntrastatReportLine."Document No." := IntrastatPurchase."Posted Document No.";
                    IntrastatReportLine.Insert(true);
                    modifyIntrastatLines(IntrastatPurchase, IntrastatReportLine);
                end;
            end;
        end;
    end;

    local procedure modifyIntrastatLines(var IntrastatPurchase: Record "fSOINSTBEIntrastat Purchase"; var IntrastatReportLine: Record "TCOGINGL Intrastat Report Line")
    var
        IntrastatPurchaseCopy: Record "fSOINSTBEIntrastat Purchase";
    begin
        IntrastatReportLine."Line No." := IntrastatPurchase."Line No.";
        IntrastatReportLine.Type := IntrastatReportLine.Type::Receipt;
        IntrastatReportLine.Date := IntrastatPurchase.Date;
        IntrastatReportLine.Validate("Tariff No.", IntrastatPurchase."Tariff No.");
        IntrastatReportLine."Country/Region Code" := IntrastatPurchase."Country Code";
        IntrastatReportLine."Transaction Type" := IntrastatPurchase."Transaction Type";
        IntrastatReportLine."Transport Method" := IntrastatPurchase."Transport Method";
        IntrastatReportLine."Source Type" := IntrastatReportLine."Source Type"::" ";
        IntrastatReportLine.Amount := IntrastatPurchase.Amount;
        IntrastatReportLine.Quantity := IntrastatPurchase.Quantity;
        IntrastatReportLine."Transaction Specification" := IntrastatPurchase."Transaction Specification";
        IntrastatReportLine."Statistical Value" := IntrastatPurchase."Statistical Value";
        IntrastatReportLine."Document No." := IntrastatPurchase."Document No.";
        IntrastatReportLine."Total Weight" := IntrastatPurchase."Total Weight";
        IntrastatReportLine."Supplementary Units" := IntrastatPurchase."Supplementary Units";
        IntrastatReportLine."Entry/Exit Point" := IntrastatPurchase."Entry Point";
        IntrastatReportLine."Area" := IntrastatPurchase."Area";
        IntrastatReportLine."Transaction Specification" := IntrastatPurchase."Transaction Specification";
        IntrastatReportLine."Partner VAT ID" := IntrastatPurchase."Partner VAT ID";
        IntrastatReportLine."Suppl. Unit of Measure" := IntrastatPurchase."Unit of Measure";
        if IntrastatReportLine.Modify(true) then
            if IntrastatPurchaseCopy.Get(IntrastatPurchase."Document No.", IntrastatPurchase."Posted Document No.") then begin
                IntrastatPurchaseCopy.Processed := true;
                IntrastatPurchaseCopy.Modify();
            end;
    end;
}
