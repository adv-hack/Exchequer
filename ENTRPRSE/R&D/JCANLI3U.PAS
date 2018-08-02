unit JCAnlI3U;

{$I DEFOvr.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, TEditVal, bkgroup, BTSupU1,Math,
  SalTxl1U, GlobVar,VarConst,ExWrap1U, SBSPanel, ComCtrls, BorBtns;

Type
  RtRecType = record
                Default  :  Byte;

                PossSet  :  Set of Byte;
              end;

  TJCAnlI1 = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;                                           
    TabSheet3: TTabSheet;
    SBSPanel1: TSBSPanel;
    Label84: Label8;
    Label82: Label8;
    Label85: Label8;
    Label88: Label8;
    Label83: Label8;
    Label87: Label8;
    Label89: Label8;
    CISPanel1: TSBSBackGroup;
    JATCB: TSBSComboBox;
    JAWF: Text8Pt;
    JAPF: Text8Pt;
    SRLTF: TSBSComboBox;
    JACISF: TSBSComboBox;
    JARevTF: TSBSComboBox;
    JACCB: TSBSComboBox;
    Label810: Label8;
    Label811: Label8;
    JAUPCF: TCurrencyEdit;
    JAUCF: Text8Pt;
    SBSBackGroup2: TSBSBackGroup;
    JACRCB: TBorCheckEx;
    JAPTCB: TSBSComboBox;
    JAADCB: TSBSComboBox;
    JADedF: TCurrencyEdit;
    Label814: Label8;
    SBSBackGroup3: TSBSBackGroup;
    JARTCB: TSBSComboBox;
    Label817: Label8;
    Label818: Label8;
    JARVF: TCurrencyEdit;
    Label819: Label8;
    JAECB: TSBSComboBox;
    Label820: Label8;
    JAEIF: TCurrencyEdit;
    Label821: Label8;
    Label86: Label8;
    Label81: Label8;
    JARCYCB: TBorCheckEx;
    JACompCB: TSBSComboBox;
    Label812: Label8;
    JAPCF: Text8Pt;
    CSStkCode: Text8Pt;
    JADF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure CSStkCodeExit(Sender: TObject);
    procedure JAWFExit(Sender: TObject);
    procedure JATCBChange(Sender: TObject);
    procedure JARevTFEnter(Sender: TObject);
    procedure JAUCFExit(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure JAECBChange(Sender: TObject);
    procedure JAPTCBChange(Sender: TObject);
    procedure JACompCBChange(Sender: TObject);
    procedure JARTCBChange(Sender: TObject);

  private
    InOutId,
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

    Procedure ChangePage(NewPage  :  Integer);

    Procedure SetDeductTab;

    Procedure OutId;

    procedure Form2Id;

    procedure SetCaption;

    procedure BuildDesign;

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    
    Function ChkRtRelate(Many2One  :  Boolean;
                         TL,CatL   :  Byte)  :  Boolean;

    Function GetRtRelateDef(Many2One  :  Boolean;
                            TL,CatL   :  Byte)  :  Byte;

  public
    { Public declarations }

    ExLocal    :  TdExLocal;
    JTMode     :  Boolean;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(Edit       :  Boolean);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer);

    Function Current_Page  :  Integer;

  end;

  Function GetRtRelate(Many2One  :  Boolean;
                       TL,CatL   :  Byte)  :  RtRecType;

Var
  SetJTMode  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
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
  SysU3,
  VarJCstU,
  JobSup1U,
  ColCtrlU,

  ThemeFix,
  
  InvListU,
  JChkUseU,
  JCSSet1U;

{$R *.DFM}

procedure TJCAnlI1.SetCaption;

Begin
  If (JTMode) then
    Caption:='Job Type Record Entry';
end;

procedure TJCAnlI1.BuildDesign;

Var
  n  :  Byte;

Begin

  Set_JAPDefaultDocT(SRLTF.Items,0);
  Set_JAPDefaultDocT(SRLTF.ItemsL,0);

  With JATCB do
  Begin
    For n:=1 to NofXTypes do
      Items.Add(JobXDesc^[n]);
  end;

  With JACCB do
  Begin
    For n:=1 to NofSysAnals do
      Items.Add(SyssJob^.JobSetUp.SummDesc[JCCats_TxLate(n,BOn)]);
  end;

  With JARevTF do
  Begin
    Items.Add('N/A');

    For n:=Succ(JCCats_TxLate(SysDeductSales,BOff)) to JCCats_TxLate(SysOH2,BOff) do
      Items.Add(SyssJob^.JobSetUp.SummDesc[JCCats_TxLate(n,BOn)]);
  end;


  If (JTMode) then
  Begin
    // Hide unwanted fields

    // Analysis Type
    JATCB.Visible:=BOff;         Label82.Visible:=BOff;

    // Catagory
    JACCB.Visible:=BOff;         Label83.Visible:=BOff;

    // P&L GL Code
    JAWF.Visible:=BOff;          Label84.Visible:=BOff;

    // WIP GL Code
    JAPF.Visible:=BOff;          Label85.Visible:=BOff;

    // Line Type
    SRLTF.Visible:=BOff;         Label88.Visible:=BOff;

    // Revenue Type
    JARevTF.Visible:=BOff;       Label87.Visible:=BOff;

    // Deduct CIS Tax
    JACISF.Visible:=BOff;        Label89.Visible:=BOff;

    // Apply Uplift To Costs panel
    CISPanel1.Visible:=BOff;

    // Uplift Control G/L Code
    JAUPCF.Visible:=BOff;

    // Uplift%
    JAUCF.Visible:=BOff;

    // Payroll Code
    JAPCF.Visible:=BOff;         Label812.Visible:=BOff;

    // Bodge existing fields for Job Type
    Label81.Caption:='Job Type Code';
//    Label81.Top:=31;
//    CSStkCode.Top:=59;
//    Label86.Top:=31;
//    JADF.Top:=59;
//    Label81.Left:=Label81.Left-2;
    CSStkCode.MaxLength:=3;

    // Resize frame vertically
    SBSPanel1.Height := CSStkCode.Height + (2 * CSStkCode.Top);

    // Move buttons to underside of resized frame
    OKCP1Btn.Top := Self.ScreenToClient(TabSheet1.ClientToScreen(Point(1, SBSPanel1.Top + SBSPanel1.Height))).Y + SBSPanel1.Top;
    CanCP1Btn.Top := OKCP1Btn.Top;

    // Resize Form/PageControl/Tabsheet - PageControl is aligned to client
    //Self.ClientHeight := Self.ClientHeight - (TabSheet1.ClientHeight - (OKCP1Btn.Top + OKCP1Btn.Height + SBSPanel1.Top));
    Self.ClientHeight := OKCP1Btn.Top + OKCP1Btn.Height + SBSPanel1.Top;

//    Self.ClientHeight:=198;
//    OKCP1Btn.Top:=Self.Height-70;
//    CanCP1Btn.Top:=OKCP1Btn.Top;
    TabSheet2.TabVisible:=BOff;
    TabSheet3.TabVisible:=BOff;

  end
  else
  Begin
    If (Not CISOn) then
    Begin
      JACISF.Visible:=BOff;
      Label89.Visible:=BOff;

    end
    else
    Begin
      Label89.Caption:='Deduct '+CCCISName^+' Tax';

      // MH 05/06/2009: Removed High/Lost options at DR/FJ request
      If (CurrentCountry=UKCCode) Then
      Begin
        JACISF.Items.Add ('N/A');
        JACISF.Items.Add ('CIS Applicable');
      End // If (CurrentCountry=UKCCode)
      Else
        Set_DefaultCIS(JACISF.Items,BOn,BOn);
    end;

    // PKR. 24/03/2016. ABSEXCH-17383. Deduct RCT Tax field and label not visible if
    //  country is Ireland and the RCT Gateway is installed.
    Label89.Visible := (Label89.Visible) and (CurrentCountry <> IECCode);
    JACISF.Visible := label89.Visible;

    Label87.Visible:=JAPOn;
    JARevTF.Visible:=JAPOn;
    TabSheet2.TabVisible:=JAPOn;
    TabSheet3.TabVisible:=JAPOn;

    If (JAPOn) then
    Begin
      Set_DefaultJADed(JAADCB.ITems,BOn,BOff);

      JAADCB.ItemIndex:=0;

      Set_DefaultJARet(JARTCB.ITems,BOff,BOff);

      JARTCB.ItemIndex:=0;
    end;

  end;
end;



procedure TJCAnlI1.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=287;
  ClientWidth:=401;

  InOutId:=BOff;

  JTMode:=SetJTMode;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TJAnalList) then
    With TJAnalList(Owner) do
      Self.SetFieldProperties(TLAccPanel);

  With PageControl1 do
  If (Pages[0].TabVisible) then
    ActivePage:=Pages[0];

  BuildDesign;

