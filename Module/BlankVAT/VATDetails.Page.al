namespace BlankVAT.CBEImporter;

page 54102 "VAT Details"
{
    ApplicationArea = All;
    Caption = 'VAT Details';
    PageType = List;
    SourceTable = "VAT Details";
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Search City"; Rec."Search City")
                {
                    ToolTip = 'Specifies the value of the Search City field.', Comment = '%';
                }
                field("Search Name"; Rec."Search Name")
                {
                    ToolTip = 'Specifies the value of the Search Name field.', Comment = '%';
                }
                field("Search Post Code"; Rec."Search Post Code")
                {
                    ToolTip = 'Specifies the value of the Search Post Code field.', Comment = '%';
                }
                field("Full Address"; Rec."Full Address")
                {
                    ToolTip = 'Specifies the value of the Full Address field.', Comment = '%';
                }
                field("Data Fetched"; Rec."Data Fetched")
                {
                    ToolTip = 'Specifies whether the data has been fetched.', Comment = '%';
                }
            }
        }
    }
}
