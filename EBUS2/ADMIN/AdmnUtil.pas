unit AdmnUtil;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  EBusCnst, VarConst, Classes, Forms;

const
  CLIENT_ID_HEADER = 60;
  CLIENT_ID_LINE = 61;
  CLIENT_ID_LOCAL = 62;  // Use with ExLocal within ONE local routine

  // Message WParams
  EBUS_FORM_CLOSE = 800;
  EBUS_FORM_REFRESH = 801;
  EBUS_FORM_SHOWN = 802;

  // Hold posting options
  POST_HOLD_NONE = 0;
  POST_HOLD_HOLD = 1;
  POST_HOLD_WARN = 2;

  // Hold status bit values values stored in Inv.HoldFlg (byte)
  HOLD_STAT_NONE = 0;
  HOLD_STAT_HOLD = 1;   // 1st bit; on = hold, off = normal
  HOLD_STAT_WARN = 2;   // 2nd bit
  HOLD_STAT_ERROR = 4;  // 3rd bit

  // Form identifiers
  FORM_DAYBOOK = 1;
  FORM_TRANS = 2;
  FORM_TRANS_LINE_OK = 3;
  FORM_TRANS_LINE_CANCEL = 4;
  FORM_LOG_VIEW = 5;
  FORM_LOOKUP_DETAIL = 6;
  FORM_HTML_VIEW = 7;

  // Transaction codes
  EBUS_SOR = 'ESO';
  EBUS_SIN = 'ESI';
  EBUS_PIN = 'EPI';
  EBUS_POR = 'EPO';

  //PR 29/08/07 Added SCR & PCR
  EBUS_SCR = 'ESC';
  EBUS_PCR = 'EPC';

type
  TEBusProcess = (ebsImport, ebsPost);
  TCompElement = (cmpName, cmpPath, cmpDragNetCode);
  TLineTypeDesc = array[0..4] of shortstring;

  TCurCompSettings = class
    private
      fDailyRate : boolean;
      fCCDepEnabled : boolean;
      fMultiLocEnabled : boolean;
      fIntrastatEnabled : boolean;
      fPaperlessLoaded  : Boolean;
      fQuantityDP: byte;
      fPriceDP: byte;
      fCostDP: byte;
      fCompanyPath : ansistring;
      fCompanyName : shortstring;
      fCompanyCode : shortstring;
      fLineTypeDesc : TLineTypeDesc;
    public
      procedure SelectCompany(const CompCode : string; WantLogIn : Boolean = False);
      procedure ReadCompanyVAT;
      procedure ReadSettings;

      property MultiLocEnabled : boolean read fMultiLocEnabled;
      property CCDepEnabled : boolean read fCCDepEnabled;
      property IntraStatEnabled : boolean read fIntrastatEnabled;
      property QuantityDP : byte read fQuantityDP;
      property PriceDP : byte read fPriceDP;
      property CostDP : byte read fCostDP;
      property LineTypeDesc : TLineTypeDesc read fLineTypeDesc;
      property CompanyPath : ansistring read fCompanyPath;
      property CompanyCode : shortstring read fCompanyCode;
      property CompanyName : shortstring read fCompanyName;
      property DailyRate   : boolean read fDailyRate;
      property PaperlessLoaded : boolean read fPaperLessLoaded write fPaperLessLoaded;
  end;



var
  CurCompSettings : TCurCompSettings;
  FirstLogIn : Boolean;

// These routines open the files with the global Btrieve handles
function  OpenMiscFile(DisplayError : boolean) : integer;
procedure CloseMiscFile;
function  OpenEBusFile(DisplayError : boolean) : integer;
procedure CloseEBusFile;

function EbusDocTypeToExDocType(const eType : string) : string;

{$IFDEF EXTERNALIMPORT}
  function OpenEBusCompanyFile(FNum : integer; CompanyCode, CompanyPath : string; DisplayError : boolean) : integer;
{$ELSE}
  function OpenEBusCompanyFile(FNum : integer; CompanyCode : string; DisplayError : boolean) : integer;
{$ENDIF}

procedure CloseEBusCompanyFile(FNum : integer);

