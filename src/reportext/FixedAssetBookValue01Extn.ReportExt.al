reportextension 50100 FixedAssetBookValue01Extn extends "Fixed Asset - Book Value 01"
{
    dataset
    {
        add("Fixed Asset")
        {
            column("AcquisitionCostAccount"; "AcquisitionCostAccount")
            {
            }
            column("DepreciationStartingDate"; DepreciationStartingDate)
            {
            }
            column("GlobalDimension1"; "Global Dimension 1 Code")
            {
            }
            column("NoofDepreciationYears"; "NoofDepreciationYears")
            {
            }
            column("StraightLine"; "StraightLine")
            {
            }
            column(DepreciationStartingDateCaption_Lbl; DepreciationStartingDate_Lbl)
            {

            }
            column(GlobalDimension1Caption_Lbl; GlobalDimension1)
            {

            }
            column(NoofDepreciationYearsCaption_Lbl; NoofDepreciationYears_Lbl)
            {

            }
            column(NoofDepreciCaption_Lbl; NoofDepreciationYears_Lbl)
            {

            }
            column(StraightLineCaption_Lbl; StraightLine_Lbl)
            {

            }

        }

    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    rendering
    {
        layout(LayoutName)
        {
            LayoutFile = 'src\report\layout\FixedAssetBookValue01Extn.rdl';
            Type = RDLC;
        }
    }
    trigger OnPreReport()

    begin
        DepreciationStartingDate := FADeprBook."Depreciation Starting Date";
        NoofDepreciationYears := FADeprBook."No. of Depreciation Years";
        StraightLine := FADeprBook."Straight-Line %";

        if FAPostingGroup.GET(FADeprBook."FA Posting Group") then
            AcquisitionCostAccount := FAPostingGroup.GetAcquisitionCostAccount();

        GL_Setup.Get();
        GlobalDimension1 := GL_Setup.FieldCaption("Shortcut Dimension 1 Code")
    end;

    var
        FAPostingGroup: Record "FA Posting Group";
        GL_Setup: Record "General Ledger Setup";
        AcquisitionCostAccount: Code[20];
        DepreciationStartingDate: Date;
        StraightLine: Decimal;
        NoofDepreciationYears: Integer;
        AcquisitionCostAccount_Lbl: Label 'Acquisition Cost Account';
        DepreciationStartingDate_Lbl: label 'Depreciation Starting Date';
        NoofDepreciationYears_Lbl: Label 'No. of Depreciation Years';
        StraightLine_Lbl: Label 'Straight-Line %';
        GlobalDimension1: Text;
}