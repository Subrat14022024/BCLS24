namespace BCLS.BCLS;

using Microsoft.Sales.Document;
using Microsoft.Finance.Dimension;

pageextension 50110 SalesOrderExt extends "Sales Order"
{
    actions
    {
        addfirst(processing)
        {
            action(DimTest)
            {
                ToolTip = 'Auto Insert of Dimension';
                Caption = 'Test Dimensions';
                ApplicationArea = all;
                Image = Dimensions;
                trigger OnAction()
                var
                    TempDimSetEntry: Record "Dimension Set Entry" temporary;
                begin
                    TempDimSetEntry.Init();
                    TempDimSetEntry.Validate("Dimension Code", 'ENTITY');
                    TempDimSetEntry.Validate("Dimension Value Code", 'ZEB BE');
                    TempDimSetEntry.Insert();
                    UpdateDimSetonSalesHeader(Rec, TempDimSetEntry);
                    Rec.Modify();
                end;
            }
        }
    }

    local procedure UpdateDimSetonSalesHeader(var SH: Record "Sales Header"; var ToAddDims: Record "Dimension Set Entry" temporary)
    var
        TempNewDimSet: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit "DimensionManagement";
    begin
        DimMgt.GetDimensionSet(TempNewDimSet, Sh."Dimension Set ID");
        if ToAddDims.FindSet() then
            repeat
                if TempNewDimSet.get(SH."Dimension Set ID", ToAddDims."Dimension Code") then begin
                    TempNewDimSet.Validate("Dimension Value Code", ToAddDims."Dimension value Code");
                    TempNewDimSet.Modify()
                end else begin
                    TempNewDimSet := ToAddDims;
                    TempNewDimSet."Dimension Set ID" := SH."Dimension Set ID";
                    TempNewDimSet.Insert()
                end;
            until ToAddDims.Next() = 0;
        SH."Dimension Set ID" := DimMgt.GetDimensionSetID(TempNewDimSet);
        DimMgt.UpdateGlobalDimFromDimSetID(SH."Dimension Set ID", SH."Shortcut Dimension 1 Code", SH."Shortcut Dimension 2 Code");
    end;
}
