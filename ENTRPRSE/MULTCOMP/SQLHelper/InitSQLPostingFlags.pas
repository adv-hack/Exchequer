Unit InitSQLPostingFlags;

Interface


Uses Classes, Dialogs, Forms, SysUtils, Windows, WiseUtil, IniFiles;

// MH 08/01/2018 2017-R1 ABSEXCH-19316: Initialise SQL Posting Flags
function SCD_InitialiseSQLPostingFlags(var DLLParams: ParamRec): LongBool; StdCall; export;

Implementation

Uses GlobVar, VarConst, BtrvU2, CompUtil, GlobExch, SQLRep_Config;

// MH 08/01/2018 2017-R1 ABSEXCH-19316: Initialise SQL Posting Flags
function SCD_InitialiseSQLPostingFlags(var DLLParams: ParamRec): LongBool;
Var
  DLLStatus, LStatus  : LongInt;
  W_InstType, W_MainDir, W_CompanyCode : String;
  KeyS : Str255;
Begin // SCD_InitialiseSQLPostingFlags
  Try
    DLLStatus := 0;    { Unknown Error }

    // Work out the type of installation - A=Install, B=Upgrade, C=Add Company }
    GetVariable(DLLParams, 'V_INSTTYPE', W_InstType);

    // Work out where the Exchequer directory is, this will contain the SQLConfig.Ini
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    FixPath (W_MainDir);

    If (W_InstType = 'A') Or (W_InstType = 'C') Then
    Begin
      // Install / Add Company - Data is assumed to be good, so set a Passed status

      // Get the Company Code for the New Company
      GetVariable(DLLParams, 'V_GETCOMPCODE', W_CompanyCode);

      // Write a passed status for the Company
      SQLReportsConfiguration (W_MainDir).SetSQLPostingStatus(W_CompanyCode, psPassed);
    End // If (W_InstType = 'A') Or (W_InstType = 'C')
    Else
    Begin
      // Upgrade - check whether the legacy SQL Posting entry exists
      With SQLReportsConfiguration (W_MainDir) Do
      Begin
        If SQLConfigExists Then
        Begin
          If SettingExists('Posting', 'DaybookPostingUsingSQL') Then
          Begin
            // Run through all the companies and add equivalent SQL Posting Status settings
            LStatus := Open_File(F[CompF], W_MainDir + FileNames[CompF], 0);
            Try
              If (LStatus = 0) Then
              Begin
                KeyS := cmCompDet;
                LStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
                While (LStatus = 0) And (Company^.RecPFix = cmCompDet) Do
                Begin
                  If LegacyDayBookPostingUsingSQL Then
                    SetSQLPostingStatus(Trim(Company^.CompDet.CompCode), psPassed)
                  Else
                    SetSQLPostingStatus(Trim(Company^.CompDet.CompCode), psFailed);

                  LStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
                End; // While (LStatus = 0) And (Company^.RecPFix = cmCompDet) 
              End; // If (LStatus = 0)
            Finally
              Close_File(F[CompF]);
            End; // Try..Finally

            DeleteKey('Posting', 'DaybookPostingUsingSQL');
          End; // If SettingExists('Posting', 'DaybookPostingUsingSQL')
        End; // If SQLConfigExists
      End; // With SQLReportsConfiguration (W_MainDir)
    End; // Else
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex, '');
      DLLStatus := 1000;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; // SCD_InitialiseSQLPostingFlags

End.
