unit oDetails;

interface

Uses
  Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
  GlobVar, VarConst, VarCnst3, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, MiscFunc,
  oBtrieve, ExBTTh1U, oLineSNo, oLine, GlobList;


type
  TTransactionDetails = Class(TTransactionLine, ITransactionDetails, ITransactionDetails2, ITransactionDetails3)
  private
    function Int2Byte(Value : Integer) : WideString;
    function PadWithZero(Value: string; ToLength: Integer): WideString;
  protected
  //overridden methods from TTransactionLine
    procedure Save; override; safecall;
    procedure Cancel; override; safecall;
    function  entDefaultVATCode(const AccountVATCode: WideString;
                                const StockVATCode: WideString): WideString; override; safecall;
    procedure CalcVATAmount; override; safecall;
    procedure CalcStockPrice; override; safecall;
    procedure ImportDefaults; override; safecall;

    // IRecordPosition Methods
    function Get_RecordPosition: Integer; override; safecall;

    //ITransactionDetails3 functions
    //PL: 21/10/2016 ABSEXCH-11258 The position property was not set in the
    //Itransactiondetails object. added save position to save position property.
    function RestorePosition(Position: Integer): Integer; safecall;

    //PR: 13/02/2016 ABSEXCH-ABSEXCH-18191 v2017 R1
    //               Override oLine function as record is already positioned in data file
    function GetRecordAddress : Integer; override;

  //Build index functions
    function Get_Index: TTransactionDetailIndex; safecall;
    procedure Set_Index(Value: TTransactionDetailIndex); safecall;

    function BuildPostRunNoIndex(RunNo: Integer; NomCode: Integer): WideString; safecall;
    function BuildNomCodeIndex(NomCode: Integer; NomMode: TNominalModeType;
                               Currency: Integer; Year: Integer;
                               Period: Integer; PostRun: Integer): WideString; safecall;
    function BuildStockCodeIndex(const StockCode: WideString): WideString; safecall;
    function BuildLineClassIndex(const LineClass: WideString;
                                          const StockCode: WideString;
                                          const LineDate: WideString): WideString; safecall;
    function BuildFolioIndex(FolioNo: Integer; LineNo: Integer): WideString; safecall;
    function BuildFolioAbsLineNoIndex(Folio: Integer; AbsLineNo: Integer): WideString; safecall;
    function BuildLineClassAcIndex(const LineClass: WideString;
                                   const AcCode: WideString;
                                   const StockCode: WideString;
                                   const LineDate: WideString): WideString; safecall;
    function BuildRecStatusIndex(NomCode: Integer; NomMode: TNominalModeType;
                                 RecStatus: TReconcileStatusType; Currency: Integer; Year: Integer;
                                 Period: Integer): WideString; safecall;
    function BuildStockLedgerIndex(const StockCode: WideString; const LineDate: WideString;
                                   FolioNo: Integer): WideString; safecall;
    function BuildECSalesIndex(const AcCode: WideString; ECService: WordBool;
                               const StartDate: WideString): WideString; safecall;
    function BuildAccountIndex(const AcCode: WideString; const OurRef: WideString): WideString; safecall;
    function BuildOurRefIndex(const OurRef: WideString): WideString; safecall;
    function BuildYearPeriodIndex(Year: Integer; Period: Integer; const OurRef: WideString): WideString; safecall;

    //Btrieve stuff
    Procedure CopyDataRecord; override;
    Function  GetDataRecord (Const BtrOp : SmallInt;
                             Const SearchKey : String = '') : Integer; Override;

    Function  AuthoriseFunction (Const FuncNo     : Byte;
                                 Const MethodName : String;
                                 Const AccessType : Byte = 0) : Boolean; Override;
    public
      Destructor Destroy; override;
  end;


  Function CreateTTransactionDetails (Const Toolkit : TObject;
                                     Const ClientId : Integer) : TTransactionDetails;



implementation

uses
  DLLTH_UP, DllErrU, BtKeys1U, ETStrU, oToolkit;

Function CreateTTransactionDetails(Const Toolkit : TObject;
                                   Const ClientId : Integer) : TTransactionDetails;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
  ATL : TBatchTLRec;
