unit oVAT100;

interface

uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     EnterpriseBeta_TLB, MiscFunc, oBtrieve, BtrvU2, GlobList, VarConst,
     Varrec2u, GlobVar, oVAT100BtrieveFile, ExceptIntf;

const
  // Client ID constants (see oBtrieve.pas)
  VAT_100_ID_GENERAL = 55;
  VAT_100_ID_ADD     = 56;
  VAT_100_ID_UPDATE  = 57;
  VAT_100_ID_CLONE   = 58;

type
  TVAT100 = class(TAutoIntfObjectEx, IBtrieveFunctions, IBtrieveFunctions2, IVAT100)
  private
    FToolkit : TObject;
    FClientID: Integer;
    FVAT100File: TVAT100BtrieveFile;
    FRecPosition : LongInt;          // Saved Record Position
    FIntfType: TInterfaceMode;
  protected
    function Get_vatCorrelationId: WideString; safecall;
    procedure Set_vatCorrelationId(const Value: WideString); safecall;
    function Get_vatIRMark: WideString; safecall;
    procedure Set_vatIRMark(const Value: WideString); safecall;
    function Get_vatDateSubmitted: WideString; safecall;
    procedure Set_vatDateSubmitted(const Value: WideString); safecall;
    function Get_vatDocumentType: WideString; safecall;
    procedure Set_vatDocumentType(const Value: WideString); safecall;
    function Get_vatPeriod: WideString; safecall;
    procedure Set_vatPeriod(const Value: WideString); safecall;
    function Get_vatUserName: WideString; safecall;
    procedure Set_vatUserName(const Value: WideString); safecall;
    function Get_vatStatus: Smallint; safecall;
    procedure Set_vatStatus(Value: Smallint); safecall;
    function Get_vatPollingInterval: Integer; safecall;
    procedure Set_vatPollingInterval(Value: Integer); safecall;
    function Get_vatDueOnOutputs: Double; safecall;
    procedure Set_vatDueOnOutputs(Value: Double); safecall;
    function Get_vatDueOnECAcquisitions: Double; safecall;
    procedure Set_vatDueOnECAcquisitions(Value: Double); safecall;
    function Get_vatTotal: Double; safecall;
    procedure Set_vatTotal(Value: Double); safecall;
    function Get_vatReclaimedOnInputs: Double; safecall;
    procedure Set_vatReclaimedOnInputs(Value: Double); safecall;
    function Get_vatNet: Double; safecall;
    procedure Set_vatNet(Value: Double); safecall;
    function Get_vatNetSalesAndOutputs: Double; safecall;
    procedure Set_vatNetSalesAndOutputs(Value: Double); safecall;
    function Get_vatNetPurchasesAndInputs: Double; safecall;
    procedure Set_vatNetPurchasesAndInputs(Value: Double); safecall;
    function Get_vatNetECSupplies: Double; safecall;
    procedure Set_vatNetECSupplies(Value: Double); safecall;
    function Get_vatNetECAcquisition: Double; safecall;
    procedure Set_vatNetECAcquisition(Value: Double); safecall;
    function Get_vatHMRCNarrative: WideString; safecall;
    procedure Set_vatHMRCNarrative(const Value: WideString); safecall;
    function Get_vatNotifyEmail: WideString; safecall;
    procedure Set_vatNotifyEmail(const Value: WideString); safecall;
    function Get_vatPollingURL: WideString; safecall;
    procedure Set_vatPollingURL(const Value: WideString); safecall;

    function Add: IVAT100; safecall;
    function Clone: IVAT100; safecall;
    procedure CloneDetails (const VAT100Details: VAT100RecType);
    function Update: IVAT100; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function Delete: Integer; safecall;

    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function Get_Index: Integer; safecall;
    procedure Set_Index(Value: Integer); safecall;
    function Get_KeyString2: WideString; safecall;

    function AuthoriseFunction (const FuncNo     : Byte;
                                const MethodName : String;
                                const AccessType : Byte = 0) : Boolean;

    function ValidateSave : Integer;

  public
    constructor Create (const IType: TInterfaceMode; const Toolkit: TObject; const ClientID: integer);
    destructor Destroy; override;
  end;

implementation

uses ComServ, oBtrieveFile;

// =============================================================================
// TVAT100
// =============================================================================

constructor TVAT100.Create(const IType: TInterfaceMode; const Toolkit: TObject; const ClientID: integer);
begin
  inherited Create (ComServer.TypeLib, IBtrieveFunctions);
  FIntfType := IType;
  FClientID := ClientID;
  FVAT100File := TVAT100BtrieveFile.Create(ClientID);
  FVAT100File.OpenFile(SetDrive + VAT100FileName);
end;

// -----------------------------------------------------------------------------

destructor TVAT100.Destroy;
begin
  FVAT100File.CloseFile;
  FreeAndNil(FVAT100File);
  inherited;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_Index: Integer;
begin
  Result := Ord(FVAT100File.Index);
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_KeyString2: WideString;
begin
  Result := FVAT100File.SearchKey;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_Position: Integer;
begin
  Result := FRecPosition;
end;

