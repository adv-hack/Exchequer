unit CompInfO;

{$ALIGN 1}

interface

Uses Classes, Dialogs, Controls, Forms, Messages, SysUtils, Windows, GlobVar,QtyBreakVar,
     VarConst, VarRec2U, {ExBtTh1U, } CacheCustAgeing, CacheCCDept, CacheNomCodes,
     OLEBtrO, EntLoggerClass, SQLCallerU, CacheJobCodes, CacheAnalysisCodes,
     SQLTransactionLines, AdoConnect, ExBtTh1u;

Type
  PtrBool          = ^Boolean;
  PtrPassEntryType = ^PassEntryType;

  TCompanyInfo = Class(TObject)
    CompanyCode : String[CompCodeLen];
    CompanyName : String[CompNameLen];
    CompanyPath : String[CompPathLen];

    BaseUser    : PtrPassEntryType; { links to record in BtrListO }
    //UserInfo    : PassEntryType;
    UserInfo    : EntryRecType;
    GotSBSDoor  : PtrBool;

    CompanyBtr  : TdOLEExLocalPtr{TdPostExLocalPtr};

    ClientId    : Integer;

    IsMultiCcy  : Boolean;

  Private
    FAgeingCache : TAccountAgeingCache;
    FCostCentreCache : TCostCentreDepartmentCache;
    FDepartmentCache : TCostCentreDepartmentCache;
    FNominalCodeCache : TNominalCodeCache;
    // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Job Codes and Analysis Codes
    FJobCodeCache : TJobCodeCache;
    FAnalysisCodeCache : TAnalysisCodeCache;
    FSQLCaller : TSQLCaller;
    FLogger : TEntSQLReportLogger;
    FSQLStoredProcedureTransactionLines: TSQLStoredProcedureTransactionLines;

    Function GetUserId : ShortString;
    Function GetAgeingCache : TAccountAgeingCache;
    Function GetCostCentreCache : TCostCentreDepartmentCache;
    Function GetDepartmentCache : TCostCentreDepartmentCache;
    Function GetNominalCodeCache : TNominalCodeCache;
    // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Job Codes and Analysis Codes
    Function GetJobCodeCache : TJobCodeCache;
    Function GetAnalysisCodeCache : TAnalysisCodeCache;
    Function GetSQLCaller : TSQLCaller;
    Function GetLogger : TEntSQLReportLogger;
    Function GetSQLStoredProcedureTransactionLines: TSQLStoredProcedureTransactionLines;
  Public
    Property UserId : ShortString Read GetUserId;
    Property AgeingCache : TAccountAgeingCache Read GetAgeingCache;
    Property CostCentreCache : TCostCentreDepartmentCache Read GetCostCentreCache;
    Property DepartmentCache : TCostCentreDepartmentCache Read GetDepartmentCache;
    Property NominalCodeCache : TNominalCodeCache Read GetNominalCodeCache;
    // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Job Codes and Analysis Codes
    Property JobCodeCache : TJobCodeCache Read GetJobCodeCache;
    Property AnalysisCodeCache : TAnalysisCodeCache Read GetAnalysisCodeCache;
    Property SQLCaller : TSQLCaller Read GetSQLCaller;
    Property Logger : TEntSQLReportLogger Read GetLogger;
    Property SQLStoredProcedureTransactionLines: TSQLStoredProcedureTransactionLines Read GetSQLStoredProcedureTransactionLines;

    Constructor Create (UserDets : PtrPassEntryType; DoorPtr : PtrBool);
    Destructor  Destroy; OverRide;
    //this Function Copy from OLELogin.. Due to used Common Login Dia
    function BtrUserTo431User(ExBtr : TdPostExLocalPtr): EntryRecType;
    function GetLogInRec(LoginCode : Str20;ExBtr : TdPostExLocalPtr): Boolean;
    Function LoginOK (Var SkipLogin : Boolean) : Boolean;
    function LogonCancelWarn(Sender: TObject): Boolean;
    Function DispLogin : Boolean;

    Function CheckSecurity (Const SecNo : LongInt) : Boolean;

    Procedure CopySys;
    Procedure UpdateSys(Const SysFlagNo : Byte);
  End; { TCompanyInfo }

implementation

