unit WORIWizU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Wiztempu, StdCtrls, TEditVal, TCustom, ExtCtrls, SBSPanel, ComCtrls,
  Mask, BorBtns,
  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  GlobVar,VarConst, ExWrap1U,
  BTSupU1,
  Grids, SBSOutl, Menus, WOPCT1U;


type
  TWORBuildWizard = class(TWizTemplate)
    Label82: Label8;
    Label818: Label8;
    TWFinBtn: TSBSButton;
    TabSheet3: TTabSheet;
    BO: Text8Pt;
    A1SCodef: Text8Pt;
    A1QIF: TCurrencyEdit;
    Label89: Label8;
    A1QOF: TCurrencyEdit;
    Label814: Label8;
    Label811: Label8;
    Label812: Label8;
    A1CBF: TCurrencyEdit;
    A1LOF: Text8Pt;
    LocLab: Label8;
    A1LIF: Text8Pt;
    Label813: Label8;
    A1CompF: Text8Pt;
    Label84: Label8;
    I1YrRef2L: Label8;
    A1RefF: Text8Pt;
    A1AccF: Text8Pt;
    Label83: Label8;
    Image3: TImage;
    NLDPanel: TPanel;
    NLCrPanel: TPanel;
    NLDrPanel: TPanel;
    NLOLine: TSBSOutlineB;
    SBSPanel5: TSBSPanel;
    Bevel7: TBevel;
    BOMTimeLab: Label8;
    OptBtn: TButton;
    BOMTimePanel: TPanel;
    A1CCF: Text8Pt;
    CCLab: Label8;
    DepLab: Label8;
    A1DpF: Text8Pt;
    Bevel1: TBevel;
    Panel1: TPanel;
    Label816: Label8;
    Label817: Label8;
    A1MEQF: TCurrencyEdit;
    PopupMenu3: TPopupMenu;
    MIRec: TMenuItem;
    Links2: TMenuItem;
    Expand1: TMenuItem;
    MIETL: TMenuItem;
    MIEAL: TMenuItem;
    EntireGeneralLedger1: TMenuItem;
    MIColl: TMenuItem;
    MICTL: TMenuItem;
    EntireGeneralLedger2: TMenuItem;
    CBAPickF: TBorCheck;
    CBCNoteF: TBorCheck;
    CBSWOF: TBorCheck;
    Label815: Label8;
    CBSNoteF: TBorCheck;
    TabSheet4: TTabSheet;
    Label87: Label8;
    Label810: Label8;
    Label819: Label8;
    Label88: Label8;
    Label85: Label8;
    CBQM1F: TBorRadio;
    CBQM2F: TBorRadio;
    CBQWOF: TBorCheck;
    CBLPF: TBorCheck;
    CBQM3F: TBorRadio;
    CBQM0F: TBorRadio;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label820: Label8;
    Label821: Label8;
    A1CompDF: TEditDate;
    Label822: Label8;
    A1TagF: TCurrencyEdit;
    Bevel4: TBevel;
    CBASLF: TSBSComboBox;
    CBDefLocF: TBorCheck;
    CBDefCCDF: TBorCheck;
    N1: TMenuItem;
    Build1: TMenuItem;
    Build2: TMenuItem;
    N2: TMenuItem;
    A1StartDF: TEditDate;
    Label823: Label8;
    A2CompDF: TEditDate;
    Label824: Label8;
    Image5: TImage;
    Label826: Label8;
    CBCUDF: TBorCheck;
    CBAWF: TBorCheck;
    Label825: Label8;
    procedure FormCreate(Sender: TObject);
    procedure TWPrevBtnClick(Sender: TObject);
    procedure TWFinBtnClick(Sender: TObject);
    procedure ECIEPFExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TWClsBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure A1SCodefExit(Sender: TObject);
    procedure A1LOFExit(Sender: TObject);
    procedure A1CCFExit(Sender: TObject);
    procedure MIEALClick(Sender: TObject);

    procedure OptBtnClick(Sender: TObject);

    procedure NLOLineExpand(Sender: TObject; Index: Longint);

    procedure NLOLineNeedValue(Sender: TObject);

    procedure NLOLineUpdateNode(Sender: TObject;
                            var Node: TSBSOutLNode; Row: Integer);
    procedure MIRecClick(Sender: TObject);
    procedure A1QIFExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Label85Click(Sender: TObject);
    procedure NLOLineNodeChkHotSpot(Sender: TObject;
      var Node: TSBSOutLNode; Row: Integer);
    procedure Build1Click(Sender: TObject);
    procedure A2CompDFExit(Sender: TObject);
    procedure A1StartDFExit(Sender: TObject);
    procedure Links2Click(Sender: TObject);
    procedure A1CompDFExit(Sender: TObject);
    procedure CBLPFClick(Sender: TObject);

  private
    { Private declarations }
    InFormCreate,
    fFrmClosing,
    fDoingClose,
    fGotChilds,
    InBom,
    InHotSpot,
    InExpand

               :       Boolean;
    OldB2BCtrl,
    B2BCtrl    :       B2BInpRec;

    fSetPageCount,
    Lab1Ofset,
    Lab2Ofset,
    Lab3Ofset,
    Lab4Ofset,
    ChrWidth,
    TotalNodes,
    TotalBOMTime,
    BOMFolio   :       LongInt;

    EditedTime :       TDateTime;

    ExLocal    :       TdExLocal;

    ChrsXross  :   Double;

    ColXAry    :   Array[1..2] of LongInt;

    RunCtrl    :   tWORGen;

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}

    // CJS 2013-10-07 - MRD1.1.21 - Consumer Support
    WasConsumer: Boolean;
    TraderCode: string[10];

    procedure FormDesign;

    procedure CheckGotChild;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    procedure OutWizard;

    procedure Form2Wizard;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure Display_GlobalTrans(Mode  :  Byte);

    procedure Display_Trans(Mode  :  Byte);

    Function Refresh_BOMTree  :  Boolean;

    Procedure OutCost;

    Procedure ClearBOMPage;

    Function FormatLine(ONomRec  :  OutNomType;
                        LineText :  String)  :  String;

    Function CalcChildBuild(StockR  :  StockRec;
                            QtyPer,
                            ThisBuildQty
                                    :  Double)  :  Double;

    procedure BOMBuildPage;

    Procedure Add_OutLines(Depth,
                           DepthLimit,
                           OIndex,
                           StkFolio      :   LongInt;
                           BuildQty      :   Double;
                     Const Fnum,
                           Keypath       :   Integer);

    Procedure Update_OutLines(Const Fnum,
                                    Keypath       :   Integer);

    Procedure Drill_OutLines(Depth,
                             DepthLimit,
                             PIndex      :  LongInt);

    Procedure Delete_OutLines(PIndex      :  LongInt;
                              DelSelf     :  Boolean);

    Procedure AddEditLine(Edit,
                          DelMode  :  Boolean);

    function FindNode(NCode  :  LongInt)  :  Integer;

    procedure EditBuild(SelItem  :  Integer);


    Function GetSelBOM  :  Boolean;


    Function GetChildBuildCount  :  Integer;


    procedure Generate_ChildWOR(WORInv     :  InvRec;
                                WORStkRec  :  StockRec;
                            Var LastMatchLine
                                           :  LongInt;
                                SingleChild:  Boolean);

    procedure Generate_WORChildren(WORInv     :  InvRec;
                                   NodeIdx    :  Integer;
                                   SingleChild:  Boolean);


    procedure UpdateNodeBuildStatus(Var Node    : TSBSOutLNode;
                                        ONomRec : OutNomType;
                                        State,
                                        LeaveCB : Boolean);

    procedure SetThisNode(Index,Level  :  Integer;
                          State        :  Boolean);

    Function CalcCompDate(Mode      :  Byte;
                          InDate    :  String)  :  LongDate;

  public
    { Public declarations }

    SORInv     :       InvRec;
    SORLine    :       Idetail;
    SORAddr    :       LongInt;
    WORMode    :       Byte;
    FromStkRO  :       Boolean;

    Function GetPageCount  :  Integer; Override;

    procedure Link2db;


    procedure TryFinishWizard;



  end;


Procedure Run_WORWizard(LInv    :  InvRec;
                        LId     :  IDetail;
                        WMode   :  Byte;
                        AOWner  :  TWinControl);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  VarRec2U,
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BTSupU2,
  BTKeys1U,
  InvListU,
  Exthrd2U,
  SysU1,
  SysU2,
  CMPCtrlU,
  SOPCT3U,

  {$IFDEF SOP}
    InvLst3U,
  {$ENDIF}

  SCRTCH2U,
  ExBtTh1U,
  PassWR2U,
  SBSComp2,
  WOPWizIU,
  DelvRunU,
  {$IFDEF Ltr}
    MSWord95,
  {$ENDIF}

  Tranl1U,
  ObjDrilU,
  SOPCT5U,

  // CJS 2013-10-07 - MRD1.1.21 - Consumer Support
  ConsumerUtils;

