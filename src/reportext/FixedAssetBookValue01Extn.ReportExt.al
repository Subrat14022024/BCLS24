reportextension 50100 FixedAssetBookValue01Extn extends "Fixed Asset - Book Value 01"
{
    dataset
    {
        add("Fixed Asset")
        {
            column("AcquisitionCostAccount"; "AcquisitionCostAccount")
            {
                Caption = 'Acquisition Cost Account';
            }
            column("DepreciationStartingDate"; DepreciationStartingDate)
            {
                Caption = 'Depreciation Starting Date';
            }
            column("GlobalDimension1"; "Global Dimension 1 Code")
            {
                Caption = 'Global Dimension 1 Code';
            }
            column("NoofDepreciationYears"; "NoofDepreciationYears")
            {
                Caption = 'No. of Depreciation Years';
            }
            column("StraightLine"; "StraightLine")
            {
                Caption = 'Straight-Line %';
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
            LayoutFile = '.vscode\Report Layouts\FixedAssetBookValue01Extn.rdl';
            Type = RDLC;
        }
    }
    trigger OnPreReport()

    begin
        DepreciationStartingDate := FADeprBook."Depreciation Starting Date";
        NoofDepreciationYears := FADeprBook."No. of Depreciation Years";
        StraightLine := FADeprBook."Straight-Line %";

        if FAPostingGroup.GET(FADeprBook."FA Posting Group") then
            AcquisitionCostAccount := FAPostingGroup.GetAcquisitionCostAccount()

    end;

    var
        FAPostingGroup: Record "FA Posting Group";
        AcquisitionCostAccount: Code[20];
        DepreciationStartingDate: Date;
        StraightLine: Decimal;
        NoofDepreciationYears: Integer;

}