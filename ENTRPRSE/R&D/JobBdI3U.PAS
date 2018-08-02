unit JobBdI3U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, BorBtns,
  GlobVar,VarConst,ExWrap1U,CmpCtrlU,SBSOutL, bkgroup, ComCtrls;


type
  TJobBudget = class(TForm)
    CanCP1Btn: TButton;
    OkCP1Btn: TButton;
    PageControl1: TPageControl;
    Budgetpage: TTabSheet;
    ValPage: TTabSheet;
    Label84: Label8;
    Label85: Label8;
    Bevel2: TBevel;
    Label813: Label8;
    BC1F: TSBSComboBox;
    BUCF: TCurrencyEdit;
    BOHCF: TCurrencyEdit;
    BUpliftPF: TCurrencyEdit;
    SetPrVBtn: TButton;
    SetPrbBtn: TButton;
    BRCF: TBorCheck;
    Panel1: TPanel;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    BSDF: Text8Pt;
    BACF: Text8Pt;
    BSCF: Text8Pt;
    BADF: Text8Pt;
    BATF: Text8Pt;
    Label814: Label8;
    BC7F: TSBSComboBox;
    BAV7F: TCurrencyEdit;
    BAPPF: TCurrencyEdit;
    Label815: Label8;
    Panel2: TPanel;
    Label821: Label8;
    Label822: Label8;
    Label823: Label8;
    Label824: Label8;
    Label825: Label8;
    Label826: Label8;
    Label827: Label8;
    BOHF: TCurrencyEdit;
    BRHF: TCurrencyEdit;
    BC3F: TSBSComboBox;
    BC2F: TSBSComboBox;
    BOVF: TCurrencyEdit;
    BRVF: TCurrencyEdit;
    BAH1F: TCurrencyEdit;
    BC4F: TSBSComboBox;
    BAV1F: TCurrencyEdit;
    BAV2F: TCurrencyEdit;
    BC5F: TSBSComboBox;
    BAH2F: TCurrencyEdit;
    BAH3F: TCurrencyEdit;
    BC6F: TSBSComboBox;
    BAV3F: TCurrencyEdit;
    BC8F: TSBSComboBox;
    BAV8F: TCurrencyEdit;
    BAPP2F: TCurrencyEdit;
    Label86: Label8;
    BAVBasisF: TSBSComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure BSCFExit(Sender: TObject);
    procedure BACFExit(Sender: TObject);
    procedure BOHFExit(Sender: TObject);
    procedure BRHFExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SetPrbBtnClick(Sender: TObject);
    procedure BUpliftPFEnter(Sender: TObject);
    procedure P2FV8FExit(Sender: TObject);
    procedure BAPP2FExit(Sender: TObject);
    procedure BAPP2FEnter(Sender: TObject);
    procedure BAV7FExit(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { Private declarations }
    IdStored,
    DuringEdit,
    IsPayMode,
    StopPageChange,
    Ok2Del1,
    Ok2Del2,
    JustCreated  :  Boolean;

    IsPRStk      :  Byte;

    SKeypath     :  Integer;

    ValPcnt      :  Double;


    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Function ActiveBudget  :  Double;

    Procedure SetFieldFocus;

    procedure SetROFields;

    Function ConfirmQuit  :  Boolean;

    Procedure OutTotals;


    procedure Form2Id;

    Function Get_NextJAFolio(JCode  :  Str10;
                             Update :  Boolean)  :  LongInt;

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    JobR       :  JobRecType;

    ExLocal    :  TdExLocal;

    Function CheckNeedStore(All  :  Boolean)  :  Boolean;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    Function ApplyUplift  :  Boolean;

    Procedure OutId;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSOutLineB) ;


    procedure EditLine(RJob       :  JobRecType;
                       Edit       :  Boolean);


    procedure  DeleteJBLine(Fnum,
                            KeyPath  :  Integer;
                            RJob     :  JobRecType);

  end;


Var
  SetPRStk   :  Byte;
  SetPRMode  :  Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  VarJCstU,
  BtKeys1U,
  BTSupU1,
  BTSupU2,
  SBSComp2,
  CurrncyU,
  ComnUnit,
  ComnU2,


  ColCtrlU,

  {SysU2,}
  MiscU,
  JobSup1U,
  JATreeU,

  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {$IFDEF NOM}
    HistWinU,
  {$ENDIF}
  Event1U,

  ThemeFix,

  PWarnU,
  SysU1,
  ExThrd2U;




