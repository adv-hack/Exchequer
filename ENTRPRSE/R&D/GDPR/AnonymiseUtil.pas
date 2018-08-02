unit AnonymiseUtil;

interface

uses ExBtTh1u, Classes, SysUtils, EntLoggerClass, SQLUtils, IndeterminateProgressF,
     DB, Windows, SQLCallerU, Forms, oAnonymisationDiaryBtrieveFile, oContactsFile,
     Dialogs, ExWrap1U, AuditIntf;

type
  {Delete Letter and Links in parallel Thread}
  TFileDeletionThread = Class(TThread)
  private
    FEntityList: TStringList;
    FEntityCode: String;
    FEntityType: TAnonymisationDiaryEntity;
    FCompanyCode: String;
    FSQLCaller: TSQLCaller;
    FThreadCompleted: Boolean;
    procedure LoadFileList(const AEntityType: Integer; const AEntityCode: String);
    procedure DeleteFiles(AList: TStringList; const ADeleteLetters, ADeleteLinks: Boolean);
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TObject; aAnonEntityList: TStringList); Overload;
    constructor Create(AOwner: TObject; AEntityCode: String; AEntityType: TAnonymisationDiaryEntity); Overload;
    destructor Destroy; override;
  end;  //TFileDeletionThread

  //------------------------------------------------------------------

  TAnonymiseThread = object(TThreadQueue)
  private
    FAnonymiseEntityList: TStringList;
    FProgressFrm: TIndeterminateProgressFrm; // Progress bar form
    FHandle: THandle;
    FTraderOptParam: String;
    FEmployeeOptParam: String;
    ExLocal: TdExLocal;
    procedure GetEntityCodeAndType(const AEntityStr: String; var AEntityCode, AEntityType: String);
    function GetEntityOptParamDesc(const AEntityType: TAnonymisationDiaryEntity): String;
    //After Complete Anonymisation process remove that Entity from AnonymisationDiary table
    procedure RemoveAnonymisationDiaryEntity(const AEntityType: Integer;
                                             const aEntityCode: String;
                                             var AErrMsg: String); virtual; abstract;
    procedure AddAuditNote(const AEntityType: Integer; const aEntityCode: String);
  public
    constructor Create(AOwner: TObject);
    destructor Destroy; virtual;
    procedure Finish; virtual;
  end; //TAnonymiseThread

  //------------------------------------------------------------------

  TAnonymiseThread_SQL = object(TAnonymiseThread)
  private
    FSQLLogger: TEntSQLReportLogger; //Error report logging
    FSQLCaller: TSQLCaller; //SQL access component, to run the stored procedure
    FCompanyCode: String; //Company Code -- required for calling stored procedures
    FFileDelThread: TFileDeletionThread;
    // -------------------------------------------------------------------------
    // Error handling & logging
    // -------------------------------------------------------------------------
    // Error message display. Displays and logs the supplied error, and sets the
    // abort flag.
    procedure ErrorMessage(const ARoutine, AMsg: String); overload;
    // Updates the error log. This is automatically called by the ErrorMessage
    // routine above
    procedure WriteErrorMsg(const ARoutine, AMsg: String);
    procedure RemoveAnonymisationDiaryEntity(const AEntityType: Integer;
                                             const AEntityCode: String;
                                             var AErrMsg: String); virtual;
  public
    constructor Create(AOwner: TObject);
    destructor Destroy; virtual;
    function Start: Boolean; virtual; //Initialises the system
    procedure Process; virtual;
  end; //TAnonymiseThread_SQL

  //------------------------------------------------------------------

  TAnonymiseThread_PSQL = object(TAnonymiseThread)
  private
    FContactBtrvFile: TContactsFile;
    FContactPlugInEnabled: Boolean;

    function RandomText(Const AValue: String): String;
    procedure AnonymiseEntity(const aEntityCode: String;
                              const aEntityType: TAnonymisationDiaryEntity;
                              var AStatus: Integer);
    //Anonymise Traders
    function AnonymiseTrader(const aEntityCode: String): Integer;
    //Anonymise Account Roles Contacts
    function AnonymiseAccountRolesContact(const aEntityCode: String): Integer;
    // Anonymise entity related Contacts in Contacts Plug-In table
    function AnonymiseAccountContacts(const aEntityCode: String): Integer;
    //Anonymise Employee
    function AnonymiseEmployee(const AEntityCode: String): Integer;
    //Anonymise Notes
    function AnonymiseNotes(const aEntityCode: String;
                            const aEntityType: TAnonymisationDiaryEntity): Integer;
    //Anonymise/Delete Links and Letters
    function AnonymiseLinksAndLetters(aEntityCode: String;
                                      const aEntityType: TAnonymisationDiaryEntity): Integer;
    //Anonymise Trancations
    function AnonymiseTransactions(const aEntityCode: String;
                                   const aEntityType: TAnonymisationDiaryEntity): Integer;
    //Anonymise Job
    function AnonymiseJob(const AEntityCode: String): Integer;
    //Remove Anonymise Entity from AnonymisationDiary Table
    procedure RemoveAnonymisationDiaryEntity(const AEntityType: Integer;
                                             const AEntityCode: String;
                                             var AErrMsg: String); virtual;
  public
    constructor Create(AOwner:  TObject);
    destructor Destroy; virtual;
    function Start: Boolean; virtual; //Initialises the system
    procedure Process; virtual;
  end; //TAnonymiseThread_PSQL

  //------------------------------------------------------------------

  //Main entry point to be called Anonymise Process
  procedure AnonymiseProcess_SQL(const AOwner: TObject; aAnonEntityList: TStringList);
  procedure AnonymiseProcess_PSQL(const AOwner: TObject; aAnonEntityList: TStringList);

  //------------------------------------------------------------------

implementation

uses BTSupU1, GDPRConst, ExThrd2U, GlobVar, oSystemSetup, ADOConnect, BtKeys1U,
     VarConst, Btrvu2, StrUtils, JobSup1U, ETDateU, DateUtils, Math, NoteSupu,
     ContactsManager, AuditNotes, CustomFieldsIntf, Letters, ETStrU, FileUtil;

//------------------------------------------------------------------------------

procedure AnonymiseProcess_SQL(const AOwner: TObject; aAnonEntityList: TStringList);
var
  lAnonymiseProcObj: ^TAnonymiseThread_SQL;
begin
  //Ensure Thread Controller is up and running
  if Create_BackThread then
  begin
    //Create Anonymise process object
    New(lAnonymiseProcObj, Create(AOwner));
    try
      //Disable the opening/closing/reopening/reclosing of the Btrieve files via the emulator
      lAnonymiseProcObj^.UsingEmulatorFiles := False;

      //Initialise the Anonymise Entity List
      if Assigned(aAnonEntityList) then
        lAnonymiseProcObj^.FAnonymiseEntityList := aAnonEntityList;

      //Call Start to display the thread Controller
      if lAnonymiseProcObj^.Start then
        BackThread.AddTask(lAnonymiseProcObj, 'Anonymising Entity')  //Initialise the Anonymise process and add it into the Thread Controller
      else
      begin
        Set_BackThreadFlip(False);
        Dispose(lAnonymiseProcObj, Destroy);
      end;

      //start the FileDeletionthread for Deleting Letter and Links
      if Assigned(aAnonEntityList) then
        lAnonymiseProcObj^.FFileDelThread := TFileDeletionThread.Create(AOwner, aAnonEntityList);

    except
      Dispose(lAnonymiseProcObj, Destroy); //Stop Anonymise if there was an exception
    end; //Try..Except
  end; //If Create_BackThread
end;

//------------------------------------------------------------------------------

procedure AnonymiseProcess_PSQL(const AOwner: TObject; aAnonEntityList: TStringList);
var
  lAnonymiseProcObj: ^TAnonymiseThread_PSQL;
begin
  //Ensure Thread Controller is up and running
  if Create_BackThread then
  begin
    //Create Anonymise process object
    New(lAnonymiseProcObj, Create(AOwner));
    try
      //Disable the opening/closing/reopening/reclosing of the Btrieve files via the emulator
      lAnonymiseProcObj^.UsingEmulatorFiles := False;

      //Initialise the Anonymise Entity List
      if Assigned(aAnonEntityList) then
        lAnonymiseProcObj^.FAnonymiseEntityList := aAnonEntityList;

      //Call Start to display the thread Controller
      if lAnonymiseProcObj^.Start then
        BackThread.AddTask(lAnonymiseProcObj, 'Anonymising Entity')  //Initialise the Anonymise process and add it into the Thread Controller
      else
      begin
        Set_BackThreadFlip(False);
        Dispose(lAnonymiseProcObj, Destroy);
      end;
    except
      Dispose(lAnonymiseProcObj, Destroy); //Stop Anonymise if there was an exception
    end; //try..except
  end; //If Create_BackThread
end;

