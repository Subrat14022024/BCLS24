page 50105 "Azure File Service Setup TEST"
{
    ApplicationArea = All;
    Caption = 'Azure File Service Setup';
    PageType = Card;
    SourceTable = "Azure File Service Setup TEST";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Storage Account"; Rec."Storage Account")
                {
                    ToolTip = 'Specifies the value of the Storage Account field.', Comment = '%';
                    Caption = 'Storage Account';
                }
                field("File Share"; Rec."File Share")
                {
                    ToolTip = 'Specifies the value of the File Share field.', Comment = '%';
                    Caption = 'File Share';
                }
                field("Sas Token"; sastoken)
                {
                    ToolTip = 'Specifies the value of the Sas Token field.', Comment = '%';
                    Caption = 'Sas Token';
                    Editable = PageEdit;
                    ExtendedDatatype = Masked;
                    trigger OnValidate()
                    begin
                        Rec.settoken(sastoken);
                    end;


                }
            }
            group(" Folder")
            {
                Caption = 'Azure Folder';

                field("Azure Folder"; Rec."Azure Folder")
                {
                    ToolTip = 'Specifies the value of the Azure Folder field.', Comment = '%';
                    Caption = 'Folder';
                }
                field("Azure Processed Folder"; Rec."Azure Processed Folder")
                {
                    ToolTip = 'Specifies the value of the Azure Processed Folder field.', Comment = '%';
                    Caption = 'Processed Folder';
                }
            }
        }
    }
    actions
    {
        area(Creation)
        {
            action(ReadFiles)
            {
                Caption = 'Read Files';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Cloud;
                ToolTip = 'Read files from azure file share';
                trigger OnAction()
                var
                    AFSDirectoryContent: Record "AFS Directory Content";
                    AFSDirectoryContent1: Record "AFS Directory Content";
                    AzureFileServiceSetup: Record "Azure File Service Setup TEST";
                    AzureFileService: Codeunit "Azure File Service";
                    FileContent: BigText;
                    FileInStream: InStream;
                    msgmoved_Lbl: Label 'File %1 Moved';
                    FileText: Text;
                    AccountNo: Text;
                    AccountNoFound: Boolean;
                    Directoryexist: Boolean;
                    NumberOfBytesRead: Integer;
                    TextRead: Text;
                begin
                    Clear(AccountNoFound);
                    AzureFileServiceSetup.Get();
                    AzureFileServiceSetup.TestField("Storage Account");
                    AzureFileServiceSetup.TestField("File Share");
                    AzureFileServiceSetup.TestField("Azure Folder");
                    AzureFileServiceSetup.TestField("Azure Processed Folder");
                    AFSDirectoryContent.Reset();
                    AzureFileService.ReadListFromShare(AzureFileServiceSetup."Azure Folder", AFSDirectoryContent);
                    AFSDirectoryContent.SetRange("Resource Type", AFSDirectoryContent."Resource Type"::File);
                    if AFSDirectoryContent.FindSet() then
                        repeat
                            Message(AFSDirectoryContent.Name);
                            Clear(FileContent);
                            Clear(Directoryexist);
                            //TempBlob.CreateInStream(FileInStream);
                            AzureFileService.ReadFileFromShare(AFSDirectoryContent."Full Name", FileText, FileInStream);
                            FileContent.AddText(FileText);

                            // If you use read then while written after read will not read anything because already everything in InStream variable is read -- vice versa
                            //FileInStream.Read(TextRead);
                            //Message(TextRead);


                            //Start: Read Each Line one by one
                            while not FileInStream.EOS AND NOT AccountNoFound do begin
                                NumberOfBytesRead := FileInStream.ReadText(TextRead);
                                //Message('%1\Size: %2', TextRead, NumberOfBytesRead);
                                if COPYSTR(TextRead, 1, 1) = '1' then begin //Data Record Old Balance
                                    case COPYSTR(TextRead, 2, 1) of
                                        '0': //Belgian account number
                                            AccountNo := COPYSTR(TextRead, 6, 12);
                                        '1': //foreign account number
                                            AccountNo := COPYSTR(TextRead, 6, 34);
                                        '2': //IBAN of the Belgian account number
                                            AccountNo := COPYSTR(TextRead, 6, 31);
                                        '3': //IBAN of the foreign account number
                                            AccountNo := COPYSTR(TextRead, 6, 34);
                                    end;
                                    AccountNo := DELCHR(AccountNo);//  HS 20190111 WAM14-0108
                                    AccountNoFound := (AccountNo <> '');
                                end;
                                Message(AccountNo);
                            end;
                            //Stop: Read Each Line one by one


                            AzureFileService.CheckListofDirectory(AzureFileServiceSetup."Azure Folder" + '\' + 'IN', AFSDirectoryContent1);
                            if AFSDirectoryContent1.FindSet() then
                                repeat
                                    if AFSDirectoryContent1.Name = 'BE67068235580287' then
                                        Directoryexist := true;
                                until AFSDirectoryContent1.Next() = 0;
                            if not Directoryexist then
                                AzureFileService.createfolder(AzureFileServiceSetup."Azure Folder" + '\' + 'IN' + '\' + 'BE67068235580287');
                            AzureFileService.WriteFiletoShare(AzureFileServiceSetup."Azure Folder" + '\' + 'IN' + '\' + 'BANK', FileInStream);

                            //AzureFileService.CreateGLLines(FileInStream, AFSDirectoryContent);



                            AzureFileService.MoveFileFromShare(AFSDirectoryContent."Full Name", AzureFileServiceSetup."Azure Processed Folder", AFSDirectoryContent.Name, FileText);
                            Message(msgmoved_Lbl, AFSDirectoryContent."Full Name");
                        until AFSDirectoryContent.Next() = 0;
                end;
            }
            action(importfromAzureFileservice)
            {
                Caption = 'Import from Azure File Service';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ImportExcel;
                ToolTip = 'This Action will import the data from Azure File Service';
                trigger OnAction()
                begin
                    Message('HI');
                    //AzureFileService.CreateGLLines();
                end;
            }

            action("Import & Process payroll file")
            {
                Caption = 'Import & Process payroll file';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Cloud;
                ToolTip = 'Import & Process payroll file';
                trigger OnAction()
                var
                    AFSDirectoryContent: Record "AFS Directory Content";
                    AzureFileServiceSetup: Record "Azure File Service Setup TEST";
                    AzureFileService: Codeunit "Azure File Service";
                    FileContent: BigText;
                    FileInStream: InStream;
                    FileText: Text;
                    AccountNoFound: Boolean;
                    Directoryexist: Boolean;
                    TextRead: Text;
                    DocumentNo: Code[20];
                    NoSeriesMgt: Codeunit "No. Series";
                begin
                    Clear(AccountNoFound);
                    AzureFileServiceSetup.Get();
                    AzureFileServiceSetup.TestField("Storage Account");
                    AzureFileServiceSetup.TestField("File Share");

                    AzureFileServiceSetup.TestField("Azure Folder");
                    AzureFileServiceSetup.TestField("Azure Processed Folder");
                    AFSDirectoryContent.Reset();
                    AzureFileService.ReadListFromShare(AzureFileServiceSetup."Azure Folder", AFSDirectoryContent);
                    AFSDirectoryContent.SetRange("Resource Type", AFSDirectoryContent."Resource Type"::File);
                    if AFSDirectoryContent.FindSet() then
                        repeat
                            Message(AFSDirectoryContent.Name);
                            Clear(FileContent);
                            Clear(Directoryexist);
                            AzureFileService.ReadFileFromShare(AFSDirectoryContent."Full Name", FileText, FileInStream);
                            FileContent.AddText(FileText);
                            DocumentNo := NoSeriesMgt.GetNextNo('GJNL-GEN');
                            while not FileInStream.EOS do begin
                                FileInStream.ReadText(TextRead);
                                if AzureFileService.TrimSpaces(CopyStr(TextRead, 1, 9)) = 'BB' then
                                    AzureFileService.CreateandProcessPayrollfiles(TextRead, DocumentNo);
                            end;
                        until AFSDirectoryContent.Next() = 0;
                end;
            }
            action(whatismysastoken)

            {
                Caption = 'what is my token';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Message(sastoken);
                end;

            }
        }

    }
    trigger OnOpenPage()
    begin
        PageEdit := CurrPage.Editable;
        if Rec.IsEmpty then
            Rec.Insert();
    end;

    trigger OnAfterGetRecord()
    begin
        PageEdit := CurrPage.Editable;
        sastoken := Rec.GetToken()
    end;



    var
        sastoken: Text;
        PageEdit: Boolean;

}
