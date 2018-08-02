unit JCEmpR3U;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SBSPanel, StdCtrls, Mask, TEditVal, ExtCtrls, ComCtrls, BorBtns,
  GlobVar,VarConst,VarRec2U,BtrvU2,BTSupU1,ExWrap1U, SupListU,

  {$IFDEF NP}
    NoteU,
  {$ENDIF}


  SBSComp2,
  SalTxl1U,
  {Recon3U,}

  JobMn2U,

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  ExtGetU,

  Menus, Buttons, Grids, SBSOutl, bkgroup, TCustom,
  // SSK 22/05/2018 2018-R1.1 ABSEXCH-20308: Added support for exporting lists
  WindowExport, ExportListIntf, oExcelExport;



type
  TJELMList  =  Class(TJLMList)

    Function SetCheckKey  :  Str255; Override;

    Function CheckRowEmph :  Byte; Override;

    Function OutJELLine(Col  :  Byte)  :  Str255;

    Function OutJEPLine(Col  :  Byte)  :  Str255;

    Function OutJEAppLine(Col  :  Byte)  :  Str255;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;


type
  TJEmpRec = class(TForm)
    PageControl1: TPageControl;
    Main: TTabSheet;
    Notes: TTabSheet;
    Ledger: TTabSheet;
    TCMPanel: TSBSPanel;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    ClsCP1Btn: TButton;
    TCMBtnScrollBox: TScrollBox;
    EditCP1Btn: TButton;
    DelCP1Btn: TButton;
    FindCP1Btn: TButton;
    HistCP1Btn: TButton;
    CopyCP1Btn: TButton;
    ViewCP1Btn: TButton;
    PrnCP1Btn: TButton;
    InsCP1Btn: TButton;
    GenCP3Btn: TButton;
    TCMScrollBox: TScrollBox;
    CLSBox: TScrollBox;
    CLORefLab: TSBSPanel;
    CLDateLab: TSBSPanel;
    CLOOLab: TSBSPanel;
    CLQOLab: TSBSPanel;
    CLALLab: TSBSPanel;
    CLORefPanel: TSBSPanel;
    CLDatePanel: TSBSPanel;
    CLOOPanel: TSBSPanel;
    CLQOPanel: TSBSPanel;
    CLALPanel: TSBSPanel;
    CListBtnPanel: TSBSPanel;
    CLAcPanel: TSBSPanel;
    CLACLab: TSBSPanel;
    CLHedPanel: TSBSPanel;
    TCNScrollBox: TScrollBox;
    TNHedPanel: TSBSPanel;
    NDateLab: TSBSPanel;
    NDescLab: TSBSPanel;
    NUserLab: TSBSPanel;
    NDatePanel: TSBSPanel;
    NDescPanel: TSBSPanel;
    NUserPanel: TSBSPanel;
    TCNListBtnPanel: TSBSPanel;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Insert1: TMenuItem;
    Delete1: TMenuItem;
    Find1: TMenuItem;
    Hist1: TMenuItem;
    Switch1: TMenuItem;
    Print1: TMenuItem;
    View1: TMenuItem;
    Copy1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    I1StatLab: Label8;
    LnkCp1Btn: TButton;
    Links1: TMenuItem;
    NteCP1Btn: TButton;
    Notes1: TMenuItem;
    AddCP1Btn: TButton;
    btnStatus: TButton;
    Status1: TMenuItem;
    SBSPanel8: TSBSPanel;
    Label85: Label8;
    Label83: Label8;
    EmACCF: Text8Pt;
    EmTypF: TSBSComboBox;
    SBSPanel2: TSBSPanel;
    Label82: Label8;
    Label84: Label8;
    Label88: Label8;
    Label89: Label8;
    SupAcF: Text8Pt;
    EAD1F: Text8Pt;
    EAd2F: Text8Pt;
    EAD3F: Text8Pt;
    EAD4F: Text8Pt;
    EAD5F: Text8Pt;
    ENamF: Text8Pt;
    ETelF: Text8Pt;
    SBSPanel3: TSBSPanel;
    Label81: Label8;
    Label86: Label8;
    Label87: Label8;
    Label810: Label8;
    EFaxF: Text8Pt;
    EMobF: Text8Pt;
    EPayNoF: Text8Pt;
    ECertF: Text8Pt;
    EExpF: TEditDate;
    PayRates: TTabSheet;
    RTSBox: TScrollBox;
    RTHedPanel: TSBSPanel;
    RTLab: TSBSPanel;
    DELab: TSBSPanel;
    THLab: TSBSPanel;
    TCLab: TSBSPanel;
    ANLab: TSBSPanel;
    RTPanel: TSBSPanel;
    DEPanel: TSBSPanel;
    THPanel: TSBSPanel;
    TCPanel: TSBSPanel;
    ANPanel: TSBSPanel;
    CLYRefPanel: TSBSPanel;
    CLDuePanel: TSBSPanel;
    CLYRefLab: TSBSPanel;
    CLDueLab: TSBSPanel;
    PNPanel: TSBSPanel;
    PNLab: TSBSPanel;
    LinkCF: Text8Pt;
    SBSPanel1: TSBSPanel;
    UD1Lab: Label8;
    UD2Lab: Label8;
    EUD1F: Text8Pt;
    EUD2F: Text8Pt;
    GrpChkF: TBorCheck;
    GenSBF: TBorCheck;
    CCLab: Label8;
    ECCF: Text8Pt;
    EDepF: Text8Pt;
    CBCertType: TSBSComboBox;
    Label811: Label8;
    UD3Lab: Label8;
    EUD3F: Text8Pt;
    EUD4F: Text8Pt;
    UD4Lab: Label8;
    Label812: Label8;
    ENINOF: Text8Pt;
    LabChkF: TBorCheck;
    AppsTPage: TTabSheet;
    StatTPage: TTabSheet;
    ContractPage: TTabSheet;
    Label813: Label8;
    EChkF: TSBSComboBox;
    Label814: Label8;
    EUTRF: Text8Pt;
    Label815: Label8;
    EVERF: Text8Pt;
    ETagF: TBorCheck;
    CBSubType: TSBSComboBox;
    Label816: Label8;
    edtEmailAddr: Text8Pt;
    edEmpStatus: Text8Pt;
    lblEmpSatus: Label8;
    popmnuStatus: TPopupMenu;
    mnuItmEmpClosed: TMenuItem;
    mnuItmLine1: TMenuItem;
    mnuItmEmpOpen: TMenuItem;
    pnlAnonymisationStatus: TPanel;
    shpNotifyStatus: TShape;
    lblAnonStatus: TLabel;
    btnPIITree: TSBSButton;
    PIITree1: TMenuItem;
    WindowExport: TWindowExport;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure EditCP1BtnClick(Sender: TObject);
    procedure DelCP1BtnClick(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure ViewCP1BtnClick(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure CLORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CLORefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CLORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GenCP3BtnClick(Sender: TObject);
    procedure FindCP1BtnClick(Sender: TObject);
    procedure PrnCP1BtnClick(Sender: TObject);
    procedure LnkCp1BtnClick(Sender: TObject);
    procedure ViewR1Click(Sender: TObject);
    procedure EmACCFExit(Sender: TObject);
    procedure SupAcFEnter(Sender: TObject);
    procedure SupAcFExit(Sender: TObject);
    procedure ECCFExit(Sender: TObject);
    procedure SupAcFDblClick(Sender: TObject);
    procedure EmTypFChange(Sender: TObject);
    procedure HistCP1BtnClick(Sender: TObject);
    procedure GrpChkFMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EUD1FEntHookEvent(Sender: TObject);
    procedure EUD1FExit(Sender: TObject);
    procedure NteCP1BtnClick(Sender: TObject);
    procedure LabChkFClick(Sender: TObject);
    procedure btnStatusClick(Sender: TObject);
    procedure mnuItmEmpClosedClick(Sender: TObject);
    procedure btnPIITreeClick(Sender: TObject);
    function WindowExportEnableExport: Boolean;
    function WindowExportGetExportDescription: String;
    procedure WindowExportExecuteCommand(const CommandID: Integer;const ProgressHWnd: HWND);

  private
    { Private declarations }
    HideDAdd,
    ManClose,
    InHBeen,
    StopPageChange,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    F9Used,
    fNeedCUpdate,
    fFrmClosing:  Boolean;

    LastHMode,
    ListOfSet  :  Byte;

    SKeypath   :  Integer;


    {$IFDEF NP}
      NotesCtrl  :  TNoteCtrl;
    {$ENDIF}

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}

    InCISVch  :  Boolean;


    PageP,
    ScrollAP,
    ScrollBP,
    Misc1P,
    PanelP     :  TPoint;

    PagePoint  :  Array[0..4] of TPoint;

    StartSize,
    InitSize   :  TPoint;

    MULCtrlO   :  Array[2..6] of TJELMList;

    InvBtnList :  TVisiBtns;

    RetRecPtr,
    DispTransPtr
               :  Pointer;

    FAnonymisationON: Boolean;
    FListScanningOn: Boolean;
    procedure SetAnonymisationON(AValue: Boolean);
    procedure SetAnonymisationBanner;

    procedure SetAnonymisationStatusDate;

    procedure DefaultPageReSize;

    procedure NotePageReSize;

    Procedure NoteUpdate;

    Function ScanMode  :  Boolean;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure WMNextDialog(Var Message  :  TMessage); Message WM_NextDlgCtl;

    procedure LedgerBuildList(PageNo     :  Byte;
                              ShowLines  :  Boolean);

    procedure RetenBuildList(PageNo     :  Byte;
                             ShowLines  :  Boolean);

    procedure AppsBuildList(PageNo     :  Byte;
                            ShowLines  :  Boolean);

    procedure Display_Trans(Mode  :  Byte);

    procedure BuildDesign;

    procedure AddCP3BtnClick(Sender: TObject);

    procedure DelCP3BtnClick(Sender: TObject);


    procedure SetCompRO(TC     :  TComponent;
                  Const TG     :  Integer;
                  Const EnabFlg:  Boolean);


    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;


    Function CheckListFinished  :  Boolean;

    procedure EditCharge;

    procedure Display_RetRec(Mode     :  Byte;
                             IsSales  :  Boolean);

    procedure EditRetRec(Sender  : TObject;
                         IsSales : Boolean);
    //HV 12/11/2017 ABSEXCH-19549: Anonymised Notification banner in View/Edit Record > Banner not displayed on maximise and then Restore Down.
    procedure SetAnonymisationPanel;
  public
    { Public declarations }

    GlobPRate    :  Byte;
    CanDelete,
    FromHist     :  Boolean;

    Level_Cr,
    Level_TxCr   :  Byte;
    Level_Commit :  Boolean;

    RateJCode    :  Str10;
    Level_JACode,
    Level_Code   :  Str20;

    Add_Type     :  Char;

    DDMode       :  Byte;

    DDCtrl       :  TNHCtrlRec;

    ExLocal      :  TdExLocal;

    HistFormPtr  :  Pointer;


    Function Current_BarPos(PageNo  :  Byte)  :  Integer;

    procedure HidePanels(PageNo    :  Byte);

    Function SetDelBtn  :  Boolean;

    Function ChkPWord(PageNo :  Integer;
                      Pages  :  TIntSet;
                      HelpS  :  LongInt) :  LongInt;

    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1,
                      Help2,
                      Help3,
                      Help4,
                      Help5,
                      Help6,
                      Help7  :  LongInt) :  LongInt;

    procedure PrimeButtons;

    procedure SetTabs;

    procedure BuildMenus;

    procedure FormDesign;

    procedure Find_LedgCoord(PageNo  :  Integer);
    procedure Store_LedgCoord(UpMode  :  Boolean);


    procedure Find_FormCoord;
    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Function Current_Page  :  Integer;

    Procedure SetFieldRW;

    Procedure OutEmpl;
    Procedure Form2Empl;


    Procedure SetFieldFocus;

    Procedure ChangePage(NewPage  :  Integer);

    Function CheckNeedStore  :  Boolean;

    Function ConfirmQuit  :  Boolean;

    Procedure SetCaption;

    procedure ShowLink;

    procedure SetEmplStore(EnabFlag,
                           ButnFlg  :  Boolean);

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure ProcessEmpl(Fnum,
                          KeyPAth    :  Integer;
                          Edit       :  Boolean);

    Function CheckCompleted(Edit  :  Boolean)  : Boolean;


    procedure StoreEmpl(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);


    Function Auto_GetECode(CCode    :  Str20;
                           Fnum,
                           Keypath  :  Integer)  :  Str20;

    procedure EditAccount(Edit  :  Boolean);

    procedure DeleteAccount;

    procedure DeleteDoc;

    procedure SetFieldProperties;

    procedure SetFormProperties;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);


    procedure Display_History(HistMode     :  Byte;
                              ChangeFocus  :  Boolean);

    // HV 30/11/2017 ABSEXCH-19394: Implements anonymisation behaviour for Emp
    property AnonymisationON: Boolean read FAnonymisationON write SetAnonymisationON;
    property ListScanningOn: Boolean read FListScanningOn write FListScanningOn;

  end;


Procedure Set_EDDFormMode(State  :  TNHCtrlRec);

Var
  GlobPRateMode:  Byte;
  GLobJCode    :  Str10;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,
  SBSComp,
  
  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  ComnUnit,
  ComnU2,
  CurrncyU,

  SysU1,

  InvListU,

  {$IFDEF GF}
    FindRecU,
    FindCtlU,
  {$ENDIF}

  {$IFDEF PF_On}

    {$IFDEF STK}
      {$IFDEF SOP}
        InvLst3U,
      {$ENDIF}
    {$ENDIF}

    {$IFDEF POST}
      RevalueU,
    {$ENDIF}

  {$ENDIF}


  {InvCTSUU,}

  JobSup1U,

  {$IFDEF JAP}
    JobSup2U,
    JobApWzU,
  {$ENDIF}

  JCEmpP1U,
  JChkUseU,
  {InvFSu3U,}

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  Tranl1U,
  PayF2U,

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  CISVch1U,
  IntMU,
  {$IFDEF Ltr}
    MSWord95,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,
  {$ENDIF}

  {$IFDEF NOM}
    HistWinU,
  {$ENDIF}

  ThemeFix,

  VarJCstU,
  Exthrd2U,
  PWarnU,
  SysU2,
  CustomFieldsVar,
  oSystemSetup,
  GDPRConst,
  CustomFieldsIntf,
  MiscU,

  //RB 22/12/2017 2018-R1 ABSEXCH-19559: GDPR (POST 19393) - 6.3.2 - Employee Open/Close behaviour - Anonymisation diary section
  oAnonymisationDiaryObjIntf,
  oAnonymisationDiaryObjDetail,
  oAnonymisationDiaryBtrieveFile,
  UA_Const,

  PIITreeF,
  PIIScannerIntf;

{$R *.DFM}


{$I JEITi1U.Pas}

Const
  MainPage   = 0;
  NotesPage  = 1;
  LedgerPage = 2;
  RatePage   = 3;
  ContPage   = 4;
  AppPage    = 5;
  StatPage   = 6;

Var
  JDDFormMode  :  TNHCtrlRec;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_EDDFormMode(State  :  TNHCtrlRec);

Begin

  JDDFormMode:=State;

end;



{ ============ Procedure to control the editing of the charge amount of actual records ======== }



Function TJEmpRec.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PageControl1);

end;



procedure TJEmpRec.Find_LedgCoord(PageNo  :  Integer);


Var
  n       :  Integer;

  GlobComp:  TGlobCompRec;


Begin

  If (MULCtrlO[PageNo]<>nil) then
  With MULCtrlO[PageNo] do
  Begin

    New(GlobComp,Create(BOn));

    With GlobComp^ do
    Begin
      GetValues:=BOn;

      If (PageNo In [RatePage..StatPage]) then
        PrimeKey:=Chr(Ord('F')+PageNo)
      else
        PrimeKey:=Chr(Ord('E')+GlobPRate);

      HasCoord:=LastCoord;


      Find_ListCoord(GlobComp);

    end; {With GlobComp..}


    Dispose(GlobComp,Destroy);

  end;
