unit BatchEnU;

interface

{$I DefOvr.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,ExWrap1U,BTSupU1,SupListU,SBSComp2,BorBtns, SalTxl1U,
  {$IFDEF NP}
    NoteU,
  {$ENDIF}

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}
  SBSComp,
  ExtGetU, Menus, BatchLnU;

type



  TBatchMList  =  Class(TDDMList)

  Public
    DayBkListMode      :  Byte;
    BatchLine          :  BatchLineRec;


    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;


  end;




  TBatchEntry = class(TForm)
    PageControl1: TPageControl;
    MainPage: TTabSheet;
    I1SBox: TScrollBox;
    I1QtyPanel: TSBSPanel;
    I1StkCodePanel: TSBSPanel;
    I1DescPanel: TSBSPanel;
    I1LTotPanel: TSBSPanel;
    I1VATPanel: TSBSPanel;
    I1HedPanel: TSBSPanel;
    I1SCodeLab: TSBSPanel;
    I1QtyLab: TSBSPanel;
    I1VATLab: TSBSPanel;
    I1DescLab: TSBSPanel;
    I1LTotLab: TSBSPanel;
    I1ItemLab: TSBSPanel;
    I1ItemPanel: TSBSPanel;
    I1ListBtnPanel: TSBSPanel;
    I1BtmPanel: TSBSPanel;
    Label813: Label8;
    I1CCLab: Label8;
    I1DepLab: Label8;
    Label819: Label8;
    I1VATTLab: Label8;
    Label821: Label8;
    CurrLab1: Label8;
    I1NomCodeF: Text8Pt;
    I1CCF: Text8Pt;
    I1DepF: Text8Pt;
    INetTotF: TCurrencyEdit;
    IVATTotF: TCurrencyEdit;
    IGTotF: TCurrencyEdit;
    AnalPage: TTabSheet;
    I2BtmPanel: TSBSPanel;
    I2StkDescLab: Label8;
    I2StkDescF: Text8Pt;
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
    I1FPanel: TSBSPanel;
    I1DumPanel: TSBSPanel;
    I1BtnPanel: TSBSPanel;
    I1BSBox: TScrollBox;
    EditI1Btn: TButton;
    CopyI1Btn: TButton;
    FullI1Btn: TButton;
    chkI1Btn: TButton;
    AddI1Btn: TButton;
    I1BtnPanel2: TSBSPanel;
    I1StatLab: Label8;
    OkI1Btn: TButton;
    CanI1Btn: TButton;
    ClsI1Btn: TButton;
    I1YRefLab: TSBSPanel;
    I1YRefPanel: TSBSPanel;
    SBSPanel3: TSBSPanel;
    Label817: Label8;
    I1OurRefF: Text8Pt;
    I1OpoF: Text8Pt;
    I1TransDateF: TEditDate;
    Label84: Label8;
    Label88: Label8;
    I1PrYrF: TEditPeriod;
    Label82: Label8;
    I1BNomF: Text8Pt;
    Label83: Label8;
    I1CqStartF: TCurrencyEdit;
    I1CurrLab: Label8;
    I1CurrF: TSBSComboBox;
    I1BTotF: TCurrencyEdit;
    I1BDifF: TCurrencyEdit;
    Label81: Label8;
    SBSPanel4: TSBSPanel;
    SBSPanel5: TSBSPanel;
    I1AddrF: TMemo;
    I1PayTF: TCurrencyEdit;
    Label85: Label8;
    I2SBox: TScrollBox;
    I2CCPanel: TSBSPanel;
    I2OrefPanel: TSBSPanel;
    I2JCPanel: TSBSPanel;
    I2JAPanel: TSBSPanel;
    I2VATPanel: TSBSPanel;
    I2HedPanel: TSBSPanel;
    I2OrefLab: TSBSPanel;
    I2CCLab: TSBSPanel;
    I2VATLab: TSBSPanel;
    I2JCLab: TSBSPanel;
    I2JALab: TSBSPanel;
    I2GLLab: TSBSPanel;
    I2DepLab: TSBSPanel;
    I2GLPanel: TSBSPanel;
    I2DepPanel: TSBSPanel;
    I2AcPanel: TSBSPanel;
    I2AcLab: TSBSPanel;
    CurrLab2: Label8;
    Label87: Label8;
    I2VATTLab: Label8;
    Label810: Label8;
    InsI1Btn: TButton;
    SwiI1Btn: TButton;
    PopupMenu2: TPopupMenu;
    Copy2: TMenuItem;
    Reverse1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Insert1: TMenuItem;
    Switch1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    Full1: TMenuItem;
    Copy1: TMenuItem;
    Check1: TMenuItem;
    DelI1Btn: TButton;
    Delete1: TMenuItem;
    LnkI1Btn: TButton;
    Links1: TMenuItem;
    pnlAnonymisationStatus: TPanel;
    shpNotifyStatus: TShape;
    lblAnonStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    function I1PrYrFConvDate(Sender: TObject; const IDate: string;
      const Date2Pr: Boolean): string;
    procedure I1TransDateFExit(Sender: TObject);
    procedure I1CurrFExit(Sender: TObject);
    procedure I1AddrFClick(Sender: TObject);
    procedure OkI1BtnClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure I1StkCodePanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure I1SCodeLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure I1SCodeLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure DelI1BtnClick(Sender: TObject);
    procedure AddI1BtnClick(Sender: TObject);
    procedure SwiI1BtnClick(Sender: TObject);
    function I1PrYrFShowPeriod(Sender: TObject; const EPr: Byte): string;
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure ClsI1BtnClick(Sender: TObject);
    procedure I1BNomFExit(Sender: TObject);
    procedure I1BTotFExit(Sender: TObject);
    procedure chkI1BtnClick(Sender: TObject);
    procedure FullI1BtnClick(Sender: TObject);
    procedure CopyI1BtnClick(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure I1CurrFEnter(Sender: TObject);
    procedure LnkI1BtnClick(Sender: TObject);
    procedure I1CqStartFExit(Sender: TObject);
  private
    { Private declarations }
    bHelpContextInc, //NF: 12/04/06
    InHBeen,
    InPassing,
    GenSelect,
    JustCreated,
    InvStored,
    StopPageChange,
    DirectStore,
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
    CanDelete    :  Boolean;

    LKeypath,
    MinHeight,
    MinWidth     :  Integer;

    {$IFDEF NP}
      NotesCtrl  :  TNoteCtrl;
    {$ENDIF}

    DispCust     :  TFCustDisplay;

    InvBtnList   :  TVisiBtns;

    IdLineActive :  Boolean;
    IdLine       :  TBEntryLine;

    DispTransPtr
                 :  Pointer;


    RecordPage   :  Byte;
    LastDocHed,
    DocHed       :  DocTypes;

    OldConTot    :  Double;

    PagePoint  :  Array[0..6] of TPoint;

    {NeedCUpdate}
    StartSize,
    InitSize   :  TPoint;

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}

    //AP 07/12/2017 2018R1 ABSEXCH-19538:variable added to handle anonymisation behaviour
    FListScanningOn,
    FAnonymisationON: Boolean;

    Procedure SetForceStore(State  :  Boolean);

    procedure Find_Page1Coord(PageNo  :  Integer);

    procedure Store_Page1Coord(UpMode  :  Boolean);

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure Display_Id(Mode  :  Byte);

    Procedure Link2Nom;

    Procedure SetCurrStat;

    Function ScanMode  :  Boolean;

    procedure Check_Batch;

    Function Batch_Required(InvR  :  InvRec)  :  Real;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure NotePageReSize;

    Function CheckNeedStore  :  Boolean;

    Function ConfirmQuit  :  Boolean;

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure SetFieldProperties;

    procedure SetFormProperties(SetList  :  Boolean);

    procedure SetNewFolio;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure SetHelpContextIDsForPage(bInc : boolean); // NF: 12/04/06
    //HV 12/11/2017 ABSEXCH-19549: Anonymised Notification banner in View/Edit Record > Banner not displayed on maximise and then Restore Down.
    procedure SetAnonymisationPanel;
  public
    { Public declarations }


    fForceStore:  Boolean;

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;

    MULCtrlO   :  TBatchMList;

    MULVisiList:  Array[0..3] of TVisiList;

    { CJS 2012-08-16 - ABSEXCH-13263 - Array of source controls to hold the
                                       font details, used by SBSComp }
    SourceListBox: array[0..3] of TStringGridEx;


    Property ForceStore  : Boolean read fForceStore write SetForceStore default False;

    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1  :  LongInt) :  LongInt;

    procedure PrimeButtons;

    procedure BuildDesign;

    procedure BuildMenus;

    procedure FormDesign;

    procedure HidePanels(PageNo    :  Byte);

    Procedure SetColDec(PageNo  :  Byte);

    Procedure InitVisiList(PageNo  :  Byte);

    Function Current_BarPos(Const PageNo  :  Byte)  :  Integer;

    Procedure SetCurrent_BarPos(Const PageNo  :  Byte;
                                Const NewBO   :  Integer);

    Procedure ChangeList(PageNo    :  Byte;
                         ShowLines :  Boolean);

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    Function Current_Page  :  Integer;

    Function SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

    procedure FormSetOfSet;

    procedure Display_Trans(Mode  :  Byte);

    procedure ShowLink(ShowLines,
                       VOMode    :  Boolean);


    Procedure ChangePage(NewPage  :  Integer);


    Procedure SetInvTotPanels(NewIndex  :  Integer);

    Procedure OutInvTotals(NewIndex  :  Integer);



    procedure SetInvFields;

    procedure OutInv;

    procedure Form2Inv;

    Procedure SetFieldFocus;

    procedure SetInvStore(EnabFlag,
                          VOMode  :  Boolean);

    Procedure Batch_Change(OInv,InvR  :  InvRec;
                           KPath      :  SmallInt);

    procedure ProcessInv(Fnum,
                         KeyPAth    :  Integer;
                         Edit,
                         AutoOn     :  Boolean);

    Procedure NoteUpdate;

    Function CheckCompleted(Edit  :  Boolean)  : Boolean;

    procedure StoreInv(Fnum,
                       KeyPAth    :  Integer);


    procedure EditAccount(Edit,
                          AutoOn,
                          ViewOnly   :  Boolean);

    //AP 07/12/2017 2018R1 ABSEXCH-19538:Anonymised Transactions > Notification banner is not displayed for SRC, PPY, xBT.
    procedure SetAnonymisationBanner;
    property ListScanningOn: Boolean read FListScanningOn write FListScanningOn;

  end;


