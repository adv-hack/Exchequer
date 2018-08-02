unit JCEmpP1U;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, TEditVal, bkgroup, BTSupU1,
  SalTxl1U, GlobVar,VarConst,ExWrap1U, SBSPanel;

type
  TJCEmpP1 = class(TForm)
    PRCF: TCurrencyEdit;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    CSStkCode: Text8Pt;
    CSComp: Text8Pt;
    PRHF: TCurrencyEdit;
    SBSPanel1: TSBSPanel;
    Label84: Label8;
    Label82: Label8;
    Label81: Label8;
    Id3SCodeLab: Label8;
    Label83: Label8;
    PrDF: Text8Pt;
    Label86: Label8;
    PRAF: Text8Pt;
    Label87: Label8;
    ICurrF: TSBSComboBox;
    ICurr2F: TSBSComboBox;
    PRPF: TCurrencyEdit;
    Label85: Label8;
    PRFF: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure PRAFExit(Sender: TObject);
    procedure CSStkCodeExit(Sender: TObject);

  private
    { CJS 2012-11-01 - ABSEXCH-13650 - validating Time Rate edit }
    OriginalRateCode: string;

    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Procedure OutId;

    procedure Form2Id;

    procedure SetCaption;


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    JobPRMode,
    EmplPRMode :  Boolean;
    PREmplCode :  Str10;

    ExLocal    :  TdExLocal;
    StkMode    :  Byte;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(Edit       :  Boolean);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer);

  end;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BorBtns,
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,

  BTSupU2,
  SBSComp2,
  CmpCtrlU,
  CurrncyU,
  ComnUnit,
  ComnU2,
  SysU2,
  JobSup1U,
  ColCtrlU,
  JChkUseU,

  JCEmpR3U,

  {$IFDEF POST}
    CISSup2U,

  {$ENDIF}

  ThemeFix,

  GenWarnU,
  InvListU;




{$R *.DFM}







procedure TJCEmpP1.SetCaption;

Begin
  With ExLocal, LJobMisc^.EmplRec do
  Begin
    Caption:='Time Rate Record ';

    If (EmplPRMode) then
      Caption:=Caption+'for : '+dbFormatName(EmpCode,EmpName)
    else
      If (JobPRMode) then
      With LJobRec^ do
        Caption:=Caption+'for : '+dbFormatName(JobCode,JobDesc);
  end;


end;


procedure TJCEmpP1.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=178;
  ClientWidth:=401;

  PREmplCode:=''; EmplPrMode:=BOff; JobPrMode:=BOff;


  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TJEmpRec) then
    With TJEmpRec(Owner) do
      Self.SetFieldProperties(RTPanel);

  {$IFNDEF MC_On}

    ICurrF.Visible:=BOff;
    ICurr2F.Visible:=BOff;

  {$ELSE}

    Set_DefaultCurr(ICurrF.Items,BOff,BOff);
    Set_DefaultCurr(ICurrF.ItemsL,BOff,BOn);
    Set_DefaultCurr(ICurr2F.Items,BOff,BOff);
    Set_DefaultCurr(ICurr2F.ItemsL,BOff,BOn);

  {$ENDIF}


end;




procedure TJCEmpP1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,45);

end;

procedure TJCEmpP1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TJCEmpP1.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TJCEmpP1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TJCEmpP1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Procedure TJCEmpP1.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      38  :  ;

    end; {Case..}

  end;
  Inherited;
end;



{ == Procedure to Send Message to Get Record == }

Procedure TJCEmpP1.Send_UpdateList(Edit   :  Boolean;
                                  Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode+100;
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}



Function TJCEmpP1.CheckNeedStore  :  Boolean;

Var
  Loop  :  Integer;

Begin
  Result:=BOff;
  Loop:=0;

  While (Loop<=Pred(ComponentCount)) and (Not Result) do
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


Procedure TJCEmpP1.SetFieldFocus;

Begin
  CSStkCode.SetFocus;

end; {Proc..}





