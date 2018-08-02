unit oCSAnal;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     VarCnst3, oBtrieve, oAddr,
     MiscFunc, BtrvU2, oStock2, oStkLoc, oNotes, ExBtTH1U, oQtyBrk,
     oStkBOM, oStkBOML, oSerial, GlobList, oLinks, oAltStk, VarRec2U;

type
  TSAHistRec = Record
    shPeriod,
    shYear,
    shCurr   : Integer;
    shLoc,
    shCC,
    shDep    : string[3];
    shType   : Char;
  end;

  TSalesAnalysisHistory = class(TBtrieveFunctions, ISalesAnalysisHistory)
  protected
    FIntfType   : TInterfaceMode;
    FCuStkRec : CuStkType;
    FPeriod, FYear, FCurrency : integer;
    MC : Byte;
    FFilterCode : string;
    FFilterType : TSalesAnalysisFilterType;
    FForecast, FRevisedForecast : Double;
    FForecastChanged, FRevisedForecastChanged : Boolean;
    FLocation, FCostCentre, FDepartment : Str255;
    FStockType : Char;
    function Get_saPeriod: Integer; safecall;
    procedure Set_saPeriod(Value: Integer); safecall;
    function Get_saYear: Integer; safecall;
    procedure Set_saYear(Value: Integer); safecall;
    function Get_saQty: Double; safecall;
    function Get_saSales: Double; safecall;
    function Get_saForecast: Double; safecall;
    procedure Set_saForecast(Value: Double); safecall;
    function Get_saRevisedForecast: Double; safecall;
    procedure Set_saRevisedForecast(Value: Double); safecall;
    function Update: ISalesAnalysisHistory; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function Get_saCurrency: Integer; safecall;
    procedure Set_saCurrency(Value: Integer); safecall;
    function Get_saCost: Double; safecall;
    function Get_saFilterType: TSalesAnalysisFilterType; safecall;
    procedure Set_saFilterType(Value: TSalesAnalysisFilterType); safecall;
    function Get_saFilterCode: WideString; safecall;
    procedure Set_saFilterCode(const Value: WideString); safecall;

    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;

    function GetHistory(WhichVal : Byte) : Double;
    function GetHistoryCode : Str255;
    Procedure CopyDataRecord; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; override;
  public
    Constructor Create(Const IType     : TInterfaceMode;
                       Const CuStkRec  : CuStkType;
                       Const BtrIntf   : TCtkTdPostExLocalPtr);
    procedure SetMC(Value : Byte);
    procedure UpdateData(CuStkRec : CuStkType);
    procedure LoadDetails(const HistRec : TSAHistRec; const csRec : CuStkType; const LockPos : longint);
    property StockType : Char read FStockType write FStockType;
  end;

  TSalesAnalysisType = (saCustomer, saStock);

  TSalesAnalysis = class(TBtrieveFunctions, ISalesAnalysis, IBrowseInfo)
  protected
    FType       : TSalesAnalysisType;
    FCuStkRec   : CuStkType;
    FCode       : string;
    FStockFolio : longint;
    FIntfType   : TInterfaceMode;
    FToolkit    : TObject;

    FHistoryO   : TSalesAnalysisHistory;
    FHistoryI   : ISalesAnalysisHistory;
    FStockType  : Char;
    function Get_saReOrderQty: Double; safecall;
    procedure Set_saReOrderQty(Value: Double); safecall;
    function Get_saLastDate: WideString; safecall;
    function Get_saLastPrice: Double; safecall;
    function Get_saLastPriceCurrency: Integer; safecall;
    function Get_saJobCode: WideString; safecall;
    function Get_saJobAnalysis: WideString; safecall;
    function Get_saLocation: WideString; safecall;
    function Get_saGLCode: Integer; safecall;
    function Get_saCostCentre: WideString; safecall;
    function Get_saDepartment: WideString; safecall;
    function Get_saQty: Double; safecall;
    function Get_saNetValue: Double; safecall;
    function Get_saDiscount: Double; safecall;
    function Get_saVATCode: WideString; safecall;
    function Get_saQtyMul: Double; safecall;
    function Get_saDiscFlag: WideString; safecall;
    function Get_saLineType: WideString; safecall;
    function Get_saInclusiveVATCode: WideString; safecall;
    function Get_saQtyPack: Double; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function Get_saHistory: ISalesAnalysisHistory; safecall;

        //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    //ICustomerSalesAnalysis
    function Get_saStockCode: WideString; safecall;
    function Get_saStockFolio: Integer; safecall;
    function Get_saDisplayOrder: Integer; safecall;
    procedure Set_saDisplayOrder(Value: Integer); safecall;
    function BuildDisplayOrderIndex(DisplayOrder: Integer): WideString; safecall;
    function BuildStockCodeIndex(const StockCode: WideString): WideString; safecall;
    function Get_Index: TCustomerSalesAnalysisIndexType; safecall;
    procedure Set_Index(Value: TCustomerSalesAnalysisIndexType); safecall;

    //IStockSalesAnalysis
    function Get_saAcCode: WideString; safecall;
    function BuildAcCodeIndex(const AcCode: WideString): WideString; safecall;

    //PR: 24/02/2010 Added new functions to deal with SQL Caching in redirect tables
    function LoadTheCache : Integer; override;
    function GetRedirectedDataRec(const BtrOp : SmallInt; const SearchKey : string) : Integer;


    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    procedure SetCode(const Value : string);
    procedure SetStockFolio(Value : longint);

    procedure InitObjects;
  public
    Constructor Create(Const IType     : TInterfaceMode;
                       Const Toolkit   : TObject;
                       Const BtrIntf   : TCtkTdPostExLocalPtr;
                       const ObjType   : TSalesAnalysisType;
                       const Code      : string);
    Destructor Destroy; override;
    procedure LoadDetails(const csRec : CuStkType; const LockPos : longint);
    procedure CloneDetails(const csRec : CuStkType);
    property Code : string write SetCode;
    property StockFolio : longint write SetStockFolio;
    property StockType : Char read FStockType write FStockType;
  end;

  TCustomerSalesAnalysis = Class(TSalesAnalysis, ICustomerSalesAnalysis)
  protected
    function Update: ICustomerSalesAnalysis; safecall;
  end;

  TStockSalesAnalysis = Class(TSalesAnalysis, IStockSalesAnalysis)
  protected
    function Update: IStockSalesAnalysis; safecall;
  end;




