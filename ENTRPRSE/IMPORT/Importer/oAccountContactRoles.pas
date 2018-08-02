unit oAccountContactRoles;

interface

uses
  GlobVar, ContactsManager, GlobalTypes;

  function StoreAccountContact(const ContactRec : PImporterAccountContactRec; TrialImport : Boolean) : Integer;
  function StoreAccountContactRole(const ContactRoleRec : PImporterAccountContactRoleRec; TrialImport : Boolean) : Integer;

implementation

uses
  Classes, SysUtils, EtStrU, BtKeys1U, VarConst, BtSupU1, ConsumerUtils, oContactRoleBtrieveFile,
  DllErrU, TImportToolkitClass;


type
  //As we can have contacts and roles in the same file, we need some way of keeping track of contacts which have
  //been added during the trial import, so that roles for them which occur later in the file don't get stopped
  //as invalid. The TContactCache holds a list of AccountCode/ContactName strings for contacts which will be
  //added from this file.
  TContactCache = Class
  protected
    FList : TStringList;
    function FormatSearchString(const AccountCode : string; const ContactName : string) : string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddContact(const AccountCode : string; const ContactName : string);
    function ContactExists(const AccountCode : string; const ContactName : string) : Boolean;
  end;

  TCustSuppFlag = (csfWrongAccountType, csfCustomer, csfSupplier, csfNotFound);

  TImporterAccountContactRole = Class
  protected
    FContactRec : PImporterAccountContactRec;
    FRoleRec : PImporterAccountContactRoleRec;
    FContactsManager : TContactsManager;
    FTrialImport : Boolean;
    FContactCache : TContactCache;
    FCustSuppFlag : TCustSuppFlag;

    //Getters & Setters
    function GetContactRec: PImporterAccountContactRec;
    procedure SetContactRec(const Value: PImporterAccountContactRec);
    function GetRoleRec: PImporterAccountContactRoleRec;
    procedure SetRoleRec(const Value: PImporterAccountContactRoleRec);
    procedure SetTrialImport(const Value: Boolean);

    //Store functions
    function StoreContact: Integer;
    function StoreRole: Integer;

    //Validation
    procedure SetCustSuppFlag;
    function ValidationCodeToInt(const ACode : TContactValidationCodes) : Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute : Integer;
    property Contact : PImporterAccountContactRec read GetContactRec write SetContactRec;
    property Role : PImporterAccountContactRoleRec read GetRoleRec write SetRoleRec;
    property TrialImport : Boolean read FTrialImport write SetTrialImport;
  end;

var
  oContactImporter : TImporterAccountContactRole;

//Called whenever the contact importer is needed - will create the contact importer if it hasn't already been created
procedure GetContactImporter;
begin
  if not Assigned(oContactImporter) then
    oContactImporter := TImporterAccountContactRole.Create;
end;

function StoreAccountContact(const ContactRec : PImporterAccountContactRec; TrialImport : Boolean) : Integer;
begin
  GetContactImporter;
  oContactImporter.TrialImport := TrialImport;
  oContactImporter.Contact := ContactRec;
  Result := oContactImporter.Execute;
end;

function StoreAccountContactRole(const ContactRoleRec : PImporterAccountContactRoleRec; TrialImport : Boolean) : Integer;
begin
  GetContactImporter;
  oContactImporter.TrialImport := TrialImport;
  oContactImporter.Role := ContactRoleRec;
  Result := oContactImporter.Execute;
end;


constructor TImporterAccountContactRole.Create;
begin
  inherited;
  FContactRec := nil;
  FRoleRec := nil;
  FContactsManager := NewContactsManager;
  FContactCache := TContactCache.Create;
end;

destructor TImporterAccountContactRole.Destroy;
begin
  FContactsManager.Free;
  FContactCache.Free;
  inherited;
end;

function TImporterAccountContactRole.Execute: Integer;
begin
  Result := 0;

  if Assigned(FContactRec) then
    Result := StoreContact;

  if Assigned(FRoleRec) then
    Result := StoreRole;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(620,Result);
end;

function TImporterAccountContactRole.GetContactRec: PImporterAccountContactRec;
begin
  Result := FContactRec;
end;


procedure TImporterAccountContactRole.SetCustSuppFlag;
var
  KeyS : Str255;
