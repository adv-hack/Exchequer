unit SysSetU;

{$I DefOvr.Inc}

interface
{$WARN UNIT_PLATFORM OFF}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TEditVal, StdCtrls, BorBtns, Mask, ExtCtrls, SBSPanel, ComCtrls, BTSupU1,
  bkgroup, Menus,VarJCstU, Grids, SBSOutl,
  AuditIntf,  // CA 26/02/2013 v7.0.2 : ABSEXCH-14003 : New Audit for this screen has been done
  GlobVar,
  // MH 07/05/2016 v7.0.14 ABSEXCH-16284: Added PPD Tab
  oSystemSetup;

type
  TSysSet = class(TForm)
    PageControl1: TPageControl;
    Company: TTabSheet;
    Switches: TTabSheet;
    SLPLPage: TTabSheet;
    Bevel1: TBevel;
    ACF: TBorCheck;
    ECF: TBorCheck;
    ESF: TBorCheck;
    NTF: TBorCheck;
    DPF: TBorCheck;
    UPF: TBorCheck;
    HUF: TBorCheck;
    SPF: TBorCheck;
    UCCF: TBorCheck;
    UEF: TBorCheck;
    CMF: TBorCheck;
    HEF: TBorCheck;                           
    DEQF: TCurrencyEdit;
    Label823: Label8;
    DESPF: TCurrencyEdit;
    Label824: Label8;
    Label825: Label8;
    DecPF: TCurrencyEdit;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    ScrollBox1: TScrollBox;
    SBSBackGroup1: TSBSBackGroup;
    Label87: Label8;
    Label86: Label8;
    VATRegLab: Label8;
    Label82: Label8;
    Label88: Label8;
    Label89: Label8;
    Label813: Label8;
    SBSBackGroup2: TSBSBackGroup;
    Label85: Label8;
    VATLab1: Label8;
    Label811: Label8;
    Label812: Label8;
    SBSBackGroup3: TSBSBackGroup;
    Label819: Label8;
    Label814: Label8;
    Label84: Label8;
    Label817: Label8;
    Label818: Label8;
    ScrollBox2: TScrollBox;
    Addr1F: Text8Pt;
    Addr2F: Text8Pt;
    Addr3F: Text8Pt;
    Addr4F: Text8Pt;
    Addr5F: Text8Pt;
    CompanyF: Text8Pt;
    PhoneF: Text8Pt;
    FaxF: Text8Pt;
    VRegF: Text8Pt;
    FinYrF: TEditDate;
    LADF: TEditDate;
    PIF: TCurrencyEdit;
    PTermF: TCurrencyEdit;
    TTermF: TBorCheck;
    TCF: TSBSComboBox;
    DSRIF: Text8Pt;
    DPPIF: Text8Pt;
    MODF: TCurrencyEdit;
    W1F: Text8Pt;
    W2F: Text8Pt;
    W3F: Text8Pt;
    B3F: TCurrencyEdit;
    B2F: TCurrencyEdit;
    B1F: TCurrencyEdit;
    CCodeF: TSBSComboBox;
    SBSBackGroup8: TSBSBackGroup;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    DebML: TSBSComboBox;
    Label837: Label8;
    Label815: Label8;
    Label816: Label8;
    Label838: Label8;
    Label839: Label8;
    SBSBackGroup5: TSBSBackGroup;
    SBSBackGroup9: TSBSBackGroup;
    TT1: Text8Pt;
    TT2: Text8Pt;
    StkPage: TTabSheet;
    DIF: TBorCheck;
    QSF: TBorCheck;
    DUF: TBorCheck;
    ASF: TBorCheck;
    USSDF: TBorCheck;
    EMLLab: Label8;
    EMLF: TSBSComboBox;
    SHSSF: TBorCheck;
    SP2F: TBorCheck;
    LSF: TBorCheck;
    DCF: TBorCheck;
    FSF: TBorCheck;
    APICK: TBorCheck;
    MUF: TBorCheck;
    STF: TBorCheck;
    UP2F: TBorCheck;
    DefVFLab: Label8;
    DEFVF: TSBSComboBox;
    Bevel2: TBevel;
    UCF: TBorCheck;
    USF: TBorCheck;
    IOF: TBorCheck;
    COF: TBorCheck;
    INF: TBorCheck;
    ATF: TBorCheck;
    SQF: TBorCheck;
    SRICntF: TBorCheck;
    PTF: TBorCheck;
    URF: TBorCheck;
    AC2F: TBorCheck;
    SMF: TBorCheck;
    ConsLab: TLabel;
    CRF: TBorRadio;
    DRF: TBorRadio;
    Label840: Label8;
    TolML: TSBSComboBox;
    Label841: Label8;
    TolF: TCurrencyEdit;
    Bevel3: TBevel;
    Bevel4: TBevel;
    DTF: TBorCheck;
    UTF: TBorCheck;
    FBF: TBorCheck;
    CurVLab: Label8;
    CurVF: TSBSComboBox;
    Bevel5: TBevel;
    DYrf: TBorCheck;
    SLF: TBorCheck;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Label828: Label8;
    DefRPrn: TSBSComboBox;
    DefFPrn: TSBSComboBox;
    Label829: Label8;
    Bevel9: TBevel;
    PYRF: TBorCheck;
    Bevel10: TBevel;
    Bevel11: TBevel;
    Bevel12: TBevel;
    Bevel13: TBevel;
    Bevel14: TBevel;
    AMFLab: Label8;
    AMF: TSBSComboBox;
    JCPage: TTabSheet;
    JWF: TBorCheck;
    JUPF: TBorCheck;
    JSBF: TBorCheck;
    Bevel15: TBevel;
    Bevel16: TBevel;
    Label855: Label8;
    JPSF: Text8Pt;
    Label856: Label8;
    FaxEPage: TTabSheet;
    SBSBackGroup10: TSBSBackGroup;
    SBSBackGroup11: TSBSBackGroup;
    Label81: Label8;
    EmNameF: Text8Pt;
    Label842: Label8;
    EmAddF: Text8Pt;
    Label843: Label8;
    SMTPF: Text8Pt;
    Label844: Label8;
    EDIEMPF: TSBSComboBox;
    EMAPIChk: TBorCheck;
    Label857: Label8;
    DefEPrn: TSBSComboBox;
    DefFaxPrn: TSBSComboBox;
    Label858: Label8;
    Label859: Label8;
    FxFromF: Text8Pt;
    Label860: Label8;
    FxFrTelF: Text8Pt;
    Label861: Label8;
    EDIEMAMF: TSBSComboBox;
    Label862: Label8;
    FxDllPathF: Text8Pt;
    FxPathBtn: TButton;
    Label863: Label8;
    FMapiChk: TSBSComboBox;
    SDNTPF: TBorCheck;
    Label876: Label8;
    AgeByCB: TSBSComboBox;
    APUpLF: TBorCheck;
    WOPPage: TTabSheet;
    CBWWIPF: TBorCheck;
    CBWAF: TBorCheck;
    Label866: Label8;
    CBWSCMF: TSBSComboBox;
    BUCCF: TSBSComboBox;
    RetBinHF: TBorCheck;
    FiltSBLocF: TBorCheck;
    Label827: Label8;
    BinMaskF: Text8Pt;
    Bevel17: TBevel;
    ScrollBox3: TScrollBox;
    Label845: Label8;
    Label846: Label8;
    Label847: Label8;
    Label848: Label8;
    Label849: Label8;
    Label850: Label8;
    Label851: Label8;
    Label852: Label8;
    Label853: Label8;
    Label854: Label8;
    JC1F: Text8Pt;
    JC2F: Text8Pt;
    JC3F: Text8Pt;
    JC4F: Text8Pt;
    JC5F: Text8Pt;
    JC6F: Text8Pt;
    JC7F: Text8Pt;
    JC8F: Text8Pt;
    JC9F: Text8Pt;
    JC10F: Text8Pt;
    JC11F: Text8Pt;
    JC12F: Text8Pt;
    JC13F: Text8Pt;
    JC16F: Text8Pt;
    JC15F: Text8Pt;
    JC14F: Text8Pt;
    JC17F: Text8Pt;
    Label830: Label8;
    Label832: Label8;
    Label833: Label8;
    Label834: Label8;
    Label835: Label8;
    Label836: Label8;
    Label864: Label8;
    JSPCF: TBorCheck;
    JAPYRF: TBorCheck;
    JAIDF: TBorCheck;
    JADACF: TBorCheck;
    UGLCCB: TBorCheck;
    bevUseOverrideLocations: TBevel;
    chkUseTTD: TBorCheck;
    chkUseVBD: TBorCheck;
    ceECThreshold: TCurrencyEdit;
    lblECThreshold: Label8;
    chkECServices: TBorCheck;
    Bevel19: TBevel;
    chkUseOverrideLocations: TBorCheck;
    bevIncludeVatInCB: TBevel;
    chkIncludeVatInCB: TBorCheck;
    ExportSettings1: TMenuItem;
    N2: TMenuItem;
    Label810: Label8;
    BNF: Text8Pt;
    Label820: Label8;
    BAF: Text8Pt;
    Label821: Label8;
    BSF: Text8Pt;
    Label822: Label8;
    BRF: Text8Pt;
    Bevel20: TBevel;
    chkEnableConsumers: TBorCheck;
    SBSBackGroup4: TSBSBackGroup;
    tabshPPD: TTabSheet;
    edtExpiredColour: TEdit;
    edtRedDaysColour: TEdit;
    edtAmberDaysColour: TEdit;
    edtGreenDaysColour: TEdit;
    btnGreenDaysColour: TButton;
    btnAmberDaysColour: TButton;
    btnRedDaysColour: TButton;
    btnExpiredColour: TButton;
    Label875: Label8;
    Label874: Label8;
    Label873: Label8;
    Label83: Label8;
    udAmberDays: TUpDown;
    Bevel21: TBevel;
    udRedDays: TUpDown;
    edtRedDays: TEdit;
    edtAmberDays: TEdit;
    bevEnableOrderPayments: TBevel;
    chkEnableOrderPayments: TBorCheck;
    lblCurrImpTol: Label8;
    eCurrImportTol: TCurrencyEdit;
    SigPage: TTabSheet;
    pnlsig: TPanel;
    memEmailSig: TMemo;
    memFaxSig: TMemo;
    bvl1: TBevel;
    bvl2: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure DSRIFExit(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ScrollBox2Exit(Sender: TObject);
    procedure DEFVFEnter(Sender: TObject);
    procedure DEFVFExit(Sender: TObject);
    procedure UCCFClick(Sender: TObject);
    procedure DebMLExit(Sender: TObject);
    procedure TolMLChange(Sender: TObject);
    procedure MODFExit(Sender: TObject);
    procedure CRFClick(Sender: TObject);
    procedure CurVFExit(Sender: TObject);
    procedure FxPathBtnClick(Sender: TObject);
    procedure FMAPIChkClick(Sender: TObject);
    procedure FxDllPathFExit(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure LSFClick(Sender: TObject);
    procedure EMLFChange(Sender: TObject);
    procedure BinMaskFExit(Sender: TObject);
    procedure PYRFClick(Sender: TObject);
    procedure JAPYRFClick(Sender: TObject);
    procedure ceECThresholdKeyPress(Sender: TObject; var Key: Char);
    procedure PIFKeyPress(Sender: TObject; var Key: Char);
    procedure ExportSettings1Click(Sender: TObject);
    procedure chkEnableConsumersMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure udRedDaysClick(Sender: TObject; Button: TUDBtnType);
    procedure btnExpiredColourClick(Sender: TObject);
    procedure btnRedDaysColourClick(Sender: TObject);
    procedure btnAmberDaysColourClick(Sender: TObject);
    procedure btnGreenDaysColourClick(Sender: TObject);
    procedure edtRedDaysChange(Sender: TObject);
    procedure edtRedDaysExit(Sender: TObject);
    procedure edtAmberDaysChange(Sender: TObject);
    procedure edtAmberDaysExit(Sender: TObject);
    procedure chkEnableOrderPaymentsClick(Sender: TObject);
    procedure chkIncludeVatInCBClick(Sender: TObject);
    procedure UCFClick(Sender: TObject);
    procedure eCurrImportTolExit(Sender: TObject);
  private
    { Private declarations }
    // MH 01/20/2014 ABSEXCH-15673: Need local var to track the value due to bugs in TBorCheck
    LastEnableOrderPayments, LastIncludeVatInCB, LastUseCreditLimitCheck,
    SetUpOk,
    LastCRF,
    BeenStored,
    BeenIn,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    CanDelete,
    // SSK 06/03/2017 2017-R1 ABSEXCH-18147: LocRecFound variable used to avoid recurrent call to CheckLocRecExists
    LocRecFound
                 :  Boolean;

    LastVCur,
    LastASV      :  Integer;

    JobCatAry    :  Array[1..NofSysAnals] of Text8pt;

    //PR: 19/06/2012 Flag to indicate if IncludeVATInCommittedBalances has been changed as
    //we'll need to update the history table.  ABSEXCH-11528
    FUpdateCommittedBalances : Boolean;

    // CA 04/03/2013 v7.0.2 ABSEXCH-14003: Added the System, VAT, Job Costing Setup Audit Trail file
    SysSetAudit       : IBaseAudit;
    SysVATAudit       : IBaseAudit;
    SysJobSetupAudit  : IBaseAudit;
    SysEDIRSetupAudit : IBaseAudit;

    // MH 08/05/2015 v7.0.14 ABSEXCH-16284: Added PPD Settings
    OriginalPPDSettings : SystemSetupInternalSettingsRecType;

    //AP: 27/06/2017 2017R2:ABSEXCH-18838:System Setup � General Settings � Company Signatures
    FFiles: array [1..2] of string;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormDesign;

    procedure SetAgeX(Var  StaUI,PUI  :  Boolean;
                           Combo      :  TSBSComboBox;
                           OutMode    :  Boolean);

    procedure OutSyss;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;


    Procedure Send_UpdateList(Mode   :  Integer);

    procedure SetSyssStore(EnabFlag,
                           VOMode  :  Boolean);


    Function CheckCompleted  : Boolean;

    procedure StoreSyss;

    Function Current_Page  :  Integer;

    Procedure ChangePage(NewPage  :  Integer);

    procedure SetFormProperties;

    procedure SetFieldProperties;

    procedure SetAlTolForm;

    procedure SetDebMLCap;

    {$IFDEF MC_On}
      procedure Warn_DayRate;
      procedure Warn_VATCurr;

    {$ENDIF}

    procedure SetHelpContextIDs; // NF: 09/05/06 Fixes for incorrect Context IDs

    procedure SetPPDLimits;
    Function ValidRedDays : Boolean;
    Function ValidAmberDays : Boolean;
    function CheckLocRecExists : Boolean;

    //AP: 27/06/2017 2017R2:ABSEXCH-18838:System Setup � General Settings � Company Signatures
    procedure StoreSigs(AEditMode: Boolean);
    procedure LoadSig;
    procedure LoadText(const AIndex: Byte; AFileName1, AFileName2: ShortString; ATheMemo: TMemo);
  public
    { Public declarations }
    procedure ProcessSyss;

  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BtrvU2,
  VarConst,

  ETDateU,
  EtStrU,
  ETMiscU,
  ComnUnit,
  ComnU2,
  BTKeys1U,
  CurrncyU,
  BTSupU2,
  InvListU,
  CmpCtrlU,
  ColCtrlU,

  SendExportSettingsF,

  {$IFDEF POST}
    {$IFDEF STK}
      ReValueU,
    {$ENDIF}
  {$ENDIF}

  {$IFDEF Frm}
    PrintFrm,
  {$ENDIF}
  FileCtrl,
  GenWarnU,
  FileUtil,
  ECBUtil,

  SysU2,

  //PR: 19/06/2012 ABSEXCH-11528 v7.0
  UpdateCommitedF,
  ApiUtil,

  //PR: 09/09/2013 ABSEXCH-14598 SEPA
  EncryptionUtils,

  //PR: 12/12/2013 ABSEXCH-14835
  ConsumerUtils,

  // MH 07/05/2016 v7.0.14 ABSEXCH-16284P: Added PPD Tab
  PPDRagColourF,

  // MH 01/20/2014 ABSEXCH-15673: Added warning on Enable Order Payments checkbox
  HelpContextIds,

  //SSK 24/01/2017 2017-R1 ABSEXCH-18147: VarRec2U, SQlUtils units are added to support CheckLocRecExists routine
  VarRec2U,

  SQlUtils,

  oProcessLock;



{$R *.DFM}


Const
  TAB_COMPANY = 0;
  TAB_SYSTEMGLCURRENCY = 1;
  TAB_SLPL = 2;
  TAB_PPD = 3;
  TAB_STOCKSPOP = 4;
  TAB_JOBCOSTING = 5;
  TAB_WOP = 6;
  TAB_FAXEMAIL = 7;

procedure TSysSet.Find_FormCoord;
Var
  ThisForm:  TForm;
  GlobComp:  TGlobCompRec;
Begin

  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do
  Begin

    GetValues:=BOn;

    PrimeKey:='S';

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(CompanyF);


    SetFieldProperties;

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

end;


procedure TSysSet.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='S';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(CompanyF);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;


procedure TSysSet.FormDesign;

Begin
  VATLab1.Caption:='Default '+CCVATName^+VATLab1.Caption;

  VATRegLab.Caption:=CCVATName^+VATRegLab.Caption;

  CurVLab.Caption:='Currency of '+CCVATName^+CurVLab.Caption;

  DebML.ItemsL.Assign(DebML.Items);

  {$IFNDEF MC_On}
    CRF.Visible:=BOff;
    DRF.Visible:=BOff;
    ConsLab.Visible:=BOff;

    CurVF.Visible:=BOff;
    CurVLab.Visible:=BOff;
    TOLML.Visible:=BOff;
    TOLF.Visible:=BOff;
    Label841.Visible:=BOff;
    Label840.Visible:=BOff;


  {$ELSE}
    Set_DefaultCurr(CurVF.Items,BOn,BOff);
    Set_DefaultCurr(CurVF.ItemsL,BOn,BOn);

    CRF.Enabled:=SBSIn;
    DRF.Enabled:=SBSIn;

    CurVF.ReadOnly:=Not SBSIn;

    CurVF.TabStop:=Not CurVF.ReadOnly;

    {$IFDEF LTE}
      CRF.Visible:=BOff;
      DRF.Visible:=BOff;
      ConsLab.Visible:=BOff;

      CurVF.Visible:=BOff;
      CurVLab.Visible:=BOff;
      TOLML.Visible:=BOff;
      TOLF.Visible:=BOff;
      Label841.Visible:=BOff;
      Label840.Visible:=BOff;


    {$ENDIF}

  {$ENDIF}


  {$IFDEF LTE}
    CustomPage440.TabVisible:=BOff;
    FaxEPage.Caption:='Paperless';
    SBSBackGroup11.Visible:=BOff;
    Label858.Visible:=BOff;
    DefFaxPrn.Visible:=BOff;
    Label863.Visible:=BOff;
    FMapiChk.Visible:=BOff;
    Label859.Visible:=BOff;
    FxFromF.Visible:=BOff;
    Label860.Visible:=BOff;
    FxFrTelF.Visible:=BOff;
    Label862.Visible:=BOff;
    FxDllPathF.Visible:=BOff;
    FxPathBtn.Visible:=BOff;
    ECF.Visible:=BOff;
    ESF.Visible:=BOff;
    UEF.Visible:=BOff;
    SMF.Visible:=BOff;
    SHSSF.Visible:=BOff;
    DIF.Visible:=BOff;

    // MH 21/07/2010 v6.4 ABSEXCH-2280: Removed from v6.4 as not supported since v6.00
    //UECL1.Caption:='Use Classic Toolbar';
    //UECL1.Visible:=BOff;

    COF.Visible:=BOff;
    HEF.Caption:='Hide Background Logo';
    UGLCCB.Visible:=BOff;
    SHSSF.Visible:=BOff;
  {$ENDIF}

  {$IFNDEF STK}
    DIF.Visible:=BOff;
    FSF.Visible:=BOff;
    MUF.Visible:=BOff;
    QSF.Visible:=BOff;
    SP2F.Visible:=BOff;
    LSF.Visible:=BOff;
    DefVF.Visible:=BOff;
    DefVFLab.Visible:=BOff;
    QSF.Visible:=BOff;
    DUF.Visible:=BOff;
    DCF.Visible:=BOff;
    USSDF.Visible:=BOff;
    STF.Visible:=BOff;
    UP2F.Visible:=BOff;
    SDNTPF.Visible:=BOff;
    ASF.Visible:=BOff;
   { SUd1Lab.Visible:=BOff;
    SUd2Lab.Visible:=BOff;
    SUd3Lab.Visible:=BOff;
    SUd4Lab.Visible:=BOff;
    UDS1F.Visible:=BOff;
    UDS2F.Visible:=BOff;
    UDS3F.Visible:=BOff;
    UDS4F.Visible:=BOff;}
    EMLF.Visible:=BOff;
    EMLLab.Visible:=BOff;
    SHSSF.Visible:=BOff;
    PYRF.Visible:=BOff;

    {With SUDBG do
    Begin
      Caption:='';
      Height:=0;
      Width:=0;
    end; {With..}

    StkPage.TabVisible:=BOff;

  {$ELSE}
    Set_DefaultVal(DefVF.Items,BOff,BOff,BOn);
    Set_DefaultVal(DefVF.ItemsL,BOff,BOff,BOn);

    DefVFLab.Visible:=FullStkSysOn and (ICEDFM=0);
    DefVF.Visible:=FullStkSysOn and (ICEDFM=0);
    DIF.Visible:=FullStkSysOn;
    FSF.Visible:=FullStkSysOn;
    APick.Visible:=FullStkSysOn;
    QSF.Visible:=FullStkSysOn;
    RetBinHF.Visible:=FullStkSysOn;
    FiltSBlocF.Visible:=FullStkSysOn;
    Label827.Visible:=FullStkSysOn;
    BinMaskF.Visible:=FullStkSysOn;
    LSF.Visible:=FullStkSysOn;
    Bevel14.Visible:=FullStkSysOn;
    Bevel17.Visible:=FullStkSysOn;
    Bevel12.Visible:=FullStkSysOn;
    Bevel11.Visible:=FullStkSysOn;

    // PKR. 11/01/2016. ABSEXCH-17097. Intrastat.
    // For UK Companies only, the 'Use EC SDD/Intrastat Fields' flag on the 'Stock/SPOP' tab
    // will be hidden as it is now located in the Intrastat Control Centre.
    USSDF.Visible:=FullStkSysOn and (CurrentCountry <> UKCCode);

    QSF.Visible:=FullStkSysOn;
    DUF.Visible:=FullStkSysOn;
    DCF.Visible:=FullStkSysOn;
    STF.Visible:=FullStkSysOn;
    SDNTPF.Visible:=FullStkSysOn;
    EMLF.Visible:=FullStkSysOn;
    EMLLab.Visible:=FullStkSysOn;

    {$IFNDEF LTE}
      SHSSF.Visible:=FullStkSysOn;
    {$ENDIF}

    {$IFNDEF SOP}
      FSF.Visible:=BOff;
      APick.Visible:=BOff;
      STF.Visible:=BOff;
      SDNTPF.Visible:=BOff;
    {$ENDIF}

    {$IFDEF LTE}
      LSF.Visible:=BOff;
      RetBinHF.Visible:=BOff;
      FiltSBlocF.Visible:=BOff;
      Label827.Visible:=BOff;
      BinMaskF.Visible:=BOff;
      Bevel14.Visible:=BOff;
      EMLLab.Visible:=BOff;
      EMLF.Visible:=BOff;
      Up2F.Visible:=BOff;

    {$ENDIF}

  {$ENDIF}

  {$IFNDEF SOP}
    Bevel14.Visible:=BOff;
    chkUseTTD.Visible:=BOff;
    chkUseVBD.Visible:=BOff;
  {$ENDIF}

  {$IFDEF JC}
    JCPage.TabVisible:=JBCostOn;
  {$ELSE}
    JCPage.TabVisible:=BOff;
  {$ENDIF}


  {$IFDEF WOP}
    WOPPage.TabVisible:=WOPOn;

    {$B-}  {Can only be changed with an empty daybook}
      CBWWIPF.Visible:=FullWOP;

      CBWWIPF.Tag:=Ord(Not CheckRecExsists(FullNomKey(WORUPRunNo),InvF,InvRNoK));

    {$B+}

  {$ELSE}
    WOPPage.TabVisible:=BOff;


  {$ENDIF}


  {$IFDEF STK}

    {$IFNDEF PF_On}
      QSF.Visible:=BOff;
      DUF.Visible:=BOff;
      DCF.Visible:=BOff;
      USSDF.Visible:=BOff;
      STF.Visible:=BOff;
      UP2F.Visible:=BOff;
      SDNTPF.Visible:=BOff;

    {$ELSE}


    {$ENDIF}

    {$IFNDEF SOP}
      EMLF.Visible:=BOff;
      EMLLab.Visible:=BOff;
      SHSSF.Visible:=BOff;
      PYRF.Visible:=BOff;

    {$ENDIF}


  {$ENDIF}

  {$IFNDEF PF_On}
     AMF.Visible:=BOff;
     AMFLab.Visible:=BOff;
     SMF.Visible:=BOff;
     BUCCF.Visible:=BOff;
  {$ENDIF}

  CompanyF.Tag:=Ord(SBSIn);


  //PR: 05/05/2015 v7.0.14 PPD T2-118 Remove references to settlement discount
  //SDiscF.DisplayFormat:=GenPcntMask;
  Set_DefaultVAT(TCF.Items,BOn,BOff);
  Set_DefaultVAT(TCF.ItemsL,BOn,BOn);


  //  SDaysF.BlockNegative:=BOn;

  PTermF.BlockNegative:=BOn;

  DecPF.BlockNegative:=BOn;
  DeSPF.BlockNegative:=BOn;
  DeQF.BlockNegative:=BOn;

  With CCodeF do
    ItemsL.Assign(Items);

  With AMF do
    ItemsL.Assign(Items);


  {$IFDEF JC}
    JobCatAry[1]:=JC1F;
    JobCatAry[2]:=JC2F;
    JobCatAry[3]:=JC3F;
    JobCatAry[4]:=JC4F;
    JobCatAry[5]:=JC5F;
    JobCatAry[6]:=JC6F;
    JobCatAry[7]:=JC7F;
    JobCatAry[8]:=JC8F;
    JobCatAry[9]:=JC9F;
    JobCatAry[10]:=JC10F;

    JobCatAry[11]:=JC11F;
    JobCatAry[12]:=JC12F;
    JobCatAry[13]:=JC13F;
    JobCatAry[14]:=JC14F;
    JobCatAry[15]:=JC15F;
    JobCatAry[16]:=JC16F;
    JobCatAry[17]:=JC17F;
  {$ENDIF}


  If (Not eBusModule) then
  Begin

  end;

  If (Not eCommsModule) then
  Begin
    Label858.Visible:=BOff;
    Label859.Visible:=BOff;
    Label860.Visible:=BOff;
    DefFaxPrn.Visible:=BOff;
    FMAPIChk.Visible:=BOff;
    Label863.Visible:=BOff;
    FxFromF.Visible:=BOff;
    FxFrTelF.Visible:=BOff;
    Label857.Visible:=BOff;
    DefEPrn.Visible:=BOff;
    Label861.Visible:=BOff;
    EDIEMAMF.Visible:=BOff;
    FxDLLPathF.Visible:=BOff;
    Label862.Visible:=BOff;
    FxPathBtn.Visible:=BOff;
    SBSBackGroup11.Visible:=BOff;

  end;

  //PR: 26/08/2009 New EC fields currently only visible for UK companies.
  lblECThreshold.Visible := Syss.USRCntryCode = UKCCode;
  ceECThreshold.Enabled := Syss.USRCntryCode = UKCCode;
  ceECThreshold.Visible := Syss.USRCntryCode = UKCCode;

  //PR: 19/02/2014 ABSEXCH-15042 Add service handling for Ireland
  chkECServices.Enabled := (Syss.USRCntryCode = UKCCode) or (Syss.USRCntryCode = IECCode);
  chkECServices.Visible := chkECServices.Enabled;

  // MH 21/07/2014: Order Payments - SPOP Only, initally UK Companies Only and not Cash Accounting
  chkEnableOrderPayments.Visible := {$IFNDEF SOP}False And {$ENDIF}
                                    (CurrentCountry = UKCCode) And
                                    (Not VAT_CashAcc(SyssVAT.VATRates.VATScheme));
  bevEnableOrderPayments.Visible := chkEnableOrderPayments.Visible;

  // SSK 30/01/2017 2017-R1 ABSEXCH-18147: Disable Multi Location drop-down list if location or stock-location record exist
  if EMLF.visible then
  begin
    LocRecFound := CheckLocRecExists;
    EMLF.Enabled := not LocRecFound;
  end;

end;


Procedure TSysSet.WMCustGetRec(Var Message  :  TMessage);
Begin
  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of


     175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);
              {ChangePage(GetNewTabIdx(PageControl1,LParam));}



    end; {Case..}

  end;
  Inherited;
end;

{ == Proc to resolve Sales & Purch Modes == }


procedure TSysSet.SetAgeX(Var  StaUI,PUI  :  Boolean;
                               Combo      :  TSBSComboBox;
                               OutMode    :  Boolean);

Begin
  With Combo do
  If (OutMode) then
  Begin
    StaUI:=(ItemIndex=1) or (ItemIndex=3);
    PUI:=(ItemIndex=2) or (ItemIndex=3);
  end
  else
  Begin
    ItemIndex:=(1*Ord(StaUI))+(2*Ord(PUI));
  end;

end;

procedure TSysSet.OutSyss;
Var
  n  :  Byte;


Begin
  With Syss do
  Begin
    CompanyF.Text:=UserName;
    Addr1F.Text:=DetailAddr[1];
    Addr2F.Text:=DetailAddr[2];
    Addr3F.Text:=DetailAddr[3];
    Addr4F.Text:=DetailAddr[4];
    Addr5F.Text:=DetailAddr[5];

    PhoneF.Text:=DetailTel;
    FaxF.Text:=DetailFax;
    VRegF.Text:=UserVATReg;

    CCodeF.ItemIndex:=CCode2I(UsrCntryCode);

    PIF.Value:=PrInYr;

    FinYrF.DateValue:=MonWk1;
    LADF.DateValue:=AuditDate;

    //PR: 05/05/2015 v7.0.14 PPD T2-118 Remove references to settlement discount
{    SDiscF.Value:=SettleDisc;
    SDaysF.Value:=SettleDays;}
    PTermF.Value:=PayTerms;
    TTermF.Checked:=TradeTerm;
    TT1.Text:=TermsofTrade[1];
    TT2.Text:=TermsofTrade[2];


    If (VATCode In VATSet) then
      TCF.ItemIndex:=GetVATIndex(VATCode);

    DSRIF.Text:=DirectCust;
    DPPIF.Text:=DirectSupp;
    MODF.Value:=WKSODue;
    B1F.Value:=DebTrig[1];
    B2F.Value:=DebTrig[2];
    B3F.Value:=DebTrig[3];
    DebML.ItemIndex:=DebtLMode;

    SetDebMLCap;

    W1F.Text:=SyssForms.FormDefs.PrimaryForm[38];
    W2F.Text:=SyssForms.FormDefs.PrimaryForm[39];
    W3F.Text:=SyssForms.FormDefs.PrimaryForm[40];

    BNF.Text:=UserBank;

    //PR: 09/09/2013 ABSEXCH-14598 SEPA
    BAF.Text:= DecryptBankAccountCode(ssBankAccountCode);
    BSF.Text:= DecryptBankSortCode(ssBankSortCode);

    BRF.Text:=UserRef;


    ECF.Checked:=ExternCust;
    NTF.Checked:=TradCodeNum;
    ESF.Checked:=ExternSIN;
    UEF.Checked:=TxLateCr;
    HEF.Checked:=HideExLogo;

    // MH 21/07/2010 v6.4 ABSEXCH-2280: Removed from v6.4 as not supported since v6.00
    //UECL1.Checked:=UseClassToolB;

    CMF.Checked:=ConsvMem;
    UCCF.Checked:=UseCCDep;
    UPF.Checked:=UsePassWords;
    HUF.Checked:=HideMenuOpt;
    DPF.Checked:=PrevPrOff;
    SPF.Checked:=AutoPrCalc;
    UTF.Checked:=UpBalOnPost;
    SLF.Checked:=SepDiscounts;
    ACF.Checked:=AutoClearPay;
    FBF.Checked:=UseBatchTot;
    DTF.Checked:=DefPCDisc;

    UCF.Checked:=UseCRLimitChk;
    // MH 01/20/2014 ABSEXCH-15673: Need local var to track the value due to bugs in TBorCheck
    LastUseCreditLimitCheck := UseCRLimitChk;

    USF.Checked:=UseCreditChk;
    IOF.Checked:=StopBadDr;
    COF.Checked:=LiveCredS;
    //DSF.Checked:=NoHoldDisc;  // SSK 25/01/2017 2017-R1 ABSEXCH-18144: Syss.NoHoldDisc commented as this field is no more relevant
    INF.Checked:=IncNotDue;
    ATF.Checked:=AutoNotes;

    SetAgeX(StaUIDate,PurchUIDate,AgeByCB,BOff);

    //ABF.Checked:=StaUIDate;

    SQF.Checked:=QuoOwnDate;
    SRICntF.Checked:=DirOwnCount;
    PtF.Checked:=PrintReciept;
    URF.Checked:=UsePayIn;
    AC2F.Checked:=AutoCQNo;
    SMF.Checked:=BatchPPY;
    DIF.Checked:=UseStock;
    QSF.Checked:=QuAllocFlg;
    DUF.Checked:=AutoBillUp;
    ASF.Checked:=AnalStkDesc;
    USSDF.Checked:=IntraStat;
    SP2F.Checked:=ShowStkGP;
    LSF.Checked:=AutoValStk;
    DCF.Checked:=DeadBOM;
    FSF.Checked:=FreeExAll;
    MUF.Checked:=ManROCP;
    STF.Checked:=DelPickOnly;

    SDNTPF.Checked:=SDNOwnDate;

    UP2F.Checked:=InpPack;
    JWF.Checked:=WarnJC;
    DYrF.Checked:=WarnYRef;
    APick.Checked:=UsePick4All;

    {$IFDEF WOP}
      CBWAF.Checked:=UseWIss4All;
      CBWWIPF.Checked:=UseSTDWOP;

      CBWSCMF.ItemIndex:=WOPStkCopMode;
    {$ENDIF}

    DecPF.Value:=NoCosDec;
    DeSPF.Value:=NoNetDec;
    DeQF.Value:=NoQtyDec;

    UGLCCB.Checked:=UseGLClass;

    {$IFDEF MC_On}
      DRF.Checked:=UseCoDayRate;
      CRF.Checked:=Not DRF.Checked;
      LastCRF:=CRF.Checked;

      CurVF.ItemIndex:=VATCurr;
      LastVCur:=VATCurr;

    {$ELSE}
      LastCRF:=BOff;
    {$ENDIF}

    {$IFDEF STK}
      DefVF.ItemIndex:=StkVM2I(AutoStkVal);

      PYRF.Checked:=ProtectYRef;

      APUpLF.Checked:=Syss.UseUpliftNC;
      APUPLF.Enabled:=LSF.Checked;

      RetBinHF.Checked:=Syss.KeepBinHist;
      FiltSBLocF.Visible:=Syss.UseMLoc and FullStkSysOn ;
      FiltSBLocF.Checked:=Syss.FiltSNoBinLoc;
      BinMaskF.Text:=Syss.BinMask;
    {$ENDIF}

    {$IFDEF LTE}
      APUpLF.Visible:=BOff;
    {$ENDIF}


    If (UseLocDel) then
      EMLF.ItemIndex:=2
    else
      EMLF.ItemIndex:=Ord(UseMLoc);
    { SSK 06/03/2017 2017-R1 ABSEXCH-18147: If Multi Location is Disabled but there are location or stock location records in the system, you are not able to exit the General Settings window
      due to the Warning message or change the Multi Location option due to it being diasbled.
      to avoid above scenario following change done}
    if LocRecFound and (EMLF.ItemIndex = 0) then
      EMLF.Enabled := True;

    // MH 11/10/2010 v6.5: Added for Override Location on TH (for LIVE)
    chkUseOverrideLocations.Visible := EMLF.Visible And (EMLF.ItemIndex=1);
    bevUseOverrideLocations.Visible := chkUseOverrideLocations.Visible;
    chkUseOverrideLocations.Checked := EnableOverrideLocations;

    // MH 05/09/2013 v7.XMRD MRD1.1.10: Added Consumer Support
    chkEnableConsumers.Checked := ssConsumersEnabled;
    BUCCF.ItemIndex:=Ord(PostCCNom)+Ord(PostCCDCombo);

    // MH 21/07/2014: Order Payments
    If chkEnableOrderPayments.Enabled Then
      chkEnableOrderPayments.Checked := ssEnableOrderPayments;
    // MH 01/20/2014 ABSEXCH-15673: Need local var to track the value due to bugs in TBorCheck
    LastEnableOrderPayments := chkEnableOrderPayments.Checked;
    
    BUCCF.Enabled:=UseCCDep;

    SHSSF.Checked:=EditSinSer;

    AMF.ItemIndex:=AMethod2I(AuthMode);

    TolML.ItemIndex:=AlTolMode;
    TolF.Value:=AlTolVal;
    


    SetAlTolForm;

    {$IFDEF SOP}
      chkUseTTD.Checked := EnableTTDDiscounts;
      chkUseVBD.Checked := EnableVBDDiscounts;
    {$ENDIF}

    //PR: 19/06/2012 Added IncludeVATInCommittedBalance flag v7.0 ABSEXCH-11528
    chkIncludeVATInCB.Checked := IncludeVATInCommittedBalance;
    // MH 01/20/2014 ABSEXCH-15673: Need local var to track the value due to bugs in TBorCheck
    LastIncludeVatInCB := chkIncludeVATInCB.Checked;


    With SyssVAT.VATRates do
    Begin



      {$IFDEF Frm}
        {$IFDEF DBD}  {*EN440PWTREE*}
          pfSet_NDPDefaultPrinter(DefRPrn,ReportPrnN,1);
          pfSet_NDPDefaultPrinter(DefFPrn,FormsPrnN,1);

          If (DefRPrn.ItemIndex<0) then
            DefRPrn.ItemIndex:=0;

          If (DefFPrn.ItemIndex<0) then
            DefFPrn.ItemIndex:=0;

          If (ReportPrnN<>'') then
            DefRPrn.Text:=ReportPrnN;

          If (FormsPrnN<>'') then
            DefFPrn.Text:=FormsPrnN;


        {$ELSE}
          pfSet_DefaultPrinter(DefRPrn,ReportPrnN);
          pfSet_DefaultPrinter(DefFPrn,FormsPrnN);

        {$ENDIF}
      {$ENDIF}

      //PR: 26/08/2009 Added v6.2 EC Fields
      ceECThreshold.Value := ECSalesThreshold;
      chkECServices.Checked := EnableECServices;
    end;

    {$IFDEF JC}
      With SyssJob^.JobSetUp do
      Begin
        JUPF.Checked:=GenPPI;
        JSBF.Checked:=PeriodBud;
        JPSF.Text:=PPIAcCode;

        For n:=Low(JobCatAry) to High(JobCatAry) do
        Begin
          JobCatAry[n].Text:=SummDesc[n];
        end;

        JSPCF.Checked:=JCCommitPin;
        JAIDF.Checked:=JAInvDate;
        JADACF.Checked:=JADelayCert;
      end;

      JAPYRF.Checked:=ProtectYRef;
    {$ENDIF}

    With SyssEDI2^.EDI2Value do
    Begin
      EMNameF.Text:=EMName;
      EMAddF.Text:=EMAddress;
      SMTPF.Text:=EMSMTP;

      EDIEMPF.ItemIndex:=EMPriority;


      EMAPIChk.Checked:=EMUseMAPI;

      FMAPIChk.ItemIndex:=FxUseMAPI;

      {* Reset read only attributes depending on mapi setting*}

      FMAPIChkClick(nil);

      EDIEMAMF.ItemIndex:=EMAttchMode;

      {$IFDEF Frm}
        pfSet_DefaultPrinter(DefEPrn,EmailPrnN);
        pfSet_DefaultPrinter(DefFaxPrn,FaxPrnN);
      {$ENDIF}

      FxFromF.Text:=FxName;
      FxFrTelF.Text:=FxPhone;
      FxDLLPathF.Text:=FaxDLLPath;
    end;
  end;

  // MH 07/05/2016 v7.0.14 ABSEXCH-16284P: Added PPD Tab
  With SystemSetup(True) Do // Refresh the SystemSetup settings
  Begin
    // Store a copy of the original values so we can check for changes to be saved if they
    // click the OK button - updating everything automatically would take too long
    OriginalPPDSettings := AuditData^;

    udRedDays.Position := PPD.PPDRedDays;
    SetPPDLimits;

    // Note: Need to set text as well otherwise the text doesn't get set properly for SetPPDLimits
    edtAmberDays.Text := IntToStr(PPD.PPDAmberDays);
    udAmberDays.Position := PPD.PPDAmberDays;
    SetPPDLimits;

    edtExpiredColour.Color := PPD.PPDExpiredColours.poBackgroundColour;
    edtExpiredColour.Font.Color := PPD.PPDExpiredColours.poFontColour;
    edtExpiredColour.Font.Style := PPD.PPDExpiredColours.poFontStyle;
    edtRedDaysColour.Color := PPD.PPDRedColours.poBackgroundColour;
    edtRedDaysColour.Font.Color := PPD.PPDRedColours.poFontColour;
    edtRedDaysColour.Font.Style := PPD.PPDRedColours.poFontStyle;
    edtAmberDaysColour.Color := PPD.PPDAmberColours.poBackgroundColour;
    edtAmberDaysColour.Font.Color := PPD.PPDAmberColours.poFontColour;
    edtAmberDaysColour.Font.Style := PPD.PPDAmberColours.poFontStyle;
    edtGreenDaysColour.Color := PPD.PPDGreenColours.poBackgroundColour;
    edtGreenDaysColour.Font.Color := PPD.PPDGreenColours.poFontColour;
    edtGreenDaysColour.Font.Style := PPD.PPDGreenColours.poFontStyle;

    //SS:26/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.
    eCurrImportTol.Value :=  CurrencySetup.ssCurrImportTol;

  End; // With SystemSetup(True)

  SetUpOk:=BOn;
end;

procedure TSysSet.FormCreate(Sender: TObject);
Var
  Locked     : Boolean;
  lOriginalTransaction : InvRec;

Begin
  InSysSS:=BOn;

  BeenIn:=BOff;


  SetUpOk:=BOff;
  BeenStored:=BOff;

  // CA 04/03/2013 v7.0.2 ABSEXCH-14003: Initialising 
  SysSetAudit := NIL;
  SysVATAudit := NIL;
  SysJobSetupAudit  := NIL;
  SysEDIRSetupAudit := Nil;

  //AP: 27/06/2017 2017R2:ABSEXCH-18838:System Setup � General Settings � Company Signatures
  FFiles[1] := '';
  FFiles[2] := '';

//  Height:=397;
//  Width:=478;
  ClientHeight:=370;
  ClientWidth:=471;

  MDI_SetFormCoord(TForm(Self));

  Locked:=BOff;

  GetMultiSys(BOff,Locked,SysR);
  GetMultiSys(BOff,Locked,VATR);

  {$IFDEF JC}
    GetMultiSys(BOff,Locked,JobSR);
  {$ENDIF}

  GetMultiSys(BOff,Locked,EDI2R);

  GetMultiSys(BOff,Locked,CstmFR);
  GetMultiSys(BOff,Locked,CstmFR2);

  ChangePage(0);
  HorzScrollBar.Position:=0;

  // CA 04/03/2013 v7.0.2 ABSEXCH-14003: Setting up the before fields
  SysSetAudit := NewAuditInterface(atSysSetup);
  SysSetAudit.BeforeData := @Syss;

  SysVATAudit := NewAuditInterface(atSysVAT);
  SysVATAudit.BeforeData := SyssVAT;

  {$IFDEF JC}
    SysJobSetupAudit := NewAuditInterface(atNCCJobSetup);
    SysJobSetupAudit.BeforeData := SyssJob;
  {$ENDIF}

  SysEDIRSetupAudit := NewAuditInterface(atEDIRSysSetup);
  SysEDIRSetupAudit.BeforeData := SyssEDI2;

  Find_FormCoord;

  // MH 27/11/2015: Modified to cache and restore the entire transaction instead of just the
  // OurRef as I was nervous about leaving Inv containing a WOR (or other) with the wrong
  // OurRef in it.

  //ABSEXCH-16872:Issue on Allocation List, where on opening system set up to check 'PPD Status Indicator' and re-clicking on list WOR window opens.
  lOriginalTransaction := Inv;  // Store Transaction to be restore later.
  try
    FormDesign;
  finally
    Inv := lOriginalTransaction; // Restore Transaction that has been changed internally be the FormDesign method.
  end;

  OutSyss;

  //GS 30/03/2012 if the user has EProcurement enabled; then disable the 'Use Override Locations' option
  if(WebExtEProcurementOn = true) then
  begin
    chkUseOverrideLocations.enabled := false;
  end;//end if

  //PR: 19/06/2012 ABSEXCH-11528
  FUpdateCommittedBalances := False;

  //PR: 20/08/2012 ABSEXCH-13320 Hide Include Vat in Committed Balances checkbox if we don't have SPOP
  {$IFNDEF SOP}
   chkIncludeVatInCB.Visible := False;
   bevIncludeVatInCB.Visible := False;
  {$ENDIF}

  //AP: 27/06/2017 2017R2:ABSEXCH-18838:System Setup � General Settings � Company Signatures
  LoadSig;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TSysSet.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


procedure TSysSet.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  InSysSS:=BOff;
  Store_FormCoord(Not SetDefault);
  Send_UpdateList(53);
end;

procedure TSysSet.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  LStatus  :  Integer;
  iPos   :  Integer;


begin
  Action:=caFree;

  // CA 27/02/2013 v7.0.2 ABSEXCH-14003: Initialising
  SysSetAudit := NIL;
  SysVATAudit := NIL;
  SysJobSetupAudit  := NIL;
  SysEDIRSetupAudit := NIL;

  If (Not BeenStored) then
  Begin
    LStatus:=UnlockMultiSing(F[SysF],SysF,SysAddr[SysR]);
    LStatus:=UnlockMultiSing(F[SysF],SysF,SysAddr[VATR]);

    {$IFDEF JC}
       LStatus:=UnlockMultiSing(F[SysF],SysF,SysAddr[JobSR]);
    {$ENDIF}
  end;

  //PR: 21/02/2017 ABSEXCH-18345 The following code had been moved into
  //               (Not BeenStored) section, so was no longer called when
  //               OK clicked.
  //PR: 19/06/2012 ABSEXCH-11528
  if FUpdateCommittedBalances then
    UpdateCommittedValues;

  //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Release process lock
  SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plSystemSetup), 0);
