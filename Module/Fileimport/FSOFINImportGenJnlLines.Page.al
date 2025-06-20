namespace FSOFIN.PayrollFileImport;

page 50154 "FSOFINImport Gen Jnl Lines"
{
    Caption = 'Import Gen. Jnl Lines';
    PageType = List;
    SourceTable = "FSOFINImport Gen Journal Lines";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(LineNo; Rec."Line No.")
                {
                }
                field(Field_01; Rec.Field_01)
                {
                }
                field(Field_02; Rec.Field_02)
                {
                }
                field(Field_13; Rec.Field_13)
                {
                    StyleExpr = NameStyle;
                }
                field(Field_03; Rec.Field_03)
                {
                }
                field(Field_04; Rec.Field_04)
                {
                }
                field(Field_14; Rec.Field_14)
                {
                    StyleExpr = NameStyle;
                }
                field(Field_15; Rec.Field_15)
                {
                }
                field(Field_05; Rec.Field_05)
                {
                }
                field(Field_06; Rec.Field_06)
                {
                }
                field(Field_07; Rec.Field_07)
                {
                }
                field(Field_08; Rec.Field_08)
                {
                }
                field(Field_09; Rec.Field_09)
                {
                }
                field(Field_10; Rec.Field_10)
                {
                }
                field(Field_11; Rec.Field_11)
                {
                }
                field(Field_12; Rec.Field_12)
                {
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
                RunObject = page "FSOFINImportGenJnl Conversion";
                ToolTip = 'Executes the Caption action.';
            }
        }
        area(Processing)
        {
            action("Read Data")
            {
                ApplicationArea = all;
                Image = Import;
                ToolTip = 'Executes the Read Data action.';
                trigger OnAction()
                begin
                    FSOFINPayrollFileImportMgmt.ImportGenJnlLineData();
                end;

            }
            action("Update Data")
            {
                ApplicationArea = all;
                ToolTip = 'Executes the Update Data action.';
                Image = UpdateXML;
                trigger OnAction()
                begin
                    FSOFINPayrollFileImportMgmt.UpdateData();
                end;
            }
            action("Process Data - Transfer")
            {
                ApplicationArea = all;
                ToolTip = 'Executes the Process Data - Transfer action.';
                Image = TransferToGeneralJournal;
                trigger OnAction()
                begin
                    FSOFINPayrollFileImportMgmt.CreateGenJnlLine();
                    FSOFINPayrollFileImportMgmt.DeleteProcessedLine();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        ChangeNameStyle(PageStyle::Unfavorable);
    end;

    local procedure ChangeNameStyle(NewPageStyle: PageStyle)
    begin
        NameStyle := Format(NewPageStyle);
    end;

    var
        FSOFINPayrollFileImportMgmt: Codeunit "FSOFINPayroll File Import";
        NameStyle: Text;
}
