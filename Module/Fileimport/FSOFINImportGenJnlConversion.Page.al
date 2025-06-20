namespace FSOFIN.PayrollFileImport;

#pragma warning disable AW0006 // Should not be searchable
page 50153 "FSOFINImportGenJnl Conversion"
#pragma warning restore AW0006
{
    Caption = 'Import Gen Jnl Conversion';
    PageType = List;
    SourceTable = "FSOFINImportGenJnl Conversion";
    LinksAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Table ID"; Rec."Table ID")
                {
                }
                field("Table Name"; Rec."Table Name")
                {
                }
                field("Field No."; Rec."Field No.")
                {
                }
                field("Field Name"; Rec."Field Name")
                {
                }
                field("Value"; Rec."Value")
                {
                }
                field("New Value"; Rec."New Value")
                {
                }
            }
        }
    }
}
