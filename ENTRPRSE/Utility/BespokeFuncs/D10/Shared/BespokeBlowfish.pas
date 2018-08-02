unit BespokeBlowfish;

interface
uses
  Blowfish;

const
  BLOWFISH_ERROR = 'BLOWFISH_ERROR';

  function BlowFishDecrypt(const Encrypted: string): string;
  function BlowFishEncrypt(const Plain: string): string;

implementation

const
  // Random strings for encoding/decoding
  sIV = 'DSa3ea'+'39lk£`¬j'+'1!kekw3'+'1223s';
  sInitialise = '8"sf'+'3w$%71~d'+'Sas'+'@sa';

function BlowFishDecrypt(const Encrypted: string): string;
// Return the Encrypted string decrypted
// The blowfish initialisation strings match those in BlowFishEncrypt
var
  BlowFish: TBlowFish;
  Decrypted: string;
begin
  BlowFish := TBlowFish.Create(nil);
  try
    try
      BlowFish.CipherMode := ECB;
      BlowFish.StringMode := smEncode; // prevent null characters mid-string
      BlowFish.LoadIVString(sIV);
      BlowFish.InitialiseString(sInitialise);
      BlowFish.DecString(Encrypted, Decrypted);
      result := Decrypted;
      BlowFish.Burn;
    except
      Result := BLOWFISH_ERROR;
    end;{try}
  finally
    BlowFish.free;
  end;{try}
end;


function BlowFishEncrypt(const Plain: string): string;
// return the unencrypted string encrypted
// The blowfish initialisation strings are arbitrary
var
  BlowFish: TBlowFish;
  Encrypted: string;
begin
  BlowFish := TBlowFish.Create(nil);
  try
    try
      BlowFish.CipherMode := ECB;
      BlowFish.StringMode := smEncode; // prevent null characters mid-string
      BlowFish.LoadIVString(sIV);
      BlowFish.InitialiseString(sInitialise);
      BlowFish.EncString(Plain, Encrypted);
      result := Encrypted;
      BlowFish.Burn;
    except
      Result := BLOWFISH_ERROR;
    end;{try}
  finally
    BlowFish.free;
  end;{try}
end;


end.
