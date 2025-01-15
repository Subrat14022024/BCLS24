codeunit 50103 "Azure File Service"

{
    var
        AzureFileServiceSetup: Record "Azure File Service Setup";

    procedure ReadListFromShare(FilePath: Text[2048]; var AFSDirectoryContent: Record "AFS Directory Content")
    var
        AFSFileClient: Codeunit "AFS File Client";
        AFSOptParamater: Codeunit "AFS Optional Parameters";
        AFSOperationResponse: Codeunit "AFS Operation Response";
        StorageAccountAutherization: Codeunit "Storage Service Authorization";
        Metadata: Dictionary of [Text, Text];
    begin
        Clear(AFSFileClient);
        AzureFileServiceSetup.Get();
        AFSOptParamater.Meta('sv', '2022-11-02');
        AFSOptParamater.Meta('ss', 'bfqt');
        AFSOptParamater.Meta('srt', 'sco');
        AFSOptParamater.Meta('sp', 'rwdlacupiytf');
        AFSOptParamater.Meta('se', '2025-01-31T16%3A56%3A43Z');
        AFSOptParamater.Meta('st', '2024-12-09T08%3A56%3A43Z');
        AFSOptParamater.Meta('spr', 'https');
        AFSOptParamater.Meta('sig', 'JTg89JTjGbOg0fGQ1qY4P0R9eGFGCvKgFFYfxgmDEBk%3D');
        AFSOptParamater.Meta('comp', 'list');
        AFSOptParamater.Meta('restype', 'directory');
        AFSFileClient.Initialize(AzureFileServiceSetup."Storage Account", AzureFileServiceSetup."File Share",
        StorageAccountAutherization.UseReadySAS(AzureFileServiceSetup."Sas Token"));
        AFSOperationResponse := AFSFileClient.SetFileMetadata(FilePath, Metadata, AFSOptParamater);
        AFSOperationResponse := AFSFileClient.ListDirectory(FilePath, AFSDirectoryContent);
        if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());
    end;

    procedure ReadFileFromShare(FilePath: Text; var FileText: Text; var FileInstream: InStream)
    var
        AFSFileClient: Codeunit "AFS File Client";
        AFSOperationResponse: Codeunit "AFS Operation Response";
        StorageAccountAutherization: Codeunit "Storage Service Authorization";
    //FileInstream: InStream;
    begin
        Clear(AFSFileClient);
        AzureFileServiceSetup.Get();
        AzureFileServiceSetup.TestField("Storage Account");
        AzureFileServiceSetup.TestField("File Share");
        AzureFileServiceSetup.TestField("Sas Token");

        AFSFileClient.Initialize(AzureFileServiceSetup."Storage Account", AzureFileServiceSetup."File Share",
        StorageAccountAutherization.UseReadySAS(AzureFileServiceSetup."Sas Token"));

        AFSOperationResponse := AFSFileClient.GetFileAsStream(FilePath, FileInstream);
        AFSFileClient.GetFileAsText(FilePath, FileText);
        if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());
    end;

    procedure MoveFileFromShare(FromFilePath: Text; ToFilePath: Text; FileName: Text; FileText: Text)
    var
        AFSFileClient: Codeunit "AFS File Client";
        AFSOperationResponse: Codeunit "AFS Operation Response";
        StorageAccountAutherization: Codeunit "Storage Service Authorization";
        TempBlob: Codeunit "Temp Blob";
        FileInStream: InStream;
        FileOutStream: OutStream;
    begin
        Clear(AFSFileClient);
        FromFilePath := FromFilePath.Replace('\', '/');
        ToFilePath := ToFilePath.Replace('\', '/');
        AzureFileServiceSetup.Get();
        AzureFileServiceSetup.TestField("Storage Account");
        AzureFileServiceSetup.TestField("File Share");
        AzureFileServiceSetup.TestField("Sas Token");

        AFSFileClient.Initialize(AzureFileServiceSetup."Storage Account", AzureFileServiceSetup."File Share",
        StorageAccountAutherization.UseReadySAS(AzureFileServiceSetup."Sas Token"));
        TempBlob.CreateOutStream(FileOutStream);
        FileOutStream.WriteText(FileText);
        TempBlob.CreateInStream(FileInStream);



        WriteFiletoShare(ToFilePath + '\' + FileName, FileInStream);

        AFSOperationResponse := AFSFileClient.DeleteFile(FromFilePath);
        if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());
    end;

    procedure WriteFiletoShare(FilePath: Text; var FileContent: InStream)
    var
        AFSFileClient: Codeunit "AFS File Client";
        AFSOperationResponse: Codeunit "AFS Operation Response";
        StorageAccountAutherization: Codeunit "Storage Service Authorization";
    begin
        AzureFileServiceSetup.Get();
        AzureFileServiceSetup.TestField("Storage Account");
        AzureFileServiceSetup.TestField("File Share");
        AzureFileServiceSetup.TestField("Sas Token");

        AFSFileClient.Initialize(AzureFileServiceSetup."Storage Account", AzureFileServiceSetup."File Share",
        StorageAccountAutherization.UseReadySAS(AzureFileServiceSetup."Sas Token"));

        AFSOperationResponse := AFSFileClient.CreateFile(FilePath, FileContent);
        if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());
        AFSOperationResponse := AFSFileClient.PutFileStream(FilePath, FileContent);
        if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());
    end;

    procedure CountFilesInFolder()
    var
        HttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        ResponseContent: Text;
        //XmlDoc: XmlDocument;
        //XmlNodeList: XmlNodeList;
        //XmlNamespaceManager: XmlNamespaceManager;
        //XmlNode: XmlNode;
        //FileCount: Integer;
        Url: Text;
    begin
        Url := 'https://stbcnonprodwe01.file.core.windows.net/icotest?sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytf&se=2025-01-31T16%3A56%3A43Z&st=2024-12-09T08%3A56%3A43Z&spr=https&sig=JTg89JTjGbOg0fGQ1qY4P0R9eGFGCvKgFFYfxgmDEBk%3D&comp=list&restype=directory';
        HttpClient.Get(Url, HttpResponse);
        if HttpResponse.IsSuccessStatusCode() then begin
            HttpResponse.Content.ReadAs(ResponseContent);
            Message('Response Content: %1', ResponseContent);
            // XmlDoc := XmlDocument.Create();
            // XmlDoc.LoadXml(ResponseContent);
            // XmlNamespaceManager := XmlNamespaceManager.Create(XmlDoc.NameTable);
            // XmlNamespaceManager.AddNamespace('x', 'http://schemas.microsoft.com/ado/2007/08/dataservices');
            // XmlNodeList := XmlDoc.SelectNodes('/EnumerationResults/Entries/File', XmlNamespaceManager);
            // FileCount := XmlNodeList.Count;
            // Message('Number of files in the folder: %1', FileCount);
        end else
            Error('Failed to retrieve files from the folder. Status Code: %1', HttpResponse.HttpStatusCode());
    end;

    procedure CreateGLLines(var FileInStream: InStream; var AFSDirectoryContent: Record "AFS Directory Content" temporary)
    var
        TempCSVBuffer: Record "CSV Buffer" temporary;
        JournalLine: Record "Gen. Journal Line";
        //AFSDirectoryContent: Record "AFS Directory Content";
        AFSFileClient: Codeunit "AFS File Client";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        AFSOperationResponse: Codeunit "AFS Operation Response";
        Authorization: Interface "Storage Service Authorization";
        LineNo: Integer;
        CsvLineNo: Integer;
        CSVAmount: Decimal;
        CSVDate: date;
        //FileInstream: InStream;
        FileText: Text;
    begin
        LineNo += 10000;
        CsvLineNo := 0;

        // Authorization := StorageServiceAuthorization.UseReadySAS('sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupiytf&se=2025-01-31T16:56:43Z&st=2024-12-09T08:56:43Z&spr=https&sig=JTg89JTjGbOg0fGQ1qY4P0R9eGFGCvKgFFYfxgmDEBk%3D&comp=list&restype=directory');
        // AFSFileClient.Initialize('stbcnonprodwe01', 'icotest', Authorization);
        // //AFSOperationResponse := AFSFileClient.GetFileAsStream('icotest', FileInstream);
        // AFSDirectoryContent.Reset();
        // AFSOperationResponse := AFSFileClient.ListDirectory('icotest', AFSDirectoryContent);
        // //AFSFileClient.GetFileAsText('icotest', FileText);
        // if not AFSOperationResponse.IsSuccessful() then
        //     Error(AFSOperationResponse.GetError());


        AFSDirectoryContent.SetRange("Resource Type", AFSDirectoryContent."Resource Type"::File);
        if AFSDirectoryContent.FindSet() then
            repeat
                TempCSVBuffer.LoadDataFromStream(FileInstream, ';');
                if TempCSVBuffer.FindSet() then
                    repeat
                        if CsvLineNo <> TempCSVBuffer."Line No." then begin
                            CsvLineNo := TempCSVBuffer."Line No.";
                            JournalLine.Init();
                            JournalLine."Line No." := LineNo;
                            journalLine.Validate("Journal Template Name", 'GENERAL');
                            JournalLine.Validate("Journal Batch Name", 'TEST');
                            LineNo += 10000;
                        end;
                        case
                            TempCSVBuffer."Field No." of
                            1:
                                begin
                                    JournalLine.Validate("Account Type", JournalLine."Account Type"::"G/L Account");
                                    JournalLine.Validate("Account No.", TempCSVBuffer.Value);
                                end;
                            2:
                                begin
                                    Evaluate(CSVAmount, TempCSVBuffer.value);
                                    JournalLine.Validate(Amount, CSVAmount);
                                end;
                            3:
                                begin
                                    Evaluate(CSVDate, TempCSVBuffer.Value);
                                    JournalLine.Validate("Posting Date", CSVdate);
                                    JournalLine.Insert(true);
                                end;
                        end;
                    until TempCSVBuffer.Next() = 0;
            until AFSDirectoryContent.Next() = 0;
    end;

}
