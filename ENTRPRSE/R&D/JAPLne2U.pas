unit JAPLne2u;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, SBSPanel,

  GlobVar,VarConst,ExWrap1U, ExtCtrls, ComCtrls, BorBtns;

const
  CANCEL_MSG_PARAM = 107;

type
  TJAPLine = class(TForm)
    Candb1Btn: TButton;
    Okdb1Btn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label87: Label8;
    Label83: Label8;
    Label88: Label8;
    Hrs: TCurrencyEdit;
    CertF: TCurrencyEdit;
    NarF: Text8Pt;
    AppF: TCurrencyEdit;
    Label89: Label8;
    Label810: Label8;
    YTDBudgetF: TCurrencyEdit;
    YTDAppF: TCurrencyEdit;
    YTDCertF: TCurrencyEdit;
    SBSPanel1: TSBSPanel;
    Label81: Label8;
    Label84: Label8;
    CCLab: Label8;
    Label85: Label8;
    Label82: Label8;
    Label86: Label8;
    JCode: Text8Pt;
    JDesc: Text8Pt;
    RtDesc: Text8Pt;
    Id3VATF: TSBSComboBox;
    NTDepF: Text8Pt;
    NTCCF: Text8Pt;
    SRLTF: TSBSComboBox;
    Anal: Text8Pt;
    SBSPanel2: TSBSPanel;
    UDF1L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    UDF3L: Label8;
    Bevel2: TBevel;
    Bevel3: TBevel;
    THUD1F: Text8Pt;
    THUD2F: Text8Pt;
    THUD4F: Text8Pt;
    THUD3F: Text8Pt;
    Bevel1: TBevel;
    Label814: Label8;
    JADedF: TCurrencyEdit;
    JACRCB: TBorCheckEx;
    JAADCB: TSBSComboBox;
    Label817: Label8;
    Label818: Label8;
    Label819: Label8;
    Label820: Label8;
    JARTCB: TSBSComboBox;
    JARVF: TCurrencyEdit;
    JAECB: TSBSComboBox;
    JAEIF: TCurrencyEdit;
    JADedNF: Text8Pt;
    Label811: Label8;
    Label812: Label8;
    JARetNF: Text8Pt;
    cbov1: TBorCheckEx;
    Label813: Label8;
    DedValF: TCurrencyEdit;
    cbOv2: TBorCheckEx;
    Label815: Label8;
    RetValF: TCurrencyEdit;
    JACompCB: TSBSComboBox;
    GAppF: TCurrencyEdit;
    GCertF: TCurrencyEdit;
    Label816: Label8;
    Label821: Label8;
    UDF5L: Label8;
    THUD5F: Text8Pt;
    UDF6L: Label8;
    THUD6F: Text8Pt;
    UDF7L: Label8;
    THUD7F: Text8Pt;
    UDF8L: Label8;
    THUD8F: Text8Pt;
    UDF9L: Label8;
    THUD9F: Text8Pt;
    UDF10L: Label8;
    THUD10F: Text8Pt;
    cbMaterialsOnly: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure Candb1BtnClick(Sender: TObject);
    procedure JCodeExit(Sender: TObject);
    procedure NTCCFExit(Sender: TObject);
    procedure AnalExit(Sender: TObject);
    procedure HrsExit(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure A1GLFExit(Sender: TObject);
    procedure JAECBChange(Sender: TObject);
    procedure JARTCBChange(Sender: TObject);
    procedure cbOv2Click(Sender: TObject);
    procedure cbov1Click(Sender: TObject);
    procedure Id3VATFExit(Sender: TObject);
    procedure JACompCBChange(Sender: TObject);
    procedure CertFEnter(Sender: TObject);
    procedure GAppFEnter(Sender: TObject);
    procedure GCertFEnter(Sender: TObject);
    procedure GAppFExit(Sender: TObject);
    procedure GCertFExit(Sender: TObject);

    Private
    { Private declarations }

    VariOn,
    lStopAutoTab,
    InPassing,
    GenSelect,
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    GAppValue,
    GCertValue,
    AppValue,
    CertValue    :  Double;

    ThisDocHed   :  DocTypes;

    TSEmplRec    :  JobMiscRec;

    //PR: 14/12/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;
    function TransactionViewOnly : Boolean;


    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Function CheckAnalCode(ACode  :  Str10)  :  Boolean;

    procedure BuildDesign2;

    procedure BuildDesign;

    procedure FormDesign;

    Function Current_Page  :  Integer;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus(EditMode  :  Byte);

    Function ConfirmQuit  :  Boolean;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    Procedure OutId;

    procedure Form2Id;

    procedure CalcJLineVAT(Sender: TObject);

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    

  public
    { Public declarations }

    TabMode    :  Byte;

    ExLocal    :  TdExLocal;

    Procedure ChangePage(NewPage  :  Integer);

    procedure ShowLink(InvR      :  InvRec;
                       JMisc     :  JobMiscRec;
                       VOMode    :  Boolean);

    procedure ProcessId(Fnum,
                        Keypath  :  Integer;
                        Edit,InsMode
                                 :  Boolean);

    procedure SetFieldProperties(Panel  :  TSBSPanel;
                                 Field  :  Text8Pt) ;

    procedure EditLine(InvR       :  InvRec;
                       JMisc      :  JobMiscRec;
                       Edit,
                       InsMode,
                       ViewOnly   :  Boolean);

    //PR: 14/12/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;
  end;

Function LJob_InGroup(JobGroup  :  Str20;
                      JobR      :  JobRecType;
                      MeExLocal :  TdExLocal)  :  Boolean;

Function LineCheckCompleted(IdR  :  IDetail;
                            InvR :  InvRec;
                            Edit,MainChk  :  Boolean;
                        Var ShowMsg :  Boolean;
                            AOwner  :  TWinControl)  : Boolean;

Var
  JADocHed  :  DocTypes;
  JATabMode :  Byte;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  VarRec2U,
  VarJCstU,
  BtKeys1U,
  BTSupU1,
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
  {SysU2,}
  MiscU,

  JCAppD2U,

  JobSup1U,
  JobSup2U,

  InvListU,

  InvCt2Su,

  PayF2U,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,

  {$ENDIF}

  {$IFDEF VAT}
    GIRateU,
  {$ENDIF}

  PWarnU,
  PassWR2U,
  {PayLineU,}
  ThemeFix,
  InvFSu3U,
  CustomFieldsIntf;




{$R *.DFM}



Function LineCheckCompleted(IdR  :  IDetail;
                            InvR :  InvRec;
                            Edit,MainChk  :  Boolean;
                        Var ShowMsg :  Boolean;
                            AOwner  :  TWinControl)  : Boolean;

Const
  NofMsgs      =  8;

Type
  PossMsgType  = Array[1..NofMsgs] of Str100;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop     :  Boolean;

  mbRet    :  Word;

  ThisBud  :  Double;

  FoundLong
           :  LongInt;

  ExLocal  :  TdExLocal;

Begin
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='The General Ledger Code is not valid.';
  PossMsg^[2]:=''; {Spare..}
  PossMsg^[3]:='The Cost Centre/ Department Code is not valid.';
  PossMsg^[4]:='The Job Code is not valid.';
  PossMsg^[5]:='The Job Analysis Code is not valid.';
  PossMsg^[6]:='The amount certifed cannot exceed the amount applied/ budgeted for';
  PossMsg^[7]:='The total amount applied including previous applications will exceed the total budget';
  PossMsg^[8]:='An additional check is made via an external hook';



  Loop:=BOff;

  Test:=1;

  Result:=BOn;  ThisBud:=0.0;


  While (Test<=NofMsgs) and (Result) do
  With IdR do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              {Begin
                Result:=GetNom(AOwner,Form_Int(NomCode,0),FoundLong,-1);

                If (Result) and (Not SBSIn) then
                  Result:=(Nom.NomType In BankSet+ProfitBFSet);
              end;}

            end;

      2  :  Result:=BOn; {Spare..}


      {$IFDEF PF_On}

        3  :  Begin
                Result:=(Not Syss.UseCCDep);

                If (Not Result) then
                Begin
                  Result:=BOn;
                  For Loop:=BOff to BOn do
                  Begin

                    Result:=(GetCCDep(AOwner,CCDep[Loop],FoundCode,Loop,-1) and (Result));

                  end;
                end;

              end;

        4  :  Begin
                {$B-}
                  Result:=(AutoLineType In [2,3]) or GetJob(AOwner,JobCode,FoundCode,-1);
                {$B+}

                If (Result) and (Not (AutoLinetype In [2,3])) and (InvR.DJobCode<>JobCode) then
                Begin
                  ExLocal.Create;

                  ExLocal.LId:=IdR;
                  ExLocal.LInv:=InvR;
                  ExLocal.LJobRec^:=JobRec^;

                  Result:=LJob_InGroup(InvR.DJobCode,ExLocal.LJobRec^,ExLocal);

                  ExLocal.Destroy;
                end;

              end;

        5  :  Begin
                {$B-}
                Result:=(AutoLineType In [2,3]) or GetJobMisc(AOwner,AnalCode,FoundCode,2,-1);
                {$B+}


              end;

        6  :  Begin
                If (SOPLink<>0) then {Ensure we do not go over budget}
                Begin
                  {$B-}
                    If (Reconcile=0) then
                    Begin
                      If (IdDocHed In JAPJAPSplit) then
                      Begin
                        ThisBud:=Get_JTLink(IdR,IdetailF,IdLinkK,CurrKeypath^[IDetailF]).CostPrice;

                        Result:=(Round_Up((NetValue+QtyPWOff),2)<=Round_Up(ThisBud,2)) or (ThisBud=0.0);
                      end
                      else
                        Result:=(Round_Up(NetValue,2)<=Round_Up(CostPrice,2)) or (CostPrice=0.0);
                    end;
                  {$B+}
                end;
              end;

        7  :  Begin
                If (SOPLink<>0) then {Ensure we do not go over budget}
                Begin
                  {$B-}
                    If (Reconcile=0) then
                    Begin
                      If (IdDocHed In JAPJAPSplit) then
                      Begin
                        ThisBud:=Get_JTLink(IdR,IdetailF,IdLinkK,CurrKeypath^[IDetailF]).CostPrice;

                        Result:=(Round_Up(CostPrice+QtyDel,2)<=Round_Up(ThisBud,2)) or (ThisBud=0.0);
                      end
                      else
                        Result:=(Round_Up(QtyDel,2)<=Round_up(CostPrice,2)) or (CostPrice=0.0);
                    end;
                  {$B+}
                end;
              end;

        8  :  Begin {* Opportunity for hook to validate this line as well *}
                 {$IFDEF CU}
                   ExLocal.Create;

                   ExLocal.LId:=IdR;
                   ExLocal.LInv:=InvR;

                   Result:=ValidExitHook(4000,23,ExLocal);
                   ShowMsg:=BOff;

                   ExLocal.Destroy;
                 {$ENDIF}
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


Function TJAPLine.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;

Procedure TJAPLine.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

  end; {With..}
end; {Proc..}

procedure TJAPLine.ShowLink(InvR     :  InvRec;
                           JMisc     :  JobMiscRec;
                           VOMode    :  Boolean);

Var
  FoundCode  :  Str20;

begin
  ExLocal.AssignFromGlobal(IdetailF);


  ExLocal.LGetRecAddr(IdetailF);

  ExLocal.LInv:=InvR;

  ExLocal.LJobMisc^:=JMisc;

  TSEmplRec:=JMisc;

  With ExLocal,LId,LInv do
  Begin
    Caption:=Pr_OurRef(LInv)+' Transaction Line';

    LViewOnly:=VOMode;
    
    If (ThisDocHed In JapJapSplit) then
    Begin
      GAppF.Visible:=(JAbMode(LInv)=2);
      GCertF.Visible:=GAppF.Visible;
      Label821.Visible:=GAppF.Visible;

      If (Not GAppF.Visible) then
      Begin
        Label83.Top:=GAppF.Top-14;
        Label89.Top:=Label83.Top;
        Label810.Top:=Label83.Top;

      end;
    end;

  end;

  If (ExLocal.LastEdit) then
    OutId;



  JustCreated:=BOff;

end;



Function TJAPLine.CheckAnalCode(ACode  :  Str10)  :  Boolean;

Var
  FoundCode  :  Str20;

Begin
  Result:=BOff;

  With ExLocal, LJobMisc^.JobAnalRec do
  Begin
    If (JAnalCode<>ACode) then
    Begin
      FoundCode:=ACode;

      If (GetJobMisc(Self.Owner,FoundCode,FoundCode,2,-1)) then
      Begin
        AssignFromGlobal(JMiscF);
        Result:=BOn;
      end;
    end
    else
      Result:=BOn;

  end;

end;


{ ========== Build runtime view ======== }


procedure TJAPLine.BuildDesign2;


begin
//

  With ExLocal,LId do
  Begin
    If (Not (ThisDocHed In [JSA,JPA])) or ((Reconcile<>0) and (SOPLink<>0)) then
    Begin
      AppF.Visible:=BOff;
      CertF.Visible:=BOff;
      YTDBudgetF.Visible:=BOn;
      YTDBudgetF.Top:=GAppF.Top;
      YTDAppF.Top:=GAppF.Top;
      YTDCertF.Top:=GAppF.Top;
      Label88.Top:=GAppF.Top+6;
      GAppF.Visible:=BOff;
      GCertF.Visible:=BOff;
      Label821.Visible:=BOff;
      Label816.Visible:=BOff;
      JARTCB.ItemIndex:=0;

      {* EN560, make the YTD read only unless special pw allows them to be overwritten *}

    end
    else
    Begin
      AppF.Visible:=BOn;
      CertF.Visible:=BOn;
      YTDBudgetF.Visible:=BOn;

      
      JARTCB.ItemIndex:=1; {*EN560 link to header basis*}

      {* EN560, make the YTD read only unless special pw allows them to be overwritten *}

    end;


    Case TabMode of
      0   :  Begin
               TabSheet2.TabVisible:=BOff;
               TabSheet3.TabVisible:=BOff;

             end;

      1   :  Begin
               TabSheet1.TabVisible:=((SOPLink<>0) or (ThisDocHed In [JPT,JST])) or
               ((ThisDocHed=JCT) and PChkAllowed_In((457*Ord(ThisDocHed In JapSalesSplit))+(460*Ord(ThisDocHed In JapPurchSplit))));
               TabSheet3.TabVisible:=BOff;

             end;
      2   :  Begin
               TabSheet1.TabVisible:=((SOPLink<>0) or (ThisDocHed In [JPT,JST])) or
                  ((ThisDocHed=JCT) and PChkAllowed_In((457*Ord(ThisDocHed In JapSalesSplit))+(460*Ord(ThisDocHed In JapPurchSplit))));
               TabSheet2.TabVisible:=BOff;

             end;
    end; {Case..}

    If (Reconcile<>0) and ((SOPLink<>0) or (ThisDocHed In [JPT,JST])) then {First tab is shown for YTD values only}
    Begin
      Label87.Visible:=BOff;
      Hrs.Visible:=BOff;
      NarF.Visible:=BOff;
      {Label83.Visible:=BOff;}
      Label810.Left:=Label89.Left;

      Label89.Left:=Label83.Left;
      
      YTDBudgetF.Visible:=BOff;
      YTDCertF.Left:=YTDAppF.Left;
      YTDAppF.Left:=YTDBudgetF.Left;


    end;
  end; {With..}
end;

procedure TJAPLine.BuildDesign;


begin
//

  Set_DefaultJARet(JARTCB.ITems,BOff,BOff);


  BuildDesign2;

  Set_DefaultJADed(JAADCB.ITems,BOn,BOff);

  JAADCB.ItemIndex:=0;

  {* Only allow edit of YTD figures with correct password *}

  If (Not (ThisDocHed In JAPOrdSplit+[JPT])) then
  Begin
    YTDBudgetF.Tag:=0;
    YTDBudgetF.Color:=clBtnFace;
  end;

  If (Not PChkAllowed_In((457*Ord(ThisDocHed In JapSalesSplit))+(460*Ord(ThisDocHed In JapPurchSplit)))) then
  Begin
    YTDAppF.Tag:=0;
    YTDAppF.Color:=clBtnFace;

  end;

  If (YTDAppF.Tag=0) then
  Begin
    YTDCertF.Tag:=0;
    YTDCertF.Color:=clBtnFace;
  end;


end;



procedure TJAPLine.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;
  Category: Integer;
  VisibleFieldCount: Integer;
begin

  {* Set Version Specific Info *}



  HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}

  NTCCF.Visible:=Not HideCC;
  NTDepF.Visible:=Not HideCC;

  If (HideCC) then
  Begin
    CCLab.Caption:=CCVATName^;
    Id3VATF.Left:=NTCCF.Left;
  end
  else
    CCLab.Caption:=CCVATName^+'/'+CCLab.Caption;

  // CJS 2014-02-12 - ABSEXCH-14946 - JSA Retention and CIS Tax Calculation
  if not (ThisDocHed in JAPSalesSplit) then
  begin
    cbMaterialsOnly.Visible := False;
    cbMaterialsOnly.Checked := False;
  end
  else
    cbMaterialsOnly.Visible := True;

  {UDF1L.Caption:=Get_CustmFieldCaption(2,21);
  UDF1L.Visible:=Not Get_CustmFieldHide(2,21);

  THUD1F.Visible:=UDF1L.Visible;

  UDF2L.Caption:=Get_CustmFieldCaption(2,22);
  UDF2L.Visible:=Not Get_CustmFieldHide(2,22);

  THUD2F.Visible:=UDF2L.Visible;


  UDF3L.Caption:=Get_CustmFieldCaption(2,23);
  UDF3L.Visible:=Not Get_CustmFieldHide(2,23);

  THUD3F.Visible:=UDF3L.Visible;


  UDF4L.Caption:=Get_CustmFieldCaption(2,24);
  UDF4L.Visible:=Not Get_CustmFieldHide(2,24);

  THUD4F.Visible:=UDF4L.Visible;}

  //GS 14/03/2012 ABSEXCH-12128: determine what record type we are showing
  //then retrieve the labels for that record types UDFs
  Case ThisDocHed of
    JCT:
    begin
      Category := cfJCTLine;
    end;
    JPT:
    begin
      Category := cfJPTLine;
    end;
    JST:
    begin
      Category := cfJSTLine;
    end;
    JPA:
    begin
      Category := cfJPALine;
    end;
    JSA:
    begin
      Category := cfJSALine;
    end;
    else //PR: 23/03/2016 v2016 R1 ABSEXCH-17390
      raise Exception.Create('Invalid DocType in TJAPLine.FormDesign: ' + DocCodes[ThisDocHed]);

  end;//end case

  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]
             Category);

  //get a count of the number of enabled UDFs
  VisibleFieldCount := NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]);
  //adjust proceeding controls to cover up any space left unoccupied by hidden fields:
  //shift the main form:
  ResizeUDFParentContainer(VisibleFieldCount, 2, self);
  //shift the OK button
  ResizeUDFParentContainer(VisibleFieldCount, 2, Okdb1Btn);
  //shift the cancel button
  ResizeUDFParentContainer(VisibleFieldCount, 2, Candb1Btn);
  //shift the seperator bevel
  ResizeUDFParentContainer(VisibleFieldCount, 2, bevel3);
  //shift the parent SBSpanel
  ResizeUDFParentContainer(VisibleFieldCount, 2, SBSPanel2);

  //ResizeUDFParentContainer(VisibleFieldCount, 2, TabSheet1);

  Hrs.DecPlaces:=Syss.NoQtyDec;

  Set_JAPDefaultDocT(SRLTF.Items,0);
  Set_JAPDefaultDocT(SRLTF.ItemsL,0);

  Set_DefaultVAT(Id3VATF.Items,BOn,BOff);
  Set_DefaultVAT(Id3VATF.ItemsL,BOn,BOn);

  BuildDesign;