end;
procedure TSysSet.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TSysSet.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TSysSet.SetSyssStore(EnabFlag,
                                  VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  OkCP1Btn.Enabled:=Not VOMode and (ICEDFM=0) ;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    Begin
      If (Text8Pt(Components[Loop]).Tag=1) then
        Text8Pt(Components[Loop]).ReadOnly:= VOMode;
    end
      else
        If (Components[Loop] is TEditDate) then
        Begin
          If (TEditDate(Components[Loop]).Tag=1) then
            TEditDate(Components[Loop]).ReadOnly:= VOMode;
        end
        else
          If (Components[Loop] is TEditPeriod) then
          Begin
            If (TEditPeriod(Components[Loop]).Tag=1) then
              TEditPeriod(Components[Loop]).ReadOnly:= VOMode;
          end
          else
            If (Components[Loop] is TCurrencyEdit) then
            Begin
              If (TCurrencyEdit(Components[Loop]).Tag=1) then
                TCurrencyEdit(Components[Loop]).ReadOnly:= VOMode;
            end
            else
              If (Components[Loop] is TBorCheck) then
              Begin
                If (TBorCheck(Components[Loop]).Tag=1) then
                  TBorCheck(Components[Loop]).Enabled:= Not VOMode;
              end
              else
                If (Components[Loop] is TBorRadio) then
                Begin
                  If (TBorRadio(Components[Loop]).Tag=1) then
                    TBorCheck(Components[Loop]).Enabled:= Not VOMode;
                end
                else
                  If (Components[Loop] is TSBSComboBox) then
                  Begin
                    If (TSBSComboBox(Components[Loop]).Tag=1) then
                      TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
                  end;
  end; {Loop..}

  {$IFDEF MC_On}
    If (Not VOMode) then
    Begin
      CRF.Enabled:=SBSIn;
      DRF.Enabled:=SBSIn;

      {CurVF.Enabled:=SBSIn;}

      CurVF.ReadOnly:=Not SBSIn;

      CurVF.TabStop:=Not CurVF.ReadOnly;

      {$IFDEF DBD}
         CCodeF.ReadOnly:=BOff;
      {$ENDIF}

    end;
  {$ENDIF}
end;



procedure TSysSet.ProcessSyss;


Var
  Locked  :  Boolean;
Begin
  Locked:=BOn;

  If (GetMultiSys(BOff,Locked,SysR)) and (Locked) then
  Begin
    If (GetMultiSys(BOff,Locked,VATR)) and (Locked) then

      {$IFDEF JC}
         If (GetMultiSys(BOff,Locked,JobSR)) and (Locked) then
      {$ENDIF}

           If (GetMultiSys(BOff,Locked,EDI2R)) and (Locked) then
             If (GetMultiSys(BOff,Locked,CstmFR)) and (Locked) then
               If (GetMultiSys(BOff,Locked,CstmFR2)) and (Locked) then


             SetSyssStore(BOn,BOff);
  end;
end;

procedure TSysSet.StoreSyss;

Var
  Res : Integer;
  n  :  Byte;

  //------------------------------

  // MH 08/05/2015 v7.0.14 ABSEXCH-16284: Added PPD Settings
  Procedure UpdateSystemSetupValue (Var Res : Integer; Const FieldIdx : TSystemSetupFieldIds; Const BeforeValue, AfterValue, ErrorDesc : String);
  Begin // UpdateSystemSetupValue
    If (Res = 0) And (BeforeValue <> AfterValue) Then
    Begin
      Res := SystemSetup.UpdateValue (FieldIdx, BeforeValue, AfterValue);
      If (Res = 2) Then
        MessageDlg ('Error - another user has already changed the ' + ErrorDesc + ', please re-open the window and try again', mtError, [mbOK], 0)
      Else If (Res > 0) Then
        MessageDlg ('An error ' + IntToStr(Res) + ' occurred updating the ' + ErrorDesc, mtError, [mbOK], 0);
    End; // If (Res = 0) And (BeforeValue <> AfterValue)
  End; // UpdateSystemSetupValue

  //------------------------------

Begin
  With Syss do
  Begin
    UserName:=CompanyF.Text;

    DetailAddr[1]:=Addr1F.Text;
    DetailAddr[2]:=Addr2F.Text;
    DetailAddr[3]:=Addr3F.Text;
    DetailAddr[4]:=Addr4F.Text;
    DetailAddr[5]:=Addr5F.Text;

    DetailTel:=PhoneF.Text;
    DetailFax:=FaxF.Text;
    UserVATReg:=VRegF.Text;

    UsrCntryCode:=I2CCode(CCodeF.ItemIndex);

    PrInYr:=Round(PIF.Value);

    MonWk1:=FinYrF.DateValue;
    AuditDate:=LADF.DateValue;

    //PR: 05/05/2015 v7.0.14 PPD T2-118 Remove references to settlement discount
{    SettleDisc:=SDiscF.Value;
    SettleDays:=Round(SDaysF.Value);}
    PayTerms:=Round(PTermF.Value);
    TradeTerm:=TTermF.Checked;
    TermsofTrade[1]:=TT1.Text;
    TermsofTrade[2]:=TT2.Text;

    With TCF do
      VATCode:=Items[ItemIndex][1];


    DirectCust:=DSRIF.Text;
    DirectSupp:=DPPIF.Text;
    WKSODue:=Round(MODF.Value);
    DebTrig[1]:=Round(B1F.Value);
    DebTrig[2]:=Round(B2F.Value);
    DebTrig[3]:=Round(B3F.Value);

    DebtLMode:=DebML.ItemIndex;

    UserBank:=BNF.Text;

    //PR: 09/09/2013 ABSEXCH-14598 SEPA
    ssBankAccountCode:=EncryptBankAccountCode(BAF.Text);
    ssBankSortCode:=EncryptBankSortCode(BSF.Text);

    UserRef:=BRF.Text;


    ExternCust:=ECF.Checked;
    TradCodeNum:=NTF.Checked;
    ExternSIN:=ESF.Checked;
    TxLateCr:=UEF.Checked;
    HideExLogo:=HEF.Checked;

    // MH 21/07/2010 v6.4 ABSEXCH-2280: Removed from v6.4 as not supported since v6.00
    //UseClassToolB:=UECL1.Checked;

    ConsvMem:=CMF.Checked;
    UseCCDep:=UCCF.Checked;
    UsePassWords:=UPF.Checked;
    HideMenuOpt:=HUF.Checked;
    PrevPrOff:=DPF.Checked;
    AutoPrCalc:=SPF.Checked;
    UpBalOnPost:=UTF.Checked;
    SepDiscounts:=SLF.Checked;
    AutoClearPay:=ACF.Checked;
    UseBatchTot:=FBF.Checked;
    DefPCDisc:=DTF.Checked;
    UseCRLimitChk:=UCF.Checked;
    UseCreditChk:=USF.Checked;
    StopBadDr:=IOF.Checked;
    LiveCredS:=COF.Checked;
    //NoHoldDisc:=DSF.Checked;  // SSK 25/01/2017 2017-R1 ABSEXCH-18144: Syss.NoHoldDisc commented as this field is no more relevant
    IncNotDue:=INF.Checked;
    AutoNotes:=ATF.Checked;

    SetAgeX(StaUIDate,PurchUIDate,AgeByCB,BOn);

    //StaUIDate:=ABF.Checked;

    QuoOwnDate:=SQF.Checked;
    DirOwnCount:=SRICntF.Checked;
    PrintReciept:=PtF.Checked;
    UsePayIn:=URF.Checked;
    AutoCQNo:=AC2F.Checked;
    BatchPPY:=SMF.Checked;
    UseStock:=DIF.Checked;
    QuAllocFlg:=QSF.Checked;
    AutoBillUp:=DUF.Checked;
    AnalStkDesc:=ASF.Checked;
    IntraStat:=USSDF.Checked;
    ShowStkGP:=SP2F.Checked;
    AutoValStk:=LSF.Checked;
    DeadBOM:=DCF.Checked;
    FreeExAll:=FSF.Checked;
    ManROCP:=MUF.Checked;
    DelPickOnly:=STF.Checked;
    SDNOwnDate:=SDNTPF.Checked;
    InpPack:=UP2F.Checked;
    WarnJC:=JWF.Checked;
    WarnYRef:=DYrF.Checked;
    UsePick4All:=APick.Checked;

    {$IFDEF WOP}
      UseWIss4All:=CBWAF.Checked;
      UseSTDWOP:=CBWWIPF.Checked;

      If (CBWSCMF.ItemIndex>=0) then
        WOPStkCopMode:=CBWSCMF.ItemIndex
      else
        WOPStkCopMode:=0;

    {$ENDIF}


    NoCosDec:=Round(DecPF.Value);
    NoNetDec:=Round(DeSPF.Value);
    NoQtyDec:=Round(DeQF.Value);


    UseMLoc:=EMLF.ItemIndex=1;
    UseLocDel:=EMLF.ItemIndex=2;

    // MH 11/10/2010 v6.5: Added for Override Location on TH (for LIVE)
    EnableOverrideLocations := UseMLoc And chkUseOverrideLocations.Checked;

    // MH 05/09/2013 v7.XMRD MRD1.1.10: Added Consumer Support
    ssConsumersEnabled := chkEnableConsumers.Checked;

    // MH 21/07/2014: Order Payments
    ssEnableOrderPayments := chkEnableOrderPayments.Visible And chkEnableOrderPayments.Checked;

    EditSinSer:=SHSSF.Checked;

    PostCCNom:=(BUCCF.ItemIndex>0);
    PostCCDCombo:=(BUCCF.ItemIndex=2);

    UseGLClass:=UGLCCB.Checked;


    {$IFDEF MC_On}
      If (DRF.Checked) then
        TotalConv:=XDayCode
      else
        TotalConv:=CRateCode;


      VATCurr:=CurVF.ItemIndex;
    {$ENDIF}

    {$IFDEF STK}
      AutoStkVal:=StkI2VM(DefVF.ItemIndex);
      ProtectYRef:=PYRF.Checked;

      Syss.UseUpliftNC:=APUpLF.Checked;

      Syss.KeepBinHist:=RetBinHF.Checked;

      If (Syss.UseMLoc) then
        Syss.FiltSNoBinLoc:=FiltSBLocF.Checked
      else
        Syss.FiltSNoBinLoc:=BOff;

      Syss.BinMask:=BinMaskF.Text;

    {$ENDIF}

    AuthMode:=I2AMethod(AMF.ItemIndex);

    AlTolMode:=TolML.ItemIndex;
    AlTolVal:=TolF.Value;
                            
    {$IFDEF SOP}
      EnableTTDDiscounts := chkUseTTD.Checked;
      EnableVBDDiscounts := chkUseVBD.Checked;
    {$ENDIF}

    //PR: 19/06/2012 Added IncludeVATInCommittedBalance flag v7.0 ABSEXCH-11528
    if IncludeVATInCommittedBalance <> chkIncludeVATInCB.Checked then
    begin
      if msgBox('You have changed the ''Include VAT in committed balances'' setting. Current committed balances will have to be updated.' +
                ' This may take a little time.'#10#10'Do you wish to continue?', mtConfirmation, [mbYes, mbNo], mbYes, 'Change committed balances') =
                 mrYes then
      begin
        IncludeVATInCommittedBalance := chkIncludeVATInCB.Checked;
        //Need to update History table with new committed balances
        FUpdateCommittedBalances := True;
      end;
    end;

    With SyssVAT.VATRates do
    Begin

      ReportPrnN:=Copy(DefRPrn.Text,1,50);
      FormsPrnN:=Copy(DefFPrn.Text,1,50);

      //PR: 26/08/2009 Added v6.2 EC Fields
      ECSalesThreshold := ceECThreshold.Value;
      EnableECServices := chkECServices.Checked;
    end;

    {$IFDEF JC}
      With SyssJob^.JobSetUp do
      Begin
        GenPPI:=JUPF.Checked;
        PeriodBud:=JSBF.Checked;
        PPIAcCode:=JPSF.Text;

        JCCommitPin:=JSPCF.Checked;

        For n:=Low(JobCatAry) to High(JobCatAry) do
        Begin
          SummDesc[n]:=JobCatAry[n].Text;
        end;

        JAInvDate:=JAIDF.Checked;
        JADelayCert:=JADACF.Checked;
      end;

      ProtectYRef:=JAPYRF.Checked;

    {$ENDIF}

    With SyssEDI2^.EDI2Value do
    Begin
      EMName:=EMNameF.Text;
      EMAddress:=EMAddF.Text;
      EMSMTP:=SMTPF.Text;

      If (EDIEMPF.ItemIndex>=0) then
        EMPriority:=EDIEMPF.ItemIndex;

      EMUseMAPI:=EMAPIChk.Checked;


      If (FMAPIChk.ItemIndex>=0) then
        FxUseMAPI:=FMAPIChk.ItemIndex;

      EmailPrnN:=Copy(DefEPrn.Text,1,20);
      FaxPrnN:=Copy(DefFaxPrn.Text,1,20);

      If (EDIEMAMF.ItemIndex>=0) then
        emAttchMode:=EDIEMAMF.ItemIndex;

      FxName:=FxFromF.Text;
      FxPhone:=FxFrTelF.Text;

      FaxDLLPath:=FxDLLPathF.Text;
    end;
  end;

  // MH 08/05/2015 v7.0.14 ABSEXCH-16284: Added PPD Settings
  Res := 0;
  UpdateSystemSetupValue (Res, siPPDRedDays, IntToStr(OriginalPPDSettings.isPPDRedDays), IntToStr(udRedDays.Position), 'Category 1 Days');
  UpdateSystemSetupValue (Res, siPPDAmberDays, IntToStr(OriginalPPDSettings.isPPDAmberDays), IntToStr(udAmberDays.Position), 'Category 2 Days');

  UpdateSystemSetupValue (Res, siPPDExpiredBackgroundColour, IntToStr(OriginalPPDSettings.isPPDExpiredColours.pcrBackgroundColour), IntToStr(edtExpiredColour.Color), 'Expired Background Colour');
  UpdateSystemSetupValue (Res, siPPDExpiredFontColour, IntToStr(OriginalPPDSettings.isPPDExpiredColours.pcrFontColour), IntToStr(edtExpiredColour.Font.Color), 'Expired Font Colour');
  UpdateSystemSetupValue (Res, siPPDExpiredFontStyle, IntToStr(OriginalPPDSettings.isPPDExpiredColours.pcrFontStyle), IntToStr(FontStyleToInternal(edtExpiredColour.Font.Style)), 'Expired Font Style');

  UpdateSystemSetupValue (Res, siPPDRedBackgroundColour, IntToStr(OriginalPPDSettings.isPPDRedColours.pcrBackgroundColour), IntToStr(edtRedDaysColour.Color), 'Category 1 Background Colour');
  UpdateSystemSetupValue (Res, siPPDRedFontColour, IntToStr(OriginalPPDSettings.isPPDRedColours.pcrFontColour), IntToStr(edtRedDaysColour.Font.Color), 'Category 1 Font Colour');
  UpdateSystemSetupValue (Res, siPPDRedFontStyle, IntToStr(OriginalPPDSettings.isPPDRedColours.pcrFontStyle), IntToStr(FontStyleToInternal(edtRedDaysColour.Font.Style)), 'Category 1 Font Style');

  UpdateSystemSetupValue (Res, siPPDAmberBackgroundColour, IntToStr(OriginalPPDSettings.isPPDAmberColours.pcrBackgroundColour), IntToStr(edtAmberDaysColour.Color), 'Category 2 Background Colour');
  UpdateSystemSetupValue (Res, siPPDAmberFontColour, IntToStr(OriginalPPDSettings.isPPDAmberColours.pcrFontColour), IntToStr(edtAmberDaysColour.Font.Color), 'Category 2 Font Colour');
  UpdateSystemSetupValue (Res, siPPDAmberFontStyle, IntToStr(OriginalPPDSettings.isPPDAmberColours.pcrFontStyle), IntToStr(FontStyleToInternal(edtAmberDaysColour.Font.Style)), 'Category 2 Font Style');

  UpdateSystemSetupValue (Res, siPPDGreenBackgroundColour, IntToStr(OriginalPPDSettings.isPPDGreenColours.pcrBackgroundColour), IntToStr(edtGreenDaysColour.Color), 'Category 3 Background Colour');
  UpdateSystemSetupValue (Res, siPPDGreenFontColour, IntToStr(OriginalPPDSettings.isPPDGreenColours.pcrFontColour), IntToStr(edtGreenDaysColour.Font.Color), 'Category 3 Font Colour');
  UpdateSystemSetupValue (Res, siPPDGreenFontStyle, IntToStr(OriginalPPDSettings.isPPDGreenColours.pcrFontStyle), IntToStr(FontStyleToInternal(edtGreenDaysColour.Font.Style)), 'Category 3 Font Style');

  //SS:26/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.
  UpdateSystemSetupValue (Res, siCurrImportTol, FloatToStr(OriginalPPDSettings.isCurrImportTol), FloatToStr(eCurrImportTol.Value), 'Currency Import Tolerance ');

end;


Function TSysSet.CheckCompleted  : Boolean;

Const
  //NofMsgs      =  5;
  NofMsgs      =  6;    // SSK 01/02/2017 2017-R1 ABSEXCH-18147: to increase array elements from 5 to 6


Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  KeyS     :  Str255;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

Begin
  New(PossMsg);
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='The Direct Customer Account is not valid.';
  PossMsg^[2]:='The Direct Supplier Account is not valid.';
  PossMsg^[3]:='The Job Costing PPI Account is not valid.';
  PossMsg^[4]:='System Setup Changes are not allowed whilst in ICE Drip Feed mode.';
  PossMsg^[5]:='The PPD Status Indicator Days are not valid';
  PossMsg^[6]:='Multi Location cannot be disabled whilst Location/Stock-Location records exist.';    // SSK 01/02/2017 2017-R1 ABSEXCH-18147: new msg included



  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin

              Result:=Global_GetMainRec(CustF,DSRIF.Text);

            end;
      2  :  Begin

              Result:=Global_GetMainRec(CustF,DPPIF.Text);

            end;

      3  :  Begin
              If (JUPF.Checked) then
                Result:=Global_GetMainRec(CustF,JPSF.Text);

            end;

      4  :  Begin
              Result:=(ICEDFM=0);
            end;

      // MH 07/05/2016 v7.0.14 ABSEXCH-16284P: Added PPD Tab
      5  :  Begin
              // Red Days must be >= 0
              Result := ValidRedDays And (udRedDays.Position >= 0);
              If Result Then
              Begin
                // Amber Days must be > Red Days
                Result := ValidAmberDays And (udAmberDays.Position > udRedDays.Position);
                If (Not Result) Then
                Begin
                  PageControl1.ActivePage := tabshPPD;
                  If edtAmberDays.CanFocus Then
                    edtAmberDays.SetFocus;
                End; // If (Not Result)
              End // If Result
              Else
              Begin
                PageControl1.ActivePage := tabshPPD;
                If edtRedDays.CanFocus Then
                  edtRedDays.SetFocus;
              End; // Else
            End; // 5 - PPD Days
      // SSK 01/02/2017 2017-R1 ABSEXCH-18147: this check is necessary to avoid the scenario, when user select disable option and opens System Setup
      // and Location window at the same time and create a location record
      6  :  begin
              Result := not (CheckLocRecExists and (EMLF.ItemIndex = 0));
              If (Not Result) Then
                if EMLF.CanFocus then EMLF.SetFocus;
            end;

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}


procedure TSysSet.OkCP1BtnClick(Sender: TObject);
Var
  Ok2Close,
  Locked  :  Boolean;

begin
  Ok2Close:=BOn;

  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      // MH 05/01/2011 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
      //                                   fields which processes the text and updates the value
      If (ActiveControl <> OkCP1Btn) Then
        // Move focus to OK button to force any OnExit validation to occur
        OkCP1Btn.SetFocus;

      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = OkCP1Btn) And CheckCompleted then
      Begin

        StoreSyss;

        {* v4.31.004 Update decimal places on global masks *}
        Set_SDefDecs;

        Send_UpdateList(101);

        //AP: 27/06/2017 2017R2:ABSEXCH-18838:System Setup � General Settings � Company Signatures
        StoreSigs(BOn);
      end
      else
        Ok2Close:=BOff;
    end
    else
      If (OKCp1Btn.Enabled) then
      Begin
        Locked:=BOn;

        GetMultiSys(BOff,Locked,SysR); {* Restore values *}

        Locked:=BOn;

        GetMultiSys(BOff,Locked,VATR); {* Restore values *}

        {$IFDEF JC}
          Locked:=BOn;

          GetMultiSys(BOff,Locked,JobSR); {* Restore values *}

        {$ENDIF}

        Locked:=BOn;

        GetMultiSys(BOff,Locked,EDI2R); {* Restore values *}


        Locked:=BOn;

        GetMultiSys(BOff,Locked,CstmFR); {* Restore values *}

        Locked:=BOn;

        GetMultiSys(BOff,Locked,CstmFR2); {* Restore values *}

      end;

    If (OKCp1Btn.Enabled) then
    Begin
      If PutMultiSys(SysR,BOn) Then
      Begin
        // CA 04/03/2013 v7.0.2 ABSEXCH-14003: Setting up the After
        if Assigned(SysSetAudit) Then
        Begin
          SysSetAudit.AfterData := @Syss;
          SysSetAudit.WriteAuditEntry;
          SysSetAudit := NIL;
        End;
      End; // If PutMultiSys(SysR,BOn)

      If PutMultiSys(VATR,BOn) Then
      Begin
        // CA 04/03/2013 v7.0.2 ABSEXCH-14003: Setting up the After
        if Assigned(SysVATAudit) Then
        Begin
          SysVATAudit.AfterData := SyssVAT;
          SysVATAudit.WriteAuditEntry;
          SysVATAudit := NIL;
        End;
      End; // If PutMultiSys(VATR,BOn)

      {$IFDEF JC}
        If PutMultiSys(JobSR,BOn) Then
        Begin
          // CA 04/03/2013 v7.0.2 ABSEXCH-14003: Setting up the After
          if Assigned(SysJobSetupAudit) Then
          Begin
            SysJobSetupAudit.AfterData := SyssJob;
            SysJobSetupAudit.WriteAuditEntry;
            SysJobSetupAudit := NIL;
          End;
        End; // If PutMultiSys(JobSR,BOn)
      {$ENDIF}

      If PutMultiSys(EDI2R,BOn) Then
      Begin
        // CA 04/03/2013 v7.0.2 ABSEXCH-14003: Setting up the After
        if Assigned(SysEDIRSetupAudit) Then
        Begin
          SysEDIRSetupAudit.AfterData := SyssEDI2;
          SysEDIRSetupAudit.WriteAuditEntry;
          SysEDIRSetupAudit := NIL;
        End;
      End; // If PutMultiSys(EDI2R,BOn)

      PutMultiSys(CstmFR,BOn);
      PutMultiSys(CstmFR2,BOn);
      BeenStored:=BOn;
    end;

    If (Ok2Close) then
      Close; 
  end; {With..}
