unit StkROrdr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, TEditVal, SBSPanel, bkgroup, Mask,ExWrap1U,

  GlobVar,VarConst;

type
  TStkReOrd = class(TForm)
    PrefSupp: Text8Pt;
    CostPriceF: TCurrencyEdit;
    CostCurr: TSBSComboBox;
    SBSBackGroup1: TSBSBackGroup;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    FreeStk: TCurrencyEdit;
    Need: TCurrencyEdit;
    OnOrd: TCurrencyEdit;
    MinStk: TCurrencyEdit;
    Label81: Label8;
    MinLab: Label8;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    OrdQty: TCurrencyEdit;
    Bevel1: TBevel;
    Company: Text8Pt;
    Label86: Label8;
    Label87: Label8;
    Label88: Label8;
    Label89: Label8;
    StkDesc: Text8Pt;
    CCLab: Label8;
    SRCCF: Text8Pt;
    SRDepF: Text8Pt;
    I1TransDateF: TEditDate;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure PrefSuppExit(Sender: TObject);
    procedure SRCCFExit(Sender: TObject);
    procedure OrdQtyEnter(Sender: TObject);
    procedure OrdQtyExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    IdStored,
    StopPageChange,
    FirstEdit,
    JustCreated  :  Boolean;

    LastQty      :  Double;
    SKeypath     :  Integer;


    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure SetCaption;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Procedure OutId(UpLink  :  Boolean);

    procedure Form2Id;

    procedure SetFieldProperties(Field  :  TSBSPanel) ;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    ExLocal    :  TdExLocal;

    Back2Back,
    GenWORQty  :  Boolean;

    StkLocFilt :  Str10;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;


    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure EditLine(Edit,
                       VO         :  Boolean;
                       Keypath    :  Integer;
                       SFilt      :  Str10);


  end;

Function Stk_SuggROQ(StockR  :  StockRec;
                     B2BOrd,
                     IncWOR  :  Boolean)  :  Double;

  Procedure Generate_AutoNeed(Back2Ord,
                              GenWORQty :  Boolean;
                              StkGrp    :  Str20;
                              StkLocFilt:  Str10;
                              Fnum,
                              KeyPath   :  Integer;
                              KeyChk    :  Str255);

  Procedure ResetOrderQty(Fnum,Keypath  :  Integer;
                          StkLocFilt    :  Str10);


Var
  StkROB2B,
  StkROGWOR  :  Boolean;

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
  BTSupU1,
  BTSupU2,
  SBSComp2,
  VarRec2U,
  CurrncyU,
  ComnUnit,
  ComnU2,


  ColCtrlU,

  CmpCtrlU,
  SysU2,

  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  StkLstU,

  InvLst3U,

  {$IFDEF CU}
    Event1U,
    CustWinU,
    CustIntU,
    oStock,
  {$ENDIF}

  ExThrd2U,
  Warn1U,
  PayF2U,
  DiscU3U,
  PassWR2U,
  Saltxl1U;




{$R *.DFM}




{ ======== Function to Prompt Reorder Qty ======= }

Function Stk_SuggROQ(StockR  :  StockRec;
                     B2BOrd,
                     IncWOR  :  Boolean)  :  Double;

Var
  AWOR,
  NeedUnit,
  ROUnit    :   Double;



Begin

  With StockR do
  Begin

    ROUnit:=0.0;  NeedUnit:=0.0;

    If (IncWOR) then
      AWOR:=QtyAllocWOR
    else
      AWOR:=0.0;

    If (B2BOrd) then
      NeedUnit:=(AllocStock(StockR)-(QtyOnOrder+QtyInStock))
    else
    Begin
      If ((FreeStock(StockR)+QtyOnOrder)<QtyMin) or (QtyMin=0) then {*Check added v4.23}
        NeedUnit:=(QtyMax-FreeStock(StockR)-QtyOnOrder);
    end;

    If (NeedUnit>0) then
    Begin

      If (IncWOR) then
        RoUnit:={DivWChk(NeedUnit,MinEccQty)} NeedUnit
      else
        RoUnit:=DivWChk(NeedUnit,BuyUnit);

      If ((ROUnit-Trunc(ROUnit))>0) then  {* Round up to next packing Qty *}
        ROUnit:=Trunc(ROUnit)+1;

    end;

  end; {With..}

  Stk_SuggROQ:=ROUnit;

