namespace FSO_Purchase.ExpectedDates;

using Microsoft.Purchases.Document;

tableextension 50138 "FSO PUR Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(50101; "FSO PUR Last Exp. Rcpt. Date"; Date)
        {
            Caption = 'Last Expected Receipt Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Last date that you want the vendor to deliver to the ship-to address.';
        }
        modify("Requested Receipt Date")
        {
            Caption = 'First Expected Receipt Date';
        }
    }
}
