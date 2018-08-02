unit MainF;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls, ShellAPI;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    Menu_File: TMenuItem;
    Menu_File_Exit: TMenuItem;
    Menu_Help: TMenuItem;
    Menu_Help_About: TMenuItem;
    Bevel1: TBevel;
    btnGenCDLic: TButton;
    btnViewCDLic: TButton;
    Menu_File_SepBar1: TMenuItem;
    Menu_File_GenCDLic: TMenuItem;
    Menu_File_ViewCDLic: TMenuItem;
    Utilities1: TMenuItem;
    ESNPasswordGenerator1: TMenuItem;
    EditExistingCDLicence1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    procedure Menu_File_ExitClick(Sender: TObject);
    procedure Menu_Help_AboutClick(Sender: TObject);
    procedure btnGenCDLicClick(Sender: TObject);
    procedure btnViewCDLicClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ESNPasswordGenerator1Click(Sender: TObject);
    procedure EditExistingCDLicence1Click(Sender: TObject);
  private
    { Private declarations }
    procedure CDLicenceWizard (Const AddMode : Boolean; Const DestLicenceDir : ShortString);
    procedure ViewLicence(Const LicenceDir : ShortString);
    procedure WriteCSV;
    procedure WritePSQLKey (Const DestLicenceDir : ShortString);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

Uses LicRec, LicVar, LicFuncU, lwType, lwCust, lwSerial, lwEntVer, lwClSvr,
     lwModule, lwConfrm, WriteLic, SerialU, ESNPW, StrUtil, History,
     lwWorkg, oLicence, ETStrU;


procedure TfrmMain.Menu_File_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.Menu_Help_AboutClick(Sender: TObject);
begin
  MessageDlg ('Exchequer CD Licence Utility' + #13 +
              'Build ' + CurrVer_CDGenLic + ' for Exchequer ' + EntVersions + #13#13 +
              // HM 02/01/03: Changed to use standard function
              //'Copyright Exchequer Software Ltd 1986-2002', mtInformation, [mbOk], 0);
              DoubleAmpers(GetCopyrightMessage), mtInformation, [mbOk], 0);
end;

procedure TfrmMain.CDLicenceWizard (Const AddMode : Boolean; Const DestLicenceDir : ShortString);
Var
  frmWiz1        : TfrmLicWiz1;      { Installation Type }
  frmWiz8        : TfrmLicWiz8;      { Customer Details }
  frmWiz6        : TfrmLicWiz6;      { CD Serial Number }
  frmWiz2        : TfrmLicWiz2;      { Enterprise Version }
  frmWiz7        : TfrmLicWiz7;      { Client-Server }
  frmWizWGE      : TfrmLicWorkgroup; { Workgroup Engine }
  frmWiz4        : TfrmLicWiz4;      { Enterprise Modules }
  frmWiz5        : TfrmLicWiz5;      { Confirm }
  WizNo, PrevWiz : Byte;
  Done, Aborted  : Boolean;
  FName, TmpPath : ANSIString;
  I              : SmallInt;
