unit StkAdjU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, TEditVal, BorBtns, Mask, ComCtrls,

  GlobVar,VarConst,ExWrap1U,BTSupU1,SupListU,SBSComp2,

  ExtGetU,

  SalTxL1U,

  AdjLineU,

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

  Menus, TCustom;



type
  TADJMList  =  Class(TDDMList)


    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;


  end;


type
  TStkAdj = class(TForm)
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
    SBSPanel5: TSBSPanel;
    DrReqdTit: Label8;
    SBSPanel4: TSBSPanel;
    CrReqdTit: Label8;
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
    CostLab: Label8;
    GLLab: Label8;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label85: Label8;
    Label86: Label8;
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
    A1StatLab: Label8;
    A1FPanel: TSBSPanel;
    Label817: Label8;
    Label87: Label8;
    Label816: Label8;
    A1OrefF: Text8Pt;
    A1OpoF: Text8Pt;
    A1YRefF: Text8Pt;
    A1LocPanel: TSBSPanel;
    A1LocLab: TSBSPanel;
    LnkN1Btn: TButton;
    Links1: TMenuItem;
    A1LocTxF: Text8Pt;
    LTxfrLab: Label8;
    FindN1Btn: TButton;
    Find1: TMenuItem;
    CustTxBtn2: TSBSButton;
    CustTxBtn1: TSBSButton;
    EntCustom3: TCustomisation;
    Custom1: TMenuItem;
    Custom2: TMenuItem;
    TabSheet1: TTabSheet;
    PMenu_Notes: TPopupMenu;
    MenItem_General: TMenuItem;
    MenItem_Dated: TMenuItem;
    MenItem_Audit: TMenuItem;
    TransExtForm1: TSBSExtendedForm;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    Label84: Label8;
    Label88: Label8;
    Label89: Label8;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    UDF5L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    A1TDateF: TEditDate;
    A1TPerF: TEditPeriod;
    A1YRef2F: Text8Pt;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    CustTxBtn3: TSBSButton;
    CustTxBtn4: TSBSButton;
    CustTxBtn5: TSBSButton;
    CustTxBtn6: TSBSButton;
    Custom3: TMenuItem;
    Custom4: TMenuItem;
    Custom5: TMenuItem;
    Custom6: TMenuItem;
    UDF11L: Label8;
    THUD11F: Text8Pt;
    UDF12L: Label8;
    THUD12F: Text8Pt;
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
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure FindN1BtnClick(Sender: TObject);
    procedure CustTxBtn1Click(Sender: TObject);
    procedure A1YRef2FChange(Sender: TObject);
    procedure SetUDFields(UDDocHed  :  DocTypes);
    procedure MenItem_GeneralClick(Sender: TObject);
    procedure MenItem_DatedClick(Sender: TObject);
    procedure MenItem_AuditClick(Sender: TObject);
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
    FColorsChanged,
    BalDone,
    fFrmClosing,
    fDoingClose,
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

    IdLine       :  TAdjLine;
    IdLineActive :  Boolean;

    RecordPage   :  Byte;
    DocHed       :  DocTypes;

    ChkTotalQty,
    OldConTot    :  Double;


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

    procedure SetFormProperties(SetList  :  Boolean);

    procedure SetFieldProperties;

    Procedure AdjStkDeduct(Mode  :  Byte);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure SetHelpContextIDs; // NF: 22/06/06
    procedure SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
  public
    { Public declarations }

    fForceStore:  Boolean;

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;

    MULCtrlO   :  TAdjMList;


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

    Function Check_LinesOk(InvR  :  InvRec)  :  Boolean;

    {$IFDEF SOP}
      Procedure RetSNos(Const OrdR       :  InvRec;
                              OId,IdR    :  IDetail);

      Procedure RetBNos(Const OrdR       :  InvRec;
                              OId,IdR    :  IDetail);

      procedure Remove_BalLines;

      Procedure TxFrSNos(Const OrdR       :  InvRec;
                               OId,IdR    :  IDetail);

      Procedure TxFrBins(Const OrdR       :  InvRec;
                               OId,IdR    :  IDetail);

      procedure Tidy_BalLines(Const  Fnum,Keypath  :  Integer);

      procedure Gen_BalLines;
    {$ENDIF}

    

    procedure StoreNtxfr(Fnum,
                         KeyPAth    :  Integer);

    procedure EditAccount(Edit,
                          AutoOn,
                          ViewOnly   :  Boolean);


  end;

  Procedure Set_SAdjFormMode(State  :  DocTypes;
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

  InvCTSUU,

  SysU1,
  SysU2,
  SysU3,
  IntMU,
  MiscU,
  PayF2U,
  PassWR2U,
  {$IFDEF SOP}
    SalTxl2U,
    StkSerNU,
    InvLst3U,
  {$ENDIF}

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}
  Event1U,
  GenWarnU,
  StockLevelsU,
  AdjCtrlU,
  //GS 18/10/2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF,
  AuditNotes,

  // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
  JobUtils,

  { CJS - 2013-10-25 - MRD2.6.09 - Transaction Originator }
  TransactionOriginator
  ;


{$R *.DFM}



Var
  SAdjFormMode  :  DocTypes;
  SAdjFormPage  :  Byte;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_SAdjFormMode(State  :  DocTypes;
                            NPage  :  Byte);

Begin
  If (State<>SAdjFormMode) then
    SAdjFormMode:=State;

  If (SAdjFormPage<>NPage) then
    SAdjFormPage:=NPage;

end;




{$I StAdjI1U.PAS}



Procedure  TStkAdj.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TStkAdj.Find_FormCoord;


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


procedure TStkAdj.Store_FormCoord(UpMode  :  Boolean);


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




procedure TStkAdj.SetForceStore(State  :  Boolean);

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


Function TStkAdj.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;


Procedure TStkAdj.Link2Nom;

Var
  FoundOk   :  Boolean;
  FoundLong :  LongInt;
  FoundStk  :  Str20;

Begin
  With Id do
  Begin

    CostLab.Caption:=FormatFloat(GenUnitMask[BOff],CostPrice);

    If (Nom.NomCode<>NomCode) then
      FoundOk:=GetNom(Self,Form_Int(NomCode,0),FoundLong,-1);

    GLLab.Caption:=Nom.Desc;

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
      end;
    {$ENDIF}

  end;
end;


