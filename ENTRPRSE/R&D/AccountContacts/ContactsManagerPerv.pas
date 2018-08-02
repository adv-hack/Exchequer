unit ContactsManagerPerv;

// 21/10/2013. PKR.  Factored out of the TContactsManager.

{
TContactsManagerPerv is a class derived from TContactsManager specifically for
Pervasive databases.  All database-specific methods are abstract in the parent 
class and are implemented here.

Any non-database methods are implemented in the parent class.

--------------------------------------------------------------------------------
This class is decoupled from the Exchequer user interface in a move towards
a Business Object based model.

DO NOT ADD ANY USER INTERFACE CODE TO THIS UNIT.
--------------------------------------------------------------------------------
}

interface

uses
  Classes,
  SysUtils,

//  Dialogs, // use this unit for ShowMessage during development.

  oContactRoleBtrieveFile,
  oAccountContactRoleBtrieveFile,
  oAccountContactBtrieveFile,

  AccountContactRoleUtil,
  ContactsManager,

  GlobVar,
  varConst,

  BTKeys1u,
  BtrvU2;

const
  success = 0;

type
  TContactsManagerPerv = class(TContactsManager)
  protected
    // Pervasive specific attributes
    fContactRoleFile        : TContactRoleBtrieveFile;
    fContactFile            : TAccountContactBtrieveFile;
    fAccountContactRoleFile : TAccountContactRoleBtrieveFile;

    // Pervasive specific DB methods
    procedure ReadRoleListFromDB; override;
    procedure ReadContactListFromDB; override;
    procedure ReadRoleAssignmentsFromDB; override;
    function  DeleteContactRolesFromDB(aContactId : integer) : integer; override;
    // PKR. 07/02/2014.  Added to extand validation for toolkit users
    function  GetAccountType(aAccountCode : string) : string; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;

    function  SaveContactToDB(aContact : TAccountContact; aEditMode : TEditModes) : integer; override;
    function  DeleteContactFromDB(aContactId : integer): Boolean; override;
    function  GetNextContactId : integer; override;
    function  ReloadContactFromDB(aContactId : integer) : Boolean; override;

    function  LockContact(aContactId : integer) : Boolean; override;
    function  UnlockContact(aContactId : integer) : Boolean; override;

    //PR: 14/02/2014 ABSEXCH-15038
    function ChangeAccountCode(OldCode, NewCode : string) : Boolean; override;

  end;

implementation

//PR: 07/03/2014 ABSEXCH-15121 Removed CustIntU from uses clause as having it here is not needed and causes problems.
{uses
  CustIntU;}

//==============================================================================
constructor TContactsManagerPerv.Create(AOwner : TComponent);
var
  iStatus : integer;
begin
  inherited;

  // Create a Contact file object
  fContactFile := TAccountContactBtrieveFile.Create;
  // Open it.
  iStatus := fContactFile.OpenFile(SetDrive + 'Cust\AccountContact.Dat', True); // Create if missing
  if (iStatus <> success) then
  begin
    Raise Exception.Create ('Pervasive Contacts : Error ' + IntToStr(iStatus) + ' occurred opening ' + SetDrive + 'Cust\AccountContact.Dat');
  end;

  // Create a Role Assignment file object
  fAccountContactRoleFile := TAccountContactRoleBtrieveFile.Create;
  iStatus := fAccountContactRoleFile.OpenFile(SetDrive + 'Cust\AccountContactRole.Dat', True); // Create if missing
  // Open it.
  if (iStatus <> success) then
  begin
    Raise Exception.Create ('Pervasive Contacts : Error ' + IntToStr(iStatus) + ' occurred opening ' + SetDrive + 'Cust\AccountContactRole.Dat');
  end;

  // Get the static list of Roles.
  ReadRoleListFromDB;
end;

      
//------------------------------------------------------------------------------
destructor TContactsManagerPerv.Destroy;
begin
  // Close and free the data files
  fContactFile.CloseFile;
  fContactFile.Free;

  fAccountContactRoleFile.CloseFile;
  fAccountContactRoleFile.Free;

  inherited;
end;

