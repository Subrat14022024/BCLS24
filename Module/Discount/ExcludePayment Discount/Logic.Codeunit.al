namespace BCLS.BCLS;

using Microsoft.Purchases.Document;
using Microsoft.Finance.GeneralLedger.Account;

codeunit 50108 Logic
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterAssignGLAccountValues, '', false, false)]
    local procedure "Purchase Line_OnAfterAssignGLAccountValues"(var PurchLine: Record "Purchase Line"; GLAccount: Record "G/L Account"; PurchHeader: Record "Purchase Header"; xPurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line" temporary)
    begin
        if PurchLine.IsTemporary() then
            exit;

        PurchLine."Exclude from Payment Discount" := GLAccount."Exclude from Payment Discount";
    end;
}
