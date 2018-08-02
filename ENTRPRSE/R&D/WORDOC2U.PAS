unit WORDoc2U;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, TEditVal, BorBtns, Mask, ComCtrls,

  GlobVar,VarConst,ExWrap1U,BTSupU1,SupListU,SBSComp2,

  SalTxL1U,

  ExtGetU,

  WORLineU,

  {$IFDEF NP}
    NoteU,
  {$ENDIF}

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  {$IFDEF CU}
  // 28/01/2013 PKR ABSEXCH-13449
  CustomBtnHandler,
  {$ENDIF}
    
  Menus, Gauges, TCustom;



type
  TWORMList  =  Class(TDDMList)

  Public
    CtrlBOM  :  IDetail;

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;


  end;


type
  TWOR = class(TForm)
    PageControl1: TPageControl;
    AdjustPage: TTabSheet;
    A1SBox: TScrollBox;
    A1HedPanel: TSBSPanel;
    A1CLab: TSBSPanel;
    A1GLab: TSBSPanel;
    A1OLab: TSBSPanel;
    A1DLab: TSBSPanel;
    A1ILab: TSBSPanel;
    A1CCLab: TSBSPanel;
    A1DpLab: TSBSPanel;
    A1CPanel: TSBSPanel;
    A1IPanel: TSBSPanel;
    A1GPanel: TSBSPanel;
    A1DPanel: TSBSPanel;
    A1OPanel: TSBSPanel;
    A1CCPanel: TSBSPanel;
    A1DpPanel: TSBSPanel;
    A1BtmPanel: TSBSPanel;
    CCPanel: TSBSPanel;
    CCTit: Label8;
    DepTit: Label8;
    CCLab: Label8;
    CostPanel: TSBSPanel;
    IssuePanel: TSBSPanel;
    A1ListBtnPanel: TSBSPanel;
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
    A1BtnPanel: TSBSPanel;
    OkN1Btn: TButton;
    CanN1Btn: TButton;
    ClsN1Btn: TButton;
    A1BSBox: TScrollBox;
    AddN1Btn: TButton;
    EditN1Btn: TButton;
    DelN1Btn: TButton;
    InsN1Btn: TButton;
    SwiN1Btn: TButton;
    A1BPanel: TSBSPanel;
    A1BLab: TSBSPanel;
    A1UPanel: TSBSPanel;
    A1ULab: TSBSPanel;
    DepLab: Label8;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label85: Label8;
    Label86: Label8;
    A1StatLab: Label8;
    A1FPanel: TSBSPanel;
    Label817: Label8;
    Label84: Label8;
    Label88: Label8;
    A1OrefF: Text8Pt;
    A1OpoF: Text8Pt;
    A1TDateF: TEditDate;
    A1TPerF: TEditPeriod;
    A1CompF: Text8Pt;
    A1LocPanel: TSBSPanel;
    A1LocLab: TSBSPanel;
    LnkN1Btn: TButton;
    A1LocTxF: Text8Pt;
    LTxfrLab: Label8;
    I1AccF: Text8Pt;
    Label89: Label8;
    A1CDateF: TEditDate;
    Label811: Label8;
    Bevel1: TBevel;
    TransExtForm1: TSBSExtendedForm;
    I1YrRefL: Label8;
    I1YrRef2L: Label8;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    A1YRefF: Text8Pt;
    I1YrRef2F: Text8Pt;
    Label87: Label8;
    A1UOPanel: TSBSPanel;
    A1UOLab: TSBSPanel;
    A1OSPanel: TSBSPanel;
    A1OSLab: TSBSPanel;
    A1BUPanel: TSBSPanel;
    A1BULab: TSBSPanel;
    A1IssPanel: TSBSPanel;
    A1IssLab: TSBSPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label810: Label8;
    LocLab: Label8;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Insert1: TMenuItem;
    Switch1: TMenuItem;
    Links1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    FinPanel: TSBSPanel;
    Label812: Label8;
    IssLab: Label8;
    ChkBtn: TButton;
    Check1: TMenuItem;
    APickI1Btn: TButton;
    AutoPick1: TMenuItem;
    PopupMenu2: TPopupMenu;
    AP1: TMenuItem;
    AW1: TMenuItem;
    Ap2: TMenuItem;
    AW2: TMenuItem;
    Label813: Label8;
    Gauge1: TGauge;
    Gauge2: TGauge;
    Label814: Label8;
    Label815: Label8;
    A1BldF: TCurrencyEdit;
    Label816: Label8;
    Label818: Label8;
    A1IssF: TCurrencyEdit;
    WORI1Btn: TButton;
    WorksOrder1: TMenuItem;
    MatI1Btn: TButton;
    Match1: TMenuItem;
    Build1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    FindN1Btn: TButton;
    Find1: TMenuItem;
    N6: TMenuItem;
    AW3: TMenuItem;
    CustTxBtn2: TSBSButton;
    CustTxBtn1: TSBSButton;
    CustTxBtn3: TSBSButton;
    CustTxBtn4: TSBSButton;
    CustTxBtn5: TSBSButton;
    CustTxBtn6: TSBSButton;
    Custom1: TMenuItem;
    Custom2: TMenuItem;
    Custom3: TMenuItem;
    Custom4: TMenuItem;
    Custom5: TMenuItem;
    Custom6: TMenuItem;
    EntCustom3: TCustomisation;
    RetI1Btn: TButton;
    Return1: TMenuItem;
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
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    function A1TPerFConvDate(Sender: TObject; const IDate: string;
      const Date2Pr: Boolean): string;
    procedure A1CPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A1CLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A1CLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AddN1BtnClick(Sender: TObject);
    procedure DelN1BtnClick(Sender: TObject);
    procedure SwiN1BtnClick(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    function A1TPerFShowPeriod(Sender: TObject; const EPr: Byte): string;
    procedure OkN1BtnClick(Sender: TObject);
    procedure ClsN1BtnClick(Sender: TObject);
    procedure A1TDateFExit(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure LnkN1BtnClick(Sender: TObject);
    procedure A1LocTxFExit(Sender: TObject);
    procedure I1AccFExit(Sender: TObject);
    procedure ChkBtnClick(Sender: TObject);
    procedure APickI1BtnClick(Sender: TObject);
    procedure AP1Click(Sender: TObject);
    procedure WORI1BtnClick(Sender: TObject);
    procedure MatI1BtnClick(Sender: TObject);
    procedure Build1Click(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure FindN1BtnClick(Sender: TObject);
    procedure AW3Click(Sender: TObject);
    procedure CustTxBtn1Click(Sender: TObject);
    procedure RetI1BtnClick(Sender: TObject);
    procedure A1YRefFChange(Sender: TObject);
    procedure I1YrRef2FChange(Sender: TObject);
    procedure SetUDFields(UDDocHed  :  DocTypes);
    procedure MenItem_AuditClick(Sender: TObject);
    procedure MenItem_DatedClick(Sender: TObject);
    procedure MenItem_GeneralClick(Sender: TObject);
  private
    JustCreated,
    InvStored,
    StopPageChange,
    FirstStore,
    ReCalcTot,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    BalDone,
    fFrmClosing,
    fDoingClose,
    fRecordLocked,
    CouldIssue,
    GotCoord,
    CanDelete    :  Boolean;

    SKeypath,
    MinHeight,
    MinWidth     :  Integer;

    {$IFDEF NP}
      NotesCtrl  :  TNoteCtrl;
    {$ENDIF}

    InvBtnList   :  TVisiBtns;

    IdLine       :  TWORLine;
    IdLineActive :  Boolean;

    BOMId        :  IDetail;

    RecordPage   :  Byte;
    DocHed       :  DocTypes;

    OldConTot    :  Double;

    MatchOrdPtr  :  Pointer;

    PagePoint    :  Array[0..6] of TPoint;

    StartSize,
    InitSize     :  TPoint;

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}

    {$IFDEF CU}
    // 28/01/2013  PKR   ABSEXCH-13449/38
    FormPurpose : TFormPurpose;
    RecordState : TRecordState;
    {$ENDIF}

    //PR: 20/11/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;
    function TransactionViewOnly : Boolean;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Procedure SetForceStore(State  :  Boolean);

    procedure NotePageReSize;

    Procedure Link2Nom;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;


    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Function CheckNeedStore  :  Boolean;

    Function ConfirmQuit  :  Boolean;

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure Display_Id(Mode  :  Byte);

    procedure DeleteNTLine;

    procedure SetFormProperties(SetList  :  Boolean);

    procedure SetFieldProperties;

    Procedure AdjStkDeduct(Mode  :  Byte);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure Display_PayIn(ChangeFocus   :  Boolean);
    procedure SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
  public
    { Public declarations }

    fForceStore:  Boolean;

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;

    MULCtrlO   :  TWORMList;


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

    procedure HideListColumns(PageNo  :  Integer);

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

    Procedure GetLineCBuild;

    procedure SetNTxfrFields;

    procedure OutNTxfr;

    Procedure OutNTxfrTotals;

    procedure Form2NTxfr;

    Procedure SetFieldFocus;

    Procedure NoteUpdate;

    procedure SetNewFolio;

    procedure ProcessNtxfr(Fnum,
                           KeyPAth    :  Integer;
                           Edit,
                           AutoOn     :  Boolean);

    Function CheckCompleted(Edit  :  Boolean)  : Boolean;

    Function Check_LinesOk(InvR  :  InvRec)  :  Boolean;

    procedure Synch_BOMCost;

    procedure StoreNtxfr(Fnum,
                         KeyPAth    :  Integer);

    procedure EditAccount(Edit,
                          AutoOn,
                          ViewOnly   :  Boolean);

    //PR: 20/11/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;

  end;

  Procedure Set_WORFormMode(State  :  DocTypes;
                            NPage  :  Byte);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
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

  SBSComp,

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

  {$IFDEF NOM}
    NLPayInU,
  {$ENDIF}

  InvCTSUU,

  SysU1,
  SysU2,
  SysU3,
  IntMU,
  MiscU,
  PayF2U,

  {$IFDEF SOP}
    InvLst3U,
  {$ENDIF}

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  {$IFDEF RET}
    RetSup1U,
    RetWiz1U,
  {$ENDIF}

  Event1U,
  PWarnU,
  GenWarnU,
  SalTxl2U,
  WOPCT1U,
  WOBOMIsU,
  WORIWizU,
  AdjCtrlU,
  //GS 17/10/ 2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF,

  { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
  TransactionOriginator,

  AuditNotes;



{$R *.DFM}


Const
  MainPage  =  0;
  AnalPage  =  1;
  BuildPage =  2;
  MatchPage =  3;
  NotePage  =  4;


Var
  WORFormMode  :  DocTypes;
  WORFormPage  :  Byte;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_WORFormMode(State  :  DocTypes;
                          NPage  :  Byte);

Begin
  If (State<>WORFormMode) then
    WORFormMode:=State;

  If (WORFormPage<>NPage) then
    WORFormPage:=NPage;

end;




{$I WORI1U.PAS}



Procedure  TWOR.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TWOR.Find_FormCoord;


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

    GetbtControlCsm(A1SBox);

    GetbtControlCsm(A1BSBox);

    GetbtControlCsm(A1BtnPanel);

    GetbtControlCsm(A1ListBtnPanel);

    GetbtControlCsm(TCNScrollBox);
    GetbtControlCsm(TCNListBtnPanel);


    If GetbtControlCsm(A1YrefF) then
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


procedure TWOR.Store_FormCoord(UpMode  :  Boolean);


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

    StorebtControlCsm(A1SBox);

    StorebtControlCsm(A1BSBox);

    StorebtControlCsm(A1BtnPanel);

    StorebtControlCsm(A1ListBtnPanel);

    StorebtControlCsm(A1YrefF);

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




procedure TWOR.SetForceStore(State  :  Boolean);

Begin
  If (State<>fForceStore) then
  Begin
    fForceStore:=State;

    If (Not ExLocal.LViewOnly) then
    Begin
      ClsN1Btn.Enabled:=Not fForceStore;
      CanN1Btn.Enabled:=ClsN1Btn.Enabled;
    end;
  end;
end;


Function TWOR.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;


Procedure TWOR.Link2Nom;

Var
  FoundOk   :  Boolean;
  FoundLong :  LongInt;
  FoundStk  :  Str20;

Begin
  With Id do
  Begin

    LocLab.Caption:=MLocStk;

    {$IFDEF PF_On}

      If (Syss.UseCCDep) then
      Begin
        CCLab.Caption:=CCDep[BOn];
        DepLab.Caption:=CCDep[BOff];
      end;



    {$ENDIF}

    {$IFDEF STK} {* Link up for List auto search to work *}
      With ExLocal do
      If (Is_FullStkCode(StockCode)) and (LStock.StockCode<>StockCode) then
      Begin
        GetStock(Self,StockCode,FoundStk,-1);
        AssignFromGlobal(StockF);

        SendToObjectStkEnq(StockCode,MLocStk,'',-1,-1,0);

      end;
    {$ENDIF}

  end;
end;


Procedure TWOR.WMCustGetRec(Var Message  :  TMessage);
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

                NotePage
                       :  AddN1BtnClick(EditN1Btn);

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

      25  :  NeedCUpdate:=BOn;


     108  :
             Begin
               With MULCtrlO do
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));

               If (IdLine<>nil) then
               With ExLocal do
               Begin
                 LInv:=IdLine.ExLocal.LInv;

                 CouldIssue:=(CouldIssue or ((IdLine.ExLocal.LId.QtyPick<>0.0) and (IdLine.ExLocal.LId.LineNo<>1)));

                 OutNTxfrTotals;

                 If (LastEdit) and (Not LViewOnly) and (Not ForceStore) then
                   ForceStore:=((LInv.ILineCount<>LastInv.ILineCount) or
                                (Linv.TotalCost<>LastInv.TotalCost) or
                                (Linv.TotalInvoiced<>LastInv.TotalInvoiced));

                 If (IdLine.ExLocal.LId.LineNo=1) then {Its been edited, pick up new version}
                   BOMId:=IdLine.ExLocal.LId;
               end;


            end;

    120,121
         :  Begin

              InvBtnList.SetEnabBtn((WParam=120));

            end;
     {$IFDEF SOP}

       131 :  With MULCtrlO do
              Begin
                If (PageKeys^[0]<>0) then
                Begin
                  PageUpDn(0,BOn);
                end;

                If (PageKeys^[0]=0) then  {Sometimes a ghost line 1 exists which PaheUpDn will reset, so we have another go}
                  InitPage;

                If (IdLine<>nil) then
                With ExLocal do
                Begin
                  LInv:=IdLine.ExLocal.LInv;
                  OutNTxfrTotals;
                  ReCalcTot:=BOn;
                end;

              end;
     {$ENDIF}

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
                      NotePage
                         :  {$IFDEF NP}
                              If (Assigned(NotesCtrl)) then
                                NotesCtrl.MULCtrlO.SetListFocus;
                            {$ELSE}
                              ;
                            {$ENDIF}

                      else  If (Assigned(MULCtrlO)) then
                              MULCtrlO.SetListFocus;

                    end; {Case..}
            end; {Case..}



     200 :  Begin

              IdLine:=nil;
              IdLineActive:=BOff;

              InvBtnList.SetEnabBtn(BOn);

              MULCtrlO.SetListFocus;
            end;

     {$IFDEF Ltr}
       400,
       401  : Begin
                LetterActive:=Boff;
                LetterForm:=nil;
              end;
     {$ENDIF}

     {$IFDEF GF}

     3003
           : If (Assigned(FindCust)) then
               With MULCtrlO,FindCust,ReturnCtrl do
               Begin
                 InFindLoop:=BOn;

                 Find_OnList(7,Trim(RecMainKey));


                 InFindLoop:=BOff;
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

Procedure TWOR.WMFormCloseMsg(Var Message  :  TMessage);
Begin


  With Message do
  Begin


    Case WParam of

      48  :  MatchOrdPtr:=nil;

    end; {Case..}

  end;
  Inherited;
end;


Procedure TWOR.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TWOR.Send_UpdateList(Edit   :  Boolean;
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


procedure TWOR.ShowLink(ShowLines,
                               VOMode    :  Boolean);
begin
  ExLocal.AssignFromGlobal(InvF);
  ExLocal.LGetRecAddr(InvF);

  With ExLocal,LInv do
  Begin
    Caption:=DocNames[InvDocHed]+' Record - '+Pr_OurRef(LInv);

    {$B-}

    LViewOnly:=SetViewOnly(ShowLines,VOMode);

    If (CheckRecExsists(FullIdKey(LInv.FolioNum,1),IDetailF,IdFOlioK)) then
      BOMId:=Id;

    PrimeButtons;

    {$B+}

    If (Not LViewOnly) and (LastEdit) then
      GetLineCBuild;


  end;


  OutNTxfr;

  

  ReFreshList(ShowLines,Not JustCreated);

  {$IFDEF NP}

    If (Current_Page=NotePage) and (NotesCtrl<>nil) then {* Assume record has changed *}
    With ExLocal do
    Begin
      NotesCtrl.RefreshList(FullNomKey(LInv.FolioNum),NotesCtrl.GetNType);
      NotesCtrl.GetLineNo:=LInv.NLineCount;
    end;
  {$ENDIF}

  JustCreated:=BOff;

end;


procedure TWOR.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(A1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(A1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(A1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(A1BtnPanel.Height);

  PagePoint[3].X:=A1BtnPanel.Height-(A1BSBox.Height);
  PagePoint[3].Y:=A1SBox.ClientHeight-(A1DPanel.Height);

  PagePoint[4].X:=PageControl1.Width-(A1ListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(A1ListBtnPanel.Height);

  PagePoint[5].X:=PageControl1.Width-(TCNScrollBox.Width);
  PagePoint[5].Y:=PageControl1.Height-(TCNScrollBox.Height);

  PagePoint[6].Y:=PageControl1.Height-(TCNListBtnPanel.Height);


  GotCoord:=BOn;

end;


Function TWOR.SetHelpC(PageNo :  Integer;
                             Pages  :  TIntSet;
                             Help0,
                             Help1  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    If (PageNo=NotePage) then
      Result:=Help1
    else
      Result:=Help0;
  end
  else
    Result:=-1;

end;

procedure TWOR.PrimeButtons;

Var
  PageNo  :  Integer;
  TheCaption    :  ShortString;

  {$IFDEF CU}
  // 25/01/2013 PKR ABSEXCH-13449
  cBtnIsEnabled : Boolean;
  TextID        : integer;
  {$ENDIF}

Begin
  PageNo:=Current_Page;

  TheCaption:='';

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
        Begin
    {00}  AddVisiRec(AddN1Btn,BOff);
    {01}  AddVisiRec(EditN1Btn,BOff);
    {02}  AddVisiRec(DelN1Btn,BOff);
    {03}  AddVisiRec(InsN1Btn,BOff);
    {04}  AddVisiRec(FindN1Btn,BOff);
    {05}  AddVisiRec(SwiN1Btn,BOff);
    {06}  AddVisiRec(APickI1Btn,BOff);
    {07}  AddVisiRec(WORI1Btn,BOff);
    {08}  AddVisiRec(RETI1Btn,{$IFDEF RET} BOff {$ELSE} BOn {$ENDIF});
    {09}  AddVisiRec(MATI1Btn,BOff);
    {10}  AddVisiRec(ChkBtn,BOff);
    {11}  AddVisiRec(LnkN1Btn,BOff);
    {12} AddVisiRec(CustTxBtn1,BOff);
    {13} AddVisiRec(CustTxBtn2,BOff);
          // 17/01/2013 PKR ABSEXCH-13449
          // Custom buttons 3..6 now available
    {14}  AddVisiRec(CustTxBtn3,BOff);
    {15}  AddVisiRec(CustTxBtn4,BOff);
    {16}  AddVisiRec(CustTxBtn5,BOff);
    {17}  AddVisiRec(CustTxBtn6,BOff);
        end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    With InvBtnList do
    Begin

      SetHideBtn(0,((ExLocal.LViewOnly) and ((PageNo<>NotePage) or (fRecordLocked))) or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],394,-255))),BOff);
      SetHideBtn(1,((ExLocal.LViewOnly) and (PageNo=NotePage) and (fRecordLocked)) or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],395,-255))) ,BOff);



      SetBtnHelp(0,SetHelpC(PageNo,[MainPage..NotePage],260,88));
      SetBtnHelp(1,SetHelpC(PageNo,[MainPage..NotePage],261,87));


      SetHideBtn(2,((ExLocal.LViewOnly) and ((PageNo<>NotePage) or (fRecordLocked))) or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],396,-255))),BOff);
      SetBtnHelp(2,SetHelpC(PageNo,[MainPage..NotePage],263,89));


      SetHideBtn(3,(ExLocal.LViewOnly) or (fRecordLocked) and (PageNo<>NotePage) or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],397,-255))),BOff);
      SetHideBtn(5,(PageNo<>NotePage),BOff);

      SetHideBtn(6,((ExLocal.LViewOnly) or (fRecordLocked)) or (PageNo In [NotePage]) or Is_StdWOP or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],398,-255))),BOff);

      SetHideBtn(7,(PageNo In [NotePage]) or ((Not ExLocal.LastEdit) and (Not ExLocal.LViewOnly)) or (Not FullWOP) or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],399,-255))),BOff);

      {$IFDEF RET}                                                                    
        SetHideBtn(8,(PageNo In [NotePage]) or (Not ExLocal.LastEdit)  or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],574,-254))) or (Not RetMOn),BOff);
      {$ENDIF}

      SetHideBtn(9,(PageNo In [NotePage]) or ((Not ExLocal.LastEdit) and (Not ExLocal.LViewOnly)) or (Not FullWOP),BOff);

      SetHideBtn(10,((ExLocal.LViewOnly) or (fRecordLocked)) or (PageNo In [NotePage]),BOff);
      SetHideBtn(11,(PageNo In [NotePage]),BOn);

      {$IFDEF CU}
        // 28/01/2013 PKR ABSEXCH-13449
        // Use the custom button handler.
        FormPurpose := fpWorksOrder;
        if ExLocal.LViewOnly then
          recordState := rsView
        else
          recordState := rsEdit;

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn1.Tag);
        {12}  SetHideBtn(12, not cBtnIsEnabled, BOff);
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn2.Tag);
        {13}  SetHideBtn(13, not cBtnIsEnabled, BOn);
              // 24/01/2013 PKR ABSEXCH-13449
              // Custom buttons 3..6 now available
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn3.Tag);
        {14}  SetHideBtn(14, not cBtnIsEnabled, BOn);
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn4.Tag);
        {15}  SetHideBtn(15, not cBtnIsEnabled, BOn);
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn5.Tag);
        {16}  SetHideBtn(16, not cBtnIsEnabled, BOn);
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn6.Tag);
        {17}  SetHideBtn(17, not cBtnIsEnabled, BOn);

