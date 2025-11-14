namespace FSO_Purchase.Discount;

using System.Environment.Configuration;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.Item;

codeunit 50650 "FSO PRD Purchase Discount Mgmt"
{
    // Public entry point: apply brand discount for a purchase header
    procedure ApplyBrandDiscount(PurchaseHeader: Record "Purchase Header")
    var
        DiscountPercentage: Decimal;
    begin
        if not this.HeaderEligibleForBrandDiscount(PurchaseHeader) then
            exit;

        DiscountPercentage := this.CalculateDiscount(PurchaseHeader);
        if DiscountPercentage = 0 then
            exit;

        this.ApplyDiscountToEligibleLines(PurchaseHeader, DiscountPercentage);
    end;

    local procedure HeaderEligibleForBrandDiscount(PurchaseHeader: Record "Purchase Header"): Boolean
    begin
        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order then
            exit(false);

        if PurchaseHeader."FSO PRD Order Type" = '' then
            exit(false);
        if PurchaseHeader."FSO PRD Sub Order Type" = '' then
            exit(false);

        exit(true);
    end;

    local procedure CalculateDiscount(PurchaseHeader: Record "Purchase Header"): Decimal
    var
        FSOPRDCommercialDiscount: Record "FSO PRD Commercial Discount";
    begin
        FSOPRDCommercialDiscount.ReadIsolation(IsolationLevel::ReadUncommitted);
        FSOPRDCommercialDiscount.SetRange("Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        FSOPRDCommercialDiscount.SetRange("Brand", PurchaseHeader."FSO PRD Brand");
        FSOPRDCommercialDiscount.SetRange("Order Type", PurchaseHeader."FSO PRD Order Type");
        FSOPRDCommercialDiscount.SetRange("Sub Order Type", PurchaseHeader."FSO PRD Sub Order Type");
        FSOPRDCommercialDiscount.SetFilter("Starting Date", '%1|<=%2', 0D, PurchaseHeader."Document Date");
        FSOPRDCommercialDiscount.SetFilter("Ending Date", '%1|>=%2', 0D, PurchaseHeader."Document Date");
        if FSOPRDCommercialDiscount.IsEmpty() then
            exit(0);
        if FSOPRDCommercialDiscount.FindLast() then
            exit(FSOPRDCommercialDiscount."Discount %");
    end;

    local procedure ApplyDiscountToEligibleLines(PurchaseHeader: Record "Purchase Header"; DiscountPercentage: Decimal)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        this.SetupPurchaseLineFilters(PurchaseLine, PurchaseHeader);

        if PurchaseLine.FindSet() then
            repeat
                this.ApplyDiscountToLineIfEligible(PurchaseLine, PurchaseHeader, DiscountPercentage);
            until PurchaseLine.Next() = 0;
    end;

    local procedure ApplyDiscountToLineIfEligible(var PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; DiscountPercentage: Decimal)
    begin
        if this.IsItemEligibleForDiscount(PurchaseHeader, PurchaseLine."No.") then begin
            PurchaseLine.Validate("Line Discount %", DiscountPercentage);
            PurchaseLine.Modify(true);
        end;
    end;

    // local procedure IsItemEligibleForDiscount(PurchaseHeader: Record "Purchase Header"; ItemNo: Code[20]): Boolean
    // var
    //     Item: Record Item;
    //     FSOPRDVendorBrandDiscount: Record "FSO PRD Commercial Discount";
    // begin
    //     if Item.Get(ItemNo) then
    //         if FSOPRDVendorBrandDiscount.Get(Item."Vendor No.", Item."FSO Brand", PurchaseHeader."FSO PRD Order Type", PurchaseHeader."FSO PRD Sub Order Type") then
    //             if FSOPRDVendorBrandDiscount."Vendor No." = PurchaseHeader."Buy-from Vendor No." then
    //                 exit(true)
    //             else
    //                 exit(false);
    //     exit(false);
    // end;

    local procedure IsItemEligibleForDiscount(PurchaseHeader: Record "Purchase Header"; ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
        FSOPRDCommercialDiscount: Record "FSO PRD Commercial Discount";
    begin
        if Item.Get(ItemNo) then begin
            FSOPRDCommercialDiscount.ReadIsolation(IsolationLevel::ReadUncommitted);
            FSOPRDCommercialDiscount.SetRange("Vendor No.", PurchaseHeader."Buy-from Vendor No.");
            FSOPRDCommercialDiscount.SetRange("Brand", PurchaseHeader."FSO PRD Brand");
            FSOPRDCommercialDiscount.SetRange("Order Type", PurchaseHeader."FSO PRD Order Type");
            FSOPRDCommercialDiscount.SetRange("Sub Order Type", PurchaseHeader."FSO PRD Sub Order Type");
            FSOPRDCommercialDiscount.SetFilter("Starting Date", '%1|<=%2', 0D, PurchaseHeader."Document Date");
            FSOPRDCommercialDiscount.SetFilter("Ending Date", '%1|>=%2', 0D, PurchaseHeader."Document Date");
            if FSOPRDCommercialDiscount.FindLast() then
                if FSOPRDCommercialDiscount."Vendor No." = Item."Vendor No." then
                    exit(true)
                else
                    exit(false);
            exit(false);
        end;
        exit(false);
    end;

    // Event subscriber: keep behavior but corrected helper name
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnRecreatePurchLinesOnBeforeInsertPurchLine, '', false, false)]
    local procedure PurchaseHeaderOnRecreatePurchLinesOnBeforeInsertPurchLine(var PurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line" temporary; ChangedFieldName: Text[100])
    begin
        if PurchaseLine.IsTemporary then
            exit;
        if PurchaseLine."Document Type" <> PurchaseLine."Document Type"::Order then
            exit;
        this.ReAssignPurchaseDiscountField(PurchaseLine);
    end;

    local procedure ReAssignPurchaseDiscountField(var PurchaseLine: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") then begin
            if PurchaseHeader."FSO PRD Order Type" <> '' then
                PurchaseLine."FSO PRD Order Type" := PurchaseHeader."FSO PRD Order Type";
            if PurchaseHeader."FSO PRD Sub Order Type" <> '' then
                PurchaseLine."FSO PRD Sub Order Type" := PurchaseHeader."FSO PRD Sub Order Type";
            if PurchaseHeader."FSO PRD Branch" <> '' then
                PurchaseLine."FSO PRD Branch" := PurchaseHeader."FSO PRD Branch";
        end;
    end;

    // Notification API: single public procedure to notify about missing discounts on lines
    procedure NotifyAboutMissingDiscountonLines(PurchHeader: Record "Purchase Header")
    begin
        this.RecallNotification(PurchHeader.RecordId);

        if this.HasEligibleLine(PurchHeader) then
            this.SendNotification(PurchHeader.RecordId, PurchHeader."No.", PurchHeader."Document Type".AsInteger());
    end;

    local procedure HasEligibleLine(PurchHeader: Record "Purchase Header"): Boolean
    var
        PurchaseLine: Record "Purchase Line";
    begin
        this.SetupPurchaseLineFilters(PurchaseLine, PurchHeader);
        if PurchaseLine.IsEmpty() then
            exit(false);

        if PurchaseLine.FindSet() then
            repeat
                if this.EligibleForDiscountNotification(PurchaseLine) then
                    exit(true);
            until PurchaseLine.Next() = 0;

        exit(false);
    end;

    local procedure SetupPurchaseLineFilters(var PurchaseLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    begin
        PurchaseLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetFilter("Line Discount %", '0');
        PurchaseLine.SetFilter(Quantity, '<>0');
        PurchaseLine.SetFilter("Direct Unit Cost", '<>0');
    end;

    local procedure EligibleForDiscountNotification(PurchaseLine: Record "Purchase Line"): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") then
            exit(this.IsItemEligibleForDiscount(PurchaseHeader, PurchaseLine."No."));
    end;

    local procedure SendNotification(PurchaseRecordID: RecordID; DocumentNo: Code[20]; DocumentType: Integer)
    var
        NotificationLifecycleMgt: Codeunit "Notification Lifecycle Mgt.";
        Notification: Notification;
    begin
        Notification.Message(this.MissingDiscountLineMsg);
        Notification.SetData('RecordID', Format(PurchaseRecordID));
        Notification.SetData('DocumentNo', Format(DocumentNo));
        Notification.SetData('DocumentType', Format(DocumentType));
        Notification.AddAction(this.DetailsTok, Codeunit::"FSO PRD Purchase Discount Mgmt", 'ApplyDiscountforEligibleLines');
        NotificationLifecycleMgt.SendNotification(Notification, PurchaseRecordID);
    end;

    // Called by notification action to apply discounts
    internal procedure ApplyDiscountforEligibleLines(Notification: Notification)
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if Notification.HasData('DocumentNo') and Notification.HasData('DocumentType') then begin
            Evaluate(PurchaseHeader."Document Type", Notification.GetData('DocumentType'));
            if PurchaseHeader.Get(PurchaseHeader."Document Type", Notification.GetData('DocumentNo')) then
                this.ApplyBrandDiscount(PurchaseHeader)
        end;
    end;

    local procedure RecallNotification(SetupRecordID: RecordID)
    var
        NotificationLifecycleMgt: Codeunit "Notification Lifecycle Mgt.";
    begin
        NotificationLifecycleMgt.RecallNotificationsForRecord(SetupRecordID, false);
    end;

    var
        MissingDiscountLineMsg: Label 'Some lines are eligible for Brand Discount, but no discount has been applied.';
        DetailsTok: Label 'Apply Brand Discount';
}