Procedure Set_BatchFormMode(State  :  DocTypes;
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

  ConvDocU,

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

  SysU1,
  SysU2,
  MiscU,
  IntMU,

  {$IFDEF SOP}

    SALTxl2U,

  {$ENDIF}

  STxMenu,

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  PayF2U,

  ThemeFix,
  
  ExThrd2U,
  Event1U,
  Tranl1U,
  GenWarnU,
  Warn1U,
  AuditNotes,

  { CJS - 2013-10-25 - MRD2.6.07 - Transaction Originator }
  TransactionOriginator,

  //AP 07/12/2017 2018R1 ABSEXCH-19538:Anonymised Transactions > Notification banner is not displayed for SRC, PPY, xBT.
  {$IFNDEF EXDLL}
    oSystemSetup,
  {$ENDIF}
  GDPRConst;

{$R *.DFM}

Var
  BatchFormMode  :  DocTypes;
  BatchFormPage  :  Byte;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_BatchFormMode(State  :  DocTypes;
                            NPage  :  Byte);

Begin
  If (State<>BatchFormMode) then
    BatchFormMode:=State;

  If (BatchFormPage<>NPage) then
    BatchFormPage:=NPage;

end;




{$I BatchTIU.PAS}



procedure TBatchEntry.SetForceStore(State  :  Boolean);

Begin
  If (State<>fForceStore) then
  Begin
    fForceStore:=State;

    If (Not ExLocal.LViewOnly) then
    Begin
      ClsI1Btn.Enabled:=Not fForceStore;
      CanI1Btn.Enabled:=ClsI1Btn.Enabled;
    end;

  end;

end;


procedure TBatchEntry.Find_Page1Coord(PageNo  :  Integer);


Var

  n       :  Integer;

  GlobComp:  TGlobCompRec;


Begin
  If (MULCtrlO<>nil) then
  With MULCtrlO do
  Begin

    New(GlobComp,Create(BOn));

    With GlobComp^ do
    Begin
      GetValues:=BOn;

      PrimeKey:='B';

      HasCoord:=LastCoord;

      Find_ListCoord(GlobComp);

      GetbtControlCsm(VisiList.LabHedPanel);

    end; {With GlobComp..}


    Dispose(GlobComp,Destroy);

  end;
end;


procedure TBatchEntry.Store_Page1Coord(UpMode  :  Boolean);


Var
  n       :  Byte;
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin

    GetValues:=UpMode;

    SaveCoord:=StoreCoord;

    PrimeKey:='B';

    For n:=1 to High(MULVisiList) do
    If (MULVisiList[n]<>nil) then
    With MULCtrlO do
    Begin
      VisiList:=MULVisiList[n];
      { CJS 2012-08-16 - ABSEXCH-13263 - Make sure that SBSComp uses the
                                         correct source control for the font
                                         details. }
      MUListBox1 := SourceListBox[n];

      Store_ListCoord(GlobComp);

      StorebtControlCsm(VisiList.LabHedPanel); {* Move to object store *}
    end;


    If (Current_Page<=High(MULVisiList)) then
      With MULCtrlO do
      Begin
        VisiList:=MULVisiList[Current_Page];
        { CJS 2012-08-16 - ABSEXCH-13263 - Restore the source control for the
                                           current page. }
        MUListBox1 := SourceListBox[Current_Page];
      end;

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;

Procedure  TBatchEntry.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TBatchEntry.Find_FormCoord;


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

    PrimeKey:='B';

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

    GetbtControlCsm(I1SBox);

    GetbtControlCsm(I1BSBox);

    GetbtControlCsm(I1BtnPanel);

    GetbtControlCsm(I1ListBtnPanel);

    GetbtControlCsm(TCNScrollBox);
    GetbtControlCsm(TCNListBtnPanel);


    If GetbtControlCsm(I1BNomF) then
      SetFieldProperties;


    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range *}

  //RB 07/12/2017 ABSEXCH-19538: Anonymised Transaction > The height of the window gets increased if "Save coordinates" is ticked
 (** With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;        **)

  {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TBatchEntry.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='B';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    //AP 07/12/2017 ABSEXCH-19538: Anonymised Transaction > The height of the window gets increased if "Save coordinates" is ticked
    //RB 28/12/2017 ABSEXCH-19538: Anonymised Transaction > The height of the window gets increased if "Save coordinates" is ticked
    if pnlAnonymisationStatus.Visible then
    begin
      Self.ClientHeight := Self.ClientHeight - pnlAnonymisationStatus.Height;
      Self.ClientWidth := Self.ClientWidth;
    end;
    
    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(I1SBox);

    StorebtControlCsm(I1BSBox);

    StorebtControlCsm(I1BtnPanel);

    StorebtControlCsm(I1ListBtnPanel);

    StorebtControlCsm(I1BNomF);

    StorebtControlCsm(TCNScrollBox);

    StorebtControlCsm(TCNListBtnPanel);

    MULCtrlO.Store_ListCoord(GlobComp);

    {$IFDEF NP}
      If (NotesCtrl<>nil) then
        NotesCtrl.MULCtrlO.Store_ListCoord(GlobComp);
    {$ENDIF}



  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

  Store_Page1Coord(UpMode);

end;




Function TBatchEntry.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;



procedure TBatchEntry.Display_Id(Mode  :  Byte);

Var
  CPage    :  Integer;

Begin

  CPage:=Current_Page;

  If (IdLine=nil) then
  Begin

    IdLine:=TBEntryLine.Create(Self);

  end;

  Try


   With IdLine do
   Begin

     DocHed:=LastDocHed;

     SetHelpContextIDs; // NF: 25/07/06 Fix for incorrect Context IDs

     WindowState:=wsNormal;
     {Show;}


     InvBtnList.SetEnabBtn(BOff);

     {Self.Enabled:=BOff;}

     If (Mode In [1..3]) then
     Begin

       Case Mode of

         1..3  :   If (Not ExLocal.InAddEdit) then
                     EditLine(Self.ExLocal.LInv,(Mode=2),(Self.ExLocal.LViewOnly or (MUlCtrlO.BatchLine.BatchSplit and (Mode<>1))))
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


Procedure TBatchEntry.Link2Nom;

Var
  FoundCode  :  LongInt;
  FoundStk   :  Str20;

Begin
  With MULCtrlO,BatchLine do
  Begin
    If (SBTRef<>Inv.OurRef) then
     Begin
       Doc2Batch(BatchLine,Inv);

       Get_BatchId(BatchLine,Inv);
     end;


    If (Nom.NomCode<>BNomCode) then
    Begin
      Nom.Desc:='';
      Global_GetMainRec(NomF,FullNomKey(BNomCode));
    end;

    I1NomCodeF.Text:=dbFormatName(Form_Int(BNomCode,0),Nom.Desc);
    I2StkDescF.Text:=Nom.Desc;

    I1CCF.Text:=BCCDep[BOn];
    I1DepF.Text:=BCCDep[BOff];

    If (ExLocal.LCust.CustCode<>BCustCode) then
    Begin
      Global_GetMainRec(CustF,BCustCode);

      ExLocal.AssignFromGlobal(CustF);

      CustToMemo(Cust,I1AddrF,0);

      I1PayTF.Value:=Cust.PayTerms;

      If (DispCust<>nil) then
      With DispCust do
      Begin
        If (CustActive) then
          I1AddrFClick(I1AddrF);
      end;
    end;

  end; {With..}
end; {Proc..}


Procedure TBatchEntry.SetCurrStat;

Begin
  {$IFDEF MC_On}

    With ExLocal,LInv do
      I1CurrF.ReadOnly:=((Round(ITotal(LInv))<>0) or (RunNo=BatchRunNo));

  {$ENDIF}
end;

Function TBatchEntry.ScanMode  :  Boolean;

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


Procedure TBatchEntry.WMCustGetRec(Var Message  :  TMessage);

Var
  mbRet  :  Word;

Begin


  With Message do
  Begin


    Case WParam of
      0,169
         :  Begin
              MULCtrlO.GetSelRec(BOff);

              Case Current_Page of

                99  :  ;

                else  Begin
                        With MULCtrlO do
                          Get_BatchId(BatchLine,Inv);

                        If (MulCtrlO.BatchLine.BatchSplit) then
                          Display_Trans(2)
                        else
                          Display_Id(2);

                        If (IdLineActive) and (Not ExLocal.InAddEdit) then {*it must be readonly *}
                          IdLine.Show;
                      end;
              end; {Case..}

            end;

      1  :  Begin

              {* Show nominal/cc dep data *}
              Link2Nom;

              If (IdLine<>nil) and (IdLineActive) then
              With IdLine do
              Begin
                If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit)
                and (Inv.OurRef<>ExLocal.LInv.OurRef) then
                Begin
                  Display_Id(0);
                end;
              end;

              InHBeen:=(InHBeen and ScanMode);

              Display_Trans(100);

            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      7  :  NoteUpDate; {* Update note line count *}

      8  :  ;  {Pay in line update *}

     17  :  Begin {* Force reset of form *}
              GotCoord:=BOff;
              SetDefault:=BOn;
              Close;
            end;

     18  :  Begin
              If (Not ExLocal.LViewOnly) then
              Begin
                With MULCtrlO do
                  AddNewRow(MUListBoxes[0].Row,BOn);

                Check_Batch;
              end;
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
                 LInv:=IdLine.BInv;

                 If (LastEdit) and (Not LViewOnly) and (Not ForceStore) then
                   ForceStore:=((LInv.ILineCount<>LastInv.ILineCount) or
                                (Linv.Variance<>LastInv.Variance) or
                                (ITotal(LInv)<>ITotal(LastInv)));

               end;


               OutInvTotals(0);

               With MULCtrlO do
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));

            end;



     120,121
         :  Begin

              InvBtnList.SetEnabBtn((WParam=120));

            end;

     131 :  Begin
              If (Assigned(IdLine)) then
              Begin
                CustToMemo(IdLine.ExLocal.LCust,I1AddrF,0);
              end;
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

     171 :  Begin  {* Link for ObjectDrill *}
              MULCtrlO.GetSelRec(BOff);
              ExLocal.AssignToGlobal(InvF);
            end;

     175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

     176 :  Case LParam of
              0  :  Case Current_Page of
                      2  :  {$IFDEF NP}
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
              DispTransPtr:=nil;

                
            end;

     201 :  Begin
              {* Detail Line Call *}

              {Self.Enabled:=BOn;
              Self.Show;}

              InvBtnList.SetEnabBtn(BOn);

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

      3000,
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
            end;



    end; {Case..}

  end;
  Inherited;
