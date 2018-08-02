unit CuStkL1U;

interface

{$I DEFOvr.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,VarRec2U, BTSupU1,ExWrap1U, ExtGetU, SBSComp2,
  CuStkA4U,

  {$IFDEF Post}
    Recon3U,
    PostingU,

    {$IFDEF SOP}
      ExBtTh1U,

    {$ENDIF}

  {$ENDIF}

  {$IFDEF Nom}
    HistWinU,
  {$ENDIF}

  {$IFDEF SOP}
    CuStkT2U,                      
    CuStkT4U,
    IntStatU,
    TTD,
  {$ENDIF}


  SalTxl2U,

  CuStkT1U,

  Menus, Mask, TCustom, AccelLbl, Buttons, BorBtns;




type
 TTSList  =  Class(TDDMList)
  Public

   ListCSAnal   :  ^CKAnalType;
   TeleSHed     :  MLocPtr;

   tMargin      :  Double;

   Procedure ExtObjCreate; Override;

   Procedure ExtObjDestroy; Override;

   Function SetCheckKey  :  Str255; Override;

   Function SetFilter  :  Str255; Override;

   Function Ok2Del :  Boolean; Override;

   Function LinktoCuRec:  Boolean;

   Function CheckRowEmph :  Byte; Override;

   Function SetCSAnal(GetRec  :  Boolean)  :  Boolean;

   Function OutSLLine(Col  :  Byte)  :  Str255;

   Function OutTSLine(Col  :  Byte)  :  Str255;

   Function OutLine(Col  :  Byte)  :  Str255; Override;

   procedure Find_Now(Cu   :   Str10;
                      St   :   Str20);

   function UnitPrice: double;

 end;

 {$IFDEF POST}
   {$IFDEF SOP}

     TReCalcTS    =  Object(TThreadQueue)

                              private
                                fMode     :  Byte;
                                TeleSHed  :  MLocPtr;

                                Procedure  ReCalc_TSTotals;

                              public
                                Constructor Create(AOwner  :  TObject);

                                Destructor  Destroy; Virtual;


                                Procedure Process; Virtual;
                                Procedure Finish;  Virtual;

                                Function Start  :  Boolean;

                            end; {Class..}


   {$ENDIF}
 {$ENDIF}

type
  TTeleSFrm = class(TForm)
    PageControl1: TPageControl;
    ItemPage: TTabSheet;
    D1SBox: TScrollBox;
    D1HedPanel: TSBSPanel;
    TSQ1Lab: TSBSPanel;
    D1RefLab: TSBSPanel;
    D1RefPanel: TSBSPanel;
    TSQ1Panel: TSBSPanel;
    D1ListBtnPanel: TSBSPanel;
    TotalPanel: TSBSPanel;
    Label82: Label8;
    TotPay: TCurrencyEdit;
    TotRec: TCurrencyEdit;
    TSQ2Panel: TSBSPanel;
    Label83: Label8;
    Label84: Label8;
    TotCB: TCurrencyEdit;
    PopupMenu1: TPopupMenu;
    Find1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    View1: TMenuItem;
    Filter1: TMenuItem;
    Hist1: TMenuItem;
    StkRec1: TMenuItem;
    Check1: TMenuItem;
    UPBOMP: TSBSPanel;
    TSQ3Panel: TSBSPanel;
    TSQ4Panel: TSBSPanel;
    TSQ5Panel: TSBSPanel;
    TSQ6Panel: TSBSPanel;
    TSQ2Lab: TSBSPanel;
    TSQ3Lab: TSBSPanel;
    TSQ4Lab: TSBSPanel;
    TSQ5Lab: TSBSPanel;
    TSQ6Lab: TSBSPanel;
    TSDatePanel: TSBSPanel;
    TSDateLab: TSBSPanel;
    TSGPPanel: TSBSPanel;
    TSGPLab: TSBSPanel;
    I1NomCodeF: Text8Pt;
    I1CCF: Text8Pt;
    I1DepF: Text8Pt;
    I1LocnF: Text8Pt;
    I1LocnLab: Label8;
    I1DepLab: Label8;
    I1CCLab: Label8;
    Label813: Label8;
    StkDescF: Text8Pt;
    TeleInpFrm: TTabSheet;
    Scale1: TMenuItem;
    Prices1: TMenuItem;
    Store1: TMenuItem;
    Currency1: TMenuItem;
    Txlate1: TMenuItem;
    Defaults1: TMenuItem;
    PopupMenu3: TPopupMenu;
    Loc1: TMenuItem;
    CC1: TMenuItem;
    Dep1: TMenuItem;
    PopupMenu4: TPopupMenu;
    MarginView1: TMenuItem;
    Prices2: TMenuItem;
    OSOrders1: TMenuItem;
    Invoices1: TMenuItem;
    CompOrd1: TMenuItem;
    AltStkCode1: TMenuItem;
    StdStkCodes1: TMenuItem;
    List1: TMenuItem;
    PopupMenu6: TPopupMenu;
    TPr1: TMenuItem;
    TW1: TMenuItem;
    TW2: TMenuItem;
    TW3: TMenuItem;
    StatsView1: TMenuItem;
    PopupMenu5: TPopupMenu;
    SPr1: TMenuItem;
    STD1: TMenuItem;
    STW1: TMenuItem;
    S2W1: TMenuItem;
    SYTD1: TMenuItem;
    lblAcCode: Label8;
    ACFF: Text8Pt;
    D1BtnPanel: TSBSPanel;
    D1BSBox: TScrollBox;
    AddD1Btn: TButton;
    EditD1Btn: TButton;
    DelD1Btn: TButton;
    FindD1Btn: TButton;
    ScleD1Btn: TButton;
    ViewD1Btn: TButton;
    HistD1Btn: TButton;
    FilterD1Btn: TButton;
    StkRD1Btn: TButton;
    PrceD1Btn: TButton;
    CurD1Btn: TButton;
    TxD1Btn: TButton;
    ChkD1Btn: TButton;
    DefD1Btn: TButton;
    StreD1Btn: TButton;
    LstD1Btn: TButton;
    Clsd1Btn: TButton;
    SBSPanel1: TSBSPanel;
    Image1: TImage;
    Label86: Label8;
    CompF: Text8Pt;
    Ledger11: TMenuItem;
    N3: TMenuItem;
    PopupMenu7: TPopupMenu;
    GQU1: TMenuItem;
    GCan1: TMenuItem;
    Label822: Label8;
    DAddr1F: Text8Pt;
    DAddr2F: Text8Pt;
    DAddr3F: Text8Pt;
    DAddr4F: Text8Pt;
    DAddr5F: Text8Pt;
    CurrF: TSBSComboBox;
    I1ExLab: Label8;
    I1EXRateF: TCurrencyEdit;
    Label87: Label8;
    I1TransDateF: TEditDate;
    I1DueDateF: TEditDate;
    I1DueDateL: Label8;
    I4JobCodeL: Label8;
    I4JobCodeF: Text8Pt;
    I4JobAnalF: Text8Pt;
    I4JAnalL: Label8;
    Label88: Label8;
    I1YRef: Text8Pt;
    Label89: Label8;
    I1LYRef: Text8Pt;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    Label810: Label8;
    Label811: Label8;
    I1LocF: Text8Pt;
    TSPrevBtn: TSBSButton;
    TSFinBtn: TSBSButton;
    LinkCF: Text8Pt;
    Label814: Label8;
    Label815: Label8;
    SBSPanel2: TSBSPanel;
    TSNextBtn: TSBSButton;
    TSInpClsBtn: TSBSButton;
    Bevel1: TBevel;
    BROrd: TBorRadio;
    BRInv: TBorRadio;
    BRQUO: TBorRadio;
    Label816: Label8;
    btnApplyTTD: TButton;
    mnuApplyTTD: TMenuItem;
    ListMenu: TPopupMenu;
    miAllStock: TMenuItem;
    miRegularStockSales: TMenuItem;
    miTeleSalesListOrder: TMenuItem;
    miChosenItems: TMenuItem;
    miNoFilter: TMenuItem;
    N4: TMenuItem;
    UnitSPanel: TSBSPanel;
    UnitSLab: TSBSPanel;
    PostCodeTxt: Text8Pt;
    Label81: Label8;
    lstDeliveryCountry: TSBSComboBox;
    lblLine1: TLabel;
    lblLine2: TLabel;
    lblLine3: TLabel;
    lblLine4: TLabel;
    lblLine5: TLabel;
    Label1: TLabel;
    lblUnitPrice: Label8;
    edtUnitPrice: TCurrencyEdit;
    Bevel3: TBevel;
    mnuOptGenerateOrderWithPayment: TMenuItem;
    btnIntrastatSettings: TButton;

