unit WLicFile;

{ markd6 10:35 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, SysUtils, Windows, LicRec;


Function WriteLicFile(Const CDLic : CDLicenceRecType) : ShortString;
Function ReadLicFile (Const LicF : ShortString; Var LicR : CDLicenceRecType) : Boolean;

{$IFDEF SETD}
  { Called by Auto-Upgrades to update the licence with the local details }
  Function UpdateLicFile(Const LicFName : ShortString;
                         Const LocalLic : CDLicenceRecType) : LongInt;
{$ENDIF}

{$IFDEF EBUS}
  E-Business module shouldn't access these functions
{$ENDIF}

implementation

Uses Crypto;

Type
  TempLicFileType = Record
    CryptoKey : Byte;
    Licence   : CDLicenceRecType;
  End; { TempLicFileType }


{----------------------------------------------------------------------------}


Function WriteLicFile(Const CDLic : CDLicenceRecType) : ShortString;
Var
  lpPathName, lpPrefixString, lpTempFileName   : PChar;
  TempPath                                     : ShortString;
  TempLic                                      : TempLicFileType;
  OutF                                         : TFileStream;
  TmpBin                                       : Array [1..255] Of Char;
  Res1                                         : LongInt;
  uUnique                                      : UInt;

  // Copied from FormDes2\FormUtil.Pas
  Function PathToShort (Const FPath : ShortString) : ShortString;
  Var
    Temp1, Temp2 : PChar;
    PLen         : SmallInt;
  Begin
    Result := FPath;

    If (Trim(FPath) <> '') Then Begin
      Temp1 := StrAlloc (250);
      Temp2 := StrAlloc (250);

      StrPCopy (Temp1, Trim(FPath));
      PLen := GetShortPathName (Temp1, Temp2, StrBufSize (Temp2));
      If (PLen > 0) Then
        Result := Trim(StrPas(Temp2));

      StrDispose (Temp1);
      StrDispose (Temp2);
    End; { If }
  End;

Begin { WriteLicFile }
  Result := '';

  { Get path of Temporary file directory }
  Res1 := GetTempPath(SizeOf(TmpBin), @TmpBin);
  Move (TmpBin, TempPath[1], Res1);
  SetLength (TempPath, Res1);

  If (Length (TempPath) > 0) Then Begin
    { Check its got a '\' on the end }
    If (TempPath[Length(TempPath)] <> '\') Then
      TempPath := TempPath + '\';

    // HM 04/07/02: GetTempPath returns a Long file Name under the Netware Client,
    //              whereas it normally returns a shortfilename.
    TempPath := PathToShort (TempPath);

    { Generate temporary file name }
    lpPathName := StrAlloc(255);         // address of directory name for temporary file
    lpPrefixString := StrAlloc(255);    // address of filename prefix
    lpTempFileName := StrAlloc(255);    // address of buffer that receives the new filename

    StrPCopy (lpPathName, TempPath);
    StrPCopy (lpPrefixString, '~vb');
    uUnique := 0;

    { Create temporary file and get filename }
    Res1 := GetTempFileName(lpPathName, lpPrefixString, uUnique, lpTempFileName);
    TempPath := lpTempFileName;

    StrDispose(lpPathName);
    StrDispose(lpPrefixString);
    StrDispose(lpTempFileName);

    { Check temporary file exists }
    If FileExists (TempPath) Then Begin
      Result := TempPath;

      { Open temporary file as stream }
      OutF := TFileStream.Create(TempPath, fmOpenReadWrite);
      Try
        { Encrypt Licence Info }
        FillChar (TempLic, SizeOf(TempLic), #0);
        With TempLic Do Begin
          CryptoKey := Random(200);
          Licence   := CDLic;
          With Licence Do Begin
            licCompany := ReverseString (licCompany);
            licSerialNo := ReverseString (licSerialNo);
          End; { With Licence }

          ChangeCryptoKey (19870 + CryptoKey);
          EncodeData (@Licence, SizeOf(Licence));
        End; { With }

        { Write licence info to temporary file }
        OutF.Position := 1;
        OutF.Write (TempLic, SizeOf(TempLic));
      Finally
        OutF.Destroy;
      End;
    End; { If }
  End; { If }
End; { WriteLicFile }


{----------------------------------------------------------------------------}


Function ReadLicFile (Const LicF : ShortString; Var LicR : CDLicenceRecType) : Boolean;
Var
  TempLic : TempLicFileType;
  OutF    : TFileStream;
Begin { ReadLicFile }
  Result := False;

  FillChar (LicR, SizeOf(LicR), #0);

  If FileExists (LicF) Then Begin
    { Open temporary file as stream }
    OutF := TFileStream.Create(LicF, fmOpenReadWrite);
    Try
      OutF.Position := 1;
      OutF.Read (TempLic, SizeOf(TempLic));

      With TempLic Do Begin
        ChangeCryptoKey (19870 + CryptoKey);
        DecodeData (@Licence, SizeOf(Licence));

        With Licence Do Begin
          licCompany := ReverseString (licCompany);
          licSerialNo := ReverseString (licSerialNo);
        End; { With Licence }
      End; { With TempLic }

      LicR := TempLic.Licence;

      Result := True;
    Finally
      OutF.Destroy;
    End;
  End; { If }
End; { ReadLicFile }


{----------------------------------------------------------------------------}


{$IFDEF SETD}
// Called by Auto-Upgrades to update the licence with the local details
//
// 0     AOK
// 1000  Unknown Error
// 1001  Unknown Exception
// 1002  Licence file Missing
Function UpdateLicFile(Const LicFName : ShortString;
                       Const LocalLic : CDLicenceRecType) : LongInt;
Var
  TempLic  : TempLicFileType;
  OutF     : TFileStream;
Begin { UpdateLicFile }
  Result := 1000;

  Try
    If FileExists (LicFName) Then Begin
      { Open temporary file as stream }
      OutF := TFileStream.Create(LicFName, fmOpenReadWrite);
      Try
        { Read licence }
        OutF.Position := 1;
        OutF.Read (TempLic, SizeOf(TempLic));

        With TempLic Do Begin
          ChangeCryptoKey (19870 + CryptoKey);
          DecodeData (@Licence, SizeOf(Licence));

          With Licence Do Begin
            licCompany := ReverseString (licCompany);
            licSerialNo := ReverseString (licSerialNo);

            { Update Licence details }
            licLicType    := LocalLic.licLicType;        { 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo }
            //licType                                   { 0=Install, 1=Upgrade, 2=Auto-Upgrade }
            licCountry    := LocalLic.licCountry;        { 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA }
            //licCompany                                { Company Name }
            licDealer     := LocalLic.licDealer;        { Dealer Description }
            //licESN                                    { Installation Serial Number }
            //licESN2                                   { Installation Serial Number }
            //licSerialNo
            licEntCVer    := LocalLic.licEntCVer;       { 0-Prof, 1-Euro, 2-MC }
            licEntModVer  := LocalLic.licEntModVer;     { 0-Basic, 1-Stock, 2-SPOP }
            licEntClSvr   := LocalLic.licEntClSvr;      { 0-Non C/S, 1=C/S, 2=Workgroup }
            licUserCnt    := LocalLic.licUserCnt;       { User Count }
            licClServer   := LocalLic.licClServer;      { 0-None, 1=NT, 2=Netware }
            licCSUserCnt  := LocalLic.licCSUserCnt;     { Client-Server Engine User Count }
            licModules    := LocalLic.licModules;       { 0-No, 1-30-Day, 2-Full }
            licUserCounts := LocalLic.licUserCounts;    { Module User Counts }
            licExpiry     := LocalLic.licExpiry;        { Licence Expiry date }
            //licResetModRelCodes                       { Reset Mod Rel Codes - 0=False, 1=True }
            //licResetCountry                           { Reset Country Code during upgrades }

            licCompany  := ReverseString (licCompany);
            licSerialNo := ReverseString (licSerialNo);
          End; { With Licence }

          ChangeCryptoKey (19870 + CryptoKey);
          EncodeData (@Licence, SizeOf(Licence));
        End; { With TempLic }

        { Write licence info to temporary file }
        OutF.Position := 1;
        OutF.Write (TempLic, SizeOf(TempLic));

        Result := 0;
      Finally
        OutF.Destroy;
      End;
    End { If }
    Else
      { Licence file Missing }
      Result := 1002;
  Except
    On Ex:Exception Do
      Result := 1001;
  End; { Try..Except }
End; { UpdateLicFile }
{$ENDIF}


end.
