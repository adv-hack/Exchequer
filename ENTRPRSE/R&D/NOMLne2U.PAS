unit NomLne2U;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, SBSPanel,

  GlobVar,VarConst,ExWrap1U, ExtCtrls, bkgroup;


type
  TNTLine = class(TForm)
    NTLDF: Text8Pt;
    Label87: Label8;
    NTNAF: Text8Pt;
    Label81: Label8;
    NTNDF: Text8Pt;
    NTCCF: Text8Pt;
    CCLab: Label8;
    NTDepF: Text8Pt;
    DepLab: Label8;
    Candb1Btn: TButton;
    Okdb1Btn: TButton;
    JCLab: Label8;
    NTJCF: Text8Pt;
    JALab: Label8;
    NTJAF: Text8Pt;
    UDF1L: Label8;
    THUD1F: Text8Pt;
    UDF2L: Label8;
    THUD2F: Text8Pt;
    THUD4F: Text8Pt;
    UDF4L: Label8;
    THUD3F: Text8Pt;
    UDF3L: Label8;
    NTCurrF: TSBSComboBox;
    CurrLab: Label8;
    I1ExLab: Label8;
    NTExRF: TCurrencyEdit;
    NTJDF: Text8Pt;
    SBSBackGroup1: TSBSBackGroup;
    NTDAmtF: TCurrencyEdit;
    Label83: Label8;
    NTCAmtF: TCurrencyEdit;
    Label82: Label8;
    NTIOCB: TSBSComboBox;
    VATLab: Label8;
    NTVATCF: TSBSComboBox;
    VATCLab: Label8;
    NTVATF: TCurrencyEdit;
    Label88: Label8;
    Bevel1: TBevel;
    PIPIF: Text8Pt;
    PILab: Label8;
    THUD5F: Text8Pt;
    UDF5L: Label8;
    THUD6F: Text8Pt;
    UDF6L: Label8;
    UDF7L: Label8;
    UDF8L: Label8;
    UDF9L: Label8;
    UDF10L: Label8;
    THUD7F: Text8Pt;
    THUD8F: Text8Pt;
    THUD9F: Text8Pt;
    THUD10F: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure Candb1BtnClick(Sender: TObject);
    procedure NTNAFExit(Sender: TObject);
    procedure NTNAFEnter(Sender: TObject);
    procedure NTCCFExit(Sender: TObject);
    procedure NTCurrFEnter(Sender: TObject);
    procedure NTCurrFExit(Sender: TObject);
    procedure NTDAmtFEnter(Sender: TObject);
    procedure NTDAmtFExit(Sender: TObject);
    procedure NTJCFExit(Sender: TObject);
    procedure NTJAFExit(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure NTVATCFExit(Sender: TObject);
    procedure NTIOCBExit(Sender: TObject);
    procedure NTIOCBEnter(Sender: TObject);
    procedure NTIOCBChange(Sender: TObject);
    procedure NTLDFExit(Sender: TObject);
    procedure NTIOCBClick(Sender: TObject);
    procedure NTCurrFClick(Sender: TObject);
    procedure SetUDFields(UDDocHed  :  DocTypes);
    procedure NTVATCFDropDown(Sender: TObject);
  private
    { Private declarations }

    VariOn,
    InPassing,
    GenSelect,
    IdStored,
    StopPageChange,

    JustCreated,
    FNetValChanged:  Boolean;


    SKeypath     :  Integer;

    //PR: 15/11/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;
    function TransactionViewOnly : Boolean;

    // CJS 2013-09-24 - ABSEXCH-13192 - add Job Costing to user profile rules
    procedure ApplyCCDeptRules;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    Procedure SetVATFieldAccess;

    Procedure OutId;

    procedure Form2Id;


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    Function NTRight(Amount  :  Real)  :  TCurrencyEdit;

    Function NTOther(TCE  :  TObject)  :  TCurrencyEdit;

    procedure SetHelpContextIDs; //NF: 24/07/06

  public
    { Public declarations }

    AutoSetIOVAT
               :  Boolean;

    ExLocal    :  TdExLocal;

    procedure ShowLink(InvR      :  InvRec;
                       VOMode    :  Boolean);

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Panel  :  TSBSPanel;
                                 Field  :  Text8Pt) ;

    procedure EditLine(InvR       :  InvRec;
                       Edit,
                       ViewOnly   :  Boolean);

    //PR: 15/11/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;
  end;


{Function LineCheckCompleted(IdR  :  IDetail;
                            InvR :  InvRec;
                            Edit,MainChk  :  Boolean;
                            AOwner  :  TWinControl)  : Boolean;}

