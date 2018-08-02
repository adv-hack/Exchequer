unit oConvert;
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  ComObj, ActiveX, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, Contnrs, VarCnst3,
  ExceptIntf;

const
  //PR: 08/05/2013 ABSEXCH-14195 Array of SPOP transactions - not allowed to use on either
  //                             end of a conversion unless SPOP licenced.
  SPOPGroup = [dtPDN, dtPOR, dtSDN, dtSOR];


type

  TConvert = Class(TAutoIntfObjectEx, IConvert)
  private
    FDataRec : TBatchConvRec;
    FStartTransI, FEndTransI : ITransaction;
    FTrans : ITransaction;
    FIndex : Integer;
  private
    procedure GetClones;
    procedure InitObjects;
  protected
    function Get_cvStartTransaction: WideString; safecall;
    function Get_cvProcessed: Integer; safecall;
    function Get_cvEndTransaction: WideString; safecall;
    function Get_cvStartTransactionI: ITransaction; safecall;
    function Get_cvEndTransactionI: ITransaction; safecall;
  public
    //PR: 26/03/2009 When using late binding descendent object TSingleConvert was only implementing IConvert. Changed create method on TConvert
    //to allow correct interface to be passsed in.
    constructor Create(const DispIntf: TGUID);
//    constructor Create;
    Destructor Destroy; override;
    procedure SetDetails(const DataRec : TBatchConvRec);
    procedure Write(P : Pointer);
    procedure Read(P : Pointer);
    property Transaction : ITransaction read FTrans write FTrans;
    property IndexPos : Integer read FIndex write FIndex;
  end;

  TSingleConvert = Class(TConvert, ISingleConvert, IConversionLibrary)
  private
    FToolkit : TObject;
    FLibraryLoaded : Boolean;
    function CheckConvert(Mode : Byte) : integer;
  protected
    function Check: Integer; safecall;
    function Execute: Integer; safecall;
    //IConversionLibrary 24/11/2011
    procedure Finalize; safecall;
  public
    Constructor Create(Toolkit : TObject);
    Destructor Destroy; override;
  end;


  TConvertList = Class(TAutoIntfObjectEx, IConvertList, IConvertList2, IConversionLibrary)
  private
    FList : TObjectList;
    FConsolidate : Boolean;
    FTransTypeTo : TDocTypes;
    FMemPointer : Pointer;
    FTrans : ITransaction;
    FToolkit : TObject;
    FInterfaceArray : Array of IConvert;
    FDate : String;

    FLibraryLoaded : Boolean;
    procedure ListToMem;
    procedure MemToList;
    function CheckConvert(var Prob : Integer; Mode : Byte) : integer;
  protected
    function Get_clConversions(Index: Integer): IConvert; safecall;
    function Get_clCount: Integer; safecall;
    procedure Add(const OurRef: WideString); safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Clear; safecall;
    function Check(var ProblemIndex: Integer): Integer; safecall;
    function Execute: Integer; safecall;
    function Get_clConsolidate: WordBool; safecall;
    procedure Set_clConsolidate(Value: WordBool); safecall;
    function Get_clDate: WideString; safecall;
    procedure Set_clDate(const Value: WideString); safecall;

    //IConversionLibrary 24/11/2011
    procedure Finalize; safecall;
  public
    Constructor Create(TransType : TDocTypes; Trans : ITransaction; Toolkit : TObject);
    Destructor Destroy; override;
  end;



function DocToOk(const OurRef : String; TypeTo : TDocTypes) : Boolean;

implementation

uses
  ComServ, SysUtils, SpDlIntf, MiscFunc, SpDllErr, GlobVar, oToolkit, Crypto, Dialogs,
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  MadExcept;

type
  ConvTypeRec = Record
    FromType  : string[3];
    ToType    : string[3];
    Mode      : SmallInt;
    Func      : SmallInt;
  end;


const
  MaxConvTypes = 10;


  ConvTypes : Array[1..MaxConvTypes] of ConvTypeRec = (
                 (FromType : 'PQU'; ToType : 'POR'; Mode : 14; Func : 1),
                 (FromType : 'SQU'; ToType : 'SOR'; Mode : 14; Func : 1),
                 (FromType : 'PQU'; ToType : 'PIN'; Mode : 6; Func : 1),
                 (FromType : 'SQU'; ToType : 'SIN'; Mode : 6; Func : 1),
                 (FromType : 'POR'; ToType : 'PDN'; Mode : 1; Func : 2),
                 (FromType : 'SOR'; ToType : 'SDN'; Mode : 1; Func : 2),
                 (FromType : 'POR'; ToType : 'PIN'; Mode : 3; Func : 2),
                 (FromType : 'SOR'; ToType : 'SIN'; Mode : 3; Func : 2),
                 (FromType : 'PDN'; ToType : 'PIN'; Mode : 2; Func : 3),
                 (FromType : 'SDN'; ToType : 'SIN'; Mode : 2; Func : 3)
                 );


