unit RETLineU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,ExWrap1U,
  {$IFDEF SOP}
    InvLst3U,
  {$ENDIF}
  BTSupU1,
  SalTxl1U,
  SalTxl2U,
  BorBtns, bkgroup;


type
  TRETLine = class(TForm)
    A1SCodef: Text8Pt;
    A1PQF: TCurrencyEdit;
    A1QIF: TCurrencyEdit;
    A1LOF: Text8Pt;
    Id3QtyLab: Label8;
    PQLab: Label8;
    LocLab: Label8;
    Id3SCodeLab: Label8;
    Okdb1Btn: TButton;
    Candb1Btn: TButton;
    Label85: Label8;
    A1IssF: TCurrencyEdit;
    Label82: Label8;
    A2IssF: TCurrencyEdit;
    Label83: Label8;
    Label84: Label8;
    A1UCF: TCurrencyEdit;
    A1GLF: Text8Pt;
    GLLab: Label8;
    CCLab: Label8;
    A1CCF: Text8Pt;
    DepLab: Label8;
    A1DpF: Text8Pt;
    UDF1L: Label8;
    THUD1F: Text8Pt;
    UDF2L: Label8;
    THUD2F: Text8Pt;
    UDF3L: Label8;
    THUD3F: Text8Pt;
    UDF4L: Label8;
    THUD4F: Text8Pt;
    Id3SBox: TScrollBox;
    Id3Desc1F: Text8Pt;
    Id3Desc2F: Text8Pt;
    Id3Desc3F: Text8Pt;
    Id3Desc4F: Text8Pt;
    Id3Desc5F: Text8Pt;
    Id3Desc6F: Text8Pt;
    Id3VATF: TSBSComboBox;
    Id3DiscF: Text8Pt;
    Label81: Label8;
    Label86: Label8;
    Label87: Label8;
    Id3LTotF: TCurrencyEdit;
    GLDescF: Text8Pt;
    SBSBackGroup1: TSBSBackGroup;
    SBSBackGroup2: TSBSBackGroup;
    Id3StatCB1: TSBSComboBox;
    Label88: Label8;
    A1WOffF: TCurrencyEdit;
    A2WOffF: TCurrencyEdit;
    Label89: Label8;
    Label810: Label8;
    Id3LCostF: TCurrencyEdit;
    Label811: Label8;
    A1URCF: TCurrencyEdit;
    Label812: Label8;
    THUD5F: Text8Pt;
    THUD6F: Text8Pt;
    THUD7F: Text8Pt;
    THUD8F: Text8Pt;
    THUD9F: Text8Pt;
    THUD10F: Text8Pt;
    UDF6L: Label8;
    UDF7L: Label8;
    UDF8L: Label8;
    UDF9L: Label8;
    UDF10L: Label8;
    UDF5L: Label8;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Candb1BtnClick(Sender: TObject);
    procedure A1SCodefExit(Sender: TObject);
    procedure A1QIFExit(Sender: TObject);
    procedure A1GLFExit(Sender: TObject);
    procedure A1CCFExit(Sender: TObject);
    procedure A1SCodefDblClick(Sender: TObject);
    procedure A1LOFEnter(Sender: TObject);
    procedure A1LOFExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure A1WOFFFExit(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure Id3Desc1FKeyPress(Sender: TObject; var Key: Char);
    procedure Id3DiscFExit(Sender: TObject);
    procedure Id3VATFExit(Sender: TObject);
    procedure A1IssFEnter(Sender: TObject);
    procedure A1WOffFEnter(Sender: TObject);
    procedure A1SCodefEnter(Sender: TObject);
    procedure A1UCFEnter(Sender: TObject);
    procedure SetUDFields(UDDocHed  :  DocTypes);
  private
    { Private declarations }

    IdStored,
    StopPageChange,
    BeenInLocSplit,
    DelLnk,
    LocalAnalMode,
    AutoValueSugg,
    BadQty,
    NegQtyChk,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    LastQtyValue :  Double;

    LastLineDesc,
    LineDesc     :  TLineDesc;

    DispStk      :  TFStkDisplay;

    {$IFDEF SOP}
        TxAutoMLId :  MLIdOPtr;


    {$ENDIF}

    //PR: 13/11/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;
    function TransactionViewOnly : Boolean;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Procedure Set_EntryRO;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Function ConfirmQuit  :  Boolean;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    Procedure SetQtyMulTab;

    Procedure OutDesc;

    Procedure Form2Desc;

    Procedure OutIdGLDesc(GLCode  :  Str20;
                          OutObj  :  TObject);

    Procedure OutUserDef;

    Procedure Form2UserDef;

    Procedure OutId;

    procedure Form2Id;

    Procedure SetLink_Adj;

    Procedure Calc_LTot;

    {$IFDEF SOP}
      Procedure MLoc_GenLocSplit(Fnum,
                                 Keypath:  Integer);
    {$ENDIF}


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);



  public
    { Public declarations }


    ExLocal    :  TdExLocal;

    procedure ShowLink(InvR      :  InvRec;
                       VOMode    :  Boolean);

    Function CompStillEdit  :  boolean;


    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit,
                        InsMode    :  Boolean);

    procedure SetFieldProperties(Panel  :  TSBSPanel;
                                 Field  :  Text8Pt) ;


    procedure EditLine(InvR       :  InvRec;
                       Edit,
                       InsMode,
                       ViewOnly,
                       AnalMode   :  Boolean);

    //PR: 14/11/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;
  end;

Function CheckCompleted(Edit,MainChk,
                        BadQty,
                        NegQtyChk     :  Boolean;
                        ExLocal       :  TdExLocal;
                        ParentF       :  TForm;
                        RETLine       :  TRETLine)  : Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  VARRec2U,
  BTSupU2,
  CurrncyU,
  SBSComp2,
  ComnUnit,
  ComnU2,

  {$IFDEF PF_On}

     InvLst2U,

  {$ENDIF}

  ColCtrlU,
  CmpCtrlU,
  SysU2,
  MiscU,

  RetDoc1U,

  InvListU,

  InvCTSUU,

  PayF2U,
  GenWarnU,
  PWarnU,
  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  InvFSu3U,

  InvCt2SU,

  DiscU3U,

  WOPCT1U,

  {$IFDEF CU}
    Event1U,
  {$ENDIF}

  {$IFDEF SOP}
    MLoc0U,

  {$ENDIF}

  {$IFDEF VAT}
    GIRateU,
  {$ENDIF}

  RetSup1U,

  ThemeFix,

  PassWR2U,
  InvFSu2U,
  //GS 20/10/2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF;




{$R *.DFM}





Function CheckCompleted(Edit,MainChk,
                        BadQty,
                        NegQtyChk     :  Boolean;
                        ExLocal       :  TdExLocal;
                        ParentF       :  TForm;
                        RETLine       :  TRETLine)  : Boolean;

Const
  NofMsgs      =  13;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop, FLowStk,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  MaxBuild,
  FoundLong
           :  LongInt;

  BalNow   :  Double;


