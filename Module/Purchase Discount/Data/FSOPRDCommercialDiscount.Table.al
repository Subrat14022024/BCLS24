namespace FSO_Purchase.Discount;
using Microsoft.Purchases.Vendor;

table 50652 "FSO PRD Commercial Discount"
{
    Caption = 'Commercial Discount';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
            ToolTip = 'Specifies the vendor to whom the discount applies.';
        }
        field(3; Brand; Code[20])
        {
            Caption = 'Brand';
            TableRelation = "FSO PUR Brand".Code;
            ToolTip = 'Specifies the Brand for which the discount is applicable.';
        }
        field(6; "Order Type"; Code[20])
        {
            Caption = 'Order Type';
            TableRelation = "FSO PRD Order Type"."Order Type";
            ToolTip = 'Specifies the order type for which the discount is applicable.';
        }
        field(7; "Sub Order Type"; Code[20])
        {
            Caption = 'Sub Order Type';
            TableRelation = "FSO PRD Order Type"."Sub Order Type" where("Order Type" = field("Order Type"));
            ToolTip = 'Specifies the sub order type for which the discount is applicable.';
        }
        field(8; "Discount %"; Decimal)
        {
            Caption = 'Discount %';
            DecimalPlaces = 0 : 2;
            ToolTip = 'Specifies the discount percentage to be applied.';
        }
        field(9; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            ToolTip = 'Specifies the starting date from which the discount is valid.';
        }
        field(10; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            ToolTip = 'Specifies the ending date until which the discount is valid.';
            trigger OnValidate()
            var
                Error_Lbl: Label 'can not be lesser then %1', Comment = '%1 is for Starting Date';
            begin
                if "Ending Date" <> 0D then
                    if Rec."Ending Date" < Rec."Starting Date" then
                        this.FieldError("Ending Date", StrSubstNo(Error_Lbl, Rec."Starting Date"));
            end;
        }
    }
    keys
    {
        key(PK; "Vendor No.", Brand, "Order Type", "Sub Order Type")
        {
            Clustered = true;
        }
    }
}
