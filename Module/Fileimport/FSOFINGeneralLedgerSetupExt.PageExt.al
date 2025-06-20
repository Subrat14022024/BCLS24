namespace FSOFIN.PayrollFileImport;

using Microsoft.Finance.GeneralLedger.Setup;

pageextension 50152 FSOFINGeneralLedgerSetupExt extends "General Ledger Setup"
{
    layout
    {
        addlast(content)
        {
            group(FSOFINFileImport)
            {
                Caption = 'Payroll File Import';
                field("FSOFINFile Share"; Rec."FSOFINFile Import File Share")
                {
                    ApplicationArea = all;
                }
                field("FSOFINPath Import Gen. Jnl Line"; Rec."FSOFINPath Import Gen Jnl Line")
                {
                    ApplicationArea = all;
                }
                field("FSOFINPath Import Gen. Jnl Line Save"; Rec."FSOFINPath Import Gen Jnl Save")
                {
                    ApplicationArea = all;
                }
                field("FSOFINNo. Series Import Gen. Journal"; Rec."FSOFINNo. Ser. Import Gen. Jnl")
                {
                    ApplicationArea = all;
                }
                field("FSOFINImport Gen. Jnl. Template"; Rec."FSOFINImport Gen. Jnl. Templat")
                {
                    ApplicationArea = all;
                }
                field("FSOFINImport Gen. Jnl. Batch"; Rec."FSOFINImport Gen. Jnl. Batch")
                {
                    ApplicationArea = all;
                }
                field("FSOFINDef Dimension 1 Code"; Rec."FSOFINDef Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}
