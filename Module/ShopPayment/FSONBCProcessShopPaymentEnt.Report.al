namespace FSO_NAVBCConnector.Shoppayment;

using Microsoft.Inventory.Location;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.ReceivablesPayables;

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
                    lCustomer: Record Customer;
                    lDefaultDimension: Record "Default Dimension";
                    lGenJournalBatch: Record "Gen. Journal Batch";

                begin
                    gGenJnlDocNo := '';

                    case "FSONBCType of Posting" of
                        "FSONBCType of Posting"::Vault:
                            begin
                                if not (FSONBCLocation.Name = '') then
                                    gGenJnlBatch := COPYSTR(FSONBCLocation.Name, 1, MAXSTRLEN(lCustomer.Name))
                                else
                                    gGenJnlBatch := FSONBCLocation.Code;

                                if not lGenJournalBatch.get(gGLSetup."FSONBCGenJnlTemplate Safe Jrnl", gGenJnlBatch) then begin
                                    clear(lGenJournalBatch);
                                    lGenJournalBatch."Journal Template Name" := gGLSetup."FSONBCGenJnlTemplate Safe Jrnl";
                                    lGenJournalBatch.Name := gGenJnlBatch;
                                    lGenJournalBatch.SetupNewBatch();
                                    lGenJournalBatch.Insert(true);
                                    gGenJnlTemplate := lGenJournalBatch."Journal Template Name";
                                    gGenJnlBatch := lGenJournalBatch.Name;
                                end;

                                lCustomer.SetRange("Location Code", FSONBCShopPaymentEntries."FSONBCLocation Code");
                                lCustomer.ReadIsolation(IsolationLevel::ReadUncommitted);
                                lCustomer.SetLoadFields("No.");
                                if lCustomer.FindFirst() then begin
                                    if lDefaultDimension.get(DATABASE::Customer, lCustomer."No.", gGLSetup."Shortcut Dimension 1 Code") then
                                        gGlobalDim1 := lDefaultDimension."Dimension Value Code";
                                    if lDefaultDimension.get(DATABASE::Customer, lCustomer."No.", gGLSetup."Shortcut Dimension 2 Code") then
                                        gGlobalDim2 := lDefaultDimension."Dimension Value Code";
                                end;

                            end;
                        else
                            GetShopPaymentBatch(lGenJournalBatch, FSONBCLocation.Code);
                            gGenJnlTemplate := lGenJournalBatch."Journal Template Name";
                            gGenJnlBatch := lGenJournalBatch.Name;

                            if (gLocation <> "FSONBCLocation Code") or (gPostingDate <> FSONBCDate) then begin
                                gLocation := "FSONBCLocation Code";
                                gPostingDate := FSONBCDate;
                                InsertInvoiceGenJnlLine(gLocation, gPostingDate);
                            end;
                    end;

                    gGenJnlTemplate := lGenJournalBatch."Journal Template Name";
                    gGenJnlBatch := lGenJournalBatch.Name;

                    InsertGenJnlLine(FSONBCShopPaymentEntries);
                end;

                trigger OnPostDataItem();
                var
                    lGenJournalBatch: Record "Gen. Journal Batch";
                begin

                    getShopPaymentBatch(lGenJournalBatch, FSONBCLocation.Code);
                    gGenJnlTemplate := lGenJournalBatch."Journal Template Name";
                    gGenJnlBatch := lGenJournalBatch.Name;
                end;

                trigger OnPreDataItem();
                var
                    lEmptyDateFormula: DateFormula;
                    lendDate: Date;
                    lStartDate: Date;
                begin
                    clear(lStartDate);
                    clear(lendDate);
                    if gGLSetup."FSONBCCreate Shop Inv DFilter" <> lEmptyDateFormula then
                        lStartDate := CALCDATE(gGLSetup."FSONBCCreate Shop Inv DFilter")
                    else begin
                        lStartDate := CalcDate(lEmptyDateFormula);
                        lendDate := lStartDate;
                    end;
                    lendDate := WorkDate();
                    SETFILTER(FSONBCDate, STRSUBSTNO('%1..%2', lStartDate, lendDate));
                end;
            }

            trigger OnAfterGetRecord();
            var
                lCustomer: Record Customer;
            begin
                lCustomer.SetRange("Location Code", FSONBCLocation.Code);
                lCustomer.ReadIsolation(IsolationLevel::ReadUncommitted);
                lCustomer.SetLoadFields("Location Code");
                if lCustomer.IsEmpty() then
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
                field(FSONBCGcodGenJnlTemplate; gGenJnlTemplate)
                {
                    ApplicationArea = all;
                    Caption = 'Gen. journal template';
                    TableRelation = "Gen. Journal Template".Name;
                    ToolTip = 'Fill the general journal template';
                }
                field(FSONBCGcodGenJnlBatch; gGenJnlBatch)
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
        lCustLedgEntry: Record "Cust. Ledger Entry";
        lPaymentToleranceMgt: Codeunit "Payment Tolerance Management";
    begin
        if GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Customer then
            exit;

        lCustLedgEntry.setcurrentkey("Customer No.", Open, Positive, "Due Date");
        lCustLedgEntry.SetRange("Customer No.", GenJnlLine."Account No.");
        lCustLedgEntry.SetRange(Open, true);
        lCustLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
        lCustLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
        lCustLedgEntry.ReadIsolation(IsolationLevel::ReadUncommitted);
        lCustLedgEntry.SetLoadFields("Amount to Apply", "Remaining Amount", "Remaining Pmt. Disc. Possible"
                                    , "Document Type", "Document No.", "Posting Date", "Pmt. Discount Date");
        if lCustLedgEntry.FindFirst() then begin
            if GenJnlLine."Currency Code" <> lCustLedgEntry."Currency Code" then
                GenJnlLine.validate("Currency Code", lCustLedgEntry."Currency Code");
            lCustLedgEntry.CALCFIELDS("Remaining Amount");
            if lCustLedgEntry."Amount to Apply" <> 0 then begin
                if lPaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, lCustLedgEntry, 0, false) then begin
                    if ABS(lCustLedgEntry."Amount to Apply") >=
                       ABS(lCustLedgEntry."Remaining Amount" - lCustLedgEntry."Remaining Pmt. Disc. Possible") then
                        GenJnlLine.Amount := -(lCustLedgEntry."Remaining Amount" - lCustLedgEntry."Remaining Pmt. Disc. Possible")
                    else
                        GenJnlLine.Amount := -lCustLedgEntry."Amount to Apply";
                end else
                    GenJnlLine.Amount := -lCustLedgEntry."Amount to Apply";
            end else
                if lPaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, lCustLedgEntry, 0, false) then
                    GenJnlLine.Amount := -(lCustLedgEntry."Remaining Amount" - lCustLedgEntry."Remaining Pmt. Disc. Possible")
                else
                    GenJnlLine.Amount := -lCustLedgEntry."Remaining Amount";
            if GenJnlLine."Bal. Account Type" IN [GenJnlLine."Bal. Account Type"::Customer, GenJnlLine."Bal. Account Type"::Vendor] then
                GenJnlLine.Amount := -GenJnlLine.Amount;
            GenJnlLine.validate(Amount);
            GenJnlLine."Applies-to Doc. Type" := lCustLedgEntry."Document Type";
            GenJnlLine."Applies-to Doc. No." := lCustLedgEntry."Document No.";
            GenJnlLine."Applies-to ID" := '';
        end;
    end;

    local procedure GetConsCustNo(Location: Code[10]): Code[20];
    var
        lCustomer: Record Customer;
    begin
        lCustomer.SetRange("Location Code", Location);
        lCustomer.ReadIsolation(IsolationLevel::ReadUncommitted);
        lCustomer.SetLoadFields("No.");
        if lCustomer.FindLast() then
            exit(lCustomer."No.");
    end;

    local procedure GetCustOpenInvoiceNo(CustNo: Code[20]; PostingDate: Date; InvNo: Integer): Code[20];
    var
        lCustLedgEntry: Record "Cust. Ledger Entry";
    begin
        lCustLedgEntry.setcurrentkey("Document Type", "Customer No.", "Posting Date", "Currency Code");
        lCustLedgEntry.SetRange("Document Type", lCustLedgEntry."Document Type"::Invoice);
        lCustLedgEntry.SetRange("Customer No.", CustNo);
        lCustLedgEntry.SetRange("Posting Date", PostingDate);
        lCustLedgEntry.SetRange(Open, true);
        lCustLedgEntry.ReadIsolation(IsolationLevel::ReadUncommitted);
        lCustLedgEntry.SetLoadFields("Document No.");
        if lCustLedgEntry.FindSet() then begin
            if InvNo > 1 then
                lCustLedgEntry.next(InvNo - 1);
            exit(lCustLedgEntry."Document No.");
        end;
    end;

    local procedure GetCustOpenInvoices(CustNo: Code[20]; PostingDate: Date): Integer;
    var
        lCustLedgEntry: Record "Cust. Ledger Entry";
    begin
        lCustLedgEntry.setcurrentkey("Document Type", "Customer No.", "Posting Date", "Currency Code");
        lCustLedgEntry.SetRange("Document Type", lCustLedgEntry."Document Type"::Invoice);
        lCustLedgEntry.SetRange("Customer No.", CustNo);
        lCustLedgEntry.SetRange("Posting Date", PostingDate);
        lCustLedgEntry.SetRange(Open, true);
        exit(lCustLedgEntry.COUNT);
    end;

    local procedure InsertGenJnlLine(ShopPaymEntries: Record "FSONBCShopPaymentEntries");
    var
        lGenJnlBatch: Record "Gen. Journal Batch";
        lCurrGenJnlLine: Record "Gen. Journal Line";
        lNewGenJnlLine: Record "Gen. Journal Line";
        lGenJnlTemplate: Record "Gen. Journal Template";
        lIntNewLineNo: Integer;
    begin
        lGenJnlTemplate.ReadIsolation(IsolationLevel::ReadUncommitted);
        lGenJnlTemplate.SetLoadFields("Source Code");
        lGenJnlTemplate.get(gGenJnlTemplate);
        lGenJnlBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
        lGenJnlBatch.SetLoadFields("Reason Code", "Posting No. Series", "Bal. Account Type", "Bal. Account No.");
        lGenJnlBatch.get(gGenJnlTemplate, gGenJnlBatch);
        if gGenJnlDocNo = '' then
            GetnextGenJnlDocNo(ShopPaymEntries.FSONBCDate);

        lCurrGenJnlLine.ReadIsolation(IsolationLevel::UpdLock);
        lCurrGenJnlLine.SetRange("Journal Template Name", gGenJnlTemplate);
        lCurrGenJnlLine.SetRange("Journal Batch Name", gGenJnlBatch);
        lCurrGenJnlLine.SetLoadFields("Line No.");
        if lCurrGenJnlLine.findlast() then
            lIntNewLineNo := lCurrGenJnlLine."Line No." + 10000
        else
            lIntNewLineNo := 10000;

        lNewGenJnlLine.init();
        lNewGenJnlLine."Journal Template Name" := gGenJnlTemplate;
        lNewGenJnlLine."Journal Batch Name" := gGenJnlBatch;
        lNewGenJnlLine."Line No." := lIntNewLineNo;
        lNewGenJnlLine."Source Code" := lGenJnlTemplate."Source Code";
        lNewGenJnlLine."Reason Code" := lGenJnlBatch."Reason Code";
        lNewGenJnlLine."Posting No. Series" := lGenJnlBatch."Posting No. Series";
        lNewGenJnlLine."Bal. Account Type" := lGenJnlBatch."Bal. Account Type";
        lNewGenJnlLine.validate("Bal. Account No.", lGenJnlBatch."Bal. Account No.");
        lNewGenJnlLine.Insert(true);

        lNewGenJnlLine.validate("Posting Date", ShopPaymEntries.FSONBCDate);
        lNewGenJnlLine.validate("Account Type", lNewGenJnlLine."Account Type"::"G/L Account");
        lNewGenJnlLine.validate("Account No.", ShopPaymEntries."FSONBCG/L Account No.");
        lNewGenJnlLine.validate("Document Type", lNewGenJnlLine."Document Type"::" ");
        lNewGenJnlLine."Document No." := gGenJnlDocNo;
        if ShopPaymEntries.FSONBCDescription <> '' then
            lNewGenJnlLine.Description := ShopPaymEntries.FSONBCDescription;
        if ShopPaymEntries."FSONBCTotal Amount Trans" >= 0 then
            lNewGenJnlLine.validate("Debit Amount", ShopPaymEntries."FSONBCTotal Amount Trans")
        else
            lNewGenJnlLine.validate("Credit Amount", -ShopPaymEntries."FSONBCTotal Amount Trans");
        lNewGenJnlLine.validate(lNewGenJnlLine."Shortcut Dimension 1 Code", gGlobalDim1);
        lNewGenJnlLine.validate(lNewGenJnlLine."Shortcut Dimension 2 Code", gGlobalDim2);
        lNewGenJnlLine.modify(true);

        ShopPaymEntries."FSONBCGen. Journal Template" := lNewGenJnlLine."Journal Template Name";
        ShopPaymEntries."FSONBCGen. Journal Batch" := lNewGenJnlLine."Journal Batch Name";
        ShopPaymEntries."FSONBCGen. Journal Line No." := lNewGenJnlLine."Line No.";
        ShopPaymEntries.FSONBCProcessed := true;
        ShopPaymEntries.modify();
    end;

    local procedure InsertInvoiceGenJnlLine(Location: Code[10]; PostingDate: Date);
    var
        lGenJnlBatch: Record "Gen. Journal Batch";
        lCurrGenJnlLine: Record "Gen. Journal Line";
        lNewGenJnlLine: Record "Gen. Journal Line";
        lGenJnlTemplate: Record "Gen. Journal Template";
        i: Integer;
        j: Integer;
        lIntNewLineNo: Integer;
    begin
        gGlobalDim1 := '';
        gGlobalDim2 := '';
        i := GetCustOpenInvoices(GetConsCustNo(Location), PostingDate);
        if i = 0 then i := 1;
        FOR j := 1 TO i DO begin
            lGenJnlTemplate.ReadIsolation(IsolationLevel::ReadUncommitted);
            lGenJnlTemplate.SetLoadFields("Source Code");
            lGenJnlTemplate.get(gGenJnlTemplate);
            lGenJnlBatch.ReadIsolation(IsolationLevel::ReadUncommitted);
            lGenJnlBatch.SetLoadFields("Reason Code", "Posting No. Series", "Bal. Account Type", "Bal. Account No.");
            lGenJnlBatch.get(gGenJnlTemplate, gGenJnlBatch);
            if gGenJnlDocNo = '' then
                GetnextGenJnlDocNo(PostingDate);

            lCurrGenJnlLine.ReadIsolation(IsolationLevel::UpdLock);
            lCurrGenJnlLine.SetRange("Journal Template Name", gGenJnlTemplate);
            lCurrGenJnlLine.SetRange("Journal Batch Name", gGenJnlBatch);
            lCurrGenJnlLine.SetLoadFields("Line No.");
            if lCurrGenJnlLine.findlast() then
                lIntNewLineNo := lCurrGenJnlLine."Line No." + 10000
            else
                lIntNewLineNo := 10000;

            lNewGenJnlLine.init();
            lNewGenJnlLine."Journal Template Name" := gGenJnlTemplate;
            lNewGenJnlLine."Journal Batch Name" := gGenJnlBatch;
            lNewGenJnlLine."Line No." := lIntNewLineNo;
            lNewGenJnlLine."Source Code" := lGenJnlTemplate."Source Code";
            lNewGenJnlLine."Reason Code" := lGenJnlBatch."Reason Code";
            lNewGenJnlLine."Posting No. Series" := lGenJnlBatch."Posting No. Series";
            lNewGenJnlLine."Bal. Account Type" := lGenJnlBatch."Bal. Account Type";
            lNewGenJnlLine.validate("Bal. Account No.", lGenJnlBatch."Bal. Account No.");
            lNewGenJnlLine.Insert(true);

            lNewGenJnlLine.validate("Posting Date", PostingDate);
            lNewGenJnlLine.validate("Account Type", lNewGenJnlLine."Account Type"::Customer);
            lNewGenJnlLine.validate("Account No.", GetConsCustNo(Location));
            lNewGenJnlLine.validate("Document Type", lNewGenJnlLine."Document Type"::" ");
            lNewGenJnlLine."Document No." := gGenJnlDocNo;
            lNewGenJnlLine."Applies-to Doc. Type" := lNewGenJnlLine."Applies-to Doc. Type"::Invoice;
            lNewGenJnlLine.validate("Applies-to Doc. No.", GetCustOpenInvoiceNo(lNewGenJnlLine."Account No.", PostingDate, j));
            GetApplyToDocAmount(lNewGenJnlLine);
            lNewGenJnlLine.modify(true);
            gGlobalDim1 := lNewGenJnlLine."Shortcut Dimension 1 Code";
            gGlobalDim2 := lNewGenJnlLine."Shortcut Dimension 2 Code";
        end;
    end;

    local procedure LookupGenJnlBatch();
    var
        lGenJnlBatch: Record "Gen. Journal Batch";
    begin
        lGenJnlBatch.SetRange("Journal Template Name", gGenJnlTemplate);
        if page.RunModal(0, lGenJnlBatch) = ACTION::LookupOK then begin
            if lGenJnlBatch."No. Series" = '' then
                lGenJnlBatch.FieldError("No. Series");
            gGenJnlBatch := lGenJnlBatch.Name;
        end;
    end;

    local procedure GetnextGenJnlDocNo(date_Posting: Date);
    var
        lGenJnlBatch: Record "Gen. Journal Batch";
        lGenJnlLine: Record "Gen. Journal Line";
        lGenJnlTemplate: Record "Gen. Journal Template";
        lNoSeriesMgt: Codeunit "No. Series";
    begin
        lGenJnlTemplate.get(gGenJnlTemplate);
        lGenJnlBatch.get(gGenJnlTemplate, gGenJnlBatch);
        lGenJnlLine.SetRange("Journal Template Name", gGenJnlTemplate);
        lGenJnlLine.SetRange("Journal Batch Name", gGenJnlBatch);
        lGenJnlLine.ReadIsolation(IsolationLevel::ReadUncommitted);
        lGenJnlLine.SetLoadFields("Document No.");
        if lGenJnlLine.findlast() then
            gGenJnlDocNo := lGenJnlLine."Document No."
        else
            if lGenJnlBatch."No. Series" <> '' then
                gGenJnlDocNo := lNoSeriesMgt.getnextNo(lGenJnlBatch."No. Series", date_Posting, false);
    end;

    local procedure GetShopPaymentBatch(VAR pGenJournalBatch: Record "Gen. Journal Batch"; LocationCode: Code[10])
    var
        lGlsetup: Record "General Ledger Setup";
        lBatchName: Text[10];
    begin
        lGlsetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        lGlsetup.SetLoadFields("FSONBCDefault Shop Pmt. Jrnl");
        lGlsetup.get();
        lGlsetup.TestField("FSONBCDefault Shop Pmt. Jrnl");
        FSONBCLocation.ReadIsolation(IsolationLevel::ReadUncommitted);
        FSONBCLocation.SetLoadFields(Name);
        FSONBCLocation.get(LocationCode);

        if not (FSONBCLocation.Name = '') then
            lBatchName := CopyStr(FSONBCLocation.Name, 1, MaxStrLen(pGenJournalBatch.Name))
        else
            lBatchName := FSONBCLocation.Code;

        if pGenJournalBatch.get(lGlsetup."FSONBCDefault Shop Pmt. Jrnl", lBatchName) then
            exit;

        clear(pGenJournalBatch);
        pGenJournalBatch."Journal Template Name" := lGlsetup."FSONBCDefault Shop Pmt. Jrnl";
        pGenJournalBatch.Name := lBatchName;
        pGenJournalBatch.SetupNewBatch();
        pGenJournalBatch.Insert(true);
    end;

    var
        gGLSetup: Record "General Ledger Setup";
        gGenJnlBatch: Code[10];
        gGenJnlTemplate: Code[10];
        gLocation: Code[10];
        gGenJnlDocNo: Code[20];
        gGlobalDim1: Code[20];
        gGlobalDim2: Code[20];
        gPostingDate: Date;

}