implementation

uses
  ComServ, BtSupU1, DllErrU, oToolkit, CuStkA4U, BtKeys1U, EtStrU, SQLStructuresU, TKSQL;

procedure TSalesAnalysis.InitObjects;
begin
  FHistoryO   := nil;
  FHistoryI   := nil;
end;

function TSalesAnalysis.Get_saReOrderQty: Double;
begin
  Result := FCuStkRec.csSOQty;
end;

procedure TSalesAnalysis.Set_saReOrderQty(Value: Double);
begin
  FCuStkRec.csSOQty := Value;
end;

function TSalesAnalysis.Get_saLastDate: WideString;
begin
  Result := FCuStkRec.csLastDate;
end;

function TSalesAnalysis.Get_saLastPrice: Double;
begin
  Result := FCuStkRec.csLastPrice;
end;

function TSalesAnalysis.Get_saLastPriceCurrency: Integer;
begin
  Result := FCuStkRec.csLPCurr;
end;

function TSalesAnalysis.Get_saJobCode: WideString;
begin
  Result := FCuStkRec.csJobCode;
end;

function TSalesAnalysis.Get_saJobAnalysis: WideString;
begin
  Result := FCuStkRec.csJACode;
end;

function TSalesAnalysis.Get_saLocation: WideString;
begin
  Result := FCuStkRec.csLocCode;
end;

function TSalesAnalysis.Get_saGLCode: Integer;
begin
  Result := FCuStkRec.csNomCode;
end;

function TSalesAnalysis.Get_saCostCentre: WideString;
begin
  Result := FCuStkRec.csCCDep[True];
end;

function TSalesAnalysis.Get_saDepartment: WideString;
begin
  Result := FCuStkRec.csCCDep[False];
end;

function TSalesAnalysis.Get_saQty: Double;
begin
  Result := FCuStkRec.csQty;
end;

function TSalesAnalysis.Get_saNetValue: Double;
begin
  Result := FCuStkRec.csNetValue;
end;

function TSalesAnalysis.Get_saDiscount: Double;
begin
  Result := FCuStkRec.csDiscount;
end;