end;



procedure TSysSet.FxPathBtnClick(Sender: TObject);
Var
  TD,
  PopDir     :       String;

begin
  {$I-}

    Try
      GetDir(0,PopDir);

      If (IOResult=0) then;

    except;
      PopDir:=SetDrive;

    end;

  {$I+}

  TD:=FxDLLPathF.Text;

  If (SelectDirectory(TD,[],FxPathBtn.HelpContext)) then
    FxDLLPathF.Text:=TD;

  {* Start thread *}

  {$I-}
    Try
      ChDir(PopDir);


    except;
      ChDir(SetDrive);
    end;

    If (IOResult=0) then;

  {$I+}

end;

procedure TSysSet.FMAPIChkClick(Sender: TObject);
begin
  FxDLLPathF.Enabled:=(FMAPIChk.ItemIndex<>1);
  FxDLLPathF.ReadOnly:=(FMAPIChk.ItemIndex=1);
  FxDLLPathF.TabStop:=FxDLLPathF.Enabled;
  FxPathBtn.Enabled:=FxDLLPathF.Enabled;
end;


procedure TSysSet.FxDllPathFExit(Sender: TObject);
begin
  With FxDLLPathF do
  If (Not DirectoryExists(Text)) and (Enabled) and (ActiveControl<>CanCP1Btn) and (Text<>'') then
  Begin
    ShowMEssage(Text+' is not a valid directory!');

    If (CanFocus) then
      SetFocus

  end;


