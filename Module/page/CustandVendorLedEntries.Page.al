page 50100 "Cust and Vendor Led Entries"
{
    PageType = List;
    SourceTableTemporary = true; // Temporary source table to store combined data
    SourceTable = "Cust. Ledger Entry";
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remaining Amount field.';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        PopulateLedgerEntries();
    end;

    procedure PopulateLedgerEntries()
    var
        CustomerLedgerRec: Record "Cust. Ledger Entry";
        VendorLedgerRec: Record "Vendor Ledger Entry";
        TempCombinedLedgerRec: Record "Cust. Ledger Entry" temporary; // Temporary combined record
    begin
        // Populate Customer Ledger Entries
        if CustomerLedgerRec.FindSet() then
            repeat
                TempCombinedLedgerRec := CustomerLedgerRec; // Copy customer record into combined record
                TempCombinedLedgerRec.Insert(); // Insert into temporary table
            until CustomerLedgerRec.Next() = 0;

        // Populate Vendor Ledger Entries
        if VendorLedgerRec.FindSet() then
            repeat
                TempCombinedLedgerRec.FindLast();
                TempCombinedLedgerRec.Init(); // Initialize for the vendor record
                TempCombinedLedgerRec."Entry No." := TempCombinedLedgerRec."Entry No." + 1;
                TempCombinedLedgerRec."Document No." := VendorLedgerRec."Document No.";
                TempCombinedLedgerRec."Posting Date" := VendorLedgerRec."Posting Date";
                TempCombinedLedgerRec."Amount" := VendorLedgerRec."Amount";
                TempCombinedLedgerRec."Remaining Amount" := VendorLedgerRec."Remaining Amount";
                TempCombinedLedgerRec."Description" := VendorLedgerRec."Description";
                TempCombinedLedgerRec.Insert(); // Insert into temporary table
            until VendorLedgerRec.Next() = 0;
    end;

}
