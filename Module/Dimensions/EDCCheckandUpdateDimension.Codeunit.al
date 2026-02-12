namespace FSO.Dimension;

Using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Setup;

codeunit 50162 "FSOFIN Dimension Update Mgmt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, OnAfterGetRecDefaultDimIDProcedure, '', false, false)]
    local procedure DimensionManagementOnAfterGetRecDefaultDimIDProcedure(var GlobalDim2Code: Code[20]; var DefaultDimSetID: Integer; CurrFieldNo: Integer; var GlobalDim1Code: Code[20])
    begin
        this.ProcessGlobalDimCode(GlobalDim1Code, DefaultDimSetID);
        this.ProcessGlobalDimCode(GlobalDim2Code, DefaultDimSetID);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, OnAfterValidateShortcutDimValues, '', false, false)]
    local procedure DimensionManagementOnAfterValidateShortcutDimValues(FieldNumber: Integer; var DimSetID: Integer; var ShortcutDimCode: Code[20])
    begin
        this.ProcessAllShortcutDimensions(DimSetID, ShortcutDimCode, FieldNumber);
    end;

    local procedure ProcessGlobalDimCode(DimValueCode: Code[20]; var DefaultDimSetID: Integer)
    var
        GLSetup: Record "General Ledger Setup";
        i: Integer;
        ShortcutDimCode: Code[20];
        DimNo: Integer;
    begin
        GLSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        GLSetup.SetLoadFields("Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code",
                              "Shortcut Dimension 4 Code", "Shortcut Dimension 5 Code", "Shortcut Dimension 6 Code",
                              "Shortcut Dimension 7 Code", "Shortcut Dimension 8 Code");
        if not GLSetup.Get() then
            exit;
        DimNo := 0;
        if DimValueCode <> '' then begin
            for i := 1 to 8 do begin
                case i of
                    1:
                        ShortcutDimCode := GLSetup."Shortcut Dimension 1 Code";
                    2:
                        ShortcutDimCode := GLSetup."Shortcut Dimension 2 Code";
                    3:
                        ShortcutDimCode := GLSetup."Shortcut Dimension 3 Code";
                    4:
                        ShortcutDimCode := GLSetup."Shortcut Dimension 4 Code";
                    5:
                        ShortcutDimCode := GLSetup."Shortcut Dimension 5 Code";
                    6:
                        ShortcutDimCode := GLSetup."Shortcut Dimension 6 Code";
                    7:
                        ShortcutDimCode := GLSetup."Shortcut Dimension 7 Code";
                    8:
                        ShortcutDimCode := GLSetup."Shortcut Dimension 8 Code";
                end;
                if ShortcutDimCode <> '' then
                    if this.RecExistsForDimValue(ShortcutDimCode, DimValueCode) then
                        DimNo := i;
            end;
            if DimNo > 0 then
                this.ProcessAllShortcutDimensions(DefaultDimSetID, DimValueCode, DimNo);
        end;
    end;

    local procedure ProcessAllShortcutDimensions(var DimensionSetID: Integer; ShortcutDimCode1: Code[20]; CurrFieldNo: Integer)
    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRecRef: RecordRef;
        FieldRef: FieldRef;
        ShortcutDimCode: Code[20];
    begin
        GLSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        GLSetup.SetLoadFields("Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code",
                              "Shortcut Dimension 4 Code", "Shortcut Dimension 5 Code", "Shortcut Dimension 6 Code",
                              "Shortcut Dimension 7 Code", "Shortcut Dimension 8 Code");
        if not GLSetup.Get() then
            exit;

        GLSetupRecRef.GetTable(GLSetup);
        if CurrFieldNo in [1 .. 8] then
            case CurrFieldNo of
                1:
                    FieldRef := GLSetupRecRef.Field(GLSetup.FieldNo("Shortcut Dimension 1 Code"));
                2:
                    FieldRef := GLSetupRecRef.Field(GLSetup.FieldNo("Shortcut Dimension 2 Code"));
                3:
                    FieldRef := GLSetupRecRef.Field(GLSetup.FieldNo("Shortcut Dimension 3 Code"));
                4:
                    FieldRef := GLSetupRecRef.Field(GLSetup.FieldNo("Shortcut Dimension 4 Code"));
                5:
                    FieldRef := GLSetupRecRef.Field(GLSetup.FieldNo("Shortcut Dimension 5 Code"));
                6:
                    FieldRef := GLSetupRecRef.Field(GLSetup.FieldNo("Shortcut Dimension 6 Code"));
                7:
                    FieldRef := GLSetupRecRef.Field(GLSetup.FieldNo("Shortcut Dimension 7 Code"));
                8:
                    FieldRef := GLSetupRecRef.Field(GLSetup.FieldNo("Shortcut Dimension 8 Code"));
            end else
            exit;

        if FieldRef.Type = FieldType::Code then
            ShortcutDimCode := FieldRef.Value
        else
            ShortcutDimCode := '';

        if ShortcutDimCode1 <> '' then
            this.UpdateDimension(ShortcutDimCode, ShortcutDimCode1, DimensionSetID);
    end;

    local procedure UpdateDimension(ShortcutDimCode: Code[20]; ReferenceDim: Code[20]; var DimensionSetID: Integer)
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimensionManagement: Codeunit "DimensionManagement";
        RecordUpdated, RemoveDimension : Boolean;
        UpdateDimCode, UpdateDim : Code[20];
    begin
        DimensionManagement.GetDimensionSet(TempDimSetEntry, DimensionSetID);

        RemoveDimension := this.CheckAndDecide(ShortcutDimCode, ReferenceDim, UpdateDim, UpdateDimCode);
        RecordUpdated := this.UpdateRecord(TempDimSetEntry, UpdateDim, UpdateDimCode, RemoveDimension);

        if RecordUpdated then
            DimensionSetID := DimensionSetEntry.GetDimensionSetID(TempDimSetEntry);
    end;

    local procedure CheckAndDecide(DimensionCode: Code[20]; ReferenceDim: Code[20]; var UpdateDim: Code[20]; var UpdateDimCode: Code[20]): Boolean
    var
        DimVal: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        GLSetup.SetLoadFields("Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code",
                              "Shortcut Dimension 4 Code", "Shortcut Dimension 5 Code", "Shortcut Dimension 6 Code",
                              "Shortcut Dimension 7 Code", "Shortcut Dimension 8 Code");
        if not GLSetup.Get() then
            exit(true);

        DimVal.ReadIsolation(IsolationLevel::ReadUncommitted);
        DimVal.SetLoadFields("FSOFIN Enseigne", "FSOFIN Link Dimension");
        if DimVal.Get(DimensionCode, ReferenceDim) then begin
            UpdateDim := DimVal."FSOFIN Link Dimension";
            UpdateDimCode := DimVal."FSOFIN Enseigne";
        end else begin
            UpdateDim := '';
            UpdateDimCode := '';
        end;
        exit(UpdateDimCode = '');
    end;

    local procedure UpdateRecord(var TempDimSetEntry: Record "Dimension Set Entry" temporary; DimCode: Code[20]; UpdateDimCode: Code[20]; RemoveDim: Boolean): Boolean
    begin
        TempDimSetEntry.SetRange("Dimension Code", DimCode);
        if TempDimSetEntry.IsEmpty then
            if RemoveDim then
                exit(false)
            else
                exit(this.AddOrUpdateDimensionValue(TempDimSetEntry, DimCode, UpdateDimCode))
        else begin
            TempDimSetEntry.SetRange("Dimension Value Code", UpdateDimCode);
            if TempDimSetEntry.IsEmpty then
                if RemoveDim then
                    exit(this.RemoveDimensionValue(TempDimSetEntry, DimCode))
                else
                    exit(this.AddOrUpdateDimensionValue(TempDimSetEntry, DimCode, UpdateDimCode));
        end;
        exit(false);
    end;

    local procedure AddOrUpdateDimensionValue(var TempDimSetEntry: Record "Dimension Set Entry" temporary; DimCode: Code[20]; UpdateDimCode: Code[20]): Boolean
    var
        DimVal: Record "Dimension Value";
    begin
        this.ResetDimensionSetID(TempDimSetEntry);
        DimVal.ReadIsolation(IsolationLevel::ReadUncommitted);
        DimVal.SetLoadFields("Dimension Value ID", Blocked);
        if not DimVal.Get(DimCode, UpdateDimCode) or DimVal.Blocked then
            exit(false);

        if TempDimSetEntry.Get(0, DimCode) then begin
            TempDimSetEntry.Validate("Dimension Value Code", UpdateDimCode);
            TempDimSetEntry.Validate("Dimension Value ID", DimVal."Dimension Value ID");
            TempDimSetEntry.Modify(true);
        end else begin
            TempDimSetEntry.Init();
            TempDimSetEntry.Validate("Dimension Code", DimCode);
            TempDimSetEntry.Validate("Dimension Value Code", UpdateDimCode);
            TempDimSetEntry.Validate("Dimension Value ID", DimVal."Dimension Value ID");
            TempDimSetEntry.Insert(true);
        end;
        exit(true);
    end;

    local procedure RemoveDimensionValue(var TempDimSetEntry: Record "Dimension Set Entry" temporary; DimCode: Code[20]): Boolean
    begin
        this.ResetDimensionSetID(TempDimSetEntry);
        if TempDimSetEntry.Get(0, DimCode) then
            TempDimSetEntry.Delete(true);
        exit(true);
    end;

    local procedure ResetDimensionSetID(var TempDimSetEntry: Record "Dimension Set Entry" temporary)
    begin
        TempDimSetEntry.SetRange("Dimension Code");
        TempDimSetEntry.SetRange("Dimension Value Code");
        if TempDimSetEntry.FindSet(true) then
            repeat
                TempDimSetEntry.Rename(0, TempDimSetEntry."Dimension Code");
            until TempDimSetEntry.Next() = 0;
    end;

    local procedure RecExistsForDimValue(DimCode: Code[20]; DimValueCode: Code[20]): Boolean
    var
        DimVal: Record "Dimension Value";
    begin
        exit(DimVal.Get(DimCode, DimValueCode));
    end;
}
