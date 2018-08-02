unit oUserList;

interface

uses
  Dialogs, SysUtils, Classes, oUserIntf, StrUtil, Variants, oSQLLoadUserDetails;

function UserDetailList(const AForceRefresh: Boolean = False): IUserDetailList;

implementation

uses
  DB, SQLUtils, oUserDetail, VarConst, VarRec2U, GlobVar, ADOConnect,
  SQLCallerU, ExWrap1U, Btrvu2, BtKeys1U, PasswordComplexityConst, BTSupU1,
  WinAuthUtil, SQLFuncs;

type

  TBaseUserDetailsList = class(TInterfacedObject, IUserDetailList)
  private
    //Internal list to store the IUserDetails objects
    FUserDetailList: TInterfaceList;
    // IUserDetailList methods
    function GetCount: Integer;
    function GetUsers(AIndex: Integer): IUserDetails;
    function FindUserByIndex(AIndex: Integer): IUserDetails;
    function FindUserByUserName(AUserName: String30): IUserDetails;
    function FindUserByWinUserID(AUserName, AWinUserID: String30): IUserDetails;
    // Reloads the cached User
    procedure Refresh;
    function AddUser: IUserDetails;
    function CopyUser(const aICopyUserDetail: IUserDetails): IUserDetails;
    function DeleteUser(AUserName: String; var ADeleteMsg: String): Integer; virtual; abstract;
    // Remove all the Custom setting for the user
    function DeleteCustomSetting(AUserName: String; var ADeleteMsg: String): Integer; virtual; abstract;
  protected
    procedure Clear;
    procedure AddUserToList(AIndex: Integer; AUserPassDetailRec: tPassDefType);
    function DeleteUserAccessSetting(AUserName: string): Integer;
    procedure PopulateList; virtual; abstract;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end; //TBaseUserDetailsList

  TSQLUserDetailsList = class(TBaseUserDetailsList)
  protected
    procedure PopulateList; override;
    function DeleteUser(AUserName: String; var ADeleteMsg: String): Integer; override;
    function DeleteCustomSetting(AUserName: String; var ADeleteMsg: String): Integer; override;
  public
  end; //TSQLUserDetailsList

  TPervasiveUserDetailsList = class(TBaseUserDetailsList)
  protected
    procedure PopulateList; override;
    function DeleteUser(AUserName: String; var ADeleteMsg: String): Integer; override;
    function DeleteCustomSetting(AUserName: String; var ADeleteMsg: String): Integer; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end; //TPervasiveUserDetailsList

var
  UserDetailListIntf: IUserDetailList;
  OpenCompanyPath: ShortString;

//------------------------------------------------------------------------------
{Load All User record from Database and store in to Interface List}
function UserDetailList(const AForceRefresh: Boolean = False): IUserDetailList;
begin
  // If the singleton doesn't exist or the company path has changed then
  // create a new singleton
  if (not Assigned(UserDetailListIntf)) or (SetDrive <> OpenCompanyPath) then
  begin
    // Create the correct version for the data edition
    if SQLUtils.UsingSQL then
      UserDetailListIntf := TSQLUserDetailsList.Create
    else
      UserDetailListIntf := TPervasiveUserDetailsList.Create;

    // Load the data
    UserDetailListIntf.Refresh;
    // Update the path so we can detect changes automatically
    OpenCompanyPath := SetDrive;
  end
  else
  begin
    // Check to see if the data should be refreshed
    if AForceRefresh then
      UserDetailListIntf.Refresh;
  end;
  Result := UserDetailListIntf;
end;

//------------------------------------------------------------------------------
{ TBaseUserDetailsList }
//------------------------------------------------------------------------------

function TBaseUserDetailsList.AddUser: IUserDetails;
var
  lNewUserDetailRec: tPassDefType;
