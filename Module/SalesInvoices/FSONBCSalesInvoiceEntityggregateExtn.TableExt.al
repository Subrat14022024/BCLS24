namespace BCLS.BCLS;

using Microsoft.Integration.Entity;
using Microsoft.Foundation.NoSeries;
using Microsoft.Inventory.Location;

tableextension 50101 SalesInvoiceEntityggregateExtn extends "Sales Invoice Entity Aggregate"
{
    fields
    {
        field(50001; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
            DataClassification = CustomerContent;
        }

    }
}

