unit oAnonymisationDiaryObjDetail;

interface

uses
  Classes, oAnonymisationDiaryObjIntf, AdoConnect, GlobVar, SQLUtils, SQLCallerU,
  oAnonymisationDiaryBtrieveFile, oSQLLoadAnonymisationDiary, SysUtils;

type
  TAnonymisationDiaryDetail = class(TInterfacedObject, IAnonymisationDiaryDetails)
  private
    FIndex: Integer;
    FEntityName: String;
    FIsPending: Boolean;
    FAnonDiaryRec: AnonymisationDiaryRecType;
    FSelected: Boolean;
    {$IFDEF OLE}
      FOLESetDrive: String;
    {$ENDIF}
    function GetIndex: Integer;
    function GetAnonymisationDate: LongDate;
    procedure SetAnonymisationDate(AValue: LongDate);
    function GetEntityCode: String;
    procedure SetEntityCode(AValue: String);
    function GetEntityType: TAnonymisationDiaryEntity;
    procedure SetEntityType(AValue: TAnonymisationDiaryEntity);
    function GetEntityName: String;
    function GetIsPending: Boolean;
    function GetSelected: Boolean;
    procedure SetSelected(AValue: Boolean);
    //HV 27/06/2018 2017R1.1 ABSEXCH-20793: provided support for entry in anonymisation control center if user changes Account Status to from OLE.
    {$IFDEF OLE}
      function GetOLESetDrive: String;
      procedure SetOLESetDrive(AValue: String);
    {$ENDIF}
  protected
    function AddEntity: Integer; virtual; abstract;
    function RemoveEntity(aEntityType: TAnonymisationDiaryEntity;
                          aEntityCode: String): Integer; virtual; abstract;
    function GetLatestTransDate(aEntityType: TAnonymisationDiaryEntity;
                                aEntityCode: String): LongDate; virtual; abstract;
  public
    constructor Create(const AIndex: Integer;
                       const aAnonymisationDiaryRec: AnonymisationDiaryRecType;
                       const aEntityName: String;
                       const aIsPending: Boolean);
    function CalculateAnonymisationDate(aLatestDate: LongDate): LongDate;
  end; //TAnonymisationDiaryDetail

  //------------------------------------------------------------------

  TSQLAnonymisationDiaryDetail = class(TAnonymisationDiaryDetail)
  private
    FSQLCaller: TSQLCaller;
    FCompanyCode: AnsiString;
    function LoadAnonDiaryData: Boolean;
  protected
    function AddEntity: Integer; override;
    function RemoveEntity(aEntityType: TAnonymisationDiaryEntity;
                          aEntityCode: String): Integer; override;
    function GetLatestTransDate(aEntityType: TAnonymisationDiaryEntity;
                                aEntityCode: String): LongDate; override;

  public
    constructor Create(const AIndex: Integer;
                       const aAnonymisationDiaryRec: AnonymisationDiaryRecType;
                       const aEntityName: String;
                       const aIsPending: Boolean);
    destructor Destroy; override;
  end; //TSQLAnonymisationDiaryDetail

  //------------------------------------------------------------------

  TPervasiveAnonymisationDiaryDetail = class(TAnonymisationDiaryDetail)
  protected
    function AddEntity: Integer; override;
    function RemoveEntity(aEntityType: TAnonymisationDiaryEntity;
                          aEntityCode: String): Integer; override;
    function GetLatestTransDate(aEntityType: TAnonymisationDiaryEntity;
                                aEntityCode: String): LongDate; override;
    function GetTimeSheetLatestTransDate(aEntityCode: String): LongDate;
  public
    constructor Create(const AIndex: Integer;
                       const aAnonymisationDiaryRec: AnonymisationDiaryRecType;
                       const aEntityName: String;
                       const aIsPending: Boolean);
  end; //TPervasiveAnonymisationDiaryDetail

  //------------------------------------------------------------------

//Create Single AnonymisationObj
function CreateAnonymisationObj(const AIndex: Integer;
                                const aAnonymisationDiaryRec: AnonymisationDiaryRecType;
                                const aEntityName: String = '';
                                const aIsPending: Boolean = False): TAnonymisationDiaryDetail;


//Also Create Single AnonymisationObj but require only single parameter
//this function will intially call CreateAnonymisationObj function.
function CreateSingleAnonObj: TAnonymisationDiaryDetail;

