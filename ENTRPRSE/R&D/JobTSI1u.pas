
unit JobTSI1u;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, SBSPanel,

  GlobVar,VarConst,ExWrap1U, ExtCtrls;


type
  TTSLine = class(TForm)
    JCode: Text8Pt;
    Label81: Label8;
    JDesc: Text8Pt;
    Label84: Label8;
    NTCCF: Text8Pt;
    NTDepF: Text8Pt;
    Candb1Btn: TButton;
    Okdb1Btn: TButton;
    Chrge: TCurrencyEdit;
    RtCode: Text8Pt;
    Label82: Label8;
    RtDesc: Text8Pt;
    Label85: Label8;
    Label86: Label8;
    Anal: Text8Pt;
    Hrs: TCurrencyEdit;
    Label87: Label8;
    Label83: Label8;
    RtHr: TCurrencyEdit;
    Label88: Label8;
    TCost: TCurrencyEdit;
    Label89: Label8;
    TotChrge: TCurrencyEdit;
    CoCr: TSBSComboBox;
    ChCr: TSBSComboBox;
    Label811: Label8;
    CCLab: Label8;
    Bevel1: TBevel;
    Bevel2: TBevel;
    NarF: Text8Pt;
    Bevel3: TBevel;
    UDF1L: Label8;
    THUD1F: Text8Pt;
    UDF2L: Label8;
    THUD2F: Text8Pt;
    THUD4F: Text8Pt;
    UDF4L: Label8;
    THUD3F: Text8Pt;
    UDF3L: Label8;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    UDF5L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
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
    procedure RtCodeExit(Sender: TObject);
    procedure HrsExit(Sender: TObject);
    procedure RtCodeEnter(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure SetUDFields(UDDocHed  :  DocTypes);
  private
    { Private declarations }

    VariOn,
    InPassing,
    GenSelect,
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    TSEmplRec   :  JobMiscRec;

    //PR: 20/11/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;
    function TransactionViewOnly : Boolean;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure SetChargeFieldRO(AllowEdit  :  Boolean);

    procedure CheckAnalCode(ACode  :  Str10);

    procedure BuildDesign;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    Procedure OutId;

    procedure Form2Id;


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    Function FindJPRLevel(JCode     :  Str10;
                     Var  UseJCode  :  Str10)  :  Boolean;

    Function Link_TSPayRate(ThisCode  :  Str20;
                            CCode     :  Str10;
                       Var  JCode     :  Str10;
                            Mode,
                            GMode     :  Integer)  :  Boolean;

    Function Get_TSPayRate(ThisCode  :  Str20;
                           CCode     :  Str10;
                           Mode,
                           GMode     :  Integer)  :  Boolean;


  public
    { Public declarations }


    ExLocal    :  TdExLocal;

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

    //PR: 20/11/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;
  end;


Function LineCheckCompleted(IdR  :  IDetail;
                            InvR :  InvRec;
                            Edit,MainChk  :  Boolean;
                        Var ShowMsg :  Boolean;
                            AOwner  :  TWinControl)  : Boolean;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BorBtns,
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

  JobTS1U,

  JobSup1U,

  InvListU,

  PayF2U,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,

  {$ENDIF}

  ThemeFix,

  PWarnU,
  {PayLineU,}
  InvFSu3U,
  //GS 26/10/2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF;




{$R *.DFM}



Function LineCheckCompleted(IdR  :  IDetail;
                            InvR :  InvRec;
                            Edit,MainChk  :  Boolean;
                        Var ShowMsg :  Boolean;
                            AOwner  :  TWinControl)  : Boolean;

Const
  NofMsgs      =  7;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop     :  Boolean;

  mbRet    :  Word;

  FoundLong
           :  LongInt;

  ExLocal  :  TdExLocal;

Begin
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='The Pay Rate Code is not valid.';
  PossMsg^[2]:=''; {Spare..}
  PossMsg^[3]:='The Cost Centre/ Department Code not valid.';
  PossMsg^[4]:='The Job Code is not valid.';
  PossMsg^[5]:='The Job Analysis Code is not valid.';
  PossMsg^[6]:='The Cost Currency is not valid.';
  PossMsg^[7]:='An additional check is made via an external hook';



  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With IdR do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=Get_StdPR(StockCode,JCtrlF,JCK,3);

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

                Result:=GetJob(AOwner,JobCode,FoundCode,-1);

              end;

        5  :  Begin

                Result:=GetJobMisc(AOwner,AnalCode,FoundCode,2,-1);

              end;

        6  :  Begin
                {$IFDEF MC_On}
                  Result:=(Currency In [Succ(CurStart)..CurrencyType]);
                {$ELSE}
                  Result:=BOn;

                {$ENDIF}
              end;

        7  :  Begin {* Opportunity for hook to validate this line as well *}
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



procedure TTSLine.ShowLink(InvR      :  InvRec;
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

  end;

  OutId;


  JustCreated:=BOff;

end;


procedure TTSLine.SetChargeFieldRO(AllowEdit  :  Boolean);

Begin
  //PR: 02/02/2018 Don't allow change if we're viewing only
  if ExLocal.LViewOnly then
    EXIT;

  If (AllowEdit) then
  Begin
    With RtHr do
    Begin
      Color:=Chrge.Color;
      Font.Color:=Chrge.Font.Color;
    end;

    With ChCr do
    Begin
      Color:=Chrge.Color;
      Font.Color:=Chrge.Font.Color;
    end;

  end
  else
  Begin
    With RtHr do
    Begin
      Color:=TCost.Color;
      Font.Color:=TCost.Font.Color;
    end;

    With ChCr do
    Begin
      Color:=TCost.Color;
      Font.Color:=TCost.Font.Color;
    end;
  end;

  With RtHr do
  Begin
    ReadOnly:=Not AllowEdit;
    Tag:=Ord(AllowEdit);
    TabStop:=AllowEdit;
  end;

  With ChCr do
  Begin
    ReadOnly:=Not AllowEdit;
    Tag:=Ord(AllowEdit);
    TabStop:=AllowEdit;
  end;

end;

procedure TTSLine.CheckAnalCode(ACode  :  Str10);

Var
  FoundCode  :  Str20;

Begin
  With ExLocal, LJobMisc^.JobAnalRec do
  Begin
    If (JAnalCode<>ACode) then
    Begin
      FoundCode:=ACode;

      If (GetJobMisc(Self.Owner,FoundCode,FoundCode,2,-1)) then
        AssignFromGlobal(JMiscF);
    end;

    SetChargeFieldRO((JAType<>4) or (PChkAllowed_In(406)));

    If (JAType=4) then
    Begin
      Label87.Caption:='Hours/Narrative';
      Label88.Caption:='Cost/Hour';
    end
    else
    Begin
      Label87.Caption:='Qty/Narrative';
      Label88.Caption:='Unit Cost';
    end;
  end;

end;


{ ========== Build runtime view ======== }

procedure TTSLine.BuildDesign;


begin
  If (PChkAllowed_In(406)) then {Open up the cost price fields}
  Begin
    SetChargeFieldRO(BOn);

  end;

end;


procedure TTSLine.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  {* Set Version Specific Info *}

  {$IFNDEF MC_On}

     ChCr.Visible:=BOff;
     CoCr.Visible:=BOff;

  {$ELSE}

     Set_DefaultCurr(CoCr.Items,BOff,BOff);
     Set_DefaultCurr(CoCr.ItemsL,BOff,BOn);
     Set_DefaultCurr(ChCr.Items,BOff,BOff);
     Set_DefaultCurr(ChCr.ItemsL,BOff,BOn);


  {$ENDIF}


  HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}

  NTCCF.Visible:=Not HideCC;
  NTDepF.Visible:=Not HideCC;

  CCLab.Visible:=NTCCF.Visible;

  //GS 26/10/2011 ABSEXCH-11706: removed existing UDF setup code; replaced with calling pauls new method
  SetUDFields(ExLocal.LInv.InvDocHed);


  Hrs.DecPlaces:=Syss.NoQtyDec;
  Chrge.DecPlaces:=Syss.NoNetDec;
  RtHr.DecPlaces:=Syss.NoCosDec;

  BuildDesign;

end;


//GS 26/10/2011 ABSEXCH-11706: a copy of pauls user fields function
//PR: 11/11/2011 Amended to use centralised function EnableUdfs in CustomFieldsIntf.pas ABSEXCH-12129
procedure TTSLine.SetUDFields(UDDocHed  :  DocTypes);
var
  VisibleFields: Integer;
  UDFPositionOffset: Integer;
begin

  //Call ArrangeUDFs to close up gaps caused by disabled fields.
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F],
             cfTSHLine);

  VisibleFields := NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]);

  //adjust the height of the UDEF container and associated controls
  //to remove any blank space caused by hidden UDEF fields
  if VisibleFields < 9 then
  begin
    //- get number of visible fields (10 - VisibleFields)
    //- divide result by 2 to get number of hidden rows (10 - VisibleFields) / 2)
    //- subtract field height from the dialog for each row that is hidden - (25 * ((10 - VisibleFields) / 2))
    UDFPositionOffset := (23 * ((10 - VisibleFields) div 2));

    self.height := self.height - UDFPositionOffset;
    Bevel3.Top := Bevel3.Top - UDFPositionOffset;
    Okdb1Btn.Top := Okdb1Btn.top - UDFPositionOffset;
    Candb1Btn.Top := Candb1Btn.Top - UDFPositionOffset;

    //if all UDEFs are hidden, then hide the UDEF field seperator (bevel line) also
    if VisibleFields = 0 then
    begin
      Bevel3.Visible := False;
    end;
  end;

