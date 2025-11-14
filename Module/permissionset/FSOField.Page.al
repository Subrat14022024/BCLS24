namespace BCLS.BCLS;

using System.Reflection;

page 50901 "FSO Field"
{
    ApplicationArea = All;
    Caption = 'Field';
    PageType = List;
    SourceTable = "Field";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("App Package ID"; Rec."App Package ID")
                {
                    ToolTip = 'Specifies the value of the App Package ID field.', Comment = '%';
                }
                field("App Runtime Package ID"; Rec."App Runtime Package ID")
                {
                    ToolTip = 'Specifies the value of the App Runtime Package ID field.', Comment = '%';
                }
                field(Class; Rec.Class)
                {
                    ToolTip = 'Specifies the type of class. Normal is data entry, FlowFields calculate and display results immediately, and FlowFilters display results based on user-defined filter values that affect the calculation of a FlowField.';
                }
                field("DataClassification"; Rec."DataClassification")
                {
                    ToolTip = 'Specifies the data classification.';
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies the value of the Enabled field.', Comment = '%';
                }
                field(ExternalName; Rec.ExternalName)
                {
                    ToolTip = 'Specifies the value of the ExternalName field.', Comment = '%';
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ToolTip = 'Specifies the caption of the field, that is, the name that will be shown in the user interface.';
                }
                field(FieldName; Rec.FieldName)
                {
                    ToolTip = 'Specifies the name of the field in the table.';
                }
                field(IsPartOfPrimaryKey; Rec.IsPartOfPrimaryKey)
                {
                    ToolTip = 'Specifies the value of the IsPartOfPrimaryKey field.', Comment = '%';
                }
                field(Len; Rec.Len)
                {
                    ToolTip = 'Specifies the value of the Len field.', Comment = '%';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the ID number of the field in the table.';
                }
                field(ObsoleteReason; Rec.ObsoleteReason)
                {
                    ToolTip = 'Specifies the value of the ObsoleteReason field.', Comment = '%';
                }
                field(ObsoleteState; Rec.ObsoleteState)
                {
                    ToolTip = 'Specifies the value of the ObsoleteState field.', Comment = '%';
                }
                field(OptimizeForTextSearch; Rec.OptimizeForTextSearch)
                {
                    ToolTip = 'Specifies the value of the OptimizeForTextSearch field.', Comment = '%';
                }
                field(OptionString; Rec.OptionString)
                {
                    ToolTip = 'Specifies the option string.';
                }
                field(RelationFieldNo; Rec.RelationFieldNo)
                {
                    ToolTip = 'Specifies the value of the RelationFieldNo field.', Comment = '%';
                }
                field(RelationTableNo; Rec.RelationTableNo)
                {
                    ToolTip = 'Specifies the ID number of a table from which the field on the current table gets data. For example, the field can provide a lookup into another table.';
                }
                field(SQLDataType; Rec.SQLDataType)
                {
                    ToolTip = 'Specifies the value of the SQLDataType field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
                field(TableName; Rec.TableName)
                {
                    ToolTip = 'Specifies the name of the table.';
                }
                field(TableNo; Rec.TableNo)
                {
                    ToolTip = 'Specifies the table number.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the type of the field in the table, which indicates the type of data it contains.';
                }
                field("Type Name"; Rec."Type Name")
                {
                    ToolTip = 'Specifies the type of data.';
                }
            }
        }
    }
}
