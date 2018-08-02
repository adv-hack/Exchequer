{-----------------------------------------------------------------------------
 Unit Name: uDashGlobal
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDashGlobal;

Interface

Uses EntLicence, Dialogs
;

Const
  glBlueColor = $00FDEADA;
  glBlueColotTo = $00E4AE88;

  glSilverColor = $00ECE2E1;
  glSilverColotTo = $00B39698;

  cMBYESNO = [mbYes, mbNo];
  cMBYESCANCELABORT = [mbYes, mbCancel, mbAbort];
  cMBOK = [mbOK];

  cDialogTitle = 'Advanced Enterprise Software';

Var
  glProduct: TelProductType;
  glUser: Integer;
  glUserLogin: String;
  glDSROnline: Boolean;
  glISVAO,
    glISCIS: Boolean;
  glProductNameIndex: Integer;

  glDashLoading: Boolean;

Function ShowDashboardDialog(Const pMsg: String; DlgType: TMsgDlgType; Buttons:
  TMsgDlgButtons; Const pUseNormalDialog: Boolean = False): Integer;

Procedure CheckCIS(const pServer: String);

Implementation

Uses Sysutils, Windows, uAdoDSR, uDashSettings, uConsts,

  {TMS taskdialog component}
  TaskDialog, TaskDialogEX


;


Function ShowDashboardDialog(Const pMsg: String; DlgType: TMsgDlgType; Buttons:
  TMsgDlgButtons; Const pUseNormalDialog: Boolean = False): Integer;
Var
  lTaskDialog: TAdvTaskDialogEX; //TDashTaskDialog;
Begin
  {
  buttons
  (cbOK, cbYes, cbNo, cbCancel, cbRetry, cbClose)

  icons
  TTaskDialogIcon = (tiBlank, tiWarning, tiQuestion, tiError, tiInformation,tiNotUsed,tiShield);
  }

  If pUseNormalDialog Then
    Result := MessageDlg(pMsg, DlgType, Buttons, 0)
  Else
  Begin

    {create altenative TADVTaskdialogex}
    Try
      lTaskDialog := TAdvTaskDialogEX.Create(Nil);
    Except
    End;

    If Assigned(lTaskDialog) Then
    Begin

      With lTaskDialog Do
      Begin
        If Buttons = cMBYESNO Then
        Begin
          lTaskDialog.Icon := tiQuestion;
          CommonButtons := [cbYes, cbNo]
        End
        Else
        Begin
          Case DlgType Of
            mtInformation: ICon := tiInformation;
            mtError: iCon := tiError;
            mtWarning: iCon := tiWarning;
          Else
            Icon := tiNotUsed;
          End;

          CommonButtons := [cbOK];
        End;

        Title := cDialogTitle;
        Content := pMsg;

        Result := Execute;
      End; {with lTaskDialog do}

      FreeAndNil(lTaskDialog);
    End
    Else
      Result := MessageDlg(pMsg, DlgType, Buttons, 0);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: CheckCIS
  Author:    vmoura

  quick check if cis is installed
-----------------------------------------------------------------------------}
Procedure CheckCIS(const pServer: String);
Var
  lDb: TADODSR;
Begin
  lDB := nil;
  Try                     
    lDb := TADODSR.Create(pServer);
  Except
  End;

  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
    Begin
      // some applications need it forced!
      {$IFDEF ISCIS}
      glISCIS := True;
      {$else}
      glISCIS := lDb.GetSystemValue(cISCISPARAM) = '1';
      {$ENDIF}
      
      If glISCIS Then
        glProductNameIndex := cCISNAME
      Else
        glProductNameIndex := cCLIENTLINKNAME;
    End; {If lDb.Connected Then}

    lDb.Free;
  End; {If Assigned(lDb) Then}
End;

End.

