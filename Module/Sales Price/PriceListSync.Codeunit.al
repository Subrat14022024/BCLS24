namespace BCLS.BCLS;

using Microsoft.Pricing.PriceList;

codeunit 50506 "Price List Sync"
{
    /// <summary>
    /// Configuration-driven synchronisation of price lines from one price list to another.
    /// Mappings are maintained in the "Price List Sync Setup" table and can point any source
    /// price list to a target price list. No hardcoding of country codes is required.
    /// </summary>

    // [EventSubscriber(ObjectType::Table, Database::"Price List Line", OnAfterInsertEvent, '', false, false)]
    // local procedure PriceListLine_OnAfterInsertEvent(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    // begin
    //     if Rec.IsTemporary() then
    //         exit;
    //     if this.VerifyPriceListLine(Rec) then
    //         this.SyncPriceFromSource(Rec);
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", OnAfterModifyEvent, '', false, false)]
    local procedure PriceListLineOnAfterModifyEvent(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary() then
            exit;
        if this.VerifyPriceListLine(Rec) then
            this.SyncPriceFromSource(Rec);
    end;

    /// <summary>
    /// Main synchronisation routine.  Looks up configuration for the source price list and
    /// creates/updates the corresponding target price list line.
    /// </summary>
    local procedure SyncPriceFromSource(SourcePriceListLine: Record "Price List Line")
    var
        SourcePriceListHeader: Record "Price List Header";
        TargetPriceListHeader: Record "Price List Header";
        TargetPriceListLine: Record "Price List Line";
        PriceListSyncSetup: Record "Price List Sync Setup";
        PriceListManagement: Codeunit "Price List Management";
    begin
        // get source header just for validation
        if not SourcePriceListHeader.Get(SourcePriceListLine."Price List Code") then
            exit;

        // find all active mappings for this source price list
        PriceListSyncSetup.SetRange("Source Price List Code", SourcePriceListLine."Price List Code");
        PriceListSyncSetup.SetRange(Active, true);
        if not PriceListSyncSetup.FindSet() then
            exit; // no mappings defined

        repeat
            if TargetPriceListHeader.Get(PriceListSyncSetup."Target Price List Code") then
                // insert or update the target line for this mapping
                if this.TargetLineExists(TargetPriceListHeader, SourcePriceListLine, TargetPriceListLine) then
                    this.UpdateTargetLine(TargetPriceListLine, SourcePriceListLine)
                else
                    this.CreateTargetLine(TargetPriceListHeader, SourcePriceListLine);
        until PriceListSyncSetup.Next() = 0;

        // leave all involved target and source lists in draft mode
        // activating multiple times is harmless, but we activate source once to avoid redundancy
        PriceListSyncSetup.Reset();
        PriceListSyncSetup.SetRange("Source Price List Code", SourcePriceListLine."Price List Code");
        PriceListSyncSetup.SetRange(Active, true);
        if PriceListSyncSetup.FindSet() then begin
            repeat
                if TargetPriceListHeader.Get(PriceListSyncSetup."Target Price List Code") then
                    PriceListManagement.ActivateDraftLines(TargetPriceListHeader, true);
            until PriceListSyncSetup.Next() = 0;

            // activate source header once (all entries have same source code)
            if SourcePriceListHeader.Get(SourcePriceListLine."Price List Code") then
                PriceListManagement.ActivateDraftLines(SourcePriceListHeader, true);
        end;

    end;

    /// <summary>
    /// Determines whether a target price line already exists matching the key fields.
    /// </summary>
    local procedure TargetLineExists(TargetPriceListHeader: Record "Price List Header"; SourcePriceListLine: Record "Price List Line"; var ExistingPriceListLine: Record "Price List Line"): Boolean
    begin
        ExistingPriceListLine.SetRange("Price List Code", TargetPriceListHeader.Code);
        ExistingPriceListLine.SetRange("Product No.", SourcePriceListLine."Product No.");
        ExistingPriceListLine.SetRange("Variant Code", SourcePriceListLine."Variant Code");
        ExistingPriceListLine.SetRange("Starting Date", SourcePriceListLine."Starting Date");
        ExistingPriceListLine.SetRange("Ending Date", SourcePriceListLine."Ending Date");
        ExistingPriceListLine.SetRange(Status, ExistingPriceListLine.Status::Active);
        exit(ExistingPriceListLine.FindFirst());
    end;

    /// <summary>
    /// Create a new line in the target price list by transferring all fields from source.
    /// </summary>
    local procedure CreateTargetLine(TargetPriceListHeader: Record "Price List Header"; SourcePriceListLine: Record "Price List Line")
    var
        NewLine: Record "Price List Line";
    begin
        NewLine.Init();
        NewLine.TransferFields(SourcePriceListLine, false);
        NewLine."Price List Code" := TargetPriceListHeader.Code;
        NewLine.SetNextLineNo();
        NewLine.CopySourceFrom(TargetPriceListHeader);
        NewLine.SetNewRecord(true);

        if NewLine.Insert(true) then
            NewLine.Modify(true);
    end;

    /// <summary>
    /// Update an existing target line with values from the source line.
    /// </summary>
    local procedure UpdateTargetLine(var TargetPriceListLine: Record "Price List Line"; SourcePriceListLine: Record "Price List Line")
    begin
        TargetPriceListLine.Validate("Unit Price", SourcePriceListLine."Unit Price");
        TargetPriceListLine.Validate("Starting Date", SourcePriceListLine."Starting Date");
        TargetPriceListLine.Validate("Ending Date", SourcePriceListLine."Ending Date");
        TargetPriceListLine.Validate("Minimum Quantity", SourcePriceListLine."Minimum Quantity");
        if TargetPriceListLine.Modify(true) then;
    end;

    /// <summary>
    /// Verifies that a price list line contains sensible data before attempting sync.
    /// </summary>
    local procedure VerifyPriceListLine(PriceListLine: Record "Price List Line"): Boolean
    begin
        if PriceListLine."Price List Code" = '' then
            exit(false);
        if PriceListLine."Product No." = '' then
            exit(false);
        if PriceListLine."Unit Price" < 0 then
            exit(false);
        if PriceListLine."Cost Factor" < 0 then
            exit(false);
        if PriceListLine."Minimum Quantity" < 0 then
            exit(false);
        if (PriceListLine."Starting Date" <> 0D) and (PriceListLine."Ending Date" <> 0D) and
           (PriceListLine."Starting Date" > PriceListLine."Ending Date") then
            exit(false);
        exit(true);
    end;
}

