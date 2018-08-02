{ *****************************************************************************
  WARNING: This component file was generated using the EventSinkImp utility.
           The contents of this file will be overwritten everytime EventSinkImp
           is asked to regenerate this sink component.

  NOTE:    When using this component at the same time with the XXX_TLB.pas in
           your Delphi projects, make sure you always put the XXX_TLB unit name
           AFTER this component unit name in the USES clause of the interface
           section of your unit; otherwise you may get interface conflict
           errors from the Delphi compiler.

           EventSinkImp is written by Binh Ly (bly@techvanguards.com)
  *****************************************************************************
  //Sink Classes//
  TFmPrintIFmPrinterEvents
}

{$IFDEF VER100}
{$DEFINE D3}
{$ENDIF}

//SinkUnitName//
unit FmPrintEvents;

interface

uses
  Windows, ActiveX, Classes, ComObj, OleCtrls
  //SinkUses//
  , StdVCL
  , FmPrint_TLB
  ;

type
  { backward compatibility types }
  {$IFDEF D3}
  OLE_COLOR = TOleColor;
  {$ENDIF}

  TFmPrintEventsBaseSink = class (TComponent, IUnknown, IDispatch)
  protected
    { IUnknown }
    function QueryInterface(const IID: TGUID; out Obj): HResult; {$IFNDEF D3} override; {$ENDIF} stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    { IDispatch }
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; virtual; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; virtual; stdcall;
    function GetTypeInfoCount(out Count: Integer): HResult; virtual; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; virtual; stdcall;
  protected
    FCookie: integer;
    FCP: IConnectionPoint;
    FSinkIID: TGUID;
    FSource: IUnknown;
    function DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; virtual; abstract;
  public
    destructor Destroy; override;
    procedure Connect (const ASource: IUnknown);
    procedure Disconnect;
    property SinkIID: TGUID read FSinkIID write FSinkIID;
    property Source: IUnknown read FSource;
  end;

  //SinkImportsForwards//

  //SinkImports//

  //SinkIntfStart//

  //SinkEventsForwards//
  T_IFmPrinterEventsPrintCompleteEvent = procedure (Sender: TObject) of object;

  //SinkComponent//
  TFmPrintIFmPrinterEvents = class (TFmPrintEventsBaseSink
    //ISinkInterface//
  )
  protected
    function DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
      VarResult, ExcepInfo, ArgErr: Pointer): HResult; override;

    //ISinkInterfaceMethods//
  public
    { system methods }
    constructor Create (AOwner: TComponent); override;
  protected
    //SinkInterface//
    procedure DoPrintComplete; safecall;
  protected
    //SinkEventsProtected//
    FPrintComplete: T_IFmPrinterEventsPrintCompleteEvent;
  published
    //SinkEventsPublished//
    property PrintComplete: T_IFmPrinterEventsPrintCompleteEvent read FPrintComplete write FPrintComplete;
  end;

  //SinkIntfEnd//

procedure Register;

implementation

uses
  SysUtils;

{ globals }

procedure BuildPositionalDispIds (pDispIds: PDispIdList; const dps: TDispParams);
var
  i: integer;
begin
  Assert (pDispIds <> nil);
  
  { by default, directly arrange in reverse order }
  for i := 0 to dps.cArgs - 1 do
    pDispIds^ [i] := dps.cArgs - 1 - i;

  { check for named args }
  if (dps.cNamedArgs <= 0) then Exit;

  { parse named args }
  for i := 0 to dps.cNamedArgs - 1 do
    pDispIds^ [dps.rgdispidNamedArgs^ [i]] := i;
end;


{ TFmPrintEventsBaseSink }

function TFmPrintEventsBaseSink.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TFmPrintEventsBaseSink.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin
  Result := E_NOTIMPL;
  pointer (TypeInfo) := nil;
end;

function TFmPrintEventsBaseSink.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Result := E_NOTIMPL;
  Count := 0;
end;

