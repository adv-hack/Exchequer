unit oJobApps;
{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     MiscFunc, oJobType, OJobAnal, oEmploy, oRates, oVoucher,
     oTrans, oBtrieve, GlobList, VarCnst3, VarConst, ExceptIntf;


type

  TAppsList = class(TAutoIntfObjectEx)
  private
    FID : SmallInt;
    FJobCode : string;
    FToolkit : TObject;
    FItemI : ITransaction3;
    FItemO : TTransaction2;
  protected
    function Get_Item : ITransaction3; safecall;

    function DoAdd : ITransaction3;
  public
    constructor Create(const DispIntf : TGUID; ID : SmallInt;
                       const JobCode : string;
                       const AToolkit : TObject);
  end;

  TTermsList = class(TAppsList, ITermsList)
  protected
    function Add: ITransaction3; safecall;
  end;

  TApplicationsList = class(TAppsList, IApplicationsList)
  protected
    function Add: ITransaction3; safecall;
  end;

  TJobApplications = class(TBtrieveFunctions, IJobApplications)
  private
//    FBtrIntf : TCtkTdPostExLocalPtr;
    FJob       : TBatchJHRec;
{    FPTRef,
    FSTRef   : string[10];

    FJobCode : string;}

    FToolkit : TObject;

    FPurchTermsI : ITransaction3;
    FPurchTermsO : TTransaction2;

    FMasterSalesTermsI : ITransaction3;
    FMasterSalesTermsO : TTransaction2;

    FContractTermsI : ITermsList;
    FContractTermsO : TTermsList;

    FSalesTermsI : ITermsList;
    FSalesTermsO : TTermsList;

    FPurchAppsI : IApplicationsList;
    FPurchAppsO : TApplicationsList;

    FSalesAppsI : IApplicationsList;
    FSalesAppsO : TApplicationsList;

    procedure InitObjects;
    function AddMasterTerms(WhichOne : Byte; UseBudgets : Boolean) : ITransaction3;
    procedure CreateBtrIntf;
  protected
    function Get_jbaPurchaseTerms: ITransaction3; safecall;
    function Get_jbaMasterSalesTerms: ITransaction3; safecall;
    function Get_jbaContractTerms: ITermsList; safecall;
    function Get_jbaSalesTerms: ITermsList; safecall;
    function Get_jbaPurchaseApplication: IApplicationsList; safecall;
    function Get_jbaSalesApplication: IApplicationsList; safecall;
    function AddPurchaseTerms(UseBudgets: WordBool): ITransaction3; safecall;
    function AddMasterSalesTerms(UseBudgets: WordBool): ITransaction3; safecall;
    procedure SetTerms(WhichOne : Byte; const OurRef : string);
    Procedure CopyDataRecord; override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; override;
  public
    constructor Create(const AToolkit : TObject;
                       const Job      : TBatchJHRec;
                       Const BtrIntf  : TCtkTdPostExLocalPtr);
    destructor Destroy; override;
  end;

  function CreateTJobApplications(const AToolkit : TObject;
                                const Job      : TBatchJHRec) : TJobApplications;


implementation

uses
  oJob, ComServ, oToolkit, VarRec2U, BtKeys1U, GlobVar, BtrvU2, BtSupU1;

{ TJobApplications }
const
  AppDocTypes : Array[40..43] of String[3] = ('JCT', 'JST', 'JPA', 'JSA');

function CreateTJobApplications(const AToolkit : TObject;
                                const Job      : TBatchJHRec) : TJobApplications;
var
  BtrIntf  : TCtkTdPostExLocalPtr;
begin
  New (BtrIntf, Create(44));

    // Open files needed by TTransaction object
  BtrIntf^.Open_System(CustF, CustF);
  BtrIntf^.Open_System(InvF, InvF);
  BtrIntf^.Open_System(IDetailF, IDetailF);
  BtrIntf^.Open_System(StockF, StockF);
  BtrIntf^.Open_System(MLocF, MLocF);
  BtrIntf^.Open_System(PwrdF, PwrdF);     { Transaction Notes }
  BtrIntf^.Open_System(JCtrlF, JCtrlF);   { Employee Time Rates for TSH }
  BtrIntf^.Open_System(JMiscF, JMiscF);   { Employee Records for TSH }
  BtrIntf^.Open_System(MiscF, MiscF);   { Links }
  BtrIntf^.Open_System(JobF, JobF);   { Links }

  Result := TJobApplications.Create(AToolkit, Job, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([CustF, InvF, IDetailF, StockF, MLocF, PwrdF, JCtrlF, JMiscF, MiscF, JobF]);
end;


constructor TJobApplications.Create(const AToolkit : TObject;
                                    const Job      : TBatchJHRec;
                                    Const BtrIntf  : TCtkTdPostExLocalPtr);
begin
  inherited Create(Comserver.TypeLib, IJobApplications, BtrIntf);
  InitObjects;
  FToolkit := AToolkit;
  FJob := Job;
end;

destructor TJobApplications.Destroy;
begin
  InitObjects;
  inherited Destroy;
end;

procedure TJobApplications.CreateBtrIntf;
begin
(*  if not Assigned(FBtrIntf) then
  begin
    New (FBtrIntf, Create(44));

    // Open files needed by TTransaction object
    FBtrIntf^.Open_System(CustF, CustF);
    FBtrIntf^.Open_System(InvF, InvF);
    FBtrIntf^.Open_System(IDetailF, IDetailF);
    FBtrIntf^.Open_System(StockF, StockF);
    FBtrIntf^.Open_System(MLocF, MLocF);
    FBtrIntf^.Open_System(PwrdF, PwrdF);     { Transaction Notes }
    FBtrIntf^.Open_System(JCtrlF, JCtrlF);   { Employee Time Rates for TSH }
    FBtrIntf^.Open_System(JMiscF, JMiscF);   { Employee Records for TSH }
    FBtrIntf^.Open_System(MiscF, MiscF);   { Links }
    FBtrIntf^.Open_System(JobF, JobF);   { Links }

  end; *)
end;


function TJobApplications.AddMasterTerms(WhichOne : Byte; UseBudgets : Boolean) : ITransaction3;
const
  Heds : Array[0..1] of string[3] = ('JST','JPT');
  RunNos : Array[0..1] of Integer = (JSTUPRunNo, JPTUPRunNo);
  FNum = JobF;
  Idx  = JobCodeK;
  Dtype : Array[0..1] of TDocTypes = (dtJST, dtJPT);
var
  TmpTransO : TTransaction2;
  TmpTransI : ITransaction3;
  ATH : TBatchTHRec;
  Res1, Res2 : Integer;
  Locked : Boolean;
  KeyS : Str255;

  procedure AddLine(const Budget : IAnalysisJobBudget; JC : String = '');
  begin
    with TmpTransI.thLines.Add do
    begin
      if JC = '' then
        tlJobCode := TmpTransI.thJobCode
      else
        tlJobCode := JC;
      tlQty := Budget.jbOriginalQty;
      tlCost := Budget.jbOriginalValue;

      tlAnalysisCode := Budget.jbAnalysisCode;
      tlDescr := Budget.jbAnalysisCodeI.anDescription;
      tlLineType := Budget.jbAnalysisCodeI.anLineType;
      ImportDefaults;

      tlVatCode := 'S'; //?????

      tlNetValue := tlCost;
      CalcVatAmount;
      tlNetValue := 0;

      Save;
    end;
  end;

  procedure AddContractLines(const JCode : String);
  var
    Res, JPos : Longint;
    OldIdx :  integer;
    OBud : IAnalysisJobBudget;
  begin
    with TToolkit(FToolkit).JobCostingI.Job as IJob2 do
    begin
      OldIdx := Index;
      Index := jrIdxParent;
      Res := GetGreaterThanOrEqual(BuildParentIndex(JCode, ''));

      while (Res = 0) and (Trim(jrParent) = Trim(JCode)) do
      begin

        if jrType = jTypeContract then
        begin
          SavePosition;
          JPos := Position;
          AddContractLines(jrParent);
          Position := JPos;
          RestorePosition;
        end
        else
        begin
          oBud := jrAnalysisBudget;

          Res := oBud.GetFirst;

          while Res = 0 do
          begin
            if ((WhichOne = 0) and (oBud.jbAnalysisType = anTypeRevenue)) or
               ((WhichOne = 1) and ((oBud.jbAnalysisType = anTypeLabour) or
                                    (oBud.jbCategory = jbcMaterials2))) then
               AddLine(oBud, jrCode);

            Res := oBud.GetNext;

          end;
        end;
        oBud := nil;
        Res := GetNext;

      end; //while Res
      Index := OldIdx;
    end; //with Job
  end;

  procedure AddLines;
  var
    Res : Longint;
  begin
    with TToolkit(FToolkit).JobCostingO.JobI as IJob2 do
    begin
      Res := jrAnalysisBudget.GetFirst;

      while Res = 0 do
      begin
        if ((WhichOne = 0) and (jrAnalysisBudget.jbAnalysisType = anTypeRevenue)) or
           ((WhichOne = 1) and ((jrAnalysisBudget.jbAnalysisType = anTypeLabour) or
                                (jrAnalysisBudget.jbCategory = jbcMaterials2))) then
           AddLine(jrAnalysisBudget);

           Res := jrAnalysisBudget.GetNext;

      end;

    end;
  end;


begin
  CreateBtrIntf;

  KeyS := FullJobCode(FJob.JobCode);
  Res1 := FBtrIntf^.LFind_Rec(B_GetEq, FNum, Idx, KeyS);

  if Res1 = 0 then
  begin
    FFileNo := FNum;
    FIndex := Idx;

    Res1 := Lock;
  end;


  if Res1 = 0 then
  begin

      TmpTransO := TTransaction2.Create(imMasterTerms, FToolkit, nil, FBtrIntf);
      TmpTransO.InitNewTrans(DType[WhichOne]);
      TmpTransO.SetTermsProc(SetTerms, Self);

      FillChar(ATH, SizeOf(ATH), 0);

      with TmpTransO do
      begin
//        ATH.TransDocHed := Heds[WhichOne];
        ATH.RunNo := RunNos[WhichOne];
        if WhichOne = 0 then
          ATH.CustCode := FJob.CustCode;

        ATH.TransDocHed := TH.TransDocHed;
        ATH.TransDate := TH.TransDate;
        ATH.AcYr := TH.AcYr;
        ATH.AcPr := TH.AcPr;

        ATH.DJobCode := FJob.JobCode;
        ATH.Currency := FJob.CurrPrice;

        ATH.MSTerms := WhichOne = 0;

        TH := ATH;

        SetJobCode(FJob.JobCode);
      end;

      TmpTransI := TmpTransO;
      TmpTransI.ImportDefaults;

      if UseBudgets then
      begin
        if TToolkit(FToolkit).JobCostingO.JobI.jrType = JTypeContract then
          AddContractLines(FJob.JobCode)
        else
          AddLines;

      end;

      Result := TmpTransI{.Save(True)};
{      if Result = 0 then
      begin
        if WhichOne = 0 then
          FBtrIntf^.LJobRec.JSTOurRef := TmpTransI.thOurRef
        else
          FBtrIntf^.LJobRec.JPTOurRef := TmpTransI.thOurRef;

        Unlock;
        Res1 := FBtrIntf^.LPut_Rec(JobF, 0);
      end;
 }
  end
  else
   // Result := Res1;
   raise Exception.Create('Unable to lock Job Record');
end;

function TJobApplications.AddMasterSalesTerms(UseBudgets: WordBool): ITransaction3;
begin
  if Trim(FJob.JSTOurRef) = '' then
    Result := AddMasterTerms(0, UseBudgets)
  else
    raise Exception.Create('MasterSalesTerms for Job ' + QuotedStr(Trim(FJob.JobCode)) + ' already exists');

end;

function TJobApplications.AddPurchaseTerms(UseBudgets: WordBool): ITransaction3;
begin
  if Trim(FJob.JPTOurRef) = '' then
    Result := AddMasterTerms(1, UseBudgets)
  else
    raise Exception.Create('PurchaseTerms for Job ' + QuotedStr(Trim(FJob.JobCode)) + ' already exists');
end;

function TJobApplications.Get_jbaSalesTerms: ITermsList;
begin
  if not Assigned(FSalesTermsO) then
  begin
    FSalesTermsO := TTermsList.Create(ITermsList, 41, FJob.JobCode, FToolkit);

    FSalesTermsI := FSalesTermsO;
  end;

  Result := FSalesTermsI;
end;

function TJobApplications.Get_jbaContractTerms: ITermsList;
begin
  if not Assigned(FContractTermsO) then
  begin
    FContractTermsO := TTermsList.Create(ITermsList, 40, FJob.JobCode, FToolkit);

    FContractTermsI := FContractTermsO;
  end;

  Result := FContractTermsI;
end;

function TJobApplications.Get_jbaMasterSalesTerms: ITransaction3;
var
  Res : longint;
begin
  if Trim(FJob.JPTOurRef) <> '' then
  begin
    if not Assigned(FMasterSalesTermsO) then
    begin
      CreateBtrIntf;
      FMasterSalesTermsO := TTransaction2.Create(imMasterTerms, FToolkit, nil, FBtrIntf);

      FMasterSalesTermsI := FMasterSalesTermsO;

      //Find correct transaction
      FMasterSalesTermsI.Index := thIdxOurRef;
      Res := FMasterSalesTermsI.GetEqual(FMasterSalesTermsI.BuildOurRefIndex(FJob.JSTOurRef));

      if Res <> 0 then // Transaction not found so free objects
        FMasterSalesTermsI := nil;
    end;

  end;
  Result := FMasterSalesTermsI;
end;

function TJobApplications.Get_jbaPurchaseApplication: IApplicationsList;
begin
  if not Assigned(FPurchAppsO) then
  begin
    FPurchAppsO := TApplicationsList.Create(IApplicationsList, 42, FJob.JobCode, FToolkit);

    FPurchAppsI := FPurchAppsO;
  end;

  Result := FPurchAppsI;
end;

function TJobApplications.Get_jbaPurchaseTerms: ITransaction3;
var
  Res : longint;
begin
  if Trim(FJob.JPTOurRef) <> '' then
  begin
    if not Assigned(FPurchTermsO) then
    begin
      CreateBtrIntf;
      FPurchTermsO := TTransaction2.Create(imMasterTerms, FToolkit, nil, FBtrIntf);

      FPurchTermsI := FPurchTermsO;

      //Find correct transaction
      FPurchTermsI.Index := thIdxOurRef;
      Res := FPurchTermsI.GetEqual(FPurchTermsI.BuildOurRefIndex(FJob.JPTOurRef));

      if Res <> 0 then // Transaction not found so free objects
        FPurchTermsI := nil;
    end;

  end;
  Result := FPurchTermsI;
end;

function TJobApplications.Get_jbaSalesApplication: IApplicationsList;
begin
  if not Assigned(FSalesAppsO) then
  begin
    FSalesAppsO := TApplicationsList.Create(IApplicationsList, 43, FJob.JobCode, FToolkit);

    FSalesAppsI := FSalesAppsO;
  end;

  Result := FSalesAppsI;
end;

procedure TJobApplications.SetTerms(WhichOne : Byte; const OurRef : string);
//Sets the Terms OurRef and saves & unlocks the job record
var
  Res1 : SmallInt;
begin
  if WhichOne = 0 then
    FBtrIntf^.LJobRec.JSTOurRef := OurRef
  else
    FBtrIntf^.LJobRec.JPTOurRef := OurRef;

  Unlock;
  Res1 := FBtrIntf^.LPut_Rec(JobF, 0);

end;


procedure TJobApplications.InitObjects;
begin
    FPurchTermsI := nil;
    FPurchTermsO := nil;

    FMasterSalesTermsI := nil;
    FMasterSalesTermsO := nil;

    FContractTermsI := nil;
    FContractTermsO := nil;

    FSalesTermsI := nil;
    FSalesTermsO := nil;

    FPurchAppsI := nil;
    FPurchAppsO := nil;

    FSalesAppsI := nil;
    FSalesAppsO := nil;

end;


procedure TJobApplications.CopyDataRecord;
begin
  //Do nothing - just here to remove warning
end;

function TJobApplications.GetDataRecord(const BtrOp: SmallInt;
  const SearchKey: String): Integer;
begin
  //Do nothing - just here to remove warning
  Result := 0;
end;

{ TAppsList }

function TAppsList.Get_Item: ITransaction3;
begin
  If (Not Assigned(FItemO)) Then Begin
    { Create and initialise Transaction Details }
    FItemO := CreateTTransaction (FToolkit, FID) as TTransaction2;
    FItemO.SetJobCode(FJobCode);
    FItemO.SetDocType(AppDocTypes[FID]);
    FItemI := FItemO;
  End; { If (Not Assigned(FTransactionO)) }

  Result := FItemI;
end;

constructor TAppsList.Create(const DispIntf : TGUID; ID : SmallInt;
                             const JobCode : string;
                             const AToolkit : TObject);
begin
  inherited Create(ComServer.TypeLib, DispIntf);
  FID := ID;
  FJobCode := JobCode;
  FToolkit := AToolkit;
end;

function TAppsList.DoAdd : ITransaction3;
var
  DType : TDocTypes;
begin
  Dtype := dtJCT;
  Case FID of
    40  :  DType := dtJCT;
    41  :  DType := dtJST;
    42  :  DType := dtJPA;
    43  :  DType := dtJSA;
  end;

  Result := Get_Item.Add(DType) as ITransaction3;

  Result.thJobCode := FJobCode;
end;


{ TTermsList }

function TTermsList.Add: ITransaction3;
begin
  Result := DoAdd;
end;

{ TApplicationsList }

function TApplicationsList.Add: ITransaction3;
begin
  Result := DoAdd;
end;

end.