function TSalesAnalysis.Get_saVATCode: WideString;
begin
  Result := FCuStkRec.csVATCode;
end;

function TSalesAnalysis.Get_saQtyMul: Double;
begin
  Result := FCuStkRec.csQtyMul;
end;

function TSalesAnalysis.Get_saDiscFlag: WideString;
begin
  Result := FCuStkRec.csDiscCh;
end;

function TSalesAnalysis.Get_saLineType: WideString;
begin
end;

function TSalesAnalysis.Get_saInclusiveVATCode: WideString;
begin
  Result := FCuStkRec.csVATIncFlg;
end;

function TSalesAnalysis.Save: Integer;
Var
  SaveInfo    : TBtrieveFileSavePos;
  SaveInfo2   : TBtrieveFileSavePos;
  BtrOp, Res  : SmallInt;
begin
  AuthoriseFunction(102, 'Save');

  // Save Current Position in global file
  SaveMainPos(SaveInfo);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Res := PositionOnLock;
    BtrOp := B_Update;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Res := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Res = 0) Then Begin
    // Add/Update Stock-Location
    SaveExLocalPos(SaveInfo2);

    Move(FCuStkRec, FBtrIntf^.LMLocCtrl^.CuStkRec, SizeOf(FCuStkRec));
    FBtrIntf^.LMLocCtrl^.RecPFix := MatchTCode;
    FBtrIntf^.LMLocCtrl^.SubType := MatchSCode;

    Res := Put_Rec(F[FFileNo], FFileNo, FBtrIntf^.LMLocCtrl^, FIndex);

    RestoreExLocalPos(SaveInfo2);
  End; { If (Res = 0) }

  // Restore original position in global customer file
  RestoreMainPos(SaveInfo);

  Result := Res;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;
end;

//=====================================================
function TSalesAnalysis.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

//=====================================================


function TSalesAnalysis.Get_saStockCode: WideString;
begin
  Result := FCuStkRec.csStockCode;
end;

function TSalesAnalysis.Get_saStockFolio: Integer;
begin
  Result := FCuStkRec.csStkFolio;
end;

function TSalesAnalysis.Get_saDisplayOrder: Integer;
begin
  Result := FCuStkRec.csLineNo;
end;

function TSalesAnalysis.Get_saQtyPack: Double;
begin
  Result := FCuStkRec.csQtyPack;
end;

procedure TSalesAnalysis.Set_saDisplayOrder(Value: Integer);
begin
  FCuStkRec.csLineNo := Value;
end;

function TSalesAnalysis.BuildDisplayOrderIndex(DisplayOrder: Integer): WideString;
begin
  Result := #0#0#0#0 + IntToHex(DisplayOrder, 4);
end;

function TSalesAnalysis.BuildStockCodeIndex(const StockCode: WideString): WideString;
begin
  Result := #0#0#0#0 + LJVar(StockCode, 16);
end;

function TSalesAnalysis.Get_Index: TCustomerSalesAnalysisIndexType;
begin
  Result := TCustomerSalesAnalysisIndexType(FIndex);
end;

procedure TSalesAnalysis.Set_Index(Value: TCustomerSalesAnalysisIndexType);
begin
  if Value in [csaIdxDisplayOrder, csaIdxStockCode] then
    FIndex := Value
  else
    raise Exception.Create('Invalid Index (' + IntToStr(Value) + ')');
end;

Function TSalesAnalysis.AuthoriseFunction (Const FuncNo     : Byte;
                            Const MethodName : String;
                            Const AccessType : Byte = 0) : Boolean;
begin
  Case FuncNo Of
    5..99     : Result := (FIntfType = imGeneral);

    // .Update method
    101       : Result := (FIntfType = imGeneral);
    // .Save method
    102       : Result :=  FIntfType In [imUpdate];
    // .Cancel method
    103       : Result := (FIntfType = imUpdate);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);

  Else
    Result := False;
  End; { Case FuncNo }

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }
end;

procedure TSalesAnalysis.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;


Procedure TSalesAnalysis.CopyDataRecord;
begin
  Move(FBtrIntf^.LMlocCtrl.CuStkRec, FCuStkRec, SizeOf(FCuStkRec));
end;

