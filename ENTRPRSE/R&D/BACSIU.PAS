unit BACSIU;

interface

{$I DefOvr.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RepInp1U, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, TEditVal, Mask,
  VarConst, BTSupU1, BTSupU3, BorBtns, StrUtils, Spin, ComCtrls;

type
  TBatchInp = class(TRepInpMsg)
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    Label87: Label8;
    NomDescF: Text8Pt;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    CQNo: TCurrencyEdit;
    AgeX: TSBSComboBox;
    CurrF: TSBSComboBox;
    CurrPF: TSBSComboBox;
    AgeIntF: TCurrencyEdit;
    Label88: Label8;
    Label89: Label8;
    ACFF: Text8Pt;
    RunF: TCurrencyEdit;
    PayIF: Text8Pt;
    RPayF: TSBSComboBox;
    Label810: Label8;
    GLMDC: Text8Pt;
    NomDescF2: Text8Pt;
    Label811: Label8;
    FilterX: TSBSComboBox;
    edtYourRef: Text8Pt;
    UseACC: TCheckBox;
    SetPCQ: TCheckBox;
    CBExcep: TCheckBox;
    grpPPD: TGroupBox;
    grpSettlementDiscount: TGroupBox;
    IncSDueCB: TCheckBox;
    Label812: Label8;
    SDDOverF: TCurrencyEdit;
    chkGivePPD: TCheckBox;
    lblIntendedPaymentDate: TLabel;
    edtIntendedPaymentDate: TEditDate;
    lblExpiryTolerance: TLabel;
    lblExpiryToleranceDays: TLabel;
    udExpiryToleranceDays: TUpDown;
    edtExpiryToleranceDays: TCurrencyEdit;
    procedure Id3CCFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure CQNoEnter(Sender: TObject);
    procedure CQNoExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure RPayFExit(Sender: TObject);
    procedure IncSDueCBClick(Sender: TObject);
    procedure CurrPFExit(Sender: TObject);
    procedure CurrFExit(Sender: TObject);
    procedure edtExpiryToleranceDaysKeyPress(Sender: TObject;
      var Key: Char);
  private
    { Private declarations }
    CRepParam  :  ^PassWordRec;

    FormRepPtr :  PFormRepPtr;

    InList,
    BACSMode   :  Boolean;

    BpUsrAddr  :  LongInt;

    procedure SetBACSMode;
    procedure SetBatchRec;

    Function CheckGLCurr  :  Boolean;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    procedure Show_BatchList;

    Function Check_CompletedOK  : Boolean;

    procedure SetHelpContextIDs; // NF: 12/04/06

  public
    { Public declarations }
    ReRun,
    IsCust     :  Boolean;


  end;


procedure Share_BatchPayments(IsCust  :  Boolean);

procedure BACS_CtrlRun(IsCust,
                       ReRun   :  Boolean;
                       AOwner  :  TComponent);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  BTKeys1U,
  InvListU,
  BPayLstU,
  CurrncyU,
  BPyItemU,

  {$IFDEF Rp}
    PrintFrm,
    BACS2U,
  {$ENDIF}

    SysU3,

  SysU2,
  GenWarnU,
  BPWarnUU,
  BTSupU2;

{$R *.DFM}


Var
  GIsCust,
  GReRun  :  Boolean;




procedure TBatchInp.SetBatchRec;

Begin
  BACS_CtrlGet(PWrdF,PWK,CRepParam^,IsCust,nil);

  With CRepParam^.BACSCRec do
  Begin
    RunF.Value:=(TagRunNo*Ord(Not ReRun))+(LastTagRunNo*Ord(ReRun));

    RPayF.ItemIndex:=CPayType2Index(PayType);

    ACFF.Text:=Form_Int(BankNom,0);

    GLMDC.Text:=Form_BInt(TagCtrlCode,0);

    Id3CCF.Text:=TagCCDep[BOn];
    Id3DepF.Text:=TagCCDep[BOff];
    UseACC.Checked:=UseAcCC;

    {$IFDEF MC_On}
      CurrF.ItemIndex:=InvCurr;

      If (PayCurr>0) then
        CurrPF.ItemIndex:=Pred(PayCurr);
    {$ENDIF}