(*
        {11}  SetHideBtn(12,Not EnableCustBtns(2000,43+(100*Ord(ExLocal.LViewOnly))),BOff);
        {12}  SetHideBtn(13,Not EnableCustBtns(2000,44+(100*Ord(ExLocal.LViewOnly))),BOn);
*)

        TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustTxBtn1.tag);
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, TextID, TheCaption, CustTxBtn1.Font);
        CustTxBtn1.Caption:=TheCaption;

        TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustTxBtn2.tag);
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, TextID, TheCaption, CustTxBtn2.Font);
        CustTxBtn2.Caption:=TheCaption;

        // 28/01/2013 PKR ABSEXCH-13449
        // Custom buttons 3..6 now available
        TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustTxBtn3.tag);
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, TextID, TheCaption, CustTxBtn3.Font);
        CustTxBtn3.Caption:=TheCaption;

        TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustTxBtn4.tag);
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, TextID, TheCaption, CustTxBtn4.Font);
        CustTxBtn4.Caption:=TheCaption;

        TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustTxBtn5.tag);
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, TextID, TheCaption, CustTxBtn5.Font);
        CustTxBtn5.Caption:=TheCaption;

        TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustTxBtn6.tag);
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, TextID, TheCaption, CustTxBtn6.Font);
        CustTxBtn6.Caption:=TheCaption;

