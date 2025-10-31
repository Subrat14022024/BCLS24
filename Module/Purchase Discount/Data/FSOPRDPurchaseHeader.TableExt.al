namespace FSO_Purchase.Discount;

using Microsoft.Purchases.Document;

tableextension 50301 "FSO PRD Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(50301; "FSO PRD Order Type"; Code[20])
        {
            Caption = 'Order Type';
            DataClassification = CustomerContent;
            TableRelation = "FSO PRD Order Type"."Order Type";
            ToolTip = 'Specifies the order Type of the Purchase Document';
            trigger OnValidate()
            begin
                Rec.UpdatePurchLines(CopyStr(FieldName("FSO PRD Order Type"), 1, 100), true);
            end;
        }
        field(50302; "FSO PRD Sub Order Type"; Code[20])
        {
            Caption = 'Sub Order Type';
            DataClassification = CustomerContent;
            TableRelation = "FSO PRD Order Type"."Sub Order Type" where("Order Type" = field("FSO PRD Order Type"), Blocked = filter(false));
            ToolTip = 'Specifies the Sub order Type of the Purchase Document';
            trigger OnValidate()
            begin
                Rec.UpdatePurchLines(CopyStr(FieldName("FSO PRD Sub Order Type"), 1, 100), true);
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
                Rec.UpdatePurchLines(CopyStr(FieldName("FSO PRD Branch"), 1, 100), true);
            end;
        }

        field(50304; "FSO PRD LSC Attrib 1 Code"; Text[30])
        {
            CaptionClass = '98,27,10001409';
            Caption = 'Attrib 1 Code';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the fourth attribute for the item on the document.';

            trigger OnLookup()
            var
                AttributeSetup: Record "LSC Attribute Setup";
                gAttributeUtils: Codeunit "LSC Attribute Utils";
                lAnswer: Text[250];
                lActionReturned: Action;
            begin
                AttributeSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
                AttributeSetup.SetLoadFields("Item Attrib. 1 Code");
                AttributeSetup.Get();
                lAnswer := gAttributeUtils.LookupOptionValues(0, AttributeSetup."Item Attrib. 1 Code", lActionReturned);
                if lActionReturned = ACTION::LookupOK then
                    Rec.Validate("FSO PRD LSC Attrib 1 Code", CopyStr(lAnswer, 1, 30));
            end;
        }
    }
}