    AgeX.ItemIndex:=Pred(AgeType);
    AgeIntF.Value:=AgeInt;
    CQNo.Value:=CQStart;
    SetPCQ.Checked:=SetCQatP;
    PayIF.Text:=SRCPIRef;
    IncSDueCB.Checked:=IncSDisc;
    SDDOverF.Value:=SDDaysOver;
    CBExcep.Checked:=ShowLog;

    // MH 08/07/2010 v6.4 ABSEXCH-10017: Added YourRef field into Batch Payments/Receipts Wizard
    edtYourRef.Text := YourRef;

    // CJS 2015-05-07 -  - v7.0.14 - PPD - T2-155 - Batch Payment/Receipt - Parameters Dialog - Add new fields
    chkGivePPD.Checked := CRepParam.BACSCRec.ApplyPPD;
    edtIntendedPaymentDate.DateValue := CRepParam.BACSCRec.IntendedPaymentDate;
    udExpiryToleranceDays.Position := CRepParam.BACSCRec.PPDExpiryToleranceDays;

    IncSDueCBClick(Nil);

    SetBACSMode;
  end;
end;

procedure TBatchInp.FormCreate(Sender: TObject);

Var
  HideCC  :  Boolean;

begin
  inherited;

  ClientHeight:=456;
  ClientWidth:=404;

  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

    Set_DefaultCurr(CurrPF.Items,BOff,BOff);
    Set_DefaultCurr(CurrPF.ItemsL,BOff,BOn);
    CurrPF.ItemIndex:=0;

  {$ELSE}
    Label88.Visible:=BOff;
    Label89.Visible:=BOff;
    CurrF.Visible:=BOff;
    CurrPF.Visible:=BOff;

  {$ENDIF}

    HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}

  Id3CCF.Visible:=Not HideCC;
  Id3DepF.Visible:=Not HideCC;
  Label84.Visible:=Not HideCC;
  UseACC.Visible:=Not HideCC;

  BACSMode:=BOff;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  New(FormRepPtr);

  FillChar(FormRepPtr^,Sizeof(FormRepPtr^),0);

  With FormRepPtr^,PParam do
  Begin
    PBatch:=BOn;
    RForm:=SyssForms.FormDefs.PrimaryForm[5];
  end;

  AgeX.ItemIndex:=2;
  AgeIntF.Value:=1;

  RPayF.ItemIndex:=0;
  AgeIntF.DisplayFormat:='';
  CQNo.DisplayFormat:='';


  IsCust:=GIsCust;
  ReRun:=GReRun;

  SDDOverF.BlockNegative:=BOn;
  RunF.BlockNegative:=BOn;

  If (Not ReRun) then
  Begin
    With RunF do
    Begin
      ReadOnly:=BOn;
      TabStop:=BOff;

      Color:=clBtnFace;

      ActiveControl:=CBExcep;
    end;

    //Label811.Visible:=BOff;
    FilterX.Visible:=BOff;

    // MH 08/07/2010 v6.4 ABSEXCH-10017: Added YourRef field into Batch Payments/Receipts Wizard
    Label811.Caption := IfThen(IsCust,'SRC','PPY') + ' Your Ref';
    edtYourRef.Top := FilterX.Top;
    edtYourRef.Left := FilterX.Left;
    edtYourRef.Visible := True;
  end
  else
  Begin
    {With CurrF do  Do not disable this, as with out it a previous run in another currency cannot be run
    Begin
      ReadOnly:=BOn;
      TabStop:=BOff;
      Color:=clBtnFace;
    end;}

    With CurrPF do
    Begin
      ReadOnly:=BOn;
      TabStop:=BOff;
      Color:=clBtnFace;
    end;

    //HV 09/02/2016 2016-R1 ABSEXCH-15816: When Re-producing a Batch Payment or Batch Receipt, the system allow the Bank GL code to be overwrite
    //With ACFF do
    //Begin
    //  ReadOnly:=BOn;
    //  TabStop:=BOff;
    //  Color:=clBtnFace;
    //end;

    With Id3CCF do
    Begin
      ReadOnly:=BOn;
      TabStop:=BOff;
      Color:=clBtnFace;
    end;

    With Id3DepF do
    Begin
      ReadOnly:=BOn;
      TabStop:=BOff;
      Color:=clBtnFace;
    end;


    With UseACC do
    Begin
      Enabled:=BOff;
      TabStop:=BOff;
    end;

    With AgeX do
    Begin
      ReadOnly:=BOn;
      TabStop:=BOff;
      Color:=clBtnFace;
    end;

    With AgeIntF do
    Begin
      ReadOnly:=BOn;
      TabStop:=BOff;
      Color:=clBtnFace;
    end;

    With GLMDC do
    Begin
      ReadOnly:=BOn;
      TabStop:=BOff;
      Color:=clBtnFace;
    end;

    FilterX.ItemIndex:=0;

    CBExcep.Visible:=BOff;
  end;

  If (IsCust) then
  Begin
    // CJS 2015-05-07 -  - v7.0.14 - PPD - T2-155 - Batch Payment/Receipt - Parameters Dialog - Add new fields
    chkGivePPD.Caption := 'Give PPD';

    Caption:=Caption+' Receipts';
    CQNo.Visible:=BOff;
    SetPCQ.Visible:=BOff;

    PayIF.Top:=CQNo.Top;
    Label85.Caption:='Paying In Reference';
  end
  else
  Begin
    // CJS 2015-05-07 -  - v7.0.14 - PPD - T2-155 - Batch Payment/Receipt - Parameters Dialog - Add new fields
    chkGivePPD.Caption := 'Take PPD';

    Caption:=Caption+' Payments';
    PayIF.Visible:=BOff;
  end;

  If (ReRun) then
    Caption:=Caption+' Rerun.';

  InList:=BOff;

  SetBatchRec;

  {SetLastValues;}

  With CRepParam^,BACSCRec do
  Begin
    If (BankNom<>0) and (Nom.NomCode<>BankNom) then
    Begin
      Global_GetMainRec(NomF,FullNomKey(BankNom));

    end;

    If (BankNom<>0) then
      NomDescF.Text:=Nom.Desc
    else
      NomDescF.Text:='';

    If (TagCtrlCode<>0) and (Nom.NomCode<>TagCtrlCode) then
    Begin
      Global_GetMainRec(NomF,FullNomKey(TagCtrlCode));

    end;

    If (TagCtrlCode<>0) then
      NomDescF2.Text:=Nom.Desc
    else
      NomDescF.Text:='';

  end;

  SetHelpContextIDs;// NF: 12/04/06
end;


Procedure TBatchInp.WMCustGetRec(Var Message  :  TMessage);

Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      55,56
          :  Begin
               If (Not ReRun) then
               Begin
                 OKCp1Btn.Enabled:=BOn;
                 Show_BatchList;
               end;

               ShutDown;
             end; {Start List}
    end; {Case..}
  end;
end;



procedure TBatchInp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

  Dispose(FormRepPtr);

  If (Not InList) then
    SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,70+Ord(IsCust),0);

end;

procedure TBatchInp.Id3CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin
  Inherited;

  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>ClsCP1Btn) and (ActiveControl<>OkCP1Btn) and
          (Syss.UseCCDep)   and (Not Has_CCWildChar(FoundCode)) then
      Begin

        StillEdit:=BOn;

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


procedure TBatchInp.ACFFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod,
  MDCFlg     :  Boolean;

  FoundLong  :  LongInt;


begin
  MDCFlg:=(Sender=GLMDC);

  FoundOk:=BOff;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    If (Not MDCFlg) then
      FoundCode:=Strip('B',[#32],Text)
    else
      FoundCode:=Text;

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>ClsCP1Btn) and ((FoundCode<>'') or (Not MDCFlg)) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self,FoundCode,FoundLong,2+(77*Ord(MDCFlg))));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=Form_Int(FoundLong,0);

        If (MDCFlg) then
          NomDescF2.Text:=Nom.Desc
        else
          NomDescF.Text:=Nom.Desc;

      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;


    If (Not FoundOk) and (AltMod) and (FoundCode='') then
    Begin
      If (MDCFlg) then
        NomDescF2.Text:=''
      else
        NomDescF.Text:='';
    end;
  end; {with..}