end;


Function TSysSet.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PAgeControl1);

end;

Procedure TSysSet.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  If (Pages[NewPage].TabVisible) then
  Begin
    ActivePage:=Pages[NewPage];

  end; {With..}

  SetHelpContextIDs; // NF: 09/05/06 Fixes for incorrect Context IDs
end; {Proc..}


procedure TSysSet.PageControl1Change(Sender: TObject);

Var
  GrpAry    :  Integer;

begin
  SetHelpContextIDs; // NF: 09/05/06 Fixes for incorrect Context IDs

// MH 07/05/2016 v7.0.14 ABSEXCH-16284P: Removed as it was screwing up the text in the TEdits linked to TUpDowns
// if the text wasn't within the TUpDown Min..Max Range
//  If (Sender is TPageControl) then
//    With Sender as TPageControl do
//    Begin
//      LockWindowUpDate(0);
//    end;
end;

procedure TSysSet.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
// MH 07/05/2016 v7.0.14 ABSEXCH-16284P: Removed as it was screwing up the text in the TEdits linked to TUpDowns
// if the text wasn't within the TUpDown Min..Max Range
//  If (AllowChange) then
//  Begin
//    Release_PageHandle(Sender);
//    LockWindowUpDate(Handle);
//  end;

  if Current_Page = 8 then
    StoreSigs(BOff);

