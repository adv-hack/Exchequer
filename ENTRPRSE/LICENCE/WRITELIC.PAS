unit WriteLic;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Controls, Dialogs, FileCtrl, Forms, SysUtils, Windows;

Procedure WriteLicence (Const DestLicenceDir : ShortString);

implementation

Uses LicRec, LicVar, LicFuncU, Crypto, DiskUtil, lwEntVer, ECBUtil;

Const
  WarnFile = 'LICWARN.TXT';

Procedure WriteLicence (Const DestLicenceDir : ShortString);
Var
  OK           : Boolean;
  posBinary    : LongInt;

  Function CopyWarnFile : Boolean;
  Var
    FromStr, ToStr : PChar;
  Begin { CopyWarnFile }
    FromStr := StrAlloc (250);
    ToStr   := StrAlloc (250);

    StrPCopy (FromStr, ConfigInfo.FileDir + WarnFile);
    //StrPCopy (ToStr, ConfigInfo.LicenceDir + LicFile);
    StrPCopy (ToStr, DestLicenceDir + LicFile);


    Result := CopyFile (FromStr, ToStr, False);

    StrDispose (FromStr);
    StrDispose (ToStr);
  End; {  CopyWarnFile }

  Function WriteLicenceDets : Boolean;
  Var
    OutF            : TStringList;
    TmpStr, TmpStr2 : ShortString;
  Begin { WriteLicenceDets }
    Result := False;

    OutF := TStringList.Create;
    Try
      { Read in existing file }
      OutF.LoadFromFile (DestLicenceDir + LicFile);

      { Append licence info }
      With LicenceInfo Do Begin
        OutF.Add ('  Company:      ' + LicenceInfo.licCompany);
        OutF.Add ('  Dealer:       ' + LicenceInfo.licDealer);
        OutF.Add ('');
        OutF.Add ('  Licence Type: ' + licCountryStr (licCountry, False) + ' ' + licTypeToStr (licType));
        OutF.Add ('');
        OutF.Add ('  CD Serial No: ' + licSerialNo);
        OutF.Add ('  Issue No:     ' + IntToStr(licAutoUpgIssue));
        OutF.Add ('  ESN:          ' + ISNByteToStr (licESN, licSerialNo) + ' / ' + ESN2ByteToStr (licESN2));
        OutF.Add ('');

        (*
        If (licClServer > 0) Then
          OutF.Add ('  C/S Engine:   Pervasive.SQL for ' + licCSEngStr (licClServer, True) + ' - ' + IntToStr(licCSUserCnt) + ' User')
        Else
          If (licPSQLWGEVer > 0) Then
            OutF.Add ('  WGE Engine:   Pervasive.SQL ' + licPSQLWGEVerToStr (licPSQLWGEVer) + ' Workgroup Engine')
          Else
            OutF.Add ('  C/S Engine:');
        *)

        // MH 06/03/07: Modified for MS SQL Support
        If (licEntDB = DBBtrieve) Then
        Begin
          Case licEntClSvr Of
            // Non-Client-Server
            0 : Begin
                  If (licPSQLWGEVer > 0) Then
                    OutF.Add ('  DB Engine:    Pervasive.SQL ' + licPSQLWGEVerToStr (licPSQLWGEVer) + ' Workgroup Engine')
                  Else
                    OutF.Add ('  DB Engine:    No Licence Specified');
                End; // Non-Client-Server
            // Client-Server
            1 : Begin
                  If (licClServer > 0) Then
                    OutF.Add ('  DB Engine:    Pervasive.SQL for ' + licCSEngStr (licClServer, True) + ' - ' + IntToStr(licCSUserCnt) + ' User')
                  Else
                    OutF.Add ('  DB Engine:    No Licence Specified');
                End; // Client-Server
          End; // Case licEntClSvr
        End // If (licEntDB = DBBtrieve)
        Else
        Begin
          OutF.Add ('  DB Engine:    MS SQL Server');
        End; // Else
        OutF.Add ('');

        // MH 21/09/07: Hid this section as meaningless for Auto-Upgrades
        If (licType <> 2) Then
        Begin
          // HM 05/10/04: Rewrote as it was crashing for Auto-Upgrades where the Edition is 0
          TmpStr := '  Exchequer:    ' + licCDEntVersion (LicenceInfo) + ' - ' + IntToStr(licUserCounts[ucCompanies]) + ' Companies';
          // MH 16/11/2012 v7.0: Remove theming support and added Exchequer Edition
          TmpStr := TmpStr + ' - ' + licExchequerEditionToStr (licExchequerEdition);
          OutF.Add (TmpStr);

          OutF.Add ('                  Account Stock Analysis       ' + licEntModRelToStr (licType, licModules[modAccStk], modAccStk));
          OutF.Add ('                  Commitment Accounting        ' + licEntModRelToStr (licType, licModules[modCommit], modCommit));
          OutF.Add ('                  eBanking                     ' + licEntModRelToStr (licType, licModules[modEBanking], modEBanking));
          OutF.Add ('                  eBusiness                    ' + licEntModRelToStr (licType, licModules[modEBus], modEBus));
          OutF.Add ('                  Enhanced Security            ' + licEntModRelToStr (licType, licModules[modEnhSec], modEnhSec));
          OutF.Add ('                  Full Stock Control           ' + licEntModRelToStr (licType, licModules[modFullStock], modFullStock));
          // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
          OutF.Add ('                  GDPR                         ' + licEntModRelToStr (licType, licModules[modGDPR], modGDPR));
          OutF.Add ('                  Goods Returns                ' + licEntModRelToStr (licType, licModules[modGoodsRet], modGoodsRet));
          OutF.Add ('                  Import Module                ' + licEntModRelToStr (licType, licModules[modImpMod], modImpMod));
          OutF.Add ('                  Job Costing                  ' + licEntModRelToStr (licType, licModules[modJobCost], modJobCost));
          OutF.Add ('                    Applications & Valuations  ' + licEntModRelToStr (licType, licModules[modAppVal], modAppVal));
          OutF.Add ('                    CIS/RCT                    ' + licEntModRelToStr (licType, licModules[modCISRCT], modCISRCT));
          OutF.Add ('                  ODBC                         ' + licEntModRelToStr (licType, licModules[modODBC], modODBC));
          OutF.Add ('                  OLE Save Functions           ' + licEntModRelToStr (licType, licModules[modOLESave], modOLESave));
          OutF.Add ('                  Outlook Dynamic Dashboard    ' + licEntModRelToStr (licType, licModules[modOutlookDD], modOutlookDD));
          OutF.Add ('                  Paperless                    ' + licEntModRelToStr (licType, licModules[modPaperless], modPaperless));
          // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
          OutF.Add ('                  Pervasive File Encryption    ' + licEntModRelToStr (licType, licModules[modPervEncrypt], modPervEncrypt));
          OutF.Add ('                  Report Writer                ' + licEntModRelToStr (licType, licModules[modRepWrt], modRepWrt));
          OutF.Add ('                  Sentimail                    ' + licElertsDesc (licModules[modElerts], licUserCounts[ucElerts]));
          OutF.Add ('                  Telesales                    ' + licEntModRelToStr (licType, licModules[modTeleSale], modTeleSale));
          OutF.Add ('                  Toolkit                      ' + licToolkitDesc(licModules[modToolDLLR], licModules[modToolDLL], licUserCounts[ucToolkit30], licUserCounts[ucToolkitFull]));
          OutF.Add ('                  Trade Counter                ' + licEntModRelToStr (licType, licModules[modTrade], modTrade) + ' - ' + IntToStr(licUserCounts[ucTradeCounter]) + ' Users');
          OutF.Add ('                  Visual Report Writer         ' + licEntModRelToStr (licType, licModules[modVisualRW], modVisualRW));
          OutF.Add ('                  Works Order Processing       ' + licWOPDesc(licModules[modStdWOP], licModules[modProWOP]));
          OutF.Add ('');
        End; // If (licType <> 2)

        OutF.Add ('-------------------------------------------------------------------------------');
      End; { If }

      { Save to file }
      OutF.SaveToFile (DestLicenceDir + LicFile);

      Result := True;
    Finally
      OutF.Destroy;
    End;
  End; { WriteLicenceDets }

  Function WriteRandomBinary : Boolean;
  Var
    OutF     : TFileStream;
    I        : LongInt;
    RndByte  : Byte;
  Begin { WriteRandomBinary }
    Result := False;

    OutF := TFileStream.Create(DestLicenceDir + LicFile, fmOpenReadWrite);
    Try
      posBinary := OutF.Size;
      OutF.Position := posBinary;

      // MH 16/11/2012 v7.0: Moved Randomize to the initialization as this location might result
      // in the same text each time
      { init the random number generator based on system clock }
      //Randomize;

      { Generate Binary area }
      For I := 1 To ((2 * SizeOf (CDLicenceRecType)) + Random(400)) Do Begin
        RndByte := Random(256);
        OutF.Write (RndByte, SizeOf(RndByte));
      End; { If }

      Result := True;
    Finally
      OutF.Destroy;
    End;
  End; { WriteRandomBinary }

  Function WriteLicence : Boolean;
  Var
    OutF               : TFileStream;
    I, ChkSum, posData : LongInt;
    DataByte, CryptB   : Byte;
    EncLic             : CDLicenceRecType;
  Begin { WriteLicence }
    Result := False;

    OutF := TFileStream.Create(DestLicenceDir + LicFile, fmOpenReadWrite);
    Try
      { Write fixed format section }
      OutF.Position := posBinary;
      DataByte := Ord('A');    OutF.Write (DataByte, SizeOf(DataByte));  { Constant }
      DataByte := Ord('A');    OutF.Write (DataByte, SizeOf(DataByte));  { Checksum }
      CryptB   := Random(256); OutF.Write (CryptB,   SizeOf(CryptB));    { Crypto Key Byte }

      { Encode licence details }
      EncLic := LicenceInfo;
      EncLic.licCompany := ReverseString (EncLic.licCompany);
      EncLic.licSerialNo := ReverseString (EncLic.licSerialNo);
      ChangeCryptoKey (6370 + CryptB);
      EncodeData (@EncLic, SizeOf(EncLic));

      { Write licence details }
      OutF.Position := posBinary + 20;
      OutF.Write (EncLic, SizeOf(EncLic));

      { Write start/end positions of binary to end of file }
      posData := OutF.Size;
      OutF.Position := posData;
      DataByte := CurrLicVer;
      OutF.Write (DataByte,  SizeOf(DataByte));       { Licence Version }
      DataByte := 7;
      OutF.Write (DataByte,  SizeOf(DataByte));       { later replaced with checksum digit }
      OutF.Write (posBinary, SizeOf(posBinary));      { Start of binary section }

      { <-- Add future information here }

      OutF.Write (posData,   SizeOf(posData));        { Start of ExchQss.Dat }
      DataByte := Ord('Z');  OutF.Write (DataByte, SizeOf(DataByte));  { Constant }

      { Calculate file checksum }
      ChkSum := 0;
      OutF.Position := 1;
      For I := 1 To OutF.Size Do Begin
        OutF.Read (DataByte, SizeOf(DataByte));
        ChkSum := ChkSum + DataByte;
      End; { For }
      DataByte := ChkSum Mod 255;
      OutF.Position := posData + 1;
      OutF.Write (DataByte, SizeOf(DataByte));

      { Write checksum check digit }
      DataByte := NOT DataByte;
      OutF.Position := posBinary + 1;
      OutF.Write (DataByte, SizeOf(DataByte));

      Result := True;
    Finally
      OutF.Destroy;
    End;
  End; { WriteLicence }

  Function CheckLicDrive : Boolean;
  Var
    DriveInfo          : DriveInfoType;
    OK, Cancel         : Boolean;
    TStr               : ShortString;
    Res                : Word;
  begin { CheckLicDrive }
    Try
      Cancel := False;

      TStr := Trim(DestLicenceDir);
      If (TStr <> '') Then
        DriveInfo.drDrive := TStr[1]
      Else Begin
        { Current directory }
        TStr := GetCurrentDir;
        If (TStr <> '') Then
          DriveInfo.drDrive := TStr[1]
      End; { If }

      Repeat
        OK := GetDriveInfo(DriveInfo);

        If OK Then
          OK := DriveInfo.drGotVolInfo;

        If (Not OK) Then Begin
          { Warn User }
          Res := MessageDlg ('The destination drive is not ready, please correct this and click OK', mtConfirmation, [mbOK, mbCancel], 0);

          Cancel := (Res = mrCancel);
        End; { If }
      Until OK Or Cancel;

      Result := OK;
    Except
      Result := False;
    End;
  End; { CheckLicDrive }