function  ConfirmRecordDelete(WhichRecords : string) : boolean;
procedure WarnRecordLocked;

function ToFixedDP(Value : double; DP : integer; CurrNum : integer = -1) : string;
function CalcLineVat(const FileLine: IDetail; SettleDiscPercent : double) : double;
// *** These functions were in use when the admin module was going to cover
// *** the set-up side of things.
function GetCompanyDescription(EntCompCode : string; Companies : PCompanies) : string;
function GetCompanyPath(EntCompCode : string; Companies : PCompanies) : string;
function CompanyBeenSetup(const CompCode : string) : boolean;
function InitialiseCompaniesRec(Companies : PCompanies;
           var NoCompanies : longint; ShowError : boolean = false) : integer; overload;
function InitialiseCompaniesRec(Companies : PCompanies) : integer; overload;
// *** ******************************************

function VATCodeToVATType(VATCode : char) : VATType;
function VATTypeToVATCode(v : VATType) : char;
function GetEBusDocName(DocType : string) : string;
function HoldStatusDescription(HoldStatus : byte; TagNo : Byte) : ShortString;
function LongDateToDateField(Date : string) : string;
function GetLineTotal(const FileLine: IDetail; UseLineDiscount : boolean;
           SettleDiscPercent : double) : double;
function IsPurchaseTransaction(const OurRef : string) : boolean;
function IntrastatAvailable(const TraderCode : string) : boolean;
procedure AssignVATItems(VATItems : TStrings; FullDescription : boolean);
procedure AssignCurrencyItems(CurrencyItems : TStrings; FullDescription : boolean);




