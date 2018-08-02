Unit AccountContactRoleUtil;

Interface

Uses Dialogs, SysUtils;

Const
                                          // Text Description               | Applies To
                                          // -------------------------------+-------------------
  riGeneralContact = 1;                   // General Contact                  Cust + Supp
  riSendQuote = 2;                        // Send Quote                       Cust + Supp
  riSendOrders = 3;                       // Send Order                       Cust + Supp
  riSendDeliveryNotes = 4;                // Send Delivery Note               Cust + Supp
  riSendInvoices = 5;                     // Send Invoice                     Cust + Supp
  riSendReceipt = 6;                      // Send Receipt                     Cust
  riSendRemittance = 7;                   // Send Remittance                         Supp
  riSendStatement = 8;                    // Send Statement                   Cust
  riDebtChaseLetter1 = 9;                 // Send Debt Chase 1                Cust
  riDebtChaseLetter2 = 10;                // Send Debt Chase 2                Cust
  riDebtChaseLetter3 = 11;                // Send Debt Chase 3                Cust
  riCreditCardPayment = 12;               // Credit Card Payment              Cust
  riSendCreditNote = 13;                  // Send Credit Note                 Cust + Supp       // PS - 19-10-2015 - ABSEXCH-15530
  riSendSaleReceiptWithInvoice = 14;      // Send Receipt with Invoice        Cust              // PS - 20-10-2015 - ABSEXCH-16501
  riSendPurchasePaymentWithInvoice = 15;  // Send Payment with Invoice               Supp       // PS - 20-10-2015 - ABSEXCH-16501
  riSendJournalInvoice = 16;              // Send Journal Invoice             Cust + Supp       // PS - 20-10-2015 - ABSEXCH-16500
  riSendJournalCredit = 17;               // Send Journal Credit              Cust + Supp       // PS - 20-10-2015 - ABSEXCH-16500
  riSendCreditWithRefund = 18;            // Send Credit with Refund          Cust + Supp       // PS - 20-10-2015 - ABSEXCH-16502
  riSendReturn = 19;                      // Send Sales Receipt               Cust + Supp       // PS - 20-10-2015 - ABSEXCH-16503

// Looks for an Account Contact for the specified RoleId, if found it returns various details
// from the Account Contact.
//
// Returns TRUE if an Account Contact Role was found, FALSE if no Account Contact Role exists
//
// PKR. 31/01/2014. ABSEXCH-14999.
// Changed ContactEmailAddr type to AnsiString to allow multiple emails.
Function FindAccountContactRole (Const AccountCode      : ShortString;
                                 Const RoleId           : Integer;
                                 Var   ContactName      : ShortString;
                                 Var   ContactFaxNumber : ShortString;
                                 Var   ContactEmailAddr : AnsiString) : Boolean;

//PR: 12/02/2014 Added function to check for roles available according to Enterprise licence
//Returns true if a RoleId indicates a valid role for the current Exchequer version (SPOP/non-SPOP)
function IsValidRoleId(RoleId : Integer) : Boolean;

Implementation

uses
  SQLUtils,
  ContactsManager,
  ContactsManagerSQL,
  ContactsManagerPerv,
  EntLicence,
  // MH 06/01/2015 v7.1 ABSEXCH-15969: Suppress Credit Card role in non-UK systems
  GlobVar;

// MH 06/01/2015 v7.1 ABSEXCH-15969: Suppress Credit Card role in non-UK systems
{$I ExchequerCountryCodes.inc}

//PR: 12/02/2014 Added function to check for roles available according to Enterprise licence
//Returns true if a RoleId indicates a valid role for the current Exchequer version (SPOP/non-SPOP)
function IsValidRoleId(RoleId : Integer) : Boolean;
begin
  Result := not (RoleId in [riSendOrders, riSendDeliveryNotes]) or (EnterpriseLicence.elModuleVersion = mvSPOP);

  // MH 06/01/2015 v7.1 ABSEXCH-15969: Suppress Credit Card role in non-UK systems
  If Result Then
    Result := (RoleId <> riCreditCardPayment) Or (CurrentCountry = UKCCode);
  // PS - 20-10-2015 - ABSEXCH-16503
  If Result Then
    Result := not  ((EnterpriseLicence.elModules[modGoodsRet] = mrNone) and (RoleId = riSendReturn));

end;

//=========================================================================

// Looks for an Account Contact for the specified RoleId, if found it returns various details
// from the Account Contact.
//
// Returns TRUE if an Account Contact Role was found, FALSE if no Account Contact Role exists
//
Function FindAccountContactRole (Const AccountCode      : ShortString;
                                 Const RoleId           : Integer;
                                 Var   ContactName      : ShortString;
                                 Var   ContactFaxNumber : ShortString;
                                 Var   ContactEmailAddr : AnsiString) : Boolean;
var
  contactManager : TContactsManager;
  contact        : TAccountContact;
Begin // FindAccountContactRole
  // PKR. 22/01/2014. Use factory method.
  contactManager := NewContactsManager;

  contactManager.SetCustomerRecord(AccountCode);

  // PKR. 28/01/2014. As we can have multiple contacts for each role, we now
  //  get a semi-colon-separated list of email addresses for the specified role
  //  from the Contacts Manager.
  contactEmailAddr := Trim(contactManager.GetContactEmailsByRole(RoleId));

  // Additionally, we get the fax number from the first contact for the specified
  //  role that has a fax number (if there is one).
  contact := contactManager.GetFaxContactForRole(RoleId);

  // There might not be a contact for this role with a fax number, in which case
  //  it will be nil.
  if (contact <> nil) then
  begin
    ContactName      := contact.contactDetails.acoContactName;
    ContactFaxNumber := Trim(contact.contactDetails.acoContactFaxNumber);
    // PKR. 28/01/2014. Email address(es) now obtained separately.
  end;

  contactManager.Free;

  Result := (contactEmailAddr <> '') or (ContactName <> '') or (ContactFaxNumber <> '')
End; // FindAccountContactRole

//=========================================================================

End.