begin // Add
  FillChar(lNewUserDetailRec, SizeOf(lNewUserDetailRec), #0);
  // Create a new object and return an interface reference
  Result := CreateUser(FUserDetailList.Count+1, umInsert, lNewUserDetailRec);
end;

//------------------------------------------------------------------------------

procedure TBaseUserDetailsList.AddUserToList(AIndex: Integer;
                                         AUserPassDetailRec: tPassDefType);
begin
  FUserDetailList.Add(CreateUser(AIndex, umReadOnly, AUserPassDetailRec));
end;

//------------------------------------------------------------------------------
{Delete User Access Setting in to Database}
function TBaseUserDetailsList.DeleteUserAccessSetting(AUserName: string): Integer;
var
  lKeyS: Str255;
  i: Integer;
begin
  for i := 0 to 3 do
  begin
    { == Delete any additional pages Access Settings From table : EXCHQCHK == }
    lKeyS := FullPWordKey(PassUCode, Chr(i), AUserName);
    Status := Find_Rec(B_GetEq, F[PWrdF], PWrdF, RecPtr[PWrdF]^, PWK, lKeyS);
    if StatusOk then
    begin
      Status := Delete_Rec(F[PWrdF], PWrdF, PWK);
      Report_BError(PWrdF, Status);
    end;
  end;
  Result := Status;
end;

//------------------------------------------------------------------------------

procedure TBaseUserDetailsList.Clear;
begin
  FUserDetailList.Clear;
end;

//------------------------------------------------------------------------------

function TBaseUserDetailsList.CopyUser(const aICopyUserDetail: IUserDetails): IUserDetails;
var
  lNewUserDetailRec: tPassDefType;
begin
  FillChar(lNewUserDetailRec, SizeOf(lNewUserDetailRec), #0);
  lNewUserDetailRec := aICopyUserDetail.udUserPassDetailRec;
  // Create a new object and return an interface reference
  Result := CreateUser(FUserDetailList.Count+1, umInsert, lNewUserDetailRec);
end;

//------------------------------------------------------------------------------

constructor TBaseUserDetailsList.Create;
begin
  inherited Create;
  FUserDetailList := TInterfaceList.Create;
end;

//------------------------------------------------------------------------------

destructor TBaseUserDetailsList.Destroy;
begin
  Clear;
  FreeAndNil(FUserDetailList);
  inherited Destroy;
end;

//------------------------------------------------------------------------------

function TBaseUserDetailsList.FindUserByIndex(AIndex: Integer): IUserDetails;
var
  i: Integer;
begin
  Result := nil;
  //Search through List
  for i := 0 to FUserDetailList.Count - 1 do
  begin
    if (FUserDetailList[i] as IUserDetails).udIndex = AIndex then
    begin
      //We got the entry so return the entry and stop the loop
      Result := FUserDetailList[i] as IUserDetails;
      Break;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TBaseUserDetailsList.FindUserByUserName(AUserName: String30): IUserDetails;
var
  i: Integer;
begin
  Result := nil;
  //Search through List
  for i := 0 to FUserDetailList.Count - 1 do
  begin
    if Trim((FUserDetailList[i] as IUserDetails).udUserName) = Trim(AUserName) then
    begin
      //We got the entry so return the entry and stop the loop
      Result := FUserDetailList[i] as IUserDetails;
      Break;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TBaseUserDetailsList.FindUserByWinUserID(AUserName, AWinUserID: String30): IUserDetails;
var
  i: Integer;
begin
  Result := nil;
  //Search through List
  for i := 0 to FUserDetailList.Count - 1 do
  begin
    with (FUserDetailList[i] as IUserDetails) do
    begin
      if (UpperCase(Trim(udWindowUserId)) = UpperCase(Trim(AWinUserID))) and
         (Trim(udUserName) <> Trim(AUserName)) then
      begin
        //We got the entry so return the entry and stop the loop
        Result := FUserDetailList[i] as IUserDetails;
        Break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TBaseUserDetailsList.GetCount: Integer;
begin
  Result := FUserDetailList.Count;
end;

//------------------------------------------------------------------------------

function TBaseUserDetailsList.GetUsers(AIndex: Integer): IUserDetails;
begin
  if (AIndex >= 0) and (AIndex < FUserDetailList.Count) then
    Result := FindUserByIndex(AIndex)
  else
    raise Exception.Create ('TBaseUserDetailsList.GetUsers: Invalid Index (Index=' + IntToStr(AIndex) + ', Count=' + IntToStr(FUserDetailList.Count) + ')');
end;

//------------------------------------------------------------------------------
{ TPervasiveUserDetailsList }
//------------------------------------------------------------------------------

constructor TPervasiveUserDetailsList.Create;
begin
  inherited;
  //in case of initialisation
end;

//------------------------------------------------------------------------------
// Delete all the custom settings made by the user
function TPervasiveUserDetailsList.DeleteCustomSetting(AUserName: String; var ADeleteMsg: String): Integer;
var
  lExLocal: TdExLocal;
  lKeyS,
  lKeyChk: Str255;
  B_Func: Integer;
  lOk,
  lLocked: Boolean;
begin
  lExLocal.Create;
  try
    with lExLocal do
    begin
      lKeyChk := PartCCKey(btCustTCode,btCustSCode);
      lKeyChk := lKeyChk + AUserName;
      lKeyS := lKeyChk;

      Status := Find_Rec(B_GetGEq, F[MiscF], MiscF, LRecPtr[MiscF]^, MiscNDXK, lKeyS);
      while (StatusOk) and (CheckKey(lKeyChk, lKeyS, Length(lKeyChk), True)) do
      begin
        lOk := LGetMultiRec(B_GetDirect, B_MultLock, lKeyS, MiscNDXK, MiscF, True, LLocked);
        if lOk and lLocked then
        begin
          Status := Delete_Rec(F[MiscF], MiscF, MiscNDXK);
          Report_BError(MiscF, Status);
          if StatusOk then
            B_Func := B_GetGEq
          else
            B_Func := B_GetNext;
        end
        else
          B_Func := B_GetNext;
        Status := Find_Rec(B_Func, F[MiscF], MiscF, LRecPtr[MiscF]^, MiscNDXK, lKeyS);
      end; {While..}
    end; {With..}
  finally
    ADeleteMsg := msgResetCustom;
    Result := 0;
  end;
end;

//------------------------------------------------------------------------------

function TPervasiveUserDetailsList.DeleteUser(AUserName: String;
                                              var ADeleteMsg: String): Integer;
var
  lExLocal: TdExLocal;
  lKeyS: Str255;
begin
  lExLocal.Create;
  try
    with lExLocal do
    begin
      lKeyS := FullPWordKey(PassUCode, Chr(0), AUserName);
      Status := Find_Rec(B_GetEq, F[PWrdF], PWrdF, LRecPtr[PWrdF]^, PWK, lKeyS);
      AssignFromGlobal(PWrdF);
      LGetRecAddr(PWrdF);
      Status := LGetDirectRec(PWrdF, PWK);
      if StatusOk then
      begin
        // Lock Selected User
        Ok := LGetMultiRec(B_GetDirect, B_MultLock, lKeyS, PWK, PWrdF, True, GlobLocked);
        if Ok and GlobLocked then
        begin
          Status := Delete_Rec(F[PWrdF], PWrdF, PWK);
          Report_BError(PWrdF, Status);
        end;

        if StatusOk then
        begin
          // Delete Access Settings
          Status := DeleteUserAccessSetting(AUserName);
          if Status = 0 then
          begin
            // Delete MlocStk(User) Record;
            with LMLocCtrl^ do
            begin
              lKeyS := FullPWordKey(PassUCode, 'D', AUserName);
              Status := Find_Rec(B_GetEq, F[MLocF], MLocF, LRecPtr[MLocF]^, MLK, lKeyS);
              if StatusOk then
              begin
                Status := Delete_Rec(F[MLocF], MLocF, MLK);
                Report_BError(MLocF, Status);
              end;
            end; // with LMLocCtrl^ do
            // Call Delete Custom Settings
            if StatusOk then
              Status := DeleteCustomSetting(AUserName, ADeleteMsg);
          end; {if Status = 0 then}
        end; {if StatusOk then}
      end; //if StatusOk then
    end; //with lExLocal do
  finally
    if StatusOk Then
      ADeleteMsg := msgDeleteUser;
    Result := Status;
    lExLocal.Destroy;
  end;
end;

//------------------------------------------------------------------------------

destructor TPervasiveUserDetailsList.Destroy;
begin
  //in case
  inherited;
end;

//------------------------------------------------------------------------------

procedure TPervasiveUserDetailsList.PopulateList;
var
  lStatus,
  lIndex: Integer;
  lKeyS: Str255;
begin
  Clear;
  lIndex := 0;
  lKeyS := FullPWordKey(PassUCode, 'D', EmptyStr);
  //HV 04/07/2018 2018 R1.1 ABSEXCH-20893: Kevin Nash Performance Issues Since Upgrading (User Management List)
  lStatus := Find_Rec(B_GetGEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, lKeyS);
  while (lStatus = 0) And (MLocCtrl^.RecPfix = PassUCode) And (MLocCtrl^.SubType = 'D') Do
  begin
    //Add Entry of current record
    AddUserToList(lIndex, MLocCtrl^.PassDefRec);
    Inc(lIndex); 
    lStatus := Find_Rec(B_GetNext, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, lKeyS);
  end;
end;

//------------------------------------------------------------------------------
{ TSQLUserDetailsList }
//------------------------------------------------------------------------------
{Delete User Custom Settings}
function TSQLUserDetailsList.DeleteCustomSetting(AUserName: String; var ADeleteMsg: String): integer;
var
  lRes: Integer;
begin
  lRes := -1;
  try
    lRes := SQLFuncs.ResetCustomSettings(SetDrive, AUserName);
  finally
    if lRes = 0 Then
      ADeleteMsg := msgResetCustom
    else
      ADeleteMsg := msgResetCustomError;
    Result := lRes;
  end;
end;

//------------------------------------------------------------------------------

function TSQLUserDetailsList.DeleteUser(AUserName: String; var ADeleteMsg: String): Integer;
var
  lSQLCaller: TSQLCaller;
  lQuery,
  lCompanyCode: String;
  lRes: Integer;
begin
  lRes := -1;
  Result := lRes;
  if AUserName <> EmptyStr then
  begin
    lSQLCaller := TSQLCaller.Create(GlobalAdoConnection);
    lCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
    try
      // Delete Selected User
      lQuery := 'Delete From [COMPANY].MLOCSTK ' +
                'WHERE RecPfix = ' + QuotedStr(PassUCode) + ' '+
                       'AND SubType = ' + QuotedStr('D') + ' ' +
                       'AND (varCode1Trans1=' + QuotedStr(AUserName) +')';
      lRes := lSQLCaller.ExecSQL(lQuery, lCompanyCode);

      if lRes = 0 then
      begin
        // Delete Access Settings
        lRes := DeleteUserAccessSetting(AUserName);
        // Call Delete Custom Settings
        if lRes = 0 then
          lRes := DeleteCustomSetting(AUserName, ADeleteMsg)
      end;
      if lRes = 0 Then
        ADeleteMsg := msgDeleteUser
      else
        ADeleteMsg := lSQLCaller.ErrorMsg;
    finally
      Result := lRes;
      lSQLCaller.Close;
      FreeAndNil(lSQLCaller);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TSQLUserDetailsList.PopulateList;
var
  lIndex: Integer;
  loLoadUserDetails: TSQLLoadUserDetails;
  lRes : Integer;
begin
  lIndex := 0;
  loLoadUserDetails := TSQLLoadUserDetails.Create;
  try
    lRes := loLoadUserDetails.ReadData;
    if lRes = 0 then
    begin
      lRes := loLoadUserDetails.GetFirst;
      while lRes = 0 do
      begin
        AddUserToList(lIndex, loLoadUserDetails.UserDetailRec);
        lRes := loLoadUserDetails.GetNext;
        Inc(lIndex)
      end;
    end;
  finally
    loLoadUserDetails.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TBaseUserDetailsList.Refresh;
begin
  // Remove any existing User Details
  Clear;
  PopulateList;
end;

//------------------------------------------------------------------------------

initialization
  OpenCompanyPath := #255;
  UserDetailListIntf := NIL;
finalization
  UserDetailListIntf := NIL;

end.
