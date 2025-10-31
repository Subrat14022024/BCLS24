namespace BCLS.BCLS;

using System.Utilities;

page 50104 EnumFilter
{
    APIGroup = 'enum';
    APIPublisher = 'hansamukh';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'enumFilter';
    DelayedInsert = true;
    EntityName = 'enumString';
    EntitySetName = 'enumStrings';
    PageType = API;
    SourceTable = "Integer";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(number; Rec.Number)
                {
                    Caption = 'Number';
                }
            }
        }

    }
}