{$R *.DFM}




{ ========== Build runtime view ======== }

{IsPrStk Modes :

2   =  Stk/payrate view
5   =  Anal heading view
6   =  Budget record

}

procedure TJobBudget.BuildDesign;


begin
  If (IsPRStk<>2) then
  Begin
    BSCF.Visible:=BOff;
    BSDF.Visible:=BOff;
    Label81.Visible:=BOff;
    Label82.Visible:=BOff;
    HelpContext:=949;
  end;

  If (IsPrStk=5) then
  Begin
    BACF.Visible:=BOff;
    BATF.Visible:=BOff;
    Label83.Visible:=BOff;
    BRCF.Visible:=BOff;
    BOHCF.Visible:=BOff;
    HelpContext:=940;
  end;

  If (IsPrStk<>6) then
  Begin
    Label813.Visible:=BOff;
    BUpliftPF.Visible:=BOff;
  end;

  ValPage.TabVisible:=(IsPrStk<>2) and (JAPOn) and ChkAllowed_In(465);

  If (Not PChkAllowed_In(457)) then
  Begin
    BAV7F.Tag:=0;
    BAV7F.Color:=clBtnFace;
    BAV7F.TabStop:=BOff;
    BAV7F.ReadOnly:=BOn;
  end;

end;


procedure TJobBudget.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  BOHF.DecPlaces:=Syss.NoQtyDec;
  BRHF.DecPlaces:=Syss.NoQtyDec;
  BAH1F.DecPlaces:=Syss.NoQtyDec;
  BAH2F.DecPlaces:=Syss.NoQtyDec;
  BAH3F.DecPlaces:=Syss.NoQtyDec;
  BUCF.DecPlaces:=Syss.NoCosDec;
  BOVF.DecPlaces:=Syss.NoCosDec;
  BRVF.DecPlaces:=Syss.NoCosDec;
  BAV1F.DecPlaces:=Syss.NoCosDec;
  BAV2F.DecPlaces:=Syss.NoCosDec;
  BAV3F.DecPlaces:=Syss.NoCosDec;

  {$IFDEF MC_On}

    Set_DefaultCurr(BC2F.Items,BOff,BOff);
    Set_DefaultCurr(BC2F.ItemsL,BOff,BOn);

  {$ENDIF}

  BuildDesign;

end;




procedure TJobBudget.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  DuringEdit:=BOff;

  ExLocal.Create;

  JustCreated:=BOn;

  ValPcnt:=0.0;

  SKeypath:=0;

  ClientHeight:=392;
  ClientWidth:=429;


  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TJAView) then
    With TJAView(Owner) do
      Self.SetFieldProperties(NLOLine);

  IsPRStk:=SetPRStk;
  IsPayMode:=SetPRMode;

  Ok2Del1:=(IsPrStk=6); Ok2Del2:=(IsPrStk=2);

  PageControl1.ActivePage:=BudgetPage;

  FormDesign;

end;




procedure TJobBudget.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,103);

end;

