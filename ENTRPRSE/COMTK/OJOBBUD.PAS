unit oJobBud;
{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE04}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, oBtrieve, GlobVar, VarConst, VarCnst3, MiscFunc,
     BtrvU2, ExBTTH1U, GlobList, VarJcstU;

const
  btSummary = 0;
  btAnalysis = 1;
  btStockRate = 2;

{  btSummaryCodes : Array[0..17] of Char = (#99, #10, #20, #30, #40, #50, #60, #160, #170, #180, #190,
                                           #11,#12,#13,#14,#15,#16,#17);}
  btSummaryCodes : Array[0..17] of Char = (#99, #10, #20, #30, #40, #50, #60, #160, #170, #180, #190,
                                           #23,#53,#63,#14,#5,#173,#67);


type
  TJobBudget = class(TBtrieveFunctions, IJobBudget, IBrowseInfo)
  private
    FBudgetRec : JobBudgType;
    FBudgetType : integer;
    FIntfType  : TInterfaceMode;
    FParentJobCode : string;
    FToolkit : TObject;
    FPeriod, FYear : Byte;
    FHaveJobRec : Boolean;
    FGotPeriodRec : Boolean;
    Function Major_Hed(n  :  byte)  :  Str255;
    function BudgetValue(WhichOne : Byte) : Double;
    Function SaveBudgetValue (Committed : SmallInt) : SmallInt;
    function ValidateSave : longint;
  protected
    function Get_jbAnalysisType: TAnalysisType; safecall;
    procedure Set_jbAnalysisType(Value: TAnalysisType); safecall;
    function Get_jbUnitPrice: Double; safecall;
    procedure Set_jbUnitPrice(Value: Double); safecall;
    function Get_jbOriginalQty: Double; safecall;
    procedure Set_jbOriginalQty(Value: Double); safecall;
    function Get_jbRevisedQty: Double; safecall;
    procedure Set_jbRevisedQty(Value: Double); safecall;
    function Get_jbOriginalValue: Double; safecall;
    procedure Set_jbOriginalValue(Value: Double); safecall;
    function Get_jbRevisedValue: Double; safecall;
    procedure Set_jbRevisedValue(Value: Double); safecall;
    function Get_jbPeriod: Integer; safecall;
    procedure Set_jbPeriod(Value: Integer); safecall;
    function Get_jbYear: Integer; safecall;
    procedure Set_jbYear(Value: Integer); safecall;
    function Get_jbCategory: TJobBudgetCategoryType; safecall;
    procedure Set_jbCategory(Value: TJobBudgetCategoryType); safecall;
    function Get_jbCategoryString: WideString; safecall;

    function DoAdd: IJobBudget; safecall;
    function DoUpdate: IJobBudget; safecall;
    function DoClone: IJobBudget; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function Delete: Integer; safecall;
    function Get_jbAnalysisCode: WideString; safecall;
    procedure Set_jbAnalysisCode(const Value: WideString); safecall;
    function Get_jbAnalysisCodeI: IJobAnalysis; safecall;
    function Get_jbFolio: Integer; safecall;
    function Get_jbRecharge: WordBool; safecall;
    procedure Set_jbRecharge(Value: WordBool); safecall;

    function Get_jbOriginalValuation: Double; safecall;
    procedure Set_jbOriginalValuation(Value: Double); safecall;
    function Get_jbRevisedValuation: Double; safecall;
    procedure Set_jbRevisedValuation(Value: Double); safecall;
    function Get_jbUplift: Double; safecall;
    procedure Set_jbUplift(Value: Double); safecall;

    function Get_jbCostOverhead: Double; safecall;
    procedure Set_jbCostOverhead(Value: Double); safecall;

    function Get_jbApplyPercent: Double; safecall;
    procedure Set_jbApplyPercent(Value: Double); safecall;
    function Get_jbApplicationBasis: TBudgetAppBasisType; safecall;
    procedure Set_jbApplicationBasis(Value: TBudgetAppBasisType); safecall;

    function Get_jbCurrency: Integer; safecall;
    procedure Set_jbCurrency(Value: Integer); safecall;

    //StockTimeRate
    function Get_jbPayRateMode: WordBool; safecall;
    procedure Set_jbPayRateMode(Value: WordBool); safecall;
    function Get_jbPayRateCurrency: Integer; safecall;
    procedure Set_jbPayRateCurrency(Value: Integer); safecall;
    function Get_jbStockOrRateCode: WideString; safecall;
    procedure Set_jbStockOrRateCode(const Value: WideString); safecall;


    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;


    function BuildCategoryIndex(Category: TJobBudgetCategoryType): WideString; safecall;
    function BuildAnalysisCodeIndex(const AnalysisCode: WideString): WideString; safecall;
    function BuildStockCodeIndex(const StockCode: WideString): WideString; safecall;
    function BuildTimeRateIndex(const TimeRate: WideString): WideString; safecall;
    function BuildAnalysisCategoryIndex(Category: TJobBudgetCategoryType): WideString; safecall;

    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    procedure  AuthoriseSQLFuncs; override;

    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;

    // Local methods
    Procedure CloneDetails (Const BudgetRec : JobBudgType);
    Function Get_NextJAFolio(JCode  :  Str10;
                                    Update :  Boolean)  :  LongInt;

  public
    Procedure LoadDetails (Const JBDets : JobBudgType; Const LockPos : LongInt;
                                       iYear, iPeriod : Byte; bGotPeriodRec : Boolean);
    Constructor Create(Const IType      : TInterfaceMode;
                       const Toolkit    : TObject;
                       Const BtrIntf    : TCtkTdPostExLocalPtr;
                       const BudgetType : Integer;
                       const JobCode    : string);
    destructor Destroy; override;
  end;

  //PR: 26/03/2013 ABSEXCH-13535 Added ISummaryJobBudget3
  TSummaryJobBudget = Class(TJobBudget, ISummaryJobBudget, ISummaryJobBudget2, ISummaryJobBudget3)
  protected
    function Get_Index: TSummaryJobBudgetIndex; safecall;
    procedure Set_Index(Value: TSummaryJobBudgetIndex); safecall;
    function Update: ISummaryJobBudget; safecall;
    function Clone: ISummaryJobBudget; safecall;
  end;

  TAnalysisJobBudget = Class(TJobBudget, IAnalysisJobBudget, IAnalysisJobBudget2, IAnalysisJobBudget3)
  protected
    function Get_Index: TAnalysisJobBudgetIndex; safecall;
    procedure Set_Index(Value: TAnalysisJobBudgetIndex); safecall;
    function Add: IAnalysisJobBudget; safecall;
    function Update: IAnalysisJobBudget; safecall;
    function Clone: IAnalysisJobBudget; safecall;
  end;

  TTimeAndStockJobBudget = Class(TJobBudget, ITimeAndStockJobBudget, ITimeAndStockJobBudget2)
  protected
    function Get_Index: TTimeAndStockJobBudgetIndex; safecall;
    procedure Set_Index(Value: TTimeAndStockJobBudgetIndex); safecall;

    function Add: ITimeAndStockJobBudget; safecall;
    function Update: ITimeAndStockJobBudget; safecall;
    function Clone: ITimeAndStockJobBudget; safecall;
  end;


  function CreateTJobBudget(Const Toolkit : TObject; Const ClientId : Integer;
                            const BudgetType : Integer; const JobCode : string) : TJobBudget;


implementation

uses
  ComServ, BtKeys1U, ETStrU, BtSupU1, DllErrU, oToolkit;

  Function FullJBDDKey(JC  :  Str10;
                       MH  :  LongInt)  :  Str20;
  Begin
    FullJBDDKey:=FullJobCode(JC)+FullNomKey(MH)+HelpKStop;
  end;




function CreateTJobBudget(Const Toolkit : TObject; Const ClientId : Integer;
                          const BudgetType : Integer; const JobCode : string) : TJobBudget;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
  FileNos : Array[0..4] of Byte;
Begin { CreateTAccount }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by object
  BtrIntf^.Open_System(JCtrlF, JCtrlF);
  BtrIntf^.Open_System(JobF, JobF);
  BtrIntf^.Open_System(NHistF, NHistF);

  if BudgetType > 0 then
    BtrIntf^.Open_System(JMiscF, JMiscF); //for Job Analysis Code

  if BudgetType > 1 then
    BtrIntf^.Open_System(StockF, StockF); //For Stock Code (Rate Code is in JCtrlF)

  Case BudgetType of
    btSummary   : Result := TSummaryJobBudget.Create(imGeneral, Toolkit, BtrIntf, BudgetType, JobCode);
    btAnalysis  : Result := TAnalysisJobBudget.Create(imGeneral, Toolkit, BtrIntf, BudgetType, JobCode);
    btStockRate : Result := TTimeAndStockJobBudget.Create(imGeneral, Toolkit, BtrIntf, BudgetType, JobCode);
    else
      raise Exception.Create('Invalid BudgetType ' + IntToStr(Ord(BudgetType)));
  end;

  if SQLBeingUsed then
  begin
    FillChar(FileNos, SizeOf(FileNos), 0);
    FileNos[0] := JCtrlF;
    FileNos[1] := JobF;
    FileNos[2] := NHistF;

    if BudgetType > 0 then
      FileNos[3] := JMiscF;

    if BudgetType > 1 then
      FileNos[4] := StockF;

    Result.SetFileNos(FileNos);
  end;

end;

Function BudBeen_Used(Const  Mode  :  Byte;
                      Const  JCode :  Str10;
                             KeyAC :  Str30)  :  Boolean;


Const
  Fnum  =  JDetlF;


Var
  KeyChk  :  Str255;
  KeyPath :  Integer;

  Function FullJDAnalKey(JC   :   Str10;
                         JA   :   Str10)  :  Str20;
  Begin
    FullJDAnalKey:=FullJobCode(JC)+FullJACode(JA);
  end;

  Function FullJDStkKey(JC   :   Str10;
                        JSC  :   Str20)  :  Str30;
  Begin
    FullJDStkKey:=FullJobCode(JC)+FullStockCode(JSC);
  end;


Begin
  KeyPath := 0;

  Case Mode of

    1,6
       :  Begin
            KeyPath:=JDAnalK;
            KeyChk:=PartCCKey(JBRCode,JBECode)+FullJDAnalKey(JCode,KeyAC);
          end;

    2,7
       :  Begin
            KeyPath:=JDStkK;
            KeyChk:=PartCCKey(JBRCode,JBECode)+FullJDStkKey(JCode,KeyAC);
          end;
  end; {Case..}


  BudBeen_Used:=CheckExsists(KeyChk,Fnum,Keypath);

end; {Func..}

Function TJobBudget.Get_NextJAFolio(JCode  :  Str10;
                                    Update :  Boolean)  :  LongInt;

Const

  Fnum      =  JobF;
  Keypath   =  JobCodeK;


Var
  LOk,
  Locked:  Boolean;

  Lnum  :  Longint;

  KeyS  :  Str255;


Begin

  With FBtrIntf^ do
  Begin
    Lnum:=0;

    KeyS:=FullJobCode(JCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);


    If (StatusOk) then
    With LJobRec^ do
    Begin

      Locked:=Not Update;

      LOk:=Not Update;

      If (Not LOk) then
      Begin
        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);
        LGetRecAddr(Fnum);
      end;

      If (LOk) And (Locked) then
      Begin

        Lnum:=ALineCount;

        {* Update NexFolio *}

        If (Update) then
        Begin
          Inc(ALineCount);

          LStatus:=LPut_Rec(Fnum,KeyPAth);

//          Report_Berror(Fnum,Status);

          LUnLockMLock(Fnum);
        end;

      end;

    end;

    Get_NextJAFolio:=Lnum;
  end; {With..}
end;



Constructor TJobBudget.Create(Const IType      : TInterfaceMode;
                              const Toolkit    : TObject;
                              Const BtrIntf    : TCtkTdPostExLocalPtr;
                              const BudgetType : Integer;
                              const JobCode    : string);
var
  Res : longint;
  KeyS : Str255;
begin
  Case BudgetType of
    0  :  Inherited Create (ComServer.TypeLib, ISummaryJobBudget3, BtrIntf); //PR: 21/01/2011 ABSEXCH-10392
    1  :  Inherited Create (ComServer.TypeLib, IAnalysisJobBudget3, BtrIntf); //PR: 21/01/2011 ABSEXCH-10392
    2  :  Inherited Create (ComServer.TypeLib, ITimeAndStockJobBudget2, BtrIntf); //PR: 21/01/2011 ABSEXCH-10392
  end;

  // Initialise Btrieve Ancestor
  FBtrIntf := BtrIntf;
  FFileNo := JCtrlF;
  FIntfType := IType;

  // Initialise variables
  FillChar(FBudgetRec, SizeOf(FBudgetRec), 0);
  FBudgetType := BudgetType;
  FToolkit := Toolkit;
  FParentJobCode := JobCode;
  FBudgetRec.JobCode := JobCode;
  KeyS := JobCode;
  FIndex := 0;
  FGotPeriodRec := False;

  FPeriod := Syss.CPr;
  FYear := Syss.CYr;

  Res := FBtrIntf^.LFind_Rec(B_GetEq, JobF, 0, KeyS);

  FHaveJobRec := Res = 0;
end;

destructor TJobBudget.Destroy;
begin

  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;

end;



function TJobBudget.Get_jbAnalysisType: TAnalysisType;
begin
  Result := Pred(FBudgetRec.BType);
end;

procedure TJobBudget.Set_jbAnalysisType(Value: TAnalysisType);
begin
  FBudgetRec.BType := Succ(Value);
end;

function TJobBudget.Get_jbUnitPrice: Double;
begin
  Result := FBudgetRec.UnitPrice;

end;

procedure TJobBudget.Set_jbUnitPrice(Value: Double);
begin
  FBudgetRec.UnitPrice := Value;
end;

function TJobBudget.Get_jbOriginalQty: Double;
begin
//  Result := FBudgetRec.BoQty;
  Result := BudgetValue(1);
end;

procedure TJobBudget.Set_jbOriginalQty(Value: Double);
begin
  FBudgetRec.BoQty := Value;
end;

function TJobBudget.Get_jbRevisedQty: Double;
begin
//  Result := FBudgetRec.BRQty;
  Result := BudgetValue(3);
end;

procedure TJobBudget.Set_jbRevisedQty(Value: Double);
begin
  FBudgetRec.BRQty := Value;
end;

function TJobBudget.Get_jbOriginalValue: Double;
begin
//  Result := FBudgetRec.BoValue;
  Result := BudgetValue(2);
end;

procedure TJobBudget.Set_jbOriginalValue(Value: Double);
begin
  FBudgetRec.BoValue := Value;
end;

function TJobBudget.Get_jbRevisedValue: Double;
begin
//  Result := FBudgetRec.BRValue;
  Result := BudgetValue(4);
end;

procedure TJobBudget.Set_jbRevisedValue(Value: Double);
begin
  FBudgetRec.BRValue := Value;
end;

function TJobBudget.Get_jbPeriod: Integer;
begin
  Result := FPeriod;
end;

procedure TJobBudget.Set_jbPeriod(Value: Integer);
begin
  FPeriod := Value;
end;

function TJobBudget.Get_jbYear: Integer;
begin
  Result := FYear;
end;

procedure TJobBudget.Set_jbYear(Value: Integer);
begin
  if Value > 1900 then
    FYear := Value - 1900
  else
    FYear := Value;
end;

function TJobBudget.DoAdd: IJobBudget;
Var
  FJBO : TJobBudget;
begin
  Result := Nil;
  AuthoriseFunction(100, 'Add');

  Case FBudgetType of
    btSummary   : FJBO := TSummaryJobBudget.Create(imAdd, FToolkit, FBtrIntf, FBudgetType, FParentJobCode);
    btAnalysis  : FJBO := TAnalysisJobBudget.Create(imAdd, FToolkit, FBtrIntf, FBudgetType, FParentJobCode);
    btStockRate : FJBO := TTimeAndStockJobBudget.Create(imAdd, FToolkit, FBtrIntf, FBudgetType, FParentJobCode);
    else
      raise Exception.Create('Invalid BudgetType ' + IntToStr(Ord(FBudgetType)));
  end;

  Case FBudgetType of
    btSummary   :  Result := FJBO as ISummaryJobBudget;
    btAnalysis  :  Result := FJBO as IAnalysisJobBudget;
    btStockRate :  Result := FJBO as ITimeAndStockJobBudget;
    else
      raise Exception.Create('Invalid BudgetType ' + IntToStr(Ord(FBudgetType)));
  end;
end;

function TJobBudget.DoUpdate: IJobBudget;
Var
  FJBO : TJobBudget;
  FuncRes   : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    Case FBudgetType of
      btSummary   : FJBO := TSummaryJobBudget.Create(imUpdate, FToolkit, FBtrIntf, FBudgetType, FParentJobCode);
      btAnalysis  : FJBO := TAnalysisJobBudget.Create(imUpdate, FToolkit, FBtrIntf, FBudgetType, FParentJobCode);
      btStockRate : FJBO := TTimeAndStockJobBudget.Create(imUpdate, FToolkit, FBtrIntf, FBudgetType, FParentJobCode);
      else
        raise Exception.Create('Invalid BudgetType ' + IntToStr(Ord(FBudgetType)));
    end;
    // Pass current Account Record and Locking Details into sub-object
    FJBO.LoadDetails(FBudgetRec, LockPosition, FYear, FPeriod, FGotPeriodRec);
    LockCount := 0;
    LockPosition := 0;

    Case FBudgetType of
      btSummary   :  Result := FJBO as ISummaryJobBudget;
      btAnalysis  :  Result := FJBO as IAnalysisJobBudget;
      btStockRate :  Result := FJBO as ITimeAndStockJobBudget;
    end;
  End; { If (FuncRes = 0) }
end; { Update }

function TJobBudget.DoClone: IJobBudget;
Var
  FJBO : TJobBudget;
begin
  Result := Nil;
  AuthoriseFunction(104, 'Clone');

  Case FBudgetType of
    btSummary   : FJBO := TSummaryJobBudget.Create(imClone, FToolkit, FBtrIntf, FBudgetType, FParentJobCode);
    btAnalysis  : FJBO := TAnalysisJobBudget.Create(imClone, FToolkit, FBtrIntf, FBudgetType, FParentJobCode);
    btStockRate : FJBO := TTimeAndStockJobBudget.Create(imClone, FToolkit, FBtrIntf, FBudgetType, FParentJobCode);
    else
      raise Exception.Create('Invalid BudgetType ' + IntToStr(Ord(FBudgetType)));
  end;

  FJBO.CloneDetails(FBudgetRec);

  Case FBudgetType of
    btSummary   :  Result := FJBO as ISummaryJobBudget;
    btAnalysis  :  Result := FJBO as IAnalysisJobBudget;
    btStockRate :  Result := FJBO as ITimeAndStockJobBudget;
    else
      raise Exception.Create('Invalid BudgetType ' + IntToStr(Ord(FBudgetType)));
  end;
end;

function TJobBudget.Save: Integer;
var
  s : string;

  //PR: 21/09/2012 ABSEXCH-13447 Need to change 99 to 0 to pick up
  //correct value (and avoid range check error.)
  function GetSummaryCode(AH : Byte) : Char;
  begin
    if AH = 99 then
      AH := 0;
    Result := btSummaryCodes[AH];
  end;

begin
  Result := ValidateSave;

  if (Result = 0) and not CheckOnly then
  begin
    if FIntfType = imAdd then
    begin
      FBudgetRec.HistFolio := Get_NextJAFolio(FParentJobCode, True);
      if FBudgetType in [btSummary, btAnalysis] then
        FBudgetRec.PayRMode := False;
    end;

    Case FBudgetType of  //PR: 21/09/2012 ABSEXCH-13447
      btSummary   : s := GetSummaryCode(FBudgetRec.AnalHed) + #0#0#0;
      btAnalysis  : s := FBudgetRec.AnalCode;
      btStockRate : s := FBudgetRec.StockCode;
    end;

    FBudgetRec.BudgetCode := FullJBCode(FBudgetRec.JobCode, 0{TheCcy}, s);

    Result := SaveBudgetValue(0);


    if (FIntfType = imUpdate) and SyssJob.JobSetup.PeriodBud then
      Unlock; //if period then record is stored in history file so we need to unlock budget rec.

    //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
    if Result = 0 then
      FIntfType := imClone;
  end;

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (600, Result);

end;

procedure TJobBudget.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

function TJobBudget.Get_jbCategory: TJobBudgetCategoryType;
begin
  Result := TJobBudgetCategoryType(FBudgetRec.AnalHed);
  //PR: 21/09/2012 ABSEXCH-13447 Change 99 to 6 for correct cat.
  if Result = 99 then
    Result := 6
  else
  if Result <= 6 then
    Dec(Result);
end;

procedure TJobBudget.Set_jbCategory(Value: TJobBudgetCategoryType);
begin
  if Value in [0..18] then
  begin
    if Value in [0..5] then
      FBudgetRec.AnalHed := Succ(Value)
    else
    if Value = 6 then //PR: 21/09/2012 ABSEXCH-13447
      FBudgetRec.AnalHed := 99
    else
      FBudgetRec.AnalHed := Value;
  end
  else
    raise ERangeError.Create('Index out of range (' + IntToStr(Value) + ')');
end;

function TJobBudget.Get_jbCategoryString: WideString;
begin
  Result := Major_Hed(FBudgetRec.AnalHed);
end;

Function TJobBudget.AuthoriseFunction (Const FuncNo     : Byte;
                            Const MethodName : String;
                            Const AccessType : Byte = 0) : Boolean;
begin
  Result := False;
  Case FuncNo Of
    //Btrieve funcs
    1..99     : Result := (FIntfType = imGeneral);
    // .Add method
    100       : Result := (FIntfType = imGeneral);
    // .Update method
    101       : Result := (FIntfType = imGeneral); //PR: 21/09/2010 - This was previously 105 while update method was passing 101
    // .Save method
    102       : Result := (FIntfType in [imAdd, imUpdate]); //PR: 21/09/2010 - Added imUpdate
    // .Clone method
    104       : Result := (FIntfType = imGeneral);
    // .Delete method
    106       : Result := (FIntfType = imGeneral) and (FBudgetType <> btSummary);
  end;

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }
end;

Procedure TJobBudget.CopyDataRecord;
var
  HoldCurrency : Byte;
begin
  //PR: 25/09/2012 ABSEXCH-13463 Copying the record will overwrite any currency that's been set, so
  //store it then restore it - only necessary for split by period.
  HoldCurrency := FBudgetRec.JBudgetCurr;
  Move(FBtrIntf^.LJobCtrl^.JobBudg, FBudgetRec, SizeOf(FBudgetRec));
  FGotPeriodRec := False;
  if SyssJob.JobSetup.PeriodBud then
  begin
    //PR: 25/09/2012 ABSEXCH-13463 Restore currency
    FBudgetRec.JBudgetCurr := HoldCurrency;
    BudgetValue(1);
  end;
end;

Function TJobBudget.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
  cPrefix, cSubType     : Char;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  cPrefix := JBRCode;
  BtrOpCode2 := 0;
  cSubType := #0;

  Case FBudgetType of
    0 :  cSubType := JBMCode;
    1 :  cSubType := JBBCode;
    2 :  cSubType := JBSCode;
  end;

  With FBtrIntf^ Do Begin
    BtrOpCode := BtrOp;
//    KeyS := cPrefix + cSubType + FullJBCode(FParentJobCode, 32, SearchKey);
    KeyS := SetKeyString(BtrOp, cPrefix + cSubType + LJVar(FParentJobCode, 10) + LJVar(SearchKey, 16));

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
{                       KeyS := cPrefix + cSubType + FullJBCode(FParentJobCode,
                                                0, #0);}
                       KeyS := cPrefix + cSubType + FParentJobCode;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
{                       BtrOpCode  := B_GetFirst;
                       BtrOpCode2 := B_GetNext;}
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       {KeyS := cPrefix + FRecTypeCode + #255;}
                       KeyS := cPrefix + cSubType + FParentJobCode + #255;
{                       Keys := cPrefix + cSubType + FullJBCode(FParentJobCode,
                                                0, #255);}
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                     End;

      B_GetEq      : begin
{                       BtrOPCode := B_GetGEq;
                       BtrOpCode2 := B_GetNext;}
                       Loop := False;
                     end;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    Repeat
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      BtrOpCode := BtrOpCode2;

      {PR 24/06/2008 - If we've passed the Prefix/SubType we want then drop out of loop
       to avoid reading remaining records in file - may improve SQL performance.}
      if (Result = 0) and ((LJobCtrl.RecPFix <> cPrefix) or (LJobCtrl.SubType <> cSubType)) then
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or ((LJobCtrl.RecPFix = cPrefix) And (LJobCtrl.SubType = cSubType));

    FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LJobCtrl.RecPFix = cPrefix) And (LJobCtrl.SubType = cSubType) and
         (LJobCtrl.JobBudg.JobCode = FParentJobCode) then
      begin
        // Convert to Toolkit structure
        CopyDataRecord;

      end
      Else
      begin  //Need to return the appropriate result
        if BtrOp = B_GetEq then
          Result := 4
        else
          Result := 9;
      end;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }
end;


Procedure TJobBudget.CloneDetails (Const BudgetRec : JobBudgType);
begin
  FBudgetRec := BudgetRec;
end;

function TJobBudget.Get_jbAnalysisCode: WideString;
begin
  Result := FBudgetRec.AnalCode;
end;

procedure TJobBudget.Set_jbAnalysisCode(const Value: WideString);
begin
  FBudgetRec.AnalCode := LJVar(UpperCase(Value), AnalKeyLen);
end;

function TJobBudget.Get_jbAnalysisCodeI: IJobAnalysis;
begin
  with FToolkit as TToolkit do
    Result := JobCostingO.JobAnalysisO.GetCloneInterface(FBudgetRec.AnalCode);
end;

function TJobBudget.Get_jbFolio: Integer;
begin
  Result := FBudgetRec.HistFolio;
end;

function TJobBudget.Get_jbRecharge: WordBool;
begin
  Result := BoolToWordBool(FBudgetREc.ReCharge);
end;

procedure TJobBudget.Set_jbRecharge(Value: WordBool);
begin
  FBudgetRec.ReCharge := WordBoolToBool(Value);
end;

function TJobBudget.Get_jbCostOverhead: Double;
begin
  Result := FBudgetRec.OverCost;
end;

procedure TJobBudget.Set_jbCostOverhead(Value: Double);
begin
  FBudgetRec.OverCost := Value;
end;

function TJobBudget.Get_jbApplyPercent: Double;
begin
  Result := FBudgetRec.JAPcntApp;
end;

procedure TJobBudget.Set_jbApplyPercent(Value: Double);
begin
  FBudgetRec.JAPcntApp := Value;
end;

function TJobBudget.Get_jbApplicationBasis: TBudgetAppBasisType;
begin
  Result := FBudgetRec.JABBasis;
end;

procedure TJobBudget.Set_jbApplicationBasis(Value: TBudgetAppBasisType);
begin
  FBudgetRec.JABBasis := Value;
end;

function TJobBudget.Delete: Integer;
var
  s : string;
  Mode : Byte;
begin
  Mode := 0;
  AuthoriseFunction(106, 'Delete');

  Case FBudgetType of
    btAnalysis  : begin
                    Mode := 1;
                    s := Get_jbAnalysisCode;
                  end;
    btStockRate : begin
                    Mode := 2;
                    s := FBudgetRec.StockCode;
                  end;
  end;

  if BudBeen_Used(Mode, FBudgetRec.JobCode, s) then
    Result := 30001
  else
    Result := FBtrIntf^.LDelete_Rec(FFileNo, FIndex);
end;

function TJobBudget.BuildCategoryIndex(Category: TJobBudgetCategoryType): WideString;
begin
  if Category < jbcReceipts then
  begin
    if Category = jbcProfit then
      Category := 0
    else
      Category := Succ(Category);
  end;
  Result := btSummaryCodes[Category] + #0#0#0;
end;

function TJobBudget.BuildAnalysisCategoryIndex(Category: TJobBudgetCategoryType): WideString;
begin
  Result := BuildCategoryIndex(Category);
end;

Function TJobBudget.Major_Hed(n  :  byte)  :  Str255;
Begin
  Result:='';

  If (n=99) then
    Result:=SyssJob^.JobSetUp.SummDesc[0]
  else
    If (n In [1..17]) then
      Result:=SyssJob^.JobSetUp.SummDesc[n]
    else
      Result:='';
end; {Func..}

function TJobBudget.BudgetValue(WhichOne : Byte) : Double;
var
  Balance,
{  LastYTD,
  ThisPr,
  ThisYTD,}
  Cleared,
  Budget,
  Budget2  :  Double;

  Qty1,
  Qty2     :  Double;

{  CrDr     :  DrCrDType;
  AcPr,AcYr
            :  Byte;}
  Range    :  Boolean;

  TmpVal, PPurch, PSales, PCleared : Double;
  KeyS : Str20;
begin
  Balance:=0;
{  LastYTD:=0;
  ThisPr:=0;
  ThisYTD:=0;}
  Cleared:=0;
  Budget:=0;
  Budget2:=0;
  Qty1:=0.0;
  Qty2:=0.0;

  PPurch := 0;
  PSales := 0;
  PCleared := 0;

  Result := 0;

  If (WhichOne In [1..4])  Then
  Begin

    if SyssJob.JobSetup.PeriodBud and not FGotPeriodRec then
    begin
      //PR: 14/09/2012 Call to profit to date wasn't setting range = true for ytd values (254, 255)
      //PR: 25/09/2012 ABSEXCH-13463 Pass currency into call to ptd.
      with FBtrIntf^, LJobRec^ do
        TmpVal := LTotal_QtProfit_To_Date(JobType,FullNHCode(FullJDHistKey(JobCode,FBudgetRec.HistFolio)),FBudgetRec.JBudgetCurr,
                                           FYear,FPeriod,PPurch,PSales,PCleared,Budget,Budget2,Qty1,Qty2,FPeriod in [254, 255]);

      FGotPeriodRec := True;


{    Case WhichOne of
      1  :  Result := Budget;
      2  :  Result := Budget2;
      3  :  Result := Qty1;
      4  :  Result := Qty2;
      1  :  Result := Qty1;
      2  :  Result := Budget;
      3  :  Result := Qty2;
      4  :  Result := Budget2;
    end; }

      FBudgetRec.BoQty := Qty1;
      FBudgetRec.BoValue := Budget;
      FBudgetRec.BRQty := Qty2;
      FBudgetRec.BRValue := Budget2;
    end;  //if SyssJob.JobSetup.PeriodBud and not FGotPeriodRec


    With FBudgetRec Do
      Case WhichOne Of
        1 : Result := BoQty;     { Orig Qty }
        2 : Result := BoValue;   { Orig Budget }
        3 : Result := BrQty;     { Revised Qty }
        4 : Result := BRValue;   { Revised Budget }
      End; { Case }
  end;


end;

function TJobBudget.Get_jbPayRateMode: WordBool;
begin
  Result := BoolToWordBool(FBudgetRec.PayRMode);
end;

procedure TJobBudget.Set_jbPayRateMode(Value: WordBool);
begin
  FBudgetRec.PayRMode := WordBoolToBool(Value);
end;

function TJobBudget.Get_jbPayRateCurrency: Integer;
begin
  Result := FBudgetRec.CurrPType;
end;

procedure TJobBudget.Set_jbPayRateCurrency(Value: Integer);
begin
  FBudgetRec.CurrPType := Value;
end;

function TJobBudget.Get_jbStockOrRateCode: WideString;
begin
  Result := FBudgetRec.StockCode;
end;

procedure TJobBudget.Set_jbStockOrRateCode(const Value: WideString);
begin
  FBudgetRec.StockCode := Value;
end;

Procedure TJobBudget.LoadDetails (Const JBDets : JobBudgType; Const LockPos : LongInt;
                                iYear, iPeriod : Byte; bGotPeriodRec : Boolean);
begin
  FBudgetRec := JBDets;
  FYear := iYear;
  FPeriod := iPeriod;
  FGotPeriodRec := bGotPeriodRec;
  LockCount := 1;
  LockPosition := LockPos;
end;

Function TJobBudget.SaveBudgetValue (Committed : SmallInt) : SmallInt;
Const
  FNum = NHistF;
  KPath = NHK;
Var
  KeyS, KeyR        : Str255;
  RecAddr           : LongInt;
  HistType          : Char;
  GotRec, IsPayMode : Boolean;
  lAnalysis         : ^JobAnalType;
  lPayRate          : ^EmplPayType;
  Locked            : Boolean;
  BudgType : String;
Begin

  with FBtrIntf^ do
  begin
    Case FBudgetType of
{      btSummary : BudgType := JBBCode;
      btAnalysis : BudgType := JBMCode;}
      btSummary : BudgType := JBMCode;
      btAnalysis : BudgType := JBBCode;
      btStockRate : BudgType := JBSCode;
    end;

    LJobCtrl.RecPfix := 'J';
    LJobCtrl.SubType := BudgType[1];
    Move(FBudgetRec, LJobCtrl.JobBudg, SizeOf(FBudgetRec));
{    Move(FBudgetRec, JobCtrl.JobBudg, SizeOf(FBudgetRec));
    JobCtrl.RecPfix := 'J';
    JobCtrl.SubType := BudgType[1];}
    If (Not SyssJob.JobSetup.PeriodBud) Then Begin


        if FIntfType = imAdd then
          Result := LAdd_Rec (JCtrlF, 0)
        else
        begin
          Result := PositionOnLock;
          Move(FBudgetRec, JobCtrl.JobBudg, SizeOf(FBudgetRec));
          JobCtrl.RecPfix := 'J';
          JobCtrl.SubType := BudgType[1];
          Result := Put_Rec(F[JCtrlF], JCtrlF, RecPtr[JCtrlF]^, FIndex) ;
        end;

    End { If }
    Else Begin
      { Budgets are in history - now it gets complicated }

      LCheckRecExsists(FBudgetRec.JobCode, JobF, 0);
      If (Committed <> 0) Then
        HistType := CommitHCode
      Else
        HistType := LJobRec.JobType;

      //PR: 14/09/2012 ABSEXCH-13428 Check if we have a CTD record for this year - if not, add one.
      //PR: 25/09/2012 ABSEXCH-13463 Include currency
      KeyS := FullNHistKey(HistType,
                           FullNHCode (FullJDHistKey(FBudgetRec.JobCode, FBudgetRec.HistFolio {LJobCtrl^.JobBudg.HistFolio})),
                           FBudgetRec.JBudgetCurr,
                           FYear{-1900},
                           255);




      If (Not LCheckExsists(KeyS, FNum, KPath)) Then Begin
        { Record doesn't exist - Set and Add }
        LResetRec (FNum);
        With LNHist Do Begin
          Code := FullNHCode (FullJDHistKey(FBudgetRec.JobCode, FBudgetRec.HistFolio));
          ExClass := HistType;
          //PR: 25/09/2012 ABSEXCH-13463 Include currency
          Cr := FBudgetRec.JBudgetCurr;
          Yr := FYear{ - 1900};
          Pr := 255;
        End; { With }

        Result := LAdd_Rec (Fnum, KPath);
      End; {If  need CTD}


      //PR: 25/09/2012 ABSEXCH-13463 Include currency
      KeyS := FullNHistKey(HistType,
                           FullNHCode (FullJDHistKey(FBudgetRec.JobCode, FBudgetRec.HistFolio {LJobCtrl^.JobBudg.HistFolio})),
                           FBudgetRec.JBudgetCurr,
                           FYear{-1900},
                           FPeriod);




      If (Not LCheckExsists(KeyS, FNum, KPath)) Then Begin
        { Record doesn't exist - Set and Add }
        LResetRec (FNum);
        With LNHist Do Begin
          Code := FullNHCode (FullJDHistKey(FBudgetRec.JobCode, FBudgetRec.HistFolio));
          ExClass := HistType;
          //PR: 25/09/2012 ABSEXCH-13463 Include currency
          Cr := FBudgetRec.JBudgetCurr;
          Yr := FYear{ - 1900};
          Pr := FPeriod;
        End; { With }

        LNHist.Value1  := FBudgetRec.BoQty;
        LNHist.Budget  := FBudgetRec.BoValue;
        LNHist.Value2  := FBudgetRec.BRQty;
        LNHist.RevisedBudget1 := FBudgetRec.BRValue;

        Result := LAdd_Rec (Fnum, KPath);
      End { If }
      Else Begin
        { found - get rec and update }
        GLobLocked:=BOff;
        Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
        LGetRecAddr(FNum);

        LNHist.Value1  := FBudgetRec.BoQty;
        LNHist.Budget  := FBudgetRec.BoValue;
        LNHist.Value2  := FBudgetRec.BRQty;
        LNHist.RevisedBudget1 := FBudgetRec.BRValue;

        { update record }
        Result := LPut_Rec (Fnum, KPath);
        LUnlockMLock(FNum);
      End;

      if (Result = 0) and (FBudgetType in [btAnalysis, btStockRate]) then
      begin
        if FIntfType = imAdd then
          Result := LAdd_Rec (JCtrlF, 0)
        else
        begin
          Result := PositionOnLock;
          Move(FBudgetRec, JobCtrl.JobBudg, SizeOf(FBudgetRec));
          JobCtrl.RecPfix := 'J';
          JobCtrl.SubType := BudgType[1];
          Result := Put_Rec(F[JCtrlF], JCtrlF, RecPtr[JCtrlF]^, FIndex) ;
        end;
      end;
    End;
  end; //with FBtrIntf^
End;

function TJobBudget.ValidateSave : longint;

  function ValidateAnalysisCode : SmallInt;
  var
    KeyS : Str255;
    Res : Boolean;

  begin
    with FBtrIntf^ do
    begin
      if LCheckExsists(JARCode + JAACode + FBudgetRec.AnalCode, JMiscF, 0) then
        Result := 0
      else
        Result := 30001;

      if Result = 0 then
      begin
        KeyS:='JB' + LJVar(FParentJobCode, 10) + LJVar(FBudgetRec.AnalCode, 16);
        Res := LCheckExsists(KeyS, JCtrlF, 0);

        //PR 2/9/03 - bugfix - changed error codes to 4 & 5
        if (FIntfType = imAdd) then
        begin
          if Res  then
            Result := 5;
        end
        else
        if (FIntfType = imUpdate) then
        begin
          if not Res  then
            Result := 4;
        end;
     end;


      if Result = 0 then
      begin
        //PR 2/9/03 - bugfix - was checking 1..10 rather than 0..9
        if not (FBudgetRec.AnalHed in [0..16]) then
          Result := 30006;
      end;
    end;

  end;

  function ValidateStockCode : SmallInt;
  var
    KeyS : Str255;
    Res : Boolean;
  begin
    with FBtrIntf^ do
    begin
      if (FBudgetRec.StockCode <> '') and LCheckExsists(FBudgetRec.StockCode, StockF, 0) then
        Result := 0
      else
        Result := 30002;

      if Result = 0 then
      begin
        KeyS:='JS' + LJVar(FParentJobCode, 10) + LJVar(FBudgetRec.StockCode, 16);
        Res := LCheckExsists(KeyS, JCtrlF, 0);

        if (FIntfType = imAdd) then
        begin
          if Res  then
            Result := 30007;
        end
        else
        if (FIntfType = imUpdate) then
        begin
          if not Res  then
            Result := 30008;
        end;
      end;
    end;
  end;

  function ValidateTimeRate : SmallInt;
  var
    KeyS : Str255;
    Res : Boolean;
  begin
    with FBtrIntf^ do
    begin
      if (FBudgetRec.StockCode <> '') and LCheckExsists(JBRCode + JBECode + FullJBCode(FullNomKey(-1), FBudgetRec.CurrPType, UpperCase(FBudgetRec.StockCode)), JCtrlF, 0) then
        Result := 0
      else
        Result := 30003;

      if Result = 0 then
      begin
        KeyS:='JS' + LJVar(FParentJobCode, 10) + LJVar(FBudgetRec.StockCode, 16);
        Res := LCheckExsists(KeyS, JCtrlF, 0);

        if (FIntfType = imAdd) then
        begin
          if Res  then
            Result := 30007;
        end
        else
        if (FIntfType = imUpdate) then
        begin
          if not Res  then
            Result := 30008;
        end;
      end;
    end;
  end;


begin
  Result := 0;


  Case FBudgetType of
    btAnalysis  : //AP : 06/03/2017 2017-R1 ABSEXCH-10343 : Importing Job Budgets - Validation required for 4 Categories to accept blank Analysis Codes
                  if (not (FBudgetRec.AnalHed in [8,15,17,99])) or (Trim(FBudgetRec.AnalCode)<>'') then
                    Result := ValidateAnalysisCode;
    btStockRate : if FBudgetRec.PayRMode then
                    Result := ValidateTimeRate
                  else
                    Result := ValidateStockCode;
  end; //case                                          

  //Set second index field
  if Result = 0 then
   if FBudgetType <> btSummary then
     FBudgetRec.Code2Ndx := FullJBDDKey(FBudgetRec.JobCode, FBudgetRec.AnalHed);


  if SyssJob.JobSetup.PeriodBud then
  begin //Check period and Year
    if Result = 0 then
      if ((FPeriod < 1) or (FPeriod > Syss.PrInYr)) then
        Result := 30004;

    if Result = 0 then
      if FYear < 1 then
        Result := 30005;
  end;

end;

function TJobBudget.BuildAnalysisCodeIndex(const AnalysisCode: WideString): WideString;
begin
  Result := LJVar(UpperCase(AnalysisCode), AnalKeyLen);
end;

function TJobBudget.BuildStockCodeIndex(const StockCode: WideString): WideString;
begin
  Result := FullStockCode(StockCode);
end;

function TJobBudget.BuildTimeRateIndex(const TimeRate: WideString): WideString;
begin
  Result := FullStockCode(TimeRate);
end;

function TJobBudget.Get_jbOriginalValuation: Double;
begin
  Result := FBudgetRec.OrigValuation;
end;

procedure TJobBudget.Set_jbOriginalValuation(Value: Double);
begin
end;

function TJobBudget.Get_jbRevisedValuation: Double;
begin
  Result := FBudgetRec.RevValuation;
end;

procedure TJobBudget.Set_jbRevisedValuation(Value: Double);
begin
  FBudgetRec.RevValuation := Value;
end;

function TJobBudget.Get_jbUplift: Double;
begin
  Result := FBudgetRec.JBUpliftP;
end;

procedure TJobBudget.Set_jbUplift(Value: Double);
begin
  FBudgetRec.JBUpliftP := Value;
end;

//============Summary budget

function TSummaryJobBudget.Update: ISummaryJobBudget;
begin
  Result := DoUpdate as ISummaryJobBudget;
end;

function TSummaryJobBudget.Clone: ISummaryJobBudget;
begin
  Result := DoClone as ISummaryJobBudget;
end;

function TSummaryJobBudget.Get_Index: TSummaryJobBudgetIndex;
begin
  Result := inherited Get_Index;
end;

procedure TSummaryJobBudget.Set_Index(Value: TSummaryJobBudgetIndex);
begin
  inherited Set_Index(Value);
end;


//======================Analysis budget

function TAnalysisJobBudget.Add: IAnalysisJobBudget;
begin
  Result := DoAdd as IAnalysisJobBudget;
end;

function TAnalysisJobBudget.Update: IAnalysisJobBudget;
begin
   Result := DoUpdate as IAnalysisJobBudget;
end;

function TAnalysisJobBudget.Clone: IAnalysisJobBudget;
begin
  Result := DoClone as IAnalysisJobBudget;
end;

function TAnalysisJobBudget.Get_Index: TAnalysisJobBudgetIndex;
begin
  Result := inherited Get_Index;
end;

procedure TAnalysisJobBudget.Set_Index(Value: TAnalysisJobBudgetIndex);
begin
  inherited Set_Index(Value);
end;



//======================TimeAndStock budget

function TTimeAndStockJobBudget.Get_Index: TTimeAndStockJobBudgetIndex;
begin
  Result := inherited Get_Index;
end;

procedure TTimeAndStockJobBudget.Set_Index(Value: TTimeAndStockJobBudgetIndex);
begin
  inherited Set_Index(Value);
end;

function TTimeAndStockJobBudget.Add: ITimeAndStockJobBudget;
begin
  Result := DoAdd as ITimeAndStockJobBudget;
end;

function TTimeAndStockJobBudget.Update: ITimeAndStockJobBudget;
begin
   Result := DoUpdate as ITimeAndStockJobBudget;
end;

function TTimeAndStockJobBudget.Clone: ITimeAndStockJobBudget;
begin
  Result := DoClone as ITimeAndStockJobBudget;
end;

//IBrowseInfo
function TJobBudget.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

function TJobBudget.Get_jbCurrency: Integer;
begin
  Result := FBudgetRec.JBudgetCurr;
end;

procedure TJobBudget.Set_jbCurrency(Value: Integer);
begin
  FBudgetRec.JBudgetCurr := Value;
  FGotPeriodRec := False;
end;




procedure TJobBudget.AuthoriseSQLFuncs;
begin
  raise EInvalidMethod.Create('The ISQLFunctions interface is not available in this object');
end;

end.