end;


Function TBatchInp.CheckGLCurr  :  Boolean;

Var
  InvR  :  InvRec;
  LId   :  Idetail;
  mbRet :  Word;

Begin
  Result:=BOn;

  Blank(InvR,Sizeof(InvR));
  Blank(LId,Sizeof(LId));

  {$IFDEF MC_On}
     With LId do
     Begin
       InvR.InvDocHed:=NMT;
       Currency:=Succ(CurrPF.ItemIndex);
       NomCode:=IntStr(ACFF.Text);

       Result:=Check_GLCurr(InvR,LId,0);

       If (Not Result) then
       Begin
         mbRet:=CustomDlg(Application.MainForm,'BACS Currency Warning','Currency of payments is not '+SSymb(Nom.DefCurr),
                               'The bank account you have chosen cannot be paid in '+Ssymb(Currency)+#13+
                               'Please change the currency, or the bank account.',
                               mtInformation,
                               [mbOk])
       end;
     end;
  {$ENDIF}
end;


procedure TBatchInp.CurrPFExit(Sender: TObject);
begin
  inherited;

  If (ActiveControl<>ClsCP1Btn) then
  With CurrPF do
  Begin
    {If (Not CheckGLCurr) and (CanFocus) then
     SetFocus;}

  end;

end;


procedure TBatchInp.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {}
  Inherited;
end;

procedure TBatchInp.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {}
  Inherited;
end;





procedure TBatchInp.SetBACSMode;

Begin

  With CRepParam^.BACSCRec do
  Begin
    BACSMode:=(RPayF.ItemIndex=1);

    If (BACSMode) then
    Begin
      {With CurrPF do  Some countries outside of BACS could generate different currency payments

      {Begin
        ReadOnly:=BOn;
        TabStop:=BOff;
        Color:=clBtnFace;
        ItemIndex:=0;
      end;}

      With CQNo do
      Begin
        ReadOnly:=BOn;
        TabStop:=BOff;
        Color:=clBtnFace;
      end;


    end
    else
    Begin
      With CQNo do
      Begin
        ReadOnly:=BOff;
        TabStop:=BOn;
        Color:=clWhite;
      end;


    end;
  end; {With..}
end;


procedure TBatchInp.RPayFExit(Sender: TObject);
begin
  inherited;
  SetBacsMode;
end;

procedure TBatchInp.CQNoEnter(Sender: TObject);
begin
  inherited;
  With CQNo do
  Begin
    If (Not ReRun) then
      Value:=StrtoInt(Get_NextChequeNo(BOff));
  end;
end;

procedure TBatchInp.CQNoExit(Sender: TObject);
begin
  inherited;
  With CQNo do
  Begin
    If (Value<>0) and (ActiveControl<>ClsCp1Btn) then
      Put_NextChequeNo(Text,BOff);
  end;
end;

procedure TBatchInp.IncSDueCBClick(Sender: TObject);
begin
  inherited;
  SDDOverF.Enabled:=IncSDueCB.Checked;
end;


procedure TBatchInp.Show_BatchList;

Var
  BPay  :  TBatchPay;
Begin
  Set_BPFormMode(IsCust,CRepParam^.BACSCRec.TagRunNo);
  {* Get latest totals *}
  SetBatchRec;

  BPay:=TBatchPay.Create(Self.Owner);

  try
    With BPay do
    Begin
      MyUsrAddr:=BpUsrAddr;
      MyUsrNo:=CRepParam^.BACSCRec.LIUCount;

      BatchCtrl:=CRepParam^;
      SetListLabels;

      MULCTrlO.BatchCtrl:=BatchCtrl.BACSCRec;

      RefreshList(BOn,BOn);


      InList:=BOn;
    end;
  except
    BPay.Free;

    InList:=BOff;
  end;

end;

Function TBatchInp.Check_CompletedOK  : Boolean;

Const
  NofMsgs      =  4;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  Test,
  mbRet    :  Word;

  FoundLong
           :  LongInt;

  DateText: string;
Begin
  if ClsCP1Btn.Focused then
  begin
    Result := True;
    exit;
  end;

  ShowMsg := False;
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='General Ledger Code is not valid.';
  PossMsg^[2]:=' Cost Centre/ Department Code not valid.';
  PossMsg^[3]:=' Bank/GL curr not valid ';
  PossMsg^[4]:='Intended Payment Date not valid.';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;

  While (Test<=NofMsgs) and (Result) do
  With CRepParam^.BACSCRec do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=GetNom(Self,ACFF.Text,FoundLong,-1);

            end;


      {$IFDEF PF_On}

        2  :  Begin
                Result:=(Not Syss.UseCCDep);

                If (Not Result) then
                Begin
                  Result:=BOn;
                  For Loop:=BOff to BOn do
                  Begin

                    Result:=(GetCCDep(Self,TagCCDep[Loop],FoundCode,Loop,-1) and (Result));

                  end;
                end;

              end;


      {$ENDIF}


      {$IFDEF MC_On}

         3  :  Begin
                 ShowMsg:=BOff;

                 Result:=CheckGLCurr;
               end;

      {$ENDIF}

         4 :  begin
                if (chkGivePPD.Checked) then
                begin
                  Result := ValidDate(Date2Store(edtIntendedPaymentDate.Text));
                  if not Result and edtIntendedPaymentDate.CanFocus then
                  begin
                    ShowMsg := False;
                    edtIntendedPaymentDate.SetFocus;
                  end;
                end;
              end;

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}


