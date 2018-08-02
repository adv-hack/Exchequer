unit UpgradeContactRoles;

interface

function InitialiseContacts(var ErrorStr: string): LongInt;

implementation

uses
  SysUtils,
  GlobVar,
  VarConst,
  oContactRoleBtrieveFile,
  oBtrieveFile;

function EnsureContactRoleExists(
                    oContactRoleFile: TContactRoleBtrieveFile;
                    Id: Integer;
                    Description: string;
                    AppliesToCustomer: Boolean;
                    AppliesToSupplier: Boolean;
                    var ErrorStr: string): LongInt;
var
  FuncRes: Integer;
begin
  FuncRes := oContactRoleFile.GetEqual(FullNomKey(Id));
  if (FuncRes in [0, 4, 9]) then
  begin
    if (FuncRes in [4, 9]) then
      // Contact Role not found -- prepare a new record
      oContactRoleFile.InitialiseRecord;

    // Fill in the details (for existing records this will update the details)
    with oContactRoleFile.ContactRole do
    begin
      crRoleId                := Id;
      crRoleDescription       := Description;
      crRoleAppliesToCustomer := AppliesToCustomer;
      crRoleAppliesToSupplier := AppliesToSupplier;
    end;

    if (FuncRes in [4, 9]) then
    begin
      FuncRes := oContactRoleFile.Insert;
      if (FuncRes <> 0) then
        ErrorStr := 'TContactRoleBtrieveFile.Insert: Error ' + IntToStr(FuncRes) + ' occurred adding ' + oContactRoleFile.ContactRole.crRoleDescription;
    end
    else
    begin
      FuncRes := oContactRoleFile.Update;
      if (FuncRes <> 0) then
        ErrorStr := 'TContactRoleBtrieveFile.Update: Error ' + IntToStr(FuncRes) + ' occurred updating ' + oContactRoleFile.ContactRole.crRoleDescription;
    end;
  end;
  Result := FuncRes;
end;

// -----------------------------------------------------------------------------

function InitialiseContacts(var ErrorStr: string): LongInt;
Var
  oContactRoleFile : TContactRoleBtrieveFile;
