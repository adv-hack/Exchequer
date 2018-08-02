unit oVersion;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, EPOSCnst, CustomP, LicRec;

type
  TTradeVersion = class(TAutoIntfObject, ITradeVersion)
  private
    LicenceRec : EntLicenceRecType;
  protected
    function Get_verTradeCounter: WideString; safecall;
    function Get_verCustomisation: WideString; safecall;
    function Get_verModuleVersion: TTradeEntModuleVersion; safecall;
    function Get_verClientServer: WordBool; safecall;
    function Get_verCurrencyVersion: TTradeEnterpriseCurrencyVersion; safecall;
    function Get_verLicenceType: TTradeLicenceType; safecall;
    function verModules(Module: TTradeModule): TTradeModuleRelease; safecall;
  public
    function GetCurrencyVersion: TTradeEnterpriseCurrencyVersion; safecall;
    Function ValidateCurrencyNo(Const CcyNo : Integer) : Integer;
    Constructor Create;
  End; { TTradeVersion }

implementation

uses
  EntLic, TKUtil, ComServ, VarRec2U, Sysutils;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeVersion.Create;
var
  LicencePath : shortstring;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeVersion);

  LicencePath := GetMultiCompDir + EntLicFName;
  ReadEntLic(LicencePath, LicenceRec)

End; { Create }

function TTradeVersion.GetCurrencyVersion: TTradeEnterpriseCurrencyVersion;
begin
  Result := LicenceRec.licEntCVer;
end;

function TTradeVersion.Get_verClientServer: WordBool;
begin
  Result := (LicenceRec.licEntClSvr = 1);
end;

function TTradeVersion.Get_verCurrencyVersion: TTradeEnterpriseCurrencyVersion;
begin
  Result := LicenceRec.licEntCVer;
end;

function TTradeVersion.Get_verCustomisation: WideString;
begin
  Result := sCustomisationVersion;
end;

function TTradeVersion.Get_verLicenceType: TTradeLicenceType;
begin
  Result := LicenceRec.licLicType;
end;

function TTradeVersion.Get_verModuleVersion: TTradeEntModuleVersion;
begin
  Result := LicenceRec.licEntModVer;
end;

function TTradeVersion.Get_verTradeCounter: WideString;
begin
  Result := sTCMVersionNumber;
end;

// Validates and Returns a Currency Number - raises exception if invalid
Function TTradeVersion.ValidateCurrencyNo(Const CcyNo : Integer) : Integer;
Var
  MaxCcy : Byte;
Begin { ValidateCurrencyNo }
  If LicenceRec.licEntCVer > 0 Then Begin
    // Multi Currency - Euro/Global

    // Check Multi-Currency release code to distinguish Euro from Global
    case LicenceRec.licEntCVer of
      1 : MaxCcy := 2; // Euro
      2 : MaxCcy := CurrencyType; // MC
    end;{case}

    If (CcyNo >= 0) And (CcyNo <= MaxCcy) Then
      Result := CcyNo
    Else
      Raise EValidation.Create ('Invalid Currency Number (' + IntToStr(CcyNo) + ')');
  End
  Else Begin
    // Single Currency - Professional
    If (CcyNo = 0) Then
      Result := CcyNo
    Else
      Raise EValidation.Create ('Invalid Currency Number (' + IntToStr(CcyNo) + ')');
  End; { Else }
End; { ValidateCurrencyNo }


function TTradeVersion.verModules(Module: TTradeModule): TTradeModuleRelease;
begin
  Result := LicenceRec.licModules[Module + 1];
end;

end.