procedure TBatchInp.CurrFExit(Sender: TObject);
begin
  inherited;
  If Sender is TSBSComboBox then
  With TSBSComboBox(Sender) do
  Begin
    If (ItemIndex<0) then
      ItemIndex:=0;
  end;

end;



procedure TBatchInp.OkCP1BtnClick(Sender: TObject);

Var
  OldPWord  :  PassWordRec;
  Ok2Print  :  Boolean;
  mbRet     :  Word;

begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^.BACSCRec do
      Begin
        Ok2Print:=BOff;

        OldPWord:=CRepParam^;

        With RPayF do
        If (ItemIndex>=0) then
        Begin
          PayType:=Items[ItemIndex][1];
        end;

        {$IFDEF MC_On}
          InvCurr:=CurrF.ItemIndex;
          PayCurr:=Succ(CurrPF.ItemIndex);

          If (PayCurr<>1) and (RPayF.ItemIndex=1) {BACS} then
            mbRet:=CustomDlg(Application.MainForm,'BACS Currency Warning','Currency of payments is not '+SSymb(1),
                                   'The BACS payment file standard does not contain a currency identifier.'+#13+
                                   'Please ensure the bank the BACS file is being sent to will be able to process this payment run in '+SSymb(PayCurr)+#13+
                                   'Otherwise these payments will be processed by the bank in '+Ssymb(1),
                                   mtInformation,
                                   [mbOk,mbCancel])
          else
            mbRet:=mrOK;

        {$ELSE}
          mbRet:=mrOk;

        {$ENDIF}

        If (mbRet=mrOK) then
        Begin

          TagCCDep[BOff]:=Id3DepF.Text;
          TagCCDep[BOn]:=Id3CCF.Text;

          UseAcCC:=UseACC.Checked;

          AgeType:=Succ(AgeX.ItemIndex);
          AgeInt:=Round(AgeIntF.Value);

          TagRunNo:=Round(RunF.Value);


          ShowLog:=CBExcep.Checked;

          CQStart:=Round(CQNo.Value);

          SetCQatP:=SetPCQ.Checked;

          SRCPIRef:=PayIF.Text;

          BankNom:=IntStr(ACFF.Text);
          TagCtrlCode:=IntStr(GLMDC.Text);

          IncSDisc:=IncSDueCB.Checked;

          SDDaysOver:=Round(SDDOverF.Value);

          UseOsNdx:=UseV5OsNdx;

          // CJS 2015-05-07 -  - v7.0.14 - PPD - T2-155 - Batch Payment/Receipt - Parameters Dialog - Add new fields
          CRepParam^.BACSCRec.ApplyPPD := chkGivePPD.Checked;
          CRepParam^.BACSCRec.IntendedPaymentDate := edtIntendedPaymentDate.DateValue;
          // CJS 2015-08-26 - ABSEXCH-16773 - Batch Payments expiry tolerance days
          CRepParam^.BACSCRec.PPDExpiryToleranceDays := StrToIntDef(Trim(edtExpiryToleranceDays.Text), udExpiryToleranceDays.Position);

          // MH 08/07/2010 v6.4 ABSEXCH-10017: Added YourRef field into Batch Payments/Receipts Wizard
          If (Not ReRun) Then
            YourRef := edtYourRef.Text;

          If (ReRun) then
          Begin
            {$IFDEF Rp}
              With FormRepPtr^,PParam do
              Begin
                If SalesMode then
                  RForm:=SyssForms.FormDefs.PrimaryForm[14]
                else
                  RForm:=SyssForms.FormDefs.PrimaryForm[5];

                PDevRec.feBatch:=BOn;

                SFiltX:=FilterX.ItemIndex;


                Ok2Print:=pfSelectFormPrinter(PDevRec,BOn,RForm,UFont,Orient);
              end;

              If (Ok2Print) then
              Begin
                OkCp1Btn.Enabled:=BOff;
                ClsCp1Btn.Enabled:=BOff;

                AddBACSPay2Thread(Self,CRepParam^,ReRun,CRepParam^.BACSCRec.SalesMode,FormRepPtr,Self.Handle);

                Enabled:=BOff;
              end;
            {$ENDIF}
          end
          else
            If (Check_CompletedOk) then
            Begin
              If (Not BACS_HasUsers(IsCust,BOff,0)) then
              Begin

                CRepParam^.BACSCRec.LIUCount:=1;

                {* Register this user in use *}

                BACS_UsrGet(IsCust,
                            CRepParam^.BACSCRec.LIUCount,
                            BPUsrAddr,
                            1);

                BACS_CtrlPut(PWrdF,PWK,CRepParam^,nil,0);

                If (OldPWord.BACSCRec.PayType<>PayType)
                    or (OldPWord.BACSCRec.AgeType<>AgeType)
                    or (OldPWord.BACSCRec.AgeInt<>AgeInt)
                    or (OldPWord.BACSCRec.InvCurr<>InvCurr)
                    or (OldPWord.BACSCRec.PayCurr<>PayCurr)
                    or (OldPWord.BACSCRec.TagCtrlCode<>TagCtrlCode)
                    or (OldPWord.BACSCRec.IncSDisc<>IncSDisc)
                    or (OldPWord.BACSCRec.SDDaysOver<>SDDaysOver)
                    // CJS 2015-06-10 - ABSEXCH-16539 - rebuild Batch Payments list if PPD settings change
                    or (OldPWord.BACSCRec.ApplyPPD <> ApplyPPD)
                    or (OldPWord.BACSCRec.IntendedPaymentDate <> IntendedPaymentDate)
                    or (OldPWord.BACSCRec.PPDExpiryToleranceDays <> PPDExpiryToleranceDays)
                    or (Not TagStatus) then
                Begin
                  OkCp1Btn.Enabled:=BOff;
                  ClsCp1Btn.Enabled:=BOff;


                  AddBACSScan2Thread(Application.MainForm,CRepParam^,Self.Handle);

                  Enabled:=BOff;
                end
                else
                Begin
                  Show_BatchList;
                  ShutDown;
                End; // Else
              End // If (Not BACS_HasUsers(IsCust,BOff,0))
              Else
              Begin
                Share_BatchPayments(IsCust);
                ShutDown;
              End; // Else
            End // If (Check_CompletedOk)
            else
              ACFF.SetFocus;
        End; // If (mbRet=mrOK)
      End; // With CRepParam^.BACSCRec
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;