procedure TJobBudget.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TJobBudget.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TJobBudget.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TJobBudget.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TJobBudget.Send_UpdateList(Edit   :  Boolean;
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



Function TJobBudget.CheckNeedStore(All  :  Boolean)  :  Boolean;

Var
  Loop  :  Integer;

Begin
  Result:=BOff;
  Loop:=0;

  While (Loop<=Pred(ComponentCount)) and ((Not Result) or (All)) do
  Begin
    If (Components[Loop] is TMaskEdit) then
    With (Components[Loop] as TMaskEdit) do
    Begin
      Result:=((Tag=1) and (Modified));

      If (Result) then
        Modified:=BOff;
    end
    else
      If (Components[Loop] is TCurrencyEdit) then
      With (Components[Loop] as TCurrencyEdit) do
      Begin
        Result:=((Tag=1) and (FloatModified));

        If (Result) then
          FloatModified:=BOff;
      end
      else
        If (Components[Loop] is TBorCheck) then
        With (Components[Loop] as TBorCheck) do
        Begin
          Result:=((Tag=1) and (Modified));

          If (Result) then
            Modified:=BOff;
        end
        else
          If (Components[Loop] is TSBSComboBox) then
          With (Components[Loop] as TSBSComboBox) do
          Begin
            Result:=((Tag=1) and (Modified));

            If (Result) then
              Modified:=BOff;
          end;

    Inc(Loop);
  end; {While..}
end;


Procedure TJobBudget.SetFieldFocus;

Begin
  If (IsPRStk=2) then
  Begin
    If (BSCF.CanFocus) then
      BSCF.SetFocus
  end
  else
    If (BACF.CanFocus) then
      BACF.SetFocus;

end; {Proc..}




Function TJobBudget.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.LastEdit) and (ExLocal.LastJobCtrl^.JobBudg.UnitPrice=BUCF.Value) then
    BUCF.FloatModified:=BOff;

  If (ExLocal.InAddEdit) and (CheckNeedStore(BOff)) and (Not ExLocal.LViewOnly) and (Not IdStored) then
  Begin

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreId(JCtrlF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(JCtrlF,LastRecAddr[JCtrlF]);

                Send_UpdateList(BOff,20);

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



Procedure TJobBudget.OutTotals;


Var
  Dnum1,
  Dnum2,
  Dnum      :  Double;

  NomBal,
  PSales,
  PPurch,
  PCleared,
  PB1,
  PB2       :  Double;


Begin
  With ExLocal,LJobCtrl^.JobBudg do
  Begin
    With JobR do
      Dnum:=Profit_To_Date(JobType,FullJDHistKey(JobCode,HistFolio),CurrBudg,
            99,Syss.PrInYr,PPurch,PSales,PCleared,BOn);


    BAH1F.Value:=PCleared;
    BAV1F.Value:=Dnum;

    With JobR do
      Dnum:=Profit_To_Date(JobType,FullJDHistKey(JobCode,HistFolio),CurrBudg,
                           GetLocalPr(0).CYr,GetLocalPr(0).CPr,PPurch,PSales,PCleared,BOff);

    BAH2F.Value:=PCleared;
    BAV2F.Value:=Dnum;

    With JobR do
      Dnum:=This_YTDHist(JobType,FullJDHistKey(JobCode,HistFolio),CurrBudg,
                         GetLocalPr(0).CYr,PPurch,PSales,PCleared,PB1,PB2);

    BAH3F.Value:=PCleared;
    BAV3F.Value:=Dnum;

  end; {With..}

end; {Proc..}

{ == Function to determine if uplift can be set == }

Function TJobBudget.ApplyUplift  :  Boolean;

Begin
  Result:=BOff;

  If (BUpliftPF.Visible) then
  Begin
     Result:=(ExLocal.LJobCtrl^.JobBudg.BType>JobXRev) and (JobMisc^.JobAnalRec.UpliftP<>0.0);

  end;

end;


{ ============== Display Id Record ============ }

Procedure TJobBudget.OutId;


Var
  FoundOk   :  Boolean;

  Dnum1,
  Dnum2,
  Dnum      :  Double;

  NomBal,
  PSales,
  PPurch,
  PCleared,
  PB1,
  PB2       :  Double;

  FoundCode :  Str20;

  KeyS      :  Str255;


Begin
  With ExLocal,LJobCtrl^.JobBudg do
  Begin
    If (IsPrStk=2) then
    Begin
      BSCF.Text:=Trim(StockCode);

        If (PayRMode) then
          BSDF.Text:=Get_StdPRDesc(StockCode,JCtrlF,JCK,-1)
        else
        Begin
          If (LStock.StockCode<>StockCode) then
            If LGetMainRecPos(StockF,StockCode) then
              BSDF.Text:=LStock.Desc[1]
            else
              BSDF.Text:='';
        end;

    end;

    If (IsPrStk<>5) then
    Begin
      BACF.Text:=Trim(AnalCode);

      If GetJobMisc(Self,AnalCode,FoundCode,2,-1) then
      Begin
        BADF.Text:=JobMisc^.JobAnalRec.JAnalName;
        BATF.Text:=JobXDesc^[JobMisc^.JobAnalRec.JAType];
      end;

      BRCF.Checked:=ReCharge;
      BOHCF.Value:=OverCost;
      BUpliftPF.Value:=Pcnt2Full(JBUpliftP);

      BUpliftPFEnter(Nil);
    end
    else
      BADF.Text:=Major_Hed(AnalHed);

    BUCF.Value:=UnitPrice;



    If (Not SyssJob^.JobSetUp.PeriodBud) then
    Begin
      BOHF.Value:=BOQty;
      BRHF.Value:=BRQty;
      BOVF.Value:=BOValue;
      BRVF.Value:=BRValue;

      {$IFDEF EX601}
      If (JBudgetCurr>0) then
        BC2F.ItemIndex:=Pred(JBudgetCurr)
      else
        BC2F.ItemIndex:=0;
      {$ENDIF}
    end
    else
    Begin
      With JobR do
        NomBal:=Total_Profit_To_Date(JobType,FullJDHistKey(JobCode,HistFolio),CurrBudg,
                                     GetLocalPr(0).CYr,Syss.PrInYr,PPurch,PSales,PCleared,PB1,PB2,Dnum1,Dnum2,BOn);

      BOHF.Value:=Dnum1;
      BRHF.Value:=Dnum2;
      BOVF.Value:=PB1;
      BRVF.Value:=PB2;

    end;

    If (IsPrStk<>2) then
    Begin
      BAV7F.Value:=OrigValuation;
      BAV8F.Value:=RevValuation;

      BAPPF.Value:=DivWChk(OrigValuation,ActiveBudget)*100;

      BAPP2F.Value:=JAPcntApp;

      BAVBasisF.ItemIndex:=JABBasis;
    end;

  end;

end;


procedure TJobBudget.Form2Id;

Begin

  With ExLocal,LJobCtrl^.JobBudg do
  Begin
    If (IsPrStk=2) then
      StockCode:=FullStockCode(BSCF.Text);


    If (IsPrStk<>5) then
    Begin
      AnalCode:=UpCaseStr(FullJACode(BACF.Text));
      OverCost:=BOHCF.Value;
      ReCharge:=BRCF.Checked;

      If (ApplyUplift) then
        JBUpliftP:=Pcnt(BUpliftPF.Value)
      else
        JBUpliftP:=0.0;
    end;

    If (Not SyssJob^.JobSetUp.PeriodBud) then
    Begin
      BoQty:=BOHF.Value;
      BoValue:=BOVF.Value;
      BrQty:=BRHF.Value;
      BrValue:=BRVF.Value;

      {$IFDEF EX601}
      If (BC2F.ItemIndex>=0) then
        JBudgetCurr:=Succ(BC2F.ItemIndex);
      {$ENDIF}  
    end;

    If (IsPrStk<>2) then
    Begin
      IF (BAV7F.TabStop) then
        OrigValuation:=BAV7F.Value;

      RevValuation:=BAV8F.Value;

      JABBasis:=BAVBasisF.ItemIndex;

      JAPcntApp:=BAPP2F.Value;
    end;


  end; {with..}

end; {Proc..}




procedure TJobBudget.SetROFields;

Begin
  If (IsPRStk=2) then
    BSCF.ReadOnly:=(Not Ok2Del2);

  BACF.ReadOnly:=(Not Ok2Del1) or (IsPrStk<>6);
  BACF.TabStop:=Not BACF.ReadOnly;

  BUCF.ReadOnly:=SyssJob^.JobSetUp.PeriodBud;
  BUCF.Visible:=Not SyssJob^.JobSetUp.PeriodBud;
  Label84.Visible:=BUCF.Visible;

  {$IFDEF MC_On}
    {BC1F.Visible:=BUCF.Visible; * Currency input is not allowed at all}

    {$IFDEF EX601}

      BC2F.Visible:=Not SyssJob^.JobSetUp.PeriodBud;

    {$ENDIF}

  {$ENDIF}


  SetPrBBtn.Visible:=SyssJob^.JobSetUp.PeriodBud and ExLocal.LastEdit;
  SetPrVBtn.Visible:=SetPrBBtn.Visible;

  If (SetPrBBtn.Visible) then
  Begin
    SetPrBBtn.Left:=BC1F.Left;
    SetPrBBtn.Top:=BC1F.Top;
    SetPrVBtn.Top:=BC1F.Top;
    SetPrVBtn.Left:=SetPrBBtn.Left+SetPrBBtn.Width+5;
    BOHF.Color:=clBtnFace;
    BOVF.Color:=clBtnFace;
    BRVF.Color:=clBtnFace;
    BRHF.Color:=clBtnFace;

    {$IFDEF MC_On}
       BC2F.Color:=clBtnFace;
       BC3F.Color:=clBtnFace;
    {$ENDIF}
  end;

  BOHCF.Visible:=(JobR.ChargeType=CPChargeType);

  Label85.Visible:=BOHCF.Visible;

  BOHF.ReadOnly:=BUCF.ReadOnly;
  BOVF.ReadOnly:=BUCF.ReadOnly;
  BRVF.ReadOnly:=BUCF.ReadOnly;
  BRHF.ReadOnly:=BUCF.ReadOnly;

  BOVF.TabStop:=Not BUCF.ReadOnly;
  BRVF.TabStop:=Not BUCF.ReadOnly;
  BRHF.TabStop:=Not BUCF.ReadOnly;
  BOHF.TabStop:=Not BUCF.ReadOnly;

  {$IFDEF MC_On}
     BC2F.ReadOnly:=BUCF.ReadOnly;
     BC3F.ReadOnly:=BUCF.ReadOnly;
     BC2F.TabStop:=Not BUCF.ReadOnly;
     BC3F.TabStop:=Not BUCF.ReadOnly;
  {$ENDIF}
end;



(*  Add is used to add Notes *)

procedure TJobBudget.ProcessId(Fnum,
                            Keypath     :  Integer;
                            Edit        :  Boolean);

Var
  KeyS  :  Str255;


Begin

  Addch:=ResetKey;

  KeyS:='';

  ExLocal.InAddEdit:=BOn;

  ExLocal.LastEdit:=Edit;

  SKeypath:=Keypath;

  If (Edit) then
  Begin

    With ExLocal do
    Begin
      LGetRecAddr(Fnum);

      If (Not LViewOnly) then
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked)
      else
        Ok:=BOn;

    end;

    If (Not Ok) or (Not GlobLocked) then
      AddCh:=Esc
    else
    With ExLocal do
    Begin
      {$B-}
        Ok2Del1:=(Not Edit) or Ok2DelJB(1,LJobCtrl^);
        Ok2Del2:=(Not Edit) or Ok2DelJB(2,LJobCtrl^);
      {$B+}

       With JobR,LJobCtrl^.JobBudg do
       Begin
         Case IsPRStk of
           2  :  Caption:='Job Budget Record for '+dbFormatName(JobCode,'Stk/PR: '+StockCode);
           5  :  Caption:='Job Budget Record for '+dbFormatName(JobCode,Major_Hed(AnalHed));
           6  :  Caption:='Job Budget Record for '+dbFormatName(JobCode,AnalCode);
         end; {Case..}

         IsPayMode:=PayRMode;
       end;

    end;
  end
  else
    With JobR do
      Caption:='Add Job Budget for '+dbFormatName(JobCode,JobDesc);



  If (Addch<>Esc) then
  With ExLocal,LJobCtrl^,JobBudg do
  begin
    If (JobR.JobType=JobGrpCode) or (IsPrStk=5) then
    Begin
      BC8F.Visible:=BOff;
      BAV8F.Visible:=BOff;
      BC7F.Visible:=BOff;
      BAV7F.Visible:=BOff;
      Label815.Visible:=BOff;
      BAPPF.Visible:=BOff;
      Label814.Visible:=BOff;
    end;

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPfix:=JBRCode;

      SubType:=JBSubAry[IsPRStk];

      JobCode:=JobR.JobCode;

      PayRMode:=IsPayMode;

      ReCharge:=(JobR.ChargeType=3);

      ValPage.TabVisible:=BOff;

      {$IFDEF EX601}
        JBudgetCurr:=JobR.CurrPrice;
      {$ENDIF}

      JABBasis:=1;

      If (IsPrStk=2) then
      Begin
        If (BSCF.CanFocus) then
          BSCF.SetFocus;
      end;

    end
    else
    Begin
      If (BUCF.CanFocus) then
        BUCF.SetFocus;

      ValPage.TabVisible:=(JAPOn) and (AnalHed=1) and (IsPrStk<>2)
    end;

    LastJobCtrl^:=LJobCtrl^;

    OutId;
    OutTotals;


  end; {If Abort..}

  SetROFields;
  DuringEdit:=BOn;