end;


procedure TJEmpRec.Store_LedgCoord(UpMode  :  Boolean);


Var
  n       :  Byte;
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin

    GetValues:=UpMode;

    SaveCoord:=StoreCoord;



    For n:=LedgerPage to StatPage do
    Begin

      If (n In [RatePage..StatPage]) then
        PrimeKey:=Chr(Ord('F')+n)
      else
        PrimeKey:=Chr(Ord('E')+GlobPRate);


      If (MULCtrlO[n]<>nil) {and ((SaveCoord) or (Not UpMode))} then
        MULCtrlO[n].Store_ListCoord(GlobComp);
    end; {Loop..}

  end; {With GlobComp..}

  GlobComp.Destroy;
end;




Procedure  TJEmpRec.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TJEmpRec.Find_FormCoord;


Var
  ThisForm:  TForm;

  VisibleRect
          :  TRect;

  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do
  Begin
    GetValues:=BOn;
    PrimeKey:=Chr(Ord('E')+GlobPRate);

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(PageControl1);

    GetbtControlCsm(TCMPanel);


    With TCMBtnScrollBox do
    Begin

      Height:=TCMPanel.ClientHeight-Top;

    end;

    GetbtControlCsm(TCMScrollBox);
    GetbtControlCsm(TCNScrollBox);
    GetbtControlCsm(TCNListBtnPanel);

    If (GetbtControlCsm(CListBtnPanel)) then
    Begin
      CLOrefPanel.Height:=CListBtnPanel.Height;
    end;

    GetbtControlCsm(CLSBox);

    TCMScrollBox.Color:=TCMPanel.Color;
    {SBSGroup1.Color:=TCMPanel.Color;
    SBSGroup2.Color:=TCMPanel.Color;
    SBSPanel4.Color:=TCMPanel.Color;}


    {DefaultPageReSize;}
    NotePageReSize;

    If (GetbtControlCsm(EMAccF)) then
      SetFieldProperties;

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range
         Find some way of getting to parent form visible area *}

  {With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;}

    {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;


end;

procedure TJEmpRec.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin

    PrimeKey:=Chr(Ord('E')+GlobPRate);

    GetValues:=UpMode;

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;
    //HV 05/12/2017 ABSEXCH-19535: Anonymised Trader > The height of the window gets increased if "Save coordinates" is ticked
    if pnlAnonymisationStatus.Visible then
      Self.ClientHeight := Self.ClientHeight - pnlAnonymisationStatus.Height;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(TCMPanel);


    StorebtControlCsm(TCMScrollBox);
    StorebtControlCsm(TCNScrollBox);

    StorebtControlCsm(TCNListBtnPanel);

    StorebtControlCsm(EMAccF);

    StorebtControlCsm(CListBtnPanel);
    StorebtControlCsm(CLSBox);

    {BOM Page}



    {$IFDEF NP}
      If (NotesCtrl<>nil) then
        NotesCtrl.MULCtrlO.Store_ListCoord(GlobComp);
    {$ENDIF}

    Store_LedgCoord(UpMode);

  end; {With GlobComp..}

  GlobComp.Destroy;


end;


procedure TJEmpRec.FormSetOfSet;


Begin
  PageP.X:=ClientWidth-(PageControl1.Width);
  PageP.Y:=ClientHeight-(PageControl1.Height);

  ScrollAP.X:=PageControl1.Width-(TCMPanel.Left);
  ScrollAP.Y:=PageControl1.Height-(TCMPanel.Height);

  ScrollBP.X:=PageControl1.Width-(TCMScrollBox.Width);
  ScrollBP.Y:=PageControl1.Height-(TCMScrollBox.Height);

  Misc1P.X:=TCMPanel.Height-(TCMBtnScrollBox.Height);

  PagePoint[0].X:=PageControl1.Width-(CLSBox.Width);
  PagePoint[0].Y:=PageControl1.Height-(CLSBox.Height);

  
  {PagePoint[1].X:=PageControl1.Width-(TCDScrollBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(TCDScrollBox.Height);}

  PagePoint[2].X:=CLSBox.Height-CLORefPanel.Height;
  PagePoint[2].Y:=PageControl1.Height-(CListBtnPanel.Height);

  PagePoint[3].X:=PageControl1.Width-(TCNScrollBox.Width);
  PagePoint[3].Y:=PageControl1.Height-(TCNScrollBox.Height);

  PagePoint[4].X:=TCNScrollBox.ClientHeight-(TCNListBtnPanel.Height);


{  Misc1P.Y:=ScrollBox5.ClientHeight-(TLAccPanel.Height);

  PanelP.X:=PageControl1.Width-(SBSPanel14.Left);
  PanelP.Y:=Panel1.Height-(SBSPanel14.Height);}



  GotCoord:=BOn;

end;

Function TJEmpRec.SetDelBtn  :  Boolean;

Begin
  Result:=((CanDelete and (Not ExLocal.InAddEdit)) or (Current_Page In [3]));
end;


Function TJEmpRec.ChkPWord(PageNo :  Integer;
                            Pages  :  TIntSet;
                            HelpS  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
    Result:=HelpS
  else
    Result:=-255;

end;

Function TJEmpRec.SetHelpC(PageNo :  Integer;
                            Pages  :  TIntSet;
                            Help0,
                            Help1,
                            Help2,
                            Help3,
                            Help4,
                            Help5,
                            Help6,
                            Help7  :  LongInt) :  LongInt;

Begin
  Result := -1;
  If (PageNo In Pages) then
  Begin
    Case PageNo of
      0  :  Result:=Help0;
      1  :  Result:=Help1;
      2  :  Result:=Help2;
      3  :  Result:=Help3;
      4  :  Result:=Help4;
      5  :  Result:=Help5;
    end; {Case..}
  end
  else
    Result:=-1;

end;


procedure TJEmpRec.PrimeButtons;

Var
  ACFlg,
  P4Blk   :  Boolean;

  n,
  PageNo  :  Integer;

Begin
  PageNo:=Current_Page;

  {$IFDEF SOP}
    ACFlg:=BOff;
  {$ELSE}
    ACFlg:=BOn;

  {$ENDIF}

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
      Begin
        PresEnab:=BOff;

      {0} AddVisiRec(AddCP1Btn,BOff);
      {1} AddVisiRec(EditCP1Btn,BOff);
      {2} AddVisiRec(InsCP1Btn,BOff);
      {3} AddVisiRec(DelCP1Btn,BOff);
      {4} AddVisiRec(FindCP1Btn,BOn);
      {5} AddVisiRec(HistCP1Btn,BOff);
      {6} AddVisiRec(GenCP3Btn,BOff);
      {7} AddVisiRec(PrnCP1Btn,BOff);
      {8} AddVisiRec(ViewCP1Btn,BOff);
      {9} AddVisiRec(CopyCP1Btn,BOff);
     {10} AddVisiRec(LnkCP1Btn,BOff);
     {11} AddVisiRec(NteCP1Btn,BOff);
     {12} AddVisiRec(btnStatus,BOff);
     {13} AddVisiRec(btnPIITree,BOff); //PR: 04/12/2017 ABSEXCH-19479

        end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    With InvBtnList do
    Begin
      PresEnab:=ExLocal.InAddEdit ;

      PWSetHideBtn(0,(PageNo In [LedgerPage]),BOff,ChkPWord(PageNo,[MainPage,RatePage],-255));
      SetBtnHelp(0,SetHelpC(PageNo,[MainPage..StatPage],1082,156,88,1102,0,0,0,0));

      PWSetHideBtn(1,BOff,BOff,ChkPWord(PageNo,[LedgerPage],215));
      SetBtnHelp(1,SetHelpC(PageNo,[MainPage..StatPage],1082,155,1104,1102,0,0,0,0));

      SetHideBtn(2,(PageNo<>NotesPage),BOff);


      Case PageNo of
        ContPage  :  PWSetHideBtn(3,(PageNo=LedgerPage),BOff,ChkPWord(PageNo,[ContPage],441));
        AppPage   :  PWSetHideBtn(3,(PageNo=LedgerPage),BOff,ChkPWord(PageNo,[AppPage],441));
        else         PWSetHideBtn(3,(PageNo=LedgerPage),BOff,ChkPWord(PageNo,[99],0));
      end; {Case..}

      
      SetBtnHelp(3,SetHelpC(PageNo,[MainPage..StatPage],1097,159,89,1103,0,0,0,0));

      SetHideBtn(4,BOn,BOff);

      SetBtnHelp(4,SetHelpC(PageNo,[LedgerPage],165,165,264,0,0,0,0,0));

      SetHideBtn(5,(Not (PageNo In [MainPage])),BOff);

      SetHideBtn(6,(Not (PageNo In [NotesPage])),BOff);

      PWSetHideBtn(7,(PageNo In [MainPage,NotesPage,RatePage,StatPage]),BOff,ChkPWord(PageNo,[MainPage],113));

      SetBtnHelp(7,SetHelpC(PageNo,[MainPage,LedgerPage],846,0,1105,0,0,0,0,0));

      SetHideBtn(8,(Not (PageNo In [LedgerPage,AppPage,ContPage])),BOff);

      SetBtnHelp(8,SetHelpC(PageNo,[LedgerPage,RatePage],0,0,930,32,0,0,0,0));

      SetHideBtn(9,BOn,BOff);

      SetBtnHelp(9,SetHelpC(PageNo,[MainPage],186,0,985,0,0,0,0,0));

      SetHideBtn(10,(PageNo In [NotesPage..StatPage]),BOff);

      SetBtnHelp(10,SetHelpC(PageNo,[MainPage,LedgerPage],81,0,81,0,0,0,0,0));

      PWSetHideBtn(11,(Not (PageNo In [MainPage])) or (Not CISOn),BOff,250);

      //RB 28/11/2017 2018-R1 ABSEXCH-19499: 6.3.2.4 (Before ABSEXCH-19393) - Add Status field to Employee and Button to change status for employee
      PWSetHideBtn(12,(Not (PageNo In [MainPage])),BOn,ChkPWord(PageNo,[MainPage], uaJobCostingEmployeeRecordsStatus));

      //PR: 04/12/2017 ABSEXCH-19427 PII Tree button
      //RB 07/12/2017 ABSEXCH-19538: User permission implementation related to Employee Status button and PII tree button in Entity Record window
      PWSetHideBtn(13, not GDPROn or Not (PageNo IN [MainPage]), True, uaAccessForEmployee);

      DelCP1Btn.Enabled:=SetDelBtn and Not PresEnab;

      OkCP1Btn.Visible:=(PageNo In [MainPage]);
      CanCP1Btn.Visible:=(PageNo In [MainPage]);

      // SSK 22/10/2017 ABSEXCH-19386: Disable the status button for all the tabs for anonymised trader
      if JobMisc^.EmplRec.emAnonymisationStatus = asAnonymised then
        btnStatus.Enabled := False;
    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;


Function TJEmpRec.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      LedgerPage
        :  Result:=CLSBox.HorzScrollBar.Position;

      RatePage,AppPage,ContPage
         :  Result:=RTSBox.HorzScrollBar.Position;

      else  Result:=0;
    end; {Case..}
end;



procedure TJEmpRec.HidePanels(PageNo    :  Byte);

Begin
  RTSBox.HorzScrollBar.Position:=0;
  RTSBox.Parent:=PageControl1.ActivePage;

  Case PageNo of
    RatePage  :  Begin
                   RTLab.Caption:='Rate Code';
                   DeLab.Caption:='Description';
                   ANLab.Caption:='Analysis';
                   TCLab.Caption:='Time Cost';
                   THLab.Caption:='Time Charge';
                   PNLab.Caption:='Pay Code';

                 end;

    AppPage,
    ContPage
             :  Begin
                   RTLab.Caption:='OurRef';
                   DeLab.Caption:='JobCode';
                   ANLab.Caption:='Date';
                   TCLab.Caption:='Budget';
                   THLab.Caption:='App./Cert.';
                   PNLab.Caption:='Status';

                 end;


  end; {Case..}

  
end;


{* Alter screen based on stock record }

procedure TJEmpRec.BuildDesign;

Begin
  With ExLocal,LJobMisc^.EmplRec do
  Begin
    Ledger.TabVisible:=((Not HideDAdd) and (DDMode=0)) and (GlobPRate=0) and (PChkAllowed_In(223));
    PayRates.TabVisible:=(((Not HideDAdd) and (DDMode=0)) and (PChkAllowed_In(222))) or (GlobPRate<>0) ;
    Notes.TabVisible:=((Not HideDAdd) and (DDMode=0)) and (GlobPRate=0);
    Main.TabVisible:=(GlobPRate=0);

    AppsTPage.TabVisible:=((Not HideDAdd) and (DDMode=0)) and (GlobPRate=0) and (PChkAllowed_In(456) and (JAPOn) and (EType=2));
    StatTPage.TabVisible:=((Not HideDAdd) and (DDMode=0)) and (GlobPRate=0) and (PChkAllowed_In(-254) and (JAPOn) and (EType=2));
    ContractPage.TabVisible:=((Not HideDAdd) and (DDMode=0)) and (GlobPRate=0) and (PChkAllowed_In(455) and (JAPOn) and (EType=2));
  end;
end;


procedure TJEmpRec.FormDesign;

Var
 n        :  Integer;
 HideCC   :  Boolean;

begin

  Find_FormCoord;


  HideCC:=Syss.UseCCDep;


  ECCF.Visible:=HideCC;
  EDepF.Visible:=HideCC;
  CCLab.Visible:=HideCC;

  LabChkF.Visible:=BOn;


  If (CurrentCountry=DefaultCountry) then
  Begin
    
    {GrpChkF.Caption:='Company Group CIS 6 Certificate';}
    CBCertType.Visible:=BOn;
    Label811.Visible:=BOn;


    GrpChkF.Visible:=Not CIS340;
    Label87.Caption:='Company Reg. No.'; //AP : 24/01/2017 2017-R1 ABSEXCH-18152 : Employees - Sub Contractor Type - Rename CRN to Company Reg. No.
    Label811.Caption:='CIS Tax Rate';

    With CBCertType do
    Begin
      With Items do
      Begin
        Strings[1]:=TxLate_CISTypeStr(1);
        Strings[2]:=TxLate_CISTypeStr(4);
        Strings[3]:='Zero Rate';

        // MH 05/06/2009: Modified at DR/FJ request to remove CIS5 and CIS6 from CIS Tax Rate List
        If (CurrentCountry = UKCCode) Then
        Begin
          // Delete in reverse order so as not to change the indexes
          Delete(5);  // CIS 6 Group
          Delete(4);  // CIS 5 Partner
        End; // If (CurrentCountry = UKCCode)
      end; {With..}
    end; {With..}

    Label810.Visible:=Not CIS340;
    EExpF.Visible:=Label810.Visible;

    Label816.Visible:=CIS340;


  end
  else
    If (CurrentCountry=IECCode) then
    Begin
      Label87.Caption:='C2 Cert Ref.';
      GrpChkF.visible:=BOff;
      CBCertType.Visible:=BOn;
      Label811.Visible:=BOn;
      Label812.Caption:='Serial No. ';

      EUTRF.Visible:=BOff;
      EVerF.Visible:=BOff;
      ETagF.Visible:=BOff;

      Label816.Visible:=BOff;
      

      With CBCertType do
      Begin
        With Items do
        Begin
          Clear;

          Add('N/A');
          Add(TxLate_CISTypeStr(1));
          Add(TxLate_CISTypeStr(2));
        end;

        ExtendedList:=BOn; MaxListWidth:=150;

        With ItemsL do
        Begin
          Clear;

          Add('N/A');
          Add('No C2 or No RCT47. (Taxed)');
          Add('C2 & RCT47. (Gross)');
        end;

      end;


    end
    else
      GrpChkF.Top:=CBCertType.Top-5;

  With EmTypF do
  Begin
    For n:=1 to NofEmplTypes do
      Items.Add(EmplTDescL^[n]);
  end;

  CBSubType.Visible:=Label816.Visible;

  //PR: 14/11/2011 Amended to use centralised function SetUdfCaptions in CustomFieldsIntf.pas ABSEXCH-12129
  SetUDFCaptions([UD1Lab, UD2Lab, UD3Lab, UD4Lab], cfEmployee);

  If (CISOn) then
  Begin
    Notes1.Caption:=CCCISName^+' Led&ger';
    NteCp1Btn.Caption:=Notes1.Caption;
  end;

  FormSetOfSet;

  PrimeButtons;

  BuildDesign;

  SetTabs;

  //HV 23/11/2017 2018-R1 ABSEXCH-19405: procedure to set a Highlighting PII Fields flag for GDPR
  if GDPROn then
    SetGDPREnabled([EUD1F, EUD2F, EUD3F, EUD4F], cfEmployee); 
end;


procedure TJEmpRec.SetTabs;

Begin
  PrimeButtons;
end;


procedure TJEmpRec.BuildMenus;
Begin
  //Status1 is the menu item 'Status' in the popup menu control 'popmnuStatus'
  //take the 'popmnuStatus' control and make it a submenu of the 'Open', 'Close' menu item
  CreateSubMenu(popmnuStatus, Status1);
end;


procedure TJEmpRec.FormCreate(Sender: TObject);

Var
  n        :  Integer;
  ShowCC   :  Boolean;

begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  fFrmClosing:=BOff;

  FListScanningOn := False;

  Visible:=BOff;

  ManClose:=BOff;

  InitSize.Y:=370;// 328;
  InitSize.X:=738;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=353;
  Width:=566;}

  MDI_SetFormCoord(TForm(Self));

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;



  {* Set Version Specific Info *}

  InHBeen:=BOff;
  FromHist:=BOff;
  HideDAdd:=BOff;
  F9Used:=BOff;

  StopPageChange:=BOff;

  DispTransPtr:=nil;
  HistFormPtr:=nil;

  RetRecPtr:=nil;

  LastHMode:=1;

  ListOfSet:=10;

  SKeypath:=0;
  GotCoord:=BOff;

  InCISVch:=BOff;


  GlobPRate:=GlobPRateMode;
  RateJCode:=GlobJCode;

  FormDesign;

  If (GlobPRate<>0) then
  Begin
    If (GlobPRate=2) then
      ExLocal.AssignFromGlobal(JobF);
      
    SetCaption;
    PageControl1Change(PageControl1);
  end
  else
    ChangePage(0);


  BuildMenus;

end;


procedure TJEmpRec.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  {For n:=Low(MULCtrlO) to 3 do  {* Seems to crash here if form open and you close app...
    If (MULCtrlO[n]<>nil) then
    Begin
      MULCtrlO[n].Destroy;
      MULCtrlO[n]:=nil;
    end;}
end;


procedure TJEmpRec.DefaultPageReSize;

Var
  n  :  Integer;

Begin

  CLSBox.Width:=PageControl1.Width-PagePoint[0].X;
  CLSBox.Height:=PageControl1.Height-PagePoint[0].Y;

  RTSBox.Width:=CLSBox.Width;
  RTSBox.Height:=CLSBox.Height;

  CListBtnPanel.Left:=CLSBox.Width+4;

  {COSBox.Height:=CLSBox.Height;
  COSBox.Width:=CLSBox.Width;

  COListBtnPanel.Left:=COSBox.Width+4;}

  CLORefPanel.Height:=CLSBox.Height-PagePoint[2].X;

  CListBtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

  {COListBtnPanel.Height:=CListBtnPanel.Height;}


  For n:=Low(MULCtrlO) to High(MULCtrlO) do
    If (MULCtrlO[n]<>nil) then
    Begin
      With MULCtrlO[n],VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=CLORefPanel.Height;

        ReFresh_Buttons;

        RefreshAllCols;
      end;
    end;

end;


procedure TJEmpRec.NotePageReSize;

Begin
  With TCNScrollBox do
  Begin
    TCNListBtnPanel.Left:=Width+4;

    TNHedPanel.Width:=HorzScrollBar.Range;
    NDatePanel.Height:=TCNListBtnPanel.Height;
  end;

  NDescPanel.Height:=NDatePanel.Height;
  NUserPanel.Height:=NDatePanel.Height;

  {TCNBtnScrollBox.Height:=TCMBtnScrollBox.Height;}

  {$IFDEF NP}

    If (NotesCtrl<>nil) then {* Adjust list *}
    With NotesCtrl.MULCtrlO,VisiList do
    Begin
      VisiRec:=List[0];

      With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=NDatePanel.Height;

      ReFresh_Buttons;

      RefreshAllCols;
    end;

  {$ENDIF}


end;




procedure TJEmpRec.FormResize(Sender: TObject);
Var
  n          :  Byte;
begin

  If (GotCoord) then
  Begin
    // MH 19/04/2010: Changed to use window handle to avoid extreme flickering which also affected other apps
    LockWindowUpDate({PageControl1.}Handle);

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;
    
    PageControl1.Width:=ClientWidth-PageP.X;
    PageControl1.Height:=ClientHeight-PageP.Y;


    TCMPanel.Left:=PageControl1.Width-ScrollAP.X;
    TCMPanel.Height:=PageControl1.Height-ScrollAP.Y;


    TCMScrollBox.Width:=PageControl1.Width-ScrollBP.X;
    TCMScrollBox.Height:=PageControl1.Height-ScrollBP.Y;

    TCMBtnScrollBox.Height:=TCMPanel.Height-Misc1P.X;


    {TCDPanel.Left:=PageControl1.Width-PagePoint[0].X;
    TCDPanel.Height:=PageControl1.Height-PagePoint[0].Y;}


    {TCDScrollBox.Width:=PageControl1.Width-PagePoint[1].X;
    TCDScrollBox.Height:=(PageControl1.Height-PagePoint[1].Y)+1;}

    {TCNPanel.Left:=PageControl1.Width-PagePoint[2].X;
    TCNPanel.Height:=PageControl1.Height-PagePoint[2].Y;}


    TCNScrollBox.Width:=PageControl1.Width-PagePoint[3].X;
    TCNScrollBox.Height:=PageControl1.Height-PagePoint[3].Y;

    TCNListBtnPanel.Height:=TCNScrollBox.ClientHeight-PagePoint[4].X;

    DefaultPageReSize;

    NotePageReSize;

    // HV 30/11/2017 ABSEXCH-19394: Implements anonymisation behaviour for Emp
    SetAnonymisationPanel;

    LockWindowUpDate(0);

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
end; {Proc..}


procedure TJEmpRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If (Current_Page<1) or (Sender is TSBSComboBox) then
    GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TJEmpRec.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  n       :  LongInt;

begin


  Action:=caFree;

end;



Function TJEmpRec.CheckListFinished  :  Boolean;

Var
  n       :  Byte;
  mbRet   :  Word;
Begin
  Result:=BOn;

  For n:=Low(MULCtrlO) to High(MULCtrlO) do
  Begin
    If (Assigned(MULCtrlO[n])) then
      Result:=Not MULCtrlO[n].ListStillBusy;

    If (Not Result) then
    Begin
      Set_BackThreadMVisible(BOn);

      mbRet:=MessageDlg('One of the lists is still busy.'+#13+#13+
                        'Do you wish to interrupt the list so that you can exit?',mtConfirmation,[mbYes,mbNo],0);

      If (mBRet=mrYes) then
      Begin
        MULCtrlO[n].IRQSearch:=BOn;

        ShowMessage('Please wait a few seconds, then try closing again.');
      end;

      Set_BackThreadMVisible(BOff);

      Break;
    end;
  end;
end;


procedure TJEmpRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

Var
  n       :  Integer;


begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try

      CanClose:=ConfirmQuit;

      If (CanClose) then
        CanClose:=CheckListFinished;

      GenCanClose(Self,Sender,CanClose,BOff);

      If (CanClose) then
        CanClose:=GenCheck_InPrint;

      If (CanClose) then
      Begin

        For n:=0 to Pred(ComponentCount) do
          If (Components[n] is TScrollBox) then
          With TScrollBox(Components[n]) do
          Begin
            VertScrollBar.Position:=0;
            HorzScrollBar.Position:=0;
          end;

        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;


        If (NeedCUpdate) then
          Store_FormCoord(Not SetDefault);


        Send_UpdateList(BOff,100+GlobPRate);

        {$IFDEF NP}
          If (NotesCtrl<>nil) then
          Begin
            try
              // MH 11/01/2011 v6.6 ABSEXCH-10718: Fix to prevent access violations if mouse moved across Notes column titles whilst form closes
              NotesCtrl.UnHookOnMouse;
              NotesCtrl.Free;

            finally

              NotesCtrl:=nil;
            end;
          end;
        {$ENDIF}

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;
end;


procedure TJEmpRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

Begin
  If (Current_Page<1) or (Key In [VK_F1..VK_F12,VK_Prior,VK_Next])  or (Sender is TComboBox) then
  Begin
    F9Used:=(Key In [VK_F9]);

    GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  end;

end;


procedure TJEmpRec.ClsCP1BtnClick(Sender: TObject);
begin
  If (ConfirmQuit) then
  Begin
    Close;
  end;
end;


{ === Procedure to set read/write access to record === }

Procedure TJEmpRec.SetFieldRW;

Begin
  With ExLocal,LJobMisc^.EmplRec do
  Begin
    If (InAddEdit) and (Not SupAcF.ReadOnly) then
    Begin
      SupAcF.ReadOnly:=(EmTypF.ItemIndex<>1);

      ECertF.ReadOnly:=SupAcF.ReadOnly;
      EExpF.ReadOnly:=SupAcF.ReadOnly;

      GrpChkF.Enabled:=Not SupAcF.ReadOnly;
      GenSBF.Enabled:=Not SupAcF.ReadOnly;

      ECertF.TabStop:=Not ECertF.ReadOnly;

      CBCertType.Enabled:=Not SupAcF.ReadOnly;

      EExpF.TabStop:=Not ECertF.ReadOnly;
      GrpChkF.TabStop:=GrpChkF.Enabled;

      GenSBF.TabStop:=GrpChkF.Enabled;

      CBSubType.Enabled:=Not ECertF.ReadOnly;
      CBSubType.TabStop:=Not ECertF.ReadOnly;

    end;


    LabChkF.Visible:=(EmTypF.ItemIndex=1);

    GenSBF.Visible:=(LabChkF.Visible and (Not LabChkF.Checked));

  end; {With..}
end; {Proc..}

{ === Procedure to Output one cust record === }

Procedure TJEmpRec.OutEmpl;

Var
  Dnum       :   Double;

  n          :   LongInt;

  FoundStr   :   Str20;


Begin

  With ExLocal,LJobMisc^.EmplRec do
  Begin

    EMAccF.Text:=Trim(EmpCode);

    If (EType>0) then
      EMTypF.ItemIndex:=Pred(EType);
      
    // HV 30/11/2017 ABSEXCH-19394: Implements anonymisation behaviour for Emp
    if FAnonymisationON and (emAnonymisationStatus = asAnonymised) then
      ENamF.Text := capAnonymised
    else
      ENamF.Text := EmpName;
      
    LinkCF.Text:=Supplier;

    LGetMainRecPos(CustF,Supplier);

    SupAcF.Text:=LCust.Company;

    EAd1F.Text:=Addr[1];
    EAd2F.Text:=Addr[2];
    EAd3F.Text:=Addr[3];
    EAd4F.Text:=Addr[4];
    EAd5F.Text:=Addr[5];

    ETelF.Text:=Phone;
    edtEmailAddr.Text := emEmailAddr;
    EFaxF.Text:=Fax;
    EMobF.Text:=Phone2;

    EPayNoF.Text:=PayNo;
    ECertF.Text:=CertNo;

    GrpChkF.Checked:=BOff;
    EUTRF.Text:=UTRCode;
    EVerF.Text:=VerifyNo;
    ETagF.Checked:=(Tagged=1);

    GenSBF.Checked:=GSelfBill;

    EExpF.DateValue:=CertExpiry;

    LabChkF.Checked:=LabPLOnly;
    LabChkFClick(Nil);

//    If (CISType>=0) then
      CBCertType.ItemIndex:=TxLate_CISType(CISType,BOn);

//    If (CISSubType>=0) then
      CBSubType.ItemIndex:=CISSubType;

    ENINOF.Text:=ENINO;

    ECCF.Text:=Trim(CCDep[BOn]);
    EDepF.Text:=Trim(CCDep[BOff]);

    EChkF.ItemIndex:=UseORate;
    EUD1F.Text:=UserDef1;
    EUD2F.Text:=UserDef2;
    EUD3F.Text:=UserDef3;
    EUD4F.Text:=UserDef4;

    //RB 28/11/2017 2018-R1 ABSEXCH-19499: 6.3.2.4 (Before ABSEXCH-19393) - Add Status field to Employee and Button to change status for employee
    edEmpStatus.Text := Show_EmpStatus(emStatus);
    SetFieldRW;
  end; {with..}

end; {Proc..}


Procedure TJEmpRec.Form2Empl;

Var
  I,n  :  Integer;

Begin

  With ExLocal,LJobMisc^,EmplRec do
  Begin


    EmpCode:=FullEmpKey(EMAccF.Text);

    EType:=Succ(EMTypF.ItemIndex);

    If (EType=EmplSubCode) then
      Supplier:=FullCustCode(LinkCF.Text);

    EmpName:=ENamF.Text;

    Addr[1]:=EAd1F.Text;
    Addr[2]:=EAd2F.Text;
    Addr[3]:=EAd3F.Text;
    Addr[4]:=EAd4F.Text;
    Addr[5]:=EAd5F.Text;

    Phone:=ETelF.Text;
    emEmailAddr := edtEmailAddr.Text;
    Fax:=EFaxF.Text;
    Phone2:=EMobF.Text;

    PayNo:=EPayNoF.Text;
    CertNo:=ECertF.Text;

    If (ValidDate(EExpF.DateValue)) then
      CertExpiry:=EExpF.DateValue
    else
      Blank(CertExpiry,Sizeof(CertExpiry));

    UTRCode:=EUTRF.Text;
    VerifyNo:=EVerF.Text;
    Tagged:=Ord(ETagF.Checked);

    GroupCert:=GrpChkF.Checked;

    If (CBCertType.ItemIndex>=0) then
      CISType:=TxLate_CISType(CBCertType.ItemIndex,BOff)
    else
      CISType:=0;

    If (CBSubType.ItemIndex>=0) then
      CISSubType:=CBSubType.ItemIndex
    else
      CISSubType:=0;

    GSelfBill:=GenSBF.Checked;

    LabPLOnly:=LabChkF.Checked;


    CCDep[BOn]:=FullCCDepKey (ECCF.Text);
    CCDep[BOff]:=FullCCDepKey (EDepF.Text);

    If (EChkF.ItemIndex>=0) then
      UseORate:=EChkF.ItemIndex;

    UserDef1:=EUD1F.Text;
    UserDef2:=EUD2F.Text;
    UserDef3:=EUD3F.Text;
    UserDef4:=EUD4F.Text;

    ENINO:=ENINOF.Text;


  end; {with..}

end; {Proc..}


Procedure TJEmpRec.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      0  :  If (LastEdit) then
              EmTypF.SetFocus
            else
              EMAccF.SetFocus;

    end; {Case&With..}

end; {Proc..}


Procedure TJEmpRec.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  If (Pages[NewPage].TabVisible) then
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);


  end; {With..}
end; {Proc..}


Function TJEmpRec.CheckNeedStore  :  Boolean;

Var
  Loop  :  Integer;

Begin
  Result:=BOff;
  Loop:=0;

  While (Loop<=Pred(ComponentCount)) and (Not Result) do
  Begin
    If (Components[Loop] is TMaskEdit) then
    With (Components[Loop] as TMaskEdit) do
    Begin
      Result:=((Tag=1) and (Modified));

      If (Result) then
        Modified:=BOff;
    end
    else
      If (Components[Loop] is TCurrencyEdit) then
      With (Components[Loop] as TCurrencyEdit) do
      Begin
        Result:=((Tag=1) and (FloatModified));

        If (Result) then
          FloatModified:=BOff;
      end
      else
        If (Components[Loop] is TBorCheck) then
        With (Components[Loop] as TBorCheck) do
        Begin
          Result:=((Tag=1) and (Modified));

          If (Result) then
            Modified:=BOff;
        end
        else
          If (Components[Loop] is TSBSComboBox) then
          With (Components[Loop] as TSBSComboBox) do
          Begin
            Result:=((Tag=1) and (Modified));

            If (Result) then
              Modified:=BOff;
          end;

    Inc(Loop);
  end; {While..}
end;


Function TJEmpRec.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;


  If (ExLocal.InAddEdit) and (CheckNeedStore) then
  Begin
    If (Current_Page>1) then {* Force view of main page *}
      ChangePage(0);

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreEmpl(JMiscF,SKeypath,ExLocal.LastEdit);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) then
                  Status:=UnLockMLock(JMiscF,LastRecAddr[JMiscF]);

                If (InAddEdit) then
                  SetEmplStore(BOff,LastEdit);

                TmpBo:=BOn;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                SetfieldFocus;
              end;
  end; {Case..}


  ConfirmQuit:=TmpBo;
end; {Func..}


procedure TJEmpRec.SetCompRO(TC     :  TComponent;
                        Const TG     :  Integer;
                        Const EnabFlg:  Boolean);


Begin
  If (TC is TMaskEdit) then
    With (TC as TMaskEdit) do
    Begin
      If (Tag=TG) then
      Begin
        ReadOnly:= Not EnabFlg;
        TabStop:=Not ReadOnly;
      end;
    end
    else
      If (TC is TCurrencyEdit ) then
      With (TC as TCurrencyEdit) do
      Begin
        If (Tag=TG) then
        Begin
          ReadOnly:= Not EnabFlg;
          TabStop:=Not ReadOnly;
        end;
      end
      else
        If (TC is TBorCheck) then
        With (TC as TBorCheck) do
        Begin
          If (Tag=TG) then
          Begin
            Enabled:=EnabFlg;
          end;
        end
        else
          If (TC is TBorRadio) then
          With (TC as TBorRadio) do
          Begin
            If (Tag=TG) then
            Begin
              Enabled:=EnabFlg;
            end;
          end
          else
            If (TC is TSBSComboBox) then
            With (TC as TSBSComboBox) do
            Begin
              If (Tag=TG) then
              Begin
                ReadOnly:=Not EnabFlg;
                TabStop:=Not ReadOnly;
              end;
            end;
end;


procedure TJEmpRec.SetEmplStore(EnabFlag,
                                ButnFlg  :  Boolean);

Var
  Loop  :  Integer;

Begin

  OkCP1Btn.Enabled:=EnabFlag;
  CanCP1Btn.Enabled:=EnabFlag;

  AddCP1Btn.Enabled:=Not EnabFlag;

  EditCP1Btn.Enabled:=Not EnabFlag;

  FindCP1Btn.Enabled:=Not EnabFlag;


  HistCP1Btn.Enabled:=Not EnabFlag;

  InsCP1Btn.Enabled:=Not EnabFlag;
  PrnCP1Btn.Enabled:=Not EnabFlag;
  {CopyCP1Btn.Enabled:=Not EnabFlag;}
  LnkCP1Btn.Enabled:=Not EnabFlag;

  NteCp1Btn.Enabled:=Not EnabFlag;
  //RB 28/11/2017 2018-R1 ABSEXCH-19499: 6.3.2.4 (Before ABSEXCH-19393) - Add Status field to Employee and Button to change status for employee
  btnStatus.Enabled := Not EnabFlag;

  ExLocal.InAddEdit:=EnabFlag;

  DelCP1Btn.Enabled:=((Not EnabFlag) and (SetDelBtn));

  For Loop:=0 to ComponentCount-1 do
  Begin
    SetCompRO(Components[Loop],1,EnabFlag);
  end;

  With ExLocal do
    EMAccF.ReadOnly:=(Not Enabled) or ((Not CanDelete) and ((Not InAddEdit) or (LastEdit))) ;

  //PR: 04/12/2017 ABSEXCH-19479
  btnPIITree.Enabled := not EnabFlag;

end;




(*  Add is used to add Jobs *)

procedure TJEmpRec.ProcessEmpl(Fnum,
                               KeyPAth    :  Integer;
                               Edit       :  Boolean);

Var
  KeyS     :  Str255;
  n        :  Integer;

Begin

  Addch:=ResetKey;

  KeyS:='';


  SKeypath:=Keypath;

  Elded:=Edit;

  HideDAdd:=BOn;

  If (Edit) then
  Begin

    With ExLocal do
    Begin
      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked);

    end;


    If (Not Ok) or (Not GlobLocked) then
      AddCh:=#27;
  end
  else
  Begin


  end;

  BuildDesign;


  If (Addch<>#27) then
  With ExLocal,LJobMisc^,EmplRec do
  begin


    If (Not Edit) then
    Begin
      Caption:='Add Employee Record';
      LResetRec(Fnum);

      RecPFix:=JARCode;
      SubType:=JASubAry[3];
      EType:=1;

      NlineCount:=1;

      CanDelete:=BOn;

    end;

    LastJobMisc^:=LJobMisc^;

    SetEmplStore(BOn,BOff);

    OutEmpl;

    SetFieldFocus;

  end; {If Abort..}

end; {Proc..}


Procedure TJEmpRec.NoteUpdate;


Const
  Fnum     =  JMiscF;
  Keypath  =  JMK;


Var
  KeyS  :  Str255;


Begin

  GLobLocked:=BOff;

  {$IFDEF NP}

    KeyS:=PartCCKey(JARCode,JASubAry[3])+NotesCtrl.GetFolio;

    With ExLocal do
    Begin
      Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPAth,Fnum,BOn,GlobLocked);

      If (Ok) and (GlobLocked) then
      With LJobMisc^,EmplRec do
      With NotesCtrl do
      Begin
        LGetRecAddr(Fnum);

        NLineCount:=GetLineNo;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        Report_Berror(Fnum,Status);

        {* Explicitly remove multi lock *}

        UnLockMLock(Fnum,LastRecAddr[Fnum]);
      end;

    end; {With..}

  {$ENDIF}


