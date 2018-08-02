unit TransactionHelperU;

interface

uses GlobVar, VarConst;

type
  InvRecPtr = ^InvRec;

  //------------------------------

  ITransactionHelper_Interface = interface
    ['{83BF1518-6946-4B73-8444-9C8FAEB9D327}']
    // Private methods to implement properties
    Function GetSettlementDiscountSupported : Boolean;

    // Public Properties
    Property SettlementDiscountSupported : Boolean Read GetSettlementDiscountSupported;

    // Public methods
    function GetOriginatorHint: string;
  end;

  //------------------------------

// Globally-accessible function to return a Transaction Helper instance
function TransactionHelper(InvR: InvRecPtr): ITransactionHelper_Interface;

// Returns TRUE if the specified date is before the cut-off date (01/04/2015)
Function SettlementDiscountSupportedForDate (Const TheDate : LongDate) : Boolean;

//Returns TRUE if the doc type is one that can have settlment discount
function DocTypeCanHaveSettlementDiscount(ADocType : DocTypes) : Boolean;

implementation

uses SysUtils, ETDateU;

type
  // Implementation of ITransactionHelper_Interface
  TTransactionHelper = class(TInterfacedObject, ITransactionHelper_Interface)
  private
    FInv: InvRecPtr;

    // ITransactionHelper_Interface methods
    Function GetSettlementDiscountSupported : Boolean;
  public
    procedure SetInv(InvR: InvRecPtr);
    function GetOriginatorHint: string;
    function GetFormattedTime(TimeStr: string; IncludeSeconds: Boolean = False): string;
  end;

//=========================================================================

// Returns TRUE if the specified date is before the cut-off date (01/04/2015)
Function SettlementDiscountSupportedForDate (Const TheDate : LongDate) : Boolean;
Begin // SettlementDiscountSupportedForDate
  // If date is not set then assume it is after the cut-off date
  Result := (TheDate <> '') And (TheDate < '20150401');
End; // SettlementDiscountSupportedForDate

//=========================================================================

function TransactionHelper(InvR: InvRecPtr): ITransactionHelper_Interface;
var
  FHelper: TTransactionHelper;
begin
  // Create the Transaction Helper instance and assign the InvRec pointer
  FHelper := TTransactionHelper.Create;
  FHelper.SetInv(InvR);
  Result := FHelper;
end;

//=========================================================================

{ TTransactionHelper }
function TTransactionHelper.GetFormattedTime(TimeStr: string; IncludeSeconds: Boolean): string;
// Returns TimeStr converted to the format 'HH:MM' (or 'HH:MM:SS' if
// IncludeSeconds is True. TimeStr is expected to be in the format 'HHMM' or
// 'HHMMSS'.
var
  Hours: string;
  Minutes: string;
  Seconds: string;
begin
  Hours := Copy(TimeStr, 1, 2);
  if (Trim(Hours) = '') then
   Hours := '00';

  Minutes := Copy(TimeStr, 3, 2);
  if (Trim(Minutes) = '') then
    Minutes := '00';

  Result := Hours + ':' + Minutes;

  if IncludeSeconds then
  begin
    Seconds := Copy(TimeStr, 5, 2);
    if (Trim(Seconds) = '') then
      Seconds := '00';

    Result := Result + ':' + Seconds;
  end;
end;

function TTransactionHelper.GetOriginatorHint: string;
begin
  Result := 'Added by ' + Trim(FInv.thOriginator) + ' on ' +
            POutDate(FInv.thCreationDate) + ' at ' +
            GetFormattedTime(FInv.thCreationTime);
end;

procedure TTransactionHelper.SetInv(InvR: InvRecPtr);
begin
  FInv := InvR;
end;

//-------------------------------------------------------------------------

// MH 20/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
Function TTransactionHelper.GetSettlementDiscountSupported : Boolean;
Begin // GetSettlementDiscountSupported
  Result := SettlementDiscountSupportedForDate (FInv^.TransDate);
End; // GetSettlementDiscountSupported

//-------------------------------------------------------------------------

//PR: 25/02/2015 ABSEXCH-15298 Return TRUE if ADocType can have settlement discount
function DocTypeCanHaveSettlementDiscount(ADocType : DocTypes) : Boolean;
begin
  Result := ADocType in [SOR, SIN, SQU, SCR, SJI, SJC, SRN, SRI, SRF, SDN,
                         POR, PIN, PCR, PQU, PJI, PJC, PRN, PPI, PRF, PDN];
end;

//-------------------------------------------------------------------------

end.
