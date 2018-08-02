unit StkTreeU;

{$I DEFOVR.Inc}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Grids,StdCtrls, OutLine, SBSOutl, TEditVal,
  GlobVar,VarConst,ETStrU,BtrvU2,BTSupU1, BTKeys1U,ExtCtrls, Buttons,
  BorBtns, Menus,

  EntWindowSettings,

  ExWrap1U,

  {$IFDEF NOM}
    HistWinU,
  {$ENDIF}

  {$IFDEF SOP}
    MLoc0U,
  {$ENDIF}

  BTSupU3,
  MoveTL1U,

  // CA  05/06/2012   v7.0  ABSEXCH-12452: - Required to get User Options - Stock Tree - Type and Code Options
  VarRec2U,

  ReconU, SBSPanel,
  StockU, ImgModU,
  StkWarnU, ToolWin, AdvToolBar, AdvGlowButton, AdvToolBarStylers;


type
  TStkView = class(TForm)
    NLDPanel: TSBSPanel;
    NLCrPanel: TSBSPanel;
    NLDrPanel: TSBSPanel;
    NLOLine: TSBSOutlineB;
    PopupMenu1: TPopupMenu;
    MIHist: TMenuItem;
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
    NCurrLab: Label8;
    Bevel6: TBevel;
    Panel4: TPanel;
    TxLateChk: TBorCheck;
    Currency: TSBSComboBox;
    Graph1: TMenuItem;
    MIRec: TMenuItem;
    OptBtn: TButton;
    ComparisonClone1: TMenuItem;
    View1: TMenuItem;
    Edit1: TMenuItem;
    Add1: TMenuItem;
    Ledger1: TMenuItem;
    Notes1: TMenuItem;
    Value1: TMenuItem;
    QtyBreaks1: TMenuItem;
    Age1: TMenuItem;
    Delete1: TMenuItem;
    Print1: TMenuItem;
    Add2: TMenuItem;
    Loc1: TMenuItem;
    LocFilt1: TMenuItem;
    LocView1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Move1: TMenuItem;
    Move2: TMenuItem;
    CanlMove1: TMenuItem;
    Show1: TMenuItem;
    OptSpeed: TMenuItem;
    ShowQSold: TMenuItem;
    ShowSC1: TMenuItem;
    MoveList1: TMenuItem;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    AdvStyler: TAdvToolBarOfficeStyler;
    FullExBtn: TAdvGlowButton;
    FullColBtn: TAdvGlowButton;
    GraphBtn: TAdvGlowButton;
    HistBtn: TAdvGlowButton;
    ReconBtn: TAdvGlowButton;
    NomSplitBtn: TAdvGlowButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    Panel3: TPanel;
    Label82: Label8;
    Period: TSBSComboBox;
    Label83: Label8;
    Year: TSBSComboBox;
    YTDChk: TBorCheck;
    AdvToolBarSeparator4: TAdvToolBarSeparator;
    Panel2: TPanel;
    ClsI1Btn: TButton;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    lblStockCode: Label8;
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
    procedure Age1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure LocFilt1Click(Sender: TObject);
    procedure LocView1Click(Sender: TObject);
    procedure Move1Click(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure OptSpeedClick(Sender: TObject);
    procedure ShowQSoldClick(Sender: TObject);
    procedure NLOLineUpdateNode(Sender: TObject; var Node: TSBSOutLNode;
      Row: Integer);
    procedure ShowSC1Click(Sender: TObject);
    procedure MoveList1Click(Sender: TObject);
    procedure PeriodKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    IAmChild,
    FiltNType,
    ShowSCCode,
    ShowQty,
    MoveMode,
    WarnMaxRecs,
    StillMore,
    RefreshHist,
    RefreshRecon,
    InHCallBack,
    InHBeen,
    UseYTD,
    MoveAskList,
    UseMoveList,

    StoreCoord,
    LastCoord,
    fNeedCUpdate,
    FColorsChanged,
    SetDefault,
    GotCoord     :   Boolean;

    MaxIn1Go,
    Lab1Ofset,
    Lab2Ofset,
    Lab3Ofset,
    Lab4Ofset,
    ChrWidth     :   LongInt;


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

    ChildNom     :   TStkView;
    InChild      :   Boolean;

    {$IFDEF Nom}
      HistForm     :   THistWin;
    {$ENDIF}

    MoveGLList   :   TMoveLTList;

    InHist       :   Boolean;


    InRecon      :   Boolean;

    ExLocal      :   TdExLocal;

    StkActive    :  Boolean;

    StkRecForm   :  TStockRec;

    ShowAge      :  TStkWarn;

    {$IFDEF SOP}
      MLocList:  TLocnList;
    {$ENDIF}

    fImageRepos  :  TImageRepos;

    //PR: 18/05/2017 ABSEXCH-18683 v2017 R1 If we've started a move, then
    //closed the window without completing it we need to remove the process lock
    //This variable keeps track of whether we need to remove the lock on destroy
    FNeedToReleaseProcessLock : Boolean;
    

    // CJS: 14/12/2010 - Amendments for new Window Settings system
    FSettings: IWindowSettings;
    procedure LoadWindowSettings;
    procedure SaveWindowSettings;
    procedure EditWindowSettings;

    Function FormatLine(ONomRec  :  OutNomType;
                        LineText :  String)  :  String;

    Procedure SuperDDCtrl(Mode  :  Byte);

    procedure GetSelRec;

    Function Page2Mode(CP  :  Integer)  :  Byte;

    procedure Display_Account(Mode             :  Byte;
                              ChangeFocus      :  Boolean);


    Procedure AddEditLine(Edit  :  Boolean);

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Function CreateCaption  :  Str255;

    Function CreateGPCaption  :  Str255;

    Procedure GetMaxRecpb;

    Procedure Add_MoreLines(Depth,
                            DepthLimit,
                            OIndex        :   LongInt;
                            StkCat        :   Str255);

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

    procedure SetFieldProperties;

    procedure SetFormProperties(SetList  :  Boolean);

    function FindNode(NCode  :  LongInt)  :  Integer;

    Function Advanced_FindNomCode(SC     :  Str20;
                                  SF     :  LongInt;
                                  Fnum,
                                  Keypath:  Integer)  :  Integer;

    Procedure FindStkCode;

    procedure StkLink;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function AddMove2List(MoveRec  :  MoveRepPtr)  :  Boolean;


    Procedure HideAll_Totals(Const HideValues  :  Boolean);

    Procedure RestartView;

    {$IFDEF SOP}
      procedure Link2MLoc(ScanMode  :  Boolean);
    {$ENDIF}


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
                                 Const CalcMode    :  Boolean;
                                       MoveRecPtr  :  Pointer);

      Procedure Update_Total4Thread(RecAddr  :  LongInt;
                                    CalcMode :  Boolean);

    {$ENDIF}

    procedure SetChildMove;

    // CA  05/06/2012   v7.0  ABSEXCH-12452: Required for User Settings - Stock Tree - Type and Code Options
    Function Get_PWDefaults(PLogin  :  Str10) : tPassDefType;

    //PR: 13/07/2012 v7.0 ABSEXCH-11178: Check the parent nodes are expanded, otherwise opening the child will crash. Copied from JobTree
    Procedure OpenParentNodes (Const ParentNode : TSBSOutlNode);
  public
    { Public declarations }

    StkLocFilt   :   Str10;

    Procedure PlaceNomCode(FindCode  :  LongInt);

  end;



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
  ComnUnit,
  ComnU2,
  BtSupU2,

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  {$IFDEF POST}
    PostSp2U,
    GenWarnU,
    MovWarnU,

  {$ENDIF}

  MoveTR1U,

  ExThrd2U,

  StkTRU,
  InvListU,
  SysU1,
  PWarnU,

  oProcessLock;

