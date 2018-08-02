unit DllJobU;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{* For Job Costing Functions *}

{F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 09/11/98                      }
{                                                              }
{                     Internal Export Module                   }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

interface

Uses
  GlobVar,
  {$IFDEF WIN32}
  VarRec2U,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst,
  VarCnst3;

FUNCTION EX_GETJOB(P            :  POINTER;
                   PSIZE        :  LONGINT;
                   SEARCHKEY    :  PCHAR;
                   SEARCHPATH   :  SMALLINT;
                   SEARCHMODE   :  SMALLINT;
                   LOCK         :  WORDBOOL) : SMALLINT;
                   {$IFDEF WIN32} STDCALL; {$ENDIF}
                   EXPORT;

FUNCTION EX_STOREJOB(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT) : SMALLINT;
                     {$IFDEF WIN32} STDCALL; {$ENDIF}
                     EXPORT;


FUNCTION EX_GETJOBEMPLOYEE(P          :  POINTER;
                           PSIZE      :  LONGINT;
                           SEARCHKEY  :  PCHAR;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT;
                           LOCK       :  WORDBOOL)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXPORT;

FUNCTION EX_GETJOBANALYSIS(P          :  POINTER;
                           PSIZE      :  LONGINT;
                           SEARCHKEY  :  PCHAR;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT;
                           LOCK       :  WORDBOOL)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXPORT;

FUNCTION EX_GETJOBTIMERATE(P          :  POINTER;
                           PSIZE      :  LONGINT;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT;
                           LOCK       :  WORDBOOL)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXPORT;

FUNCTION EX_GETJOBTYPE(P          :  POINTER;
                       PSIZE      :  LONGINT;
                       SEARCHKEY  :  PCHAR;
                       SEARCHMODE :  SMALLINT;
                       LOCK       :  WORDBOOL)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF}
                       EXPORT;

FUNCTION EX_STOREJOBEMPLOYEE(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHPATH   :  SMALLINT;
                             SEARCHMODE   :  SMALLINT) : SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXPORT;

FUNCTION EX_STOREJOBANALYSIS(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHPATH   :  SMALLINT;
                             SEARCHMODE   :  SMALLINT) : SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXPORT;

FUNCTION EX_STOREJOBTIMERATE(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHPATH   :  SMALLINT;
                             SEARCHMODE   :  SMALLINT) : SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXPORT;

FUNCTION EX_STOREJOBTYPE(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT) : SMALLINT;
                         {$IFDEF WIN32} STDCALL; {$ENDIF}
                         EXPORT;

FUNCTION EX_SETJAINVOICEDFLAG(TRANSREF        : PCHAR;
                              LINENO          : LONGINT;
                              INVOICEREF      : PCHAR;
                              WIPTRANSFERRED  : WORDBOOL;
                              CHARGEOUT       : DOUBLE;
                              CHARGEOUTCURR   : LONGINT) : SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}
                         EXPORT;


FUNCTION FUNC612(SECPARAM : LONGINT; S1 : ShortString) : SMALLINT; STDCALL; EXPORT;


{$IFDEF COMTK}

  Procedure CopyExJobToTKJob (Const JobR : JobRecType; Var ExJHRec : TBatchJHRec);
  Procedure CopyExJobAnalysisToTKJobAnalysis (Const JobAnalR : JobAnalType;
                                                Var ExJanalRec : TBatchJobAnalRec);
  Procedure CopyExEmployeeToTKEmployee(Const EmployeeRec : EmplType;
                                         Var ExEmployee : TBatchEmplRec);
  Procedure CopyExJRateToTKJRate(const JobRate : EmplPayType;
                                   Var ExJRate   :  TBatchJobRateRec);


{$ENDIF}


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
{$IFDEF WIN32}
  BtrvU2,
  BTSupU1,
  SysU2,
  ComnU2,
  CurrncyU,
  BtKeys1U,
  BankU1,
{$ELSE}
  BtrvU16,
  BTSup1,
  BTSup2,
{$ENDIF}
  BTS1,
  DLLErrU,
  Dialogs,
  SysUtils,
  VarJCstU,
  JobSup1U,
  DLSQLSup,

  //PR: 02/11/2011 v6.9
  AuditNotes,
  AuditNoteIntf,

  //AP: 10/01/2018 ABSEXCH-19588
  oAnonymisationDiaryObjIntf,
  oAnonymisationDiaryObjDetail,
  oAnonymisationDiaryBtrieveFile;



Const

  { ============= for Job ChargeType ================ }

  CTStart         = 1;
  CTEnd           = 4;

  CTTime          = 'T';
  CTFixed         = 'F';
  CTCost          = 'C';
  CTNon           = 'N';

  { ============ for Job Status ===================== }

  JSStart        = 1;
  JSEnd          = 5;

  JSQuo          = 'Q';
  JSActive       = 'A';
  JSSusp         = 'S';
  JSCompl        = 'C';
  JSClosed       = 'L';

  PRateCode      = -1;  {* For Global Time Rate key for Employee Code *}

Function JCCats_TxLate(ANo    :  LongInt;
                       ToCat  :  Boolean)  :  LongInt;

Const
  ToCatMap  :  Array[SysAnlsRev..NofSysAnals] of LongInt =
               (15,1,14,2,11,3,4,5,12,6,13,7,8,9,10,16,17);

Var
  n  :  Byte;


Begin
  Result:=ANo;

    Case ToCat of
      BOff  :  Begin
                 For n:=Low(ToCatMap) to High(ToCatMap) do
                 Begin
                   If (Ano=ToCatMap[n]) then
                   Begin
                     Result:=n;
                     Break;
                   end;
                 end;
               end;

      BOn   :  Begin
                 If (Ano In [SysAnlsRev..NofSysAnals]) then
                   Result:=ToCatMap[Ano];
               end;
    end; {Case..}


end; {Func..}



{ ============================================================================ }

Procedure CopyExJobToTKJob (Const JobR : JobRecType; Var ExJHRec : TBatchJHRec);
const
  {$IFDEF COMTK}
    CompletedAR    : Array[0..1] of WordBool = (BOff,BOn);
  {$ELSE}
    CompletedAR    : Array[0..1] of WordBool = (Ord(BOff),Ord(BOn));
  {$ENDIF}
  ChargeTypeAR  :  Array[CTStart..CTEnd] of Char = (CTTime,CTFixed,CTCost,CTNon);
  JobStatAR     :  Array[JSStart..JSEnd] of Char = (JSQuo,JSActive,JSSusp,JSCompl,JSClosed);

begin
  With ExJHRec do
  begin
    JobCode:=JobR.JobCode;
    JobDesc:=JobR.JobDesc;
    JobFolio:=JobR.JobFolio;
    CustCode:=JobR.CustCode;
    JobCat:=JobR.JobCat;
    JobAltCode:=JobR.JobAltCode;
    Contact:=JobR.Contact;
    JobMan:=JobR.JobMan;
    QuotePrice:=JobR.QuotePrice;
    CurrPrice:=JobR.CurrPrice;
    StartDate:=JobR.StartDate;
    EndDate:=JobR.EndDate;
    RevEDate:=JobR.RevEDate;
    SORRef:=JobR.SORRef;
    VATCode:=JobR.VATCode;
    JobAnal:=JobR.JobAnal;
    JobType:=JobR.JobType;

    {* LongInt to WordBool *}
    Completed:=CompletedAR[Ord(JobR.Completed)];

    {* SmallInt to Char T/F/C/N *}
    ChargeType:=ChargeTypeAR[JobR.ChargeType];

    {* LongInt to Char Q/A/S/C/L *}
    JobStat:=JobStatAR[JobR.JobStat];

    {* 10.12.99 *}
    UserDef1:=JobR.UserDef1;
    UserDef2:=JobR.UserDef2;
    {$IFDEF COMTK}
    DefRetCurr := JobR.DefRetCurr;
    JPTOurRef := JobR.JPTOurRef;
    JSTOurRef := JobR.JSTOurRef;
    JQSCode := JobR.JQSCode;
    {$ENDIF} //PR: 21/10/2011 Moved Ud3 & 4 out of COMTk only for v6.9
    UserDef3:=JobR.UserDef3;
    UserDef4:=JobR.UserDef4;

    //PR: 21/10/2011 v6.9
    UserDef5 := JobR.UserDef5;
    UserDef6 := JobR.UserDef6;
    UserDef7 := JobR.UserDef7;
    UserDef8 := JobR.UserDef8;
    UserDef9 := JobR.UserDef9;
    UserDef10 := JobR.UserDef10;

    //PR: 12/09/2013 ABSEXCH-13192
    jrCostCentre := JobR.CCDep[True];
    jrDepartment := JobR.CCDep[False];

    //AP: 08/12/2017 ABSEXCH-19485
    {$IFDEF COMTK}
      jrAnonymised := JobR.jrAnonymised;
      jrAnonymisedDate := JobR.jrAnonymisedDate;
      jrAnonymisedTime := JobR.jrAnonymisedTime;
    {$ENDIF}
  end; { with..}
end; {JobToExJob..}


Procedure JobToExJob(Var ExJHRec  :  TBatchJHRec);
begin
  CopyExJobToTKJob (JobRec^, ExJHRec);
End;

{ ============ Get Job Header Record ============== }

FUNCTION EX_GETJOB(P            :  POINTER;
                   PSIZE        :  LONGINT;
                   SEARCHKEY    :  PCHAR;
                   SEARCHPATH   :  SMALLINT;
                   SEARCHMODE   :  SMALLINT;
                   LOCK         :  WORDBOOL) : SMALLINT;
Const
  Fnum       =  JobF;

Var
  ExJHRec    :  ^TBatchJHRec;
  KeyS       :  Str255;
  Locked     :  Boolean;
  B_Func     :  Integer;

Begin
  LastErDesc:='';
  Result:=32767;
  Locked:=BOff;
  B_Func:=0;

  If (P<>Nil) and (PSize=Sizeof(TBatchJHRec)) then
  Begin

    KeyS:=StrPas(SearchKey);

    ExJHRec:=P;

    If TestMode Then
            ShowMessage ('Ex_GetJob: ' + #10#13 +
            'P: ' + ExJHRec^.JobCode + #10#13 +
            'PSize: ' + IntToStr(PSize) + #10#13 +
            'SearchKey: ' + StrPas(SearchKey) + #10#13 +
            'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
            'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
            'Lock: ' + IntToStr(Ord(Lock)));

    Blank(ExJHRec^,Sizeof(ExJHRec^));

    Result:=Find_Rec(SearchMode,F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath,KeyS);

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
      {$IFDEF WIN32}
      begin
        If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked)) then
          Result:=0;

        // If not locked and user hits cancel return code 84
        if (Result = 0) and not Locked then
          Result := 84;
      end;
      {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked));
      {$ENDIF}


    StrPCopy(SearchKey,KeyS);

    If (Result=0) then
      JobToExJob(ExJHRec^);

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(60,Result);

end; { Ex_GetJob.. }

{ =========== Store Job Header Record ============ }
//PR: 28/09/2010 Changes to store procedure to avoid being able to amend JobCat
Function ExJobToJob(ExJHRec  :  TBatchJHRec;
                Var AddMode  :  SmallInt)  :  Integer;

Const
  Fnum    = JobF;
  KeyPath = JobCodeK;

  CompletedAR   :  Array[False..True] of Integer = (0,1);
  ChargeTypeAR  :  Array[CTStart..CTEnd] of Char = (CTTime,CTFixed,CTCost,CTNon);
  JobStatAR     :  Array[JSStart..JSEnd] of Char = (JSQuo,JSActive,JSSusp,JSCompl,JSClosed);
