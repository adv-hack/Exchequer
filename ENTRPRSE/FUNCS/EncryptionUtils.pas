unit EncryptionUtils;
{Functions to wrap around the Blowfish component. Initially for SMTP Authorisation ABSEXCH-12837, but further specific functions
can be added if required.}
interface


function EncryptSMTPAuthPassword(const s : string) : string;
function DecryptSMTPAuthPassword(const s : string) : string;

// MH 10/05/2013 ABSEXCH-13793 v7.0.4: Added new fields for XML VAT100 Export
function EncryptVAT100UserId(const s : string) : string;
function DecryptVAT100UserId(const s : string) : string;
function EncryptVAT100Password(const s : string) : string;
function DecryptVAT100Password(const s : string) : string;

//PR: 24/07/2013 New functions for SEPA bank functions
function EncryptBankSortCode(const s : string) : string;
function DecryptBankSortCode(const s : string) : string;
function EncryptBankAccountCode(const s : string) : string;
function DecryptBankAccountCode(const s : string) : string;
function EncryptBankMandateID(const s : string) : string;
function DecryptBankMandateID(const s : string) : string;

//PR: 16/08/2013 Extra functions for SEPA User IDs
function EncryptBankUserID(const s : string) : string;
function DecryptBankUserID(const s : string) : string;

//HV: 21/08/2017 New functions for User Security Answer
function EncryptUserSecurityAnswer(const s : string) : string;
function DecryptUserSecurityAnswer(const s : string) : string;


implementation

uses
  Blowfish, SysUtils;

Const
  bEncrypt = True;
  bDecrypt = False;

  SORT_LEN = 15;
  IBAN_LEN = 35;


//Generic function to initialise Blowfish and encrypt or decrypt as string. Functions can be added which call it using different
//keystrings or CipherMode; defaults to the simplest ciphermode
function EncryptDecryptString(const Value      : string;
                              const KeyString  : string;
                                    Encrypt    : Boolean;
                              const Vector     : string = '';
                                    CipherMode : TCipherMode = ECB) : string;
var
  oBlowfish : TBlowfish;
begin
  //Passing an empty string to Blowfish causes an exception.
  if Value = '' then
  begin
    Result := '';
    EXIT;
  end;

  oBlowfish := TBlowfish.Create(nil);

  Try
    //Set mode
    oBlowfish.CipherMode := CipherMode;
    oBlowfish.StringMode := smEncode; //let component handle nulls in encrypted string

    //Initialise - **These strings must NOT be changed once the build has been released**
    oBlowfish.InitialiseString(KeyString);
    if Vector <> '' then
      oBlowfish.LoadIVString(Vector);

    //Encrypt or Decrypt
    if Encrypt then
      oBlowfish.EncString(Value, Result)
    else
      oBlowfish.DecString(Value, Result);
  Finally
    //Clear encryption object and free memory
    oBlowfish.Burn;
    FreeAndNil(oBlowfish);
  End;
end;

//Specific function to encrypt or decrypt a string for SMTP Authorisation
function EncryptDecryptSMTPAuthPassword(const s : string; Encrypt : Boolean) : string;
begin
  Result := EncryptDecryptString(s,
                                 'A;bZq=4hvNMxC042nC%775Dux1!@5B++4ace+=',
                                 Encrypt,
                                 'faiAF+J(Y$',
                                 CBC );//CBC is more secure than ECB

end;

//Encrypt
function EncryptSMTPAuthPassword(const s : string) : string;
begin
  Result := EncryptDecryptSMTPAuthPassword(s, True);
end;

//Decrypt
function DecryptSMTPAuthPassword(const s : string) : string;
begin
  Result := EncryptDecryptSMTPAuthPassword(s, False);
end;

//-------------------------------------------------------------------------

// MH 10/05/2013 ABSEXCH-13793 v7.0.4: Added new fields for XML VAT100 Export

//Specific function to encrypt or decrypt a string for SMTP Authorisation
function EncryptDecryptVAT100(const s : string; Encrypt : Boolean) : string;
begin
  Result := EncryptDecryptString(s,
                                 'P:\W1bLle=Ba1Dr1ck/Lu+-R47d$OkLe3TOjsX',
                                 Encrypt,
                                 'Tjd_u49$j1',
                                 CBC );//CBC is more secure than ECB

end;

//------------------------------

function EncryptVAT100UserId(const s : string) : string;
Begin // EncryptVAT100UserId
  Result := EncryptDecryptVAT100(S, bEncrypt);
End; // EncryptVAT100UserId
function DecryptVAT100UserId(const s : string) : string;
Begin // DecryptVAT100UserId
  Result := EncryptDecryptVAT100(S, bDecrypt);
End; // DecryptVAT100UserId

//------------------------------

function EncryptVAT100Password(const s : string) : string;
Begin // EncryptVAT100Password
  Result := EncryptDecryptVAT100(S, bEncrypt);
End; // EncryptVAT100Password
function DecryptVAT100Password(const s : string) : string;
Begin // DecryptVAT100Password
  Result := EncryptDecryptVAT100(S, bDecrypt);
End; // DecryptVAT100Password

//-------------------------------------------------------------------------

//PR: 24/07/2013 Specific function to encrypt or decrypt a string for SEPA fields
function EncryptDecryptSEPA(const s : string; Encrypt : Boolean) : string;
begin
  Result := EncryptDecryptString(s,
                                 'b;qw10Lle=Ba1D9472/Lk+-R47d$O*Le3T+j-X',
                                 Encrypt,
                                 'P0d_u7d$j6',
                                 CBC );//CBC is more secure than ECB

end;


//PR: 24/07/2013 New functions for SEPA bank functions
function EncryptBankSortCode(const s : string) : string;
begin
  Result := EncryptDecryptSEPA(Copy(s, 1, SORT_LEN), True);
end;

function DecryptBankSortCode(const s : string) : string;
begin
  Result := EncryptDecryptSEPA(s, False);
end;

function EncryptBankAccountCode(const s : string) : string;
begin
  Result := EncryptDecryptSEPA(Copy(s, 1, IBAN_LEN), True);
end;

function DecryptBankAccountCode(const s : string) : string;
begin
  Result := EncryptDecryptSEPA(s, False);
end;

function EncryptBankMandateID(const s : string) : string;
begin
  Result := EncryptDecryptSEPA(Copy(s, 1, IBAN_LEN), True);
end;

function DecryptBankMandateID(const s : string) : string;
begin
  Result := EncryptDecryptSEPA(s, False);
end;

function EncryptBankUserID(const s : string) : string;
begin
  Result := EncryptDecryptSEPA(Copy(s, 1, IBAN_LEN), True);
end;

function DecryptBankUserID(const s : string) : string;
begin
  Result := EncryptDecryptSEPA(s, False);
end;

//HV: 21/08/2017 Specific function to encrypt or decrypt a string for User Security Answer
function EncryptDecryptSecurityAnswer(const s : string; Encrypt : Boolean) : string;
begin
  Result := EncryptDecryptString(s,
                                 'C;qw143l=Ba1D72/ik+-R47dAr$Oth*L3T+-HV',
                                 Encrypt,
                                 'D0a_v7d$&6',
                                 CBC );
end;

function EncryptUserSecurityAnswer(const s : string) : string;
begin
  Result := EncryptDecryptSecurityAnswer(s, True);
end;

function DecryptUserSecurityAnswer(const s : string) : string;
begin
  Result := EncryptDecryptSecurityAnswer(s, False);
end;




end.
