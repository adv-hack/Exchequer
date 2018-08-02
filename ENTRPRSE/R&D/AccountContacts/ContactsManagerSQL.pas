unit ContactsManagerSQL;

// 21/10/2013. PKR.  Factored out of the TContactsManager.

// This class is decoupled from the Exchequer user interface in a move towards
// a Business Object based model.

// Contains pure database access methods.  All validation and confirmation must
// be done by the calling program.

// DO NOT ADD ANY USER INTERFACE CODE TO THIS UNIT.

interface

uses
  Classes,
  SysUtils,

//  Dialogs, // use this unit for ShowMessage during development.

  GlobVar,
  varConst,

  BtKeys1u,

  AccountContactRoleUtil,
  ContactsManager;  // The parent class.

const
  success = 0;

type
//##############################################################################
// TContactsManagerSQL
//##############################################################################
  TContactsManagerSQL = class(TContactsManager)
  private
    FCompanyCode : ShortString;
  protected
    // Database access methods
    procedure ReadRoleListFromDB; override;        // Read the roles from the database
    procedure ReadContactListFromDB; override;     // Read the contacts from the database
    procedure ReadRoleAssignmentsFromDB; override; // Read role assignments from the database
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

uses
  SQLUtils,
  SQLCallerU,
  ADOConnect,
  oContactRoleBtrieveFile; // For ContactRoleRecType, which is also used for SQL.

//==============================================================================
constructor TContactsManagerSQL.Create(AOwner : TComponent);
begin
  inherited;

  // Lookup the data path in the Company Table to determine the Company Code - cache in local
  // variable for performance 
  FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);

  // Get the static list of Roles.
  ReadRoleListFromDB;
end;


//------------------------------------------------------------------------------
destructor TContactsManagerSQL.Destroy;
begin
  inherited;
end;

//==============================================================================
// DB methods
//==============================================================================
procedure TContactsManagerSQL.ReadRoleListFromDB;
var
  index   : integer;
  sSQL    : String;
begin
  With TSQLCaller.Create(GlobalADOConnection) Do
  Begin
    Try
      // PKR. 13/01/2014. Added ORDER BY clause
      sSQL := 'SELECT crRoleId, ' +
                     'crRoleDescription, ' +
                     'crRoleAppliesToCustomer, ' +
                     'crRoleAppliesToSupplier ' +
              'FROM [COMPANY].ContactRole ' +
              'ORDER BY crRoleId ';

      Select(sSQL, FCompanyCode);
      if (ErrorMsg = '') And (Records.RecordCount > 0) then
      Begin
        Records.First;

        While (Not Records.EOF) Do
        Begin
          // Add the Role to the list

          // PKR. 11/02/2014. ABSEXCH-15023 Suppress "Send Order" and
          //  "Send Delivery Note" for non-SPOP systems.

          // PR: 12/02/2014 Amended to check licence at run-time to avoid issues with toolkit/importer etc.
          if IsValidRoleId(Records.FieldByName('crRoleId').Value) then
          begin
            // Set the size of the Roles array
            Setlength(fRoles, Length(fRoles)+1);
            index := High(fRoles);

            fRoles[index].crRoleId                := Records.FieldByName('crRoleId').Value;
            fRoles[index].crRoleDescription       := Records.FieldByName('crRoleDescription').Value;
            fRoles[index].crRoleAppliesToCustomer := Records.FieldByName('crRoleAppliesToCustomer').Value;
            fRoles[index].crRoleAppliesToSupplier := Records.FieldByName('crRoleAppliesToSupplier').Value;
          end;

          Records.Next;
        end;
      end;
    finally
      free;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TContactsManagerSQL.ReadContactListFromDB;
Var
  sSQL : String;
  index : integer;
