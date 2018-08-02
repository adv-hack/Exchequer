unit PasswordUtil;

interface


{$IFDEF IMPV6}
  {$DEFINE ISYS}
{$ENDIF}
{$IFDEF OLE}
  {$DEFINE ISYS}
{$ENDIF}

uses
  GlobVar, PasswordComplexityConst, StrUtils, SysUtils, UA_Const, ComnUnit;
  
  function SendResetPwrdEmail(var ANewPassword: String;
                              const AUserID, AUserEmailID: String;
                              AMsgType: Integer = 1): Integer;
  function GenerateRandomPassword: String;
  function GetPWText(APWCode: Str255; var APNo: SmallInt): String;
  procedure PrimeTreeGroups(var PWTreeGrpAry: tPWTreeGrpAry);
  function GenerateRandomPwdSalt: String;

implementation

uses Varconst, BTSupU1, CommsInt, oSystemSetup, Dialogs, Forms, Controls,
     HelpSupU, Btrvu2, Math;

//------------------------------------------------------------------------------

function SendResetPwrdEmail(var ANewPassword: String;
                            const AUserID, AUserEmailID: String;
                            AMsgType: Integer = 1): Integer;
var
  lObjEmail: TEntEmail;
  lRes: SmallInt;
  lIsLocked,
  lGetMultiSys,
  lAutoUnload: Boolean;
  lMsg : String;
begin
  lRes := 2;
  try
    ANewPassword := GenerateRandomPassword;
  except
    ANewPassword := GenerateRandomPassword;
  end;
  if ANewPassword <> '' then
  begin
    lObjEmail := TEntEmail.Create;
    try
      with lObjEmail, SyssEDI2^.EDI2Value do
      begin
        Subject := EmailSubject[AMsgType];
        Priority := EmPriority;
        Recipients.Add(AUserEmailID);
        Sender :=  EmAddress;
        lIsLocked := False;
        // Get Email Message Text based on Sender
        if AMsgType in [MsgTypeResetPwd, MsgTypeForgettenPwd] then
          lMsg := Format(EmailMessage[AMsgType], [ANewPassword])
        else if AMsgType = MsgTypeSendPwdExchq then
          lMsg := Format(EmailMessage[AMsgType], [AUserID, ANewPassword])
        else if AMsgType = MsgTypeSendPwdWin then
          lMsg := Format(EmailMessage[AMsgType], [AUserID]);

        Message := PChar(lMsg);
        {$IFDEF ISYS}
          lGetMultiSys := True;
          lAutoUnload := False;
        {$ELSE}
          lGetMultiSys := GetMultiSys(False, lIsLocked, EDI2R);
          lAutoUnload := True;
        {$ENDIF}

        if lGetMultiSys then
        begin
          SenderName := EmName;
          SMTPServer := EmSMTP;
          UseMapi := EmUseMAPI;
          if ((UseMapi) and (EmAddress = EmptyStr)) or
             ((SenderName <> EmptyStr) and (EmAddress <> EmptyStr) and (Recipients.Text <> EmptyStr)) then
            lRes := Send(lAutoUnload)
          else
            lRes := 4;
        end
        else
          lRes := 4;
      end; { With }
    finally
      lObjEmail.Destroy;
    end;
  end;
  Result := lRes;
end;

//------------------------------------------------------------------------------
//PL 20/07/2017 2017-R2 ABSEXCH-18842 2.3.2 Reset Password - Generate Random Password
function GenerateRandomPassword: string;
var
  I,
  lPasswordLength: Integer;
  lRandomPassword,
  lPasswordString: string;
  //----------------------------------------------------------------------------
  function GetRandomString(RequireUppercase,
                           RequireLowercase,
                           RequireNumeric,
                           RequireSymbol: Boolean ): string;
  var
    lCharSet,
    lRandomString : string;
  begin
    lCharSet := '';

    if RequireUppercase then
      lCharSet := lCharSet + cUpper;

    if RequireLowercase then
      lCharSet := lCharSet + cLower;

    if RequireNumeric then
      lCharSet := lCharSet + cNumber;

    if RequireSymbol then
      lCharSet := lCharSet + cSpecialChar;

    Result := lCharSet;
  end;
  //----------------------------------------------------------------------------