Var
  n         : Byte;

  OJob      : JobRecType;

  FindRec,
  ValidRec,
  ValidHed  : Boolean;

  Td,Tm,Ty  : Word;

  KeyS      : Str255;

Begin
  Result:=0;
  ValidRec:=BOff;
  ValidHed:=BOn;

  With JobRec^ do
  Begin

    KeyS:=LJVar(UpperCase(ExJHRec.JobCode),JobCodeLen);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    FindRec:=StatusOk;

    {* For Wins Import *}

    If (AddMode=CheckMode) or (AddMode=ImportMode) then
    begin
      If (FindRec) then
        AddMode:=B_Update
      else
        AddMode:=B_Insert;
    end;

    If (AddMode=B_Insert) then
    Begin
      ResetRec(Fnum);
      GenSetError(Not FindRec,5,Result,ValidHed);
    end
    else
    Begin
      GenSetError(FindRec,4,Result,ValidHed);
      OJob:=JobRec^; //PR: Store Existing JobRec for validation
    end;

    {* Assign fields *}
    JobCode:=FullJobCode(UpperCase(ExJHRec.JobCode));
    {JobCode:=ExJHRec.JobCode;}

    JobDesc:=FullJobDesc(ExJHRec.JobDesc);
    CustCode:=FullCustCode(ExJHRec.CustCode);
    JobCat:=FullJobCode(UpperCase(ExJHRec.JobCat));
    JobAltCode:=FullJobCode(UpperCase(ExJHRec.JobAltCode));
    Contact:=ExJHRec.Contact;
    JobMan:=ExJHRec.JobMan;
    QuotePrice:=ExJHRec.QuotePrice;
    CurrPrice:=ExJHRec.CurrPrice;
    StartDate:=ExJHRec.StartDate;
    EndDate:=ExJHRec.EndDate;
    RevEDate:=ExJHRec.RevEDate;
    SORRef:=UpperCase(ExJHRec.SORRef);
    VATCode:=ExJHRec.VATCode;
    JobAnal:=FullCCDepKey(UpperCase(ExJHRec.JobAnal)); {* Job Type *}
    JobType:=ExJHRec.JobType;            {* Job or Contract *}

    Completed:=CompletedAR[WordBoolToBool(ExJHRec.Completed)];

    For n:=CTStart to CTEnd do
      If (ExJHRec.ChargeType=ChargeTypeAR[n]) then
        ChargeType:=n;

    If (Not (ChargeType In [CTStart..CTEnd])) then
      ChargeType:=CTStart;

    For n:=JSStart to JSEnd do
      If (ExJHRec.JobStat=JobStatAR[n]) then
        JobStat:=n;

    If (Not (JobStat In [JSStart..JSEnd])) then
      JobStat:=JSStart;

    {* 10.12.99 *}
    UserDef1:=ExJHRec.UserDef1;
    UserDef2:=ExJHRec.UserDef2;

    //PR: 21/10/2011 Moved Ud3 & 4 out of COMTk only for v6.9
    UserDef3:=ExJHRec.UserDef3;
    UserDef4:=ExJHRec.UserDef4;

    //PR: 21/10/2011 v6.9
    UserDef5 := ExJHRec.UserDef5;
    UserDef6 := ExJHRec.UserDef6;
    UserDef7 := ExJHRec.UserDef7;
    UserDef8 := ExJHRec.UserDef8;
    UserDef9 := ExJHRec.UserDef9;
    UserDef10 := ExJHRec.UserDef10;

    //PR: 14/03/2012 v6.10 ABSEXCH-12118
    {$IFDEF COMTK}
    JQSCode := ExJHRec.JQSCode;
    {$ENDIF}

    //PR: 12/09/2013 ABSEXCH-13192
    CCDep[True] := ExJHRec.jrCostCentre;
    CCDep[False] := ExJHRec.jrDepartment;

    //AP: 08/12/2017 ABSEXCH-19485
    {$IFDEF COMTK}
      jrAnonymised := ExJHRec.jrAnonymised;
      jrAnonymisedDate := ExJHRec.jrAnonymisedDate;
      jrAnonymisedTime := ExJHRec.jrAnonymisedTime;
    {$ENDIF}
    {* Begin Validation *}


    If (Result=0) then
    Begin


      If (AddMode=B_Update) then
      Begin
        {* Job Type must be same *}
        ValidRec:=(OJob.JobType=JobType);
        GenSetError(ValidRec,30001,Result,ValidHed);

        //PR: 28/09/2010 Moved check from below where JobCat had already been set.
        {* Job Category must be same *}
        ValidRec:=(OJob.JobCat=JobCat);
        GenSetError(ValidRec,30002,Result,ValidHed);

        //PR: Can't see the point of these
{        OJob.JobCode       := JobCode;
        OJob.JobFolio      := JobFolio;
        OJob.NLineCount    := NLineCount;
        OJob.ALineCount    := ALineCount;
        OJob.JobType       := JobType;
        OJob.JobAnal       := JobAnal;
        OJob.JobCat        := JobCat;}

        {* Job Category must be same *}
{        ValidRec:=(OJob.JobCat=JobCat);
        GenSetError(ValidRec,30002,Result,ValidHed);}
      end
      else  {* New record *}
      begin

        {* Job Code should not be empty *}
        ValidRec:=(Not EmptyKey(JobCode,JobCodeLen));
        GenSetError(ValidRec,30003,Result,ValidHed);

        {OJob.}NLineCount:=1;
        {* 24.02.99 - Changed from 1 to 1000 advised by EL *}
        {OJob.}ALineCount:=1000;

      end;  {If AddMode..}

      {Nom:=ONom; if same file is used to search, it is necessary to assign back!}
//      JobRec^:=OJob;

      {* Job Type Check *}
      ValidRec:=((JobType=JobGrpCode) or (JobType=JobJobCode)); {K/J}
      GenSetError(ValidRec,30004,Result,ValidHed);

      {* Currency Check *}
      If (ExSyss.MCMode) then
        ValidRec:=((CurrPrice>=1) and (CurrPrice<=CurrencyType))
      else
      Begin
        ValidRec:=BOn;
        CurrPrice:=0;
      end;
      GenSetError(ValidRec,30005,Result,ValidHed);

//      JobRec^:=OJob; {* JobCat checking use Job file and record may be diff. *}

//-------------------------------------------------------------------------------
      {* Job Category Check *} //At BH's request moved above to be first test

(*      ValidRec:=(EmptyKey(JobCat,JobCodeLen));  {* Blank Cat = Level 0 *}
      If (Not ValidRec) then
      Begin
        ValidRec:=(CheckRecExsists(JobCat,Fnum,Keypath));
        ValidRec:=((ValidRec) and ((JobType=JobGrpCode)));  {JobGrpCode=K}
      end;
      GenSetError(ValidRec,30006,Result,ValidHed);

      JobRec^:=OJob; {* JobCat checking use Job file and record may be diff. *}
      *)
