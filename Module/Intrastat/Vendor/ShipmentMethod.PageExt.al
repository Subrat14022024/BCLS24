namespace BCLS.BCLS;

using Microsoft.Foundation.Shipping;

pageextension 58103 "Shipment Method" extends "Shipment Methods"
{
    layout
    {
        modify("Incoterm in Intrastat Decl.")
        {
            Visible = true;
        }
    }
}