// -----------------------------------------------------------------------------

function TVAT100.GetEqual(const SearchKey: WideString): Integer;
begin
  Result := FVAT100File.GetEqual(SearchKey);
end;

// -----------------------------------------------------------------------------

function TVAT100.GetFirst: Integer;
begin
  Result := FVAT100File.GetFirst;
end;

// -----------------------------------------------------------------------------

function TVAT100.GetGreaterThan(const SearchKey: WideString): Integer;
begin
  Result := FVAT100File.GetGreaterThan(SearchKey);
end;

// -----------------------------------------------------------------------------

function TVAT100.GetGreaterThanOrEqual(
  const SearchKey: WideString): Integer;
begin
  Result := FVAT100File.GetGreaterThanOrEqual(SearchKey);
end;

// -----------------------------------------------------------------------------

function TVAT100.GetLast: Integer;
begin
  Result := FVAT100File.GetLast;
end;

// -----------------------------------------------------------------------------

function TVAT100.GetLessThan(const SearchKey: WideString): Integer;
begin
  Result := FVAT100File.GetLessThan(SearchKey);
end;

// -----------------------------------------------------------------------------

function TVAT100.GetLessThanOrEqual(const SearchKey: WideString): Integer;
begin
  Result := FVAT100File.GetLessThanOrEqual(SearchKey);
end;

// -----------------------------------------------------------------------------

function TVAT100.GetNext: Integer;
begin
  Result := FVAT100File.GetNext;
end;

// -----------------------------------------------------------------------------

function TVAT100.GetPrevious: Integer;
begin
  Result := FVAT100File.GetPrevious;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatCorrelationId: WideString;
begin
  Result := FVAT100File.Rec.vatCorrelationID;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatDateSubmitted: WideString;
begin
  Result := FVAT100File.Rec.vatDateSubmitted;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatDocumentType: WideString;
begin
  Result := FVAT100File.Rec.vatDocumentType;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatDueOnECAcquisitions: Double;
begin
  Result := FVAT100File.Rec.vatDueOnECAcquisitions;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatDueOnOutputs: Double;
begin
  Result := FVAT100File.Rec.vatDueOnOutputs;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatHMRCNarrative: WideString;
begin
  Result := FVAT100File.Rec.vatHMRCNarrative;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatIRMark: WideString;
begin
  Result := FVAT100File.Rec.vatIRMark;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatNet: Double;
begin
  Result := FVAT100File.Rec.vatNet;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatNetECAcquisition: Double;
begin
  Result := FVAT100File.Rec.vatNetECAcquisition;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatNetECSupplies: Double;
begin
  Result := FVAT100File.Rec.vatNetECSupplies;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatNetPurchasesAndInputs: Double;
begin
  Result := FVAT100File.Rec.vatNetPurchasesAndInputs;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatNetSalesAndOutputs: Double;
begin
  Result := FVAT100File.Rec.vatNetSalesAndOutputs;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatNotifyEmail: WideString;
begin
  Result := FVAT100File.Rec.vatNotifyEmail;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatPeriod: WideString;
begin
  Result := FVAT100File.Rec.vatPeriod;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatPollingInterval: Integer;
begin
  Result := FVAT100File.Rec.vatPollingInterval;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatReclaimedOnInputs: Double;
begin
  Result := FVAT100File.Rec.vatReclaimedOnInputs;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatStatus: Smallint;
begin
  Result := FVAT100File.Rec.vatStatus;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatTotal: Double;
begin
  Result := FVAT100File.Rec.vatTotal;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatUserName: WideString;
begin
  Result := FVAT100File.Rec.vatUserName;
end;

// -----------------------------------------------------------------------------

function TVAT100.Get_vatPollingURL: WideString;
begin
  Result := FVAT100File.Rec.vatPollingURL;
end;

// -----------------------------------------------------------------------------

function TVAT100.RestorePosition: Integer;
begin
  Set_Position(FRecPosition);
end;

// -----------------------------------------------------------------------------

function TVAT100.SavePosition: Integer;
begin
  FVAT100File.GetPosition(FRecPosition);
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_Index(Value: Integer);
begin
  FVAT100File.Index := TVAT100Index(Value);
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_Position(Value: Integer);
begin
  FVAT100File.RestorePosition(Value);
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatCorrelationId(const Value: WideString);
begin
  with FVAT100File.Rec do
    vatCorrelationID := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatDateSubmitted(const Value: WideString);
begin
  with FVAT100File.Rec do
    vatDateSubmitted := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatDocumentType(const Value: WideString);
begin
  with FVAT100File.Rec do
    vatDocumentType := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatDueOnECAcquisitions(Value: Double);
begin
  with FVAT100File.Rec do
    vatDueOnECAcquisitions := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatDueOnOutputs(Value: Double);
begin
  with FVAT100File.Rec do
    vatDueOnOutputs := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatHMRCNarrative(const Value: WideString);
var
  Buffer: AnsiString;
  BytesToCopy: Integer;
