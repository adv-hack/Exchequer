unit oAccountContact;

{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     SysConst, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarConst,
     ContactsManager, oAccountContactBtrieveFile, oAddr, MiscFunc, oContactRoles,
     ExceptIntf;

type
  TCOMAccountContact = class(TAutoIntfObjectEx, IAccountContact)
  private
    FContactsManager : TContactsManager;
    FAccountContact : TAccountContact;
    FAccountCode : string;
  protected
    FAddressO       : TAddress;
    FAddressI       : IAddress;

    RolesListO : TLimitedSystemSetupContactRolesList;
    RolesListI : ISystemSetupContactRolesList;

    FIntfType       : TInterfaceMode;

    function Get_acoContactId: Integer; safecall;
    function Get_acoName: WideString; safecall;
    procedure Set_acoName(const Value: WideString); safecall;
    function Get_acoJobTitle: WideString; safecall;
    procedure Set_acoJobTitle(const Value: WideString); safecall;
    function Get_acoPhone: WideString; safecall;
    procedure Set_acoPhone(const Value: WideString); safecall;
    function Get_acoFax: WideString; safecall;
    procedure Set_acoFax(const Value: WideString); safecall;
    function Get_acoEmail: WideString; safecall;
    procedure Set_acoEmail(const Value: WideString); safecall;
    function Get_acoHasOwnAddress: WordBool; safecall;
    procedure Set_acoHasOwnAddress(Value: WordBool); safecall;
    function Get_acoAddress: IAddress; safecall;
    function Get_acoPostCode: WideString; safecall;
    procedure Set_acoPostCode(const Value: WideString); safecall;
    function AssignRole(RoleId: Integer): Integer; safecall;
    function UnassignRole(RoleId: Integer): Integer; safecall;
    function Update: IAccountContact; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function Delete: WordBool; safecall;
    function Get_acoRoles: ISystemSetupContactRolesList; safecall;

    function GetAddrLine (AddrIdx, Idx : Byte; DirectToLines : Boolean = True) : String;
    Procedure SetAddrLine(AddrIdx, Idx : Byte; Value : String; DirectToLines : Boolean = True);

    procedure InitObjects;
  public
    constructor Create(const acCode           : string;
                       const ContactsManagerO : TContactsManager;
                       const oAccount         : TAccountContact;
                             IntfMode         : TInterfaceMode);
    destructor Destroy; override;

  end;

  TLimitedAccountContactsList = class(TAutoIntfObjectEx, IAccountContactsList)
  protected
    FAccountCode : string;
    FContactsManager : TContactsManager;
    FContactList : Array of TAccountContact;
    FRoleId : Integer;
    function Get_aclCount: Integer; safecall;
    function Get_aclContact(Index: Integer): IAccountContact; safecall;
    function AddContact: IAccountContact; safecall;
    function FindContactsForRole(RoleId: Integer): IAccountContactsList; safecall;
    function FindContactById(ContactId: Integer): IAccountContact; safecall;
    procedure LoadRoles;
  public
    constructor Create(const acCode           : string;
                       const ContactsManagerO : TContactsManager;
                                       RoleId : Integer);
    destructor Destroy; override;
  end;

  TAccountContactsList = class(TAutoIntfObjectEx, IAccountContactsList)
  private
    procedure SetAccountCode(const Value: string);
  protected
    FAccountCode : string;
    FContactsManager : TContactsManager;

    ContactsListO : TLimitedAccountContactsList;
    ContactsListI : IAccountContactsList;

    function Get_aclCount: Integer; safecall;
    function Get_aclContact(Index: Integer): IAccountContact; safecall;
    function AddContact: IAccountContact; safecall;
    function FindContactsForRole(RoleId: Integer): IAccountContactsList; safecall;
    function FindContactById(ContactId: Integer): IAccountContact; safecall;

  public
    constructor Create;
    destructor Destroy; override;
    property AccountCode : string read FAccountCode write SetAccountCode;
  end;


implementation

uses
  ComServ, DllErrU, GlobVar;

procedure InvalidMethod(const MethodName : string);
begin
  raise EInvalidMethod.Create('The method ' + QuotedStr(MethodName) + ' is not available in this object');
end;

{ TAccountContact }

function TCOMAccountContact.AssignRole(RoleId: Integer): Integer;
begin
  if (RoleId > 0) and (RoleId <= FContactsManager.GetNumRoles) then
  begin
    Result := 0;
    //When adding a contact we can't use AssignRoleToContact since we don't have a ContactId yet,
    //so add it into the Role list for the TAccountContact
    if FIntfType = imAdd then
    with FAccountContact do
    begin
      SetLength(assignedRoles, Length(assignedRoles) + 1);
      assignedRoles[High(assignedRoles)] := FContactsManager.GetRoleById(RoleId);
    end
    else
    if FIntfType = imUpdate then
      FContactsManager.AssignRoleToContact(RoleId, Get_acoContactId)
    else
      InvalidMethod('AssignRole');
  end
  else
    Result := 30009;
end;

procedure TCOMAccountContact.Cancel;
begin
  FContactsManager.UnlockContact(FAccountContact.contactDetails.acoContactId);
end;

constructor TCOMAccountContact.Create(const acCode           : string;
                                      const ContactsManagerO : TContactsManager;
                                      const oAccount         : TAccountContact;
                                            IntfMode         : TInterfaceMode);
begin
  // MH 03/10/2017 2018-R1 ABSEXCH-19215: Added missing inherited call
  inherited Create(ComServer.TypeLib, IAccountContact);
  FAccountCode := acCode;
  FContactsManager := ContactsManagerO;
  FAccountContact := oAccount;
  FAccountContact.contactDetails.acoAccountCode := acCode;
  FIntfType := IntfMode;
  InitObjects;
end;

destructor TCOMAccountContact.Destroy;
begin
  InitObjects;
  inherited;
end;

function TCOMAccountContact.GetAddrLine(AddrIdx, Idx: Byte;
  DirectToLines: Boolean): String;
begin
//PR: 26/11/2014 Order Payments Add Country Code
  if Idx = IDX_COUNTRY then
    Result := FAccountContact.contactDetails.acoContactCountry
  else
    Result := Trim(FAccountContact.contactDetails.acoContactAddress[Idx]);
end;

function TCOMAccountContact.Get_acoAddress: IAddress;
begin
  If (Not Assigned(FAddressO)) Then Begin
    { Create and initialise Customer Address Sub-Object}
    FAddressO := TAddress.Create(1, GetAddrLine, SetAddrLine);

    FAddressI := FAddressO;
  End; { If (Not Assigned(FAddressO)) }

  Result := FAddressI;
end;

function TCOMAccountContact.Get_acoContactId: Integer;
begin
  Result := FAccountContact.contactDetails.acoContactId;
end;

function TCOMAccountContact.Get_acoEmail: WideString;
begin
  Result := Trim(FAccountContact.contactDetails.acoContactEmailAddress);
end;

function TCOMAccountContact.Get_acoFax: WideString;
begin
  Result := Trim(FAccountContact.contactDetails.acoContactFaxNumber);
end;

function TCOMAccountContact.Get_acoHasOwnAddress: WordBool;
begin
  Result := FAccountContact.contactDetails.acoContactHasOwnAddress;
end;

function TCOMAccountContact.Get_acoJobTitle: WideString;
begin
  Result := Trim(FAccountContact.contactDetails.acoContactJobTitle);
end;

function TCOMAccountContact.Get_acoName: WideString;
begin
  Result := FAccountContact.contactDetails.acoContactName;
end;

function TCOMAccountContact.Get_acoPhone: WideString;
begin
  Result := Trim(FAccountContact.contactDetails.acoContactPhoneNumber);
end;

function TCOMAccountContact.Get_acoPostCode: WideString;
begin
  Result := Trim(FAccountContact.contactDetails.acoContactPostcode);
end;

function TCOMAccountContact.Get_acoRoles: ISystemSetupContactRolesList;
begin
  if not Assigned(RolesListO) then
  begin
    RolesListO := TLimitedSystemSetupContactRolesList.Create(FAccountContact, FContactsManager);

    RolesListI := RolesListO;
  end;

  Result := RolesListI;
end;

function TCOMAccountContact.UnassignRole(RoleId: Integer): Integer;
begin
  Result := Ord(FContactsManager.UnassignRoleFromContact(RoleId, Get_acoContactId));
  if Result <> 0 then
    Result := 30009
end;

function TCOMAccountContact.Save: Integer;

  function IntFModeToEditMode(const AMode : TInterfaceMode) : TEditModes;
  begin
    if AMode = imAdd then
      Result := emAdd
    else
      Result := emEdit;
  end;

  //Translate from enumeration returned from validation function to integer
  function ValidationCodeToInt(const ACode : TContactValidationCodes) : Integer;
  begin
    Case ACode of
      cvOK                  : Result := 0;
      cvAccountNotFound     : Result := 30007;
      cvMissingName         : Result := 30001;
      cvNameNotUnique       : Result := 30002;
      cvInvalidEmailAddress : Result := 30003;
      cvInvalidAccountType  : Result := 30005;
      cvIncorrectRoleForAccountType
                            : Result := 30006;
      cvInvalidCountry      : Result := 30010; //PR: 16/09/2105 ABSEXCH-16861 Added Invalid Country error
      else
        Result := 30004;
    end;
  end;

begin
  if FintfType in [imAdd, imUpdate] then
  Try
    //Validate record
    Result := ValidationCodeToInt(FContactsManager.ValidateContact(FAccountContact, IntFModeToEditMode(FIntfType)));

    if Result = 0 then
    begin
      if FIntfType = imAdd then
      begin
        Result := FContactsManager.SaveContactToDB(FAccountContact, emAdd);
        if Result = 0 then
          FContactsManager.AddContact(FAccountContact);
      end
      else
        Result := FContactsManager.SaveContactToDB(FAccountContact, emEdit);

    end;


    //In MS-SQL PKR is returning -1 from update if the record doesn't update
    if Result = -1 then
    begin
      if FIntfType = imAdd then
        Result := 30004 //Unknown error
      else
        Result := 80; //Pervasive 'conflict' code when record has changed between being read and being stored
    end;

    //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
    if Result = 0 then
      FIntfType := imClone;

    LastErDesc := Ex_ErrorDescription (620, Result);
  Except
    on E:Exception do
    begin
      raise EToolkitException.Create('Exception ' + QuotedStr(E.Message) + ' when storing contact');
    end;
  End
  else
    InvalidMethod('Save');
end;

procedure TCOMAccountContact.SetAddrLine(AddrIdx, Idx: Byte; Value: String;
  DirectToLines: Boolean);
begin
//PR: 26/11/2014 Order Payments Add Country Code
  if Idx = IDX_COUNTRY then
    FAccountContact.contactDetails.acoContactCountry := Value
  else
    FAccountContact.contactDetails.acoContactAddress[Idx] := Value;
end;

procedure TCOMAccountContact.Set_acoEmail(const Value: WideString);
begin
  FAccountContact.contactDetails.acoContactEmailAddress := Value;
end;

procedure TCOMAccountContact.Set_acoFax(const Value: WideString);
begin
  FAccountContact.contactDetails.acoContactFaxNumber := Value;
end;

procedure TCOMAccountContact.Set_acoHasOwnAddress(Value: WordBool);
begin
  FAccountContact.contactDetails.acoContactHasOwnAddress := Value;
end;

procedure TCOMAccountContact.Set_acoJobTitle(const Value: WideString);
begin
  FAccountContact.contactDetails.acoContactJobTitle := Value;
end;

procedure TCOMAccountContact.Set_acoName(const Value: WideString);
begin
  FAccountContact.contactDetails.acoContactName := Value;
end;

procedure TCOMAccountContact.Set_acoPhone(const Value: WideString);
begin
  FAccountContact.contactDetails.acoContactPhoneNumber := Value;
end;

procedure TCOMAccountContact.Set_acoPostCode(const Value: WideString);
begin
  FAccountContact.contactDetails.acoContactPostCode := Value;
end;

function TCOMAccountContact.Update: IAccountContact;
begin
  if FIntfType  = imGeneral then
  begin
    if FContactsManager.LockContact(FAccountContact.contactDetails.acoContactId) then
      Result := TCOMAccountContact.Create(FAccountCode, FContactsManager, FAccountContact, imUpdate)
    else
      Result := nil;
  end
  else
    InvalidMethod('Update');
end;

procedure TCOMAccountContact.InitObjects;
begin
  RolesListO := nil;
  RolesListI := nil;
end;

function TCOMAccountContact.Delete: WordBool;
begin
  if FIntfType = imGeneral then
    Result := FContactsManager.DeleteContact(FAccountContact.contactDetails.acoContactId)
  else
    InvalidMethod('Delete');
end;

{ TAccountContactsList }

function TAccountContactsList.AddContact: IAccountContact;
var
  oAccContact : TCOMAccountContact;
begin
  oAccContact := TCOMAccountContact.Create(FAccountCode, FContactsManager, TAccountContact.Create, imAdd);
  Result := oAccContact;
end;

constructor TAccountContactsList.Create;
begin
  inherited Create(ComServer.TypeLib, IAccountContactsList);
  FContactsManager := NewContactsManager;
end;

destructor TAccountContactsList.Destroy;
begin
  if Assigned(FContactsManager) then
   FContactsManager.Free;
  inherited;
end;

function TAccountContactsList.FindContactById(
  ContactId: Integer): IAccountContact;
var
  oAccountContact : TAccountContact;
begin
  oAccountContact := FContactsManager.GetContactById(ContactId);
  if Assigned(oAccountContact) then
    Result := TCOMAccountContact.Create(FAccountCode, FContactsManager, oAccountContact, imGeneral) as IAccountContact
  else
    Result := nil;
end;

function TAccountContactsList.FindContactsForRole(
  RoleId: Integer): IAccountContactsList;
begin
  if not Assigned(ContactsListO) then
  begin
    ContactsListO := TLimitedAccountContactsList.Create(FAccountCode, FContactsManager, RoleId);

    ContactsListI := ContactsListO;
  end;

  Result := ContactsListI;
end;

function TAccountContactsList.Get_aclContact(
  Index: Integer): IAccountContact;
begin
  //Index is 1 based, so need to decrement to access zero-based array in contacts manager
  if (Index > 0) and (Index <= Get_aclCount) then
    Result := TCOMAccountContact.Create(FAccountCode, FContactsManager,
                                         FContactsManager.GetContact(Index - 1), imGeneral) as IAccountContact
  else
    raise EInvalidIndex.Create('Invalid Contact Index (' + IntToStr(Index) + ')');
end;

function TAccountContactsList.Get_aclCount: Integer;
begin
  Result := FContactsManager.GetNumContacts;
end;

procedure TAccountContactsList.SetAccountCode(const Value: string);
begin
  //Check if code has changed - if not do nothing, as SetCustomerRecord loads contact details from db
  if FAccountCode <> Value then
  begin
    FAccountCode := Value;
    FContactsManager.SetCustomerRecord(FAccountCode);
  end;
end;

{ TLimitedAccountContactsList }

function TLimitedAccountContactsList.AddContact: IAccountContact;
begin
  InvalidMethod('AddContact');
end;

constructor TLimitedAccountContactsList.Create(const acCode: string;
  const ContactsManagerO: TContactsManager; RoleId: Integer);
begin
  inherited Create(ComServer.TypeLib, IAccountContactsList);
  FAccountCode := acCode;
  FContactsManager := ContactsManagerO;
  FRoleId := RoleId;
  LoadRoles;
end;

destructor TLimitedAccountContactsList.Destroy;
begin
  Finalize(FContactList);
  inherited;
end;

function TLimitedAccountContactsList.FindContactById(
  ContactId: Integer): IAccountContact;
begin
  Result := nil;
end;

function TLimitedAccountContactsList.FindContactsForRole(
  RoleId: Integer): IAccountContactsList;
begin
  InvalidMethod('FindContactsForRole');
end;

function TLimitedAccountContactsList.Get_aclContact(
  Index: Integer): IAccountContact;
begin
  //Index is 1 based, so need to decrement to access zero-based array in contacts list
  if (Index > 0) and (Index <= Get_aclCount) then
    Result := TCOMAccountContact.Create(FAccountCode,
                                     FContactsManager,
                                     FContactList[Index - 1], imGeneral) as IAccountContact
  else
    raise EInvalidIndex.Create('Invalid Contact Index (' + IntToStr(Index) + ')');
end;

function TLimitedAccountContactsList.Get_aclCount: Integer;
begin
  Result := Length(FContactList);
end;

procedure TLimitedAccountContactsList.LoadRoles;
var
  i, j : integer;
  ThisContact : TAccountContact;
begin
  //Build list of Contacts which have this role
  for i := 0 to FContactsManager.GetNumContacts - 1 do
  begin
    ThisContact := FContactsManager.GetContact(i);
    for j := 0 to Length(ThisContact.assignedRoles) - 1 do
    begin
      if FRoleId = ThisContact.assignedRoles[j].crRoleId then
      begin
        SetLength(FContactList, Length(FContactList) + 1);
        FContactList[Length(FContactList) - 1] := ThisContact;
      end;
    end;
  end;
end;


end.
