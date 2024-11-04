namespace BCLS.BCLS;
using Microsoft.Integration.Entity;
using Microsoft.Purchases.Document;
codeunit 50101 PurchHeaderAPISubscriber
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
        PurchHdr.Validate("Posting No.", PurchInvoiceEntityAggregate."Posting No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyPurchaseHdr(var Rec: Record "Purchase Header")
    begin
        if Rec.IsTemporary then
            exit;
        UpdatePurchHdr(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforePurchaseHdr(var Rec: Record "Purchase Header")
    begin
        if Rec.IsTemporary then
            exit;
        UpdatePurchHdr(Rec);
    end;
}