Function TJCEmpP1.ConfirmQuit  :  Boolean;

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
                StoreId(JCtrlF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(JCtrlF,LastRecAddr[JCtrlF]);

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




{ ============== Display Id Record ============ }

Procedure TJCEmpP1.OutId;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  n         :  Byte;

  KeyS      :  Str255;


Begin
  SetCaption;

  With ExLocal,LJobCtrl^.EmplPay do
  Begin
    csStkCode.Text:=Trim(EStockCode);

    { CJS 2012-11-01 - ABSEXCH-13650 - validating Time Rate edit }
    OriginalRateCode := Trim(EStockCode);

    PRDF.Text:=PayRDesc;

    PRAF.Text:=Trim(EAnalCode);

    If GetJobMisc(Self,EAnalCode,FoundCode,2,-1) then
      CSComp.Text:=JobMisc^.JobAnalRec.JAnalName;

    PRPF.Value:=PayRRate;
    PRFF.Value:=PayRFact;


    {$IFDEF MC_On}
      If (CostCurr>0) then
        ICurrF.ItemIndex:=Pred(CostCurr);

      If (ChargeCurr>0) then
        ICurr2F.ItemIndex:=Pred(ChargeCurr);
    {$ENDIF}

    PRCF.Value:=Cost;
    PRHF.Value:=ChargeOut;

  end;


end;


procedure TJCEmpP1.Form2Id;


Begin
  With ExLocal,LJobCtrl^.EmplPay do
  Begin
    EStockCode:=FullJACode(csStkCode.Text);

    PayRDesc:=PRDF.Text;

    EAnalCode:=FullJACode(PRAF.Text);

    PayRRate:=Round(PRPF.Value);

    PayRFact:=Round(PRFF.Value);

    {$IFDEF MC_On}
      CostCurr:=Succ(ICurrF.ItemIndex);

      ChargeCurr:=Succ(ICurr2F.ItemIndex);

    {$ENDIF}

    Cost:=PRCF.Value;

    ChargeOut:=PRHF.Value;

  end;



end; {Proc..}





(*  Add is used to add Notes *)

procedure TJCEmpP1.ProcessId(Fnum,
                            Keypath     :  Integer;
                            Edit        :  Boolean);

Var
  KeyS     :  Str255;
  UseNext  :  LongInt;


Begin

  Addch:=ResetKey;

  KeyS:='';

  ExLocal.InAddEdit:=BOn;

  ExLocal.LastEdit:=Edit;

  SKeypath:=Keypath;

  If (Edit) then
  Begin
    OutId;

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
  With ExLocal,LJobCtrl^,EmplPay do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPfix:=JBRCode;
      Subtype:=JBSubAry[3+Ord(EmplPRMode)];


      EmpCode:=PREmplCode;

      {$IFDEF MC_On}
        CostCurr:=1;
        ChargeCurr:=1;
      {$ENDIF}

    end;

    LastJobCtrl^:=LJobCtrl^;

    OutId;

  end {If Abort..}
  else
    Close;

end; {Proc..}



Function TJCEmpP1.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  4;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  Test     :  Byte;

  n,
  mbRet    :  Word;

  FoundCode:  Str20;

  FoundLong:  LongInt;

  { CJS 2012-09-06 - ABSEXCH-13394 - Alt+O stores Time Rates without full validation }
  MessageShown: Boolean;
Begin
  New(PossMsg);

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  { CJS 2012-09-06 - ABSEXCH-13394 - Alt+O stores Time Rates without full validation }
  MessageShown := False;

  {$IFDEF MC}
    PossMsg^[1]:='That Rate code && cost currency combination is not valid.';
  {$ELSE}
    PossMsg^[1]:='That Rate code is not valid.';
  {$ENDIF}

  PossMsg^[2]:='That Time Rate Code already exists as a Stock Code.';
  PossMsg^[3]:='The Time Cost currency is not valid.';
  PossMsg^[4]:='The Time Charge currency is not valid.';


  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LJobCtrl^,EmplPay do
  Begin
    Case Test of

      1  :
               Begin
                 // MH 01/03/2010: Modified to use the correct length as it was allowing blank rate codes to be stored
                 //Result:=(Not EmptyKey(EStockCode,StkKeyLen));
                 Result:=(Not EmptyKey(EStockCode,JobKeyLen));

                 If (Result) then
                 Begin
                   If ((Not LastEdit) or ((LastJobCtrl^.EmplPay.EStockCode<>EStockCode))
                                          or (LastJobCtrl^.EmplPay.CostCurr<>CostCurr)) and (InAddEdit) then
                   Begin
                     Result:=Not CheckExsists(FullJBKey(RecPFix,SubType,FullJBCode(EmpCode,CostCurr,EStockCode)),JCtrlF,JCK);

                   end;

                 end;


               end;

               { CJS 2012-09-06 - ABSEXCH-13394 - Alt+O stores Time Rates without full validation }
      2  :     // Result:=Not LGetMainRecPos(StockF,EStockCode);
              begin
                { CJS 2012-11-01 - ABSEXCH-13650 - validating Time Rate edit }
                if (OriginalRateCode <> Trim(EStockCode)) then
                begin
                  { Check for duplicate Time Rate code }
                  Result := (not Check4DupliGen(FullJBKey(RecPFix,SubType,FullJBCode(EmpCode,CostCurr,EStockCode)),JCtrlF,JCK,'Rate Code'));
                  if Result then
                    { Also check for Duplicate stock code }
                    Result := not (Check4DupliGen(FullStockCode(EStockCode),StockF,StkCodeK,'Stock Code',
                                   'That Time Rate Code already exists as a Stock Code'));
                  if not Result then
                    // Check4DupliGen() will already have displayed a message if
                    // required, so we shouldn't show it again.
                    MessageShown := True;
                end;
              end;


      {$IFDEF MC}

        3  :  Result:=(CostCurr<>0);
        4  :  Result:=(ChargeCurr<>0);


      {$ENDIF}


    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  { CJS 2012-09-06 - ABSEXCH-13394 - Alt+O stores Time Rates without full
    validation - Only display the error message (if required) if it has not
    already been shown. }
  If (Not Result) and (Not MainChk) and (Not MessageShown) then
    mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}




