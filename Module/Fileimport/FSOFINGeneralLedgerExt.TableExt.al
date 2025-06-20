namespace FSOFIN.PayrollFileImport;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.Dimension;
using FSO_Integration.AFS;

tableextension 50151 "FSOFINGeneral Ledger Ext" extends "General Ledger Setup"
{
    fields
    {
        field(50150; "FSOFINPath Import Gen Jnl Line"; Text[250])
        {
            Caption = 'Path Import Gen. Jnl Line';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Path Import Gen. Jnl Line field.';
        }
        field(50151; "FSOFINPath Import Gen Jnl Save"; Text[250])
        {
            Caption = 'Path Import Gen. Jnl Line Save';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Path Import Gen. Jnl Line Save field.';
        }
        field(50152; "FSOFINFile Import File Share"; Code[100])
        {
            Caption = 'File Import File Share';
            DataClassification = CustomerContent;
            TableRelation = "FSOINTAzure File Service Setup";
            ToolTip = 'Specifies the value of the File Share field.';
        }
        field(50153; "FSOFINNo. Ser. Import Gen. Jnl"; Code[20])
        {
            Caption = 'No. Series Import Gen. Journal';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the No. Series Import Gen. Journal field.';
        }
        field(50154; "FSOFINImport Gen. Jnl. Templat"; Code[10])
        {
            Caption = 'Import Gen. Jnl. Template';
            TableRelation = "Gen. Journal Template".Name where("Page ID" = const(39));
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Import Gen. Jnl. Template field.';
        }
        field(50155; "FSOFINImport Gen. Jnl. Batch"; Code[10])
        {
            Caption = 'Import Gen. Jnl. Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("FSOFINImport Gen. Jnl. Templat"), "Bal. Account Type" = const("G/L Account"));
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Import Gen. Jnl. Batch field.';
        }
        field(50156; "FSOFINDef Dimension 1 Code"; Code[20])
        {
            Caption = 'Default Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Default Shortcut Dimension 1 Code.';
        }
    }
}
