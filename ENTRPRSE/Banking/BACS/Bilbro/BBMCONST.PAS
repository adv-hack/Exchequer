unit bbmconst;

interface

const
  CRLF = #13#10;
  CRLF2 = CRLF + CRLF;

  AccessKeyField = 'EE_Account_Code';
  BbmIniFileName = 'bbm.ini';


  detBankName = 'Beneficiary_Bank_Name';
  detBankAdd1 = 'Beneficiary_Bank_Address1';
  detBankAdd2 = 'Beneficiary_Bank_Address2';
  detBankAdd3 = 'Beneficiary_Bank_Address3';
  detBankAcc  = 'Beneficiary_Account_Number';

  detBenName  = 'Beneficiary_Name';
  detBenAdd1  = 'Beneficiary_Address1';
  detBenAdd2  = 'Beneficiary_Address2';
  detBenAdd3  = 'Beneficiary_Address3';

  detSwiftBIC = 'SWIFT_BIC';
  detRouting  = 'Routine_Code'; //Doh!

  detCharge = 'Charging_Ins';
  detPay    = 'Payment_Ins';

implementation

end.