end; {Proc..}




Function TJobBudget.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  4;
  Fnum         =  JCtrlF;
  Keypath      =  JCK;


Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  KeyS     :  Str255;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;


Begin
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='The Stock/Pay Rate Code is not valid.';
  PossMsg^[2]:='The Analysis Code is not valid.';
  PossMsg^[3]:='A Budget record for this Stock/Pay code already exists.';
  PossMsg^[4]:='A Budget record for this Analysis code already exists.';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LJobCtrl^,JobBudg do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    {$B-}

    Case Test of

      1  :  Begin
              Result:=(IsPRStk<>2);

              If (Not Result) then
              Begin
                 If (Not IsPayMode) then
                   Result:=((Not EmptyKey(StockCode,StkKeyLen)) and (LGetMainRecPos(StockF,StockCode)))
                 else
                   Result:=((Not EmptyKey(StockCode,StkKeyLen)) and (CheckExsists(FullJBKey(JBRCode,JBSubAry[3],FullJACode(FullNomKey(PRateCode))+FullStockCode(StockCode)),JCtrlF,JCK)));

              end;
            end;

      2  :  Begin
              Result:=(IsPRStk=5) or ((IsPrStk=2) and (Not IsPayMode)) or ((Not EmptyKey(AnalCode,JobKeyLen)) and (GetJobMisc(Self,AnalCode,FoundCode,2,-1)));
            end;

      3  :  If (LastJobCtrl^.JobBudg.StockCode<>StockCode) and (LastEdit) then
            Begin
              Result:=(IsPRStk<>2) or (Not CheckExsists(FullJBKey(RecPFix,SubType,FullJBCode(JobCode,CurrBudg,StockCode)),JCtrlF,JCK));
            end;

      4  :  If (LastJobCtrl^.JobBudg.AnalCode<>AnalCode) and (LastEdit) then
            Begin
              Result:=(IsPRStk In [2,5]) or (Not CheckExsists(FullJBKey(RecPFix,SubType,FullJBCode(JobCode,CurrBudg,AnalCode)),JCtrlF,JCK));
            end;

    end;{Case..}

    {$B+}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}



