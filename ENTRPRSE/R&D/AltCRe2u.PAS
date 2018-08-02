unit AltCRe2U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, BorBtns, TEditVal, Mask, ExtCtrls,
  GlobVar,VarConst,ExWrap1U,BTSupU1,CmpCtrlU,SBSPanel;


type
  TAltSCRec = class(TForm)
    NPNotePanel: TPanel;
    Label89: Label8;
    Label81: Label8;
    ACSCode: Text8Pt;
    Label82: Label8;
    UROChk: TBorCheck;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    ACSDesc: Text8Pt;
    ACADesc: Text8Pt;
    ACACName: Text8Pt;
    ROPF: TCurrencyEdit;
    SRRPCF: TSBSComboBox;
    ACACode: Text8Pt;
    ACCode: Text8Pt;
    UseRQChk: TBorCheck;
    Label87: Label8;
    MEQF: TCurrencyEdit;
    Label88: Label8;
    RQtyF: TCurrencyEdit;
    UseMEQChk: TBorCheck;
    Label810: Label8;
    DOLF: TCurrencyEdit;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CanCp1BtnClick(Sender: TObject);
    procedure UROChkClick(Sender: TObject);
    procedure ACCodeExit(Sender: TObject);
    procedure ACACodeExit(Sender: TObject);
  private
    { Private declarations }

    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;


    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Procedure OutId;

    procedure Form2Id;


    Procedure SetROFields;

    Procedure StoreEquiv(Fnum,
                         Keypath  :  Integer;
                         DelMode  :  Boolean);

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    AltPageMode:  Byte;

    ParentStock:  StockRec;

    ExLocal    :  TdExLocal;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure SetCaption;

    Function GetLastsdLineNo(Fnum  :  Integer)  :  LongInt;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(Edit       :  Boolean;
                       NewPage    :  Byte);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer);

  end;

Const
  AltRecCaption  :  Array[0..4] of Str50 = ('Alternative','Equivalent','Superseded by','Opportunity','Supersedes');
  AltSPFix       :  Array[0..4] of Char = (NoteCCode,'1','2','3','2');

  AltPageNo   =  0;
  EquivPageNo =  1;
  SuperPageNo =  2;
  OppoPageNo  =  3;
  SuperSdPageNo= 4;

  Function Stock_HasSuperOpo(StkFolio  :  LongInt)  :  Byte;


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
  SBSComp2,
  CurrncyU,
  ComnUnit,
  ComnU2,
  SysU1,
  SysU2,

  ColCtrlU,

  AltCLs2U,

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  ThemeFix,

  InvListU;



{$R *.DFM}


{ == Function to determine if a stock item has been superseded or oppotunity bound == }

Function Stock_HasSuperOpo(StkFolio  :  LongInt)  :  Byte;

Const
  Fnum     = MLocF;
  Keypath  = MLSecK;


Var

    n          : Byte;

    FoundOk    : Boolean;

    TmpStat,
    TmpKPath   : Integer;

    TmpRecAddr : LongInt;

    KeyS2,
    KeyChk2  :  Str255;

    TmpMLoc
             :  MLocRec;



Begin
  Result:=0;  FoundOk:=BOff;

  TmpMLoc:=MLocCtrl^;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  n:=SuperPageNo;

  Repeat
    KeyChk2:=PartCCKey(NoteTCode,AltSPfix[n])+FullNomKey(StkFolio);
    KeyS2:=KeyChk2;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS2);

    FoundOk:=(StatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOn));

    If (Not FoundOk) then
      Inc(n);

  Until (n>OppoPageNo) or (FoundOk);

  If (FoundOk) then
    Result:=n;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  MLocCtrl^:=TmpMLoc;

end;



{ ========== Build runtime view ======== }

procedure TAltSCRec.BuildDesign;