end; {Func..}




Function TJEmpRec.ScanMode  :  Boolean;

Var
  n  :  Byte;

Begin
  If (Assigned(DispTransPtr)) then
  With TFInvDisplay(DispTransPtr) do
  Begin
    For n:=Low(TransActive) to High(TransActive) do
    Begin
      Result:=TransActive[n];

      If (Result) then
        break;
    end;
  end
  else
    Result:=BOff;
end;



Procedure TJEmpRec.WMCustGetRec(Var Message  :  TMessage);

Var
  ListPoint  :  TPoint;
  LastPage   :  TTabSheet;
  SMode      :  Integer;


Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      0,1,169
         :  If (Current_Page In [LedgerPage,AppPage,ContPage]) then
            Begin
              If (WParam=169) then
              Begin
                MULCtrlO[Current_Page].GetSelRec(BOff);
                WParam:=0;
              end;

              InHBeen:=((WParam=0) or ((InHBeen) and ScanMode));

              Display_Trans(2+(98*WParam));

            end
            else
            If (Current_Page=RatePage) and (Assigned(MULCtrlO[3])) and (WParam In [0,169]) then
            Begin
              If (MULCtrlO[Current_Page].ValidLine) then
                EditRetRec(EditCP1Btn,BOff);
            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      7  :  NoteUpDate; {* Update note line count *}

     17  :  Begin {* Force reset of form *}
              GotCoord:=BOff;
              SetDefault:=BOn;
              Close;
            end;
     25  :  NeedCUpdate:=BOn;

     108
         :  With MULCtrlO[Current_Page] do
            Begin

              AddNewRow(MUListBoxes[0].Row,(LParam=1));

            end;


     110 :  Begin
              If (Current_Page<>MainPage) then
                ChangePage(0);
              Show;
            end;


     {$IFDEF FRM}

        170  :  PrnCp1BtnClick(nil);

     {$ENDIF}

     175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

     177 :  Begin
              LastPage:=PageControl1.ActivePage;

              BuildDesign;

              If (PageControl1.ActivePage<>LastPage) then
                PageControl1.ActivePage:=LastPage;

              PrimeButtons;

              Check_TabAfterPW(PageControl1,Self,WM_CustGetRec);
            end;

     200 :  DispTransPtr:=nil;


     {$IFDEF Ltr}
       400,
       401  : Begin
                LetterActive:=Boff;
                LetterForm:=nil;
              end;
     {$ENDIF}

     {$IFDEF GF}

       3002
          : If (Assigned(FindCust)) then
              With MULCtrlO[LParam],FindCust,ReturnCtrl do
              Begin
                InFindLoop:=BOn;

                SMode:=SearchMode+10;

                Find_OnList(SMode,SearchKey);

                With MUListBoxes[0] do
                  If (CanFocus) then
                    SetFocus;

                InFindLoop:=BOff;
              end;
     {$ENDIF}

      3003
         :  Begin

              If (Not ExLocal.InAddEdit) then
              Begin
                ShowLink;
              end;
            end;





    end; {Case..}

  end;
  Inherited;