{ ====== Function to Return next Budget Folio Number ====== }
{ = Reproduced in JobPostU for Thread safe operation = }

Function TJobBudget.Get_NextJAFolio(JCode  :  Str10;
                                    Update :  Boolean)  :  LongInt;

Const

  Fnum      =  JobF;
  Keypath   =  JobCodeK;


Var
  LOk,
  Locked:  Boolean;

  Lnum  :  Longint;

  KeyS  :  Str255;


Begin

  With ExLocal do
  Begin
    Lnum:=0;

    KeyS:=FullJobCode(JCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);


    If (StatusOk) then
    With LJobRec^ do
    Begin

      Locked:=Not Update;

      LOk:=Not Update;

      If (Not LOk) then
      Begin
        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);
        LGetRecAddr(Fnum);
      end;

      If (LOk) And (Locked) then
      Begin

        Lnum:=ALineCount;

        {* Update NexFolio *}

        If (Update) then
        Begin
          Inc(ALineCount);

          Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

          Report_Berror(Fnum,Status);

          UnLockMLock(Fnum,LastRecAddr[Fnum]);
        end;

      end;

    end;

    Get_NextJAFolio:=Lnum;
  end; {With..}
end;





procedure TJobBudget.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpJCtrl
       :  JobCtrlRec;

  KeyS :  Str255;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LJobCtrl^,JobBudg do
  Begin
    {$IFDEF CU} {* Call Budget store here? *}

      GenHooks(5000,76,ExLocal);

    {$ENDIF}


    COk:=CheckCompleted(LastEdit,BOff);


    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      Case IsPRStk of
        2  :  Begin
                BudgetCode:=FullJBCode(JobCode,CurrBudg,StockCode);

                Code2NDX:=FullJDAnalKey(JobCode,AnalCode); {* To enable Drill down to analysis level *}


              end;

        6  :  Begin
                BudgetCode:=FullJBCode(JobCode,CurrBudg,AnalCode);

                Code2NDX:=FullJBDDKey(JobCode,AnalHed); {* To enable Drill down to analysis level *}

              end;
      end; {case..}

      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpJCtrl:=LJobCtrl^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LJobCtrl^:=TmpJCtrl;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end
      else
      Begin
        HistFolio:=Get_NextJAFolio(JobCode,BOn);


        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end;

      Report_BError(Fnum,Status);


      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      IdStored:=BOn;

      Send_UpdateList(LastEdit,16);

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TJobBudget.SetFieldProperties(Field  :  TSBSOutLineB) ;

