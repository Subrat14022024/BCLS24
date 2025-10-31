namespace FSO_Purchase.Discount;

using Microsoft.Purchases.Document;

codeunit 50301 "FSO PRD Purchase Discount Mgmt"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnUpdatePurchLinesByChangedFieldName, '', false, false)]
    local procedure PurchaseHeaderOnUpdatePurchLinesByChangedFieldName(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; ChangedFieldName: Text[100]; ChangedFieldNo: Integer; xPurchaseHeader: Record "Purchase Header")
    begin
        if PurchHeader.IsTemporary then
            exit;
        if PurchLine.IsTemporary then
            exit;

        this.PrepareforUpdateOrderSubOrderTypeAndBranch(PurchHeader, PurchLine, ChangedFieldNo, xPurchaseHeader);
    end;

    local procedure PrepareforUpdateOrderSubOrderTypeAndBranch(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; ChangedFieldNo: Integer; xPurchaseHeader: Record "Purchase Header")
    begin
        if ChangedFieldNo in [PurchHeader.FieldNo("FSO PRD Order Type"), PurchHeader.FieldNo("FSO PRD Sub Order Type"), PurchHeader.FieldNo("FSO PRD Branch")] then
            if (PurchHeader."FSO PRD Order Type" <> xPurchaseHeader."FSO PRD Order Type") or (PurchHeader."FSO PRD Sub Order Type" <> xPurchaseHeader."FSO PRD Sub Order Type") or (PurchHeader."FSO PRD Branch" <> xPurchaseHeader."FSO PRD Branch") then
                PurchLine.UpdateOrderSubOrderTypeAndBranch();
    end;

    internal procedure ApplyBrandDiscount(PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        DiscountPercentage: Decimal;
    begin
        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order then
            exit;

        if PurchaseHeader."FSO PRD Order Type" = '' then
            exit;
        if PurchaseHeader."FSO PRD Sub Order Type" = '' then
            exit;

        DiscountPercentage := this.CalculateDiscount(PurchaseHeader);
        if DiscountPercentage = 0 then
            exit;
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("Line Discount %", 0);
        if PurchaseLine.FindSet() then
            repeat
                if this.IsItemEligibleforDiscount(PurchaseHeader, PurchaseLine."No.") then begin
                    PurchaseLine.Validate("Line Discount %", DiscountPercentage);
                    PurchaseLine.Modify(true)
                end;
            until PurchaseLine.Next() = 0
    end;

    local procedure CalculateDiscount(PurchaseHeader: Record "Purchase Header"): Decimal
    var
        FSOPURVendorBrandDiscount: Record "FSO PRD Vendor Brand Discount";
        LSCAttributeSetup: Record "LSC Attribute Setup";
    begin
        LSCAttributeSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        LSCAttributeSetup.SetLoadFields("Item Attrib. 1 Code");
        LSCAttributeSetup.Get();
        FSOPURVendorBrandDiscount.ReadIsolation(IsolationLevel::ReadUncommitted);
        if FSOPURVendorBrandDiscount.Get(PurchaseHeader."Buy-from Vendor No.", PurchaseHeader."FSO PRD Branch", LSCAttributeSetup."Item Attrib. 1 Code", PurchaseHeader."FSO PRD LSC Attrib 1 Code", PurchaseHeader."FSO PRD Order Type", PurchaseHeader."FSO PRD Sub Order Type") then begin
            FSOPURVendorBrandDiscount.SetFilter("Ending Date", '%1|>=%2', 0D, PurchaseHeader."Document Date");
            FSOPURVendorBrandDiscount.SetFilter("Starting Date", '%1|<=%2', 0D, PurchaseHeader."Document Date");
            exit(FSOPURVendorBrandDiscount."Discount %");
        end else
            FSOPURVendorBrandDiscount.ReadIsolation(IsolationLevel::ReadUncommitted);
        if FSOPURVendorBrandDiscount.Get(PurchaseHeader."Buy-from Vendor No.", '', LSCAttributeSetup."Item Attrib. 1 Code", PurchaseHeader."FSO PRD LSC Attrib 1 Code", PurchaseHeader."FSO PRD Order Type", PurchaseHeader."FSO PRD Sub Order Type") then begin
            FSOPURVendorBrandDiscount.SetFilter("Ending Date", '%1|>=%2', 0D, PurchaseHeader."Document Date");
            FSOPURVendorBrandDiscount.SetFilter("Starting Date", '%1|<=%2', 0D, PurchaseHeader."Document Date");
            exit(FSOPURVendorBrandDiscount."Discount %");
        end;
    end;

    local procedure IsItemEligibleforDiscount(PurchaseHeader: Record "Purchase Header"; ItemNo: Code[20]): Boolean
    var
        LSCAttributeValue: Record "LSC Attribute Value";
        LSCAttributeSetup: Record "LSC Attribute Setup";
    begin
        LSCAttributeSetup.Get();
        LSCAttributeValue.SetRange("Link Field 1", ItemNo);
        LSCAttributeValue.SetRange("Attribute Code", LSCAttributeSetup."Item Attrib. 1 Code");
        LSCAttributeValue.SetRange("Attribute Value", PurchaseHeader."FSO PRD LSC Attrib 1 Code");
        exit(not LSCAttributeValue.IsEmpty());
    end;

    procedure Public_ApplyBrandDiscount(PurchaseHeader: Record "Purchase Header")
    begin
        this.ApplyBrandDiscount(PurchaseHeader)
    end;
}
