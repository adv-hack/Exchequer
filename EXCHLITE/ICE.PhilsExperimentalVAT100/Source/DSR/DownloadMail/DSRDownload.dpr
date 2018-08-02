{-----------------------------------------------------------------------------
 Unit Name: DSRDownload
 Author:    vmoura
 Purpose:
 History:

 the reason for this application is to avoid the dashboard to hang when calling/receiving
 e-mails where there are thousands attachments. this smal application
 call the unit responsible por receiving the files and also use an inherited
 component for process pop3/smtp and mapi from sentimail
-----------------------------------------------------------------------------}
Program DSRDownload;

uses
  Forms,
  uCommon,
  Windows,
  Sysutils,
  uFrmDownload in 'uFrmDownload.pas' {frmDSRDownload},
  uDSRSettings in 'X:\EXCHLITE\ICE\Source\DSR\uDSRSettings.pas',
  uDSRDownloadEMail in 'X:\EXCHLITE\ICE\Source\DSR\uDSRDownloadEMail.pas';

{$R *.res}

(*function PerformLogon(const pUser, pDomain, pPassword: String): Cardinal;
begin
  if not LogonUser(pChar(pUser), pChar(pDomain), pChar(pPassword),
    LOGON32_LOGON_NETWORK,
    LOGON32_PROVIDER_DEFAULT,
    Result) then
    RaiseLastWin32Error;
end;*)

Var
//  hToken,
  lErrorMode: Cardinal;
Begin
  lErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS Or SEM_NOOPENFILEERRORBOX Or
      SEM_NOGPFAULTERRORBOX);

//  hToken := PerformLogon('abo', 'P002957', 'abo');
//  try
//    ImpersonateLoggedOnUser(hToken);
    try
      Application.Initialize;

      {check if the param being used is a valid guid param}
      If _IsValidGuid(Trim(ParamStr(1))) Then
      Begin
        Try
          uFrmDownload.StartDSRDownload(Trim(ParamStr(1)));
        Except
          On e: exception Do
          Begin
            _LogMSG('An exception has occurred while calling Client Sync Download E-Mail application. Error: ' +
              e.message);
            Application.Terminate;
          End; {begin}
        End; {try}
      End
      Else
        _LogMSG('Invalid parameter starting Client Sync Download Application...');
    finally
     lErrorMode := SetErrorMode(0);
     Application.Terminate;

//      RevertToSelf;
    end;
//  finally
//    CloseHandle(hToken);
//  end;

End.

