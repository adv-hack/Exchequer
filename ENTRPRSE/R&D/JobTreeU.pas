unit JobTreeU;

{$I DEFOVR.Inc}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Grids,StdCtrls, OutLine, SBSOutl, TEditVal,
  GlobVar,VarConst,ETStrU,BtrvU2,BTSupU1, BTKeys1U,ExtCtrls, Buttons,
  BorBtns, Menus,

  ExWrap1U,

  JobMn2U,
  JobDBk2U,

  {$IFDEF NOM}
    HistWinU,
  {$ENDIF}

  JATreeU,

  SBSPanel, ImgList, ToolWin, AdvToolBar, AdvGlowButton, AdvToolBarStylers;


type
  TJobView = class(TForm)
    NLDPanel: TSBSPanel;
    NLOLine: TSBSOutlineB;
    PopupMenu1: TPopupMenu;
    MIFind: TMenuItem;
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
    Bevel6: TBevel;
    Panel4: TSBSPanel;
    Add1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Move1: TMenuItem;
    Move2: TMenuItem;
    CanlMove1: TMenuItem;
    OptSpeed: TMenuItem;
    ShowTotals1: TMenuItem;
    SBSPopupMenu1: TSBSPopupMenu;
    Job1: TMenuItem;
    Contract1: TMenuItem;
    View1: TMenuItem;
    Edit1: TMenuItem;
    Notes1: TMenuItem;
    Delete1: TMenuItem;
    Print1: TMenuItem;
    N6: TMenuItem;
    CopyJob1: TMenuItem;
    InvJob1: TMenuItem;
    PopupMenu3: TPopupMenu;
    Quotation2: TMenuItem;
    Active2: TMenuItem;
    Suspended2: TMenuItem;
    Completed2: TMenuItem;
    Closed2: TMenuItem;
    FiltJobs1: TMenuItem;
    N7: TMenuItem;
    CIS2: TMenuItem;
    CISL1: TMenuItem;
    CISG1: TMenuItem;
    CISG2: TMenuItem;
    ShowApps1: TMenuItem;
    Valuation1: TMenuItem;
    Val1: TMenuItem;
    Val2: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    CheckJobTotals1: TMenuItem;
    CheckJobTotals2: TMenuItem;
    CISG3: TMenuItem;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    AdvStyler: TAdvToolBarOfficeStyler;
    FullExBtn: TAdvGlowButton;
    FullColBtn: TAdvGlowButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    Panel1: TPanel;
    ClsI1Btn: TButton;
    Panel2: TPanel;
    OptBtn: TButton;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    lblStatusCode: Label8;
    CheckAllJobs1: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure NLOLineExpand(Sender: TObject; Index: Longint);
    procedure NLOLineCollapse(Sender: TObject; Index: Longint);
    procedure FullExBtnClick(Sender: TObject);
    procedure ClsI1BtnClick(Sender: TObject);
    procedure NLOLineDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure NLOLineMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MIEALClick(Sender: TObject);
    procedure MIFindClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure OptBtnClick(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Move1Click(Sender: TObject);
    procedure OptSpeedClick(Sender: TObject);
    procedure NLOLineNeedValue(Sender: TObject);
    procedure ShowTotals1Click(Sender: TObject);
    procedure Job1Click(Sender: TObject);
    procedure CopyJob1Click(Sender: TObject);
    procedure ReconBtnClick(Sender: TObject);
    procedure InvJob1Click(Sender: TObject);
    procedure Quotation1Click(Sender: TObject);
    procedure CISL1Click(Sender: TObject);
    procedure ShowApps1Click(Sender: TObject);
    procedure Val1Click(Sender: TObject);
    procedure CheckJobTotals1Click(Sender: TObject);
    procedure CheckJobTotals2Click(Sender: TObject);
    procedure CheckAllJobs1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
    IAmChild,
    FiltNType,
    ShowJATotals,
    ShowQty,
    MoveMode,
    WarnMaxRecs,
    StillMore,
    RefreshHist,
    RefreshRecon,
    InHCallBack,
    InHBeen,
    UseYTD,
    StoreCoord,
    LastCoord,
    fNeedCUpdate,
    FColorsChanged,
    InJTCISVoucher,
    SetDefault,
    GotCoord,
    showingTotals : Boolean;

    MaxIn1Go,
    Lab1Ofset,
    Lab2Ofset,
    Lab3Ofset,
    Lab4Ofset,
    IncJobFilt,
    ChrWidth     :   LongInt;

    Level_Type   :   Char;

    StartSize,
    OrigSize,
    InitSize     :  TPoint;

    MoveToItem,
    MoveItemParent,
    MoveItem     :   Integer;

    MoveInsMode  :   TSBSAttachMode;

    LastCursor   :   TCursor;


    NTxCr,
    NCr,NPr,NYr  :   Byte;

    ChrsXross    :   Double;

    ColXAry      :   Array[1..2] of LongInt;

    ChildNom     :   TJobView;
    InChild      :   Boolean;

    {$IFDEF Nom}
      HistForm     :   THistWin;
    {$ENDIF}

    JobRecForm   :  TJobRec;

    {$IFDEF DBk_On}
      JCDayBk       :  TJobDayBk;
      InJCDayBk     :  Boolean;
    {$ENDIF}


    InHist       :   Boolean;


    InRecon      :   Boolean;

    ExLocal      :   TdExLocal;

    JobActive    :  Boolean;

    JInvRecPtr   :  Pointer;

    // CJS 2014-04-16 - ABSEXCH-12628, ABSEXCH-13258 - error on Exchequer shutdown
    // Holds a reference to the Job Totals form when it is open (replaces the
    // previous JTotView variable)
    JobTotalsForm: TJAView;

    //PR: 18/05/2017 ABSEXCH-18683 v2017 R1 If we've started a move, then
    //closed the window without completing it we need to remove the process lock
    //This variable keeps track of whether we need to remove the lock on destroy
    FNeedToReleaseProcessLock : Boolean;


    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Function FormatLine(ONomRec  :  OutNomType;
                        LineText :  String)  :  String;

    Procedure SuperDDCtrl(Mode  :  Byte);

    procedure GetSelRec;

    Function Page2Mode(CP  :  Integer)  :  Byte;

    procedure Display_Account(Mode             :  Byte;
                              ChangeFocus      :  Boolean);

    procedure Display_JobRec(Mode             :  Byte;
                             ChangeFocus      :  Boolean);

    procedure JobLink;


    Procedure AddEditLine(Edit  :  Boolean);

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Function CreateCaption  :  Str255;

    Function CreateGPCaption  :  Str255;

    Procedure Add_MoreLines(Depth,
                            DepthLimit,
                            OIndex        :   LongInt;
                            StkCat        :   Str255);

    Procedure GetMaxRecpb;

    Procedure Add_OutLines(Depth,
                           DepthLimit,
                           OIndex        :   LongInt;
                           StkCat        :   Str20;
                           StkMore       :   Str255;
                           NeedMode      :   Boolean;
                     Const Fnum,
                           Keypath       :   Integer);

    Procedure Add_TotOutLines(Depth,
                              DepthLimit,
                              SFolio,
                              OIndex        :   LongInt;
                              StkCat        :   Str20;
                              ONType        :   Char;
                              LineText      :   String);


    Procedure Update_OutLines(Const Fnum,
                                    Keypath       :   Integer);

    procedure GetMoreLinks(Index  :  LongInt);

    Procedure Drill_OutLines(Depth,
                             DepthLimit,
                             PIndex      :  LongInt);

    Procedure Delete_OutLines(PIndex      :  LongInt;
                              DelSelf     :  Boolean);

    procedure NLChildUpdate;

    procedure Display_History(ONomCtrl     :  OutNomType;
                              ChangeFocus,
                              ShowGraph    :  Boolean);

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure SetFormProperties(SetList  :  Boolean);

    function FindNode(NCode  :  LongInt)  :  Integer;

    Function Advanced_FindNomCode(SC     :  Str20;
                                  SF     :  LongInt;
                                  Fnum,
                                  Keypath:  Integer)  :  Integer;

    Procedure FindStkCode;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function Is_NodeParent(MIdx,SIdx  :  Integer)  :  Boolean;

    Function Place_InOrder(MIdx,SIdx  :  Integer;
                       Var UseAdd     :  Boolean)  :  Integer;

    {$IFDEF POST}
      Function Confirm_Move(MIdx,SIdx  :  Integer)  :  Boolean;

      procedure RefreshMove(WhichNode  :  Integer);

      Procedure Alter_Total(Const PIdx1 :  Integer;
                            Const NC    :  Str20;
                            Const HideValues
                                        :  Boolean);

      Function FindXONC(Const NC1  :  Str20)  :  Integer;

      Procedure Update_TotalMove(Const NC1,NC2     :  Str20;
                                 Const CalcMode    :  Boolean);

      Procedure Update_Total4Thread(RecAddr  :  LongInt;
                                    CalcMode :  Boolean);

    {$ENDIF}

    procedure SetChildMove;

    Procedure Create_CopyJob(Const NJCode,
                                   JParent :  Str10;
                             Const Fnum,
                                   Keypath :  Integer);

    Procedure Copy_JobPayRates(Const FJCode,TJCode  :  Str10;
                                     Fnum,Keypath   :  Integer);

    Procedure Copy_JobHistory(Const FJCode,TJCode  :  Str10;
                              Const FJTYpe         :  Char;
                                    Fnum,Keypath   :  Integer);

    Procedure CopyBudgetDetails(Const FJCode,
                                      TJCode,
                                      FParent  :  Str10;
                                Const JFolio   :  LongInt;
                                      Fnum,
                                      Keypath  :  Integer;
                                Const Fnum2,
                                      Keypath2 :  Integer);


    Procedure Copy_Contract(NJCode  :  Str10;
                            CopyCon :  Boolean;
                            Level   :  LongInt);

    Procedure Copy_Job;

    procedure Display_InvWRec(Mode     :  Byte;
                              JCode    :  Str10);


    procedure CalcMenuExclude(Var  Source  :  TMenuItem;
                              Var  IncInt  :  LongInt);

    procedure Set_ValuationFromContract(Mode             :  Byte);
    procedure Set_ValuationFromExpenditure(Mode   :  Byte);

    //PR: 10/07/2012 ABSEXCH-12678 Check the parent nodes are expanded, otherwise opening the child will crash. Copied from MH's change for v6.9.001
    Procedure OpenParentNodes (Const ParentNode : TSBSOutlNode);

    // CJS 2014-04-16 - ABSEXCH-12628, ABSEXCH-13258 - error on Exchequer shutdown
    // -----------------------------------------------------------------------------
    // Routines for handling the Job Totals form
    // -----------------------------------------------------------------------------
    // Creates and displays the Job Totals form
    procedure OpenJobTotals;

    // Ensures that the Job Totals form matches the selected item in the Job Tree
    procedure SynchroniseJobTotals;

    // Closes the Job Totals form
    procedure CloseJobTotals;

    // Called when the user closes the Job Totals form
    procedure OnJobTotalsClose;

  public
    { Public declarations }

    Procedure PlaceNomCode(FindCode  :  LongInt);

  end;


{$IFDEF DBD}
procedure Run_Test512;
{$ENDIF}

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

  IntMU,
  CISInp1U,

  {$IFDEF POST}
    PostSp2U,
    GenWarnU,
    MovWarnU,
    BTSupU3,
    JCInv1U,

    JobPostU,

  {$ENDIF}

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  ExThrd2U,
  JobSup1U,
  InvListU,

  SysU1,

  JobSup2U,
  JobPAppU,
  JAPValIU,

  StkTRU,
  PWarnU,
  AuditNotes,

  WM_Const,
  // CJS 2014-04-15 - v7.0.10 - ABSEXCH-13784 - Job Move actual and budget figures
  JobBudPU,

  // CJS 2015-02-23 - ABSEXCH-16133 - SQL version of Check All Job Totals
  SQLUtils,
  SQLRep_Config,
  SQLCheckAllJobsFrmU,

  oProcessLock,
  //SSK 13/12/2017 ABSEXCH-19497: GDPR constants
  GDPRConst;

{$R *.DFM}

Const
  InitWidth  =  118;
  TDpth      =  70;






Procedure  TJobView.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TJobView.Find_FormCoord;


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

    PrimeKey:='J';

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

  {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

  FormResize(Self);
end;


procedure TJobView.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin


  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='J';

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


  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;


Function TJobView.FormatLine(ONomRec  :  OutNomType;
                             LineText :  String)  :  String;

Begin
  With ONomRec do
  Begin
    Result:=Spc(1*OutDepth)+Strip('R',[#32],LineText);

    Result:=Result+Spc(Round((Width-Canvas.TextWidth(Result))/Canvas.TextWidth(' '))-(TDpth*OutDepth));
  end;
end;


{ ======= Procedure to Build Total for each heading File ===== }

Procedure TJobView.Add_TotOutLines(Depth,
                                   DepthLimit,
                                   SFolio,
                                   OIndex        :   LongInt;
                                   StkCat        :   Str20;
                                   ONType        :   Char;
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

      OutStkCode:=StkCat;

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

    {Items[NewIdx].UseLeafX:=obLeaf2;}


  end; {With..}

end; {Proc..}


Procedure TJobView.Add_MoreLines(Depth,
                                 DepthLimit,
                                 OIndex        :   LongInt;
                                 StkCat        :   Str255);


Var
  LineText
          :  String;

  SpcWidth,
  NewIdx,
  NewObj,
  TmpRecAddr
          :  LongInt;

  TmpStat,
  TmpKPath
          :  Integer;

  ONomRec :  ^OutNomType;



Begin
  New(ONomRec);
  FillChar(ONomRec^,Sizeof(ONomRec^),0);
  With ExLocal.LJobRec^, ONomRec^ do
  Begin
    OutNomCode:=JobFolio;
    OutStkCode:=JobCode;
    OutStkCat:=JobCat;
    OutDepth:=Depth;
    BeenDepth:=DepthLimit;
    OutNomType:=JobType;
    MoreLink:=BOn;
  end;

  LineText:=Spc(1*Depth)+'* Double Click here for more records.';

  StillMore:=BOn;

  NewIdx:=NLOLine.AddChildObject(OIndex,LineText,ONomRec);
end;


Procedure TJobView.GetMaxRecpb;

Var
  TF  :  TStkTRI;

Begin
  TF:=TStkTRI.Create(Self);

  Try
    With TF do
    Begin
      ShowModal;

      If (ModalResult=mrOk) then
        MaxIn1Go:=Round(MaxRecs.Value);

    end;
  finally
    TF.Free;

  end;

end;



{ ======= Procedure to Build List based on Nominal File ===== }

Procedure TJobView.Add_OutLines(Depth,
                                DepthLimit,
                                OIndex        :   LongInt;
                                StkCat        :   Str20;
                                StkMore       :   Str255;
                                NeedMode      :   Boolean;
                          Const Fnum,
                                Keypath       :   Integer);


Var
  KeyS,
  KeyChk
          :  Str255;

  LineText,
  lJobDescText:  String;

  SpcWidth,
  NewIdx,
  InsIdx,
  NewObj,
  TmpRecAddr,
  ThisCount,
  ChkJobFilt
          :  LongInt;

  TmpStat,
  TmpKPath
          :  Integer;
  ChangeKey
          :  Boolean;

  TmpJob  :  JobRecType;

  ONomRec :  ^OutNomType;


Begin
  TmpKPath:=Keypath;
  ThisCount:=0; ChkJobFilt:=0;

  InsIdx:=0;
  ChangeKey:=NeedMode;

  With NLOLine,ExLocal do
  Begin

    SpcWidth:=Canvas.TextWidth(' ');

    If (NeedMode) then
      KeyChk:=StkMore
    else
      KeyChk:=FullJobCode(StkCat);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (ThisCount<MaxIn1Go) do
    With LJobRec^ do
    Begin
      {Application.ProcessMessages;  Cannot put this here, as LStock can get corrupted}

      ChkJobFilt:=Round(Power(2,JobStat));

      If ((ChkJobFilt AND IncJobFilt)<>0) or ((JobType=JobGrpCode) and (JobStat=2)) then
      Begin

        Inc(ThisCount);

        If (WarnMaxRecs) and (ThisCount=MaxIn1Go) then
        Begin
          TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);
          TmpJob:=LJobRec^;

          WarnMaxRecs:=BOff;

          GetMaxRecpb;

          TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
          LJobRec^:=TmpJob;

        end;

        If (ThisCount<MaxIn1Go) then
        Begin
          New(ONomRec);
          FillChar(ONomRec^,Sizeof(ONomRec^),0);
          With ONomRec^ do
          Begin
            OutNomCode:=JobFolio;
            OutStkCode:=JobCode;
            OutStkCat:=JobCat;
            OutDepth:=Depth;
            BeenDepth:=DepthLimit;
            OutNomType:=JobType;
          end;

          {LineText:=Spc(1*Depth)+LJVar(Desc,ChrWidth-(20*Depth))}

          {LineText:=FormatLine(ONomRec^,Strip('R',[#32],Desc[1]));}
          //HV ABSEXCH-19649: not displayed as *ANONYMISED* in Job Costing Drill Down Window when new Job Record is added
          if GDPROn and jrAnonymised then
            lJobDescText := Spc(1) + capAnonymised
          else
            lJobDescText := JobDesc;

          LineText:=Spc(1*Depth)+Strip('R',[#32],dbformatName(JobCode, lJobDescText));

          LineText:=LineText+Spc(Round((Width-Canvas.TextWidth(LineText))/SpcWidth)-(TDpth*Depth));



          {If (NeedMode) then
          Begin
            If (ChangeKey) then
              InsIdx:=OIndex
            else
              InsIdx:=NewIdx+1;

            NewIdx:=InsertObject(InsIdx,LineText,ONomRec);
          end
          else}
            NewIdx:=AddChildObject(OIndex,LineText,ONomRec);

          If (JobType=JobGrpCode) and (Depth<DepthLimit) then
          Begin
            //PR: 30/03/2011 ABSEXCH-10787 Removed code that runs when not optimised for speed (not Syss.BigJobTree) to
            //avoid errors in find.
            // MH 14/03/2012 ABSEXCH-12665: Reinstated original behaviour for post v6.9 Beta for PowerTecnique
            If (Not Syss.BigJobTree) then
            Begin

              TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);
              TmpJob:=LJobRec^;

              Add_OutLines(Depth+1,DepthLimit,NewIdx,JobCode,'',BOff,Fnum,Keypath);

              TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
              LJobRec^:=TmpJob;
            end
            else
              ONomRec^.NotOpen:=BOn;

            Add_TotOutLines(Depth+1,DepthLimit,JobFolio,NewIdx,JobCode,JobType,'End of '+JobDesc);
          end;

          If (NeedMode) and (ChangeKey) then
          Begin
            KeyChk:=FullJobCode(StkCat);
            ChangeKey:=BOff;
          end;

          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);
        end
        else
          Add_MoreLines(Depth,DepthLimit,OIndex,KeyS);
      end
      else
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);
    end; {While..}

  end; {With..}

end; {Proc..}


Procedure TJobView.Update_OutLines(Const Fnum,
                                         Keypath       :   Integer);


Var
  KeyS    :  Str255;

  LineText,
  lJobDescText
          :  String;

  N       :  LongInt;

  ONomRec :  ^OutNomType;


Begin
  With NLOLine do
  Begin
    BeginUpdate;

    For n:=1 to ItemCount do
    Begin
      ONomRec:=Items[n].Data;

      If (ONomRec<>Nil) then
      With ONomRec^ do
      Begin
        KeyS:=FullJobCode(OutStkCode);

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        LineText:=Strip('B',[#32],Items[n].Text);

        With JobRec^ do
        Begin
          {LineText:=Spc(1*OutDepth)+LJVar(LineText,ChrWidth-(20*OutDepth))}

          If (Not MoreLink) then
          Begin
            //SSK 13/12/2017 ABSEXCH-19497 : change description
            if GDPROn and (jrAnonymised) then
              lJobDescText := Spc(1) + capAnonymised
            else
              lJobDescText := JobDesc;

            LineText:=Spc(1*OutDepth)+dbFormatName(JobCode,lJobDescText);

            If (HedTotal) then
              LineText:='End of '+LineText
            else;

            LineText:=LineText+Spc(Round((Width-Canvas.TextWidth(LineText))/CanVas.TextWidth(' '))-(TDpth*OutDepth));
          end;
        end;

        Items[n].Text:=LineText;
      end;

    end; {Loop..}

    EndUpdate;

  end; {With..}
end; {Proc..}


Procedure TJobView.Drill_OutLines(Depth,
                                  DepthLimit,
                                  PIndex      :  LongInt);

Var
  NextChild       :  LongInt;

  ONomRec,
  ChildNRec       :  ^OutNomType;

  ForcedOpen,
  LoopCtrl        :  Boolean;


Begin
  LoopCtrl:=BOff;  ForcedOpen:=BOff;

  With NLOLine do
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
            //PR: 30/03/2011 ABSEXCH-10787 Removed code that runs when not optimised for speed (not Syss.BigJobTree) to
            //avoid errors in find.
          // MH 14/03/2012 ABSEXCH-12665: Reinstated original behaviour for post v6.9 Beta for PowerTecnique
          If (NextChild>0) and (Syss.BigJobTree) and (NotOpen) then
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
            If (Not LoopCtrl) and (Not HedTotal) then
            Begin
              Add_OutLines(Depth,DepthLimit,PIndex,OutStkCode,'',BOff,JobF,JobCatK);

              ONomRec:=Items[PIndex].Data;

              If (OutNomType=JobGrpCode) then
                Add_TotOutLines(Depth,DepthLimit,OutNomCode,PIndex,OutStkCode,OutNomType,'End of '+Items[PIndex].Text);
            end;
          end
          else
            // MH 14/03/2012 ABSEXCH-12665: Reinstated original behaviour for post v6.9 Beta for PowerTecnique
            If (Not Syss.BigJobTree) then
              Drill_OutLines(Depth+1,DepthLimit,NextChild);
        end;

        If (Not LoopCtrl) then
          LoopCtrl:=BOn;

      Until (NextChild<1);

    end; {If limit reached..}

  end; {With..}
end; {Proc..}




Procedure TJobView.Delete_OutLines(PIndex      :  LongInt;
                                   DelSelf     :  Boolean);

Var
  IdxParent,
  OrigChild,
  NextChild       :  LongInt;

  ONomRec         :  ^OutNomType;

  LoopCtrl        :  Boolean;


Begin
  LoopCtrl:=BOff;
  IdxParent:=-1;


  With NLOLine do
  Begin

    Repeat
      NextChild:=Items[PIndex].GetFirstChild;

      If (NextChild>0) then {* Try and find more for this level *}
      Begin
        ONomRec:=Items[NextChild].Data;

        If (Items[NextChild].HasItems) then {* Delete lower levels *}
          Delete_OutLines(NextChild,BOff);

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



procedure TJobView.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  {* Inform parent closing *}

  GenCanCloseAll(Self,Sender,CanClose,BOn,BOn);

  If (CanClose) then
    CanClose:=GenCheck_InPrint;

  If (CanCLose) then
  Begin
    If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
      Store_FormCoord(Not SetDefault);


    Send_UpdateList(55);
  end;



end;

procedure TJobView.FormClose(Sender: TObject; var Action: TCloseAction);
Var
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

  {$IFDEF NOM}
    If (InHist) and (HistForm<>nil) then
    Begin
      InHist:=BOff;
      HistForm.Free;
    end;
  {$ENDIF}

  If (InChild) and (ChildNom<>nil) then
  Begin
    InChild:=BOff;
    ChildNom.Free;
  end;

  If (JobActive) and (JobRecForm<>nil) then
  Begin
    JobRecform.Free;
    JobActive:=BOff;
  end;

  ExLocal.Destroy;

  Action:=caFree;

end;

Function TJobView.CreateCaption  :  Str255;

Var
  LocTit  :  Str50;

Begin
  LocTit:='';

  Caption:='Job Costing Drill Down.';
end;


Function TJobView.CreateGPCaption  :  Str255;

Begin
end;

procedure TJobView.FormCreate(Sender: TObject);
begin
  FNeedToReleaseProcessLock := False;

  ExLocal.Create;

  InitSize.Y:=421;
  InitSize.X:=271;//247;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=349;
  Width:=590;}

  MDI_SetFormCoord(TForm(Self));

  GotCoord:=BOff;
  NeedCUpdate:=BOff;
  FColorsChanged := False;

  StillMore:=BOff;
  UseYTD:=BOn;

  Lab4Ofset:=Height-Panel4.Top+2;

  Find_FormCoord;

  Lab1Ofset:=Width-(NLDPanel.Width);
  Lab2Ofset:=Height - NLOLine.Height;

  ChrWidth:=InitWidth;

  ChrsXRoss:=(ChrWidth/Width);

  If (GetMaxColors(Self.Canvas.Handle)<2) or (Syss.UseClassToolB) then {Assign 16 bit speed buttons}
  Begin
//    ToolBar.Images := ilTBar16Col;
//    ToolBar.HotImages := nil;

//    FreeandNil(ilTBar24Bit);
//    FreeandNil(ilTBar24BitHot);
  end
  else
  Begin
//    ToolBar.Images := ilTBar24Bit;
//    ToolBar.HotImages := ilTBar24BitHot;

//    FreeandNil(ilTBar16Col);
  end;
  // MH 14/03/2012 ABSEXCH-12665: Reinstated original behaviour for post v6.9 Beta for PowerTecnique
  OptSpeed.Checked:=Syss.BigJobTree;
  
  //TW 05/08/11: Code fix for Show/Hide totals on form load.
  //OptSpeed.Visible := false;
  ShowJATotals := true;
  InRecon:=BOff;

  JInvRecPtr:=nil;

  CreateSubMenu(SBSPopUpMenu1,Add1);
  CreateSubMenu(PopUpMenu3,FiltJobs1);

  CalcMenuExclude(FiltJobs1,IncJobFilt);

  Add1.Visible:=ChkAllowed_In(207);
  Edit1.Visible:=ChkAllowed_In(209);
  Delete1.Visible:=ChkAllowed_In(209);
  Notes1.Visible:=ChkAllowed_In(209);
  Print1.Visible:=ChkAllowed_In(-255);
  ShowTotals1.Visible:=ChkAllowed_In(208);
  N6.Visible:=ShowTotals1.Visible;

  CheckJobTotals1.Visible:=(SBSIn or Debug);
  CheckJobTotals2.Visible:=(SBSIn or Debug);

  MaxIn1Go:=500;
  WarnMaxRecs:=BOn;

  MoveMode:=BOff;
  MoveItem:=-1;
  MoveToItem:=-1;
  MoveInsMode:=TSBSAttachMode(0);
  MoveItemParent:=-1;

  Move1.Visible:=ChkAllowed_In(428);

  N4.Visible:=Move1.Visible;
  Move2.Visible:=BOff;
  FiltNType:=BOff;

  If (Not Move1.Visible) then
  Begin
    Move1.Shortcut:=0;
    Move2.Shortcut:=0;
  end;

  

  If (Owner is TJobView) then
  With TJobView(Owner) do
  Begin
    Self.Left:=Left+20;
    Self.Top:=Top+20;
    Self.Width:=Width;
    Self.Height:=Height;

    Self.NLOLine.Assign(NLOLine);

    StoreCoord:=BOff;

    Self.StoreCoordFlg.Enabled:=BOff;

    Self.N4.Visible:=BOff;
    Self.N5.Visible:=BOff;
    Self.Move1.Visible:=BOff;
    Self.Move2.Visible:=BOff;
    Self.CanlMove1.Visible:=BOff;
    IAmChild:=BOn;
  end
  else
  Begin
    IAmChild:=BOff;

     CIS2.Visible := CISOn;

     CISL1.Caption:='&'+CCCISName^+' Ledger';

     CISL1.Visible:=CISOn and ChkAllowed_In(246);
     CISG1.Visible:=CISOn and ChkAllowed_In(247);
     CISG3.Visible:=BOff;


     If (CurrentCountry=IECCode) then
     Begin
       CISG1.Caption:='&Generate RCTDC && RCT47';
       CISG2.Visible:=BOff;
       
       // PKR. 23/03/2016. ABSEXCH-17383. eRCT Plugin support.
       // Remove Contractor's Tax menu item for Ireland
       CIS2.Visible := false;
     end
     else
     Begin
       CISG3.Visible:=CISG1.Visible and CIS340;

       CISG1.Visible:=Not CISG3.Visible;

       CISG2.Visible:=CISG1.Visible;
     end;

     CIS2.Visible:=CanShowPMenu(CIS2);

     N7.Visible:=CIS2.Visible;

     InJTCISVoucher:=BOff;


    Add_OutLines(0,2,0,'','',BOff,JobF,JobCatK);


  end;

  Val1.Visible:=ChkAllowed_In(466);
  Val2.Visible:=ChkAllowed_In(467);

  ShowApps1.Visible:=(JAPOn and (Not IAmChild)) and (ChkAllowed_In(434) or ChkAllowed_In(443));
  Valuation1.Visible:=(JAPOn) and CanShowPMenu(Valuation1);

  {$IFDEF DBk_On}
    JCDayBk:=Nil;
    InJCDayBk:=BOff;
  {$ENDIF}


  CreateCaption;

  GotCoord:=BOn;

  JobActive:=BOff;
  JobRecForm:=nil;

  NLOLine.TreeColor   := NLOLine.Font.Color;

  FormReSize(Self);

end;


procedure TJobView.FormResize(Sender: TObject);
begin
  //If (GotCoord) then
  Begin
    GotCoord:=BOff;

    OrigSize.X:=ClientWidth;
    OrigSize.Y:=ClientHeight;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

//    NLOLine.Width:=ClientWidth-5;
//    NLOLine.Height:=ClientHeight-107; {* This ratio is critical, and must follow the design form ratio! *}

    NLDPanel.Width:=ClientWidth - (2 * NLDPanel.Left);//Width-Lab1Ofset;

    NLOLine.Width := NLDPanel.Width;
    NLOLine.Height := ClientHeight - 105;

    ChrWidth:=Round(Width*ChrsXRoss);

    NLOLine.HideText:=(Width<=100);

    Bevel6.Width := ClientWidth - (2 * Bevel6.Left);

    Update_OutLines(JobF,JobCodeK);

    {ClientWidth:=OrigSize.X;
    ClientHeight:=OrigSize.Y;}

    GotCoord:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end;


end;

procedure TJobView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  If (NLOLine.SelectedItem>0) and (Key=VK_Delete)  then
  Begin
    GetSelRec;

    // NOTE: this does not work, presumably because it is checking the Stock
    //       record when it should be checking the Job record. See ABSEXCH-15283
    //       -- CJS 2014-04-16
    If Ok2DelStk(0,Stock) then
      Display_Account(3,BOn);

  end;
end;

procedure TJobView.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TJobView.Display_History(ONomCtrl     :  OutNomType;
                                   ChangeFocus,
                                   ShowGraph    :  Boolean);

Var
  NomNHCtrl  :  TNHCtrlRec;

  FoundCode  :  Str20;

  fPr,fYr    :  Byte;

Begin
  {$IFDEF NOM}

    With NomNHCtrl,ONomCtrl do
    Begin
      FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

      NHMode:=9;
      NBMode:=12;

      NHCr:=NCr;
      NHTxCr:=NTxCr;
      NHPr:=NPr;
      NHYr:=NYr;
      NHNomCode:=OutNomCode;

      NHCCode:=FullNomKey(NHNomCode);


      If (JobRec^.JobCode<>OutStkCode) then
        GetJob(Self,OutStkCode,FoundCode,-1);

      NHKeyLen:=NHCodeLen+2;


      With JobRec^ do
      Begin
        Find_FirstHist(JobType,NomNHCtrl,fPr,fYr);
        MainK:=FullNHistKey(JobType,NHCCode,NCr,fYr,fPr);
        AltMainK:=FullNHistKey(JobType,NHCCode,NCr,0,0);
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


procedure TJobView.GetMoreLinks(Index  :  LongInt);

Var
  Depth,
  OIndex,
  LIndex  :  LongInt;
  ONomRec :  ^OutNomType;

begin

  OIndex:=0;

  With (NLOLine ) do
  Begin
    ONomRec:=Items[Index].Data;
    OIndex:=Items[Index].Parent.Index;

    If (OIndex<>0) then
      LIndex:=Items[OIndex].GetLastChild
    else
      LIndex:=-1;

    If (ONomRec<>nil) then
    With ONomRec^ do
    Begin

      Add_OutLines(OutDepth,BeenDepth,OIndex,OutStkCat,Strip('R',[#0],FullJobTree(OutStkCat,OutStkCode)),BOn,JobF,JobCatK);

      If (LIndex<>-1) then
      Begin
        Items[LIndex].MoveTo(Index,oaAdd);
      end;

      Delete(Index);

      Dispose(ONomRec);

      If (InChild) then
        PostMessage(ChildNom.Handle,WM_CustGetRec,250,Index);
    end;
  end; {With..}
end; {Proc..}



procedure TJobView.NLOLineExpand(Sender: TObject; Index: Longint);
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
      If (MoreLink) then {* Get next load *}
      Begin
        IsMore:=BOn;
        PostMessage(Self.Handle,WM_CustGetRec,250,Index);
      end
      else
        If (BeenDepth<Depth+2) or (NotOpen) then
        Begin
          BeenDepth:=Depth+2;
          {BeginUpdate;}

          If (NotOpen) then
            Depth:=Succ(Depth);

          Drill_OutLines(Depth,Depth+2,Index);
          {EndUpdate;}
        end;
    end;

  end; {With..}

  If (InChild) and (Not IsMore) then
    ChildNom.NLOLine.ExpandxNCode(NLOLine.Items[Index].Data,BOn);

  // CJS 2014-04-16 - ABSEXCH-12628, ABSEXCH-13258 - error on Exchequer shutdown
  If (Not IsMore) and (JobTotalsForm = nil) and (ShowTotals1.Enabled) then
    OpenJobTotals;

end;

procedure TJobView.NLOLineCollapse(Sender: TObject; Index: Longint);
begin
  If (InChild) then
    ChildNom.NLOLine.ExpandxNCode(NLOLine.Items[Index].Data,BOff);
end;






procedure TJobView.FullExBtnClick(Sender: TObject);
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



Procedure TJobView.SuperDDCtrl(Mode  :  Byte);


Begin

  With NLOLine,EXlocal do
  Begin
    If (Items[SelectedItem].HasItems) then
    Begin
      If (Mode=0) then
      Begin

        Items[SelectedItem].Expand;

        InHCallBack:=BOn;


        InHCallBack:=BOff;
        InHBeen:=BOn;
      end;
    end
    else
    Begin
      RefreshRecon:=BOn;

    end;

  end


end;


procedure TJobView.GetSelRec;


Var
  ONomRec   :  ^OutNomType;
  FoundOk   :  Boolean;
  FoundCode :  Str20;


begin
  With NLOLine do
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



procedure TJobView.Display_Account(Mode             :  Byte;
                                   ChangeFocus      :  Boolean);

Var
  ONomRec    :  ^OutNomType;
  NomNHCtrl  :  TNHCtrlRec;

  LSelectedItem
             :  LongInt;
  ThisNode   :  TSBSOutLNode;


Begin
  With NLOLine do
  If (SelectedItem>0) then
  Begin
    LSelectedItem:=SelectedItem;
    ThisNode:=Items[LSelectedItem];

    ONomRec:=ThisNode.Data;
  end;

  GetSelRec;

  With NomNHCtrl,ONomRec^ do
  If (NLOLine.SelectedItem>0) then
  Begin

  end; {With..}


  If (JobTotalsForm=nil) then
  Begin
    GetSelRec;

    Set_JAViewJC(JobRec^.JobCode);

    JobTotalsForm:=TJAView.Create(Self);

  end;

  Try

   InRecon:=BOn;

   With JobTotalsForm do
   Begin

     WindowState:=wsNormal;

     SetTabxJType(JobRec^.JobType);

     If (Mode In [1..10]) and (ChangeFocus) then
       Show;

     If (ONomRec^.OutStkCode<>JATreeJCode) then
       ApplyNewJCode(ONomRec^.OutStkCode);

   end; {With..}


  except

   InRecon:=BOff;
   JobTotalsForm.Free;
   JobTotalsForm:=nil;
  end;




end;


procedure TJobView.Display_JobRec(Mode             :  Byte;
                                  ChangeFocus      :  Boolean);

Var
  ONomRec    :  ^OutNomType;
  NomNHCtrl  :  TNHCtrlRec;

  LSelectedItem
             :  LongInt;
  ThisNode   :  TSBSOutLNode;


Begin
  With NLOLine do
  If (SelectedItem>0) then
  Begin
    LSelectedItem:=SelectedItem;
    ThisNode:=Items[LSelectedItem];

    ONomRec:=ThisNode.Data;
  end;

  GetSelRec;



  If (JobRecForm=nil) then
  Begin

    JobRecForm:=TJobRec.Create(Self);
    GetSelRec;

  end
  else
    JobRecForm.ListScanningOn := True;

  Try

   JobActive:=BOn;

   With JobRecForm do
   Begin
     // SSK 13/12/2017 2018R1 ABSEXCH-19497: Implements anonymisation behaviour for Job
     if (Not ExLocal.InAddEdit) then
       AnonymisationON := GDPROn and (Mode <> 1) and (JobRec^.jrAnonymised);

     WindowState:=wsNormal;

     SetTabs;

     If (Mode In [1..10]) and (ChangeFocus) then
       Show;

     If (Not ExLocal.InAddEdit) then
       ShowLink;


     If (Mode In [1..3]) and (Not ExLocal.InAddEdit) then
     Begin
       ChangePage(0);

       If (Mode=3) then
         DeleteAccount
       else
       Begin
         If (Mode=1) then {* Set Parent *}
         Begin
           {$B-} {* Self needed to distinguish between NLOline in Stock record! *}
             If (Self.NLOLine.SelectedItem>0) and (ThisNode.Parent.Index>0) then
               Level_Code:=OutNomType(ThisNode.Parent.Data^).OutStkCode
             else
               Level_Code:=FullStockCode('');

             Add_Type:=Level_Type;
           {$B+}
         end;
         EditAccount((Mode=2));

         
       end;
     end;

     Case Mode of
       5  :  ChangePage(1);

     end;



   end; {With..}


  except
  on E:Exception do
  begin
//    ShowMessage(E.Message);

   JobActive:=BOff;

   JobRecForm.Free;
  end;
  end;


end;


procedure TJobView.JobLink;
Var
  DispRec  :  Boolean;

begin
  DispRec:=BOff;

  If (JobRecForm<>nil) and (JobActive) then
  With JobRecForm do
  Begin
    GetSelRec;

    If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) and (JobRec^.JobCode<>ExLocal.LJobRec^.JobCode) then
    Begin
      Display_JobRec(0,BOff);
    end;
  end;

end;


procedure TJobView.ReconBtnClick(Sender: TObject);

Var
  ONomRec  :  ^OutNomType;
  DispRec  :  Boolean;
  RMode    :  Byte;

begin
  DispRec:=BOff;

  RMode:=6;


  If ChkAllowed_In(208) then
  With NLOLine do
  Begin

    ONomRec:=Items[SelectedItem].Data;

    If (InRecon) and (Assigned(JobTotalsForm)) then
    Begin
      DispRec:=(((JobTotalsForm.JATreeJCode<>ONOmRec^.OutStkCode) and (Not ONomRec^.HedTotal)) or (Sender<>nil)
                 {or (RefreshRecon)});
    end;

    //TW 18/10/2011 Boolean added as part of ABSEXCH-11995
    {$IFDEF Nom}
      If ((Not InRecon) or (DispRec)) and (Not InHCallBack) and (Not ONomRec.HedTotal) and (Not StopDD) and (ShowJATotals) then
      Begin
        Display_Account(RMode,((Sender<>nil) and (Sender<>HistForm)));
        showingTotals := true;
      end;
    {$ELSE}
      If ((Not InRecon) or (DispRec)) and (Not InHCallBack) and (Not ONomRec.HedTotal) and (ShowJATotals) then
      begin
        Display_Account(RMode,(Sender<>nil));
        showingTotals := true;
      end;
    {$ENDIF}

    ReFreshRecon:=BOff;
  end;
end;




Procedure TJobView.AddEditLine(Edit  :  Boolean);

Var
  Depth,
  OIndex,
  NewIdx   :  Integer;
  PNode    :  TSBSOutLNode;
  NewFolio :  LongInt;
  ONomRec  :  ^OutNomType;

Begin

  With NLOLine,JobRec^ do
  If (Not Edit) then
  Begin
    NewFolio:=JobFolio;

    Begin
      {$B-}
      If (SelectedItem=0) or (Items[SelectedItem].Parent.Index<=0) then
      Begin
      {$B+}

        If (SelectedItem>0) then
        Begin
          PNode:=Items[SelectedItem];

          Repeat

            Delete_OutLines(1,BOn);

          Until (ItemCount<=0);
        end;

        Add_OutLines(0,2,0,'','',BOff,JobF,JobCatK)

      end
      else
      Begin
        PNode:=Items[SelectedItem].Parent;
        OIndex:=PNode.Index;

        ONomRec:=PNode.Data;

        ONomRec^.BeenDepth:=0;
        PNode.Collapse;

        Delete_OutLines(OIndex,BOff);

        Depth:=Pred(PNode.Level);

        Drill_OutLines(Depth,Depth+2,OIndex);
        PNode.Expand;
      end;
    end;


    OIndex:=FindNode(Integer(NewFolio));

    If (OIndex<>-1) then
      SelectedItem:=OIndex;


  end
  else
  Begin
    ONomRec:=Items[SelectedItem].Data;

    Items[SelectedItem].Text:=FormatLine(ONomRec^,dbFormatName(JobCode,JobDesc));

    ONomRec^.OutStkCode:=JobCode;

    ONomRec^.OutNomType:=JobType;

    PNode:=Items[SelectedItem];
    OIndex:=SelectedItem;

    Delete_OutLines(OIndex,BOff);

    Depth:=Pred(PNode.Level);

    Drill_OutLines(Depth,Depth+2,OIndex);
  end;

end;



Procedure TJobView.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of
      {$IFDEF DBk_On}

        17  :  Begin
                 JCDayBk:=Nil;
                 InJCDayBk:=BOff;
               end;
      {$ENDIF}

      41 :  Begin
              InHist:=BOff;

            end;

      43 :  ; {Rserved MLocList}

      46 :  InChild:=BOff;

      52,53
         :  Begin
              ExLocal.AssignFromGlobal(NHistF);

              SuperDDCtrl(WParam-52)
            end;

      WP_CLOSE_JOB_TOTALS_FORM :  Begin
              OnJobTotalsClose;
            end;

      62
         :  Begin
              ExLocal.AssignFromGlobal(JobF);
              ExLocal.AssignFromGlobal(NHistF);
              PlaceNomCode(ExLocal.LJobRec^.JobFolio);
              SuperDDCtrl(0);
            end;

      66 :  InJTCISVoucher:=BOff;

      71 :  SendMessage(Self.Handle,WM_Close,0,0);
      {$IFDEF POST}
      // WP_START_TREE_MOVE (70) = starting Move thread process
      // WP_END_TREE_MOVE (72) = completed Move thread process
      WP_START_TREE_MOVE,
      WP_END_TREE_MOVE:
             Update_Total4Thread(LParam, (WParam = WP_START_TREE_MOVE));
      {$ENDIF}

      159:  JInvRecPtr:=nil;


    end; {Case..}

  end;
  Inherited;
end;

Procedure TJobView.WMCustGetRec(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of
       25  :  NeedCUpdate:=BOn;

      {$IFDEF POST}
        74
         :  RefreshMove(NLOLine.SelectedItem);
      {$ENDIF}

      169  : With NLOLine do
               Items[SelectedItem].Expand;

      132  : If (JobActive) then
             Begin
               JobRecForm.ExLocal.AssignToGlobal(JobF);
               AddEditLine((LParam=1));
             end;

      170  :  Print1Click(nil);


      232,332
         :  Begin
              {InRecon:=BOff;}

              JobActive:=BOff;
              JobRecForm:=nil;

              If (WParam=332) then
              With NLOLine do
                If (SelectedItem>=0) then
                  Delete_OutLines(SelectedItem,BOn);
            end;

      250 :  GetMoreLinks(LParam);



    end; {Case..}

  end;
  Inherited;
end;


Procedure TJobView.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TJobView.Send_UpdateList(Mode   :  Integer);

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




procedure TJobView.ClsI1BtnClick(Sender: TObject);
begin
  Close;
end;


procedure TJobView.NLChildUpdate;

Var
  n   :  Integer;

Begin

  If (InChild) then
  Begin
    n:=ChildNom.NLOLine.FindxNCode(NLOLine.Items[NLOLine.SelectedItem].Data);

    If (n<>-1) then
      ChildNom.NLOLine.SelectedItem:=n;
  end;


end;


procedure TJobView.NLOLineDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin

  if (JobTotalsForm <> nil) then
    SynchroniseJobTotals;

//  If (InRecon) then
//    ReconBtnClick(nil);

  If (JobRecForm<>nil) and (JobActive) then
    JobLink;


  NLChildUpDate;

end;


procedure TJobView.NLOLineNeedValue(Sender: TObject);

Var
  ONomRec      :  ^OutNomType;
  DrawIdxCode  :  LongInt;



begin
  With Sender as TSBSOutLineB do
  Begin
    DrawIdxCode:=CalcIdx;

    If (DrawIdxCode>0) then
    Begin
      ONomRec:=Items[DrawIdxCode].Data;

      If (ONomRec<>nil) then
      With ONomRec^ do
      Begin
        If (DrawIdxCode=SelectedItem) then
        Begin
          If (JobRec^.JobCode<>OutStkCode) then
            Global_GetMainRec(JobF,OutStkCode);

          lblStatusCode.Caption:= 'Status : ' + JobStatusL^[JobRec^.JobStat]

        end;

      end;
    end; {If found equiv index..}
  end;
end;



procedure TJobView.PopupMenu1Popup(Sender: TObject);

Var
  n        : Integer;
  ONomRec  :  ^OutNomType;


begin
  if Assigned(JobTotalsForm) then
    ShowTotals1.Caption := 'Hide &Totals'
  else
    ShowTotals1.Caption := 'Show &Totals';

  StoreCoordFlg.Checked:=StoreCoord;

  N3.Tag:=Ord(ActiveControl Is TSBSOutLineB);

  GetSelRec;


  Delete1.Enabled:=Ok2DelJob(0,JobRec^) or (JobRec^.JobStat=JobClosed);

  // CJS 2015-02-23 - ABSEXCH-16133 - SQL version of Check All Job Totals
  CheckAllJobs1.Visible := (SQLUtils.UsingSQLAlternateFuncs And SQLReportsConfiguration.UseSQLCheckAllJobs) and
                           (SBSIn or Debug);

  With NLOLine do
    If (SelectedItem>0) then
    Begin
      ONomRec:=Items[SelectedItem].Data;

      With Delete1 do
        Enabled:=(Enabled and Not ONomRec^.HedTotal);

      With InvJob1 do
        Enabled:=(ONomRec^.OutNomType=JobJobCode);
    end;

  Add1.Enabled:=Not JobActive;
end;



procedure TJobView.SetFormProperties(SetList  :  Boolean);

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

        TmpPanel[2].Font:=NLDPanel.Font;
        TmpPanel[2].Color:=NLDPanel.Color;


        TmpPanel[3].Color:=BarColor;
        TmpPanel[3].Font.Assign(TmpPanel[1].Font);
        TmpPanel[3].Font.Color:=BarTextColor;
      end;

      
    end
    else
    Begin
      TmpPanel[2].Font:=Panel4.Font;
      TmpPanel[2].Color:=Panel4.Color;
    end;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        // MH 07/11/2012 v7.0 ABSEXCH-13676: List Headings options being shown when not applicable
        SupportListHeadingBackground := False;

        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],Ord(SetList),Self.Caption+' '+PropTit[SetList]+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);
        FColorsChanged := NeedCUpdate;

        If (BeenChange) and (not ResetDefaults) then
        Begin

          If (SetList) then
          With NLOLine do
          Begin
            Font.Assign(TmpPanel[1].Font);
            Color:=TmpPanel[1].Color;

            NLDPanel.Font.Assign(TmpPanel[2].Font);
            NLDPanel.Color:=TmpPanel[2].Color;


            BarColor:=TmpPanel[3].Color;
            BarTextColor:=TmpPanel[3].Font.Color;

            NLOLine.TreeColor   := NLOLine.Font.Color;
          end
          else
          Begin
            {SetFieldProperties;}
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


procedure TJobView.PropFlgClick(Sender: TObject);
begin
  SetFormProperties(N3.Tag=1);
  N3.Tag:=0;
end;


procedure TJobView.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;



procedure TJobView.NLOLineMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NLChildUpDate;
end;




procedure TJobView.MIEALClick(Sender: TObject);
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



{ ======= Function to find the note a nominal code resides at ======= }

function TJobView.FindNode(NCode  :  LongInt)  :  Integer;

Var
  n          :  Integer;
  FoundOk    :  Boolean;


Begin
  FoundOk:=BOff;

  With NLOLine do
    For n:=1 to ItemCount do
    Begin
      FoundOk:=(OutNomType(Items[n].Data^).OutNomCode=NCode);

      If (FoundOk) then
        Break;
    end;

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;

end;

//-------------------------------------------------------------------------

//PR: 10/07/2012 ABSEXCH-12678 Check the parent nodes are expanded, otherwise opening the child will crash. Copied from MH's change for v6.9.001
Procedure TJobView.OpenParentNodes (Const ParentNode : TSBSOutlNode);
Begin // OpenParentNodes
  If Assigned(ParentNode) Then
  Begin
    // Check the parent node of this parent is expanded, and so on until we reach the parentless root
    OpenParentNodes (ParentNode.Parent);

    If (Not ParentNode.Expanded) Then
    Begin
      ParentNode.Expand;
    End; // If (Not ParentNode.Expanded)
  End; // If Assigned(ParentNode)
End; // OpenParentNodes

//-------------------------------------------------------------------------

Function TJobView.Advanced_FindNomCode(SC     :  Str20;
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
    Result:=FindNode(JobRec^.JobFolio);

    If (Result=-1) then {* Atempt to load that up *}
    Begin
      If (Not EmptyKey(JobRec^.JobCat,JobKeyLen)) then
      Begin
        Result:=Advanced_FindNomCode(JobRec^.JobCat,JobRec^.JobFolio,Fnum,Keypath);
      end;
    end;

    If (Result<>-1) then
    With NLOLine do
    Begin
      ONomRec:=Items[Result].Data;

      If (ONomRec^.NotOpen) then
      Begin
        //PR: 10/07/2012 ABSEXCH-12678 Check the parent nodes are expanded, otherwise opening the child will crash. Copied from MH's change for v6.9.001
        OpenParentNodes(Items[Result].Parent);

        Items[Result].Expand;


      end;

      Result:=FindNode(SF);
    end;
  end;


end;



Procedure TJobView.PlaceNomCode(FindCode  :  LongInt);

Const
  Fnum     =  JobF;
  Keypath  =  JobCodeK;

Var
  FoundOk    :  Boolean;
  FoundCode  :  Str20;
  KeyS       :  Str255;
  n          :  Integer;
  FoundLong  :  LongInt;

Begin

  FoundOk:=(JobRec^.JobFolio=FindCode);

  If (Not FoundOk) then
  Begin
    KeyS:=FullJobCode(JobRec^.JobCode);
    FoundOk:=GetJob(Owner,KeyS,FoundCode,-1);
  end;

  If (FoundOk) then
  Begin
    KeyS:=FullJobCode(JobRec^.JobCat);

    If (Not EmptyKey(JobRec^.JobCat,JobKeyLen)) then
      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    //PR: 30/03/2011 ABSEXCH-10787 Removed check for not speed optimisation (not Syss.BigJobTree) to
   //avoid errors in find.
    // MH 14/03/2012 ABSEXCH-10123: Reinstated original behaviour for post v6.9 Beta for PowerTecnique
    If (Not Syss.BigJobTree) then
    Begin
      While (StatusOk) and (Not EmptyKey(JobRec^.JobCat,JobKeyLen)) do {* Get to top of this branch *}
      Begin
        KeyS:=FullJobCode(JobRec^.JobCat);

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      end;
    end;

    n:=FindNode(JobRec^.JobFolio);

    If (n=-1) and (Syss.BigJobTree) and (Not EmptyKey(JobRec^.JobCat,JobKeyLen)) then
      n:=Advanced_FindNomCode(JobRec^.JobCat,JobRec^.JobFolio,Fnum,Keypath);

    If (n<>-1) then
    With NLOLine do
    Begin
      StopDD:=BOn;

      //PR: 10/07/2012 ABSEXCH-12678 Check the parent nodes are expanded, otherwise opening the child will crash. Copied from MH's change for v6.9.001
      OpenParentNodes (Items[n].Parent);

      Items[n].FullExpand;

      n:=FindNode(Integer(FindCode));

      If (n<>-1) then
        SelectedItem:=n
      else
        If (StillMore) then
          ShowMessage('That Job code code not be found.'+#13+'There are more Job codes available which are not shown.'+#13+
                       'Please click on the More record lines to load more data.');

      StopDD:=BOff;

    end;

  end;

end;


Procedure TJobView.FindStkCode;


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

    InpOk:=InputQuery('Find Job Record','Please enter the Job code you wish to find',SCode);

    If (InpOk) then
      FoundOk:=GetJob(Self,SCode,FoundCode,99);

  Until (FoundOk) or (Not InpOk);

  If (FoundOk) then
  Begin
    PlaceNomCode(JobRec^.JobFolio);
  end;


end;


procedure TJobView.MIFindClick(Sender: TObject);
begin
  FindStkCode;
end;

Function TJobView.Page2Mode(CP  :  Integer)  :  Byte;

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





procedure TJobView.Edit1Click(Sender: TObject);

Var
  RB  :  Byte;

begin
  If (Sender is TMenuItem) then
  Begin
    RB:=TMenuItem(Sender).Tag;

    If (NLOLine.SelectedItem>0) or (RB=1) then
      Display_JobRec(RB,BOn);

  end;
end;


procedure TJobView.Job1Click(Sender: TObject);

Var
  RB  :  Byte;

begin
  If (Sender is TMenuItem) then
  Begin
    RB:=TMenuItem(Sender).Tag;

    Case RB of
      1  :  Level_Type:=JobJobCode;
      2  :  Level_Type:=JobGrpCode;
    end;

    Edit1Click(Add1);

  end;
end;


procedure TJobView.OptBtnClick(Sender: TObject);

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




procedure TJobView.Print1Click(Sender: TObject);
begin
  {$IFDEF FRM}
    With NLOLine do
      If (SelectedItem>0) then
      Begin
        GetSelRec;
        ExLocal.AssignFromGlobal(JobF);
        Control_DefProcess(25,
                           JobF,JobCodeK,
                           FullJobCode(ExLocal.LJobRec^.JobCode),
                           ExLocal,
                           BOn);
      end;
  {$ENDIF}
end;


Function TJobView.Is_NodeParent(MIdx,SIdx  :  Integer)  :  Boolean;

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

Function TJobView.Place_InOrder(MIdx,SIdx  :  Integer;
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

{$IFDEF POST}
  Function TJobView.Confirm_Move(MIdx,SIdx  :  Integer)  :  Boolean;

  Var
    MoveRec  :  MoveRepPtr;
    mbRet    :  Word;
    PIdx     :  Integer;

    ONomRec  :  ^OutNomType;

    WMsg     :  AnsiString;

  Begin
    New(MoveRec);


    Result:=BOff;

    try
      FillChar(MoveRec^,Sizeof(MoveRec^),0);

      With MoveRec^, NLOLine do
      Begin
        ONomRec:=Items[MIdx].Data;

        MoveMode:=30;

        With ONomRec^ do
        Begin
          MoveSCode:=OutStkCode;
          WasSGrp:=OutStkCat;

          If (Global_GetMainRec(JobF,MoveSCode)) then
          With JobRec^ do
          Begin
            WasSGrp:=JobCat;
            MoveJob:=JobRec^;
          end;
        end;

        PIdx:=Items[SIdx].Parent.Index;

        If (PIdx>0) then
        Begin
          ONomRec:=Items[PIdx].Data;

          With ONomRec^ do
          Begin
            NewSGrp:=FullJobCode(OutStkCode);

            If (Global_GetMainRec(JobF,OutStkCode)) then
            Begin
              GrpJob:=JobRec^;
            end;
          end;
        end
        else
        With GrpJob do
        Begin
          JobDesc:='Job Root';
          NewSGrp:=FullJobCode('');

        end;
        Set_BackThreadMVisible(BOn);

        WMsg:=ConCat('You are about to move ',dbFormatName(MoveJob.JobCode,MoveJob.JobDesc),' into ',
              dbFormatName(GrpJob.JobCode,GrpJob.JobDesc),#13,#13);
        WMsg:=ConCat(WMsg,'The group totals affected will be blanked out until the move is complete.',#13,#13);
        WMsg:=ConCat(WMsg,'This operation should be performed with all other users logged out.',#13,#13,'A backup ',
              'MUST be taken since the integrity of the Job Tree will be damaged should the move fail.',#13,#13,
              'Do you wish to continue?');

        mbRet:=MovCustomDlg(Application.MainForm,'WARNING','Job Move',WMsg,mtWarning,[mbYes,mbNo]);

        Set_BackThreadMVisible(BOff);

        Result:=(mbRet=mrOk);

        If (Result) then
        begin
          Result := AddMove2Thread(self, MoveRec);
          // CJS 2014-04-15 - v7.0.10 - ABSEXCH-13784 - Job Move actual and budget figures
          // Add the 'Update Job Budget' routines to the thread queue, one for
          // the original Job parent, and the other for the new parent.

          //We need to ensure that the process lock isn't removed until the second update budget
          //thread is completed, so set the ProcessLockTypes accordingly in the last parameter of
          //the call
          AddJobPostBud2Thread(self.Owner, 38, MoveJob.JobCat, nil, self.Handle, plNone);
          AddJobPostBud2Thread(self.Owner, 38, GrpJob.JobCode, nil, self.Handle, plMoveJob);
          FNeedToReleaseProcessLock := False;
        end;


      end; {With..}
    finally
      Dispose(MoveRec);

     end;
  end;


  procedure TJobView.RefreshMove(WhichNode  :  Integer);

  Var
    N,Depth,
    PIdx1        :  Integer;

    PNode        :  TSBSOutLNode;


  Begin
    If (WhichNode>0) then
    With NLOLine do
    Begin
      If (Items[WhichNode].Parent.Index>0) then
        PIdx1:=Items[WhichNode].TopItem
      else
        PIdx1:=WhichNode;

      N:=PIdx1;
      If (N>0) then
      Begin
        PNode:=Items[n];

        PNode.Collapse;

        Delete_OutLines(n,BOff);

        Depth:=1;

        Drill_OutLines(Depth,Depth+2,n);

        PNode.Expand;

      end;

    end;

    If (Assigned(ChildNom)) and (InChild) then
      ChildNom.RefreshMove(WhichNode);
  end;


  Procedure TJobView.Alter_Total(Const PIdx1 :  Integer;
                                 Const NC    :  Str20;
                                 Const HideValues
                                             :  Boolean);

Var
  ONomRec    :  ^OutNomType;
  NIdx,PIdx  :  Integer;
  FoundOk,
  AbortOn    :  Boolean;

Begin
  FoundOk:=BOff;  AbortOn:=BOff;

  With NLOLine do
  If (PIdx1<=ItemCount) then
  Begin
    BeginUpdate;

    PIdx:=PIdx1;

    Repeat

      ONomRec:=Items[PIdx].Data;

      If (ONomRec^.OutStkCode=NC) or (PIdx<>PIdx1) then {* Still same nom code or down a level! *}
      Begin
        ONomRec^.HideValue:=HideValues;

        FoundOk:=BOff;

        NIdx:=Items[PIdx].GetLastChild;

        Repeat
          If (NIdx>0) then
          Begin
            ONomRec:=Items[NIdx].Data;

            FoundOk:=ONomRec^.HedTotal;

            If (FoundOk) then
              ONomRec^.HideValue:=HideValues
            else
              NIdx:=Items[PIdx].GetPrevChild(NIdx);

          end;

        Until (NIdx<1) or (FoundOk);

        PIdx:=Items[PIdx].Parent.Index;
      end
      else
        AbortOn:=BOn;

    Until (PIdx<1) or (AbortOn);

    EndUpDate;
  end; {With..}

end;

Function TJobView.FindXONC(Const NC1  :  Str20)  :  Integer;

Var
  n          :  Integer;
  ONomRec    :  ^OutNomType;


Begin
  Result:=-1;

  With NLOLine do
  Begin
    For n:=1 to ItemCount do
    Begin
      ONomRec:=Items[n].Data;

      If (ONomRec^.OutStkCode=NC1) then
      Begin
        Result:=n;
        Break;
      end;
    end;
  end;

end;

Procedure TJobView.Update_TotalMove(Const NC1,NC2     :  Str20;
                                    Const CalcMode    :  Boolean);

Var
  PIdx1, PIdx2  :  Integer;
  ONomRec       :  ^OutNomType;


Begin

  If (NC1<>'') then
  Begin
    PIdx1:=FindxONC(NC1);

  end;

  If (PIdx1>0) then
    Alter_Total(PIdx1,NC1,CalcMode);

  If (NC2<>'') then
  Begin
    PIdx2:=FindxONC(NC2);

  end;

  If (PIdx2>0) then
    Alter_Total(PIdx2,NC2,CalcMode);


  If (Assigned(ChildNom)) and (InChild) then
    ChildNom.Update_TotalMove(NC1,NC2,CalcMode);
end;

// Called by the 'Move Job' thread before it starts processing and after it
// has completed
Procedure TJobView.Update_Total4Thread(RecAddr  :  LongInt;
                                       CalcMode :  Boolean);
var
  MoveRec: MoveRepPtr;
begin
  MoveRec := Pointer(RecAddr);

  if (Assigned(MoveRec)) then
  with MoveRec^ do
  begin
    // Update the displayed totals (???)
    Update_TotalMove(WasSGrp,NewSGrp,CalcMode);

    // CalcMode:
    //    True: starting Move thread process
    //   False: completed Move thread process
    if (not CalcMode) then
    begin
      // Clean up
      Dispose(MoveRec);
      // Re-enable 'Show Totals' menu option
      ShowTotals1.Enabled := BOn;
      // Re-open the Job Totals window if it was previously open
      OpenJobTotals;
      SynchroniseJobTotals;
    end
    else
    begin
      // Close the Job Totals window if it is open, so that it does not
      // interfere with the thread process which will update the totals.
      if (Assigned(JobTotalsForm)) then
        CloseJobTotals;
      // Disable the 'Show Totals' menu option
      ShowTotals1.Enabled := BOff;
    end;
  end;
end;


{$ENDIF}





procedure TJobView.SetChildMove;

Begin
  If (Assigned(ChildNom)) and (InChild) then
  Begin
    ChildNom.MoveItem:=MoveItem;
    ChildNom.MoveToItem:=MoveToItem;
    ChildNom.MoveItemParent:=MoveItemParent;
    ChildNom.MoveInsMode:=MoveInsMode;
    ChildNom.MoveMode:=BOn;

  end;
end;


procedure TJobView.Move1Click(Sender: TObject);
Var
  MMode    :  TSBSAttachMode;
  ONomRec  :  ^OutNomType;
  LastText :  Str255;

  SIdx,
  Depth,
  NIdx     :  Integer;

  Ok2Cont,
  UseAdd   :  Boolean;

  BMoveMode:  Byte;

begin
  UseAdd:=BOff;  Ok2Cont:=BOff;


  If (Sender=Move1) or (Sender=Move2) then
    BMoveMode:=Ord(MoveMode)
  else
    If (Sender=CanlMove1) then
      BMoveMode:=3
    else
      BMoveMode:=4;

  With NLOLine do
  Begin
    Case BMoveMode of
      0    :  Begin
                //PR: 18/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
                if not GetProcessLock(plMoveJob) then
                  EXIT;

                 MoveItem:=SelectedItem;
                 MoveItemParent:=Items[MoveItem].Parent.Index;
                 MoveMode:=Not MoveMode;
                 LastCursor:=Cursor;
                 Cursor:=crDrag;
                 FNeedToReleaseProcessLock := True;

               end;

      1     :  Begin
                 If (Items[SelectedItem].Parent.Index=Items[MoveItem].Parent.Index) or (Is_NodeParent(MoveItem,SelectedItem)) then
                 Begin
                   Set_BackThreadMVisible(BOn);

                   ShowMessage('It is not possible to move within the same group!');

                   Set_BackThreadMVisible(BOff);

                 end
                 else
                   If (SelectedItem=MoveItem) or (SelectedItem<=0) then
                   Begin
                     Set_BackThreadMVisible(BOn);

                     ShowMessage('It is not possible to move to the group specified!');

                     Set_BackThreadMVisible(BOff);

                   end
                   else
                   Begin

                     Try
                       ONomRec:=Items[MoveItem].Data;
                       LastText:=Items[MoveItem].Text;

                       Items[MoveItem].Collapse;

                       SIdx:=Place_InOrder(MoveItem,SelectedItem,UseAdd);

                       If (UseAdd) then {Add/Insert}
                         MMode:=TSBSAttachMode(0)
                       else
                         MMode:=TSBSAttachMode(2);

                       NIdx:=Items[SIdx].Parent.Index;

                       {$IFDEF POST}
                         Ok2Cont:=Confirm_Move(MoveItem,SIdx);
                       {$ELSE}
                         Ok2Cont:=BOff;
                       {$ENDIF}

                       If (Ok2Cont) then
                       Begin
                         MoveToItem:=SIdx;
                         MoveInsMode:=MMode;

                         Items[MoveItem].Collapse;

                         {* Changes here need to be relected in the 4: section for the child control *}
                         BeginUpdate;

                         Items[MoveItem].MoveTo(MoveToItem,MoveInsMode);
                       end;

                     Finally
                       Begin
                         If (Ok2Cont) then
                         Begin
                           EndUpDate;

                           SetChildMove;

                           If (InChild) and (Assigned(ChildNom)) then
                           Begin
                             ChildNom.Move1Click(Nil);
                           end;

                           MoveMode:=Not MoveMode;
                           Cursor:=LastCursor;

                         end;
                       end;
                     end;
                   end;
               end;
      3    :  Begin
                 MoveItem:=-1;
                 MoveMode:=BOff;
                 Cursor:=LastCursor;
                 Move1.Enabled:=BOn;
                 //PR: 18/05/2017 ABSEXCH-18683 v2017 R1 Move cancelled so release process lock
                 if Assigned(Application.Mainform) then
                   SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plMoveJob), 0);
                 FNeedToReleaseProcessLock := False;
              end;

      4    :  If (MoveMode) then {For Child }
              Begin
                Try

                  Items[MoveItem].Collapse;

                  BeginUpdate;

                  Items[MoveItem].MoveTo(MoveToItem,MoveInsMode);


                finally
                  Begin
                    EndUpDate;

                    SetChildMove;

                    If (InChild) and (Assigned(ChildNom)) then
                    Begin
                      {ChildNom.LastCursor:=LastCursor;}
                      ChildNom.Move1Click(Nil);
                    end;

                    MoveMode:=Not MoveMode;
                    {Move1.Enabled:=BOn;
                    Cursor:=LastCursor;}
                  end;
                end;
              end;

    end; {Case..}
  end; {With..}

  If (Not IAmChild) then
  Begin
    CanlMove1.Visible:=MoveMode;
    Move1.Visible:=Not MoveMode;
    Move2.Visible:=Not Move1.Visible;
  end;


end;



procedure TJobView.OptSpeedClick(Sender: TObject);
Var
  Locked  :  Boolean;

begin

  Locked:=BOn;

  Begin


    If (GetMultiSys(BOn,Locked,SysR)) then
    Begin
      Syss.BigJobTree:=Not Syss.BigJobTree;

      PutMultiSys(SysR,BOn);
    end;

    OptSpeed.Checked:=Syss.BigJobTree;

  end;
 
end;


procedure TJobView.CheckJobTotals1Click(Sender: TObject);
begin
  {$IFDEF POST}
    AddCheckNom2Thread(Self,Nom,JobRec^,5);
  {$ENDIF}

end;

procedure TJobView.CheckJobTotals2Click(Sender: TObject);
begin
  {$IFDEF POST}
    With NLOLine do
      If (SelectedItem>0) then
      Begin
        GetSelRec;
        ExLocal.AssignFromGlobal(JobF);

        AddJobPost2Thread(Self,46,ExLocal.LJobRec^.JobCode,Nil,Self.Handle);
      end;
  {$ENDIF}

end;


procedure TJobView.ShowTotals1Click(Sender: TObject);
begin
  //TW 18/10/2011: Due to the backwards way this form works i added a new boolean
  //               to allow for the totals to be shown/closed correctly and under
  //               the appropriate circumstances.
  {
  ShowJATotals := not ShowJATotals;

  if (not showingTotals) then
  begin
    ShowJATotals := true;
    ReconBtnClick(nil)
  end
  else
  begin
    if Assigned(JobTotalsForm) and (InRecon) then
    begin
      InRecon := false;
      JobTotalsForm.Close;
    end;
    showingTotals := false;
    ShowJATotals := true;
  end;
  }
  if Assigned(JobTotalsForm) then
    CloseJobTotals
  else
    OpenJobTotals;
end;

Procedure TJobView.Create_CopyJob(Const NJCode,
                                        JParent :  Str10;
                                  Const Fnum,
                                        Keypath :  Integer);


Begin

  With ExLocal,LJobRec^ do
  Begin

    JobCode:=NJCode;
    JobCat:=JParent;

    Blank(JPTOurRef,Sizeof(JPTOurRef));
    Blank(JSTOurRef,Sizeof(JSTOurRef));

    JobFolio:=SetNextJFolio(JBF,BOn,0);

    Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

    Report_BError(Fnum,Status);

  end; {With..}

end; {Proc..}


{ ======= Copy Job History for Budgets ======== }

Procedure TJobView.Copy_JobHistory(Const FJCode,TJCode  :  Str10;
                                   Const FJTYpe         :  Char;
                                         Fnum,Keypath   :  Integer);

Var
  TmpStat       :  Integer;
  TmpRecAddr    :  LongInt;

  KeyChk,
  KeyS          :  Str255;


Begin

  With ExLocal do
  Begin

    KeyChk:=FJType+FJCode;

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With LNHist do
    Begin
      Application.ProcessMessages;

      TmpStat:=LPresrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOff,BOff);

      Sales:=0;
      Purchases:=0;
      Cleared:=0;

      Code:=TJCode+Copy(Code,Succ(JobCodeLen),Length(Code)-JobCodeLen);

      Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      TmpStat:=LPresrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOn,BOff);

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,keypath,KeyS);

    end; {While..}
  end; {With..}

end; {Proc..}


{ ======= Copy Job PayRates ======== }

Procedure TJobView.Copy_JobPayRates(Const FJCode,TJCode  :  Str10;
                                          Fnum,Keypath   :  Integer);

Var
  TmpStat       :  Integer;
  TmpRecAddr    :  LongInt;

  KeyChk,
  KeyS          :  Str255;


Begin

  With ExLocal do
  Begin

    // MH 25/06/2009: Modified to use Job Code formatting function as the Employee Code
    // formatting function formats to 6 characters whereas jobs can be up to 10 long -
    // this results in it copying incorrect rates if the first 6 characters match
    //KeyChk:=JBRCode+JBSubAry[3]+FullEmpKey(FJCode);
    KeyChk:=JBRCode+JBSubAry[3]+FullJobCode(FJCode);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With LJobCtrl^.EmplPay do
    Begin
      Application.ProcessMessages;

      TmpStat:=LPresrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOff,BOff);

      EmpCode:=FullJobCode(TJCode);

      EmplCode:=FullJBCode(EmpCode,CostCurr,EStockCode);

      Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      TmpStat:=LPresrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOn,BOff);

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,keypath,KeyS);

    end; {While..}
  end; {With..}

end; {Proc..}


{ ========= Routines to Delete a job and all asociated files ======= }

Procedure TJobView.CopyBudgetDetails(Const FJCode,
                                           TJCode,
                                           FParent  :  Str10;
                                     Const JFolio   :  LongInt;
                                           Fnum,
                                           Keypath  :  Integer;
                                     Const Fnum2,
                                           Keypath2 :  Integer);


Const

  LoopCtrl  :  Array[1..3] of Char  =  (JBSCode,JBBCode,JBMCode);

Var
  Loop  :  Byte;

  KeyChk,
  KeyS  :  Str255;

  TmpStat
        :  Integer;
  TmpRecAddr
        :  LongInt;


Begin

  Loop:=1;

  Create_CopyJob(TJCode,FParent,Fnum2,Keypath2);

  With ExLocal do
  Begin

    If (StatusOk) then
    Repeat

      KeyChk:=PartCCKey(JBRCode,LoopCtrl[Loop])+FJCode;

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With LJobCtrl^,JobBudg do
      Begin
        TmpStat:=LPresrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOff,BOff);

        JobCode:=TJCode;

        OrigValuation:=0.0;
        RevValuation:=0.0;
        JAPcntApp:=0.0;

        Case SubType of

          JBBCode  :  Begin
                        BudgetCode:=FullJBCode(JobCode,CurrBudg,AnalCode);

                        Code2NDX:=FullJBDDKey(JobCode,AnalHed); {* To enable Drill down to analysis level *}
                      end;

          JBSCode  :  Begin

                        BudgetCode:=FullJBCode(JobCode,CurrBudg,StockCode);

                        Code2NDX:=FullJDAnalKey(JobCode,AnalCode); {* To enable Drill down to analysis level *}

                      end;

          JBMCode  :  BudgetCode:=FullJBCode(JobCode,CurrBudg,FullNomKey(HistFolio));


        end; {Case..}


        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum,Status);

        TmpStat:=LPresrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOn,BOff);

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,keypath,KeyS);


      end; {While..}


      Inc(Loop);


    Until (Loop>3);

    Copy_JobHistory(FJCode,TJCode,LJobRec^.JobType,NHistF,NHK);

    Copy_JobPayRates(FJCode,TJCode,JCtrlF,JCK);

    //TW 07/11/2011 Adds Job Copy audit note.
    if(Status = 0) then
     TAuditNote.WriteAuditNote(anJob, anCreate, ExLocal);


    {$IFDEF NP}
      CopyNoteFolio(NoteJCode,NoteDCode,FullNCode(FullNomKey(JFolio)),FullNCode(FullNomKey(LJobRec^.JobFolio)),0);
    {$ENDIF}

  end; {With..}

end; {Proc..}


Procedure TJobView.Copy_Contract(NJCode  :  Str10;
                                 CopyCon :  Boolean;
                                 Level   :  LongInt);

Const
  Fnum     = JobF;
  Keypath  = JobCatK;

Var
  CopyJob  :  JobRecType;

  TmpStat,
  TmpKpath
        :  Integer;
  TmpRecAddr
        :  LongInt;

  KeyS,
  KeyChk   :  Str255;

  AutoJCode:  Str10;


Begin
  With ExLocal do
  Begin
    CopyJob:=LJobRec^;  AutoJCode:='';

    CopyBudgetDetails(CopyJob.JobCode,NJCode,CopyJob.JobCat,CopyJob.JobFolio,JCtrlF,JCK,JobF,JobCodeK);

    If (CopyCon) and (CopyJob.JobType=JobGrpCode) then {Go find child jobs}
    Begin
      TmpKPath:=GetPosKey;

      KeyChk:=CopyJob.JobCode;

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With LJobRec^ do
      Begin
        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

        JobCat:=NJCode;

        AutoJCode:=Auto_GetJCode(Trim(JobCode),JobF,JobCodeK);

        Copy_Contract(AutoJCode,BOn,Succ(Level));

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,keypath,KeyS);

      end;

      
    end;

  end;
