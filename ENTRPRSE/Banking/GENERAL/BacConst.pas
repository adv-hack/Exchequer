unit BacConst;

interface

const

  KnownBacsTypes = 89; // Increase this when adding new types

{Export objects}
  exBacs1     = 0;
  exAIB       = 1;
  exBnkIre    = 2;
  exIdeal     = 3;
  exHex       = 4;
  exBacstel   = 5;
  exNatwest   = 6;
  exBacsNc    = 7;
  exPcPayCsv  = 8;
  exPcPayAsc  = 9;
  exCoutts    = 10;
  exBusMaster = 11;
  exPayaway   = 12;
  exAbnAmro   = 13;
  exBankScot  = 14;
  exMultiBacs = 15;
  exRBS       = 16;
  exBBMInt    = 17;
  exCoop      = 18;
  exYorkBank  = 19;
  exRBSCashM  = 20;
  exUlsterBank= 21;
  exDanske    = 22;
  exRbsBulk   = 23;
  exUnity     = 24;
  exBACSess   = 25;
  exSHBBacs   = 26;
  exSHBIntl   = 27;
  exHSBC18    = 28;
  exPayMan    = 29;
  exNorthern  = 30;
  exFirstNat  = 31;
  exBankLine  = 32;
  exBnkIreEx  = 33;
  exClydesdale= 34;
  exNIB       = 35;
  exAcc       = 36;
  exFirstTrust= 37;
  exHypoV     = 38;
  exBankLineBulk
              = 39;
  exJPMorgan  = 40;
  exNacha     = 41;
  exNorthernCSF
              = 42;
  exSogeCash  = 43;
  exRaboBank  = 44;
  exLloydsXml = 45;
  exSantander = 46;
  exClydesdale2 = 47;
  exDanskeUK  = 48;
  exANZABA    = 49;
  exBarcInet  = 50;
  exHoare     = 51;
  exHSBCCanada
              = 52;
  exHSBCIreland
              = 53;
  exHSBCNZ    = 54;
  exHSBCAustralia
              = 55;
  exClydesdale2013
              = 56;
  exHSBCMT103Euro
              = 57;
  exHSBCMT103PP
              = 58;
  exBankLineAdHoc
              = 59;

  //SEPA xml formats
  exAIBSEPA      = 60;
  exBankIreSEPA  = 61;
  exUlsterSEPA   = 62;
  exDanskeSEPA   = 63;
  exABNSEPA      = 64;
  exUniSEPA      = 65;
  exBankLineSEPA = 66;
  exBarclaysSEPA = 67;

  exUBS          = 68;

  exHSBCSepa     = 69;
  exBankAmericaSepa
                 = 70;
  exCommerzbank  = 71;
  exDeutsche     = 72;
  exLloydsCol    = 73;
  exDNB          = 74;
  exBankLineBulkBBT = 75;
  exUlsterBankAdhoc = 76; //HV 25/02/2016 2016-R2 ABSEXCH-16595: New Bacs format for Ulster Bank Bankline Ad-hoc
  exDBSUFF       = 77;
  exSVB          = 78;    //HV 24/05/2016 2016-R2 ABSEXCH-17453: New format for SVB (Silicon Valley Bank)
  exBarclaysSage = 79;    //HV 08/06/2016 2016-R2 ABSEXCH-17575: Barclays.NET Sage file format, Sage file format -UK Three Day Payments and UK faster/Next Day Payment
  exSVBUD        = 80;    //HV 28/07/2016 2016-R3 ABSEXCH-17648: BACS - New format for Silicon Valley Bank (SVB)-BACS OR MULTI-BACS USER DEFINED FILE RECORD FORMAT
  exBLCoutts     = 81;    //HV 02/08/2016 2016-R3 ABSEXCH-17646: New format for Coutts Bank
  exBarclaysWealth = 82;  //PR 21/12/2016 2017-R1 ABSEXCH-18048: New format for Barclays Wealth. Descends from Barclays Business Master Sepa and allows different currency
  exMetroBank    = 83;    //HV 12/04/2017 2017-R1 ABSEXCH-18562: New format for QPR - E-Banking Metro Bank
  exBankLineIntl = 84;    //PR 13/04/2017 2017-R1 ABSEXCH-18463: New format for Bankline International payments
  exHoareTransCode = 85;  //HV 13/04/2017 2017-R1 ABSEXCH-18556: New format for The Honourable Soc of Gray's Inn - E-banking Platform- C Hoare & Co
  exBankofScotlandCSV = 86;  //SS:24/07/2017:2017-R2:ABSEXGENERIC-408:New Plug-in format for Bank of Scotland
  exRBSEq = 87;  //HV 02/04/2018 2016-R1 ABSEXCH-19690 : Growth Capital Partners LLP - BACS format (Eq BACS - RBS EQ Bank)
  exHSBCMT103PPXML = 88; //HV 09/05/2018 2018-R1.1 ABSEXCH-20015: Thomas Pink - HSBC-MT103 Priority Payments (XML Foramt)

