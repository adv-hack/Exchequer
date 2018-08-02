unit NomTfr2U;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, TEditVal, BorBtns, Mask, ComCtrls,

  GlobVar,VarConst,ExWrap1U,BTSupU1,SupListU,SBSComp, SBSComp2,

  SalTxL1U,

  NomLne2U,

  {$IFDEF NP}
    NoteU,
  {$ENDIF}

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  Menus;



type
  TNTxfrMList  =  Class(TGenList)


    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;


  end;


type
  TNTxfrForm = class(TForm)
    PageControl1: TPageControl;
    RecepPage: TTabSheet;
    NotesPage: TTabSheet;
    TCNScrollBox: TScrollBox;
    TNHedPanel: TSBSPanel;
    NDateLab: TSBSPanel;
    NDescLab: TSBSPanel;
    NUserLab: TSBSPanel;
    NDatePanel: TSBSPanel;
    NDescPanel: TSBSPanel;
    NUserPanel: TSBSPanel;
    TCNListBtnPanel: TSBSPanel;
    N1SBox: TScrollBox;
    N1HedPanel: TSBSPanel;
    N1DLab: TSBSPanel;
    N1NomLab: TSBSPanel;
    N1CrLab: TSBSPanel;
    N1NDLab: TSBSPanel;
    N1DrLab: TSBSPanel;
    N1CCLab: TSBSPanel;
    N1DepLab: TSBSPanel;
    N1DPanel: TSBSPanel;
    N1DrPanel: TSBSPanel;
    N1NomPanel: TSBSPanel;
    N1NDPanel: TSBSPanel;
    N1CrPanel: TSBSPanel;
    N1CCPanel: TSBSPanel;
    N1DepPanel: TSBSPanel;
    N1BtnPanel: TSBSPanel;
    OkN1Btn: TButton;
    CanN1Btn: TButton;
    ClsN1Btn: TButton;
    N1FPanel: TSBSPanel;
    Label817: Label8;
    Label84: Label8;
    Label87: Label8;
    N1BLab: Label8;
    N1OrefF: Text8Pt;
    N1OpoF: Text8Pt;
    N1TDateF: TEditDate;
    N1YRefF: Text8Pt;
    N1SelBalQF: TBorCheck;
    N1BSBox: TScrollBox;
    AddN1Btn: TButton;
    EditN1Btn: TButton;
    DelN1Btn: TButton;
    InsN1Btn: TButton;
    SWiN1Btn: TButton;
    N1SelBalF: Text8Pt;
    N1BaseF: TCurrencyEdit;
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
    Label816: Label8;
    Label81: Label8;
    N1StatLab: Label8;
    N1BtmPanel: TSBSPanel;
    CCPanel: TSBSPanel;
    CCTit: Label8;
    DepTit: Label8;
    CCLab: Label8;
    DepLab: Label8;
    panDrReqd: TSBSPanel;
    panCrReqd: TSBSPanel;
    N1ListBtnPanel: TSBSPanel;
    LnkN1Btn: TButton;
    Links1: TMenuItem;
    N1AutoRevF: TBorCheck;
    chkI1Btn: TButton;
    Check1: TMenuItem;
    TransExtForm1: TSBSExtendedForm;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    Label88: Label8;
    N1TPerF: TEditPeriod;
    Label82: Label8;
    N1YRef2F: Text8Pt;
    N1VCPanel: TSBSPanel;
    N1VCLab: TSBSPanel;
    N1VAmtPanel: TSBSPanel;
    N1VAmtLab: TSBSPanel;
    TabSheet1: TTabSheet;
    SBSPanel53: TSBSPanel;
    SBSPanel54: TSBSPanel;
    I5VATRLab: TLabel;
    Label8: TLabel;
    I5VATLab: TLabel;
    ScrollBox8: TScrollBox;
    I5VR1F: Text8Pt;
    I5VR2F: Text8Pt;
    I5VR3F: Text8Pt;
    I5VR4F: Text8Pt;
    I5VR5F: Text8Pt;
    I5VR6F: Text8Pt;
    I5VR7F: Text8Pt;
    I5VG1F: TCurrencyEdit;
    I5VG2F: TCurrencyEdit;
    I5VG3F: TCurrencyEdit;
    I5VG4F: TCurrencyEdit;
    I5VG5F: TCurrencyEdit;
    I5VG6F: TCurrencyEdit;
    I5VG7F: TCurrencyEdit;
    I5VV1F: TCurrencyEdit;
    I5VV2F: TCurrencyEdit;
    I5VV3F: TCurrencyEdit;
    I5VV4F: TCurrencyEdit;
    I5VV5F: TCurrencyEdit;
    I5VV6F: TCurrencyEdit;
    I5VV7F: TCurrencyEdit;
    I5VR8F: Text8Pt;
    I5VG8F: TCurrencyEdit;
    I5VV8F: TCurrencyEdit;
    I5Vr9F: Text8Pt;
    I5VG9F: TCurrencyEdit;
    I5VV9F: TCurrencyEdit;
    I5Vr10F: Text8Pt;
    I5VG10F: TCurrencyEdit;
    I5VV10F: TCurrencyEdit;
    I5Vr11F: Text8Pt;
    I5VG11F: TCurrencyEdit;
    I5VV11F: TCurrencyEdit;
    I5VR12F: Text8Pt;
    I5VG12F: TCurrencyEdit;
    I5VV12F: TCurrencyEdit;
    I5Vr13F: Text8Pt;
    I5VG13F: TCurrencyEdit;
    I5VV13F: TCurrencyEdit;
    I5Vr14F: Text8Pt;
    I5VG14F: TCurrencyEdit;
    I5VV14F: TCurrencyEdit;
    I5Vr15F: Text8Pt;
    I5VG15F: TCurrencyEdit;
    I5VV15F: TCurrencyEdit;
    I5VV16F: TCurrencyEdit;
    I5VG16F: TCurrencyEdit;
    I5Vr16F: Text8Pt;
    I5Vr17F: Text8Pt;
    I5VG17F: TCurrencyEdit;
    I5VV17F: TCurrencyEdit;
    I5VV18F: TCurrencyEdit;
    I5VG18F: TCurrencyEdit;
    I5Vr18F: Text8Pt;
    I5Vr19F: Text8Pt;
    I5VG19F: TCurrencyEdit;
    I5VV19F: TCurrencyEdit;
    I5Vr20F: Text8Pt;
    I5VG20F: TCurrencyEdit;
    I5VV20F: TCurrencyEdit;
    I5Vr21F: Text8Pt;
    I5VG21F: TCurrencyEdit;
    I5VV21F: TCurrencyEdit;
    SBSPanel1: TSBSPanel;
    N1AcalcVATF: TBorCheck;
    NTIOHedCB: TSBSComboBox;
    VATLab: Label8;
    N1ReconPanel: TSBSPanel;
    N1ReconLab: TSBSPanel;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    UDF5L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    PMenu_Notes: TPopupMenu;
    MenItem_General: TMenuItem;
    MenItem_Dated: TMenuItem;
    MenItem_Audit: TMenuItem;
    UDF11L: Label8;
    THUD11F: Text8Pt;
    UDF12L: Label8;
    THUD12F: Text8Pt;
    Shape1: TShape;
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ClsN1BtnClick(Sender: TObject);
    function N1TPerFConvDate(Sender: TObject; const IDate: string;
      const Date2Pr: Boolean): string;
    procedure N1DPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1DLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1DLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AddN1BtnClick(Sender: TObject);
    procedure DelN1BtnClick(Sender: TObject);
    procedure SWiN1BtnClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    function N1TPerFShowPeriod(Sender: TObject; const EPr: Byte): string;
    procedure OkN1BtnClick(Sender: TObject);
    procedure N1SelBalFExit(Sender: TObject);
    procedure N1TDateFExit(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure N1SelBalFEnter(Sender: TObject);
    procedure LnkN1BtnClick(Sender: TObject);
    procedure chkI1BtnClick(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure I5VV1FExit(Sender: TObject);
    procedure N1AcalcVATFClick(Sender: TObject);
    procedure NTIOHedCBEnter(Sender: TObject);
    procedure N1YRef2FChange(Sender: TObject);
    procedure SetUDFields(UDDocHed  :  DocTypes);
    procedure MenItem_GeneralClick(Sender: TObject);
    procedure MenItem_DatedClick(Sender: TObject);
    procedure MenItem_AuditClick(Sender: TObject);
    private
    {private declarations}

    BalDone,
    JustCreated,
    InvStored,
    StopPageChange,
    FirstStore,
    ReCalcTot,
    fNeedCUpdate,
    FColorsChanged,
    fFrmClosing,
    fDoingClose,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    fRecordLocked,
    VIOBeenThere,
    HaveVAT,
    CanDelete    :  Boolean;

    SKeypath,
    MinHeight,
    MinWidth     :  Integer;

    {$IFDEF NP}
      NotesCtrl  :  TNoteCtrl;
    {$ENDIF}

    VATMatrix    :  TVATMatrix;
    VATTitLAB    :  String;

    InvBtnList   :  TVisiBtns;

    IdLine       :  TNTLine;
    IdLineActive :  Boolean;

    RecordPage   :  Byte;
    DocHed       :  DocTypes;

    OldConTot    :  Double;


    PagePoint    :  Array[0..6] of TPoint;

    StartSize,
    InitSize     :  TPoint;

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}

    //PR: 15/11/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;
    function TransactionViewOnly : Boolean;


    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Procedure SetForceStore(State  :  Boolean);

    procedure NotePageReSize;

    Procedure Link2Nom;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Function CheckNeedStore  :  Boolean;

    Function ConfirmQuit  :  Boolean;

    procedure ShowRightMeny(X,Y,Mode  :  Integer);



    procedure Display_Id(Mode  :  Byte);

    procedure DeleteNTLine;

    Function AutoBal  :  Boolean;

    procedure SetFormProperties(SetList  :  Boolean);

    procedure SetFieldProperties;

    procedure Tidy_BalLines(Const  Fnum,Keypath  :  Integer);

    procedure Gen_BalLines;

    Procedure  SetNeedCUpdate(B  :  Boolean);
    procedure SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;
  public
    { Public declarations }

    fForceStore   : Boolean;

    ExLocal       : TdExLocal;
    ListOfSet     : Integer;

    MULCtrlO      : TNTxfrMList;

    // CA 09/04/2013 v7.0.3 ABSEXCH-13168: New field required to check on imbalance. New flag to ensure base currency has not been used
    FDebitAmount  : Extended;
    FCreditAmount : Extended;
    FNotBaseUsed  : Boolean;

    Property ForceStore  : Boolean read fForceStore write SetForceStore default False;

    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1  :  LongInt) :  LongInt;

    procedure PrimeButtons;

    procedure BuildDesign;

    procedure FormDesign;

    Function Current_BarPos(PageNo  :  Byte)  :  Integer;

    procedure HidePanels(PageNo    :  Byte);

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    Function Current_Page  :  Integer;

    Function SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

    procedure ShowLink(ShowLines,
                       VOMode    :  Boolean);


    procedure FormSetOfSet;


    procedure SetNTxfrStore(EnabFlag,
                            VOMode  :  Boolean);

    Procedure ChangePage(NewPage  :  Integer);


    procedure SetNTxfrFields;

    Procedure OutNTxfrTotals;

    procedure ReFreshFooter;

    Procedure Set_NOMIOFlg(SetMode  :  Boolean);

    procedure OutNTxfr;

    procedure Form2NTxfr;

    Procedure SetFieldFocus;

    Procedure NoteUpdate;

    procedure SetNewFolio;

    procedure GetAutoSettings;

    procedure ProcessNtxfr(Fnum,
                           KeyPAth    :  Integer;
                           Edit,
                           AutoOn     :  Boolean);

    Function CheckCompleted(Edit  :  Boolean)  : Boolean;

    Function Check_LinesOk(InvR  :  InvRec)  :  Boolean;

    // CA 10/04/2013 v7.0.3 ABSEXCH-13168: New procedure to check currency
    procedure CheckCurrency(InvR  :  InvRec);


    procedure StoreNtxfr(Fnum,
                         KeyPAth    :  Integer);

    procedure EditAccount(Edit,
                          AutoOn,
                          ViewOnly   :  Boolean);

    procedure SetHelpContextIDs; // NF: 24/07/06

    //PR: 15/11/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;
  end;

  Procedure Set_NTxfrFormMode(State  :  DocTypes;
                              NPage  :  Byte);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  // NF:
  {$IFDEF CU}
    CustWinU,
    CustIntU,
  {$ENDIF}

  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,

  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,

  {$IFDEF PF_On}

    InvLst2U,

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
  AutoTxU,
  PayF2U,

  ConvDocU,

  ThemeFix,

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}
  Event1U,
  GenWarnU,
  Warn1U,
  //GS 14/10/2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF,

  { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
  TransactionOriginator,

  AuditNotes;

{$R *.DFM}



Const
  NTMainPNo        =  0;
  NTFootPNo        =  1;
  NTNotesPNo       =  2;

Var
  NTxfrFormMode  :  DocTypes;
  NTxfrFormPage  :  Byte;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_NTxfrFormMode(State  :  DocTypes;
                            NPage  :  Byte);

Begin
  If (State<>NTxfrFormMode) then
    NTxfrFormMode:=State;

  If (NTxfrFormPage<>NPage) then
    NTxfrFormPage:=NPage;

end;




{$I NTxfrI1U.PAS}


Procedure  TNtxfrForm.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TNtxfrForm.Find_FormCoord;


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

    PrimeKey:=DocCodes[DocHed][1];

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

    GetbtControlCsm(N1SBox);

    GetbtControlCsm(N1BSBox);

    GetbtControlCsm(N1BtnPanel);

    GetbtControlCsm(N1ListBtnPanel);

    GetbtControlCsm(TCNScrollBox);
    GetbtControlCsm(TCNListBtnPanel);


    If GetbtControlCsm(N1YrefF) then
      SetFieldProperties;


    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range *}

  With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;


  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TNTxfrForm.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:=DocCodes[DocHed][1];

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(N1SBox);

    StorebtControlCsm(N1BSBox);

    StorebtControlCsm(N1BtnPanel);

    StorebtControlCsm(N1ListBtnPanel);

    StorebtControlCsm(N1YrefF);

    StorebtControlCsm(TCNScrollBox);

    StorebtControlCsm(TCNListBtnPanel);

    MULCtrlO.Store_ListCoord(GlobComp);

    {$IFDEF NP}
      If (NotesCtrl<>nil) then
        NotesCtrl.MULCtrlO.Store_ListCoord(GlobComp);
    {$ENDIF}

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