end;




procedure TJCAnlI1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,100+Ord(JTMode));

end;

procedure TJCAnlI1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TJCAnlI1.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TJCAnlI1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TJCAnlI1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Procedure TJCAnlI1.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);


    end; {Case..}

  end;
  Inherited;
end;



{ == Procedure to Send Message to Get Record == }

Procedure TJCAnlI1.Send_UpdateList(Edit   :  Boolean;
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



Function TJCAnlI1.CheckNeedStore  :  Boolean;

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


Procedure TJCAnlI1.SetFieldFocus;

Begin
  CSStkCode.SetFocus;

end; {Proc..}





Function TJCAnlI1.ConfirmQuit  :  Boolean;

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
                StoreId(JMiscF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(JMiscF,LastRecAddr[JMiscF]);

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

Procedure TJCAnlI1.SetDeductTab;

Begin
  {$IFDEF JAP}
    TabSheet2.TabVisible:=(JAPOn and ((JCCats_TxLate(Succ(JACCB.ItemIndex),BOn)=SysDeductSales) or (JACCB.ItemIndex=Pred(SysDeductPurch))));
    TabSheet3.TabVisible:=(JAPOn and (JCCats_TxLate(Succ(JACCB.ItemIndex),BOn) In [9,10])); {Retention only available for rention type analysis codes}
  {$ENDIF}
end;


Procedure TJCAnlI1.OutId;


Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  n         :  Byte;

  KeyS      :  Str255;


Begin
  InOutId:=BOn;

  SetCaption;

  With ExLocal,LJobMisc^,JobAnalRec do
  Begin
    csStkCode.Text:=Trim(JAnalCode);
    JADF.Text:=JAnalName;

    If (Not JTMode) then
    Begin
      If (JAType>0) then
        JATCB.ItemIndex:=Pred(JAType);

      If (AnalHed>0) then
        JACCB.ItemIndex:=Pred(JCCats_TxLate(AnalHed,BOff));

      JAWF.Text:=Form_BInt(WIPNom[BOn],0);
      JAPF.Text:=Form_BInt(WIPNom[BOff],0);

//      If (JLinkLT>=0) then
        SRLTF.ItemIndex:=JLinkLT;


      If (CISOn) then
      Begin
        // MH 05/06/2009: Removed High/Lost options at DR/FJ request
        If (CurrentCountry=UKCCode) Then
          JACISF.ItemIndex:=IfThen(CISTaxRate=C0,0,1)
        Else
          JACISF.ItemIndex:=GetCISCIndex(CISTaxRate);
      End; // If (CISOn)

      If (RevenueType>0) then
        JARevTF.ItemIndex:=JCCats_TxLate(RevenueType,BOff)-3
      else
        JARevTF.ItemIndex:=0;

      JAUPCF.Value:=Pcnt2Full(UpliftP);

      JAUCF.Text:=Form_BInt(UpliftGL,0);

//      If (JADetType>=0) then
        JAPTCB.ItemIndex:=JADetType;

      JACRCB.Checked:=JACalcB4Ret;

      JADedF.Value:=JADeduct;

//      If (JADedApply>=0) then
        JAADCB.ItemIndex:=JADedApply;

//      If (JARetType>=0) then
        JARTCB.ItemIndex:=JARetType;

      JARVF.Value:=JARetValue;

//      If (JARetExp>=0) then
        JAECB.ItemIndex:=JARetExp;

      JAEIF.Value:=JARetExpInt;

      JARCYCB.Checked:=JARetPres;

      JACompCB.ItemIndex:=JADedComp;

      If (JARevTF.Visible) then
        JARevTFEnter(nil);

      JAPCF.Text:=JAPayCode;

      JAECBChange(Nil);
      JACompCBChange(Nil);
    end;
  end;

  SetDeductTab;

  InOutId:=BOff;

end;


procedure TJCAnlI1.Form2Id;


Begin

  With ExLocal,LJobMisc^ do
  Begin
    If (Not JTMode) then
    With JobAnalRec do
    Begin
      JAnalCode:=FullJACode(csStkCode.Text);

      JAnalName:=JADF.Text;

      JAType:=Succ(JATCB.ItemIndex);

      AnalHed:=JCCats_TxLate(Succ(JACCB.ItemIndex),BOn);

      WIPNom[BOn]:=IntStr(JAWF.Text);
      WIPNom[BOff]:=IntStr(JAPF.Text);


      JLinkLT:=SRLTF.ItemIndex;

      If (CISOn) then
        With JACISF do
          If (ItemIndex > 0) Then
          Begin
            If (CurrentCountry = UKCCode) Then
              CISTaxRate := 'C'
            Else
              CISTaxRate := Items[ItemIndex][1]
          End // If (ItemIndex > 0)
          Else
            CISTaxRate:=C0;

      If (JARevTF.ItemIndex>0) and (AnalHed=1) then
        RevenueType:=JCCats_TxLate(JARevTF.ItemIndex+3,BOn)
      else
        RevenueType:=0;


      UpliftP:=Pcnt(JAUPCF.Value);

      If (UpLiftP<>0.0) then
      Begin
        UpliftGL:=IntStr(JAUCF.Text);
      end
      else
      Begin
        UpliftGL:=0;

      end;

      If (JAPTCB.ItemIndex>=0) then
        JADetType:=JAPTCB.ItemIndex;

      JACalcB4Ret:=JACRCB.Checked;

      JADeduct:=JADedF.Value;

      If (JAADCB.ItemIndex>=0) then
        JADedApply:=JAADCB.ItemIndex;

      If (JARTCB.ItemIndex>=0) then
        JARetType:=JARTCB.ItemIndex;

      JARetValue:=JARVF.Value;

      If (JAECB.ItemIndex>=0) then
        JARetExp:=JAECB.ItemIndex;

      JARetPres:=JARCYCB.Checked;

      JARetExpInt:=Round(JAEIF.Value);

      If (JACompCB.ItemIndex>=0) then
        JADedComp:=JACompCB.ItemIndex;

      JAPayCode:=JAPCF.Text;

    end
    else
    With JobTypeRec do
    Begin
      JobType:=FullJACode(csStkCode.Text);
      JTypeName:=JADF.Text;

    end;
  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TJCAnlI1.ProcessId(Fnum,
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
  With ExLocal,LJobMisc^,JobAnalRec,JobTypeRec do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPfix:=JARCode;
      Subtype:=JASubAry[2-Ord(JTMode)];

      If (Not JTMode) then
      Begin
        JAtype:=1; AnalHed:=2;
      end;

    end;

    LastJobMisc^:=LJobMisc^;

    OutId;

  end {If Abort..}
  else
    Close;

end; {Proc..}



Function TJCAnlI1.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  9;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  Test     :  Byte;

  n,
  mbRet    :  Word;

  FoundCode:  Str20;

  FoundLong:  LongInt;


Begin
  New(PossMsg);

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That Analysis code is not valid.';
  PossMsg^[2]:='That Job Type code is not valid.';
  PossMsg^[3]:='That WIP G/L code is not valid.';
  PossMsg^[4]:='That P&&L G/L code is not valid.';
  PossMsg^[5]:='That Analysis Type is not valid.';
  PossMsg^[6]:='That Category Type is not valid.';
  PossMsg^[7]:='The relationship between Analysis Type && Category Type is not valid.';
  PossMsg^[8]:='That Uplift Control G/L code is not valid.';
  PossMsg^[9]:='The Retention expiry basis is not valid.';



  Test:=1;

  Result:=BOn;

  {$B-}

  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LJobMisc^, JobTypeRec, JobAnalRec do
  Begin
    Case Test of

      1  :     If (Not JTMode) then
               Begin
                 Result:=(Not EmptyKey(JAnalCode,AnalKeyLen));

                 If (Result) then
                 Begin
                   If ((Not LastEdit) or (LastJobMisc^.JobAnalRec.JAnalCode<>JAnalCode)) and (InAddEdit) then
                   Begin
                     Result:=Not CheckExsists(FullJAKey(RecPFix,SubType,JAnalCode),JMiscF,JMK);

                   end;

                 end;
               end;


      2  :     If (JTMode) then
               Begin
                 Result:=(Not EmptyKey(JobType,AnalKeyLen));

                 If (Result) then
                 Begin
                   If ((Not LastEdit) or (LastJobMisc^.JobTypeRec.JobType<>JobType)) and (InAddEdit) then
                   Begin
                     Result:=Not CheckExsists(FullJAKey(RecPFix,SubType,JobType),JMiscF,JMK);

                   end;

                 end;
               end;

       3,4
          :  If (Not JTMode) then
             Begin
               Result:=(WIPNom[(Test=4)]<>0) and (GetNom(Self,Form_Int(WIPNom[(Test=4)],0),FoundLong,-1));
             end;


       5  :  Result:=(JTMode) or ((JAType >=Low(JobXDesc^)) and (JAType<=High(JobXDesc^)));
       6  :  Result:=(JTMode) or ((AnalHed >=1) and (JAType<=NofSysAnals));

       7  :  Result:=(JTMode) or (ChkRtRelate(BOn,JAType,AnalHed));

       8
          :  If (Not JTMode) then
             Begin
               {$B-}
               Result:=(UpliftP=0.0) or ((UpliftGL<>0) and (GetNom(Self,Form_Int(UpliftGL,0),FoundLong,-1)));
               {$B+}
             end;

       9  :  Begin
               {$B-}
               Result:=(JARetExp<2) or ((JARetExp=2) and (JARetType=1)) or ((JARetExp=3) and (JARetType=2));
               {$B+}
             end;

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  {$B+}

  If (Not Result) and (Not MainChk) then
    mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}





procedure TJCAnlI1.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk,
  ChkRN
       :  Boolean;

  TmpMLoc
       :  JobMiscRec;

  KeyN,OldCode:  Str255;

  KeyS :  Str255;

  mbRet:  Word;




Begin
  KeyS:='';

  Form2Id;


  ChkRN:=BOff;

  With ExLocal,LJobMisc^,JobAnalRec do
  Begin
    If (JTMode) then
    Begin
      ChkRN:=(LastJobMisc^.JobTypeRec.JobType<>JobTypeRec.JobType) and (LastEdit);

      If (ChkRN) then
        KeyS:=LastJobMisc^.JobTypeRec.JobType;
    end
    else
    Begin
      ChkRN:=(LastJobMisc^.JobAnalRec.JAnalCode<>JAnalCode) and (LastEdit);

      If (ChkRN) then
        KeyS:=LastJobMisc^.JobAnalRec.JAnalCode;
    end;


    If (ChkRN) then
    Begin
      If (Ent_BeenUsed(1+(1*Ord(Not JTMode)),KeyS)) then
      Begin
        If (JTMode) then
          JobTypeRec.JobType:=LastJobMisc^.JobTypeRec.JobType
        else
          JAnalCode:=LastJobMisc^.JobAnalRec.JAnalCode;

        ShowMessage('It is not possible to change '+Trim(KeyS)+','+#13+'as it is has already been used inside Job Costing.');
      end;
    end;

    COk:=CheckCompleted(LastEdit,BOff);



    If (COk) then
    Begin

      JANameCode:=FullAnalDesc(UpCaseStr(Copy(JAnalName,1,Pred(SizeOf(JANameCode)))));

      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpMLoc:=LJobMisc^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LJobMisc^:=TmpMLoc;

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

      Send_UpdateList(LastEdit,Ord(JTMode));

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TJCAnlI1.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TJCAnlI1.EditLine(Edit       :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ProcessId(JMiscF,JMK,LastEdit);
  end;
end;


procedure TJCAnlI1.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult=mrOk) then
      Begin
        // MH 21/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
        //                                   fields which processes the text and updates the value
        If (ActiveControl <> OkCP1Btn) Then
          // Move focus to OK button to force any OnExit validation to occur
          OkCP1Btn.SetFocus;

        // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
        If (ActiveControl = OkCP1Btn) Then
          StoreId(JMiscF,SKeypath);
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


procedure TJCAnlI1.DeleteBOMLine(Fnum,
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

    MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this record',
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

          Send_UpdateList(BOff,200+Ord(JTMode));


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}





procedure TJCAnlI1.CSStkCodeExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str20;


begin

  If (Sender is TMaskEdit) and (ActiveControl<>CanCP1Btn) then
  With ExLocal,LJobMisc^,JobAnalRec,(Sender as TMaskEdit) do
  Begin
    Text:=UpcaseStr(Text);

    CCode:=FullJACode(Text);

    COK:=BOn;


    If ((Not LastEdit) or (LastJobMisc^.JobAnalRec.JAnalCode<>CCode)) and (InAddEdit) then
    Begin

      If (COk) then
        COk:=(Not Check4DupliGen(FullJAKey(RecPFix,SubType,CCode),JMiscF,JMK,'Code'));

      If (Not COk) then
      Begin

        SetFocus;
      end;

    end;
  end;
end;




procedure TJCAnlI1.JAWFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn)  then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,5));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin


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


