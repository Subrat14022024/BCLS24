namespace BCLS.BCLS;
using Microsoft.Inventory.Item;

pageextension 52111 "FSO Item Card Ext" extends "LSC Retail Item Card"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(ItemImages; "FSO Item Images FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
    }
}