end; {Func..}


  { =========== Procedure to Generate automatic Order Qty ========= }



  Procedure Generate_AutoNeed(Back2Ord,
                              GenWORQty :  Boolean;
                              StkGrp    :  Str20;
                              StkLocFilt:  Str10;
                              Fnum,
                              KeyPath   :  Integer;
                              KeyChk    :  Str255);

  Var
    KeyS       :  Str255;

    LOk,
    Locked,
    Ok2Go      :  Boolean;

    ROChk      :  Real;

    MsgForm    :  TForm;

    mbRet      :  TModalResult;

    LAddr      :  LongInt;

    TmpStk     :  StockRec;

    {$IFDEF CU}

      ROLineCU  :  TCustomEvent;

      ExLocal   :  TdExLocal;
    {$ENDIF}



  Begin

    KeyS:=KeyChk;

    Ok2Go:=BOn;


    Try
      {$IFDEF CU}
        ROLineCU:=TCustomEvent.Create(EnterpriseBase+3000,52);

        ExLocal.Create;

        If (ROLineCU.GotEvent) then
        Begin
          ROLineCU.BuildEvent(ExLocal);
        end;
      {$ELSE}

//        ROLineCU:=nil;

      {$ENDIF}

      RoChk:=0;

      Set_BackThreadMVisible(BOn);

      MsgForm:=CreateMessageDialog('Please Wait... Generating Order Quantities',mtInformation,[mbAbort]);
      MsgForm.Show;
      MsgForm.Update;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (Ok2Go) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With Stock do
      Begin

        mbRet:=MsgForm.ModalResult;

        Loop_CheckKey(Ok2Go,mbRet);

        MsgForm.ModalResult:=mbRet;

        Application.ProcessMessages;

        If (StockType<>StkGrpCode) and (Ok2Go) then
        Begin
          TmpStk:=Stock;

          Stock_LocSubst(TmpStk,StkLocFilt);

          ROChk:=Stk_SuggROQ(TmpStk,Back2Ord,GenWORQty and (StockType=StkBillCode));

          If (RoChk<>0) and (Stk_InGroup(StkGrp,Stock)) then
          Begin

            LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

            If (LOk) and (Locked) then
            Begin

              RoQty:=ROChk;

              RoFlg:=BOn;

(*              {$B-}
              If (Assigned(ROLineCU)) and (ROLineCU.GotEvent) then
              {$B+}
              With ROLineCU do
              Begin
                ExLocal.AssignFromGlobal(StockF);

                TStock(EntSysObj.Stock).Assign(EnterpriseBase+3000,52,ExLocal.LStock);
                Execute;

                If ValidStatus and DataChanged then
                  RoQty:=EntSysObj.Stock.stReOrderQty;
              end;


              If (LeadTime>0) then {Set Delivery date based on lead time}
              Begin
                RoDate:=CalcDueDatexDays(Today,LeadTime);
              end;  *)


              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

              Report_BError(Fnum,Status);

              Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

              If (StatusOk) and (Not EmptyKey(StkLocFilt,LocKeyLen)) then
                Update_LocROTake(Stock,StkLocFilt,0);

            end; {If Locked..}

          end;

        end; {If Wrong type..}

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}
    finally
      {$IFDEF CU}
        ExLocal.Destroy;

        ROLineCU.Free;
      {$ENDIF}

    end;

    MsgForm.Free;

    Set_BackThreadMVisible(BOff);


  end; {Proc..}



Procedure ResetOrderQty(Fnum,Keypath  :  Integer;
                        StkLocFilt    :  Str10);