Function LineCheckCompleted(IdR  :  IDetail;
                            InvR :  InvRec;
                            Edit,MainChk  :  Boolean;
                            AOwner  :  TWinControl;
                            CUPtr :  Pointer)  : Boolean; // NF:



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  // NF:
  {$IFDEF CU}
    CustWinU,
    CustIntU,
    OInv,
  {$ENDIF}

  BorBtns,
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  BTSupU1,
  BTSupU2,
  CurrncyU,
  SBSComp2,
  VarRec2U,
  ComnUnit,
  ComnU2,

  {$IFDEF PF_On}

     InvLst2U,

  {$ENDIF}

  ColCtrlU,
  CmpCtrlU,
  SysU3,
  MiscU,

  Nomtfr2U,

  InvListU,

  PayF2U,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {PayLineU,}

  {$IFDEF VAT}
    GIRateU,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,
  {$ENDIF}

  ThemeFix,

  Saltxl1U,
  
   //GS 26/10/2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF,

  // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
  PassWR2U,
  JobUtils
  ;




{$R *.DFM}



{Function LineCheckCompleted(IdR  :  IDetail;
                            InvR :  InvRec;
                            Edit,MainChk  :  Boolean;
                            AOwner  :  TWinControl)  : Boolean;}
Function LineCheckCompleted(IdR  :  IDetail;
                            InvR :  InvRec;
                            Edit,MainChk  :  Boolean;
                            AOwner  :  TWinControl;
                            CUPtr :  Pointer)  : Boolean;  // NF:

Const
  NofMsgs      =  12;

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

  FoundLong
           :  LongInt;

  BalNow   :  Double;

  ExLocal  :  TdExLocal;

  // NF:
  {$IFDEF CU}
    LineCU  :  TCustomEvent;
  {$ENDIF}

Begin
  New(PossMsg);
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='General Ledger Code is not valid.';
  PossMsg^[2]:='The Currency is not valid.';
  PossMsg^[3]:='Cost Centre/Department Code not valid.';
  PossMsg^[4]:='Job Code is not valid.';
  PossMsg^[5]:='Job Analysis Code is not Valid.';
  PossMsg^[6]:='An Exchange Rate of Zero is not allowed.';
  PossMsg^[7]:='Maximum line value exceeded.';
  PossMsg^[8]:='That G/L and currency combination are not allowed.';
  PossMsg^[9]:='An additional check is made via an external hook';
  PossMsg^[10]:='For local currency the exchange rate must be 1.0';
  PossMsg^[11]:='A valid Job code must be present for that G/L Code.';
  PossMsg^[12]:='That '+CCVATName^+' Code is not valid.';

  // NF:
  {$IFDEF CU}
     If (Assigned(CUPtr)) then LineCU:=CUPtr
     else LineCU:=Nil;
  {$ENDIF}

  Loop:=BOff;

  Test:=1;

  Result:=BOn;

  BalNow:=InvLTotal(IdR,BOff,0);


  While (Test<=NofMsgs) and (Result) do
  With IdR do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=(Round_Up(BalNow+VAT,2)=0.0);

              If (Not Result) then
              Begin
                Result:=GetNom(AOwner,Form_Int(NomCode,0),FoundLong,-1);

                If (Result) and (Not SBSIn) then
                  Result:=(Nom.NomType In BankSet+ProfitBFSet);
              end;

            end;

    {$IFDEF MC_On}

      2  :  Result:=(Currency In [Succ(CurStart)..CurrencyType]) or ((Currency =0) and (SBSIN));

      10 :  Begin
              Result:=((Currency=1) and (CXRate[BOn]=1.0)) or (Currency>1) or ((Currency =0) and (SBSIN));

            end;

    {$ENDIF}



      {$IFDEF PF_On}
        //TG-01-06-2017- ABSEXCH-18682-No error is displayed on 'Edit' and 'OK'
        3  :  Begin
                Result:=(not Syss.UseCCDep) or (not LComplete_CCDep(IdR,BalNow));

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

                Result:=((Not JBCostOn) or (Not LComplete_JobAnl(IdR,BalNow)) or (EmptyKey(JobCode,JobCodeLen)));

                If (Not Result) then
                  Result:=GetJob(AOwner,JobCode,FoundCode,-1);

              end;

        5  :  Begin

                Result:=((Not JBCostOn) or (Not LComplete_JobAnl(IdR,BalNow)) or (EmptyKey(JobCode,JobCodeLen)));

                If (Not Result) then
                  Result:=GetJobMisc(AOwner,AnalCode,FoundCode,2,-1);

              end;

        9  :  Begin {* Opportunity for hook to validate this line as well *}
                 {$IFDEF CU}
{                   ExLocal.Create;

                   ExLocal.LId:=IdR;
                   ExLocal.LInv:=InvR;

                   Result:=ValidExitHook(4000,19,ExLocal);
                   ShowMsg:=BOff;

                   ExLocal.Destroy;}
                 {$ENDIF}


                 // NF:
                 {$IFDEF CU}
                   If (Assigned(LineCU)) then
                   begin
                     With LineCU do
                     Begin
                       If (GotEvent) then
                       Begin
                         {v5.50. Alter current line to reflect this one. Returns false if could not be assigned}

  //                       If TInvoice(EntSysObj.Transaction).ChangeCurrentLine(Exlocal.LId) then
                         If TInvoice(EntSysObj.Transaction).ChangeCurrentLine(IdR) then
                         Begin
                           Execute;
                           Result:=EntSysObj.BoResult;
                         end
                         else
                           Result:=BOff;

                       end;
                     end;
                   end else
                   begin
                     ExLocal.Create;
                     ExLocal.LId:=IdR;
                     ExLocal.LInv:=InvR;

                     Result:=ValidExitHook(4000,19,ExLocal);

  //                     ShowMsg:=BOff;
                     ExLocal.Destroy;
                   end;

                   ShowMsg:=BOff;
                 {$ENDIF}

              end;


      {$ENDIF}

      6  :  Begin
              {$IFDEF MC_On}
                 Result:=CXRate[UseCoDayRate]<>0.0;

              {$ELSE}
                Result:=BOn;
              {$ENDIF}
            end;

      7  :  Begin

              Result:=(ABS(BalNow)<=MaxLineValue32);

            end;

      8  :  Result:=Check_GLCurr(InvR,IdR,0);

      {$IFDEF JC}

        11  :  Result:=Check_GLJC(InvR,IdR,0);

      {$ENDIF}

      12  :  Result:=(NomIOFlg=0) or (VATCode In VATSet);

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}