begin
  {$IFNDEF MC_On}
    SRRPCF.Visible:=BOff;
    ROPF.Left:=SRRPCF.Left;
  {$ELSE}
    Set_DefaultCurr(SRRPCF.Items,BOff,BOff);
    Set_DefaultCurr(SRRPCF.ItemsL,BOff,BOn);
    SRRPCF.Visible:=(AltPageMode = AltPageNo);

  {$ENDIF}

  Case AltPageMode of
    AltPageNo   :  Begin
                     Label81.Caption:='Alternative Code';
                     Label84.Caption:='Alt. Desc.';


                   end;
    EquivPageNo :  Begin
                     Label81.Caption:='Equivalent Code';
                     Label84.Caption:='Desc.';

                   end;
    SuperPageNo :  Begin
                     Label81.Caption:='Superseded Code';
                     Label84.Caption:='Desc.';

                   end;
    OppoPageNo  :  Begin
                     Label81.Caption:='Opportunity Code';
                     Label84.Caption:='Desc.';

                   end;
  end; {Case..}

  {Label82.Visible:=(AltPageMode = AltPageNo);
  AcCode.Visible:=(AltPageMode = AltPageNo);
  Label85.Visible:=(AltPageMode = AltPageNo);
  AcaCName.Visible:=(AltPageMode = AltPageNo);}
  ACACode.Link_to_Stock:=(AltPageMode <> AltPageNo);

  ACADesc.Tag:=Ord((AltPageMode = AltPageNo));
  ACADesc.ReadOnly:=ACADesc.Tag=0;
  ACADesc.TabStop:=Not ACADesc.ReadOnly;
  Label86.Visible:=(AltPageMode = AltPageNo);

  UseMEQChk.Visible:=(AltPageMode = AltPageNo);
  Label87.Visible:=(AltPageMode = AltPageNo);
  MEQF.Visible:=(AltPageMode = AltPageNo);
  UseRQChk.Visible:=(AltPageMode <> AltPageNo);
  Label88.Visible:=(AltPageMode <> AltPageNo);
  RQtyF.Visible:=(AltPageMode <> AltPageNo);
  Label810.Visible:=(AltPageMode <> AltPageNo);
  
  DOLF.Visible:=(AltPageMode <> AltPageNo);

  If (UseRQChk.Visible) then
  Begin
    UseRQChk.Top:=UROChk.Top;
    UseRQChk.TabOrder:=UROChk.TabOrder;
    Label88.Top:=Label86.Top;
    RQtyF.Top:=UROChk.Top;
    RQtyF.TabOrder:=ROPF.TabOrder;

  end;

  UROChk.Visible:=(AltPageMode = AltPageNo);
  ROPF.Visible:=(AltPageMode = AltPageNo);


  RQtyF.DecPlaces:=Syss.NoQtyDec;
  MEQF.DecPlaces:=Syss.NoQtyDec;

  With ACADesc do
  If (ACADesc.ReadOnly) then
  Begin
    Color:=clBtnFace;
    Font.Color:=clBlack;
    {* b5471.036. EL: Sent to prevent miscoloring bug under XP when the color is grayed out. *}
    PostMessage(ACADesc.Handle, WM_MOUSEMOVE, 0, 0);

  end
  else
  Begin
    Color:=ACACode.Color;
    Font.Color:=ACACode.Font.Color;

  end;

end;


procedure TAltSCRec.FormDesign;


begin

  ACACode.MaxLength:=StkKeyLen;
  ACADesc.MaxLength:=StkDesKLen;
  ROPF.DecPlaces:=Syss.NoCosDec;
  BuildDesign;

end;



procedure TAltSCRec.SetCaption;

Begin
  With ExLocal,ParentStock do
    Caption:=AltRecCaption[AltPageMode]+' Code Record for '+dbFormatName(StockCode,Desc[1]);

end;


procedure TAltSCRec.FormCreate(Sender: TObject);
begin
  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  AltPageMode:=0;

  SKeypath:=0;

  ClientHeight:=201;
  ClientWidth:=537;

  MDI_SetFormCoord(TForm(Self));

  {With TForm(Owner) do
    Self.Left:=Left+2;}

  If (Owner is TAltCList) then
    With TAltCList(Owner) do
      Self.SetFieldProperties(ccPanel);

  FormDesign;

end;




procedure TAltSCRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,102);

end;

procedure TAltSCRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TAltSCRec.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TAltSCRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TAltSCRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Procedure TAltSCRec.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      0  :  ;

    end; {Case..}

  end;
  Inherited;
