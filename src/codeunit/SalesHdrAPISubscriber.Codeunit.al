codeunit 50101 SalesHdrAPISubscriber
{
    EventSubscriberInstance = Manual;

    var
        SalesInvoiceHdrAggregate: Record "Sales Invoice Entity Aggregate";

    procedure SetSalesHdrInvoiceHdrAggregate(Rec: Record "Sales Invoice Entity Aggregate")
    begin
        SalesInvoiceHdrAggregate := Rec;
    end;

    local procedure UpdateSalesHdr(var SalesHdr: Record "Sales Header")
    begin
        SalesHdr.Validate("Location Code", SalesInvoiceHdrAggregate."Location Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesHdr(var Rec: Record "Sales Header")
    begin
        if Rec.IsTemporary then
            exit;
        UpdateSalesHdr(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifySalesHdr(var Rec: Record "Sales Header")
    begin
        if Rec.IsTemporary then
            exit;
        UpdateSalesHdr(Rec);
    end;
}