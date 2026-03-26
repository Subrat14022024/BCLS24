namespace BCLS.BCLS;
using Microsoft.Inventory.Item;
#if not FSOCLEAN27
pageextension 52111 "FSO Item Card Ext" extends "LSC Retail Item Card"
#endif
pageextension 52111 "FSO Item Card Ext" extends "LSC Retail Item"
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

