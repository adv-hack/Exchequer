Unit uEMailDLLWizard;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AdvPanel, AdvGlowButton, StdCtrls, Mask, AdvEdit,
  ComCtrls, AdvEdBtn, AdvFileNameEdit, AdvOfficePager, AdvOfficePagerStylers;

Type
  TfrmEmailDllWizard = Class(TForm)
    advPanel: TAdvPanel;
    btnOK: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    Panel1: TPanel;
    Label7: TLabel;
    ofEmailSystem: TAdvOfficePager;
    ofpOutgoing: TAdvOfficePage;
    ofpIncoming: TAdvOfficePage;
    pgStyler: TAdvOfficePagerOfficeStyler;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtOutgoingGuidWiz: TAdvMaskEdit;
    edtOutgoing: TAdvFileNameEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtIncomingGuidWiz: TAdvMaskEdit;
    edtIncoming: TAdvFileNameEdit;
    Procedure btnCancelClick(Sender: TObject);
    Procedure edtOutgoingDialogExit(Sender: TObject; ExitOK: Boolean);
    Procedure btnOKClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  Private
  Public
  End;

Var
  frmEmailDllWizard: TfrmEmailDllWizard;

Implementation

Uses uCommon, udashGlobal;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: btnCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmEmailDllWizard.btnCancelClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: edtOutgoingDialogExit
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmEmailDllWizard.edtOutgoingDialogExit(Sender: TObject;
  ExitOK: Boolean);
Var
  lStr: TStringlist;
Begin
  If ExitOK Then
  Begin
    lStr := TStringlist.Create;
    {load info from a win32 dll}
    Try
      _GetGuidsFromDll((Sender As TAdvFileNameEdit).Text, lStr);
    Except
    End;

    If lStr.Count = 1 Then
    Begin
      {check for just one guid loaded..}
      If lStr.Count = 1 Then
      Begin
        {tag - 0 = outgoing, tag - 1 = incoming}
        If (Sender As TAdvFileNameEdit).Tag = 0 Then
          edtOutgoingGuidWiz.Text := lStr.Text
        Else
          edtIncomingGuidWiz.Text := lStr.Text
      End
    End
    Else
(*      MessageDlg('The Dashboard could not load the information required.' + #13 + #10
        + 'Please contact support for help.', mtError, [mbok], 0);*)
      ShowDashboardDialog('The Dashboard could not load the information required.' + #13 + #10
        + 'Please contact support for help.', mtError, [mbok]);

    lStr.Free;
  End; {If ExitOK Then}
End;

{-----------------------------------------------------------------------------
  Procedure: btnOKClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmEmailDllWizard.btnOKClick(Sender: TObject);
Begin
  If Not _IsValidGuid(edtOutgoingGuidWiz.Text) Then
  Begin
(*    MessageDlg('Invalid GUID information for the outgoing system.' + #13 + #10 +
      'Select a valid DLL or enter the GUID mannualy.', mtError, [mbok], 0);*)
    ShowDashboardDialog('Invalid GUID information for the outgoing system.' + #13 + #10 +
      'Select a valid DLL or enter the GUID mannualy.', mtError, [mbok]);

    Abort;
  End; {if not _IsValidGuid(edtOutgoingGuidWiz.Text) then}

  If Not _IsValidGuid(edtIncomingGuidWiz.Text) Then
  Begin
(*    MessageDlg('Invalid GUID information for the incoming system.' + #13 + #10 +
      'Select a valid DLL or enter the GUID mannualy.', mtError, [mbok], 0);*)
    ShowDashboardDialog('Invalid GUID information for the incoming system.' + #13 + #10 +
      'Select a valid DLL or enter the GUID mannualy.', mtError, [mbok]);

    Abort;
  End; {if not _IsValidGuid(edtIncomingGuidWiz.Text) then}

  ModalResult := mrOK;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmEmailDllWizard.FormCreate(Sender: TObject);
Begin
  ofEmailSystem.ActivePage := ofpOutgoing;
End;

procedure TfrmEmailDllWizard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then
    btnCancelClick(Sender);
end;

End.

