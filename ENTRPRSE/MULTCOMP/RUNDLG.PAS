unit RunDlg;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal;

type
  TRunDialog = class(TForm)
    rnCommand: Text8Pt;
    OKBtn: TButton;
    CancelBtn: TButton;
    Label82: Label8;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Ok  : Boolean;
    Function  GetCommand : String;
    Procedure SetCommand(Value : String);
  public
    { Public declarations }
    Property Command : String read GetCommand write SetCommand;
    Function Execute : Boolean;
  end;

implementation

{$R *.DFM}

procedure TRunDialog.FormCreate(Sender: TObject);
begin
  Ok := False;
end;

Function TRunDialog.GetCommand : String;
begin
  Result := rnCommand.Text;
end;

Procedure TRunDialog.SetCommand(Value : String);
Begin
  rnCommand.Text := Value;
end;

procedure TRunDialog.CancelBtnClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

procedure TRunDialog.OKBtnClick(Sender: TObject);
Var
  LNull   : Array [0..255] Of Char;
begin
  If (Trim(rnCommand.Text) <> '') Then
  Begin
    { Run Command }
    FillChar (LNull, SizeOf (LNull), #0);
    StrPCopy(LNull,rnCommand.Text);

    Ok := WinExec(LNull, SW_SHOW) > 31;

    If (Not Ok) Then
      MessageDlg ('An error has occurred running the command line',
                  mtError, [mbOk], 0)
    Else
      Close;
  End // If (Trim(rnCommand.Text) <> '')
  Else
    MessageDlg ('The command line must be set before it can be run', mtError, [mbOk], 0)
end;

Function TRunDialog.Execute : Boolean;
begin
  Ok := False;

  ShowModal;

  Result := Ok;
End;

end.
