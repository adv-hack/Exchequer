program Enter1;

{$I DEFOVR.Inc}

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  ShareMem,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  madListForms in 'W:\Compon\madCollection\madExcept\Custom\madListForms.pas',  
  {$IFDEF HTMLHELP}
    D6OnHelpFix,
    conHTMLHelp,
  {$ENDIF}
  GlobVar in 'Globvar.pas',
  VarConst in 'Varconst.pas',
  Forms,
  Windows,
  BtrvU2,
  ExWrap1U,
  GFXUtil in  'W:\entrprse\funcs\GFXUtil.pas',{ - shared directory selection dialog}
  APIUtil in  'W:\entrprse\funcs\APIUtil.pas',{ - shared directory selection dialog}
  XPThemes in  'W:\entrprse\funcs\XPThemes.pas',{ - shared directory selection dialog}
  CompUtil in  'W:\entrprse\MULTCOMP\CompUtil.pas',{ - shared directory selection dialog}
  ENTLic2 in  'W:\entrprse\MULTCOMP\EntLic2.pas',{ - shared directory selection dialog}
  SerialU in  'W:\entrprse\MULTCOMP\SerialU.pas',{ - shared directory selection dialog}
  Crypto in  'W:\entrprse\MULTCOMP\Crypto.pas',{ - pword encryption routines}
  FileUtil in 'W:\entrprse\funcs\fileutil.pas',
  StrUtil in 'W:\entrprse\funcs\Strutil.pas',

  {$IFDEF EXSQL}
    SQLCallerU,
  {$ENDIF}


  SButton,
  Childwin in 'CHILDWIN.PAS' {MDIChild},
  colctrlu in 'Colctrlu.pas' {ColourCtrl},
  CmpCtrlU in 'Cmpctrlu.pas',
  DebugU in 'DebugU.pas' {DebugForm},
  BTSupU1 in 'Btsupu1.pas',
  BtSupu2 in 'Btsupu2.pas',
  SupListu in 'Suplistu.pas' {PopUpList},
  InvListU in 'Invlistu.pas',
  BarGU,
  GenWarnU in 'GenWarnU.pas' {GenWarnFrm},
  MovWarnU in 'MovWarnU.pas' {MovWarnFrm},
  AllcWrnU in 'AllcWrnU.pas' {GenWarnFrm1},

  Brand in 'W:\entrprse\funcs\Brand.pas',
  GmXML in 'W:\compon\TGMXml\GmXml.pas',