end;


Procedure TJobView.Copy_Job;


Var
  InpOk,
  FoundOk  :  Boolean;

  FoundCode:  Str20;
  FoundLong
           :  LongInt;

  n,INCode :  Integer;

  mRet     :  Word;

  SCode    :  String;

  KeyS     :  Str255;

  {CopyJob  :  JobRecType;}


Begin

  SCode:='';
  FoundOk:=BOff;

  GetSelRec;

  ExLocal.AssignFromGlobal(JobF);

  With ExLocal do
  Begin

    Repeat

      InpOk:=InputQuery('Copy Job Record '+dbFormatName(LJobRec^.JobCode,LJobRec^.JobDesc),'Please enter the new Job code for the copy Job',SCode);

      If (InpOk) then
      Begin
        SCode:=UpCaseStr(FullJobCode(SCode));

        FoundOk:=(Not (Check4DupliGen(SCode,JobF,JobCodeK,'Job Code'))) and (Not EmptyKey(Scode,JobKeyLen));

      end;

    Until (FoundOk) or (Not InpOk);

    If (FoundOk) then
    Begin
      {CopyJob:=LJobRec^;}

      If (LJobRec^.JobType=JobGrpCode) then
      Begin
        mRet:=CustomDlg(Application.MainForm,'Please Confirm','Copy Entire Contract',
                        'This Contract contains other Jobs/Contracts.'+#13+
                        'Do you wish to copy the entire structure of this Job Contract to the new Contract?',mtConfirmation,[mbYes,mbNo]);

        FoundOk:=(mRet=mrOk);
      end
      else
        FoundOk:=BOff;


      LastCursor:=Cursor;

      Cursor:=crHourGlass;

      {CopyBudgetDetails(CopyJob.JobCode,SCode,CopyJob.JobCat,CopyJob.JobFolio,JCtrlF,JCK,JobF,JobCodeK);}

      Copy_Contract(SCode,FoundOk,0);

      AddEditLine(BOff);

      Cursor:=LastCursor;
    end;
  end;

