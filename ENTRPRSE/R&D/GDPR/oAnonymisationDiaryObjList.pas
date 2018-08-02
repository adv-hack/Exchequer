unit oAnonymisationDiaryObjList;

interface

uses Classes, oAnonymisationDiaryObjIntf, SysUtils, oAnonymisationDiaryObjDetail,
     Dialogs, AnonymiseUtil;

function AnonymisationDiaryDetailList(const AForceRefresh: Boolean = False): IAnonymisationDiaryDetailList;

implementation

uses
  DB, ADOConnect, SQLUtils, oSQLLoadAnonymisationDiary, oAnonymisationDiaryBtrieveFile,
  GlobVar, BtKeys1U, VarConst, Btrvu2, StrUtils, JobSup1U, ETDateU, SQLCallerU,
  DateUtils, PWarnU, UA_Const;

type
  TBaseAnonymisationDiaryDetailList = class(TInterfacedObject, IAnonymisationDiaryDetailList)
  private
    FAnonDiaryDetailList: TInterfaceList; //Internal list to store the IAnonymisationDiaryDetails objects
    FAnonymiseEntityList: TStringList; 
    // IAnonymisationDiaryDetailList methods
    function GetCount: Integer;
    function GetAnonymisationDiaryObj(AIndex: Integer): IAnonymisationDiaryDetails;
    function FindEntiyByIndex(AIndex: Integer): IAnonymisationDiaryDetails;
    function FindAnonObjByEntityCode(AEntityCode: String): IAnonymisationDiaryDetails;
    procedure Refresh; // Reloads the cached User
    procedure Anonymise(const AOwner: TObject);
    procedure AddLinkedEmployeesForAnonymise(const ACustCode: String; var AList: TStringList);
  protected
    procedure Clear;
    procedure AddAnonDiaryToList(AIndex: Integer; aAnonDiaryRec: AnonymisationDiaryRecType);
    procedure PopulateList; virtual; abstract;
    procedure AnonymiseEntity(const AOwner: TObject); virtual; abstract;
    function GetEntityName(aCode: String; aType: TAnonymisationDiaryEntity): String;
    function IsEntityHasPermission(const aEntityType: TAnonymisationDiaryEntity): Boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end; //TBaseAnonymisationDiaryDetailList

  //------------------------------------------------------------------
  TSQLAnonymisationDiaryList = class(TBaseAnonymisationDiaryDetailList)
  protected
    procedure PopulateList; override;
    procedure AnonymiseEntity(const AOwner: TObject); override;
  public

  end; //TSQLAnonymisationDiaryList

  //------------------------------------------------------------------
  TPervasiveAnonymisationDiaryList = class(TBaseAnonymisationDiaryDetailList)
  private
    FAnonDiaryBtrvFile : TAnonymisationDiaryBtrieveFile;
  protected
    procedure PopulateList; override;
    procedure AnonymiseEntity(const AOwner: TObject); override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end; //TPervasiveAnonymisationDiaryList
  //------------------------------------------------------------------

var
  AnonDiaryListIntf: IAnonymisationDiaryDetailList;

//------------------------------------------------------------------------------
{Load All Record from Database and store in to Interface List}
function AnonymisationDiaryDetailList(const AForceRefresh: Boolean = False): IAnonymisationDiaryDetailList;
begin
  // create a new singleton
  if (not Assigned(AnonDiaryListIntf)) then
  begin
    // Create the correct version for the data edition
    if SQLUtils.UsingSQL then
      AnonDiaryListIntf := TSQLAnonymisationDiaryList.Create
    else
      AnonDiaryListIntf := TPervasiveAnonymisationDiaryList.Create;

    // Load the data
    AnonDiaryListIntf.Refresh;
  end
  else
  begin
    // Check to see if the data should be refreshed
    if AForceRefresh then
      AnonDiaryListIntf.Refresh;
  end;
  Result := AnonDiaryListIntf;
end;

//------------------------------------------------------------------------------
{ TBaseAnonymisationDiaryDetailList }
//------------------------------------------------------------------------------

procedure TBaseAnonymisationDiaryDetailList.AddAnonDiaryToList(AIndex: Integer;
                                                               aAnonDiaryRec: AnonymisationDiaryRecType);
var
  lEntityName: String;
  lIsPending: Boolean;
begin
  //Populate EntityName and IsPending from here?
  lEntityName := Trim(GetEntityName(aAnonDiaryRec.adEntityCode, aAnonDiaryRec.adEntityType));
  lIsPending := CompareDate(StrToDate(POutDate(aAnonDiaryRec.adAnonymisationDate)), Today) > 0;
  FAnonDiaryDetailList.Add(CreateAnonymisationObj(AIndex, aAnonDiaryRec, lEntityName, lIsPending));
end;

//------------------------------------------------------------------------------