end;


procedure TSysSet.DSRIFExit(Sender: TObject);

Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and  {(((FoundCode<>'') and (OrigValue<>Text)) or} ((Sender<>JPSF) or (JUPF.Checked)) and (ActiveControl<>CanCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,(Sender=DSRIF),0));

      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

        {* Weird bug when calling up a list caused the Enter/Exit methods
             of the next field not to be called. This fix sets the focus to the next field, and then
             sends a false move to previous control message ... *}

        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        // CJS 2015-05-29 - ABSEXCH-16438 - System Setup error - cannot focus a disabled or invisible window
        If (Sender<>JPSF) then
          ChangePage(TAB_COMPANY)
        else
          ChangePage(TAB_JOBCOSTING);

        SetFocus;
      end; {If not found..}
    end;
  end; {with..}
end;

procedure TSysSet.BinMaskFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  n          :  Byte;

begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Text;

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=BOn;

      For n:=1 to Length(FoundCode) do
      Begin
        FoundOk:=(FoundCode[n] In ['a','A','c','C','l','L','9','-','0','#',#32]);

        If (Not FoundOk) then
          Break;
      end;

      If (Not FoundOk) then
      Begin
        CustomDlg(Application.MainForm,'Invalid Mask','Mask pattern not valid',
                               'Valid mask characters are:-'+#13+
                               'A,a,c,C,l,L,0,9,#,-. E.g. AAA-000-00'+#13+
                               'C-99999999, aaaaaa.'+#13+
                               'See help for more details.',
                               mtwarning,
                               [mbOk]);

        SetFocus;
      end; {If not found..}
    end;
  end; {with..}
end;


procedure TSysSet.ScrollBox2Exit(Sender: TObject);
begin
  If (Sender is TScrollBox) then
    TScrollBox(Sender).VertScrollBar.Position:=0;
end;

procedure TSysSet.SetFieldProperties;

Var
  n  : Integer;


Begin
  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox) or (Components[n] is TCurrencyEdit) and (Components[n]<>CompanyF) then
    Begin
      With TGlobControl(Components[n]) do
        If (Tag>0) or (Self.Components[n]=CCodeF)  then
        Begin
          Font.Assign(CompanyF.Font);
          Color:=CompanyF.Color;
        end;
    End // If (Components[n] is TMaskEdit) or ...
    Else If (Components[n] is TEdit) Then
    Begin
      With TEdit(Components[n]) do
        If (Tag > 0) then
        Begin
          Font.Assign(CompanyF.Font);
          Color:=CompanyF.Color;
        end;
    End; // If (Components[n] is TEdit)
  end; {Loop..}
end;


procedure TSysSet.SetFormProperties;


Var
  TmpPanel    :  Array[1..3] of TPanel;

  n           :  Byte;

  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;

Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do
  Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;


  try
    TmpPanel[1].Font:=CompanyF.Font;
    TmpPanel[1].Color:=CompanyF.Color;

    TmpPanel[2].Font:=PageControl1.Font;
    TmpPanel[2].Color:=ScrollBox1.Color;

    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],0,'System SetUp Properties',BeenChange,ResetDefaults);


        If (BeenChange) and (not ResetDefaults) then
        Begin
          PageControl1.Font.Assign(TmpPanel[2].Font);

          CompanyF.Font.Assign(TmpPanel[1].Font);
          CompanyF.Color:=TmpPanel[1].Color;

          SetFieldProperties;

        end;

      end;

    finally

      ColourCtrl.Free;

    end;

  Finally

    For n:=1 to 3 do
      TmpPanel[n].Free;

  end;

  If (ResetDefaults) then
  Begin
    SetDefault:=BOn;
    Close;
  end;