{$R *.DFM}


Const
  InitWidth  =  118;
  TDpth      =  70;


Var
  LocalInv   :  ^InvRec;
  LocalId    :  ^Idetail;
  LocalSORAddr
             :  LongInt;
  LocalMode  :  Byte;
  WORWizard  :  TWORBuildWizard;
  WORWActive :  Boolean;



Procedure Set_WORInv(LInv  :  InvRec;
                     LId   :  IDetail;
                     WMode :  Byte;
                     LAddr :  LongInt);

Begin
  If (Not Assigned(LocalInv)) then
    New(LocalInv);

  LocalInv^:=LInv;

  If (Not Assigned(LocalId)) then
    New(LocalId);

  LocalId^:=LId;

  If (LocalSORAddr<>LAddr) then
    LocalSORAddr:=LAddr;

  If (LocalMode<>WMode) then
    LocalMode:=WMode;

end;

procedure TWORBuildWizard.FormCreate(Sender: TObject);

Const
  BRES   :  Array[0..1] of PChar  = ('B2BRADIO','B2BTICK');


Var
  n  :  Integer;
  BMap1
     :  TBitMap;

  RectD
     :  TRect;


begin
  WORWActive:=BOn;  InFormCreate:=BOn;  fGotChilds:=FullWOP;;

  fSetPageCount:=4; {Set this here as other wise wizard will show prev button}

  inherited;

  ReEnable:=BOn;

  ExLocal.Create;

  fDoingClose:=BOff;
  fFrmClosing:=BOff;

  FromStkRO:=BOff;

  SORInv:=LocalInv^;
  SORLine:=LocalId^;
  SORAddr:=LocalSORAddr;
  WORMode:=LocalMode;


  With PageControl1 do
  Begin
    Lab1Ofset:=Width-(NLDPanel.Width);
    Lab2Ofset:=Width-NLCrPanel.Left;
    Lab3Ofset:=Width-NLDrPanel.Left;

    ChrWidth:=InitWidth;

    ChrsXRoss:=(ChrWidth/Width);
  end;

  {ChrWidth:=InitWidth;

  ChrsXRoss:=(ChrWidth/Width);}

  With ExLocal do
  Begin
    LInv:=SORInv;
    LId:=SORLine;
  end;

  For n:=0 to PageControl1.PageCount-1 do {Hide Tabs}
  With PageControl1 do
  Begin
    If (Assigned(Pages[n])) then
    Begin
      Pages[n].TabVisible:=BOff;
      Pages[n].Visible:=BOn;
    end;

  end; {Loop}

  fSetPageCount:=PageControl1.PageCount;

  PageControl1.ActivePage:=TabSheet1;

  LastValueObj.GetAllLastValuesFull(Self);
  
  B2BCtrl:=Get_LastB2BVal(FullB2BKey(AllocB2BICode,-2,EntryRec^.Login),-2);

  With B2BCtrl do
  Begin
    WStartDate:=Today;
    WORTagNo:=SORInv.Tagged;
    WORRef:='';
  end;

  A1RefF.Text:='';
  
  Blank(RunCtrl,SizeOf(RunCtrl));

  RunCtrl.LastMatchLine:=1;

  OldB2BCtrl:=B2BCtrl;

  InBOM:=BOff; InHotSpot:=BOff; InExpand:=BOff;

  EditedTime:=Now;

  BOMFolio:=0;

  FormDesign;

  Image3.Visible:=BOff;

  OutWizard;
  SetStepCaption;


  If (WORMode<>0) then
  Begin
    Label86.Caption:='Works Order for '+SORInv.OurRef;
    Label82.Caption:='Generate a Works Order for '+Trim(A1SCodeF.Text)+' on '+SORInv.OurRef;
  end;

  // CJS 2013-10-07 - MRD1.1.21 - Consumer Support
  WasConsumer := False;

  InFormCreate:=BOff;
end;


Function TWORBuildWizard.GetPageCount  :  Integer;

Begin
  Result:=fSetPageCount-Ord(Not fGotChilds);

end;

procedure TWORBuildWizard.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

  WORWActive:=BOff;



  inherited;

end;



Procedure TWORBuildWizard.WMCustGetRec(Var Message  :  TMessage);

Begin


  With Message do
  Begin

    Case WParam of


     {$IFDEF Ltr}
       400,
       401  : Begin
                LetterActive:=Boff;
                LetterForm:=nil;
              end;
     {$ELSE}
       400  :  ;
     {$ENDIF}



    end; {Case..}

  end;
  Inherited;
end;



procedure TWORBuildWizard.FormDesign;

Var
  MLOCFlg  :  Boolean;

Begin
  A1QOF.DecPlaces:=Syss.NoQtyDec;
  A1QIF.DecPlaces:=Syss.NoQtyDec;
  A1CBF.DecPlaces:=Syss.NoQtyDec;
  A1MEQF.DecPlaces:=Syss.NoQtyDec;

  if Syss.ssConsumersEnabled then
    A1AccF.Width := 252
  else
    A1AccF.Width := 80;
    
  // Force a re-positioning of the drop-down/pop-up arrows
  A1AccF.PosArrows;

  With B2BCtrl do
  Begin
    {$IFDEF SOP}

      MLocFlg:=Syss.UseMLoc;

    {$ELSE}

      MLocFlg:=BOff;


    {$ENDIF}
  end;


  If (Not MLocFlg) then
  Begin
    A1LOF.Visible:=BOff;
    A1LIF.Visible:=BOff;
    LocLab.Visible:=BOff;
    Label813.Visible:=BOff;
    CBDefLocF.Visible:=BOff;
  end;

  MLocFlg:=Syss.USeCCDep;


  If (Not MLocFlg) then
  Begin
    A1CCF.Visible:=BOff;
    A1DpF.Visible:=BOff;
    CCLab.Visible:=BOff;
    DepLab.Visible:=BOff;
    CBDefCCDF.Visible:=BOff;
  end;


  If (WORMode<>0) then
  Begin
    A1SCodeF.ReadOnly:=BOn;
    A1SCodeF.TabStop:=BOff;
    A1SCodeF.Color:=clBtnFace;

    A1AccF.ReadOnly:=BOn;
    A1AccF.TabStop:=BOff;
    A1AccF.Color:=clBtnFace;

    A1LIf.Tag:=0;
    A1LIf.ReadOnly:=BOn;
    A1LIf.TabStop:=BOff;
    A1LIf.Color:=clBtnFace;

    Self.ActiveControl:=A1QIF;
  end
  else
  Begin

    Self.ActiveControl:=A1SCodeF;

  end;


  CBAPickF.Visible:=(Not StdWOP);{ or ((WORMode<>0) and (SORInv.InvDocHed=SOR));}

end;


procedure TWORBuildWizard.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  ONomRec      :  ^OutNomType;

  n            :  Integer;

begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    With NLOLine do {* Tidy up attached objects *}
    Begin
      For n:=1 to ItemCount do
      Begin
        ONomRec:=Items[n].Data;
        If (ONomRec<>nil) then
          Dispose(ONomRec);
      end;
    end;

    inherited;


  end;
end;




procedure TWORBuildWizard.CheckGotChild;

Begin
  With ExLocal do
  Begin

    If (FullWOP) then
      fGotChilds:=ContainsChildBom(LStock,0)
    else
      fGotChilds:=BOff;

    {Bevel1.Visible:=fGotChilds;
    Label810.Visible:=fGotChilds;
    Label88.Visible:=fGotChilds;
    Label87.Visible:=fGotChilds;
    CBQWoF.Visible:=fGotChilds;
    CBQM0F.Visible:=fGotChilds;
    CBQM1F.Visible:=fGotChilds;
    CBQM1F.Visible:=fGotChilds;
    CBQM2F.Visible:=fGotChilds;
    CBQM3F.Visible:=fGotChilds;
    CBLPF.Visible:=fGotChilds;
    Image2.Visible:=fGotChilds;}

    TabSheet4.Visible:=fGotChilds;

    If (WORMode=0)  then
    Begin

      {TabSheet2.Visible:=fGotChilds;}

      CBSWOF.Checked:=BOn; {Force Display at end of a single WOR being generated}

      CBCNoteF.Visible:=BOff;

      CBCUDF.Visible:=BOff;


    end;

    CBAPickF.Visible:=(Not STDWOP) and ((fGotChilds) or ((WORMode<>0) and (SORInv.InvDocHed In [SOR,WOR])));

    fSetPageCount:=3+Ord(fGotChilds);
    SetWizButtons;
    SetStepCaption;
    TWNextBtn.Visible:=Not IsFinish;

  end;
