unit KPICommon;

interface

uses Controls, StdCtrls, Windows, Graphics, SysUtils, AdvPanel, Classes, BlowFish, Dialogs, AdvCombo, Messages,
     Enterprise01_TLB, CTKUtil;

type
  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
  end;{with}

  TReportRec = Record
    cNodeType : WideChar;
    sCode : string;
    sName : string;
    sFileName : string;
    sLastRun : string;
    bAllowEdit : boolean;
  end;

  TReportInfo = Class
    ReportRec : TReportRec;
  end;

function  DecryptIniFile(AIniFileName: string; ToStream: boolean): TMemoryStream;
procedure EncryptIniFile(AIniFileName: string);
function  EnterToTab(Key: char; handle: HWND): char;
procedure ShowDLLDetails(AnObject: TObject; BGColor: TColor; UseBGColor: boolean);
function  ValidLogin(ADataPath: string; AUserName: string; APassword: string): boolean;

// CJS 2013-11-04 - MRD2.6.43 - Support for Transaction Originator
function GetOriginatorHint(oTransaction: ITransaction11): string;

var
  KPIHostPath: WideString;
  KPIHostVersion: WideString;
  KPIPluginPath: array[0..MAX_PATH] of char;
  KPIUserID: ShortString;

implementation

uses ETDateU;

const
  KPIPluginVersion = 'v7.0.8.046';

// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// v7.0.046 CS  03/12/2013  MRD1.1.46 - Added support for Consumer Ledger
// -----------------------------------------------------------------------------
// v7.0.045 CS  04/11/2013  MRD2.6.43 - Added support for Transaction Originator
// -----------------------------------------------------------------------------
// v7.0.044 CS  02/11/2012  ABSEXCH-13657 - Goods and VAT on Transaction Footer
//                          are the wrong way around
// -----------------------------------------------------------------------------
// v7.0.043 CS  12/10/2012  ABSEXCH-13569 - VAT Code list on Transaction Lines
// -----------------------------------------------------------------------------
// v7.0.042 CS  06/09/2012  ABSEXCH-13369 - Timesheet Entry Form size
//                          ABSEXCH-13379 - UDF Labels on Timesheet Entry Lines
// -----------------------------------------------------------------------------
// v7.0.041 CS  30/08/2012  ABSEXCH-12450 - Support for UDFs 5-10
// -----------------------------------------------------------------------------
// v7.0.040 CS  17/08/2012  ABSEXCH-13304 - Fixed problem with redisplay of
//                          Transaction form.
// -----------------------------------------------------------------------------
// v7.0.039 CS  07/08/2012  ABSEXCH-2449 - Authoris-e not showing POR's. Added
//                          Added Transaction form and Transaction Line form
// -----------------------------------------------------------------------------
// v6.5.038 CS  13/01/2011  Prevented VAT-Inclusive 'Today' totals in the
//                          Daybook Totals from doubling-up.
// -----------------------------------------------------------------------------
// 6.4.037  CS  07/01/2011  Further corrections to calculation and recalculation
//                          of Daybook Totals -- corrected Total and TodayIncVAT
// -----------------------------------------------------------------------------
// 6.4.035  CS  08/11/2010  Further corrections to calculation and recalculation
//                          of Daybook Totals.
// -----------------------------------------------------------------------------
// 6.4.034  CS  08/11/2010  Further corrections to calculation and recalculation
//                          of Daybook Totals.
// -----------------------------------------------------------------------------
// 6.4.033  CS  08/11/2010  Corrected calculation and recalculation of Daybook
//                          Totals.
// -----------------------------------------------------------------------------
// 6.3.031  CS  07/04/2009  Replaced custom security class with a call to the
//                          standard security com object, so that the new
//                          encrypted security password is used.
// -----------------------------------------------------------------------------

function DecryptIniFile(AIniFileName: string; ToStream: boolean): TMemoryStream;
// 1. Reads the encrypted ini file into the input stream,
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
  if not FileExists(AIniFileName) then exit;
try
  BlowFish := TBlowFish.Create(nil);
  try
    BlowFish.CipherMode := ECB;
//    BlowFish.LoadIVString('F2ABC392'); // only for CBC, CFB and OFB cipher modes
//    BlowFish.InitialiseString('8F3319');
    BlowFish.InitialiseString('050242617A7A612021030604'); // a  seemingly random sequence of ascii Hex codes

    MSI := TMemoryStream.Create;
    MSO := TMemoryStream.Create;
    try
      MSI.LoadFromFile(AIniFileName); // load the file into the stream
      MSI.Seek(0, soFromBeginning);   // ReadBuffer operates from the current position so back up
      MSI.ReadBuffer(StreamKey, SizeOf(StreamKey));  // read the first few characters
      MSI.Seek(0, soFromBeginning);   // Back up again
      result := MSI;  // set the result to the input stream in case it's not encrypted and ToStream=True
      if StreamKey = '[' then exit; // file isn't encrypted

      BlowFish.DecStream(MSI, MSO);   // decrypt input stream to output stream
      MSO.Seek(0, soFromBeginning);   // go to start of output stream
      MSO.ReadBuffer(StreamKey, SizeOf(StreamKey));  // read the first few characters
      if StreamKey <> '[' then // Check that it decrypted ok before overwriting file
        raise exception.Create('Cannot read ' + AIniFileName);
      MSO.Seek(0, soFromBeginning);   // go to start of output stream for caller to use
      result := MSO;
      if not ToStream then
        MSO.SaveToFile(AIniFileName);   // save the decrypted file back to disk ready for TBigIni to read or write
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
  ShowMessage(e.Message + ' while reading ' + AIniFileName);
end;
end;