begin
  Buffer := Value;
  BytesToCopy := Length(Buffer);
  if (BytesToCopy > SizeOf(FVAT100File.Rec.vatHMRCNarrative)) then
    BytesToCopy := SizeOf(FVAT100File.Rec.vatHMRCNarrative);

  with FVAT100File.Rec do
    Move(Buffer[1], vatHMRCNarrative[0], BytesToCopy);
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatIRMark(const Value: WideString);
begin
  with FVAT100File.Rec do
    vatIRMark := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatNet(Value: Double);
begin
  with FVAT100File.Rec do
    vatNet := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatNetECAcquisition(Value: Double);
begin
  with FVAT100File.Rec do
    vatNetECAcquisition := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatNetECSupplies(Value: Double);
begin
  with FVAT100File.Rec do
    vatNetECSupplies := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatNetPurchasesAndInputs(Value: Double);
begin
  with FVAT100File.Rec do
    vatNetPurchasesAndInputs := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatNetSalesAndOutputs(Value: Double);
begin
  with FVAT100File.Rec do
    vatNetSalesAndOutputs := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatNotifyEmail(const Value: WideString);
begin
  with FVAT100File.Rec do
    vatNotifyEmail := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatPeriod(const Value: WideString);
begin
  with FVAT100File.Rec do
    vatPeriod := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatPollingInterval(Value: Integer);
begin
  with FVAT100File.Rec do
    vatPollingInterval := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatReclaimedOnInputs(Value: Double);
begin
  with FVAT100File.Rec do
    vatReclaimedOnInputs := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatStatus(Value: Smallint);
begin
  with FVAT100File.Rec do
    vatStatus := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatTotal(Value: Double);
begin
  with FVAT100File.Rec do
    vatTotal := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatUserName(const Value: WideString);
begin
  with FVAT100File.Rec do
    vatUserName := Value;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Set_vatPollingURL(const Value: WideString);
begin
  with FVAT100File.Rec do
    vatPollingURL := Value;
end;

// -----------------------------------------------------------------------------

function TVAT100.Add: IVAT100;
begin
  AuthoriseFunction(100, 'Add');
  Result := TVAT100.Create(imAdd, FToolkit, VAT_100_ID_ADD);
end;

// -----------------------------------------------------------------------------

function TVAT100.AuthoriseFunction(const FuncNo: Byte;
  const MethodName: String; const AccessType: Byte): Boolean;
begin
  case FuncNo of
    5..99     : Result := (FIntfType = imGeneral);

    // .Add method
    100       : Result := (FIntfType = imGeneral);

    // .Update method
    101       : Result := (FIntfType = imGeneral);

    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate]);

    // .Cancel method
    103       : Result := (FIntfType = imUpdate);

    // .Clone method
    104       : Result := (FIntfType = imGeneral);

    // .Delete method
    105       : Result := (FIntfType = imGeneral);

    else
       Result := False;
  end; // case FuncNo of...

  if (not Result) then
  begin
    if (AccessType = 0) then
      // Method
      raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    else
      // Property
      raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  end; // if (not Result)...
end;

// -----------------------------------------------------------------------------

procedure TVAT100.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');
  FVAT100File.Unlock;
end;

// -----------------------------------------------------------------------------

function TVAT100.Clone: IVAT100;
var
  VAT100Clone: TVAT100;
Begin
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new object and initialise
  VAT100Clone := TVAT100.Create(imClone, FToolkit, VAT_100_ID_CLONE);
  VAT100Clone.CloneDetails(FVAT100File.Rec);

  Result := VAT100Clone;
end;

// -----------------------------------------------------------------------------

function TVAT100.Delete: Integer;
begin
  AuthoriseFunction(105, 'Delete');
  Result := FVAT100File.Delete;
end;

// -----------------------------------------------------------------------------

function TVAT100.Save: Integer;
begin
  AuthoriseFunction(102, 'Save');
  if FIntfType = imAdd then
    Result := FVAT100File.Insert
  else
    Result := FVAT100File.Update;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;
end;

// -----------------------------------------------------------------------------

function TVAT100.Update: IVAT100;
var
  VAT100Update: TVAT100;
  RecAddr: LongInt;
begin
  AuthoriseFunction(101, 'Update');
  VAT100Update := TVAT100.Create(imUpdate, FToolkit, VAT_100_ID_UPDATE);
  VAT100Update.CloneDetails(FVAT100File.Rec);

  // Position VAT100Update on to the correct record
  FVAT100File.GetPosition(RecAddr);
  VAT100Update.FVAT100File.RestorePosition(RecAddr);

  if (VAT100Update.FVAT100File.Lock = 0) then
    Result := VAT100Update
  else
  begin
    // ShowMessage('Lock failed: ' + IntToStr(VAT100Update.FVAT100File.Lock));
    // Result := VAT100Update;
    FreeAndNil(VAT100Update);
    Result := nil;
  end;
end;

// -----------------------------------------------------------------------------

function TVAT100.ValidateSave: Integer;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

procedure TVAT100.CloneDetails(const VAT100Details: VAT100RecType);
begin
  FVAT100File.Rec := VAT100Details;
end;

// -----------------------------------------------------------------------------

end.