end;

procedure TWORBuildWizard.Link2db;

Var
  LocalCCDep  :  CCDepType;

Begin
  If Global_GetMainRec(StockF,A1SCodeF.Text) then
  Begin
    ExLocal.AssignFromGlobal(StockF);

    If (WORMode=0) or (SORLine.Desc='') then
      Bo.Text:=Stock.Desc[1]
    else
      Bo.Text:=SORLine.Desc;

    A1QOF.Value:=FreeStock(Stock);
    A1CBF.Value:=HowManyBOM(Stock,BOff,BOn,'',1);
    A1LOf.Text:=Stock.DefMLoc;

    LocalCCDep:=GetProfileCCDep('','',Stock.CCDep,SORLine.CCDep,1);

    If (LocalCCDep[BOn]<>'') then
      A1CCF.Text:=LocalCCDep[BOn];

    If (LocalCCDep[BOff]<>'') then
      A1DpF.Text:=LocalCCDep[BOff];

    A1MEQF.Value:=Stock.MinEccQty;





    CheckGotChild;
  end
  else
  Begin
    Bo.Text:='';
    A1QOF.Value:=0.0;
    A1CBF.Value:=0.0;
    A1LOf.Text:='';
    A1CCF.Text:='';
    A1DpF.Text:='';

  end;

  // CJS 2013-10-08 - MRD1.1.21 - Consumer Support
  If Global_GetMainRec(CustF, A1AccF.Text) then
  begin
    A1CompF.Text := Cust.Company;
    // Store the short code
    TraderCode   := Cust.CustCode;
    // If this is a consumer, display the long code, otherwise leave the
    // displayed code unchanged
    if IsConsumer(Cust) then
    begin
      A1AccF.Text := Cust.acLongACCode;
    end;
  end
  else
    A1CompF.Text:='';


end;

procedure TWORBuildWizard.OutWizard;

Begin
  With B2BCtrl do
  Begin
    If (WORMode<>0) then
    Begin
      A1SCodeF.Text:=SORLine.StockCode;

      If (SORLine.IdDocHed=WOR) then {Don't multiply by qtymul as this is qty per!}
        A1QIF.Value:=Qty_OS(SORLine)
      else
        A1QIF.Value:=Qty_OS(SORLine)*SORLine.QtyMul;
        
      A1LIF.Text:=SORLine.MLocStk;

      A1CCF.Text:=SORLine.CCDep[BOn];
      A1DpF.Text:=SORLine.CCDep[BOff];


    end
    else
    Begin
      If (InFormCreate) then
      Begin
        A1QIF.Value:=1.0;
      end;
    end;

    A1AccF.Text:=SORInv.CustCode;

    Link2db;

    B2BCtrl.BuildQty:=A1QIF.Value;

    OutCost;


    A1LOF.Text:=Trim(LocOR);

    If (A1LIF.Text='') then
      A1LIF.Text:=Trim(LocIR);

    CBAPickF.Checked:=AutoPick;
    CBCNoteF.Checked:=ExcludeBOM;

    CBCUDF.Checked:=CopySORUDF;

    CBSNoteF.Checked:=CopyStkNote;

    CBQWOF.Checked:=BWOQty;

    CBQM0F.Checked:=(QtyMode=0);
    CBQM1F.Checked:=(QtyMode=1);
    CBQM2F.Checked:=(QtyMode=2);
    CBQM3F.Checked:=(QtyMode=3);
    CBLPF.Checked:=LessFStk;
    CBAWF.Checked:=LessA2WOR;

    CBDefLocF.Checked:=UseDefLoc;
    CBDefCCDF.Checked:=UseDefCCDep;

    If (AutoSetChilds>=0) then
      CBASLF.ItemIndex:=AutoSetChilds;

    CBSWOF.Checked:=UseOnOrder;

    A1CompDF.DateValue:=WCompDate;

    A1StartDF.DateValue:=WStartDate;

    A1TagF.Value:=WORTagNo;



  end; {With..}
end;



procedure TWORBuildWizard.Form2Wizard;

Begin
  With B2BCtrl do
  Begin
    WORBOMCode:=FullStockCode(A1SCodeF.Text);
    BuildQty:=A1QIF.Value;
    WORRef:=A1RefF.Text;
    LocOR:=A1LOF.Text;
    LocIR:=A1LIF.Text;

    AutoPick:=CBAPickF.Checked;
    ExcludeBOM:=CBCNoteF.Checked;

    CopySORUDF:=CBCUDF.Checked;

    CopyStkNote:=CBSNoteF.Checked;

    DefCCDep[BOn]:=A1CCF.Text;
    DefCCDep[BOff]:=A1DpF.Text;

    QtyMode:=(1*Ord(CBQM1F.Checked))+(2*Ord(CBQM2F.Checked))+(3*Ord(CBQM3F.Checked));

    BWOQty:=CBQWOF.Checked;
    LessFStk:=CBLPF.Checked;
    LessA2WOR:=CBAWF.Checked;
    UseDefLoc:=CBDefLocF.Checked;
    UseDefCCDep:=CBDefCCDF.Checked;

    // CJS 2013-10-08 - MRD1.1.21 - Consumer Support - use the short code, not
    // the displayed code (which might be a long Consumer code)
    SuppCode := FullCustCode(TraderCode);

    If (CBASLF.ItemIndex>=0) then
      AutoSetChilds:=CBASLF.ItemIndex;

    UseOnOrder:=CBSWOF.Checked;

    WCompDate:=A1CompDF.DateValue;

    WStartDate:=A1StartDF.DateValue;

    WORTagNo:=Round(A1TagF.Value);


    GenOrder:=0;

    If (Not CBAPickF.Visible) then
      AutoPick:=BOff;

  end; {With..}
end;




procedure TWORBuildWizard.TWPrevBtnClick(Sender: TObject);


Var
  AllowChange
            :  Boolean;
  NewIndex  :  Integer;

begin
  // MH 15/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on fields which processes the text and updates the value
  If (Sender = TWNextBtn) And (ActiveControl <> TWNextBtn) And TWNextBtn.CanFocus Then
    TWNextBtn.SetFocus;

  AllowChange:=BOn;

  NewIndex:=pcLivePage(Sender);

  If (NewIndex In [0]) then
  Begin
    Form2Wizard;

    AllowChange:=CheckCompleted(BOff,BOff);
  end;

  If (AllowChange) then
  Begin
    inherited;

    TWNextBtn.Visible:=Not IsFinish;

    PageControl1Change(PageControl1);
  end;
end;


procedure TWORBuildWizard.ECIEPFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (AltMod) and (ActiveControl<>TWClsBtn)  and (FoundCode<>'') then
    Begin

      StillEdit:=BOn;

      // CJS 2013-10-07 - MRD1.1.21 - Consumer Support
      if WasConsumer then
      begin
        if Copy(FoundCode, 1, 1) <> CONSUMER_PREFIX then
          FoundCode := CONSUMER_PREFIX + FoundCode;
      end;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,0));

      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        // CJS 2013-10-08 - MRD1.1.21 - Consumer Support
        // Store the short code, and for Consumers display the long code
        TraderCode := Cust.CustCode;
        if IsConsumer(Cust) then
        begin
          Text := Cust.acLongAcCode;
          WasConsumer := True;
        end
        else
        begin
          Text := FoundCode;
          WasConsumer := False;
        end;

        A1CompF.Text:=Cust.Company;

        A1TagF.Value:=Cust.DefTagNo;

      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;







procedure TWORBuildWizard.A1SCodefExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  Rnum       :  Double;



begin

  Rnum:=0;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    Form2Wizard;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>TWClsBtn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetStock(Self,FoundCode,FoundCode,2));

      If (FoundOk) then {* Credit Check *}
      With Stock do
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;


        If (WORMode=0) then
          If (Stock.MinEccQty<>0.0) then
            A1QIF.Value:=Stock.MinEccQty;

        OutWizard;

        Begin


          SendToObjectStkEnq(FoundCode,B2BCtrl.LOCIR,'',-1,-1,0);


        end;

      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;

procedure TWORBuildWizard.A1QIFExit(Sender: TObject);
Var
  AltMod     :  Boolean;

  mbRet      :  Word;


