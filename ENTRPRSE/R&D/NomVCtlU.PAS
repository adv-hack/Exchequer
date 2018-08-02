unit NomVCtlU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, BorBtns,BarGU,
  GlobVar,VarConst,ExWrap1U,CmpCtrlU,SBSOutL, BTSupU1,bkgroup;


type
  TNomVCtlRec = class(TForm)
    NIPF: TBorCheck;
    NIDF: Text8Pt;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    SBSPanel1: TSBSBackGroup;
    SBSBackGroup1: TSBSBackGroup;
    Label86: Label8;
    NICF: TCurrencyEdit;
    A1CCF: Text8Pt;
    CCLab: Label8;
    A1DpF: Text8Pt;
    DepLab: Label8;
    Label810: Label8;
    NIICF: TBorCheck;
    Label82: Label8;
    Period: TSBSComboBox;
    Label81: Label8;
    ToPeriod: TSBSComboBox;
    Label83: Label8;
    Year: TSBSComboBox;
    YTDChk: TBorCheck;
    NCurrLab: Label8;
    Currency: TSBSComboBox;
    TxLateChk: TBorCheck;
    NIIUF: TBorCheck;
    Label85: Label8;
    NIAFCB: TBorCheck;
    SBSBackGroup2: TSBSBackGroup;
    Label84: Label8;
    I1TransDateF: TEditDate;
    I2PrYrF: TEditPeriod;
    NOpoF: Text8Pt;
    Label87: Label8;
    NSysDFCB: TBorCheck;
    NIUCB: TSBSComboBox;
    VRunNoF: Text8Pt;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure NICFExit(Sender: TObject);
    procedure NIFJCFClick(Sender: TObject);
    procedure NIVNFExit(Sender: TObject);
    procedure A1CCFExit(Sender: TObject);
    procedure YTDChkClick(Sender: TObject);
    procedure NIICFClick(Sender: TObject);
    procedure NIUCBChange(Sender: TObject);
    procedure PeriodExit(Sender: TObject);
    procedure PeriodKeyPress(Sender: TObject; var Key: Char);
  private
    CanDelete,
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;
    NITLastValue:  LongInt;

    Progress     :  TBarP;


    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Procedure SetCaption;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Procedure HideFieldsxType;

    Procedure OutId;

    procedure Form2Id;

    procedure Copy_ViewCtrl(Fnum   :  Integer;
                            NewIdx :  LongInt);

    Procedure Change_Details(Renumb  :  Boolean);

    Procedure StartChange;

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    GenCopy    :  Boolean;

    Copy_View,
    Level_View,
    Level_Code :  LongInt;

    ExLocal    :  TdExLocal;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSOutLineB) ;

    procedure EditLine(RNomView   :  NomViewRec;
                       Edit       :  Boolean);


    procedure DeleteNomLine(Fnum,
                            KeyPath  :  Integer);

  end;


  Procedure BuildViewCtrl_Ndx(ExLocal      :  TdExLocal);

  Function Get_GLViewCtrlRec(VN  :  LongInt)  :  ViewCtrlType;



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
  CurrncyU,
  ComnUnit,
  ComnU2,


  ColCtrlU,

  SysU2,
  MiscU,
  PWarnU,
  NomView1,
  NomVRecU,
  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  PayF2U,

  {PayLineU,}

  ThemeFix,
  
  ExThrd2U,
  SysU1,
  Saltxl1U;




{$R *.DFM}




{ == Proc to build all the Views indexes == }

Procedure BuildViewCtrl_Ndx(ExLocal      :  TdExLocal);

