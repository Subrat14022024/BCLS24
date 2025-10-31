namespace BCLS.BCLS;

using Microsoft.Sales.Customer;

pageextension 50118 Customer extends "LSC Retail Customer Card"
{
    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields("Balance (LCY)");
        Message('%1', Format(Rec."Balance (LCY)", 0, 9));
    end;
}