Procedure TStkAdj.WMCustGetRec(Var Message  :  TMessage);
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

                else With ExLocal do
                     If (EmptyKey(LInv.DelTerms,MLocKeyLen)) or (Id.Qty<0) or (LInv.DelTerms<>Id.MLocStk) then
                     Begin

                        Display_Id(2);

                        If (IdLineActive) and (Not ExLocal.InAddEdit) then {*it must be readonly *}
                          IdLine.Show;
                      end
                      else
                        If (WParam=0) then
                          ShowMessage('It is not possible to edit an automatically generated location transfer line. Adjust the out line in order to affect the in line.');

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
               With MULCtrlO do
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));

               If (IdLine<>nil) then
               With ExLocal do
               Begin
                 LInv:=IdLine.ExLocal.LInv;

                 If (LastEdit) and (Not LViewOnly) and (Not ForceStore) then
                   ForceStore:=((LInv.ILineCount<>LastInv.ILineCount) or
                                (Linv.Variance<>LastInv.Variance) or
                                (Linv.TotalInvoiced<>LastInv.TotalInvoiced));

               end;


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


Procedure TStkAdj.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TStkAdj.Send_UpdateList(Edit   :  Boolean;
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


procedure TStkAdj.ShowLink(ShowLines,
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


procedure TStkAdj.FormSetOfSet;

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


Function TStkAdj.SetHelpC(PageNo :  Integer;
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

//------------------------------------------------------------------------------
procedure TStkAdj.PrimeButtons;

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
      {00}AddVisiRec(AddN1Btn,BOff);
      {01}AddVisiRec(EditN1Btn,BOff);
      {02}AddVisiRec(DelN1Btn,BOff);
      {03}AddVisiRec(FindN1Btn,BOff);
      {04}AddVisiRec(InsN1Btn,BOff);
      {05}AddVisiRec(SwiN1Btn,BOff);
      {06}AddVisiRec(LnkN1Btn,BOff);

      {07} AddVisiRec(CustTxBtn1,BOff);
      {08} AddVisiRec(CustTxBtn2,BOff);
           // 17/01/2013 PKR ABSEXCH-13449
           // Custom buttons 3..6 now available
      {09} AddVisiRec(CustTxBtn3,BOff);
      {10} AddVisiRec(CustTxBtn4,BOff);
      {11} AddVisiRec(CustTxBtn5,BOff);
      {12} AddVisiRec(CustTxBtn6,BOff);

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
      SetHideBtn(1,((ExLocal.LViewOnly) and (PageNo=1) and (fRecordLocked)) ,BOff);

      SetBtnHelp(0,SetHelpC(PageNo,[0..1],260,88));
      SetBtnHelp(1,SetHelpC(PageNo,[0..1],261,87));


      SetHideBtn(2,Not IdButton(0).Visible,BOff);
      SetBtnHelp(2,SetHelpC(PageNo,[0..1],263,89));

      SetHideBtn(4,(PageNo=0) or (Not IdButton(0).Visible),BOff);

      SetHideBtn(5,(PageNo=0),BOff);
      SetHideBtn(6,(PageNo In [1]),BOff);

      {$IFDEF CU}
              // 17/01/2013 PKR ABSEXCH-13449
              // Use the custom button handler.
              FormPurpose := fpStockAdjustment;
              if ExLocal.LViewOnly then
                recordState := rsView
              else
                recordState := rsEdit;
              
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn1.Tag);
        {07}  SetHideBtn(07, not cBtnIsEnabled, BOff);
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn2.Tag);
        {08}  SetHideBtn(08, not cBtnIsEnabled, BOn);
              // 17/01/2013 PKR ABSEXCH-13449
              // Custom buttons 3..6 now available
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn3.Tag);
        {09}  SetHideBtn( 9, not cBtnIsEnabled, BOn);
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn4.Tag);
        {10}  SetHideBtn(10, not cBtnIsEnabled, BOn);
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn5.Tag);
        {11}  SetHideBtn(11, not cBtnIsEnabled, BOn);
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn6.Tag);
        {12}  SetHideBtn(12, not cBtnIsEnabled, BOn);

(*
        {07}  SetHideBtn(07,Not EnableCustBtns(2000,38+(100*Ord(ExLocal.LViewOnly))),BOff);
        {08}  SetHideBtn(08,Not EnableCustBtns(2000,39+(100*Ord(ExLocal.LViewOnly))),BOn);
*)

        // 17/01/2013 PKR ABSEXCH-13449
        // Use the custom button handler to get the text ID.
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
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, 16, TheCaption, CustTxBtn1.Font);
        CustTxBtn1.Caption:=TheCaption;

        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, 17, TheCaption, CustTxBtn2.Font);

        CustTxBtn2.Caption:=TheCaption;
*)

      {$ELSE}
        {07}  SetHideBtn(07,BOn,BOff);
        {08}  SetHideBtn(08,BOn,BOn);
              // 17/01/2013 PKR ABSEXCH-13449
              // Custom buttons 3..6 now available
        {09}  SetHideBtn( 9,BOn,BOn);
        {10}  SetHideBtn(10,BOn,BOn);
        {11}  SetHideBtn(11,BOn,BOn);
        {12}  SetHideBtn(12,BOn,BOn);

      {$ENDIF}

    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;


procedure TStkAdj.BuildDesign;

Var
  HideCC  :  Boolean;

begin

  {* Set Version Specific Info *}


  A1YRefF.MaxLength:=DocYRef2Len;
  A1YRef2F.MaxLength:=DocYRef1Len;

  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}


  CCPanel.Visible:=Not HideCC;


  {$IFNDEF SOP}

    HideCC:=BOn;
  {$ELSE}

    HideCC:=Not Syss.UseMLoc;
  {$ENDIF}

  If (HideCC) then
  Begin
    A1LocTxF.Visible:=BOff;
    LTxFrLab.Visible:=BOff;

    TransExtForm1.TabNext:=A1OpoF;

  end;
  
  
  (*
  UDF1L.Caption:=Get_CustmFieldCaption(2,1);
  UDF1L.Visible:=Not Get_CustmFieldHide(2,1);

  THUD1F.Visible:=UDF1L.Visible;

  UDF2L.Caption:=Get_CustmFieldCaption(2,2);
  UDF2L.Visible:=Not Get_CustmFieldHide(2,2);

  THUD2F.Visible:=UDF2L.Visible;


  UDF3L.Caption:=Get_CustmFieldCaption(2,3);
  UDF3L.Visible:=Not Get_CustmFieldHide(2,3);

  THUD3F.Visible:=UDF3L.Visible;


  UDF4L.Caption:=Get_CustmFieldCaption(2,4);
  UDF4L.Visible:=Not Get_CustmFieldHide(2,4);

  THUD4F.Visible:=UDF4L.Visible;

  TransExtform1.ReAssignFocusLast;

  If (Not THUD1F.Visible) or (Not THUD2F.Visible) or (Not THUD3F.Visible) or (Not THUD4F.Visible) then
  With TransExtForm1 do
  Begin
    If ((Not THUD4F.Visible) and (Not THUD2F.Visible)) then
      ExpandedWidth:=Width;

    If ((Not THUD1F.Visible) and (Not THUD2F.Visible) and (Not THUD3F.Visible) and (Not THUD4F.Visible)) then
      ExpandedHeight:=Height;

  end;
  *)

  //GS 18/10/2011 ABSEXCH-11706: removed existing UDF setup code; replaced with calling pauls new method
  SetUDFields(DocHed);

