unit ExWrap;

{ prutherford440 15:10 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$H-}

uses
  ExpObj, CustAbsU, Classes, BacConst, FileUtil;



type

  TExportWrapper = Class
    Exporter    : TExportObject;
    constructor Create(const EventData : TAbsEnterpriseSystem; WhichObject : Byte);
    destructor Destroy; override;
    function StartUp(const EventData : TAbsEnterpriseSystem) : Boolean;
    function CreateFile(const EventData : TAbsEnterpriseSystem;
                        const AFileName : String) : Boolean;
    function Validate(const EventData : TAbsEnterpriseSystem) : Boolean;
    function Write(const EventData : TAbsEnterpriseSystem) : Boolean;
    function Contra(const EventData : TAbsEnterpriseSystem) : Boolean;
    function Close(const EventData : TAbsEnterpriseSystem) : Boolean;
    function Reject(const EventData : TAbsEnterpriseSystem) : Boolean;
    function Erase(const EventData : TAbsEnterpriseSystem) : Boolean;
    function Complete(const EventData : TAbsEnterpriseSystem) : Boolean;
  end;

  function HandleBatchHooks(const EventData : TAbsEnterpriseSystem;
                                   HID : longint;
                                 WhichObject : integer;
                              FileTypesAllowed : Byte;
                              PayFile, RecFile : string) : Boolean;

  function HookIsLicenced(WhichBacs : integer) : Boolean;
  procedure MakeBacsAboutText(WhichBacs : integer);

var
  ExportWrapper : TExportWrapper;
  Count : integer;
  BankDetFromIni : Boolean;

  IniBankSort,
  IniBankAc,
  IniBankRef,
  IniPayFile,
  IniDDFile,
  OutputPath : string;

  BacsType : integer;

  AboutText : TStringList;
  

implementation

uses
  Bacs00, AibObj, BankIObj, HexObj, Bacstobj, NatWObj, IdealObj, Dialogs,
  BacNcObj, PcCsvObj, CouttObj, BMastObj, PaywayOb, HobsObj, {CheckSec,} PISecure, ChainU,
  SysUtils, PIMisc, ActiveX, RbsObj{$IFDEF BBM}, BbmObj{$ENDIF},
  CoopObj, YorkObj, CashMObj, UlstrObj, DanskObj, RbsBulkO, UnityObj, BacssObj, ShbBObj, ShbIObj,
  HSB18obj, EntLicence, PayMnger, NorthObj, FirstObj, BankLObj, BIExObj, ClydOBJ, NIBObj,
  TSBPmObj, AccObj, FTrustOb, HypoVObj, BankLBulkObj, JPMorganObj, NachaObj, NorthernCSFObj, SogeObj,
  RaboObj, LloydsXmlObj, SantanderObj, ClydeObj2, DanskeUKObj, ANZABAObj, BarclaysInetObj,
  HoareObj, HSBCCanadaObj, HsbcIrelandObj, HsbcNZObj, HsbcAusObj,
  Clyde2013Obj, MT103, AIBSepaObj, BankofIrelandSepaObj, UlsterSepaObj, DanskeSepaObj,
  AbnSepaObj, UniSepaObj, BankLineSepaObj, BarclaysBMSepaObj, UBSObject, HSBCSepaObj,
  BankOfAmericaSepaObj, CommerzBankObj, DeutscheSepaObj, LLoydsColObj, ExchequerRelease,
  DNBBACSObj,BankLBulkBBTObj, DBSUffObj, SVBObj, BarcSegeObj, BarclaysBMWealthObj, MetroBankObj,
  BanklineIntlObj,BankOfScotCSVObj,RBSEqObj, HSBCMT103PPXMLObj;

var
  HookLicenced : Boolean;

