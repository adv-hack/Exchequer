unit BtrListO;

{ markd6 12:58 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Messages, SysUtils, Windows, GlobVar,
     VarConst, ExBtTh1U, CompInfo;

Const
  MaxListItems = 10;

  { Keep in sync with Excel Add-In source code }
  ErrNom       = 511; { Invalid Nominal/General Ledger Code }
  ErrYear      = 512; { Invalid Year }
  ErrPeriod    = 513; { Invalid Period }
  ErrCcy       = 514; { Invalid Currency Number }
  ErrCust      = 515; { Invalid Customer Code }
  ErrComp      = 516; { Invalid Company Code or Logon Skipping }
  ErrFromGL    = 517; { Invalid From GL Code }
  ErrToGL      = 518; { Invalid To GL Code }
  ErrCC        = 519; { Invalid Cost Centre Code }
  ErrDept      = 520; { Invalid Department Code }
  ErrJobCode   = 521; { Invalid Job Code }
  ErrJobAnal   = 522; { Invalid Job Analysis }
  ErrStock     = 523; { Invalid Stock Code }
  ErrPrice     = 524; { Invalid Price Band }
  ErrValue     = 525; { Invalid Value }
  ErrSupp      = 526; { Invalid Supplier }
  ErrLoc       = 527; { Invalid Location }
  ErrPermit    = 528; { Permission Denied - User not authorised to use this function }
  {ErrDocType   = 529; { Excel - Invalid Document Type }
  ErrBudget    = 530; { Invalid Budget Type }
  {ErrTotType   = 531; { Excel - Invalid Total Type }
  ErrRateType  = 532; { Invalid Rate Type }
  {ErrPostCodd  = 533; { Excel - Invalid Posted/Committed Flag }
  ErrStartDate = 534; { Invalid Start Date }
  ErrEndDate   = 535; { Invalid End Date }
  ErrAccCode   = 536; { Invalid Account Code }
  ErrUnknown   = 537; { Unknown Error }
  ErrUserAbort = 538; { Aborted By User }
  ErrAgeDate   = 539; { Invalid Ageing Date }
  ErrQuantity  = 540; { Invalid Quantity }
  ErrAgeUnits  = 541; { Invalid Aging Units }
  ErrAgeInt    = 542; { Invalid Ageing Interval }
  ErrLineNo    = 543; { Invalid Line Number }
  // 544              { EntAddNomTxfrLines - Invalid GL List }
  // 545              { EntAddNomTxf      pb rLines - Invalid Description List }
  // 546              { EntAddNomTxfrLines - Invalid Currency List }
  // 547              { EntAddNomTxfrLines - Invalid Amount }
  // 548              { EntAddNomTxfrLines - Invalid Amount List }
  // 549              { EntAddNomTxfrLines - Total Not Zero }
  ErrCCList    = 550; { Invalid Cost Centre List }
  ErrDeptList  = 551; { EntAddNomTxfrLines - Invalid Department List }
  ErrJobList   = 552; { EntAddNomTxfrLines - Invalid Job Code List }
  ErrAnalList  = 553; { EntAddNomTxfrLines - Invalid Analysis Code List }
  // 554              { EntAddNomTxfrLines - Invalid Rate }
  // 555              { EntAddNomTxfrLines - Invalid Rate List }
  ErrAltCode   = 556; { Invalid Alternate Stock Code }
  ErrNoROPrice = 557; { No prices stored on Alt Stk Code record }
  ErrLineType  = 558; { Invalid Line Type }
  ErrVATCode   = 559; { Invalid VAT Code }
  ErrRevDate   = 560; { Invalid Revised End Date }
  ErrStkLocDis = 561; { Stock/Location Field Disabled }
  ErrNoSaveMod = 562; { No OLE Save Functions Release Code }
  ErrJobClosed  = 563; { Job Closed }
  ErrEmplCode  = 564; { Invalid Employee Code }
  ErrTimeRate  = 565; { Invalid Time-Rate Code }
  ErrTimeRateList   = 566; { Invalid Time-Rate List }
  ErrNarrList       = 567; { Invalid Narrative List }
  ErrHoursList      = 568; { Invalid Hours List }
  ErrChargeRateList = 569; { Invalid Charge Rate List }
  ErrHours          = 570; { Invalid Hours - must be > 0.0 }
  ErrCostCcyList    = 571; { Invalid Cost Currency List }
  ErrHourlyCostList = 572; { Invalid Hourly Cost List }
  ErrEmplCertExp    = 573; { Employee Certifacte Expired }
  ErrCISDeductType  = 574; { Invalid CIS Deduction Type }
  ErrDeliveryMode   = 575; { Invalid Statement/Invoice Delivery Mode }
  ErrDate           = 576; { EntAddNOMVATLines: Invalid Date }
  ErrHeaderVATFlag  = 577; { EntAddNOMVATLines: Invalid Header VAT Flag }
  ErrVATAmount      = 578; { EntAddNOMVATLines: Invalid VAT Amount }
  ErrVATAmountList  = 579; { EntAddNOMVATLines: Invalid VAT Amount List }
  ErrVATFlagList    = 580; { EntAddNOMVATLines: Invalid Line VAT Flag List }
  ErrVATCodeList    = 581; { EntAddNOMVATLines: Invalid Line VAT Code List }
  ErrIncVATCodeList = 582; { EntAddNOMVATLines: Invalid Line Inclusive VAT Code List }
  ErrLineVATFlag    = 583; { EntAddNOMVATLines: Invalid Line VAT Flag }
  ErrUserFieldsList = 584; { EntJCAddJob/EntAddTimesheetUDFWithCosts: Invalid User Fields List }
  ErrAppsValsBasis      = 585; // Invalid Apps & Vals Basis
  ErrAppsValsContract   = 586; // Invalid Apps & Vals Contract OurRef
  ErrJobTypeCode    = 587; { Invalid JobTypeCode }   // SSK 29/08/2016 R3 ABSEXCH-14589: added to return JobTypeName
  ErrInactiveCC     = 588; { Inactive Cost Centre Code }  // PL 30/08/2016 R3 ABSEXCH-15689 : Added code to check inactive CC / Dept
  ErrInactiveDept   = 589; { Inactive Department Code }   // PL 30/08/2016 R3 ABSEXCH-15689 : Added code to check inactive CC / Dept
  ErrEmployeeClosed = 590; { Employee Closed }   // MH 02/01/2018 2018-R1 ABSEXCH-19552: Added check on Employee Status
  ErrTraderAnonymised = 591; { Anonymised account can not be edited } //HV 26/06/2018 2017R1.1 ABSEXCH-20793: provided support for entry in anonymisation control center if user changes Account Status to from OLE.

  ErrInternalErr    = 599; { EntAddJobWithAnalysisBudgets: See returned error string }
  ErrRecLock   = 600; { Record Locked }
  ErrBtrBase   = 600; { Base Error for btrieve - 601 -> }


Type
  TBtrListO = Class(TObject)
  Private
    FCompListChanged : TNotifyEvent;

    Procedure SetCompList(Value : TNotifyEvent);
    Procedure UpDisp;
  Public
    Companies : TList;
    BaseUser  : PtrPassEntryType;
    SBSDoor   : PtrBool;

    Constructor Create;
    Destructor  Destroy; OverRide;

    Function OpenCompany (CompCode : ShortString; Var CompObj : TCompanyInfo) : Boolean;
    Function OpenSaveCompany (CompCode : ShortString; Var CompObj : TCompanyInfo) : LongInt;
    Function FindCompany (Const CompCode : ShortString; Var CompObj : TCompanyInfo) : Boolean;
    Function ValidCompany(Const CompCode : ShortString;Var CompPath : ShortString) : Boolean;

    Property OnCompListChanged : TNotifyEvent read FCompListChanged write SetCompList;
  End; { TBtrListO }

Var
  OpenComp, CacheHit  : LongInt;

implementation

Uses BtrvU2, BtKeys1U, EntServF, OleServr, HelpSupU, AuditIntf, History;

{ Creates and Initialises the Object }
Constructor TBtrListO.Create;
Begin
  Inherited Create;

  Companies := TList.Create;

  { Init base user details record }
  GetMem (BaseUser, SizeOf (BaseUser^));
  FillChar (BaseUser^, SizeOf(BaseUser^), #0);

  GetMem (SBSDoor, SizeOf (SBSDoor^));
  SBSDoor^ := False;
End;


{ Shuts down the object }
Destructor TBtrListO.Destroy;
Var
  CompObj : TCompanyInfo;
Begin
  If Assigned(Companies) Then Begin
    While (Companies.Count > 0) Do Begin
      { Delete all company info from list before destroying }
      CompObj := TCompanyInfo(Companies.Items[0]);
      Companies.Delete (0);
      CompObj.Destroy;
    End; { While }
    Companies.Free;
  End; { If }

  FreeMem (BaseUser, SizeOf (BaseUser^));

  FreeMem (SBSDoor, SizeOf (SBSDoor^));

  UpDisp;

  Inherited Destroy;
End;


Procedure TBtrListO.SetCompList(Value : TNotifyEvent);
Begin
  FCompListChanged := Value;

  UpDisp;
End;


{ Called to change companies - returns true if change made ok - handle to }
{ Btrieve object passed back in CompObj parameter                               }
Function TBtrListO.OpenCompany (CompCode : ShortString; Var CompObj : TCompanyInfo) : Boolean;
Var
  CompPath : ShortString;
Begin
  Result  := False;

  CompObj := Nil;

  Inc(OpenComp);    { Update performance stats }

  { Check we aren't in skiplogon mode }
  If (Not SkipLogon) Then Begin
    { Convert Company Code to UpperCase }
    CompCode := UpperCase(CompCode);

    { look in current list of btrieve objects for company }
    If Not FindCompany (CompCode, CompObj) Then Begin
      { Company not already loaded - check its an AOK company code }
      If ValidCompany(CompCode, CompPath) Then Begin
        { Got a valid company thats not in the list }
        If (Companies.Count >= MaxListItems) Then Begin
          { Need to close the last company in the list }
          CompObj := TCompanyInfo(Companies.Items[Pred(MaxListItems)]);
          CompObj.Destroy;

          Companies.Delete (Pred(MaxListItems));
        End; { If }

        { Set the drive to point to the data }
        SetDrive := CompPath;

        { need to add a new company wotsit }
        CompObj := TCompanyInfo.Create(BaseUser, SBSDoor);
        With CompObj Do Begin
          CompanyCode := Trim(CompCode);
          CompanyName := Company^.CompDet.CompName;
          CompanyPath := Trim(Company^.CompDet.CompPath);
        End; { With }

        // MH 12/02/2013 v7.0.2 ABSEXCH-13580: Extended OLE Server to support login via memory map,
        //                                     SkipLogin is now only set if not using the memory map
        If CompObj.LoginOK (SkipLogon) Then
        Begin
          { Logged in OK }
          Companies.Insert (0, CompObj);

          Result := True;
        End { If }
        Else Begin
          { Failed to login }
          CompObj.Destroy;
          Result := False;
        End; { Else }
      End; { If }
    End { If }
    Else Begin
      { Company already loaded }
      Inc(CacheHit);
      Result := True;
    End; { Else }

    If Result Then
    Begin
      // Copy company system records into global records
      CompObj.CopySys;

      AuditSystemInformation.asApplicationDescription := 'Exchequer OLE Server';
      AuditSystemInformation.asApplicationVersion := CurrVersion_OLE;
      AuditSystemInformation.asExchequerUser := CompObj.UserId;
      AuditSystemInformation.asCompanyDirectory := CompObj.CompanyPath;
      AuditSystemInformation.asCompanyName := Trim(CompObj.CompanyName);
    End; // If Result
  End; { With }

  { Update info on window (if turned on) }
  UpDisp;
End;


Function TBtrListO.OpenSaveCompany (CompCode : ShortString; Var CompObj : TCompanyInfo) : LongInt;
Begin { OpenSaveCompany }
  Result := 0;

  { Open Company }
  If OpenCompany (CompCode, CompObj) Then Begin
    { Check for Save rights }
    If Not Check_ModRel(9, BOn) Then
      Result := ErrNoSaveMod;
  End { If OpenCompany (CompCode, CompObj) }
  Else
    { Cannot load company }
    Result := ErrComp;
End; { OpenSaveCompany }


{ Looks through Companies list to find company data }
Function TBtrListO.FindCompany (Const CompCode : ShortString; Var CompObj : TCompanyInfo) : Boolean;
Var
  I       : Integer;
Begin
  Result := False;

  If (Companies.Count > 0) Then
    For I := 0 To Pred(Companies.Count) Do Begin
      { Get local handle on company info }
      CompObj := TCompanyInfo(Companies.Items[I]);

      If (Trim(CompObj.CompanyCode) = Trim(CompCode)) Then Begin
        { Found Company }
        Result := True;

        { Move to top of list }
        Companies.Move (I, 0);

        { Exit loop }
        Break;
      End; { If }
    End; { For }

  If (Not Result) Then
    CompObj := Nil;
End;


{ Looks up the specified Company Code in the Companies Database and returns the }
{ datapath if it is valid                                                       }
Function TBtrListO.ValidCompany(Const CompCode : ShortString;Var CompPath : ShortString) : Boolean;
Var
  KeyS : Str255;
Begin
  { Load Company Options Record }
  KeyS := FullCompCodeKey(cmCompDet, CompCode);
  Status := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
  Result := StatusOk;

  If Result Then Begin
    CompPath := Trim(Company^.CompDet.CompPath);
  End;
End;


{ Updates the display on the server form }
Procedure TBtrListO.UpDisp;
Begin
  If Assigned(FCompListChanged) Then
    FCompListChanged(Self);
end;

Initialization
  OpenComp := 0;
  CacheHit := 0;
end.
