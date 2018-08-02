unit HistWinU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,SBSComp,SBSComp2,ExWrap1U,BTSupU1,SupListU, Menus,
  BorBtns, TEditVal, OleCtrls, {VCFImprs,} SalTxl1U,BarGU,{VCFI,}
  {VCIFiLib_TLB,} EntWindowSettings,

  // MH 09/03/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  WindowExport, ExportListIntf, oExcelExport,

  VCFI32;


type


  TNHMList  =  Class(TGenList)

  Public
    LNHCtrl    :  TNHCtrlRec;
    BudgetTot  :  Double;
    Progress   :  TBarP;
    ViewNHist  :  HistoryRec;



    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function Get_BudgetYTD(TCode      :  Char;
                           Per        :  Byte;
                       Var Bud2,
                           Bud3,
                           Bud4       :  Double)  :  Double;

    Function Get_CommitValues(PrevNHist  :  HistoryRec)  :  HistoryRec;


    {$IFDEF STK}
      Function Get_QtyUsed(PrevNHist  :  HistoryRec)  :  HistoryRec;
    {$ENDIF}

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Procedure EditBudget(PColor  :  TColor;
                         PFont   :  TFont;
                         ORMode  :  Byte);

    Function PartHistMKey(HType  :  Char;
                          NCode  :  LongInt)  :  Str10;

    Procedure Hed_YTDType(MoveCode  :  LongInt;
                          NTyp      :  Char;
                          Fnum,
                          Keypath   :  Integer;
                      Var YTDOk,
                          YTDNCFOk  :  Boolean);

    Procedure FillBudget(NKey  :  Str255);

    {$IFDEF PF_On}

      {Function HeadCode(NRec  :  NominalRec;
                        SRec  :  StockRec;
                        Mode  :  Boolean)  :  Char;}

      Function Input_ABValue(Mode    :    Byte;
                         Var Value   :    Real)  :  Boolean;

      Function Get_Profile(NKey  :  Str255)  :  Real;

      Procedure YTD_SplitBudget(AutoValue  :  Real;
                                AutoOn     :  Boolean;
                                NKey       :  Str255);

      Procedure Copy_Budget(NKey       :  Str255;
                            Actuals    :  Boolean);


    {$ENDIF}
  end;


