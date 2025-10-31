namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Ledger;

tableextension 50110 "General Ledger Entry" extends "G/L Entry"
{
    fields
    {
        field(50100; "FOS Selected"; Boolean)
        {
            Caption = 'Selected';
            ToolTip = 'Indicates whether the G/L Entry is selected for further processing.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50101; "FSO Selected By User"; Code[50])
        {
            Caption = 'Selected By User';
            ToolTip = 'Indicates the user who selected the G/L Entries for further processing.';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}