end;




procedure TNTxfrForm.SetForceStore(State  :  Boolean);

Begin
  If (State<>fForceStore) then
  Begin
    fForceStore:=State;

    ClsN1Btn.Enabled:=Not fForceStore;
    CanN1Btn.Enabled:=ClsN1Btn.Enabled;
  end;
end;


Function TNTxfrForm.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;


Procedure TNTxfrForm.Link2Nom;


Begin
  With Id do
  Begin
    {$IFDEF MC_On}

      N1BaseF.Value:=Conv_TCurr(NetValue+VAT,CXRate[UseCoDayRate],Currency,UseORate,BOff);

    {$ENDIF}

    {$IFDEF PF_On}

      If (Syss.UseCCDep) then
      Begin
        CCLab.Caption:=CCDep[BOn];
        DepLab.Caption:=CCDep[BOff];
      end;

    {$ENDIF}
  end;
end;


Procedure TNTxfrForm.WMCustGetRec(Var Message  :  TMessage);

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

              If (WParam=169) then
                MULCtrlO.GetSelRec(BOff);

              Case Current_Page of

                NTNotesPNo  :  AddN1BtnClick(EditN1Btn);

                else  Begin

                        Display_Id(2);

                        If (IdLineActive) and (Not ExLocal.InAddEdit) then {*it must be readonly *}
                          IdLine.Show;
                      end;
              end; {Case..}
            end;

      1  :  Begin

              {* Show nominal/cc dep data *}

              Link2Nom;

            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      7  :  NoteUpDate; {* Update note line count *}

     17  :  Begin {* Force reset of form *}
              GotCoord:=BOff;
              SetDefault:=BOn;
              Close;
            end;

     25  :  Begin
              NeedCUpdate:=BOn;
              FColorsChanged := True;
            End;

     108  :
             Begin

               If (IdLine<>nil) then
               With ExLocal do
               Begin
                 LInv:=IdLine.ExLocal.LInv;

                 OutNTxfrTotals;

                 ReCalcTot:=BOn;

                 If (LastEdit) and (Not LViewOnly) and (Not ForceStore) then
                   ForceStore:=((LInv.InvNetVal<>LastInv.InvNetVal) or
                                (Linv.Variance<>LastInv.Variance) or
                                (Linv.ILineCount<>LastInv.ILineCount) or
                                (Linv.TotalInvoiced<>LastInv.TotalInvoiced));

               end;

               With MULCtrlO do
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));

              InvBtnList.SetEnabBtn(BOn);

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

    //GS: 16/05/11 ABSEXCH-11356
    //added a 'wParam = 171' (opening the object drill) branch, now when the object drill is opened
    //and the active MDI form is TRecepForm (Sales Recipt / Purchase Payment record) the global invoice record
    //is refreshed beforehand, instead of using the last available global invoice record; which may not be
    //the record currently being displayed.

    171 :  Begin  // Link for ObjectDrill
              MULCtrlO.GetSelRec(BOff);
              ExLocal.AssignToGlobal(InvF);
            end;

     175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

     176 :  Case LParam of
              0  :  Case Current_Page of
                      NTMainPNo
                         :  If (Assigned(MULCtrlO)) then
                              MULCtrlO.SetListFocus;

                      NTNotesPNo
                         :  {$IFDEF NP}
                              If (Assigned(NotesCtrl)) then
                                NotesCtrl.MULCtrlO.SetListFocus;
                            {$ELSE}
                              ;
                            {$ENDIF}

                    end; {Case..}
            end; {Case..}

     200 :  Begin

              IdLine:=nil;
              IdLineActive:=BOff;

              MULCtrlO.SetListFocus;
            end;

     {$IFDEF Ltr}
       400,
       401  : Begin
                LetterActive:=Boff;
                LetterForm:=nil;
              end;
     {$ENDIF}

      {3000,
      3001,
      3010,
      3011
         :  Begin
              If (WParam<3010) and (WindowState=wsMinimized) then
                WindowState:=wsNormal;

              If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) then
              Begin
                ShowLink(BOn,BOn);
              end;
            end;}



    end; {Case..}

  end;
  Inherited;
end;