    { CS: 14/04/2008 - Amendments for Form Resize routines }
    procedure FormStartResize(var Msg: TMsg); message WM_ENTERSIZEMOVE;
    procedure FormEndResize(var Msg: TMsg); message WM_EXITSIZEMOVE;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure Clsd1BtnClick(Sender: TObject);
    procedure D1RefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure D1RefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure D1RefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure MarginView1Click(Sender: TObject);
    procedure AllStock1Click(Sender: TObject);
    procedure OSOrders1Click(Sender: TObject);
    procedure TPr1Click(Sender: TObject);
    procedure Currency1Click(Sender: TObject);
    procedure Prices1Click(Sender: TObject);
    procedure Loc1Click(Sender: TObject);
    procedure CC1Click(Sender: TObject);
    procedure AltStkCode1Click(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure LstD1BtnClick(Sender: TObject);
    procedure ViewD1BtnClick(Sender: TObject);
    procedure FilterD1BtnClick(Sender: TObject);
    procedure ScleD1BtnClick(Sender: TObject);
    procedure AddD1BtnClick(Sender: TObject);
    procedure StkRD1BtnClick(Sender: TObject);
    procedure HistD1BtnClick(Sender: TObject);
    procedure ChkD1BtnClick(Sender: TObject);
    procedure TSNextBtnClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure Ledger1Click(Sender: TObject);
    procedure StreD1BtnClick(Sender: TObject);
    procedure GOrd1Click(Sender: TObject);
    procedure DefD1BtnClick(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure CurrFExit(Sender: TObject);
    procedure I1TransDateFExit(Sender: TObject);
    procedure I1YRefExit(Sender: TObject);
    procedure I5ISBtnClick(Sender: TObject);
    procedure I4JobCodeFExit(Sender: TObject);
    procedure I4JobAnalFChange(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure I1LocFExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TSPrevBtnClick(Sender: TObject);
    procedure CompFDblClick(Sender: TObject);
    procedure ACFFDblClick(Sender: TObject);
    procedure ACFFEnter(Sender: TObject);
    procedure PopupMenu7Popup(Sender: TObject);
    procedure I1YRefChange(Sender: TObject);
    procedure I1LYRefChange(Sender: TObject);
    procedure btnApplyTTDClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnIntrastatSettingsClick(Sender: TObject);
  private
    TeleSRun,
    InHBeen,
    RecMode,
    BeenIn,
    CheckCLimit,
    ForceACEdit,
    JustCreated,
    StoreCoord,
    LastCoord,
    SetDefault,
    PastFCreate,
    fNeedCUpdate,
    FColorsChanged,
    UpdateTotals,
    fFrmClosing,
    fDoingClose,
    fFinishedOK,
    GotCoord,
    DuringActive,
    ForceTSStore,
    CurrChange,
    ApplyTTD,
    CanDelete    :  Boolean;

    ChkInProg,
    LastPr,
    LastYr,
    LastMode     :  Byte;

    BeenAECnt,
    PM5Cnt,
    PM4Cnt,
    PM3Cnt,
    PM2Cnt       :  Integer;

    OriginalTotal:  Double;

    PagePoint    :  Array[0..6] of TPoint;

    BPTots       :  Array[0..3] of TCurrencyEdit;


    CustBtnList  :  TVisiBtns;

    StartSize,
    MaxSize,
    InitSize     :  TPoint;


    CuStkLine    :  TCuStkT1;

    {$IFDEF SOP}
      TSStkLine  :  TCuStkT2;
      TSDefFrm   :  TCuStkT4;

      TSDAddr    :  Array[1..5] of Text8pt;

      ISCtrl     :  TIntStatInv;

      TTDHelper :  TTTDTelesaleHelper;
    {$ENDIF}


    DrillStk,
    DispStk      :  TFStkDisplay;

    {$IFDEF Nom}
      HistForm     :   THistWin;
    {$ENDIF}

    { CS: 14/04/2008 - Amendments for Form Resize routines }
    IsResizing: Boolean;

    // CJS 2013-10-07 - MRD1.1.22 - Consumer Support
    WasConsumer : Boolean;

    // MH 25/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    SettlementDiscountPercentage : Double;

    procedure ResizeAcCodeField;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Function DrillStkLives  :  Boolean;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Procedure Loaded; Override;

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function CheckListFinished  :  Boolean;

    procedure OutTeleSTot;

    procedure OutTeleSBot;

    procedure OutStkLstBot;

    procedure Link2Tot;

    Procedure SetButtons(State  :  Boolean);

    Function SetHelpC(PageNo :  Boolean;
                      Help0,
                      Help1  :  LongInt) :  LongInt;

    Function SetDelBtn  :  Boolean;

    procedure PrimeButtons(PWRef   :  Boolean);

    Function CK_Title(CKAnal     :  CKAnalType)  :  Str255;

    Procedure SetColDec(PageNo  :  Byte);

    Procedure HidePanels(PageNo    :  Byte);

    Procedure ManageMenus;

    Procedure UpdateListView(UpdateList  :  Boolean);

    procedure Display_CSRec(Mode  :  Byte);

    procedure Display_Rec(Mode  :  Byte);

    procedure DrillToStkLedger(NPr,NYr,DMode  :  Byte);

    procedure Display_History(ChangeFocus :  Boolean);


    {$IFDEF SOP}
      procedure SetGenStatus;

      procedure OutTeleSImp;

      procedure Form2TeleS;

      procedure Display_TSRec(Mode  :  Byte);

      procedure Display_TSDefFrm;

      Function CheckTSCompleted(Edit  :  Boolean)  : Boolean;

      procedure BeginTeleSales(CP  :  Boolean);

    {$ENDIF}

    // Displays the Intrastat Details form. If ForValidation is True,
    // validates the intrastat details first, and only displays the form
    // if there are any problems.
    //
    // Returns False if any problems were found with the validation.
    function ShowIntrastatDetails(ForValidation: Boolean): Boolean;

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListCSAnal   :  ^CKAnalType;

    TeleSHed     :  MLocPtr;

    ListOfSet    :  Integer;

    MULCtrlO     :  TTSList;



    procedure FormDesign;

    procedure SetCaption;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure SetFormProperties;

  end;

  Procedure Set_TSFormMode(TSRec   :  CKAnalType);


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
  DiscU3U,
  CuStkA2U,
  CuStkA3U,
  CuStkA5U,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {$IFDEF MC_On}
    LedCuU,
  {$ENDIF}

  {$IFDEF GF}
    FindRecU,
    FindCtlU,
  {$ENDIF}

  {$IFDEF SOP}
    InvLst3U,
    InvLst2U,
    InvCtSuU,

    CuStkT3U,
  {$ENDIF}

  ExThrd2U,

  {$IFDEF CU}
    Event1U,
  {$ENDIF}

{$IFDEF EXSQL}
  SQLUtils,
{$ENDIF}

{  GenWarnU,}
  Saltxl1U,
  MiscU,
  GenWarnU,
  PWarnU,
  Warn1U,
  SysU1,
  SysU2,

  // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added Generate Order with Payment option
  UA_Const,

  // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
  PassWR2U,
  JobUtils,

  // MH 25/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  TransactionHelperU,
  SavePos,

  // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  CountryCodes, CountryCodeUtils,

  // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom labelling for address fields
  CustomFieldsIntf,

  // CJS 2013-11-28 - MRD1.1.22 - Consumer Support
  ConsumerUtils,

  // CJS 2016-01-18 - ABSEXCH-17104 - Intrastat - 4.8 - Telesales
  IntrastatDetailsF,

  //SSK 22/02/2018 2018 R1 ABSEXCH-19778: GDPR
  GDPRConst;


{$R *.DFM}


Var
  LocalCSAnal   :  ^CKAnalType;

{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_TSFormMode(TSRec   :  CKAnalType);


Begin

  LocalCSAnal^:=TSRec;
end;



{$I Tsti1U.pas}


{$IFDEF POST}

  {$IFDEF SOP}
    { ========== TStkFreeze methods =========== }

    Constructor TRecalcTS.Create(AOwner  :  TObject);

    Begin
      Inherited Create(AOwner);

      fTQNo:=3;
      fMode:=0;
      fCanAbort:=BOn;

      fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

      MTExLocal:=nil;
      TeleSHed:=nil;

    end;

    Destructor TRecalcTS.Destroy;

    Begin

      {If (Assigned(TeleSHed)) then
      Begin
        Dispose(TeleSHed);
        TeleSHed:=nil;
      end;}

      Inherited Destroy;


    end;



    { ========= Procedure to Update default Stock Valuation ========= }

    Procedure  TRecalcTS.ReCalc_TSTotals;

    Const
      Fnum      =  MLocF;
      Keypath   =  MLK;

    Var
      KeyS,
      KeyChk   :  Str255;

      ItemCount:  LongInt;



    Begin

      With TeleSHed^.TeleSRec do
      Begin
        tcNetTotal:=0.0;
        tcVATTotal:=0.0;
        tcDiscTotal:=0.0;
        tcLineCount:=0;
      end;

      ItemCount:=0;

      ShowStatus(1,'Processing:-');

      With MTExLocal^ do
      Begin
        InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId));

        KeyChk:=PartCCKey(MatchTCode,MatchSCode)+FullCustCode(TeleSHed^.TeleSRec.tcCustCode);

        KeyS:=KeyChk;

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
        With LMLocCtrl^,CuStkRec do
        Begin

          Inc(ItemCount);

          UpdateProgress(ItemCount);

          If (csEntered) then
          Begin
            Case fMode of
              0  :  Calc_TeleTots(TeleSHed,cuStkRec,1);

              1  :  Begin
                      csEntered:=BOff;
                      csQty:=0;

                      LStatus:=LPut_Rec(Fnum,KeyPath);

                      LReport_BError(Fnum,LStatus);
                    end;

            end; {case..}

            ShowStatus(2,csStockCode);

          end;


          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        end; {While..}

      end; {With..}

      UpdateProgress(ThreadRec^.PTotal);

      If (fMyOwner is TForm) then
        SendMessage(TForm(fMyOWner).Handle,WM_CustGetRec,302,LongInt(@TeleSHed^));

    end; {Proc..}




    Procedure TRecalcTS.Process;

    Begin
      InMainThread:=BOn;

      Inherited Process;

      ShowStatus(0,'Calculate TeleSales Totals for '+TeleSHed^.TeleSRec.tcCustCode);

      ReCalc_TSTotals;
    end;


    Procedure TRecalcTS.Finish;
    Begin
      Inherited Finish;

      {Overridable method}

      InMainThread:=BOff;

    end;




    Function TRecalcTS.Start  :  Boolean;

    Var
      mbRet  :  Word;
      KeyS   :  Str255;

    Begin
      Result:=BOn;


      If (Result) then
      Begin
        If (Not Assigned(MTExLocal)) then { Open up files here }
        Begin
          {$IFDEF EXSQL}
          if SQLUtils.UsingSQL then
          begin
            // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
            if (not Assigned(LPostLocal)) then
              Result := Create_LocalThreadFiles;

            If (Result) then
              MTExLocal := LPostLocal;

          end
          else
          {$ENDIF}
          begin
            New(MTExLocal,Create(51));

            try
              With MTExLocal^ do
                Open_System(StockF,MLocF);

            except
              Dispose(MTExLocal,Destroy);
              MTExLocal:=nil;

            end; {Except}

            Result:=Assigned(MTExLocal);
          end;
        end;
      end;
      {$IFDEF EXSQL}
      if Result and SQLUtils.UsingSQL then
      begin
        MTExLocal^.Close_Files;
        CloseClientIdSession(MTExLocal^.ExClientID, False);
      end;
      {$ENDIF}
    end;




   Procedure AddRecalcTS2Thread(AOwner     :  TObject;
                                TSR        :  MLocPtr;
                                Mode       :  Byte);



    Var
      LCheck_Stk :  ^TReCalcTS;

    Begin

      If (Create_BackThread) then
      Begin
        New(LCheck_Stk,Create(AOwner));

        try
          With LCheck_Stk^ do
          Begin
            If (Start) and (Create_BackThread) then
            Begin
              New(TeleSHed);

              TeleSHed^:=TSR^;
              fMode:=Mode;

              With BackThread do
                AddTask(LCheck_Stk,'Recalc TeleS');
            end
            else
            Begin
              Set_BackThreadFlip(BOff);
              Dispose(LCheck_Stk,Destroy);
            end;
          end; {with..}

        except
          If (Assigned(LCheck_Stk^.TeleSHed)) then
            Dispose(LCheck_Stk^.TeleSHed);

          Dispose(LCheck_Stk,Destroy);

        end; {try..}
      end; {If process got ok..}

    end;



  {$ENDIF}
{$ENDIF}


Procedure  TTeleSFrm.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TTeleSFrm.Find_FormCoord;


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

    PrimeKey:=Chr(Ord('T')+Ord(ListCSAnal^.IsTeleS));

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then
      Begin {* Go get postion, as would not have been set initianly *}
        MaxSize.Y:=GlobHeight;
        MaxSize.X:=GlobWidth;

        SetPosition(ThisForm);
      end;
    end;


    GetbtControlCsm(PageControl1);

    GetbtControlCsm(D1SBox);

    GetbtControlCsm(D1ListBtnPanel);

    GetbtControlCsm(D1BtnPanel);

    GetbtControlCsm(D1BSBox);

    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

    {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TTeleSFrm.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:=Chr(Ord('T')+Ord(ListCSAnal^.IsTeleS));

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);


    StorebtControlCsm(PageControl1);

    StorebtControlCsm(d1SBox);

    StorebtControlCsm(d1BtnPanel);

    StorebtControlCsm(d1BSBox);

    StorebtControlCsm(d1ListBtnPanel);


    MULCtrlO.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;



procedure TTeleSFrm.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(D1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(D1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(D1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(D1BtnPanel.Height);

  PagePoint[3].X:=D1BtnPanel.Height-(D1BSBox.Height);
  PagePoint[3].Y:=D1SBox.ClientHeight-(D1RefPanel.Height);

  PagePoint[4].Y:=PageControl1.Height-(D1ListBtnPanel.Height);


  PagePoint[5].X:=ClientWidth-Bevel1.Width;
  PagePoint[5].Y:=ClientHeight-Bevel1.Top;

  PagePoint[6].X:=D1BtnPanel.Left-TSFinBtn.Left;
  PagePoint[6].Y:=TSFinBtn.Left-TSPrevBtn.Left;



  {GotCoord:=BOn;}

end;


procedure TTeleSFrm.OutTeleSTot;


Begin
  With MLocCtrl^.CuStkRec do
  Begin
    With TeleSHed^.TeleSRec do
    Begin
      TotCB.Value:=Round_Up(tcNetTotal-tcDiscTotal,2);
      TotPay.Value:=tcVATTotal;
      TotRec.CurrencySymb:=PSymb(TcCurr);
      TotRec.Value:=Round_Up(tcNetTotal-tcDiscTotal+tcVATTotal,2);

    end;

  end; {With..}
end;



procedure TTeleSFrm.OutTeleSBot;

Const
  Fnum      =  MLocF;
  Keypath2  =  MLSecK;


Var
  KeyChk  :  Str255;


Begin
  With ExLocal, ListCSAnal^, LMLocCtrl^.CuStkRec do
  Begin
    OutStkLstBot;

    If (ScanMode=2) then
    Begin
      KeyChk:=PartCCKey(MatchTCode,MatchSCode)+Full_CuStkKey(LCust.CustCode,LStock.StockCode);

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath2,KeyChk);

      If (Not StatusOk) then
      Begin
        LResetRec(Fnum);
      end;

    end
    else
      LMLocCtrl^:=MLocCtrl^;


    I1NomCodeF.Text:=Form_Int(csNomCode,0);

    I1CCF.Text:=csCCDep[BOn];
    I1DepF.Text:=csCCDep[BOff];

    I1LocnF.Text:=csLocCode;

  end; {With..}
end;


procedure TTeleSFrm.OutStkLstBot;


Begin
  With ExLocal, MLocCtrl^.CuStkRec, ListCSAnal^ do
  Begin
    Case ScanMode of
      2  :  If (LStock.StockCode<>Stock.StockCode) then
               AssignFromGlobal(StockF);
      else  If (LStock.StockCode<>csStockCode) then
              LGetMainRecPos(StockF,csStockCode);
    end;

    StkDescF.Text:=LStock.Desc[1];

  end; {With..}
end;


procedure TTeleSFrm.Link2Tot;


Begin
  {If (Assigned(MULCtrlO)) then
    MULCtrlO.GetSelRec(BOn);}

  If (TeleSRun) then
    OutTeleSBot
  else
    OutStkLstBot;

{$IFDEF EXSQL}
    if SQLUtils.UsingSQL and (MULCtrlO <> nil) and (EXLocal.LStock.StockCode <> '') then
    begin
      edtUnitPrice.CurrencySymb:=TotRec.CurrencySymb;
      edtUnitPrice.Value := MULCtrlO.UnitPrice;
    end
    else
      edtUnitPrice.Value := 0.0;
{$ENDIF}

  Prices1Click(Nil);
end;


Procedure TTeleSFrm.SetButtons(State  :  Boolean);


Begin
  CustBtnList.SetEnabBtn(State);

end;



Function TTeleSFrm.SetHelpC(PageNo :  Boolean;
                            Help0,
                            Help1  :  LongInt) :  LongInt;

Begin
  Begin
    If (PageNo) then
      Result:=Help1
    else
      Result:=Help0;
  end;

end;



Function TTeleSFrm.SetDelBtn  :  Boolean;

Begin
  Result:=(TeleSRun or ((Not PChkAllowed_In(470)) and ListCSAnal^.IsaC) or ((Not PChkAllowed_In(471)) and (Not ListCSAnal^.IsaC)));

end;


procedure TTeleSFrm.PrimeButtons(PWRef   :  Boolean);
Var
  HideAge  :  Boolean;

Begin
  If (PWRef) and (Assigned(CustBtnList)) then
  Begin
    LockWindowUpDate(Handle);

    {SetTabs2;}
    CustBtnList.ResetButtons;
    CustBtnList.Free;
    CustBtnList:=nil;

  end;


  If (CustBtnList=nil) then
  Begin
    CustBtnList:=TVisiBtns.Create;

    {$IFDEF SOP}
      HideAge:=BOff;
    {$ELSE}
      HideAge:=BOn;
    {$ENDIF}

    try

      With CustBtnList do
        Begin
          {00} AddVisiRec(AddD1Btn,BOff);
               SetBtnHelp(0,SetHelpC(TeleSRun,811,791));

          {01} AddVisiRec(EditD1Btn,BOff);
               SetBtnHelp(1,SetHelpC(TeleSRun,811,792));

          {$B-}
          {02} AddVisiRec(DelD1Btn,SetDelBtn);
          {$B+}
          {03} AddVisiRec(FindD1Btn,BOff);
          {04} AddVisiRec(LstD1Btn,BOff);
          {05} AddVisiRec(ViewD1Btn,BOff);
               SetBtnHelp(5,SetHelpC(TeleSRun,813,794));

               With Syss do
          {06}   AddVisiRec(FilterD1Btn,(Not UseCCDep) and (Not UseMLoc) and (Not PostCCNom));

          {07} AddVisiRec(HistD1Btn,BOff);
          {08} AddVisiRec(StkRD1Btn,BOff);
          {09} AddVisiRec(ScleD1Btn,BOff);
               SetBtnHelp(09,SetHelpC(TeleSRun,816,797));

          {10} AddVisiRec(PrceD1Btn,BOff);
          {11} AddVisiRec(StreD1Btn,Not TeleSRun);

               {$IFDEF MC_On}
          {12}   AddVisiRec(CurD1Btn,TeleSRun);
          {13}   AddVisiRec(TxD1Btn,TeleSRun);
               {$ELSE}
          {13}   AddVisiRec(CurD1Btn,BOn);
          {14}   AddVisiRec(TxD1Btn,BOn);
               {$ENDIF}

          {14} AddVisiRec(ChkD1Btn,BOff);
               SetBtnHelp(14,SetHelpC(TeleSRun,815,801));

          {15} AddVisiRec(DefD1Btn,Not TeleSRun);

          {16} AddVisiRec(btnApplyTTD,Boff);

          HideButtons;
        end; {With..}

    except

      CustBtnList.Free;
      CustBtnList:=nil;
    end; {Try..}



    If (TeleSRun) then
    Begin
      {GOrd1.Visible:=PChkAllowed_In(346);
      GInv1.Visible:=PChkAllowed_In(347);
      GQU1.Visible:=PChkAllowed_In(348);

      If (Not GOrd1.Visible) and (Not GInv1.Visible) and (Not GQU1.Visible) then
      Begin
        TSFinBtn.Enabled:=BOff;
        StreD1Btn.Enabled:=BOff;
      end;}

      BROrd.Visible:=PChkAllowed_In(346);
      BRInv.Visible:=PChkAllowed_In(347);
      BRQuo.Visible:=PChkAllowed_In(348);

      If (Not BROrd.Visible) and (Not BRInv.Visible) and (Not BRQuo.Visible) then
      Begin
        TSFinBtn.Enabled:=BOff;
        StreD1Btn.Enabled:=BOff;
      end;
    end;



    If (PWRef) then
      LockWindowUpDate(0);


  end {If needs creating }
  else
    CustBtnList.RefreshButtons;
end;




Procedure TTeleSFrm.WMCustGetRec(Var Message  :  TMessage);

Var
  TSPtr  :  MLocPtr;
  PrimeKey
         :  Str255;

  {$IFDEF SOP}
    OpoLineCtrl
           :  TOpoLineCtrl;
  {$ENDIF}


Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,1,169
         :  Begin
              If (Assigned(MULCtrlO)) then
                PostMessage(Self.Handle,WM_FormCloseMsg,WParam,LParam);

            end;


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      25 :  Begin
              NeedCUpdate:=BOn;
              FColorsChanged := True;
            End;


      52,53
         :  Begin
              ExLocal.AssignFromGlobal(NHistF);

              With NHist do
                DrillToStkLedger(Pr,Yr,1);
            end;

      62
         :  Begin

              ExLocal.AssignFromGlobal(NHistF);

              With NHist do
                DrillToStkLedger(Pr,Yr,1);

            end;


      56 :  Begin
              SendMessage(Self.Handle,WM_Close,0,0);

            end;


     116 :  With MULCtrlO do
             {If (ListCSAnal^.ScanMode<>2) then}
             Begin

               AddNewRow(MUListBoxes[0].Row,(LParam=1));

               If (TeleSRun) then
                 OutTeleSTot;

             end;

      117 : With MULCtrlO do
            {If (ListCSAnal^.ScanMode<>2) then}
            Begin

              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;

              If (TeleSRun) then
                OutTeleSTot;

            end;

      203 :  CuStkLine:=nil;

      {$IFDEF SOP}
        204 :  Begin
                 TSStkLine:=nil;

                 {Revert focus address back to parent for this}
                   OpoLineHandle:=Self.Handle;

               end;

        205 :  Begin
                 TSDefFrm:=nil;

                 If (LParam<>0) then
                 Begin

                   TSPtr:=Pointer(LParam);
                   TeleSHed^:=TSPtr^;

                   UpdateTotals:=BOn;

                   Dispose(TSPtr);
                 end;

               end;
      {$ENDIF}

      207     :  Begin {Reset TS as currency has changed}
                   Try
                     GOrd1Click(GCan1);
                   finally

                   end; {try..}

                 end;


      {$IFDEF POST}
        {$IFDEF SOP}

          302  :  If (LParam<>0) then
                  Begin

                    SetButtons(BOn);

                    TSPtr:=Pointer(LParam);

                    TeleSHed^:=TSPtr^;

                    Dispose(TSPtr);

                    OutTeleSTot;

                    If (ChkInProg=2) and (Assigned(MULCtrlO)) then {* It was a list reset *}
                      MULCtrlO.PageUpDn(0,BOn);


                    ChkInProg:=0;

                    ForceTsStore:=BOn;

                    OutTeleSImp;

                    If (Not CurrChange) then
                    Begin
                      fFinishedOk:=BOn;

                      PostMessage(Self.Handle,WM_Close,0,0);

                    end
                    else
                      TeleSHed^.TeleSRec.tcInProg:=BOn;

                    CurrChange:=BOff;

                  end;
        {$ENDIF}
      {$ENDIF}

    {$IFDEF SOP}
       1103
            : Begin {Link from Obj Stk Enq Equiv oppo hot link to auto create the line}
                If (Not Assigned(TSStkLine)) and (TeleSRun) and (PageControl1.ActivePage=ItemPage) then
                Begin
                  New(OpoLineCtrl,Create(Pointer(LParam)));

                  try
                    With OpoLineCtrl^ do
                    Begin

                      If (Not Have_TSLine(ExLocal,OStockCode,BOff)) then
                      Begin
                        AddD1BtnClick(AddD1Btn);

                        If (Assigned(TSStkLine))  then
                        Begin
                          SendMessage(TSStkLine.Handle,WM_CustGetRec,1101,LParam);

                        end;
                      end
                      else
                      Begin
                        If (Have_TSLine(ExLocal,OStockCode,BOn)) then
                        Begin
                          AddD1BtnClick(EditD1Btn);

                          If (Assigned(TSStkLine))  then
                          Begin
                            SendMessage(TSStkLine.Handle,WM_CustGetRec,1105,LParam);

                          end;
                        end;
                      end;

                    end;
                  Finally
                    Dispose(OpoLineCtrl,Destroy);

                  end; {try..}

                end;
              end;
     {$ENDIF}

  {$IFDEF GF}

    3003
          : If (Assigned(FindCust)) then
              With MULCtrlO, ListCSAnal^, FindCust,ReturnCtrl do
              Begin
                InFindLoop:=BOn;

                Case ActiveFindPage of
                  // CJS 2015-01-21 - ABSEXCH-15434, ABSEXCH-16054, ABSEXCH-15943 - Find on Telesales fails
                  tabFindStock :
                    Begin
                      If (ListCSAnal^.ScanMode=1) then
                      Begin
                        PrimeKey:=SearchKey;

                        If (SearchMode<>30) then {We need to find by other means}
                        Begin
                          Status:=Find_Rec(B_GetGEq,F[StockF],StockF,RecPtr[StockF]^,SearchPath,PrimeKey);

                          If (StatusOk and (CheckKey(SearchKey,PrimeKey,Length(SearchKey),BOff))) then
                            PrimeKey:=VarConst.Stock.StockCode
                          else
                          Begin
                            PrimeKey:=SearchKey;
                            Ccode:=NdxWeight;
                          end;
                        end;


                      end
                      else
                        PrimeKey:=VarConst.Stock.StockCode;


                      Find_Now(CCode,PrimeKey);
                    end;
                end; {Case..}

                InFindLoop:=BOff;
              end;

  {$ENDIF}


    end; {Case..}
  end;
  Inherited;
end;


Function TTeleSFrm.DrillStkLives  :  Boolean;

Begin
  Result:=Assigned(DrillStk);

  If (Result) then
    Result:=Assigned(DrillStk.StkRecForm);

end;


Procedure TTeleSFrm.WMFormCloseMsg(Var Message  :  TMessage);

Var
  IMode  :  SmallInt;

Begin

  With Message do
  Begin
    Case WParam of
      0,1,169
         :  Begin
              If (WParam=169) then
              Begin
                MULCtrlO.GetSelRec(BOff);
                IMode:=0;
              end
              else
                IMode:=WParam;

              If (IMode=1) then
                Link2Tot;

              {$IFDEF NOM}
                If ((DrillStkLives) and (Not Assigned(HistForm))) or ((Imode=0) and (Not TeleSRun)) then
              {$ELSE}
                If (DrillStkLives)  or ((Imode=0) and (Not TeleSRun)) then

              {$ENDIF}

                  DrillToStkLedger(LastPr,LastYr,LastMode)
              {$IFDEF NOM}
                else
                  If (Assigned(HistForm)) then
                    Display_History(BOff);

              {$ELSE}
                ;
               {$ENDIF}

               If (IMode=0) and (TeleSRun) then
                 Display_Rec(2);
            end;

      {$IFDEF NOM}
        41 :  Begin
                HistForm:=nil;
                LastPr:=0; LastYr:=0; LastMode:=0;
              end;
      {$ENDIF}

        52,53,62
          :  PostMessage(Self.Handle,WM_CustGetRec,WParam,LParam);

    end; {Case..}

  end;

  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TTeleSFrm.Send_UpdateList(Mode   :  Integer);

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


Procedure TTeleSFrm.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin
    If (Not GotCoord) and (Not JustCreated) and (PastFCreate) then
    Begin
      ptMinTrackSize.X:=MaxSize.X;
      ptMinTrackSize.Y:=MaxSize.Y;
      ptMaxTrackSize.X:=MaxSize.X;
      ptMaxTrackSize.Y:=MaxSize.Y;
    end
    else
    Begin
      ptMinTrackSize.X:=200;
      ptMinTrackSize.Y:=210;

    end;

    {ptMaxSize.X:=530;
    ptMaxSize.Y:=368;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;


Procedure TTeleSFrm.WMSysCommand(Var Message  :  TMessage);


Begin
  With Message do
    Case WParam of

      SC_Maximize  :  Begin
                        Self.ClientHeight:=InitSize.Y;
                        Self.ClientWidth:=InitSize.X;

                        WParam:=0;
                      end;

    end; {Case..}

  Inherited;
end;








procedure TTeleSFrm.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LFnum,
  LKeyLen     :  Integer;

Begin
  LKeyPath := 0;
  LFNum := MLocF;
  {KeyStart:=FullBankMKey(MBankHed,MBankSub,CtrlNom,CtrlCr);}


  If (Assigned(MULCtrlO)) then
  With MULCtrlO,  ListCSAnal^ do
  Begin

    Case ScanMode of
      1,3
         :  Begin
              KeyStart:=PartCCKey(MatchTCode,MatchSCode)+ListCSAnal^.CCode+ConstStr(#0,4);
              LFnum:=MLocF;

              If (ScanMode=1) then
              Begin
                LKeypath:=MLSecK;
              end
              else
              Begin
                LKeypath:=MLK;
                
              end;

              Filter[2,1]:=#0;
              Filter[1,1]:=NdxWeight;
              Filter[3,1]:=#0;

            end;

      2  :  Begin
              KeyStart:='';
              LFnum:=StockF;
              LKeypath:=StkCodeK;

              Filter[2,1]:=StkGrpCode;
              Filter[1,1]:=StkDListCode;

            end;


    end; {Case..}

    LKeyLen:=Length(KeyStart);



    IgnoreMsg:=IgMsg;

    MULCtrlO.UseVariant := true;
    StartList(LFnum,LKeypath,KeyStart,'','',LKeyLen,(Not ShowLines));

{$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      ListKey := KeyStart;
{$ENDIF}

    IgnoreMsg:=BOff;
  end;

end;



Procedure TTeleSFrm.ManageMenus;

Begin
  With ListCSAnal^ do
  Begin
    MarginView1.Visible:=(DispMode<>1) and (Not IsTeleS);
    StatsView1.Visible:=(DispMode<>2)  and (IsTeleS);
    Prices2.Visible:=(DispMode<>3);

    {$IFDEF SOP}
      OSOrders1.Visible:=(OrdMode<>1) and (Not IsTeleS);
      Invoices1.Visible:=(OrdMode<>0);
      CompOrd1.Visible:=(OrdMode<>2);
      AltStkCode1.Visible:=Not OwnPNo;
      StdStkCodes1.Visible:=OwnPNo;

    {$ELSE}
      OSOrders1.Visible:=BOff;
      CompOrd1.Visible:=BOff;
      AltStkCode1.Visible:=BOff;
      Invoices1.Visible:=BOff;
      StdStkCodes1.Visible:=BOff;

    {$ENDIF}

    miRegularStockSales.Checked := (ScanMode = 1);
    miAllStock.Checked := (ScanMode = 2);
    miAllStock.Visible := IsTeleS;
    miTeleSalesListOrder.Checked := (ScanMode = 3);

    N4.Visible := IsTeleS;

    miChosenItems.Visible := IsTeleS;
    miChosenItems.Enabled := IsTeleS and (ScanMode <> 2);
    miChosenItems.Checked := IsTeleS and (OrdMode = 3) and (ScanMode <> 2);

    miNoFilter.Visible := IsTeleS;
    miNoFilter.Enabled := IsTeleS and (ScanMode <> 2);
    miNoFilter.Checked := IsTeleS and (OrdMode = 0) and (ScanMode <> 2);

    With Syss do
    Begin
      Filter1.Visible:=((UseCCDep) and (PostCCNom)) or (UseMLoc) ;

      Dep1.Visible:=UseCCDep;
      CC1.Visible:=UseCCDep;
      Loc1.Visible:=UseMLoc;
    end;

    SPr1.Visible:=(OrdMode<>1) and (ScaleMode<>0);
    STD1.Visible:=(OrdMode<>1) and (ScaleMode<>1);
    STW1.Visible:=(OrdMode<>1) and (ScaleMode<>2);
    S2W1.Visible:=(OrdMode<>1) and (ScaleMode<>3);
    SYTD1.Visible:=(OrdMode<>1) and (ScaleMode<>4);

    TPr1.Visible:=(OrdMode<>1) and (ScaleMode<>0);
    TW1.Visible:=(OrdMode<>1) and (ScaleMode<>1);
    TW2.Visible:=(OrdMode<>1) and (ScaleMode<>2);
    TW3.Visible:=(OrdMode<>1) and (ScaleMode<>3);


    With CustBtnList do
    Begin
      SetHideBtn(1,(ScanMode=2),BOff);  {* Set Edit and Delete to off if Stock Mode *}
      SetHideBtn(2,(ScanMode=2) or SetDelBtn,BOn);

      Edit1.Visible:=EditD1Btn.Visible;
      Delete1.Visible:=DelD1Btn.Visible;

      {$IFDEF SOP}
        // Apply TTD button - SOP only
        SetHideBtn(16,(DispMode<>2) Or (Not Syss.EnableTTDDiscounts),BOn);
        btnApplyTTD.Enabled := Not TTDHelper.ApplyTTD;
      {$ELSE}
        SetHideBtn(16,True,BOff);
      {$ENDIF}
    end;
  end;


  UpdateSubMenu(PopUpMenu4,PM4Cnt,View1);
  UpdateSubMenu(PopUpMenu3,PM3Cnt,Filter1);
  UpdateSubMenu(ListMenu,PM2Cnt,List1, True);

  If TeleSRun then
  Begin
    UpdateSubMenu(PopUpMenu6,PM5Cnt,Scale1);

  end
  else
    UpdateSubMenu(PopUpMenu5,PM5Cnt,Scale1);

  SetCaption;
end;





Procedure TTeleSFrm.SetColDec(PageNo  :  Byte);

Var
  n  :  Byte;

Begin
  With MULCtrlO, ListCSAnal^ do
  Begin
    If (IsTeleS) then
    Begin
      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      If (n In [1..6]) then
      Begin
        Case n of
          2..4  : NoDecPlaces:=Syss.NoQtyDec;
          5     : NoDecPlaces:=Syss.NoNetDec;
          6     : NoDecPlaces:=2;
        end; {Case..}

        Case DispMode of
          2  :  Begin
                  Case n of
                    1    :  NoDecPlaces:=Syss.NoQtyDec;
                  end; {Case..}
                end;

          3  :  Begin
                  Case n of
                    // MH 27/05/2010 v6.4 ABSEXCH-2633: Modified to display last price to 2dp
                    1    :  NoDecPlaces:=2; //Syss.NoNetDec;
                  end; {Case..}
                end;


        end; {Case..}

      end; {With..}

    end
    else
    Begin
      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      If (n In [1..6]) then
      Begin

        Case DispMode of
          1  :  Begin
                  Case n of
                    1    :  NoDecPlaces:=Syss.NoQtyDec;

                    // MH 27/05/2010 v6.4 ABSEXCH-2633: Modified to display last price to 2dp
                    //4  :  If (IsaC) then
                    //          NoDecPlaces:=Syss.NoNetDec
                    //        else
                    //          NoDecPlaces:=Syss.NoCosDec;

                    else    NoDecPlaces:=2;
                  end; {Case..}
                end;

          2  :  Begin
                  Case n of
                    1,2  :  NoDecPlaces:=Syss.NoQtyDec;
                    3    :  If (IsaC) then
                              NoDecPlaces:=Syss.NoNetDec
                            else
                              NoDecPlaces:=Syss.NoCosDec;

                    else    NoDecPlaces:=2;
                  end; {Case..}
                end;

          3  :  Begin
                  Case n of
                    1,2  :  NoDecPlaces:=Syss.NoQtyDec;

                    // MH 27/05/2010 v6.4 ABSEXCH-2633: Modified to display last price to 2dp
                    3{,4}:  If (IsaC) then
                              NoDecPlaces:=Syss.NoNetDec
                            else
                              NoDecPlaces:=Syss.NoCosDec;

                    else    NoDecPlaces:=2;
                  end; {Case..}

                end;
        end; {Case..}

      end; {With..}

    end;

  end;
end;


Procedure TTeleSFrm.UpdateListView(UpdateList  :  Boolean);

Begin
  With MULCtrlO do
  Begin

    If (UpdateList) then
    Begin
      {ListCSAnal^:=Self.ListCSAnal^;}
      DisplayMode:=ListCSAnal^.DispMode;
    end;

    SetColDec(0);
    HidePanels(0);

    ReAssignCols;

    VisiList.SetHedPanel(ListOfSet);

    ManageMenus;

    If (UpdateList) then
    Begin
      PageUpDn(0,BOn);
    end;

  end;
end;


Procedure TTeleSFrm.HidePanels(PageNo    :  Byte);

Begin
  D1SBox.HorzScrollBar.Position:=0;

  With MULCtrlO,VisiList,ListCSAnal^ do
  Begin
    If (IsTeleS) then
    Begin
      SetHidePanel(7,BOn,BOff);
      SetHidePanel(8,BOn,BOn);
      {$IFDEF EXSQL}
      if SQLUtils.UsingSQL then
        SetHidePanel(6,BOn,BOn);
      {$ENDIF}

      IdPanel(FindxColOrder(4),BOn).Caption:='This Qty';
      IdPanel(FindxColOrder(6),BOn).Caption:='U/Price';
      IdPanel(FindxColOrder(5),BOn).Caption:='Total';

      Case DispMode of
        2  :  Begin
                Case ScaleMode of
                  0  :  Begin
                          IdPanel(FindxColOrder(1),BOn).Caption:='Per 3';
                          IdPanel(FindxColOrder(2),BOn).Caption:='Per 2';
                          IdPanel(FindxColOrder(3),BOn).Caption:='Per 1';
                        end;

                  1  :  Begin
                          IdPanel(FindxColOrder(1),BOn).Caption:='Wk 3';
                          IdPanel(FindxColOrder(2),BOn).Caption:='Wk 2';
                          IdPanel(FindxColOrder(3),BOn).Caption:='Wk 1';
                        end;
                  2  :  Begin
                          IdPanel(FindxColOrder(1),BOn).Caption:='Wk 5-6';
                          IdPanel(FindxColOrder(2),BOn).Caption:='Wk 3-4';
                          IdPanel(FindxColOrder(3),BOn).Caption:='Wk 1-2';

                        end;

                  3  :  Begin
                          IdPanel(FindxColOrder(1),BOn).Caption:='Wk 9-12';
                          IdPanel(FindxColOrder(2),BOn).Caption:='Wk 5-8';
                          IdPanel(FindxColOrder(3),BOn).Caption:='Wk 1-4';

                        end;

                end; {case..}



              end;


        3  :  Begin
                IdPanel(FindxColOrder(1),BOn).Caption:='Last-Paid';
                IdPanel(FindxColOrder(2),BOn).Caption:='Free Stk';
                IdPanel(FindxColOrder(3),BOn).Caption:='R/O Qty';
              end;


      end;
    end
    else
    Begin
      SetHidePanel(4,(DispMode=2),BOff);
      SetHidePanel(5,BOn,BOff);
      SetHidePanel(6,BOn,BOff);
      SetHidePanel(7,(DispMode=3),BOff);
      SetHidePanel(8,(DispMode<>1),BOn);
      SetHidePanel(9,BOn,BOff); // Hide the Unit of Sale column

      Case DispMode of
        1  :  Begin
                IdPanel(FindxColOrder(2),BOn).Caption:='Turnover';
                IdPanel(FindxColOrder(3),BOn).Caption:='Margin';
                IdPanel(FindxColOrder(4),BOn).Caption:='Last-Paid';


              end;


        2  :  Begin
                IdPanel(FindxColOrder(2),BOn).Caption:='Qty-YTD';
                IdPanel(FindxColOrder(3),BOn).Caption:='Last-Paid';


              end;


        3  :  Begin
                IdPanel(FindxColOrder(2),BOn).Caption:='Qty-YTD';
                IdPanel(FindxColOrder(3),BOn).Caption:='1-Off-Prce';

                IdPanel(FindxColOrder(4),BOn).Caption:='Last-Paid';


              end;


      end;
    end;
  end;
end;


procedure TTeleSFrm.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  StartPanel := nil;
  MULCtrlO:=TTSList.Create(Self);

  Try

    With MULCtrlO do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(D1RefPanel,D1RefLab);
          AddVisiRec(TSQ1Panel,TSQ1Lab);
          AddVisiRec(TSQ2Panel,TSQ2Lab);
          AddVisiRec(TSQ3Panel,TSQ3Lab);
          AddVisiRec(TSQ4Panel,TSQ4Lab);
          AddVisiRec(TSQ5Panel,TSQ5Lab);
          AddVisiRec(TSQ6Panel,TSQ6Lab);
          AddVisiRec(TSDatePanel,TSDateLab);
          AddVisiRec(TSGPPanel,TSGPLab);
          AddVisiRec(UnitSPanel, UnitSLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);


          {HidePanels(0);}

          LabHedPanel:=D1HedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;


      {FormSetOfSet;}


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

        If (n In [1..6]) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=Syss.NoQtyDec;
        end;
      end;

      ListCSAnal:=@Self.ListCSAnal^; {* Bind Together *}

      TeleSHed:=@Self.TeleSHed^; {* Bind Together *}

      If (ListCSAnal^.IsTeleS) then
        Filter[1,1]:=NdxWeight;

      DisplayMode:=ListCSAnal^.DispMode;;

      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOff;

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsBold];
      HighLiteStyle[2]:=[fsUnderline];
      HighLiteStyle[3]:=[fsUnderline,fsBold];

      Set_Buttons(D1ListBtnPanel);

      ReFreshList(BOn,BOff);

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;

  GotCoord:=BOn;

  FormSetOfSet;

  FormReSize(Self);

{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
  begin
    MULCtrlO.GetMatch(B_GetGEq, B_GetNext, MULCtrlO.ListKey);
    OutTeleSBot;
  end;
{$ENDIF}

  {RefreshList(BOn,BOn);}

end;


procedure TTeleSFrm.ResizeAcCodeField;
begin
  if Syss.ssConsumersEnabled then
  begin
    lblAcCode.Left := 222;//168;
    ACFF.Left := 244;//192;
    ACFF.Width := 151;
  end
  else
  begin
    lblAcCode.Left := 293;//238;
    ACFF.Left := 315;//263;
    ACFF.Width := 80;
  end;
  // Force a re-positioning of the drop-down/pop-up arrows
  ACFF.PosArrows;
end;

procedure TTeleSFrm.FormDesign;

Var
  HideCC    :  Boolean;
  NewHeight : Integer;
Begin
  HideCC:=BOff;

  ResizeAcCodeField;

  With ListCSAnal^,ExLocal do
  Begin
    If (Not IsTeleS) then
    Begin
      Label813.Visible:=BOff;
      I1CCLab.Visible:=BOff;
      I1DepLab.Visible:=BOff;
      I1LocnLab.Visible:=BOff;
      Label82.Visible:=BOff;
      TotCB.Visible:=BOff;
      Label84.Visible:=BOff;
      TotRec.Visible:=BOff;
      Label83.Visible:=BOff;
      TotPay.Visible:=BOff;
      I1NomCodeF.Visible:=BOff;
      I1CCF.Visible:=BOff;
      I1DepF.Visible:=BOff;
      I1LocnF.Visible:=BOff;
      TeleInpFrm.TabVisible:=BOff;
      PageControl1.ActivePage:=ItemPage;
      ItemPage.Caption:='Stock Analysis';
      ItemPage.HelpContext:=810;
    end
    else
    Begin
      {$IFDEF SOP}
        HideCC:=Syss.UseCCDep;

        I1CCLab.Visible:=HideCC;
        I1DepLab.Visible:=HideCC;
        I1CCF.Visible:=HideCC;
        I1DepF.Visible:=HideCC;
        Id3CCF.Visible:=HideCC;
        Id3DepF.Visible:=HideCC;
        Label810.Visible:=HideCC;

        I1LocnLab.Visible:=Syss.UseMLoc;
        I1LocnF.Visible:=Syss.UseMLoc;

        Label811.Visible:=Syss.UseMLoc;
        I1LocF.Visible:=Syss.UseMLoc;

        UPBOMP.Visible:=BOff;

        {$IFNDEF MC_On}
          CurrF.Visible:=BOff;
          Label815.Visible:=BOff;
          I1ExRateF.Visible:=BOff;
          I1ExLab.Visible:=BOff;
        {$ELSE}

          Set_DefaultCurr(CurrF.Items,BOff,BOff);
          Set_DefaultCurr(CurrF.ItemsL,BOff,BOn);


        {$ENDIF}

        TSDAddr[1]:=DAddr1F;
        TSDAddr[2]:=DAddr2F;
        TSDAddr[3]:=DAddr3F;
        TSDAddr[4]:=DAddr4F;
        TSDAddr[5]:=DAddr5F;


        I4JobCodeF.Visible:=JBCostOn;
        I4JobAnalF.Visible:=JBCostOn;
        I4JobCodeL.Visible:=JBCostOn;
        I4JAnalL.Visible:=JBCostOn;

        TSPrevBtn.Visible:=BOn;
        TSFinBtn.Visible:=BOn;

        Label83.Caption:=CCVATName^;

      {$ENDIF}


      ItemPage.TabVisible:=BOff;

      PageControl1.ActivePage:=TeleInpFrm;

      ItemPage.HelpContext:=780;

      Self.ActiveControl:=ACFF;
    end;
  end;

  //PR: 07/04/2011 ABSEXCH-10664 Call page change event to kick off setting correct help context on form.
  PageControl1Change(PageControl1);


  // If this not a SQL compile, or if SQL is not in use, hide the Unit Price
  // panel, because we will be using the original Unit Price column instead.

{$IFDEF EXSQL}
  if not SQLUtils.UsingSQL then
{$ENDIF}
  begin
    //UnitPricePnl.Visible := False;
    lblUnitPrice.Visible := False;
    edtUnitPrice.Visible := False;

    // Resize the List Control Box so that it covers the area occupied by the
    // now-invisible Unit Price panel.
    //D1SBox.Height := D1SBox.Height + UnitPricePnl.Height;

    // Resize the List Control panels as well
    NewHeight := D1SBox.ClientHeight - PagePoint[3].Y;

    // We can't use the VisiList because it hasn't been created yet. If we
    // wait until it *is* created, the Unit Price panel is visible for a
    // moment before the panels are resized, which looks bad.
    D1RefPanel.Height     := NewHeight;
    TSQ1Panel.Height      := NewHeight;
    TSQ2Panel.Height      := NewHeight;
    TSQ3Panel.Height      := NewHeight;
    TSQ4Panel.Height      := NewHeight;
    TSQ5Panel.Height      := NewHeight;
    TSQ6Panel.Height      := NewHeight;
    TSDatePanel.Height    := NewHeight;
    TSGPPanel.Height      := NewHeight;
    UnitSPanel.Height     := NewHeight;
    D1ListBtnPanel.Height := NewHeight;
  end;

end;


{ ===== Function to Return Current View ===== }

Function TTeleSFrm.CK_Title(CKAnal     :  CKAnalType)  :  Str255;

Const
  CCDepTit  :  Array[BOff..BOn] of Str20 = ('Dp','Cc');


Var
  CKFilt   :  Str20;
  CKTitle  :  Str255;
  TmpBo    :  Boolean;


Begin
  CKTitle:=''; CKFilt:='';

  With CKAnal do
  Begin

    If (OrdMode In [0,2,3]) then
    Begin
      Case OrdMode of
        0  :  CKTitle:='Invoiced';
        2  :  CKTitle:='Ordered ';
        3  :  CKTitle:='Chosen  ';
      end;  {case..}

      If (Not IsTeleS) then
      Begin
        CKTitle:='Scale: '+CKTitle+' ';


        Case ScaleMode of

          1  :  CKTitle:=CKTitle+'Today -';
          2  :  CKTitle:=CKTitle+'This Wk';
          3  :  CKTitle:=CKTitle+'2 Weeks';
          4  :  CKTitle:=CKTitle+'Y-T-D -';
          else  CKTitle:=CKTitle+'This Pr';
        end; {Case..}
      end;
    end
    else
      CKTitle:='Outstanding Orders -';

    {$IFDEF SOP}
      If (Not EmptyKey(LocFilt,MLocKeyLen)) then
      Begin
        CKFilt:='.Loc : '+LocFilt;

      end;
    {$ENDIF}

    If (Syss.UseCCDep) and (Syss.PostCCNom) then
    For TmpBo :=BOff to BOn do
    Begin

      If (Not EmptyKeyS(RCCDep[TmpBo],ccKeyLen,BOff)) then
      Begin
        CKFilt:='.'+CCDepTit[TmpBo]+' : '+RCCDep[TmpBo];

      end;
    end;


  end;

  CK_Title:=CKTitle+CKFilt;
end;


procedure TTeleSFrm.SetCaption;

Var
  LevelStr  :  Str255;
  lTraderDesc: String;
Begin
  With ListCSAnal^,ExLocal do
  Begin
    If (LCust.CustCode<>CCode) then
      LGetMainRecPos(CustF,CCode);

    If (TeleSRun) then
      LevelStr:='TeleSales Entry for '
    else
      LevelStr:='Stock Analysis for ';

    //SSK 21/02/2018 2018 R1 ABSEXCH-19778: fix caption issue for Anonymised trader in Stock Analysis window
    if GDPROn and (LCust.acAnonymisationStatus = asAnonymised) then
      lTraderDesc := capAnonymised
    else
      lTraderDesc := LCust.Company;

    LevelStr:=LevelStr+dbFormatName(LCust.CustCode, lTraderDesc);


    If (TeleSRun) then
      With TeleSHed^,TeleSRec do
        LevelStr:=LevelStr+' '+Show_TreeCur(tcCurr,0)
    else
      LevelStr:=LevelStr+' '+Show_TreeCur(RCr,RTxCr);

  end; {with..}

  Caption:=LevelStr;

  UPBOMP.Caption:=CK_Title(ListCSAnal^);
end;


procedure TTeleSFrm.FormCreate(Sender: TObject);

Var
  n  :  Integer;
  NewHeight : Integer;

begin
  { CS: 14/04/2008 - Amendments for Form Resize routines }
  IsResizing := False;

  fFrmClosing:=BOff;
  fDoingClose:=BOff;

  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;
  FColorsChanged := False;

  PastFCreate:=BOff;

  JustCreated:=BOn;

  fFinishedOk:=BOff;

  // MH 25/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  SettlementDiscountPercentage := -1.0;

  {$IFDEF SOP}
    TTDHelper := TTTDTelesaleHelper.Create;
    TTDHelper.TransactionMode := tmAdd;
  {$ENDIF}

  {* When adjusting screen size, adjust MaxSize below as well .... *}

  InitSize.Y := PageControl1.Height + (2 * PageControl1.Top); //359;
  InitSize.X := PageControl1.Width + (2 * PageControl1.Left); //622;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=244;
  Width:=370;}

  BeenIn:=BOff;
  InHBeen:=BOff;

  ForceTSStore:=BOff;

  CurrChange:=BOff;

  New(ListCSAnal);

  FillChar(ListCSAnal^,Sizeof(ListCSAnal^),0);

  ListCSAnal^:=LocalCSAnal^;

  New(TeleSHed);

  Blank(TeleSHed^,Sizeof(TeleSHed^));

  OriginalTotal:=0.0;

  ExLocal.AssignFromGlobal(CustF);

  If NoXLogo then
     Image1.Visible:=BOff;

  LastPr:=0; LastYr:=0; LastMode:=0;
  DuringActive:=BOff;
  BeenAECnt:=0;
  ForceACEdit:=BOff;


  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  CuStkLine:=nil;

  {$IFDEF SOP}
    TSStkLine:=nil;
    TSDefFrm:=nil;
  {$ENDIF}


  DispStk:=nil;
  DrillStk:=nil;

  TeleSRun:=ListCSAnal^.IsTeleS;
  UpdateTotals:=BOff;
  ChkInProg:=0;

  PrimeButtons(BOff);

  // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  LoadCountryCodes (lstDeliveryCountry);
  // MH 26/01/2015 v7.1 ABSEXCH-16063: Modified country field to use long names
  lstDeliveryCountry.Items.Assign(lstDeliveryCountry.ItemsL);

  // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom labelling for address fields
  SetUDFCaptions([lblLine1, lblLine2, lblLine3, lblLine4, lblLine5], cfAddressLabels);

  If (TeleSRun) then
  Begin
    CreateSubMenu(PopUpMenu6,Scale1);
    PM5Cnt:=Pred(GetMenuItemCount(PopUpMenu6.Handle));
  end
  else
  Begin
    CreateSubMenu(PopUpMenu5,Scale1);
    PM5Cnt:=Pred(GetMenuItemCount(PopUpMenu5.Handle));

  end;

  CreateSubMenu(PopUpMenu4,View1);
  CreateSubMenu(PopUpMenu3,Filter1);
  CreateSubMenu(ListMenu,List1);
  CreateSubMenu(PopUpMenu7,Store1);


  PM4Cnt:=Pred(GetMenuItemCount(PopUpMenu4.Handle));
  PM3Cnt:=Pred(GetMenuItemCount(PopUpMenu3.Handle));
  PM2Cnt:=Pred(GetMenuItemCount(ListMenu.Handle));


  FormDesign;



  If (Not TeleSRun) then
  Begin
    SetCaption;

    FormBuildList(BOff);

    UpdateListView(BOff);

  end
  else
  With ExLocal,LCust do
  Begin
    {$IFDEF SOP}

      If (MatchOwner('CustRec3',Self.Owner)) then {* We are being called directly from the record *}
      Begin
        SetCaption;

        If (Get_TsRecord(CustCode,TeleSHed,BOn)) then
        Begin
          With TeleSHed^,TeleSRec do
          Begin
            tcTDate:=Today; tcDelDate:=Today;

            If (tcWasNew) then
              Set_TSFromCust(LCust,TeleSRec);

            CheckCLimit:=BOn;
          end
        end
        else
          TSNextBtn.Enabled:=BOff;


      end
      else {* We are being called by EparentU}
      Begin
        CheckCLimit:=BOff;

        CustSupp:=TradeCode[BOn]; {Force this to be of an account type so that the hook will accpet it as a valid account *}
      end;

      OutTeleSTot;
      OutTeleSImp;


    {$ENDIF}

    MaxSize.Y:=Height;
    MaxSize.X:=Width;

    If (MaxSize.Y<392) then
      MaxSize.Y:=392;

    If (MaxSize.X<630) then
      MaxSize.X:=630;

    PastFCreate:=BOn;
  end;

  // CJS 2013-10-07 - MRD1.1.22 - Consumer Support
  WasConsumer := False;
end;



procedure TTeleSFrm.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  {$IFDEF NOM}
    If (HistForm<>nil) then
    Begin
      HistForm.Free;
      HistForm:=nil;
    end;
  {$ENDIF}

  {$IFDEF SOP}
    FreeAndNIL(TTDHelper);
  {$ENDIF}

  ExLocal.Destroy;

  If (ListCSAnal<>nil) then
  Begin
    Dispose(ListCSAnal);
    ListCSAnal:=nil;
  end;

  If (TeleSHed<>nil) then
  Begin
    Dispose(TeleSHed);
    TeleSHed:=nil;
  end;

  If (CustBtnList<>nil) then
  Begin
    CustBtnList.Free;
    CustBtnList:=nil;
  end;


end;


Function TTeleSFrm.CheckListFinished  :  Boolean;

Var
  n       :  Byte;
  mbRet   :  Word;
Begin
  Result:=BOn;

  If (Assigned(MULCtrlO)) then
    Result:=Not MULCtrlO.ListStillBusy;

  If (Not Result) then
  Begin
    Set_BackThreadMVisible(BOn);

    mbRet:=MessageDlg('The list is still busy.'+#13+#13+
                      'Do you wish to interrupt the list so that you can exit?',mtConfirmation,[mbYes,mbNo],0);

    If (mBRet=mrYes) then
    Begin
      MULCtrlO.IRQSearch:=BOn;

      ShowMessage('Please wait a few seconds, then try closing again.');
    end;

    Set_BackThreadMVisible(BOff);

  end;
end;

procedure TTeleSFrm.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n         : Integer;


begin
  If (ChkInProg=0) then
  Begin
    If (Not fFrmClosing) then
    Begin
      fFrmClosing:=BOn;

      If (TotRec.Value<>OriginalTotal) and (TeleSRun) and (Not fFinishedOK) then {Warn closing}
        CanClose:=(CustomDlg(Application.MainForm,'Please Confirm','Closing TeleSales screen.',
                               'You are about to close this screen without finalising the order.'+#13+
                               'The order details will be kept safe under this account code so you'+
                               ' can retrieve it later.'+#13+#13+
                               'Please confirm you wish to close this screen?',
                               mtConfirmation,
                               [mbYes,mbNo])=mrOK);
      If (CanClose) then
      Begin
        CanClose:=CheckListFinished;

        Try
          For n:=0 to Pred(ComponentCount) do
          If (Components[n] is TScrollBox) then
          With TScrollBox(Components[n]) do
          Begin
            VertScrollBar.Position:=0;
            HorzScrollBar.Position:=0;
          end;

          VertScrollBar.Position:=0;
          HorzScrollBar.Position:=0;

          If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
            Store_FormCoord(Not SetDefault);

          {$IFDEF SOP}
            {* Update Totals *}

            //GS 01/06/11 ABSEXCH-11207: program attempts to update the customers telesales record, even when the
            //form is being used for stock analysis; added a condition to bypass the telesales update code when the form
            //is not being used for telesales

            if TeleSRun then
            Begin
              If (((TotRec.Value<>OriginalTotal) or (ForceTSStore)) and (UpdateTotals))
                or (TeleSHed^.TeleSRec.tcLastOpo<>EntryRec^.Login)
                or ((TeleSHed^.TeleSRec.tcLineCount=0) and  (TeleSHed^.TeleSRec.tcinProg)) then {* Only store it if it has some value *}
                Get_TSRecord(TeleSHed^.TeleSRec.tcCustCode,TeleSHed,BOff)
              else
                If (TeleSHed^.TeleSRec.tcLockAddr<>0) then
                  UnLockMultiSing(F[MLocF],MLocF,TeleSHed^.TeleSRec.tcLockAddr);
            end;

          {$ENDIF}

          Send_UpdateList(145+Ord(TeleSRun));
        Finally
          fFrmClosing:=BOff;
        end;
      end {If Warn about to close ok'd}
      else
        fFrmClosing:=BOff;
    end
    else
      CanClose:=BOff;
  end
  else
  Begin
    CanClose:=BOff;

    {$IFDEF POST}
      Set_BackThreadMVisible(BOn);

      ShowMessage('This form cannot be closed until check has finished.');

      Set_BackThreadMVisible(BOff);

    {$ENDIF}

  end;

end;

procedure TTeleSFrm.FormClose(Sender: TObject; var Action: TCloseAction);
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


procedure TTeleSFrm.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;
  NewHeight: Integer;


begin

  If (GotCoord) and (Not fDoingClose) then
  Begin
    UPBOMP.Left := ClientWidth - UPBOMP.Width - 5;

    PageControl1.Width:=ClientWidth-PagePoint[0].X;

    PageControl1.Height:=ClientHeight-PagePoint[0].Y;

    D1SBox.Width:=PageControl1.Width-PagePoint[1].X;
    D1SBox.Height:=PageControl1.Height-PagePoint[1].Y;

    D1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    D1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    D1BSBox.Height:=D1BtnPanel.Height-PagePoint[3].X;

    //D1ListBtnPanel.Left:=(D1BtnPanel.Left-D1ListBtnPanel.Width)-2;
    D1ListBtnPanel.Left := D1SBox.Left + D1SBox.Width + 2;
    D1ListBtnPanel.Height:=PageControl1.Height-PagePoint[4].Y;

    Bevel1.Width:=ClientWidth-PagePoint[5].X;

    TSFinBtn.Left:=D1BtnPanel.Left-PagePoint[6].X;
    TSPrevBtn.Left:=TSFinBtn.Left-PagePoint[6].Y;
    TSNextBtn.Left:=TSPrevBtn.Left;
    TSInpClsBtn.Left:=TSFinBtn.Left;

    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
        begin
          Height:=D1SBox.ClientHeight-PagePoint[3].Y;
          NewHeight := Height;
        end;

        { CS: 14/04/2008 - Amendments for Form Resize routines. Only updates
          the columns if the form is not being resized. This is to prevent the
          columns being constantly recalculated as the user sizes a form. }
        if not IsResizing then
          RefreshAllCols
        else
          { If the user is resizing the form, update the list column heights,
            but don't update the contents yet. }
          For n:=1 to Pred(Count) do
          Begin

            VisiRec:=List[n];

            try

              If (VisiRec<>Nil) then
                With VisiRec^ do
                Begin

                  With (PanelObj as TSBSPanel) do
                  Begin
                    Height:=NewHeight;
                  end;

                  ReSizeOneCol(n);

                end; {Width..}

            except;

            end;
          end; {Loop..}


      end;

      LockWindowUpDate(0);

      MULCtrlO.ReFresh_Buttons;

    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;




procedure TTeleSFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TTeleSFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TTeleSFrm.SetFormProperties;


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


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Caption+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);
        FColorsChanged := NeedCUpdate;

        If (BeenChange) and (not ResetDefaults) then
        Begin

          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1,2  :  MULCtrlO.ReColorCol(Font,Color,(n=2));

                3    :  MULCtrlO.ReColorBar(Font,Color);
              end; {Case..}

          MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
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

procedure TTeleSFrm.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TTeleSFrm.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  With CustBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end;

  {$IFDEF SOP}
    mnuApplyTTD.Checked := TTDHelper.ApplyTTD;
  {$ENDIF}
end;



procedure TTeleSFrm.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TTeleSFrm.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;



procedure TTeleSFrm.Clsd1BtnClick(Sender: TObject);

begin
  {$B-}
    If (Not Assigned(MULCtrlO)) or  (Not MULCtrlO.InListFind) then
  {$B+}
    Close;
end;


procedure TTeleSFrm.D1RefPanelMouseUp(Sender: TObject;
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

    BarPos:=D1SBox.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);

  end;

end;


procedure TTeleSFrm.D1RefLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
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


procedure TTeleSFrm.D1RefLabMouseDown(Sender: TObject;
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



procedure TTeleSFrm.Loaded;

Begin
  Inherited;


  {TeleSRun:=LocalCSAnal^.IsTeleS;

  If (TeleSRun) then
  Begin
    ActiveControl:=ACFF
  end;}

end;

procedure TTeleSFrm.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO))  then
    MULCtrlO.SetListFocus;

  If (JustCreated) and (TeleSRun) then
  Begin
    MDI_ForceParentBKGnd(BOn);

    If (TeleSRun) then
    Begin
      DuringActive:=BOn;

      If (ACFF.CanFocus) and (ACFF.Text='') then
      Begin
        ACFF.SetFocus;

        If (GetMaxColors(Application.MainForm.Canvas.Handle) <2) then
        Begin
          FieldNextFix(Handle,ActiveControl,CompF); {* Added so that qty is auto selected *}
          Inc(BeenAECnt);
        end
        else
          BeenAECnt:=3;

      end
      else
        If (I1TransDateF.CanFocus) and (ACFF.Text<>'') then
        Begin
          I1TransDateF.SetFocus;

          FieldNextFix(Handle,ActiveControl,CompF); {* Added so that qty is auto selected *}


        end;

      DuringActive:=BOff;

    end;



    JustCreated:=BOff;
  end;

  OpoLineHandle:=Self.Handle;

end;



procedure TTeleSFrm.MarginView1Click(Sender: TObject);
begin

  If (Sender is TMenuItem) then
  With TMenuItem(Sender) do
    ListCSAnal^.DispMode:=Tag;


  UpdateListView(BOn);


end;

procedure TTeleSFrm.AllStock1Click(Sender: TObject);
begin
  If (Sender is TMenuItem) then
  With TMenuItem(Sender) do
  Begin
    ListCSAnal^.ScanMode:=Tag;

    If (Tag=3) and (ListCSAnal^.OrdMode=3) then
      ListCSAnal^.OrdMode:=0;

  end;

  If (Assigned(MULCtrlO)) then
  Begin
    {MULCtrlO.ListCSAnal^:=Self.ListCSAnal^;}

    RefreshList(BOn,BOn);
  end;

  ManageMenus;
end;

procedure TTeleSFrm.OSOrders1Click(Sender: TObject);
begin
  If (Sender is TMenuItem) then
  With TMenuItem(Sender) do
    ListCSAnal^.OrdMode:=Tag;

  With MULCtrlO do
  If (Self.ListCSAnal^.OrdMode In [1,3]) then
  Begin
    Filter[3,1]:=NdxWeight;

  end
  else
    Filter[3,1]:=#0;


  {UpdateListView(BOn);}

  With MULCtrlO do
  Begin
    {ListCSAnal^:=Self.ListCSAnal^;}

    InitPage;
  end;

  ManageMenus;

end;

procedure TTeleSFrm.TPr1Click(Sender: TObject);
begin
  If (Sender is TMenuItem) then
  With TMenuItem(Sender) do
    ListCSAnal^.ScaleMode:=Tag;

  UpdateListView(BOn);

end;


procedure TTeleSFrm.Currency1Click(Sender: TObject);
{$IFDEF MC_On}

  Var
    LedCur  :  TLCForm;

    mrRet   :  Word;

    IsTxl   :  Boolean;

    UseCr   :  Byte;
{$ENDIF}

begin
  If  (Not MULCtrlO.InListFind) then
  Begin
  {$IFDEF MC_On}

    LedCur:=TLCForm.Create(Self);

    try

      With ListCSAnal^,MULCtrlO,VisiList do
      Begin
        IsTxl:=(Sender=TxLate1) or (Sender=TxD1Btn);

        If (IsTxl) then
          UseCr:=RTxCr
        else
          UseCr:=RCr;

        mrRet:=LedCur.InitAS(UseCr,Succ(Ord(IsTxl)),IdPanel(0,BOff).Color,IdPanel(0,BOff).Font);

        If (mrRet=mrOk) then
        Begin
          If (IsTxl) then
            RTxCr:=UseCr
          else
            RCr:=UseCr;

          UpdateListView(BOn);

        end;
      end;

    finally

      LedCur.Free;

    end; {try..}

  {$ENDIF}
  end;
end;



procedure TTeleSFrm.Prices1Click(Sender: TObject);

begin
  If  (Not MULCtrlO.InListFind) then
  With ExLocal,MulCtrlO.ListCSAnal^ do
    SendToObjectStkEnq(LStock.StockCode,LocFilt,CCode,RCr,-1,Ord(Sender<>Nil));
end;

procedure TTeleSFrm.Loc1Click(Sender: TObject);

Var
  InpOk,
  FoundOk  :  Boolean;


  OCode,
  SICode   :  String;

  NewLoc   :  Str10;


Begin

  With ListCSAnal^ do
  Begin

    SICode:=LocFilt;
    OCode:=SICode;
    NewLoc:='';
    FoundOK := False;
    Repeat

      InpOk:=InputQuery('Location Filter','Enter the Location Code you wish to filter by.',SICode);

      {$IFDEF SOP}
        If (InpOk) then
          If (Not EmptyKey(SICode,LocKeyLen)) then
            FoundOk:=GetMLoc(Self,SICode,NewLoc,'',0)
          else
          Begin
            NewLoc:='';
            FoundOk:=BOn;
          end;
      {$ENDIF}

    Until (FoundOk) or (Not InpOk);

    If (FoundOk) and (SICode<>OCode) and (Assigned(MULCtrlO)) then
    With MULCtrlO do
    Begin
      LocFilt:=NewLoc;
      Blank(RCCDep,Sizeof(RCCDep));

      UpdateListView(BOn);

      
    end;
  end; {with..}

end;




procedure TTeleSFrm.CC1Click(Sender: TObject);
Var
  CCNomMode,
  InpOk,
  FoundOk  :  Boolean;
  FoundStr :  Str20;
  OCode,
  SICode   :  String;

Begin
  CCNomMode:=(TMenuItem(Sender).Tag=1);

  With ListCSAnal^ do
  Begin
    SICode:=RCCDep[CCNomMode];
    OCode:=SICode;
    FoundOK := False;
    Repeat

      InpOk:=InputQuery(CostCtrRTitle[CCNomMode]+' Filter','Enter the '+CostCtrRTitle[CCNomMode]+' you wish to filter by. (Blank for none)',SICode);

      {$IFDEF PF_On}
        If (InpOk) then
          If (Not EmptyKey(SICode,LocKeyLen)) then
          Begin
            FoundOk:=GetCCDep(Self,SICode,FoundStr,CCNomMode,0);

            If (FoundOk) then
             RCCDep[CCNomMode]:=FoundStr;
          end
          else
          Begin
            RCCDep[CCNomMode]:='';
            FoundOk:=BOn;
          end;
      {$ENDIF}

    Until (FoundOk) or (Not InpOk);

    If (FoundOk) and (SICode<>OCode) and (Assigned(MULCtrlO)) then
    With MULCtrlO do
    Begin

      Blank(LocFilt,Sizeof(LocFilt));
      IsCCDep:=CCNomMode;

      UpdateListView(BOn);

    end;
  end; {With..}

end;



procedure TTeleSFrm.AltStkCode1Click(Sender: TObject);
begin
  With ListCSAnal^ do
    OwnPNo:=Not OwnPNo;

  UpdateListView(BOn);

end;

procedure TTeleSFrm.Find1Click(Sender: TObject);
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
        Pass2Parent:=(ListCSAnal^.ScanMode=1);
        ShowSome:={(LParam=1);}BOn;

        If (ShowSome) then
          DontHide:=[tabFindStock];
        //PR: 04/12/2013 ABSEXCH-14824
        Ctrl_GlobalFind(Self,ReturnCtrl,tabFindStock);

      end;
    end; {If in list find..}

  {$ENDIF}
end;



procedure TTeleSFrm.LstD1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  If (Not MULCtrlO.InListFind) then
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    With TWinControl(Sender) do
      ListPoint:=ClientToScreen(ListPoint);

    ListMenu.PopUp(ListPoint.X,ListPoint.Y);
  end;
end;



procedure TTeleSFrm.ViewD1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  If (Not MULCtrlO.InListFind) then
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    With TWinControl(Sender) do
      ListPoint:=ClientToScreen(ListPoint);

    PopUpMenu4.PopUp(ListPoint.X,ListPoint.Y);
  end;
end;



procedure TTeleSFrm.FilterD1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  If (Not MULCtrlO.InListFind) then
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    With TWinControl(Sender) do
      ListPoint:=ClientToScreen(ListPoint);

    PopUpMenu3.PopUp(ListPoint.X,ListPoint.Y);
  end;
end;


procedure TTeleSFrm.ScleD1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  If (Not MULCtrlO.InListFind) then
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    With TWinControl(Sender) do
      ListPoint:=ClientToScreen(ListPoint);

    If (TeleSRun) then
      PopUpMenu6.PopUp(ListPoint.X,ListPoint.Y)
    else
      PopUpMenu5.PopUp(ListPoint.X,ListPoint.Y);
  end;
end;


procedure TTeleSFrm.StreD1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  If (Not MULCtrlO.InListFind) then
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    With TWinControl(Sender) do
      ListPoint:=ClientToScreen(ListPoint);

    PopUpMenu7.PopUp(ListPoint.X,ListPoint.Y);
  end;
end;


procedure TTeleSFrm.Display_CSRec(Mode  :  Byte);

Var
  WasNew  :  Boolean;

  Begin
    WasNew:=BOff;


    If (CuStkLine=nil) then
    Begin
      CuStkLine:=TCuStkT1.Create(Self);

      WasNew:=BOn;

    end;

    Try


     With CuStkLine do
     Begin

       ExLocal.AssignFromGlobal(MLocF);
       ExLocal.LStock:=Self.ExLocal.LStock;
       ExLocal.LCust:=Self.ExLocal.LCust;

       StkMode:=ListCSAnal^.ScanMode;

       WindowState:=wsNormal;

       If (Mode In [1..3]) then
       Begin

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine((Mode=2))
                     else
                       Show;
              3  :  If (Not ExLocal.InAddEdit) then
                       DeleteBOMLine(MLocF,MLK);
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except

     CuStkLine.Free;
     CuStkLine:=nil;

    end;

  end;


{$IFDEF SOP}

  procedure TTeleSFrm.Display_TSRec(Mode  :  Byte);

  Const
    Fnum      =  MLocF;
    Keypath2  =  MLSecK;


  Var
    WasNew  :  Boolean;
    KeyChk  :  Str255;


    Begin
      WasNew:=BOff;

      With ExLocal, ListCSAnal^, LMLocCtrl^.CuStkRec do
      Begin
        If (ScanMode=2) then
        Begin
          KeyChk:=PartCCKey(MatchTCode,MatchSCode)+Full_CuStkKey(LCust.CustCode,LStock.StockCode);

          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath2,KeyChk);

          If (Not StatusOk) then
          Begin
            LResetRec(Fnum);

            csStockCode:=LStock.StockCode;
            csStkFolio:=LStock.StockFolio;
            MLocCtrl^:=LMLocCtrl^;

            If (Mode=2) then
              Mode:=1;
          end;
        end;
      end;


      If (TSStkLine=nil) then
      Begin
        TSStkLine:=TCuStkT2.Create(Self);

        WasNew:=BOn;

      end;

      Try
        // MH 22/02/2010 v6.3 ABSEXCH-9421: Added check on whether the line dialog is already in use as
        // dropping the records in was causing strange behaviour
       If (Not TSStkLine.ExLocal.InAddEdit) Then
       Begin
         With TSStkLine do
         Begin

           ExLocal.AssignFromGlobal(MLocF);
           ExLocal.LStock:=Self.ExLocal.LStock;
           ExLocal.LCust:=Self.ExLocal.LCust;

           SetDescRO;

           TeleSHed:=@Self.TeleSHed^;

           StkMode:=ListCSAnal^.ScanMode;

           WindowState:=wsNormal;

           Case Mode of
             1  :  If (t2SCodeF.CanFocus) then
                     t2ScodeF.SetFocus;
             2  :  Begin
                     If (t2Qty.CanFocus) then
                       t2Qty.SetFocus;

                     FieldNextFix(Handle,ActiveControl,T2LTF); {* Added so that qty is auto selected *}

                     {* Added so that the onexit event of T2Qty is ignored until after the tab out! *}
                   
                     PostMessage(TSSTkLine.Handle,WM_CustGetRec,4,0);
                   end;
           end; {case..}


           If (Mode In [1..3]) then
           Begin

             Case Mode of

               1..2  :   If (Not ExLocal.InAddEdit) then
                           EditLine((Mode=2))
                         else
                           Show;
                  3  :  If (Not ExLocal.InAddEdit) then
                           DeleteBOMLine(MLocF,MLK);
                         else
                           Show;

             end; {Case..}

           end;



         end; {With..}
       End; // If (Not TSStkLine.ExLocal.InAddEdit)
      except

       TSStkLine.Free;
       TSStkLine:=nil;

      end;

    end;


    procedure TTeleSFrm.Display_TSDefFrm;


    Var
      WasNew  :  Boolean;


      Begin
        WasNew:=BOff;


        If (TSDefFrm=nil) then
        Begin
          TSDefFrm:=TCuStkT4.Create(Self);

          WasNew:=BOn;

        end;

        Try


         With TSDefFrm do
         Begin
           TeleSHed^:=Self.TeleSHed^;

           OutId;

           WindowState:=wsNormal;


         end; {With..}


        except

         TSDefFrm.Free;
         TSDefFrm:=nil;

        end;

      end;

{$ENDIF}

procedure TTeleSFrm.Display_Rec(Mode  :  Byte);

Begin
  Try
    If (Not TeleSRun) then
      Display_CSRec(Mode)
    {$IFDEF SOP}
    else
      Display_TSRec(Mode)

    {$ENDIF}
  finally

  end; {try..}

end;

procedure TTeleSFrm.AddD1BtnClick(Sender: TObject);
begin
  {$B-}
  If (Assigned(MULCtrlO)) and ((MULCtrlO.ValidLine) or (TComponent(Sender).Tag=1)) and (Not MULCtrlO.InListFind) then

  {$B+}

  With ListCSAnal^ do
  Begin
    Display_Rec(TComponent(Sender).Tag);

  end;


end;

procedure TTeleSFrm.StkRD1BtnClick(Sender: TObject);
begin
  {$B-}
  If (Assigned(MULCtrlO)) and (MULCtrlO.ValidLine)  and (Not MULCtrlO.InListFind) then
  {$B+}
  Begin
    If (DispStk=nil) then
      DispStk:=TFStkDisplay.Create(Self);

    try

      ExLocal.AssignToGlobal(StockF);

      With DispStk do

        Display_Account(0);

    except

      DispStk.Free;
      DispStk:=nil;
    end;
  end;
end;



procedure TTeleSFrm.DrillToStkLedger(NPr,NYr,DMode  :  Byte);

Var
  FMode  :  Byte;

begin
  FMode := 0;
  If (DrillStk=nil) then
    DrillStk:=TFStkDisplay.Create(Self);

  try

    ExLocal.AssignToGlobal(StockF);

    With DrillStk,ListCSAnal^  do
    Begin
      CuStkCtrlRec:=ListCSAnal^;

      DDPr:=NPr; DDYr:=NYr;

      If (DMode=1) then
        FMode:=20
      else
        Case OrdMode of

          0,3
             :  FMode:=51;
             
          1  :  FMode:=41;
          2  :  FMode:=45;

        end; {Case..}


      Display_Account(FMode);

      LastPr:=NPr; LastYr:=NYr; LastMode:=DMode;

    end;

  except

    DrillStk.Free;
    DrillStk:=nil;
  end;
end;


procedure TTeleSFrm.Display_History(ChangeFocus :  Boolean);

Var
  NomNHCtrl  :  TNHCtrlRec;

  FoundCode  :  Str20;

  fPr,fYr    :  Byte;

Begin
  {$IFDEF NOM}

  {$B-}

    If (Assigned(MulCtrlO)) and (MulCtrlO.SetCSAnal(BOn)) then
    Begin

  {$B+}

      With NomNHCtrl,MulCtrlO,ListCSAnal^ do
      Begin
        FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

        NHMode:=88;
        NBMode:=12;

        NHCr:=RCr;
        NHTxCr:=RTxCr;
        NHPr:=GetLocalPr(0).CPr;
        NHYr:=GetLocalPr(0).CYr;

        NHNomCode:=SFolio;

        NHLocCode:=LocFilt;
        NHCuCode:=CCode;
        NHCCMode:=IsCCDep;
        NHCDCode:=RCCDep[IsCCDep];

        NHCCode:=Calc_CStkKeyHist(MulCtrlO.ListCSAnal^);


        NHKeyLen:=NHCodeLen+2;

        ExLocal.AssignToGlobal(StockF);
        ExLocal.AssignToGlobal(CustF);

        Begin
          Find_FirstHist(CuStkHistCode,NomNHCtrl,fPr,fYr);
          MainK:=FullNHistKey(CuStkHistCode,NHCCode,NHCr,fYr,fPr);
          AltMainK:=FullNHistKey(CuStkHistCode,NHCCode,NHCr,0,0);
        end;

        Set_NHFormMode(NomNHCtrl);

      end;

      If (Not Assigned(HistForm)) then
      Begin

        HistForm:=THistWin.Create(Self);

      end;

      Try

       With HistForm do
       Begin

         WindowState:=wsNormal;


         If (ChangeFocus) then
           Show;


         ShowLink(BOn,BOff);


       end; {With..}


      except

       HistForm.Free;
       HistForm:=nil;

      end; {try..}
    end;

  {$ENDIF}
end;





procedure TTeleSFrm.HistD1BtnClick(Sender: TObject);
begin
  If  (Not MULCtrlO.InListFind) then
    Display_History(BOff);
end;

procedure TTeleSFrm.ChkD1BtnClick(Sender: TObject);

Var
  mbRet  :  Word;

begin
  If  (Not MULCtrlO.InListFind) then
  Begin
  {$IFDEF Post}


    {$IFDEF SOP}
      If (TeleSRun) then
      Begin
        Set_BackThreadMVisible(BOn);

        mbRet:=MessageDlg('Please confirm you wish to recalculate the TeleSales total for this account',mtConfirmation,[mbYes,mbNo],0);

        Set_BackThreadMVisible(BOff);

      If (mbRet=mrYes) then
      Begin
        ChkInProg:=1;

        SetButtons(BOff);

        AddRecalcTS2Thread(Self,TeleSHed,0);

      end;
      end
      else
    {$ENDIF}

    Begin
      Set_BackThreadMVisible(BOn);

      mbRet:=MessageDlg('Please confirm you wish to recalculate the stock analysis for this account',mtConfirmation,[mbYes,mbNo],0);

      Set_BackThreadMVisible(BOff);

      If (mbRet=mrYes) then
        AddCheckCust2Thread(Self,Exlocal.LCust.CustCode,BOff,BOff,BOn);
    end;

  {$ENDIF}
  end;
end;


{$IFDEF SOP}


  procedure TTeleSFrm.SetGenStatus;


  Begin
    With TeleSHed^.TeleSRec do
    Begin
      BROrd.Enabled:=(tcNetTotal=0.0) or (Not CheckNegStk);
      BRInv.Enabled:=BROrd.Enabled;
      BRQuo.Enabled:=BROrd.Enabled;
    end; {With..}
  end;


  procedure TTeleSFrm.OutTeleSImp;

  Var
    n  :  Byte;

  Begin

    With TeleSHed^.TeleSRec, EXLocal,LCust do
    Begin

      If (CustCode<>tcCustCode) then
        If LGetMainRecPos(CustF,tcCustCode) then;

      // CJS 2013-10-03 - MRD1.1.22 - Consumer Support
      if IsConsumer(LCust) then
        ACFF.Text := LCust.acLongAcCode
      else
      ACFF.Text:=tcCustCode;
      LinkCF.Text:=ACFF.Text;

      CompF.Text:=LCust.Company;

      {$IFDEF MC_On}
        If (tcCurr>0) then
          CurrF.ItemIndex:=Pred(tcCurr);

        I1ExRateF.Value:=tcCXRate[BOn];
      {$ENDIF}


      BROrd.Checked:=(TcGenMode=0);
      BRInv.Checked:=(TcGenMode=1);
      BRQuo.Checked:=(TcGenMode=2);


      If (tcTDate>=Today) then
        I1TransDateF.DateValue:=tcTDate
      else
        I1TransDateF.DateValue:=Today;

      If (tcDelDate>=Today) then
        I1DueDateF.DateValue:=tcDelDate
      else
        I1DueDateF.DateValue:=Today;



      I1LYRef.Text:=tcLYRef;
      I1YRef.Text:=tcYourRef;

      Id3CCF.Text:=tcCCDep[BOn];
      Id3DepF.Text:=tcCCDep[BOff];

      I1LocF.Text:=tcLocCode;
      I4JobCodeF.Text:=tcJobCode;
      I4JobAnalF.Text:=tcJACode;

      For n:=Low(TSDAddr) to High(TSDAddr) do
        TSDAddr[n].Text:=tcDAddr[n];

      { CJS 2013-08-08 - MRD2.5 - Delivery PostCode }
      PostCodeTxt.Text := tcDeliveryPostCode;

      // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
      If ValidCountryCode(ifCountry2, tcDeliveryCountry) Then
        lstDeliveryCountry.ItemIndex := ISO3166CountryCodes.IndexOf(ifCountry2, tcDeliveryCountry)
      Else
        lstDeliveryCountry.ItemIndex := -1;
    end;


  end;


  procedure TTeleSFrm.Form2TeleS;

  Var
    n  :  Byte;

  Begin
    With TeleSHed^.TeleSRec do
    Begin
      // CJS 2013-10-03 - MRD1.1.22 - Consumer Support
      if IsConsumer(ExLocal.LCust) then
        tcCustCode := FullCustCode(ExLocal.LCust.CustCode)
      else
        tcCustCode:=FullCustCode(ACFF.Text);

      {$IFDEF MC_On}

        tcCurr:=Succ(CurrF.ItemIndex);

        tcCXRate[BOn]:=I1ExRateF.Value;

      {$ENDIF}


      tcGenMode:=(1*Ord(BRInv.Checked))+(2*Ord(BRQuo.Checked));

      tcTDate:=I1TransDateF.DateValue;

      tcDelDate:=I1DueDateF.DateValue;

      tcLYRef:=I1LYRef.Text;
      tcYourRef:=I1YRef.Text;

      tcCCDep[BOn]:=Id3CCF.Text;
      tcCCDep[BOff]:=Id3DepF.Text;

      tcLocCode:=I1LocF.Text;
      tcJobCode:=I4JobCodeF.Text;
      tcJACode:=I4JobAnalF.Text;


      For n:=Low(TSDAddr) to High(TSDAddr) do
        tcDAddr[n]:=TSDAddr[n].Text;

      { CJS 2013-08-08 - MRD2.5 - Delivery PostCode }
      tcDeliveryPostCode := PostCodeTxt.Text;

      // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
      // MH 26/01/2015 v7.1 ABSEXCH-16063: Modified country fields to use long names
      //tcDeliveryCountry := lstDeliveryCountry.Text;
      If (lstDeliveryCountry.ItemIndex >= 0) Then
        tcDeliveryCountry := ISO3166CountryCodes.ccCountryDetails[lstDeliveryCountry.ItemIndex].cdCountryCode2
      Else
        tcDeliveryCountry := '  ';
    end; {with..}
  end;


  Function TTeleSFrm.CheckTSCompleted(Edit  :  Boolean)  : Boolean;

  Const
    NofMsgs      =  13;

  Type
    PossMsgType  = Array[1..NofMsgs] of Str80;

  Var
    PossMsg  :  ^PossMsgType;

    Test     :  Byte;

    mbRet    :  Word;

    FoundCode2
             :  Str10;

    FoundCode:  Str20;

    FoundLong:  LongInt;


  Begin
    New(PossMsg);

    FillChar(PossMsg^,Sizeof(PossMsg^),0);

    PossMsg^[1]:='That Account Code is not valid.';
    PossMsg^[2]:='The default Cost Centre Code is not valid.';
    PossMsg^[3]:='The default Department Code is not valid.';
    PossMsg^[4]:='The default Currency is not valid.';
    PossMsg^[5]:='The default G/L Control Code is not valid.';
    PossMsg^[6]:='The default delivery date is not valid.';
    PossMsg^[7]:='The default Location Code is not valid.';
    PossMsg^[8]:='The default Job Costing Code is not valid.';
    PossMsg^[9]:='An Exchange Rate of zero is not valid.';
    PossMsg^[10]:='The default date is not valid.';
    PossMsg^[11]:='The default Job Costing Analysis Code is not valid.';
    PossMsg^[12]:='For local currency the exchange rate must be 1.0';
    PossMsg^[13]:='The Delivery Address Country is not valid';



    Test:=1;

    Result:=BOn;


    While (Test<=NofMsgs) and (Result) do
    With ExLocal,TeleSHed^.TeleSRec  do
    Begin
      {$B-}

      Case Test of

        1  :  Begin
                Result:=(Not EmptyKey(tcCustCode,CustKeyLen));

                If (Result) then
                  Result:=(CheckRecExsists(tcCustCode,CustF,CustCodeK));

                If (Result) then
                  Result:=Cust.CustSupp=SetFilterFromDoc(SIN);

              end;

              //AP-27-06-2017- ABSEXCH-18682 - Error even when System is not using CC/Dep
        2  :  if (Syss.UseCCDep) then
                Result:=(EmptyKeyS(tcCCDep[BOn],CCKeyLen,BOff) or GetCCDep(Self,tcCCDep[BOn],FoundCode,BOn,-1));

              //AP-27-06-2017- ABSEXCH-18682 - Error even when System is not using CC/Dep
        3  :  if (Syss.UseCCDep) then
                Result:=(EmptyKeyS(tcCCDep[BOff],CCKeyLen,BOff) or GetCCDep(Self,tcCCDep[BOff],FoundCode,BOff,-1));

      {$IFDEF MC_On}
        4  :
                 Result:=(TcCurr In [Succ(CurStart)..CurrencyType]);

        9  :     Result:=(tcCXRate[BOn]<>0);

        12 :     Result:=((TcCurr=1) and (tcCXRate[BOn]=1.0)) or (TcCurr>1);

      {$ENDIF}

        5  :   Result:=(tcCtrlCode=0) or (GetNom(Self,Form_Int(tcCtrlCode,0),FoundLong,-1));

        6  :   Result:=(tcDelDate<>'');

        7  :   Result:=(Not Syss.UseMLoc) or ((Not EmptyKey(tcLocCode,MLocKeyLen)) and (GetMLoc(Self,tcLocCode,FoundCode2,'',-1)));

        8  :   Result:=(EmptyKey(tcJobCode,JobCodeLen)) or (GetJob(Self,tcJobCode,FoundCode,-1));

        10 :   Result:=(tcTDate<>'');

        //11 :  Result:=(EmptyKey(tcJobCode,JobCodeLen)) or (GetJobMisc(Self,tcJACode,FoundCode,2,-1));

        // MH 21/12/2010 v6.6: Modified Job Code/Analysis Code validation to require both blank or both valid
        11 :  Result:= (EmptyKey(tcJobCode,JobCodeLen) And EmptyKey(tcJACode,JobCodeLen))
                       Or
                       ((Not EmptyKey(tcJobCode,JobCodeLen)) And GetJobMisc(Self,tcJACode,FoundCode,2,-1));

        // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
        13 :  Begin // Delivery Address Country
               // Validate Delivery Postcode if any part of the delivery address is set
               If (Trim(tcDAddr[1]) <> '') Or (Trim(tcDAddr[2]) <> '') Or (Trim(tcDAddr[3]) <> '') Or
                  (Trim(tcDAddr[4]) <> '') Or (Trim(tcDAddr[5]) <> '') Or (Trim(tcDeliveryPostCode) <> '') Then
                 Result := (Trim(tcDeliveryCountry) <> '') And ValidCountryCode (ifCountry2, tcDeliveryCountry)
               Else
                 Result := True;
             End;
      end;{Case..}

      {$B+}

      If (Result) then
        Inc(Test);

    end; {While..}

    If (Not Result) then
      mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

    Dispose(PossMsg);

  end; {Func..}


  procedure TTeleSFrm.BeginTeleSales(CP  :  Boolean);
  var
    n  :  Integer;
    NewHeight : Integer;

    // MH 25/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
	SettlementDiscountRate : Double;
    sKey, sKeyChk : Str255;
    LOK, Locked : Boolean;
    iStatus, LAddr : Integer;

    //------------------------------

	// MH 25/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    Function ResetTelesalesLineVAT (TeleHeader : TeleCustType) : Double;
    Var
      LocalID : IDetail;
      sKey, sKeyChk : Str255;
      iStatus : Integer;
    Begin // ResetTelesalesLineVAT
      Result := 0.0;

      // Save the current position in MLocStk
      With TBtrieveSavePosition.Create Do
      Begin
        Try
          // Save the current position in the file for the current key
          SaveFilePosition (MLocF, GetPosKey);
          SaveDataBlock (MLocCtrl, SizeOf(MLocCtrl^));

          //------------------------------

          sKey := PartCCKey(MatchTCode, MatchSCode) + FullCustCode(TeleHeader.tcCustCode);
          sKeyChk := sKey;
          iStatus := Find_Rec(B_GetGEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, sKey);
          While (iStatus = 0) And (CheckKey(sKeyChk, sKey, Length(sKeyChk), True)) Do
          Begin
            // Check to see if the line has been set
            If MLocCtrl^.CuStkRec.csEntered Then
            Begin
              // Create a fake transaction line from the Telesales Line to allow VAT to be calculated
              TL2ID(LocalID, MLocCtrl^.CuStkRec);
              CalcVat(LocalID, TeleHeader.tcSetDisc);
              MLocCtrl^.CuStkRec.csVAT := LocalId.VAT;

              // Update the running total of VAT for the Telesales Header
              Result := Round_Up(Result + MLocCtrl^.CuStkRec.csVAT, 2);

              // Update the Telesales Line
              iStatus := Put_Rec(F[MLocF], MLocF, RecPtr[MLocF]^, MLK);
              Report_BError(MLocF, iStatus);
            End; // If MLocCtrl^.CuStkRec.csEntered

            iStatus := Find_Rec(B_GetNext, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, sKey);
          End; // While (iStatus = 0) And (CheckKey(sKeyChk, sKey, Length(sKeyChk), True))

          //------------------------------

          // Restore position in file
          RestoreDataBlock (MLocCtrl);
          RestoreSavedPosition;
        Finally
          Free;
        End; // Try..Finally
      End; // With TBtrieveSavePosition.Create
    End; // ResetTelesalesLineVAT

    //------------------------------

    // CJS 2016-01-20 - ABSEXCH-17104 - Intrastat - 4.8 - Telesales
    function ValidateIntrastat: Boolean;
    begin
      Result := ShowIntrastatDetails(True)
    end;

  Begin
    Form2TeleS;

    // CJS 2016-01-20 - ABSEXCH-17104 - Intrastat - 4.8 - Telesales
    // If Intrastat is being used for this Trader, validate it before allowing
    // the user to continue.
    // CJS 2016-01-25 - ABSEXCH-17183 – Suppress Intrastat validation if Intrastat is disabled
    // Split the check into two lines (short-circuit boolean evaluation is
    // off at this point, so it was calling ValidateIntrastat even if the
    // settings button was not visible).
    if btnIntrastatSettings.Visible then
      if not ValidateIntrastat then
        Exit;

    If (CheckTSCompleted(BOff)) then
    Begin
      // MH 25/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015

      // Work out what settlement discount to apply
      If SettlementDiscountSupportedForDate (TeleSHed^.TeleSRec.tcTDate) Then
        // Rate from Customer Record - convert to percentage
        SettlementDiscountRate := Pcnt(SettlementDiscountPercentage)
      Else
        SettlementDiscountRate := 0.0;

      // Work out if that differs from what is present in the Telesales Header record
      If (SettlementDiscountRate <> TeleSHed^.TeleSRec.tcSetDisc) Then
      Begin
        // Update the Telesales Header record - we are changing the VAT on the lines
        // permanently so we will also need to update the header in the DB
        TeleSHed^.TeleSRec.tcSetDisc := SettlementDiscountRate;

        // Check to see if this is a new telesales session or a resumption of a previous session
        // which may have details set
        If (Not TeleSHed^.TeleSRec.tcWasNew) Then
        Begin
          // Get and lock the Telesales Header record
          sKey := PartCCKey(MatchTCode, PostLCode) + TeleSHed^.TeleSRec.tcCode1;
          sKeyChk := sKey;
          iStatus := Find_Rec(B_GetGEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, sKey);
          If (iStatus = 0) And CheckKey(sKeyChk, sKey, Length(sKeyChk), True) Then
          Begin
            Locked := False;
            LOk := GetMultiRecAddr(B_GetDirect, B_MultLock, sKey, MLK, MLocF, BOff, Locked, LAddr);
            If LOK And Locked Then
            Begin
              // Copy in the details from the wizard
              MLocCtrl^.TeleSRec := TeleSHed^.TeleSRec;

              // Run through the Telesales Lines and recalc the VAT on any existing picked items
              // to remove Settlement Discount
              MLocCtrl^.TeleSRec.tcVATTotal := ResetTelesalesLineVAT (MLocCtrl^.TeleSRec);

              // Update the Telesales Header record in the DB
              iStatus := Put_Rec(F[MLocF], MLocF, RecPtr[MLocF]^, MLK);
              Report_BError(MLocF, iStatus);
              UnLockMultiSing(F[MLocF], MLocF, LAddr);

              // Update the local copy so it is in sync with the DB
              TeleSHed^.TeleSRec := MLocCtrl^.TeleSRec;
            End; // If LOK And Locked
          End; // If (iStatus = 0) And CheckKey(sKeyChk, sKey, Length(sKeyChk), True)
        End; // If (Not TeleSHed^.TeleSRec.tcWasNew)
      End; // If (SettlementDiscountRate <> TeleSHed^.TeleSRec.tcSetDisc)

      SetGenStatus;

      If (CP) then
      Begin
        ItemPage.TabVisible:=BOn;

        PageControl1.ActivePage:=ItemPage;

        UpdateTotals:=BOn;
        UPBOMP.Visible:=BOn;
        OutTeleSTot;

      end;

      {* If TeleSMode, then get TeleS Values, once ready to display list *}

       ListCSAnal^.CCode:=TeleSHed^.TeleSRec.tcCustCode;
       ListCSAnal^.IsaC:=BOn;

       ListCSAnal^.ScaleMode:=TeleSHed^.TeleSRec.tcScaleMode;
       ListCSAnal^.OrdMode:=TeleSHed^.TeleSRec.tcOrdMode;

       If (ListCSAnal^.OrdMode=2) and (ListCSAnal^.ScaleMode=0) then
         ListCSAnal^.ScaleMode:=1;



      If (Not Assigned(MULCtrlO)) then
      Begin
        {Preserve original total so we only prompt on close if a change has ocurred}
        OriginalTotal:=TotRec.Value;

        ListCSAnal^.DispMode:=2;

        ListCSAnal^.ScanMode:=1;

        FormBuildList(BOff);

        UpdateListView(BOff);

        MULCtrlO.SetListFocus;

      end
      else
      Begin
        SetCaption;

        RefreshList(BOn,BOff);

      end;


    end;
  end;



{$ENDIF}


procedure TTeleSFrm.TSNextBtnClick(Sender: TObject);
begin
  {$IFDEF SOP}
    // MH 21/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
    //                                   fields which processes the text and updates the value
    If (ActiveControl <> TSNextBtn) Then
      // Move focus to OK button to force any OnExit validation to occur
      TSNextBtn.SetFocus;

    // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
    If (ActiveControl = TSNextBtn) Then
      BeginTeleSales(BOn);
  {$ENDIF}
  //PR: 07/04/2011 ABSEXCH-10664 Call page change event to kick off setting correct help context on form.
  PageControl1Change(PageControl1);

end;

procedure TTeleSFrm.TSPrevBtnClick(Sender: TObject);
begin
  {$IFDEF SOP}
    {$B-}
    If (Assigned(MULCtrlO)) and (Not MULCtrlO.InListFind) then
    {$B+}
    Begin
      SetGenStatus;

      PageControl1.ActivePage:=TeleInpFrm;
      MDI_ForceParentBKGnd(BOn);
    end;
    //PR: 08/04/2011 ABSEXCH-10664 Call page change event to kick off setting correct help context on form.
    PageControl1Change(PageControl1);
  {$ENDIF}
end;


procedure TTeleSFrm.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);

Var
  NewIndex  :  Integer;

begin
  NewIndex:=pcLivePage(Sender);


  {$IFDEF SOP}
    {$B-}

    AllowChange:=(NewIndex=1) or CheckTSCompleted(BOff);


    {$B+}

    If (NewIndex=1) and AllowChange then
      MDI_ForceParentBKGnd(BOn);


  {$ELSE}

    AllowChange:=BOff;

  {$ENDIF}

end;

procedure TTeleSFrm.Ledger1Click(Sender: TObject);
begin
  If (Assigned(MULCtrlO)) then
  With MULCtrlO do
  Begin
    If ValidLine then
      DrillToStkLedger(LastPr,LastYr,LastMode);

  end;
end;

procedure TTeleSFrm.PopupMenu7Popup(Sender: TObject);
Const
  GenCap  :  Array[0..2] of Str30 = ('Order','Invoice','Quotation');

begin
  With TeleSHed^.TeleSRec do
  Begin
    GQU1.Caption:='&Generate '+GenCap[tcGenMode];

    GQU1.Tag:=Succ(tcGenMode);

    // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added Generate Order with Payment option
    // MH 09/06/2015 2015-R1 ABSEXCH-16515: Added check on mode so the option is only available if creating an order
    mnuOptGenerateOrderWithPayment.Visible := (tcGenMode = 0 {Order}) And ExLocal.LCust.acAllowOrderPayments And ChkAllowed_In(uaSORAllowOrderPaymentsPayment);
  end;
end;


procedure TTeleSFrm.GOrd1Click(Sender: TObject);
{$IFDEF SOP}
Var
  TSDocT  :  DocTypes;
  TelesalesOptions : TelesalesOptionsSet;
{$ENDIF SOP}
begin
  {$IFDEF SOP}
    If (Sender is TMenuItem) then
    Begin
      TelesalesOptions := [];
      Case TMenuItem(Sender).Tag of
        1  :  TSDocT:=SOR;
        2  :  TSDocT:=SIN;
        3  :  TSDocT:=SQU;
        // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added Generate Order with Payment option
        5  :  Begin
                TSDocT:=SOR;
                TelesalesOptions := TelesalesOptions + [tsoOrderPaymentsOfferPayment];
              End;
        else  TSDocT:=PIN;  // Cancel

      end; {Case..}

      If (TSDocT<>PIN) then
      With MULCtrlO do
      Begin
        // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added Generate Order with Payment option
        Gen_TeleSalesDoc(TSDocT,
                         TeleSHed,
                         {$IFDEF SOP}
                         TTDHelper,
                         {$ENDIF}
                         KeyRef,
                         KeyPath,
                         TelesalesOptions);

        ForceTsStore:=BOn;

        fFinishedOK:=BOn;


        SendMessage(Self.Handle,WM_Close,0,0);

        {PageUpDn(0,BOn);}
      end
      else {* Reset entered so far *}
      Begin
        {$IFDEF POST}
          ChkInProg:=2;

          SetButtons(BOff);

          TeleSHed^.TeleSRec.tcInProg:=BOff;

          AddRecalcTS2Thread(Self,TeleSHed,1);

          {== reset header ==}

        {$ENDIF}
      end;

    end;
  {$ENDIF}
end;

procedure TTeleSFrm.DefD1BtnClick(Sender: TObject);
begin
  If  (Not MULCtrlO.InListFind) then
  {$IFDEF SOP}
    Display_TSDefFrm;
  {$ENDIF}
end;


procedure TTeleSFrm.ACFFEnter(Sender: TObject);
begin
  Inc(BeenAECnt);
end;


procedure TTeleSFrm.ACFFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  WTrig,
  FoundOk,
  AltMod     :  Boolean;

  n          :  Byte;

  TempCust   :  CustRec;

begin
  {$IFDEF SOP}

    If (Sender is Text8pt) and (not TSInpClsBtn.Focused) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=(Modified or ForceACEdit);

      FoundCode:=Strip('B',[#32],Text);

      // CJS 2013-12-20 - ABSEXCH-14875 - moved this check so that it is
      // applied before calling the Extended Search, rather than just before
      // the GetCust() call below.
      if WasConsumer then
      begin
        if Copy(FoundCode, 1, 1) <> CONSUMER_PREFIX then
          FoundCode := CONSUMER_PREFIX + FoundCode;
      end;

      {$IFDEF CU}
        ExLocal.LCust.CustSupp:=TradeCode[BOn]; {Force this to be of an account type so that the hook will accept it as a valid account *}
        If (Not ReadOnly) then
        Begin
          // MH 26/02/2015 v7.0.13 ABSEXCH-16225: Added DoFocusFix parameter as it was screwing the focus on
          // the following transaction date field which causes it to ignore manual changes.
          FoundCode:=TextExitHook(1000,100,Trim(FoundCode),ExLocal, DoFocusFix);

          AltMod:=(AltMod or (FoundCode<>Text));
        end;
      {$ENDIF}

      { CJS 2013-02-26 - ABSEXCH-11276 - Extended Search - ESC key handling }
      if (FoundCode = 'EXTSEARCH CANCELLED') then
        Text := '';

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>TsInpClsBtn) and (Not DuringActive) and (BeenAECnt>2) then
      Begin

        StillEdit:=BOn;

        ForceACEdit:=BOff;

        { CJS 2013-02-26 - ABSEXCH-11276 - Extended Search - ESC key handling }
        if FoundCode <> 'EXTSEARCH CANCELLED' then
        begin
          FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,3))
        end
        else
          FoundOk := False;

        {$IFDEF CU} {* Call hooks here *}

          If (FoundOk) then
          With ExLocal do
          Begin
            TempCust:=LCust;
            ExLocal.AssignFromGlobal(CustF);
            FoundOk:=ValidExitHook(2000,189,ExLocal);
            LCust:=TempCust;
          end;

        {$ENDIF}


        If (FoundOk) then
        With ExLocal do
        Begin
          // CJS 2013-10-03 - MRD1.1.22 - Consumer Support
          if IsConsumer(Cust) then
          begin
            Text := Cust.acLongAcCode;
            WasConsumer := True;
          end
          else
          begin
          Text:=FoundCode;
            WasConsumer := False;
          end;

          LinkCF.Text:=Text;

          AssignFromGlobal(CustF);

          FoundOk:=Not Check_AccForCredit(LCust,0,0,BOn,BOn,WTrig,Self);

          SendToObjectCC(FoundCode,0);

          If (FoundOk) then
          With TeleSHed^,TeleSRec do
          Begin
            // MH 25/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
            SettlementDiscountPercentage := LCust.DefSetDisc;

            If (tcLockAddr<>0) then {v5.61 we had a prior lock in place, release it.}
                                    {v5.70, also release InProg}
              Unlock_TeleSales(tcLockAddr,MLocF,MLK);

              {UnLockMultiSing(F[MLocF],MLocF,tcLockAddr);}

            FoundOk:=Get_TSRecord(FoundCode,TeleSHed,BOn);

            If (FoundOk) then
            With LCust do
            Begin
              If (tcWasNew) then
                Set_TSFromCust(LCust,TeleSRec);

              SetGenStatus;
              OutTeleSImp;
              OutTeleSTot;

            end;

            {FoundOk:=BOn;}

            {$IFDEF CU} {* Call Delivery address hook here *}

              For n:=Low(TSDAddr) to High(TSDAddr) do
                LCust.DAddr[n]:=TSDAddr[n].Text;

              { CJS 2013-08-08 - MRD2.5 - Delivery PostCode }
              LCust.acDeliveryPostCode := PostCodeTxt.Text;
              // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
              // MH 26/01/2015 v7.1 ABSEXCH-16063: Modified country fields to use long names
              //LCust.acDeliveryCountry := lstDeliveryCountry.Text;
              If (lstDeliveryCountry.ItemIndex <> -1) Then
                LCust.acDeliveryCountry := ISO3166CountryCodes.ccCountryDetails[lstDeliveryCountry.ItemIndex].cdCountryCode2
              Else
                LCust.acDeliveryCountry := '  ';

              GenHooks(1000,109,ExLocal);

              For n:=Low(TSDAddr) to High(TSDAddr) do
                TSDAddr[n].Text:=LCust.DAddr[n];

              { CJS 2013-08-08 - MRD2.5 - Delivery PostCode }
              PostCodeTxt.Text := LCust.acDeliveryPostCode;
              // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
              If ValidCountryCode (ifCountry2, LCust.acDeliveryCountry) Then
                lstDeliveryCountry.ItemIndex := ISO3166CountryCodes.IndexOf(ifCountry2, LCust.acDeliveryCountry);

              // CJS 2016-01-20 - ABSEXCH-17104 - Intrastat - 4.8 - Telesales
              btnIntrastatSettings.Visible := Syss.Intrastat and LCust.EECMember;

            {$ENDIF}

          end;
        end;

        If (Not FoundOk) then
        Begin
          SetFocus;
          ForceACEdit:=BOn;
        end;
      end;
    end; {With..}
    {$ENDIF}

  end; {Proc..}



procedure TTeleSFrm.CurrFExit(Sender: TObject);
begin
  {$IFDEF SOP}
    {$IFDEF MC_On}
      With TeleSHed^,TeleSRec,CurrF do
      If (Modified) then
      Begin
        tcCurr:=Succ(CurrF.ItemIndex);

        tcCXRate[BOn]:=SyssCurr.Currencies[tcCurr].CRates[BOn];

        I1ExRateF.Value:=tcCXrate[BOn];

        I1ExRateF.ReadOnly:=(SyssGCuR^.GhostRates.TriEuro[tcCurr]<>0);

        If (tcLineCount<>0) then
        Begin
          CustomDlg(Application.MainForm,'Please Note','TeleSales currency changed.',
                               'You have changed the currency of this TeleSales transaction.'+#13+
                               'The current TeleSales entries for this account will be reset.',
                               mtInformation,
                               [mbOK]);
          CurrChange:=BOn;

          PostMessage(Self.Handle,WM_CustGetRec,207,0);
        end;

        OutTeleSTot;
      end;
    {$ENDIF}
  {$ENDIF}
end;



procedure TTeleSFrm.I1TransDateFExit(Sender: TObject);

Var
  FoundOk,
  WTrig  :  Boolean;

begin
  {$IFDEF SOP}
    If (I1DueDateF.DateValue='') then
      I1DueDateF.DateValue:=I1TransDateF.DateValue;

    If (CheckCLimit) then
    Begin
      FoundOk:=Not Check_AccForCredit(ExLocal.LCust,0,0,BOn,BOn,WTrig,Self);

      If (Not FoundOk) then
      Begin
        BeenAECnt:=3;
        ForceACEdit:=BOn;
        ACFF.SetFocus;
      end
      else
        CheckCLimit:=BOff;

    end;

  {$ENDIF}
end;

procedure TTeleSFrm.I1YRefExit(Sender: TObject);

Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

begin
  {$IFDEF SOP}

    If (Sender is Text8pt) and (Syss.WarnYRef) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      Modified:=BOff;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>TsInpClsBtn) then
      Begin
        FoundOk:=(Not Check4DupliYRef(FoundCode,ACFF.Text,InvF,InvYrRefK,ExLocal.LInv,'Reference ('+FoundCode+')'));


      end;
    end; {With..}
  {$ENDIF}
end;


procedure TTeleSFrm.I5ISBtnClick(Sender: TObject);
Var
  mrResult  :  Word;

begin
  {$IFDEF SOP}
   {$B-}
    // MH 21/12/2010 v6.6 ABSEXCH-10548: Added check on list not existing as was preventing button
    //                                   from working until you'd been to the list and come back again
    If (Assigned(MULCtrlO) and (Not MULCtrlO.InListFind)) Or (Not Assigned(MULCtrlO)) then
   {$B+}
    With TeleSHed^,TeleSRec do
    Begin
      ISCtrl:=TIntStatInv.Create(Self);

      try

        With ISCtrl do
        Begin
          ISDelTerms:=tcDelTerms;
          ISTransNat:=tcTransNat;
          ISTransMode:=tcTransMode;

          With ACFF do
            mrResult:=InitIS(BOff,Color,Font);

          If (mrResult=mrOk) then
          Begin
            tcDelTerms:=ISDelTerms;
            tcTransNat:=ISTransNat;
            tcTransMode:=ISTransMode;
          end;
        end;

      finally

        ISCtrl.Free;

      end; {Try..}

    end; {with..}

  {$ENDIF}
end;



procedure TTeleSFrm.I4JobCodeFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  JobCCDept: CCDepType;
  CCDept: CCDepType;
begin
  {$IFDEF SOP}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>TsInpClsBtn) and (JBCostOn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJob(Self,FoundCode,FoundCode,0));

        If (FoundOk) then {* Credit Check *}
        Begin
          Text:=FoundCode;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

          // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
          JobUtils.GetJobCCDept(FoundCode, JobCCDept);
          CCDept[True] := Id3CCF.Text;
          CCDept[False] := Id3DepF.Text;
          CCDept := GetCustProfileCCDepEx(ExLocal.LCust.CustCC, ExLocal.LCust.CustDep, CCDept, JobCCDept, 0);
          Id3CCF.Text := CCDept[True];
          Id3DepF.Text := CCDept[False];

        end
        else
        Begin
          {StopPageChange:=BOn;}

            SetFocus;
        end; {If not found..}

      end
      else
        If (FoundCode='') then {* Reset Janal code *}
          I4JobAnalF.Text:='';

    end;
  {$ENDIF}
end;




procedure TTeleSFrm.I4JobAnalFChange(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  {$IFDEF SOP}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (((AltMod) or (FoundCode='')) and (Not EmptyKey(I4JobCodeF.Text,JobCodeLen))) and (JBCostOn) and (ActiveControl<>TsInpClsBtn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,2,Anal_FiltMode(SIN)));

        If (FoundOk) then {* Credit Check *}
        Begin

          Text:=FoundCode;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

        end
        else
        Begin
          {StopPageChange:=BOn;}

          SetFocus;
        end; {If not found..}
      end;

    end;
  {$ENDIF}

end;



procedure TTeleSFrm.Id3CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin

  {$IFDEF SOP}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>TsInpClsBtn) and (Syss.UseCCDep)  then
      Begin

        // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
        // For Job Costing, allow the user to pass through the Cost Centre and
        // Department fields without selecting anything, but if they have
        // entered values, do the normal validation.
        if (FoundCode <> '') or (not I4JobCodeF.Visible) then
        begin
          StillEdit:=BOn;

          //TG-29-05-2017- ABSEXCH-18684- Inactive CC/Dep gets display in 'Cost Centre/Department Search List'.
          FoundOk:=(GetCCDep(Self.Owner,FoundCode,FoundCode,IsCC,2));

          If (FoundOk) then
          Begin

            StillEdit:=BOff;

            Text:=FoundCode;

          end
          else
          Begin

            SetFocus;
          end; {If not found..}
        end;
      end
      else
        If (AltMod) and (FoundCode='') then
          Text:='';

    end; {with..}
  {$ENDIF}
end;



procedure TTeleSFrm.I1LocFExit(Sender: TObject);

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

      If (((AltMod) or ((FoundCode='') and Syss.UseMLoc)) and (ActiveControl<>TsInpClsBtn)) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,SCode,77*Ord(Syss.UseMLoc)));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin
          Text:=FoundCode;

        end
        else
        Begin

          SetFocus;
        end; {If not found..}
      end;

    end; {with..}
  {$ENDIF}
end;




procedure TTeleSFrm.CompFDblClick(Sender: TObject);
begin
  ACFF.DblClick;

