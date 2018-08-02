unit LicFuncU;

{ HM 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Forms, IniFiles, SysUtils,
     LicRec,   { in x:\sbslib\win\excommon\ }
     SerialU;  { in x:\entrprse\multcomp\ }

{ Returns a string descriptor of the country id }
Function licCountryStr (Const CntryId : Byte;Const Short:Boolean) : ShortString;

{ Returns a string representation of the hex serial number }
//Function licSerialStr (Const SNo : SerialNoType) : SerialNoStrType;

{ Validates the passed string as a disk Serial Number }
Function licValidSNo(Const TheSNo : SerialNoStrType) : Boolean;

{ Returns a string representation of the licence type }
Function licTypeToStr (Const LicType : Byte) : ShortString;

{ Returns a string representation of the Currency Version }
Function licCurrVerToStr (Const LicCurr : Byte) : ShortString;

{ Returns a string representation of the Core Modules }
Function licEntModsToStr (Const LicCurr : Byte) : ShortString;

{ Returns a string representation of the Core Modules }
{Function licEntVersion (Const LicInfo : LicenceRecType) : ShortString;}
Function licCDEntVersion (Const CDLicInfo : CDLicenceRecType; Const ShortDesc : Boolean = False) : ShortString;

{ Returns a string representation of a modules release state }
Function licEntModRelToStr (Const InstType, ModRel, ModNo : Byte) : ShortString;

{ Returns a long or short string description of a module }
Function licModuleDescEx (Const LongDesc : Boolean; Const ModNo : Byte) : ShortString;

{ Returns a long string description of a module }
Function licModuleDesc (Const ModNo : Byte) : ShortString;

{ Returns a string description of the Client-Server Engine }
Function licCSEngStr (Const EngType : Byte; Const Short : Boolean) : ShortString;

{ Returns a string description of a module }
Function licLicTypeToStr (Const LicType : Byte; Const Short : Boolean) : ShortString;

{ Converts a ISN array of byte into a ISN format display string }
{Function ISNByteToStr (Const ISNLic : LicenceRecType) : ShortString;}
Function ISNByteToStr (Const LicESN : ESNByteArrayType;
                       Const licSNo : SerialNoStrType) : ShortString;

{ Converts a ISN array of byte into a ISN format display string, but reurns blank if not set }
Function ISNByteToStrB (Const LicESN : ESNByteArrayType;
                        Const licSNo : SerialNoStrType) : ShortString;

{ Converts a ISN array of byte into a ISN format display string }
{Function ESN2ByteToStr (Const ISNLic : LicenceRecType) : ShortString;}
Function ESN2ByteToStr (Const LicESN2 : ESNByteArrayType) : ShortString;

{ Copies the licence details between the two different licencing structures }
Procedure licCopyLicence (Var   CDLic  : CDLicenceRecType;
                          Var   EntLic : EntLicenceRecType;
                          Const FromCD : Boolean);

{ Copies the CD licence details into the Enterprise Licence Details which it returns }
Function licCopyCDLicToEntLic (CDLic : CDLicenceRecType) : EntLicenceRecType;

{ Copies the Enterprise licence details into the CD Licence Details which it returns }
Function licCopyEntLicToCDLic (EntLic : EntLicenceRecType) : CDLicenceRecType;

{ Return string representing the Enterprise Version for the licence version }
Function licEntVer(Const LicVer : Byte) : ShortString;

{ Returns True if the passed ESN is set - any numbers <> 0 }
Function licESNSet(Const licESN : ESNByteArrayType) : Boolean;

{ Returns True if the passed ESN's match exactly }
Function licMatchingESN(Const licESN1, licESN2 : ESNByteArrayType) : Boolean;

// Calculates the 7th byte in a v5.00 ESN
Function licCalcESNByte7 (licESN : ESNByteArrayType; Const licLicType : Byte) : Byte;

// Formats an ESN into the v5.00 7 segment ESN display
Function licESN7Str (Const licESN : ESNByteArrayType; Const licLicType : Byte) : ShortString;

// Formats an ESN into the 6 segment ESN display string
Function licESNStr (Const licESN : ESNByteArrayType) : ShortString;

// Decodes the 7th segment of a v5.00 ESN
Function licDecodeDemoFlag (Const licESN : ESNByteArrayType; Var DemoFlag : Byte) : Boolean;

// Returns a string description of the licEntClSvr field from the Licence
Function licEntClSvrToStr (Const EntClSvr : Byte; Const Short : Boolean) : ShortString;

// Returns a string description of the licPSQLWGEVer field from the Licence
Function licPSQLWGEVerToStr (Const PSQLWGEVer : Byte; Const Short : Boolean = True) : ShortString;

// Returns a string description of the licProductType field from the Licence
Function licProductTypeToStr (Const ProductType : Byte; Const Short : Boolean = True) : ShortString;

// Extracts the stored CD-Key from a formatted CD-Key string in the format
// XXXXX-XXXXX-XXXXX-XXXXX-XXXXX.  To save space the '-' are not stored in
// the licence file
Function ExtractCDKeyForLicence (Const FormattedCDKey : ShortString) : ShortString;

// Formats the stored unformatted CD-Key into the display format
// XXXXX-XXXXX-XXXXX-XXXXX-XXXXX.  To save space the '-' are not stored in
// the licence file
Function FormatCDKey (Const UnformattedCDKey : ShortString) : ShortString;

// v6.00 - Returns a string version of the DB Version
Function licDBToStr (Const DBVersion : Byte; Const Short : Boolean = False) : ShortString;

// MH 16/11/2012 v7.0 - Returns a string version of the Exchequer Edition
Function licExchequerEditionToStr (Const ExchEdition : TExchequerEdition; Const Short : Boolean = False) : ShortString;

implementation

Uses StrUtils;

//--------------------------------------------------------------------------

{ Returns a string descriptor of the country id }
Function licCountryStr (Const CntryId : Byte;Const Short:Boolean) : ShortString;
Begin { licCountryStr }
  If Short Then Begin
    Case CntryId Of
      0 : Result := '';                   { Any Country }
      1 : Result := 'UK';
      2 : Result := 'NZ';
      3 : Result := 'Sing';
      4 : Result := 'Aus';
      5 : Result := 'EIRE';
      6 : Result := 'RSA';
    Else
      Result := '???';
    End; { Case }
  End { If }
  Else Begin
    Case CntryId Of
      0 : Result := '';                   { Any Country }
      1 : Result := 'United Kingdom';
      2 : Result := 'New Zealand';
      3 : Result := 'Singapore';
      4 : Result := 'Australia';
      5 : Result := 'Ireland';
      6 : Result := 'South Africa';
    Else
      Result := 'Unknown';
    End; { Case }
  End; { Else }
End; { licCountryStr }

//--------------------------------------------------------------------------

(*
{ Returns a string representation of the hex serial number }
Function licSerialStr (Const SNo : SerialNoType) : SerialNoStrType;

  Function ByteToHexStr (Const TheByte : Byte) : ShortString;
  Begin { ByteToHexStr }
    { Convert Byte to hex string equivalent }
    Result := Format ('%2x', [TheByte]);

    { Check for blank leading byte }
    If (Result[1] = ' ') Then
      Result[1] := '0';
  End; { ByteToHexStr }

Begin { licSerialStr }
  If (SNo[1] <> 0) Or (SNo[2] <> 0) Or (SNo[3] <> 0) Or (SNo[4] <> 0) Then Begin
    { Serial Numner is set }
    Result := ByteToHexStr(SNo[4]) +
              ByteToHexStr(SNo[3]) + '-' +
              ByteToHexStr(SNo[2]) +
              ByteToHexStr(SNo[1]);
  End { If }
  Else Begin
    { Serial Number isn't set }
    Result := '  -  ';
  End; { If }
End; { licSerialStr }
*)

//--------------------------------------------------------------------------

{ Validates the passed string as a disk Serial Number }
Function licValidSNo(Const TheSNo : SerialNoStrType) : Boolean;
Const
  OKChars = ['A'..'F', '0', '1'..'9'];
Begin { licValidSNo }
  { Check the length is right - 'XXXX-XXXX' }
  Result := (Length(TheSNo) = 9);

  If Result Then Begin
    { Check format }
    Result := ((TheSno[1] In OKChars) And
               (TheSno[2] In OKChars) And
               (TheSno[3] In OKChars) And
               (TheSno[4] In OKChars) And
               (TheSno[5] = '-') And
               (TheSno[6] In OKChars) And
               (TheSno[7] In OKChars) And
               (TheSno[8] In OKChars) And
               (TheSno[1] In OKChars));
  End; { If Result }
End; { licValidSNo }

//--------------------------------------------------------------------------

{ Returns a string representation of the licence type }
Function licTypeToStr (Const LicType : Byte) : ShortString;
Begin { licTypeToStr }
  Case LicType Of
    0 : Result := 'Install';
    1 : Result := 'Upgrade';
    2 : Result := 'Auto-Upgrade';
  Else
    Result := 'Invalid';
  End; { Case }
End; { licTypeToStr }

//--------------------------------------------------------------------------

{ Returns a string representation of the Currency Version }
Function licCurrVerToStr (Const LicCurr : Byte) : ShortString;
Begin { licCurrVerToStr }
  Case LicCurr Of
    0 : Result := 'Prof';
    1 : Result := 'Euro';
    2 : Result := 'Global';
  Else
    Result := 'Invalid';
  End; { Case }
End; { licCurrVerToStr }

//--------------------------------------------------------------------------

{ Returns a string representation of the Core Modules }
Function licEntModsToStr (Const LicCurr : Byte) : ShortString;
Begin { licEntModsToStr }
  Case LicCurr Of
    0 : Result := '';
    1 : Result := 'Stock';
    2 : Result := 'SPOP';
  Else
    Result := 'Invalid';
  End; { Case }
End; { licEntModsToStr }

//--------------------------------------------------------------------------

{ Returns a string representation of the Core Modules }
Function licCDEntVersion (Const CDLicInfo : CDLicenceRecType; Const ShortDesc : Boolean = False) : ShortString;
Begin { licCDEntVersion }
  With CDLicInfo Do Begin
    If (licProductType In [1, 2]) Then
    Begin
      // 1=LITE Customer, 2=LITE Accountant
      Result := IfThen(licProductType=1, '', 'Practice ');

      Result := Result + IfThen (licEntCVer = 0, 'S/C', 'M/C');

      Case licEntModVer Of
        1 : Result := Result + IfThen(ShortDesc, ' Stk', ' Stock');
        2 : Result := Result + ' SOP';
      End; { Case }

      If (Not ShortDesc) Then Result := Result + ' Edition';
    End // If (licProductType In [1, 2])
    Else
    Begin
      // Assume Exchequer

      { Currency version + Core Modules }
      Result := licCurrVerToStr (licEntCVer) + '/' + licEntModsToStr (licEntModVer);

      { Add Client Server flag }
      If (Result[Length(Result)] <> '/') Then Result := Result + '/';
      If (licEntClSvr = 1) Then Result := Result + 'CS';

      { Add User Count }
      If (Result[Length(Result)] <> '/') Then Result := Result + '/';
      Result := Result + IntToStr(licUserCnt);
    End; // Else
  End; { With CDLicInfo }
End; { licCDEntVersion }

//--------------------------------------------------------------------------

{ Returns a string representation of a modules release state (max 4 chars) }
Function licEntModRelToStr (Const InstType, ModRel, ModNo : Byte) : ShortString;
Begin { licEntModRelToStr }
  Case ModRel Of
    0 : Begin
          If (InstType = 1) And (ModNo In modAutoSet) Then Begin
            { Upgrading a Release Code module - change to auto }
            Result := 'Auto';
          End { If }
          Else
            If (InstType = 2) Then
              { Auto-Upgrade }
              Result := 'Auto'
            Else
              Result := 'No';
        End; { 0 }
    1 : Result := '30-Day';
    2 : Result := 'Full';
  Else
    Result := '?';
  End; { Case }
End; { licEntModRelToStr }

//--------------------------------------------------------------------------

{ Returns a string description of a module }
Function licModuleDescEx (Const LongDesc : Boolean; Const ModNo : Byte) : ShortString;
Begin { licModuleDescEx }
  If LongDesc Then
    // Long Descriptions
    Case ModNo Of
      modAccStk      : Result := 'Account Stock Analysis';
      modImpMod      : Result := 'Importer';
      modJobCost     : Result := 'Job Costing';
      modODBC        : Result := 'ODBC';
      modRepWrt      : Result := 'Report Writer';
      modTeleSale    : Result := 'Telesales';
      modToolDLL     : Result := 'Toolkit DLL (Developer)';
      modToolDLLR    : Result := 'Toolkit DLL (Run-Time)';
      modEBus        : Result := 'eBusiness';
      modPaperless   : Result := 'Paperless';
      modOLESave     : Result := 'OLE Save Functions';
      modCommit      : Result := 'Commitment Accounting';
      modTrade       : Result := 'Trade Counter';
      modStdWOP      : Result := 'Standard WOP';
      modProWOP      : Result := 'Professional WOP';
      modElerts      : Result := 'Sentimail';
      modEnhSec      : Result := 'Enhanced Security';
      modCISRCT      : Result := 'Job Costing CIS/RCT';
      modAppVal      : Result := 'Job Costing App & Val';
      modFullStock   : Result := 'Full Stock Control';
      modVisualRW    : Result := 'Visual Report Writer';
      modGoodsRet    : Result := 'Goods Returns';
      modEBanking    : Result := 'eBanking';
      modOutlookDD   : Result := 'Outlook Dynamic Dashboard';
      // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
      modGDPR        : Result := 'GDPR';
      modPervEncrypt : Result := 'Pervasive File Encryption';
    End { Case }
  Else
    // Short Descriptions
    Case ModNo Of
      modAccStk    : Result := 'Acc Stk Analysis';
      modImpMod    : Result := 'Importer';
      modJobCost   : Result := 'Job Cost';
      modODBC      : Result := 'ODBC';
      modRepWrt    : Result := 'Rep Writer';
      modTeleSale  : Result := 'Telesales';
      modToolDLL   : Result := 'TK Dev';
      modToolDLLR  : Result := 'TK Run';
      modEBus      : Result := 'eBus';
      modPaperless : Result := 'Paperless';
      modOLESave   : Result := 'OLE Save';
      modCommit    : Result := 'Commit';
      modTrade     : Result := 'Trade';
      modStdWOP    : Result := 'Std WOP';
      modProWOP    : Result := 'Prof WOP';
      modElerts    : Result := 'Sentimail';
      modEnhSec    : Result := 'Security';
      modCISRCT    : Result := 'JC CIS/RCT';
      modAppVal    : Result := 'JC App & Val';
      modFullStock : Result := 'Full Stk';
      modVisualRW  : Result := 'VRW';
      modGoodsRet  : Result := 'Returns';
      modEBanking  : Result := 'eBank';
      modOutlookDD : Result := 'ODD';
      // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
      modGDPR        : Result := 'GDPR';
      modPervEncrypt : Result := 'P.SQL Encrypt';
    End; { Case }
End; { licModuleDescEx }

{ Returns a string description of a module }
Function licModuleDesc (Const ModNo : Byte) : ShortString;
Begin { licModuleDesc }
  Result := licModuleDescEx (True, ModNo);
End; { licModuleDesc }

//--------------------------------------------------------------------------

{ Returns a string description of the Client-Server Engine }
Function licCSEngStr (Const EngType : Byte; Const Short : Boolean) : ShortString;
Begin { licCSEngStr }
  If Short Then Begin
    Case EngType Of
      1   : Result := 'NT';
      2   : Result := 'Netware';
    Else
      Result := 'None';
    End; { Case }
  End { If }
  Else Begin
    Case EngType Of
      1   : Result := 'Microsoft NT';
      2   : Result := 'Novell Netware';
    Else
      Result := 'None';
    End; { Case }
  End; { Else }
End; { licCSEngStr }

{---------------------------------------------------------------------------}

{ Returns a string description of the Licence Type }
Function licLicTypeToStr (Const LicType : Byte; Const Short : Boolean) : ShortString;
Begin { licLicTypeToStr }
  If Short Then Begin
    Case LicType Of
      { Customer / End-User }
      0 : Result := 'Customer';
      { Demo / Reseller }
      1 : Result := 'Demo';
    End; { Case LicType }
  End { If Short }
  Else Begin
    Case LicType Of
      { Customer / End-User }
      0 : Result := 'Customer / End-User';
      { Demo / Reseller }
      1 : Result := 'Demo / Reseller';
    End; { Case LicType }
  End; { Else }
End; { licLicTypeToStr }

{---------------------------------------------------------------------------}

{ Converts a ISN array of byte into a ISN format display string }
Function ISNByteToStr (Const LicESN : ESNByteArrayType;
                       Const licSNo : SerialNoStrType) : ShortString;
Var
  LclByte : SerialNoType;
Begin { ISNByteToStr }
  If (licESN[1] = 0) And (licESN[2] = 0) And (licESN[3] = 0) And
     (licESN[4] = 0) And (licESN[5] = 0) And (licESN[6] = 0) Then Begin
    { ESN Not Set - must be Install or first SCuD Upgrade generate ESN }
    { from CD Serial Number                                            }
    { Note: 1 in 281.4 Billion probability of all 0's being correct    }

    FillChar(LclByte, SizeOf(LclByte), #0);

    Result := SNoByteToISN (SNoStrToSNoByte (licSNo), LclByte);
  End { If }
  Else Begin
    { ISN Set }
    Result := IntToStr3(licESN[1]) + '-' +
              IntToStr3(licESN[2]) + '-' +
              IntToStr3(licESN[3]) + '-' +
              IntToStr3(licESN[4]) + '-' +
              IntToStr3(licESN[5]) + '-' +
              IntToStr3(licESN[6]);
  End; { Else }
End; { ISNByteToStr }

{---------------------------------------------------------------------------}

{ Converts a ISN array of byte into a ISN format display string, but reurns blank if not set }
Function ISNByteToStrB (Const LicESN : ESNByteArrayType;
                        Const licSNo : SerialNoStrType) : ShortString;
Begin { ISNByteToStrB }
  Result := '';

  If (licESN[1] <> 0) Or (licESN[2] <> 0) Or (licESN[3] <> 0) Or
     (licESN[4] <> 0) Or (licESN[5] <> 0) Or (licESN[6] <> 0) Then
    Result := ISNByteToStr (LicESN, licSNo);
End; { ISNByteToStrB }

{---------------------------------------------------------------------------}

{ Converts a ISN array of byte into a ISN format display string }
Function ESN2ByteToStr (Const LicESN2 : ESNByteArrayType) : ShortString;
Begin { ESN2ByteToStr }
  Result := '';

  If (licESN2[1] <> 0) Or (licESN2[2] <> 0) Or (licESN2[3] <> 0) Or
     (licESN2[4] <> 0) Or (licESN2[5] <> 0) Or (licESN2[6] <> 0) Then Begin
    { ESN2 Set }
    Result := IntToStr3(licESN2[1]) + '-' +
              IntToStr3(licESN2[2]) + '-' +
              IntToStr3(licESN2[3]) + '-' +
              IntToStr3(licESN2[4]) + '-' +
              IntToStr3(licESN2[5]) + '-' +
              IntToStr3(licESN2[6]);
  End; { If }
End; { ESNByte2ToStr }

//--------------------------------------------------------------------------

{ Copies the licence details between the two different licencing structures }
Procedure licCopyLicence (Var   CDLic  : CDLicenceRecType;
                          Var   EntLic : EntLicenceRecType;
                          Const FromCD : Boolean);

  { Copies values between two variables depending on the FromVar1 flag }
  Procedure Swapsies (Const FromVar2           : Boolean;
                            Var1, Var2         : Pointer;
                      Const VarSize1, VarSize2 : LongInt);
  Begin { Swapsies }
    If (VarSize1 = VarSize2) Then Begin
      { Two variables are the same size - continue }
      If FromVar2 Then
        Move (Var2^, Var1^, VarSize1)
      Else
        Move (Var1^, Var2^, VarSize1);
    End { If (VarSize1 = VarSize2) }
    Else
      Raise Exception.Create ('LicFuncU.Pas - licCopyLicence - Variable Size Mismatch');
  End; { Swapsies }

Begin { licCopyLicence }
  { IMPORTANT NOTE:  This must be kept in sync with the structures in LicRec.Pas }
  { and the Swapsies routine can only be used for variables of identical types   }

  Swapsies (FromCD, @EntLic.licLicType, @CDLic.licLicType, SizeOf(EntLic.licLicType), SizeOf(CDLic.LicLicType));
  Swapsies (FromCD, @EntLic.licType, @CDLic.licType, SizeOf(EntLic.licType), SizeOf(CDLic.licType));
  Swapsies (FromCD, @EntLic.licCountry, @CDLic.licCountry, SizeOf(EntLic.licCountry), SizeOf(CDLic.licCountry));

  Swapsies (FromCD, @EntLic.licCompany, @CDLic.licCompany, SizeOf(EntLic.licCompany), SizeOf(CDLic.licCompany));
  Swapsies (FromCD, @EntLic.licDealer, @CDLic.licDealer, SizeOf(EntLic.licDealer), SizeOf(CDLic.licDealer));
  Swapsies (FromCD, @EntLic.licISN, @CDLic.licESN, SizeOf(EntLic.licISN), SizeOf(CDLic.licESN));
  Swapsies (FromCD, @EntLic.licESN2, @CDLic.licESN2, SizeOf(EntLic.licESN2), SizeOf(CDLic.licESN2));

  Swapsies (FromCD, @EntLic.licSerialNo, @CDLic.licSerialNo, SizeOf(EntLic.licSerialNo), SizeOf(CDLic.licSerialNo));

  Swapsies (FromCD, @EntLic.licEntCVer, @CDLic.licEntCVer, SizeOf(EntLic.licEntCVer), SizeOf(CDLic.licEntCVer));
  Swapsies (FromCD, @EntLic.licEntModVer, @CDLic.licEntModVer, SizeOf(EntLic.licEntModVer), SizeOf(CDLic.licEntModVer));
  Swapsies (FromCD, @EntLic.licEntClSvr, @CDLic.licEntClSvr, SizeOf(EntLic.licEntClSvr), SizeOf(CDLic.licEntClSvr));
  Swapsies (FromCD, @EntLic.licUserCnt, @CDLic.licUserCnt, SizeOf(EntLic.licUserCnt), SizeOf(CDLic.licUserCnt));

  Swapsies (FromCD, @EntLic.licClServer, @CDLic.licClServer, SizeOf(EntLic.licClServer), SizeOf(CDLic.licClServer));
  Swapsies (FromCD, @EntLic.licCSUserCnt, @CDLic.licCSUserCnt, SizeOf(EntLic.licCSUserCnt), SizeOf(CDLic.licCSUserCnt));

  Swapsies (FromCD, @EntLic.licModules, @CDLic.licModules, SizeOf(EntLic.licModules), SizeOf(CDLic.licModules));
  Swapsies (FromCD, @EntLic.licUserCounts, @CDLic.licUserCounts, SizeOf(EntLic.licUserCounts), SizeOf(CDLic.licUserCounts));

  Swapsies (FromCD, @EntLic.licExpiry, @CDLic.licExpiry, SizeOf(EntLic.licExpiry), SizeOf(CDLic.licExpiry));

  Swapsies (FromCD, @EntLic.licResetModRels, @CDLic.licResetModRels, SizeOf(EntLic.licResetModRels), SizeOf(CDLic.licResetModRels));
  Swapsies (FromCD, @EntLic.licResetCountry, @CDLic.licResetCountry, SizeOf(EntLic.licResetCountry), SizeOf(CDLic.licResetCountry));

  Swapsies (FromCD, @EntLic.licPSQLWGEVer, @CDLic.licPSQLWGEVer, SizeOf(EntLic.licPSQLWGEVer), SizeOf(CDLic.licPSQLWGEVer));

  Swapsies (FromCD, @EntLic.licProductType, @CDLic.licProductType, SizeOf(EntLic.licProductType), SizeOf(CDLic.licProductType));

  Swapsies (FromCD, @EntLic.licCDKey, @CDLic.licCDKey, SizeOf(EntLic.licCDKey), SizeOf(CDLic.licCDKey));

  // MH 06/03/06: Added Edition/Theme into Enterprise Licence structure for LITE
  Swapsies (FromCD, @EntLic.licEntEdition, @CDLic.licEntEdition, SizeOf(EntLic.licEntEdition), SizeOf(CDLic.licEntEdition));

  // MH 19/11/12: Added Exchequer Edition into Enterprise Licence structure for Small Business Edition
  Swapsies (FromCD, @EntLic.licExchequerEdition, @CDLic.licExchequerEdition, SizeOf(EntLic.licExchequerEdition), SizeOf(CDLic.licExchequerEdition));

  {$IFDEF LIC600}
  Swapsies (FromCD, @EntLic.licEntDB, @CDLic.licEntDB, SizeOf(EntLic.licEntDB), SizeOf(CDLic.licEntDB));
  {$ENDIF}
End; { licCopyLicence }

//--------------------------------------------------------------------------

{ Copies the CD licence details into the Enterprise Licence Details which it returns }
Function licCopyCDLicToEntLic (CDLic : CDLicenceRecType) : EntLicenceRecType;
Var
  EntLic : EntLicenceRecType;
Begin { licCopyCDLicToEntLic }
  { Initialise the Enterprise licence }
  FillChar (EntLic, SizeOf(EntLic), #0);

  { Copy the CD licence details to the Enterprise Licence Details }
  licCopyLicence (CDLic, EntLic, True);

  Result := EntLic;
End; { licCopyCDLicToEntLic }

//--------------------------------------------------------------------------

{ Copies the Enterprise licence details into the CD Licence Details which it returns }
Function licCopyEntLicToCDLic (EntLic : EntLicenceRecType) : CDLicenceRecType;
Var
  CDLic : CDLicenceRecType;
Begin { licCopyEntLicToCDLic }
  { Initialise the Enterprise licence }
  FillChar (CDLic, SizeOf(CDLic), #0);

  { Copy the Ent licence details to the CD Licence Details }
  licCopyLicence (CDLic, EntLic, False);

  Result := CDLic;
End; { licCopyEntLicToCDLic }

//--------------------------------------------------------------------------

{ Return string representing the Enterprise Version for the licence version }
Function licEntVer(Const LicVer : Byte) : ShortString;
Begin { licEntVer }
  Case LicVer Of
    LicVer431    : Result := 'v4.31/v4.32';
    LicVer440    : Result := 'v5.0x/v5.5x/v5.6x/v5.7x';
    LicVer600    : Result := 'v6.xx';
    LicVer70     : Result := 'v7.x';
    // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
    LicVer2018R1 : Result := 'v2018-R1+';
  Else
    Result := '?.??';
  End; { Case }
End; { licEntVer }

//--------------------------------------------------------------------------

{ Returns True if the passed ESN is set - any numbers <> 0 }
Function licESNSet(Const licESN : ESNByteArrayType) : Boolean;
Begin { licESNSet }
  Result := (licESN[1] <> 0) Or (licESN[2] <> 0) Or
            (licESN[3] <> 0) Or (licESN[4] <> 0) Or
            (licESN[5] <> 0) Or (licESN[6] <> 0);
End; { licESNSet }

//--------------------------------------------------------------------------

{ Returns True if the passed ESN's match exactly }
Function licMatchingESN(Const licESN1, licESN2 : ESNByteArrayType) : Boolean;
Begin { licMatchingESN }
  Result := (licEsn1[1] = licEsn2[1]) And (licEsn1[2] = licEsn2[2]) And
            (licEsn1[3] = licEsn2[3]) And (licEsn1[4] = licEsn2[4]) And
            (licEsn1[5] = licEsn2[5]) And (licEsn1[6] = licEsn2[6]);
End; { licMatchingESN }

//--------------------------------------------------------------------------

// Calculates the 7th byte in a v5.00 ESN
Function licCalcESNByte7 (licESN : ESNByteArrayType; Const licLicType : Byte) : Byte;
Const
  MultiplyBy : Array [1..6] Of LongInt = (23,32,29,41,37,56);
Var
  CSum     : LongInt;
  I, Byte7 : Byte;
Begin { licCalcESNByte7 }
(***
  // Attempt 1 - using bit 7 (Value=2) as flag

  // Generate base number for
  If licESNSet (licESN) Then Begin
    // ESN is non-zero - generate Byte7 based on Checksum
    CSum := 0;
    For I := 1 To 6 Do
      CSum := CSum + (licESN[I] SHL (I Mod 4));
    Byte7 := CSum Mod 235;
  End { If licESNSet (licESN) }
  Else
    // ESN Not Set - set multiple bits to hide flag bit
    Byte7 := 1 Or 4 Or 16 Or 64;

  // Zero flag bit if set
  If ((Byte7 And 2) = 2) Then
    Byte7 := Byte7 - 2;

  // Add flag bit into Byte7 where required - 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo
  If (licLicType In [1, 2]) Then
    Byte7 := Byte7 + 2;

  Result := Byte7;
***)

  // Version 2 - Using Shift Right to change number if Demo/Reseller
  Try
    If licESNSet (licESN) Then Begin
      // ESN is non-zero - generate Byte7 based on Checksum
      CSum := 0;
      For I := 1 To 6 Do
        CSum := CSum + (licESN[I] * MultiplyBy[I]);

      If (licLicType In [1, 2]) Then
        CSum := CSum + (CSum Div 6) + (CSum Mod 6);

      Byte7 := CSum Mod 235;
    End { If licESNSet (licESN) }
    Else
      // ESN Not Set - set multiple bits to hide flag bit
      If (licLicType In [1, 2]) Then
        Byte7 := 1 Or 2 Or 4 Or 16 Or 64
      Else
        Byte7 := 16 Or 64 Or 128;
  Except
    // Just in case there are range check errors, etc...
    On Exception Do
      Byte7 := 255;
  End;

  Result := Byte7;
End; { licCalcESNByte7 }

//--------------------------------------------------------------------------

// Formats an ESN into the v5.00 7 segment ESN display
Function licESN7Str (Const licESN : ESNByteArrayType; Const licLicType : Byte) : ShortString;
Var
  Byte7 : Byte;
Begin { licESN7Str }
  // Calculate the ESN Byte7 flag
  Byte7 := licCalcESNByte7 (licESN, licLicType);

  Result := Format ('%3.3d-%3.3d-%3.3d-%3.3d-%3.3d-%3.3d-%3.3d',
                    [licESN[1], licESN[2], licESN[3], licESN[4],
                     licESN[5], licESN[6], Byte7]);
End; { licESN7Str }

//--------------------------------------------------------------------------

// Formats an ESN into the 6 segment ESN display string
Function licESNStr (Const licESN : ESNByteArrayType) : ShortString;
Begin { licESNStr }
  Result := Format ('%3.3d-%3.3d-%3.3d-%3.3d-%3.3d-%3.3d',
                    [licESN[1], licESN[2], licESN[3],
                     licESN[4], licESN[5], licESN[6]]);
End; { licESNStr }

//--------------------------------------------------------------------------

// Decodes the 7th segment of a v5.00 ESN
Function licDecodeDemoFlag (Const licESN : ESNByteArrayType; Var DemoFlag : Byte) : Boolean;
Begin { licDecodeDemoFlag }
  If (DemoFlag = licCalcESNByte7 (licESN, 0)) Then Begin
    // full Version
    DemoFlag := 0;
    Result := True;
  End { If (DemoFlag = CalcESNByte7 (licESN, 0)) }
  Else
    If (DemoFlag = licCalcESNByte7 (licESN, 1)) Then Begin
      // Demo Version
      DemoFlag := 1;
      Result := True;
    End { If (DemoFlag = CalcESNByte7 (licESN, 1)) }
    Else
      // Invalid DemoFlag segment
      Result := False;
End; { licDecodeDemoFlag }

//--------------------------------------------------------------------------

// Returns a string description of the licEntClSvr field from the Licence
Function licEntClSvrToStr (Const EntClSvr : Byte; Const Short : Boolean) : ShortString;
Begin // licEntClSvrToStr
  If Short Then
  Begin
    Case EntClSvr Of
      0   : Result := '615';
      1   : Result := 'CS';
    Else
      Result := '???';
    End; { Case EntClSvr }
  End { If }
  Else
  Begin
    Case EntClSvr Of
      0   : Result := 'v6.15 Workstation';
      1   : Result := 'Client-Server';
    Else
      Result := 'Unknown (' + IntToStr(EntClSvr) + ')';
    End; { Case EntClSvr }
  End; { Else }
End; // licEntClSvrToStr

//--------------------------------------------------------------------------

// Returns a string description of the licPSQLWGEVer field from the Licence
Function licPSQLWGEVerToStr (Const PSQLWGEVer : Byte; Const Short : Boolean = True) : ShortString;
Begin // licPSQLWGEVerToStr
  If Short Then
  Begin
    Case PSQLWGEVer Of
      0   : Result := '';
      1   : Result := 'v8';
    Else
      Result := '???';
    End; { Case EntClSvr }
  End { If }
  Else
  Begin
    Case PSQLWGEVer Of
      0   : Result := '';
      1   : Result := 'P.SQL v8 WGE';
    Else
      Result := '???';
    End; { Case EntClSvr }
  End; { Else }
End; // licPSQLWGEVerToStr

//--------------------------------------------------------------------------

// Returns a string description of the licProductType field from the Licence
Function licProductTypeToStr (Const ProductType : Byte; Const Short : Boolean = True) : ShortString;
Begin // licProductTypeToStr
  If Short Then
  Begin
    Case ProductType Of
      0   : Result := 'Exch';
      1   : Result := 'Cust';
      2   : Result := 'Acct';
    Else
      Result := '???';
    End; { Case ProductType }
  End { If }
  Else
  Begin
    Case ProductType Of
      0   : Result := 'Exchequer';
      1   : Result := 'Customer';
      2   : Result := 'Accountant';
    Else
      Result := '???';
    End; { Case ProductType }
  End; { Else }
End; // licProductTypeToStr

//--------------------------------------------------------------------------

// Extracts the stored CD-Key from a formatted CD-Key string in the format
// XXXX-XXXX-XXXX-XXXX-XXXX-XXXX.  To save space the '-' are not stored in
// the licence file
Function ExtractCDKeyForLicence (Const FormattedCDKey : ShortString) : ShortString;
Begin // ExtractCDKeyForLicence
  If (Length(FormattedCDKey) = 29) Then
  Begin
    Result := Copy (FormattedCDKey, 1, 4) + Copy (FormattedCDKey, 6, 4) + Copy (FormattedCDKey, 11, 4) +
              Copy (FormattedCDKey, 16, 4) + Copy (FormattedCDKey, 21, 4) + Copy (FormattedCDKey, 26, 4);
  End // (Length(FormattedCDKey) = 28)
  Else
    Raise Exception.Create ('LicFuncU.ExtractCDKeyForLicence: Invalid CD-Key Length (' + IntToStr(Length(FormattedCDKey)) + ')');
End; // ExtractCDKeyForLicence

//------------------------------

// Formats the stored unformatted CD-Key into the display format
// XXXX-XXXX-XXXX-XXXX-XXXX-XXXX.  To save space the '-' are not stored in
// the licence file
Function FormatCDKey (Const UnformattedCDKey : ShortString) : ShortString;
Begin // FormatCDKey
  If (Length(UnformattedCDKey) = 24) Then
  Begin
    Result := Copy (UnformattedCDKey, 1, 4) + '-' +
              Copy (UnformattedCDKey, 5, 4) + '-' +
              Copy (UnformattedCDKey, 9, 4) + '-' +
              Copy (UnformattedCDKey, 13, 4) + '-' +
              Copy (UnformattedCDKey, 17, 4) + '-' +
              Copy (UnformattedCDKey, 21, 4);
  End // (Length(UnformattedCDKey) = 24)
  Else
    Result := '     -     -     -     -    ';
End; // FormatCDKey

//-------------------------------------------------------------------------

// v6.00 - Returns a string version of the DB Version
Function licDBToStr (Const DBVersion : Byte; Const Short : Boolean = False) : ShortString;
Begin // licDBToStr
  If Short Then
  Begin
    Case DBVersion Of
      0   : Result := 'P.SQL';
      1   : Result := 'MSSQL';
    Else
      Result := '???';
    End; { Case DBVersion }
  End { If }
  Else
  Begin
    Case DBVersion Of
      0   : Result := 'Pervasive.SQL';
      1   : Result := 'Microsoft SQL Server';
    Else
      Result := '???';
    End; { Case DBVersion }
  End; { Else }
End; // licDBToStr

//-------------------------------------------------------------------------

// MH 16/11/2012 v7.0 - Returns a string version of the Exchequer Edition
Function licExchequerEditionToStr (Const ExchEdition : TExchequerEdition; Const Short : Boolean = False) : ShortString;
Begin // licExchequerEditionToStr
  Case ExchEdition Of
    eeStandard      : Result := IfThen(Short, 'Std', 'Standard Edition');
    eeSmallBusiness : Result := IfThen(Short, 'SBE', 'Small Business Edition');
  Else
    Result := '???';
  End; // Case ExchEdition
End; // licExchequerEditionToStr

//-------------------------------------------------------------------------

end.

