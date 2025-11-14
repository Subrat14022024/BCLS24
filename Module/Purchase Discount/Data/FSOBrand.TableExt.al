namespace FSO_Purchase.Discount;

using Microsoft.Inventory.Item;

tableextension 50301 "FSO Brand" extends Item
{
    fields
    {
        field(50301; "FSO Brand"; Code[20])
        {
            Caption = 'Brand';
            DataClassification = CustomerContent;
            TableRelation = "FSO Brand"."Code";
            ToolTip = 'Specifies the brand of the item.';
        }
    }
}