end;




procedure TJAPLine.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  InPassing:=BOff;

  JustCreated:=BOn;

  SKeypath:=0;

  GAppValue:=0.0;
  GCertValue:=0.0;
  AppValue:=0.0;
  CertValue:=0.0;

  ClientHeight:=470; //PR: 14/10/2011 Changed from 380 to accommodate v6.9 udfs
  ClientWidth:=446;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TJCApp) then
    With TJCAPP(Owner) do
      Self.SetFieldProperties(A1FPanel,A1YRefF);

  ThisDocHed:=JADocHed;

  TabMode:=JATabMode;

  FormDesign;

  ChangePage(TabMode);

end;




procedure TJAPLine.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,100);

end;

procedure TJAPLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TJAPLine.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TJAPLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TJAPLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TJAPLine.Send_UpdateList(Edit   :  Boolean;
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

    If (Mode=8) then
    begin
      Case TabMode of
        1,2  :  MSg:=WM_FormCloseMsg;
      end; {Case..}
    end;
    if (Mode = CANCEL_MSG_PARAM) then
      WParam := Mode
    else
      WParam:=Mode+100;

    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}



Function TJAPLine.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;


Procedure TJAPLine.SetFieldFocus(EditMode  :  Byte);

Begin
  Case EditMode of
    0  :  Begin
            If (Not JCode.ReadOnly) then
              JCode.SetFocus
            else
              Anal.SetFocus;
          end;
    1  :  With Exlocal,LId do
          Begin
            If (LastEdit) then
            Begin
              Case Reconcile of
                0  :    If (IdDocHed In JAPJAPSplit) then
                        Begin
                          Case LInv.TransNat of
                            2  :  Begin
                                    If (GAppF.Value<>0.0) and (GCertF.CanFocus) and (Not lStopAutoTab) then
                                      GCertF.SetFocus
                                    else
                                      GAppF.SetFocus;
                                  end;
                            else  Begin
                                    If (AppF.Value<>0.0) and (CertF.CanFocus) and (Not lStopAutoTab) then
                                      CertF.SetFocus
                                    else
                                      AppF.SetFocus;
                                  end;
                          end; {Case..}
                          
                        end
                        else
                          If (YTDBudgetF.CanFocus) then
                            YTDBudgetF.SetFocus;

                1  :  If (JADedF.CanFocus) then
                        JADedF.SetFocus
                      else
                        If (DedValF.CanFocus) then
                          DedValF.SetFocus;

                2  :  Begin
                        If (JARVF.CanFocus) then
                          JARVF.SetFocus;
                      end;
              end; {Case..}
            end
            else
              SetFieldFocus(0);

          end;
  end; {Case..}

