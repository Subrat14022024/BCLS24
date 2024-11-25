namespace BCLS.BCLS;
using Microsoft.Inventory.Location;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.ReceivablesPayables;

report 50100 "Process shop payment entries"
{

    ApplicationArea = all;
    Caption = 'Process shop payment entries';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Location; Location)
        {
            RequestFilterFields = "Code";
            dataitem("Shop Payment Entries"; "Shop Payment Entries")
            {
                DataItemLink = "Location Code" = field(Code);
                DataItemTableView = sorting(Processed, Date, "Location Code")
                                    where(Processed = const(false));
                RequestFilterFields = Date, "Location Code";

                trigger OnAfterGetRecord();
                var
                    Grec_Customer: Record Customer;
                    DefaultDimension: Record "Default Dimension";
                    GenJournalBatch: Record "Gen. Journal Batch";

                begin
                    Gcod_GenJnlDocNo := '';

                    case "Type of Posting" of
                        "Type of Posting"::Kluis:
                            begin
                                if not (Location.Name = '') then
                                    Gcod_GenJnlBatch1 := COPYSTR(Location.Name, 1, MAXSTRLEN(GenJournalBatch.Name))
                                else
                                    Gcod_GenJnlBatch1 := Location.Code;

                                if not GenJournalBatch.get(GLSetup."Gen. Jnl. Template Safe Jrnl.", Gcod_GenJnlBatch1) then begin
                                    CLEAR(GenJournalBatch);
                                    GenJournalBatch."Journal Template Name" := GLSetup."Gen. Jnl. Template Safe Jrnl.";
                                    GenJournalBatch.Name := Gcod_GenJnlBatch1;
                                    GenJournalBatch.SetupNewBatch();
                                    GenJournalBatch.Insert(true);
                                    Gcod_GenJnlTemplate1 := GenJournalBatch."Journal Template Name";
                                    Gcod_GenJnlBatch1 := GenJournalBatch.Name;
                                end;

                                // if Location."PFS Consumer Customer No." <> '' then begin
                                //     if DefaultDimension.get(DATABASE::Customer, Location."PFS Consumer Customer No.", GLSetup."Shortcut Dimension 1 Code") then
                                //         GlobalDim1 := DefaultDimension."Dimension Value Code";
                                //     if DefaultDimension.get(DATABASE::Customer, Location."PFS Consumer Customer No.", GLSetup."Shortcut Dimension 2 Code") then
                                //         GlobalDim2 := DefaultDimension."Dimension Value Code";
                                // end;
                                Grec_Customer.SetRange("Location Code", "Shop Payment Entries"."Location Code");
                                if Grec_Customer.FindFirst() then begin
                                    if DefaultDimension.get(DATABASE::Customer, Grec_Customer."No.", GLSetup."Shortcut Dimension 1 Code") then
                                        GlobalDim1 := DefaultDimension."Dimension Value Code";
                                    if DefaultDimension.get(DATABASE::Customer, Grec_Customer."No.", GLSetup."Shortcut Dimension 2 Code") then
                                        GlobalDim2 := DefaultDimension."Dimension Value Code";
                                end;


                            end;
                        else
                            getShopPaymentBatch(GenJournalBatch, Location.Code);
                            Gcod_GenJnlTemplate1 := GenJournalBatch."Journal Template Name";
                            Gcod_GenJnlBatch1 := GenJournalBatch.Name;

                            if (Gcod_Location <> "Location Code") or (Gdate_Posting <> Date) then begin
                                Gcod_Location := "Location Code";
                                Gdate_Posting := Date;
                                Fct_InsertInvoiceGenJnlLine(Gcod_Location, Gdate_Posting);
                            end;
                    end;

                    Gcod_GenJnlTemplate1 := GenJournalBatch."Journal Template Name";
                    Gcod_GenJnlBatch1 := GenJournalBatch.Name;

                    Fct_InsertGenJnlLine("Shop Payment Entries");
                end;

                trigger OnPostDataItem();
                var
                    GenJournalBatch: Record "Gen. Journal Batch";
                // lrec_GenJnlLine: Record "Gen. Journal Line";
                // ldat_postDate: Date;
                // ldec_totDif: Decimal;
                begin

                    getShopPaymentBatch(GenJournalBatch, Location.Code);
                    Gcod_GenJnlTemplate1 := GenJournalBatch."Journal Template Name";
                    Gcod_GenJnlBatch1 := GenJournalBatch.Name;

                    // if ICSetup."Process Differences" then begin
                    //     lrec_GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                    //     lrec_GenJnlLine.SetRange("Journal Template Name", Gcod_GenJnlTemplate1);
                    //     lrec_GenJnlLine.SetRange("Journal Batch Name", Gcod_GenJnlBatch1);
                    //     lrec_GenJnlLine.SetRange("Document No.", Gcod_GenJnlDocNo);
                    //     if lrec_GenJnlLine.FindSet() then
                    //         repeat
                    //             if lrec_GenJnlLine."Account No." <> ICSetup."Difference Account" then begin
                    //                 ldat_postDate := lrec_GenJnlLine."Posting Date";
                    //                 lrec_GenJnlLine.SetRange("Posting Date", ldat_postDate);
                    //                 ldec_totDif := 0;
                    //                 repeat
                    //                     ldec_totDif += lrec_GenJnlLine.Amount;
                    //                 until lrec_GenJnlLine.next() = 0;
                    //                 if ABS(ldec_totDif) <> 0 then
                    //                     if ABS(ldec_totDif) < ICSetup."Max Diff to Allow Post GenJrnl" then
                    //                         fct_InsertGenJnlLineForDifference(lrec_GenJnlLine."Line No." + 10, ICSetup."Difference Account", ldat_postDate, -ldec_totDif);
                    //                 lrec_GenJnlLine.SetRange("Posting Date");
                    //             end;
                    //         until lrec_GenJnlLine.next() = 0;
                    // end;
                end;

                trigger OnPreDataItem();
                var
                    EmptyDateFormula: DateFormula;
                    endDate: Date;
                    StartDate: Date;
                begin
                    CLEAR(StartDate);
                    CLEAR(endDate);
                    if GLSetup."Create Shop Inv DateFilter" <> EmptyDateFormula then
                        StartDate := CALCDATE(GLSetup."Create Shop Inv DateFilter")
                    else begin
                        StartDate := CalcDate(EmptyDateFormula);
                        endDate := StartDate;
                    end;
                    endDate := WorkDate();
                    SETFILTER(Date, STRSUBSTNO('%1..%2', StartDate, endDate));
                end;
            }

            trigger OnAfterGetRecord();
            var
                Cust: Record Customer;
            begin
                // if "PFS Consumer Customer No." = '' then
                //     CurrReport.Skip();
                // if not Cust.get("PFS Consumer Customer No.") then
                //     CurrReport.Skip();
                cust.SetRange("Location Code", Location.Code);
                if Cust.IsEmpty() then
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
                field(Gcod_GenJnlTemplate; Gcod_GenJnlTemplate1)
                {
                    ApplicationArea = all;
                    Caption = 'Gen. journal template';
                    TableRelation = "Gen. Journal Template".Name;
                    ToolTip = 'Fill the general journal template';
                }
                field(Gcod_GenJnlBatch; Gcod_GenJnlBatch1)
                {
                    ApplicationArea = all;
                    Caption = 'Gen. journal batch';
                    TableRelation = "Gen. Journal Batch".Name;
                    ToolTip = 'Fill the general journal template';

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Fct_LookupGenJnlBatch();
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
        //ICSetup.get();
        GLSetup.get();
    end;

    var
        //ICSetup: Record "11006900";
        GLSetup: Record "General Ledger Setup";
        Gcod_GenJnlBatch1: Code[10];
        Gcod_GenJnlTemplate1: Code[10];
        Gcod_Location: Code[10];
        Gcod_GenJnlDocNo: Code[20];
        GlobalDim1: Code[20];
        GlobalDim2: Code[20];
        Gdate_Posting: Date;

    procedure Fct_GetApplyToDocAmount(var PRec_GenJnlLine: Record "Gen. Journal Line");
    var
        LRec_CustLedgEntry: Record "Cust. Ledger Entry";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
    begin
        if PRec_GenJnlLine."Account Type" <> PRec_GenJnlLine."Account Type"::Customer then
            exit;

        LRec_CustLedgEntry.setcurrentkey("Customer No.", Open, Positive, "Due Date");
        LRec_CustLedgEntry.SetRange("Customer No.", PRec_GenJnlLine."Account No.");
        LRec_CustLedgEntry.SetRange(Open, true);
        LRec_CustLedgEntry.SetRange("Document Type", PRec_GenJnlLine."Applies-to Doc. Type");
        LRec_CustLedgEntry.SetRange("Document No.", PRec_GenJnlLine."Applies-to Doc. No.");
        if LRec_CustLedgEntry.FindFirst() then begin
            if PRec_GenJnlLine."Currency Code" <> LRec_CustLedgEntry."Currency Code" then
                PRec_GenJnlLine.VALIDATE("Currency Code", LRec_CustLedgEntry."Currency Code");
            LRec_CustLedgEntry.CALCFIELDS("Remaining Amount");
            if LRec_CustLedgEntry."Amount to Apply" <> 0 then begin
                //if LCdu_GenJnlPostLine.CheckCalcPmtDiscGenJnlCust(PRec_GenJnlLine, LRec_CustLedgEntry, 0, false) then begin
                if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(PRec_GenJnlLine, LRec_CustLedgEntry, 0, false) then begin
                    if ABS(LRec_CustLedgEntry."Amount to Apply") >=
                       ABS(LRec_CustLedgEntry."Remaining Amount" - LRec_CustLedgEntry."Remaining Pmt. Disc. Possible") then
                        PRec_GenJnlLine.Amount := -(LRec_CustLedgEntry."Remaining Amount" - LRec_CustLedgEntry."Remaining Pmt. Disc. Possible")
                    else
                        PRec_GenJnlLine.Amount := -LRec_CustLedgEntry."Amount to Apply";
                end else
                    PRec_GenJnlLine.Amount := -LRec_CustLedgEntry."Amount to Apply";
            end else
                //if LCdu_GenJnlPostLine.CheckCalcPmtDiscGenJnlCust(PRec_GenJnlLine, LRec_CustLedgEntry, 0, false) then
                if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(PRec_GenJnlLine, LRec_CustLedgEntry, 0, false) then
                    PRec_GenJnlLine.Amount := -(LRec_CustLedgEntry."Remaining Amount" - LRec_CustLedgEntry."Remaining Pmt. Disc. Possible")
                else
                    PRec_GenJnlLine.Amount := -LRec_CustLedgEntry."Remaining Amount";
            if PRec_GenJnlLine."Bal. Account Type" IN [PRec_GenJnlLine."Bal. Account Type"::Customer, PRec_GenJnlLine."Bal. Account Type"::Vendor] then
                PRec_GenJnlLine.Amount := -PRec_GenJnlLine.Amount;
            PRec_GenJnlLine.VALIDATE(Amount);
            PRec_GenJnlLine."Applies-to Doc. Type" := LRec_CustLedgEntry."Document Type";
            PRec_GenJnlLine."Applies-to Doc. No." := LRec_CustLedgEntry."Document No.";
            PRec_GenJnlLine."Applies-to ID" := '';
        end;
    end;

    procedure Fct_GetConsCustNo(Pcod_Location: Code[10]): Code[20];
    var
        //LRec_Location: Record Location;
        LRec_Customer: Record Customer;
    begin
        // LRec_Location.get(Pcod_Location);
        // exit(LRec_Location."PFS Consumer Customer No.");
        LRec_Customer.SetRange("Location Code", Pcod_Location);
        if LRec_Customer.FindLast() then
            exit(LRec_Customer."Location Code");
    end;

    procedure Fct_GetCustOpenInvoiceNo(Pcod_CustNo: Code[20]; Pdate_Posting: Date; InvNo: Integer): Code[20];
    var
        LRec_CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        LRec_CustLedgEntry.setcurrentkey("Document Type", "Customer No.", "Posting Date", "Currency Code");
        LRec_CustLedgEntry.SetRange("Document Type", LRec_CustLedgEntry."Document Type"::Invoice);
        LRec_CustLedgEntry.SetRange("Customer No.", Pcod_CustNo);
        LRec_CustLedgEntry.SetRange("Posting Date", Pdate_Posting);
        LRec_CustLedgEntry.SetRange(Open, true);
        if LRec_CustLedgEntry.FindSet() then begin
            if InvNo > 1 then
                LRec_CustLedgEntry.next(InvNo - 1);
            exit(LRec_CustLedgEntry."Document No.");
        end;
    end;

    procedure Fct_GetCustOpenInvoices(Pcod_CustNo: Code[20]; Pdate_Posting: Date): Integer;
    var
        LRec_CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        LRec_CustLedgEntry.setcurrentkey("Document Type", "Customer No.", "Posting Date", "Currency Code");
        LRec_CustLedgEntry.SetRange("Document Type", LRec_CustLedgEntry."Document Type"::Invoice);
        LRec_CustLedgEntry.SetRange("Customer No.", Pcod_CustNo);
        LRec_CustLedgEntry.SetRange("Posting Date", Pdate_Posting);
        LRec_CustLedgEntry.SetRange(Open, true);
        exit(LRec_CustLedgEntry.COUNT);
    end;

    procedure Fct_InsertGenJnlLine(PRec_ShopPaymEntries: Record "Shop Payment Entries");
    var
        LRec_GenJnlBatch: Record "Gen. Journal Batch";
        LRec_CurrGenJnlLine: Record "Gen. Journal Line";
        LRec_NewGenJnlLine: Record "Gen. Journal Line";
        LRec_GenJnlTemplate: Record "Gen. Journal Template";
        Lint_NewLineNo: Integer;
    begin
        LRec_GenJnlTemplate.get(Gcod_GenJnlTemplate1);
        LRec_GenJnlBatch.get(Gcod_GenJnlTemplate1, Gcod_GenJnlBatch1);
        if Gcod_GenJnlDocNo = '' then
            Fct_GetnextGenJnlDocNo(PRec_ShopPaymEntries.Date);

        LRec_NewGenJnlLine.LOCKTABLE();
        LRec_CurrGenJnlLine.SetRange("Journal Template Name", Gcod_GenJnlTemplate1);
        LRec_CurrGenJnlLine.SetRange("Journal Batch Name", Gcod_GenJnlBatch1);
        if LRec_CurrGenJnlLine.findlast() then
            Lint_NewLineNo := LRec_CurrGenJnlLine."Line No." + 10000
        else
            Lint_NewLineNo := 10000;

        LRec_NewGenJnlLine.init();
        LRec_NewGenJnlLine."Journal Template Name" := Gcod_GenJnlTemplate1;
        LRec_NewGenJnlLine."Journal Batch Name" := Gcod_GenJnlBatch1;
        LRec_NewGenJnlLine."Line No." := Lint_NewLineNo;
        LRec_NewGenJnlLine."Source Code" := LRec_GenJnlTemplate."Source Code";
        LRec_NewGenJnlLine."Reason Code" := LRec_GenJnlBatch."Reason Code";
        LRec_NewGenJnlLine."Posting No. Series" := LRec_GenJnlBatch."Posting No. Series";
        LRec_NewGenJnlLine."Bal. Account Type" := LRec_GenJnlBatch."Bal. Account Type";
        LRec_NewGenJnlLine.VALIDATE("Bal. Account No.", LRec_GenJnlBatch."Bal. Account No.");
        LRec_NewGenJnlLine.Insert(true);

        LRec_NewGenJnlLine.VALIDATE("Posting Date", PRec_ShopPaymEntries.Date);
        LRec_NewGenJnlLine.VALIDATE("Account Type", LRec_NewGenJnlLine."Account Type"::"G/L Account");
        LRec_NewGenJnlLine.VALIDATE("Account No.", PRec_ShopPaymEntries."G/L Account No.");
        LRec_NewGenJnlLine.VALIDATE("Document Type", LRec_NewGenJnlLine."Document Type"::" ");
        LRec_NewGenJnlLine."Document No." := Gcod_GenJnlDocNo;
        if PRec_ShopPaymEntries.Description <> '' then
            LRec_NewGenJnlLine.Description := PRec_ShopPaymEntries.Description;
        if PRec_ShopPaymEntries."Total Amount Transactions" >= 0 then
            LRec_NewGenJnlLine.VALIDATE("Debit Amount", PRec_ShopPaymEntries."Total Amount Transactions")
        else
            LRec_NewGenJnlLine.VALIDATE("Credit Amount", -PRec_ShopPaymEntries."Total Amount Transactions");
        //"Shop Payment Entry No." := PRec_ShopPaymEntries."Entry No."; commented by subrat

        LRec_NewGenJnlLine.VALIDATE(LRec_NewGenJnlLine."Shortcut Dimension 1 Code", GlobalDim1);
        LRec_NewGenJnlLine.VALIDATE(LRec_NewGenJnlLine."Shortcut Dimension 2 Code", GlobalDim2);
        LRec_NewGenJnlLine.modify(true);

        PRec_ShopPaymEntries."Gen. Journal Template" := LRec_NewGenJnlLine."Journal Template Name";
        PRec_ShopPaymEntries."Gen. Journal Batch" := LRec_NewGenJnlLine."Journal Batch Name";
        PRec_ShopPaymEntries."Gen. Journal Line No." := LRec_NewGenJnlLine."Line No.";
        PRec_ShopPaymEntries.Processed := true;
        PRec_ShopPaymEntries.modify();
    end;

    procedure fct_InsertGenJnlLineForDifference(pLineNo: Integer; pAccountNo: Code[20]; pDate: Date; pAmount: Decimal);
    var
        LRec_GenJnlBatch: Record "Gen. Journal Batch";
        LRec_NewGenJnlLine: Record "Gen. Journal Line";
        LRec_GenJnlTemplate: Record "Gen. Journal Template";
    begin
        LRec_GenJnlTemplate.get(Gcod_GenJnlTemplate1);
        LRec_GenJnlBatch.get(Gcod_GenJnlTemplate1, Gcod_GenJnlBatch1);
        LRec_NewGenJnlLine.LOCKTABLE();
        LRec_NewGenJnlLine.init();
        LRec_NewGenJnlLine."Journal Template Name" := Gcod_GenJnlTemplate1;
        LRec_NewGenJnlLine."Journal Batch Name" := Gcod_GenJnlBatch1;
        LRec_NewGenJnlLine."Line No." := pLineNo;
        LRec_NewGenJnlLine."Source Code" := LRec_GenJnlTemplate."Source Code";
        LRec_NewGenJnlLine."Reason Code" := LRec_GenJnlBatch."Reason Code";
        LRec_NewGenJnlLine."Posting No. Series" := LRec_GenJnlBatch."Posting No. Series";
        LRec_NewGenJnlLine."Bal. Account Type" := LRec_GenJnlBatch."Bal. Account Type";
        LRec_NewGenJnlLine.VALIDATE("Bal. Account No.", LRec_GenJnlBatch."Bal. Account No.");
        LRec_NewGenJnlLine.Insert(true);

        LRec_NewGenJnlLine.VALIDATE("Posting Date", pDate);
        LRec_NewGenJnlLine.VALIDATE("Account Type", LRec_NewGenJnlLine."Account Type"::"G/L Account");
        LRec_NewGenJnlLine.VALIDATE("Account No.", pAccountNo);
        LRec_NewGenJnlLine.VALIDATE("Document Type", LRec_NewGenJnlLine."Document Type"::" ");
        LRec_NewGenJnlLine."Document No." := Gcod_GenJnlDocNo;
        LRec_NewGenJnlLine.VALIDATE(Amount, pAmount);
        LRec_NewGenJnlLine.VALIDATE(LRec_NewGenJnlLine."Shortcut Dimension 1 Code", GlobalDim1);
        LRec_NewGenJnlLine.VALIDATE(LRec_NewGenJnlLine."Shortcut Dimension 2 Code", GlobalDim2);
        LRec_NewGenJnlLine.modify(true);
    end;

    procedure Fct_InsertInvoiceGenJnlLine(Pcod_Location: Code[10]; Pdate_Posting: Date);
    var
        LRec_GenJnlBatch: Record "Gen. Journal Batch";
        LRec_CurrGenJnlLine: Record "Gen. Journal Line";
        LRec_NewGenJnlLine: Record "Gen. Journal Line";
        LRec_GenJnlTemplate: Record "Gen. Journal Template";
        i: Integer;
        j: Integer;
        Lint_NewLineNo: Integer;
    begin
        GlobalDim1 := '';
        GlobalDim2 := '';
        i := Fct_GetCustOpenInvoices(Fct_GetConsCustNo(Pcod_Location), Pdate_Posting);
        if i = 0 then i := 1;
        FOR j := 1 TO i DO begin
            LRec_GenJnlTemplate.get(Gcod_GenJnlTemplate1);
            LRec_GenJnlBatch.get(Gcod_GenJnlTemplate1, Gcod_GenJnlBatch1);
            if Gcod_GenJnlDocNo = '' then
                Fct_GetnextGenJnlDocNo(Pdate_Posting);

            LRec_NewGenJnlLine.LOCKTABLE();
            LRec_CurrGenJnlLine.SetRange("Journal Template Name", Gcod_GenJnlTemplate1);
            LRec_CurrGenJnlLine.SetRange("Journal Batch Name", Gcod_GenJnlBatch1);
            if LRec_CurrGenJnlLine.findlast() then
                Lint_NewLineNo := LRec_CurrGenJnlLine."Line No." + 10000
            else
                Lint_NewLineNo := 10000;

            LRec_NewGenJnlLine.init();
            LRec_NewGenJnlLine."Journal Template Name" := Gcod_GenJnlTemplate1;
            LRec_NewGenJnlLine."Journal Batch Name" := Gcod_GenJnlBatch1;
            LRec_NewGenJnlLine."Line No." := Lint_NewLineNo;
            LRec_NewGenJnlLine."Source Code" := LRec_GenJnlTemplate."Source Code";
            LRec_NewGenJnlLine."Reason Code" := LRec_GenJnlBatch."Reason Code";
            LRec_NewGenJnlLine."Posting No. Series" := LRec_GenJnlBatch."Posting No. Series";
            LRec_NewGenJnlLine."Bal. Account Type" := LRec_GenJnlBatch."Bal. Account Type";
            LRec_NewGenJnlLine.VALIDATE("Bal. Account No.", LRec_GenJnlBatch."Bal. Account No.");
            LRec_NewGenJnlLine.Insert(true);

            LRec_NewGenJnlLine.VALIDATE("Posting Date", Pdate_Posting);
            LRec_NewGenJnlLine.VALIDATE("Account Type", LRec_NewGenJnlLine."Account Type"::Customer);
            LRec_NewGenJnlLine.VALIDATE("Account No.", Fct_GetConsCustNo(Pcod_Location));
            LRec_NewGenJnlLine.VALIDATE("Document Type", LRec_NewGenJnlLine."Document Type"::" ");
            LRec_NewGenJnlLine."Document No." := Gcod_GenJnlDocNo;
            LRec_NewGenJnlLine."Applies-to Doc. Type" := LRec_NewGenJnlLine."Applies-to Doc. Type"::Invoice;
            LRec_NewGenJnlLine.VALIDATE("Applies-to Doc. No.", Fct_GetCustOpenInvoiceNo(LRec_NewGenJnlLine."Account No.", Pdate_Posting, j));
            Fct_GetApplyToDocAmount(LRec_NewGenJnlLine);
            LRec_NewGenJnlLine.modify(true);
            GlobalDim1 := LRec_NewGenJnlLine."Shortcut Dimension 1 Code";
            GlobalDim2 := LRec_NewGenJnlLine."Shortcut Dimension 2 Code";

        end;
    end;

    procedure Fct_LookupGenJnlBatch();
    var
        LRec_GenJnlBatch: Record "Gen. Journal Batch";
    begin
        LRec_GenJnlBatch.SetRange("Journal Template Name", Gcod_GenJnlTemplate1);
        if PAGE.RUNMODAL(0, LRec_GenJnlBatch) = ACTION::LookupOK then begin
            if LRec_GenJnlBatch."No. Series" = '' then
                LRec_GenJnlBatch.FIELDERROR("No. Series");
            Gcod_GenJnlBatch1 := LRec_GenJnlBatch.Name;
        end;
    end;

    local procedure Fct_GetnextGenJnlDocNo(Pdate_Posting: Date);
    var
        LRec_GenJnlBatch: Record "Gen. Journal Batch";
        LRec_GenJnlLine: Record "Gen. Journal Line";
        LRec_GenJnlTemplate: Record "Gen. Journal Template";
        LCdu_NoSeriesMgt: Codeunit "No. Series";
    begin
        LRec_GenJnlTemplate.get(Gcod_GenJnlTemplate1);
        LRec_GenJnlBatch.get(Gcod_GenJnlTemplate1, Gcod_GenJnlBatch1);
        LRec_GenJnlLine.SetRange("Journal Template Name", Gcod_GenJnlTemplate1);
        LRec_GenJnlLine.SetRange("Journal Batch Name", Gcod_GenJnlBatch1);
        if LRec_GenJnlLine.findlast() then
            Gcod_GenJnlDocNo := LRec_GenJnlLine."Document No."
        else
            if LRec_GenJnlBatch."No. Series" <> '' then
                Gcod_GenJnlDocNo := LCdu_NoSeriesMgt.getnextNo(LRec_GenJnlBatch."No. Series", Pdate_Posting, false);
    end;

    local procedure GetShopPaymentBatch(var GenJournalBatch: Record "Gen. Journal Batch"; LocationCode: Code[10])
    var
        lrecGlsetup: Record "General Ledger Setup";
        BatchName: Text[10];

    begin
        lrecGlsetup.TESTFIELD("Default Shop Payment Journal");
        Location.GET(LocationCode);

        if not (Location.Name = '') then
            BatchName := COPYSTR(Location.Name, 1, MAXSTRLEN(GenJournalBatch.Name))
        else
            BatchName := Location.Code;

        if GenJournalBatch.GET(lrecGlsetup."Default Shop Payment Journal", BatchName) then
            exit;

        CLEAR(GenJournalBatch);
        GenJournalBatch."Journal Template Name" := lrecGlsetup."Default Shop Payment Journal";
        GenJournalBatch.Name := BatchName;
        GenJournalBatch.SetupNewBatch();
        GenJournalBatch.INSERT(true);
    end;
}

