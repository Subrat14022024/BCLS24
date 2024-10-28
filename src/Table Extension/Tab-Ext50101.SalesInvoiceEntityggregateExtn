namespace BCLS.BCLS;

using Microsoft.Integration.Entity;
using Microsoft.Inventory.Location;

tableextension 50101 SalesInvoiceEntityggregateExtn extends "Sales Invoice Entity Aggregate"
{
    fields
    {
        field(50100; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(50101; "Location Id"; Guid)
        {
            Caption = 'Location Id';
            DataClassification = ToBeClassified;

        }
    }

}

