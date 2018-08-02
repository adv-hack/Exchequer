{-----------------------------------------------------------------------------
 Unit Name: uMCM
 Author:    vmoura
 Purpose:
 History:

 MCM functionality

CompCode is the code of the company to appear in the Multi-Company Manager,
this is a 6-char alphanumeric (uppercase) which must not already exist in the MCM.

  CompName is the name of the company to appear in the Multi-Company Manager

  CompDir is the directory to install the new company dataset into, please note
  that if a dataset already exists in this directory then it will be overwritten.

  hWnd is window handle of the form to receive WM_USER+1 notification messages,
  the following messages are currently implemented:-

    WParam=1  Error in SCD_GenRootLocFiles, check LParam for error number
    WParam=2  Error in SCD_EntCopyMainSecurity, check LParam for error number
    WParam=3  Error in SCD_EntCompanyWizard, check LParam for error number
    WParam=4  Success

-----------------------------------------------------------------------------}
Unit uMCM;

Interface

Uses
  Windows, Messages, SysUtils, {Variants, Classes, Graphics,} Controls, Forms
  ;

Const
  cMCM = 'ICSCOMP.EXE';
  cMCMPARAMS = '/DVDM /CODE="%s" /NAME="%s" /INSTDIR="%s" /HWND="%d"';

  cMCMMESSAGE = WM_USER + 1;
  cCOMPPATH = 'companies';

Type
  TfrmMCM = Class(TForm)
    Procedure FormCreate(Sender: TObject);
  Private
    fCompResult: Longword;
    fError: String;
    Procedure MCMDelay(msecs: Longint);
  Public
    Procedure MCMMESSAGE(Var Message: TMessage); Message cMCMMESSAGE;
  Published
    Property CompResult: Longword Read fCompResult Write fCompResult;
    Property Error: String Read fError Write fError;
  End;

Function CreateExCompany(Const pCompanyName, pCompanyCode: String): Longword;

{var
  frmMCM: TfrmMCM;
}

Implementation

Uses uCommon, uExFunc, uConsts;

{$R *.dfm}

{ TfrmMCM }

{-----------------------------------------------------------------------------
  Procedure: CreateCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function CreateExCompany(Const pCompanyName, pCompanyCode: String): Longword;
Var
  frmMCM: TfrmMCM;
  lCompDir, lExPath,
    lExe: String;
Begin
  { cMCMPARAMS = '/DVDM /CODE="%s" /NAME="%s" /INSTDIR="%s" /HWND="%d"'; }

  {check the company code}
  If Not _CheckExCompCode(pCompanyCode) Then
  Begin
    lExPath := _GetExDataPath;

    {check the company installer}
    If _FileSize(lExPath + cMCM) > 0 Then
    Begin
      {check company license issues}
      If _CheckExCompanyCount Then
      Begin
//        Result := S_OK;
        frmMCM := TfrmMCM.Create(Nil);
        lCompDir := IncludeTrailingPathDelimiter(lExPath) + cCOMPPATH + '\' +
          pCompanyCode;

        lExe := IncludeTrailingPathDelimiter(lExPath) + cMCM + ' ' +
          Format(cMCMPARAMS, [pCompanyCode, pCompanyName, lCompDir,
          frmMcm.Handle]);

        Try
          _fileExec(lExe, True, True);
        {wait for the message from the installer}
          frmMCM.MCMDelay(50000);
          Result := frmMCM.CompResult;

        {give another try in case the form didnt have enouth time to process the message}
          If Result = cEXCHERROR Then
            If _GetExCompanyPath(pCompanyCode) <> '' Then
              Result := S_OK;
        Finally
          FreeAndNil(frmMCM);
        End;
      End {If _CheckExCompanyCount Then}
      Else
        Result := cEXCHCOMPLICEXCEEDED;
    End {If _FileSize(lExPath + cMCM) > 0 Then}
    Else
    Begin
      Result := cFILENOTFOUND;
      _LogMSG('CreateCompany :- MCM does not exist.');
    End;
  End
  Else
    Result := cEXCHCOMPALREADYEXISTS;
End;

{-----------------------------------------------------------------------------
  Procedure: MCMDelay
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMCM.MCMDelay(msecs: Longint);
Var
  targettime: Longint;
  Msg: TMsg;
Begin
  targettime := GetTickCount + msecs;
  While targettime > GetTickCount Do
    If PeekMessage(Msg, 0, 0, 0, PM_REMOVE) Then
    Begin
      If Msg.message = cMCMMESSAGE Then
      Begin
        {transmit the message to the form}
        TranslateMessage(Msg);
        DispatchMessage(Msg);
        Break;
      End; {If Msg.message = cMCMMESSAGE Then}

      TranslateMessage(Msg);
      DispatchMessage(Msg);
    End; {If PeekMessage(Msg, 0, 0, 0, PM_REMOVE) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: MCMMESSAGE
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMCM.MCMMESSAGE(Var Message: TMessage);
Begin
  Case Message.WParam Of
    1..3:
      Begin
        fCompResult := cEXCHERROR;
        fError := 'Error code: ' + inttostr(message.WParam) + '. Error parameter: '
          + inttostr(message.LParam);
      End;
    4:
      Begin
        fCompResult := S_OK;
        fError := '';
      End;
  End; {Case Message.WParam Of}

  Try
    _LogMsg(Format('Creating company params result: WParam=%d, LParam=%d',
      [Message.WParam, Message.LParam]));
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMCM.FormCreate(Sender: TObject);
Begin
  fCompResult := cEXCHERROR;
End;

End.