procedure TJCAnlI1.JAUCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  AltMod     :  Boolean;

begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn)  and (JAUPCF.Value<>0.0) then
      JAWFExit(Sender);
  end; {With..}
end;


{ ==== Various routines to return and validate the relationship betwix Main Types and Catagories == }

Function GetRtRelate(Many2One  :  Boolean;
                     TL,CatL   :  Byte)  :  RtRecType;


Begin
  FillChar(Result,SizeOf(Result),0);

  With Result do
  Case Many2One of

    BOff  :  Begin
               Case TL of
                 1  :  Begin  {Revenue = Revenue,Receipts,Sales Ret,Purch Ret,Deductions Sales Apps, Purc Apps}
                         PossSet:=[1,7,9,10,14,15,16,17];
                         Default:=2;
                       end;
                 2  :  Begin  {Overheads = Disbursments, Non Rec Disb, Overheads,WIP, OverHeads 2}
                         PossSet:=[3,4,6,8,13];
                         Default:=8;
                       end;
                 3  :  Begin  {Materials= Disbursments, Non Rec Disb,,Materials, WIP, Materials 2}
                         PossSet:=[3,4,5,8,12];
                         Default:=6;
                       end;
                 else  Begin  {Labour = Disbursments, Non Rec Disb,Labour , WIP, Sub contrcat labour}
                         PossSet:=[2,3,4,8,11];
                         Default:=2;
                       end;

               end; {Case..}

             end;

    BOn  :  Begin
               Case CatL of
                 1  :  Begin  {Revenue = Revenue}
                         PossSet:=[1];
                         Default:=1;
                       end;
                 2,11
                    :  Begin  {Labour= Labour}
                         PossSet:=[4];
                         Default:=4;
                       end;
                 3  :  Begin  {Disbursments = Overheads,Materials,Labour}
                         PossSet:=[2,3,4];
                         Default:=3;
                       end;
                 4  :  Begin  {Non Rec Disb= Overheads,Materials,Labour}
                         PossSet:=[2,3,4];
                         Default:=2;
                       end;
                 5,12
                    :  Begin  {Materials=Materials}
                         PossSet:=[3];
                         Default:=3;
                       end;
                 6,13
                    :  Begin  {Overheads=Overheads}
                         PossSet:=[2];
                         Default:=2;
                       end;
                 7  :  Begin  {Receipts=Revenue}
                         PossSet:=[1];
                         Default:=1;
                       end;

                 8  :  Begin  {WIP=Overheads, Materials,Labour}
                         PossSet:=[2,3,4];
                         Default:=3;
                       end;

                 9  :  Begin  {Sales Ret=Revenue}
                         PossSet:=[1];
                         Default:=1;
                       end;

                 else  Begin  {Purch Ret, Deductions, Apps =Revenue}
                         PossSet:=[1];
                         Default:=1;
                       end;

               end; {Case..}

             end;
  end; {Case..}
