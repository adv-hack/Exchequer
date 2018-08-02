unit Version;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, FileCtrl, SysUtils, Windows, SetupU;

{ Returns True if O/S is windows 2000 }
function IsWin2000 : Boolean;

function SCD_IsWin2000(var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation

{ Returns True if O/S is windows 2000 }
function IsWin2000 : Boolean;
Var
  OSVerIRec : TOSVersionInfo;
Begin { IsWin2000 }
  Result := False;

  { Initialise API structure }
  FillChar(OSVerIRec, Sizeof(OSVerIRec), #0);
  OSVerIRec.dwOSVersionInfoSize := Sizeof(OSVerIRec);

  If GetVersionEx(OSVerIRec) then
    Result := (OSVerIRec.dwPlatformId = VER_PLATFORM_WIN32_NT) And (OSVerIRec.dwMajorVersion = 5);
End; { IsWin2000 }

{----------------------------------------------------------------------------}

{ Sets the Wise V_IsWin2000 variable to Y if running Windows 2000 }
function SCD_IsWin2000(var DLLParams: ParamRec): LongBool;
Begin { SCD_IsWin2000 }
  Try
    If IsWin2000 Then
      { Win 2000 }
      SetVariable(DLLParams,'V_ISWIN2000', 'Y')
    Else
      { Not win 2000 ! }
      SetVariable(DLLParams,'V_ISWIN2000', 'N');
  Except
    On Exception Do
      SetVariable(DLLParams,'V_ISWIN2000','N');
  End;
End; { SCD_IsWin2000 }


end.