//  antLabel in '\COMPON\Standard\antLabel.pas',
//  antDesc in '\COMPON\Standard\antDesc.pas',

  uICEDripFeed,

  {$IFDEF FRM}

    PrintFrm,

    PrntDlg2,

    FaxIntO  in 'W:\Entrprse\Fax\FaxIntO.Pas' ,

    BrwseDir in  'W:\entrprse\funcs\BrwseDir.pas',{ - shared directory selection dialog}

    DLLInt,

    {$IFDEF DPr_On}
      DefProcU,
      RepInpTU,
      FrmThrdU,
    {$ENDIF}


    SalTxl4U,
  {$ENDIF}

  {$IFDEF ADDNOMWIZARD}
    AddNomWizard in 'W:\Entrprse\AddNom\AddNomWizard.Pas' ,
    AddNomProc in 'W:\Entrprse\AddNom\AddNomProc.Pas' ,
    NomLine in 'W:\Entrprse\AddNom\NomLine.Pas' ,
    NumEdit in 'W:\Entrprse\AddNom\NumEdit.Pas' ,
    IncVATRate in 'W:\Entrprse\AddNom\IncVATRate.Pas' ,
    AddNomWizCustom in 'W:\Entrprse\AddNom\AddNomWizCustom.Pas' ,
    EnterpriseBeta_tlb  in 'W:\entrprse\COMTK\EnterpriseBeta_tlb.pas',{ - I/F for COMTK}
    SecCodes in 'W:\entrprse\COMTK\SecCodes.pas',{ }
    EnterToTab in 'W:\COMPON\Standard\EnterToTab.pas',
    KeyUtils in 'W:\COMPON\Standard\KeyUtils.pas',
    Enterprise04_tlb  in 'W:\entrprse\COMTK\Enterprise04_tlb.pas',{ - I/F for COMTK}

  {$ENDIF}

  {$IFDEF EBANK}
    GetRecon In 'W:\Entrprse\Banking\GetRecon.pas',
    grpview In 'W:\Entrprse\Banking\grpview.pas',
    RecFind In 'W:\Entrprse\Banking\RecFind.pas',
    RecInp In 'W:\Entrprse\Banking\RecInp.pas',
    ReconObj In 'W:\Entrprse\Banking\ReconObj.pas',
    RecReprt In 'W:\Entrprse\Banking\RecReprt.pas',
    StatFilt In 'W:\Entrprse\Banking\StatFilt.pas',
    StatForm In 'W:\Entrprse\Banking\StatForm.pas',
    TranFile In 'W:\Entrprse\Banking\TranFile.pas',
    TransLst In 'W:\Entrprse\Banking\TransLst.pas',
    BankDetl In 'W:\Entrprse\Banking\BankDetl.pas',
    BankList In 'W:\Entrprse\Banking\BankList.pas',
    Csvp In 'W:\Entrprse\Banking\Csvp.pas',
    GLList In 'W:\Entrprse\Banking\GLList.pas',
    ImpObj In 'W:\Entrprse\Banking\ImpObj.pas',
    ImpProgf In 'W:\Entrprse\Banking\ImpProgf.pas',
    statprnt in 'W:\Entrprse\Banking\statprnt.pas',
    StatRef in 'W:\Entrprse\Banking\StatRef.pas',
    Existng in 'W:\Entrprse\Banking\Existng.pas',
    Filter in 'W:\Entrprse\Banking\Filter.pas',
    NomDefs in 'W:\Entrprse\Banking\NomDefs.pas',
    SQLQueries in 'W:\Entrprse\Banking\SQLQueries.pas',


    {$IFNDEF ADDNOMWIZARD}
      EnterToTab in '\COMPON\Standard\EnterToTab.pas',
    {$ENDIF}
  {$ENDIF}

   CommsInt in 'W:\Entrprse\EntComms\CommsInt.Pas' ,

  {$IFDEF SY}
    TermServ in 'W:\Entrprse\funcs\TermServ.pas',{ - Terminal Server routines}
    oMCMSec in 'W:\Entrprse\MULTCOMP\OMCMSec.pas',{ - shared directory selection dialog}

    {$IFDEF BUREAU}
      {$IFNDEF ADDNOMWIZARD}
        Enterprise04_tlb  in 'W:\Entrprse\COMTK\Enterprise04_tlb.pas',{ - I/F for COMTK}

      {$ENDIF}
    {$ENDIF}
  {$ENDIF}


  {$IFDEF C_On}
    CustLst2 in 'Custlst2.pas' {TradList},
    CustR3U in 'Custr3u.pas' {CustRec3},
    CustSupU,

    {$IFDEF Ltr}
      letters in 'Letters.pas' {LettersList},
      MSWord95 in 'Msword95.pas',

    {$ENDIF}

    SetCtrlU in 'SetCtrlU.pas' {SettleForm},

  {$ENDIF}

  {$IFDEF GF}
    FindCtlU in 'Findctlu.pas',
    FindRecU in 'Findrecu.pas' {FindRec},
  {$ENDIF}

  {$IFDEF NP}
    Noteu in 'Noteu.pas' {NoteCtrl},
    NoteSupU in 'Notesupu.pas',
  {$ENDIF}

  BTSFrmU1 in 'Btsfrmu1.pas' {BTWaitLock},

  {$IFDEF DBK_On}
    Daybk2 in 'Daybk2.pas' {Daybk1},
    TagInpU,

    {$IFDEF JC}
      JobDbk2U,
    {$ENDIF}
  {$ENDIF}

  ComnUnit in 'Comnunit.pas',
  ComnU2 in 'Comnu2.pas',
  CurrncyU in 'Currncyu.pas',
  SysU1 in 'Sysu1.pas',
  SysU2 in 'Sysu2.pas',
  PWarnU in 'PWarnU.pas' {PassWLock},

  {$IFDEF Nom}

    Nominl1U in 'Nominl1u.pas' {NomView},
    HistWinU in 'Histwinu.pas' {HistWin},
    ReconU in 'Reconu.pas' {ReconList},
    NmlCCDU in 'NmlCCDU.pas' {CCDepView},
    NmlCDIU,
    NlPayInU in 'Nlpayinu.pas' {PayInWin},
    GLBnkRIU in 'GLBnkRIU.pas' {GLReconFrm},
    BankRCU,
    BankRCSU,
    BankRMMU,
    BankEntU,
    BankRS2U,
    BnkWarnU in 'BnkWarnU.pas' {BankWarnFrm},

    RollBudU,

    {$IFNDEF LTE}
      NomView1,
      NomVRecU,
      NomVCtlU,
    {$ENDIF}
    MoveTL1U,
    MoveTR1U,

  {$ENDIF}

  {$IFDEF JC}
    JobSup1U,
    JobTreeU,
    JATreeU,

    JobMn2U,

    SalTxl3U,

    JobBdI3U,

    CISSup1U,
    CISSup2U,
    CISInp1U,
    CISVCH1U,
    CISVCH2U,
    ObjCISMU,
    CISEDIWU,
    CISEDITU,

    CISWrite in 'W:\Entrprse\CISXML\CISWrite.pas' {TCISMessageRec},
    CISXCnst in 'W:\Entrprse\CISXML\CISXCnst.pas' ,
    InternetFiling_TLB in 'W:\Entrprse\CISXML\InternetFiling_TLB.pas',

    CISXMLWU,
    CISXMLTU,

    JobTS1U,
    JobTSI1U,
    JHistDDU,
    JCRet1U,

    JClsJIU in 'JClsJIU.pas' {JobClsInp},
    JCEmpL1U,

    JCEmpR3U,

    JCSSet1U,
    JCEmpP1U,

    JCAnlI3U,

    JChkUseU,

    SetCISU,

    {$IFDEF JAP}
      JobSup2U,
      JCAPPD2U,
      JAPLne2U,
      JobApWzU in 'JobApWzU.pas' {JobAppWizard},
      JASCLnkU,
    {$ENDIF}


  {$ENDIF}

  {$IFDEF Inv}
    Docsupu1 in 'Docsupu1.pas',
    InvFSu2U in 'Invfsu2u.pas',
    InvFSu3U in 'Invfsu3u.pas',
    CSWarnU in 'Cswarnu.pas' {CredLimForm},
    AutoTxU in 'Autotxu.pas' {AutoTxPop},
    DelAddu in 'Deladdu.pas' {DelAddrPop},
    IntStatu in 'Intstatu.pas' {IntStatInv},
    STxMenu in 'Stxmenu.pas' {InvAddForm},
    SaleTx2U in 'SaleTx2U.pas' {SalesTBody},
    TxLineU in 'Txlineu.pas' {TxLine},
    RecepU in 'Recepu.pas' {RecepForm},

    Nomtfr2u in 'Nomtfr2u.pas' {NTxfrForm},
    NomLne2U,

    PayLineU,
    Saltxl1u in 'Saltxl1u.pas',
    Saltxl2u in 'Saltxl2u.pas',
    BatchEnU,
    BatchlnU,

  {$ENDIF}

  {$IFDEF PF_On}
    {$IFDEF CC}
      CCListU,
      CCInpU,
    {$ENDIF}
  {$ENDIF}

  {$IFDEF SOP}
    SOPCT1U in 'Sopct1u.pas',
    SOPCT2U in 'Sopct2u.pas',
    SOPCT3U in 'SOPCT3U.pas',

    {$IFDEF POST}
      SOPCT4U,

    {$ENDIF}

    {*EN431MB2B*}
    SOPCT5U,
    SOPB2BWU,

  {$ENDIF}

  {$IFDEF PF_On}
    InvLst2U in 'Invlst2u.pas',
  {$ENDIF}

  MiscU in 'MiscU.pas',
  IntMU in 'IntMU.pas',

  {$IFDEF STK}
    DiscU3U in 'Discu3u.pas',
    DiscU4U in 'Discu4u.pas',
    FIFOL2U in 'Fifol2u.pas',
    InvCt2SU in 'Invct2su.pas',
    InvCtSuU in 'Invctsuu.pas',
    StkLockU,

    {$IFDEF SKL}
      StkTreeU in 'Stktreeu.pas' {StkView},
      StkLstU,
      StkTRU in 'StkTRU.pas' {StkTRI},
    {$ENDIF}

    StkAdjU,
    AdjCtrlU,
    AdjLineU,
    {StkIntU,  Embedded in stock record now}

    {$IFDEF WOP}
      WORDoc2U,
      WORLineU,
      WOPInpU,
      WORInpU,
      WORPickU,
      WORIWizU,
    {$ENDIF}

    {$IFDEF RET}
      RETDoc1U,
      RETLineU,
      RETInpU,
      RetSup1U,
      RetSup2U,
      RetWiz1U,
      RetLTR1U,
      RetLTL1U,
    {$ENDIF}


    {$IFDEF PF_On}
      StkBOMIU,
      StkValU,
      StkQtyU,

      DelQDiscU,

      CuStkA4U,
      CuStkA3U,
      CuStkA2U,
      CuStkA5U,

      CuStkL1U,
      CuStkT1U,

      StkBinU,

      {$IFNDEF SOP} {EN552 When this directive is removed, remove the Entry for BomCmpU from SOP and leave here as we need it for non SOP versions}
        BomCmpU,
      {$ENDIF}

      {$IFDEF SOP}
        StkSernU,
        PickInpU in 'PickInpU.pas' {PickInpMsg},
        DelvinpU in 'DelvinpU.pas' {SOPInpMsg},
        StkROrdr,
        StkROCtl,
        StkROFrm in 'StkROFrm.pas' {ROCtrlForm},
        SOPFOFIU in 'SOPFOFIU.pas' {SOPROFiFrm},
        MLoc0U,
        MLocMRIU,
        MLocSRIU,
        InvLst3U,
        BomCmpU,
        StkLocEU,
        StkSNRIU,
        StkSNRRU,

        {$IFDEF Frm}
          PickRunU in 'PickRunU.pas' {PickRunFrm},
          DelvRunU in 'DelvRunU.pas' {SOPRunFrm},
        {$ENDIF}

         CuStkT2U,
         CuStkT3U,
         CuStkT4U,

         BINSVCU,

         AltCLs2U,
         AltCRe2U,

      {$ENDIF}

      {$IFDEF WOP}
        WOPCT1U in 'Wopct1u.pas',
        WOBOMIsU,


      {$ENDIF}

    {$ENDIF}

  {$ENDIF}

  LedgSupU in 'Ledgsupu.pas',
  CLPalU,
  CLPalMCU,
  ConvDocU in 'Convdocu.pas',
  Recon3U in 'Recon3u.pas',
  Tranl1U in 'Tranl1u.pas',

  MatchU in 'Matchu.pas' {MatchWin},
  ObjDrilU in 'ObjDrilU.pas' {ObjDFrm},

  WizTempU in 'WizTempU.pas' {WizTemplate},

  AllocS1U in 'AllocS1U.pas',
  AllocS2U in 'AllocS2U.pas',
  AllcWizU in 'AllcWizU.pas',
  AllCIP3U in 'AllCIP3U.pas',

  {$IFDEF POST}
    PostingU,
    RevalueU,
    ReValu2U,

    MCRVCCIU,

    {$IFDEF STK}
      StkChkU,
    {$ENDIF}

    BPayLstU,
    BPyItemU,
    BPWarnUU,
    BACSIU in 'BACSIU.pas' {BatchInp},

    PostInpU in 'PostInpU.pas' {PostFilt},
    PostSp2U,

    CredPopU,

    UnpostU,
    UnPostIU,

    UnPostRU,


    {$IFDEF STK}
        ObjPrceU,
    {$ENDIF}

    {$IFDEF JC}
      JobPostU,
      JobPst2U,
      JobBudPU,
      JPstInpU in 'JPstInpU.pas' {JPostFilt},
      JCInv1U,

      {$IFDEF JAP}
        JobPAppU,
        JAPstIpU in 'JAPstIpU.pas' {JAPstIpU},
        JAPValIU in 'JAPValIU.pas' {JAPValIU},

        {$IFDEF POST}
          JCCstmWU in 'JCCstmWU.pas' {JCCstmWU},
        {$ENDIF}
      {$ENDIF}

    {$ENDIF}


    AlcItemU in 'AlcItemU.pas',
  {$ENDIF}


      RepInp1U in 'Repinp1u.pas' {RepInpMsg},
  {$IFDEF RP}

    RepInp2U in 'RepInp2U.pas' {RepInpMsg1},
    RepInp3u in 'RepInp3u.pas' {RepInpMsg3},
    RepInp4U in 'RepInp4U.pas' {RepInpMsg4},
    RepInp5U in 'RepInp5U.pas' {RepInpMsg5},
    Repinp6u in 'Repinp6u.pas' {RepInpMsg6},
    Repinp7u in 'Repinp7u.pas' {RepInpMsg7},
    Repinp8u in 'Repinp8u.pas' {RepInpMsg8},
    RepInp9U in 'RepInp9U.pas' {RepInpMsg9},
    RepInpAU in 'RepInpAU.pas' {RepInpMsgA},
    RepInpBU in 'RepInpBU.pas' {RepInpMsgB},
    RepInpEU in 'RepInpEU.pas' {RepInpMsgE},
    RepInpVU in 'RepInpVU.pas' {RepInpMsgV},
    RepInpWU in 'RepInpWU.pas' {RepInpMsgW},
    RepInpPU in 'RepInpPU.pas' {RepInpMsgP},
    RepInpQU in 'RepInpQU.pas' {RepInpMsgQ},
	//HV 06/04/2017 2017-R1 ABSEXCH-18434: New Standard Report - Customer/Supplier Transactions on Hold
   	TraderTransOnHoldReport in 'StandardReports\TraderTransOnHoldReport.Pas',
    //HV 06/04/2017 2017-R1 ABSEXCH-18436: Added New Standard Report
   	TradersOnHoldReport in 'StandardReports\TradersOnHoldReport.Pas',
   	TradersOrderReport in 'StandardReports\TradersOrderReport.Pas',
    //AP 31/07/2017 2017-R1 ABSEXCH-15994: Added New Standard Report
    ECSalesDetailedReport in 'StandardReports\ECSalesDetailedReport.Pas',

    {$IFDEF PF_On}
      RepInpFU in 'RepInpFU.pas' {RepInpMsgF},
      ReportAU,
    {$ENDIF}



    ReportU,
    Report2U,
    Report3U,
    Report4U,
    Report5U,


    Report8U,
    ReportKU,
    Report9U,

    {$IFDEF PF_On}
      {$IFDEF STK}
        ReportBU,

        RepBNSKU,
        RepInpRU,
      {$ENDIF}
    {$ENDIF}

    {$IFDEF STK}
      Report6U,
      Report7U,
      ReportCU,
      ReportDU,
      ReportEU,
      ReportFU,
      ReportGU,

      RepInpCU in 'RepInpCU.pas' {RepInpMsgC},
      RepInpDU in 'RepInpDU.pas' {RepInpMsgD},
      RepInpGU in 'RepInpGU.pas' {RepInpMsgG},
      RepInpHU in 'RepInpHU.pas' {RepInpMsgH},
      RepInpJU in 'RepInpJU.pas' {RepInpMsgJ},
      RepInpKU in 'RepInpKU.pas' {RepInpMsgK},
      RepInpLU in 'RepInpLU.pas' {RepInpMsgL},
      RepInpMU in 'RepInpMU.pas' {RepInpMsgM},
      RepInpNU in 'RepInpNU.pas' {RepInpMsgN},
      RepInpOU in 'RepInpOU.pas' {RepInpMsgO},

      {$IFDEF WOP}
        ReportWU,
        RepInpXU,
        RepInpYU,

      {$ENDIF}

      {$IFDEF RET}
        RepRet1U,
        RepIRT1U,
      {$ENDIF}

    {$ENDIF}

    ReportHU,
    ReportIU,

    {$IFDEF NOM}
      ReportJU,
    {$ENDIF}

    BACS2U,
    BACS3U in 'BACS3U.pas' {BatchRunInp},

    {$IFDEF JC}
      RepInpSU,
      RepIJCEU,
      RepJCE1U,
      RepIJCHU,
      RepJCH1U,
      RepIJCXU,
      RepJCX1U,
      RepIJCBU,
      RepJCB1U,
      RepIJCAU,
      RepJCA1U,
      RepIJCWU,
      RepJCW1U,
      RepIJCIU,
      RepJCB2U,

      RepICI1U,
      RepICI2U,
      RepJCE2U,

      RepJCE3U,

      RepICI3U,

      {$IFDEF JAP}
        RepIJCPU,
        RepJCA2U,

      {$ENDIF}

    {$ENDIF}

    RepCCShu,

    RepAlcU,

    {$IFDEF MC_On}
      ReportRV,
    {$ENDIF}

  {$ENDIF}

  ExBtTh1U,
  ExThredU,
  EXThSu1U,
  ExThrd2U,

  {$IFDEF MC_On}
    SetCurrU,
  {$ENDIF}

  SetPrU,


  {$IFDEF SY}
    AboutU in 'AboutU.pas' {AboutFrm},
    SSCustEU,
    SysSetU,
    DocNumLU,
    DocNumRU,
    SetNCC,
    ChngComp,
    PathUtil,
    Excep2U,
    Excep3U,
    AUWarnU,
  {$ENDIF}

  {$IFDEF S2}
    SecSup2U,
    HelpSupU,
    SecureU in 'SecureU.pas' {AboutFrm},
    MURelU in 'MURelU.pas' {MultiLicFrm},
    PassWR2U,
    InpPWU,
    ESecMsgU,
    SetModU,
    SYSU3,
    MCMFuncs in 'W:\Entrprse\MULTCOMP\MCMFuncs.pas',{ - shared directory selection dialog}
    ENTLic in 'W:\Entrprse\MULTCOMP\EntLic.pas',{ - shared directory selection dialog}

  {$ENDIF}

  EntLicence in 'W:\Entrprse\drilldn\EntLicence.pas', {Lic/Branding Object}

  {$IFDEF VAT}
    SetVATU,
    VATEDIWU in 'VATEDIWU.pas' {VATEDIWizard},

    {$IFDEF Rp}
      VATEDITU,

      {$IFDEF EN601VXML}
        oIrishIntrastat,
        oIrishECSales,
      {$ENDIF}
    {$ENDIF}

    GIRateU,

  {$ENDIF}

  {$IFNDEF BCS}
    ChkBCSU,
  {$ENDIF}

  {$IFDEF CU}
    CustIntU,
    CustWinU,
    CustABSU,
    CustTypU,
    OCust,
    OInv,
    OIdetail,
    OStock,
    OSetUp,
    OJob,

  {$ENDIF}

  // Consumer Ledger
  oBtrieveFile in 'W:\Entrprse\MultComp\oBtrieveFile.pas',

  // Account Multi-Contacts
  oAccountContactBtrieveFile in 'W:\Entrprse\R&D\AccountContacts\oAccountContactBtrieveFile.Pas',
  oContactRoleBtrieveFile in 'W:\Entrprse\R&D\AccountContacts\oContactRoleBtrieveFile.Pas',
  oAccountContactRoleBtrieveFile in 'W:\Entrprse\R&D\AccountContacts\oAccountContactRoleBtrieveFile.Pas',
  AccountContactRoleUtil in 'W:\Entrprse\R&D\AccountContacts\AccountContactRoleUtil.Pas',
  custRolesFrame in 'W:\Entrprse\R&D\AccountContacts\CustRolesframe.pas',
  ContactsManager in 'W:\Entrprse\R&D\AccountContacts\ContactsManager.pas',
  ContactsManagerSQL in 'W:\Entrprse\R&D\AccountContacts\ContactsManagerSQL.pas',
  ContactsManagerPerv in 'W:\Entrprse\R&D\AccountContacts\ContactsManagerPerv.pas',
  ContactEditor in 'W:\Entrprse\R&D\AccountContacts\ContactEditor.pas',

  // Prompt Payment Discount (v7.0.14)
  PromptPaymentDiscountFuncs in 'W:\Entrprse\Funcs\PromptPaymentDiscountFuncs.pas',
  oSystemSetupBtrieveFile in 'W:\SBSLib\Win\ExCommon\oSystemSetupBtrieveFile.pas',
  oSystemSetup in 'W:\SBSLib\Win\ExCommon\oSystemSetup.pas',
  oPPDLedgerTransactions in 'W:\Entrprse\R&D\PPD\oPPDLedgerTransactions.pas',
  PPDLedgerF in 'W:\Entrprse\R&D\PPD\PPDLedgerF.pas',
  oTakePPD in 'W:\Entrprse\R&D\PPD\oTakePPD.pas',

  {$IFDEF SOP}
    // Order Payments
    oOPVATPayBtrieveFile in 'W:\Entrprse\R&D\OrderPayments\oOPVATPayBtrieveFile.pas',
    oOPVATPayMemoryList in 'W:\Entrprse\R&D\OrderPayments\oOPVATPayMemoryList.pas',
    oCreditCardGateway in 'W:\Entrprse\R&D\OrderPayments\oCreditCardGateway.pas',
    OrderPaymentsInterfaces in 'W:\Entrprse\R&D\OrderPayments\OrderPaymentsInterfaces.pas',
    oOrderPaymentsBaseTransactionInfo in 'W:\Entrprse\R&D\OrderPayments\oOrderPaymentsBaseTransactionInfo.pas',
    oOrderPaymentsTransactionInfo in 'W:\Entrprse\R&D\OrderPayments\oOrderPaymentsTransactionInfo.pas',
    oOrderPaymentsTransactionPaymentInfo in 'W:\Entrprse\R&D\OrderPayments\oOrderPaymentsTransactionPaymentInfo.pas',
    RefundF in 'W:\Entrprse\R&D\OrderPayments\RefundF.pas',
    RefundPaymentFrame in 'W:\Entrprse\R&D\OrderPayments\RefundPaymentFrame.pas',
    RefundQuantityF in 'W:\Entrprse\R&D\OrderPayments\RefundQuantityF.pas',
    oOrderPaymentsRefundManager in 'W:\Entrprse\R&D\OrderPayments\oOrderPaymentsRefundManager.pas',
    PaymentF in 'W:\Entrprse\R&D\OrderPayments\PaymentF.pas',
    oOPPayment in 'W:\Entrprse\R&D\OrderPayments\oOPPayment.pas',
    oOrderPaymentsSRC in 'W:\Entrprse\R&D\OrderPayments\oOrderPaymentsSRC.pas',
    OrdPayCustomisation in 'W:\Entrprse\R&D\OrderPayments\OrdPayCustomisation.pas',
    OrderPaymentsInvoiceMatching in 'W:\Entrprse\R&D\OrderPayments\OrderPaymentsInvoiceMatching.pas',
    OrderPaymentsMatching in 'W:\Entrprse\R&D\OrderPayments\OrderPaymentsMatching.pas',
    PasswordAuthorisationF in 'W:\Entrprse\R&D\OrderPayments\PasswordAuthorisationF.pas',
    TxStatusF in 'W:\Entrprse\R&D\OrderPayments\TxStatusF.pas',
    TransCancelF in 'W:\Entrprse\R&D\OrderPayments\TransCancelF.pas',
    ExchequerPaymentGateway_TLB in 'W:\Entrprse\R&D\OrderPayments\ExchequerPaymentGateway_TLB.pas',
    System_TLB in 'W:\Entrprse\R&D\OrderPayments\System_TLB.pas',
    System_Windows_Forms_TLB in 'W:\Entrprse\R&D\OrderPayments\System_Windows_Forms_TLB.pas',
    Accessibility_TLB in 'W:\Entrprse\R&D\OrderPayments\Accessibility_TLB.pas',
    OrderPaymentsUnmatchedReceipts in 'W:\Entrprse\R&D\OrderPayments\OrderPaymentsUnmatchedReceipts.pas',
    Rep_UnmatchedSalesReceipts in 'W:\Entrprse\R&D\Rep_UnmatchedSalesReceipts.pas',
    Rep_OrderPaymentsVATReturn in 'W:\Entrprse\R&D\Rep_OrderPaymentsVATReturn.pas',
    VATReturnWizardU in 'W:\Entrprse\R&D\VATReturnWizardU.pas',
    XMLFuncs in 'W:\Entrprse\Funcs\XMLFuncs.pas',
    RepInp_EndOfDayPayments in 'W:\Entrprse\R&D\OrderPayments\RepInp_EndOfDayPayments.pas',
    Rep_EndOfDayPayments in 'W:\Entrprse\R&D\OrderPayments\Rep_EndOfDayPayments.pas',
	  OrderPaymentFuncs in 'W:\Entrprse\R&D\OrderPayments\OrderPaymentFuncs.pas',
    oOPOrderAuditNotes in 'W:\Entrprse\R&D\OrderPayments\oOPOrderAuditNotes.pas',
  	OrderPaymentsTrackerF in 'W:\Entrprse\R&D\OrderPayments\OrderPaymentsTrackerF.pas',
  {$ENDIF SOP}

  // VAT 100 Submission
  vatReturnDBManager in 'W:\Entrprse\R&D\VAT100Submission\vatReturnDBManager.pas',
  vatReturnDBManagerPerv in 'W:\Entrprse\R&D\VAT100Submission\vatReturnDBManagerPerv.pas',
  vatReturnDBManagerSQL in 'W:\Entrprse\R&D\VAT100Submission\vatReturnDBManagerSQL.pas',
  vatReturnDetail in 'W:\Entrprse\R&D\VAT100Submission\vatReturnDetail.pas',
  vatReturnHistory in 'W:\Entrprse\R&D\VAT100Submission\vatReturnHistory.pas',
  vatReturnSummary in 'W:\Entrprse\R&D\VAT100Submission\vatReturnSummary.pas',
  vatUtils in 'W:\Entrprse\R&D\VAT100Submission\vatUtils.pas',

  CountryCodes in 'W:\Entrprse\Funcs\CountryCodes.pas',
  CountryCodeUtils in 'W:\Entrprse\Funcs\CountryCodeUtils.pas',

  // Intrastat ----------------------
  IntrastatControlCentreF in 'W:\Entrprse\R&D\Intrastat\IntrastatControlCentreF.pas',
  IntrastatXML in 'W:\Entrprse\R&D\Intrastat\IntrastatXML.pas',
  IntrastatDetailsF in 'Intrastat\IntrastatDetailsF.pas' {IntrastatDetailsFrm},
  IntrastatDataClass in 'W:\Entrprse\R&D\Intrastat\IntrastatDataClass.pas',
  UKIntrastatReport in 'W:\Entrprse\R&D\Intrastat\UKIntrastatReport.pas',
  // Intrastat ----------------------

  oRCTGateway in 'W:\Entrprse\R&D\RCTGateway\oRCTGateway.pas',

  Event1U,
  ImgModu in 'ImgModu.pas' {ImageRepos: TDataModule},
  Diary in 'Diary.pas' {DiaryFrm},
  DiaryNote in 'DiaryNote.pas' {DiaryNoteFrm},
  Base36 in 'W:\Entrprse\Base36\Base36.pas',
  EParentU in 'EParentU.pas' {MainForm},
  BasePrintPreview in '..\FORMDES2\BasePrintPreview.pas' {Form_BasePrintPreview},
  PrintPreviewWizard in 'PrintPreviewWizard.pas' {Form_PrintPreviewWizard},
  AccrualRepDlg in 'AccrualRepDlg.pas' {frmAccrualRepDlg},
  // Password Complexity --------------
  AuthenticationSettingsF in 'Password Complexity\AuthenticationSettingsF.pas' {frmUserAuthenticationSettings},
  ChangePasswordF in 'Password Complexity\ChangePasswordF.pas' {frmChangePassword},
  ForgottenPasswordRequestF in 'Password Complexity\ForgottenPasswordRequestF.pas' {frmForgottenPasswordRequest},
  ImportUsersF in 'Password Complexity\ImportUsersF.pas' {frmImportUsers},
  oUserDetail in 'Password Complexity\oUserDetail.pas',
  oUserIntf in 'Password Complexity\oUserIntf.pas',
  oUserList in 'Password Complexity\oUserList.pas',
  oSQLLoadUserDetails in 'Password Complexity\oSQLLoadUserDetails.pas',
  PasswordUtil in 'Password Complexity\PasswordUtil.pas',
  AuthenticateUserUtil in 'Password Complexity\AuthenticateUserUtil.pas',    
  PasswordComplexityConst in 'Password Complexity\PasswordComplexityConst.pas',
  UserProfileF in 'Password Complexity\UserProfileF.pas' {frmUserProfile},
  UsersListF in 'Password Complexity\UsersListF.pas' {frmUserManagement},
  LoginF in 'Password Complexity\LoginF.pas' {TfrmLogin},
  //HV 16-11-2017 2018 R1, ABSEXCH-19345: GDPR Configuration Window
  GDPRConst in 'GDPR\GDPRConst.pas',
  oAnonymisationDiaryObjIntf in 'GDPR\oAnonymisationDiaryObjIntf.pas',
  oAnonymisationDiaryObjList in 'GDPR\oAnonymisationDiaryObjList.pas',
  oAnonymisationDiaryObjDetail in 'GDPR\oAnonymisationDiaryObjDetail.pas',
  oSQLLoadAnonymisationDiary in 'GDPR\oSQLLoadAnonymisationDiary.pas',
  AnonymisationControlCentreF in 'GDPR\AnonymisationControlCentreF.pas' {frmAnonymisationControlCentre},
  AnonymiseUtil in 'GDPR\AnonymiseUtil.pas',
  GDPRConfigF in 'GDPR\GDPRConfigF.pas', {TfrmGDPRConfiguration}
  oPIIScanner in 'GDPR\oPIIScanner.pas',
  PIIScannerIntf in 'GDPR\PIIScannerIntf.pas',
  PIIFieldNumbers in 'GDPR\PIIFieldNumbers.pas',
  PIITreeF in 'GDPR\PIITreeF.pas' {frmPIITree},
  PIITreePrint in 'GDPR\PIITreePrint.pas',
  oPIIDataAccess in 'GDPR\oPIIDataAccess.pas',
  oContactsFile in 'GDPR\oContactsFile.pas',
  oEbusTrans in 'GDPR\oEbusTrans.pas',
  PIIProgressF in 'GDPR\PIIProgressF.pas',

  // Export Lists -----------------------------------------
  ExportProgressF in 'ExportLists\ExportProgressF.pas',
  ExportListIntf in 'ExportListIntf.pas',
  oExcelExport in 'ExportLists\oExcelExport.pas',
  XLUtils_TLB in 'ExportLists\XLUtils_TLB.pas';


{$R *.RES}
{$R Arrows.RES}

{$IFDEF COMCU}

  {$R *.TLB}
{$ENDIF}

{$IFDEF BindingRTLI} {* Include Run time Line Information *}
  {$R *.RLI}
{$ENDIF}

// MH 30/05/2014 v7.0.10 ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

begin
  Application.Initialize;

  Application.Title := 'Exchequer';
  Application.HelpFile := 'ENTRPRSE.HLP';

  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.