end;


Procedure TJEmpRec.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      41 :  Begin
              HistFormPtr:=nil;

              DDMode:=0;

              If (MULCtrlO[2]<>nil) then
              Begin

                DDCtrl.NHNeedGExt:=BOff;
                RefreshList(BOn,BOff);
              end;
            end;


      52,53
         :  Begin
              FromHist:=BOn;

              If (Current_Page<>LedgerPage) then
                ChangePage(LedgerPage);



              If (MULCtrlO[2]<>nil) then
              With ExLocal,MULCtrlO[2],DDCtrl do
              Begin
                ExLocal.AssignFromGlobal(NHistF);

                DDMode:=32;

                NHPr:=LNHist.Pr;
                NHYr:=LNHist.Yr;

                NHNeedGExt:=BOn;

                RefreshList(BOn,BOn);


              end;

              FromHist:=BOff;

            end;

      64,65
         :  Begin
              InHBeen:=((WParam=64) or (InHBeen));

              Display_Trans(2);
            end;

     66  :  InCISVch:=BOff;

      145:  Begin
              RetRecPtr:=nil;
            end;

       150
         :  Begin
              With MULCtrlO[3]do
              Begin

               AddNewRow(MUListBoxes[0].Row,(LParam=1));

              end;
            end;

       158
          : With MULCtrlO[3] do
            Begin

              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;

            end;


    end; {Case..}

  end;

  Inherited;
end;

Procedure TJEmpRec.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin

    ptMinTrackSize.X:=200;
    ptMinTrackSize.Y:=210;

    {ptMaxSize.X:=530;
    ptMaxSize.Y:=368;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;

Procedure TJEmpRec.WMNextDialog(Var Message  :  TMessage);


Begin
  {We only want to intercept F9 messages}
  If (ActiveControl=SupAcF) and (F9Used) then
  Begin
    LastValueObj.GetValue(TComponent(LinkCF));
    SupAcF.Text:=LinkCF.Text;
    
  end;
  F9Used:=BOff;

  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TJEmpRec.Send_UpdateList(Edit   :  Boolean;
                                    Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode+100;
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}



Function TJEmpRec.CheckCompleted(Edit  :  Boolean)  : Boolean;

Const
  NofMsgs      =  14;

Type
  PossMsgType  = Array[1..NofMsgs] of String[150];

Var
  PossMsg  :  ^PossMsgType;

  WarnMsg,
  ShowMsg,
  Loop      :  Boolean;

  Test, iChar, iLen     :  Byte;

  n,
  mbRet    :  Word;

  FoundCode:  Str20;

  FoundLong:  LongInt;

Begin
  ShowMsg := False;
  New(PossMsg);
  Loop:=BOff;
  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='The Employee Code entered already exists';
  PossMsg^[2]:='The Employee Code entered is not valid';
  PossMsg^[3]:='The Supplier code is not valid';
  PossMsg^[4]:='The Name entered is not valid, names for Sub-Contractors of this type must be entered as firstname and surname';
  //TG-01-06-2017- ABSEXCH-18682-No error is displayed on 'Edit' and 'OK'
  PossMsg^[5]:='Cost Centre Code not valid.';
  PossMsg^[6]:='Department Code not valid.';
  PossMsg^[7]:='The UTR entered is not valid';
  PossMsg^[8]:='';   // Should never be used
  PossMsg^[9]:='The Contracter Type entered is not valid for the CIS Tax Rate entered';
  PossMsg^[10]:='A Certificate Expiry date must be set for that Certificate type';
  If (CurrentCountry=IECCode) Then
    PossMsg^[11]:='A Certificate Number must be set for that Certificate type'
  Else
    PossMsg^[11]:='An invalid Company Registration Number (CRN) has been entered';
  PossMsg^[12]:='The NINO entered is not valid';
  PossMsg^[13]:='The Verification No. entered is not valid';
  PossMsg^[14]:='An additional check is made via an external hook';

  Test:=1;

  Result:=BOn; WarnMsg:=BOff;

  While (Test<=NofMsgs) and (Result)  and (Not WarnMsg) do
  With ExLocal,LJobMisc^,EmplRec do
  Begin
    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              If (Not Edit) then
                Result:=Not (CheckExsists(PartCCKey(RecPFix,SubType)+EmpCode,JMiscF,JMK))
              else
                Result:=BOn;
            end;

      2  :  Result:=(Not EmptyKey(EmpCode,EmplKeyLen));

      3  :  Result:=EmptyKey(Supplier,CustKeyLen) or Global_GetMainRec(CustF,Supplier);

      4  :  If (CurrentCountry=UKCCode) And (EType = 2) And (CISSubType In [1, 2]) Then
            Begin
              // Sub-Contractor - Sole Trader / Partnership - check name format
              Result := (Length(EmpName) >= 3) And (WordCnt(EmpName) >= 2) And (UpperCase(EmpName)[1] In ['A'..'Z']);
            End // If (CurrentCountry=UKCCode) And (EType = 2) And (CISSubType In [1, 2])
            Else
              Result := True;

            //TG-01-06-2017- ABSEXCH-18682-No error is displayed on 'Edit' and 'OK'
            //AP-16-06-2017- ABSEXCH-18682 - Error even when System is not using CC/Dep
      5  :  if (Syss.UseCCDep) then
              Result := GetCCDep(self,CCDep[True],FoundCode,(True),-1) ;
      6  :  if (Syss.UseCCDep) then
              Result := GetCCDep(self,CCDep[False],FoundCode,(False),-1) ;

      7  :  If (CurrentCountry=UKCCode) Then
            Begin
              Result := (UTRCode = '') Or CISValid_UTR(UTRCode);

              If Result And (UTRCode = '') And (EType = 2) And (CISSubType In [1, 3, 4]) And (CISType <> 1) Then
              Begin
                // Sole Trader / Trust / Company - Set Tax Rate to High when UTR blank
                CISType := 1;
                CBCertType.ItemIndex:=TxLate_CISType(CISType,BOn);
                MessageDlg ('The CIS Tax Rate has been changed to High because the UTR has not been set', mtWarning, [mbOk], 0);
              End // If Result And (UTRCode = '') And (CISSubType In [1, 3, 4]) And (CISType <> 1)
            End // If (CurrentCountry=UKCCode)
            Else
              WarnMsg:=(UTRCode<>'') and (Not CISValid_UTR(UTRCode));

      8   : Begin
              If (CurrentCountry=UKCCode) And (EType = 2) And (CISSubType = 2) Then
              Begin
                // Partnership - Set Tax Rate to High when Partnership UTR on Supplier is blank or if Supplier is blank
                If (Not EmptyKey(Supplier, CustKeyLen)) And Global_GetMainRec(CustF, Supplier) Then
                Begin
                  // Partnership UTR is stored in Supplier Credit Card Number field (classy!)
                  If (Cust.CCDCardNo = '') Or (Not CISValid_UTR(Cust.CCDCardNo)) Then
                  Begin
                    CISType := 1;
                    CBCertType.ItemIndex:=TxLate_CISType(CISType,BOn);
                    MessageDlg ('The CIS Tax Rate has been changed to High because the Partnership UTR on the Supplier is invalid', mtWarning, [mbOk], 0);
                  End; // If (Cust.CCDCardNo = '') Or (Not CISValid_UTR(Cust.CCDCardNo))
                End // If (Not EmptyKey(Supplier, CustKeyLen)) And Global_GetMainRec(CustF, Supplier)
                Else
                Begin
                  // Supplier blank or invalid - set Tax Rate to High
                  CISType := 1;
                  CBCertType.ItemIndex:=TxLate_CISType(CISType,BOn);
                  MessageDlg ('The CIS Tax Rate has been changed to High because the Supplier has not been set', mtWarning, [mbOk], 0);
                End; // Else
              End; // If (CurrentCountry=UKCCode) And (CISSubType = 2)

              Result := True;
            End;

      9  :  If (CurrentCountry=UKCCode) And (EType = 2) And (CISType > 0) Then
              Result := (CISSubType <> 0)
            Else
              Result := True;

      10 :  Result:=(CISType In [0,4]) or (CertExpiry<>'') or (EType<>2)  or (CIS340) ;

      11 :  Begin // CRN
              CertNo := Trim(CertNo);

              Result:=(CISType In [0]) or ((CertNo<>'') or CIS340) or ((CISType=1) and (CurrentCountry=IECCode)) ;

              // MH 28/05/2009: Added additional validation for v6.01
              If Result And (EType=2) And (CurrentCountry=UKCCode) And (CertNo <> '') Then
              Begin
                iLen := Length(CertNo);

                // Check if it is in AAN[NNNNN] format
                Result := (iLen >= 3) And (CertNo[1] In ['a'..'z', 'A'..'Z']) And (CertNo[2] In ['a'..'z', 'A'..'Z']);
                If Result Then
                Begin
                  // max length 8 (2 alpha + 6 numeric)
                  Result := (iLen <= 8);
                  If Result Then
                    For iChar := 3 To iLen Do
                    Begin
                      Result := (CertNo[iChar] In ['0'..'9']);
                      If (Not Result) Then Break;
                    End // For iChar
                End // If Result
                Else
                Begin
                  // Check is in N[NNNNNNN] format
                  Result := (iLen In [1..8]);
                  If Result Then
                    For iChar := 1 To Length(CertNo) Do
                    Begin
                      Result := (CertNo[iChar] In ['0'..'9']);
                      If (Not Result) Then Break;
                    End; // For iChar
                End; // Else
              End; // If Result And (EType=2) And (CurrentCountry=UKCCode) And (Trim(CertNo) <> '')
            End; // 7

      12  :  If (CurrentCountry=UKCCode) Then
              Result := (ENINo = '') Or CISValid_NINO(ENINo)
            Else
              WarnMsg:=(ENINo<>'') and (Not CISValid_NINO(ENINo));

      13 :  If (CurrentCountry=UKCCode) Then
              Result := (VerifyNo = '') Or CISValid_VerNo(VerifyNo)
            Else
              WarnMsg:=(VerifyNo<>'') and (Not CISValid_VerNo(VerifyNo));

      14 :  Begin {* Opportunity for hook to validate this line as well *}
              {$IFDEF CU}
                 LJobRec^.UserDef1:=UserDef1;
                 LJobRec^.UserDef2:=UserDef2;
                 LJobRec^.UserDef3:=UserDef3;
                 LJobRec^.UserDef4:=UserDef4;

                 Result:=ValidExitHook(5000,50,ExLocal);
                 ShowMsg:=BOff;

               {$ENDIF}
              end;


    end;{Case..}

    If (Result) and (Not WarnMsg) then
      Inc(Test);

  end; {While..}

  If ((Not Result) or (WarnMsg)) and (ShowMsg) then
    mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}