Procedure TNTxfrForm.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TNTxfrForm.Send_UpdateList(Edit   :  Boolean;
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


procedure TNTxfrForm.ShowLink(ShowLines,
                               VOMode    :  Boolean);
begin
  ExLocal.AssignFromGlobal(InvF);
  ExLocal.LGetRecAddr(InvF);

  With ExLocal,LInv do
  Begin
    Caption:=DocNames[InvDocHed]+' Record - '+Pr_OurRef(LInv);

    {$B-}

    LViewOnly:=SetViewOnly(ShowLines,VOMode);

    PrimeButtons;

    {$B+}

  end;


  OutNTxfr;


  
  Case Current_Page of
    NTMainPNo  :  ReFreshList(ShowLines,Not JustCreated);

    NTFootPNo  :  ReFreshFooter;

    NTNotesPNo :  Begin
                    {$IFDEF NP}

                      If (NotesCtrl<>nil) then {* Assume record has changed *}
                      With ExLocal do
                      Begin
                        NotesCtrl.RefreshList(FullNomKey(LInv.FolioNum),NotesCtrl.GetNType);
                        NotesCtrl.GetLineNo:=LInv.NLineCount;
                      end;
                    {$ENDIF}
                  end;
  end; {case..}
  
  JustCreated:=BOff;

end;


procedure TNTxfrForm.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(N1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(N1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(N1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(N1BtnPanel.Height);

  PagePoint[3].X:=N1BtnPanel.Height-(N1BSBox.Height);
  PagePoint[3].Y:=N1SBox.ClientHeight-(N1DPanel.Height);

  PagePoint[4].X:=PageControl1.Width-(N1ListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(N1ListBtnPanel.Height);

  PagePoint[5].X:=PageControl1.Width-(TCNScrollBox.Width);
  PagePoint[5].Y:=PageControl1.Height-(TCNScrollBox.Height);

  PagePoint[6].Y:=PageControl1.Height-(TCNListBtnPanel.Height);


  GotCoord:=BOn;

end;


Function TNTxfrForm.SetHelpC(PageNo :  Integer;
                             Pages  :  TIntSet;
                             Help0,
                             Help1  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    If (PageNo=NTNotesPNo) then
      Result:=Help1
    else
      Result:=Help0;
  end
  else
    Result:=-1;

end;

procedure TNTxfrForm.PrimeButtons;

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
          AddVisiRec(AddN1Btn,BOff);
          AddVisiRec(EditN1Btn,BOff);
          AddVisiRec(DelN1Btn,BOff);
          AddVisiRec(InsN1Btn,BOff);
          AddVisiRec(SwiN1Btn,BOff);
          AddVisiRec(ChkI1Btn,BOff);
          AddVisiRec(LnkN1Btn,BOff);
        end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    With InvBtnList do
    Begin

      SetHideBtn(0,((ExLocal.LViewOnly) and ((PageNo<>NTNotesPNo) or (fRecordLocked))),BOff);
      SetHideBtn(1,((ExLocal.LViewOnly) and (PageNo=NTNotesPNo) and (fRecordLocked)) ,BOff);

      SetBtnHelp(0,SetHelpC(PageNo,[0,NTNotesPNo],427,88));
      SetBtnHelp(1,SetHelpC(PageNo,[0,NTNotesPNo],428,87));


      SetHideBtn(2,Not IdButton(0).Visible,BOff);

      SetBtnHelp(2,SetHelpC(PageNo,[0,NTNotesPNo],429,89));


      SetHideBtn(3,(PageNo=0) or (Not IdButton(0).Visible),BOff);

      SetHideBtn(4,(PageNo=0),BOff);
      SetHideBtn(5,((ExLocal.LViewOnly) or (PageNo=NTNotesPNo)),BOff);
      SetHideBtn(6,(PageNo In [NTNotesPNo]),BOn);

    end;

    LnkN1Btn.HelpContext := 81; // NF: 09/05/06 Fix for incorrect Context ID

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure TNTxfrForm.BuildDesign;

Var
  HideCC  :  Boolean;

begin

  {* Set Version Specific Info *}

  {$IFNDEF MC_On}
    N1BLab.Visible:=BOff;
    N1BaseF.Visible:=BOff;

  {$ENDIF}

  {$IFDEF LTE}
    N1SelBalQF.Visible:=BOff;
    Label81.Visible:=BOff;
    N1SelBalF.Visible:=BOff;
  {$ENDIF}

  N1YRefF.MaxLength:=DocYRef2Len;
  N1YRef2F.MaxLength:=DocYRef1Len;

  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}


  N1VAmtLab.Caption:=CCVATName^+N1VAmtLab.Caption;
  //  CA 03/08/2012  ABSEXCH-12952 - Rebranding / UI Update
  // VATTit.Caption:=CCVATName^+VATtit.Caption;
  VATTitLAB := ' ' + CCVATName^+' : ';
  SBSPanel1.Caption  := VATTitLAB;

  N1AcalcVATF.Caption:=N1AcalcVATF.Caption+CCVATName^;

  VATLab.Caption:=VATLab.Caption+CCVATName^;
  I5VATLab.Caption:=CCVATName^;

  CCPanel.Visible:=Not HideCC;

  //GS 18/10/2011 ABSEXCH-11706: removed existing UDF setup code; replaced with calling pauls new method
  SetUDFields(DocHed);
  (*
  UDF1L.Caption:=Get_CustmFieldCaption(1,43);
  UDF1L.Visible:=Not Get_CustmFieldHide(1,43);

  THUD1F.Visible:=UDF1L.Visible;

  UDF2L.Caption:=Get_CustmFieldCaption(1,44);
  UDF2L.Visible:=Not Get_CustmFieldHide(1,44);

  THUD2F.Visible:=UDF2L.Visible;


  UDF3L.Caption:=Get_CustmFieldCaption(1,45);
  UDF3L.Visible:=Not Get_CustmFieldHide(1,45);

  THUD3F.Visible:=UDF3L.Visible;


  UDF4L.Caption:=Get_CustmFieldCaption(1,46);
  UDF4L.Visible:=Not Get_CustmFieldHide(1,46);

  THUD4F.Visible:=UDF4L.Visible;

  TransExtform1.ReAssignFocusLast;

  If (Not THUD1F.Visible) or (Not THUD2F.Visible) or (Not THUD3F.Visible) or (Not THUD4F.Visible) then
  With TransExtForm1 do
  Begin
    If ((Not THUD1F.Visible) and (Not THUD2F.Visible) and (Not THUD3F.Visible) and (Not THUD4F.Visible)) then
      ExpandedHeight:=Height;

  end;
  *)
end;


//GS 18/10/2011 ABSEXCH-11706: a copy of pauls user fields function
//PR: 11/11/2011 Amended to use centralised function EnableUdfs in CustomFieldsIntf.pas ABSEXCH-12129
procedure TNTxfrForm.SetUDFields(UDDocHed  :  DocTypes);
begin
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L, UDF11L, UDF12L],
              [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F],
              cfNOMHeader);

  ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F]),
                           2, //UDFs laid out on the UI as 2 columns, 5 rows
                           TransExtForm1,
                           0,     // RowHeightOverRide
                           12);   // UDF_Count

end;

procedure TNTxfrForm.FormDesign;


begin

  PrimeButtons;

  BuildDesign;

  {* Build VAT Matrix *}

  try

    With VATMatrix do
    Begin
      AddVisiRec(I5VR1F,I5VV1F,I5VG1F);
      AddVisiRec(I5VR2F,I5VV2F,I5VG2F);
      AddVisiRec(I5VR3F,I5VV3F,I5VG3F);
      AddVisiRec(I5VR4F,I5VV4F,I5VG4F);
      AddVisiRec(I5VR5F,I5VV5F,I5VG5F);
      AddVisiRec(I5VR6F,I5VV6F,I5VG6F);
      AddVisiRec(I5VR7F,I5VV7F,I5VG7F);
      AddVisiRec(I5VR8F,I5VV8F,I5VG8F);
      AddVisiRec(I5VR9F,I5VV9F,I5VG9F);
      AddVisiRec(I5VR10F,I5VV10F,I5VG10F);
      AddVisiRec(I5VR11F,I5VV11F,I5VG11F);
      AddVisiRec(I5VR12F,I5VV12F,I5VG12F);
      AddVisiRec(I5VR13F,I5VV13F,I5VG13F);
      AddVisiRec(I5VR14F,I5VV14F,I5VG14F);
      AddVisiRec(I5VR15F,I5VV15F,I5VG15F);
      AddVisiRec(I5VR16F,I5VV16F,I5VG16F);
      AddVisiRec(I5VR17F,I5VV17F,I5VG17F);
      AddVisiRec(I5VR18F,I5VV18F,I5VG18F);
      AddVisiRec(I5VR19F,I5VV19F,I5VG19F);
      AddVisiRec(I5VR20F,I5VV20F,I5VG20F);
      AddVisiRec(I5VR21F,I5VV21F,I5VG21F);
    end;

  except

    VATMatrix:=nil

  end;


end;

procedure TNTxfrForm.HidePanels(PageNo    :  Byte);

Var
  TmpBo  :  Boolean;
  n      :  Integer;

Begin
  With MULCtrlO,VisiList do
  Begin
    fBarOfSet:=Current_BarPos(PageNo);

    Case PageNo of
      NTMainPNo

         :  Begin
              {$IFNDEF PF_On}
                TmpBo:=BOn;
              {$ELSE}
                TmpBo:=Not Syss.UseCCDep;
              {$ENDIF}

              SetHidePanel(7,TmpBo,BOff);
              SetHidePanel(8,TmpBo,BOn);

            end;


    end; {Case..}

  end; {with..}
