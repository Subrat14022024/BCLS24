namespace FSO_NAVBCConnector.Shoppayment;
page 50112 "FSONBCShopPaymentEntries"
{
    APIGroup = 'sales';
    APIPublisher = 'fso';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    EntityCaption = 'Shop Payment Entries';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'shoppaymententry';
    EntitySetName = 'shoppaymententries';
    ODataKeyFields = "FSONBCEntry No.";
    PageType = API;
    SourceTable = "FSONBCShopPaymentEntries";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("fSONBCdate"; Rec."FSONBCDate")
                {
                }
                field(fSONBCdescription; Rec.FSONBCDescription)
                {
                }
                field(fSONBCentryNo; Rec."FSONBCEntry No.")
                {
                }
                field(fSONBCexportedToSalesSubs; Rec."FSONBCExported to Sales Subs.")
                {
                }
                field(fSONBCgLAccountNo; Rec."FSONBCG/L Account No.")
                {
                }
                field(fSONBCgenJournalAmount; Rec."FSONBCGen. Journal Amount")
                {
                }
                field(fSONBCgenJournalBatch; Rec."FSONBCGen. Journal Batch")
                {
                }
                field(fSONBCgenJournalLineNo; Rec."FSONBCGen. Journal Line No.")
                {
                }
                field(fSONBCgenJournalTemplate; Rec."FSONBCGen. Journal Template")
                {
                }
                field(fSONBCinvoiceNo; Rec."FSONBCInvoice No.")
                {
                }
                field(fSONBClocationCode; Rec."FSONBCLocation Code")
                {
                }
                field(fSONBCposted; Rec.FSONBCPosted)
                {
                }
                field(fSONBCprocessed; Rec.FSONBCProcessed)
                {
                }
                field(fSONBCsynchronizationDateExport; Rec."FSONBCSynchronization Date Exp")
                {
                }
                field(fSONBCsynchronizationDateImport; Rec."FSONBCSynchronization Date Imp")
                {
                }
                field(fSONBCsynchronizationTimeExport; Rec."FSONBCSynchronization Time Exp")
                {
                }
                field(fSONBCsynchronizationTimeImport; Rec."FSONBCSynchronization Time Imp")
                {
                }
                field(fSONBCtenderSubtype; Rec."FSONBCTender Subtype")
                {
                }
                field(fSONBCtenderType; Rec."FSONBCTender Type")
                {
                }
                field(fSONBCtotalAmountTransactions; Rec."FSONBCTotal Amount Trans")
                {
                }
                field(fSONBCtype; Rec."FSONBCType")
                {
                }
                field(fSONBCtypeOfPosting; Rec."FSONBCType of Posting")
                {
                }
            }
        }
    }
}
