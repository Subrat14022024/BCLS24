namespace FSO_Purchase.Discount;

using Microsoft.Purchases.Document;

tableextension 50650 "FSO PRD Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(50301; "FSO PRD Order Type"; Code[20])
        {
            Caption = 'Order Type';
            DataClassification = CustomerContent;
            TableRelation = "FSO PRD Order Type"."Order Type" where(Blocked = const(false));
            ToolTip = 'Specifies the order Type of the Purchase Document';
            trigger OnValidate()

            begin
                xRec := Rec;
                // Rec.UpdatePurchLinesByFieldNo(FieldNo("FSO PRD Order Type"), CurrFieldNo <> 0);
                if xRec."FSO PRD Order Type" <> Rec."FSO PRD Order Type" then
                    Rec.RecreatePurchLines(CopyStr(FieldCaption("FSO PRD Order Type"), 1, MaxStrLen("FSO PRD Order Type")));


            end;

            // trigger OnLookup()
            // var
            //     FSOPRDOrderTypeRec: Record "FSO PRD Order Type";
            //     FSOPRDOrderType: Page "FSO PRD Order Type";
            // begin
            //     FSOPRDOrderType.LookupMode := true;
            //     if FSOPRDOrderType.RunModal() = Action::LookupOK then
            //         FSOPRDOrderType.SetSelection(FSOPRDOrderTypeRec);
            //     Message('Text:%1\RecOrderType:%2\RecsubOrderType:%3', 'nothing', FSOPRDOrderTypeRec."Order Type", FSOPRDOrderTypeRec."Sub Order Type");
            //     Message('Text:%1\RecOrderType:%2\RecsubOrderType:%3', FSOPRDOrderType.GetSelectionFilterForOrderType(FSOPRDOrderTypeRec), FSOPRDOrderTypeRec."Order Type", FSOPRDOrderTypeRec."Sub Order Type");
            // end;

        }
        field(50302; "FSO PRD Sub Order Type"; Code[20])
        {
            Caption = 'Sub Order Type';
            DataClassification = CustomerContent;
            TableRelation = "FSO PRD Order Type"."Sub Order Type" where(Blocked = const(false));
            ToolTip = 'Specifies the Sub order Type of the Purchase Document';
            trigger OnValidate()
            begin
                if xRec."FSO PRD Sub Order Type" <> Rec."FSO PRD Sub Order Type" then
                    Rec.RecreatePurchLines(CopyStr(FieldCaption("FSO PRD Sub Order Type"), 1, MaxStrLen("FSO PRD Sub Order Type")));
            end;
        }
        field(50303; "FSO PRD Branch"; Code[20])
        {
            Caption = 'Branch';
            DataClassification = CustomerContent;
            TableRelation = "FSO PRD Branch";
            ToolTip = 'Specifies the branch of the Purchase Document';
            trigger OnValidate()
            begin
                if xRec."FSO PRD Branch" <> Rec."FSO PRD Branch" then
                    Rec.RecreatePurchLines(CopyStr(FieldCaption("FSO PRD Branch"), 1, MaxStrLen("FSO PRD Branch")));
            end;
        }
        field(50305; "FSO PRD Brand"; Code[20])
        {
            Caption = 'Brand';
            DataClassification = CustomerContent;
            TableRelation = "FSO PUR Brand".Code;
            ToolTip = 'Specifies the Brand of the Purchase Document';
            trigger OnValidate()
            begin
                if xRec."FSO PRD Brand" <> Rec."FSO PRD Brand" then
                    Rec.RecreatePurchLines(CopyStr(FieldCaption("FSO PRD Brand"), 1, MaxStrLen("FSO PRD Brand")));
            end;
        }
        // field(50306; "Last Expected Receipt Date"; Date)
        // {
        //     Caption = 'Last Expected Receipt Date';
        //     ToolTip = 'Specifies Last Expected Receipt Date and dates will be calculated automatically in case of reorders';
        // }
    }
}