end;


Procedure TBatchEntry.WMFormCloseMsg(Var Message  :  TMessage);
Begin


  With Message do
  Begin


  end;
  Inherited;
end;



Procedure TBatchEntry.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TBatchEntry.Send_UpdateList(Edit   :  Boolean;
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


procedure TBatchEntry.ShowLink(ShowLines,
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

    If (Not JustCreated) then {* Rebuild design based on doc type *}
    Begin
      DocHed:=LInv.InvDocHed;
      BuildDesign;
    end;

  end;

  OutInv;


  If (Not JustCreated) then {* Invoice already exisits *}
  Begin
    Case Current_Page of

      99  :  ;

      else  Begin
              ChangeList(Current_Page,BOff);
              ReFreshList(ShowLines,Not JustCreated);
            end;

    end; {Case..}
  end
  else
    ReFreshList(ShowLines,Not JustCreated);




  {* Set any fields specific to doc type here *}

  {RPayF.Visible:=(Not RecordMode);
  Label833.Visible:=(Not RecordMode);}

  {$IFDEF NP}

    If (Current_Page=2) and (NotesCtrl<>nil) then {* Assume record has changed *}
    With ExLocal do
    Begin
      NotesCtrl.RefreshList(FullNomKey(LInv.FolioNum),NotesCtrl.GetNType);
      NotesCtrl.GetLineNo:=LInv.NLineCount;
    end;
  {$ENDIF}

  JustCreated:=BOff;

end;


{ ======= Link to Trans display ======== }

procedure TBatchEntry.Display_Trans(Mode  :  Byte);

Var
  DispTrans  :  TFInvDisplay;
Begin

  InHBeen:=(Mode<>100);

  If (DispTransPtr=nil) then
  Begin
    DispTrans:=TFInvDisplay.Create(Self);
    DispTransPtr:=DispTrans;
  end
  else
    DispTrans:=DispTransPtr;

    try

      With DispTrans do
      Begin
        LastDocHed:=Inv.InvDocHed;
        Self.LastDocHed:=LastDocHed;
        fBatchEdit:=(Mode<>100);

        If ((LastFolio<>Inv.FolioNum) or (Mode<>100)) and (InHBeen) then
          Display_Trans(Mode,Inv.FolioNum,BOff,(Mode<>100));

      end; {with..}

    except

      DispTrans.Free;

    end;

end;


procedure TBatchEntry.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(I1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(I1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(I1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(I1BtnPanel.Height);

  PagePoint[3].X:=I1BtnPanel.Height-(I1BSBox.Height);
  PagePoint[3].Y:=I1SBox.ClientHeight-(I1StkCodePanel.Height);

  PagePoint[4].X:=PageControl1.Width-(I1ListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(I1ListBtnPanel.Height);

  PagePoint[5].X:=PageControl1.Width-(TCNScrollBox.Width);
  PagePoint[5].Y:=PageControl1.Height-(TCNScrollBox.Height);

  PagePoint[6].Y:=PageControl1.Height-(TCNListBtnPanel.Height);


  GotCoord:=BOn;

end;


Function TBatchEntry.SetHelpC(PageNo :  Integer;
                              Pages  :  TIntSet;
                              Help0,
                              Help1  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    If (PageNo=2) then
      Result:=Help1
    else
      Result:=Help0;
  end
  else
    Result:=-1;

end;


procedure TBatchEntry.PrimeButtons;

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
     {00} AddVisiRec(AddI1Btn,BOff);
     {01} AddVisiRec(EditI1Btn,BOff);
     {02} AddVisiRec(InsI1Btn,BOff);
     {03} AddVisiRec(DelI1Btn,BOff);
     {04} AddVisiRec(FullI1Btn,BOff);
     {05} AddVisiRec(CopyI1Btn,BOff);
     {06} AddVisiRec(ChkI1Btn,BOff);
     {07} AddVisiRec(SwiI1Btn,BOff);
     {08} AddVisiRec(LnkI1Btn,BOff);
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
      SetHideBtn(0,((ExLocal.LViewOnly) and (PageNo<>2)) ,BOff);

      {SetHideBtn(1,IdLineActive,BOff);}

      SetBtnHelp(0,SetHelpC(PageNo,[0..6],40035,88));
      SetBtnHelp(1,SetHelpC(PageNo,[0..6],40011,87));


      SetHideBtn(2,(PageNo<>2),BOff);

      SetBtnHelp(2,SetHelpC(PageNo,[0..6],262,86));

      SetHideBtn(3,(PageNo<>2),BOff);

      SetBtnHelp(3,SetHelpC(PageNo,[0..6],263,89));

      SetHideBtn(4,(ExLocal.LViewOnly or (PageNo=2)),BOff);
      SetHideBtn(5,(ExLocal.LViewOnly or (PageNo=2)),BOff);
      SetHideBtn(6,(ExLocal.LViewOnly or (PageNo=2)),BOff);

      SetHideBtn(7,(PageNo<>2),BOff);
      SetHideBtn(8,(PageNo In [2]),BOn);


      If (IdLineActive) and (PageNo<>2) then {* Reset during a line edit *}
        InvBtnList.SetEnabBtn(BOff);

    end;

    SetHelpContextIDsForPage(TRUE); //NF: 12/04/06

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure TBatchEntry.BuildMenus;

Begin

  CreateSubMenu(PopUpMenu2,Copy1);
end;

procedure TBatchEntry.BuildDesign;

Var
  HideCC  :  Boolean;

begin

  HideCC:=BOff;

  {* Set Version Specific Info *}

  {$IFNDEF MC_On}
    I1CurrLab.Caption:='Batch Total';
    I1BTotF.Left:=I1CurrF.Left;

    I1CurrF.Visible:=BOff;
  {$ENDIF}


  {$IFNDEF PF_On}
    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}

  I1CCLab.Visible:=Not HideCC;
  I1CCF.Visible:=Not HideCC;
  I1DepLab.Visible:=Not HideCC;
  I1DepF.Visible:=Not HideCC;


  {$IFDEF MC_On}

    Set_DefaultCurr(I1CurrF.Items,BOff,BOff);
    Set_DefaultCurr(I1CurrF.ItemsL,BOff,BOn);

  {$ENDIF}


end;


procedure TBatchEntry.FormDesign;


begin

  I1VATLab.Caption:=CCVATName^;
  I2VATLab.Caption:=CCVATName^;
  I1VATTLab.Caption:=CCVATName^+I1VATTLab.Caption;
  I2VATTLab.Caption:=CCVATName^+I2VATTLab.Caption;

  I1CqStartF.DisplayFormat:='';

  PrimeButtons;

  BuildDesign;

  BuildMenus;


end;

procedure TBatchEntry.HidePanels(PageNo    :  Byte);

Var
  CCDepBo
         :  Boolean;
  n      :  Integer;

Begin
  With MULCtrlO,VisiList do
  Begin
    fBarOfSet:=Current_BarPos(PageNo);
    vUseOfSet:=BOn;

    Case PageNo of

      1  :  Begin
              CCDepBo:=BOff;

              {$IFNDEF PF_On}
                CCDepBo:=BOn;
              {$ELSE}
                CCDepBo:=Not Syss.UseCCDep;
              {$ENDIF}

              SetHidePanel(3,CCDepBo,BOff);
              SetHidePanel(4,CCDepBo,BOff);

              SetHidePanel(5,Not JBCostOn,BOff);
              SetHidePanel(6,Not JBCostOn,BOn);

            end;

    end; {Case..}

  end;
end;

Procedure TBatchEntry.SetColDec(PageNo  :  Byte);

Var
  n  :  Byte;

Begin
  With MULCtrlO do
  Begin
    For n:=0 to MUTotCols do
    With ColAppear^[n] do
    Begin
      AltDefault:=BOn;

      DispFormat:=SGText;

      Case PageNo of
        0  :  If (n=5) then
              Begin
                DispFormat:=SGFloat;
                NoDecPlaces:=2;
              end;
        1  :  If (n=2) then
              Begin
                DispFormat:=SGFloat;
                NoDecPlaces:=0;
              end;
      end; {Case..}
    end; {loop..}
  end; {With..}
end; {Proc..}


Procedure TBatchEntry.InitVisiList(PageNo  :  Byte);

Var
  Idx  :  Integer;

Begin
  If (MULVisiList[PageNo]=nil) then
  Begin
    MULVisiList[PageNo]:=TVisiList.Create;
    { CJS 2012-08-16 - ABSEXCH-13263 - Create the source control for the font
                                       details for the list on the current
                                       page. }
    SourceListBox[PageNo] := TStringGridEx.Create(MULCtrlO);
    SourceListBox[Pageno].DefaultRowHeight := abs(SourceListBox[Pageno].Font.Height) + 5;

    try

      With MULVisiList[PageNo] do
      Case PageNo of

        1  :
              Begin

                AddVisiRec(I2ORefPanel,I2OrefLab);
                AddVisiRec(I2AcPanel,I2AcLab);
                AddVisiRec(I2GLPanel,I2GLLab);
                AddVisiRec(I2CCPanel,I2CCLab);
                AddVisiRec(I2DepPanel,I2DepLab);
                AddVisiRec(I2JCPanel,I2JCLab);
                AddVisiRec(I2JAPanel,I2JALab);
                AddVisiRec(I2VATPanel,I2VATLab);

                LabHedPanel:=I2HedPanel;

              end;

      end; {Case..}

      With MULCtrlO do
      Begin
        VisiList:=MULVisiList[PageNo];
        MUListBox1 := SourceListbox[PageNo];
      end;

      {* Get coordinates here ? *}

      {Find_Page1Coord(PageNo);}

      With MULCtrlO do
        Match_VisiList(MULVisiList[0],VisiList);

    except

      MULVisiList[PageNo].Free;

      MULVisiList[PageNo]:=nil;

      { CJS 2012-08-16 - ABSEXCH-13263 - Free the source control. }
      SourceListBox[PageNo].Free;
      SourceListBox[PageNo] := nil;
    end; {try..}

  end; {already initialised}
end; {Proc..}


Function TBatchEntry.Current_BarPos(Const PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      0
         :  Result:=I1SBox.HorzScrollBar.Position;

      1  :  Result:=I2SBox.HorzScrollBar.Position;
      else  Result:=0;
    end; {Case..}


end;

Procedure TBatchEntry.SetCurrent_BarPos(Const PageNo  :  Byte;
                                        Const NewBO   :  Integer);

Begin
  Case PageNo of
      0
         :  I1SBox.HorzScrollBar.Position:=NewBO;

      1  :  I2SBox.HorzScrollBar.Position:=NewBO;
    end; {Case..}


end;


Procedure TBatchEntry.ChangeList(PageNo   :  Byte;
                                 ShowLines:  Boolean);


Var
  NewBar  :  Integer;

Begin

  NewBar:=0;


  If (PageNo<2) then
  With MULCtrlO do
  Begin
    SetCurrent_BarPos(PageNo,0);

    If (MULVisiList[PageNo]=nil) then
      InitVisiList(PageNo)
    else
    Begin
      VisiList:=MULVisiList[PageNo];
      { CJS 2012-08-16 - ABSEXCH-13263 - Make sure that SBSComp uses the
                                         correct source control for the font
                                         details. }
      MUListBox1 := SourceListBox[PageNo];
    end;

    { CJS 2010-08-31 - ABSEXCH-13344 - Grid index out of range on list. Call
      RefreshAllCols to force the number of rows on the list to be set
      correctly. }
    RefreshAllCols;

    I1ListBtnPanel.Parent:=PageControl1.Pages[PageNo];

    DayBkListMode:=PageNo;

    SetColDec(PageNo);

    HidePanels(PageNo);

    ReAssignCols;

    {If (PageNo In [2,3]) then
      ApplyReSizeAllCols(0,NewBar,BOn);}

    If (ShowLines) then
    Begin
      PageUpDn(0,BOn);

      VisiList.SetHedPanel(ListOfSet+NewBar);
    end;

  end; {With..}

end;


procedure TBatchEntry.RefreshList(ShowLines,
                                  IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;

Begin

  KeyStart:=ExLocal.LInv.OurRef;

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(InvF,InvBatchK,KeyStart,'','',DocKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TBatchEntry.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TBatchMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO do
    Begin

      Try

        With VisiList do
        Begin
          AddVisiRec(I1StkCodePanel,I1SCodeLab);
          AddVisiRec(I1ItemPanel,I1ItemLab);
          AddVisiRec(I1QtyPanel,I1QtyLab);
          AddVisiRec(I1YRefPanel,I1YRefLab);
          AddVisiRec(I1DescPanel,I1DescLab);
          AddVisiRec(I1LTotPanel,I1LTotLab);
          AddVisiRec(I1VATPanel,I1VATLab);
          AddVisiRec(I1DumPanel,I1DumPanel);


          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(0);

          LabHedPanel:=I1HedPanel;

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

      SetColDec(0);

      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      DayBkListMode:=0;

      Set_Buttons(I1ListBtnPanel);

      ReFreshList(ShowLines,BOff);

      MULVisiList[0]:=VisiList;
      { CJS 2012-08-16 - ABSEXCH-13263 - Take a copy of the default source control. }
      SourceListBox[0] := MUListBox1;

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;


  FormSetOfSet;

  FormReSize(Self);

end;



{ ==== Display Invoice Total ==== }

Procedure TBatchEntry.SetInvTotPanels(NewIndex  :  Integer);

Var
  NewParent  :  TWinControl;

Begin

  INetTotF.Visible:=(NewIndex In [0..1]);

  IVatTotF.Visible:=(INetTotF.Visible);

  IGTotF.Visible:=(IVATTotF.Visible);

  If (NewIndex In [0,1]) then
  Begin
    Case NewIndex of
      1  :  NewParent:=I2BtmPanel;
      else  NewParent:=I1BtmPanel;
    end; {Case..}

    INetTotF.Parent:=NewParent;
    IVatTotF.Parent:=NewParent;
    IGTotF.Parent:=NewParent;
  end;

end;

Procedure TBatchEntry.OutInvTotals(NewIndex  :  Integer);

Begin

  With ExLocal,LInv do
  Begin
    {$IFDEF MC_On}
      CurrLab1.Caption:=SSymb(Currency);
      CurrLab2.Caption:=SSymb(Currency);
    {$ENDIF}

    IGTotF.Value:=ITotal(LInv);
    IVATTotF.Value:=InvVAT;
    INetTotF.Value:=InvNetVal-DiscSetAm;
    I1BDifF.Value:=Batch_Required(LInv);

  end;

end;


{ ======= Work out batch required =========}

Function TBatchEntry.Batch_Required(InvR  :  InvRec)  :  Real;

Begin

  With InvR do
    Batch_Required:=Round_Up(ITotal(InvR)-(TotalInvoiced*DocCnst[InvDocHed]*DocNotCnst),2);

end; {Func..}



{ ======== Display Invoice Record ========== }

procedure TBatchEntry.SetInvFields;

Var
  GenStr       :  Str255;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    I1OurRefF.Text:=Pr_OurRef(LInv);
    I1OpoF.Text:=OpName;

    { CJS - 2013-10-25 - MRD2.6.07 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      I1OpoF.Hint := GetOriginatorHint(LInv)
    else
      I1OpoF.Hint := '';

    I1PrYrF.InitPeriod(AcPr,AcYr,BOn,BOn);

    I1TransDateF.DateValue:=TransDate;
    {I1YrRefF.Text:=YourRef;
    I1YrRef2F.Text:=TransDesc;}

    {$IFDEF MC_On}
      If (Currency>0) then
        I1CurrF.ItemIndex:=Pred(Currency);

    {$ENDIF}

    I1CqStartF.Text:=RemitNo;

    I1BNomF.Text:=Form_BInt(BatchNom,0);
    I1BTotF.Value:=TotalInvoiced;

  end; {With..}
end;


{ ======== Display Invoice Record ========== }

procedure TBatchEntry.OutInv;

Var
  GenStr       :  Str255;
  FoundCode    :  Str20;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    SetInvFields;

    OutInvTotals(Current_Page);
  end; {With..}
end;


procedure TBatchEntry.Form2Inv;

Begin
  With ExLocal.LInv do
  Begin
    TransDate:=I1TransDateF.DateValue;
    I1PrYrF.InitPeriod(AcPr,AcYr,BOff,BOff);

    {YourRef:=I1YrRefF.Text;
    TransDesc:=I1YrRef2F.Text;}

    {$IFDEF MC_On}

      Currency:=Succ(I1CurrF.ItemIndex);
    {$ENDIF}

    BatchNom:=IntStr(I1BNomF.Text);
    TotalInvoiced:=I1BTotF.Value;

    RemitNo:=I1CqStartF.Text;


  end; {With..}
end;

Procedure TBatchEntry.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      0..1
         :  I1TransDateF.SetFocus;
    end; {Case&With..}

end; {Proc..}




Procedure TBatchEntry.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TBatchEntry.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);
  end;
end;


procedure TBatchEntry.PageControl1Change(Sender: TObject);
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

      {$B-}

        If ((NewIndex In [0..1]) and (MULVisiList[NewIndex]<>nil)) then
          LockWindowUpDate(0);

      {$B+}

      PrimeButtons;


      If (NewIndex=0) then
      Begin
        I1AddrF.Color:=I1BNomF.Color;
        I1AddrF.Font.Color:=I1BNomF.Font.Color;

        CustToMemo(ExLocal.LCust,I1AddrF,0);
      end
      else
      With ExLocal,LInv do
      Begin
        I1AddrF.Color:=clBtnFace;
        I1AddrF.Font.Color:=clBlack;

        CustToMemo(LCust,I1AddrF,0);

      end;

      SetInvTotPanels(NewIndex);
      OutInvTotals(NewIndex);

      Case NewIndex of

        0..1
           :  Begin
                ChangeList(NewIndex,BOn);

                {$IFNDEF LTE} // NF: 20/04/06 Removed for IAO
                  Case NewIndex of
                    0  :  SBSPanel3.HelpContext:=40033;
                    1  :  SBSPanel3.HelpContext:=40031;
                  end; {case..}
                {$ENDIF}
              end;

      {$IFDEF NP}

        2  :  If (NotesCtrl=nil) then
              With ExLocal do
              Begin
                NotesCtrl:=TNoteCtrl.Create(Self);

                NotesCtrl.Caption:=Caption+' - Notes';

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

                MDI_UpdateParentStat;

                {$IFNDEF LTE} // NF: 20/04/06 Removed for IAO
                  SBSPanel3.HelpContext:=80;
                {$ENDIF}

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

         2  :  ;

      {$ENDIF}

      end; {Case..}


      MDI_UpdateParentStat;

    end;

  LockWindowUpDate(0);
end;




procedure TBatchEntry.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  bHelpContextInc := FALSE; //NF: 12/04/06

  fFrmClosing:=BOff;
  fDoingClose:=BOff;

  ExLocal.Create;

  ForceStore:=BOff;

  ListScanningOn := False;

  LastCoord:=BOff;
  ReCalcTot:=BOn;

  Visible:=BOff;

  InvStored:=BOff;

  JustCreated:=BOn;
  LKeypath:=0;

  InHBeen:=BOff;

  GotCoord:=BOff;
  NeedCUpdate:=BOff;
  FColorsChanged := False;

  StopPageChange:=BOff;

  InPassIng:=BOff;
  GenSelect:=BOff;

  MinHeight:=375; {* Page control1 H/W *}
  MinWidth:=631;

  //AP 07/12/2017 2018R1 ABSEXCH-19538:Changed initial clientheight from 351 to 425 to accommodate new Anonymised Control
  InitSize.Y := 425;
  InitSize.X:=632;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=375;
  Width:=640;}


  PageControl1.ActivePage:=MainPage;

  DispTransPtr:=nil;

  Left:=0;
  Top:=0;

  RecordPage:=BatchFormPage;
  DocHed:=BatchFormMode;

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


procedure TBatchEntry.NotePageReSize;

Begin
  With TCNScrollBox do
  Begin
    TCNListBtnPanel.Left:=Width+1;

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


procedure TBatchEntry.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) and (Not fDoingClose) then
  Begin
    MULCtrlO.LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

  {  NewVal:=ClientWidth-PagePoint[0].X;
    If (NewVal<MinWidth) then
      NewVal:=MinWidth;

    PageControl1.Width:=NewVal;

    NewVal:=ClientHeight-PagePoint[0].Y;

    If (NewVal<MinHeight) then
      NewVal:=MinHeight;

    PageControl1.Height:=NewVal;  }

    PageControl1.Width := ClientWidth - 4;
    if FAnonymisationON then
      PageControl1.Height := ClientHeight - pnlAnonymisationStatus.Height - 4
    else
      PageControl1.Height := ClientHeight - 4;

    I1SBox.Width:=PageControl1.Width-PagePoint[1].X;
    I1SBox.Height:=PageControl1.Height-PagePoint[1].Y;

    I1FPanel.Width:=PageControl1.Width-5;

    I2SBox.Width:=I1SBox.Width;
    I2SBox.Height:=I1SBox.Height;

    TCNScrollBox.Width:=PageControl1.Width-PagePoint[5].X;
    TCNScrollBox.Height:=PageControl1.Height-PagePoint[5].Y;

    I1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    I1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    I1BtnPanel2.Left:=I1BtnPanel.Left+1;

    I1BSBox.Height:=I1BtnPanel.Height-PagePoint[3].X;

    I1ListBtnPanel.Left:=PageControl1.Width-PagePoint[4].X;
    I1ListBtnPanel.Height:=PageControl1.Height-PagePoint[4].Y;


    TCNListBtnPanel.Height:=PageControl1.Height-PagePoint[6].Y;

    NotePageResize;


    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      For n:=High(MULVisiList) downto 0 do
      If (MULVisiList[n]<>nil) then
      Begin
        MULCtrlO.VisiList:=MULVisiList[n];
        { CJS 2012-08-16 - ABSEXCH-13263 - Make sure that SBSComp uses the
                                           correct source control for the font
                                           details. }
        MULCtrlO.MUListBox1 := SourceListBox[n];

        With MULCtrlO,VisiList do
        Begin
          VisiRec:=List[0];

          With (VisiRec^.PanelObj as TSBSPanel) do
            Height:=I1SBox.ClientHeight-PagePoint[3].Y;

          RefreshAllCols;
        end;
      end; {Loop..}

      MULCtrlO.ReFresh_Buttons;

      If (Current_Page<2) then
      With MULCtrlO do
      Begin
        VisiList:=MULVisiList[Current_Page];
        { CJS 2012-08-16 - ABSEXCH-13263 - Restore the source control for the
                                           current page. }
        MUListBox1 := SourceListBox[Current_Page];
        RefreshAllCols;
      end;

      LockWindowUpDate(0);
    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;

    //AP 07/12/2017 2018R1 ABSEXCH-19538:Resize the anonymisation shape
    SetAnonymisationPanel;
    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;


procedure TBatchEntry.FormDestroy(Sender: TObject);

Var
  n  :  Byte;

begin
  ExLocal.Destroy;

  If (Not fDoingClose) then
  Begin
    {* Note 0 is not destroyed, as this is the lists own copy *}


    With MULCtrlO do
    Begin
      VisiList:=MULVisiList[0];
      { CJS 2012-08-16 - ABSEXCH-13263 - restore the original source control. }
      MUListBox1 := SourceListBox[0];
    end;


    For n:=1 to High(MULVisiList) do
    If (MULVisiList[n]<>nil) then
    begin
      MULVisiList[n].Free;
      SourceListBox[n].Free;
    end;
  end;

  If (InvBtnList<>nil) then
    InvBtnList.Free;

  {If (MULCtrlO<>nil) then
    MULCtrlO.Free;}

end;

procedure TBatchEntry.FormCloseQuery(Sender: TObject;
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

        Send_UpdateList(BOff,104);

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;

end;

procedure TBatchEntry.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  n  :  Byte;

begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    {* Note 0 is not destroyed, as this is the lists own copy *}


    With MULCtrlO do
    Begin
      VisiList:=MULVisiList[0];
      { CJS 2012-08-16 - ABSEXCH-13263 - restore the original source control. }
      MUListBox1 := SourceListBox[0];
    end;


    For n:=1 to High(MULVisiList) do
    If (MULVisiList[n]<>nil) then
    begin
      MULVisiList[n].Free;
      { CJS 2012-08-16 - ABSEXCH-13263 - free the source controls created on
                                         this form. }
      if SourceListBox[n] <> nil then
      begin
        SourceListBox[n].Free;
        SourceListBox[n] := nil;
      end;
    end;


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

procedure TBatchEntry.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

{   If (Key=$5A) and (ssAlt In Shift) and (Not ExLocal.LViewOnly) then
  Begin
    Re_SetDoc(ExLocal.LInv);
    OutInv;
    RefreshList(BOn,BOff);
  end; Alt Z not applicable to batch }

end;

procedure TBatchEntry.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Function TBatchEntry.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;

procedure TBatchEntry.ClsI1BtnClick(Sender: TObject);
begin

  If (ConfirmQuit) then
    Close;
end;


function TBatchEntry.I1PrYrFConvDate(Sender: TObject; const IDate: string;
  const Date2Pr: Boolean): string;

Begin

  Result:=ConvInpPr(IDate,Date2Pr,@ExLocal);

end; {Proc..}


Function TBatchEntry.ConfirmQuit  :  Boolean;

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
      mbRet:=MessageDlg('This Transaction must be stored',mtWarning,[mbOk],0)
    else
      mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes
           :  Begin
                StoreInv(InvF,LKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) then
                Begin
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


procedure TBatchEntry.SetInvStore(EnabFlag,
                                  VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode;

  OkI1Btn.Enabled:=Not VOMode;
  CanI1Btn.Enabled:=Not VOMode;

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
                If (Components[Loop] is TSBSComboBox) then
                Begin
                  If (TSBSComboBox(Components[Loop]).Tag=1) then
                    TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
              end;
  end; {Loop..}

  {* Set currency to readonly, if receipt part of SRI present *}

  SetCurrStat;

end;



(*  Add is used to add Customers *)

procedure TBatchEntry.ProcessInv(Fnum,
                                 KeyPAth    :  Integer;
                                 Edit,
                                 AutoOn     :  Boolean);

Var
  KeyS       :  Str255;

  FOLDeter   :  DocTypes;


Begin

  Addch:=ResetKey;

  KeyS:='';

  FOLDeter:=FOL;

  Elded:=Edit;

  FirstStore:=Not Edit;
  
  OldConTot:=0;

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


      OldConTot:=ConsolITotal(LInv);

    end;


    If (Not Ok) or (Not GlobLocked) then
    Begin
      AddCh:=#27;
      ExLocal.LViewOnly:=BOn;
    end;
  end;



  If (Addch<>#27) then
  With ExLocal,LInv do
  begin

    
    If (Not Edit) then
    Begin
      Caption:=DocNames[DocHed]+' Record';

      LResetRec(Fnum);

      RunNo:=0;

      NomAuto:=BOff;

      InvDocHed:=DocHed;


      TransDate:=Today; AcPr:=GetLocalPr(0).CPr; AcYr:=GetLocalPr(0).CYr;

      NLineCount:=1;
      ILineCount:=2;

    {$IFDEF MC_On}

      Currency:=1;

      CXrate[BOn]:=SyssCurr.Currencies[Currency].CRates[BOn];

      CXRate[BOff]:=0;

    {$ELSE}

      Currency:=0;

      CXrate:=SyssCurr.Currencies[Currency].CRates;


    {$ENDIF}

    SetTriRec(Currency,UseORate,CurrTriR);


    OpName:=EntryRec^.Login;

    If (InvDocHed In PurchSplit) then
      RemitNo:=Get_NextChequeNo(BOff);

    SetNextDocNos(LInv,BOff);

    OutInv;

    If (Not Edit) then
      ReFreshList(BOn,Not JustCreated);

    end
    else
    Begin
      {$IFNDEF JC}

      {$ENDIF}
    end;

    LastInv:=LInv;

    SetInvStore(BOn,LViewOnly);


    SetFieldFocus;

  end {If Abort..}
  else
  Begin
    SetViewOnly(BOn,ExLocal.LViewOnly);
    PrimeButtons;
  end;


end; {Proc..}


procedure TBatchEntry.I1TransDateFExit(Sender: TObject);
begin
  With ExLocal,LInv,I1TransDateF do
    If {(DateModified) and} (Not LastEdit) and (ValidDate(DateValue)) then
    Begin
      TransDate:=DateValue;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
      With I1PrYrF do
      Begin
        Date2Pr(TransDate,AcPr,AcYr,@ExLocal);

        InitPeriod(AcPr,AcYr,BOn,BOn);
      end;

    end;
end;


procedure TBatchEntry.I1CurrFEnter(Sender: TObject);
begin
  I1CurrF.AllowChangeInExit:=BOff;
  SetCurrStat;
end;


procedure TBatchEntry.I1CurrFExit(Sender: TObject);
begin
  {$IFDEF MC_On}
     With ExLocal,LInv,I1CurrF do
     If (Modified) then
     Begin
       If (I1CurrF.ItemIndex=-1) then
       With I1CurrF do
       Begin
         AllowChangeInExit:=BOn;
         ItemIndex:=0;
       end;

       Currency:=Succ(I1CurrF.ItemIndex);

       CXRate:=SyssCurr.Currencies[Currency].CRates;

       CXRate[BOff]:=0;

       SetTriRec(Currency,UseORate,CurrTriR);

       CurrLab1.Caption:=SSymb(Currency);
       CurrLab2.Caption:=SSymb(Currency);

     end;
  {$ENDIF}
end;



Procedure TBatchEntry.NoteUpdate;


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

        //PR: 10/07/2012 ABSEXCH-12784 Change to check
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





Function TBatchEntry.CheckCompleted(Edit  :  Boolean)  : Boolean;

Const
  NofMsgs      =  8;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg,
  AfterMsg :  Str255;

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
  PossMsg^[4]:='Bank G/L code is not valid.';
  PossMsg^[5]:='Batch Total does not agree.';
  PossMsg^[6]:='An exchnage rate of zero is not valid.';
  PossMsg^[7]:='Currency is not valid.';
  PossMsg^[8]:='Check child windows';


  Test:=1;

  Result:=BOn;

  BalNow:=0;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LInv do
  Begin
    ExtraMsg:='';
    AfterMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=Not IdLineActive;

              If Assigned(IdLine) and (IdLineActive) then
                IdLine.Show;
            end;

    
      2  :  Result:=ValidDate(TransDate);

      3  :  Result:=ValidPeriod(StrPeriod(ConvTxYrVal(AcYr,BOff),AcPr),Syss.PrInYr);

      4  :  Begin
              Result:=(BatchNom=0);

              If (Not Result) then
                Result:=Global_GetMainRec(NomF,FullNomKey(BatchNom));
            end;

      5  :  Result:=(Batch_Required(LInv)=0) or (Not Syss.UseBatchTot);

      6  :  Result:=(CXRate[BOn]<>0);

      {$IFDEF MC_On}

        7  :  Result:=(Currency In [Succ(CurStart)..CurrencyType]);

      {$ENDIF}

      8  :  Begin {* Check if all child windows are gojng to close *}
              ShowMsg:=BOff;

              GenCanClose(Self,Self,Result,BOff);

            end;



    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test]+AfterMsg,mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}



{ ============ Procedure to Reset Pr & Yr Totals ========= }
{ Move to thread }

Procedure TBatchEntry.Batch_Change(OInv,InvR  :  InvRec;
                                   KPath      :  SmallInt);


Const
  Fnum     =  InvF;

  KeyPath  =  InvBatchK;



Var
  KeyS,
  KeyChk   :  Str255;

  OInv2    :  InvRec;

  RecAddr  :  Longint;

  LOk,
  Locked   :  Boolean;


Begin

  RecAddr:=0;

  If (OInv.AcYr<>InvR.AcYr) or (OInv.AcPr<>InvR.AcPr) then
  Begin
    KeyChk:=InvR.OurRef;

    KeyS:=KeyChk;

    ExLocal.LGetRecAddr(Fnum);

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Inv do
    Begin

      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,RecAddr);

      If (LOk) and (Locked) then
      Begin

        If (RunNo=BatchRunNo) then
        Begin

          OInv2:=Inv;

          AcPr:=InvR.AcPr;

          AcYr:=InvR.AcYr;

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);
          //GS 03/11/2011 added audit note to a modified batch record
          if Status = 0 then
          begin
            TAuditNote.WriteAuditNote(anTransaction, anEdit, ExLocal);
          end;

          Report_BError(Fnum,Status);

          If (StatusOk) then   {* Change detail lines *}
            Check_DocChanges(OInv2,Inv);

        end;

        Status:=UnLockMultiSing(F[Fnum],Fnum,RecAddr);

      end;
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

  end; {With..}

  ExLocal.LGetDirectRec(Fnum,KPath);
end; {Proc..}




procedure TBatchEntry.StoreInv(Fnum,
                               KeyPAth    :  Integer);


Var
  COk  :  Boolean;
  TmpInv
       :  InvRec;
  KeyS :  Str255;

  MbRet:  Word;

  Mode :  Byte;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState: Boolean;
  CursorState: TCursor;

Begin
  KeyS:='';

  Mode:=0;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState := OkI1Btn.Enabled;
  CursorState := Cursor;
  OkI1Btn.Enabled := False;
  try

    Form2Inv;

    With ExLocal,LInv do
    Begin

      COk:=CheckCompleted(LastEdit);


      If (COk) then
      Begin

        Cursor := crHourGlass;

        OpName:=EntryRec^.LogIn;



        If (LastEdit) then
        Begin
          If (Not LViewOnly) then
          Begin
            Status:=LSecure_InvPut(Fnum,KeyPAth,0);
            //GS 03/11/2011 added audit note to a modified batch record
            if Status = 0 then
            begin
              TAuditNote.WriteAuditNote(anTransaction, anEdit, ExLocal);
            end;

          end; {Don't store if view only}
        end
        else
        Begin {* Add new record *}
          If (Not ForceStore) then
          Begin
            SetNextDocNos(LInv,BOn)
          end;

          If (Not InvStored) and (Not LForcedAdd) then
          begin
            { CJS - 2013-10-25 - MRD2.6.07 - Transaction Originator }
            TransactionOriginator.SetOriginator(LInv);

            Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
            //GS 03/11/2011 added audit note to a new batch record
            if Status = 0 then
            begin
              TAuditNote.WriteAuditNote(anTransaction, anCreate, ExLocal);
            end;
          end
          else
          Begin
            Status:=LSecure_InvPut(Fnum,KeyPAth,0);
            //GS 03/11/2011 added audit note to a modified batch record
            if Status = 0 then
            begin
              TAuditNote.WriteAuditNote(anTransaction, anEdit, ExLocal);
            end
          end;


          CanDelete:=BOn;
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


        end;

        If (LastEdit) or (LForcedAdd) then
        Begin
          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);
        end;

        If (StatusOk) and (Not LViewOnly) and (Not InvStored) then
          Batch_Change(LastInv,LInv,Keypath);  {* Reset-any Changes *}

        SetInvStore(BOff,BOff);

        { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
        Cursor := CursorState;

        LastValueObj.UpdateAllLastValues(Self);

        InvStored:=BOn;

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
    OkI1Btn.Enabled := ButtonState;
  end;

end;

Function TBatchEntry.SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

Var
  VOMsg  : Byte;

Begin


{$B-}

  Result:=(SL and ((VO) or View_Status(ExLocal.LInv,BOff,VOMsg)));

{$B+}

  If (VO) then {* Force View only msg *}
    VOMsg:=9;

  If (Result) then
    I1StatLab.Caption:='STATUS:'+#13+GetIntMsg(VOMsg+50)
  else
    I1StatLab.Caption:='';

  OkI1Btn.Visible:=Not Result;
  CanI1Btn.Visible:=OkI1Btn.Visible;
  
  

  {I1BSBox.Visible:=Not Result;}
end;

procedure TBatchEntry.EditAccount(Edit,
                                  AutoOn,
                                  ViewOnly   :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ShowLink(Edit,ViewOnly);

    LKeypath:=InvOurRefK;

    ProcessInv(InvF,LKeypath,LastEdit,AutoOn);

  end;
end;



procedure TBatchEntry.I1AddrFClick(Sender: TObject);
begin
  If (Not EmptyKey(ExLocal.LCust.CustCode,CustKeyLen)) then
  Begin
    If (Not MatchOwner('CustRec3',Self.Owner)) then
    Begin

      If (DispCust=nil) then
        DispCust:=TFCustDisplay.Create(Self);

      try

        ExLocal.AssignToGlobal(CustF);

        With DispCust do
          Display_Account(IsACust(ExLocal.LCust.CustSupp),0,ExLocal.LInv);

      except

        DispCust.Free;
        DispCust:=nil;
      end;
    end
    else  {* We are being called via custrec3, hence double click should inform custrec *}
    Begin
      Send_UpdateList(BOff,10);
    end;
  end; {If..}
end;


procedure TBatchEntry.OkI1BtnClick(Sender: TObject);
Var
  TmpBo  :  Boolean;
  KeyS   :  Str255;

begin

  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      // Move focus to OK button to force OnExit validation/formatting to kick in
      If OkI1Btn.CanFocus Then
        OkI1Btn.SetFocus;

      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = OkI1Btn) Then
      begin
        StoreInv(InvF,LKeyPath);
      end;
    end
    else
      If (ModalResult=mrCancel) then
      Begin
        ClsI1Btn.Click;

        Exit;
      end;
  end; {With..}
end;



procedure TBatchEntry.PopupMenu1Popup(Sender: TObject);
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


procedure TBatchEntry.I1SCodeLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

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

procedure TBatchEntry.I1SCodeLabMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);

begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO<>nil) then
    Begin
      MULCtrlO.VisiList.MoveLabel(X,Y);

      NeedCUpdate:=MULCtrlO.VisiList.MovingLab;
    end;
  end;

end;




procedure TBatchEntry.I1StkCodePanelMouseUp(Sender: TObject;
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
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
  end;

end;


procedure TBatchEntry.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    N3.Tag:=99;

    PopUp(X,Y);
  end;


end;

procedure TBatchEntry.SetFieldProperties;

Var
  n  : Integer;


Begin
  I1BtmPanel.Color:=I1FPanel.Color;
  I2BtmPanel.Color:=I1FPanel.Color;
  I1BtnPanel.Color:=I1FPanel.Color;
  I1BtnPanel2.Color:=I1FPanel.Color;

  SBSPanel4.Color:=I1FPanel.Color;
  SBSPanel3.Color:=I1FPanel.Color;

  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) and (Components[n]<>I1BNomF) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(I1BNomF.Font);
        Color:=I1BNomF.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        {CheckColor:=I1BNomF.Color;}
        Color:=I1FPanel.Color;
      end;

  end; {Loop..}

  I1AddrF.Color:=I1BNomF.Color;
  I1AddrF.Font.Assign(I1BNomF.Font);

end;


procedure TBatchEntry.SetFormProperties(SetList  :  Boolean);

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
      TmpPanel[1].Font:=I1BNomF.Font;
      TmpPanel[1].Color:=I1BNomF.Color;

      TmpPanel[2].Font:=I1FPanel.Font;
      TmpPanel[2].Color:=I1FPanel.Color;
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
            I1FPanel.Font.Assign(TmpPanel[2].Font);
            I1FPanel.Color:=TmpPanel[2].Color;

            I1BNomF.Font.Assign(TmpPanel[1].Font);
            I1BNomF.Color:=TmpPanel[1].Color;

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



procedure TBatchEntry.PropFlgClick(Sender: TObject);
begin
  SetFormProperties((N3.Tag=99));
  N3.Tag:=0;
end;

procedure TBatchEntry.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;


procedure TBatchEntry.SetNewFolio;

Begin

  With ExLocal do
  If (Not ForceStore) and (Not LastEdit) and (InAddEdit) and (Not LViewOnly) then {* Document commits to invoice number here *}
  Begin
    ForceStore:=BOn;
    SetNextDocNos(LInv,BOn);

    I1OurRefF.Text:=Pr_OurRef(LInv);
    
    { CJS - 2013-10-25 - MRD2.6.07 - Transaction Originator }
    TransactionOriginator.SetOriginator(LInv);
    I1OpoF.Hint := GetOriginatorHint(LInv);

    {* Set new list search *}
    {* Force add of header now *}
    LSecure_Add(InvF,LKeypath,0);


    RefreshList(BOff,BOff);
  end;
end;


procedure TBatchEntry.AddI1BtnClick(Sender: TObject);

Var
  Mode  :  Byte;

  Ok2Show,
  BatSplit
        :  Boolean;


begin
  Mode:=0;

  BatSplit:=BOff;

  Case Current_Page of

    2  : {$IFDEF NP}
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

               NotesCtrl.AddEditNote((Sender=EditI1Btn),(Sender=InsI1Btn));
             end;

           end;
         {$ELSE}
           ;
         {$ENDIF}

    else   If ((Sender Is TButton) or (Sender Is TMenuItem))
              and ((MULCtrlO.ValidLine) or ((Sender=AddI1Btn) or (Sender=Add1))) then
           Begin
             With MULCtrlO do
             Begin
              RefreshLine(MUListBoxes[0].Row,BOff);
              Get_BatchId(BatchLine,Inv);
             end;

             If (Sender=AddI1Btn) or (Sender=EditI1Btn) or (Sender=Edit1) or (Sender=Add1) or (Sender=InsI1Btn) or (Sender=Insert1) then
               Mode:=1+(1*(Ord(Sender=EditI1Btn)+Ord(Sender=Edit1))) + (2*(Ord(Sender=InsI1Btn)+Ord(Sender=Insert1)));

             LastDocHed:=DocHed;

             Case Mode of
               1  :  Ok2Show:=AddDayBook(Self,(DocHed In SalesSplit),LastDocHed,1);
               else  Ok2Show:=BOn;
             end;

             {* Transfer to record, so the line is upto date *}


             BatSplit:=((Mode=2) and Ok2Show and MULCtrlO.BatchLine.BatchSplit);

             If (Ok2Show) then
             Begin
               If (BatSplit) then
                 Display_Trans(2)
               else
               Begin
                 Form2Inv;

                 SetNewFolio;

                 Display_Id(Mode);
               end;
             end;
           end;

  end; {Case..}


end;

procedure TBatchEntry.DelI1BtnClick(Sender: TObject);

Const
  Fnum  =  IdetailF;

Var
  mbRet  :  Word;

  KeyS   :  Str255;

  UseFolio
         :  LongInt;

  FoundCode
         :  Str20;


begin

  Case Current_Page of

    2  :  {$IFDEF NP}
            If (NotesCtrl<>nil) then
              NotesCtrl.Delete1Click(Sender);

          {$ELSE}
             ;
          {$ENDIF}

  end; {Case..}

end;


procedure TBatchEntry.SwiI1BtnClick(Sender: TObject);
begin
  {$IFDEF NP}

    If (NotesCtrl<>nil) then
    With NotesCtrl do
    Begin

      If (Not MULCtrlO.InListFind) then
        SwitchGenMode;

    end;
  {$ENDIF}
end;


function TBatchEntry.I1PrYrFShowPeriod(Sender: TObject;
  const EPr: Byte): string;
begin
  Result:=PPr_Pr(EPr);
end;



procedure TBatchEntry.I1BNomFExit(Sender: TObject);
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

    Form2Inv;


    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanI1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,2));

      If (FoundOk) then {* Credit Check *}
      Begin
        Text:=Form_Int(FoundLong,0);
      end
      else
        SetFocus;


    end;


  end; {with..}
end;


procedure TBatchEntry.I1CqStartFExit(Sender: TObject);
Var
  AltMod     :  Boolean;
  FoundValue :  LongInt;
  FoundCode  :  Str255;

begin

  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    FoundValue:=Round(Value);

    If ((AltMod) and (FoundValue<>0)) and (ActiveControl<>CanI1Btn) then
    Begin
      If (DocHed In PurchSplit) then
        Put_NextChequeNo(FoundCode,BOff);
    end;


  end; {with..}
end;



procedure TBatchEntry.I1BTotFExit(Sender: TObject);
begin
  Form2Inv;
  OutInvTotals(0);
end;

procedure TBatchEntry.Check_Batch;


Const
  Fnum     =  InvF;

  KeyPath  =  InvBatchK;



Var
  KeyS,
  KeyChk   :  Str255;

  TmpKPath,
  TmpStat  :  Integer;
  TmpAddr  :  LongInt;

  NoAbort  :  Boolean;

  mbRet    :  TModalResult;

  MsgForm  :  TForm;

  CBL      :  BatchLineRec;


Begin
  MulCtrlO.GetSelRec(BOff);

  NoAbort:=BOn;

  CBL:=MULCtrlO.BatchLine;

  Set_BackThreadMVisible(BOn);

  MsgForm:=CreateMessageDialog('Please wait... Recalculating batch totals.',mtInformation,[mbAbort]);
  MsgForm.Show;
  MsgForm.Update;

  TmpKPath:=Keypath;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpAddr,BOff,BOff);

  With ExLocal,LInv do
  Begin

    InvNetVal:=0;

    InvVAT:=0;

    DiscTaken:=BOff;

    DiscAmount:=0;

    DiscSetAm:=0;



    Blank(InvVATAnal,Sizeof(InvVATAnal));

    KeyChk:=OurRef;

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoAbort) do
    With Inv, MUlCtrlO do
    Begin

      mbRet:=MsgForm.ModalResult;
      Loop_CheckKey(NoAbort,mbRet);
      MsgForm.ModalResult:=mbRet;

      Application.ProcessMessages;

      Doc2Batch(BatchLine,Inv);

      UpdateBATBal(BatchLine,LInv,0);

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    end; {While..}

  end; {With..}

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpAddr,BOn,BOn);

  MsgForm.Free;

  MULCtrlO.BatchLine:=CBL;

  Set_BackThreadMVisible(BOff);

  OutInvTotals(0);

