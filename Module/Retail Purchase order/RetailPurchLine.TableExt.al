namespace BCLS.BCLS;

using Microsoft.Finance.AllocationAccount;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Finance.VAT.Setup;
using Microsoft.FixedAssets.Depreciation;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.FixedAssets.Setup;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Inventory.Location;
using Microsoft.Pricing.Calculation;
using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Setup;
using Microsoft.Utilities;
using Microsoft.Warehouse.Journal;
using Microsoft.Warehouse.Structure;
using System.Environment.Configuration;

tableextension 50201 "Retail PurchLine" extends "Purchase Line"
{
    fields
    {
        field(50202; "Vendor Item Color"; Code[100])
        {
            Caption = 'Vendor Item Color';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies Vendor Item Color';
            CaptionClass = GetCaptionClass(FieldNo("No."));
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account"), "System-Created Entry" = const(false)) "G/L Account" where("Direct Posting" = const(true), "Account Type" = const(Posting), Blocked = const(false))
            else
            if (Type = const("G/L Account"), "System-Created Entry" = const(true)) "G/L Account"
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge"
            else
            if (Type = const(Item), "Document Type" = filter(<> "Credit Memo" & <> "Return Order")) Item where(Blocked = const(false), "Purchasing Blocked" = const(false))
            else
            if (Type = const(Item), "Document Type" = filter("Credit Memo" | "Return Order")) Item where(Blocked = const(false))
            else
            if (Type = const("Allocation Account")) "Allocation Account"
            else
            if (Type = const(Resource)) Resource;

            ValidateTableRelation = false;

            trigger OnValidate()
            var
                TempPurchLine: Record "Purchase Line" temporary;
                IsHandled: Boolean;
                ShouldAssignQuantityFromXRec: Boolean;
            begin
                IsHandled := false;
                //OnBeforeValidateNo(Rec, xRec, CurrFieldNo, IsHandled);
                if IsHandled then
                    exit;

                GetPurchSetup();

                "No." := FindOrCreateRecordByNo("No.");

                TestStatusOpen();
                TestField("Qty. Rcd. Not Invoiced", 0);
                TestField("Quantity Received", 0);

                IsHandled := false;
                //OnValidateNoOnBeforeCheckReceiptNo(Rec, xRec, IsHandled);
                if not IsHandled then
                    TestField("Receipt No.", '');

                TestField("Prepmt. Amt. Inv.", 0);

                TestReturnFieldsZero();

                CheckAssociatedSalesOrder();
                //CheckAssociatedProdOrder();

                //OnValidateNoOnAfterChecks(Rec, xRec, CurrFieldNo);

                if "No." <> xRec."No." then begin
                    if (Quantity <> 0) and ItemExists(xRec."No.") then begin
                        PurchLineReserve.VerifyChange(Rec, xRec);
                        CalcFields("Reserved Qty. (Base)");
                        TestField("Reserved Qty. (Base)", 0);
                        if Type = Type::Item then
                            PurchasesWarehouseMgt.PurchaseLineVerifyChange(Rec, xRec);
                        //OnValidateNoOnAfterVerifyChange(Rec, xRec);
                        if CurrFieldNo = Rec.FieldNo("No.") then
                            CheckWarehouse(false);
                    end;
                    if Type = Type::Item then
                        DeleteItemChargeAssignment("Document Type", "Document No.", "Line No.");
                    if Type = Type::"Charge (Item)" then
                        DeleteChargeChargeAssgnt("Document Type", "Document No.", "Line No.");
                end;

                //OnValidateNoOnBeforeInitRec(Rec, xRec, CurrFieldNo);
                TempPurchLine := Rec;
                Init();
                SystemId := TempPurchLine.SystemId;
                if xRec."Line Amount" <> 0 then
                    "Recalculate Invoice Disc." := xRec."Allow Invoice Disc.";
                Type := TempPurchLine.Type;
                "No." := TempPurchLine."No.";
                IsHandled := false;
                //OnValidateNoOnCopyFromTempPurchLine(Rec, TempPurchLine, xRec, IsHandled);
                if IsHandled then
                    exit;
                if "No." = '' then
                    exit;

                if HasTypeToFillMandatoryFields() then begin
                    Quantity := TempPurchLine.Quantity;
                    "Outstanding Qty. (Base)" := TempPurchLine."Outstanding Qty. (Base)";
                end;

                "System-Created Entry" := TempPurchLine."System-Created Entry";

                //OnBeforeAssignHeaderValues(Rec, PurchHeader);

                PurchHeader := GetPurchHeader();
                InitHeaderDefaults(PurchHeader, TempPurchLine);
                UpdateLeadTimeFields();
                UpdateDates();

                //OnAfterAssignHeaderValues(Rec, PurchHeader);

                case Type of
                    Type::" ":
                        CopyFromStandardText();
                    Type::"G/L Account":
                        CopyFromGLAccount(TempPurchLine);
                    Type::Item:
                        CopyFromItem();
                    Type::Resource:
                        CopyFromResource();
                    Type::"Fixed Asset":
                        CopyFromFixedAsset();
                    Type::"Charge (Item)":
                        CopyFromItemCharge();
                end;

                //OnAfterAssignFieldsForNo(Rec, xRec, PurchHeader);

                if Type <> Type::" " then begin
                    PostingSetupMgt.CheckGenPostingSetupPurchAccount("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                    PostingSetupMgt.CheckVATPostingSetupPurchAccount("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                end;

                IsHandled := false;
                //OnBeforeValidateVATProdPostingGroup(Rec, xRec, IsHandled);
                if not IsHandled then
                    if HasTypeToFillMandatoryFields() and not (Type = Type::"Fixed Asset") then
                        Validate("VAT Prod. Posting Group");

                UpdatePrepmtSetupFields();

                if HasTypeToFillMandatoryFields() then begin
                    PlanPriceCalcByField(FieldNo("No."));
                    IsHandled := false;
                    //OnValidateNoOnBeforeAssignQtyFromXRec(Rec, xRec, IsHandled);
                    ShouldAssignQuantityFromXRec := (not IsHandled) and (not QuantityDefaultedFromGLAccount());
                    if ShouldAssignQuantityFromXRec then
                        Quantity := xRec.Quantity;
                    //OnValidateNoOnAfterAssignQtyFromXRec(Rec, TempPurchLine);
                    Validate("Unit of Measure Code");
                    InitOutstandingAndQtyToShipReceive(TempPurchLine);
                    UpdateWithWarehouseReceive();
                    UpdateJobFields();
                end;

                Rec.CreateDimFromDefaultDim(Rec.FieldNo("No."));

                PurchHeader := Rec.GetPurchHeader();
                UpdateItemReference();
                UpdateDirectUnitCostByField(FieldNo("No."));

                GetDefaultBin();

                IsHandled := false;
                //OnValidateNoOnBeforeJobTaskIsSet(PurchHeader, Rec, xRec, TempPurchLine, IsHandled);
                if not IsHandled then
                    if JobTaskIsSet() then begin
                        CreateTempJobJnlLine(true);
                        UpdateJobPrices();
                        UpdateDimensionsFromJobTask();
                    end;
            end;
        }
    }
    local procedure GetPurchSetup()
    begin
        if not PurchSetupRead then
            PurchSetup.Get();
        PurchSetupRead := true;

        //OnAfterGetPurchSetup(Rec, PurchSetup);
    end;

    local procedure TestReturnFieldsZero()
    begin
        TestField("Return Qty. Shipped Not Invd.", 0);
        TestField("Return Qty. Shipped", 0);
        TestField("Return Shipment No.", '');
    end;

    local procedure CopyFromStandardText()
    var
        StandardText: Record "Standard Text";
    begin
        "Tax Area Code" := '';
        "Tax Liable" := false;
        StandardText.Get("No.");
        Description := StandardText.Description;
        "Allow Item Charge Assignment" := false;
        //OnAfterAssignStdTxtValues(Rec, StandardText);
    end;

    local procedure CopyFromGLAccount()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeCopyFromGLAccount(Rec, xRec, CurrFieldNo, IsHandled);
        if not IsHandled then begin
            GLAcc.Get("No.");
            GLAcc.CheckGLAcc();
            if not "System-Created Entry" then
                GLAcc.TestField("Direct Posting", true);
            Description := GLAcc.Name;
            "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
            "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
            "Tax Group Code" := GLAcc."Tax Group Code";
            "Allow Invoice Disc." := false;
            "Allow Item Charge Assignment" := false;
            //OnNotHandledCopyFromGLAccount(Rec, GLAcc);
            InitDeferralCode();
            "Non Deductible VAT %" := GLAcc."% Non deductible VAT";
            SetDefaultGLAccountQuantity();
        end;
        //OnAfterAssignGLAccountValues(Rec, GLAcc, PurchHeader, xRec, TempPurchaseLine);
    end;

    local procedure CopyFromItem()
    var
        Item: Record Item;
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        IsHandled: Boolean;
    begin
        GetItem(Item);
        GetGLSetup();
        IsHandled := false;
        //OnBeforeCopyFromItem(Rec, Item, IsHandled);
        if not IsHandled then begin
            Item.TestField(Blocked, false);
            Item.TestField("Gen. Prod. Posting Group");
            if Item."Purchasing Blocked" then
                if IsCreditDocType() then
                    SendBlockedItemNotification()
                else
                    Error(PurchasingBlockedErr, Item.TableCaption(), Item."No.", Item.FieldCaption("Purchasing Blocked"));
            if Item.Type = Item.Type::Inventory then begin
                Item.TestField("Inventory Posting Group");
                "Posting Group" := Item."Inventory Posting Group";
            end;
        end;

        //OnCopyFromItemOnAfterCheck(Rec, Item, CurrFieldNo);

        Description := Item.Description;
        "Description 2" := Item."Description 2";
        UpdateUnitPriceLCYFromItem(Item);
        "Units per Parcel" := Item."Units per Parcel";
        "Indirect Cost %" := Item."Indirect Cost %";
        "Overhead Rate" := Item."Overhead Rate";
        "Allow Invoice Disc." := Item."Allow Invoice Disc.";
        "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
        "Tax Group Code" := Item."Tax Group Code";
        Nonstock := Item."Created From Nonstock Item";
        "Item Category Code" := Item."Item Category Code";
        "Allow Item Charge Assignment" := true;
        PrepaymentMgt.SetPurchPrepaymentPct(Rec, PurchHeader."Posting Date");
        if IsInventoriableItem() then
            PostingSetupMgt.CheckInvtPostingSetupInventoryAccount("Location Code", "Posting Group");

        if Item."Price Includes VAT" then begin
            if not VATPostingSetup.Get(Item."VAT Bus. Posting Gr. (Price)", Item."VAT Prod. Posting Group") then
                VATPostingSetup.Init();
            case VATPostingSetup."VAT Calculation Type" of
                VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                    VATPostingSetup."VAT %" := 0;
                VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                    Error(
                      Text002,
                      VATPostingSetup.FieldCaption("VAT Calculation Type"),
                      VATPostingSetup."VAT Calculation Type");
            end;
            IsHandled := false;
            //OnCopyFromItemOnBeforeAssignUnitPriceLCY(Rec, GLSetup, VATPostingSetup, IsHandled);
            if not IsHandled then
                "Unit Price (LCY)" :=
                  Round("Unit Price (LCY)" / (1 + VATPostingSetup."VAT %" / 100),
                    GLSetup."Unit-Amount Rounding Precision");
        end;

        if PurchHeader."Language Code" <> '' then
            GetItemTranslation();

        //OnCopyFromItemOnAfterGetItemTranslation(Rec, Item);

        if Item."Purch. Unit of Measure" <> '' then
            "Unit of Measure Code" := Item."Purch. Unit of Measure"
        else
            "Unit of Measure Code" := Item."Base Unit of Measure";
        InitDeferralCode();
        //OnAfterAssignItemValues(Rec, Item, CurrFieldNo, PurchHeader);
    end;

    local procedure SetDefaultGLAccountQuantity()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeSetDefaultGLAccountQuantity(Rec, IsHandled);
        if IsHandled then
            exit;

        GetPurchSetup();
        if PurchSetup."Default G/L Account Quantity" then
            Validate(Quantity, 1);
    end;

    local procedure CopyFromResource()
    var
        Resource: Record Resource;
    begin
        GetResource(Resource);
        Resource.CheckResourcePrivacyBlocked(false);
        Resource.TestField(Blocked, false);
        Resource.TestField("Gen. Prod. Posting Group");
        Description := Resource.Name;
        "Description 2" := Resource."Name 2";
        "Unit of Measure Code" := Resource."Base Unit of Measure";
        "Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
        "VAT Prod. Posting Group" := Resource."VAT Prod. Posting Group";
        "Tax Group Code" := Resource."Tax Group Code";
        "Allow Item Charge Assignment" := false;
        "Direct Unit Cost" := Resource."Direct Unit Cost";
        InitDeferralCode();

        //OnAfterAssignResourceValues(Rec, Resource);
    end;

    local procedure GetResource(var Resource: Record Resource)
    begin
        TestField("No.");
        Resource.Get("No.")
    end;

    local procedure CopyFromFixedAsset()
    var
        FixedAsset: Record "Fixed Asset";
    begin
        FixedAsset.Get("No.");
        FixedAsset.TestField(Inactive, false);
        FixedAsset.TestField(Blocked, false);
        GetFAPostingGroup();
        Description := FixedAsset.Description;
        "Description 2" := FixedAsset."Description 2";
        "Allow Invoice Disc." := false;
        "Allow Item Charge Assignment" := false;
        //OnAfterAssignFixedAssetValues(Rec, FixedAsset, PurchHeader);
    end;

    local procedure CopyFromItemCharge()
    begin
        ItemCharge.Get("No.");
        Description := ItemCharge.Description;
        "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
        "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
        "Tax Group Code" := ItemCharge."Tax Group Code";
        "Allow Invoice Disc." := false;
        "Allow Item Charge Assignment" := false;
        "Indirect Cost %" := 0;
        "Overhead Rate" := 0;
        //OnAfterAssignItemChargeValues(Rec, ItemCharge, PurchHeader);
    end;

    local procedure GetFAPostingGroup()
    var
        LocalGLAcc: Record "G/L Account";
        FAPostingGr: Record "FA Posting Group";
        FADeprBook: Record "FA Depreciation Book";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeGetFAPostingGroup(Rec, IsHandled);
        if IsHandled then
            exit;

        if (Type <> Type::"Fixed Asset") or ("No." = '') then
            exit;
        if "Depreciation Book Code" = '' then
            if not FindDefaultFADeprBook() then
                exit;

        if "FA Posting Type" = "FA Posting Type"::" " then
            "FA Posting Type" := "FA Posting Type"::"Acquisition Cost";
        FADeprBook.Get("No.", "Depreciation Book Code");
        FADeprBook.TestField("FA Posting Group");
        FAPostingGr.GetPostingGroup(FADeprBook."FA Posting Group", FADeprBook."Depreciation Book Code");
        IsHandled := false;
        //OnGetFAPostingGroupOnBeforeLocalGLAccGet(Rec, FAPostingGr, LocalGLAcc, IsHandled);
        if not IsHandled then
            case "FA Posting Type" of
                "FA Posting Type"::"Acquisition Cost":
                    LocalGLAcc.Get(FAPostingGr.GetAcquisitionCostAccount());
                "FA Posting Type"::Appreciation:
                    LocalGLAcc.Get(FAPostingGr.GetAppreciationAccount());
                "FA Posting Type"::Maintenance:
                    LocalGLAcc.Get(FAPostingGr.GetMaintenanceExpenseAccount());
            end;

        IsHandled := false;
        //OnGetFAPostingGroupOnBeforeCheckGLAcc(Rec, LocalGLAcc, FADeprBook, IsHandled);
        if not IsHandled then begin
            LocalGLAcc.CheckGLAcc();
            if not ApplicationAreaMgmt.IsSalesTaxEnabled() then
                LocalGLAcc.TestField("Gen. Prod. Posting Group");
            "Posting Group" := FADeprBook."FA Posting Group";
            "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
            "Tax Group Code" := LocalGLAcc."Tax Group Code";
        end;
        ValidateVATProdPostingGroupFromGLAcc(LocalGLAcc);
        "Non Deductible VAT %" := LocalGLAcc."% Non deductible VAT";

        // OnAfterGetFAPostingGroup(Rec, LocalGLAcc);
    end;

    local procedure ValidateVATProdPostingGroupFromGLAcc(GLAccount: Record "G/L Account")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeValidateVATProdPostingGroupFromGLAcc(Rec, IsHandled);
        if IsHandled then
            exit;

        Validate("VAT Prod. Posting Group", GLAccount."VAT Prod. Posting Group");
    end;

    local procedure FindDefaultFADeprBook() Result: Boolean
    var
        FASetup: Record "FA Setup";
        FADeprBook: Record "FA Depreciation Book";
        DefaultFADeprBook: Record "FA Depreciation Book";
        SetFADeprBook: Record "FA Depreciation Book";
    begin
        FASetup.Get();

        DefaultFADeprBook.SetRange("FA No.", "No.");
        DefaultFADeprBook.SetRange("Default FA Depreciation Book", true);

        SetFADeprBook.SetRange("FA No.", "No.");

        case true of
            SetFADeprBook.Count = 1:
                begin
                    SetFADeprBook.FindFirst();
                    "Depreciation Book Code" := SetFADeprBook."Depreciation Book Code";
                end;
            DefaultFADeprBook.FindFirst():
                "Depreciation Book Code" := DefaultFADeprBook."Depreciation Book Code";
            FADeprBook.Get("No.", FASetup."Default Depr. Book"):
                "Depreciation Book Code" := FASetup."Default Depr. Book"
            else
                "Depreciation Book Code" := '';
        end;
        Result := "Depreciation Book Code" <> '';

        //OnAfterFindDefaultFADeprBook(Rec, Result);
    end;

    local procedure QuantityDefaultedFromGLAccount(): Boolean
    begin
        if Rec.Type <> Rec.Type::"G/L Account" then
            exit(false);
        GetPurchSetup();
        exit(PurchSetup."Default G/L Account Quantity");
    end;

    local procedure GetItem(var Item: Record Item)
    begin
        TestField("No.");
        Item.Get("No.");

        //OnAfterGetItem(Item, Rec);
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get();
        GLSetupRead := true;
    end;

    local procedure GetBlockedItemNotificationID(): Guid
    begin
        exit('963A9FD3-11E8-4CAA-BE3A-7F8CEC9EF8EC');
    end;

    local procedure SendBlockedItemNotification()
    var
        NotificationLifecycleMgt: Codeunit "Notification Lifecycle Mgt.";
        NotificationToSend: Notification;
    begin
        NotificationToSend.Id := GetBlockedItemNotificationID();
        NotificationToSend.Recall();
        NotificationToSend.Message := StrSubstNo(BlockedItemNotificationMsg, "No.");
        NotificationLifecycleMgt.SendNotification(NotificationToSend, RecordId);
    end;

    local procedure UpdateUnitPriceLCYFromItem(Item: Record Item)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeUpdateUnitPriceLCYFromItem(Rec, Item, CurrFieldNo, IsHandled);
        if IsHandled then
            exit;

        "Unit Price (LCY)" := Item."Unit Price";
    end;

    local procedure UpdateJobFields()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeUpdateJobFields(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if xRec."Job No." <> '' then
            Validate("Job No.", xRec."Job No.");
        "Job Line Type" := xRec."Job Line Type";
        if xRec."Job Task No." <> '' then begin
            Validate("Job Task No.", xRec."Job Task No.");
            if "No." = xRec."No." then
                Validate("Job Planning Line No.", xRec."Job Planning Line No.");
        end;
    end;

    local procedure UpdateItemReference()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeUpdateItemReference(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        ItemReferenceMgt.EnterPurchaseItemReference(Rec);

        UpdateICPartner();

        if Type <> Type::Item then
            exit;

        UpdateVendorItemNoFromItemReference();
    end;

    local procedure UpdateVendorItemNoFromItemReference()
    begin
        if "Item Reference No." = '' then
            SetVendorItemNo()
        else
            Validate("Vendor Item No.", "Item Reference No.");
        //OnAfterUpdateVendorItemNoFromItemReference(Rec, xRec);
    end;

    local procedure UpdateDirectUnitCostByField(CalledByFieldNo: Integer)
    var
        BlanketOrderPurchaseLine: Record "Purchase Line";
        PriceCalculation: Interface "Price Calculation";
        IsHandled: Boolean;
        ShouldExit: Boolean;
    begin
        if not IsPriceCalcCalledByField(CalledByFieldNo) then
            exit;

        IsHandled := false;
        //OnBeforeUpdateDirectUnitCost(Rec, xRec, CalledByFieldNo, CurrFieldNo, IsHandled);
        if IsHandled then
            exit;

        if (CurrFieldNo <> 0) and ("Prod. Order No." <> '') then
            UpdateAmounts();

        ShouldExit := ((CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0)) or ("Prod. Order No." <> '');
        //OnUpdateDirectUnitCostByFieldOnAfterCalcShouldExit(Rec, xRec, CalledByFieldNo, CurrFieldNo, ShouldExit);
        if ShouldExit then
            exit;

        case Type of
            Type::"G/L Account",
            Type::Item,
            Type::Resource:
                begin
                    GetPurchHeader();
                    IsHandled := false;
                    //OnUpdateDirectUnitCostOnBeforeFindPrice(PurchHeader, Rec, CalledByFieldNo, CurrFieldNo, IsHandled, xRec);
                    if not IsHandled then
                        if not BlanketOrderIsRelated(BlanketOrderPurchaseLine) then begin
                            GetPriceCalculationHandler(PurchHeader, PriceCalculation);
                            if not ("Copied From Posted Doc." and IsCreditDocType()) then begin
                                PriceCalculation.ApplyPrice(CalledByFieldNo);
                                PriceCalculation.ApplyDiscount();
                            end;
                            GetLineWithCalculatedPrice(PriceCalculation);
                        end else begin
                            Validate("Direct Unit Cost", BlanketOrderPurchaseLine."Direct Unit Cost");
                            Validate("Line Discount %", BlanketOrderPurchaseLine."Line Discount %");

                            //OnUpdateDirectUnitCostByFieldOnAfterSetBlanketOrderPriceFields(PurchHeader, BlanketOrderPurchaseLine, Rec, CalledByFieldNo, CurrFieldNo);
                        end;
                    if (xRec."Direct Unit Cost" <> Rec."Direct Unit Cost") or not (CalledByFieldNo in [FieldNo("Job Task No."), FieldNo("Job No.")]) then
                        Validate("Direct Unit Cost");
                end;
        end;

        //OnUpdateDirectUnitCostByFieldOnBeforeUpdateItemReference(Rec, CalledByFieldNo);
        if Type = Type::Item then
            if CalledByFieldNo in [FieldNo("No."), FieldNo("Variant Code")] then
                UpdateItemReference();

        ClearFieldCausedPriceCalculation();
        //OnAfterUpdateDirectUnitCost(Rec, xRec, CalledByFieldNo, CurrFieldNo);
    end;

    local procedure BlanketOrderIsRelated(var BlanketOrderPurchaseLine: Record "Purchase Line"): Boolean
    var
        IsHandled, Result : Boolean;
    begin
        IsHandled := false;
        Result := false;
        //OnBeforeBlanketOrderIsRelated(Rec, BlanketOrderPurchaseLine, IsHandled, Result);
        if IsHandled then
            exit(Result);

        if "Blanket Order Line No." = 0 then exit;
        BlanketOrderPurchaseLine.SetLoadFields("Direct Unit Cost", "Line Discount %");
        //OnBlanketOrderIsRelatedOnAfterSetLoadFields(BlanketOrderPurchaseLine);
        if BlanketOrderPurchaseLine.Get("Document Type"::"Blanket Order", "Blanket Order No.", "Blanket Order Line No.") then
            exit(true);
    end;


    local procedure GetLineWithCalculatedPrice(var PriceCalculation: Interface "Price Calculation")
    var
        Line: Variant;
    begin
        PriceCalculation.GetLine(Line);
        Rec := Line;
    end;

    local procedure GetDefaultBin()
    var
        WMSManagement: Codeunit "WMS Management";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeGetDefaultBin(Rec, IsHandled, xRec);
        if IsHandled then
            exit;

        if (Type <> Type::Item) or IsNonInventoriableItem() then
            exit;

        "Bin Code" := '';
        if "Drop Shipment" then
            exit;

        if ("Location Code" <> '') and ("No." <> '') then begin
            GetLocation("Location Code");
            if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then begin
                WMSManagement.GetDefaultBin("No.", "Variant Code", "Location Code", "Bin Code");
                HandleDedicatedBin(false);
            end;
        end;

        //OnAfterGetDefaultBin(Rec);
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Clear(Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    local procedure HandleDedicatedBin(IssueWarning: Boolean)
    var
        WhseIntegrationMgt: Codeunit "Whse. Integration Management";
    begin
        //OnBeforeHandleDedicatedBin(Rec, xRec, IssueWarning);
        if not IsInbound() and ("Quantity (Base)" <> 0) then
            WhseIntegrationMgt.CheckIfBinDedicatedOnSrcDoc("Location Code", "Bin Code", IssueWarning);
    end;

    local procedure UpdateDimensionsFromJobTask()
    var
        SourceCodeSetup: Record "Source Code Setup";
        DimSetArrID: array[10] of Integer;
        DimValue1: Code[20];
        DimValue2: Code[20];
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeUpdateDimensionsFromJobTask(Rec, CurrFieldNo, IsHandled);
        if not IsHandled then begin
            SourceCodeSetup.Get();
            DimSetArrID[1] := "Dimension Set ID";
            DimSetArrID[2] :=
                DimMgt.CreateDimSetFromJobTaskDim("Job No.",
                "Job Task No.", DimValue1, DimValue2);
            DimMgt.CreateDimForPurchLineWithHigherPriorities(
                Rec, CurrFieldNo, DimSetArrID[3], DimValue1, DimValue2, SourceCodeSetup.Purchases, Database::Job);

            "Dimension Set ID" :=
                DimMgt.GetCombinedDimensionSetID(
                DimSetArrID, DimValue1, DimValue2);

            "Shortcut Dimension 1 Code" := DimValue1;
            "Shortcut Dimension 2 Code" := DimValue2;
        end;
        //OnAfterUpdateDimensionsFromJobTask(Rec);
    end;

    local procedure CopyFromGLAccount(var TempPurchaseLine: Record "Purchase Line" temporary)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeCopyFromGLAccount(Rec, xRec, CurrFieldNo, IsHandled);
        if not IsHandled then begin
            GLAcc.Get("No.");
            GLAcc.CheckGLAcc();
            if not "System-Created Entry" then
                GLAcc.TestField("Direct Posting", true);
            Description := GLAcc.Name;
            "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
            "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
            "Tax Group Code" := GLAcc."Tax Group Code";
            "Allow Invoice Disc." := false;
            "Allow Item Charge Assignment" := false;
            //OnNotHandledCopyFromGLAccount(Rec, GLAcc);
            InitDeferralCode();
            "Non Deductible VAT %" := GLAcc."% Non deductible VAT";
            SetDefaultGLAccountQuantity();
        end;
        //OnAfterAssignGLAccountValues(Rec, GLAcc, PurchHeader, xRec, TempPurchaseLine);
    end;

    local procedure InitOutstandingAndQtyToShipReceive(var TempPurchLine: Record "Purchase Line" temporary)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeInitOutstandingAndQtyToShipReceive(Rec, TempPurchLine, IsHandled, xRec);
        if IsHandled then
            exit;

        if Quantity <> 0 then begin
            InitOutstanding();
            if IsCreditDocType() then
                InitQtyToShip()
            else
                InitQtyToReceive();
        end;
    end;

    var
        PurchHeader: Record "Purchase Header";
        GLAcc: Record "G/L Account";
        VATPostingSetup: Record "VAT Posting Setup";
        ItemCharge: Record "Item Charge";
        Location: Record Location;
        GLSetup: Record "General Ledger Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        PurchasesWarehouseMgt: Codeunit "Purchases Warehouse Mgt.";
        DimMgt: Codeunit DimensionManagement;
        ItemReferenceMgt: Codeunit "Item Reference Management";
        PostingSetupMgt: Codeunit PostingSetupManagement;
        ApplicationAreaMgmt: Codeunit "Application Area Mgmt.";
        GLSetupRead: Boolean;
        PurchSetupRead: Boolean;
#pragma warning disable AA0074
#pragma warning disable AA0470
        Text002: Label 'Prices including VAT cannot be calculated when %1 is %2.';
#pragma warning restore AA0470
#pragma warning disable AA0470
#pragma warning restore AA0470
#pragma warning disable AA0470
#pragma warning restore AA0470
#pragma warning disable AA0470
#pragma warning restore AA0470
#pragma warning disable AA0470
#pragma warning restore AA0470
#pragma warning disable AA0470
#pragma warning restore AA0470
#pragma warning restore AA0074
        PurchasingBlockedErr: Label 'You cannot purchase %1 %2 because the %3 check box is selected on the %1 card.', Comment = '%1 - Table Caption (Item), %2 - Item No., %3 - Field Caption';
        BlockedItemNotificationMsg: Label 'Item %1 is blocked, but it is allowed on this type of document.', Comment = '%1 is Item No.';
}