procedure ReNameEntityCode(const aEntityType: TAnonymisationDiaryEntity;
                           const aEntityOldCode, aEntityNewCode: String);

implementation

Uses ETDateU, BtrvU2, VarConst, Dialogs, BtKeys1U, DateUtils, oSystemSetup,
     SysU3, StrUtils, DB, BTSupU1;

//------------------------------------------------------------------------------

function CreateAnonymisationObj(const AIndex: Integer;
                                const aAnonymisationDiaryRec: AnonymisationDiaryRecType;
                                const aEntityName: String = '';
                                const aIsPending: Boolean = False): TAnonymisationDiaryDetail;
begin
  if SQLUtils.UsingSQL then
    Result := TSQLAnonymisationDiaryDetail.Create(AIndex, aAnonymisationDiaryRec, aEntityName, aIsPending)
  else
    Result := TPervasiveAnonymisationDiaryDetail.Create(AIndex, aAnonymisationDiaryRec, aEntityName, aIsPending);
end;

//------------------------------------------------------------------------------

function CreateSingleAnonObj: TAnonymisationDiaryDetail;
var
  lAnonDiaryRec: AnonymisationDiaryRecType;
begin
  FillChar(lAnonDiaryRec, SizeOf(lAnonDiaryRec), #0);
  Result := CreateAnonymisationObj(0, lAnonDiaryRec);
end;

procedure ReNameEntityCode(const aEntityType: TAnonymisationDiaryEntity;
                           const aEntityOldCode, aEntityNewCode: String);
var
  lKeyS: Str255;
  lStatus: Integer;
  lAnonDiaryBtrvFile: TAnonymisationDiaryBtrieveFile;
  lSQLCaller: TSQLCaller;
  lQuery,
  lCompanyCode: String;
begin
  if SQLUtils.UsingSQL then
  begin
    lSQLCaller := TSQLCaller.Create(GlobalADOConnection);
    lCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
    try
      lQuery := 'Update [COMPANY].ANONYMISATIONDIARY Set adEntityCode = ' + QuotedStr(Trim(aEntityNewCode)) +
                ' WHERE adEntityType = ' + QuotedStr(IntToStr(ord(aEntityType))) +
                ' AND adEntityCode = ' + QuotedStr(Trim(aEntityOldCode));
      lSQLCaller.ExecSQL(lQuery, lCompanyCode);
    finally
      lSQLCaller.Close;
      FreeAndNil(lSQLCaller);
    end;
  end
  else
  begin
    lAnonDiaryBtrvFile := TAnonymisationDiaryBtrieveFile.Create;
    try
      if (lAnonDiaryBtrvFile.OpenFile(IncludeTrailingPathDelimiter(SetDrive)+ AnonymisationDiaryFileName) = 0) then
      begin
        lKeyS := lAnonDiaryBtrvFile.BuildTypeCodeKey(aEntityType, aEntityOldCode);
        lStatus := lAnonDiaryBtrvFile.GetEqual(lKeyS);
        if lStatus = 0 then
        begin
          with lAnonDiaryBtrvFile.AnonymisationDiary do
            adEntityCode := lAnonDiaryBtrvFile.PadEntityCode(aEntityNewCode);

          lAnonDiaryBtrvFile.Update;
        end;

      end;
    finally
      lAnonDiaryBtrvFile.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------
{ TAnonymisationDiaryDetail }
//------------------------------------------------------------------------------

function TAnonymisationDiaryDetail.CalculateAnonymisationDate(aLatestDate: LongDate): LongDate;
var
  lLatestTransDate: TDateTime;
  lFinancialStartDate: TDateTime;
  lAnonymisationDate: TDateTime;
begin
  lLatestTransDate := StrToDate(POutDate(aLatestDate));
  lFinancialStartDate := StrToDate(POutDate(Syss.MonWk1));

  if (MonthOf(lLatestTransDate) <> MonthOf(lFinancialStartDate)) then
  begin
    if MonthOf(lLatestTransDate) < MonthOf(lFinancialStartDate) then  //If Period is before fiscal year
      lAnonymisationDate := EncodeDate(YearOf(lLatestTransDate), MonthOf(lFinancialStartDate), DayOf(lFinancialStartDate))
    else
      lAnonymisationDate := EncodeDate(YearOf(lLatestTransDate)+1, MonthOf(lFinancialStartDate), DayOf(lFinancialStartDate));
  end
  else  //Check dates when period is same
  begin
    if DayOf(lLatestTransDate) < DayOf(lFinancialStartDate) then
      lAnonymisationDate := EncodeDate(YearOf(lLatestTransDate), MonthOf(lFinancialStartDate), DayOf(lFinancialStartDate))
    else
      lAnonymisationDate := EncodeDate(YearOf(lLatestTransDate)+1, MonthOf(lFinancialStartDate), DayOf(lFinancialStartDate));
  end;

  case FAnonDiaryRec.adEntityType of
    adeCustomer,
    adeSupplier : lAnonymisationDate := IncYear(lAnonymisationDate, SystemSetup(True).GDPR.GDPRTraderRetentionPeriod);

    adeEmployee : lAnonymisationDate := IncYear(lAnonymisationDate, SystemSetup(True).GDPR.GDPREmployeeRetentionPeriod);
  end;
  Result := FormatDateTime('yyyymmdd',lAnonymisationDate);
end;

//------------------------------------------------------------------------------

constructor TAnonymisationDiaryDetail.Create(const AIndex: Integer;
                                             const aAnonymisationDiaryRec: AnonymisationDiaryRecType;
                                             const aEntityName: String;
                                             const aIsPending: Boolean);
begin
  inherited Create;
  FIndex := AIndex;
  FAnonDiaryRec := aAnonymisationDiaryRec;
  FEntityName := aEntityName;
  FIsPending := aIsPending;
  FSelected := False;
end;

//------------------------------------------------------------------------------

function TAnonymisationDiaryDetail.GetAnonymisationDate: LongDate;
begin
  Result := FAnonDiaryRec.adAnonymisationDate;
end;

//------------------------------------------------------------------------------

function TAnonymisationDiaryDetail.GetEntityCode: String;
begin
  Result := FAnonDiaryRec.adEntityCode;
end;

//------------------------------------------------------------------------------

function TAnonymisationDiaryDetail.GetEntityName: String;
begin
  Result := FEntityName;
end;

//------------------------------------------------------------------------------

function TAnonymisationDiaryDetail.GetEntityType: TAnonymisationDiaryEntity;
begin
  Result := FAnonDiaryRec.adEntityType;
end;

//------------------------------------------------------------------------------

function TAnonymisationDiaryDetail.GetIndex: Integer;
begin
  Result := FIndex;
end;

//------------------------------------------------------------------------------

function TAnonymisationDiaryDetail.GetIsPending: Boolean;
begin
  Result := FIsPending;
end;

procedure TAnonymisationDiaryDetail.SetAnonymisationDate(AValue: LongDate);
begin
  FAnonDiaryRec.adAnonymisationDate := AValue;
end;

//------------------------------------------------------------------------------

procedure TAnonymisationDiaryDetail.SetEntityCode(AValue: String);
begin
  FAnonDiaryRec.adEntityCode := AValue;
end;

//------------------------------------------------------------------------------

procedure TAnonymisationDiaryDetail.SetEntityType(AValue: TAnonymisationDiaryEntity);
begin
  FAnonDiaryRec.adEntityType := AValue;
end;

//------------------------------------------------------------------------------

function TAnonymisationDiaryDetail.GetSelected: Boolean;
begin
  Result := FSelected
end;

//------------------------------------------------------------------------------

procedure TAnonymisationDiaryDetail.SetSelected(AValue : Boolean);
begin
  FSelected := AValue;
end;

//------------------------------------------------------------------------------
{ TSQLAnonymisationDiaryDetail }
//------------------------------------------------------------------------------

constructor TSQLAnonymisationDiaryDetail.Create(const AIndex: Integer;
                                                const aAnonymisationDiaryRec: AnonymisationDiaryRecType;
                                                const aEntityName: String;
                                                const aIsPending: Boolean);
begin
  FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
  FSQLCaller := TSQLCaller.Create(GlobalAdoConnection);
  inherited Create(AIndex, aAnonymisationDiaryRec, aEntityName, aIsPending);
end;

//------------------------------------------------------------------------------

destructor TSQLAnonymisationDiaryDetail.Destroy;
begin
  FreeAndNil(FSQLCaller);
  inherited;
end;

//------------------------------------------------------------------------------

function TSQLAnonymisationDiaryDetail.LoadAnonDiaryData: Boolean;
var
  loLoadAnonymisationDiary: TSQLLoadAnonymisationDiary;
  lRes: Integer;
begin
  Result := False;
  if Assigned(FSQLCaller) then
  begin
    //Refresh the anonymisation diary and update call to check for changes
    loLoadAnonymisationDiary := TSQLLoadAnonymisationDiary.Create(FSQLCaller);
    try
      lRes := loLoadAnonymisationDiary.ReadData();
      if lRes = 0 then
      begin
        lRes := loLoadAnonymisationDiary.GetFirst;
        if lRes = 0 then
        begin
          FAnonDiaryRec := loLoadAnonymisationDiary.AnonymisationDiaryRec;
          Result := True;
        end;
      end;
    finally
      loLoadAnonymisationDiary.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TSQLAnonymisationDiaryDetail.AddEntity: Integer;
var
  lQuery: AnsiString;
  lLatestTransDate: LongDate;
begin
  Result := -1;

  //HV 27/06/2018 2017R1.1 ABSEXCH-20793: provided support for entry in anonymisation control center if user changes Account Status to from OLE.
  {$IFDEF OLE}
    SetDrive := FOLESetDrive;
    FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
    ResetConnection(SetDrive);
  {$ENDIF}

  //check if a record already exists for that Entity before adding
  lQuery := 'SELECT adEntityCode FROM [COMPANY].ANONYMISATIONDIARY ' +
            'WHERE adEntityCode = ' + QuotedStr(Trim(FAnonDiaryRec.adEntityCode)) +
            ' AND adEntityType = ' + IntToStr(ord(FAnonDiaryRec.adEntityType));           //SSK 12/02/2018 2018 R1 ABSEXCH-19747: included EntityType in condition to avoid clashes with same AccountCode belongs to different AccountType (e.g Employee and Customer)

  if Assigned(FSQLCaller) then
  begin
    FSQLCaller.Select(lQuery, FCompanyCode);

    if (FSQLCaller.ErrorMsg = '') and (FSQLCaller.Records.RecordCount > 0) then
      Exit;
    FSQLCaller.Close;
  end;

  lLatestTransDate := GetLatestTransDate(FAnonDiaryRec.adEntityType, Trim(FAnonDiaryRec.adEntityCode));
  if lLatestTransDate = EmptyStr then
    FAnonDiaryRec.adAnonymisationDate := FormatDateTime('yyyymmdd', Today)
  else
    FAnonDiaryRec.adAnonymisationDate := CalculateAnonymisationDate(lLatestTransDate);
  lQuery := 'INSERT INTO [COMPANY].ANONYMISATIONDIARY ' +
              '(' +
                'adEntityType, ' +
                'adEntityCode, ' +
                'adAnonymisationDate' +
              ')' +
            'VALUES ' +
              '(' +
                IntToStr(Ord(FAnonDiaryRec.adEntityType)) + ', ' +
                QuotedStr(FAnonDiaryRec.adEntityCode) + ', ' +
                QuotedStr(FAnonDiaryRec.adAnonymisationDate) +
              ')';
  Result := FSQLCaller.ExecSQL(lQuery, FCompanyCode);
end;

//------------------------------------------------------------------------------

function TSQLAnonymisationDiaryDetail.RemoveEntity(aEntityType: TAnonymisationDiaryEntity; aEntityCode: String): Integer;
var
  lSQLCaller: TSQLCaller;
  lQuery,
  lCompanyCode: String;
begin
  Result := -1;
  //HV 27/06/2018 2017R1.1 ABSEXCH-20793: provided support for entry in anonymisation control center if user changes Account Status to from OLE.
  {$IFDEF OLE}
    SetDrive := FOLESetDrive;
    ResetConnection(SetDrive);
  {$ENDIF}

  lSQLCaller := TSQLCaller.Create(GlobalADOConnection);
  lCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
  try
    lQuery := 'Delete From [COMPANY].ANONYMISATIONDIARY ' +
              'WHERE adEntityType = ' + QuotedStr(IntToStr(ord(aEntityType))) + ' '+
              'AND adEntityCode = ' + QuotedStr(aEntityCode);
    Result := lSQLCaller.ExecSQL(lQuery, lCompanyCode);
  finally
    lSQLCaller.Close;
    FreeAndNil(lSQLCaller);
  end;
end;

//------------------------------------------------------------------------------

function TSQLAnonymisationDiaryDetail.GetLatestTransDate(aEntityType: TAnonymisationDiaryEntity;
                                                         aEntityCode: String): LongDate;
var
  lSQLQuery: AnsiString;
  fldLastTransactionDate: TStringField;
  lWhereClause: String;
  //-------------------------------------
  procedure PrepareFields;
  begin
    with FSQLCaller.Records do
    begin
      fldLastTransactionDate := FieldByName('LastTransactionDate') as TStringField;
    end;
  end;
  //-------------------------------------
begin
  Result := EmptyStr;
  if aEntityType = adeCustomer then
    lWhereClause := 'WHERE (thDocType In (0,1,2,3,4,5,6,7,8,9,44,49)) AND (thAcCode = ' + QuotedStr(aEntityCode) + ') '  //JST - 47
  else if aEntityType = adeSupplier then
    lWhereClause := 'WHERE (thDocType In (15,16,17,18,19,20,21,22,23,24,41,45,50)) AND ' +
                    '((thAcCode = ' + QuotedStr(aEntityCode) + ') OR ' +
                    '(thBatchLinkTrans In (Select var_code1Trans1 FROM [COMPANY].JOBMISC ' +
                                          'WHERE RecPfix=''J'' and SubType=''E'' and EType = 2 and var_code4=' + QuotedStr(aEntityCode) +'))) ' ; //TSH-41
  //Build query based on traders/employee
  case aEntityType of
    adeCustomer,
    adeSupplier : begin
                    lSQLQuery := 'SELECT CASE WHEN (MaxTransDate >= MaxDueDate) THEN MaxTransDate ELSE MaxDueDate END As ' + QuotedStr('LastTransactionDate') + ' ' +
                                 'FROM ( SELECT Max(thTransDate) As ' + QuotedStr('MaxTransDate') + ', ' +
                                               'Max(thDueDate) As ' + QuotedStr('MaxDueDate') + ' ' +
                                        'FROM [COMPANY].DOCUMENT ' + lWhereClause + ') As QueryData';

                  end;
    adeEmployee : begin  //HV ABSEXCH-19615: Transactions to be considered to get latest transaction date for Employee. Transaction to include : JPA, TSH
                    lSQLQuery := 'SELECT CASE WHEN (MaxTransDate >= MaxDueDate) THEN MaxTransDate ELSE MaxDueDate END As ' + QuotedStr('LastTransactionDate') + ' ' +
                                 'FROM ( SELECT Max(thTransDate) As ' + QuotedStr('MaxTransDate') + ', ' +
                                               'Max(thDueDate) As ' + QuotedStr('MaxDueDate') + ' ' +
                                        'FROM [COMPANY].DOCUMENT ' +
                                        'WHERE (thDocType In (41, 50)) ' +
                                        'AND ((thBatchLinkTrans = ' + QuotedStr(aEntityCode) + ') OR (SUBSTRING(thBatchLink, 3, 6) = '+ QuotedStr(aEntityCode) +'))' +
                                       ') As QueryData';
                  end;
  end; {case}

  if Assigned(FSQLCaller) then
  begin
    FSQLCaller.Select(lSQLQuery, FCompanyCode);
    if FSQLCaller.Records.RecordCount > 0 then
    begin
      PrepareFields;
      FSQLCaller.Records.First;
      Result := fldLastTransactionDate.Value;
    end;
  end
  else
    raise Exception.Create('SQLCaller instance not initialized');
end;

//------------------------------------------------------------------------------
{ TPervasiveAnonymisationDiaryDetail }
//------------------------------------------------------------------------------

constructor TPervasiveAnonymisationDiaryDetail.Create(const AIndex: Integer;
                                                      const aAnonymisationDiaryRec: AnonymisationDiaryRecType;
                                                      const aEntityName: String;
                                                      const aIsPending: Boolean);
begin
  inherited Create(AIndex, aAnonymisationDiaryRec, aEntityName, aIsPending);
end;

//------------------------------------------------------------------------------

function TPervasiveAnonymisationDiaryDetail.AddEntity: Integer;
var
  lAnonDiaryBtrvFile: TAnonymisationDiaryBtrieveFile;
  lLatestTransDate: LongDate;
begin
  Result := 23;
  lAnonDiaryBtrvFile := TAnonymisationDiaryBtrieveFile.Create;
  //HV 27/06/2018 2017R1.1 ABSEXCH-20793: provided support for entry in anonymisation control center if user changes Account Status to from OLE.
  {$IFDEF OLE}
    SetDrive := FOLESetDrive;
    Open_System(InvF, InvF);
  {$ENDIF}
  try
    if (lAnonDiaryBtrvFile.OpenFile(IncludeTrailingPathDelimiter(SetDrive) + AnonymisationDiaryFileName) = 0) then
    begin
      lAnonDiaryBtrvFile.InitialiseRecord;
      with lAnonDiaryBtrvFile.AnonymisationDiary do
      begin
        adEntityType := FAnonDiaryRec.adEntityType;
        adEntityCode := lAnonDiaryBtrvFile.PadEntityCode(FAnonDiaryRec.adEntityCode);

        lLatestTransDate := GetLatestTransDate(FAnonDiaryRec.adEntityType, Trim(FAnonDiaryRec.adEntityCode));
        if lLatestTransDate = EmptyStr then
          FAnonDiaryRec.adAnonymisationDate := FormatDateTime('yyyymmdd', Today)
        else
          FAnonDiaryRec.adAnonymisationDate := CalculateAnonymisationDate(lLatestTransDate);
        adAnonymisationDate := FAnonDiaryRec.adAnonymisationDate;
      end;
      Result := lAnonDiaryBtrvFile.Insert;
    end;
  finally
    {$IFDEF OLE}
      Close_File(F[InvF]);
    {$ENDIF}
    lAnonDiaryBtrvFile.Free;
  end;
end;

//------------------------------------------------------------------------------

function TPervasiveAnonymisationDiaryDetail.RemoveEntity(aEntityType: TAnonymisationDiaryEntity;
                                                         aEntityCode: String): Integer;
var
  lKeyS: Str255;
  lStatus: Integer;
  lAnonDiaryBtrvFile: TAnonymisationDiaryBtrieveFile;
begin
  Result := 23;
  {$IFDEF OLE}
    SetDrive := FOLESetDrive;
  {$ENDIF}
  lAnonDiaryBtrvFile := TAnonymisationDiaryBtrieveFile.Create;
  try
    if (lAnonDiaryBtrvFile.OpenFile(IncludeTrailingPathDelimiter(SetDrive)+ AnonymisationDiaryFileName) = 0) then
    begin
      lKeyS := lAnonDiaryBtrvFile.BuildTypeCodeKey(aEntityType, aEntityCode);
      lStatus := lAnonDiaryBtrvFile.GetEqual(lKeyS);
      if lStatus = 0 then
        Result := lAnonDiaryBtrvFile.Delete;
    end;
  finally
    lAnonDiaryBtrvFile.Free;
  end;
end;

//------------------------------------------------------------------------------

function TPervasiveAnonymisationDiaryDetail.GetLatestTransDate(aEntityType: TAnonymisationDiaryEntity;
                                                               aEntityCode: String): LongDate;
var
  lKeyS,
  lKeyRef: Str255;
  lRes: Integer;
  lLatestTransDate,
  lTSATransDate: LongDate;
  FoundOk : Boolean;
  procedure CheckTraderOtherTrans(AKeyS: Str255);
  begin
    lLatestTransDate := '';
    lKeyRef := AKeyS;
    lKeyS := lKeyRef;
    lRes := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvCustLedgK, lKeyS);
    if (lRes = 0) and (CheckKey(lKeyRef, lKeyS, Length(lKeyRef), BOn)) then
      lLatestTransDate := Inv.TransDate;
    while (lRes = 0) and (CheckKey(lKeyRef, lKeyS, Length(lKeyRef), BOn)) do
    begin
      if CompareDate(StrToDate(POutDate(Inv.TransDate)), StrToDate(POutDate(lLatestTransDate))) > 0 then
        lLatestTransDate := Inv.TransDate;
      if CompareDate(StrToDate(POutDate(Inv.DueDate)), StrToDate(POutDate(lLatestTransDate))) > 0 then
        lLatestTransDate := Inv.DueDate;
      lRes := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvCustLedgK, lKeyS);
    end;
    if lLatestTransDate <> '' then
    begin
      if Result = '' then
        Result := lLatestTransDate;
      if CompareDate(StrToDate(POutDate(lLatestTransDate)), StrToDate(POutDate(Result))) > 0 then
        Result := lLatestTransDate;
    end;
  end;
