unit progu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ScriptU, StdCtrls;

type
  PHWND = ^HWND;

  TForm1 = class(TForm)
    lblWait: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ScriptObj : TScriptObj;
    Running : Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

function EnumWndProc (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;

implementation

{$R *.DFM}

Uses Brand;

//=========================================================================

{ Callback function to identify the form designer window }
function EnumWndProc (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
var
  ClassName : string;
  Tag       : THandle;
begin
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (Trim(ClassName));

  If (AnsiCompareText (ClassName, 'GLBSUninstall') = 0) then begin
    FoundWnd^ := Hwnd;
    Result := False;
  End; { If }
end;

//=========================================================================

procedure TForm1.FormCreate(Sender: TObject);
Var
  OldHWnd : HWnd;
begin
  // Check the WISE Uninstaller window is running to prevent dopey users killing their accounts
  OldHwnd := 0;
  EnumWindows (@EnumWndProc, Longint(@OldHwnd));
  If (OldHwnd = 0) Then Begin
    Halt;
  End; { If }

  Running := False;

  Caption := Branding.pbProductName + ' Uninstall Utility';
  lblWait.Caption := StringReplace(lblWait.Caption, '<APPTITLE>', Branding.pbProductName, [rfReplaceAll, rfIgnoreCase]);
end;

//-------------------------------------------------------------------------

procedure TForm1.FormActivate(Sender: TObject);
begin
  Refresh;

  // Don't want to start multiple installs if the focus changes
  If (Not Running) Then
  Begin
    Running := True;

    ScriptObj := TScriptObj.Create;
    Try
      With ScriptObj Do Begin
        BaseDir := ExtractFilePath(Application.ExeName);
        ScriptName := 'EntDel.Lst';
      End; { With }

      ScriptObj.Execute;
    Finally
      ScriptObj.Free;
    End;

    PostMessage (Self.Handle, WM_Close, 0, 0);
  End; // If (Not Running)
end;

//-------------------------------------------------------------------------

end.
