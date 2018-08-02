unit StorInfo;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, IniFiles, SysUtils, Windows, SetupU;

function SCD_StoreSetupInfo (var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation

Uses CompUtil;

function SCD_StoreSetupInfo (var DLLParams: ParamRec): LongBool;
Var
  IniF : TIniFile;
  W_MainDir, W_TempStr : String;
Begin { SCD_StoreSetupInfo }
  GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
  FixPath(W_MainDir);

  IniF := TIniFile.Create(W_MainDir + 'WSTATION\SETUP.USR');
  Try
    GetVariable(DLLParams, 'V_PAPEMAIL', W_TempStr);
    IniF.WriteString ('Entrprse', 'PEmail', W_TempStr);

    GetVariable(DLLParams, 'V_PAPFAX', W_TempStr);
    IniF.WriteString ('Entrprse', 'PFax', W_TempStr);


  Finally
    IniF.Destroy;
  End;
End; { SCD_StoreSetupInfo }

end.