end;



procedure TJobView.CopyJob1Click(Sender: TObject);
begin
  If (NLOLine.SelectedItem>0) then
    Copy_Job;
end;


{ ======= Invoice Wizard based control ======= }

procedure TJobView.Display_InvWRec(Mode     :  Byte;
                                   JCode    :  Str10);

{$IFDEF POST}

    Var
      WasNew  :  Boolean;
      TInvRec :  TJInvFrm;


      Begin
        WasNew:=BOff;

        With ExLocal do
        Begin
          {Set_JRFormMode(IsSales); * Set Stage or final *}
        end;


        If (JInvRecPtr=nil) then
        Begin
          TInvRec:=TJInvFrm.Create(Self);

          WasNew:=BOn;

          JInvRecPtr:=TInvRec;
        end
        else
          TInvRec:=JInvRecPtr;

        Try


         With TInvRec,ExLocal do
         Begin
           If (LJobRec^.JobCode<>JCode) then
             LGetMainReCPos(JobF,JCode);


           WindowState:=wsNormal;


           SetFirstFieldFocus;

           If (WasNew) then
             EditIWiz(JobF,JobCodeK)
           else
             Show;


         end; {With..}


        except

         TInvRec.Free;
         JInvRecPtr:=nil;

        end;
{$ELSE}
  Begin
{$ENDIF}


  end;



