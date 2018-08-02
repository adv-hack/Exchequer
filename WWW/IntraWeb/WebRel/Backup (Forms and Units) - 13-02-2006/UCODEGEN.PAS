unit uCodeGen;

interface

uses
  SecSup2U, GlobVar, VarRec2U, Controls;

type
  TCodeGenerator = class
  private
    f30Day: boolean;
    fESN: ISNArrayType;
    fLastErrorMsg: string;
    fSecCode: string[20];
    fUserCount: integer;
    fVersion: string;
    function Calc_CheckSum(PModuleNo, PIChkSum: SmallInt): SmallInt;
    function Check_CheckSum(SecNo: Str20; ChkSum, ModuleNo, RevOR: SmallInt): Boolean;
    function GetReleaseCode(ModuleNo, PModuleNo, PICheckSum, RevOR: integer; Release, UserCount: boolean): string;
    function GetResetEntCode: string;
    function GetResyncCode: string;
    function GetResetPlugCode: string;
  public
    constructor Create(ESN: string; Version: string);
    function GetCode(CodeID: integer; SecDate: TDateTime; ThirtyDay: boolean; SecCode: string = ''; UserCount: integer = 0; ModuleID: integer = 0): string;
    property LastErrorMsg: string read fLastErrorMsg;
  end;

implementation

uses uCodeIDs, ETDateU, RsyncU, SysUtils;

//*** Startup and Shutdown *****************************************************

constructor TCodeGenerator.Create(ESN: string; Version: string);
var
CharIndex: integer;
begin
  inherited Create;

  for CharIndex:= 0 to 6 do fESN[Succ(CharIndex)]:= StrToIntDef(Copy(ESN, Succ(CharIndex * 4), 3), -1);

  if Version = version430 then fVersion:= '4.30'
  else if Version = version430c then fVersion:= '4.30'
  else if Version = version431 then fVersion:= '4.31'
  else if Version = version5 then fVersion:= '5.00';
end;

//*** Code Generation **********************************************************

function TCodeGenerator.GetCode(CodeID: integer; SecDate: TDateTime; ThirtyDay: boolean; SecCode: string; UserCount: integer; ModuleID: integer): string;
begin
  f30Day:= ThirtyDay;
  fSecCode:= Copy(SecCode, 1, 20);
  fUserCount:= UserCount;
  SecBaseDate:= SecDate;

  case CodeID of
    cidPlugIn: Result:= Generate_ESN_BaseSecurity(fESN, eidPlugIn, 0, 0);
    cidMCM: Result:= Generate_ESN_BaseSecurity(fESN, eidMCM, 0, 0);
    cidDaily: Result:= Generate_ESN_BaseSecurity(fESN, eidDaily, 0, 0);
    cidDirectors: Result:= Generate_ESN_BaseSecurity(fESN, eidDirectors, 0, 0);
    cidVectDaily: Result:= Generate_ESN_BaseSecurity(fESN, eidVectronDaily, 0, 0);
    cidEntRel: Result:= GetReleaseCode(eidSystem, eidSystem, 0, 0, false, false);
    cidEntUCRel: Result:= GetReleaseCode(254 - (7 * Ord(f30Day)), 254 - (7 * Ord(f30Day)), 0, 0, false, true);
    cidEntCoyRel: Result:= GetReleaseCode(eidCoyCount, eidCoyCount, 0, 1, false, true);
    cidModRel: Result:= GetReleaseCode(ModuleID, ModuleID, 0, 0, true, false);
    cidModUCRel: Result:= GetReleaseCode(ModuleID, ModuleID + (1000 * Ord(f30Day) * Ord(ModuleID = eidToolkit)), 0, 1, false, true);
    cidPlugRel: Result:= GetReleaseCode(eidPlugRel, eidPlugRel, PI_CheckSum(ModuleID), 0, false, false);
    cidPlugUCRel: Result:= GetReleaseCode(eidPlugUCRel, eidPlugUCRel, PI_CheckSum(ModuleID), 0, false, true);
    cidVectRel: Result:= GetReleaseCode(241 + Ord(f30Day), 0, 0, 0, false, false);
    cidResync: Result:= GetResyncCode;
    cidResetEnt: Result:= GetResetEntCode;
    cidResetPlug: Result:= GetResetPlugCode;
  end;

  if Result = '' then
  begin
    case CodeID of
      cidPlugIn, cidMCM, cidDaily, cidDirectors, cidVectDaily: fLastErrorMsg:= 'The ESN is invalid.';
      cidEntRel, cidEntUCRel, cidEntCoyRel, cidModRel, cidModUCRel, cidPlugRel, cidPlugUCRel, cidVectRel: fLastErrorMsg:= 'The security code specified is invalid.';
      cidResync: fLastErrorMsg:= 'This password can only be provided for valid ESNs, version 4.31 and above.';
      cidResetEnt, cidResetPlug: fLastErrorMsg:= 'This password can only be provided for valid ESNs, version 5.00 and above.';
    end;
  end;