Begin // LoadData
  // PKR. 22/10/2013.  Clear the list to prevent duplicates.
  Setlength(fContacts, 0);

  With TSQLCaller.Create(GlobalADOConnection) Do
  Begin
    Try
      sSQL := 'SELECT acoContactId, acoAccountCode, acoContactName, acoContactJobTitle, ' +
                     'acoContactPhoneNumber, acoContactFaxNumber, acoContactEmailAddress, ' +
                     'acoContactHasOwnAddress, acoContactAddress1, acoContactAddress2, ' +
                     'acoContactAddress3, acoContactAddress4, acoContactAddress5, ' +
                     'acoContactPostCode, acoContactCountry, acoDateModified ' +
              'FROM [COMPANY].AccountContact ' +
              'WHERE acoAccountCode = ' + QuotedStr(fCustomerCode) + ' ' +
              'ORDER BY acoContactName';

      Select(sSQL, FCompanyCode);
      if (ErrorMsg = '') And (Records.RecordCount > 0) then
      Begin
        Records.First;

        While (Not Records.EOF) Do
        Begin
          // Set the size of the Contacts array
          Setlength(fContacts, Length(fContacts)+1);
          index := High(fContacts);

          // Contacts is an array of objects (roles is an array of records), so
          //  we need to create an instance of the object.
          fContacts[index] := TAccountContact.Create;

          fContacts[index].contactDetails.acoContactId            := Records.FieldByName('acoContactId').Value;
          fContacts[index].contactDetails.acoAccountCode          := Records.FieldByName('acoAccountCode').Value;
          fContacts[index].contactDetails.acoContactName          := Records.FieldByName('acoContactName').Value;
          fContacts[index].contactDetails.acoContactJobTitle      := Records.FieldByName('acoContactJobTitle').Value;
          fContacts[index].contactDetails.acoContactPhoneNumber   := Records.FieldByName('acoContactPhoneNumber').Value;
          fContacts[index].contactDetails.acoContactFaxNumber     := Records.FieldByName('acoContactFaxNumber').Value;
          fContacts[index].contactDetails.acoContactEmailAddress  := Records.FieldByName('acoContactEmailAddress').Value;
          fContacts[index].contactDetails.acoContactHasOwnAddress := Records.FieldByName('acoContactHasOwnAddress').Value;
          fContacts[index].contactDetails.acoContactAddress[1]    := Records.FieldByName('acoContactAddress1').Value;
          fContacts[index].contactDetails.acoContactAddress[2]    := Records.FieldByName('acoContactAddress2').Value;
          fContacts[index].contactDetails.acoContactAddress[3]    := Records.FieldByName('acoContactAddress3').Value;
          fContacts[index].contactDetails.acoContactAddress[4]    := Records.FieldByName('acoContactAddress4').Value;
          fContacts[index].contactDetails.acoContactAddress[5]    := Records.FieldByName('acoContactAddress5').Value;
          fContacts[index].contactDetails.acoContactPostCode      := Records.FieldByName('acoContactPostCode').Value;
          // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
          fContacts[index].contactDetails.acoContactCountry       := Records.FieldByName('acoContactCountry').Value;
          // PKR. 13/01/2014. Added for optimistic locking
          fContacts[index].dateModified                           := Records.FieldByName('acoDateModified').Value;

          Records.Next;
        end;
      End;
    Finally
      Free;
    End; // Try..Finally
  End; // With TSQLCaller.Create(GlobalADOConnection)
end;

//------------------------------------------------------------------------------
// Reloads the selected contact.
// If the contact doesn't exist, return false.
// If it exists and it is in the list, then update it.
function TContactsManagerSQL.ReloadContactFromDB(aContactId : integer) : Boolean;
Var
  sSQL       : String;
  index      : integer;
  roleId     : integer;
  theContact : TAccountContact;
  theRole    : ContactRoleRecType;
