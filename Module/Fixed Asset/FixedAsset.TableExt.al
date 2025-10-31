namespace BCLS.BCLS;

using Microsoft.FixedAssets.FixedAsset;

tableextension 55107 "Fixed Asset" extends "Fixed Asset"
{
    fields
    {
        field(50100; "FSOBEF Neg. Acquisition Value"; Boolean)
        {
            Caption = 'Negative Acquisition Value';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether the fixed asset has a negative acquisition value.';
        }
    }
}