(*
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, 30+(100*Ord(ExLocal.LViewOnly)), TheCaption, CustTxBtn1.Font);
        CustTxBtn1.Caption:=TheCaption;

        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, 31+(100*Ord(ExLocal.LViewOnly)), TheCaption, CustTxBtn2.Font);
        CustTxBtn2.Caption:=TheCaption;
*)

      {$ELSE}
        {11}  SetHideBtn(12,BOn,BOff);
        {12}  SetHideBtn(13,BOn,BOn);
        // 17/01/2013 PKR ABSEXCH-13449
        // Custom buttons 3..6 now available
        {13}  SetHideBtn(14,BOn,BOn);
        {14}  SetHideBtn(15,BOn,BOn);
        {15}  SetHideBtn(16,BOn,BOn);
        {16}  SetHideBtn(17,BOn,BOn);

      {$ENDIF}

    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure TWOR.BuildDesign;

Var
  HideCC,
  HideLoc  :  Boolean;

begin

  {* Set Version Specific Info *}


  A1YRefF.MaxLength:=DocYRef2Len;

  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}


  {CCPanel.Visible:=Not HideCC;}


  A1BldF.Visible:=Not Is_StdWOP;
  Label814.Visible:=A1BldF.Visible;
  Label815.Visible:=A1BldF.Visible;

  If (Not A1BldF.Visible) then
  Begin
    Label818.Caption:='build';

  end;

  A1IssF.DecPlaces:=Syss.NoQtyDec;
  A1BldF.DecPlaces:=Syss.NoQtyDec;

  {$IFNDEF SOP}

    HideLoc:=BOn;

    AW2.Visible:=BOff;
    Ap2.Visible:=BOff;
  {$ELSE}

    HideLoc:=Not Syss.UseMLoc;
  {$ENDIF}

  If (HideLoc) then
  Begin
    A1LocTxF.Visible:=BOff;
    LTxFrLab.Visible:=BOff;
    Label810.Visible:=BOff;
    LocLab.Visible:=BOff;
  end;

  If (HideCC and HideLoc) then
    CCPanel.Visible:=BOff
  else
    If HideCC then
    Begin
      CCTit.Visible:=BOff;
      CCLab.Visible:=BOff;
      DepTit.Visible:=BOff;
      DepLab.Visible:=BOff;

      Label810.Left:=CCTit.Left;
      LocLab.Left:=CCLab.Left;
    end;

  CreateSubMenu(PopUpMenu2,AutoPick1);

  CostPanel.Visible:=PChkAllowed_In(143);
  IssuePanel.Visible:=CostPanel.Visible;

  (*
  UDF1L.Caption:=Get_CustmFieldCaption(2,9);
  UDF1L.Visible:=Not Get_CustmFieldHide(2,9);

  THUD1F.Visible:=UDF1L.Visible;

  UDF2L.Caption:=Get_CustmFieldCaption(2,10);
  UDF2L.Visible:=Not Get_CustmFieldHide(2,10);

  THUD2F.Visible:=UDF2L.Visible;


  UDF3L.Caption:=Get_CustmFieldCaption(2,11);
  UDF3L.Visible:=Not Get_CustmFieldHide(2,11);

  THUD3F.Visible:=UDF3L.Visible;


  UDF4L.Caption:=Get_CustmFieldCaption(2,12);
  UDF4L.Visible:=Not Get_CustmFieldHide(2,12);

  THUD4F.Visible:=UDF4L.Visible;

  TransExtform1.ReAssignFocusLast;

  If (Not THUD1F.Visible) or (Not THUD2F.Visible) or (Not THUD3F.Visible) or (Not THUD4F.Visible) then
  With TransExtForm1 do
  Begin
    If ((Not THUD1F.Visible) and (Not THUD2F.Visible) and (Not THUD3F.Visible) and (Not THUD4F.Visible)) then
      ExpandedHeight:=Height;

  end;
  *)

  SetUDFields(DocHed);

