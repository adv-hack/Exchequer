unit PIIFieldNumbers;

interface

type
  TPIIFieldNo = (PIIAccount,
                PIICustomer,
                PIIConsumer,
                PIISupplier,
                PIIAcContact,
                PIIAddress,
                PIIEmail,
                PIIPhone1,
                PIIPhone2,
                PIIFax,
                PIIDeliveryAddress,
                PIIUDF1,
                PIIUDF2,
                PIIUDF3,
                PIIUDF4,
                PIIUDF5,
                PIIUDF6,
                PIIUDF7,
                PIIUDF8,
                PIIUDF9,
                PIIUDF10,
                PIIUDF11,
                PIIUDF12,
                PIIUDF13,
                PIIUDF14,
                PIIUDF15,

                PIIBankAC,
                PIIBankSort,
                PIIBankRef,
                PIIBankMandate,
                PIIBankMandateDate,
                PIITheirAccount,
                PIIVATRegNo,
                PIIWebPassword,

                PIIAccountContacts,
                PIIAccountContact,
                PIIAccountContactName,
                PIIAcContactJobTitle,
                PIIAcContactPhone,
                PIIAcContactFax,
                PIIAcContactEmail,
                PIIAcContactAddress,

                PIIPluginContacts,
                PIIPlugInContact,
                PIIPlugInContactName,
                PIIPlugInContactPhone,
                PIIPlugInContactFax,
                PIIPlugInContactEmail,
                PIIPlugInContactAddress,
                PIIPlugInContactJob,
                PIIPlugInContactSalutation,

                PIINote,
                PIILink,
                PIILinkHeader,
                PIILetter,
                PIILetterHeader,


                PIITransactions,
                PIITransaction,
                PIITransactionLines,
                PIITransactionLine,
                PIITransactionReference,
                PIIPayDetails,

                PIIEmployees,
                PIIEmployee,
                PIIEmployeeName,
                PIIEmpNINumber,
                PIIEmpUTR,
                PIIEmpCRN,
                PIIVerifyNo,
                PIIEmpSupplier,
                PIIEmpPayrollNo,
                PIIEmpCISVoucher,
                PIIEmpCISVouchers,
                PIICISVoucherNo,

                piiJobs,
                PIIJob,
                PIIJobDescription,
                PIIJobContact,
                PIIJobManager,

                PIIEbusTransactions,
                PIIEbusTransaction
                );

  function FieldText(const FieldNo : TPIIFieldNo) : string;
  function XMLText(const FieldNo : TPIIFieldNo) : string;
  function XMLAttributeType(const FieldNo : TPIIFieldNo) : string;
  function XMLInclude(FieldNo : TPIIFieldNo) : Boolean;
  function IncludeInTree(FieldNo : TPIIFieldNo) : Boolean;


implementation

uses
  SysUtils;

function FieldText(const FieldNo : TPIIFieldNo) : string;
begin
  Case FieldNo of

      PIIAccount : Result := '';
      PIIAcContact : Result := 'Contact';
      PIIAddress : Result := 'Address';
      PIIEmail : Result := 'Email';
      PIIPhone1 : Result := 'Telephone';
      PIIPhone2 : Result := 'Mobile';
      PIIFax : Result :=  'Fax';
      PIIDeliveryAddress : Result := 'Delivery Address';

      PIIBankAC  : Result := 'Bank Account/IBAN';
      PIIBankSort : Result := 'Bank Sort Code/BIC';
      PIIBankRef : Result := 'Bank Ref';
      PIIBankMandate : Result := 'Bank DD Mandate';
      PIIBankMandateDate : Result := 'Bank DD Mandate Date';
      PIITheirAccount : Result := 'Their A/C for us';
      PIIVATRegNo : Result := 'Vat Reg No.';
      PIIWebPassword : Result := 'Web Password';


      PIIUDF1 : Result := 'UDF Field 1';
      PIIUDF2 : Result := 'UDF Field 2';
      PIIUDF3 : Result := 'UDF Field 3';
      PIIUDF4 : Result := 'UDF Field 4';
      PIIUDF5 : Result := 'UDF Field 5';
      PIIUDF6 : Result := 'UDF Field 6';
      PIIUDF7 : Result := 'UDF Field 7';
      PIIUDF8 : Result := 'UDF Field 8';
      PIIUDF9 : Result := 'UDF Field 9';
      PIIUDF10 : Result := 'UDF Field 10';
      PIIUDF11 : Result := 'UDF Field 11';
      PIIUDF12 : Result := 'UDF Field 12';
      PIIUDF13 : Result := 'UDF Field 13';
      PIIUDF14 : Result := 'UDF Field 14';
      PIIUDF15 : Result := 'UDF Field 15';

      PIINote : Result := '';
      PIILink : Result := '';
      PIILetter : Result := '';

      PIIAccountContact : Result := 'Role';
      PIIAccountContactName : Result := 'Name';
      PIIAcContactJobTitle : Result := 'Job Title';
      PIIAcContactPhone : Result := 'Phone';
      PIIAcContactFax : Result := 'Fax';
      PIIAcContactEmail : Result := 'Email';
      PIIAcContactAddress : Result := 'Address';

      PIIPlugInContact : Result := 'Contact';
      PIIPlugInContactName : Result := 'Name';
      PIIPlugInContactPhone : Result := 'Phone';
      PIIPlugInContactFax : Result := 'Fax';
      PIIPlugInContactEmail : Result := 'Email';
      PIIPlugInContactAddress : Result := 'Address';
      PIIPlugInContactJob : Result := 'Job Title';
      PIIPlugInContactSalutation : Result := 'Salutation';

      PIITransaction : Result := '';
      PIIPayDetails : Result := 'Pay Details';

      PIIEmployee : Result := 'Employee';
      PIIEmployeeName : Result := 'Name';
      PIIEmpNINumber : Result :=  'NI Number';
      PIIEmpUTR : Result := 'UTR';
      PIIEmpCRN : Result := 'CRN';
      PIIVerifyNo : Result := 'Verification No.';
      PIIEmpPayrollNo : Result := 'Payroll Number';
      PIIEmpSupplier : Result := 'Supplier';
      PIIEmpCISVoucher : Result := '';
      PIIEmpCISVouchers : Result := '';
      PIICISVoucherNo : Result := 'Reference';

      PIIJob : Result := '';
      PIIJobDescription : Result := 'Description';
      PIIJobContact : Result := 'Contact';
      PIIJobManager : Result := 'Manager';