Var
  KeyS       :  Str255;

  LOk,
  Locked     :  Boolean;

  LAddr      :  LongInt;


Begin
  LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

  If (LOk) and (Locked) then
  With Stock do
  Begin

    RoQty:=0;

    RoFlg:=BOff;

    Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

    Report_BError(Fnum,Status);

    Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

    If (StatusOk) and (Not EmptyKey(StkLocFilt,LocKeyLen)) then
      Update_LocROTake(Stock,StkLocFilt,0);

  end; {If Locked..}
end; {Proc..}



{ ========== Build runtime view ======== }

procedure TStkReOrd.BuildDesign;


begin


end;


procedure TStkReOrd.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  CostPriceF.DecPlaces:=Syss.NoCosDec;
  FreeStk.DecPlaces:=Syss.NoQtyDec;
  MinStk.DecPlaces:=Syss.NoQtyDec;
  OnOrd.DecPlaces:=Syss.NoQtyDec;
  Need.DecPlaces:=Syss.NoQtyDec;
  OrdQty.DecPlaces:=Syss.NoQtyDec;

  {$IFDEF MC_On}
    Set_DefaultCurr(CostCurr.Items,BOff,BOff);
    Set_DefaultCurr(CostCurr.ItemsL,BOff,BOn);
  {$ELSE}
    CostCurr.Visible:=BOff;
    CostPriceF.Left:=CostCurr.Left;
  {$ENDIF}

  {$IFNDEF PF_On}
    HideCC:=BOff;
  {$ELSE}
    HideCC:=Syss.UseCCDep;
  {$ENDIF}

  SRCCF.Visible:=HideCC;
  SRDepF.Visible:=HideCC;

  If (Not HideCC) then
  Begin
    CCLab.Caption:='Delivery Date';
    I1TransDateF.Left:=SRCCF.Left;
  end;

  If (Back2Back) then
    MinLab.Caption:='Back Order';

  BuildDesign;

end;


procedure TStkReOrd.SetCaption;

Begin
  Caption:='Stock Re-Order Item. ';

  {$IFDEF SOP}
    If (Not EmptyKey(StkLocFilt,LocKeyLen)) then
      Caption:=Caption+'- Locn : '+StkLocFilt+'. ';

  {$ENDIF}

  With ExLocal.LStock do
    Caption:=Caption+dbFormatName(StockCode,Desc[1]);
end;

procedure TStkReOrd.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;
  FirstEdit:=BOn;

  SKeypath:=0;

  ClientHeight:=179;
  ClientWidth:=427;

  With TForm(Owner) do
    Self.Left:=Left+2;


  Back2Back:=StkROB2B;
  GenWORQty:=StkROGWOR;


  If (Owner is TStkList) then
  With TStkList(Owner) do
  Begin
    Self.SetFieldProperties(ROSPanel);

  end;

  StkLocFilt:='';

  FormDesign;

end;


procedure TStkReOrd.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TStkReOrd.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,113);

end;


