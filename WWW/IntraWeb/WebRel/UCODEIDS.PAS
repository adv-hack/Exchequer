unit uCodeIDs;
{Contains CodeIDs for auditing; These IDs must map to those stored in the
 CodeTypes table in the Pervasive SecAdmin database;}

interface

const
  cidPlugIn = 1;
  cidMCM = 2;
  cidDaily = 3;
  cidDirectors = 4;
  cidEntRel = 5;
  cidEntUCRel = 6;
  cidEntCoyRel = 7;
  cidModRel = 8;
  cidModUCRel = 9;
  cidPlugRel = 10;
  cidPlugUCRel = 11;
  cidVectRel = 12;
  cidResync = 13;
  cidResetEnt = 14;
  cidResetPlug = 15;
  cidVectDaily = 16;
  cidSpecialFunction = 17;

  {Constants required for the CodeGenerator.GetCode method;}

  eidSystem = 0;
  eidMultiCurrency = 1;
  eidJobCosting = 2;
  eidReportWriter = 3;
  eidToolkit = 4;
  eidTeleSales = 5;
  eidStkAnalysis = 6;
  eidEBusiness = 7;
  eidPaperless = 8;
  eidOLESave = 9;
  eidCommitment = 10;
  eidTradeCounter = 11;
  eidStdWorksOrders = 12;
  eidProWorksOrders = 13;
  eidSentimail = 14;
  eidUserProfiles = 15;
  eidCIS = 16;
  eidAppsVals = 17;
  eidFullStock = 18;
  eidVisualRW = 19;
  eidGoodsReturns = 20;
  eidEBanking = 21;
  eidOutlookDashboard = 22;
  eidImporter = 23;
  eidGDPR = 24;
  eidPervFileEncryption = 25;

  eidVectronDaily = 243;
  eidDirectors = 244;
  eidMCM = 245;
  eidPlugIn = 248;
  eidPlugUCRel = 250;
  eidDaily = 251;
  eidPlugRel = 252;
  eidCoyCount = 253;
  eidToolkitUC = 1004;


  {Version Constants;}

  version5 = 'v5.0x/v5.5x';
  version431 = 'v4.31/v4.32';
  version430c = 'v4.30c';
  version430 = 'v4.30';

  
  {Text Constants}

  tidMultiCurrency = 'Multi Currency';
  tidJobCosting = 'Job Costing';
  tidReportWriter = 'Report Writer';
  tidToolkit = 'Toolkit';
  tidTeleSales = 'TeleSales';
  tidStkAnalysis = 'A/C Stk Analysis';
  tidEBusiness = 'eBusiness';
  tidPaperless = 'Paperless';
  tidOLESave = 'OLE Save';
  tidCommitment = 'Commitment';
  tidTradeCounter = 'Trade Counter';
  tidStdWorksOrders = 'Std Works Orders';
  tidProWorksOrders = 'Pro Works Orders';
  tidSentimail = 'Sentimail';
  tidUserProfiles = 'Enhanced User Profiles';
  tidCISRCT = 'CIS/RCT';

  tidAppsVals = 'Applications & Valuations';
  tidFullStock = 'Full Stock Control';
  tidVisualRW = 'Visual Report Writer';
  tidGoodsReturns = 'Goods Returns';
  tidEBanking = 'eBanking';
  tidOutlookDashboard = 'Outlook Dynamic Dashboard';
  tidImporter = 'Importer';
  tidGDPR = 'GDPR';
  tidPervFileEncryption = 'Pervasive File Encryption';


  tidEmailRequest = 'Request Code';
  tidEmailThreshApplied = 'Threshold Applied';
  tidEmailThreshOverridden = 'Threshold Overridden';
  tidEmailCodeUnavailable = 'Code Unavailable';
  // AB - 3
  tidEmailESNSpecified = 'ESN Specified';

  fullRelease = 'Full Release';

  {Group Type Constants}

  gtDealer = 1;
  gtDistributor = 2;

implementation

end.