function DocToOk(const OurRef : String; TypeTo : TDocTypes) : Boolean;
//Checks that it's a legal conversion - ConvTypes array specifies what can
//be converted. Also sets the function to be called and the mode parameter
var
  sFrom, sTo : string;
  k : integer;
begin
  Result := False;
  sTo := TLBDocTypeToTKDocType(TypeTo);
  sFrom := Copy(OurRef, 1, 3);
  for k := 1 to MaxConvTypes do
  begin
    if (sTo = ConvTypes[k].ToType) and
       (sFrom = ConvTypes[k].FromType) then
    begin
      Result := True;
      Break;
    end;
  end;
end;



{==============================TConvert========================================}
//PR: 26/03/2009 Added DispIntf parameter
constructor TConvert.Create(const DispIntf: TGUID);
begin
  //PR: 08/05/2013 ABSEXCH-14195 Removed check for SPOP licenced - now checked when we know transaction types.
  inherited Create(ComServer.TypeLib, DispIntf);
  FDataRec.cvStatus := -1;
  InitObjects;
end;


Destructor TConvert.Destroy;
begin
  InitObjects;
  inherited Destroy;
end;

procedure TConvert.InitObjects;
begin
  FStartTransI := nil;
  FEndTransI := nil;
end;

function TConvert.Get_cvStartTransaction: WideString;
begin
  Result := FDataRec.cvDocFrom;
end;

function TConvert.Get_cvProcessed: Integer;
begin
  Result := FDataRec.cvStatus;
end;

function TConvert.Get_cvEndTransaction: WideString;
begin
  Result := FDataRec.cvDocTo;
end;

function TConvert.Get_cvStartTransactionI: ITransaction;
begin
  if not Assigned(FStartTransI) then
    GetClones;
  Result := FStartTransI;
end;

function TConvert.Get_cvEndTransactionI: ITransaction;
begin
  if not Assigned(FEndTransI) then
    GetClones;
  Result := FEndTransI;
end;

procedure TConvert.SetDetails(const DataRec : TBatchConvRec);
begin
  FDataRec := DataRec;
end;

procedure TConvert.Write(P : Pointer);
begin
  Move(FDataRec, P^, SizeOf(TBatchConvRec));
end;

procedure TConvert.Read(P : Pointer);
begin
  Move(P^, FDataRec, SizeOf(TBatchConvRec));
  GetClones;
end;

procedure TConvert.GetClones;
var
  Pos, Res : LongInt;
  OldIdx : Integer;
begin
  //Only need to find clone interfaces if we're converting (rather than checking)
  if Trim(FDataRec.cvDocTo) <> '' then
  begin
    FTrans.SavePosition;
    Pos := FTrans.Position;

    OldIdx := FTrans.Index;
    FTrans.Index := thIdxOurRef;

    Res := FTrans.GetEqual(FDataRec.cvDocFrom);
    if Res = 0 then
      FStartTransI := FTrans.Clone;

    Res := FTrans.GetEqual(FDataRec.cvDocTo);
    if Res = 0 then
      FEndTransI := FTrans.Clone;

    FTrans.Index := OldIdx;

    FTrans.Position := Pos;
    FTrans.RestorePosition;
  end;
end;

{==============================TSingleConvert==================================}

Constructor TSingleConvert.Create(Toolkit : TObject);
var
  Res : SmallInt;
  Path : PChar;
  sPath : string;
  si : SmallInt;
  MC : WordBool;
begin
  //PR: 26/03/2009
  inherited Create(ISingleConvert);
//  inherited Create;
  Path := StrAlloc(255);
  Try
    with Toolkit as TToolkit do
    begin
      sPath := ConfigI.DataDirectory;
      si := EnterpriseI.enCurrencyVersion;
      FTrans := TransactionO;
    end;

    if si in [1, 2] then
      MC := True
    else
      MC := False;

    StrPCopy(Path, sPath);

    Res := SP_INITDLLPATH(Path, MC);
  {  if Res <> 0 then
      raise Exception.Create('Unable to load library ENTDLLSP.DLL');}
  Finally
    StrDispose(Path);
    Res := SetSPBackDoor;
    if Res = 0 then
      Res := SP_INITDLL;

    //PR: 24/11/2011
    FLibraryLoaded := Res = 0;

    if Res = -1 then
      raise Exception.Create('Unable to load library ENTDLLSP.DLL')
    else
    if Res <> 0 then
      raise Exception.Create('Error ' + IntToStr(Res) + ' opening SPToolkit');
  End;
