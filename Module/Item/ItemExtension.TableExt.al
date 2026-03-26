namespace FSO_Purchase.VendorItemColor;

using Microsoft.Inventory.Item;
tableextension 58401 "Item Extension" extends Item
{
    fields
    {
        field(50100; "Vendor Item Color"; Code[100])
        {
            OptimizeForTextSearch = true;
            DataClassification = CustomerContent;
            TableRelation = "Vendor Item Color".Code where(Code = field("Vendor Item Color"));
            ValidateTableRelation = false; //ValidateTableRelation = false because if value will not available in 'Vendor Item Color', system will not through error
            ToolTip = 'Specifies Vendor Item Color';

            trigger OnValidate()
            var
                ItemVendorColorRec: Record "Vendor Item Color";
            begin
                if not ItemVendorColorRec.Get(Rec."Vendor Item Color") then begin
                    ItemVendorColorRec.Init();
                    ItemVendorColorRec.Code := Rec."Vendor Item Color";
                    ItemVendorColorRec.Insert();
                end;
                this.HasDuplicateVendorItemAndColor();
            end;

        }

        modify("Vendor Item No.")
        {
            trigger OnAfterValidate()
            begin
                this.HasDuplicateVendorItemAndColor();
            end;
        }
    }

    procedure HasDuplicateVendorItemAndColor()
    var
        ItemTable: Record Item;
        ErrMsgLbl: Label 'Combination of vendor item no and vendor item color already exists for %1 item', Comment = '%1 for itemNo.';
    begin
        ItemTable.SetLoadFields("No.");
        ItemTable.ReadIsolation(IsolationLevel::ReadUncommitted);
        if (Rec."Vendor Item No." <> '') and (Rec."Vendor Item Color" <> '') then begin
            ItemTable.SetRange("Vendor Item No.", Rec."Vendor Item No.");
            ItemTable.SetRange("Vendor Item Color", Rec."Vendor Item Color");
            if ItemTable.FindFirst() then
                Error(ErrMsgLbl, ItemTable."No.");
        end;
    end;
}