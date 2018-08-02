unit oLicence;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, LicRec, LicVar, LicFuncU;

Const
  LicenceVersions : Set Of Byte = [LicVer431, LicVer440, LicVer600, LicVer70, LicVer2018R1];

Type
  TEntLicence = Class(TObject)
  Private
    FCheck1    : Byte;
    FCheck2    : Byte;
    FExpired   : Boolean;
    FExpiry    : TDateTime;
    FFileName  : ShortString;
    FPosBinary : LongInt;
    FPosData   : LongInt;
    FSetExpiry : Boolean;         { Set Expiry flag if expired during reading of info }
    FSize      : LongInt;
    FUsers     : SmallInt;        { Enterprise User Count: 1-999 }
    FValid     : Boolean;
    FValidErr  : Byte;            { Validation Error Number }
    FVersion   : Byte;            { Licence Version }

    Function GetValidErr : ShortString;
    Procedure ZapInfo;
  Protected
    Function GetBaseMods : Byte;
    Function GetCDSerial : ShortString;
    Function GetClSvr : Byte;
    Function GetClSvrEng : Byte;
    Function GetClSvrEngU : SmallInt;
    Function GetCompany : ShortString;
    Function GetCountry : Byte;
    Function GetCurrVer : Byte;
    Function GetDealer : ShortString;
    Function GetIsCurrent : Boolean;
    Function GetLicType : Byte;
    Function GetModules (Index : Byte) : Byte;
    Function GetUserCounts (Index : Byte) : SmallInt;
    Procedure SetFileName(Value : ShortString);
    Function GetType : Byte;
    Function GetUsers : SmallInt;
    Function GetIssueNo : SmallInt;
    Function GetPSQLKey : ShortString;
    Function GetPSQLWGE : Byte;
    Function GetEntDBType : Byte;
    Function GetExchequerEdition : TExchequerEdition;
  Public
    EncLic : CDLicenceRecType;

    Property Check1 : Byte Read FCheck1;
    Property Check2 : Byte Read FCheck2;
    Property Expired : Boolean Read FExpired;
    Property Expiry : TDateTime Read FExpiry;
    Property FileName : ShortString Read FFileName Write SetFileName;
    Property IsCurrent : Boolean Read GetIsCurrent;
    Property PosBinary : LongInt Read FPosBinary;
    Property PosData : LongInt Read FPosData;
    Property SetExpiry : Boolean Read FSetExpiry Write FSetExpiry;
    Property Size : LongInt Read FSize;
    Property Valid : Boolean Read FValid;
    Property ValidErrStr : ShortString Read GetValidErr;
    Property Version : Byte Read FVersion;

    { Enterprise Licence Details }
    Property BaseModules : Byte Read GetBaseMods;
    Property CDSerial : ShortString Read GetCDSerial;
    Property ClSvr : Byte Read GetClSvr;
    Property Company : ShortString Read GetCompany;
    Property Country : Byte Read GetCountry;
    Property CurrVer : Byte Read GetCurrVer;
    Property Dealer : ShortString Read GetDealer;
    Property InstType : Byte Read GetType;
    Property IssueNo : SmallInt Read GetIssueNo;
    Property LicType : Byte Read GetLicType;
    Property Modules[Index : Byte] : Byte Read GetModules;
    Property PSQLKey : ShortString Read GetPSQLKey;
    Property PSQLWGE : Byte Read GetPSQLWGE;
    Property UserCounts[Index : Byte] : SmallInt Read GetUserCounts;
    Property Users : SmallInt Read GetUsers;

    { Pervasive.SQL Licence }
    Property ClSvrEng : Byte Read GetClSvrEng;
    Property ClSvrUser : SmallInt Read GetClSvrEngU;

    Property EntDBType : Byte Read GetEntDBType;

    // HM 19/11/12: Added SBE Support
    Property ExchequerEdition : TExchequerEdition Read GetExchequerEdition;

    Constructor Create;
    Destructor Destroy; Override;
  End; { TEntLicence }


implementation

Uses Crypto, ECBUtil;

Constructor TEntLicence.Create;
Begin { Create }
  Inherited Create;

  { System flag }
  FSetExpiry := False;

  ZapInfo;
End; { Create }