//--------------------------------------------------------------------------------

      {* VAT Code Check *}
      ValidRec:=(VATCode<>VATMCode) and (VATCode In VATSet);
      GenSetError(ValidRec,30007,Result,ValidHed);

      {* Customer Code Check *}
      {* 06.11.98 - Modified for Windows version Job costing *}
      ValidRec:=(JobType=JobGrpCode);  {If not Contract, CustCode is mandatory.}
      If (Not ValidRec) then
      Begin
        ValidRec:= (CustCode <> '') and CheckRecExsists(CustCode,CustF,CustCodeK);
        ValidRec:=((ValidRec) and (Cust.CustSupp=TradeCode[BOn])); { Trade[off]='S' [on]='C' }
      end;
      GenSetError(ValidRec,30008,Result,ValidHed);

      {* Start Date Check *}
      DateStr(StartDate,Td,Tm,Ty);
      ValidRec:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));
      GenSetError(ValidRec,30009,Result,ValidHed);

      {* End Date Check *}
      //AP : 19/12/2016 2017-R1 ABSEXCH-16294 : Error in Toolkit when trying to set the status of a Job to closed
      If (EndDate<>'') and (EndDate<>'00000000') then
      begin
        DateStr(EndDate,Td,Tm,Ty);
        ValidRec:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));
        GenSetError(ValidRec,30010,Result,ValidHed);
      end;

      {* Revised Date Check *}
      //AP : 19/12/2016 2017-R1 ABSEXCH-16294 : Error in Toolkit when trying to set the status of a Job to closed
      If (RevEDate<>'') and (RevEDate<>'00000000') then
      begin
        DateStr(RevEDate,Td,Tm,Ty);
        ValidRec:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));
        GenSetError(ValidRec,30011,Result,ValidHed);
      end;

      ValidRec:=(JobType=JobGrpCode);  {If not Contract, CustCode is mandatory.}
      If (Not ValidRec) then
      begin
        ValidRec := (CheckRecExsists(JARCode+JATCode+JobAnal,JMiscF,JMK) and
          (Strip('B',[#32],JobAnal)<>''));

        GenSetError(ValidRec,30012,Result,ValidHed);
      end; {if..}

      //Check whether we need to check the CC/Dept at all - system switch plus not a contract
      //PR: 12/09/2013 ABSEXCH-13192
      If Syss.UseCCDep and (JobType <> JobGrpCode)Then
      Begin
      // Validate CC/Dept Codes fully
        ValidRec := EmptyKey(CCDep[True], CCKeyLen);
        if not ValidRec then
          ValidRec:=CheckRecExsists(CostCCode+CSubCode[Bon]+CCDep[True],PWrdF,PWK);

        if ValidRec then
        begin
          ValidRec := EmptyKey(CCDep[False], CCKeyLen);
          if not ValidRec then
            ValidRec:=CheckRecExsists(CostCCode+CSubCode[Boff]+CCDep[False],PWrdF,PWK);
        end;


        GenSetError(ValidRec,30013,Result,ValidHed);

      End { If Syss.UseCCDep }
      Else Begin
        // CC/Depts turned off or contract - blank out CC/Dept
        CCDep[True] := '';
        CCDep[False] := '';
      End; { Else }

//-------------------------------------------------------------------------------
      {* Job Category Check *} //At BH's request moved from below to be first test

      ValidRec:=(EmptyKey(JobCat,JobCodeLen));  {* Blank Cat = Level 0 *}
      If (Not ValidRec) then
      Begin
        OJob := JobRec^; //Store Job Rec again before searching for Parent Job
        ValidRec:=(CheckRecExsists(JobCat,Fnum,Keypath));
        ValidRec:=((ValidRec) and ((JobType=JobGrpCode)));  {JobGrpCode=K}
        JobRec^:=OJob; {* JobCat checking use Job file and record may be diff. *}  //Reset JobRec
      end;
      GenSetError(ValidRec,30006,Result,ValidHed);



//--------------------------------------------------------------------------------
    end;  {If Result=0 ..}


  end; {With JobRec^ do..}

end; {func..}


FUNCTION EX_STOREJOB(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT) : SMALLINT;
Const
  Fnum  = JobF;
Var
  ExJHRec    :  ^TBatchJHRec;
  KeyS       :  Str255;
  TmpMode    :  SmallInt;

Begin
  if CheckOnly then
    SearchMode := CheckMode;

  LastErDesc:='';
  If TestMode Then Begin
    ExJHRec:=P;
    ShowMessage('Ex_StoreJob:' + #10#13 +
                'P^.JobCode: ' + ExJHRec^.JobCode + #10#13 +
                'PSize: ' + IntToStr(PSize) + #10#13 +
                'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  TmpMode:=SearchMode;
  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchJHRec)) then
  Begin

    ExJHRec:=P;

    ExJHRec.JobCode := UpperCase(ExJHRec.JobCode);

    if JBCostOn then
      Result:=ExJobToJob(ExJHRec^,SearchMode)
    else
      Result := NoJobErr;

    If (TmpMode<>CheckMode) and (Result=0) then
    Case SearchMode of

      B_Insert  :  begin
                     With JobRec^ do
                     begin
                       Result:=GetNextCount(JBF,BOn,BOff,0,JobFolio,''); { JBF is for Job Folio No }
                     end;
                     Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath);
                     If (Result=0) then
                       Gen_JMajorHed(JobRec^);

                     //PR: 02/11/2011 v6.9
                     if Result = 0 then
                       AuditNote.AddNote(anJob, JobRec^.JobFolio, anCreate);
                   end;

      B_Update  :  begin
                     Result:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath);

                     //PR: 02/11/2011 v6.9
                     if Result = 0 then
                       AuditNote.AddNote(anJob, JobRec^.JobFolio, anEdit);
                   end;

      else         Result:=30000;

    end;

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(61,Result);

end; {Ex_StoreJob Func..}


{* ---- From Exch.Employee Record to External Employee Record ------ *}
Procedure CopyExEmployeeToTKEmployee(Const EmployeeRec : EmplType;
                                         Var ExEmployee : TBatchEmplRec);
Var
  n  :  Byte;
begin
  With ExEmployee do
  begin
    EmpCode:=EmployeeRec.EmpCode;
    Supplier:=EmployeeRec.Supplier;
    EmpName:=EmployeeRec.EmpName;
    For n:=1 to 5 do
      Addr[n]:=EmployeeRec.Addr[n];
    Phone:=EmployeeRec.Phone;
    Fax:=EmployeeRec.Fax;
    Mobile:=EmployeeRec.Phone2;
    {to change }
    Case EmployeeRec.EType of
      1  :  EmpType:='P';  { Production }
      2  :  EmpType:='S';  { Sub-Contract }
      3  :  EmpType:='O';  { Over-head }
    end; {case..}

    PayNo:=EmployeeRec.PayNo;
    CertNo:=EmployeeRec.CertNo;
    CertExpiry:=EmployeeRec.CertExpiry;
{    UseORate:=WordBoolToBool(EmployeeRec.UseORate);}
    UseORate := EmployeeRec.UseORate;
    UserDef1:=EmployeeRec.UserDef1;
    UserDef2:=EmployeeRec.UserDef2;
    CC := EmployeeRec.CCDep[true];
    Dep := EmployeeRec.CCDep[false];
    Case EmployeeRec.CISType of
      0  :  CertType := 'N';
      1  :  CertType := '4';
      2  :  CertType := '5';
      3  :  CertType := '6';
      4  :  CertType := '7';
      5  :  CertType := '8';
      else
        CertType := 'N';
    end;
    UserDef3 := EmployeeRec.UserDef3;
    UserDef4 := EmployeeRec.UserDef4;
    GroupCert := BoolToWordBool(EmployeeRec.GroupCert);
    SelfBill := BoolToWordBool(EmployeeRec.GSelfBill);
    ENINo := EmployeeRec.ENINo;
    {$IFDEF EN551}
    LabourPLOnly := BoolToWordBool(EmployeeRec.LabPLOnly);
    {$ENDIF}
    {$IFDEF COMTK}
     UTRCode := EmployeeRec.UTRCode;
     VerificationNo := EmployeeRec.VerifyNo;
     Tagged := (EmployeeRec.Tagged = 1);
     ContractorType := EmployeeRec.CISSubType;
    {$ENDIF}
     emEmailAddress := EmployeeRec.emEmailAddr;
    {$IFDEF COMTK}
      emStatus := Ord(EmployeeRec.emStatus);
      emAnonymisationStatus := Ord(EmployeeRec.emAnonymisationStatus);
      emAnonymisedDate := EmployeeRec.emAnonymisedDate;
      emAnonymisedTime := EmployeeRec.emAnonymisedTime;
    {$ENDIF}
  end; {with..}
end; {func..}



function EmpToExEmp(Var ExEmp  :  TBatchEmplRec) :  Integer;
Var
  n  :  Byte;

begin
 Result := 0;
 CopyExEmployeeToTKEmployee(JobMisc^.EmplRec, ExEmp);
(*  With ExEmp do
  begin
    EmpCode:=JobMisc^.EmplRec.EmpCode;
    Supplier:=JobMisc^.EmplRec.Supplier;
    EmpName:=JobMisc^.EmplRec.EmpName;
    For n:=1 to 5 do
      Addr[n]:=JobMisc^.EmplRec.Addr[n];
    Phone:=JobMisc^.EmplRec.Phone;
    Fax:=JobMisc^.EmplRec.Fax;
    Mobile:=JobMisc^.EmplRec.Phone2;
    {to change }
    Case JobMisc^.EmplRec.EType of
      1  :  EmpType:='P';  { Production }
      2  :  EmpType:='S';  { Sub-Contract }
      3  :  EmpType:='O';  { Over-head }
    end; {case..}

    PayNo:=JobMisc^.EmplRec.PayNo;
    CertNo:=JobMisc^.EmplRec.CertNo;
    CertExpiry:=JobMisc^.EmplRec.CertExpiry;
{    UseORate:=WordBoolToBool(JobMisc^.EmplRec.UseORate);}
    UseORate:=BoolToWordBool(JobMisc^.EmplRec.UseORate);
    UserDef1:=JobMisc^.EmplRec.UserDef1;
    UserDef2:=JobMisc^.EmplRec.UserDef2;
    CC := JobMisc^.EmplRec.CCDep[true];
    Dep := JobMisc^.EmplRec.CCDep[false];
  end; {with..} *)
end; {func..}

Procedure CopyTkEmployeeToEntEmployee(Var EmployeeRec : EmplType;
                                    const ExEmployee  : TBatchEmplRec);
Var
  n  :  Byte;
begin
  With ExEmployee do
  begin
    EmployeeRec.EmpCode := FullEmpKey(UpperCase(EmpCode));
    EmployeeRec.Supplier := FullCustCode(Supplier);
    EmployeeRec.EmpName := EmpName;
    //PR 25/01/2008 Start populating surname field as Exchequer does
    EmployeeRec.Surname := ExtractWords(WordCnt(EmpNAme),1,EmpName);
    EmployeeRec.Phone := Phone;
    EmployeeRec.Fax := Fax;
    EmployeeRec.Phone2 := Mobile;
    {to change }

    EmployeeRec.PayNo := PayNo;
    EmployeeRec.CertNo := CertNo;
    EmployeeRec.CertExpiry := CertExpiry;

    EmployeeRec.UseORate := Byte(UseORate);

    EmployeeRec.UserDef1 := UserDef1;
    EmployeeRec.UserDef2 := UserDef2;
    EmployeeRec.CCDep[true] := FullCCDepKey(UpperCase(CC));
    EmployeeRec.CCDep[false] := FullCCDepKey(UpperCase(Dep));

    EmployeeRec.UserDef3 := UserDef3;
    EmployeeRec.UserDef4 := UserDef4;
    EmployeeRec.GroupCert  := WordBoolToBool(GroupCert);
    Case CertType of
      'N' :   EmployeeRec.CISType := 0;
      '4'  :  EmployeeRec.CISType := 1;
      '5'  :  EmployeeRec.CISType := 2;
      '6'  :  EmployeeRec.CISType := 3;
      '7'  :  EmployeeRec.CISType := 4;
      '8'  :  EmployeeRec.CISType := 5;
      else
        EmployeeRec.CISType := 0;
    end;
    EmployeeRec.GSelfBill := WordBoolToBool(SelfBill);


    For n:=1 to 5 do
      EmployeeRec.Addr[n] := Addr[n];

    Case EmpType of
      'P'  : EmployeeRec.EType := 1;  { Production }
      'S'  :  EmployeeRec.EType := 2;  { Sub-Contract }
      'O'  :  EmployeeRec.EType := 3;  { Over-head }
      else
        EmployeeRec.EType := 1;
    end; {case..}

    EmployeeRec.ENINo := ENINo;
    {$IFDEF EN551}
    EmployeeRec.LabPLOnly := WordBoolToBool(LabourPLOnly);
    {$ENDIF}
    {$IFDEF COMTK}
    EmployeeRec.VerifyNo := VerificationNo;
    EmployeeRec.UTRCode := UTRCode;
    if WordBoolToBool(Tagged) then
      EmployeeRec.Tagged := 1
    else
      EmployeeRec.Tagged := 0;
    EmployeeRec.CISSubType := ContractorType;
    {$ENDIF}
    EmployeeRec.emEmailAddr := emEmailAddress;
    {$IFDEF COMTK}
      EmployeeRec.emAnonymisationStatus := TEntityAnonymisationStatus(emAnonymisationStatus);
      EmployeeRec.emAnonymisedDate := emAnonymisedDate;
      EmployeeRec.emAnonymisedTime := emAnonymisedTime;
    {$ENDIF}

  end; {with..}
end; {func..}

function GetSetEmployeeGroup(var ExEmpRec : TBatchEmplRec; A, B : Boolean) : SmallInt;
const
  FNum = JMiscF;
  SearchPath = 2;
var
  KeyChk,KeyS  : Str255;
  Done : Boolean;
  Mode : Byte;
  C, D, Get : Boolean;
  Locked : Boolean;
  SearchMode : SmallInt;
  RecPos : Longint;
  KeyNum : Integer;
begin
{4 possibilities-
 A : Need to set certificate ref on all other employees of that supplier
 B : As B for certificate expiry
 C : We have a blank cert ref and need to take it from another employee
 D : As C for certificate expiry}

  Result := 0;

  C := (Trim(ExEmpRec.CertNo) = '');
  D := (Trim(ExEmpRec.CertExpiry) = '');

  Get := C or D;

  if A or B or C or D then
  begin
    //Store record position
    KeyNum := GetPosKey;
    Result := Presrv_BTPos(JMiscF, KeyNum, F[JMiscF], RecPos, False, False);

    if Result = 0 then
    begin


      Done := False;

      KeyChk := JARCode+JAECode + ExEmpRec.Supplier;
      KeyS := KeyChk;

      SearchMode := B_GetGEq;

      Repeat
        Result:=Find_Rec(SearchMode,F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath,KeyS);

        SearchMode:=B_GetNext;

        if (Result = 0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and JobMisc^.EmplRec.GroupCert then
        begin
          if Get then
          begin
            if C then
              ExEmpRec.CertNo := JobMisc^.EmplRec.CertNo;

            if D then
              ExEmpRec.CertExpiry := JobMisc^.EmplRec.CertExpiry;

            Done := True;
          end
          else
          begin
            if A or B then
            begin
              //Get record lock first
              If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,True{wait},Locked)) then
                Result:=0;

              // If not locked and user hits cancel return code 84
              if (Result = 0) and not Locked then
                Result := 84;

              if Result = 0 then
              begin
                JobMisc^.EmplRec.CertNo := ExEmpRec.CertNo;
                JobMisc^.EmplRec.CertExpiry := ExEmpRec.CertExpiry;

                Result := Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath);
              end;
            end;
          end;

        end;

      Until Done or (Result<>0) or not CheckKey(KeyChk,KeyS,Length(KeyChk),BOn);
      //Restore record position //PR: 25/03/2014 ABSEXCH-15199 Change to return record.
      Presrv_BTPos(JMiscF, KeyNum, F[JMiscF], RecPos, True, True);
    end; //rec position saved

  end; //A or B or C or D
