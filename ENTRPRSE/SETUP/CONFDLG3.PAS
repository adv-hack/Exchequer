unit Confdlg3;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, FileCtrl;

type
  TConfigDlg3 = class(TForm)
    HelpBtn: TButton;
    Panel1: TPanel;
    Bevel1: TBevel;
    ExitBtn: TButton;
    BackBtn: TButton;
    NextBtn: TButton;
    TitleLbl: TLabel;
    InstrLbl: TLabel;
    Image1: TImage;
    DeductBOM: TCheckBox;
    ExchCcyRate: TCheckBox;
    DeductStk: TCheckBox;
    SetCost: TCheckBox;
    MultiCcy: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    DefCcy: TEdit;
    UpdStkLev: TCheckBox;
    procedure HelpBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DefCcyKeyPress(Sender: TObject; var Key: Char);
    procedure MultiCcyClick(Sender: TObject);
    procedure DeductBOMClick(Sender: TObject);
  private
    { Private declarations }
    FExitCode : Char;
    Function  GotMCFile : Boolean;
  protected
    Function  ValidOk(VCode : Char) : Boolean; Virtual;
  public
    { Public declarations }
    Install : Boolean;
    Property ExitCode : Char read FExitCode write FExitCode;

    procedure DispRec;
  end;

implementation

{$R *.DFM}

Uses SetupU, VarCnst3;

{ Initialise local variables }
procedure TConfigDlg3.FormCreate(Sender: TObject);
begin
  Caption := 'Exchequer Enterprise Toolkit DLL Installation';
  ExitCode := '?';
end;

{ Help Button }
procedure TConfigDlg3.HelpBtnClick(Sender: TObject);
begin
  If (HelpContext <> 0) Then
    Application.HelpContext (HelpContext);
end;

{ Exit Installation Button }
procedure TConfigDlg3.ExitBtnClick(Sender: TObject);
begin
  ExitCode := '?';
  Close;
end;

{ << Back button }
procedure TConfigDlg3.BackBtnClick(Sender: TObject);
begin
  If ValidOk('B') Then Begin
    ExitCode := 'B';
    Close;
  End; { If }
end;

{ Next >> button }
procedure TConfigDlg3.NextBtnClick(Sender: TObject);
begin
  If ValidOk('N') Then Begin
    ExitCode := 'N';
    Close;
  End { If }
end;

procedure TConfigDlg3.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If (ExitCode = '?') Then Begin
    If (Application.MessageBox ('Are you sure you want to abort this installation?',
        'Install', MB_ICONQUESTION OR MB_YESNO) = IDYES) Then Begin
      ExitCode := 'X';
      CanClose := True;
    End { If }
    Else
      CanClose := False;
  End { If }
  Else
    CanClose := True;
end;

procedure TConfigDlg3.DefCcyKeyPress(Sender: TObject; var Key: Char);
begin
  If Not (Key In [#8, '0'..'9']) Then
    Key := #0;
end;

{ Perform any required validation - should be overridden }
Function TConfigDlg3.ValidOk(VCode : Char) : Boolean;
Var
  CcyVal, ErrCode : Integer;
Begin
  Result := True;

  If (VCode = 'N') Then Begin
    { Validate the Currency Number }
    If MultiCcy.Checked Then Begin
      If Not GotMCFile Then
        Result := (MessageDlg ('The specified data directory does not contain a ' +
                               'Multi-Currency version, do you want to continue anyway?',
                               mtConfirmation, [mbYes, mbNo], 0) = mrYes);

      If Result Then Begin
        { Check its 1..30 }
        Result := (Trim(DefCcy.Text) <> '');
        If Result Then Begin
          { Convert string to number }
          Val(DefCcy.Text, CcyVal, ErrCode);

          Result := (ErrCode = 0) And (CcyVal In [1..30]);
          If Result Then
            ExSyss.DefCur := CcyVal
          Else
            MessageDlg ('The Default Currency is not valid', mtError, [mbOk], 0);
        End { If }
        Else
          MessageDlg ('The Default Currency must be set', mtError, [mbOk], 0);
      End; { If }
    End { If }
    Else Begin
      { Single Currency }
      If GotMCFile Then
        Result := (MessageDlg ('The specified data directory contains a Multi-Currency ' +
                               'version, do you want to continue anyway?',
                               mtConfirmation, [mbYes, mbNo], 0) = mrYes);

      If Result Then
        ExSyss.DefCur := 0;
    End; { Else }

    If Result Then Begin
      ExSyss.AutoSetStkCost := SetCost.Checked;
      ExSyss.DeductBOM := DeductBOM.Checked;
      ExSyss.UseMLoc := DeductStk.Checked;
      ExSyss.UseExCrRate := ExchCcyRate.Checked;
      ExSyss.MCMode := MultiCcy.Checked;
      ExSyss.UpStkBal := UpdStkLev.Checked;
    End; { If }
  End; { If }
End;

procedure TConfigDlg3.DispRec;
Begin
  SetCost.Checked := ExSyss.AutoSetStkCost;
  DeductBOM.Checked := ExSyss.DeductBOM;
  DeductStk.Checked := ExSyss.UseMLoc;
  ExchCcyRate.Checked := ExSyss.UseExCrRate;
  UpdStkLev.Checked := ExSyss.UpStkBal;

  { Check if option is valid }
  If Install Then Begin
    { Installing - check to find default value }
    MultiCcy.Checked := GotMCFile;
  End { If }
  Else Begin
    { Upgrade / Configure }
    MultiCcy.Checked := ExSyss.MCMode;
  End; { If }
  MultiCcyClick(Self);

  If MultiCcy.Checked Then Begin
    If (ExSyss.DefCur In [1..30]) Then
      DefCcy.Text := IntToStr(ExSyss.DefCur)
    Else
      DefCcy.Text := '1';
  End; { If }
End;

procedure TConfigDlg3.MultiCcyClick(Sender: TObject);
begin
  DefCcy.Enabled := MultiCcy.Checked;
  ExchCcyRate.Enabled := MultiCcy.Checked;

  If MultiCcy.Checked Then Begin
    { Multi-Currency }
    If (ExSyss.DefCur In [1..30]) Then
      DefCcy.Text := IntToStr(ExSyss.DefCur)
    Else
      DefCcy.Text := '1';
    ExchCcyRate.Checked := ExSyss.UseExCrRate;
  End { If }
  Else Begin
    { Single Currency }
    DefCcy.Text := '0';
    ExchCcyRate.Checked := False;
  End; { Else }
end;


{ Returns True if the Multi-Currency DEF file is installed }
Function TConfigDlg3.GotMCFile : Boolean;
Var
  FPath : String;
Begin
  FPath := ExSyss.ExPath;
  If Not (Copy (FPath, Length(FPath), 1)[1] In [':', '\']) Then
    FPath := FPath + '\';

  Result := FileExists(FPath + 'DEFMC044.SYS');
End;


procedure TConfigDlg3.DeductBOMClick(Sender: TObject);
begin
  If DeductBOM.Checked Then
    UpdStkLev.Checked := True;
end;

end.
