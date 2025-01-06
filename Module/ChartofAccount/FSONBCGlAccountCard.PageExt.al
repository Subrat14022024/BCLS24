pageextension 50101 FSONBCGlAccountCard extends "G/L Account Card"
{
    layout
    {
        modify("Account Category")
        {
            ShowMandatory = true;
            BlankZero = true;
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Consol. Translation Method" := Rec."Consol. Translation Method"::"Historical Rate";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."No." <> '' then
            if Rec."Account Category" = Rec."Account Category"::" " then
                rec.TestField("Account Category");
    end;
}
