namespace BCLS.BCLS;

using System.Reflection;
using System.Azure.Storage;
using Microsoft.Purchases.Document;

page 50102 "Enum"
{
    APIGroup = 'enum';
    APIPublisher = 'hansamukh';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'enum';
    DelayedInsert = true;
    EntityName = 'enum';
    EntitySetName = 'enums';
    PageType = API;
    SourceTable = "Field";
    SourceTableView = where("Type" = const(Option));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(tableNo; Rec.TableNo)
                {
                    Caption = 'TableNo';
                }
                field(tableName; Rec.TableName)
                {
                    Caption = 'TableName';
                }
                field(fieldNo; Rec."No.")
                {
                    Caption = 'FieldNo.';
                }
                field(fieldName; Rec.FieldName)
                {
                    Caption = 'FieldName';
                }
                field(enumTypeValue; enumTypeValue)
                {
                    Caption = 'EnumTypeValue';
                }
                field(optionString; Rec.OptionString)
                {
                    Caption = 'OptionString';
                }
                field(obsoleteReason; Rec.ObsoleteReason)
                {
                    Caption = 'ObsoleteReason';
                }
                field(obsoleteState; Rec.ObsoleteState)
                {
                    Caption = 'ObsoleteState';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
            }
        }
    }


    procedure CalculateEnumTypeValue(EnumVar: Integer)
    begin
    end;

    var
        enumTypeValue: Integer;

}