{*************************************************************************}
{ TMS TAdvSysKeyboardHook component                                       }
{ for Delphi & C++Builder                                                 }
{ version 1.0                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright �  2007                                             }
{           Email : info@tmssoftware.com                                  }
{           Web : http://www.tmssoftware.com                              }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit AdvSysKeyboardHook;

{$I TMSDEFS.INC}

interface

uses
  Classes, Windows, Forms, Dialogs, Controls, Graphics, Messages, ExtCtrls,
  SysUtils, Math, StdCtrls;

const

  MAJ_VER = 1; // Major version nr.
  MIN_VER = 0; // Minor version nr.
  REL_VER = 0; // Release nr.
  BLD_VER = 0; // Build nr.


type
  TAdvSysKeyboardHook = class(TComponent)
  private
    Button1: TButton;
    Button1B: TButton;
    FOnKeyDown: TKeyEvent;
    procedure Button1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1BMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    function GetHooked: Boolean;
    function GetVersion: string;
    procedure SetVersion(const Value: string);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;

    procedure InitKeyBoardHook;
    procedure KillKeyBoardHook;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetVersionNr: integer;

    property Hooked: Boolean read GetHooked;
  published
    property OnKeyDown: TKeyEvent read FOnKeyDown write FOnKeyDown;
    property Version: string read GetVersion write SetVersion stored false;
  end;

implementation

//------------------------------------------------------------------------------

{Functions prototypes for the hook dll}
type

  TGetHookRecPointer = function : pointer stdcall;
  TStartKeyBoardHook = procedure stdcall;
  TStopKeyBoardHook = procedure stdcall;

{The record type filled in by the hook dll}
  THookRec = packed record
  TheHookHandle : HHOOK;
  TheAppWinHandle : HWND;
  TheCtrlWinHandle : HWND;
  TheCtrl2WinHandle : HWND;
  TheKeyCount : DWORD;
  DropDownShortCut: DWORD;
  Swallow: DWORD;
  SwallowAlphabets: DWORD;
end;

{A pointer type to the hook record}
 PHookRec = ^THookRec;


var
  hHookLib : THANDLE; {A handle to the hook dll}
  GetHookRecPointer : TGetHookRecPointer; {Function pointer}
  StartKeyBoardHook : TStartKeyBoardHook; {Function pointer}
  StopKeyBoardHook : TStopKeyBoardHook; {Function pointer}
  LibLoadSuccess : bool; {If the hook lib was successfully loaded}
  lpHookRec : PHookRec; {A pointer to the hook record}
  EnterKeyCount : DWORD; {An internal count of the Enter Key}


//------------------------------------------------------------------------------

{ TAdvSysKeyboardHook }

constructor TAdvSysKeyboardHook.Create(AOwner: TComponent);
var
  I,Instances:Integer;
begin
  inherited;
  Button1 := nil;
  Button1B := nil;
  EnterKeyCount := 0;
  lpHookRec := NIL;
  LibLoadSuccess := False;
  @GetHookRecPointer := NIL;
  @StartKeyBoardHook := NIL;
  @StopKeyBoardHook := NIL;
  hHookLib := 0;

  if not (AOwner is TForm) then
    raise Exception.Create('Control parent must be a form!');

  Instances := 0;
  for I := 0 to Owner.ComponentCount - 1 do
    if (Owner.Components[I] is TAdvSysKeyboardHook) then Inc(Instances);
  if (Instances > 1) then
    raise Exception.Create('Only one instance of TAdvSysKeyboardHook allowed on form');

  InitKeyBoardHook;
end;

//------------------------------------------------------------------------------

destructor TAdvSysKeyboardHook.Destroy;
begin
  KillKeyBoardHook;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TAdvSysKeyboardHook.Loaded;
begin
  inherited;

end;

//------------------------------------------------------------------------------

procedure TAdvSysKeyboardHook.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;

end;

//------------------------------------------------------------------------------

procedure TAdvSysKeyboardHook.InitKeyBoardHook;
begin
  if (csDesigning in ComponentState) or (hHookLib <> 0) or not (Owner is TCustomForm) then
    Exit;

  if (Button1 = nil) then
  begin
    Button1 := TButton.Create(Self);
    Button1.Parent := TCustomForm(Owner);
    Button1.Visible := False;
    Button1.OnKeyUp := Button1KeyUp;
  end;
  if (Button1B = nil) then
  begin
    Button1B := TButton.Create(Self);
    Button1B.Parent := TCustomForm(Owner);
    Button1B.Visible := False;
    Button1B.OnMouseMove := Button1BMouseMove;
  end;

 {Set our initial variables}
  EnterKeyCount := 0;
  lpHookRec := NIL;
  LibLoadSuccess := FALSE;
  @GetHookRecPointer := NIL;
  @StartKeyBoardHook := NIL;
  @StopKeyBoardHook := NIL;
 {Try to load the hook dll}
  hHookLib := LoadLibrary('KEYHOOKDLL.DLL');
 {If the hook dll was loaded successfully}
  if hHookLib <> 0 then begin
   {Get the function addresses}
    @GetHookRecPointer :=
      GetProcAddress(hHookLib, 'GETHOOKRECPOINTER');
    @StartKeyBoardHook :=
      GetProcAddress(hHookLib, 'STARTKEYBOARDHOOK');
    @StopKeyBoardHook :=
      GetProcAddress(hHookLib, 'STOPKEYBOARDHOOK');
   {Did we find all the functions we need?}
    if ((@GetHookRecPointer <> NIL) AND
        (@StartKeyBoardHook <> NIL) AND
        (@StopKeyBoardHook <> NIL)) then begin
       LibLoadSuccess := TRUE;
      {Get a pointer to the hook record}
       lpHookRec := GetHookRecPointer;
      {Were we successfull in getting a ponter to the hook record}
       if (lpHookRec <> nil) then begin
        {Fill in our portion of the hook record}
         lpHookRec^.TheHookHandle := 0;
         lpHookRec^.TheCtrlWinHandle := Button1.Handle;
         lpHookRec^.TheCtrl2WinHandle := Button1B.Handle;
         lpHookRec^.TheKeyCount := 0;
         lpHookRec^.DropDownShortCut := 0; //FDropDownShortCut;
         lpHookRec^.Swallow := 0;
         lpHookRec^.SwallowAlphabets := 0;
         //lpHookRec^.KeyDownProc := self.GeneralKeyDown;
        {Start the keyboard hook}
         StartKeyBoardHook;
        {Start the timer if the hook was successfully set}
         if (lpHookRec^.TheHookHandle <> 0) then begin
           //Timer1.Enabled := TRUE;
         end;
       end;
    end else begin
     {We failed to find all the functions we need}
      FreeLibrary(hHookLib);
      hHookLib := 0;
      @GetHookRecPointer := NIL;
      @StartKeyBoardHook := NIL;
      @StopKeyBoardHook := NIL;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TAdvSysKeyboardHook.KillKeyBoardHook;
begin
  {Did we load the dll successfully?}
  if (LibLoadSuccess = TRUE) then begin
   {Did we sucessfully get a pointer to the hook record?}
    if (lpHookRec <> nil) then begin
     {Did the hook get set?}
      if (lpHookRec^.TheHookHandle <> 0) then begin
        //Timer1.Enabled := FALSE;
        StopKeyBoardHook;
      end;
    end;
   {Free the hook dll}
    FreeLibrary(hHookLib);

    EnterKeyCount := 0;
    lpHookRec := NIL;
    LibLoadSuccess := False;
    @GetHookRecPointer := NIL;
    @StartKeyBoardHook := NIL;
    @StopKeyBoardHook := NIL;
    hHookLib := 0;
  end;
end;

//------------------------------------------------------------------------------

procedure TAdvSysKeyboardHook.Button1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(OnKeyDown) then
  begin
    OnKeyDown(Self, Key, Shift);
  end;
end;

//------------------------------------------------------------------------------

procedure TAdvSysKeyboardHook.Button1BMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin

end;

//------------------------------------------------------------------------------

function TAdvSysKeyboardHook.GetHooked: Boolean;
begin
  Result := (LibLoadSuccess = TRUE) and (lpHookRec <> nil) and (lpHookRec^.TheHookHandle <> 0);
end;

//------------------------------------------------------------------------------

function TAdvSysKeyboardHook.GetVersion: string;
var
  vn: Integer;
begin
  vn := GetVersionNr;
  Result := IntToStr(Hi(Hiword(vn)))+'.'+IntToStr(Lo(Hiword(vn)))+'.'+IntToStr(Hi(Loword(vn)))+'.'+IntToStr(Lo(Loword(vn)));
end;

//------------------------------------------------------------------------------

function TAdvSysKeyboardHook.GetVersionNr: integer;
begin
  Result := MakeLong(MakeWord(BLD_VER,REL_VER),MakeWord(MIN_VER,MAJ_VER));
end;

//------------------------------------------------------------------------------

procedure TAdvSysKeyboardHook.SetVersion(const Value: string);
begin

end;

//------------------------------------------------------------------------------

{$IFDEF FREEWARE}
{$I TRIAL.INC}
{$ENDIF}


end.