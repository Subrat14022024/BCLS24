namespace FINBC.FINBC;

using Microsoft.Bank.BankAccount;

tableextension 50126 bankaccextn extends "Bank Account"
{
    fields
    {
        field(50101; "Auto Post CODA Journals"; Boolean)
        {
            Caption = 'Auto Post CODA Journals';
            DataClassification = ToBeClassified;
        }
    }
}