Var
  n  : Integer;


Begin
  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox) or (Components[n] is TSBSComboBox)
     or (Components[n] is TCurrencyEdit) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(Field.Font);
        Color:=Field.Color;
      end;


  end; {Loop..}


end;





procedure TJobBudget.EditLine(RJob     :  JobRecType;
                              Edit     :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    JobR:=RJob;
    LJobRec^:=JobR;
    
    ProcessId(JCtrlF,JCK,LastEdit);
  end;
end;




procedure TJobBudget.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      if OkCP1Btn.CanFocus then
        OkCP1Btn.SetFocus;
      if (ActiveControl = OkCP1Btn) then
        StoreId(JCtrlF,SKeypath);
    end
    else
      If (ModalResult=mrCancel) then
      Begin
        With Exlocal do
        If (LastEdit) then
          UnLockMLock(JCtrlF,LastRecAddr[JCtrlF]);

        Begin
          Close;
          Exit;
        end;
      end;
  end; {With..}

end;


procedure TJobBudget.DeleteJBLine(Fnum,
                                  KeyPath  :  Integer;
                                  RJob     :  JobRecType);

Var
  MbRet  :  Word;
  GotRec :  Integer;
  KeyS   :  Str255;

Begin
  With ExLocal do
  Begin
    JobR:=RJob;
    LJobRec^:=JobR;
    AssignFromGlobal(Fnum);
    LGetRecAddr(Fnum);
    OutId;
    OKCP1Btn.Enabled:=BOff;
    CanCP1Btn.Enabled:=BOff;

    MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Budget',
                       mtConfirmation,[mbYes,mbNo],0);

    If (MbRet=MrYes) then
    Begin
      Status:=LGetDirectRec(Fnum,KeyPath);

      If (StatusOk) then
      Begin

        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,GlobLocked);

        If (Ok) and (GlobLocked) then
        Begin

          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

          Report_BError(Fnum,Status);
        end;

        If (StatusOk) then
        Begin
          Send_UpdateList(BOff,17);


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}




