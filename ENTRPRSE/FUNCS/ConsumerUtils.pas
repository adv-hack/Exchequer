unit ConsumerUtils;
{Unit for consumer specific functions & constants}
interface

uses
  SysUtils, Classes, GlobVar, VarConst,
  oBtrieveFile; // Entrprse\MultComp - Btrieve File Object

const
  CONSUMER_CHAR   = 'U'; //Consumer subtype character
  CUSTOMER_CHAR   = 'C';
  SUPPLIER_CHAR   = 'S';

  CONSUMER_PREFIX = '_'; //Prefix for consumer short codes
  CONSUMER_NAME   = 'Consumer';

  // Constants which map to the tab pages on the Trader List
  CUSTOMER_TYPE = 0;
  CONSUMER_TYPE = 1;
  SUPPLIER_TYPE = 2;

  AcTypePrefix : Array[CUSTOMER_TYPE..SUPPLIER_TYPE] of Char = (CUSTOMER_CHAR, CONSUMER_CHAR, SUPPLIER_CHAR);


type
  //Enumeration to govern if and how consumers are shown in a pop-up customer/supplier search list
  TConsumerMode = (cmDontShow, cmShowShortCode, cmShowLongCode);

{ Trader Type routines }

//Returns the sub-type char ('C', 'U', 'S') from the trader type (0, 1, 2)
function SubTypeFromTraderType(TraderType: Byte): Char;

//Returns the name of the trader type (Customer, Supplier, Consumer)
function TraderTypeNameFromSubType(SubType : Char) : string;

//Returns 6-char trader code or 30-char consumer code as appropriate
function TraderCodeToShow(ConsumerMode : TConsumerMode; ACust : CustRec) : string;

//Returns Trader type (0, 1, 2) from the subtype ('C', 'U', 'S')
function TraderTypeFromSubType(SubType : Char) : Byte;

//Returns true if the customer record is a consumer
function IsConsumer(const ACust : CustRec) : Boolean;


{ Base-26 Conversion (for Consumer codes) }

// Converts LongNum to a Base-26 string, and stores the result in Code. Returns
// False if the conversion fails.
function ToBase26(const LongNum: LongInt; var Code: ShortString): Boolean;

// Converts a Base-26 number to an integer, and stores the result in LongNum.
// Returns false if the conversion fails.
function FromBase26(const Code: ShortString; var LongNum: LongInt): Boolean;

// Increments the Base-26 number supplied in Code, and stores the result
// in NextCode. Returns False if there are errors.
function IncBase26(const Code: ShortString; var NextCode: ShortString): Boolean;

{ Consumer Code routines }

// Returns the next sequential Consumer code.
function NextConsumerCode: ShortString;

//Returns True if there are any consumer records in the database
function AreThereAnyConsumers : Boolean;

{ Trader Cache }

type
  // Simple wrapper for the Consumer details
  TCodeWrapper = class(TObject)
  public
    CharValue: Char;
    CodeValue: AnsiString;
    constructor Create(WithChar: Char; WithCode: AnsiString = '');
  end;

  //------------------------------

  TCustSuppBtrieveFile = Class(TBaseBtrieveFile)
  Private
    // Internal typed data buffer for btrieve access
    FCustSuppRec : CustRec;
  Protected
    Function GetRecordPointer : Pointer;
  Public
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property CustSuppRec : CustRec Read FCustSuppRec Write FCustSuppRec;

    Constructor Create;
  End; // TCustSuppBtrieveFile

  //------------------------------

  // Maintains a cache of Trader codes and their sub-types, so that the sub-type
  // can quickly be retrieved without having to search the database every time
  // it is required
  TTraderCache = class(TObject)
  private
    FIncludeLongCode: Boolean;
    // Stringlist to store trader codes and subtypes
    FCache: TStringList;
    FCustSuppFile : TCustSuppBtrieveFile;
    // Returns the TCodeWrapper for the supplied Trader, retrieving the details
    // from the cache or the actual database, and adding it to the cache if it
    // was not previously recorded there
    function GetEntry(CustCode: string): TCodeWrapper;
  public
    constructor Create(IncludeLongCode: Boolean = False);
    destructor Destroy; override;
    // Returns the subtype of the supplied Trader, retrieving it either from
    // the cache or the actual database, and adding it to the cache if it was
    // not previously recorded there
    function GetSubType(CustCode: string): Char;
    // Returns the Long Code of the supplied Trader, retrieving it either from
    // the cache or the actual database, and adding it to the cache if it was
    // not previously recorded there
    function GetLongCode(CustCode: string): AnsiString;
    // This returns the Long Code if the supplied Trader is a Consumer,
    // otherwise it returns the short code (i.e. the code that was passed in).
    function GetCode(CustCode: string): AnsiString;
  end;

