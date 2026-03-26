namespace FSO_FINBE.CustomerCreation;

using Microsoft.Sales.Setup;

pageextension 50210 "FSO BEF Sales & Receivable" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(Content)
        {
            group(FSOAPIGROUP)
            {
                Caption = 'FSO API';
                field("FSO BEF Cust. API"; Rec."FSO BEF Cust. API")
                {
                    ApplicationArea = All;
                }
                field("FSO BEF Cust. API Token"; Rec."FSO BEF Cust. API Token")
                {
                    ApplicationArea = All;
                }
                field("FSO BEF Cust. Default Template"; Rec."FSO BEF Cust. Default Template")
                {
                    ApplicationArea = All;
                }
                field("FSO BEF Separator"; Rec."FSO BEF Separator")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