end;

//GS 18/10/2011 ABSEXCH-11706: a copy of pauls user fields function
//PR: 11/11/2011 Amended to use centralised function EnableUdfs in CustomFieldsIntf.pas ABSEXCH-12129
procedure TStkAdj.SetUDFields(UDDocHed  :  DocTypes);
begin

  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L, UDF11L, UDF12L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F],
             cfADJHeader);

  ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F]),
                           2, //UDFs laid out on the UI as 2 columns, 5 rows
                           TransExtForm1,
                           0,     // RowHeightOverRide
                           12);   // UDF_Count
end;


procedure TStkAdj.FormDesign;


begin

  PrimeButtons;

  BuildDesign;

  {$IFDEF CU} {Set captions on custom buttons}
  try
    EntCustom3.Execute;
  except
    ShowMessage('Customisation Control Failed to initialise');
  end;
  {$ENDIF}

end;

procedure TStkAdj.HidePanels(PageNo    :  Byte);

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

              {$IFDEF LTE}
                {$IFNDEF SOP}
                  SetHidePanel(6,BOn,BOff);
                {$ENDIF}  
              {$ENDIF}  

              SetHidePanel(8,TmpBo,BOff);
              SetHidePanel(9,TmpBo,BOn);

            end;


    end; {Case..}

  end; {with..}
end;


Function TStkAdj.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      0
         :  Result:=A1SBox.HorzScrollBar.Position;
      else  Result:=0;
    end; {Case..}


end;


