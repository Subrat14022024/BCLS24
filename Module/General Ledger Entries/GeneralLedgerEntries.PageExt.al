namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Ledger;

pageextension 50116 "General Ledger Entries" extends "General Ledger Entries"
{
    trigger OnOpenPage()
    var
        GLEntry: Record "G/L Entry";
        InitialRecordsLoaded: Text;
    begin
        InitialRecordsLoaded := Rec.GetView();
        GLEntry.Reset();
        GLEntry.SetView(InitialRecordsLoaded);
        GLEntry.SetRange(Reviewed, false);
        CurrPage.SetTableView(GLEntry);
    end;
}
