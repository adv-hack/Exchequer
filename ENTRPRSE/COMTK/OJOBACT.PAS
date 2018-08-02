unit oJobAct;
{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
      oBtrieve, GlobVar, VarConst, VarCnst3, MiscFunc,
     BtrvU2, ExBTTH1U, oCcyTri, VarRec2U, GlobList;


type
  TJobActual = class(TBtrieveFunctions, IJobActual, IBrowseInfo)
  private
    FJARec : JobActType;
    FTriO : TCurrencyTriangulation;
    FTriI : ICurrencyTriangulation;
    FParentJobCode : string;

    FIntfType  : TInterfaceMode;
    FToolkit : TObject;

  protected
    function Get_jaAnalysisCode: WideString; safecall;
    function Get_jaCurrency: Integer; safecall;
    function Get_jaPeriod: Integer; safecall;
    function Get_jaYear: Integer; safecall;
    function Get_jaPosted: WordBool; safecall;
    function Get_jaLineFolio: Integer; safecall;
    function Get_jaLineNumber: Integer; safecall;
    function Get_jaDocRef: WideString; safecall;
    function Get_jaStockCode: WideString; safecall;
    function Get_jaDate: WideString; safecall;
    function Get_jaQty: Double; safecall;
    function Get_jaCost: Double; safecall;
    function Get_jaCharge: Double; safecall;
    function Get_jaInvoiced: WordBool; safecall;
    function Get_jaInvoiceRef: WideString; safecall;
    function Get_jaEmployeeCode: WideString; safecall;
    function Get_jaAnalysisCategory: TAnalysisCategory; safecall;
    function Get_jaPostedRun: Integer; safecall;
    function Get_jaReverseWIP: WordBool; safecall;
    function Get_jaReconciled: WordBool; safecall;
    function Get_jaDocType: TDocTypes; safecall;
    function Get_jaChargeCurrency: Integer; safecall;
    function Get_jaAccountCode: WideString; safecall;
    function Get_jaHoldFlag: Integer; safecall;
    function Get_jaPostedToStock: WordBool; safecall;
    function Get_jaCompanyRate: Double; safecall;
    function Get_jaDailyRate: Double; safecall;
    function Get_jaTagged: WordBool; safecall;
    function Get_jaGLCode: Integer; safecall;
    function Get_jaUseORate: Integer; safecall;
    function Get_jaTriangulation: ICurrencyTriangulation; safecall;
    function Get_jaPriceMultiplier: Double; safecall;

    function Get_Index: TJobActualIndexType; safecall;
    procedure Set_Index(Value: TJobActualIndexType); safecall;
    function BuildLedgerIndex(Posted: WordBool; Currency: Byte; Invoiced: WordBool): WideString; safecall;
    function BuildAnalysisCodeIndex(const AnalysisCode: WideString): WideString; safecall;
    function BuildStockCodeIndex(const StockCode: WideString): WideString; safecall;
    function BuildAnalysisCategoryIndex(AnalysisType: TAnalysisType): WideString; safecall;
    function UpdateCharge(NewValue: Double): Integer; safecall;

    function Clone : IJobActual; safecall;

    function Get_jaUpliftTotal: Double; safecall;
    function Get_jaUpliftGL: Integer; safecall;


    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;


    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;

    // Local methods
    Procedure CloneDetails (Const JDets : JobActType);
    Procedure InitObjects;

    Function TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt; override;
    function GetTriRec : TriCurType;
  public
    Constructor Create(Const IType     : TInterfaceMode;
                       const Toolkit   : TObject;
                       Const BtrIntf   : TCtkTdPostExLocalPtr;
                       const JobCode   : String);
    destructor Destroy; override;
  end;

  function CreateTJobActual(Const Toolkit : TObject; Const ClientId : Integer;
                            const JobCode : string) : TJobActual;

implementation

uses
  BtKeys1U, ComServ;


function CreateTJobActual(Const Toolkit : TObject; Const ClientId : Integer;
                          const JobCode : string) : TJobActual;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTAccount }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by object
  BtrIntf^.Open_System(JDetlF, JDetlF);

  // Create bas TAccount object
  Result := TJobActual.Create(imGeneral, Toolkit, BtrIntf, JobCode);

  if SQLBeingUsed then
    Result.SetFileNos([JDetlF]);

End; { CreateTAccount }

Constructor TJobActual.Create(Const IType     : TInterfaceMode;
                              Const Toolkit   : TObject;
                              Const BtrIntf   : TCtkTdPostExLocalPtr;
                              Const JobCode   : string);
