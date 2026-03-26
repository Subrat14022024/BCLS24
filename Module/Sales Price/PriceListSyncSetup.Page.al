namespace BCLS.BCLS;

using Microsoft.Pricing.PriceList;

page 50507 "Price List Sync Setup"
{
    PageType = List;
    SourceTable = "Price List Sync Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Source Price List Code"; Rec."Source Price List Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the source price list to watch.';
                }
                field("Target Price List Code"; Rec."Target Price List Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the target price list to create/update.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'If unchecked, this mapping will be ignored.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Optional description for this synchronization rule.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ValidateAll)
            {
                Caption = 'Validate Configurations';
                ApplicationArea = All;
                ToolTip = 'Checks that all source and target price lists exist.';
                trigger OnAction()
                var
                    Setup: Record "Price List Sync Setup";
                    Header: Record "Price List Header";
                    ValidCnt: Integer;
                    InvalidCnt: Integer;
                begin
                    Setup.Reset();
                    if Setup.FindSet() then
                        repeat
                            if not Header.Get(Setup."Source Price List Code") then
                                InvalidCnt += 1;
                            if not Header.Get(Setup."Target Price List Code") then
                                InvalidCnt += 1;
                            ValidCnt += 1;
                        until Setup.Next() = 0;
                    Message('%1 entries checked, %2 missing lists.', ValidCnt, InvalidCnt);
                end;
            }
        }
    }
}