begin

  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit) do
  Begin
    AltMod:=Modified;

    If ((Value<A1MEQF.Value) and (A1MEQF.Value>0)) and (ActiveControl<>TWClsBtn) then
    Begin
      mbRet:=MessageDlg('Please confirm you do not wish to build the minimum economical qty of '+Form_Real(A1MEQF.Value,0,Syss.NoQtyDec),
                        mtConfirmation,[mbYes,mbNo],0);

      If (mbRet=mrNo) then
        Value:=A1MEQF.Value;

    end;

    B2BCtrl.BuildQty:=Value;

    OutCost;

    A1CompDF.DateValue:=CalcCompDate(0,A1CompDF.DateValue);


  end; {with..}
end;

Function TWORBuildWizard.CalcCompDate(Mode      :  Byte;
                                      InDate    :  String)  :  LongDate;

Var
  LDays,
  AddTime              :  LongInt;
  Days,Hrs,Mins        :  Extended;

Begin
  Result:=InDate;

  With ExLocal,LStock do
  If (CalcProdTime) then
  Begin
    Case Mode of
      0,10:  Addtime:=Round(ProdTime*B2BCtrl.BuildQty);
      1,11:  AddTime:=TotalBOMTime;
    end;

    Time2Mins(AddTime,Days,Hrs,Mins,0);

    LDays:=Round(Days);

    If (Mode In [10,11]) then {Take time off}
      Result:=CalcDueDatexDays(A1CompDF.DateValue,LDays*DocNotCnst)
    else
      Result:=CalcDueDatexDays(A1StartDF.DateValue,LDays);
  end;

end;




procedure TWORBuildWizard.A1LOFExit(Sender: TObject);
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

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>TWClsBtn) and (ActiveControl<>TWFinBtn)
          and  (Syss.UseMLoc) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetMLoc(Self,FoundCode,FoundCode,SCode,77));

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

    end; {with..}
  {$ENDIF}
end;



procedure TWORBuildWizard.A1CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin

  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);


      If ((AltMod) or (FoundCode='')) and (ActiveControl<>TWClsBtn) and (Syss.UseCCDep) then
      Begin

        StillEdit:=BOn;
        //TG-29-05-2017- ABSEXCH-18684- Inactive CC/Dep gets display in 'Cost Centre/Department Search List'.
        FoundOk:=(GetCCDep(Self,FoundCode,FoundCode,IsCC,2));


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

    end; {with..}
  {$ENDIF}
end;


procedure TWORBuildWizard.A2CompDFExit(Sender: TObject);

begin
  If (Sender is TEditDate) then
  With (Sender as TEditDate) do
  Begin

    If (ActiveControl<>TWClsBtn) then
      A1CompDF.DateValue:=DateValue
  end; {With..}

end;

procedure TWORBuildWizard.A1StartDFExit(Sender: TObject);


begin
  If (Sender is TEditDate) then
  With (Sender as TEditDate) do
  Begin

    If (Modified) and (ActiveControl<>TWClsBtn) then
      A1CompDF.DateValue:=CalcCompDate(0,A1CompDF.DateValue);

  end; {With..}

end;

procedure TWORBuildWizard.A1CompDFExit(Sender: TObject);
Var
  FromBDate  :  Boolean;
begin
  If (Sender is TEditDate) then
  With (Sender as TEditDate) do
  Begin

    If (Modified) and (ActiveControl<>TWClsBtn) then
    Begin
      FromBDate:=(Sender=A2CompDf);

      If (FromBDate) then
        A2CompDFExit(Sender);

      A1StartDF.DateValue:=CalcCompDate(10+Ord(FromBDate),A1StartDF.DateValue);

    end;

  end; {With..}

end;


{ ======= Link to Trans display ======== }

procedure TWORBuildWizard.Display_GlobalTrans(Mode  :  Byte);

Begin

  ExLocal.LastInv:=ExLocal.LInv;

  ExLocal.AssignFromGlobal(InvF);

  With TFInvDisplay.Create(Application.MainForm) do
  Begin

    try

      With ExLocal do
      Begin
        LastDocHed:=LInv.InvDocHed;

        Display_Trans(Mode,0,BOff,BOn);

      end; {with..}

    except

      Free;

    end;
  end;

  ExLocal.LInv:=ExLocal.LastInv;
end;


procedure TWORBuildWizard.Display_Trans(Mode  :  Byte);

Begin
  If (WORMode=0) then {Lets get it added into the daybook first, then display it}
  Begin
    

    If (Owner is TForm) and (B2BCtrl.UseOnOrder) then
      PostMessage((Self.Owner as TForm).Handle,WM_FormCloseMsg,66,0);
  end
  else
  Begin {Display via global show trans}

    If (B2BCtrl.UseOnOrder) then
      Display_GlobalTrans(Mode);


  end;

end;



Function TWORBuildWizard.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  6;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  MaxBuild,
  FoundLong
           :  LongInt;


Begin
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:=' is not a valid account code.';
  PossMsg^[2]:='You have not set a build quantity.';
  PossMsg^[3]:='The Generate From location is not valid.';
  PossMsg^[4]:='The Generate To location is not valid.';
  PossMsg^[5]:=' is not a valid Bill of Material Stock Code.';
  PossMsg^[6]:='Cost Centre/ Department Code not valid.';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;

  MaxBuild:=0;

  While (Test<=NofMsgs) and (Result) do
  With B2BCtrl do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=(Trim(SuppCode)='');

              If (Not Result) then
              Begin
                Result:=Global_GetMainRec(CustF, SuppCode);
              end;

              ExtraMsg:=Trim(SuppCode);


            end;

      2  :  Result:=(BuildQty>0.0);



      {$IFDEF PF_On}

        3  : {$IFDEF SOP}

              If (Syss.UseMLoc) then {* Check location valid *}
              Begin
                If (LocOR<>'') then
                  Result:=Global_GetMainRec(MLocF,Quick_MLKey(LocOR))
                else
                  Result:=BOff;
              end
              else
            {$ENDIF}
                Result:=BOn;

        4  : {$IFDEF SOP}

              If (Syss.UseMLoc) then {* Check location valid *}
              Begin
                If (LocIR<>'') then
                  Result:=Global_GetMainRec(MLocF,Quick_MLKey(LocIR))
                else
                  Result:=BOff;
              end
              else
            {$ENDIF}
                Result:=BOn;

        5  :  Begin
              {$IFDEF STK}


                Result:=GetStock(Self,WORBOMCode,Foundcode,-1);

                If (Result) then
                  Result:=(Stock.StockType=StkBillCode);

                ExtraMsg:=Trim(WORBOMCode);

              {$ELSE}

                Result:=BOn;

              {$ENDIF}
            end;

        6  :  Begin
                Result:=(Not Syss.UseCCDep);

                If (Not Result) then
                Begin
                  Result:=BOn;
                  For Loop:=BOff to BOn do
                  Begin

                    Result:=(GetCCDep(Self,DefCCDep[Loop],FoundCode,Loop,-1) and (Result));

                  end;
                end;

              end;


      {$ENDIF}


    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}


Function TWORBuildWizard.GetChildBuildCount  :  Integer;

Var
  n       :  Integer;
  ONomRec :  ^OutNomType;

Begin
  Result:=0;

  With NLOLine do
  Begin
    TotalNodes:=ItemCount;

    If (TotalNodes>0) then
    Begin
      For n:=1 to TotalNodes do
      Begin
        ONomRec:=Items[n].Data;

        If (ONomRec<>nil) then
        With ONomRec^ do
          Result:=Result+Ord(PRateMode)
      end;
    end;

  end;

end;


procedure TWORBuildWizard.Generate_ChildWOR(WORInv     :  InvRec;
                                            WORStkRec  :  StockRec;
                                        Var LastMatchLine
                                                       :  LongInt;
                                            SingleChild:  Boolean);


Const
  Fnum     =  IdetailF;
  Keypath  =  IdLinkK;


Var
  KeyS,
  KeyChk  :  Str255;

  WORLine :  IDetail;

  FoundOk :  Boolean;


