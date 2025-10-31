namespace BCLS.BCLS;

using Microsoft.Purchases.Document;
using System.Environment.Configuration;

pageextension 50114 "Notification" extends "Purchase Invoice"
{
    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Transaction Specification" = '' then
            NotifyTransactionSpecBlank()
        else
            RecallNotification();
    end;

    local procedure NotifyTransactionSpecBlank()
    var
        NotificationLifeCycleMgmt: Codeunit "Notification Lifecycle Mgt.";
        Notification: Notification;
        TransactionSpectication_Lbl: Label 'Transaction Specification is blank. Please update the field before posting the document.', Locked = true;
    begin
        Notification.Message(TransactionSpectication_Lbl);
        Notification.Scope(NotificationScope::LocalScope);
        NotificationLifeCycleMgmt.SendNotification(Notification, Rec.RecordId());
    end;

    local procedure RecallNotification()
    var
        NotificationLifeCycleMgmt: Codeunit "Notification Lifecycle Mgt.";
    begin
        NotificationLifeCycleMgmt.RecallNotificationsForRecord(Rec.RecordId, true);
    end;
}