end;

function TCodeGenerator.GetReleaseCode(ModuleNo, PModuleNo, PICheckSum, RevOR: integer; Release, UserCount: boolean): string;
begin
  Result:= '';

  if Check_CheckSum(fSecCode, Calc_CheckSum(PModuleNo, PICheckSum), PModuleNo, RevOR) then
  begin
    if Calc_Security(fSecCode, Release) <> 0 then
    begin
      if UserCount then Result:= Gen_UsrRelCode(fSecCode, fUserCount)
      else
      begin
        // f30Day changed from Boolean to Byte. If statement reflects either side 1=true, 0=false.
        if f30Day then
          Result:= Generate_ESN_BaseRelease(fSecCode, ModuleNo, PICheckSum, 1, fVersion)
        else
          Result:= Generate_ESN_BaseRelease(fSecCode, ModuleNo, PICheckSum, 0, fVersion);
      end;
    end;
  end;
end;

function TCodeGenerator.GetResyncCode: string;
begin
  if fVersion = '5.00' then Result:= CalcRSysnc(3, Now, fESN[1], fESN[2], fESN[3], fESN[4], fESN[5], fESN[6])
  else if fVersion = '4.31' then Result:= CalcRSysnc432(Now, fESN[1], fESN[2], fESN[3], fESN[4], fESN[5], fESN[6])
  else Result:= '';
end;

function TCodeGenerator.GetResetEntCode: string;
begin
  if fVersion = '5.00' then Result:= CalcRSysnc(2, Now, fESN[1], fESN[2], fESN[3], fESN[4], fESN[5], fESN[6])
  else Result:= '';
end;

function TCodeGenerator.GetResetPlugCode: string;
begin
  Result:= CalcRSysnc(4, Now, fESN[1], fESN[2], fESN[3], fESN[4], fESN[5], fESN[6]);
end;

//*** Helper Functions *********************************************************

function TCodeGenerator.Check_CheckSum(SecNo: Str20; ChkSum, ModuleNo, RevOR: SmallInt): Boolean;
var
ModuleRelMode: boolean;
CSLen: byte;
CS: integer;
Secy: LongInt;
CSStr, SecyStr: Str20;
begin
  CS:= ChkSum;
  CSStr:= IntToStr(CS);
  CSLen:= Length(CSStr);

  ModuleRelMode:= (((ModuleNo >= 1) and (ModuleNo <= 99)) or ((ModuleNo >= 1001) and (ModuleNo <= 1099))) and (RevOR = 0);
  Secy:= Calc_Security(SecNo, ModuleRelMode);
  SecyStr:= IntToStr(Secy);

  Result:= (CS = StrToInt(Copy(SecyStr, Length(SecyStr) - Pred(CSLen), CSLen))) or (CS = 0);
end;

function TCodeGenerator.Calc_CheckSum(PModuleNo, PIChkSum: SmallInt): SmallInt;
var
CSESN: ISNArrayType;
begin
  if (((PModuleNo >= 1) and (PModuleNo <= 99)) or (PModuleNo = 254)) and (fVersion < ExNewVer) then FillChar(CSESN, Sizeof(CSESN), 0)
  else CSESN:= fESN;

  Result:= Calc_ESN_CheckSum(CSESN, PModuleNo, PIChkSum);
end;

//******************************************************************************

end.