Begin
  If (Not SingleChild) then
  Begin
    With WORInv do
    Begin
      KeyChk:=FullNomKey(FolioNum);

      KeyS:=FullIdKey(FolioNum,LastMatchLine);
    end;

    FoundOk:=BOff;

    Status:=Find_Rec(B_GetGretr,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With Id do
    Begin
      FoundOk:=(CheckKey(WORStkRec.StockCode,StockCode,Length(WORStkRec.StockCode),BOff));

      If (Not FoundOk) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end;
  end
  else
  Begin
    FillChar(WORInv,Sizeof(WORInv),#0); {Create the WOR, /but don't attach it to the original}
    ResetRec(IdetailF);
    FoundOk:=BOn;
  end;

  If (FoundOk) then
  Begin
    WORLine:=Id;

    If (Not SingleChild) then
      LastMatchLine:=Id.ABSLineNo;

    Generate_WOR(WORInv,WORLine,WORStkRec,B2BCtrl,RunCtrl);

  end; {If new generated line ok}
end;


procedure TWORBuildWizard.Generate_WORChildren(WORInv     :  InvRec;
                                               NodeIdx    :  Integer;
                                               SingleChild:  Boolean);


Const
  Fnum     =  IdetailF;
  Keypath  =  IdFolioK;


Var
  ChildIdx:  Integer;

  LastLineNo
          :  LongInt;

  ChildGenerated
          :  Boolean;

  ONomRec :  ^OutNomType;

Begin
  ChildIdx:=0; LastLineNo:=1;

  With NLOLine,RunCtrl do
  Begin
    If (NodeIdx=0) then
    Begin
      Repeat
        Inc(ChildIdx);
      {$B-}
      Until (ChildIdx>TotalNodes) or (Items[ChildIdx].Level=1);
      {$B+}
    end
    else
      ChildIdx:=ITems[NodeIdx].GetFirstChild;

    While (Not AbortRun) and (ChildIdx>0) and (ChildIdx<>NodeIdx)  and (ChildIdx<=TotalNodes) do
    Begin
      ONomRec:=Items[ChildIdx].Data;

      ChildGenerated:=BOff;

      If (ONomRec<>nil) then
      Begin
        With B2BCtrl,ONomRec^ do
        If (PRateMode) then
        Begin
         {$B-}
          If (OutNomType=StkBillCode) and (StkCost<>0.0) and (Global_GetMainRec(StockF,OutStkCode)) then
         {$B+}
          Begin
            WORBOMCode:=OutStkCode;
            BuildQty:=StkCost;

            Generate_ChildWOR(WORInv,Stock,LastLineNo,SingleChild);

            ChildGenerated:=WORCreated;

            {If (Not AbortRun) and (WORCreated) and (Items[ChildIdx].HasItems) then {Generate any of its children next}
              {Generate_WORChildren(Inv,ChildIdx,BOff);}
          end;

        end;

        If (Not AbortRun) and (Items[ChildIdx].HasItems) then {Generate any of its children next, but only connect to parent if immediate WOR generated.}
          Generate_WORChildren(Inv,ChildIdx,Not ChildGenerated);

      end;
      If (NodeIdx=0) then
      Begin
        Repeat
          Inc(ChildIdx);
        {$B-}
        Until (ChildIdx>TotalNodes) or (Items[ChildIdx].Level=1);
        {$B+}
      end
      else
        ChildIdx:=ITems[NodeIdx].GetNextChild(ChildIdx);

    end;

  end;
end;



procedure TWORBuildWizard.TryFinishWizard;

Var
  CalledThread,
  SuppOk  :  Boolean;
  mbRet   :  Word;
  FoundCode
          :  Str20;

  WORInv  :  InvRec;

  MTExLocal
         :  tdPostExLocalPtr;

  ThisScrt
         :  Scratch2Ptr;


{ == Proc to cascade any initial costs back up the WOR tree == }

Procedure CascadeCost;

Const
  Fnum     = ReportF;
  Keypath  = RpK;

  Fnum1    = InvF;
  Keypath1 = InvOurRefK;

  Fnum2    = IdetailF;
  Keypath2 = IdLinkK;

Var
  MsgForm  :  TSOPRunFrm;

  KeyS,
  KeyChk,
  KeyI     :  Str255;

  PORId    :  IDetail;

Begin
  If (Assigned(MTExLocal)) then
  With TSOPRunFrm.Create(Self), MTExLocal^ do
  Begin
    try

      ThisMode:=97;  Visible:=BOff;

      KeyChk:=FullNomKey(ThisScrt^.Process);
      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetLast,Fnum,KeyPath,KeyS);


      While (LStatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With LInv do
      Begin

        ThisScrt^ .Get_Scratch(LRepScr^);

        KeyI:=FullIdKey(FolioNum,1);

        LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyI);

        If (LStatusOk) then
        With LId do
        Begin
          PORId:=LId;

          If (SOPLink<>0) and (SOPLineNo<>0) then
          Begin
            KeyI:=FullIdKey(SOPLink,SOPLineNo);

            LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyI);

            If (LStatusOk) {and (IdDocHed=WOR)} then {Update cost up the tree. Might as well update SOR price as well whilst we are at it}
              PickSORvPOR(LInv,PORId,Fnum1,KeyPath1,Fnum2,KeyPath2,1);

          end;
        end;

        LStatus:=LFind_Rec(B_GetPrev,Fnum,KeyPath,KeyS);

      end; {While..}

    Finally
      Free;

    end; {Try..}
  end; {With..}

end;


begin
  inherited;

  Form2Wizard;

  SuppOk:=CheckCompleted(BOff,BOff);

  TotalNodes:=0;

  CalledThread:=BOff;

  ThisScrt:=nil;
  MTExLocal:=nil;

  If (SuppOk) then
  Begin
    Set_BackThreadMVisible(BOn);

    mbRet:=MessageDlg('Please confirm you wish to generate the Works Order',mtConfirmation,[mbYes,mbNo],0);

    Set_BackThreadMVisible(BOff);

    SuppOk:=(mbRet=mrYes);

    If (SuppOK) then
    Begin


      With B2BCtrl do
      Begin
        GenOrder:=0;

        If (Not InBom) and (AutoSetChilds In [1,2]) and (FullWOP) then {Go take a look at the BOM's}
        Begin
          OldB2BCtrl:=B2BCtrl;
          BOMBuildPage;
        end;

        MultiMode:=(GetChildBuildCount>0);
      end;


      Put_LastB2BVal(AllocB2BICode,B2BCtrl,-2,EntryRec^.Login);

      Generate_WOR(SORInv,SORLine,ExLocal.LStock,B2BCtrl,RunCtrl);

      WORInv:=Inv;

      With RunCtrl do
      Begin
        ThisScrt:=ptrThisScrt;
        MTExLocal:=ptrMTExLocal;
      end; {With..}

      {* Update Daybook *}
      If (Owner is TForm) and (RunCtrl.WORCreated) and (WORMode=0) and (Not FromStkRO) then
      Begin
        PostMessage((Self.Owner as TForm).Handle,WM_CustGetRec,100,0);


      end;


      If (B2BCtrl.MultiMode) and (RunCtrl.WORCreated) then
      Begin
        Generate_WORChildren(WORInv,0,BOff);
        RunCtrl.WORCreated:=BOn; {Restore here as generation of each child could reset it, but obviously to have got here, parent must have been created}
      end;


      If (B2BCtrl.GenOrder=1) then
        Display_Trans(2)
      else
      If (RunCtrl.WORCreated) then
      Begin
        {* Update Daybook *}
        If (Owner is TForm) and (RunCtrl.WORCreated) and (WORMode=0) then
        Begin
          PostMessage((Self.Owner as TForm).Handle,WM_CustGetRec,182,0);
        end;

        CascadeCost; {Refresh all upper level costs from the bottom of the build}

        try


          {* Call OBject DD and show list of POR's produced. *}
          Begin

            Set_ODDMode(2);

            With TObjDFrm.Create(Application.MainForm) do
            try

              If (WORMode=0) then
                SORInv:=WORInv;

              BuildB2BList(SORInv,MTExLocal,ThisScrt);
              CalledThread:=BOn;
            except
              CalledThread:=BOff;
              Free;
            end; {Try..}
          end



        Finally


        end; {try..}
      end;

      If (Assigned(ThisScrt)) and (Not CalledThread) then
      Begin
        Dispose(ThisScrt,Done);
        ThisScrt:=nil;
      end;

      If (Assigned(MTExlocal)) and (Not CalledThread) then
        Dispose(MTExLocal,Destroy);

      With RunCtrl do
      If (Assigned(ptrMsgForm)) and (B2BCtrl.MultiMode) then
        TForm(PtrMsgForm).Free;

      LastValueObj.UpdateAllLastValuesFull(Self);

      PostMessage(Self.Handle,WM_Close,0,0);
    end;
  end;

end;

procedure TWORBuildWizard.TWFinBtnClick(Sender: TObject);

Begin
  // MH 15/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on fields which processes the text and updates the value
  If (Sender = TWFinBtn) And (ActiveControl <> TWFinBtn) And TWFinBtn.CanFocus Then
    TWFinBtn.SetFocus;

  TryFinishWizard;

end;

procedure TWORBuildWizard.TWClsBtnClick(Sender: TObject);

Var
  LStatus  :  Integer;

begin
  LStatus:=0;

  inherited;
end;


Function TWORBuildWizard.Refresh_BOMTree  :  Boolean;
Begin
  Form2Wizard;
  
  With B2BCtrl do
    Result:=(BuildQty<>OldB2BCtrl.BuildQty)
          or (WORBOMCode<>OldB2BCtrl.WORBOMCode)
          or (QtyMode<>OldB2BCtrl.QtyMode)
          or (BWoQty<>OldB2BCtrl.BWOQty)
          or (BWoQty<>OldB2BCtrl.BWOQty)
          or (AutoSetChilds<>OldB2BCtrl.AutoSetChilds)
          or (LessFStk<>OldB2BCtrl.LessFStk)
          or (LessA2WOR<>OldB2BCtrl.LessA2WOR);

end;

procedure TWORBuildWizard.PageControl1Change(Sender: TObject);

Var
  NewIndex  :  Integer;

begin
  inherited;

  If (Sender is TPageControl) then
  With Sender as TPageControl do
  Begin
    NewIndex:=pcLivePage(Sender);

  {Hide images}

    Case NewIndex of
      0,1
         :  Begin
              Image1.Visible:=BOn;
              Image3.Visible:=BOff;
            end;
      2  :  Begin
              SBSPanel1.Visible:=BOn;

              Image1.Visible:=BOff;
              Image3.Visible:=BOn;

              With Image3 do
              Begin
                Top:=Image1.Top;
                Left:=Image1.Left;
                Width:=Image1.Width;
                Height:=Image1.Height;

              end;
            end;

      3  :  Begin
              SBSPanel1.Visible:=BOff;
              A2CompDF.DateValue:=A1CompDF.DateValue;

              If (InBOM) and (Refresh_BOMTree) then
              Begin
                InBOM:=BOff;

                OldB2BCtrl:=B2BCtrl;

                ClearBOMPage;
              end;

              If (Not InBOM) then
                BOMBuildPage;
            end;
    end; {case..}



  end; {With..}
end;

Procedure TWORBuildWizard.ClearBOMPage;

Begin
  With NLOLine do
  If (ItemCount>0) then
    Repeat

      Delete_OutLines(1,BOn);

    Until (ItemCount<=0);
end;


Procedure TWORBuildWizard.OutCost;

Begin
  With Exlocal do
  Begin
    BOMTimePanel.Caption:=ProdTime2Str(TotalBOMTime);

    Try
      With LStock,B2BCtrl do
        Panel1.Caption:=ProdTime2Str(Round(ProdTime*BuildQty));
    Except
      On Exception Do
        Panel1.Caption:='--ERROR--';
    End; // Try..Finally

    With LStock do
      Label820.Caption:='Sub Bill of Materials req. to build '+Form_Real(B2BCtrl.BuildQty,0,Syss.NoQtyDec)+' x '+
                        dbFormatName(StockCode,Desc[1]);

  end;
end;

procedure TWORBuildWizard.BOMBuildPage;

Var
  n           :  Byte;



Begin
  If (Not InBOM) then
  With ExLocal,LStock do
  Begin

    ColXAry[1]:=NLDrPanel.Width+NLDrPanel.Left-4;
    ColXAry[2]:=NLCrPanel.Width+NLCrPanel.Left-4;

    ChrWidth:=Round(Width*ChrsXRoss);

    InBOM:=BOn;

    Form2Wizard;

    TotalBOMTime:=Round(ProdTime*B2BCtrl.BuildQty);

    BOMFolio:=StockFolio;

    Add_OutLines(0,2,0,StockFolio,B2BCtrl.BuildQty,PWrdF,PWK);

    OutCost;

    A2CompDF.DateValue:=CalcCompDate(1,A2CompDF.DateValue);

    If (NLOLine.ItemCount>=0) then
    Begin
      NLOLine.FullExpand;
      NLOLine.TreeReady:=BOn;
    end;
  end;
end;


Function TWORBuildWizard.FormatLine(ONomRec  :  OutNomType;
                                    LineText :  String)  :  String;

Begin
  With ONomRec do
  Begin
    Result:=Spc(1*OutDepth)+Strip('R',[#32],LineText);

    Result:=Result+Spc(Round((Width-Canvas.TextWidth(Result))/Canvas.TextWidth(' '))-(TDpth*OutDepth));
  end;
end;


Function TWORBuildWizard.CalcChildBuild(StockR  :  StockRec;
                                        QtyPer,
                                        ThisBuildQty
                                                :  Double)  :  Double;
Var
  FreeStk,
  QtyLeft,
  MinRem  :  Double;

  EccQty  :  Integer;

Begin
  With ExLocal,B2BCtrl do
  Begin
    Result:=0.0; QtyLeft:=0.0; MinRem:=0.0;  FreeStk:=0.0;

    If (LessFStk) then
    Begin
      {$IFDEF SOP}
        Stock_LocSubst(StockR,B2BCtrl.LOCOR);
      {$ENDIF}

      FreeStk:=FreeStock(StockR);
    end;

    If (LessA2WOR) then
      FreeStk:=FreeStk-StockR.QtyAllocWOR;

    If (FreeStk<0.0) then
      FreeStk:=0.0;

    If (BWOQty) then
      Result:=Result+(ThisBuildQty*QtyPer);

    Result:=Result-FreeStk;

    With StockR do
    Case QtyMode of
      1  :  If (MinEccQty<>0.0) and (FreeStk<MinEccQty) then {make up to nearest ecc qty}
            Begin
              EccQty:=Trunc(DivwChk(Result,MinEccQty));

              MinRem:=DivwChk(Result,MinEccQty)-EccQty;

              If (EccQty<1) then
                QtyLeft:=(MinEccQty-Result)
              else
                QtyLeft:=((MinEccQty*(EccQty+Ord(MinRem>0)))-Result);
            end;
      2  :  QtyLeft:=(QtyMin);
      3  :  QtyLeft:=(QtyMax);
    end; {Case..}

    If (QtyLeft>0) then
    Begin
      Result:=Result+QtyLeft
    end;

    If (Result<0.0) then
      Result:=0.0;

  end;
end;

{ ======= Procedure to Build List based on Nominal File ===== }

Procedure TWORBuildWizard.Add_OutLines(Depth,
                                 DepthLimit,
                                 OIndex,
                                 StkFolio      :   LongInt;
                                 BuildQty      :   Double;
                           Const Fnum,
                                 Keypath       :   Integer);

Const
  Fnum2     =  StockF;
  Keypath2  =  StkFolioK;


Var
  KeyS,
  KeyChk,
  KeyLenChk,
  KeyStk
          :  Str255;

  LineText
          :  String;

  SpcWidth,
  NewIdx,
  NewObj,
  TmpRecAddr
          :  LongInt;

  CKLen,
  TmpStat,
  TmpKPath
          :  Integer;

  ONomRec :  ^OutNomType;

  OldCursor
          :  TCursor;


Begin
  TmpKPath:=Keypath;

  With NLOLine do
  Begin

    OldCursor:=Cursor;

    Cursor:=crHourGlass;

    SpcWidth:=Canvas.TextWidth(' ');

    KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StkFolio)));

    KeyLenChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,Strip('R',[#0],FullNomKey(StkFolio))));

    CKLen:=Length(KeyChk);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,CKLen,BOn)) do
    With PassWord.BillMatRec,Stock do
    Begin
      If (Keypath=HelpNdxK) then
        KeyStk:=StockLink
      else
        KeyStk:=BillLink;

      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);


      If (StatusOk) and (StockType=StkBillCode) then
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

          OutNomCat:=ProdTime;

          StkQty:=QtyUsed*BuildQty;
          StkCost:=CalcChildBuild(Stock,QtyUsed,BuildQty);

          PRateMode:=((StkCost>0.0) and (B2BCtrl.AutoSetChilds=2)) or (B2BCtrl.AutoSetChilds=1);

          If (PRateMode) then
            TotalBOMTime:=TotalBOMTime+Round(OutNomCat*StkCost);

          {OBOMLink:=StockLink;}

          {v4.30a alter to get record position}

          GetPos(F[Fnum],Fnum,OBOMAddr);


        end;

        LineText:=FormatLine(ONomRec^,dbFormatName(StockCode,Desc[1]));

        NewIdx:=AddChildObject(OIndex,LineText,ONomRec);
                                  {b561. Limit removed as depth of 2 stoped proper costings on boms more than 4 levels deep}
        If (StockType=StkBillCode) {and (Depth<DepthLimit)}  then
        Begin
          TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

          Add_OutLines(Depth+1,DepthLimit,NewIdx,StockFolio,ONomRec^.StkCost,Fnum,PWK);

          TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);

        end;

        If (NewIdx>-1) and (WOPOn) then
        With Items[NewIdx] do
        Begin
          ShowCheckBox:=BOn;
        end;


      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    Cursor:=OldCursor;

  end; {With..}