end;

procedure TTeleSFrm.ACFFDblClick(Sender: TObject);
begin
  If (MatchOwner('CustRec3',Self.Owner)) then
    TForm(Self.Owner).Show
  else
    LinkCF.DblClick;
end;

// MHYR 25/10/07
procedure TTeleSFrm.I1YRefChange(Sender: TObject);
begin
  I1YRef.Hint := I1YRef.Text;
end;

// MHYR 25/10/07
procedure TTeleSFrm.I1LYRefChange(Sender: TObject);
begin
  I1LYRef.Hint := I1LYRef.Text;
end;

{ CS: 14/04/2008 - Amendments for Form Resize routines }
procedure TTeleSFrm.FormStartResize(var Msg: TMsg);
begin
  { User is starting to resize the form. Suppress the update of the list
    columns until the resize finishes. }
  IsResizing := True;
end;

{ CS: 14/04/2008 - Amendments for Form Resize routines }
procedure TTeleSFrm.FormEndResize(var Msg: TMsg);
begin
  { Finished resizing the form. Force a complete refresh of the list columns. }
  IsResizing := False;
  Screen.Cursor := crAppStart;
  try
    FormResize(self);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TTeleSFrm.btnApplyTTDClick(Sender: TObject);
begin
  {$IFDEF SOP}