procedure EncryptIniFile(AIniFileName: string);
// 1. Reads the plain ini file into the input stream,
// 2. Encrypts the input stream to the output stream,
// 3. Writes the encrypted output stream back to the ini file.
// The ini file should always start with a section.
// Knowing this, we can check for a valid encryption before overwriting the file.
// Also, if Importer crashes, e.g. with a BTrieve conflict, it can leave the settings
// file in the wrong state. The integrity checks ensure that the file doesn't become
// corrupted by encrypting an already encrypted file.
// DO NOT CHANGE THE INITIALISE STRING !
const
  CryptKey: string[9] = chr($7A) + chr($A4) + chr($97) + chr($09) + chr($0C) + chr($55) + chr($3B) + chr($D1) + chr($16);
var
  BlowFish: TBlowFish;
  MSI, MSO: TMemoryStream;
  StreamKey: char;
begin
  if not FileExists(AIniFileName) then exit;
try
  BlowFish := TBlowFish.Create(nil);
  try
    BlowFish.CipherMode := ECB;
//    BlowFish.LoadIVString('F2ABC392');  // only for CBC, CFB and OFB cipher modes
//    BlowFish.InitialiseString('8F3319');
    BlowFish.InitialiseString('050242617A7A612021030604'); // a seemingly random sequence of ascii Hex codes

    MSI := TMemoryStream.Create;
    MSO := TMemoryStream.Create;
    try
      MSI.LoadFromFile(AIniFileName); // load the file into the input stream
      MSI.Seek(0, soFromBeginning);   // ReadBuffer operates from the current position so back up
      MSI.ReadBuffer(StreamKey, SizeOf(StreamKey));   // read the first few characters
      if StreamKey <> '[' then exit; // it's already encrypted

      MSI.Seek(0, soFromBeginning);   // back to top again
      BlowFish.EncStream(MSI, MSO);   // encrypt the input stream to the output stream
      MSO.Seek(0, soFromBeginning);   // back to the start of the output stream
      MSO.ReadBuffer(StreamKey, SizeOf(StreamKey));   // read the first few characters

      if StreamKey = '[' then   // check that it encrypted ok before overwriting file
        raise exception.Create('Cannot write ' + AIniFileName);
      MSO.SaveToFile(AIniFileName);   // save the encrypted file over the top of the original disk file
                                      // but only now we know the contents are valid
    finally
      MSI.Free;
      MSO.Free;
    end;

    BlowFish.Burn;
  finally
    BlowFish.Free;
  end;
except on e:exception do
  ShowMessage(e.Message + ' while writing ' + AIniFileName);
end;
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

function ValidLogin(ADataPath: string; AUserName: string; APassword: string): boolean;
var
  Toolkit: IToolkit;
  FuncRes: Integer;
begin
  result := false;
  Toolkit := OpenToolkit(ADataPath, true);            // use the backdoor
  if not assigned(Toolkit) then
    ShowMessage('Couldn''t open the COM Toolkit')
  else
  try
    FuncRes := Toolkit.Functions.entCheckPassword(AUserName, APassword);
    Result := (FuncRes = 0);
    if Result then
    begin
//      ShowMessage('Logged in as ' + AUserName);
      KPIUserID := AUserName;
    end
    else
    begin
      ShowMessage('Unable to login as user ' + AUserName + ', error ' + IntToStr(FuncRes));
      KPIUserID := '';
    end;
  finally
    Toolkit.CloseToolkit;
  end;
end;

procedure ShowDLLDetails(AnObject: TObject; BGColor: TColor; UseBGColor: boolean);
const
  Def_BGColor = $00E4AE88;
  FGColor = clNavy;
begin
  GetModuleFileName(hInstance, KPIPluginPath, SizeOf(KPIPluginPath));

  with TLabel.Create(TControl(AnObject)) do begin
    Caption      := KPIHostVersion + ' ' + LowerCase(KPIHostPath);
    Parent       := TWinControl(AnObject);
    if UseBGColor then Color := BGColor else Color := Def_BGColor;
    Font.Color   := FGColor;
    Left         := 8;
    Top          := TControl(AnObject).Height - (Height * 2);
  end;

  with TLabel.Create(TControl(AnObject)) do begin
    Caption      := KPIPluginVersion + ' ' + LowerCase(KPIPluginPath);
    Parent       := TWinControl(AnObject);
    if UseBGColor then Color := BGColor else Color := Def_BGColor;
    Font.Color   := FGColor;
    Left         := 8;
    Top          := TControl(AnObject).Height - (Height * 1);
  end;
end;

// CJS 2013-11-04 - MRD2.6.43 - Support for Transaction Originator
function GetFormattedTime(TimeStr: string; IncludeSeconds: Boolean): string;
// Returns TimeStr converted to the format 'HH:MM' (or 'HH:MM:SS' if
// IncludeSeconds is True. TimeStr is expected to be in the format 'HHMM' or
// 'HHMMSS'.
var
  Hours: string;
  Minutes: string;
  Seconds: string;
begin
  Hours := Copy(TimeStr, 1, 2);
  if (Trim(Hours) = '') then
   Hours := '00';

  Minutes := Copy(TimeStr, 3, 2);
  if (Trim(Minutes) = '') then
    Minutes := '00';

  Result := Hours + ':' + Minutes;

  if IncludeSeconds then
  begin
    Seconds := Copy(TimeStr, 5, 2);
    if (Trim(Seconds) = '') then
      Seconds := '00';

    Result := Result + ':' + Seconds;
  end;
end;

function GetOriginatorHint(oTransaction: ITransaction11): string;
begin
  Result := 'Added by ' + oTransaction.thOriginator + ' on ' +
            POutDate(oTransaction.thCreationDate) + ' at ' +
            GetFormattedTime(oTransaction.thCreationTime, False);
end;

end.
