namespace BlankVAT.CBEImporter;
page 50702 "VAT Detail"
{
    ApplicationArea = All;
    Caption = 'VAT Detail';
    PageType = Document;
    SourceTable = "FSO CBE Company";
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Search Name"; Rec."Search Name")
                {
                    ToolTip = 'Specifies the value of the Search Name field.', Comment = '%';
                }
                field("Search City"; Rec."Search City")
                {
                    ToolTip = 'Specifies the value of the Search City field.', Comment = '%';
                }
                field("Search Post Code"; Rec."Search Post Code")
                {
                    ToolTip = 'Specifies the value of the Search Post Code field.', Comment = '%';
                }
                field("CBE No."; Rec."CBE No.")
                {
                    ToolTip = 'Specifies the value of the CBE Number field.', Comment = '%';
                }
                field("CBE No. Formatted"; Rec."CBE No. Formatted")
                {
                    ToolTip = 'Specifies the value of the CBE Number Formatted field.', Comment = '%';
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
                field(Box; Rec.Box)
                {
                    ToolTip = 'Specifies the value of the Box field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field(Web; Rec.Web)
                {
                    ToolTip = 'Specifies the value of the Web field.', Comment = '%';
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.', Comment = '%';
                }
                field(Denomination; Rec.Denomination)
                {
                    ToolTip = 'Specifies the value of the Denomination field.', Comment = '%';
                }
                field("Denomination With Legal Form"; Rec."Denomination With Legal Form")
                {
                    ToolTip = 'Specifies the value of the Denomination With Legal Form field.', Comment = '%';
                }
                field("Juridical Form"; Rec."Juridical Form")
                {
                    ToolTip = 'Specifies the value of the Juridical Form field.', Comment = '%';
                }
                field("Juridical Form Code"; Rec."Juridical Form Code")
                {
                    ToolTip = 'Specifies the value of the Juridical Form Code field.', Comment = '%';
                }
                field("Juridical Situation"; Rec."Juridical Situation")
                {
                    ToolTip = 'Specifies the value of the Juridical Situation field.', Comment = '%';
                }
                field(Phone; Rec.Phone)
                {
                    ToolTip = 'Specifies the value of the Phone field.', Comment = '%';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field.', Comment = '%';
                }
                field("Guid"; Rec."Guid")
                {
                    ToolTip = 'Specifies the value of the GUID field.', Comment = '%';
                }
                field("Source JSON"; Rec."Source JSON")
                {
                    ToolTip = 'Specifies the value of the Source JSON field.', Comment = '%';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    StyleExpr = StyleTxt;
                }
                field(Street; Rec.Street)
                {
                    ToolTip = 'Specifies the value of the Street field.', Comment = '%';
                }
            }
            part(Establishments; Establishment)
            {
                ApplicationArea = All;
                SubPageLink = "Company CBE No." = field("CBE No.");
                Visible = true;
            }
            part("CBE NACE Activities"; "CBE NACE Activity")
            {
                ApplicationArea = All;
                SubPageLink = "Company CBE No." = field("CBE No.");
                Visible = true;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        StyleTxt := Format(StyleExpr());
    end;

    local procedure StyleExpr(): PageStyle
    var
        lPageStyle: PageStyle;
    begin
        Clear(Active);
        Active := false;
        if Rec.Status = 'active' then
            Active := true;

        if Active then
            lPageStyle := PageStyle::Favorable
        else
            lPageStyle := PageStyle::Unfavorable;
        exit(lPageStyle);
    end;

    var
        Active: Boolean;
        StyleTxt: Text;
}