end;

//GS 14/10/2011 ABSEXCH-11706: a copy of pauls user fields function
//PR: 14/11/2011 Amended to use centralised function EnableUdfs in CustomFieldsIntf.pas ABSEXCH-12129
procedure TWOR.SetUDFields(UDDocHed  :  DocTypes);
begin
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L, UDF11L, UDF12L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F],
             cfWORHeader);

  ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F]),
                           2, //UDFs laid out on the UI as 2 columns, 5 rows
                           TransExtForm1,
                           0,     // RowHeightOverRide
                           12);   // UDF_Count
end;

procedure TWOR.FormDesign;


begin

  PrimeButtons;

  BuildDesign;

end;

procedure TWOR.HidePanels(PageNo    :  Byte);

Var
  TmpBo  :  Boolean;
  n      :  Integer;

Begin
  With MULCtrlO,VisiList do
  Begin
    fBarOfSet:=Current_BarPos(PageNo);

    Case PageNo of

      MainPage
         :  Begin
              For n:=2 to 13 do
                SetHidePanel(FindxColOrder(n),(n>=9),(n=13));

            end;
      AnalPage
         :  Begin
              For n:=2 to 13 do
                SetHidePanel(FindxColOrder(n),(((n<9) and (n>3)) or (n=2)),BOff);

              {$IFNDEF PF_On}
                TmpBo:=BOn;
              {$ELSE}
                TmpBo:=Not Syss.UseCCDep;
              {$ENDIF}

              SetHidePanel(FindxColOrder(9),Not PChkAllowed_In(143),BOff); {Hide Cost if hide gp set}
              SetHidePanel(FindxColOrder(10),Not Syss.UseMLoc,BOff);
              SetHidePanel(FindxColOrder(12),TmpBo,BOff);
              SetHidePanel(FindxColOrder(13),TmpBo,BOn);

            end;


    end; {Case..}

  end; {with..}
end;


Function TWOR.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      MainPage
         :  Result:=A1SBox.HorzScrollBar.Position;
      else  Result:=0;
    end; {Case..}


end;