procedure TStkAdj.RefreshList(ShowLines,
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


procedure TStkAdj.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TAdjMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO do
    Begin

      Try

        With VisiList do
        Begin
          AddVisiRec(A1CPanel,A1CLab);
          AddVisiRec(A1DPanel,A1DLab);
          AddVisiRec(A1IPanel,A1ILab);
          AddVisiRec(A1OPanel,A1OLab);
          AddVisiRec(A1BPanel,A1BLab);
          AddVisiRec(A1UPanel,A1ULab);
          AddVisiRec(A1LocPanel,A1LocLab);
          AddVisiRec(A1GPanel,A1GLab);
          AddVisiRec(A1CCPanel,A1CCLab);
          AddVisiRec(A1DpPanel,A1DpLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(0);

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

        If (n In [2,3,5,7]) then
        Begin
          DispFormat:=SGFloat;

          Case n of
            2,3  :  NoDecPlaces:=Syss.NoQtyDec;
              5  :  NoDecPlaces:=Syss.NoCosDec;
            else    NoDecPlaces:=0;
          end; {Case..}
        end;
      end;


      ListLocal:=@ExLocal;

      ListCreate;

      NoUpCaseCheck:=BOn;

      UseSet4End:=BOn;

      Set_Buttons(A1ListBtnPanel);

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

procedure TStkAdj.SetNTxfrFields;

Var
  GenStr       :  Str255;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    A1ORefF.Text:=Pr_OurRef(LInv);
    A1OpoF.Text:=OpName;

    { CJS - 2013-10-25 - MRD2.6.09 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      A1OpoF.Hint := GetOriginatorHint(LInv)
    else
      A1OpoF.Hint := '';

    A1TPerF.InitPeriod(AcPr,AcYr,BOn,BOn);

    A1TDateF.DateValue:=TransDate;

    A1YRefF.Text:=TransDesc;
    A1YRef2F.Text:=YourRef;

    {$IFDEF SOP}
      A1LocTxF.Text:=Trim(DelTerms);
    {$ENDIF}

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



{ ======== Display Invoice Record ========== }

procedure TStkAdj.OutNTxfr;

Var
  GenStr       :  Str255;
  FoundCode    :  Str20;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    SetNTxfrFields;
  end; {With..}
end;


procedure TStkAdj.Form2NTxfr;


Begin
  With ExLocal,LInv do
  Begin
    TransDate:=A1TDateF.DateValue;

    A1TPerF.InitPeriod(AcPr,AcYr,BOff,BOff);

    TransDesc:=A1YRefF.Text;

    YourRef:=A1YRef2F.Text;

    {$IFDEF SOP}
      If (Syss.UseMLoc) and (Not EmptyKey(A1LocTxF.Text,MLocKeyLen)) then
        DelTerms:=Full_MLocKey(A1LocTxF.Text);
    {$ENDIF}

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


Procedure TStkAdj.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      0
         :  A1YRefF.SetFocus;

    end; {Case&With..}

end; {Proc..}




Procedure TStkAdj.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TStkAdj.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
  end;
end;


procedure TStkAdj.PageControl1Change(Sender: TObject);
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

         1  :  ;

      {$ENDIF}



      end; {Case..}


      MDI_UpdateParentStat;

    end; {With..}
end;




procedure TStkAdj.FormCreate(Sender: TObject);

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
  FColorsChanged := False;
  BalDone:=BOff;

  ChkTotalQty:=0.0;

  Visible:=BOff;

  InvStored:=BOff;

  JustCreated:=BOn;

  fRecordLocked:=BOff;
  
  StopPageChange:=BOff;

  SKeypath:=0;

  MinHeight:=351;
  MinWidth:=630;

  InitSize.Y:=358;
  InitSize.X:=632;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  TabSheet1.TabVisible:=BOff;

  {Height:=382;
  Width:=640;}

  PageControl1.ActivePage:=AdjustPage;


  With TForm(Owner) do
  Begin
    Self.Left:=0;
    Self.Top:=0;
  end;

  RecordPage:=SAdjFormPage;
  DocHed:=SAdjFormMode;

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

  SetHelpContextIDs; // NF: 22/06/06 Fix for incorrect Context IDs
end;



procedure TStkAdj.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  If (InvBtnList<>nil) then
    InvBtnList.Free;

  {If (MULCtrlO<>nil) then
    MULCtrlO.Free;}

end;

procedure TStkAdj.FormCloseQuery(Sender: TObject;
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

        Send_UpdateList(BOff,103);

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;

end;

procedure TStkAdj.FormClose(Sender: TObject; var Action: TCloseAction);
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


procedure TStkAdj.NotePageReSize;

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


procedure TStkAdj.FormResize(Sender: TObject);
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


    With A1SBox do
      A1HedPanel.Width:=HorzScrollBar.Range;


    TCNListBtnPanel.Height:=PageControl1.Height-PagePoint[6].Y;

    NotePageResize;


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


procedure TStkAdj.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TStkAdj.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Function TStkAdj.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;




procedure TStkAdj.ClsN1BtnClick(Sender: TObject);
begin
  If ConfirmQuit then
    Close;
end;

function TStkAdj.A1TPerFConvDate(Sender: TObject; const IDate: string;
  const Date2Pr: Boolean): string;
begin
  Result:=ConvInpPr(IDate,Date2Pr,@ExLocal);
end;


Function TStkAdj.ConfirmQuit  :  Boolean;

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
      mbRet:=MessageDlg('This Stock Adjustment must be stored',mtWarning,[mbOk],0)
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


procedure TStkAdj.SetNTxfrStore(EnabFlag,
                                VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode;

  OkN1Btn.Enabled:=Not VOMode;
  CanN1Btn.Enabled:=Not VOMode;


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

end;


Procedure TStkAdj.NoteUpdate;


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



Function TStkAdj.SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

Var
  VOMsg  : Byte;

Begin


{$B-}

  Result:=(SL and ((VO) or View_Status(ExLocal.LInv,BOff,VOMsg)));

{$B+}

  If (VO) then {* Force View only msg *}
    VOMsg:=9;

  If (Result) then
    A1StatLab.Caption:='STATUS:'+#13+GetIntMsg(VOMsg+50)
  else
    A1StatLab.Caption:='';

  OkN1Btn.Visible:=Not Result;
  CanN1Btn.Visible:=OkN1Btn.Visible;

end;





(*  Add is used to add Customers *)

procedure TStkAdj.ProcessNtxfr(Fnum,
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

Function TStkAdj.Check_LinesOk(InvR  :  InvRec)  :  Boolean;

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

  ChkTotalQty:=0.0;

  While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NomOk) do
  With Id do
  Begin

    If (IdLine<>nil) then
    With IdLine do
    Begin
      ExLocal.AssignFromGlobal(IdetailF);
      NomOk:=CheckCompleted(Self.ExLocal.LastEdit,BOn);
    end
    else
      NomOk:=BOn;

    ChkTotalQty:=ChkTotalQty+Round_Up(Qty,Syss.NoQtyDec);


    ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Result:=NomOk;
end; {Func..}



Function TStkAdj.CheckCompleted(Edit  :  Boolean)  : Boolean;

Const
  NofMsgs      =  9;
  Fnum     =  IDetailF;
  Keypath  =  IDFolioK;

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

  StockLevelsFrm: TStockLevelsFrm;
  KeyChk: Str255;
  KeyS: Str255;
  FuncRes: LongInt;

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
  PossMsg^[7]:='The total location transfer quantity out does not match the total quantity in';
  PossMsg^[8]:='An additional check is made via an external hook';
  PossMsg^[9]:='Insufficient stock'; // Never displayed




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

        7  :   If (Syss.UseMLoc) and (Not EmptyKey(DelTerms,LocKeyLen)) and (BalDone) then {Check lines balance}
               Begin
                 Result:=(ChkTotalQty=0.0);

               end;
      {$ENDIF}

      6  :  Result:=ValidDate(TransDate);

      8  :   Begin {* Opportunity for hook to validate the header as well *}
                 {$IFDEF CU}

                   Result:=ValidExitHook(2000,82,ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;

      9:  begin
      {
            Screen.Cursor := crHourglass;
            StockLevelsFrm := TStockLevelsFrm.Create(Application.MainForm);
            try
              KeyChk := FullIdKey(LInv.FolioNum, RecieptCode);
              KeyS   := KeyChk;

              FuncRes := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

              if (FuncRes = 0) and CheckKey(KeyChk, KeyS, Length(KeyChk), BOn) then
                if not StockLevelsFrm.Check(Id, Id.Qty * -1.0, 3, self.WindowHandle, True) then
                begin
                  StockLevelsFrm.ShowModal;
                  Result  := False;
                  ShowMsg := False;
                end;
            finally
              Screen.Cursor := crDefault;
              StockLevelsFrm.Free;
            end;
      }            
          end;


    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}


Procedure TStkAdj.AdjStkDeduct(Mode  :  Byte);

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


{$IFDEF SOP}

  { ===== Proc to Transfer all Serial nos from one document to another ===== }

  Procedure TStkAdj.RetSNos(Const OrdR       :  InvRec;
                                  OId,IdR    :  IDetail);


  Const
    Fnum      = MiscF;
    Keypath   = MIK;

  Var
    KeyS,KeyChk  :  Str255;

    B_Func       :  Integer;

    FoundCode,
    FindBatch    :  Str20;
    BQtyU,
    DiscP,
    Dnum1,Dnum2,
    SerCount     :  Double;
    FoundOk,
    FoundAll,
    LOk,
    Locked       :  Boolean;

    LAddr        :  LongInt;


  Begin

    FoundAll:=(IdR.SerialQty=0.0);  SerCount:=0.0;


    If (OId.StockCode<>Stock.StockCode) then
    Begin
      GetStock(Self,OId.StockCode,FoundCode,-1);
    end;

    If (Is_SerNo(Stock.StkValType)) and (Not FoundAll) then
    Begin

      KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio));

      KeyS:=KeyChk;


      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundAll) do
      With MiscRecs^.SerialRec do
      Begin
        Application.ProcessMessages;

        Dnum1:=0.0; Dnum2:=0.0;  BQtyU:=0.0;  LOK:=BOff;

        B_Func:=B_GetNext;

        With OrdR,IdR do
        Begin
          FoundOk:=((CheckKey(OurRef,InDoc,Length(OurRef),BOff)) and (BuyLine=ABSLineNo));

        end;

        If (FoundOk) then
        With IdR do
        Begin
          If (BatchRec) and (Not BatchChild) then {*  *}
          Begin
            If (QtyUsed<>0) then
            Begin
              BQtyU:=BQtyU+(Qty*QtyMul);
              BuyQty:=BuyQty-(Qty*QtyMul);

              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);
            end
            else
            Begin
              Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

              If (StatusOK) then
                B_Func:=B_GetGEq;

              BQtyU:=BQtyU+BuyQty;
            end;

            Report_BError(Fnum,Status);


            LOk:=StatusOk;


          end
          else
          If (Not BatchRec) and (Not Sold) and (OId.MLocStk<>'') then
          Begin
            SERN_SetUse(Fnum,Keypath,Dnum1,Dnum2,OrdR,OId,0);

            LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

            If (LOk) and (Locked) then
            Begin
              OutMLoc:=OId.MLocStk;

              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

              Report_BError(Fnum,Status);

              If (StatusOk) then
                B_Func:=B_GetLessEq;

              Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

            end;
          end;

          If (LOk) then
          Begin
            If (BatchRec) then
            Begin
              SerCount:=SerCount+BQtyU;
            end
            else
            Begin
              SerCount:=SerCount+1.0;
            end;
          end; {If Locked..}
        end; {With..}

        FoundAll:=(SerCount>=ABS(IdR.SerialQty));

        If (Not FoundAll) then
        Begin
          Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

          FoundAll:=(Sold);
        end;

      end; {While..}
    end {If SNo..}
    else
      RetBNos(OrdR,OId,IdR);




  end; {Proc..}


  { ===== Proc to Transfer all Bin nos from one document to another ===== }

  Procedure TStkAdj.RetBNos(Const OrdR       :  InvRec;
                                  OId,IdR    :  IDetail);


  Const
    Fnum      = MLocF;
    Keypath   = MLSecK;

  Var
    KeyS,KeyChk  :  Str255;

    B_Func       :  Integer;

    FoundCode,
    FindBatch    :  Str20;
    BQtyU,
    DiscP,
    Dnum1,Dnum2,
    SerCount     :  Double;
    FoundOk,
    FoundAll,
    LOk,
    Locked       :  Boolean;

    LAddr        :  LongInt;


  Begin

    FoundAll:=(IdR.BinQty=0.0);  SerCount:=0.0;


    If (OId.StockCode<>Stock.StockCode) then
    Begin
      GetStock(Self,OId.StockCode,FoundCode,-1);
    end;

    If (Stock.MultiBinMode) and (Not FoundAll) then
    Begin

      KeyChk:=FullQDKey(brRecCode,MSernSub,FullNomKey(Stock.StockFolio)+Full_MLocKey(IdR.MLocStk)+Chr(0));

      KeyS:=KeyChk;


      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundAll) do
      With MLocCtrl^.brBinRec do
      Begin
        Application.ProcessMessages;

        Dnum1:=0.0; Dnum2:=0.0;  BQtyU:=0.0;  LOK:=BOff;

        B_Func:=B_GetNext;

        With OrdR,IdR do
          FoundOk:=((CheckKey(OurRef,brInDoc,Length(OurRef),BOff)) and (brBuyLine=ABSLineNo));

        If (FoundOk) then
        With IdR do
        Begin
          If (brBatchRec) and (Not brBatchChild) then {*  *}
          Begin
            If (brQtyUsed<>0) then
            Begin
              BQtyU:=BQtyU+(Qty*QtyMul);
              brBuyQty:=brBuyQty-(Qty*QtyMul);

              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);
            end
            else
            Begin
              Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

              If (StatusOK) then
                B_Func:=B_GetGEq;

              bQtyU:=BQtyU+brBuyQty;
            end;

            Report_BError(Fnum,Status);


            LOk:=StatusOk;


          end;

          If (LOk) then
          Begin
            If (brBatchRec) then
            Begin
              SerCount:=SerCount+BQtyU;
            end
            else
            Begin
              SerCount:=SerCount+1.0;
            end;
          end; {If Locked..}
        end; {With..}

        FoundAll:=(SerCount>=ABS(IdR.BinQty));

        If (Not FoundAll) then
        Begin
          Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

          FoundAll:=(brSold);
        end;

      end; {While..}
    end; {If Bin..}


  end; {Proc..}


  procedure TStkAdj.Remove_BalLines;

  Const
    Fnum     =  IDetailF;
    Keypath  =  IdFolioK;

  Var

    KeyChk,KeyS  :  Str255;
    OId          :  IDetail;


  Begin
    With ExLocal,LInv do
    Begin
      KeyChk:=FullIdKey(FolioNum,RecieptCode);
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

      Blank(OId,Sizeof(OId));

      While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) do
      With LId do
      Begin

        If (CheckKey(DelTerms,MLocStk,Length(DelTerms),BOff)) and (Qty>0) then
        Begin


          Status:=Delete_Rec(F[FNum],Fnum,KeyPath);

          Report_BError(Fnum,Status);

          If (StatusOk) then
          Begin

            Deduct_AdjStk(LId,LInv,BOff);

            {$IFDEF PF_On}

              If (Not EmptyKey(LId.JobCode,JobCodeLen)) then
                Delete_JobAct(LId);

            {$ENDIF}

            RetSNos(LInv,OId,LId);

          end;

          Blank(OId,Sizeof(OId));

        end
        else
          OId:=LId;


        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

      end; {while..}

    end; {with..}

  end;

  { ===== Proc to Transfer all Serial nos from one document to another ===== }

