namespace BCLS.BCLS;

page 50112 "Shop Payment Entries"
{
    APIGroup = 'sales';
    APIPublisher = 'fso';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'shopPaymentEntries';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'shoppaymententries';
    EntitySetName = 'shoppaymententries';
    PageType = API;
    SourceTable = "Shop Payment Entries";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("date"; Rec."Date")
                {
                    Caption = 'Date';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(exportedToSalesSubs; Rec."Exported to Sales Subs.")
                {
                    Caption = 'Exported to Sales Subs.';
                }
                field(gLAccountNo; Rec."G/L Account No.")
                {
                    Caption = 'G/L Account No.';
                }
                field(genJournalAmount; Rec."Gen. Journal Amount")
                {
                    Caption = 'Gen. Journal Amount';
                }
                field(genJournalBatch; Rec."Gen. Journal Batch")
                {
                    Caption = 'Gen. Journal Batch';
                }
                field(genJournalLineNo; Rec."Gen. Journal Line No.")
                {
                    Caption = 'Gen. Journal Line No.';
                }
                field(genJournalTemplate; Rec."Gen. Journal Template")
                {
                    Caption = 'Gen. Journal Template';
                }
                field(invoiceNo; Rec."Invoice No.")
                {
                    Caption = 'Invoice No.';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(posted; Rec.Posted)
                {
                    Caption = 'Posted';
                }
                field(processed; Rec.Processed)
                {
                    Caption = 'Processed';
                }
                // field(subsidiaryCode; Rec."Subsidiary Code")
                // {
                //     Caption = 'Subsidiary Code';
                // }
                field(synchronizationDateExport; Rec."Synchronization Date Export")
                {
                    Caption = 'Synchronization Date Export';
                }
                field(synchronizationDateImport; Rec."Synchronization Date Import")
                {
                    Caption = 'Synchronization Date Import';
                }
                field(synchronizationTimeExport; Rec."Synchronization Time Export")
                {
                    Caption = 'Synchronization Time Export';
                }
                field(synchronizationTimeImport; Rec."Synchronization Time Import")
                {
                    Caption = 'Synchronization Time Import';
                }
                field(tenderSubtype; Rec."Tender Subtype")
                {
                    Caption = 'Tender Subtype';
                }
                field(tenderType; Rec."Tender Type")
                {
                    Caption = 'Tender Type';
                }
                field(totalAmountTransactions; Rec."Total Amount Transactions")
                {
                    Caption = 'Total Amount Transactions';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(typeOfPosting; Rec."Type of Posting")
                {
                    Caption = 'Type of Posting';
                }
            }
        }
    }
}
