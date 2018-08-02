{-----------------------------------------------------------------------------
 Unit Name: uCrypto
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}

Unit uCrypto;

Interface

Uses
  uConsts;

Type
  TCrypto = Class
  Private
    Class Function DoCryptoFile(pOption: TFileOptions; Const pFileIn: String;
      Const pFileOut: String = ''): Boolean; Virtual;
    Class Function DoCryptoString(pOption: TFileOptions; Const pString: String):
      String; Virtual;
  Public
    Class Function EncryptFile(Const pFileIn: String; Const pFileOut: String =
      ''): Boolean; Virtual;
    Class Function DecryptFile(Const pFileIn: String; Const pFileOut: String =
      ''): Boolean; Virtual;
    Class Function EncryptString(Const pString: String): String;
    Class Function DecryptString(Const pString: String): String;
  End;

Implementation

Uses Windows, Classes, SysUtils,
  uCommon,
  blowfish;

{ TCrypto }

{-----------------------------------------------------------------------------
  Procedure: DecryptFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TCrypto.DecryptFile(Const pFileIn: String; Const pFileOut: String
  = ''): Boolean;
Begin
  Result := DoCryptoFile([soDoDecrypt], pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: DoCryptoFile
  Author:    vmoura

  do the encryption and decryption job
-----------------------------------------------------------------------------}
Class Function TCrypto.DoCryptoFile(pOption: TFileOptions; Const pFileIn,
  pFileOut: String): Boolean;
Var
  lFileOut: String;
  lBlowfish: TBlowfish;
  lsIN,
    lsOut: TFilestream;
Begin
  Result := False;

  lBlowfish := TBlowfish.Create(Nil);
  lBlowfish.CipherMode := TCipherMode(cCryptoMode);

  If pFileOut <> '' Then // test if in and out are diferent
  Begin
    If _FileSize(pFileout) > 0 Then
      _DelFile(pFileout);
    lFileOut := pFileOut;
  End
  Else // if they are, get a temp file
    lFileOut := ExtractFilePath(pFileIn) + _CreateGuidStr +  ExtractFileExt(pFileIn);

  Try
    { i am using file stream because i got problem using just encfile.
     i couldnt delete the file if something wrong happens}
    lsIn := TFilestream.Create(pFileIn, fmOpenRead);
    lsOut := TFilestream.Create(lFileOut, fmCreate);

    With lBlowfish Do
    Try
      LoadIVString(cCryptoV); // load crypt key stuff
      InitialiseString(cCryptoKey);

      // try encrypting the file
      If soDoEncrypt In pOption Then
        EncStream(lsIN, lsOut)
      // try decrypting the file
      Else If soDoDecrypt In pOption Then
        DecStream(lsIn, lsOut);
    Except
      On e: Exception Do
      Begin
//        _LogMSG('TCrypto.DoCryptoFile :- Error processing file. Error: ' + e.Message);
//        Result := False;
//        lBlowfish.Burn;
//        FreeAndNil(lBlowfish);
//        FreeAndNil(lsIn);
//        FreeAndNil(lsOut);
//        _DelFile(lFileOut);
      End;
    End;
  Finally
    // release the objects here to be able to delete, copy files..
    If Assigned(lsIn) Then
      FreeAndNil(lsIn);
    If Assigned(lsOut) Then
      FreeAndNil(lsOut);

    // if nothing happened...
    If Assigned(lBlowfish) Then
    Begin
      lBlowfish.Burn;
      FreeAndNil(lBlowfish);
    End;

    If _FileSize(lFileOut) > 0 Then
      // test if the file exist and nothing happened
    Begin
      If pFileOut = '' Then
      Begin
        If CopyFile(pchar(lfileOut), pChar(pFileIn), False) Then
        Begin // try to copy to same name
          _DelFile(lFileOut);
          Result := True;
        End // copy file
        Else If _DelFile(pFileIn) Then
          // if somethig happens, try delete and just rename the file name}
          If RenameFile(lFileOut, pFileIn) Then
            Result := True;
         // else begin
      End // else begin
      Else
        Result := True;
    End // if fileexists
    Else If FileExists(lFileOut) Then // remove garbage if something gets wrong
      _DelFile(lFileOut);

  End; // finally
End;

{-----------------------------------------------------------------------------
  Procedure: EncryptFile
  Author:    vmoura

  if pFileOut is '' then it  creates a "empty" file
  after that, copy this information over the original file
-----------------------------------------------------------------------------}
Class Function TCrypto.EncryptFile(Const pFileIn: String; Const pFileOut: String
  = ''): boolean;
Begin
  Result := DoCryptoFile([soDoEncrypt], pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: DoCryptoString
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TCrypto.DoCryptoString(pOption: TFileOptions; Const pString: String): String;
Var
  lBlowfish: TBlowfish;
  lsIn,
    lsOut: String;
Begin
  Result := '';
  lBlowfish := TBlowfish.Create(Nil);
  lBlowfish.CipherMode := TCipherMode(cCryptoMode);
  lsIn := pString;

  Try
    With lBlowfish Do
    Try
      LoadIVString(cCryptoV); // load crypt key stuff
      InitialiseString(cCryptoKey);
      // try encrypt the string
      If soDoEncrypt In pOption Then
        EncString(lsIn, lsOut)
      // try decrypt the string
      Else If soDoDecrypt In pOption Then
        DecString(lsIn, lsOut);
    Except
      On e: Exception Do
      Begin
        lBlowfish.Burn;
        lsOut := '';
        FreeAndNil(lBlowfish);
      End;
    End;
  Finally
    // if nothing happened...
    If Assigned(lBlowfish) Then
    Begin
      lBlowfish.Burn;
      FreeAndNil(lBlowfish);
    End;{If Assigned(lBlowfish) Then}

    If lsOut <> '' Then
      Result := lsOut;
  End; // finally
End;

{-----------------------------------------------------------------------------
  Procedure: EncryptString
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TCrypto.EncryptString(Const pString: String): String;
Begin
  If Trim(pString) <> '' Then
    Result := DoCryptoString([soDoEncrypt], pString);
End;

{-----------------------------------------------------------------------------
  Procedure: DecryptString
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TCrypto.DecryptString(Const pString: String): String;
Begin
  If Trim(pString) <> '' Then
    Result := DoCryptoString([soDoDecrypt], pString);
End;

End.

