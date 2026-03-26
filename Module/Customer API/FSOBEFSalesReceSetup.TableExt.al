namespace FSO_FINBE.CustomerCreation;

using Microsoft.Sales.Customer;
using Microsoft.Sales.Setup;

tableextension 50209 "FSO BEF Sales & Rece. Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50200; "FSO BEF Cust. API"; Text[250])
        {
            Caption = 'Cust. API';
            DataClassification = CustomerContent;
            toolTip = 'Specifies the Customer API URL.';
        }
        field(50201; "FSO BEF Cust. API Token"; Text[50])
        {
            Caption = 'Cust. API Token';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the token for Customer API.';
        }
        field(50202; "FSO BEF Cust. Default Template"; Code[20])
        {
            Caption = 'Cust. Default Template';
            DataClassification = CustomerContent;
            TableRelation = "Customer Templ.".Code;
            ToolTip = 'Specifies the default customer template code.';
        }
        field(50203; "FSO BEF Separator"; Text[1])
        {
            Caption = 'Separator';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the separator for multiple values in Customer API and token fields.';
        }
    }
}