begin
  Inherited Create (ComServer.TypeLib, IJobActual, BtrIntf);

  // Initialise Btrieve Ancestor
  FBtrIntf := BtrIntf;
  FFileNo := JDetlF;

  // Initialise variables
  FillChar(FJARec, SizeOf(FJARec), 0);
  InitObjects;
  FParentJobCode := JobCode;
  FToolkit := Toolkit;
  FObjectID := tkoJobActual;
  FSQLParentKey := JobCode;
end;

destructor TJobActual.Destroy;
begin
  InitObjects;

  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
end;


function TJobActual.Get_jaAnalysisCode: WideString;
begin
  Result := FJARec.AnalCode;
end;

function TJobActual.Get_jaCurrency: Integer;
begin
  Result := FJARec.ActCurr;
end;

function TJobActual.Get_jaPeriod: Integer;
begin
  Result := FJARec.ActPr;
end;

function TJobActual.Get_jaYear: Integer;
begin
  Result := FJARec.ActYr;
end;

function TJobActual.Get_jaPosted: WordBool;
begin
  Result := BoolToWordBool(FJARec.Posted);
end;

function TJobActual.Get_jaLineFolio: Integer;
begin
  Result := FJARec.LineFolio;
end;

function TJobActual.Get_jaLineNumber: Integer;
begin
  Result := FJARec.LineNo;
end;

function TJobActual.Get_jaDocRef: WideString;
begin
  Result := FJARec.LineORef;
end;

function TJobActual.Get_jaStockCode: WideString;
begin
  Result := FJARec.StockCode;
end;

function TJobActual.Get_jaDate: WideString;
begin
  Result := FJARec.JDate;
end;

function TJobActual.Get_jaQty: Double;
begin
  Result := FJARec.Qty;
end;

function TJobActual.Get_jaCost: Double;
begin
  Result := FJARec.Cost;
end;

function TJobActual.Get_jaCharge: Double;
begin
  Result := FJARec.Charge;
end;

function TJobActual.Get_jaInvoiced: WordBool;
begin
  Result := BoolToWordBool(FJARec.Invoiced);
end;

function TJobActual.Get_jaInvoiceRef: WideString;
begin
  Result := FJARec.InvRef;
end;

function TJobActual.Get_jaEmployeeCode: WideString;
begin
  Result := FJARec.EmplCode;
end;

function TJobActual.Get_jaAnalysisCategory: TAnalysisCategory;
begin
  Result := Pred(FJARec.JAType);
end;

function TJobActual.Get_jaPostedRun: Integer;
begin
  Result := FJARec.PostedRun;
end;

function TJobActual.Get_jaReverseWIP: WordBool;
begin
  Result := BoolToWordBool(FJARec.Reverse);
end;

function TJobActual.Get_jaReconciled: WordBool;
begin
  Result := BoolToWordBool(FJARec.ReconTS);
end;

function TJobActual.Get_jaDocType: TDocTypes;
begin
  Result := TKDocTypeVal[FJARec.JDDT];
end;

function TJobActual.Get_jaChargeCurrency: Integer;
begin
  Result := FJARec.CurrCharge;
end;

function TJobActual.Get_jaAccountCode: WideString;
begin
  Result := FJARec.ActCCode;
end;

function TJobActual.Get_jaHoldFlag: Integer;
begin
  Result := FJARec.HoldFlg;
end;

function TJobActual.Get_jaPostedToStock: WordBool;
begin
  Result := BoolToWordBool(FJARec.Post2Stk);
end;

function TJobActual.Get_jaCompanyRate: Double;
begin
  Result := FJARec.PCRates[False];
end;

function TJobActual.Get_jaDailyRate: Double;
begin
  Result := FJARec.PCRates[True];
end;

function TJobActual.Get_jaTagged: WordBool;
begin
  Result := BoolToWordBool(FJARec.Tagged);
end;

function TJobActual.Get_jaGLCode: Integer;
begin
  Result := FJARec.OrigNCode;
end;

function TJobActual.Get_jaUseORate: Integer;
begin
  Result := FJARec.JUseORate;
end;

function TJobActual.Get_jaTriangulation: ICurrencyTriangulation;
begin
  if not Assigned(FTriO) then
  begin
    FTriO := TCurrencyTriangulation.Create(GetTriRec);

    FTriI := FTriO;
  end;
  Result := FTriI;
end;

function TJobActual.Get_jaPriceMultiplier: Double;
begin
  Result := FJARec.JPriceMulX;
end;

Function TJobActual.AuthoriseFunction (Const FuncNo     : Byte;
                                       Const MethodName : String;
                                       Const AccessType : Byte = 0) : Boolean;
