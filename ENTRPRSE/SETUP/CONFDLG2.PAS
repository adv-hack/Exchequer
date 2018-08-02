unit Confdlg2;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TConfigDlg2 = class(TForm)
    HelpBtn: TButton;
    Panel1: TPanel;
    Bevel1: TBevel;
    ExitBtn: TButton;
    BackBtn: TButton;
    NextBtn: TButton;
    TitleLbl: TLabel;
    InstrLbl: TLabel;
    Image1: TImage;
    TranPer: TCheckBox;
    OWTranNo: TCheckBox;
    OWNotePad: TCheckBox;
    EditTran: TCheckBox;
    UpAccBal: TCheckBox;
    Label1: TLabel;
    procedure HelpBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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

Uses VarCnst3;

{ Initialise local variables }
procedure TConfigDlg2.FormCreate(Sender: TObject);
begin
  ExitCode := '?';
end;

{ Help Button }
procedure TConfigDlg2.HelpBtnClick(Sender: TObject);
begin
  If (HelpContext <> 0) Then
    Application.HelpContext (HelpContext);
end;

{ Exit Installation Button }
procedure TConfigDlg2.ExitBtnClick(Sender: TObject);
begin
  ExitCode := '?';
  Close;
end;

{ << Back button }
procedure TConfigDlg2.BackBtnClick(Sender: TObject);
begin
  If ValidOk('B') Then Begin
    ExitCode := 'B';
    Close;
  End; { If }
end;

{ Next >> button }
procedure TConfigDlg2.NextBtnClick(Sender: TObject);
begin
  If ValidOk('N') Then Begin
    ExitCode := 'N';
    Close;
  End { If }
end;

{ Perform any required validation - should be overridden }
Function TConfigDlg2.ValidOk(VCode : Char) : Boolean;
Begin
  ValidOk := True;

  If (VCode = 'N') Then Begin
    ExSyss.OverWNPad := OWNotePad.Checked;
    ExSyss.UpAccBal := UpAccBal.Checked;
    ExSyss.AllowEdit := EditTran.Checked;
    ExSyss.OverWORef := OWTranNo.Checked;
    ExSyss.AutoSetPr := TranPer.Checked;
  End; { If }
End;

procedure TConfigDlg2.FormCloseQuery(Sender: TObject;
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

procedure TConfigDlg2.DispRec;
Begin
  OWNotePad.Checked := ExSyss.OverWNPad;
  UpAccBal.Checked := ExSyss.UpAccBal;

  EditTran.Checked := ExSyss.AllowEdit;
  OWTranNo.Checked := ExSyss.OverWORef;
  TranPer.Checked := ExSyss.AutoSetPr;
End;

end.