procedure TJobBudget.BSCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  Dupli,
  AltMod     :  Boolean;



begin
  {$IFDEF STK}

    If (Sender is Text8pt) then
    With (Sender as Text8pt), ExLocal do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (DuringEdit) then
      Begin
        Form2Id;
        AssignToGLobal(JCtrlF);

        StillEdit:=BOn;

        If (IsPayMode) then
          FoundOk:=Get_BudPayRate(Self,FoundCode,0,0,3)
        else
        Begin
          FoundOk:=(GetStock(Self.Owner,FoundCode,FoundCode,99));

          If (FoundOk) then
            JobCtrl^.JobBudg.AnalCode:=Stock.JAnalCode;
        end;


        If (FoundOk) then {* Credit Check *}
        With LJobCtrl^,JobBudg do
        Begin

          StockCode:=FullStockCode(FoundCode);
          JobCtrl^.JobBudg.StockCode:=StockCode;

          FoundOk:=(Not Check4DupliGen(FullJBKey(RecPFix,SubType,FullJBCode(JobCode,CurrBudg,StockCode)),JCtrlF,JCK,'Record ('+Strip('B',[#32],StockCode)+')'));


        end;


        If (FoundOk) then
        Begin
          AssignFromGlobal(JCtrlF);

          {$IFDEF CU} {* Call Budget cost hook here, allows override of budget unit price & currency? *}

            GenHooks(5000,75,ExLocal);

          {$ENDIF}


          OutId;

          StopPageChange:=BOff;

          StillEdit:=BOff;

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



procedure TJobBudget.BACFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  Dupli,
  AltMod     :  Boolean;



begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt), ExLocal do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (DuringEdit) and (Not ReadOnly) then
    Begin
      Form2Id;

      StillEdit:=BOn;

      FoundOk:=(GetJobMisc(Self.Owner,FoundCode,FoundCode,2,99));


      If (FoundOk) then {* Credit Check *}
      With LJobCtrl^,JobBudg do
      Begin
        AnalCode:=UpCaseStr(FullJACode(FoundCode));

        FoundOk:=(Not Check4DupliGen(FullJBKey(RecPFix,SubType,FullJBCode(JobCode,CurrBudg,AnalCode)),JCtrlF,JCK,'Record ('+Strip('B',[#32],AnalCode)+')'));


      end;


      If (FoundOk) then
      With LJobCtrl^.JobBudg do
      Begin
        BType:=JobMisc^.JobAnalRec.JAType;
        AnalHed:=JobMisc^.JobAnalRec.AnalHed;
        ReCharge:=(BType<>JobXRev);

        OutId;

        StopPageChange:=BOff;

        StillEdit:=BOff;

      end
      else
      Begin
        StopPageChange:=BOn;

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;



procedure TJobBudget.BOHFExit(Sender: TObject);

Var
  FoundValue :  Double;

  AltMod     :  Boolean;

begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit), ExLocal do
  Begin
    AltMod:=FloatModified;

    FoundValue:=Value;

    If (AltMod) and (ActiveControl<>CanCP1Btn) then
    Begin
      If (BRHF.Value=0) then
      Begin
        BRHF.Value:=FoundValue;
        BRHF.FloatModified:=BOn;
      end;

      If (BOVF.Value=0) then
        BOVF.Value:=FoundValue*BUCF.Value;

    end;
  end; {with..}
end;

procedure TJobBudget.BRHFExit(Sender: TObject);
Var
  FoundValue :  Double;

  AltMod     :  Boolean;

begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit), ExLocal do
  Begin
    AltMod:=FloatModified;

    FoundValue:=Value;

    If (ActiveControl<>CanCP1Btn) then
    Begin
      If (BRVF.Value=0) then
        BRVF.Value:=FoundValue*BUCF.Value;

    end;
  end; {with..}
end;

procedure TJobBudget.BUpliftPFEnter(Sender: TObject);
begin
  BUpliftPF.Enabled:=ApplyUplift;
  Label813.Enabled:=BUpliftPF.Enabled;

  If (Not BUpliftPF.Enabled) then
    BUpliftPF.Value:=0.0;
end;


procedure TJobBudget.FormActivate(Sender: TObject);
begin
  If (Not DuringEdit) then
    CheckNeedStore(BOn);
end;




procedure TJobBudget.SetPrbBtnClick(Sender: TObject);
begin
  Send_UpdateList(BOff,104+Ord(Sender=SetPrBBtn));
end;

Function TJobBudget.ActiveBudget  :  Double;

Begin
  If (BRVF.Value<>0.0) then
    Result:=BRVF.Value
  else
    Result:=BOVF.Value;

end;

procedure TJobBudget.P2FV8FExit(Sender: TObject);

Var
  AltMod  :  Boolean;

begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit), ExLocal do
  Begin
    AltMod:=FloatModified;

    If (ActiveControl<>CanCP1Btn) and (AltMod) then
    Begin
      BAPP2F.Value:=Round_Up(DivWchk(Value,ActiveBudget)*100,2);
    end;
  end; {with..}


end;

procedure TJobBudget.BAV7FExit(Sender: TObject);
begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit), ExLocal do
  If (TabStop) then
  Begin
    BAPPF.Value:=DivWChk(Value,ActiveBudget)*100;
  end;

end;

procedure TJobBudget.BAPP2FEnter(Sender: TObject);
begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit), ExLocal do
  Begin
    ValPcnt:=Round_Up(Value,2);
  end;
end;

procedure TJobBudget.BAPP2FExit(Sender: TObject);

Var
  AltMod  :  Boolean;

begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit), ExLocal do
  Begin
    AltMod:=(ValPcnt<>Round_Up(Value,2));

    If (ActiveControl<>CanCP1Btn) and (AltMod) then
    Begin
      BAV8F.Value:=Round_Up(DivWchk(Value,100)*ActiveBudget,2);
    end;
  end; {with..}


end;



procedure TJobBudget.PageControl1Change(Sender: TObject);
begin
  If (PageControl1.ActivePage=ValPage) and (BAV8F.CanFocus) and (BAV8F.TabStop) then
    BAV8F.SetFocus;
end;

Initialization

SetPRStk:=6;
SetPRMode:=BOff;

end.
