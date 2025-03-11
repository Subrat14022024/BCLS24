namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50106 PaymentJournalExtn extends "Payment Journal"
{
    layout
    {
        addafter("Amount (LCY)")
        {
            field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';
            }
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the due date on the entry.';
            }
            field("Orig. Pmt. Disc. Possible"; Rec."Orig. Pmt. Disc. Possible")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Original Pmt. Disc. Possible field.';
            }
        }
    }
}
