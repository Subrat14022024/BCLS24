namespace FSFINBELTEST.FSFINBELTEST;

page 59100 "Import Gen. Jnl Lines"
{
    ApplicationArea = All;
    Caption = 'Import Gen. Jnl Lines';
    PageType = List;
    SourceTable = "Import General Journal Lines";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(LineNo; Rec.LineNo)
                {
                    ToolTip = 'Specifies the value of the LineNo field.';
                }
                field(Veld_01; Rec.Veld_01)
                {
                    ToolTip = 'Specifies the value of the Veld_01 field.';
                }
                field(Veld_02; Rec.Veld_02)
                {
                    ToolTip = 'Specifies the value of the Veld_02 field.';
                }
                field(Veld_03; Rec.Veld_03)
                {
                    ToolTip = 'Specifies the value of the Veld_03 field.';
                }
                field(Veld_04; Rec.Veld_04)
                {
                    ToolTip = 'Specifies the value of the Veld_04 field.';
                }
                field(Veld_05; Rec.Veld_05)
                {
                    ToolTip = 'Specifies the value of the Veld_05 field.';
                }
                field(Veld_06; Rec.Veld_06)
                {
                    ToolTip = 'Specifies the value of the Veld_06 field.';
                }
                field(Veld_07; Rec.Veld_07)
                {
                    ToolTip = 'Specifies the value of the Veld_07 field.';
                }
                field(Veld_08; Rec.Veld_08)
                {
                    ToolTip = 'Specifies the value of the Veld_08 field.';
                }
                field(Veld_09; Rec.Veld_09)
                {
                    ToolTip = 'Specifies the value of the Veld_09 field.';
                }
                field(Veld_10; Rec.Veld_10)
                {
                    ToolTip = 'Specifies the value of the Veld_10 field.';
                }
                field(Veld_11; Rec.Veld_11)
                {
                    ToolTip = 'Specifies the value of the Veld_11 field.';
                }
                field(Veld_12; Rec.Veld_12)
                {
                    ToolTip = 'Specifies the value of the Veld_12 field.';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(Conversion)
            {
                ApplicationArea = All;
                Caption = 'Conversion';
                Image = UnitConversions;
                RunObject = page "Import Gen Jnl Conversion";
                ToolTip = 'Executes the Caption action.';
            }
        }
        area(Processing)
        {
            action("Read Data")
            {
                Image = Import;
                ToolTip = 'Executes the Read Data action.';
                trigger OnAction()
                begin
                    ImportLogic.ImportGenJnlLineData();
                end;

            }
            action("Update Data")
            {
                ToolTip = 'Executes the Update Data action.';
                Image = UpdateXML;
                trigger OnAction()
                begin
                    ImportLogic.Updatedata();
                end;
            }
            action("Process Data - Transfer")
            {
                ToolTip = 'Executes the Process Data - Transfer action.';
                Image = TransferToGeneralJournal;
                trigger OnAction()
                begin
                    ImportLogic.CreateGenJnlLine();
                end;
            }
        }
    }
    var
        ImportLogic: Codeunit "ImportLogic";
}
