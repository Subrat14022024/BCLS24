namespace FSFINBELTEST.FSFINBELTEST;

#pragma warning disable AW0006
page 59101 "Import Gen Jnl Conversion"
#pragma warning restore AW0006
{
    Caption = 'Import Gen Jnl Conversion';
    PageType = List;
    SourceTable = "Import Gen Jnl Conversion";
    LinksAllowed = false;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Table Name field.';
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Field No. field.';
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Field Name field.';
                }
                field("Value"; Rec."Value")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Value field.';
                }
                field("New Value"; Rec."New Value")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the New Value field.';
                }
            }
        }
    }
}
