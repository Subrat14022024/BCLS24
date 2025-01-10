namespace BCLS.BCLS;

using Microsoft.Finance.Dimension;

page 50121 DimensionUpdate
{
    APIGroup = 'vendor';
    APIPublisher = 'fso';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'dimensionUpdate';
    DelayedInsert = true;
    EntityName = 'dimensionUpdate';
    EntitySetName = 'dimensionUpdates';
    PageType = API;
    AutoSplitKey = false;
    ODataKeyFields = SystemId;
    SourceTable = "Default Dimension";



    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(tableID; Rec."Table ID")
                {
                    Caption = 'Table ID';
                }
                field(allowedValuesFilter; Rec."Allowed Values Filter")
                {
                    Caption = 'Allowed Values Filter';
                }
                field(dimensionCode; Rec."Dimension Code")
                {
                    Caption = 'Dimension Code';
                }
                field(dimensionValueCode; Rec."Dimension Value Code")
                {
                    Caption = 'Dimension Value Code';
                }
                field(dimensionId; Rec.DimensionId)
                {
                    Caption = 'DimensionId';
                }
                field(dimensionValueId; Rec.DimensionValueId)
                {
                    Caption = 'DimensionValueId';
                }
                field(multiSelectionAction; Rec."Multi Selection Action")
                {
                    Caption = 'Multi Selection Action';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(parentType; Rec."Parent Type")
                {
                    Caption = 'Parent Type';
                }
                field(parentId; Rec.ParentId)
                {
                    Caption = 'ParentId';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
                field(tableCaption; Rec."Table Caption")
                {
                    Caption = 'Table Caption';
                }
                field(valuePosting; Rec."Value Posting")
                {
                    Caption = 'Value Posting';
                }
            }
        }
    }
}