implementation

uses SavePos, BtrvU2, BTKeys1U, BtSupU1;

const
  { Constants for Base-26 conversion }
  B26Power1  = 26;
  B26Power2  = 26 * 26;
  B26Power3  = 26 * 26 * 26;
  B26Power4  = 26 * 26 * 26 * 26;
  B26Power5  = 26 * 26 * 26 * 26 * 26;

  B26Set   = ['2', '5'..'9', 'B'..'D', 'F'..'H', 'J'..'N', 'P'..'T', 'V'..'X', 'Z'];

  B26Str = '256789BCDFGHJKLMNPQRSTVWXZ';

// =============================================================================
// Base-26 Conversion routines
// =============================================================================

// Private helper function for Base-26 conversion routines
function CharToB26(const TheChar: Char): LongInt;
begin
  Result := Pos(TheChar, B26Str) - 1;
end;

function ToBase26(const LongNum: LongInt; var Code: ShortString): Boolean;
var
  CalcNum, I : LongInt;
begin
  Code := '22222';
  Result := False;

  if (LongNum >= 0) And (LongNum < B26Power5) then
  begin
    CalcNum := LongNum;

    if (CalcNum >= B26Power4) then
    begin
      I := CalcNum div B26Power4;
      Code[1] := B26Str[I+1];
      CalcNum := CalcNum mod B26Power4;
    end;

    if (CalcNum >= B26Power3) then
    begin
      I := CalcNum div B26Power3;
      Code[2] := B26Str[I+1];
      CalcNum := CalcNum mod B26Power3;
    end;

    if (CalcNum >= B26Power2) then
    begin
      I := CalcNum div B26Power2;
      Code[3] := B26Str[I+1];
      CalcNum := CalcNum mod B26Power2;
    end;

    if (CalcNum >= B26Power1) then
    begin
      I := CalcNum div B26Power1;
      Code[4] := B26Str[I+1];
      CalcNum := CalcNum mod B26Power1;
    end;

    if (CalcNum >= 0) and (CalcNum < 26) then
    begin
      Code[5] := B26Str[CalcNum+1];
      Result := True;
    end
    else
      Result := False;
  end;

end;

function FromBase26(const Code: ShortString; var LongNum: LongInt): Boolean;
begin
  Result := False;
  LongNum := 0;

  if (Length(Code) = 5) then
  begin
    if (Code[1] in B26Set) and (Code[2] in B26Set) and (Code[3] in B26Set) and (Code[4] in B26Set) and (Code[5] in B26Set) then
    begin
       LongNum :=           (CharToB26 (Code[1]) * B26Power4);
       LongNum := LongNum + (CharToB26 (Code[2]) * B26Power3);
       LongNum := LongNum + (CharToB26 (Code[3]) * B26Power2);
       LongNum := LongNum + (CharToB26 (Code[4]) * B26Power1);
       LongNum := LongNum + (CharToB26 (Code[5]));
       Result := True;
    end;
  end;

end;

function IncBase26(const Code: ShortString; var NextCode: ShortString): Boolean;
var
  Number: Integer;
begin
  Result := FromBase26(Code, Number);
  if Result then
  begin
    Number := Number + 1;
    Result := ToBase26(Number, NextCode);
  end;
end;

// =============================================================================
// Consumer Code routines
// =============================================================================

function NextConsumerCode: ShortString;
var
  LastUsedCode: ShortString;
  FuncRes: LongInt;
  KeyPath: Integer;
  Key: Str255;
  CodeOK : Boolean;
