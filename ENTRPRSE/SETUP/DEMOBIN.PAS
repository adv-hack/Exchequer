unit DemoBin;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, FileCtrl, Forms, IniFiles, SysUtils, Windows,
     SetupU;


{ Reads the Setup.Bin .INI file which contains info for the Demo CD Setup }
function SCD_ReadDemoConfig (var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;


implementation

Uses CompUtil;

{ Reads the Setup.Bin .INI file which contains info for the Demo CD Setup }
function SCD_ReadDemoConfig (var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;
var
  IniF        : TIniFile;
  LicPath     : String;
  IntRes, Err : Integer;
Begin { SCD_ReadDemoConfig }
  Result := False;

  Try
    { Get Installation Source directory }
    GetVariable(DLLParams, 'INST', LicPath);
    FixPath(LicPath);
    If FileExists (LicPath + 'SETUP.BIN') Then Begin
      IniF := TIniFile.Create(LicPath + 'SETUP.BIN');
      Try
        LicPath := IniF.ReadString ('DemoConfig', 'Country', '1');

        IntRes := 0;
        Val (LicPath, IntRes, Err);

        If (Err = 0) And ((IntRes >= 1) And (IntRes <= 6)) Then Begin
          SetVariable(DLLParams, 'I_COUNTRY', IntToStr(IntRes));
        End; { If }
      Finally
        IniF.Free;
      End;
    End; { If FileExists }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SCD_ReadDemoConfig }


end.