constructor TExportWrapper.Create(const EventData : TAbsEnterpriseSystem; WhichObject : Byte);
begin
  inherited Create;
  with EventData do
  begin
  {Don't want a try/except block here as any exception will be handled by
  the lines below where exportwrapper itself is created}
      case WhichObject of
        exBacs1   : Exporter := TBacs1Obj.Create;
        exAIB     : Exporter := TAibEftObj.Create(EventData);
        exBnkIre  : Exporter := TBankIrExportObject.Create(EventData);
        exIdeal   : Exporter := TIdealExportObject.Create(EventData);
        exHex     : Exporter := THexagonExportObject.Create(EventData);
        exBacstel : begin
                      {$IFNDEF Multibacs}
                        CoInitialize(nil);
                      {$ENDIF}
                       Exporter := TBacstelExportObject.Create(EventData.Setup.ssDataPath);
                    end;
        exNatwest : Exporter := TNatWestExportObject.Create;
        exBacsNc  : Exporter := TBacsNcExportObject.Create;
        exPcPayCsv : Exporter := TPcPayCsvExportObject.Create;
        exPcPayAsc : Exporter := TBacsNcExportObject.Create; {re-use of bacsnc}
        exCoutts   : Exporter := TCouttsExportObject.Create(EventData);
        exBusMaster : begin
                      {$IFNDEF Multibacs}
                        CoInitialize(nil);
                      {$ENDIF}
                        Exporter := TBusinessMasterExportObject.Create(EventData.Setup.ssDataPath);//TBacsNcExportObject.Create; {re-use of bacsnc}
                      end;
        exPayaway   : Exporter := TPayawayExportObject.Create;
        exBankScot  : Exporter := TBankScotHobsExportObject.Create(EventData);
        exRBS       : Exporter := TRoyLineExportObject.Create;
        {$IFDEF BBM}
        exBBMInt    : Exporter := TBBMObject.Create;
        {$ENDIF}
        exCoop      : Exporter := TCoopExportObject.Create;
        exYorkBank  : Exporter := TYorkBankExportObject.Create;
        exRbsCashM  : Exporter := TRoylineCashManObject.Create;
        exUlsterBank: Exporter := TUlsterBankExportObject.Create(EventData);
        exDanske    : Exporter := TDanskeExportObject.Create;
        exRbsBulk   : Exporter := TRBSBulkExportObject.Create;
        exUnity     : Exporter := TUnityExportObject.Create;
        exBACSess   : Exporter := TBacsessExportObject.Create;
        exSHBBacs   : Exporter := TShbBacsExporter.Create;
        exSHBIntl   : begin
                      {$IFNDEF Multibacs}
                        CoInitialize(nil);
                      {$ENDIF}
                        Exporter := TShbIntExporter.Create(EventData);
                      end;
        exHSBC18    : Exporter := THSBC18Object.Create;
        exPayMan    : Exporter := TNatWestPayManagerObject.Create;
        exNorthern  : Exporter := TNorthernObj.Create(EventData);
        exFirstNat  : Exporter := TFirstNatExportObject.Create;
        exBankLine  : Exporter := TBankLineObject.Create;
        exBnkIreEx  : Exporter := TBankIrExportObjectEx.Create(EventData);
        exClydesdale: Exporter := TClydExportObject.Create;
        exNIB       : Exporter := TNIBExportObject.Create(EventData);
        exAcc       : Exporter := TAccBankExportObject.Create(EventData);
        exFirstTrust: Exporter := TFirstTrustExportObject.Create;
        exHypoV     : Exporter := THypoVObj.Create;
        exBankLineBulk
                    : Exporter := TBankLineBulkObject.Create;
        exJPMorgan  : Exporter := TJPMorganExportObject.Create;
        exNacha     : Exporter := TNachaObject.Create;
        exNorthernCSF
                    : Exporter := TNorthernCSFExportObject.Create;
        exSogeCash  : Exporter := TSogeExportObject.Create;
        exRaboBank  : Exporter := TRaboBankExportObject.Create;
        exLloydsXml : Exporter := TLLoydsXmlExportObject.Create;
        exSantander : Exporter := TSantanderCsvExportObject.Create;
        exClydesdale2
                    : Exporter := TClydeExportObject2.Create(EventData);
        exDanskeUK  : Exporter := TDanskeUKExportObject.Create;
        exANZABA    : Exporter := TANZABAExportObject.Create;
        exBarcInet  : Exporter := TBarclaysInternetExportObject.Create;
        exHoare     : Exporter := THoarePayExportObject.Create; //v6.10 ABSEXCH-12013 16/03/2012
        exHSBCCanada: Exporter := THSBCCanadaExportObject.Create;
        exHSBCIreland
                    : Exporter := THSBCIrelandExportObject.Create(EventData);
        exHSBCNZ    : Exporter := THSBCNZExporter.Create;
        exHSBCAustralia
                    : Exporter := THSBCAustraliaExportObject.Create;
        exClydesdale2013
                    : Exporter := TClyde2013ExportObject.Create;
        exHSBCMT103Euro
                    : Exporter := TMT103EurozoneExportObject.Create;
        exHSBCMT103PP
                    : Exporter := TMT103PriorityExportObject.Create;
        exBankLineAdHoc
                    : Exporter := TBankLineAdHocObject.Create;

        exAIBSEPA   : Exporter := TAibSepaExportObject.Create;
        exBankIreSEPA
                    : Exporter := TBankofIrelandSepaExportObject.Create;
        exUlsterSEPA: Exporter := TUlsterSepaExportObject.Create;
        exDanskeSEPA: Exporter := TDanskeSepaExportObject.Create;
        exABNSEPA   : Exporter := TABNSepaExportObject.Create;
        exUniSEPA   : Exporter := TUniSepaExportObject.Create;
        exBankLineSEPA
                    : Exporter := TBankLineSepaObject.Create;
        exBarclaysSEPA
                    : Exporter := TBarclaysBMSepaObject.Create;
        exUBS       : Exporter := TUBSExportObject.Create;
        exHSBCSepa  : Exporter := THSBCSepaExportObject.Create;
        exBankAmericaSepa
                    : Exporter := TBankofAmericaSepaExportObject.Create;
        exDeutsche  : Exporter := TDeutscheSepaObject.Create;
        exLloydsCol : Exporter := TLLoydsCOLExportObject.Create;
        exDNB       : Exporter := TDNBBACSExportObject.Create;
        exBankLineBulkBBT
                    : Exporter := TBankLineBulkBBTObject.Create;
        exUlsterBankAdhoc
                    : Exporter := TUlsterBankAdHocObject.Create;  //HV 25/02/2016 2016-R2 ABSEXCH-16595: New Bacs format for Ulster Bank Bankline Ad-hoc
        exDBSUff    : Exporter := TDBSUFFObject.Create;
        exSVB       : Exporter := TSVBObject.Create; //HV 24/05/2016 2016-R2 ABSEXCH-17453: New format for SVB (Silicon Valley Bank)
        exBarclaysSage
                    : Exporter := TBarcSegeObject.Create(EventData); //HV 08/06/2016 2016-R2 ABSEXCH-17575: Barclays.NET Sage file format, Sage file format -UK Three Day Payments and UK faster/Next Day Payment
        exSVBUD     : Exporter := TSVBUDObject.Create;  //HV 28/07/2016 2016-R3 ABSEXCH-17648: BACS - New format for Silicon Valley Bank (SVB)-BACS OR MULTI-BACS USER DEFINED FILE RECORD FORMAT
        exBLCoutts  : Exporter := TBLCouttsObject.Create;  //HV 02/08/2016 2016-R3 ABSEXCH-17646: New format for Coutts Bank
        exBarclaysWealth
                    : Exporter := TBarclaysBMWealthObj.Create;
        exMetroBank : Exporter := TMetroBankObject.Create(EventData); //HV 12/04/2017 2017-R1 ABSEXCH-18562: New format for QPR - E-Banking Metro Bank
        exBanklineIntl
                    : Exporter := TBanklineIntlObject.Create; //PR 13/04/2017 2017-R1 ABSEXCH-18463: New format for Bankline International payments
        exHoareTransCode
                    : Exporter := THoareTransCodeExportObject.Create; //HV 13/04/2017 2017-R1 ABSEXCH-18556: New format for The Honourable Soc of Gray's Inn - E-banking Platform- C Hoare & Co
        exBankofScotlandCSV
                    : Exporter := TBankScotCSVExportObject.Create(EventData); //SS:28/07/2017:2017-R2:ABSEXGENERIC-408:New Plug-in format for Bank of Scotland
        exRBSEq
                    : Exporter := TRBSEqObject.Create; //HV 03/04/2017:2018-R1.1:ABSEXCH-19690: New Plug-in format for RBS Eq Bank
        exHSBCMT103PPXML
                    : Exporter := THSBCMT103PPXMLExportObject.Create; //HV 09/05/2018 2018-R1.1 ABSEXCH-20015: Thomas Pink - HSBC-MT103 Priority Payments (XML Foramt)
      end; {case}

      BoResult := True;
      with Exporter do
      begin
        RequiredPath := CheckPath(EventData.Setup.ssDataPath);
        DataPath := RequiredPath;
        EntPath := GetEnterpriseDirectory;
        Hookname := BacsDescriptions[WhichObject];
        if BankDetFromIni then
        begin
          if Trim(OutputPath) <> '' then
            RequiredPath := CheckPath(OutputPath);
          UserBankSort := IniBankSort;
          UserBankAcc  := IniBankAc;
          UserBankRef  := IniBankRef;
        end
        else {take from system}
        begin
          UserBankSort := TAbsSetup10(EventData.Setup).ssBankSortCode;
          UserBankAcc  := TAbsSetup10(EventData.Setup).ssBankAccountCode;
          UserBankRef  := EventData.Setup.ssUserRef;
        end;
        Initialize;
        BoResult := ValidateSystem(EventData);
        if Failed > 0 then
           BoResult := False;
        if not BoResult then
        begin
          Case Failed of
            flBank :
             ShowExportMessage('Error','Check system bank details','Run aborted');
            flUserID :
             ShowExportMessage('Error','Invalid User ID','Run aborted');
            flCurrency :
                 ShowExportMessage('Warning', QuotedStr(ProcControl.PayCurr) +
                                      ' is not a valid ISO currency code',
                            'Run aborted');

          end;
        end;

      end;

  end;