//------------------------------------------------------------------------------
{ TAnonymiseThread }
//------------------------------------------------------------------------------

constructor TAnonymiseThread.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  FCancelled := False;
  FCanAbort := False;
  FPriority := tpHighest;
  FSetPriority := BOn;
  FHandle:= TForm(AOwner).Handle;
  ExLocal.Create;
end;

//------------------------------------------------------------------------------

procedure TAnonymiseThread.Finish;
begin
  if (FProgressFrm <> nil) then
    FProgressFrm.Stop;
  if Assigned(ThreadRec) then
    UpdateProgress(ThreadRec.PTotal);
  inherited;
  //HV 02/02/2018 2017R1 ABSEXCH-19685: Auditing after successfully Anonymising entity
  NewAuditInterface(atAnonymisation, FAnonymiseEntityList).WriteAuditEntry;
end;

//------------------------------------------------------------------------------

procedure TAnonymiseThread.GetEntityCodeAndType(const AEntityStr: String;
                                                var AEntityCode, AEntityType: String);
begin
  if AEntityStr <> '' then
  begin
    AEntityCode := LeftStr(AEntityStr, Length(AEntityStr)-2);
    AEntityType := RightStr(AEntityStr, 1);
  end;
end;

//------------------------------------------------------------------------------

function TAnonymiseThread.GetEntityOptParamDesc(const AEntityType: TAnonymisationDiaryEntity): String;
begin
  Result := EmptyStr;
  with SystemSetup(True) do
  begin
    case AEntityType of
      adeCustomer,
      adeSupplier : begin
                      if GDPR.GDPRTraderAnonNotesOption > 1 then
                        Result := strDeleteNotes + ' ';
                      if GDPR.GDPRTraderAnonLettersOption > 1 then
                        Result := Result + strDeleteLetters + ' ';
                      if GDPR.GDPRTraderAnonLinksOption > 1 then
                        Result := Result + strDeleteLinks + ' ';
                    end;
      adeEmployee : begin
                      if GDPR.GDPREmployeeAnonNotesOption > 1 then
                        Result := strDeleteNotes + ' ';
                      if GDPR.GDPREmployeeAnonLettersOption > 1 then
                        Result := Result + strDeleteLetters + ' ';
                      if GDPR.GDPREmployeeAnonLinksOption > 1 then
                        Result := Result + strDeleteLinks + ' ';
                    end;
      else
        Result := EmptyStr;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TAnonymiseThread.AddAuditNote(const AEntityType: Integer; const aEntityCode: String);
var
  lStatus: Integer;
  lKeyS: Str255;
begin
  if AEntityType In [1,2] then
  begin
    lKeyS := FullCustcode(AEntityCode);
    lStatus := Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, lKeyS);
    if lStatus = 0 then
    begin
      ExLocal.AssignFromGlobal(CustF);
      TAuditNote.WriteAuditNote(anAccount, anAnonymised, ExLocal);
    end;
  end;
end;

//------------------------------------------------------------------------------

destructor TAnonymiseThread.Destroy;
begin
  FProgressFrm := nil;
  ExLocal.Destroy;
  inherited Destroy;
end;

//------------------------------------------------------------------------------
{ TAnonymiseThread_SQL }
//------------------------------------------------------------------------------

constructor TAnonymiseThread_SQL.Create(AOwner: TObject);
begin
  Inherited Create(AOwner);
end;

//------------------------------------------------------------------------------

destructor TAnonymiseThread_SQL.Destroy;
begin
  FreeAndNil(FSQLLogger);
  FreeAndNil(FSQLCaller);
  inherited Destroy;
end;

//------------------------------------------------------------------------------

function TAnonymiseThread_SQL.Start: Boolean;
begin
  Result := True;
  FSQLLogger := TEntSQLReportLogger.Create('Anonymising Entity');
  try
    FSQLCaller := TSQLCaller.Create(GlobalAdoConnection); // Create the SQL Caller instance
    FCompanyCode := SQLUtils.GetCompanyCode(SetDrive); // Determine the company code

    // Set the time-outs to 60 minutes
    FSQLCaller.Connection.CommandTimeout := 3600;
    FSQLCaller.Query.CommandTimeout := 3600;
    FSQLCaller.Records.CommandTimeout := 3600;

    //Get Entity Optinal Param from GDPR Config
    FTraderOptParam := Trim(GetEntityOptParamDesc(adeCustomer));
    FEmployeeOptParam := Trim(GetEntityOptParamDesc(adeEmployee));

    // Create the progress bar form
    if FAnonymiseEntityList.Count > 0 then
    begin
      FProgressFrm := TIndeterminateProgressFrm.Create(Application.MainForm);
      FProgressFrm.Start('Anonymising Entity', 'Anonymising Data');
    end;

  except
    on E:Exception do
    begin
      // Report the error and return False to indicate the failure
      ErrorMessage('Starting Anonymising Entity', 'Initialisation failed: ' + E.Message);
      Result := False;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TAnonymiseThread_SQL.Process;
var
  i,
  lStatus: Integer;
  lQuery,
  lEntityCode,
  lEntityType,
  lCompanyCode,
  lOptParam,
  lErrorMsg: String;
begin
  if not Assigned(FAnonymiseEntityList) then exit;
  //start the File Deletion Thread execution in background
  FFileDelThread.Resume;
  {this loop hold the execution to avoid the following section (for i := 0 to (FAnonymiseEntityList.Count - 1) do Loop)
   to execute before deleting all Links and Letters which actually will result in malfunctioning}
  repeat
    application.ProcessMessages;
  until FFileDelThread.FThreadCompleted;

  // Initialise the Progress Bar range
  InitProgress(FAnonymiseEntityList.Count + 2);

  //EXEC [common].[esp_AnonymiseEntity] 'ZZZZ01,ZZZZ02,ZZZZ03,ZZZZ04,ZZZZ05', 1, 'ABAP01'
  // Prepare the query
  for i := 0 to (FAnonymiseEntityList.Count - 1) do
  begin
    lCompanyCode := QuotedStr(FCompanyCode);

    GetEntityCodeAndType(Trim(FAnonymiseEntityList.Strings[i]), lEntityCode, lEntityType);

    if TAnonymisationDiaryEntity(StrToInt(lEntityType)) = adeEmployee then
      lOptParam := QuotedStr(FEmployeeOptParam)
    else
      lOptParam := QuotedStr(FTraderOptParam);

    //lOptParam := QuotedStr(Trim(GetEntityOptParamDesc(TAnonymisationDiaryEntity(StrToInt(lEntityType)))));

    lQuery := 'EXEC [common].esp_AnonymiseEntity ' + lCompanyCode + ', ' + lEntityType + ', ' + QuotedStr(lEntityCode) + ', '+ lOptParam;
    lStatus := FSQLCaller.ExecSQL(lQuery); // Execute the stored procedure
    lErrorMsg := FSQLCaller.ErrorMsg;

    if (lStatus = 0) and (FSQLCaller.ErrorMsg = EmptyStr) then
    begin
      RemoveAnonymisationDiaryEntity(StrToInt(lEntityType), lEntityCode, lErrorMsg);
      if Assigned(ThreadRec) then
        UpdateProgress(2 + I);
    end;
    
    if (lErrorMsg <> '') then
      ErrorMessage('TAnonymiseThread_SQL.Process', 'Error Anonymising Entity: ' + lErrorMsg);
  end;

  //Update Anon List in Control Center screen.
  SendMessage(FHandle, WM_AnonControlCentreMsg, 2, 0);
end;

//------------------------------------------------------------------------------

procedure TAnonymiseThread_SQL.ErrorMessage(const ARoutine, AMsg: String);
begin
  // Write the message to the error log
  WriteErrorMsg(ARoutine, AMsg);
  // If an error occurs, we have to abort. In theory, Anonymise Entity could
  // skip to the next Anonymise Entity and try to carry on, but in practice we have no
  // way of offering this option to the user without rewriting LThShowMsg().
  ThreadRec.ThAbort := True;
end;

//------------------------------------------------------------------------------

procedure TAnonymiseThread_SQL.WriteErrorMsg(const ARoutine, AMsg: String);
begin
  FSQLLogger.LogError('Error in ' + ARoutine, AMsg);
end;

//------------------------------------------------------------------------------
//After Complete Anonymisation process remove that Entity from AnonymisationDiary table
procedure TAnonymiseThread_SQL.RemoveAnonymisationDiaryEntity(const AEntityType: Integer;
                                                              const AEntityCode: String;
                                                              var AErrMsg: String);
var
  lSQLCaller: TSQLCaller;
  lRes: Integer;
  lQuery: String;