begin
  Result := EmptyStr;
  lLatestTransDate := EmptyStr;
  lTSATransDate := EmptyStr;
  aEntityCode := Trim(aEntityCode);
  case aEntityType of
    adeCustomer,
    adeSupplier : begin //Latest TransDate
                    case aEntityType of
                      adeCustomer : lKeyS := FullCustCode(aEntityCode) + 'C' + Chr(1) + '9';
                      adeSupplier : lKeyS := FullCustCode(aEntityCode) + 'S' + Chr(1) + '9';
                    end;
                    lRes := Find_Rec(B_GetLess, F[InvF], InvF, RecPtr[InvF]^, InvCustLedgK, lKeyS);
                    //LatestDueDate
                    if (lRes = 0) and (Trim(Inv.CustCode)= aEntityCode) and (Inv.InvDocHed <> JCT) then //If no result found then cust/supp does not have any transactions
                    begin
                      lLatestTransDate := Inv.TransDate;
                      //Get Due Date from Document
                      case aEntityType of
                        adeCustomer : lKeyS := 'C' + FullCustCode(aEntityCode) + NDxWeight;
                        adeSupplier : lKeyS := 'S' + FullCustCode(aEntityCode) + NDxWeight;
                      end;
                      FoundOk := False;
                      lRes := Find_Rec(B_GetLess, F[InvF], InvF, RecPtr[InvF]^, InvCDueK, lKeyS);
                      while (lRes=0) and (not FoundOk) do
                      begin
                        if Trim(Inv.CustCode)= aEntityCode then
                          FoundOk := True;
                        if not FoundOk then
                          lRes:=Find_Rec(B_GetPrev, F[InvF], InvF, RecPtr[InvF]^, InvCDueK, lKeyS);
                      end;
                      if FoundOk then
                      begin
                        if CompareDate(StrToDate(POutDate(lLatestTransDate)), StrToDate(POutDate(Inv.DueDate))) < 0 then
                          Result := Inv.DueDate
                        else
                          Result := lLatestTransDate;
                      end
                      else
                        Result := lLatestTransDate;
                    end;
                    // Check Other Transcations
                    if aEntityType = adeCustomer then
                    begin
                      //JSA from Job > Sales applications
                      CheckTraderOtherTrans(FullCustCode(aEntityCode) + 'J' + Chr(1));
                      //SOR and SDN
                      CheckTraderOtherTrans(FullCustType(aEntityCode, Char(Succ(Ord('C')))) + Chr(1));
                      //SRN
                      CheckTraderOtherTrans(FullCustType(aEntityCode, Ret_CustSupp(SRN)) + Chr(1));
                    end
                    else if aEntityType = adeSupplier then //JPA, TSH of sub contractors(if any).
                    begin
                      //PDN and POR
                      CheckTraderOtherTrans(FullCustType(aEntityCode, Char(Succ(Ord('S')))) + Chr(1));
                      //PRN
                      CheckTraderOtherTrans(FullCustType(aEntityCode, Ret_CustSupp(PRN)) + Chr(1));
                      //JPA
                      CheckTraderOtherTrans(FullCustType(aEntityCode, 'J') + Chr(1));
                      //TimeSheet
                      {$IFDEF JC}
                        lTSATransDate := GetTimeSheetLatestTransDate(aEntityCode);
                        if lTSATransDate <> '' then
                        begin
                          if Result = '' then
                            Result := lTSATransDate;
                          if CompareDate(StrToDate(POutDate(lTSATransDate)), StrToDate(POutDate(Result))) > 0 then
                            Result := lTSATransDate;
                        end;
                      {$ENDIF}
                    end;
                  end;
    adeEmployee : begin
                    //TimeSheet
                    {$IFDEF JC}
                      lKeyS := FullNCode(aEntityCode);
                      lRes := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvBatchK, lKeyS);
                      //Compare dates to find latest date
                      if (lRes = 0) and (CheckKey(aEntityCode, lKeyS, Length(aEntityCode), BOn)) then
                        lLatestTransDate := Inv.TransDate;
                      while (lRes = 0) and (CheckKey(aEntityCode, lKeyS, Length(aEntityCode), BOn)) do
                      begin
                        if CompareDate(StrToDate(POutDate(Inv.TransDate)), StrToDate(POutDate(lLatestTransDate))) > 0 then
                          lLatestTransDate := Inv.TransDate;
                        lRes := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvBatchK, lKeyS);
                      end;
                    {$ENDIF}

                    //Applications  JPA
                    lKeyRef := #6 + FullNCode(aEntityCode);
                    lKeyS := lKeyRef;
                    lRes := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvBatchK, lKeyS);
                    if (lRes = 0) and (lLatestTransDate = EmptyStr)  and (CheckKey(lKeyRef, lKeyS, Length(lKeyRef), BOn)) then
                      lLatestTransDate := Inv.TransDate;
                    //Compare dates to find latest date
                    while (lRes = 0) and (CheckKey(lKeyRef, lKeyS, Length(lKeyRef), BOn)) do
                    begin
                      if CompareDate(StrToDate(POutDate(Inv.TransDate)), StrToDate(POutDate(lLatestTransDate))) > 0 then
                        lLatestTransDate := Inv.TransDate;
                      if CompareDate(StrToDate(POutDate(Inv.DueDate)), StrToDate(POutDate(lLatestTransDate))) > 0 then
                        lLatestTransDate := Inv.DueDate;
                      lRes := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvBatchK, lKeyS);
                    end;
                    Result := lLatestTransDate;
                  end; {adeEmployee}
  end;  {case aEntityType of}
