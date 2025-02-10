namespace BCLS.BCLS;
using Microsoft.Inventory.Intrastat;

page 50132 fSOINSTBEIntrastatAPI
{
    APIGroup = 'intrastat';
    APIPublisher = 'fso';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'intrastatAPI';
    DelayedInsert = true;
    EntityName = 'intrastat';
    EntitySetName = 'intrastats';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "FSOINSTBEIntrastat Purchase";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(fSOINSTBEamount; Rec.Amount)
                {
                }
                field("fSOINSTBEarea"; Rec."Area")
                {
                }
                field(fSOINSTBEcountryCode; Rec."Country Code")
                {
                }
                field(fSOINSTBEcountryOfOriginCode; Rec."Country of Origin Code")
                {
                }
                field("fSOINSTBEdate"; Rec."Date")
                {
                }
                field(fSOINSTBEdocumentNo; Rec."Document No.")
                {
                }
                field(fSOINSTBEentryPoint; Rec."Entry Point")
                {
                }
                field(fSOINSTBEexportedToSalesSubs; Rec."Exported to Sales Subs.")
                {
                }
                field(fSOINSTBElineNo; Rec."Line No.")
                {
                }
                field(fSOINSTBEsystemId; Rec.SystemId)
                {
                }
                field(fSOINSTBEpostedDocumentNo; Rec."Posted Document No.")
                {
                }
                field(fSOINSTBEprocessed; Rec.Processed)
                {
                }
                field(fSOINSTBEquantity; Rec.Quantity)
                {
                }
                field(fSOINSTBEstatisticalValue; Rec."Statistical Value")
                {
                }
                field(fSOINSTBEsupplementaryUnits; Rec."Supplementary Units")
                {
                }
                field(fSOINSTBEsynchronizationDateExport; Rec."Synchronization Date Export")
                {
                }
                field(fSOINSTBEsynchronizationDateImport; Rec."Synchronization Date Import")
                {
                }
                field(fSOINSTBEsynchronizationTimeExport; Rec."Synchronization Time Export")
                {
                }
                field(fSOINSTBEsynchronizationTimeImport; Rec."Synchronization Time Import")
                {
                }
                field(fSOINSTBEsystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(fSOINSTBEsystemCreatedBy; Rec.SystemCreatedBy)
                {
                }
                field(fSOINSTBEtariffNo; Rec."Tariff No.")
                {
                }
                field(fSOINSTBEtariffNoDescription; Rec."Tariff No. Description")
                {
                }
                field(fSOINSTBEtotalWeight; Rec."Total Weight")
                {
                }
                field(fSOINSTBEtransactionSpecification; Rec."Transaction Specification")
                {
                }
                field("fSOINSTBEtransactionType"; Rec."Transaction Type")
                {
                }
                field(fSOINSTBEtransportMethod; Rec."Transport Method")
                {
                }
                field("fSOINSTBEtype"; Rec."Type")
                {
                }
                field(fSOINSTBEunitOfMeasure; Rec."Unit of Measure")
                {
                }
                field("fSOINSTBEpartnerVATID"; Rec."Partner VAT ID")
                {
                }
            }
        }
    }
}