procedure TJCEmpP1.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  ReSynchPR,
  COk,
  ChkRN  :  Boolean;

  TmpMLoc
       :  JobCtrlRec;

  KeyN,OldCode:  Str255;

  KeyS :  Str255;

  mbRet:  Word;




Begin
  KeyS:='';

  Form2Id;  ReSynchPr:=BOff;


  With ExLocal,LJobCtrl^,EmplPay do
  Begin

    ChkRN:=(LastJobCtrl^.EmplPay.EStockCode<>EStockCode) and (LastEdit);

    If (ChkRN) then
      KeyS:=LastJobCtrl^.EmplPay.EStockCode;

    If (ChkRN) then
    Begin
      If (Ent_BeenUsed(3,KeyS)) then
      Begin
        EStockCode:=LastJobCtrl^.EmplPay.EStockCode;
        
        ShowMessage('It is not possible to change '+Trim(KeyS)+','+#13+'as it is has already been used inside Job Costing.');
      end;
    end;


    COk:=CheckCompleted(LastEdit,BOff);



    If (COk) then
    Begin
      {$B-}
      If (LastEdit) and (Not EmplPRMode) and (Not JobPRMode) and ((LastJobCtrl^.EmplPay.Cost<>Cost) or (LastJobCtrl^.EmplPay.ChargeOut<>ChargeOut) or
         (LastJobCtrl^.EmplPay.PayRFact<>PayRFact) or (LastJobCtrl^.EmplPay.PayRRate<>PayRRate)) then
      {$B+}
         ReSynchPr:=(CustomDlg(Application.MainForm,'Update Rates','Global Rate Update',
                               'Do you wish to update the details of any Employee based Rates with the same code from this Global Rate?',
                               mtConfirmation,
                               [mbYes,mbNo])=mrOk);

      Cursor:=CrHourGlass;

      EmplCode:=FullJBCode(EmpCode,CostCurr,EStockCode);

      ECodeNDX:=Copy(PayRDesc,1,Pred(Sizeof(ECodeNDX)));


      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpMLoc:=LJobCtrl^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LJobCtrl^:=TmpMLoc;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end
      else
      Begin

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end;

      Report_BError(Fnum,Status);


      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      IdStored:=BOn;

      Send_UpdateList(LastEdit,50);

      LastValueObj.UpdateAllLastValues(Self);

      {$IFDEF POST}
        If (ReSynchPr) then
          AddUPayRate2Thread(Application.MainForm,EStockCode,CostCurr,1);
      {$ENDIF}

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TJCEmpP1.SetFieldProperties(Field  :  TSBSPanel) ;

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


  end; {Loop..}


end;


procedure TJCEmpP1.EditLine(Edit       :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ProcessId(JCtrlF,JCK,LastEdit);
  end;
end;


procedure TJCEmpP1.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      if CanCP1Btn.CanFocus then
        CanCP1Btn.SetFocus;
      if (ActiveControl = CanCP1Btn) then
        StoreId(JCtrlF,SKeypath);
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


procedure TJCEmpP1.DeleteBOMLine(Fnum,
                                  KeyPath  :  Integer);

Var
  MbRet  :  Word;
  GotRec :  Integer;
  KeyS   :  Str255;

Begin
  With ExLocal do
  Begin
    AssignFromGlobal(Fnum);
    LGetRecAddr(Fnum);
    OutId;
    OKCP1Btn.Enabled:=BOff;
    CanCP1Btn.Enabled:=BOff;

    MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Time Rate record',
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
          Send_UpdateList(BOff,58);
        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}



procedure TJCEmpP1.PRAFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  AMode      :  Byte;

begin

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AMode:=3;

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) or (FoundCode=''))  and (ActiveControl<>CanCP1Btn)  then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,2,AMode));

        If (FoundOk) then {* Credit Check *}
        Begin

          Text:=FoundCode;

          CSComp.Text:=JobMisc^.JobAnalRec.JAnalName;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

        end
        else
        Begin
          {StopPageChange:=BOn;}

          SetFocus;
        end; {If not found..}
      end;

    end;