Begin { CreateTTransaction }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));
  FillChar(ATL, SizeOf(ATL), #0);
  // Open files needed by TTransaction object
  BtrIntf^.Open_System(IDetailF, IDetailF);

  // Create base TTransaction object
  Result := TTransactionDetails.Create(0, imGeneral, Toolkit, Nil, Nil, BtrIntf, ATL, False, 0);

  if SQLBeingUsed then
    Result.SetFileNos([IDetailF]);

End; { CreateTTransaction }


procedure TTransactionDetails.Save;
begin
  Raise EInvalidMethod.Create ('The ITransactionDetails.Save method is not available');
end;

procedure TTransactionDetails.Cancel;
begin
  Raise EInvalidMethod.Create ('The ITransactionDetails.Cancel method is not available');
end;

function  TTransactionDetails.entDefaultVATCode(const AccountVATCode: WideString;
                            const StockVATCode: WideString): WideString;
begin
  Raise EInvalidMethod.Create ('The ITransactionDetails.entDefaultVATCode method is not available');
end;

procedure TTransactionDetails.CalcVATAmount;
begin
  Raise EInvalidMethod.Create ('The ITransactionDetails.CalcVATAmount method is not available');
end;

procedure TTransactionDetails.CalcStockPrice;
begin
  Raise EInvalidMethod.Create ('The ITransactionDetails.CalcStockPrice method is not available');
end;

procedure TTransactionDetails.ImportDefaults;
begin
  Raise EInvalidMethod.Create ('The ITransactionDetails.ImportDefaults method is not available');
end;

function TTransactionDetails.Int2Byte(Value : Integer) : WideString;
begin
//Convert an integer into a byte and return as a char
  Result := Char(Value mod 256);
end;

function TTransactionDetails.PadWithZero(Value: string;
  ToLength: Integer): WideString;
begin
  Result := Copy(Value + ConstStr(#0, ToLength), 1, ToLength);
end;

Function TTransactionDetails.GetDataRecord (Const BtrOp : SmallInt;
                                           Const SearchKey : String = '') : Integer;
Var
  BtrOpCode : SmallInt;
  KeyS      : Str255;
begin
  Result := 0;
  LastErDesc := '';

  With FBtrIntf^ Do Begin
    KeyS := SetKeyString(BtrOp, SearchKey);
    BtrOpCode := BtrOp;

    // Get record
    Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

    If (Result = 0) Then
      CopyDataRecord;

//    Changed := True;
    FKeyString := KeyS;
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (20, Result);
end;

Procedure TTransactionDetails.CopyDataRecord;
Begin { CopyDataRecord }
  With FBtrIntf^ Do Begin
    // Convert to Toolkit structure
    CopyEntIdToTKId(LID, FTL);
  End; { With FBtrIntf^ }
End; { CopyDataRecord }


function TTransactionDetails.BuildPostRunNoIndex(RunNo: Integer; NomCode: Integer): WideString;
begin
{ 01  -  PostedRun + NomCode  (IDRunK)  }
  Result := FullNomKey(RunNo) + FullNomKey(NomCode);
end;

function TTransactionDetails.BuildNomCodeIndex(NomCode: Integer; NomMode: TNominalModeType;
                                               Currency: Integer; Year: Integer;
                                               Period: Integer; PostRun: Integer): WideString;
begin
{ 02  -  NomCode + [NomMode+Currency+Yr+Pr] + PostedRun (IDNomK)  }
  with TToolkit(FToolkit) do
    Result := FullNomKey(NomCode) + Char(Ord(NomMode)) + Char(Currency) +
              Char(ValidateYear(Year)) +
              Char(ValidatePeriod(Period)) + FullNomKey(PostRun);
end;

function TTransactionDetails.BuildStockCodeIndex(const StockCode: WideString): WideString;
begin
{ 03  -  StockCode  (  IdStk  )  }
  Result := FullStockCode(StockCode);
end;

function TTransactionDetails.BuildLineClassIndex(const LineClass: WideString;
                                                 const StockCode: WideString;
                                                 const LineDate: WideString) : WideString;
begin
{ 04  -  LineType + StockCode + PDate (  IdAnalk  )  }
  //AP : 7/11/2016 : 2017-R1 ABSEXCH-11873 ITransactionDetails.BuildLineClassIndex and BuildLineClassAcIndex methods are not returning the correct key strings.
  Result := LineClass + FullStockCode(StockCode) + ConstStr(#0,4) + LineDate;
end;

function TTransactionDetails.BuildFolioIndex(FolioNo: Integer; LineNo: Integer): WideString;
begin
{ 00 - Folio No + Line No (IdFolioK) }
  Result := FullNomKey(FolioNo) + FullNomKey(LineNo);
end;

function TTransactionDetails.BuildFolioAbsLineNoIndex(Folio: Integer; AbsLineNo: Integer): WideString;
begin
{ 05  -  Folio No. + ABS LineNo (  IdLinkK  )  }
  Result := FullNomKey(Folio) + FullNomKey(AbsLineNo);
end;

function TTransactionDetails.BuildLineClassAcIndex(const LineClass: WideString;
                                                   const AcCode: WideString;
                                                   const StockCode: WideString;
                                                   const LineDate: WideString): WideString;
begin
{ 06  -  LineType + CustCode + StockCode + PDate (  IdCAnalk  )  }
  //AP : 7/11/2016 : 2017-R1 ABSEXCH-11873 ITransactionDetails.BuildLineClassIndex and BuildLineClassAcIndex methods are not returning the correct key strings.
  Result := LineClass + FullCustCode(AcCode) +
            FullStockCode(StockCode) + ConstStr(#0,4) + LineDate;
end;

function TTransactionDetails.BuildRecStatusIndex(NomCode: Integer; NomMode: TNominalModeType;
                                                 RecStatus: TReconcileStatusType;
                                                 Currency: Integer; Year: Integer;
                                                 Period: Integer): WideString;
begin
{ 07  -  [NomCode + NomMode] +Reconcile + [Currency+Yr+Pr] (IDReconK)  }
  with TToolkit(FToolkit) do
    Result := FullNomKey(NomCode) +
              Char(Ord(NomMode)) +
              Char(Ord(RecStatus)) +
              Char(ValidateCurrencyNo(Currency)) +
              Char(ValidateYear(Year)) +
              Char(ValidatePeriod(Period));
end;

function TTransactionDetails.Get_Index: TTransactionDetailIndex;
begin
  Result := TTransactionDetailIndex(FIndex);
end;

procedure TTransactionDetails.Set_Index(Value: TTransactionDetailIndex);
begin
  FIndex := Ord(Value);
end;

function TTransactionDetails.Get_RecordPosition: Integer;
Var
  TmpPos : LongInt;
begin
  TmpPos := FRecPosition;
  SavePosition;
  Result := FRecPosition;
  FRecPosition := TmpPos;
end;

Function TTransactionDetails.AuthoriseFunction (Const FuncNo     : Byte;
                                                Const MethodName : String;
                                                Const AccessType : Byte = 0) : Boolean;
begin
  Result := True;
end;

Destructor TTransactionDetails.Destroy;
begin
  inherited Destroy;
end;

function TTransactionDetails.BuildStockLedgerIndex(const StockCode,
  LineDate: WideString; FolioNo: Integer): WideString;
begin
  // 08 - StockCode + LineDate + Folio (IdStockLedgerK)
  Result := FullStockCode(StockCode) + LJVar(LineDate, LDateKeyLen) + FullNomKey(FolioNo);
end;

function TTransactionDetails.BuildECSalesIndex(const AcCode: WideString;
  ECService: WordBool; const StartDate: WideString): WideString;
begin
  // 09 - AcCode + ECService + ServiceStartDate (IdECSalesK)
  Result := PadWithZero(AcCode, 10) + Chr(Ord(WordBoolToBool(ECService))) + LJVar(StartDate, LDateKeyLen);
end;

function TTransactionDetails.BuildAccountIndex(const AcCode,
  OurRef: WideString): WideString;
begin
  // 10 - AcCode + OurRef (IdCustCodeK)
  Result := PadWithZero(AcCode, 10) + FullOurRefKey(OurRef);
end;

function TTransactionDetails.BuildOurRefIndex(
  const OurRef: WideString): WideString;
begin
  // 11 - OurRef (IdDocPRefK)
  Result := FullOurRefKey(OurRef);
end;

function TTransactionDetails.BuildYearPeriodIndex(Year, Period: Integer;
  const OurRef: WideString): WideString;
begin
  // 12 - Year + Period + OurRef (IdYrPrK)
  Result := Chr(Year) + Chr(Period) + FullOurRefKey(OurRef);
end;

function TTransactionDetails.RestorePosition(Position: Integer): Integer;
begin
  FRecPosition := Position;
  inherited RestorePosition;
end;

//Override oLine function as record is already positioned in data file
function TTransactionDetails.GetRecordAddress: Integer;
var
  Res : Integer;
begin
  Res := FBtrIntf^.LGetPos(FFileNo, Result);
  if Res <> 0 then
    Result := 0;
end;

end.
