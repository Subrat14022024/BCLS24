namespace FSFINBELTEST.FSFINBELTEST;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Journal;

tableextension 59100 GLFileExtension extends "General Ledger Setup"
{
    fields
    {
        field(50110; "Path Import Gen. Jnl Line"; Text[250])
        {
            Caption = 'Path Import Gen. Jnl Line';
            DataClassification = CustomerContent;
        }
        field(50111; "Path Import Gen. Jnl Line Save"; Text[250])
        {
            Caption = 'Path Import Gen. Jnl Line Save';
            DataClassification = CustomerContent;
        }
        field(50112; "File Share"; Code[100])
        {
            Caption = 'File Share';
            DataClassification = CustomerContent;
        }
        field(50113; "No. Series Import Gen. Journal"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50114; "Import Gen. Jnl. Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name where("Page ID" = const(39));

            DataClassification = CustomerContent;
        }
        field(50105; "Import Gen. Jnl. Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Import Gen. Jnl. Template"), "Bal. Account Type" = const("G/L Account"));
            DataClassification = CustomerContent;
        }
    }
}
