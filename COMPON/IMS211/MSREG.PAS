(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msreg;

interface

uses Classes, msSocket, msSMTP, msHTTP, msPOP, msMsg,
{$IFDEF VER140}
  DesignIntf,
  DesignWindows,
  DesignEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF}
  msMsgCls, msaddrpe, msAttPe, msFTP, msNNTP, msVersPe;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Internet Mail Suite', [TmsSimpleListenerSocket, TmsListenerSocket,
    TmsClientSocket, TmsSMTPClient, TmsPOPClient, TmsHTTPClient, TmsMessage,
    TmsNNTPClient, TmsArticle, TmsFTPClient]);
  RegisterPropertyEditor(TypeInfo(TmsAddressList),nil,'',TmsAddressListProperty);
  RegisterPropertyEditor(TypeInfo(TmsAttList),nil,'',TmsAttListProperty);
  RegisterPropertyEditor(TypeInfo(string),TmsSocketBase,'Version',TmsVersionProperty);
  RegisterPropertyEditor(TypeInfo(string),TmsCustomMessage,'Version',TmsVersionProperty);
end;

end.
