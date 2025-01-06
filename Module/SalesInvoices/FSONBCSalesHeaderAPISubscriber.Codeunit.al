namespace FSO_NAVBCConnector.SalesInv;

using Microsoft.Integration.Entity;
using Microsoft.Sales.Document;
codeunit 50100 FSONBCSalesHeaderAPISubscriber
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
        SalesHdr.Validate("Posting No.", SalesInvoiceEntityAggregate."FSONBCPosting No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure SalesHeaderOnBeforeInsert(var Rec: Record "Sales Header")
    begin
        if Rec.IsTemporary then
            exit;
        UpdateSalesHdr(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeModifyEvent', '', false, false)]
    local procedure SalesHeaderOnBeforeModify(var Rec: Record "Sales Header")
    begin
        if Rec.IsTemporary then
            exit;
        UpdateSalesHdr(Rec);
    end;
}