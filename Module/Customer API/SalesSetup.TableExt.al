namespace BCLS.BCLS;

using Microsoft.Sales.Customer;
using Microsoft.Sales.Setup;

tableextension 55101 SalesSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(55101; "Cust. API"; Text[250])
        {
            Caption = 'Cust. API';
            DataClassification = CustomerContent;
            toolTip = 'Specifies the Customer API URL.';
        }
        field(55102; "Cust. API Token"; Text[50])
        {
            Caption = 'Cust. API Token';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the token for Customer API.';
        }
        field(55103; "Cust. Default Template"; Code[20])
        {
            Caption = 'Cust. Default Template';
            DataClassification = CustomerContent;
            TableRelation = "Customer Templ.".Code;
            ToolTip = 'Specifies the default customer template code.';
        }
        field(55104; Separator; Text[1])
        {
            Caption = 'Separator';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the separator for multiple values in Customer API and token fields.';
        }
    }
}