//------------------------------------------------------------------------------
// The Roles file is used only to get a list of roles, so it doesn't need to be
//  kept open for the duration.  So it is opened and closed here.
procedure TContactsManagerPerv.ReadRoleListFromDB;
var
  iStatus : integer;
  index   : integer;
begin
  // Create a Role file object
  fContactRoleFile := TContactRoleBtrieveFile.Create;
  try
    iStatus := fContactRoleFile.OpenFile(SetDrive + 'Cust\ContactRole.Dat', True); // Create if missing
    if iStatus = success then
    begin
      if fContactRoleFile.GetRecordCount > 0 then
      begin
        // Set the size of the Roles array
        Setlength(fRoles, fContactRoleFile.GetRecordCount);
        index := 0;

        iStatus := fContactRoleFile.GetFirst;
        while (iStatus = success) do
        begin
          // PKR. 11/02/2014. ABSEXCH-15023 Suppress "Send Order" and
          //  "Send Delivery Note" for non-SPOP systems.

          // PR: 12/02/2014 Amended to check licence at run-time to avoid issues with toolkit/importer etc.
          if IsValidRoleId(fContactRoleFile.ContactRole.crRoleId) then
          begin
            // Copy the details into the Role List record.
            fRoles[index].crRoleId := fContactRoleFile.ContactRole.crRoleId;
            fRoles[index].crRoleDescription := Trim(fContactRoleFile.ContactRole.crRoleDescription);
            fRoles[index].crRoleAppliesToCustomer := fContactRoleFile.ContactRole.crRoleAppliesToCustomer;
            fRoles[index].crRoleAppliesToSupplier := fContactRoleFile.ContactRole.crRoleAppliesToSupplier;
          end;

          // Look for the next record
          iStatus := fContactRoleFile.GetNext;
          // and move to the next entry in the roles list.
          inc(index);
        end;
      end;
    
      fContactRoleFile.CloseFile;
    end; // If iStatus = success
  finally
    // Free the Role file object
    fContactRoleFile.Free;
  end;
end;

//------------------------------------------------------------------------------
// Reads the contact list for the selected Account.
procedure TContactsManagerPerv.ReadContactListFromDB;
var
  iStatus      : integer;
  index        : integer;
  iNumContacts : integer;
  keyS         : Str255;
begin
  // PKR. 22/10/2013.  Clear the list to prevent duplicates.
  Setlength(fContacts, 0);

  iNumContacts := fContactFile.GetRecordCount;
  if iNumContacts > 0 then
  begin
    // PKR. 07/11/2013. Added call to FullCustCode.
    keyS               := FullCustCode(fCustomerCode);
    fContactFile.Index := acoIdxAccountContactName;

    iStatus            := fContactFile.GetGreaterThanOrEqual(keyS);

    // PKR. 07/11/2013. Moved test for key value to while-loop condition to
    //  stop the loop running to EOF.
    while ((iStatus = success) and
           (fContactFile.AccountContact.acoAccountCode = keyS)) do
    begin
      // Set the size of the Contacts array
      Setlength(fContacts, Length(fContacts)+1);
      index := High(fContacts);

      // Contacts is an array of objects (roles is an array of records), so
      //  we need to create an instance of the object.
      fContacts[index] := TAccountContact.Create;

      fContacts[index].contactDetails.acoContactId            := fContactFile.AccountContact.acoContactId;
      fContacts[index].contactDetails.acoAccountCode          := fContactFile.AccountContact.acoAccountCode;
      fContacts[index].contactDetails.acoContactName          := Trim(fContactFile.AccountContact.acoContactName);
      fContacts[index].contactDetails.acoContactJobTitle      := Trim(fContactFile.AccountContact.acoContactJobTitle);
      fContacts[index].contactDetails.acoContactPhoneNumber   := Trim(fContactFile.AccountContact.acoContactPhoneNumber);
      fContacts[index].contactDetails.acoContactFaxNumber     := Trim(fContactFile.AccountContact.acoContactFaxNumber);
      fContacts[index].contactDetails.acoContactEmailAddress  := Trim(fContactFile.AccountContact.acoContactEmailAddress);
      fContacts[index].contactDetails.acoContactHasOwnAddress := fContactFile.AccountContact.acoContactHasOwnAddress;
      fContacts[index].contactDetails.acoContactAddress[1]    := Trim(fContactFile.AccountContact.acoContactAddress[1]);
      fContacts[index].contactDetails.acoContactAddress[2]    := Trim(fContactFile.AccountContact.acoContactAddress[2]);
      fContacts[index].contactDetails.acoContactAddress[3]    := Trim(fContactFile.AccountContact.acoContactAddress[3]);
      fContacts[index].contactDetails.acoContactAddress[4]    := Trim(fContactFile.AccountContact.acoContactAddress[4]);
      fContacts[index].contactDetails.acoContactAddress[5]    := Trim(fContactFile.AccountContact.acoContactAddress[5]);
      fContacts[index].contactDetails.acoContactPostCode      := Trim(fContactFile.AccountContact.acoContactPostCode);
      // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
      fContacts[index].contactDetails.acoContactCountry       := fContactFile.AccountContact.acoContactCountry;

      // Look for the next record
      iStatus := fContactFile.GetNext;
    end;
  end;