end; {Proc..}




procedure TBatchEntry.chkI1BtnClick(Sender: TObject);
begin
  Check_Batch;
end;

procedure TBatchEntry.FullI1BtnClick(Sender: TObject);
begin
  If (MULCtrlO.ValidLine) then
  Begin

    MULCtrlO.GetSelRec(BOff);

    Display_Trans(2);
  end;

end;

procedure TBatchEntry.CopyI1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  With MULCtrlO do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);


       With TWinControl(Sender) do
       Begin
         ListPoint.X:=1;
         ListPoint.Y:=1;

         ListPoint:=ClientToScreen(ListPoint);

       end;



       PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
    end;
  end;{with..}

end;

procedure TBatchEntry.Copy2Click(Sender: TObject);
begin
  If (Sender Is TMenuItem) then
  With MULCtrlO,TMenuItem(Sender) do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin
      ContraCopy_Doc(Inv.FolioNum,Tag,'');

      With ExLocal do
        If (Tag>0) then {* Add Value to Balance *}
        Begin
          UpdateBATBal(BatchLine,LInv,Pred(Tag));
          OutInvTotals(0);
        end;
    end;

    ReFreshList(BOn,BOff);

  end;

end;


procedure TBatchEntry.LnkI1BtnClick(Sender: TObject);
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