end;


procedure TSysSet.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;


procedure TSysSet.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
end;

procedure TSysSet.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;


procedure TSysSet.DEFVFEnter(Sender: TObject);
begin
  {$IFDEF STK}
    LastASV:=DefVF.ItemIndex;
  {$ENDIF}
end;

procedure TSysSet.DEFVFExit(Sender: TObject);
begin
  {$IFDEF STK}
    {$IFDEF POST}
      If (LastASV<>DefVF.ItemIndex) then
        AddStkVal2Thread(Application.MainForm,StkI2VM(LastASV),StkI2VM(DefVF.ItemIndex));
    {$ENDIF}
  {$ENDIF}
end;

procedure TSysSet.EMLFChange(Sender: TObject);
begin
  FiltSBLocF.Visible:=(EMLF.ItemIndex=1);

  // MH 11/10/2010 v6.5: Added for Override Location on TH (for LIVE)
  chkUseOverrideLocations.Visible := (EMLF.ItemIndex=1);
end;

procedure TSysSet.UCCFClick(Sender: TObject);
begin
  With BUCCF do
  Begin
    If (Not UCCF.Checked) then
      ItemIndex:=0;

    Enabled:=UCCF.Checked;
  end;

end;

procedure TSysSet.LSFClick(Sender: TObject);
begin
  With ApUpLF do
  Begin
    If (Not LSF.Checked) then
      Checked:=BOff;

    Enabled:=LSF.Checked;
  end;

