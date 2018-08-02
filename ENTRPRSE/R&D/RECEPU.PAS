unit RecepU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, SBSPanel, ComCtrls, StdCtrls, TEditVal, Mask,
  GlobVar,VarConst,ExWrap1U,BTSupU1,SupListU,SBSComp2,BorBtns,
  DelAddU,
  SalTxL1U,
  EntWindowSettings,
  {$IFDEF NP}
    NoteU,
  {$ENDIF}

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  PayLineU,


  Menus;



type
  TRecepForm = class(TForm)
    PageControl1: TPageControl;
    RecepPage: TTabSheet;
    R1SBox: TScrollBox;
    R1HedPanel: TSBSPanel;
    R1PayPanel: TSBSPanel;
    R1NomPanel: TSBSPanel;
    R1NomD2Panel: TSBSPanel;
    R1BasePanel: TSBSPanel;
    R1ChqPanel: TSBSPanel;
    R1PayInPanel: TSBSPanel;
    R1ListBtnPanel: TSBSPanel;
    NotesPage: TTabSheet;
    R1BtnPanel: TSBSPanel;
    R1BSBox: TScrollBox;
    AddR1Btn: TButton;
    EditR1Btn: TButton;
    DelR1Btn: TButton;
    InsR1Btn: TButton;
    OkR1Btn: TButton;
    CanR1Btn: TButton;
    ClsR1Btn: TButton;
    TCNScrollBox: TScrollBox;
    TNHedPanel: TSBSPanel;
    NDateLab: TSBSPanel;
    NDescLab: TSBSPanel;
    NUserLab: TSBSPanel;
    NDatePanel: TSBSPanel;
    NDescPanel: TSBSPanel;
    NUserPanel: TSBSPanel;
    TcNListBtnPanel: TSBSPanel;
    R1FPanel: TSBSPanel;
    Label84: Label8;
    Label87: Label8;
    R1CurrLab: Label8;
    Label82: Label8;
    R1XRateLab: Label8;
    R1Base2Lab: Label8;
    R1TDateF: TEditDate;
    R1TPerF: TEditPeriod;
    R1YrefF: Text8Pt;
    R1RValF: TCurrencyEdit;
    R1XRateF: TCurrencyEdit;
    SBSPanel2: TSBSPanel;
    R1CurrF: TSBSComboBox;
    R1AddrF: TMemo;
    SwiR1Btn: TButton;
    R1BaseF: TCurrencyEdit;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Insert1: TMenuItem;
    Switch1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    DefR1Btn: TButton;
    I1StatLab: Label8;
    Defaults1: TMenuItem;
    StatusPnl: TSBSPanel;
    SBSPanel4: TSBSPanel;
    ReqdTit: Label8;
    ReqdLab: Label8;
    VarPanel: TSBSPanel;
    VarTit: Label8;
    VarLab: Label8;
    CCPanel: TSBSPanel;
    CCTit: Label8;
    DepTit: Label8;
    CCLab: Label8;
    DepLab: Label8;
    R1NomLab: TSBSPanel;
    R1NomD2Lab: TSBSPanel;
    R1ChQLab: TSBSPanel;
    R1PayLab: TSBSPanel;
    R1BaseLab: TSBSPanel;
    R1PayInLab: TSBSPanel;
    StatR1Btn: TButton;
    Cleared1: TMenuItem;
    DiscPanel: TSBSPanel;
    Label81: Label8;
    DiscLab: Label8;
    LnkR1Btn: TButton;
    Links1: TMenuItem;
    chkI1Btn: TButton;
    Check1: TMenuItem;
    PayR1Btn: TButton;
    Pay1: TMenuItem;
    R1ReconPanel: TSBSPanel;
    R1ReconLab: TSBSPanel;
    PMenu_Notes: TPopupMenu;
    MenItem_General: TMenuItem;
    MenItem_Dated: TMenuItem;
    MenItem_Audit: TMenuItem;
    TransExtForm1: TSBSExtendedForm;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    Label88: Label8;
    UDF5L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    DMDCNomF: Text8Pt;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    Label817: Label8;
    R1OrefF: Text8Pt;
    R1OpoF: Text8Pt;
    R1AccF: Text8Pt;
    Label83: Label8;
    UDF11L: Label8;
    THUD11F: Text8Pt;
    UDF12L: Label8;
    THUD12F: Text8Pt;
    Shape1: TShape;
    pnlAnonymisationStatus: TPanel;
    shpNotifyStatus: TShape;
    lblAnonStatus: TLabel;
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure SetUDFields(UDDocHed  :  DocTypes);
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ClsR1BtnClick(Sender: TObject);
    function R1TPerFConvDate(Sender: TObject; const IDate: string;
      const Date2Pr: Boolean): string;
    procedure R1AddrFDblClick(Sender: TObject);
    procedure AddR1BtnClick(Sender: TObject);
    procedure DelR1BtnClick(Sender: TObject);
    procedure SwiR1BtnClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    function R1TPerFShowPeriod(Sender: TObject; const EPr: Byte): string;
    procedure OkR1BtnClick(Sender: TObject);
    procedure R1TDateFExit(Sender: TObject);
    procedure R1AccFExit(Sender: TObject);
    procedure R1CurrFExit(Sender: TObject);
    procedure R1BaseFEnter(Sender: TObject);
    procedure R1RValFExit(Sender: TObject);
    procedure R1AccFEnter(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DefR1BtnClick(Sender: TObject);
    procedure R1XRateFExit(Sender: TObject);
    procedure StatR1BtnClick(Sender: TObject);
    procedure DMDCNomFExit(Sender: TObject);
    procedure LnkR1BtnClick(Sender: TObject);
    procedure chkI1BtnClick(Sender: TObject);
    procedure R1XRateFEnter(Sender: TObject);
    procedure PayR1BtnClick(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure R1YrefFChange(Sender: TObject);
    procedure MenItem_GeneralClick(Sender: TObject);
    procedure MenItem_DatedClick(Sender: TObject);
    procedure MenItem_AuditClick(Sender: TObject);
  private
    { Private declarations }

    bHelpContextInc, //NF: 12/04/06
    RAutoVar,
    RAutoDisc,
    AutoStore,
    AutoBal,
    JustCreated,
    InvStored,
    StopPageChange,
    FirstStore,
    ReCalcTot,
    StoreCoord,
    fNeedCUpdate,
    FColorsChanged,
    fFrmClosing,
    fDoingClose,
    LastCoord,
    SetDefault,
    GotCoord,
    ReCalcVariance,
    fRecordLocked,
    RunCredStatus,
    CanDelete    :  Boolean;

    SKeypath,
    MinHeight,
    MinWidth,
    POPStack     :  Integer;

    ABalNom      :  LongInt;

    {$IFDEF NP}
      NotesCtrl  :  TNoteCtrl;
    {$ENDIF}

    PayCtrl      :  TPayLine;

    DispCust     :  TFCustDisplay;

    InvBtnList   :  TVisiBtns;

    DelACtrl     :  TDelAddrPop;

    RecordPage   :  Byte;
    DocHed       :  DocTypes;

    RRnum,
    OldRnum,
    OldUnallocated,
    OldFullDisc,
    FullOldRnum,
    OwnOldRnum,
    OldFullOwn    :  Double;


    PagePoint  :  Array[0..6] of TPoint;

    StartSize,
    InitSize   :  TPoint;

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}

    // CJS: 16/12/2010 - Amendments for new Window Settings system
    FSettings : IWindowSettings;
    FPopupForList: Boolean;

    //PR: 08/10/2013 MRD 1.1.19
    WasConsumer : Boolean;

    //PR: 15/11/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;

    //AP 04/12/2017 2018R1 ABSEXCH-19538:variable added to handle anonymisation behaviour
    FListScanningOn,
    FAnonymisationON: Boolean;

    function TransactionViewOnly : Boolean;


    procedure ForceReadOnlyColors;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Procedure SetForceStore(State  :  Boolean);

    procedure FormSetOfSet;

    procedure NotePageReSize;

    procedure PayIPageReSize;

    procedure LinkToCC;

    Procedure SetCurrStat;

    Procedure SetCtrlNomStat;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Function CheckNeedStore  :  Boolean;

    Function ConfirmQuit  :  Boolean;

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure RefreshList(ShowLines,IgMsg  :  Boolean);

    procedure SetNewFolio;

    Function Check_LinesOk(InvR  :  InvRec)  :  Boolean;

    Function CheckCompleted(Edit  :  Boolean)  : Boolean;

    procedure RetFromLedger;

    procedure Link2Ledger(Sender  :  TObject);

    Function CalcBalValue  :  Double;

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure Warn_Allocated;

    Function Warn_OverAllocated  :   Boolean;

    procedure SetHelpContextIDsForPage(bInc : boolean); // NF: 12/04/06

    //PR: 22/11/2011 v6.9
    procedure SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
    //HV 12/11/2017 ABSEXCH-19549: Anonymised Notification banner in View/Edit Record > Banner not displayed on maximise and then Restore Down.
    procedure SetAnonymisationPanel;
  public
    { Public declarations }

    fForceStore:  Boolean;

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;


    Property ForceStore  : Boolean read fForceStore write SetForceStore default False;

    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1  :  LongInt) :  LongInt;

    procedure PrimeButtons;

    procedure BuildDesign;

    procedure FormDesign;

    Function Current_BarPos(PageNo  :  Byte)  :  Integer;


    procedure FormBuildList(ShowLines  :  Boolean);

    Function Current_Page  :  Integer;

    Function SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

    procedure ShowLink(ShowLines,
                       VOMode    :  Boolean);


    procedure SetRecepStore(EnabFlag,
                            VOMode  :  Boolean);

    Procedure ChangePage(NewPage  :  Integer);


    procedure SetRecepFields;

    Procedure OutRecepTotals;

    procedure OutRecep;

    procedure Form2Recep;

    Procedure SetFieldFocus;

    Procedure NoteUpdate;

    procedure GetAutoSettings;

    procedure ProcessRecep(Fnum,
                           KeyPAth    :  Integer;
                           Edit,
                           AutoOn     :  Boolean);

    procedure AutoGenLines(Fnum,Keypath  :  SmallInt);

    procedure StoreRecep(Fnum,
                         KeyPAth    :  Integer);

    procedure EditAccount(Edit,
                          AutoOn,
                          ViewOnly   :  Boolean);

    //PR: 15/11/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;

    //AP 07/12/2017 2018R1 ABSEXCH-19538:Anonymised Transactions > Notification banner is not displayed for SRC, PPY, xBT.
    procedure SetAnonymisationBanner;
    property ListScanningOn: Boolean read FListScanningOn write FListScanningOn;

  end;

  Procedure Set_RecepFormMode(State  :  DocTypes;
                              NPage  :  Byte);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Grids,
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,
  VarRec2U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,

  {$IFDEF PF_On}

    InvLst2U,

    {$IFDEF JC}
       JChkUseU,
    {$ENDIF}


  {$ENDIF}

  {$IFDEF GF}
    FindRecU,
    FindCtlU,
  {$ENDIF}

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  SysU1,
  SysU2,
  SysU3,
  IntMU,
  MiscU,
  PayF2U,
  AutoTxU,
  SrcBnkU,

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  Event1U,
  {$IFDEF CU}

  {$ELSE}
    {$IFDEF EBUS}
      Event1U,
    {$ENDIF}
  {$ENDIF}
  {$IFDEF RW}
    {Event1U,}
  {$ENDIF}

  {$IFDEF POST}
    PostingU,
  {$ENDIF}

  ThemeFix,

  PassWR2U,
  GenWarnU,
  Warn1U,
  //GS 14/10/2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF,

  { CJS - 2013-08-14 - MRD2.6 - Transaction Originator }
  TransactionOriginator,

  ConsumerUtils,

  AuditNotes,

  //AP 04/12/2017 2018R1 ABSEXCH-19538:Anonymised Transactions > Notification banner is not displayed for SRC, PPY, xBT.
  {$IFNDEF EXDLL}
    oSystemSetup,
  {$ENDIF}
  GDPRConst;

{$R *.DFM}



Var
  RecepFormMode  :  DocTypes;
  RecepFormPage  :  Byte;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_RecepFormMode(State  :  DocTypes;
                            NPage  :  Byte);

Begin
  If (State<>RecepFormMode) then
    RecepFormMode:=State;

  If (RecepFormPage<>NPage) then
    RecepFormPage:=NPage;

end;



Procedure  TRecepForm.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TRecepForm.Find_FormCoord;


Var
  ThisForm:  TForm;

  VisibleRect
          :  TRect;

  GlobComp:  TGlobCompRec;


Begin
  if Assigned(FSettings) and not FSettings.UseDefaults then
  begin
    // CJS 24/03/2011 ABSEXCH-10544
    FSettings.SettingsToWindow(self);
    FSettings.SettingsToParent(Self);
    ForceReadOnlyColors;
  end;
(*
  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do
  Begin

    GetValues:=BOn;

    PrimeKey:=Chr(Ord('!')+Ord(DocHed In SalesSplit));


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

    GetbtControlCsm(R1SBox);

    GetbtControlCsm(R1BSBox);

    GetbtControlCsm(R1BtnPanel);

    GetbtControlCsm(R1ListBtnPanel);

    GetbtControlCsm(TCNScrollBox);
    GetbtControlCsm(TCNListBtnPanel);


    If GetbtControlCsm(R1AccF) then
      SetFieldProperties;


  end; {With GlobComp..}


  StartSize.X:=Width; StartSize.Y:=Height;

  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range *}