procedure TJobView.InvJob1Click(Sender: TObject);

Var
  ONomRec  :  ^OutNomType;

begin
  If (NLOLine.SelectedItem>0) then
  With NLOLine do
  Begin
    ONomRec:=Items[SelectedItem].Data;

    If (ONomRec^.OutNomType=JobJobCode) then
      Display_InvWRec(0,ONomRec^.OutStkCode);
  end;
end;


procedure TJobView.CalcMenuExclude(Var  Source  :  TMenuItem;
                                   Var  IncInt  :  LongInt);

Var
  n         :  LongInt;
  TV        :  Integer;
  ThisChild :  TMenuItem;

Begin
  IncInt:=0;

  If (Pred(GetMenuItemCount(Source.Handle))>=0) then
  Begin

    With Source do
    For n:=0 to (Pred(GetMenuItemCount(Handle))) do
    Begin
      TV:=Items[n].Tag;

      Case TV of
        1..5
              :  Begin
                   If (Items[n].Checked) then
                     IncInt:=IncInt+Round(Power(2,TV));
                 end;


      end; {Case..}
    end; {Loop..}
  end;
end;



procedure TJobView.Quotation1Click(Sender: TObject);
begin
  If (Sender is TMenuItem) then
  Begin
    TMenuItem(Sender).Checked:=Not TMenuItem(Sender).Checked;

    CalcMenuExclude(FiltJobs1,IncJobFilt);

    With NLOLine do
    If (ItemCount>0) then
    Repeat

      Delete_OutLines(1,BOn);

    Until (ItemCount<=0);

    Add_OutLines(0,2,0,'','',BOff,JobF,JobCatK)


  end;
