namespace BCLS.BCLS;

using Microsoft.FixedAssets.FixedAsset;

pageextension 50115 "Fixed Asset Card" extends "Fixed Asset Card"
{
    layout
    {
        modify("FA Location Code")
        {
            ShowMandatory = true;
        }

    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ConfirmationMessageLbl: label 'FA Location Code must have a value in Fixed Asset: No.=%1. It cannot be zero or empty. \\ Do you want to continue ?', Locked = true, Comment = '%1 Fixed Asset No.';
    begin
        if Rec."FA Location Code" = '' then
            exit(Confirm(ConfirmationMessageLbl, false, Rec."No."));
    end;
}
