namespace BCLS.BCLS;

using Microsoft.Inventory.Item;

page 50101 SubratWorksheet
{
    ApplicationArea = All;
    Caption = 'Subrat Worksheet';
    PageType = Worksheet;
    SourceTable = Item;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(Filter)
            {
                Caption = 'Filters';
                field("Item Category Code Filter"; ItemCategoryCodeFilter)
                {
                    Caption = 'Item Category Code Filter';
                    ToolTip = 'Specifies the item category code to filter the items.';
                    trigger OnValidate()
                    begin
                        if ItemCategoryCodeFilter <> '' then
                            Rec.SetFilter("Item Category Code", ItemCategoryCodeFilter)
                        else
                            Rec.SetRange("Item Category Code");

                        CurrPage.Update(false);
                    end;

                    trigger OnAssistEdit()
                    var
                        ItemCategories: Page "Item Categories";
                    begin
                        ItemCategories.LookupMode := true;
                        if ItemCategories.RunModal() = Action::LookupOK then
                            ItemCategoryCodeFilter := ItemCategories.GetSelectionFilter();
                        if ItemCategoryCodeFilter <> '' then
                            Rec.SetFilter("Item Category Code", ItemCategoryCodeFilter)
                        else
                            Rec.SetRange("Item Category Code");

                        CurrPage.Update(false);
                    end;
                }
                field("LSC Division Code Filter"; LSCDivisionCodeFilter)
                {
                    Caption = 'LSC Division Code Filter';
                    ToolTip = 'Specifies the division code to filter the items (for example Food, Hardware, Clothing).';
                    trigger OnValidate()
                    begin
                        if LSCDivisionCodeFilter <> '' then
                            Rec.SetFilter("LSC Division Code", LSCDivisionCodeFilter)
                        else
                            Rec.SetRange("LSC Division Code");

                        CurrPage.Update(false);
                    end;

                    trigger OnAssistEdit()
                    var
                        LSCDivision: Record "LSC Division";
                        LSCDivisionPage: Page "LSC Divisions";


                    begin
                        LSCDivisionPage.LookupMode := true;
                        if LSCDivisionPage.RunModal() = Action::LookupOK then
                            LSCDivisionPage.SetSelectionFilter(LSCDivision);

                        LSCDivisionCodeFilter := LSCDivision.GetFilter(Code);
                        Message(LSCDivisionCodeFilter);
                    end;
                }
            }
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the item.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ToolTip = 'Specifies the item category code of the item.';
                }
                field("LSC Division Code"; Rec."LSC Division Code")
                {
                    ToolTip = 'Specifies the division code that indicates which division this item belongs to (for example Food, Hardware, Clothing).';
                }
            }
        }
    }
    var
        ItemCategoryCodeFilter, LSCDivisionCodeFilter : Text;
}
