unit lwWorkg;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Mask, TEditVal;

type
  TfrmLicWorkgroup = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Bevel2: TBevel;
    btnNext: TButton;
    btnPrevious: TButton;
    Label10: TLabel;
    edtLicence: TEdit;
    Label1: TLabel;
    lstWGEEngine: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WizMod : SmallInt;
  end;


Procedure LicWiz_WorkGroup (Var   WizForm           : TfrmLicWorkgroup;
                            Var   WizNo, LastWiz    : Byte;
                            Const WizPrev, WizNext  : Byte;
                            Var   Done, Aborted     : Boolean);


implementation

{$R *.DFM}

Uses LicVar;

//-------------------------------------------------------------------------

Procedure LicWiz_WorkGroup (Var   WizForm           : TfrmLicWorkgroup;
                            Var   WizNo, LastWiz    : Byte;
                            Const WizPrev, WizNext  : Byte;
                            Var   Done, Aborted     : Boolean);
Begin { LicWiz_WorkGroup }
  // Only display for Non C/S Install and Upgrade licences
  // MH 12/07/2013: Removed Pervasive dialogs at Martin's request
  If FALSE And (LicenceInfo.licType In [0, 1]) And (LicenceInfo.licEntClSvr = 0) Then Begin
    { Create Form as and when necessary }
    If Not Assigned(WizForm) Then Begin
      WizForm := TfrmLicWorkgroup.Create(Application.MainForm);
    End; { If Not Assigned(WizForm)  }

    { Re-Initialise forms return value }
    WizForm.WizMod := Wiz_Abort;

    { Display Form }
    WizForm.ShowModal;

    { Process return value }
    Case WizForm.WizMod Of
      Wiz_Abort  : Aborted := True;

      Wiz_Prev   : WizNo := WizPrev;

      Wiz_Next   : WizNo := WizNext;
    End; { Case }
  End // If (LicenceInfo.licType In [0, 1]) And (LicenceInfo.licEntClSvr = 0)
  Else Begin
    // Skip past dialog
    LicenceInfo.licPSQLWGEVer := 0;

    If (LastWiz = WizPrev) Then
      WizNo := WizNext
    Else
      WizNo := WizPrev;
  End; { Else }

  LastWiz := Wiz_Workgroup;
End; { LicWiz_WorkGroup }

{----------------------------------------------------------------------------}


procedure TfrmLicWorkgroup.FormCreate(Sender: TObject);
begin
  licInitWin (Self, Wiz_Workgroup);

  { Init local variables }
  WizMod := Wiz_Abort;

  lstWGEEngine.ItemIndex := LicenceInfo.licPSQLWGEVer;
  edtLicence.Text := LicenceInfo.licPSQLLicKey;
end;

procedure TfrmLicWorkgroup.btnPreviousClick(Sender: TObject);
begin
  WizMod := Wiz_Prev;
  Close;
end;

procedure TfrmLicWorkgroup.btnNextClick(Sender: TObject);
Var
  OK      : Boolean;
begin
  { Do validation }
  OK := (lstWGEEngine.ItemIndex >= 0);

  If OK Then Begin
    LicenceInfo.licPSQLWGEVer := lstWGEEngine.ItemIndex;
    If (LicenceInfo.licPSQLWGEVer > 0) Then
      LicenceInfo.licPSQLLicKey := UpperCase(Trim(edtLicence.Text))
    Else
      LicenceInfo.licPSQLLicKey := '';

    OK := (Length(LicenceInfo.licPSQLLicKey) = 24) Or (LicenceInfo.licPSQLWGEVer = 0);

    If OK Then Begin
      WizMod := Wiz_Next;
      Close;
    End { If }
    Else
      ShowMessage ('A valid Licence Key must be specified');
  End { If }
  Else
    ShowMessage ('A valid Workgroup Engine choice must be selected');
end;

procedure TfrmLicWorkgroup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Save positions into ini file }
  licSaveCoords (Self);
end;

procedure TfrmLicWorkgroup.Label10Click(Sender: TObject);
begin
  edtLicence.Text := 'WGE:EFGHIJKLMNOPQRSTUVwx';
end;

end.