procedure TNTLine.ApplyCCDeptRules;
var
  JobCCDept: CCDepType;
  CCDept: CCDepType;
begin
  JobUtils.GetJobCCDept(NTJCF.Text, JobCCDept);
  CCDept[True] := NTCCF.Text;
  CCDept[False] := NTDepF.Text;
  CCDept := GetCustProfileCCDepEx('', '', CCDept, JobCCDept, 1);
  NTCCF.Text := CCDept[True];
  NTDepF.Text := CCDept[False];
end;

procedure TNTLine.ShowLink(InvR      :  InvRec;
                           VOMode    :  Boolean);

Var
  FoundCode  :  Str20;

begin
  ExLocal.AssignFromGlobal(IdetailF);


  ExLocal.LGetRecAddr(IdetailF);

  ExLocal.LInv:=InvR;

  With ExLocal,LId,LInv do
  Begin
    Caption:=Pr_OurRef(LInv)+' Transaction Line';

    LViewOnly:=VOMode;

  end;

  OutId;


  JustCreated:=BOff;

end;




{ ========== Build runtime view ======== }

procedure TNTLine.BuildDesign;


begin


end;


procedure TNTLine.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  {* Set Version Specific Info *}

  {$IFNDEF MC_On}

     CurrLab.Visible:=BOff;
     NTCurrF.Visible:=BOff;
     NTExRF.Visible:=BOff;
     I1ExLab.Visible:=BOff;


  {$ELSE}

     Set_DefaultCurr(NTCurrF.Items,BOff,BOff);
     Set_DefaultCurr(NTCurrF.ItemsL,BOff,BOn);

  {$ENDIF}


  NTIOCB.ItemsL.Assign(NTIOCB.Items);

  HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}


  NTCCF.Visible:=Not HideCC;
  NTDepF.Visible:=Not HideCC;

  CCLab.Visible:=NTCCF.Visible;
  DepLab.Visible:=NTCCF.Visible;

  Build_DefaultCVAT(NTVATCF.Items,BOn,BOn,BOff,BOff);
  Build_DefaultCVAT(NTVATCF.ItemsL,BOn,BOn,BOff,BOn);

  VATCLab.Caption:=CCVATName^+VATCLab.Caption;

  VATLab.Caption:=CCVATName^;

  Label88.Caption:=CCVATName^+Label88.Caption;


  If (Not JBCostOn) then
  Begin
    NTJCF.Visible:=BOff;
    NTJAF.Visible:=BOff;
    JCLab.Visible:=BOff;
    JALab.Visible:=BOff;
    NTJDF.Visible:=BOff;
  end;

  If (Not UseCoDayRate) then
  With NTExRF do
  Begin
    Tag:=0;
    Color:=clWindow;
    TabStop:=BOff;
    Enabled:=BOff;

  end;

  If (Not Syss.UsePayIn) then
  Begin
    PIPIF.Visible:=BOff;
    PILab.Visible:=BOff;
  end;


  //GS 26/10/2011 ABSEXCH-11706: removed existing UDF setup code; replaced with calling pauls new method
  SetUDFields(ExLocal.LInv.InvDocHed);

  NTLDF.MaxLength:=DocDesLen;

  BuildDesign;

