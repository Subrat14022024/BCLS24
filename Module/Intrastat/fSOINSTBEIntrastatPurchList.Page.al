namespace BCLS.BCLS;
page 50133 fSOINSTBEIntrastatPurchList
{
    ApplicationArea = All;
    Caption = 'IntrastatPurchaseListPAge';
    PageType = List;
    SourceTable = "FSOINSTBEIntrastat Purchase";
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Area"; Rec."Area")
                {
                    ToolTip = 'Specifies the value of the Area field.', Comment = '%';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ToolTip = 'Specifies the value of the Country Code field.', Comment = '%';
                }
                field("Country of Origin Code"; Rec."Country of Origin Code")
                {
                    ToolTip = 'Specifies the value of the Country of Origin Code field.', Comment = '%';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Entry Point"; Rec."Entry Point")
                {
                    ToolTip = 'Specifies the value of the Entry Point field.', Comment = '%';
                }
                field("Exported to Sales Subs."; Rec."Exported to Sales Subs.")
                {
                    ToolTip = 'Specifies the value of the Exported to Sales Subs. field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Partner VAT ID"; Rec."Partner VAT ID")
                {
                    ToolTip = 'Specifies the value of the Partner VAT ID field.', Comment = '%';
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    ToolTip = 'Specifies the value of the Posted Document No. field.', Comment = '%';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Statistical Value"; Rec."Statistical Value")
                {
                    ToolTip = 'Specifies the value of the Statistical Value field.', Comment = '%';
                }
                field("Supplementary Units"; Rec."Supplementary Units")
                {
                    ToolTip = 'Specifies the value of the Supplementary Units field.', Comment = '%';
                }
                field("Synchronization Date Export"; Rec."Synchronization Date Export")
                {
                    ToolTip = 'Specifies the value of the Synchronization Date Export field.', Comment = '%';
                }
                field("Synchronization Date Import"; Rec."Synchronization Date Import")
                {
                    ToolTip = 'Specifies the value of the Synchonization date import field.', Comment = '%';
                }
                field("Synchronization Time Export"; Rec."Synchronization Time Export")
                {
                    ToolTip = 'Specifies the value of the Synchonization time export field.', Comment = '%';
                }
                field("Synchronization Time Import"; Rec."Synchronization Time Import")
                {
                    ToolTip = 'Specifies the value of the Synchonization time import field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
                field("Tariff No."; Rec."Tariff No.")
                {
                    ToolTip = 'Specifies the value of the Tariff No. field.', Comment = '%';
                }
                field("Tariff No. Description"; Rec."Tariff No. Description")
                {
                    ToolTip = 'Specifies the value of the Tariff No. Description field.', Comment = '%';
                }
                field("Total Weight"; Rec."Total Weight")
                {
                    ToolTip = 'Specifies the value of the Total Weight field.', Comment = '%';
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                    ToolTip = 'Specifies the value of the Transaction Specification field.', Comment = '%';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Transaction Type field.', Comment = '%';
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ToolTip = 'Specifies the value of the Transport Method field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Process)
            {
                ApplicationArea = All;
                Caption = 'Process';
                ToolTip = 'Process action will help to insert the line into TCOG Tables';
                trigger OnAction()
                var
                    IntrastatPurchase: Record "FSOINSTBEIntrastat Purchase";
                begin
                    IntrastatPurchase.SetRange(Processed, false);
                    if IntrastatPurchase.FindSet() then
                        repeat
                            ProcessIntrastatEntries(IntrastatPurchase);
                        until IntrastatPurchase.Next() = 0;
                end;
            }
        }

    }
    local procedure ProcessIntrastatEntries(var IntrastatPurchase: Record "FSOINSTBEIntrastat Purchase")
    var
        IntrastatReportLine: Record "TCOGINGL Intrastat Report Line";
    begin
        IntrastatReportLine.Init();
        IntrastatReportLine."GUID entry No." := CreateGuid();
        IntrastatReportLine."Line No." := IntrastatPurchase."Line No.";
        IntrastatReportLine.Type := IntrastatReportLine.Type::Receipt;
        IntrastatReportLine.Date := IntrastatPurchase.Date;
        IntrastatReportLine."Tariff No." := IntrastatPurchase."Tariff No.";
        IntrastatReportLine."Tariff Description" := IntrastatPurchase."Tariff No. Description";
        IntrastatReportLine."Country/Region Code" := IntrastatPurchase."Country Code";
        IntrastatReportLine."Transaction Type" := IntrastatPurchase."Transaction Type";
        IntrastatReportLine."Transport Method" := IntrastatPurchase."Transport Method";
        IntrastatReportLine."Source Type" := IntrastatReportLine."Source Type"::" ";
        IntrastatReportLine.Amount := IntrastatPurchase.Amount;
        IntrastatReportLine.Quantity := IntrastatPurchase.Quantity;
        IntrastatReportLine."Transaction Specification" := IntrastatPurchase."Transaction Specification";
        IntrastatReportLine."Statistical Value" := IntrastatPurchase."Statistical Value";
        IntrastatReportLine."Document No." := IntrastatPurchase."Document No.";
        IntrastatReportLine."Total Weight" := IntrastatPurchase."Total Weight";
        IntrastatReportLine."Supplementary Units" := IntrastatPurchase."Supplementary Units";
        IntrastatReportLine."Entry/Exit Point" := IntrastatPurchase."Entry Point";
        IntrastatReportLine."Area" := IntrastatPurchase."Area";
        IntrastatReportLine."Transaction Specification" := IntrastatPurchase."Transaction Specification";
        IntrastatReportLine."Partner VAT ID" := IntrastatPurchase."Partner VAT ID";
        IntrastatReportLine."Suppl. Unit of Measure" := IntrastatPurchase."Unit of Measure";
        if IntrastatReportLine.Insert() then begin
            IntrastatPurchase.Processed := true;
            IntrastatPurchase.Modify();
        end;

    end;
}
