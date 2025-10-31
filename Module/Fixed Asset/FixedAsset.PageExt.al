namespace BCLS.BCLS;

using Microsoft.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.Ledger;
pageextension 55111 "Fixed Asset" extends "Fixed Asset Card"
{
    layout
    {
        addbefore(AddMoreDeprBooks)
        {
            field("FSOBEFNegative Acquisition"; Rec."FSOBEF Neg. Acquisition Value")
            {
                ApplicationArea = All;
                Editable = AllowEditNegAcqValue;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        FALedgerEntry: Record "FA Ledger Entry";
    begin
        FALedgerEntry.SetRange("FA No.", Rec."No.");
        if FALedgerEntry.IsEmpty() then
            AllowEditNegAcqValue := true
        else
            AllowEditNegAcqValue := false;
    end;

    var
        AllowEditNegAcqValue: Boolean;
}