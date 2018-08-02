unit Common;

interface

uses Blowfish, windows, messages, sysutils;

function Decrypt(const Encrypted: string): string;
function Encrypt(const Plain: string): string;
procedure EncryptionOn;
function EnterToTab(Key: char; handle: HWND): char;
function ExeFileName: string;
function IniFileName: string;

const
  APPVERSION = 'build 016';

implementation

var
  FEncryptionOn: boolean;

function BlowFishDecrypt(const Encrypted: string): string;
// Return the Encrypted string decrypted
// The blowfish initialisation strings match those in BlowFishEncrypt
// DO NOT CHANGE THE INITIALISATION STRINGS !
var
  BlowFish: TBlowFish;
  Decrypted: string;
begin
  if length(Encrypted) = 0 then
    result := ''
  else begin
    BlowFish := TBlowFish.Create(nil);
    try
      BlowFish.CipherMode := ECB;
      BlowFish.StringMode := smEncode;
      BlowFish.LoadIVString('F2ABC392');
      BlowFish.InitialiseString('8F3319');
      BlowFish.DecString(Encrypted, Decrypted);
      result := Decrypted;
      BlowFish.Burn;
    finally
      BlowFish.free;
    end;
  end;
end;

function Decrypt(const Encrypted: string): string;
begin
  if FEncryptionOn then
    result := BlowFishDecrypt(Encrypted)
  else
    result := Encrypted;
end;

function BlowFishEncrypt(const Plain: string): string;
// return the unencrypted string encrypted
// The blowfish initialisation strings match those in BlowFishDecrypt
// DO NOT CHANGE THE INITIALISATION STRINGS !
var
  BlowFish: TBlowFish;
  Encrypted: string;
begin
  if length(Plain) = 0 then
    result := ''
  else begin
    BlowFish := TBlowFish.Create(nil);
    try
      BlowFish.CipherMode := ECB;
      BlowFish.StringMode := smEncode;
      BlowFish.LoadIVString('F2ABC392');
      BlowFish.InitialiseString('8F3319');
      BlowFish.EncString(Plain, Encrypted);
      result := Encrypted;
      BlowFish.Burn;
    finally
      BlowFish.free;
    end;
  end;
end;

function Encrypt(const Plain: string): string;
begin
  if FEncryptionOn then
    result := BlowFishEncrypt(Plain)
  else
    result := Plain;
end;

procedure EncryptionOn;
begin
  FEncryptionOn := true;
end;

function  EnterToTab(Key: char; handle: HWND): char;
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    result := #0;
  end
  else
    result := Key;
end;

function ExeFileName: string;
begin
  result := lowercase(ParamStr(0));
end;

function IniFileName: string;
begin
  result := ChangeFileExt(ParamStr(0), '.ini');
end;

end.
