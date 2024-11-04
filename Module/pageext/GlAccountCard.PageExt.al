pageextension 50101 GlAccountCard extends "G/L Account Card"
{
    layout
    {
        modify("Account Category")
        {
            ShowMandatory = true;
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Consol. Translation Method" := Rec."Consol. Translation Method"::"Historical Rate";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.TestField("Account Category");
    end;

}