procedure TWOR.RefreshList(ShowLines,
                                 IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;

Begin
  KeyStart:=FullIdkey(EXLocal.LInv.FolioNum,1);

  With MULCtrlO do
  Begin
    CtrlBOM:=BOMId;

    IgnoreMsg:=IgMsg;

    StartList(IdetailF,IdFolioK,KeyStart,'','',4,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;


end;


procedure TWOR.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TWORMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO do
    Begin

      Try

        With VisiList do
        Begin
          {00} AddVisiRec(A1CPanel,A1CLab);
          {01} AddVisiRec(A1DPanel,A1DLab);
          {02} AddVisiRec(A1IPanel,A1ILab);
          {03} AddVisiRec(A1OPanel,A1OLab);
          {04} AddVisiRec(A1BPanel,A1BLab);
          {05} AddVisiRec(A1UOPanel,A1UOLab);
          {06} AddVisiRec(A1OSPanel,A1OSLab);
          {07} AddVisiRec(A1BUPanel,A1BULab);
          {08} AddVisiRec(A1IssPanel,A1IssLab);
          {09} AddVisiRec(A1UPanel,A1ULab);
          {10} AddVisiRec(A1LocPanel,A1LocLab);
          {11} AddVisiRec(A1GPanel,A1GLab);
          {12} AddVisiRec(A1CCPanel,A1CCLab);
          {13} AddVisiRec(A1DpPanel,A1DpLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(MainPage);

          LabHedPanel:=A1HedPanel;

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
      MUTotCols:=13;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;

      
      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [2..9]) then
        Begin
          DispFormat:=SGFloat;

          Case n of
            2..8
                 :  NoDecPlaces:=Syss.NoQtyDec;
              9  :  NoDecPlaces:=Syss.NoCosDec;
            else    NoDecPlaces:=0;
          end; {Case..}
        end;
      end;

      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;


      Set_Buttons(A1ListBtnPanel);

      HighLiteStyle[1]:=[fsBold];
      HighLiteStyle[2]:=[fsUnderline,fsBold];


      ReFreshList(ShowLines,BOff);


    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;


  FormSetOfSet;

  FormReSize(Self);

end;



Procedure TWOR.OutNTxfrTotals;

Var
  Dnum    :  Double;
  NTDrCr  :  DrCrType;

Begin
  With ExLocal,LInv do
  Begin

    CostPanel.Caption := 'Total Cost: ' + FormatFloat(GenRealMask,TotalCost);
//    CostLab.Caption:=FormatFloat(GenRealMask,TotalCost);

    IssuePanel.Caption := 'Issued Cost: ' + FormatFloat(GenRealMask,TotalInvoiced);
//    IssuedLab.Caption:=FormatFloat(GenRealMask,TotalInvoiced);

    {IssLab.Caption:=FormatFloat(GenPcntMask,(DivWChk(TotalInvoiced,TotalCost)*100));

    FinLab.Caption:=FormatFloat(GenPcntMask,(DivWChk(TotalReserved,TotalInvoiced)*100));}

    Gauge1.Progress:=Round(DivWChk(Round_Up(TotalInvoiced,2),Round_Up(TotalCost,2))*100);
    Gauge2.Progress:=Round(DivWChk(Round_Up(TotalReserved,2),Round_Up(TotalCost,2))*100);


  end; {With..}

end;


Procedure TWOR.GetLineCBuild;

Var

  LowQty,
  TotBOM :  Double;
  LowStock
         :  Str20;
  LowLoc :  Str5;

Begin
  With BOMId do
  Begin
    If (Stock.StockCode<>Stockcode) then
      If (Not Global_GetMainRec(StockF,StockCode)) then
        ResetRec(StockF);
  end;


  If (Not Is_StdWOP) then
  With BOMId do
    A1BldF.Value:=SSDUpLift-QtyWOff
  else
    A1BldF.Value:=0.0;

  If (BOMId.SSDUpLift<>WORReqQty(BOMId)) then
  Begin
    TotBOM:=CouldBuildBOM(ExLocal.LInv,CouldIssue,LowStock,LowQty,LowLoc,0);

    If (TotBOM<Qty_OS(BOMId)) then
      A1IssF.Value:=TotBOM
    else
      A1IssF.Value:=Qty_OS(BOMId)-A1BldF.Value;
  end
  else
    A1IssF.Value:=0.0;

  If (BOMId.QtyWOff=0) then
    A1IssLab.Caption:='Free';

end;


{ ======== Display Receipt Record ========== }

procedure TWOR.SetNTxfrFields;

Var
  GenStr       :  Str255;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    A1ORefF.Text:=Pr_OurRef(LInv);
    A1OpoF.Text:=OpName;

    { CJS - 2013-10-25 - MRD2.6.12 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      A1OpoF.Hint := GetOriginatorHint(LInv)
    else
      A1OpoF.Hint := '';

    A1TPerF.InitPeriod(AcPr,AcYr,BOn,BOn);

    A1TDateF.DateValue:=TransDate;
    A1CDateF.DateValue:=DueDate;

    I1AccF.Text:=CustCode;

    If Global_GetMainRec(CustF,CustCode) then
      A1CompF.Text:=Cust.Company;

    A1YRefF.Text:=YourRef;

    I1YrRef2F.Text:=TransDesc;

    {$IFDEF SOP}
      A1LocTxF.Text:=Trim(DelTerms);
    {$ENDIF}

    THUd1F.Text:=DocUser1;
    THUd2F.Text:=DocUser2;
    THUd3F.Text:=DocUser3;
    THUd4F.Text:=DocUser4;
    //GS 17/10/2011 ABSEXCH-11706: put customisation values into text boxes
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



{ ======== Display Invoice Record ========== }

procedure TWOR.OutNTxfr;

Var
  GenStr       :  Str255;
  FoundCode    :  Str20;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    OutNTxfrTotals;

    SetNTxfrFields;
  end; {With..}
end;


procedure TWOR.Form2NTxfr;


Begin
  With ExLocal,LInv do
  Begin
    TransDate:=A1TDateF.DateValue;
    DueDate:=A1CDateF.DateValue;

    A1TPerF.InitPeriod(AcPr,AcYr,BOff,BOff);

    YourRef:=A1YRefF.Text;
    TransDesc:=I1YrRef2F.Text;

    CustCode:=FullCustCode(I1AccF.Text);

    {$IFDEF SOP}
      If (Syss.UseMLoc) and (Not EmptyKey(A1LocTxF.Text,MLocKeyLen)) then
        DelTerms:=Full_MLocKey(A1LocTxF.Text);
    {$ENDIF}


    DocUser1:=THUd1F.Text;
    DocUser2:=THUd2F.Text;
    DocUser3:=THUd3F.Text;
    DocUser4:=THUd4F.Text;
    //GS 17/10/2011 ABSEXCH-11706: write udef field values into customisation object
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


Procedure TWOR.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      MainPage
         :  With I1AccF do
              If CanFocus then
                SetFocus;

    end; {Case&With..}

end; {Proc..}




Procedure TWOR.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TWOR.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
  end;
end;

procedure TWOR.HideListColumns(PageNo  :  Integer);


Begin
  If (Assigned(MULCtrlO)) then
  With MULCtrlO,VisiList do
  Begin
    HidePanels(PageNo);

    ReAssignCols;

    PageUpDn(0,BOn);

    SetHedPanel(ListOfSet);


  end;
end;

procedure TWOR.PageControl1Change(Sender: TObject);
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

      {If (NewIndex In [NotePage]) and (A1FPanel.Visible) then
        A1FPanel.Visible:=BOff
      else
        If (Not A1FPanel.Visible) then
          A1FPanel.Visible:=BOn;}


      HideListColumns(NewIndex);

      Case NewIndex of
        MainPage,
        AnalPage
           :  Begin
                A1SBox.Parent:=ActivePage;
                A1ListBtnPanel.Parent:=ActivePage;
                A1BtmPanel.Parent:=ActivePage;
              end;

      {$IFDEF NP}


        NotePage
           :  If (NotesCtrl=nil) then
              With ExLocal do
              Begin
                NotesCtrl:=TNoteCtrl.Create(Self);

                //TW 26/10/2011: Add Event handler for new note functionality.
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
              begin
                With ExLocal do
                  If (FullNomKey(LInv.FolioNum)<>NotesCtrl.GetFolio) then {* Refresh notes *}
                  with NotesCtrl do
                  Begin
                    RefreshList(FullNomkey(LInv.FolioNum),GetNType);
                    GetLineNo:=LInv.NLineCount;
                  end;
                 SwitchNoteButtons(Self, NotesCtrl.NoteMode);
              end;
      {$ENDIF}



      end; {Case..}


      MDI_UpdateParentStat;

    end; {With..}
end;




procedure TWOR.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  fFrmClosing:=BOff;
  fDoingClose:=BOff;

  ExLocal.Create;

  ForceStore:=BOff;

  LastCoord:=BOff;
  ReCalcTot:=BOn;
  NeedCUpdate:=BOff;
  BalDone:=BOff;

  Visible:=BOff;

  InvStored:=BOff;
  CouldIssue:=BOff;

  JustCreated:=BOn;

  fRecordLocked:=BOff;

  StopPageChange:=BOff;

  Blank(BOMId,sizeof(BOMId));

  SKeypath:=0;

  MinHeight:=351;
  MinWidth:=630;

  InitSize.Y:=358;
  InitSize.X:=632;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=382;
  Width:=640;}

  PageControl1.ActivePage:=AdjustPage;


  With TForm(Owner) do
  Begin
    Self.Left:=0;
    Self.Top:=0;
  end;

  RecordPage:=WORFormPage;
  DocHed:=WORFormMode;

  MatchOrdPtr:=nil;

  Caption:=DocNames[DocHed];

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;


  FormDesign;

  {$IFDEF CU}
    try
      EntCustom3.Execute;
    except
      ShowMessage('Customisation Control Failed to initialise');
    end;

  {$ENDIF}


  FormBuildList(BOff);

end;



procedure TWOR.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  If (InvBtnList<>nil) then
    InvBtnList.Free;

  {If (MULCtrlO<>nil) then
    MULCtrlO.Free;}

end;

procedure TWOR.FormCloseQuery(Sender: TObject;
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

        If (NeedCUpdate) then
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

        Send_UpdateList(BOff,107);

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;

end;

procedure TWOR.FormClose(Sender: TObject; var Action: TCloseAction);
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


procedure TWOR.NotePageReSize;

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


procedure TWOR.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) and (Not fDoingClose) then
  Begin
    MULCtrlO.LinkOtherDisp:=BOff;

    NewVal:=ClientWidth-PagePoint[0].X;
    If (NewVal<MinWidth) then
      NewVal:=MinWidth;

    PageControl1.Width:=NewVal;

    NewVal:=ClientHeight-PagePoint[0].Y;

    If (NewVal<MinHeight) then
      NewVal:=MinHeight;

    PageControl1.Height:=NewVal;


    A1SBox.Width:=PageControl1.Width-PagePoint[1].X;
    A1SBox.Height:=PageControl1.Height-PagePoint[1].Y;

    TCNScrollBox.Width:=PageControl1.Width-PagePoint[5].X;
    TCNScrollBox.Height:=PageControl1.Height-PagePoint[5].Y;

    A1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    A1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    A1BSBox.Height:=A1BtnPanel.Height-PagePoint[3].X;

    A1ListBtnPanel.Left:=PageControl1.Width-PagePoint[4].X;
    A1ListBtnPanel.Height:=PageControl1.Height-PagePoint[4].Y;


    TCNListBtnPanel.Height:=PageControl1.Height-PagePoint[6].Y;

    NotePageResize;

    With A1SBox do
      A1HedPanel.Width:=HorzScrollBar.Range;



    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=A1SBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      MULCtrlO.ReFresh_Buttons;

      LockWindowUpDate(0);
    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;


        NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
end;


procedure TWOR.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TWOR.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Function TWOR.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;




procedure TWOR.ClsN1BtnClick(Sender: TObject);
begin
  If ConfirmQuit then
    Close;
end;

function TWOR.A1TPerFConvDate(Sender: TObject; const IDate: string;
  const Date2Pr: Boolean): string;
begin
  Result:=ConvInpPr(IDate,Date2Pr,@ExLocal);
end;


Function TWOR.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and ((CheckNeedStore) or (ForceStore)) and (Not ExLocal.LViewOnly) and (Not InvStored) then
  Begin
    If (Current_Page>NotePage) then {* Force view of main page *}
      ChangePage(0);

    If (ForceStore) then
      mbRet:=MessageDlg('This Works Order must be stored',mtWarning,[mbOk],0)
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


procedure TWOR.SetNTxfrStore(EnabFlag,
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

end;


Procedure TWOR.NoteUpdate;


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



Function TWOR.SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

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
    A1StatLab.Caption:=GetIntMsg(VOMsg+50);
    Shape1.Shape := stRoundRect;
    Shape1.Left := 5; //I1StatLab.Left - 1;
    Shape1.Top := 5; //I1StatLab.Top - 3;
    Shape1.Width := A1btnPanel.Width - 10; //I1StatLab.Width + 4;
    Shape1.Height := A1StatLab.Height + 4;
    Shape1.Visible := True;
    Shape1.Brush.Color := RGB(0, 159, 223);
    A1StatLab.Color := Shape1.Brush.Color;
  end
  else
    A1StatLab.Caption:='';

  OkN1Btn.Visible:=Not Result or FAllowPostedEdit;
  CanN1Btn.Visible:=OkN1Btn.Visible;

end;





(*  Add is used to add Customers *)

procedure TWOR.ProcessNtxfr(Fnum,
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

      
      NomAuto:=Not AutoOn;

      InvDocHed:=DocHed;

      RunNo:=Set_WORdRunNo(InvDocHed,AutoOn,BOff);

      TransDate:=Today; AcPr:=GetLocalPr(0).CPr; AcYr:=GetLocalPr(0).CYr;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
        Date2Pr(TransDate,AcPr,AcYr,@ExLocal);

      Blank(DueDate,Sizeof(DueDate));

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

      SetTriRec(Currency,UseORate,CurrTriR);


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
        Add_DocEditNow(LInv.FolioNum);

    end;


    SetNtxfrStore(BOn,LViewOnly);

    If (LastEdit) then
    Begin
      A1LocTxF.ReadOnly:=BOn;
      A1LocTxF.TabStop:=BOff;
      A1LocTxF.Color:=clBtnFace;
      A1LocTxF.Font.Color:=clWindowText;
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

Function TWOR.Check_LinesOk(InvR  :  InvRec)  :  Boolean;

Const
  Fnum     =  IDetailF;
  Keypath  =  IDFolioK;



Var

  KeyS,
  KeyChk    :  Str255;
  NomOk     :  Boolean;

  ExStatus,
  TmpKPath,
  TmpStat   :  Integer;

  TmpRecAddr
            :  LongInt;


 {$IFDEF PF_On}
  Loop     :  Boolean;
 {$ENDIF}




Begin
  NomOk:=BOn;

  ExStatus:=0;

  KeyChk:=FullNomKey(InvR.FolioNum);

  KeyS:=FullIdKey(InvR.FolioNum,1);

  TmpKPath:=KeyPath;

  ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


  While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NomOk) do
  With Id do
  Begin
    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    ExLocal.AssignFromGlobal(IdetailF);
    ExLocal.LastId:=ExLocal.LId;

    NomOk:=WORLineU.CheckCompleted(Self.ExLocal.LastEdit,BOn,ExLocal,IdLine);

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Result:=NomOk;
end; {Func..}



Function TWOR.CheckCompleted(Edit  :  Boolean)  : Boolean;

Const
  NofMsgs      =  7;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  SCode    :  Str10;

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
  PossMsg^[2]:='Financial Period is not valid.';
  PossMsg^[3]:='Check child windows';
  PossMsg^[4]:='Problem with transaction lines.';
  PossMsg^[5]:='That Location code is not valid.';
  PossMsg^[6]:='Transaction Date is not valid.';
  PossMsg^[7]:='An additional check is made via an external hook';



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

      
      2  :  Result:=ValidPeriod(StrPeriod(ConvTxYrVal(AcYr,BOff),AcPr),Syss.PrInYr);

      3  :  Begin {* Check if all child windows are gojng to close *}
              ShowMsg:=BOff;

              GenCanClose(Self,Self,Result,BOff);

            end;

      4  :  Result:=Check_LinesOk(LInv);

      {$IFDEF SOP}

        5  :  {$B-}
                Result:=(Not Syss.UseMLoc) or (EmptyKey(DelTerms,LocKeyLen)) or (GetMLoc(Self.Owner,DelTerms,SCode,FoundCode,-1));
              {$B+}
      {$ENDIF}

      6  :  Result:=ValidDate(TransDate);

      7  :   Begin {* Opportunity for hook to validate the header as well *}
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


Procedure TWOR.AdjStkDeduct(Mode  :  Byte);

Var
  AdjCtrl  :  TSAdjCForm;


Begin
  AdjCtrl:=TSAdjCForm.Create(Self);

  try
    With AdjCtrl do
    Begin
      Update;

      Prime_AdjStk(ExLocal.LInv,Mode);

    end
  finally

    AdjCtrl.Free;

  end; {try..}


end;


{Always keep line one cost equal to total cost}

procedure TWOR.Synch_BOMCost;

Const
  Fnum     =   IdetailF;
  Keypath  =   IdFolioK;


Var
  KeyS,
  KeyChk   :   Str255;


Begin
  With ExLocal, LInv do
  Begin
    KeyS:=FullIdKey(FolioNum,1);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    If (StatusOk) then
    With LId do
    Begin
      Costprice:=Round_Up(DivWChk(TotalCost,WORReqQty(LId)),Syss.NoCosDec);

      Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      Report_BError(Fnum,Status);

    end
    else
      LResetRec(Fnum);

  end;

end;


procedure TWOR.StoreNtxfr(Fnum,
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

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState: Boolean;
  CursorState: TCursor;

Begin
  KeyS:='';

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState := OkN1Btn.Enabled;
  CursorState := Cursor;

  OkN1Btn.Enabled := False;
  try

    Form2Ntxfr;

    COwnSet:=0;

    ResOrFull:=0;


    With ExLocal,LInv do
    Begin
      {$IFDEF CU} {* Call any pre store hooks here *}

        LNeedRefs:=(Not ForceStore) and (Not LastEdit); {If we enter hook with no folio assigned, let hook assign them}

        GenHooks(2000,1,ExLocal);

        If (LNeedRefs) then
          ForceStore:=LSetRefs;

      {$ENDIF}


      COk:=CheckCompleted(LastEdit);


      If (COk) then
      Begin

        Cursor:=crHourGlass;


        OpName:=EntryRec^.LogIn;

        CheckYRef(LInv);  {* To reset index on blank *}


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
            { CJS - 2013-10-25 - MRD2.6.12 - Transaction Originator }
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
          AssignToGlobal(InvF);
          
          If (Not LastEdit) then {* Get record, as if daybook empty, getpos was failing *}
            LGetMainRecPosKey(Fnum,InvOurRefK,LInv.OurRef);

          LGetRecAddr(Fnum);  {* Refresh record address *}

          If (StatusOk) then
          Begin

            Send_UpdateList(LastEdit,RecordPage);

          end;


          Check_DocChanges(LastInv,LInv);  {* Update all lines with any changes *}

          {Update line one cost with total cost, keep synchronised}

          Synch_BOMCost;

          If (LId.QtyPick<>0) then {Auto prompt to build}
          Begin
            If (PChkAllowed_In(385) and PChkAllowed_In(384)) then
              PostMessage((Owner as TForm).Handle,WM_FormCloseMsg,81,LastRecAddr[InvF]);
          end
          else
            If (CouldIssue) and (Not Is_StdWOP) then {Prompt to issue it}
            Begin
              If (PChkAllowed_In(382) and PChkAllowed_In(381)) then
                PostMessage((Owner as TForm).Handle,WM_FormCloseMsg,80,LastRecAddr[InvF]);
            end;

        end;

        If (LastEdit) or (LForcedAdd) then
        Begin
          Delete_DocEditNow(LInv.FolioNum);

          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

        end;

        SetNtxfrStore(BOff,BOff);

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




procedure TWOR.EditAccount(Edit,
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




procedure TWOR.A1CPanelMouseUp(Sender: TObject; Button: TMouseButton;
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



procedure TWOR.A1CLabMouseDown(Sender: TObject; Button: TMouseButton;
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



procedure TWOR.A1CLabMouseMove(Sender: TObject; Shift: TShiftState;
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


procedure TWOR.AddN1BtnClick(Sender: TObject);

Var
  Mode  :  Byte;

begin
  Mode:=0;

  Case Current_Page of

    NotePage
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

             If (Sender=AddN1Btn) or (Sender=EditN1Btn) or (Sender=Edit1) or (Sender=Add1) or (Sender=InsN1Btn) or (Sender=Insert1) then
               Mode:=1+(1*(Ord(Sender=EditN1Btn)+Ord(Sender=Edit1)))+ (2*(Ord(Sender=InsN1Btn)+Ord(Sender=Insert1)));


             {* Transfer to record, so the line is upto date *}

             If (Mode=3) and (Id.LineNo=1) then {Check to see what Stock type we have}
             Begin
               If (Stock.StockCode<>Id.StockCode) then
                 Global_GetMainRec(StockF,Id.StockCode);
             end;

             If (Mode<>3) or (Id.LineNo<>1) or (Stock.StockType<>StkBillCode) then
             Begin
               Form2Ntxfr;

               SetNewFolio;

               Display_Id(Mode);
             end
             else
             Begin
               ShowMessage('It is not possible to insert a line before the top line containing'+#13+
                           'the controlling BOM for this Works Order');

             end;
           end;

  end; {Case..}

end;





procedure TWOR.DelN1BtnClick(Sender: TObject);
begin
  Case Current_Page of

    NotePage
        :  {$IFDEF NP}
            If (NotesCtrl<>nil) then
              NotesCtrl.Delete1Click(Sender);

          {$ELSE}
             ;
          {$ENDIF}

    else   DeleteNTLine;

  end; {Case..}
end;

procedure TWOR.SwiN1BtnClick(Sender: TObject);
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


procedure TWOR.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    N3.Tag:=99;

    PopUp(X,Y);
  end;


end;

procedure TWOR.PopupMenu1Popup(Sender: TObject);
Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  {$IFDEF CU}
  Custom1.Caption := CustTxBtn1.Caption;
  Custom2.Caption := CustTxBtn2.Caption;
  // 17/01/2013 PKR ABSEXCH-13449
  // Custom buttons 3..6 now available
  Custom3.Caption := CustTxBtn3.Caption;
  Custom4.Caption := CustTxBtn4.Caption;
  Custom5.Caption := CustTxBtn5.Caption;
  Custom6.Caption := CustTxBtn6.Caption;
  {$ENDIF}

  With InvBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end; {With..}

end;


function TWOR.A1TPerFShowPeriod(Sender: TObject;
  const EPr: Byte): string;
begin
  Result:=PPr_Pr(EPr);
end;


procedure TWOR.SetNewFolio;

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

    A1ORefF.Text:=Pr_OurRef(LInv);

    HoldFlg:=HoldQ; {v5.60 auto set header on hold and clear when ok pressed so its not part of posting routine if it crashed
                     header is never stored correctly }

    { CJS - 2013-10-25 - MRD2.6.12 - Transaction Originator }
    TransactionOriginator.SetOriginator(LInv);
    A1OpoF.Hint := GetOriginatorHint(LInv);

        {* Force add of header now *}
    If (LSecure_Add(InvF,SKeypath,0)) then
      Add_DocEditNow(LInv.FolioNum);


    RefreshList(BOff,BOff);
  end;
end;



procedure TWOR.A1LocTxFExit(Sender: TObject);
Var
  SCode      :  Str20;
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;


begin

  {$IFDEF SOP}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) and (Not EmptyKey(FoundCode,MLocKeyLen))) and (ActiveControl<>CanN1Btn) and (ActiveControl<>OkN1Btn) and (ActiveControl<>ClsN1Btn)
          and  (Syss.UseMLoc) and (Not ExLocal.LastEdit) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,'',0));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(MLocF);

        end;


        If (FoundOk) then
        Begin

          StopPageChange:=BOff;

          StillEdit:=BOff;

          Text:=FoundCode;

        end
        else
        Begin
          StopPageChange:=BOn;

          SetFocus;
        end; {If not found..}
      end;

    end; {with..}
  {$ENDIF}
end;


procedure TWOR.I1AccFExit(Sender: TObject);
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

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsN1Btn) and (ActiveControl<>CanN1Btn)  then
    Begin
      {$IFDEF CU} {* Call hooks here *}

        FoundCode:=TextExitHook(2000,6,FoundCode,ExLocal);

      {$ENDIF}


      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,0));


      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(CustF);

        A1CompF.Text:=LCust.Company;

        If (LCust.DefTagNo<>0) then
          LInv.Tagged:=LCust.DefTagNo;
      end;


      If (FoundOk) then
      Begin

        StopPageChange:=BOff;

        StillEdit:=BOff;

        Text:=FoundCode;

        SendToObjectCC(FoundCode,0);


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



procedure TWOR.THUD1FEntHookEvent(Sender: TObject);
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
                //GS 17/10/2011 ABSEXCH-11706: create branches for the new UDFs
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
                                  If (Sender=A1YRefF) then
                                  Begin
                                    ExLocal.LInv.YourRef:=Text;
                                    CUUDEvent:=120;
                                  end
                                  else
                                    If (Sender=I1YrRef2F) then
                                    Begin
                                      ExLocal.LInv.TransDesc:=Text;
                                      CUUDEvent:=121;
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
              //GS 17/10/2011 ABSEXCH-11706: put customisation object vals into UDFs
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
              121  :  Text:=LInv.TransDesc;

            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;


procedure TWOR.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>CanN1Btn) and (ActiveControl<>ClsN1Btn) then
  Begin
    Text8pt(Sender).ExecuteHookMsg;
  end;

