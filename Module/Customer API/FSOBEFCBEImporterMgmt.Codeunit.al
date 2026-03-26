namespace FSO_FINBE.CustomerCreation;

using FSOFIN.Communication;
using Microsoft.Foundation.Address;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Setup;
using System.RestClient;
using System.Text;

codeunit 50207 "FSO BEF CBE Importer Mgmt."
{
    internal procedure ImportFromJson(JsonObj: JsonObject): Boolean
    var
        FSOBEFCustomerData: Record "FSO BEF Customer Data";
        value: JsonToken;
        JsonTokenValue: JsonToken;
        ErrorOccurred: Boolean;
    begin
        ErrorOccurred := false;
        //        if not JsonObj.ReadFrom(JsonValue.AsText()) then
        //            exit(false);

        // Navigate to data object if it exists
        if JsonObj.Get(this.DataField(), JsonTokenValue) then
            JsonObj := JsonTokenValue.AsObject();

        // Extract and validate VAT number
        if not JsonObj.Get(this.CbeNumberField(), value) or value.AsValue().IsNull() then
            exit(false);

        if not FSOBEFCustomerData.Get(value.AsValue().AsText()) then begin
            FSOBEFCustomerData.Init();
            FSOBEFCustomerData.Validate("Enterprise No.", CopyStr(value.AsValue().AsText(), 1, MaxStrLen(FSOBEFCustomerData."Enterprise No.")));

            // Extract company name
            if JsonObj.Get(this.DenominationField(), value) and not value.AsValue().IsNull() then
                FSOBEFCustomerData."Name" := CopyStr(value.AsValue().AsText(), 1, MaxStrLen(FSOBEFCustomerData."Name"));

            if JsonObj.Get(this.TypeField(), value) and not value.AsValue().IsNull() then
                FSOBEFCustomerData.Type := CopyStr(value.AsValue().AsText(), 1, MaxStrLen(FSOBEFCustomerData.Type));

            // Parse address object if present
            if JsonObj.Contains(this.AddressField()) then
                ErrorOccurred := not this.ParseAddressFromJson(JsonObj, FSOBEFCustomerData);

            if not ErrorOccurred then
                FSOBEFCustomerData.Insert(true);
        end;
        exit(not ErrorOccurred);
    end;

    local procedure ParseAddressFromJson(var JsonObj: JsonObject; var FSOBEFCustomerData: Record "FSO BEF Customer Data"): Boolean
    var
        addr: JsonObject;
        value: JsonToken;
    begin
        if not JsonObj.Get(this.AddressField(), value) then
            exit(true);

        addr := value.AsObject();

        // Street
        if addr.Get(this.StreetField(), value) and not value.AsValue().IsNull() then
            FSOBEFCustomerData.Validate("Street", value.AsValue().AsText())
        else
            FSOBEFCustomerData."Street" := '';

        // Street Number
        if addr.Get(this.StreetNumberField(), value) and not value.AsValue().IsNull() then
            FSOBEFCustomerData."Street No" := CopyStr(value.AsValue().AsCode(), 1, MaxStrLen(FSOBEFCustomerData."Street No"))
        else
            FSOBEFCustomerData."Street No" := '';

        // Box
        if addr.Get(this.BoxField(), value) and not value.AsValue().IsNull() then
            FSOBEFCustomerData.Validate("Box", value.AsValue().AsText())
        else
            FSOBEFCustomerData."Box" := '';

        // Postal Code
        if addr.Get(this.PostCodeField(), value) and not value.AsValue().IsNull() then
            FSOBEFCustomerData.Validate("Postal Code", value.AsValue().AsCode())
        else
            FSOBEFCustomerData."Postal Code" := '';

        // City
        if addr.Get(this.CityField(), value) and not value.AsValue().IsNull() then
            FSOBEFCustomerData.Validate("City", value.AsValue().AsText())
        else
            FSOBEFCustomerData."City" := '';

        // Country Code
        if addr.Get(this.CountryCodeField(), value) and not value.AsValue().IsNull() then
            FSOBEFCustomerData.Validate("Country", value.AsValue().AsText())
        else
            FSOBEFCustomerData."Country" := '';

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
            this.LoadApiResult1(FormattedVats.Get(i));
    end;

    local procedure SplitAndFormatEnterpriseNo(EnterpriseNo: Text): List of [Text]
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Result: List of [Text];
        SplitEnterpriseNo: List of [Text];
        i: Integer;
        Element: Text[50];
        Formatted: Text;
    begin
        SalesReceivablesSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        SalesReceivablesSetup.SetLoadFields("FSO BEF Separator");
        SalesReceivablesSetup.Get();

        SalesReceivablesSetup.TestField("FSO BEF Separator");

        if StrPos(EnterpriseNo, SalesReceivablesSetup."FSO BEF Separator") <> 0 then
            SplitEnterpriseNo := EnterpriseNo.Split(SalesReceivablesSetup."FSO BEF Separator")
        else
            SplitEnterpriseNo.Add(EnterpriseNo);

        // Format each Enterprise No and add to result if valid
        for i := 1 to SplitEnterpriseNo.Count() do begin
            Element := CopyStr(SplitEnterpriseNo.Get(i), 1, MaxStrLen(Element));
            if Element <> '' then begin
                Formatted := this.FormatEnterpriseNo(Element);
                if Formatted <> '' then
                    Result.Add(Formatted);
            end;
        end;
        exit(Result);
    end;

    // local procedure LoadApiResult(EnterpriseNo: Text)
    // var
    //     SalesReceivablesSetup: Record "Sales & Receivables Setup";
    //     Client: HttpClient;
    //     Response: HttpResponseMessage;
    //     ResultText: Text;
    //     BearerText_Lbl: Label 'Bearer %1', Comment = '%1 for Bearer token in Authorization header';
    //     ConnectionErrorLbl: Label 'Error connecting to Customer API for Enterprise No. %1. HTTP Status Code: %2', Comment = '%1 is the Enterprise No., %2 is the HTTP Status Code', Locked = true;
    // begin
    //     if EnterpriseNo = '' then
    //         exit;

    //     SalesReceivablesSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
    //     SalesReceivablesSetup.SetLoadFields("FSO BEF Cust. API", "FSO BEF Cust. API Token");
    //     SalesReceivablesSetup.Get();

    //     SalesReceivablesSetup.TestField("FSO BEF Cust. API");
    //     SalesReceivablesSetup.TestField("FSO BEF Cust. API Token");

    //     Client.Clear();
    //     Client.DefaultRequestHeaders.Add('Authorization', StrSubstNo(BearerText_Lbl, SalesReceivablesSetup."FSO BEF Cust. API Token"));
    //     Client.DefaultRequestHeaders.Add('Accept', 'application/json');

    //     if Client.Get(StrSubstNo(SalesReceivablesSetup."FSO BEF Cust. API", EnterpriseNo), Response) then begin
    //         if Response.IsSuccessStatusCode() then
    //             Response.Content().ReadAs(ResultText);
    //         if ResultText <> '' then
    //             this.ImportFromJson(ResultText);
    //     end else
    //         Error(ConnectionErrorLbl, EnterpriseNo, Response.HttpStatusCode());
    // end;

    local procedure LoadApiResult1(EnterpriseNo: Text)
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        HttpContent: Codeunit "Http Content";
        BearerText_Lbl: Label 'Bearer %1', Comment = '%1 for Bearer token in Authorization header';
    begin
        if EnterpriseNo = '' then
            exit;

        SalesReceivablesSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        SalesReceivablesSetup.SetLoadFields("FSO BEF Cust. API", "FSO BEF Cust. API Token");
        SalesReceivablesSetup.Get();

        SalesReceivablesSetup.TestField("FSO BEF Cust. API");
        SalesReceivablesSetup.TestField("FSO BEF Cust. API Token");

        this.InitializeRestClient();
        this.RestClient.SetDefaultRequestHeader('Accept', 'application/json');
        this.RestClient.SetDefaultRequestHeader('Authorization', StrSubstNo(BearerText_Lbl, SalesReceivablesSetup."FSO BEF Cust. API Token"));
        this.ImportFromJson(this.GetValueFromAPI(this.RestClient.Send("Http Method"::Get, StrSubstNo(SalesReceivablesSetup."FSO BEF Cust. API", EnterpriseNo), HttpContent).GetContent()));
    end;

    internal procedure GetValueFromAPI(HttpContent: Codeunit "Http Content"): JsonObject
    var
        ResultObj, ErrorObj : JsonObject;
        ResultField: JsonToken;
        APIErr: Label 'API call failed: %1', Comment = '%1 is the error message';
    begin
        ResultObj := HttpContent.AsJson().AsObject();

        if ResultObj.Get('error', ResultField) then begin
            ErrorObj := ResultField.AsObject();
            ErrorObj.Get('message', ResultField);
            Error(APIErr, ResultField.AsValue().AsText());
        end;

        if ResultObj.Get('data', ResultField) then
            exit(ResultField.AsObject())
    end;

    internal procedure InitializeRestClient()
    var
        FSOFINHttpClientHandler: Codeunit "FSO FIN Http Client Handler";
    begin
        Clear(this.RestClient);
        this.RestClient.Initialize(FSOFINHttpClientHandler);
    end;

    local procedure FormatEnterpriseNo(EnterpriseNo: Text[50]): Text
    begin
        exit(DelChr(EnterpriseNo, '=', DelChr(EnterpriseNo, '=', '0123456789')));
    end;

    local procedure CheckPostCode(FSOBEFCustomerData: Record "FSO BEF Customer Data"): Code[20]
    var
        PostCode: Record "Post Code";
        CreatedPostCode: Code[20];
    begin
        if FSOBEFCustomerData.Country <> '' then
            PostCode.SetRange("Country/Region Code", FSOBEFCustomerData.Country);
        PostCode.SetFilter(code, '*' + FSOBEFCustomerData."Postal Code" + '*');
        PostCode.ReadIsolation(IsolationLevel::ReadUncommitted);
        PostCode.SetLoadFields(Code);
        if PostCode.FindFirst() then
            exit(PostCode.Code)
        else
            if this.CreatePostCode(FSOBEFCustomerData, CreatedPostCode) then
                exit(CreatedPostCode)
    end;

    local procedure CreatePostCode(FSOBEFCustomerData: Record "FSO BEF Customer Data"; var CreatedPostCode: Code[20]): Boolean
    var
        PostCode: Record "Post Code";
    begin
        PostCode.Init();
        PostCode.Validate(Code, Format(FSOBEFCustomerData."Postal Code"));
        PostCode.Validate(City, FSOBEFCustomerData.City);
        PostCode.Validate("Country/Region Code", FSOBEFCustomerData.Country);
        PostCode.Insert(true);
        CreatedPostCode := PostCode.Code;
        exit(true);
    end;

    internal procedure TryCreateCustomerFromData(FSOBEFCustomerData: Record "FSO BEF Customer Data"; var Customer: Record Customer; var NewCustomerNo: Code[20]): Boolean
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        CustomerTempl: Record "Customer Templ.";
        CustomerTemplMgt: Codeunit "Customer Templ. Mgt.";
        IsHandled: Boolean;
    begin
        Clear(Customer);
        if this.CustomerCheck(FSOBEFCustomerData) then
            exit(false);
        if not this.AddressCheck(FSOBEFCustomerData) then
            exit(false);

        NewCustomerNo := '';
        SalesReceivablesSetup.ReadIsolation(IsolationLevel::ReadUncommitted);
        SalesReceivablesSetup.SetLoadFields("FSO BEF Cust. Default Template");
        SalesReceivablesSetup.Get();
        CustomerTempl.Get(SalesReceivablesSetup."FSO BEF Cust. Default Template");

        if CustomerTemplMgt.CreateCustomerFromTemplate(Customer, IsHandled, CustomerTempl.Code) then begin
            Customer.Validate(Name, FSOBEFCustomerData.Name);
            Customer.Validate(Address, CopyStr(this.GetCustomerFullAddress(FSOBEFCustomerData), 1, MaxStrLen(Customer.Address)));
            Customer.Validate("Post Code", this.CheckPostCode(FSOBEFCustomerData));
            Customer.Validate(City, CopyStr(FSOBEFCustomerData.City, 1, MaxStrLen(Customer.City)));
            Customer.Validate("Country/Region Code", CopyStr(FSOBEFCustomerData.Country, 1, MaxStrLen(Customer."Country/Region Code")));
            Customer.Validate("Enterprise No.", FSOBEFCustomerData."Enterprise No.");
            if FSOBEFCustomerData.Type <> '' then
                if FSOBEFCustomerData.Type = this.TypeLegalPerson() then
                    Customer.Validate("Copy Sell-to Addr. to Qte From", Customer."Copy Sell-to Addr. to Qte From"::Company)
                else
                    if FSOBEFCustomerData.Type = this.TypeNaturalPerson() then
                        Customer.Validate("Copy Sell-to Addr. to Qte From", Customer."Copy Sell-to Addr. to Qte From"::Person);
            Customer.Modify(true);
            NewCustomerNo := Customer."No.";
        end;
        exit(true);
    end;

    local procedure CustomerCheck(FSOBEFCustomerData: Record "FSO BEF Customer Data"): Boolean
    var
        Customer: Record Customer;
        CustomerAlreadyRegisteredLbl: Label 'Customer Already Registered With %1', Comment = '%1 is the Customer Number', Locked = true;
    begin
        Customer.SetCurrentKey("Enterprise No.");
        Customer.ReadIsolation(IsolationLevel::ReadUncommitted);
        Customer.SetLoadFields("Enterprise No.");
        Customer.SetFilter("Enterprise No.", '*' + FSOBEFCustomerData."Enterprise No." + '*');
        if Customer.FindFirst() then begin
            FSOBEFCustomerData.Info := strsubstNo(CustomerAlreadyRegisteredLbl, Customer."No.");
            FSOBEFCustomerData.Modify(true);
        end;
        exit(not Customer.IsEmpty());
    end;

    local procedure AddressCheck(FSOBEFCustomerData: Record "FSO BEF Customer Data"): Boolean
    var
        Address: Text;
        AddressCheckLbl: Label 'Address information is incomplete for Enterprise No. %1', Comment = '%1 is the Enterprise No.', Locked = true;
    begin
        Address := Format(FSOBEFCustomerData.Street) + Format(FSOBEFCustomerData."Street No") + Format(FSOBEFCustomerData.Box);
        if DelChr(Address, '=', ' ') <> '' then
            exit(true)
        else begin
            FSOBEFCustomerData.Info := strsubstNo(AddressCheckLbl, FSOBEFCustomerData."Enterprise No.");
            FSOBEFCustomerData.Modify(true);
        end;
        exit(false);
    end;

    local procedure GetCustomerFullAddress(FSOBEFCustomerData: Record "FSO BEF Customer Data"): Text
    var
    begin
        exit(Format(FSOBEFCustomerData.Street) + ' ' +
            Format(FSOBEFCustomerData."Street No") + ' ' +
            Format(FSOBEFCustomerData.Box));
    end;

    internal procedure ProcessCustomerBatch(var CreatedCustomerNo: Code[20]): Boolean
    var
        Customer: Record Customer;
        ExistingCustomer: Record Customer;
        FSOBEFCustomerData: Record "FSO BEF Customer Data";
        IsSingle: Boolean;
        NewCustomerNo: Code[20];
        CustomerAlreadyRegisteredLbl: Label 'Customer Already Registered With %1', Comment = '%1 is the Customer Number', Locked = true;
    begin
        if not FSOBEFCustomerData.FindSet() then
            exit(false);

        CreatedCustomerNo := '';
        IsSingle := FSOBEFCustomerData.Count <= 1;
        repeat
            ExistingCustomer.SetCurrentKey("Enterprise No.");
            ExistingCustomer.SetRange("Enterprise No.", FSOBEFCustomerData."Enterprise No.");
            if ExistingCustomer.FindFirst() then begin
                FSOBEFCustomerData.Info := StrSubstNo(CustomerAlreadyRegisteredLbl, ExistingCustomer."No.");
                FSOBEFCustomerData.Modify(true);
            end else
                if this.TryCreateCustomerFromData(FSOBEFCustomerData, Customer, NewCustomerNo) then begin
                    if IsSingle then
                        CreatedCustomerNo := NewCustomerNo;
                    FSOBEFCustomerData.Mark(true);
                end;
        until FSOBEFCustomerData.Next() = 0;

        FSOBEFCustomerData.MarkedOnly(true);
        FSOBEFCustomerData.DeleteAll();

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

    local procedure TypeField(): Text
    begin
        exit('type');
    end;

    local procedure TypeNaturalPerson(): Text
    begin
        exit('natural_person');
    end;

    local procedure TypeLegalPerson(): Text
    begin
        exit('legal_person');
    end;

    var
        RestClient: Codeunit "Rest Client";

}