end;


Function TNTxfrForm.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      NTMainPNo
         :  Result:=N1SBox.HorzScrollBar.Position;
      else  Result:=0;
    end; {Case..}


end;


procedure TNTxfrForm.RefreshList(ShowLines,
                                 IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;

Begin

  KeyStart:=FullIdkey(EXLocal.LInv.FolioNum,RecieptCode);

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(IdetailF,IdFolioK,KeyStart,'','',4,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TNTxfrForm.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TNTxfrMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO do
    Begin

      Try

        With VisiList do
        Begin
          AddVisiRec(N1DPanel,N1DLab);
          AddVisiRec(N1NomPanel,N1NomLab);
          AddVisiRec(N1NDPanel,N1NDLab);
          AddVisiRec(N1DrPanel,N1DrLab);
          AddVisiRec(N1CrPanel,N1CrLab);
          AddVisiRec(N1VCPanel,N1VCLab);
          AddVisiRec(N1VAmtPanel,N1VAmtLab);
          AddVisiRec(N1CCPanel,N1CCLab);
          AddVisiRec(N1DepPanel,N1DepLab);
          AddVisiRec(N1ReconPanel,N1ReconLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(0);

          LabHedPanel:=N1HedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;


      ListOfSet:=10;


      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=9;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [1,3,4,6]) then
        Begin
          DispFormat:=SGFloat;

          If (n<>1) then
            NoDecPlaces:=2
          else
            NoDecPlaces:=0;
        end;
      end;


      ListLocal:=@ExLocal;

      ListCreate;

      NoUpCaseCheck:=BOn;

      UseSet4End:=BOn;

      Set_Buttons(N1ListBtnPanel);

      ReFreshList(ShowLines,BOff);

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;


  FormSetOfSet;

  FormReSize(Self);

end;



{ ======== Display Receipt Record ========== }

procedure TNTxfrForm.SetNTxfrFields;

Var
  GenStr       :  Str255;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    N1ORefF.Text:=Pr_OurRef(LInv);
    N1OpoF.Text:=OpName;

    { CJS - 2013-10-25 - MRD2.6.08 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      N1OpoF.Hint := GetOriginatorHint(LInv)
    else
      N1OpoF.Hint := '';

    N1TPerF.InitPeriod(AcPr,AcYr,BOn,BOn);

    N1TDateF.DateValue:=TransDate;

    N1YRefF.Text:=TransDesc;
    N1YRef2F.Text:=YourRef;

    N1AutoRevF.Checked:=UnTagged;

    N1SelBalF.Text:=Form_BInt(BatchNom,0);

    THUd1F.Text:=DocUser1;
    THUd2F.Text:=DocUser2;
    THUd3F.Text:=DocUser3;
    THUd4F.Text:=DocUser4;
    //GS 18/10/2011 ABSEXCH-11706: put customisation values into text text boxes
    THUd5F.Text:=DocUser5;
    THUd6F.Text:=DocUser6;
    THUd7F.Text:=DocUser7;
    THUd8F.Text:=DocUser8;
    THUd9F.Text:=DocUser9;
    THUd10F.Text:=DocUser10;
    // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
    THUd11F.Text:=thUserField11;
    THUd12F.Text:=thUserField12;
    Set_NOMIOFlg(BOff);

  end; {With..}
end;


Procedure TNTxfrForm.OutNTxfrTotals;

Var
  Dnum    :  Double;
  NTDrCr  :  DrCrType;
  
  n       :  VATType;


Begin
  With ExLocal,LInv do
  Begin
    HaveVAT:=BOff;

    ShowDrCr((PRequired(BOn,LInv)*DocNotCnst),NTDrCr);

//  CA 03/08/2012  ABSEXCH-12952 - Rebranding / UI Update
//    DrReqdLab.Caption:=FormatFloat(GenRealMask,NTDrCr[BOff]);
//    CrReqdLab.Caption:=FormatFloat(GenRealMask,NTDrCr[BOn]);

    // CA 09/04/2013 v7.0.3 ABSEXCH-13168: New field required to check on imbalance
    // CJS 2013-05-03 v7.0.3 - ABSEXCH-14271 - invalid floating point value -
    //                amended code to read the floating-point values directly
    FDebitAmount   := NTDrCr[BOff];
    FCreditAmount  := NTDrCr[BOn];

    // MH 24/09/2012 v7.0 ABSEXCH-13456: Panels not updating correctly as both fields referenced BOff
    panDrReqd.Caption := ' Dr Reqd: ' + FormatFloat(GenRealMask,NTDrCr[BOff]);
    panCrReqd.Caption := ' Cr Reqd: ' + FormatFloat(GenRealMask,NTDrCr[BOn]);

    If (VATMatrix<>nil) then
    With VATMatrix do
    Begin
      For n:=VStart to VEnd do
      Begin
        IdRec(Ord(n))^.GoodsD.Value:=LInvNetAnal[n];
        IdRec(Ord(n))^.VATD.Value:=InvVATAnal[n];

        HaveVAT:=(HaveVAT or LInvNetTrig[n]);
      end;
    end;

//  CA 03/08/2012  ABSEXCH-12952 - Rebranding / UI Update
//  VATTotLab.Caption:=FormatBFloat(GenRealMask,InvVAT,Not HaveVAT);
    SBSPanel1.Caption := VATTitLAB + FormatBFloat(GenRealMask,InvVAT,Not HaveVAT);
    
    If ((HaveVAT) or (LViewOnly)) and (NTIOHedCB.ItemIndex>0) then
      SBSPanel1.Caption:=SBSPanel1.Caption+' '+NTIOHedCB.Items[NTIOHedCB.ItemIndex][1];

    //  CA 03/08/2012  ABSEXCH-12952 - Rebranding / UI Update. Below remarked out and  replaced with above
    //  VATTotLab.Caption:=VATTotLab.Caption+' '+NTIOHedCB.Items[NTIOHedCB.ItemIndex][1];

  end; {With..}

end;

procedure TNTxfrForm.ReFreshFooter;

Begin
  With ExLocal,LInv do
  Begin

    If (ForceStore) or (LastEdit) or (LViewOnly) then
    Begin
      CalcInvVATTotals(LInv,ExLocal,Not ManVAT);

      N1AcalcVATFClick(Nil);
    end;

    VATMatrix.HideVATMatrix(LInvNetTrig);

    OutNTxfrTotals;
  end; {With..}
end;

Procedure TNTxfrForm.Set_NOMIOFlg(SetMode  :  Boolean);

Begin
  With ExLocal,LInv do
  Case SetMode of
    BOff  :  Begin
               NTIOHedCB.ItemIndex:=(1*Ord(NOMVATIO=IOVATCh[BOff]))+(2*Ord(NOMVATIO=IOVATCh[BOn]));
             end;
    BOn   :  Begin
               If (HaveVAT) and (NTIOHedCB.ItemIndex>=0) then
               Begin
                 Case NTIOHedCB.ItemIndex of
                   1,2  : NOMVATIO:=IOVATCh[NTIOHedCB.ItemIndex=2];
                   else   NOMVATIO:=C0;
                 end; {Case..}
               end
               else
                 NOMVATIO:=C0;
             end;

  end;{Case..}
end;

{ ======== Display Invoice Record ========== }

procedure TNTxfrForm.OutNTxfr;

Var
  GenStr       :  Str255;
  FoundCode    :  Str20;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    SetNTxfrFields;

    OutNTxfrTotals;
  end; {With..}
end;


procedure TNTxfrForm.Form2NTxfr;

Var
  n       :  VATType;

Begin
  With ExLocal,LInv do
  Begin
    TransDate:=N1TDateF.DateValue;

    N1TPerF.InitPeriod(AcPr,AcYr,BOff,BOff);

    TransDesc:=N1YRefF.Text;
    YourRef:=N1YRef2F.Text;

    UnTagged:=N1AutoRevF.Checked;

    If (N1SelBalQF.Checked) and (Not LastEdit) then
      BatchNom:=IntStr(N1SelBalF.Text);

    DocUser1:=THUd1F.Text;
    DocUser2:=THUd2F.Text;
    DocUser3:=THUd3F.Text;
    DocUser4:=THUd4F.Text;
    //GS 18/10/2011 ABSEXCH-11706: write udef field values into customisation object
    DocUser5:=THUd5F.Text;
    DocUser6:=THUd6F.Text;
    DocUser7:=THUd7F.Text;
    DocUser8:=THUd8F.Text;
    DocUser9:=THUd9F.Text;
    DocUser10:=THUd10F.Text;
    // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
    thUserField11 := THUd11F.Text;
    thUserField12 := THUd12F.Text;
    Set_NOMIOFlg(BOn);

    If (ManVAT) then
    Begin
      For n:=VStart to VEnd do
      Begin

        InvVATAnal[n]:=VATMatrix.IDRec(Ord(n))^.VATD.Value;

      end;
    end;


  end; {With..}
end;


Procedure TNTxfrForm.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      NTMainPNo
         :  N1YRefF.SetFocus;

    end; {Case&With..}

end; {Proc..}




Procedure TNTxfrForm.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TNTxfrForm.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
  end;
end;


procedure TNTxfrForm.PageControl1Change(Sender: TObject);
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

      If (NewIndex<>NTFootPNo) then
        PrimeButtons;

      N1FPanel.Visible:=(NewIndex<>NTFootPNo);
      N1BSBox.Visible:=N1FPanel.Visible;

      If (Not TransExtForm1.NewSetting) and (NewIndex>0) then {* Panel is open, so close it *}
        TransExtForm1.ForceClose;


      Case NewIndex of

       NTFootPNo
          :   If (ReCalcTot) then
              Begin
                ReCalcTot:=BOff;

                ReFreshFooter;
              end;

      {$IFDEF NP}

        NTNotesPNo
           :  If (NotesCtrl=nil) then
              With ExLocal do
              Begin
                NotesCtrl:=TNoteCtrl.Create(Self);


                //TW 26/10/2011: Add Event handler for new note functionality.
                NotesCtrl.fParentLocked:=fRecordLocked;
                NotesCtrl.Caption:=Caption+' - Notes';
                NotesCtrl.OnSwitch := SwitchNoteButtons;

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

                  CoorPrime:=DocCodes[DocHed][1];
                  CoorHasCoor:=LastCoord;

                end;

                try
                  NotesCtrl.CreateList(Self,NoteSetUp,NoteDCode,NoteCDCode,FullNomKey(LInv.FolioNum));
                  NotesCtrl.GetLineNo:=LInv.NLineCount;


                except
                  NotesCtrl.Free;
                  NotesCtrl:=Nil
                end;


              end
              else
              With ExLocal do
              begin
                If (FullNomKey(LInv.FolioNum)<>NotesCtrl.GetFolio) then {* Refresh notes *}
                with NotesCtrl do
                Begin
                  RefreshList(FullNomkey(LInv.FolioNum),GetNType);
                  GetLineNo:=LInv.NLineCount;
                end;
                //TW 26/10/2011: If note list already exists call method to make sure
                //               buttons are appropriately enabled.
                SwitchNoteButtons(Self, NotesCtrl.NoteMode);
              end;
      {$ELSE}

         NTNotesPNo  :  ;

      {$ENDIF}



      end; {Case..}


      MDI_UpdateParentStat;

    end; {With..}
end;




procedure TNTxfrForm.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  fFrmClosing:=BOff;
  fDoingClose:=BOff;
  ExLocal.Create;

  ForceStore:=BOff;

  LastCoord:=BOff;
  ReCalcTot:=BOn;

  Visible:=BOff;

  InvStored:=BOff;

  JustCreated:=BOn;

  ReCalcTot:=BOn;

  BalDone:=BOff;

  NeedCUpdate:=BOff;
  FColorsChanged := False;

  StopPageChange:=BOff;

  fRecordLocked:=BOff;

  VIOBeenThere:=BOff;

  HaveVAT:=BOff;

  SKeypath:=0;

  MinHeight:=351;
  MinWidth:=630;

  InitSize.Y:=358;
  InitSize.X:=632;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=382;
  Width:=640;}

  PageControl1.ActivePage:=RecepPage;

  VATMatrix:=TVATMatrix.Create;

  With TForm(Owner) do
  Begin
    Self.Left:=0;
    Self.Top:=0;
  end;

  RecordPage:=NTxfrFormPage;
  DocHed:=NTxfrFormMode;

  Caption:=DocNames[DocHed];

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;


  FormDesign;

  FormBuildList(BOff);

  SetHelpContextIDs // NF: 24/07/06
end;



procedure TNTxfrForm.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;
  VATMatrix.Free;


  If (InvBtnList<>nil) then
    InvBtnList.Free;

  {If (MULCtrlO<>nil) then
    MULCtrlO.Free;}

end;

procedure TNTxfrForm.FormCloseQuery(Sender: TObject;
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

        Send_UpdateList(BOff,102);

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;

end;

procedure TNTxfrForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    If (MULCtrlO<>nil) then
    Begin
      try
        MULCtrlO.Destroy;
      finally
        MULCtrlO:=nil;
      end;
    end;

  end;
end;


procedure TNTxfrForm.NotePageReSize;

Begin
  With TCNScrollBox do
  Begin
    TCNListBtnPanel.Left:=Width+5;

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


procedure TNTxfrForm.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) and (Not fDoingClose) then
  Begin
    MULCtrlO.LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;
    
    NewVal:=ClientWidth-PagePoint[0].X;
    If (NewVal<MinWidth) then
      NewVal:=MinWidth;

    PageControl1.Width:=NewVal;

    NewVal:=ClientHeight-PagePoint[0].Y;

    If (NewVal<MinHeight) then
      NewVal:=MinHeight;

    PageControl1.Height:=NewVal;


    N1SBox.Width:=PageControl1.Width-PagePoint[1].X;
    N1SBox.Height:=PageControl1.Height-PagePoint[1].Y;

    TCNScrollBox.Width:=PageControl1.Width-PagePoint[5].X;
    TCNScrollBox.Height:=PageControl1.Height-PagePoint[5].Y;

    N1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    N1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    N1BSBox.Height:=N1BtnPanel.Height-PagePoint[3].X;

    N1ListBtnPanel.Left:=PageControl1.Width-PagePoint[4].X;
    N1ListBtnPanel.Height:=PageControl1.Height-PagePoint[4].Y;


    TCNListBtnPanel.Height:=PageControl1.Height-PagePoint[6].Y;

    NotePageResize;


    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=N1SBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      MULCtrlO.ReFresh_Buttons;

      LockWindowUpDate(0);
    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));


  end; {If time to update}