Begin
  New(PossMsg);  FLowStk:=BOff;
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='General Ledger Code is not valid.';
  PossMsg^[2]:='Stock Code is not valid.';
  PossMsg^[3]:='Cost Centre/ Department Code not valid.';
  PossMsg^[4]:=''; {Over returned..}
  PossMsg^[5]:='The Quantity required is not valid. Negative Stock is not allowed';
  PossMsg^[6]:='You must correct the last invalid entry before storing this line.';
  PossMsg^[7]:='Maximum line value exceeded.';
  PossMsg^[8]:='Location Code is not valid.';
  PossMsg^[9]:='An additional check is made via an external hook';
  PossMsg^[10]:='';
  PossMsg^[11]:='';
  PossMsg^[12]:='';
  PossMsg^[13]:='Check stock never called, so call it now.';



  Loop:=BOff;

  Test:=1;

  Result:=BOn;

  BalNow:=InvLTotal(ExLocal.LId,BOff,0);

  MaxBuild:=0;

  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LId do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=Not Syss.AutoValStk or (BalNow=0.0);

              If (Not Result) then
              Begin
                Result:=GetNom(Application.MainForm,Form_Int(NomCode,0),FoundLong,-1);

                If (Result) and (Not SBSIn) then
                  Result:=(Nom.NomType In BankSet+ProfitBFSet);
              end;

            end;

      2  :  Begin
              {$IFDEF STK}

                Result:=EmptyKey(StockCode,StkKeyLen);

                If (Not Result) then
                  Result:=GetStock(Application.MainForm,StockCode,Foundcode,-1);

              {$ELSE}

                Result:=BOn;

              {$ENDIF}
            end;




      {$IFDEF PF_On}

        3  :  Begin
                Result:=((Not Syss.UseCCDep) or (Not LComplete_CCDep(LId,BalNow)));

                If (Not Result) then
                Begin
                  Result:=BOn;
                  For Loop:=BOff to BOn do
                  Begin

                    Result:=(GetCCDep(Application.MainForm,CCDep[Loop],FoundCode,Loop,-1) and (Result));

                  end;
                end;

              end;

        4  :  Begin

                If (Assigned(RetLine)) then
                  ExtraMsg:=RetLine.Label82.Caption+' + '+RetLine.Label83.Caption+' cannot exceed the '+RetLine.PQLab.Caption;

                Result:=((Qty) >= (QtyDel+QtyWOff+QtyPWoff+SSDUplift));

              end;

        5  :  Result:=Not BadQty;


        9  :  If (Assigned(RetLine)) then {* Only call on a line store basis so its consistant with how ADJ's behave *}
              Begin {* Opportunity for hook to validate this line as well *}
                 {$IFDEF CU}

                   ExLocal.AssignFromGlobal(StockF);
                   
                   Result:=ValidExitHook(4000,20,ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;


      {$ENDIF}

      6  :  If (Assigned(RETLine)) then
            Begin
              Result:=(Not RETLine.CompStillEdit);

            end;

      7  :  Begin

              Result:=(BalNow<=MaxLineValue);

            end;
      8  : {$IFDEF SOP}

              If (Syss.UseMLoc) and (LComplete_MLoc(LId)) then {* Check location valid *}
              Begin
                Result:=Global_GetMainRec(MLocF,Quick_MLKey(MLocStk));
              end
              else
            {$ENDIF}
                Result:=BOn;


      13  :  Begin
                Result:=(Not (LInv.InvDocHed In StkRetPurchSplit)) or (Not Syss.UseStock) or (not CheckNegStk) or (NegQtyChk);

                If (Not Result) then
                Begin
                  If (LastId.MLocStk<>MLocStk) then {* Discount last qty as loc has changed and this is not an edit now *}
                    LastId.Qty:=0;

                  Check_StockCtrl(StockCode,(Qty*QtyMul)-(LastId.Qty*LastId.QtyMul),1+Ord(CheckNegStk),
                           FLowStk,IdDocHed,LId,ParentF.Handle);

                  Result:=Not FLowStk;

                  ShowMsg:=Result;

                  
                end;
              end;




    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  {$IFDEF DBD}
    If (Not Result) and (Debug) then
      MessageBeep(0);

  {$ENDIF}

  Dispose(PossMsg);

end; {Func..}



procedure TRETLine.ShowLink(InvR      :  InvRec;
                            VOMode    :  Boolean);

Var
  FoundCode  :  Str20;

begin
  ExLocal.AssignFromGlobal(IdetailF);


  ExLocal.LGetRecAddr(IdetailF);

  ExLocal.LInv:=InvR;

  // MH 23/11/2011 v6.9: Moved from FormDesign as it was using the global Inv record which was being
  // influenced by other code e.g. if you opened the NOM daybook it became a NOM which had interesting results!
  SetUDFields(ExLocal.LInv.InvDocHed);

  With ExLocal,LId,LInv do
  Begin
    Caption:=Pr_OurRef(LInv)+' Transaction Line';

    LViewOnly:=VOMode;

    If (LCust.CustCode<>CustCode) then
      LGetMainRecPos(CustF,CustCode);

    If (Is_FullStkCode(StockCode)) and (LStock.StockCode<>StockCode) then
      LGetMainRecPos(StockF,StockCode);


  end;

  If (ExLocal.LInv.InvDocHed In StkRetSalesSplit) then
  Begin
    A1UCF.DecPlaces:=Syss.NoNetDec;
    {Label82.Caption:='Qty Issued ';
    Label89.Caption:='Tot. Issued ';}



  end
  else
  Begin
    A1UCF.DecPlaces:=Syss.NoCosDec;
    {Label811.Visible:=BOff;
    Id3LCostF.Visible:=BOff;}
    Label811.Caption:='Original Cost';

  end;

  A1URCf.DecPlaces:=A1UCF.DecPlaces;

  Id3LCostF.DecPlaces:=Syss.NoCosDec;


  OutId;

  If (ExLocal.LastEdit) then {* Get desc lines if editing *}
    OutDesc;


  JustCreated:=BOff;

  If (ExLocal.LastEdit) then
    SetFieldFocus;

end;




{ ========== Build runtime view ======== }

procedure TRETLine.BuildDesign;


begin
  try
    With LineDesc.DescFields do
    Begin
      AddVisiRec(Id3Desc2F,BOff);
      AddVisiRec(Id3Desc3F,BOff);
      AddVisiRec(Id3Desc4F,BOff);
      AddVisiRec(Id3Desc5F,BOff);
      AddVisiRec(Id3Desc6F,BOff);
    end; {With..}
  except

    LineDesc.DescFields.Free;
    LineDesc.DescFields:=nil;

  end;{try..}

end;



procedure TRETLine.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  {* Set Version Specific Info *}

  {$IFNDEF SOP}

     LocLab.Visible:=BOff;
     A1LoF.Visible:=BOff;
  {$ELSE}

     LocLab.Visible:=Syss.UseMLoc;
     A1LoF.Visible:=LocLab.Visible;

  {$ENDIF}


  HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}



  A1CCF.Visible:=Not HideCC;
  A1DpF.Visible:=Not HideCC;

  CCLab.Visible:=A1CCF.Visible;
  DepLab.Visible:=A1CCF.Visible;

  A1PQF.DecPlaces:=Syss.NoQtyDec;
  A1QIF.DecPlaces:=Syss.NoQtyDec;


  A1WOFFF.DecPlaces:=Syss.NoQtyDec;
  A1IssF.DecPlaces:=Syss.NoQtyDec;
  A2IssF.DecPlaces:=Syss.NoQtyDec;
  A2WOffF.DecPlaces:=Syss.NoQtyDec;


  Label811.Visible:=Id3LCostF.Visible;
  Id3LCostF.Visible:=PChkAllowed_In(143);

  //GS 20/10/2011 ABSEXCH-11706: removed existing UDF setup code; replaced with calling pauls new method
  //PR: 23/11/2011 Changed to use global record as ExLocal isn't populated at this point.
  // MH 23/11/2011 v6.9: Moved to ShowLink where LInv is populated with the correct transaction
  //SetUDFields(Inv.InvDocHed);

  Label86.Caption:=CCVATName^;

  Set_RetLineStat(Id3StatCB1.Items);

  Set_DefaultVAT(Id3VATF.Items,BOn,BOff);
  Set_DefaultVAT(Id3VATF.ItemsL,BOn,BOn);

  BuildDesign;

end;

//GS 20/10/2011 ABSEXCH-11706: a copy of pauls user fields function
//PR: 14/11/2011 Amended to use centralised function EnableUdfs in CustomFieldsIntf.pas ABSEXCH-12129
//PR: 23/11/2011 Amended to resize form if enough fields are hidden.
procedure TRETLine.SetUDFields(UDDocHed  :  DocTypes);
const
  UDHEIGHT = 48; //Include height of edit + label + spacing
var
  VisibleFieldCount: Integer;
begin
{$IFDEF ENTER1}
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F],
             DocTypeToCFCategory(UDDocHed, True));

  VisibleFieldCount := NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]);

  ResizeUDFParentContainer(VisibleFieldCount, 5, self, UDHEIGHT);
  ResizeUDFParentContainer(VisibleFieldCount, 5, Okdb1Btn, UDHEIGHT);
  ResizeUDFParentContainer(VisibleFieldCount, 5, Candb1Btn, UDHEIGHT);
{$ENDIF}

end;

procedure TRETLine.FormActivate(Sender: TObject);
begin
  If (JustCreated) then
  Begin
    SetFieldFocus;

    {$IFDEF CU} {* Call hooks here *}
      GenHooks(4000,8,ExLocal);
    {$ENDIF}

  end;

  {$IFDEF SOP}
     OpoLineHandle:=Self.Handle;
  {$ENDIF}