end;

procedure TJobView.CISL1Click(Sender: TObject);

begin

    If (Sender is TMenuItem) then
    Begin
      If (Not InJTCISVoucher) then
      Begin
        InJTCISVoucher:=BOn;

        SetFMode(TMenuItem(Sender).Tag);

        With TCISVInp.Create(Self) do
        Try

        except
          Free;

        end; {try..}
      end
      else
      Begin
        Set_BackThreadMVisible(BOn);
        ShowMessage('The '+CCCISName^+' '+GetIntMsg(4)+' Ledger is currently in use.');
        Set_BackThreadMVisible(BOff);
      end;

    end


end;

procedure TJobView.ShowApps1Click(Sender: TObject);
begin
  {$IFDEF DBk_On}

    Begin
      If (Not Assigned(JCDayBk)) then
      Begin
        SetForApps:=BOn;

        InJCDayBk:=BOn;
        JCDayBk:=TJobDayBk.Create(Self);
      end
      else
      With JCDayBk do
      Begin
        If (WindowState=wsMinimized) then
          WindowState:=wsNormal;

        Show;
      end;
    end;
  {$ENDIF}
end;


procedure TJobView.Set_ValuationFromContract(Mode             :  Byte);

Var
  ONomRec       :  ^OutNomType;
  NomNHCtrl     :  TNHCtrlRec;

  LSelectedItem
                :  LongInt;
  ThisNode      :  TSBSOutLNode;

  jpAppCtrlRec  :  tJAppWizRec;