end; {Proc..}


procedure TJAPLine.Candb1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      StoreId(IdetailF,SKeypath);
    end
    else
      If (ModalResult=mrCancel) then
      Begin
        Send_UpdateList(BOff, CANCEL_MSG_PARAM);
        Close;
        Exit;
      end;
  end; {With..}
end;



Function TJAPLine.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and (CheckNeedStore) and (Not ExLocal.LViewOnly) and (Not IdStored) then
  Begin

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
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

                Send_UpdateList(BOff,20);

                TmpBo:=BOn;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                SetfieldFocus(0);
              end;
  end; {Case..}


  ConfirmQuit:=TmpBo;
end; {Func..}


procedure TJAPLine.SetIdStore(EnabFlag,
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

  cbOv2Click(nil);
  cbOv1Click(nil);
end;


{ ============== Display Id Record ============ }

Procedure TJAPLine.OutId;

Var
  FoundOk   :  Boolean;

  FoundLong :  LongInt;

  FoundCode :  Str20;

Begin
  With ExLocal,LId do
  Begin
    JCode.Text:=Trim(JobCode);

    {$B-}
     If (LJobRec^.JobCode=JobCode) or (LGetMainRecPos(JobF,JobCode)) then
    {$B+}
        JDesc.Text:=LJobRec^.JobDesc;

    Anal.Text:=Trim(AnalCode);

    If CheckAnalCode(AnalCode) then
      RtDesc.Text:=LJobMisc^.JobAnalRec.JAnalName;

    NTCCF.Text:=CCDep[BOn];
    NTDepF.Text:=CCDep[BOff];

    NarF.Text:=Desc;

    JARetNF.Text:=Desc;
    JADedNF.Text:=Desc;

    {A1GLF.Text:=Form_BInt(NomCode,0);}

    Hrs.Value:=Qty;

    If (VATCode In VATSet) then
      Id3VATF.ItemIndex:=GetVATIndex(VATCode);

    AppF.Value:=CostPrice;
    YTDAppF.Value:=QtyDel;

    CertF.Value:=NetValue;
    YTDCertF.Value:=QtyPWOff;

    If (Not (IdDocHed In [JSA,JPA])) then
      YTDBudgetF.Value:=CostPrice
    else
    Begin
      GAppF.Value:=Round_Up(YTDAppF.Value+AppF.Value,2);
      GCertF.Value:=Round_Up(YTDCertF.Value+CertF.Value,2);

    end;

    SRLTF.ItemIndex:=DocLTLink;

    If (VATCode In VATSet) then
      Id3VATF.ItemIndex:=GetVATIndex(VATCode);


    {*EN560 TYD, link back to parent JCT via SOPLink & SOPLineNo}
    {YTDBudgetF:= Get from JCT line}

    THUd1F.Text:=LineUser1;
    THUd2F.Text:=LineUser2;
    THUd3F.Text:=LineUser3;
    THUd4F.Text:=LineUser4;

    //6.9 New Udfs
    THUD5F.Text  := LineUser5;
    THUD6F.Text  := LineUser6;
    THUD7F.Text  := LineUser7;
    THUD8F.Text  := LineUser8;
    THUD9F.Text  := LineUser9;
    THUD10F.Text := LineUser10;


    { == Deduction items == }

    {JAPTCB.ItemIndex:=Ord(DiscountChr<>PcntChr);}

    {If (JustCreated) then {Force mask to be set-up
      JAPTCBChange(Nil);}

    JADedF.Value:=Discount;

    JACRCB.Checked:=ShowCase;

    JAADCB.ItemIndex:=KitLink;

    cbOV1.Checked:=LiveUplift;

    { == Retention items == }

    JARTCB.ItemIndex:=COSNomCode;

    JARVF.Value:=Discount;

    cbMaterialsOnly.Checked := tlMaterialsOnlyRetention;

    JAECB.ItemIndex:=Round(SSDSPUnit);

    JAEIF.Value:=OldSerQty;

    cbOV2.Checked:=LiveUplift;

    JACompCB.ItemIndex:=JAPDedType;

    If (JustCreated) then
    Begin
      DedValF.Value:=NetValue;
      RetValF.Value:=NetValue;

      If (ThisDocHed In [JPA,JSA]) then
        YTDBudgetF.Value:=Get_JTLink(LId,IdetailF,IdLinkK,SKeypath).CostPrice;

      BuildDesign2;
    end;

    JACompCBChange(Nil);
  end;

end;


procedure TJAPLine.Form2Id;

Begin

  With EXLocal,LId do
  Begin

    CCDep[BOn]:=NTCCF.Text;
    CCDep[BOff]:=NTDepF.Text;

    JobCode:=FullJobCode(JCode.Text);
    AnalCode:=FullJACode(Anal.Text);
    Qty:=Round_up(Hrs.Value,Syss.NoQtyDec);

    NetValue:=Round_up(CertF.Value,2);
    CostPrice:=Round_up(AppF.Value,2);

    If (Not (IdDocHed In [JSA,JPA])) then
      CostPrice:=Round_up(YTDBudgetF.Value,2)
    else
      CostPrice:=Round_up(AppF.Value,2);

    {* EN560. For special mode, we need to allow YTD to be manually entered/ overridden *}

    QtyDel:=Round_up(YTDAppF.Value,2);
    QtyPWOff:=Round_up(YTDCertF.Value,2);

    {NomCode:=IntStr(A1GLF.Text);}

    Case TabMode of
      1  :  Begin
              Desc:=JADedNF.Text;
              Discount:=Round_Up(JADedF.Value,2);

              {If (JAPTCB.ItemIndex=0) then
                DiscountChr:=PcntChr
              else
                DiscountChr:=C0;}

              LiveUplift:=cbOV1.Checked;
              NetValue:=DedValF.Value;

              // CJS 17/11/2010 - If the user overrides the CIS Tax, update
              // the transaction header as well. Note that this assumes that
              // there is only ever one CIS Tax transaction line, which I
              // believe to be the case.
              if LiveUplift then
              begin
                { CJS 2014-02-19 - ABSEXCH-13322 - Only do this for CIS
                  tax lines -- ignore other deduction lines. }
                if Trim(AnalCode) = '' then
                begin
                  ExLocal.LInv.CISManualTax := True;
                  ExLocal.LInv.CISTax := NetValue;
                end;
              end
              else
              begin
                ExLocal.LInv.CISManualTax := False;
              end;
            end;

      2  :  Begin
              Desc:=JARetNF.Text;
              Discount:=JARVF.Value;

              LiveUplift:=cbOV2.Checked;

              NetValue:=RetValF.Value;

              JAPCalc_RetDate(ExLocal);
            end;

      else  Desc:=NarF.Text;
    end;

    If (SRLTF.ItemIndex>=0) then
      DocLTLink:=SRLTF.ItemIndex;

    LineUser1:=THUd1F.Text;
    LineUser2:=THUd2F.Text;
    LineUser3:=THUd3F.Text;
    LineUser4:=THUd4F.Text;

    //6.9 New Udfs
    LineUser5  := THUD5F.Text;
    LineUser6  := THUD6F.Text;
    LineUser7  := THUD7F.Text;
    LineUser8  := THUD8F.Text;
    LineUser9  := THUD9F.Text;
    LineUser10 := THUD10F.Text;


    With Id3VATF do
      If (ItemIndex>=0) then
        VATCode:=Items[ItemIndex][1];

    { == Deduction items == }

    

    ShowCase:=JACRCB.Checked;

    KitLink:=JAADCB.ItemIndex;

    { == Retention items == }

    COSNomCode:=JARTCB.ItemIndex;

    SSDSPUnit:=JAECB.ItemIndex;

    OldSerQty:=Round(JAEIF.Value);

    If (JACompCB.ItemIndex>=0) then
      JAPDedType:=JACompCB.ItemIndex;

    tlMaterialsOnlyRetention := cbMaterialsOnly.Checked;

  end; {with..}

end; {Proc..}




    { ======= Function to Check belongs to tree ====== }

  Function LJob_InGroup(JobGroup  :  Str20;
                        JobR      :  JobRecType;
                        MeExLocal :  TdExLocal)  :  Boolean;


  Const
    Fnum     =  JobF;
    Keypath  =  JobCodeK;


  Var
    KeyS2   :  Str255;
    FoundOk :  Boolean;
    TmpKPath,
    TmpStat :  Integer;

    TJob    :  JobRecType;

    TmpRecAddr
            :  LongInt;


  Begin
    With MeExLocal do
    Begin

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      TJob:=LJobRec^;

      KeyS2:=JobR.JobCat;

      FoundOk:=((EmptyKey(JobGroup,JobKeyLen)) or (FullJobCode(JobGroup)=FullJobCode(KeyS2)));


      If (Not FoundOk) then
        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS2);


      While (StatusOk) and (Not FoundOk) and (Not EmptyKey(LJobRec^.JobCat,JobKeyLen)) do
      With LJobRec^ do
      Begin

        FoundOk:=((FullJobCode(JobGroup)=JobCode) or (FullJobCode(JobGroup)=FullJobCode(JobCat)));

        If (Not FoundOk) then
        Begin
          KeyS2:=JobCat;

          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS2);

        end;

      end; {While..}

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      LJobRec^:=TJob;

      LJob_InGroup:=FoundOk;
    end; {With..}
  end; {Func..}