end;


procedure TRETLine.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  LastQtyValue:=0; AutoValueSugg:=BOff;

  NegQtyChk:=BOff; BadQty:=BOff; LastQtyValue:=0;

  DelLnk:=BOff; LocalAnalMode:=BOff;

  LineDesc:=TLineDesc.Create;
  LastLineDesc:=nil;

  try
    With LineDesc do
    Begin
      Fnum:=IDetailF;
      Keypath:=IdFolioK;
    end;
  except

    LineDesc.Free;
    LineDesc:=nil;

  end;

  //GS 20/10/2011 ABSEXCH-11706: modified client height
  ClientHeight:=301;
  ClientWidth:=619;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TRetDoc) then
    With TRetDoc(Owner) do
      Self.SetFieldProperties(A1FPanel,A1YRefF);

  DispStk:=nil;

  BeenInLocSplit:=BOff;

  {$IFDEF SOP}
    TxAutoMLId:=nil;
  {$ENDIF}

  FormDesign;

end;




procedure TRETLine.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  GenCanClose(Self,Sender,CanClose,BOn);

  If (CanClose) then
    CanClose:=ConfirmQuit;

  If (CanClose) then
  Begin

    {$IFDEF CU} {* Call hooks here *}
       GenHooks(4000,7,ExLocal);
    {$ENDIF}

    Send_UpdateList(BOff,100);

  end;

end;

procedure TRETLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TRETLine.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

  LineDesc.Destroy;

  If (Assigned(LastLineDesc)) then
  Begin
    LastLineDesc.Free;
    LastLineDesc:=nil;
  end;


  {$IFDEF SOP}
    If (Assigned(TxAutoMLId)) then
      Dispose(TxAutoMLId,Done);
  {$ENDIF}

end;



procedure TRETLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TRETLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TRETLine.Send_UpdateList(Edit   :  Boolean;
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



Function TRETLine.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;


Procedure TRETLine.SetFieldFocus;

Begin
  If (Not ExLocal.LastEdit) or (Not A1IssF.Visible) then
  Begin
    If (A1SCodeF.CanFocus) and (Not A1SCodeF.ReadOnly) then
      A1SCodeF.SetFocus;
  end
  else
  Begin
    If (A1PQF.Value=0.0) and (A1QIF.CanFocus) then
      A1QIF.SetFocus
    else
      If (A1IssF.CanFocus) and (ExLocal.LInv.InvDocHed In StkRetSalesSplit) then
        A1IssF.SetFocus
      else
        If (A1WOFFF.CanFocus) then
          A1WOffF.SetFocus
  end;
end; {Proc..}


Procedure TRETLine.Set_EntryRO;

Begin
  With ExLocal do
  If (InAddEdit) then
  Begin
    If (Ea2Case(LId,LStock,LastId.QtyPick+LastId.Qty)<>(A1QIF.Value+A1PQf.Value)) then
    Begin
      A1IssF.Value:=0.0;
      A1IssF.TabStop:=BOff;
      A1IssF.ReadOnly:=BOn;
      A1IssF.Color:=clBtnFace;

      A1WOffF.Value:=0.0;

    end
    else
      If (LastId.QtyPWOff+LastId.SSDUplift+A1IssF.Value+A1WOffF.Value<>0.0) then
      Begin
        {A1QIF.Value:=0.0;}

        A1QIF.TabStop:=BOff;
        A1QIF.ReadOnly:=BOn;
        A1QIF.Color:=clBtnFace;
      end
      else
      Begin
        A1QIF.TabStop:=BOn;
        A1QIF.ReadOnly:=BOff;
        A1QIF.Color:=clWindow;

        A1IssF.TabStop:=BOn;
        A1IssF.ReadOnly:=BOff;
        A1IssF.Color:=clWindow;

      end;


    A1WOffF.TabStop:=A1IssF.TabStop;
    A1WOffF.ReadOnly:=A1IssF.ReadOnly;
    A1WOffF.Color:=A1IssF.Color;

    A1PQF.TabStop:=A1QIF.TabStop;
    A1PQF.ReadOnly:=A1QIF.ReadOnly;
    A1PQF.Color:=A1QIF.Color;

    If (A1IssF.Value=0.0) then
    Begin
      A1URCF.TabStop:=BOff;
      A1URCF.ReadOnly:=BOn;
      A1URCF.Color:=clBtnFace;
    end
    else
    Begin
      A1URCF.TabStop:=BOn;
      A1URCF.ReadOnly:=BOff;
      A1URCF.Color:=clWindow;
    end;
  end;
end;


Function TRETLine.CompStillEdit  :  boolean;

Var
  Loop  :  Integer;

Begin
  Result:=BOff;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    Begin
      Result:=Text8Pt(Components[Loop]).StillEdit;
    end
      else
        If (Components[Loop] is TCurrencyEdit) then
        Begin
          Result:=TCurrencyEdit(Components[Loop]).StillEdit;
        end;

    If (Result) then
      Break;
  end;

end;

procedure TRETLine.Candb1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk)  then
    Begin
      // MH 16/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
      //                                   fields which processes the text and updates the value
      If (ActiveControl <> Okdb1Btn) Then
        // Move focus to OK button to force any OnExit validation to occur
        Okdb1Btn.SetFocus;

      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = Okdb1Btn) Then
        StoreId(IdetailF,SKeypath);
    end
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


Procedure TRETLine.WMCustGetRec(Var Message  :  TMessage);

Var
  DPtr    :  ^Double;


Begin

  With Message do
  Begin


    Case WParam of


     {$IFDEF SOP}
       212  :  Begin

                 DPtr:=Pointer(LParam);

                 Self.Enabled:=BOff;

                 TForm(Self.Owner).Enabled:=BOff;

                 Display_LocUse(Self,ExLocal.LId,ExLocal.LStock,DPtr^,TxAutoMLId);

                 Self.Enabled:=BOn;

                 With TForm(Self.Owner) do
                 Begin
                   Enabled:=BOn;
                   Show;
                 end;

                 Show;

                 Dispose(DPtr);
                 BeenInLocSplit:=BOn;

               end;
     {$ELSE}
       212  :  ;


     {$ENDIF}


    end; {Case..}

  end;
  Inherited;
end;