Procedure TJEmpRec.SetCaption;

Var
  LocTit  :  Str50;
  lStr: String;
Begin
  LocTit:='';
  With ExLocal,LJobMisc^,EmplRec,DDCtrl do
  Begin
    Case GlobPRate of
      1  :  Caption:='Global Time Rates.';
      2  :  With LJobRec^ do
              Caption:='Job Time Rates.'+dbFormatName(JobCode,JobDesc);
    else
      begin
        // HV 30/11/2017 ABSEXCH-19394: Implements anonymisation behaviour for Emp
        if FAnonymisationON and (emAnonymisationStatus = asAnonymised) then
          lStr := capAnonymised
        else
          lStr := EmpName;
        Caption:='Employee Record '+dbFormatName(EmpCode, lStr);
      end;
    end; {Case..}
  end;
end;


procedure TJEmpRec.StoreEmpl(Fnum,
                             KeyPAth    :  Integer;
                             Edit       :  Boolean);

Var
  COk,
  StoredOK
       :  Boolean;
  TmpJobM
       :  JobMiscRec;
  KeyS :  Str255;

  MbRet:  Word;

  NewSCode
       :  Str20;

  UpdateGrpCert
       :  Boolean;


Begin
  KeyS:='';     NewSCode:='';

  Form2Empl;

  UpdateGrpCert:=BOff;  StoredOk:=BOff;

  With ExLocal,LJobMisc^,EmplRec do
  Begin

    If (Edit) and (LastJobMisc^.EmplRec.EmpCode<>EmpCode) then
    Begin
      COk:=(Not Check4DupliGen(EmpCode,Fnum,JMK,'Employee code'));
    end
    else
      COk:=BOn;

    If (COk) then
      COk:=CheckCompleted(Edit);

    If (COk) then
    Begin
      Cursor:=crHourGlass;

      Surname:=ExtractWords(WordCnt(EmpNAme),1,EmpName);

      UpdateGrpCert:=(GroupCert and (Etype=EmplSubCode) and
                         ((LastJobMisc^.EmplRec.CertNo<>CertNo)
                          or (LastJobMisc^.EmplRec.CertExpiry<>CertExpiry)))
                          or (LastJobMisc^.EmplRec.LabPLOnly<>LabPLOnly)

                          ;


      If (Edit) then
      Begin
        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpJobM:=LJobMisc^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LJobMisc^:=TmpJobM;
        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
      end
      else
      Begin
        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
        CanDelete:=BOn;
      end;

      SetCaption;

      Report_BError(Fnum,Status);

      LGetRecAddr(Fnum);  {* Refresh record address *}

      StoredOk:=StatusOk;

      If (StatusOk) then
      Begin
        Send_UpdateList(Edit,0+GlobPRate);
      end;

      If (Edit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      // MH 20/03/13 v7.0.2 ABSEXCH-14162: Added After Store hook point for HF Group
      {$IFDEF CU} {* Call any post store hooks here *}
        If (Status = 0) Then
        Begin
          GenHooks(5000, 51, ExLocal);
        End; // If (Status = 0)
      {$ENDIF}

      SetEmplStore(BOff,Edit);

      Cursor:=CrDefault;

      LastValueObj.UpdateAllLastValues(Self);
      LastValueObj.StoreValue(TComponent(LinkCF));

      If (HideDAdd) then
      Begin
        HideDAdd:=BOff;
        SetTabs;
        BuildDesign;
      end;

      {$IFDEF PF_On}
        {$IFDEF POST}
          If (StoredOK) and (UpdateGrpCert) then
            AddGrpCertUpdate2Thread(Application.MainForm,LJobMisc^.EmplRec);
        {$ENDIF}
      {$ENDIF}
    end
    else
    Begin

      {ChangeNBPage(1);}

      SetFieldFocus;

    end;
 end; {If..}

end;



procedure TJEmpRec.OkCP1BtnClick(Sender: TObject);

Var
  TmpBo  :  Boolean;
  KeyS   :  Str255;

begin

  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
      StoreEmpl(JMiscF,SKeypath,ExLocal.LastEdit)
    else
      If (ModalResult=mrCancel) then
      Begin
         If (Not ExLocal.LastEdit) then {* Force close..}
         Begin
           Close;
           Exit;
         end;

        If (ConfirmQuit) then
        With ExLocal do
        Begin


          If (InAddEdit) then
            LJobMisc^:=LastJobMisc^;
          OutEmpl;

          If (HideDAdd) then
          Begin
            HideDAdd:=BOff;
            BuildDesign;
            SetTabs;
          end;

        end;
      end;
  end; {With..}
end;

procedure TJEmpRec.EditAccount(Edit  :  Boolean);
begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    If (Not Edit) then
      ChangePage(0);

    ProcessEmpl(JMiscF,CurrKeyPath^[JMiscF],LastEdit);
  end;
end;


procedure TJEmpRec.DeleteAccount;

Const
  Fnum  =  JMiscF;


Var
  MbRet  :  Word;
  KeyS   :  Str255;

  lRes,
  Keypath:  Integer;

  LastCursor
         :  TCursor;
  lAnonDiaryDetail: IAnonymisationDiaryDetails;
Begin

  MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Employee Record',
                     mtConfirmation,[mbYes,mbNo],0);


  If (MbRet=MrYes) then
  With ExLocal do
  Begin
    LastCursor:=Cursor;

    Cursor:=crHourGlass;

    Self.Enabled:=BOff;

    try

      Keypath:=CurrKeyPath^[Fnum];

      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,GlobLocked);

      If (Ok) and (GlobLocked) then
      Begin
        Status:=Delete_Rec(F[Fnum],Fnum,CurrKeyPath^[Fnum]);

        Report_BError(Fnum,Status);

        If (StatusOk) then {* Delete any dependant links etc *}
        With LJobMisc^,EmplRec do
        Begin
          {* Delete all other links *}

          KeyS:=PartCCKey(JBRCode,JBSubAry[4])+FullEmpKey(EmpCode);

          DeleteLinks(KeyS,JCtrlF,Length(KeyS),JCK,BOff);

          {$IFDEF NP}
            Delete_Notes(NoteECode,FullNCode(EmpCode)); {* Auto Delete Notes *}
          {$ENDIF}

          {$IFDEF Ltr}
            { Delete any letters/Links }
            DeleteLetters (LetterEmplCode, EmpCode);
          {$ENDIF}

          //HV ABSEXCH-19607:Delete record from exchequer should remove Data from Anon. Control centre window.
          //Record Delete from Anon. Diary Table
          if GDPROn then
          begin
            lAnonDiaryDetail := CreateSingleAnonObj;
            if Assigned(lAnonDiaryDetail) then
            begin
              lRes := lAnonDiaryDetail.RemoveEntity(adeEmployee, EmpCode);
              if lRes = 0 then
                SendMessage(Application.MainForm.Handle, WM_FormCloseMsg, 103, 0);
            end;
          end;

          {Also delete other details }
          Send_UpdateList(Boff,200+GlobPRate);

          Cursor:=Lastcursor;

          Close;
        end;
      end;
    finally
      Cursor:=LastCursor;
    end;
  end;
end; {PRoc..}


procedure TJEmpRec.DeleteDoc;


Var
  MbRet  :  Word;
  KeyS   :  Str255;

  Keypath:  Integer;

  LAddr  :  LongInt;


Begin
  With MULCtrlO[Current_Page] do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin

      {$IFDEF CU}
        If (ValidExitHook(2000,100,ExLocal)) then
      {$ENDIF}

      Begin
        GetSelRec(BOff);

        If Delete_Application(Inv,BOn,ScanFileNum,Keypath,ExLocal) then
        Begin
          PageUpDn(0,BOn);

          If (PageKeys^[0]=0) then {* Update screen as we have lost them all!*}
            InitPage

        end;

      end;
    end; {If confirm delete..}
  end; {If ok..}
end; {PRoc..}



procedure TJEmpRec.EditCharge;

Begin
  If (Assigned(MULCtrlO[2])) then
    If (MULCtrlO[2].ValidLine) then
    With MULCtrlO[2] do
    Begin

      EditActCharge(Self,CLORefPanel.Color,CLORefPanel.Font,0,ExLocal,ScanFileNum,KeyPath,JobDetl^.JobActual.CurrCharge);

      RefreshLine(MUListBoxes[0].Row,BOn);

    end;

end;



procedure TJEmpRec.EditCP1BtnClick(Sender: TObject);

Var
  EMode  :  Byte;

begin

  Case Current_Page of
    NotesPage
        :  AddCP3BtnClick(Sender);
    LedgerPage
        :  EditCharge;

    RatePage
        :  EditRetRec(Sender,Current_Page=4);

    AppPage,ContPage
        :  Begin
             eMode:=Ord((Sender=EditCP1Btn) or (Sender=Edit1));

             If (eMode=1) then
               InHBeen:=BOn;

             Display_Trans(1+(1*eMode));
           end;

    else
    begin
      FListScanningOn := True;
      AnonymisationON := FAnonymisationON and (Sender=EditCP1Btn);
      EditAccount(Sender = EditCP1Btn);
    end;
  end; {Case..}    
end;



procedure TJEmpRec.ShowLink;
Var
  StartPage  :  Integer;
{$IFDEF Ltr}
  OldCust, TmpPtr : CustRecPtr;
{$ENDIF}
begin
  StartPage:=Current_Page;

  ExLocal.AssignFromGlobal(JMiscF);
  ExLocal.LGetRecAddr(JMiscF);

  SetCaption;

  OutEmpl;

  DDCtrl:=JDDFormMode;

  DelCP1Btn.Enabled:=SetDelBtn;

  // SSK 05/03/2018 ABSEXCH-19843: Disable the status button for all the tabs for anonymised trader
  if GDPROn then
    btnStatus.Enabled := not (ExLocal.LJobMisc^.EmplRec.emAnonymisationStatus = asAnonymised);

  BuildDesign;

  Case Current_Page of

    1  :  {$IFDEF NP}
            If (NotesCtrl<>nil) then {* Assume record has changed *}
            With ExLocal do
            Begin
              NotesCtrl.RefreshList(LJobMisc^.EmplRec.EmpCode,NotesCtrl.GetNType);
              NotesCtrl.GetLineNo:=LJobMisc^.EmplRec.NLineCount;
            end;

          {$ELSE}

            ;
          {$ENDIF}

    2..4
       :  RefreshList(BOn,BOff);


  end; {Case..}

  If (HistFormPtr<>nil) then
    Display_History(LastHMode,BOff);


  {$IFDEF Ltr}
  If Assigned(LetterForm) And LetterActive Then
    If (LetterForm.WindowState <> wsMinimized) Then
      With LetterForm, ExLocal, LJobMisc^ Do Begin
        { Get Job's Customer }
        LoadLettersFor (EmplRec.EmpCode,
                        EmplRec.EmpCode,
                        Trim(EmplRec.EmpCode),
                        LetterEmplCode,
                        Nil, Nil, Nil, Nil, LJobMisc);
      End; { With }
  {$ENDIF}

  SetAnonymisationStatusDate;
end;


procedure TJEmpRec.SetFieldProperties;

Var
  n  : Integer;


Begin
  {SBSPanel4.Color:=SBSPanel1.Color;}

  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) and (Components[n]<>EMAccF) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(EMAccF.Font);
        Color:=EMAccF.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        {CheckColor:=EMAccF.Color;}
        Color:=TCMScrollBox.Color;
      end;

  end; {Loop..}

  {With YTDCombo do
  Begin
    Font.Assign(SRCF.Font);
    Color:=SRCF.Color;
  end;}


end;



procedure TJEmpRec.SetFormProperties;

Const
  PropTit     :  Array[0..1] of Str10 = ('Record','List');