begin
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveDataBlock(@Cust, SizeOf(Cust));
      SaveFilePosition (CustF, GetPosKey);

      // Find the last Consumer code
      Key := 'U_ZZZZZ';
      KeyPath := CustACCodeK;
      FuncRes := Find_Rec(B_GetLessEq, F[CustF], CustF, RecPtr[CustF]^, KeyPath, Key);

      // Increment it and return the new code
      if (FuncRes = 0) and (Cust.acSubType = 'U') then
      begin
        LastUsedCode := Cust.CustCode;
        // Strip off the underscore to get a valid Base-26 string...
        LastUsedCode := Copy(LastUsedCode, 2, 5);

        //PR: 06/12/2013 Add check for existing customer or supplier acCode
        repeat
          // ...increment the result...
          if ConsumerUtils.IncBase26(LastUsedCode, Result) then
            // ...and prepend the underscore to get the new code
            Result := '_' + Result
          else
            raise Exception.Create('Invalid Consumer code: ' + Key);

          //Check if code exists as customer or supplier acCode
          CodeOK := not CheckRecExsists(Result, CustF, CustCodeK);

          if not CodeOK then //code already exists, so go round again
            LastUsedCode := Copy(Result, 2, 5);

        until CodeOK;
      end
      else if (FuncRes in [4, 9]) or (Cust.acSubType <> 'U') then
        // No Consumers found, so use the first Consumer code
        Result := '_22222'
      else
        // Something is seriously wrong
        raise Exception.Create('Unexpected error searching Consumer records: ' + IntToStr(FuncRes));

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock(@Cust);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
end;


// =============================================================================
// Trader Type routines
// =============================================================================
//Returns the sub-type char ('C', 'U', 'S') from the trader type (0, 1, 2)
function SubTypeFromTraderType(TraderType: Byte): Char;
begin
  case TraderType of
    0: Result := 'C';
    1: Result := 'U';
    2: Result := 'S';
  else
    Result := #0;
  end;
end;

//Returns the name of the trader type (Customer, Supplier, Consumer)
function TraderTypeNameFromSubType(SubType : Char) : string;
begin
  if (SubType = CONSUMER_CHAR) then
    Result := CONSUMER_NAME
  else
    Result := TradeType[Subtype = 'C'];
end;

//Returns 6-char trader code or 30-char consumer code as appropriate
function TraderCodeToShow(ConsumerMode : TConsumerMode; ACust : CustRec) : string;
begin
  if IsConsumer(ACust) and (ConsumerMode = cmShowLongCode) then
    Result := ACust.acLongACCode
  else
    Result := ACust.CustCode;
end;

//Returns Trader type (0, 1, 2) from the subtype ('C', 'U', 'S')
function TraderTypeFromSubType(SubType : Char) : Byte;
begin
  Case SubType of
    CUSTOMER_CHAR  : Result := CUSTOMER_TYPE;
    CONSUMER_CHAR  : Result := CONSUMER_TYPE;
    SUPPLIER_CHAR  : Result := SUPPLIER_TYPE;
    else
      Result := CUSTOMER_TYPE;
  end;
end;

//Returns true if the customer record is a consumer
function IsConsumer(const ACust : CustRec) : Boolean;
begin
  Result := ACust.acSubtype = CONSUMER_CHAR;
end;

//Returns True if there are any consumer records in the database
function AreThereAnyConsumers : Boolean;
var
  FuncRes: LongInt;
  KeyPath: Integer;
  Key: Str255;
begin
  With TBtrieveSavePosition.Create Do
  Try
    // Save the current position in the file for the current key
    SaveDataBlock(@Cust, SizeOf(Cust));
    SaveFilePosition (CustF, GetPosKey);

    // Find the first consumer code if any
    Key := 'U';
    KeyPath := CustACCodeK;
    FuncRes := Find_Rec(B_GetGEq, F[CustF], CustF, RecPtr[CustF]^, KeyPath, Key);

    Result := (FuncRes = 0) and IsConsumer(Cust);

    // Restore position in file
    RestoreSavedPosition;
    RestoreDataBlock(@Cust);
  Finally
    Free;
  End; // Try..Finally

end;


// =============================================================================
// TTraderCache
// =============================================================================

constructor TTraderCache.Create(IncludeLongCode: Boolean);
Var
  Res : Integer;
