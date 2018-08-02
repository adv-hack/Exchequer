unit crypto;

interface

uses
  Windows;

const
  CRYPT_KEY_CONTAINER = 'IRIS_EMULATOR_KEY_CONTAINER';

  
procedure CryptText(var aBuffer : array of Byte;
                        Password: string;
                        ToCrypt: Boolean);

implementation

uses
  WCrypt2;

procedure CryptText(var aBuffer : array of Byte;
                        Password: string;
                        ToCrypt: Boolean);
var
  hProv  : HCRYPTPROV;
  hash   : HCRYPTHASH;
  key    : HCRYPTKEY;

  pBuffer : PByte;
  len    : DWORD;
  dwFlags : DWORD;
  dwKeyLength : DWORD;
begin
  {get context for crypt default provider}
  if not CryptAcquireContext(@hProv, PChar(CRYPT_KEY_CONTAINER), nil, PROV_RSA_FULL, 0) then  //      ; // CRYPT_VERIFYCONTEXT);
    begin
      if not (CryptAcquireContext(@hProv, PChar(CRYPT_KEY_CONTAINER), nil, PROV_RSA_FULL, CRYPT_NEWKEYSET))	then
      begin
      end;
    end;

  {create hash-object (MD5 algorithm)}
  CryptCreateHash(hProv, CALG_MD5, 0, 0, @hash);

  {get hash from password}
  CryptHashData(hash, @Password[1], Length(Password), 0);

  {create key from hash by RC4 algorithm}
  dwKeyLength := 128;
  dwFlags := CRYPT_EXPORTABLE or (dwKeyLength * $10000);
  CryptDeriveKey(hProv, CALG_RC4, hash, dwFlags, @key);

  {destroy hash-object}
  CryptDestroyHash(hash);

  try
    len := Length(aBuffer);

    pBuffer := @aBuffer;

    if ToCrypt then
      {crypt buffer}
      CryptEncrypt(key, 0, true, 0, pBuffer, @len, len)
    else
      {decrypt buffer}
      CryptDecrypt(key, 0, true, 0, pBuffer, @len);
  finally
  end;

  {release the context for crypt default provider}
  CryptReleaseContext(hProv, 0);
end;

end.