{$R *.DFM}

Const
  InitWidth  =  118;
  TDpth      =  70;






Procedure  TStkView.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

Function TStkView.FormatLine(ONomRec  :  OutNomType;
                             LineText :  String)  :  String;

Begin
  With ONomRec,Stock do
  Begin
    Result:=Spc(1*OutDepth)+Strip('R',[#32],LineText);

    If (FiltNType) and (OutNomType<>StkGrpCode) then
      Result:=Result+' ('+StockType+')';

    If (ShowSCCode) then
      Result:=Result+' : '+Trim(StockCode);


    Result:=Result+Spc(Round((Width-Canvas.TextWidth(Result))/Canvas.TextWidth(' '))-(TDpth*OutDepth));
  end;
end;


{ ======= Procedure to Build Total for each heading File ===== }

Procedure TStkView.Add_TotOutLines(Depth,
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

  end; {With..}

end; {Proc..}


Procedure TStkView.Add_MoreLines(Depth,
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
  With ExLocal.LStock, ONomRec^ do
  Begin
    OutNomCode:=StockFolio;
    OutStkCode:=StockCode;
    OutStkCat:=StockCat;
    OutDepth:=Depth;
    BeenDepth:=DepthLimit;
    OutNomType:=StockType;
    MoreLink:=BOn;
  end;

  LineText:=Spc(1*Depth)+'* Double Click here for more records.';

  StillMore:=BOn;

  NewIdx:=NLOLine.AddChildObject(OIndex,LineText,ONomRec);
end;


Procedure TStkView.GetMaxRecpb;

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

Procedure TStkView.Add_OutLines(Depth,
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

  LineText
          :  String;

  SpcWidth,
  NewIdx,
  InsIdx,
  NewObj,
  TmpRecAddr,
  ThisCount
          :  LongInt;

  TmpStat,
  TmpKPath
          :  Integer;
  ChangeKey
          :  Boolean;

  TmpStk  :  StockRec;

  ONomRec :  ^OutNomType;


Begin
  TmpKPath:=Keypath;
  ThisCount:=0;

  InsIdx:=0;
  ChangeKey:=NeedMode;

  With NLOLine,ExLocal do
  Begin

    SpcWidth:=Canvas.TextWidth(' ');

    If (NeedMode) then
      KeyChk:=StkMore
    else
      KeyChk:=FullStockCode(StkCat);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (ThisCount<MaxIn1Go) do
    With LStock do
    Begin
      {Application.ProcessMessages;  Cannot put this here, as LStock can get corrupted}

      Inc(ThisCount);

      If (WarnMaxRecs) and (ThisCount=MaxIn1Go) then
      Begin
        WarnMaxRecs:=BOff;

        GetMaxRecpb;
      end;

      If (ThisCount<MaxIn1Go) then
      Begin
        New(ONomRec);
        FillChar(ONomRec^,Sizeof(ONomRec^),0);
        With ONomRec^ do
        Begin
          OutNomCode:=StockFolio;
          OutStkCode:=StockCode;
          OutStkCat:=StockCat;
          OutDepth:=Depth;
          BeenDepth:=DepthLimit;
          OutNomType:=StockType;
        end;

        {LineText:=Spc(1*Depth)+LJVar(Desc,ChrWidth-(20*Depth))}

        {LineText:=FormatLine(ONomRec^,Strip('R',[#32],Desc[1]));}

        LineText:=Spc(1*Depth)+Strip('R',[#32],Desc[1]);

        If (FiltNType) and (ONomRec^.OutNomType<>StkGrpCode) then
          LineText:=LineText+' ('+StockType+')';

        If (ShowSCCode) then
          LineText:=LineText+' : '+Trim(StockCode);

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

        If (StockType=StkGrpCode) and (Depth<DepthLimit) then
        Begin
          If (Not Syss.BigStkTree) then
          Begin

            TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);
            TmpStk:=LStock;

            Add_OutLines(Depth+1,DepthLimit,NewIdx,StockCode,'',BOff,Fnum,Keypath);

            TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
            LStock:=TmpStk;
          end
          else
            ONomRec^.NotOpen:=BOn;

          Add_TotOutLines(Depth+1,DepthLimit,StockFolio,NewIdx,StockCode,StockType,'Total '+Desc[1]);
        end;

        If (NeedMode) and (ChangeKey) then
        Begin
          KeyChk:=FullStockCode(StkCat);
          ChangeKey:=BOff;
        end;

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);
      end
      else
        Add_MoreLines(Depth,DepthLimit,OIndex,KeyS);

    end; {While..}

  end; {With..}

end; {Proc..}


Procedure TStkView.Update_OutLines(Const Fnum,
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
        KeyS:=FullStockCode(OutStkCode);

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        LineText:=Strip('B',[#32],Items[n].Text);

        With Stock do
        Begin
          {LineText:=Spc(1*OutDepth)+LJVar(LineText,ChrWidth-(20*OutDepth))}

          If (Not MoreLink) then
          Begin
            LineText:=Spc(1*OutDepth)+Strip('R',[#32],Desc[1]);

            If (HedTotal) then
              LineText:='Total '+LineText
            else
              If (FiltNType) and (OutNomType<>StkGrpCode) then
                LineText:=LineText+' ('+StockType+')';

            If (ShowSCCode) then
              LineText:=LineText+' : '+Trim(StockCode);


            LineText:=LineText+Spc(Round((Width-Canvas.TextWidth(LineText))/CanVas.TextWidth(' '))-(TDpth*OutDepth));
          end;
        end;

        Items[n].Text:=LineText;
      end;

    end; {Loop..}

    EndUpdate;

  end; {With..}
end; {Proc..}


Procedure TStkView.Drill_OutLines(Depth,
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
          If (NextChild>0) and (Syss.BigStkTree) and (NotOpen) then
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
              Add_OutLines(Depth,DepthLimit,PIndex,OutStkCode,'',BOff,StockF,StkCatK);

              ONomRec:=Items[PIndex].Data;

              If (OutNomType=StkGrpCode) then
                Add_TotOutLines(Depth,DepthLimit,OutNomCode,PIndex,OutStkCode,OutNomType,'Total '+Items[PIndex].Text);
            end;
          end
          else
            If (Not Syss.BigStkTree) then
              Drill_OutLines(Depth+1,DepthLimit,NextChild);
        end;

        If (Not LoopCtrl) then
          LoopCtrl:=BOn;

      Until (NextChild<1);

    end; {If limit reached..}

  end; {With..}
end; {Proc..}




Procedure TStkView.Delete_OutLines(PIndex      :  LongInt;
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



procedure TStkView.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  {* Inform parent closing *}

  If (CanClose) then
    CanClose:=GenCheck_InPrint;

  If (CanClose) then
    GenCanClose(Self,Sender,CanClose,BOn);


  If (CanCLose) then
  Begin
    // CJS: 14/12/2010 - Amendments for new Window Settings system
    If (NeedCUpdate) { And (StoreCoord Or FColorsChanged)} then
      SaveWindowSettings;


    Send_UpdateList(46);
  end;
  


end;

procedure TStkView.FormClose(Sender: TObject; var Action: TCloseAction);
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

  If (StkActive) and (StkRecForm<>nil) then
  Begin
    StkRecform.Free;
    StkActive:=BOff;
  end;

  If (ShowAge<>nil) then
    ShowAge.Free;

  FreeandNil(fImageRepos);

  ExLocal.Destroy;

  Action:=caFree;

end;

Function TStkView.CreateCaption  :  Str255;

Var
  LocTit  :  Str50;

Begin
  LocTit:='';

  {$IFDEF SOP}
    If (Not EmptyKey(StkLocFilt,LocKeyLen)) then
      LocTit:=' - Locn : '+StkLocFilt+'. ';

  {$ENDIF}


  Caption:='Stock Drill Down : '+LocTit+PPr_OutPr(NPr,NYr)+'. '+Show_TreeCur(NCr,NTxCr)+'.';
end;


Function TStkView.CreateGPCaption  :  Str255;

Begin
  If (ShowQty) then
    NLDrPanel.Caption:='Qty'
  else
    NLDrPanel.Caption:='GP%';
end;

procedure TStkview.FormCreate(Sender: TObject);
var
  UProfile : tPassDefType;
begin
  FNeedToReleaseProcessLock := False;

  ExLocal.Create;

  // CA  05/06/2012   v7.0  ABSEXCH-12452: Required to check on user Setting - Stock Tree - Type and Code Options
  UProfile:= Get_PWDefaults(EntryRec^.Login);

  InitSize.Y:=329;
  InitSize.X:=607;//535;

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

  // CJS: 24/03/2011 ABSEXCH-10544
  // Moved the reading of the offsets so that they are read *before* the
  // window positions are retrieved, to ensure that they hold the design-time
  // offset (which will then be used to re-calculate the correct position for
  // the labels if the window settings have changed).
  Lab1Ofset:=Width-(NLDPanel.Width);
  Lab2Ofset:=Width-NLCrPanel.Left;
  Lab3Ofset:=Width-NLDrPanel.Left;

  // CJS: 13/12/2010 Added to use new Window Positioning system
  // Find_FormCoord;
  FSettings := GetWindowSettings(self.Name);
  LoadWindowSettings;

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

  {$IFDEF MC_On}

    Set_DefaultCurr(Currency.Items,BOn,BOff);
    Set_DefaultCurr(Currency.ItemsL,BOn,BOn);

  {$ELSE}

    Currency.Visible:=BOff;
    NCurrLab.Visible:=BOff;
    TxLateChk.Visible:=BOff;

  {$ENDIF}

  {$IFNDEF PF_On}
    QtyBreaks1.Visible:=BOff;
    Value1.Visible:=BOff;
  {$ELSE}
    QtyBreaks1.Visible:=ChkAllowed_In(146);
    Value1.Visible:=ChkAllowed_In(149);

  {$ENDIF}

  {$IFNDEF SOP}
    Age1.Visible:=BOff;
    Loc1.Visible:=BOff;
  {$ELSE}
    Age1.Visible:=ChkAllowed_In(148);
    Loc1.Visible:=Syss.UseMLoc;
    MLocList:=nil;
  {$ENDIF}

  MoveAskList:=BOff;
  UseMoveList:=BOff;
  MoveGLList:=Nil;

  OptSpeed.Checked:=Syss.BigStkTree;

  ShowQty:=(Not PChkAllowed_In(143));

  If (Not ShowQty) then
    ShowQty:=Syss.ShowQtySTree;

  CreateGPCaption;

  ShowQSold.Checked:=ShowQty;


  Add2.Visible:=ChkAllowed_In(110);
  Add1.Visible:=Add2.Visible;
  Edit1.Visible:=ChkAllowed_In(111);
  Delete1.Visible:=ChkAllowed_In(112);
  Print1.Visible:=ChkAllowed_In(113);
  Ledger1.Visible:=ChkAllowed_In(109);


  StkLocFilt:='';

  Set_DefaultPr(Period.Items);

  Period.ItemIndex:=Pred(GetLocalPr(0).CPr);

  Set_DefaultYr(Year.Items,GetLocalPr(0).CYr);

  Year.ItemIndex:=10;

  Currency.ItemIndex:=0;
  MaxIn1Go:=500;
  WarnMaxRecs:=BOn;

  MoveMode:=BOff;
  MoveItem:=-1;
  MoveToItem:=-1;
  MoveInsMode:=TSBSAttachMode(0);
  MoveItemParent:=-1;
  Move1.Visible:=ChkAllowed_In(200);
  //HV 03/05/2016 2016-R2 ABSEXCH-10025: When a user does not have access to the stock move they are still able to see the move list option in the stock tree.
  MoveList1.Visible := Move1.Visible;
  N4.Visible:=Move1.Visible;
  Move2.Visible:=BOff;
  FiltNType:=BOff;
  ShowSCCode:=BOff;


  If (Not Move1.Visible) then
  Begin
    Move1.Shortcut:=0;
    Move2.Shortcut:=0;
  end;

  If (Owner is TStkView) then
  With TStkView(Owner) do
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
    Self.StkLocFilt:=StkLocFilt;
    Self.TxLateChk.Checked:=TxLateChk.Checked;

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
    Add_OutLines(0,2,0,'','',BOff,StockF,StkCatK);

    NPr:=Succ(Period.ItemIndex);

    NYr:=TxlateYrVal(StrToInt(Year.Text),BOn);


    {$IFDEF MC_On}
      NCr:=Currency.ItemIndex;
    {$ELSE}
      NCr:=0;
    {$ENDIF}

  end;

  CreateCaption;

  GotCoord:=BOn;

  StkActive:=BOff;
  StkRecForm:=nil;

  // CA  05/06/2012   v7.0  ABSEXCH-12452: Setting up the defaults - Stock Tree - Type and Code Options
  if(UProfile.ShowStockCode) then
     ShowSC1Click(nil);

  if(UProfile.ShowProductType) then
     Show1Click(nil);

  FormReSize(Self);
end;


procedure TStkView.FormResize(Sender: TObject);
begin
  If (GotCoord) then
  Begin
    GotCoord:=BOff;

    OrigSize.X:=ClientWidth;
    OrigSize.Y:=ClientHeight;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    NLOLine.Width:=ClientWidth-5;
    NLOLine.Height:=ClientHeight-107; {* This ratio is critical, and must follow the design form ratio! *}
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

    Bevel6.Left := NLOLine.Left;
    Bevel6.Width := NLOLine.Width;

    Update_OutLines(StockF,StkCodeK);

    {ClientWidth:=OrigSize.X;
    ClientHeight:=OrigSize.Y;}

    GotCoord:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end;


end;

procedure TStkView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  If (NLOLine.SelectedItem>0) and (Key=VK_Delete)  then
  Begin
    GetSelRec;

    If Ok2DelStk(0,Stock) then
      Display_Account(3,BOn);

  end;
end;

procedure TStkView.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TStkView.Display_History(ONomCtrl     :  OutNomType;
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

      NHLocCode:=StkLocFilt;
      
      NHCCode:=CalcKeyHist(NHNomCode,NHLocCode);


      If (Stock.StockCode<>OutStkCode) then
        GetStock(Self,OutStkCode,FoundCode,-1);

      NHKeyLen:=NHCodeLen+2;


      With Stock do
      Begin
        Find_FirstHist(StockType,NomNHCtrl,fPr,fYr);
        MainK:=FullNHistKey(StockType,NHCCode,NCr,fYr,fPr);
        AltMainK:=FullNHistKey(StockType,NHCCode,NCr,0,0);
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


procedure TStkview.GetMoreLinks(Index  :  LongInt);

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

      Add_OutLines(OutDepth,BeenDepth,OIndex,OutStkCat,Strip('R',[#0],FullStockTree(OutStkCat,OutStkCode)),BOn,StockF,StkCatK);

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



procedure TStkview.NLOLineExpand(Sender: TObject; Index: Longint);
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


  If (Not IsMore) then
    ReconBtnClick(Sender);

end;

procedure TStkview.NLOLineCollapse(Sender: TObject; Index: Longint);
begin
  If (InChild) then
    ChildNom.NLOLine.ExpandxNCode(NLOLine.Items[Index].Data,BOff);
end;


procedure TStkview.NLOLineNeedValue(Sender: TObject);

Var
  ONomRec      :  ^OutNomType;
  DrawIdxCode  :  LongInt;
  ShowGP       :  Boolean;
  Profit,
  Sales,
  Purch,
  Cleared      :  Double;



begin
  With Sender as TSBSOutLineB do
  Begin
    DrawIdxCode:=CalcIdx;

    ShowGP:=(PChkAllowed_In(143));

    If (DrawIdxCode>0) then
    Begin
      ONomRec:=Items[DrawIdxCode].Data;

      If (ONomRec<>nil) then
      With ONomRec^ do
      Begin
        If (DrawIdxCode=SelectedItem) then
           lblStockCode.Caption:= 'Stock Code: ' + OutStkCode;

        If (LastPr<>NPr) or (LastYr<>NYr) or (LastCr<>NCr) or (LastYTD<>UseYTD) or (LastTxCr<>NTxCr) or (LastLoc<>StkLocFilt)
        or (LastHValue<>HideValue) or (LastSQty<>ShowQty) then
        Begin

          Profit:=Profit_to_Date(OutNomType,CalcKeyHist(OutNomCode,StkLocFilt),NCr,NYr,NPr,Purch,Sales,Cleared,UseYTD);

          ColValue:=0;

          Blank(LastDrCr,Sizeof(LastDrCr));

          LastDrCr[2]:=Currency_Txlate(Sales,NCr,NTxCr);

          If (ShowGP) and (Not ShowQty) then
            LastDrCr[1]:=Calc_Pcnt(Sales,Profit)*DocNotCnst
          else
            LastDrCr[1]:=Cleared;


          LastPr:=NPr;
          LastYr:=NYr;
          LastCr:=NCr;
          LastTxCr:=NTxCr;
          LastYTD:=UseYTD;
          LastLoc:=StkLocFilt;
          LastHValue:=HideValue;
          LastSQty:=ShowQty;
        end; {If settings changed..}

        With Items[DrawIdxCode] do
          If (Not Expanded) or (Not HasItems) then
          Begin
            If (Not HideValue) then
            Begin

                ColValue:=LastDrCr[SetCol];
                If (SetCol=1) and (Not ShowQty) then
                  ColFmt:=GenPcntMask
                else
                  ColFmt:=GenRealMask;
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


procedure TStkView.NLOLineUpdateNode(Sender: TObject;
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
          StkDescCode  :  UseLeafX:=obLeaf3;
          StkBillCode  :  UseLeafX:=obLeaf2;
          StkDListCode :  UseLeafX:=obLeaf4;
          else            UseLeafX:=obLeaf;
        end; {Case..}

        If HedTotal then
          UseLeafX:=obLeaf5;
      end;
    end;

  end;

end;




procedure TStkView.FullExBtnClick(Sender: TObject);
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


procedure TStkView.CurrencyClick(Sender: TObject);
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

Procedure TStkView.SuperDDCtrl(Mode  :  Byte);


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


procedure TStkview.GetSelRec;


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
        If (Stock.StockCode<>OutStkCode) or (ExLocal.LStock.StockCode<>OutStkCode) then
          FoundOk:=GetStock(Self,OutStkCode,FoundCode,-1);
    end;
  end; {With..}
end;

procedure TStkView.Display_Account(Mode             :  Byte;
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
    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    If (Mode<>5) then {* Do not set, as we want to view notes, and NHMode5=use serial numbers *}
      NHMode:=Mode;

    NHCr:=NCr;
    NHTxCr:=NTxCr;

    NHPr:=NPr;

    NHYr:=NYr;

    NHNomCode:=OutNomCode;

    NHNeedGExt:=(NHMode=7);

    If (NHNeedGExt) then
    With ExLocal do

    Begin
      NHPr:=LNHist.Pr;

      NHYr:=LNHist.Yr;
    end;

    Set_DDFormMode(NomNHCtrl);

  end;{With..}


  If (StkRecForm=nil) then
  Begin

    StkRecForm:=TStockRec.Create(Self);
    GetSelRec;

  end;

  Try

   StkActive:=BOn;

   With StkRecForm do
   Begin

     WindowState:=wsNormal;

     SRecLocFilt:=StkLocFilt;

     SerUseMode:=BOff; BinUseMode:=BOff; InSerFind:=BOff; InBinFind:=BOff;

     SetTabs;

     If (Mode In [1..10]) and (ChangeFocus) then
       Show;

     If (Not ExLocal.InAddEdit) then
       ShowLink;


     If (Mode In [1..3]) and (Not ExLocal.InAddEdit) then
     Begin
       ChangePage(StockU.SMainPNo);

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

           {$B+}
         end;
         EditAccount((Mode=2));
       end;
     end;

     Case Mode of

       5  :  ChangePage(StockU.SNotesPNo);
       6..10
          :  Begin
               InRecon:=BOn;
               Case Mode of
                 {$IFDEF PF_On}
                   9  :  If (ValPage.TabVisible) then
                           ChangePage(StockU.SValuePNo);
                   10 :  If (QtyBreaks.TabVisible) then
                           ChangePage(StockU.SQtyBPNo);
                 {$ELSE}
                   9  :  ;
                 {$ENDIF}
                 else    If (Current_Page<>StockU.SLedgerPNo) then
                           ChangePage(StockU.SLedgerPNo);
               end;{Case..}

               {If (Mode>6) and (HistFormPtr=nil) then
                 Display_History(Mode-6,BOn);}

             end;

     end;



   end; {With..}


  except

   InRecon:=BOff;
   StkActive:=BOff;

   StkRecForm.Free;

  end;


end;


Procedure TStkView.AddEditLine(Edit  :  Boolean);

Var
  Depth,
  OIndex,
  NewIdx   :  Integer;
  PNode    :  TSBSOutLNode;
  NewFolio :  LongInt;
  ONomRec  :  ^OutNomType;

Begin

  With NLOLine,Stock do
  If (Not Edit) then
  Begin
    NewFolio:=StockFolio;

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

        Add_OutLines(0,2,0,'','',BOff,StockF,StkCatK)

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

    Items[SelectedItem].Text:=FormatLine(ONomRec^,Desc[1]);

    ONomRec^.OutStkCode:=StockCode;

    ONomRec^.OutNomType:=StockType;

    PNode:=Items[SelectedItem];
    OIndex:=SelectedItem;

    Delete_OutLines(OIndex,BOff);

    Depth:=Pred(PNode.Level);

    Drill_OutLines(Depth,Depth+2,OIndex);
  end;

end;



Procedure TStkView.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of


      41 :  Begin
              InHist:=BOff;

            end;

      42 :  InRecon:=BOff;

      {$IFDEF SOP}
        43 :  MLocList:=nil;
      {$ENDIF}

      46 :  InChild:=BOff;

      52,53
         :  Begin
              ExLocal.AssignFromGlobal(NHistF);

              SuperDDCtrl(WParam-52)
            end;

      62
         :  Begin
              ExLocal.AssignFromGlobal(StockF);
              ExLocal.AssignFromGlobal(NHistF);
              PlaceNomCode(ExLocal.LStock.StockFolio);
              SuperDDCtrl(0);
            end;

      71 :  SendMessage(Self.Handle,WM_Close,0,0);
      {$IFDEF POST}
        70,72
         :  Begin
                {RefreshMove(MoveItemParent); {* This has been disabled since it could be very confusing to have things collapse etc whilst you were still moving about. *}

              Update_Total4Thread(LParam,(WParam=70));
            end;

        73  :  Begin
                 ReStartView;

               end;
      {$ENDIF}

      277  :  MoveGLList:=nil;


    end; {Case..}

  end;
  Inherited;
end;

Procedure TStkView.WMCustGetRec(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of
       25  :  NeedCUpdate:=BOn;

      169  : With NLOLine do
               Items[SelectedItem].Expand;

      100  : If (StkActive) then
             Begin
               StkRecForm.ExLocal.AssignToGlobal(StockF);
               AddEditLine((LParam=1));
             end;

      170  :  Print1Click(nil);

      211  :  ShowAge:=nil;


      200,300
         :  Begin
              InRecon:=BOff;
              StkActive:=BOff;
              StkRecForm:=nil;

              If (WParam=300) then
              With NLOLine do
                If (SelectedItem>=0) then
                  Delete_OutLines(SelectedItem,BOn);
            end;

      250 :  GetMoreLinks(LParam);



    end; {Case..}

  end;
  Inherited;
end;


Procedure TStkView.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TStkView.Send_UpdateList(Mode   :  Integer);

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




procedure TStkView.ClsI1BtnClick(Sender: TObject);
begin
  Close;
end;

procedure TStkView.NomSplitBtnClick(Sender: TObject);
begin
  If (Not InChild) then
  Begin
    ChildNom:=TStkView.Create(Self);
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

procedure TStkView.NLChildUpdate;

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


procedure TStkView.NLOLineDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  If (InHist) then
    HistBtnClick(nil);

  If (InRecon) then
    ReconBtnClick(nil);


  If (StkRecForm<>nil) and (StkActive) and (Not InRecon) then
    StkLink;

  With NLOLine do
    If (ShowAge<>nil) and (Index=SelectedItem) then
    try
      GetSelRec;
      ShowAge.ShowAged;

    except
      ShowAge.Free;
      ShowAge:=nil;
    end;

  {$IFDEF SOP}
    If (Assigned(MLocList)) then
    Begin
      GetSelRec;
      Link2MLoc(BOn);
    end;
  {$ENDIF}

  NLChildUpDate;

end;


procedure TStkView.YTDChkClick(Sender: TObject);
begin
  UseYTD:=YTDChk.Checked;

  NLOLine.Refresh;
end;

procedure TStkView.PopupMenu1Popup(Sender: TObject);

Var
  n        : Integer;
  ONomRec  :  ^OutNomType;


begin
  StoreCoordFlg.Checked:=StoreCoord;

  N3.Tag:=Ord(ActiveControl Is TSBSOutLineB);

  GetSelRec;

  Delete1.Enabled:=Ok2DelStk(0,Stock);

  With NLOLine do
    If (SelectedItem>0) then
    Begin
      ONomRec:=Items[SelectedItem].Data;

      With Delete1 do
        Enabled:=(Enabled and Not ONomRec^.HedTotal);
    end;

  Add1.Enabled:=Not InRecon;
  Age1.Enabled:=(Stock.StockType In StkProdSet);
  Ledger1.Enabled:=(Stock.StockType<>StkGrpCode);
  Value1.Enabled:=Ledger1.Enabled;
  LocView1.Enabled:=Ledger1.Enabled;
end;

procedure TStkView.SetFieldProperties;

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


procedure TStkView.SetFormProperties(SetList  :  Boolean);

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

end;


procedure TStkview.PropFlgClick(Sender: TObject);
begin
  // CJS: 14/12/2010 - Amendments for new Window Settings system
  EditWindowSettings;
  (*
  SetFormProperties(N3.Tag=1);
  N3.Tag:=0;
  *)
end;


procedure TStkview.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;



procedure TStkView.NLOLineMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NLChildUpDate;
end;


procedure TStkView.TxLateChkClick(Sender: TObject);
begin
  If (TxLateChk.Checked) then
    Currency.ItemIndex:=NTxCr
  else
    Currency.ItemIndex:=NCr;
end;


procedure TStkView.HistBtnClick(Sender: TObject);
Var
  ONomRec  :  ^OutNomType;
  DispRec  :  Boolean;

begin
  {$IFDEF NOM}
    DispRec:=BOff;

    With NLOLine do
    Begin
      ONomRec:=Items[SelectedItem].Data;

      If (InHist) then
        DispRec:=((HistForm.NHCtrl.NHNomCode<>ONOmRec^.OutNomCode) or (Sender<>nil) or (RefreshHist));


      If ((Not InHist) or (DispRec)) and (Not InHCallBack) then
        Display_History(ONomRec^,(Sender<>nil),((Sender=GraphBtn) or (Sender=Graph1)));

      ReFreshHist:=BOff;
    end;
  {$ENDIF}
end;

procedure TStkView.StkLink;
Var
  DispRec  :  Boolean;

begin
  DispRec:=BOff;

  If (StkRecForm<>nil) and (StkActive) then
  With StkRecForm do
  Begin
    GetSelRec;

    If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) and (Stock.StockCode<>ExLocal.LStock.StockCode) then
    Begin
      Display_Account(0,BOff);
    end;
  end;

end;


procedure TStkview.MIEALClick(Sender: TObject);
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

procedure TStkView.PeriodKeyPress(Sender: TObject; var Key: Char);
begin
  If (Not (Key In ['0'..'9',#8,#13])) and (Not GetLocalPr(0).DispPrAsMonths) then
    Key:=#0;
end;


procedure TStkview.PeriodExit(Sender: TObject);
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

{ ======= Function to find the note a nominal code resides at ======= }

function TStkView.FindNode(NCode  :  LongInt)  :  Integer;

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

Function TStkView.Advanced_FindNomCode(SC     :  Str20;
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
    Result:=FindNode(Stock.StockFolio);

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
        //PR: 13/07/2012 v7.0 ABSEXCH-11178: Check the parent nodes are expanded, otherwise opening the child will crash. Copied from JobTree
        OpenParentNodes(Items[Result].Parent);


        Items[Result].Expand;
      end;

      Result:=FindNode(SF);
    end;
  end;


end;



Procedure TStkView.PlaceNomCode(FindCode  :  LongInt);

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

  FoundOk:=(Stock.StockFolio=FindCode);

  If (Not FoundOk) then
  Begin
    KeyS:=FullStockCode(Stock.StockCode);
    FoundOk:=GetStock(Owner,KeyS,FoundCode,-1);
  end;

  If (FoundOk) then
  Begin
    KeyS:=FullStockCode(Stock.StockCat);

    If (Not EmptyKey(Stock.StockCat,StkKeyLen)) then
      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (Not Syss.BigStkTree) then
    Begin
      While (StatusOk) and (Not EmptyKey(Stock.StockCat,StkKeyLen)) do {* Get to top of this branch *}
      Begin
        KeyS:=FullStockCode(Stock.StockCat);

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      end;
    end;

    n:=FindNode(Stock.StockFolio);

    If (n=-1) and (Syss.BigStkTree) and (Not EmptyKey(Stock.StockCat,StkKeyLen)) then
      n:=Advanced_FindNomCode(Stock.StockCat,Stock.StockFolio,Fnum,Keypath);

    If (n<>-1) then
    With NLOLine do
    Begin
      StopDD:=BOn;

      //PR: 13/07/2012 v7.0 ABSEXCH-11178: Check the parent nodes are expanded, otherwise opening the child will crash. Copied from JobTree
      OpenParentNodes(Items[n].Parent);

      Items[n].FullExpand;

      n:=FindNode(Integer(FindCode));

      If (n<>-1) then
        SelectedItem:=n
      else
        If (StillMore) then
          ShowMessage('That stock code code not be found.'+#13+'There are more stock codes available which are not shown.'+#13+
                       'Please click on the More record lines to load more data.');

      StopDD:=BOff;

    end;

  end;

end;


Procedure TStkView.FindStkCode;

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

    If (InpOk) then
      FoundOk:=GetStock(Self,SCode,FoundCode,99);

  Until (FoundOk) or (Not InpOk);

  If (FoundOk) then
  Begin
    PlaceNomCode(Stock.StockFolio);
  end;


end;


procedure TStkView.MIFindClick(Sender: TObject);
begin
  FindStkCode;
end;

Function TStkView.Page2Mode(CP  :  Integer)  :  Byte;

Begin
  Case CP of

    0..2
         :  Result:=0;
    4    :  Result:=5;
    5    :  Result:=10;
    6    :  Result:=6;
    7    :  Result:=9;
    else    Result:=6;

  end; {Case..}
end;

procedure TStkView.ReconBtnClick(Sender: TObject);

Var
  ONomRec  :  ^OutNomType;
  DispRec  :  Boolean;
  RMode    :  Byte;

begin
  DispRec:=BOff;

  {$IFDEF Nom}
    If (Sender=HistForm) and (Sender<>nil) then
      RMode:=7
    else
  {$ENDIF}
      Begin
        If Assigned(StkRecForm) then
          RMode:=Page2Mode(StkRecForm.Current_Page)
        else
          RMode:=6;
      end;

  With NLOLine do
  Begin
    ONomRec:=Items[SelectedItem].Data;

    If (InRecon) and (Assigned(StkRecForm)) then
    Begin
      DispRec:=(((StkRecForm.DDCtrl.NHNomCode<>ONOmRec^.OutNomCode) and (Not ONomRec^.HedTotal)) or (Sender<>nil)
                 {or (RefreshRecon)});

    end;

    {$IFDEF Nom}
      If ((Not InRecon) or (DispRec)) and (Not Items[SelectedItem].HasItems) and (Not InHCallBack) and (Not ONomRec.HedTotal) and (Not StopDD) then
        Display_Account(RMode,((Sender<>nil) and (Sender<>HistForm)));
    {$ELSE}
      If ((Not InRecon) or (DispRec)) and (Not Items[SelectedItem].HasItems) and (Not InHCallBack) and (Not ONomRec.HedTotal) then
        Display_Account(RMode,(Sender<>nil));
    {$ENDIF}

    ReFreshRecon:=BOff;
  end;
end;




procedure TStkView.Edit1Click(Sender: TObject);

Var
  RB  :  Byte;

begin
  If (Sender is TMenuItem) then
  Begin
    RB:=TMenuItem(Sender).Tag;

    If (NLOLine.SelectedItem>0) or (RB=1) then
      Display_Account(RB,BOn);

  end;
end;

procedure TStkView.OptBtnClick(Sender: TObject);

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


procedure TStkView.Age1Click(Sender: TObject);
Var
  WasNew  :  Boolean;

begin
  {$IFDEF SOP}
                                               
    WasNew:=BOff;

    If (ShowAge=nil) then
    Begin
      ShowAge:=TStkWarn.Create(Self);
      WasNew:=BOn;
    end;

    try

      If (WasNew) then
        ShowAge.InitScanMode;

      ShowAge.ShowAged;

    except
      ShowAge.Free;
      ShowAge:=nil;
    end;
  {$ENDIF}
end;



procedure TStkView.Print1Click(Sender: TObject);
begin
  {$IFDEF FRM}
    With NLOLine do
      If (SelectedItem>0) then
      Begin
        GetSelRec;
        ExLocal.AssignFromGlobal(StockF);
        PrintStockRecord(ExLocal,BOn);
      end;
  {$ENDIF}
end;

procedure TStkView.LocFilt1Click(Sender: TObject);
Var
  InpOk,
  FoundOk  :  Boolean;

  OCode,
  SCode    :  String;

Begin

  SCode:=StkLocFilt;
  OCode:=SCode;

  Repeat

    InpOk:=InputQuery('Location Filter','Enter the Location Code you wish to filter by. (Blank for none)',SCode);

    {$IFDEF SOP}
      If (InpOk) then
        If (Not EmptyKey(SCode,LocKeyLen)) then
          FoundOk:=GetMLoc(Self,SCode,StkLocFilt,'',0)
        else
        Begin
          StkLocfilt:='';
          FoundOk:=BOn;
        end;
    {$ENDIF}

  Until (FoundOk) or (Not InpOk);

  If (FoundOk) and (SCode<>OCode)  then
  Begin
    CurrencyClick(Sender);

    If (Assigned(StkRecForm)) then
    With StkRecForm do
      If (Not ExLocal.InAddEdit) then
      Begin
        SRecLocFilt:=StkLocFilt;
        ShowLink;
      end;
  end;


end;


{$IFDEF SOP}
  procedure TStkView.Link2MLoc(ScanMode  :  Boolean);

  Var
    WasNew  :  Boolean;

  begin
    WasNew:=BOff;

    
    If (Stock.StockType<>StkGrpCode) then
    Begin

      If (Not Assigned(MLocList)) then
      Begin
        Set_MLFormMode(21);
        MLocList:=TLocnList.Create(Self);
        WasNew:=BOn;
      end;


      With MLocList do
      If ((Not ScanMode) or (ExLocal.LStock.StockCode<>Stock.StockCode)) then
      Begin
        try
          LSRKey:=Stock.StockCode;
          ExLocal.AssignFromGlobal(StockF);

          If (WasNew) then
            ChangePage(1)
          else
          Begin

              
            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            RefreshList(BOn,BOn);

            If (Not ScanMode) then
              Show;
          end;

        except
          MLocList.Free;
          MLocList:=nil;
        end; {try..}
      end; {With..}
    end;
  end;
{$ENDIF}

procedure TStkView.LocView1Click(Sender: TObject);
begin

  {$IFDEF SOP}
    GetSelRec;
    Link2MLoc(BOff);
  {$ENDIF}
end;


Function TStkView.Is_NodeParent(MIdx,SIdx  :  Integer)  :  Boolean;

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

Function TStkView.Place_InOrder(MIdx,SIdx  :  Integer;
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
  Function TStkView.Confirm_Move(MIdx,SIdx  :  Integer)  :  Boolean;

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

        MoveMode:=3;

        With ONomRec^ do
        Begin
          MoveSCode:=OutStkCode;
          WasSGrp:=OutStkCat;

          If (Global_GetMainRec(StockF,MoveSCode)) then
          With Stock do
          Begin
            WasSGrp:=StockCat;
            MoveStk:=Stock;
          end;
        end;

        PIdx:=Items[SIdx].Parent.Index;

        If (PIdx>0) then
        Begin
          ONomRec:=Items[PIdx].Data;

          With ONomRec^ do
          Begin
            NewSGrp:=FullStockCode(OutStkCode);

            If (Global_GetMainRec(StockF,OutStkCode)) then
            Begin
              GrpStk:=Stock;
            end;
          end;
        end
        else
        With GrpStk do
        Begin
          Desc[1]:='Stock Root';
          NewSGrp:=FullStockCode('');
        end;
        Set_BackThreadMVisible(BOn);

        WMsg:=ConCat('You are about to move ',dbFormatName(MoveStk.StockCode,MoveStk.Desc[1]),' into ',
              dbFormatName(GrpStk.StockCode,GrpStk.Desc[1]),#13,#13);

        If (Not UseMoveList) then
        Begin

          WMsg:=ConCat(WMsg,'The group totals affected will be blanked out until the move is complete.',#13,#13);
          WMsg:=ConCat(WMsg,'This operation should be performed with all other users logged out.',#13,#13,'A backup ',
                'MUST be taken since the integrity of the Stock Tree will be damaged should the move fail.',#13,#13,
                'Do you wish to continue?');

          mbRet:=MovCustomDlg(Application.MainForm,'WARNING','Stock Move',WMsg,mtWarning,[mbYes,mbNo]);

        end
        else
        Begin

            WMsg:=ConCat(WMsg,'This move instruction will be added to the list of moves and will need to be processed.',#13);

          mbRet:=CustomDlg(Application.MainForm,'Please Confirm','Stock Move',WMsg,mtConfirmation,[mbYes,mbNo]);

        end;


        Set_BackThreadMVisible(BOff);

        Result:=(mbRet=mrOk);

        If (Result) then
        Begin
          If (Result) then
          Begin
            If (UseMoveList) then
            begin
              Result:=AddMove2List(MoveRec);
              //PR: 18/05/2017 ABSEXCH-18683 v2017 R1 Release process lock - it will be
              //                                      set again when list is processed
              if Assigned(Application.Mainform) then
                 SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plMoveStock), 0);

            end
            else
              Result:=AddMove2Thread(Self,MoveRec);

          end;

          FNeedToReleaseProcessLock := False;
        end;

      end; {With..}
    finally
      Dispose(MoveRec);

     end;
  end;


  procedure TStkView.RefreshMove(WhichNode  :  Integer);

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


  Procedure TStkView.Alter_Total(Const PIdx1 :  Integer;
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

Function TStkView.FindXONC(Const NC1  :  Str20)  :  Integer;

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

Procedure TStkView.Update_TotalMove(Const NC1,NC2     :  Str20;
                                    Const CalcMode    :  Boolean;
                                          MoveRecPtr  :  Pointer);

Var
  PIdx1, PIdx2,
  NewIdx        :  Integer;
  ONomRec       :  ^OutNomType;
  MoveRec       :  MoveRepPtr;


Begin
  PIdx1:=-1; PIdx2:=-1;  NewIdx:=-1;

  MoveRec:=MoveRecPtr;

  Add2.Enabled:=Not CalcMode; {Disable add whilst move is under way}
  Add1.Enabled:=Add2.Enabled;
  Edit1.Enabled:=Add2.Enabled;

  If (Assigned(MoveRec)) then
  With MoveRec^do
  Begin

    If (Not CalcMode) and (MoveMode=4) then
    Begin
      If (MoveSCode<>'') then {* Renumber local copy in NLOLine}
      Begin
        NewIdx:=FindxONC(MoveSCode);

        If (NewIdx>=0) then
        Begin
          ONomRec:=NLOLine.Items[NewIdx].Data;
          ONomRec^.OutStkCode:=NewSCode;

        end;
      end;

      {RefreshMove(MoveItemParent); {* This has been disabled since it could be very confusing to have things collapse etc whilst you were still moving about. *}

    end;
  end; {If..}

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
    ChildNom.Update_TotalMove(NC1,NC2,CalcMode,MoveRecPtr);
end;



Procedure TStkView.HideAll_Totals(Const HideValues  :  Boolean);

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

Procedure TStkView.Update_Total4Thread(RecAddr  :  LongInt;
                                       CalcMode :  Boolean);

Var
  MoveRec  :  MoveRepPtr;

Begin
  MoveRec:=Pointer(RecAddr);

  If (Assigned(MoveRec)) then
  With MoveRec^ do
  Begin

    Update_TotalMove(WasSGrp,NewSGrp,CalcMode,MoveRec);

    If (Not CalcMode) then
      Dispose(MoveRec);
  end
  else
  Begin {Hide all, could be coming from Move List}

  HideAll_Totals(CalcMode);

  end;

end;


{$ENDIF}

// CA  05/06/2012   v7.0  ABSEXCH-12452: Required for user settings   Stock Tree - Type and Code Options
Function TStkView.Get_PWDefaults(PLogin  :  Str10)  :  tPassDefType;
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

procedure TStkView.SetChildMove;

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


procedure TStkView.Move1Click(Sender: TObject);
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
                 if not GetProcessLock(plMoveStock) then
                   EXIT;
                 MoveItem:=SelectedItem;
                 MoveItemParent:=Items[MoveItem].Parent.Index;
                 MoveMode:=Not MoveMode;
                 LastCursor:=Cursor;

                 If (Not MoveAskList) then
                 Begin
                   UseMoveList:=(CustomDlg(Application.MainForm,'Please Confirm','Stock Move',
                                          'Do you wish to compile a list of moves to be processed later or move codes individually using drag and drop?'+#13+#13+
                                          'Choose [Yes] to compile a list, or [No] to move the codes individually.',mtConfirmation,[mbYes,mbNo,mbCancel])=mrOk);


                   MoveAskList:=BOn;

                   MoveList1.Visible:=UseMoveList;
                 end;

                 Cursor:=crDrag;
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

                         {* Changes here need to be relected in the 4: section for the child control *}
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
                   SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plMoveStock), 0);
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



procedure TStkView.MoveList1Click(Sender: TObject);
begin
  Set_LocalMode(2);

  If (Not Assigned(MoveGLList)) then
    MoveGLList:=TMoveLTList.Create(Self);

  Try

    With MoveGLList do
      Show;

  Except
    FreeandNil(MoveGLList)

  end; {Try..}

end;


Function TStkView.AddMove2List(MoveRec  :  MoveRepPtr)  :  Boolean;

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;


Begin
  Result:=BOff;

  With ExLocal,LPassword,MoveStkRec, MoveRec^ do
  Begin
    LResetRec(Fnum);

    RecPfix:=MoveNomTCode;

    SubType:=MNSubCode(2);

    MoveCode:=MoveStk.StockCode;
    MFromCode:=MoveStk.StockCat;
    MToCode:=GrpStk.StockCode;

    MStkCode:=MoveCode;

    Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

    Result:=StatusOk;
      
    Report_BError(Fnum,Status);

    If (Not Assigned(MoveGLList)) then
      MoveList1Click(Nil);

    If (Assigned(MoveGLList)) then
    Begin
      MoveGLList.Exlocal.LPassword:=LPassword;

      PostMessage(MoveGLList.Handle,WM_CustGetRec,116,0);

    end;

  end;
end;


Procedure TStkView.RestartView;

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

    Add_OutLines(0,2,0,'','',BOff,StockF,StkCatK);

    NLOline.Refresh;

    If (Assigned(ChildNom)) and (InChild) then
      ChildNom.RestartView;

  finally
    NLOLine.Enabled:=BOn;
    OptBtn.Enabled:=BOn;
    Cursor:=LastCursor;
  end; {Try..}
end;



procedure TStkView.Show1Click(Sender: TObject);
begin
  FiltNType:=Not FiltNType;

  Show1.Checked:=FiltNType;

  Update_OutLines(StockF,StkCodeK);

end;

procedure TStkView.ShowSC1Click(Sender: TObject);
begin
  ShowSCCode:=Not ShowSCCode;

  ShowSC1.Checked:=ShowSCCode;

  Update_OutLines(StockF,StkCodeK);

end;


procedure TStkView.OptSpeedClick(Sender: TObject);
Var
  Locked  :  Boolean;

begin

  Locked:=BOn;

  Begin


    If (GetMultiSys(BOn,Locked,SysR)) then
    Begin
      Syss.BigStkTree:=Not Syss.BigStkTree;

      PutMultiSys(SysR,BOn);
    end;

    OptSpeed.Checked:=Syss.BigStkTree;

  end;

end;




procedure TStkView.ShowQSoldClick(Sender: TObject);
Var
  Locked  :  Boolean;

begin

  Locked:=BOn;

  ShowQty:=Not ShowQty;

  If (GetMultiSys(BOn,Locked,SysR)) then
  Begin
    Syss.ShowQtySTree:=ShowQty;

    PutMultiSys(SysR,BOn);
  end;

  ShowQSold.Checked:=ShowQty;

  CreateGPCaption;

  Update_OutLines(StockF,StkCodeK);

end;

// -----------------------------------------------------------------------------
// CJS: 14/12/2010 - Amendments for new Window Settings system

procedure TStkView.EditWindowSettings;
begin
  if (FSettings.Edit(self, NLOLine) = mrOK) then
  Begin
    NLOLine.TreeColor   := NLOLine.Font.Color;
    NeedCUpdate := True;
  End;
end;

// -----------------------------------------------------------------------------

procedure TStkView.LoadWindowSettings;
begin
  if Assigned(FSettings) then
  begin
    FSettings.LoadSettings;
    if not FSettings.UseDefaults then
    begin
      FSettings.SettingsToWindow(self);
      FSettings.SettingsToParent(self);
      NLOLine.TreeColor   := NLOLine.Font.Color;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TStkView.SaveWindowSettings;
begin
  if Assigned(FSettings) and NeedCUpdate then
  begin
    FSettings.WindowToSettings(self);
    FSettings.SaveSettings(StoreCoord);
  end;
  FSettings := nil;
end;

// -----------------------------------------------------------------------------
//PR: 13/07/2012 v7.0 ABSEXCH-11178: Check the parent nodes are expanded, otherwise opening the child will crash. Copied from JobTree
procedure TStkView.OpenParentNodes(const ParentNode: TSBSOutlNode);
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
End; // OpenParentNodesend;

//-------------------------------------------------------------------------

procedure TStkView.FormDestroy(Sender: TObject);
begin
  //PR: 18/05/2017 ABSEXCH-18683 v2017 R1 If we've started a move, then
  //closed the window without completing it we need to remove the process lock
  if FNeedToReleaseProcessLock then
    if Assigned(Application.Mainform) then
       SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plMoveStock), 0);
end;

end.