procedure TBaseAnonymisationDiaryDetailList.Clear;
begin
  if Assigned(FAnonDiaryDetailList) then
    FAnonDiaryDetailList.Clear;
end;

//------------------------------------------------------------------------------

constructor TBaseAnonymisationDiaryDetailList.Create;
begin
  inherited Create;
  FAnonDiaryDetailList := TInterfaceList.Create;
  FAnonymiseEntityList := TStringList.Create;
end;

//------------------------------------------------------------------------------

destructor TBaseAnonymisationDiaryDetailList.Destroy;
begin
  Clear;
  if assigned(FAnonymiseEntityList) then
    FreeAndNil(FAnonymiseEntityList);
  FreeAndNil(FAnonDiaryDetailList);
  inherited;
end;

//------------------------------------------------------------------------------

function TBaseAnonymisationDiaryDetailList.FindAnonObjByEntityCode(AEntityCode: String): IAnonymisationDiaryDetails;
var
  i: Integer;
begin
  Result := Nil;
  //Search through list
  for i := 0 to FAnonDiaryDetailList.Count - 1 do
  begin
    if (FAnonDiaryDetailList[i] as IAnonymisationDiaryDetails).adEntityCode = AEntityCode then
    begin
      //We got the entry so return the entry and stop the loop
      Result := FAnonDiaryDetailList[i] as IAnonymisationDiaryDetails;
      Break;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TBaseAnonymisationDiaryDetailList.FindEntiyByIndex(AIndex: Integer): IAnonymisationDiaryDetails;
var
  i: Integer;
begin
  Result := Nil;
  //Search through list
  for i := 0 to FAnonDiaryDetailList.Count - 1 do
  begin
    if (FAnonDiaryDetailList[i] as IAnonymisationDiaryDetails).adIndex = AIndex then
    begin
      //We got the entry so return the entry and stop the loop
      Result := FAnonDiaryDetailList[i] as IAnonymisationDiaryDetails;
      Break;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TBaseAnonymisationDiaryDetailList.GetAnonymisationDiaryObj(AIndex: Integer): IAnonymisationDiaryDetails;
begin
  if (AIndex >= 0) and (AIndex < FAnonDiaryDetailList.Count) then
    Result := FindEntiyByIndex(AIndex)
  else
    raise Exception.Create('TBaseAnonymisationDiaryDetailList.GetAnonymisationDiaryObj: Invalid Index ' +
          '(Index=' + IntToStr(AIndex) + ', Count=' + IntToStr(FAnonDiaryDetailList.Count) + ')');
end;

//------------------------------------------------------------------------------

function TBaseAnonymisationDiaryDetailList.GetCount: Integer;
begin
  Result := FAnonDiaryDetailList.Count;
end;

//------------------------------------------------------------------------------

procedure TBaseAnonymisationDiaryDetailList.Refresh;
begin
  Clear;
  PopulateList;
end;

//------------------------------------------------------------------------------

function TBaseAnonymisationDiaryDetailList.GetEntityName(aCode: String;
                                                        aType: TAnonymisationDiaryEntity): String;
var
  lKeyS: Str255;
  lStatus: Integer;
begin
  Result := '';
  case aType of
    adeCustomer,
    adeSupplier : begin
                    lKeyS := FullCustCode(aCode);
                    lStatus := Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, lKeyS);
                    if lStatus = 0 then
                      Result := Cust.Company;
                  end;
    adeEmployee : begin
                    lKeyS := PartCCKey(JARCode, JAECode) + FullEmpKey(aCode);
                    lStatus := Find_Rec(B_GetEq, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, lKeyS);
                    if lStatus = 0 then
                      Result := JobMisc.EmplRec.EmpName;
                  end;
  end;
end;

//------------------------------------------------------------------------------

procedure TBaseAnonymisationDiaryDetailList.Anonymise(const AOwner: TObject);
var
  i: Integer;
begin
  FAnonymiseEntityList.Clear;
  for i := 0 to (AnonDiaryListIntf.Count - 1) do
  begin
    with AnonDiaryListIntf[i] do
    begin
      if adSelected and (not adIsPending) then
      begin
        FAnonymiseEntityList.Add(Trim(adEntityCode) + '=' + IntToStr(Ord(adEntityType)));
        if adEntityType = adeSupplier then
          AddLinkedEmployeesForAnonymise(Trim(adEntityCode), FAnonymiseEntityList);
      end;
    end;
  end;
  AnonymiseEntity(AOwner);
end;

//------------------------------------------------------------------------------
//Anonymise Trader - Pervasive: Trader's Employees - for suppliers (Sub-contractors)only
procedure TBaseAnonymisationDiaryDetailList.AddLinkedEmployeesForAnonymise(const ACustCode: String; var AList: TStringList);
var
  lKeyS: Str255;
  lStatus: Integer;
