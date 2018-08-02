{-----------------------------------------------------------------------------
 Unit Name: uDashGlobal
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDashGlobal;

Interface

Uses EntLicence, uDashTaskDialog, Dialogs;

Const
  glBlueColor = $00FDEADA;
  glBlueColotTo = $00E4AE88;

  glSilverColor = $00ECE2E1;
  glSilverColotTo = $00B39698;

  cMBYESNO = [mbYes, mbNo];
  cMBYESCANCELABORT = [mbYes, mbCancel, mbAbort];
  cMBOK = [mbOK];

  cDialogTitle = 'IRIS Enterprise Software';

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

Implementation

Uses Sysutils, Windows;

Function ShowDashboardDialog(Const pMsg: String; DlgType: TMsgDlgType; Buttons:
  TMsgDlgButtons; Const pUseNormalDialog: Boolean = False): Integer;
Var
  lTaskDialog: TDashTaskDialog;
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
    
    Try
      lTaskDialog := TDashTaskDialog.Create(Nil);
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

End.

