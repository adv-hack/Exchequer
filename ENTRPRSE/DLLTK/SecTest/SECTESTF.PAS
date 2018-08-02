unit SecTestF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

{ Btrieve Constants }
{$I ExDllBt.Inc}

{ Toolkit Structures }
{$I ExchDll.Inc}

type
  TForm1 = class(TForm)
    btnLogout: TButton;
    btnCrashOut: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCrashOutClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses UseDLLU;

procedure TForm1.FormCreate(Sender: TObject);
Var
  Res : SmallInt;
begin
  Res := Ex_InitDLL;
  If (Res <> 0) Then
    ShowMessage ('Ex_InitDLL: ' + IntToStr(Res));
end;

// 'Close without Logout'
procedure TForm1.btnCrashOutClick(Sender: TObject);
begin
  Close;
end;

// 'Shutdown Normally'
procedure TForm1.btnLogoutClick(Sender: TObject);
begin
  Ex_CloseData;

  Close;
end;

end.