Begin
  With NLOLine do
  If (SelectedItem>0) then
  Begin
    LSelectedItem:=SelectedItem;
    ThisNode:=Items[LSelectedItem];

    ONomRec:=ThisNode.Data;
  end;

  GetSelRec;



  With ONomRec^ do
  Begin
    If (OutNomType=JobGrpCode) then
    Begin
      JAPGenValInput(Self,52,OutStkCode);
    end
    else
    Begin
      CustomDlg(Self,'Please Note!','Contracts Only',
               'It is only possible to set the valuation at Contract level to then set all the Sub contracts and Jobs'+
               ' contained within the contract using this option',
               mtInformation,
               [mbOk]);


    end;
  end;



end;

procedure TJobView.Set_ValuationFromExpenditure(Mode   :  Byte);

Var
  ONomRec       :  ^OutNomType;
  NomNHCtrl     :  TNHCtrlRec;

  LSelectedItem
                :  LongInt;
  ThisNode      :  TSBSOutLNode;


Begin
  With NLOLine do
  If (SelectedItem>0) then
  Begin
    LSelectedItem:=SelectedItem;
    ThisNode:=Items[LSelectedItem];

    ONomRec:=ThisNode.Data;
  end;

  GetSelRec;



  With ONomRec^ do
  Begin
    If (LSelectedItem>=0) then
    Begin
      JAPGenValInput(Self,Mode,OutStkCode);
    end
    else
    Begin

    end;
  end;



