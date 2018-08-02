unit Security;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  SysU2, GlobVar, VarConst, SysUtils;

function Get_UserID(AUserName: String): String;
function EX_CHECKSECURITY(UserName : PChar; AreaCode : LongInt; VAR SecurityResult : SmallInt) : SmallInt; STDCALL EXPORT;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses DllErrU, oSystemSetup, DLSQLSup, BtKeys1U, Btrvu2, PasswordComplexityConst, VarRec2U;

// SSK 29/05/2018 2018-R1.1 ABSEXCH-20687: this function will check validity of the user
function Get_UserID(AUserName: String): String;
var
  lUserFound: Boolean;
  lKeyS: Str255;
begin
  Result := EmptyStr;
  if SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows then
  begin
    with MLocCtrl^.PassDefRec do
    begin
      //Read through users and find one with this windows domain and Id
      lUserFound := False;
      lKeyS := FullPWordKey(PassUCode, 'D', '');
      UseVariant(F[MLocF]);
      Status := Find_Rec(B_GetGEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, lKeyS);

      while (Status = 0) and (MLocCtrl.RecPFix = PassUCode) and (MLocCtrl.SubType = 'D') and (not lUserFound) do
      begin
        //Need to make comparison case-insensitive
        lUserFound := (Trim(UpperCase(AUserName)) = Trim(UpperCase(WindowUserId))) or
                      (Trim(UpperCase(AUserName)) = Trim(UpperCase(Login)));
        if not lUserFound then
        begin  //read next user record
          UseVariant(F[MLocF]);
          Status := Find_Rec(B_GetNext, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, lKeyS);
        end;
      end; //while not UserFound
      if lUserFound then
        Result := Trim(Login);
    end;
  end
  else
    Result := AUserName;
end;

Function EX_CHECKSECURITY(UserName : PChar; AreaCode : LongInt; var SecurityResult : SmallInt) : SmallInt; STDCALL EXPORT;
var
  lUserID: Str255;
begin

  Result:=0;

  // SSK 29/05/2018 2018-R1.1 ABSEXCH-20687: check windows user-id in case Windows Authentication is ON
  lUserID := Get_UserID(StrPas(UserName));

  if (AreaCode > High(EntryRec.Access)) or (AreaCode < Low(EntryRec.Access)) then Result := 1001
  else begin
    if GetLogInRec(UpperCase(lUserID)) then
      begin
        Result := 0;
        SecurityResult := EntryRec.Access[AreaCode];
      end
    else Result := 1000;
  end;{if}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(134,Result);

end; {Ex_CheckSecurity..}

end.