function TFmPrintEventsBaseSink.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
var
  dps: TDispParams absolute Params;
  bHasParams: boolean;
  pDispIds: PDispIdList;
  iDispIdsSize: integer;
begin
  { validity checks }
  if (Flags AND DISPATCH_METHOD = 0) then
    raise Exception.Create (
      Format ('%s only supports sinking of method calls!', [ClassName]
    ));

  { build pDispIds array. this maybe a bit of overhead but it allows us to
    sink named-argument calls such as Excel's AppEvents, etc!
  }
  pDispIds := nil;
  iDispIdsSize := 0;
  bHasParams := (dps.cArgs > 0);
  if (bHasParams) then
  begin
    iDispIdsSize := dps.cArgs * SizeOf (TDispId);
    GetMem (pDispIds, iDispIdsSize);
  end;  { if }

  try
    { rearrange dispids properly }
    if (bHasParams) then BuildPositionalDispIds (pDispIds, dps);
    Result := DoInvoke (DispId, IID, LocaleID, Flags, dps, pDispIds, VarResult, ExcepInfo, ArgErr);
  finally
    { free pDispIds array }
    if (bHasParams) then FreeMem (pDispIds, iDispIdsSize);
  end;  { finally }
end;

function TFmPrintEventsBaseSink.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if (GetInterface (IID, Obj)) then
  begin
    Result := S_OK;
    Exit;
  end
  else
    if (IsEqualIID (IID, FSinkIID)) then
      if (GetInterface (IDispatch, Obj)) then
      begin
        Result := S_OK;
        Exit;
      end;
  Result := E_NOINTERFACE;
  pointer (Obj) := nil;
end;

function TFmPrintEventsBaseSink._AddRef: Integer;
begin
  Result := 2;
end;

function TFmPrintEventsBaseSink._Release: Integer;
begin
  Result := 1;
end;

destructor TFmPrintEventsBaseSink.Destroy;
begin
  Disconnect;
  inherited;
end;

procedure TFmPrintEventsBaseSink.Connect (const ASource: IUnknown);
var
  pcpc: IConnectionPointContainer;
begin
  Assert (ASource <> nil);
  Disconnect;
  try
    OleCheck (ASource.QueryInterface (IConnectionPointContainer, pcpc));
    OleCheck (pcpc.FindConnectionPoint (FSinkIID, FCP));
    OleCheck (FCP.Advise (Self, FCookie));
    FSource := ASource;
  except
    raise Exception.Create (Format ('Unable to connect %s.'#13'%s',
      [Name, Exception (ExceptObject).Message]
    ));
  end;  { finally }
end;

procedure TFmPrintEventsBaseSink.Disconnect;
begin
  if (FSource = nil) then Exit;
  try
    OleCheck (FCP.Unadvise (FCookie));
    FCP := nil;
    FSource := nil;
  except
    pointer (FCP) := nil;
    pointer (FSource) := nil;
  end;  { except }
end;


//SinkImplStart//

function TFmPrintIFmPrinterEvents.DoInvoke (DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var dps: TDispParams; pDispIds: PDispIdList;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
type
  POleVariant = ^OleVariant;
begin
  Result := DISP_E_MEMBERNOTFOUND;

  //SinkInvoke//
    case DispId of
      1 :
      begin
        DoPrintComplete ();
        Result := S_OK;
      end;
    end;  { case }
  //SinkInvokeEnd//
end;

constructor TFmPrintIFmPrinterEvents.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  //SinkInit//
  FSinkIID := _IFmPrinterEvents;
end;

//SinkImplementation//
procedure TFmPrintIFmPrinterEvents.DoPrintComplete;
begin
  if not Assigned (PrintComplete) then System.Exit;
  PrintComplete (Self);
end;


//SinkImplEnd//

procedure Register;
begin
  //SinkRegisterStart//
  RegisterComponents ('Fax', [TFmPrintIFmPrinterEvents]);
  //SinkRegisterEnd//
end;

end.