procedure TJAPLine.JCodeExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

begin
  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) and (Not (ExLocal.LId.AutoLineType In [2,3])) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJob(Self.Owner,FoundCode,FoundCode,4));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin
          AssignFromGlobal(JobF);

          If (FoundCode<>LInv.DJobCode) then
            FoundOk:=LJob_InGroup(LInv.DJobCode,LJobRec^,ExLocal);

          If (FoundOk) then
          Begin
            Text:=FoundCode;

            JDesc.Text:=LJobRec^.JobDesc;
          end
          else
            SetFocus;
        end
        else
        Begin

          SetFocus;
        end; {If not found..}

      end
      else
        If (FoundCode='') then {* Reset Janal code *}
          Anal.Text:='';

    end;
  {$ENDIF}
end;





procedure TJAPLine.NTCCFExit(Sender: TObject);
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


      If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) and (ActiveControl<>Okdb1Btn)
          and (Syss.UseCCDep) then
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

          InPassing:=BOn;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

          InPassing:=BOff;

        end
        else
        Begin

          SetFocus;
        end; {If not found..}
      end;

    end; {with..}
  {$ENDIF}
end;




procedure TJAPLine.AnalExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  AMode      :  Byte;


begin
  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      If (ThisDocHed In JAPSalesSplit) then
        AMode:=13
      else
        AMode:=12;

      Case TabMode of
        1  :  Begin
                If (ThisDocHed In JAPSalesSplit) then
                  AMode:=9
                else
                  AMode:=10;

              end;
        2  :  Begin
                If (ThisDocHed In JAPSalesSplit) then
                  AMode:=6
                else
                  AMode:=5;

              end;
      end; {Case..}

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn)  and (Not (ExLocal.LId.AutoLineType In [2,3])) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self.Owner,FoundCode,FoundCode,2,AMode));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(JMiscF);

          Text:=FoundCode;

          InPassing:=BOn;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

          InPassing:=BOff;

          If CheckAnalCode(FoundCode) then
          With LJobMisc^.JobAnalRec do
          Begin
            RtDesc.Text:=JAnalName;
            JADedNF.Text:=JAnalName;
            NarF.Text:=JAnalName;
            JARetNF.Text:=JAnalName;

            //PR: 23/03/2016 v2016 R1 ABSEXCH-17390 Removed byte>=0 checks
