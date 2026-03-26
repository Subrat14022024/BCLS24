namespace FSO_Purchase.ExpectedDates;

pageextension 50128 "FSO PUR Purchase Header" extends "LSC Retail Purchase Order"
{
    layout
    {
        addafter("Expected Receipt Date")
        {
            field("FSO PUR Last Expected Receipt Date"; Rec."FSO PUR Last Exp. Rcpt. Date")
            {
                ApplicationArea = all;
            }
        }
        movebefore("FSO PUR Last Expected Receipt Date"; "TCOG BLM Requested Receipt Date")
    }
}
