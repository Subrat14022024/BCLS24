namespace BCLS.BCLS;
using Microsoft.Integration.Entity;
using Microsoft.Sales.Document;
codeunit 50100 SalesHeaderAPISubscriber
{
    EventSubscriberInstance = Manual;

    var
        SalesInvoiceEntityAggregate: Record "Sales Invoice Entity Aggregate";

    procedure SetSalesInvAggregate(Rec: Record "Sales Invoice Entity Aggregate")
    begin
        SalesInvoiceEntityAggregate := Rec;
    end;

    local procedure UpdateSalesHdr(var SalesHdr: Record "Sales Header")
    begin
        SalesHdr.Validate("Posting No.", SalesInvoiceEntityAggregate."Posting No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertHdrLine(var Rec: Record "Sales Header")
    begin
        if Rec.IsTemporary then
            exit;
        UpdateSalesHdr(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifySalesLine(var Rec: Record "Sales Header")
    begin
        if Rec.IsTemporary then
            exit;
        UpdateSalesHdr(Rec);
    end;
}