end;





procedure TJCEmpP1.CSStkCodeExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str20;


begin

  If (Sender is TMaskEdit) and (ActiveControl<>CanCP1Btn) then
  With ExLocal,LJobCtrl^,EmplPay,(Sender as TMaskEdit) do
  Begin
    Text:=UpcaseStr(Text);

    Form2Id;

    CCode:=FullJACode(Text);

    COK:=BOn;


    If ((Not LastEdit) or (LastJobCtrl^.EmplPay.EStockCode<>CCode)) and (InAddEdit) then
    Begin
      If (EmplPRMode) or (JobPRMode) then
      Begin
        AssignToGlobal(JCtrlF);

        COk:=Get_StdPayRate(Self,CCode,0,0,3);

        If (COk) then
        Begin
          AssignFromGlobal(JCtrlF);
        end;
      end
      else
        COk:=BOn;


      If (COk) then
        COk:=(Not Check4DupliGen(FullJBKey(RecPFix,SubType,FullJBCode(EmpCode,CostCurr,EStockCode)),JCtrlF,JCK,'Rate Code'));

      If (COk) then {* Also check for Duplicate stock code *}
        { CJS 2012-09-06 - ABSEXCH-13392 - Stock Code/Time Rate warning message }
        COK:=Not (Check4DupliGen(FullStockCode(EStockCode),StockF,StkCodeK,'Stock Code',
                  'That Time Rate Code already exists as a Stock Code'));

      If (Not COk) then
      Begin

        SetFocus;
      end
      else
      Begin
        {$IFDEF MC}
          If (CostCurr=0) then
            CostCurr:=1;
        {$ENDIF}

        OutId;

      end;

    end;
  end;
end;





Initialization

end.