end;

procedure TTSLine.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  InPassing:=BOff;

  JustCreated:=BOn;

  SKeypath:=0;

  //GS 26/10/2011 ABSEXCH-11706: modifed the default height to accomodate the new UDEFs
  ClientHeight:=380;
  ClientWidth:=446;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TTSheetForm) then
    With TTSheetForm(Owner) do
      Self.SetFieldProperties(N1DPanel,N1YRefF);

  FormDesign;

end;




procedure TTSLine.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,100);

end;

procedure TTSLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TTSLine.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TTSLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TTSLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TTSLine.Send_UpdateList(Edit   :  Boolean;
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



Function TTSLine.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;


Procedure TTSLine.SetFieldFocus;

Begin
  JCode.SetFocus;

end; {Proc..}


procedure TTSLine.Candb1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult=mrOk) then
      Begin
        // MH 16/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
        //                                   fields which processes the text and updates the value
        If (ActiveControl <> Okdb1Btn) Then
          // Move focus to OK button to force any OnExit validation to occur
          Okdb1Btn.SetFocus;

        // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
        If (ActiveControl = Okdb1Btn) Then
          StoreId(IdetailF,SKeypath);
      End // If (ModalResult=mrOk)
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



Function TTSLine.ConfirmQuit  :  Boolean;

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


