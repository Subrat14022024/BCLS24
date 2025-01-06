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
        SasToken: SecretText;
    begin
        AzureFileServiceSetup.Get();
        SasToken := AzureFileServiceSetup."Sas Token";
        AzureFileServiceSetup.TestField("Storage Account");
        AzureFileServiceSetup.TestField("File Share");
        AzureFileServiceSetup.TestField("Sas Token");
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
        StorageAccountAutherization.CreateSharedKey(SasToken));
        AFSOperationResponse := AFSFileClient.SetFileMetadata(FilePath, Metadata, AFSOptParamater);
        AFSOperationResponse := AFSFileClient.ListDirectory(FilePath, AFSDirectoryContent);
        if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());
    end;

    procedure ReadFileFromShare(FilePath: Text; var FileText: Text)
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
        StorageAccountAutherization.CreateSharedKey(AzureFileServiceSetup."Sas Token"));

        //AFSOperationResponse := AFSFileClient.GetFileAsStream(FilePath,FileInstream); 
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
        FromFilePath := FromFilePath.Replace('\', '/');
        ToFilePath := ToFilePath.Replace('\', '/');
        AzureFileServiceSetup.Get();
        AzureFileServiceSetup.TestField("Storage Account");
        AzureFileServiceSetup.TestField("File Share");
        AzureFileServiceSetup.TestField("Sas Token");

        AFSFileClient.Initialize(AzureFileServiceSetup."Storage Account", AzureFileServiceSetup."File Share",
        StorageAccountAutherization.CreateSharedKey(AzureFileServiceSetup."Sas Token"));
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
        StorageAccountAutherization.CreateSharedKey(AzureFileServiceSetup."Sas Token"));

        AFSOperationResponse := AFSFileClient.CreateFile(FilePath, FileContent);
        if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());
        AFSOperationResponse := AFSFileClient.PutFileStream(FilePath, FileContent);
        if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());
    end;


}