Procedure TStkAdj.TxFrSNos(Const OrdR       :  InvRec;
                                 OId,IdR    :  IDetail);


  Const
    Fnum      = MiscF;
    Keypath   = MIK;

  Var
    KeyS,KeyChk  :  Str255;

    B_Func       :  Integer;

    FoundCode,
    FindBatch    :  Str20;
    BQtyU,
    DiscP,
    Dnum1,Dnum2,
    SerCount     :  Double;
    FoundOk,
    FoundAll,
    LOk,
    Locked       :  Boolean;

    LAddr        :  LongInt;


  Begin

    FoundAll:=(IdR.SerialQty=0.0);  SerCount:=0.0;


    If (OId.StockCode<>Stock.StockCode) then
    Begin
      GetStock(Self,OId.StockCode,FoundCode,-1);
    end;

    If (Is_SerNo(Stock.StkValType)) and (Not FoundAll) then
    Begin

      KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio)+#1);

      KeyS:=KeyChk+NdxWeight;


      Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundAll) do
      With MiscRecs^.SerialRec do
      Begin
        Application.ProcessMessages;

        Dnum1:=0.0; Dnum2:=0.0;  BQtyU:=0.0;  LOK:=BOff;

        B_Func:=B_GetPrev;

        With OrdR,OId do
          FoundOk:=((CheckKey(OurRef,OutDoc,Length(OurRef),BOff)) and (SoldLine=ABSLineNo));

        If (FoundOk) then
        With IdR do
        Begin
          If (BatchChild) then {* add new batch, at new in location *}
          Begin
            Status:=GetPos(F[Fnum],Fnum,LAddr);

            FindBatch:=BatchNo;
            BQtyU:=QtyUsed;

            BatchChild:=BOff;
            Sold:=BOff;
            BuyQty:=QtyUsed;  QtyUsed:=0.0;
            DateIn:=DateOut;
            InDoc:=OutDoc;
            BuyLine:=SoldLine;

            SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);
            Blank(OutDoc,Sizeof(OutDoc));
            Blank(DateOut,Sizeof(DateOut));
            Blank(OutMLoc,Sizeof(OutMLoc));
            SoldLine:=0;
            SerSell:=0;
            InMLoc:=MLocStk;

            Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

            Report_BError(Fnum,Status);

            LOk:=StatusOk;

            If (LOK) then
            Begin {Preserv pos of the child so we can go past it}
              SetDataRecOfs(Fnum,LAddr);

              Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);
            end;

          end
          else
          If (Not BatchRec) then
          Begin
            SERN_SetUse(Fnum,Keypath,Dnum1,Dnum2,OrdR,IdR,0);

            LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

            If (LOk) and (Locked) then
            Begin
              InMLoc:=MLocStk;

              InDoc:=OrdR.OurRef;
              BuyLine:=ABSLineNo;

              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

              Report_BError(Fnum,Status);

              If (StatusOk) then
                B_Func:=B_GetLessEq;

              Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

            end;
          end;

          If (LOk) then
          Begin
            If (BatchRec) then
            Begin
              SerCount:=SerCount+BQtyU;
            end
            else
            Begin
              SerCount:=SerCount+1.0;
            end;
          end; {If Locked..}
        end {With..}
        else
        Begin {*v5.71. Double check used line has not already been completely sold, and so prevent doubling up of serial record generation *}
          With OrdR,OId do
          If ((CheckKey(OurRef,InDoc,Length(OurRef),BOff)) and (BuyLine=ABSLineNo)) and (Sold) then
            If (BatchRec) then
            Begin
              SerCount:=SerCount+QtyUsed;
            end
            else
            Begin
              SerCount:=SerCount+1.0;
            end;

        end;

        FoundAll:=(SerCount>=IdR.SerialQty);

        If (Not FoundAll) then
        Begin
          Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

          FoundAll:=(Not Sold);
        end;

      end; {While..}
    end {If SNo..}
    else
      TxFrBins(OrdR,OId,IdR);


  end; {Proc..}


