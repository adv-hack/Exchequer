// Implementation of the "ssCompany" COM Object
unit oCompany;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, EPOSProc
  , VarConst, CustomP, DLLInc, oAddr, GlobVar, UseDLLU, EPOSCnst, Classes;

type

  TTradeCompany = class(TAutoIntfObject, ITradeCompany)
  private
    lCompanyRec : TCompanyType;
  protected
    function Get_coCode: WideString; safecall;
    function Get_coName: WideString; safecall;
    function Get_coPath: WideString; safecall;
  public
    Constructor Create(sCompCode : string; Companies : TStringList);
    Destructor Destroy; override;

  End; { TTradeCompany }

implementation

uses ComServ;

//---------------------------------------------------------------------------

Constructor TTradeCompany.Create(sCompCode : string; Companies : TStringList);
var
  iPos : integer;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  For iPos := 0 to Companies.Count - 1 do begin
    if (TCompanyInfo(Companies.Objects[iPos]).CompanyRec.CompCode = sCompCode)
    then begin
      lCompanyRec := TCompanyInfo(Companies.Objects[iPos]).CompanyRec;
      Break;
    end;{if}
  end;{for}
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeCompany.Destroy;
Begin { Destroy }
  Inherited;
End; { Destroy }

function TTradeCompany.Get_coCode: WideString;
begin
  Result := trim(lCompanyRec.CompCode);
end;

function TTradeCompany.Get_coName: WideString;
begin
  Result := trim(lCompanyRec.CompName);
end;

function TTradeCompany.Get_coPath: WideString;
begin
  Result := trim(lCompanyRec.CompPath);
end;

end.
