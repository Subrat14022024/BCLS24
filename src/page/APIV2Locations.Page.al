namespace Microsoft.API.V2;

using Microsoft.Inventory.Location;

page 50106 "APIV2 - Locations"
{
    APIGroup = 'sales';
    APIPublisher = 'hansamukh';
    APIVersion = 'v2.0';
    DelayedInsert = true;
    EntityCaption = 'Location';
    EntityName = 'location';
    EntitySetCaption = 'Locations';
    EntitySetName = 'locations';
    Extensible = false;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = Location;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(code; Rec.Code)
                {
                    Caption = 'Code';
                }
                field(displayName; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(contact; Rec.Contact)
                {
                    Caption = 'Contact';
                }
                field(addressLine1; Rec.Address)
                {
                    Caption = 'Address Line 1';
                }
                field(addressLine2; Rec."Address 2")
                {
                    Caption = 'Address Line 2';
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                }
                field(state; Rec.County)
                {
                    Caption = 'State';
                }
                field(country; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                }
                field(postalCode; Rec."Post Code")
                {
                    Caption = 'Post Code';
                }
                field(phoneNumber; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(email; Rec."E-Mail")
                {
                    Caption = 'Email';
                }
                field(website; Rec."Home Page")
                {
                    Caption = 'Website';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                    Editable = false;
                }
            }
        }
    }
}