end;

destructor TExportWrapper.Destroy;
begin
  FreeAndNil(Exporter);
  inherited Destroy;
end;

function TExportWrapper.StartUp(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := True;
end;

function TExportWrapper.CreateFile(const EventData : TAbsEnterpriseSystem;
                                   const AFileName : String) : Boolean;
begin
  Result := False;
  if Exporter <> nil then
  with Exporter, EventData do
  begin
    if Failed = 0 then
    begin
     Result := (CreateOutFile(RequiredPath + AFileName,
                  EventData) = 0);
     if not Result and (Failed = 0) then
           Failed := flFile;
    end;
  end;
end;

function TExportWrapper.Validate(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := False;
  if Exporter <> nil then
  with Exporter, EventData do
  begin
   begin
     Result := ValidateRec(EventData);

     //PR: 19/04/2013 This next part was commented out in v6.7 for no reason I can see. (It may have been for debugging.)
     //It had the result that even if some accounts were invalid, the file created message would still be shown, even though
     //the file had been deleted.
     if not Result then
       if Failed = 0 then
         Failed := flBank;
   end;
  end;
end;

function TExportWrapper.Write(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := False;
  if Exporter <> nil then
  with Exporter, EventData do
  begin
   begin
     Result := WriteRec(EventData, wrPayline);
     if not Result then
       if Failed = 0 then
         Failed := flRec;
   end;
  end;
end;

function TExportWrapper.Contra(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := False;
  if Exporter <> nil then
  with Exporter, EventData do
  begin
   begin
     Result := WriteRec(EventData, wrContra);
     if not Result then
        Failed := flRec;
   end;
  end;
end;

function TExportWrapper.Close(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := False;
  if Exporter <> nil then
  with Exporter, EventData do
  begin
     Result := (CloseOutFile = 0);
     if FileRejected then
       ErrorReport(EventData, 0);
     if not Result then
        Failed := flFile
     else
     if TransactionsWritten = 0 then
        Failed := flNoRecs;
  end;
end;

function TExportWrapper.Reject(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := True;
  if Exporter <> nil then
  with Exporter, EventData do
  begin
    RejectRecord(EventData);
  end;
end;

function TExportWrapper.Erase(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := True;
  if Exporter <> nil then
  with Exporter, EventData do
  begin
     BoResult := EraseOutFile;
     Result := BoResult;
  end;
end;

function TExportWrapper.Complete(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := True;
  if Exporter <> nil then
  with Exporter do
    CompletionMessage(EventData);
end;


{--------------------------------------------------------------------------------------------}
//Security functions

function BacsSysCode(WhichBacs : integer) : string;
begin
  Result := 'EXCHBACSPI000' + IntToStr(100 + WhichBacs);
end;

function BacsSecCode(WhichBacs : integer) : String;
begin
  Result := 'Dkdje*_RuUBIF' + IntToStr(100 + WhichBacs);
end;

function BacsDesc(WhichBacs : integer) : string;
begin
  Result := BacsShortDescriptions[WhichBacs] + ' Plug-In';
end;

function BacsVersion(WhichBacs : integer) : string;
var
  BuildNo : string;
begin

  Case WhichBacs of
    exBacs1     : BuildNo := '004';
    exAIB       : BuildNo := '011';
    exBnkIre    : BuildNo := '011';
    exIdeal     : BuildNo := '006';
    exHex       : BuildNo := '009';
    exBacstel   : BuildNo := '007';
    exNatwest   : BuildNo := '004';
    exBacsNc    : BuildNo := '006';
    exPcPayCsv  : BuildNo := '006';
    exPcPayAsc  : BuildNo := '006';
    exCoutts    : BuildNo := '008';
    exBusMaster : BuildNo := '007';
    exPayaway   : BuildNo := '007';
    exAbnAmro   : BuildNo := '006';
    exBankScot  : BuildNo := '008';
    exMultiBacs : BuildNo := '097';       //Increment this when adding new format
    exRBS       : BuildNo := '012';
    exBBMInt    : BuildNo := '019';
    exCoop      : BuildNo := '007';
    exYorkBank  : BuildNo := '006';
    exRBSCashM  : BuildNo := '009';
    exUlsterBank: BuildNo := '009';
    exDanske    : BuildNo := '011';
    exRBSBulk   : BuildNo := '007';
    exUnity     : BuildNo := '007';
    exBACSess   : BuildNo := '008';
    exSHBBacs   : BuildNo := '007';
    exSHBIntl   : BuildNo := '006';
    exHsbc18    : BuildNo := '012';
    exPayMan    : BuildNo := '005';
    exNorthern  : BuildNo := '009';
    exFirstNat  : BuildNo := '004';
    exBankLine  : BuildNo := '011';
    exBnkIreEx  : BuildNo := '006';
    exClydesdale: BuildNo := '003';
    exNIB       : BuildNo := '004';
    exAcc       : BuildNo := '005';
    exFirstTrust: BuildNo := '003';
    exHypoV     : BuildNo := '004';
    exBankLineBulk
                : BuildNo := '006';
    exJPMorgan  : BuildNo := '003';
    exNacha     : BuildNo := '002';
    exNorthernCSF
                : BuildNo := '003';
    exSogeCash  : BuildNo := '006';
    exRaboBank  : BuildNo := '006';
    exLloydsXml : BuildNo := '003';
    exSantander : BuildNo := '004';
    exDanskeUK  : BuildNo := '003';
    exANZABA    : BuildNo := '004';
    exBarcInet  : BuildNo := '002';
    exHoare     : BuildNo := '002';
    exHSBCCanada: BuildNo := '002';
    exHSBCIreland
                : BuildNo := '003';
    exHSBCNZ    : BuildNo := '004';
    exHSBCAustralia
                : BuildNo := '002';
    exClydesdale2013
                : BuildNo := '002';
    exHSBCMT103Euro
                : BuildNo := '002';
    exHSBCMT103PP
                : BuildNo := '002';
    exBankLineAdHoc
                : BuildNo := '003';
    exAIBSepa   : BuildNo := '006';
    exBankIreSEPA
                : BuildNo := '005';
    exUlsterSEPA: BuildNo := '005';
    exDanskeSEPA: BuildNo := '004';
    exAbnSEPA   : BuildNo := '003';
    exUniSEPA   : BuildNo := '003';
    exBanklineSEPA
                : BuildNo := '002';
    exBarclaysSEPA
                : BuildNo := '005';
    exUBS       : BuildNo := '002';
    exHSBCSepa  : BuildNo := '002';
    exBankAmericaSepa
                : BuildNo := '001';
    exCommerzBank
                : BuildNo := '001';
    exDeutsche  : BuildNo := '001';
    exLloydsCol : BuildNo := '001';
    exDNB       : BuildNo := '003';
    exBankLineBulkBBT
                : BuildNo := '001';
    exUlsterBankAdhoc
                : BuildNo := '001'; //HV 25/02/2016 2016-R2 ABSEXCH-16595: New Bacs format for Ulster Bank Bankline Ad-hoc
    exDBSUff    : BuildNo := '007';
    exSVB       : BuildNo := '001'; //HV 24/05/2016 2016-R2 ABSEXCH-17453: New format for SVB (Silicon Valley Bank)
    exBarclaysSage
                : BuildNo := '001'; //HV 08/06/2016 2016-R2 ABSEXCH-17575: Barclays.NET Sage file format, Sage file format -UK Three Day Payments and UK faster/Next Day Payment
    exSVBUD     : BuildNo := '001'; //HV 28/07/2016 2016-R3 ABSEXCH-17648: BACS - New format for Silicon Valley Bank (SVB)-BACS OR MULTI-BACS USER DEFINED FILE RECORD FORMAT
    exBLCoutts  : BuildNo := '001'; //HV 02/08/2016 2016-R3 ABSEXCH-17646: New format for Coutts Bank
    exBarclaysWealth
                : BuildNo := '004'; //PR 21/12/2016 2017-R1 ABSEXCH-18048: New format for Barclays Wealth.
    exMetroBank : BuildNo := '001'; //HV 12/04/2017 2017-R1 ABSEXCH-18562: New format for QPR - E-Banking Metro Bank
    exBanklineIntl
                : BuildNo := '001'; //PR 13/04/2017 2017-R1 ABSEXCH-18463: New format for Bankline International payments
    exHoareTransCode
                : BuildNo := '001'; //HV 13/04/2017 2017-R1 ABSEXCH-18556: New format for The Honourable Soc of Gray's Inn - E-banking Platform- C Hoare & Co
    exBankofScotlandCSV
                : BuildNo := '001'; //SS:28/07/2017:2017-R2:ABSEXGENERIC-408:New Plug-in format for Bank of Scotland
    exRBSEq     : BuildNo := '001'; //HV 02/04/2018 2016-R1 ABSEXCH-19690 : Growth Capital Partners LLP - BACS format (Eq BACS - RBS EQ Bank)
    exHSBCMT103PPXML
                : BuildNo := '001';
    else
      BuildNo := '001';
  end;

  Result := ExchequerModuleVersion(emEBanking, BuildNo) + ' (DLL)';
end;



function HookIsLicenced(WhichBacs : integer) : Boolean;
begin
{$IFDEF BBM} //Don't check licence for Bilbrough
   Result := True;
{$ELSE}
  if (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct]) then
    Result := True
  else
  if WhichBacs >= 0 then
{  Result := CheckHookSecurity (BacsIDs[WhichBacs], 1000 + WhichBacs,
                                BacsDescriptions[WhichBacs] +
                                ' batch transaction') {CheckSec.pas}

   Result := PICheckSecurity(BacsSysCode(WhichBacs), BacsSecCode(WhichBacs),
                             BacsDesc(WhichBacs), BacsVersion(WhichBacs),
                             stSystemOnly, ptDLL, DllChain.ModuleName)
  else
    Result := False;


{$ENDIF}

  HookLicenced := Result;

end;

procedure MakeBacsAboutText(WhichBacs : integer);
begin
  AboutText := TStringList.Create;
  PIMakeAboutText(BacsDesc(WhichBacs), BacsVersion(WhichBacs), AboutText);
end;



{--------------------------------------------------------------------------------------------}


function HandleBatchHooks(const EventData : TAbsEnterpriseSystem;
                                 HID : longint;
                                 WhichObject : integer;
                              FileTypesAllowed : Byte;
                              PayFile, RecFile : string) : Boolean;
var
  DefaultOutFileName : string;
Begin
  { Handle Hook Events here }
  with EventData do
  begin
   Case  HID of
      1   :  begin //PR: 15/10/2010 Changed as previous way was no longer compiling for some unknown reason.
               Try
               //Put security check here
               {$IFDEF Multibacs}
                 CoInitialize(nil);
                 ExportWrapper := TExportWrapper.Create(EventData, WhichObject)
               {$ELSE}
                 if HookLicenced then
                   ExportWrapper := TExportWrapper.Create(EventData, WhichObject)
                 else
                 begin
                   BoResult := False;
                 end;
               {$ENDIF}

               Except
                 ShowMessage('Unable to create EFT process. Run aborted');
                 BoResult := False;
               End;
             end;
     10   :  begin
               if ExportWrapper <> nil then
                with ExportWrapper, ExportWrapper.Exporter do
                begin
                  GetEventData(EventData);
                  Case FileTypesAllowed of
                    ftaCreditOnly    :  begin
                                          if ProcControl.SalesPurch then
                                          begin
                                            BoResult := False;
                                            FreeAndNil(ExportWrapper);
                                          end
                                          else
                                          begin
                                            DefaultOutFileName := PayFile;
                                            BoResult := CreateFile(EventData,
                                                 DefaultOutFileName);
                                          end;
                                        end;
                    ftaDebitOnly     :  begin {not needed yet but worth doing?}
                                          if not ProcControl.SalesPurch then
                                          begin
                                            BoResult := False;
                                            FreeAndNil(ExportWrapper);
                                          end
                                          else
                                          begin
                                            DefaultOutFileName := RecFile;
                                            BoResult := CreateFile(EventData,
                                                 DefaultOutFileName);
                                          end;
                                        end;
                    ftaBoth          :  begin
                                          if Trim(RecFile) = '' then
                                            RecFile := 'BacsRec.txt';
                                          if Trim(PayFile) = '' then
                                            PayFile := 'BacsPay.txt';
                                          if ProcControl.SalesPurch then
                                            DefaultOutFileName := RecFile
                                          else
                                            DefaultOutFileName := PayFile;
                                          BoResult := CreateFile(EventData, DefaultOutFileName);
                                        end;
                    end;{case}
                end;
             end;
     20   :  begin
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                 BoResult := Validate(EventData);
               end;
             end;
     30   :  begin
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                 BoResult := Write(EventData);
               end;
             end;
     31   :  begin
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                 BoResult := Contra(EventData);
               end;
             end;
     50   :  begin
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                 Close(EventData);
                 BoResult := True;
               end;
             end;
     60   :  begin
              {reject epf file - what do we need to do here? May as well tell user}
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                 Reject(EventData);
               end;
             end;
     70   :  begin
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                Erase(EventData);
               end;
             end;
     80   :  begin
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                 Complete(EventData);
                 ExportWrapper.Free;
               end;
             end;
     end; {case}

     Result := BoResult;
  end; {if winid...}
end;



Initialization

  Count := 1;
  ExportWrapper := nil;
  BankDetFromIni := False;

  AboutText := nil;

Finalization
  if Assigned(AboutText) then
    AboutText.Free;


end.