begin
  lSQLCaller := TSQLCaller.Create(GlobalAdoConnection);
  try
    lQuery := 'DELETE FROM [COMPANY].ANONYMISATIONDIARY WHERE adEntityType = ' + IntToStr(AEntityType) +
                                                        ' AND adEntityCode = ' + QuotedStr(aEntityCode);
    lRes := lSQLCaller.ExecSQL(lQuery, FCompanyCode);

    if lRes <> 0 then
      AErrMsg := lSQLCaller.ErrorMsg
    else
      AddAuditNote(AEntityType, AEntityCode);
    finally
      FreeandNil(lSQLCaller);
  end;
end;

//------------------------------------------------------------------------------
{ TAnonymiseThread_PSQL }
//------------------------------------------------------------------------------

constructor TAnonymiseThread_PSQL.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  FContactBtrvFile := TContactsFile.Create;
end;

//------------------------------------------------------------------------------

destructor TAnonymiseThread_PSQL.Destroy;
begin
  FreeAndNil(FContactBtrvFile);
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TAnonymiseThread_PSQL.Process;
var
  i,
  lStatus: Integer;
  lEntityCode,
  lEntityTypeStr,
  lErrorMsg: String;
  lEntityType: TAnonymisationDiaryEntity;
begin
  if not Assigned(FAnonymiseEntityList) then exit;
  lStatus := 0;
  // Initialise the Progress Bar range
  InitProgress(FAnonymiseEntityList.Count + 2);
  for i := 0 to (FAnonymiseEntityList.Count - 1) do
  begin
    GetEntityCodeAndType(Trim(FAnonymiseEntityList.Strings[i]), lEntityCode, lEntityTypeStr);
    lEntityType := TAnonymisationDiaryEntity(StrToInt(lEntityTypeStr));
    AnonymiseEntity(lEntityCode, lEntityType, lStatus);
    if (lStatus = 0) then
      RemoveAnonymisationDiaryEntity(Ord(lEntityType), lEntityCode, lErrorMsg);
    if Assigned(ThreadRec) then
      UpdateProgress(2 + I);
    if lStatus <> 0 then
      Break;
  end;

  //Update Anon List in Control Center screen.
  SendMessage(FHandle, WM_AnonControlCentreMsg, 2, 0);
end;

//------------------------------------------------------------------------------

function TAnonymiseThread_PSQL.Start: Boolean;
begin
  Result := True;

  //Get Entity Optinal Param from GDPR Config
  FTraderOptParam := Trim(GetEntityOptParamDesc(adeCustomer));
  FEmployeeOptParam := Trim(GetEntityOptParamDesc(adeEmployee));

  if Assigned(FContactBtrvFile) then
    FContactPlugInEnabled := FContactBtrvFile.OpenFile = 0;

  // Create the progress bar form
  if FAnonymiseEntityList.Count > 0 then
  begin
    FProgressFrm := TIndeterminateProgressFrm.Create(Application.MainForm);
    FProgressFrm.Start('Anonymising Entity', 'Anonymising Data');
  end;
end;

//------------------------------------------------------------------------------
//Convert String value to Random text for Anonymise
function TAnonymiseThread_PSQL.RandomText(const AValue: String): String;
var
  lAnonStr: String;
  i: Integer;

  //------------------------------------------

  function GetRandomChar(const AFromLimit, AToLimit: Byte): Char;
  begin
    Result := Chr(RandomRange(AFromLimit, AToLimit));
  end;

  //------------------------------------------
begin
  lAnonStr := EmptyStr;

  for i := 1 to length(AValue) do
  begin
    if AValue[i] in ['A'..'Z'] then
      lAnonStr := lAnonStr + GetRandomChar(65, 91)
    else if AValue[i] in ['a'..'z'] then
      lAnonStr := lAnonStr + GetRandomChar(97, 122)
    else if AValue[i] in ['0'..'9'] then
      lAnonStr := lAnonStr + GetRandomChar(48, 57)
    else
      lAnonStr := lAnonStr + AValue[i];
  end;

  Result := lAnonStr;
end;

//------------------------------------------------------------------------------

procedure TAnonymiseThread_PSQL.AnonymiseEntity(const aEntityCode: String;
                                                const aEntityType: TAnonymisationDiaryEntity;
                                                var AStatus: Integer);
begin
  case AEntityType of
    adeCustomer,
    adeSupplier : AStatus := AnonymiseTrader(aEntityCode);
    adeEmployee : AStatus := AnonymiseEmployee(aEntityCode);
  end;
end;