procedure TTSLine.SetIdStore(EnabFlag,
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


{ ============== Display Id Record ============ }

Procedure TTSLine.OutId;

Var
  FoundOk   :  Boolean;

  FoundLong :  LongInt;

  FoundCode :  Str20;

Begin
  With ExLocal,LId do
  Begin
    JCode.Text:=Trim(JobCode);

    If (LJobRec^.JobCode<>JobCode) then
      LGetMainRecPos(JobF,JobCode);

    JDesc.Text:=LJobRec^.JobDesc;

    RtCode.Text:=Trim(StockCode);

    RtDesc.Text:=Get_StdPrDesc(StockCode,JCtrlF,JCK,0);

    Anal.Text:=Trim(AnalCode);

    CheckAnalCode(AnalCode);

    NTCCF.Text:=CCDep[BOn];
    NTDepF.Text:=CCDep[BOff];

    NarF.Text:=Desc;

    Hrs.Value:=Qty;

    {$IFDEF MC_On}
      If (Currency>0) then
        ChCr.ItemIndex:=Pred(Currency);

      If (Reconcile>0) then
        CoCr.ItemIndex:=Pred(Reconcile);
    {$ENDIF}

    Chrge.Value:=CostPrice;
    TotChrge.Value:=InvLCost(LId);
    RtHr.Value:=NetValue;
    TCost.Value:=DetLTotal(LId,BOn,BOff,0.0);

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


  end;

end;


procedure TTSLine.Form2Id;

Begin

  With EXLocal.LId do
  Begin

    CCDep[BOn]:=NTCCF.Text;
    CCDep[BOff]:=NTDepF.Text;

    JobCode:=FullJobCode(JCode.Text);
    AnalCode:=FullJACode(Anal.Text);
    Qty:=Round_up(Hrs.Value,Syss.NoQtyDec);
    NetValue:=Round_up(RtHr.Value,Syss.NoCosDec);
    CostPrice:=Round_up(Chrge.Value,Syss.NoNetDec);
    StockCode:=FullStockCode(RtCode.Text);

    {$IFDEF MC_On}
      Currency:=Succ(ChCr.ItemIndex);

      Reconcile:=Succ(CoCr.ItemIndex);
    {$ENDIF}

    Desc:=NarF.Text;

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

  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TTSLine.ProcessId(Fnum,
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

    //GS 22/08/2011 ABSEXCH-11512: only determine if we should escape from the method ('AddCh:=Esc') if 'view only' is false
    //because if we are just viewing the record we don't need a successful lock ('GlobLocked') on the record to proceed!
    If ExLocal.LViewOnly = False then
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

      NomMode:=TSTNomMode;

      ABSLineNo:=LInv.ILineCount;

      IDDocHed:=LInv.InvDocHed;

      Currency:=LInv.Currency;

      CXRate:=LInv.CXRate;

      CurrTriR:=LInv.CurrTriR;

      PYr:=LInv.ACYr;
      PPr:=LInv.AcPr;

      Payment:=DocPayType[IdDocHed];

      PDate:=LInv.TransDate;

      CCDep:=TSEmplRec.EmplRec.CCDep;

    end;

    LastId:=LId;


    OutId;

    JCode.OrigValue:=JCode.Text;

    SetIdStore(BOn,ExLocal.LViewOnly);

  end; {If Abort..}

end; {Proc..}





procedure TTSLine.StoreId(Fnum,
                          Keypath  :  Integer);

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


          With LastId  do
            InvFSU3U.UpdateRecBal(LastId,LInv,BOn,BOff,17);

          InvFSU3U.UpdateRecBal(LId,LInv,BOff,BOff,17);

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


procedure TTSLine.SetFieldProperties(Panel  :  TSBSPanel;
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


procedure TTSLine.EditLine(InvR       :  InvRec;
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



procedure TTSLine.JCodeExit(Sender: TObject);
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

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJob(Self.Owner,FoundCode,FoundCode,4));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin
          AssignFromGlobal(JobF);

          Text:=FoundCode;

          JDesc.Text:=LJobRec^.JobDesc;
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





procedure TTSLine.NTCCFExit(Sender: TObject);
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

        //TG 15-05-2017 2017 R2 18699 - Access Violation message - creating Job Record using inactive CC/Dept
        // Mode 2 has to sent instead of 0
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




procedure TTSLine.AnalExit(Sender: TObject);
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

      AMode:=3;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) then
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

          CheckAnalCode(FoundCode);
        end
        else
        Begin
          SetFocus;
        end; {If not found..}
      end;

    end;
  {$ENDIF}

end;


Function TTSLine.FindJPRLevel(JCode     :  Str10;
                         Var  UseJCode  :  Str10)  :  Boolean;


Const
  Fnum     =  JCtrlF;
  Keypath  =  JCK;
  Fnum2    =  JobF;
  Keypath2 =  JobCatK;

Var
  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr : LongInt;

  KeyChk,
  KeyS       : Str255;

  LOk        : Boolean;

  TmpJRec    : JobRecType;


Begin
  Result:=BOff;  LOk:=BOff;

  KeyS:=''; KeyChk:='';    UseJCode:=JCode;

  With ExLocal do
  Begin
    TmpJRec:=LJobRec^;

    TmpKPath:=GetPosKey;

    TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOff,BOff);

    If (LGetMainRecPos(JobF,JCode)) then
    Begin
      KeyChk:=JBRCode+JBSubAry[3]+FullEmpKey(JCode);
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);

      Result:=(StatusOk and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)));

      If (Result) then
       UseJCode:=JCode
      else
        If (Not Emptykey(LJobRec^.JobCat,JobKeyLen)) and (LJobRec^.JobCat<>JCode) then
          Result:=FindJPRLevel(LJobRec^.JobCat,UseJCode);


    end;

    TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOn,BOn);

    LJobRec^:=TmpJRec;
  end; {With..}