end;

procedure TJobView.Val1Click(Sender: TObject);
begin
  If (Sender is TMenuItem) then
    With TMenuItem(Sender) do
    Case Tag of
      0  :  Set_ValuationFromContract(0);
      1  :  Set_ValuationFromExpenditure(52+Tag);
    end; {Case..}
end;

// -----------------------------------------------------------------------------
// Routines for handling the Job Totals form
// -----------------------------------------------------------------------------
// Creates and displays the Job Totals form
procedure TJobView.OpenJobTotals;
var
  TreeItem : ^OutNomType;
begin
  // 208 = allow View Job Record Totals
  if ChkAllowed_In(208) and (NLOLine.SelectedItem > 0) and (JobTotalsForm = nil) then
  begin
    // Retrieve the details of the currently selected item in the Job Tree
    TreeItem := NLOLine.Items[NLOLine.SelectedItem].Data;

    // Locate the Job Record for the currently selected item
    GetSelRec;

    // Set up the Job Code that the form should display
    Set_JAViewJC(TreeItem.OutStkCode);

    // Create the form
    JobTotalsForm := TJAView.Create(Self);
    JobTotalsForm.Show;
  end;
end;

// Ensures that the Job Totals form matches the selected item in the Job Tree
procedure TJobView.SynchroniseJobTotals;
// Copied from ReconBtnClick() and amended
var
  TreeItem :  ^OutNomType;
  MustResync :  Boolean;