procedure TStkReOrd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TStkReOrd.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TStkReOrd.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TStkReOrd.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TStkReOrd.Send_UpdateList(Edit   :  Boolean;
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



Function TStkReOrd.CheckNeedStore  :  Boolean;

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


Procedure TStkReOrd.SetFieldFocus;

Begin
  If (OrdQty.CanFocus) then
    OrdQty.SetFocus;
end; {Proc..}




Function TStkReOrd.ConfirmQuit  :  Boolean;

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
                StoreId(StockF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(StockF,LastRecAddr[StockF]);

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




{ ============== Display Id Record ============ }

Procedure TStkReOrd.OutId(UpLink  :  Boolean);


Var
  TBo,
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  KeyS      :  Str255;

  TmpStk    :  StockRec;


Begin
  With ExLocal,LStock do
  Begin
    If (UpLink) then
      Stock_LocROSubst(LStock,StkLocFilt);

    FreeStk.Value:=CaseQty(LStock,FreeStock(LStock));
    If (Back2Back) then
      MinStk.Value:=CaseQty(LStock,AllocStock(LStock))
    else
      MinStk.Value:=CaseQty(LStock,QtyMin);

    OnOrd.Value:=CaseQty(LStock,QtyOnOrder+(QtyAllocWOR*Ord(GenWORQty and (StockType=StkBillCode))));

    TmpStk:=LStock;

    Stock_LocSubst(TmpStk,StkLocFilt);

    Need.Value:=CaseQty(LStock,Stk_SuggROQ(TmpStk,Back2Back,GenWORQty and (StockType=StkBillCode)));


    If (ROQty=0.0) and (JustCreated) then
    Begin

      ROQty:=Stk_SuggROQ(TmpStk,Back2Back,GenWORQty and (StockType=StkBillCode));

      RODate:=CalcDueDatexDays(Today,LeadTime);

      JustCreated:=BOff;
    end;

    OrdQty.Value:=CaseQty(LStock,ROQty);

    StkDesc.Text:=Desc[1];
    PrefSupp.Text:=SuppTemp;

    FoundOk:=GetCust(Self,SuppTemp,FoundCode,BOff,-1);

    Company.Text:=Cust.Company;

    {$IFDEF MC_On}
       If (RoCurrency>0) then
         CostCurr.ItemIndex:=Pred(ROCurrency);
    {$ENDIF}

    CostPriceF.Value:=ROCPrice;

    {For TBo:=BOff to BOn do v4.32 Method
    Begin
      If (EmptyKey(ROCCDep[TBo],ccKeyLen)) then
        ROCCDep[TBo]:=LStock.CCDep[TBo];

      If (EmptyKey(ROCCDep[TBo],ccKeyLen)) then
        Case TBo of
          BOff  :  ROCCDep[TBo]:=LCust.CustCC;
          BOn   :  ROCCDep[TBo]:=LCust.CustDep;
        end; {Case..
    end;}


    SRCCF.Text:=ROCCDep[BOn];
    SRDepF.Text:=ROCCDep[BOff];

    If (RODate='') then
      RODate:=Today;

    I1TransDateF.DateValue:=RODate;

  end;

end;


procedure TStkReOrd.Form2Id;

Var
  TmpId  :  IDetail;

Begin

  With EXLocal,LStock do
  Begin
    SetE2CId(TmpId,LStock);

    ROQty:=Case2Ea(TmpId,LStock,OrdQty.Value);


    {$IFDEF MC_On}
      If (CostCurr.ItemIndex>=0) then
        ROCurrency:=Succ(CostCurr.ItemIndex);
    {$ENDIF}

    RODate:=I1TransDateF.DateValue;
    SuppTemp:=FullCustCode(PrefSupp.Text);
    ROCPrice:=CostPriceF.Value;
    ROCCDep[BOn]:=SRCCF.Text;
    ROCCDep[BOff]:=SRDepF.Text;

  end; {with..}

end; {Proc..}





procedure TStkReOrd.SetIdStore(EnabFlag,
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

procedure TStkReOrd.ProcessId(Fnum,
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
      AddCh:=Esc;
  end;


  If (Addch<>Esc) then
  begin


    OutId(BOn);

  end; {If Abort..}

  SetIdStore(BOn,ExLocal.LViewOnly);

  SetFieldFocus;

  FieldNextFix(Self.Handle,ActiveControl,Nil);

end; {Proc..}




Function TStkReOrd.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  4;


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

  PossMsg^[1]:='That Supplier does not exist!';
  PossMsg^[2]:='Cost Centre Code not Valid.';
  PossMsg^[3]:='Department Code not Valid.';
  PossMsg^[4]:='Re-Order Currency Not Valid.';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal, LStock do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=EmptyKey(SuppTemp,CustKeyLen);

              If (Not Result) then
                Result:=GetCust(Self,SuppTemp,FoundCode,BOff,-1);

            end;

      {$IFDEF PF_On}
        2,3

           :  {$B-}
                Result:=((Not Syss.UseCCDep) or GetCCDep(Self,ROCCDep[(Test=2)],FoundCode,(Test=2),-1));
              {$B+}

      {$ENDIF}

      {$IFDEF MC_On}

        4  :  Result:=(ROCurrency In [CurStart..CurrencyType]);


      {$ENDIF}

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}




procedure TStkReOrd.StoreId(Fnum,
                            Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpStk
       :  StockRec;

  KeyS :  Str255;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LStock do
  Begin


    COk:=CheckCompleted(LastEdit,BOff);


    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      ROFlg:=(ROQty<>0.0);

      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpStk:=LStock;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LStock:=TmpStk;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end;

      Report_BError(Fnum,Status);


      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      If (StatusOk) and (Not EmptyKey(StkLocFilt,LocKeyLen)) then
        Update_LocROTake(LStock,StkLocFilt,0);

      IdStored:=BOn;

      SetIdStore(BOff,BOff);

      Send_UpdateList(LastEdit,1);

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;




procedure TStkReOrd.EditLine(Edit,
                             VO         :  Boolean;
                             Keypath    :  Integer;
                             SFilt      :  Str10);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    LViewOnly:=VO;

    AssignFromGlobal(StockF);

    StkLocFilt:=SFilt;

    SetCaption;

    ProcessId(StockF,KeyPath,LastEdit);
  end;
end;



procedure TStkReOrd.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) and (FormStyle<>fsNormal) then
    Begin
      StoreId(StockF,SKeypath);
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


procedure TStkReOrd.PrefSuppExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  Flg,
  FoundOk,
  AltMod     :  Boolean;

  RODiscChr  : Char;
  Rnum,
  RODisc
             : Real;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (AltMod) and (ActiveControl<>CanCP1Btn)  and (FoundCode<>'') then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOff,0));


      If (FoundOk) then
      With ExLocal,LStock do
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

        Form2Id;


        Flg:=(ROCPrice=0);

        Rnum:=0;

        {$IFDEF MC_On}
          ROCurrency:=Cust.Currency;
        {$ENDIF}

        Calc_StockPrice(LStock,Cust,ROCurrency,ROQty,Today, Rnum,RODisc,RODiscChr,StkLocFilt,Flg, 0);

        ROCPrice:=Round_Up(Rnum-Calc_PAmount(Rnum,RODisc,RODiscChr),Syss.NoCosDec);

        OutId(BOff);

      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;

procedure TStkReOrd.SRCCFExit(Sender: TObject);
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
          (Syss.UseCCDep) or (FoundCode='') then
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



procedure TStkReOrd.OrdQtyEnter(Sender: TObject);

begin
  Form2Id;
  With ExLocal,LStock do
  Begin

    If (Not FirstEdit) then
      LastQty:=ROQty
    else
      FirstEdit:=JustCreated;

  end; {With..}


end;

procedure TStkReOrd.OrdQtyExit(Sender: TObject);

Var
  Flg,
  FoundOk   :  Boolean;
  FoundCode :  Str20;

  RODiscChr :  Char;
  RODisc,
  Rnum      :  Real;

begin
  Form2Id;

  With ExLocal,LStock do
  Begin
    If (LastQty<>OrdQty.Value) then
    Begin
    
      {$IFDEF CU} {* Call hooks here *}
        ROQty:=ValueExitHook(3000,51,ROQty,ExLocal);
     {$ENDIF}


      If (Cust.CustCode<>SuppTemp) then
        FoundOk:=GetCust(Self,SuppTemp,Foundcode,BOff,-1);

      Flg:=BOff;
      Rnum:=0;

      Calc_StockPrice(LStock,Cust,ROCurrency,ROQty,Today,Rnum,RODisc,RODiscChr,StkLocFilt,Flg, 0);

      If (Flg) then
        ROCPrice:=Round_Up(Rnum-Calc_PAmount(Rnum,RODisc,RODiscChr),Syss.NoCosDec);;

      OutId(BOff);

    end;
  end; {With..}
end;


Initialization

  StkROB2B:=BOff;

end.
