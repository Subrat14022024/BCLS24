namespace FSO_NAVBCConnector.PurchaseInv;

using Microsoft.Integration.Entity;
using Microsoft.Purchases.Document;
codeunit 50101 FSONBCPurchHeaderAPISubscriber
{
    EventSubscriberInstance = Manual;

    var
        PurchInvoiceEntityAggregate: Record "Purch. Inv. Entity Aggregate";

    procedure SetpurchInvAggregate(Rec: Record "Purch. Inv. Entity Aggregate")
    begin
        PurchInvoiceEntityAggregate := Rec;
    end;

    local procedure UpdatePurchHdr(var PurchHdr: Record "Purchase Header")
    begin
        PurchHdr.Validate("Payment Discount %", PurchInvoiceEntityAggregate."FSONBCPayment Discount");
        PurchHdr.Validate("Posting No.", PurchInvoiceEntityAggregate."FSONBCPosting No.");
        PurchHdr.Validate("VAT Base Discount %", PurchInvoiceEntityAggregate."FSONBCVAT Base Discount");
        PurchHdr.Validate("Payment Terms Code", PurchInvoiceEntityAggregate."Payment Terms Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeModifyEvent', '', false, false)]
    local procedure PurchaseHeaderOnBeforeModify(var Rec: Record "Purchase Header")
    begin
        if Rec.IsTemporary then
            exit;
        UpdatePurchHdr(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure PurchaseHeaderOnBeforeInsert(var Rec: Record "Purchase Header")
    begin
        if Rec.IsTemporary then
            exit;
        UpdatePurchHdr(Rec);
    end;
}