end;



//GS 26/10/2011 ABSEXCH-11706: a copy of pauls user fields function
//PR: 11/11/2011 Amended to use centralised function EnableUdfs in CustomFieldsIntf.pas ABSEXCH-12129
procedure TNTLine.SetUDFields(UDDocHed  :  DocTypes);
begin
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F],
             cfNOMLine);
end;

procedure TNTLine.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  InPassing:=BOff;

  JustCreated:=BOn;

  SKeypath:=0;

  //GS 26/10/2011 ABSEXCH-11706: modified default height & width to accomodate new UDEFs
  ClientHeight:=347;
  ClientWidth:=614;

  VariOn:=BOff;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TNTxfrForm) then
    With TNTxfrForm(Owner) do
      Self.SetFieldProperties(N1DPanel,N1YRefF);

  {AutoSetIOVAT:=Debug;  {Set this based on password or header default, depending on how we implement}
  FNetValChanged := BOff; // SSK 19/06/2017 2017-R1 ABSEXCH-13530: changes for Inclusive VAT ('I')
  FormDesign;

  SetHelpContextIDs; //NF: 24/07/06
end;




procedure TNTLine.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,100);

end;

procedure TNTLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TNTLine.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TNTLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TNTLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TNTLine.Send_UpdateList(Edit   :  Boolean;
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



Function TNTLine.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;


Procedure TNTLine.SetFieldFocus;

Begin
  NTLDF.SetFocus;

end; {Proc..}


procedure TNTLine.Candb1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult=mrOk) then
      Begin
        // MH 12/05/2010: Move focus to OK button to force OnExit validation to kick in
        If CanFocus Then
          SetFocus;

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



Function TNTLine.ConfirmQuit  :  Boolean;

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
                SetfieldFocus;
              end;
  end; {Case..}


  ConfirmQuit:=TmpBo;
end; {Func..}


