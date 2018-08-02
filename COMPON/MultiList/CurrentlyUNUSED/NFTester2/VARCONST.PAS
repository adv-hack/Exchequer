unit VarConst;
{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface
{$H-}
{$REALCOMPATIBILITY ON}
uses
  Graphics, WinTypes, GlobVar, BtrvU2, Messages, APIUtil, StrUtil;
{const
  Ver            :  ShortString = '/CS ';}

{$I ExchDll.Inc}        {* Record Structure File *}

type

  TBalanceRec = Record
    Balance : integer;
    Score : Byte;
  end;{TBalanceRec}

  TLoginMode = (lmNone, lmOperator, lmMaster, lmUser, lmDebug);
  DrCrType = Array[False..True] of Real;   { Debit(+) Credit(-) }

const
  WincardVersion = 'v5.50.090';

  bgVerifySends = TRUE;

  igDefaultRetries = 2;
  sgLogFile = 'commslog.txt';

  MP2StartTrack4Mb = 101;
  MP2StartTrack = 11;

  sTechSupportLogFile = 'CARDLOG.DAT';
  sDuffTillLogFile = 'TILLCARD.LOG';

  hsOverLimit = 1;
  hsExpired = 2;
  hsOnHold = 3;
  hsAllowedCredit = 4;
  hsSuspended = 5;

  NoOfFuncCats = 5;
  FuncKey = #250 + #250 + #250 + #250 + #250 + #250;

  MainBillSplitK = #251 + #251 + #251 + #251 + #251 + #251;
  BillSplitCreditKey = #252 + #252 + #252 + #252 + #252 + #252;

  WM_InPrint = WM_USER + $103;
  // Version Number
  {$I VerModu.Pas}

  // Import directory paths and filenames }
  {$I FilePath.Inc}

  {Card Status Constants}
  sOverLimit = 'Over Limit';
  sExpired = 'Expired';
  sSuspended = 'Suspended';

  // Invoice Description Constants
  InvDescEOY = 'End of Year reset';
  InvDescEOP = 'End of Period reset';

  // Command-Line Switches
  CSTillSwitch    = 'AUTO_TILL';
  LiveSwitch      = 'LIVE_ON';
  ECRCom19200     = '/ECR19200'; { Use 19200 baud to talk to till }
  ECRCom1Flag     = '/COM1';
  ECRCom2Flag     = '/COM2';
  ECRCom3Flag     = '/COM3';
  ECRCom4Flag     = '/COM4';
  ECRTillFlag     = '/TILL:';
  ECRTillMP2      = 'MP2';
  ECRTillMP3      = 'MP3';
  TillType_MP2    = 0;
  TillType_MP3    = 1;
  AutoEODReps    = 'AutoEOD.Spl';
  { == Ex Start Numbering All ExFiles from last Normal File +1 ==}

  NOM_CARD = 5;
  NOM_CASH = 1;
  NOM_CORRECTION = 3;
  NOM_FORFEIT = 4;
  NOM_DISCOUNT = 6;
  NOM_TILL_DEPOSIT = 7;
  NOM_SALES = 8;

  FIRST_ISSUE_NUMBER = 11;

{ ============= Customer Record ============== }

  {$I VARREC.INC}

const
//  StoredClerkDataTypes = [1,4,10,11,9];
  StoredClerkDataTypes = [1,4,10,11,9,17]; {0.63}

  ReceiptSet     =  [NMT,SRI];      { Differentiate betwix Reciept & Payment }
{  Nom_Cash         = 1;
  Nom_Renewals     = 2;
  Nom_Corrections  = 3;
  Nom_Forfeits     = 4;
  Nom_CardAccount  = 5;
  Nom_Discounts    = 6;
  Nom_TillDeposits = 7;}


  TradeCode      :  Array[False..True] of Char       = ('Z','C');

  NoPayTypes     =  4;

  PAYTYPE_CASH = 'A';
  PAYTYPE_RENEWAL = 'R';
  PAYTYPE_CORRECTION = 'C';
  PAYTYPE_FORFEIT = 'F';
  TYPE_FUNCTION_BOOKING = 'B';

  PayTypes       :  Array[1..NoPayTypes] of Char = (PAYTYPE_CASH, PAYTYPE_RENEWAL
                                                  , PAYTYPE_CORRECTION, PAYTYPE_FORFEIT);


{  PayTypes       :  Array[1..NoPayTypes] of Char = ('A','R','C','F');

                                           {         ^   ^   ^   ^
                                                     |   |   |   |-Forfeit
                                                     |   |   |-Credit Card
                                                     |   |-Renewal
                                                     |-Cash                }
                                                     
  IncxDocHed : Array[DocTypes] of Integer    =
                                   (  1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
                                      1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,   -1,    1,    1,    1,
                                      1,    1,    1,    1,    1,    1,    1);

  DocNotCnst     =  -1;

  DocCnst       : array[DocTypes] of Integer
                   = (   -1,    1,    1,   -1,    1,    1,   -1,    1,   -1,    1,    1,
                          1,   -1,    1,    1,   -1,   -1,    1,   -1,   -1,    1,    1,
                          1,    1,    1,    1,    1,   -1,    1,    1,    1,    1,    1,
                          1,    1,    1,    1);

  DocNames      : array[DocTypes] of string[30]
                   = ('Sales Invoice', 'Sales Receipt', 'Sales Credit Note',
                      'Sales Journal Invoice', 'Sales Journal Credit', 'Sales Refund',
                      'Sales Receipt & Invoice', 'Sales Quotation','Sales Order',
                      'Sales Delivery Note', 'Settlement Discounts Given',
                      'Standard Discounts Given','Output VAT', 'Debtors Control A/C',
                      'Purchase Invoice','Purchase Payment','Purchase Credit Note',
                      'Purchase Journal Invoice','Purchase Journal Credit',
                      'Purchase Refund','Purchase Payment & Invoice',
                      'Purchase Quotation','Purchase Order','Purchase Delivery Note',
                      'Settlement Discounts Taken','Standard Discounts Taken','Input VAT',
                      'Creditors Control A/C',
                      'Nominal Transfer','Stock Adjustment','Posting Run','Folio Number',
                      'Automatic Folio No.','Automatic Document',
                      'Automatic Cheque Number','Automatic Pay-in Ref','Stock Folio Number');

type
  GuestSale_Retrieved = Array [1..53] Of Boolean;

  TProcessMode = (pmNone, pmFunction, pmBillSplit);
  BestBunchRec = Record

                   Value  :  Integer;
                   Score  :  Byte;
                   Order  :  Byte;

                 end;


  TCompType  =  Array[1..MaxNoTills] of BestBunchRec;

(* global variables *)
var
  sEXEDir : string;

  // Global Variables for misc
  AllowHotKey   : Boolean;


  // Global Variables for Card System
  CSAutoTill    : Boolean;
  ECRTillType   : Byte;     { Till Type: MP2 or MP3 }
  Live          : Boolean;

  {Global Customer Record}
  Cust          : CustRec;
  CustFile      : Cust_FileDef;

  {Global invoice Record}
  Inv           :   InvRec;
  InvFile       :   Inv_FileDef;

  {Global Sales Details Record}
  SalesDetRec  : SalesDetRecType;
  SalesDetFile : SalesDet_FileDef;

  {Global System Record}
  Syss          :   Sysrec;
  SysFile       :   Sys_FileDef;

  {Global Group Record}
  GroupFile : Group_FileDef;
  GroupRec  : GroupRecType;

  {Global Item Record}
  ItemRec  : ItemRecType;
  ItemFile : Item_FileDef;

  {Global Till Sales Record}
  TillSales : TillSalesRec;
  TillSalesFile : TillSales_FileDef;

  {$IFNDEF VECTRONDLL}

    {global comms parameters}
    bgDetailedCommsLog : boolean;
    igBaudRate : integer;
    igComPortNo : byte;
    igMuxPause : integer;
    igCommsTimeout : integer;
    bgCommsWorking : boolean;
    bgLogBigErrors : boolean;
    TAsyncOk : boolean;
    BestTillno : byte;
    agBalances : array of TBalanceRec;
    LoginMode : TLoginMode;

  {$ENDIF}

  bgShowErrors : Boolean;
  bgReportFix : Boolean;
  igStdVATRate : double;
  sgEntPathOverride : string;

{$IFDEF CARDTK}
  const
    CARDTK_INIFILE = 'CARDTK.INI';

  var
    sClubDir, sCardSystemDir : ANSIstring;

  function GetCardTKIniSettings(var sClubDir : ANSIstring; var sCardSystemDir : ANSIstring) : boolean;
{$ENDIF}

{ Needed available globally so change company can re-open the files }
procedure Open_System(Start,Fin  :  Integer);
procedure Close_Files(ByFile  :  Boolean);
procedure InitSysRecord;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  Dialogs, SysUtils,
  {$IFNDEF CARDTK}
    DLLProc,
  {$ELSE}
    Registry,
  {$ENDIF}

   IniFiles, Forms, CardProc;

// Import Btrieve File Definitions and other misc routines
{$I VarCnst2.Pas}

procedure InitSysRecord;
var
  bLock : boolean;
  SetupIni : TIniFile;
  sSetupIniFilename : string;
begin
  sSetupIniFilename := ExtractFilePath(Application.ExeName) + 'WCSSETUP.INI';
  if FileExists(sSetupIniFilename) then
    begin
      {Update Syss with details input during the setup program}
      bLock := TRUE;
      GetMultiSys(FALSE,bLock);
      SetupIni := TIniFile.Create(sSetupIniFilename);
      SetupIni.UpdateFile;

      if UpperCase(SetupIni.ReadString('Setup','Update','')) = 'TRUE' then SetRelCode(7) {set 7 Day release Code}
      else begin
        Syss.UserName := SetupIni.ReadString('Setup','ClubName','');
        Syss.MergePath := SetupIni.ReadString('Setup','ClubDir','');
        Syss.ExPath := SetupIni.ReadString('Setup','EnterpriseDir','');
        SetRelCode(30);{set 30 Day release Code}
      end;{if}

      DeleteFile(sSetupIniFilename);

      PutMultiSys(TRUE);
    end
  else begin
    {Do not update Syss}
    bLock := FALSE;
    GetMultiSys(FALSE,bLock);
  end;{if}

  if Syss.LinkToExch and (Syss.VatMode = vmAdv)
  then MsgBox('You have the both the link to exchequer, and advanced VAT mode switched on.' + #13#13
  + 'This version of Exchequer Loyalty does not support this.' + #13#13
  + 'Contact Support for further information on this.',mtWarning,[mbOK],mbOK,'System Settings');

end;

{ Analyse command-line parameters }
{$IFNDEF VECTRONDLL}
  procedure GetBTParam;
  var
    n  :  Word;
  begin { GetBTParam }
    SBSIn := False;

    bgDetailedCommsLog := FALSE;
    igMuxPause := 20;
    igCommsTimeout :=  2000;
    bgLogBigErrors := FALSE;
    bgReportFix := FALSE;

    sgEntPathOverride := '';

    if (ParamCount>0) then begin
      for n:=1 to ParamCount do begin
        if (not SBSIn) then SBSIn:=(ParamStr(n)=PSwitch+SBSPass);

        if (not Live) then Live := (ParamStr(n)=LiveSwitch);

        bgCommsWorking := Live;

        { MH - Added 13/07/95 }
        if (UpperCase(ParamStr(N)) = ECRCom19200) then igBaudRate := 19200;

        { MH - Added 17/07/95 }
        if (UpperCase(ParamStr(N)) = ECRCom1Flag) then igComPortNo := 1;
        if (UpperCase(ParamStr(N)) = ECRCom2Flag) then igComPortNo := 2;
        if (UpperCase(ParamStr(N)) = ECRCom3Flag) then igComPortNo := 3;
        if (UpperCase(ParamStr(N)) = ECRCom4Flag) then igComPortNo := 4;

        {NF: Added 12/12/00}
        if (UpperCase(ParamStr(N)) = '/DETAILEDLOGGING') then bgDetailedCommsLog := TRUE;
        if (UpperCase(Copy(ParamStr(N),1,10)) = '/MUXPAUSE=') then igMuxPause := StrToIntDef((Copy(ParamStr(N),11,50)),10);

        {NF: Added 03/01/01}
        if (UpperCase(Copy(ParamStr(N),1,8)) = '/ENTDIR=') then sgEntPathOverride := Copy(ParamStr(N),9,255);

        {NF: Added 10/01/01}
        if (UpperCase(Copy(ParamStr(N),1,14)) = '/COMMSTIMEOUT=') then igCommsTimeout := StrToIntDef((Copy(ParamStr(N),15,255)),2000);

        {NF: Added 17/09/01}
        if (UpperCase(Copy(ParamStr(N),1,10)) = '/LOGERRORS') then bgLogBigErrors := TRUE;

        if (UpperCase(Copy(ParamStr(N),1,10)) = '/REPORTFIX') then bgReportFix := TRUE;

      end;{for}
    end;{if}

    if (SBSIn) then SBSParam:=' '+PSwitch+SBSPass
    else SBSParam:='';
  end;
{$ENDIF}

{$IFDEF CARDTK}
  function GetCardTKIniSettings(var sClubDir : ANSIstring; var sCardSystemDir : ANSIstring) : boolean;
  var
    sIniFilename : string;
    CardTkIni : TIniFile;

    function GetCardTkDllDir : string;
    var
      ClsId : string;
      RegO : TRegistry;
    begin
      Result := '';

      RegO := TRegistry.Create;

      {Check for COM Object}
      RegO.RootKey := HKEY_CLASSES_ROOT;
      If RegO.KeyExists('Exchequer.CardSystem\Clsid') Then
        {get path from com object registration}
        Begin
          { Key exists - get CLSID }
          If RegO.OpenKey('Exchequer.CardSystem\Clsid', False) Then Begin
            If RegO.KeyExists('') Then Begin
              ClsId := RegO.ReadString ('');
              { Open CLSID up and get executable name }
              RegO.CloseKey;
              If RegO.OpenKey('Clsid\'+ClsId+'\InprocServer32', False) Then Begin
                ClsId := RegO.ReadString ('');
                If FileExists (ClsId) Then Begin
                  { Got File - Check its in current directory }
                  Result := IncludeTrailingBackslash(Trim(ExtractFilePath(ClsId)));
                End; { If }
              End; { If }
            End; { If }
          End; { If }
        End
      else begin
        {get path from setup program registration}
        RegO.RootKey := HKEY_LOCAL_MACHINE;
        If RegO.KeyExists('Software\Exchequer\Card System') Then Begin
          { Key exists - get ClubDir }
          If RegO.OpenKey('Software\Exchequer\Card System', False) Then Begin
            Result := IncludeTrailingBackslash(Trim(RegO.ReadString ('ClubDir')));
          end;{if}
        end;{if}
      end;{if}

      RegO.CloseKey;
    end;{GetCardTkDllDir}

  Begin{GetCardTKIniSettings}
    sIniFilename := GetCardTkDllDir + CARDTK_INIFILE;
    if FileExists(sIniFilename) then
      begin
        {Read settings from the ini file}
        CardTkIni := TIniFile.Create(sIniFilename);
        sClubDir := IncludeTrailingBackslash(CardTkIni.ReadString('Settings','ClubDir',''));
        sCardSystemDir := IncludeTrailingBackslash(CardTkIni.ReadString('Settings','CardSystemDir',''));
        Result := TRUE;
      end
    else Result := FALSE;
  end;{GetCardTKIniSettings}
{$ENDIF}


initialization

//  ShowMessage(IntToStr(SizeOf(CustRec)));

  // Init Global Variables

  bgShowErrors := TRUE;
  AllowHotKey   := FALSE;
  CSAutoTill    := FALSE;
  ECRTillType   := TillType_MP2;    { Till Type: MP2 or MP3 }

  {$IFNDEF VECTRONDLL}
    igBaudRate    := 9600;            { Baud Rate for communications }
    igComPortNo   := 1;               { Com Port: COM1 - COM4 }
    Live          := FALSE;           { Talk to tills }
    bgCommsWorking := FALSE;
    TAsyncOk := bgCommsWorking;
  {$ENDIF}

  DocNames[NMT]:='Paid In';
  DocNames[SOA]:='Spend';
  DocNames[SIN]:='';
  DocNames[SRI]:='Paid In';
  DocCodes[SOA]:='SOR';
  DocCnst[SOA]:=-1;
  DocCnst[SRI]:=1;

  // Define Btrieve files
  TotFiles := 7;

  DefineCardCustF;
  DefineInv;
  DefineSalesDet;
  DefineSys;
  DefineItems;
  DefineGroup;
  DefineTillSales;

  // Check Command-Line parameters
  {$IFNDEF VECTRONDLL}
    GetBtParam;
  {$ENDIF}

  // Open data files }

  {$IFDEF CARDTK}
    if GetCardTKIniSettings(sClubDir, sCardSystemDir) then setdrive := sCardSystemDir;
  {$ENDIF}

  Open_System(1,TotFiles);

  // Put System Parameters into Syss
  InitSysRecord;

  // Toolkit DLL
  {$IFNDEF CARDTK}
    oDLL := TDLL.Create;
    oDLL.GetGlobalVATRate;
  {$ENDIF}

finalization
  {* All Pointers Destroyed via HeapVarTidy in SysU2 v4.01b, 15/12/1997 *}


end.