//            If (JADetType>=0) then
            Begin
              cbOv1.Checked:=(JADetType=1);
            end;

            If (cbOv1.Checked) then
              DedValF.Value:=JADeduct
            else
              JADedF.Value:=JADeduct;

            JACRCB.Checked:=JACalcB4Ret;

//            If (JADedApply>=0) then
              JAADCB.ItemIndex:=JADedApply;


            JARVF.Value:=JARetValue;

//            If (JARetExp>=0) then
              JAECB.ItemIndex:=JARetExp;

            JAEIF.Value:=JARetExpInt;

            JACompCB.ItemIndex:=JADedComp;

            SRLTF.ItemIndex:=JLinkLT;

//            If (JADedComp>=0) then
            Begin
              JACompCBChange(Nil);
            end;

//            If (JARetType>=0) then
            Begin
              JARTCB.ItemIndex:=JARetType;
              JARTCBChange(Nil);
            end;

            
          end;

        end
        else
        Begin
          SetFocus;
        end; {If not found..}
      end;

    end;
  {$ENDIF}

end;


procedure TJAPLine.CalcJLineVAT(Sender: TObject);
begin
  Form2Id;

  Calc_AppVAT(ExLocal);

  OutId;
end;



procedure TJAPLine.HrsExit(Sender: TObject);
begin
  CalcJLineVAT(Sender);