end;

//------------------------------------------------------------------------------

function TPervasiveAnonymisationDiaryDetail.GetTimeSheetLatestTransDate(aEntityCode: String): LongDate;
var
  lKeyS,
  lEmpKeyS : Str255;
  lRes,
  lEmpRes: Integer;
  lEmpCode: String;
  lLatestTransDate: LongDate;
begin
  lLatestTransDate := EmptyStr;
  
  lKeyS := PartCCKey(JARCode, JASubAry[3]);
  lEmpRes := Find_Rec(B_GetFirst, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, lKeyS);
  while (lEmpRes = 0) do
  begin
    if (JobMisc.EmplRec.EType = 2) and
       (JobMisc.EmplRec.emAnonymisationStatus <> asAnonymised) and
       (Trim(JobMisc.EmplRec.Supplier) = aEntityCode) then
    begin
      //TimeSheet
      lEmpCode := Trim(JobMisc.EmplRec.EmpCode);
      lEmpKeyS := FullNCode(Trim(lEmpCode));
      lRes := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvBatchK, lEmpKeyS);
      //Compare dates to find latest date
      if (lRes = 0) and (lLatestTransDate = '') and (CheckKey(lEmpCode, lEmpKeyS, Length(lEmpCode), BOn)) then
        lLatestTransDate := Inv.TransDate;
      while (lRes = 0) and (CheckKey(lEmpCode, lEmpKeyS, Length(lEmpCode), BOn)) do
      begin
        if CompareDate(StrToDate(POutDate(Inv.TransDate)), StrToDate(POutDate(lLatestTransDate))) > 0 then
          lLatestTransDate := Inv.TransDate;
        lRes := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvBatchK, lEmpKeyS);
      end;
    end;
    lEmpRes := Find_Rec(B_GetNext, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, lKeyS);
  end; //while (lEmpRes = 0) do
  Result := lLatestTransDate;
end;

//------------------------------------------------------------------------------
//HV 27/06/2018 2017R1.1 ABSEXCH-20793: provided support for entry in anonymisation control center if user changes Account Status to from OLE.
{$IFDEF OLE}

function TAnonymisationDiaryDetail.GetOLESetDrive: String;
begin
  Result := FOLESetDrive;
end;

//------------------------------------------------------------------------------

procedure TAnonymisationDiaryDetail.SetOLESetDrive(AValue: String);
begin
  FOLESetDrive := AValue;
end;

{$ENDIF}

//------------------------------------------------------------------------------

end.
