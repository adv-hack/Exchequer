unit ZSysFunc;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Controls, Windows, Forms, Enterprise_TLB, CustAbsU;

type
  TCOMSysFunc = class(TAutoIntfObject, ICOMSysFunc)
  private
  protected
    function  entMessageDlg(DialogType: TEntMsgDlgType; const Message: WideString; Buttons: Integer): TentMsgDlgReturn; safecall;
    function  Get_hWnd: Integer; safecall;
    procedure entActivateClient(hWnd: Integer); safecall;
  public
    Constructor Create;
  End; { TCOMSysFunc }

implementation

uses ComServ, GlobVar, VarConst;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMSysFunc.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMSysFunc);

End; { Create }

{-----------------------------------------}

function TCOMSysFunc.entMessageDlg(      DialogType : TEntMsgDlgType;
                                   const Message    : WideString;
                                         Buttons    : Integer): TentMsgDlgReturn;

Var
  BtnSet : TMsgDlgButtons;
  Res    : Word;
Begin
  BtnSet := [];
  If ((Buttons And embYes) = embYes) Then BtnSet := BtnSet + [mbYes];
  If ((Buttons And embNo) = embNo) Then BtnSet := BtnSet + [mbNo];
  If ((Buttons And embOK) = embOK) Then BtnSet := BtnSet + [mbOK];
  If ((Buttons And embCancel) = embCancel) Then BtnSet := BtnSet + [mbCancel];
  If ((Buttons And embAbort) = embAbort) Then BtnSet := BtnSet + [mbAbort];
  If ((Buttons And embRetry) = embRetry) Then BtnSet := BtnSet + [mbRetry];
  If ((Buttons And embIgnore) = embIgnore) Then BtnSet := BtnSet + [mbIgnore];
  If ((Buttons And embAll) = embAll) Then BtnSet := BtnSet + [mbAll];
  If ((Buttons And embNoToAll) = embNoToAll) Then BtnSet := BtnSet + [mbNoToAll];
  If ((Buttons And embYesToAll) = embYesToAll) Then BtnSet := BtnSet + [mbYesToAll];
  If ((Buttons And embHelp) = embHelp) Then BtnSet := BtnSet + [mbHelp];

  Res := MessageDlg (Message, TMsgDlgType(DialogType), BtnSet, 0);

  Case Res Of
    mrNone     : Result := emrNone;
    mrOk       : Result := emrOk;
    mrCancel   : Result := emrCancel;
    mrAbort    : Result := emrAbort;
    mrRetry    : Result := emrRetry;
    mrIgnore   : Result := emrIgnore;
    mrYes      : Result := emrYes;
    mrNo       : Result := emrNo;
    mrAll      : Result := emrAll;
    mrNoToAll  : Result := emrNoToAll;
    mrYesToAll : Result := emrYesToAll;
  Else
    Result := emrNone;
  End; { Case }
End;

{-----------------------------------------}

procedure TCOMSysFunc.entActivateClient(hWnd: Integer);
Begin
  SetForegroundWindow (hWnd);
End;

{-----------------------------------------}

function TCOMSysFunc.Get_hWnd: Integer;
Begin
  Result := Application.MainForm.Handle;
End;

end.