end;

Function TJCAnlI1.ChkRtRelate(Many2One  :  Boolean;
                              TL,CatL   :  Byte)  :  Boolean;
Begin
  Result := False;
  With GetRtRelate(Many2One,TL,CatL) do
  Begin
    Case Many2One of
      BOff  :  Result:=CatL In PossSet;
      BOn   :  Result:=TL In PossSet;
    end; {{case..}
  end;
end;

Function TJCAnlI1.GetRtRelateDef(Many2One  :  Boolean;
                                 TL,CatL   :  Byte)  :  Byte;

Begin
  Result:=GetRtRelate(Many2One,TL,CatL).Default;
end;



procedure TJCAnlI1.JATCBChange(Sender: TObject);
begin
  If (Not InOutId) and (ExLocal.InAddEdit) then
  Begin
    JACCB.ItemIndex:=Pred(GetRtRelateDef(BOff,Succ(JATCB.ItemIndex),0));

    JARevTFEnter(Sender);

    If (JACISF.Visible) then
    Begin

      If (CurrentCountry<>IECCode) then
      If ((JATCB.ItemIndex In [1,3]) and (CurrentCountry<>IECCode)) or ((JATCB.ItemIndex>0) and (CurrentCountry=IECCode)) and (CISOn) then
        JACISF.ItemIndex:=1
      else
        JACISF.ItemIndex:=0;
    end;
  end;
end;

procedure TJCAnlI1.JARevTFEnter(Sender: TObject);
begin
  If (ExLocal.InAddEdit) then
  Begin
    If (JARevTF.Visible) then
    Begin
      JARevTF.Enabled:=(JACCB.ItemIndex=1);

      If (Not JARevTF.Enabled) then
        JARevTF.ItemIndex:=0;

      Label87.Enabled:=JARevTF.Enabled;
    end;
  end;

  SetDeductTab;
end;

Function TJCAnlI1.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PAgeControl1);