end;

//------------------------------------------------------------------------------
// PKR. 14/01/2014. Added to allow the currently selected contact to be
//  re-loaded immediately before editing it.
function TContactsManagerPerv.ReloadContactFromDB(aContactId : integer) : boolean;
var
  iStatus      : integer;
  index        : integer;
  iNumContacts : integer;
  keyS         : Str255;
  theContact   : TAccountContact;
  theRole      : ContactRoleRecType;
begin
  Result := false;

  theContact := GetContactById(aContactId);
  if (theContact <> nil) then
  begin
    iNumContacts := fContactFile.GetRecordCount;
    if iNumContacts > 0 then
    begin
      keyS               :=  FullNomKey(aContactId); // PS - 20/10/2015 - ABSEXCH-15581
      fContactFile.Index := acoIdxContactId;

      iStatus            := fContactFile.GetEqual(keyS);
      if (iStatus = success) then
      begin
        theContact := GetContactById(aContactId);
        if (theContact <> nil) then
        begin
          theContact.contactDetails.acoContactId            := fContactFile.AccountContact.acoContactId;
          theContact.contactDetails.acoAccountCode          := fContactFile.AccountContact.acoAccountCode;
          theContact.contactDetails.acoContactName          := Trim(fContactFile.AccountContact.acoContactName);
          theContact.contactDetails.acoContactJobTitle      := Trim(fContactFile.AccountContact.acoContactJobTitle);
          theContact.contactDetails.acoContactPhoneNumber   := Trim(fContactFile.AccountContact.acoContactPhoneNumber);
          theContact.contactDetails.acoContactFaxNumber     := Trim(fContactFile.AccountContact.acoContactFaxNumber);
          theContact.contactDetails.acoContactEmailAddress  := Trim(fContactFile.AccountContact.acoContactEmailAddress);
          theContact.contactDetails.acoContactHasOwnAddress := fContactFile.AccountContact.acoContactHasOwnAddress;
          theContact.contactDetails.acoContactAddress[1]    := Trim(fContactFile.AccountContact.acoContactAddress[1]);
          theContact.contactDetails.acoContactAddress[2]    := Trim(fContactFile.AccountContact.acoContactAddress[2]);
          theContact.contactDetails.acoContactAddress[3]    := Trim(fContactFile.AccountContact.acoContactAddress[3]);
          theContact.contactDetails.acoContactAddress[4]    := Trim(fContactFile.AccountContact.acoContactAddress[4]);
          theContact.contactDetails.acoContactAddress[5]    := Trim(fContactFile.AccountContact.acoContactAddress[5]);
          theContact.contactDetails.acoContactPostCode      := Trim(fContactFile.AccountContact.acoContactPostCode);
          // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
          theContact.contactDetails.acoContactCountry       := fContactFile.AccountContact.acoContactCountry;

          // Now we need to update the contact's list of assigned roles.
          // Clear the list
          SetLength(theContact.assignedRoles, 0);

          // Get a role assignment for this contact
          fAccountContactRoleFile.Index := acrIdxContactRole;
          keyS := FullNomKey(theContact.contactDetails.acoContactId);

          iStatus := fAccountContactRoleFile.GetGreaterThanOrEqual(keyS);

          while ((iStatus = success) and
                 (fAccountContactRoleFile.AccountContactRole.acrContactId = theContact.contactDetails.acoContactId)) do
          begin
            // Found one that belongs to this contact, so add it to their list
            Setlength(theContact.assignedRoles, Length(theContact.assignedRoles)+1);
            index := High(theContact.assignedRoles);

            //PR: 26/01/2016 ABSEXCH-16867 v2016 R1 Changed to use GetRoleById
            theRole := GetRoleById(fAccountContactRoleFile.AccountContactRole.acrRoleId);

            theContact.assignedRoles[index].crRoleId := fAccountContactRoleFile.AccountContactRole.acrRoleId;
            theContact.assignedRoles[index].crRoleDescription := GetRoleDescription(fAccountContactRoleFile.AccountContactRole.acrRoleId);
            theContact.assignedRoles[index].crRoleAppliesToCustomer := theRole.crRoleAppliesToCustomer;
            theContact.assignedRoles[index].crRoleAppliesToSupplier := theRole.crRoleAppliesToSupplier;

            iStatus := fAccountContactRoleFile.GetNext;
          end;
          Result := True; // PS - 20/10/2015 - ABSEXCH-15581
        end;
      end;
    end;
  end;