end;


procedure TNTxfrForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  If (Key=$5A) and (Shift = ([ssAlt,ssCtrl,ssShift])) and (Not ExLocal.LViewOnly) then
  Begin
    Re_SetDoc(ExLocal.LInv);
    OutNtxfr;
    MULCtrlO.PageUpDn(0,BOn);
  end;

end;

procedure TNTxfrForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Function TNTxfrForm.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;




procedure TNTxfrForm.ClsN1BtnClick(Sender: TObject);
begin
  If ConfirmQuit then
    Close;
end;

function TNTxfrForm.N1TPerFConvDate(Sender: TObject; const IDate: string;
  const Date2Pr: Boolean): string;
begin
  Result:=ConvInpPr(IDate,Date2Pr,@ExLocal);
end;


Function TNTxfrForm.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and ((CheckNeedStore) or (ForceStore)) and (Not ExLocal.LViewOnly) and (Not InvStored) then
  Begin
    If (Current_Page>NTMainPNo) then {* Force view of main page *}
      ChangePage(0);

    If (ForceStore) then
      mbRet:=MessageDlg('This Nominal Transfer must be stored',mtWarning,[mbOk],0)
    else
      mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes
           :  Begin
                StoreNtxfr(InvF,SKeypath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) then
                Begin
                  Delete_DocEditNow(LInv.FolioNum);

                  Status:=UnLockMLock(InvF,LastRecAddr[InvF]);

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


procedure TNTxfrForm.SetNTxfrStore(EnabFlag,
                                   VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode or FAllowPostedEdit;

  OkN1Btn.Enabled:=Not VOMode or FAllowPostedEdit;
  CanN1Btn.Enabled:=Not VOMode or FAllowPostedEdit;


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

  N1SelBalQF.Enabled:=((Not ExLocal.LastEdit) and (Not VOMode));

  N1SelBalF.ReadOnly:=Not N1SelBalQF.Enabled;

end;


Procedure TNTxfrForm.NoteUpdate;


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



Function TNTxfrForm.SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

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
    N1StatLab.Caption := GetIntMsg(VOMsg+50);
    Shape1.Shape := stRoundRect;
    Shape1.Left := 5; //I1StatLab.Left - 1;
    Shape1.Top := 5; //I1StatLab.Top - 3;
    Shape1.Width := N1btnPanel.Width - 10; //I1StatLab.Width + 4;
    Shape1.Height := N1StatLab.Height + 4;
    Shape1.Visible := True;
    Shape1.Brush.Color := RGB(0, 159, 223);
    N1StatLab.Color := Shape1.Brush.Color;
  end
  else
    N1StatLab.Caption:='';

  OkN1Btn.Visible:=Not Result or FAllowPostedEdit;
  CanN1Btn.Visible:=OkN1Btn.Visible;



end;


procedure TNtxfrForm.GetAutoSettings;

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

        With N1YRefF do
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

          SetNtxfrFields;
        end;


      end;
    finally

      ASCtrl.Free;

    end; {Try..}

  end; {with..}
end; {Proc..}




(*  Add is used to add Customers *)

procedure TNtxfrForm.ProcessNtxfr(Fnum,
                                  KeyPAth    :  Integer;
                                  Edit,
                                  AutoOn     :  Boolean);

Var
  KeyS       :  Str255;


Begin

  Addch:=ResetKey;

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

    LastInv:=LInv;

    If (Not Edit) then
    Begin
      Caption:=DocNames[DocHed]+' Record';

      LResetRec(Fnum);

      RunNo:=0+(AutoRunNo*Ord(AutoOn));

      NomAuto:=Not AutoOn;

      InvDocHed:=DocHed;

      TransDate:=Today; AcPr:=GetLocalPr(0).CPr; AcYr:=GetLocalPr(0).CYr;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
        Date2Pr(TransDate,AcPr,AcYr,@ExLocal);

      NLineCount:=1;

      ILineCount:=1;


      OpName:=EntryRec^.Login;

      {$IFDEF MC_On}

        Currency:=1;
      {$ELSE}

        Currency:=0;

      {$ENDIF}

      CXrate:=SyssCurr.Currencies[Currency].CRates;

      VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;

      SetTriRec(Currency,UseORate,CurrTriR);

      SetTriRec(Syss.VATCurr,UseORate,VATTriR);

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


      OutNtxfr;

      If (Not Edit) then
        ReFreshList(BOn,Not JustCreated);

    end
    else
    Begin
      {* Add to list as currently being edited *}

      If (Not LViewOnly) then
      Begin
        Add_DocEditNow(LInv.FolioNum);

        If (Not LInv.ManVAT) then
          ReFreshFooter;
      end;
    end;


    SetNtxfrStore(BOn,LViewOnly);


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


{ ====================== Procedure to check if at least one line isnt using the base currency =============== }

// CA 10/04/2013 v7.0.3 ABSEXCH-13168: New procedure to check currency
procedure TNtxfrForm.CheckCurrency(InvR  :  InvRec);
Const
  Fnum     =  IDetailF;
  Keypath  =  IDFolioK;
Var
  KeyS,
  KeyChk    :  Str255;
  ExStatus  :  Integer;
Begin
  ExStatus:=0;

  KeyChk:=FullIdKey(InvR.FolioNum,RecieptCode);

  KeyS:=KeyChk;

  ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  try // NF:
    While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))  do
    With Id do
    Begin

      ExLocal.AssignFromGlobal(IdetailF);

      if Currency > 1 Then
         FNotBaseUsed := True;

      ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}
  finally
  end;{try}