procedure Share_BatchPayments(IsCust  :  Boolean);

Var
  BPay  :  TBatchPay;
  BCtrl :  PassWordRec;
  MyAddr:  LongInt;

Begin
  FillChar(BCtrl,Sizeof(BCtrl),#0);

  {Display list of logged in users}

  Show_LIUsers(IsCust,0);

  BCtrl.BacsCRec.SalesMode:=IsCust;
  
  {Lock prev ctrl record}

  BACS_CtrlPut(PWrdF,PWK,BCtrl,nil,1);

  {* Register this user in use *}

  Inc(BCtrl.BACSCRec.LIUCount);
  BACS_UsrGet(IsCust,
              BCtrl.BACSCRec.LIUCount,
              MyAddr,1);

  BACS_CtrlPut(PWrdF,PWK,BCtrl,nil,0);

  Set_BPFormMode(IsCust,BCtrl.BACSCRec.TagRunNo);

  BPay:=TBatchPay.Create(Application.MainForm);

  try
    With BPay do
    Begin
      MyUsrAddr:=MyAddr;
      MyUsrNo:=BCtrl.BACSCRec.LIUCount;

      BatchCtrl:=BCtrl;
      SetListLabels;

      MULCTrlO.BatchCtrl:=BatchCtrl.BACSCRec;

      RefreshList(BOn,BOn);

    end;
  except
    BPay.Free;
  end;
end;


procedure BACS_CtrlRun(IsCust,
                       ReRun   :  Boolean;
                       AOwner  :  TComponent);

Var
  RepInpMsg1  :  TBatchInp;

Begin
  GIsCust:=IsCust;
  GReRun:=ReRun;

  {$B-} {If we are calling a re-run or there are no other users in proceed normally}
  If (ReRun) or (Not BACS_HasUsers(IsCust,BOff,0)) then
  {$B+}
    RepInpMsg1:=TBatchInp.Create(AOwner)
  else
  Begin
    Share_BatchPayments(IsCust);

  end;

end;

procedure TBatchInp.SetHelpContextIDs; // NF: 12/04/06
var
  bPurchase : boolean;

  procedure IncHelpContextIDs(iInc : integer; TheControl : TControl);
  var
    iPos : integer;

    procedure SetContextID(AControl : TControl; iNewID : integer);
    begin{SetContextID}
      // Set Context ID
      if AControl.HelpContext > 0
      then AControl.HelpContext := iNewID;
    end;{SetContextID}

  begin{IncHelpContextIDs}
    // Inc the control's Context ID
    SetContextID(TheControl, TheControl.HelpContext + iInc);

    // Inc the Context IDs of the controls in the control
    For iPos := 0 to Thecontrol.ComponentCount -1 do
    begin
      if Thecontrol.Components[iPos] is TControl
      and (not (Thecontrol.Components[iPos] is TForm))  // NF: 08/05/06 - Fixed so that it does not itterate through other Forms
      then IncHelpContextIDs(iInc, TControl(TheControl.Components[iPos]));
    end;{for}
  end;{IncHelpContextIDs}

begin
  bPurchase := not IsCust;
  {$IFDEF LTE}
    // IAO
    HelpContext := 40100;
    CBExcep.HelpContext := 1692;
    OkCP1Btn.HelpContext := 1705; // NF: 09/05/06 Fix for incorrect Context ID
    ClsCP1Btn.HelpContext := 1706; // NF: 09/05/06 Fix for incorrect Context ID
    if not bPurchase then IncHelpContextIDs(5000, Self);
//    OkCP1Btn.HelpContext := HelpContext; NF: 09/05/06
//    ClsCP1Btn.HelpContext := HelpContext; NF: 09/05/06
  {$ELSE}
    // Exchequer
    // NF: 09/05/06 Fixes for incorrect Context IDs
    bPurchase := not IsCust;
    if bPurchase then
    begin
      OkCP1Btn.HelpContext := 1705;
      ClsCP1Btn.HelpContext := 1706;
    end else
    begin
      OkCP1Btn.HelpContext := 6705;
      ClsCP1Btn.HelpContext := 6706;
    end;{if}
  {$ENDIF}
end;

procedure TBatchInp.edtExpiryToleranceDaysKeyPress(Sender: TObject;
  var Key: Char);
begin
  // CJS 2015-07-08 - ABSEXCH-16639 - add range restriction to Expiry Tolerance Days in Batch Payments
  inherited;
  if (Key = '-') then
    Key := #0;
end;

Initialization

  GIsCust:=BOff;
  GReRun:=BOff;

Finalization


end.