begin
  Result := false;

  // Search for the record
  With TSQLCaller.Create(GlobalADOConnection) Do
  Begin
    Try
      sSQL := 'SELECT acoContactId, acoAccountCode, acoContactName, acoContactJobTitle, ' +
                     'acoContactPhoneNumber, acoContactFaxNumber, acoContactEmailAddress, ' +
                     'acoContactHasOwnAddress, acoContactAddress1, acoContactAddress2, ' +
                     'acoContactAddress3, acoContactAddress4, acoContactAddress5, ' +
                     'acoContactPostCode, acoContactCountry, acoDateModified ' +
              'FROM [COMPANY].AccountContact ' +
              'WHERE acoAccountCode = ' + QuotedStr(fCustomerCode) + ' ' +
              'AND acoContactId = ' + QuotedStr(IntToStr(aContactId));

      Select(sSQL, FCompanyCode);

      if (ErrorMsg = '') And (Records.RecordCount > 0) then
      begin
        // Found the record
        // Locate it in the list of contacts
        theContact := GetContactById(aContactId);
        if (theContact <> nil) then
        begin
          // Found it, so update the details
          theContact.contactDetails.acoContactId            := Records.FieldByName('acoContactId').Value;
          theContact.contactDetails.acoAccountCode          := Records.FieldByName('acoAccountCode').Value;
          theContact.contactDetails.acoContactName          := Records.FieldByName('acoContactName').Value;
          theContact.contactDetails.acoContactJobTitle      := Records.FieldByName('acoContactJobTitle').Value;
          theContact.contactDetails.acoContactPhoneNumber   := Records.FieldByName('acoContactPhoneNumber').Value;
          theContact.contactDetails.acoContactFaxNumber     := Records.FieldByName('acoContactFaxNumber').Value;
          theContact.contactDetails.acoContactEmailAddress  := Records.FieldByName('acoContactEmailAddress').Value;
          theContact.contactDetails.acoContactHasOwnAddress := Records.FieldByName('acoContactHasOwnAddress').Value;
          theContact.contactDetails.acoContactAddress[1]    := Records.FieldByName('acoContactAddress1').Value;
          theContact.contactDetails.acoContactAddress[2]    := Records.FieldByName('acoContactAddress2').Value;
          theContact.contactDetails.acoContactAddress[3]    := Records.FieldByName('acoContactAddress3').Value;
          theContact.contactDetails.acoContactAddress[4]    := Records.FieldByName('acoContactAddress4').Value;
          theContact.contactDetails.acoContactAddress[5]    := Records.FieldByName('acoContactAddress5').Value;
          theContact.contactDetails.acoContactPostCode      := Records.FieldByName('acoContactPostCode').Value;
          // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
          theContact.contactDetails.acoContactCountry       := Records.FieldByName('acoContactCountry').Value;

          theContact.dateModified := Records.FieldByName('acoDateModified').Value;

          with TSQLCaller.Create(GlobalADOConnection) do
          begin
            try
              // Now we need to update the contact's list of assigned roles.
              sSQL := 'SELECT acrRoleId FROM [COMPANY].AccountContactRole AS ACR' +
                      ' WHERE ACR.acrContactId = ' + QuotedStr(IntToStr(aContactId));
              Select(sSQL, FCompanyCode);

              // Clear the list
              SetLength(theContact.assignedRoles, 0);

              if (ErrorMsg = '') And (Records.RecordCount > 0) then
              begin
                Records.First;
                while (not Records.EOF) Do
                begin
                  roleId    := records.FieldByName('acrRoleId').Value;

                  theRole    := GetRoleById(roleId);

                  // Add a record to the Assigned Roles list
                  SetLength(theContact.assignedRoles, Length(theContact.assignedRoles)+1);
                  index := High(theContact.assignedRoles);

                  theContact.assignedRoles[index].crRoleId          := roleId;
                  theContact.assignedRoles[index].crRoleDescription := theRole.crRoleDescription;
                  theContact.assignedRoles[index].crRoleAppliesToCustomer := theRole.crRoleAppliesToCustomer;
                  theContact.assignedRoles[index].crRoleAppliesToSupplier := theRole.crRoleAppliesToSupplier;

                  Records.Next;
                end;
              end;

              Result := true;
            finally
              free
            end;
          end; // With TSQLCaller.Create
        end;
      end;
    finally
      free;  // the TSQLCaller
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TContactsManagerSQL.ReadRoleAssignmentsFromDB;
Var
  sSQL : String;
  index : integer;
  contactId : integer;
  roleId    : integer;
  theContact : TAccountContact;
  theRole    : ContactRoleRecType;
