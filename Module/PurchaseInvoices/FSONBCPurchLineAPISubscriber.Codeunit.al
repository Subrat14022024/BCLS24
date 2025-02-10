namespace FSO_NAVBCConnector.PurchaseInv;

using Microsoft.Integration.Entity;
using Microsoft.Purchases.Document;
codeunit 50102 FSONBCPurchLineAPISubscriber
{
    EventSubscriberInstance = Manual;

    var
        PurchInvLineAggregate: Record "Purch. Inv. Line Aggregate";
        GenProductPostingGroupUpdate: Code[10];

    procedure SetpurchInvLine(GenProductPostingGroup: Code[10]; Rec: Record "Purch. Inv. Line Aggregate")
    begin
        this.PurchInvLineAggregate := Rec;
        this.GenProductPostingGroupUpdate := GenProductPostingGroup;
    end;

    local procedure UpdatePurchLine(var PurchLine: Record "Purchase line")
    begin
        PurchLine.Validate(PurchLine."Gen. Prod. Posting Group", this.GenProductPostingGroupUpdate);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeModifyEvent', '', false, false)]
    local procedure PurchaseLineOnBeforeModify(var Rec: Record "purchase line")
    begin
        if Rec.IsTemporary then
            exit;
        this.UpdatePurchLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure PurchaseLineOnBeforeInsert(var Rec: Record "Purchase Line")
    begin
        if Rec.IsTemporary then
            exit;
        this.UpdatePurchLine(Rec);
    end;
}