{ ===== Proc to Transfer all Bin nos from one document to another ===== }

Procedure TStkAdj.TxFrBins(Const OrdR       :  InvRec;
                                 OId,IdR    :  IDetail);


  Const
    Fnum      = MLocF;
    Keypath   = MLSecK;

  Var
    KeyS,KeyChk  :  Str255;

    B_Func       :  Integer;

    FoundCode    :  Str20;
    BQtyU,
    DiscP,
    Dnum1,Dnum2,
    SerCount     :  Double;
    FoundOk,
    FoundAll,
    LOk,
    Locked       :  Boolean;

    LAddr        :  LongInt;


  Begin

    FoundAll:=(IdR.BinQty=0.0);  SerCount:=0.0;


    If (OId.StockCode<>Stock.StockCode) then
    Begin
      GetStock(Self,OId.StockCode,FoundCode,-1);
    end;

    If (Stock.MultiBinMode) and (Not FoundAll) then
    Begin

      KeyChk:=FullQDKey(brRecCode,MSernSub,FullNomKey(Stock.StockFolio)+Full_MLocKey(OId.MLocStk)+Chr(1));

      KeyS:=KeyChk+NdxWeight;


      Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundAll) do
      With MLocCtrl^.brBinRec do
      Begin
        Application.ProcessMessages;

        Dnum1:=0.0; Dnum2:=0.0;  BQtyU:=0.0;  LOK:=BOff;

        B_Func:=B_GetPrev;

        With OrdR,OId do
          FoundOk:=((CheckKey(OurRef,brOutDoc,Length(OurRef),BOff)) and (brSoldLine=ABSLineNo));

        If (FoundOk) then
        With IdR do
        Begin
          If (brBatchChild) then {* add new batch, at new in location *}
          Begin
            Status:=GetPos(F[Fnum],Fnum,LAddr);

            BQtyU:=brQtyUsed;

            brBatchChild:=BOff;
            brSold:=BOff;
            brBuyQty:=brQtyUsed;  brQtyUsed:=0.0;
            brDateIn:=brDateOut;
            brInDoc:=brOutDoc;
            brBuyLine:=brSoldLine;

            Blank(brOutDoc,Sizeof(brOutDoc));
            Blank(brDateOut,Sizeof(brDateOut));
            Blank(brOutMLoc,Sizeof(brOutMLoc));
            brSoldLine:=0;
            brBinSell:=0;
            brInMLoc:=MLocStk;

            brCode2:=FullBinCode2(brStkFolio,brSold,brInMLoc,brPriority,brDateIn,brBinCode1);

            brCode3:=FullBinCode3(brStkFolio,brInMLoc,BrBinCode1);

            Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

            Report_BError(Fnum,Status);

            LOk:=StatusOk;

            If (LOK) then
            Begin {Preserv pos of the child so we can go past it}
              SetDataRecOfs(Fnum,LAddr);

              Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);
            end;

          end;

          If (LOk) then
          Begin
            SerCount:=SerCount+BQtyU;
          end; {If Locked..}
        end; {With..}

        FoundAll:=(SerCount>=IdR.BinQty);

        If (Not FoundAll) then
        Begin
          Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

          FoundAll:=(Not brSold);
        end;

      end; {While..}
    end; {If SNo..}


  end; {Proc..}



  procedure TStkAdj.Tidy_BalLines(Const  Fnum,Keypath  :  Integer);

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


  procedure TStkAdj.Gen_BalLines;

  Const
    Fnum     =  IDetailF;
    Keypath  =  IdFolioK;

  Var
    KeyChk,KeyS  :  Str255;
    OId          :  IDetail;
    SetNom,
    SetCCDep,
    Loop         :  Boolean;

    n            :  Byte;

    MSLR         :  MStkLocType;
    MLOR         :  MLocLocType;

    // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
    JobCCDept : CCDepType;

  Begin

    With ExLocal,LInv do
    Begin
      If (LastEdit) then {Remove any previously generated lines}
        Remove_BalLines;

      KeyChk:=FullIdKey(FolioNum,RecieptCode);
      KeyS:=KeyChk;

      SetCCDep:=BOff;  SetNom:=BOff;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

      While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) do
      With LId do
      Begin

        LineNo:=Pred(LineNo);

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum,Status);

        If (StatusOk) and (Not CheckKey(DelTerms,MLocStk,Length(DelTerms),BOff)) then
        Begin
          OId:=LId;

          Qty:=Qty*DocNotCnst;

          KitLink:=0;  {* Do we want to reverse a build? I think not... *}

          MLocStk:=Full_MLocKey(DelTerms);

          {* Overide with stock/loc defaults*}

          If (LStock.StockCode<>StockCode) then
          Begin
            If Global_GetMainRec(StockF,FullStockCode(StockCode)) then
              AssignFromGlobal(StockF)
            else
              LResetRec(StockF);
          end;

          {$IFDEF PF_On}
            If Syss.UseCCDep then
              SetCCDep:=LocOVerride(MLocStk,2);

          {$ENDIF}

          SetNom:=LocOVerride(MLocStk,1);

          Stock_LocLinkSubst(LStock,MLocStk);

          {* If overwrite cc/dep or noms but no Stk loc record has been created then grap cc/dep &/or nom from master loc record *}

          If ((SetCCDep) or (SetNOM)) and (Not LinkMLoc_Stock(MLocStk,FullStockcode(LStock.StockCode),MSLR)) then
          Begin
            If (LinkMLoc_Loc(MLocStk,MLOR)) then
            Begin
              If (SetCCDep) then
                LStock.CCDep:=MLOR.LoCCDep;

              If (SetNOM) then
              Begin
                For n:=1 to NofSNoms do
                  LStock.NomCodeS[n]:=MLOR.loNominal[n];
              end;
            end;
          end;

          If (LStock.StockType=StkBillCode) then
            NomCode:=LStock.NomCodes[5]  {* Asjust WIP *}
          else
            NomCode:=LStock.NomCodes[3];

          {* Override with WIP Nominal code *}

          NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);

          {With LStock do
            If (JBCostOn) and (Not EmptyKey(JAnalCode,AnalKeyLen)) then
              AnalCode:=JAnalCode;}

          {v4.32 method}
          {If (EmptyKeyS(CCDep[BOff],CCKeyLen,BOff)) or ((SetCCDep) and (Not EmptyKeyS(LStock.CCDep[BOff],CCKeyLen,BOff))) then
            CCDep[BOff]:=LStock.CCDep[BOff];

          If (EmptyKeyS(CCDep[BOn],CCKeyLen,BOff)) or ((SetCCDep) and (Not EmptyKeyS(LStock.CCDep[BOn],CCKeyLen,BOff))) then
            CCDep[BOn]:=LStock.CCDep[BOn];}

          If (SetCCDep) then
          Begin
            Blank(CCDep,Sizeof(CCDep));

            // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
            JobUtils.GetJobCCDept(JobCode, JobCCDept);
            CCDep:=GetProfileCCDepEx('', '', LStock.CCDep, CCDep, JobCCDept, 1);

            For Loop:=BOff to BOn do
              If (Trim(CCDep[Loop])='') then
                CCDep[Loop]:=OId.CCDep[Loop];
          end;

          Deduct_AdjStk(LId,LInv,BOn);

          SerialQty:=SerialQty*DocNotCnst;
          BinQty:=BinQty*DocNotCnst;

          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          If (StatusOk) then
            Update_JobAct(LId,LInv);
            
          {* We need to alter the In location code for any serial nos *}
          TxFrSnos(LInv,OId,LId);

        end;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

      end; {while..}

    end; {with..}

    Tidy_BalLines(Fnum,Keypath);

  end;
{$ENDIF}