end;

Destructor TSingleConvert.Destroy;
begin
  //PR: 24/11/2011 Check that conversion dll hasn't been unloaded by Finalize
  if FLibraryLoaded then
    SP_CLOSEDLL;
  inherited Destroy;
end;

function TSingleConvert.Check: Integer;
begin
  Result := CheckConvert(1);
end;

function TSingleConvert.Execute: Integer;
begin
  Result := CheckConvert(2);
end;

function TSingleConvert.CheckConvert(Mode : Byte) : integer;
begin
  Result := 0;
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    //Mode = 1 for check, 2 for Convert
    LastErDesc := '';

    //PR: 24/11/2011 Added check that object hasn't been finalised
    if FLibraryLoaded then
    begin
      Case Mode of
        1 : Result := SP_CHECKCONVERSION(@FDataRec, SizeOf(TBatchConvRec), False);
        2 : Result := SP_CONVERTTRANSACTION(@FDataRec, SizeOf(TBatchConvRec), False);
      end;
    end
    else
      Result := 20000;

    If (Result <> 0) Then
      LastErDesc := SP_ERRORMESSAGE(1, Result);
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

{==============================TConvertList====================================}
constructor TConvertList.Create(TransType : TDocTypes; Trans : ITransaction; Toolkit : TObject);
var
  Res : SmallInt;
  Path : PChar;
  sPath : string;
  si : SmallInt;
  MC : WordBool;
begin
  //PR: 08/05/2013 ABSEXCH-14195 Allow non-SPOP conversions eg SQU-SIN
  if SPOPOn or not (TransType in SPOPGroup) then
  begin
    inherited Create(ComServer.TypeLib, IConvertList2);

    FList := TObjectList.Create;
    FList.OwnsObjects := False;
    FConsolidate := True;
    FTransTypeTo := TransType;
    FTrans := Trans;

    Path := StrAlloc(255);
    Try
      with Toolkit as TToolkit do
      begin
        sPath := ConfigI.DataDirectory;
        si := EnterpriseI.enCurrencyVersion;
      end;

      if si in [1, 2] then
        MC := True
      else
        MC := False;

      StrPCopy(Path, sPath);


      Res := SP_INITDLLPATH(Path, MC);
    {  if Res <> 0 then
        raise Exception.Create('Unable to load library ENTDLLSP.DLL');}
    Finally
      StrDispose(Path);
      Res := SetSPBackDoor;
      if Res = 0 then
        Res := SP_INITDLL;

      //PR: 24/11/2011
      FLibraryLoaded := Res = 0;

      if Res = -1 then
        raise Exception.Create('Unable to load library ENTDLLSP.DLL')
      else
      if Res <> 0 then
        raise Exception.Create('Error ' + IntToStr(Res) + ' opening SPToolkit');
    End;
  end
  else
    raise EInvalidMethod.Create('This installation of Exchequer is not licenced for Order Processing');
end;

destructor TConvertList.Destroy;
var
  i : integer;
begin
  //PR: 24/11/2011 Check that conversion dll hasn't been unloaded by Finalize
  if FLibraryLoaded then
    SP_CLOSEDLL;

  //PR: 09/04/2013 ABSEXCH-14195 If exception raised in constructor, delphi calls destructor, so check if list is assigned
  //                             to avoid access violation.
  if Assigned(FList) then
  begin
    FList.Clear;
    FList.Free;
  end;
  inherited Destroy;
end;

function TConvertList.Get_clConversions(Index: Integer): IConvert;
begin
  if (Index > 0) and (Index <= FList.Count) then
    Result := TConvert(FList.Items[Index-1])
  else
    raise ERangeError.Create(IntToStr(Index) + ' is not a valid entry in the current list.');
end;

function TConvertList.Get_clCount: Integer;
begin
  Result := FList.Count;
end;

procedure TConvertList.Add(const OurRef: WideString);
var
  Conv : TConvert;
  TempRec : TBatchConvRec;