//    If Sender Is TMenuItem Then
//      TTDHelper.ApplyTTD := NOT TTDHelper.ApplyTTD
//    Else
      TTDHelper.ApplyTTD := True;
    TTDHelper.Owner := Self;
    btnApplyTTD.Enabled := False;
  {$ENDIF}
end;

procedure TTeleSFrm.PageControl1Change(Sender: TObject);
begin
  //PR: 07/04/2011 ABSEXCH-10664 Set help context on form from active page.
  if Assigned(PageControl1.ActivePage) then
  begin
    HelpContext := PageControl1.ActivePage.HelpContext;
    PageControl1.HelpContext := PageControl1.ActivePage.HelpContext;

    UPBOMP.Visible := (PageControl1.ActivePage.TabIndex > 0);
  end;
end;

// CJS 2016-01-18 - ABSEXCH-17104 - Intrastat - 4.8 - Telesales
procedure TTeleSFrm.btnIntrastatSettingsClick(Sender: TObject);
begin
  ShowIntrastatDetails(False);
end;

function TTeleSFrm.ShowIntrastatDetails(ForValidation: Boolean): Boolean;
var
  Dlg: TIntrastatDetailsFrm;
  DlgResult: Word;
  MustShow: Boolean;
begin
  Result := True;
  MustShow := True;
  Dlg := TIntrastatDetailsFrm.Create(self);
  try
    Dlg.DeliveryTerms   := TeleSHed.TeleSRec.tcDelTerms;
    Dlg.NoTc            := TeleSHed.TeleSRec.tcTransNat;
    Dlg.ModeOfTransport := TeleSHed.TeleSRec.tcTransMode;
    Dlg.TransactionType := TeleSHed.TeleSRec.tcSSDProcess;

    if ForValidation then
    begin
      Result := Dlg.Validate;
      MustShow := not Result;
    end;

    if MustShow then
    begin
      DlgResult := Dlg.ShowModal;

      if DlgResult = mrOk then
      begin
        TeleSHed.TeleSRec.tcDelTerms   := Dlg.DeliveryTerms;
        TeleSHed.TeleSRec.tcTransNat   := Dlg.NoTc;
        TeleSHed.TeleSRec.tcTransMode  := Dlg.ModeOfTransport;
        TeleSHed.TeleSRec.tcSSDProcess := Dlg.TransactionType;
      end;
    end;
  finally
    Dlg.Free;
  end;
end;

Initialization

  New(LocalCSAnal);

  FillChar(LocalCSAnal^,Sizeof(LocalCSAnal^),0);

Finalization

  Dispose(LocalCSAnal);

end.