end;


//------------------------------------------------------------------------------
procedure TContactsManagerPerv.ReadRoleAssignmentsFromDB;
var
  sKey    : Str20;
  iStatus : integer;
  index   : integer;
  cIndex  : integer;
  theRole : ContactRoleRecType;
begin
  // Loop through the contact list
  for cIndex := Low(fContacts) to High(fContacts) do
  begin
    // Get a role assignment for this contact
    fAccountContactRoleFile.Index := acrIdxContactRole;
    sKey := FullNomKey(fContacts[cindex].contactDetails.acoContactId);

    iStatus := fAccountContactRoleFile.GetGreaterThanOrEqual(sKey);

    // PKR. 07/11/2013. Moved test for ContactId to while-loop condition to
    //  stop the loop running to EOF.
    while ((iStatus = success) and
           (fAccountContactRoleFile.AccountContactRole.acrContactId = fContacts[cIndex].contactDetails.acoContactId)) do
    begin
      // PKR. 11/02/2014. ABSEXCH-15023 Suppress "Send Order" and
      //  "Send Delivery Note" for non-SPOP systems.
      // Technically, if it is a non-SPOP system, then a contact should not have
      // been assigned unavailable roles, but if by some quirk it happens, then
      // it will cause problems when it is displayed, so we'll suppress them here
      // also.

      // PR: 12/02/2014 Amended to check licence at run-time to avoid issues with toolkit/importer etc.
      if IsValidRoleId(fAccountContactRoleFile.AccountContactRole.acrRoleId) then
      begin
        // Found one that belongs to this contact, so add it to their list
        Setlength(fContacts[cIndex].assignedRoles, Length(fContacts[cIndex].assignedRoles)+1);
        index := High(fContacts[cIndex].assignedRoles);

        //PR: 26/01/2016 ABSEXCH-16867 v2016 R1 Changed to use GetRoleById
        theRole := GetRoleById(fAccountContactRoleFile.AccountContactRole.acrRoleId);

        fContacts[cIndex].assignedRoles[index].crRoleId := fAccountContactRoleFile.AccountContactRole.acrRoleId;
        fContacts[cIndex].assignedRoles[index].crRoleDescription := GetRoleDescription(fAccountContactRoleFile.AccountContactRole.acrRoleId);
        fContacts[cIndex].assignedRoles[index].crRoleAppliesToCustomer := theRole.crRoleAppliesToCustomer;
        fContacts[cIndex].assignedRoles[index].crRoleAppliesToSupplier := theRole.crRoleAppliesToSupplier;
      end;

      iStatus := fAccountContactRoleFile.GetNext;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Returns 0 if save was successful.