begin
  MustResync := BOff;

  // 208 = allow View Job Record Totals
  If ChkAllowed_In(208) and Assigned(JobTotalsForm) and (NLOLine.SelectedItem > 0) then
  With NLOLine do
  Begin
    // Retrieve the details of the currently selected item in the Job Tree
    TreeItem := Items[SelectedItem].Data;

    // Is the Job Totals form displaying a different Job/Contract? If so, we
    // need to update the display
    MustResync :=(JobTotalsForm.JATreeJCode <> TreeItem^.OutStkCode);

    If (MustResync) and (Not InHCallBack) then
    begin
      // Locate the actual Job record
      GetSelRec;
      With JobTotalsForm do
      Begin
        // Refresh the Job Totals Form with the current Job Code
        WindowState := wsNormal;
        SetTabxJType(JobRec^.JobType);
        ApplyNewJCode(TreeItem^.OutStkCode);
      end; {With..}

    end;
  end;
end;

// Closes the Job Totals form
procedure TJobView.CloseJobTotals;
begin
  JobTotalsForm.Close;
  OnJobTotalsClose;
end;

// Called when Job Totals form is closed, either programmatically or by the
// user.
procedure TJobView.OnJobTotalsClose;
begin
  JobTotalsForm := nil;
end;


{$IFDEF DBD}
procedure Run_Test512;

Var
  tw  :  tJAppWizRec;
begin
  //UnAllocWizard(Sender);

  {$IFDEF DBD}
      {$IFDEF POST}
    {$IFDEF JC}
       FillChar(tw,Sizeof(tw),#0);

       If (JBCostOn) then
         AddJobPostApp2Thread(Application.MainForm,99,tw,Application.MainForm.handle);
    {$ENDIF}
  {$ENDIF}


  {$ENDIF}
end;

{$ENDIF}


procedure TJobView.CheckAllJobs1Click(Sender: TObject);
begin
  {$IFDEF POST}
  SQLCheckAllJobs(self);
  {$ENDIF}
end;

procedure TJobView.FormDestroy(Sender: TObject);
begin
  //PR: 18/05/2017 ABSEXCH-18683 v2017 R1 If we've started a move, then
  //closed the window without completing it we need to remove the process lock
  if FNeedToReleaseProcessLock then
    if Assigned(Application.Mainform) then
       SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plMoveJob), 0);
end;

end.