procedure TStkAdj.StoreNtxfr(Fnum,
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

      {$IFDEF SOP}

        If (COk) and (Not EmptyKey(DelTerms,MLocKeyLen)) and (Not BalDone) then
        Begin
          Gen_BalLines;
          BalDone:=BOn;
        
          COk:=CheckCompleted(LastEdit);

          If (Not COK) then
            MULCtrlO.PageUpDn(0,BOn);

        end;

      {$ENDIF}

      If (COk) then
      Begin

        Cursor:=crHourGlass;


        OpName:=EntryRec^.LogIn;

        CheckYRef(LInv);  {* To reset index on blank *}
        OrdMatch:=BOn; {Set up so that subsequent matching ot nom works on non WOP generated Adj's}



        If (LastEdit) then
        Begin
          If (Not LViewOnly) then
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
            { CJS - 2013-10-25 - MRD2.6.09 - Transaction Originator }
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


          AdjStkDeduct(0);

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




procedure TStkAdj.EditAccount(Edit,
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




procedure TStkAdj.A1CPanelMouseUp(Sender: TObject; Button: TMouseButton;
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



procedure TStkAdj.A1CLabMouseDown(Sender: TObject; Button: TMouseButton;
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



procedure TStkAdj.A1CLabMouseMove(Sender: TObject; Shift: TShiftState;
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


procedure TStkAdj.AddN1BtnClick(Sender: TObject);

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

             {* Transfer to record, so the line is upto date *}

             With ExLocal do
               If (Mode<>2) or (EmptyKey(LInv.DelTerms,MLocKeyLen)) or (Id.Qty<0) or (LInv.DelTerms<>Id.MLocStk) then
               Begin
                 Form2Ntxfr;

                 SetNewFolio;

                 Display_Id(Mode);
               end
               else
               Begin
                 ShowMessage('It is not possible to edit an automatically generated location transfer line. Adjust the out line in order to affect the in line.');

               end;
           end;

  end; {Case..}

end;





procedure TStkAdj.DelN1BtnClick(Sender: TObject);
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

procedure TStkAdj.SwiN1BtnClick(Sender: TObject);
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

procedure TStkAdj.FindN1BtnClick(Sender: TObject);
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
          DontHide:=[1,3];

        //PR: 04/12/2013 ABSEXCH-14824
        Ctrl_GlobalFind(Self, ReturnCtrl, tabFindStock);

      end;
    end; {If in list find..}

  {$ENDIF}
end;


procedure TStkAdj.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    N3.Tag:=99;

    PopUp(X,Y);
  end;


end;

procedure TStkAdj.PopupMenu1Popup(Sender: TObject);
Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  {$IFDEF CU}
  // Update the custom Menu item captions to match the custom button captions.
  Custom1.Caption:=CustTxBtn1.Caption;
  Custom2.Caption:=CustTxBtn2.Caption;
  // 28/01/2013 PKR ABSEXCH-13449
  // Custom buttons 3..6 now available
  Custom3.Caption:=CustTxBtn3.Caption;
  Custom4.Caption:=CustTxBtn4.Caption;
  Custom5.Caption:=CustTxBtn5.Caption;
  Custom6.Caption:=CustTxBtn6.Caption;
  {$ENDIF}

  With InvBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end; {With..}

end;


function TStkAdj.A1TPerFShowPeriod(Sender: TObject;
  const EPr: Byte): string;
begin
  Result:=PPr_Pr(EPr);
end;


procedure TStkAdj.SetNewFolio;

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

    { CJS - 2013-10-25 - MRD2.6.09 - Transaction Originator }
    TransactionOriginator.SetOriginator(LInv);
    A1OpoF.Hint := GetOriginatorHint(LInv);

        {* Force add of header now *}
    If (LSecure_Add(InvF,SKeypath,0)) then
      Add_DocEditNow(LInv.FolioNum);


    RefreshList(BOff,BOff);
  end;
end;



procedure TStkAdj.A1LocTxFExit(Sender: TObject);
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


procedure TStkAdj.THUD1FEntHookEvent(Sender: TObject);
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
                                  If (Sender=A1YRefF) then
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

procedure TStkAdj.THUD1FExit(Sender: TObject);
var
  UDFs: array [1..10] of TCustomEdit;
  LastUDF: TCustomEdit;
  VisibleUDFCount: Integer;
  i: Integer;
  UpperBound, LowerBound: Integer;
begin
  If (Sender is Text8Pt)  and (ActiveControl<>CanN1Btn) and (ActiveControl<>ClsN1Btn) then
  Begin

    Text8pt(Sender).ExecuteHookMsg;

  end;

//PR: 06/03/2012 ABSEXCH-12620 Commented out the code below, since it doesn't seem to be necessary and causes an
//exception when the In-Location edit is invisible - eg UseLocations disabled or non-Spop versions. Also amended tab order
//on form to match pre-69 tab order.

(*
  //GS 22/11/2011 ABSEXCH-12181: use code to manipulate tab / focus flow;
  //when the user tabs out of the last UDF; shift focus to the location input box

  //because UDFs can be disabled / enabled, we need to determine which one is the 'last visible UDF':
  //once we know this, and when the user exits this control, we can shift focus where we like

  //create an array of UDF fields
  UDFs[1] := THUD1F;
  UDFs[2] := THUD2F;
  UDFs[3] := THUD3F;
  UDFs[4] := THUD4F;
  UDFs[5] := THUD5F;
  UDFs[6] := THUD6F;
  UDFs[7] := THUD7F;
  UDFs[8] := THUD8F;
  UDFs[9] := THUD9F;
  UDFs[10] := THUD10F;

  //determine how many are visible
  VisibleUDFCount := NumberOfVisibleUDFs(UDFs);

  //if there are any visible fields..
  if VisibleUDFCount > 0 then
  begin
    //iterate through the array (back to front) and get a reference to the first visible field
    UpperBound := High(UDFs);
    LowerBound := Low(UDFs);
    for i := UpperBound downto LowerBound do
    begin
      if UDFs[i].Visible = True then
      begin
        //we found what we needed, save a reference and exit the interation
        LastUDF := UDFs[i];
        Break;
      end;
    end;
    //if the user has tabbed out of the last UDF, then shift focus to the 'location' input control
    if Sender = LastUDF then
    begin
      A1LocTxF.SetFocus;
    end;
  end;
*)
end;



procedure TStkAdj.OkN1BtnClick(Sender: TObject);
begin

  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult = mrOk) then
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

          Begin
            Close;
            Exit;
          end;
        end;
    end; {With..}
end;




procedure TStkAdj.Display_Id(Mode  :  Byte);


Begin

  If (IdLine=nil) then
  Begin

    IdLine:=TAdjLine.Create(Self);

  end;

  Try


   With IdLine do
   Begin

     WindowState:=wsNormal;
     {Show;}


     InvBtnList.SetEnabBtn(BOff);

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



procedure TStkAdj.DeleteNTLine;

Var
  MbRet  :  Word;
  KeyS   :  Str255;

Begin

  With ExLocal,MULCtrlO do
    If (PageKeys^[MUListBoxes[0].Row]<>0) and (ValidLine) and (Not InListFind) then
    Begin
      If (EmptyKey(LInv.DelTerms,MLocKeyLen)) or (Id.Qty<0) or (LInv.DelTerms<>Id.MLocStk) then
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

            Deduct_AdjStk(LId,LInv,BOff);

            {$IFDEF SOP}

              Self.Enabled:=BOff;

              Control_SNos(LId,LInv,LStock,3,Self);

              Self.Enabled:=BOn;
              Self.Show;

            {$ENDIF}

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
      end
      else
        ShowMessage('It is not possible to delete an automatically generated location transfer line. Adjust the out line in order to affect the in line.');

    end; {If line is valid for deletion..}
end; {PRoc..}


procedure TStkAdj.A1TDateFExit(Sender: TObject);
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


procedure TStkAdj.SetFieldProperties;

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


procedure TStkAdj.SetFormProperties(SetList  :  Boolean);

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


procedure TStkAdj.PropFlgClick(Sender: TObject);
begin
  SetFormProperties((N3.Tag=99));
  N3.Tag:=0;
end;



procedure TStkAdj.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;






procedure TStkAdj.LnkN1BtnClick(Sender: TObject);
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

procedure TStkAdj.CustTxBtn1Click(Sender: TObject);
var
  // 24/01/2013 PKR ABSEXCH-13449
  eventID            : Integer;
  customButtonNumber : integer;
Begin
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
//        If ExecuteCustBtn(2000,((38+(100*Ord(Not InAddEdit)))*Ord((Sender=CustTxBtn1) or (Sender=Custom1)))+
//                      ((39+(100*Ord(Not InAddEdit)))*Ord((Sender=CustTxBtn2) or (Sender=Custom2))), ExLocal) then
        Begin
          THUD1F.Text:=LInv.DocUser1;
          THUD2F.Text:=LInv.DocUser2;
          THUD3F.Text:=LInv.DocUser3;
          THUD4F.Text:=LInv.DocUser4;
          //GS 18/10/2011 ABSEXCH-11706: put customisation values into text boxes
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

procedure TStkAdj.SetHelpContextIDs;
// NF: 22/06/06
begin
  // Fix incorrect IDs
  A1YRef2F.HelpContext := 1900;
end;


// MHYR 25/10/07
procedure TStkAdj.A1YRef2FChange(Sender: TObject);
begin
  A1YRef2F.Hint := A1YRef2F.Text;
end;

procedure TStkAdj.MenItem_AuditClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmAudit);
end;

procedure TStkAdj.MenItem_DatedClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmDated);
end;

procedure TStkAdj.MenItem_GeneralClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmGeneral);
end;

procedure TStkAdj.SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
begin
  //Called when user uses Switch from pop-up menu on Notes form
  AddN1Btn.Enabled := NewMode <> nmAudit;
  EditN1Btn.Enabled := NewMode <> nmAudit;
  InsN1Btn.Enabled := NewMode <> nmAudit;
  DelN1Btn.Enabled := NewMode <> nmAudit;
  FindN1Btn.Enabled := NewMode <> nmAudit;
end;

Initialization

end.