begin
  { Run the Licence Wizard }
  Done := False;
  Aborted := False;
  WizNo := Wiz_Start;
  PrevWiz := 0;

  ConfigInfo.AddMode := AddMode;

  frmWiz1   := Nil;
  frmWiz8   := Nil;
  frmWiz6   := Nil;
  frmWiz2   := Nil;
  frmWiz7   := Nil;
  frmWiz4   := Nil;
  frmWiz5   := Nil;
  frmWizWGE := NIL;

  Repeat
    Case WizNo Of
      { Installation Type }
      Wiz_Type     : LicWiz_InstType (frmWiz1, WizNo, PrevWiz, 0, Wiz_CustDets, Done, Aborted);

      { Customer Details }
      Wiz_CustDets : LicWiz_CustDets (frmWiz8, WizNo, PrevWiz, Wiz_Type, Wiz_Serial, Done, Aborted);

      { CD Serial Number }
      Wiz_Serial   : LicWiz_CDSerial (frmWiz6, WizNo, PrevWiz, Wiz_CustDets, Wiz_EntVer, Done, Aborted);

      { Enterprise Version }
      Wiz_EntVer   : LicWiz_EntVer (frmWiz2, WizNo, PrevWiz, Wiz_Serial, Wiz_ClServer, Done, Aborted);

      { Client-Server Version }
      Wiz_ClServer : LicWiz_ClServer (frmWiz7, WizNo, PrevWiz, Wiz_EntVer, Wiz_Workgroup, Done, Aborted);

      { Workgroup Engine }
      Wiz_Workgroup : LicWiz_WorkGroup (frmWizWGE, WizNo, PrevWiz, Wiz_ClServer, Wiz_Modules, Done, Aborted);

      { Modules }
      Wiz_Modules  : LicWiz_EntMods (frmWiz4, WizNo, PrevWiz, Wiz_Workgroup, Wiz_Confirm, Done, Aborted);

      { Confirm }
      Wiz_Confirm  : Begin
                       LicWiz_Confirm (frmWiz5, WizNo, PrevWiz, Wiz_Modules, 0, Done, Aborted);

                       If Done Then Begin
                         // Write CD Licence
                         WriteLicence (DestLicenceDir);

                         // Write/Delete P.SQL Licence Key Notification File
                         WritePSQLKey (DestLicenceDir);

                         If Not frmWiz5.chkSuppressLog.Checked Then
                           WriteCSV;

                         // Update WebRel
                         If frmWiz5.chkWebRel.Checked Then
                         Begin
                           // Create a temporary file containing the details in the Windows Temp directory
                           // Get Temp Path
                           SetLength(TmpPath, MAX_PATH);
                           I := GetTempPath(Length(TmpPath), PChar(TmpPath));
                           SetLength(TmpPath, I);
                           IncludeTrailingBackSlash(TmpPath);

                           // Calc Temp File in Temp Path
                           SetLength(FName, MAX_PATH + 1);
                           If (GetTempFileName(PChar(TmpPath), 'CDGEN', 0, PChar(FName)) <> 0) Then Begin
                             // Create temp file
                             With TStringList.Create Do
                               Try
                                 Add ('customer');
                                 Add (CDGenInfo.AccountCode + '~' +
                                      Trim(LicenceInfo.licCompany) + '~' +
                                      CDGenInfo.DealerCode + '~');

                                 SaveToFile (FName);
                               Finally
                                 Free;
                               End;

                             // execute WRTransmit to update WebRel
                             ShellExecute(Handle,                                 // Parent Window
                                          'open',                                 // Operation
                                          PChar(ExtractFilePath(Application.ExeName) + 'WRTransmit.exe'), // FileName
                                          PChar('/delete /f:' + FName),           // Params
                                          PChar(ExtractFilePath(Application.ExeName)),   // Default Dir
                                          SW_SHOWNORMAL);                         // Show

                           End { If (GetTempFileName... }
                           Else
                             ShowMessage ('Unable to update WebRel');
                         End; // If frmWiz5.chkWebRel.Checked
                       End; { If Done }
                     End;
    Else
      ShowMessage ('Invalid DlgNo: ' + IntToStr(WizNo));
      WizNo := Wiz_Type;
    End; { Case }
  Until Done or Aborted;

  { Free any created wizard forms }
  FreeAndNIL(frmWiz1);
  FreeAndNIL(frmWiz8);
  FreeAndNIL(frmWiz6);
  FreeAndNIL(frmWiz2);
  FreeAndNIL(frmWiz7);
  FreeAndNIL(frmWiz4);
  FreeAndNIL(frmWiz5);
  FreeAndNIL(frmWizWGE);

  If Done Then Begin
    { Automatically View Licence }
    //btnViewCDLicClick(Self);
    ViewLicence(DestLicenceDir);
  End; { If }
end;

//------------------------------

procedure TfrmMain.btnGenCDLicClick(Sender: TObject);
Begin
  licInitGlobToDefaults;
  CDLicenceWizard (True, ConfigInfo.LicenceDir);
End;

//------------------------------

procedure TfrmMain.EditExistingCDLicence1Click(Sender: TObject);
Var
  OrigDir, LicDir : ShortString;
  RunWizard : Boolean;
begin
  // Save current directory
  OrigDir := GetCurrentDir;
  Try
    If (OpenDialog1.InitialDir = '') Then
      OpenDialog1.InitialDir := ExtractFilePath(ConfigInfo.LicenceDir);

    RunWizard := OpenDialog1.Execute;
  Finally
    // Restore original current directory - otherwise it breaks files opened using relative paths
    SetCurrentDir(OrigDir);
  End; // Try..Finally

  If RunWizard Then
  Begin
    // Remember the selected directory for next time
    LicDir := ExtractFilePath(OpenDialog1.FileName);
    OpenDialog1.InitialDir := LicDir;     // NOTE: Removes trailing backslash so use LicDir

    // Copy existing licence into global licence record
    With TEntLicence.Create Do
      Try
        FileName := OpenDialog1.FileName;
        LicenceInfo := EncLic;
      Finally
        Free;
      End; // Try..Finally

    // Run the wizard in Edit mode
    CDLicenceWizard (False, LicDir);
  End; // If RunWizard
end;

//-------------------------------------------------------------------------

// Remove any unwanted Licence Key Files and create the wanted Licence Key File
procedure TfrmMain.WritePSQLKey (Const DestLicenceDir : ShortString);
Const
  CSName = 'CSLic.Txt';
  WGName = 'WGLic.Txt';
Var
  FName        : ShortString;
  DelCS, DelWG : Boolean;
Begin // WritePSQLKey
  // Look to see if either file is there to be removed
  DelCS := FileExists (DestLicenceDir + CSName);
  DelWG := FileExists (DestLicenceDir + WGName);

  // Decide which (if any) we want to create
  FName := '';
  If (LicenceInfo.licClServer > 0) Then
  Begin
    // Client-Server Engine
    FName := CSName;
    DelCS := False;
  End // If (LicenceInfo.licClServer > 0)
  Else
    If (LicenceInfo.licPSQLWGEVer > 0) Then
    Begin
      // Workgroup Engine is Licenced
      FName := WGName;
      DelWG := False;
    End; // If (LicenceInfo.licPSQLWGEVer > 0)

  // Create licence key file
  If (Trim(FName) <> '') Then
    With TStringList.Create Do
      Try
        Add (LicenceInfo.licPSQLLicKey);
        SaveToFile (DestLicenceDir + FName);
      Finally
        Free;
      End;

  // Remove unwanted licence files
  If DelCS Then DeleteFile (DestLicenceDir + CSName);
  If DelWG Then DeleteFile (DestLicenceDir + WGName);
End; // WritePSQLKey

//-------------------------------------------------------------------------

procedure TfrmMain.ViewLicence(Const LicenceDir : ShortString);
Var
  cmdFile, cmdPath, cmdParams : PChar;
  Flags                       : SmallInt;
Begin
  { Build access string for .INI file }
  cmdFile   := StrAlloc(255);
  cmdPath   := StrAlloc(255);
  cmdParams := StrAlloc(255);

  StrPCopy (cmdFile,   'ENTVWLIC.EXE');
  StrPCopy (cmdParams, LicenceDir + LicFile);
  StrPCopy (cmdPath,   ExtractFilePath(Application.ExeName));

  Flags := SW_SHOWNORMAL;

  ShellExecute (Application.MainForm.Handle, NIL, cmdFile, cmdParams, cmdPath, Flags);

  StrDispose(cmdFile);
  StrDispose(cmdPath);
  StrDispose(cmdParams);
end;

//------------------------------

procedure TfrmMain.btnViewCDLicClick(Sender: TObject);
begin
  ViewLicence (ConfigInfo.LicenceDir);
end;

//-------------------------------------------------------------------------

procedure TfrmMain.WriteCSV;
Var
  TextF      : TFileStream;
  {CSVF       : TStringList;}
  CSVStr     : ANSIString;
  I          : SmallInt;
  Fini       : Byte;
  OpenFlags  : Word;

  Function ModRelToStr (Const ModRel : Byte) : ShortString;
  Begin
    Case ModRel Of
      0 : Result := '';
      1 : Result := '30-Day';
      2 : Result := 'Full';
    Else
      Result := '?';
    End; { Case }
  End;

  Function licLicTypeStr (Const LicType : Byte) : ShortString;
  Begin { licLicTypeStr }
    Case LicType Of
      { Customer / End-User }
      0 : Result := '';
      { Demo / Reseller }
      1 : Result := 'Demo ';
      { Demo CD }
      2 : Result := 'Demo ';
    End; { Case LicType }
  End; { licLicTypeStr }

  Function WinUserName : ShortString;
  Var
    pSysInfo  : PChar;
    StrLength : DWord;
  Begin { WinUserName }
    StrLength := 100;
    pSysInfo := StrAlloc (StrLength);

    GetUserName (pSysInfo, StrLength);

    Result := pSysInfo;

    StrDispose (pSysInfo);
  End; { WinUserName }

  { Calculates the current time in seconds }
  Function xoCurrentTime : Double;
  Var
    wHour, wMin, wSec, wMSec  : Word;
    lHour, lMin, lSec, lMSec : LongInt;
  begin
    Result := 0;

    Try
      { Get current time }
      DecodeTime(Now, wHour, wMin, wSec, wMSec);

      { Copy fields into longs to force compiler to work in LongInt mode  }
      { otherwise you can get Range Check Errors as it works in Word mode }
      lHour := wHour;
      lMin  := wMin;
      lSec  := wSec;
      lMSec := wMSec;

      { Calculate number of seconds since midbnight }
      Result := (lSec + (60 * (lMin + (lHour * 60)))) + (lMSec * 0.001);
    Except
      On Ex: Exception Do
        MessageDlg ('The following exception occurred in xoCurrentTime: ' +
                    #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);
    End;
  End;


  Procedure xoWaitForSecs (Const Secs : Double);
  Var
    stTime, fiTime, cuTime : Double;
  Begin
    Try
      { Get start time - this is used to detect the time wrapping around at midnight }
      stTime := xoCurrentTime;

      { Calculate end time }
      fiTime := stTime + Secs;

      Repeat
        { Let other apps do something }
        Application.ProcessMessages;

        { Get time again }
        cuTime := xoCurrentTime;

        { Exit loop if time has wrapped around or wait period has expired }
      Until (cuTime < stTime) Or (cuTime > fiTime);
    Except
      On Ex: Exception Do
        MessageDlg ('The following exception occurred in xoWaitForSecs: ' +
                    #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);
    End;
  End;


Begin { WriteCSV }
  Try
    (*  HM 29/08/00: Rewrote to avoid sharing errors and corruption which DL reported
    CSVF := TStringList.Create;
    Try
      With CSVF Do Begin
        If FileExists (ExtractFilePath(Application.ExeName) + 'LicLog.CSV') Then Begin
          LoadFromFile(ExtractFilePath(Application.ExeName) + 'LicLog.CSV')
        End; { If }

        Add(CSVStr);

        SaveToFile(ExtractFilePath(Application.ExeName) + 'LicLog.CSV')
      End; { With }
    Finally
      CSVF.Free;
    End;
    *)

    With LicenceInfo Do Begin
      { Build CSV string }
      CSVStr := '"' + CDGenInfo.AccountCode + '",' +
                '"' + licCompany + '",' +
                '"' + licSerialNo + '",' +
                '"' + ISNByteToStr (licESN, licSerialNo) + '",' +
                '"' + ESN2ByteToStr (licESN2) + '",' +
                '"' + licDealer + '",' +
                '"' + CDGenInfo.DealerCode + '",' +
                '"' + CDGenInfo.VersionStr + '",' +
                // MH 03/12/2014 ABSEXCH-15897: Extended details written to LicLog.csv to include the database type
                '"' + licCDEntVersion (LicenceInfo) + '/' + licDBToStr(licEntDB, True) + '",' +
                '"';

      // P.SQL Client-Server/Workgroup Engine Licencing
      If (licClServer > 0) Then
        CSVStr := CSVStr + licCSEngStr (licClServer, True) + '/' + IntToStr(licCSUserCnt)
      Else
        If (licPSQLWGEVer > 0) Then
          CSVStr := CSVStr + 'WGE ' + licPSQLWGEVerToStr(licPSQLWGEVer);
      CSVStr := CSVStr + '","';
      If (licClServer > 0) Or (licPSQLWGEVer > 0) Then
        CSVStr := CSVStr + Trim(licPSQLLicKey);

      // Company Count
      CSVStr := CSVStr + '",' + IntToStr(licUserCounts[ucCompanies]) + ',';

      // Optional Modules
      CSVStr := CSVStr + '"' + ModRelToStr (licModules[modAccStk]) + '",' +
                         '"' + ModRelToStr (licModules[modImpMod]) + '",' +
                         '"' + ModRelToStr (licModules[modJobCost]) + '",' +
                         '"' + ModRelToStr (licModules[modCISRCT]) + '",' +
                         '"' + ModRelToStr (licModules[modAppVal]) + '",' +
                         '"' + ModRelToStr (licModules[modODBC]) + '",' +
                         '"' + ModRelToStr (licModules[modRepWrt]) + '",' +
                         '"' + ModRelToStr (licModules[modTeleSale]) + '",' +
                         '"' + ModRelToStr (licModules[modToolDLL]) + '",' +
                         '"' + ModRelToStr (licModules[modToolDLLR]) + Format(' (%d/%d)",', [licUserCounts[ucToolkit30], licUserCounts[ucToolkitFull]]) +
                         '"' + ModRelToStr (licModules[modEBus]) + '",' +
                         '"' + ModRelToStr (licModules[modPaperless]) + '",' +
                         '"' + ModRelToStr (licModules[modOLESave]) + '",' +
                         '"' + ModRelToStr (licModules[modCommit]) + '",' +
                         '"' + ModRelToStr (licModules[modTrade]) + Format(' (%d)",', [licUserCounts[ucTradeCounter]]) +
                         '"' + ModRelToStr (licModules[modStdWOP]) + '",' +
                         '"' + ModRelToStr (licModules[modProWOP]) + '",' +
                         '"' + ModRelToStr (licModules[modElerts]) + Format(' (%d)",', [licUserCounts[ucElerts]]) +
                         '"' + ModRelToStr (licModules[modEnhSec]) + '",' +
                         '"' + ModRelToStr (licModules[modFullStock]) + '",' +
                         '"' + ModRelToStr (licModules[modVisualRW]) + '",' +
                         '"' + ModRelToStr (licModules[modGoodsRet]) + '",' +
                         IntToStr(licAutoUpgIssue) + ',' +
                         '"' + FormatDateTime ('YYYY/MM/DD HH:MM', Now) + '",' +
                         '"' + licCountryStr (licCountry, True) + ' ' + licLicTypeStr (licLicType) + licTypeToStr (licType) + '",' +
                         '"';  { Backdoors }
      If licResetModRels Then
        CSVStr := CSVStr + '1';
      If licResetCountry Then
        CSVStr := CSVStr + '2';
      CSVStr := CSVStr + '","' + WinUserName + '","' + ModRelToStr (licModules[modEBanking]) + '"';
      CSVStr := CSVStr + ',"' + ModRelToStr (licModules[modOutlookDD]) + '"';

      // MH 19/11/2012 v7.0: Added support for Small Business Edition
      CSVStr := CSVStr + ',"' + licExchequerEditionToStr (licExchequerEdition) + '"';

      // MH 16/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
      CSVStr := CSVStr + ',"' + ModRelToStr (licModules[modGDPR]) + '","' +
                                ModRelToStr (licModules[modPervEncrypt]) + '"';
    End; { With }


    Fini := 0;
    Repeat
      Try
        If FileExists(ExtractFilePath(Application.ExeName) + 'LicLog.CSV') Then
          OpenFlags := fmOpenReadWrite Or fmShareExclusive
        Else
          OpenFlags := fmCreate Or fmShareExclusive;

        TextF := TFileStream.Create (ExtractFilePath(Application.ExeName) + 'LicLog.CSV',
                                     OpenFlags);
      Except
        On Exception Do
          TextF := Nil;
      End;

      If Assigned(TextF) Then Begin
        // Move To end of file
        TextF.Position := TextF.Size;

        // Write CSV Text to file with CRLF to terminate line
        CSVStr := CSVStr + #13#10;
        TextF.Write (Pointer(CSVStr)^, Length(CSVStr));

        FreeAndNIL(TextF);
        Fini := 6;
      End { If Assigned(TextF) }
      Else Begin
        Inc (Fini);

        If (Fini > 5) Then Begin
          // Ask if users wants to retry
          If (MessageDlg ('Someone else is using the log, the licence details cannot be written', mtWarning, [mbRetry, mbCancel], 0) = mrRetry) Then
            Fini := 0;
        End { If }
        Else
          // Wait 1 second
          xoWaitForSecs (1);
      End; { Else }
    Until (Fini > 5);
  Except
    On Ex:Exception Do
      MessageDlg ('The following error occured logging this licence in the CSV File:-' + #13#13 +
                  Ex.Message, mtInformation, [mbOk], 0);
  End;
End; { WriteCSV }

{--------------------------------------------------------------------------}

Procedure ChkOK;
Var
  SNo : String;
Begin { ChkOK }
  { Check its a valid serial number }
//  SNo := GetDriveSerial('C');
//  If (Sno <> '0E30-140C') And         // Derrick Lambert - HP Work Machine
//     (Sno <> '5C12-479E') And         // Eduardo Notebook
//     (Sno <> '5053-B48F') Then Begin  // James Waygood
    { Invalid Serial Number - Check running from develop directory or cosher licence directory}
    If (UpperCase(ExtractFilePath(Application.ExeName)) <> 'W:\ENTRPRSE\LICENCE\TEST\') And
       (UpperCase(ExtractFilePath(Application.ExeName)) <> 'H:\ADMIN\LIC2018R1\') Then
      Halt;
//  End; { If }
End; { ChkOK }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  { Try to load default saved position }
  licLoadCoords(TForm(Self));
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Save positions into ini file }
  licSaveCoords (Self);
end;

procedure TfrmMain.ESNPasswordGenerator1Click(Sender: TObject);
begin
  With TfrmESNPasswords.Create(Self) Do
    Try
      ShowModal;
    Finally
      Free;
    End;
end;


Initialization
//ShowMessage ('CDLicenceRecType: ' + IntToStr(SizeOf(CDLicenceRecType)));
//ShowMessage ('EntLicenceRecType: ' + IntToStr(SizeOf(EntLicenceRecType)));

  ChkOK;

  { Check it is not NT 3.51 }
  If CheckOSVer (4) Then Begin
    Application.MessageBox ('This utility cannot be used under NT 3.51 and will be stopped', 'Error', MB_ICONSTOP);
    Application.Terminate;
  End; { If }
end.