{File types allowed}
  ftaCreditOnly = 0;
  ftaDebitOnly  = 1;
  ftaBoth       = 2;

  BacsIDs : Array[0..KnownBacsTypes - 1] of String[8] =

                     ('Bacs1','AIB','BnkIre','Ideal','Hex',
                      'BacsTel','NatWest','BacsNc','PcPayCsv',
                      'PcPayAsc','Coutts','BusMast','Payaway',
                      'AbnEpf', 'BankScot', 'eBanking', 'Rbs',
                      'BBMI', 'CoopBank', 'YorkBank', 'RbsCashM',
                      'UlstrBnk', 'Danske', 'RBS Bulk', 'Unity', 'BACSess',
                      'SHBBacs', 'SHBIntl', 'HSBC18', 'PayMnger', 'Northern',
                      'FirstNat', 'Bankline','BnkIreEx','Clyddale', 'NIB', 'TSBPerm',
                      'AccBank', '1stTrust', 'BankLinB', 'JPMorgan', 'NACHA', 'NBCSF', 'SogeCash', 'RaboBank',
                      'Lloyds', 'Santnder', 'Clyde2', 'DanskeUK', 'ANZABA', 'BarcInet', 'Hoare', 'HSBCCan',
                      'HSBCIre', 'HSBCNZ', 'HSBCAus', 'Clyde13', 'HSBCEuro', 'HSBCPPay', 'BLAdHoc', 'AIBSepa',
                      'BISepa', 'UlstSEPA', 'DanskSep', 'ABNSEPA', 'UNISepa', 'BLSepa', 'BMSepa', 'UBSPAY',
                      'HSBCSepa', 'BoASepa', 'Commerz', 'Deutsche', 'LloydCOL', 'DNB BACS', 'BankLBBT', 'UBAdhoc',
                      'DBSUFF', 'SVB', 'BarcSege', 'SVBUD', 'BLCoutts', 'BM Wealth', 'MetroBnk', 'BLIntl', 'HoareTC','BSCOTCSV',
                      'RBSEq', 'HSBC103');



  BacsDescriptions : Array[0..KnownBacsTypes - 1] of ShortString =

                       ('BACS/no date',
                        'Allied Irish Bank',
                        'Bank of Ireland',
                        'Development Bank of Singapore IDEAL',
                        'HSBC Hexagon',
                        'Barclays Bacstel',
                        'Natwest Autopay',
                        'BACS/no date/no contra',
                        'Lloyds TSB PcPay Comma Separated',
                        'Lloyds TSB PcPay Fixed-length',
                        'Coutts BACS format',
                        'Barclays BusinessMaster',
                        'Natwest PayAway',
                        'ABN-Amro',
                        'Bank of Scotland HOBS',
                        'eBanking',
                        'Royal Bank of Scotland',
                        'Barclays BusinessMaster (International)',
                        'Co-operative Bank',
                        'Yorkshire Bank',
                        'RoyLine Cash Management',
                        'Ulster Bank Anytime',
                        'Den Danske Bank',
                        'Royal Bank of Scotland Bulk Format',
                        'Unity Bank',
                        'BACSess',
                        'Saudi Hollandi Bank (BACS)',
                        'Saudi Hollandi Bank (International)',
                        'HSBC 18',
                        'Natwest BankLine Payment Manager',
                        'Northern Bank',
                        'First National Bank',
                        'Bankline Internet Banking',
                        'Bank of Ireland Extended',
                        'Clydesdale Bank',
                        'National Irish Bank',
                        'Acc Bank',
                        'First Trust',
                        'HypoVereinsbank',
                        'Bankline Bulk',
                        'J P Morgan BACS',
                        'NACHA',
                        'Northern Bank CSF',
                        'SogeCash',
                        'RaboBank (CLIEOP-3)',
                        'Lloyds TSB (XML)',
                        'Santander',
                        'Clydesdale New',
                        'Den Danske Bank UK Format',
                        'ANZ Bank ABA Format',
                        'Barclays Internet',
                        'E Hoare',
                        'HSBC Canada',
                        'HSBC Ireland',
                        'HSBC New Zealand',
                        'HSBC Australia',
                        'Clydesdale Bank 2013',
                        'HSBC MT03 Eurozone',
                        'HSBC MT03 Priority Payment',
                        'Bankline Ad Hoc',
                        'Allied Irish Bank SEPA',
                        'Bank of Ireland SEPA',
                        'Ulster Bank SEPA',
                        'Danske Bank SEPA',
                        'ABN-AMRO SEPA',
                        'Unicredit SEPA',
                        'Bankline SEPA',
                        'Barclays BusinessMaster SEPA',
                        'UBS Payment',
                        'HSBC Sepa',
                        'Bank of America SEPA',
                        'Commerzbank BACS-18',
                        'Deutsche Sepa',
                        'Lloyds Corporate Online',
                        'DNB BACS',
                        'Bankline Bulk BBT',
                        'Ulster Bank Adhoc',
                        'DBS UFF',
                        'SVB - Faster Payments',
                        'Barclays Sage',
                        'SVB - User Defined',
                        'BL Internet - COUTTS',
                        'Barclays Wealth',
                        'Metro Bank',
                        'Bankline International',
						            'E Hoare TransCode',
                        'Bank of Scotland CSV',
                        'eQ BACS',
                        'HSBC MT103 Priority Payment XML'
                        );



  BacsShortDescriptions : Array[0..KnownBacsTypes - 1] of ShortString =

                       ('BACS/no date',
                        'Allied Irish Bank',
                        'Bank of Ireland',
                        'DBS IDEAL',
                        'HSBC Hexagon',
                        'Barclays Bacstel',
                        'Natwest Autopay',
                        'BACS/no date/no contra',
                        'Lloyds TSB PcPay CSV',
                        'Lloyds TSB PcPay ASCII',
                        'Coutts BACS format',
                        'Barclays BusinessMaster',
                        'Natwest PayAway',
                        'ABN-Amro',
                        'Bank of Scotland HOBS',
                        'eBanking',
                        'Royal Bank of Scotland',
                        'BBM (Int)',
                        'Co-op Bank',
                        'Yorkshire Bank',
                        'Royline Cash Management',
                        'Ulster Bank Anytime',
                        'Den Danske Bank',
                        'RBS Bulk Format',
                        'Unity Bank',
                        'BACSess',
                        'SHB BACS',
                        'SHB Intl',
                        'HSBC 18',
                        'Natwest Payment Manager',
                        'Northern Bank',
                        'First National Bank',
                        'Bankline Internet',
                        'Bank of Ireland Extended',
                        'Clydesdale Bank',
                        'National Irish Bank',
                        'Acc Bank',
                        'First Trust',
                        'HypoVereinsbank',
                        'Bankline Bulk',
                        'J P Morgan BACS',
                        'HSBC USA NACHA',
                        'Northern Bank CSF',
                        'SogeCash',
                        'RaboBank',
                        'Lloyds TSB',
                        'Santander',
                        'Clydesdale Bank New',
                        'Den Danske Bank UK',
                        'ANZ ABA',
                        'Barclays Internet Banking',
                        'E Hoare',
                        'HSBC Canada',
                        'HSBC Ireland',
                        'HSBC New Zealand',
                        'HSBC Australia',
                        'Clydesdale 2013',
                        'HSBC MT03 Eurozone',
                        'HSBC MT03 Priority Pay',
                        'Bankline Ad Hoc',
                        'Allied Irish Bank SEPA',
                        'Bank of Ireland SEPA',
                        'Ulster Bank SEPA',
                        'Danske Bank SEPA',
                        'ABN-AMRO SEPA',
                        'Unicredit SEPA',
                        'Bankline SEPA',
                        'Barclays SEPA',
                        'UBS Payment',
                        'HSBC Sepa',
                        'Bank of America SEPA',
                        'Commerzbank BACS-18',
                        'Deutsche Sepa',
                        'Lloyds COL',
                        'DNB BACS',
                        'Bankline Bulk BBT',
                        'Ulster Bank Adhoc',
                        'DBS UFF',
                        'SVB - Faster Payments',
                        'Barclays Sage',
                        'SVB - User Defined',
                        'BL Internet - COUTTS',
                        'Barclays Wealth',
                        'Metro Bank',
                        'Bankline International',
                        'E Hoare TransCode',
                        'Bank of Scotland CSV',
                        'eQ BACS',
                        'HSBC MT103 Priority Payment XML');

  StatementFormats : Array[0..KnownBacsTypes - 1] of ShortString =
                       ('StdBacs', 'AIB', 'BankIRE', 'DBSIDEAL', 'Hexagon', 'Barclays',
                        'Natwest', 'StdBacs1', 'Lloyds', 'Lloyds', 'Coutts', 'Barclays',
                         'Payaway', 'ABN', 'BoSHobs',
                        '', 'RBS', 'BBMInt', 'Co-op', 'Yorks',
                         'Royline', 'Ulster', 'DenDansk', 'RBSBulk', 'Unity',
                         'BacSess', 'ShbBacs', 'ShbIntl', 'HSBC18', 'Natwest', 'Northern',
                         'FirstNat', 'Bankline', 'BankIEx','Clyddale', 'NIB',  'AccBank',
                         '1stTrust', 'HypoV', 'Bankline', 'JPMorgan','NACHA', 'NBCSF', 'SogeCash', 'RaboBank',
                         'Lloyds','Santnder', 'Clyddale', 'DanskeUK', 'ANZABA', 'BarcInet', 'Hoare', 'HSBCCAN',
                         'HSBCIre', 'HSBCNZ', 'HSBCAus', 'Clyde13', 'HSBC18', 'HSBC18', 'Natwest', 'AIB', 'BankIRE', 'Ulster',
                         'Danske', 'ABNSEPA', 'UniSEPA', 'Bankline', 'Barclays', 'UBSPAY', 'HSBCSepa', 'BOASepa',
                         'Commerz', 'Deutsche', 'LloydCOL', 'DNBBACS', 'BankLBBT', 'UBAdhoc', 'DBSUFF', 'SVB','BarcSege',
                         'SVBUD', 'BLCoutts', 'Barclays', 'MetroBnk', 'BLIntl', 'HoareTC', 'BSCOTCSV', 'RBSEq',
                         'HSBC103');

  EntVer = '2017 Build '; // PS 19/02/2016 2016 R1 ABSEXCH-17274 : Change copyright to 2016
                         //  PL 04/11/2016 ABSEXGENERIC-400 rebranding update 	

  //Ini Filenames
  AIB_SEPA_INI    = 'AIBSepa.ini';
  BI_SEPA_INI     = 'BankIrelandSepa.ini';
  ULSTER_SEPA_INI = 'UlsterSepa.ini';
  DANSKE_SEPA_INI = 'DanskeSepa.ini';
  ABN_SEPA_INI    = 'abnSepa.ini';
  UNI_SEPA_INI    = 'UniCreditSepa.ini';
  HSBC_SEPA_INI   = 'HSBCSepa.ini';
  BOA_SEPA_INI    = 'BoASepa.ini';
  DEUTSCHE_SEPA_INI = 'Deutsche.ini';

function BankProduct(WhichOne : Word;
                     var ProductName : ShortString;
                     var DefPayFile  : ShortString;
                     var DefRecFile  : ShortString) : Boolean; Export;

function BankProductCount : SmallInt; Export;

function BankStatementFormat(WhichOne : Word) : ShortString; Export;



implementation

function BankProduct(WhichOne : Word;
                     var ProductName : ShortString;
                     var DefPayFile  : ShortString;
                     var DefRecFile  : ShortString) : Boolean;
begin
  Result := WhichOne <= KnownBacsTypes;
  if Result then
  begin
    ProductName := BacsShortDescriptions[WhichOne - 1];
    DefPayFile := '';
    DefRecFile := '';
  end;
end;

function BankProductCount : SmallInt;
begin
  Result := SmallInt(KnownBacsTypes);
end;

function BankStatementFormat(WhichOne : Word) : ShortString;
begin
  if WhichOne <= KnownBacsTypes then
    Result := StatementFormats[WhichOne - 1]
  else
    Result := '';
end;


end.

