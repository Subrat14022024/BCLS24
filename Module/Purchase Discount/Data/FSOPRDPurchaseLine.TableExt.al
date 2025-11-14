namespace FSO_Purchase.Discount;

using Microsoft.Purchases.Document;

tableextension 50651 "FSO PRD Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(50301; "FSO PRD Order Type"; Code[20])
        {
            Caption = 'Order Type';
            DataClassification = CustomerContent;
            TableRelation = "FSO PRD Order Type"."Order Type" where(Blocked = const(false));
            Editable = false;
            ToolTip = 'Specifies the order Type of the Purchase Document';
        }
        field(50302; "FSO PRD Sub Order Type"; Code[20])
        {
            Caption = 'Sub Order Type';
            DataClassification = CustomerContent;
            TableRelation = "FSO PRD Order Type"."Sub Order Type" where("Order Type" = field("FSO PRD Order Type"), Blocked = filter(false));
            Editable = false;
            ToolTip = 'Specifies the Sub order Type of the Purchase Document';
        }
        field(50303; "FSO PRD Branch"; Code[20])
        {
            Caption = 'Branch';
            DataClassification = CustomerContent;
            TableRelation = "FSO PRD Branch";
            Editable = false;
            ToolTip = 'Specifies the branch of the Purchase Document';
        }
    }
    trigger OnInsert()
    begin
        UpdateToPurchLine(Rec);
    end;

    // trigger OnModify()
    // begin
    //     PurchHeader := this.GetPurchHeader();
    //     if (PurchHeader."FSO PRD Order Type" <> xRec."FSO PRD Order Type") or (PurchHeader."FSO PRD Sub Order Type" <> xRec."FSO PRD Sub Order Type") then
    //         UpdateToPurchLine(Rec)
    // end;

    internal procedure UpdateToPurchLine(var PurchaseLine: Record "Purchase Line")
    begin
        PurchHeader := this.GetPurchHeader();
        if Rec."Document Type" = PurchaseLine."Document Type"::Order then begin
            if PurchHeader."FSO PRD Order Type" <> '' then
                Rec."FSO PRD Order Type" := PurchHeader."FSO PRD Order Type";
            if PurchHeader."FSO PRD Sub Order Type" <> '' then
                Rec."FSO PRD Sub Order Type" := PurchHeader."FSO PRD Sub Order Type";
            if PurchHeader."FSO PRD Branch" <> '' then
                Rec."FSO PRD Branch" := PurchHeader."FSO PRD Branch";
        end;
    end;

    var
        PurchHeader: Record "Purchase Header";

}