begin
  KeyS := FullCustCode(FContactsManager.GetAccountId);
  if CheckRecExsists(KeyS, CustF, CustCodeK) then
  begin
    if (Cust.acSubType <> CONSUMER_CHAR) then
    begin
      if Cust.CustSupp = CUSTOMER_CHAR then
        FCustSuppFlag := csfCustomer
      else
        FCustSuppFlag := csfSupplier;
    end
    else
      FCustSuppFlag := csfWrongAccountType;
  end
  else
    FCustSuppFlag := csfNotFound;
end;

function TImporterAccountContactRole.GetRoleRec: PImporterAccountContactRoleRec;
begin
  Result := FRoleRec;
end;

procedure TImporterAccountContactRole.SetContactRec(
  const Value: PImporterAccountContactRec);
begin
  FContactRec := Value;
  if Assigned(FContactRec) then
  begin
    if FContactRec.iacAccountCode <> FContactsManager.GetAccountId then
    begin
      FContactsManager.SetCustomerRecord(FContactRec.iacAccountCode);
      SetCustSuppFlag;
    end;
    FRoleRec := nil;
  end;
end;

procedure TImporterAccountContactRole.SetRoleRec(
  const Value: PImporterAccountContactRoleRec);
begin
  FRoleRec := Value;
  if Assigned(FRoleRec) then
  begin
    if FRoleRec.icrAccountCode <> FContactsManager.GetAccountId then
    begin
      FContactsManager.SetCustomerRecord(FRoleRec.icrAccountCode);
      SetCustSuppFlag;
    end;
    FContactRec := nil;
  end;
end;

procedure TImporterAccountContactRole.SetTrialImport(const Value: Boolean);
begin
  FTrialImport := Value;
end;

function TImporterAccountContactRole.StoreContact: Integer;
var
  oContact : TAccountContact;
  ContactNo : Integer;
  ContactId : Integer;
  EditMode : TEditModes;

begin
  if not (FCustSuppFlag in [csfWrongAccountType, csfNotFound]) then
  begin

    Result := 30004; //Unknown error in case anything goes wrong

    //See if contact already exists if so then we update the record; if not, we add it.
    ContactId := FContactsManager.GetContactIdByName(FContactRec.iacName);

    if ContactId >= 0 then
      EditMode := emEdit
    else
      EditMode := emAdd;


    //copy data to object suitable for Contact Manager
    if EditMode = emAdd then
      oContact := TAccountContact.Create
    else
      oContact := FContactsManager.GetContactById(ContactId);

    Try
      if EditMode = emEdit then
        oContact.ContactDetails.acoContactId := ContactId;
      oContact.ContactDetails.acoAccountCode := FContactRec.iacAccountCode;
      oContact.ContactDetails.acoContactName := FContactRec.iacName;
      oContact.ContactDetails.acoContactJobTitle := FContactRec.iacJobTitle;
      oContact.ContactDetails.acoContactPhoneNumber := FContactRec.iacPhoneNumber;
      oContact.ContactDetails.acoContactFaxNumber := FContactRec.iacFaxNumber;
      oContact.ContactDetails.acoContactEmailAddress := FContactRec.iacEmailAddress;
      oContact.ContactDetails.acoContactHasOwnAddress := FContactRec.iacHasOwnAddress;
      oContact.ContactDetails.acoContactAddress := FContactRec.iacAddress;
      oContact.ContactDetails.acoContactPostCode := FContactRec.iacPostcode;

      //PR: 28/11/2014 Order Payments
      oContact.ContactDetails.acoContactCountry := FContactRec.iacCountryCode;

      if FTrialImport then //Call validation
      begin
        Result := ValidationCodeToInt(FContactsManager.ValidateContact(oContact, EditMode));

        //Now we need to add this contact to the cache so we can use it to validate contacts for
        //StoreContactRole
        if Result = 0 then
          FContactCache.AddContact(FContactRec.iacAccountCode, FContactRec.iacName);
      end
      else
      begin
        //Store to database
        if EditMode = emAdd then
        begin
          //Keep record of index of added contact as we'll need it below
          ContactNo := FContactsManager.AddContact(oContact);

          if ContactNo > -1 then //Contact was added to manager successfully
          with FContactsManager do
            Result := SaveContactToDb(GetContact(ContactNo), EditMode);
        end
        else //Editing
        begin
          with FContactsManager do
            Result := SaveContactToDb(oContact, EditMode);
        end;
      end;
    Finally
      if EditMode = emAdd then
        oContact.Free;
    End;
  end
  else
  begin
    if FCustSuppFlag = csfWrongAccountType then
      Result := 30005
    else
      Result := 30007 //Invalid Account Code

  end;
end;

