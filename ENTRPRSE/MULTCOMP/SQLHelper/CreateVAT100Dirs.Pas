Unit CreateVAT100Dirs;

Interface

Uses Classes, SysUtils, Windows, WiseUtil;

// Called to create the Audit folder and the initial audit log if required
function SCD_CreateVAT100Dirs(var DLLParams: ParamRec): LongBool;

Implementation

Uses CompUtil, GlobVar, VarConst, BtrvU2, GlobExcH;

//=========================================================================

// Called to create the Audit folder and the initial audit log if required
function SCD_CreateVAT100Dirs(var DLLParams: ParamRec): LongBool;
Var
  W_InstType, W_CompanyName, W_MainDir : String;
  lStatus, DllStatus : LongInt;
  Params, sPath  : ANSIString;
  KeyS : Str255;
Begin // SCD_CreateVAT100Dirs
  Params := DLLParams.szParam;

  { Check security parameter to ensure not called by anyone }
  If (Copy (Params, 1, 9) = 'JDU38S2GU') And (Length(Params) = 9) Then
  Begin
    DllStatus := 0;

    Try
      { Get Enterprise Main Directory from WISE }
      GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
      FixPath (W_MainDir);

      { open company database }
      lStatus := Open_File(F[CompF], W_MainDir + FileNames[CompF], 0);

      If (lStatus = 0) Then
      Begin
        Try
          // Run through the Company Records
          lStatus := Find_Rec(B_GetFirst, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
          While (lStatus = 0) Do
          Begin
            If (Company^.RecPFix = cmCompDet) Then
            Begin
              sPath := IncludeTrailingPathDelimiter(Trim(Company^.CompDet.CompPath));
              ForceDirectories (sPath + 'Audit\VAT100\RawFiles\Sent');
              ForceDirectories (sPath + 'Audit\VAT100\RawFiles\Received');
            End; // If (Company^.RecPFix = cmCompDet)

            lStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
          End; // While (lStatus = 0)
        Finally
          { close company database }
          Close_File(F[CompF]);
        End; // Try..Finally
      End // If (lStatus = 0)
      Else
        { Btrieve Error opening Company.Dat }
        DLLStatus := 10100 + lStatus;
    Except
      On Ex:Exception Do
      Begin
        GlobExceptHandler(Ex);
        DLLStatus := 1001;
      End; { On }
    End; // Try..Except
  End // If (Copy (Params, 1, 9) = 'JDU38S2GU') And (Length(Params) = 9)
  Else Begin
    { Incorrect security parameter }
    DLLStatus := 1001;
  End; { Else }

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; // SCD_CreateVAT100Dirs

//=========================================================================


End.
