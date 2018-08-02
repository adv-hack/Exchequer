unit oIntrastat;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE04}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     GlobVar, VarConst, VarRec2U, MiscFunc, IntrastatXML, ExceptIntf;

type
  TIntrastatDetailsObject = class(TAutoIntfObjectEx, IIntrastatDeliveryTerms, IIntrastatNoTC,
                                   IIntrastatTransportMode)
  protected
    FObjectType : enumSettingType;
    FIndex : Integer;

    function Get_idtCode: WideString; safecall;
    function Get_idtDescription: WideString; safecall;

    function Get_itcCode: WideString; safecall;
    function Get_itcDescription: WideString; safecall;

    function Get_itmCode: WideString; safecall;
    function Get_itmDescription: WideString; safecall;

    function GetCode : WideString;
    function GetDescription : WideString;


  public
    Constructor Create(AIndex : Integer; oType : enumSettingType);
  end;

  TIntrastatList = class(TAutoIntfObjectEx, IIntrastatDeliveryTermsList, IIntrastatNoTCList,
                                   IIntrastatTransportModeList)
  protected
    FObjectType : enumSettingType;
    function GetCount : Integer;
    function GetItem(Index : Integer) : TIntrastatDetailsObject;

    function Get_idtCount: Integer; safecall;
    function Get_idtDeliveryTerms(Index: Integer): IIntrastatDeliveryTerms; safecall;

    function Get_itcCount: Integer; safecall;
    function Get_itcNoTC(Index: Integer): IIntrastatNoTC; safecall;

    function Get_itmCount: Integer; safecall;
    function Get_itmTransportMode(Index: Integer): IIntrastatTransportMode; safecall;
  public
    Constructor Create(oType : enumSettingType);
  end;

  TIntrastatSetup = class(TAutoIntfObjectEx, IIntrastatSetup)
  protected
    FDeliveryTermsI : IIntrastatDeliveryTermsList;
    FDeliveryTermsO : TIntrastatList;

    FNoTCI : IIntrastatNoTCList;
    FNoTCO : TIntrastatList;

    FTransportModeI : IIntrastatTransportModeList;
    FTransportModeO : TIntrastatList;

    function Get_ssEnableIntrastat: WordBool; safecall;
    function Get_ssShowDeliveryTerms: WordBool; safecall;
    function Get_ssShowTransportMode: WordBool; safecall;
    function Get_ssLastClosedArrivalsDate: WideString; safecall;
    function Get_ssLastClosedDispatchesDate: WideString; safecall;
    function Get_ssDeliveryTerms: IIntrastatDeliveryTermsList; safecall;
    function Get_ssNoTC: IIntrastatNoTCList; safecall;
    function Get_ssTransportMode: IIntrastatTransportModeList; safecall;

    procedure InitialiseLists;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  ComServ, oSystemSetup;

{ TIntrastatDetailsObject }

constructor TIntrastatDetailsObject.Create(AIndex : Integer; oType: enumSettingType);
begin
  Case oType of
    stDeliveryTerms       : Inherited Create (ComServer.TypeLib, IIntrastatDeliveryTerms);
    stNatureOfTransaction : Inherited Create (ComServer.TypeLib, IIntrastatNoTC);
    stModeOfTransport     : Inherited Create (ComServer.TypeLib, IIntrastatTransportMode);
  end;

  FObjectType := oType;
  FIndex := AIndex - 1; //Switch from COM TK 1-based index to IntrastatXML 0-based index
end;

function TIntrastatDetailsObject.Get_idtCode: WideString;
begin
  Result := GetCode;
end;

function TIntrastatDetailsObject.Get_idtDescription: WideString;
begin
  Result := GetDescription;
end;

function TIntrastatDetailsObject.Get_itmDescription: WideString;
begin
  Result := GetDescription;
end;

function TIntrastatDetailsObject.Get_itcCode: WideString;
begin
  Result := GetCode;
end;

function TIntrastatDetailsObject.Get_itcDescription: WideString;
begin
  Result := GetDescription;
end;

function TIntrastatDetailsObject.Get_itmCode: WideString;
begin
  Result := GetCode;
end;

function TIntrastatDetailsObject.GetCode: WideString;
begin
  Case FObjectType of
    stDeliveryTerms : Result := IntrastatSettings.DeliveryTerms[FIndex].Code;
    stNatureOfTransaction : Result := IntrastatSettings.NatureOfTransactionCodes[FIndex].Code;
    stModeOfTransport : Result := IntrastatSettings.ModesOfTransport[FIndex].Code;
  end;
end;