Begin
  With ExLocal,LNomView^.ViewCtrl do
  Begin
    VCCode1:=FullNVIdx(#0,#0,0,ViewCtrlNo,BOff);
  end;
end;

{ == Function to Get next View No. == }

Function Get_NextViewCtrlIdx(Var ExLocal      :  TdExLocal;
                                 Fnum2,KPath  :  Integer;
                                 Level_View   :  LongInt) :  LongInt;

Var
  TmpRecAddr,
  TmpKPath :  LongInt;

  TmpStat  :  Integer;

  KeySChk,
  KeySC    :  Str255;

  TmpNV    :  NomViewRec;

Begin
  Result:=1;

  With ExLocal do
  Begin
    TmpNV:=LNomView^;

    TmpKPath:=KPath;

    TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOff,BOff);

    KeySChk:=NVRCode+NVCSCode;

    KeySC:=KeySChk+Dec2Hex(65535);

    Status:=Find_Rec(B_GetLessEq,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,NVCodeK,KeySC);

    If (StatusOk) and (CheckKey(KeySChk,KeySC,Length(KeySChk),BOff))  then
      Result:=LNomView^.ViewCtrl.ViewCtrlNo+1;

    TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOn,BOff);

    LNomView^:=TmpNV;
  end;


end;


{ == Function to Return View Ctrl Record based on view number == }

Function Get_GLViewCtrlRec(VN  :  LongInt)  :  ViewCtrlType;

Const
  Fnum    =  NomViewF;
  Keypath =  NVCodeK;

Var
  KeyS  :  Str255;

Begin
  KeyS:=FullNVIdx(NVRCode,NVCSCode,0,VN,BOn);

  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  If (StatusOk) then
  Begin
    Result:=NomView^.ViewCtrl;
    Result.LoadedOk:=BOn;
  end
  else
    Blank(Result,Sizeof(Result));

end;



{ ========== Build runtime view ======== }

procedure TNomVCtlRec.BuildDesign;


begin


end;


procedure TNomVCtlRec.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin
  NIDF.MaxLength:=NomDesLen;

  If (Not Syss.UseCCDep) then
  Begin
    CCLab.Visible:=BOff;
    DepLab.Visible:=BOff;
    A1CCF.Visible:=BOff;
    A1DpF.Visible:=BOff;

  end;

  {$IFNDEF SOP}
    NIICF.Visible:=BOff;

  {$ELSE}
    NIICF.Visible:=CommitAct;
  {$ENDIF}

  {$IFDEF MC_On}

    Set_DefaultCurr(Currency.Items,BOn,BOff);
    Set_DefaultCurr(Currency.ItemsL,BOn,BOn);

  {$ELSE}

   NCurrLab.Visible:=BOff;
   Currency.Visible:=BOff;
   TxLateChk.Visible:=BOff;

  {$ENDIF}

  Set_DefaultPr(Period.Items);

  Period.ItemIndex:=Pred(GetLocalPr(0).CPr);

  Set_DefaultPr(ToPeriod.Items);

  ToPeriod.ItemIndex:=Pred(GetLocalPr(0).CPr);


  Set_DefaultYr(Year.Items,GetLocalPr(0).CYr);


  BuildDesign;

end;



Procedure TNomVCtlRec.SetCaption;

Begin
  With ExLocal,LNomView^.ViewCtrl do
  Begin
    Caption:='General Ledger View Control Record - '+dbFormatName(Form_Int(ViewCtrlNo,0),ViewDesc)+'. ';
  end;
end;


procedure TNomVCtlRec.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=277;
  ClientWidth:=372;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TNViews) then
    With TNViews(Owner) do
      Self.SetFieldProperties(NLOLine);

  FormDesign;

  GenCopy:=BOff;  Copy_View:=0;

  CanDelete:=BOn;

end;




procedure TNomVCtlRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,101);

end;

procedure TNomVCtlRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TNomVCtlRec.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TNomVCtlRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TNomVCtlRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TNomVCtlRec.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      38  :  If (GenCopy) then
               Copy_ViewCtrl(NomViewF,ExLocal.LNomView^.ViewCtrl.ViewCtrlNo)
             else
               With ExLocal do
                 Change_Details(LNomView^.ViewCtrl.ViewCtrlNo<>LastNomView^.ViewCtrl.ViewCtrlNo);

    end; {Case..}

  end;
  Inherited;
end;


