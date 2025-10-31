namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Account;

pageextension 50112 "General LedgerExt" extends "G/L Account Card"
{
    layout
    {
        addlast("General")
        {
            field("Exclude from Payment Discount"; Rec."Exclude from Payment Discount")
            {
                ApplicationArea = All;
            }
        }
    }
}
