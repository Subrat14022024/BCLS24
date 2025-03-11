table 59102 "Import Gen Jnl Conversion"
{
    Caption = 'Import Gen Jnl Conversion';
    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
            DataClassification = CustomerContent;
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
            TableRelation = Field."No." where(TableNo = field("Table ID"));
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(4; "Table Name"; Text[30])
        {
            Caption = 'Table Name';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObj."Object Name" where("Object Type" = const(Table), "Object ID" = field("Table ID")));
            Editable = false;
        }
        field(5; "Field Name"; Text[30])
        {
            Caption = 'Field Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table ID"), "No." = field("Field No.")));
        }
        field(6; "Value"; Text[250])
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
        field(7; "New Value"; Text[30])
        {
            Caption = 'New Value';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Table ID", "Field No.", "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "Entry No." = 0 then
            "Entry No." := GetNewEntryNo();
    end;

    local procedure GetNewEntryNo(): Integer
    var
        ImportGenJnlConversion: Record "Import Gen Jnl Conversion";
    begin
        if ImportGenJnlConversion.FindLast() then
            exit(ImportGenJnlConversion."Entry No." + 1)
        else
            exit(1);
    end;

}
