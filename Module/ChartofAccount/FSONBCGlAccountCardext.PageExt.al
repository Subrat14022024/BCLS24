pageextension 50125 FSONBCGlAccountCardext extends "G/L Account Card"
{
    // Set the default Review Policy when a new G/L Account record is created to ensure proper review and balance matching.
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Review Policy" := Rec."Review Policy"::"Allow Review and Match Balance";
    end;
}