end; {Func..}

 { ====================== Function to Check ALL valid invlines (InvLTotal<>0) have a nominal =============== }

Function TNtxfrForm.Check_LinesOk(InvR  :  InvRec)  :  Boolean;
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

  // NF:
  {$IFDEF CU}
    LineCU  :  TCustomEvent;
  {$ELSE}
    LineCU  :  Pointer;
  {$ENDIF}

Begin
  NomOk:=BOn;

  ExStatus:=0;

  KeyChk:=FullIdKey(InvR.FolioNum,RecieptCode);

  KeyS:=KeyChk;

  ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  LineCU:=Nil; // NF:

  try // NF:
    While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NomOk) do
    With Id do
    Begin

      ExLocal.AssignFromGlobal(IdetailF);

      // NF:
      {$IFDEF CU}
        If (Not Assigned(LineCU)) then
        Begin
          LineCU:=TCustomEvent.Create(EnterpriseBase + 4000, 19);
          If (LineCU.GotEvent) then LineCU.BuildEvent(ExLocal);
        end;
      {$ENDIF}

      //NomOk:=LineCheckCompleted(ExLocal.LId,ExLocal.LInv,Self.ExLocal.LastEdit,BOn,Self);
      NomOk:=LineCheckCompleted(ExLocal.LId,ExLocal.LInv,Self.ExLocal.LastEdit,BOn,Self,LineCU); // NF:

      ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}
  finally
    // NF:
    {$IFDEF CU}
      If (Assigned(LineCU)) then LineCU.Free;
    {$ENDIF}
  end;{try}


{  While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NomOk) do
  With Id do
  Begin

    ExLocal.AssignFromGlobal(IdetailF);
    NomOk:=LineCheckCompleted(ExLocal.LId,ExLocal.LInv,Self.ExLocal.LastEdit,BOn,Self);

    ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Result:=NomOk;
end; {Func..}



Function TNtxfrForm.CheckCompleted(Edit  :  Boolean)  : Boolean;

Const
  NofMsgs      =  8;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  BalNow   :  Double;


Begin
  New(PossMsg);
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='The current transaction line has not been stored yet.';
  PossMsg^[2]:='Transaction Date is not valid.';
  PossMsg^[3]:='Financial Period is not valid.';
  PossMsg^[4]:='This transaction does not balance.';
  PossMsg^[5]:='Problem with transaction lines.';
  PossMsg^[6]:='Check child windows!';
  PossMsg^[7]:='This Journal contains '+CCVATName^+'. You must specify if it is Input or Output tax.';

  PossMsg^[8]:='An additional check is made via an external hook';

  


  Test:=1;

  Result:=BOn;

  BalNow:=0;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LInv do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=Not IdLineActive;

              If Assigned(IdLine) and (IdLineActive) then
                IdLine.Show;
            end;

      2  :  Result:=ValidDate(TransDate);

      3  :  Result:=ValidPeriod(StrPeriod(ConvTxYrVal(AcYr,BOff),AcPr),Syss.PrInYr);

      4  :  Result:=(Round_Up(PRequired(BOn,LInv),2)=0);

      5  :  if not ExLocal.LViewOnly then //PR: 17/11/2017 ABSEXCH-19451
              Result:=Check_LinesOk(LInv);

      6  :  Begin {* Check if all child windows are gojng to close *}
              ShowMsg:=BOff;

              GenCanClose(Self,Self,Result,BOff);

            end;

      7  :   Begin
               {$B-}
               Result:=(Not HaveVAT) or (NOMVATIO=IOVATCh[BOff]) or (NOMVATIO=IOVATCh[BOn]);
               {$B+}
             end;
      8  :   Begin {* Opportunity for hook to validate the header as well *}
                 {$IFDEF CU}

                   Result:=ValidExitHook(2000,82,ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;






    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  // CA 09/04/2013 v7.0.3 ABSEXCH-13168: AUD Nominal transaction causing an imbalance of 0.01p though when manually adding the amounts up they balance.
  If (Not Result) and (ShowMsg) then
  Begin
    {$IFDEF MC_On}

      // CA 10/04/2013 v7.0.3 ABSEXCH-13168: FNotBaseUsed This is set to false then CheckCurrency Called
      FNotBaseUsed := False;
      CheckCurrency(ExLocal.LInv);
      
      if (Test = 4) And
         (FNotBaseUsed = True) And
         ((FCreditAmount = 0.01) Or (FDebitAmount = 0.01)) Then
      Begin
         mbRet:=MessageDlg('A balancing line is required to be added to currency variance to settle this Nominal. Click the Help button for more information. ',mtWarning,[mbOk,mbHelp],40190)
      End
      else
       mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);
    {$ELSE}
       mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);
    {$ENDIF}

  End;

  Dispose(PossMsg);

end; {Func..}



Function TNtxfrForm.AutoBal  :  Boolean;

Var
  SBalnCode  :  LongInt;