begin
  Result := False;
  Case FuncNo Of
    //Btrieve funcs
    1..99     : Result := (FIntfType = imGeneral);

    // .Clone method
    104       : Result := (FIntfType = imGeneral);
    // .UpdateCharge method
    105       : Result := (FIntfType = imGeneral);
  end;
end;

Procedure TJobActual.CopyDataRecord;
begin
  Move(FBtrIntf^.LJobDetl.JobActual, FJARec, SizeOf(FJARec));
end;

Function TJobActual.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  With FBtrIntf^ Do Begin
    BtrOpCode := BtrOp;
    KeyS := SetKeyString(BtrOp, JBRCode + JBECode + FullJobCode(FParentJobCode) + SearchKey);

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS := JBRCode + JBECode + FullJobCode(FParentJobCode) + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS := JBRCode + JBECode + FullJobCode(FParentJobCode) + #255;
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                     End;

      // Looking for exact match - do it and finish
      B_GetEq      : Loop := False;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    Repeat
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      BtrOpCode := BtrOpCode2;


      {PR 24/06/2008 - If we've passed the Prefix/SubType we want then drop out of loop
       to avoid reading remaining records in file - may improve SQL performance.}
      if (Result = 0) and ((LJobDetl.RecPFix <> JBRCode) or (LJobDetl.SubType <> JBECode)) then
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or ((LJobDetl.RecPFix = JBRCode) And (LJobDetl.SubType = JBECode));



    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LJobDetl.RecPFix = JBRCode) And (LJobDetl.SubType = JBECode) and
         (Trim(LJobDetl.JobActual.JobCode) = Trim(FParentJobCode))  Then
      begin
        // Convert to Toolkit structure
        CopyDataRecord;
        FKeyString := KeyS;
      end
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

{  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (63, Result);}
End; { GetDataRecord }

Procedure TJobActual.CloneDetails (Const JDets : JobActType);
begin
  Move(JDets, FJARec, SizeOf(FJARec));
end;

Procedure TJobActual.InitObjects;
begin
  FTriO := nil;
  FTriI := nil;
end;

function TJobActual.Clone : IJobActual;
var
  TempO : TJobActual;
begin
  AuthoriseFunction(104, 'Clone');
  TempO := TJobActual.Create(imClone, FToolkit, FBtrIntf, FParentJobCode);
  TempO.CloneDetails(FJARec);

  Result := TempO;
end;

function TJobActual.Get_Index: TJobActualIndexType;
begin
  Result := inherited Get_Index;
end;

procedure TJobActual.Set_Index(Value: TJobActualIndexType);
begin
  inherited Set_Index(Value);
end;

function TJobActual.BuildLedgerIndex(Posted: WordBool; Currency: Byte; Invoiced: WordBool): WideString;
var
  PostBool, InvBool : Boolean;
begin
  PostBool := WordBoolToBool(Posted);
  InvBool := WordBooltoBool(Invoiced);
  Result := Char(Ord(PostBool)) + Char(Currency) + Char(Ord(InvBool));
end;

function TJobActual.BuildAnalysisCodeIndex(const AnalysisCode: WideString): WideString;
begin
  Result := FullJACode(AnalysisCode);
end;

function TJobActual.BuildStockCodeIndex(const StockCode: WideString): WideString;
begin
  Result := FullStockCode(StockCode);
end;

function TJobActual.BuildAnalysisCategoryIndex(AnalysisType: TAnalysisType): WideString;
begin
  Result := FullNomKey(Succ(AnalysisType));
end;

Function TJobActual.TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt;
begin
  if FromTLB then
  begin
    if IdxNo = jaIdxAnalysisCategory then
      Result := 6
    else
      Result := IdxNo;
  end
  else
  begin
    if IdxNo = 6 then
      Result := jaIdxAnalysisCategory
    else
      Result := IdxNo;
  end;
end;

function TJobActual.UpdateCharge(NewValue: Double): Integer;
var
  Res : integer;
begin

  AuthoriseFunction(105, 'UpdateCharge');
{  if not FJARec.Posted then
  begin}
    Result := LockCID;

    if Result = 0 then
    begin
      FJARec.Charge := NewValue;
      FBtrIntf^.LJobDetl.JobActual.Charge := NewValue;
      Result := FBtrIntf^.LPut_Rec(FFileNo, FIndex);
    end;
{  end
  else
    Result := 30000;}
end;

function TJobActual.Get_jaUpliftTotal: Double;
begin
  Result := FJARec.UpliftTotal;
end;

function TJobActual.Get_jaUpliftGL: Integer;
begin
  Result := FJARec.UpliftGL;
end;

function TJobActual.GetTriRec : TriCurType;
begin
  Result := FJARec.PCTriR;
end;


//IBrowseInfo
function TJobActual.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;





end.
