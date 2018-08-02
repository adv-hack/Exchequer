unit CompanyExists;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, WiseUtil, IniFiles;

Function Setup_CompanyExists (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

Uses GlobVar, VarConst, BtrvU2, BTKeys1U;

//=========================================================================

// Called via SQLHelpr.Exe from the Company Details dialog in the exchequer installer
// to determine if the company code already exists. Returns TRUE if it exists.
Function Setup_CompanyExists (var DLLParams: ParamRec): LongBool;
Var
  W_MainDir, W_CompCode : ANSIString;
  LStatus          : SmallInt;
  KeyS             : Str255;
  Ver              : Integer;
  Rev              : Integer;
  Typ              : Char;
  DumBlock         : BtrvU2.FileVar;
Begin { Setup_CompanyExists }
  Result := False;

  GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
  GetVariable(DLLParams, 'V_COMPCODE', W_CompCode);

  { Check Btrieve is running - often comes in handy :-) }
  If GetBtrvVer(DumBlock,Ver,Rev,Typ,1) Then
  Begin
    { Open Company.Dat in Main Directory }
    LStatus := Open_File(F[CompF], W_MainDir + FileNames[CompF], 0);
    If (LStatus = 0) Then
    Begin
      KeyS := FullCompCodeKey(cmCompDet, W_CompCode);
      LStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
      Result := (LStatus = 0);

      { Close company.Dat }
      Close_File(F[CompF]);
    End; // If (LStatus = 0)
  End; // If GetBtrvVer(DumBlock,Ver,Rev,Typ,1)
End; { Setup_CompanyExists }

//=========================================================================

end.
