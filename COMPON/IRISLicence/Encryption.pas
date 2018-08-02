unit Encryption;

interface
  uses Blowfish, classes, SysUtils;

function  DecryptFile(AFileName: pchar; ToStream: boolean; PlainKey: char = '['): TMemoryStream;
procedure EncryptFile(AFileName: pchar; FromStream: boolean = false; InStream: TMemoryStream = nil; PlainKey: char = '[');

implementation

function DecryptFile(AFileName: pchar; ToStream: boolean; PlainKey: char = '['): TMemoryStream;
// 1. Reads the encrypted file into the input stream,
// 2. decrypts the input stream to the output stream,
// 3. Writes the decrypted output stream back to the ini file.
// The ini file should always start with a section.
// Knowing this, we can check for a valid decryption before overwriting the file.
// Also, if Importer crashes, e.g. with a BTrieve conflict, it can leave the settings
// file in the wrong state. The integrity checks ensure that the file doesn't become
// corrupted by decrypting an already decrypted file.
// If the caller wants access to the decrypted stream we pass it back as the result
// and its up to the caller to free it. We don't save the decrypted contents to disk.
// DO NOT CHANGE THE INITIALISE STRING !
var
  BlowFish: TBlowFish;
  MSI, MSO: TMemoryStream;
  StreamKey: char;
begin
  result := nil;
  if not FileExists(AFileName) then exit;
try
  BlowFish := TBlowFish.Create(nil);
  try
    BlowFish.CipherMode := ECB;
    BlowFish.InitialiseString('050242617A7A612021030604'); // a  seemingly random sequence of ascii Hex codes

    MSI := TMemoryStream.Create;
    MSO := TMemoryStream.Create;
    try
      MSI.LoadFromFile(AFileName); // load the file into the stream
      MSI.Seek(0, soFromBeginning);   // ReadBuffer operates from the current position so back up
      MSI.ReadBuffer(StreamKey, 1);  // read the first few characters
      MSI.Seek(0, soFromBeginning);   // Back up again
      result := MSI;  // set the result to the input stream in case it's not encrypted and ToStream=True
//      if StreamKey = PlainKey then exit; // file isn't encrypted

      BlowFish.DecStream(MSI, MSO);   // decrypt input stream to output stream
      MSO.Seek(0, soFromBeginning);   // go to start of output stream
      MSO.ReadBuffer(StreamKey, 1);  // read the first few characters
//      if StreamKey <> PlainKey then // Check that it decrypted ok before overwriting file
//        raise exception.Create('Cannot read ' + AFileName);
      MSO.Seek(0, soFromBeginning);   // go to start of output stream for caller to use
      result := MSO;
      if not ToStream then
        MSO.SaveToFile(AFileName);   // save the decrypted file back to disk ready for read or write
                                        // but only now we know the contents are valid
    finally
      if (result = MSO) or not ToStream then
        MSI.Free;                       // caller won't be using this so needs to be freed here
      if (result = MSI) or not ToStream then
        MSO.Free;                       // caller won't be using this so needs to be freed here
    end;

    BlowFish.Burn;
  finally
    BlowFish.Free;
  end;
except on e:exception do
  raise;
end;
end;

procedure EncryptFile(AFileName: pchar; FromStream: boolean = false; InStream: TMemoryStream = nil; PlainKey: char = '[');
// 1. Reads the plain ini file into the input stream,
// 2. Encrypts the input stream to the output stream,
// 3. Writes the encrypted output stream back to the ini file.
// The ini file should always start with a section.
// Knowing this, we can check for a valid encryption before overwriting the file.
// Also, if Importer crashes, e.g. with a BTrieve conflict, it can leave the settings
// file in the wrong state. The integrity checks ensure that the file doesn't become
// corrupted by encrypting an already encrypted file.
// DO NOT CHANGE THE INITIALISE STRING !
// v8.0.1: The ECB cipher only encrypts 8 bytes at a time. Unfortunately, there are circumstances where the first
// character of the block remains unchanged. The first character was being used to check that the encryption had been applied
// and this gave a false negative. As a result, instead of displaying an error message we now just don't write the file
// to disk and leave it unencrypted. It's not a big deal as it only depends on particular
// GP practice numbers and the file contents are pretty obscure even without encryption.
const
  CryptKey: string[9] = chr($7A) + chr($A4) + chr($97) + chr($09) + chr($0C) + chr($55) + chr($3B) + chr($D1) + chr($16);
var
  BlowFish: TBlowFish;
  MSI, MSO: TMemoryStream;
  StreamKey: char;
begin
//  if not FileExists(AFileName) then exit;
try
  BlowFish := TBlowFish.Create(nil);
  try
    BlowFish.CipherMode := ECB;
    BlowFish.InitialiseString('050242617A7A612021030604'); // a seemingly random sequence of ascii Hex codes

    if FromStream then
      MSI := InStream
    else
      MSI := TMemoryStream.Create;
    MSO := TMemoryStream.Create;
    try
      if not FromStream then
        MSI.LoadFromFile(AFileName); // load the file into the input stream
      MSI.Seek(0, soFromBeginning);   // ReadBuffer operates from the current position so back up
      MSI.ReadBuffer(StreamKey, 1);   // read the first few characters
//      if StreamKey <> PlainKey then exit; // it's already encrypted

      MSI.Seek(0, soFromBeginning);   // back to top again
      BlowFish.EncStream(MSI, MSO);   // encrypt the input stream to the output stream
      MSO.Seek(0, soFromBeginning);   // back to the start of the output stream
//      MSO.ReadBuffer(StreamKey, 1);   // read the first few characters

//      if StreamKey <> PlainKey then   // check that it encrypted ok before overwriting file  // v8.0.1 see comment above
//        raise exception.Create('Cannot write ' + AFileName);                               // v8.0.1 see comment above
      MSO.SaveToFile(AFileName);   // save the encrypted file over the top of the original disk file
                                      // but only now we know the contents are valid
    finally
      if not FromStream then
        MSI.Free;
      MSO.Free;
    end;

    BlowFish.Burn;
  finally
    BlowFish.Free;
  end;
except on e:exception do
  raise;
end;
end;

end.