end;



{ == Procedure to Send Message to Get Record == }

Procedure TAltSCRec.Send_UpdateList(Edit   :  Boolean;
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



Function TAltSCRec.CheckNeedStore  :  Boolean;

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


Procedure TAltSCRec.SetFieldFocus;

Begin
  ACACode.SetFocus;

end; {Proc..}



Procedure TAltSCRec.SetROFields;

Var
  n  :  Byte;
Begin
  ROPF.ReadOnly:=Not UROChk.Checked;
  SRRPCF.ReadOnly:=Not UROChk.Checked;

  MEQF.ReadOnly:=Not UseMEQChk.Checked;
  RQtyF.ReadOnly:=Not UseRQChk.Checked;

end; {Proc..}



Function TAltSCRec.ConfirmQuit  :  Boolean;

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
                StoreId(MLocF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(MLocF,LastRecAddr[MLocF]);

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

Procedure TAltSCRec.OutId;

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  n         :  Byte;

  KeyS      :  Str255;


Begin
  With ExLocal,LMLocCtrl^,sdbStkRec do
  Begin


    ACACode.Text:=Trim(sdCode1);

    ACADesc.Text:=Trim(sdDesc);

    ACSCode.Text:=ParentStock.StockCode;
    ACSDesc.Text:=ParentStock.Desc[1];

    ACCode.Text:=Trim(sdSuppCode);

    LGetMainRecPos(CustF,sdSuppCode);

    ACACName.Text:=LCust.Company;

    {$IFDEF MC_On}
      SRRPCF.ItemIndex:=Pred(sdROCurrency);
    {$ENDIF}

    ROPF.Value:=sdROPrice;
    UROChk.Checked:=sdOverRO;

    UseMEQChk.Checked:=sdOverMinEcc;
    MEQF.Value:=sdMinEccQty;
    UseRQChk.Checked:=sdOverLineQty;
    RQtyF.Value:=sdLineQty;
    DOLF.Value:=sdLineNo;

    If (AltPageMode<>AltPageNo) then
    Begin
      If (sdCode1<>LStock.StockCode)  and (sdCode1<>'') then
        LGetMainRecPos(StockF,FullStockCode(sdCode1));

      If (sdCode1<>'') then
        ACADesc.Text:=LStock.Desc[1];
    end;

  end;

  SetROFields;

end;


procedure TAltSCRec.Form2Id;

Var
  n :  Byte;

Begin

  With EXLocal,LMLocCtrl^,sdbStkRec do
  Begin
    sdCode1:=FullStockCode(ACACode.Text);
    sdDesc:=ACADesc.Text;
    sdSuppCode:=FullCustCode(ACCode.Text);

    sdOverRO:=UROChk.Checked;

    {$IFDEF MC_On}
      sdROCurrency:=Succ(SRRPCF.ItemIndex);
    {$ENDIF}

    sdROPrice:=ROPF.Value;

    sdOverMinEcc:=UseMEQChk.Checked;
    sdMinEccQty:=MEQF.Value;
    sdOverLineQty:=UseRQChk.Checked;
    sdLineQty:=RQtyF.Value;
    sdLineNo:=Round(DOLF.Value);

  end; {with..}

end; {Proc..}


procedure TAltSCRec.ACCodeExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text) and (ExLocal.InAddEdit) and (ActiveControl<>CanCP1Btn) and (Not ReadOnly) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOff,99));

      If (FoundOk) then
      Begin

        StopPageChange:=BOff;

        StillEdit:=BOff;

        Text:=FoundCode;

        ACACName.Text:=Cust.Company;

        {* Weird bug when calling up a list caused the Enter/Exit methods
             of the next field not to be called. This fix sets the focus to the next field, and then
             sends a false move to previous control message ... *}

        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin

        StopPageChange:=BOn;

        SetFocus;
      end; {If not found..}
    end;
  end; {with..}
end;