Function TRETLine.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;
  EditId :  IDetail;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and (CheckNeedStore) and (Not ExLocal.LViewOnly) and (Not IdStored) then
  Begin

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);

    DelLnk:=BOn;
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreId(IdetailF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(IdetailF,LastRecAddr[IdetailF]);

                {$IFDEF STK}
                   {$B-}
                   If (A1SCodeF.Text<>'') and (ExLocal.LStock.StockCode=FullStockCode(A1SCodeF.Text)) and (DelLnk) and (Assigned(LineDesc)) and (LineDesc.HasDesc) {(LastId.StockCode<>FullStockCode(Id3SCodeF.Text))} then
                   {$B+}
                   Begin
                     AssignToGlobal(IdetailF);

                     Delete_Kit(ExLocal.LStock.StockFolio,0,ExLocal.LInv);

                     {* Attempt to refresh list *}

                     Send_UpdateList(BOff,30);

                   end;


                {$ENDIF}


                try
                  {$B-}
                  If (LastEdit) and (Not LViewOnly) and (Assigned(LastLineDesc)) and (LastLineDesc.BeenDeleted) and (DelLnk) then
                  Begin
                    EditId:=LId;
                    LSetDataRecOfs(IdetailF,LastRecAddr[IdetailF]); {* Retrieve record by address Preserve position *}

                    Status:=GetDirect(F[IdetailF],IdetailF,LRecPtr[IdetailF]^,CurrKeyPath^[IdetailF],0); {* Re-Establish Position *}

                    If (LId.LineNo>EditId.LineNo) then {During the edit it got renumbered..}
                    Begin
                      LastLineDesc.RenumberBy(LId.LineNo-EditID.LineNo);
                    end;

					// MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
                    LastLineDesc.StoreMultiLines(LId,LInv, False);
                    Send_UpdateList(BOff,30);

                  end;

                  {$B+}
                finally
                  LastLineDesc.Free;
                  LastLineDesc:=Nil;

                end;


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



procedure TRETLine.SetIdStore(EnabFlag,
                             VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode or FAllowPostedEdit;

  Okdb1Btn.Enabled:=Not VOMode or FAllowPostedEdit;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    with Text8Pt(Components[Loop]) do
    Begin
      If (Tag=1) then
        ReadOnly:= VOMode and not AllowPostedEdit;
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


  Set_EntryRO;
end;


Procedure TRETLine.SetQtyMulTab;

Begin
end;



{ ============== Display Id Record ============ }


Procedure TRETLine.OutDesc;

Var
  n  :  Integer;

Begin
  With ExLocal,LId,LineDesc do
  Begin

    If (Is_FullStkCode(StockCode)) then
      LDKitLink:=LStock.StockFolio
    else
      LDKitLink:=FolioRef;

    LDFolio:=FolioRef;

    Editing:=BOn;

    GetMultiLines(LastRecAddr[Fnum],BOn);

    SetDescFields;

  end;

end;


Procedure TRETLine.Form2Desc;

Var
  n,
  PrevCount,
  NowCount,
  noLines  :  Integer;

  FoundOk  :  Boolean;


Begin

  With LineDesc.DescFields do
  Begin

    noLines:=Pred(Count);
    PrevCount:=Linedesc.Count;  NowCount:=0;

    FoundOk:=BOn;

    While (noLines>=0) and (FoundOk) do
    Begin
      FoundOk:=EmptyKey(IdDescfRec(noLines).Text,DocDesLen);

      If (FoundOk) then
        Dec(noLines);

    end;

    For n:=0 to Pred(Count) do
    Begin
      If (n<=noLines) then
      Begin
        If (n>Pred(LineDesc.Count)) then
          LineDesc.AddVisiRec(IdDescfRec(n).Text,0,0)
        else
          LineDesc.IdRec(n)^.fLine:=IdDescfRec(n).Text;
      end
      else
      Begin
        If (noLines=-1) and (LineDesc.Count>0) then
        Begin
          If (n=0) then {We have no additional lines any more, but we used to, so get rid}
          Begin
            LineDesc.Clear;
            Break;
          end;
        end
        else
          If (n<=Pred(LineDesc.Count)) then
            LineDesc.Delete(Pred(LineDesc.Count));
      end;
    end;

  end; {With..}

  With ExLocal,LId,LineDesc do
  Begin
    {* Delete any old lines first *}

    LDFolio:=LId.FolioRef;

    If (Not LastEdit) then {* Get folio here for non stock lines *}
    Begin
      If (Is_FullStkCode(StockCode)) then
        LDKitLink:=LStock.StockFolio
      else
        LDKitLink:=LId.FolioRef;
    end;

    If (LastEdit) or ((HasDesc) and (noLines>-1)) then {* Delete what was there first *}
    Begin
      If (Is_FullStkCode(StockCode)) then
        LDKitLink:=LStock.StockFolio;

      NowCount:=MaxCount;

      If (LastEdit) then {Only delete original qty}
        MaxCount:=PrevCount;

      GetMultiLines(LastRecAddr[Fnum],BOff);

      MaxCount:=NowCount;
    end;



	// MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
    StoreMultiLines(LId,LInv, LastIns);

  end; {With..}
end;


Procedure TRETLine.OutIdGLDesc(GLCode  :  Str20;
                               OutObj  :  TObject);

Var
  FoundOk  :  Boolean;
  NomCode,
  FoundCode:  LongInt;
  FoundCode2
           :  Str20;

Begin
  {$B-}
  If (Assigned(OutObj)) and (OutObj is Text8Pt) then
  With Text8pt(OutObj) do
  Begin
    NomCode:=IntStr(Trim(GLCode));

    If (Nom.NomCode<>NomCode) and (NomCode<>0)then
      FoundOk:=GetNom(Self,Form_Int(NomCode,0),FoundCode,-1)
    else
      FoundOk:=(NomCode<>0);

    If (FoundOk) then
      Text:=Nom.Desc
    else
      Text:='';
  end;

  {$B+}
end;


Procedure TRETLine.OutUserDef;

Begin
  With ExLocal,LId do
  Begin
    THUD1F.Text:=LineUser1;
    THUD2F.Text:=LineUser2;
    THUD3F.Text:=LineUser3;
    THUD4F.Text:=LineUser4;
    //GS 20/10/2011 ABSEXCH-11706: put customisation values into text boxes
    THUd5F.Text:=LineUser5;
    THUd6F.Text:=LineUser6;
    THUd7F.Text:=LineUser7;
    THUd8F.Text:=LineUser8;
    THUd9F.Text:=LineUser9;
    THUd10F.Text:=LineUser10;
  end; {With..}
end;

Procedure TRETLine.Form2UserDef;

Begin
  With ExLocal,LId do
  Begin
    LineUser1:=THUD1F.Text;
    LineUser2:=THUD2F.Text;
    LineUser3:=THUD3F.Text;
    LineUser4:=THUD4F.Text;
    //GS 20/10/2011 ABSEXCH-11706: write udef field values into customisation object
    LineUser5:=THUd5F.Text;
    LineUser6:=THUd6F.Text;
    LineUser7:=THUd7F.Text;
    LineUser8:=THUd8F.Text;
    LineUser9:=THUd9F.Text;
    LineUser10:=THUd10F.Text;
  end; {With..}
end;


Procedure TRETLine.OutId;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

Begin
  With ExLocal,LId do
  Begin
    A1SCodeF.Text:=StockCode;
    A1SCodeF.OrigValue:=StockCode;


    If (LStock.StockCode<>StockCode) then
    Begin
      FoundOk:=GetStock(Self,A1SCodeF.Text,FoundCode,-1);

      If (FoundOk) then
        AssignFromGlobal(StockF);
    end;

    A1LoF.Text:=MLocStk;

    A1PQF.Value:=Ea2Case(LId,LStock,Qty);

    A1QIF.Value:=Ea2Case(LId,LStock,QtyPick);

    A2IssF.Value:=Ea2Case(LId,LStock,QtyDel);
    A1IssF.Value:=Ea2Case(LId,LStock,QtyPWOff);

    A2WOFFF.Value:=Ea2Case(LId,LStock,QtyWOff);
    A1WOFFF.Value:=Ea2Case(LId,LStock,SSDUplift);

    A1UCF.Value:=NetValue;

    A1URCF.Value:=SSDSPUnit;

    A1GLF.Text:=Form_Int(NomCode,0);

    Id3StatCB1.ItemIndex:=DocLTLink;

    A1CCF.Text:=CCDep[BOn];
    A1DpF.Text:=CCDep[BOff];

    If (VATCode In VATSet) then
      Id3VATF.ItemIndex:=GetVATIndex(VATCode);

    OutIdGLDesc(A1GLF.Text,GLDescF);


    Id3DiscF.Text:=PPR_PamountStr(Discount,DiscountChr);

    Id3LCostF.Value:=CostPrice;

    Id3LTotF.Value:=InvLTotal(LId,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken)));

    
    Id3Desc1F.Text:=Desc;



    THUd1F.Text:=LineUser1;
    THUd2F.Text:=LineUser2;
    THUd3F.Text:=LineUser3;
    THUd4F.Text:=LineUser4;
    //GS 20/10/2011 ABSEXCH-11706: put customisation values into text boxes
    THUd5F.Text:=LineUser5;
    THUd6F.Text:=LineUser6;
    THUd7F.Text:=LineUser7;
    THUd8F.Text:=LineUser8;
    THUd9F.Text:=LineUser9;
    THUd10F.Text:=LineUser10;

    JustCreated:=BOff;
  end;


end;


procedure TRETLine.Form2Id;