end;

procedure TSysSet.SetDebMLCap;

Begin
  If UseDebtWeeks(DebML.ItemIndex) then
    Label837.Caption:=' wks'
  else
    Label837.Caption:='days';

  Label816.Caption:=Label837.Caption;
  Label839.Caption:=Label837.Caption;
end;


procedure TSysSet.SetAlTolForm;

Begin
  Case TolML.ItemIndex of
    1  :  TolF.DisplayFormat:=GenRealMask;

    2  :  TolF.DisplayFormat:=GenPcntMask;
  end; {Case..}
end;

procedure TSysSet.DebMLExit(Sender: TObject);
begin
  SetDebMLCap;
end;

procedure TSysSet.TolMLChange(Sender: TObject);
begin
  SetAlTolForm;
end;

procedure TSysSet.MODFExit(Sender: TObject);

Var
  AltMod  :  Boolean;

begin
  If (Sender is TCurrencyEdit) then
  With TCurrencyEdit(Sender) do
  Begin
    AltMod:=FloatModified;

    If (AltMod) and (ActiveControl<>CanCP1Btn) then
    Begin
      If (Value>255) or (Value<0) then
      Begin
        Value:=0;
        ShowMessage('The value must be between 0, and 255');
        SetFocus;
      end;
    end;
  end;
end;


{$IFDEF MC_On}

  procedure TSysSet.Warn_DayRate;


  Begin
    CustomDlg(Application.MainForm,'Please Note!','Valuation Method Changed',
                               'Changing the currency valuation method will have '+
                               'serious implications on your accounts, unless the correct procedure is followed'+#13+
                               'Please consult your supplier.',
                               mtInformation,
                               [mbOk]);



  end;

  procedure TSysSet.Warn_VATCurr;


  Begin
    CustomDlg(Application.MainForm,'Please Note!',CCVATName^+' Currency Changed',
                               'Changing the '+CCVATName^+' reporting currency will have '+
                               'serious implications on your '+CCVATName^+' returns, unless the '+
                               'correct procedure is followed.'+#13+
                               'Please consult your supplier.',
                               mtInformation,
                               [mbOk]);



  end;

{$ENDIF}


procedure TSysSet.CRFClick(Sender: TObject);
begin
  {$IFDEF MC_On}
    If (CRF.Checked<>LastCRF) and (SetUpOK) then
    Begin
      LastCRF:=CRF.Checked;
      Warn_DayRate;
    end;
  {$ENDIF}
end;

procedure TSysSet.CurVFExit(Sender: TObject);
begin
  {$IFDEF MC_On}
    If (CurVF.ItemIndex<>LastVCur) and (SetUpOK) then
    Begin
      LastVCur:=CurVF.ItemIndex;
      Warn_VatCurr;
    end;
  {$ENDIF}

end;

procedure TSysSet.PYRFClick(Sender: TObject);
begin
  JAPYRF.Checked:=PYRF.Checked;
end;

procedure TSysSet.JAPYRFClick(Sender: TObject);
begin
  PYRF.Checked:=JAPYRF.Checked;
end;


// NF: 09/05/06 Fixes for incorrect Context IDs
procedure TSysSet.SetHelpContextIDs;
begin
  TTermF.HelpContext := 760;
  TT1.HelpContext := 760;
  TT2.HelpContext := 760;
  UGLCCB.HelpContext := 1714;
  OkCP1Btn.HelpContext := 1711;
  CanCP1Btn.HelpContext := 1712;

  case PageControl1.ActivePage.PageIndex of
    TAB_COMPANY : begin
      PageControl1.ActivePage.HelpContext := 49;
    end;

    TAB_SYSTEMGLCURRENCY : begin
      PageControl1.ActivePage.HelpContext := 1713;
    end;

    TAB_SLPL : begin
      PageControl1.ActivePage.HelpContext := 1715;
    end;

    // MH 07/05/2016 v7.0.14 ABSEXCH-16284P: Added PPD Tab
    TAB_PPD : begin
      //PageControl1.ActivePage.HelpContext := 1715;
    end;

    TAB_STOCKSPOP : begin
      PageControl1.ActivePage.HelpContext := 1716;
    end;

    TAB_JOBCOSTING : begin
//      PageControl1.ActivePage.HelpContext := 0;
      //PageControl1.ActivePage.HelpContext := 49;

      // MH 19/10/2011 v6.9 ABSEXCH-12008: Corrected context id
      PageControl1.ActivePage.HelpContext := 1090;
    end;

    TAB_WOP : begin
      PageControl1.ActivePage.HelpContext := 1356;
    end;

    TAB_FAXEMAIL : begin
      PageControl1.ActivePage.HelpContext := 1717;
    end;
  end;{case}

  HelpContext := PageControl1.ActivePage.HelpContext;
  PageControl1.HelpContext := PageControl1.ActivePage.HelpContext;
end;

procedure TSysSet.ceECThresholdKeyPress(Sender: TObject; var Key: Char);
begin
  //PR: 18/09/2009 Don't allow negative value for Sales Threshold
  if Key = '-' then
    Key := #0;
end;

procedure TSysSet.PIFKeyPress(Sender: TObject; var Key: Char);
begin
  If (Key = '-') Then Key := #0;
end;

procedure TSysSet.ExportSettings1Click(Sender: TObject);
begin
  with TfrmExportResults.Create(Application) do
  Try
    ShowModal;
  Finally
    Free;
  End;

end;

