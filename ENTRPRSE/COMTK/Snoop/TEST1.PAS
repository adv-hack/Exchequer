unit test1;

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

var
  Form1: TForm1;

implementation

{$R *.dfm}

  function SetHook : Boolean; External 'KeyHook.dll';
  procedure EndHook; External 'KeyHook.dll';



function SetThisHook : Boolean;
var
 sPath : string;
 DLL : THandle;
 ProcAddr : Pointer;
 KH : THandle;
begin
 sPath := ExtractFilePath(ParamStr(0)) + 'keyhook.dll';
 DLL := LoadLibrary(PChar(sPath));
 ProcAddr := GetProcAddress(DLL, PChar('HookProc'));
 KH := SetWindowsHookEx(WH_KEYBOARD, ProcAddr, DLL, 0);
 Result := KH <> 0;
end;




procedure TForm1.FormCreate(Sender: TObject);
begin
  if SetHook then
    ShowMessage('Hook set ok')
  else
    ShowMessage('Hook not set');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  EndHook;
end;

end.
 