end;

procedure TJAPLine.CertFEnter(Sender: TObject);
begin
  If (Not JustCreated) and (ExLocal.InAddEdit) and (ActiveControl<>Candb1Btn) then
    If (Sender is TCurrencyEdit) then
    With (Sender as TCurrencyEdit) do
      If (Value=0.0) then
      Begin
        Value:=AppF.Value;
        SelectAll;
      end;
end;

procedure TJAPLine.GAppFEnter(Sender: TObject);
begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit), ExLocal do
  Begin
    GAppValue:=Round_Up(Value,2);
  end;
end;

procedure TJAPLine.GAppFExit(Sender: TObject);
Var
  AltMod  :  Boolean;

begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit), ExLocal do
  Begin
    AltMod:=(GAppValue<>Round_Up(Value,2));

    If (ActiveControl<>Candb1Btn) and (AltMod) then
    Begin
      AppF.Value:=Round_Up(Value-YTDAppF.Value,2);
      CalcJLineVAT(Sender);
    end;
  end; {with..}


end;

procedure TJAPLine.GCertFEnter(Sender: TObject);
begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit), ExLocal do
  Begin
    GCertValue:=Round_Up(Value,2);

    If (Not JustCreated) and (ExLocal.InAddEdit) and (ActiveControl<>Candb1Btn) then
      If (CertF.Value=0.0) then
      Begin
        Value:=GAppF.Value;
        SelectAll;
      end;

  end;

