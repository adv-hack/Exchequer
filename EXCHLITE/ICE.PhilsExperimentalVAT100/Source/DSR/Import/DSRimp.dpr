{-----------------------------------------------------------------------------
 Unit Name: DSRimp
 Author:    vmoura
 Purpose:
 History:

 import application for dsr

 this thin application basically loads the files, check them and pass to the
 plug-ins...
-----------------------------------------------------------------------------}
Program DSRimp;

uses
  Forms,
  uCommon,
  Windows,
  uAdoDsr,
  Sysutils,
  uConsts,
  uFrmIMP in 'uFrmIMP.pas' {frmImp},
  uDSRSettings in 'X:\EXCHLITE\ICE\Source\DSR\uDSRSettings.pas',
  uDSRImport in 'X:\EXCHLITE\ICE\Source\DSR\uDSRImport.pas',
  uDSRMail in 'X:\EXCHLITE\ICE\Source\DSR\uDSRMail.pas',
  DSROutgoing_TLB in 'X:\EXCHLITE\ICE\Source\DSR\Outgoing\DSROutgoing_TLB.pas',
  uDSRFileFunc in 'X:\EXCHLITE\ICE\Source\DSR\uDSRFileFunc.pas',
  DSRIncoming_TLB in 'X:\EXCHLITE\ICE\Source\DSR\Incoming\DSRIncoming_TLB.pas',
  uMCM in 'X:\EXCHLITE\ICE\Source\DSR\uMCM.pas' {frmMCM};

{$R *.res}
Var
  fComp,
    fPack,
    fGuid: String;

  lErrorMode: Cardinal;

{-----------------------------------------------------------------------------
  Procedure: CheckMsgStatus
  Author:    vmoura

  last method resource to check the msg status

-----------------------------------------------------------------------------}
Procedure CheckMsgStatus;
Var
  lDb: TADODSR;
Begin
  Try
    lDb := Nil;
    Try
      lDb := TADODSR.Create(_DSRGetDBServer);
    Except
    End;

    If Assigned(lDb) And lDb.Connected Then
    Begin
      Try
        If lDb.Connected Then
        Begin
          _CallDebugLog('check msg status ... change status');
          If lDb.GetInboxMessageStatus(_SafeStringToGuid(fGuid)) = cPROCESSING Then
            lDb.SetInboxMessageStatus(_SafeStringToGuid(fGuid), cFAILED);
        End;
      Finally
        lDb.Free
      End; {try}
    End; {If Assigned(lDb) And lDb.Connected Then}
  Except
  End;
End;

Begin
  lErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS Or SEM_NOOPENFILEERRORBOX Or
    SEM_NOGPFAULTERRORBOX);

  Application.Initialize;

  {check the parameters of the import
  1 must be a company code
  2 the guid of the batch to import
  3 packageId... not in use/future use
  }

  fComp := Trim(ParamStr(1));
  fGuid := Trim(ParamStr(2));
  fPack := Trim(ParamStr(3));

  {check the main parameters
  company
  inbox guid
  package (if necessary)}
  If (fComp <> '') And (fGuid <> '') And (fPack <> '') Then
  Begin
    Try
      uFrmIMP.StartImport(fComp, fGuid, fPack);
    Except
      On e: exception Do
      Begin
        Sleep(100);
        _LogMSG('An exception has occurred while calling StartImport. Error: ' +
          e.message);
      End; {begin}
    End; {try}

    {give another try}
    Try
      CheckMsgStatus;
    Except
    End;
  End
  Else
  Begin
    _LogMSG('Invalid parameters calling import. ' +
      ' Param 1 = ' + fComp +
      ' Param 2 = ' + fGuid +
      ' Param 3 = ' + fPack
      );
  End; {begin}

  Sleep(100);
  _LogMSG('Import application ' + inttostr(Application.Handle) +
    ' is about to finish...');

  SetErrorMode(lErrorMode);
  Application.Terminate;
End.