end;



procedure TWOR.OkN1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult = mrOk) Then
      Begin
        // MH 16/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
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

          Begin
            Close;
            Exit;
          end;
        end;
    end; {With..}
end;




procedure TWOR.Display_Id(Mode  :  Byte);


Begin

  If (IdLine=nil) then
  Begin

    IdLine:=TWORLine.Create(Self);

  end;

  Try

   //PR: 21/11/2017 ABSEXCH-19451
   if FAllowPostedEdit then
     IdLine.EnableEditPostedFields;

   With IdLine do
   Begin

     WindowState:=wsNormal;
     {Show;}


     InvBtnList.SetEnabBtn(BOff);

     If (Mode In [1..3]) then
     Begin

       Case Mode of

         1..3  :   If (Not ExLocal.InAddEdit) then
                     EditLine(Self.ExLocal.LInv,(Mode=2),(Mode=3),Self.ExLocal.LViewOnly,BOmId)
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



procedure TWOR.DeleteNTLine;

Var
  MbRet  :  Word;
  KeyS   :  Str255;

Begin

  With ExLocal,MULCtrlO do
    If (PageKeys^[MUListBoxes[0].Row]<>0) and (ValidLine) and (Not InListFind) and (Ok2Del) then
    Begin
      If (Id.LineNo<>1) then
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

            Deduct_WORStk(LId,LInv,BOff);

            UpdateWORCost(LInv,LId,1);


            {$IFDEF SOP}

              Self.Enabled:=BOff;

              Control_SNos(LId,LInv,LStock,3,Self); {*EN440WOP*}

              Self.Enabled:=BOn;
              Self.Show;

            {$ENDIF}

            With MULCtrlO do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
            end;

            OutNTxfrTotals;
          end;
        end;
      end
      else
      Begin
        ShowMessage('It is not possible to delete the top line for this Works Order as it contains the controlling BOM.');

      end;
    end; {If line is valid for deletion..}