//------------------------------------------------------------------------------
//Anonymise PII Fields for Trader
function TAnonymiseThread_PSQL.AnonymiseTrader(const AEntityCode: String): Integer;
var
  lKeyS: Str255;
  lStatus: Integer;
  lCustomFieldsObj: TCustomFields;

  //-------------------------------------------------------------
  //AnonymiseUDF
  procedure AnonymiseUDF(aCategory: Integer);
  begin
    with Cust do
    begin
      if lCustomFieldsObj.Get_Field(aCategory, 1).cfContainsPIIData then
        UserDef1 := RandomText(UserDef1);
      if lCustomFieldsObj.Get_Field(aCategory, 2).cfContainsPIIData then
        UserDef2 := RandomText(UserDef2);
      if lCustomFieldsObj.Get_Field(aCategory, 3).cfContainsPIIData then
        UserDef3 := RandomText(UserDef3);
      if lCustomFieldsObj.Get_Field(aCategory, 4).cfContainsPIIData then
        UserDef4 := RandomText(UserDef4);
      if lCustomFieldsObj.Get_Field(aCategory, 5).cfContainsPIIData then
        UserDef5 := RandomText(UserDef5);
      if lCustomFieldsObj.Get_Field(aCategory, 6).cfContainsPIIData then
        UserDef6 := RandomText(UserDef6);
      if lCustomFieldsObj.Get_Field(aCategory, 7).cfContainsPIIData then
        UserDef7 := RandomText(UserDef7);
      if lCustomFieldsObj.Get_Field(aCategory, 8).cfContainsPIIData then
        UserDef8 := RandomText(UserDef8);
      if lCustomFieldsObj.Get_Field(aCategory, 9).cfContainsPIIData then
        UserDef9 := RandomText(UserDef9);
      if lCustomFieldsObj.Get_Field(aCategory, 10).cfContainsPIIData then
        UserDef10 := RandomText(UserDef10);
      if lCustomFieldsObj.Get_Field(aCategory, 11).cfContainsPIIData then
        CCDCardNo := RandomText(CCDCardNo);
      if lCustomFieldsObj.Get_Field(aCategory, 12).cfContainsPIIData then
        FillChar(CCDSDate, SizeOf(CCDSDate), #0);
      if lCustomFieldsObj.Get_Field(aCategory, 13).cfContainsPIIData then
        FillChar(CCDEDate, SizeOf(CCDEDate), #0);
      if lCustomFieldsObj.Get_Field(aCategory, 14).cfContainsPIIData then
        CCDName := RandomText(CCDName);
      if lCustomFieldsObj.Get_Field(aCategory, 15).cfContainsPIIData then
        CCDSARef := RandomText(CCDSARef);  
    end;
  end;
  //-------------------------------------------------------------

begin
  //Anonymise PII Fields for Trader
  lKeyS := FullCustcode(AEntityCode);
  lStatus := Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, lKeyS);

  if lStatus = 0 then
  begin
    with Cust do
    begin
      Company := RandomText(Company);
      Contact := RandomText(Contact);
      Addr[1] := RandomText(Addr[1]);
      Addr[2] := RandomText(Addr[2]);
      Addr[3] := RandomText(Addr[3]);
      Addr[4] := RandomText(Addr[4]);
      Addr[5] := RandomText(Addr[5]);
      PostCode := RandomText(PostCode);
      FillChar(EmailAddr, SizeOf(EmailAddr), #0);
      FillChar(Phone, SizeOf(Phone), #0);
      FillChar(Fax, SizeOf(Fax), #0);
      FillChar(Phone2, SizeOf(Phone2), #0);
      DAddr[1] := RandomText(DAddr[1]);
      DAddr[2] := RandomText(DAddr[2]);
      DAddr[3] := RandomText(DAddr[3]);
      DAddr[4] := RandomText(DAddr[4]);
      DAddr[5] := RandomText(DAddr[5]);
      acDeliveryPostCode := RandomText(acDeliveryPostCode);
      RefNo := RandomText(RefNo); //acTheirAcc
      FillChar(VATRegNo, SizeOf(VATRegNo), #0);
      acBankAccountCode := '';
      acBankSortCode := '';
      acMandateID := '';
      acMandateDate := '';
      BankRef := RandomText(BankRef);
      FillChar(ebusPwrd, SizeOf(ebusPwrd), #0);
      acAnonymisationStatus := asAnonymised;
      acAnonymisedDate := FormatDateTime('yyyymmdd', Today);
      acAnonymisedTime := TimeNowStr;

      lCustomFieldsObj := CustomFields;
      if Assigned(lCustomFieldsObj) then
      begin
        if IsACust(Cust.CustSupp) then
          AnonymiseUDF(cfCustomer)
        else
          AnonymiseUDF(cfSupplier);
      end;
    end;                           
    //Update row with Anonymised value in Database
    lStatus := Put_Rec(F[CustF], CustF, RecPtr[CustF]^, CustCodeK);

    AnonymiseAccountRolesContact(AEntityCode); //Anonymise entity related Contacts in Account Roles
    AnonymiseAccountContacts(AEntityCode); //Anonymise entity related Contacts in Contacts Plug-In table
    AnonymiseNotes(Trim(AEntityCode), adeCustomer); //Anonymise Notes
    if lStatus = 0 then
    begin
      if IsACust(Cust.CustSupp) then
      begin
        AnonymiseLinksAndLetters(Trim(AEntityCode), adeCustomer); //Anonymise/Delete Lettesr and Links
        AnonymiseTransactions(Trim(AEntityCode), adeCustomer); //Anonymise Transaction
        AnonymiseJob(Trim(AEntityCode)); //Anonymise Job
      end
      else if not IsACust(Cust.CustSupp) then
      begin
        AnonymiseLinksAndLetters(Trim(AEntityCode), adeSupplier); //Anonymise/Delete Lettesr and Links
        AnonymiseTransactions(Trim(AEntityCode), adeSupplier); //Anonymise Transaction
      end;
    end;
  end;
  Result := lStatus;
end;

//------------------------------------------------------------------------------
//Anonymise Account Roles Contacts
function TAnonymiseThread_PSQL.AnonymiseAccountRolesContact(const aEntityCode: String): Integer;
var
  i,
  lStatus,
  lContactId: Integer;
  lContactManager: TContactsManager;
  lContact: TAccountContact;
begin
  lContactManager := NewContactsManager;
  lStatus := 0;
  try
    if Assigned(lContactManager) then
    begin
      lContactManager.SetCustomerRecord(aEntityCode);

      for i := 0 to lContactManager.GetNumContacts - 1 do
      begin
        lContact := lContactManager.GetContact(i);
        if Assigned(lContact) then
        begin
          lContactId := lContact.ContactDetails.acoContactId;
          // Lock the contact record
          if (lContactManager.LockContact(lContactId)) then
          begin
            with lContact.contactDetails do
            begin
              acoContactName         := RandomText(acoContactName);
              acoContactJobTitle     := RandomText(acoContactJobTitle);
              FillChar(acoContactPhoneNumber, SizeOf(acoContactPhoneNumber), #0);
              FillChar(acoContactFaxNumber, SizeOf(acoContactFaxNumber), #0);
              FillChar(acoContactEmailAddress, SizeOf(acoContactEmailAddress), #0);
              acoContactAddress[1]   := RandomText(acoContactAddress[1]);
              acoContactAddress[2]   := RandomText(acoContactAddress[2]);
              acoContactAddress[3]   := RandomText(acoContactAddress[3]);
              acoContactAddress[4]   := RandomText(acoContactAddress[4]);
              acoContactAddress[5]   := RandomText(acoContactAddress[5]);
              acoContactPostCode     := RandomText(acoContactPostCode);
            end;
            lStatus := lContactManager.SaveContactToDB(lContact, emEdit);
          end; // if (lContactManager.LockContact(lContactId)) then
        end; // if Assigned(lContact) then
      end; // for i := 0 to lContactManager.GetNumContacts - 1 do
    end; // if Assigned(lContactManager) then
  finally
    FreeAndNil(lContactManager);
    Result := lStatus;
  end;
end;

//------------------------------------------------------------------------------
// Anonymise entity related Contacts in Contacts Plug-In table
function TAnonymiseThread_PSQL.AnonymiseAccountContacts(const aEntityCode: String): Integer;
var
  lRes: Integer;
  lCompanyCode: String;
  lKeyS: Str255;
begin
  Result := 0;
  if FContactPlugInEnabled and Assigned(FContactBtrvFile) then
  begin
    lCompanyCode := GetCompanyCode(SetDrive);
    FContactBtrvFile.GetFirst;
    lKeyS := FullCustCode(lCompanyCode) + FullCustCode(aEntityCode);
    lRes := FContactBtrvFile.GetGreaterThanOrEqual(lKeyS);
    with FContactBtrvFile.ContactRec do
    begin
      while (lRes = 0) and (Trim(coAccount) = Trim(aEntityCode)) do
      begin
        coTitle := RandomText(coTitle);
        coSalutation := RandomText(coSalutation);
        coFirstName := RandomText(coFirstName);
        coSurname := RandomText(coSurname);
        coPosition := RandomText(coPosition);
        FillChar(coContactNo, SizeOf(coContactNo), #0);
        FillChar(coFaxNumber, SizeOf(coFaxNumber), #0);
        FillChar(coEmailAddr, SizeOf(coEmailAddr), #0);
        coAddress1 := RandomText(coAddress1);
        coAddress2 := RandomText(coAddress2);
        coAddress3 := RandomText(coAddress3);
        coAddress4 := RandomText(coAddress4);
        coPostCode := RandomText(coPostCode);
        FContactBtrvFile.Update;
        lRes := FContactBtrvFile.GetNext;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Anonymise the Employee
function TAnonymiseThread_PSQL.AnonymiseEmployee(const AEntityCode: String): Integer;
var
  lKeyS: Str255;
  lStatus: Integer;
  lCustomFieldsObj: TCustomFields;

  //------------------------------------------------------
  //AnonymiseUDF
  procedure AnonymiseUDF(aCategory: Integer);
  begin
    with JobMisc.EmplRec do
    begin
      if lCustomFieldsObj.Get_Field(aCategory, 1).cfContainsPIIData then
        UserDef1 := RandomText(UserDef1);
      if lCustomFieldsObj.Get_Field(aCategory, 2).cfContainsPIIData then
        UserDef2 := RandomText(UserDef2);
      if lCustomFieldsObj.Get_Field(aCategory, 3).cfContainsPIIData then
        UserDef3 := RandomText(UserDef3);
      if lCustomFieldsObj.Get_Field(aCategory, 4).cfContainsPIIData then
        UserDef4 := RandomText(UserDef4);
    end;
  end;
  //------------------------------------------------------

begin
  lKeyS := PartCCKey(JARCode, JASubAry[3]) + FullEmpKey(AEntityCode);
  lStatus := Find_Rec(B_GetEq, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, lKeyS);

  //Anonymise the Employee
  if lStatus = 0 then
  begin
    with JobMisc.EmplRec do
    begin
      EmpName := RandomText(EmpName);
      Addr[1] := RandomText(Addr[1]);
      Addr[2] := RandomText(Addr[2]);
      Addr[3] := RandomText(Addr[3]);
      Addr[4] := RandomText(Addr[4]);
      Addr[5] := RandomText(Addr[5]);
      FillChar(Phone, SizeOf(Phone), #0);
      FillChar(emEmailAddr, SizeOf(emEmailAddr), #0);
      FillChar(Fax, SizeOf(Fax), #0);
      FillChar(Phone2, SizeOf(Phone2), #0);
      PayNo := RandomText(PayNo);
      CertNo := RandomText(CertNo);
      ENINo := RandomText(ENINo);
      UTRCode := Randomtext(UTRCode);
      VerifyNo := RandomText(VerifyNo);
      emAnonymisationStatus := asAnonymised;
      emAnonymisedDate := FormatDateTime('yyyymmdd', Today);
      emAnonymisedTime := TimeNowStr;

      //AnonymiseUDF
      lCustomFieldsObj := CustomFields;
      if Assigned(lCustomFieldsObj) then
        AnonymiseUDF(cfEmployee);
    end;

    //Update row with Anonymised value in Database
    lStatus := Put_Rec(F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK);

    AnonymiseNotes(Trim(AEntityCode), adeEmployee); //Anonymise Notes
    AnonymiseLinksAndLetters(Trim(AEntityCode), adeEmployee); //Anonymise Links and Letters
    AnonymiseTransactions(Trim(AEntityCode), adeEmployee); //Anonymise Transaction
  end;
  Result := lStatus;
end;

//------------------------------------------------------------------------------

function TAnonymiseThread_PSQL.AnonymiseNotes(const aEntityCode: String;
                                              const aEntityType: TAnonymisationDiaryEntity): Integer;
var
  lKeyS,
  lKeyRef,
  lNotesKeyRef,
  lNotesKeyS: Str255;  
  lStatus: Integer;
  //-------------------------------------------------

  procedure DeleteNotes(aTypeCode, aSubTypeCode: Char; aKey2Match: String);
  begin
    lKeyRef := PartGNoteKey(NoteTCode, aTypeCode, aSubTypeCode, FullNCode(aKey2Match));
    lKeyS := lKeyRef;

    lStatus := Find_Rec(B_GetGEq,F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, lKeyS);
    while (lStatus = 0) and (CheckKeyRange(lKeyRef, lKeyRef, lKeyS, Length(lKeyRef), BOff)) do
    begin
      lStatus := Delete_Rec(F[PWrdF], PWrdF, PWK);
      lStatus := Find_Rec(B_GetNext, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, lKeyS);
    end;
  end;

  //-------------------------------------------------
  //For Transaction notes we need to loop through transactions and find notes and delete them
  procedure DeleteTransactionNotes(aKey2Match: Str255; aIndexNum: Integer; aSubTypeCode: Char);
  begin
    lKeyRef := aKey2Match;
    lKeyS := lKeyRef;

    lStatus := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, aIndexNum, lKeyS);

    while (lStatus = 0) and (CheckKey(lKeyRef, lKeyS, Length(lKeyRef), BOn)) do
    begin
      lNotesKeyRef := PartGNoteKey(NoteTCode, NoteDCode, aSubTypeCode, FullNomKey(Inv.FolioNum));
      lNotesKeyS := lNotesKeyRef;
      lStatus := Find_Rec(B_GetGEq,F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, lNotesKeyS);
      //Loop through transaction notes
      while (lStatus = 0) and (CheckKeyRange(lNotesKeyRef, lNotesKeyRef, lNotesKeyS, Length(lNotesKeyRef), BOff)) do
      begin
        lStatus := Delete_Rec(F[PWrdF], PWrdF, PWK);
        lStatus := Find_Rec(B_GetNext, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, lNotesKeyS);
      end;
      lStatus := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, aIndexNum, lKeyS);
    end;
  end;
  //-------------------------------------------------

begin
  lStatus := 0;
  //Check Action for notes to be carried out
  case aEntityType of
    adeCustomer,
    adeSupplier : begin
                    if AnsiPos(strDeleteNotes, FTraderOptParam) > 0 then
                    begin
                      //Anonymise/delete Trader
                      DeleteNotes(NoteCCode, NoteCGCode, AEntityCode); {* General Notes Sub Code *}
                      DeleteNotes(NoteCCode, NoteCDCode, AEntityCode); {* Dated Notes Sub Code *}
                      //Delete Trader Transaction notes
                      DeleteTransactionNotes(Trim(AEntityCode), InvCustK, NoteCGCode); {* General Notes Sub Code *}
                      DeleteTransactionNotes(Trim(AEntityCode), InvCustK, NoteCDCode); {* Dated Notes Sub Code *}
                    end;
                  end;
    adeEmployee : begin
                    if AnsiPos(strDeleteNotes, FEmployeeOptParam) > 0 then
                    begin
                      //Anonymise/delete Employee
                      DeleteNotes(NoteECode, NoteCGCode, AEntityCode); {* General Notes Sub Code *}
                      DeleteNotes(NoteECode, NoteCDCode, AEntityCode); {* Dated Notes Sub Code *}

                      //Delete Employee Transaction notes  {* General Notes Sub Code *}
                      DeleteTransactionNotes(FullNCode(Trim(AEntityCode)), InvBatchK, NoteCGCode);      //TSH (TimrSheet)
                      DeleteTransactionNotes(#5 + FullNCode(Trim(AEntityCode)), InvBatchK, NoteCGCode); //JCT (Terms)
                      DeleteTransactionNotes(#6 + FullNCode(Trim(AEntityCode)), InvBatchK, NoteCGCode); //JPA (Applications)
                      {* Dated Notes Sub Code *}
                      DeleteTransactionNotes(FullNCode(Trim(AEntityCode)), InvBatchK, NoteCDCode);      //TSH (TimrSheet)
                      DeleteTransactionNotes(#5 + FullNCode(Trim(AEntityCode)), InvBatchK, NoteCDCode); //JCT (Terms)
                      DeleteTransactionNotes(#6 + FullNCode(Trim(AEntityCode)), InvBatchK, NoteCDCode); //JPA (Applications)
                    end;
                  end; //adeEmployee
  end; //case aEntityType of
  Result := 0;
end;

//------------------------------------------------------------------------------

function TAnonymiseThread_PSQL.AnonymiseLinksAndLetters(aEntityCode: String;
  const aEntityType: TAnonymisationDiaryEntity): Integer;
var
  lStatus: Integer;
  
  //-------------------------------------------------------------
  //Delete Transaction Links and Letters
  procedure DeleteTransactionLinksAndLetters(const AKeyS: Str255;
                                             const ADeleteLinks: Boolean; {True: Delete Links, False: Delete Letters}
                                             const AIndexNum: Integer; ADeleteFile: Boolean);
  var
    lInvKeyRef,
    lInvKeyS: Str255;
  begin
    lInvKeyRef := AKeyS;
    lInvKeyS := lInvKeyRef;
    lStatus := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, AIndexNum, lInvKeyS);

    while (lStatus = 0) and (CheckKey(lInvKeyRef, lInvKeyS, Length(lInvKeyRef), BOn)) do
    begin
      if  (not (Inv.InvDocHed In [JPA, TSH, JCT])) And (aEntityType <> adeEmployee) then
        lStatus := DeleteLettersLinks(LetterDocCode, FullNomKey(Inv.FolioNum), aDeleteLinks, aDeleteFile);
      lStatus := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, AIndexNum, lInvKeyS);
    end;
  end;
  //-------------------------------------------------------------

begin
  lStatus := 0;
  AEntityCode := Trim(AEntityCode);
  case aEntityType of
    adeCustomer : begin
                    //Anonymise and delete all Links for Customer
                    if AnsiPos(strDeleteLinks, FTraderOptParam) > 0 then
                    begin
                      //Delete Links for Customer
                      DeleteLettersLinks(TradeCode[True], AEntityCode, True, (SystemSetup.GDPR.GDPRTraderAnonLinksOption = 3));

                      //Delete Links for Consumer
                      DeleteLettersLinks('U', AEntityCode, True, (SystemSetup.GDPR.GDPRTraderAnonLinksOption = 3));

                      //Delete Transaction Links for Customer
                      DeleteTransactionLinksAndLetters(AEntityCode, True, InvCustK, (SystemSetup.GDPR.GDPRTraderAnonLinksOption = 3));
                    end;
                    //Anonymise and delete all Letters for Customer
                    if (AnsiPos(strDeleteLetters, FTraderOptParam) > 0) then
                    begin
                      //Delete Letters for Customer
                      DeleteLettersLinks(TradeCode[True], AEntityCode, False, (SystemSetup.GDPR.GDPRTraderAnonLettersOption = 3));

                      //Delete Letters for Consumer
                      DeleteLettersLinks('U', AEntityCode, False, (SystemSetup.GDPR.GDPRTraderAnonLettersOption = 3));

                      //Delete Transaction Letters for Customer
                      DeleteTransactionLinksAndLetters(AEntityCode, False, InvCustK, (SystemSetup.GDPR.GDPRTraderAnonLettersOption = 3));
                    end;
                  end;
    adeSupplier : begin
                    //Anonymise and delete all Links for Supplier
                    if AnsiPos(strDeleteLinks, FTraderOptParam) > 0 then
                    begin
                      DeleteLettersLinks(TradeCode[False], AEntityCode, True, (SystemSetup.GDPR.GDPRTraderAnonLinksOption = 3));
                      //Delete Transaction Links for Supplier
                      DeleteTransactionLinksAndLetters(AEntityCode, True, InvCustK, (SystemSetup.GDPR.GDPRTraderAnonLinksOption = 3));
                    end;
                    //Anonymise and delete all Letters for Supplier
                    if (AnsiPos(strDeleteLetters, FTraderOptParam) > 0) then
                    begin
                      DeleteLettersLinks(TradeCode[False], AEntityCode, False, (SystemSetup.GDPR.GDPRTraderAnonLettersOption = 3));
                      //Delete Transaction Letters for Supplier
                      DeleteTransactionLinksAndLetters(AEntityCode, False, InvCustK, (SystemSetup.GDPR.GDPRTraderAnonLettersOption = 3));
                    end;
                  end;
    adeEmployee : begin
                    //Delete Links for Employee
                    if AnsiPos(strDeleteLinks, FEmployeeOptParam) > 0 then
                    begin
                      DeleteLettersLinks(LetterEmplCode, AEntityCode, True, (SystemSetup.GDPR.GDPREmployeeAnonLinksOption = 3));
                      //Delete Transaction Links for Employee
                      DeleteTransactionLinksAndLetters(AEntityCode, True, InvBatchK, (SystemSetup.GDPR.GDPREmployeeAnonLinksOption = 3)); // TimeSheet
                      DeleteTransactionLinksAndLetters(#5 + FullNCode(aEntityCode), True, InvBatchK, (SystemSetup.GDPR.GDPREmployeeAnonLinksOption = 3)); //JCT (Terms)
                      DeleteTransactionLinksAndLetters(#6 + FullNCode(aEntityCode), True, InvBatchK, (SystemSetup.GDPR.GDPREmployeeAnonLinksOption = 3)); //JPA (Applications)
                    end;
                    //Delete Letters for Employee
                    if  (AnsiPos(strDeleteLetters, FEmployeeOptParam) > 0) then
                    begin
                      DeleteLettersLinks(LetterEmplCode, Trim(AEntityCode), False, (SystemSetup.GDPR.GDPREmployeeAnonLettersOption = 3));
                      DeleteTransactionLinksAndLetters(AEntityCode, False, InvBatchK, (SystemSetup.GDPR.GDPREmployeeAnonLettersOption = 3)); //TimeSheet
                      DeleteTransactionLinksAndLetters(#5 + FullNCode(aEntityCode), False, InvBatchK, (SystemSetup.GDPR.GDPREmployeeAnonLinksOption = 3)); //JCT (Terms)
                      DeleteTransactionLinksAndLetters(#6 + FullNCode(aEntityCode), False, InvBatchK, (SystemSetup.GDPR.GDPREmployeeAnonLinksOption = 3)); //JPA (Applications)
                    end;
                  end;
  end; //case aEntityType of
  Result := lStatus;
end;

//------------------------------------------------------------------------------

function TAnonymiseThread_PSQL.AnonymiseJob(const AEntityCode: String): Integer;
var
  lKeyS,
  lKeyRef: Str255;
  lStatus: Integer;
  lCustomFieldsObj: TCustomFields;
  //AnonymiseUDF
  procedure AnonymiseUDF(aCategory: Integer);
  begin
    with JobRec^ do
    begin
      if lCustomFieldsObj.Get_Field(aCategory, 1).cfContainsPIIData then
        UserDef1 := RandomText(UserDef1);
      if lCustomFieldsObj.Get_Field(aCategory, 2).cfContainsPIIData then
        UserDef2 := RandomText(UserDef2);
      if lCustomFieldsObj.Get_Field(aCategory, 3).cfContainsPIIData then
        UserDef3 := RandomText(UserDef3);
      if lCustomFieldsObj.Get_Field(aCategory, 4).cfContainsPIIData then
        UserDef4 := RandomText(UserDef4);
      if lCustomFieldsObj.Get_Field(aCategory, 5).cfContainsPIIData then
        UserDef5 := RandomText(UserDef5);
      if lCustomFieldsObj.Get_Field(aCategory, 6).cfContainsPIIData then
        UserDef6 := RandomText(UserDef6);
      if lCustomFieldsObj.Get_Field(aCategory, 7).cfContainsPIIData then
        UserDef7 := RandomText(UserDef7);
      if lCustomFieldsObj.Get_Field(aCategory, 8).cfContainsPIIData then
        UserDef8 := RandomText(UserDef8);
      if lCustomFieldsObj.Get_Field(aCategory, 9).cfContainsPIIData then
        UserDef9 := RandomText(UserDef9);
      if lCustomFieldsObj.Get_Field(aCategory, 10).cfContainsPIIData then
        UserDef10 := RandomText(UserDef10);
    end;   
  end;

  //For Transaction notes we need to loop through transactions and find notes and delete them
  procedure DeleteJobsNotes(aSubTypeCode: Char);
  var
    lNotesKeyS,
    lNotesKeyRef: Str255;
    lRes: Integer;
  begin
    lNotesKeyRef := PartGNoteKey(NoteTCode, NoteJCode, aSubTypeCode, FullNCode(FullNomKey(JobRec^.JobFolio)));
    lNotesKeyS := lNotesKeyRef;
    lRes := Find_Rec(B_GetGEq,F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, lNotesKeyS);
    //Loop through transaction notes
    while (lRes = 0) and (CheckKeyRange(lNotesKeyRef, lNotesKeyRef, lNotesKeyS, Length(lNotesKeyRef), BOff)) do
    begin
      Delete_Rec(F[PWrdF], PWrdF, PWK);
      lRes := Find_Rec(B_GetNext, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, lNotesKeyS);
    end;
  end;

begin
  //Anonymise PII Fields for Trader JOBHEAD
  lKeyRef := FullCustCode(AEntityCode);
  lKeyS := lKeyRef;
  lStatus := Find_Rec(B_GetGEq, F[JobF], JobF, RecPtr[JobF]^, JobCustK, lKeyS);
  while (lStatus = 0) and (CheckKey(lKeyRef, lKeyS, Length(lKeyRef), BOn)) do
  begin
    with JobRec^ do
    begin
      JobDesc := RandomText(JobDesc);
			Contact := RandomText(Contact);
			JobMan := RandomText(JobMan);
      jrAnonymised := True;
      jrAnonymisedDate := FormatDateTime('yyyymmdd', Today);
      jrAnonymisedTime := TimeNowStr;
      //AnonymiseUDF
      lCustomFieldsObj := CustomFields;
      if Assigned(lCustomFieldsObj) then
        AnonymiseUDF(cfJob);
    end;
    // Update in DB
    Put_Rec(F[JobF], JobF, RecPtr[JobF]^, JobCustK);

    //Delete Notes
    if AnsiPos(strDeleteNotes, FTraderOptParam) > 0 then
    begin
      DeleteJobsNotes(NoteCGCode); {* General Notes Sub Code *}
      DeleteJobsNotes(NoteCDCode); {* Dated Notes Sub Code *}
    end;

    //Delete Links
    if AnsiPos(strDeleteLinks, FTraderOptParam) > 0 then
      DeleteLettersLinks(LetterJobCode, FullNomKey(JobRec^.JobFolio), True, (SystemSetup.GDPR.GDPRTraderAnonLinksOption = 3));

    //Delete Letters
    if AnsiPos(strDeleteLetters, FTraderOptParam) > 0 then
      DeleteLettersLinks(LetterJobCode, FullNomKey(JobRec^.JobFolio), False, (SystemSetup.GDPR.GDPRTraderAnonLettersOption = 3));

    //Next Transaction
    lStatus := Find_Rec(B_GetNext, F[JobF], JobF, RecPtr[JobF]^, JobCustK, lKeyS);
  end;

  Result := 0;  
end;

//------------------------------------------------------------------------------

function TAnonymiseThread_PSQL.AnonymiseTransactions(const aEntityCode: String;
                                                     const aEntityType: TAnonymisationDiaryEntity): Integer;
var
  lInvKeyRef,
  lInvKeyS,
  lDetailKeyRef,
  lDetailKeyS: Str255;
  lStatus: Integer;
  lCustomFieldsObj: TCustomFields;
  
  //-----------------------------------------------------------
  // Anonymise Document Table
  procedure AnonymiseHeadersUDF(aCategory: Integer);
  begin
    with Inv do
    begin
      if lCustomFieldsObj.Get_Field(aCategory, 1).cfContainsPIIData then
        DocUser1 := RandomText(DocUser1);
      if lCustomFieldsObj.Get_Field(aCategory, 2).cfContainsPIIData then
        DocUser2 := RandomText(DocUser2);
      if lCustomFieldsObj.Get_Field(aCategory, 3).cfContainsPIIData then
        DocUser3 := RandomText(DocUser3);
      if lCustomFieldsObj.Get_Field(aCategory, 4).cfContainsPIIData then
        DocUser4 := RandomText(DocUser4);
      if lCustomFieldsObj.Get_Field(aCategory, 5).cfContainsPIIData then
        DocUser5 := RandomText(DocUser5);
      if lCustomFieldsObj.Get_Field(aCategory, 6).cfContainsPIIData then
        DocUser6 := RandomText(DocUser6);
      if lCustomFieldsObj.Get_Field(aCategory, 7).cfContainsPIIData then
        DocUser7 := RandomText(DocUser7);
      if lCustomFieldsObj.Get_Field(aCategory, 8).cfContainsPIIData then
        DocUser8 := RandomText(DocUser8);
      if lCustomFieldsObj.Get_Field(aCategory, 9).cfContainsPIIData then
        DocUser9 := RandomText(DocUser9);
      if lCustomFieldsObj.Get_Field(aCategory, 10).cfContainsPIIData then
        DocUser10 := RandomText(DocUser10);
      if lCustomFieldsObj.Get_Field(aCategory, 11).cfContainsPIIData then
        thUserField11 := RandomText(thUserField11);
      if lCustomFieldsObj.Get_Field(aCategory, 12).cfContainsPIIData then
        thUserField12 := RandomText(thUserField12);
    end;
  end;

  //-----------------------------------------------------------
  // Anonymise Document Table
  procedure AnonymiseDetailsUDF(aCategory: Integer);
  begin
    if lCustomFieldsObj.Get_Field(aCategory, 1).cfContainsPIIData then
      Id.LineUser1 := RandomText(Id.LineUser1);
    if lCustomFieldsObj.Get_Field(aCategory, 2).cfContainsPIIData then
      Id.LineUser2 := RandomText(Id.LineUser2);
    if lCustomFieldsObj.Get_Field(aCategory, 3).cfContainsPIIData then
      Id.LineUser3 := RandomText(Id.LineUser3);
    if lCustomFieldsObj.Get_Field(aCategory, 4).cfContainsPIIData then
      Id.LineUser4 := RandomText(Id.LineUser4);
    if lCustomFieldsObj.Get_Field(aCategory, 5).cfContainsPIIData then
      Id.LineUser5 := RandomText(Id.LineUser5);
    if lCustomFieldsObj.Get_Field(aCategory, 6).cfContainsPIIData then
      Id.LineUser6 := RandomText(Id.LineUser6);
    if lCustomFieldsObj.Get_Field(aCategory, 7).cfContainsPIIData then
      Id.LineUser7 := RandomText(Id.LineUser7);
    if lCustomFieldsObj.Get_Field(aCategory, 8).cfContainsPIIData then
      Id.LineUser8 := RandomText(Id.LineUser8);
    if lCustomFieldsObj.Get_Field(aCategory, 9).cfContainsPIIData then
      Id.LineUser9 := RandomText(Id.LineUser9);
    if lCustomFieldsObj.Get_Field(aCategory, 10).cfContainsPIIData then
      Id.LineUser10 := RandomText(Id.LineUser10);
  end;

  //-----------------------------------------------------------

  procedure AnonymiseGenericFields;
  begin
    Inv.thAnonymised := True;
    Inv.thAnonymisedDate := FormatDateTime('yyyymmdd',Today);
    Inv.thAnonymisedTime := TimeNowStr;
    Inv.DAddr[1] := RandomText(Inv.DAddr[1]);
    Inv.DAddr[2] := RandomText(Inv.DAddr[2]);
    Inv.DAddr[3] := RandomText(Inv.DAddr[3]);
    Inv.DAddr[4] := RandomText(Inv.DAddr[4]);
    Inv.DAddr[5] := RandomText(Inv.DAddr[5]);
    Inv.thDeliveryPostCode := RandomText(Inv.thDeliveryPostCode);
    //HV 29 Jan,2015 - ABSEXCH-19670: Post Anonymisation > If all notes deleted then remove the Status 'Notes' in Transaction daybook.
    if Inv.HoldFlg In [32,33,34,35,36,37,38,160,161,162,163,164,165,166] then
    begin
      if ((aEntityType = adeEmployee) and (AnsiPos(strDeleteNotes, FEmployeeOptParam) > 0)) or
         ((aEntityType In [adeCustomer, adeSupplier]) and (AnsiPos(strDeleteNotes, FTraderOptParam) > 0)) then
        Inv.HoldFlg := Inv.HoldFlg - 32;
    end;
  end;

  //-----------------------------------------------------------
  //AnonymiseEmployeeTranscaions
  procedure AnonymiseEmployeeTranscaions(const AKeyString: Str255);
  begin
    if Assigned(lCustomFieldsObj) then
    begin
      lInvKeyRef := AKeyString;
      lInvKeyS := lInvKeyRef;
      lStatus := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvBatchK, lInvKeyS);
      while (lStatus = 0) and
            (CheckKey(lInvKeyRef, lInvKeyS, Length(lInvKeyRef), BOn)) and
            (Trim(Inv.BatchLink) = Trim(lInvKeyRef)) do
      begin
        AnonymiseGenericFields;
        case Inv.InvDocHed of //Update Headers
          TSH : AnonymiseHeadersUDF(cfTSHHeader);
          JPA : AnonymiseHeadersUDF(cfJPAHeader);
          JPT : AnonymiseHeadersUDF(cfJPTHeader);
          JCT : AnonymiseHeadersUDF(cfJCTHeader);
        end;
        //Update the record
        lStatus := Put_Rec(F[InvF], InvF, RecPtr[InvF]^, InvBatchK);

        //Then update its details if any
        lDetailKeyRef := FullNomKey(Inv.FolioNum);
        lDetailKeyS := lDetailKeyRef;
        lStatus := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK, lDetailKeyS);
        while (lStatus = 0) and (CheckKey(lDetailKeyRef, lDetailKeyS, Length(lDetailKeyRef), BOn)) do
        begin
          //update line items
          case Inv.InvDocHed of
            TSH : AnonymiseDetailsUDF(cfTSHLine);
            JPA : AnonymiseDetailsUDF(cfJPALine);
            JPT : AnonymiseDetailsUDF(cfJPTLine);
            JCT : AnonymiseDetailsUDF(cfJCTLine);
          end;
          //Update the Record
          lStatus := Put_Rec(F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK);
          //Next line item if any
          lStatus := Find_Rec(B_GetNext, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK, lDetailKeyS);
        end;
        //Next Transaction
        lStatus := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvBatchK, lInvKeyS);
      end;
    end; {if Assigned(lCustomFieldsObj) then} 
  end;
  //-----------------------------------------------------------
  
begin
  Result := 0;
  case aEntityType of
    adeCustomer,
    adeSupplier : begin
                    lCustomFieldsObj := CustomFields;
                    if Assigned(lCustomFieldsObj) then
                    begin
                      lInvKeyRef := aEntityCode;
                      lInvKeyS := lInvKeyRef;
                      lStatus := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvCustK, lInvKeyS);
                      while (lStatus = 0) and
                            (CheckKey(lInvKeyRef, lInvKeyS, Length(lInvKeyRef), BOn)) and
                            (Trim(Inv.CustCode) = lInvKeyRef) do
                      begin
                        AnonymiseGenericFields;
                        case Inv.InvDocHed of //Update Headers
                          //Customer/Consumer
                          SIN,
                          SCR,
                          SJI,
                          SJC,
                          SRF,
                          SRI : AnonymiseHeadersUDF(cfSINHeader);
                          SRC : AnonymiseHeadersUDF(cfSRCHeader);
                          SQU : AnonymiseHeadersUDF(cfSQUHeader);
                          SOR,
                          SDN : AnonymiseHeadersUDF(cfSORHeader);
                          JST : AnonymiseHeadersUDF(cfJSTHeader);
                          JSA : AnonymiseHeadersUDF(cfJSAHeader);
                          SRN : AnonymiseHeadersUDF(cfSRNHeader);
                          //Supplier
                          PIN,
                          PCR,
                          PJI,
                          PJC,
                          PRF,
                          PPI : AnonymiseHeadersUDF(cfPINHeader);
                          PPY : AnonymiseHeadersUDF(cfPPYHeader);
                          PQU : AnonymiseHeadersUDF(cfPQUHeader);
                          POR,
                          PDN : AnonymiseHeadersUDF(cfPORHeader);
                          PRN : AnonymiseHeadersUDF(cfPRNHeader);
                        end;
                        //Update the record
                        lStatus := Put_Rec(F[InvF], InvF, RecPtr[InvF]^, InvCustK);

                        //Then update its details if any
                        lDetailKeyRef := FullNomKey(Inv.FolioNum);
                        lDetailKeyS := lDetailKeyRef;
                        lStatus := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK, lDetailKeyS);
                        while (lStatus = 0) and (CheckKey(lDetailKeyRef, lDetailKeyS, Length(lDetailKeyRef), BOn)) do
                        begin
                          //update line items
                          case Inv.InvDocHed of
                            //Customer/Consumer
                            SIN,
                            SCR,
                            SJI,
                            SJC,
                            SRF,
                            SRI : AnonymiseDetailsUDF(cfSINLine);
                            SRC : AnonymiseDetailsUDF(cfSRCLine);
                            SQU : AnonymiseDetailsUDF(cfSQULine);
                            SOR,
                            SDN : AnonymiseDetailsUDF(cfSORLine);
                            JST : AnonymiseDetailsUDF(cfJSTLine);
                            JSA : AnonymiseDetailsUDF(cfJSALine);
                            SRN : AnonymiseDetailsUDF(cfSRNLine);
                            //Supplier
                            PIN,
                            PCR,
                            PJI,
                            PJC,
                            PRF,
                            PPI : AnonymiseDetailsUDF(cfPINLine);
                            PPY : AnonymiseDetailsUDF(cfPPYLine);
                            PQU : AnonymiseDetailsUDF(cfPQULine);
                            POR,
                            PDN : AnonymiseDetailsUDF(cfPORLine);
                            PRN : AnonymiseDetailsUDF(cfPRNLine);
                          end;
                          //Update the Record
                          lStatus := Put_Rec(F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK);
                          //Next line item if any
                          lStatus := Find_Rec(B_GetNext, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK, lDetailKeyS);
                        end;

                        //Next Transaction
                        lStatus := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvCustK, lInvKeyS);
                      end;
                    end; {if Assigned(lCustomFieldsObj) then}
                  end;    
    adeEmployee : begin
                    lCustomFieldsObj := CustomFields;
                    AnonymiseEmployeeTranscaions(FullNCode(aEntityCode)); // TSH (TimrSheet)
                    AnonymiseEmployeeTranscaions(#5 + FullNCode(aEntityCode)); //JCT (Terms)
                    AnonymiseEmployeeTranscaions(#6 + FullNCode(aEntityCode)); //JPA (Applications)
                  end; {adeEmployee}
  end;
end;

//------------------------------------------------------------------------------
//After Complete Anonymisation process remove that Entity from AnonymisationDiary table
procedure TAnonymiseThread_PSQL.RemoveAnonymisationDiaryEntity(const AEntityType: Integer;
                                                               const AEntityCode: String;
                                                               var AErrMsg: String);
var
  lAnonDiaryBtrvFile: TAnonymisationDiaryBtrieveFile;
  lKey: String;
  lStatus: Integer;
begin
  lAnonDiaryBtrvFile := TAnonymisationDiaryBtrieveFile.Create;
  try
    if (lAnonDiaryBtrvFile.OpenFile(IncludeTrailingPathDelimiter(SetDrive) + AnonymisationDiaryFileName) = 0) then
    begin
      lKey := lAnonDiaryBtrvFile.BuildTypeCodeKey(TAnonymisationDiaryEntity(AEntityType), AEntityCode);
      lAnonDiaryBtrvFile.Index := adIdxTypeCode;
      lStatus := lAnonDiaryBtrvFile.GetEqual(lKey);
      if lStatus = 0 then
      begin
        lAnonDiaryBtrvFile.Delete;
        AddAuditNote(AEntityType, AEntityCode);
      end;
    end;
  finally
    lAnonDiaryBtrvFile.Free;
  end;
end;

//------------------------------------------------------------------------------
{ TFileDeletionThread }
//------------------------------------------------------------------------------

constructor TFileDeletionThread.Create(AOwner: TObject; aAnonEntityList: TStringList);
begin
  inherited Create(True);

  Self.FreeOnTerminate := True;
  FSQLCaller := TSQLCaller.Create(GlobalAdoConnection); // Create the SQL Caller instance
  FCompanyCode := SQLUtils.GetCompanyCode(SetDrive); // Determine the company code

  // Set the time-outs to 60 minutes
  FSQLCaller.Connection.CommandTimeout := 3600;
  FSQLCaller.Query.CommandTimeout := 3600;
  FSQLCaller.Records.CommandTimeout := 3600;

  FThreadCompleted := False;
  if Assigned(aAnonEntityList) then
    FEntityList := aAnonEntityList;
end;

//------------------------------------------------------------------------------

constructor TFileDeletionThread.Create(AOwner: TObject; AEntityCode: String; AEntityType: TAnonymisationDiaryEntity);
begin
  inherited Create(True);

  Self.FreeOnTerminate := False;
  FSQLCaller := TSQLCaller.Create(GlobalAdoConnection); // Create the SQL Caller instance
  FCompanyCode := SQLUtils.GetCompanyCode(SetDrive); // Determine the company code
  // Set the time-outs to 60 minutes
  FSQLCaller.Connection.CommandTimeout := 3600;
  FSQLCaller.Query.CommandTimeout := 3600;
  FSQLCaller.Records.CommandTimeout := 3600;

  FEntityCode := AEntityCode;
  FEntityType := AEntityType;
end;

//------------------------------------------------------------------------------
//delete all files in AList
procedure TFileDeletionThread.DeleteFiles(AList: TStringList; const ADeleteLetters, ADeleteLinks: Boolean);
var
  lFilename,
  lPath: String;
  I: Integer;
begin
  lpath := SetDrive;
  for I:= 0 to AList.Count-1 do
  begin
    lFilename := Trim(AList.Strings[I]);
    if (UpperCase(Copy(lFilename, 1, 4)) = 'DOCS') then //It's a letter
    begin
      lFilename := lPath + lFilename;
      if ADeleteLetters and FileExists(lFilename) then
        DeleteFile(PChar(lFilename));
    end
    else  //It's a link
    begin
      if not(pos(':', lFilename) > 0) then  //this is needed to be done
        lFilename := lpath + lFilename;

      if ADeleteLinks and FileExists(lFilename) then
        DeleteFile(PChar(lFilename));
    end;
  end; {for I:= 0 to AList.Count-1 do}
end;

//------------------------------------------------------------------------------

procedure TFileDeletionThread.Execute;
var
  i: Integer;
  lEntityType: TAnonymisationDiaryEntity;
  lEntityCode,
  lEntityStr: String;
  lIsDeleteFiles: Boolean;
begin
  inherited;
  //fill out the FileList from all traders
  lIsDeleteFiles := False;
  if Assigned(FEntityList) then
  begin
    for i := 0 to (FEntityList.Count - 1) do
    begin
      lEntityStr := Trim(FEntityList.Strings[i]);
      lEntityCode := LeftStr(lEntityStr, Length(lEntityStr)-2);
      lEntityType := TAnonymisationDiaryEntity(StrToIntDef(RightStr(lEntityStr, 1), 1));

      with SystemSetup.GDPR do
      begin
        if lEntityType in [adeCustomer, adeSupplier] then
          lIsDeleteFiles := (GDPRTraderAnonLettersOption = 3) or (GDPRTraderAnonLinksOption = 3);
        if lEntityType = adeEmployee then
          lIsDeleteFiles := (GDPREmployeeAnonLettersOption = 3) or (GDPREmployeeAnonLinksOption = 3);
      end;
      if lIsDeleteFiles then
        LoadFileList(Ord(lEntityType), lEntityCode);  //fill the list
    end;
  end
  else // Delete Letter and Links for Single Entity
  begin
    with SystemSetup.GDPR do
    begin
      if FEntityType in [adeCustomer, adeSupplier] then
        lIsDeleteFiles := (GDPRTraderAnonLettersOption = 3) or (GDPRTraderAnonLinksOption = 3);
      if FEntityType = adeEmployee then
        lIsDeleteFiles := (GDPREmployeeAnonLettersOption = 3) or (GDPREmployeeAnonLinksOption = 3);
    end;
    if lIsDeleteFiles then
      LoadFileList(Ord(FEntityType), FEntityCode);  //fill the list
  end;
end;

//------------------------------------------------------------------------------

procedure TFileDeletionThread.LoadFileList(const AEntityType: Integer; const AEntityCode: String);
var
  lParamList : TStringList;
  lFileNameFld: TField;
  lRes: integer;
  lErrorMsg: String;
  lQuery: String;
  lFileList: TStringList;   //file list with path
  lDeleteLetters, lDeleteLinks: Boolean;
begin
  lParamList := TStringList.Create;
  lFileList := TStringList.Create;
  try
    lFileList.Clear;
    //Initialize stored procedure parameters.
    lParamList.Values['@iv_Companies'] := FCompanyCode;
    lParamList.Values['@iv_AnonymisationType'] := IntToStr(aEntityType);
    lParamList.Values['@iv_AnonymisationCode'] := Trim(aEntityCode);

    lQuery := '[COMMON].esp_GetLetterLinkFilenames';
    lRes :=  FSQLCaller.ExecStoredProcedure(lQuery, lParamList);

    if (lRes = 0) and FSQLCaller.StoredProcedure.Active then
    begin
      lFileNameFld := FSQLCaller.StoredProcedure.FindField('Filename');
      if Assigned(lFileNameFld) then
      begin
        FSQLCaller.StoredProcedure.First;
        while not FSQLCaller.StoredProcedure.Eof do
        begin
          if lFileNameFld.AsString <> EmptyStr then
            lFileList.Add(lFileNameFld.AsString);
          FSQLCaller.StoredProcedure.Next;
        end; // while not StoredProcedure.Eof do
      end; // if Assigned(lFileNameFld) then
    end // if (lRes = 0) and FSQLCaller.StoredProcedure.Active then
    else
    begin
      lErrorMsg := FSQLCaller.ErrorMsg;
      if (lErrorMsg <> '') then
        MessageDlg('TFileDeletionThread.LoadFileList, Error LoadFileList: ' + lErrorMsg, mtError, [mbOk], 0);
    end;

    if lFileList.Count > 0 then
    begin
      if aEntityType = 3 then
      begin
        lDeleteLetters := (SystemSetup.GDPR.GDPREmployeeAnonLettersOption = 3);
        lDeleteLinks := (SystemSetup.GDPR.GDPREmployeeAnonLinksOption = 3);
      end
      else
      begin
        lDeleteLetters := (SystemSetup.GDPR.GDPRTraderAnonLettersOption = 3);
        lDeleteLinks := (SystemSetup.GDPR.GDPRTraderAnonLinksOption = 3);
      end;
      DeleteFiles(lFileList, lDeleteLetters, lDeleteLinks );
    end;
  finally
    FreeAndNil(lParamList);
    FreeAndNil(lFileList);
  end;
end;

//------------------------------------------------------------------------------

destructor TFileDeletionThread.Destroy;
begin
  FreeAndNil(FSQLCaller);
  FThreadCompleted := True;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

end.
