namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Account;

tableextension 50108 "GL AccountExt" extends "G/L Account"
{
    fields
    {
        field(50100; "Exclude from Payment Discount"; Boolean)
        {
            Caption = 'Exclude from Payment Discount';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether the G/L account is excluded from payment discount calculations.';
        }
    }
}