Procedure TNomVCtlRec.Send_UpdateList(Edit   :  Boolean;
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



Function TNomVCtlRec.CheckNeedStore  :  Boolean;

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


Procedure TNomVCtlRec.SetFieldFocus;

Begin
  If (CanDelete) and (NICF.CanFocus) then
  Begin
    NICF.SetFocus
  end
  else
  Begin
    If (NIDF.CanFocus) then
      NIDF.SetFocus;
  end;

end; {Proc..}




Function TNomVCtlRec.ConfirmQuit  :  Boolean;

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
                StoreId(NomViewF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(NomViewF,LastRecAddr[NomViewF]);


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


Procedure TNomVCtlRec.HideFieldsxType;
Var
  ShowField,
  DefSet     :  Boolean;
Begin
  ShowField:=Not NIAFCb.Checked;
  DefSet:=Not NSysDFCb.Checked;

  NICF.Enabled:=ShowField;

  NIDF.Enabled:=ShowField;
  NSysDFCb.Enabled:=ShowField;

  Period.Enabled:=ShowField and DefSet;
  ToPeriod.Enabled:=Period.Enabled and (Not YTDChk.Checked);
  Year.Enabled:=Period.Enabled;
  YTDChk.Enabled:=Period.Enabled;


  A1CCF.Enabled:=ShowField;
  A1DpF.Enabled:=ShowField;
  Currency.Enabled:=ShowField;
  TxLateChk.Enabled:=ShowField;

  {$IFDEF SOP}
    NIICF.Visible:=ShowField and CommitAct;

    NIICF.Enabled:=(NIUCB.ITemIndex=0);

    NIUCB.Enabled:=Not NIICF.Checked;
  {$ELSE}
    NIICF.Visible:=BOff;
  {$ENDIF}
  
  NIPf.Visible:=ShowField;
  {NICF.Enabled:=ShowField;}
  NIIUF.Visible:=BOff;


end;



{ ============== Display Id Record ============ }

Procedure TNomVCtlRec.OutId;


Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  FoundLong :  Integer;

  KeyS      :  Str255;


Begin
  With ExLocal,LNomView^.ViewCtrl do
  Begin

    NICF.Value:=ViewCtrlNo;
    A1CCF.Text:=LinkCCDep[BOn];
    A1DpF.Text:=LinkCCDep[BOff];
    NIPf.Checked:=IncBudget;
    NIUCB.ItemIndex:=IncUnposted;
    NIDF.Text:=Trim(ViewDesc);
    NIICF.Checked:=IncCommit;

    NIIUF.Checked:=AutoStruct;
    NIAFCB.Checked:=Inactive;

    Period.ItemIndex:=Pred(DefPeriod);
    ToPeriod.ItemIndex:=Pred(DefPeriodTo);

    Year.ItemIndex:=Pred(DefYear);

    I2PrYrF.InitPeriod(LastPeriod,LastYear,BOn,BOn);
    I1TransDateF.DateValue:=LastUpdate;

    YTDChk.Checked:=DefYTD;

    NOpoF.Text:=Trim(LastOpo);

    VRunNoF.Text:=Form_Int(LastPRunNo,0);

    NSysDFCB.Checked:=DefUseF6;

    If (LastPRunNo<>Pred(GetNextCount(RUN,BOff,BOff,0))) and (LastPRunNo<>0) then
    Begin
      Label84.Font.Color:=clRed;

    end
    else
    Begin
      Label84.Font.Color:=clBlack;

    end;

    Label87.Font.Color:=Label84.Font.Color;


    {$IFDEF MC_On}
      Currency.ItemIndex:=DefCurr;
      TxLateChk.Checked:=DefCurrTx;
    {$ENDIF}

  end;

end;


procedure TNomVCtlRec.Form2Id;

Begin

  With EXLocal.LNomView^.ViewCtrl do
  Begin

    ViewCtrlNo:=Trunc(NICF.Value);

    LinkCCDep[BOn]:=Trim(A1CCF.Text);
    LinkCCDep[BOff]:=Trim(A1DpF.Text);

    IncBudget:=NIPf.Checked;
    AutoStruct:=NIIUF.Checked;
    ViewDesc:=NIDF.Text;

    IncCommit:=NIICF.Checked;

    Inactive:=NIAFCb.Checked;

    IncUnposted:=NIUCB.ItemIndex;
    
    DefUseF6:=NSysDFCB.Checked;

    DefPeriod:=Succ(Period.ItemIndex);
    DefPeriodTo:=Succ(ToPeriod.ItemIndex);
    DefYear:=Succ(Year.ItemIndex);

    DefYTD:=YTDChk.Checked;

    {$IFDEF MC_On}
      If (Currency.ItemIndex>-1) then
        DefCurr:=Currency.ItemIndex
      else
        DefCurr:=0;
        
      DefCurrTx:=TxLateChk.Checked;
    {$ENDIF}

  end; {with..}

end; {Proc..}



procedure TNomVCtlRec.SetIdStore(EnabFlag,
                             VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode;

  OkCP1Btn.Enabled:=Not VOMode;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    Begin
      If (Text8Pt(Components[Loop]).Tag=1) then
        Text8Pt(Components[Loop]).ReadOnly:= VOMode;
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



(*  Add is used to add Notes *)

procedure TNomVCtlRec.ProcessId(Fnum,
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

    SetCaption;

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
  With ExLocal,LNomView^,ViewCtrl do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPFix:=NVRCode;
      SubType:=NVCSCode;

      

      If (GenCopy) then
      Begin
        ViewCtrl:=LastNomView^.ViewCtrl;
        LastPeriod:=0;
        LastYear:=0;
        Blank(LastUpdate,Sizeof(LastUpdate));
        LastPRunNo:=0;
        Blank(LastOpo,Sizeof(LastOpo));

        Copy_View:=ViewCtrlNo;
      end
      else
      Begin
        YTDChk.Checked:=BOn;

        IndexLInt:=1;

        DefUseF6:=BOn;
      end;

      ViewCtrlNo:=Get_NextViewCtrlIdx(ExLocal,Fnum,KeyPath,Level_View);

      CanDelete:=BOn;

      NIFJCFClick(Nil);

    end
    else
      CanDelete:=BOn;



    LastNomView^:=LNomView^;

    OutId;

    SetIdStore(BOn,ExLocal.LViewOnly);

    If (Edit) then
    Begin
      CanDelete:=Not CheckExsists(Strip('R',[#0],PrimeNVCode(NVRCode,NVVSCode,ViewCtrlNo,BOn)),Fnum,Keypath);

      If (Not CanDelete) then
      Begin
        NICf.Enabled:=BOff;
      end;

      HideFieldsxType;
    end;

    SetFieldFocus;

  end; {If Abort..}

end; {Proc..}




Function TNomVCtlRec.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  4;
  Fnum         =  NomViewF;
  Keypath      =  NVCodeK;


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

  PossMsg^[1]:='That View No. already exists.';
  PossMsg^[2]:='That View Code is not valid.';
  PossMsg^[3]:='That View Account Type is not valid.';
  PossMsg^[4]:='That default period is not valid.';

  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LNomView^,ViewCtrl do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              If (Not Edit) then
                Result:=Not (CheckExsists(Strip('R',[#0],FullNVIdx(RecPFix,SubType,0,ViewCtrlNo,BOn)),Fnum,Keypath))
              else
                Result:=BOn;
            end;

      2  :  Result:=(ViewCtrlNo<>0);

      {3  :  If (LastNom.NomType<>NomType) then
              Result:=NomGood_Type(NomType,CanDelete) and NomGood_Type2(NomType,CAT);}

      4  :  Result:=(DefUseF6) or ((DefPeriod<>0) and (DefPeriodTo<>0) and (DefYear<>0));

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}



{ == Procedure to copy an existing G/L view == }

procedure TNomVCtlRec.Copy_ViewCtrl(Fnum   :  Integer;
                                    NewIdx :  LongInt);

Const
  Keypath  =  NVCodeK;

Var
  RecAddr,
  TmpRecAddr,
  PurgeCount,
  TmpKPath :  LongInt;

  TmpStat  :  Integer;

  TmpNomView
           :  NomViewRec;

  KeyS,
  KeyChk   :  Str255;


Begin
  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  KeyChk:=PrimeNVCode(NVRCode,NVVSCode,Copy_View,BOn);

  KeyS:=KeyChk;


  Try
    With ExLocal do
    Begin

      TmpNomView:=LNomView^;

      PurgeCount:=0;
      Progress.CanCP1Btn.Visible:=BOn;

      Progress.Gauge1.MaxValue:=Used_Recs(F[Fnum],Fnum);

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Progress.KeyR<>mrAbort) do
      With LNomView^,NomViewLine do
      Begin
        Application.ProcessMessages;

        Inc(PurgeCount);

        Progress.Gauge1.Progress:=PurgeCount;

        LGetRecAddr(Fnum);

        NomViewNo:=NewIdx;

        LinkCCDep:=TmpNomView.ViewCtrl.LinkCCDep;
        IncBudget:=TmpNomView.ViewCtrl.IncBudget;
        IncCommit:=TmpNomView.ViewCtrl.IncCommit;
        IncUnposted:=TmpNomView.ViewCtrl.IncUnposted;

        BuildView_Ndx(ExLocal);

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        Report_BError(Fnum,Status);

        LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

        Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

        If (StatusOk) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);

      end;

      Progress.Gauge1.Progress:=Used_Recs(F[Fnum],Fnum);
    end; {With..}
  finally
    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    ExLocal.LNomView^:=TmpNomView;

    Progress.ShutDown;

  end; {Try..}

end;





Procedure TNomVCtlRec.Change_Details(Renumb  :  Boolean);

Const
  Fnum   =  NomViewF;
  Keypath=  NVCodeK;

Var
  RecAddr,
  TmpRecAddr,
  PurgeCount,
  TmpKPath :  LongInt;

  B_Func,
  TmpStat  :  Integer;

  KeyS,
  KeyChk  :  Str255;

  VCtrl   :  ViewCtrlType;

  TmpNomView
          :  NomViewRec;


Procedure Renum_NomViewActualHist;



Const
  FnumH     =  NHistF;

  KeypathH  =  NHK;



Var
  KeySH,
  KeyChkH   :  Str255;



Begin

  With ExLocal,LNomView^.NomViewLine do
  Begin
    KeyChkH:=ViewType+PostNVIdx(LastNomView^.ViewCtrl.ViewCtrlNo,ABSViewIdx);

    KeySH:=KeyChkH;

    Status:=Find_Rec(B_GetGEq,F[FnumH],FnumH,LRecPtr[FnumH]^,KeypathH,KeySH);


    While (StatusOk) and (CheckKey(KeyChkH,KeySH,Pred(Length(KeyChkH)),BOn)) and (Progress.KeyR<>mrAbort)  do
    With LNHist do
    Begin
      Application.ProcessMessages;

      Code:=PostNVIdx(NomViewNo,ABSViewIdx);

      Status:=Put_Rec(F[FnumH],FnumH,LRecPtr[FnumH]^,KeyPAthH);

      Report_BError(FnumH,Status);

      If (StatusOk) then
        Status:=Find_Rec(B_GetGEq,F[FnumH],FnumH,LRecPtr[FnumH]^,KeypathH,KeySH);

    end; {While..}
  end; {With..}
end; {Proc..}

Begin
  With ExLocal do
  Begin
    VCtrl:=LNomView^.ViewCtrl;  B_Func:=B_GetNext;

    If (Renumb) then
      KeyChk:=PrimeNVCode(NVRCode,NVVSCode,LastNomView^.ViewCtrl.ViewCtrlNo,BOn)
    else
      KeyChk:=PrimeNVCode(NVRCode,NVVSCode,VCtrl.ViewCtrlNo,BOn);

    KeyS:=KeyChk;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    Try
    Begin
      TmpNomView:=LNomView^;

      PurgeCount:=0;
      Progress.CanCP1Btn.Visible:=BOn;

      Progress.Gauge1.MaxValue:=Used_Recs(F[Fnum],Fnum);

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);



      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Progress.KeyR<>mrAbort) do
      With LNomView^,NomViewLine do
      Begin
        Application.ProcessMessages;

        Inc(PurgeCount);

        Progress.Gauge1.Progress:=PurgeCount;

        LinkCCDep:=VCtrl.LinkCCDep;
        IncBudget:=VCtrl.IncBudget;
        IncCommit:=VCtrl.IncCommit;
        IncUnposted:=VCtrl.IncUnposted;

        If (Renumb) and (NomViewNo<>VCtrl.ViewCtrlNo) then
        Begin
          NomViewNo:=VCtrl.ViewCtrlNo;
          BuildView_Ndx(ExLocal);
        end
        else
          B_Func:=B_GetNext;


        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        Report_BError(Fnum,Status);

        If (StatusOk) and (Renumb) then
        Begin
          B_Func:=B_GetGEq;
          Renum_NomViewActualHist;
        end
        else
          B_Func:=B_GetNext;

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);


      end;

      Progress.Gauge1.Progress:=Used_Recs(F[Fnum],Fnum);

    end;
    finally
      Progress.ShutDown;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      ExLocal.LNomView^:=TmpNomView;
    end; {Try..}

  end;
end;

Procedure TNomVCtlRec.StartChange;

begin
  Progress:=TBarP.Create(Self);

  try

    Progress.Caption:='Changing Defaults';

    Set_BackThreadMVisible(BOn);


    Progress.ShowModal;

  finally

    Progress.Free;

    Set_BackThreadMVisible(BOff);

  end;
end;


procedure TNomVCtlRec.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpNomView
       :  NomViewRec;

  KeyS :  Str255;

  NewNType
       :  Char;

  mbRet:  Word;



Begin
  KeyS:='';    NewNType:=#0;

  Form2Id;


  With ExLocal,LNomView^,ViewCtrl do
  Begin
    If (LastEdit) and (LastNomView^.ViewCtrl.ViewCtrlNo<>ViewCtrlNo) then
    Begin
      COk:=(Not Check4DupliGen(FullNVIdx(RecPFix,SubType,0,ViewCtrlNo,BOn),Fnum,Keypath,'View Control'));
    end
    else
      COk:=BOn;


    If (COk) then
      COk:=CheckCompleted(LastEdit,BOff);


    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      BuildViewCtrl_Ndx(ExLocal);

      If (LastEdit) then
      Begin


        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpNomView:=LNomView^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LNomView^:=TmpNomView;

        end;


        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end
      else
      Begin

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end;

      Report_BError(Fnum,Status);

      If (StatusOk) then
      Begin
        SetCaption;

        If (GenCopy) then
          StartChange
        else
          If (LastEdit) and ((LastNomView^.ViewCtrl.LinkCCDep[BOn]<>LinkCCDep[BOn]) or (LastNomView^.ViewCtrl.LinkCCDep[BOff]<>LinkCCDep[BOff]) or
                             (LastNomView^.ViewCtrl.IncBudget<>IncBudget) or (LastNomView^.ViewCtrl.IncCommit<>IncCommit) or
                             (LastNomView^.ViewCtrl.IncUnposted<>IncUnPosted) or
                             (LastNomView^.ViewCtrl.ViewCtrlNo<>ViewCtrlNo)) then
        Begin
          If (LastNomView^.ViewCtrl.ViewCtrlNo=ViewCtrlNo) then
            mbRet:=MessageDlg('Apply changes to all View Account Records?.',mtConfirmation,[mbYes,mbNo],0)
          else
            mbRet:=mrYes;

          If (mbRet=mrYes) then
            StartChange;
        end;
      end;

      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      IdStored:=BOn;

      Send_UpdateList(LastEdit and (LastNomView^.ViewCtrl.ViewCtrlNo=ViewCtrlNo),1);

      SetIdStore(BOff,BOff);

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TNomVCtlRec.SetFieldProperties(Field  :  TSBSOutLineB) ;

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


procedure TNomVCtlRec.EditLine(RNomView   :  NomViewRec;
                               Edit       :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    LNomView^:=RNomView;

    If (GenCopy) then
      LastNomView^:=RNomView;

    ProcessId(NomViewF,NVCodeK,LastEdit);
  end;
end;


procedure TNomVCtlRec.DeleteNOMLine(Fnum,
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
        With ExLocal.LNomView^.NomViewLine do
        Begin

          Send_UpdateList(BOff,201);


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}


procedure TNomVCtlRec.CanCP1BtnClick(Sender: TObject);
Begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      StoreId(NomViewF,SKeypath);
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
end; {Proc..}


procedure TNomVCtlRec.NICFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str100;


begin

  If (Sender is Text8pt) then
  With (Sender as TExt8pt),ExLocal,LNomView^ do
  Begin

    If ((Not LastEdit) or (Trim(LastNomView^.NomViewLine.ViewCode)<>Text)) and (InAddEdit) and (Not ReadOnly) and (ActiveControl<>CanCP1Btn) then
    Begin
      CCode:=FullNVCode(RecPFix,SubType,NomViewLine.NomViewNo,Text,BOn);


      COk:=(Not Check4DupliGen(CCode,NomViewF,NVCodeK,'General Ledger View Code ('+Text+')'));

      If (Not COk) then
      Begin

        SetFocus;

      end;

    end;
  end;
end;

procedure TNomVCtlRec.NIVNFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str50;


begin

  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit),ExLocal,LNomView^ do
  Begin

    If ((Not LastEdit) or (LastNomView^.ViewCtrl.ViewCtrlNo<>Value)) and (InAddEdit) and (Not ReadOnly) and (ActiveControl<>CanCP1Btn) then
    Begin
      CCode:=FullNVIdx(RecPFix,SubType,0,Trunc(Value),BOn);


      COk:=(Not Check4DupliGen(CCode,NomViewF,NVCodeK,'General Ledger View Ctrl Number ('+Form_Int(Trunc(Value),0)+')'));

      If (Not COk) then
      Begin

        SetFocus;

      end

    end;
  end;
end;




procedure TNomVCtlRec.NIFJCFClick(Sender: TObject);
begin
  HideFieldsxType;
end;



procedure TNomVCtlRec.A1CCFExit(Sender: TObject);
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

      If (AltMod) and (ActiveControl<>CanCP1Btn) and
          (Syss.UseCCDep)  and (FoundCode<>'') and (Not Has_CCWildChar(FoundCode)) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetCCDep(Self,FoundCode,FoundCode,IsCC,0));


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

procedure TNomVCtlRec.YTDChkClick(Sender: TObject);
begin
  ToPeriod.Enabled:=(Period.Enabled) and (Not YTDChk.Checked);
end;

procedure TNomVCtlRec.NIICFClick(Sender: TObject);
begin
  If (NIICF.Checked) then
  Begin

    NIUCB.ITemIndex:=0;
  end
  else
  Begin


  end;

  NIUCB.Enabled:=Not NIICF.Checked;
end;

procedure TNomVCtlRec.NIUCBChange(Sender: TObject);
begin
  NIICF.Enabled:=(NIUCB.ITemIndex=0);

  If (Not NIICF.Enabled) then
    NIICF.Checked:=BOff;
end;

procedure TNomVCtlRec.PeriodExit(Sender: TObject);
begin
  If (Sender is TSBSComboBox) then
    With TSBSComboBox(Sender) do
    Begin
      If (Sender=Period) or (Sender=ToPeriod) or (Sender=Year) then
      Begin
        If (IntStr(Text)=0) then
        Begin
          ItemIndeX:=0;
          Text:=Items.Strings[0];
        end;

      end;


      If (Sender=Period)  or (Sender=ToPeriod) then
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

    end;
end;

procedure TNomVCtlRec.PeriodKeyPress(Sender: TObject; var Key: Char);
begin
  If (Not (Key In ['0'..'9',#8])) then
    Key:=#0;
end;

end.
