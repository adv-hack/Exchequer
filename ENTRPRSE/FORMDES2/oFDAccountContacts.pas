unit oFDAccountContacts;

Interface

Uses Classes, SysUtils, GlobVar, VarConst, oAccountContactBtrieveFile;

Type
  // Generic interface for objects which implement a specific import type
  IFDAccountContacts = Interface
    ['{D7DEDB12-04E4-40A9-94D2-A70045D28E8C}']
    // --- Internal Methods to implement Public Properties ---
    Function GetAccountContact : AccountContactRecType;

    // ------------------ Public Properties ------------------
    Property AccountContact : AccountContactRecType Read GetAccountContact;

    // ------------------- Public Methods --------------------
    Procedure FindAccountRoleByDescription(Const AccountCode, RoleDescription : ShortString);
  End; // IFDAccountContacts

  //------------------------------

// Returns a reference to the Form Designer's internal Account Contacts object
Function FDAccountContacts : IFDAccountContacts;

// Called from sbsForm_DeInitialise when the DLL is being unloaded or Exchequer is changing companies
Procedure FDAccountContacts_CloseDown;

Implementation

Uses AccountContactRoleUtil, ContactsManager, BtrvU2, SavePos, BTKeys1U;

Type
  TFDAccountContacts = Class(TInterfacedObject, IFDAccountContacts)
  Private
    // reference to ContactsManager object
    FContactsManager : TContactsManager;
    FAccountContact : AccountContactRecType;

    // Initialises the Account Contact details from the defaults in the Account record
    Procedure InitAccountContactFromAccount (Const Account : CustRec);

    // IFDAccountContacts
    Function GetAccountContact : AccountContactRecType;

    Procedure FindAccountRoleByDescription(Const AccountCode, RoleDescription : ShortString);
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TFDAccountContacts

Var
  LFDAccountContacts : IFDAccountContacts;

//=========================================================================

// Returns a reference to the Form Designer's internal Account Contacts object
Function FDAccountContacts : IFDAccountContacts;
Begin // FDAccountContacts
  If (Not Assigned(LFDAccountContacts)) Then
    LFDAccountContacts := TFDAccountContacts.Create;
  Result := LFDAccountContacts;
End; // FDAccountContacts

//------------------------------

// Called from sbsForm_DeInitialise when the DLL is being unloaded or Exchequer is changing companies
Procedure FDAccountContacts_CloseDown;
Begin // FDAccountContacts_CloseDown
  LFDAccountContacts := NIL
End; // FDAccountContacts_CloseDown

//=========================================================================

