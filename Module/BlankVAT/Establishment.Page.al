namespace BlankVAT.CBEImporter;

page 54705 Establishment
{
    ApplicationArea = All;
    Caption = 'Establishment';
    PageType = ListPart;
    SourceTable = "FSO CBE Establishment";
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
                field("Establishment No."; Rec."Establishment No.")
                {
                    ToolTip = 'Specifies the value of the Establishment Number field.', Comment = '%';
                }
                field(Box; Rec.Box)
                {
                    ToolTip = 'Specifies the value of the Box field.', Comment = '%';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.', Comment = '%';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ToolTip = 'Specifies the value of the Country Code field.', Comment = '%';
                }
                field("Full Address"; Rec."Full Address")
                {
                    ToolTip = 'Specifies the value of the Full Address field.', Comment = '%';
                }
                field("House No."; Rec."House No.")
                {
                    ToolTip = 'Specifies the value of the House No. field.', Comment = '%';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field.', Comment = '%';
                }
                field(Street; Rec.Street)
                {
                    ToolTip = 'Specifies the value of the Street field.', Comment = '%';
                }
                field("Type Of Address"; Rec."Type Of Address")
                {
                    ToolTip = 'Specifies the value of the Type Of Address field.', Comment = '%';
                }
            }
        }
    }
}
