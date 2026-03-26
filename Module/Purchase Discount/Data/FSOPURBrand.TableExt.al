namespace FSO_Purchase.Discount;

using Microsoft.Inventory.Item;

tableextension 50301 "FSOPUR Brand" extends Item
{
    fields
    {
        field(50301; "FSOPUR Brand"; Code[20])
        {
            Caption = 'Brand';
            DataClassification = CustomerContent;
            TableRelation = "FSO PUR Brand"."Code";
            ToolTip = 'Specifies the brand of the item.';
            trigger OnValidate()
            var
                FSOPURBrand: Record "FSO PUR Brand";
            begin
                if "FSOPUR Brand" <> '' then begin
                    FSOPURBrand.ReadIsolation(IsolationLevel::ReadUncommitted);
                    FSOPURBrand.SetLoadFields("No Stock Posting");
                    if FSOPURBrand.Get(Rec."FSOPUR Brand") then
                        if FSOPURBrand."No Stock Posting" then
                            Rec.Validate(Type, type::"Non-Inventory");
                end;
            end;
        }
    }
}