Begin
  SBalnCode:=IntStr(N1SelBalF.Text);

  Result:=((N1SelBalQF.Checked) and (SBalNCode<>0));

  If (Result) then
    Result:=CheckExsists(Strip('R',[#0],FullNomKey(SBalnCode)),NomF,NomCodeK);
end;


procedure TNtxfrForm.StoreNtxfr(Fnum,
                                KeyPAth    :  Integer);


Var
  COk  :  Boolean;
  TmpInv
       :  InvRec;
  KeyS :  Str255;

  MbRet:  Word;

  Mode :  Byte;

  COwnSet,
  ResOrFull  :  Real;

  Vt  :  VATType;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState: Boolean;
  CursorState: TCursor;

Begin
  KeyS:='';

  ButtonState := OkN1Btn.Enabled;
  CursorState := Cursor;

  OkN1Btn.Enabled := False;
  try
    if not ExLocal.LViewOnly then
    begin
      RefreshFooter;

      N1AcalcVATFClick(Nil);
    end;

    Form2Ntxfr;

    COwnSet:=0;

    ResOrFull:=0;

    COk:=BOn;

    With ExLocal,LInv do
    Begin
      If not LViewOnly and (AutoBal) and (Round_Up(PRequired(BOn,LInv),2)<>0.00) and (Not LastEdit) and (Not BalDone) and (Not IdLineActive) then
      Begin
        GenCanClose(Self,Self,COk,BOff);

        If (COk) then
        Begin
          Gen_BalLines;
          BalDone:=BOn;
          MULCtrlO.PageUpDn(0,BOn);
        end;
      end;

      {$IFDEF CU} {* Call any pre store hooks here *}

        LNeedRefs:=(Not ForceStore) and (Not LastEdit); {If we enter hook with no folio assigned, let hook assign them}

        GenHooks(2000,1,ExLocal);

        If (LNeedRefs) then
          ForceStore:=LSetRefs;

      {$ENDIF}

      if not LViewOnly then
        CalcInvVATTotals(LInv,ExLocal,Not ManVAT);


      COk:=CheckCompleted(LastEdit);


      If (COk) then
      Begin

        Cursor:=crHourGlass;


        OpName:=EntryRec^.LogIn;

        CheckYRef(LInv);  {* To reset index on blank *}

        if not LViewOnly then
        begin

          OrigRates:=SyssCurr.Currencies[Currency].CRates;

          SetTriRec(Currency,UseORate,OrigTriR);

          If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) and (NomAuto)  and (HaveVAT) then  {* Cash Accounting set VATdate to Current VATPeriod Non Auto Items only *}
          Begin

             // VATPostDate:=SyssVAT.VATRates.CurrPeriod;

             VATPostDate:=CalcVATDate(TransDate);  {v5.71. CA Allows jump to future period, set from period self}

             Settled:=0.0; CurrSettled:=0.0;

             For VT:=VStart to VEnd do
             Begin
               CurrSettled:=CurrSettled+Round_Up(LInvNetAnal[Vt],2);


             end;

             CurrSettled:=Round_Up(CurrSettled+InvVAT,2)*DocNotCnst;

             Settled:=CurrSettled; {* Its all at base currency anyway *}


             {UntilDate:=Today;}

          end
          else
          Begin
            Blank(VATPostDate,sizeof(VATPostDate));
            Settled:=0.0; CurrSettled:=0.0;
          end;

        end; //if not LViewOnly

        If (LastEdit) then
        Begin
          If (Not TransactionViewOnly) then
          Begin

            Status:=LSecure_InvPut(Fnum,KeyPAth,0);

          //PR: 22/11/2011 Add audit note
          if Status = 0 then
            TAuditNote.WriteAuditNote(anTransaction, anEdit, ExLocal);


          end; {Don't store if view only}
        end
        else
        Begin {* Add new record *}
          If (VATCRate[BOn]=0.0) then
          Begin
            VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;
            SetTriRec(Syss.VATCurr,UseORate,VATTriR);
          end;

          If (Not LastEdit) and ((HoldFlg AND HoldQ)=HoldQ) then
            HoldFlg:=(HoldFlg-HoldQ); {v5.60 Clear saftey hold as header about to be stored correctly}


          If (Not ForceStore) then
          Begin
            If (NomAuto) then
              SetNextDocNos(LInv,BOn)
            else
              SetNextAutoDocNos(LInv,BOn);
          end;

          If (Not InvStored) and (Not LForcedAdd) then
          begin
            { CJS - 2013-10-25 - MRD2.6.07 - Transaction Originator }
            TransactionOriginator.SetOriginator(LInv);

            Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
          end
          else
            Status:=LSecure_InvPut(Fnum,KeyPAth,0);

          //PR: 22/11/2011 Add audit note
          if Status = 0 then
            TAuditNote.WriteAuditNote(anTransaction, anCreate, ExLocal);

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


          {If (LastEdit) then  v4.32, check under all modes}
            Check_DocChanges(LastInv,LInv);  {* Update all lines with any changes *}


        end;

        If (LastEdit) or (LForcedAdd) then
        Begin
          Delete_DocEditNow(FolioNum);

          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);
        end;


        SetNtxfrStore(BOff,BOff);

        {If (N1AutoRevF.Checked) then {* We need to auto reverse *
        Replaced in v4.31 so it is executed when posting
        Begin
          ContraCopy_Doc(FolioNum,4,'');

          Send_UpdateList(BOff,RecordPage);

        end;}

        { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
        Cursor := CursorState;

        InvStored:=BOn;

        LastValueObj.UpdateAllLastValues(Self);

        {$IFDEF CU} {* Call any post store hooks here *}

            GenHooks(2000,170,ExLocal);

        {$ENDIF}

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
    OkN1Btn.Enabled := ButtonState;
  end;

end;




procedure TNTxfrForm.EditAccount(Edit,
                                 AutoOn,
                                 ViewOnly   :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ShowLink(Edit,ViewOnly);

    ProcessNtxfr(InvF,CurrKeyPath^[InvF],LastEdit,AutoOn);
  end;
end;




procedure TNTxfrForm.N1DPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

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
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
  end;
end; {Proc..}



procedure TNTxfrForm.N1DLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      If (MULCtrlO<>nil) then
        MULCtrlO.VisiList.PrimeMove(Sender);

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



procedure TNTxfrForm.N1DLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO<>nil) then
      MULCtrlO.VisiList.MoveLabel(X,Y);

    NeedCUpdate:=MULCtrlO.VisiList.MovingLab;
  end;

end;

procedure TNTxfrForm.AddN1BtnClick(Sender: TObject);

Var
  Mode  :  Byte;

begin
  Mode:=0;

  Case Current_Page of

    NTNotesPNo
        : {$IFDEF NP}
           Begin

             SetNewFolio;

             If (NotesCtrl<>nil) then
             With ExLocal,NotesCtrl do
             Begin
               {* Reset folio, in case it changes *}

               If (FullNomKey(LInv.FolioNum) <> GetFolio) then
               Begin
                 RefreshList(FullNomkey(LInv.FolioNum),GetNType);
               end;

               NotesCtrl.AddEditNote((Sender=EditN1Btn),(Sender=InsN1Btn));
             end;

           end;
         {$ELSE}
           ;
         {$ENDIF}

    else   If ((Sender Is TButton) or (Sender Is TMenuItem))
              and ((MULCtrlO.ValidLine) or ((Sender=AddN1Btn) or (Sender=Add1))) then
           Begin
             With MULCtrlO do
               RefreshLine(MUListBoxes[0].Row,BOff);

             If (Sender=AddN1Btn) or (Sender=EditN1Btn) or (Sender=Edit1) or (Sender=Add1) then
               Mode:=1+(1*(Ord(Sender=EditN1Btn)+Ord(Sender=Edit1)));

             {* Transfer to record, so the line is upto date *}

             Form2Ntxfr;

             SetNewFolio;

             Display_Id(Mode);
           end;

  end; {Case..}

end;





procedure TNTxfrForm.DelN1BtnClick(Sender: TObject);
begin
  Case Current_Page of

    NTNotesPNo
       :  {$IFDEF NP}
            If (NotesCtrl<>nil) then
              NotesCtrl.Delete1Click(Sender);

          {$ELSE}
             ;
          {$ENDIF}

    else   DeleteNTLine;

  end; {Case..}
end;


procedure TNTxfrForm.chkI1BtnClick(Sender: TObject);
Var
  LastTotal  :  Double;

begin
  With ExLocal,LInv do
  Begin
    LastTotal:=InvNetVal;

    {Check_OtherDocs(LInv,4);}

    CalcInvVATTotals(LInv,ExLocal,Not ManVAT);

    ForceStore:=(ForceStore or (LastTotal<>InvNetVal));
  end;

  OutNTxfrTotals;
end;


procedure TNTxfrForm.SWiN1BtnClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  {$IFDEF NP}
      If (NotesCtrl<>nil) then
      With NotesCtrl do
      Begin

        If (Not MULCtrlO.InListFind) then
        begin
          //TW: 26/10/2011 v6.9 Added submenu to handle Audit History Notes
          ListPoint.X:=1;
          ListPoint.Y:=1;

          ListPoint := SwiN1Btn.ClientToScreen(ListPoint);

          PMenu_Notes.Popup(ListPoint.X, ListPoint.Y);
        end;
      end;
  {$ENDIF}
end;


procedure TNTxfrForm.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    N3.Tag:=99;

    PopUp(X,Y);
  end;


end;

procedure TNTxfrForm.PopupMenu1Popup(Sender: TObject);
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

  end; {With..}

end;


function TNTxfrForm.N1TPerFShowPeriod(Sender: TObject;
  const EPr: Byte): string;
begin
  Result:=PPr_Pr(EPr);
end;


procedure TNTxfrForm.SetNewFolio;

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

    N1ORefF.Text:=Pr_OurRef(LInv);

    HoldFlg:=HoldQ; {v5.60 auto set header on hold and clear when ok pressed so its not part of posting routine if it crashed
                     header is never stored correctly }


    { CJS - 2013-10-25 - MRD2.6.07 - Transaction Originator }
    TransactionOriginator.SetOriginator(LInv);
    N1OpoF.Hint := GetOriginatorHint(LInv);

    {* Force add of header now *}
    If (LSecure_Add(InvF,SKeypath,0)) then
      Add_DocEditNow(LInv.FolioNum);


    RefreshList(BOff,BOff);
  end;
end;


procedure TNTxfrForm.OkN1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult = mrOk) Then
      Begin
        // MH 15/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
        //                                   fields which processes the text and updates the value
        If (ActiveControl <> OkN1Btn) Then
          // Move focus to OK button to force any OnExit validation to occur
          OkN1Btn.SetFocus;

        // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
        If (ActiveControl = OkN1Btn) Then
          StoreNtxfr(InvF,SKeypath)
      End // If (ModalResult = mrOk)
      else
        If (ModalResult=mrCancel) then
        Begin
          ClsN1Btn.Click;
          Exit;
        end;
    end; {With..}
end;





procedure TNTxfrForm.N1SelBalFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  FoundLong  :  LongInt;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (AltMod) and (N1SelBalQF.Checked)
     and (ActiveControl<>CanN1Btn) and (ActiveControl<>OkN1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,2));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(NomF);



      end;


      If (FoundOk) then
      With ExLocal do
      Begin

        StillEdit:=BOff;

        Text:=Form_Int(FoundLong,0);

        {* Weird bug when calling up a list caused the Enter/Exit methods
             of the next field not to be called. This fix sets the focus to the next field, and then
             sends a false move to previous control message ... *}

        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;


procedure TNTxfrForm.Display_Id(Mode  :  Byte);


Begin


  If (IdLine=nil) then
  Begin

    IdLine:=TNTLine.Create(Self);

  end;

  Try
   //PR: 16/11/2017 ABSEXCH-19451 Allow edit posted transaction
   if FAllowPostedEdit then
     IdLine.EnableEditPostedFields;


   With IdLine do
   Begin

     WindowState:=wsNormal;
     {Show;}



     InvBtnList.SetEnabBtn(BOff);

     AutoSetIOVAT:=N1AcalcVATF.Checked;

     If (Mode In [1..3]) then
     Begin

       Case Mode of

         1..3  :   If (Not ExLocal.InAddEdit) then
                     EditLine(Self.ExLocal.LInv,(Mode=2),Self.ExLocal.LViewOnly)
                   else
                     Show;


       end; {Case..}

     end
     else
       If (Not ExLocal.InAddEdit) then
         ShowLink(Self.ExLocal.LInv,Self.ExLocal.LViewOnly);



   end; {With..}

   IdLineActive:=BOn;


  except

   IdLineActive:=BOff;

   IdLine.Free;

   InvBtnList.SetEnabBtn(BOn);

  end;

end;



procedure TNtxfrForm.DeleteNTLine;

Var
  MbRet  :  Word;
  KeyS   :  Str255;

Begin

  With ExLocal,MULCtrlO do
    If (PageKeys^[MUListBoxes[0].Row]<>0) and (ValidLine) and (Not InListFind) then
    Begin
      MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Line',
                         mtConfirmation,[mbYes,mbNo],0);

      If (MbRet=MrYes) then
      Begin

        ForceStore:=BOn;
        
        RefreshLine(MUListBoxes[0].Row,BOff);

        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,GlobLocked);

        AssignFromGlobal(IdetailF);

        If (Ok) and (GlobLocked) then
        Begin

          Status:=Delete_Rec(F[ScanFileNum],ScanFilenum,KeyPath);

          Report_BError(ScanFileNum,Status);
        end;

        If (StatusOk) then
        Begin
          With LId do
            UpdateRecBal(LInv,NomCode,(NetValue*DocNotCnst),(VAT*DocNotCnst),CXRate,Currency,UseORate,4);

            OutNTxfrTotals;

          {$IFDEF PF_On}

            If (Not EmptyKey(LId.JobCode,JobCodeLen)) then
              Delete_JobAct(LId);

          {$ENDIF}

          With MULCtrlO do
          Begin
            If (MUListBox1.Row<>0) then
              PageUpDn(0,BOn)
            else
              InitPage;
          end;

        end;
      end;
    end; {If line is valid for deletion..}
