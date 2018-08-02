Unit JobTS1U;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, TEditVal, BorBtns, Mask, ComCtrls,

  GlobVar,VarConst,ExWrap1U,BTSupU1,SupListU,SBSComp2,

  SalTxL1U,

  JobTSI1U,

  {$IFDEF NP}
    NoteU,
  {$ENDIF}

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  ExtGetU,

  Menus;



type
  TSheetMList  =  Class(TDDMList)


    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;


  end;


type
  TTSheetForm = class(TForm)
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
    N1DrLab: TSBSPanel;
    N1TCLab: TSBSPanel;
    N1CCLab: TSBSPanel;
    N1DepLab: TSBSPanel;
    N1DPanel: TSBSPanel;
    N1DrPanel: TSBSPanel;
    N1NomPanel: TSBSPanel;
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
    N1OrefF: Text8Pt;
    N1OpoF: Text8Pt;
    N1TDateF: TEditDate;
    N1BSBox: TScrollBox;
    AddN1Btn: TButton;
    EditN1Btn: TButton;
    DelN1Btn: TButton;
    InsN1Btn: TButton;
    SWiN1Btn: TButton;
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
    Label81: Label8;
    N1StatLab: Label8;
    N1BtmPanel: TSBSPanel;
    SBSPanel5: TSBSPanel;
    DrReqdTit: Label8;
    PayDescF: Label8;
    N1ListBtnPanel: TSBSPanel;
    LnkN1Btn: TButton;
    Links1: TMenuItem;
    EmpAc: Text8Pt;
    Label82: Label8;
    SBSPanel1: TSBSPanel;
    Label83: Label8;
    CrReqdLab: Label8;
    N1APanel: TSBSPanel;
    N1ALab: TSBSPanel;
    N1TCPanel: TSBSPanel;
    N1TSWkF: TCurrencyEdit;
    SBSPanel2: TSBSPanel;
    Label86: Label8;
    DrReqdLab: Label8;
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
    Label87: Label8;
    N1YRefF: Text8Pt;
    Label88: Label8;
    N1TPerF: TEditPeriod;
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
    pnlAnonymisationStatus: TPanel;
    shpNotifyStatus: TShape;
    lblAnonStatus: TLabel;
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
    procedure N1TDateFExit(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LnkN1BtnClick(Sender: TObject);
    procedure EmpAcExit(Sender: TObject);
    procedure chkI1BtnClick(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure SetUDFields(UDDocHed  :  DocTypes);
    procedure MenItem_GeneralClick(Sender: TObject);
    procedure MenItem_DatedClick(Sender: TObject);
    procedure MenItem_AuditClick(Sender: TObject);
    private
    {private declarations}

    JustCreated,
    InvStored,
    StopPageChange,
    FirstStore,
    fNeedCUpdate,
    FColorsChanged,
    fFrmClosing,
    fDoingClose,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    fRecordLocked,
    CanDelete    :  Boolean;

    SKeypath,
    MinHeight,
    MinWidth     :  Integer;

    {$IFDEF NP}
      NotesCtrl  :  TNoteCtrl;
    {$ENDIF}

    InvBtnList   :  TVisiBtns;

    IdLine       :  TTSLine;
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

    //PR: 20/11/2017 ABSEXCH-19451
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


    Procedure OutNTxfrTotals;

    procedure Display_Id(Mode  :  Byte);

    procedure DeleteNTLine;

    procedure SetFormProperties(SetList  :  Boolean);

    procedure SetFieldProperties;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;
    procedure SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
  public
    { Public declarations }

    fForceStore:  Boolean;

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;

    MULCtrlO   :  TSheetMList;

    //SSK 09/01/2018 2018R1 ABSEXCH-19561: variables for post anonymisation
    FAnonymisationON: Boolean;
    FSaveAnonPanelCord: Boolean;

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

    procedure OutNTxfr;

    procedure Form2NTxfr;

    Procedure SetFieldFocus;

    Procedure NoteUpdate;

    procedure SetNewFolio;

    procedure ProcessNtxfr(Fnum,
                           KeyPAth    :  Integer;
                           Edit,
                           AutoOn     :  Boolean);

    Function CheckCompleted(Edit  :  Boolean)  : Boolean;

    Function Check_LinesOk(InvR     :  InvRec;
                       Var ShowMsg  :  Boolean)  :  Boolean;

    procedure StoreNtxfr(Fnum,
                         KeyPAth    :  Integer);

    procedure EditAccount(Edit,
                          AutoOn,
                          ViewOnly   :  Boolean);

    //PR: 20/11/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;

    //SSK 09/01/2018 2018R1 ABSEXCH-19561: Routines for handling of Post Anonymisation Behaviour for JCT/JPT/JST/JPA/JSA
    procedure SetAnonymisationBanner;
    procedure SetAnonymisationON(AValue: Boolean);
    procedure SetAnonymisationPanel;
  end;

  Procedure Set_TSheetFormMode(State  :  DocTypes;
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
  SBSComp,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,
  VarJCstU,
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
  IntMU,

  MiscU,

  PayF2U,
  {ConvDocU,}

  JobSup1U,

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  InvFSU3U,
  Event1U,
  GenWarnU,
  JChkUseU,
  Warn1U,
  //GS 18/10/ 2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF,

  { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
  TransactionOriginator,

  //GS access to audit notes class
  AuditNotes,
  oSystemSetup,
  GDPRConst;


{$R *.DFM}



Var
  TSheetFormMode  :  DocTypes;
  TSheetFormPage  :  Byte;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_TSheetFormMode(State  :  DocTypes;
                             NPage  :  Byte);

Begin
  If (State<>TSheetFormMode) then
    TSheetFormMode:=State;

  If (TSheetFormPage<>NPage) then
    TSheetFormPage:=NPage;

end;




{$I JTShtI1U.PAS}


Procedure  TTSheetForm.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TTSheetForm.Find_FormCoord;


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

    if GetbtControlCsm(pnlAnonymisationStatus) then
      FSaveAnonPanelCord := True;


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


procedure TTSheetForm.Store_FormCoord(UpMode  :  Boolean);


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

    StorebtControlcsm(pnlAnonymisationStatus);

    MULCtrlO.Store_ListCoord(GlobComp);

    {$IFDEF NP}
      If (NotesCtrl<>nil) then
        NotesCtrl.MULCtrlO.Store_ListCoord(GlobComp);
    {$ENDIF}

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

end;




procedure TTSheetForm.SetForceStore(State  :  Boolean);

Begin
  If (State<>fForceStore) then
  Begin
    fForceStore:=State;

    ClsN1Btn.Enabled:=Not fForceStore;
    CanN1Btn.Enabled:=ClsN1Btn.Enabled;
  end;
end;


Function TTSheetForm.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;


Procedure TTSheetForm.Link2Nom;


Begin
  With Id do
  Begin
    {$IFDEF MC_On}

      {N1BaseF.Value:=Conv_TCurr(NetValue,CXRate[UseCoDayRate],Currency,BOff);}

    {$ENDIF}

    PayDescF.Caption:=Get_StdPRDesc(StockCode,JCtrlF,JCK,-1);
  end;
end;


Procedure TTSheetForm.WMCustGetRec(Var Message  :  TMessage);

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

                1  :  AddN1BtnClick(EditN1Btn);

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
                 If (Not ExLocal.InAddEdit) or ((Not CheckFormNeedStoreChk(Self,BOff)) and (ExLocal.LastEdit)) then
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
                      1  :  {$IFDEF NP}
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


Procedure TTSheetForm.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TTSheetForm.Send_UpdateList(Edit   :  Boolean;
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


procedure TTSheetForm.ShowLink(ShowLines,
                               VOMode    :  Boolean);
var
  lAnonStat: string;      //SSK 09/01/2018 2018R1 ABSEXCH-19561:: variable added
begin
  ExLocal.AssignFromGlobal(InvF);
  ExLocal.LGetRecAddr(InvF);

  With ExLocal,LInv do
  Begin

    //SSK 09/01/2018 2018R1 ABSEXCH-19561: update caption for anonymisation
    lAnonStat := ' ';
    if GDPROn and (thAnonymised) then
      lAnonStat := lAnonStat + capAnonymised;
    Caption := DocNames[InvDocHed]+' Record - ' + Pr_OurRef(LInv) + lAnonStat;

    {$B-}

    LViewOnly:=SetViewOnly(ShowLines,VOMode);

    PrimeButtons;

    {$B+}

    //SSK 09/01/2018 2018R1 ABSEXCH-19561: Anonymisation status determined here
    if ShowLines or VOMode then
      FAnonymisationON := (GDPROn and (trim(OurRef) <> '') and thAnonymised)
    else
      FAnonymisationON := False;

    SetAnonymisationBanner;

  end;


  OutNTxfr;


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


procedure TTSheetForm.FormSetOfSet;

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


Function TTSheetForm.SetHelpC(PageNo :  Integer;
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

procedure TTSheetForm.PrimeButtons;

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

      SetHideBtn(0,((ExLocal.LViewOnly) and ((PageNo<>1) or (fRecordLocked))),BOff);
      SetHideBtn(1,((TransactionViewOnly) and (PageNo=1) and (fRecordLocked)) ,BOff);


      SetBtnHelp(0,SetHelpC(PageNo,[0..1],1024,88));
      SetBtnHelp(1,SetHelpC(PageNo,[0..1],1024,87));


      SetHideBtn(2,Not IdButton(0).Visible,BOff);

      SetBtnHelp(2,SetHelpC(PageNo,[0..1],1025,89));


      SetHideBtn(3,Not IdButton(0).Visible,BOff);

      SetBtnHelp(3,SetHelpC(PageNo,[0..1],1024,86));

      SetHideBtn(4,(PageNo=0),BOff);

      SetHideBtn(5,((ExLocal.LViewOnly) or (PageNo=1)),BOff);
      
      SetHideBtn(6,(PageNo In [1]),BOn);
      SetBtnHelp(6,SetHelpC(PageNo,[0],81,0));

    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure TTSheetForm.BuildDesign;


begin

  {* Set Version Specific Info *}

  {$IFNDEF MC_On}

  {$ENDIF}


  N1YRefF.MaxLength:=DocYRef2Len;

  //GS 18/10/2011 ABSEXCH-11706: removed existing UDF setup code; replaced with calling pauls new method
  SetUDFields(DocHed);

  (*
  UDF1L.Caption:=Get_CustmFieldCaption(2,17);
  UDF1L.Visible:=Not Get_CustmFieldHide(2,17);

  THUD1F.Visible:=UDF1L.Visible;

  UDF2L.Caption:=Get_CustmFieldCaption(2,18);
  UDF2L.Visible:=Not Get_CustmFieldHide(2,18);

  THUD2F.Visible:=UDF2L.Visible;


  UDF3L.Caption:=Get_CustmFieldCaption(2,19);
  UDF3L.Visible:=Not Get_CustmFieldHide(2,19);

  THUD3F.Visible:=UDF3L.Visible;


  UDF4L.Caption:=Get_CustmFieldCaption(2,20);
  UDF4L.Visible:=Not Get_CustmFieldHide(2,20);

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
procedure TTSheetForm.SetUDFields(UDDocHed  :  DocTypes);
begin

  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L, UDF11L, UDF12L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F],
             cfTSHHeader);

  ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F]),
                           2, //UDFs laid out on the UI as 2 columns, 5 rows
                           TransExtForm1,
                           0,     // RowHeightOverRide
                           12);   // UDF_Count
end;

procedure TTSheetForm.FormDesign;


begin

  PrimeButtons;

  BuildDesign;

end;

procedure TTSheetForm.HidePanels(PageNo    :  Byte);

Var
  TmpBo  :  Boolean;
  n      :  Integer;

Begin
  With MULCtrlO,VisiList do
  Begin
    fBarOfSet:=Current_BarPos(PageNo);

    Case PageNo of

      0
         :  Begin
              {$IFNDEF PF_On}
                TmpBo:=BOn;
              {$ELSE}
                TmpBo:=Not Syss.UseCCDep;
              {$ENDIF}

              SetHidePanel(3,TmpBo,BOff);
              SetHidePanel(4,TmpBo,BOn);

            end;


    end; {Case..}

  end; {with..}
end;


Function TTSheetForm.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      0
         :  Result:=N1SBox.HorzScrollBar.Position;
      else  Result:=0;
    end; {Case..}


end;


procedure TTSheetForm.RefreshList(ShowLines,
                                 IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;

Begin

  KeyStart:=FullIdkey(EXLocal.LInv.FolioNum,0);

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(IdetailF,IdFolioK,KeyStart,'','',4,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TTSheetForm.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TSheetMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO do
    Begin

      Try

        With VisiList do
        Begin
          AddVisiRec(N1DPanel,N1DLab);
          AddVisiRec(N1NomPanel,N1NomLab);
          AddVisiRec(N1APanel,N1ALab);
          AddVisiRec(N1CCPanel,N1CCLab);
          AddVisiRec(N1DepPanel,N1DepLab);
          AddVisiRec(N1DrPanel,N1DrLab);
          AddVisiRec(N1TCPanel,N1TCLab);
          AddVisiRec(N1CrPanel,N1CrLab);

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

        If (n In [5..7]) then
        Begin
          DispFormat:=SGFloat;

          Case n of
            5  :  NoDecPlaces:=Syss.NoQtyDec;
            6  :  NoDecPlaces:=Syss.NoCOSDec;
            else  NoDecPlaces:=2;
          end; {Case..}

        end;
      end;


      ListLocal:=@ExLocal;

      ListCreate;

      NoUpCaseCheck:=BOn;


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

procedure TTSheetForm.SetNTxfrFields;

Var
  FoundCode  :  Str20;


Begin

  With ExLocal,LInv do
  Begin
    N1ORefF.Text:=Pr_OurRef(LInv);
    N1OpoF.Text:=OpName;

    { CJS - 2013-10-25 - MRD2.6.11 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      N1OpoF.Hint := GetOriginatorHint(LInv)
    else
      N1OpoF.Hint := '';

    N1TPerF.InitPeriod(AcPr,AcYr,BOn,BOn);

    N1TDateF.DateValue:=TransDate;

    N1YRefF.Text:=TransDesc;

    N1TSWkF.Value:=DiscDays;

    EmpAc.Text:=BatchLink;

    If (JobMisc^.EmplRec.EmpCode<>BatchLink) then
    Begin
      GetJobMisc(Self,BatchLink,FoundCode,3,-1);

    end;

    AssignFromGlobal(JMiscF);

    THUd1F.Text:=DocUser1;
    THUd2F.Text:=DocUser2;
    THUd3F.Text:=DocUser3;
    THUd4F.Text:=DocUser4;
    //GS 18/10/2011 ABSEXCH-11706: put customisation values into text boxes
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



Procedure TTSheetForm.OutNTxfrTotals;

Var
  Dnum    :  Double;
  NTDrCr  :  DrCrType;

Begin
  With ExLocal,LInv do
  Begin

    DrReqdLab.Caption:=FormatFloat(GenQtyMask,TotalInvoiced);

    CrReqdLab.Caption:=FormatCurFloat(GenRealMask,InvNetVal,BOff,Currency);

  end; {With..}

end;

{ ======== Display Invoice Record ========== }

procedure TTSheetForm.OutNTxfr;

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


procedure TTSheetForm.Form2NTxfr;

Var
  FoundCode  :  Str20;

Begin
  With ExLocal,LInv do
  Begin
    TransDate:=N1TDateF.DateValue;

    {If (JobMisc^.EmplRec.EmpCode<>BatchLink) then
      GetJobMisc(Self,BatchLink,FoundCode,3,-1);

    AssignFromGlobal(JMiscF);}

    N1TPerF.InitPeriod(AcPr,AcYr,BOff,BOff);

    TransDesc:=N1YRefF.Text;

    DiscDays:=Round(N1TSWkF.Value);
    // MH 04/02/2010 (v6.3): Also set new Week/Month field on header for TSH
    thWeekMonth := DiscDays;

    BatchLink:=UpCaseStr(FullEmpKey(EmpAc.Text));

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
  end; {With..}
end;


Procedure TTSheetForm.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      0
         :  EmpAc.SetFocus;

    end; {Case&With..}

end; {Proc..}




Procedure TTSheetForm.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TTSheetForm.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
  end;
end;


procedure TTSheetForm.PageControl1Change(Sender: TObject);
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

                NotesCtrl.fParentLocked:=fRecordLocked;
                
                //TW 07/11/2011: Add Event handler for new note functionality.
                NotesCtrl.OnSwitch := SwitchNoteButtons;
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
              With ExLocal do
              begin
                If (FullNomKey(LInv.FolioNum)<>NotesCtrl.GetFolio) then {* Refresh notes *}
                with NotesCtrl do
                Begin
                  RefreshList(FullNomkey(LInv.FolioNum),GetNType);
                  GetLineNo:=LInv.NLineCount;
                end;
                SwitchNoteButtons(Self, NotesCtrl.NoteMode);
              end;

      {$ELSE}

         1  :  ;

      {$ENDIF}



      end; {Case..}


      MDI_UpdateParentStat;

    end; {With..}
end;




procedure TTSheetForm.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  fFrmClosing:=BOff;
  fDoingClose:=BOff;
  ExLocal.Create;

  ForceStore:=BOff;

  LastCoord:=BOff;

  Visible:=BOff;

  InvStored:=BOff;

  JustCreated:=BOn;

  NeedCUpdate:=BOff;
  FColorsChanged := False;

  StopPageChange:=BOff;

  fRecordLocked:=BOff;

  FAnonymisationON := False;
  FSaveAnonPanelCord := False;

  SKeypath:=0;

  MinHeight:=326;
  MinWidth:=630;

  InitSize.Y:=377; //333
  InitSize.X:=632;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=382;
  Width:=640;}

  PageControl1.ActivePage:=RecepPage;


  With TForm(Owner) do
  Begin
    Self.Left:=0;
    Self.Top:=0;
  end;

  RecordPage:=TSheetFormPage;
  DocHed:=TSheetFormMode;

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

end;



procedure TTSheetForm.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  If (InvBtnList<>nil) then
    InvBtnList.Free;

  {If (MULCtrlO<>nil) then
    MULCtrlO.Free;}

end;

procedure TTSheetForm.FormCloseQuery(Sender: TObject;
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

        n:=106;

        If (RecordPage=108) then {Being called from match window, need different reference}
          n:=RecordPage;

        Send_UpdateList(BOff,n);
        
      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;

end;

procedure TTSheetForm.FormClose(Sender: TObject; var Action: TCloseAction);
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


procedure TTSheetForm.NotePageReSize;

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


procedure TTSheetForm.FormResize(Sender: TObject);
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

    //SSK 09/01/2018 2018R1 ABSEXCH-19561: set size/position of anonymisation panel on form resize
    SetAnonymisationPanel;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));


  end; {If time to update}
end;


procedure TTSheetForm.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TTSheetForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Function TTSheetForm.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;




procedure TTSheetForm.ClsN1BtnClick(Sender: TObject);
begin
  If ConfirmQuit then
    Close;
end;

function TTSheetForm.N1TPerFConvDate(Sender: TObject; const IDate: string;
  const Date2Pr: Boolean): string;
begin
  Result:=ConvInpPr(IDate,Date2Pr,@ExLocal);
end;


Function TTSheetForm.ConfirmQuit  :  Boolean;

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
      mbRet:=MessageDlg('This Timesheet must be stored',mtWarning,[mbOk],0)
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


procedure TTSheetForm.SetNTxfrStore(EnabFlag,
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


Procedure TTSheetForm.NoteUpdate;


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



Function TTSheetForm.SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

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





(*  Add is used to add Customers *)

procedure TTSheetForm.ProcessNtxfr(Fnum,
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



    SetFieldFocus;

  end {If Abort..}
  else
  Begin
    SetViewOnly(BOn,ExLocal.LViewOnly);
    PrimeButtons;
  end;


end; {Proc..}



 { ====================== Function to Check ALL valid invlines (InvLTotal<>0) have a nominal =============== }

Function TTSheetForm.Check_LinesOk(InvR     :  InvRec;
                               Var ShowMsg  :  Boolean)  :  Boolean;

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

    ExLocal.AssignFromGlobal(IdetailF);
    NomOk:=LineCheckCompleted(ExLocal.LId,InvR,Self.ExLocal.LastEdit,BOn,ShowMsg,Self);

    ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Result:=NomOk;
end; {Func..}



Function TTSheetForm.CheckCompleted(Edit  :  Boolean)  : Boolean;

Const
  NofMsgs      =  9;

Type
  PossMsgType  = Array[1..NofMsgs] of String[86];

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


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  // MH 13/03/2012 v6.10 ABSEXCH-2777: Added validation on Employee Code
  PossMsg^[1]:='The employee code is not valid';
  PossMsg^[2]:='This line must be completed.';
  PossMsg^[3]:='Financial Period is not valid.';
  PossMsg^[4]:='Check child windows!';
  PossMsg^[5]:='Problem with transaction lines.';
  PossMsg^[6]:='The Self Employed Certificate for that employee has expired.';
  PossMsg^[7]:='Transaction Date is not valid.';
  PossMsg^[8]:='This Sub-contract employee is set to record labour costs via the Purchase ledger only.';
  PossMsg^[9]:='An additional check is made via an external hook';



  Test:=1;

  Result:=BOn;

  BalNow:=0;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LInv do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of
      // MH 13/03/2012 v6.10 ABSEXCH-2777: Added validation on Employee Code - inserted first so
      // we know we have a valid employee before it starts checks related to the employee details
      1  : Begin
             // Check employee code is set
             Result := (Trim(BatchLink) <> '');
             If Result Then
             Begin
               // Check it is a valid employee
               FoundCode := BatchLink;
               Result := GetJobMisc(Self, FoundCode, FoundCode, 3, -1);
             End; // If Result
           End;

      2  :  Begin
              Result:=Not IdLineActive;

              If Assigned(IdLine) and (IdLineActive) then
                IdLine.Show;
            end;

      3  :  Result:=ValidPeriod(StrPeriod(ConvTxYrVal(AcYr,BOff),AcPr),Syss.PrInYr);

      4  :  Begin {* Check if all child windows are gojng to close *}
              ShowMsg:=BOff;

              GenCanClose(Self,Self,Result,BOff);

            end;

      5  :  Result:=Check_LinesOk(LInv,ShowMsg);

      6  :  Begin
              Result:=Not Cert_Expired(BatchLink,TransDate,BOff,BOn);

              ShowMsg:=BOff;
            end;

      7  :  Result:=ValidDate(TransDate);

      8  :  Begin
              Result:=Not JobMisc^.EmplRec.LabPLOnly;

            end;

      9  :   Begin {* Opportunity for hook to validate the header as well *}
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





procedure TTSheetForm.StoreNtxfr(Fnum,
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



        If (LastEdit) then
        Begin
          If (Not TransactionViewOnly) then
          Begin
            Status:=LSecure_InvPut(Fnum,KeyPAth,0);
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
            { CJS - 2013-10-25 - MRD2.6.11 - Transaction Originator }
            TransactionOriginator.SetOriginator(LInv);

            Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
          end
          else
            Status:=LSecure_InvPut(Fnum,KeyPAth,0);


        end;

        If (Not LViewOnly) then
          Report_BError(Fnum,Status);

        If (StatusOk) and (Not LViewOnly) then
        Begin
          If (Not LastEdit) then {* Get record, as if daybook empty, getpos was failing *}
          With LInv do
            LGetMainRecPosKey(Fnum,InvRNoK,FullDayBkKey(RunNo,FolioNum,DocCodes[InvDocHed]));

          LGetRecAddr(Fnum);  {* Refresh record address *}

          If (StatusOk) then
          Begin

            Send_UpdateList(LastEdit,RecordPage);

          end;


          {If (LastEdit) then  v4.32, check under all modes}
            if Check_DocChanges(LastInv,LInv) then  {* Update all lines with any changes *}
            begin
              //GS add audit note when TSH is edited
              if Status = 0 then
              begin
                TAuditNote.WriteAuditNote(anTransaction, anEdit, ExLocal);
              end
            end;

        end;

        If (LastEdit) or (LForcedAdd) then
        Begin
          Delete_DocEditNow(FolioNum);

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




procedure TTSheetForm.EditAccount(Edit,
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




procedure TTSheetForm.N1DPanelMouseUp(Sender: TObject; Button: TMouseButton;
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



procedure TTSheetForm.N1DLabMouseDown(Sender: TObject; Button: TMouseButton;
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



procedure TTSheetForm.N1DLabMouseMove(Sender: TObject; Shift: TShiftState;
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

procedure TTSheetForm.AddN1BtnClick(Sender: TObject);

Var
  Mode  :  Byte;

begin
  Mode:=0;

  Case Current_Page of

    1  : {$IFDEF NP}
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

             Mode:=Mode+(8*Ord((Sender=InsN1Btn) or (Sender=Insert1)));

             {* Transfer to record, so the line is upto date *}

             Form2Ntxfr;

             SetNewFolio;

             Display_Id(Mode);
           end;

  end; {Case..}

end;





procedure TTSheetForm.DelN1BtnClick(Sender: TObject);
begin
  Case Current_Page of

    1  :  {$IFDEF NP}
            If (NotesCtrl<>nil) then
              NotesCtrl.Delete1Click(Sender);

          {$ELSE}
             ;
          {$ENDIF}

    else   DeleteNTLine;

  end; {Case..}
end;

procedure TTSheetForm.SWiN1BtnClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  {$IFDEF NP}

    If (NotesCtrl<>nil) then
    With NotesCtrl do
    Begin
      If (Not MULCtrlO.InListFind) then
      begin
          //TW: 07/11/2011 v6.9 Added submenu to handle Audit History Notes
          ListPoint.X:=1;
          ListPoint.Y:=1;

          ListPoint := SwiN1Btn.ClientToScreen(ListPoint);

          PMenu_Notes.Popup(ListPoint.X, ListPoint.Y);
      end;
    end;
  {$ENDIF}
end;

procedure TTSheetForm.chkI1BtnClick(Sender: TObject);
Var
  LastTotal  :  Double;

begin
  With ExLocal,LInv do
  Begin
    LastTotal:=InvNetVal;

    Check_OtherDocs(LInv,17);

    If (Not ForceStore) then
      ForceStore:=(LastTotal<>InvNetVal);
  end;

  OutNTxfrTotals;
end;


procedure TTSheetForm.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    N3.Tag:=99;

    PopUp(X,Y);
  end;


end;

procedure TTSheetForm.PopupMenu1Popup(Sender: TObject);
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


function TTSheetForm.N1TPerFShowPeriod(Sender: TObject;
  const EPr: Byte): string;
begin
  Result:=PPr_Pr(EPr);
end;


procedure TTSheetForm.SetNewFolio;

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

    { CJS - 2013-10-25 - MRD2.6.11 - Transaction Originator }
    TransactionOriginator.SetOriginator(LInv);
    N1OpoF.Hint := GetOriginatorHint(LInv);

    {* Force add of header now *}
    If (LSecure_Add(InvF,SKeypath,0)) then
      Add_DocEditNow(LInv.FolioNum);


    RefreshList(BOff,BOff);
  end;
end;


procedure TTSheetForm.OkN1BtnClick(Sender: TObject);
begin

  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult=mrOk) then
      Begin
        // MH 16/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
        //                                   fields which processes the text and updates the value
        If (ActiveControl <> OkN1Btn) Then
          // Move focus to OK button to force any OnExit validation to occur
          OkN1Btn.SetFocus;

        // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
        If (ActiveControl = OkN1Btn) Then
          StoreNtxfr(InvF,SKeypath)
      End // If (ModalResult=mrOk)
      else
        If (ModalResult=mrCancel) then
        Begin
          ClsN1Btn.Click;
          Exit;
        end;
    end; {With..}
end;







procedure TTSheetForm.Display_Id(Mode  :  Byte);


Begin


  If (IdLine=nil) then
  Begin

    IdLine:=TTSLine.Create(Self);

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

     If (Mode In [1..3,8]) then
     Begin

       Case Mode of

         1..3,8
             :   If (Not ExLocal.InAddEdit) then
                     EditLine(Self.ExLocal.LInv,Self.ExLocal.LJobMisc^,(Mode=2),(Mode=8),Self.ExLocal.LViewOnly)
                   else
                     Show;


       end; {Case..}

     end
     else
       If (Not ExLocal.InAddEdit) then
         ShowLink(Self.ExLocal.LInv,Self.ExLocal.LJobMisc^,Self.ExLocal.LViewOnly);



   end; {With..}

   IdLineActive:=BOn;


  except

   IdLineActive:=BOff;

   IdLine.Free;

   InvBtnList.SetEnabBtn(BOn);

  end;

end;



procedure TTSheetForm.DeleteNTLine;

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
          InvFSU3U.UpdateRecBal(LId,LInv,BOn,BOff,17);

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


procedure TTSheetForm.EmpAcExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  mbRet      :  Word;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanN1Btn) and (ActiveControl<>ClsN1Btn) then
    Begin

      StillEdit:=BOn;

      //RB 30/11/2017 2018-R1 ABSEXCH-19393: GDPR (POST 19352) - 6.3.2 - Employee Open/Close behaviour - less anonymisation diary section
      FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,3,14));

      If (FoundOk) then
      Begin
        FoundOk:=Not JobMisc^.EmplRec.LabPLOnly;

        If (Not FoundOk) then
          CustomDlg(Application.MainForm,'Note!','Timesheet not allowed for employee',
                                'This Sub-contract employee has been set to have labour costs captured via the Purchase Ledger only.'+#13+
                                'Timesheets are not allowed for this Sub-contract employee.',
                                mtInformation,[mbOK]);

      end;

      If (FoundOk) then
      Begin
        {FoundOk:=Not }Cert_Expired(JobMisc^.EmplRec.EmpCode,N1TDateF.DateValue,BOff,BOn); {Just warn here}

      end;



      If (FoundOk) then
      With ExLocal do
      Begin

        StillEdit:=BOff;

        AssignFromGlobal(JMiscF);

        If (N1YRefF.Text='') or (Not LastEdit) then
          N1YRefF.Text:=JobMisc^.EmplRec.EmpName;

        Text:=FoundCode;
      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;


procedure TTSheetForm.N1TDateFExit(Sender: TObject);
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


procedure TTSheetForm.THUD1FEntHookEvent(Sender: TObject);
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

procedure TTSheetForm.THUD1FExit(Sender: TObject);
Begin
  If (Sender is Text8Pt)  and (ActiveControl<>CanN1Btn) and (ActiveControl<>ClsN1Btn) then
  Begin

    Text8pt(Sender).ExecuteHookMsg;

  end;
end;


procedure TTSheetForm.SetFieldProperties;

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
        {CheckColor:=N1YrefF.Color;}
        Color:=N1FPanel.Color;
      end;

  end; {Loop..}

end;


procedure TTSheetForm.SetFormProperties(SetList  :  Boolean);

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


procedure TTSheetForm.PropFlgClick(Sender: TObject);
begin
  SetFormProperties((N3.Tag=99));
  N3.Tag:=0;
end;



procedure TTSheetForm.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;





procedure TTSheetForm.LnkN1BtnClick(Sender: TObject);
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

procedure TTSheetForm.MenItem_AuditClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmAudit);
end;

procedure TTSheetForm.MenItem_DatedClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmDated);
end;

procedure TTSheetForm.MenItem_GeneralClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmGeneral);
end;

procedure TTSheetForm.SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
begin
  //Called when user uses Switch from pop-up menu on Notes form
  AddN1Btn.Enabled := NewMode <> nmAudit;
  EditN1Btn.Enabled := NewMode <> nmAudit;
  InsN1Btn.Enabled := NewMode <> nmAudit;
  DelN1Btn.Enabled := NewMode <> nmAudit;
end;

//PR: 20/11/2017 ABSEXCH-19451
procedure TTSheetForm.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;

  //Description
  N1YRefF.AllowPostedEdit := True;

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
function TTSheetForm.TransactionViewOnly: Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;

//SSK 09/01/2018 2018R1 ABSEXCH-19561: Implements anonymisation behaviour for Job related transactions
procedure TTSheetForm.SetAnonymisationON(AValue: Boolean);
begin
  FAnonymisationON := AValue;
  SetAnonymisationBanner;
end;

procedure TTSheetForm.SetAnonymisationBanner;
var
  lAnonymised: Boolean;
begin

  if FAnonymisationON then
  begin
    if (pnlAnonymisationStatus.Visible or FSaveAnonPanelCord) then
      InitSize.Y := Self.ClientHeight
    else
      InitSize.Y := Self.ClientHeight + pnlAnonymisationStatus.Height;
  end
  else
  begin
    if (pnlAnonymisationStatus.Visible or FSaveAnonPanelCord) then
      InitSize.Y := Self.ClientHeight - pnlAnonymisationStatus.Height
    else
      InitSize.Y := Self.ClientHeight;
    PagePoint[0].Y:= 3;
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
end;

procedure TTSheetForm.SetAnonymisationPanel;
begin
  if GDPROn and FAnonymisationON then
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

Initialization

end.