Uses EntServF, BtrvU2, BtSupU1, Crypto, HelpSupU, APIUtil,
     MemMap,          // Memory Map for sharing data between OLE/COM Servers for Exccel Add-Ins
     SQLUtils, SQLRep_Config,   // Overrideable settings for SQL mods
     ExWrap1U, BTKeys1U, ETDateU, Brand, LoginWar, LoginF, PasswordComplexityConst,
     //PR: 04/07/2012 ABSEXCH-12957
     BudgetHistoryVar,
     // MH 12/02/2013 v7.0.2 ABSEXCH-13580: Extended OLE Server to support login via memory map
     MemoryMap, EntLicence;


Const
  ClientBase = 90;

Var
  NextClientId : TBits;


{ Creates and Initialises the Object }
Constructor TCompanyInfo.Create (UserDets : PtrPassEntryType;
                                 DoorPtr  : PtrBool);
Var
  KeyS : Str255;
  I    : SysRecTypes;
Begin
  Inherited Create;

  // Cache objects are created on demand
  FAgeingCache := NIL;
  FCostCentreCache := NIL;
  FDepartmentCache := NIL;
  FNominalCodeCache := NIL;

  { NOTE: SetDrive is set to the Company Directory at this point }

  { Generate unique client id for btrieve access }
  ClientId := ClientBase + NextClientId.OpenBit;
  NextClientId[ClientId - ClientBase] := True;

  { Create btrieve object }
  New(CompanyBtr, Create(ClientId));
  CompanyBtr.Open_System (1, TotFiles);

  Open_System(MLocF, MLocF);
  Open_System(PWrdF, PWrdF);
  Open_System(SysF, SysF);

  {SS 17/08/2016 2016-R3
  ABSEXCH-14877:EntSuppSalesPrice & EntCustSalesPrice do not respect qty break discounts.} 
  CompanyBtr.Open_System(QtyBreakF,QtyBreakF);

  //PR: 04/07/2012 ABSEXCH-12957
  CompanyBtr.Open_System (BudgetHistoryF, BudgetHistoryF);

  { Take local copy of the base user details pointer for user during the login }
  BaseUser   := UserDets;
  GotSbsDoor := DoorPtr;

  { Init user details record }
  FillChar (UserInfo, SizeOf(UserInfo), #0);

  { Load system records into CompanyBtr }
  With CompanyBtr^ Do Begin

  {SysRecTypes    =  (SysR,VATR,DefR,CurR,CuR2,CuR3,ModRR,GCUR,GCU2,GCU3,JobSR,FormR,EDI1R,EDI2R,EDI3R);}

    {$IFDEF EN550CIS}
    For I := CISR DownTo SysR Do Begin
    {$ELSE}
    For I := JobSR DownTo SysR Do Begin
    {$ENDIF}
      KeyS := SysNames[I];
      LStatus:=LFind_Rec(B_GetEq, SysF, 0, KeyS);

      Case I Of
        SysR  : { already there } ;
        VATR  : Move(LSyss, LSyssVAT,   Sizeof(LSyssVAT));
        DEFR  : Move(LSyss, LSyssDEF,   Sizeof(LSyssDEF));

        //CurR  : Move(LSyss, LSyssCurr,  Sizeof(LSyssCurr));
        CurR,
        CuR2,
        CuR3  :  Begin
                   Move(LSyss,LSyssCurr1P^,Sizeof(LSyssCurr1P^));

                   SetCurrPage(Succ(Ord(I)-Ord(CurR)),
                               LSyssCurr1P^,
                               LSyssCurr,
                               BOn);
                 end;

        ModRR : Move(LSyss, LSyssMod^,   Sizeof(LSyssMod^));
        JobSR : Move(LSyss, LSyssJob,   Sizeof(LSyssJob));
        {HV 14/11/2017 ABSEXCH-19415: this line added to fix the Forgot Password Functionality not working in OLE Server
        this line is added to initialize company's Fax/Email settings}
        EDI2R :  Move(LSyss, lSyssEDI2^, Sizeof(lSyssEDI2^));
        //GCUR  : Move(LSyss, LSyssGCur,  Sizeof(LSyssGCur));
        GCuR,
        GCU2,
        GCU3  :  Begin

                   Move(LSyss,LSyssGCur1P^,Sizeof(LSyssGCur1P^));

                   SetGCurPage(Succ(Ord(I)-Ord(GCuR)),
                               LSyssGCuR1P^,
                               LSyssGCuR,
                               BOn);

                 end;

        {$IFDEF EN550CIS}
        CISR :  Move(LSyss, LSyssCIS,Sizeof(LSyssCIS));
        {$ENDIF}
      End; { Case }
    End; { For }

    // HM 25/06/02: Copy Local System Setup Records in global records
    CopySys;
  End; { With }

  { Check directory for Single/Multi-Currency }
  IsMultiCcy := FileExists (SetDrive + 'DEFMC044.SYS');

  //Intialise GlobalAdoConnection as we will be using SystemSetup (needed for Common Login Screen implementation)
  //EnterpriseLicence.IsSQL - we need to check this for SQL Only
  if EnterpriseLicence.IsSQL and (not Assigned(GlobalAdoConnection)) then
    InitialiseGlobalADOConnection(SetDrive);

End;


{ Shuts down the object }
Destructor TCompanyInfo.Destroy;
Begin
  BaseUser   := Nil;
  GotSbsDoor := Nil;

  If Assigned(FAgeingCache) Then
    FreeandNIL(FAgeingCache);

  If Assigned(FCostCentreCache) Then
    FreeandNIL(FCostCentreCache);

  If Assigned(FDepartmentCache) Then
    FreeandNIL(FDepartmentCache);

  If Assigned(FNominalCodeCache) Then
    FreeandNIL(FNominalCodeCache);

  If Assigned(FSQLStoredProcedureTransactionLines) Then
    FreeAndNIL(FSQLStoredProcedureTransactionLines);

  If Assigned(FSQLCaller) Then
    FreeAndNIL(FSQLCaller);

  If Assigned(FLogger) Then
    FreeAndNIL(FLogger);

  { Shutdown Btrieve object }
  Close_File(F[MLocF]);
  Close_File(F[PWrdF]);
  Close_File(F[SysF]);
  CompanyBtr.Close_Files;
  Dispose (CompanyBtr, Destroy);

  { Free client id for reuse }
  NextClientId[ClientId - ClientBase] := False;

  { do inherited ancestor type stuff }
  Inherited Destroy;
End;


{ Copy company system records into global records }
Procedure TCompanyInfo.CopySys;
Begin { CopySys }
  With CompanyBtr^ Do Begin
    Syss      := LSyss;
    SyssVAT^  := LSyssVAT;
    SyssDEF^  := LSyssDEF;
    SyssCurr^ := LSyssCurr;
    SyssGCuR^ := LSyssGCur;
    SyssMod^  := LSyssMod^;
    SyssJob^  := LSyssJob;
    {HV 14/11/2017 ABSEXCH-19415: this line added to fix the Forgot Password Functionality not working in OLE Server
    this line is added to initialize company's Fax/Email settings}
    SyssEDI2^ := lSyssEDI2^;
    {$IFDEF EN550CIS}
    SyssCIS^  := LSyssCIS;
    {$ENDIF}
  End; { With }
End; { CopySys }

function TCompanyInfo.BtrUserTo431User(ExBtr : TdPostExLocalPtr): EntryRecType;
Var
  N        : Byte;

  {== Routines to control the getting and storage of additional password records ==}
  Procedure SetEntryRecVar(PgNo    :  Byte;
                           PLogin  :  Str10;
                           LoadRec,
                           OverWER :  Boolean;
                       Var ERec    :  EntryRecType);
  Const
    Fnum      =  PWrdF;
    Keypath   =  PWK;
  Var
    KeyS  :  Str255;
    SetER :  Boolean;
    n     :  Byte;
    Idx   :  Longint;
    TmpPassWord  : PassWordRec;
  Begin
    With ExBtr^ Do Begin
      TmpPassWord := LPassword;

      SetER:=BOn;

      If LoadRec Then Begin
        KeyS:=FullPWordKey(PassUCode,Chr(PgNo),PLogin);

        Status:=LFind_Rec(B_GetEq,FNum,KeyPath,KeyS);

        If (Not StatusOk) Then Begin
          LResetRec(Fnum);
          SetER:=OverWER; {In the case of a copy or system copy, do not overwrite EntryRec if not found *}
        End; { If (Not StatusOk) }
      End; { If LoadRec }

      Idx:=256*PgNo;

      With LPassWord, PassEntryRec Do Begin
        If (SetER) then
          For n:=Low(Access) to High(Access) Do
            ERec.Access[n+Idx]:=Access[n];

        If (PgNo=0) then Begin
          ERec.Login:=Login;
          ERec.LastPNo:=LastPNo;
          ERec.PWord:=PWord;
        End; { If (PgNo=0) }
      End; { With LPassWord, PassEntryRec }

      LPassword := TmpPassWord;
    End; { With ExBtr^ }
  end;

Begin { BtrUserTo431User }
  With ExBtr^.LPassword.PassEntryRec Do
    // HM 02/02/05: Extended passwords to 4 pages (1000 in total)
    For N := 0 To 3 Do
      SetEntryRecVar(N,Login,(N>0),BOn,Result);
End; { BtrUserTo431User }

function TCompanyInfo.GetLogInRec(LoginCode : Str20;ExBtr : TdPostExLocalPtr): Boolean;
Const
  Keypath  =  PWK;
  Fnum     =  PWrdF;
Var
  KeyS     : Str255;
  //lStatus : SmallInt;
Begin
  Result:=BOff;

  KeyS:=FullPWordKey(PassUCode,C0,LoginCode);

  With ExBtr^ Do
  Begin
    lStatus:=LFind_Rec(B_GetEq,FNum,KeyPath,KeyS);

    Result := (lStatus = 0);
    If Result then
    begin
      If (Branding.pbProduct = Brand.ptExchequer) Then
      Begin
        // Get the user profile and check the password expiry  (Doesn't apply to LITE)
        KeyS := FullPWordKey(PassUCode, 'D', lPassword.PassEntryRec.Login);
        Status := LFind_Rec(B_GetEq, MLocF, MLK, KeyS);
        If (Status = 0) Then
        Begin
          Case LMLocCtrl.PassDefRec.PWExpMode Of
            0 : ; // Never Expires
            1 : Begin
                  // Check number of days left before expiry
                  Result := (NoDays(Today, LMLocCtrl.PassDefRec.PWExpDate) > 0);
                End;
            2 : Result := False; // Expired
          End; // Case LMLocCtrl.PassDefRec.PWExpMode
        End; // If (lStatus = 0)
      End; // If (Branding.pbProduct = ptExchequer)
    End; // If Result

    If Result then
    begin
      // Get all the user permissions records and combine into one consolidated record
      EntryRec^ := BtrUserTo431User (ExBtr);
    End; // If Result
  End; // With ExBtr^
end;

{ displays the login window to the user, unless we already have a valid  }
{ user id and password for the system, User details are kept in UserInfo }
{ for when we implement the security.                                    }
Function TCompanyInfo.LoginOK (Var SkipLogin : Boolean) : Boolean;
Var
  FoundCode  :  Str20;
  ExecuteNormalLogin : Boolean;
  I : Integer;
Begin
  Result := False;
  SkipLogin := False;

  //------------------------------

  // MH 12/02/2013 v7.0.2 ABSEXCH-13580: Extended OLE Server to support login via memory map
  ExecuteNormalLogin := True;
  If Assigned(GlobalOLEMemoryMap) Then
  Begin
    If GlobalOLEMemoryMap.Defined Then
    Begin
      If (GlobalOLEMemoryMap.CompanyCount > 0) Then
      Begin
        // Disable the UI login dialog as the memory map contains login details instead
        ExecuteNormalLogin := False;

        // Run through the company login details defined looking for a matching Company Code
        For I := 1 To GlobalOLEMemoryMap.CompanyCount Do
        Begin
          // Both codes should be stored in Trim(UpperCase(X)) form and can be directly compared
          If (GlobalOLEMemoryMap.Companies[I].cdCompanyCode = CompanyCode) Then
          Begin
            // Check to see if the UserID/Pwd is valid
            FoundCode := GlobalOLEMemoryMap.Companies[I].cdUserID;
            If GetLoginRec(FoundCode, CompanyBtr) Then
            Begin
              // Would prefer to encrypt the password and compare to the encrypted user password
              // from the DB, but the comment further down about passwords sometimes being padded
              // prevents that as I can't 'sometimes' pad before encrypting
              Result := (GlobalOLEMemoryMap.Companies[I].cdPassword = Trim(Decode(CompanyBtr^.LPassword.PassEntryRec.PWord)));

              { Take copy of user for checking security }
              If Result Then
              Begin
                UserInfo := BtrUserTo431User(CompanyBtr);
                Break;
              End; // If Result
            End; // If GetLoginRec(FoundCode, CompanyBtr)
          End; // If (GlobalOLEMemoryMap.Companies[I].cdCompanyCode = Trim(UpperCase(CompanyCode)))
        End; // For I
      End; // If (GlobalOLEMemoryMap.CompanyCount > 0)
    End; // If GlobalOLEMemoryMap.Defined
  End; // If Assigned(GlobalOLEMemoryMap)

  //------------------------------

  // MH 12/02/2013 v7.0.2 ABSEXCH-13580: Extended OLE Server to support login via memory map
  If ExecuteNormalLogin Then
  Begin
    { Check we already have one successfull login }
    If (BaseUser^.Login[1] <> #0) Then Begin
      If (Not GotSBSDoor^) Then Begin
        { See if we have a matching login record in this data }
        FoundCode := Trim(BaseUser^.Login);
        If GetLoginRec(FoundCode, CompanyBtr) Then Begin
          // HM 11/04/00: Modified as PWord sometime padded, sometime not
          Result := (BaseUser^.PWord = Trim(Decode(CompanyBtr^.LPassword.PassEntryRec.PWord)));

          { Take copy of user for checking security }
          If Result Then
            UserInfo := BtrUserTo431User(CompanyBtr);
        End { If }
        Else
          Result := False;

        { No matching user/pword combo - so need to ask }
        If (Not Result) Then
          Result := DispLogin;
      End { If }
      Else
        Result := True;
    End { If }
    Else
      { No Successfull logins so far }
      Result := DispLogin;

    // MH 12/02/2013 v7.0.2 ABSEXCH-13580: Extended OLE Server to support login via memory map
    //                                     and made Login skipping limited to manual logins
    SkipLogin := (Not Result);
  End; // If ExecuteNormalLogin
End;

function TCompanyInfo.LogonCancelWarn(Sender: TObject): Boolean;
Var
  lLogonWarnfrm: TForm_LogonWarn;
begin
  Result := False;
  lLogonWarnfrm := TForm_LogonWarn.Create(Application);
  try
    lLogonWarnfrm.ShowModal;
    Result := lLogonWarnfrm.ModalResult = mrYes
  finally
    FreeAndNil(lLogonWarnfrm);
  end;
end;

{ Displays login screen }
function TCompanyInfo.DispLogin : Boolean;
var
  lLoginFrm: TfrmLogin;
  lGotPassWord: Boolean;
begin
  Result := True;
  lLoginFrm := TfrmLogin.Create(Application);
  lGotPassWord := False;
  try
    with lLoginFrm do
    begin
      //ExBtr := CompanyBtr;
      LoginDialog := ldOLEServer;
      OnOLECloseEvent := LogonCancelWarn;
      EnSecurity := Check_ModRel(15,BOn);
      GDPROn := Check_ModRel(24, BOn);

      InitDefaults;
      { Set focus to login window }
      Application.Restore;
      Application.ProcessMessages;
      SetForegroundWindow(Form_EnterpriseOleServer.Handle);
      ShowModal;
      Application.Minimize;
      lGotPassWord := ModalResult = mrOk;

      if lGotPassWord then
      begin
        { Take copy of user for default login - if 1st login }
        if (BaseUser^.Login[1] = #0) then
          with BaseUser^ do
          begin
            Login := EntryRec^.Login;
            Pword := Trim(Decode(EntryRec^.Pword));
          end; { With BaseUser }
        { Take copy of user for checking security }
        UserInfo := EntryRec^; 
        // HM 20/12/02: Add the user into the memory map object for sharing with
        // other Excel Add-In objects sech as the Drill-Down, this prevents the
        // requirement for multiple logins to the same company.
        GlobalOLEMap.AddLogin(CompanyCode, EntryRec^.Login);
      end; { If }
    end; { With }   
    GotSBSDoor^ := (EntryRec^.Login = SBSDoor);
  finally
    FreeAndNil(lLoginFrm);
  end; { Try }
  Result := lGotPassWord;   
End;


{ Checks the Logged In user has security rights }
Function TCompanyInfo.CheckSecurity (Const SecNo : LongInt) : Boolean;
Begin
  With UserInfo Do Begin
    { Check login name is set, and user has security privileges }
    Result := GotSBSDoor^ Or
              ((Login[1] <> #0) And
              ((SecNo >= Low(Access)) And (SecNo <= High(Access))) And
              (Access[SecNo] = 1));
  End; { With }
End;


Procedure TCompanyInfo.UpdateSys(Const SysFlagNo : Byte);
Const
  FNum              = SysF;
  KeyPath : Integer = 0;
Var
  KeyS      : Str255;
  LocStat   : Integer;
  LocLocked : Boolean;
Begin { UpdateSys }
  { Load system records into CompanyBtr }
  With CompanyBtr^ Do Begin
    { Refresh system setup record }
    KeyS := SysNames[SysR];
    LocStat:=LFind_Rec(B_GetEq, FNum, KeyPath, KeyS);

    If (LStatus = 0) Then Begin
      { Lock record }
      LocLocked:=BOff;
      Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPath,Fnum,BOn,LocLocked);
      LGetRecAddr(FNum);

      If OK And GlobLocked Then Begin
        { Change flags as required }
        Case SysFlagNo Of
          1 : Begin { NeedBMUp - 'Update Build Costings' flag }
                LSyss.NeedBMUp := True;
              End;
        End; { Case }

        { Update record }
        LStatus := LPut_Rec (Fnum, KeyPath);
        LUnLockMLock(FNum);
      End; { If }
    End; { If }
  End; { With }
End; { UpdateSys }

//-------------------------------------------------------------------------

Function TCompanyInfo.GetUserId : ShortString;
Begin // GetUserId
  Result := Trim(UserInfo.Login);
End; // GetUserId

//-------------------------------------------------------------------------

Function TCompanyInfo.GetAgeingCache : TAccountAgeingCache;
Begin // GetAgeingCache
  If Not Assigned(FAgeingCache) Then
    FAgeingCache := TAccountAgeingCache.Create;
  Result := FAgeingCache;
End; // GetAgeingCache

//------------------------------

Function TCompanyInfo.GetCostCentreCache : TCostCentreDepartmentCache;
Begin // GetCostCentreCache
  If Not Assigned(FCostCentreCache) Then
  Begin
    FCostCentreCache := TCostCentreDepartmentCache.Create(ccdCostCentre);

    // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
    If SQLUtils.UsingSQL And SQLReportsConfiguration.UseOLEPreloadCaching Then
    Begin
      FCostCentreCache.SQLPreload(CompanyCode);
    End; // If SQLUtils.UsingSQL And SQLReportsConfiguration.UseOLEPreloadCaching
  End; // If Not Assigned(FCostCentreCache)
  Result := FCostCentreCache;
End; // GetCostCentreCache

//------------------------------

Function TCompanyInfo.GetDepartmentCache : TCostCentreDepartmentCache;
Begin // GetDepartmentCache
  If Not Assigned(FDepartmentCache) Then
  Begin
    FDepartmentCache := TCostCentreDepartmentCache.Create(ccdDepartment);

    // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
    If SQLUtils.UsingSQL And SQLReportsConfiguration.UseOLEPreloadCaching Then
    Begin
      FDepartmentCache.SQLPreload(CompanyCode);
    End; // If SQLUtils.UsingSQL And SQLReportsConfiguration.UseOLEPreloadCaching
  End; // If Not Assigned(FCostCentreCache)
  Result := FDepartmentCache;
End; // GetDepartmentCache

//------------------------------

Function TCompanyInfo.GetNominalCodeCache : TNominalCodeCache;
Begin // GetNominalCodeCache
  If Not Assigned(FNominalCodeCache) Then
  Begin
    FNominalCodeCache := TNominalCodeCache.Create;

    // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
    If SQLUtils.UsingSQL And SQLReportsConfiguration.UseOLEPreloadCaching Then
    Begin
      FNominalCodeCache.SQLPreload(CompanyCode);
    End; // If SQLUtils.UsingSQL And SQLReportsConfiguration.UseOLEPreloadCaching
  End; // If Not Assigned(FNominalCodeCache)
  Result := FNominalCodeCache;
End; // GetNominalCodeCache

//------------------------------

// MH 20/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Job Codes
Function TCompanyInfo.GetJobCodeCache : TJobCodeCache;
Begin // GetJobCodeCache
  If Not Assigned(FJobCodeCache) Then
  Begin
    FJobCodeCache := TJobCodeCache.Create;

    If SQLUtils.UsingSQL And SQLReportsConfiguration.UseOLEPreloadCaching Then
    Begin
      FJobCodeCache.SQLPreload(CompanyCode);
    End; // If SQLUtils.UsingSQL And SQLReportsConfiguration.UseOLEPreloadCaching
  End; // If Not Assigned(FJobCodeCache)
  Result := FJobCodeCache;
End; // GetJobCodeCache

//------------------------------

// MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Analysis Codes
Function TCompanyInfo.GetAnalysisCodeCache : TAnalysisCodeCache;
Begin // GetAnalysisCodeCache
  If Not Assigned(FAnalysisCodeCache) Then
  Begin
    FAnalysisCodeCache := TAnalysisCodeCache.Create;

    If SQLUtils.UsingSQL And SQLReportsConfiguration.UseOLEPreloadCaching Then
    Begin
      FAnalysisCodeCache.SQLPreload(CompanyCode);
    End; // If SQLUtils.UsingSQL And SQLReportsConfiguration.UseOLEPreloadCaching
  End; // If Not Assigned(FAnalysisCodeCache)
  Result := FAnalysisCodeCache;
End; // GetAnalysisCodeCache

//------------------------------

Function TCompanyInfo.GetSQLCaller : TSQLCaller;
Var
  sConnectionString, lPassword : WideString;  //VA:29/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords	
Begin // GetSQLCaller
  If Not Assigned(FSQLCaller) Then
  Begin
    // Create SQL Caller Instance for this company and initialise the SQL stuff
    FSQLCaller := TSQLCaller.Create;

    // Get Company Admin Connection String - Read-Only doesn't have rights to run this
    //If (GetConnectionString(CompanyCode, False, sConnectionString) = 0) Then
    //VA:29/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords	
    If (GetConnectionStringWOPass(CompanyCode, False, sConnectionString, lPassword) = 0) Then
    Begin
      // Connection String
      FSQLCaller.ConnectionString := sConnectionString;
      FSQLCaller.Connection.Password := lPassword;
      // Timeout
      FSQLCaller.Records.CommandTimeout := SQLReportsConfiguration.OLETimeoutInSeconds;
    End // If (GetConnectionString(CompanyCode, False, sConnectionString) = 0)
    Else
      Raise Exception.Create ('TCompanyInfo.GetSQLCaller: Unable to get Connection String');
  End; // If Not Assigned(FSQLCaller)

  Result := FSQLCaller;
End; // GetSQLCaller

//------------------------------

Function TCompanyInfo.GetLogger : TEntSQLReportLogger;
Begin // GetLogger
  If Not Assigned(FLogger) Then
  Begin
    FLogger := TEntSQLReportLogger.Create('OLEServer');
    FLogger.DataPath := Trim(CompanyPath);
  End; // If Not Assigned(FLogger)
  Result := FLogger;
End; // GetLogger


Function TCompanyInfo.GetSQLStoredProcedureTransactionLines : TSQLStoredProcedureTransactionLines;
Begin // GetSQLStoredProcedureransactionLines
  If Not Assigned(FSQLStoredProcedureTransactionLines) Then
  Begin
    FSQLStoredProcedureTransactionLines := TSQLStoredProcedureTransactionLines.Create;
  End; // If Not Assigned(TSQLStoredProcedureransactionLines)
  Result := FSQLStoredProcedureTransactionLines;
End; // GetSQLStoredProcedureransactionLines


//-------------------------------------------------------------------------

Initialization
  NextClientId := TBits.Create;

  // MH 12/02/2013 v7.0.2 ABSEXCH-13580: Extended OLE Server to support login via memory map
  //                                     Note: Automatically destroyed on shutdown
  GlobalOLEMemoryMap := TOLEServerMemoryMap.Create(False);
Finalization
  NextClientId.Free;
end.