end;

procedure TJAPLine.GCertFExit(Sender: TObject);
Var
  AltMod  :  Boolean;

begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit), ExLocal do
  Begin
    AltMod:=(GCertValue<>Round_Up(Value,2));

    If (ActiveControl<>Candb1Btn) and (AltMod) then
    Begin
      CertF.Value:=Round_Up(Value-YTDCertF.Value,2);
    end;
  end; {with..}


end;



procedure TJAPLine.THUD1FEntHookEvent(Sender: TObject);
Var
  CUUDEvent  :  Byte;
  Result     :  LongInt;

begin
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
        else //PR: 14/10/2011 Add new UDFs - Hook points are 211-216, need to subtract 30 which is added below, so 181-186
        if Sender = THUD5F then
        begin
          ExLocal.LId.LineUser5:=Text;
          CUUDEvent:=181;
        end
        else
        if Sender = THUD6F then
        begin
          ExLocal.LId.LineUser6:=Text;
          CUUDEvent:=182;
        end
        else
        if Sender = THUD7F then
        begin
          ExLocal.LId.LineUser7:=Text;
          CUUDEvent:=183;
        end
        else
        if Sender = THUD8F then
        begin
          ExLocal.LId.LineUser8:=Text;
          CUUDEvent:=184;
        end
        else
        if Sender = THUD9F then
        begin
          ExLocal.LId.LineUser9:=Text;
          CUUDEvent:=185;
        end
        else
        if Sender = THUD10F then
        begin
          ExLocal.LId.LineUser10:=Text;
          CUUDEvent:=186;
        end
        else
          raise Exception.Create('Invalid Sender in TJAPLine.THUD1FEntHookEvent: ' + (Sender as Text8pt).Name);



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

            //PR: 14/10/2011 v6.9 new user fields
            181  :  Text:=LId.LineUser5;
            182  :  Text:=LId.LineUser6;
            183  :  Text:=LId.LineUser7;
            184  :  Text:=LId.LineUser8;
            185  :  Text:=LId.LineUser9;
            186  :  Text:=LId.LineUser10;

            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;




procedure TJAPLine.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>Candb1Btn) then
    Text8pt(Sender).ExecuteHookMsg;

end;

procedure TJAPLine.A1GLFExit(Sender: TObject);
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

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,0));

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


      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;



procedure TJAPLine.JAECBChange(Sender: TObject);
begin
  If (ExLocal.InAddEdit) then
  Begin
    JAEIF.Enabled:=(JAECB.ItemIndex<>2);

    If (Not JAEIF.Enabled) then
      JAEIF.Value:=0.0;
  end;

end;

procedure TJAPLine.JARTCBChange(Sender: TObject);
Var
  EqValue  :  Double;

begin
  If (Not JustCreated) then
  Begin
    Form2Id;


    With ExLocal do
    If (LId.DiscountChr=PcntChr) and (Not LId.LiveUplift) then
    Begin
      eqValue:=CalcJAPRetTotals(LInv,LId,ExLocal,TabMode,JAiMode(LInv));
      Case TabMode of
        1  :  DedValF.Value:=eqValue;
        2  :  RetValF.Value:=eqValue;
      end; {Case..}
    end; {With..}
  end;
end;



procedure TJAPLine.cbOv2Click(Sender: TObject);
begin
  If (ExLocal.InAddEdit) then
    RetValF.Enabled:=(cbOv2.Checked);

end;

procedure TJAPLine.cbov1Click(Sender: TObject);
begin
  If (ExLocal.InAddEdit) then
    DedValF.Enabled:=(cbOv1.Checked);

end;

procedure TJAPLine.JACompCBChange(Sender: TObject);
begin
  If (ExLocal.InAddEdit) then
  Begin
    JAADCB.Enabled:=(JACompCB.ItemIndex=0);

    If (Not JAADCB.Enabled) then
      JAADCB.ItemIndex:=0;

    JADedF.Enabled:=(JACompCB.ItemIndex<>2);

    JACRCb.Enabled:=JADedF.Enabled and (JACompCB.ItemIndex=0);

    If (Not JACRCb.Enabled) then
      JACRCB.Checked:=BOff;

    If (Not JADedF.Enabled) then
    Begin
      JADedF.Value:=0.0;
      cbov1.Checked:=BOn;
    end;



  end;

end;

procedure TJAPLine.Id3VATFExit(Sender: TObject);
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

      If (ActiveControl<>Candb1Btn) then
      Begin
        {$IFDEF CU} {* Call any pre store hooks here *}
          If (Not ReadOnly) then
            GenHooks(4000,6,ExLocal);
        {$ENDIF}

        If (GenSelect or AltMod) then
        With ExLocal,LInv,LId do
        Begin


          BalNow:=NetValue;


         If (BalNow<>0) then
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

             Calc_AppVAT(ExLocal);        
             {CalcVat(LId,LInv.DiscSetl);}

             OutId;

             StopPageChange:=BOff;
           end;
         end;

        end; {With..}
      end; {If..}
    end; {With..}
  end; {If..}
end;


(*  Add is used to add Notes *)

procedure TJAPLine.ProcessId(Fnum,
                            Keypath     :  Integer;
                            Edit,InsMode
                                        :  Boolean);

Var
  KeyS  :  Str255;
  CurrRLine
        :  LongInt;


