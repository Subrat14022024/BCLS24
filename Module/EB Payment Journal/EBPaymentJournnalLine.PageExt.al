namespace BCLS.BCLS;

using Microsoft.Bank.Payment;

pageextension 50105 EBPaymentJournnalLine extends "EB Payment Journal"
{
    layout
    {
        addafter(Status)
        {
            field("Due Date VLE"; Rec."Due Date VLE")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Due Date from VLE.';
            }
            field("Pmt. Discount Date VLE"; Rec."Pmt. Discount Date VLE")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Pmt. Discount Date from VLE.';
            }
        }
    }
}
