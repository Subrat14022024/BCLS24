namespace BCLS.BCLS;
using Microsoft.Inventory.Item;

page 52100 "FSO Item Images FactBox"
{
    PageType = CardPart;
    SourceTable = Item;
    Caption = 'Item Images';

    layout
    {
        area(content)
        {
            usercontrol(ItemCarousel; "FSO Item Image Carousel")
            {
                ApplicationArea = All;
                trigger OnImageClicked(ImageUrl: Text)
                begin
                    ShowImages();
                end;
            }
        }
    }

    local procedure ShowImages()
    var
        ImageUrls: Text;
        ImageUrl_Lbl: Label 'https://cdn.fashionsociety.be/items/MOA201MT%20005/colors/LIGHT%20BLUE?w=930&h=990', Comment = '%1 = Vendor Item No., %2 = Description', Locked = true;
    begin
        ImageUrls += StrSubstNo(ImageUrl_Lbl, Rec."Vendor Item No.", Rec.Description);
        CurrPage.ItemCarousel.SetImages(ImageUrls);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        this.ShowImages();
    end;
}