end;

Function TkEmpToEmp(ExEmpRec  :  TBatchEmplRec;
                    AddMode,
                    SearchPath:  SmallInt)  :  Integer;
const
  FNum = JMiscF;
  KeyPath = 0;
var
  KeyChk, KeyS : Str255;
  ValidHed, ValidCheck, TBo, RepBo  : Boolean;
  s : String[3];
  NeedGrpCertRefUpdate : Boolean;
  NeedGrpCertExpUpdate : Boolean;
  SaveAddMode : SmallInt;
  lAnonDiaryDetail: IAnonymisationDiaryDetails;
  lRes: Integer;

  //ABSEXCH-20851:Validation check for the Employee associated with the Trader account
  lKeyS: Str255;
  lStatus: Integer;

begin
  Result := 0;
  KeyChk:=JARCode+JAECode;
  ExEmpRec.EmpCode:=LJVar(UpperCase(ExEmpRec.EmpCode),AccLen);
  KeyS:= ExEmpRec.EmpCode;
  SaveAddMode := AddMode;
  NeedGrpCertExpUpdate := False;
  NeedGrpCertRefUpdate := False;
  KeyS:=KeyChk+KeyS;

  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    {import - assign appro. mode }
  If (AddMode=CheckMode) or (AddMode=ImportMode) then
  begin
    If (Status = 0) then
      AddMode:=B_Update
    else
      AddMode:=B_Insert;
  end;


  If (AddMode=B_Insert) then
  Begin
    ResetRec(Fnum);
    GenSetError((Status <> 0),5,Result,ValidHed);
  end
  else
  Begin
    GenSetError((Status = 0),4,Result,ValidHed);
  end;

  if (Result = 0) and Syss.UseCCDep then
  begin
    //Check CC & Department
    For Tbo := BOff to BOn Do
    Begin
      RepBo:=BOff;
      Repeat
        if not RepBo then
          s := FullCCDepKey(UpperCase(ExEmpRec.CC))
        else
          s := FullCCDepKey(UpperCase(ExEmpRec.Dep));
        KeyS:=(CostCCode+CSubCode[TBo]+ s);
        Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyS);

        ValidCheck:=(Status=0);

        RepBo:=Not RepBo;

      Until (Not RepBo) or (ValidCheck);
      GenSetError(ValidCheck,30001,Result,ValidHed);

      {SS 15/06/2016 2016-R3
       ABSEXCH-12948:Core Financials - Possible to import Transactions with Inactive CC/Depts using Importer Module.
       -Added validation to check Cost Centre/Department is active or not.}
      if ValidCheck and (Trim(s) <> EmptyStr) then
      begin
        ValidCheck := (PassWord.CostCtrRec.HideAC = 0);
        GenSetError(ValidCheck,30007,Result,ValidHed);
      end;
    end;
  end;

  if (Result = 0) then
  begin
    //If employee type is sub-contractor then must have a valid supplier code,
    //if not then supplier code must be blank
    if (ExEmpRec.EmpType = 'S') then
    begin
      ValidCheck:=(ExEmpRec.Supplier <> '') and
         (CheckRecExsists(FullCustCode(ExEmpRec.Supplier),CustF,CustCodeK) and (Cust.CustSupp = TradeCode[False]));
      GenSetError(ValidCheck,30002,Result,ValidHed);
    end
    else
    begin
      ExEmpRec.Supplier := '';
      ExEmpRec.GroupCert := BoolToWordBool(False);
    end;
  end;

  if (Result = 0) and (ExEmpRec.EmpType = 'S') then
  begin
  //Check Cert Expiry is a valid Date  (can also be blank)
    ValidCheck := ValidDate(ExEmpRec.CertExpiry) or (Trim(ExEmpRec.CertExpiry) = '') or
       (ExEmpRec.CertType in ['N', '5', '7']);

    GenSetError(ValidCheck,30003,Result,ValidHed);
  end;
  
  {$IFDEF COMTK}
    {SS 25/05/2016 2016-R2 ABSEXCH-16608:importer issues - Employee Records the field EMSUBTYP - Added Validation for invalid Contractor Type.}
    if (Result = 0) and (ExEmpRec.EmpType = 'S') then
    begin
      ValidCheck := (ExEmpRec.ContractorType in [0..4]);
      GenSetError(ValidCheck,30006,Result,ValidHed);
    end;
  {$ENDIF}

  if (Result = 0) then
  begin
   {Before copying the record to the Ent Record, check for whether we need a Group Certificate Update.
    If Group Certificate then Cert reference & expiry must be the same as others for that supplier. so
    if cert ref is blank, then try to find one for another employee, if not then we need to update
    all the employees of that supplier who have GroupCert = True.
    This is a 2-pass operation - before saving the record we need to set blank certno or expiry if necessary,
    after, we need to set other employees if necessary}

    if WordBoolToBool(ExEmpRec.GroupCert) then
    begin
      NeedGrpCertRefUpdate := (ExEmpRec.CertNo <> JobMisc^.EmplRec.CertNo) and
         (Trim(ExEmpRec.CertNo) <> '');

      NeedGrpCertExpUpdate := (ExEmpRec.CertExpiry  <> JobMisc^.EmplRec.CertExpiry) and
         (Trim(ExEmpRec.CertExpiry) <> '');

      Result := GetSetEmployeeGroup(ExEmpRec, False, False);
      if Result in [4, 9] then
        Result := 0;
      ValidCheck := Result = 0;
      GenSetError(ValidCheck,30004,Result,ValidHed);

    end;
  end;

  if (Result = 0) and (SaveAddMode <> CheckMode) then
  begin
    //PR: 25/03/2014 ABSEXCH-15199 If we're adding then we need to clear the record again after
    //                             the previous checks
    If (AddMode=B_Insert) then
      ResetRec(Fnum);

    CopyTkEmployeeToEntEmployee(JobMisc^.EmplRec, ExEmpRec);
    {$IFDEF COMTK}
      //AP 22/06/2018 ABSEXCH-20851:Validation check for the Employee associated with the Trader account
      if (JobMisc^.EmplRec.EType = 2) and (ExEmpRec.emStatus = 0) then
      begin
        lKeyS := FullCustCode(JobMisc^.EmplRec.Supplier);
        lStatus := Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, lKeyS);
        if (lStatus = 0) and (Cust.AccStatus = 3) then
        begin
          ValidCheck := False;
          GenSetError(ValidCheck, 30009, Result, ValidHed); 
        end;
      end;

      //HV 20/06/2018 2018-R1.1 ABSEXCH-20851: Com Toolkit > Employee Status > The new Employee Status field should fully implement the Open/Close status changes as per HLD section 6.3.2 Close Employee Process
      if (Result = 0) and GDPROn and (AddMode = B_Update) and (TEmployeeStatus(ExEmpRec.emStatus) <> JobMisc^.EmplRec.emStatus) then
      begin
        if (ExEmpRec.emAnonymisationStatus = 2) then
        begin
          ValidCheck := False;
          GenSetError(ValidCheck, 30008, Result, ValidHed);
        end
        else
        begin
          lAnonDiaryDetail := CreateSingleAnonObj;
          JobMisc^.EmplRec.emStatus := TEmployeeStatus(ExEmpRec.emStatus);
          if Assigned(lAnonDiaryDetail) then
          begin
            case ExEmpRec.emStatus of
              0:
              begin
                JobMisc^.EmplRec.emAnonymisationStatus := asNotRequested;
                JobMisc^.EmplRec.emAnonymisedDate := '';
                JobMisc^.EmplRec.emAnonymisedTime := '';
                //Remove Entry from AnonymisationDiary Table
                lRes := lAnonDiaryDetail.RemoveEntity(adeEmployee, ExEmpRec.EmpCode);
              end;
              1:
              begin
                //Add Entry into AnonymisationDiary Table
                lAnonDiaryDetail.adEntityType := adeEmployee;
                lAnonDiaryDetail.adEntityCode := ExEmpRec.EmpCode;
                lRes := lAnonDiaryDetail.AddEntity;

                if lRes = 0 then
                begin
                  JobMisc^.EmplRec.emAnonymisationStatus := asPending;
                  if (JobMisc^.EmplRec.EType = 2) and (Cust.acAnonymisationStatus = asPending) then
                    JobMisc^.EmplRec.emAnonymisedDate := Cust.acAnonymisedDate
                  else
                    JobMisc^.EmplRec.emAnonymisedDate := lAnonDiaryDetail.adAnonymisationDate;
                  JobMisc^.EmplRec.emAnonymisedTime := TimeNowStr;
                end;
              end;
            end;
          end;
        end;
      end;

    {$ENDIF}

    if (Result = 0) then
    begin
      JobMisc^.RecPfix := JARCode;
      JobMisc^.SubType := JAECode;
      Case AddMode of

        B_Insert  :  Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath);

        B_Update  :  Result:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath);

        else         Result:=30000;

      end;
    end;
  end;

  if Result = 0 then
  begin
    if WordBoolToBool(ExEmpRec.GroupCert) then
      Result := GetSetEmployeeGroup(ExEmpRec, NeedGrpCertRefUpdate, NeedGrpCertExpUpdate);
    if Result in [4, 9] then
      Result := 0;
    ValidCheck := Result = 0;
    GenSetError(ValidCheck,30005,Result,ValidHed);
  end;
end;



{* ---------- Get Job Costing Employee Record ------------- *}

FUNCTION EX_GETJOBEMPLOYEE(P          :  POINTER;
                           PSIZE      :  LONGINT;
                           SEARCHKEY  :  PCHAR;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT;
                           LOCK       :  WORDBOOL)  :  SMALLINT;

Const
  Fnum   =  JMiscF;

Var
  ExEmpRec  :  ^TBatchEmplRec;
  KeyChk,
  KeyS      :  Str255;
  Found,
  Loop,
  Locked    :  Boolean;
  B_Func    :  Integer;