end; {Func..}


Function TTSLine.Link_TSPayRate(ThisCode  :  Str20;
                                CCode     :  Str10;
                           Var  JCode     :  Str10;
                                Mode,
                                GMode     :  Integer)  :  Boolean;


Const
  GModeAry  :   Array[0..3] of Byte = (3,4,3,3);

Var
  KeyChk    :  Str255;
  FoundCode :  Str20;
  LOk,
  FoundJ    :  Boolean;


Begin
  LOk:=BOff;

  KeyChk:=FullNomKey(PRateCode);

  FoundCode:=''; JCode:='';  FoundJ:=BOff;

  With ExLocal, LJobMisc^.EmplRec do
  Begin
    If (EmpCode<>CCode) then
    Begin
      LOk:=GetJobMisc(Self,CCode,FoundCode,3,-1);

      If (LOk) then
        ExLocal.AssignFromGlobal(JMiscF);
    end
    else
      LOk:=BOn;

    If (LOk) then
    Begin
      JCode:=LId.JobCode;

      FoundJ:=FindJPRLevel(LId.JobCode,JCode);

      Case UseORate of
        1  :  KeyChk:=CCode; {Get Employee only}
        3  :  Begin {Get Job/contract only}
                If (FoundJ) then
                  KeyChk:=JCode
                else
                  KeyChk:=LId.JobCode;
              end;
      end; {Case..}
    end {If found ok..}
    else
      UseORate:=0;

    LOk:=GetEmpRate(Self.Owner,FullJACode(KeyChk)+ThisCode,LId.StockCode,GModeAry[UseORate],Mode);

  end;

  Link_TSPayRate:=LOk;