Begin

  With EXLocal,LId do
  Begin
    NomCode:=IntStr(A1GLF.Text);

    CCDep[BOn]:=A1CCF.Text;
    CCDep[BOff]:=A1DpF.Text;

    StockCode:=FullStockCode(A1SCodeF.Text);

    Qty:=Case2Ea(LId,LStock,A1PQF.Value);
    QtyPack:=QtyMul;
    QtyPick:=Case2Ea(LId,LStock,A1QIF.Value);
    SSDUplift:=Case2Ea(LId,LStock,A1WOFFF.Value);
    QtyPWOff:=Case2Ea(LId,LStock,A1IssF.Value);

    NetValue:=A1UCF.Value;

    SSDSPUnit:=A1URCF.Value;

    {$IFDEF SOP}
      MLocStk:=Full_MLocKey(A1LoF.Text);

    {$ELSE}
      MLocStk:=A1LoF.Text;

    {$ENDIF}


    ProcessInputPAmount(Discount,DiscountChr,Id3DiscF.Text);

    With Id3VATF do
      If (ItemIndex>=0) then
        VATCode:=Items[ItemIndex][1];

    If (Id3StatCB1.ItemIndex>=0) then
      DocLTLink:=Id3StatCB1.ItemIndex;

    LineUser1:=THUd1F.Text;
    LineUser2:=THUd2F.Text;
    LineUser3:=THUd3F.Text;
    LineUser4:=THUd4F.Text;
    //GS 20/10/2011 ABSEXCH-11706: write udef field values into customisation object
    LineUser5:=THUd5F.Text;
    LineUser6:=THUd6F.Text;
    LineUser7:=THUd7F.Text;
    LineUser8:=THUd8F.Text;
    LineUser9:=THUd9F.Text;
    LineUser10:=THUd10F.Text;

    Desc:=Id3Desc1F.Text;


  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TRETLine.ProcessId(Fnum,
                            Keypath     :  Integer;
                            Edit,
                            InsMode     :  Boolean);

Var
  KeyS  :  Str255;

  CurrRLine
        :  LongInt;

Begin

  Addch:=ResetKey;

  IdStored:=BOff;

  KeyS:='';

  ExLocal.InAddEdit:=BOn;

  ExLocal.LastEdit:=Edit;

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
      AddCh:=Esc;
  end;


  If (Addch<>Esc) then
  With ExLocal,LId do
  begin
    LastIns:=InsMode;


    If (Not Edit) then
    Begin
      CurrRLine:=Id.LineNo; {* this is correct, as LId not set on an insert *}

      LastQtyValue:=0;

      LResetRec(Fnum);

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      If (InsMode) and (CurrRLine>0) then  {* Do not allow insert on first blank line! *}
        LineNo:=CurrRLine
      else
        LineNo:=LInv.ILineCount;

      ABSLineNo:=LInv.ILineCount;

      IDDocHed:=LInv.InvDocHed;

      PostedRun:=StkAdjRunNo;

      NomMode:=StkAdjNomMode;

      QtyMul:=1;

      QtyPack:=QtyMul;

      PriceMulX:=1.0;

      MLocStk:=LInv.DelTerms;

      LineType:=StkLineType[IdDocHed];

      Currency:=LInv.Currency;

      CXRate:=LInv.CXRate;

      CurrTriR:=LInv.CurrTriR;

      PYr:=LInv.ACYr;
      PPr:=LInv.AcPr;

      Payment:=SetRPayment(LInv.InvDocHed);

      If (Syss.AutoClearPay) then
        Reconcile:=ReconC;

      CustCode:=LInv.CustCode;

      PDate:=LInv.DueDate;

      If (JBCostOn) then
      Begin

        JobCode:=LInv.DJobCode;
        AnalCode:=LInv.DJobAnal;


        NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);

      end;



    end
    else
    Begin
      LastLineDesc:=TLineDesc.Create;

      try
        If (Assigned(LineDesc)) then {* Take a copy of the lines as they were *}
          LineDesc.AssignCopy(LastLineDesc);

      except
        LastLineDesc.Free;
        LastLineDesc:=nil;
      end;

      LastQtyValue:=QtyPick;

    end;

      
    LastId:=LId;


    OutId;

    SetIdStore(BOn,ExLocal.LViewOnly);

  end; {If Abort..}

end; {Proc..}







{$IFDEF SOP}
{ ==== Proc to Generate Automatic ==== }

  Procedure TRETLine.MLoc_GenLocSplit(Fnum,
                                      Keypath:  Integer);

  Var
    Found  :  Boolean;
    TmpStr :  Str20;

    DCnst  :  Integer;

    TmpId  :  Idetail;

    StockR :  StockRec;

  Begin
    If (Assigned(TxAutoMLId)) then
    With TxAutoMLId^,EXLocal,LId do
    Begin
      LGetRecAddr(Fnum);

      Found:=FindDir(BOn);

      While (Found) do
      With CarryFR^ do
      Begin
        If (idLoc<>NdxWeight) then
        Begin
          LId.MLocStk:=IdLoc;

          LId.SerialQty:=0;

          LId.BinQty:=0.0;

          If (Not (IdDocHed In StkAdjSplit)) then
          Begin
            LineNo:=LInv.ILineCount;

            {* Set on all Lines *}


            ABSLineNo:=LInv.ILineCount;

            If (Stock.StockCode<>StockCode) then
            Begin
              If (LGetMainRecPos(StockF,StockCode)) then
                AssignToGlobal(StockF);
            end;


            Qty:=1;
            QtyPick:=0.0;
            QtyDel:=0.0;
            QtyWOff:=0.0;

            TmpId:=LId;

            SetLink_Adj;

            DCnst:=1;
          end
          else
            DCnst:=-1;

          Qty:=idQTLoc*DCnst;
          QtyPick:=Qty;

          Self.Enabled:=BOff;

          TForm(Self.Owner).Enabled:=BOff;

          StockR:=LStock;

          If (Is_SerNo(LStock.StkValType)) then
            StockR.StockCode:=NdxWeight; {* Force link up to stock *}

          Control_SNos(LId,LInv,StockR,1,Self);

          Self.Enabled:=BOn;

          With TForm(Self.Owner) do
          Begin
            Enabled:=BOn;
            Show;
          end;

          Deduct_ADJStk(LId,LInv,BOn);

          Inc(LInv.ILineCount);

          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          If (StatusOk) then
          Begin
            UpdateWORCost(LInv,LId,0);

          end;

        end;

        Found:=FindDir(BOff);

      end; {While..}

      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,Keypath); {* Re-Establish Position *}

      Send_UpdateList(BOff,31);
    end; {End With..}
  end;
{$ENDIF}


procedure TRETLine.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpId
       :  Idetail;

  KeyS :  Str255;

  SMode:  Byte;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transactions }
  ButtonState: Boolean;
  CursorState: TCursor;