procedure TAltSCRec.ACACodeExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin

  If (Sender is Text8pt) and (AltPageMode<>AltPageNo) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetStock(Self,FoundCode,FoundCode,3));

      If (FoundOk) then
      Begin
        FoundOk:=(FoundCode<>FullStockCode(ACSCode.Text));

        If (Not FoundOk) then
          MessageDlg('The '+Label81.Caption+' and Stock Code cannot be the same.',mtWarning,[mbOk],0);
      end;

      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

        With ExLocal,LMLocCtrl^,sdbStkRec do
          sdCode1:=FoundCode;

        OutId;
      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;


Function TAltSCRec.GetLastsdLineNo(Fnum  :  Integer)  :  LongInt;

Const
  Keypath  =  MLSuppK;

Var
  KeyChk,
  KeyS       :    Str255;
  LocalMLoc  :    MLocRec;

Begin
  With ExLocal,LMLocCtrl^,sdbStkRec do
  Begin
    LocalMLoc:=LMLocCtrl^;

    KeyChk:=PartCCKey(NoteTCode,AltSPfix[AltPageMode])+FullNomKey(sdStkFolio);

    KeyS:=PartCCKey(NoteTCode,AltSPfix[AltPageMode])+FullRunNoKey(sdStkFolio,MaxLInt);

    Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);


    If (StatusOk and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff))) then
      Result:=Succ(sdLineNo)
    else
      Result:=1;

    LMLocCtrl^:=LocalMLoc;

  end; {With..}
end;


(*  Add is used to add Notes *)

procedure TAltSCRec.ProcessId(Fnum,
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
  With ExLocal,LMLocCtrl^,sdbStkRec do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPfix:=NoteTCode;
      Subtype:=AltSPfix[AltPageMode];

      sdNLineCount:=1;
      sdStkFolio:=ParentStock.StockFolio;

      {$IFDEF MC_On}
        sdROCurrency:=1;
      {$ENDIF}

      sdLineQty:=1.0;

      If (AltPageMode<>AltPageNo) then
        sdLineNo:=GetLastsdLineNo(Fnum);

      sdMinEccQty:=1.0;
    end;

    LastMLoc^:=LMLocCtrl^;

    OutId;

  end {If Abort..}
  else
    Close;

end; {Proc..}




Function TAltSCRec.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  3;


Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  KeyS     :  Str255;

  n,
  Test     :  Byte;

  FoundLong:  LongInt;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;


Begin
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That Alternative Code is not valid.';
  PossMsg^[2]:='The Re-Order Price currency is not valid.';
  PossMsg^[3]:='The '+Label81.Caption+' and Stock Code cannot be the same.';



  Loop:=BOff;

  Test:=1;

  Result:=BOn;
  ShowMsg := False; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 

  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LMLocCtrl^.sdbStkRec do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin

              Result:=Not EmptyKey(sdCode1,StkKeyLen);

            end;


    {$IFDEF MC_On}

      2  :
               Result:=(sdROCurrency In [Succ(CurStart)..CurrencyType]);

    {$ELSE}
      2  :     Result:=BOn;

    {$ENDIF}


      3  :  Begin

              Result:=(sdCode1<>ParentStock.StockCode) or (AltPageMode=AltPageNo);

            end;


    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}



{ == procedure to offer to insert equivalent entry into opossite stock item == }

Procedure TAltSCRec.StoreEquiv(Fnum,
                               Keypath  :  Integer;
                               DelMode  :  Boolean);

Var
  mbRet    :  Word;

  KeyS2,
  KeyChk2  :  Str255;

  TmpMLoc
           :  MLocRec;
  TmpStk   :  StockRec;


