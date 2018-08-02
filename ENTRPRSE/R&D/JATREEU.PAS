unit JATreeU;

{$I DEFOVR.Inc}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Grids,StdCtrls, OutLine, SBSOutl, TEditVal,
  GlobVar,VarConst,ETStrU,BtrvU2,BTSupU1, BTKeys1U,ExtCtrls, Buttons,
  BorBtns, Menus,

  ExWrap1U,

  {$IFDEF NOM}
    HistWinU,
  {$ENDIF}

  JobBdI3U,

  SalTxl3U,

  SBSPanel, ImgModU,ToolWin, AdvGlowButton, AdvToolBar, AdvToolBarStylers;


type
  TJAView = class(TForm)
    PopupMenu1: TPopupMenu;
    MIHist: TMenuItem;
    Expand1: TMenuItem;
    MIETL: TMenuItem;
    MIEAL: TMenuItem;
    EntireGeneralLedger1: TMenuItem;
    MIColl: TMenuItem;
    MICTL: TMenuItem;
    EntireGeneralLedger2: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    SBSPanel1: TSBSPanel;
    NCurrLab: Label8;
    Panel4: TSBSPanel;
    TxLateChk: TBorCheck;
    Currency: TSBSComboBox;
    Graph1: TMenuItem;
    MIRec: TMenuItem;
    OptBtn: TButton;
    ComparisonClone1: TMenuItem;
    Edit1: TMenuItem;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    N5: TMenuItem;
    PageControl1: TPageControl;
    CatPage: TTabSheet;
    StkPage: TTabSheet;
    NLDPanel: TSBSPanel;
    NLCrPanel: TSBSPanel;
    NLDrPanel: TSBSPanel;
    NLOLine: TSBSOutlineB;
    NLOLine2: TSBSOutlineB;
    Showvalue1: TMenuItem;
    NDisp1: TMenuItem;
    NDisp2: TMenuItem;
    NDisp3: TMenuItem;
    NLAcPanel: TSBSPanel;
    NLAcPanel2: TPanel;
    NLDPanel2: TPanel;
    NLCrPanel2: TPanel;
    NLDrPanel2: TPanel;
    Filter1: TMenuItem;
    SBSPopupMenu1: TSBSPopupMenu;
    StockCode1: TMenuItem;
    TimeRate1: TMenuItem;
    UpdateBud1: TMenuItem;
    UpdateBud2: TMenuItem;
    Valuation1: TMenuItem;
    UpdateBud3: TMenuItem;
    Valuation2: TMenuItem;
    AdvStyler: TAdvToolBarOfficeStyler;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    FullExBtn: TAdvGlowButton;
    FullColBtn: TAdvGlowButton;
    Panel7: TPanel;
    Button1: TButton;
    Panel8: TPanel;
    GraphBtn: TAdvGlowButton;
    HistBtn: TAdvGlowButton;
    NomSplitBtn: TAdvGlowButton;
    ReconBtn: TAdvGlowButton;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    Label82: Label8;
    Period: TSBSComboBox;
    Label83: Label8;
    Year: TSBSComboBox;
    YTDChk: TBorCheck;
    lblDetailsCode: Label8;
    UpdateAllCategoriesandContracts1: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure NLOLineExpand(Sender: TObject; Index: Longint);
    procedure NLOLineCollapse(Sender: TObject; Index: Longint);
    procedure NLOLineNeedValue(Sender: TObject);
    procedure FullExBtnClick(Sender: TObject);
    procedure CurrencyClick(Sender: TObject);
    procedure ClsI1BtnClick(Sender: TObject);
    procedure NomSplitBtnClick(Sender: TObject);
    procedure NLOLineDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure YTDChkClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure NLOLineMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TxLateChkClick(Sender: TObject);
    procedure HistBtnClick(Sender: TObject);
    procedure MIEALClick(Sender: TObject);
    procedure PeriodExit(Sender: TObject);
    procedure MIFindClick(Sender: TObject);
    procedure ReconBtnClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure OptBtnClick(Sender: TObject);
    procedure NDisp1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Filter1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure TimeRate1Click(Sender: TObject);
    procedure UpdateBud1Click(Sender: TObject);
    procedure UpdateBud2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Valuation2Click(Sender: TObject);
    procedure PeriodKeyPress(Sender: TObject; var Key: Char);
    procedure NLOLineClick(Sender: TObject);
    { CJS 2012-08-28 - ABSEXCH-11183 - Stock Code and Time Rate clash }
    procedure NLOLine2UpdateNode(Sender: TObject; var Node: TSBSOutLNode;
      Row: Integer);
    // CJS 2015-02-20 - ABSEXCH-15785 - SQL version of Update all Contracts
    procedure UpdateAllCategoriesandContracts1Click(Sender: TObject);

  private
    { Private declarations }
    IAmChild,
    FiltNType,
    ShowQty,
    WarnMaxRecs,
    StillMore,
    RefreshHist,
    BeenUpdate,
    RefreshRecon,
    InHCallBack,
    InHBeen,
    UseYTD,
    StoreCoord,
    LastCoord,
    fNeedCUpdate,
    FColorsChanged,
    SetDefault,
    GotCoord     :   Boolean;

    LastJobType  :  Char;
    
    MaxIn1Go,
    Lab1Ofset,
    Lab2Ofset,
    Lab3Ofset,
    Lab4Ofset,
    Lab5Ofset,
    Lab6Ofset,
    Lab7Ofset,
    ChrWidth     :   LongInt;


    StartSize,
    OrigSize,
    InitSize     :  TPoint;


    LastCursor   :   TCursor;

    NDispMode,
    NTxCr,
    NCr,NPr,NYr  :   Byte;

    ChrsXross    :   Double;

    ColXAry      :   Array[1..3] of LongInt;

    ChildNom     :   TJAView;
    InChild      :   Boolean;

    {$IFDEF Nom}
      HistForm     :   THistWin;
    {$ENDIF}

    BudRec       :   TJobBudget;

    InHist       :   Boolean;


    InRecon      :   Boolean;

    ExLocal      :   TdExLocal;

    JobActive    :  Boolean;

    JobRecFrm    :  TFJobDisplay;

    //fImageRepos  :  TImageRepos;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Function FormatLine(ONomRec  :  OutNomType;
                        LineText :  String)  :  String;

    Procedure SuperDDCtrl(Mode  :  Byte);

    Function GetSelJARec(INo  :  Integer)  :  Boolean;

    procedure GetSelRec;

    Function Page2Mode(CP  :  Integer)  :  Byte;

    procedure Display_Account(Mode             :  Byte;
                              ChangeFocus      :  Boolean);


    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Function CreateCaption  :  Str255;

    Function CreateGPCaption  :  Str255;

    Function UseJAFilter  :  Str20;

    Procedure Add_OutLines(Depth,
                           DepthLimit,
                           OIndex        :   LongInt;
                           StkCat        :   Str20;
                           JTMode        :   Byte;
                           JCType        :   LongInt;
                           UNLOLine      :   TSBSOutlineB;
                     Const Fnum,
                           Keypath       :   Integer);


    Procedure Add_TotOutLines(Depth,
                              DepthLimit,
                              SFolio,
                              OIndex        :   LongInt;
                              JCode,
                              StkCat        :   Str20;
                              ONType        :   Char;
                              JTMode        :   Byte;
                              AHed          :   LongInt;
                              LineText      :   String);

    Function NLOLineAddProfit  :  Double;

    Procedure Update_OutLines(Const Fnum          :   Integer;
                                    UNLOLine      :   TSBSOutlineB);

    Procedure Drill_OutLines(Depth,
                             DepthLimit,
                             PIndex        :  LongInt;
                             UNLOLine      :   TSBSOutlineB);

    Procedure Delete_OutLines(PIndex      :  LongInt;
                              DelSelf     :  Boolean;
                              UNLOLine    :  TSBSOutlineB);

    procedure NLChildUpdate;

    procedure SetHistoryMode(ONomCtrl     :  OutNomType;
                         Var NHMode,
                             NBMode       :  Byte;
                         Var NBCMode      :  Boolean);

    procedure Display_History(ONomCtrl     :  OutNomType;
                              ChangeFocus,
                              ShowGraph    :  Boolean);

    procedure LinkBudg_toHistory(BudMode  :  Byte);

    Procedure Send_UpdateList(Mode   :  Integer);

    Function GetNLOLine(Mode  :  Byte)  :  TSBSOutLineB;

    procedure SetFieldProperties;

    procedure SetFormProperties(SetList  :  Boolean);

    procedure Display_BudRec(Mode,JM  :  Byte);

    Procedure AddEditLine(Edit,
                          DelMode  :  Boolean);

    function FindNode(NCode  :  LongInt;
                      JCode  :  Str20)  :  Integer;

    Function Advanced_FindNomCode(SC     :  Str20;
                                  SF     :  LongInt;
                                  Fnum,
                                  Keypath:  Integer)  :  Integer;

    Procedure FindStkCode;

    procedure StkLink;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function Is_NodeParent(MIdx,SIdx  :  Integer)  :  Boolean;

    Function Place_InOrder(MIdx,SIdx  :  Integer;
                       Var UseAdd     :  Boolean)  :  Integer;

    procedure UpdateHeadings(NIdx  :  Integer);

    procedure UpdateJobBudgets(CategoriesOnly: Boolean);

  public
    { Public declarations }
    JATreeJCode  :  Str20;

    Procedure PlaceNomCode(FindCode  :  LongInt);

    Function StkPageVisible  :  Boolean;

    {$IFDEF STK}
      
      procedure ApplyNewSPayJCode;

    {$ENDIF}

    procedure ApplyNewJCode(JCode  :  Str20);

    procedure SetTabxJType(JT  :  Char);

  end;


Procedure Set_JAViewJC(JC  :  Str20);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETDateU,
  CurrncyU,
  Mask,
  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  ETMiscU,
  CmpCtrlU,
  ColCtrlU,
  VarJCstU,
  ComnUnit,
  ComnU2,
  BtSupU2,

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  {$IFDEF POST}
    JobBudPU,
  {$ENDIF}

  ExThrd2U,

  InvListU,
  JobSup1U,

  JobMn2U,

  JobApWzU,

  ThemeFix,

  {$IFDEF EXSQL}
    SQLUtils,
    SQLRep_Config,
    SQLCallerU,
  {$ENDIF}

  SysU1,
  PWarnU,
  WM_Const,

  // CJS 2014-07-08 - ABSEXCH-13227 - Password option for budget records
  UA_Const,

  oProcessLock;

{$R *.DFM}

Const
  InitWidth  =  118;
  TDpth      =  70;


Var
  HJCode  :  Str20;


Procedure Set_JAViewJC(JC  :  Str20);

Begin
  HJCode:=JC;


end;



