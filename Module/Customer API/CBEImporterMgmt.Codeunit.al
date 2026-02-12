namespace BCLS.BCLS;

using Microsoft.Foundation.Address;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Setup;

codeunit 55702 "CBE Importer Mgmt."
{

    internal procedure ImportFromJson(JsonText: Text): Boolean
    var
        CustomerData: Record "CustomerData";
        JsonObj: JsonObject;
        value: JsonToken;
        JsonTokenValue: JsonToken;
        ErrorOccurred: Boolean;
    begin
        ErrorOccurred := false;
        if not JsonObj.ReadFrom(JsonText) then
            exit(false);

        // Navigate to data object if it exists
        if JsonObj.Get(this.DataField(), JsonTokenValue) then
            JsonObj := JsonTokenValue.AsObject();

        // Extract and validate VAT number
        if not JsonObj.Get(this.CbeNumberField(), value) or value.AsValue().IsNull() then
            exit(false);

        if not CustomerData.Get(value.AsValue().AsText()) then begin
            CustomerData.Init();
            CustomerData.Validate("Enterprise No.", CopyStr(value.AsValue().AsText(), 1, MaxStrLen(CustomerData."Enterprise No.")));

            // Extract company name
            if JsonObj.Get(this.DenominationField(), value) and not value.AsValue().IsNull() then
                CustomerData."Name" := CopyStr(value.AsValue().AsText(), 1, MaxStrLen(CustomerData."Name"));

            // Parse address object if present
            if JsonObj.Contains(this.AddressField()) then
                ErrorOccurred := not this.ParseAddressFromJson(JsonObj, CustomerData);

            if not ErrorOccurred then
                CustomerData.Insert(true);
        end;
        exit(not ErrorOccurred);
    end;

    local procedure ParseAddressFromJson(var JsonObj: JsonObject; var CustomerData: Record "CustomerData"): Boolean
    var
        addr: JsonObject;
        value: JsonToken;
    begin
        if not JsonObj.Get(this.AddressField(), value) then
            exit(true);

        addr := value.AsObject();

        // Street
        if addr.Get(this.StreetField(), value) and not value.AsValue().IsNull() then
            CustomerData.Validate("Street", value.AsValue().AsText())
        else
            CustomerData."Street" := '';

        // Street Number
        if addr.Get(this.StreetNumberField(), value) and not value.AsValue().IsNull() then
            CustomerData."Street No" := CopyStr(value.AsValue().AsCode(), 1, MaxStrLen(CustomerData."Street No"))
        else
            CustomerData."Street No" := '';

        // Box
        if addr.Get(this.BoxField(), value) and not value.AsValue().IsNull() then
            CustomerData.Validate("Box", value.AsValue().AsText())
        else
            CustomerData."Box" := '';

        // Postal Code
        if addr.Get(this.PostCodeField(), value) and not value.AsValue().IsNull() then
            CustomerData."Postal Code" := value.AsValue().AsInteger()
        else
            CustomerData."Postal Code" := 0;

        // City
        if addr.Get(this.CityField(), value) and not value.AsValue().IsNull() then
            CustomerData.Validate("City", value.AsValue().AsText())
        else
            CustomerData."City" := '';

        // Country Code
        if addr.Get(this.CountryCodeField(), value) and not value.AsValue().IsNull() then
            CustomerData.Validate("Country", value.AsValue().AsText())
        else
            CustomerData."Country" := '';

        exit(true);
    end;

    internal procedure BuildEnterpriseNoFilter(EnterpriseNo: Text): Text
    var
        FormattedVats: List of [Text];
        i: Integer;
        FilterText: Text;
    begin
        if EnterpriseNo = '' then
            exit('');

        FormattedVats := this.SplitAndFormatEnterpriseNo(EnterpriseNo);
        for i := 1 to FormattedVats.Count() do begin
            if i > 1 then
                FilterText += '|';
            FilterText += FormattedVats.Get(i);
        end;
        exit(FilterText);
    end;

    internal procedure LoadApiResultsFromInput(EnterpriseNo: Text)
    var
        FormattedVats: List of [Text];
        i: Integer;
    begin
        if EnterpriseNo = '' then
            exit;

        FormattedVats := this.SplitAndFormatEnterpriseNo(EnterpriseNo);
        for i := 1 to FormattedVats.Count() do
            this.LoadApiResult(FormattedVats.Get(i));
    end;

    local procedure SplitAndFormatEnterpriseNo(EnterpriseNo: Text): List of [Text]
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Result: List of [Text];
        SplitEnterpriseNo: List of [Text];
        i: Integer;
        element: Text[50];
        formatted: Text;
    begin
        SalesReceivablesSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        SalesReceivablesSetup.SetLoadFields(Separator);
        SalesReceivablesSetup.Get();

        SalesReceivablesSetup.TestField(Separator);

        if StrPos(EnterpriseNo, SalesReceivablesSetup.Separator) <> 0 then
            SplitEnterpriseNo := EnterpriseNo.Split(SalesReceivablesSetup.Separator)
        else
            SplitEnterpriseNo.Add(EnterpriseNo);

        // Format each Enterprise No and add to result if valid
        for i := 1 to SplitEnterpriseNo.Count() do begin
            element := CopyStr(SplitEnterpriseNo.Get(i), 1, MaxStrLen(element));
            if element <> '' then begin
                formatted := this.FormatEnterpriseNo(element);
                if formatted <> '' then
                    Result.Add(formatted);
            end;
        end;
        exit(Result);
    end;

    local procedure LoadApiResult(EnterpriseNo: Text)
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Client: HttpClient;
        Response: HttpResponseMessage;
        ResultText: Text;
        BearerText_Lbl: Label 'Bearer %1', Comment = '%1 for Bearer token in Authorization header';
        ConnectionErrorLbl: Label 'Error connecting to Customer API for Enterprise No. %1. HTTP Status Code: %2', Comment = '%1 is the Enterprise No., %2 is the HTTP Status Code', Locked = true;
    begin
        if EnterpriseNo = '' then
            exit;

        SalesReceivablesSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        SalesReceivablesSetup.SetLoadFields("Cust. API", "Cust. API Token");
        SalesReceivablesSetup.Get();

        SalesReceivablesSetup.TestField("Cust. API");
        SalesReceivablesSetup.TestField("Cust. API Token");

        Client.Clear();
        Client.DefaultRequestHeaders.Add('Authorization', StrSubstNo(BearerText_Lbl, SalesReceivablesSetup."Cust. API Token"));
        Client.DefaultRequestHeaders.Add('Accept', 'application/json');

        if Client.Get(StrSubstNo(SalesReceivablesSetup."Cust. API", EnterpriseNo), Response) then begin
            if Response.IsSuccessStatusCode() then
                Response.Content().ReadAs(ResultText);
            if ResultText <> '' then
                this.ImportFromJson(ResultText);
        end else
            Error(ConnectionErrorLbl, EnterpriseNo, Response.HttpStatusCode());
    end;

    local procedure FormatEnterpriseNo(EnterpriseNo: Text[50]): Text
    begin
        exit(DelChr(EnterpriseNo, '=', DelChr(EnterpriseNo, '=', '0123456789')));
    end;

    local procedure CheckPostCode(CustomerData: Record CustomerData): Code[20]
    var
        PostCode: Record "Post Code";
        Code: Code[20];
        CreatedPostCode: Code[20];
    begin
        code := Format(CustomerData."Postal Code");
        PostCode.SetRange(code, code);
        if PostCode.FindFirst() then
            exit(PostCode.Code)
        else
            if this.CreatePostCode(CustomerData, CreatedPostCode) then
                exit(CreatedPostCode)
    end;

    local procedure CreatePostCode(CustomerData: Record CustomerData; var CreatedPostCode: Code[20]): Boolean
    var
        PostCode: Record "Post Code";
    begin
        PostCode.Init();
        PostCode.Validate(Code, Format(CustomerData."Postal Code"));
        PostCode.Validate(City, CustomerData.City);
        PostCode.Validate("Country/Region Code", CustomerData.Country);
        PostCode.Insert(true);
        CreatedPostCode := PostCode.Code;
        exit(true);
    end;

    internal procedure TryCreateCustomerFromData(CustomerData: Record CustomerData; var Customer: Record Customer; var NewCustomerNo: Code[20]): Boolean
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        CustomerTempl: Record "Customer Templ.";
        CustomerTemplMgt: Codeunit "Customer Templ. Mgt.";
        IsHandled: Boolean;
    begin
        NewCustomerNo := '';
        SalesReceivablesSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        SalesReceivablesSetup.SetLoadFields("Cust. Default Template");
        SalesReceivablesSetup.Get();
        CustomerTempl.Get(SalesReceivablesSetup."Cust. Default Template");
        this.CheckPostCode(CustomerData);
        Clear(Customer);
        if this.CustomerCheck(CustomerData) then
            exit(false);
        if CustomerTemplMgt.CreateCustomerFromTemplate(Customer, IsHandled, CustomerTempl.Code) then begin
            Customer.Validate(Name, CustomerData.Name);
            Customer.Validate(Address, this.AddressCheck(CustomerData));
            Customer.Validate("Post Code", Format(CustomerData."Postal Code"));
            Customer.Validate(City, CopyStr(CustomerData.City, 1, MaxStrLen(Customer.City)));
            Customer.Validate("Country/Region Code", CopyStr(CustomerData.Country, 1, MaxStrLen(Customer."Country/Region Code")));
            Customer.Validate("Enterprise No.", CustomerData."Enterprise No.");
            Customer.Modify(true);
            NewCustomerNo := Customer."No.";
        end;
        exit(true);
    end;

    local procedure CustomerCheck(CustomerData: Record CustomerData): Boolean
    var
        Customer: Record Customer;
        CustomerAlreadyRegisteredLbl: Label 'Customer Already Registered With %1', Comment = '%1 is the Customer Number', Locked = true;
    begin
        Customer.SetCurrentKey("Enterprise No.");
        Customer.ReadIsolation(IsolationLevel::ReadUncommitted);
        Customer.SetLoadFields("Enterprise No.");
        customer.SetRange("Enterprise No.", CustomerData."Enterprise No.");
        if not Customer.IsEmpty() then
            if Customer.FindFirst() then begin
                CustomerData.Info := strsubstNo(CustomerAlreadyRegisteredLbl, Customer."No.");
                CustomerData.Modify(true);
            end;
        exit(not Customer.IsEmpty());
    end;

    local procedure AddressCheck(CustomerData: Record CustomerData): Code[100]
    var
        Address: Text[100];
        AddressCheckLbl: Label 'Address information is incomplete for Enterprise No. %1', Comment = '%1 is the Enterprise No.', Locked = true;
    begin
        Address := Format(CustomerData.Street) + ' ' + Format(CustomerData."Street No") + ' ' + Format(CustomerData.Box);
        if DelChr(Address, '=', ' ') <> '' then
            exit(Address)
        else
            Error(AddressCheckLbl, CustomerData."Enterprise No.");
    end;


    internal procedure ProcessCustomerBatch(var CreatedCustomerNo: Code[20]): Boolean
    var
        Customer: Record Customer;
        ExistingCustomer: Record Customer;
        SourceData: Record CustomerData;
        IsSingle: Boolean;
        NewCustomerNo: Code[20];
        CustomerAlreadyRegisteredLbl: Label 'Customer Already Registered With %1', Comment = '%1 is the Customer Number', Locked = true;
    begin
        if not SourceData.FindSet() then
            exit(false);

        CreatedCustomerNo := '';
        IsSingle := SourceData.Count <= 1;
        repeat
            ExistingCustomer.SetCurrentKey("Enterprise No.");
            ExistingCustomer.SetRange("Enterprise No.", SourceData."Enterprise No.");
            if ExistingCustomer.FindFirst() then begin
                SourceData.Info := StrSubstNo(CustomerAlreadyRegisteredLbl, ExistingCustomer."No.");
                SourceData.Modify(true);
            end else
                if this.TryCreateCustomerFromData(SourceData, Customer, NewCustomerNo) then begin
                    if IsSingle then
                        CreatedCustomerNo := NewCustomerNo;
                    SourceData.Mark(true);
                end;
        until SourceData.Next() = 0;

        SourceData.MarkedOnly(true);
        SourceData.DeleteAll();

        exit(CreatedCustomerNo <> '');
    end;

    local procedure CbeNumberField(): Text
    begin
        exit('cbe_number');
    end;

    local procedure DataField(): Text
    begin
        exit('data');
    end;

    local procedure DenominationField(): Text
    begin
        exit('denomination');
    end;

    local procedure AddressField(): Text
    begin
        exit('address');
    end;

    local procedure StreetField(): Text
    begin
        exit('street');
    end;

    local procedure StreetNumberField(): Text
    begin
        exit('street_number');
    end;

    local procedure BoxField(): Text
    begin
        exit('box');
    end;

    local procedure PostCodeField(): Text
    begin
        exit('post_code');
    end;

    local procedure CityField(): Text
    begin
        exit('city');
    end;

    local procedure CountryCodeField(): Text
    begin
        exit('country_code');
    end;
}