begin
  LastErDesc:='';
  ExEmpRec:=P;
  Locked:=BOff;

  If (TestMode) then
  With ExEmpRec^ do
  begin
    ShowMessage('Ex_GetJobEmployee  : '+#13#10+
                'PSize              : '+IntToStr(PSize)+#13#10+
                'SearchKey          : '+StrPas(SearchKey)+#13#10+
                'SearchPath         : '+IntToStr(SearchPath)+#13#10+
                'SearchMode         : '+IntToStr(SearchMode)+#13#10+
                'Lock               : '+IntToStr(Ord(Lock)));

  end; {if..}

  Result:=32767;
  If (P<>NIL) and (PSize=SizeOf(TBatchEmplRec)) then
  begin

    KeyChk:=JARCode+JAECode;
    KeyS:=StrPas(SearchKey);
    If (KeyS<>'') then
      KeyS:=LJVar(UpperCase(KeyS),AccLen);

    KeyS:=KeyChk+KeyS;

    Blank(ExEmpRec^,Sizeof(ExEmpRec^));

    Loop:=BOn;
    B_Func:=0;

    Case SearchMode of

      B_GetGEq,
      B_GetGretr,
      B_GetNext,
      B_GetFirst  :  B_Func:=B_GetNext;

      B_GetLess,
      B_GetLessEq,
      B_GetPrev,
      B_GetLast   :  B_Func:=B_GetPrev;

      B_StepFirst,
      B_StepNext  :  B_Func:=B_StepNext;

      B_StepLast,
      B_StepPrev  :  B_Func:=B_StepPrev;

      else           Loop:=BOff;

    end; {Case..}

    Found:=BOff;

    Repeat
      UseVariant(F[FNum]);
      Result:=Find_Rec(SearchMode,F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath,KeyS);

      SearchMode:=B_Func;

      Found:=(Result=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));

    Until ((Found) or ((Result<>0) or (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))) or (Not Loop));

    If WordBoolToBool(Lock) and Found then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      UseVariant(F[FNum]);
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,FNum,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,FNum,SilentLock,Locked));
    {$ENDIF}

    StrPCopy(SearchKey,KeyS);

    If (Found) then
      EmpToExEmp(ExEmpRec^)
    else
      Result:=9;

  end
  else
    if (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(63,Result);

end; {Ex_GetJobEmployee ...}


Procedure CopyExJobAnalysisToTKJobAnalysis (Const JobAnalR : JobAnalType;
                                        Var ExJanalRec : TBatchJobAnalRec);
begin
  With ExJAnalRec do
  begin
    JAnalCode:=JobAnalR.JAnalCode;
    JAnalDesc:=JobAnalR.JAnalName;

    Case JobAnalR.JAType of
      1 : JAnalType:='R';  {Revenue}
      2 : JAnalType:='O';  {Overhead}
      3 : JAnalType:='M';  {Material}
      4 : JAnalType:='L';  {Labour}
    end;

    Case JobAnalR.AnalHed of
      1 : JAnalCatry:='A';  { Sales }
      2 : JAnalCatry:='T';  { Time }
      3 : JAnalCatry:='D';  { Disbursement }
      4 : JAnalCatry:='N';  { Non-Recover Discursement }
      5 : JAnalCatry:='I';  { Stock Issues }
      6 : JAnalCatry:='O';  { Overheads }
      7 : JAnalCatry:='R';  { Receipts }
      8 : JAnalCatry:='W';  { WIP }
      9 : JAnalCatry:='S';  { Retention SL }
     10 : JAnalCatry:='P';  { Retention PL }

     11..17 : JAnalCatry:=Char(JobAnalR.AnalHed);
    end;

    WIPNomCode:=JobAnalR.WIPNom[BOff];
    PLNomCode:=JobAnalR.WIPNom[BOn];

    Case JobAnalR.JLinkLT of
      0  :  LineType:='N';  { Normal }
      1  :  LineType:='L';  { Labour }
      2  :  LineType:='M';  { Materials }
      3  :  LineType:='F';  { Freight }
      4  :  LineType:='D';  { Discount }
      5..17
         :  LineType := Char(JobAnalR.JLinkLT);

    end;

    UpliftP := JobAnalR.UpliftP;
    UpliftGL := JobAnalR.UpliftGL;
    if JobAnalR.RevenueType > 0 then
      RevenueType := JCCats_TxLate(JobAnalR.RevenueType {- 3}, False) - 3
    else
      RevenueType := 0;

    jaPayCode := JobAnalR.JAPayCode;

    {$IFDEF COMTK}
    jaDetType := JobAnalR.JADetType;
    jaCalcB4Ret := JobAnalR.JACalcB4Ret;
    jaDeduct := JobAnalR.JADeduct;
    jaDeductApply := JobAnalR.JADedApply;
    jaRetType := JobAnalR.JARetType;
    jaRetValue := JobAnalR.JARetValue;
    jaRetExpiry := JobAnalR.JARetExp;
    jaRetExpInterval := JobAnalR.JARetExpInt;
    jaPreserveRet := JobAnalR.JARetPres;
    jaDeductCalc := JobAnalR.JADedComp;
    {$ENDIF}


  end; {with..}
end;

Procedure CopyTkJobAnalysisToExJobAnalysis (var JobAnalR : JobAnalType;
                                        Const ExJanalRec : TBatchJobAnalRec);
begin
  With ExJAnalRec do
  begin
    JobAnalR.JAnalCode := FullJACode(UpperCase(JAnalCode));
    JobAnalR.JAnalName := JAnalDesc;
    JobAnalR.JANameCode := FullAnalDesc(JAnalDesc);

    Case ExJanalRec.JAnalType of
      'R' : JobAnalR.JAType := 1;  {Revenue}
      'O' : JobAnalR.JAType := 2;  {Overhead}
      'M' : JobAnalR.JAType := 3;  {Material}
      'L' : JobAnalR.JAType := 4;  {Labour}
    end;

    Case ExJanalRec.JAnalCatry of
      'A' : JobAnalR.AnalHed := 1;  { Sales }
      'T' : JobAnalR.AnalHed := 2;  { Time }
      'D' : JobAnalR.AnalHed := 3;  { Disbursement }
      'N' : JobAnalR.AnalHed := 4;  { Non-Recover Discursement }
      'I' : JobAnalR.AnalHed := 5;  { Stock Issues }
      'O' : JobAnalR.AnalHed := 6;  { Overheads }
      'R' : JobAnalR.AnalHed := 7;  { Receipts }
      'W' : JobAnalR.AnalHed := 8;  { WIP }
      'S' : JobAnalR.AnalHed := 9;  { Retention SL }
      'P' : JobAnalR.AnalHed := 10; { Retention PL }
      #11..#17
          : JobAnalR.AnalHed := Ord(ExJanalRec.JAnalCatry);
    end;

    JobAnalR.WIPNom[BOff] := WIPNomCode;
    JobAnalR.WIPNom[BOn] := PLNomCode;

    Case ExJanalRec.LineType of
      'N'  :  JobAnalR.JLinkLT := 0;  { Normal }
      'L'  :  JobAnalR.JLinkLT := 1;  { Labour }
      'M'  :  JobAnalR.JLinkLT := 2;  { Materials }
      'F'  :  JobAnalR.JLinkLT := 3;  { Freight }
      'D'  :  JobAnalR.JLinkLT := 4;  { Discount }
      #5..#17
           :  JobAnalR.JLinkLT := Ord(ExJanalRec.LineType);
    end;

    JobAnalR.UpliftP := ExJanalRec.UpliftP;
    JobAnalR.UpliftGL := ExJanalRec.UpliftGL;
    if ExJAnalrec.RevenueType > 0 then
      JobAnalR.RevenueType := JCCats_TxLate(ExJanalRec.RevenueType + 3, True)
    else
      JobAnalR.RevenueType := 0;
    JobAnalR.CISTaxRate := ExJanalRec.CISTaxRate;

    JobAnalR.JAPayCode := ExJanalRec.jaPayCode;

    {$IFDEF COMTK}
     JobAnalR.JADetType := ExJanalRec.jaDetType;
     JobAnalR.JACalcB4Ret := ExJanalRec.jaCalcB4Ret;
     JobAnalR.JADeduct := ExJanalRec.jaDeduct;
     JobAnalR.JADedApply := ExJanalRec.jaDeductApply;
     JobAnalR.JARetType := ExJanalRec.jaRetType;
     JobAnalR.JARetValue := ExJanalRec.jaRetValue;
     JobAnalR.JARetExp := ExJanalRec.jaRetExpiry;
     JobAnalR.JARetExpInt := ExJanalRec.jaRetExpInterval;
     JobAnalR.JARetPres := ExJanalRec.jaPreserveRet;
     JobAnalR.JADedComp := ExJanalRec.jaDeductCalc;
    {$ENDIF}


  end; {with..}
end;

{* From Exch. Job Analysis to External Job Analysis Record *}

function JAnalToExJAnal(Var ExJAnal  :  TBatchJobAnalRec) :  Integer;
begin
  Result := 0;
  CopyExJobAnalysisToTKJobAnalysis(JobMisc^.JobAnalRec, ExJAnal);
end; {func..}


{* --------- Get Job Analysis Record ------------ *}

FUNCTION EX_GETJOBANALYSIS(P          :  POINTER;
                           PSIZE      :  LONGINT;
                           SEARCHKEY  :  PCHAR;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT;
                           LOCK       :  WORDBOOL)  :  SMALLINT;

Const
  Fnum   =  JMiscF;

Var
  ExJAnalRec  :  ^TBatchJobAnalRec;
  KeyChk,
  KeyS        :  Str255;
  Found,
  Loop,
  Locked      :  Boolean;
  B_Func      :  Integer;
begin
  LastErDesc:='';
  ExJAnalRec:=P;
  Locked:=BOff;

  If (TestMode) then
  With ExJAnalRec^ do
  begin
    ShowMessage('Ex_GetJobAnalysis  : '+#13#10+
                'PSize              : '+IntToStr(PSize)+#13#10+
                'SearchKey          : '+StrPas(SearchKey)+#13#10+
                'SearchPath         : '+IntToStr(SearchPath)+#13#10+
                'SearchMode         : '+IntToStr(SearchMode)+#13#10+
                'Lock               : '+IntToStr(Ord(Lock)));

  end; {if..}

  Result:=32767;
  If (P<>NIL) and (PSize=SizeOf(TBatchJobAnalRec)) then
  begin

    KeyChk:=JARCode+JAACode;
    KeyS:=StrPas(SearchKey);
    If (KeyS<>'') then
      KeyS:=LJVar(UpperCase(KeyS),JobCodeLen);

    KeyS:=KeyChk+KeyS;

    Blank(ExJAnalRec^,Sizeof(ExJAnalRec^));

    Loop:=BOn;
    B_Func:=0;

    Case SearchMode of

      B_GetGEq,
      B_GetGretr,
      B_GetNext,
      B_GetFirst  :  B_Func:=B_GetNext;

      B_GetLess,
      B_GetLessEq,
      B_GetPrev,
      B_GetLast   :  B_Func:=B_GetPrev;

      B_StepFirst,
      B_StepNext  :  B_Func:=B_StepNext;

      B_StepLast,
      B_StepPrev  :  B_Func:=B_StepPrev;

      else           Loop:=BOff;

    end; {Case..}

    Found:=BOff;

    Repeat
      UseVariant(F[FNum]);
      Result:=Find_Rec(SearchMode,F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath,KeyS);

      SearchMode:=B_Func;

      Found:=(Result=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));

    Until ((Found) or ((Result<>0) or (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))) or (Not Loop));


    If WordBoolToBool(Lock) and Found then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      UseVariant(F[FNum]);
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,FNum,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,FNum,SilentLock,Locked));
    {$ENDIF}

    StrPCopy(SearchKey,KeyS);

    If (Found) then
      JAnalToExJAnal(ExJAnalRec^)
    else
      Result:=9;

  end
  else
    if (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(62,Result);

end; {Ex_GetJobAnalysis...}


{* ------- From Exch. Job Time Rate to External Time Rate ------- *}
Procedure CopyExJRateToTKJRate(const JobRate : EmplPayType;
                                 Var ExJRate   :  TBatchJobRateRec);
begin
  With ExJRate do
  begin
    JRateCode:=JobRate.EStockCode;
    JRateDesc:=JobRate.PayRDesc;
    JAnalCode:=JobRate.EAnalCode;
    If (JobRate.EmpCode<>FullNomKey(PRateCode)) then
      JEmpCode:=JobRate.EmpCode;
    CostCurr:=JobRate.CostCurr;
    Cost:=JobRate.Cost;
    ChargeCurr:=JobRate.ChargeCurr;
    ChargeRate:=JobRate.ChargeOut;
    PayrollCode:=JobRate.PayRRate;
    PayFactor:=JobRate.PayRFact;   { 19.02.2001 - Payroll Factor }
    PayRate:=JobRate.PayRRate;     { 19.02.2001 - Payroll Rate }
  end; {with..}
end; {func..}



function JRateToExJRate(Var ExJRate   :  TBatchJobRateRec)  :  Integer;
begin
  Result := 0;
  CopyExJRateToTKJRate(JobCtrl^.EmplPay, ExJRate);

(*  With ExJRate do
  begin
    JRateCode:=JobCtrl^.EmplPay.EStockCode;
    JRateDesc:=JobCtrl^.EmplPay.PayRDesc;
    JAnalCode:=JobCtrl^.EmplPay.EAnalCode;
    If (JobCtrl^.EmplPay.EmpCode<>FullNomKey(PRateCode)) then
      JEmpCode:=JobCtrl^.EmplPay.EmpCode;
    CostCurr:=JobCtrl^.EmplPay.CostCurr;
    Cost:=JobCtrl^.EmplPay.Cost;
    ChargeCurr:=JobCtrl^.EmplPay.ChargeCurr;
    ChargeRate:=JobCtrl^.EmplPay.ChargeOut;
    PayrollCode:=JobCtrl^.EmplPay.PayRRate;
    PayFactor:=JobCtrl^.EmplPay.PayRFact;   { 19.02.2001 - Payroll Factor }
    PayRate:=JobCtrl^.EmplPay.PayRRate;     { 19.02.2001 - Payroll Rate }
  end; {with..} *)
end; {func..}

{* -------- Get Job Costing Time Rate ---------- *}
FUNCTION EX_GETJOBTIMERATE(P          :  POINTER;
                           PSIZE      :  LONGINT;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT;
                           LOCK       :  WORDBOOL)  :  SMALLINT;

Const
  Fnum   =  JCtrlF;

Var
  ExJRateRec  :  ^TBatchJobRateRec;
  KeyChk,
  KeyS        :  Str255;
  Found,
  Loop,
  Locked      :  Boolean;
  B_Func      :  Integer;
begin
  LastErDesc:='';

  ExJRateRec:=P;
  Locked:=BOff;

  If (TestMode) then
  With ExJRateRec^ do
  begin
    ShowMessage('Ex_GetJobTimeRate  : '+#13#10+
                'PSize              : '+IntToStr(PSize)+#13#10+
                'SearchPath         : '+IntToStr(SearchPath)+#13#10+
                'SearchMode         : '+IntToStr(SearchMode)+#13#10+
                'Lock               : '+IntToStr(Ord(Lock)));

  end; {if..}

  Result:=32767;
  If (P<>NIL) and (PSize=SizeOf(TBatchJobRateRec)) then
  With ExJRateRec^ do
  begin

    JRateCode:=Uppercase(JRateCode);
    JEmpCode:=Uppercase(JEmpCode);

    {* If Global Rate, EmpCode is set as :- *}
    If (EmptyKey(JEmpCode,AccLen)) then
    begin
      KeyChk:=JBRCode+JBECode;
      JEmpCode:=FullNomKey(PRateCode);
    end
    else
    begin {by Employee + RateCode }
      KeyChk:=JBRCode+JBPCode;
    end;

    If (ExSyss.MCMode) then
    begin
      If (Not ((CostCurr>=1) and (CostCurr<=CurrencyType))) then
        CostCurr:=1;
    end
    else
      CostCurr:=0;

    KeyS:=FullJBCode(JEmpCode,CostCurr,JRateCode);

    KeyS:=KeyChk+KeyS;

    Blank(ExJRateRec^,Sizeof(ExJRateRec^));

    Loop:=BOn;
    B_Func:=0;

    Case SearchMode of

      B_GetGEq,
      B_GetGretr,
      B_GetNext,
      B_GetFirst  :  B_Func:=B_GetNext;

      B_GetLess,
      B_GetLessEq,
      B_GetPrev,
      B_GetLast   :  B_Func:=B_GetPrev;

      B_StepFirst,
      B_StepNext  :  B_Func:=B_StepNext;

      B_StepLast,
      B_StepPrev  :  B_Func:=B_StepPrev;

      else           Loop:=BOff;

    end; {Case..}

    Found:=BOff;

    Repeat
      UseVariant(F[FNum]);
      Result:=Find_Rec(SearchMode,F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath,KeyS);

      SearchMode:=B_Func;

      Found:=(Result=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));

    Until ((Found) or ((Result<>0) or (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))) or (Not Loop));

    If WordBoolToBool(Lock) and Found then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      UseVariant(F[FNum]);
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked));
    {$ENDIF}

    {StrPCopy(SearchKey,KeyS);}

    If (Found) then
      JRateToExJRate(ExJRateRec^)
    else
      Result:=9;

  end
  else
    if (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(64,Result);

end; {Ex_GetJobTimeRate...}

{------------------------------------------------------------------------- }

FUNCTION EX_GETJOBTYPE(P          :  POINTER;
                       PSIZE      :  LONGINT;
                       SEARCHKEY  :  PCHAR;
                       SEARCHMODE :  SMALLINT;
                       LOCK       :  WORDBOOL) : SMALLINT;
const
  FNum   =  JMiscF;
var
  ToolkitJobTypeRec : ^TBatchJobTypeRec;
  LockStr : string[5];
  KeyS        :  Str255;
  Locked      :  Boolean;
begin

  LastErDesc:='';
  ToolkitJobTypeRec := P;
  Locked := false;

  if TestMode then
    with ToolkitJobTypeRec^ do
    begin
      if WordBoolToBool(Lock) then
        LockStr := 'True'
      else
        LockStr := 'False';

      ShowMessage('Ex_GetJobType'+#13#10+
                  'PSize : '+IntToStr(PSize)+#13#10+
                  'SearchKey : '+StrPas(SearchKey)+#13#10+
                  'SearchMode : '+IntToStr(SearchMode)+#13#10+
                  'Lock : ' + LockStr);
    end; { TestMode }

  Result := 0;
  { Process fatal errors ... }
  if not Assigned(P) then
    Result := 32767;

  if PSize <> SizeOf(TBatchJobTypeRec) then
    Result := 32766;

  if (Result=0) then
  begin

    { An index MUST be used as cost centres and departments are part of }
    { a variant record structure i.e. step functions won't work }
    case SearchMode of
      B_StepFirst : SearchMode := B_GetFirst;
      B_StepNext  : SearchMode := B_GetNext;
      B_StepLast  : SearchMode := B_GetLast;
      B_StepPrev  : SearchMode := B_GetPrev;
    end;

    Locked := false;

    KeyS := StrPas(SearchKey);
    KeyS := LJVar(Strip('B',[#32],Uppercase(KeyS)), 10);

    case SearchMode of
      B_GetFirst :
        begin
          KeyS := JARCode + JATCode;
          SearchMode := B_GetGeq;
        end;
      B_GetLast :
        begin
          KeyS := JARCode + chr(ord(JATCode)+1);
          SearchMode := B_GetLess;
        end;
    else
      KeyS := JARCode + JATCode + KeyS;
    end; { case }

    UseVariant(F[FNum]);
    Result := Find_Rec(SearchMode,F[FNum], FNum, RecPtr[FNum]^, JMK, KeyS);
    StrPCopy(SearchKey, KeyS);

    if Result = 0 then
      with ToolkitJobTypeRec^ do
      begin
        if (JobMisc^.RecPFix = JARCode) and (JobMisc^.SubType = JATCode) then
        begin
          FillChar(ToolkitJobTypeRec^, Sizeof(ToolkitJobTypeRec^), 0);
          JTypeCode := JobMisc^.JobTypeRec.JobType;
          JTypeDesc := JobMisc^.JobTypeRec.JTypeName;
        end
        else
          Result := 9;
      end;

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
      {$IFDEF WIN32}
      begin
        UseVariant(F[FNum]);
        If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,JMK,Fnum,SilentLock,Locked)) then
          Result:=0;
        // If not locked and user hits cancel return code 84
        if (Result = 0) and not Locked then
          Result := 84;
      end;
      {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,JMK,Fnum,SilentLock,Locked));
      {$ENDIF}

  end; {If Result=0..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(126,Result);

end; { EX_GETJOBTYPE }

FUNCTION EX_STOREJOBEMPLOYEE(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHPATH   :  SMALLINT;
                             SEARCHMODE   :  SMALLINT) : SMALLINT;
Const
  Fnum   =  JMiscF;
Var
  ExEmpRec    :  ^TBatchEmplRec;
  KeyS        :  Str255;
  TmpMode     :  SmallInt;

Begin
  LastErDesc:='';
  If TestMode Then Begin
    ExEmpRec:=P;
    ShowMessage('Ex_StoreJobEmployee:' + #10#13 +
                'P^.EmpCode: ' + ExEmpRec^.EmpCode + #10#13 +
                'PSize: ' + IntToStr(PSize) + #10#13 +
                'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  TmpMode:=SearchMode;
  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchEmplRec)) then
  Begin

    ExEmpRec:=P;

    ExEmpRec^.EmpCode := UpperCase(ExEmpRec^.EmpCode);
    ExEmpRec^.CC := LJVar(ExEmpRec^.CC, 3);
    ExEmpRec^.Dep := LJVar(ExEmpRec^.Dep, 3);

    if JBCostOn then
      Result:=TkEmpToEmp(ExEmpRec^,SearchMode, SearchPath)
    else
      Result := NoJobErr;


  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(167,Result);

end; {Ex_StoreJobEmployee Func..}

{function ValidType(ACat, AType : Char) : Boolean;

const
   ValidTypes : Array[1..10, 1..4] of Boolean =
                  (//   R      O      M      L
                     (True,  False, False, False), //Sales              'A'
                     (False, False, False, True),  //Time               'T'
                     (False, True,  True,  True),  //Disbursement       'D'
                     (False, True,  True,  True),  //NRDisbursement     'N'
                     (False, False, True,  False), //Stock Issues       'I'
                     (False, True,  False, False), //Overheads          'O'
                     (True,  False, False, False), //Receipts           'R'
                     (False, True,  True,  True),  //WIP                'W'
                     (True,  False, False, False), //Retentions SL      'S'
                     (True,  False, False, False)  //Retentions PL      'P'
                     );
var
  c, t : integer;
begin
  c := Pos(ACat, 'ATDNIORWSP');
  t := Pos(AType, 'ROML');

  if (c = 0) or (t = 0) then
    Result := False
  else
    Result := ValidTypes[c, t];
end; }

function ValidType(ACat, AType : Char) : Boolean;
var
 c, t : integer;
 PossSet : Set of Byte;
 Default : Byte;
begin
   c := Pos(ACat, 'ATDNIORWSP'#11#12#13#14#15#16#17);
   t := Pos(AType, 'ROML');
   Case t of
     1  :  Begin  {Revenue = Revenue,Receipts,Sales Ret,Purch Ret,Deductions Sales Apps, Purc Apps}
             PossSet:=[1,7,9,10,14,15,16,17];
             Default:=2;
           end;
     2  :  Begin  {Overheads = Disbursments, Non Rec Disb, Overheads,WIP, OverHeads 2}
             PossSet:=[3,4,6,8,13];
             Default:=8;
           end;
     3  :  Begin  {Materials= Disbursments, Non Rec Disb,,Materials, WIP, Materials 2}
             PossSet:=[3,4,5,8,12];
             Default:=6;
           end;
     else  Begin  {Labour = Disbursments, Non Rec Disb,Labour , WIP, Sub contrcat labour}
             PossSet:=[2,3,4,8,11];
             Default:=2;
           end;

   end; {Case..}

   Result := c in PossSet;

end;

function TkAnalToEntAnal(ExJAnalRec  :  TBatchJobAnalRec;
                         SearchMode  : SmallInt) : Integer;
Const
  Fnum   =  JMiscF;

  AnalTypeSet = ['R','O','M','L'];
  AnalCatSet  = ['A','D','I','R','S','T','N','O','W','P', #11..#17];
  AnalLineSet = ['N','F','M','L','D', #5..#17];

Var
  KeyChk,
  KeyS        :  Str255;
  TmpMode     :  SmallInt;
  ValidHed,
  ValidCheck  : Boolean;
  Stat        : Integer;
  SaveSearchMode : SmallInt;
Begin
  Result := 0;
  SaveSearchMode := 0;
  //Check code isn't blank
  ValidCheck := Trim(ExJAnalRec.JAnalCode) <> '';
  GenSetError(ValidCheck,30001,Result,ValidHed);

  if Result = 0 then
  begin
    //Check analysis type
    ValidCheck := ExJAnalRec.JAnalType in AnalTypeSet;
    GenSetError(ValidCheck,30002,Result,ValidHed);
  end;

  if Result = 0 then
  begin
    //Check Analysis category
    ValidCheck := ExJAnalRec.JAnalCatry in AnalCatSet;
    GenSetError(ValidCheck,30003,Result,ValidHed);
  end;

  if Result = 0 then
  begin
    //Check Line type
    ValidCheck := ExJAnalRec.LineType in AnalLineSet;
    GenSetError(ValidCheck,30004,Result,ValidHed);
  end;

  if Result = 0 then
  begin
    //Check WIP GL Code
    ValidCheck:=(ExJAnalRec.WIPNomCode <> 0) and (CheckRecExsists(Strip('R',[#0],FullNomKey(ExJAnalRec.WIPNomCode)),NomF,NomCodeK));
    GenSetError(ValidCheck,30005,Result,ValidHed);
  end;

  if Result = 0 then
  begin
    //Check PL GL Code
    ValidCheck:=(ExJAnalRec.PLNomCode <> 0) and (CheckRecExsists(Strip('R',[#0],FullNomKey(ExJAnalRec.PLNomCode)),NomF,NomCodeK));
    GenSetError(ValidCheck,30006,Result,ValidHed);
  end;

  if (Result = 0) and (ExJAnalRec.UpliftP <> 0) then
  begin
    //Check PL GL Code
    ValidCheck:=(ExJAnalRec.UpliftGL <> 0) and (CheckRecExsists(Strip('R',[#0],FullNomKey(ExJAnalRec.UpliftGL)),NomF,NomCodeK));
    GenSetError(ValidCheck,30007,Result,ValidHed);
  end;

  if Result = 0 then
  begin
    ValidCheck := ExJAnalRec.CISTaxRate in [#0, 'C','T'];
    GenSetError(ValidCheck,30008,Result,ValidHed);
  end;

  if Result = 0 then
  begin
    ValidCheck := ValidType(ExJAnalRec.JAnalCatry, ExJAnalRec.JAnalType);
    GenSetError(ValidCheck,30009,Result,ValidHed);
  end;

  if Result = 0 then
  begin
    //Check whether code already exists
    KeyChk:=JARCode+JAACode;
    KeyS:=ExJAnalRec.JAnalCode;

    KeyS:=LJVar(UpperCase(KeyS),JobCodeLen);

    KeyS:=KeyChk+KeyS;

    Stat:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

    SaveSearchMode := SearchMode;

    If (SearchMode=CheckMode) or (SearchMode=ImportMode) then
    begin
      If (Stat = 0) then
        SearchMode:=B_Update
      else
        SearchMode:=B_Insert;
    end;


    if SearchMode = B_Update then
      GenSetError((Stat = 0),4,Result,ValidHed)
    else
    if SearchMode = B_Insert then
    begin
      ResetRec(Fnum);
      GenSetError((Stat <> 0),5,Result,ValidHed);
    end
    else
      Result := 30000;
  end;

  if (Result = 0) and (SaveSearchMode <> CheckMode) then
  begin
    //Copy record to entrprse record
    CopyTkJobAnalysisToExJobAnalysis(JobMisc^.JobAnalRec, ExJAnalRec);
    JobMisc^.RecPfix := JARCode;
    JobMisc^.SubType := JAACode;
    Case SearchMode of
      B_Insert  :  Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);
      B_Update  :  Result:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);
      else         Result:=30000;
    end;

  end;
end;

FUNCTION EX_STOREJOBANALYSIS(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHPATH   :  SMALLINT;
                             SEARCHMODE   :  SMALLINT) : SMALLINT;
Var
  ExJAnalRec  :  ^TBatchJobAnalRec;
Begin
  LastErDesc:='';
  If TestMode Then Begin
    ExJAnalRec :=P;
    ShowMessage('Ex_StoreJobAnalysis:' + #10#13 +
                'P^.JAnalCode: ' + ExJAnalRec^.JAnalCode + #10#13 +
                'PSize: ' + IntToStr(PSize) + #10#13 +
                'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchJobAnalRec)) then
  Begin

    ExJAnalRec:=P;

    ExJAnalRec^.JAnalCode := UpperCase(ExJAnalRec^.JAnalCode);

    if JBCostOn then
      Result := TkAnalToEntAnal(ExJAnalRec^, SearchMode)
    else
      Result := NoJobErr;

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(168,Result);


end;

function TkJobTypeToEntJobType(TypeRec  :  TBatchJobTypeRec;
                         SearchMode  : SmallInt) : Integer;
Const
  Fnum   =  JMiscF;

Var
  KeyChk,
  KeyS        :  Str255;
  TmpMode     :  SmallInt;
  ValidHed,
  ValidCheck  : Boolean;
  Stat        : Integer;
Begin
  Result := 0;
  //Check code isn't blank
  ValidCheck := Trim(TypeRec.JTypeCode) <> '';
  GenSetError(ValidCheck,30001,Result,ValidHed);

  if Result = 0 then
  begin
    //Check whether code already exists
    KeyS:=JARCode + JATCode + LJVar(UpperCase(TypeRec.JTypeCode), JobCodeLen);

    Stat:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

    if SearchMode = B_Update then
      GenSetError((Stat = 0),4,Result,ValidHed)
    else
    if SearchMode = B_Insert then
    begin
      ResetRec(Fnum);
      GenSetError((Stat <> 0),5,Result,ValidHed);
    end
    else
      Result := 30000;
  end;

  if Result = 0 then
  begin
    JobMisc^.RecPfix := JARCode;
    JobMisc^.SubType := JATCode;

    JobMisc^.JobTypeRec.JobType := LJVar(UpperCase(TypeRec.JTypeCode), JobCodeLen);
    JobMisc^.JobTypeRec.JTypeName := TypeRec.JTypeDesc;
    JobMisc^.JobTypeRec.JTNameCode := FullAnalDesc(TypeRec.JTypeDesc);

    Case SearchMode of
      B_Insert  :  Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);
      B_Update  :  Result:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);
      else         Result:=30000;
    end;

  end;
end;




FUNCTION EX_STOREJOBTYPE(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT) : SMALLINT;
var
  TypeRec : ^TBatchJobTypeRec;

begin
  LastErDesc:='';
  If TestMode Then Begin
    TypeRec :=P;
    ShowMessage('Ex_StoreJobType:' + #10#13 +
                'P^.JTypeCode: ' + TypeRec^.JTypeCode + #10#13 +
                'PSize: ' + IntToStr(PSize) + #10#13 +
                'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchJobTypeRec)) then
  Begin

    TypeRec:=P;
    if JBCostOn then
      Result := TkJobTypeToEntJobType(TypeRec^, SearchMode)
    else
      Result := NoJobErr;

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(169,Result);

end;

Procedure CopyTKJRateToExJRate(var JobRate : EmplPayType;
                           const ExJRate   :  TBatchJobRateRec);
begin
  With ExJRate do
  begin
    //PR: 11/07/2012 ABSEXCH-12532 EmpCode is populated differently depending upon the type of
    //rate.  Global rates contain FullNomKey(-1); Employee rates contain employee code padded to 6 spaces;
    //Job rates contain job code padded to 10 spaces.

    //Blank out EmpCode before populating it
    FillChar(JobRate.EmpCode, SizeOf(JobRate.EmpCode), 0);

    If (EmptyKey(JEmpCode,AccLen)) or (JEmpCode = FullNomKey(-1)) then //Global rate
      JobRate.EmpCode := FullNomKey(PRateCode)
    else
    begin
    {$IFDEF COMTK}
      if RecType = JBPCode then//Employee - pad to 6 chars
        JobRate.EmpCode := LJVar(JEmpCode, AccLen)
      else  //Job - pad to 10 chars
        JobRate.EmpCode := LJVar(JEmpCode, JobCodeLen);
    {$ELSE}
        JobRate.EmpCode := LJVar(JEmpCode, AccLen);
    {$ENDIF}
    end;

    JobRate.EmplCode := FullJBCode(JobRate.EmpCode, ExJRate.CostCurr, ExJRate.JRateCode);
    JobRate.ECodeNdx := JRateDesc;

    JobRate.EStockCode := JRateCode;
    JobRate.PayRDesc := JRateDesc;
    JobRate.EAnalCode := JAnalCode;
    JobRate.CostCurr := CostCurr;
    JobRate.Cost := Cost;
    JobRate.ChargeCurr := ChargeCurr;
    JobRate.ChargeOut := ChargeRate;
    JobRate.PayRRate := PayrollCode;
    JobRate.PayRFact := PayFactor;
    JobRate.PayRRate := PayRate;
  end; {with..}
end; {func..}

function TkTimeRateToExTimeRate(RateRec : TBatchJobRateRec; SearchMode : SmallInt) : integer;
Const
  Fnum   =  JCtrlF;
Var
  KeyChk,
  KeyS        :  Str255;
  ValidHed,
  ValidCheck  : Boolean;
  Stat : Integer;
  SaveSearchMode : SmallInt;
  EmpRate : Boolean;

  //PR: 04/11/2009 Added for fix to storing Job/Employee rates with Cost Currency different to Global Rate
  TmpStat,
  TmpKPath,
  Res :  Integer;

  TmpRecAddr
           :  LongInt;
Begin
  //Check code isn't blank
  Result := 0;
  ValidCheck := Trim(RateRec.JRateCode) <> '';
  GenSetError(ValidCheck,30001,Result,ValidHed);
  SaveSearchMode := 0;
  if Result = 0 then
  begin
    //Check analysis code exists
    ValidCheck:= (RateRec.JAnalCode <> '') and (CheckRecExsists(JARCode + JAACode + RateRec.JAnalCode,JMiscF,0));
    GenSetError(ValidCheck,30002,Result,ValidHed);

    if ValidCheck then
    begin
      ValidCheck := (JobMisc^.JobAnalRec.JAType in [2, 4]); //labour & overheads only
      GenSetError(ValidCheck,30007,Result,ValidHed);
    end;
  end;

  if Result = 0 then
  begin
    //Cost currency
    If (ExSyss.MCMode) then
      ValidCheck := (RateRec.CostCurr >= 1) and (RateRec.CostCurr <= CurrencyType)
    else
      ValidCheck := RateRec.CostCurr = 0;

    GenSetError(ValidCheck,30004,Result,ValidHed);
  end;


  if Result = 0 then
  begin
    //Check employee code exists or is empty      //PR: 20/11/2009 Check for global code
    ValidCheck:=(Trim(RateRec.JEmpCode) = '') or (Copy(RateRec.JEmpCode, 1, 4) = FullNomKey(PRateCode));
    if not ValidCheck then
      EmpRate := (Trim(RateRec.JEmpCode) <> '') and
      {$IFDEF COMTK}
          ((RateRec.RecType = JBPCode) and CheckRecExsists(JARCode + JAECode + LJVar(RateRec.JEmpCode, AccLen),JMiscF,0)) or
           ((RateRec.RecType = JBECode) and CheckRecExsists(LJVar(RateRec.JEmpCode,JobCodeLen), JobF, 0))
      {$ELSE}
           CheckRecExsists(JARCode + JAECode + RateRec.JEmpCode,JMiscF,0)
      {$ENDIF}
    else
      EmpRate := False;

    ValidCheck := ValidCheck or EmpRate;
    GenSetError(ValidCheck,30003,Result,ValidHed);

{    if EmpRate then
    begin
      //Check that we have a global rate for this code
      KeyChk:=JBRCode+JBECode;
      KeyS:=FullJBCode(FullNomKey(PRateCode),RateRec.CostCurr,RateRec.JRateCode);
      KeyS:=KeyChk+KeyS;

      ValidCheck := CheckExsists(KeyS, JCtrlF, 0);
      GenSetError(ValidCheck, 30006, Result, ValidHed);
    end;}

    //PR: 04/11/2009 Fix to storing Job/Employee rates with Cost Currency different to Global Rate
    if EmpRate then
    begin
      //Check that we have a global rate for this code
      KeyS:=JBRCode+JBECode + FullJACode(FullNomKey(PRateCode)) + LJVar(RateRec.JRateCode,StkKeyLen);
      KeyChk := KeyS;


      //Save position in Job Ctrl file
      TmpKPath:=GetPosKey;
      TmpStat:=Presrv_BTPos(JCtrlF,TmpKPath,F[JCtrlF],TmpRecAddr,BOff,BOff);


      //Find record - no need to preserve existing contents as we replace them from the tk record below
      Res := Find_Rec(B_GetGEq, F[JCtrlF], JCtrlF, RecPtr[JCtrlF]^, 0, KeyS);

      //Restore position in Job Ctrl file
      TmpStat:=Presrv_BTPos(JCtrlF,TmpKPath,F[JCtrlF],TmpRecAddr,BOn,BOff);

      //Check that we have a global rate record
      ValidCheck := (Res = 0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));
      GenSetError(ValidCheck, 30006, Result, ValidHed);
    end;


  end;



  if Result = 0 then
  begin
    //Charge currency
    If (ExSyss.MCMode) then
      ValidCheck := (RateRec.ChargeCurr >= 1) and (RateRec.ChargeCurr <= CurrencyType)
    else
      ValidCheck := RateRec.ChargeCurr = 0;

    GenSetError(ValidCheck,30005,Result,ValidHed);
  end;

  if Result = 0 then
  begin
    ValidCheck := (RateRec.PayFactor >= 0) and (RateRec.PayFactor <= 99);
    GenSetError(ValidCheck,30008,Result,ValidHed);
  end;

  if Result = 0 then
  begin
    ValidCheck := (RateRec.PayRollCode >= 0) and (RateRec.PayRollCode <= 99);
    GenSetError(ValidCheck,30009,Result,ValidHed);
  end;

  if Result = 0 then
  begin

    RateRec.JRateCode:=LJVar(Uppercase(RateRec.JRateCode), 10);
    RateRec.JEmpCode:=LJVar(Uppercase(RateRec.JEmpCode), 10);
    RateRec.JAnalCode := LJVar(Uppercase(RateRec.JAnalCode), 10);

    {* If Global Rate, EmpCode is set as :- *}
    //PR: 12/10/2010 If global rate, JempCode may already be set to FullNomKey(-1) so check
    If (Trim(RateRec.JEmpCode) = ''){$IFDEF IMPV6} or (Copy(RateRec.JEmpCode, 1, 4) = FullNomKey(-1)) {$ENDIF}then
    begin
      KeyChk:=JBRCode+JBECode;
      RateRec.JEmpCode:=FullNomKey(PRateCode);
    end
    else
    begin {by Employee + RateCode }
    {$IFNDEF COMTK}
      KeyChk:=JBRCode+JBPCode;
    {$ELSE}
      KeyChk:=JBRCode+RateRec.RecType;   //For comtk can have job rates as well as employee
    {$ENDIF}
    end;

    //PR: 20/11/2009 If currency has been changed then we can't use it to find original record for updating
    {$IFDEF COMTK}
    if SearchMode = B_Insert then
      KeyS := KeyChk + FullJBCode(RateRec.JEmpCode,RateRec.CostCurr,RateRec.JRateCode)
    else
      KeyS := KeyChk + FullJBCode(RateRec.JEmpCode,RateRec.OriginalCostCurr,RateRec.JRateCode);
    {$ELSE}
    KeyS := KeyChk + FullJBCode(RateRec.JEmpCode,RateRec.CostCurr,RateRec.JRateCode);
    {$ENDIF}

    Stat:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

    SaveSearchMode := SearchMode;

    If (SearchMode=CheckMode) or (SearchMode=ImportMode) then
    begin
      If (Stat = 0) then
        SearchMode:=B_Update
      else
        SearchMode:=B_Insert;
    end;


    if SearchMode = B_Update then
      GenSetError((Stat = 0),4,Result,ValidHed)
    else
    if SearchMode = B_Insert then
    begin
      ResetRec(Fnum);
      GenSetError((Stat <> 0),5,Result,ValidHed);
    end
    else
      Result := 30000;
  end;

  if (Result = 0) and (SaveSearchMode <> CheckMode) then
  begin
    JobCtrl^.RecPfix := KeyChk[1];
    JobCtrl^.SubType := KeyChk[2];

    CopyTkJRateToExJRate(JobCtrl^.EmplPay, RateRec);

    Case SearchMode of
      B_Insert  :  Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);
      B_Update  :  Result:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);
      else         Result:=30000;
    end;

  end;

  {SS 15/06/2016 2016-R3 
   ABSEXCH-13693:Importer doesn't validate Global Time Rate record import where the same Stock Code already exists and vice versa.
   - Validation for the Stock.}
  if Result = 0 then
  begin
    KeyS := FullStockCode(RateRec.JRateCode);
    ValidCheck := not CheckRecExsists(KeyS,StockF,StkCodeK);
    GenSetError(ValidCheck,30010,Result,ValidHed);
  end;

end;



FUNCTION EX_STOREJOBTIMERATE(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHPATH   :  SMALLINT;
                             SEARCHMODE   :  SMALLINT) : SMALLINT;
var
  RateRec : ^TBatchJobRateRec;

begin
  LastErDesc:='';
  If TestMode Then Begin
    RateRec :=P;
    ShowMessage('Ex_StoreJobTimeRate:' + #10#13 +
                'P^.JRateCode: ' + RateRec^.JRateCode + #10#13 +
                'PSize: ' + IntToStr(PSize) + #10#13 +
                'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchJobRateRec)) then
  Begin

    RateRec:=P;

    RateRec^.JRateCode := UpperCase(RateRec^.JRateCode);
    RateRec^.JEmpCode := UpperCase(RateRec^.JEmpCode);
    RateRec.JAnalCode := Uppercase(RateRec.JAnalCode);

    if JBCostOn then
      Result := TkTimeRateToExTimeRate(RateRec^, SearchMode)
    else
      Result := NoJobErr;

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(170,Result);

end;


FUNCTION EX_SETJAINVOICEDFLAG(TRANSREF        : PCHAR;
                              LINENO          : LONGINT;
                              INVOICEREF      : PCHAR;
                              WIPTRANSFERRED  : WORDBOOL;
                              CHARGEOUT       : DOUBLE;
                              CHARGEOUTCURR   : LONGINT) : SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}
const
  FNum = JDetlF;
  Idx = 5;

  FNum2 = InvF;
  Idx2 = 2;
VAR
  JARec : JobActType;
  Res : SmallInt;
  KeyS, KeyChk : Str255;
  Locked : Boolean;
begin
  KeyS := StrPas(TransRef);
  Res := Find_Rec(B_GetGEq, F[FNum2], FNum2, RecPtr[FNum2]^, Idx2, KeyS);

  if Res = 0 then
  begin
    KeyS := JBRCode + JBECode + FullNomKey(Inv.FolioNum) + FullNomKey(LineNo) + '!';
    Result := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, Idx, KeyS);

    if Result = 0 then
    begin
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,Idx,Fnum,SilentLock,Locked)) then
        Result:=0;

          // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
          Result := 84;

      if Result = 0 then
      begin
        JobDetl.JobActual.Invoiced := True;
        JobDetl.JobActual.InvRef := StrPas(InvoiceRef);
        if ChargeOut > 0 then
        begin
          JobDetl.JobActual.Charge := ChargeOut;
          JobDetl.JobActual.CurrCharge := ChargeOutCurr;
        end;
        JobDetl.JobActual.Reversed := WordBoolToBool(WIPTransferred);

        Result := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, Idx);

      end;
    end
    else
      Result := 30002;
  end
  else
    Result := 30001;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(170,Result);


end;

//
// MH 03/11/06: Added to allow a broken Job Tree to be repaired for a customer without a backup
//
//   0      AOK
//   1001   Unknown Error
//   1002   Job Code does not exist
//   1003   Error locking Job/Contract
//   2000+  Btrieve error updating Job/Contract
//
FUNCTION FUNC612(SECPARAM : LONGINT; S1 : ShortString) : SMALLINT; STDCALL; EXPORT;
Var
  KeyS   : Str255;
  Locked : Boolean;
  Res : SmallInt;
Begin // FUNC612
  Result := 1001;

  // Parameter to stop just anyone using this function - no riff raff allowed
  If (SecParam = 73836) Then
  Begin
    // Check the Job Exists
    KeyS := FullJobCode(S1);
    Res := Find_Rec(B_GetEq, F[JobF], JobF, RecPtr[JobF]^, JobCodeK, KeyS);
    If (Res = 0) Then
    Begin
      // Lock it
      Locked := False;
      If GetMultiRec(B_GetDirect, B_SingLock, KeyS, JobCodeK, JobF, SilentLock, Locked) Then
        Res :=0;
      // If not locked and user hits cancel return code 84
      If (Res = 0) And (Not Locked) Then
          Res := 84;

      If (Res = 0) Then
      Begin
        // Clear the current parent to move it to the root
        JobRec^.JobCat := FullJobCode('');

        // Update the job
        Res := Put_Rec(F[JobF], JobF, RecPtr[JobF]^, JobCodeK);
        If (Res = 0) Then
          Result := 0
        Else
          Result := 2000 + Res;
      End // If (Res = 0)
      Else
        Result := 1003; // Error locking Job/Contract
    End
    Else
      Result := 1002; // Job Code does not exist
  End; // If (SecParam = 73836)
End; // FUNC612

end.

