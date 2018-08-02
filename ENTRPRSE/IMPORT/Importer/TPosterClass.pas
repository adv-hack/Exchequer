unit TPosterClass;

{******************************************************************************}
{ Implements a simple class for sending broadcast messages to specific windows }
{ within the application rather than to every top-level window.                }
{ This means we can use WM_USER + ???? messages rather than having to define   }
{ and register system-wide messages.                                           }
{ Classes which have messages to issue should define a public Poster property. }
{ Forms which want to receive messages from a given class should call it's     }
{ Poster.RegisterWindow method passing it's window handle.                     }
{******************************************************************************}

interface

uses classes, windows;

type
   TPoster = class(TObject)
  private
{* Internal Fields *}
    FRegisteredWindows: TList;
  public
    constructor create;
    destructor  destroy; override;
    procedure PostMSg(MsgNo: integer; wParam: integer; lParam: integer);
    procedure RegisterWindow(hWND: HWND);
  end;

implementation

uses Utils, forms;

constructor TPoster.create;
begin
  inherited create;

  FRegisteredWindows := TList.Create;
end;

destructor TPoster.destroy;
begin
  FreeObjects([FRegisteredWindows]);
  inherited;
end;

procedure TPoster.PostMsg(MsgNo: integer; wParam: integer; lParam: integer);
// Posts the message to the message queue of all windows(ie forms) which called
// RegisterWindow with their handle
var
  i: integer;
begin
  for i := 0 to FRegisteredWindows.Count - 1 do begin
    PostMessage(HWND(FRegisteredWindows[i]), MsgNo, wParam, lParam);
    application.ProcessMessages;
  end;
end;

procedure TPoster.RegisterWindow(hWND: HWND);
// adds the window handle to the list if it's not already in the list.
// Windows which want to receive TPoster's messages must register.
var
  i: integer;
begin
  for i := 0 to FRegisteredWindows.Count - 1 do
    if FRegisteredWindows[i] = pointer(hWND) then exit; // IndexOf not good enuf huh ??

  FRegisteredWindows.Add(pointer(hWND));
end;

end.
