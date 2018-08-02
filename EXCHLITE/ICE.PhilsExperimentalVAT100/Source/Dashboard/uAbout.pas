{-----------------------------------------------------------------------------
 Unit Name: uAbout
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uAbout;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvGlowButton, StdCtrls, AdvEdit, ExtCtrls, AdvPanel, AdvMemo,

  ufrmbase
  ;

Type
  //TfrmAbout = Class(TForm)
  TfrmAbout = Class(TfrmBase)
    advPanel: TAdvPanel;
    btnClose: TAdvGlowButton;
    lblVersion: TLabel;
    mmAbout: TMemo;
    lblDSRVersion: TLabel;
    Panel1: TPanel;
    lblInfo: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure btnCloseClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
  Private
  Public
  End;

Var
  frmAbout: TfrmAbout;

Implementation

Uses uConsts, uDashGlobal, uDSR, uDashSettings, uCommon, StrUtil, EntLicence;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAbout.FormCreate(Sender: TObject);
Begin
  Inherited;

  if glProduct In [ptLITECust, ptLITEAcct] Then
    lblVersion.Caption := 'Version: ' + cIAOVERSION + cDASHBUILD
  else
    lblVersion.Caption := 'Version: ' + cEXVERSION + cDASHBUILD;

  lblInfo.Caption := _GetProductName(glProductNameIndex) + ' Information';

  If glISCIS Then
  Begin
    //lblVersion.Caption := 'Version: ' + cDASHVERSION + '/CIS/EXCHEQUER';
    lblVersion.Caption := lblVersion.Caption + '/CIS/EXCHEQUER';
    {remove the iao dashboard info}
    mmAbout.Lines.Delete(0);
  End; {if glISCIS then}

  If glISVAO Then
  Begin
    //lblVersion.Caption := 'Version: ' + cDASHVERSION + '/CIS/IAOO';
    lblVersion.Caption := lblVersion.Caption + '/CIS/IAOO';
    {remove the iao dashboard info}
    If Not glISCIS Then
      mmAbout.Lines.Delete(0);
  End; {if glISVAO then}

  mmAbout.Lines.Add('');
  mmAbout.Lines.Add(GetCopyrightMessage);

  If glDSROnline Then
  Begin
    Try
//      lblDSRVersion.Caption := _GetProductName(glProductNameIndex) + ' Version: ' +
      lblDSRVersion.Caption := 'Service Version: ' +
        TDSR.DSR_Version(_DashboardGetDSRServer, _DashboardGetDSRPort);
    Except
      lblDSRVersion.Caption := 'The information about the service could not loaded...';
    End;
  End
  Else
    lblDSRVersion.Caption := _GetProductName(glProductNameIndex) + ' is Offline.';
End;

{-----------------------------------------------------------------------------
  Procedure: btnCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAbout.btnCloseClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAbout.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    Close;
End;

End.

