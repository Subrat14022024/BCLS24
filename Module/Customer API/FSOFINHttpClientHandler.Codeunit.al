namespace FSOFIN.Communication;

using System.RestClient;

// This makes sure that the calls are sent from FSO FIN application, instead of Microsoft System application.
// Before using the RestClient codeunit, call the RestClient.Initialize() procedure with this codeunit as a parameter.
codeunit 50153 "FSO FIN Http Client Handler" implements "Http Client Handler"
{
    procedure Send(
        HttpClient: HttpClient;
        HttpRequestMessage: Codeunit "Http Request Message";
        var HttpResponseMessage: Codeunit "Http Response Message") Success: Boolean
    var
        ResponseMessage: HttpResponseMessage;
    begin
        Success := HttpClient.Send(HttpRequestMessage.GetHttpRequestMessage(), ResponseMessage);
        HttpResponseMessage.SetResponseMessage(ResponseMessage);
    end;
}