Var
  TmpPanel    :  Array[1..3] of TPanel;

  ListChange,
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

  ListChange:=0;

  ListChange:=ListChange+(1*Ord(Current_Page In [LedgerPage..StatPage]));

  try

    Case ListChange of
      0  :  Begin
              TmpPanel[1].Font:=EMAccF.Font;
              TmpPanel[1].Color:=EMaccF.Color;

              TmpPanel[2].Font:=PageControl1.Font;
              TmpPanel[2].Color:=TCMScrollBox.Color;
            end;

      1  :  Begin
              With MULCtrlO[Current_Page].VisiList do
              Begin
                VisiRec:=List[0];

                TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
                TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

                TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
                TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


                TmpPanel[3].Color:=MULCtrlO[Current_Page].ColAppear^[0].HBKColor;
              end;

              TmpPanel[3].Font.Assign(TmpPanel[1].Font);

              TmpPanel[3].Font.Color:=MULCtrlO[Current_Page].ColAppear^[0].HTextColor;
            end;



    end; {Case..}



    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],Ord(ListChange<>0),
                      'Employee '+PropTit[ListChange]+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin
          Case ListChange of
            0  :  Begin
                    PageControl1.Font.Assign(TmpPanel[2].Font);
                    TCMScrollBox.Color:=TmpPanel[2].Color;

                    EMAccF.Font.Assign(TmpPanel[1].Font);
                    EMAccF.Color:=TmpPanel[1].Color;

                    SetFieldProperties;
                  end;
            1  :  Begin
                    For n:=1 to 3 do
                      With TmpPanel[n] do
                        Case n of
                          1,2  :  MULCtrlO[Current_Page].ReColorCol(Font,Color,(n=2));

                          3    :  MULCtrlO[Current_Page].ReColorBar(Font,Color);
                        end; {Case..}

                    MULCtrlO[Current_Page].VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
                  end;


          end; {case..}

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



procedure TJEmpRec.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  With InvBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

    {* Set all equivalent enables *}

    Delete1.Enabled:=DelCP1Btn.Enabled;
  end; {With..}

end;


procedure TJEmpRec.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;

procedure TJEmpRec.PropFlgClick(Sender: TObject);
begin
  {$IFDEF NP}
    If (Current_Page=1) then
      NotesCtrl.SetFormProperties
    else
  {$ENDIF}
      SetFormProperties;
end;

procedure TJEmpRec.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;

procedure TJEmpRec.DelCP1BtnClick(Sender: TObject);
begin
  Case Current_Page of
    NotesPage
       :  DelCp3BtnClick(Sender);
    RatePage
       :  If (Assigned(MULCtrlO[Current_Page])) and (MULCtrlO[Current_Page].ValidLine) then
          Begin

            If (Not Ent_BeenUsed(3,JobCtrl^.EmplPay.EStockCode)) then
              EditRetRec(Sender,(Current_Page=4))
            else
              ShowMessage('This record is in use elsewhere in the system, it cannot be deleted.');
          end;
    ContPage,
    AppPage
       :  DeleteDoc;

    else  DeleteAccount;
  end; {case..}

end;

procedure TJEmpRec.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);

Var
  NewIndex  :  Integer;

begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    // MH 30/06/2009 (20081021100021): Added this statement to change the focus because
    // if the focus was on the Supplier A/C field when tabs were changed the contents of
    // the Employee Type field were lost when you returned to the main tab.  NOTE: This
    // only happened when the page handles were released.
    If (Current_Page = 0) And (ActiveControl = SupAcF) And EmACCF.CanFocus Then
      EmACCF.SetFocus;

    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);

    NewIndex:=Current_Page;

    If (NewIndex In [RatePage..AppPage]) and (Assigned(MULCtrlO[NewIndex])) then
      MulCtrlO[NewIndex].HideCols(BOn);
  end;
end;





procedure TJEmpRec.PageControl1Change(Sender: TObject);

Var
  n         :  Byte;
  NewIndex  :  Integer;

  {$IFDEF NP}
    NoteSetUp :  TNotePadSetUp;
  {$ENDIF}

  ChkStr    :  Str255;

begin

  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);
      {$B-}

      If (Not (NewIndex In [LedgerPage..StatPage])) or (MULCtrlO[NewIndex]<>nil)  then
        LockWindowUpDate(0);

      {$B+}

      PrimeButtons;

      If (NewIndex In [LedgerPage..StatPage]) then
      Begin
        CListBtnPanel.Parent:=ActivePage;

        If (NewIndex In [RatePage,AppPage,ContPage]) then
          HidePanels(NewIndex);
      end;


      Case NewIndex of

      {$IFDEF NP}

        NotesPage
           :  If (NotesCtrl=nil) then
              With ExLocal do
              Begin
                NotesCtrl:=TNoteCtrl.Create(Self);

                NotesCtrl.Caption:='Employee Record '+Caption;

                FillChar(NoteSetup,Sizeof(NoteSetUp),0);

                With NoteSetUp do
                Begin
                  ColPanels[0]:=NDatePanel; ColPanels[1]:=NDateLab;
                  ColPanels[2]:=NDescPanel; ColPanels[3]:=NDescLab;
                  ColPanels[4]:=NUserPanel; ColPanels[5]:=NUserLab;

                  ColPanels[6]:=TNHedPanel;
                  ColPanels[7]:=TCNListBtnPanel;

                  ScrollBox:=TCNScrollBox;
                  PropPopUp:=StoreCoordFlg;

                  CoorPrime:='E';
                  CoorHasCoor:=LastCoord;

                end;

                try
                  NotesCtrl.CreateList(Self,NoteSetUp,NoteECode,NoteCDCode,FullNCode(LJobMisc^.EmplRec.EmpCode));
                  NotesCtrl.GetLineNo:=LJobMisc^.EmplRec.NLineCount;

                except
                  NotesCtrl.Free;
                  NotesCtrl:=Nil
                end;

                MDI_UpdateParentStat;

              end
              else
              With ExLocal do
                If (LJobMisc^.EmplRec.EmpCode<>NotesCtrl.GetFolio) then {* Refresh notes *}
                with NotesCtrl do
                Begin
                  RefreshList(FullNCode(LJobMisc^.EmplRec.EmpCode),GetNType);
                  GetLineNo:=LJobMisc^.EmplRec.NLineCount;
                end;

      {$ELSE}

         NotesPage  :  ;

      {$ENDIF}

        LedgerPage..StatPage
           : Begin


               If (MULCtrlO[NewIndex]=nil) then
               Begin
                 Case NewIndex of
                   LedgerPage  :  LedgerBuildList(NewIndex,BOn);

                   RatePage    :  RetenBuildList(NewIndex,BOn);

                   AppPage,
                   ContPage    :  AppsBuildList(NewIndex,BOn);

                 end; {Case..}

               end
               else
                 With EXLocal do
                 Begin

                   ChkStr:=MULCtrlO[NewIndex].SetCheckKey;

                   If (Not CheckKey(ChkStr,MULCtrlO[NewIndex].KeyRef,Length(ChkStr),BOn)) or (NewIndex In [RatePage..ContPage]) then
                     RefreshList(BOn,BOff);

                   MULCtrlO[NewIndex].ReFresh_Buttons;
                 end;


             If MULCtrlO[NewIndex].CanFocus then
               MULCtrlO[NewIndex].SetListFocus;

             MulCtrlO[NewIndex].ReAssignCols;
           end;


      end; {Case..}

      LockWindowUpDate(0);

      // SSK 22/05/2018 2018-R1.1 ABSEXCH-20309: handle the availability of the export funtionality on page change
      WindowExport.ReevaluateExportStatus;
    end;
end;


procedure TJEmpRec.AddCP3BtnClick(Sender: TObject);
begin
  {$IFDEF NP}
    If (NotesCtrl<>nil) then
      NotesCtrl.AddEditNote((Sender=EditCP1Btn),(Sender=InsCP1Btn));
  {$ENDIF}
end;


procedure TJEmpRec.DelCP3BtnClick(Sender: TObject);
begin
  {$IFDEF NP}
    If (NotesCtrl<>nil) then
      NotesCtrl.Delete1Click(Sender);
  {$ENDIF}
end;

procedure TJEmpRec.GenCP3BtnClick(Sender: TObject);
begin

  Case Current_Page of

    NotesPage
        :  {$IFDEF NP}
            If (NotesCtrl<>nil) then
            With NotesCtrl do
            Begin

              If (Not MULCtrlO.InListFind) then
                SwitchGenMode;

            end;
          {$ELSE}

            ;
          {$ENDIF}

  end; {Case..}


end;


procedure TJEmpRec.LedgerBuildList(PageNo     :  Byte;
                                    ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO[PageNo]:=TJELMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO[PageNo] do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(CLORefPanel,CLORefLab);
          AddVisiRec(CLDatePanel,CLDateLab);
          AddVisiRec(CLACPanel,CLACLab);
          AddVisiRec(CLQOPanel,CLQOLab);
          AddVisiRec(CLALPanel,CLALLab);
          AddVisiRec(CLOOPanel,CLOOLab);
          AddVisiRec(CLYRefPanel,CLYrefLab);
          AddVisiRec(CLDuePanel,CLDueLab);

          // SSK 22/05/2018 2018-R1.1 ABSEXCH-20309: Added metadata info for Ledger tab
          ColAppear^[3].ExportMetadata := emtQuantity;        // Hours
          ColAppear^[4].ExportMetadata := emtCurrencyAmount;  // U/Cost
          ColAppear^[5].ExportMetadata := emtCurrencyAmount;  // Total


          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel:=CLHedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;



      Find_LedgCoord(PageNo);

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=7;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [3..5]) then
        Begin
          DispFormat:=SGFloat;

          Case n of
            3  :  NoDecPlaces:=Syss.NoQtyDec;
            4  :  NoDecPlaces:=Syss.NoCosDec;
            5  :  NoDecPlaces:=2;
          end; {Case..}
        end;
      end;

      DisplayMode:=31;

      ListLocal:=@ExLocal;

      ListCreate;

      {UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;}

      HighLiteStyle[1]:=[fsBold];

      Set_Buttons(CListBtnPanel);

      ReFreshList(Not FromHist,BOff);

    end; {With}

    DefaultPageReSize;

  Except

    MULCtrlO[PageNo].Free;
    MULCtrlO[PageNo]:=Nil;
  end;


end;



procedure TJEmpRec.RetenBuildList(PageNo     :  Byte;
                                 ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO[3]:=TJELMList.Create(Self);
  StartPanel := nil;


  Try

    With MULCtrlO[PageNo] do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(RTPanel,RTLab);
          AddVisiRec(DEPanel,DELab);
          AddVisiRec(ANPanel,ANLab);
          AddVisiRec(TCPanel,TCLab);
          AddVisiRec(THPanel,THLab);
          AddVisiRec(PNPanel,PNLab);


          // SSK 22/05/2018 2018-R1.1 ABSEXCH-20308: this will work for both Global Time Rate and Employee Time Rate
          ColAppear^[3].ExportMetadata := emtCurrencyAmount;     // Time Cost
          ColAppear^[4].ExportMetadata := emtCurrencyAmount;     // Time Charge
          ColAppear^[5].ExportMetadata := emtAlignRight;         // Pay Code

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel:=RTHedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;



      Find_LedgCoord(PageNo);

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=5;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [3,4]) then
        Begin
          DispFormat:=SGFloat;

          Case n of
            3  :  NoDecPlaces:=Syss.NoCosDec;
            4  :  NoDecPlaces:=2;
          end; {Case..}
        end;
      end;

      DisplayMode:=1;

      ListLocal:=@ExLocal;


      ListCreate;

      {UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;}

      HighLiteStyle[1]:=[fsBold];

      Set_Buttons(CListBtnPanel);

      ReFreshList(Not FromHist,BOff);

    end; {With}

    DefaultPageReSize;

  Except

    MULCtrlO[PageNo].Free;
    MULCtrlO[PageNo]:=Nil;
  end;


end;