Constructor TFDAccountContacts.Create;
Begin // Create
  Inherited Create;

  // Create the ContactsManager object if not already in existence - this will then
  // be cached for this instance of the print form
  FContactsManager := NewContactsManager;

  // Initialise the internal records to safe values
  FillChar (FAccountContact, SizeOf(FAccountContact), #0);
End; // Create

//------------------------------

Destructor TFDAccountContacts.Destroy;
Begin // Destroy
  FreeAndNIL(FContactsManager);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TFDAccountContacts.FindAccountRoleByDescription(Const AccountCode, RoleDescription : ShortString);
Var
  oContact : TAccountContact;
  sKey : Str255;
  iStatus, RoleId, I : Integer;
  GotAccount : Boolean;
Begin // FindAccountRoleByDescription
  // Blank out any previous Account Contact details just in case the Account Code or Role Description
  // are invalid and no details can be found
  FillChar (FAccountContact, SizeOf(FAccountContact), #0);

  // Lookup the Role Description to identify its Role Id
  RoleId := FContactsManager.GetRoleIdByDescription(RoleDescription);
  If (RoleId > 0) Then
  Begin
    // Flag indicates whether a customer/supplier has been successfully found for the specified
    // Account Code
    GotAccount := False;

    // Check to see if account is already loaded in global Cust record
    If (UpperCase(Trim(AccountCode)) = UpperCase(Trim(Cust.CustCode))) Then
    Begin
      // Result! Already loaded - copy details across
      InitAccountContactFromAccount (Cust);
      GotAccount := True;
    End // If (UpperCase(Trim(AccountCode)) = UpperCase(Trim(Cust.CustCode)))
    Else
    Begin
      // Load in from DB - save and restore the position/record otherwise it will screw up the form
      With TBtrieveSavePosition.Create Do
      Begin
        Try
          // Save the current position in the file for the current key
          SaveFilePosition (CustF, GetPosKey);
          SaveDataBlock (@Cust, SizeOf(Cust));

          // Load the specified Account
          sKey := FullCustCode(sAcCode);
          iStatus := Find_Rec (B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, sKey);
          If (iStatus = 0) Then
          Begin
            // Success - copy details across
            InitAccountContactFromAccount (Cust);
            GotAccount := True;
          End; // If (iStatus = 0)
        Finally
          // Restore position in file
          RestoreDataBlock (@Cust);
          RestoreSavedPosition;
          Free;
        End; // Try..Finally
      End; // With TBtrieveSavePosition.Create
    End; // Else

    If GotAccount Then
    Begin
      // Load the Account's Contacts and assigned Role's
      FContactsManager.SetCustomerRecord(FAccountContact.acoAccountCode);

      // Look for the Account Contact record for the Role, returns NIL if not found
      oContact := FContactsManager.GetContactByRole(RoleId);
      // If not found then look for a General Contacts role to duplicate Exchequer behaviour
      If (Not Assigned(oContact)) Then
        oContact := FContactsManager.GetContactByRole(riGeneralContact);
      If Assigned(oContact) Then
      Begin
        // Copy the Account Contact details in overwriting the defaults from the Account
        FAccountContact.acoContactId             := oContact.contactDetails.acoContactId;
        //FAccountContact.acoAccountCode         :=
        FAccountContact.acoContactName           := oContact.contactDetails.acoContactName;
        FAccountContact.acoContactJobTitle       := oContact.contactDetails.acoContactJobTitle;
        FAccountContact.acoContactPhoneNumber    := oContact.contactDetails.acoContactPhoneNumber;
        FAccountContact.acoContactFaxNumber      := oContact.contactDetails.acoContactFaxNumber;
        FAccountContact.acoContactEmailAddress   := oContact.contactDetails.acoContactEmailAddress;

        // Bug: Has Own Address was always false
        FAccountContact.acoContactHasOwnAddress := oContact.contactDetails.acoContactHasOwnAddress;
        If oContact.contactDetails.acoContactHasOwnAddress Then
        Begin
          For I := Low(FAccountContact.acoContactAddress) To High(FAccountContact.acoContactAddress) Do
            FAccountContact.acoContactAddress[I] := oContact.contactDetails.acoContactAddress[I];
          FAccountContact.acoContactPostCode     := oContact.contactDetails.acoContactPostCode;

          // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Codes
          FAccountContact.acoContactCountry      := oContact.contactDetails.acoContactCountry;
        End; // If oContact.contactDetails.acoContactHasOwnAddress
      End; // If Assigned(oContact)
    End; // If GotAccount
  End; // If (RoleId > 0)
End; // FindAccountRoleByDescription

//------------------------------

// Initialises the Account Contact details from the defaults in the Account record
Procedure TFDAccountContacts.InitAccountContactFromAccount (Const Account : CustRec);
Var
  I : Integer;
Begin // InitAccountContactFromAccount
  FillChar (FAccountContact, SizeOf(FAccountContact), #0);
  FAccountContact.acoContactId            := -1;
  FAccountContact.acoAccountCode          := Account.CustCode;
  FAccountContact.acoContactName          := Account.Contact;
  FAccountContact.acoContactJobTitle      := '';
  FAccountContact.acoContactPhoneNumber   := Account.Phone;
  FAccountContact.acoContactFaxNumber     := Account.Fax;
  FAccountContact.acoContactEmailAddress  := Account.EmailAddr;
  FAccountContact.acoContactHasOwnAddress := False;
  For I := Low(FAccountContact.acoContactAddress) To High(FAccountContact.acoContactAddress) Do
    FAccountContact.acoContactAddress[I]  := Account.Addr[I];
  FAccountContact.acoContactPostCode      := Account.PostCode;

  // MH 26/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Codes
  FAccountContact.acoContactCountry      := Account.acCountry;
End; // InitAccountContactFromAccount

//-------------------------------------------------------------------------

Function TFDAccountContacts.GetAccountContact : AccountContactRecType;
Begin // GetAccountContact
  Result := FAccountContact;
End; // GetAccountContact

//-------------------------------------------------------------------------

Initialization
  LFDAccountContacts := NIL;
Finalization
  FDAccountContacts_CloseDown;
End.