begin
  With TSQLCaller.Create(GlobalADOConnection) Do
  Begin
    Try
      // Get all records that apply to the Contacts for the selected account.

      // PKR. 14/01/2014. Modified to use aliases for legibility.
      sSQL := 'SELECT acrContactId, acrRoleId ' +
              '  FROM [COMPANY].AccountContactRole AS ACR ' +
              '  JOIN [COMPANY].AccountContact AS AC ON AC.[acoContactId] = ACR.acrContactId ' +
              ' WHERE AC.acoAccountCode = ''' + fCustomerCode + ''' ';


      Select(sSQL, FCompanyCode);
      if (ErrorMsg = '') And (Records.RecordCount > 0) then
      Begin
        Records.First;

        While (Not Records.EOF) Do
        Begin
          contactId := Records.FieldByName('acrContactId').Value;
          roleId    := records.FieldByName('acrRoleId').Value;

          // PKR. 11/02/2014. ABSEXCH-15023 Suppress "Send Order" and
          //  "Send Delivery Note" for non-SPOP systems.
          // Technically, if it is a non-SPOP system, then a contact should not have
          // been assigned unavailable roles, but if by some quirk it happens, then
          // it will cause problems when it is displayed, so we'll suppress them here
          // also.

          // PR: 12/02/2014 Amended to check licence at run-time to avoid issues with toolkit/importer etc.
          if IsValidRoleId(roleId) then
          begin
            // Get the Contact
            theContact := GetContactById(contactId);
            theRole    := GetRoleById(roleId);

            // Add a record to the Assigned Roles list
            SetLength(theContact.assignedRoles, Length(theContact.assignedRoles)+1);
            index := High(theContact.assignedRoles);

            theContact.assignedRoles[index].crRoleId          := roleId;
            theContact.assignedRoles[index].crRoleDescription := theRole.crRoleDescription;
            theContact.assignedRoles[index].crRoleAppliesToCustomer := theRole.crRoleAppliesToCustomer;
            theContact.assignedRoles[index].crRoleAppliesToSupplier := theRole.crRoleAppliesToSupplier;
          end;

          Records.Next;
        end;
      End;
    Finally
      Free;
    End; // Try..Finally
  End; // With TSQLCaller.Create(GlobalADOConnection)
end;

//------------------------------------------------------------------------------
// Inserts or Updates a Contact record as appropriate.
// EditMode can be emAdd or emEdit.
function TContactsManagerSQL.SaveContactToDB(aContact : TAccountContact;
                                             aEditMode : TEditModes) : integer;
var
  sSQL         : String;
  iStatus      : Integer;
  rIndex       : integer;
  roleId       : integer;
begin
  iStatus := success;

  if (aEditMode = emAdd) or (aEditMode = emEdit) then
  begin
    if (not aContact.contactDetails.acoContactHasOwnAddress) then
    begin
      aContact.contactDetails.acoContactAddress[1]    := '';
      aContact.contactDetails.acoContactAddress[2]    := '';
      aContact.contactDetails.acoContactAddress[3]    := '';
      aContact.contactDetails.acoContactAddress[4]    := '';
      aContact.contactDetails.acoContactAddress[5]    := '';
      aContact.contactDetails.acoContactPostCode      := '';
      // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
      aContact.contactDetails.acoContactCountry       := '  ';
    end;

    if (aEditMode = emAdd) then
    begin
      // Add the record to the database file
      With TSQLCaller.Create(GlobalADOConnection) Do
      Begin
        Try
          with aContact.contactDetails do
          begin
            // PKR. 14/01/2014.
            // Removed Version field which has been replaced by acoModifiedDate, which is
            // set using a trigger.

            // The SQL Emulator requires the positionId field, and it must be an
            // Identity field, so we can't make acoContactId an Identity field.
            // So we now update acoContactId from positionId using a trigger.
            // SQL Server won't allow triggers to be used in conjunction with an
            // OUTPUT clause unless it has an INTO clause, so we have to send the
            // required data to a temporary table and query that.

            // Note: acoContactId is a Non-Null field, so we have to write a
            // dummy value (0) into it to satisfy this.  The trigger will update it.

            // PKR. 27/01/2014.  Multiple SQL statements, separated by semi-colons.
            sSQL := 'DECLARE @ACI TABLE (acoContactId  INT);';

            sSQL := sSQL +
            'INSERT INTO [COMPANY].AccountContact ' +
               '(' +
                 'acoContactId' +
               ', acoAccountCode' +
               ', acoContactName' +
               ', acoContactJobTitle' +
               ', acoContactPhoneNumber' +
               ', acoContactFaxNumber' +
               ', acoContactEmailAddress' +
               ', acoContactHasOwnAddress' +
               ', acoContactAddress1' +
               ', acoContactAddress2' +
               ', acoContactAddress3' +
               ', acoContactAddress4' +
               ', acoContactAddress5' +
               ', acoContactPostCode' +
               ', acoContactCountry' +
               ')' +
            'OUTPUT INSERTED.PositionId INTO @ACI ' + // .acoContactId ' +
            'VALUES ( ' +
                  '0, ' +
                  QuotedStr(acoAccountCode)  + ', ' +
                  QuotedStr(acoContactName)  + ', ' +
                  QuotedStr(acoContactJobTitle)  + ', ' +
                  QuotedStr(acoContactPhoneNumber)  + ', ' +
                  QuotedStr(acoContactFaxNumber)  + ', ' +
                  QuotedStr(acoContactEmailAddress)  + ', ' +
                  IntToStr(Ord(acoContactHasOwnAddress))  + ', ' +
                  QuotedStr(acoContactAddress[1])  + ', ' +
                  QuotedStr(acoContactAddress[2])  + ', ' +
                  QuotedStr(acoContactAddress[3])  + ', ' +
                  QuotedStr(acoContactAddress[4])  + ', ' +
                  QuotedStr(acoContactAddress[5])  + ', ' +
                  QuotedStr(acoContactPostCode)    + ', ' +
                  QuotedStr(acoContactCountry) +
                '); ';

            sSQL := sSQL +
            'SELECT acoContactId FROM @ACI ';
          end;

          // PKR 24/01/2014. Changed from ExecSQL() to Select() so that it returns
          //  a results set
          Select(sSQL, FCompanyCode);

          if (ErrorMsg = '') And (Records.RecordCount > 0) then
          Begin
            Records.First;
            aContact.contactDetails.acoContactId := Records.FieldByName('acoContactId').Value;
            LastAddedContactId := aContact.contactDetails.acoContactId;
            iStatus := success;
          end
          else
          begin
            iStatus := -1;
          end;
        Finally
          Free;
        End; // Try..Finally
      End; // With TSQLCaller.Create(GlobalADOConnection)

      // PKR. 24/01/2014. Moved saving of assigned roles to here.
      // Loop through the roles for this contact.
      // The contact is new, so we don't need to unassign any roles.
      if (iStatus = success) then
      begin
        if Length(aContact.assignedRoles) > 0 then
        begin
          for rIndex := 0 to Length(aContact.assignedRoles)-1 do
          begin
            roleId := aContact.assignedRoles[rIndex].crRoleId;

            With TSQLCaller.Create(GlobalADOConnection) Do
            Begin
              Try
                sSQL := 'INSERT INTO [COMPANY].AccountContactRole ' +
                                '(acrContactId, acrRoleId) ' +
                        'VALUES (' +
                                IntToStr(aContact.contactDetails.acoContactId) + ', ' +
                                IntToStr(roleId) + ')';

                iStatus := ExecSQL(sSQL, FCompanyCode);

                if (iStatus <> 0) then
                begin
                  // Failed to do the insert, do don't try any more
                  break;
                end;
              finally
                free;
              end; // try
            end; // with TSQLCaller
          end; // for rIndex
        end; // if has roles
      end; // if iStatus = 0
    end // if Add mode
    else
    begin
      //........................................................................
      // Edit Mode.
      // Update the record in the database file

      // We need to check that the acoDateModified field hasn't changed since we
      //  read the record.  If it has, it means that somebody else has changed it
      //  in the meantime.
      With TSQLCaller.Create(GlobalADOConnection) Do
      Begin
        Try
          with aContact.contactDetails do
          sSQL := 'UPDATE [COMPANY].AccountContact ' +
                  'SET acoContactName          = ' + QuotedStr(acoContactName)  + ', ' +
                      'acoContactJobTitle      = ' + QuotedStr(acoContactJobTitle)  + ', ' +
                      'acoContactPhoneNumber   = ' + QuotedStr(acoContactPhoneNumber)  + ', ' +
                      'acoContactFaxNumber     = ' + QuotedStr(acoContactFaxNumber)  + ', ' +
                      'acoContactEmailAddress  = ' + QuotedStr(acoContactEmailAddress)  + ', ' +
                      'acoContactHasOwnAddress = ' + IntToStr(Ord(acoContactHasOwnAddress))  + ', ' +
                      'acoContactAddress1      = ' + QuotedStr(acoContactAddress[1])  + ', ' +
                      'acoContactAddress2      = ' + QuotedStr(acoContactAddress[2])  + ', ' +
                      'acoContactAddress3      = ' + QuotedStr(acoContactAddress[3])  + ', ' +
                      'acoContactAddress4      = ' + QuotedStr(acoContactAddress[4])  + ', ' +
                      'acoContactAddress5      = ' + QuotedStr(acoContactAddress[5])  + ', ' +
                      'acoContactPostCode      = ' + QuotedStr(acoContactPostCode)    + ', ' +
                      'acoContactCountry       = ' + QuotedStr(acoContactCountry)     +  ' ' +
                  'WHERE acoContactId    = ' + IntToStr(acoContactId) + ' ' +
                  'AND   acoDateModified = ' + QuotedStr(FormatSQLDateTime(aContact.dateModified));

          // iStatus: 0=success, -1=failure
          iStatus := ExecSQL(sSQL, FCompanyCode);

          if (iStatus = 0) then
          begin
            // Successful.  Check that a row was affected.
            if (LastRecordCount < 1) then
            begin
              // No rows affected, so it's an error
              iStatus := -1;
            end;
          end;
        finally
          Free;
        end;
      end;

      // Now we need to update the contact's roles list in the database.
      // The easiest way is to delete any assigned roles and and then reassign them.
      if (iStatus = success) then
      begin
        // Unassign any roles for this contact
        With TSQLCaller.Create(GlobalADOConnection) Do
        Begin
          Try
            sSQL := 'DELETE FROM [COMPANY].[AccountContactRole] ' +
                    'WHERE acrContactId = ' + IntToStr(aContact.contactDetails.acoContactId);

            // Will return -1 if it failed.  If it was successful, we don't care
            //  how many rows were affected as we must have succesfully deleted them.
            iStatus := ExecSQL(sSQL, FCompanyCode);
          finally
            free;
          end;
        end;

        if (iStatus = success) then
        begin
          // Assign the roles that it now has
          if Length(aContact.assignedRoles) > 0 then
          begin
            With TSQLCaller.Create(GlobalADOConnection) Do
            Begin
              Try
                for rIndex := 0 to Length(aContact.assignedRoles)-1 do
                begin
                  roleId := aContact.assignedRoles[rIndex].crRoleId;

                  sSQL := 'INSERT INTO [COMPANY].AccountContactRole ' +
                                  '(acrContactId, acrRoleId) ' +
                          'VALUES (' +
                                  IntToStr(aContact.contactDetails.acoContactId) + ', ' +
                                  IntToStr(roleId) +
                                  ')';

                  iStatus := ExecSQL(sSQL, FCompanyCode);

                  if (iStatus = 0) then
                  begin
                    // Successful.  Check that a row was affected.
                    if (LastRecordCount < 1) then
                    begin
                      // No rows affected, so it's an error
                      iStatus := -1;
                    end;
                  end;

                  if (iStatus <> 0) then
                  begin
                    // Failed to do the insert, do don't try any more
                    break;
                  end;
                end;
              finally
                free;
              end;
            end;
          end;
        end;
      end;
    end; // edit mode

    // PKR. 03/02/2014. ABSECH-15006.
    // Having saved the record, the trigger will have updated the acoDateModified
    //  field, so we need to reload the record so that we have the latest
    //  acoDateModified value.
    ReloadContactFromDB(aContact.contactDetails.acoContactId);
  end; // if add mode or edit mode

  Result := iStatus;
end;

//------------------------------------------------------------------------------
// Deletes the selected Contact from the database.
function TContactsManagerSQL.DeleteContactFromDB(aContactId : integer): Boolean;
var
  sSQL    : String;
  iStatus : Integer;
begin
  with TSQLCaller.Create(GlobalADOConnection) do
  begin
    Try
      // Delete the roles assigned to this contact
      iStatus := DeleteContactRolesFromDB(aContactId);

      if (iStatus = success) then
      begin
        // Delete the contact
        sSQL := 'DELETE FROM [COMPANY].AccountContact ' +
                ' WHERE [COMPANY].AccountContact.acoContactId = ''' + IntToStr(aContactId) + '''';

        iStatus := ExecSQL(sSQL, FCompanyCode);
      end;
    finally
      free;
    end;
  end;
  Result := (iStatus = success);
end;

//------------------------------------------------------------------------------
// Deletes ALL contact roles for the specified contact from the database.
//  Used when deleting a contact.
function TContactsManagerSQL.DeleteContactRolesFromDB(aContactId : integer) : integer;
var
  sSQL    : String;
  iStatus : Integer;
begin
  with TSQLCaller.Create(GlobalADOConnection) do
  begin
    Try
      sSQL := 'DELETE FROM [COMPANY].AccountContactRole ' +
              ' WHERE [COMPANY].AccountContactRole.acrContactId = ''' + IntToStr(aContactId) + ''' ';

      iStatus := ExecSQL(sSQL, FCompanyCode);
    finally
      free;
    end;
  end;
  Result := iStatus;
end;

//------------------------------------------------------------------------------
function TContactsManagerSQL.GetNextContactId : integer;
var
  sSQL : String;
begin
  // Set a default in case there are no existing records
  Result := 1;

  With TSQLCaller.Create(GlobalADOConnection) Do
  Begin
    Try
      sSQL := 'SELECT MAX(acoContactId) AS ''MaxCID'' FROM [COMPANY].AccountContact';
      
      Select(sSQL, FCompanyCode);

      if (ErrorMsg = '') And (Records.RecordCount > 0) then
      Begin
        Records.First;

        // If the table is empty, the above SQL returns a single record containing NULL
        //  so we have to check for it.
        if (not Records.FieldByName('MaxCID').IsNull) then
          Result := Records.FieldByName('MaxCID').Value + 1
        else
          Result := 1;
      end;
    finally
      free;
    end;
  end;
end;

//------------------------------------------------------------------------------
// These are required because Pervasive requires them.
function TContactsManagerSQL.LockContact(aContactId : integer) : Boolean;
begin
  Result := true;
end;

function TContactsManagerSQL.UnlockContact(aContactId : integer) : Boolean;
begin
  Result := true;
end;

//------------------------------------------------------------------------------
// PKR. 07/02/2014.  Added to extand validation for toolkit users
// Consults the CustSupp table to get the account type.
// Returns (C)ustomer, (S)upplier, Cons(U)mer, or '' (not found)
function TContactsManagerSQL.GetAccountType(aAccountCode : string) : string;
var
  sSQL     : string;
  custSupp : string;
  subType  : string;
begin
  // Assume we won't find it
  Result := '';

  With TSQLCaller.Create(GlobalADOConnection) Do
  Begin
    Try
      sSQL := 'SELECT acCustSupp, ' +
                     'acSubType ' +
              'FROM [COMPANY].CUSTSUPP ' +
              'WHERE acCode = ''' + FullCustCode(aAccountCode) + '''';

      Select(sSQL, FCompanyCode);
      if (ErrorMsg = '') And (Records.RecordCount > 0) then
      Begin
        // Found it.
        Records.First;

        custSupp := Records.FieldByName('acCustSupp').Value;
        subType  := Records.FieldByName('acSubType').Value;

        if ((UpperCase(custSupp) = 'C') or (UpperCase(custSupp) = 'S')) then
        begin
          Result := subType;
        end;
      end;
    finally
      free;
    end; // try
  end; // with TSQLCaller
end;

//------------------------------------------------------------------------------

function TContactsManagerSQL.ChangeAccountCode(
  OldCode, NewCode: string): Boolean;
begin
  //Do nothing - account code change is handled by  SQL Server
  Result := True;
end;

end.