begin
  oContactRoleFile := TContactRoleBtrieveFile.Create;
  Try
    Result := oContactRoleFile.OpenFile (SetDrive + 'Cust\ContactRole.Dat', True); // Create if missing
    If (Result = 0) Then
    Begin
      {
        riGeneralContact = 1;        // General Contact     Cust + Supp
        riSendQuote = 2;             // Send Quote          Cust + Supp
        riSendOrders = 3;            // Send Order          Cust + Supp
        riSendDeliveryNotes = 4;     // Send Delivery Note  Cust + Supp
        riSendInvoices = 5;          // Send Invoice        Cust + Supp
        riSendReceipt = 6;           // Send Receipt        Cust
        riSendRemittance = 7;        // Send Remittance            Supp
        riSendStatement = 8;         // Send Statement      Cust


        Send Debt Chase 1 	Cust
        Send Debt Chase 2 	Cust
        Send Debt Chase 3	Cust
        riSendCreditNote = 13;       // Send Credit Note                 Cust + Supp       // PS - 19-10-2015 - ABSEXCH-15530
        riSendSaleReceipt = 14;      // Send Sales Receipt               Cust              // PS - 20-10-2015 - ABSEXCH-16501
        riSendPurchaseReceipt = 15;  // Send Purchase Receipt                   Supp       // PS - 20-10-2015 - ABSEXCH-16501
        riSendJournalInvoice = 16;   // Send Journal Invoice             Cust + Supp       // PS - 20-10-2015 - ABSEXCH-16500
        riSendJournalCredit = 17;    // Send Journal Credit              Cust + Supp       // PS - 20-10-2015 - ABSEXCH-16500
        riSendCreditWithRefund = 18; // Send Credit with Refund          Cust + Supp       // PS - 20-10-2015 - ABSEXCH-16502
        riSendReturn = 19;           // Send Sales Receipt               Cust + Supp       // PS - 20-10-2015 - ABSEXCH-16503
      }
      Result := EnsureContactRoleExists(oContactRoleFile, 1, 'General Contact', True, True, ErrorStr);
      if (Result <> 0) then
        Exit;

      Result := EnsureContactRoleExists(oContactRoleFile, 2, 'Send Quote', True, True, ErrorStr);
      if (Result <> 0) then
        Exit;

      Result := EnsureContactRoleExists(oContactRoleFile, 3, 'Send Order', True, True, ErrorStr);
      if (Result <> 0) then
        Exit;

      Result := EnsureContactRoleExists(oContactRoleFile, 4, 'Send Delivery Note', True, True, ErrorStr);
      if (Result <> 0) then
        Exit;

      Result := EnsureContactRoleExists(oContactRoleFile, 5, 'Send Invoice', True, True, ErrorStr);
      if (Result <> 0) then
        Exit;

      Result := EnsureContactRoleExists(oContactRoleFile, 6, 'Send Receipt', True, False, ErrorStr);
      if (Result <> 0) then
        Exit;

      Result := EnsureContactRoleExists(oContactRoleFile, 7, 'Send Remittance', False, True, ErrorStr);
      if (Result <> 0) then
        Exit;

      Result := EnsureContactRoleExists(oContactRoleFile, 8, 'Send Statement', True, False, ErrorStr);
      if (Result <> 0) then
        Exit;

      Result := EnsureContactRoleExists(oContactRoleFile, 9, 'Send Debt Chase 1', True, False, ErrorStr);
      if (Result <> 0) then
        Exit;

      Result := EnsureContactRoleExists(oContactRoleFile, 10, 'Send Debt Chase 2', True, False, ErrorStr);
      if (Result <> 0) then
        Exit;

      Result := EnsureContactRoleExists(oContactRoleFile, 11, 'Send Debt Chase 3', True, False, ErrorStr);
      if (Result <> 0) then
        Exit;

      //PR: 29/07/2014 Order Payments T012
      Result := EnsureContactRoleExists(oContactRoleFile, 12, 'Credit Card Payment', True, False, ErrorStr);
      if (Result <> 0) then
        Exit;

      // PS - 19-10-2015 - ABSEXCH-15530
      Result := EnsureContactRoleExists(oContactRoleFile, 13, 'Send Credit Note', True, True, ErrorStr);
      if (Result <> 0) then
        Exit;

      // PS - 20-10-2015 - ABSEXCH-16501
      Result := EnsureContactRoleExists(oContactRoleFile, 14, 'Send Receipt with Invoice', True, False, ErrorStr);
      if (Result <> 0) then
        Exit;

      // PS - 20-10-2015 - ABSEXCH-16501
      Result := EnsureContactRoleExists(oContactRoleFile, 15, 'Send Payment with Invoice', False, True, ErrorStr);
      if (Result <> 0) then
        Exit;

      // PS - 20-10-2015 - ABSEXCH-16500
      Result := EnsureContactRoleExists(oContactRoleFile, 16, 'Send Journal Invoice', True, True, ErrorStr);
      if (Result <> 0) then
        Exit;

      // PS - 20-10-2015 - ABSEXCH-16500
      Result := EnsureContactRoleExists(oContactRoleFile, 17, 'Send Journal Credit', True, True, ErrorStr);
      if (Result <> 0) then
        Exit;

      // PS - 20-10-2015 - ABSEXCH-16502
      Result := EnsureContactRoleExists(oContactRoleFile, 18, 'Send Credit with Refund', True, True, ErrorStr);
      if (Result <> 0) then
        Exit;

      // PS - 20-10-2015 - ABSEXCH-16503
      Result := EnsureContactRoleExists(oContactRoleFile, 19, 'Send Return', True, True, ErrorStr);
      if (Result <> 0) then
        Exit;

      oContactRoleFile.CloseFile;
    End // If (Result = 0)
    Else
      // Shouldn't ever happen
      ErrorStr := 'TContactRoleBtrieveFile.Create: Error ' + IntToStr(Result) + ' occurred opening ' + SetDrive + 'Cust\ContactRole.Dat';
  Finally
    oContactRoleFile.Free;
  End; // Try..Finally

end;

end.
