unit commsg;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TfrmComMsg = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnYes: TBitBtn;
    btnNo: TBitBtn;
    btnOK: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IsCloseDown : Boolean;
  end;

procedure ShowComMessage(const Msg : string);
function ComMessageDlg(const Msg : string) : SmallInt;
procedure ComTimedMessage(const Msg : String; Secs : longint);


implementation

{uses
  ComU;}

{$R *.DFM}


procedure ShowComMessage(const Msg : string);
begin
  with TfrmComMsg.Create(Application) do
  begin
   Try
    Label1.Caption := Msg;
    ShowModal;
   Finally
    Free;
{    if not IsLibrary then
      SetForegroundWindow(Form1.EntCustom1.IntF.SysFunc.hwnd);}
   End;
  end;
end;

function ComMessageDlg(const Msg : string) : SmallInt;
begin
  with TfrmComMsg.Create(Application) do
  begin
   Try
    btnOK.Visible := False;
    btnYes.Visible := True;
    btnNo.Visible := True;
    Label1.Caption := Msg;
    ShowModal;
    Result := ModalResult;
   Finally
    Free;
{    if not IsLibrary then
      SetForegroundWindow(Form1.EntCustom1.IntF.SysFunc.hwnd);}
   End;
  end;
end;

procedure ComTimedMessage(const Msg : String; Secs : longint);

  procedure Delay(HowLong : longint);
  var
    Start : Cardinal;
  begin
    Start := GetTickCount;
    while Start + (Secs * 100) > GetTickCount do
      Application.ProcessMessages;
  end;

begin
  with TfrmComMsg.Create(Application) do
  begin
   Try
    Label1.Caption := Msg;
    btnOK.Visible := False;
    IsCloseDown := True;
    Show;
    Delay(Secs);
   Finally
    Free;
{    if not IsLibrary and not IsCloseDown then
      SetForegroundWindow(Form1.EntCustom1.IntF.SysFunc.hwnd);}
   End;
  end;
end;


procedure TfrmComMsg.FormActivate(Sender: TObject);
begin
{  if not IsLibrary and not IsCloseDown then
    Form1.EntCustom1.IntF.SysFunc.entActivateClient(Self.Handle);}
end;

procedure TfrmComMsg.FormCreate(Sender: TObject);
begin
  IsCloseDown := False;
end;

end.