function TContactsManagerPerv.SaveContactToDB(aContact  : TAccountContact;
                                              aEditMode : TEditModes) : integer;
var
  iStatus    : integer;
  rIndex     : integer;
  roleId     : integer;
  sKey       : Str20;
  contactId  : integer;
begin
  // In Edit mode we should already have the correct locked record.
  // In Add mode create a new record.
  if (aEditMode = emAdd) then
  begin
    // Adding a new record, so create a blank record
    fContactFile.InitialiseRecord;
    iStatus := 0;
  end
  else
  begin
    // Get the record
    fContactFile.Index := acoIdxContactId;
    sKey := FullNomKey(aContact.contactDetails.acoContactId);
    iStatus := fContactFile.GetEqual(sKey);
  end;

  if (iStatus = success) then
  begin
    // Copy the details into the new record
    with fContactFile.AccountContact do
    begin
      // PKR. 27/01/2014.
      // For Add, get the next Contact Id.
      if (aContact.contactDetails.acoContactId = 0) then
      begin
        contactId := GetNextContactId;
        // PKR. 11/02/2014. Update the record in the list with the new contact id.
        aContact.contactDetails.acoContactId := contactId;
      end
      else
      begin
        contactId := aContact.contactDetails.acoContactId;
      end;

      // PKR. 07/11/2013. Added call to FullCustCode.
      acoContactId            := contactId;
      acoAccountCode          := FullCustCode(aContact.contactDetails.acoAccountCode);
      acoContactName          := aContact.contactDetails.acoContactName;
      acoContactJobTitle      := aContact.contactDetails.acoContactJobTitle;
      acoContactPhoneNumber   := aContact.contactDetails.acoContactPhoneNumber;
      acoContactFaxNumber     := aContact.contactDetails.acoContactFaxNumber;
      acoContactEmailAddress  := aContact.contactDetails.acoContactEmailAddress;
      acoContactHasOwnAddress := aContact.contactDetails.acoContactHasOwnAddress;
      if (acoContactHasOwnAddress) then
      begin
        acoContactAddress[1]  := aContact.contactDetails.acoContactAddress[1];
        acoContactAddress[2]  := aContact.contactDetails.acoContactAddress[2];
        acoContactAddress[3]  := aContact.contactDetails.acoContactAddress[3];
        acoContactAddress[4]  := aContact.contactDetails.acoContactAddress[4];
        acoContactAddress[5]  := aContact.contactDetails.acoContactAddress[5];
        acoContactPostCode    := aContact.contactDetails.acoContactPostCode;
        // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
        acoContactCountry     := aContact.contactDetails.acoContactCountry;
      end
      else
      begin
        acoContactAddress[1]  := '';
        acoContactAddress[2]  := '';
        acoContactAddress[3]  := '';
        acoContactAddress[4]  := '';
        acoContactAddress[5]  := '';
        acoContactPostCode    := '';
        // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
        acoContactCountry     := '  ';
      end;
    end;

    if (aEditMode = emAdd) then
    //............................................................................
    // ADD
    //............................................................................
    begin
      // Add the Contact record to the database file
      iStatus := fContactFile.Insert;

      // Now we need to add the the assigned roles.
      if (iStatus = success) then
      begin
        if Length(aContact.assignedRoles) > 0 then
        begin
          for rIndex := 0 to Length(aContact.assignedRoles)-1 do
          begin
            roleId := aContact.assignedRoles[rIndex].crRoleId;
            // Create and save a record for this role assignment.
            fAccountContactRoleFile.InitialiseRecord;
            with fAccountContactRoleFile.AccountContactRole do
            begin
              acrContactId := contactId;
              acrRoleId    := roleId;
            end;

            // Add the Role Assignment record to the database file
            iStatus := fAccountContactRoleFile.Insert;
          end; // For each assigned role
        end;  // Contact has assigned roles
      end; // Contact saved successfully (iStatus = 0)

      // For Add mode, we set the newly-assigned contactId.  This is only really
      // used by SQL, but we'll also do it here for consistency.
      LastAddedContactId := contactId;
    end
    else
    //............................................................................
    // UPDATE
    //............................................................................
    begin
      // Update the record
      iStatus := fContactFile.Update;

      // Now update the assigned roles.  It is possible that we have unassigned some
      //  roles and assigned different ones (using the contact editor checkboxes)
      //  so we need to do unassign and assign.
      if (iStatus = success) then
      begin
        // Delete all role assignments for this contact.
        iStatus := DeleteContactRolesFromDB(contactId);
        if (iStatus = success) then
        begin
          // Loop through all the assigned roles and create records for them.
          if (Length(aContact.assignedRoles) > 0) then
          begin
            for rIndex := 0 to Length(aContact.assignedRoles)-1 do
            begin
              roleId := aContact.assignedRoles[rIndex].crRoleId;

              // Add a role assignment record to the database
              fAccountContactRoleFile.InitialiseRecord;
              with fAccountContactRoleFile.AccountContactRole do
              begin
                acrContactId := contactId;
                acrRoleId    := roleId;
              end;
              iStatus := fAccountContactRoleFile.Insert;

              if (iStatus <> success) then
              begin
                break;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  Result := iStatus;
