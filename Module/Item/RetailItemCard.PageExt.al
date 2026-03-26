namespace FSO_Purchase.VendorItemColor;

#if not FSOCLEAN27
pageextension 58402 "Retail Item Card" extends "LSC Retail Item Card"
# endif
pageextension 58402 "Retail Item Card" extends "LSC Retail Item"
{
    layout
    {
        moveafter("No."; "Vendor Item No.")

        modify("Vendor Item No.")
        {
            ShowMandatory = true;
            Editable = ItemNoEditable;
        }

        addafter("Vendor Item No.")
        {
            field("Vendor Item Color"; Rec."Vendor Item Color")
            {
                ShowMandatory = true;
                NotBlank = true;
                Editable = ItemColorEditable;
                ApplicationArea = All;
            }
        }
        modify("Base Unit of Measure")
        {
            trigger OnAfterValidate()
            begin
                CheckEditable := true;
            end;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                CheckEditable := true;
            end;
        }
#if not FSOCLEAN27
        modify("<Base Unit of Measure2>")
        {
            trigger OnAfterValidate()
            begin
                CheckEditable := true;
            end;
        }
        modify("<Base Unit of Measure3>")
        {
            trigger OnAfterValidate()
            begin
                CheckEditable := true;
            end;
        }
#endif
    }

    trigger OnAfterGetRecord()
    begin
        if not CheckEditable then
            this.checkPageUpdate()
        else
            CheckEditable := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        this.checkPageUpdate();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if (Rec."No." <> '') then
            if (Rec."Vendor Item No." = '') or (Rec."Vendor Item Color" = '') then begin
                Rec.Validate(Blocked, true);
                Rec.Modify(true);
            end;
    end;

    var
        ItemNoEditable: Boolean;
        ItemColorEditable: Boolean;
        CheckEditable: Boolean;

    procedure checkPageUpdate()
    begin
        ItemNoEditable := true;
        if Rec."Vendor Item No." <> '' then
            ItemNoEditable := false;

        ItemColorEditable := true;
        if Rec."Vendor Item Color" <> '' then
            ItemColorEditable := false;
    end;
}