namespace FSO_Purchase.Discount;
using Microsoft.Purchases.Vendor;

table 50303 "FSO PRD Vendor Brand Discount"
{
    Caption = 'Vendor Brand Discount';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
            ToolTip = 'Specifies the vendor to whom the discount applies.';
        }
        field(2; Branch; Code[20])
        {
            Caption = 'Branch';
            TableRelation = "FSO PRD Branch".Code;
            ToolTip = 'Specifies the branch associated with the vendor for this discount.';
        }
        field(3; "Attribute Code"; Code[20])
        {
            Caption = 'Attribute Code';
            TableRelation = "LSC Attribute".Code;
            ToolTip = 'Specifies the attribute code for which the discount is applicable.';
            trigger OnValidate()
            var
                LSCAttribute: Record "LSC Attribute";
            begin
                if LSCAttribute.Get("Attribute Code") then
                    Rec."Attribute Description" := LSCAttribute.Description;
            end;
        }
        field(4; "Attribute Description"; Text[50])
        {
            Editable = false;
            Caption = 'Attribute Description';
            TableRelation = "LSC Attribute".Description where(Code = field("Attribute Code"));
            ToolTip = 'Displays the description of the selected attribute code.';
        }
        field(5; "Attribute Code Value"; Text[50])
        {
            Caption = 'Attribute Code Value';
            ToolTip = 'Specifies the value of the attribute code for which the discount is applicable.';
            trigger OnLookup()
            var
                LSCAttributeValue: Record "LSC Attribute Value";
                AttributeUtils: Codeunit "LSC Attribute Utils";
                RetValue: Text[250];
                ActionReturned: Action;
            begin
                LSCAttributeValue.ReadIsolation(IsolationLevel::ReadUncommitted);
                LSCAttributeValue.SetRange("Attribute Code", Rec."Attribute Code");
                if LSCAttributeValue.FindFirst() then
                    RetValue := AttributeUtils.LookupOptionValues(LSCAttributeValue."Link Type".AsInteger(), "Attribute Code", ActionReturned);

                if ActionReturned = ACTION::LookupOK then
                    Rec.Validate(Rec."Attribute code Value", RetValue);
            end;

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
        // Composite primary key ensures uniqueness for each vendor, branch, attribute, attribute value, order type, and sub order type combination.
        // This design prevents duplicate discount entries for the same set of criteria.
        key(PK; "Vendor No.", Branch, "Attribute Code", "Attribute Code Value", "Order Type", "Sub Order Type")
        {
            Clustered = true;
        }
    }
}
