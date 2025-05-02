namespace FSO_NAVBCConnector.Shoppayment;

using Microsoft.Finance.GeneralLedger.Setup;

pageextension 50102 FSONBCGeneralLedgerSetupExt extends "General Ledger Setup"
{
    layout
    {
        addlast(content)
        {
            group(FSONBCShopPayment)
            {
                Caption = 'Shop Payment Setup';
                field("FSONBCGenJnlTemplate Safe Jrnl"; Rec."FSONBCGenJnlTemplate Safe Jrnl")
                {
                    ApplicationArea = All;
                    ToolTip = 'Define General Template for Safe Entries';
                }
                field("FSONBCGenJnlBatch Safe Jrnl."; Rec."FSONBCGenJnlBatch Safe Jrnl.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Define General Batch for Safe Entries';
                }
                field("FSONBCDefault Shop Pmt. Jrnl"; Rec."FSONBCDefault Shop Pmt. Jrnl")
                {
                    ApplicationArea = All;
                    ToolTip = 'Define General Template for shop Entries';
                }
                field("FSONBCDefault Shop Pmt. Batch"; Rec."FSONBCDefault Shop Pmt. Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Define General Batch for Shop Entries';
                }
                field("FSONBCCreate Shop Inv DFilter"; Rec."FSONBCCreate Shop Inv DFilter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Define General Batch for Shop Entries';
                }
                group("Difference Posting")
                {
                    field("FSONBCProcess Difference"; Rec."FSONBCProcess Difference")
                    {
                        ApplicationArea = all;
                    }
                    field("FSONBCAuto Post Journals"; Rec."FSONBCAuto Post Journals")
                    {
                        ApplicationArea = all;
                    }
                    field("FSONBCMax. Difference Allowed"; Rec."FSONBCMax. Difference Allowed")
                    {
                        ApplicationArea = all;
                    }
                    field("FSONBCDifference GL A/c"; Rec."FSONBCDifference GL A/c")
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

}