Begin { WriteLicence }
  { Check drive to write licence to is OK }
  If CheckLicDrive Then Begin
    { Delete any existing Licence }
    OK := Not FileExists (DestLicenceDir + LicFile);
    If (Not OK) Then Begin
      { Delete file }
      OK := SysUtils.DeleteFile (DestLicenceDir + LicFile);

      If (Not OK) Then Begin
        { Cannot delete licence file }
        MessageDlg ('An error occured deleting an existing Licence File - Please remove it manually and retry',
                    mtError, [mbOk], 0);
      End; { If }
    End; { If }

    If OK Then Begin
      { Copy base text file in from Files directory }
      OK := FileExists (ConfigInfo.FileDir + WarnFile);
      If OK Then Begin
        OK := CopyWarnFile;
      End { If }
      Else Begin
        { Base warning file is missing }
        MessageDlg ('The warning file ' + WarnFile + ' is missing from the files directory',
                    mtError, [mbOk], 0);
      End; { Else }
    End; { If }

    If OK Then Begin
      { Open as text file and write licence info to header }
      OK := WriteLicenceDets;

      If (Not OK) Then Begin
        { Problem writing randam binary to file }
        MessageDlg ('A problem occured writing the Licence Details section to the licence',
                    mtError, [mbOk], 0);
      End; { If }
    End; { If }

    If OK Then Begin
      { Open as stream and write 10k of random binary crap to file }
      OK := WriteRandomBinary;

      If (Not OK) Then Begin
        { Problem writing randam binary to file }
        MessageDlg ('A problem occured writing the binary section to the licence',
                    mtError, [mbOk], 0);
      End; { If }
    End; { If }

    If OK Then Begin
      { Open as random-access stream and write licencing and security information }
      OK := WriteLicence;
    End; { If }

    If OK Then Begin
      { All finished }

      { Auto - View ? }

    End; { If }
  End { If }
  Else Begin
    { Error on destination drive }
    MessageDlg ('A problem occured on the destination drive',
                mtError, [mbOk], 0);
  End; { Else }
End; { WriteLicence }

Initialization
  Randomize;
end.