*)
end;


procedure TRecepForm.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin
(*
  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:=Chr(Ord('!')+Ord(DocHed In SalesSplit));

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(R1SBox);

    StorebtControlCsm(R1BSBox);

    StorebtControlCsm(R1BtnPanel);

    StorebtControlCsm(R1ListBtnPanel);

    StorebtControlCsm(R1AccF);

    StorebtControlCsm(TCNScrollBox);

    StorebtControlCsm(TCNListBtnPanel);

    {$IFDEF NP}
      If (NotesCtrl<>nil) then
        NotesCtrl.MULCtrlO.Store_ListCoord(GlobComp);
    {$ENDIF}

    {$IFDEF Rt_On}
      If (PayCtrl<>nil) then
        PayCtrl.MULCtrlO.Store_ListCoord(GlobComp);
    {$ENDIF}

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
*)
  if Assigned(FSettings) then
  begin
    if Assigned(NotesCtrl) then
      FSettings.ParentToSettings(NotesCtrl.MULCtrlO, NotesCtrl.MULCtrlO); //Notes

    if Assigned(PayCtrl) then
      FSettings.ParentToSettings(PayCtrl.MULCtrlO, PayCtrl.MULCtrlO); //Pay Lines

    FSettings.ParentToSettings(Self,R1YRefF);
    //AP 07/12/2017 ABSEXCH-19538: Anonymised Transaction > The height of the window gets increased if "Save coordinates" is ticked
    if pnlAnonymisationStatus.Visible then
    begin
      Self.ClientHeight := Self.ClientHeight - pnlAnonymisationStatus.Height;
      Self.ClientWidth := Self.ClientWidth;
    end;
    // CJS 24/03/2011 ABSEXCH-10544
    FSettings.WindowToSettings(self);
    FSettings.SaveSettings(StoreCoord);
  end;

end;




procedure TRecepForm.SetForceStore(State  :  Boolean);

Begin
  If (State<>fForceStore) then
  Begin
    fForceStore:=State;

    If (Not ExLocal.LViewOnly) then
    Begin
      ClsR1Btn.Enabled:=Not fForceStore;
      CanR1Btn.Enabled:=ClsR1Btn.Enabled;
    end;

  end;
end;


Function TRecepForm.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;


procedure TRecepForm.LinkToCC;

Begin
  With Id do
  Begin
    CCLab.Caption:=CCDep[BOn];
    DepLab.Caption:=CCDep[BOff];
  end;
end;

Procedure TRecepForm.SetCurrStat;