Begin
  KeyS:='';  SMode:=0;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transactions }
  ButtonState := Okdb1Btn.Enabled;
  CursorState := Cursor;

  Okdb1Btn.Enabled := False;
  try

    Form2Id;


    With ExLocal,LId do
    Begin

      {$IFDEF CU} {* Call any pre store hooks here *}

        GenHooks(4000,10,ExLocal);

      {$ENDIF}

      COk:=CheckCompleted(LastEdit,BOff,BadQty,NegQtyChk,ExLocal,TForm(Self.Owner),Self);


      If (COk) then
      Begin
        Cursor:=CrHourGlass;
        if not LViewOnly then
        begin

        {$IFDEF STK} {v5.52. Open up for non SPOP versions using multi bins}
            Self.Enabled:=BOff;
            TForm(Owner).Enabled:=BOff;

           If (IdDocHed In StkRetSalesSplit) then
             SMode:=(24*Ord((IdDocHed In StkRetSalesSplit))+  ((1*Ord(QtyPWOff+SSDUplift+LastId.QtyPWOff+LastId.SSDUplift<>0.0))))
           else
             SMode:=(25*(1*Ord(QtyPWOff+LastId.QtyPWOff<>0.0)));

           If (Not SSDUseLine) or (IdDocHed In StkRetSalesSplit) or ((Stock.MultiBinMode or (Is_SerNo(Stock.StkValType))) and (Copy(RET_GetSORNo(SOPLink),1,3) = DocCodes[WOR]))  then
             Control_SNos(LId,LInv,LStock,1+SMode,Self);

           Self.Enabled:=BOn;
           TForm(Owner).Enabled:=BOn;
           TForm(Owner).Show;
        {$ENDIF}

          Deduct_ADJStk(LastId,LInv,BOff); {* Only deduct returns levels... + live if PRN *}

          Deduct_ADJStk(LId,LInv,BOn);
        end; //If not LViewOnly

        Form2Desc;

        if not LViewOnly then
          CalcVATExLocal(ExLocal,BOff,nil);

        If (LastEdit) then
        Begin

          If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
          Begin

            TmpId:=LId;

            LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

            Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

            LId:=TmpId;

          end;

          Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        end
        else
        Begin
          If (LastIns) then
          Begin
            TmpId:=LId;

            MoveEmUp(FullNomKey(LId.FolioRef),
                   FullIdKey(LId.FolioRef,LastAddrD),
                   FullIdKey(LId.FolioRef,LId.LineNo),
                   1,
                   Fnum,KeyPath,
                   // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
                   mumInsert);

            LId:=TmpId;
          end;


          Inc(LInv.ILineCount);


          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        end;

        Report_BError(Fnum,Status);

        If (StatusOk) and (Not TransactionViewOnly) then
        Begin
          if not LViewOnly then
          begin
            With LastId do
              UpdateRecBal(LastId,LInv,BOn,BOff,0);

            With LId do
              UpdateRecBal(LId,LInv,BOff,BOn,0);

          end;
          {* Preserv position *}


          Status:=LPresrv_BTPos(Fnum,Keypath,F[Fnum],LastRecAddr[Fnum],BOff,BOff);


          If not LViewOnly and ((LastId.Qty<>LId.Qty) or (LastId.QtyPWoff<>LId.QtyPWOff)  or (LastId.SSDUplift<>LId.SSDUplift))  then
            Re_CalcKitRet(LStock.StockFolio,LId);


          {$IFDEF CU}

            ValidExitHook(4000,14,ExLocal);

          {$ENDIF}


          Status:=LPresrv_BTPos(Fnum,Keypath,F[Fnum],LastRecAddr[Fnum],BOn,BOff);

        end;

        { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transactions }
        Cursor := CursorState;

        InAddEdit:=Boff;

        If (LastEdit) then
          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

        SetIdStore(BOff,BOff);

        IdStored:=BOn;

        Send_UpdateList(LastEdit,8);

        LastValueObj.UpdateAllLastValues(Self);

        {$IFDEF SOP}
          If (Assigned(TxAutoMLId)) and not LViewOnly then
            MLoc_GenLocSplit(Fnum,Keypath);
        {$ENDIF}

        Close;
      end
      else
        SetFieldFocus;

    end; {With..}

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transactions }
  finally
    Cursor := CursorState;
    Okdb1Btn.Enabled := ButtonState;
  end;

end;


procedure TRETLine.SetFieldProperties(Panel  :  TSBSPanel;
                                      Field  :  Text8Pt) ;

Var
  n  : Integer;


Begin
  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(Field.Font);
        Color:=Field.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        {CheckColor:=Field.Color;}
        Color:=Panel.Color;
      end;

  end; {Loop..}


end;


procedure TRETLine.EditLine(InvR       :  InvRec;
                            Edit,
                            InsMode,
                            ViewOnly,
                            AnalMode   :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    LocalAnalMode:=AnalMode;

    ShowLink(InvR,ViewOnly);

    ProcessId(IdetailF,CurrKeyPath^[IdetailF],LastEdit,InsMode);

    If (Edit) and (Self.ActiveControl=A1IssF) then
      A1IssFEnter(A1IssF)
    else
      If (Edit) and (Self.ActiveControl=A1WOffF) then
        A1WOffFEnter(A1WOffF);

  end;
end;



procedure TRETLine.A1GLFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn)  then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,2));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(NomF);



      end;


      If (FoundOk) then
      With ExLocal,LId do
      Begin

        StillEdit:=BOff;

        Text:=Form_Int(FoundLong,0);

        OutIdGLDesc(Text,GLDescF);
      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;





procedure TRETLine.A1CCFExit(Sender: TObject);
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
      Form2Id;
      
      FoundCode:=Name;

      IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

      {$IFDEF CU} {* Call hooks here *}
          Text:=TextExitHook(4000,16+Ord(Not Iscc),Text,ExLocal);
      {$ENDIF}

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);


      If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) and (Syss.UseCCDep) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetCCDep(Self.Owner,FoundCode,FoundCode,IsCC,2));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(PWrdF);

        end;


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






 Procedure TRETLine.SetLink_Adj;

 Var
   Rnum  :  Real;
   {$IFDEF SOP}
     TmpStk  :  ^StockRec;
   {$ENDIF}

 Begin
   With ExLocal,LId do
   Begin
     {$IFDEF SOP}
        New(TmpStk);
        TmpStk^:=LStock;

        Stock_LocLinkSubst(LStock,MLocStk);
     {$ENDIF}


     Link_StockCtrl(LId,LInv,LCust,1,0,0,Qty*QtyMul,1,LastIns,LineDesc);
     SSDSPUnit := 0.0;

                                                       {* Changed from BOff? *}
     Rnum:=Currency_ConvFT(Calc_StkCP(LStock.CostPrice,LStock.BuyUnit,(LStock.DPackQty And LStock.CalcPack)),
                           LStock.PCurrency,LInv.Currency,UseCoDayRate);

     {* To be replaced by FIFO Calc *}

     CostPrice:=Round_Up(Rnum,Syss.NoCosDec);


     If (IdDocHed In StkRetSalesSplit) and (LStock.ReturnGL<>0) then
       NomCode:=LStock.ReturnGL
     else
       If (IdDocHed In StkRetPurchSplit) and (LStock.PReturnGL<>0) then
         NomCode:=LStock.PReturnGL;

     If (NomIOFlg=1) then {* Keep it as a warranty item zero priced *}
       NetValue:=0.0;

     {$IFDEF SOP}
       LStock:=TmpStk^;
       Dispose(TmpStk);
     {$ENDIF}
   end;
 end; {Proc..}


Procedure TRETLine.Calc_LTot;


Begin
  Form2Id;

  With ExLocal,LId do
  Begin


    Id3LTotF.Value:=InvLTotal(LId,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken)));

    If (Id3LTotF.Value<>0) and (Not (VATCode In VATSet)) then
    Begin

      VATCode:=LCust.VATCode;
      VATIncFlg:=LCust.CVATIncFlg;

      OutId;
    end;


    {* Don't call if nothing has changed, or if the line is still inclusive v4.31.004/build 124 *}

    If (VATCode In VATSet) and (VATCode<>VATICode) then
    Begin

      {$IFDEF CU} {* Call hooks here *}
        GenHooks(4000,26,ExLocal);
      {$ENDIF}

    end;

  end; {With..}
end; {Proc..}




procedure TRETLine.A1SCodefEnter(Sender: TObject);
begin
  With ExLocal do
  Begin
    If (LastEdit) then
      LastQtyValue:=LastId.Qty*LastId.QtyMul{*StkChkCnst};
  end;

  {$IFDEF CU}
    If (Not A1PQF.ReadOnly) and (Sender=A1PQF) then
    Begin
      Form2UserDef;

      A1PQF.Value:=ValueExitHook(4000,1,A1PQF.Value,ExLocal);

      OutUserDef;
    end;
  {$ENDIF}


end;



procedure TRETLine.A1SCodefExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  SetQtyOn,
  AltMod     :  Boolean;

  Rnum       :  Double;

  StoreQty   :  Double;


begin

  Rnum:=0;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;  SetQtyOn:=BOff;

    FoundCode:=Text;

    {$IFDEF CU} {* Call hooks here *}

        StoreQty:=ExLocal.LId.Qty;

        Text:=TextExitHook(4000,15,Text,ExLocal);

        SetQtyOn:=(ExLocal.LId.Qty<>StoreQty) or (EnableCustBtns(4000,15));

        If (SetQtyOn) then {This hook can set the qty also here, but in so doing will not kick in any qty based events}
        Begin
          A1PQF.Value:=Ea2Case(ExLocal.LId,ExLocal.LStock,ExLocal.LId.Qty);
          StoreQty:=ExLocal.LId.Qty;
        end;


        AltMod:=(AltMod or (FoundCode<>Text));

      {$ENDIF}

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>Candb1Btn) then
    Begin

      StillEdit:=BOn;

      If (Trim(OrigValue)<>'') and (ExLocal.LStock.StockCode=FullStockCode(OrigValue)) then
        Begin
          ExLocal.AssignToGlobal(IdetailF);
          Delete_Kit(ExLocal.LStock.StockFolio,0,ExLocal.LInv);

          If (Assigned(LastLineDesc)) then
            LastLineDesc.BeenDeleted:=BOn;
        end;


      FoundOk:=(GetsdbStock(Self.Owner,FoundCode,ExLocal.LInv.CustCode,FoundCode,ExLocal.LId.sdbFolio,3));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(StockF);

        SetQtyMulTab;



        StillEdit:=BOff;

        Text:=FoundCode;

        With ExLocal,LId do
        Begin
          Form2Id;


          If (OrigValue<>'') and (CheckNegStk) then
          Begin
            LastQtyValue:=0.0;
          end;


          {$IFDEF SOP}
            SendSuperOpoStkEnq(FoundCode,MLocStk,LInv.CustCode,LInv.Currency,-1,0);

          {$ELSE}
            SendToObjectStkEnq(FoundCode,MLocStk,LInv.CustCode,LInv.Currency,-1,0);

          {$ENDIF}


          SetLink_Adj;

          {$IFDEF CU} {* Call hooks here *}
              GenHooks(4000,11,ExLocal);
          {$ENDIF}



          OutId;


        end;


        If (Not Syss.UseMLoc) then
        Begin
          If (A1QIF.CanFocus) then
          Begin
            A1QIF.SetFocus;
            A1QIF.SelectAll;
          end;
        end
        else
          If (A1LOF.CanFocus) then
          Begin
            A1LOF.SetFocus;
            A1LOF.SelectAll;
          end;

      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;


