page 50102 "Journal Creation"
{
    APIGroup = 'journals';
    APIPublisher = 'subrat';
    APIVersion = 'v1.0';
    Caption = 'Journal Creation';
    DelayedInsert = true;
    EntityName = 'fashionsociety';
    EntitySetName = 'fashionsociety';
    MultipleNewLines = true;
    PageType = API;
    SourceTable = 81;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("journalTemplateName"; Rec."Journal Template Name")
                {
                    Caption = 'Journal Template Name';

                }
                field("journalbatchname"; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name';

                }
                field("lineNo"; Rec."Line No.")
                {
                    Caption = 'line No';

                }
                field("postingDate"; Rec."Posting Date")
                {
                    Caption = 'line No';

                }
                field("documentType"; Rec."Document Type")
                {
                    Caption = 'Document Type';

                }
                field("documentNo"; Rec."Document No.")
                {
                    Caption = 'Document No.';

                }
                field("accounttype"; Rec."Account Type")
                {
                    Caption = 'Account Type';

                }
                field("accountno"; Rec."Account No.")
                {
                    Caption = 'Account Type';

                }
                field("amount"; Rec.Amount)
                {
                    Caption = 'Amount';

                }
                field("paymentDiscount"; Rec."Payment Discount %")
                {
                    Caption = 'Payment Discount';

                }
            }
        }
    }
}