end; {PRoc..}


procedure TNTxfrForm.N1TDateFExit(Sender: TObject);
begin
  With ExLocal,LInv,N1TDateF do
    If {(DateModified) and} (Not LastEdit) and (ValidDate(DateValue)) then
    Begin
      TransDate:=DateValue;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
      With N1TPerF do
      Begin
        Date2Pr(TransDate,AcPr,AcYr,@ExLocal);

        InitPeriod(AcPr,AcYr,BOn,BOn);
      end;

    end;

end;

procedure TNTxfrForm.THUD1FEntHookEvent(Sender: TObject);
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
                //GS 18/10/2011 ABSEXCH-11706: create branches for the new UDFs
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
                                  If (Sender=N1YRefF) then
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
              //GS 18/10/2011 ABSEXCH-11706: put customisation object vals into UDFs
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

procedure TNTxfrForm.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>CanN1Btn) and (ActiveControl<>ClsN1Btn) then
  Begin

    Text8pt(Sender).ExecuteHookMsg;

  end;

end;


procedure TNTxfrForm.SetFieldProperties;

Var
  n  : Integer;


Begin
  N1BtmPanel.Color:=N1FPanel.Color;
  N1BtnPanel.Color:=N1FPanel.Color;

  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) and (Components[n]<>N1YrefF) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(N1YrefF.Font);
        Color:=N1YrefF.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        CheckColor:=clBlack;
        Color:=N1FPanel.Color;
      end;

  end; {Loop..}

end;


procedure TNTxfrForm.SetFormProperties(SetList  :  Boolean);

Const
  PropTit     :  Array[BOff..BOn] of Str5 = ('Form','List');



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

    If (SetList) then
    Begin
      With MULCtrlO.VisiList do
      Begin
        VisiRec:=List[0];

        TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
        TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

        TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
        TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


        TmpPanel[3].Color:=MULCtrlO.ColAppear^[0].HBKColor;
      end;

      TmpPanel[3].Font.Assign(TmpPanel[1].Font);

      TmpPanel[3].Font.Color:=MULCtrlO.ColAppear^[0].HTextColor;
    end
    else
    Begin
      TmpPanel[1].Font:=N1YrefF.Font;
      TmpPanel[1].Color:=N1YrefF.Color;

      TmpPanel[2].Font:=N1FPanel.Font;
      TmpPanel[2].Color:=N1FPanel.Color;
    end;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],Ord(SetList),Self.Caption+' '+PropTit[SetList]+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);
        FColorsChanged := NeedCUpdate;

        If (BeenChange) and (not ResetDefaults) then
        Begin

          If (SetList) then
          Begin
            For n:=1 to 3 do
              With TmpPanel[n] do
                Case n of
                  1,2  :  MULCtrlO.ReColorCol(Font,Color,(n=2));

                  3    :  MULCtrlO.ReColorBar(Font,Color);
                end; {Case..}

            MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
          end
          else
          Begin
            N1FPanel.Font.Assign(TmpPanel[2].Font);
            N1FPanel.Color:=TmpPanel[2].Color;

            N1YrefF.Font.Assign(TmpPanel[1].Font);
            N1YrefF.Color:=TmpPanel[1].Color;

            SetFieldProperties;
          end;
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


procedure TNTxfrForm.PropFlgClick(Sender: TObject);
begin
  SetFormProperties((N3.Tag=99));
  N3.Tag:=0;
end;



procedure TNTxfrForm.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;


procedure TNTxfrForm.Tidy_BalLines(Const  Fnum,Keypath  :  Integer);

Var
  KeyChk,KeyS  :  Str255;


Begin
  With ExLocal,LInv do
  Begin
    KeyChk:=FullIdKey(FolioNum,Pred(RecieptCode));
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) do
    With LId do
    Begin

      LineNo:=RecieptCode;

      Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    end; {while..}

  end; {with..}
end;


procedure TNTxfrForm.Gen_BalLines;

Const
  Fnum     =  IDetailF;
  Keypath  =  IdFolioK;

Var
  KeyChk,KeyS  :  Str255;


Begin
  With ExLocal,LInv do
  Begin
    KeyChk:=FullIdKey(FolioNum,RecieptCode);
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) do
    With LId do
    Begin

      LineNo:=Pred(LineNo);

      Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      If (StatusOk) then
      Begin
        NetValue:=(NetValue+VAT)*DocNotCnst;

        VAT:=0.0;
        VATCode:=C0;
        NOMIOFlg:=0;

        {If (NOMIOFlg>0) then
        Begin
          VAT:=VAT*DocNotCnst;

          If (NomIOFlg=1) then
            NomIOFlg:=2
          else
            NomIOFlg:=1;
        end
        else
        Begin
          VAT:=0.0;
          VATCode:=C0;

        end;}

        NomCode:=IntStr(N1SelBalF.Text);

        ABSLineNo:=LInv.ILineCount;

        Blank(JobCode,Sizeof(JobCode));
        Blank(Analcode,Sizeof(Analcode));

        Inc(LInv.ILineCount);

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum,Status);

        If (StatusOk) then
        Begin
          UpdateRecBal(LInv,NomCode,NetValue,VAT,CXRate,Currency,UseORate,4);

          {Update_JobAct(LId,LInv);  EL: This taken out as it would only serve to generate an opposite canceling the original line out.
            If you do not want any effect on JC, then do not use a job code! *}
        end;
      end;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    end; {while..}

  end; {with..}

  Tidy_BalLines(Fnum,Keypath);

  OutNtxfrTotals;
end;

procedure TNTxfrForm.N1SelBalFEnter(Sender: TObject);
begin
  If (ExLocal.InAddEdit) then
    N1SelBalF.ReadOnly:=Not N1SelBalQF.Checked;
end;


procedure TNTxfrForm.LnkN1BtnClick(Sender: TObject);
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
                                 Nil, Nil, @ExLocal.LInv, Nil, Nil);
    Except
     LetterActive := BOff;
     LetterForm.Free;
    End;
  {$ENDIF}
end;





procedure TNTxfrForm.I5VV1FExit(Sender: TObject);
begin
  {VATMatrix.Update_Rate(Sender,ExLocal.LInv); Was corrupting the contents of NTIOHedCB, plus no need to have.
  ReFreshFooter;}
end;

procedure TNTxfrForm.N1AcalcVATFClick(Sender: TObject);
begin
  If (N1ACalcVATF.Checked) and (Not VIOBeenThere) then
  Begin
    NTIOHedCB.ItemIndex:=Ord(ExLocal.LInv.InvVAT<>0.0)+Ord(ExLocal.LInv.InvVAT<0.0);
  end;
end;

procedure TNTxfrForm.NTIOHedCBEnter(Sender: TObject);
begin
  VIOBeenThere:=BOn;
end;

procedure TNTxfrForm.SetHelpContextIDs; // NF: 24/07/06
begin
  // NF: 24/07/06 Fixes for incorrect Context IDs
  N1YRefF.HelpContext := 2072;
end;


// MHYR 25/10/07
procedure TNTxfrForm.N1YRef2FChange(Sender: TObject);
begin
  N1YRef2F.Hint := N1YRef2F.Text;
end;

procedure TNTxfrForm.MenItem_AuditClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmAudit);
end;

procedure TNTxfrForm.MenItem_DatedClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmDated);
end;

procedure TNTxfrForm.MenItem_GeneralClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmGeneral);
end;

procedure TNTxfrForm.SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
begin
  //Called when user uses Switch from pop-up menu on Notes form
  AddN1Btn.Enabled := NewMode <> nmAudit;
  EditN1Btn.Enabled := NewMode <> nmAudit;
  InsN1Btn.Enabled := NewMode <> nmAudit;
  DelN1Btn.Enabled := NewMode <> nmAudit;
end;
procedure TNTxfrForm.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;

  //Description & Your rRef
  N1YRefF.AllowPostedEdit := True;
  N1YRef2F.AllowPostedEdit := True;

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

  ClsN1Btn.Visible := False;
  ClsN1Btn.Enabled := False;
  OkN1Btn.Top := CanN1Btn.Top + 6;
  CanN1Btn.Top := ClsN1Btn.Top + 6;


end;

function TNTxfrForm.TransactionViewOnly: Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;

Initialization

end.