end; {Proc..}


Procedure TWORBuildWizard.Update_OutLines(Const Fnum,
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

          LineText:=Spc(1*OutDepth)+dbFormatName(StockCode,Desc[1]);

          LineText:=LineText+Spc(Round((Width-Canvas.TextWidth(LineText))/CanVas.TextWidth(' '))-(TDpth*OutDepth));

          {LineText:=Strip('R',[#32],Desc[1]);

          LineText:=FormatLine(ONomRec^,LineText);}

        end;

        Items[n].Text:=LineText;
      end;

    end; {Loop..}

    EndUpdate;

  end; {With..}
end; {Proc..}


Procedure TWORBuildWizard.Drill_OutLines(Depth,
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
              Add_OutLines(Depth,DepthLimit,PIndex,OutNomCode,B2BCtrl.BuildQty,PWrdF,PWK);

              ONomRec:=Items[PIndex].Data;

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




Procedure TWORBuildWizard.Delete_OutLines(PIndex      :  LongInt;
                                    DelSelf     :  Boolean);

Var
  IdxParent,
  OrigChild,
  NextChild       :  LongInt;

  ONomRec         :  ^OutNomType;

  Node            :  TSBSOutLNode;

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

        Node:=Items[NextChild];

        If (Items[NextChild].HasItems) then {* Delete lower levels *}
          Delete_OutLines(NextChild,BOff);

        If (ONomRec^.PRateMode) then
          UpdateNodeBuildStatus(Node,ONomRec^,BOff,BOn);


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



Procedure TWORBuildWizard.AddEditLine(Edit,
                              DelMode  :  Boolean);

Var
Depth,
OIndex,
NewIdx   :  Integer;
PNode    :  TSBSOutLNode;
NewFolio :  LongInt;
ONomRec  :  ^OutNomType;

Begin

With NLOLine,PassWord do
Begin
  GetSelBOM;
  ONomRec:=Items[SelectedItem].Data;

  With ONomRec^,PassWord.BillMatRec do
  Begin
    StkQty:=QtyUsed*B2BCtrl.BuildQty;
    StkCost:=CalcChildBuild(Stock,QtyUsed,B2BCtrl.BuildQty);
    PRateMode:=((StkCost>0.0) and (B2BCtrl.AutoSetChilds=2)) or (B2BCtrl.AutoSetChilds=1);


  end;

  With Stock do
    Items[SelectedItem].Text:=FormatLine(ONomRec^,dbFormatName(StockCode,Desc[1]));
end;

end;


{ ======= Function to find the note a nominal code resides at ======= }

function TWORBuildWizard.FindNode(NCode  :  LongInt)  :  Integer;

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


procedure TWORBuildWizard.EditBuild(SelItem  :  Integer);

Var
  ISCtrl         :  TWORWizBuild;
  PAllo,
  CBuild         :  Double;
  RunPick        :  Boolean;
  mrResult       :  TModalResult;
  ONomRec        :  ^OutNomType;
  Node           :  TSBSOutLNode;


begin
  PAllo:=0.0; CBuild:=0.0;  RunPick:=BOff;

  With NLOLine do
  Begin
    ONomRec:=Items[SelItem].Data;

    Node:=Items[SelItem];


    If (Assigned(ONomRec)) then
    With ONomRec^ do
    Begin

      ISCtrl:=TWORWizBuild.Create(Self);

      try

        With ISCtrl do
        Begin
          PAllo:=StkCost;
          RunPick:=PRateMode;


          Repeat                     {* Take into account already issued qty *}
            mrResult:=InitIS(PAllo,RunPick);

            If (mrResult=mrOk) and (PAValue>=0.0) then
            Begin
              StkCost:=PAValue;
              PRateMode:=SetBuild;

              If (Global_GetMainRec(StockF,OutStkCode)) then
                With Stock do
                  Items[SelItem].Text:=FormatLine(ONomRec^,dbFormatName(StockCode,Desc[1]));

            end;

          Until (mrResult<>mrOK) or (PAValue>=0.0);

          If (RunPick) then
            UpdateNodeBuildStatus(Node,ONomRec^,BOff,BOn);

          If (PRateMode) then
            UpdateNodeBuildStatus(Node,ONomRec^,PRateMode,BOn);

          If (MrResult=mrOK) then
          With Stock do
          Begin
            If (PAllo<>PAValue) then
            Begin
              Delete_OutLines(SelItem,BOff);

              Add_OutLines(OutDepth,2,SelItem,StockFolio,StkCost,PWrdF,PWK);


              Items[SelItem].FullExpand;
            end;

          end;

          OutCost;

          A2CompDF.DateValue:=CalcCompDate(1,A2CompDF.DateValue);

          EditedTime:=Now;
        end;

      finally

        ISCtrl.Free;

      end; {Try..}
    end;

  end;
end;


procedure TWORBuildWizard.MIRecClick(Sender: TObject);
begin
  inherited;

  EditBuild(NLOLine.SelectedItem);

end;


Function TWORBuildWizard.GetSelBOM  :  Boolean;


Const
Fnum     =  PWrdF;
Keypath  =  PWK;
Fnum2    =  StockF;
Keypath2 =  StkFolioK;

Var
ONomRec   :  ^OutNomType;
KeyChk,
KeyS      :  Str255;


begin
With NLOLine do
  If (ItemCount>0) then
  Begin

    ONomRec:=Items[SelectedItem].Data;

    With ONomRec^,PassWord.BillMatRec do
    Begin
      {KeyChk:=Strip('R',[#32,#0],FullMatchKey(BillMatTCode,BillMatSCode,OBOMLink));

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      Result:=(StatusOk and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));}


      SetDataRecOfs(Fnum,OBOMAddr); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Result:=StatusOk;

      If (Result) then
      Begin
        KeyS:=BillLink;

        Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);
      end;
    end;
  end; {If full list..}
end;





procedure TWORBuildWizard.NLOLineExpand(Sender: TObject; Index: Longint);
Var
Depth   :  LongInt;
ONomRec :  ^OutNomType;

begin
{$IFDEf PF_On}
  InExpand:=BOn;

  If (InBOM) then
  With (Sender as TSBSOutLineB)  do
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

    If (Not Items[Index].HasItems) and (Not InHotSpot) then
      EditBuild(Index);


  end; {With..}

  InExpand:=BOff;
{$ENDIF}

end;




procedure TWORBuildWizard.NLOLineNeedValue(Sender: TObject);
Var
ONomRec      :  ^OutNomType;
DrawIdxCode  :  LongInt;
{$IFDEF Ltr}
  OldCust, TmpPtr : CustRecPtr;
{$ENDIF}


begin
{$IFDEf PF_On}

  With Sender as TSBSOutLineB do
  Begin
    DrawIdxCode:=CalcIdx;

    If (DrawIdxCode>0) then
    Begin
      ONomRec:=Items[DrawIdxCode].Data;

      If (ONomRec<>nil) then
      With ONomRec^ do
      Begin

        ColValue:=0;

        Blank(LastDrCr,Sizeof(LastDrCr));

        LastDrCr[2]:=StkQty;

        LastDrCr[1]:=StkCost;

        If (DrawIdxCode=SelectedItem) then
        Begin
          If (Stock.StockCode<>OutStkCode) then
            Global_GetMainRec(StockF,OutStkCode);

          SendToObjectStkEnq(OutStkCode,B2BCtrl.LOCOR,'',-1,-1,0);

          {$IFDEF Ltr}
            If Assigned(LetterForm) And LetterActive Then
              If (LetterForm.WindowState <> wsMinimized) Then
                Begin
                  New (OldCust);
                  OldCust^ := Cust;
                  If CheckRecExsists(FullCustCode(Stock.Supplier), CustF, CustCodeK) Then
                    TmpPtr := @Cust
                  Else
                    TmpPtr := Nil;
                  LetterForm.LoadLettersFor (FullNomKey(Stock.StockFolio),   { Index Key }
                                             Stock.StockCode,               { Caption }
                                             CodeToFName (Stock.StockCode), { FName }
                                             LetterStkCode,
                                             TmpPtr, @Stock, Nil, Nil, Nil);
                  Cust := OldCust^;
                  Dispose(OldCust);
                End; { With }
            {$ENDIF}
        end;


        With Items[DrawIdxCode] do
          Begin
            ColValue:=LastDrCr[SetCol];

            ColFmt:=GenQtyMask;
          end;

          ColsX:=ColXAry[SetCol];
      end;
    end; {If found equiv index..}
  end;
{$ENDIF}
end;

procedure TWORBuildWizard.NLOLineUpdateNode(Sender: TObject;
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
      If (WOPOn) then
      Begin
        CheckBoxChecked:=PRateMode;

      end;
    end;

  end;
end;

procedure TWORBuildWizard.UpdateNodeBuildStatus(Var Node    : TSBSOutLNode;
                                                    ONomRec : OutNomType;
                                                    State,
                                                    LeaveCB : Boolean);

Const
  DCnst  :  Array[BOff..BOn] of SmallInt = (-1,1);



Begin
  With Node,ONomRec do
  Begin
    If (Not LeaveCB) then
      CheckBoxChecked:=State;

    TotalBOMTime:=TotalBOMTime+(Round(OutNomCat*StkCost)*DCnst[State]);
  end;

end;

procedure TWORBuildWizard.NLOLineNodeChkHotSpot(Sender: TObject;
  var Node: TSBSOutLNode; Row: Integer);


var
  ONomRec      :  ^OutNomType;
  Present      :  TDateTime;

begin
  Present:=Now;

  If (Not InExpand) and (Present-EditedTime>2e-5) then
  With Node do
  Begin
    InHotSpot:=BOn;

    ONomRec:=Data;

    If (ONomRec<>nil) then
    With ONomRec^ do
    Begin
      Begin
        PRateMode:=Not PRateMode;

        UpdateNodeBuildStatus(Node,ONomRec^,PRateMode,BOff);

        A2CompDF.DateValue:=CalcCompDate(1,A2CompDF.DateValue);

        OutCost;
      end;
    end;
    InHotspot:=BOff;
  end;

  
end;


procedure TWORBuildWizard.SetThisNode(Index,Level  :  Integer;
                                      State        :  Boolean);

Var
  ONomRec      :  ^OutNomType;
  DrawIdxCode  :  LongInt;
  Node         : TSBSOutLNode;
begin

  With NLOLine do
  Begin
    If (Index>=0) then
    Begin

      ONomRec:=Items[Index].Data;

      If (ONomRec<>nil) then
      With ONomRec^ do
      Begin

        If (Items[Index].HasItems) then
        Begin
          Items[Index].Expand;

          DrawIdxCode:=Items[Index].GetFirstChild;

          While (DrawIdxCode>=0) do
          Begin
            If (Items[DrawIdxCode].HasItems) then
              SetThisNode(DrawIdxCode,Level+1,State);

            Begin
              ONomRec:=Items[DrawIdxCode].Data;

              If (ONomRec<>nil) then
              With ONomRec^ do
              Begin
                If (PRateMode<>State) then
                Begin
                  PRateMode:=State;

                  Node:=Items[DrawIdxCode];

                  UpdateNodeBuildStatus(Node,ONomRec^,State,BOff);

                end;
              end;
            end;

            DrawIdxCode:=Items[Index].GetNextChild(DrawIdxCode);

          end; {While..}

        end;

        If (Level=0) then {* Do one and only store}
        Begin
          ONomRec:=Items[Index].Data;

          If (ONomRec<>nil) then
          With ONomRec^ do
          Begin
            If (PRateMode<>State) then
            Begin
              PRateMode:=State;

              Node:=Items[Index];

              UpdateNodeBuildStatus(Node,ONomRec^,State,BOff);

            end;
          end;

          Refresh;
          OutCost;
        end;
      end;{With..}


    end;
  end;{With..}

end;{Proc..}


procedure TWORBuildWizard.Build1Click(Sender: TObject);
begin
  If (NLOLine.SelectedItem>=0) then
    SetThisNode(NLOLine.SelectedItem,0,(Sender=Build1));
end;


procedure TWORBuildWizard.MIEALClick(Sender: TObject);
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


procedure TWORBuildWizard.CBLPFClick(Sender: TObject);
begin
  inherited;

  CBAWF.Enabled:=CBLPF.Checked;

  If (Not CBAWF.Enabled) then
    CBAWF.Checked:=BOff;
end;


procedure TWORBuildWizard.OptBtnClick(Sender: TObject);
Var
ListPoint  :  TPoint;

begin
  With TWinControl(Sender) do
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    ListPoint:=ClientToScreen(ListPoint);

  end;

  PopUpMenu3.PopUp(ListPoint.X,ListPoint.Y);
end;



procedure TWORBuildWizard.FormResize(Sender: TObject);
begin
  inherited;
  NLOLine.Width:=ClientWidth-21;
  NLOLine.Height:=ClientHeight-157;

  NLDPanel.Width:=Width-Lab1Ofset;
  NLCrPanel.Left:=Width-Lab2Ofset;
  NLDrPanel.Left:=Width-Lab3Ofset;

  {$IFDEF PF_On}
    ColXAry[1]:=NLDrPanel.Width+NLDrPanel.Left-4;
    ColXAry[2]:=NLCrPanel.Width+NLCrPanel.Left-4;

    ChrWidth:=Round(Width*ChrsXRoss);

    {NLOLine.HideText:=(Width<=383);}

    Update_OutLines(StockF,StkCodeK);
  {$ENDIF}


end;


procedure TWORBuildWizard.Label85Click(Sender: TObject);
begin
  inherited;
  If Sender is TLabel then
  With TLabel(Sender) do
    If FocusControl is TBorRadio then
      TBorRadio(FocusControl).Checked:=BOn
    else
      If FocusControl is TBorCheck then
        TBorCheck(FocusControl).Checked:=Not TBorCheck(FocusControl).Checked;

end;

procedure TWORBuildWizard.Links2Click(Sender: TObject);
{$IFDEF Ltr}
Var
  NKey    : String[4];
  OldCust : ^CustRec;
  StkCode : String[20];
  StkFol  : LongInt;
  StkAcc  : String[10];
  StkRec  : StockRecPtr;
{$ENDIF}
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

      StkCode := Stock.StockCode;
      StkFol  := Stock.StockFolio;
      StkAcc  := Stock.Supplier;
      StkRec  := @Stock;

      { Get Supplier }
      New (OldCust);
      OldCust^ := Cust;
      NKey := FullNomKey(StkFol);
      If CheckRecExsists(FullCustCode(StkAcc), CustF, CustCodeK) Then
        LetterForm.LoadLettersFor (NKey,                       { Index Key }
                                   StkCode,                    { Caption }
                                   CodeToFName (StkCode),      { FName }
                                   LetterStkCode,
                                   @Cust, StkRec, Nil, Nil, Nil)
      Else
        LetterForm.LoadLettersFor (NKey,                       { Index Key }
                                   StkCode,                    { Caption }
                                   CodeToFName (StkCode),      { FName }
                                   LetterStkCode,
                                   Nil, StkRec, Nil, Nil, Nil);
      Cust := OldCust^;
      Dispose(OldCust);
    Except
     LetterActive := BOff;
     LetterForm.Free;
    End;
  {$ENDIF}
end;



{ == Procedure to display wizard == }

Procedure Run_WORWizard(LInv    :  InvRec;
                        LId     :  IDetail;
                        WMode   :  Byte;
                        AOWner  :  TWinControl);

Var
  LAddr  :  LongInt;
  FromRO,
  Locked :  Boolean;
  KeyS   :  Str255;


Begin
  Locked:=BOff;

  KeyS:=LInv.OurRef;

  Begin
    FromRO:=WMode=255;

    If FromRO then
      WMode:=0;

    Set_WORInv(LInv,LId,WMode,LAddr);

    If (Assigned(WORWizard)) and (WORWActive) then
      WORWizard.Show
    else
    Begin
      WORWizard:=TWORBuildWizard.Create(AOWner);

      Try
        With WORWizard do
        Begin
          FromStkRO:=FromRO;

          If (FRomRO) then
          Begin
            A1SCodeF.Text:=LId.StockCode;

            ActiveControl:=A1QIF;

            A1QIF.Value:=Qty_OS(LId);

            Link2db;


          end;
        end;
      except
        WORWizard.Free;
        WORWizard:=nil;
      end; {try..}
    end;
  end;

end;








Initialization
  LocalInv:=Nil;
  LocalId:=Nil;
  WORWizard:=Nil;
  WORWActive:=BOff;

  LocalSORAddr:=0;

Finalization
  If (Assigned(LocalInv)) then
    Dispose(LocalInv);

  If (Assigned(LocalId)) then
    Dispose(LocalId);


end.

