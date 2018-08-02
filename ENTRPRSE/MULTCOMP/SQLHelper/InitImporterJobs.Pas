unit InitImporterJobs;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses SysUtils, WiseUtil;

function SCD_InitialiseImporterJobs(var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

Uses GlobVar, VarConst, BtrvU2, GlobExcH, uUpdatePaths, SQLUtils, CompUtil;


// v6.3 - Initialise Importer Example Jobs
//
// 1000   - Unknown Error
// 1001   - Unknown Exception
// 1002   - Invalid Main Directory
// 10100-10199  - Btrieve Error opening Company.Dat
function SCD_InitialiseImporterJobs(var DLLParams: ParamRec): LongBool;
Const
  FNum    = CompF;
  KeyPath : Integer = CompCodeK;
Var
  DllStatus, lStatus : LongInt;
  ExeDir    : String;
  KeyS                         : Str255;
Begin { SCD_InitialiseImporterJobs }
  DllStatus := 1000;

  Try
    { Get Installation Type from WISE }
    GetVariable(DLLParams, 'V_MAINDIR', ExeDir);
    FixPath (ExeDir);

    // Check paths are valid
    if SQLUtils.ValidSystem(ExeDir) then
    Begin
      { open company database }
      lStatus := Open_File(F[FNum], ExeDir + FileNames[FNum], 0);
      If (lStatus = 0) Then
      Begin
        Try
          // Step through each company }
          KeyS := cmCompDet;
          lStatus := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
          While (lStatus = 0) And (Company^.RecPFix = cmCompDet) Do
          Begin
            If (UpperCase(Trim(Company^.CompDet.CompPath)) = UpperCase(ExeDir)) Then
            Begin
              // Root directory
              UpdateImporterPaths(Trim(Company^.CompDet.CompPath), Company^.CompDet.CompCode, Trim(Company^.CompDet.CompName));
            End; // If (UpperCase(Trim(Company^.CompDet.CompPath)) = UpperCase(ExeDir))

            lStatus := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
          End; // While (lStatus = 0)

          DllStatus := 0;
        Finally
          { close company database }
          Close_File(F[CompF]);
        End; // Try..Finallytry
      End // If (lStatus = 0)
      Else
        { Btrieve Error opening Company.Dat }
        DLLStatus := 10100 + lStatus;
    End { If }
    Else
      { Invalid Main Directory }
      DllStatus := 1002;
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      DLLStatus := 1001;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_InitialiseImporterJobs }

end.