Begin
  If (AltPageMode=EquivPageNo) or (DelMode) then
  With ExLocal,LMLocCtrl^,sdbStkRec do
  Begin
    TmpMLoc:=LMLocCtrl^; TmpStk:=LStock;

    KeyChk2:=sdCode1;

    If (DelMode) then
      LGetMainRecPos(StockF,KeyChk2);

    KeyS2:=PartCCKey(NoteTCode,AltSPfix[EquivPageNo])+Full_SupStkKey(LStock.StockFolio,ParentStock.StockCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,MLSecK,KeyS2);

    If (Not StatusOk) and (Not DelMode) then
    Begin
      MbRet:=MessageDlg('Do you wish to create an equivalent record against '+Trim(LStock.StockCode)+' for '+Trim(ParentStock.StockCode)+'?',
                       mtConfirmation,[mbYes,mbNo],0);

      If (mbRet=mrYes) then
      Begin
        LMLocCtrl^:=TmpMLoc;

        sdCode1:=ParentStock.StockCode;

        sdStkFolio:=LStock.StockFolio;

        sdCode2:=Full_SupStkKey(sdStkFolio,sdCode1);
        sdCode3:=FullRunNoKey(sdStkFolio,sdLineNo)+sdCode1;
        sdDesc:=ACSDesc.Text;

        If (sdLineQty<>1) and (sdLineQty<>0) and (sdOverLineQty) then
          sdLineQty:=Round_Up(DivWChk(1,sdLineQty),Syss.NoQtyDec);

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        Report_BError(Fnum,Status);


      end;

    end
    else
      If (StatusOk) and (DelMode) then
      Begin
        AssignToGlobal(Fnum);
        
        DeleteBOMLine(Fnum,KeyPath);

      end;


    If (Not DelMode) then
    Begin
      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}
    end;

    LMLocCtrl^:=TmpMLoc; LStock:=TmpStk;

  end;
end;



procedure TAltSCRec.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpMLoc
       :  MLocRec;

  KeyS :  Str255;

  mbRet:  Word;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LMLocCtrl^,sdbStkRec do
  Begin
    COk:=CheckCompleted(LastEdit,BOff);



    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      If (Not LastEdit) then
      Begin
        sdFolio:=SetNextSFolio(SKF,BOn,1);
      end;

      sdCode2:=Full_SupStkKey(sdStkFolio,sdCode1);

      If (AltPageMode<>AltPageNo) then
        sdCode3:=FullRunNoKey(sdStkFolio,sdLineNo)+sdCode1
      else
        sdCode3:=FullRunNoKey(sdFolio,sdStkFolio);

      {* Update last edited flag *}

      sdLastUsed:=Today;
      sdLastTime:=TimeNowStr;

      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpMLoc:=LMLocCtrl^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LMLocCtrl^:=TmpMLoc;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end
      else
      Begin

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        LGetRecAddr(Fnum);

        StoreEquiv(Fnum,Keypath,BOff);
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


procedure TAltSCRec.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TAltSCRec.EditLine(Edit       :  Boolean;
                             NewPage    :  Byte);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ParentStock:=LStock;

    AltPageMode:=NewPage;

    SetCaption;

    BuildDesign;

    ProcessId(MLocF,MLK,LastEdit);
  end;
end;


procedure TAltSCRec.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      // Move focus to OK button to force OnExit validation/formatting to kick in
      If OkCP1Btn.CanFocus Then
        OkCP1Btn.SetFocus;
      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = OkCP1Btn) Then
      begin
        StoreId(MLocF,SKeypath);
      end;
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


procedure TAltSCRec.DeleteBOMLine(Fnum,
                                KeyPath  :  Integer);

Var
  MbRet  :  Word;
  GotRec :  Integer;
  KeyS   :  Str255;

Begin
  With ExLocal do
  Begin
    ParentStock:=LStock;

    AssignFromGlobal(Fnum);
    LGetRecAddr(Fnum);
    OutId;
    OKCP1Btn.Enabled:=BOff;
    CanCP1Btn.Enabled:=BOff;

    MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this record?',
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

          {$IFDEF NP}
            Delete_Notes(NotesdbCode,FullNCode(FullNomKey(LMLocCtrl^.sdbStkRec.sdFolio)));
          {$ENDIF}


          StoreEquiv(Fnum,Keypath,BOn);

          Send_UpdateList(BOff,17);


          
        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}





procedure TAltSCRec.UROChkClick(Sender: TObject);
begin
  SetROFields;

  With ExLocal do
  If (Sender=UseRQChk) and (RQtyF.Value=1.0) and (UseRQChk.Checked) and (LStock.SellUnit<>1.0) then
  Begin
    RQtyF.Value:=Round_Up(DivwChk(ParentStock.SellUnit,LStock.SellUnit),Syss.NoQtyDec);

  end;
end;


Initialization



end.