end;

//------------------------------------------------------------------------------
function TContactsManagerPerv.DeleteContactFromDB(aContactId : integer): Boolean;
var
  iStatus  : integer;
  sKey     : Str20;
  oContact : TAccountContact;
begin
  Result := true;

  // Get the record
  fContactFile.Index := acoIdxContactId;
  sKey := FullNomKey(aContactId);
  iStatus := fContactFile.GetEqual(sKey);

  if (iStatus = success) then
  begin
    oContact := GetContactById(aContactId);
    if (oContact <> nil) then
    begin
      iStatus := DeleteContactRolesFromDB(oContact.contactDetails.acoContactId);
      if (iStatus <> success) then
      begin
        Result := false;
      end
      else
      begin
        // Now that we've deleted the assigned Roles from the database, we can
        //  safely delete the Contact.
        // Lock the record
        iStatus := fContactFile.Lock;
        if (iStatus = success) then
        begin
          // Delete the record (which also releases the lock)
          iStatus := fContactFile.Delete;
        end;
        Result := iStatus = success;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Deletes ALL contact roles for the specified contact from the database.
//  Used when deleting a contact.
function TContactsManagerPerv.DeleteContactRolesFromDB(aContactId : integer) : integer;
var
  sKey    : Str20;
  iStatus : integer;
begin
  // Find and delete all the records in the role assignments table for this contact
  fAccountContactRoleFile.Index := acrIdxContactRole;
  sKey := FullNomKey(aContactId);

  // Find the record for this ContactId/RoleId combination
  iStatus := fAccountContactRoleFile.GetGreaterThanOrEqual(sKey);

  while (iStatus = success) and
        (fAccountContactRoleFile.AccountContactRole.acrContactId = aContactId) do
  begin
    iStatus := fAccountContactRoleFile.Lock;
    if (iStatus = success) then
    begin
      iStatus := fAccountContactRoleFile.Delete;
    end;

    // Try the next record.
    iStatus := fAccountContactRoleFile.GetNext;
  end;

  // If key not found, or end of file, it's ok.
  if (iStatus = 4) or (iStatus = 9) then
  begin
    iStatus := success;
  end;

  Result := iStatus;
end;

//------------------------------------------------------------------------------
function TContactsManagerPerv.GetNextContactId : integer;
var
  iStatus      : integer;
begin
  // Set a default in case there are no existing records
  Result := 1;

  // Simply get the ID of the last record and add one.
  fContactFile.Index := acoIdxContactId;
  iStatus            := fContactFile.GetLast;
  
  if (iStatus = success) then
  begin
    Result := fContactFile.AccountContact.acoContactId + 1;
  end;
end;

//------------------------------------------------------------------------------
function TContactsManagerPerv.LockContact(aContactId : integer) : Boolean;
var
  sKey    : Str20;
  iStatus : integer;
