namespace BCLS.BCLS;
using System.Utilities;

page 59106 ErrorCollection
{
    ApplicationArea = All;
    Caption = 'ErrorCollection';
    PageType = Card;
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(TestError)
            {
                ApplicationArea = All;
                Caption = 'TestError';
                Image = ItemTrackingLedger;
                ToolTip = 'Testing of collection of errors';
                trigger OnAction()
                begin
                    this.TEST();
                end;
            }
        }

    }

    [ErrorBehavior(ErrorBehavior::Collect)]
    local procedure TEST()
    var
        Notofication1: Notification;
        Name: Text[20];
        ErrorInformation: ErrorInfo;

    begin
        // Name := 'Subrat';
        // if Name = 'Subrat' then begin
        //     ErrorInformation := ErrorInfo.Create('Name Can not be subrat', true);
        //     ErrorInformation.Collectible(true);
        //     Error(ErrorInfo.Create('2nd error message', true));
        // end;
        // Error(ErrorInformation);
        Notofication1.Message('Hi Subrat this action is notification');
        Notofication1.Send()


    end;
}
