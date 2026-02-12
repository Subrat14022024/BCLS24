namespace BlankVAT.CBEImporter;

using BCLS.BCLS;
using BlankVAT.CBEImporter;
using Financial.FSOSEPA;
using FINBC.FINBC;
using FSO.Dimension;
using FSOFIN.PayrollFileImport;
using FSO_NAVBCConnector.PurchaseInv;
using FSO_NAVBCConnector.SalesInv;
using FSO_NAVBCConnector.Shoppayment;
using FSO_Purchase.Discount;

permissionset 54700 GeneratedPermission
{
    Assignable = true;
    Permissions = tabledata "Azure File Service Setup TEST" = RIMD,
        tabledata "FSO CBE Company" = RIMD,
        tabledata "FSO CBE Establishment" = RIMD,
        tabledata "FSO CBE NACE Activity" = RIMD,
        tabledata "FSO PRD Branch" = RIMD,
        tabledata "FSO PRD Commercial Discount" = RIMD,
        tabledata "FSO PRD Order Type" = RIMD,
        tabledata "FSOFINImport Gen Journal Lines" = RIMD,
        tabledata "FSOFINImportGenJnl Conversion" = RIMD,
        tabledata "FSOINSTBEIntrastat Purchase" = RIMD,
        tabledata FSONBCShopPaymentEntries = RIMD,
        tabledata "FSO PUR Brand" = RIMD,
        tabledata "TCOGINGL Intrastat Report Line" = RIMD,
        tabledata "VAT Details" = RIMD,
        tabledata CustomerData = RIMD,
        table "VAT Details" = X,
        table "Azure File Service Setup TEST" = X,
        table "FSO CBE Company" = X,
        table "FSO CBE Establishment" = X,
        table "FSO CBE NACE Activity" = X,
        table "FSO PRD Branch" = X,
        table "FSO PRD Commercial Discount" = X,
        table "FSO PRD Order Type" = X,
        table "FSOFINImport Gen Journal Lines" = X,
        table "FSOFINImportGenJnl Conversion" = X,
        table "FSOINSTBEIntrastat Purchase" = X,
        table FSONBCShopPaymentEntries = X,
        table "FSO PUR Brand" = X,
        table CustomerData = X,
        table "TCOGINGL Intrastat Report Line" = X,
        report FSONBCProcessShopPaymentEnt = X,
        codeunit "Azure File Service" = X,
        codeunit EBSuggestPaymentEvents = X,
        codeunit event2 = X,
        codeunit "FA Neg. Acquisition Management" = X,
        codeunit "FSO PRD Purchase Discount Mgmt" = X,
        codeunit "FSOFIN Dimension Update Mgmt" = X,
        codeunit "FSOFINPayroll File Import" = X,
        codeunit "FSOFINPayroll File Import Mgmt" = X,
        codeunit FSOINSTBEEventSubscriber = X,
        codeunit FSONBCPurchHeaderAPISubscriber = X,
        codeunit FSONBCPurchLineAPISubscriber = X,
        codeunit FSONBCSalesHeaderAPISubscriber = X,
        codeunit Logic = X,
        codeunit TESTVATDISCOUNT = X,
        xmlport "FSO SEPA CT pain.001.001.09" = X,
        page "Azure File Service Setup TEST" = X,
        page "Cust and Vendor Led Entries" = X,
        page DimensionUpdate = X,
        page Enum = X,
        page EnumFilter = X,
        page ErrorCollection = X,
        page "FSO Brand" = X,
        page "FSO Field" = X,
        page "FSO Item Images FactBox" = X,
        page "FSO PRD Branch" = X,
        page "FSO PRD Order Type" = X,
        page "FSO PRD Vendor Brand Discount" = X,
        page "FSOFINImport Gen Jnl Lines" = X,
        page "FSOFINImportGenJnl Conversion" = X,
        page fSOINSTBEIntrastatAPI = X,
        page fSOINSTBEIntrastatPurchList = X,
        page "FSONBC APIV2 - Purch Invoices" = X,
        page "FSONBC APIV2 - Sales Invoices" = X,
        page "FSONBC APIV2 Purch Inv Lines" = X,
        page FSONBCShopPaymentEntries = X,
        page FSONBCVendorUpdate = X,
        page SubratWorksheet = X;
}