procedure TRETLine.A1WOFFFExit(Sender: TObject);
Var
  AltMod,
  FlowStk  :  Boolean;

begin
  FLowStk:=BOff;

  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit) do
  Begin
    AltMod:=FloatModified;

    If ((AltMod) or (StillEdit)) and (ActiveControl<>Candb1Btn) then
    With ExLocal,LId do
    Begin
      Form2Id;

      StillEdit:=BOn;


      StillEdit:=BOff;


    end;

  end; {If/With..}
end;


procedure TRETLine.A1IssFEnter(Sender: TObject);
Begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit), ExLocal do
  Begin
    If (Not JustCreated) and (ExLocal.InAddEdit) and (ActiveControl<>Candb1Btn) and (A1PQF.Value<>0.0) and (A2IssF.Value+A2WOFFF.Value+A1WOFFF.Value<A1PQF.Value)
       and (A1QIF.Value=0.0) then
      If (A1IssF.Value=0.0) then
      Begin
        Value:=A1PQF.Value-(A2IssF.Value+A2WOFFF.Value+A1WOFFF.Value);

        If (Value<0) then
          Value:=0;

        SelectAll;
      end;

  end;
end;

procedure TRETLine.A1WOffFEnter(Sender: TObject);
begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit), ExLocal do
  Begin
    If (Not JustCreated) and (ExLocal.InAddEdit) and (ActiveControl<>Candb1Btn) and (A1PQF.Value<>0.0) and (A1IssF.Value+A2IssF.Value+A2WOFFF.Value+A1WOFFF.Value<A1PQF.Value)
       and (A1QIF.Value=0.0) and (Not AutoValueSugg) then
      If (A1WOFFF.Value=0.0) then
      Begin
        Value:=A1PQF.Value-(A2IssF.Value+A1IssF.Value+A1WOFFF.Value);

        If (Value<0) then
          Value:=0;

        AutoValueSugg:=(Value<>0.0);

        SelectAll;
      end;

  end;

end;


procedure TRETLine.A1UCFEnter(Sender: TObject);
begin
  {$IFDEF CU} {* Call any pre store hooks here *}
    {$B-}
    If (Sender is TCurrencyEdit) and (Not TCurrencyEdit(Sender).ReadOnly) and (Sender=A1UCF) then
    Begin
    {$B+}
      Form2Id;

      GenHooks(4000,9,ExLocal);

      OutId;
    end;
  {$ENDIF}

end;


procedure TRETLine.A1QIFExit(Sender: TObject);
Var
  AltMod,
  FlowStk,
  Flg,
  Ok2Cont  :  Boolean;

  MaxBuild :  LongInt;

begin
  FLowStk:=BOff; MaxBuild:=0;  Ok2Cont:=BOn;

  If (Sender is TCurrencyEdit) then
  With ExLocal, (Sender as TCurrencyEdit) do
  Begin
    AltMod:=FloatModified;

    If (AltMod) and (ExLocal.LId.NomIOFlg=1) and (Sender=A1UCF) then
    Begin
      If (Value<>0.0) and (LastValue=0.0) then
      Begin
        Ok2Cont:=(CustomDlg(Application.MainForm,'Please note','Warranty Line',
                                    'This item has been returned within warranty and so is zero priced.'+#13+#13+
                                    'Please confirm you want to override the warranty status.',mtConfirmation,[mbOk,mbCancel])=mrOk);

        If (Ok2Cont) then
          ExLocal.LId.NomIOFlg:=0;
      end;
    end;

    If (Sender = A1PQF) then
    With LId do
    Begin
      Form2Id;

      {$IFDEF CU} {* Call any pre store hooks here *}
        If (Not ReadOnly) then
        Begin
          GenHooks(4000,3,ExLocal);

          OutUserDef;
        end;
      {$ENDIF}

      If (Not EmptyKey(StockCode,StkKeyLen)) and (SOPLink=0) then  {* For manual lines, apply auto discounts *}
      Begin

        MLocStk:=GetCustProfileMLoc(LCust.DefMLocStk,MLocStk,1);

         {$IFDEF STK}

           If (LastQtyValue<>Qty*QtyMul) then
           Begin

             Flg:=((Not LastEdit) and ((NetValue=0) or ((IdDocHed In StkRetPurchSplit) and (ExLocal.LId.sdbFolio=0))));

             Calc_StockPrice(LStock,LCust,LInv.Currency,Calc_IdQty(Qty,QtyMul,UsePack),LInv.TransDate,
                             NetValue,
                             Discount,DiscountChr,MLocStk,Flg,0);

             {$IFDEF SOP}
               If (Flg) then
                 QBLineVAT_Update(ExLocal);
             {$ENDIF}


             OutId; {* Set here, as otherwise, any auto discount does not get set *}
           end;

         {$ENDIF}


      end;


      If ((LastQtyValue<>Qty*QtyMul) or (BadQty))  and (Not EmptyKey(StockCode,StkKeyLen)) then
      Begin


        If (Not LastEdit) then {* Don't keep checking on last Qty *}
          LastQtyValue:=0;

        If (LInv.InvDocHed In StkRetPurchSplit) then
        Begin
          NegQtyChk:=BOn;

          {Check_StockCtrl(StockCode,(Qty*QtyMul)-LastQtyValue,1,FLowStk,IdDocHed,LId,Self.Handle);
           Mode check added for negative stock on invoices*}

          Check_StockCtrl(StockCode,(Qty*QtyMul)-LastQtyValue,1+Ord(CheckNegStk),FLowStk,IdDocHed,LId,Self.Handle);

          BadQty:=FLowStk;

          {$IFDEF SOP}
             If (Syss.UseMLoc) and (Assigned(TxAutoMLId)) then  {* Adjust quantity based on split *}
             Begin
               TxAutoMLId^.SetIdQty(LId);
               OutId;
             end;
           {$ENDIF}

          Ok2Cont:=Not BadQty;

        end;

        If (FLowStk) and (CanFocus) then {* Force adjustment *}
          SetFocus;
      end;
    end {With..}
    else
      If (Sender = A1UCF) then
      Begin
        Form2Id;

        {$IFDEF CU} {* Call any pre store hooks here *}
          If (Not ReadOnly)  then
          Begin
            GenHooks(4000,5,ExLocal);
          end;

        {$ENDIF}



      end;


    If (Ok2Cont) then
    Begin
      Calc_LTot; {* Capture any line total changes *}

      Set_EntryRO;

      {$IFDEF CU} {* Call hooks here *}
        If (Not EmptyKey(ExLocal.LId.StockCode,StkKeyLen)) then
        Begin
          GenHooks(4000,12,ExLocal);

          If (EnableCustBtns(4000,12)) then
            OutId;
        end;
      {$ENDIF}

    end
    else
      If (Not FLowStk) then
        Value:=0.0;
  end;
end;


procedure TRETLine.Id3DiscFExit(Sender: TObject);
begin
  Begin


      If (Sender is Text8Pt) then
      With ExLocal,LId,Text8pt(Sender) do
      Begin
        If (Modified) then
        Begin
          {$IFDEF CU} {* Call any pre store hooks here *}
            If (Not ReadOnly) then
            Begin
              Form2Id ;
              GenHooks(4000,4,ExLocal);
              OutId;
            end;
          {$ENDIF}

        end;  
      end; {With..}


    Calc_LTot;
  end;

end;




procedure TRETLine.A1SCodefDblClick(Sender: TObject);
begin
  {$IFDEF STK}

    With A1SCodeF do
     If (CheckKey(FullStockCode(Text),ExLocal.LStock.StockCode,StkKeyLen,BOff)) then
    Begin
      If (Not MatchOwner('StockRec',Self.Owner.Owner)) then
      Begin

        If (DispStk=nil) then
          DispStk:=TFStkDisplay.Create(Self);

        try

          ExLocal.AssignToGlobal(StockF);

          With DispStk do

            Display_Account(0);

        except

          DispStk.Free;

        end;
      end
      else  {* We are being called via StockRec, hence double click should inform custrec *}
      Begin
        Send_UpdateList(BOff,10);
      end;
    end
    else
      A1SCodeFExit(A1SCodeF);

  {$ENDIF}

end;

procedure TRETLine.THUD1FEntHookEvent(Sender: TObject);
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
            ExLocal.LId.LineUser1:=Text;
            CUUDEvent:=1;
          end
          else
            If (Sender=THUD2F) then
            Begin
              ExLocal.LId.LineUser2:=Text;
              CUUDEvent:=2;
            end
            else
              If (Sender=THUD3F) then
              Begin
                ExLocal.LId.LineUser3:=Text;
                CUUDEvent:=3;
              end
              else
                If (Sender=THUD4F) then
                Begin
                  ExLocal.LId.LineUser4:=Text;
                  CUUDEvent:=4;
                end
                //GS 20/10/2011 ABSEXCH-11706: create branches for the new UDFs
                //there is a 30 offset; event values are adjucted accordingly
                else
                  If (Sender=THUD5F) then
                  Begin
                    ExLocal.LId.LineUser5:=Text;
                    CUUDEvent:=(211 - 30);
                  end
                  else
                    If (Sender=THUD6F) then
                    Begin
                      ExLocal.LId.LineUser6:=Text;
                      CUUDEvent:=(212 - 30);
                    end
                    else
                      If (Sender=THUD7F) then
                      Begin
                        ExLocal.LId.LineUser7:=Text;
                        CUUDEvent:=(213 - 30);
                      end
                      else
                        If (Sender=THUD8F) then
                        Begin
                          ExLocal.LId.LineUser8:=Text;
                          CUUDEvent:=(214 - 30);
                        end
                        else
                          If (Sender=THUD9F) then
                          Begin
                            ExLocal.LId.LineUser9:=Text;
                            CUUDEvent:=(215 - 30);
                          end
                          else
                            If (Sender=THUD10F) then
                            Begin
                              ExLocal.LId.LineUser10:=Text;
                              CUUDEvent:=(216 - 30);
                            end;

          Result:=IntExitHook(4000,30+CUUDEvent,-1,ExLocal);

          If (Result=0) then
            SetFocus
          else
          With ExLocal do
          If (Result=1) then
          Begin
            Case CUUDEvent of
              1  :  Text:=LId.LineUser1;
              2  :  Text:=LId.LineUser2;
              3  :  Text:=LId.LineUser3;
              4  :  Text:=LId.LineUser4;
              //GS 20/10/2011 ABSEXCH-11706: put customisation object vals into UDFs
              (211 - 30)  :  Text:=LId.LineUser5;
              (212 - 30)  :  Text:=LId.LineUser6;
              (213 - 30)  :  Text:=LId.LineUser7;
              (214 - 30)  :  Text:=LId.LineUser8;
              (215 - 30)  :  Text:=LId.LineUser9;
              (216 - 30)  :  Text:=LId.LineUser10;
            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;


procedure TRETLine.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>Candb1Btn) then
    Text8pt(Sender).ExecuteHookMsg;