end;

Procedure TJCAnlI1.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TJCAnlI1.PageControl1Change(Sender: TObject);
begin
  If (Sender is TPageControl) then
  With Sender as TPageControl do
  Begin
    LockWindowUpDate(0);




    Case Current_Page of

      0  :  Begin
              Label81.Parent:=SBSPanel1;
              Label86.Parent:=SBSPanel1;

              Label81.Top:=12;

              With CSStkCode do
              Begin
                Top:=9;
                Left:=JATCB.Left;
                Parent:=SBSPanel1;
                TabOrder:=1;
                TabStop:=BOn;
                ReadOnly:=BOff;
                Color:=JATCB.Color;
                Font.Color:=JATCB.Font.Color;
              end;

              With JADF do
              Begin
                Top:=9;
                Parent:=SBSPanel1;
                TabOrder:=2;
                TabStop:=BOn;
                ReadOnly:=BOff;
                Color:=JATCB.Color;
                Font.Color:=JATCB.Font.Color;
              end;

            end;
      else  Begin
              Label81.Top:=20;
              Label81.Parent:=ActivePage;
              Label86.Parent:=ActivePage;


              With CSStkCode do
              Begin
                Top:=17;
                Parent:=ActivePage;
                Left:=JARTCB.Left;
                TabStop:=BOff;
                ReadOnly:=BOn;
                Color:=clBtnFace;
                Font.Color:=clBlack;
              end;

              With JADF do
              Begin
                Top:=17;
                Parent:=ActivePage;
                TabStop:=BOff;
                ReadOnly:=BOn;
                Color:=clBtnFace;
                Font.Color:=clBlack;

              end;

            end;

    end; {Case..}


    Label86.Top:=Label81.Top;

  end;