procedure TJEmpRec.AppsBuildList(PageNo     :  Byte;
                                 ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO[PageNo]:=TJELMList.Create(Self);
  StartPanel := nil;


  Try

    With MULCtrlO[PageNo] do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(RTPanel,RTLab);
          AddVisiRec(DEPanel,DELab);
          AddVisiRec(ANPanel,ANLab);
          AddVisiRec(TCPanel,TCLab);
          AddVisiRec(THPanel,THLab);
          AddVisiRec(PNPanel,PNLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel:=RTHedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;



      Find_LedgCoord(PageNo);

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=5;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [3,4]) then
        Begin
          DispFormat:=SGFloat;

          NoDecPlaces:=2;
        end;
      end;

      DisplayMode:=33+Ord(PageNo=ContPage);

      ListLocal:=@ExLocal;


      ListCreate;

      {UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;}

      HighLiteStyle[1]:=[fsBold];

      Set_Buttons(CListBtnPanel);

      ReFreshList(Not FromHist,BOff);

    end; {With}

    DefaultPageReSize;

  Except

    MULCtrlO[PageNo].Free;
    MULCtrlO[PageNo]:=Nil;
  end;


end;



procedure TJEmpRec.RefreshList(ShowLines,
                                IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  Fnum,
  LKeyLen,
  KPath,
  CPage       :  Integer;

Begin
  CPage:=Current_Page;
  FNum := InvF;
  KPath := 0;
  {$B-}
  If (CPage In [LedgerPage..StatPage]) and (Assigned(MULCtrlO[CPage])) then
  With MULCtrlO[CPage],ExLocal,LJobRec^ do
  {$B+}
  Begin
    LNHCtrl:=DDCtrl;


    With ExLocal,LJobMisc^,EmplRec,LNHCtrl do
    Begin

      Case CPage of

        LedgerPage
           :  Begin
                Fnum:=JDetlF;
                KPath:=JDEmpK;

                KeyStart:=PartCCKey(JBRCode,JBECode)+FullEmpKey(EmpCode);


                If (NHNeedGExt) then
                Begin
                  DisplayMode:=32;

                  If (StkExtObjPtr=nil) then
                  Begin
                    ExtObjCreate;

                  end;

                  Case DDMode of
                    32     :  With StkExtRecPtr^ do
                              Begin
                                FDesc:=FullEmpKey(EmpCode);

                                FMode:=DDMode;

                                FPr:=NHPr;
                                FYr:=NHYr;
                              end;

                  end; {Case..}


                end
                else
                Begin
                  If (StkExtObjPtr<>nil) then
                    ExtObjDestroy; {* Remove previous link *}

                  DisplayMode:=31;
                end;
            end;

        RatePage
           :  Begin
                Fnum:=JCtrlF;
                KPath:=JCK;

                Case GlobPRate of
                  1  :  KeyStart:=PartCCKey(JBRCode,JBSubAry[3])+FullNomKey(PRateCode);
                  2  :  KeyStart:=PartCCKey(JBRCode,JBSubAry[3])+FullJobCode(RateJCode);
                  else  KeyStart:=PartCCKey(JBRCode,JBSubAry[4])+FullEmpKey(EmpCode);
                end; {Case..}

              end;

        AppPage,
        ContPage
           :  Begin
                Fnum:=InvF;
                KPath:=InvBatchK;

                KeyStart:=Strip('R',[#0],FullJAPEmplKey(BOff,EmpCode,(CPage=ContPage)));

              end;

      end; {Case..}
    end;

    LKeyLen:=Length(KeyStart);

    IgnoreMsg:=IgMsg;

    StartList(Fnum,KPath,KeyStart,'','',LKeyLen,(Not ShowLines));


    IgnoreMsg:=BOff;
  end;

end;



procedure TJEmpRec.CLORefPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;



begin

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    BarPos:=Current_BarPos(Current_Page);

    If (PanRsized) then
      MULCtrlO[Current_Page].ResizeAllCols(MULCtrlO[Current_Page].VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO[Current_Page].VisiList.MovingLab or PanRSized);
  end;

end;




procedure TJEmpRec.CLORefLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      If (MULCtrlO[Current_Page]<>nil) then
        MULCtrlO[Current_Page].VisiList.PrimeMove(Sender);
      NeedCUpdate:=BOn;
    end
    else
      If (Button=mbRight) then
      Begin
        ListPoint:=ClientToScreen(Point(X,Y));

        ShowRightMeny(ListPoint.X,ListPoint.Y,0);
      end;

  end;
end;


procedure TJEmpRec.CLORefLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO[Current_Page]<>nil) then
    Begin
      MULCtrlO[Current_Page].VisiList.MoveLabel(X,Y);

      NeedCUpdate:=MULCtrlO[Current_Page].VisiList.MovingLab;
    end;
  end;

end;

{ ======= Link to Trans display ======== }

procedure TJEmpRec.Display_Trans(Mode  :  Byte);

Var
  DispTrans  :  TFInvDisplay;
  DT         :  DocTypes;
  DisplayOptions : TransactionDisplayOptionsSet;

Begin
  {$IFDEF JAP}
    If (Mode=1) then
    With ExLocal,LJobMisc^.EmplRec do
    Begin
      If (Current_Page In [AppPage]) then
        DT:=JPA
      else
        DT:=JCT;

      Set_JPAJCT(Inv,Id,DT,EmpCode,'',0,0);

      with TJobAppWizard.Create(Self) do
        Show;
    end
  else
  {$ENDIF}
  Begin
    If (DispTransPtr=nil) then
    Begin
      DispTrans:=TFInvDisplay.Create(Self);
      DispTransPtr:=DispTrans;
    end
    else
      DispTrans:=DispTransPtr;

      try

        With ExLocal,DispTrans do
        Begin
          If (Current_Page In [LedgerPage,AppPage,ContPage]) then
            With MULCtrlO[Current_Page] do
            Begin
              If (Current_Page=LedgerPage) then
                Link2Inv;

              AssignFromGlobal(InvF);

              if RestrictedEditOnly(Inv) then
                DisplayOptions := [GDPR_AllowPostedEdit]
              else
                DisplayOptions := [];
            end;

          LastDocHed:=LInv.InvDocHed;

          If ((LastFolio<>LInv.FolioNum) or (Mode<>100)) and (InHBeen) then
            Display_Trans(Mode,Inv.FolioNum,BOn,(Mode<>100), DisplayOptions);

        end; {with..}

      except

        DispTrans.Free;

      end;
  end; {Proc..}
end;



procedure TJEmpRec.ViewCP1BtnClick(Sender: TObject);
Var
  Modus       :  Byte;

  ListPoint   :  TPoint;

begin
  Case Current_Page of
    LedgerPage,AppPage,ContPage
         :  With MULCtrlO[Current_Page] do
            If (ValidLine) then
            Begin
              RefreshLine(MUListBoxes[0].Row,BOff);

              InHBeen:=BOn;

              Modus:=2;

              Display_Trans(Modus);

            end;

    RatePage

         :  Begin
            end;

  end; {Case..}

end;




procedure TJEmpRec.FindCP1BtnClick(Sender: TObject);

Var
  ListPoint   :  TPoint;
  ReturnCtrl  :  TReturnCtrlRec;


begin
  Case Current_Page of

   {$IFDEF GF}
    LedgerPage,AppPage,ContPage
       :  With ReturnCtrl,MessageReturn do
          Begin
            FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

            WParam:=3000;
            Msg:=WM_CustGetRec;
            DisplayxParent:=BOn;
            ShowOnly:=BOn;

            Pass2Parent:=BOn;

            LParam:=Current_Page;

            Ctrl_GlobalFind(Self,ReturnCtrl,2);

          end; {With..}
    {$ELSE}
      0  :  ;

   {$ENDIF}



  end; {Case..}
end;






procedure TJEmpRec.PrnCP1BtnClick(Sender: TObject);

begin
  {$IFDEF FRM}
    With ExLocal do
    Case Current_Page of

      LedgerPage,AppPage,ContPage
           :  With MulCtrlO[Current_Page] do
              If ValidLine then
              Begin
                GetSelRec(BOff);


                AssignFromGlobal(InvF);

                With LInv do
                  Control_DefProcess(DEFDEFMode[InvDocHed],
                                     IdetailF,IdFolioK,
                                     FullNomKey(FolioNum),ExLocal,BOn);
              end;


    end; {Case..}

  {$ENDIF}
end;





procedure TJEmpRec.LnkCp1BtnClick(Sender: TObject);
begin
  {$IFDEF Ltr}
    { Create form if not already created }
    If Not Assigned (LetterForm) Then Begin
      { Create letters form }
      LetterForm := TLettersList.Create (Self);
    End; { If }

    Try
      { mark form as active }
      LetterActive := BOn;

      { Display form }
      LetterForm.WindowState := wsNormal;
      LetterForm.Show;

      With ExLocal, LJobMisc^ Do Begin
        { Get Job's Customer }
        LetterForm.LoadLettersFor (EmplRec.EmpCode,
                                   EmplRec.EmpCode,
                                   Trim(EmplRec.EmpCode),
                                   LetterEmplCode,
                                   Nil, Nil, Nil, Nil, LJobMisc);
      End; { With }
    Except
     LetterActive := BOff;
     LetterForm.Free;
    End;
  {$ENDIF}
end;


{ =============== Procedure to Find Next Availabel Code ============ }

Function TJEmpRec.Auto_GetECode(CCode    :  Str20;
                                Fnum,
                                Keypath  :  Integer)  :  Str20;



Var
  KeyS  :  Str255;

  UseNumber
        :  Boolean;

  TmpStat
        :  Integer;

  TmpRecAddr
        :  LongInt;
  TmpJobM
        :  JobMiscRec;

  NewNo :  Str10;

  LCode :  Str20;

  PadLen,
  LLen  :  Byte;
  n     :  Word;



Begin


  TmpJobM:=JobMisc^;

  TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOff,BOff);

  LCode:=Trim(CCode);

  LLen:=Length(LCode);

  n:=IntStr(Copy(LCode,LLen-1,2));

  UseNumber:=(n<>0);

  Repeat

    KeyS:=PartCCKey(JARCode,JASubAry[3])+FullEmpKey(CCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    If (StatusOk) then
    Begin

      Inc(n);

      NewNo:=Form_Int(n,0);

      PadLen:=2+Ord(n>99);


      If (LLen<=(EmplKeyLen-PadLen)) then
        CCode:=Copy(LCode,1,LLen-(2*Ord(UseNumber)))+SetPadNo(NewNo,PadLen)
      else
        CCode:=Copy(CCode,1,EmplKeyLen-PadLen)+SetPadNo(NewNo,PadLen);

    end;

  Until (Not StatusOk) or (n=999);

  TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOn,BOff);

  JobMisc^:=TmpJobM;

  Auto_GetECode:=FullEmpKey(CCode);

end; {Func..}


procedure TJEmpRec.ViewR1Click(Sender: TObject);
Var
  KeyI  :  Str255;

begin
  With MULCtrlO[Current_Page] do
  If (ValidLine) then
  With JobDetl^.JobReten do
  Begin

    If (TMenuItem(Sender).Tag=1) then
      KeyI:=RetDoc
    else
      KeyI:=RetCrDoc;

    InHBeen:=CheckRecExsists(KeyI,InvF,InvOurRefK);

    If (InHBeen) then
      ExLocal.LInv:=Inv;

    Display_Trans(2);

  end;
end;


{ ======= Retention based control ======= }

procedure TJEmpRec.Display_RetRec(Mode     :  Byte;
                                 IsSales  :  Boolean);

Var
  WasNew  :  Boolean;
  EPRRec  :  TJCEmpP1;


  Begin
    WasNew:=BOff;

    With ExLocal do
    Begin

    end;


    If (RetRecPtr=nil) then
    Begin
      EPRRec:=TJCEmpP1.Create(Self);

      WasNew:=BOn;

      RetRecPtr:=EPRRec;
    end
    else
      EPRRec:=RetRecPtr;

    Try


     With EPRRec do
     Begin
       EmplPrMode:=(GlobPRate=0);
       JobPrMode:=(GlobPRate=2);

       Case GlobPRate of
         1  :  PREmplCode:=FullNomKey(PRateCode);
         2  :  PREmplCode:=FullJobCode(RateJCode);
         else  PREmplCode:=FullEmpKey(Self.ExLocal.LJobMisc^.EmplRec.EmpCode);
       end; {Case..}


       If (Mode=1) then
         ResetRec(JCtrlF);

       ExLocal.AssignFromGlobal(JCtrlF);
       ExLocal.LJobMisc^:=Self.ExLocal.LJobMisc^;
       ExLocal.LJobRec^:=Self.ExLocal.LJobRec^;

       If (Mode=2) then
       Begin
         CSStkCode.ReadOnly:=BOff; {Ent_BeenUsed(3,JobCtrl^.EmplPay.EStockCode);}
       end;

       WindowState:=wsNormal;


       Case Mode of
         1,2  :  Begin
                   If (Mode=2) then
                   Begin
                     If PrDF.CanFocus then
                       PrDF.SetFocus;
                   end
                   else
                     If (CSStkCode.CanFocus) then
                       CSStkCode.SetFocus;

                   {FieldNextFix(Handle,ActiveControl,CompF); {* Added so that qty is auto selected *}
                 end;
       end;

       If (Mode In [1..3]) then
       Begin

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine((Mode=2))
                     else
                       Show;
              3  :  If (Not ExLocal.InAddEdit) then
                       DeleteBOMLine(JCtrlF,JCK);
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except

     EPRRec.Free;
     RetRecPtr:=nil;

    end;

  end;


procedure TJEmpRec.EditRetRec(Sender  : TObject;
                             IsSales : Boolean);

Var
  EMode  :  Byte;

Begin
  EMode:=1*Ord((Sender = AddCP1Btn) or (Sender = Add1)) +
         2*Ord((Sender = EditCP1Btn) or (Sender = Edit1))+
         3*Ord((Sender = DelCP1Btn) or (Sender = Delete1));

  {$B-}
  If (EMode=1) or (MULCtrlO[3+Ord(IsSales)].ValidLine) then
  {$B+}
    Display_RetRec(EMode, IsSales);
end;


procedure TJEmpRec.EmACCFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str20;


begin

  If (Sender is TMaskEdit) and (ActiveControl<>CanCP1Btn) then
  With (Sender as TMaskEdit),ExLocal do
  Begin
    {$IFDEF XCUX} {*For future use with a hook }
      If (Not ReadOnly) then
        Text:=TextExitHook(3000,1,Trim(Text),ExLocal);
    {$ENDIF}


    CCode:=UpCaseStr(FullEmpKey(Text));

    If ((Not LastEdit) or (LastJobMisc^.EmplRec.EmpCode<>CCode)) and (InAddEdit) then
    Begin
      COk:=(Not Check4DupliGen(PartCCKey(JARCode,JASubAry[3])+CCode,JMiscF,JMK,'Record ('+Strip('B',[#32],CCode)+')'));

      If (Not COk) then
      Begin

        Text:=Auto_GetECode(CCode,JMiscF,JMK);

        ChangePage(0);

        EMAccF.SetFocus;

        StopPageChange:=BOn;


      end
      else
        StopPageChange:=BOff;


    end;
  end;
end;



procedure TJEmpRec.SupAcFEnter(Sender: TObject);
begin
  If (Sender is TMaskEdit) then
  With (Sender as TMaskEdit) do
  Begin
    If (ExLocal.InAddEdit) then
    Begin
      ReadOnly:=EmTypF.ItemIndex<>1;

      If (Sender=SupAcF) and (Not ReadOnly) then
        Text:=LinkCF.Text;
    end;
  end {With..}
end;



procedure TJEmpRec.SupAcFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Text;

    Form2Empl;

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (ActiveControl<>CanCP1Btn) and (Not ReadOnly) then
    Begin

      If (((AltMod) and (Text<>LinkCF.Text)) or (FoundCode=''))  then

      Begin

        StillEdit:=BOn;

        FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOff,0));


        If (FoundOk) then
        With ExLocal, LJobMisc^.EmplRec do
        Begin

          StillEdit:=BOff;


          ExLocal.AssignFromGlobal(CustF);

          Supplier:=FoundCode;

          Begin
            If (Addr[1]='') or (Not LastEdit) then
              Addr:=LCust.Addr;

            If (Phone='') or (Not LastEdit)  then
              Phone:=LCust.Phone;

            If (Fax='') or (Not LastEdit)  then
              Fax:=LCust.Fax;

            If (Phone2='') or (Not LastEdit)  then
              Phone2:=LCust.Phone2;
          end;

          OutEmpl;


          SendToObjectCC(FoundCode,0);
        end
        else
        Begin

          SetFocus;
        end; {If not found..}
      end
      else
        OutEmpl;
    end;

  end; {with..}
end;





procedure TJEmpRec.ECCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>ClsCP1Btn) and (Syss.UseCCDep)  then
    Begin

      StillEdit:=BOn;
      //TG-29-05-2017- ABSEXCH-18684- Inactive CC/Dep gets display in 'Cost Centre/Department Search List'.
      FoundOk:=(GetCCDep(Self,FoundCode,FoundCode,IsCC,2));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;


      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end
    else
      If (AltMod) and (FoundCode='') then
        Text:='';

  end; {with..}
end;


procedure TJEmpRec.SupAcFDblClick(Sender: TObject);
begin
  LinkCF.DblClick;
end;

procedure TJEmpRec.EmTypFChange(Sender: TObject);
begin
  If (Not EmTypF.ReadOnly) then
  Begin
    If (EmTypF.ItemIndex<>1) then
    Begin
      LinkCF.Text:='';
      SupAcF.Text:='';
      GrpChkF.Checked:=BOff;
      ECertF.Text:='';
    end;
    // SSK 09/02/2017 2017-R1 ABSEXCH-18148: Changed to make 'set Labour Costs via PL' option ticked by default when 'Sub Contractor' Employee Type is selected
    if (Sender = EmTypF) then    // SSK 22/02/2017 2017-R1 ABSEXCH-18148: this extra check is added, as this functions is also called from change event of CBCertType/CBSubType
      LabChkF.Checked := (EmTypF.ItemIndex=1);

    SetFieldRW;
  end;
end;


procedure TJEmpRec.LabChkFClick(Sender: TObject);
begin
  EChkF.Visible:=Not LabChkF.Checked;

  Label813.Visible:=EChkF.Visible;

  GenSBF.Visible:=Not LabChkF.Checked;

  If (Not EChkF.Visible) then
    EChkF.ItemIndex:=0;

  If (Not GenSBF.Visible) then
    GenSBF.Checked:=BOff;
end;

procedure TJEmpRec.GrpChkFMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

Const
  Fnum     =  JMiscF;
  Keypath  =  JMTrdK;

Var
  FoundOk    : Boolean;
  Keypath2,
  TmpStat    : Integer;
  TmpRecAddr : LongInt;

  KeyChk,
  KeyS       : Str255;

  LocalEmpl  : EmplType;

Begin
  FoundOk:=BOff;


  If (GrpChkF.Checked) and (ExLocal.InAddEdit) then
  Begin
    LocalEmpl:=ExLocal.LJobMisc^.EmplRec;

    KeyPath2:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,Keypath2,F[Fnum],TmpRecAddr,BOff,BOff);

    KeyChk:=FullJBKey(JARCode,JASubAry[3],FullCustCode(LinkCF.Text));
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not FoundOk) do
    With JobMisc^,EmplRec do
    Begin
      Application.ProcessMessages;

      If (GroupCert) and (EmpCode<>FullCustCode(EMACCF.Text)) then
      Begin
        ECertF.Text:=CertNo;
        EEXpF.DateValue:=CertExpiry;
        FoundOk:=BOn;
      end;


      If (Not FoundOk) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

    end;
    TmpStat:=Presrv_BTPos(Fnum,Keypath2,F[Fnum],TmpRecAddr,BOn,BOn);

    ExLocal.LJobMisc^.EmplRec:=LocalEmpl;

  end;
end;



procedure TJEmpRec.EUD1FEntHookEvent(Sender: TObject);
Var
  CUUDEvent  :  Byte;
  Result     :  LongInt;

begin
   CUUDEvent := 0;
  {$IFDEF CU}
    If (Sender is Text8Pt)then
      With (Sender as Text8pt) do
      Begin
        If (Not ReadOnly) then
        Begin
          If (Sender=EUD1F) then
          Begin
            ExLocal.LJobRec^.UserDef1:=Text;
            CUUDEvent:=1;
          end
          else
            If (Sender=EUD2F) then
            Begin
              ExLocal.LJobRec^.UserDef2:=Text;
              CUUDEvent:=2;
            end
            else
              If (Sender=EUD3F) then
              Begin
                ExLocal.LJobRec^.UserDef3:=Text;
                CUUDEvent:=3;
              end
              else
                If (Sender=EUD4F) then
                Begin
                  ExLocal.LJobRec^.UserDef4:=Text;
                  CUUDEvent:=4;
                end;

          Result:=IntExitHook(5000,40+CUUDEvent,-1,ExLocal);

          If (Result=0) then
            SetFocus
          else
          With ExLocal do
          If (Result=1) then
          Begin
            Case CUUDEvent of
              1  :  Text:=LJobMisc^.EmplRec.UserDef1;
              2  :  Text:=LJobMisc^.EmplRec.UserDef2;
              3  :  Text:=LJobMisc^.EmplRec.UserDef3;
              4  :  Text:=LJobMisc^.EmplRec.UserDef4;
            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;


procedure TJEmpRec.EUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>CanCP1Btn) and (ActiveControl<>ClsCP1Btn) then
    Text8pt(Sender).ExecuteHookMsg;

end;


procedure TJEmpRec.Display_History(HistMode     :  Byte;
                                   ChangeFocus  :  Boolean);


{$IFDEF NOM}

  Var
    NomNHCtrl  :  TNHCtrlRec;

    FoundLong  :  Longint;

    fPr,fYr    :  Byte;

    HistForm   :  THistWin;

    WasNew     :  Boolean;

  Begin
    LastHMode:=HistMode;

    WasNew:=BOff;

    With NomNHCtrl do
    Begin
      FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

      NHMode:=29;
      NBMode:=11;

      NHCr:=0;
      NHTxCr:=0;
      NHPr:=1;
      NHYr:=GetLocalPr(0).CYr;

      NHCCode:=FullNCode(ExLocal.LJobMisc^.EmplRec.EmpCode);

      NHKeyLen:=NHCodeLen+2;

      Begin
        Find_FirstHist(EmpHistCode,NomNHCtrl,fPr,fYr);
        MainK:=FullNHistKey(EmpHistCode,NHCCode,NHCr,fYr,fPr);
        AltMainK:=FullNHistKey(EmpHistCode,NHCCode,NHCr,0,0);
      end;

      Set_NHFormMode(NomNHCtrl);

      ExLocal.AssignToGlobal(JMiscF);

    end;

    If (HistFormPtr=nil) then
    Begin
      WasNew:=BOn;

      HistForm:=THistWin.Create(Self);

      HistFormPtr:=HistForm;

    end
    else
      HistForm:=HistFormPtr;

    Try

     With HistForm do
     Begin


       WindowState:=wsNormal;

       If (ChangeFocus) then
         Show;

       ShowLink(BOn,BOff);


     end; {With..}

     If (WasNew) then
     Begin

     end;

    except

     HistFormPtr:=nil;

     HistForm.Free;
     HistForm:=nil;

    end; {try..}

{$ELSE}
begin
{$ENDIF}

end;



procedure TJEmpRec.HistCP1BtnClick(Sender: TObject);
begin
  Display_History(0,BOn);
end;




procedure TJEmpRec.NteCP1BtnClick(Sender: TObject);
Var
  CRepParam  :  CVATRepParam;

begin
  Blank(CRepParam,Sizeof(CRepParam));

  {$B-}
  If (ExLocal.LJobMisc^.EmplRec.EType=2) then
  Begin
    If (Not InCISVch) then

  {$B+}
    With ExLocal, CRepParam do
    Begin
      InCISVch:=BOn;
      VATStartD:='19800101';
      VATEndD:=MaxUntilDate;
      VSig:=LJobMisc^.EmplRec.EmpCode;

      Show_CISList(Self,CRepParam);

    end;
  end
  else
    ShowMessage('This option is only available for Sub Contract employees');
end;




procedure TJEmpRec.btnStatusClick(Sender: TObject);
var
  lListPoint: TPoint;
begin
  with TWinControl(Sender) do
  begin
    lListPoint.X := 1;
    lListPoint.Y := 1;
    lListPoint := ClientToScreen(lListPoint);
  end;
  popmnuStatus.PopUp(lListPoint.X, lListPoint.Y);
end;

//RB 28/11/2017 2018-R1 ABSEXCH-19499: 6.3.2.4 (Before ABSEXCH-19393) - Add Status field to Employee and Button to change status for employee
procedure TJEmpRec.mnuItmEmpClosedClick(Sender: TObject);
var
  lKeyS : Str255;
  lStatus: SmallInt;
  lAnonDiaryDetail: IAnonymisationDiaryDetails;
  lRes: Integer;
begin
  lKeyS:='';
  with ExLocal do
  begin
    //RB 09/01/2018 ABSEXCH-19555: Trader Open/Close behaviour impact on Employee and Jobs.
    if (LJobMisc.EmplRec.EType = 2) and (TMenuItem(Sender).Tag = 0) then
    begin
      lKeyS := FullCustCode(LJobMIsc.EmplRec.Supplier);
      lStatus := Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, lKeyS);
      if (lStatus = 0) and (Cust.AccStatus = 3) then
      begin
        MessageDlg('You cannot ''Open'' Employee as associated Supplier is ''Closed!''', mtError, [mbOK], 0);
        Exit;
      end;
    end;
    
    lKeyS := PartCCKey(JARCode,JASubAry[3])+FullEmpKey(LJobMisc.EmplRec.EmpCode);
    lStatus := Find_Rec(B_GetEq+B_MultNWLock, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, lKeyS);      //B_GetEq+B_MultLock
    LGetRecAddr(JMiscF);
    lRes := -1;
    if (lStatus = 0) and (LJobMisc.EmplRec.emStatus <> TEmployeeStatus(TMenuItem(Sender).Tag)) then
    Begin
      //Update the status of employee
      LJobMisc.EmplRec.emStatus:=TEmployeeStatus(TMenuItem(Sender).Tag);

      //RB 22/12/2017 2018-R1 ABSEXCH-19559: GDPR (POST 19393) - 6.3.2 - Employee Open/Close behaviour - Anonymisation diary section
      if GDPROn then
      begin
        lAnonDiaryDetail := CreateSingleAnonObj;
        if Assigned(lAnonDiaryDetail) then
        begin
          //RB 30/11/2017 2018-R1 ABSEXCH-19393: GDPR (POST 19352) - 6.3.2 - Employee Open/Close behaviour - less anonymisation diary section
          case TMenuItem(Sender).Tag of
            0 : begin  {Open}
                  //Remove entry from AnonymisationDiary Table
                  lRes := lAnonDiaryDetail.RemoveEntity(adeEmployee, lJobMIsc.EmplRec.EmpCode);

                  //RB 26/12/2017 2018-R1 ABSEXCH-19586: User permission implementation related to Anonymisation Control Centre window
                  LJobMisc.EmplRec.emAnonymisationStatus := asNotRequested;
                  LJobMisc.EmplRec.emAnonymisedDate := EmptyStr;
                  LJobMisc.EmplRec.emAnonymisedTime := EmptyStr;
                  FListScanningOn := True;
                  AnonymisationON := False;
                end;
            1 : begin  {closed}
                  //Add Entry into AnonymisationDiary Table
                  lAnonDiaryDetail.adEntityType := adeEmployee;
                  lAnonDiaryDetail.adEntityCode := LJobMisc.EmplRec.EmpCode;
                  lRes := lAnonDiaryDetail.AddEntity;

                  if lRes = 0 then
                  begin
                    //RB 26/12/2017 2018-R1 ABSEXCH-19586: User permission implementation related to Anonymisation Control Centre window
                    LJobMisc.EmplRec.emAnonymisationStatus := asPending;
                    {SSK 13/02/2018 2018 R1 ABSEXCH-19749: condition checked for the employee, linked to a supplier;
                    considered the anonymised date of the supplier when supplier's anonymisation status is Pending}
                    if (LJobMisc.EmplRec.EType = 2) and (LCust.acAnonymisationStatus = asPending) then
                      LJobMisc.EmplRec.emAnonymisedDate := LCust.acAnonymisedDate
                    else
                      LJobMisc.EmplRec.emAnonymisedDate := lAnonDiaryDetail.adAnonymisationDate;
                    LJobMisc.EmplRec.emAnonymisedTime := TimeNowStr;
                    FListScanningOn := True;
                    AnonymisationON := True;
                  end;
                end;
          end;
        end;
      end;
      
      Status:=Put_Rec(F[JMiscF],JMiscF,LRecPtr[JMiscF]^,JMK);
      
      if (lRes = 0) and GDPROn then
      begin
        if (not StatusOk) and (LJobMisc.EmplRec.emStatus = emsClosed) then
          lAnonDiaryDetail.RemoveEntity(adeEmployee, lJobMIsc.EmplRec.EmpCode);
        SendMessage(Application.MainForm.Handle, WM_FormCloseMsg, 103, 0);
      end;

      Report_Berror(JMiscF, Status);

      Status:=UnLockMLock(JMiscF,LastRecAddr[JMiscF]);

      OutEmpl;
      PrimeButtons;

      //SSK 30/01/2018 2018-R1 ABSEXCH-19686: Show PII Tree, on Close status if "Display the PII Information Window..." option is ticked
      if (StatusOk) and (LJobMisc.EmplRec.emStatus = emsClosed) and SystemSetup.GDPR.GDPREmployeeDisplayPIITree and GDPROn then
      begin
        if ChkAllowed_In(uaAccessForEmployee) then
          btnPIITreeClick(mnuItmEmpClosed);
      end;
    end;
  end; {With..}
end;

//------------------------------------------------------------------------------
// HV 30/11/2017 ABSEXCH-19394: Implements anonymisation behaviour for Emp
procedure TJEmpRec.SetAnonymisationON(AValue: Boolean);
begin
  if GlobPRate = 1 then
    FAnonymisationON := False
  else
    FAnonymisationON := AValue;
  SetAnonymisationBanner;
end;

//------------------------------------------------------------------------------
// HV 30/11/2017 ABSEXCH-19394: Implements anonymisation behaviour for Emp
procedure TJEmpRec.SetAnonymisationBanner;
var
  lAnonymised: Boolean;
begin
  //HV 06/12/2017 ABSEXCH-19535: Anonymised Trader > The height of the window gets increased if "Save coordinates" is ticked
  if FAnonymisationON then
  begin
    PageP.Y:= 44;
    if (FListScanningOn and pnlAnonymisationStatus.Visible) or ((not LastCoord) and (not FListScanningOn)) then
      InitSize.Y := Self.ClientHeight
    else
      InitSize.Y := Self.ClientHeight + pnlAnonymisationStatus.Height;
  end
  else
  begin
    if (FListScanningOn and pnlAnonymisationStatus.Visible) or ((not LastCoord) and (not FListScanningOn)) then
      InitSize.Y := Self.ClientHeight - pnlAnonymisationStatus.Height
    else
      InitSize.Y := Self.ClientHeight;
    PageP.Y:= 1;
  end;
  if FListScanningOn then
  begin
    PageP.Y:= InitSize.Y - PageControl1.Height;
    FListScanningOn := False;
  end;

  pnlAnonymisationStatus.Visible := FAnonymisationON;
  if pnlAnonymisationStatus.Visible then
  begin
    //change the color of anonymisation controls
    with SystemSetup.GDPR do
    begin
      shpNotifyStatus.Brush.Color := NotificationWarningColour;
      shpNotifyStatus.Pen.Color := shpNotifyStatus.Brush.Color;
      lblAnonStatus.Font.Color := NotificationWarningFontColour;
    end;
    SetAnonymisationStatusDate;
  end;
  Self.ClientHeight := InitSize.Y;
  FormResize(nil);
end;

procedure TJEmpRec.SetAnonymisationStatusDate;
var
  lAnonymised: Boolean;
begin
  if GDPROn and FAnonymisationON then
  begin
    //update the anonymisation Date
    lAnonymised := ExLocal.LJobMisc.EmplRec.emAnonymisationStatus = asAnonymised;
    btnStatus.Enabled := not lAnonymised;      // disable the status button for
    if lAnonymised then //update the anonymisation Date
      lblAnonStatus.Caption := Format(capAnonymisedStatus, [POutDate(ExLocal.LJobMisc.EmplRec.emAnonymisedDate)])
    else
      lblAnonStatus.Caption := Format(capAnonymisedPendingStatus, [POutDate(ExLocal.LJobMisc.EmplRec.emAnonymisedDate)]);
    SetAnonymisationPanel;
  end;
end;


//------------------------------------------------------------------------------
//HV 12/11/2017 ABSEXCH-19549: Anonymised Notification banner in View/Edit Record > Banner not displayed on maximise and then Restore Down.
procedure TJEmpRec.SetAnonymisationPanel;
begin
  if  GDPROn and FAnonymisationON then
  begin
    pnlAnonymisationStatus.Left := 0;
    pnlAnonymisationStatus.Top := Self.ClientHeight - (pnlAnonymisationStatus.Height+1);
    pnlAnonymisationStatus.Width := Self.ClientWidth;
    shpNotifyStatus.Width := pnlAnonymisationStatus.Width - 10;
    shpNotifyStatus.Left := 5;
    //center the label
    lblAnonStatus.Left := Round((pnlAnonymisationStatus.Width - lblAnonStatus.width)/2);
  end;
end;

//------------------------------------------------------------------------------

procedure TJEmpRec.btnPIITreeClick(Sender: TObject);
begin
  with ExLocal.LJobMisc^.EmplRec do
    TfrmPIITree.CreateWithScanType(Application.MainForm, pstEmployee, dbFormatName(EmpCode, EmpName), ExLocal);
end;

//------------------------------------------------------------------------------

function TJEmpRec.WindowExportEnableExport: Boolean;
begin
  Result := (Current_Page In [NotesPage,
                              LedgerPage,
                              RatePage]);
  if Result then
  begin
    WindowExport.AddExportCommand (ecIDCurrentRow, ecdCurrentRow);
    WindowExport.AddExportCommand (ecIDCurrentPage, ecdCurrentPage);
    WindowExport.AddExportCommand (ecIDEntireList, ecdEntireList);
  end;
end;

procedure TJEmpRec.WindowExportExecuteCommand(const CommandID: Integer;const ProgressHWnd: HWND);
Var
  ListExportIntf : IExportListData;
begin
  // Returns a new instance of an "Export Btrieve List To Excel" object
  ListExportIntf := NewExcelListExport;
  try
    ListExportIntf.ExportTitle := WindowExportGetExportDescription;

    // Connect to Excel
    If ListExportIntf.StartExport Then
    begin
      // SSK 22/05/2018 2018-R1.1 ABSEXCH-20309: changes made to implement export list functionality for Notes, Ledger, .... etc. tab
      if (Current_Page = NotesPage) then
        // Notes tab
        NotesCtrl.MULCtrlO.ExportList (ListExportIntf, CommandID, ProgressHWnd)
      else if (Current_Page In [LedgerPage, RatePage]) then
        // Get the active Btrieve List to export the data for Ledger tab & Time Rate/Global Time Rate
        MulCtrlO[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd);

      ListExportIntf.FinishExport;
    end; // If ListExportIntf.StartExport(sTitle)
  finally
    ListExportIntf := NIL;
  end; // Try..Finally

end;

function TJEmpRec.WindowExportGetExportDescription: String;
begin
  // SSK 22/05/2018 2018-R1.1 ABSEXCH-20309: changes made to implement export list functionality for Notes, Ledger, .... etc tab
  case Current_Page Of
    NotesPage     : Result := 'Notes';
    LedgerPage    : Result := 'Ledger';
    RatePage      : begin
                      if GlobPRate = 1 then
                        Result := 'Global Time Rates'
                      else
                        Result := 'Time Rates';
                    end;
  end;

  // SSK 29/05/2018 2018-R1.1 ABSEXCH-20687: this condition is checked for Employee/Job Costing Time Rates
  if GlobPRate = 0 then   //Employee Time Rates
    Result := 'Employee ' + Result + ' - ' + Trim(ExLocal.LJobMisc^.EmplRec.EmpCode)
  else if GlobPRate = 2 then   //Job Time Rates
    Result := 'Job ' + Result + ' - ' + Trim(ExLocal.LJobRec^.JobCode);

end;

Initialization

  FillChar(JDDFormMode,Sizeof(JDDFormMode),0);
  FillChar(GlobJCode,Sizeof(GlobJCode),0);


end.