end;


procedure TRETLine.A1LOFEnter(Sender: TObject);
begin
  If (Syss.UseMLoc) and (EmptyKey(A1LoF.Text,MLocKeyLen)) then
  Begin
    If (EmptyKey(A1LoF.Text,MLocKeyLen)) then
      A1LoF.Text:=ExLocal.LStock.DefMLoc;
  end;

end;

procedure TRETLine.A1LOFExit(Sender: TObject);
Var
  SCode      :  Str20;
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;

  LineLink,
  LinkLine   :  LongInt;


begin

  {$IFDEF SOP}

    Form2Id;

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      Scode:=ExLocal.LId.StockCode;

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) and (ActiveControl<>Okdb1Btn)
          and  (Syss.UseMLoc) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,SCode,77));

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

          Form2Id;

          // MH 01/07/2009 (20060119114817): Added check on stock code because if no stock code was
          // specified details were being copied in incorrectly from the global stock record
          If (Trim(ExLocal.LId.StockCode) <> '') Then
          Begin
            With ExLocal.LId do
              SendToObjectStkEnq(StockCode,MLocStk,'',-1,-1,0);

            SetLink_Adj;
          End; // If (Trim(StockCode) <> '')

          OutId;



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

procedure TRETLine.Id3Desc1FKeyPress(Sender: TObject; var Key: Char);
Begin
  If (Sender is Text8pt) then
  With Text8pt(Sender) do
  Begin
    If (SelStart>=MaxLength) then {* Auto wrap around *}
      SetNextLine(Self,Sender,Id3Desc6F,Parent,Key);
  end;
end;


procedure TRETLine.Id3VATFExit(Sender: TObject);
Var
  Flg         :  Boolean;

  FoundCode   :  Str20;

  BalNow      :  Double;

  AltMod      :  Boolean;

begin
  Begin

    Form2Id;

    If (Sender is TSBSComboBox) then
    With (Sender as TSBSComboBox) do
    Begin
      AltMod:=Modified;

      If (ActiveControl<>Candb1Btn) and (AltMod) then
      With ExLocal,LInv,LId do
      Begin

        {$IFDEF CU} {* Call any pre store hooks here *}
          If (Not ReadOnly) then
            GenHooks(4000,6,ExLocal);
        {$ENDIF}

        BalNow:=NetValue;


       If (BalNow<>0) and (Qty<>0) then
       Begin

         If (LCust.CustCode<>LInv.CustCode) then
         Begin
            GetCust(Self,LInv.CustCode,FoundCode,IsACust(CustSupp),-1);


           AssignFromGlobal(CustF);
         end
         else
           AssignToGlobal(CustF);


         Flg :=(((Not (VATCode In VATEECSet)) or (LCust.EECMember)));

         If (Not Flg) then
         Begin

           Warn_BADVATCode(VATCode);

           StopPageChange:=BOn;
           SetFocus;

         end
         else
         Begin
           {$IFDEF VAT}
             If (VATCode=VATICode) then
               With TSBSComboBox(Sender) do
                 GetIRate(Parent.ClientToScreen(ClientPos(Left,Top+23)),Color,Font,Self.Parent,LViewOnly,VATIncFlg);
           {$ENDIF}

           CalcVATExLocal(ExLocal,BOff,nil);

           {CalcVat(LId,LInv.DiscSetl);}

           OutId;

           StopPageChange:=BOff;
         end;
       end;

      end; {With..}
    end; {With..}
  end; {If..}
end;




procedure TRETLine.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;

  //Stock description
  ID3Desc1F.AllowPostedEdit := True;
  ID3Desc2F.AllowPostedEdit := True;
  ID3Desc3F.AllowPostedEdit := True;
  ID3Desc4F.AllowPostedEdit := True;
  ID3Desc5F.AllowPostedEdit := True;
  ID3Desc6F.AllowPostedEdit := True;

  //UDFs
  THUD1F.AllowPostedEdit := True;
  THUD2F.AllowPostedEdit := True;
  THUD3F.AllowPostedEdit := True;
  THUD4F.AllowPostedEdit := True;
  THUD5F.AllowPostedEdit := True;
  THUD6F.AllowPostedEdit := True;
  THUD7F.AllowPostedEdit := True;
  THUD8F.AllowPostedEdit := True;
  THUD9F.AllowPostedEdit := True;
  THUD10F.AllowPostedEdit := True;

end;

function TRETLine.TransactionViewOnly: Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;

Initialization

end.
