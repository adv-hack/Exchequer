unit Zver;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustAbsU;

type
  TCOMVersion = class(TAutoIntfObject, ICOMVersion2)
  private
  protected
    function  Get_AcStkAnalOn: WordBool; safecall;
    function  Get_CurrencyVer: Smallint; safecall;
    function  Get_EBusinessOn: WordBool; safecall;
    function  Get_JobCostOn: WordBool; safecall;
    function  Get_ModuleVer: Smallint; safecall;
    function  Get_PaperlessOn: WordBool; safecall;
    function  Get_RepWrtOn: WordBool; safecall;
    function  Get_TelesalesOn: WordBool; safecall;
    function  Get_VersionStr: WideString; safecall;
    function  Get_GDPROnLicense: WordBool; safecall;
  public
    Constructor Create;
  End; { TCOMVersion }

implementation

uses ComServ, GlobVar, VarConst;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMVersion.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMVersion2);

End; { Create }

{-----------------------------------------}

function TCOMVersion.Get_AcStkAnalOn: WordBool;
Begin { Get_AcStkAnalOn }
  Result := AnalCuStk;
End; { Get_AcStkAnalOn }

{-----------------------------------------}

function TCOMVersion.Get_CurrencyVer: SmallInt;
Begin { Get_CurrencyVer }
  {$IFDEF MC_On}
    If EuroVers Then
      Result := 1   { Euro }
    Else
      Result := 2;  { Global }
  {$ELSE}
    Result := 0;    { Prof }
  {$ENDIF}
End; { Get_CurrencyVer }

{-----------------------------------------}

function TCOMVersion.Get_EBusinessOn: WordBool;
Begin { Get_EBusinessOn }
  Result := eBusModule;
End; { Get_EBusinessOn }

{-----------------------------------------}

function TCOMVersion.Get_GDPROnLicense: WordBool;
begin
  Result := GDPROn;
end;

function TCOMVersion.Get_JobCostOn: WordBool;
Begin { Get_JobCostOn }
  Result := JBCostOn;
End; { Get_JobCostOn }

{-----------------------------------------}

function TCOMVersion.Get_ModuleVer: SmallInt;
Begin { Get_ModuleVer }
  {$IFDEF SOP}
    {$IFDEF STK}
      Result := 1  { Stock }
    {$ELSE}
      Result := 2   { SPOP }
    {$ENDIF}
  {$ELSE}
    Result := 0  { Standard }
  {$ENDIF}
End; { Get_ModuleVer }

{-----------------------------------------}

function TCOMVersion.Get_PaperlessOn: WordBool;
Begin { Get_PaperlessOn }
  Result := eCommsModule;
End; { Get_PaperlessOn }

{-----------------------------------------}

function TCOMVersion.Get_RepWrtOn: WordBool;
Begin { Get_RepWrtOn }
  Result := RepWrtOn;
End; { Get_RepWrtOn }

{-----------------------------------------}

function TCOMVersion.Get_TelesalesOn: WordBool;
Begin { Get_TelesalesOn }
  Result := TeleSModule;
End; { Get_TelesalesOn }

{-----------------------------------------}

function TCOMVersion.Get_VersionStr: WideString;
Begin { Get_TelesalesOn }
  Result := Ver;
End; { Get_TelesalesOn }

{-----------------------------------------}

end.