procedure TSysSet.chkEnableConsumersMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //PR: 12/12/2013 ABSEXCH-14835 If disabling consumers then we check if any consumers exist - if there are
  //then we don't allow consumers to be disabled.
  if not chkEnableConsumers.Checked then
  begin
    if AreThereAnyConsumers then
    begin   //PR: 18/12/2013 ABSEXCH-14866 Amended message as requested by RE.
      msgBox('The ''Enable Consumers for Sales'' system switch cannot be disabled as Consumer Records and Consumer Transactions exist.', mtWarning,
                  [mbOK], mbOK, 'Disable Consumers');
      chkEnableConsumers.Checked := True;
    end;
  end;

end;

//-------------------------------------------------------------------------

procedure TSysSet.SetPPDLimits;
Begin // SetPPDLimits
  If ValidRedDays Then
    edtRedDaysColour.Text := '0 - ' + IntToStr(udRedDays.Position) + ' Days (inclusive)'
  Else
    edtRedDaysColour.Text := 'Error!';

  If ValidAmberDays Then
  Begin
    edtAmberDaysColour.Text := IntToStr(udRedDays.Position + 1) + ' - ' + IntToStr(udAmberDays.Position) + ' Days (inclusive)';
    edtGreenDaysColour.Text := IntToStr(udAmberDays.Position + 1) + '+ Days';
  End // If ValidAmberDays
  Else
  Begin
    edtAmberDaysColour.Text := 'Error!';
    edtGreenDaysColour.Text := 'Error!';
  End; // Else
End; // SetPPDLimits

//------------------------------

procedure TSysSet.udRedDaysClick(Sender: TObject; Button: TUDBtnType);
begin
  SetPPDLimits;
end;

//------------------------------

Function TSysSet.ValidRedDays : Boolean;
Var
  CurrVal : Integer;
begin
  CurrVal := StrToIntDef(Trim(edtRedDays.Text), -999);
  Result := (CurrVal >= udRedDays.Min) And (CurrVal <= udRedDays.Max)
End;

//------------------------------

Function TSysSet.ValidAmberDays : Boolean;
Var
  CurrVal : Integer;
begin
  CurrVal := StrToIntDef(Trim(edtAmberDays.Text), -999);
  Result := (CurrVal >= udAmberDays.Min) And (CurrVal <= udAmberDays.Max) And (CurrVal > udRedDays.Position);
End;

//------------------------------

procedure TSysSet.edtRedDaysChange(Sender: TObject);
begin
  // Hack as this method is called several times during the form creation - before all the controls exists
  If Assigned(udRedDays) And Self.Visible Then
    SetPPDLimits;
end;

//------------------------------

procedure TSysSet.edtRedDaysExit(Sender: TObject);
begin
  SetPPDLimits;
end;

//------------------------------

procedure TSysSet.edtAmberDaysChange(Sender: TObject);
begin
  // Hack as this method is called several times during the form creation - before all the controls exists
  If Assigned(udAmberDays) And Self.Visible Then
    SetPPDLimits;
end;

//------------------------------

procedure TSysSet.edtAmberDaysExit(Sender: TObject);
begin
  SetPPDLimits;
end;

//------------------------------

procedure TSysSet.btnExpiredColourClick(Sender: TObject);
begin
  DisplayPPDColourSelection (Self, edtExpiredColour);
end;

//------------------------------

procedure TSysSet.btnRedDaysColourClick(Sender: TObject);
begin
  DisplayPPDColourSelection (Self, edtRedDaysColour);
end;

//------------------------------

procedure TSysSet.btnAmberDaysColourClick(Sender: TObject);
begin
  DisplayPPDColourSelection (Self, edtAmberDaysColour);
end;

//------------------------------

procedure TSysSet.btnGreenDaysColourClick(Sender: TObject);
begin
  DisplayPPDColourSelection (Self, edtGreenDaysColour);
end;

// MH 01/20/2014 ABSEXCH-15673: Added warning on Enable Order Payments checkbox
procedure TSysSet.chkEnableOrderPaymentsClick(Sender: TObject);
begin
  // MH 09/06/2015 Exch-R1 ABSEXCH-16374: Remove 'Include VAT in committed balances' warning from non-SOP systems
  {$IFDEF SOP}
    // Check visible to prevent this kicking off when the window is created and the value initialised
    // Use LastEnableOrderPayments to detect changes in the Checked value - required due to bugs in TBorCheck
    If Self.Visible And (chkEnableOrderPayments.Checked <> LastEnableOrderPayments) Then
    Begin
      LastEnableOrderPayments := chkEnableOrderPayments.Checked;

      // If Credit Limit checks are turned On and Order Payments is turned on and 'Include VAT in
      // committed balances' isn't then display a warning to the user
      If UCF.Checked And chkEnableOrderPayments.Checked And (Not chkIncludeVatInCB.Checked) Then
      Begin
        // MH 29/01/2015 v7.1 ABSEXCH-16092: Modified to be a Yes/No message
        If (MessageDlg ('You have turned ON the ''Enable Order Payments'' setting. ' +
                        #13#10#13#10 +
                        'We recommend turning ON ''Include VAT in Committed Balances'' otherwise any ' +
                        'credit limits set can be exceeded without the necessary notification to the user.' +
                        #13#10#13#10 +
                        'Do you want to turn ON ''Include VAT in Committed Balances''?',
                        mtInformation, [mbYes, mbNo, mbHelp], OrdPay_EnableOrderPayments) = mrYes) Then
          chkIncludeVatInCB.Checked := True;
      End; // If UCF.Checked And chkEnableOrderPayments.Checked And (Not chkIncludeVatInCB.Checked)
    End; // If Self.Visible And (chkEnableOrderPayments.Checked <> LastEnableOrderPayments)
  {$ENDIF SOP}
end;

// MH 01/20/2014 ABSEXCH-15673: Added warning on Enable Order Payments checkbox
procedure TSysSet.chkIncludeVatInCBClick(Sender: TObject);
begin
  // MH 09/06/2015 Exch-R1 ABSEXCH-16374: Remove 'Include VAT in committed balances' warning from non-SOP systems
  {$IFDEF SOP}
    // Check visible to prevent this kicking off when the window is created and the value initialised
    // Use LastEnableOrderPayments to detect changes in the Checked value - required due to bugs in TBorCheck
    If Self.Visible And (chkIncludeVatInCB.Checked <> LastIncludeVatInCB) Then
    Begin
      LastIncludeVatInCB := chkIncludeVatInCB.Checked;

      // If Credit Limit checks are turned On and Order Payments is turned on and 'Include VAT in
      // committed balances' isn't then display a warning to the user
      If UCF.Checked And (Not chkIncludeVatInCB.Checked) And chkEnableOrderPayments.Checked Then
      Begin
        // MH 29/01/2015 v7.1 ABSEXCH-16092: Modified to be a Yes/No message
        If (MessageDlg ('You have turned OFF the ''Include VAT in Committed Balances'' setting. ' +
                        #13#10#13#10 +
                        'We recommend turning ON ''Include VAT in Committed Balances'' otherwise any ' +
                        'credit limits set can be exceeded without the necessary notification to the user.' +
                        #13#10#13#10 +
                        'Do you want to turn it ON again?',
                        mtInformation, [mbYes, mbNo, mbHelp], OrdPay_EnableOrderPayments) = mrYes) Then
          chkIncludeVatInCB.Checked := True;
      End; // If UCF.Checked And (Not chkIncludeVatInCB.Checked) And chkEnableOrderPayments.Checked
    End; // If Self.Visible And (chkIncludeVatInCB.Checked <> LastIncludeVatInCB)
  {$ENDIF SOP}
end;

// MH 01/20/2014 ABSEXCH-15673: Added warning on Enable Order Payments checkbox
procedure TSysSet.UCFClick(Sender: TObject);
begin
  // MH 09/06/2015 Exch-R1 ABSEXCH-16374: Remove 'Include VAT in committed balances' warning from non-SOP systems
  {$IFDEF SOP}
    // Check visible to prevent this kicking off when the window is created and the value initialised
    // Use LastEnableOrderPayments to detect changes in the Checked value - required due to bugs in TBorCheck
    If Self.Visible And (UCF.Checked <> LastUseCreditLimitCheck) Then
    Begin
      LastUseCreditLimitCheck := UCF.Checked;

      // If Credit Limit checks are turned On and 'Include VAT in committed balances' isn't then
      // display a warning to the user
      If UCF.Checked And (Not chkIncludeVatInCB.Checked) Then
      Begin
        // MH 29/01/2015 v7.1 ABSEXCH-16092: Modified to be a Yes/No message
        If (MessageDlg ('You have turned ON the ''Use Credit Limit Check'' setting. ' +
                        #13#10#13#10 +
                        'We recommend turning ON ''Include VAT in Committed Balances'' otherwise any ' +
                        'credit limits set can be exceeded without the necessary notification to the user.' +
                        #13#10#13#10 +
                        'Do you want to turn ON ''Include VAT in Committed Balances''?',
                        mtInformation, [mbYes, mbNo, mbHelp], OrdPay_EnableOrderPayments) = mrYes) Then
          chkIncludeVatInCB.Checked := True;
      End; // If UCF.Checked And (Not chkIncludeVatInCB.Checked)
    End; // If Self.Visible And (chkIncludeVatInCB.Checked <> LastIncludeVatInCB)
  {$ENDIF SOP}
end;


// check for existence of record in Location and StockLocation table
function TSysSet.CheckLocRecExists: Boolean;
var
  KeyS, KeyChk      :  Str255;
  bRetLoc, bRetStkLoc  : boolean;
begin

  //check for record in Location table
  KeyS:=PartCCKey(CostCCode,CSubCode[BOn]);
  bRetLoc := CheckRecExsists(KeyS, MLocF, MLK);


  //check for record in StockLocation table
  KeyChk:=PartCCKey(CostCCode,CSubCode[BOff]);
  bRetStkLoc := CheckRecExsists(KeyChk, MLocF, MLSecK);

  result := bRetLoc or bRetStkLoc;
end;

// SSK 23/05/2017 2017-R1 ABSEXCH-18685: validation done to restrict 'Currency Import tolerance' field  as per the jira requirement
procedure TSysSet.eCurrImportTolExit(Sender: TObject);
begin
  if (eCurrImportTol.Value > 999.99) then eCurrImportTol.Value := 999.99;
end;

//AP: 27/06/2017 2017R2:ABSEXCH-18838:System Setup � General Settings � Company Signatures
procedure TSysSet.StoreSigs(AEditMode: Boolean);
begin
  // Save
  if (AEditMode) then
  begin
    memFaxSig.ReadOnly := True;
    memFaxSig.Lines.SaveToFile(FFiles[2]);

    memEmailSig.ReadOnly := True;
    memEmailSig.Lines.SaveToFile(FFiles[1]);
  end { Else }
  else
  begin
    memFaxSig.ReadOnly := True;
    memEmailSig.ReadOnly := True;
  end;
end; {Proc..}

//AP: 27/06/2017 2017R2:ABSEXCH-18838:System Setup � General Settings � Company Signatures
procedure TSysSet.LoadSig;
begin
  LoadText(1, 'COMPANY.TXT', 'COMPANY.TXT', memEmailSig);
  LoadText(2, 'COMPANY.TX2', 'COMPANY.TX2', memFaxSig);
end;

//AP: 27/06/2017 2017R2:ABSEXCH-18838:System Setup � General Settings � Company Signatures
procedure TSysSet.LoadText(const AIndex: Byte; AFileName1, AFileName2: ShortString; ATheMemo: TMemo);
const
  PathMaster = 'DOCMASTR\';
begin { LoadText }
  AFileName1 := SetDrive + PathMaster + AFileName1;
  // Take copy of filename for later save operation
  FFiles[AIndex] := AFileName1;

  if not FileExists(AFileName1) then
    AFileName1 := SetDrive + PathMaster + AFileName2;

  if FileExists(AFileName1) then
    ATheMemo.Lines.LoadFromFile (AFileName1) // Load Text
  else
    ATheMemo.Clear;
end; { LoadText }

//==============================================================================

end.

