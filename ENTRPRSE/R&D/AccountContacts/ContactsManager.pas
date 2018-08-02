unit ContactsManager;

// October 2013. PKR. MRD 7.X Item 2.4 - Ledger Multi-Contacts

// 21/10/2013. PKR. Factored out the SQL and Pervasive functions into derived
// classes.
// No instances of this class should be instantiated as it contains
// virtual abstract methods.

// This class is decoupled from the Exchequer user interface in a move towards
// a Business Object based model.

// DO NOT ADD ANY USER INTERFACE CODE TO THIS UNIT.

interface

uses
  Classes,
  SysUtils,
  DB,

//  Dialogs, // Use this for ShowMessage for development purposes only

  oAccountContactBtrieveFile,
  oContactRoleBtrieveFile,

  StrUtil, // For email address validation

  GlobVar,
  varConst; 

const
  success = 0;
  
type
  TEditModes = (emAdd, emEdit, emView);

  TContactValidationCodes = (cvOK,
                             cvMissingName,
                             cvNameNotUnique,
                             cvInvalidEmailAddress,
                             cvAccountNotFound,
                             cvIncorrectAccountCode,
                             cvInvalidAccountType,
                             cvIncorrectRoleForAccountType,
                             cvInvalidCountry);

  TRoleAssignmentStatus = (rasSuccess, rasInvalidRole,
                           rasInvalidContact, rasAlreadyAssigned,
                           rasSaveFailed, rasUnnasignFailed);

  //----------------------------------------------------------------------------
  TAccountContact = class
  public
    contactDetails : AccountContactRecType;
    // PKR. 13/01/2014. Added for optimistic locking
    dateModified   : TDateTime;
    assignedRoles  : array of ContactRoleRecType;
  end;
  TArrayOfAccountContacts = array of TAccountContact;
  //----------------------------------------------------------------------------
//##############################################################################
// TContactsManager
// DO NOT INSTANTIATE THIS CLASS.
// This class contains abstract methods which must be implemented by derived 
//  classes.  The abstract methods involve database access, so there must be a 
//  derived class for each database type.
// Initial version has derived classes for SQL and for Pervasive.
// See ContactsManagerSQL.pas and ContactsManagerPerv.pas
//##############################################################################
  TContactsManager = class
  protected
    fRoles         : array of ContactRoleRecType;
    fContacts      : array of TAccountContact;

    fCustomerCode  : string;
    fLastAddedContactId : integer;

    // Database access methods - only used internally
    procedure ReadRoleListFromDB; virtual; abstract;        // Read the roles from the database
    procedure ReadContactListFromDB; virtual; abstract;     // Read the contacts from the database
    procedure ReadRoleAssignmentsFromDB; virtual; abstract; // Read role assignments from the database
    function  DeleteContactRolesFromDB(aContactId : integer) : integer; virtual; abstract;

    // Helper methods
    function  RoleExists(aRoleId : integer) : boolean;
    function  ContactExists(aContactId : integer) : boolean;

    // PKR. 14/01/2014. Added for querying the DateModified fields.
    function  FormatSQLDateTime(aDateTime : TDateTime) : string;
    // PKR. 07/02/2014.  Added to extand validation for toolkit users
    function  GetAccountType(aAccountCode : string) : string; virtual; abstract;
  private
    procedure SortContacts;
  public
    constructor Create(AOwner : TComponent); virtual;
    // PKR. 07/05/2014. ABSEXCH-15312. Intermittent Range Check error when emailing statements.
    // Object was not destroying properly.
    // Changed from virtual to override so that "inherited" ripples back up to TObject.
    destructor  Destroy; override;

    Property  LastAddedContactId : integer read fLastAddedContactId write fLastAddedContactId;

    function  GetAccountID : string;
    procedure SetCustomerRecord(aCustCode : string);

    function  RoleIsAssigned(aRoleId : integer) : boolean;
    function  AssignRoleToContact(aRoleId, aContactId : Integer) : TRoleAssignmentStatus;
    function  UnassignRoleFromContact(aRoleId, aContactId : integer) : TRoleAssignmentStatus;

    // PKR. 14/01/2014. Added to allow the contact list to be refreshed when
    //  an update fails due to multi-user action.
    procedure RefreshContacts;
    // PKR. 14/01/2014. Added to allow the currently selected contact to be
    //  re-loaded immediately before editing it.
    function  ReloadContactFromDB(aContactId : integer) : boolean; virtual; abstract;

    function  DeleteContact(aContactId : integer): Boolean; virtual;

    function  SaveContactToDB(aContact : TAccountContact; aEditMode : TEditModes) : integer; virtual; abstract;
    function  DeleteContactFromDB(aContactId : integer): Boolean; virtual; abstract;

    function  GetNumRoles : integer;
    function  GetRole(aIndex : integer) : ContactRoleRecType;
    function  GetRoleById(aRoleId : integer) : ContactRoleRecType;
    function  GetRoleIdByDescription(aRoleDescription : string) : Integer;
    function  GetRoleByDescription(aRoleDescription : string) : ContactRoleRecType;
    function  GetRoleDescription(aRoleId : integer) : string;

    function  GetNumContacts : integer;
    function  AddContact(aContact : TAccountContact) : integer;
    function  GetContact(aIndex : integer) : TAccountContact;
    function  GetContactById(aContactId : integer) : TAccountContact;
    function  GetContactByRole(aRoleId : integer) : TAccountContact;
    function  GetContactListByRole(aRoleId : integer) : TArrayOfAccountContacts;
    function  GetContactEmailsByRole(aRoleId : integer) : AnsiString;
    function  GetContactIdByName(aName : string) : integer;
    function  GetFaxContactForRole(aRoleId : integer) : TAccountContact;
    function  GetNextContactId : integer; virtual; abstract;
    function  isUniqueContactName(aName : string) : boolean;

    function  IndexOf(aContactId : integer) : integer;

    function  PadWithSpaces(aString : string; aLength : integer) : string;

    function  LockContact(aContactId : integer) : Boolean; virtual; abstract;
    function  UnlockContact(aContactId : integer) : Boolean; virtual; abstract;

    function  ValidateContact(var aContact : TAccountContact; aEditMode : TEditModes) : TContactValidationCodes;

    //PR: 14/02/2014 ABSEXCH-15038
    function ChangeAccountCode(OldCode, NewCode : string) : Boolean; virtual; abstract;

    //PR: 14/02/2014 ABSEXCH-15039/15040
    procedure DeleteAllContacts;
  end;

  // Function to return a new TContactsManager instance for the appropriate data
