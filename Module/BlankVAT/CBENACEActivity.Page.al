namespace BlankVAT.CBEImporter;

page 54706 "CBE NACE Activity"
{
    ApplicationArea = All;
    Caption = 'CBE NACE Activity';
    PageType = ListPart;
    SourceTable = "FSO CBE NACE Activity";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Company CBE No."; Rec."Company CBE No.")
                {
                    ToolTip = 'Specifies the value of the Company CBE No. field.', Comment = '%';
                }
                field("Activity Code"; Rec."Activity Code")
                {
                    ToolTip = 'Specifies the value of the Activity Code field.', Comment = '%';
                }
                field(Classification; Rec.Classification)
                {
                    ToolTip = 'Specifies the value of the Classification field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("NACE Version"; Rec."NACE Version")
                {
                    ToolTip = 'Specifies the value of the NACE Version field.', Comment = '%';
                }
            }
        }
    }
}