end; {PRoc..}


procedure TWOR.A1TDateFExit(Sender: TObject);
begin
  With ExLocal,LInv,A1TDateF do
    If {(DateModified) and} (Not LastEdit) and (ValidDate(DateValue)) then
    Begin
      TransDate:=DateValue;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
      With A1TPerF do
      Begin
        Date2Pr(TransDate,AcPr,AcYr,@ExLocal);

        InitPeriod(AcPr,AcYr,BOn,BOn);
      end;

    end;

end;


procedure TWOR.SetFieldProperties;

Var
  n  : Integer;


Begin
  A1BtmPanel.Color:=A1FPanel.Color;
  A1BtnPanel.Color:=A1FPanel.Color;

  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) and (Components[n]<>A1YrefF) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(A1YrefF.Font);
        Color:=A1YrefF.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        {CheckColor:=A1YrefF.Color;}
        Color:=A1FPanel.Color;
      end;

  end; {Loop..}

end;


procedure TWOR.SetFormProperties(SetList  :  Boolean);

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
      TmpPanel[1].Font:=A1YrefF.Font;
      TmpPanel[1].Color:=A1YrefF.Color;

      TmpPanel[2].Font:=A1FPanel.Font;
      TmpPanel[2].Color:=A1FPanel.Color;
    end;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],Ord(SetList),Self.Caption+' '+PropTit[SetList]+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

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
            A1FPanel.Font.Assign(TmpPanel[2].Font);
            A1FPanel.Color:=TmpPanel[2].Color;

            A1YrefF.Font.Assign(TmpPanel[1].Font);
            A1YrefF.Color:=TmpPanel[1].Color;

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


procedure TWOR.PropFlgClick(Sender: TObject);
begin
  SetFormProperties((N3.Tag=99));
  N3.Tag:=0;
end;



procedure TWOR.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;






procedure TWOR.LnkN1BtnClick(Sender: TObject);
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



procedure TWOR.ChkBtnClick(Sender: TObject);
Var
  LastTotal  :  Double;

begin
  With ExLocal,LInv do
  Begin
    LastTotal:=TotalCost+TotalInvoiced;

    Check_OtherDocs(LInv,0);

    ForceStore:=(ForceStore or (LastTotal<>(TotalCost+TotalInvoiced)));
  end;

  OutNTxfrTotals;
end;



procedure TWOR.APickI1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  GetCursorPos(ListPoint);
  With ListPoint do
  Begin
    X:=X-50;
    Y:=Y-15;
  end;

  PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
end;




procedure TWOR.AP1Click(Sender: TObject);

Var
  ISCtrl         :  TWOBOMIssue;
  PAllo,
  CBuild         :  Double;
  RunPick        :  Boolean;
  mrResult       :  TModalResult;

begin
  PAllo:=0.0; CBuild:=0.0;

  If (Sender is TMenuItem) then
  With Sender as TMenuItem do
  Begin
    RunPick:=(Tag>=3);

    If (Qty_OS(BOMId)<>0.0) and (Not RunPick) then
    Begin

      ISCtrl:=TWOBOMIssue.Create(Self);

      try

        With ISCtrl do
        Begin
          PAValue:=PAllo;

          Repeat                     {* Take into account already issued qty *}
            mrResult:=InitIS(WORReqQty(BOMId)-BOMId.SSDUplift,BOMId);

            If (mrResult=mrOk) and (PAValue<=Qty_OS(BOMId)) and (PAValue>0) then
            Begin
              PAllo:=PAValue;

              RunPick:=BOn;
            end;

          Until (mrResult<>mrOK) or (RunPick);
        end;

      finally

        ISCtrl.Free;

      end; {Try..}
    end
    else
      If (Tag<3) then
        ShowMessage('BOM '+Trim(BOMId.StockCode)+' has already been fully issued.')
      else
        RunPick:=(MessageDlg('Please confirm you wish to reset the picked levels to zero?',mtConfirmation,[mbYes,mbNo],0)=mrYes);

    If (RunPick) then
    With ExLocal do
    Begin
      WORAuto_PickQty(LInv,BOMId,PAllo,CBuild,CouldIssue,Tag,Self);

      If (Assigned(MULCtrlO)) then
        MULCtrlO.PageUpDn(0,BOn);

      OutNTxfrTotals;
    end;
  end;
end;


procedure TWOR.AW3Click(Sender: TObject);
Var
  mrResult       :  TModalResult;

