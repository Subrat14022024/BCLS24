namespace FINBC.FINBC;

using Microsoft.Finance.GeneralLedger.Setup;

pageextension 50129 GlCodaExt extends "General Ledger Setup"
{
    layout
    {

        addlast(content)
        {
            group(CODA)
            {
                field("CODA Import Folder"; Rec."CODA Import Folder")
                {
                    ApplicationArea = All;
                    Caption = 'CODA Import Folder';
                    ToolTip = 'Specify the path for Import';
                }
                field("CODA Archive Folder"; Rec."CODA Archive Folder")
                {
                    ApplicationArea = All;
                    Caption = 'CODA Archive Folder';
                    ToolTip = 'Specify the path for Archive';
                }
                field("CODA ERROR Folder"; Rec."CODA ERROR Folder")
                {
                    ApplicationArea = All;
                    Caption = 'CODA ERROR Folder';
                    ToolTip = 'Specify the path for Error';
                }
                field("File Share Name"; Rec."File Share Name")
                {
                    ApplicationArea = All;
                    Caption = 'File Share Name';
                    ToolTip = 'Specify the name of file share';
                }

            }
        }
    }
}