Begin

  Addch:=ResetKey;

  IdStored:=BOff;

  KeyS:='';

  SKeypath:=Keypath;

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

      LResetRec(Fnum);

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      If (InsMode) and (CurrRLine>0) then  {* Do not allow insert on first blank line! *}
        LineNo:=CurrRLine
      else
        LineNo:=LInv.ILineCount;

      NomMode:=TSTNomMode; {*EN560 ?? What is this mode, for dd of g/l? *}

      ABSLineNo:=LInv.ILineCount;

      IDDocHed:=LInv.InvDocHed;

      Currency:=LInv.Currency;

      CXRate:=LInv.CXRate;

      CurrTriR:=LInv.CurrTriR;

      PYr:=LInv.ACYr;
      PPr:=LInv.AcPr;

      PDate:=LInv.TransDate;

      Qty:=1.0;

      {$B-}
      If (LJobRec^.JobCode=LInv.DJobCode) or (LGetMainRecPos(JobF,LInv.DJobCode)) then
      {$B+}
        If (LJobRec^.JobType<>JobGrpCode) then
        Begin
          JobCode:=LInv.DJobCode;
          JCode.Tag:=0;
          JCode.TabStop:=BOff;
          JCode.ReadOnly:=BOn;

        end;

      VATCode:=VATSTDCode;

      DiscountChr:=PcntChr; {*EN560* Default to %, but need to link to anal code *}

      // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
      // Amended to call new function, passing additional JobRec.CCDep parameter 
      With TSEmplRec.EmplRec do
        LId.CCDep:=GetCustProfileCCDepEx(CCDep[BOn],CCDep[BOff],LId.CCDep,ExLocal.LJobRec^.CCDep, 0);


      Case TabMode of
        1  :  LineNo:=JALDedLineNo;
        2  :  LineNo:=JALRetLineNo;
      end; {Case..}

      Reconcile:=TabMode;

      If (Reconcile>0) then
        Payment:=DocPayType[SIN]
      else
        Payment:=DocPayType[PIN];
    end;

    LastId:=LId;

    If (Not LViewOnly) and (IdDocHed In JAPJAPSplit) then
    Begin
      Case TabMode of
        0  :  With LInv do
              If (CostPrice=0.0) then
              Begin {* Auto suggest remainder each time *}
                If (TotalInvoiced-TotalCost>0.0) then
                Begin
                  If (TransNat<>2) then
                    CostPrice:=TotalInvoiced-TotalCost;
                    
                  lStopAutoTab:=BOn;
                end;
              end;
      end; {Case..}


    end;


    SetIdStore(BOn,ExLocal.LViewOnly);

    OutId;

    JCode.OrigValue:=JCode.Text;


    {If (JCode.ReadOnly) then}
      SetFieldFocus(1);

  end; {If Abort..}

end; {Proc..}





procedure TJAPLine.StoreId(Fnum,
                          Keypath  :  Integer);

Const
  CalcModes  :  Array[0..2] of Byte = (3,1,1);

Var
  COk,
  DSM  :  Boolean;

  Dnum,
  Dnum2
       :  Double;

  TmpId
       :  Idetail;

  KeyS :  Str255;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState: Boolean;
  CursorState: TCursor;

Begin
  KeyS:='';  Dnum:=0;  DSM:=BOff; Dnum2:=0.0;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState := Okdb1Btn.Enabled;
  CursorState := Cursor;

  Okdb1Btn.Enabled := False;
  try

    Form2Id;


    With ExLocal,LId do
    Begin

      COk:=LineCheckCompleted(LId,LInv,LastEdit,BOff,DSM,Self);


      If (COk) then
      Begin
        Cursor:=CrHourGlass;

        SSDUseLine:=LInv.PDiscTaken;

        Update_JAPDeductLine(LId,LInv,0);

        If (LiveUplift) and (Not SSDUseLine) and (Reconcile>0) then {* If its manual, copy into certified as well *}
          SSDUplift:=NetValue;

        Calc_AppVAT(ExLocal);

        If (LastEdit) then
        Begin

          If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
          Begin

            TmpId:=LId;

            LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

            Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

            LId:=TmpId;

          end;

          Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

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

        If (StatusOk) then
        Begin

          CalcJAPVATTotals(LInv,ExLocal,Not LInv.ManVAT,CalcModes[Reconcile]);


          {$IFDEF PF_On}

              Update_JobAct(LId,LInv);

          {$ENDIF}

           With LId do
           Begin
             Dnum:=DetLTotal(LId,BOn,BOff,0.0)*LineCnst(Payment);

             If (JBCostOn) and ((LastId.AnalCode<>AnalCode) or (LastId.StockCode<>StockCode))
               and (Not EmptyKey(JobCode,JobCodeLen))
                  and (Not Get_BudgMUp(JobCode,AnalCode,StockCode,0,Dnum,Dnum2, 2+Ord(IdDocHed In PSOPSet))) then


               Warn_AnalOverB(JobCode,AnalCode);

           end; {With..}

           Update_JTLink(LastId,LastInv,BOn,BOn,Fnum,IdLinkK,Keypath,0);

           Update_JTLink(LId,LInv,BOff,BOn,Fnum,IdLinkK,Keypath,0);

        end;

        { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
        Cursor := CursorState;

        InAddEdit:=Boff;

        If (LastEdit) then
          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

        SetIdStore(BOff,BOff);

        IdStored:=BOn;

        Send_UpdateList(LastEdit,8);

        LastValueObj.UpdateAllLastValues(Self);

        Close;
      end
      else
        SetFieldFocus(0);

    end; {With..}
  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  finally
    Cursor := CursorState;
    Okdb1Btn.Enabled := ButtonState;
  end;

end;


procedure TJAPLine.SetFieldProperties(Panel  :  TSBSPanel;
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


procedure TJAPLine.EditLine(InvR       :  InvRec;
                           JMisc      :  JobMiscRec;
                           Edit,
                           InsMode,
                           ViewOnly   :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ShowLink(InvR,JMisc,ViewOnly);

    ProcessId(IdetailF,CurrKeyPath^[IdetailF],LastEdit,InsMode);
  end;
end;













function TJAPLine.TransactionViewOnly: Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;

procedure TJAPLine.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;

  //Description & PayInRef
  JARETNF.AllowPostedEdit := True;

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

Initialization

JADocHed:=JCT;
JATabMode:=0;

end.