Begin
  {$IFDEF MC_On}


    With ExLocal,LInv do
    If (Not LViewOnly) then
    Begin
      R1CurrF.ReadOnly:=((Round(TotalInvoiced)<>0) or (CheckExsists(Strip('R',[#0],FullNomKey(FolioNum)),IdetailF,IdFolioK)));

      R1XRateF.ReadOnly:=(R1CurrF.ReadOnly or (Not UseCoDayRate) or (SyssGCuR^.GhostRates.TriEuro[Currency]<>0)
                       or (Currency=1) or (Not CanEditTriEuro(Currency)));
    end;

  {$ENDIF}
end;


Procedure TRecepForm.SetCtrlNomStat;


Begin

  With ExLocal do
  If (Not LViewOnly) then
  With DMDCNomF do
  Begin
    ReadOnly:=((Text='') and (LCust.DefCtrlNom=0));

    TabStop:=Not ReadOnly;

  end;
end;


Procedure TRecepForm.WMCustGetRec(Var Message  :  TMessage);

Var
  mbRet  :  Word;

Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin
              If (PayCtrl<>nil) then
                With PayCtrl do
                  MULCtrlO.GetSelRec(BOff);

              AddR1BtnClick(EditR1Btn);
            end;

      1  :  Begin
              LinkToCC;
            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      7  :  NoteUpDate; {* Update note line count *}

     17  :  Begin {* Force reset of form *}
              GotCoord:=BOff;
              SetDefault:=BOn;
              Close;
            end;

     18  :  RetFromLedger;

     25  :  Begin
              NeedCUpdate:=BOn;
              FColorsChanged := True;
            End;

     30  :  RunCredStatus:=(LParam=1);

    108  :  Begin

              If (PayCtrl<>nil) then
              With ExLocal do
              Begin
                LInv:=PayCtrl.ExLocal.LInv;
                LId:=PayCtrl.ExLocal.LId;

                OutRecepTotals;

                If (LastEdit) and (Not LViewOnly) and (Not ForceStore) then
                  ForceStore:=((LInv.TotalReserved<>LastInv.TotalReserved) or
                               (Linv.Variance<>LastInv.Variance) or
                               (Linv.TotalInvoiced<>LastInv.TotalInvoiced) or
                               (Linv.DiscSetl<>LastInv.DiscSetl) or
                               (Linv.PostDiscAm<>LastInv.PostDiscAm));

                SetCurrStat;

              end;

              InvBtnList.SetEnabBtn(BOn);

              If (AutoStore) then
                StoreRecep(InvF,SKeypath);

            end;

    120,121
         :  Begin

              InvBtnList.SetEnabBtn((WParam=120));

            end;

    {$IFDEF FRM}

       170  :  Begin
                 {$B-}
                 If (Not ExLocal.InAddEdit) or ((Not CheckFormNeedStoreChk(Self,BOff)) and (ExLocal.LastEdit) and (Not ForceStore)) then
                   PrintDocument(ExLocal,BOn)
                 {$B+}
                 else
                   mbRet:=CustomDlg(Application.MainForm,'Please note','Print Transaction',
                                    'This transaction may only be printed once it has been stored.'+#13+#13+
                                    'Please complete this transaction, and then choose print.',mtInformation,[mbOk]);

               end;


    {$ENDIF}

    //GS: 15/03/2012 ABSEXCH-2414
    //added a 'wParam = 171' (opening the object drill) branch, now when the object drill is opened
    //and the active MDI form is TRecepForm (Sales Recipt / Purchase Payment record) the global invoice record
    //is refreshed beforehand, instead of using the last available global invoice record; which may not be
    //the record currently being displayed.

    171 :  Begin  // Link for ObjectDrill
              PayCtrl.MULCtrlO.GetSelRec(BOff);
              ExLocal.AssignToGlobal(InvF);
            end;

    175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

    176 :  Case LParam of
             0  :  Case Current_Page of

                     1  :  {$IFDEF NP}
                             If (Assigned(NotesCtrl)) then
                               NotesCtrl.MULCtrlO.SetListFocus;
                           {$ELSE}
                             ;
                           {$ENDIF}

                     else  If (Assigned(PayCtrl)) then
                             PayCtrl.MULCtrlO.SetListFocus;

                   end; {Case..}

             1  :  ; {VK_Home pressed..}

            end; {Case..}



     {$IFDEF Ltr}
       400,
       401  : Begin
                LetterActive:=Boff;
                LetterForm:=nil;
              end;
     {$ENDIF}
    end; {Case..}

  end;
  Inherited;
end;

Procedure TRecepForm.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

{ == Procedure to Send Message to Get Record == }

Procedure TRecepForm.Send_UpdateList(Edit   :  Boolean;
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


procedure TRecepForm.ShowLink(ShowLines,
                               VOMode    :  Boolean);
var
  lAnonStat: string;
begin
  ExLocal.AssignFromGlobal(InvF);
  ExLocal.LGetRecAddr(InvF);

  With ExLocal,LInv do
  Begin
    //AP 07/12/2017 2018R1 ABSEXCH-19538:set AnonymisationON to position the banner properly
    lAnonStat := ' ';
    if GDPROn and (LInv.thAnonymised) then
      lAnonStat := lAnonStat + capAnonymised;
    Caption := DocNames[InvDocHed]+' Record - ' + Pr_OurRef(LInv) + lAnonStat;

    {$B-}

    LViewOnly:=SetViewOnly(ShowLines,VOMode);

    PrimeButtons;

    {$B+}

    //AP 07/12/2017 2018R1 ABSEXCH-19538:set AnonymisationON to position the banner properly
    if ShowLines or VOMode then
      FAnonymisationON := (GDPROn and (trim(LInv.OurRef) <> '') and LInv.thAnonymised)
    else
      FAnonymisationON := False;
    SetAnonymisationBanner;
  end;


  OutRecep;


  ReFreshList(ShowLines,Not JustCreated);




  {$IFDEF NP}

    If (Current_Page=1) and (NotesCtrl<>nil) then {* Assume record has changed *}
    With ExLocal do
    Begin
      NotesCtrl.RefreshList(FullNomKey(LInv.FolioNum),NotesCtrl.GetNType);
      NotesCtrl.GetLineNo:=LInv.NLineCount;
    end;
  {$ENDIF}

  JustCreated:=BOff;

end;

Function TRecepForm.SetHelpC(PageNo :  Integer;
                             Pages  :  TIntSet;
                             Help0,
                             Help1  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    If (PageNo=1) then
      Result:=Help1
    else
      Result:=Help0;
  end
  else
    Result:=-1;

end;


procedure TRecepForm.PrimeButtons;

Var
  PageNo  :  Integer;

Begin
  PageNo:=Current_Page;

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
      Begin
       {0}AddVisiRec(AddR1Btn,BOff);
       {1}AddVisiRec(EditR1Btn,BOff);
       {2}AddVisiRec(DelR1Btn,BOff);
       {3}AddVisiRec(InsR1Btn,BOff);
       {4}AddVisiRec(SwiR1Btn,BOff);
       {5}AddVisiRec(DefR1Btn,BOff);
       {6}AddVisiRec(StatR1Btn,BOff);
       {7}AddVisiRec(ChkI1Btn,BOff);
       {8}AddVisiRec(LnkR1Btn,BOff);
       {9}AddVisiRec(PayR1Btn,BOff);

      end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    SetHelpContextIDsForPage(FALSE); //NF: 12/04/06

    With InvBtnList do
    Begin
      SetHideBtn(0,((ExLocal.LViewOnly) and ((PageNo<>1) or (fRecordLocked))),BOff);
      SetHideBtn(1,((ExLocal.LViewOnly) and (PageNo=1) and (fRecordLocked)) ,BOff);

      SetBtnHelp(0,SetHelpC(PageNo,[0..1],260,88));
      SetBtnHelp(1,SetHelpC(PageNo,[0..1],261,87));

      SetHideBtn(2,Not IdButton(0).Visible,BOff);
      SetBtnHelp(2,SetHelpC(PageNo,[0..1],263,89));

      SetHideBtn(3,(PageNo=0) or (Not IdButton(0).Visible),BOff);


      SetHideBtn(4,(PageNo=0),BOff);
      SetHideBtn(5,((ExLocal.LViewOnly) or (PageNo=1)),BOff);
      SetHideBtn(6,(PageNo<>0),BOff);
      SetHideBtn(7,((ExLocal.LViewOnly) or (PageNo=1)),BOff);
      SetHideBtn(8,(PageNo In [1]),BOn);

    end;

    SetHelpContextIDsForPage(TRUE); //NF: 12/04/06

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure TRecepForm.BuildDesign;

Var
  HideCC  :  Boolean;

begin

  {* Set Version Specific Info *}

  {$IFNDEF MC_On}
    R1CurrLab.Visible:=BOff;
    R1CurrF.Visible:=BOff;
    R1XRateF.Visible:=BOff;
    R1XRateLab.Visible:=BOff;
    R1Base2Lab.Visible:=BOff;
    R1BaseF.Visible:=BOff;
    VarPanel.Visible:=BOff;
    ReqdTit.Caption:='Required';

    TransExtForm1.TabNext:=R1RValF;
    
  {$ENDIF}

  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}


  CCPanel.Visible:=Not HideCC;

  //PR: 08/10/2013 MRD 1.1.19 Set length appropriately - company length + 2 (_/)
  R1AccF.MaxLength:=CustCompLen + 2;
  R1YRefF.MaxLength:=DocYRef1Len;

  If (DocHed In PurchSplit) then
    RecepPage.Caption:='Payment';

  //GS 14/10/2011 ABSEXCH-11706: removed existing UDF setup code; replaced with calling pauls new method
  SetUDFields(DocHed);

  R1BSBox.HorzScrollBar.Visible:=BOff;
end;


//GS 14/10/2011 ABSEXCH-11706: a copy of pauls user fields function
//PR: 14/11/2011 Amended to use centralised function EnableUdfs in CustomFieldsIntf.pas ABSEXCH-12129
procedure TRecepForm.SetUDFields(UDDocHed  :  DocTypes);
begin
{$IFDEF ENTER1}
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L, UDF11L, UDF12L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F],
             DocTypeToCFCategory(UDDocHed));


  ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F]),
                           2, //UDFs laid out on the UI as 2 columns, 5 rows
                           TransExtForm1,
                           0,     // RowHeightOverRide
                           12);   // UDF_Count
{$ENDIF}
end;

procedure TRecepForm.FormDesign;


begin

  {$IFDEF MC_On}

    Set_DefaultCurr(R1CurrF.Items,BOff,BOff);
    Set_DefaultCurr(R1CurrF.ItemsL,BOff,BOn);

  {$ENDIF}

  PrimeButtons;

  BuildDesign;

end;



Function TRecepForm.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      0
         :  Result:=R1SBox.HorzScrollBar.Position;
      else  Result:=0;
    end; {Case..}


end;



Procedure TRecepForm.RefreshList(ShowLines,IgMsg  :  Boolean);
Begin

  If (PayCtrl<>nil) then
  With ExLocal do
    If (LInv.FolioNum<>PayCtrl.GetFolio) and (ShowLines) then {* Refresh notes *}
    with PayCtrl do
    Begin
      ExLocal.LInv:=Self.ExLocal.LInv;
      RefreshList(LInv.FolioNum);
    end;


end;


procedure TRecepForm.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;

  PaySetUp    :  TPayInSetUp;


Begin

  Find_FormCoord;

  With ExLocal do
  Begin
    PayCtrl:=TPayLine.Create(Self);

    With PaySetUp do
    Begin
      ColPanels[0]:=R1NomPanel; ColPanels[1]:=R1NomLab;
      ColPanels[2]:=R1NomD2Panel; ColPanels[3]:=R1NomD2Lab;
      ColPanels[4]:=R1ChQPanel; ColPanels[5]:=R1ChQLab;

      ColPanels[6]:=R1PayPanel; ColPanels[7]:=R1PayLab;
      ColPanels[8]:=R1BasePanel; ColPanels[9]:=R1BaseLab;
      ColPanels[10]:=R1PayInPanel; ColPanels[11]:=R1PayInLab;

      ColPanels[12]:=R1HedPanel;
      ColPanels[13]:=R1ListBtnPanel;

      ColPanels[14] := R1ReconPanel;
      ColPanels[15] := R1ReconLab;



      ScrollBox:=R1SBox;
      PropPopUp:=StoreCoordFlg;

      CoorPrime:=Chr(Ord('!')+Ord(DocHed In SalesSplit));
      CoorHasCoor:=LastCoord;

    end;

    try
      PayCtrl.WindowSettings := FSettings;
      PayCtrl.CreateList(Self,PaySetUp,ShowLines,LInv);


    except
      PayCtrl.Free;
      PayCtrl:=Nil
    end;

    MDI_UpdateParentStat;

  end;


  FormSetOfSet;

  FormReSize(Self);

end;



{ ======== Display Receipt Record ========== }

procedure TRecepForm.SetRecepFields;

Var
  GenStr       :  Str255;

  UOR,
  n,m          :  Byte;


Begin
  UOR:=0;

  With ExLocal,LInv do
  Begin
    R1ORefF.Text:=Pr_OurRef(LInv);
    R1OpoF.Text:=OpName;

    { CJS - 2013-10-25 - MRD2.6.06 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      R1OpoF.Hint := GetOriginatorHint(LInv)
    else
      R1OpoF.Hint := '';

    //PR: 08/10/2013 MRD 1.1.19 Set contents of a/c code field appropriately for trader type
    if IsConsumer(ExLocal.LCust) then
    begin
      R1AccF.Text := Trim(ExLocal.LCust.acLongACCode);
      WasConsumer := True; //Set consumer indicator
    end
    else
    begin
      R1AccF.Text:=Strip('R',[#32],CustCode);
      WasConsumer := False; //Set consumer indicator
    end;

    R1TPerF.InitPeriod(AcPr,AcYr,BOn,BOn);

    R1TDateF.DateValue:=TransDate;

    R1YRefF.Text:=YourRef;

    {$IFDEF MC_On}
      If (Currency>0) then
        R1CurrF.ItemIndex:=Pred(Currency);

      R1XRateF.Value:=CXRate[BOn];

      UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

      R1BaseF.Value:=Conv_TCurr(InvNetVal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

    {$ENDIF}

    DMDCNomF.Text:=Form_BInt(CtrlNom,0);

    CustToMemo(LCust,R1AddrF,0);

    R1RValF.Value:=InvNetVal;

    THUd1F.Text:=DocUser1;
    THUd2F.Text:=DocUser2;
    THUd3F.Text:=DocUser3;
    THUd4F.Text:=DocUser4;
    //GS 14/10/2011 ABSEXCH-11706: put customisation values into text text boxes
    THUd5F.Text:=DocUser5;
    THUd6F.Text:=DocUser6;
    THUd7F.Text:=DocUser7;
    THUd8F.Text:=DocUser8;
    THUd9F.Text:=DocUser9;
    THUd10F.Text:=DocUser10;
    // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
    THUd11F.Text:=thUserField11;
    THUd12F.Text:=thUserField12;



  end; {With..}
end;


Procedure TRecepForm.OutRecepTotals;

Var
  Dnum  :  Double;

Begin
  With ExLocal,LInv do
  Begin
    Dnum:=(TotalReserved-(Variance+PostDiscAm));

    VarLab.Caption:=FormatFloat(GenRealMask,Dnum);

    ReqdLab.Caption:=FormatFloat(GenRealMask,PRequired(BOn,LInv)*DocNotCnst);

    Dnum:=(DiscSetl-PostDiscAm);

    DiscLab.Caption:=FormatFloat(GenRealMask,Dnum);


  end; {With..}

end;

{ ======== Display Invoice Record ========== }

procedure TRecepForm.OutRecep;

Var
  GenStr       :  Str255;
  FoundCode    :  Str20;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    FoundCode:=CustCode;

    GetCust(Self,CustCode,FoundCode,IsACust(CustSupp),-1);

    ExLocal.AssignFromGlobal(CustF);

    SetRecepFields;

    OutRecepTotals;

    SetCtrlNomStat;

    {ResetExtFL;}

    TransExtForm1.ReAssignFocusLast;

    If (DispCust<>nil) then
    With DispCust do
    Begin
      If (CustActive) then
        R1AddrFDblClick(R1AddrF);
    end;
  end; {With..}
end;


procedure TRecepForm.Form2Recep;

Var
  n  :  VATType;

Begin
  With ExLocal.LInv do
  Begin
    //PR: 08/10/2013 MRD 1.1.19 Use long code for consumers.
    if IsConsumer(ExLocal.LCust) then
      CustCode := ExLocal.LCust.CustCode
    else
      CustCode:=FullCustCode(R1AccF.Text);

    TransDate:=R1TDateF.DateValue;

    R1TPerF.InitPeriod(AcPr,AcYr,BOff,BOff);

    YourRef:=R1YRefF.Text;

    CtrlNom:=IntStr(DMDCNomF.Text);

    {$IFDEF MC_On}

      Currency:=Succ(R1CurrF.ItemIndex);

      CXRate[BOn]:=R1XRateF.Value;

    {$ENDIF}


    InvNetVal:=R1RValF.Value;

    DocUser1:=THUd1F.Text;
    DocUser2:=THUd2F.Text;
    DocUser3:=THUd3F.Text;
    DocUser4:=THUd4F.Text;
    //GS 14/10/2011 ABSEXCH-11706: write udef field values into customisation object
    DocUser5:=THUd5F.Text;
    DocUser6:=THUd6F.Text;
    DocUser7:=THUd7F.Text;
    DocUser8:=THUd8F.Text;
    DocUser9:=THUd9F.Text;
    DocUser10:=THUd10F.Text;
    // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
    thUserField11 := THUd11F.Text;
    thUserField12 := THUd12F.Text;
  end; {With..}
end;


Procedure TRecepForm.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      0     //PR: 08/10/2013 MRD 1.1.19 Set initial focus to a/c code rather than your ref
         :  R1AccF.SetFocus;

    end; {Case&With..}

end; {Proc..}




Procedure TRecepForm.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}




procedure TRecepForm.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
  end;
end;


procedure TRecepForm.PageControl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;

  {$IFDEF NP}
    NoteSetUp :  TNotePadSetUp;
  {$ENDIF}

begin
  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      PrimeButtons;

      Case NewIndex of


      {$IFDEF NP}

        1  :  If (NotesCtrl=nil) then
              With ExLocal do
              Begin
                NotesCtrl:=TNoteCtrl.Create(Self);
                //PR: 22/11/2011 v6.9 Add Event handler for new note functionality.
                NotesCtrl.OnSwitch := SwitchNoteButtons;

                NotesCtrl.fParentLocked:=fRecordLocked;

                NotesCtrl.Caption:=Caption+' - Notes';

                FillChar(NoteSetup,Sizeof(NoteSetUp),0);
                With NoteSetUp do
                Begin
                  ColPanels[0]:=NDatePanel; ColPanels[1]:=NDateLab;
                  ColPanels[2]:=NDescPanel; ColPanels[3]:=NDescLab;
                  ColPanels[4]:=NUserPanel; ColPanels[5]:=NUserLab;

                  ColPanels[6]:=TNHedPanel;
                  ColPanels[7]:=TcNListBtnPanel;

                  ScrollBox:=TCNScrollBox;
                  PropPopUp:=StoreCoordFlg;

                  CoorPrime:=Chr(Ord('!')+Ord(DocHed In SalesSplit));
                  CoorHasCoor:=LastCoord;

                end;

                try
                  NotesCtrl.WindowSettings := FSettings;
                  NotesCtrl.CreateList(Self,NoteSetUp,NoteDCode,NoteCDCode,FullNomKey(LInv.FolioNum));
                  NotesCtrl.GetLineNo:=LInv.NLineCount;


                except
                  NotesCtrl.Free;
                  NotesCtrl:=Nil
                end;


              end
              else
              With ExLocal do
                If (FullNomKey(LInv.FolioNum)<>NotesCtrl.GetFolio) then {* Refresh notes *}
                with NotesCtrl do
                Begin
                  RefreshList(FullNomkey(LInv.FolioNum),GetNType);
                  GetLineNo:=LInv.NLineCount;
                end;

      {$ELSE}

         1  :  ;

      {$ENDIF}



      end; {Case..}


      MDI_UpdateParentStat;

    end; {With..}
end;



procedure TRecepForm.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(R1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(R1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(R1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(R1BtnPanel.Height);

  PagePoint[3].X:=R1BtnPanel.Height-(R1BSBox.Height);
  PagePoint[3].Y:=R1SBox.ClientHeight-(R1NomPanel.Height);

  PagePoint[4].X:=PageControl1.Width-(R1ListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(R1ListBtnPanel.Height);

  PagePoint[5].X:=PageControl1.Width-(TCNScrollBox.Width);
  PagePoint[5].Y:=PageControl1.Height-(TCNScrollBox.Height);

  PagePoint[6].X:=PageControl1.Width-(TCNListBtnPanel.Left);
  PagePoint[6].Y:=PageControl1.Height-(TCNListBtnPanel.Height);


  GotCoord:=BOn;

end;


procedure TRecepForm.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  bHelpContextInc := FALSE; //NF: 12/04/06

  ExLocal.Create;

  fDoingClose:=BOff;

  ForceStore:=BOff;

  ListScanningOn := False;

  LastCoord:=BOff;
  ReCalcTot:=BOn;

  Visible:=BOff;

  InvStored:=BOff;

  JustCreated:=BOn;

  GotCoord:=BOff;

  NeedCUpdate:=BOff;
  FColorsChanged := False;
  fFrmClosing:=BOff;
  StopPageChange:=BOff;
  fRecordLocked:=BOff;

  RunCredStatus:=BOff;

  PayCtrl:=nil;

  SKeypath:=0;

  MinHeight:=375;
  MinWidth:=626;

  //AP 06/12/2017 2018R1 ABSEXCH-19538:Changed initial clientheight from 351 to 425 to accommodate new Anonymised Control
  InitSize.Y := 425;
  InitSize.X:=632;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  POPStack:=0;

  {Height:=382;
  Width:=638;}

  PageControl1.ActivePage:=RecepPage;


  With TForm(Owner) do
  Begin
    Self.Left:=0;
    Self.Top:=0;
  end;

  RecordPage:=RecepFormPage;
  DocHed:=RecepFormMode;

  Caption:=DocNames[DocHed];

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;


  AutoStore:=BOff;
  AutoBal:=Syss.UseDefBank;

  {If (DocHed In SalesSplit) then v4.32 method
    ABaLNom:=Syss.DefSRCBankNom
  else
    ABaLNom:=Syss.DefBankNom;}


  ABaLNom:=GetProfileBank(DocHed In SalesSplit);


  RAutoVar:=Syss.AutoGenVar;
  RAutoDisc:=Syss.AutoGenDisc;
  ReCalcVariance:=BOff;


  FormDesign;

  // CJS: 16/12/2010 - Amendments for new Window Settings system
  //PR: 27/05/2011 Change to use ClassName rather than Name as identifier - if there are
  //2 instances of the form in existence at the same time, Delphi will change the name of one to Name + '_1' (ABSEXCH-11426)
  FSettings := GetWindowSettings(Self.ClassName + '_' + DocCodes[DocHed]);
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  FormBuildList(BOff);

  //PR: 08/10/2013 MRD 1.1.19
  WasConsumer := False;

  FAllowPostedEdit := False;

end;



procedure TRecepForm.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  If (InvBtnList<>nil) then
    InvBtnList.Free;

  {If (MULCtrlO<>nil) then
    MULCtrlO.Free;}

  If (Not fDoingClose) then {FormClose never executed so we cannot destroy list resourece, otherwise get a GPF}
    PayCtrl.MulCtrlO:=nil; {Stop list being destroyed}

end;

procedure TRecepForm.FormCloseQuery(Sender: TObject;
                                 var CanClose: Boolean);
Var
  n  : Integer;

begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try
      CanClose:=ConfirmQuit;

      GenCanClose(Self,Sender,CanClose,BOn);

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

        If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
          Store_FormCoord(Not SetDefault);


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

        Send_UpdateList(BOff,101);

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;

end;

procedure TRecepForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    Try
      If (PayCtrl.MULCtrlO<>Nil) then
        PayCtrl.MULCtrlO.Destroy; {* Must be destroyed here, as owned by ROB1...}

    Finally

      PayCtrl.MULCtrlO:=Nil;

    end; {Finally..}

  end;
end;

procedure TRecepForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  If (Key=$5A) and (Shift = ([ssAlt,ssCtrl,ssShift])) and (Not ExLocal.LViewOnly) and (ExLocal.LastEdit) then
  Begin
    Re_SetDoc(ExLocal.LInv);
    OutRecep;
    PayCtrl.MULCtrlO.PageUpDn(0,BOn);
  end;

end;

procedure TRecepForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;




procedure TRecepForm.NotePageReSize;

Begin
  With TCNScrollBox do
  Begin
    TNHedPanel.Width:=HorzScrollBar.Range;
    NDatePanel.Height:=TCNListBtnPanel.Height;
  end;

  NDescPanel.Height:=NDatePanel.Height;
  NUserPanel.Height:=NDatePanel.Height;


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


procedure TRecepForm.PayIPageReSize;

Begin
  If (Not fFrmClosing) then
  Begin
    With R1SBox do
    Begin
      R1HedPanel.Width:=HorzScrollBar.Range;
      // CJS 24/03/2011 ABSEXCH-10544
      // R1NomPanel.Height:=R1SBox.ClientHeight-PagePoint[3].Y;
      R1NomPanel.Height:=R1SBox.ClientHeight-R1HedPanel.Height;
    end;

    R1NomD2Panel.Height:=R1NomPanel.Height;
    R1ChQPanel.Height:=R1NomPanel.Height;
    R1PayPanel.Height:=R1NomPanel.Height;
    R1BasePanel.Height:=R1NomPanel.Height;
    R1PayInPanel.Height:=R1NomPanel.Height;


    If (PayCtrl<>nil) and (PayCtrl.MULCtrlO<>Nil) then {* Adjust list *}
    With PayCtrl.MULCtrlO,VisiList do
    Begin
      VisiRec:=List[0];

      With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=R1NomPanel.Height;

      ReFresh_Buttons;

      RefreshAllCols;
    end;
  end;
end;



procedure TRecepForm.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;
  Margin: Integer;

begin

  If (GotCoord) then
  Begin
    LockWindowUpdate(Handle);
    try
      Self.HorzScrollBar.Position:=0;
      Self.VertScrollBar.Position:=0;
{
      NewVal:=ClientWidth-PagePoint[0].X;
      If (NewVal<MinWidth) then
        NewVal:=MinWidth;

      PageControl1.Width:=NewVal;

      NewVal:=ClientHeight-PagePoint[0].Y;

      If (NewVal<MinHeight) then
        NewVal:=MinHeight;

      PageControl1.Height:=NewVal;
}

      PageControl1.Width := ClientWidth - 4;
      if FAnonymisationON then
        PageControl1.Height := ClientHeight - pnlAnonymisationStatus.Height - 4
      else
        PageControl1.Height := ClientHeight - 4;

      // CJS 24/03/2011 ABSEXCH-10544
      Margin := R1SBox.Left;

      R1SBox.Width := PageControl1.Width - (R1ListBtnPanel.Width + 4 + R1BtnPanel.Width + (2 * Margin));
      R1SBox.Height := (PageControl1.Height - StatusPnl.Height) - R1SBox.Top;

      TCNScrollBox.Width:=PageControl1.Width-PagePoint[5].X;
      TCNScrollBox.Height := PageControl1.Height - TCNScrollBox.Top;

      R1BtnPanel.Left := PageControl1.Width - (R1BtnPanel.Width + Margin);

      R1BtnPanel.Height := (PageControl1.Height - StatusPnl.Height) - R1BtnPanel.Top;
      R1BSBox.Height := R1BtnPanel.Height - R1BSBox.Top;

      R1ListBtnPanel.Left := R1SBox.Left + R1SBox.Width;
      R1ListBtnPanel.Height := ((PageControl1.Height - StatusPnl.Height) - R1ListBtnPanel.Top) - 32;

      TCNListBtnPanel.Left := R1SBox.Left + R1SBox.Width;
      TCNListBtnPanel.Height := (PageControl1.Height - TCNListBtnPanel.Top) - 32;

      NotePageResize;
      PayIPageResize;

      //AP 04/12/2017 2018R1 ABSEXCH-19538:Resize the anonymisation shape
      SetAnonymisationPanel;
      NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

    finally
      LockWindowUpdate(0);
    end;
  end; {If time to update}
end;


Function TRecepForm.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;


procedure TRecepForm.ClsR1BtnClick(Sender: TObject);
begin
  If ConfirmQuit then
    Close;
end;

function TRecepForm.R1TPerFConvDate(Sender: TObject; const IDate: string;
  const Date2Pr: Boolean): string;
begin
  Result:=ConvInpPr(IDate,Date2Pr,@ExLocal);
end;

Function TRecepForm.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and ((CheckNeedStore) or (ForceStore)) and (Not ExLocal.LViewOnly) and (Not InvStored) then
  Begin
    If (Current_Page>1) then {* Force view of main page *}
      ChangePage(0);

    If (ForceStore) then
      mbRet:=MessageDlg('This Receipt must be stored',mtWarning,[mbOk],0)
    else
      mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes
           :  Begin
                StoreRecep(InvF,SKeypath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) then
                Begin
                  Delete_DocEditNow(LInv.FolioNum);
                  Status:=UnLockMLock(InvF,LastRecAddr[InvF]);
                end
                else
                  If (Not LastEdit) then
                  Begin
                    ResetGlobAlloc(SalesorPurch(DocHed));

                    InSRC[SalesOrPurch(DocHed)]:=BOff;
                  end;

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


procedure TRecepForm.SetRecepStore(EnabFlag,
                                   VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode or FAllowPostedEdit;

  OkR1Btn.Enabled:=Not VOMode or FAllowPostedEdit;
  CanR1Btn.Enabled:=Not VOMode or FAllowPostedEdit;


  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    with Text8Pt(Components[Loop]) do
    Begin
      If (Tag=1) then
        ReadOnly:= VOMode and not AllowPostedEdit;
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
                If (Components[Loop] is TSBSComboBox) then
                Begin
                  If (TSBSComboBox(Components[Loop]).Tag=1) then
                    TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
              end;
  end; {Loop..}

  SetCurrStat;

end;


Procedure TRecepForm.NoteUpdate;


Const
  Fnum     =  InvF;
  Keypath  =  InvFolioK;


Var
  KeyChk,
  KeyS    :  Str255;

  HoldMode:  Byte;

  B_Func  :  Integer;

  TmpBo   :  Boolean;

  LiveInv :  InvRec;


Begin

  GLobLocked:=BOff;

  {$IFDEF NP}

    KeyS:=NotesCtrl.GetFolio;

    With ExLocal do
    Begin
      If (LastEdit) then
      Begin
        LiveInv:=LInv;
        Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPAth,Fnum,BOn,GlobLocked);

        LInv:=LiveInv;
      end

      else
      Begin
        Ok:=BOn; GlobLocked:=BOn;
      end;



      If (Ok) and (GlobLocked) then
      With LInv  do
      Begin
        If (LastEdit) then
          LGetRecAddr(Fnum);


        NLineCount:=NotesCtrl.GetLineNo;

        //PR: 10/07/2012 ABSEXCH-12784 Change to check for non-audit notes.
        if HasNonAuditNotes(LInv) then
          HoldMode:=232  {* Set Hold *}
        else
          HoldMode:=233;

        SetHold(HoldMode,Fnum,Keypath,BOff,LInv);

        If (LastEdit) then
        Begin
          Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath);

          Report_BError(Fnum,Status);
          {* Explicitly remove multi lock *}

          UnLockMLock(Fnum,LastRecAddr[Fnum]);
        end;

      end;

    end; {With..}

  {$ENDIF}


end; {Func..}

Function TRecepForm.SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

Var
  VOMsg  : Byte;

Begin


{$B-}

  Result:=(SL and ((VO) or View_Status(ExLocal.LInv,BOff,VOMsg)));

{$B+}

  If (VO) then {* Force View only msg *}
    VOMsg:=9;

  If (Result) then
  begin
    I1StatLab.Caption := GetIntMsg(VOMsg+50);
    Shape1.Shape := stRoundRect;
    Shape1.Left := 5; //I1StatLab.Left - 1;
    Shape1.Top := 16; //I1StatLab.Top - 3;
    Shape1.Width := R1btnPanel.Width - 10; //I1StatLab.Width + 4;
    Shape1.Height := I1StatLab.Height + 4;
    Shape1.Visible := True;
    Shape1.Brush.Color := RGB(0, 159, 223);
    I1StatLab.Color := Shape1.Brush.Color;
  end
  else
    I1StatLab.Caption:='';

  OkR1Btn.Visible:=Not Result or FAllowPostedEdit;
  CanR1Btn.Visible:=OkR1Btn.Visible;

  OKR1Btn.Enabled := OkR1Btn.Visible;
  CanR1Btn.Enabled := OkR1Btn.Visible;

  //PR: 04/12/2014 ABSEXCH-15890 Add Order Payments tag to Status message.
  // MH 03/07/2015 2015-R1 ABSEXCH-16499: Split status for Payments and Refunds
  //PR: 06/02/2018 ABSEXCH-19451 Amended caption to fit in new screen layout
  if ExLocal.LInv.thOrderPaymentElement In OrderPayment_PaymentSet then
    I1StatLab.Caption := 'V/O Ord Payment'
  Else if ExLocal.LInv.thOrderPaymentElement In OrderPayment_RefundSet then
    I1StatLab.Caption := 'V/O Ord Refund';

end;



procedure TRecepForm.GetAutoSettings;

Var
  mrResult  :  Word;
  ASCtrl    :  TAutoTxPop;

begin
  With ExLocal,LInv do
  Begin
    ASCtrl:=TAutoTxPop.Create(Self);

    try

      With ASCtrl do
      Begin
        ASTransDate:=TransDate;
        ASAutoIncBy:=AutoIncBy;
        ASAutoInc:=AutoInc;
        ASUntilDate:=UntilDate;
        ASPr:=ACPr;
        ASYr:=ACYr;
        ASUPr:=UnPr;
        ASUYr:=UnYr;
        ASAutoPost:=AutoPost;
        ASKeepDate:=OnPickRun;

        With R1AccF do
          mrResult:=InitAS(LViewOnly,Color,Font);

        If (mrResult=mrOk) then
        Begin
          TransDate:=ASTransDate;
          AutoIncBy:=ASAutoIncBy;
          AutoInc:=ASAutoInc;
          UntilDate:=ASUntilDate;
          AcPr:=ASPr;
          ACYr:=ASYr;
          UnPr:=ASUPr;
          UnYr:=ASUYr;
          AutoPost:=ASAutoPost;
          OnPickRun:=ASKeepDate;

          If (AutoIncBy=DayInc) then
            DueDate:=CalcDueDate(TransDate,AutoInc);

          SetRecepFields;
        end;


      end;
    finally

      ASCtrl.Free;

    end; {Try..}

  end; {with..}
end; {Proc..}





(*  Add is used to add Customers *)

procedure TRecepForm.ProcessRecep(Fnum,
                                  KeyPAth    :  Integer;
                                  Edit,
                                  AutoOn     :  Boolean);

Var
  UOR        :  Byte;

  KeyS       :  Str255;


Begin

  Addch:=ResetKey;

  UOR:=0;

  KeyS:='';

  Elded:=Edit;

  SKeyPath:=Keypath;

  If (Edit) then
  Begin

    With ExLocal do
    Begin
      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      If (Not LViewOnly) then
      Begin
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked);

        If (Ok) and (LInv.RunNo>0) then {* its posted.. }
          Ok:=BOff;
      end
      else
        Ok:=BOn;


    end;


    If (Not Ok) or (Not GlobLocked) then
    Begin
      AddCh:=#27;
      ExLocal.LViewOnly:=BOn;
      fRecordLocked:=BOn;
    end;
  end;



  If (Addch<>#27) then
  With ExLocal,LInv do
  begin

    
    If (Not Edit) then
    Begin
      Caption:=DocNames[DocHed]+' Record';

      LResetRec(Fnum);

      RunNo:=0+(AutoRunNo*Ord(AutoOn));

      NomAuto:=Not AutoOn;

      InvDocHed:=DocHed;

      InSRC[SalesOrPurch(DocHed)]:=BOn;

      TransDate:=Today; AcPr:=GetLocalPr(0).CPr; AcYr:=GetLocalPr(0).CYr;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
        Date2Pr(TransDate,AcPr,AcYr,@ExLocal);

      NLineCount:=1;

      ILineCount:=1;


      OpName:=EntryRec^.Login;

      {$IFDEF MC_On}

        Currency:=1;

        CXrate:=SyssCurr.Currencies[Currency].CRates;

        CXRate[BOff]:=0;
      {$ELSE}

        Currency:=0;

        CXrate:=SyssCurr.Currencies[Currency].CRates;


      {$ENDIF}

      {* Preserve original Co. Rate *}

      OrigRates:=SyssCurr.Currencies[Currency].CRates;

      SetTriRec(Currency,UseORate,CurrTriR);
      SetTriRec(Currency,UseORate,OrigTriR);

      CustSupp:=TradeCode[(InvDocHed In SalesSplit)];


      If (Not AutoOn) then
        SetNextDocNos(LInv,BOff)
      else
      Begin
        SetNextAutoDocNos(LInv,BOff);

        AutoIncBy:=DayInc;

        AutoInc:=30;

        UntilDate:=MaxUntilDate;

        UnYr:=MaxUnYr;

        UnPr:=Syss.PrInYr;
      end;

      
      OutRecep;

      If (Not Edit) then
        ReFreshList(BOn,Not JustCreated);

    end
    else
    Begin
      {* Add to list as currently being edited *}

      If (Not LViewOnly) then
        Add_DocEditNow(LInv.FolioNum);

    end;

    LastInv:=LInv;

    RRnum:=0; OldUnallocated:=0;

    FullOldRnum:=0;

    OldFullOwn:=0;

    OldFullDisc:=0;

    UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

    OldRnum:=Conv_TCurr(InvNetVal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

    UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

    OwnOldRnum:=Conv_TCurr(InvNetVal,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff);

    FullOldRnum:=OldRnum;


    SetRecepStore(BOn,LViewOnly);


    If (AutoOn) then {* Get Auto Settings *}
    Begin
      GetAutoSettings;
    end;



    SetFieldFocus;

  end {If Abort..}
  else
  Begin
    SetViewOnly(BOn,ExLocal.LViewOnly);
    PrimeButtons;
  end;


end; {Proc..}



 { ====================== Function to Check ALL valid invlines (InvLTotal<>0) have a nominal =============== }

Function TRecepForm.Check_LinesOk(InvR  :  InvRec)  :  Boolean;

Const
  Fnum     =  IDetailF;
  Keypath  =  IDFolioK;



Var

  KeyS,
  KeyChk    :  Str255;
  NomOk     :  Boolean;

  ExStatus  :  Integer;

 {$IFDEF PF_On}

  Loop     :  Boolean;

 {$ENDIF}


Begin
  NomOk:=BOn;

  ExStatus:=0;

  KeyChk:=FullIdKey(InvR.FolioNum,RecieptCode);

  KeyS:=KeyChk;

  ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


  While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NomOk) do
  With Id do
  Begin

    If (PayCtrl<>nil) then
    With PayCtrl do
    Begin
      ExLocal.AssignFromGlobal(IdetailF);
      NomOk:=CheckCompleted(Self.ExLocal.LastEdit,BOn);
    end
    else
      NomOk:=BOn;


    ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Result:=NomOk;
end; {Func..}


Function TRecepForm.Warn_OverAllocated  :   Boolean;

Const
  UnderOver  :  Array[BOff..BOn] of Str10 = ('under','over');

Var
  VarAmnt   :  Double;
  mbRet     :  Word;

  Begin
    Result:=BOn;


    With ExLocal,LInv do
    Begin


      VarAmnt:=Round_Up(Round_Up(TotalReserved,2)-(Variance+PostDiscAm),2);

      If (Not LastEdit) and (VarAmnt<>0) then
      Begin
        mbRet:=CustomDlg(Self,'WARNING!',UnderOver[VarAmnt>0]+' allocation.',
                       'This '+DocNames[InvdocHed]+' has been '+UnderOver[VarAmnt>0]+' allocated.'+#13+#13+

                       {$IFDEF MC_On}
                         'Please check you have taken any variance / settlement discount now, as these '+
                         'can only be taken when a '+DocNames[InvdocHed]+' is initially created.'+#13+#13+

                        {$ELSE}

                          'Although '+UnderOver[VarAmnt>0]+' allocation is permitted, it can '+
                          'make the ledger difficult to reconcile.'+#13+#13+
                        {$ENDIF}


                        'Please confirm you wish to '+UnderOver[VarAmnt>0]+' allocate this '+DocNames[InvdocHed],
                       mtConfirmation,
                       [mbYes,mbNo]);


        Result:=(mbRet=mrOk);

      end;
    end;
  end;


Function TRecepForm.CheckCompleted(Edit  :  Boolean)  : Boolean;

Const
  NofMsgs      =  14;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  FoundLong:  LongInt;
  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  BalNow   :  Double;


Begin
  New(PossMsg);
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='Are any windows outstanding';
  PossMsg^[2]:='Account Code is not valid.';
  PossMsg^[3]:='Currency is not valid.';
  PossMsg^[4]:='Payment part of this transaction does not balance.';
  PossMsg^[5]:='Transaction Date is not valid.';
  PossMsg^[6]:='Financial Period is not valid.';
  PossMsg^[7]:='Problem with transaction lines.';
  PossMsg^[8]:='This document must be allocated before it can be stored.';
  PossMsg^[9]:='The Control G/L Code is not valid.';
  PossMsg^[10]:='An exchange rate of zero is not valid.';
  PossMsg^[11]:='Warn Under/Over allocated.';
  PossMsg^[12]:='For local currency the exchange rate must be 1.0';
  PossMsg^[13]:='Check sub contractor expiry';
  PossMsg^[14]:='An additional check is made via an external hook';




  Test:=1;

  Result:=BOn;

  BalNow:=0;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LInv do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin {* Check if all child windows are going to close *}
              ShowMsg:=BOff;

              GenCanClose(Self,Self,Result,BOff);

            end;

      2  :  Begin
              Result:=((GetCust(Self,CustCode,FoundCode,IsACust(CustSupp),-1))
                      and (Cust.CustSupp=SetFilterFromDoc(InvDocHed))
                      and (Not EmptyKey(CustCode,CustKeyLen)));
            end;

    {$IFDEF MC_On}

      3  :  Result:=(Currency In [Succ(CurStart)..CurrencyType]);

      12 :  Begin
              Result:=((Currency=1) and (CXRate[BOn]=1.0)) or (Currency>1);

            end;
    {$ENDIF}

      4  :  Result:=(Round_Up(PRequired(BOn,LInv),2)=0);

      5  :  Result:=ValidDate(TransDate);

      6  :  Result:=ValidPeriod(StrPeriod(ConvTxYrVal(AcYr,BOff),AcPr),Syss.PrInYr);

      7  :  Result:=Check_LinesOk(LInv);

      8  :  Begin
              Result:=(Not JBFieldOn) or (LastEdit);

              If (Not Result) then
              With GlobalAllocRec^[SalesorPurch(InvDocHed)] do
              Begin
                Result:=((LUnallocated<>(InvNetVal*DocCnst[InvDocHed]*DocNotCnst)) Or (InvNetVal=0.0));
              end;
            end;

      // MH 08/11/2010 v6.5 ABSEXCH-10108: Modified check so that GetNom isn't called if the Control GL Code is 0
      //9  :  Result:=(CtrlNom=0) or (GetNom(Self,Form_Int(CtrlNom,0),FoundLong,-1));
      9   : Begin
              Result:=(CtrlNom=0);
              If (Not Result) Then
              Begin
                Result := GetNom(Self,Form_Int(CtrlNom,0),FoundLong,-1);
                // MH 08/11/2010 v6.5 ABSEXCH-10465: Modified validation to enfore a Control Code
                If Result Then
                  Result := (Nom.NomType = CtrlNHCode);
              End; // If (Not Result)
            End;

     10  :  Result:=(CXRate[BOn]<>0);

     11  :  Begin

              ShowMsg:=BOff;

              {$B-}

              Result:=RAutoVar or AutoBal or Warn_OverAllocated;

              {$B+}
            end;

     13  :  Begin
              ShowMsg:=BOff;

              {$IFDEF JC}
                {$IFDEF PF_On}
                   If (JBCostOn) and (InvDocHed=PPY) then
                     Result:=Not Cert_Expired(CustCode,Today,BOn,BOn);
                {$ENDIF}
              {$ENDIF}

            end;

     14  :   Begin {* Opportunity for hook to validate the header as well *}
                 {$IFDEF CU}

                   Result:=ValidExitHook(2000,82,ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;





    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}




procedure TRecepForm.AutoGenLines(Fnum,Keypath  :  SmallInt);

Var
  Ok2Store,
  Loop :  Boolean;

  VNum,
  DNum :  Double;


Begin
  With ExLocal.LInv do
  Begin
    DNum:=Round_Up(DiscSetl-PostDiscAm,2);

    If (Not RAutoDisc) then {* Take into account amount to be taken off by settlemt discount *}
      VNum:=Round_Up(TotalReserved-(Variance+PostDiscAm),2)
    else                {* Take off completely the amount of discount which is going to be auto taken *}
      VNum:=Round_Up(TotalReserved-(Variance+DiscSetl),2);
  end;

  If ((RAutoDisc) and (DNum<>0.0)) or ((RAutoVar) and (VNum<>0.0)) then
  With ExLocal do
  Begin
    
    If (LId.FolioRef=LInv.FolioNum) then
    With LId do
    Begin
      Loop:=BOff;

      Currency:=0;
      CXRate:=SyssCurr.Currencies[Currency].CRates;
      SetTriRec(Currency,UseORate,CurrTriR);


      Repeat
        Ok2Store:=BOff;

        If (Not Loop) and (DNum<>0.0) and (RAutoDisc) then
        Begin
          LId.NomCode:=Syss.NomCtrlCodes[SDiscNom(IdDocHed)];
          LId.NetValue:=DNum;
          Ok2Store:=BOn;
        end
        else
          If (Loop) and (VNum<>0.0) and (RAutoVar) then
          Begin
            LId.NomCode:=Syss.NomCtrlCodes[CurrVar];
            LId.NetValue:=VNum;
            Ok2Store:=BOn;
          end;


        If (Ok2Store) then
        Begin
          Inc(LInv.ILineCount);

          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

          Report_BError(Fnum,Status);

          If (StatusOk) then
          Begin
            UpdateRecBal(LInv,NomCode,NetValue,0.0,CXRate,LId.Currency,UseORate,1);
          end;
        end;

        Loop:=Not Loop;

      Until (Not Loop);
    end
    else
      ShowMessage('Automatic lines could not be generated for Variance, or Settlement Discount'+#13+
                  'as no other lines exist');

  end;
end;




procedure TRecepForm.StoreRecep(Fnum,
                                KeyPAth    :  Integer);


Var
  COk  :  Boolean;
  TmpInv
       :  InvRec;
  KeyS :  Str255;

  MbRet:  Word;

  UOR,
  Mode :  Byte;

  Rnum,
  Dnum :  Double;

  COwnSet,
  ResOrFull,
  ProRataVar :  Real;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState: Boolean;
  CursorState: TCursor;

Begin
  KeyS:='';

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState := OkR1Btn.Enabled;
  CursorState := Cursor;

  OkR1Btn.Enabled := False;
  try

    Form2Recep;

    COwnSet:=0; UOR:=0;

    ResOrFull:=0;  ProRataVar:=0;

    AutoStore:=BOff;

    With ExLocal,LInv do
    Begin
      If not LViewOnly and (AutoBal) and (Round_Up(PRequired(BOn,LInv),2)<>0.00) then
      Begin
        {$IFDEF MC_On}
          Dnum:=Round_Up(TotalReserved-(Variance+PostDiscAm),2);

          If (Dnum<>0) and (Not RAutoVar) then
            mbRet:=MessageDlg('There is '+SSymb(0)+Form_Real(Dnum,0,2)+' of Variance available on this Transaction.'+#13+#13+
                              'Do you wish to finish this Transaction without taking the Variance?',mtConfirmation,[mbYes,mbNo],0)
          else
            mbRet:=mrYes;

        {$ELSE}

          mbRet:=mrYes;

        {$ENDIF}

        If (mbRet=mrYes) then
        Begin
          AutoStore:=BOn;
          AddR1BtnClick(AddR1Btn);
        end;

        Exit;
      end;

      {$IFDEF CU} {* Call any pre store hooks here *}

          LNeedRefs:=(Not ForceStore) and (Not LastEdit); {If we enter hook with no folio assigned, let hook assign them}

          GenHooks(2000,1,ExLocal);

          If (LNeedRefs) then
            ForceStore:=LSetRefs;

          {v5.50 Refresh list so any customisation inserted lines are visible}
          PayCtrl.MULCtrlO.PageUpDn(0,BOn);
      {$ENDIF}

      COk:=CheckCompleted(LastEdit);


      If (COk) then
      Begin
        if not LViewOnly then
        begin
          AutoGenLines(IDetailF,IdFolioK);


          DueDate:=TransDate;
        end;

        OpName:=EntryRec^.LogIn;
        Cursor:=crHourGlass;


        CheckYRef(LInv);  {* To reset index on blank *}

        If (LastEdit) then
        Begin
          If (Not TransactionViewOnly) then
          Begin

            if not LViewOnly then
            begin
              OrigRates[BOn]:=CXRate[BOn];


              Set_DocAlcStat(LInv);  {* Set Allocation Status *}
            end;

            If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
            Begin

              TmpInv:=LInv;

              LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

              Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

              LInv:=TmpInv;

            end;

            Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

            //PR: 22/11/2011 Add audit note
            if Status = 0 then
              TAuditNote.WriteAuditNote(anTransaction, anEdit, ExLocal);

          end; {Don't store if view only}
        end
        else
        Begin {* Add new record *}

          With GlobalAllocRec^[SalesorPurch(InvDocHed)] do
          Begin

            Settled:=Round_Up((ConvCurrItotal(LInv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst)-
                              (Round_up(LUnallocated-(PostDiscAm*DocCnst[InvDocHed]),2)),2);

            {* Subtraction of variance & rounding of Fullunaloc added here 20/11/93, as otherwise any
               receipt where variance taken, was showing the variance amount as OS when viewing the ledger
               in its own currency *}

            {* 02/03/94 New FullOwnUnalloc added as problems were identified with Day rate own currency settled,
               As each document was at a different rate the calculation for own currency used a consolidated
               equivalent coverted back to its own currency using the documents own rate, which invariably would
               be different from the reciept it was being allocated against. FullOwnUnalloc was added to keep the
               sterling equivalent at the current day rate which ensures parity on both sides. The Base equivalent
               calculation remains the same. *}


            CurrSettled:=(Itotal(LInv)*DocCnst[InvDocHed]*DocNotCnst);

            If ((TotalReserved=0) and (Round_Up(LFullUnallocated,2)<>0)) then
              ResOrFull:=LFullUnallocated
            else
              ResOrFull:=TotalReserved;

            If (UseCoDayRate) then
            Begin
              COwnSet:=0;

              {* 24/01/1997 Rounding of comparison needed, as subtraction was failing, and own currency allocations
                            always had an amount o/s in own currency if any variance was taken *}

              Rnum:=Round_Up(Round_Up(ResOrFull,2)-(Variance+PostDiscAm),2);

              {31/12/1998. If the exchange rate on the transaction differed from the global one, any
                         untaken variance was incorrectly expressed in own currency *}

              {If (Rnum<>0.0) then
                COwnSet:=(LFullOwnUnalloc-(Variance+PostDiscAm));  {* DocCnst[InvDocHed] Removed from here as causing a
                                                        problem when allocating own currency to a PPY, if the
                                                        PPY was left O/S from when it was first raised. *}

              If (Rnum<>0) then
              Begin
                COwnSet:=LFullOwnUnalloc;

                If ((Variance+PostDiscAm)<>0.0) then {* Work out what % of available variance has been taken, and prorata that in currency *}
                Begin
                  ProRataVar:=(DivWChk((Variance+PostDiscAm),ResOrFull));

                  COwnSet:=COwnSet-(COwnSet*ProRataVar);
                end;

              end;

              UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

              CurrSettled:=CurrSettled-Round_Up(Conv_TCurr(COwnSet,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOn),2);
            end
            else
            Begin
              COwnSet:=0.0;


              Rnum:=Round_Up(Round_Up(ResOrFull,2)-(Variance+PostDiscAm),2);

              If (Rnum<>0.0) then
                COwnSet:=(LFullOwnUnalloc-(Variance+PostDiscAm));
                                                      {* ResOrFull replaced by FullOwnUnalloc as otherwise leaving
                                                         an SRC or PPY partialy unallocated without taking variance
                                                         would use the sterling unallocated as the figure for calculating
                                                         Own currency O/S. If an invoice with VAT at a day rate is
                                                         involved this would be incorrect *}
              UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

              CurrSettled:=CurrSettled-Round_Up(Conv_TCurr(COwnSet,XRate(CXRate,BOff,Currency),Currency,UOR,BOn),2);
            end;
          end; {With..}

          {If (BaseTotalOS(LInv)=0) then
            CXRate:=SyssCurr.Currencies[Currency].CRates; Removed v4.20 as overwrites any edit currency?}

          VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;

          {* Preserve original Co. Rate *}

          OrigRates:=SyssCurr.Currencies[Currency].CRates;

          SetTriRec(Syss.VATCurr,UseORate,VATTriR);
          SetTriRec(Currency,UseORate,OrigTriR);


          If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) and (Settled<>0) then  {* Cash Accounting set VATdate to Current
                                                                                 VATPeriod only if some of it has been settled *}
          Begin

            // VATPostDate:=SyssVAT.VATRates.CurrPeriod;

            VATPostDate:=CalcVATDate(TransDate)  {v5.71. CA Allows jump to future period, set from period of self}
          
            {UntilDate:=Today;}

          end;

          If (NomAuto) then
          Begin
            If (BaseTotalOS(LInv)=0) then {* Set as allocated today *}
              UntilDate:=Today;

            Set_DocAlcStat(LInv);  {* Set Allocation Status *}
          end;


          If (Not ForceStore) then
          Begin
            If (NomAuto) then
              SetNextDocNos(LInv,BOn)
            else
              SetNextAutoDocNos(LInv,BOn);
          end;

          If (Not InvStored) then
          begin
            { CJS - 2013-10-25 - MRD2.6.06 - Transaction Originator }
            TransactionOriginator.SetOriginator(LInv);

            Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
          end
          else
            Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

          //PR: 22/11/2011 Add audit note
          if Status = 0 then
            TAuditNote.WriteAuditNote(anTransaction, anCreate, ExLocal);

          CanDelete:=BOn;

          ResetGlobAlloc(SalesorPurch(DocHed));

          InSRC[SalesOrPurch(DocHed)]:=BOff;

        end;

        If (Not LViewOnly) then
          Report_BError(Fnum,Status);

        If (StatusOk) and (Not LViewOnly) then
        Begin
          If (Not LastEdit) then {* Get record, as if daybook empty, getpos was failing *}
            LGetMainRecPosKey(Fnum,InvOurRefK,LInv.OurRef);

          LGetRecAddr(Fnum);  {* Refresh record address *}

          If (StatusOk) then
          Begin

            Send_UpdateList(LastEdit,RecordPage);

          end;

          If (Not Syss.UpBalOnPost) and (NomAuto) then
            UpdateCustBal(LastInv,LInv);


          If (LastEdit) then
            Check_DocChanges(LastInv,LInv);  {* Update all lines with any changes *}


        end;

        If (LastEdit) then
          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

        SetRecepStore(BOff,BOff);

        { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
        Cursor := CursorState;


        If (LastEdit) then
          Delete_DocEditNow(FolioNum);

        InvStored:=BOn;

        LastValueObj.UpdateAllLastValues(Self);

        SendToObjectCC(LInv.CustCode,1);

        {$IFDEF CU} {* Call any post store hooks here *}

            GenHooks(2000,170,ExLocal);


        {$ENDIF}

        If (RunCredStatus) then {Delay running of credit status until here to min disruption}
        Begin
          {$IFDEF Post}
            AddChkCAlloc2Thread(Self.Owner,ExLocal.LCust.CustCode);
          {$ENDIF}
        end;

        Close;

        Exit;

      end {* If ok2 store (}
      else
      Begin

        {ChangePage(0);}

        SetFieldFocus;

      end;


    end; {With..}

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  finally
    Cursor := CursorState;
    OkR1Btn.Enabled := ButtonState;
  end;

end;



procedure TRecepForm.EditAccount(Edit,
                                 AutoOn,
                                 ViewOnly   :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;


    If (Not Edit) then
      ResetGlobAlloc(SalesorPurch(DocHed));


    ShowLink(Edit,ViewOnly);

    ProcessRecep(InvF,CurrKeyPath^[InvF],LastEdit,AutoOn);

    //PR: 08/10/2013 MRD 1.1.19 Set WasConsumer appropriately for a/c type
    WasConsumer := IsConsumer(LCust);
  end;
end;




procedure TRecepForm.R1AddrFDblClick(Sender: TObject);

Var
  TmpBo  :  Boolean;

begin
  With ExLocal.LInv do
    TmpBo:=SalesOrPurch(InvDocHed);


  With R1AccF do //PR: 03/12/2013 ABSEXCH-14818 Change to use acount code from Cust record rather than Text from R1AccF edit
   If (CheckKey(FullCustCode(ExLocal.LCust.CustCode),ExLocal.LCust.CustCode,CustKeyLen,BOff)) then
  Begin
    If (Not MatchOwner('CustRec3',Self.Owner)) then
    Begin

      If (DispCust=nil) then
        DispCust:=TFCustDisplay.Create(Self);

      try

        ExLocal.AssignToGlobal(CustF);

        With DispCust do
          Display_Account(IsACust(ExLocal.LCust.CustSupp),10*Ord(InSRC[TmpBo]),ExLocal.LInv);

      except

        DispCust.Free;

      end;
    end
    else
      Send_UpdateList(BOff,10);
  end
  else
    R1AccFExit(R1AccF);

end;

procedure TRecepForm.SetNewFolio;

Begin

  With ExLocal,LInv do
  If (Not ForceStore) and (Not LastEdit) and (InAddEdit) and (Not LViewOnly) then {* Document commits to invoice number here *}
  Begin
    ForceStore:=BOn;


    If (NomAuto) then
      SetNextDocNos(LInv,BOn)
    else
      SetNextAutoDocNos(LInv,BOn);
    {* Set new list search *}

    R1ORefF.Text:=Pr_OurRef(LInv);
    
    RefreshList(BOff,BOff);
  end;
end;


Function TRecepForm.CalcBalValue  :  Double;

Var
  UOR   :  Byte;

Begin
  With ExLocal,LInv do
  Begin
    UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

    Result:=Conv_TCurr(PRequired((Round_Up(PRequired(BOff,LInv),2)=0),LInv),XRate(CXRate,BOff,Currency),Currency,UOR,BOn);
  end;
end;


procedure TRecepForm.AddR1BtnClick(Sender: TObject);

Var
  SBNom   :  LongInt;

  SBVal   :  Double;

begin
  SBNom:=0;
  SBVal:=0;

  Case Current_Page of

    0  :  If ((Sender Is TButton) or (Sender Is TMenuItem)) then
           Begin

             If (Not ExLocal.LastEdit) then
               SetNewFolio;

             If (PayCtrl<>nil) then
               With ExLocal,PayCtrl do
                 If  ((MULCtrlO.ValidLine) or ((Sender=AddR1Btn) or (Sender=Add1))) then
                 Begin
                 {* Reset folio, in case it changes *}

                 If (LInv.FolioNum <> GetFolio) then
                 Begin
                   RefreshList(LInv.FolioNum);
                 end;

                 InvBtnList.SetEnabBtn(BOff);

                 If (AutoBal) and (CheckExsists(Strip('R',[#0],FullNomKey(ABalNom)),NomF,NomCodeK)) and (Round_Up(PRequired(BOn,LInv),2)<>0.0) then
                 Begin
                   SBNom:=ABalNom;
                   SBVal:=CalcBalValue;
                 end;

                 //PR: 16/11/2017 ABSEXCH-19451 Allow edit posted transaction
                 if FAllowPostedEdit then
                   PayCtrl.EnableEditPostedFields;

                 PayCtrl.AddEditPay(((Sender=EditR1Btn) or (Sender=Edit1)),LViewOnly,SBNom,SBVal,LInv);
               end;

           end;

    1  : {$IFDEF NP}
           Begin

             If (Not ExLocal.LastEdit) then
               SetNewFolio;

             If (NotesCtrl<>nil) then
             With ExLocal,NotesCtrl do
             Begin
               {* Reset folio, in case it changes *}

               If (FullNomKey(LInv.FolioNum) <> GetFolio) then
               Begin
                 RefreshList(FullNomkey(LInv.FolioNum),GetNType);
               end;

               NotesCtrl.AddEditNote((Sender=EditR1Btn),(Sender=InsR1Btn));
             end;

           end;
         {$ELSE}
           ;
         {$ENDIF}
  end; {Case..}

end;

procedure TRecepForm.DelR1BtnClick(Sender: TObject);
begin
  Case Current_Page of
    0  :  If (PayCtrl<>nil) then
              PayCtrl.DeletePayLine(ExLocal.LInv);

    1  :  {$IFDEF NP}
            If (NotesCtrl<>nil) then
              NotesCtrl.Delete1Click(Sender);

          {$ELSE}
             ;
          {$ENDIF}
  end; {Case..}
end;

procedure TRecepForm.SwiR1BtnClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  {$IFDEF NP}

    If (NotesCtrl<>nil) then
    With NotesCtrl do
    Begin

      If (Not MULCtrlO.InListFind) then
        begin
          //PR: 22/11/2011 v6.9 Added submenu to handle Audit History Notes
          ListPoint.X:=1;
          ListPoint.Y:=1;

          ListPoint := SwiR1Btn.ClientToScreen(ListPoint);

          PMenu_Notes.Popup(ListPoint.X, ListPoint.Y);
        end;
    end;
  {$ENDIF}

end;

procedure TRecepForm.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    N3.Tag:=99;

    PopUp(X,Y);
  end;


end;


procedure TRecepForm.PopupMenu1Popup(Sender: TObject);
Var
  n  :  Integer;
  MousePos: TPoint;
begin
  StoreCoordFlg.Checked:=StoreCoord;

  // CJS: 21/12/2010 - For the Properties option on the pop-up menu we need to
  // know if we are over a list, so that the correct Properties editor is
  // displayed (the list properties are separate from the properties for the
  // other controls on the form).
  if (Sender is TPopupMenu) then
    with Sender as TPopupMenu do
    begin
      MousePos := ScreenToClient(TPopupMenu(Sender).PopupPoint);
      FPopUpForList := (MousePos.X > R1SBox.Left) and (MousePos.X <= (R1SBox.Left + R1SBox.Width)) and
                      (MousePos.Y > R1SBox.Top)  and (MousePos.Y <= (R1SBox.Top  + R1SBox.Height));
    end;

  With InvBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end; {With..}

end;

function TRecepForm.R1TPerFShowPeriod(Sender: TObject;
  const EPr: Byte): string;
begin
  Result:=PPr_Pr(EPr);
end;


procedure TRecepForm.OkR1BtnClick(Sender: TObject);

begin

  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    begin
      // Move focus to OK button to force OnExit validation/formatting to kick in
      If OkR1Btn.CanFocus Then
        OkR1Btn.SetFocus;

      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = OkR1Btn) Then
      begin
        StoreRecep(InvF,SKeypath);
      end;
    end
    else
      If (ModalResult=mrCancel) then
      Begin
        ClsR1Btn.Click;

        Exit;
      end;
  end; {With..}
end;


procedure TRecepForm.R1TDateFExit(Sender: TObject);
begin
  With ExLocal,LInv,R1TDateF do
    If {(DateModified) and} (Not LastEdit) and (ValidDate(DateValue)) then
    Begin
      TransDate:=DateValue;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
      With R1TPerF do
      Begin
        Date2Pr(TransDate,AcPr,AcYr,@ExLocal);

        InitPeriod(AcPr,AcYr,BOn,BOn);
      end;

    end;

end;


procedure TRecepForm.R1AccFEnter(Sender: TObject);
Var
  AccEdit  :  Boolean;

begin
  With ExLocal,LInv,GlobalAllocRec^[SalesorPurch(InvDocHed)] do
    AccEdit:=(((LastEdit) or (Not NomAuto) or (Round(LUnallocated)=Round(InvNetVal*DocCnst[InvDocHed]*DocNotCnst))) and (Not LViewOnly));

  If (Sender is TMaskEdit) then
    TMaskEdit(Sender).ReadOnly:=Not AccEdit;
end;


procedure TRecepForm.R1AccFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>ClsR1Btn) and (ActiveControl<>CanR1Btn)  then
    Begin
        //PR: 08/10/2013 MRD 1.1.19 Set consumer prefix if we previously had a consumer
        if WasConsumer then
        begin
          if Copy(FoundCode, 1, 1) <> CONSUMER_PREFIX then
            FoundCode := CONSUMER_PREFIX + FoundCode;
        end;

      {$IFDEF CU} {* Call hooks here *}

        FoundCode:=TextExitHook(2000,6,FoundCode,ExLocal);

      {$ENDIF}


      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,IsACust(ExLocal.LInv.CustSupp),0));

      {$IFDEF JC}
        {$IFDEF PF_On}
           If (FoundOK) and (JBCostOn) and (DocHed=PPY) then
             FoundOk:=Not Cert_Expired(FoundCode,Today,BOn,BOn);
        {$ENDIF}
      {$ENDIF}

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(CustF);

        CustToMemo(LCust,R1AddrF,0);

      end;


      If (FoundOk) then
      Begin

        StopPageChange:=BOff;

        StillEdit:=BOff;

        //PR: 08/10/2013 MRD 1.1.19 Set contents of a/c code field appropriately for trader type
        if IsConsumer(ExLocal.LCust) then
        begin
          Text := Trim(ExLocal.LCust.acLongACCode);
          WasConsumer := True; //Set consumer indicator
        end
        else
        begin
          Text:=FoundCode;
          WasConsumer := False; //Set consumer indicator
        end;

        SendToObjectCC(FoundCode,0);
        
        {$IFDEF MC_On}

          If (Not R1CurrF.ReadOnly) then
          With ExLocal,LInv do
          Begin
            Currency:=LCust.Currency;

            
            If (Currency>0) then
              R1CurrF.ItemIndex:=Pred(Currency);

            R1CurrF.Modified:=BOn;
            R1CurrFExit(Sender);
          end;

        {$ENDIF}

          DMDCNomF.Text:=Form_BInt(ExLocal.LCust.DefCtrlNom,0);

          SetCtrlNomStat;
          
        {* Weird bug when calling up a list caused the Enter/Exit methods
             of the next field not to be called. This fix sets the focus to the next field, and then
             sends a false move to previous control message ... *}

        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        StopPageChange:=BOn;

        SetFocus;
      end; {If not found..}
    end;
    {$IFDEF CU} {* Call notification hook regardless of edit state *}

      GenHooks(2000,101,ExLocal);

    {$ENDIF}
  end; {with..}
end;




procedure TRecepForm.DMDCNomFExit(Sender: TObject);
Var
  FoundCode  :  Str20;
  FoundNom   :  LongInt;

  FoundOk,
  AltMod     :  Boolean;

begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundNom:=0;

    FoundCode:=Text;

    If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self,FoundCode,FoundNom,78));

      If (FoundOk) then
      Begin
        StillEdit:=BOff;

        StopPageChange:=BOff;

        Text:=Form_Int(FoundNom,0);

        {* Weird bug when calling up a list caused the Enter/Exit methods
             of the next field not to be called. This fix sets the focus to the next field, and then
             sends a false move to previous control message ... *}

        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        StopPageChange:=BOn;
        SetFocus;
      end; {If not found..}
    end;
  end; {with..}
end;



procedure TRecepForm.Warn_Allocated;

Var
  UOR  :  Byte;

Begin
  With ExLocal,LInv,GlobalAllocRec^[SalesorPurch(InvDocHed)] do
  Begin
    UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

    If (Round_Up(LFullUnallocated,2)<>(Round_Up(Conv_TCurr(InvNetVal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff)
                           *DocCnst[InvdocHed]*DocNotCnst,2))) and (Not LastEdit) then
    Begin
      CustomDlg(Self,'WARNING!','Already Allocated',
                               'This '+DocNames[InvdocHed]+' has been allocated.'+#13+
                               'Changing its value can leave the ledger out of balance.'+#13+#13+
                               'Please unallocate any matched transactions first.',
                               mtInformation,
                               [mbOk]);



    end;
  end;
end;


procedure TRecepForm.R1CurrFExit(Sender: TObject);
begin
  {$IFDEF MC_On}
     With ExLocal,LInv,R1CurrF do
     If (Modified) and (OrigValue<>Text) then
     Begin
       Warn_Allocated;

       Currency:=Succ(R1CurrF.ItemIndex);

       CXrate:=SyssCurr.Currencies[Currency].CRates;
       CXrate[BOff]:=0;

       VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;

       SetTriRec(Currency,UseORate,CurrTriR);

       SetTriRec(Syss.VATCurr,UseORate,VATTriR);

       R1XRateF.Value:=XRate(CXRate,BOff,Currency);

       If (Not LViewOnly) then
         R1XRateF.ReadOnly:=(SyssGCuR^.GhostRates.TriEuro[Currency]<>0) or (Currency=1) or (Not CanEditTriEuro(Currency));

       R1BaseFEnter(Sender);

       OutRecepTotals;

     end;
  {$ENDIF}
end;

procedure TRecepForm.R1BaseFEnter(Sender: TObject);
Var
  UOR  :  Byte;

begin
  With ExLocal.LInv do
  Begin
    Form2Recep;
    UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

    R1BaseF.Value:=Conv_TCurr(InvNetVal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
  end;
end;


procedure TRecepForm.R1RValFExit(Sender: TObject);

Var
  UOR  :  Byte;

begin
  Form2Recep;


  With ExLocal,LInv do
  If (Not LViewOnly) then
  Begin

    UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

    RRnum:=Conv_TCurr(InvNetVal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

    UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

    OldFullOwn:=Conv_TCurr(InvNetVal,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff);


    {$IFDEF MC_On}

      R1BaseFEnter(Sender);

    {$ENDIF}

    If (Not LastEdit) then
      UpdateAllBal((RRnum-OldRnum)*DocCnst[InvDocHed]*DocNotCnst,
                   (RRnum-FullOldRnum)*DocCnst[InvDocHed]*DocNotCnst,
                   (OldFullOwn-OwnOldRnum)*DocCnst[InvDocHed]*DocNotCnst,BOff,InvDocHed);


    ReCalcVariance:=(OldRnum<>RRnum) and (TotalReserved<>0);

    OldRnum:=RRnum;

    FullOldRnum:=RRnum;

    OwnOldRnum:=OldFullOwn;

    OutRecepTotals;

    If (R1RValF.FloatModified) then
      Warn_Allocated;


    {.$IFNDEF MC_On}

      Link2Ledger(Sender);

    {.$ENDIF}

  end; {with..}

end;


procedure TRecepForm.RetFromLedger;

Var
  UOR  :  Byte;

Begin
  Dec(POPStack);

  With ExLocal,LInv,GlobalAllocRec^[SalesorPurch(InvDocHed)] do
  Begin

    If (InvNetVal=0) and (Not LastEdit) then

    Begin

      {$IFDEF Mc_On} {* Use FullUnallocated Amount to auto suggest *}

        UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

        InvNetVal:=Round_Up(Conv_TCurr(LFullUnallocated,XRate(CXRate,BOff,Currency),Currency,UOR,BOn)-LFullDisc,2)*DocCnst[InvDocHed];

        UpdateAllBal(((LFullUnallocated-LFullDisc)*DocNotCnst),((LFullUnallocated-LFullDisc)*DocNotCnst),
                      (LFullOwnUnalloc*DocNotCnst),BOff,InvDocHed);

      {$ELSE} {* Use normal unallocated, as SC ver allows part allocation *}

        UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

        InvNetVal:=Round_Up(Conv_TCurr(LUnallocated,XRate(CXRate,BOff,Currency),Currency,UOR,BOn)-LFullDisc,2)*DocCnst[InvDocHed];

        UpdateAllBal(((LUnallocated-LFullDisc)*DocNotCnst),((LFullUnallocated-LFullDisc)*DocNotCnst),(LFullOwnUnalloc*DocNotCnst),BOff,InvdocHed);


      {$ENDIF}

      TotalReserved:=LFullDisc;

      FullOldRnum:=LFullUnallocated*DocCnst[InvDocHed];

      UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

      OldRnum:=Conv_TCurr(InvNetVal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

      OwnOldRnum:=LFullOwnUnalloc*DocCnst[InvDocHed];

      SetRecepFields;

    end;


    If (Not LastEdit) and ((OldUnallocated<>LUnallocated) or (RecalcVariance)) then
    Begin
      TotalReserved:=LUnallocated*DocCnst[InvDocHed];
      ReCalcVariance:=BOff;
    end;

    If (Not LastEdit) and (OldFullDisc<>LFullDisc) then
      DiscSetl:=LFullDisc*DocCnst[InvDocHed];

  end;

  OutRecepTotals;
end;



procedure TRecepForm.Link2Ledger(Sender  :  TObject);


Begin
  Form2Recep;

  With ExLocal,LInv,GlobalAllocRec^[SalesorPurch(InvDocHed)] do
  Begin
    If (POPStack<=0) then
    Begin
      OldUnallocated:=LUnallocated;
      OldFullDisc:=LFullDisc;
    end;

    SetNewFolio;

    If (Not LastEdit) and (NomAuto) then
    Begin

      LRemitDoc:=OurRef;

      LLastMDoc:=InvDocHed;

      LCADate:=Transdate;

      AssignToGlobal(InvF);

      R1AddrFDblClick(Sender);

      Inc(POPStack);
    end;
  end; {With..}

end;


procedure TRecepForm.R1XRateFEnter(Sender: TObject);
begin
  {$IFDEF CU} {* Call hooks here *}

    If (Not R1XRateF.ReadOnly) and (Sender=R1XRateF) then
    Begin
      R1XRateF.Value:=ValueExitHook(2000,7,R1XRateF.Value,ExLocal);
    end;

  {$ENDIF}

end;

procedure TRecepForm.R1XRateFExit(Sender: TObject);
begin
  If (R1XRateF.FloatModified) then
    Warn_Allocated;

   R1BaseFEnter(Sender);

  {$IFDEF MC_On}

    {Link2Ledger(Sender);}

  {$ENDIF}
end;


procedure TRecepForm.THUD1FEntHookEvent(Sender: TObject);
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
          If (Sender=THUD1F) then
          Begin
            ExLocal.LInv.DocUser1:=Text;
            CUUDEvent:=1;
          end
          else
            If (Sender=THUD2F) then
            Begin
              ExLocal.LInv.DocUser2:=Text;
              CUUDEvent:=2;
            end
            else
              If (Sender=THUD3F) then
              Begin
                ExLocal.LInv.DocUser3:=Text;
                CUUDEvent:=3;
              end
              else
                If (Sender=THUD4F) then
                Begin
                  ExLocal.LInv.DocUser4:=Text;
                  CUUDEvent:=4;
                end
                //GS 14/10/2011 ABSEXCH-11706: create branches for the new UDFs
                //there is a 60 offset; event values are adjucted accordingly
                else
                  If (Sender=THUD5F) then
                  Begin
                    ExLocal.LInv.DocUser5:=Text;
                    CUUDEvent:=(211 - 60);
                  end
                  else
                    If (Sender=THUD6F) then
                    Begin
                      ExLocal.LInv.DocUser6:=Text;
                      CUUDEvent:=(212 - 60);
                    end
                    else
                      If (Sender=THUD7F) then
                      Begin
                        ExLocal.LInv.DocUser7:=Text;
                        CUUDEvent:=(213 - 60);
                      end
                      else
                        If (Sender=THUD8F) then
                        Begin
                          ExLocal.LInv.DocUser8:=Text;
                          CUUDEvent:=(214 - 60);
                        end
                        else
                          If (Sender=THUD9F) then
                          Begin
                            ExLocal.LInv.DocUser9:=Text;
                            CUUDEvent:=(215 - 60);
                          end
                          else
                            If (Sender=THUD10F) then
                            Begin
                              ExLocal.LInv.DocUser10:=Text;
                              CUUDEvent:=(216 - 60);
                            end
                            else
                              // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
                              If (Sender=THUD11F) then
                              Begin
                                ExLocal.LInv.thUserField11:=Text;
                                CUUDEvent:=(217 - 60);
                              end
                              else
                                If (Sender=THUD12F) then
                                Begin
                                  ExLocal.LInv.thUserField12:=Text;
                                  CUUDEvent:=(218 - 60);
                                end
                else
                  If (Sender=R1YRefF) then
                  Begin
                    ExLocal.LInv.YourRef:=Text;
                    CUUDEvent:=120;
                  end;

          Result:=IntExitHook(2000,60+CUUDEvent,-1,ExLocal);

          If (Result=0) then
            SetFocus
          else
          With ExLocal do
          If (Result=1) then
          Begin
            Case CUUDEvent of
              1  :  Text:=LInv.DocUser1;
              2  :  Text:=LInv.DocUser2;
              3  :  Text:=LInv.DocUser3;
              4  :  Text:=LInv.DocUser4;
              //GS 14/10/2011 ABSEXCH-11706: put customisation object vals into UDFs
              (211 - 60) :  Text:=LInv.DocUser5;
              (212 - 60) :  Text:=LInv.DocUser6;
              (213 - 60) :  Text:=LInv.DocUser7;
              (214 - 60) :  Text:=LInv.DocUser8;
              (215 - 60) :  Text:=LInv.DocUser9;
              (216 - 60) :  Text:=LInv.DocUser10;
              // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
              (217 - 60) :  Text:=LInv.thUserField11;
              (218 - 60) :  Text:=LInv.thUserField12;

              120  :  Text:=LInv.YourRef;
            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;


procedure TRecepForm.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>CanR1Btn) and (ActiveControl<>ClsR1Btn) then
    Text8pt(Sender).ExecuteHookMsg;
end;


procedure TRecepForm.PropFlgClick(Sender: TObject);
Begin
{
  If (N3.Tag=99) and (PayCtrl<>nil) then
  Begin
    N3.Tag:=0;
    PayCtrl.SetFormProperties;
  end
  else
    SetFormProperties(BOff);
}
  if FPopupForList then
  begin
    case Current_Page of
    {$IFDEF RT_On}
      0  :  If (PayCtrl<>nil) then
            begin
              PayCtrl.SetFormProperties;
              FColorsChanged := True;
              NeedCUpdate := True;
            end;
    {$ELSE}

      0  :  ;

    {$ENDIF}
      1  :  begin
              NotesCtrl.SetFormProperties;
              FColorsChanged := True;
              NeedCUpdate := True;
            end
    end;
  end
  else
  begin
    // CJS: 21/12/2010
    if Assigned(FSettings) then
    begin
      FSettings.Edit(self, R1YRefF);
      FColorsChanged := True;
      NeedCUpdate := True;
      // Reset the colours for read-only controls.
      ForceReadOnlyColors;
    end;
  end; {Case..}

end;




procedure TRecepForm.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;


procedure TRecepForm.DefR1BtnClick(Sender: TObject);
Var
  mrResult  :  Word;

  ISCtrl    :  TBankDefault;

begin

  With ExLocal,LInv do
  Begin
    ISCtrl:=TBankDefault.Create(Self);

    try

      With ISCtrl do
      Begin
        ISNomCode:=ABalNom;
        UseNomCode:=AutoBal;
        UseAutoVar:=RAutoVar;
        UseAutoDisc:=RAutoDisc;

        IsSRCBank:=DocHed In SalesSplit;

        With R1AccF do
          mrResult:=InitIS(LViewOnly,Color,Font);

        If (mrResult=mrOk) then
        Begin
          ABalNom:=ISNomCode;
          AutoBal:=UseNomCode;
          RAutoVar:=UseAutoVar;
          RAutoDisc:=UseAutoDisc;
        end;
      end;

    finally

      ISCtrl.Free;

    end; {Try..}

  end; {with..}

end;




procedure TRecepForm.StatR1BtnClick(Sender: TObject);
begin
  PayCtrl.CtrlView;
end;


procedure TRecepForm.chkI1BtnClick(Sender: TObject);

Var
  LastTotal  :  Double;

begin
  With ExLocal,LInv do
  Begin
    LastTotal:=TotalInvoiced+Variance;

    Check_OtherDocs(LInv,6);

    ForceStore:=(ForceStore or (LastTotal<>(TotalInvoiced+Variance)));
  end;

  OutRecepTotals;
end;




procedure TRecepForm.LnkR1BtnClick(Sender: TObject);
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
      LetterForm.LoadLettersFor (FullNomKey(ExLocal.LInv.FolioNum),
                                 ExLocal.LInv.OurRef,
                                 Copy(ExLocal.LInv.OurRef,1,3)+Copy(ExLocal.LInv.OurRef,5,5),
                                 LetterDocCode,
                                 @ExLocal.LCust, Nil, @ExLocal.LInv, Nil, Nil);
    Except
     LetterActive := BOff;
     LetterForm.Free;
    End;
  {$ENDIF}
end;



procedure TRecepForm.PayR1BtnClick(Sender: TObject);

Var
  mrResult  :  Word;

begin
  With ExLocal,LInv do
  Begin
    DelACtrl:=TDelAddrPop.Create(Self);

    try

      With DelACtrl do
      Begin
        PopAddr:=DAddr;

        // MH 29/01/2015 v7.1 ABSEXCH-16089: Display Credit Card Labels for Order Payments SRC's paid by Credit Card
        If (thOrderPaymentElement In OrderPayment_PaymentAndRefundSet) And ((thOrderPaymentFlags And thopfCreditCardPaymentTaken) = thopfCreditCardPaymentTaken) Then
          DelACtrl.DisplayMode := dadmReceiptCreditCard
        Else
          DelACtrl.DisplayMode := dadmReceiptPayDetails;

        With R1YRefF do
          //PR: 13/12/2017 ABSEXCH-19451 Allow posted trans to be edited
          mrResult:=InitDelAddr(LViewOnly and not FAllowPostedEdit,Color,Font);

        If (mrResult=mrOk) then
          DAddr:=POPAddr;

      end;
    finally

      DelACtrl.Free;

    end; {Try..}

  end; {with..}

end;

procedure TRecepForm.SetHelpContextIDsForPage(bInc : boolean); // NF: 12/04/06
const
  TAB_MAIN = 0;
  TAB_NOTES = 1;
var
  iOffSet : integer;
  bPurchase : boolean;

  procedure IncHelpContextIDs(iInc : integer; TheControl : TControl);
  var
    iPos : integer;

    procedure SetContextID(AControl : TControl; iNewID : integer);
    begin{SetContextID}
      // Exceptions
      if AControl is TTabSheet then exit;
      if AControl.Name = 'OkR1Btn' then exit;
      if AControl.Name = 'CanR1Btn' then exit;
      if AControl.Name = 'ClsR1Btn' then exit;
      if AControl.Name = 'LnkR1Btn' then exit;

      // Set Context ID
      if AControl.HelpContext > 0
      then AControl.HelpContext := iNewID;
    end;{SetContextID}

  begin{IncHelpContextIDs}
    // Inc the control's Context ID
    SetContextID(TheControl, TheControl.HelpContext + iInc);

    // Inc the Context IDs of the controls in the control
    For iPos := 0 to Thecontrol.ComponentCount -1 do
    begin
      if Thecontrol.Components[iPos] is TControl
      and (not (Thecontrol.Components[iPos] is TForm))  // NF: 08/05/06 - Fixed so that it does not itterate through other Forms
      then IncHelpContextIDs(iInc, TControl(TheControl.Components[iPos]));
    end;{for}
  end;{IncHelpContextIDs}

begin
  {$IFDEF LTE}
    if (not bHelpContextInc) and (not bInc) then exit;

    bPurchase := not (DocHed in [SIN,SRC,SCR,SJI,SJC,SRF,SRI,SQU,SOR,SDN,SBT,SDG,SDT,SKF,SRN]);
    if bPurchase then iOffSet := 0
    else begin
      if bInc then
      begin
        iOffSet := 5000;
        bHelpContextInc := TRUE;
      end else
      begin
        iOffSet := -5000;
        bHelpContextInc := FALSE;
      end;{if}
    end;{if}

    // Set Correct Tab IDs
    if (bInc) then
    begin
      case PageControl1.ActivePage.PageIndex of
        TAB_MAIN : begin
          PageControl1.ActivePage.HelpContext := iOffSet + 236;
        end;
        TAB_NOTES : begin
          PageControl1.ActivePage.HelpContext := iOffSet + 1686;
        end;
      end;{case}

      LnkR1Btn.HelpContext := 81;
    end;{if}

    if (iOffSet <> 0) then IncHelpContextIDs(iOffSet, Self);

    HelpContext := PageControl1.ActivePage.HelpContext;
    PageControl1.HelpContext := PageControl1.ActivePage.HelpContext;

  {$ENDIF}
end;

// MHYR 25/10/07
procedure TRecepForm.R1YrefFChange(Sender: TObject);
begin
  R1YrefF.Hint := R1YrefF.Text;
end;

// CJS: 21/12/2010 - Amendments for new Window Settings system
procedure TRecepForm.ForceReadOnlyColors;
var
  n: Integer;
begin
  for n := 0 to Pred(ComponentCount) do
  begin
    if (Components[n] is TMaskEdit) or
       (Components[n] is TComboBox) or
       (Components[n] is TCurrencyEdit) then
    begin
      if (Components[n].Tag = 0) then
      begin
        TGlobControl(Components[n]).Font.Color := clWindowText;
        TGlobControl(Components[n]).Color := clBtnFace;
      end;
    end;
  end;
end;

procedure TRecepForm.SwitchNoteButtons(Sender: TObject;
  NewMode: TNoteMode);
begin
  //Called when user uses Switch from pop-up menu on Notes form
  AddR1Btn.Enabled := NewMode <> nmAudit;
  EditR1Btn.Enabled := NewMode <> nmAudit;
  InsR1Btn.Enabled := NewMode <> nmAudit;
  DelR1Btn.Enabled := NewMode <> nmAudit;
end;

procedure TRecepForm.MenItem_GeneralClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmGeneral);
end;

procedure TRecepForm.MenItem_DatedClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmDated);
end;

procedure TRecepForm.MenItem_AuditClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmAudit);
end;
//PR: 15/11/2017 ABSEXCH-19451
function TRecepForm.TransactionViewOnly: Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;

procedure TRecepForm.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;

  //YourRef
  R1YRefF.AllowPostedEdit := True;

  //UDFs
  THUD1F.AllowPostedEdit := True;
  THUD2F.AllowPostedEdit := True;
  THUD3F.AllowPostedEdit := True;
  THUD4F.AllowPostedEdit := True;
  THUD5F.AllowPostedEdit := True;
  THUD6F.AllowPostedEdit := True;
  THUD7F.AllowPostedEdit := True;
  THUD8F.AllowPostedEdit := True;
  THUD9F.AllowPostedEdit := True;
  THUD10F.AllowPostedEdit := True;
  THUD11F.AllowPostedEdit := True;
  THUD12F.AllowPostedEdit := True;


  ClsR1Btn.Visible := False;
  ClsR1Btn.Enabled := False;
  OkR1Btn.Top := CanR1Btn.Top + 5;
  CanR1Btn.Top := ClsR1Btn.Top + 5;

  R1BSBox.Top := CanR1Btn.Top + CanR1Btn.Height + 10;
  
end;

//AP 07/12/2017 2018R1 ABSEXCH-19538:Anonymised Transactions > Notification banner is not displayed for SRC, PPY, xBT.
procedure TRecepForm.SetAnonymisationBanner;
begin
  {$IFNDEF EXDLL}
    if FAnonymisationON then
    begin
      if (FListScanningOn and pnlAnonymisationStatus.Visible) or (FSettings.UseDefaults and (not FListScanningOn)) then
        InitSize.Y := Self.ClientHeight
      else
        InitSize.Y := Self.ClientHeight + pnlAnonymisationStatus.Height;
    end
    else
    begin
      if (FListScanningOn and pnlAnonymisationStatus.Visible) or (FSettings.UseDefaults and (not FListScanningOn)) then
        InitSize.Y := Self.ClientHeight - pnlAnonymisationStatus.Height
      else
        InitSize.Y := Self.ClientHeight;
      PagePoint[0].Y := 3;
    end;
    if FListScanningOn then
    begin
      if FAnonymisationON then
        PagePoint[0].Y := 78;
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
      lblAnonStatus.Caption := Format(capAnonymisedStatus, [POutDate(ExLocal.LInv.thAnonymisedDate)]); //update the anonymisation Date
      SetAnonymisationPanel;
    end;
    Self.ClientHeight := InitSize.Y;
    FormResize(nil);
  {$ENDIF EXDLL}
end;

//HV 12/11/2017 ABSEXCH-19549: Anonymised Notification banner in View/Edit Record > Banner not displayed on maximise and then Restore Down.
procedure TRecepForm.SetAnonymisationPanel;
begin
  if  GDPROn and FAnonymisationON then
  begin
    pnlAnonymisationStatus.Left := 0;
    pnlAnonymisationStatus.Top := Self.ClientHeight - (pnlAnonymisationStatus.Height);
    pnlAnonymisationStatus.Width := Self.ClientWidth;
    shpNotifyStatus.Width := pnlAnonymisationStatus.Width - 10;
    shpNotifyStatus.Left := 5;
    //center the label
    lblAnonStatus.Left := Round((pnlAnonymisationStatus.Width - lblAnonStatus.width)/2);
  end;
end;

Initialization

end.
