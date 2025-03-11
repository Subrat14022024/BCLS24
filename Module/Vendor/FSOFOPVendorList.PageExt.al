namespace BCLS.BCLS;

using Microsoft.Purchases.Vendor;

pageextension 50104 FSOFOPVendorList extends "Vendor List"
{
    layout
    {
        modify("No.")
        {
            StyleExpr = StyleTxt;
        }
        modify("Name")
        {
            StyleExpr = StyleTxt;
        }
    }
    var
        StyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle();
    end;

    local procedure SetStyle(): Text
    begin
        case Rec.Blocked of
            Rec.Blocked::All:
                exit(FormatPageStyle(PageStyle::Unfavorable));
            Rec.Blocked::Payment:
                exit(FormatPageStyle(PageStyle::Ambiguous));
            else
                exit(FormatPageStyle(PageStyle::None));
        end;
    end;

    local procedure FormatPageStyle(NewPageStyle: PageStyle): Text
    begin
        exit(Format(NewPageStyle))
    end;

}
