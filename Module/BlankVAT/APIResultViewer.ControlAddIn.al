namespace BlankVAT.CBEImporter;

controladdin "API Result Viewer"
{
    Scripts = 'Module/BlankVAT/apiViewer.js';
    StyleSheets = 'Module/BlankVAT/apiViewer.css';
    StartupScript = 'Module/BlankVAT/apiViewer.js';


    RequestedHeight = 600;
    RequestedWidth = 800;

    event ControlReady();
    procedure SetText(ApiText: Text);
    procedure LoadApiResult(VATNumber: Text);

}