end;

procedure TJCAnlI1.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);
  end;
end;

procedure TJCAnlI1.JAECBChange(Sender: TObject);
begin
  If (ExLocal.InAddEdit) then
  Begin
    JAEIF.Enabled:=(JAECB.ItemIndex<2);

    If (Not JAEIF.Enabled) then
      JAEIF.Value:=0.0;
  end;

end;

procedure TJCAnlI1.JAPTCBChange(Sender: TObject);
begin
  If (JAPTCB.ItemIndex=0) then
    JADedF.DisplayFormat:=GenPcnt2dMask
  else
    JADedF.DisplayFormat:=GenUnitMask[(JCCats_TxLate(Succ(JACCB.ItemIndex),BOn)=SysDeductSales)];
end;

procedure TJCAnlI1.JACompCBChange(Sender: TObject);
begin
  If (ExLocal.InAddEdit) then
  Begin
    JAADCB.Enabled:=(JACompCB.ItemIndex=0);

    If (Not JAADCB.Enabled) then
      JAADCB.ItemIndex:=0;

    JAPTCB.Enabled:=JAADCB.Enabled;

    If (Not JAPTCB.Enabled) then
      If (JACompCB.ItemIndex=1) then
        JAPTCB.ItemIndex:=0
      else
      Begin
        JAPTCB.ItemIndex:=1;
        JAPTCBChange(Sender);
      end;

    JADedF.Enabled:=(JACompCB.ItemIndex<>2);

    {JACRCb.Enabled:=JADedF.Enabled;}
    JACRCb.Enabled:=JADedF.Enabled and (JACompCB.ItemIndex=0); 

    JARCYCb.Enabled:=JADedF.Enabled;

    If (Not JACRCb.Enabled) then
      JACRCB.Checked:=BOff;

    If (Not JADedF.Enabled) then
    Begin
      JADedF.Value:=0.0;
      JARCYCb.Checked:=BOff;
    end;

  end;


end;

procedure TJCAnlI1.JARTCBChange(Sender: TObject);
begin
  If (Not InOutId) and (ExLocal.InAddEdit) then
  Begin
    If (JARTCB.ItemIndex In [1,2]) then
    Begin
      JAECB.ItemIndex:=Succ(JARTCB.ItemIndex);

    end;
  end;
end;

Initialization

  SetJTMode:=BOff;

end.
