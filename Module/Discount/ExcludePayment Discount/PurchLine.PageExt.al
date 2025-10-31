namespace BCLS.BCLS;

using Microsoft.Purchases.Document;
using Microsoft.Finance.GeneralLedger.Account;

pageextension 50113 PurchLine extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Exclude from Payment Discount"; Rec."Exclude from Payment Discount")
            {
                ApplicationArea = Basic, Suite;
                Editable = gEditable;
                trigger OnValidate()
                var
                    GLAccount: Record "G/L Account";
                    TEXT001_Lbl: Label 'Excl. Payment Discount in Purchase Invoice Line does not match the values of the G/L Account. Do you still want to Continue?';
                begin
                    if xRec."Exclude from Payment Discount" <> Rec."Exclude from Payment Discount" then
                        if Rec.Type = Rec.Type::"G/L Account" then begin
                            GLAccount.Get(Rec."No.");
                            if rec."Exclude from Payment Discount" <> GLAccount."Exclude from Payment Discount" then
                                if not Confirm(TEXT001_Lbl, false) then
                                    Error('');
                        end;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if Rec.Type = Rec.Type::"G/L Account" then
            gEditable := true
        else
            gEditable := false;
    end;

    var
        gEditable: Boolean;
}