Procedure TEntLicence.ZapInfo;
Begin { ZapInfo }
  FFileName  := '';
  FValid     := False;
  FValidErr  := 0;

  { Decode info }
  FPosBinary := 0;
  FPosData   := 0;
  FSize      := 0;
  FVersion   := 0;

  { Checksums }
  FCheck1    := 0;
  FCheck2    := 0;

  { Licence flags }
  FExpired   := False;
  FExpiry    := 0;
End; { Create }

Destructor TEntLicence.Destroy;
Begin { Destroy }

  Inherited Destroy;
End; { Destroy }

Function TEntLicence.GetValidErr : ShortString;
Begin { GetValidErr }
  Case FValidErr Of
    0   : Result := 'Validated OK';
    1   : Result := 'Invalid Licence File (1)';
    2,3 : Result := 'The Enterprise CD Licence Checksum failed';
    4   : Result := 'The Enterprise CD Licence File is an unsupported version';
    5   : Result := 'Invalid Licence File (2)';
    6   : Result := 'Invalid Licence File (6)';
    7   : Result := 'Licence File Not Found';
    255 : Result := 'Unknown Error';
  Else
    Result := '';
  End; { Case }
End; { GetValidErr }

Procedure TEntLicence.SetFileName(Value : ShortString);
Var
  LicenceF          : TFileStream;
  I, ChkSum         : LongInt;
  CryptKey,
  DataByte, DataLen : Byte;
  //Year, Month, Day  : Word;

  Function LongToByte (Const TheLong : LongInt) : Byte;
  Begin
    Try
      Result := TheLong;
    Except
      Result := 0;
    End;
  End;

  {-------------------------}

  Procedure Read431Licence;
  Var
    Lic431 : Old431LicenceRecType;
    I      : SmallInt;
  Begin { Read431Licence }
    LicenceF.Read (Lic431, SizeOf(Lic431));
    ChangeCryptoKey (6370 + CryptKey);
    DecodeData(@Lic431, SizeOf(Lic431));

    { unreverse strings reversed for safety reasons }
    Lic431.licCompany := ReverseString (Lic431.licCompany);
    Lic431.licSerialNo := ReverseString (Lic431.licSerialNo);

    { Copy details into current licence structure }
    FillChar (EncLic, SizeOf(EncLic), #0);
    With Lic431 Do Begin
      EncLic.licLicType   := licLicType;
      EncLic.licType      := licType;
      EncLic.licCountry   := licCountry;

      EncLic.licCompany   := licCompany;
      EncLic.licDealer    := licDealer;

      EncLic.licESN       := licISN;
      EncLic.licESN2      := licESN2;

      EncLic.licSerialNo  := licSerialNo;

      EncLic.licEntDB     := DBBtrieve;
      EncLic.licEntCVer   := licEntCVer;
      EncLic.licEntModVer := licEntModVer;
      EncLic.licEntClSvr  := licEntClSvr;
      EncLic.licUserCnt   := licUserCnt;

      EncLic.licClServer  := licClServer;
      EncLic.licCSUserCnt := licCSUserCnt;

      For I := Low(licModules) To High(licModules) Do
        EncLic.licModules[I] := licModules[I];

      EncLic.licResetModRels := (licOptions[1] = 1);
      EncLic.licResetCountry := licResetCountry;
    End; { With Lic431 }
  End; { Read431Licence }

  {-------------------------}

  Procedure Read440Licence;
  Var
    Lic440 : Old440LicenceRecType;
    I      : SmallInt;
  Begin { Read440Licence }
    LicenceF.Read (Lic440, SizeOf(Lic440));
    ChangeCryptoKey (6370 + CryptKey);
    DecodeData(@Lic440, SizeOf(Lic440));

    { unreverse strings reversed for safety reasons }
    Lic440.licCompany := ReverseString (Lic440.licCompany);
    Lic440.licSerialNo := ReverseString (Lic440.licSerialNo);

    { Copy details into current licence structure }
    FillChar (EncLic, SizeOf(EncLic), #0);
    With Lic440 Do
    Begin
      EncLic.licLicType   := licLicType;
      EncLic.licType      := licType;
      EncLic.licCountry   := licCountry;

      EncLic.licCompany   := licCompany;
      EncLic.licDealer    := licDealer;

      EncLic.licESN       := licESN;
      EncLic.licESN2      := licESN2;

      EncLic.licSerialNo  := licSerialNo;

      EncLic.licEntDB     := DBBtrieve;
      EncLic.licEntCVer   := licEntCVer;
      EncLic.licEntModVer := licEntModVer;
      EncLic.licEntClSvr  := licEntClSvr;
      EncLic.licUserCnt   := licUserCnt;

      EncLic.licClServer  := licClServer;
      EncLic.licCSUserCnt := licCSUserCnt;

      For I := Low(licModules) To High(licModules) Do
        EncLic.licModules[I] := licModules[I];

      For I := Low(licUserCounts) To High(licUserCounts) Do
        EncLic.licUserCounts[I] := licUserCounts[I];

      EncLic.licExpiry := licExpiry;

      EncLic.licResetModRels := licResetModRels;
      EncLic.licResetCountry := licResetCountry;

      EncLic.licAutoUpgIssue := licAutoUpgIssue;

      EncLic.licPSQLLicKey   := licPSQLLicKey;
      EncLic.licPSQLWGEVer   := licPSQLWGEVer;

      EncLic.licEntEdition   := licEntEdition;

      EncLic.licProductType  := licProductType;

      EncLic.licCDKey        := licCDKey;
    End; { With Lic440 }
  End; { Read440Licence }

  {-------------------------}

  Procedure Read600Licence;
  Begin { Read600Licence }
    LicenceF.Read (EncLic, SizeOf(EncLic));
    ChangeCryptoKey (6370 + CryptKey);
    DecodeData(@EncLic, SizeOf(EncLic));

    { unreverse strings reversed for safety reasons }
    EncLic.licCompany := ReverseString (EncLic.licCompany);
    EncLic.licSerialNo := ReverseString (EncLic.licSerialNo);
  End; { Read600Licence }

  {-------------------------}

Begin { SetFileName }
  If (Value <> FFileName) Then
    If FileExists(Value) Then Begin
      ZapInfo;

      FFileName := Value;

      FValidErr := 0;

      Try
        { HM 20/06/01: Removed the Write requirement as it was preventing Read-Only licences from being opened }
        LicenceF := TFileStream.Create(FFileName, fmOpenRead{Write} Or fmShareExclusive);
        Try
          FSize := LicenceF.Size;

          { Revalidate the licence - Check last character }
          LicenceF.Position := Pred(LicenceF.Size);
          LicenceF.Read (DataByte, SizeOf(DataByte));
          FValid := (DataByte = Ord('Z'));
          FValidErr := 1;

          If FValid Then Begin
            { extract data position }
            LicenceF.Position := LicenceF.Size - 5;
            LicenceF.Read (FPosData, SizeOf(FPosData));

            LicenceF.Position := FPosData;
            LicenceF.Read (FVersion,   SizeOf(FVersion));       { File Checksum }
            LicenceF.Read (FCheck1,    SizeOf(FCheck1));        { File Checksum }
            LicenceF.Read (FPosBinary, SizeOf(FPosBinary));     { Start of binary data }

            LicenceF.Position := FPosBinary + 1;
            LicenceF.Read (FCheck2,    SizeOf(FCheck2));        { File Checksum }

            { Check checksums add up }
            FValid := ((FCheck1 + FCheck2) = 255);
            FValidErr := 2;
          End; { If }

          If FValid Then Begin
            { Check licence version }
            // HM 28/06/01: Extended to read v4.30c/v4.31/v4/32 and v4.40 format licences
            //FValid := (FVersion = CurrLicVer);
            FValid := (FVersion In LicenceVersions);
            FValidErr := 4;
          End; { If }

          If FValid Then Begin
            { Check checksum digit is correct }
            ChkSum := 0;
            LicenceF.Position := 1;
            For I := 1 To LicenceF.Size Do Begin
              LicenceF.Read (DataByte, SizeOf(DataByte));

              { Check for special cases }
              If (I = (posBinary + 1)) Then Begin
                { Check Digit 2 }
                Inc (ChkSum, Ord('A'));
              End { If }
              Else Begin
                If (I = (posData + 1)) Then Begin
                  { Check Digit 1 }
                  Inc (ChkSum, 7);
                End { If }
                Else Begin
                  ChkSum := ChkSum + DataByte;
                End; { Else }
              End; { Else }
            End; { For }

            FValid := ((ChkSum Mod 255) = FCheck1);
            FValidErr := 3;
          End; { If }

          If FValid Then Begin
            { Check 1st character of binary section is 'A' }
            LicenceF.Position := FPosBinary;
            LicenceF.Read (DataByte, SizeOf(DataByte));
            FValid := (DataByte = Ord('A'));
            FValidErr := 5;
          End; { If }

          If FValid Then Begin
            { Get key for decryption }
            LicenceF.Position := FPosBinary + 2;
            LicenceF.Read (CryptKey, SizeOf(CryptKey));

            { Extract Licencing Information }
            LicenceF.Position := FPosBinary + 20;
            // HM 28/06/01: Extended to read v4.30c/v4.31/v4/32 and v4.40 format licences
            Case FVersion Of
              LicVer431    : Read431Licence;
              LicVer440    : Read440Licence;
              LicVer600    : Read600Licence;
              LicVer70     : Read600Licence;
              // MH 16/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
              LicVer2018R1 : Read600Licence;
            Else
              FValid := False;
              FValidErr := 6;
            End; { Case }
          End; { If }
        Finally
          LicenceF.Destroy;
        End;
      Except
        FValid := False;
        FValidErr := 255;
      End;
    End { If FileExists(Value) }
    Else Begin
      { File not found }
        FValid := False;
        FValidErr := 7;
    End; { Else }
End; { SetFileName }

{--------------------------------------------------------------------------}

Function TEntLicence.GetBaseMods : Byte;
Begin { GetBaseMods }
  Result := EncLic.licEntModVer;
End; { GetBaseMods }

Function TEntLicence.GetCDSerial : ShortString;
Begin { GetCDSerial }
  Result := EncLic.licSerialNo;
End; { GetCDSerial }

Function TEntLicence.GetClSvr : Byte;
Begin { GetClSvr }
  Result := EncLic.licEntClSvr;
End; { GetClSvr }

Function TEntLicence.GetClSvrEng : Byte;
Begin { GetClSvrEng }
  Result := EncLic.licClServer;
End; { GetClSvrEng }

Function TEntLicence.GetClSvrEngU : SmallInt;
Begin { GetClSvrEngU }
  Result := EncLic.licCSUserCnt;
End; { GetClSvrEngU }

Function TEntLicence.GetCompany : ShortString;
Begin { GetCompany }
  Result := EncLic.licCompany;
End; { GetCompany }

Function TEntLicence.GetCountry : Byte;
Begin { GetCountry }
  Result := EncLic.licCountry;
End; { GetCountry }

Function TEntLicence.GetCurrVer : Byte;
Begin { GetCurrVer }
  Result := EncLic.licEntCVer;
End; { GetCurrVer }

Function TEntLicence.GetModules (Index : Byte) : Byte;
Begin { GetModules }
  If (Index >= Low(EncLic.licModules)) And (Index <= High(EncLic.licModules)) Then
    Result := EncLic.licModules[Index]
  Else
    Result := 0;
End; { GetModules }

Function TEntLicence.GetUserCounts (Index : Byte) : SmallInt;
Begin { GetUserCounts }
  If (Index >= Low(EncLic.licUserCounts)) And (Index <= High(EncLic.licUserCounts)) Then
    Result := EncLic.licUserCounts[Index]
  Else
    Result := 0;
End; { GetUserCounts }


Function TEntLicence.GetType : Byte;
Begin { GetType }
  Result := EncLic.licType;
End; { GetType }

Function TEntLicence.GetUsers : SmallInt;
Begin { GetUsers }
  Result := EncLic.licUserCnt;
End; { GetUsers }

Function TEntLicence.GetLicType : Byte;
Begin { GetLicType }
  Result := EncLic.licLicType;
End; { GetLicType }

Function TEntLicence.GetDealer : ShortString;
Begin { GetDealer }
  Result := EncLic.licDealer;
End; { GetDealer }

Function TEntLicence.GetIsCurrent : Boolean;
Begin { GetIsCurrent }
  Result := (FVersion = CurrLicVer);
End; { GetIsCurrent }

function TEntLicence.GetIssueNo: SmallInt;
begin
  Result := EncLic.licAutoUpgIssue;
end;

Function TEntLicence.GetPSQLKey : ShortString;
begin
  Result := EncLic.licPSQLLicKey;
end;

Function TEntLicence.GetPSQLWGE : Byte;
begin
  Result := EncLic.licPSQLWGEVer;
end;

Function TEntLicence.GetEntDBType : Byte;
begin
  Result := EncLic.licEntDB;
end;

//------------------------------

Function TEntLicence.GetExchequerEdition : TExchequerEdition;
Begin // GetExchequerEdition
  Result := EncLic.licExchequerEdition;
End; // GetExchequerEdition

//------------------------------

end.