Function TSalesAnalysis.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, KeyChk,
  CodeChk               : Str255;
  Loop                  : Boolean;

Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';

  if UsingRedirectCache then
    Result := GetRedirectedDataRec(BtrOp, SearchKey)
  else
  With FBtrIntf^ Do Begin
    // General shared index including Discounts, FIFO, Serial No's, Window Positions, etc... records

    KeyChk := MatchTCode + MatchSCode + FCode;

    KeyS := SetKeyString(BtrOp, KeyChk + SearchKey);

    BtrOpCode := BtrOp;
    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetFirst   : Begin
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                     End;

      // HM 11/12/01: Modified as GetEqual would find matching codes for other stock items
      //              and return with a 0
      // Looking for exact match - do it and finish
      {B_GetEq      : Loop := False;}
      B_GetEq      : Begin
                       KeyChk := KeyS;
                       BtrOpCode2 := B_GetNext;
                       Loop := False;
                     End;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    // Loop through file until we wither get a btrieve error or we find a desired
    // record.  Except for GetEqual which just looks for an exact match
    Repeat
      // Look for record
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      If (Result = 0) Then Begin
        // Change Btrieve Operation to look for next record
        BtrOpCode := BtrOpCode2;
        if FType = saCustomer then
          CodeChk := LMLocCtrl^.CuStkRec.csCustCode
        else
          CodeChk := LMLocCtrl^.CuStkRec.csStockCode;

        If (Not CheckKey(KeyS, KeyChk, Length(KeyChk), True)) Then
          // Invalid Record - return End of File
          Result := 9;
      End; { If (Result = 0) }
    Until (Result <> 0) Or (Not Loop) Or ((Result = 0) And (FCode = CodeChk));

    FKeyString := KeyS;

    If (Result = 0) And (FCode = CodeChk) Then Begin
        CopyDataRecord
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (172, Result);
End; { GetDataRecord }

Constructor TSalesAnalysis.Create(Const IType     : TInterfaceMode;
                                  Const Toolkit   : TObject;
                                  Const BtrIntf   : TCtkTdPostExLocalPtr;
                                  const ObjType   : TSalesAnalysisType;
                                  const Code      : string);
