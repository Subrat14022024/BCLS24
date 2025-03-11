namespace BCLS.BCLS;

using Microsoft.Purchases.Vendor;

pageextension 50107 "Vendor Card" extends "Vendor Card"
{
    layout
    {
        modify(Blocked)
        {
            StyleExpr = StyleTxt;
        }
    }
    var
        StyleTxt: Text;

    trigger OnAfterGetCurrRecord()
    begin
        StyleTxt := SetStyle();
    end;

    local procedure SetStyle(): Text
    var
        Unfavorable_Lbl: Label 'Unfavorable', Locked = true;
        Ambiguous_Lbl: Label 'Ambiguous', Locked = true;
    begin
        case Rec.Blocked of
            Rec.Blocked::All:
                exit(Unfavorable_Lbl);
            Rec.Blocked::Payment:
                exit(Ambiguous_Lbl);
            else
                exit('');
        end;
    end;
}
