table 50105 "Azure File Service Setup TEST"

{
    Caption = 'Azure File Service Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Storage Account"; Text[250])
        {
            Caption = 'Storage Account';
            DataClassification = CustomerContent;
        }
        field(3; "File Share"; Text[250])
        {
            Caption = 'File Share';
            DataClassification = CustomerContent;

        }

        field(5; "Azure Folder"; Text[250])
        {
            Caption = 'Azure File Folder';
            DataClassification = CustomerContent;
        }
        field(6; "Azure Processed Folder"; Text[250])
        {
            Caption = 'Azure File Processed Folder';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    procedure SetToken(SetTokenValue: Text)
    begin
        if IsolatedStorage.Contains(Sastoken_Lbl, DataScope::Module) then
            IsolatedStorage.Delete(Sastoken_Lbl, DataScope::Module);

        IsolatedStorage.Set(Sastoken_Lbl, SetTokenValue, DataScope::Module);
    end;

    procedure GetToken(): Text
    var
        Token: Text;
    begin
        if IsolatedStorage.Contains(Sastoken_Lbl, DataScope::Module) then
            if IsolatedStorage.Get(Sastoken_Lbl, DataScope::Module, Token) then
                exit(Token)
    end;


    var
        Sastoken_Lbl: Label 'Sas Token', Locked = true;



}