Function NewContactsManager : TContactsManager;

implementation

uses
  SQLUtils, ContactsManagerPerv, ContactsManagerSQL,
  // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  CountryCodes, CountryCodeUtils;

//=========================================================================

Function NewContactsManager : TContactsManager;
Begin // NewContactsManager
  If SQLUtils.UsingSQL Then
    Result := TContactsManagerSQL.Create(NIL)
  Else
    Result := TContactsManagerPerv.Create(NIL);
End; // NewContactsManager

//==============================================================================
constructor TContactsManager.Create(AOwner : TComponent);
begin
  // Nothing to do here - all done in the sub-classes.
end;

//------------------------------------------------------------------------------
destructor TContactsManager.Destroy;
begin
  inherited;
end;

//------------------------------------------------------------------------------
// PKR. 14/01/2014. Reload the contacts from the database.
procedure TContactsManager.RefreshContacts;
begin
  ReadContactListFromDB;
  ReadRoleAssignmentsFromDB;
end;

//------------------------------------------------------------------------------
function TContactsManager.GetAccountID : string;
begin
  Result := fCustomerCode;
end;

//------------------------------------------------------------------------------
// Sets the customer account.  Contacts for the selected account are then read in.
procedure TContactsManager.SetCustomerRecord(aCustCode : string);
begin
  fCustomerCode := aCustCode;

  // Read the database tables.
  ReadContactListFromDB;
  ReadRoleAssignmentsFromDB;
end;
      
//------------------------------------------------------------------------------
// Deletes the specified Contact from the list.
function TContactsManager.DeleteContact(aContactId : integer) : boolean;
var
  oContact   : TAccountContact;
  index      : integer;
  contactIndex : integer;
begin
  // Get the contact
  oContact := GetContactById(aContactId);
  
  // Unassign this contact's roles
  if (Length(oContact.assignedRoles) > 0) then
  begin
    for index := High(oContact.assignedRoles) downto Low(oContact.assignedRoles) do
    begin
      UnassignRoleFromContact(oContact.assignedRoles[index].crRoleId, aContactId);
    end;
  end;

  // Remove the contact from the database
  // This also deletes the contact's assigned roles from the database.
  Result := DeleteContactFromDB(aContactId);

  // Remove the contact from the list of contacts.  Move any later contacts
  //  down the list and delete the last one.
  contactIndex := IndexOf(aContactId);
  if contactIndex < (GetNumContacts - 1) then
  begin
    // Not the last one, so move the subsequent contacts down the list.
    for index := contactIndex+1 to (GetNumContacts - 1) do
    begin
      fContacts[index-1] := fContacts[index];
    end;
  end;

  // Remove the last item from the list.
  SetLength(fContacts, Length(fContacts)-1);
