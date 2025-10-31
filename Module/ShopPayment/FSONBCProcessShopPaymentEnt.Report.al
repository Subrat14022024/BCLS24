namespace FSO_NAVBCConnector.Shoppayment;

using Microsoft.Inventory.Location;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Finance.GeneralLedger.Posting;

report 50100 "FSONBCProcessShopPaymentEnt"
{

    ApplicationArea = all;
    Caption = 'Process shop payment entries';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(FSONBCLocation; Location)
        {
            RequestFilterFields = "Code";
            dataitem(FSONBCShopPaymentEntries; "FSONBCShopPaymentEntries")
            {
                DataItemLink = "FSONBCLocation Code" = field(Code);
                DataItemTableView = sorting(FSONBCProcessed, FSONBCDate, "FSONBCLocation Code")
                                    where(FSONBCProcessed = const(false));
                RequestFilterFields = FSONBCDate, "FSONBCLocation Code";

                trigger OnAfterGetRecord();
                var
                    Customer: Record Customer;
                    DefaultDimension: Record "Default Dimension";
                    GenJournalBatch: Record "Gen. Journal Batch";
                begin
                    case "FSONBCType of Posting" of
                        "FSONBCType of Posting"::Vault:
                            begin
                                if not (FSONBCLocation.Name = '') then
                                    GenJnlBatchName := COPYSTR(FSONBCLocation.Name, 1, MAXSTRLEN(GenJournalBatch.Name))
                                else
                                    GenJnlBatchName := FSONBCLocation.Code;

                                if not GenJournalBatch.get(gGLSetup."FSONBCGenJnlTemplate Safe Jrnl", GenJnlBatchName) then begin
                                    clear(GenJournalBatch);
                                    GenJournalBatch."Journal Template Name" := gGLSetup."FSONBCGenJnlTemplate Safe Jrnl";
                                    GenJournalBatch.Name := GenJnlBatchName;
                                    GenJournalBatch.SetupNewBatch();
                                    GenJournalBatch.Insert(true);
                                    GenJnlTemplateName := GenJournalBatch."Journal Template Name";
                                    GenJnlBatchName := GenJournalBatch.Name;
                                end;

                                Customer.SetRange("Location Code", FSONBCShopPaymentEntries."FSONBCLocation Code");
                                Customer.ReadIsolation(IsolationLevel::ReadUncommitted);
                                Customer.SetLoadFields("No.");
                                if Customer.FindFirst() then begin
                                    if DefaultDimension.get(DATABASE::Customer, Customer."No.", gGLSetup."Shortcut Dimension 1 Code") then
                                        GlobalDim1Code := DefaultDimension."Dimension Value Code";
                                    if DefaultDimension.get(DATABASE::Customer, Customer."No.", gGLSetup."Shortcut Dimension 2 Code") then
                                        GlobalDim2Code := DefaultDimension."Dimension Value Code";
                                end;

                            end;
                        else
                            GetShopPaymentBatch(GenJournalBatch, FSONBCLocation.Code);
                            GenJnlTemplateName := GenJournalBatch."Journal Template Name";
                            GenJnlBatchName := GenJournalBatch.Name;

                            if (gLocationCode <> "FSONBCLocation Code") or (gPostingDate <> FSONBCDate) then begin
                                gLocationCode := "FSONBCLocation Code";
                                gPostingDate := FSONBCDate;
                                InsertInvoiceGenJnlLine(gLocationCode, gPostingDate);
                            end;
                    end;

                    GenJnlTemplateName := GenJournalBatch."Journal Template Name";
                    GenJnlBatchName := GenJournalBatch.Name;

                    InsertGenJnlLine(FSONBCShopPaymentEntries);
                end;

                trigger OnPostDataItem();
                var
                    GenJournalBatch: Record "Gen. Journal Batch";
                begin
                    getShopPaymentBatch(GenJournalBatch, FSONBCLocation.Code);
                    GenJnlTemplateName := GenJournalBatch."Journal Template Name";
                    GenJnlBatchName := GenJournalBatch.Name;

                    if gGLSetup."FSONBCProcess Difference" then
                        ProcessJournalDifferences(GenJnlTemplateName, GenJnlBatchName);

                    if gGLSetup."FSONBCAuto Post Journals" then begin
                        PrepareJournalLinesToPost(GenJnlTemplateName, GenJnlBatchName);
                        PrepareJournalLinesToPost(gGLSetup."FSONBCGenJnlTemplate Safe Jrnl", GetVaultBatch(GenJournalBatch, FSONBCLocation.Code));
                    end;
                end;

                trigger OnPreDataItem();
                var
                    EmptyDateFormula: DateFormula;
                    EndDate: Date;
                    StartDate: Date;
                begin
                    clear(StartDate);
                    clear(endDate);
                    if gGLSetup."FSONBCCreate Shop Inv DFilter" <> EmptyDateFormula then
                        StartDate := CALCDATE(gGLSetup."FSONBCCreate Shop Inv DFilter")
                    else begin
                        StartDate := CalcDate(EmptyDateFormula);
                        endDate := StartDate;
                    end;
                    endDate := WorkDate();
                    SETFILTER(FSONBCDate, STRSUBSTNO('%1..%2', StartDate, endDate));
                end;
            }

            trigger OnAfterGetRecord();
            var
                Customer: Record Customer;
            begin
                Customer.SetRange("Location Code", FSONBCLocation.Code);
                Customer.ReadIsolation(IsolationLevel::ReadUncommitted);
                Customer.SetLoadFields("Location Code");
                if Customer.IsEmpty() then
                    CurrReport.Skip();
            end;
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                }
                field(FSONBCGcodGenJnlTemplate; GenJnlTemplateName)
                {
                    ApplicationArea = all;
                    Caption = 'Gen. journal template';
                    TableRelation = "Gen. Journal Template".Name;
                    ToolTip = 'Fill the general journal template';
                }
                field(FSONBCGcodGenJnlBatch; GenJnlBatchName)
                {
                    ApplicationArea = all;
                    Caption = 'Gen. journal batch';
                    TableRelation = "Gen. Journal Batch".Name;
                    ToolTip = 'Fill the general journal template';

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        LookupGenJnlBatch();
                    end;
                }
            }
        }
    }

    trigger OnInitReport();
    begin
        CurrReport.UseRequestPage(false);
    end;

    trigger OnPreReport();
    begin
        gGLSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        gGLSetup.SetLoadFields("Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "FSONBCCreate Shop Inv DFilter"
        , "FSONBCDefault Shop Pmt. Batch", "FSONBCDefault Shop Pmt. Jrnl", "FSONBCGenJnlTemplate Safe Jrnl", "FSONBCGenJnlBatch Safe Jrnl.");
        gGLSetup.get();
    end;

    local procedure GetApplyToDocAmount(var GenJnlLine: Record "Gen. Journal Line");
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
    begin
        if GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Customer then
            exit;

        CustLedgEntry.setcurrentkey("Customer No.", Open, Positive, "Due Date");
        CustLedgEntry.SetRange("Customer No.", GenJnlLine."Account No.");
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
        CustLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
        CustLedgEntry.ReadIsolation(IsolationLevel::ReadUncommitted);
        CustLedgEntry.SetLoadFields("Amount to Apply", "Remaining Amount", "Remaining Pmt. Disc. Possible"
                                    , "Document Type", "Document No.", "Posting Date", "Pmt. Discount Date", "Currency Code");
        if CustLedgEntry.FindFirst() then begin
            if GenJnlLine."Currency Code" <> CustLedgEntry."Currency Code" then
                GenJnlLine.validate("Currency Code", CustLedgEntry."Currency Code");
            CustLedgEntry.CALCFIELDS("Remaining Amount");
            if CustLedgEntry."Amount to Apply" <> 0 then begin
                if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, false) then begin
                    if ABS(CustLedgEntry."Amount to Apply") >=
                       ABS(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible") then
                        GenJnlLine.Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                    else
                        GenJnlLine.Amount := -CustLedgEntry."Amount to Apply";
                end else
                    GenJnlLine.Amount := -CustLedgEntry."Amount to Apply";
            end else
                if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, false) then
                    GenJnlLine.Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                else
                    GenJnlLine.Amount := -CustLedgEntry."Remaining Amount";
            if GenJnlLine."Bal. Account Type" IN [GenJnlLine."Bal. Account Type"::Customer, GenJnlLine."Bal. Account Type"::Vendor] then
                GenJnlLine.Amount := -GenJnlLine.Amount;
            GenJnlLine.validate(Amount);
            GenJnlLine."Applies-to Doc. Type" := CustLedgEntry."Document Type";
            GenJnlLine."Applies-to Doc. No." := CustLedgEntry."Document No.";
            GenJnlLine."Applies-to ID" := '';
        end;
    end;

    local procedure GetConsCustNo(Location: Code[10]): Code[20];
    var
        Customer: Record Customer;
    begin
        Customer.SetRange("Location Code", Location);
        Customer.ReadIsolation(IsolationLevel::ReadUncommitted);
        Customer.SetLoadFields("No.");
        if Customer.FindLast() then
            exit(Customer."No.");
    end;

    local procedure GetCustOpenInvoiceNo(CustNo: Code[20]; PostingDate: Date; InvNo: Integer): Code[20];
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.setcurrentkey("Document Type", "Customer No.", "Posting Date", "Currency Code");
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
        CustLedgEntry.SetRange("Customer No.", CustNo);
        CustLedgEntry.SetRange("Posting Date", PostingDate);
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.ReadIsolation(IsolationLevel::ReadUncommitted);
        CustLedgEntry.SetLoadFields("Document No.");
        if CustLedgEntry.FindSet() then begin
            if InvNo > 1 then
                CustLedgEntry.next(InvNo - 1);
            exit(CustLedgEntry."Document No.");
        end;
    end;

    local procedure GetCustOpenInvoices(CustNo: Code[20]; PostingDate: Date): Integer;
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.setcurrentkey("Document Type", "Customer No.", "Posting Date", "Currency Code");
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
        CustLedgEntry.SetRange("Customer No.", CustNo);
        CustLedgEntry.SetRange("Posting Date", PostingDate);
        CustLedgEntry.SetRange(Open, true);
        exit(CustLedgEntry.COUNT);
    end;

    local procedure InsertGenJnlLine(ShopPaymEntries: Record "FSONBCShopPaymentEntries");
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        CurrGenJnlLine: Record "Gen. Journal Line";
        NewGenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        IntNewLineNo: Integer;
    begin
        GenJnlTemplate.ReadIsolation(IsolationLevel::ReadUncommitted);
        GenJnlTemplate.SetLoadFields("Source Code");
        GenJnlTemplate.get(GenJnlTemplateName);
        GenJnlBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
        GenJnlBatch.SetLoadFields("Reason Code", "Posting No. Series", "Bal. Account Type", "Bal. Account No.");
        GenJnlBatch.get(GenJnlTemplateName, GenJnlBatchName);
        CurrGenJnlLine.ReadIsolation(IsolationLevel::UpdLock);
        CurrGenJnlLine.SetRange("Journal Template Name", GenJnlTemplateName);
        CurrGenJnlLine.SetRange("Journal Batch Name", GenJnlBatchName);
        CurrGenJnlLine.SetLoadFields("Line No.");
        if CurrGenJnlLine.findlast() then
            IntNewLineNo := CurrGenJnlLine."Line No." + 10000
        else
            IntNewLineNo := 10000;

        NewGenJnlLine.init();
        NewGenJnlLine."Journal Template Name" := GenJnlTemplateName;
        NewGenJnlLine."Journal Batch Name" := GenJnlBatchName;
        NewGenJnlLine."Line No." := IntNewLineNo;
        NewGenJnlLine."Source Code" := GenJnlTemplate."Source Code";
        NewGenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
        NewGenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
        NewGenJnlLine."Bal. Account Type" := GenJnlBatch."Bal. Account Type";
        NewGenJnlLine.validate("Bal. Account No.", GenJnlBatch."Bal. Account No.");
        NewGenJnlLine.Insert(true);

        NewGenJnlLine.validate("Posting Date", ShopPaymEntries.FSONBCDate);
        NewGenJnlLine.validate("Account Type", NewGenJnlLine."Account Type"::"G/L Account");
        NewGenJnlLine.validate("Account No.", ShopPaymEntries."FSONBCG/L Account No.");
        NewGenJnlLine.validate("Document Type", NewGenJnlLine."Document Type"::" ");
        NewGenJnlLine."Document No." := GetnextGenJnlDocNo(ShopPaymEntries.FSONBCDate);
        if ShopPaymEntries.FSONBCDescription <> '' then
            NewGenJnlLine.Description := ShopPaymEntries.FSONBCDescription;
        if ShopPaymEntries."FSONBCTotal Amount Trans" >= 0 then
            NewGenJnlLine.validate("Debit Amount", ShopPaymEntries."FSONBCTotal Amount Trans")
        else
            NewGenJnlLine.validate("Credit Amount", -ShopPaymEntries."FSONBCTotal Amount Trans");
        NewGenJnlLine.validate(NewGenJnlLine."Shortcut Dimension 1 Code", GlobalDim1Code);
        NewGenJnlLine.validate(NewGenJnlLine."Shortcut Dimension 2 Code", GlobalDim2Code);
        NewGenJnlLine.modify(true);

        ShopPaymEntries."FSONBCGen. Journal Template" := NewGenJnlLine."Journal Template Name";
        ShopPaymEntries."FSONBCGen. Journal Batch" := NewGenJnlLine."Journal Batch Name";
        ShopPaymEntries."FSONBCGen. Journal Line No." := NewGenJnlLine."Line No.";
        ShopPaymEntries.FSONBCProcessed := true;
        ShopPaymEntries.modify();
    end;

    local procedure InsertInvoiceGenJnlLine(Location: Code[10]; PostingDate: Date);
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        CurrGenJnlLine: Record "Gen. Journal Line";
        NewGenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        i: Integer;
        j: Integer;
        IntNewLineNo: Integer;
    begin
        GlobalDim1Code := '';
        GlobalDim2Code := '';
        i := GetCustOpenInvoices(GetConsCustNo(Location), PostingDate);
        if i = 0 then i := 1;
        FOR j := 1 TO i DO begin
            GenJnlTemplate.ReadIsolation(IsolationLevel::ReadUncommitted);
            GenJnlTemplate.SetLoadFields("Source Code");
            GenJnlTemplate.get(GenJnlTemplateName);
            GenJnlBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
            GenJnlBatch.SetLoadFields("Reason Code", "Posting No. Series", "Bal. Account Type", "Bal. Account No.");
            GenJnlBatch.get(GenJnlTemplateName, GenJnlBatchName);

            CurrGenJnlLine.ReadIsolation(IsolationLevel::UpdLock);
            CurrGenJnlLine.SetRange("Journal Template Name", GenJnlTemplateName);
            CurrGenJnlLine.SetRange("Journal Batch Name", GenJnlBatchName);
            CurrGenJnlLine.SetLoadFields("Line No.");
            if CurrGenJnlLine.findlast() then
                IntNewLineNo := CurrGenJnlLine."Line No." + 10000
            else
                IntNewLineNo := 10000;

            NewGenJnlLine.init();
            NewGenJnlLine."Journal Template Name" := GenJnlTemplateName;
            NewGenJnlLine."Journal Batch Name" := GenJnlBatchName;
            NewGenJnlLine."Line No." := IntNewLineNo;
            NewGenJnlLine."Source Code" := GenJnlTemplate."Source Code";
            NewGenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
            NewGenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
            NewGenJnlLine."Bal. Account Type" := GenJnlBatch."Bal. Account Type";
            NewGenJnlLine.validate("Bal. Account No.", GenJnlBatch."Bal. Account No.");
            NewGenJnlLine.Insert(true);

            NewGenJnlLine.validate("Posting Date", PostingDate);
            NewGenJnlLine.validate("Account Type", NewGenJnlLine."Account Type"::Customer);
            NewGenJnlLine.validate("Account No.", GetConsCustNo(Location));
            NewGenJnlLine.validate("Document Type", NewGenJnlLine."Document Type"::" ");
            NewGenJnlLine."Document No." := GetnextGenJnlDocNo(PostingDate);
            NewGenJnlLine."Applies-to Doc. Type" := NewGenJnlLine."Applies-to Doc. Type"::Invoice;
            NewGenJnlLine.validate("Applies-to Doc. No.", GetCustOpenInvoiceNo(NewGenJnlLine."Account No.", PostingDate, j));
            GetApplyToDocAmount(NewGenJnlLine);
            NewGenJnlLine.modify(true);
            GlobalDim1Code := NewGenJnlLine."Shortcut Dimension 1 Code";
            GlobalDim2Code := NewGenJnlLine."Shortcut Dimension 2 Code";
        end;
    end;

    local procedure LookupGenJnlBatch();
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        GenJnlBatch.SetRange("Journal Template Name", GenJnlTemplateName);
        if page.RunModal(0, GenJnlBatch) = ACTION::LookupOK then begin
            if GenJnlBatch."No. Series" = '' then
                GenJnlBatch.FieldError("No. Series");
            GenJnlBatchName := GenJnlBatch.Name;
        end;
    end;

    local procedure GetnextGenJnlDocNo(date_Posting: Date): Code[20];
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        GenJnlTemplate.get(GenJnlTemplateName);
        GenJnlBatch.get(GenJnlTemplateName, GenJnlBatchName);
        GenJnlLine.SetRange("Journal Template Name", GenJnlTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", GenJnlBatchName);
        GenJnlLine.SetRange("Posting Date", date_Posting);
        GenJnlLine.ReadIsolation(IsolationLevel::ReadUncommitted);
        GenJnlLine.SetLoadFields("Document No.");
        if GenJnlLine.findlast() then
            exit(GenJnlLine."Document No.")
        else
            if GenJnlBatch."No. Series" <> '' then
                exit(NoSeriesMgt.getnextNo(GenJnlBatch."No. Series", date_Posting, false));
    end;

    local procedure GetShopPaymentBatch(VAR GenJournalBatch: Record "Gen. Journal Batch"; LocationCode: Code[10])
    var
        Glsetup: Record "General Ledger Setup";
        BatchName: Text[10];
    begin
        Glsetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        Glsetup.SetLoadFields("FSONBCDefault Shop Pmt. Jrnl");
        Glsetup.get();
        Glsetup.TestField("FSONBCDefault Shop Pmt. Jrnl");
        FSONBCLocation.ReadIsolation(IsolationLevel::ReadUncommitted);
        FSONBCLocation.SetLoadFields(Name);
        FSONBCLocation.get(LocationCode);

        if not (FSONBCLocation.Name = '') then
            BatchName := CopyStr(FSONBCLocation.Name, 1, MaxStrLen(GenJournalBatch.Name))
        else
            BatchName := FSONBCLocation.Code;

        if GenJournalBatch.get(Glsetup."FSONBCDefault Shop Pmt. Jrnl", BatchName) then
            exit;

        clear(GenJournalBatch);
        GenJournalBatch."Journal Template Name" := Glsetup."FSONBCDefault Shop Pmt. Jrnl";
        GenJournalBatch.Name := BatchName;
        GenJournalBatch.SetupNewBatch();
        GenJournalBatch.Insert(true);
    end;

    procedure ProcessJournalDifferences(JournalTemplate: Code[10]; JournalBatch: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
        NewGenJnlLine: Record "Gen. Journal Line";
        PostingDate: Date;
        TotalDif: Decimal;
    begin
        GenJnlLine.ReadIsolation(IsolationLevel::ReadUncommitted);
        GenJnlLine.SetLoadFields("Account No.", "Posting Date");
        GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
        GenJnlLine.SetRange("Journal Template Name", JournalTemplate);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatch);
        if GenJnlLine.FindSet() then
            repeat
                if GenJnlLine."Account No." <> gGLSetup."FSONBCDifference GL A/c" then begin
                    PostingDate := GenJnlLine."Posting Date";

                    NewGenJnlLine.Reset();
                    NewGenJnlLine.ReadIsolation(IsolationLevel::ReadUncommitted);
                    NewGenJnlLine.SetLoadFields("Amount (LCY)");
                    NewGenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                    NewGenJnlLine.SetRange("Journal Template Name", JournalTemplate);
                    NewGenJnlLine.SetRange("Journal Batch Name", JournalBatch);
                    NewGenJnlLine.SetRange("Posting Date", PostingDate);
                    TotalDif := 0;
                    NewGenJnlLine.CalcSums("Amount (LCY)");
                    TotalDif := NewGenJnlLine."Amount (LCY)";

                    if (ABS(TotalDif) > 0) then
                        if (ABS(TotalDif) <= gGLSetup."FSONBCMax. Difference Allowed") then
                            InsertGenJnlLineForDifference(GenJnlLine."Line No." + 10, gGLSetup."FSONBCDifference GL A/c", PostingDate, -TotalDif);
                end;
            until GenJnlLine.Next() = 0;
    end;

    [Obsolete('We have Removed Document Number')]
    procedure ProcessJournalDifferences(JournalTemplate: Code[10]; JournalBatch: Code[10]; DocumentNo: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
        NewGenJnlLine: Record "Gen. Journal Line";
        PostingDate: Date;
        TotalDif: Decimal;
    begin
        GenJnlLine.ReadIsolation(IsolationLevel::ReadUncommitted);
        GenJnlLine.SetLoadFields("Account No.", "Posting Date");
        GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
        GenJnlLine.SetRange("Journal Template Name", JournalTemplate);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatch);
        if GenJnlLine.FindSet() then
            repeat
                if GenJnlLine."Account No." <> gGLSetup."FSONBCDifference GL A/c" then begin
                    PostingDate := GenJnlLine."Posting Date";

                    NewGenJnlLine.Reset();
                    NewGenJnlLine.ReadIsolation(IsolationLevel::ReadUncommitted);
                    NewGenJnlLine.SetLoadFields("Amount (LCY)");
                    NewGenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                    NewGenJnlLine.SetRange("Journal Template Name", JournalTemplate);
                    NewGenJnlLine.SetRange("Journal Batch Name", JournalBatch);
                    NewGenJnlLine.SetRange("Posting Date", PostingDate);
                    NewGenJnlLine.SetRange("Document No.", DocumentNo);
                    TotalDif := 0;
                    NewGenJnlLine.CalcSums("Amount (LCY)");
                    TotalDif := NewGenJnlLine."Amount (LCY)";

                    if (ABS(TotalDif) > 0) then
                        if (ABS(TotalDif) <= gGLSetup."FSONBCMax. Difference Allowed") then
                            InsertGenJnlLineForDifference(GenJnlLine."Line No." + 10, gGLSetup."FSONBCDifference GL A/c", PostingDate, -TotalDif);
                end;
            until GenJnlLine.Next() = 0;
    end;

    local procedure InsertGenJnlLineForDifference(LineNo: Integer; AccountNo: Code[20]; PostingDate: Date; DiffAmount: Decimal)
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        NewGenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlTemplate.ReadIsolation(IsolationLevel::ReadUncommitted);
        GenJnlTemplate.SetLoadFields("Source Code");
        GenJnlTemplate.Get(GenJnlTemplateName);
        GenJnlBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
        GenJnlBatch.SetLoadFields("Reason Code", "Posting No. Series", "Bal. Account Type", "Bal. Account No.");
        GenJnlBatch.Get(GenJnlTemplateName, GenJnlBatchName);
        NewGenJnlLine.ReadIsolation(IsolationLevel::UpdLock);
        NewGenJnlLine.Init();
        NewGenJnlLine."Journal Template Name" := GenJnlTemplateName;
        NewGenJnlLine."Journal Batch Name" := GenJnlBatchName;
        NewGenJnlLine."Line No." := LineNo;
        NewGenJnlLine."Source Code" := GenJnlTemplate."Source Code";
        NewGenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
        NewGenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
        NewGenJnlLine."Bal. Account Type" := GenJnlBatch."Bal. Account Type";
        NewGenJnlLine.Validate("Bal. Account No.", GenJnlBatch."Bal. Account No.");
        NewGenJnlLine.Insert(true);

        NewGenJnlLine.Validate("Posting Date", PostingDate);
        NewGenJnlLine.Validate("Account Type", NewGenJnlLine."Account Type"::"G/L Account");
        NewGenJnlLine.Validate("Account No.", AccountNo);
        NewGenJnlLine.Validate("Document Type", NewGenJnlLine."Document Type"::" ");
        NewGenJnlLine."Document No." := GetnextGenJnlDocNo(PostingDate);
        NewGenJnlLine.Validate(Amount, DiffAmount);
        NewGenJnlLine.Validate(NewGenJnlLine."Shortcut Dimension 1 Code", GlobalDim1Code);
        NewGenJnlLine.Validate(NewGenJnlLine."Shortcut Dimension 2 Code", GlobalDim2Code);
        NewGenJnlLine.Modify(true);
    end;

    local procedure GetVaultBatch(var GenJournalBatch: Record "Gen. Journal Batch"; LocationCode: Code[10]): Code[10];
    var
        BatchName: Text[10];
    begin
        FSONBCLocation.ReadIsolation(IsolationLevel::ReadUncommitted);
        FSONBCLocation.SetLoadFields(Name);
        FSONBCLocation.Get(LocationCode);
        if not (FSONBCLocation.Name = '') then
            BatchName := CopyStr(FSONBCLocation.Name, 1, MaxStrLen(GenJournalBatch.Name))
        else
            BatchName := FSONBCLocation.Code;

        exit(BatchName);
    end;

    local procedure CheckGenJnlLinesExistsforPosting(GenJnlTemplate: Code[10]; GenJnlBatch: Code[10]): Boolean
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Reset();
        GenJnlLine.ReadIsolation(IsolationLevel::ReadUncommitted);
        GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
        GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate);
        GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch);
        if not GenJnlLine.IsEmpty() then
            exit(true)
        else
            exit(false);
    end;

    procedure PrepareJournalLinesToPost(JournalTemplate: Code[10]; JournalBatch: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
        NewGenJnlLine: Record "Gen. Journal Line";
        PostingDate: Date;
    begin
        if CheckGenJnlLinesExistsforPosting(JournalTemplate, JournalBatch) then begin
            GenJnlLine.Reset();
            GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            GenJnlLine.SetRange("Journal Template Name", JournalTemplate);
            GenJnlLine.SetRange("Journal Batch Name", JournalBatch);
            if GenJnlLine.FindSet() then begin
                Clear(PostingDate);
                repeat
                    if PostingDate <> GenJnlLine."Posting Date" then begin
                        PostingDate := GenJnlLine."Posting Date";
                        NewGenJnlLine.CopyFilters(GenJnlLine);
                        NewGenJnlLine.SetRange("Posting Date", PostingDate);
                        if NewGenJnlLine.FindSet() then
                            PostGenJnlViaJobQueue(NewGenJnlLine);
                    end;
                until GenJnlLine.Next() = 0;
            end;
        end;
    end;

    local procedure PostGenJnlViaJobQueue(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlPostviaJobQueue: Codeunit "Gen. Jnl.-Post via Job Queue";
    begin
        if GenJournalLine.GetDocumentBalance(GenJournalLine) = 0 then
            GenJnlPostviaJobQueue.EnqueueGenJrnlLineWithUI(GenJournalLine, false)
    end;

    var
        gGLSetup: Record "General Ledger Setup";
        GenJnlBatchName: Code[10];
        GenJnlTemplateName: Code[10];
        gLocationCode: Code[10];
        GlobalDim1Code: Code[20];
        GlobalDim2Code: Code[20];
        gPostingDate: Date;

}