type
  THistWin = class(TForm)
    PageControl1: TPageControl;
    BudVarPage: TTabSheet;
    NBSBox: TScrollBox;
    NBPrPanel: TSBSPanel;
    NBHedPanel: TSBSPanel;
    NBBudLab: TSBSPanel;
    NBPrLab: TSBSPanel;
    NBBalLab: TSBSPanel;
    NBVarLab: TSBSPanel;
    NBBalPanel: TSBSPanel;
    NBBudPanel: TSBSPanel;
    NBVarPanel: TSBSPanel;
    NHDrCrPage: TTabSheet;
    NHBtnPanel: TSBSPanel;
    NHBSBox: TScrollBox;
    EditnhBtn: TButton;
    FillnhBtn: TButton;
    SetUpnhBtn: TButton;
    ProfilenhBtn: TButton;
    Clsnh1Btn: TButton;
    NHSBox: TScrollBox;
    NHPrPanel: TSBSPanel;
    NHHedPanel: TSBSPanel;
    NHCrLab: TSBSPanel;
    NHPrLab: TSBSPanel;
    NHDrLab: TSBSPanel;
    NHBalLab: TSBSPanel;
    NHDrPanel: TSBSPanel;
    NHCrPanel: TSBSPanel;
    NHBalPanel: TSBSPanel;
    NHListBtnPanel: TSBSPanel;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    Edit1: TMenuItem;
    Fill1: TMenuItem;
    SetUp1: TMenuItem;
    Profile1: TMenuItem;
    N2: TMenuItem;
    GraphPage: TTabSheet;
    GraphPanel: TSBSPanel;
    InvChk: TBorCheck;
    C1Chk: TBorCheck;
    C2Chk: TBorCheck;
    C2ModeBox: TSBSComboBox;
    C1ModeBox: TSBSComboBox;
    C3ModeBox: TSBSComboBox;
    C4ModeBox: TSBSComboBox;
    C3Chk: TBorCheck;
    C4Chk: TBorCheck;
    Label81: Label8;
    Q4Chk: TBorCheck;
    CumLab: Label8;
    Q1Chk: TBorCheck;


    GTitPanel: TSBSPanel;
    GraphTit: Label8;
    PopupMenu2: TPopupMenu;
    Enter1: TMenuItem;
    CopyL1: TMenuItem;
    CopyL2: TMenuItem;
    Update1: TMenuItem;
    PopupMenu3: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem4: TMenuItem;
    Q5Chk: TBorCheck;
    PopupMenu4: TPopupMenu;
    MenuItem3: TMenuItem;
    MenuItem5: TMenuItem;
    NBBud2Panel: TSBSPanel;
    NBBud2Lab: TSBSPanel;
    NHUsePanel: TSBSPanel;
    NHUseLab: TSBSPanel;
    RollUp1: TMenuItem;
    btnRevisions: TButton;
    RevHistory1: TMenuItem;
    WindowExport: TWindowExport;
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
    procedure Clsnh1BtnClick(Sender: TObject);
    procedure NHPrPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NHPrLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NHPrLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure C1ModeBoxChange(Sender: TObject);
    procedure VCFI1PointSelected(Sender: TObject; var Series, DataPoint,
      MouseFlags, Cancel: Smallint);
    procedure SetUpnhBtnClick(Sender: TObject);
    procedure VCFI1ApplyChanges(Sender: TObject);
    procedure EditnhBtnClick(Sender: TObject);
    procedure FillnhBtnClick(Sender: TObject);
    procedure ProfilenhBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Enter1Click(Sender: TObject);
    procedure o(Sender: TObject);
    procedure Update1Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure RollUp1Click(Sender: TObject);
    procedure btnRevisionsClick(Sender: TObject);
    function WindowExportEnableExport: Boolean;
    procedure WindowExportExecuteCommand(const CommandID: Integer;
      const ProgressHWnd: HWND);
    function WindowExportGetExportDescription: String;
  private
    { Private declarations }
    ListActive,
    GraphCreated,
    BeenIn,
    JustCreated,
    StopPageChange,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fDoingClose,
    GotCoord,
    InDestroyObjs,
    CanDelete    :  Boolean;

    GSRow,
    GERow,
    MinHeight,
    MinWidth     :  Integer;

    InvBtnList   :  TVisiBtns;

    OldNHCtrl    :  TNHCtrlRec;

    PrevCCount,
    GraphMode,
    GraphHeight  :  Integer;

    GPieList     :  TPieList;

    PagePoint    :  Array[0..4] of TPoint;

    StartSize,
    InitSize     :  TPoint;


    MULVisiList  :  Array[0..1] of TVisiList;

    { CJS 2012-08-16 - ABSEXCH-13263 - array of source controls to hold the font
                                       details for SBSComp. }
    SourceListBox: array[0..1] of TStringGridEx;

    ProfileFrm   :  THistWin;

    // MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
    FSettings : IWindowSettings;

    procedure Find_FormCoord;

    procedure FormSetOfSet;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormClose(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;



    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure MapHistVar(Var NHPfix  :  Char;
                         Var NHFolio :  Str20;
                         LNom    :  NominalRec);

    Function GetHistValue(HPr,HYr,
                          HMode     :  Byte;
                          LNom      :  NominalRec;
                          GetYTD    :  Boolean)  :  Real;

    procedure FillData(C1Mode,C2Mode,
                       C3Mode,C4Mode  :  Integer;
                       Cum1,Cum2,
                       Cum3,Cum4      :  Boolean);

    procedure CreateStripGraph(NewGraph  :  Boolean);

    procedure CreateGraphPage;

    procedure Stock2Nom;

    procedure BuildPie(C1Mode  :  Integer);

    procedure Set_SetUP;

    procedure CreateGraphPie;

    procedure Graph2Act(Const GPr,GYr  :  Byte;
                        Const LNom     :  NominalRec);

    procedure Strip2Act(Const Period,Col  :  Byte);
    procedure Pie2Act(Const Period,Col  :  Byte);

    {$IFDEF PF_On}
      procedure Display_Profile;
    {$ENDIF}

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure SetHelpContextIDsForPage; // NF: 16/05/06

  public
    { Public declarations }

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;

    NHCtrl       :  TNHCtrlRec;

    MULCtrlO   :  TNHMList;

    VCFI1: TVCFirstImpression;


    procedure PrimeButtons;

    procedure RenamePanels;

    procedure SetTabs;

    procedure BuildDesign;

    procedure FormDesign;

    procedure DestroyObjs(Sender: TObject);


    Procedure InitVisiList(PageNo  :  Byte);

    Function Current_BarPos(PageNo  :  Byte)  :  Integer;

    Procedure SetLHMode(PageNo  :  Byte);

    Procedure ChangeList(PageNo   :  Byte;
                         ShowLines:  Boolean);

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    Function Current_Page  :  Integer;

    procedure SetCaption;

    procedure ShowLink(ShowLines,
                       ShowGraph  :  Boolean);


    Procedure ChangePage(NewPage  :  Integer);
  end;


  Procedure Set_NHFormMode(State  :  TNHCtrlRec);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  VarJCstU,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,

  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  SysU1,
  SysU2,
  IntMU,
  MiscU,

  {$IFDEF STK}
    CuStkA4U,

  {$ENDIF}

  PWarnU,
  {$IFDEF JC}
    JobSup1U,

  {$ENDIF}

  PayF2U,
  CLPALU,

  RollBudU,

  {$IFDEF EXSQL}
  SQLUtils,
  SQLFuncs,
  {$ENDIF}

  Warn1U,

  //PR: 27/06/2012
  GLBudgetHistoryClass,
  GLBudgetRevisionF,
  ApiUtil,

  // CJS 2016-04-06 - ABSEXCH-17382 - GL Budget roll up - SQL improvements
  GLRollupBudgetModule,
  GLRollupBudgetDlg,
  SQLRep_Config,
  //SSK 21/02/2018 2018 R1 ABSEXCH-19778: Anonymisation
  GDPRConst;


{$R *.DFM}


Const
  GTitle  :  Array[0..8] of Str5 = ('','Act','Act','Budg','Budg','Credt','Credt','Debit','Debit');


Var
  NHFormMode  :  TNHCtrlRec;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_NHFormMode(State  :  TNHCtrlRec);

Begin

  NHFormMode:=State;

end;


{$I NHstTI1U.PAS}


Function THistWin.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;



Procedure  THistWin.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure THistWin.Find_FormCoord;
//Var
//  ThisForm:  TForm;
//
//  VisibleRect
//          :  TRect;
//
//  GlobComp:  TGlobCompRec;
Begin
  // MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
  if Assigned(FSettings) and not FSettings.UseDefaults then
  begin
    FSettings.SettingsToWindow(Self);
    FSettings.SettingsToParent(Self);
    FSettings.SettingsToParent(MulCtrlO);
  end;
  {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;
end;


procedure THistWin.FormSetOfSet;

Begin
  PagePoint[0].X:=HorzScrollBar.Range-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(NHSBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(NHSBox.Height);

  PagePoint[2].X:=PageControl1.Width-(NHBtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(NHBtnPanel.Height);

  PagePoint[3].X:=NHBtnPanel.Height-(NHBSBox.Height);
  PagePoint[3].Y:=NHSBox.ClientHeight-(NHPrPanel.Height);

  PagePoint[4].X:=PageControl1.Width-(NHListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(NHListBtnPanel.Height);

  GotCoord:=BOn;

end;



Procedure THistWin.WMCustGetRec(Var Message  :  TMessage);
Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin
              Send_UpdateList(52);
              BeenIn:=BOn;
            end;

      1  :  With OldNHCtrl do
            Begin
              If ((NHPr<>NHist.Pr) or (NHYr<>NHist.Yr) or (NHCr<>NHist.Cr) or (NHKeyCode<>NHist.Code)) and (BeenIn) then
              Begin
                NHPr:=NHist.Pr;
                NHYr:=NHist.Yr;
                NHCr:=NHist.Cr;
                NHKeyCode:=NHist.Code;

                Send_UpdateList(53);

                MULCtrlO.BeenDClick:=BOn;
              end;


            end;


      2  :  ShowRightMeny(LParamLo,LParamHi,1);
      
      25 :  NeedCUpdate:=BOn;

      {$IFDEF XPF_On}

        38  :  Begin
                 If (Assigned(MULCtrlO)) then
                   With MULCtrlO do
                     Update_GlobalBudgets(KeyRef,BOff);

               end;

      {$ENDIF}


      175  :  With PageControl1 do
                ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);


    

    end; {Case..}

  end;
  Inherited;
end;


Procedure THistWin.WMFormClose(Var Message  :  TMessage);
Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      {$IFDEF PF_On}
        8  :  If (Assigned(MULCtrlO)) then
                MULCtrlO.InitPage;
      {$ENDIF}


      41 :  ProfileFrm:=nil;


    end; {Case..}

  end;
  Inherited;
end;


Procedure THistWin.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure THistWin.Send_UpdateList(Mode   :  Integer);

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



procedure THistWin.SetCaption;


Const
  HrsMsg  :  Array[BOff..BOn] of String[20] = ('',',Hrs/Qty');


Var
  LocTit    :  Str50;
  LevelStr,
  StkCode,
  StkDesc   :  Str255;
  ShowHCurr :  Byte;
  //SSK 21/02/2018 2018 R1 ABSEXCH-19778: Anonymisation
  lTraderName: String;
Begin
  LevelStr:='Bug!';  ShowHCurr:=0;

  LocTit:=''; StkCode:=''; StkDesc:='';lTraderName:='';

  With ExLocal,NHCtrl do
  Begin
    ShowHCurr:=NHCr;

    {$IFDEF SOP}
      If (Not EmptyKey(NHLocCode,LocKeyLen)) then
        LocTit:=' - Locn : '+NHLocCode+'. ';

    {$ENDIF}

    Case NHMode of
      1  :  With LNom do
            Begin
              LevelStr:=dbFormatName(Form_Int(NomCode,0),Desc)+': History.';
            end;


      4  :  Begin
              LevelStr:=CCVATName^+' History.';
              ShowHCurr:=Syss.VATCurr;
            end;



      8  :  With LCust do
            begin
              if GDPROn and (acAnonymisationStatus = asAnonymised) then         //SSK 21/02/2018 2018 R1 ABSEXCH-19778: fix caption issue for Anonymised trader
                lTraderName := capAnonymised
              else
                lTraderName := Company;

              LevelStr := dbFormatName(CustCode, lTraderName) + ': Account History.';
            end;



      {$IFDEF STK}

         9  :  With LStock do
                 LevelStr:=dbFormatName(StockCode,Desc[1])+': History.';

         88 :  With LStock,LCust do
                  LevelStr:=dbFormatName(CustCode,'')+'.'+
                             dbFormatName(StockCode,Desc[1])+': History.';

      {$ENDIF}


      {$IFDEF PF_On}


         10  :  LevelStr:=TForm(Self.Owner).Caption+' - Budget Profile - ';

      {$ENDIF}

      19  :  With LCust do
             begin
               if GDPROn and (acAnonymisationStatus = asAnonymised) then         //SSK 21/02/2018 2018 R1 ABSEXCH-19778: fix caption issue for Anonymised trader
                 lTraderName := capAnonymised
               else
                 lTraderName := Company;
               LevelStr:=dbFormatName(CustCode,lTraderName)+': Account Margin.';
             end;

      {$IFDEF JC}
        21,22,25..27,29,
        31,32,35..37
           :  Begin
                Case NHMode of
                  21,26,31,36
                      :    With LJobMisc^,JobAnalRec do
                           Begin
                             StkCode:=JAnalCode;
                             StkDesc:=JAnalName;
                           end;

                  22,27,32,37
                      :    With LJobCtrl^,JobBudg do
                           Begin
                             StkCode:=StockCode;

                             If (Not PayRMode) then
                               StkDesc:=LStock.Desc[1];
                           end;


                  25,35
                      :    With LJobCtrl^,JobBudg do
                           Begin
                             StkCode:=StockCode;

                             StkDesc:=Major_Hed(AnalHed);
                           end;

                  29  :   With LJobMisc^,EmplRec do
                          Begin
                            LevelStr:=dbFormatName(EmpCode,EmpName)+': Labour History';
                          end;

                end; {case..}

                If (NHMode<>29) then
                  LevelStr:='(Job: '+Strip('B',[#32],LJobRec^.JobCode)+') '+Strip('B',[#32],StkCode)+'/'+
                             Strip('B',[#32],StkDesc)+HrsMsg[NHMode In [31..37]];

              end;

             50  :  With LNomView^.NomViewLine do
                    Begin
                      LevelStr:=dbFormatName(ViewCode,Desc)+': G/L View '+SetN(NomViewNo)+' History.';
                    end;


      {$ENDIF}

    end; {Case..}


    Caption:=Show_CCFilt(NHCDCode,NHCCMode)+Show_CommitMode(NHCommitView)+LocTit+LevelStr;

    If (NHMode<>10) and (Not (NHMode In [31..37])) then
      Caption:=Caption+' '+Show_TreeCur(ShowHCurr,NHTxCr);

  end;

end;


procedure THistWin.ShowLink(ShowLines,
                            ShowGraph :  Boolean);


begin

  NHCtrl:=NHFormMode;

  If (NHCtrl.NHMode In [9,88]) then
    Stock2Nom;

  ExLocal.AssignFromGlobal(NomF);
  ExLocal.AssignFromGlobal(CustF);
  ExLocal.AssignFromGlobal(StockF);

  ExLocal.AssignFromGlobal(NomViewF);
  ExLocal.LGetRecAddr(NomViewF);

  ExLocal.LGetRecAddr(NomF);
  ExLocal.LGetRecAddr(CustF);
  ExLocal.LGetRecAddr(StockF);


  {$IFDEF JC}
    ExLocal.AssignFromGlobal(JobF);
    ExLocal.AssignFromGlobal(JCtrlF);
    ExLocal.AssignFromGlobal(JMiscF);


    ExLocal.LGetRecAddr(JobF);
    ExLocal.LGetRecAddr(JCtrlF);
    ExLocal.LGetRecAddr(JMiscF);

  {$ENDIF}



  PrimeButtons;

  SetCaption;

  If (JustCreated) then
  Begin
    Case NHCtrl.NHMode of
         9,88
            :  Begin
                 InvChk.Checked:=BOff;
               end;

      8,19  :  Begin
                 InvChk.Checked:=Not IsACust(ExLocal.LCust.CustSupp);
                 C1Chk.Checked:=(NHCtrl.NHMode<>8);
                 C2Chk.Checked:=C1Chk.Checked;
                 C3Chk.Checked:=C1Chk.Checked;
                 C4Chk.Checked:=C1Chk.Checked;
               end;
    else       InvChk.Checked:=BOn;
    end; {Case..}

    GraphPage.TabVisible:=(Not (NHCtrl.NHMode In [4,10]));

    {$IFDEF LTE}
      BudVarPage.TabVisible:=(Not (NHCtrl.NHMode In [4]));
    {$ENDIF}

  end; {Begin..}


  ReFreshList(ShowLines,Not JustCreated);

  If (JustCreated) and (NHCtrl.NHMode=10) then
  Begin
    ChangePage(1);
    SetTabs;
  end;

  If (GraphCreated) or (ShowGraph) then
  Begin
    CreateGraphPage;

    If (ShowGraph) and (Current_Page<>2) then
      ChangePage(2);
  end;

  If (JustCreated) then {* fix 256 colour problem *}
  Begin
    MDI_ForceParentBKGnd(BOff);

    If (GraphCreated) and (ShowGraph) then
    Begin
      VCFI1.Repaint:=BOff;
      VCFI1.Repaint:=BOn;
    end;
  end;

  JustCreated:=BOff;

  // MH 13/03/2018 2018-R2 ABSEXCH-19172: Need to reevaluate here as the FormActivate occurs before NHCtrl has been populated
  WindowExport.ReevaluateExportStatus;
end;


procedure THistWin.PrimeButtons;

Var
  n,
  PageNo  :  Integer;

  ShowEdit,
  NotHed,
  NotPro  :  Boolean;

Begin
  PageNo:=Current_Page;

  {$IFDEF PF_On}
    NotPro:=BOff;
  {$ELSE}
    NotPro:=BOn;
  {$ENDIF}

  ShowEdit:=(NHCtrl.NHMode In [21,22,25..27,29,31,32,35..37]);

  {$IFDEF LTE}
    RollUp1.Visible:=BOff;

  {$ELSE}
    RollUp1.Visible:=Syss.UseCCDep and (NHCtrl.NHMode In [1,10]) ;

  {$ENDIF}

  If (Assigned(MULCtrlO)) then
  With ExLocal do
  Begin
    Case NHCtrl.NHMode of
      1,10  :  NotHed:=(LNom.NomType<>NomHedCode);
      9,88  :  NotHed:=(LStock.StockType<>StkGrpCode);
      else     NotHed:=BOn;
    end; {Case..}
  end
  else
    NotHed:=BOn;

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
        Begin
          //PR: 28/06/2012 ABSEXCH-12957 Add revisions button
     {0}  AddVisiRec(btnRevisions,BOff);
     {1}  AddVisiRec(EditNHBtn,BOff);
     {2}  AddVisiRec(FillNHBtn,BOff);
     {3}  AddVisiRec(SetUpNHBtn,BOff);
     {4}  AddVisiRec(ProfileNHBtn,BOff);
        end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    With InvBtnList do
    Begin


      NHBSBox.Visible:=(PageNo<>0) or (ShowEdit);

      //PR: 28/06/2012 ABSEXCH-12957 Add revisions button (and increment numbers on others so revisions is at the top)
      //PR: 27/07/2012 ABSEXCH-13223 Check that this is GL History window (NHMode = 1)
      SetHideBtn(0,((PageNo<>1) and (Not ShowEdit)) or (NHCtrl.NHMode <> 1) ,BOff);
      //PR: 02/11/2012 ABSEXCH-13640 Add Rev History menu item.
      RevHistory1.Visible := btnRevisions.Visible;
      SetHideBtn(1,(PageNo<>1) and (Not ShowEdit),BOff);
      SetHideBtn(2,(PageNo<>1) and (Not ShowEdit),BOff);
      SetHideBtn(3,(((PageNo<>1) or (NotPro)) and (PageNo<>2)),BOff);
      SetHideBtn(4,((PageNo<>1) or (NotPro) or (NotHed) or (NHCtrl.NHMode=10)),BOn);

    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure THistWin.RenamePanels;
Begin
  With MULCtrlO,VisiList,NHCtrl do
  Begin
    Case Current_Page of
      0  :  Case NHMode of

              4  :  Begin
                      IdPanel(1,BOn).Caption:=CCVATName^+Spc(4);
                      IdPanel(2,BOn).Caption:='NETT'+Spc(4);
                      IdPanel(3,BOn).Caption:='';
                    end;

              {$IFDEF STK}

                9,88
                   :  Begin
                        IdPanel(1,BOn).Caption:='Qty Sold'+Spc(4);
                        IdPanel(2,BOn).Caption:='Sales'+Spc(4);
                        IdPanel(3,BOn).Caption:='Margin'+Spc(4);
                       
                      end;
              {$ENDIF}

              19 :  Begin
                      IdPanel(1,BOn).Caption:='Sales'+Spc(4);
                      IdPanel(2,BOn).Caption:='Margin'+Spc(4);
                      IdPanel(3,BOn).Caption:='GP%'+Spc(4);
                    end;


              {$IFDEF JC}

                21,22,25,31,32,35
                   :  Begin
                        IdPanel(1,BOn).Caption:='Actual'+Spc(4);
                        IdPanel(2,BOn).Caption:='Original Budget'+Spc(4);
                        IdPanel(3,BOn).Caption:='Revised Budget'+Spc(4);
                      end;
              {$ENDIF}

              else  Begin
                      IdPanel(1,BOn).Caption:='Debit'+Spc(4);
                      IdPanel(2,BOn).Caption:='Credit'+Spc(4);
                      IdPanel(3,BOn).Caption:='Balance'+Spc(4);
                    end;

            end; {Case..}


    end; {Case..}
  end; {With..}
end;


procedure THistWin.BuildDesign;


begin

  {* Set Version Specific Info *}


end;

procedure THistWin.SetTabs;
Begin
  {* Hide page 0&2 for profile view *}

  {NHDrCrPage.TabVisible:=(NHCtrl.NHMode<>10);}
  GraphPage.TabVisible:=(Not (NHCtrl.NHMode In [4,10]));


  If (NHCtrl.NHMode=10) then
    BudVarPage.Caption:='Profile';


end;

procedure THistWin.FormDesign;


begin

  if SQLUtils.UsingSQL and SQLReportsConfiguration.UseSQLRollupGLBudgets then
  begin
    Update1.Visible := False;
    RollUp1.Caption := '&Roll Up Budgets';
  end;

  C1ModeBox.ItemIndex:=1;
  C2ModeBox.ItemIndex:=3;
  C3ModeBox.ItemIndex:=2;
  C4ModeBox.ItemIndex:=4;

  Q1Chk.Checked:=(GetLocalPr(0).CPr<=Trunc(Syss.PrInYr/2));
  Q4Chk.Checked:=Not Q1Chk.Checked;

  PrimeButtons;

  BuildDesign;

end;


Procedure THistWin.InitVisiList(PageNo  :  Byte);

Var
  n,
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

                AddVisiRec(NBPrPanel,NBPrLab);
                AddVisiRec(NBBalPanel,NBBalLab);
                AddVisiRec(NBBudPanel,NBBudLab);
                AddVisiRec(NBBud2Panel,NBBud2Lab);
                AddVisiRec(NBVarPanel,NBVarLab);

                LabHedPanel:=NBHedPanel;

                SetHidePanel(4,BOff,BOn);

                With MULCtrlO do
                Begin
                  ColAppear^[4]:=ColAppear^[3];

                  // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
                  ColAppear^[0].ExportMetadata := emtForceText;
                  ColAppear^[1].ExportMetadata := emtCurrencyAmount;
                  ColAppear^[2].ExportMetadata := emtCurrencyAmount;
                  ColAppear^[3].ExportMetadata := emtCurrencyAmount;
                  ColAppear^[4].ExportMetadata := emtCurrencyAmount;

                  For n:=0 to MUTotCols do
                  With ColAppear^[n] do
                  Begin
                    AltDefault:=BOn;

                    If (n In [0..4]) then
                    Begin
                      DispFormat:=SGFloat;

                      If (n=0) then
                        NoDecPlaces:=0
                      else
                        If (NHCtrl.NHMode In [9,88]) and (n In [1..4]) then
                        Begin
                          NoDecPlaces:=Syss.NoQtyDec;
                          // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
                          ColAppear^[n].ExportMetadata := emtQuantity
                        End // If (NHCtrl.NHMode In [9,88]) and (n In [1..4])
                        else
                          If (NHFormMode.NHMode In [35]) and (n In [1..3]) then
                          Begin
                            Case n of
                              1  :  Begin
                                      NoDecPlaces:=Syss.NoQtyDec;
                                      // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
                                      ColAppear^[n].ExportMetadata := emtQuantity;
                                    End;
                              else  NoDecPlaces:=Syss.NoCOSDec;
                            end;
                          end
                          else
                            NoDecPlaces:=2;
                    end;
                  end;

                end;

                Case NHCtrl.NHMode of

                  9,88
                      :  Begin
                           IdPanel(1,BOn).Caption:='Qty'+spc(5);
                           IdPanel(2,BOn).Caption:='Forecast'+spc(5);
                           IdPanel(3,BOn).Caption:='Revised Forecast'+spc(5);
                           IdPanel(4,BOn).Caption:='Variance'+Spc(5);
                         end;

                  10  :  Begin
                          IdPanel(1,BOn).Caption:='Budget'+Spc(4);
                          IdPanel(2,BOn).Caption:='%'+Spc(4);
                          IdPanel(4,BOn).Caption:='Profile'+Spc(4);
                        end;

                  else   Begin

                           Case NHCtrl.NHMode of
                             19  :  IdPanel(1,BOn).Caption:='Margin'+Spc(5);
                             else   IdPanel(1,BOn).Caption:='Balance'+Spc(5);
                           end; {Case..}

                           IdPanel(2,BOn).Caption:='Budget'+Spc(5);
                           IdPanel(3,BOn).Caption:='Revised Budget'+Spc(5);
                           IdPanel(4,BOn).Caption:='Variance'+Spc(5);
                         end;

                end; {Case..}


                Case NHCtrl.NHMode of {Hide panel 3 for profiles & VAT/GST}

                   4  :   SetHidePanel(3,BOn,BOn);

                  10    :  SetHidePanel(3,BOn,BOn);


                end; {Case..}
              end;

      end; {Case..}

      With MULCtrlO do
      Begin
        VisiList:=MULVisiList[PageNo];
        { CJS 2012-08-16 - ABSEXCH-13263 - Make sure that SBSComp uses the
                                           correct source control for the font
                                           details. }
        MUListBox1 := SourceListBox[PageNo];
        MulCtrlO.Name := 'List' + IntToStr(PageNo);

        // MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
        FSettings.SettingsToParent(MULCtrlO);
      end;

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


Function THistWin.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      0
         :  Result:=NHSBox.HorzScrollBar.Position;
      1
         :  Result:=NBSBox.HorzScrollBar.Position;

      else  Result:=0;
    end; {Case..}


end;


Procedure THistWin.SetLHMode(PageNo  :  Byte);
Begin
  With MULCtrlO do
  Case PageNo of

      0  :  LNHCtrl.NHMode:=NHCtrl.NHMode;

      1  :  LNHCtrl.NHMode:=NHCtrl.NBMode;

   end; {case..}
end;

Procedure THistWin.ChangeList(PageNo   :  Byte;
                              ShowLines:  Boolean);


Begin


  With MULCtrlO do
  Begin

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
    Name := 'List' + IntToStr(PageNo);

    { CJS 2012-09-04 - ABSEXCH-13363 - Grid index out of range }
    RefreshAllCols;

    NHListBtnPanel.Parent:=PageControl1.Pages[PageNo];


    SetLHMode(PageNo);

    ReAssignCols;


    If (ShowLines) then
    Begin
      PageUpDn(0,BOn);

      VisiList.SetHedPanel(ListOfSet+Current_BarPos(PageNo));
    end;


  end; {With..}

end;




procedure THistWin.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeyLen     :  Integer;
{$IFDEF EXSQL}
  Where       :  Str255;
  HexCode     :  string;
{$ENDIF}
Begin

  KeyStart:=NHCtrl.MainK;
  LKeyLen:=NHCtrl.NHKeyLen;

{$IFDEF EXSQL}
  Where := '';
  if SQLUtils.UsingSQLAlternateFuncs then
  begin
    HexCode := StringToHex(Copy(KeyStart, 2, 20), 20);
    if (KeyStart <> '') then
      Where := '[hiExClass] = '  + IntToStr(Ord(Copy(KeyStart, 1, 1)[1])) + ' AND ' +
               '[hiCodeComputed] = ' + HexCode;
  end;
{$ENDIF}

  RenamePanels;

  With MULCtrlO do
  Begin
    LNHCtrl:=NHCtrl;
    Blank(ViewNHist,Sizeof(ViewNHist));

    SetLHMode(Current_Page);

    IgnoreMsg:=IgMsg;

    Fill2End:=BOn;

    StartList(NHistF,NHK,KeyStart,'','',LKeyLen,(Not ShowLines){$IFDEF EXSQL}, Where{$ENDIF});

    IgnoreMsg:=BOff;

    KeyRef:=NHCtrl.AltMainK; {* Reset start key, as otherwise home does not work... *}

    Fill2End:=BOff;

  end;

end;


procedure THistWin.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TNHMList.Create(Self);

  StartPanel := nil; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390

  Try

    With MULCtrlO do
    Begin
      { CJS 2012-08-16 - ABSEXCH-13263 - Set the name so that the window
                                         settings are found. }
      MULCtrlO.Name := 'List0';

      Try

        With VisiList do
        Begin
          AddVisiRec(NHPrPanel,NHPrLab);
          AddVisiRec(NHDrPanel,NHDrLab);
          AddVisiRec(NHCrPanel,NHCrLab);
          AddVisiRec(NHBalPanel,NHBalLab);
          AddVisiRec(NHUsePanel,NHUseLab);

          // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
          ColAppear^[0].ExportMetadata := emtForceText;
          ColAppear^[1].ExportMetadata := emtCurrencyAmount;
          ColAppear^[2].ExportMetadata := emtCurrencyAmount;
          ColAppear^[3].ExportMetadata := emtCurrencyAmount;
          ColAppear^[4].ExportMetadata := emtCurrencyAmount;

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=NHHedPanel;

          SetHidePanel(3,(NHFormMode.NHMode In [4]),BOn);

          SetHidePanel(4,(Not (NHFormMode.NHMode In [9,88])),BOn);

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;

      ListOfSet:=10;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=4;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [0..4]) then
        Begin
          DispFormat:=SGFloat;

          If (n=0) then
            NoDecPlaces:=0
          else
            If (NHFormMode.NHMode In [9,88]) and (n In [1,4]) then
            Begin
              NoDecPlaces:=Syss.NoQtyDec;
              // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
              ColAppear^[n].ExportMetadata := emtQuantity;
            End // If (NHFormMode.NHMode In [9,88]) and (n In [1,4])
            else
              If (NHFormMode.NHMode In [35]) and (n In [1..3]) then
              Begin
                Case n of
                  1  :  Begin
                          NoDecPlaces:=Syss.NoQtyDec;
                          // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
                          ColAppear^[n].ExportMetadata := emtQuantity;
                        End;
                  else  NoDecPlaces:=Syss.NoCOSDec;
                end;
              end
              else
                NoDecPlaces:=2;
        end;
      end;


      ListLocal:=@ExLocal;

      Find_FormCoord;

      ListCreate;

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      MULVisiList[0]:=VisiList;
      { CJS 2012-08-16 - ABSEXCH-13263 - Take a copy of the default source control. }
      SourceListBox[0] := MUListBox1;

      HighLiteStyle[1]:=[fsBold,fsUnderline];

      Set_Buttons(NHListBtnPanel);

      { CJS 2012-09-03 - ABSEXCH-13352 - font sizing issues on Stock History }
      {
      For n:=1 to High(MULVisiList) do
      Begin
        If (MULVisiList[n]=nil) then
          InitVisiList(n);
      end;
      }

      ChangeList(0, False);

      ReFreshList(ShowLines,BOff);

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;



  FormSetOfSet;

  FormReSize(Self);

end;


Procedure THistWin.ChangePage(NewPage  :  Integer);


Begin
  SetHelpContextIDsForPage; // NF: 16/05/06 Fixes for incorrect Context IDs

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}




procedure THistWin.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    If (Current_Page<>2) then
      Release_PageHandle(Sender);
    LockWindowUpDate(Handle);
  end;
end;

procedure THistWin.PageControl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;


begin
  SetHelpContextIDsForPage; // NF: 16/05/06 Fixes for incorrect Context IDs

  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      {$B-}

        If (NewIndex=2) or (MULVisiList[NewIndex]<>nil) then
          LockWindowUpDate(0);

      {$B+}

      DeleteSubMenu(SetUp1);

      PrimeButtons;

      Case NewIndex of

        0,1  :  Begin
                  Case NHCtrl.NHMode of
                    10  :  CreateSubMenu(PopUpMenu3,SetUp1);
                    // CJS 2016-04-19 - ABSEXCH-17431 - UI mods for SQL GL Budget changes
                    // Remove Update All Heading Budgets option from right-click menu
                    else CreateSubMenuSuffix(PopUpMenu2, SetUp1, 'X', True);
                  end; {Case..}

                  ChangeList(NewIndex,BOn);

                  If (MULCtrlO<>nil) and (ListActive) then
                    MULCtrlO.SetListFocus;

                end;

          2  :  Begin
                  If (Not GraphCreated) then
                    CreateGraphPage;
                end;

      end; {Case..}


      MDI_UpdateParentStat;

    end; {With..}

  // MH 09/03/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  WindowExport.ReevaluateExportStatus;

  LockWindowUpDate(0);
end;


procedure THistWin.FormCreate(Sender: TObject);

Var
  n       :  Integer;

begin
{$IFDEF HM}
  {ShowMessage ('THistWin.FormCreate');}
{$ENDIF}
  ExLocal.Create;

  LastCoord:=BOff;

  JustCreated:=BOn;

  InDestroyObjs:=BOff;
  fDoingClose:=BOff;

  StopPageChange:=BOff;
  NeedCUpdate:=BOff;

  GraphMode:=0;
  GraphCreated:=BOff;

  VCFI1:=nil;

  GPieList:=nil;
  ProfileFrm:=nil;

  // CJS 23/03/2011 - ABSEXCH-10544
  InitSize.Y:=298;
  InitSize.X:=546;

  PrevCCount:=1;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=338;
  Width:=440;}

  {GraphHeight:=GraphPage.Height-VCFI1.Height;}
  GraphHeight:=-32;

  MinHeight:=292;
  MinWidth:=543;

  BeenIn:=BOff;

  PageControl1.ActivePage:=NHDrCrPage;

  ListActive:=BOff;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  // MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
  //PR: 27/05/2011 Change to use ClassName rather than Name as identifier - if there are
  //2 instances of the form in existence at the same time, Delphi will change the name of one to Name + '_1' (ABSEXCH-11426)
  FSettings := GetWindowSettings(Self.ClassName);
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  FormDesign;

  FormBuildList(BOff);

  SetHelpContextIDsForPage; // NF: 16/05/06 Fixes for incorrect Context IDs
end;



procedure THistWin.DestroyObjs(Sender: TObject);

Var
  n  :  Byte;
begin
  InDestroyObjs:=BOn;

  GotCoord:=BOff; {* Just incase form resixe called whilts in the middle of all this... *}

  ExLocal.Destroy;

  If (InvBtnList<>nil) then
    InvBtnList.Free;


  If (Assigned(MULCtrlO)) then
  With MULCtrlO do
  Begin
    VisiList:=MULVisiList[0];
    MULCtrlO.Name := 'List0';
    { CJS 2012-08-16 - ABSEXCH-13263 - Restore the original source control. }
    MUListBox1 := SourceListBox[0];
  end;


  For n:=1 to High(MULVisiList) do
  begin
    If (MULVisiList[n]<>nil) then
    Begin
      MULVisiList[n].Free;
      MULVisiList[n]:=nil;
    end;
    { CJS 2012-08-16 - ABSEXCH-13263 - free the source control }
    if (SourceListBox[n] <> nil) then
    begin
      SourceListBox[n].Free;
      SourceListBox[n] := nil;
    end;
  end;

  If (GPieList<>nil) then
  Begin
    GPieList.Free;
    GPieList:=nil;
  end;

  If (MULCtrlO<>nil) and (fDoingClose) then
  Begin
    MULCtrlO.Destroy;
    MULCtrlO:=nil;
  end;

  If (Assigned(VCFI1)) then
  Begin
    VCFI1.Free;
    VCFI1:=nil;
  end;
end;



procedure THistWin.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  If (Not InDestroyObjs) then
    DestroyObjs(Sender);

end;

procedure THistWin.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;

begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

    VertScrollBar.Position:=0;
    HorzScrollBar.Position:=0;

    // MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
    if Assigned(FSettings) and NeedCUpdate then
    begin
      // Check Debit/Credit
      If Assigned(MULVisiList[0]) Then
      Begin
        MULCtrlO.Name := 'List0';
        MULCtrlO.VisiList := MULVisiList[0];
        { CJS 2012-08-16 - ABSEXCH-13263 - Make sure the correct source control
                                           is used for the font details. }
        MULCtrlO.MUListBox1 := SourceListbox[0];

        FSettings.ParentToSettings(MULCtrlO, MULCtrlO);
      End; // If Assigned(MULVisiList[0])

      // Check Budget/Variance
      If Assigned(MULVisiList[1]) Then
      Begin
        MULCtrlO.Name := 'List1';
        MULCtrlO.VisiList := MULVisiList[1];
        { CJS 2012-08-16 - ABSEXCH-13263 - Make sure the correct source control
                                           is used for the font details. }
        MULCtrlO.MUListBox1 := SourceListbox[1];

        FSettings.ParentToSettings(MULCtrlO, MULCtrlO);
      End; // If Assigned(MULVisiList[1])

      FSettings.WindowToSettings(Self);
      FSettings.SaveSettings(StoreCoord);
      FSettings := nil;
    end;

    If (Not InDestroyObjs) then
      DestroyObjs(Sender);

    Send_UpdateList(41);

    MDI_UpdateParentBkGnd(BOn);
  end;
end;

procedure THistWin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure THistWin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure THistWin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure THistWin.FormResize(Sender: TObject);
var
  n: Byte;
  Margin: Integer;
  i: Integer;
begin
  If (GotCoord) and (Not fDoingClose) then
  Begin
    LockWindowUpdate(Handle);
    try
      MULCtrlO.LinkOtherDisp:=BOff;

      Self.HorzScrollBar.Position:=0;
      Self.VertScrollBar.Position:=0;

      // Note: Using NHDrCrPage.Left as a generic divider measurement
      Margin := NHDrCrPage.Left;

//    PageControl1.Width := Self.ClientWidth - (2 * Margin) + 1;
//    PageControl1.Height := Self.ClientHeight - (2 * Margin) + 1;
      PageControl1.Width := ClientWidth - 4;
      PageControl1.Height := ClientHeight - 4;

      // Button Panel
      NHBtnPanel.Top := NHDrCrPage.Top;
      NHBtnPanel.Height := NHDrCRPage.ClientHeight - (2 * Margin);
      NHBtnPanel.Left := NHDrCRPage.ClientWidth - NHBtnPanel.Width - Margin;

      // Buttons scroll-box in button panel
      NHSBox.Height := NHBtnPanel.Height - NHSBox.Top - 1;

      // List scroll up/down panel
      NHListBtnPanel.Left := NHBtnPanel.Left - NHListBtnPanel.Width - Margin;

      // List Scroll Box
      NHSBox.Width := NHListBtnPanel.Left - NHSBox.Left;
      NHSBox.Height := NHDrCrPage.ClientHeight - Margin - NHSBox.Top;

      //GS 08/07/2011 ABSEXCH-11384: adjust the width and height of the NBSBox (budget tab list)
      NBSBox.Width := NHSBox.Width;
      NBSBox.Height := NHSBox.Height;

      If (Assigned(VCFI1)) then
      Begin
        VCFI1.Height:=GraphPage.Height-GraphHeight;
        VCFI1.Width:=GraphPage.Width-NHBtnPanel.Width;
      end;

      If (MULCtrlO<>nil) then
      Begin
        For n:=High(MULVisiList) downto 0 do
        If (MULVisiList[n]<>nil) then
        Begin
          MULCtrlO.VisiList:=MULVisiList[n];
          MULCtrlO.Name := 'List' + IntToStr(n);
          { CJS 2012-08-16 - ABSEXCH-13263 - Make sure the correct source control
                                             is used for the font details. }
          MULCtrlO.MUListBox1 := SourceListbox[n];

          With MULCtrlO,VisiList do
          Begin
            VisiRec:=List[0];



            //GS
            if n = 0 then
            begin
              i := NHSBox.ClientHeight;
              With (VisiRec^.PanelObj as TSBSPanel) do
                Height := (i - NHHedPanel.Height) - 10;
            end;//end if

            if n = 1 then
            begin
              i := NBSBox.ClientHeight;
              With (VisiRec^.PanelObj as TSBSPanel) do
                Height := (i - NBHedPanel.Height) - 10;
            end;//end if

            RefreshAllCols;
          end;
        end; {Loop..}

        MULCtrlO.ReFresh_Buttons;

        If (Current_Page<>2) then
          With MULCtrlO do
          Begin
            VisiList:=MULVisiList[Current_Page];
            MULCtrlO.Name := 'List' + IntToStr(Current_Page);
            { CJS 2012-08-16 - ABSEXCH-13263 - Make sure the correct source control
                                               is used for the font details. }
            MULCtrlO.MUListBox1 := SourceListbox[Current_Page];
            RefreshAllCols;
          end;

      end;{Loop..}

      //GS 08/07/2011 ABSEXCH-11384: removed code that resizes the height of the list scroll bar;
      //instead of adjusting the SB in code, i have anchored it to the bottom of the form, so the
      //program adjusts the height automatically
      //NHListBtnPanel.Height := NHPrPanel.Height;

      NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
    finally
      LockWindowUpdate(0);
      MULCtrlO.LinkOtherDisp:=BOn;
    end;
  end; {If time to update}
end;



procedure THistWin.Clsnh1BtnClick(Sender: TObject);
begin
  Close;
end;

procedure THistWin.NHPrPanelMouseUp(Sender: TObject; Button: TMouseButton;
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

end;


procedure THistWin.NHPrLabMouseDown(Sender: TObject; Button: TMouseButton;
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


procedure THistWin.NHPrLabMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
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


(*** MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
procedure THistWin.SetFormProperties;


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
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,'History Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);
        
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

end; ***)

procedure THistWin.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure THistWin.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  DeleteSubMenu(Edit1);

  If (NHCtrl.NHMode In  [1,8,9,11,12,21,22,25..27,29,31,32,35..37,50,91,92])  and (Edit1.Visible) then {* All double budget modes, offer either to edit *}
    CreateSubMenu(PopUpMenu4,Edit1);

  With InvBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end; {With..}

end;



procedure THistWin.PropFlgClick(Sender: TObject);
begin
  // MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
  if Assigned(FSettings) then
    if FSettings.Edit(MulCtrlO, MulCtrlO) = mrOK then
      NeedCUpdate := True;
end;

procedure THistWin.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;


procedure THistWin.MapHistVar(Var NHPfix  :  Char;
                              Var NHFolio :  Str20;
                                  LNom    :  NominalRec);


Begin
  With NHCtrl do
  Begin
    Case NHMode of
      8  :  With ExLocal,LCust do
            Begin
              NHPfix:=CustHistAry[1];
              NHFolio:=FullNCode(CustCode);
            end;
     19  :  With ExLocal,LCust do
            Begin
              NHPfix:=CustHistAry[3];
              NHFolio:=FullNCode(CustCode);
            end;

     {$IFDEF JC}
       21,22,25..27,
       31,32,35..37
           :
              With ExLocal,LJobCtrl^.JobBudg do
              Begin
                If (Not NHCommitMode) then
                  NHPFix:=LJobRec^.JobType
                else
                  NHPFix:=CommitHCode;

                NHFolio:=FullJDHistKey(JobCode,HistFolio);

              end;

       29
           :
              With ExLocal,LJobMisc^.EmplRec do
              Begin
                NHPFix:=EmpHistCode;

                NHFolio:=FullEmpKey(EmpCode);

              end;


     {$ENDIF}

       50  :  With ExLocal,LNomView^.NomViewLine do
              Begin
                NHPfix:=ViewType;

                NHFolio:=PostNVIdx(NomViewNo,ABSViewIdx);
              end;

     else   With LNom do
            Begin
              NHPfix:=NomType;

              Case NHMode of
                {$IFDEF STK}
                  9  :  NHFolio:=CalcKeyHist(NomCode,NHLocCode);

                  88 :  NHFolio:=Calc_CStkNHKeyHist(NHCtrl);
                {$ELSE}
                  9  :  ;
                {$ENDIF}



                else  NHFolio:=CalcCCKeyHistP(NomCode,NHCCMode,NHCDCode);
              end; {Case..}
            end;
    end; {Case..}
  end;
end;



Function THistWin.GetHistValue(HPr,HYr,
                               HMode     :  Byte;
                               LNom      :  NominalRec;
                               GetYTD    :  Boolean)  :  Real;

Var
  NomBal,
  Purch,
  Sales,
  Cleared,
  Budget1,
  Budget2,

  BV1,BV2,
  ComNomBal,
  ComPurch,
  ComSales,
  ComCleared,
  ComBudget1,
  ComBudget2,

  ComBV1,ComBV2
           :  Double;

  NHPfix   :  Char;
  NHFolio  :  Str20;


Begin
  With NHCtrl do
  Begin
    MapHistVar(NHPfix,NHFolio,LNom);

    NomBal:=0.0; Purch:=0.0; Sales:=0.0; Cleared:=0.0; Budget1:=0.0; Budget2:=0.0;    BV1:=0.0; BV2:=0.0;

    {$IFDEF SOP}
      If (NHCommitView In [0,1]) or (Not CommitAct) then {* its either actuals or combined *}
        NomBal:=Total_Profit_To_Date(NHPfix,NHFolio,NHCr,HYr,HPr,Purch,Sales,Cleared,Budget1,Budget2,BV1,BV2,GetYTD);

      If (NHCommitView In [1,2]) and (CommitAct) then {* Go get commitment value *}
      Begin
        ComNomBal:=Total_Profit_To_Date(NHPfix,CommitKey+NHFolio,NHCr,HYr,HPr,ComPurch,ComSales,ComCleared,ComBudget1,ComBudget2,ComBV1,ComBV2,GetYTD);

        NomBal:=NomBal+ComNomBal;
        Purch:=Purch+ComPurch;
        Sales:=Sales+ComSales;
      end;

    {$ELSE}
      NomBal:=Total_Profit_To_Date(NHPfix,NHFolio,NHCr,HYr,HPr,Purch,Sales,Cleared,Budget1,Budget2,BV1,BV2,GetYTD);
    {$ENDIF}

    Case HMode of

      1,2  :  Case NHMode of
                9,12,31,32,35,88
                      :  Result:=Cleared;
                else     Result:=NomBal;
              end;
      3,4  :  Case NHMode of
                21,22,25..27,29,31,32,35..37
                      :  Result:=Budget2;
                else     Result:=Budget1;
              end;

      5,6  :  Result:=Purch;
      7,8  :  Result:=Sales;
      else    Result:=0;

    end; {Case..}

    {$B+}
    If (NHMode In  [21,22,25..27,
                   31,32,35..37])  then {* All JC modes, invert *}
    {$B-}
    Begin
      Result:=Result*-1;
    end;

  end; {With..}

end;


procedure THistWin.FillData(C1Mode,C2Mode,
                            C3Mode,C4Mode  :  Integer;
                            Cum1,Cum2,
                            Cum3,Cum4      :  Boolean);


Var
  TCnst,
  DCnst,
  LoopMode,
  NewRows,
  n,m  :  Integer;

  Loop,
  GYr  :  Byte;

  GFin :  Array[1..4] of Byte;

  HasValues,
  AllZero,
  Cuml :  Boolean;

  GSeries
       :  Array[1..4,1..99] of Double;

  Rnum :  Real;

  VCIWith  :  Variant;


Begin
  If (Assigned(VCFI1)) then
  Begin

      Loop:=1;  AllZero:=BOff; HasValues:=BOff;

      FillChar(GSeries,Sizeof(GSeries),0);

      If (InvChk.Checked) then
        DCnst:=-1
      else
        DCnst:=1;

      If (Q5Chk.Checked) then
        TCnst:=1000
      else
        TCnst:=1;

      LoopMode:=C1Mode;

      Cuml:=Cum1;

      If (Q1Chk.Checked) then
        GSRow:=1
      else
        GSRow:=Trunc(Syss.PrInYr/2);

      If (Q4Chk.Checked) then
        GERow:=Syss.PrInYr
      else
        GERow:=Trunc(Syss.PrInYr/2);


      NewRows:=Succ(GERow-GSRow);

      With VCFI1 do
      Begin
        RePaint:=BOff;

        If (NewRows<>RowCount) then
          RowCount:=NewRows;
      end;


      Repeat
        GYr:=NHCtrl.NHYr;

        If (LoopMode In [2,4,6,8]) and (Gyr>0) then
          GYr:=AdjYr(GYr,BOff);

        GFin[Loop]:=GYr;

        For n:=GSRow to GERow do
        Begin

          With ExLocal,NHCtrl do
          Begin
            Rnum:=GetHistValue(n,GYr,LoopMode,LNom,BOff);

            GSeries[Loop,n]:=DivWChk(Currency_Txlate(Rnum,NHCr,NHTxCr),TCnst);

            If (Cuml) and (n>1) then
              GSeries[Loop,n]:=GSeries[Loop,n]+GSeries[Loop,n-1];

          end; {With..}

        end;

        Inc(Loop);

        Case Loop of

          2  :  Begin
                  LoopMode:=C2Mode;
                  Cuml:=Cum2;
                end;
          3  :  Begin
                  LoopMode:=C3Mode;
                  Cuml:=Cum3;
                end;
          4  :  Begin
                  LoopMode:=C4Mode;
                  Cuml:=Cum4;
                end;

        end; {Case..}

      Until (Loop>4);

      VCIWith:=VCFI1.Plot.SeriesCollection;

      With VCFI1 do
      Begin

        m:=1;

        For n:=GSRow to GERow do
        Begin
          Row:=m;


          Loop:=1;

          Repeat
            Column:=Loop;

            HasValues:=(HasValues or (Round_Up(GSeries[Loop,n],2)<>0.0));

            Data:=Form_Real(GSeries[Loop,n]*DCnst,0,2);

            Inc(Loop);

          Until (Loop>4);

          Inc(m);
        end;

        Column:=1;


        m:=1;

        For n:=GSRow to GERow do
        Begin
          Row:=m;
          RowLabel:=PPR_Pr(n);
          Inc(m);
        end;

        If (C1Mode<>0) then
          ColumnLabel:=Form_Int(TxlateYrVal(GFin[1],BOff),0)+' '+GTitle[C1Mode];


        VCIWith.Item(Column).Position.Excluded:=(C1Mode=0);

        Column:=2;

        If (C2Mode<>0) then
          ColumnLabel:=Form_Int(TxlateYrVal(GFin[2],BOff),0)+' '+GTitle[C2Mode];

        VCIWith.Item(Column).Position.Excluded:=(C2Mode=0);

        Column:=3;

        If (C3Mode<>0) then
          ColumnLabel:=Form_Int(TxlateYrVal(GFin[3],BOff),0)+' '+GTitle[C3Mode];

        VCIWith.Item(Column).Position.Excluded:=(C3Mode=0);

        Column:=4;

        If (C4Mode<>0) then
          ColumnLabel:=Form_Int(TxlateYrVal(GFin[4],BOff),0)+' '+GTitle[C4Mode];

        VCIWith.Item(Column).Position.Excluded:=(C4Mode=0);

        For n:=1 to ColumnCount do
          VCIWith.Item(n).DataPoints.Item(1).DataPointLabel.LocationType:=0;

        If (Not HasValues) then {* Minimise the graph rage so choosing gnatt does not cause a gpf with more than one colum and no values *}
        Begin
          PrevCCount:=ColumnCount;
          ColumnCount:=1;
        end;


        Repaint:=BOn;

      end; {With..}
  end;
end;


procedure THistWin.CreateStripGraph(NewGraph  :  Boolean);

Var
  n  :  Integer;

Begin
  With VCFI1 do
  Begin
    RePaint:=BOff;

    ColumnCount:=4;

    Legend.Location.Visible:=BOn;

    Plot.Axis(3,1).AxisScale.Hide:=BOn;
    Legend.vtfont.size:=9;

    C1ModeBoxChange(nil);

    If (NewGraph) then
      ChartType:=2;

    GraphCreated:=BOn;

  end; {With..}

end;

procedure THistWin.CreateGraphPage;

Const
  HrsMsg  :  Array[BOff..BOn] of String[20] = ('',',Hrs/Qty');

Var
  StkCode,
  StkDesc,
  LevelStr  :  Str255;

  NewGraph  :  Boolean;



Begin
  StkCode:=''; StkDesc:=''; LevelStr:='';  NewGraph:=BOff;

  With ExLocal,LNom,NHCtrl do
    If (NomType In [CuStkHistCode,StkGrpCode,NomHedCode]) or (GraphMode<>1) then
    Begin
      Case NHMode of
         8  : With LCust do
                 GraphTit.Caption:=dbFormatName(CustCode,Company)+' Balance History';

         9  : With LStock do
                 GraphTit.Caption:=dbFormatName(StockCode,Desc[1])+','+Show_TreeCur(NHCr,NHTxCr);

        88  : With LCust,LStock do
                 GraphTit.Caption:=dbFormatName(CustCode,'')+'.'+
                                   dbFormatName(StockCode,Desc[1])+','+Show_TreeCur(NHCr,NHTxCr);

        19  : With LCust do
                 GraphTit.Caption:=dbFormatName(CustCode,Company)+' Margin History';

        {$IFDEF JC}
          21,22,25..27,29,
          31,32,35..37
             :  Begin
                  Case NHMode of
                    21,26,31,36
                        :    With LJobMisc^,JobAnalRec do
                             Begin
                               StkCode:=JAnalCode;
                               StkDesc:=JAnalName;
                             end;

                    22,27,32,37
                        :    With LJobCtrl^,JobBudg do
                             Begin
                               StkCode:=StockCode;

                               If (Not PayRMode) then
                                 StkDesc:=LStock.Desc[1];
                             end;


                    25,35
                        :    With LJobCtrl^,JobBudg do
                             Begin
                               StkCode:=StockCode;

                               StkDesc:=Major_Hed(AnalHed);
                             end;

                    29  :   With LJobMisc^,EmplRec do
                            Begin
                              LevelStr:=dbFormatName(EmpCode,EmpName)+': Labour History';
                            end;


                  end; {case..}

                  If (NHMode<>29) then
                    LevelStr:='(Job: '+Strip('B',[#32],LJobRec^.JobCode)+') '+Strip('B',[#32],StkCode)+'/'+
                               Strip('B',[#32],StkDesc)+HrsMsg[NHMode In [31..37]];

                  If (Not (NHMode In [31..37])) then
                    LevelStr:=LevelStr+' '+Show_TreeCur(NHCr,NHTxCr);


                  GraphTit.Caption:=LevelStr;
                end;

        {$ENDIF}

          50  :  With LNomView^.NomViewLine do
                 Begin
                   GraphTit.Caption:=dbFormatName(ViewCode,Desc)+': G/L View '+SetN(NomViewNo)+' History.';
                 end;


         else GraphTit.Caption:=dbFormatName(Form_Int(NomCode,0),Desc)+','+Show_TreeCur(NHCr,NHTxCr);

      end; {Case..}
    end; {Case..}


  If (Not Assigned(VCFI1)) then
  Begin
      VCFI1:=TVcFirstImpression.Create(GraphPage);

      Try
        With VCFI1 do
        Begin
          Left := -16;
          Top := -25;

          Height:=GraphPage.Height-GraphHeight;
          Width:=GraphPage.Width-NHBtnPanel.Width;

          {Width := 429;

          Height := 297;}

          TabOrder := 1;

          OnPointSelected := VCFI1PointSelected;
          OnApplyChanges := VCFI1ApplyChanges;

          Plot.View3d.Elevation:=30;
          Plot.View3d.Rotation:=73;

          Visible := BOff;
          Parent:=GraphPage;

          SendToBack;

          NewGraph:=BOn;

        end;

      except
        VCFI1.Free;
        VCFI1:=nil;
      end;
  end;

  If (Assigned(VCFI1)) then
  Begin
    Try
        Case GraphMode of
          0  :  CreateStripGraph(NewGraph);

          1  :  If (EXLocal.LNom.NomType In [NomHedCode,StkGrpCode,CuStkHistCode,ViewHedCode]) then
                  CreateGraphPie;
        end;

        If (NewGraph) then
        Begin
          C1ModeBoxChange(Nil);

          VCFI1.Visible:=BOn;


        end;
      except
        VCFI1.Free;
        VCFI1:=nil;
      end;

  end;

end;


procedure THistWin.Stock2Nom;

Begin
  If (NHCtrl.NHMode=50) then {*Subs LView control *}
  With NomView^.NomViewLine,Nom do
  Begin
    NomCode:=ViewIdx;
    Nom.Desc:=NomView^.NomViewLine.Desc;

    NomType:=ViewType;
  end
  else
  With Stock,Nom do
  Begin
    NomCode:=StockFolio;
    Nom.Desc:=Stock.Desc[1];

    {$IFDEF STK}
      If (NHCtrl.NHMode=88) then
        NomType:=CuStkHistCode
      else
    {$ENDIF}
        NomType:=StockType;
  end;
end;


procedure THistWin.BuildPie(C1Mode  :  Integer);

Var
  GYr      :  Byte;

  Fnum,Keypath,
  n,
  DCnst    :  Integer;

  KeyS,
  KeyChk   :  Str255;

  GPcnt    :  Double;

  VCIWith,
  VCIWith2,
  VCIWith3 :  Variant;


Begin

  If (GPieList=nil) then
    GPieList:=TPieList.Create;

  GYr:=NHCtrl.NHYr;

  If (C1Mode In [2,4,6,8]) then
    GYr:=AdjYr(GYr,BOff);

  If (InvChk.Checked) then
    DCnst:=-1
  else
    DCnst:=1;

  try

    GPieList.Clear;
    GPieList.DestroyVisi;

    Case NHCtrl.NHMode of
      9,88
         :  Begin
              Fnum:=StockF;
              Keypath:=StkCatK;

              KeyChk:=FullStockCode(ExLocal.LStock.StockCode);
            end;
      else  Begin
              Fnum:=NomF;
              Keypath:=NomCatK;

              KeyChk:=FullNomKey(ExLocal.LNom.NomCode);
            end;
    end; {Case..}


    KeyS:=KeyChk;


    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) do
    With Nom do
    Begin
      With NHCtrl,GPieList do
      Begin
        If (NHMode In [9,88,50]) then
          Stock2Nom;

        AddVisiRec(Nom,GetHistValue(NHCtrl.NHPr,GYr,C1Mode,Nom,C1Chk.Checked)*DCnst);
      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    end;

    GPieList.SetPieTotal;

    VCIWith3:=VCFI1.Plot.SeriesCollection;

    With VCFI1 do
    Begin
      RePaint:=BOff;

      n:=GPieList.Count;

      If (ColumnCount<n) then
      Begin
        DataGrid.InsertColumns(ColumnCount,n-ColumnCount);

      end;

      If (n>0) then
        ColumnCount:=n
      else
        ColumnCount:=1;

      Row:=1;

      RowLabel:=PPr_Pr(NHCtrl.NHPr)+'/'+Form_Int(TxlateYrVal(GYr,BOff),0);

      If (C1Chk.Checked) then
        RowLabel:=RowLabel+' YTD';

      RowLabel:=RowLabel+' '+GTitle[C1Mode];

      If (GPieList.Count>0) then
      Begin
        For n:=1 to ColumnCount do
        Begin
          Column:=n;
          With GPieList do
          Begin
            Data:=Form_Real(IdRec(n-1)^.PNomValue,0,2);
            ColumnLabel:=Strip('B',[#32],IdRec(n-1)^.PNomDesc);
            GPcnt:=Round(DivWChk(IdRec(n-1)^.PNomValue,PieTotal)*100);
          end;

          VCIWith2:=VCIWith3.Item(n).DataPoints.Item(1);

          VCIWith:=VCIWith2.DataPointLabel;

          VCIWith.Text:=Copy(ColumnLabel,1,20)+' ('+Form_Real(GPcnt,0,0)+'%)';
          VCIWith.LocationType:=6;
          VCIWith.LineStyle:=2;
          VCIWith.vtFont.Size:=7;
          VCIWith2.Offset:=0.03;
        end;
      end
      else
      Begin
        Column:=1;
        Data:='';
        ColumnLabel:='';
        GPcnt:=0;
      end;


      RePaint:=BOn;
    end;

  except

    GPieList.Free;
    GPieList:=nil;

  end; {try..}


end;


procedure THistWin.CreateGraphPie;

Var
  n  :  Integer;

Begin
  With VCFI1 do
  Begin
    RePaint:=BOff;

    RowCount:=1;

    Row:=1;

    
    Legend.Location.Visible:=BOff;


    C1ModeBoxChange(nil);

  end; {With..}

end;

procedure THistWin.C1ModeBoxChange(Sender: TObject);
begin
  Begin
    Case GraphMode of

      0  :  FillData(C1ModeBox.ItemIndex,C2ModeBox.ItemIndex,
                     C3ModeBox.ItemIndex,C4ModeBox.ItemIndex,
                     C1Chk.Checked,C2Chk.Checked,
                     C3Chk.Checked,C4Chk.Checked);

      1  :  BuildPie(C1ModeBox.ItemIndex);

    end; {Case..}
  end;

end;


procedure THistWin.Graph2Act(Const GPr,GYr  :  Byte;
                             Const LNom     :  NominalRec);

Var
  KeyChk,
  KeyS    :  Str255;
  NHPfix  :  Char;
  NHFolio :  Str20;

Begin


  With NHCtrl do
  Begin
    MapHistVar(NHPfix,NHFolio,LNom);

    KeyS:=FullNHistKey(NHPfix,NHFolio,NHCr,GYr,GPr);
  end;

  With MULCtrlO do
    Status:=Find_Rec(B_GetGEq,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,KeyS);


  If (StatusOk) then
    Send_UpdateList(52+(10*GraphMode))
  else
    MessageBeep(0);

end;

procedure THistWin.Set_SetUP;

Const
  CumTit  :  Array[0..1] of Str20 = ('Cumulative','Year to date');

Begin
  C2Chk.Enabled:=(GraphMode=0);

  If (C2Chk.Enabled) then
    C2Chk.State:=cbChecked
  else
    C2Chk.State:=cbGrayed;

  C3Chk.Enabled:=C2Chk.Enabled;
  C3Chk.State:=C2Chk.State;

  C4Chk.Enabled:=C2Chk.Enabled;
  C4Chk.State:=C2Chk.State;
  Q1Chk.State:=C2Chk.State;
  Q4Chk.State:=C2Chk.State;

  C2ModeBox.Enabled:=C2Chk.Enabled;
  C3ModeBox.Enabled:=C2Chk.Enabled;
  C4ModeBox.Enabled:=C2Chk.Enabled;
  Q1Chk.Enabled:=C2Chk.Enabled;
  Q4Chk.Enabled:=C2Chk.Enabled;

  CumLab.Caption:=CumTit[GraphMode];
end;


procedure THistWin.Strip2Act(Const Period,Col  :  Byte);

Var
  GYr  :  Byte;

begin
  GYr:=NHCtrl.NHYr;

  Case Col of
    1  :  If (C1ModeBox.ItemIndex in [2,4,6,8]) then
            GYr:=AdjYr(GYr,BOff);
    2  :  If (C2ModeBox.ItemIndex in [2,4,6,8]) then
            GYr:=AdjYr(GYr,BOff);
    3  :  If (C3ModeBox.ItemIndex in [2,4,6,8]) then
            GYr:=AdjYr(GYr,BOff);
    4  :  If (C4ModeBox.ItemIndex in [2,4,6,8]) then
            GYr:=AdjYr(GYr,BOff);
  end;

  Graph2Act(Period+Pred(GSRow),GYr,ExLocal.LNom);
end;


procedure THistWin.Pie2Act(Const Period,Col  :  Byte);

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  GPr,
  GYr  :  Byte;

  TNomCode,
  FoundLong
       :  LongInt;

  KeyS :  Str255;

begin
  GYr:=NHCtrl.NHYr;
  TNomCode := 0; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390

  If (C1ModeBox.ItemIndex in [2,4,6,8]) then
    GYr:=AdjYr(GYr,BOff);

  {* Need to alter this to find via GPieList *}
  If (GPieList<>nil) then
    TNomCode:=GPieList.IdRec(Pred(Col))^.PNomCode;

  Case NHCtrl.NHMode of

    9,88
       :  Begin
            If (TNomCode<>Stock.StockFolio) then
            Begin
              KeyS:=FullNomKey(TNomCode);

              Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

              Stock2Nom;
            end;
          end;

    else  Begin

            If (TNomCode<>Nom.NomCode) then
              GetNom(Self,Form_Int(TNomCode,0),FoundLong,-1);
          end;
  end; {Case..}

  If (C1Chk.Checked) then
    GPr:=YTDNCF
  else
    GPr:=NHCtrl.NHPr;

  Graph2Act(GPr,GYr,Nom);
end;


procedure THistWin.VCFI1PointSelected(Sender: TObject; var Series,
  DataPoint, MouseFlags, Cancel: Smallint);

Begin
  Case GraphMode of
    0  :  Strip2Act(DataPoint,Series);
    1  :  Pie2Act(DataPoint,Series);
  end; {Case..}
end;

procedure THistWin.SetUpnhBtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;


begin
  If (Current_Page=2) then
    GraphPanel.Visible:=Not GraphPanel.Visible
  else
    If (Not (Sender is TMenuItem)) and (Current_Page=1) then
    With TWinControl(Sender) do
    Begin
      ListPoint.X:=1;
      ListPoint.Y:=1;

      ListPoint:=ClientToScreen(ListPoint);

      Case NHCtrl.NHMode of
        10  :  PopUpMenu3.PopUp(ListPoint.X,ListPoint.Y);
        else   PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
      end; {Case..}
    end;


end;

procedure THistWin.VCFI1ApplyChanges(Sender: TObject);

Var
  NewMode  :  Integer;

begin
  With VCFI1,NHCtrl do
  Begin
    Case NHMode of
      8,19  :  NewMode:=0

      else     If (ExLocal.LNom.NomType In [NomHedCode,StkGrpCode,CuStkHistCode]) and (ChartType In [13,14]) then
                 NewMode:=1
               else
                 NewMode:=0;
                 
    end; {Case..}
  end;

  If (GraphMode<>NewMode) then
  Begin
    GraphMode:=NewMode;
    Set_SetUp;
    CreateGraphPage;
  end;

end;

procedure THistWin.EditnhBtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  If (MULCtrlO<>nil) then
  Begin
    If (NHCtrl.NHMode In  [1,8,9,11,12,21,22,25..27,29,
                           31,32,35..37,50,91,92])  then {* All double budget modes, offer either to edit *}
    Begin
      If (Not (Sender is TMenuItem)) and (Current_Page<>2) then
      With TWinControl(Sender) do
      Begin
        ListPoint.X:=1;
        ListPoint.Y:=1;

        ListPoint:=ClientToScreen(ListPoint);

        PopUpMenu4.PopUp(ListPoint.X,ListPoint.Y);

      end;

    end
    else
      MULCtrlO.EditBudget(NBPrPanel.Color,NBPrPanel.Font,1);
  end;
end;

procedure THistWin.MenuItem3Click(Sender: TObject);
begin
  MULCtrlO.EditBudget(NBPrPanel.Color,NBPrPanel.Font,TMenuItem(Sender).Tag);
end;


procedure THistWin.FillnhBtnClick(Sender: TObject);
begin
  If (MULCtrlO<>nil) then
    With MULCtrlO do
      FillBudget(KeyRef);
end;

{$IFDEF PF_On}

  procedure THistWin.Display_Profile;

    Var
      NomNHCtrl  :  TNHCtrlRec;

      BudgetFolio:  Longint;

      BudTyp     :  Char;
      WasNew     :  Boolean;

      GenStkStr  :  Str255;

    Begin
      BudgetFolio:=0;

      //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
      BudTyp := #0; 

      WasNew:=BOff;

      GenStkStr:='';

      With NomNHCtrl,ExLocal do
      Begin
        FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);
        NomNHCtrl:=NHCtrl;

        NHMode:=10;
        NBMode:=10;
        NHPr:=1;

        If (MULCtrlO.KeyRef[1] In [StkGrpCode,NomHedCode]) then
        Begin

          Case MULCtrlO.KeyRef[1] of

            NomHedCode  :  Begin
                             BudTyp:=LNom.NomType;

                             BudgetFolio:=LNom.Nomcode;

                             GenStkStr:=CalcCCKeyHistP(BudgetFolio,NHCCMode,NHCDCode);
                           end;

            {$IFDEF STK}
              StkGrpCode  :  Begin
                               BudTyp:=LStock.StockType;
                               BudgetFolio:=LStock.StockFolio;

                               GenStkStr:=CalcKeyHist(BudgetFolio,NHLocCode);
                             end;

              CuStkHistCode
                          :  Begin
                               BudTyp:=CuStkHistCode;

                               BudgetFolio:=LStock.StockFolio;

                               GenStkStr:=Calc_CStkNHKeyHist(NHCtrl);
                             end;
            {$ENDIF}
          end; {Case..}
        end;

        NHCCode:=GenStkStr; {FullNCode(FullNomKey(BudgetFolio));}

        NHKeyLen:=NHCodeLen+2;

        MainK:=FullNHistKey(Calc_AltStkHCode(BudTyp),GenStkStr,NHCr,0,0);
        AltMainK:=MainK;

        Set_NHFormMode(NomNHCtrl);

      end;

      If (ProfileFrm=nil) then
      Begin
        WasNew:=BOn;

        ProfileFrm:=THistWin.Create(Self);


      end;

      Try

       With ProfileFrm do
       Begin


         WindowState:=wsNormal;

         Show;

         ShowLink(BOn,BOff);


         If (WasNew) then
         Begin
           NHDrCrPage.TabVisible:=BOff;
         end;

       end; {With..}


      except

       ProfileFrm.Free;
       ProfileFrm:=nil;

      end; {try..}

  end;

{$ENDIF}

procedure THistWin.ProfilenhBtnClick(Sender: TObject);
begin
  {$IFDEF PF_On}
    Display_Profile;
  {$ENDIF}
end;

procedure THistWin.FormActivate(Sender: TObject);
begin
  If (Current_Page<>2) and (MULCtrlO<>nil) then
    MULCtrlO.SetListFocus;
  ListActive:=BOn;
end;

procedure THistWin.Enter1Click(Sender: TObject);
begin
  {$IFDEF PF_On}
    If (MULCtrlO<>nil) then
      With MULCtrlO do
        YTD_SplitBudget(0,BOff,KeyRef);
  {$ENDIF}
end;

procedure THistWin.o(Sender: TObject);
begin
  {$IFDEF PF_On}
    If (MULCtrlO<>nil) then
      With MULCtrlO do
        Copy_Budget(KeyRef,(TMenuItem(Sender).Tag=3));

  {$ENDIF}
end;

procedure THistWin.Update1Click(Sender: TObject);
Var
  mbRet  :  Word;

begin
  {$IFDEF PF_On}
    If Assigned(MULCtrlO) then
    With MULCtrlO do
    Begin
      mbRet:=MessageDlg('Please Confirm you wish to Update all Budgets.',mtConfirmation,[mbYes,mbNo],0);

      If (mbRet=mrYes) then
      Begin
        AddUpBudget2Thread(Self,0,KeyRef,ScanFileNum,Keypath,Nom,Stock,NomView^, NHCtrl);
      end;
    end; {With..}
  {$ENDIF}
end;

procedure THistWin.MenuItem4Click(Sender: TObject);

Var
  mbRet  :  Word;

begin
  {$IFDEF PF_On}
    If Assigned(MULCtrlO) then
      With MULCtrlO,ExLocal do
      Begin
        mbRet:=MessageDlg('Please Confirm you wish to Update all Profiles below this level.',mtConfirmation,[mbYes,mbNo],0);

        If (mbRet=mrYes) then
          AddUpBudget2Thread(Self,1,KeyRef,ScanFileNum,Keypath,LNom,LStock,NomView^, NHCtrl);

      end; {With..}
  {$ENDIF}
end;


procedure THistWin.RollUp1Click(Sender: TObject);
var
  Dlg: TRollupBudgetDlg;
begin
  // CJS 2016-04-12 - ABSEXCH-17382 - GL Budget roll up - SQL improvements
  // CJS 2016-04-19 - ABSEXCH-17431 - additional UI mods for SQL GL Budget changes
  if SQLUtils.UsingSQL and SQLReportsConfiguration.UseSQLRollupGLBudgets then
  begin
    // If not budgeting by Cost Centre/Department...
    if Ord(Syss.PostCCNom)+Ord(Syss.PostCCDCombo) = 0 then
      // ...call the roll-up routine directly, for G/L Only
      RollupBudgets('G')
    else
      // Otherwise launch the Roll-up Budgets selection dialog
      Dlg := TRollupBudgetDlg.Create(self);
  end
  else
    Roll_Budget(Self,ExLocal.LNom);
end;

// NF: 16/05/06 Fixes for incorrect Context IDs
procedure THistWin.SetHelpContextIDsForPage;
const
  TAB_DEBITCREDIT = 0;
  TAB_BUDGETVARIANCE = 1;
  TAB_GRAPH = 2;
begin
  case PageControl1.ActivePage.PageIndex of
    TAB_DEBITCREDIT : NHDrCrPage.HelpContext := 180;
    TAB_BUDGETVARIANCE : begin
      if (NHCtrl.NHMode = 10) then
      begin
        // Budget Profile Mode
        BudVarPage.HelpContext := 1798;

        EditnhBtn.HelpContext := 1800;
        FillnhBtn.HelpContext := 1801;
        SetUpnhBtn.HelpContext := 1802;
        ProfilenhBtn.HelpContext := 1803;
      end else
      begin
        // History Mode
        //PR: 12/11/2012 Different help context for GL Budget history.
        if NHCtrl.NHMode = 1 then
          BudVarPage.HelpContext := 40182
        else
          BudVarPage.HelpContext := 185;

        EditnhBtn.HelpContext := 184;
        FillnhBtn.HelpContext := 183;
        SetUpnhBtn.HelpContext := 181;
        ProfilenhBtn.HelpContext := 1799;
      end;{if}
    end;
    TAB_GRAPH : GraphPage.HelpContext := 182;
  end;{case}

  Clsnh1Btn.HelpContext := 1804;

  PageControl1.HelpContext := PageControl1.ActivePage.HelpContext;
  HelpContext := PageControl1.ActivePage.HelpContext;
end;


procedure THistWin.btnRevisionsClick(Sender: TObject);
var
  NomType : Char;
begin
  //PR: 04/07/2012 ABSEXCH-12957 Display Revised Budget changes dialog.
  with TfrmGLBudgetRevisions.Create(Application) do
  Try
    //PR: 19/07/2012 ABSEXCH-13185 Pass through NomType char as that is used as prefix in history table.
    //Nom may change when doing split budget, so take from list keystring if possible;
    if Assigned(MULCtrlO) and (Length(MULCtrlO.KeyRef) > 0) then
      NomType := MULCtrlO.KeyRef[1]
    else
      NomType := Nom.NomType;
    InitialiseRevisions(MULCtrlO.LNHCtrl.NHNomCode, MULCtrlO.LNHCtrl.NHCr, Self.Caption, NomType);
    if LoadYears then
      ShowModal
    else
      msgBox('There are no revised budget changes for this GL Code/currency', mtInformation, [mbOK], mbOK, 'Revised budget changes');
  Finally
    Free;
  End;
end;

//-------------------------------------------------------------------------

// MH 09/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
function THistWin.WindowExportEnableExport: Boolean;
begin
  Result := (Current_Page In [0, 1]) And (NHCtrl.NHMode = 1);
  If Result Then
  Begin
    WindowExport.AddExportCommand (ecIDCurrentRow, ecdCurrentRow);
    WindowExport.AddExportCommand (ecIDCurrentPage, ecdCurrentPage);
    WindowExport.AddExportCommand (ecIDEntireList, ecdEntireList);
  End; // If Result
end;

//-------------------------------------------------------------------------

// MH 09/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
procedure THistWin.WindowExportExecuteCommand(const CommandID: Integer; const ProgressHWnd: HWND);
Var
  ListExportIntf : IExportListData;
begin
  // Returns a new instance of an "Export Btrieve List To Excel" object
  ListExportIntf := NewExcelListExport;
  Try
    ListExportIntf.ExportTitle := WindowExportGetExportDescription;

    // Connect to Excel
    If ListExportIntf.StartExport Then
    Begin
      // Get the active Btrieve List to export the data
      MulCtrlO.ExportList (ListExportIntf, CommandID, ProgressHWnd);

      ListExportIntf.FinishExport;
    End; // If ListExportIntf.StartExport(sTitle)
  Finally
    ListExportIntf := NIL;
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

// MH 09/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
function THistWin.WindowExportGetExportDescription: String;
begin
  If (NHCtrl.NHMode = 1) Then
  Begin
    // GL History
    Result := 'GL History - ' + IntToStr(ExLocal.LNom.NomCode);
  End // If (NHCtrl.NHMode = 1)
  Else
    Result := 'Period History';

  Case Current_Page Of
    0 : Result := Result + ' - Debit & Credit';
    1 : Result := Result + ' - Budget & Variance';
  End; // Case Current_Page
end;

//-------------------------------------------------------------------------

Initialization


end.