end;


{ ====== Wrapper procedure to get details of std payrates ======= }

Function TTSLine.Get_TSPayRate(ThisCode  :  Str20;
                               CCode     :  Str10;
                               Mode,
                               GMode     :  Integer)  :  Boolean;

Const
  Fnum     = JCtrlF;
  KeyPath  = JCK;

Var

  TCtrlRec  :  JobCtrlRec;

  JLevelCode:  Str10;

  KeyChk    :  Str255;

  PROverride,
  Loop      :  Boolean;

  ThisCurr  :  Byte;


{ == Function to return equivalent employee or job rates == }

Function MatchPRate(MPRMode  :  Byte;
                    MCode    :  Str10)  :  Boolean;

Begin
  With JobCtrl^.EmplPay do
  Begin
    ThisCurr:=CostCurr;

    Loop:=BOff;

    Repeat

      KeyChk:=FullJBKey(JBRCode,JBSubAry[MPRMode],FullJBCode(MCode,ThisCurr,EStockCode));

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyChk);

      ThisCurr:=0;

      Loop:=Not Loop;

    Until (Not Loop) or (StatusOk);

  end;

  Result:=StatusOk;

end; {Func..}




Begin
  Result:=BOff; PROverride:=BOff;


  If Link_TSPayRate(ThisCode,CCode,JLevelCode,Mode,GMode) then
  With ExLocal do
  Begin
    TCtrlRec:=JobCtrl^;


    With LJobMisc^.EmplRec do
      Case UseORate of
        0,1  :  Begin
                  PROverride:=MatchPRate(4,CCode);

                  If (Not PROverride) and (UseORate<>1) then
                    PROverride:=MatchPRate(3,JLevelCode);
                end;
        2,3  :  Begin
                  PROverride:=MatchPRate(3,JLevelCode);

                  If (Not PROverride) and (UseORate<>3) then
                    PROverride:=MatchPRate(4,CCode);
                end;
      end; {Case..}

    If (Not PROverride) then
      JobCtrl^:=TCtrlRec;

    With JobCtrl^.EmplPay do
    Begin
      LId.AnalCode:=EAnalCode;  {* JA_X Replace with correct Anal *}
      LId.Currency:=CostCurr;
      LId.NetValue:=Cost;
      LId.CostPrice:=ChargeOut;

      LId.Desc:=PayRDesc;

      LId.Reconcile:=ChargeCurr;
      LId.CXRate:=SyssCurr^.Currencies[CostCurr].CRates;
      SetTriRec(LId.Currency,LId.UseORate,LId.CurrTriR);



    end;

    Result:=BOn;
  end;


end; {Proc..}


procedure TTSLine.RtCodeEnter(Sender: TObject);
begin
  {$IFDEF CU}
    If (Not RtCode.ReadOnly) and (Sender=RtCode) then
    Begin
      RtCode.Text:=TextExitHook(4000,53,RtCode.Text,ExLocal,DoFocusFix);
    end;
  {$ENDIF}

end;


procedure TTSLine.RtCodeExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      {$IFDEF CU}
        Text:=TextExitHook(4000,54,RtCode.Text,ExLocal);
      {$ENDIF}

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) then
      Begin
        Form2Id;

        StillEdit:=BOn;

        FoundOk:=Get_TSPayRate(FoundCode,ExLocal.LInv.BatchLink,0,3);

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin
          OutId;

          Text:=LId.StockCode;

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

procedure TTSLine.HrsExit(Sender: TObject);
begin
  Form2Id;

  If (Sender=Chrge) then
  With (Sender as TCurrencyEdit) do
  Begin
    {$IFDEF CU}
      GenHooks(4000,55,ExLocal,DoFocusFix);
    {$ENDIF}
  end;

  
  OutId;
end;


procedure TTSLine.THUD1FEntHookEvent(Sender: TObject);
Var
  CUUDEvent  :  Byte;
  Result     :  LongInt;

begin
   CUUDEvent  := 0;
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
                //GS 26/10/2011 ABSEXCH-11706: create branches for the new UDFs
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
              //GS 26/10/2011 ABSEXCH-11706: put customisation object vals into UDFs
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




procedure TTSLine.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>Candb1Btn) then
    Text8pt(Sender).ExecuteHookMsg;

end;

procedure TTSLine.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;

  //Description
  NarF.AllowPostedEdit := True;

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

function TTSLine.TransactionViewOnly: Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;

Initialization

end.
