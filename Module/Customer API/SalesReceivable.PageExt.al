namespace BCLS.BCLS;

using Microsoft.Sales.Setup;

pageextension 55101 "Sales & Receivable" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(Content)
        {
            group(FSOAPIGROUP)
            {
                Caption = 'FSO API';
                field("Cust. API"; Rec."Cust. API")
                {
                    ApplicationArea = All;
                }
                field("Cust. API Token"; Rec."Cust. API Token")
                {
                    ApplicationArea = All;
                }
                field("Cust. Default Template"; Rec."Cust. Default Template")
                {
                    ApplicationArea = All;
                }
                field(Separator; Rec.Separator)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
