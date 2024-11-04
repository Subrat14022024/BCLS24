namespace BCLS.BCLS;

using Microsoft.Integration.Entity;

tableextension 50102 FSONBCPurchInvEntityAggrExtn extends "Purch. Inv. Entity Aggregate"
{
    fields
    {
        field(50100; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
            DataClassification = CustomerContent;
        }

    }
}
