unit UserProf;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  Dialogs, SysUtils, GlobVar, VarConst, VarRec2U, VarCnst3;


Function EX_GETUSERPROFILE (P          : Pointer;
                            PSize      : LongInt;
                            SearchKey  : PChar;
                            SearchMode : SmallInt) : SmallInt; StdCall; Export;


implementation

Uses BtrvU2, BtSupU1, DLLErrU, ETStrU;


//----------------------------------------------------------------------------

// Copy the User Profile from the Enterprise record into the Toolkit record
Function GetUserProf (Const UserID : ShortString) : TUserProfileType;
Var
  KeyS    : Str255;
  lStatus : SmallInt;
Begin { GetUserProf }
  // Try to find a matching User Profile record
  KeyS := PassUCode + 'D' + UserId;
  lStatus := Find_Rec (B_GetEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, KeyS);

  If (LStatus = 0) Then Begin
    // Found - copy detail across
    FillChar (Result, SizeOf (Result), #0);
    With Result, MLocCtrl.PassDefRec Do Begin
      // User Id
      upUserId         := Trim(UserId);
      // User Name
      upName           := Trim(UserName);
      // Email Address
      upEmail          := Trim(EmailAddr);

      { Misc }
      // Minutes for Auto Lock Out
      upLockOutMins    := PWTimeOut;

      { Defaults }
      // Default Cust for SRI
      upDefSRICust     := DirCust;
      // Default Supp for PPI
      upDefPPISupp     := DirSupp;
      // Default Cost Centre
      upDefCostCentre  := CCDep[BOn];
      // Default Department
      upDefDepartment  := CCDep[BOff];
      // Rule for applying Default CC/Dept
      upDefCCDeptRule  := CCDepRule;
      // Default Location code
      upDefLocation    := Loc;
      // Rule for applying Default Location
      upDefLocRule     := LocRule;
      // Default Sales Bank GL Code
      upDefSalesBankGL := SalesBank;
      // Default Purchase Bank GL Code
      upDefPurchBankGL := PurchBank;

      //PR: 12/08/2011 Added ShowGLCodes ABSEXCH-7994
      upShowGLCodesInTree := BoolToWordBool(ShowGLCodes);

      //PR: 13/07/2012 Added ShowStockCodes and ShowProductTypes ABSEXCH-12452
      upShowProductTypesInTree := BoolToWordBool(ShowProductType);
      upShowStockCodesInTree := BoolToWordBool(ShowStockCode);

      { Authorisation }
      // Max Sales Authorisation Amount
      upMaxSalesAuth   := MaxSalesA;
      // Max Purchase Authorisation Amount
      upMaxPurchAuth   := MaxPurchA;

          //PR: 22/08/2017 v2017R2 ABSEXCH-18857 User Status & Windows User ID
      upUserStatus :=  Ord(UserStatus);
      upWindowsUserID := WindowUserID;
    End; { With Result }
  End { If (LStatus = 0) }
  Else Begin
    // Profile doesn't exist - generate a blank profile
    FillChar (Result, SizeOf (Result), #0);
    With Result Do Begin
      // User Id
      upUserId := Trim(UserId);
    End; { With Result }
  End; { Else }
End; { GetUserProf }

//----------------------------------------------------------------------------

Function Ex_GetUserProfile (P          : Pointer;
                            PSize      : LongInt;
                            SearchKey  : PChar;
                            SearchMode : SmallInt) : SmallInt;
Var
  TKUserProf            : ^TUserProfileType;
  KeyS                  : Str255;
  BtrOpCode, BtrOpCode2 : SmallInt;
  Loop                  : Boolean;
Begin { Ex_GetUserProfile }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  If TestMode Then Begin
    ShowMessage ('Ex_GetUserProfile:' + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchKey: '  + StrPas(SearchKey) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode));
  End; { If TestMode }

  TKUserProf := P;
  FillChar (TKUserProf^, SizeOf(TKUserProf^), #0);
  If Assigned(TKUserProf) And (PSize = SizeOf(TUserProfileType)) Then Begin
    BtrOpCode := SearchMode;
    KeyS := PassUCode + C0 + LJVar(StrPas(SearchKey),10);

    Loop := True;
    Case SearchMode of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS := PassUCode + C0 + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS := PassUCode + C0 + #255;
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                     End;

      // Looking for exact match - do it and finish
      B_GetEq      : Loop := False;
    Else
      // Invalid Btrieve Operation
      Result := 32765;
    End; { Case BtrOp}

    If (Result = 0) Then Begin
      Repeat
        Result := Find_Rec (BtrOpCode, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, KeyS);

        BtrOpCode := BtrOpCode2;

        If (Password.RecPFix <> PassUCode) Or (Password.SubType <> C0) Then
          // Not a User Password record - abandon operation
          Result := 9;
      Until (Result <> 0) Or (Not Loop) Or ((Password.RecPFix = PassUCode) And (Password.SubType = C0));

      StrPCopy (SearchKey, KeyS);
    End; { If (Result = 0) }

    If (Result = 0) Then
      // check correct record type was returned
      If (Password.RecPFix <> PassUCode) Or (Password.SubType <> C0) Then
        Result := 4;

    If (Result = 0) Then Begin
      // Return full key string back to the program in the SearchKey parameter
      StrPCopy (SearchKey, KeyS);

      // Find the User Profile for the user or generate a blank one
      TKUserProf^ := GetUserProf (Password.PassEntryRec.Login);
    End; { If (Result = 0) }
  End { If Assigned(... }
  Else
    If Assigned(TKUserProf) Then
      // Incorrect Record Size
      Result := 32766
    Else
      // Invalid Pointer
      Result := 32767;

  If (Result <> 0) then
    LastErDesc := Ex_ErrorDescription(500, Result);
End; { Ex_GetUserProfile }

//----------------------------------------------------------------------------

end.
