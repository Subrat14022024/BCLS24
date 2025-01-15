page 50104 "Azure File Service Setup"
{
    ApplicationArea = All;
    Caption = 'Azure File Service Setup';
    PageType = Card;
    SourceTable = "Azure File Service Setup";
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
                field("Sas Token"; Rec."Sas Token")
                {
                    ToolTip = 'Specifies the value of the Sas Token field.', Comment = '%';
                    Caption = 'Sas Token';
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
                    AzureFileServiceSetup: Record "Azure File Service Setup";
                    AzureFileService: Codeunit "Azure File Service";
                    TempBlob: Codeunit "Temp Blob";
                    FileContent: BigText;
                    FileInStream: InStream;
                    msgmoved_Lbl: Label 'File %1 Moved';
                    FileText: Text;
                    AccountNo: Text;
                    AccountNoFound: Boolean;
                begin
                    Clear(AccountNoFound);
                    AzureFileServiceSetup.Get();
                    AzureFileServiceSetup.TestField("Storage Account");
                    AzureFileServiceSetup.TestField("File Share");
                    AzureFileServiceSetup.TestField("Sas Token");
                    AzureFileServiceSetup.TestField("Azure Folder");
                    AzureFileServiceSetup.TestField("Azure Processed Folder");
                    AFSDirectoryContent.Reset();
                    AzureFileService.ReadListFromShare(AzureFileServiceSetup."Azure Folder", AFSDirectoryContent);
                    AFSDirectoryContent.SetRange("Resource Type", AFSDirectoryContent."Resource Type"::File);
                    if AFSDirectoryContent.FindSet() then
                        repeat
                            Message(AFSDirectoryContent.Name);
                            Clear(FileContent);
                            TempBlob.CreateInStream(FileInStream);
                            AzureFileService.ReadFileFromShare(AFSDirectoryContent."Full Name", FileText, FileInStream);
                            FileContent.AddText(FileText);
                            //AzureFileService.CreateGLLines(FileInStream, AFSDirectoryContent);

                            if COPYSTR(FileText, 1, 1) = '1' then begin //Data Record Old Balance
                                case COPYSTR(FileText, 2, 1) of
                                    '0': //Belgian account number
                                        AccountNo := COPYSTR(FileText, 6, 12);
                                    '1': //foreign account number
                                        AccountNo := COPYSTR(FileText, 6, 34);
                                    '2': //IBAN of the Belgian account number
                                        AccountNo := COPYSTR(FileText, 6, 31);
                                    '3': //IBAN of the foreign account number
                                        AccountNo := COPYSTR(FileText, 6, 34);
                                end;
                                AccountNo := DELCHR(AccountNo);//  HS 20190111 WAM14-0108
                                AccountNoFound := (AccountNo <> '');
                            end;
                            Message(AccountNo);

                            AzureFileService.MoveFileFromShare(AFSDirectoryContent."Full Name", AzureFileServiceSetup."Azure Processed Folder", AFSDirectoryContent.Name, FileText);
                            Message(msgmoved_Lbl, AFSDirectoryContent."Full Name");
                        until AFSDirectoryContent.Next() = 0;
                end;
            }
            action(ReadFileContent)
            {
                Caption = 'Read File content';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Cloud;
                trigger OnAction()
                var
                    //AFSDirectoryContent: Record "AFS Directory Content";
                    //AzureFileServiceSetup: Record "Azure File Service Setup";
                    AzureFileService: Codeunit "Azure File Service";
                //TempBlob: Codeunit "Temp Blob";
                //FileContent: BigText;
                //FileInStream: InStream;
                //msgmovedlbl: Label 'File %1 Moved';
                //FileText: Text;
                begin
                    AzureFileService.CountFilesInFolder()
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
                var
                    AzureFileService: Codeunit "Azure File Service";
                begin
                    Message('HI');
                    //AzureFileService.CreateGLLines();
                end;
            }

        }
    }
}
