unit Nominl1U;

{$I DEFOVR.Inc}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Grids,StdCtrls, {OutLine,} SBSOutl, TEditVal,
  GlobVar,VarConst,ETStrU,BtrvU2,BTSupU1, BTKeys1U,ExtCtrls, Buttons,
  BorBtns, Menus, ImgModU, ExWrap1U, HistWinU, ReconU, NomRecU, NmlCCDU,
  BTSupU3, MoveTL1U, EntWindowSettings, SBSPanel, ToolWin, AdvGlowButton,
  AdvToolBar, AdvToolBarStylers, VarRec2U;
type

  //PR: 05/08/2008 In order to allow passing of colours to ObjectClones we needed to change the way that settings were used on this form.
  //Previously, we were using the form itself as the parent object for the settings (logically enough, since it was the parent of all the controls.)
  //However, when the form was created as an object clone, Delphi appends a number to the name (eg Nomview_1). Consequently, the ObjectClone
  //wasn't finding the correct parent record in the settings object passed to it. To get round this, I've added a new panel (pnlAll) to the form, to
  //be the parent for the controls. This is aligned alClient, all the controls have been moved to it, and it is passed into any settings functions
  //where Self would previously have been passed as the parent.  ABSEXCH-11428

  TNomview = class(TForm)
    pnlAll: TPanel;
    NLOLine: TSBSOutlineB;
    SBSPanel1: TSBSPanel;
    NCurrLab: Label8;
    TxLateChk: TBorCheck;
    Currency: TSBSComboBox;
    OptBtn: TButton;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    AdvToolBarSeparator4: TAdvToolBarSeparator;
    AdvToolBarSeparator5: TAdvToolBarSeparator;
    FullExBtn: TAdvGlowButton;
    FullColBtn: TAdvGlowButton;
    GraphBtn: TAdvGlowButton;
    HistBtn: TAdvGlowButton;
    ReconBtn: TAdvGlowButton;
    NomSplitBtn: TAdvGlowButton;
    Panel1: TPanel;
    YTDChk: TBorCheck;
    Panel2: TPanel;
    ClsI1Btn: TButton;
    Panel3: TPanel;
    Label82: Label8;
    Label81: Label8;
    Period: TSBSComboBox;
    ToPeriod: TSBSComboBox;
    Panel6: TPanel;
    Label83: Label8;
    Year: TSBSComboBox;
    PopupMenu1: TPopupMenu;
    Record1: TMenuItem;
    Edit1: TMenuItem;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    DeleteAll1: TMenuItem;
    Add2: TMenuItem;
    MIHist: TMenuItem;
    Graph1: TMenuItem;
    Filter1: TMenuItem;
    NCC1: TMenuItem;
    NDp1: TMenuItem;
    Commitment1: TMenuItem;
    Commit1: TMenuItem;
    Commit2: TMenuItem;
    Commit3: TMenuItem;
    MIFind: TMenuItem;
    CCDepView1: TMenuItem;
    N4: TMenuItem;
    Move1: TMenuItem;
    Move2: TMenuItem;
    CanlMove1: TMenuItem;
    MoveList1: TMenuItem;
    N8: TMenuItem;
    CopytoGLView1: TMenuItem;
    N5: TMenuItem;
    Expand1: TMenuItem;
    MIETL: TMenuItem;
    MIEAL: TMenuItem;
    EntireGeneralLedger1: TMenuItem;
    MIColl: TMenuItem;
    MICTL: TMenuItem;
    EntireGeneralLedger2: TMenuItem;
    N7: TMenuItem;
    ObjectClone1: TMenuItem;
    ObjectClone2: TMenuItem;
    AddTB1: TMenuItem;
    Check1: TMenuItem;
    N6: TMenuItem;
    ShowC1: TMenuItem;
    Show1: TMenuItem;
    ShowG1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    AdvStyler: TAdvToolBarOfficeStyler;
    Panel4: TSBSPanel;
    lblGLCode: Label8;
    NLDPanel: TSBSPanel;
    lblTBDiff: Label8;
    NLCrPanel: TSBSPanel;
    NLDrPanel: TSBSPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure NLOLineExpand(Sender: TObject; Index: Longint);
    procedure NLOLineNeedValue(Sender: TObject);
    procedure CurrencyClick(Sender: TObject);
    procedure FullExBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ClsI1BtnClick(Sender: TObject);
    procedure NomSplitBtnClick(Sender: TObject);
    procedure NLOLineCollapse(Sender: TObject; Index: Longint);
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
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PeriodExit(Sender: TObject);
    procedure MIFindClick(Sender: TObject);
    procedure ReconBtnClick(Sender: TObject);
    procedure OptBtnClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure ShowC1Click(Sender: TObject);
    procedure NCC1Click(Sender: TObject);
    procedure Move1Click(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure Commit1Click(Sender: TObject);
    procedure NLOLineUpdateNode(Sender: TObject; var Node: TSBSOutLNode;
      Row: Integer);
    procedure CCDepView1Click(Sender: TObject);
    procedure AddTB1Click(Sender: TObject);
    procedure ShowG1Click(Sender: TObject);
    procedure Check1Click(Sender: TObject);
    procedure ObjectClone2Click(Sender: TObject);
    procedure DeleteAll1Click(Sender: TObject);
    procedure YearKeyPress(Sender: TObject; var Key: Char);
    procedure CopytoGLView1Click(Sender: TObject);
    procedure MoveList1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    IAmChild,
    FiltCarryF,
    FiltNType,
    ShowGLCode,
    RefreshHist,
    RefreshRecon,
    RefreshCCDepView,
    InHCallBack,
    InHBeen,
    UseYTD,
    MoveMode,
    StoreCoord,
    fNeedCUpdate,
    FColorsChanged,
    LastCoord,
    SetDefault,
    MoveAskList,
    UseMoveList,
    PostLock,
    GotCoord     :   Boolean;

    Lab1Ofset,
    Lab2Ofset,
    Lab3Ofset,
    Lab4Ofset,
    ChrWidth     :   LongInt;

    MoveToItem,
    MoveItemParent,
    MoveItem     :   Integer;

    MoveInsMode  :   TSBSAttachMode;

    LastCursor   :   TCursor;

    StartSize,
    InitSize     :  TPoint;


    MoveGLList   :   TMoveLTList;

    TBDiff,
    ChrsXross    :   Double;

    ColXAry      :   Array[1..2] of LongInt;

    ChildNom
        :   TNomView;

    InChild      :   Boolean;

    HistForm     :   THistWin;

    CCDepView    :   TCCDepView;

    InCCDepView,
    InCCDepVLink,
    InHist       :   Boolean;


    ReconForm    :   TReconList;
    InRecon      :   Boolean;

    ExLocal      :   TdExLocal;

    NomActive    :  Boolean;

    NomRecForm   :  TNomRec;

    fImageRepos  :  TImageRepos;

    // MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
    FSettings : IWindowSettings;

    //PR: 18/05/2017 ABSEXCH-18683 v2017 R1 If we've started a move, then
    //closed the window without completing it we need to remove the process lock
    //This variable keeps track of whether we need to remove the lock on destroy
    FNeedToReleaseProcessLock : Boolean;

    { Private declarations }

    procedure SetWindowSettings(const Value : IWindowSettings);
    function IsClone : Boolean;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Procedure SuperDDCtrl(Mode  :  Byte);

    procedure GetSelRec;

    Procedure LinkList(NC  :  LongInt);

    procedure Display_Account(Mode             :  Byte;
                              ChangeFocus      :  Boolean);

    Procedure AddEditLine(Edit  :  Boolean);

    Procedure Delete_OutLines(PIndex      :  LongInt;
                              DelSelf     :  Boolean);

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Function CreateDiffCaption  :  Str255;

    Function CreateCaption  :  Str255;

    Function FormatLine(ONomRec  :  OutNomType;
                        LineText :  String)  :  String;

    Procedure Add_TotOutLines(Depth,
                              DepthLimit,
                              NomCat,
                              OIndex        :   LongInt;
                              ONType        :   Char;
                              LineText      :   String);

    Function TB_Balance(CheckGlobal  :  Boolean)  :  Double;

    Procedure Show_TBDiff(ShowZero  :  Byte);

    Procedure Add_OutLines(Depth,
                           DepthLimit,
                           NomCat,
                           OIndex        :   LongInt;
                     Const Fnum,
                           Keypath       :   Integer);


    Procedure Update_OutLines(Const Fnum,
                                    Keypath       :   Integer);

    Procedure Drill_OutLines(Depth,
                             DepthLimit,
                             PIndex      :  LongInt);


    procedure NLChildForceReDraw;

    procedure NLChildUpdate;

    procedure Display_History(ONomCtrl     :  OutNomType;
                              ChangeFocus,
                              ShowGraph    :  Boolean);

    procedure Display_Recon(Opt          :  Byte;
                            ONomCtrl     :  OutNomType;
                            ChangeFocus  :  Boolean);

    procedure Display_CCDepView(ONomCtrl     :  OutNomType;
                                ChangeFocus  :  Boolean);

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure SetFieldProperties;

    function FindNode(NCode  :  LongInt)  :  Integer;

    Procedure FindNomCode;

    Function Is_NodeParent(MIdx,SIdx  :  Integer)  :  Boolean;

    Function Place_InOrder(MIdx,SIdx  :  Integer;
                       Var UseAdd     :  Boolean)  :  Integer;

    Function Check_TransForNom  :  Boolean;

    Procedure DeleteAllNoms;

    Function AddMove2List(MoveRec  :  MoveRepPtr)  :  Boolean;

    Procedure RestartView;


    {$IFDEF POST}
      Function Confirm_Move(MIdx,SIdx  :  Integer)  :  Boolean;


      Procedure Alter_Total(Const PIdx1 :  Integer;
                            Const NC    :  LongInt;
                            Const HideValues
                                        :  Boolean);

      Procedure HideAll_Totals(Const HideValues  :  Boolean);

      Procedure Update_TotalMove(Const NC1,NC2     :  LongInt;
                                 Const CalcMode    :  Boolean);

      Function FindXONC(Const NC1  :  LongInt)  :  Integer;

      Procedure Update_Total4Thread(RecAddr  :  LongInt;
                                    CalcMode :  Boolean);

    {$ENDIF}

    procedure SetChildMove;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    procedure Show_CCDepViewHistory(ShowGraph  :  Boolean;
                                    ViewMode   :  Byte);

    Function Being_Posted(Const LMode  :  Byte)  :  Boolean;

    procedure Calc_TBDiff;

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;
    Function Get_PWDefaults(PLogin  :  Str10) : tPassDefType;

  public
    { Public declarations }
    CCNomFilt    :   CCNomFiltType;

    CCNomMode    :   Boolean;

    CommitMode   :   Byte;


    NTxCr,
    NCr,NPr,
    NPrTo,NYr    :   Byte;

    ParentNom,
    GrandPNom  :  TNomView;


    {$IFDEF POST}
        procedure RefreshMove(WhichNode  :  Integer);
    {$ENDIF}

    Procedure PlaceNomCode(FindCode  :  LongInt);

    property WindowSettings : IWindowSettings read FSettings write SetWindowSettings;

  end;

  Function GLTypeChange(LNom    :  NominalRec;
                        NTyp    :  Char;
                        AOwner  :  TForm)  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETDateU,
  ETMiscU,
  CurrncyU,
  Mask,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  CmpCtrlU,
  ColCtrlU,
  ComnU2,
  BtSupU2,
  SalTxl1U,
  InvListU,

  {$IFDEF POST}
    PostSp2U,
    GenWarnU,
    MovWarnU,

  {$ENDIF}

  MoveTR1U,

  NmlCDIU,

  TrialBalanceWarningF,

  ExThrd2U,
  SysU1,
  PWarnU,

  oProcessLock;

{$R *.DFM}

Const
  InitWidth  =  128; {118}
  TDpth      =  70;




{$IFDEF POST}
  Function Confirm_ChangeType(LNom    :  NominalRec;
                              NTyp    :  Char;
                              AOwner  :  TForm)  :  Boolean;

  Var
    MoveRec  :  MoveRepPtr;
    mbRet    :  Word;
    WMsg     :  AnsiString;

  Begin
    New(MoveRec);


    Result:=BOff;

    try
      FillChar(MoveRec^,Sizeof(MoveRec^),0);

      With MoveRec^, LNom do
      Begin
        MoveMode:=2;

        MoveNCode:=NomCode;
        WasNCat:=Cat;
        NewNCat:=Cat;
        NewNType:=NTyp;
        MoveNom:=LNom;

        Set_BackThreadMVisible(BOn);

        WMsg:=ConCat('You are about to change ',dbFormatName(Form_Int(MoveNom.NomCode,0),MoveNom.Desc),' from a type ',
                     NomType,' account to a type ',NTyp,' account,',#13,#13);
        WMsg:=ConCat(WMsg,'The heading totals affected will be blanked out until the change is complete.',#13,#13);
        WMsg:=ConCat(WMsg,'This operation should be performed with all other users logged out.',#13,#13,'A backup ',
              'MUST be taken since the integrity of the G/L will be damaged should the change fail.',#13,#13,
              'Do you wish to continue?');

        mbRet:=MovCustomDlg(Application.MainForm,'WARNING','G/L Type Change',WMsg,mtWarning,[mbYes,mbNo]);

        Set_BackThreadMVisible(BOff);

        Result:=(mbRet=mrOk);

        If (Result) then
          Result:=AddMove2Thread(AOwner,MoveRec);

      end; {With..}
    finally
      Dispose(MoveRec);

     end;
  end;

{$ENDIF}


Function GLTypeChange(LNom    :  NominalRec;
                      NTyp    :  Char;
                      AOwner  :  TForm)  :  Boolean;

Begin
  {$IFDEF POST}
    Result:=Confirm_ChangeType(LNom,NTyp,AOwner);
  {$ELSE}
    Result:=BOff;
  {$ENDIF}
end;


Procedure  TNomView.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


Procedure TNomView.Find_FormCoord;
Var
  VisibleRect : TRect;
Begin // Find_FormCoord
  // MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
  if not IsClone and Assigned(FSettings) and not FSettings.UseDefaults then
  begin
    FSettings.SettingsToWindow(Self);
    FSettings.SettingsToParent(pnlAll); //PR: 05/08/2008 ABSEXCH-11428
  end;

  With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;

    {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;
End; // Find_FormCoord

(***
procedure TNomView.Find_FormCoord;
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

    PrimeKey:='N';

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

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;

    {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;  ***)


procedure TNomView.Store_FormCoord(UpMode  :  Boolean);
//Var
//  GlobComp:  TGlobCompRec;
Begin
//  New(GlobComp,Create(BOff));
//
//  With GlobComp^ do
//  Begin
//    GetValues:=UpMode;
//
//    PrimeKey:='N';
//
//    ColOrd:=Ord(StoreCoord);
//
//    HLite:=Ord(LastCoord);
//
//    SaveCoord:=StoreCoord;
//
//    If (Not LastCoord) then {* Attempt to store last coord *}
//      HLite:=ColOrd;
//
//    StorebtControlCsm(Self);
//
//    ColOrd:=NLOLine.BarColor;
//
//    StorebtControlCsm(NLOLine);
//
//    ColOrd:=NLOLine.BarTextColor;
//
//    StorebtControlCsm(NLDPanel);
//
//    StorebtControlCsm(NLDrPanel);
//
//    StorebtControlCsm(NLCrPanel);
//
//    StorebtControlCsm(Period);
//
//
//  end; {With GlobComp..}
//
//  Dispose(GlobComp,Destroy);
end;


Function TNomView.FormatLine(ONomRec  :  OutNomType;
                             LineText :  String)  :  String;

Begin
  With ONomRec,Nom do
  Begin
    Result:=Spc(1*OutDepth)+Strip('R',[#32],LineText);

    If (FiltNType) and (OutNomType<>NomHedCode) then
      Result:=Result+' ('+NomType+')';

    If (ShowGLCode) then
      Result:=Result+' : '+Form_Int(NomCode,0);

    Result:=Result+Spc(Round((Width-Canvas.TextWidth(Result))/Canvas.TextWidth(' '))-(TDpth*OutDepth));

    LineText:=LineText+Spc(Round((Width-Canvas.TextWidth(LineText))/CanVas.TextWidth(' '))-(TDpth*OutDepth));
  end;
end;


{ ======= Procedure to Build Total for each heading File ===== }

Procedure TNomview.Add_TotOutLines(Depth,
                                 DepthLimit,
                                 NomCat,
                                 OIndex        :   LongInt;
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
      OutNomCode:=NomCat;
      OutDepth:=Depth;
      BeenDepth:=DepthLimit;
      OutNomType:=ONType;
      HedTotal:=BOn;
    end;

    {LineText:=Spc(1*Depth)+LJVar(LineText,ChrWidth-(20*Depth));}

    LineText:=Spc(1*Depth)+Strip('R',[#32],LineText);

    LineText:=LineText+Spc(Round((Width-Canvas.TextWidth(LineText))/Canvas.TextWidth(' '))-(TDpth*Depth));


    NewIdx:=AddChildObject(OIndex,LineText,ONomRec);

  end; {With..}

end; {Proc..}

{ == Function to calculate TB_Level zero difference == }

Function TNomview.TB_Balance(CheckGlobal  :  Boolean)  :  Double;
//Var
//  ChkCr,
//  ChkPr,
//  ChkYr  :  Byte;
//
//  Purch,Sales,Cleared
//         :  Double;
Begin
(*
  Result:=0.0;

  ChkCr:=0;

  If (CheckGlobal) then
  Begin
    ChkPr:=99; ChkYr:=150;

  end
  else
  Begin
    ChkPr:=NPr; ChkYr:=NYr;
    ChkCr:=NCr;

  end;

  With Nom do
    Result:=Round_Up(Profit_To_Date(NomType,FullNomKey(NomCode),ChkCr,ChkYr,ChkPr,Purch,Sales,Cleared,BOn),2);
*)

  // MH 05/10/2010 v6.4 ABSEXCH-9791: Modified to use common routine
  If CheckGlobal Then
    Result := CalcGLTrialBalanceAmount (Nom.NomCode, Nom.NomType)
  Else
    Result := CalcGLTrialBalanceAmount (Nom.NomCode, Nom.NomType, NCr, NPr, NYr);
end;

Procedure TNomview.Show_TBDiff(ShowZero  :  Byte);

Begin
  // MH 05/10/2010 v6.4 ABSEXCH-9791: Modified to use common routine
  //lblTBDiff.Visible:=(ABS(TBDiff)>=1);
  lblTBDiff.Visible := IsTrialBalanceBorked(TBDiff);

  If (lblTBDiff.Visible) then
  With lblTBDiff do
  Begin
    Caption:='TB Out : '+FormatCurFloat(GenRealMask,TBDiff,BOff,NCr);
  end
  else
    Case ShowZero of
      1  :  Begin
              lblTBDiff.Visible:=BOn;

              lblTBDiff.Caption:='TB Balances.';
            end;
      2  :  Begin
              lblTBDiff.Visible:=BOn;

              lblTBDiff.Caption:='Post in progress.';
            end;
    end; {Case..}

end;

{ ======= Procedure to Build List based on Nominal File ===== }

Procedure TNomview.Add_OutLines(Depth,
                              DepthLimit,
                              NomCat,
                              OIndex        :   LongInt;
                        Const Fnum,
                              Keypath       :   Integer);


Var
  KeyS,
  KeyChk
          :  Str255;

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
  TmpKPath:=Keypath;

  With NLOLine do
  Begin

    SpcWidth:=Canvas.TextWidth(' ');

    KeyChk:=FullNomKey(NomCat);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Nom do
    Begin
      {* DO not put application.processmessages here, as nom re can get corrupted...*}

      If (NomType<>CarryFlg) or (Not FiltCarryF) then
      Begin

        New(ONomRec);
        FillChar(ONomRec^,Sizeof(ONomRec^),0);
        With ONomRec^ do
        Begin
          OutNomCode:=NomCode;
          OutNomCat:=Cat;
          OutDepth:=Depth;
          BeenDepth:=DepthLimit;
          OutNomType:=NomType;
        end;

        {LineText:=Spc(1*Depth)+LJVar(Desc,ChrWidth-(20*Depth))}

        {LineText:=FormatLine(ONomRec^,Strip('R',[#32],Desc));}

        LineText:=Spc(1*Depth)+Strip('R',[#32],Desc);

        If (FiltNType) and (ONomRec^.OutNomType<>NomHedCode) then
          LineText:=LineText+' ('+NomType+')';

        If (ShowGLCode) then
          LineText:=LineText+' : '+Form_Int(NomCode,0);

        LineText:=LineText+Spc(Round((Width-Canvas.TextWidth(LineText))/SpcWidth)-(TDpth*Depth));



        NewIdx:=AddChildObject(OIndex,LineText,ONomRec);

        If (NomType=NomHedCode) and (Depth<DepthLimit) then
        Begin
          TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

          Add_OutLines(Depth+1,DepthLimit,NomCode,NewIdx,Fnum,Keypath);

          TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);

          Add_TotOutLines(Depth+1,DepthLimit,NomCode,NewIdx,NomType,'Total '+Desc);
        end;

        If (Depth=0) and (NomCat=0) and (Not IamChild) and (Not PostLock) then {We are at level zero only, so go add up totals if other posting run not in prgress}
        Begin
          TBDiff:=Round_Up(TBDiff+TB_Balance(BOn),2);

        end;
      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

  end; {With..}

end; {Proc..}


Procedure TNomview.Update_OutLines(Const Fnum,
                                       Keypath       :   Integer);


Var
  KeyS    :  Str255;

  LineText
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
        KeyS:=FullNomKey(OutNomCode);

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        LineText:=Strip('B',[#32],Items[n].Text);

        With Nom do
        Begin
          {LineText:=Spc(1*OutDepth)+LJVar(LineText,ChrWidth-(20*OutDepth))}

          LineText:=Spc(1*OutDepth)+Strip('R',[#32],Desc);

          If (HedTotal) then
            LineText:='Total '+LineText
          else
          Begin
            If (FiltNType) and (OutNomType<>NomHedCode) then
              LineText:=LineText+' ('+NomType+')';

            If (ShowGLCode) then
              LineText:=LineText+' : '+Form_Int(NomCode,0);

          end;

          

          {LineText:=FormatLine(ONomRec^,LineText);}

          LineText:=LineText+Spc(Round((Width-Canvas.TextWidth(LineText))/CanVas.TextWidth(' '))-(TDpth*OutDepth));

        end;

        Items[n].Text:=LineText;
      end;

    end; {Loop..}

    EndUpdate;

  end; {With..}
end; {Proc..}


Procedure TNomview.Drill_OutLines(Depth,
                                DepthLimit,
                                PIndex      :  LongInt);

Var
  NextChild       :  LongInt;

  ONomRec         :  ^OutNomType;

  LoopCtrl        :  Boolean;


Begin
  LoopCtrl:=BOff;

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
          If (NextChild<1) then {* Try and find more for this level *}
          Begin
            If (Not LoopCtrl) and (Not HedTotal) then
            Begin
              Add_OutLines(Depth,DepthLimit,OutNomCode,PIndex,NomF,NomCatK);

              ONomRec:=Items[PIndex].Data;

              If (OutNomType=NomHedCode) then
                Add_TotOutLines(Depth,DepthLimit,OutNomCode,PIndex,OutNomType,'Total '+Items[PIndex].Text);
            end;
          end
          else
            Drill_OutLines(Depth+1,DepthLimit,NextChild);
        end;

        If (Not LoopCtrl) then
          LoopCtrl:=BOn;

      Until (NextChild<1);

    end; {If limit reached..}

  end; {With..}
end; {Proc..}


Procedure TNomView.Delete_OutLines(PIndex      :  LongInt;
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

procedure TNomview.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  {* Inform parent closing *}

  If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
    Store_FormCoord(Not SetDefault);

  Send_UpdateList(40);

end;

procedure TNomview.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  N       :  LongInt;
  ONomRec :  ^OutNomType;
begin
  // MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
  If not IsClone and Assigned(FSettings) And NeedCUpdate Then
  Begin
    FSettings.ParentToSettings(pnlAll, NLOLine); //PR: 05/08/2008 ABSEXCH-11428
    FSettings.WindowToSettings(Self);
    FSettings.SaveSettings(StoreCoord);
  End; // If Assigned(FSettings) And NeedCUpdate
  FSettings := nil;


  With NLOLine do {* Tidy up attached objects *}
  Begin
    For n:=1 to ItemCount do
    Begin
      ONomRec:=Items[n].Data;
      If (ONomRec<>nil) then
        Dispose(ONomRec);
    end;

  end;

  If (InHist) and (HistForm<>nil) then
  Begin
    InHist:=BOff;
    HistForm.Free;
  end;

  If (InRecon) and (ReconForm<>nil) then
  Begin
    InRecon:=BOff;
    ReconForm.Free;
  end;

  If (InChild) and (ChildNom<>nil) then
  Begin
    InChild:=BOff;
    ChildNom.Free;
  end;

  If (NomActive) and (NomRecForm<>nil) then
  Begin
    NomRecform.Free;
    NomActive:=BOff;
  end;

  FreeandNil(fImageRepos);

  ExLocal.Destroy;

  Action:=caFree;

end;

Function TNomView.CreateCaption  :  Str255;

Begin
  Caption:='General Ledger Drill Down : '+Show_CCFilt(CCNomFilt[CCNomMode],CCNomMode)+Show_CommitMode(CommitMode);

  If (Not UseYTD) and (NPrTo>NPr) then
    Caption:=Caption+PPr_OutPr(NPr,NYr)+'-'+PPr_OutPr(NPrTo,NYr)+'. '+Show_TreeCur(NCr,NTxCr)+'.'
  else
    Caption:=Caption+PPr_OutPr(NPr,NYr)+'. '+Show_TreeCur(NCr,NTxCr)+'.';


end;

Function TNomView.CreateDiffCaption  :  Str255;

Begin
  Caption:=GrandPNom.Caption+' compared to  ';

  With ParentNom do
  Begin
    If (Not UseYTD) and (NPrTo>NPr) then
      Self.Caption:=Self.Caption+PPr_OutPr(NPr,NYr)+'-'+PPr_OutPr(NPrTo,NYr)
    else
      Self.Caption:=Self.Caption+PPr_OutPr(NPr,NYr);

  end;
end;

procedure TNomview.FormCreate(Sender: TObject);
var
  UProfile : tPassDefType;
begin
  FNeedToReleaseProcessLock := False;
  ExLocal.Create;

  UProfile:= Get_PWDefaults(EntryRec^.Login);

  InitSize.Y:=327;
  InitSize.X:=656;//603;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=349;
  Width:=590;}

  MDI_SetFormCoord(TForm(Self));

  GotCoord:=BOff;
  NeedCUpdate:=BOff;
  FColorsChanged := False;


  FillChar(CCNomFilt,Sizeof(CCNomFilt),0);
  CCNomMode:=BOff;
  CommitMode:=0;

  UseYTD:=BOn;

  Lab4Ofset:=Height-Panel4.Top+2;

  // MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
  //PR: 27/05/2011 Change to use ClassName rather than Name as identifier - if there are
  //2 instances of the form in existence at the same time, Delphi will change the name of one to Name + '_1' (ABSEXCH-11426)
  if not IsClone then
    FSettings := GetWindowSettings(Self.ClassName);
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  // CJS: 24/03/2011 ABSEXCH-10544
  // Moved the reading of the offsets so that they are read *before* the
  // window positions are retrieved, to ensure that they hold the design-time
  // offset (which will then be used to re-calculate the correct position for
  // the labels if the window settings have changed).
  Lab1Ofset:=Width-(NLDPanel.Width);
  Lab2Ofset:=Width-NLCrPanel.Left;
  Lab3Ofset:=Width-NLDrPanel.Left;

  Find_FormCoord;

  ChrWidth:=InitWidth;

  ChrsXRoss:=(ChrWidth/Width);

  If (Not Assigned(fImageRepos)) then
    fImageRepos:=TImageRepos.Create(Self);

  If (GetMaxColors(Self.Canvas.Handle)<2) or (Syss.UseClassToolB) then {Assign 16 bit speed buttons}
  Begin
//    ToolBar.Images := fImageRepos.ilTBar16Col;
//    ToolBar.HotImages := nil;

//    FreeandNil(fImageRepos.ilTBar24Bit);
//    FreeandNil(fImageRepos.ilTBar24BitHot);

  end
  else
  Begin
//    ToolBar.Images := fImageRepos.ilTBar24bit;
//    ToolBar.HotImages := fImageRepos.ilTBar24bitHot;

//    FreeandNil(fImageRepos.ilTBar16Col);
  end;


  FiltCarryF:=BOn;

  {$IFDEF MC_On}

    Set_DefaultCurr(Currency.Items,BOn,BOff);
    Set_DefaultCurr(Currency.ItemsL,BOn,BOn);

  {$ELSE}

    Currency.Visible:=BOff;
    NCurrLab.Visible:=BOff;
    TxLateChk.Visible:=BOff;

  {$ENDIF}

  Add2.Visible:=ChkAllowed_In(21) and (ICEDFM<>2) ;
  Add1.Visible:=Add2.Visible;
  Edit1.Visible:=ChkAllowed_In(22);
  Delete1.Visible:=ChkAllowed_In(23);

  DeleteAll1.Visible:=SBSIn;

  MoveAskList:=BOff;
  UseMoveList:=BOff;
  MoveGLList:=Nil;


  {$IFDEF SOP}

    Commitment1.Visible:=CommitAct;

  {$ELSE}
    Commitment1.Visible:=BOff;

  {$ENDIF}

  With Syss do
    NCC1.Visible:=(UseCCDep and PostCCNom);

  NDp1.Visible:=NCC1.Visible;

  Filter1.Visible:=(NCC1.Visible) or (Commitment1.Visible);

  {$IFDEF LTE}
    CCDepView1.Visible:=BOff;
    ObjectClone1.Visible:=BOff;
    NomSplitBtn.Visible:=BOff;

  {$ELSE}
    CCDepView1.Visible:=NCC1.Visible;

  {$ENDIF}



  Set_DefaultPr(Period.Items);

  Period.ItemIndex:=Pred(GetLocalPr(0).CPr);


  ToPeriod.Visible:=BOn;

  Set_DefaultPr(ToPeriod.Items);

  ToPeriod.ItemIndex:=Pred(GetLocalPr(0).CPr);

  Set_DefaultYr(Year.Items,GetLocalPr(0).CYr);

  Year.ItemIndex:=10;

  MoveMode:=BOff;
  MoveItem:=-1;
  MoveToItem:=-1;
  MoveInsMode:=TSBSAttachMode(0);
  MoveItemParent:=-1;

  {$IFDEF LTE}
    Move1.Visible:=BOff; 

  {$ELSE}

    Move1.Visible:=ChkAllowed_In(198);

  {$ENDIF}

  MoveList1.Visible:=Move1.Visible;

  N4.Visible:=Move1.Visible;

  Check1.Visible:=(SBSIn or Debug);

  TBDiff:=0.0;

  PostLock:=BOff;

  If (Not Move1.Visible) then
  Begin
    Move1.ShortCut:=0;
    Move2.ShortCut:=0;
  end;

  Move2.Visible:=BOff;
  FiltNType:=BOff;
  ShowGLCode:=BOff;

  Currency.ItemIndex:=0;

  If (Owner is TNomView) then
  With TNomView(Owner) do
  Begin
    Self.Left:=Left+20;
    Self.Top:=Top+20;
    Self.Width:=Width;
    Self.Height:=Height;
    Self.NPr:=NPr;

    Self.NPrTo:=NPrTo;

    Self.NYr:=NYr;
    Self.NCr:=NCr;
    Self.NTxCr:=NTxCr;

    Self.Period.ItemIndex:=Period.ItemIndex;

    Self.ToPeriod.ItemIndex:=ToPeriod.ItemIndex;

    Self.Year.ItemIndex:=Year.ItemIndex;
    Self.TxLateChk.Checked:=TxLateChk.Checked;

    Self.Currency.ItemIndex:=Currency.ItemIndex;
    
    Self.CCNomMode:=CCNomMode;
    Self.CCNomFilt:=CCNomFilt;


    Self.CommitMode:=CommitMode;

    Self.NLOLine.Assign(NLOLine);

    StoreCoord:=BOff;

    Self.StoreCoordFlg.Enabled:=BOff;

    Self.N4.Visible:=BOff;
    Self.N5.Visible:=BOff;
    Self.Move1.Visible:=BOff;
    Self.Move2.Visible:=BOff;
    Self.CanlMove1.Visible:=BOff;
    IAmChild:=BOn;

    {$B-}
    Self.ObjectClone2.Visible:=(Assigned(Self.Owner.Owner)) and (TNomView(Self.Owner).Owner is TNomView);
    {$B+}

    If (Self.ObjectClone2.Visible) then
    Begin
      Self.ParentNom:=TNomView(Self.Owner);
      Self.GrandPNom:=TNomView(Self.Owner.Owner);
    end;

  end
  else
  Begin
    PostLock:=Being_Posted(0);

    IAmChild:=BOff;
    Add_OutLines(0,2,0,0,NomF,NomCatK);

    NPr:=Succ(Period.ItemIndex);

    NPrTo:=Succ(ToPeriod.ItemIndex);

    NYr:=TxlateYrVal(StrToInt(Year.Text),BOn);

    {$IFDEF MC_On}
      NCr:=Currency.ItemIndex;
    {$ELSE}
      NCr:=0;
    {$ENDIF}

    Show_TBDiff(2*Ord(PostLock));

  end;


  InCCDepView:=BOff;
  InCCDepVLink:=BOff;

  CreateCaption;

  GotCoord:=BOn;

  NomActive:=BOff;
  NomRecForm:=nil;

  //TW
          if(UProfile.ShowGLCodes) then
     ShowG1Click(nil);

  FormReSize(Self);
end;

Function TNomView.Get_PWDefaults(PLogin  :  Str10)  :  tPassDefType;
Const
  Fnum     =  MLocF;
  Keypath  =  MLK;
Var
  Mbret  :  Word;
  KeyS, KeyChk :  Str255;
  B_Func :  Integer;
  LOk, LLocked : Boolean;
Begin
  Blank(Result,Sizeof(Result));
  KeyChk:=FullPWordKey(PassUCode,'D',PLogin);
  KeyS:=KeyChk;

  Begin
    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (StatusOk) then
    Begin
      Result:=MLocCtrl^.PassDefRec;
      {$IFDEF LTE}
        Result.PWExpMode:=0;
      {$ENDIF}
    end;
    Result.Loaded:=StatusOk;
  end; {With..}
end;

procedure TNomview.FormResize(Sender: TObject);
var
  KeyPath : Integer;
  RecAddress : longint;
  NeedToRestorePosition : Boolean;
begin
  If (GotCoord) then
  Begin
    GotCoord:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    NLOLine.Width:=ClientWidth-5;
    NLOLine.Height:=ClientHeight-99;
    NLDPanel.Width:=Width-Lab1Ofset;
    NLCrPanel.Left:=Width-Lab2Ofset;
    NLDrPanel.Left:=Width-Lab3Ofset;

    {Panel4.Top:=Height-Lab4Ofset;
    Panel5.Top:=Height-Lab4Ofset;

    ClsI1Btn.Top:=Height-Lab4Ofset;}

    ColXAry[1]:=NLDrPanel.Width+NLDrPanel.Left-4;
    ColXAry[2]:=NLCrPanel.Width+NLCrPanel.Left-4;

    ChrWidth:=Round(Width*ChrsXRoss);

    NLOLine.HideText:=(Width<=383);

   {$IFDEF XDBD}

    If (Debug) then
    Begin
      DebugForm.Add('Width'+inttoStr(Width));

    end;

   {$ENDIF}

    //SBSPanel1.Top:=NLOline.Top+NLOline.Height;

    //PR 19/08/2008 Amended to restore original position in Nominal file after reloading the data
    NeedToRestorePosition := Nom.NomCode <> 0;
    if NeedToRestorePosition then
    begin
      KeyPath := GetPosKey;
      Presrv_BTPos(NomF, KeyPath, F[NomF], RecAddress, False, False);
    end;

    Update_OutLines(NomF,NomCodeK);

    if NeedToRestorePosition then
      Presrv_BTPos(NomF, KeyPath, F[NomF], RecAddress, True, True);

    GotCoord:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end;


end;

procedure TNomview.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  {$IFNDEF LTE}
    If (NLOLine.SelectedItem>0) and (Key=VK_Delete)  and (Delete1.Enabled) then
    Begin
      GetSelRec;

      If Ok2DelNom(0,Nom) then
        Display_Account(3,BOn);

    end;
  {$ENDIF}  
end;

procedure TNomview.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TNomView.Display_History(ONomCtrl     :  OutNomType;
                                   ChangeFocus,
                                   ShowGraph    :  Boolean);

Var
  NomNHCtrl  :  TNHCtrlRec;

  FoundLong  :  Longint;

  fPr,fYr    :  Byte;

Begin
  With NomNHCtrl,ONomCtrl do
  Begin
    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    NHMode:=1;
    NBMode:=11;

    NHCr:=NCr;
    NHTxCr:=NTxCr;
    NHPr:=NPr;
    NHYr:=NYr;
    NHNomCode:=OutNomCode;


    NHCDCode:=CCNomFilt[CCNomMode];
    NHCCMode:=CCNomMode;

    NHCCode:=CalcCCKeyHistP(NHNomCode,CCNomMode,NHCDCode);

    {$IFDEF SOP}
      NHCommitView:=CommitMode;

    {$ENDIF}

    {NHCCode:=FullNomKey(NHNomCode);}


    If (Nom.NomCode<>NHNomCode) then
      GetNom(Self,Form_Int(NHNomCode,0),FoundLong,-1);

    NHKeyLen:=NHCodeLen+2;


    With Nom do
    Begin
      Find_FirstHist(NomType,NomNHCtrl,fPr,fYr);
      MainK:=FullNHistKey(NomType,NHCCode,NCr,fYr,fPr);
      AltMainK:=FullNHistKey(NomType,NHCCode,NCr,0,0);
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


end;


procedure TNomView.Display_Recon(Opt          :  Byte;
                                 ONomCtrl     :  OutNomType;
                                 ChangeFocus  :  Boolean);

Var
  NomNHCtrl  :  TNHCtrlRec;

  FoundLong  :  Longint;

  fPr,fYr    :  Byte;

  WasFromHist,
  NeedGExt   :  Boolean;

Begin
  With NomNHCtrl,ONomCtrl do
  Begin
    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    WasFromHist:=(Opt=15) and (InHist);

    NHCCDDMode:=(Opt=16);

    If (NHCCDDMode) then {* Adjust for CC/Dep Filt DD *}
      Opt:=15;

    NHMode:=Opt;

    NHCr:=NCr;
    NHTxCr:=NTxCr;

    NHPr:=NPr;

    NHYr:=NYr;

    NHNomCode:=OutNomCode;
    NHCommitView:=CommitMode;

    If (WasFromHist) then {Take CC/Dep code from whatever history is set to}
    With HistForm do
    Begin
      try
        NHCDCode:=NHCtrl.NHCDCode;
        NHCCMode:=NHCtrl.NHCCMode;
        NHCCDDMode:=NHCtrl.NHCCDDMode;
      except
        On exception do;
      end; {try..}
    end
    else
    Begin
      NHCDCode:=CCNomFilt[CCNomMode];
      NHCCMode:=CCNomMode;
    end;


    If (Nom.NomCode<>NHNomCode) then
      GetNom(Self,Form_Int(NHNomCode,0),FoundLong,-1);


    NeedGExt:=(NHMode=15);

    If (NeedGExt) and (Not NHCCDDMode) then
    With ExLocal do
    Begin
      NHPr:=LNHist.Pr;

      NHYr:=LNHist.Yr;

      NHYTDMode:=(NHPr=YTD);

      NHSDDFilt:=BOn;
    end;

    NHKeyLen:=Succ(Sizeof(Nom.NomCode));  {* NomCode+NomMode *}

    {$IFDEF MC_On}

      If (NHCr<>0) then
      Begin

        Inc(NHKeyLen);  { Include Currency }

        If (NHMode=15) then
        Begin
          NHKeyLen:=NHKeyLen+2; {Include Period & Year}

          If (NHPr In [YTD,YTDNCF]) then   {* Searching by year only *}
          Begin

            Dec(NHKeyLen);

          end;

        end;

        NeedGExt:=Not EmptyKeyS(NHCDCode,ccKeyLen,BOff);
      end;

    {$ELSE}

      Begin

        If (NHMode=15) then
        Begin
          NHKeyLen:=NHKeyLen+3; {Include Currency, Period & Year}

          If (NHPr In [YTD,YTDNCF]) then   {* Searching by year only *}
          Begin
            Dec(NHKeyLen);

          end;

        end;

        {$IFDEF PF_On}
          NeedGExt:=Not EmptyKeyS(NHCDCode,ccKeyLen,BOff);
        {$ELSE}
          NeedGExt:=BOff;
        {$ENDIF}

      end;

    {$ENDIF}


    NHNeedGExt:=NeedGExt;

    With Nom do
    Begin
      If (NHMode=15) and (Not NHCCDDMode) then
      Begin
        {$IFDEF MC_On}

          If (NHCr=0) then
            MainK:=FullIdPostKey(NHNomCode,0,0,NHCr,0,0)
          else
          Begin
            If (NHPr In [YTD,YTDNCF]) then {* Prime key at start of list *}
              NHPr:=1;

            MainK:=FullIdPostKey(NHNomCode,0,0,NHCr,NHYr,NHPr);
          end;

        {$ELSE}

            If (NHPr In [YTD,YTDNCF]) then
              NHPr:=1;

            MainK:=FullIdPostKey(NHNomCode,0,0,NHCr,NHYr,NHPr);

        {$ENDIF}
      end
      else
        MainK:=FullIdPostKey(NomCode,0,0,NHCr,0,0);
    end;


    Set_DDFormMode(NomNHCtrl);

  end;

  If (Not InRecon) then
  Begin


    ReconForm:=TReconList.Create(Self);

  end;

  Try

   InRecon:=BOn;

   With ReconForm do
   Begin

     WindowState:=wsNormal;

     If (ChangeFocus) then
       Show;

     ShowLink(BOn);

   end; {With..}


  except

   InRecon:=BOff;

   ReconForm.Free;
   ReconForm:=nil;

  end; {try..}


end;


procedure TNomView.Display_CCDepView(ONomCtrl     :  OutNomType;
                                     ChangeFocus  :  Boolean);

Var
  NomNHCtrl  :  TNHCtrlRec;

  FoundLong  :  Longint;

  fPr,fYr    :  Byte;

Begin
  With NomNHCtrl,ONomCtrl do
  Begin
    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);


    NHCr:=NCr;
    NHTxCr:=NTxCr;
    NHPr:=NPr;
    NHPrTo:=NPrTo;

    NHYr:=NYr;
    NHNomCode:=OutNomCode;

    NHCDCode:=CCNomFilt[CCNomMode];
    NHCCMode:=CCNomMode;

    NHCCode:=CalcCCKeyHistP(NHNomCode,CCNomMode,NHCDCode);

    {$IFDEF SOP}
      NHCommitView:=CommitMode;

    {$ENDIF}

    {NHCCode:=FullNomKey(NHNomCode);}


    If (Nom.NomCode<>NHNomCode) then
      GetNom(Self,Form_Int(NHNomCode,0),FoundLong,-1);


  end;

  If (Not InCCDepView) then
  Begin


    CCDepView:=TCCDepView.Create(Self);

  end;

  Try

   InCCDepView:=BOn;

   With CCDepView do
   Begin

     WindowState:=wsNormal;

     CCDepNHCtrl:=NomNHCtrl;
     CCNom:=Nom;
     UseYTD:=Self.UseYTD;

     TotalBal:=ONomCtrl.StkCost;

     If (ChangeFocus) then
       Show;

     Show_Link;



   end; {With..}


  except

   InCCDepView:=BOff;

   CCDepView.Free;
   CCDepView:=nil;

  end; {try..}


end;



procedure TNomview.NLOLineExpand(Sender: TObject; Index: Longint);
Var
  Depth   :  LongInt;
  ONomRec :  ^OutNomType;

begin
  With (Sender as TSBSOutLineB) do
  Begin
    Depth:=Pred(Items[Index].Level);

    ONomRec:=Items[Index].Data;

    If (ONomRec<>nil) then
    With ONomRec^ do
    Begin
      If (BeenDepth<Depth+2) then
      Begin
        BeenDepth:=Depth+2;
        {BeginUpdate;}
        Drill_OutLines(Depth,Depth+2,Index);
        {EndUpdate;}
      end;
    end;

  end; {With..}

  If (InChild) then
    ChildNom.NLOLine.ExpandxNCode(NLOLine.Items[Index].Data,BOn);

  ReconBtnClick(Sender);

end;

procedure TNomview.NLOLineCollapse(Sender: TObject; Index: Longint);
begin
  If (InChild) then
    ChildNom.NLOLine.ExpandxNCode(NLOLine.Items[Index].Data,BOff);
end;


Procedure TNomview.LinkList(NC  :  LongInt);

Begin
  lblGLCode.Caption := 'GL Code : ' + IntToStr(NC);
end;

procedure TNomview.NLOLineNeedValue(Sender: TObject);

Var
  ONomRec      :  ^OutNomType;
  DrawIdxCode  :  LongInt;
  Profit,
  Sales,
  Purch,
  CommitValue,
  Cleared      :  Double;

  Loop       :  Boolean;
  StoreD     :  Double;
  CalcNom    :  TNomView;



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
          LinkList(OutNomCode);

        If (LastPr<>NPr) or (LastPrTo<>NPrTo) or (LastYr<>NYr) or (LastCr<>NCr) or (LastYTD<>UseYTD)
          or (LastTxCr<>NTxCr) or (LastCCFilt[CCNomMode]<>CCNomFilt[CCNomMode])
          or (LastHValue<>HideValue) or (LastCommitMode<>CommitMode)
          then
        Begin


           Loop:=BOff;  StoreD:=0.0;

           If (ObjectClone2.Checked) then
              CalcNom:=GrandPNom
            else
              CalcNom:=Self;

            Repeat
              With CalcNom do
              Begin
                Profit:=0.0; CommitValue:=0.0;

            {$IFDEF SOP}

                If (CommitMode In [0,1]) then
                  Profit:=Profit_to_DateRange(OutNomType,CalcCCKeyHistP(OutNomCode,CCNomMode,CCNomFilt[CCNomMode]),
                                       NCr,NYr,NPr,NPrTo,Purch,Sales,Cleared,UseYTD);

                If (CommitMode In [1,2]) then
                  CommitValue:=Profit_to_DateRange(OutNomType,CommitKey+CalcCCKeyHistP(OutNomCode,CCNomMode,CCNomFilt[CCNomMode]),
                                       NCr,NYr,NPr,NPrTo,Purch,Sales,Cleared,UseYTD);

                Profit:=Profit+CommitValue;

            {$ELSE}
                Profit:=Profit_to_DateRange(OutNomType,CalcCCKeyHistP(OutNomCode,CCNomMode,CCNomFilt[CCNomMode]),
                                       NCr,NYr,NPr,NPrTo,Purch,Sales,Cleared,UseYTD);
            {$ENDIF}

               end;

               Loop:=Not Loop;

               If (Self.ObjectClone2.Checked) then
               Begin
                 If (Loop) then
                 Begin
                   CalcNom:=ParentNom;
                   StoreD:=Profit;
                 end;
                 {else
                   Profit:=Round_Up(StoreD-Profit,2);}
               end;

            Until (Not Loop) or (Not Self.ObjectClone2.Checked);

            Blank(LastDrCr,Sizeof(LastDrCr));

            If (Self.ObjectClone2.Checked) then
            Begin
              LastDrCr[2]:=Round_Up(StoreD-Profit,2);
              LastDrCr[1]:=Calc_Pcnt(StoreD,LastDrCr[2]);

            end
            else
            Begin
              StkCost:=Currency_Txlate(Profit,NCr,NTxCr);

              LastDrCr[1+Ord(Profit>0)]:=ABS(StkCost);

            end;



          ColValue:=0;



          LastPr:=NPr;

          LastPrTo:=NPrTo;

          LastYr:=NYr;
          LastCr:=NCr;
          LastTxCr:=NTxCr;
          LastYTD:=UseYTD;
          LastHValue:=HideValue;
          LastCCFilt:=CCNomFilt;
          LastCommitMode:=COmmitMode;


        end; {If settings changed..}

        With Items[DrawIdxCode] do
          If (Not HideValue) then
          Begin
            If ((Not Expanded) or (Not HasItems)) then
              ColValue:=LastDrCr[SetCol];
          end
          else
            ColValue:=0.0;

          If (SetCol=1) and (Self.ObjectClone2.Checked) then
            ColFmt:=GenPcntMask
          else
            ColFmt:=GenRealMask;


          ColsX:=ColXAry[SetCol];
        If (DrawIdxCode=SelectedItem) and (InCCDepView) then
            PostMessage(Self.Handle,WM_CustGetRec,30,0);

      end;
    end; {If found equiv index..}
  end;
end;


procedure TNomview.NLOLineUpdateNode(Sender: TObject;
  var Node: TSBSOutLNode; Row: Integer);
var
  ONomRec      :  ^OutNomType;

begin
  With Node do
  Begin
    ONomRec:=Data;

    If (ONomRec<>nil) then
    With ONomRec^ do
    Begin
      If (Not HasItems) then
      Begin
        Case OutNomType of
          BankNHCode   :  UseLeafX:=obLeaf2;
          CtrlNHCode   :  UseLeafX:=obLeaf3;
          CarryFlg     :  UseLeafX:=obLeaf4;
          else            UseLeafX:=obLeaf;
        end; {Case..}

        If HedTotal then
          UseLeafX:=obMinus;
      end;
    end;

  end;

end;



procedure TNomview.CurrencyClick(Sender: TObject);
begin
  NPr:=Succ(Period.ItemIndex);

  NPrTo:=Succ(ToPeriod.ItemIndex);

  NYr:=TxLateYrVal(StrToInt(Year.Text),BOn);

  {$IFDEF MC_On}
    If (TxLateChk.Checked) then
      NTxCr:=Currency.ItemIndex
    else
      NCr:=Currency.ItemIndex;
  {$ENDIF}

  CreateCaption;

  NLOLine.Refresh;

  lblTBDiff.Visible:=BOff;

  If (Sender<>nil) then
  Begin
    RefreshHist:=InHist;

    If (RefreshHist) then
      HistBtnClick(nil);

    RefreshRecon:=InRecon;

    If (RefreshRecon) then
      ReconBtnClick(nil);

    RefreshCCDepView:=InCCDepView;

    If RefreshCCDepView then
      CCDepView1Click(Nil);
  end;

  NLChildForceReDraw;

end;


procedure TNomview.FullExBtnClick(Sender: TObject);
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


Procedure TNomView.SuperDDCtrl(Mode  :  Byte);


Begin

  With NLOLine,EXlocal do
  Begin
    If (Items[SelectedItem].HasItems) then
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

        CurrencyClick(HistForm);

        InHCallBack:=BOff;
        InHBeen:=BOn;
      end;
    end
    else
    Begin
      RefreshRecon:=BOn;

      If (InHist) and (InRecon) or (Mode=0) then
        ReconBtnClick(HistForm);
    end;

  end


end;

procedure TNomView.GetSelRec;


Var
  ONomRec   :  ^OutNomType;
  FoundOk   :  Boolean;
  FoundLong :  LongInt;


begin
  With NLOLine do
  Begin
    If (SelectedItem>0) then
    Begin
      ONomRec:=Items[SelectedItem].Data;

      With ONomRec^ do
        If (Nom.NomCode<>OutNomCode) then
          FoundOk:=GetNom(Self,Form_Int(OutNomCode,0),FoundLong,-1);
    end;
  end; {With..}
end;

procedure TNomView.Display_Account(Mode             :  Byte;
                                   ChangeFocus      :  Boolean);

Var
  ONomRec    :  ^OutNomType;

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


  If (NomRecForm=nil) then
  Begin

    NomRecForm:=TNomRec.Create(Self);

  end;

  Try

   NomActive:=BOn;

   With NomRecForm do
   Begin

     WindowState:=wsNormal;

     If (Mode In [1..10]) and (ChangeFocus) then
       Show;


     If (Mode In [1..3]) and (Not ExLocal.InAddEdit) then
     Begin

       If (Mode=3) then
       Begin
         DeleteNomLine(NomF,NomCatK);
       end
       else
       Begin
         If (Mode=1) then {* Set Parent *}
         Begin
           {$B-}

           With NLOLine do
             If (SelectedItem>0) and (ThisNode.Parent.Index>0) then
               Level_Code:=OutNomType(ThisNode.Parent.Data^).OutNomCode
             else
               Level_Code:=0;
           {$B+}
         end;
         EditLine(Nom,(Mode=2));

       end;
     end;



   end; {With..}


  except

   NomActive:=BOff;

   NomRecForm.Free;

  end;


end;


Procedure TNomView.AddEditLine(Edit  :  Boolean);

Var
  Depth,
  OIndex,
  NewIdx   :  Integer;
  PNode    :  TSBSOutLNode;
  NewFolio :  LongInt;
  ONomRec  :  ^OutNomType;

Begin

  With NLOLine,Nom do
  If (Not Edit) then
  Begin
    NewFolio:=NomCode;

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

      Add_OutLines(0,2,0,0,NomF,NomCatK)

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



    OIndex:=FindNode(Integer(NewFolio));

    If (OIndex<>-1) then
      SelectedItem:=OIndex;


  end
  else
  Begin
    ONomRec:=Items[SelectedItem].Data;
    Items[SelectedItem].Text:=FormatLine(ONomRec^,Desc);
    ONomRec^.OutNomCode:=NomCode;
    ONomRec^.OutNomType:=NomType;

    PNode:=Items[SelectedItem];
    OIndex:=SelectedItem;

    Delete_OutLines(OIndex,BOff);

    Depth:=Pred(PNode.Level);

    Drill_OutLines(Depth,Depth+2,OIndex);
  end;

end;


Procedure TNomView.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      40 :  InChild:=BOff;

      41 :  Begin
              InHist:=BOff;

              If (InCCDepView) then
              Begin
                CCDepView.InHist:=BOff;
                CCDepView.InGraph:=BOff;
              end;
            end;

      42 :  Begin
              InRecon:=BOff;

              If (InCCDepView) then
              Begin
                CCDepView.InRecon:=BOff;
              end;
            end;

      43 :  Begin
              InCCDepView:=BOff;
              CCDepView:=nil;
            end;
      44..46
         :  Show_CCDepViewHistory((WParam=45),Ord(WParam=46));


      52,53
         :  Begin
              ExLocal.AssignFromGlobal(NHistF);

              SuperDDCtrl(WParam-52)
            end;

      62
         :  Begin
              ExLocal.AssignFromGlobal(NomF);
              ExLocal.AssignFromGlobal(NHistF);
              PlaceNomCode(ExLocal.LNom.NomCode);
              SuperDDCtrl(0);
            end;

            {* A move is being recovered close form... *}
      71 :  SendMessage(Self.Handle,WM_Close,0,0);

      {$IFDEF POST}
        70,72
         :  {RefreshMove;} {* This has been disabled since it could be very confusing to have things collapse etc whilst you were still moving about. *}
             Update_Total4Thread(LParam,(WParam=70));

         73  :  Begin
                  ReStartView;

                end;
      {$ENDIF}

      277  :  MoveGLList:=nil;

    end; {Case..}

  end;
  Inherited;
end;

Procedure TNomView.WMCustGetRec(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of
       25  :  NeedCUpdate:=BOn;

       30  :  CCDepView1Click(Nil);

      100  : If (NomActive) then
             Begin
               NomRecForm.ExLocal.AssignToGlobal(NomF);
               AddEditLine((LParam=1));
             end;


      169  : With NLOLine do
               Items[SelectedItem].Expand;

      200,300
         :  Begin
              NomActive:=BOff;
              NomRecForm:=nil;

              If (WParam=300) then
              With NLOLine do
                If (SelectedItem>=0) then
                  Delete_OutLines(SelectedItem,BOn);
            end;

    end; {Case..}

  end;
  Inherited;
end;


Procedure TNomView.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TNomView.Send_UpdateList(Mode   :  Integer);

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
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}



procedure TNomview.ClsI1BtnClick(Sender: TObject);
begin
  Close;
end;

procedure TNomview.NomSplitBtnClick(Sender: TObject);
begin
  If (Not InChild) then
  Begin
    ChildNom:=TNomView.Create(Self);
    InChild:=BOn;
  end;

  try
    With ChildNom do
    Begin
      WindowSettings := Self.FSettings;
      Show;
    end;

  except

    InChild:=BOff;
    ChildNom:=nil;

  end; {try..}

end;


procedure TNomView.NLChildForceReDraw;

Var
  GrandChild  :  TNomView;

Begin
  {$B-}

  If (InChild) then
  Begin
    GrandChild:=ChildNom;

    If (ChildNom.InChild) and (Not ChildNom.ObjectClone2.Checked) then
      GrandChild:=ChildNom.ChildNom;
  end;

  If (InChild) and (GrandChild.ObjectClone2.Checked) then
  {$B+}
  With GrandChild do
  Begin
    CreateDiffCaption;

    UseYTD:=Not UseYTD;

    NLOLine.Refresh;
  end;

end;

procedure TNomView.NLChildUpdate;

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

procedure TNomview.NLOLineDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);


begin
  If (InHist) then
    HistBtnClick(nil);

  If (InRecon) then
    ReconBtnClick(nil);
  
  NLChildUpDate;

end;

procedure TNomview.YTDChkClick(Sender: TObject);
begin
  UseYTD:=YTDChk.Checked;

  ToPeriod.Enabled:=Not UseYTD;

  NLChildForceReDraw;

  NLOLine.Refresh;
end;

procedure TNomview.PopupMenu1Popup(Sender: TObject);

Var
  ONomRec  :  ^OutNomType;

begin
  StoreCoordFlg.Checked:=StoreCoord;
  ShowC1.Checked:=Not FiltCarryF;

  SendMessage(Application.MainForm.Handle,WM_FormCloseMsg,250,0);

  GetSelRec;

  Delete1.Enabled:=Ok2DelNom(0,Nom) and (ICEDFM=0);

  {$IFDEF LTE}
    {$B-}

    If (Delete1.Enabled) then
      With NLOLine do
        Delete1.Enabled:=(SelectedItem>0) and ((Items[SelectedItem].Parent.Index>0) or (Nom.NomType<>NomHedCode));
    {$B+}
  {$ENDIF}


  With NLOLine do
    If (SelectedItem>0) then
    Begin
      ONomRec:=Items[SelectedItem].Data;

      With Delete1 do
        Enabled:=(Enabled and Not ONomRec^.HedTotal);
    end;


  N3.Tag:=Ord(ActiveControl Is TSBSOutLineB);
end;



procedure TNomView.SetFieldProperties;

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
        {CheckColor:=Period.Color;}
      end;

  end; {Loop..}


end;

(*** MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
procedure TNomView.SetFormProperties(SetList  :  Boolean);

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
          With NLOLine do
          Begin
            Font.Assign(TmpPanel[1].Font);
            Color:=TmpPanel[1].Color;

            NLDPanel.Font.Assign(TmpPanel[2].Font);
            NLDPanel.Color:=TmpPanel[2].Color;


            BarColor:=TmpPanel[3].Color;
            BarTextColor:=TmpPanel[3].Font.Color;

            NLCrPanel.Font.Assign(TmpPanel[2].Font);
            NLCrPanel.Color:=TmpPanel[2].Color;

            NLDrPanel.Font.Assign(TmpPanel[2].Font);
            NLDrPanel.Color:=TmpPanel[2].Color;
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

end;  ***)


procedure TNomview.PropFlgClick(Sender: TObject);
begin
//  SetFormProperties(N3.Tag=1);
//  N3.Tag:=0;

  // MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
  // CA 23/07/2012 v7.0 ABSEXCH-13189: Dealt with TreeColor
  if Assigned(FSettings) then
    if FSettings.Edit(pnlAll, NLOLine) = mrOK then //PR: 05/08/2008 ABSEXCH-11428
    Begin
      NLOLine.TreeColor   := NLOLine.Font.Color;
      NeedCUpdate := True;
    End;
end;


procedure TNomview.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;



procedure TNomview.NLOLineMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

begin

  NLChildUpDate;

end;


procedure TNomview.TxLateChkClick(Sender: TObject);
begin
  If (TxLateChk.Checked) then
    Currency.ItemIndex:=NTxCr
  else
    Currency.ItemIndex:=NCr;
end;


procedure TNomview.HistBtnClick(Sender: TObject);

Var
  ONomRec  :  OutNomType;
  DispRec  :  Boolean;

begin
  DispRec:=BOff;

  With NLOLine do
  Begin
    ONomRec:=OutNomType(Items[SelectedItem].Data^);

    If (InHist) then
      DispRec:=((HistForm.NHCtrl.NHNomCode<>ONOmRec.OutNomCode) or (Sender<>nil) or (RefreshHist));


    If ((Not InHist) or (DispRec)) and (Not InHCallBack) and (ONomRec.OutNomType<>CarryFlg) then
      Display_History(ONomRec,(Sender<>nil),((Sender=GraphBtn) or (Sender=Graph1)));

    ReFreshHist:=BOff;
  end;
end;


procedure TNomview.CCDepView1Click(Sender: TObject);
Var
  ONomRec  :  OutNomType;
  DispRec  :  Boolean;

begin
  DispRec:=BOff;
  With NLOLine do
  Begin
    ONomRec:=OutNomType(Items[SelectedItem].Data^);

    If (InCCDepView) then
      DispRec:=((CCDepView.CCDepNHCtrl.NHNomCode<>ONOmRec.OutNomCode) or (Sender<>nil) or (RefreshCCDepView));


    If ((Not InCCDepView) or (DispRec)) and (ONomRec.OutNomType<>CarryFlg) then
      Display_CCDepView(ONomRec,(Sender<>nil));

    RefreshCCDepView:=BOff;
  end;
end;


procedure TNomview.MIEALClick(Sender: TObject);

Var
  RT  :  Integer;

begin
  If (Sender is TMenuItem) then
  With NLOLine do
  Begin
    RT:=TMenuItem(Sender).Tag;

    If (RT <>0) then
      StopDD:=BOn;

    Case RT of
      1  :  Items[SelectedItem].Expand;
      2  :  Items[SelectedItem].FullExpand;
      3  :  FullExpand;
      4  :  Items[SelectedItem].Collapse;
      5  :  FullCollapse;
    end; {case..}

    StopDD:=BOff;
  end;
end;

procedure TNomview.YearKeyPress(Sender: TObject; var Key: Char);
begin
  If (Not (Key In ['0'..'9',#8,#13])) and (Not GetLocalPr(0).DispPrAsMonths) then
    Key:=#0;
end;

procedure TNomview.PeriodExit(Sender: TObject);
begin
  If (Sender is TSBSComboBox) then
    With TSBSComboBox(Sender) do
    Begin
      If (Sender=Period) or (Sender=ToPeriod) or (Sender=Year) then
      Begin
        If (IntStr(Text)=0) and (Not GetLocalPr(0).DispPrAsMonths) then
        Begin
          ItemIndeX:=0;
          Text:=Items.Strings[0];
        end;

      end;

      If (Sender=Period) or (Sender=ToPeriod) then
        Text:=SetPadNo(Text,2);

      If (Sender<>Currency) then {* Validate does this job already *}
        ItemIndex:=Set_TSIndex(Items,ItemIndex,Text);

      If (Sender=Period) then
      Begin
        If (ItemIndex>ToPeriod.ItemIndex) then
          ToPeriod.ItemIndex:=ItemIndex;
      end
      else
        If (Sender=ToPeriod) then
        Begin
          If (ItemIndex<Period.ItemIndex) then
            Period.ItemIndex:=ItemIndex;
        end;

      CurrencyClick(Sender);
    end;
end;

{ ======= Function to find the note a nominal code resides at ======= }

function TNomView.FindNode(NCode  :  LongInt)  :  Integer;

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


Procedure TNomView.PlaceNomCode(FindCode  :  LongInt);

Const
  Fnum     =  NomF;
  Keypath  =  NomCodeK;

Var
  FoundOk    :  Boolean;
  KeyS       :  Str255;
  n          :  Integer;
  FoundLong  :  LongInt;

Begin

  FoundOk:=(Nom.NomCode=FindCode);

  If (Not FoundOk) then
  Begin
    KeyS:=Form_Int(FindCode,0);
    FoundOk:=GetNom(Owner,KeyS,FoundLong,-1);
  end;

  If (FoundOk) then
  Begin
    KeyS:=FullNomKey(Nom.Cat);

    If (Nom.Cat<>0) then
      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (Nom.Cat<>0) do {* Get to top of this branch *}
    Begin
      KeyS:=FullNomKey(Nom.Cat);

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    end;

    n:=FindNode(Nom.NomCode);

    If (n<>-1) then
    With NLOLine do
    Begin
      StopDD:=BOn;

      Items[n].FullExpand;

      n:=FindNode(Integer(FindCode));

      If (n<>-1) then
        SelectedItem:=n;

      StopDD:=BOff;
    end;

  end;

end;


Procedure TNomView.FindNomCode;

Const
  Fnum     =  NomF;
  Keypath  =  NomCodeK;

Var
  InpOk,
  FoundOk  :  Boolean;

  FoundLong
           :  LongInt;

  n,INCode :  Integer;

  SCode    :  String;

  KeyS     :  Str255;


Begin

  SCode:='';
  
  FoundOk:=BOff;

  Repeat

    InpOk:=InputQuery('Find General Ledger Code','Please enter the general ledger code you wish to find',SCode);

    If (InpOk) then
      FoundOk:=GetNom(Self,SCode,FoundLong,99);

  Until (FoundOk) or (Not InpOk);

  If (FoundOk) then
  Begin
    PlaceNomCode(FoundLong);
  end;


end;


procedure TNomview.MIFindClick(Sender: TObject);
begin
  FindNomCode;
end;

procedure TNomview.ReconBtnClick(Sender: TObject);
Var
  ONomRec  :  OutNomType;
  DispRec  :  Boolean;
  RMode    :  Byte;

begin
  DispRec:=BOff;

  If (Sender=HistForm) and (Sender<>nil) then
    RMode:=15
  else
  Begin
    RMode:=3;

    IF (Not EmptyKeyS(CCNomFilt[CCNomMode],ccKeyLen,BOff)) then
      RMode:=16;
  end;

  With NLOLine do
  Begin
    ONomRec:=OutNomType(Items[SelectedItem].Data^);

    If (InRecon) and (Assigned(ReconForm)) then
    Begin
      DispRec:=(((ReconForm.DDCtrl.NHNomCode<>ONOmRec.OutNomCode) and (Not ONomRec.HedTotal)) or (Sender<>nil)
                 {or (RefreshRecon)});

    end;


    If ((Not InRecon) or (DispRec)) and (Not Items[SelectedItem].HasItems) and (Not InHCallBack) and (Not ONomRec.HedTotal) and
      (Not StopDD) and (ONomRec.OutNomType<>CarryFlg) then
      Display_Recon(RMode,ONomRec,((Sender<>nil) and (Sender<>HistForm)));

    ReFreshRecon:=BOff;
  end;
end;



procedure TNomview.OptBtnClick(Sender: TObject);
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

procedure TNomview.Edit1Click(Sender: TObject);
Var
  RB  :  Byte;

begin
  {$IFDEF DBD}

    If (Debug) then
    Begin
      DebugForm.Add('Help_ID'+inttoStr(TMEnuItem(Sender).HelpContext));
    end;

   {$ENDIF}

  If (Sender is TMenuItem) then
  Begin
    RB:=TMenuItem(Sender).Tag;

    If (NLOLine.SelectedItem>0) or (RB=1) then
      Display_Account(RB,BOn);

  end;
end;



Function TNomview.Check_TransForNom  :  Boolean;

Const
  Fnum     =  IDetailF;
  KeyPath  =  IdFolioK;

Var
  FoundOk  :  Boolean;
  KeyS     :  Str255;

Begin
  FoundOk:=BOff;

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  {* Mod so that Direct reciept lines do not get deleted on an invoice update *}

  While (Status=0) and (Not FoundOk) do
  With Id do
  Begin
    FoundOk:=(Id.NomCode<>0);

    If (Not FoundOk) then
      Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
  end;

  Result:=Not FoundOk;

end;



{ == Delete all Records == }

Procedure TNomview.DeleteAllNoms;

Var
  mbRet   :  Word;

Begin
  NLOLine.FullCollapse;

  OptBtn.Enabled:=BOff;

  LastCursor:=Cursor;

  If (Check_TransForNom) then
    mbRet:=MovCustomDlg(Application.MainForm,'WARNING','Clear G/L','Please confirm you wish to destroy all the G/L Codes.'+#13+#13+
                                        'This is a non recoverable destructive process.  To restore the G/L you will need to revert to a backup.' ,mtWarning,[mbYes,mbNo])
  else
    mbRet:=CustomDlg(Application.MainForm,'Deletion not possible','Clear G/L','It is not possible to destroy the G/L at this time as there are transaction lines using G/L Codes.',mtWarning,[mbCancel]);

  Try
    If (mbRet=mrOk) then
    Begin
      NLOLine.Enabled:=BOff;

      If (Check_TransForNom) then
      Begin
        Cursor:=crHourGlass;
        Application.ProcessMessages;

        DeleteLinks('',NomF,0,NomCodeK,BOff);


        With NLOLine do
        If (ItemCount>0) then
        Repeat

          Delete_OutLines(1,BOn);

        Until (ItemCount<=0);


        NLOline.Refresh;

        If (Assigned(ChildNom)) and (InChild) then
          ChildNom.RestartView;
      end;

    end;
  Finally
    NLOLine.Enabled:=BOn;
    OptBtn.Enabled:=BOn;
    Cursor:=LastCursor;
  end; {Try..}


end;

Procedure TNomview.RestartView;

Begin
  NLOLine.FullCollapse;

  OptBtn.Enabled:=BOff;

  LastCursor:=Cursor;

  NLOLine.Enabled:=BOff;

  Cursor:=crHourGlass;

  Try

    With NLOLine do
    If (ItemCount>0) then
    Repeat

      Delete_OutLines(1,BOn);

    Until (ItemCount<=0);

    Add_OutLines(0,2,0,0,NomF,NomCatK);

    NLOline.Refresh;

    If (Assigned(ChildNom)) and (InChild) then
      ChildNom.RestartView;

  finally
    NLOLine.Enabled:=BOn;
    OptBtn.Enabled:=BOn;
    Cursor:=LastCursor;
  end; {Try..}
end;



procedure TNomview.DeleteAll1Click(Sender: TObject);
begin
  DeleteAllNoms;
end;


procedure TNomview.ShowC1Click(Sender: TObject);
begin
  FiltCarryF:=Not FiltCarryF;

  NLOLine.SelectedItem:=1;
  AddEditLine(BOff);
end;

procedure TNomview.NCC1Click(Sender: TObject);
Var
  InpOk,
  FoundOk  :  Boolean;
  FoundStr :  Str20;

  ISCtrl         :  TEditCCDep;
  mrResult       :  TModalResult;

  OCode,
  SCode    :  String;

Begin

  SCode:=CCNomFilt[CCNomMode];
  OCode:=SCode;

  CCNomMode:=(Sender=NCC1);

  ISCtrl:=TEditCCDep.Create(Self);

  try

    With ISCtrl do
    Begin
      mrResult:=InitIS(CCNomFilt[CCNomMode],CCNomMode);

      If (mrResult=mrOk) then
      Begin
        CCNomFilt[CCNomMode]:=PAValue;
        SCode:=PAValue;
      end;
    end;

  finally

    ISCtrl.Free;

  end; {Try..}

  If (mrResult=mrOK) and (SCode<>OCode)  then
  Begin
    CurrencyClick(Sender);
  end;


end;




Function TNomview.Is_NodeParent(MIdx,SIdx  :  Integer)  :  Boolean;

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

Function TNomview.Place_InOrder(MIdx,SIdx  :  Integer;
                            Var UseAdd     :  Boolean)  :  Integer;

Var
  ONomRec    :  ^OutNomType;
  PIdx,TIdx  :  Integer;
  N,
  NNC        :  LongInt;
  FoundOk    :  Boolean;

Begin
  FoundOk:=BOff;  UseAdd:=BOff;

  Result:=SIdx;

  With NLOLine do
  Begin
    ONomRec:=Items[MIdx].Data;

    NNC:=ONomRec^.OutNomCode;

    PIdx:=Items[SIdx].Parent.Index;


    If (PIdx>0) then
    Begin
      TIdx:=Items[PIdx].GetFirstChild;

      While (TIdx>0) and (Not FoundOk) do
      Begin
        ONomRec:=Items[TIdx].Data;

        With ONomRec^ do
          FoundOk:=((OutNomCode>NNC) or (HedTotal));


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
            FoundOk:=(OutNomCode>NNC);

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
  Function TNomview.Confirm_Move(MIdx,SIdx  :  Integer)  :  Boolean;

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

        MoveMode:=1;

        With ONomRec^ do
        Begin
          MoveNCode:=OutNomCode;
          WasNCat:=OutNomCat;
          NewNType:=OutNomType;

          If (Global_GetMainRec(NomF,FullNomKey(MoveNCode))) then
          With Nom do
          Begin
            WasNCat:=Cat;
            MoveNom:=Nom;
          end;
        end;

        PIdx:=Items[SIdx].Parent.Index;

        If (PIdx>0) then
        Begin
          ONomRec:=Items[PIdx].Data;

          With ONomRec^ do
          Begin
            NewNCat:=OutNomCode;

            If (Global_GetMainRec(NomF,FullNomKey(OutNomCode))) then
            Begin
              GrpNom:=Nom
            end;
          end;
        end
        else
        With GrpNom do
        Begin
          Desc:='G/L Root';
        end;
        Set_BackThreadMVisible(BOn);

        WMsg:=ConCat('You are about to move ',dbFormatName(Form_Int(MoveNom.NomCode,0),MoveNom.Desc),' into ',
              dbFormatName(Form_Int(GrpNom.NomCode,0),GrpNom.Desc),#13,#13);

        If (Not UseMoveList) then
        Begin
          WMsg:=ConCat(WMsg,'The heading totals affected will be blanked out until the move is complete.',#13,#13);
          WMsg:=ConCat(WMsg,'This operation should be performed with all other users logged out.',#13,#13,'A backup ',
                'MUST be taken since the integrity of the G/L will be damaged should the move fail.',#13,#13,
                'Do you wish to continue?');
          mbRet:=MovCustomDlg(Application.MainForm,'WARNING','G/L Move',WMsg,mtWarning,[mbYes,mbNo]);

        end
        else
        Begin
          WMsg:=ConCat(WMsg,'This move instruction will be added to the list of moves and will need to be processed.',#13);
          mbRet:=CustomDlg(Application.MainForm,'Please Confirm','G/L Move',WMsg,mtConfirmation,[mbYes,mbNo]);

        end;


        Set_BackThreadMVisible(BOff);

        Result:=(mbRet=mrOk);

        If (Result) then
        Begin

          If (UseMoveList) then
          begin
            Result:=AddMove2List(MoveRec);
            //PR: 18/05/2017 ABSEXCH-18683 v2017 R1 Release process lock - it will be
            //                                      set again when list is processed
            if Assigned(Application.Mainform) then
               SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plMoveGLCode), 0);

          end
          else
            Result:=AddMove2Thread(Self,MoveRec);

          FNeedToReleaseProcessLock := False;
        end;

        {If (Result) then
          Update_TotalMove(FrmPIdx,ToPIdx,WasNCat,NewNCat,BOn);}

      end; {With..}
    finally
      Dispose(MoveRec);

     end;
  end;


  {procedure TNomview.RefreshMove; Version which was called from move thread, not used

  Var
    N,Depth,
    PIdx1,PIdx2  :  Integer;

    Loop         :  Boolean;

    PNode        :  TSBSOutLNode;


  Begin
    With NLOLine do
    Begin
      If (MoveItemParent>0) and (Items[MoveItemParent].Parent.Index>0) then
        PIdx1:=Items[MoveItemParent].TopItem
      else
        PIdx1:=MoveItemParent;

      If (Items[MoveToItem].Parent.Index>0) then
        PIdx2:=Items[MoveToItem].TopItem
      else
        PIdx2:=MoveToItem;

      Loop:=BOff;
      N:=PIdx1;
      Repeat
        If (N>0) then
        Begin
          PNode:=Items[n];

          PNode.Collapse;

          Delete_OutLines(n,BOff);

          Depth:=Pred(PNode.Level);

          Drill_OutLines(Depth,Depth+2,n);

          PNode.Expand;
        end;

        Loop:=Not Loop;

        N:=PIdx2;

      Until (Not Loop);
    end;

    SetChildMove;

    If (Assigned(ChildNom)) and (InChild) then
      ChildNom.RefreshMove;
  end;}


  procedure TNomview.RefreshMove(WhichNode  :  Integer);

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



Procedure TNomview.Alter_Total(Const PIdx1 :  Integer;
                               Const NC    :  LongInt;
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

      If (ONomRec^.OutNomCode=NC) or (PIdx<>PIdx1) then {* Still same nom code or down a level! *}
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

Procedure TNomview.HideAll_Totals(Const HideValues  :  Boolean);

Var
  ONomRec    :  ^OutNomType;
  NIdx,PIdx  :  Integer;
  FoundOk,
  AbortOn    :  Boolean;

Begin
  FoundOk:=BOff;  AbortOn:=BOff;

  With NLOLine do
  If (ItemCount>0) then
  Begin
    BeginUpdate;

    PIdx:=1; NIdx:=Pred(ItemCount);

    Repeat

      ONomRec:=Items[PIdx].Data;

      ONomRec^.HideValue:=HideValues;

      FoundOk:=BOff;

      Inc(PIdx)

    Until (PIdx>=NIdx) or (AbortOn);

    EndUpDate;
  end; {With..}

   If (Assigned(ChildNom)) and (InChild) then
    ChildNom.HideAll_Totals(HideValues);
end;

Function TNomview.FindXONC(Const NC1  :  LongInt)  :  Integer;

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

      If (ONomRec^.OutNomCode=NC1) then
      Begin
        Result:=n;
        Break;
      end;
    end;
  end;

end;

Procedure TNomview.Update_TotalMove(Const NC1,NC2     :  LongInt;
                                    Const CalcMode    :  Boolean);

Var
  PIdx1, PIdx2  :  Integer;
  NC3           :  LongInt;
  ONomRec       :  ^OutNomType;


Begin
  NC3:=-1;  PIdx1:=-1; PIdx2:=-1;

  If (NC1>0) then
  Begin
    PIdx1:=FindxONC(NC1);

  end;

  If (PIdx1>0) then
    Alter_Total(PIdx1,NC1,CalcMode);

  If (NC2>0) and (NC2<>NC1) then
  Begin
    PIdx2:=FindxONC(NC2);

  end;

  If (PIdx2>0) then
    Alter_Total(PIdx2,NC2,CalcMode);

  {* Auto blank p&l b/f if present *}

  PIdx2:=FindxONC(Syss.NomCtrlCodes[ProfitBF]);

  If (PIdx2>0) then
  Begin
    PIdx2:=NLOLine.Items[PIdx2].Parent.Index;

    If (PIdx2>0) then
    Begin
      ONomRec:=NLOLine.Items[PIdx2].Data;
      NC3:=ONomRec^.OutNomCode;
    end;
  end;

  If (PIdx2>0) then
    Alter_Total(PIdx2,NC3,CalcMode);

  If (Assigned(ChildNom)) and (InChild) then
    ChildNom.Update_TotalMove(NC1,NC2,CalcMode);
end;


Procedure TNomview.Update_Total4Thread(RecAddr  :  LongInt;
                                       CalcMode :  Boolean);

Var
  MoveRec  :  MoveRepPtr;

Begin
  MoveRec:=Pointer(RecAddr);

  If (Assigned(MoveRec)) then
  With MoveRec^ do
  Begin
    Update_TotalMove(WasNCat,NewNCat,CalcMode);

    If (Not CalcMode) then
      Dispose(MoveRec);
  end
  else
  Begin {Hide all, could be coming from Check G/L}
    HideAll_Totals(CalcMode);

  end;

end;

{$ENDIF}



procedure TNomview.SetChildMove;

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


procedure TNomview.Move1Click(Sender: TObject);


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
                if not GetProcessLock(plMoveGLCode) then
                  EXIT;
                FNeedToReleaseProcessLock := True;

                 MoveItem:=SelectedItem;
                 MoveItemParent:=Items[MoveItem].Parent.Index;
                 MoveMode:=Not MoveMode;
                 LastCursor:=Cursor;

                 If (Not MoveAskList) then
                 Begin

                   {$IFNDEF LTE}

                     UseMoveList:=(CustomDlg(Application.MainForm,'Please Confirm','G/L Move',
                                          'Do you wish to compile a list of moves to be processed later or move codes individually using drag and drop?'+#13+#13+
                                          'Choose [Yes] to compile a list, or [No] to move the codes individually.',mtConfirmation,[mbYes,mbNo,mbCancel])=mrOk);
                   {$ELSE}

                     UseMoveList:=BOn;

                   {$ENDIF}

                   MoveAskList:=BOn;

                   MoveList1.Visible:=UseMoveList;
                 end;


                 Cursor:=crDrag;
               end;

      1     :  Begin
                 If (Items[SelectedItem].Parent.Index=Items[MoveItem].Parent.Index) or (Is_NodeParent(MoveItem,SelectedItem)) then
                 Begin
                   Set_BackThreadMVisible(BOn);

                   ShowMessage('It is not possible to move within the same heading!');

                   Set_BackThreadMVisible(BOff);

                 end
                 else
                   If (SelectedItem=MoveItem) or (SelectedItem<=0) then
                   Begin
                     Set_BackThreadMVisible(BOn);

                     ShowMessage('It is not possible to move to the heading specified!');

                     Set_BackThreadMVisible(BOff);

                   end
                   else
                   Begin

                     Try
                       ONomRec:=Items[MoveItem].Data;
                       LastText:=Items[MoveItem].Text;

                       If (Not UseMoveList) then
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

                       If (Ok2Cont) and (Not UseMoveList) then
                       Begin
                         MoveToItem:=SIdx;
                         MoveInsMode:=MMode;

                         Items[MoveItem].Collapse;

                         {* Changes here need to be reflected in the 4: section for the child control *}
                         BeginUpdate;

                         Items[MoveItem].MoveTo(MoveToItem,MoveInsMode);
                       end;

                     Finally
                       Begin
                         If (Ok2Cont) then
                         Begin
                           If (Not UseMoveList) then
                           Begin
                             EndUpDate;

                             SetChildMove;

                             If (InChild) and (Assigned(ChildNom)) then
                             Begin
                               ChildNom.Move1Click(Nil);
                             end;
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
                   SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plMoveGLCode), 0);
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

procedure TNomview.Check1Click(Sender: TObject);
begin
  {$IFDEF POST}
    AddCheckNom2Thread(Self,Nom,JobRec^,2);
  {$ENDIF}

end;


procedure TNomview.MoveList1Click(Sender: TObject);
begin
  Set_LocalMode(1);

  If (Not Assigned(MoveGLList)) then
    MoveGLList:=TMoveLTList.Create(Self);

  Try
    With MoveGLList do
      Show;

  Except
    FreeandNil(MoveGLList)

  end; {Try..}
end;


  Function TNomview.AddMove2List(MoveRec  :  MoveRepPtr)  :  Boolean;

  Const
    Fnum     =  PWrdF;
    Keypath  =  PWK;


  Begin
    Result:=BOff;

    With ExLocal,LPassword,MoveNomRec, MoveRec^ do
    Begin
      LResetRec(Fnum);

      RecPfix:=MoveNomTCode;

      SubType:=MNSubCode(1);

      MoveCode:=MoveNom.NomCode;
      MoveFrom:=MoveNom.Cat;
      MoveTo:=GrpNom.NomCode;
      MoveType:=MoveNom.NomType;

      MNomCode:=SetPadNo(Form_Int(MoveCode,0),10);

      Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      Report_BError(Fnum,Status);

      Result:=StatusOk;

      If (Not Assigned(MoveGLList)) then
        MoveList1Click(Nil);

      If (Assigned(MoveGLList)) then
      Begin
        MoveGLList.Exlocal.LPassword:=LPassword;

        PostMessage(MoveGLList.Handle,WM_CustGetRec,116,0);

      end;

    end;
  end;



procedure TNomview.Show1Click(Sender: TObject);
begin
  FiltNType:=Not FiltNType;

  Show1.Checked:=FiltNType;

  Update_OutLines(NomF,NomCodeK);
end;

procedure TNomview.ShowG1Click(Sender: TObject);
begin
  ShowGLCode:=Not ShowGLCode;

  ShowG1.Checked:=ShowGLCode;

  Update_OutLines(NomF,NomCodeK);
end;


procedure TNomview.Commit1Click(Sender: TObject);
begin
  {$IFDEF SOP}
     If (Sender is TMenuItem) then
     Begin
       If (CommitMode<>TMenuItem(Sender).Tag) then
       Begin
         CommitMode:=TMenuItem(Sender).Tag;
         TMenuItem(Sender).Checked:=BOn;
         Update_OutLines(NomF,NomCodeK);
         CreateCaption;
       end;

     end;
  {$ENDIF}
end;


procedure TNomview.Show_CCDepViewHistory(ShowGraph  :  Boolean;
                                         ViewMode   :  Byte);

Var
  OldCCDepCode  :  Str10;
  OldCCDepMode  :  Boolean;
  ONomRec       :  OutNomType;


Begin
  If (InCCDepView) and (Not InCCDepVLink) then
  With CCDepView do
  Begin
    InCCDepVLink:=BOn;

    OldCCDepMode:=CCNomMode;

    OldCCDepCode:=CCNomFilt[CCNomMode];

    Try
      CCNomMode:=ThisCCMode;
      CCNomFilt[CCNomMode]:=ThisCCCode;

      With Self.NLOLine do
        ONomRec:=OutNomType(Items[SelectedItem].Data^);

      Case ViewMode of
        0  :  Display_History(ONomRec,BOff,ShowGraph);
        1  :  With Self.NLOLine do
                If (Not StopDD) and (Not Items[SelectedItem].HasItems) then
                  Display_Recon(16,ONomRec,BOff);
      end; {Case..}

    finally
      CCNomMode:=OldCCDepMode;
      CCNomFilt[CCNomMode]:=OldCCDepCode;
      InCCDepVLink:=BOff;

    end; {try..}
  end;

end;


Function TNomview.Being_Posted(Const LMode  :  Byte)  :  Boolean;

Const
  LockSet  :  Set of Byte = [1..4,9,21..24];
  Fnum     =  MiscF;
  Keypath  =  MIK;


Var
  n     :  Byte;
  KeyStr:  Str255;
  LAddr :  LongInt;


Begin
  Result:=BOff;

  For n:=1 to 30 do
    If (n In LockSet) then
    Begin
      KeyStr:=FullPLockKey(PostUCode,PostLCode,n);

      Status:=Find_Rec(B_GetEq+B_MultNWLock,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyStr);

      Result:=(Status=85) or (Status=84);

      If (StatusOK) then {We need to unlock}
      Begin
        Status:=GetPos(F[Fnum],Fnum,LAddr);  {* Preserve DocPosn *}

        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

        If (Status<>81) then
          Report_BError(Fnum,Status);

      end;

      If (Result) then
        Break;
    end;


end;

procedure TNomview.Calc_TBDiff;

Const
  Fnum     =  NomF;
  Keypath  =  NomCatK;

Var
  KeyChk,
  KeyStr :  Str255;

Begin
  TBDiff:=0.0;

  KeyChk:=FullNomKey(0);
  KeyStr:=KeyChk;

  Begin
    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyStr);

    While (StatusOk) and (CheckKey(KeyChk,KeyStr,Length(KeyChk),BOn)) do
    With Nom do
    Begin
      TBDiff:=Round_Up(TBDiff+TB_Balance(BOff),2);


      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyStr);
    end;

  end; {With..}

  Show_TBDiff(1);
end;


procedure TNomview.AddTB1Click(Sender: TObject);
begin
  If Not Being_Posted(0) then
    Calc_TBDiff
  else
    Show_TBDiff(2);
end;



procedure TNomview.ObjectClone2Click(Sender: TObject);
begin
  ObjectClone2.Checked:=Not ObjectClone2.Checked;

  {$B-}
  If (Not ObjectClone2.Checked) or (ParentNom.Currency.ItemIndex=GrandPNom.Currency.ItemIndex) then
  {$B+}
  Begin
    {* Alter Caption, disable period *}

    UseYTD:=Not UseYTD; {* Force a re-draw through *}

    NLOLine.Refresh;

    If (ObjectClone2.Checked) then
    Begin
      CreateDiffCaption;

      NLCrPanel.Caption:='Difference  ';
      NLDrPanel.Caption:='% Difference  ';

    end
    else
    Begin
      CreateCaption;

      NLCrPanel.Caption:='Debit  ';
      NLDrPanel.Caption:='Credit  ';

    end;
  end
  else
    CustomDlg(Application.MainForm,'Note','ObjectClone Difference','In order to calculate the difference, the parent and grandparent currencies must match.',mtConfirmation,[mbOK]);

  Period.Enabled:=Not ObjectClone2.Checked;

  ToPeriod.Enabled:=Period.Enabled;
  Year.Enabled:=Period.Enabled;
  YTDChk.Enabled:=Period.Enabled;
  Currency.Enabled:=Period.Enabled;
  NomSplitBtn.Enabled:=Period.Enabled;
  ObjectClone1.Enabled:=Period.Enabled;
end;




procedure TNomview.CopytoGLView1Click(Sender: TObject);

Var
  ONomRec  :  ^OutNomType;
begin
  With NLOline do
  Begin
    If (SelectedItem>0) then
    Begin
      ONomRec:=Items[SelectedItem].Data;

      SendMessage(Application.MainForm.Handle,WM_FormCloseMsg,251,ONomRec^.OutNomCode);
    end;
  end;
end;

//PR: 05/08/2011 Added function to specifiy if we're in an ObjectClone, so we don't load or save settings.
function TNomview.IsClone: Boolean;
begin
  if Assigned(Owner) then
    Result :=  (Owner.ClassName = ClassName)
  else
    Result := False;
end;

//PR: 05/08/2011 Added function to pass in the window settings to an ObjectClone from its owner.  (ABSEXCH-11428)
procedure TNomview.SetWindowSettings(const Value: IWindowSettings);
begin
  FSettings := Value;

  // CA 23/07/2012 v7.0 ABSEXCH-13189: Dealt with TreeColor
  if Assigned(FSettings) and not FSettings.UseDefaults then
  begin
    FSettings.SettingsToWindow(Self);
    FSettings.SettingsToParent(pnlAll);
    NLOLine.TreeColor   := NLOLine.Font.Color;
  end;

end;

procedure TNomview.FormDestroy(Sender: TObject);
begin
  //PR: 18/05/2017 ABSEXCH-18683 v2017 R1 If we've started a move, then
  //closed the window without completing it we need to remove the process lock
  if FNeedToReleaseProcessLock then
    if Assigned(Application.Mainform) then
       SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plMoveGLCode), 0);

end;

Initialization


end.