end;
      
//------------------------------------------------------------------------------
// Returs true if the specified Role has been assigned to a Contact in this account.
function TContactsManager.RoleIsAssigned(aRoleId : integer) : boolean;
var
  rIndex : integer;
  cIndex : integer;
begin
  Result := false;
  
  // Loop through all the contacts
  if GetNumContacts > 0 then
  begin
    for cIndex := Low(fContacts) to High(fContacts) do
    begin
      // See if the role is assigned to this contact
      if Length(fContacts[cIndex].assignedRoles) > 0 then
      begin
        for rIndex := Low(fContacts[cIndex].assignedRoles) to High(fContacts[cIndex].assignedRoles) do
        begin
          if fContacts[cIndex].assignedRoles[rIndex].crRoleId = aRoleId then
          begin
            // Found, so set the flag and quit the loop
            Result := true;
            break;
          end;
        end;
        // Found so quit the loop
        if Result then
          break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Returns true if a record exists for the specified Role Id.
function TContactsManager.RoleExists(aRoleId : integer) : boolean;
var
  index : integer;
begin
  Result := false;
  if GetNumRoles > 0 then
  begin
    // For each role in the list...
    for index := Low(fRoles) to High(fRoles) do
    begin
      // ...if the ID matches, then set the exists flag
      if (fRoles[index].crRoleId = aRoleId) then
      begin
        Result := true;
        // Found it, so don't need to continue through the loop
        break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
function TContactsManager.AssignRoleToContact(aRoleId, aContactId : Integer) : TRoleAssignmentStatus;
var
  theContact : TAccountContact;
  sSQL       : String;
  Res        : Integer;
  index      : integer;
  hasRole    : Boolean;
  theRole    : ContactRoleRecType;
begin
  // PKR. 21/01/2014. Now allows roles to be assigned to multiple contacts.
  if not RoleExists(aRoleId) then
    Result := rasInvalidRole
  else
  begin
    //PR: 10/02/2014 Change to get role by Id rather than index
    theRole := GetRoleById(aRoleId);

    if not ContactExists(aContactId) then
      Result := rasInvalidContact
    else
    begin
      // Get the Contact
      theContact := GetContactbyId(aContactId);

      // If this Contact already has this role, then do nothing
      hasRole := false;
      for index := Low(theContact.assignedRoles) to High(theContact.assignedRoles) do
      begin
        if theContact.assignedRoles[index].crRoleId = aRoleId then
        begin
          hasRole := true;
        end;
      end;

      if not hasRole then
      begin
        // Add the Role to the Contact's assigned Roles.
        SetLength(theContact.assignedRoles, Length(theContact.assignedRoles)+1);
        theContact.assignedRoles[High(theContact.assignedRoles)].crRoleId := aRoleId;
        theContact.assignedRoles[High(theContact.assignedRoles)].crRoleDescription := GetRoleDescription(aRoleId);
        theContact.assignedRoles[High(theContact.assignedRoles)].crRoleAppliesToCustomer := theRole.crRoleAppliesToCustomer;
        theContact.assignedRoles[High(theContact.assignedRoles)].crRoleAppliesToSupplier := theRole.crRoleAppliesToSupplier;
      end;

      // Return success (even if the role was already assigned to this contact)
      Result := rasSuccess;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Removes a role from a contact.  If the role is not assigned to the contact,
//  then we don't really care as we're trying to remove it anyway.
function TContactsManager.UnassignRoleFromContact(aRoleId, aContactId : integer) : TRoleAssignmentStatus;
var
  index      : integer;
  index2     : integer;
  theContact : TAccountContact;
  sSQL       : String;
  Res        : Integer;
begin
  Result := rasSuccess; // Innocent until proven guilty

  if not RoleExists(aRoleId) then
    Result := rasInvalidRole
  else
  begin
    if not ContactExists(aContactId) then
      Result := rasInvalidContact
    else
    begin
      // Get the contact
      theContact := GetContactById(aContactId);
    
      // Look for the Role in this Contact's Assigned Roles..
      if (Length(theContact.assignedRoles) > 0) then
      begin
        for index := Low(theContact.assignedRoles) to High(theContact.assignedRoles) do
        begin
          if theContact.assignedRoles[index].crRoleId = aRoleId then
          begin
            // Found the role.
            // if it's not the last one in the list, then move all the others down.
            if (index < High(theContact.assignedRoles)) then
            begin
              for index2 := index+1 to High(theContact.assignedRoles) do
              begin
                theContact.assignedRoles[index2-1] := theContact.assignedRoles[index2];
              end;
            end;

            // Delete the last one
            SetLength(theContact.assignedRoles, Length(theContact.assignedRoles)-1);