Procedure  TJAView.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TJAView.Find_FormCoord;


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

    PrimeKey:='A';

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    If GetbtControlCsm(NLOLine) then
      NLOLine.BarColor:=ColOrd;

    If GetbtControlCsm(NLDPanel) then
      NLOLine.BarTextColor:=ColOrd;

    GetbtControlCsm(NLCrPanel);

    GetbtControlCsm(NLDrPanel);

    If GetbtControlCsm(Period) then
      SetFieldProperties;

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range *}

  With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  {If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;}

  {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TJAView.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin


  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='A';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    ColOrd:=NLOLine.BarColor;

    StorebtControlCsm(NLOLine);

    ColOrd:=NLOLine.BarTextColor;

    StorebtControlCsm(NLDPanel);

    StorebtControlCsm(NLDrPanel);

    StorebtControlCsm(NLCrPanel);

    StorebtControlCsm(Period);


  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;


Function TJAView.FormatLine(ONomRec  :  OutNomType;
                             LineText :  String)  :  String;

Begin
  With ONomRec do
  Begin
    Result:=Spc(1*OutDepth)+Strip('R',[#32],LineText);

    Result:=Result+Spc(Round((Width-Canvas.TextWidth(Result))/Canvas.TextWidth(' '))-(TDpth*OutDepth));
  end;
end;


{ ======= Procedure to Build Total for each heading File ===== }

Procedure TJAView.Add_TotOutLines(Depth,
                                  DepthLimit,
                                  SFolio,
                                  OIndex        :   LongInt;
                                  JCode,
                                  StkCat        :   Str20;
                                  ONType        :   Char;
                                  JTMode        :   Byte;
                                  AHed          :   LongInt;
                                  LineText      :   String);


Var

  NewIdx,
  NewObj
          :  LongInt;

  ONomRec :  ^OutNomType;


Begin

  With NLOLine do
  Begin

    New(ONomRec);
    FillChar(ONomRec^,Sizeof(ONomRec^),0);
    With ONomRec^ do
    Begin
      OutNomCode:=SFolio;
      OutNomCat:=AHed;
      OutJTNo:=JTMode;

      OutStkCode:=JCode;
      OutStkCat:=StkCat;

      OutDepth:=Depth;
      BeenDepth:=DepthLimit;
      OutNomType:=ONType;
      HedTotal:=BOn;
    end;

    {LineText:=Spc(1*Depth)+LJVar(LineText,ChrWidth-(20*Depth));}

    {LineText:=FormatLine(ONomRec^,LineText);}

    LineText:=Spc(1*Depth)+Strip('R',[#32],LineText);

    LineText:=LineText+Spc(Round((Width-Canvas.TextWidth(LineText))/Canvas.TextWidth(' '))-(TDpth*Depth));


    NewIdx:=AddChildObject(OIndex,LineText,ONomRec);

    Items[NewIdx].UseLeafX:=obLeaf2;


  end; {With..}

end; {Proc..}



Function TJAView.UseJAFilter  :  Str20;

Var
  ONomRec :  ^OutNomType;
  Idx     :  Integer;

Begin
  Result:='';

  If (FiltNType) then
  With NLOLine do
  Begin
    If (SelectedItem>0) then
    Begin
      Idx:=SelectedItem;

      ONomRec:=Items[Idx].Data;


      With ONomRec^ do
      Begin
        If (OutJTNo=6) then {* We are sat on an Analysis Code, so use it...*}
          Result:=OutStkCat;

      end;
    end; {We have a selection}
  end;
end;


{ ======= Procedure to Build List based on Nominal File ===== }

Procedure TJAView.Add_OutLines(Depth,
                               DepthLimit,
                               OIndex        :   LongInt;
                               StkCat        :   Str20;
                               JTMode        :   Byte;
                               JCType        :   LongInt;
                               UNLOLine      :   TSBSOutlineB;
                         Const Fnum,
                               Keypath       :   Integer);

Const
  Fnum2      =  JobF;
  Keypath2   =  JobCatK;


Var
  KeyS,
  KeyChk,
  KeyS2,
  KeyChk2
          :  Str255;

  LineText,
  UseHed

          :  String;

  SpcWidth,
  NewIdx,
  InsIdx,
  NewObj,
  TmpRecAddr,
  ThisCount,
  MaxTLen
          :  LongInt;
  SubKPath,
  TmpStat,
  TmpKPath
          :  Integer;

  ONomRec :  ^OutNomType;


Procedure Out_Add2Tree;

Var
  FoundCode  :  Str20;

Begin
  With ExLocal,LJobCtrl^.JobBudg, UNLOLine do
  Begin
    {Application.ProcessMessages;  Cannot put this here, as LStock can get corrupted}

    If (JTMode<>1) then
      LGetMainRecPos(JobF,StkCat);

    If (JTMode In [2,6]) then
      GetJobMisc(Self,AnalCode,FoundCode,2,-1);

    Begin
      New(ONomRec);
      FillChar(ONomRec^,Sizeof(ONomRec^),0);
      With ONomRec^ do
      Begin
        OutNomCode:=HistFolio;
        OutStkCode:=JobCode;

        If (JTMode<>2) then
        Begin
          OutNomCat:=AnalHed;
          OutStkCat:=AnalCode;

          If (OutStkCat='') then
            OutStkCat:=Form_Int(AnalHed,0);
        end
        else
        Begin
          OutStkCat:=StockCode;
          { CJS 2012-08-28 - ABSEXCH-11183 - Stock Code and Time Rate clash }
          OutViewCode := AnalCode;
          PRateMode:=PayRMode;
        end;

        If (JTMode=1) then
          OutJTNo:=5
        else
          OutJTNo:=JTMode;


        OutDepth:=Depth;
        BeenDepth:=DepthLimit;
        OutNomType:=LJobRec^.JobType;
        NotOpen:=BOn;
        ShowAsBar:=(AnalHed In [SysAnlsProfit]);

      end;

      {LineText:=Spc(1*Depth)+LJVar(Desc,ChrWidth-(20*Depth))}

      {LineText:=FormatLine(ONomRec^,Strip('R',[#32],Desc[1]));}

      LineText:=Spc(1*Depth);


      Case JTMode of
        1,5
           :  UseHed:=Strip('R',[#32],Major_Hed(AnalHed));

        2  :  Begin

                If (PayRMode) then
                  UseHed:=dbFormatName(StockCode,Get_StdPRDesc(StockCode,Fnum,SubKPath,-1))
                else
                Begin
                  {$IFDEF STK}
                    LGetMainRecPos(StockF,StockCode);

                    UseHed:=dbFormatName(StockCode,LStock.Desc[1]);

                  {$ENDIF}
                end;

              end;

        6  :  UseHed:=Strip('R',[#32],JobMisc^.JobAnalRec.JAnalName);
      end; {Case..}

      MaxTLen:=Round(NLDPanel.Width/Canvas.TextWidth('e'));

      If (MaxTLen>10) and (JTMode<>2) then
        MaxTLen:=MaxTLen-10;

      UseHed:=Copy(UseHed,1,MaxTLen);

      If (JTMode<>2) and (JobCode<>JATreeJCode) then
        LineText:=LineText+UseHed+'. ('+Trim(JobCode)+')'
      else
        LineText:=LineText+UseHed;

      LineText:=LineText+Spc(Round((Width-Canvas.TextWidth(LineText))/SpcWidth)-(TDpth*Depth));

      NewIdx:=AddChildObject(OIndex,LineText,ONomRec);

      If (JTMode In [1,5]) and ((Not (AnalHed In [SysAnlsProfit,SysAnlsWIP,SysAppSal,SysAppPur])) or (LJobRec^.JobType=JobGrpCode)) then
        Add_TotOutLines(Depth+1,DepthLimit,HistFolio,NewIdx,JobCode,AnalCode,LJobRec^.JobType,JTMode,AnalHed,'Total '+UseHed);
    end;
  end; {With..}

end;

Begin
  TmpKPath:=Keypath;
  ThisCount:=0;

  InsIdx:=0;  UseHed:='';

  With UNLOLine,ExLocal do
  Begin

    SpcWidth:=Canvas.TextWidth(' ');

    Case JTMode of

      1    :  Begin
                KeyChk2:=StkCat;

                KeyS2:=KeyChk2;

                Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS2);

                While (StatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOn)) do
                With LJobRec^ do
                Begin
                  KeyChk:=PartCCKey(JBRCode,JBSubAry[5])+FullJobCode(JobCode)+FullNomKey(JCType);
                  KeyS:=KeyChk;

                  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

                  If (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))  then
                  With LJobCtrl^.JobBudg do
                  Begin
                    Out_Add2Tree;
                  end;

                  Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS2);

                end;
              end;
      2,5,6
           :  Begin
                SubKPath:=Keypath;

                Case JTMode of
                  2  :  If (UseJAFilter='') then
                          KeyChk:=PartCCKey(JBRCode,JBSubAry[JTMode])+StkCat
                        else
                        Begin
                          KeyChk:=PartCCKey(JBRCode,JBSubAry[JTMode])+FullJDAnalKey(StkCat,UseJAFilter);
                          SubKPath:=JCSecK;
                        end;

                  5  :  KeyChk:=PartCCKey(JBRCode,JBSubAry[JTMode])+StkCat;
                  6  :  KeyChk:=PartCCKey(JBRCode,JBSubAry[JTMode])+FullJBDDKey(StkCat,JCType);
                end;


                KeyS:=KeyChk;

                Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,SubKPath,KeyS);

                While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
                Begin
                  Out_Add2Tree;

                  Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,SubKPath,KeyS);

                end; {While..}

              end;



    end;



  end; {With..}

end; {Proc..}


Procedure TJAView.Update_OutLines(Const Fnum          :   Integer;
                                        UNLOLine      :   TSBSOutlineB);


Var
  KeyChk,
  KeyS    :  Str255;

  FoundCode
          :  Str20;

  LineText,
  UseHed
          :  String;

  KeyPath :  Integer;

  MaxTLen,
  N       :  LongInt;

  ONomRec :  ^OutNomType;


Begin
  With UNLOLine do
  Begin
    BeginUpdate;

    For n:=1 to ItemCount do
    Begin
      ONomRec:=Items[n].Data;

      If (ONomRec<>Nil) then
      With ONomRec^ do
      Begin
        Case OutJTNo of
          2,6
             :  Begin
                  KeyChk:=Strip('R',[#0],PartCCKey(JBRCode,JBSubAry[OutJTNo])+FullJBCode(OutStkCode,0,OutStkCat));
                  KeyPath:=JCK;
                end;

          else  Begin
                  KeyChk:=PartCCKey(JBRCode,JBSubAry[OutJTNo])+Strip('R',[#0],FullJBCode(OutStkCode,0,FullNomKey(OutNomCode)));
                  KeyPath:=JCK;
                end;
        end; {case..}


        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        If (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))  then
        With JobCtrl^.JobBudg do
        Begin
          {LineText:=Spc(1*OutDepth)+LJVar(LineText,ChrWidth-(20*OutDepth))}

          If (OutJTNo In [2,6]) then
            GetJobMisc(Self,AnalCode,FoundCode,2,-1);

          Begin
            LineText:=Spc(1*OutDepth);

            Case OutJTNo of
              2  :  Begin

                      If (PayRMode) then
                        UseHed:=dbFormatName(StockCode,Get_StdPRDesc(StockCode,Fnum,JCK,-1))
                      else
                      Begin
                        {$IFDEF STK}
                          Global_GetMainRec(StockF,StockCode);

                          UseHed:=dbFormatName(StockCode,Stock.Desc[1]);

                        {$ENDIF}
                      end;

                    end;


              5  :  UseHed:=Strip('R',[#32],Major_Hed(AnalHed));

              6  :  UseHed:=Strip('R',[#32],JobMisc^.JobAnalRec.JAnalName);
            end; {Case..}

            MaxTLen:=Round(NLDPanel.Width/Canvas.TextWidth('e'));

            If (MaxTLen>10) and (OutJTNo<>2) then
              MaxTLen:=MaxTLen-10;

            UseHed:=Copy(UseHed,1,MaxTLen);

            If (OutJTNo<>2) and (JobCode<>JATreeJCode) then
              LineText:=LineText+UseHed+'. ('+Trim(JobCode)+')'
            else
              LineText:=LineText+UseHed;

            If (HedTotal) then
              LineText:='Total '+LineText;

            LineText:=LineText+Spc(Round((Width-Canvas.TextWidth(LineText))/CanVas.TextWidth(' '))-(TDpth*OutDepth));
          end;

          Items[n].Text:=LineText;

        end;


      end;

    end; {Loop..}

    EndUpdate;

  end; {With..}
end; {Proc..}


Procedure TJAView.Drill_OutLines(Depth,
                                 DepthLimit,
                                 PIndex        :  LongInt;
                                 UNLOLine      :   TSBSOutlineB);

Var
  JTMode          :  Byte;

  JHedNo,
  NextChild       :  LongInt;

  KeyPath         :  Integer;

  ONomRec,
  ChildNRec       :  ^OutNomType;

  ForcedOpen,
  LoopCtrl        :  Boolean;


Begin
  LoopCtrl:=BOff;
  ForcedOpen:=BOff;
  NextChild := -1;

  With UNLOLine do
  Begin
    If (Depth<DepthLimit) then
    Begin
      ONomRec:=Items[PIndex].Data;

      Repeat
        Case LoopCtrl of

          BOff  :  NextChild:=Items[PIndex].GetFirstChild;
          BOn   :  NextChild:=Items[PIndex].GetNextChild(NextChild);

        end; {Case..}

        If (ONomRec<>Nil) then
        With ONomRec^ do
        Begin
          If (NextChild>0) and (NotOpen) then
          Begin
            ChildNRec:=Items[NextChild].Data;

            ForcedOpen:=ChildNRec^.HedTotal;

            If (ForcedOpen) then
            Begin
              Dispose(ChildNRec);
              Delete(NextChild);

              NotOpen:=BOff;
            end;
          end;

          If (NextChild<1) or (ForcedOpen) then {* Try and find more for this level *}
          Begin
            If (Not LoopCtrl) and (Not HedTotal) and (OutJTNo<>6) and ((Not (OutNomCat In [SysAnlsProfit,SysAnlsWIP,SysAppPur,SysAppSal])) or (OutNomType=JobGrpCode)) then
            Begin
              If (OutNomType=JobGrpCode) and (OutJTNo=5) then
              Begin
                JTMode:=1;
                Keypath:=JCK;
                JHedNo:=OutNomCode;
              end
              else
              Begin
                JTMode:=6;
                KeyPath:=JCSecK;
                JHedNo:=OutNomCat;
              end;

              Add_OutLines(Depth,DepthLimit,PIndex,OutStkCode,JTMode,JHedNo,UNLOLine,JCtrlF,Keypath);

              ONomRec:=Items[PIndex].Data;

              If (OutJTNo=5) then
                Add_TotOutLines(Depth,DepthLimit,OutNomCode,PIndex,OutStkCode,OutStkCat,OutNomType,OutJTNo,OutNomCat,'Total '+Items[PIndex].Text);
            end;
          end;
        end;

        If (Not LoopCtrl) then
          LoopCtrl:=BOn;

      Until (NextChild<1);

    end; {If limit reached..}

  end; {With..}
end; {Proc..}




Procedure TJAView.Delete_OutLines(PIndex      :  LongInt;
                                  DelSelf     :  Boolean;
                                  UNLOLine    :  TSBSOutlineB);

Var
  IdxParent,
  OrigChild,
  NextChild       :  LongInt;

  ONomRec         :  ^OutNomType;

  LoopCtrl        :  Boolean;


Begin
  LoopCtrl:=BOff;
  IdxParent:=-1;


  With UNLOLine do
  Begin

    Repeat
      NextChild:=Items[PIndex].GetFirstChild;

      If (NextChild>0) then {* Try and find more for this level *}
      Begin
        ONomRec:=Items[NextChild].Data;

        If (Items[NextChild].HasItems) then {* Delete lower levels *}
          Delete_OutLines(NextChild,BOff,UNLOLine);

        Dispose(ONomRec);
        Delete(NextChild);
      end;


    Until (NextChild<1);

    If (DelSelf) then
    Begin
      ONomRec:=Items[PIndex].Data;

      IdxParent:=Items[PIndex].Parent.Index;

      Dispose(ONomRec);
      Delete(PIndex);

      If (IdxParent>0) then
      Begin
        Items[IdxParent].Collapse;
        Items[IdxParent].Expand;
        SelectedItem:=PIndex;
      end;
    end;

  end; {With..}
end; {Proc..}



procedure TJAView.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  {* Inform parent closing *}

  If (CanClose) then
    CanClose:=GenCheck_InPrint;

  If (CanCLose) then
  Begin
    If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
      Store_FormCoord(Not SetDefault);


    Send_UpdateList(WP_CLOSE_JOB_TOTALS_FORM);
  end;



end;

procedure TJAView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //HV 17/05/2017 2017-R2 ABSEXCH-18698: Access Violation message appears when clicking on Object Clone for a Job record
  if Assigned(Self.Owner) and (Self.Owner is TJAView) then
  begin
    with TJAView(Self.Owner) do
    begin
      if (InChild) and Assigned(ChildNom) then
        InChild:=BOff;
    end;
  end;
  Action:=caFree;
end;


procedure TJAView.FormDestroy(Sender: TObject);
var
  N       :  LongInt;
  ONomRec :  ^OutNomType;
begin

  With NLOLine do {* Tidy up attached objects *}
  Begin
    For n:=1 to ItemCount do
    Begin
      ONomRec:=Items[n].Data;
      If (ONomRec<>nil) then
        Dispose(ONomRec);
    end;

  end;

  {$IFDEF STK}
    With NLOLine2 do {* Tidy up attached objects *}
    Begin
      For n:=1 to ItemCount do
      Begin
        ONomRec:=Items[n].Data;
        If (ONomRec<>nil) then
          Dispose(ONomRec);
      end;

    end;
  {$ENDIF}

  {$IFDEF NOM}
    If (InHist) and (HistForm<>nil) then
    Begin
      InHist:=BOff;
      HistForm.Free;
    end;
  {$ENDIF}

  //HV 17/05/2017 2017-R2 ABSEXCH-18698: Access Violation message appears when clicking on Object Clone for a Job record
  if (ChildNom <> nil) then
    ChildNom := nil;

  If (JobActive) and (JobRecFrm<>nil) then
  Begin
    JobRecfrm.Free;
    JobActive:=BOff;
  end;

  ExLocal.Destroy;

end;



Function TJAView.CreateCaption  :  Str255;

Var
  LocTit  :  Str50;

Begin
  LocTit:='';


  Caption:='Job Totals for : '+Trim(JATreeJCode)+'. '+PPr_OutPr(NPr,NYr)+'. '+Show_TreeCur(NCr,NTxCr)+'.';
end;


Function TJAView.CreateGPCaption  :  Str255;

Begin
end;

procedure TJAView.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  InitSize.Y:=421;
  InitSize.X:=592;//553;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=349;
  Width:=590;}


  {$B-}

  If (Owner is TForm) and (Copy(TForm(Owner).Name,1,7)='JobView') then
  With TForm(Owner) do
  Begin
   {$B+}
    Self.Left:=Left+Width+1;
    Self.Top:=Top;
  end
  else
    MDI_SetFormCoord(TForm(Self));


  GotCoord:=BOff;
  NeedCUpdate:=BOff;
  FColorsChanged := False;

  StillMore:=BOff;
  UseYTD:=BOn;

  LastJobType:=#0;

  PageControl1.ActivePage:=CatPage;

  {$IFNDEF STK}
    StkPage.TabVisible:=BOff;
  {$ENDIF}


  Lab4Ofset:=Height-Panel4.Top+2;

  Lab5OfSet:=ClientHeight-PageControl1.Height;
  Lab6Ofset:=ClientWidth-PageControl1.Width;

  Lab1Ofset:=CatPage.Width-(NLDPanel.Width);
  Lab2Ofset:=CatPage.Width-NLCrPanel.Left;
  Lab3Ofset:=CatPage.Width-NLDrPanel.Left;
  Lab7Ofset:=CatPage.Width-NLAcPanel.Left;


  Find_FormCoord;


  ChrWidth:=InitWidth;

  ChrsXRoss:=(ChrWidth/Width);

//  If (Not Assigned(fImageRepos)) then
//    fImageRepos:=TImageRepos.Create(Self);
//
//  If (GetMaxColors(Self.Canvas.Handle)<2) or (Syss.UseClassToolB) then {Assign 16 bit speed buttons}
//  Begin
//    ToolBar.Images := fImageRepos.ilTBar16Col;
//    ToolBar.HotImages := nil;
//
//    FreeandNil(fImageRepos.ilTBar24Bit);
//    FreeandNil(fImageRepos.ilTBar24BitHot);
//
//  end
//  else
//  Begin
//    ToolBar.Images := fImageRepos.ilTBar24bit;
//    ToolBar.HotImages := fImageRepos.ilTBar24bitHot;
//
//    FreeandNil(fImageRepos.ilTBar16Col);
//  end;

  {$IFDEF MC_On}

    Set_DefaultCurr(Currency.Items,BOn,BOff);
    Set_DefaultCurr(Currency.ItemsL,BOn,BOn);

  {$ELSE}

    Currency.Visible:=BOff;
    NCurrLab.Visible:=BOff;
    TxLateChk.Visible:=BOff;

  {$ENDIF}


  JATreeJCode:=HJCode;

  ShowQty:=(Not PChkAllowed_In(143));

  If (Not ShowQty) then
    ShowQty:=Syss.ShowQtySTree;

  CreateGPCaption;

  // CJS 2014-07-08 - ABSEXCH-13227 - Password option for budget records
  MIRec.Visible:=ChkAllowed_In(uaAccessJobBudgetsMenu);
  UpdateBud1.Visible:=ChkAllowed_In(238);
  UpdateBud2.Visible:=UpdateBud1.Visible;

  Valuation1.Visible:=JAPOn and ChkAllowed_In(465);
  Valuation2.Visible:=JAPOn and ChkAllowed_In(465);

  Set_DefaultPr(Period.Items);

  Period.ItemIndex:=Pred(GetLocalPr(0).CPr);

  Set_DefaultYr(Year.Items,GetLocalPr(0).CYr);

  Year.ItemIndex:=10;

  Currency.ItemIndex:=0;
  MaxIn1Go:=500;
  WarnMaxRecs:=BOn;
  BeenUpdate:=BOff;

  FiltNType:=BOff;


  If (Owner is TJAView) then
    With TJAView(Owner) do
    Begin
      Self.Left:=Left+20;
      Self.Top:=Top+20;
      Self.Width:=Width;
      Self.Height:=Height;
      Self.NPr:=NPr;
      Self.NYr:=NYr;
      Self.NCr:=NCr;
      Self.NTxCr:=NTxCr;

      Self.Period.ItemIndex:=Period.ItemIndex;
      Self.Year.ItemIndex:=Year.ItemIndex;
      Self.Currency.ItemIndex:=Currency.ItemIndex;
      Self.TxLateChk.Checked:=TxLateChk.Checked;

      Self.NLOLine.Assign(NLOLine);

      StoreCoord:=BOff;

      Self.StoreCoordFlg.Enabled:=BOff;

      Self.N5.Visible:=BOff;
      IAmChild:=BOn;
    end
  else
  Begin
    IAmChild:=BOff;
    Add_OutLines(0,2,0,JATreeJCode,5,0,NLOLine,JCtrlF,JCK);

    NPr:=Succ(Period.ItemIndex);

    NYr:=TxlateYrVal(StrToInt(Year.Text),BOn);


    {$IFDEF MC_On}
      NCr:=Currency.ItemIndex;
    {$ELSE}
      NCr:=0;
    {$ENDIF}

    UpdateBud3.Visible:=BOn;

  end;



  CreateCaption;

  GotCoord:=BOn;

  JobActive:=BOff;
  JobRecFrm:=nil;

  // CA 23/07/2012 ABSEXCH-12952 - Setting the TreeColor
  NLOLine.TreeColor   := NLOLine.Font.Color;

  FormReSize(Self);
end;


procedure TJAView.FormResize(Sender: TObject);
begin
  If (GotCoord) then
  Begin
    GotCoord:=BOff;

    OrigSize.X:=ClientWidth;
    OrigSize.Y:=ClientHeight;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;



    {PageControl1.Height:=Height-Lab5Ofset;}

    PageControl1.Width:=ClientWidth-(2 * PageControl1.Left);//Lab6Ofset;
    PageControl1.Height:=ClientHeight-Lab5Ofset;

    NLOLine.Width:=PageControl1.ActivePage.ClientWidth-5;
    NLOLine.Height:=PageControl1.ActivePage.ClientHeight-25; {* This ratio is critical, and must follow the design form ratio! *}

    NLOLine2.Width:=NLOLine.Width;
    NLOLine2.Height:=NLOLine.Height;

    {PageControl1.Height:=SBSPanel1.Top-PageControl1.Top-9;}

    NLDPanel.Width:=PageControl1.ActivePage.Width-Lab1Ofset;
    NLCrPanel.Left:=PageControl1.ActivePage.Width-Lab2Ofset;
    NLDrPanel.Left:=PageControl1.ActivePage.Width-Lab3Ofset;
    NLAcPanel.Left:=PageControl1.ActivePage.Width-Lab7Ofset;

    NLDPanel2.Width:=NLDPanel.Width;
    NLCrPanel2.Left:=NLCrPanel.Left;
    NLDrPanel2.Left:=NLDrPanel.Left;
    NLAcPanel2.Left:=NLAcPanel.Left;

    ColXAry[3]:=NLDrPanel.Width+NLDrPanel.Left-4;
    ColXAry[2]:=NLCrPanel.Width+NLCrPanel.Left-4;
    ColXAry[1]:=NLAcPanel.Width+NLAcPanel.Left-4;

    ChrWidth:=Round(Width*ChrsXRoss);

    NLOLine.HideText:=(Width<=383);

    Update_OutLines(JCtrlF,NLOLine);

    {$IFDEF STK}
      If (StkPageVisible) then
        Update_OutLines(JCtrlF,NLOLine2);
    {$ENDIF}

    {ClientWidth:=OrigSize.X;
    ClientHeight:=OrigSize.Y;}

    GotCoord:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end;


end;

procedure TJAView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  If (NLOLine.SelectedItem>0) and (Key=VK_Delete)  then
  Begin
    GetSelRec;

    If Ok2DelJob(0,JobRec^) then
      Display_Account(3,BOn);

  end;
end;

procedure TJAView.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TJAView.SetHistoryMode(ONomCtrl     :  OutNomType;
                             Var NHMode,
                                 NBMode       :  Byte;
                             Var NBCMode      :  Boolean);

Begin
  With ONomCtrl do
  Begin
    Case OutJTNo of
      2  :  NHMode:=22 + (10*Ord(NDispMode=1));
      5  :  NHMode:=25 + (10*Ord(NDispMode=1));
      6  :  NHMode:=21 + (10*Ord(NDispMode=1));


    end; {case...}

    NBMode:=91+Ord(NHMode In [31..37]);

    NBCMode:=(NDispMode=2); {* Set Committed seperetly *}
  end;
end;


procedure TJAView.Display_History(ONomCtrl     :  OutNomType;
                                   ChangeFocus,
                                   ShowGraph    :  Boolean);

Var
  NomNHCtrl  :  TNHCtrlRec;

  FoundCode  :  Str20;

  KeyChk,
  KeyS       :  Str255;

  NChar      :  Char;
  fPr,fYr    :  Byte;

Begin
  {$IFDEF NOM}

    With NomNHCtrl,ONomCtrl do
    Begin
      FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

      SetHistoryMode(ONomCtrl,NHMode,NBMode,NHCommitMode);

      NHCr:=NCr;
      NHTxCr:=NTxCr;
      NHPr:=NPr;
      NHYr:=NYr;
      NHNomCode:=OutNomCode;

      NHCCode:=FullJDHistKey(OutStkCode,OutNomCode);


      If (JobRec^.JobCode<>OutStkCode) then
        GetJob(Self,OutStkCode,FoundCode,-1);

      If (ONomCtrl.OutJTNo=6) then
      Begin
        If (JobMisc^.JobAnalRec.JAnalCode<>OutStkCat) then
          GetJobMisc(Self,OutStkCat,FoundCode,2,-1);
      end;

      If (ONomCtrl.OutJTNo In [2,5]) then
      Begin
        If (JobCtrl^.JobBudg.HistFolio<>OutNomCode) then
        Begin
          Case ONomCtrl.OutJTNo of
            2  :  KeyChk:=PartCCKey(JBRCode,JBSubAry[OutJTNo])+Strip('R',[#0],FullJBCode(OutStkCode,0,OutStkCat));
            5  :  KeyChk:=PartCCKey(JBRCode,JBSubAry[OutJTNo])+Strip('R',[#0],FullJBCode(OutStkCode,0,FullNomKey(OutNomCode)));
          end;

          KeyS:=KeyChk;

          Status:=Find_Rec(B_GetGEq,F[JCtrlF],JCtrlF,RecPtr[JCtrlF]^,JCK,KeyS);

          If (Not StatusOk) or (Not CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))  then
            ResetRec(JCtrlF);
        end;
      end;


      NHKeyLen:=NHCodeLen+2;

      If (NHCommitMode) then
        NChar:=CommitHCode
      else
        NChar:=JobRec^.JobType;

      With JobRec^ do
      Begin
        Find_FirstHist(NChar,NomNHCtrl,fPr,fYr);
        MainK:=FullNHistKey(NChar,NHCCode,NCr,fYr,fPr);
        AltMainK:=FullNHistKey(NChar,NHCCode,NCr,0,0);
      end;

      Set_NHFormMode(NomNHCtrl);

    end;

    If (Not InHist) then
    Begin

      HistForm:=THistWin.Create(Self);

    end;

    Try

     InHist:=BOn;

     With HistForm do
     Begin

       WindowState:=wsNormal;


       If (ChangeFocus) then
         Show;


       ShowLink(BOn,ShowGraph);


     end; {With..}


    except

     InHist:=BOff;

     HistForm.Free;
     HistForm:=nil;

    end; {try..}

  {$ENDIF}
end;



procedure TJAView.LinkBudg_toHistory(BudMode  :  Byte);

Var
  ONomRec        :  ^OutNomType;
  LastDispMode   :  Integer;


Begin
  With GetNLOLine(0) do
    If (SelectedItem>0) then
    Begin
      LastDispMode:=NDispMode;

      ONomRec:=Items[SelectedItem].Data;

      Case BudMode of
        0,1  :  NDispMode:=BudMode;
      end;

      Display_History(ONomRec^,BOff,BOff);

      NDispMode:=LastDispMode;
    end;


end;


procedure TJAView.NLOLineExpand(Sender: TObject; Index: Longint);
Var
  Depth   :  LongInt;
  ONomRec :  ^OutNomType;
  IsMore  :  Boolean;

begin
  IsMore:=BOff;

  With (Sender as TSBSOutLineB) do
  Begin
    Depth:=Pred(Items[Index].Level);

    ONomRec:=Items[Index].Data;

    If (ONomRec<>nil) then
    With ONomRec^ do
    Begin
        If ((BeenDepth<Depth+2) or (NotOpen)) and (OutJTNo<>2) then
        Begin
          BeenDepth:=Depth+2;

          If (NotOpen) then
            Depth:=Succ(Depth);

          {BeginUpdate;}
          Drill_OutLines(Depth,Depth+2,Index,TSBSOutLineB(Sender));
          {EndUpdate;}
        end;
    end;

  end; {With..}

  If (InChild) and (Not IsMore) then
    ChildNom.NLOLine.ExpandxNCode(NLOLine.Items[Index].Data,BOn);


  If (Not IsMore) then
    ReconBtnClick(Sender);

end;

procedure TJAView.NLOLineCollapse(Sender: TObject; Index: Longint);
begin
  If (InChild) then
    ChildNom.NLOLine.ExpandxNCode(NLOLine.Items[Index].Data,BOff);
end;

Function TJAView.NLOLineAddProfit  :  Double;

Var
  ONomRec    :  ^OutNomType;
  PIdx,DCnst :  Integer;
  N          :  LongInt;
  FoundOk    :  Boolean;


Begin
  Result:=0.0; PIdx:=0; FoundOk:=BOff;  DCnst:=1;

  With NLOLine do
  Begin

    For n:=1 to ItemCount do
    Begin
      PIdx:=Items[n].Parent.Index;

      If (PIdx<=0) then
      Begin
        ONomRec:=Items[n].Data;

        With ONomRec^ do
        Begin
          FoundOk:=(OutNomCat=SysAnlsProfit);

          If (OutNomCat=SysAnlsRev) then
            DCnst:=DocNotCnst
          else
            DCnst:=1;
            
          If (Not FoundOk) then
          Begin
            Result:=Result+(LastDrCr[2]*DCnst);

          end
          else
            Break;
        end; {With..}
      end; {If level 0 item}
    end; {Loop..}

  end; {With..}

  Result:=Result;
end;



procedure TJAView.NLOLineNeedValue(Sender: TObject);

Const
  Fnum     =  JCtrlF;
  Keypath  =  JCK;

Var
  ONomRec      :  ^OutNomType;
  DrawIdxCode  :  LongInt;

  JBCurr,
  JNCR         :  Byte;

  ShowGP       :  Boolean;
  Profit,
  Sales,
  Purch,
  Bud1,
  Bud2,
  Cleared,

  Dnum,
  Dnum1,
  Dnum2,
  CommitVal,
  DCol2        :  Double;

  HistCode     :  Char;


  KeyS,
  KeyChk       :  Str255;


begin
  With Sender as TSBSOutLineB do
  Begin
    DrawIdxCode:=CalcIdx;

    ShowGP:=(PChkAllowed_In(143));

    JBCurr:=0;

    {$IFDEF EX601}
    If (NCr=0) then
      JNcR:=1
    else
      JNcR:=NCr;
    {$ELSE}

      JNCr:=NCr;
    {$ENDIF}

    If (DrawIdxCode>0) then
    Begin
      ONomRec:=Items[DrawIdxCode].Data;

      If (ONomRec<>nil) then
      With ONomRec^ do
      Begin
        If (DrawIdxCode=SelectedItem) then
        Begin
          If (OutJTNo=6) then
            lblDetailsCode.Caption:= 'Details : ' + OutStkCat
          else
          Begin
            If (JobRec^.JobCode<>OutStkCode) then
              GLobal_GetMainRec(JobF,OutStkCode);

            lblDetailsCode.Caption:= 'Details : ' + JobRec^.JobDesc;
          end;
        end;

        If (LastPr<>NPr) or (LastYr<>NYr) or (LastCr<>NCr) or (LastYTD<>UseYTD) or (LastTxCr<>NTxCr)
        or (LastHValue<>HideValue) or (LastSQty<>ShowQty) or (LastDMode<>NDispMode) or (BeenEdit) or (BeenUpdate) then
        Begin

          If (NDispMode=2) then
          Begin

            CommitVal:=Total_Profit_To_Date(CommitHCode,FullJDHistKey(OutStkCode,OutNomCode),NCr,
                                       NYr,NPr,Purch,Sales,Cleared,Bud1,Bud2,Dnum1,Dnum2,UseYTD);

            
          end
          else
            CommitVal:=0;

          Profit:=Total_Profit_To_Date(OutNomType,FullJDHistKey(OutStkCode,OutNomCode),NCr,
                                       NYr,NPr,Purch,Sales,Cleared,Bud1,Bud2,Dnum1,Dnum2,UseYTD);

          ColValue:=0;

          Blank(LastDrCr,Sizeof(LastDrCr));

          If (Not SyssJob^.JobSetUp.PeriodBud) then {* Replace period bud with anal bud *}
          Begin
            {KeyChk:=PartCCKey(JBRCode,JBSubAry[OutJTNo])+FullJobCode(OutStkCode)+FullNomKey(OutNomCode);

            KeyS:=KeyChk;

            Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

            If (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))  then}

            If (GetSelJARec(DrawIdxCode)) then
            With JobCtrl^.JobBudg do
            Begin
              Bud1:=BOValue;
              Bud2:=BRValue;

              Dnum1:=BOQty;
              Dnum2:=BRQty;

              {$IFDEF EX601}
                JBCurr:=JBudgetCurr;
              {$ENDIF}

            end;
          end
          else  {* Set by history... *}
          Begin


          end;

          If (Bud2=0) then
            Bud2:=Bud1;

          If (Dnum2=0) then
            Dnum2:=Dnum1;

          Case NDispMode of
            0  :  Begin

                    LastDrCr[1]:=Profit;

                    If (OutNomCat=SysAnlsProfit) then
                      Dnum:=NLOLineAddProfit*DocNotCnst
                    else
                      Dnum:=Currency_Txlate(Bud2,{$IFDEF EX601} JBCurr {$ELSE} 0 {$ENDIF},JNCr); {* Budget is always currency 0, so needs transalting *}

                    LastDrCr[2]:=Dnum;


                    LastDrCr[3]:=Profit-Dnum;

                  end;
            1  :  Begin
                    LastDrCr[1]:=Cleared;
                    LastDrCr[2]:=Dnum2;
                    LastDrCr[3]:=Cleared-Dnum2;
                  end;

            2  :  Begin
                    LastDrCr[1]:=Profit;
                    LastDrCr[2]:=Cleared;
                    LastDrCr[3]:=CommitVal;
                  end;

          end; {Case..}


          If (NDispMode In [0,2]) then
          Begin
            LastDrCr[1]:=Currency_Txlate(LastDrCr[1],NCr,NTxCr);

            If (NDispMode<>2) then
              LastDrCr[2]:=Currency_Txlate(LastDrCr[2],NCr,NTxCr);

            LastDrCr[3]:=Currency_Txlate(LastDrCr[3],NCr,NTxCr);
          end;


          LastPr:=NPr;
          LastYr:=NYr;
          LastCr:=NCr;
          LastTxCr:=NTxCr;
          LastYTD:=UseYTD;
          LastHValue:=HideValue;
          LastSQty:=ShowQty;
          LastDMode:=NDispMode;
          BeenEdit:=BOff;
        end; {If settings changed..}



        With Items[DrawIdxCode] do
          If (Not Expanded) or (Not HasItems) then
          Begin
            If (Not HideValue) then
            Begin
              ColValue:=LastDrCr[SetCol];

              ColFmt:=GenRealMask;

              Case NDispMode of
                1  :  ColFmt:=GenQtyMask;

                2  :  If (SetCol=2) then
                        ColFmt:=GenQtyMask;
              end; {Case..}

            end
            else
            Begin
              ColValue:=0.0;
              ColFmt:='';
            end;
          end;
          

          ColsX:=ColXAry[SetCol];
      end;
    end; {If found equiv index..}
  end;
end;





procedure TJAView.FullExBtnClick(Sender: TObject);
begin
  If (Sender=FullExBtn) then
  Begin
    NLOLine.StopDD:=BOn;

    If (InChild) then
      ChildNom.NLOLine.StopDD:=BOn;

    NLOLine.FullExpand;

    If (InChild) then
    Begin
      ChildNom.NLOLine.FullExpand;
      ChildNom.NLOLine.StopDD:=BOff;
    end;

    NLOLine.StopDD:=BOff;

  end
  else
  Begin
    NLOLine.FullCollapse;

    If (InChild) then
      ChildNom.NLOLine.FullCollapse;

  end;
end;


procedure TJAView.CurrencyClick(Sender: TObject);
begin
  NPr:=Succ(Period.ItemIndex);
  NYr:=TxLateYrVal(StrToInt(Year.Text),BOn);


  {$IFDEF MC_On}
    If (TxLateChk.Checked) then
      NTxCr:=Currency.ItemIndex
    else
      NCr:=Currency.ItemIndex;
  {$ENDIF}

  CreateCaption;

  NLOLine.Refresh;


  If (Sender<>nil) then
  Begin
    RefreshHist:=InHist;

    If (RefreshHist) then
      HistBtnClick(nil);

    RefreshRecon:=InRecon;

    If (RefreshRecon) then
      ReconBtnClick(nil);
  end;
end;

Procedure TJAView.SuperDDCtrl(Mode  :  Byte);

Var
  ONomRec   :  ^OutNomType;

Begin
  ONomRec := nil;

  With GetNLOLine(0),EXlocal do
  Begin
    If (SelectedItem>0) then
      ONomRec:=Items[SelectedItem].Data;

    {$B+}
      If (SelectedItem>0) and (Items[SelectedItem].HasItems) and (ONomRec^.OutNomType=JobGrpCode) then
    {$B-}
    Begin
      If (Mode=0) then
      Begin
        If (Not (LNHist.Pr In [YTD,YTDNCF])) then
          Period.ItemIndex:=Pred(LNHist.Pr)
        else
          Period.ItemIndex:=Pred(Period.Items.Count);


        Set_DefaultYr(Year.Items,LNHist.Yr);

        Year.ItemIndex:=10;

        YTDChk.Checked:=(LNHist.Pr In [YTD,YTDNCF]);

        UseYTD:=YTDChk.Checked;

        Items[SelectedItem].Expand;

        InHCallBack:=BOn;

        {$IFDEF NOM}
          CurrencyClick(HistForm);
        {$ELSE}
          CurrencyClick(nil);
        {$ENDIF}



        InHCallBack:=BOff;
        InHBeen:=BOn;
      end;
    end
    else
    Begin
      RefreshRecon:=BOn;

      {$IFDEF Nom}
        If (InHist) and (InRecon) or (Mode=0) then
          ReconBtnClick(HistForm);
      {$ENDIF}
    end;
  end
end;


procedure TJAView.GetSelRec;


Var
  ONomRec   :  ^OutNomType;
  FoundOk   :  Boolean;
  FoundCode :  Str20;

begin

  With GetNLOLine(0) do
  Begin
    If (SelectedItem>0) then
    Begin
      ONomRec:=Items[SelectedItem].Data;

      With ONomRec^ do
        If (JobRec^.JobCode<>OutStkCode) or (ExLocal.LJobRec^.JobCode<>OutStkCode) then
          FoundOk:=GetJob(Self,OutStkCode,FoundCode,-1);
    end;
  end; {With..}
end;


Function TJAView.GetSelJARec(INo  :  Integer)  :  Boolean;


Var
  ONomRec   :  ^OutNomType;
  FoundOk   :  Boolean;

  KeyChk,
  KeyS      :  Str255;

  ThisItem  :  Integer;


begin
  Result := False;
  With GetNLOLine(0) do
  Begin
    If (INo=-1) then
      ThisItem:=SelectedItem
    else
      ThisItem:=INo;

    If (ThisItem>0) then
    Begin
      ONomRec:=Items[ThisItem].Data;

      With ONomRec^ do
      Begin
        Case OutJTNo of
          2,6
             :  Begin
                  KeyChk:=Strip('R',[#0],PartCCKey(JBRCode,JBSubAry[OutJTNo])+FullJBCode(OutStkCode,0,OutStkCat));
                end;

          else  Begin
                  KeyChk:=PartCCKey(JBRCode,JBSubAry[OutJTNo])+Strip('R',[#0],FullJBCode(OutStkCode,0,FullNomKey(OutNomCode)));
                end;
        end; {case..}

        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[JCtrlF],JCtrlF,RecPtr[JCtrlF]^,JCK,KeyS);

        Result:=(StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));

      end;
    end;
  end; {With..}
end;



procedure TJAView.Display_Account(Mode             :  Byte;
                                  ChangeFocus      :  Boolean);

Var
  ONomRec    :  ^OutNomType;
  NomNHCtrl  :  TNHCtrlRec;

  LSelectedItem
             :  LongInt;
  ThisNode   :  TSBSOutLNode;


Begin
  ONomRec := nil;
  With GetNLOLine(0) do
  If (SelectedItem>0) then
  Begin
    LSelectedItem:=SelectedItem;
    ThisNode:=Items[LSelectedItem];

    ONomRec:=ThisNode.Data;
  end;

  GetSelRec;

  With NomNHCtrl,ONomRec^ do
  If (GetNLOLine(0).SelectedItem>0) then
  Begin
    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    NHMode:=Mode;

    NHCr:=NCr;
    NHTxCr:=NTxCr;

    NHPr:=NPr;

    NHYr:=NYr;

    NHNomCode:=OutNomCode;
    NHDDRecon:=OutNomCat;

    NHNeedGExt:=((OutNomCat In [SysAnlsProfit ,SysAnlsWIP]) and (NHMode In [5,15])) or (NHMode In [13..15]);

    If (NHNeedGExt) then
    With ExLocal do
    Begin
      NHPr:=LNHist.Pr;

      NHYr:=LNHist.Yr;

      If (OutNomCat In [SysAnlsProfit ,SysAnlsWIP]) then {* Adjust for Profit or WIP *}
        NHMode:=(16*Ord(OutNomCat=SysAnlsProfit))+(17*Ord(OutNomCat=SysAnlsWIP))+(2*Ord(NHMode In [15]));
    end
    {$IFDEF ExxxN560}
     else
       If (OutNomCat In [SysAppPur ,SysAppSal]) then {* Adjust for straight apps *}
          NHMode:=6;
    {$ELSE}
      ;
    {$ENDIF}




  end;{With..}

  JobMn2U.Set_DDFormMode(NomNHCtrl);

  If (Not Assigned(JobRecFrm)) then
  Begin
    JobRecFrm:=TFJobDisplay.Create(Self);

  end;

  try
    JobActive:=BOn;

    With NomNHCtrl,ONomRec^ do
    Begin

      InRecon:=(NHMode In [5,6,7,13..20]);

      JobRecFrm.Display_Account(NHMode,OutStkCode,OutStkCat,NCr,NTxCr,(NDispMode=2),nil);

    end;

  except
    JobRecFrm.Free;
    JobRecFrm:=nil;
    InRecon:=BOff;
  end; {try..}



end;




Procedure TJAView.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      41 :  Begin
              InHist:=BOff;

              If (Assigned(BudRec)) then
                BudRec.OutId;
            end;


      56 :  InChild:=BOff;

      52,53
         :  Begin
              ExLocal.AssignFromGlobal(NHistF);

              SuperDDCtrl(WParam-52)
            end;

      62
         :  Begin
              {ExLocal.AssignFromGlobal(StockF);
              ExLocal.AssignFromGlobal(NHistF);
              PlaceNomCode(ExLocal.LStock.StockFolio);
              SuperDDCtrl(0);}
            end;

      71 :  SendMessage(Self.Handle,WM_Close,0,0);

      75 :   Begin
                BeenUpdate:=BOn;

                {* Forced page change here as otherwise refresh has no effect *}
                PageControl1.ActivePage:=CatPage;

                {* v4.30c. Call this here so that sub menu off add gets removed before tab changes, otherwise get AV when chenging back to
                   Stock Tab *}
                   
                PageControl1Change(Nil);


                NLOLine.Refresh;

              end;



    end; {Case..}

  end;
  Inherited;
end;

Procedure TJAView.WMCustGetRec(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of
       25  :  NeedCUpdate:=BOn;

       36  :  Begin

                JobActive:=BOff;
                InRecon:=BOff;
              end;

       74 :   BeenUpdate:=BOff;

      116,117
          :  Begin
              {$IFDEF PF_On}
               With BudRec do
               Begin
                 ExLocal.AssignToGlobal(JCtrlF);

                 AddEditLine((LParam=1),(WParam=117));
               end;
              {$ENDIF}
            end;


      169  : With NLOLine do
               Items[SelectedItem].Expand;


      203  :  BudRec:=nil;

      204,205
           :  Begin
                LinkBudg_toHistory(WParam-204);
              end;

    end; {Case..}

  end;
  Inherited;
end;


Procedure TJAView.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TJAView.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    LParam:=-1;
    WParam:=Mode;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}




procedure TJAView.ClsI1BtnClick(Sender: TObject);
begin
  Close;
end;

procedure TJAView.NomSplitBtnClick(Sender: TObject);
begin
  If (Not InChild) then
  Begin
    HJCode:=JATreeJCode;

    ChildNom:=TJAView.Create(Self);
    InChild:=BOn;
  end;

  try
    With ChildNom do
    Begin
      Show;
    end;

  except

    InChild:=BOff;
    ChildNom:=nil;

  end; {try..}

end;

procedure TJAView.NLChildUpdate;

Var
  n   :  Integer;

Begin

  If (InChild) then
  Begin
    n:=ChildNom.NLOLine.FindxNCode(NLOLine.Items[NLOLine.SelectedItem].Data);

    If (n<>-1) then
      ChildNom.NLOLine.SelectedItem:=n;

    {$IFDEF STK}
      If (StkPageVisible) and (ChildNom.StkPageVisible) then
      Begin
        n:=ChildNom.NLOLine2.FindxNCode(NLOLine2.Items[NLOLine2.SelectedItem].Data);

        If (n<>-1) then
          ChildNom.NLOLine2.SelectedItem:=n;
      end;

    {$ENDIF}
  end;


end;


procedure TJAView.NLOLineDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  If (InHist) then
    HistBtnClick(nil);

//  If (InRecon) then
//    ReconBtnClick(nil);


  {If (JobRecFrm<>nil) and (JobActive) and (Not InRecon) then
    StkLink;}


//  NLChildUpDate;

end;


procedure TJAView.YTDChkClick(Sender: TObject);
begin
  UseYTD:=YTDChk.Checked;

  NLOLine.Refresh;
end;

Function TJAView.GetNLOLine(Mode  :  Byte)  :  TSBSOutLineB;

Begin
  {$IFDEF STK}
     If (StkPageVisible) then
       Result:=NLOLine2
     else
       Result:=NLOLine;

  {$ELSE}
    Result:=NLOLine;

  {$ENDIF}


end;

procedure TJAView.PopupMenu1Popup(Sender: TObject);

Var
  Ok2Edit  :  Boolean;
  n        : Integer;
  ONomRec  :  ^OutNomType;


begin
  Ok2Edit:=BOn;

  StoreCoordFlg.Checked:=StoreCoord;

  N3.Tag:=Ord(ActiveControl Is TSBSOutLineB);

  NDisp1.Visible:=(NDispMode<>0);
  NDisp2.Visible:=(NDispMode<>1);
  NDisp3.Visible:=(NDispMode<>2);


  With GetNLOLine(0) do
    If (SelectedItem>0) then
    Begin
      ONomRec:=Items[SelectedItem].Data;

      With ONomRec^ do
        {Ok2Edit:=(((OutJTNo=5) and (Not SyssJob^.JobSetUp.PeriodBud)) or (Not Items[SelectedItem].HasItems)) and (Not HedTotal);}
        Ok2Edit:=(Not HedTotal);

      If (ONomRec^.OutJTNo in [2,6]) then
      Begin
        If (GetSelJARec(-1)) then
          With Delete1 do
          Begin
            Enabled:=(Not ONomRec^.HedTotal) and (Ok2DelJB(ONomRec^.OutJTNo,JobCtrl^)) and (Ok2Edit);
            Visible:=BOn;
          end;
      end
      else
        Delete1.Visible:=BOff;

      With ExLocal, ONomRec^ do
        If (OutStkCode<>LJobRec^.JobCode) then
          ExLocal.LGetMainRecPos(JobF,ONomRec^.OutStkCode);

      Add1.Visible:=((ONomRec^.OutJTNo<>5) or ((ONomRec^.HedTotal) and (ONomRec^.OutJTNo=5))) and (ExLocal.LJobRec^.JobType<>JobGrpCode) and (Not InJobEdit);

      Edit1.Visible:={((ONomRec^.OutJTNo<>5) or (Not SyssJob^.JobSetUp.PeriodBud)) and} (Not ONomRec^.HedTotal);

      // CJS 2015-02-20 - ABSEXCH-15785 - SQL version of Update all Contracts
      // For SQL only, hide the previous menu options, and show the new one.
      If SQLUtils.UsingSQLAlternateFuncs And
         SQLReportsConfiguration.UseSQLUpdateJobCategoriesAndContracts Then
      begin
        // CJS 2016-04-22 - ABSEXCH-17272 - Add Individual Job Budget Update
        UpdateBud1.Visible := ChkAllowed_In(238);
        UpdateBud2.Visible := False;
        UpdateBud3.Visible := False;
        UpdateAllCategoriesandContracts1.Visible := UpdateBud1.Visible;
      end
      else
      begin
        UpdateBud1.Visible := ChkAllowed_In(238);
        UpdateBud2.Visible := UpdateBud2.Visible;
        UpdateAllCategoriesandContracts1.Visible := False;
        // MH 03/07/2009: Modified 'Update This Contract' menu option to only be available on Contracts.
        UpdateBud3.Visible := (ExLocal.LJobRec^.JobType = JobGrpCode);
      end;
    end
    else
    Begin
      Ok2Edit:=BOff;
      Delete1.Enabled:=BOff;
      Add1.Visible:=(ExLocal.LJobRec^.JobType<>JobGrpCode);
    end;

  Edit1.Enabled:=Ok2Edit;
end;

procedure TJAView.SetFieldProperties;

Var
  n  : Integer;


Begin

  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TSBSComboBox)
     or (Components[n] is TCurrencyEdit) and (Components[n]<>Period) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(Period.Font);
        Color:=Period.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        CheckColor:=Period.Color;
      end;

  end; {Loop..}


end;


procedure TJAView.SetFormProperties(SetList  :  Boolean);

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
      With NLOLine do
      Begin
        TmpPanel[1].Font:=Font;
        TmpPanel[1].Color:=Color;

        TmpPanel[2].Color:=HLBarColor;
        TmpPanel[2].Font.Assign(TmpPanel[1].Font);
        TmpPanel[2].Font.Color:=HLBarTextColor;


        TmpPanel[3].Color:=BarColor;
        TmpPanel[3].Font.Assign(TmpPanel[1].Font);
        TmpPanel[3].Font.Color:=BarTextColor;
      end;


    end
    else
    Begin
      TmpPanel[1].Font:=Period.Font;
      TmpPanel[1].Color:=Period.Color;

      TmpPanel[2].Font:=Panel4.Font;
      TmpPanel[2].Color:=Panel4.Color;
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
            With NLOLine do
            Begin
              Font.Assign(TmpPanel[1].Font);
              Color:=TmpPanel[1].Color;

              {NLDPanel.Font.Assign(TmpPanel[2].Font);
              NLDPanel.Color:=TmpPanel[2].Color;}


              BarColor:=TmpPanel[3].Color;
              BarTextColor:=TmpPanel[3].Font.Color;

              HLBarColor:=TmpPanel[2].Color;
              HLBarTextColor:=TmpPanel[2].Font.Color;

              {NLCrPanel.Font.Assign(TmpPanel[2].Font);
              NLCrPanel.Color:=TmpPanel[2].Color;

              NLDrPanel.Font.Assign(TmpPanel[2].Font);
              NLDrPanel.Color:=TmpPanel[2].Color;}

              // CA 23/07/2012 ABSEXCH-12952 - Setting the TreeColor
              NLOLine.TreeColor   := NLOLine.Font.Color;

            end;

            {$IFDEF STK}

              With NLOLine2 do
              Begin
                Font.Assign(TmpPanel[1].Font);
                Color:=TmpPanel[1].Color;

                {NLDPanel.Font.Assign(TmpPanel[2].Font);
                NLDPanel.Color:=TmpPanel[2].Color;}


                BarColor:=TmpPanel[3].Color;
                BarTextColor:=TmpPanel[3].Font.Color;

                HLBarColor:=TmpPanel[2].Color;
                HLBarTextColor:=TmpPanel[2].Font.Color;

                {NLCrPanel.Font.Assign(TmpPanel[2].Font);
                NLCrPanel.Color:=TmpPanel[2].Color;

                NLDrPanel.Font.Assign(TmpPanel[2].Font);
                NLDrPanel.Color:=TmpPanel[2].Color;}

              end;
            {$ENDIF}
          end
          else
          Begin
            Period.Font.Assign(TmpPanel[1].Font);
            Period.Color:=TmpPanel[1].Color;

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


procedure TJAView.PropFlgClick(Sender: TObject);
begin
  SetFormProperties(N3.Tag=1);
  N3.Tag:=0;
end;


procedure TJAView.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;



procedure TJAView.NLOLineMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NLChildUpDate;
end;


procedure TJAView.TxLateChkClick(Sender: TObject);
begin
  If (TxLateChk.Checked) then
    Currency.ItemIndex:=NTxCr
  else
    Currency.ItemIndex:=NCr;
end;


procedure TJAView.HistBtnClick(Sender: TObject);
Var
  ONomRec  :  ^OutNomType;
  DispRec  :  Boolean;
  UNLOLine :  TSBSOutlineB;



begin
  {$IFDEF NOM}
    DispRec:=BOff;

    {$IFDEF STK}
       If (StkPageVisible) then
         UNLOLine:=NLOLine2
       else
         UNLOLine:=NLOLine;

    {$ELSE}
      UNLOLine:=NLOLine;

    {$ENDIF}

    With UNLOLine do
    Begin
      ONomRec:=Items[SelectedItem].Data;

      If (InHist) then
        With ONomRec^ do
        DispRec:=((HistForm.NHCtrl.NHCCode<>FullJDHistKey(OutStkCode,OutNomCode)) or (Sender<>nil) or (RefreshHist));


      If ((Not InHist) or (DispRec)) and (Not InHCallBack) then
        Display_History(ONomRec^,(Sender<>nil),((Sender=GraphBtn) or (Sender=Graph1)));

      ReFreshHist:=BOff;
    end;
  {$ENDIF}
end;

procedure TJAView.StkLink;
Var
  DispRec  :  Boolean;

begin
  DispRec:=BOff;

  If (JobRecFrm<>nil) and (JobActive) then
  With JobRecFrm do
  Begin
    GetSelRec;

    If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) and ((JobRec^.JobCode<>TFJobCCode) or (JobMisc^.JobAnalRec.JAnalCode<>TFJobACode)) then
    Begin
      Self.Display_Account(0,BOff);
    end;
  end;

end;


procedure TJAView.MIEALClick(Sender: TObject);
begin
  If (Sender is TMenuItem) then
  With NLOLine do
  Begin
    StopDD:=BOn;

    Case TMenuItem(Sender).Tag of
      1  :  Items[SelectedItem].Expand;
      2  :  Items[SelectedItem].FullExpand;
      3  :  FullExpand;
      4  :  Items[SelectedItem].Collapse;
      5  :  FullCollapse;
    end; {case..}

    StopDD:=BOff;
  end;
end;

procedure TJAView.PeriodKeyPress(Sender: TObject; var Key: Char);
begin
  If (Not (Key In ['0'..'9',#8,#13])) and (Not GetLocalPr(0).DispPrAsMonths) then
    Key:=#0;
end;


procedure TJAView.PeriodExit(Sender: TObject);
begin
  If (Sender is TSBSComboBox) then
    With TSBSComboBox(Sender) do
    Begin
      If (IntStr(Text)=0) and (Not GetLocalPr(0).DispPrAsMonths) then
      Begin
        ItemIndeX:=0;
        Text:=Items.Strings[0];
      end;

      If (Sender=Period) then
        Text:=SetPadNo(Text,2);

      If (Sender<>Currency) then
        ItemIndex:=Set_TSIndex(Items,ItemIndex,Text);

      CurrencyClick(Sender);
    end;
end;



procedure TJAView.Display_BudRec(Mode,JM  :  Byte);


Begin
  {$B-}

  If (Mode=1) or (GetSelJARec(-1)) then
  Begin

  {$B+}
    SetPRStk:=JM;

    If (BudRec=nil) then
    Begin

      BudRec:=TJobBudget.Create(Self);

    end;

    Try


     With BudRec do
     Begin

       WindowState:=wsNormal;
       {Show;}


       If (Mode In [1..4]) then
       Begin

         Case Mode of

           1..2,4
               :   If (Not ExLocal.InAddEdit) then
                   Begin
                     EditLine(Self.ExLocal.LJobRec^,(Mode<>1));

                     If (Mode=4) then
                     Begin
                       PageControl1.ActivePage:=ValPage;

                       If (BAV8F.CanFocus) then
                          BAV8F.SetFocus;
                     end;
                   end
                     else
                       Show;
              3  :  If (Not ExLocal.InAddEdit) then
                       DeleteJBLine(JCtrlF,JCK,Self.ExLocal.LJobRec^);
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except

     BudRec.Free;


    end;
  end; {If..}
end;




Procedure TJAView.AddEditLine(Edit,
                              DelMode  :  Boolean);

Var
  Depth,
  OIndex,
  NewIdx   :  Integer;
  PNode    :  TSBSOutLNode;
  NewFolio,
  HTxFolio :  LongInt;
  MJCode   :  Str20;
  ONomRec  :  ^OutNomType;
  UNLOLine :  TSBSOutLineB;


Begin
  UNLOLine:=GetNLOLine(0);

  With UNLOLine,JobCtrl^.JobBudg do
  If (Not Edit) then
  Begin
    NewFolio:=HistFolio;

    MJCode:=JobCode;

    If (SelectedItem>0) then
      PNode:=Items[SelectedItem].Parent
    else
      PNode:=nil;

    If (Assigned(PNode)) then
      ONomRec:=PNode.Data
    else
      ONomRec:=nil;

    HTxFolio:=HFolio_TxLate(AnalHed);

    {$B-}

    If (PNode<>nil) and (Assigned(ONomRec)) and (ONomRec^.OutNomCode<>HTxFolio)  then {* We are in the wrong heading... *}
    {$B+}

    Begin
      PNode.Collapse;

      OIndex:=FindNode(HTxFolio,MJCode);

      If (OIndex>0) then
      Begin
        SelectedItem:=OIndex;

        PNode:=Items[OIndex];

        ONomRec:=PNode.Data;

        ONomRec^.BeenDepth:=0;
        PNode.Collapse;

        Delete_OutLines(OIndex,BOff,UNLOLine);

        Depth:=Pred(PNode.Level);

        Drill_OutLines(Depth,Depth+2,OIndex,UNLOLine);
        PNode.Expand;
      end;
    end
    else
    Begin
      {$B-}
      If (SelectedItem=0) or (Items[SelectedItem].Parent.Index<=0) then
      Begin
      {$B+}

        If (SelectedItem>0) then
        Begin
          PNode:=Items[SelectedItem];

          Repeat

            Delete_OutLines(1,BOn,UNLOLine);

          Until (ItemCount<=0);
        end;

        If (StkPageVisible) then
         Add_OutLines(0,2,0,JATreeJCode,2,0,UNLOLine,JCtrlF,JCSecK)
       else
         Add_OutLines(0,2,0,JATreeJCode,5,0,UNLOLine,JCtrlF,JCK);

      end
      else
      Begin
        PNode:=Items[SelectedItem].Parent;
        OIndex:=PNode.Index;

        ONomRec:=PNode.Data;

        ONomRec^.BeenDepth:=0;
        PNode.Collapse;

        Delete_OutLines(OIndex,BOff,UNLOLine);

        Depth:=Pred(PNode.Level);

        Drill_OutLines(Depth,Depth+2,OIndex,UNLOLine);
        PNode.Expand;
      end;
    end;

    OIndex:=FindNode(NewFolio,MJCode);

    If (OIndex<>-1) then
      SelectedItem:=OIndex;
  end
  else
  Begin
    GetSelJARec(-1);
    ONomRec:=Items[SelectedItem].Data;

    With ONomRec^,JobCtrl^.JobBudg do
    Begin
      {* Edit description here *}
      BeenEdit:=BOn;
    end;

    {Items[SelectedItem].Text:=FormatLine(ONomRec^,Stock.Desc[1]);}
  end;

end;


{ ======= Function to find the note a nominal code resides at ======= }

function TJAView.FindNode(NCode  :  LongInt;
                          JCode  :  Str20)  :  Integer;

Var
  n          :  Integer;
  FoundOk    :  Boolean;


Begin
  FoundOk:=BOff;

  With NLOLine do
    For n:=1 to ItemCount do
    Begin
      FoundOk:=(OutNomType(Items[n].Data^).OutNomCode=NCode) and (OutNomType(Items[n].Data^).OutStkCode=JCode);

      If (FoundOk) then
        Break;
    end;

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;

end;

Function TJAView.Advanced_FindNomCode(SC     :  Str20;
                                       SF     :  LongInt;
                                       Fnum,
                                       Keypath:  Integer)  :  Integer;

Var
  KeyS     :    Str255;
  ONomRec  :    ^OutNomType;


Begin
  Result:=-1;

  KeyS:=SC;

  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  If (StatusOk) then
  Begin
    Result:=FindNode(Stock.StockFolio,SC);

    If (Result=-1) then {* Atempt to load that up *}
    Begin
      If (Not EmptyKey(Stock.StockCat,StkKeyLen)) then
      Begin
        Result:=Advanced_FindNomCode(Stock.StockCat,Stock.StockFolio,Fnum,Keypath);
      end;
    end;

    If (Result<>-1) then
    With NLOLine do
    Begin
      ONomRec:=Items[Result].Data;

      If (ONomRec^.NotOpen) then
      Begin
        Items[Result].Expand;

        
      end;

      Result:=FindNode(SF,SC);
    end;
  end;


end;



Procedure TJAView.PlaceNomCode(FindCode  :  LongInt);

Const
  Fnum     =  StockF;
  Keypath  =  StkCodeK;

Var
  FoundOk    :  Boolean;
  FoundCode  :  Str20;
  KeyS       :  Str255;
  n          :  Integer;
  FoundLong  :  LongInt;

Begin


end;


Procedure TJAView.FindStkCode;

Const
  Fnum     =  NomF;
  Keypath  =  NomCodeK;

Var
  InpOk,
  FoundOk  :  Boolean;

  FoundCode:  Str20;
  FoundLong
           :  LongInt;

  n,INCode :  Integer;

  SCode    :  String;

  KeyS     :  Str255;


Begin

  SCode:='';
  FoundOk:=BOff;

  Repeat

    InpOk:=InputQuery('Find Stock Record','Please enter the stock code you wish to find',SCode);

    {If (InpOk) then
      FoundOk:=GetStock(Self,SCode,FoundCode,99);}

  Until (FoundOk) or (Not InpOk);

  If (FoundOk) then
  Begin
    PlaceNomCode(Stock.StockFolio);
  end;


end;


procedure TJAView.MIFindClick(Sender: TObject);
begin
  FindStkCode;
end;

Function TJAView.Page2Mode(CP  :  Integer)  :  Byte;

Begin
  Case CP of

    1,0  :  Result:=0;
    2    :  Result:=5;
    3    :  Result:=10;
    4    :  Result:=6;
    5    :  Result:=9;
    else    Result:=6;

  end; {Case..}
end;

procedure TJAView.ReconBtnClick(Sender: TObject);
Var
  ONomRec  :  ^OutNomType;
  DispRec  :  Boolean;
  RMode    :  Byte;
  SelectionChanged: Boolean;


begin
  DispRec:=BOff;


  With GetNLOLine(0) do
  Begin
    ONomRec:=Items[SelectedItem].Data;

    If (InRecon) and (Assigned(JobRecFrm)) then
    Begin
      // CJS 30/11/2010 - Amended check so that the drill-down is refreshed
      //                  on a change to a different line, rather than only
      //                  on a change to a different branch in the Job Tree.
      SelectionChanged := (JobRecFrm.TFJobACode <> ONOmRec^.OutStkCat) or
                          (JobRecFrm.TFJobCCode <> ONomRec^.OutStkCode);
      DispRec := ((SelectionChanged and (Not ONomRec^.HedTotal)) or (Sender<>nil));

//      DispRec:=(((JobRecFrm.TFJobACode<>ONOmRec^.OutStkCat) and (Not ONomRec^.HedTotal)) or (Sender<>nil)
//                 {or (RefreshRecon)});

    end;

    RMode:=ONomRec^.OutJTNo;

    If (RMode=2) then
      RMode:=7;

  {$IFDEF Nom}
    If (Sender=HistForm) and (Sender<>nil) then
    Begin
      Case RMode of
        5  :  RMode:=15;
        6  :  RMode:=13;
        7  :  RMode:=14;
      end; {Case..}
    end;
  {$ENDIF}


    {$IFDEF Nom}
      If ((Not InRecon) or (DispRec)) and ((Not Items[SelectedItem].HasItems) or (RMode In [13..15])) and (Not InHCallBack) and (Not ONomRec.HedTotal) and (Not StopDD) then
        Display_Account(RMode,((Sender<>nil) and (Sender<>HistForm)));
    {$ELSE}
      If ((Not InRecon) or (DispRec)) and ((Not Items[SelectedItem].HasItems) or (RMode In [13..15])) and (Not InHCallBack) and (Not ONomRec.HedTotal) then
        Display_Account(RMode,(Sender<>nil));
    {$ENDIF}

    ReFreshRecon:=BOff;
  end;
end;




procedure TJAView.Edit1Click(Sender: TObject);

Var
  RB,JM    :  Byte;
  Ok2Edit  :  Boolean;
  ONomRec  :  ^OutNomType;

begin
  Ok2Edit:=BOn;

  If (Sender is TMenuItem) then
  Begin
    RB:=TMenuItem(Sender).Tag;

    If (GetNLOLine(0).SelectedItem>0) or (RB=1) then
    With GetNLOLine(0) do
    Begin
      If (RB<>1) then
      Begin
        ONomRec:=Items[SelectedItem].Data;
        JM:=ONomRec^.OutJTNo;

        Ok2Edit:=(JM=5) or (Not Items[SelectedItem].HasItems);
      end
      else
        JM:=(2*Ord(StkPageVisible))+(6*Ord(Not StkPageVisible));

      If (Ok2Edit) then
        Display_BudRec(RB,JM);
    end;

  end;
end;

procedure TJAView.Add1Click(Sender: TObject);
begin
  If (Not StkPageVisible) then
    Edit1Click(Sender);
end;

procedure TJAView.TimeRate1Click(Sender: TObject);
begin
  SetPRMode:=(TMenuItem(Sender).Tag=1);

  Edit1Click(Add1);
end;


procedure TJAView.OptBtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  With TWinControl(Sender) do
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    ListPoint:=ClientToScreen(ListPoint);

  end;



  PopUpMenu1.PopUp(ListPoint.X,ListPoint.Y);
end;


procedure TJAView.UpdateBud1Click(Sender: TObject);
Var
  SQLCaller: TSQLCaller;
  ConnectionString: string;
  CompanyCode: string;
  Res : Integer;
begin
  {$IFDEF POST}
  // CJS 2016-04-22 - ABSEXCH-17272 - Add Individual Job Budget Update
  If SQLUtils.UsingSQLAlternateFuncs And SQLReportsConfiguration.UseSQLUpdateCategoryLevels Then
  begin
    if not GetProcessLock(plUpdateJobBudgets) then
      EXIT;
    UpdateJobBudgets(True);
  end
  Else
    // Create legacy thread object
    AddJobPostBud2Thread(Self.Owner,30+Ord(StkPageVisible),JATreeJCode,nil,Self.Handle);
  {$ENDIF}
end;


procedure TJAView.UpdateBud2Click(Sender: TObject);
begin
  if not GetProcessLock(plUpdateJobBudgets) then
    EXIT;
  AddJobPostBud2Thread(Self.Owner,TMenuItem(Sender).Tag,JATreeJCode,nil,Self.Handle);
end;

procedure TJAView.Valuation2Click(Sender: TObject);

Var
  ONomRec  :  ^OutNomType;
  TInv     :  InvRec;
  TId      :  Idetail;

begin
  Blank(TInv,Sizeof(TInv));
  Blank(TId,Sizeof(TId));

  If (Sender is TMenuItem) then
  Begin

    If (GetNLOLine(0).SelectedItem>0) then
    With GetNLOLine(0) do
    Begin
      ONomRec:=Items[SelectedItem].Data;

      With ONomRec^ do
      Begin
        Set_JPAJCT(TInv,TId,JSA,'',OutStkCode,1,0);
      end; {With..}

      with TJobAppWizard.Create(Self) do
      Begin
        Show;

        A1UseValcb.Checked:=BOn;
      end;

    end;

  end;

end;


Function TJAView.Is_NodeParent(MIdx,SIdx  :  Integer)  :  Boolean;

Var
  PIdx,TIdx  :  Integer;

Begin
  Result:=BOff;

  With NLOLine do
  Begin
    TIdx:=SIdx;

    Repeat
      PIdx:=Items[TIdx].Parent.Index;

      Result:=(PIdx=MIdx);

      TIdx:=PIdx;

    Until (Result) or (PIdx<=0);

  end;


end;

Function TJAView.Place_InOrder(MIdx,SIdx  :  Integer;
                            Var UseAdd     :  Boolean)  :  Integer;

Var
  ONomRec    :  ^OutNomType;
  PIdx,TIdx  :  Integer;
  N          :  LongInt;
  NNC        :  Str20;
  FoundOk    :  Boolean;

Begin
  FoundOk:=BOff;  UseAdd:=BOff;

  Result:=SIdx;

  With NLOLine do
  Begin
    ONomRec:=Items[MIdx].Data;

    NNC:=ONomRec^.OutStkCode;

    PIdx:=Items[SIdx].Parent.Index;


    If (PIdx>0) then
    Begin
      TIdx:=Items[PIdx].GetFirstChild;

      While (TIdx>0) and (Not FoundOk) do
      Begin
        ONomRec:=Items[TIdx].Data;

        With ONomRec^ do
          FoundOk:=((OutStkCode>NNC) or (HedTotal));


        If (Not FoundOk) then
          TIdx:=Items[PIdx].GetNextChild(TIdx);

      end;
    end
    else
    Begin
      TIdx := -1;
      For n:=1 to ItemCount do
      Begin
        PIdx:=Items[n].Parent.Index;

        If (PIdx<=0) then {* its a level 0 item *}
        Begin
          TIdx:=n;

          ONomRec:=Items[TIdx].Data;

          With ONomRec^ do
            FoundOk:=(OutStkCode>NNC);

          If (FoundOk) then
            Break;
        end;
      end;

      If (Not FoundOk) then
        Result:=TIdx;
    end;

  end; {With..}

  If (FoundOk) then
    Result:=TIdx
  else
  Begin
    UseAdd:=BOn;
  end;

end;


procedure TJAView.UpdateHeadings(NIdx  :  Integer);

Var
  DCTit  :  Array[1..3] of Str30;

Begin
  Case NIdx of

    1  :  Begin
            DCTit[1]:='Actual Qty/Hrs '; DCTit[2]:='Qty/Hrs Budget  '; DCTit[3]:='Qty/Hrs Variance ';
          end;
    2  :  Begin
            DCTit[1]:='Actual Value  '; DCTit[2]:='Actual Qty/Hrs  '; DCTit[3]:='Committed  ';
          end;
    else  Begin
            DCTit[1]:='Actual Value  '; DCTit[2]:='Budget  '; DCTit[3]:='Variance  ';
          end;

  end; {Case..}

  NLAcPanel.Caption:=DCTit[1];
  NLCrPanel.Caption:=DCTit[2];
  NLDrPanel.Caption:=DCTit[3];

  NLAcPanel2.Caption:=NLAcPanel.Caption;
  NLCrPanel2.Caption:=NLCrPanel.Caption;
  NLDrPanel2.Caption:=NLDrPanel.Caption;

end;

procedure TJAView.NDisp1Click(Sender: TObject);
begin
  NDispMode:=TMenuItem(Sender).Tag;

  UpdateHeadings(NDispMode);

  Update_OutLines(JCtrlF,NLOLine);

  {$IFDEF STK}
    Update_OutLines(JCtrlF,NLOLine2);
  {$ENDIF}

end;

Function TJAView.StkPageVisible  :  Boolean;

  Begin
    Result:=PageControl1.ActivePage=StkPage;
  end;


{$IFDEF STK}

  procedure TJAView.ApplyNewSPayJCode;

  Begin
    With NLOLine2 do
      If (ItemCount>0) then
      Repeat

        Delete_OutLines(1,BOn,NLOLine2);

      Until (ItemCount<=0);

    Add_OutLines(0,2,0,JATreeJCode,2,0,NLOLine2,JCtrlF,JCSecK);

    If (InChild) then
      ChildNom.ApplyNewSPayJCode;

  end;

  
{$ENDIF}

procedure TJAView.ApplyNewJCode(JCode  :  Str20);

Begin
  With NLOLine do
    If (ItemCount>0) then
    Repeat

      Delete_OutLines(1,BOn,NLOLine);

    Until (ItemCount<=0);

  JATreeJCode:=JCode;

  CreateCaption;

  Add_OutLines(0,2,0,JATreeJCode,5,0,NLOLine,JCtrlF,JCK);

  If (InChild) then
    ChildNom.ApplyNewJCode(JCode);

  {$IFDEF STK}
    If (StkPageVisible) then
      ApplyNewSPayJCode;

  {$ENDIF}


end;

procedure TJAView.PageControl1Change(Sender: TObject);
begin
  {$IFDEF STK}
    If (StkPageVisible) then
    Begin
      CreateSubMenu(SBSPopUpMenu1,Add1);
      ApplyNewSPayJCode;
    end
    else
      DeleteSubMenu(Add1);

  {$ENDIF}
end;

procedure TJAView.Filter1Click(Sender: TObject);
begin
  FiltNType:=Not FiltNType;

  Filter1.Checked:=FiltNType;
end;

procedure TJAView.SetTabxJType(JT  :  Char);

Begin
  {$IFDEF STK}

    If (JT<>LastJobType) then
    Begin
      If (JT=JobGrpCode) then
      Begin
        If (PageControl1.ActivePage<>CatPage) then
        Begin
          PageControl1.ActivePage:=CatPage;
          DeleteSubMenu(Add1);
        end;

        StkPage.TabVisible:=BOff;

      end
      else
        StkPage.TabVisible:=BOn;

      LastJobType:=JT;
    end;
  {$ENDIF}

end;

procedure TJAView.NLOLineClick(Sender: TObject);
begin
  If (InRecon) then
    ReconBtnClick(nil);
  NLChildUpDate;
end;

{ CJS 2012-08-28 - ABSEXCH-11183 - Stock Code and Time Rate clash }
procedure TJAView.NLOLine2UpdateNode(Sender: TObject;
  var Node: TSBSOutLNode; Row: Integer);
var
  ONomRec: ^OutNomType;
begin
  ONomRec := Node.Data;
  if Trim(ONomRec^.OutViewCode) = '' then
    Node.UseLeafX := obLeaf
  else
    Node.UseLeafX := obLeaf2
end;

// CJS 2015-02-20 - ABSEXCH-15785 - SQL version of Update all Contracts
procedure TJAView.UpdateAllCategoriesandContracts1Click(Sender: TObject);
begin
  if not GetProcessLock(plUpdateJobBudgets) then
    EXIT;
  UpdateJobBudgets(False);
end;

// CJS 2016-04-22 - ABSEXCH-17272 - Add Individual Job Budget Update
procedure TJAView.UpdateJobBudgets(CategoriesOnly: Boolean);
var
  SQLCaller: TSQLCaller;
  ConnectionString,
  lPassword: WideString;
  CompanyCode: string;    //VA:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  Res : Integer;
  i: Integer;
  Title: string;
  lRes: Integer;
begin
  // Execute the stored procedure and update the window
  SQLCaller := TSQLCaller.Create;
  Try
    CompanyCode := SQLUtils.GetCompanyCode(SetDrive);

    if CategoriesOnly then
      Title := 'Category Level'
    else
      Title := 'Categories and Contracts';

    // Get an admin connection string (not read-only)
    //SQLUtils.GetConnectionString(CompanyCode, False, ConnectionString);
    //VA:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    lRes := SQLUtils.GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword);
    SQLCaller.ConnectionString := ConnectionString;
    SQLCaller.Connection.Password := lPassword;

    // CJS 2016-03-23 - ABSEXCH-17271 - Job Budgets - SQL improvements
    SQLCaller.Connection.CommandTimeout := SQLReportsConfiguration.RollupJobBudgetsTimeoutInSeconds;
    SQLCaller.Query.CommandTimeout := SQLReportsConfiguration.RollupJobBudgetsTimeoutInSeconds;
    Screen.Cursor := crHourGlass;
    try
      if CategoriesOnly then
        Res := SQLCaller.ExecSQL('[COMPANY].esp_RollupJobBudgets 1, ''' + JATreeJCode + '''', CompanyCode)
      else
        Res := SQLCaller.ExecSQL('[COMPANY].esp_RollupJobBudgets', CompanyCode);
    finally
      Screen.Cursor := crDefault;
    end;
    If (Res >= 0) Then
    begin
      // Update tree
      SendMessage(Self.Handle, WM_FormCloseMsg, 75, 0);
      Application.MessageBox(PChar(Title + ' updated'), PChar('Update ' + Title))
    end
    Else
      Application.MessageBox(PChar('The following error occurred updating ' + Title + #13 + SQLCaller.ErrorMsg), PChar('Update All ' + Title));
  Finally
    Screen.Cursor := crDefault;
    SQLCaller.Free;
    if Assigned(Application.Mainform) then
       SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plUpdateJobBudgets), 0);
  End;
end;

Initialization

  HJCode:='';

end.
