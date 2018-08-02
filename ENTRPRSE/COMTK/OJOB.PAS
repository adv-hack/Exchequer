unit oJob;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     oBtrieve, GlobVar, VarConst, VarCnst3, MiscFunc,
     BtrvU2, ExBTTH1U, oNotes, oLinks, oJobAct, oJobRet, oJobBud, GlobList,
     oJobApps, oRates;

type
  //PR: 14/03/2012 v6.10 Added IJob6 ABSEXCH-12510
  //PR: ABSEXCH-13202 Added IJob7
  //PR: 13/09/2013 ABSEXCH-13192 Added IJob8
  //AP: 08/12/2017 2018R1 ABSEXCH-19485 Added IJob9
  TJob = class(TBtrieveFunctions, IJob, IJob2, IJob3, IJob4, IJob5, IJob6, IJob7, IJob8, IJob9, IBrowseInfo)
  private
    // Note: All properties protected to allow descendants access

    // Toolkit Job record
    FJob       : TBatchJHRec;

    // Job Notes sub-object
    FNotesO         : TNotes;
    FNotesI         : INotes;

    FLinksO         : TLinks;
    FLinksI         : ILinks;

    FJobActO        : TJobActual;
    FJobActI        : IJobActual;

    FPurchRetO      : TJobRetention;
    FPurchRetI      : IJobRetention;

    FSalesRetO      : TJobRetention;
    FSalesRetI      : IJobRetention;

    FSumBudgeO      : TSummaryJobBudget;
    FSumBudgeI      : ISummaryJobBudget;

    FAnalBudgeO     : TAnalysisJobBudget;
    FAnalBudgeI     : IAnalysisJobBudget;

    FStockBudgeO    : TTimeAndStockJobBudget;
    FStockBudgeI    : ITimeAndStockJobBudget;

    FAppsO          : TJobApplications;
    FAppsI          : IJobApplications;

    FTimeRatesO     : TTimeRates;
    FTimeRatesI     : ITimeRates;


    // Main Job object
    FParentJob : TJob;

    // Main Toolkit object
    FToolkit   : TObject;

    // Object Type
    FIntfType  : TInterfaceMode;

    //PR: 31/08/2012 ABSEXCH-13202
    FExJobRec : JobRecType; //Exchequer job record needed for updating budgets
    FDeleteProcessedOK : Boolean; //Flag to indicate if all the delete sub-functions went ok.
  protected
    // IJobCosting
    function  Get_jrCode: WideString; safecall;
    procedure Set_jrCode(const Value: WideString); safecall;
    function  Get_jrDesc: WideString; safecall;
    procedure Set_jrDesc(const Value: WideString); safecall;
    function  Get_jrFolio: Integer; safecall;
    function  Get_jrAcCode: WideString; safecall;
    procedure Set_jrAcCode(const Value: WideString); safecall;
    function  Get_jrParent: WideString; safecall;
    procedure Set_jrParent(const Value: WideString); safecall;
    function  Get_jrAltCode: WideString; safecall;
    procedure Set_jrAltCode(const Value: WideString); safecall;
    function  Get_jrCompleted: WordBool; safecall;
    procedure Set_jrCompleted(Value: WordBool); safecall;
    function  Get_jrContact: WideString; safecall;
    procedure Set_jrContact(const Value: WideString); safecall;
    function  Get_jrManager: WideString; safecall;
    procedure Set_jrManager(const Value: WideString); safecall;
    function  Get_jrChargeType: TJobChargeType; safecall;
    procedure Set_jrChargeType(Value: TJobChargeType); safecall;
    function  Get_jrQuotePrice: Double; safecall;
    procedure Set_jrQuotePrice(Value: Double); safecall;
    function  Get_jrQuotePriceCurr: Smallint; safecall;
    procedure Set_jrQuotePriceCurr(Value: Smallint); safecall;
    function  Get_jrStartDate: WideString; safecall;
    procedure Set_jrStartDate(const Value: WideString); safecall;
    function  Get_jrEndDate: WideString; safecall;
    procedure Set_jrEndDate(const Value: WideString); safecall;
    function  Get_jrRevisedEndDate: WideString; safecall;
    procedure Set_jrRevisedEndDate(const Value: WideString); safecall;
    function  Get_jrSORNumber: WideString; safecall;
    procedure Set_jrSORNumber(const Value: WideString); safecall;
    function  Get_jrVATCode: WideString; safecall;
    procedure Set_jrVATCode(const Value: WideString); safecall;
    function  Get_jrJobType: WideString; safecall;
    procedure Set_jrJobType(const Value: WideString); safecall;
    function  Get_jrType: TJobTypeType; safecall;
    procedure Set_jrType(Value: TJobTypeType); safecall;
    function  Get_jrStatus: TJobStatusType; safecall;
    procedure Set_jrStatus(Value: TJobStatusType); safecall;
    function  Get_jrUserField1: WideString; safecall;
    procedure Set_jrUserField1(const Value: WideString); safecall;
    function  Get_jrUserField2: WideString; safecall;
    procedure Set_jrUserField2(const Value: WideString); safecall;
    function  Get_jrNotes: INotes; safecall;
    function  Get_jrJobTypeI: IJobType; safecall;

    //IJob2 methods
    function Get_jrLinks: ILinks; safecall;
    function Get_jrJobActual: IJobActual; safecall;
    function Get_jrPurchaseRetention: IJobRetention; safecall;
    function Get_jrSalesRetention: IJobRetention; safecall;
    function Get_jrSummaryBudget: ISummaryJobBudget; safecall;
    function Get_jrAnalysisBudget: IAnalysisJobBudget; safecall;
    function Get_jrTimeAndStockBudget: ITimeAndStockJobBudget; safecall;
    function Invoice: IJobInvoice; safecall;
    function Print(PrintAs: TJobPrintMode): IPrintJob; safecall;

    //IJob3 methods
    function Get_jrApplications: IJobApplications; safecall;
    function Get_jrTimeRates: ITimeRates; safecall;

    //IJob4 methods
    function Get_jrUserField3: WideString; safecall;
    procedure Set_jrUserField3(const Value: WideString); safecall;
    function Get_jrUserField4: WideString; safecall;
    procedure Set_jrUserField4(const Value: WideString); safecall;

    //PR: 26/10/2011 v6.9 IJob5
    function Get_jrUserField5: WideString; safecall;
    procedure Set_jrUserField5(const Value: WideString); safecall;
    function Get_jrUserField6: WideString; safecall;
    procedure Set_jrUserField6(const Value: WideString); safecall;
    function Get_jrUserField7: WideString; safecall;
    procedure Set_jrUserField7(const Value: WideString); safecall;
    function Get_jrUserField8: WideString; safecall;
    procedure Set_jrUserField8(const Value: WideString); safecall;
    function Get_jrUserField9: WideString; safecall;
    procedure Set_jrUserField9(const Value: WideString); safecall;
    function Get_jrUserField10: WideString; safecall;
    procedure Set_jrUserField10(const Value: WideString); safecall;

    //PR: 14/03/2012 v6.10 IJob6 ABSEXCH-12510
    function Get_jrQSCode: WideString; safecall;
    procedure Set_jrQSCode(const Value: WideString); safecall;

    //PR: ABSEXCH-13202 IJob7
    function Delete(DeleteLinkFiles: WordBool): Integer; safecall;
    function CanDelete: WordBool; safecall;

    //PR: 12/09/2013 ABSEXCH-13192 IJob8
    function Get_jrCostCentre: WideString; safecall;
    procedure Set_jrCostCentre(const Value: WideString); safecall;
    function Get_jrDepartment: WideString; safecall;
    procedure Set_jrDepartment(const Value: WideString); safecall;

    //AP: 08/12/2017 ABSEXCH-19485 IJob9
    function  Get_jrAnonymised: WordBool; safecall;
    function  Get_jrAnonymisedDate: WideString; safecall;
    function  Get_jrAnonymisedTime: WideString; safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;


    function  Get_Index: TStockIndex; safecall;
    procedure Set_Index(Value: TStockIndex); safecall;

    function  BuildCodeIndex(const JobCode: WideString): WideString; safecall;
    function  BuildFolioIndex(Folio: Integer): WideString; safecall;
    function  BuildParentIndex(const ParentCode: WideString; const JobCode: WideString): WideString; safecall;
    function  BuildDescIndex(const Description: WideString): WideString; safecall;
    function  BuildCompletedCodeIndex(Completed: WordBool; const JobCode: WideString): WideString; safecall;
    function  BuildCompletedDescIndex(Completed: WordBool; const Description: WideString): WideString; safecall;
    function  BuildAltCodeIndex(const AlternateCode: WideString): WideString; safecall;
    function  BuildAccountIndex(const AccountCode: WideString): WideString; safecall;

    function  Add: IJob; safecall;
    function  Update: IJob; safecall;
    function  Clone: IJob; safecall;
    function  Save: Integer; safecall;
    procedure Cancel; safecall;

    // Overridden TBtrieveFunctions methods
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    procedure InitNewRecord;

    // Local methods
    Procedure CloneDetails (Const JobDets : TBatchJHRec);
    Procedure InitObjects(FullReset : Boolean = True);
    Procedure LoadDetails (Const JobDets : TBatchJHRec; Const LockPos : LongInt);

    //Local methods called when deleting job record
    Function  LDelete_JobDetails(JCode  :  Str10;
                               JType  :  Char;
                               JFolio :  LongInt;
                               DelHist:  Boolean)  :  Boolean; //copied and adapted from Delete_JobDetails in JobSup1U.pas
    procedure DeleteRelatedRecords(DeleteLinkFiles: Boolean);
    procedure DeleteLinksAndLetters(DeleteFiles : Boolean);
    procedure DeletePayRates;
    function UpdateBudgets : Boolean;
    function RunGLCheck : Boolean;
  public
    Constructor Create(Const IType     : TInterfaceMode;
                       Const Toolkit   : TObject;
                       Const ParentJob : TJob;
                       Const BtrIntf   : TCtkTdPostExLocalPtr);
    Destructor Destroy; override;
    Function GetCloneInterface (Const Code : ShortString) : IJob;
  end; { TJob }

