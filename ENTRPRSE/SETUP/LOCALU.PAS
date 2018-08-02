unit LocalU;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, Dialogs, FileCtrl, SysUtils, Windows, SetupU;

{ Checks the CD for the Local customisation directory }
function SCD_CheckLocalDir (var DLLParams: ParamRec): LongBool; StdCall; export;

{ Calculates the Command Line parameter string for the localisation .EXE's }
Function SCD_CalcLocalParams (var DLLParams: ParamRec) : LongBool; StdCall; export;

implementation

Uses compUtil;

{ Checks the CD for the Local customisation directory }
Function SCD_CheckLocalDir (var DLLParams: ParamRec): LongBool;
Var
  W_GotLocal, W_InstPath, W_LocalPath, W_LocalOpts : String;
Begin { SCD_CheckLocalDir }
  Result := False;

  W_LocalOpts := '';

  Try
    { Get Installation Path }
    GetVariable(DLLParams, 'V_LOCALDIR', W_InstPath);
    FixPath (W_InstPath);

    { Calculate Localisation Directory path }
    W_LocalPath := W_InstPath + 'LOCAL\';

    If DirectoryExists(W_LocalPath) Then Begin
      W_GotLocal := 'Y';

      If FileExists (W_LocalPath + 'LCLMAIN.EXE') Then
        W_LocalOpts := W_LocalOpts + 'A';

      If DirectoryExists (W_LocalPath + 'FILES') Then
        W_LocalOpts := W_LocalOpts + 'B';

      If FileExists (W_LocalPath + 'LCLDATA.EXE') Then
        W_LocalOpts := W_LocalOpts + 'C';
    End { If }
    Else Begin
      W_GotLocal := 'N';
    End; { Else }

    SetVariable(DLLParams, 'V_GOTLOCAL', W_GotLocal);
    SetVariable(DLLParams, 'V_LOCALDIR', W_LocalPath);
    SetVariable(DLLParams, 'V_LOCALOPTS', W_LocalOpts);
  Except
    On Ex:Exception Do ;
  End;
End; { SCD_CheckLocalDir }


{ Calculates the Command Line parameter string for the localisation .EXE's }
Function SCD_CalcLocalParams (var DLLParams: ParamRec) : LongBool;
Var
  W_CmdParam, W_InstType, WiseVar : String;
  W_LclMode                       : Char;
Begin { SCD_CalcLocalParams }
  Result := False;

  W_CmdParam := '';

  Try
    { Get command-line parameter to ID if LCLMAIN.EXE or LCLDATA.EXE }
    { A=LCLMAIN, B=LCLDATA }
    W_LclMode := DllParams.szParam[0];

    { Get Installation Type: A=Install, B=Upgrade, C=Add Company }
    GetVariable(DLLParams, 'V_INSTTYPE', W_InstType);

    { Installation Type }
    Case W_InstType[1] Of
      'A'   : W_CmdParam := W_CmdParam + '/TYPE:I ';
      'B'   : W_CmdParam := W_CmdParam + '/TYPE:U ';
    End; { If }

    If (W_InstType[1] In ['A', 'B']) Then Begin
      { Install/Upgrade }

      { Demo or Full version }
      GetVariable(DLLParams, 'I_LICTYPE', WiseVar);
      If (WiseVar[1] In ['1', '2']) Then
        W_CmdParam := W_CmdParam + '/DEMO ';

      { Currency Version - 0-Prof, 1-Euro, 2-MC }
      GetVariable (DLLParams, 'L_CURRVER', WiseVar);
      W_CmdParam := W_CmdParam + '/CCY:' + WiseVar[1] + ' ';

      { Module Version - 0-Basic, 1-Stock, 2-SPOP }
      GetVariable (DLLParams, 'L_BASE', WiseVar);
      W_CmdParam := W_CmdParam + '/MODS:' + WiseVar[1] + ' ';
    End; { If }

    If (W_InstType[1] In ['A', 'C']) Then Begin
      { Data Type }
      GetVariable (DLLParams, 'V_DEMODATA', WiseVar);
      If (WiseVar[1] = 'Y') Then
        W_CmdParam := W_CmdParam + '/DATA:DEMO '
      Else
        W_CmdParam := W_CmdParam + '/DATA:BLANK ';
    End; { If }

    SetVariable(DLLParams, 'V_CMDPARAM', W_CmdParam);
  Except
    On Ex:Exception Do ;
  End;
End; { SCD_CalcLocalParams }


end.
