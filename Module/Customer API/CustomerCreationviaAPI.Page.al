namespace BCLS.BCLS;

using Microsoft.Foundation.Address;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Setup;

page 54799 "Customer Creation via API"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = CustomerData;
    AnalysisModeEnabled = true;
    InsertAllowed = false;
    layout
    {

        area(content)
        {
            field(EnterpriseNo; this.EnterpriseNo)
            {
                Caption = 'Enterprise Number';
                ApplicationArea = All;
                InstructionalText = 'Enter the Enterprise numbers with format and press Enter to fetch the API result.';
                ToolTip = 'Enter the VAT number to fetch the API result.';
                trigger OnValidate()
                begin
                    this.ProcessEnterpriseNo(this.EnterpriseNo);
                    this.EnterpriseNo := '';
                end;
            }
            repeater(General)
            {
                Caption = 'Lines';

                field("Enterprise No."; Rec."Enterprise No.")
                {
                    Caption = 'Enterprise No.';
                    Editable = false;
                    ToolTip = 'Specifies the Enterprise No.';
                    StyleExpr = this.StyleText;
                    trigger OnDrillDown()
                    var
                        Customer: Record Customer;
                    begin
                        if Rec."Enterprise No." <> '' then begin
                            Customer.SetFilter("Enterprise No.", '*' + Rec."Enterprise No." + '*');
                            if Customer.FindFirst() then
                                Page.Run(Page::"Customer Card", Customer);
                        end;
                    end;
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                    ToolTip = 'Specifies the Name.';
                    StyleExpr = this.StyleText;
                }
                field(Street; Rec.Street)
                {
                    Caption = 'Street';
                    ToolTip = 'Specifies the Street.';
                    StyleExpr = this.StyleText;
                }
                field("Street No"; Rec."Street No")
                {
                    Caption = 'Street No';
                    ToolTip = 'Specifies the Street No.';
                    StyleExpr = this.StyleText;
                }
                field(PostalCode; Rec."Postal Code")
                {
                    Caption = 'Postal Code';
                    ToolTip = 'Specifies the Postal Code.';
                    StyleExpr = this.StyleText;
                }
                field(Box; Rec.Box)
                {
                    Caption = 'Box';
                    ToolTip = 'Specifies the Box.';
                    StyleExpr = this.StyleText;
                }
                field(City; Rec.City)
                {
                    Caption = 'City';
                    ToolTip = 'Specifies the City.';
                    StyleExpr = this.StyleText;
                }
                field(Country; Rec.Country)
                {
                    Caption = 'Country';
                    ToolTip = 'Specifies the Country.';
                    StyleExpr = this.StyleText;
                }
                field(Info; Rec.Info)
                {
                    Caption = 'info';
                    ToolTip = 'Specific Information';
                    StyleExpr = this.StyleText;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Process)
            {
                action("Create All")
                {
                    Caption = 'Create All';
                    Image = NewCustomer;
                    ToolTip = 'Create All Customers from API result.';
                    trigger OnAction()
                    var

                    begin
                        // Process batch creation and get created customer number
                        if this.CBEImporterMgmt.ProcessCustomerBatch(this.CreatedCustomerNo) then begin
                            this.Customer.Get(this.CreatedCustomerNo);
                            if Confirm(PageOpenConfirmationLbl, true, this.CreatedCustomerNo) then
                                Page.Run(Page::"Customer Card", this.Customer);
                        end;
                        CurrPage.Update(false);
                    end;
                }
                action(Create)
                {
                    Caption = 'Create';
                    Image = New;
                    ToolTip = 'Create Customer from selected line.';
                    trigger OnAction()
                    var
                        CustomerData: Record CustomerData;
                    begin
                        if Rec."Enterprise No." <> '' then begin
                            // Process creation for selected line and get created customer number
                            CurrPage.GetRecord(CustomerData);
                            if this.CBEImporterMgmt.TryCreateCustomerFromData(CustomerData, this.Customer, this.CreatedCustomerNo) then begin
                                if Confirm(this.PageOpenConfirmationLbl, true, this.CreatedCustomerNo) then
                                    Page.Run(Page::"Customer Card", this.Customer);
                                CustomerData.Delete();
                                CurrPage.Update(false);
                            end;
                        end;
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(Create_Promoted; Create)
                {
                }
                actionref(CreateAll_Promoted; "Create All")
                {
                }
            }
        }
    }
    local procedure ProcessEnterpriseNo(EnterpriseCode: Text)
    var
        CBEImporterMgt: Codeunit "CBE Importer Mgmt.";
        FilterText: Text;
    begin
        FilterText := CBEImporterMgt.BuildEnterpriseNoFilter(EnterpriseCode);
        CBEImporterMgt.LoadApiResultsFromInput(EnterpriseCode);
        this.Rec.SetFilter("Enterprise No.", FilterText);
        CurrPage.Update(false);
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(this.Style);
        Clear(this.StyleText);
        if Rec.Info <> '' then
            this.Style := true;
        if this.Style then
            this.StyleText := Format(PageStyle::Unfavorable);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Info, '<>%1', '');
        Rec.DeleteAll();
        Rec.SetRange(Info);
        CurrPage.Update(false);
    end;

    var
        Customer: Record Customer;
        CBEImporterMgmt: Codeunit "CBE Importer Mgmt.";
        CreatedCustomerNo: Code[20];
        EnterpriseNo: Text;
        Style: Boolean;
        StyleText: Text;
        PageOpenConfirmationLbl: Label 'Do you want to open customer Card %1', Comment = '%1 is the Customer Number', Locked = true;
}
