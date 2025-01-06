namespace FSO_NAVBCConnector.SalesInv;

using Microsoft.Integration.Entity;
tableextension 50101 FSONBCSalesInvEntityAggrExtn extends "Sales Invoice Entity Aggregate"
{
    fields
    {
        field(50001; "FSONBCPosting No."; Code[20])
        {
            Caption = 'Posting No.';
            DataClassification = CustomerContent;
        }
    }
}