begin
  if ObjType = saCustomer then
  begin
    Inherited Create (ComServer.TypeLib, ICustomerSalesAnalysis, BtrIntf);
    FIndex := 1;
    FObjectID := tkoCustSalesAnal;
  end
  else
  begin
    Inherited Create (ComServer.TypeLib, IStockSalesAnalysis, BtrIntf);
    FIndex := 2;
    FObjectID := tkoStockSalesAnal;
  end;

  // Initialise Btrieve Ancestor
  FFileNo := MLocF;
  SetCode(Code);
  FType := ObjType;

  // Initialise variables
  FillChar (FCuStkRec, SizeOf(FCuStkRec), #0);
  InitObjects;

  FIntfType := IType;
  FToolkit := Toolkit;

  FSQLParentKey := Code;

end;

Destructor TSalesAnalysis.Destroy;
begin
  InitObjects;
  FToolkit := nil;
end;

procedure TSalesAnalysis.LoadDetails(const csRec : CuStkType; const LockPos : longint);
begin
  FCuStkRec := csRec;
  LockCount := 1;
  LockPosition := LockPos;
end;

procedure TSalesAnalysis.CloneDetails(const csRec : CuStkType);
begin
  FCuStkRec := csRec;
end;

function TSalesAnalysis.Get_saHistory: ISalesAnalysisHistory;
begin
  if not Assigned(FHistoryO) then
  begin
    FHistoryO := TSalesAnalysisHistory.Create(imGeneral, FCuStkRec, FBtrIntf);
    FHistoryO.SetMC((FToolkit as TToolkit).SystemSetupI.ssCurrencyVersion);

    FHistoryI := FHistoryO;
  end
  else
    FHistoryO.UpdateData(FCuStkRec);

  FHistoryO.StockType := FStockType;

  Result := FHistoryI;
end;

procedure TSalesAnalysis.SetCode(const Value : string);
begin
  FCode := Value;
  FSQLParentKey := Value;
end;

procedure TSalesAnalysis.SetStockFolio(Value : longint);
begin
  FCuStkRec.csStkFolio := Value;
end;

//==========================================================================================

function TSalesAnalysis.Get_saAcCode: WideString;
begin
  Result := FCuStkRec.csCustCode;
end;

function TSalesAnalysis.BuildAcCodeIndex(const AcCode: WideString): WideString; safecall;
begin
  Result := #0#0#0#0 + LJVar(AcCode, 6);
end;


//==========================================================================================

Constructor TSalesAnalysisHistory.Create(Const IType     : TInterfaceMode;
                                         Const CuStkRec  : CuStkType;
                                         Const BtrIntf   : TCtkTdPostExLocalPtr);
begin
  Inherited Create (ComServer.TypeLib, ISalesAnalysisHistory, BtrIntf);
  FIntfType := IType;
  FCuStkRec := CuStkRec;
  MC := 0;
  FCurrency := 0;
  FPeriod := 99;
  FYear := 0;
  FFilterType := ftNone;
  FForecastChanged := False;
  FRevisedForecastChanged := False;
  FFileNo := NHistF;
  FIndex := NHK;
end;

procedure TSalesAnalysisHistory.SetMC(Value : Byte);
begin
  MC := Value;
end;

procedure TSalesAnalysisHistory.UpdateData(CuStkRec : CuStkType);
begin
  FCuStkRec := CuStkRec;
end;

function TSalesAnalysisHistory.GetHistory(WhichVal : Byte) : Double;
Var
  Purch,PSales,
  PCleared,
  PBudget,
  PRBudget,
  BValue1,
  BValue2,
  DNum      :  Double;
  KeyS : Str255;
  PeriodShift : Byte;
  Prefix : Char;
begin
  Result := 0;
  KeyS := GetHistoryCode;

  if (FPeriod > 99) and (FPeriod < 254) then
    PeriodShift := 100
  else
    PeriodShift := 0;

  if Trim(FCuStkRec.csCustCode) = '' then
    Prefix := FStockType
  else
    Prefix := CuStkHistCode;

  DNum := Total_Profit_To_Date({FStockType}{CuStkHistCode}Prefix, KeyS, FCurrency, FYear, FPeriod - PeriodShift, Purch,PSales,
                              PCleared, PBudget, PRBudget, BValue1, BValue2, FPeriod >= 99);

  Case WhichVal of
    1  :  Result := PCleared;        //Qty
    2  :  Result := PSales;          //Sales
    3  :  Result := Purch;           //Costs
    4  :  Result := PBudget;         //Forecast
    5  :  Result := PRBudget         //Revised Forecast
  end;

end;

function TSalesAnalysisHistory.Get_saPeriod: Integer;
begin
  if FPeriod = 99 then
    Result := -99
  else
    Result := FPeriod;
end;

procedure TSalesAnalysisHistory.Set_saPeriod(Value: Integer);
begin
  if Value = -99 then
    FPeriod := 99
  else
    FPeriod := Value;
end;

function TSalesAnalysisHistory.Get_saYear: Integer;
begin
  Result := FYear;
  if Result < 1900 then
    Result := Result + 1900;
end;

procedure TSalesAnalysisHistory.Set_saYear(Value: Integer);
begin
  FYear := Value;

  if FYear > 1900 then
    FYear := FYear - 1900;
end;

function TSalesAnalysisHistory.Get_saCurrency: Integer;
begin
  Result := FCurrency;
end;

procedure TSalesAnalysisHistory.Set_saCurrency(Value: Integer);
begin
  if ((MC = enGlobal) and (Value in [0..90])) or ((MC = enEuro) and (Value in [0..2])) or (Value = 0) then
    FCurrency := Value
  else
    raise Exception.Create('Invalid Currency No (' + IntToStr(Value));
end;

function TSalesAnalysisHistory.Get_saQty: Double;
begin
  Result := GetHistory(1);
end;

function TSalesAnalysisHistory.Get_saSales: Double;
begin
  Result := GetHistory(2);
end;

function TSalesAnalysisHistory.Get_saCost: Double; safecall;
begin
  Result := GetHistory(3);
end;

function TSalesAnalysisHistory.Get_saForecast: Double;
begin
  if FForecastChanged then
    Result := FForecast
  else
    Result := GetHistory(4);
end;

function TSalesAnalysisHistory.Get_saRevisedForecast: Double;
begin
  if FRevisedForecastChanged then
    Result := FRevisedForecast
  else
    Result := GetHistory(5);
end;

procedure TSalesAnalysisHistory.Set_saForecast(Value: Double);
begin
  FForecast :=  Value;
  FForecastChanged := True;
end;

procedure TSalesAnalysisHistory.Set_saRevisedForecast(Value: Double);
begin
  FRevisedForecast :=  Value;
  FRevisedForecastChanged := True;
end;

function TSalesAnalysisHistory.Update: ISalesAnalysisHistory;
var
  UpdateO : TSalesAnalysisHistory;
  Key, Key2 : Str255;
  Found : Boolean;
  FuncRes : LongInt;
  HistRec : TSAHistRec;
  KeyChar : Char;
begin
  Result := Nil;
  AuthoriseFunction(101, 'Update');

//PR: Changes to deal with StockAnalysis with no AcCode replicated from 600.003
  if Trim(FCuStkRec.csCustCode) = '' then
    KeyChar :=  FStockType
  else
    KeyChar :=  CuStkHistCode;

  with FBtrIntf^ do
  begin
    Key := FullNHistKey(KeyChar,
                        GetHistoryCode,
                        FCurrency,
                        FYear,
                        FPeriod);
    Key2 := Key;

    { Load record }

    Found := LFind_Rec(B_GetEq, FFileNo, FIndex, Key) = 0;

    If (Not Found) Then Begin
      { Record doesn't exist - Add new and then update }
      LAdd_NHist(KeyChar,
                 GetHistoryCode,
                 FCurrency,
                 FYear,
                 FPeriod,
                 FFileNo,
                 FIndex);

      { Now get record }
      Key := Key2;
      Found := LFind_Rec(B_GetEq, FFileNo, FIndex, Key) = 0;
    end;
  end;

  if Found then
  begin
  // Lock Current Record
    FuncRes := Lock;

    If (FuncRes = 0) Then Begin
      // Create an update object
      UpdateO := TSalesAnalysisHistory.Create(imUpdate, FCuStkRec, FBtrIntf);
      HistRec.shPeriod := FPeriod;
      HistRec.shYear := FYear;
      HistRec.shCurr := FCurrency;

      HistRec.shLoc := FLocation;
      HistRec.shCC := FCostCentre;
      HistRec.shDep := FDepartment;
      HistRec.shType := FStockType;
      // Pass current Location Record and Locking Details into sub-object
      UpdateO.LoadDetails(HistRec, FCuStkRec, LockPosition);
      LockCount := 0;
      LockPosition := 0;

      Result := UpdateO;
    End; { If (FuncRes = 0) }
  end;

end;

procedure TSalesAnalysisHistory.LoadDetails(const HistRec : TSAHistRec; const csRec : CuStkType; const LockPos : longint);
begin
  FCuStkRec := csRec;
  LockCount := 1;
  LockPosition := LockPos;
  FPeriod := HistRec.shPeriod;
  FYear := HistRec.shYear;
  FCurrency := HistRec.shCurr;
  FLocation := HistRec.shLoc;
  FCostCentre := HistRec.shCC;
  FDepartment := HistRec.shDep;
  FStockType := HistRec.shType;
end;


function TSalesAnalysisHistory.Save: Integer;
Var
  SaveInfo    : TBtrieveFileSavePos;
  SaveInfo2   : TBtrieveFileSavePos;
  BtrOp, Res  : SmallInt;
begin
  AuthoriseFunction(102, 'Save');

  // Save Current Position in global file
  SaveMainPos(SaveInfo);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Res := PositionOnLock;
    BtrOp := B_Update;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Res := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Res = 0) Then Begin
    // Add/Update Stock-Location
    SaveExLocalPos(SaveInfo2);

    if FForecastChanged then
      NHist.Budget := FForecast;

    if FRevisedForecastChanged then
      NHist.RevisedBudget1 := FRevisedForecast;


    Res := Put_Rec(F[FFileNo], FFileNo, NHist, FIndex);

    if Res = 0 then
    begin
      FForecastChanged := False;
      FRevisedForecastChanged := False;
    end;

    RestoreExLocalPos(SaveInfo2);
  End; { If (Res = 0) }

  // Restore original position in global customer file
  RestoreMainPos(SaveInfo);

  Result := Res;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;
end;

procedure TSalesAnalysisHistory.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
  FForecastChanged := False;
  FRevisedForecastChanged := False;
end;


function TSalesAnalysisHistory.Get_saFilterType: TSalesAnalysisFilterType;
begin
  Result := FFilterType;
end;

procedure TSalesAnalysisHistory.Set_saFilterType(Value: TSalesAnalysisFilterType);
begin
  if (Value <= ftLocation) then
    FFilterType := Value
  else
    raise Exception.Create('Invalid Filter Type (' + IntToStr(Value) + ')');
end;

function TSalesAnalysisHistory.Get_saFilterCode: WideString;
begin
  Result := FFilterCode;
end;

procedure TSalesAnalysisHistory.Set_saFilterCode(const Value: WideString);
begin
  FFilterCode := UpperCase(Value);
end;

{function TSalesAnalysisHistory.GetHistoryCode : Str255;
const
  FilterNames : Array[ftCostCentre..ftLocation] of String[11] = ('Cost Centre',
                                                                 'Department',
                                                                 'Location');
var
  KeyS : Str255;
  FNum, FIdx : Byte;
begin

  Case FFilterType of
    ftCostCentre,
    ftDepartment : begin
                     FNum := PwrdF;
                     FIdx := cdIdxCode;
                     KeyS := CostCCode + CSubCode[FFilterType = ftCostCentre] +
                               LJVar(UpperCase(FFilterCode), CCKeyLen);

                   end;
    ftLocation   : begin
                     FNum := MLocF;
                     FIdx := loIdxCode;
                     KeyS := CostCCode + CSubCode[True] +
                               LJVar(UpperCase(Copy(FFilterCode, 1, 3)), MLocKeyLen);
                   end;
  end;

  if (FFilterType > ftNone) and not CheckExsists(KeyS, FNum, FIdx) then
    Raise Exception.Create('Invalid ' + FilterNames[FFilterType] + ' (' + QuotedStr(FFilterCode) + ')');

  Case FFilterType of
    ftNone       : if Trim(FCuStkRec.csCustCode) = '' then
                     KeyS := FullNomKey(FCuStkRec.csStkFolio)
                   else
                     KeyS := Full_CuStkHKey1(FCuStkRec.csCustCode, FCuStkRec.csStkFolio);


    ftCostCentre,
    ftDepartment : KeyS := Full_CuStkHKey2(FCuStkRec.csCustCode, FCuStkRec.csStkFolio,
                                            PostCCKey(FFilterType = ftCostCentre,FFilterCode));
    ftLocation   : KeyS := Full_CuStkHKey3(FCuStkRec.csCustCode, FCuStkRec.csStkFolio, FFilterCode);
  end;

  Result := KeyS;

end;}

//PR: Replicated from 600.003 to set keystring correctly with Locations
function TSalesAnalysisHistory.GetHistoryCode : Str255;
const
  FilterNames : Array[ftCostCentre..ftLocation] of String[11] = ('Cost Centre',
                                                                 'Department',
                                                                 'Location');
var
  KeyS : Str255;
  FNum, FIdx : Byte;
begin
  FNum := 0;
  FIdx := 0;
  Case FFilterType of
    ftCostCentre,
    ftDepartment : begin
                     FNum := PwrdF;
                     FIdx := cdIdxCode;
                     KeyS := CostCCode + CSubCode[FFilterType = ftCostCentre] +
                               LJVar(UpperCase(FFilterCode), CCKeyLen);

                   end;
    ftLocation   : begin
                     FNum := MLocF;
                     FIdx := loIdxCode;
                     KeyS := CostCCode + CSubCode[True] +
                               LJVar(UpperCase(Copy(FFilterCode, 1, 3)), MLocKeyLen);
                   end;
  end;

  if (FFilterType > ftNone) and not CheckExsists(KeyS, FNum, FIdx) then
    Raise Exception.Create('Invalid ' + FilterNames[FFilterType] + ' (' + QuotedStr(FFilterCode) + ')');

  Case FFilterType of
    ftNone       : KeyS := {Full_CuStkHKey1(FCuStkRec.csCustCode, FCuStkRec.csStkFolio);}
                           FullNomKey(FCuStkRec.csStkFolio) + FullStockCode(FCuStkRec.csCustCode);
    ftCostCentre,
    ftDepartment : KeyS := Full_CuStkHKey2(FCuStkRec.csCustCode, FCuStkRec.csStkFolio,
                                            PostCCKey(FFilterType = ftCostCentre,FFilterCode));
    ftLocation   : KeyS := {Full_CuStkHKey3(FCuStkRec.csCustCode, FCuStkRec.csStkFolio, FFilterCode);}
                           'L' + FullNomKey(FCuStkRec.csStkFolio) + FullStockCode(FFilterCode);
  end;

  Result := KeyS;

end;


Function TSalesAnalysisHistory.AuthoriseFunction (Const FuncNo     : Byte;
                                                  Const MethodName : String;
                                                  Const AccessType : Byte = 0) : Boolean;
begin
  Case FuncNo Of
    5..99     : Result := (FIntfType = imGeneral);

    // .Update method
    101       : Result := (FIntfType = imGeneral);
    // .Save method
    102       : Result :=  FIntfType In [imUpdate];
    // .Cancel method
    103       : Result := (FIntfType = imUpdate);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);

  Else
    Result := False;
  End; { Case FuncNo }

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }
end;