begin
  Result := '';
  lRandomPassword := '';
  lPasswordString :='';

  with SystemSetup(True) do
  begin
    lPasswordLength := PasswordAuthentication.MinimumPasswordLength;
    if lPasswordLength < 8 then
      lPasswordLength := 8;

    //The first character of ANY auto generated password will never be a special character.
    lPasswordString := GetRandomString(True, True, True, False);
    lRandomPassword := lRandomPassword + lPasswordString[RandomRange(1, Length(lPasswordString)-1)];
    lPasswordLength := lPasswordLength-1;

    if (not PasswordAuthentication.RequireUppercase) and
       (not PasswordAuthentication.RequireLowercase) and
       (not PasswordAuthentication.RequireNumeric) and
       (not PasswordAuthentication.RequireSymbol) then
    begin
      lPasswordString := GetRandomString(True, True, True, True);
      for I:=0 to lPasswordLength-1 do
        lRandomPassword := lRandomPassword + lPasswordString[RandomRange(1, Length(lPasswordString)-1)] ;
    end
    else
    begin
      if PasswordAuthentication.RequireUppercase then
      begin
        lPasswordString := GetRandomString(True,False,False,False);
        lRandomPassword := lRandomPassword + lPasswordString[RandomRange(1, Length(lPasswordString)-1)];
        lPasswordLength := lPasswordLength-1;
      end;
      if PasswordAuthentication.RequireLowercase then
      begin
        lPasswordString := GetRandomString(False,True,False,False);
        lRandomPassword := lRandomPassword + lPasswordString[RandomRange(1, Length(lPasswordString)-1)];
        lPasswordLength := lPasswordLength-1;
      end;
      if PasswordAuthentication.RequireNumeric then
      begin
        lPasswordString := GetRandomString(False,False,True,False);
        lRandomPassword := lRandomPassword + lPasswordString[RandomRange(1, Length(lPasswordString)-1)];
        lPasswordLength := lPasswordLength-1;
      end;
      if PasswordAuthentication.RequireSymbol then
      begin
        lPasswordString := GetRandomString(False,False,False,True);
        lRandomPassword := lRandomPassword + lPasswordString[RandomRange(1, Length(lPasswordString)-1)];
        lPasswordLength := lPasswordLength-1;
      end;

      if lPasswordLength > 0 then
      begin
        lPasswordString := GetRandomString(True, True, True, True);
        for I:=0 to lPasswordLength-1 do
         lRandomPassword := lRandomPassword + lPasswordString[RandomRange(1, Length(lPasswordString)-1)];
      end;
    end;
    Result := lRandomPassword;
  end;
end;

//------------------------------------------------------------------------------

function GetPWText(APWCode: Str255; var APNo: SmallInt): String;
var
  lKeyS: Str255;
begin
  lKeyS := PassLCode + #0 + APWCode;
  APNo := 0;

  Status := Find_Rec(B_GetEq, F[PWrdF], PWrdF, RecPtr[PWrdF]^, PWK, lKeyS);
  if StatusOk then
  begin
    with PassWord.PassListRec do
    begin
      Result := PassDesc;
      APNo := PassLNo;
    end;
  end
  else
  begin
    {$IFDEF DBD}
      Result:='** Invalid Password setting ** '+APWCode;
    {$ELSE}
      Result:='XNANX'; {Non debug mode deliberatly exclude those which cannot be found}
    {$ENDIF}
  end;
end;

//------------------------------------------------------------------------------

procedure PrimeTreeGroups(var PWTreeGrpAry: tPWTreeGrpAry);
var
  SentimailOn,
  VizRepWrt,
  CanSaveOLE,
  TradeCounter:  Boolean;
  HoldStr,
  WOPStr,
  JAPStr,
  RetStr:  Str255;
begin
  WOPStr:= '';
  JAPStr:= '';
  RetStr:= '';
 {$IFDEF ENTER1}
  CanSaveOLE:=Check_ModRel(9, False);
  {$IFDEF DBD}
    TradeCounter := True;
    SentimailOn := True;
    VizRepWrt := False;
  {$ELSE}
    TradeCounter := Check_ModRel(11, True);
    SentimailOn := Check_ModRel(14, True);
    VizRepWrt := Check_ModRel(19, True);;
  {$ENDIF}

  {$I PWARY.PAS}
 {$ENDIF}
end;

//------------------------------------------------------------------------------

function GenerateRandomPwdSalt: String;
var
  I,
  lPasswordLength: Integer;
  lRandomPassword,
  lPasswordString: string;
  //----------------------------------------------------------------------------
  function GetRandomString(RequireUppercase: Boolean = True;
                           RequireLowercase: Boolean = True;
                           RequireNumeric: Boolean = True;
                           RequireSymbol: Boolean = True): string;
  var
    lCharSet,
    lRandomString : string;
  begin
    lCharSet := '';

    if RequireUppercase then
      lCharSet := lCharSet + cUpper;

    if RequireLowercase then
      lCharSet := lCharSet + cLower;

    if RequireNumeric then
      lCharSet := lCharSet + cNumber;

    if RequireSymbol then
      lCharSet := lCharSet + cSpecialChar;

    Result := lCharSet;
  end;
  //----------------------------------------------------------------------------

begin
  Result := '';
  lRandomPassword := '';
  lPasswordString :='';
  lPasswordLength := 16;

  for I := 0 to 3 do
  begin
    lPasswordString := GetRandomString(I=0,I=1,I=2,I=3);
    lRandomPassword := lRandomPassword + lPasswordString[RandomRange(1, Length(lPasswordString)-1)];
    lPasswordLength := lPasswordLength-1;
  end;

  if lPasswordLength > 0 then
  begin
    lPasswordString := GetRandomString;
    for I:=0 to lPasswordLength-1 do
      lRandomPassword := lRandomPassword + lPasswordString[RandomRange(1, Length(lPasswordString)-1)];

  end;
  Result := lRandomPassword;
end;
//------------------------------------------------------------------------------
end.
