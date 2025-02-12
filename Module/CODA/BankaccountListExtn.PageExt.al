namespace FINBC.FINBC;

using Microsoft.Bank.BankAccount;
using Microsoft.API.Webhooks;

pageextension 50128 BankaccountListExtn extends "Bank Account List"
{
    actions
    {
        addafter("&Import CODA File")
        {
            action("Import & Process Coda")
            {
                ApplicationArea = All;
                Caption = 'Automatic Import and Process';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "API Routes";
                ToolTip = 'This action will import and process for all coda files';
            }
        }
    }
}
