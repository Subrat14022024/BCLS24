namespace BCLS.BCLS;

using Microsoft.Inventory.Journal;

page 59101 "Warehouse Journal"
{
    APIGroup = 'itemReclassJournal';
    APIPublisher = 'fSO';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'warehouseJournal';
    DelayedInsert = true;
    EntityName = 'itemReclassJournal';
    EntitySetName = 'itemReclassJournals';
    PageType = API;
    SourceTable = "Item Journal Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(journalTemplateName; Rec."Journal Template Name")
                {
                    Caption = 'Journal Template Name';
                }
                field(journalBatchName; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
                field(binCode; Rec."Bin Code")
                {
                    Caption = 'Bin Code';
                }
                field(newBinCode; Rec."New Bin Code")
                {
                    Caption = 'New Bin Code';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Journal Template Name" := 'RECLASSIFI';
        Rec."Journal Batch Name" := 'DEFAULT';
        Rec."Line No." := Random(10000);
    end;
}
