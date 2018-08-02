unit Confdlg4;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, FileCtrl;

type
  TConfigDlg4 = class(TForm)
    HelpBtn: TButton;
    Panel1: TPanel;
    Bevel1: TBevel;
    ExitBtn: TButton;
    BackBtn: TButton;
    NextBtn: TButton;
    TitleLbl: TLabel;
    InstrLbl: TLabel;
    Image1: TImage;
    Label2: TLabel;
    DefNom: TEdit;
    Label1: TLabel;
    DefDept: TEdit;
    Label3: TLabel;
    DefCC: TEdit;
    Label4: TLabel;
    procedure HelpBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DefNomKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FExitCode : Char;
  protected
    Function  ValidOk(VCode : Char) : Boolean; Virtual;
  public
    { Public declarations }
    Property ExitCode : Char read FExitCode write FExitCode;

    procedure DispRec;
  end;

implementation

{$R *.DFM}

Uses SetupU, VarCnst3;

{ Initialise local variables }
procedure TConfigDlg4.FormCreate(Sender: TObject);
begin
  ExitCode := '?';
end;

{ Help Button }
procedure TConfigDlg4.HelpBtnClick(Sender: TObject);
begin
  If (HelpContext <> 0) Then
    Application.HelpContext (HelpContext);
end;

{ Exit Installation Button }
procedure TConfigDlg4.ExitBtnClick(Sender: TObject);
begin
  ExitCode := '?';
  Close;
end;

{ << Back button }
procedure TConfigDlg4.BackBtnClick(Sender: TObject);
begin
  If ValidOk('B') Then Begin
    ExitCode := 'B';
    Close;
  End; { If }
end;

{ Next >> button }
procedure TConfigDlg4.NextBtnClick(Sender: TObject);
begin
  If ValidOk('N') Then Begin
    ExitCode := 'N';
    Close;
  End { If }
end;

procedure TConfigDlg4.FormCloseQuery(Sender: TObject;
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

{ Perform any required validation - should be overridden }
Function TConfigDlg4.ValidOk(VCode : Char) : Boolean;
Var
  CcyVal  : LongInt;
  ErrCode : Integer;
Begin
  Result := True;

  If (VCode = 'N') Then Begin
    { Convert string to number }
    Val(DefNom.Text, CcyVal, ErrCode);
    Result := (ErrCode = 0);
    If Result Then Begin
      ExSyss.DefNom := CcyVal;

      ExSyss.DefCCDep[True] := DefCC.Text;
      ExSyss.DefCCDep[False] := DefDept.Text;
    End { If }
    Else
      MessageDlg ('The Default General Ledger Code is not valid', mtError, [mbOk], 0);
  End; { If }
End;

procedure TConfigDlg4.DispRec;
Begin
  DefNom.Text := IntToStr(ExSyss.DefNom);
  DefCC.Text := Trim(UpperCase(ExSyss.DefCCDep[True]));
  DefDept.Text := Trim(UpperCase(ExSyss.DefCCDep[False]));
End;

procedure TConfigDlg4.DefNomKeyPress(Sender: TObject; var Key: Char);
begin
  If Not (Key In [#8, '0'..'9']) Then
    Key := #0;
end;

end.
