namespace FSOFIN.PayrollFileImport;

using System.Reflection;

table 50151 "FSOFINImportGenJnl Conversion"
{
    Caption = 'Import Gen Jnl Conversion';
    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Table ID field.';
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
            TableRelation = Field."No." where(TableNo = field("Table ID"));
            ToolTip = 'Specifies the value of the Field No. field.';
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Entry No. field.';
        }
        field(4; "Table Name"; Text[30])
        {
            Caption = 'Table Name';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObj."Object Name" where("Object Type" = const(Table), "Object ID" = field("Table ID")));
            Editable = false;
            ToolTip = 'Specifies the value of the Table Name field.';
        }
        field(5; "Field Name"; Text[30])
        {
            Caption = 'Field Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table ID"), "No." = field("Field No.")));
            ToolTip = 'Specifies the value of the Field Name field.';
        }
        field(6; "Value"; Text[250])
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Value field.';
        }
        field(7; "New Value"; Text[30])
        {
            Caption = 'New Value';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the New Value field.';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "Entry No." := GetNewEntryNo();
    end;

    local procedure GetNewEntryNo(): Integer
    var
        ImportGenJnlConversion: Record "FSOFINImportGenJnl Conversion";
    begin
        ImportGenJnlConversion.Reset();
        ImportGenJnlConversion.ReadIsolation(IsolationLevel::ReadUncommitted);
        ImportGenJnlConversion.SetLoadFields("Entry No.");
        if ImportGenJnlConversion.FindLast() then
            exit(ImportGenJnlConversion."Entry No." + 10000)
        else
            exit(10000);
    end;

}