{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  EBusUtil, BtrvU2, Dialogs, Controls, EBusBtrv, EBusVar, StrUtil,
  SysUtils, Crypto, LicRec, EntLic, UseDLLU, EBusLook, GlobVar,VarRec2U,
  UseTKit, TKitUtil, BTSupU1, TKUtil, LoginF, PasswordComplexityConst, CmpCtrlU, SQLUtils;

//-----------------------------------------------------------------------

const
  XDocTypes : Array[1..6, 1..2] of String[3] = ((EBUS_SOR, 'SOR'),
                                                (EBUS_POR, 'POR'),
                                                (EBUS_SIN, 'SIN'),
                                                (EBUS_PIN, 'PIN'),
                                                (EBUS_SCR, 'SCR'),
                                                (EBUS_PCR, 'PCR'));

function EbusDocTypeToExDocType(const eType : string) : string;
var
  i : integer;
begin
  Result := '';
  for i := 1 to 6 do
    if eType = XDocTypes[i, 1] then
    begin
      Result := XDocTypes[i, 2];
      Break;
    end;
end;


{$IFDEF EXTERNALIMPORT}
function OpenEBusCompanyFile(FNum : integer; CompanyCode, CompanyPath : string; DisplayError : boolean) : integer;
{$ELSE}
function OpenEBusCompanyFile(FNum : integer; CompanyCode : string; DisplayError : boolean) : integer;
{$ENDIF}
// Pre    : FNum = Btrieve file number constant
// Action : Opens a specific Btrieve file in a company's Ebus sub-directory
var
  FileName,
  SubDir,
  FileDesc : string;
begin
  case FNum of
    EBsL : begin
             FileName := LOOKUPS_FILENAME;
             FileDesc := 'Lookup';
           end;
    InvF : begin
             FileName := EBUS_DOCNAME;
             FileDesc := 'Transaction Header';
           end;
    IDetailF : begin
                 FileName := EBUS_DETAILNAME;
                 FileDesc := 'Transaction Lines';
               end;
    PwrdF  : begin
                 FileName := EBUS_NOTESNAME;
                 FileDesc := 'Notes';
             end;
  else
    begin
      Result := -1;
      exit;
    end;
  end;

  {$IFDEF EXTERNALIMPORT}
    SubDir := GetEBusSubDir(GetCompanyDirFromCode(CompanyCode, CompanyPath), FileName);
  {$ELSE}
    SubDir := GetEBusSubDir(GetCompanyDirFromCode(CompanyCode), FileName);
  {$ENDIF}

  Result := Open_File(F[FNum], SubDir, 0);
    if (Result <> 0) and DisplayError then
      MessageDlg(Format('Could not open E-Business %s data file.', [FileDesc]) + CRLF +
        'Directory : ' + SubDir + CRLF +
        'Company   : ' + CompanyCode + CRLF +
        'Error Code: ' + IntToStr(Result) + CRLF +
         Set_StatMes(Result), mtWarning, [mbOK], 0);
end;

//-----------------------------------------------------------------------

procedure CloseEBusCompanyFile(FNum : integer);
begin
  if FNum in [EBsL, InvF, IDetailF] then
    Close_File(F[FNum]);
end;

//-----------------------------------------------------------------------

function OpenEBusFile(DisplayError : boolean) : integer;
// Notes : The EBus file is in the main company directory
const
  FNum = EBsF;
var
  Dir : string;
begin
  Dir := GetMultiCompDir + FileNames[FNum];
  Result := Open_File(F[FNum], Dir, 0);
  if (Result <> 0) and DisplayError then
    MessageDlg('Could not open E-Business Module data file.' + CRLF +
      'Directory : ' + Dir + CRLF +
      'Error Code: ' + IntToStr(Result) + CRLF +
       Set_StatMes(Result), mtWarning, [mbOK], 0);
end; // OpenEBusFile

//-----------------------------------------------------------------------

procedure CloseEBusFile;
const
  FNum =  EBsF;
begin
  Close_File(F[FNum]);
end;

//-----------------------------------------------------------------------

function OpenMiscFile(DisplayError : boolean) : integer;
// Notes : Opens the Misc file in the main company directory
//         Used for storing window positions
const
  FNum = MiscF;
var
  Dir : string;
begin
//PR: 21/08/2012 ABSEXCH-12843 This was using a client id for MiscF, but was using the global array of file vars.
//consequently, when a lookup function checked if the file was open without a client id, it would think that is wasn't
//and would close the file for the global file var, resulting in it being closed for the client id as well.
//To fix this, I've changed all references to Miscf used by the postioning system to work without a client id - this prevents
//the lookups from closing miscf.

{  FillChar(MiscCID, SizeOf(MiscCID), 0);
  MiscCID.AppID[1] := 'E';
  MiscCID.AppID[2] := 'B';
  MiscCID.TaskID := 99;}

  //PR: 07/02/2013  ABSEXCH-13988 If using MS-SQL then use company data path rather than root company path.
  if not SQLUtils.UsingSQL then
    Dir := GetMultiCompDir + FileNames[FNum]
  else
    Dir := CurCompSettings.CompanyPath + FileNames[FNum];
  Result := Open_FileCID(F[FNum], Dir, 0, nil);
  if (Result <> 0) and DisplayError then
      MessageDlg('Could not open miscellaneous data file.' + CRLF +
      'Directory : ' + Dir + CRLF +
      'Error Code: ' + IntToStr(Result) + CRLF +
       Set_StatMes(Result), mtWarning, [mbOK], 0);
end;

//-----------------------------------------------------------------------

procedure CloseMiscFile;
const
  FNum = MiscF;
begin
  //PR: 21/08/2012 ABSEXCH-12843
  Close_FileCID(F[FNum], nil);
end;

//-----------------------------------------------------------------------

function ConfirmRecordDelete(WhichRecords : string) : boolean;
begin
  Result := MessageDlg('Please confirm you wish' + CRLF + 'to delete ' + WhichRecords +
    ' ?', mtConfirmation, [mbYes, mbNo] , 0) = mrYes;
end;

//-----------------------------------------------------------------------

procedure WarnRecordLocked;
begin
  MessageDlg('Sorry, this record is locked by another user', mtWarning, [mbOK], 0);
end;

//-----------------------------------------------------------------------

function InitialiseCompaniesRec(Companies : PCompanies;
           var NoCompanies : longint; ShowError : boolean = false) : integer; overload;
var
  MainEntDir : ansistring;
begin
  MainEntDir := GetMultiCompDir;
  NoCompanies := SizeOf(Companies^);
  // NoCompanies not set correctly if main Enterprise directory wrong - i.e. can't find
  Result := ExGetCompany(PChar(MainEntDir), Companies, NoCompanies);
  if Result <> 0 then
    MessageDlg(Format('Call to Ex_GetCompany returned code %d' + CRLF +
               'Search path is %s', [Result, MainEntDir]), mtError, [mbOK], 0);
end;

//-----------------------------------------------------------------------

function InitialiseCompaniesRec(Companies : PCompanies) : integer; overload;
var
  NoCompanies : longint;
begin
  Result := InitialiseCompaniesRec(Companies, NoCompanies);
end;

//-----------------------------------------------------------------------

function CompanyBeenSetup(const CompCode : string) : boolean;
// Pre  : CompCode = Enterprise Multi-company Company code
// Post : Returns true if the company has been set up in the E-Business Btrieve file
begin
  with TEBusBtrieveCompany.Create(true) do
  try
    OpenFile;
    CompanyCode := CompCode;
    Result := FindRecord = 0;
    CloseFile;
  finally
    Free;
  end;
end;

//-----------------------------------------------------------------------

function GetCompanyGeneric(EntCompCode : string; CompElement : TCompElement;
           Companies : PCompanies) : string;
var
  i,
  NoCompanies : integer;
begin
  Result := '';
  NoCompanies := SizeOf(Companies^) div SizeOf(TCompanyType);
  for i := 1 to NoCompanies do
    if Trim(Companies^[i].CompCode) = Trim(EntCompCode) then
      case CompElement of
        cmpPath :
          Result := Trim(Companies^[i].CompPath);
        cmpName :
          Result := Companies^[i].CompName;
      else
        Result := '';
      end;
end; // GetCompanyGeneric

//-----------------------------------------------------------------------

function GetCompanyDescription(EntCompCode : string; Companies : PCompanies) : string;
// Pre  : EntCompCode = Enterprise company code
//      : Companies = Pointer to allocated TCompanyType DLL record
// Post : Returns description of that company
begin
  Result := GetCompanyGeneric(EntCompCode, cmpName, Companies);
end; // GetCompanyDescription

//-----------------------------------------------------------------------

function GetCompanyPath(EntCompCode : string; Companies : PCompanies) : string;
// Pre  : EntCompCode = Enterprise company code
//      : Companies = Pointer to allocated TCompanyType DLL record
// Post : Returns path to that company
begin
  Result := GetCompanyGeneric(EntCompCode, cmpPath, Companies);
end;

//-----------------------------------------------------------------------

function ToFixedDP(Value : double; DP : integer; CurrNum : integer = -1) : string;
begin
  Result := FloatToStrF(Ex_RoundUp(Value, DP), ffFixed, 18, DP);
  if CurrNum <> - 1 then
    Result := GetCurrencySymbol(CurrNum) + Result;
end;

//-----------------------------------------------------------------------
function CalcLineVat(const FileLine: IDetail; SettleDiscPercent : double) : double;
var
  TLine : TBatchTLRec;
begin
  TransLineToTKitTransLine(FileLine, TLine);
  if Ex_CalcLineTax(@TLine, SizeOf(TLine), SettleDiscPercent) = 0 then
    Result := TLIne.VAT
  else
    Result := FileLine.VAT;
end;

function GetLineTotal(const FileLine: IDetail; UseLineDiscount : boolean;
  SettleDiscPercent : double) : double;
var
  TLine : TBatchTLRec;
begin
  TransLineToTKitTransLine(FileLine, TLine);
  Ex_GetLineTotal(@TLine, SizeOf(TLine), UseLineDiscount, SettleDiscPercent, Result);
end;

//-----------------------------------------------------------------------

function VATCodeToVATType(VATCode : char) : VATType;
begin
  case VATCode of
    'S' : Result := Standard;
    'E' : Result := Exempt;
    'Z' : Result := Zero;
    '1' : Result := Rate1;
    '2' : Result := Rate2;
    '3' : Result := Rate3;
    'A' : Result := Rate3;
    '4' : Result := Rate4;
    'D' : Result := Rate4;
    '5' : Result := Rate5;
    '6' : Result := Rate6;
    '7' : Result := Rate7;
    '8' : Result := Rate8;
    '9' : Result := Rate9;
    'T' : Result := Rate10;
    'X' : Result := Rate11;
    'B' : Result := Rate12;
    'C' : Result := Rate13;
    'F' : Result := Rate14;
    'G' : Result := Rate15;
    'R' : Result := Rate16;
    'W' : Result := Rate17;
    'Y' : Result := Rate18;
  else
    Result := Spare8;
  end;
end;

//-----------------------------------------------------------------------

function VATTypeToVATCode(v : VATType) : char;
var
  Posn : integer;
begin
  Posn := ord(v);
  if Posn <= MAX_VAT_INDEX then
    Result := VAT_CODES[Posn]
  else
    Result := #0;
end;

//-----------------------------------------------------------------------

function GetEBusDocName(DocType : string) : string;
// Pre  : DocType = 3 letter E-Business document code
// Post : Returns descriptive document name
begin
  Result := '';
  if DocType = EBUS_SOR then
    Result := 'Sales Order';
  if DocType = EBUS_SIN then
    Result := 'Sales Invoice';
  if DocType = EBUS_PIN then
    Result := 'Purchase Invoice';
  if DocType = EBUS_POR then
    Result := 'Purchase Order';
end;

//-----------------------------------------------------------------------

function HoldStatusDescription(HoldStatus : byte; TagNo : Byte) : ShortString;
var
  NoOfStats : Byte;
begin
{  if TagNo = 0 then
  begin
    Case HoldStatus of
      HOLD_STAT_HOLD   : Result := 'Hold';
      HOLD_STAT_WARN   : Result := 'Warning';
      HOLD_STAT_ERROR  : Result := 'Error!';
    end;
  end
  else}
  begin
    NoOfStats := 0;

    if HoldStatus and HOLD_STAT_HOLD = HOLD_STAT_HOLD then
      inc(NoOfStats);
    if HoldStatus and HOLD_STAT_WARN = HOLD_STAT_WARN then
      inc(NoOfStats);
    if HoldStatus and HOLD_STAT_ERROR = HOLD_STAT_ERROR then
      inc(NoOfStats);

    Result := '';

    if NoOfStats = 1 then
    begin
      if HoldStatus and HOLD_STAT_HOLD = HOLD_STAT_HOLD then
        Result := 'Hold/'
      else
      if HoldStatus and HOLD_STAT_WARN = HOLD_STAT_WARN then
        Result := 'Warning/'
      else
      if HoldStatus and HOLD_STAT_ERROR = HOLD_STAT_ERROR then
        Result := 'Error!/';
    end
    else
    begin
      if HoldStatus and HOLD_STAT_HOLD = HOLD_STAT_HOLD then
        Result := Result + 'H/';
      if HoldStatus and HOLD_STAT_WARN = HOLD_STAT_WARN then
        Result := Result + ' W/';
      if HoldStatus and HOLD_STAT_ERROR = HOLD_STAT_ERROR then
        Result := Result + ' Err/';
    end;

    if TagNo > 0 then
    begin
      if NoOfStats > 0 then
        Result := Result + ' T' + IntToStr(TagNo)
      else
        Result := Result + 'Tagged ' + IntToStr(TagNo);
    end;

    if Result[Length(Result)] = '/' then
      Delete(Result, Length(Result), 1);

  end;
end; // HoldStatusDescription

//-----------------------------------------------------------------------

function LongDateToDateField(Date : string) : string;
// Pre  : Date in format yyyymmdd
// Post : Date in format ddmmyyyy
begin
  Result := copy(Date, 7, 2) + copy(Date, 5, 2) + copy(Date, 1, 4);
end;

//-----------------------------------------------------------------------

function IsPurchaseTransaction(const OurRef : string) : boolean;
// Post : Returns true for purchase order, purchase invoice etc
var
  OurRefPrefix : string;
begin
  Result := false;
  OurRefPrefix := copy(OurRef, 1, 3);
  Result := (OurRefPrefix = EBUS_POR) or (OurRefPrefix = EBUS_PIN) or
    (OurRefPrefix = DocCodes[POR]) or (OurRefPrefix = DocCodes[PIN]);
end;

//-----------------------------------------------------------------------

function IntrastatAvailable(const TraderCode : string) : boolean;
// Post  : Returns true if intrastat details should be shown
// Notes : The trader must have the EC Member flag ticked
var
  TraderRec : TBatchCURec;
  SearchCode : array[0..255] of char;
begin
  Result := false;
  FillChar(TraderRec, SizeOf(TraderRec), 0);
  StrPCopy(SearchCode, TraderCode);
  if Ex_GetAccount(@TraderRec, SizeOf(TraderRec), SearchCode, 0, B_GetEq, 0, false) = 0 then
    Result := TraderRec.EECMember;
end;

//-----------------------------------------------------------------------

procedure AssignVATItems(VATItems : TStrings; FullDescription : boolean);
var
  Description : string;
  VATRec : TBatchVATRec;
  Status,
  i : integer;
begin
  for i := Low(VAT_CODES) to High(VAT_CODES) do
  begin
    VATRec.VATCode := VAT_CODES[i];
    Status := Ex_GetVATRate(@VATRec, SizeOf(VATRec));
    if Status = 0 then
      if FullDescription then
        Description := Format('%s - %s', [VATRec.VATCode, VATRec.VATDesc])
      else
        Description := VATRec.VATCode;
      VATItems.Add(Description);
  end;
end;

//-----------------------------------------------------------------------

procedure AssignCurrencyItems(CurrencyItems : TStrings; FullDescription : boolean);
var
  Description : string;
  CurrencyRec : TBatchCurrRec;
  CurrNum : integer;
begin
  // Ignore consolidated currency 0
  for CurrNum := 1 to MAX_CURRENCY_INDEX do
    if Ex_GetCurrency(@CurrencyRec, SizeOf(CurrencyRec), CurrNum) = 0 then
    begin
      Description := StringReplace(CurrencyRec.ScreenSymb, #156, '£', []);
      if FullDescription then
        Description := Description + ' - ' + CurrencyRec.Name;
      CurrencyItems.Add(Description);
    end;
end;

//=======================================================================
// TCurCompSettings

procedure TCurCompSettings.SelectCompany(const CompCode : string; WantLogIn : Boolean = False);
var
  Status : integer;
  Params : TEBusBtrieveParams;
  OldCompanyCode : string;

  function DoLogIn : Boolean;
  var
    lLoginFrm: TfrmLogin;
  begin
    Result := BOff;
    lLoginFrm := TfrmLogin.Create(Application);
    try
      with lLoginFrm do
      begin
        eBussCompanyPath := fCompanyPath;
        CompanyDrive := fCompanyPath;
        LoginDialog := ldeBusiness;
        InitDefaults; //Init Defaults values
        
        //SS:09/10/2017:2017-R2:ABSEXCH-19377:eBusiness > Menu Bar > Company Name should be changed on login screen when accessed from Menu bar.
        InitCompanyPath;

        //SS:09/10/2017:2017-R2:ABSEXCH-19377:eBusiness > Menu Bar > Company Name should be changed on login screen when accessed from Menu bar.
        //When company has changed below tables should be reopened.
        if( WantLogIn ) then
        begin
          Open_System(PwrdF, PwrdF);
          Open_System(MlocF, MLocF);
          Open_System(SysF, SysF);
        end;

        ShowModal;
        Result := ModalResult = mrOk;
        if (Result) and (LoggedInUserName <> 'SYSTEM') then
          ThisUser.UserName := LoggedInUserName;
      end; {with lLoginFrm do}
    finally
      FreeAndNil(lLoginFrm);
    end;
  end;

begin
  If PaperlessLoaded then  {* We have previosuly loaded the paperless module, so we need to unload it *}
  Begin
    PaperlessLoaded:=False;
    EX_ENDPRINTFORM;

  end;

  if not FirstLogin then
  begin
    Ex_CloseData;
    OldCompanyCode := fCompanyCode;
    fCompanyCode := Trim(CompCode);
    {$IFDEF EXTERNALIMPORT}
      fCompanyPath := GetCompanyDirFromCode(CompanyCode, CompanyPath);
    {$ELSE}
      fCompanyPath := GetCompanyDirFromCode(CompanyCode);
    {$ENDIF}
  end
  else
  begin
    fCompanyPath := SetDrive;
    fCompanyCode := CompanyCodeFromDir(fCompanyPath);
  end;


  if WantLogIn and not DoLogIn then
  begin
    if FirstLogIn then
    begin
 //     Application.Terminate;
      Halt;
    end
    else
    begin
      fCompanyCode := OldCompanyCode;
      {$IFDEF EXTERNALIMPORT}
        fCompanyPath := GetCompanyDirFromCode(CompanyCode, CompanyPath);
      {$ELSE}
        fCompanyPath := GetCompanyDirFromCode(CompanyCode);
      {$ENDIF}
    end;
  end;
  FirstLogIn := False;
  fCompanyName := GetCompanyNameFromCode(CompanyCode);
  Status := SetToolkitPath(CompanyPath);
  if Status <> 0 then
    ShowMessageFmt('TCurCompSettings.SelectCompany, SetToolkitPath returned : %d', [Status])
  else
  begin

    ebCompDir := CompanyPath;
    Status := Ex_InitDLL;
    if Status <> 0 then
      ShowMessageFmt('TCurCompSettings.SelectCompany, Ex_InitDLL returned : %d', [Status])
    else
    begin
      ReadSettings;
      // Update the default company parameter in EBus.dat
      Params := TEBusBtrieveParams.Create(true);
      with Params do
        try
          OpenFile;
          Status := FindRecord;
          if Status in [0, 4] then
          begin
            ParamsSettings.EntDefaultCompany := CompanyCode;
            if Status = 0 then
              UpdateRecord
            else
              AddRecord;
          end;
          CloseFile;
        finally
          Free;
        end;
      //PR: 07/02/2013 ABSEXCH-13988 Reopen misc file for this company (SQL Only)
      if SQLUtils.UsingSQL then
        OpenMiscFile(True);
    end;
  end;
end; // TCurCompSettings.SelectCompany

//-----------------------------------------------------------------------

procedure TCurCompSettings.ReadCompanyVAT;
var
  Lock : boolean;
  Status : integer;
begin
  Status := Open_File(F[SysF], CompanyPath + FileNames[SysF], 0);
  if Status = 0 then
  begin
    Lock := false;
    GetMultiSys(false, Lock, VATR);
    Close_File(F[SysF]);
  end;
end;

//-----------------------------------------------------------------------

procedure TCurCompSettings.ReadSettings;
// Notes : Assumes Toolkit is open for the correct company
var
  i : integer;
  Status : integer;
  SysData : TBatchSysRec;
begin
  Status := Ex_GetSysData(@SysData, SizeOf(SysData));
  if Status = 0 then
  begin
    fCCDepEnabled := SysData.CCDepts;
    fMultiLocEnabled := SysData.MultiLocn = 2;
    fIntraStatEnabled := SysData.IntraStat;
    fDailyRate := SysData.ExchangeRate ='V';
    fQuantityDP := SysData.QuantityDP;
    fPriceDP := SysData.PriceDP;
    fCostDP := SysData.CostDP;
    fLineTypeDesc[0] := 'Normal';

    PaperlessLoaded:=False;

    for i := 1 to 4 do
      fLineTypeDesc[i] := SysData.TransLineTypeLabel[i];

    // If calling Enterprise code the following need to be initialised also
    CurrentCountry := SysData.CurrentCountry;
    Syss.NoQtyDec := SysData.QuantityDP;
    Syss.NoCosDec := SysData.CostDP;
    Syss.NoNetDec := SysData.PriceDP;
    ReadCompanyVAT;
    Syss.EnableTTDDiscounts := SysData.TTDEnabled;
    Syss.EnableVBDDiscounts := SysData.VBDEnabled;
    Syss.Intrastat := fIntraStatEnabled;
  end
  else
    ShowMessageFmt('TCurCompSettings.ReadSettings, Ex_GetSysData returned : %d', [Status]);
end;

//-----------------------------------------------------------------------



initialization
  CurCompSettings := TCurCompSettings.Create ;
  FirstLogIn := True;

finalization
  CurCompSettings.Free;

end.