(*
            // There will be a database record for this assignment, so we need
            //  to delete it from the database.
            with TSQLCaller.Create(GlobalADOConnection) do
            begin
              Try
                sSQL := 'DELETE FROM [COMPANY].AccountContactRole ' +
                        ' WHERE [COMPANY].AccountContactRole.acrContactId = ''' + IntToStr(aContactId) + ''' ' +
                        '   AND [COMPANY].AccountContactRole.acrRoleId = ''' + IntToStr(aRoleId) + ''' ';

                Res := ExecSQL(sSQL, FCompanyCode);

                if (Res = 0) then
                  Result := rasSuccess
                else
                  Result := rasUnnasignFailed;
              finally
                free;
              end;
            end;
*)
          end;
        end;
      end;
    end;
  end;
end;


//------------------------------------------------------------------------------
// Returns true if a contact with the specified ID exists.  False otherwise.
function TContactsManager.ContactExists(aContactid : integer) : boolean;
var
  index : integer;
begin
  Result := false;
  if GetNumContacts > 0 then
  begin
    // For each contact in the list...
    for index := Low(fContacts) to High(fContacts) do
    begin
      // ...if the ID matches, then set the exists flag
      if (fContacts[index].contactDetails.acoContactId = aContactId) then
      begin
        Result := true;
        // Found it, so don't need to continue through the loop
        break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Returns a simple indexed element of the roles array.
function TContactsManager.GetRole(aIndex : integer) : ContactRoleRecType;   
begin
  if (aIndex <= Length(fRoles)-1) then
    Result := fRoles[aIndex];
end;

//------------------------------------------------------------------------------
// Returns the Role that has the specified Id.
function TContactsManager.GetRoleById(aRoleId : integer) : ContactRoleRecType;
var
  index : integer;
begin
  for index := Low(fRoles) to High(fRoles) do
  begin
    if fRoles[index].crRoleId = aRoleId then
    begin
      Result := fRoles[index];
      break;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Returns the Role Id of the Role that has the specified Description, -1 if not found
function TContactsManager.GetRoleIdByDescription(aRoleDescription : string) : Integer;
var
  index : integer;
begin
  Result := -1;
  for index := Low(fRoles) to High(fRoles) do
  begin
    // Case insensitive
    if LowerCase(fRoles[index].crRoleDescription) = lowercase(aRoleDescription) then
    begin
      Result := fRoles[index].crRoleId;
      break;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Returns the Role that has the specified Description.
function TContactsManager.GetRoleByDescription(aRoleDescription : string) : ContactRoleRecType;
var
  index : integer;
begin
  for index := Low(fRoles) to High(fRoles) do
  begin
    // Case insensitive, without leading/trailing whitespace.
    if LowerCase(fRoles[index].crRoleDescription) = Trim(LowerCase(aRoleDescription)) then
    begin
      Result := fRoles[index];
      break;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Returns the description of the specified Role
function TContactsManager.GetRoleDescription(aRoleId : integer) : string; 
var
  index : integer;
begin
  Result := '';
  for index := Low(fRoles) to High(fRoles) do
  begin
    if fRoles[index].crRoleId = aRoleId then
    begin
      Result := fRoles[index].crRoleDescription;
      break;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Returns a simple indexed element of the contacts array.
function TContactsManager.GetContact(aIndex : integer) : TAccountContact;
begin
  Result := nil;

  if aIndex >= 0 then
  begin
    if (aIndex <= Length(fContacts)-1) then
      Result := fContacts[aIndex];
  end;
end;

//------------------------------------------------------------------------------
// Returns the Contact that has the specified Id, or nil if none exists.
function TContactsManager.GetContactById(aContactId : integer) : TAccountContact;
var
  index : integer;
  nContacts : integer;
begin
  Result := nil;
  nContacts := Length(fContacts);
  for index := Low(fContacts) to High(fContacts) do
  begin
    if fContacts[index].contactDetails.acoContactId = aContactId then
    begin
      Result := fContacts[index];
      break;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Returns the Contact that has been assigned the specified Role.
function TContactsManager.GetContactByRole(aRoleId : integer) : TAccountContact;
var
  cIndex  : integer;
  rIndex  : integer;
  contact : TAccountContact;
begin
  Result := nil;
  if GetNumContacts > 0 then
  begin
    for cIndex := Low(fContacts) to High(fContacts) do
    begin
      contact := fContacts[cIndex];
      if Length(contact.AssignedRoles) > 0 then
      begin
        for rIndex := Low(contact.AssignedRoles) to High(contact.AssignedRoles) do
        begin
          if contact.assignedRoles[rindex].crRoleId = aRoleId then
          begin
            Result := contact;
            // Found it, so we can quit the loop.
            break;
          end;
        end;
      end;
      if Result <> nil then
        break;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Returns an array of Contacts that have been assigned the specified Role.
function TContactsManager.GetContactListByRole(aRoleId : integer) : TArrayOfAccountContacts;
var
  cIndex  : integer;
  rIndex  : integer;
  contact : TAccountContact;
  contacts : TArrayOfAccountContacts;
begin
  Result := nil;
  if GetNumContacts > 0 then
  begin
    for cIndex := Low(fContacts) to High(fContacts) do
    begin
      contact := fContacts[cIndex];
      if Length(contact.AssignedRoles) > 0 then
      begin
        for rIndex := Low(contact.AssignedRoles) to High(contact.AssignedRoles) do
        begin
          if contact.assignedRoles[rindex].crRoleId = aRoleId then
          begin
            SetLength(contacts, Length(contacts)+1);
            contacts[High(contacts)] := contact;
          end;
        end;
      end;
    end;
  end;
  Result := contacts;
end;

//------------------------------------------------------------------------------
// Returns a semi-colon separated list of Contact Emails for all contacts that
//  have been assigned the specified Role.
function TContactsManager.GetContactEmailsByRole(aRoleId : integer) : AnsiString;
var
  emailList    : string;
  altEmailList : string;
  GeneralContactRoleId : integer;
  cIndex    : integer;
  rIndex    : integer;
  oContact  : TAccountContact;
  oRole     : ContactRoleRecType;
  foundContact : Boolean;
begin
  emailList    := '';
  altEmailList := '';
  foundContact := false;

  // GetRoleByDescription uses a case-insensitive comparison
  oRole := GetRoleByDescription('General Contact');
  GeneralContactRoleId := oRole.crRoleId;

  if (GetNumContacts > 0) then
  begin
    // Loop through the contacts
    for cIndex := 0 to GetNumContacts-1 do
    begin
      oContact := GetContact(cIndex);
      // See if this contact has been assigned the specified role.
      if Length(oContact.assignedRoles) > 0 then
      begin
        // For each of this contact's assigned roles...
        for rIndex := 0 to Length(oContact.assignedRoles)-1 do
        begin
          if oContact.assignedRoles[rIndex].crRoleId = aRoleId then
          begin
            // Add the email address if it has been specified
            if oContact.contactDetails.acoContactEmailAddress <> '' then
            begin
              // Add the contact name
              emailList := emailList + oContact.contactDetails.acoContactName + ';';
              // Add the contact email
              emailList := emailList + oContact.contactDetails.acoContactEmailAddress + ';';
            end;
          end;

          // PKR. 30/01/2014. ABSEXCH-14987. If no contacts are found for the
          //  specified role, then return General Contacts instead.
          if oContact.assignedRoles[rIndex].crRoleId = GeneralContactRoleId then
          begin
            // Add the email address if it has been specified
            if oContact.contactDetails.acoContactEmailAddress <> '' then
            begin
              // Add the contact name
              altEmailList := altEmailList + oContact.contactDetails.acoContactName + ';';
              // Add the contact email
              altEmailList := altEmailList + oContact.contactDetails.acoContactEmailAddress + ';';
            end;
          end;
        end;
      end;
    end;
  end;

  // PKR. 30/01/2014. ABSEXCH-14987. If there are no email addresses for the
  // specified role, use the list of email addresses for the General Contact role instead.
  // If that is also empty, then the calling code should handle it.
  if (emailList <> '') then
  begin
    Result := emailList
  end
  else
  begin
    Result := altEmailList;
  end;
end;

//------------------------------------------------------------------------------
// Returns the first contact that has been assigned the specified role, who also
//  has a fax number specified.
// PKR. 30/01/2014. ABSEXCH-14987. If none is found, look for a General Contact
//  who has a fax number.
function TContactsManager.GetFaxContactForRole(aRoleId : integer) : TAccountContact;
var
  cIndex    : integer;
  rIndex    : integer;
  GeneralContactRoleId : integer;
  oContact  : TAccountContact;
  oRole     : ContactRoleRecType;
begin
  Result := nil;

  // GetRoleByDescription uses a case-insensitive comparison
  oRole := GetRoleByDescription('General Contact');
  GeneralContactRoleId := oRole.crRoleId;

  if (GetNumContacts > 0) then
  begin
    // Loop through the contacts
    for cIndex := 0 to GetNumContacts-1 do
    begin
      oContact := GetContact(cIndex);
      for rIndex := 0 to Length(oContact.assignedRoles)-1 do
      begin
        if oContact.assignedRoles[rIndex].crRoleId = aRoleId then
        begin
          if oContact.contactDetails.acoContactFaxNumber <> '' then
          begin
            Result := oContact;
            break;
          end;
        end;
      end;
      if (Result <> nil) then
        break;
    end;

    // PKR. 30/01/2014. ABSEXCH-14987. If there is no fax number for the specified
    //  use the list of email addresses for the General Contact role instead.
    if (Result = nil) then
    begin
      for cIndex := 0 to GetNumContacts-1 do
      begin
        oContact := GetContact(cIndex);
        for rIndex := 0 to Length(oContact.assignedRoles)-1 do
        begin
          if oContact.assignedRoles[rIndex].crRoleId = GeneralContactRoleId then
          begin
            if oContact.contactDetails.acoContactFaxNumber <> '' then
            begin
              Result := oContact;
              break;
            end;
          end;
        end;
        if (Result <> nil) then
          break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Returns a contact's Id, based on a case-insensitive match.
function TContactsManager.GetContactIdByName(aName : string) : integer;
var
  index  : integer;
begin
  Result := -1;

  // Look through all the contacts to see if we can find the name
  if (GetNumContacts > 0) then
  begin
    for index := Low(fContacts) to High(fContacts) do
    begin
      if Lowercase(fContacts[index].contactDetails.acoContactName) =
         Lowercase(aName) then
      begin
        Result := fContacts[index].contactDetails.acoContactId;
        break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Returns true if the specified name does not already exist in the Contacts list.
function TContactsManager.isUniqueContactName(aName : string) : boolean;
var
  index  : integer;
begin
  Result := true;
  
  // Look through all the contacts to see if there is a Name collision
  if (GetNumContacts > 0) then
  begin
    for index := Low(fContacts) to High(fContacts) do
    begin
      if Lowercase(fContacts[index].contactDetails.acoContactName) =
         Lowercase(aName) then
      begin
        Result := false;
        break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Returns the number of roles in the list
function TContactsManager.GetNumRoles : integer;
begin
  Result := Length(fRoles);
end;

//------------------------------------------------------------------------------
// Returns the number of Contacts in the list
function TContactsManager.GetNumContacts : integer;
begin
  Result := Length(fContacts);
end;


//------------------------------------------------------------------------------
// Adds the specified Contact to the contacts list.
function TContactsManager.AddContact(aContact : TAccountContact) : integer;
var
  newContact : TAccountContact;
  cIndex     : integer;
  index      : integer;
begin
  SetLength(fContacts, Length(fContacts)+1);
  cIndex := High(fContacts);

  fContacts[cIndex] := TAccountContact.Create;
  newContact := fContacts[cIndex];

  newContact.contactDetails.acoContactId := aContact.contactDetails.acoContactId;
  newContact.contactDetails.acoAccountCode := aContact.contactDetails.acoAccountCode;
  newContact.contactDetails.acoContactName := aContact.contactDetails.acoContactName;
  newContact.contactDetails.acoContactJobTitle := aContact.contactDetails.acoContactJobTitle;
  newContact.contactDetails.acoContactPhoneNumber := aContact.contactDetails.acoContactPhoneNumber;
  newContact.contactDetails.acoContactFaxNumber := aContact.contactDetails.acoContactFaxNumber;
  newContact.contactDetails.acoContactEmailAddress := aContact.contactDetails.acoContactEmailAddress;
  newContact.contactDetails.acoContactHasOwnAddress := aContact.contactDetails.acoContactHasOwnAddress;
  newContact.contactDetails.acoContactAddress[1] := aContact.contactDetails.acoContactAddress[1];
  newContact.contactDetails.acoContactAddress[2] := aContact.contactDetails.acoContactAddress[2];
  newContact.contactDetails.acoContactAddress[3] := aContact.contactDetails.acoContactAddress[3];
  newContact.contactDetails.acoContactAddress[4] := aContact.contactDetails.acoContactAddress[4];
  newContact.contactDetails.acoContactAddress[5] := aContact.contactDetails.acoContactAddress[5];
  newContact.contactDetails.acoContactPostCode := aContact.contactDetails.acoContactPostCode;
  // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  newContact.contactDetails.acoContactCountry := aContact.contactDetails.acoContactCountry;

  // PKR. 19/02/2014. ABSEXCH-15087. Couldn't assign roles immediately after adding a contact.
  newContact.dateModified                      := aContact.dateModified;

  if Length(aContact.assignedRoles) > 0 then
  begin
    SetLength(newContact.assignedRoles, Length(aContact.assignedRoles));
    for index := Low(aContact.assignedRoles) to High(aContact.assignedRoles) do
    begin
      newContact.assignedRoles[index].crRoleId := aContact.assignedRoles[index].crRoleId;
      newContact.assignedRoles[index].crRoleDescription := aContact.assignedRoles[index].crRoleDescription;
      newContact.assignedRoles[index].crRoleAppliesToCustomer := aContact.assignedRoles[index].crRoleAppliesToCustomer;
      newContact.assignedRoles[index].crRoleAppliesToSupplier := aContact.assignedRoles[index].crRoleAppliesToSupplier;
    end;
  end;
  SortContacts;

  // PKR. 10/02/2014.  Return the index of the added contact after sorting the contacts
  Result := IndexOf(aContact.contactDetails.acoContactId);
end;

//------------------------------------------------------------------------------
// Returns the index of the Contact with the specified ID.
function TContactsManager.IndexOf(aContactId : integer) : integer;
var
  index : integer;
  numContacts : integer;
begin
  Result := -1;
  numContacts := Length(fContacts);
  if Length(fContacts) > 0 then
  begin
    for index := Low(fContacts) to High(fContacts) do
    begin
      if fContacts[index].contactDetails.acoContactId = aContactId then
      begin
        Result := index;
        break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Pads a string with trailing spaces to the specified length.
// Also trims an over-length string to the specified length.
function TContactsManager.PadWithSpaces(aString : string; aLength : integer) : string;
var
  workStr : string;
begin
  workStr := Trim(aString);
  // Pad with trailing spaces.
  while Length(workStr) < aLength do
  begin
    workStr := workStr + ' ';
  end;
  
  // Reduce an over-length string.
  if Length(workStr) > aLength then
  begin
    workStr := Copy(workStr, 1, aLength);
  end;
    
  Result := workStr;
end;

//------------------------------------------------------------------------------
// PKR. 04/11/2013.  Moved from ContactEditor.pas to make this business object 
//  more self-contained.
//
// Validates the data in the form and returns false if there is a problem.
// Displays a message for the first error found only.
//
// Validation rules:
// These are quite simple, but could be extended later.
// 1) No leading or trailing whitespace. This is enforced - not reported.
// 2) Name is mandatory
// 3) Name to be unique within the contact list - validate if in Add mode.
// 4) Email address must appear valid. i.e. name@domain.tld as minumum - must
//    have an '@' and a '.' separated by other characters.
// 5) Account Code must be the same as the current one
// 6) Assigned Roles must be appropriate for the account type (Customer/Supplier)
// 7) Country Code must be specified on the Address
function TContactsManager.ValidateContact(var aContact : TAccountContact;
                              aEditMode : TEditModes) : TContactValidationCodes;
const
  minAddressLines = 3;
var
  haveFoundAnError : Boolean;
  exploder         : TStringList;
  atPos            : integer;
  dotPos           : integer;
  index            : integer;
  contactId        : integer;
  accountType      : string;
  theRole          : ContactRoleRecType;
begin
  Result := cvOK;

  // This is used so that we report the first error encountered
  haveFoundAnError := false;

  // Rule 1) Enforced removal of leading and trailing whitespace
  aContact.contactDetails.acoContactName         := Trim(aContact.contactDetails.acoContactName);
  aContact.contactDetails.acoContactJobTitle     := Trim(aContact.contactDetails.acoContactJobTitle);
  aContact.contactDetails.acoContactPhoneNumber  := Trim(aContact.contactDetails.acoContactPhoneNumber);
  aContact.contactDetails.acoContactFaxNumber    := Trim(aContact.contactDetails.acoContactFaxNumber);
  aContact.contactDetails.acoContactEmailAddress := Trim(aContact.contactDetails.acoContactEmailAddress);
  aContact.contactDetails.acoContactAddress[1]   := Trim(aContact.contactDetails.acoContactAddress[1]);
  aContact.contactDetails.acoContactAddress[2]   := Trim(aContact.contactDetails.acoContactAddress[2]);
  aContact.contactDetails.acoContactAddress[3]   := Trim(aContact.contactDetails.acoContactAddress[3]);
  aContact.contactDetails.acoContactAddress[4]   := Trim(aContact.contactDetails.acoContactAddress[4]);
  aContact.contactDetails.acoContactAddress[5]   := Trim(aContact.contactDetails.acoContactAddress[5]);
  aContact.contactDetails.acoContactPostCode     := Trim(aContact.contactDetails.acoContactPostCode);
  // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  aContact.contactDetails.acoContactCountry      := Trim(aContact.contactDetails.acoContactCountry);

  // Rule 2) Contact Name.  Mandatory field.
  if aContact.contactDetails.acoContactName = '' then
  begin
    haveFoundAnError := true;
    Result := cvMissingName;
  end;

  // Rule 3) Contact name is unique
  if not haveFoundAnError then
  begin
    if aEditMode = emAdd then
    begin
      if (not isUniqueContactName(aContact.contactDetails.acoContactName)) then
      begin
        haveFoundAnError := true;
        Result := cvNameNotUnique;
      end;
    end
    else
    begin
      // Not adding, so we must be editing.  We can not allow the name to be
      //  changed to the same as a different record.
      contactId := GetContactIdByName(aContact.contactDetails.acoContactName);
      if (contactId <> aContact.contactDetails.acoContactId) then
      begin
        // Found a different record with the same name, so disallow it.
        haveFoundAnError := true;
        Result := cvNameNotUnique;
      end;
    end;
  end;

  if not haveFoundAnError then
  begin
    // Rule 4) Email address must appear valid.
    if aContact.contactDetails.acoContactEmailAddress <> '' then
    begin
      if not ValidateEmailAddress(aContact.contactDetails.acoContactEmailAddress) then
      begin
        Result := cvInvalidEmailAddress;
        haveFoundAnError := true;
      end;
    end;
  end;

  if not haveFoundAnError then
  begin
    // Rule 5) Account Code must be the same as the current one
    if (aContact.contactDetails.acoAccountCode <> fCustomerCode) then
    begin
      Result := cvIncorrectAccountCode;
      haveFoundAnError := true;
    end;
  end;

  if not haveFoundAnError then
  begin
    // Rule 6) Assigned Roles must be appropriate for the account type (Customer/Supplier)
    accountType := GetAccountType(fCustomerCode);
    if (accountType = 'C') or (accountType = 'S') then
    begin
      // This is a Customer or Supplier
      // Check each assigned role to ensure it is appropriate to the account type
      if Length(aContact.assignedRoles) > 0 then
      begin
        for index := 0 to Length(aContact.assignedRoles)-1 do
        begin
          // PKR. 10/02/2014. Corrected logic to find inappropriate role type.
          if ((not aContact.assignedRoles[index].crRoleAppliesToCustomer) and (accountType = 'C')) or
             ((not aContact.assignedRoles[index].crRoleAppliesToSupplier) and (accountType = 'S')) then
          begin
            Result := cvIncorrectRoleForAccountType;
            break;  // Found a bad one - no need to check further.
          end;
        end;
      end;
    end
    else
    begin
      // A Consumer, a bad database record, or not found.
      if (accountType = '') then
      begin
        Result := cvAccountNotFound;
      end
      else
      begin
        Result := cvInvalidAccountType;
      end;
      haveFoundAnError := true;
    end;
  end;

  if not haveFoundAnError then
  begin
    // Rule 7) Country Code must be specified on the Address
    if aContact.contactDetails.acoContactHasOwnAddress And (Not ValidCountryCode (ifCountry2, aContact.contactDetails.acoContactCountry)) Then
    begin
      Result := cvInvalidCountry;
      haveFoundAnError := true;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TContactsManager.SortContacts;
var
  tempContact : TAccountContact;
  index       : integer;
  swapped     : boolean;
begin
  if (GetNumContacts > 1) then
  begin
    swapped := true;
    while (swapped) do
    begin
      swapped := false;
      for index := Low(fContacts) to High(fContacts)-1 do
      begin
        if (CompareText(fContacts[index+1].contactDetails.acoContactName,
                        fContacts[index].contactDetails.acoContactName) < 0) then
        begin
          // Swap them
          tempContact        := fContacts[index];
          fContacts[index]   := fContacts[index+1];
          fContacts[index+1] := tempContact;
          swapped := true;
        end;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
function TContactsManager.FormatSQLDateTime(aDateTime : TDateTime) : string;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', aDateTime);
end;

//------------------------------------------------------------------------------

//PR: 14/02/2014 ABSEXCH-15039/15040 Procedure to delete all contacts for the current account - called when
//                                   deleting an account.
procedure TContactsManager.DeleteAllContacts;
var
  i : integer;
begin
  //Delete all contacts for current account
  for i := 0 to Length(fContacts) - 1 do
    DeleteContactFromDB(fContacts[i].contactDetails.acoContactID);

  //Reload to clear contact list
  ReadContactListFromDB;
end;

end.
