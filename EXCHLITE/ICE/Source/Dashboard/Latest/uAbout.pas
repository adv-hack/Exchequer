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
  Dialogs, AdvGlowButton, StdCtrls, AdvEdit, ExtCtrls, AdvPanel, AdvMemo;

Type
  TfrmAbout = Class(TForm)
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

Uses uConsts, uDashGlobal, uDSR, uDashSettings, uCommon, StrUtil;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAbout.FormCreate(Sender: TObject);
Begin
  lblVersion.Caption := 'Dashboard Version: ' + cDASHVERSION;
  //lblInfo.Caption := 'Dashboard and Client Sync Information';
  lblInfo.Caption := 'Dashboard and ' + _GetProductName(glProductNameIndex) + ' Information';

  if glISCIS then
  begin
    lblVersion.Caption := 'Dashboard Version: ' + cDASHVERSION + '/CIS/EXCHEQUER';
    {remove the iao dashboard info}
    mmAbout.Lines.Delete(0);
  end; {if glISCIS then}

  if glISVAO then
  begin
    lblVersion.Caption := 'Dashboard Version: ' + cDASHVERSION + '/CIS/IAOO';
    {remove the iao dashboard info}
    if not glISCIS then
      mmAbout.Lines.Delete(0);
  end; {if glISVAO then}

  mmAbout.Lines.Add('');
  mmAbout.Lines.Add(GetCopyrightMessage);

  If glISCIS Then
    lblInfo.Caption := 'Dashboard Information';

  If glDSROnline Then
  Begin
    Try
      lblDSRVersion.Caption := _GetProductName(glProductNameIndex) + ' Version: ' +
          TDSR.DSR_Version(_DashboardGetDSRServer, _DashboardGetDSRPort);
    Except
      lblDSRVersion.Caption := 'The Dashboard could not load the ' + _GetProductName(glProductNameIndex) + ' Version.';
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