function TIntrastatDetailsObject.GetDescription: WideString;
begin
  Case FObjectType of
    stDeliveryTerms : Result := IntrastatSettings.DeliveryTerms[FIndex].Description;
    stNatureOfTransaction : Result := IntrastatSettings.NatureOfTransactionCodes[FIndex].Description;
    stModeOfTransport : Result := IntrastatSettings.ModesOfTransport[FIndex].Description;
  end;
end;

{ TIntrastatList }

constructor TIntrastatList.Create(oType: enumSettingType);
begin
  Case oType of
    stDeliveryTerms       : Inherited Create (ComServer.TypeLib, IIntrastatDeliveryTermsList);
    stNatureOfTransaction : Inherited Create (ComServer.TypeLib, IIntrastatNoTCList);
    stModeOfTransport     : Inherited Create (ComServer.TypeLib, IIntrastatTransportModeList);
  end;

  FObjectType := oType;
end;

function TIntrastatList.Get_idtCount: Integer;
begin
  Result := GetCount;
end;

function TIntrastatList.Get_idtDeliveryTerms(
  Index: Integer): IIntrastatDeliveryTerms;
begin
  Result := GetItem(Index);
end;

function TIntrastatList.Get_itcCount: Integer;
begin
  Result := GetCount;
end;

function TIntrastatList.Get_itcNoTC(Index: Integer): IIntrastatNoTC;
begin
  Result := GetItem(Index);
end;

function TIntrastatList.Get_itmCount: Integer;
begin
  Result := GetCount;
end;

function TIntrastatList.Get_itmTransportMode(
  Index: Integer): IIntrastatTransportMode;
begin
  Result := GetItem(Index);
end;

function TIntrastatList.GetCount: Integer;
begin
  Result := 0;
  Case FObjectType of
    stDeliveryTerms : Result := IntrastatSettings.DeliveryTermsCount;
    stNatureOfTransaction : Result := IntrastatSettings.NatureOfTransactionCodesCount;
    stModeOfTransport : Result := IntrastatSettings.ModesOfTransportCount;
  end;
end;

function TIntrastatList.GetItem(Index: Integer): TIntrastatDetailsObject;
begin
  if (Index >= 1) and (Index <= GetCount) then
    Result := TIntrastatDetailsObject.Create(Index, FObjectType)
  else
    raise EInvalidMethod.Create('Index out of range (' + IntToStr(Index) + ')');
end;

{ TIntrastatSetup }

constructor TIntrastatSetup.Create;
begin
  inherited Create(ComServer.TypeLib, IIntrastatSetup);
  InitialiseLists;
end;

destructor TIntrastatSetup.Destroy;
begin
  InitialiseLists;
  inherited;
end;

function TIntrastatSetup.Get_ssDeliveryTerms: IIntrastatDeliveryTermsList;
begin
  if not Assigned(FDeliveryTermsO) then
  begin
    FDeliveryTermsO := TIntrastatList.Create(stDeliveryTerms);

    FDeliveryTermsI := FDeliveryTermsO;
  end;

  Result := FDeliveryTermsI;
end;

function TIntrastatSetup.Get_ssEnableIntrastat: WordBool;
begin
  Result := Syss.Intrastat;
end;

function TIntrastatSetup.Get_ssLastClosedArrivalsDate: WideString;
begin
  Result := SystemSetup.Intrastat.isLastClosedArrivalsDate;
end;

function TIntrastatSetup.Get_ssLastClosedDispatchesDate: WideString;
begin
  Result := SystemSetup.Intrastat.isLastClosedDispatchesDate;
end;

function TIntrastatSetup.Get_ssNoTC: IIntrastatNoTCList;
begin
  if not Assigned(FNoTCO) then
  begin
    FNoTCO := TIntrastatList.Create(stNatureOfTransaction);

    FNoTCI := FNoTCO;
  end;

  Result := FNoTCI;
end;

function TIntrastatSetup.Get_ssShowDeliveryTerms: WordBool;
begin
  Result := SystemSetup.Intrastat.isShowDeliveryTerms;
end;

function TIntrastatSetup.Get_ssShowTransportMode: WordBool;
begin
  //PR: 12/02/2016 v2016 R1 ABSEXCH-17294 Wasn't assigning result
  Result := SystemSetup.Intrastat.isShowModeOfTransport;
end;

function TIntrastatSetup.Get_ssTransportMode: IIntrastatTransportModeList;
begin
  if not Assigned(FTransportModeO) then
  begin
    FTransportModeO := TIntrastatList.Create(stModeOfTransport);

    FTransportModeI := FTransportModeO;
  end;

  Result := FTransportModeI;
end;

procedure TIntrastatSetup.InitialiseLists;
begin
  FDeliveryTermsI := nil;
  FDeliveryTermsO := nil;

  FNoTCI := nil;
  FNoTCO := nil;

  FTransportModeI := nil;
  FTransportModeO := nil;
end;

end.
