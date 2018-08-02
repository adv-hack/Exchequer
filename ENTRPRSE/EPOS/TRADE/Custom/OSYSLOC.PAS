// Implementation of the "ssLocation" COM Object
unit oSysLoc;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, EPOSProc
  , VarConst, CustomP, DLLInc, oAddr, GlobVar, UseDLLU;

type

  TTradeLocation = class(TAutoIntfObject, ITradeLocation)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    FLocAddressO : TTradeAddress;
    FLocAddressI : ITradeAddress;

    Function GetDataChanged : Boolean;

  protected
    function Get_loCode: WideString; safecall;
    function Get_loName: WideString; safecall;
    function Get_loAddress: ITradeAddress; safecall;
    function Get_loPhone: WideString; safecall;
    function Get_loFax: WideString; safecall;
    function Get_loEmailAddr: WideString; safecall;
    function Get_loModem: WideString; safecall;
    function Get_loContact: WideString; safecall;
    function Get_loCurrency: Smallint; safecall;
    function Get_loArea: WideString; safecall;
    function Get_loRep: WideString; safecall;
    function Get_loTagged: WordBool; safecall;
    function Get_loCostCentre: WideString; safecall;
    function Get_loDepartment: WideString; safecall;
    function Get_loOverrideSalesPrice: WordBool; safecall;
    function Get_loOverrideGLCodes: WordBool; safecall;
    function Get_loOverrideCCDept: WordBool; safecall;
    function Get_loOverrideSupplier: WordBool; safecall;
    function Get_loOverrideBinLocation: WordBool; safecall;
    function Get_loSalesGL: Integer; safecall;
    function Get_loCostOfSalesGL: Integer; safecall;
    function Get_loPandLGL: Integer; safecall;
    function Get_loBalSheetGL: Integer; safecall;
    function Get_loWIPGL: Integer; safecall;
  public
    lTKLocationRec : TBatchMLocRec;

    // DataChanged flag indicates whether Plug-Ins made any changes to
    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create(sLocCode : string);
    Destructor Destroy; override;

  End; { TTradeLocation }

implementation

uses
  CustIntU, ComServ;

//---------------------------------------------------------------------------

Constructor TTradeLocation.Create(sLocCode : string);

  function GetLocRec(sLocation : string) : TBatchMLocRec;
  Var
    iStatus :  Integer;
    PCLoc   :  PChar;
    SearchPath : SmallInt;
  begin
    SearchPath:=0;

    Result.loCode:=sLocation;

    {* allocate memory buffer for PC Location as String 255 *}
    PCLoc := StrAlloc (255);

    {* assign Location Code into PC *}
    StrPCopy(PCLoc, Result.loCode);

    {* Find by using DLL function  *}
    iStatus := Ex_GetLocation(@Result,SizeOf(Result),PCLoc,SearchPath,B_GetEq,False);
//    if (iStatus <> 0) then Raise Exception.Create ('Ex_GetLocation : ' + IntToStr(iStatus));

    {* dispose allocated buffer of PC *}
    StrDispose(PCLoc);
  end;{GetLocRec}

Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  if trim(sLocCode) <> '' then lTKLocationRec := GetLocRec(sLocCode);

  FLocAddressO := TTradeAddress.Create;
  FLocAddressI := FLocAddressO;
  FLocAddressO.Assign(nil, waSysLocation);

  FDataChanged := False;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeLocation.Destroy;
Begin { Destroy }

  FLocAddressO := nil;
  FLocAddressI := nil;

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

// Returns TRUE if any properties within the eventdata have been changed
function TTradeLocation.GetDataChanged : Boolean;
begin { GetDataChanged }
  Result := FDataChanged or FLocAddressO.DataChanged;
end; { GetDataChanged }


function TTradeLocation.Get_loAddress: ITradeAddress;
begin
  Result := FLocAddressI;
end;


function TTradeLocation.Get_loArea: WideString;
begin
  Result := lTKLocationRec.loArea;
end;

function TTradeLocation.Get_loBalSheetGL: Integer;
begin
  Result := lTKLocationRec.loNominal[4];
end;

function TTradeLocation.Get_loCode: WideString;
begin
  Result := lTKLocationRec.loCode;
end;

function TTradeLocation.Get_loContact: WideString;
begin
  Result := lTKLocationRec.loContact;
end;

function TTradeLocation.Get_loCostCentre: WideString;
begin
  Result := lTKLocationRec.loCC;
end;

function TTradeLocation.Get_loCostOfSalesGL: Integer;
begin
  Result := lTKLocationRec.loNominal[2];
end;

function TTradeLocation.Get_loCurrency: Smallint;
begin
  Result := lTKLocationRec.loCurrency;
end;

function TTradeLocation.Get_loDepartment: WideString;
begin
  Result := lTKLocationRec.loDep;
end;

function TTradeLocation.Get_loEmailAddr: WideString;
begin
  Result := lTKLocationRec.loemail;
end;

function TTradeLocation.Get_loFax: WideString;
begin
  Result := lTKLocationRec.loFax;
end;

function TTradeLocation.Get_loModem: WideString;
begin
  Result := lTKLocationRec.loModem;
end;

function TTradeLocation.Get_loName: WideString;
begin
  Result := lTKLocationRec.loName;
end;

function TTradeLocation.Get_loOverrideBinLocation: WordBool;
begin
  Result := lTKLocationRec.loUseBinLoc;
end;

function TTradeLocation.Get_loOverrideCCDept: WordBool;
begin
  Result := lTKLocationRec.loUseCCDep;
end;

function TTradeLocation.Get_loOverrideGLCodes: WordBool;
begin
  Result := lTKLocationRec.loUseNom;
end;

function TTradeLocation.Get_loOverrideSalesPrice: WordBool;
begin
  Result := lTKLocationRec.loUsePrice;
end;

function TTradeLocation.Get_loOverrideSupplier: WordBool;
begin
  Result := lTKLocationRec.loUseSupp;
end;

function TTradeLocation.Get_loPandLGL: Integer;
begin
  Result := lTKLocationRec.loNominal[3];
end;

function TTradeLocation.Get_loPhone: WideString;
begin
  Result := lTKLocationRec.loTel;
end;

function TTradeLocation.Get_loSalesGL: Integer;
begin
  Result := lTKLocationRec.loNominal[1];
end;

function TTradeLocation.Get_loTagged: WordBool;
begin
  Result := lTKLocationRec.loTag;
end;

function TTradeLocation.Get_loWIPGL: Integer;
begin
  Result := lTKLocationRec.loNominal[5];
end;

function TTradeLocation.Get_loRep: WideString;
begin
  Result := lTKLocationRec.loRep;
end;

end.
