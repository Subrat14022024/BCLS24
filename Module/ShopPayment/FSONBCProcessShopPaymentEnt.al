namespace BCLS.BCLS;
using Microsoft.Inventory.Location;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.Receivables;
using Microsoft.Manufacturing.Capacity;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Journal;

report 50100 "Process shop payment entries"
{

    CaptionML = ENU = 'Process shop payment entries',
                FRA = 'Traiter les écritures paiement magasin';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Location; Location)
        {
            RequestFilterFields = "Code";
            dataitem("Shop Payment Entries"; "Shop Payment Entries")
            {
                DataItemLink = "Location Code" = FIELD(Code);
                DataItemTableView = SORTING(Processed, Date, "Location Code", "Subsidiary Code")
                                    WHERE(Processed = const(false));
                RequestFilterFields = Date, "Location Code", "Subsidiary Code";

                trigger OnAfterGetRecord();
                var
                    DefaultDimension: Record "Default Dimension";
                    GenJournalBatch: Record "Gen. Journal Batch";
                begin
                    Gcod_GenJnlDocNo := '';

                    CASE "Type of Posting" OF
                        "Type of Posting"::Kluis:
                            begin
                                if NOT (Location.Name = '') then
                                    Gcod_GenJnlBatch1 := COPYSTR(Location.Name, 1, MAXSTRLEN(GenJournalBatch.Name))
                                else
                                    Gcod_GenJnlBatch1 := Location.Code;

                                if NOT GenJournalBatch.get(GLSetup."Gen. Jnl. Template Safe Jrnl.", Gcod_GenJnlBatch1) then begin
                                    CLEAR(GenJournalBatch);
                                    GenJournalBatch."Journal Template Name" := GLSetup."Gen. Jnl. Template Safe Jrnl.";
                                    GenJournalBatch.Name := Gcod_GenJnlBatch1;
                                    GenJournalBatch.SetupNewBatch();
                                    GenJournalBatch.insert(true);
                                    Gcod_GenJnlTemplate1 := GenJournalBatch."Journal Template Name";
                                    Gcod_GenJnlBatch1 := GenJournalBatch.Name;
                                end;

                                if Location."PFS Consumer Customer No." <> '' then begin
                                    if DefaultDimension.get(DATABASE::Customer, Location."PFS Consumer Customer No.", GLSetup."Shortcut Dimension 1 Code") then
                                        GlobalDim1 := DefaultDimension."Dimension Value Code";
                                    if DefaultDimension.get(DATABASE::Customer, Location."PFS Consumer Customer No.", GLSetup."Shortcut Dimension 2 Code") then
                                        GlobalDim2 := DefaultDimension."Dimension Value Code";
                                end;
                            end;
                        else
                            ICSetup.getShopPaymentBatch(GenJournalBatch, Location.Code);
                            Gcod_GenJnlTemplate1 := GenJournalBatch."Journal Template Name";
                            Gcod_GenJnlBatch1 := GenJournalBatch.Name;

                            if (Gcod_Location <> "Location Code") or (Gdate_Posting <> Date) then begin
                                Gcod_Location := "Location Code";
                                Gdate_Posting := Date;
                                Fct_insertInvoiceGenJnlLine(Gcod_Location, Gdate_Posting);
                            end;
                    end;

                    Gcod_GenJnlTemplate1 := GenJournalBatch."Journal Template Name";
                    Gcod_GenJnlBatch1 := GenJournalBatch.Name;

                    Fct_insertGenJnlLine("Shop Payment Entries");
                end;

                trigger OnPostDataItem();
                var
                    GenJournalBatch: Record "Gen. Journal Batch";
                    lrec_GenJnlLine: Record "Gen. Journal Line";
                    ldat_postDate: Date;
                    ldec_totDif: Decimal;
                begin

                    ICSetup.getShopPaymentBatch(GenJournalBatch, Location.Code);
                    Gcod_GenJnlTemplate1 := GenJournalBatch."Journal Template Name";
                    Gcod_GenJnlBatch1 := GenJournalBatch.Name;

                    if ICSetup."Process Differences" then begin
                        lrec_GenJnlLine.setcurrentkey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                        lrec_GenJnlLine.setrange("Journal Template Name", Gcod_GenJnlTemplate1);
                        lrec_GenJnlLine.setrange("Journal Batch Name", Gcod_GenJnlBatch1);
                        lrec_GenJnlLine.setrange("Document No.", Gcod_GenJnlDocNo);
                        if lrec_GenJnlLine.FindSet() then
                            repeat
                                if lrec_GenJnlLine."Account No." <> ICSetup."Difference Account" then begin
                                    ldat_postDate := lrec_GenJnlLine."Posting Date";
                                    lrec_GenJnlLine.setrange("Posting Date", ldat_postDate);
                                    ldec_totDif := 0;
                                    repeat
                                        ldec_totDif += lrec_GenJnlLine.Amount;
                                    until lrec_GenJnlLine.next() = 0;
                                    if ABS(ldec_totDif) <> 0 then
                                        if ABS(ldec_totDif) < ICSetup."Max Diff to Allow Post GenJrnl" then
                                            fct_insertGenJnlLineForDifference(lrec_GenJnlLine."Line No." + 10, ICSetup."Difference Account", ldat_postDate, -ldec_totDif);
                                    lrec_GenJnlLine.setrange("Posting Date");
                                end;
                            until lrec_GenJnlLine.next() = 0;
                    end;
                end;

                trigger OnPreDataItem();
                var
                    EmptyDateFormula: DateFormula;
                    endDate: Date;
                    StartDate: Date;
                begin
                    CLEAR(StartDate);
                    CLEAR(endDate);
                    if ICSetup.Cr_ShopInv_StartDate_DateForm <> EmptyDateFormula then begin
                        StartDate := CALCDATE(ICSetup.Cr_ShopInv_StartDate_DateForm);
                        case ICSetup.Cr_ShopInv_PeriodLength of
                            ICSetup.Cr_ShopInv_PeriodLength::Day:
                                endDate := CALCDATE('<1D>', StartDate);
                            ICSetup.Cr_ShopInv_PeriodLength::Week:
                                endDate := CALCDATE('<1W>', StartDate);
                            ICSetup.Cr_ShopInv_PeriodLength::Month:
                                endDate := CALCDATE('<1M>', StartDate);
                            else
                                endDate := StartDate;
                        end;
                    end else
                        endDate := WorkDate();

                    SETFILTER(Date, STRSUBSTNO('%1..%2', StartDate, endDate));
                end;
            }

            trigger OnAfterGetRecord();
            var
                Cust: Record Customer;
            begin
                if "PFS Consumer Customer No." = '' then
                    CurrReport.Skip();
                if NOT Cust.get("PFS Consumer Customer No.") then
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
                    CaptionML = ENU = 'Options',
                                FRB = 'Options',
                                NLB = 'Opties';
                }
                field(Gcod_GenJnlTemplate; Gcod_GenJnlTemplate1)
                {
                    CaptionML = ENU = 'Gen. journal template',
                                FRA = 'Modèle feuille comptabilité';
                    TableRelation = "Gen. Journal Template".Name;
                }
                field(Gcod_GenJnlBatch; Gcod_GenJnlBatch1)
                {
                    CaptionML = ENU = 'Gen. journal batch',
                                FRA = 'Nom feuille comptabilité';
                    TableRelation = "Gen. Journal Batch".Name;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Fct_LookupGenJnlBatch();
                    end;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CurrReport.USEREQUESTPAGE(false);
    end;

    trigger OnPreReport();
    begin
        ICSetup.get();
        GLSetup.get();
    end;

    var
        ICSetup: Record "11006900";
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
        LCdu_GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        WITH PRec_GenJnlLine DO begin
            if "Account Type" <> "Account Type"::Customer then
                exit;

            LRec_CustLedgEntry.setcurrentkey("Customer No.", Open, Positive, "Due Date");
            LRec_CustLedgEntry.setrange("Customer No.", "Account No.");
            LRec_CustLedgEntry.setrange(Open, true);
            LRec_CustLedgEntry.setrange("Document Type", "Applies-to Doc. Type");
            LRec_CustLedgEntry.setrange("Document No.", "Applies-to Doc. No.");
            if LRec_CustLedgEntry.findfirst() then begin
                if "Currency Code" <> LRec_CustLedgEntry."Currency Code" then
                    VALIDATE("Currency Code", LRec_CustLedgEntry."Currency Code");
                LRec_CustLedgEntry.CALCFIELDS("Remaining Amount");
                if LRec_CustLedgEntry."Amount to Apply" <> 0 then begin
                    if LCdu_GenJnlPostLine.CheckCalcPmtDiscGenJnlCust(PRec_GenJnlLine, LRec_CustLedgEntry, 0, false) then begin
                        if ABS(LRec_CustLedgEntry."Amount to Apply") >=
                           ABS(LRec_CustLedgEntry."Remaining Amount" - LRec_CustLedgEntry."Remaining Pmt. Disc. Possible") then
                            Amount := -(LRec_CustLedgEntry."Remaining Amount" - LRec_CustLedgEntry."Remaining Pmt. Disc. Possible")
                        else
                            Amount := -LRec_CustLedgEntry."Amount to Apply";
                    end else
                        Amount := -LRec_CustLedgEntry."Amount to Apply";
                end else
                    if LCdu_GenJnlPostLine.CheckCalcPmtDiscGenJnlCust(PRec_GenJnlLine, LRec_CustLedgEntry, 0, false) then
                        Amount := -(LRec_CustLedgEntry."Remaining Amount" - LRec_CustLedgEntry."Remaining Pmt. Disc. Possible")
                    else
                        Amount := -LRec_CustLedgEntry."Remaining Amount";
                if "Bal. Account Type" IN ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor] then
                    Amount := -Amount;
                VALIDATE(Amount);
                "Applies-to Doc. Type" := LRec_CustLedgEntry."Document Type";
                "Applies-to Doc. No." := LRec_CustLedgEntry."Document No.";
                "Applies-to ID" := '';
            end;
        end;
    end;

    procedure Fct_GetConsCustNo(Pcod_Location: Code[10]): Code[20];
    var
        LRec_Location: Record Location;
    begin
        LRec_Location.get(Pcod_Location);
        exit(LRec_Location."PFS Consumer Customer No.");
    end;

    procedure Fct_GetCustOpenInvoiceNo(Pcod_CustNo: Code[20]; Pdate_Posting: Date; InvNo: Integer): Code[20];
    var
        LRec_CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        WITH LRec_CustLedgEntry DO begin
            setcurrentkey("Document Type", "Customer No.", "Posting Date", "Currency Code");
            setrange("Document Type", "Document Type"::Invoice);
            setrange("Customer No.", Pcod_CustNo);
            setrange("Posting Date", Pdate_Posting);
            setrange(Open, true);
            if findfirst() then begin
                if InvNo > 1 then
                    next(InvNo - 1);
                exit("Document No.");
            end;
        end;
    end;

    procedure Fct_GetCustOpenInvoices(Pcod_CustNo: Code[20]; Pdate_Posting: Date): Integer;
    var
        LRec_CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        WITH LRec_CustLedgEntry DO begin
            setcurrentkey("Document Type", "Customer No.", "Posting Date", "Currency Code");
            setrange("Document Type", "Document Type"::Invoice);
            setrange("Customer No.", Pcod_CustNo);
            setrange("Posting Date", Pdate_Posting);
            setrange(Open, true);
            exit(COUNT);
        end;
    end;

    procedure Fct_insertGenJnlLine(PRec_ShopPaymEntries: Record "Shop Payment Entries");
    var
        LRec_GenJnlBatch: Record "Gen. Journal Batch";
        LRec_CurrGenJnlLine: Record "Gen. Journal Line";
        LRec_NewGenJnlLine: Record "Gen. Journal Line";
        LRec_GenJnlTemplate: Record "Gen. Journal Template";
        Lint_NewLineNo: Integer;
    begin
        WITH LRec_NewGenJnlLine DO begin
            LRec_GenJnlTemplate.get(Gcod_GenJnlTemplate1);
            LRec_GenJnlBatch.get(Gcod_GenJnlTemplate1, Gcod_GenJnlBatch1);
            if Gcod_GenJnlDocNo = '' then
                Fct_GetnextGenJnlDocNo(PRec_ShopPaymEntries.Date);

            LOCKTABLE();
            LRec_CurrGenJnlLine.setrange("Journal Template Name", Gcod_GenJnlTemplate1);
            LRec_CurrGenJnlLine.setrange("Journal Batch Name", Gcod_GenJnlBatch1);
            if LRec_CurrGenJnlLine.findlast() then
                Lint_NewLineNo := LRec_CurrGenJnlLine."Line No." + 10000
            else
                Lint_NewLineNo := 10000;

            init();
            "Journal Template Name" := Gcod_GenJnlTemplate1;
            "Journal Batch Name" := Gcod_GenJnlBatch1;
            "Line No." := Lint_NewLineNo;
            "Source Code" := LRec_GenJnlTemplate."Source Code";
            "Reason Code" := LRec_GenJnlBatch."Reason Code";
            "Posting No. Series" := LRec_GenJnlBatch."Posting No. Series";
            "Bal. Account Type" := LRec_GenJnlBatch."Bal. Account Type";
            VALIDATE("Bal. Account No.", LRec_GenJnlBatch."Bal. Account No.");
            insert(true);

            VALIDATE("Posting Date", PRec_ShopPaymEntries.Date);
            VALIDATE("Account Type", "Account Type"::"G/L Account");
            VALIDATE("Account No.", PRec_ShopPaymEntries."G/L Account No.");
            VALIDATE("Document Type", "Document Type"::" ");
            "Document No." := Gcod_GenJnlDocNo;
            if PRec_ShopPaymEntries.Description <> '' then
                Description := PRec_ShopPaymEntries.Description;
            if PRec_ShopPaymEntries."Total Amount Transactions" >= 0 then
                VALIDATE("Debit Amount", PRec_ShopPaymEntries."Total Amount Transactions")
            else
                VALIDATE("Credit Amount", -PRec_ShopPaymEntries."Total Amount Transactions");
            "Shop Payment Entry No." := PRec_ShopPaymEntries."Entry No.";

            VALIDATE(LRec_NewGenJnlLine."Shortcut Dimension 1 Code", GlobalDim1);
            VALIDATE(LRec_NewGenJnlLine."Shortcut Dimension 2 Code", GlobalDim2);
            modify(true);

            PRec_ShopPaymEntries."Gen. Journal Template" := "Journal Template Name";
            PRec_ShopPaymEntries."Gen. Journal Batch" := "Journal Batch Name";
            PRec_ShopPaymEntries."Gen. Journal Line No." := "Line No.";
            PRec_ShopPaymEntries.Processed := true;
            PRec_ShopPaymEntries.modify();
        end;
    end;

    procedure fct_insertGenJnlLineForDifference(pLineNo: Integer; pAccountNo: Code[20]; pDate: Date; pAmount: Decimal);
    var
        LRec_GenJnlBatch: Record "Gen. Journal Batch";
        LRec_NewGenJnlLine: Record "Gen. Journal Line";
        LRec_GenJnlTemplate: Record "Gen. Journal Template";
    begin
        WITH LRec_NewGenJnlLine DO begin
            LRec_GenJnlTemplate.get(Gcod_GenJnlTemplate1);
            LRec_GenJnlBatch.get(Gcod_GenJnlTemplate1, Gcod_GenJnlBatch1);
            LOCKTABLE();
            init();
            "Journal Template Name" := Gcod_GenJnlTemplate1;
            "Journal Batch Name" := Gcod_GenJnlBatch1;
            "Line No." := pLineNo;
            "Source Code" := LRec_GenJnlTemplate."Source Code";
            "Reason Code" := LRec_GenJnlBatch."Reason Code";
            "Posting No. Series" := LRec_GenJnlBatch."Posting No. Series";
            "Bal. Account Type" := LRec_GenJnlBatch."Bal. Account Type";
            VALIDATE("Bal. Account No.", LRec_GenJnlBatch."Bal. Account No.");
            insert(true);

            VALIDATE("Posting Date", pDate);
            VALIDATE("Account Type", "Account Type"::"G/L Account");
            VALIDATE("Account No.", pAccountNo);
            VALIDATE("Document Type", "Document Type"::" ");
            "Document No." := Gcod_GenJnlDocNo;
            VALIDATE(Amount, pAmount);
            VALIDATE(LRec_NewGenJnlLine."Shortcut Dimension 1 Code", GlobalDim1);
            VALIDATE(LRec_NewGenJnlLine."Shortcut Dimension 2 Code", GlobalDim2);
            modify(true);
        end;
    end;

    procedure Fct_insertInvoiceGenJnlLine(Pcod_Location: Code[10]; Pdate_Posting: Date);
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
            WITH LRec_NewGenJnlLine DO begin
                LRec_GenJnlTemplate.get(Gcod_GenJnlTemplate1);
                LRec_GenJnlBatch.get(Gcod_GenJnlTemplate1, Gcod_GenJnlBatch1);
                if Gcod_GenJnlDocNo = '' then
                    Fct_GetnextGenJnlDocNo(Pdate_Posting);

                LOCKTABLE();
                LRec_CurrGenJnlLine.setrange("Journal Template Name", Gcod_GenJnlTemplate1);
                LRec_CurrGenJnlLine.setrange("Journal Batch Name", Gcod_GenJnlBatch1);
                if LRec_CurrGenJnlLine.findlast() then
                    Lint_NewLineNo := LRec_CurrGenJnlLine."Line No." + 10000
                else
                    Lint_NewLineNo := 10000;

                init();
                "Journal Template Name" := Gcod_GenJnlTemplate1;
                "Journal Batch Name" := Gcod_GenJnlBatch1;
                "Line No." := Lint_NewLineNo;
                "Source Code" := LRec_GenJnlTemplate."Source Code";
                "Reason Code" := LRec_GenJnlBatch."Reason Code";
                "Posting No. Series" := LRec_GenJnlBatch."Posting No. Series";
                "Bal. Account Type" := LRec_GenJnlBatch."Bal. Account Type";
                VALIDATE("Bal. Account No.", LRec_GenJnlBatch."Bal. Account No.");
                insert(true);

                VALIDATE("Posting Date", Pdate_Posting);
                VALIDATE("Account Type", "Account Type"::Customer);
                VALIDATE("Account No.", Fct_GetConsCustNo(Pcod_Location));
                VALIDATE("Document Type", "Document Type"::" ");
                "Document No." := Gcod_GenJnlDocNo;
                "Applies-to Doc. Type" := "Applies-to Doc. Type"::Invoice;
                VALIDATE("Applies-to Doc. No.", Fct_GetCustOpenInvoiceNo("Account No.", Pdate_Posting, j));
                Fct_GetApplyToDocAmount(LRec_NewGenJnlLine);
                modify(true);
            end;
            GlobalDim1 := LRec_NewGenJnlLine."Shortcut Dimension 1 Code";
            GlobalDim2 := LRec_NewGenJnlLine."Shortcut Dimension 2 Code";

        end;
    end;

    procedure Fct_LookupGenJnlBatch();
    var
        LRec_GenJnlBatch: Record "Gen. Journal Batch";
    begin
        LRec_GenJnlBatch.setrange("Journal Template Name", Gcod_GenJnlTemplate1);
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
        LRec_GenJnlLine.setrange("Journal Template Name", Gcod_GenJnlTemplate1);
        LRec_GenJnlLine.setrange("Journal Batch Name", Gcod_GenJnlBatch1);
        if LRec_GenJnlLine.findlast() then
            Gcod_GenJnlDocNo := LRec_GenJnlLine."Document No."
        else
            if LRec_GenJnlBatch."No. Series" <> '' then
                Gcod_GenJnlDocNo := LCdu_NoSeriesMgt.getnextNo(LRec_GenJnlBatch."No. Series", Pdate_Posting, false);
    end;
}