function TImporterAccountContactRole.StoreRole: Integer;
var
  iContactId : Integer;
  iRoleId : Integer;
  oContact : TAccountContact;

  function ValidRoleForAccountType : Boolean;
  var
    oRoleRec : ContactRoleRecType;
  begin
    oRoleRec := FContactsManager.GetRoleById(iRoleId);
    Result := (FCustSuppFlag = csfCustomer) and (oRoleRec.crRoleAppliesToCustomer) or
              (FCustSuppFlag = csfSupplier) and (oRoleRec.crRoleAppliesToSupplier);
  end;

  function TxLateRoleResult(Res : TRoleAssignmentStatus) : Integer;
  begin
    Case Res of
      rasSuccess           : Result := 0;
      rasInvalidContact    : Result := 30008;
      rasInvalidRole       : Result := 30009;
      else
        Result := 30004;
    end;
  end;

  function HaveCachedContact : Boolean;
  begin
    Result := FContactCache.ContactExists(FContactsManager.GetAccountId, FRoleRec.icrContactName);
  end;

  function Validate : Integer;
  begin
    if FCustSuppFlag = csfWrongAccountType then
      Result := 30005
    else
    if FCustSuppFlag = csfNotFound then
      Result := 30007
    else
    if (iContactId < 0) and not HaveCachedContact then
      Result := 30008
    else
    if (iRoleId < 0) then
      Result := 30009
    else
    if not ValidRoleForAccountType then
      Result := 30006
    else
      Result := 0;
  end;

  //Translate from enumeration returned from validation function to integer
  function ValidationCodeToInt(const ACode : TContactValidationCodes) : Integer;
  begin
    Case ACode of
      cvOK                  : Result := 0;
      cvMissingName         : Result := 30001;
      cvNameNotUnique       : Result := 30002;
      cvInvalidEmailAddress : Result := 30003;
      cvInvalidAccountType  : Result := 30005;
      cvIncorrectRoleForAccountType
                            : Result := 30006;
      cvAccountNotFound     : Result := 30007;
      else
        Result := 30004;
    end;
  end;


begin
  iContactId := FContactsManager.GetContactIdByName(FRoleRec.icrContactName);
  iRoleId := FContactsManager.GetRoleIdByDescription(FRoleRec.icrRoleDescription);

  if FTrialImport then
    Result := Validate
  else
  begin
    Result := TxLateRoleResult(FContactsManager.AssignRoleToContact(iRoleId, iContactId));

    if Result = 0 then
    begin
      oContact := FContactsManager.GetContactById(iContactId);
      if Assigned(oContact) then
      begin
        Result := ValidationCodeToInt(FContactsManager.ValidateContact(oContact, emEdit));
        if Result = 0 then
          Result := FContactsManager.SaveContactToDB(oContact, emEdit);
      end
      else //shouldn't happen
        Result := TxLateRoleResult(rasInvalidContact);
    end;
  end;
end;

{ TContactCache }

procedure TContactCache.AddContact(const AccountCode, ContactName: string);
begin
  FList.Add(FormatSearchString(AccountCode, ContactName));
end;

function TContactCache.ContactExists(const AccountCode,
  ContactName: string): Boolean;
begin
  Result := FList.IndexOf(FormatSearchString(AccountCode, ContactName)) >= 0;
end;

constructor TContactCache.Create;
begin
  inherited;
  FList := TStringList.Create;
  FList.CaseSensitive := False;
  FList.Sorted := True;
  FList.Duplicates := dupIgnore;
end;

destructor TContactCache.Destroy;
begin
  if Assigned(FList) then
    FList.Free;
  inherited;
end;

function TContactCache.FormatSearchString(const AccountCode,
  ContactName: string): string;
begin
  Result := LJVar(AccountCode, 10) + Trim(ContactName);
end;

function TImporterAccountContactRole.ValidationCodeToInt(
  const ACode: TContactValidationCodes): Integer;
begin
  Case ACode of
    cvOK                  : Result := 0;
    cvAccountNotFound     : Result := 4;
    cvMissingName         : Result := 30001;
    cvNameNotUnique       : Result := 30002;
    cvInvalidEmailAddress : Result := 30003;
    cvInvalidAccountType  : Result := 30005;
    cvIncorrectRoleForAccountType
                          : Result := 30006;
    cvInvalidCountry      : Result := 30010;
    else
      Result := 30004;
  end;
end;

initialization
  oContactImporter := nil;

finalization
  if Assigned(oContactImporter) then
    oContactImporter.Free;

end.