procedure TNTLine.SetIdStore(EnabFlag,
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

end;


Procedure TNTLine.SetVATFieldAccess;
Begin
  With NTVATCF do
  Begin
    ReadOnly:=(NTIOCB.ItemIndex=0);


    Tag:=Ord(Not ReadOnly);

    If (Not ReadOnly) then
      Color:=NTCAmtF.Color
    else
      Color:=clWindow;

    {TabStop:=Enabled;}

    (*
    If (Not ExLocal.LastEdit) then
    Begin
      If (Not ReadOnly)  then
        ItemIndex:=0
      else
        ItemIndex:=-1;
    end;
    *)

    // MH 12/05/2010: Rewrote so that VAT Codes are removed during edits if type is set to N/A
    If (Not ReadOnly) Then
    Begin
      // Read-Write - force valid selection
      If (ItemIndex = -1) Then
        ItemIndex := 0
    End // If (Not ReadOnly)
    Else
      // Read-only - remove VAT Code
      ItemIndex := -1;
  end;

  With NTVATF do
  Begin
    Enabled:=(Not NTVATCF.ReadOnly) and (Not ExLocal.LInv.ManVAT) and (NTIOCB.ItemIndex=2);

    Tag:=Ord(Enabled);

    If (Enabled) then
      Color:=NTCAmtF.Color
    else
      Color:=clWindow;


    TabStop:=Enabled;

    If (Not Enabled) and (NTIOCB.ItemIndex=0) then
      Value:=0.0;
  end;



end;

{ ============== Display Id Record ============ }

Procedure TNTLine.OutId;

Var
  FoundOk   :  Boolean;

  FoundLong :  LongInt;

  FoundCode :  Str20;

Begin
  With ExLocal,LId do
  Begin
    NTLDF.Text:=Desc;
    NTNAF.Text:=Form_BInt(NomCode,0);

    NTCCF.Text:=CCDep[BOn];
    NTDepF.Text:=CCDep[BOff];

    {$IFDEF MC_On}

      If (Currency>0) then
        NTCurrF.ItemIndex:=Pred(Currency);

      NTExRF.Value:=CXRate[UseCoDayRate];

    {$ENDIF}

    {v5.71 reset fields first}
    
    NTRight(-1).Value:=0.0;
    NTRight(1).Value:=0.0;

    NTRight(NetValue).Value:=ABS(NetValue);
    


    NTJCF.Text:=Strip('R',[#32],JobCode);
    NTJAF.Text:=Strip('R',[#32],AnalCode);

    {$B-}
      If (NTJCF.Text<>'') and (GetJob(Self,JobCode,FoundCode,-1)) then
        NTJDF.Text:=JobRec^.JobDesc
      else
        NTJDF.Text:='';
    {$B+}

    If (PostedRun>0) then
      PIPIF.Text:=Extract_PayRef2(StockCode)
    else
      PIPIF.Text:=Extract_PayRef1(StockCode);


    FoundOk:=GetNom(Self,NTNAF.Text,FoundLong,-1);

    NTNDF.Text:=Nom.Desc;

    THUd1F.Text:=LineUser1;
    THUd2F.Text:=LineUser2;
    THUd3F.Text:=LineUser3;
    THUd4F.Text:=LineUser4;
    //GS 26/10/2011 ABSEXCH-11706: put customisation values into text boxes
    THUd5F.Text:=LineUser5;
    THUd6F.Text:=LineUser6;
    THUd7F.Text:=LineUser7;
    THUd8F.Text:=LineUser8;
    THUd9F.Text:=LineUser9;
    THUd10F.Text:=LineUser10;

    // SSK 29/05/2017 2017-R1 ABSEXCH-13530: changes for Inclusive VAT ('I')
    If (VATCode In VATSet) then
    begin
      if (VATCode = VATMCode) then
        NTVATCF.ItemIndex := GetVATIndex(VATICode)
      else
        NTVATCF.ItemIndex := GetVATIndex(VATCode);
    end
    else
      NTVATCF.ItemIndex:=-1;

    NTVATF.Value:=VAT;

    NTIOCB.ItemIndex:=NOMIOFlg;
  end;

  // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
  ApplyCCDeptRules;

end;


procedure TNTLine.Form2Id;

Begin

  With EXLocal.LId do
  Begin
    NomCode:=IntStr(NTNAF.Text);
    Desc:=NTLDF.Text;

    If (Syss.UsePayIn) then
    begin
      //PR: 16/11/2017 ABSEXCH-19451 If we're editing a posted transaction
      //then we have to use the existing prefix chars
      if PostedRun > 0 then
        StockCode := Copy(StockCode, 1, 6) + LJVar(PIPIF.Text, 10)
      else
        StockCode:=Pre_PostPayInKey(PayInCode,PIPIF.Text);

    end;


    CCDep[BOn]:=NTCCF.Text;
    CCDep[BOff]:=NTDepF.Text;

    {$IFDEF MC_On}
      Currency:=Succ(NTCurrF.ItemIndex);

      If (UseCoDayRate) then
        CXRate[UseCoDayRate]:=NTExRF.Value;

    {$ENDIF}

    If (JBCostOn) then
    Begin
      JobCode:=FullJobCode(NTJCF.Text);
      AnalCode:=FullJACode(NTJAF.Text);
    end;

    NetValue:=NTDAmtF.Value+(NTCAmtF.Value*DocNotCnst);

    LineUser1:=THUd1F.Text;
    LineUser2:=THUd2F.Text;
    LineUser3:=THUd3F.Text;
    LineUser4:=THUd4F.Text;
    //GS 26/10/2011 ABSEXCH-11706: write udef field values into customisation object
    LineUser5:=THUd5F.Text;
    LineUser6:=THUd6F.Text;
    LineUser7:=THUd7F.Text;
    LineUser8:=THUd8F.Text;
    LineUser9:=THUd9F.Text;
    LineUser10:=THUd10F.Text;

    NOMIOFlg:=NTIOCB.ItemIndex;

    With NTVATCF do
      If (ItemIndex>-1) then
      begin
        If ((Items[ItemIndex][1]='I') and (VAT<>0.00) and (NTIOCB.ItemIndex=1)) then     // SSK 07/06/2017 2017-R1 ABSEXCH-13530: changes for Inclusive VAT ('I')
          VATCode := VATMCode
        else
          VATCode := Items[ItemIndex][1];
      end
      else
        VATCode := C0;

    VAT:=NTVATF.Value;

  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TNTLine.ProcessId(Fnum,
                            Keypath     :  Integer;
                            Edit        :  Boolean);

Var
  KeyS  :  Str255;


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

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      LineNo:=RecieptCode;

      ABSLineNo:=LInv.ILineCount;

      IDDocHed:=LInv.InvDocHed;

      Qty:=1;

      Currency:=LInv.Currency;

      CXRate:=LInv.CXRate;

      CurrTriR:=LInv.CurrTriR;

      PYr:=LInv.ACYr;
      PPr:=LInv.AcPr;

      Payment:=SetRPayment(LInv.InvDocHed);

      If (Syss.AutoClearPay) then
        Reconcile:=ReconC;



      PDate:=LInv.TransDate;



    end;

    LastId:=LId;


    OutId;

    NTLDF.OrigValue:=NTLDF.Text;

    SetIdStore(BOn,ExLocal.LViewOnly);

    {If (LInv.ManVAT) then}
      SetVATFieldAccess;

  end; {If Abort..}

end; {Proc..}





procedure TNTLine.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpId
       :  Idetail;

  KeyS :  Str255;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState: Boolean;
  CursorState: TCursor;

Begin
  KeyS:='';

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
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


  //    COk:=LineCheckCompleted(LId,LInv,LastEdit,BOff,Self);
      //PR: 17/11/2017 ABSEXCH-19451 Unfortunately, there could be lines
      //where currency = 0 (created under daily pwrd) which will fail check.
      if not LViewOnly then
        COk:=LineCheckCompleted(LId,LInv,LastEdit,BOff,Self,nil)
      else
        COk := True;


      If (COk) then
      Begin
        Cursor:=CrHourGlass;

        If (NomIOFlg=1) and not LViewOnly then
          CalcVATExLocal(ExLocal,BOff,nil);

        {
          CJS 24/01/2011 - ASBEXCH-9963 - Silently make sure that NOMMODE
          holds the correct value. If it is 2 (StkAdjNomMode), reset it
          to 0.
        }
        if (IdDocHed <> ADJ) and (NomMode = 2) then
          NomMode := 0;

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
          Inc(LInv.ILineCount);


          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        end;

        Report_BError(Fnum,Status);

        If (StatusOk) and not LViewOnly then
        Begin


          With LastId  do
            UpdateRecBal(LInv,NomCode,(NetValue*DocNotCnst),(VAT*DocNotCnst),CXRate,Currency,UseORate,4);

          With LId do
            UpdateRecBal(LInv,NomCode,NetValue,VAT,CXRate,Currency,UseORate,4);

          {$IFDEF PF_On}

            If (JbCostOn) and ((DetLTotal(LId,BOn,BOff,0.0)<>0) or (DetLTotal(LastId,BOn,BOff,0.0)<>0) or (LId.IdDocHed In StkADJSplit))
              and (Not (LId.IdDocHed In PurchSet)) then

              Update_JobAct(LId,LInv);

          {$ENDIF}

          // CJS 2014-05-06 - ABSEXCH-14076 - After Store Line Hook point on NOM lines
          {$IFDEF CU}
          ValidExitHook(4000, 14, ExLocal);
          {$ENDIF}
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
        SetFieldFocus;

    end; {With..}

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  finally
    Cursor := CursorState;
    Okdb1Btn.Enabled := ButtonState;
  end;

end;


procedure TNTLine.SetFieldProperties(Panel  :  TSBSPanel;
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


procedure TNTLine.EditLine(InvR       :  InvRec;
                           Edit,
                           ViewOnly   :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ShowLink(InvR,ViewOnly);

    ProcessId(IdetailF,CurrKeyPath^[IdetailF],LastEdit);
  end;
end;



procedure TNTLine.NTNAFEnter(Sender: TObject);
begin
  GenSelect:=Not InPassing;

end;




procedure TNTLine.NTNAFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) and (ActiveControl<>Okdb1Btn)
        and (GenSelect) then
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

        NTNDF.Text:=Nom.Desc;

        VariOn:=(FoundLong=Syss.NomCtrlCodes[CurrVar]);

        {$IFDEF MC_On}

          If (VariOn) then
          Begin
            Currency:=1;
            NTCurrF.ItemIndex:=Pred(Currency);

            CXRate:=SyssCurr.Currencies[Currency].CRates;

            SetTriRec(Currency,UseORate,CurrTriR);

          end
          else
            If (Not NTCurrF.ReadOnly) and (InAddEdit) then
            Begin
              If (Nom.DefCurr>0) then
              Begin
                Currency:=Nom.DefCurr;     

                NTCurrF.ItemIndex:=Pred(Currency);

                CXRate:=SyssCurr.Currencies[Currency].CRates;

                SetTriRec(Currency,UseORate,CurrTriR);

                NTExRF.Value:=CXRate[UseCoDayRate];
              end;
            end;

        {$ENDIF}


        {* Weird bug when calling up a list caused the Enter/Exit methods
             of the next field not to be called. This fix sets the focus to the next field, and then
             sends a false move to previous control message ... *}

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
end;





procedure TNTLine.NTCCFExit(Sender: TObject);
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
          and (Syss.UseCCDep) and (GenSelect) then
      Begin

        // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
        // For Job Costing, allow the user to pass through the Cost Centre and
        // Department fields without selecting anything, but if they have
        // entered values, do the normal validation.
        if (FoundCode <> '') or (not NTJCF.Visible) then
        begin
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
      end;

    end; {with..}
  {$ENDIF}
end;




procedure TNTLine.NTCurrFEnter(Sender: TObject);
begin
  NTCurrF.ReadOnly:=(VariOn or ExLocal.LViewOnly);
end;

procedure TNTLine.NTCurrFClick(Sender: TObject);
begin
  NTCurrF.Modified := True;
  NTCurrFExit(Sender);
end;

procedure TNTLine.NTCurrFExit(Sender: TObject);
begin
  With NTCurrF do

    With ExLocal,LId do
    Begin
      // MH 26/10/2010 v6.4 ABSEXCH-9711: Removed check against original value as it was causing the rates not to
      // update if the currency was changed back to the original currency
      If (Modified) {and (OrigValue<>Text)} then
      Begin
        CXrate:=SyssCurr.Currencies[Succ(NTCurrF.ItemIndex)].CRates;
        SetTriRec(Succ(NTCurrF.ItemIndex),UseORate,CurrTriR);

        NTExRF.Value:=CXRate[UseCoDayRate];
      end;

      NTExRF.ReadOnly:=(NTCurrF.ReadOnly or (Not UseCoDayRate) or (SyssGCuR^.GhostRates.TriEuro[Succ(NTCurrF.ItemIndex)]<>0)
                       or (Not NTExRF.Enabled)
                       or (Succ(NTCurrF.ItemIndex)=1) or (Not CanEditTriEuro(Succ(NTCurrF.ItemIndex))));
    end;
end;

{ ================= Function Return if input should be a debit / Credit ========= }

Function TNTLine.NTRight(Amount  :  Real)  :  TCurrencyEdit;

Begin
  If (Amount<0) then
    NTRight:=NTCAMTF
  else
    NTRight:=NTDAmtF;
end;


{ ================= Function Return if input should be a debit / Credit ========= }

Function TNTLine.NTOther(TCE  :  TObject)  :  TCurrencyEdit;

Begin
  If (TCE=NTDAmtF) then
    Result:=NTCAMTF
  else
    Result:=NTDAmtF;
end;


procedure TNTLine.NTDAmtFEnter(Sender: TObject);
begin
  If (Round_Up(NTDAmtF.Value,0)=0.0) and (Round_up(NTCAmtF.Value,2)=0.0) then
  With ExLocal, LId,TCurrencyEdit(Sender) do
  Begin
    {$IFDEF MC_On}

    {$ELSE}

      If (NTRight(PRequired(BOn,LInv)*-1)=Sender) then
        Value:=Conv_TCurr(PRequired(BOff,LInv),CXRate[UseCoDayRate],Currency,UseORate,BOn);

      If (Value<0.0) then
        Value:=Value*-1;

    {$ENDIF}

  end;
end;

procedure TNTLine.NTDAmtFExit(Sender: TObject);
var
  lNetval: Real;

begin
  With TCurrencyEdit(Sender) do
  Begin
    If (Round_up(Value,2)<>0.0) then
      NTOther(Sender).Value:=0.0;

    With EXLocal, LId do
    Begin
      // SSK 19/06/2017 2017-R1 ABSEXCH-13530: if Debit/Credit is changed then show message
      lNetval := NTDAmtF.Value+(NTCAmtF.Value* DocNotCnst);

      if InAddEdit and ((VATCode = VATICode) or (VATCode = VATMCode)) then (*and FNetValChanged*)
      begin
        FNetValChanged := Round_Up((abs(NetValue - lNetval)), 2)>0.00;
        if FNetValChanged then
        begin
          MessageDlg('You have edited the Debit/Credit of a VAT Inclusive transaction,' + #13
                      + 'please reselect the VAT code', mtInformation, [mbOk], 0);
          NTVATCF.setfocus;
          SendMessage(NTVATCF.handle, CB_SHOWDROPDOWN, Integer(True), 0);
        end;
      end;

    end;

  end;
end;

procedure TNTLine.NTLDFExit(Sender: TObject);
begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;
  end;

  {$IFDEF MC_On}
    NTCurrFExit(Sender);
  {$ENDIF}  
end;

procedure TNTLine.NTJCFExit(Sender: TObject);
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

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>Candb1Btn) and (GenSelect) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJob(Self.Owner,FoundCode,FoundCode,4));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin
          AssignFromGlobal(JobF);

          Text:=FoundCode;

          NTJDF.Text:=JobRec^.JobDesc;

          // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
          ApplyCCDeptRules;

          InPassing:=BOn;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

          InPassing:=BOff;
        end
        else
        Begin

          SetFocus;
        end; {If not found..}

      end
      else
        If (FoundCode='') then {* Reset Janal code *}
          NTJAF.Text:='';

    end;
  {$ENDIF}
end;



procedure TNTLine.NTJAFExit(Sender: TObject);
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

      If (((AltMod) or (FoundCode='')) and (Not EmptyKey(NTJCF.Text,JobCodeLen))) and (ActiveControl<>Candb1Btn) and (GenSelect) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self.Owner,FoundCode,FoundCode,2,Anal_FiltMode(ExLocal.LId.IdDocHed)));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(JMiscF);

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

    end;
  {$ENDIF}

end;



procedure TNTLine.THUD1FEntHookEvent(Sender: TObject);
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
                //GS 19/10/2011 ABSEXCH-11706: create branches for the new UDFs
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
              //GS 19/10/2011 ABSEXCH-11706: put customisation object vals into UDFs
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




procedure TNTLine.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>Candb1Btn) then
    Text8pt(Sender).ExecuteHookMsg;

end;

procedure TNTLine.NTVATCFExit(Sender: TObject);

Var
  AltMod: Boolean;

  mbRet: Word;

begin
  If (Sender is TSBSComboBox) then
    With (Sender as TSBSComboBox) do
    Begin
      AltMod:=Modified;

      If (ActiveControl<>Candb1Btn) and (GenSelect or AltMod or (NTIOCB.ItemIndex In [1])) and (Not ExLocal.LInv.ManVAT) and (Not ReadOnly) then
      With ExLocal,LInv,LId do
      Begin

        Form2Id;

        // SSK 19/06/2017 2017-R1 ABSEXCH-13530: this will prevent user from choosing 'M' vat code
        mbRet := mrOK;

        {$IFDEF VAT}
          If ((VATCode=VATICode) or (VATCode=VATMCode)) and (activecontrol = NTVATCF) then  // SSK 29/05/2017 2017-R1 ABSEXCH-13530: changes for Inclusive VAT ('I')
          begin
            if (NTIOCB.ItemIndex <> 2)  and (not FNetValChanged) then
              mbRet := MessageDlg('Please ensure the Debit/Credit is correct before applying' + #13 +
                            'an update to the Inclusive VAT(I) code', mtWarning, [mbOk, mbCancel], 0)
            else
              mbRet := mrOk;

            if mbRet = mrOk then
            begin
              With TSBSComboBox(Sender) do
                GetIRate(Parent.ClientToScreen(ClientPos(Left,Top+23)),Color,Font,Self.Parent,LViewOnly,VATIncFlg);
                VATCode := VATICode;
            end
            else
              VATCode := NTVATCF.Items[0][1];

            SetFocus;
          end;
        {$ENDIF}

        If (NomIOFlg=1) then
          CalcVATExLocal(ExLocal,BOff,nil);

        OutId;


      end;

    end;

end;

procedure TNTLine.NTIOCBClick(Sender: TObject);
begin
  // Update UI to reflect changes
  SetVATFieldAccess;
end;

procedure TNTLine.NTIOCBExit(Sender: TObject);
Var
  AltMod  :  Boolean;
begin
  If (Sender is TSBSComboBox) then
  With (Sender as TSBSComboBox) do
  Begin
    AltMod:=Modified;

    If (ActiveControl<>Candb1Btn) and ((AltMod) or (NTIOCB.ItemIndex=0)) then
    Begin
      SetVATFieldAccess;

    end;
  end;
end;

procedure TNTLine.NTIOCBEnter(Sender: TObject);
Var
  ForceChange  :  Integer;

begin
  If (AutoSetIOVat) and (NTIOCB.ItemIndex=0) then
  With ExLocal, LId do
  Begin
    ForceChange:=NTIOCB.ItemIndex;

    Form2Id;

    {If (NetValue<0) then
      NTIOCB.ItemIndex:=2
    else}
      NTIOCB.ItemIndex:=1;

    If (ForceChange<>NTIOCB.ItemIndex) then
    Begin
      NTIOCBChange(Sender);
      NTIOCBClick(Sender);
    End; // If (ForceChange<>NTIOCB.ItemIndex)
  end;
end;

procedure TNTLine.NTIOCBChange(Sender: TObject);
begin
  GenSelect:=(GenSelect or (NTIOCB.ItemIndex<>0));
end;

procedure TNTLine.SetHelpContextIDs; // NF: 24/07/06
begin
  // NF: 24/07/06 Fixes for incorrect Context IDs
  HelpContext := 2081;
  NTLDF.HelpContext := 2074;
  NTNAF.HelpContext := 2075;
  NTCCF.HelpContext := 2076;
  NTDepF.HelpContext := 2077;
  NTCurrF.HelpContext := 2078;
  NTDAmtF.HelpContext := 2079;
  NTCAmtF.HelpContext := 2080;
  Okdb1Btn.HelpContext := 278;
  Candb1Btn.HelpContext := 279;
end;


procedure TNTLine.NTVATCFDropDown(Sender: TObject);
begin
  // SSK 22/06/2017 2017-R1 ABSEXCH-13530 : this change will avoid selection of 'M' through keyboard
  if NTVATCF.Items[NTVATCF.ItemIndex][1] in ['I', 'M'] then
    if not (ExLocal.LInv.ManVAT) then
      NTVATCF.ItemIndex := 0;
end;

procedure TNTLine.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;

  //Description & PayInRef
  NTLDF.AllowPostedEdit := True;
  PIPIF.AllowPostedEdit := True;

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

function TNTLine.TransactionViewOnly: Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;

Initialization

end.