begin
  //PR: 08/05/2013 ABSEXCH-14195 Allow non-SPOP conversions eg SQU-SIN
  if SPOPOn or not (TKDocTypeToTLBDocType(Copy(OurRef, 1, 3)) in SPOPGroup) then
  begin
    FillChar(TempRec, SizeOf(TempRec), 0);

    TempRec.cvDocFrom := OurRef;
    TempRec.cvDate := FDate;
    TempRec.cvDocToType := TLBDocTypeToTKDocType(FTransTypeTo);
    TempRec.cvStatus := -1;

    //PR: 26/03/2009 Change to pass DispIntf param to TConvert.Create
    Conv := TConvert.Create(IConvert);
  //  Conv := TConvert.Create;
    Conv.SetDetails(TempRec);
    Conv.Transaction := FTrans;
    Conv.IndexPos := FList.Count + 1;
    FList.Add(Conv);
    SetLength(FInterfaceArray, FList.Count);
    FInterfaceArray[FList.Count-1] := Get_clConversions(FList.Count);
  end
  else
    raise EInvalidMethod.Create('This installation of Exchequer is not licenced for Order Processing');

end;

procedure TConvertList.Delete(Index: Integer);
begin
  if (Index > 0) and (Index <= FList.Count) then
    FList.Delete(Index - 1)
  else
    raise ERangeError.Create(IntToStr(Index) + ' is not a valid entry in the current list.');
end;

procedure TConvertList.Clear;
var
  i : integer;
begin
  for i := 0 to FList.Count -1 do
    FInterfaceArray[i] := nil;
  FList.Clear;
end;

function TConvertList.Check(var ProblemIndex: Integer): Integer;
begin
  Result := CheckConvert(ProblemIndex, 1);
end;

function TConvertList.Execute: Integer;
var
  i : integer;
begin
  Result := CheckConvert(i, 2);
end;

function TConvertList.Get_clConsolidate: WordBool;
begin
  Result := FConsolidate;
end;

procedure TConvertList.Set_clConsolidate(Value: WordBool);
begin
  FConsolidate := Value;
end;

procedure TConvertList.ListToMem;
var
  i : integer;
  P : Pointer;
begin
  for i := 0 to FList.Count - 1 do
  begin
    P := Pointer(Longint(FMemPointer) + (i * SizeOf(TBatchConvRec)));
    TConvert(FList.Items[i]).Write(P);
  end;
end;

procedure TConvertList.MemToList;
var
  i : integer;
  P : Pointer;
begin
  for i := 0 to FList.Count - 1 do
  begin
    P := Pointer(Longint(FMemPointer) + (i * SizeOf(TBatchConvRec)));
    TConvert(FList.Items[i]).Read(P);
  end;
end;

function TConvertList.CheckConvert(var Prob : Integer; Mode : Byte) : integer;
//Mode = 1 for check, 2 for Convert
var
  i : integer;
begin
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    LastErDesc := '';
    Result := -1;
    //PR: 24/11/2011 Added check that object hasn't been finalised
    if FLibraryLoaded then
    begin
      GetMem(FMemPointer, SizeOf(TBatchConvRec) * FList.Count);
      Try
        ListToMem;
        //Do things
        Case Mode of
         1 : Result := SP_CHECKCONVERSION(FMemPointer, FList.Count * SizeOf(TBatchConvRec), FConsolidate);
         2 : Result := SP_CONVERTTRANSACTION(FMemPointer, FList.Count * SizeOf(TBatchConvRec), FConsolidate);
        end;
        MemToList;
      Finally
        FreeMem(FMemPointer, SizeOf(TBatchConvRec) * FList.Count);
        If (Result <> 0) Then
        begin
          for i := 0 to FList.Count - 1 do
            if TConvert(FList[i]).Get_cvProcessed <> 0 then
            begin
              Prob := i + 1;
              Break;
            end;
        end;
      End;
    end
    else
      Result := 20000;

    LastErDesc := SP_ERRORMESSAGE(1, Result);
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;






function TConvertList.Get_clDate: WideString;
begin
  Result := FDate;
end;

procedure TConvertList.Set_clDate(const Value: WideString);
begin
  FDate := Value;
end;

procedure TSingleConvert.Finalize;
begin
  //PR: 24/11/2011 Explicitly unload conversion dll - needed by .net programs where garbage collection might not
  //destroy the object in a timely manner.
  if FLibraryLoaded then
  begin
    SP_CLOSEDLL;
    FLibraryLoaded := False;
  end;
end;

procedure TConvertList.Finalize;
begin
  //PR: 24/11/2011 Explicitly unload conversion dll - needed by .net programs where garbage collection might not
  //destroy the object in a timely manner.
  if FLibraryLoaded then
  begin
    SP_CLOSEDLL;
    FLibraryLoaded := False;
  end;
end;

end.
