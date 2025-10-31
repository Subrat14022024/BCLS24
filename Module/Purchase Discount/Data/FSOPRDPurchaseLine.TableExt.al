namespace FSO_Purchase.Discount;

using Microsoft.Purchases.Document;

tableextension 50302 "FSO PRD Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(50301; "FSO PRD Order Type"; Code[20])
        {
            Caption = 'Order Type';
            DataClassification = CustomerContent;
            TableRelation = "FSO PRD Order Type"."Order Type";
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
        UpdateToPurchLine()
    end;

    trigger OnModify()
    begin
        PurchHeader := this.GetPurchHeader();
        if (PurchHeader."FSO PRD Order Type" <> xRec."FSO PRD Order Type") or (PurchHeader."FSO PRD Sub Order Type" <> xRec."FSO PRD Sub Order Type") then
            UpdateOrderSubOrderTypeAndBranch()
    end;

    internal procedure UpdateOrderSubOrderTypeAndBranch()
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then begin
            PurchHeader := this.GetPurchHeader();
            PurchHeader.TestField("FSO PRD Order Type");
            PurchHeader.TestField("FSO PRD Sub Order Type");
            PurchHeader.TestField("FSO PRD Branch");
            UpdateToPurchLines()
        end;
    end;

    local procedure UpdateToPurchLine()
    begin
        PurchHeader := this.GetPurchHeader();
        if Rec."Document Type" = Rec."Document Type"::Order then begin
            Rec."FSO PRD Order Type" := PurchHeader."FSO PRD Order Type";
            Rec."FSO PRD Sub Order Type" := PurchHeader."FSO PRD Sub Order Type";
            Rec."FSO PRD Branch" := PurchHeader."FSO PRD Branch";
        end;
    end;

    local procedure UpdateToPurchLines()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchHeader := this.GetPurchHeader();
        PurchaseLine.SetRange("Document Type", "Document Type"::Order);
        PurchaseLine.SetRange("Document No.", Rec."Document No.");
        if not PurchaseLine.IsEmpty() then
            if PurchaseLine.FindSet() then
                repeat
                    PurchaseLine."FSO PRD Order Type" := PurchHeader."FSO PRD Order Type";
                    PurchaseLine."FSO PRD Sub Order Type" := PurchHeader."FSO PRD Sub Order Type";
                    PurchaseLine."FSO PRD Branch" := PurchHeader."FSO PRD Branch";
                    PurchaseLine.Modify(false);
                until PurchaseLine.Next() = 0;
    end;

    var
        PurchHeader: Record "Purchase Header";

}