procedure TBatchEntry.SetHelpContextIDsForPage(bInc : boolean); // NF: 12/04/06
const
  TAB_DATA_ENTRY = 0;
  TAB_ANALYSIS = 1;
  TAB_NOTES = 2;
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
      if AControl.Name = 'OkI1Btn' then exit;
      if AControl.Name = 'CanI1Btn' then exit;
      if AControl.Name = 'ClsI1Btn' then exit;
      if AControl.Name = 'SwiI1Btn' then exit;
      if AControl.Name = 'LnkI1Btn' then exit;

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
        TAB_DATA_ENTRY : begin
          PageControl1.ActivePage.HelpContext := iOffSet + 40033;
          I1NomCodeF.HelpContext := 40010;
          LnkI1Btn.HelpContext := 81;
          I1StkCodePanel.HelpContext := 0;
          I1DescPanel.HelpContext := 0;
          I1LTotPanel.HelpContext := 0;
          I1VATPanel.HelpContext := 0;
          I1ItemPanel.HelpContext := 0;
          I1YRefPanel.HelpContext := 0;
          I1QtyPanel.HelpContext := 0;
          SBSPanel3.HelpContext := 40033;
          EditI1Btn.HelpContext := 2086; // NF: 25/07/06
        end;
        TAB_ANALYSIS : begin
          PageControl1.ActivePage.HelpContext := iOffSet + 1690;
          SBSPanel3.HelpContext := 1690;
          EditI1Btn.HelpContext := 2086; // NF: 25/07/06
        end;
        TAB_NOTES : begin
          PageControl1.ActivePage.HelpContext := iOffSet + 1691;
          SwiI1Btn.HelpContext := 90;
          SBSPanel3.HelpContext := 1691;
        end;
      end;{case}
    end;{if}

    if (iOffSet <> 0) then IncHelpContextIDs(iOffSet, Self);

    HelpContext := PageControl1.ActivePage.HelpContext;
    PageControl1.HelpContext := PageControl1.ActivePage.HelpContext;

  {$ENDIF}
end;

//AP 07/12/2017 2018R1 ABSEXCH-19538:Anonymised Transactions > Notification banner is not displayed for SRC, PPY, xBT.
procedure TBatchEntry.SetAnonymisationBanner;
begin
  {$IFNDEF EXDLL}
    if FAnonymisationON then
    begin
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
      PagePoint[0].Y := 3;
    end;
    if FListScanningOn then
    begin
      if FAnonymisationON then
        PagePoint[0].Y := 80;
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
procedure TBatchEntry.SetAnonymisationPanel;
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