//      PIIHeader : Result := '';
      else
        Result := '';
  end; //case

  if Trim(Result) <> '' then
    Result := Trim(Result) + ': ';
end;

function XMLText(const FieldNo : TPIIFieldNo) : string;
begin
  Case FieldNo of

      PIIAccount : Result := '';
      PIIAcContact : Result := 'Contact';
      PIIAddress : Result := 'Address';
      PIIEmail : Result := 'Email';
      PIIPhone1 : Result := 'Telephone';
      PIIPhone2 : Result := 'Mobile';
      PIIFax : Result :=  'Fax';
      PIIDeliveryAddress : Result := 'DeliveryAddress';

      PIIBankAC  : Result := 'BankAccountOrIBAN';
      PIIBankSort : Result := 'BankSortCodeOrBIC';
      PIIBankRef : Result := 'BankRef';
      PIIBankMandate : Result := 'BankDDMandate';
      PIIBankMandateDate : Result := 'BankDDMandateDate';
      PIITheirAccount : Result := 'TheirAccountForUs';
      PIIVATRegNo : Result := 'VatRegNo';
      PIIWebPassword : Result := 'WebPassword';


      PIIUDF1,
      PIIUDF2,
      PIIUDF3,
      PIIUDF4,
      PIIUDF5,
      PIIUDF6,
      PIIUDF7,
      PIIUDF8,
      PIIUDF9,
      PIIUDF10,
      PIIUDF11,
      PIIUDF12,
      PIIUDF13,
      PIIUDF14,
      PIIUDF15 : Result := 'UserDefinedField';

      PIINote : Result := 'Note';
      PIILinkHeader : Result := 'Links';
      PIILink : Result := 'Link';
      PIILetter : Result := 'Letter';
      PIILetterHeader : Result := 'Letters';

      PIIAccountContacts : Result := 'TraderRoles';
      PIIAccountContact : Result := 'Role';
      PIIAccountContactName : Result := 'Name';
      PIIAcContactJobTitle : Result := 'JobTitle';
      PIIAcContactPhone : Result := 'Phone';
      PIIAcContactFax : Result := 'Fax';
      PIIAcContactEmail : Result := 'Email';
      PIIAcContactAddress : Result := 'Address';

      PIIPlugInContacts : Result := 'TraderContacts';
      PIIPlugInContact : Result := 'Contact';
      PIIPlugInContactName : Result := 'Name';
      PIIPlugInContactPhone : Result := 'Phone';
      PIIPlugInContactFax : Result := 'Fax';
      PIIPlugInContactEmail : Result := 'Email';
      PIIPlugInContactAddress : Result := 'Address';
      PIIPlugInContactJob : Result := 'Job Title';
      PIIPlugInContactSalutation : Result := 'Salutation';

      PIITransaction : Result := 'Transaction';
      PIITransactions : Result := 'Transactions';
      PIIEbusTransactions : Result := 'eBusinessTransactions';
      PIIEbusTransaction : Result := 'Transaction';
      PIITransactionLines : Result := 'Lines';
      PIITransactionLine : Result := 'Line';
      PIITransactionReference : Result := 'Reference';
      PIIPayDetails : Result := 'PayDetails';

      PIIEmployees : Result := 'Employees';
      PIIEmployee : Result := 'Employee';
      PIIEmployeeName : Result := 'Name';
      PIIEmpNINumber : Result :=  'NationalInsuranceNumber';
      PIIEmpUTR : Result := 'UTR';
      PIIEmpCRN : Result := 'CRN';
      PIIVerifyNo : Result := 'VerificationNumber';
      PIIEmpSupplier : Result := 'Supplier';
      PIIEmpPayrollNo : Result := 'PayrollNumber';
      PIIEmpCISVoucher : Result := 'CISVoucher';
      PIIEmpCISVouchers : Result := 'CISVouchers';

      PIIJobs : Result := 'Jobs';
      PIIJob : Result := 'Job';
      PIIJobDescription : Result := 'Description';
      PIIJobContact : Result := 'Contact';
      PIIJobManager : Result := 'Manager';
//      PIIHeader : Result := '';
      else
        Result := '';
  end; //case

end;

function XMLAttributeType(const FieldNo : TPIIFieldNo) : string;
begin
  Case FieldNo of
    PIIUDF1..PIIUDF12
               : Result := 'Description';
    PIIEmpCISVoucher
               : Result := 'Reference';
    PIITransactionLine
               : Result := 'Number';
    PIIJob     : Result := 'Code';

    else
      Result := 'Type';
  end;

end;

function XMLInclude(FieldNo : TPIIFieldNo) : Boolean;
begin
  if FieldNo in [PIICISVoucherNo] then
    Result := False
  else
    Result := True;
end;

function IncludeInTree(FieldNo : TPIIFieldNo) : Boolean;
begin
  if FieldNo in [PIITransactionReference, PIIEmployeeName] then
    Result := False
  else
    Result := True;
end;


end.