begin
  //Search sub contractor or Employee and added in Anonymise list 
  lKeyS := PartCCKey(JARCode, JASubAry[3]);
  lStatus := Find_Rec(B_GetFirst, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, lKeyS);
  while lStatus = 0 do
  begin
    with JobMisc.EmplRec do
    begin
      if (EType = 2) and (Trim(Supplier) = ACustCode) then
        FAnonymiseEntityList.Add(Trim(EmpCode) + '=3' );
    end;
    lStatus := Find_Rec(B_GetNext, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, lKeyS);
  end;
end;

//------------------------------------------------------------------------------
{ TSQLAnonymisationDiaryList }
//------------------------------------------------------------------------------

procedure TSQLAnonymisationDiaryList.AnonymiseEntity(const AOwner: TObject);
begin
  inherited;
  AnonymiseProcess_SQL(AOwner, FAnonymiseEntityList);
end;

//------------------------------------------------------------------------------

procedure TSQLAnonymisationDiaryList.PopulateList;
var
  lIndex,
  lRes: Integer;
  loLoadAnonymisationDiary: TSQLLoadAnonymisationDiary;
begin
  Clear;
  lIndex := 0;
  loLoadAnonymisationDiary := TSQLLoadAnonymisationDiary.Create;
  try
    lRes := loLoadAnonymisationDiary.ReadData;
    if lRes = 0 then
    begin
      lRes := loLoadAnonymisationDiary.GetFirst;
      while lRes = 0 do
      begin
        //SSK 09/01/2018 2018R1 ABSEXCH-19591: include entity which user has access permission to
        if IsEntityHasPermission(loLoadAnonymisationDiary.AnonymisationDiaryRec.adEntityType) then
        begin
          AddAnonDiaryToList(lIndex, loLoadAnonymisationDiary.AnonymisationDiaryRec);
          Inc(lIndex);
        end;
        lRes := loLoadAnonymisationDiary.GetNext;
      end;
    end;
  finally
    loLoadAnonymisationDiary.Free;
  end;
end;

//------------------------------------------------------------------------------
{ TPervasiveAnonymisationDiaryList }
//------------------------------------------------------------------------------

procedure TPervasiveAnonymisationDiaryList.AnonymiseEntity(const AOwner: TObject);
begin
  inherited;
  AnonymiseProcess_PSQL(AOwner, FAnonymiseEntityList);
end;

//------------------------------------------------------------------------------

constructor TPervasiveAnonymisationDiaryList.Create;
begin
  inherited;
  FAnonDiaryBtrvFile := TAnonymisationDiaryBtrieveFile.Create;
end;

//------------------------------------------------------------------------------

destructor TPervasiveAnonymisationDiaryList.Destroy;
begin
  FAnonDiaryBtrvFile.CloseFile;
  FreeAndNil(FAnonDiaryBtrvFile);
  inherited;
end;

//------------------------------------------------------------------------------

procedure TPervasiveAnonymisationDiaryList.PopulateList;
var
  lRes,
  lIndex: Integer;
begin
  Clear;
  lIndex := 0;
  if (FAnonDiaryBtrvFile.OpenFile(IncludeTrailingPathDelimiter(SetDrive) + AnonymisationDiaryFileName) = 0) then
  begin
    FAnonDiaryBtrvFile.Index := adIdxDateCodeType;
    lRes := FAnonDiaryBtrvFile.GetFirst;
    while lRes = 0 do
    begin
      //SSK 09/01/2018 2018R1 ABSEXCH-19591: include entity which has user has access permission to
      if IsEntityHasPermission(FAnonDiaryBtrvFile.AnonymisationDiary.adEntityType) then
      begin
        AddAnonDiaryToList(lIndex, FAnonDiaryBtrvFile.AnonymisationDiary);
        Inc(lIndex);
      end;
      lRes := FAnonDiaryBtrvFile.GetNext;
    end;
  end;
end;

//------------------------------------------------------------------------------
//SSK 09/01/2018 2018R1 ABSEXCH-19591: include the entities whose access permission is granted to logged in user
function TBaseAnonymisationDiaryDetailList.IsEntityHasPermission(const aEntityType: TAnonymisationDiaryEntity): Boolean;
var
  lEntityHasPermission: Boolean;
begin
  lEntityHasPermission := False;
  case aEntityType of
    adeCustomer : begin
                    if ChkAllowed_in(uaAnonymiseCustomerConsumer) then
                      lEntityHasPermission := True;
                  end;
    adeSupplier : begin
                    if ChkAllowed_in(uaAnonymiseSupplier) then
                      lEntityHasPermission := True;
                  end;
    adeEmployee : begin
                    if ChkAllowed_in(uaAnonymiseEmployee) then
                      lEntityHasPermission := True;
                  end;
  end;
  Result := lEntityHasPermission;
end;

//------------------------------------------------------------------------------
initialization
  AnonDiaryListIntf := nil;

finalization
  AnonDiaryListIntf := nil;

end.