//========================================================================
function TCustomerSalesAnalysis.Update: ICustomerSalesAnalysis;
Var
  UpdateO : TCustomerSalesAnalysis;
  FuncRes : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TCustomerSalesAnalysis.Create(imUpdate, FToolkit, FBtrIntf, saCustomer,
                                               FCuStkRec.csCustCode);

    // Pass current Location Record and Locking Details into sub-object
    UpdateO.LoadDetails(FCuStkRec, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;

//========================================================================
function TStockSalesAnalysis.Update: IStockSalesAnalysis;
Var
  UpdateO : TStockSalesAnalysis;
  FuncRes : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TStockSalesAnalysis.Create(imUpdate, FToolkit, FBtrIntf, saStock,
                                               FCuStkRec.csStockCode);

    // Pass current Location Record and Locking Details into sub-object
    UpdateO.LoadDetails(FCuStkRec, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;



function TSalesAnalysis.GetRedirectedDataRec(const BtrOp: SmallInt;
  const SearchKey: string): Integer;
var
  DataRec : TCustomerStockAnalysisRec;
  sKey : Str255;
begin
  sKey := SetKeyString(BtrOp, SearchKey);
  Result := FSQLRedirect.GetData(BtrOp, FIndex, sKey, @DataRec, SizeOf(DataRec));

  if Result = 0 then
  begin
    FBtrIntf^.LMlocCtrl^.RecPfix := MatchTCode;
    FBtrIntf^.LMlocCtrl^.SubType := MatchSCode;
    FBtrIntf^.LMlocCtrl^.CuStkRec.csCode1 := Full_CuStkLKey(DataRec.csCustCode, DataRec.csLineNo);
    FBtrIntf^.LMlocCtrl^.CuStkRec.csCode2 := Full_CuStkKey(DataRec.csCustCode, DataRec.csStockCode);
    FBtrIntf^.LMlocCtrl^.CuStkRec.csCode3 := Full_CuStkKey2(DataRec.csCustCode, DataRec.csStockCode);

    Move(DataRec, FBtrIntf^.LMlocCtrl^.CuStkRec.csCustCode, SizeOf(DataRec));

    CopyDataRecord;

    FKeyString := sKey;
  end;
end;

function TSalesAnalysis.LoadTheCache: Integer;
var
  DefaultWhere : string;
begin
  Result := 0;
  if not UsingRedirectCache then
  begin
    FSQLRedirect := TSQLRedirect.Create;
    FSQLRedirect.FileNo := F_CUSTOMER_STOCK_ANAL;
    FSQLRedirect.WhereClause := FullQuery;;
    FSQLRedirect.FieldList := FColumns;
    FSQLRedirect.ClientID := FBtrIntf^.ExClientID;
    Result := FSQLRedirect.Open;
  end;
end;

procedure TSalesAnalysisHistory.CopyDataRecord;
begin
  //PR: 25/03/2010 Do nothing - Added method as fix for update abstract error as CopyDataRecord is called from Lock method in
  //ancestor BtrieveFunctions.
end;


function TSalesAnalysisHistory.GetDataRecord(const BtrOp: SmallInt;
  const SearchKey: String): Integer;
begin
  //Do nothing - avoid warnings
  Result := 0;
end;

end.