begin
  inherited Create;

  FIncludeLongCode := IncludelongCode;
  FCache := TStringList.Create;

  // Use a Btrieve File object in order to access the customer/supplier/consumer table
  // in order to avoid problems in threads with changing the global Cust record - this
  // will also mean we don't need to Save/Restore positions/data which should improve
  // performance
  FCustSuppFile := TCustSuppBtrieveFile.Create;
  Res := FCustSuppFile.OpenFile (SetDrive + Filenames[CustF], False, V600Owner, -2); // Read-only mode
  If (Res <> 0) Then
    // Error - what do we do now? Can't display a message as this can be used from a thread
    Raise Exception.Create ('TTraderCache.Create: Error opening ' + SetDrive + Filenames[CustF] + ': ' + IntToStr(Res));
end;

destructor TTraderCache.Destroy;
var
  i: Integer;
begin
  // Shutdown the Btrieve File object
  If Assigned(FCustSuppFile) Then
  Begin
    FCustSuppFile.CloseFile;
    FreeAndNIL(FCustSuppFile);
  End; // If Assigned(FCustSuppFile)

  // Free any TCodeWrapper instances
  for i := FCache.Count - 1 downto 0 do
    FCache.Objects[i].Free;

  FreeAndNil(FCache);
  inherited;
end;

function TTraderCache.GetCode(CustCode: string): AnsiString;
var
  Wrapper: TCodeWrapper;
begin
  // Get the details for the supplied Trader
  Wrapper := GetEntry(CustCode);
  if (Wrapper = nil) then
    // No entry found against the supplied code
    Result := ''
  else
    if TraderTypeFromSubType(Wrapper.CharValue) = CONSUMER_TYPE then
      Result := Wrapper.CodeValue
    else
      Result := CustCode;
end;

function TTraderCache.GetEntry(CustCode: string): TCodeWrapper;
var
  Entry: Integer;
  FuncRes: LongInt;
  LongCode: AnsiString;
begin
  // Look for a cached Trader entry
  Entry := FCache.IndexOf(CustCode);
  if (Entry = -1) then
  begin
    // Entry not found in the cache, so search for the actual record
    FuncRes := FCustSuppFile.GetEqual(FullCustCode(CustCode));
    If (FuncRes = 0) Then
    Begin
      // Retrieve the Long Code, if required
      if FIncludeLongCode then
        LongCode := FCustSuppFile.CustSuppRec.acLongACCode
      else
        LongCode := '';

      // Store the code and the sub-type in the cache
      Result := TCodeWrapper.Create(FCustSuppFile.CustSuppRec.acSubType, LongCode);
      FCache.AddObject(FCustSuppFile.CustSuppRec.CustCode, Result);
    End // if (FuncRes = 0)
    Else
      // No record found
      Result := nil;
  end
  else
    // Return the details from the cache entry
    Result := TCodeWrapper(FCache.Objects[Entry]);
end;

function TTraderCache.GetLongCode(CustCode: string): AnsiString;
var
  Wrapper: TCodeWrapper;
begin
  // Get the details for the supplied Trader
  Wrapper := GetEntry(CustCode);
  if (Wrapper = nil) then
    // No entry found against the supplied code
    Result := ''
  else
    // Return the Long Account Code
    Result := Wrapper.CodeValue;
end;

function TTraderCache.GetSubType(CustCode: string): Char;
var
  Wrapper: TCodeWrapper;
begin
  // Get the details for the supplied Trader
  Wrapper := GetEntry(CustCode);
  if (Wrapper = nil) then
    // No entry found against the supplied code
    Result := #0
  else
    // Return the Subtype
    Result := Wrapper.CharValue;
end;

//=========================================================================

{ TCodeWrapper }
constructor TCodeWrapper.Create(WithChar: Char; WithCode: AnsiString);
begin
  inherited Create;
  CharValue := WithChar;
  CodeValue  := WithCode;
end;

//=========================================================================

Constructor TCustSuppBtrieveFile.Create;
Begin // Create
  Inherited Create;

  // Link in data record
  FDataRecLen := SizeOf(FCustSuppRec);
  FDataRec := @FCustSuppRec;

  FIndex := CustCodeK;
End; // Create

//-------------------------------------------------------------------------

Function TCustSuppBtrieveFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//=========================================================================


end.