begin
  // Find the Database File record for this contact
  fContactFile.Index := acoIdxContactId;
  sKey := FullNomKey(aContactId);
  iStatus := fContactFile.GetEqual(sKey);

  if (iStatus = success) then
  begin
    // lock the record
    iStatus := fContactFile.Lock;
    Result := (iStatus = success);
  end
  else
  begin
    // Couldn't find the contact.  Somebody else has deleted it?
    Result := false;
  end;
end;

function TContactsManagerPerv.UnlockContact(aContactId : integer) : Boolean;
var
  sKey    : Str20;
  iStatus : integer;
begin
  // Find the Database File record for this contact
  fContactFile.Index := acoIdxContactId;
  sKey := FullNomKey(aContactId);
  iStatus := fContactFile.GetEqual(sKey);

  if (iStatus = success) then
  begin
    // Unlock the record
    fContactFile.Unlock;
    Result := (iStatus = success);
  end
  else
  begin
    // Couldn't find the contact.  Somebody else has deleted it?
    Result := false;
  end;
end;

//------------------------------------------------------------------------------
// PKR. 07/02/2014.  Added to extand validation for toolkit users
// Consults the CustSupp table to get the account type.
// Returns (C)ustomer, (S)upplier, Cons(U)mer, or '' (not found)
function TContactsManagerPerv.GetAccountType(aAccountCode : string) : string;
var
  custSupp : string;
  subType  : string;

  keyS     : Str255;
  Status   : integer;
  accRec   : CustRec;
begin
  // Assume we won't find it.
  Result := '';

  // Read the CustSupp and acSubType fields from the CustSupp table.
  KeyS := FullCustCode(aAccountCode);
  Status := Find_Rec(B_GetEq, F[CustF], CustF, accRec, CustCodeK, KeyS);
  if (Status = 0) then
  begin
    // Found the record
    //TG 05/06/2017 18629- Travco - Import contact Roles - Finished with errors if less than 6 chars
    //HV 16/01/2018 ABSEXCH-19639: Pervasive Only: Creating New Roles gives "Account not found" error.
    if (trim(accRec.CustCode) = trim(aAccountCode)) then
    begin
      custSupp := accRec.CustSupp;
      subType  := accRec.acSubType;

      if ((UpperCase(custSupp) = 'C') or (UpperCase(custSupp) = 'S')) then
      begin
        Result := subType;
      end;
    end
  end;
end;

//------------------------------------------------------------------------------
//PR: 14/02/2014 ABSEXCH-15038 Function to change account code on contact records. Runs within a database transaction so
//                             that if one update fails, nothing is committed.
function TContactsManagerPerv.ChangeAccountCode(
   OldCode, NewCode : string): Boolean;
var
  KeyS : string;
  Res : Integer;
begin
  Result := False;

  //Start database transaction
  Res := Ctrl_BTransCID(B_BeginTrans, fContactFile.ClientId);
  if Res = 0 then
  Try
    Result := True;
    Try
      KeyS := FullCustCode(OldCode);
      fContactFile.Index := acoIdxAccountContactName;

      //Find first record for this account
      Res := fContactFile.GetGreaterThanOrEqual(KeyS);

      while Result and (Res = 0) and (fContactFile.AccountContact.acoAccountCode = KeyS) do
      begin
        //Lock record
        Res := fContactFile.Lock;

        if Res = 0 then
        begin
          //Set new code
          with fContactFile.AccountContact do
            acoAccountCode := NewCode;

          //Save record
          Res := fContactFile.Update;

          Result := Res = 0;
        end
        else
          Result := False;

        if Result then //Find first record with original account code
          Res := fContactFile.GetGreaterThanOrEqual(KeyS);
      end;
    Except
      Result := False;
    End;
  Finally
    //Finish database transaction
    if Result then
      Ctrl_BTransCID(B_EndTrans, fContactFile.ClientId)
    else
      Ctrl_BTransCID(B_AbortTrans, fContactFile.ClientId);

    //Reload contacts - whether success or failure, the contacts list will be empty, since
    //it will have already tried to load contacts with the new code.
    ReadContactListFromDB;
  End;
end;

end.
