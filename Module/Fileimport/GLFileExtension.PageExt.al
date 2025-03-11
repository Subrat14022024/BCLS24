namespace FSFINBELTEST.FSFINBELTEST;

using Microsoft.Finance.GeneralLedger.Setup;

pageextension 59103 GLFileExtension extends "General Ledger Setup"
{
    layout
    {
        addlast(content)
        {
            group(FileImport)
            {
                field("File Share"; Rec."File Share")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the File Share field.';
                }
                field("Path Import Gen. Jnl Line"; Rec."Path Import Gen. Jnl Line")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Path Import Gen. Jnl Line field.';
                }
                field("Path Import Gen. Jnl Line Save"; Rec."Path Import Gen. Jnl Line Save")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Path Import Gen. Jnl Line Save field.';
                }
                field("No. Series Import Gen. Journal"; Rec."No. Series Import Gen. Journal")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Series Import Gen. Journal field.';
                }
                field("Import Gen. Jnl. Template"; Rec."Import Gen. Jnl. Template")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Gen. Jnl. Template field.';
                }
                field("Import Gen. Jnl. Batch"; Rec."Import Gen. Jnl. Batch")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Gen. Jnl. Batch field.';
                }
            }
        }
    }

}