begin
  If (Sender is TMenuItem) then
  With Sender as TMenuItem do
  Begin
    If (MessageDlg('Please confirm you wish to Write off any outstanding build and component lines?',mtConfirmation,[mbYes,mbNo],0)=mrYes) then
    With ExLocal do
    Begin
      WORAuto_WriteOfff(LInv,BOMId,Tag,Self);

      If (Assigned(MULCtrlO)) then
        MULCtrlO.PageUpDn(0,BOn);

      OutNTxfrTotals;
    end;
  end;
end;




procedure TWOR.FindN1BtnClick(Sender: TObject);
Var
  ReturnCtrl  :  TReturnCtrlRec;

begin

  {$IFDEF GF}

    If (Not MULCtrlO.InListFind)  then
    Begin

      With ReturnCtrl,MessageReturn do
      Begin
        FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

        WParam:=3000;
        LParam:=0;
        Msg:=WM_CustGetRec;
        DisplayxParent:=BOn;
        ShowOnly:=BOn;
        Pass2Parent:=BOff;
        ShowSome:=BOff;

        If (ShowSome) then
          DontHide:=[tabFindSupplier,tabFindStock];

        //PR: 04/12/2013 ABSEXCH-14824
        Ctrl_GlobalFind(Self, ReturnCtrl, tabFindStock);

      end;
    end; {If in list find..}

  {$ENDIF}
end;


procedure TWOR.Build1Click(Sender: TObject);

Var
  KeyS  :  Str255;

begin
  If (A1BldF.Value>0) then
  With ExLocal,Id do
  Begin
    KeyS:=FullIdKey(LInv.FolioNum,1);
    Status:=Find_Rec(B_GetEq,F[IdetailF],IdetailF,RecPtr[IdetailF]^,IdFolioK,KeyS);

    If (StatusOk) then
    Begin
      AssignFromGlobal(IdetailF);

      Display_Id(2);

      If (Assigned(IdLine)) then
      Begin
        IdLine.A1IssF.Value:=A1BldF.Value;
        IdLine.A1IssF.FloatModified:=BOn;

      end;
    end;
  end {with..}
  else
    ShowMessage('You must first issue stock to a Works Order before you can build it.');
end;


procedure TWOR.WORI1BtnClick(Sender: TObject);
begin
  {$IFDEF WOP}
    If (MULCtrlO<>nil) then
    With MULCtrlO do
    If (ValidLine) and (Id.LineNo<>1) then
    With ExLocal,Id do
    Begin
      If (Stock.StockCode<>StockCode) then
        If (Not Global_GetMainRec(StockF,StockCode)) then
          ResetRec(StockF);

      If (Stock.StockType=StkBillCode) and (Qty_OS(Id)<>0.0) then
        Run_WORWizard(LInv,Id,1,Self.Parent)
      else
        ShowMessage('You can only generate a works order for an outstanding bill of material');
    end;

  {$ENDIF}

end;

procedure TWOR.RetI1BtnClick(Sender: TObject);
Var
  RETRef  :  Str10;
  mbRet   :  Word;

begin
  {$IFDEF RET}
    If (MULCtrlO<>nil) then
    With MULCtrlO do
    If (ValidLine) then
    With ExLocal,Id do
    If (LineNo>1) and (Qty_OS(Id)<>0.0) then {* Its a valid line *}
    Begin
      If (Stock.StockCode<>StockCode) then
        If (Not Global_GetMainRec(StockF,StockCode)) then
          ResetRec(StockF);

      If (CheckExsiting_RET(LInv,Id,RETRef,BOn)) then
      Begin
        mbRet:=CustomDlg(Application.MainForm,'Please note','Return Exists',
                                'Return '+RETRef+' already exists for this line.'+#13+#13+
                                'Please confirm you want to create another Return for this line.',mtConfirmation,[mbOk,mbCancel]);
      end
      else
        mbRet:=mrOk;

      If (mbRet=mrOk) then
        Gen_RetDocWiz(LInv,Id,10,Self);
    end
    else
      mbRet:=CustomDlg(Application.MainForm,'Please note','Components Only!',
                                'You can only return components which remain unissued.',mtInformation,[mbOk]);
  {$ENDIF}
end;



procedure TWOR.Display_PayIn(ChangeFocus   :  Boolean);


{$IFDEF NOM}

  Var
    NomNHCtrl  :  TNHCtrlRec;

    FoundLong  :  Longint;

    PayInForm  :  TPayInWin;

    TmpId      :  Idetail;

    WasNew     :  Boolean;

  Begin

    {$IFDEF STK}

      WasNew:=BOff;

      With EXLocal,NomNHCtrl do
      Begin
        TmpId:=Id;

        AssignToGlobal(InvF);

        FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

        NHMode:=3;

        Set_PIFormMode(NomNHCtrl);

      end;

      If (MatchOrdPtr=nil) then
      Begin
        WasNew:=BOn;

        PayInForm:=TPayInWin.Create(Self);

        MatchOrdPtr:=PayInForm;

      end
      else
        PayInForm:=MatchOrdPtr;

      Try

       With PayInForm do
       Begin
         Id:=TmpId;

         WindowState:=wsNormal;

         If (ChangeFocus) then
           Show;

         ShowLink(BOn);


       end; {With..}

       If (WasNew) then
       Begin
       end;

      except

       MatchOrdPtr:=nil;

       PayInForm.Free;
       PayInForm:=nil;

      end; {try..}
    {$ENDIF}

  {$ELSE}

    Begin


  {$ENDIF}

end;


procedure TWOR.MatI1BtnClick(Sender: TObject);
begin
  If (MULCtrlO<>nil) then
  With MULCtrlO do
  If (ValidLine) then
  Begin
    Display_PayIn(BOn);
  end;

end;







procedure TWOR.CustTxBtn1Click(Sender: TObject);
var
  // 24/01/2013 PKR ABSEXCH-13449
  eventID            : Integer;
  customButtonNumber : integer;
begin
  {$IFDEF CU}
    If (Assigned(MULCtrlO)) then
    With MULCtrlO,ExLocal do
    Begin
      Form2NTxfr;
      Begin
        If (ValidLine) then
          LId:=Id
        else
          LResetRec(IDetailF);

        // 24/01/2013 PKR ABSEXCH-13449
        // Get the custom button number.
        // The button or menu item Tag property is set to the button number.
        customButtonNumber := -1;
        if Sender is TSBSButton then
          customButtonNumber := (Sender as TSBSButton).Tag;
        if Sender is TMenuItem then
          customButtonNumber := (Sender as TMenuItem).Tag;

        if custBtnHandler.CustomButtonClick(formPurpose,
                                            0,
                                            recordState,
                                            customButtonNumber,
                                            ExLocal) then
//        If ExecuteCustBtn(2000,((43+(100*Ord(Not InAddEdit)))*Ord((Sender=CustTxBtn1) or (Sender=Custom1)))+
//                      ((44+(100*Ord(Not InAddEdit)))*Ord((Sender=CustTxBtn2) or (Sender=Custom2))), ExLocal) then
        Begin
          THUD1F.Text:=LInv.DocUser1;
          THUD2F.Text:=LInv.DocUser2;
          THUD3F.Text:=LInv.DocUser3;
          THUD4F.Text:=LInv.DocUser4;
          //GS 17/10/2011 ABSEXCH-11706: put customisation values into text boxes
          THUd5F.Text:=LInv.DocUser5;
          THUd6F.Text:=LInv.DocUser6;
          THUd7F.Text:=LInv.DocUser7;
          THUd8F.Text:=LInv.DocUser8;
          THUd9F.Text:=LInv.DocUser9;
          THUd10F.Text:=LInv.DocUser10;
          // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
          THUd11F.Text := LInv.thUserField11;
          THUd12F.Text := LInv.thUserField12;
        end;

      end;
    end; {With..}
  {$ENDIF}

end;


// MHYR 25/10/07
procedure TWOR.A1YRefFChange(Sender: TObject);
begin
  A1YRefF.Hint := A1YRefF.Text;
end;

// MHYR 25/10/07
procedure TWOR.I1YrRef2FChange(Sender: TObject);
begin
  I1YrRef2F.Hint := I1YrRef2F.Text;
end;

procedure TWOR.MenItem_AuditClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmAudit);
end;

procedure TWOR.MenItem_DatedClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmDated);
end;

procedure TWOR.MenItem_GeneralClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmGeneral);
end;

procedure TWOR.SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
begin
  //Called when user uses Switch from pop-up menu on Notes form
  AddN1Btn.Enabled := NewMode <> nmAudit;
  EditN1Btn.Enabled := NewMode <> nmAudit;
  InsN1Btn.Enabled := NewMode <> nmAudit;
  DelN1Btn.Enabled := NewMode <> nmAudit;
  FindN1Btn.Enabled := NewMode <> nmAudit;
end;

procedure TWOR.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;

  //Description
  A1YRefF.AllowPostedEdit := True;
  I1YrRef2F.AllowPostedEdit := True;

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

//PR: 20/11/2017 ABSEXCH-19451
function TWOR.TransactionViewOnly: Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;


Initialization

end.
