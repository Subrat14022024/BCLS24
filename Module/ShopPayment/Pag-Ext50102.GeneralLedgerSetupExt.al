namespace BCLS.BCLS;

using Microsoft.Finance.GeneralLedger.Setup;

pageextension 50102 GeneralLedgerSetupExt extends "General Ledger Setup"
{
    layout
    {
        addlast(VATReportingDateGroup)
        {
            group(ShopPayment)
            {
                Caption = 'Shop Payment Setup';
                field("Gen. Jnl. Template Safe Jrnl."; Rec."Gen. Jnl. Template Safe Jrnl.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Define General Template for Safe Entries';
                }
                field("Gen. Jnl. Batch Safe Jrnl."; Rec."Gen. Jnl. Batch Safe Jrnl.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Define General Batch for Safe Entries';
                }
                field("Default Shop Payment Journal"; Rec."Default Shop Payment Journal")
                {
                    ApplicationArea = All;
                    ToolTip = 'Define General Template for shop Entries';
                }
                field("Default Shop Payment Batch"; Rec."Default Shop Payment Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Define General Batch for Shop Entries';
                }
                field("Create Shop Inv DateFilter"; Rec."Create Shop Inv DateFilter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Define General Batch for Shop Entries';
                }
            }
        }
    }

}
