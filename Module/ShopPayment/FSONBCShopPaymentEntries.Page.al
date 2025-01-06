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
                field("FSONBCdate"; Rec."FSONBCDate")
                {
                }
                field(FSONBCdescription; Rec.FSONBCDescription)
                {
                }
                field(FSONBCentryNo; Rec."FSONBCEntry No.")
                {
                }
                field(FSONBCexportedToSalesSubs; Rec."FSONBCExported to Sales Subs.")
                {
                }
                field(FSONBCgLAccountNo; Rec."FSONBCG/L Account No.")
                {
                }
                field(FSONBCgenJournalAmount; Rec."FSONBCGen. Journal Amount")
                {
                }
                field(FSONBCgenJournalBatch; Rec."FSONBCGen. Journal Batch")
                {
                }
                field(FSONBCgenJournalLineNo; Rec."FSONBCGen. Journal Line No.")
                {
                }
                field(FSONBCgenJournalTemplate; Rec."FSONBCGen. Journal Template")
                {
                }
                field(FSONBCinvoiceNo; Rec."FSONBCInvoice No.")
                {
                }
                field(FSONBClocationCode; Rec."FSONBCLocation Code")
                {
                }
                field(FSONBCposted; Rec.FSONBCPosted)
                {
                }
                field(FSONBCprocessed; Rec.FSONBCProcessed)
                {
                }
                field(FSONBCsynchronizationDateExport; Rec."FSONBCSynchronization Date Exp")
                {
                }
                field(FSONBCsynchronizationDateImport; Rec."FSONBCSynchronization Date Imp")
                {
                }
                field(FSONBCsynchronizationTimeExport; Rec."FSONBCSynchronization Time Exp")
                {
                }
                field(FSONBCsynchronizationTimeImport; Rec."FSONBCSynchronization Time Imp")
                {
                }
                field(FSONBCtenderSubtype; Rec."FSONBCTender Subtype")
                {
                }
                field(FSONBCtenderType; Rec."FSONBCTender Type")
                {
                }
                field(FSONBCtotalAmountTransactions; Rec."FSONBCTotal Amount Trans")
                {
                }
                field(FSONBCtype; Rec."FSONBCType")
                {
                }
                field(FSONBCtypeOfPosting; Rec."FSONBCType of Posting")
                {
                }
            }
        }
    }
}
