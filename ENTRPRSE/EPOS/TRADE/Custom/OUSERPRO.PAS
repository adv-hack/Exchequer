unit oUserPro;

Interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, VarRec2U, UseDLLU
  , DLLInc, EposProc;

type
  TTradeUserProfile = class(TAutoIntfObject, ITradeUserProfile)
  private

  protected
    function Get_upUserID: WideString; safecall;
    function Get_upName: WideString; safecall;
    function Get_upLockOutMins: Integer; safecall;
    function Get_upEmail: WideString; safecall;
    function Get_upDefSRICust: WideString; safecall;
    function Get_upDefPPISupp: WideString; safecall;
    function Get_upMaxSalesAuth: Double; safecall;
    function Get_upMaxPurchAuth: Double; safecall;
    function Get_upDefSalesBankGL: Integer; safecall;
    function Get_upDefPurchBankGL: Integer; safecall;
    function Get_upCCDeptRule: TTradePriorityRuleType; safecall;
    function Get_upDefCostCentre: WideString; safecall;
    function Get_upDefDepartment: WideString; safecall;
    function Get_upDefLocation: WideString; safecall;
    function Get_upDefLocRule: TTradePriorityRuleType; safecall;
    function Get_upSecurityFlags(Index: Integer): TTradeSecurityResultType; safecall;
  public
    Constructor Create;
  End; { TTradeUserProfile }

implementation

uses ComServ;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeUserProfile.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeUserProfile);

End; { Create }


function  TTradeUserProfile.Get_upUserID: WideString;
begin
  Result := Trim(TKUserProfileRec.upUserId);
end;

function  TTradeUserProfile.Get_upName: WideString;
begin
  Result := Trim(TKUserProfileRec.upName);
end;

function  TTradeUserProfile.Get_upEmail: WideString;
begin
  Result := Trim(TKUserProfileRec.upEmail);
end;

function  TTradeUserProfile.Get_upDefSRICust: WideString;
begin
  Result := Trim(TKUserProfileRec.upDefSRICust);
end;

function  TTradeUserProfile.Get_upDefPPISupp: WideString;
begin
  Result := Trim(TKUserProfileRec.upDefPPISupp);
end;

function  TTradeUserProfile.Get_upLockOutMins : Integer;
begin
  Result := TKUserProfileRec.upLockOutMins;
end;

function  TTradeUserProfile.Get_upDefSalesBankGL : Integer;
begin
  Result := TKUserProfileRec.upDefSalesBankGL;
end;

function  TTradeUserProfile.Get_upDefPurchBankGL : Integer;
begin
  Result := TKUserProfileRec.upDefPurchBankGL;
end;

function  TTradeUserProfile.Get_upMaxSalesAuth : Double;
begin
  Result := TKUserProfileRec.upMaxSalesAuth;
end;

function  TTradeUserProfile.Get_upMaxPurchAuth : Double;
begin
  Result := TKUserProfileRec.upMaxPurchAuth;
end;

function  TTradeUserProfile.Get_upCCDeptRule: TTradePriorityRuleType;
begin
  Result := TTradePriorityRuleType(TKUserProfileRec.upDefCCDeptRule);
end;

function  TTradeUserProfile.Get_upDefCostCentre: WideString;
begin
  Result := TKUserProfileRec.upDefCostCentre;
end;

function  TTradeUserProfile.Get_upDefDepartment: WideString;
begin
  Result := TKUserProfileRec.upDefDepartment;
end;

function  TTradeUserProfile.Get_upDefLocation: WideString;
begin
  Result := TKUserProfileRec.upDefLocation;
end;

function  TTradeUserProfile.Get_upDefLocRule: TTradePriorityRuleType;
begin
  Result := TTradePriorityRuleType(TKUserProfileRec.upDefLocRule);
end;

function  TTradeUserProfile.Get_upSecurityFlags(Index: Integer): TTradeSecurityResultType;
var
  TempRes, SecRes : SmallInt;
  PLogin : PChar;
begin
  PLogin := StrAlloc(255);
  StrPCopy(PLogin, TKUserProfileRec.upUserId);

  TempRes := Ex_CheckSecurity(PLogin, Index, SecRes);
  StrDispose(PLogin);
  if TempRes = 0 then
    Result := TTradeSecurityResultType(SecRes)
  else
  if TempRes = 1001 then
    raise ERangeError.Create('Index out of range checking security: ' + IntToStr(Index))
  else
    raise Exception.Create('Error ' + IntToStr(TempRes) + ' occurred while checking security');

end;

end.