Function CreateTJob (Const Toolkit : TObject; Const ClientId : Integer) : TJob;

implementation

uses ComServ, DLLJobU, DllErrU, BtKeys1U, EtStrU,
     oToolkit,
     oJobType,
{$If Defined(COMPRNT)}
     EnterpriseForms_TLB,    // Type Library for Form Printing Toolkit
     oPrntJob,               // COM Toolkit Print Job Object
{$IfEnd}
     oJobInv,
     //PR: 29/08/2012 ABSEXCH-13202
     JobSup1U,
     NoteSupU,
     BtsupU1,
     JobBudgetUpdate,
     JobDeleteCheck,
     SQLUtils;

const
  {$I Filepath.inc}
{-------------------------------------------------------------------------------------------------}

Function CreateTJob (Const Toolkit : TObject; Const ClientId : Integer) : TJob;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTAccount }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by object
  BtrIntf^.Open_System(JobF, JobF);
  BtrIntf^.Open_System(PwrdF, PwrdF);   { Job Notes }
  BtrIntf^.Open_System(MiscF, MiscF);   { Job Links }
  BtrIntf^.Open_System(JCtrlF, JCtrlF);   { Job Rates }

  //PR: ABSEXCH-13202 Add JDetlF and HistF deleting a job
  BtrIntf^.Open_System(JDetlF, JDetlF);   { Job Rates }
  BtrIntf^.Open_System(NHistF, NHistF);   { Job Rates }

  // Create bas TAccount object
  Result := TJob.Create(imGeneral, Toolkit, NIL, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([PwrdF, JCtrlF, JobF, MiscF]);

End; { CreateTAccount }

{-------------------------------------------------------------------------------------------------}

Constructor TJob.Create(Const IType     : TInterfaceMode;
                        Const Toolkit   : TObject;
                        Const ParentJob : TJob;
                        Const BtrIntf   : TCtkTdPostExLocalPtr);
begin
//PR: 14/03/2012 v6.10 IJob6 ABSEXCH-12510
//PR: ABSEXCH-13202 IJob7
//PR: 13/09/2013 ABSEXCH-13192 Changed to IJob8
//AP: 08/12/2017 2018R1 ABSEXCH-19485 Changed to IJob9
  Inherited Create (ComServer.TypeLib, IJob9, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := JobF;

  // Initialise variables
  FillChar (FJob, SizeOf(FJob), #0);
  InitObjects;

  FToolkit := Toolkit;

  // Setup Link for child Customer objects to parent custom object
  FIntfType := IType;
  If Assigned(ParentJob) Then Begin
    FParentJob := ParentJob;
    FIndex := FParentJob.FIndex;
  End { If Assigned(ParentJob) }
  Else Begin
    FParentJob := Self;
    Set_Index(jrIdxCode);
  End; { Else }
  FObjectID := tkoJob;
end;

{-----------------------------------------}

destructor TJob.Destroy;
begin
  { Destroy sub-ojects }
  InitObjects;

  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
end;

{-----------------------------------------}

procedure TJob.InitObjects(FullReset : Boolean = True);
begin
  if FullReset then
  begin
  // Job Notes sub-object
    FNotesO := NIL;
    FNotesI := NIL;

    FParentJob := NIL;
    FToolkit := NIL;
  end;

  FLinksO := nil;
  FLinksI := nil;

  FJobActO := nil;
  FJobActI := nil;

  FPurchRetO := nil;
  FPurchRetI := nil;

  FSalesRetO := nil;
  FSalesRetI := nil;

  FSumBudgeO  := nil;
  FSumBudgeI  := nil;

  FAnalBudgeO := nil;
  FAnalBudgeI := nil;

  FStockBudgeO := nil;
  FStockBudgeI := nil;

  FAppsO := nil;
  FAppsI := nil;

  FTimeRatesO := nil;
  FTimeRatesI := nil;

end;

{-----------------------------------------}

function TJob.Get_jrCode: WideString;
begin
  Result := FJob.JobCode;
end;

procedure TJob.Set_jrCode(const Value: WideString);
begin
  FJob.JobCode := FullJobCode(Value);
end;

{-----------------------------------------}

function TJob.Get_jrDesc: WideString;
begin
  Result := FJob.JobDesc;
end;

procedure TJob.Set_jrDesc(const Value: WideString);
begin
  FJob.JobDesc := Value;
end;

{-----------------------------------------}

function TJob.Get_jrAcCode: WideString;
begin
  Result := FJob.CustCode;
end;

procedure TJob.Set_jrAcCode(const Value: WideString);
begin
  FJob.CustCode := FullCustCode(Value);
end;

{-----------------------------------------}

function TJob.Get_jrFolio: Integer;
begin
  Result := FJob.JobFolio;
end;

{-----------------------------------------}

function TJob.Get_jrParent: WideString;
begin
  Result := FJob.JobCat;
end;

procedure TJob.Set_jrParent(const Value: WideString);
begin
  FJob.JobCat := FullJobCode(Value);
end;

{-----------------------------------------}

function TJob.Get_jrAltCode: WideString;
begin
  Result := FJob.JobAltCode;
end;

procedure TJob.Set_jrAltCode(const Value: WideString);
begin
  FJob.JobAltCode := Value;
end;

{-----------------------------------------}

function TJob.Get_jrCompleted: WordBool;
begin
  Result := FJob.Completed;
end;

procedure TJob.Set_jrCompleted(Value: WordBool);
begin
  FJob.Completed := Value;
end;

{-----------------------------------------}

function TJob.Get_jrContact: WideString;
begin
  Result := FJob.Contact;
end;

procedure TJob.Set_jrContact(const Value: WideString);
begin
  FJob.Contact := Value;
end;

{-----------------------------------------}

function TJob.Get_jrManager: WideString;
begin
  Result := FJob.JobMan;
end;

procedure TJob.Set_jrManager(const Value: WideString);
begin
  FJob.JobMan := Value;
end;

{-----------------------------------------}

function TJob.Get_jrChargeType: TJobChargeType;
begin
  Case FJob.ChargeType Of
    'T' : Result := JChrgTimeMaterials;
    'F' : Result := JChrgFixedPrice;
    'C' : Result := JChrgCostPlus;
    'N' : Result := JChrgNonProductive;
  Else
    Raise EUnknownValue.Create ('Invalid Job Charge Type ' + QuotedStr(FJob.ChargeType));
  End; { Case }
end;

procedure TJob.Set_jrChargeType(Value: TJobChargeType);
begin
  Case Value Of
    JChrgTimeMaterials : FJob.ChargeType := 'T';
    JChrgFixedPrice    : FJob.ChargeType := 'F';
    JChrgCostPlus      : FJob.ChargeType := 'C';
    JChrgNonProductive : FJob.ChargeType := 'N';
  Else
    Raise EUnknownValue.Create ('Invalid Job Charge Type ' + IntToStr(Ord(Value)));
  End; { Case }
end;

{-----------------------------------------}

function TJob.Get_jrQuotePrice: Double;
begin
  Result := FJob.QuotePrice;
end;

procedure TJob.Set_jrQuotePrice(Value: Double);
begin
  FJob.QuotePrice := Value;
end;

{-----------------------------------------}

function TJob.Get_jrQuotePriceCurr: Smallint;
begin
  Result := FJob.CurrPrice;
end;

procedure TJob.Set_jrQuotePriceCurr(Value: Smallint);
begin
  FJob.CurrPrice := ValidateCurrencyNo (Value);
end;

{-----------------------------------------}

function TJob.Get_jrStartDate: WideString;
begin
  Result := FJob.StartDate;
end;

procedure TJob.Set_jrStartDate(const Value: WideString);
begin
  FJob.StartDate := Value;
end;

{-----------------------------------------}

function TJob.Get_jrEndDate: WideString;
begin
  Result := FJob.EndDate;
end;

procedure TJob.Set_jrEndDate(const Value: WideString);
begin
  FJob.EndDate := Value;
end;

{-----------------------------------------}

function TJob.Get_jrRevisedEndDate: WideString;
begin
  Result := FJob.RevEDate;
end;

procedure TJob.Set_jrRevisedEndDate(const Value: WideString);
begin
  FJob.RevEDate := Value;
end;

{-----------------------------------------}

function TJob.Get_jrSORNumber: WideString;
begin
  Result := FJob.SORRef;
end;

procedure TJob.Set_jrSORNumber(const Value: WideString);
begin
  FJob.SORRef := Value;
end;

{-----------------------------------------}


function TJob.Get_jrVATCode: WideString;
begin
  Result := FJob.VATCode;
end;

procedure TJob.Set_jrVATCode(const Value: WideString);
begin
  FJob.VATCode := ExtractChar(Value, #0);
end;

{-----------------------------------------}

function TJob.Get_jrJobType: WideString;
begin
  Result := FJob.JobAnal;
end;

procedure TJob.Set_jrJobType(const Value: WideString);
begin
  FJob.JobAnal := FullJACode(Value);
end;

{-----------------------------------------}

function TJob.Get_jrType: TJobTypeType;
begin
  Case FJob.JobType Of
    JobGrpCode : Result := JTypeContract;
    JobJobCode : Result := JTypeJob;
    JobPhzCode : Result := JTypePhase;
  Else
    Raise EUnknownValue.Create ('Invalid Job Type ' + QuotedStr(FJob.JobType));
  End; { Case FJob.JobType }
end;

procedure TJob.Set_jrType(Value: TJobTypeType);
begin
  Case Value Of
    JTypeContract : FJob.JobType := JobGrpCode;
    JTypeJob      : FJob.JobType := JobJobCode;
    JTypePhase    : FJob.JobType := JobPhzCode;
  Else
    Raise EUnknownValue.Create ('Invalid Job Type ' + IntToStr(Ord(Value)));
  End; { Case Value }
end;

{-----------------------------------------}

function TJob.Get_jrStatus: TJobStatusType;
begin
  Case FJob.JobStat Of
    'Q' : Result := JStatusQuotation;
    'A' : Result := JStatusActive;
    'S' : Result := JStatusSuspended;
    'C' : Result := JStatusCompleted;
    'L' : Result := JStatusClosed;
  Else
    Raise EUnknownValue.Create ('Invalid Job Status ' + QuotedStr(FJob.JobStat));
  End; { Case }
end;

procedure TJob.Set_jrStatus(Value: TJobStatusType);
begin
  Case Value Of
    JStatusQuotation : FJob.JobStat := 'Q';
    JStatusActive    : FJob.JobStat := 'A';
    JStatusSuspended : FJob.JobStat := 'S';
    JStatusCompleted : FJob.JobStat := 'C';
    JStatusClosed    : FJob.JobStat := 'L';
  Else
    Raise EUnknownValue.Create ('Invalid Job Status ' + IntToStr(Ord(Value)));
  End; { Case }
end;

{-----------------------------------------}

function TJob.Get_jrUserField1: WideString;
begin
  Result := FJob.UserDef1;
end;

procedure TJob.Set_jrUserField1(const Value: WideString);
begin
  FJob.UserDef1 := Value;
end;

{-----------------------------------------}

function TJob.Get_jrUserField2: WideString;
begin
  Result := FJob.UserDef2;
end;

procedure TJob.Set_jrUserField2(const Value: WideString);
begin
  FJob.UserDef2 := Value;
end;

{-----------------------------------------}

function TJob.Get_Index: TStockIndex;
begin
  Result := Inherited Get_Index;
end;

procedure TJob.Set_Index(Value: TStockIndex);
begin
  Inherited Set_Index (Value);
end;

{-----------------------------------------}

Function TJob.AuthoriseFunction (Const FuncNo     : Byte;
                                 Const MethodName : String;
                                 Const AccessType : Byte = 0) : Boolean;
begin
  Case FuncNo Of
    1..99     : Result := (FIntfType = imGeneral);

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

    // .jrNotes property
    201       : Result := (FIntfType = imGeneral);

    //PR: 29/08/2012 ABSEXCH-13202 IJob7 methods
    // .CanDelete method
    202       : Result := (FIntfType = imGeneral);
    // .Delete method
    203       : Result := (FIntfType = imGeneral);

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

{-----------------------------------------}

Procedure TJob.CopyDataRecord;
Begin { CopyDataRecord }
  CopyExJobToTKJob (FBtrIntf^.LJobRec^, FJob);
End; { CopyDataRecord }

{-----------------------------------------}

Function TJob.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode : SmallInt;
  KeyS      : Str255;
begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';

  With FBtrIntf^ Do Begin
    KeyS := SetKeyString(BtrOp, SearchKey);
    BtrOpCode := BtrOp;

    // Get record
    Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

    If (Result = 0) Then
    begin
      // Convert to Toolkit structure
      CopyDataRecord;
      InitObjects(False);
    end;

    FKeyString := KeyS;
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (60, Result);
End; { GetDataRecord }

{-----------------------------------------}

function TJob.BuildCodeIndex(const JobCode: WideString): WideString;
begin
  // Index 0 - JobCode (JobCodeK)
  Result := FullJobCode(JobCode);
end;

{-----------------------------------------}

function TJob.BuildFolioIndex(Folio: Integer): WideString;
begin
  // 1 - Job Folio  (JobFolioK)
  Result := FullNomKey(Folio);
end;

{-----------------------------------------}

function TJob.BuildParentIndex(const ParentCode, JobCode: WideString): WideString;
begin
  // Index 2 - JobCat+JobCode (JobCATK)
  Result := FullJobCode(ParentCode) + FullJobCode(JobCode);
end;

{-----------------------------------------}

function TJob.BuildAccountIndex(const AccountCode: WideString): WideString;
begin
  // Index 7 - Account Code (JobCustK)
  Result := FullCustCode(AccountCode);
end;

{-----------------------------------------}

function TJob.BuildAltCodeIndex(const AlternateCode: WideString): WideString;
begin
  // Index 6 - JobAlt Code (JobAltK)
  Result := FullJobCode(AlternateCode);
end;

{-----------------------------------------}

function TJob.BuildCompletedCodeIndex(Completed: WordBool; const JobCode: WideString): WideString;
Var
  CompFlag : LongInt;
begin
  // Index 4 - Completed + JobCode (JobCompCK)
  If Completed Then CompFlag := 1 Else CompFlag := 0;
  Result := FullNomKey(CompFlag) + FullJobCode(JobCode);
end;

{-----------------------------------------}

function TJob.BuildCompletedDescIndex(Completed: WordBool; const Description: WideString): WideString;
Var
  CompFlag : LongInt;
begin
  // Index 5 - Completed + JobDesc (JobCompDK)
  If Completed Then CompFlag := 1 Else CompFlag := 0;
  Result := FullNomKey(CompFlag) + Description;
end;

{-----------------------------------------}

function TJob.BuildDescIndex(const Description: WideString): WideString;
begin
  // Index 3 - Desc (JobDescK)
  Result := Description;
end;

{-----------------------------------------}

procedure TJob.InitNewRecord;
begin
  FillChar(FJob, SizeOf(FJob), #0);
  With FJob Do Begin
    JobType := JobJobCode;   // Job
    JobStat := 'Q';          // Quotation
    ChargeType := 'F';       // Fixed Price
    VATCode := Syss.VATCode; // VAT Code - Used for what?
    CurrPrice := 1;
    StartDate := FormatDateTime('YYYYMMDD', SysUtils.Date);
  End; { With FJob }
end;

{-----------------------------------------}

function TJob.Add: IJob;
Var
  AddO : TJob;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TJob.Create(imAdd, FToolkit, FParentJob, FBtrIntf);
  AddO.InitNewRecord;

  Result := AddO;
end;

{-----------------------------------------}

procedure TJob.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

{-----------------------------------------}

Procedure TJob.CloneDetails (Const JobDets : TBatchJHRec);
begin
  FJob := JobDets;
end;

{-----------------------------------------}

function TJob.Clone: IJob;
Var
  CloneO : TJob;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Stock object and initialise
  CloneO := TJob.Create(imClone, FToolkit, FParentJob, FBtrIntf);
  CloneO.CloneDetails(FJob);

  Result := CloneO;
end;

{-----------------------------------------}

function TJob.Save: Integer;
Var
  SaveInfo  : TBtrieveSavePosType;
  SaveInfo2 : TBtrieveFileSavePos;
  BtrOp     : SmallInt;
begin
  AuthoriseFunction(102, 'Save');

  // Save current file positions in main files
  SaveInfo := SaveSystemFilePos ([]);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Result := PositionOnLock;
    BtrOp := B_Update;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Result := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Result = 0) Then Begin
    // Add/Update
    SaveExLocalPos(SaveInfo2);
    Result := Ex_StoreJob (@FJob, SizeOf(FJob), FIndex, BtrOp);
    RestoreExLocalPos(SaveInfo2);

    //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
    if Result = 0 then
      FIntfType := imClone;
  End; { If (Res = 0) }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (61, Result);


  // Restore original file positions
  RestoreSystemFilePos (SaveInfo);
end;

{-----------------------------------------}

Procedure TJob.LoadDetails (Const JobDets : TBatchJHRec; Const LockPos : LongInt);
begin
  FJob := JobDets;

  LockCount := 1;
  LockPosition := LockPos;
end;

{-----------------------------------------}

function TJob.Update: IJob;
Var
  UpdateO : TJob;
  FuncRes  : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TJob.Create(imUpdate, FToolkit, FParentJob, FBtrIntf);

    // Pass current job Record and Locking Details into sub-object
    UpdateO.LoadDetails(FJob, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;

{-----------------------------------------}

function TJob.Get_jrNotes: INotes;
begin
  AuthoriseFunction(201, 'jrNotes', 1);

  { Check Notes sub-object has been initialised }
  If (Not Assigned(FNotesO)) Then Begin
    { Create and initialise Notes sub-object}
    FNotesO := TNotes.Create(imGeneral,
                             FToolkit,
                             FBtrIntF,
                             'JOB',
                             '2',
                             False);

    FNotesI := FNotesO;
  End; { If (Not Assigned(FNotesO)) }

  FNotesO.SetStartKey (FullJobCode(FJob.JobCode),
                       NoteTCode + NoteJCode + FullNCode(FullNomKey(FJob.JobFolio)));

  Result := FNotesI;
end;

{-----------------------------------------}
function  TJob.Get_jrJobTypeI: IJobType;
begin
  With FToolkit As TToolkit Do
    Result := JobCostingO.JobTypeO.GetCloneInterface(Get_jrJobType);
end;

{-----------------------------------------}
Function TJob.GetCloneInterface (Const Code : ShortString) : IJob;
Var
  SaveInfo : TBtrieveFileSavePos;
  ljrCode  : ShortString;
  Res      : LongInt;
Begin { GetCloneInterface }
  Result := NIL;

  // Reformat as valid account code
  ljrCode := BuildCodeIndex(Code);

  // Check not blank
  If (Trim(ljrCode) <> '') Then Begin
    // Save Current Position and index
    SaveExLocalPosRec (SaveInfo, @FJob, SizeOf(FJob));

    // Find record for AcCode
    Set_Index(jrIdxCode);
    Res := GetDataRecord (B_GetEq, ljrCode);
    If (Res = 0) Then Begin
      // Got Record - generate and return a Clone interface
      Result := Clone;
    End; { If (Res = 0) }

    // Restore Original Index and position
    RestoreExLocalPosRec (SaveInfo, @FJob, SizeOf(FJob));
  End; { If (Trim(ljtCode) <> '') }
End;

function TJob.Get_jrLinks: ILinks;
begin
  if Not Assigned(FLinksO) then
  begin
    FLinksO := TLinks.Create(imGeneral, FBtrIntf, 'J', '', FJob.JobFolio);

    FLinksI := FLinksO;
  end;

  FLinksO.OwnerType := 'J';
  FLinksO.OwnerCode := '';
  FLinksO.OwnerFolio := FJob.JobFolio;

  Result := FLinksI;
end;

function TJob.Get_jrJobActual: IJobActual;
begin
  if not Assigned(FJobActO) then
  begin
    FJobActO := CreateTJobActual(FToolkit, 35, Get_jrCode);

    FJobActI := FJobActO;
  end;

  Result := FJobActI;
end;

function TJob.Get_jrPurchaseRetention: IJobRetention;
begin
  if not Assigned(FPurchRetO) then
  begin
    FPurchRetO := CreateTJobRetention(FToolkit, 25, spPurchase, Get_jrCode);

    FPurchRetI := FPurchRetO;
  end;

  Result := FPurchRetI;
end;

function TJob.Get_jrSalesRetention: IJobRetention;
begin
  if not Assigned(FSalesRetO) then
  begin
    FSalesRetO := CreateTJobRetention(FToolkit, 26, spSales, Get_jrCode);

    FSalesRetI := FSalesRetO;
  end;

  Result := FSalesRetI;
end;

function TJob.Get_jrSummaryBudget: ISummaryJobBudget;
begin
  if not Assigned(FSumBudgeO) then
  begin
    FSumBudgeO := CreateTJobBudget(FToolkit, 30, btSummary, Get_jrCode) as TSummaryJobBudget;

    FSumBudgeI := FSumBudgeO;
  end;

  Result := FSumBudgeI;
end;

function TJob.Get_jrAnalysisBudget: IAnalysisJobBudget;
begin
  if not Assigned(FAnalBudgeO) then
  begin
    FAnalBudgeO := CreateTJobBudget(FToolkit, 31, btAnalysis, Get_jrCode) as TAnalysisJobBudget;

    FAnalBudgeI := FAnalBudgeO;
  end;

  Result := FAnalBudgeI;
end;

function TJob.Get_jrTimeAndStockBudget: ITimeAndStockJobBudget;
begin
  if not Assigned(FStockBudgeO) then
  begin
    FStockBudgeO := CreateTJobBudget(FToolkit, 31, btStockRate, Get_jrCode) as TTimeAndStockJobBudget;

    FStockBudgeI := FStockBudgeO;
  end;

  Result := FStockBudgeI;
end;

function TJob.Invoice: IJobInvoice;
var
  TmpInv : TJobInvoice;
begin
  TmpInv := TJobInvoice.Create(FJob.JobCode, FJob.CustCode, FToolkit as TToolkit);

  Result := TmpInv;
end;

//-------------------------------------------------------------------------

function TJob.Print(PrintAs: TJobPrintMode): IPrintJob;
Var
  oPrintJob  : TPrintJob;
begin
  // Create and initialise the PrintJob object
  oPrintJob := TPrintJob.Create(FToolkit, fmJobDetails, defTypeJobWithNotes, jtForm);
  With oPrintJob Do Begin
    // Configure to print the transaction
    MainFileNum  := JobF;
    MainKeyPath  := JobCodeK;
    MainKeyRef   := FullJobCode(FJob.JobCode);

    TableFileNum := PwrdF;
    TableKeyPath := PWK;
    TableKeyRef  := NoteTCode + NoteJCode + FullNCode(FullNomKey(FJob.JobFolio));

    DefaultAcc   := '';
  End; { With oPrintJob }

  // Return reference to interface - object will be automatically destroyed when
  // user reference to it is lost
  Result := oPrintJob;
end;

function TJob.Get_jrApplications: IJobApplications;
begin
  if JAPOn then
  begin
    if not Assigned(FAppsO) then
    begin
      FAppsO := CreateTJobApplications(FToolkit, FJob);

      FAppsI := FAppsO;
    end;

    Result := FAppsI;
  end
  else
    raise EInvalidMethod.Create('This installation of Exchequer is not licenced for Applications & Valuations');

end;

function TJob.Get_jrTimeRates: ITimeRates;
begin
  If (Not Assigned(FTimeRatesO)) Then Begin
    { Create and initialise the Job Record sub-object }
    FTimeRatesO := TTimeRates.Create(imGeneral, FToolkit, FBtrIntF);

    FTimeRatesI := FTimeRatesO;
  End; { If (Not Assigned(FJobO)) }

  FTimeRatesO.JobCode := Get_jrCode;

  Result := FTimeRatesI;
end;

//-------------------------------------------------------------------------

//IBrowseInfo
function TJob.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;


function TJob.Get_jrUserField3: WideString;
begin
  Result := FJob.UserDef3;
end;

function TJob.Get_jrUserField4: WideString;
begin
  Result := FJob.UserDef4;
end;

procedure TJob.Set_jrUserField3(const Value: WideString);
begin
  FJob.UserDef3 := Value;
end;

procedure TJob.Set_jrUserField4(const Value: WideString);
begin
  FJob.UserDef4 := Value;
end;

function TJob.Get_jrUserField10: WideString;
begin
  Result := FJob.UserDef10;
end;

function TJob.Get_jrUserField5: WideString;
begin
  Result := FJob.UserDef5;
end;

function TJob.Get_jrUserField6: WideString;
begin
  Result := FJob.UserDef6;
end;

function TJob.Get_jrUserField7: WideString;
begin
  Result := FJob.UserDef7;
end;

function TJob.Get_jrUserField8: WideString;
begin
  Result := FJob.UserDef8;
end;

function TJob.Get_jrUserField9: WideString;
begin
  Result := FJob.UserDef9;
end;

procedure TJob.Set_jrUserField10(const Value: WideString);
begin
  FJob.UserDef10 := Value;
end;

procedure TJob.Set_jrUserField5(const Value: WideString);
begin
  FJob.UserDef5 := Value;
end;

procedure TJob.Set_jrUserField6(const Value: WideString);
begin
  FJob.UserDef6 := Value;
end;

procedure TJob.Set_jrUserField7(const Value: WideString);
begin
  FJob.UserDef7 := Value;
end;

procedure TJob.Set_jrUserField8(const Value: WideString);
begin
  FJob.UserDef8 := Value;
end;

procedure TJob.Set_jrUserField9(const Value: WideString);
begin
  FJob.UserDef9 := Value;
end;

//PR: 14/03/2012 v6.10 ABSEXCH-12510
function TJob.Get_jrQSCode: WideString;
begin
  Result := FJob.JQSCode;
end;

procedure TJob.Set_jrQSCode(const Value: WideString);
begin
  FJob.JQSCode := Value;
end;

//PR: ABSEXCH-13202 IJob7 Add Delete method. DeleteLinkFiles controls whether the files to which links refer
//should be deleted or not. As this function updates budgets and history, it runs in a transaction so we can
//roll it back if anything fails.
function TJob.Delete(DeleteLinkFiles: WordBool): Integer;
const
  btBeginTrans = 19;
  btEndTrans = 20;
  btAbortTrans = 21;
var
  Res : Integer;
  UsingTransaction : Boolean;
begin
  AuthoriseFunction(202, 'Delete');
  if CanDelete then
  begin
    //Check that the file isn't in use
    Result := Lock;

    if Result = 0 then
    begin
      //Take copy of Exchequer Job Rec
      FExJobRec := FBtrIntf^.LJobRec^;

      //Need to unlock it, otherwise we can't get a transaction.
      Unlock;

      FDeleteProcessedOK := True;

      //Start transaction
      Res := Ctrl_BTransCId(btBeginTrans, FBtrIntf^.ExClientId);
      UsingTransaction := Res = 0;

      //36 result from Begin Transaction (Pervasive) is 'not configured for transactions'. Unlikely,
      //but take account of the possibility and continue without a transaction.
      if Res in [0, 36] then
      Try
        Try
          //Delete record
          Result := FBtrIntf^.LDelete_Rec(FFileNo, FIndex);

          //delete related records and files.
          if Result = 0 then
            DeleteRelatedRecords(DeleteLinkFiles);
        Except
          on E:Exception do
          begin
            LastErDesc := 'Exception in IJob.Delete: ' + E.Message;
            FDeleteProcessedOK := False;
          end;
        End;

      Finally
        //Either commit or rollback transaction according to result of updates, etc.
        if FDeleteProcessedOK then
        begin
          //Commit transaction
          if UsingTransaction then
            Result := Ctrl_BTransCId(btEndTrans, FBtrIntf^.ExClientId);
        end
        else
        begin
          //Rollback transaction and set error code
          if UsingTransaction then
            Ctrl_BTransCId(btAbortTrans, FBtrIntf^.ExClientId);
          Result := 30022;

          //Error message should have been set at point of exception, but
          //if it's still blank set it to unknown.
          if Trim(LastErDesc) = '' then
            LastErDesc := 'Unknown error';
        end;
      End //if Res in [0, 36]
      else
        Result := Res;
    end; //If Result = 0 (Lock)
  end  //If CanDelete
  else
  begin
    if FJob.JobType = 'K' then
    begin
      Result := 30020; //contract contains jobs
      LastErDesc := 'Cannot delete a contract which contains jobs';
    end
    else
    begin
      LastErDesc := 'Cannot delete an open job which has transactions';
      Result := 30021;
    end;
  end;
end;

//PR: 24/08/2012 ABSEXCH-13202 Function to delete any related records
procedure TJob.DeleteRelatedRecords(DeleteLinkFiles: Boolean);
var
  CurrentlyUsingSQLAltFuncs : Boolean;
begin
  with FJob do
  begin
    //Delete notes
    Delete_Notes(NoteJCode,FullNCode(FullNomKey(JobFolio))); //NoteSupU.pas

    //Delete letters and links
    DeleteLinksAndLetters(DeleteLinkFiles);

    //Delete PayRates for job
    DeletePayRates;

    //Update budgets
    FDeleteProcessedOK := UpdateBudgets;

    //Run delete job check to recalculate history values
    // May need to turn off stored procedures for this as the PostToHistory sp times out
    // if called from within a database transaction.

    //Store current state of UsingSQLAlternateFuncs
    CurrentlyUsingSQLAltFuncs := SQLUtils.UsingSQLAlternateFuncs;
    if CurrentlyUsingSQLAltFuncs then
      SQLUtils.DisableSQLAlternateFuncs;
    Try
      if FDeleteProcessedOK then
        FDeleteProcessedOK := RunGLCheck;
    Finally
      //If necessary, restore state of UsingSQLAlternateFuncs
      if CurrentlyUsingSQLAltFuncs then
        SQLUtils.EnableSQLAlternateFuncs;
    End;

    //Delete Job Details
    if FDeleteProcessedOK then
      LDelete_JobDetails(JobCode, JobType, JobFolio, True); //JobSup1U.pas
  end;
end;

//PR: 24/08/2012 ABSEXCH-13202 Function to check whether we allow this job to be deleted or not.
//Conditions taken from JobTreeU.pas and JobSup1U.pas
function TJob.CanDelete: WordBool;
var
  Res : integer;
begin
  AuthoriseFunction(202, 'CanDelete');
  //Always allow closed jobs to be deleted
  Result := FJob.JobStat = 'L';

  if not Result then
  begin
    if(FJob.JobType = 'K') then
      //Contract - check if we have any jobs
      Result := not FBtrIntf^.LCheckExsists(FJob.JobCode, JobF, JobCatK)
    else
      //Job - check if there are any transactions for this job code
      Result := not FBtrIntf^.LCheckExsists(PartCCKey(JBRCode,JBECode)+ FJob.JobCode, JDetlF, JDLedgerK);
  end;

end;

//Function to delete links and letters. Adapted from DeleteLetters in R&D\Letters.pas. DeleteFiles parameter
//governs whether link files are deleted (letters files are always deleted since they are copies.)
procedure TJob.DeleteLinksAndLetters(DeleteFiles: Boolean);
Const
  FNum    = MiscF;
  KeyPath = MIK;
Var
  OKey, KeyS      : AnyStr;
  DocPath         : AnsiString;
  Locked, SkipDel : Boolean;
  LAddr           : LongInt;
  KLen            : Integer;
  Res             : integer;
begin
  { Build key for items to delete }
  KeyS := LetterTCode + LetterJobCode + FullNomKey(FJob.JobFolio);
  OKey := KeyS;
  KLen := Length(KeyS);

  with FBtrIntf^ do
  begin
    { Get first, if any }
    Res := LFind_Rec(B_GetGEq, MiscF, MIK, KeyS);

    While (Res=0) and (CheckKey(OKey,KeyS,KLen,BOn)) Do Begin
      { lock }
      Ok:=LGetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

      If (Ok) and (Locked) Then Begin
        SkipDel := False;
        If (MiscRecs^.btLetterRec.Version = DocWord95) Then Begin
          { Letter }
          DocPath := SetDrive + PathDocs + MiscRecs^.btLetterRec.LtrPath
        End { If }
        Else Begin
          { Link - ask if they want to delete }
          DocPath := MiscRecs^.btLinkRec.LtrPath;
          SkipDel := not DeleteFiles;
        End; { Else }

        If (Not SkipDel) Then
          DeleteFile(PCHAR(DocPath));

        { Delete record }
        Res := LDelete_Rec(MiscF, MIK);
      End; { If }

      { Get next }
      Res := LFind_Rec(B_GetNext, MiscF, MIK, KeyS);
    end;
  end;
end;

procedure TJob.DeletePayRates;
var
  KeyS : Str255;
  Res : Integer;
begin
  KeyS:=PartCCKey(JBRCode, JBSubAry[3]) + FullEmpKey(FJob.JobCode);

  FBtrIntf^.LDeleteLinks(KeyS, JCtrlF, Length(KeyS), JCK, False);
end;

//Update budgets for the job tree
function TJob.UpdateBudgets : Boolean;
var
  KeyS : Str255;
  Res : Integer;
  UpdateBudgets : TJobBudgetUpdater; //In JobBudgetUpdate.pas
begin
  UpdateBudgets := TJobBudgetUpdater.Create;
  Try
    UpdateBudgets.ExLocal := FBtrIntf;
    UpdateBudgets.JobCode := FJob.JobCode;
    UpdateBudgets.UpdateMode := 38;
    Result := UpdateBudgets.Execute;
  Finally
    UpdateBudgets.Free;
  End;
end;

//Run Check on GL
function TJob.RunGLCheck : Boolean;
var
  oCheck : TJobDeleteCheck; //In JobDeleteCheck.pas
  oEnterprise : IEnterprise;
begin
  oCheck := TJobDeleteCheck.Create;
  Try
    oCheck.DelJobRec := FExJobRec;
    oCheck.ExLocal := FBtrIntf;
    oEnterprise := TToolkit(FToolkit).EnterpriseI;
    oCheck.SOPLicenced := oEnterprise.enModuleVersion = enModSPOP;
    Result := oCheck.Execute;
  Finally
    oCheck.Free;
  End;
end;

//copied and adapted from Delete_JobDetails in JobSup1U.pas
function TJob.LDelete_JobDetails(JCode: Str10; JType: Char; JFolio: Integer;
  DelHist: Boolean): Boolean;
Const
  Fnum2      =  JCtrlF;
  Keypath2   =  JCK;
  Fnum3      =  JDetlF;
  Keypath3   =  JDLedgerK;

  LoopCtrl  :  Array[1..5] of Char  =  (JBSCode,JBBCode,JBMCode,JBECode,JBPCode);

Var
  Loop  :  Byte;

  KeyChk,
  KeyS  :  Str255;

  Fnum,
  Keypath
        :  Integer;
Begin

  Result:=BOn;

  Fnum:=Fnum2;

  Keypath:=Keypath2;

  Loop:=1;

  with FBtrIntf^ do
  Repeat

    KeyChk:=PartCCKey(JBRCode,LoopCtrl[Loop])+JCode;

    KeyS:=KeyChk;

    Status:=LFind_Rec(B_GetGEq, Fnum, keypath, KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    Begin

      Application.ProcessMessages;

      LStatus:= LDelete_Rec(Fnum,KeyPath);

      Result:=(Result and LStatusOk);

      Status:=LFind_Rec(B_GetNext, Fnum, keypath, KeyS);


    end; {While..}


    Inc(Loop);

    If (Loop=4) then
    Begin

      Fnum:=Fnum3;

      Keypath:=KeyPath3;

    end;


  Until (Loop>5);

  If (Result) and (DelHist) then
  Begin

    KeyChk:=JType+JCode;

    FBtrIntf^.LDeleteLinks(KeyChk,NHistF,Length(KeyChk),NHK,BOff);

  end;

end; {Proc..}

//PR: 12/09/2013 ABSEXCH-13192
function TJob.Get_jrCostCentre: WideString;
begin
  Result := FJob.jrCostCentre;
end;

function TJob.Get_jrDepartment: WideString;
begin
  Result := FJob.jrDepartment;
end;

procedure TJob.Set_jrCostCentre(const Value: WideString);
begin
  FJob.jrCostCentre := Value;
end;

procedure TJob.Set_jrDepartment(const Value: WideString);
begin
  FJob.jrDepartment := Value;
end;

//AP: 08/12/2017 ABSEXCH-19485 New field for GDPR
function  TJob.Get_jrAnonymised: WordBool;
begin
  Result := FJob.jrAnonymised;
end;

function  TJob.Get_jrAnonymisedDate: WideString;
begin
  Result := FJob.jrAnonymisedDate;
end;

function  TJob.Get_jrAnonymisedTime: WideString;
begin
  Result := FJob.jrAnonymisedTime;
end;

end.
