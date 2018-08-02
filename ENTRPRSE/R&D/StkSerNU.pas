unit StkSerNU;

{$I DEFOVR.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Mask,

  GlobVar,VarConst,ExWrap1U,CmpCtrlU, bkgroup;


type
  TStkSerNo = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    ODF: TEditDate;
    InF: Text8Pt;
    InCF: TSBSComboBox;
    UCF: TCurrencyEdit;
    OutF: Text8Pt;
    OutCF: TSBSComboBox;
    USF: TCurrencyEdit;
    SNoF: Text8Pt;
    BNoF: Text8Pt;
    OQF: TCurrencyEdit;
    AQF: TCurrencyEdit;
    UQF: TCurrencyEdit;
    SBSPanel1: TSBSBackGroup;
    Label88: Label8;
    Label89: Label8;
    SBSPanel2: TSBSBackGroup;
    Label810: Label8;
    CurrLab1: Label8;
    Label87: Label8;
    CurrLab2: Label8;
    Label85: Label8;
    Label811: Label8;
    Label812: Label8;
    Label82: Label8;
    Label81: Label8;
    UseLab: Label8;
    LocInF: Text8Pt;
    LocOutF: Text8Pt;
    InLocLab: Label8;
    OutLocLab: Label8;
    Label83: Label8;
    UBF1: TEditDate;
    Label84: Label8;
    BCF1: Text8Pt;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SNoFExit(Sender: TObject);
    procedure BNoFExit(Sender: TObject);
    procedure OQFEnter(Sender: TObject);
    procedure LocInFExit(Sender: TObject);
    procedure BNoFEnter(Sender: TObject);
    procedure BCF1Exit(Sender: TObject);
  private
    { Private declarations }

    CompInp,
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;


    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Procedure OutId;

    procedure Form2Id;

    procedure SetCaption;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    StockR     :  StockRec;

    DocCostP   :  Double;

      {* Used to control variation of behavior when returning sales stock, as this is stock we get back temporarily.
         25 = set already sold stock to returned. Mark as returned internaly, which will prevent it from being unused
         26 = Un sell, and return to stock, reseting any returned stock flag *}
      SerRetMode,
    SerMode    :  Byte;

    SerialReq  :  Double;

    ExLocal    :  TdExLocal;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;


    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(RStock     :  StockRec;
                       Edit,
                       VO         :  Boolean);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer;
                            RStock   :  StockRec);

  end;



Procedure SERN_SetLink(InvR   :  InvRec;
                       IdR    :  Idetail;
                   Var DocRef,
                       OrdRef :  Str10;
                   Var DocLNo,
                       OrdLNo :  LongInt;
                   Var LineLoc:  Str10);

Function GetStkBNC(TStkFolio  :  LongInt)  :  LongInt;

Function Ser_CalcCrCost(ICr      :  Byte;
                        TMisc    :  MiscRec)  :  Double;

Procedure SERN_SetUse(Fnum,
                      Keypath  :  Integer;
                  Var SerialR,
                      DocPCost :  Double;
                      InvR     :  InvRec;
                      IdR      :  IDetail;
                      SerRetMode
                               :  Byte);

Procedure Un_UseBatch(BRef  :  Str20;
                      SFolio,
                      NFolio:  LongInt;
                      QtyU  :  Double;
                      PInLoc:  Str10;
                      Fnum,
                      Keypath,
                      KeyPath2
                            :  Integer);

Procedure Make_BatchSetUse(Fnum,KeyPath  :  Integer;
                           InvR          :  InvRec;
                           IdR           :  IDetail;
                           QtyB          :  Double;
                           LAddr         :  LongInt;
                           SerRetMode
                                    :  Byte);

Procedure Batch_SetUse(Fnum,
                       Keypath,
                       CurrLine :  Integer;
                   Var SerialR,
                       DocPCost :  Double;
                       InvR     :  InvRec;
                       IdR      :  IDetail;
                        SerRetMode
                                :  Byte);


Procedure SERN_SetRet(Fnum,
                      Keypath  :  Integer;
                  Var SerialR,
                      DocPCost :  Double;
                      InvR     :  InvRec;
                      IdR      :  IDetail;
                      RetMode  :  Byte);

Function CheckSNOExsists(RT,SP     :  Char;
                         StkFolio  :  LongInt;
                         SKey      :  Str20)   :  Boolean;

Function Check4DupliSNO(RT,SP     :  Char;
                        StkFolio  :  LongInt;
                        SKey      :  Str20)   :  Boolean;


Procedure Set_ModalMode(MM,CI  :  Boolean);

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
  VARRec2U,
  CurrncyU,
  ComnUnit,
  ComnU2,


  ColCtrlU,

  SysU1,
  SysU2,

  {$IFNDEF EXDLL}
    StockU,
  {$ENDIF}

  {$IFDEF SOPDLL}
    StockU,
  {$ENDIF}

  InvListU,

  PWarnU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  PayF2U,

  {PayLineU,}

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,
  {$ENDIF}

  ThemeFix,

  Saltxl1U;




{$R *.DFM}



Var
  ModalMode,
  ModalInp  :  Boolean;


Procedure Set_ModalMode(MM,CI  :  Boolean);

Begin
  ModalMode:=MM;
  ModalInp:=CI;

end;

{ ========== Build runtime view ======== }

procedure TStkSerNo.BuildDesign;


begin


end;


procedure TStkSerNo.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  UCF.DecPlaces:=Syss.NoCosDec;
  USF.DecPlaces:=Syss.NoNetDec;
  OQF.DecPlaces:=Syss.NoQtyDec;
  AQF.DecPlaces:=Syss.NoQtyDec;
  UQF.DecPlaces:=Syss.NoQtyDec;

  {$IFDEF MC_On}
    Set_DefaultCurr(IncF.Items,BOff,BOff);
    Set_DefaultCurr(IncF.ItemsL,BOff,BOn);
    Set_DefaultCurr(OutcF.Items,BOff,BOff);
    Set_DefaultCurr(OutcF.ItemsL,BOff,BOn);


  {$ELSE}
    IncF.Visible:=BOff;
    OutcF.Visible:=BOff;
    CurrLab1.Visible:=BOff;
    CurrLab2.Visible:=BOff;
  {$ENDIF}


  If (Not Syss.UseMLoc) then
  Begin
    LocInF.Visible:=BOff;
    LocOutF.Visible:=BOff;
    InLocLab.Visible:=BOff;
    OutLocLab.Visible:=BOff;
  end;

  
  SNoF.MaxLength:=SNoKeyLen;
  BNoF.MaxLength:=BNoKeyLen;
  InF.MaxLength:=DocKeyLen;
  OutF.MaxLength:=DocKeyLen;

  If (FormStyle=fsNormal) and (Not CompInp) then
  Begin
    UseLab.Visible:=BOn;
    UQF.Visible:=BOn;
    ActiveControl:=UQF;
  end
  else
  Begin
    UBF1.Left:=UQF.Left-3;
    UBF1.Top:=UQF.Top;
    Label83.Top:=UseLab.Top;
    Label83.Left:=UBF1.Left+3;
  end;

  BuildDesign;

end;




procedure TStkSerNo.FormCreate(Sender: TObject);
begin
  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=263;
  ClientWidth:=383;

  DocCostP:=0;
  SerMode:=4;


  SerRetMode:=0;

  SerialReq:=0;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TStockRec) then
    With TStockRec(Owner) do
    Begin
      Self.SetFieldProperties(SNoPanel);

      If (SerUseMode) then
        SerMode:=5;

      Self.SerRetMode:=SerRetMode;

    end;

  CompInp:=ModalInp;

  If (ModalMode) then
  Begin
    FormStyle:=fsNormal;
    Visible:=BOff;
  end
  else
    FormStyle:=fsMDIChild;

  FormDesign;

end;




procedure TStkSerNo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,103);

end;

procedure TStkSerNo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TStkSerNo.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TStkSerNo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TStkSerNo.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TStkSerNo.Send_UpdateList(Edit   :  Boolean;
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



Function TStkSerNo.CheckNeedStore  :  Boolean;

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


Procedure TStkSerNo.SetFieldFocus;

Begin
  If (SNoF.CanFocus) then
    SNoF.SetFocus;
end; {Proc..}




Function TStkSerNo.ConfirmQuit  :  Boolean;

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
                StoreId(MiscF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(MiscF,LastRecAddr[MiscF]);

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

Procedure TStkSerNo.OutId;

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  KeyS      :  Str255;


Begin
  With ExLocal,LMiscRecs^.SerialRec do
  Begin
    SNoF.Text:=Strip('R',[#32],SerialNo);
    BNoF.Text:=Strip('R',[#32],BatchNo);
    InF.Text:=InDoc;
    OutF.Text:=OutDoc;

    {$IFDEF MC_On}
       If (CurCost>0) then
         IncF.ItemIndex:=Pred(CurCost);

       If (CurSell>0) then
         OutcF.ItemIndex:=Pred(CurSell);
    {$ENDIF}

    LocInF.Text:=InMLoc;
    LocOutF.Text:=OutMLoc;

    If PChkAllowed_In(143) then
      UCF.Value:=SerCost
    else
      UCF.Value:=0.0;

    USF.Value:=SerSell;

    ODF.DateValue:=DateOut;
    UBF1.DateValue:=DateUseX;

    OQF.Value:=BuyQty;
    AQF.Value:=BuyQty-QtyUsed;

    BCF1.Text:=InBinCode;
  end;

end;


procedure TStkSerNo.Form2Id;

Begin

  With EXLocal,LMiscRecs^.SerialRec do
  Begin
    SerialNo:=LJVar(UpCaseStr(SNoF.Text),SNoKeyLen);
    BatchNo:=LJVar(UpCaseStr(BNof.Text),BNoKeyLen);
    InDoc:=UpCaseStr(InF.Text);
    OutDoc:=UpCaseStr(OutF.Text);

    {$IFDEF MC_On}
      If (IncF.ItemIndex>=0) then
        CurCost:=Succ(IncF.ItemIndex);

      If (OutcF.ItemIndex>=0) then
        CurSell:=Succ(OutcF.ItemIndex);

      If (CurCost<>LastMisc^.SerialRec.CurCost) then
      Begin
        SerCRates:=SyssCurr^.Currencies[CurCost].CRates;
        SetTriRec(CurCost,SUseORate,SerTriR);
      end;
    {$ENDIF}

    DateOut:=ODF.DateValue;
    DateUseX:=UBF1.DateValue;

    If PChkAllowed_In(143) then
      SerCost:=UCF.Value;

    SerSell:=USF.Value;


    InMLoc:=LocInF.Text;
    OutMLoc:=LocOutF.Text;

    BuyQty:=OQF.Value;

    InBinCode:=BCF1.Text;

  end; {with..}

end; {Proc..}





procedure TStkSerNo.SetIdStore(EnabFlag,
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

  {$IFDEF X32}
    Removed, as when processing a stock take, you should be allowed into the cost.
    If (SerMode=5) and (Not ExLocal.LastEdit) then
    Begin
      UCF.ReadOnly:=BOn;
      UCF.TabStop:=BOff;

      {$IFDEF MC_On}
         InCF.ReadOnly:=BOn;
         InCF.TabStop:=BOff;

      {$ENDIF}
    end;

  {$ENDIF}
end;


procedure TStkSerNo.SetCaption;


Begin
  With ExLocal,LMiscRecs^,SerialRec do
  Begin
    Caption:='Serial/Batch : '+Strip('B',[#32],SerialNo);

    If (BatchNo<>'') then
      Caption:=Caption+'/'+Strip('B',[#32],BatchNo);
  end;
end;

(*  Add is used to add Notes *)

procedure TStkSerNo.ProcessId(Fnum,
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

      SetCaption;

    end;

    If (Not Ok) or (Not GlobLocked) then
      AddCh:=Esc;
  end;


  If (Addch<>Esc) then
  With ExLocal,LMiscRecs^,SerialRec do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecMfix:=MFIFOCode;
      SubType:=MSERNSub;

      StkFolio:=StockR.StockFolio;

      InBinCode:=StockR.BinLoc;

      NLineCount:=1;

      If (SerMode=5) then
      Begin
        SERN_SetLink(LInv,LId,InDoc,InOrdDoc,BuyLine,InOrdLine,InMLoc);

        CurCost:=LInv.Currency;

        SerCost:=DocCostP;

        SerCRates:=LInv.CXRate;
        SerTriR:=LInv.CurrTriR;


        With LId do
        If (Not EmptyKey(JobCode,JobKeyLen)) and (Not EmptyKey(AnalCode,AnalKeyLen)) and (Not (IdDocHed In StkAdjSplit)) then {Force serial to be out as well}
        Begin
          OutDoc:=InDoc; OutOrdDoc:=InOrdDoc;
          OutOrdLine:=InOrdLine;
          SoldLine:=BuyLine;

          DateOut:=LId.PDate;

          CurSell:=CurCost;
          SerSell:=SerCost;

          
          OutMLoc:=InMLoc;

        end;

        If (SerCRates[BOff]=0.0) then
        Begin
          SerCRates[BOff]:=SyssCurr^.Currencies[CurCost].CRates[BOff];
          SetTriRec(CurCost,SUseORate,SerTriR);
        end;

      end
      else
      Begin
        {$IFDEF MC_On}
          CurCost:=1;
          CurSell:=1;
        {$ENDIF}
      end;


    end;

    LastMisc^:=LMiscRecs^;

    OutId;

  end; {If Abort..}

  SetIdStore(BOn,ExLocal.LViewOnly);

end; {Proc..}




Function TStkSerNo.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  7;
  Fnum         =  MiscF;
  Keypath      =  MIK;


Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  KeyS     :  Str255;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop,
  TmpBo,
  ShowMsg  :  Boolean;

  mbRet    :  Word;


Begin
  New(PossMsg);
  ShowMsg := False;
  TmpBo := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That Serial No. exists already!';
  PossMsg^[2]:='You must complete the Serial No. or Batch No.!';
  PossMsg^[3]:='Cost Currency not Valid.';
  PossMsg^[4]:='Sales Currency not Valid.';
  PossMsg^[5]:='In Location not Valid.';
  PossMsg^[6]:='Out Location not Valid.';
  PossMsg^[7]:='You must complete the Bin Location Code';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal, LMiscRecs^,SerialRec do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=((Not EmptyKey(SerialNo,SNoKeyLen)) or (Not EmptyKey(BatchNo,BNoKeyLen)));

              If (Result) and (Not EmptyKey(SerialNo,SNoKeyLen)) and (Not Edit) then
                Result:=Not CheckSNoExsists(RecMfix,SubType,StkFolio,SerialNo);

            end;

      2  :  Result:=(Not (EmptyKey(SerialNo,SNoKeyLen)) or (Not EmptyKey(BatchNo,BNoKeyLen)));


      {$IFDEF MC_On}

        3  :  Result:=(CurCost In [CurStart..CurrencyType]);

        4  :  Result:=(CurSell In [CurStart..CurrencyType]);


      {$ENDIF}

      {$IFDEF SOP}
        5,6  :  If (Syss.UseMLoc) then
                Begin
                  Case Test of
                    5  :  Begin
                            FoundCode:=InMLoc;
                            TmpBo:=EmptyKey(InDoc,DocKeyLen);
                          end;
                    6  :  Begin
                            FoundCode:=OutMLoc;
                            TmpBo:=EmptyKey(OutDoc,DocKeyLen);
                          end;
                  end; {Case..}


                    If (Not TmpBo) then
                      TmpBo:=Global_GetMainRec(MLocF,Quick_MLKey(FoundCode));

                    Result:=TmpBo;
                end;
      {$ENDIF}

      7  :  Result:=((InBinCode<>'') or (Not StockR.MultiBinMode));

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}




procedure TStkSerNo.StoreId(Fnum,
                            Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpMisc
       :  MiscRec;

  KeyS :  Str255;




Begin
  KeyS:='';

  Form2Id;

  COk:=BOn;

  With ExLocal,LMiscRecs^,SerialRec do
  Begin
    {$IFDEF CU}
      COk:=ValidExitHook(3100,4,ExLocal);
    {$ENDIF}



    If (LastEdit) and (LastMisc^.SerialRec.SerialNo<>SerialNo) then
    Begin
      {$B-}
        COk:=(COk and (Not Check4DupliGen(FullQDKey(RecMfix,SubType,SerialNo),Fnum,MiscNDXK,'Serial No.')));
      {$B+}
    end
    else
      COk:=BOn;

    If (COk) then
      COk:=CheckCompleted(LastEdit,BOff);


    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      

      With LId do
        If (Not EmptyKey(JobCode,JobKeyLen)) and (Not EmptyKey(AnalCode,AnalKeyLen)) and (BatchRec) and (Not EmptyKey(OutDoc,DocKeyLen))
        and (Not LastEdit) and (Not (IdDocHed In StkAdjSplit)) then {Force serial to be out as well}
        Begin
          QtyUsed:=BuyQty;

        end;

      // MH 13/03/2012 v6.10 ABSEXCH-10123: Added rounding to fix issue where 0.0 qty batches are still shown as available
      Sold:=(((Not EmptyKey(OutDoc,DocKeyLen)) and (Not BatchRec)) or
              ((Round_Up(BuyQty-QtyUsed,Syss.NoQtyDec)<=0) and (BatchRec))) ;

      SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);

      If (BatchRec) and (NoteFolio=0) and (Not BatchChild) then {* Assign Notefolio's
                                              early to help with multiple batches *}
        NoteFolio:=GetNextCount(SKF,BOn,BOff,0);


      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpMisc:=LMiscRecs^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LMiscRecs^:=TmpMisc;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end
      else
      Begin
        

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        If (Not BatchRec) then
          SerialReq:=Round_Up(SerialReq-Ord(SerMode=5),Syss.NoQtyDec);

        SetCaption;
      end;

      Report_BError(Fnum,Status);

      If (StatusOk) then
      Begin
        If (BatchRec) and (SerMode=5) then
          SerialReq:=Round_Up(SerialReq-BuyQty+LastMisc^.SerialRec.BuyQty,Syss.NoQtyDec);

      end;

      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      IdStored:=BOn;

      SetIdStore(BOff,BOff);

      Send_UpdateList(LastEdit,18);

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TStkSerNo.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TStkSerNo.EditLine(RStock     :  StockRec;
                             Edit,
                             VO         :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    LViewOnly:=VO;

    StockR:=RStock;

    AssignFromGlobal(MiscF);

    ProcessId(MiscF,MIK,LastEdit);
  end;
end;



procedure TStkSerNo.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) and ((FormStyle<>fsNormal) or (CompInp)) then
    Begin
      // Move focus to OK button to force OnExit validation/formatting to kick in
      If OkCP1Btn.CanFocus Then
        OkCP1Btn.SetFocus;
      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = OkCP1Btn) Then
      begin
        StoreId(MiscF,SKeypath);
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


procedure TStkSerNo.DeleteBOMLine(Fnum,
                                KeyPath  :  Integer;
                                RStock   :  StockRec);

Var
  MbRet  :  Word;
  GotRec :  Integer;
  KeyS   :  Str255;

Begin
  With ExLocal do
  Begin
    StockR:=RStock;
    AssignFromGlobal(Fnum);
    LGetRecAddr(Fnum);
    OutId;
    OKCP1Btn.Enabled:=BOff;
    CanCP1Btn.Enabled:=BOff;

    MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Line',
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

          {$IFDEF NP}
            With LMiscRecs^.SerialRec  do
              If (NoteFolio<>0) then
                Delete_Notes(NoteRCode,FullNCode(FullNomKey(NoteFolio)));
          {$ENDIF}

        end;

        If (StatusOk) then
        With LMiscRecs^.SerialRec do
        Begin
          If (BatchRec) and (SerMode=5) then
          Begin
            If (Not BatchChild) then
              SerialReq:=Round_Up(SerialReq+BuyQty,Syss.NoQtyDec)
            else
            Begin
              SerialReq:=Round_Up(SerialReq+(QtyUsed*DocNotCnst),Syss.NoQtyDec);

              Un_UseBatch(BatchNo,StkFolio,ChildNFolio,QtyUsed,OutMLoc,Fnum,MiscBtcK,KeyPath);
            end;
          end
          else
           SerialReq:=Round_Up(SerialReq+Ord(SerMode=5),Syss.NoQtyDec);

          Send_UpdateList(BOff,19);


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}



procedure TStkSerNo.SNoFExit(Sender: TObject);

Var
  COk   :  Boolean;
  CCode :  Str20;


begin
  If (Sender is TMaskEdit) then
  With (Sender as TMaskEdit),ExLocal,LMiscRecs^ do
  Begin
    Text:=UpCaseStr(Text);

    CCode:=LJVar(Text,SNoKeyLen);

    If ((Not LastEdit) or (LastMisc^.SerialRec.SerialNo<>CCode)) and (InAddEdit) and (Not EmptyKey(CCode,SNoKeyLen)) then
    Begin
      {COk:=(Not Check4DupliGen(FullQDKey(RecMfix,SubType,CCode),MiscF,MiscNDXK,'Serial No. ('+Strip('B',[#32],CCode)+')'));}

      COk:=(Not Check4DupliSNo(RecMfix,SubType,SerialRec.StkFolio,CCode));

      If (Not COk) then
      Begin

        If (CanFocus) then
          SetFocus;
      end;

    end;
    SerialRec.BatchRec:=EmptyKey(SnoF.Text,SnoKeyLen);
  end;
end;


procedure TStkSerNo.BNoFEnter(Sender: TObject);
begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin

  {$IFDEF CU}
    If (Not ReadOnly) and (Not ExLocal.LastEdit) then
      Text:=TextExitHook(3100,1,Trim(Text),ExLocal);
  {$ENDIF}
  end;
end;



procedure TStkSerNo.BNoFExit(Sender: TObject);
Var
  AltMod     :  Boolean;

begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    Text:=UpCaseStr(Text);

    AltMod:=Modified; {* For some reason altmod not set when entering alpha chars! *}

    With ExLocal,LMiscRecs^.SerialRec do
    Begin
      BatchRec:=EmptyKey(SnoF.Text,SnoKeyLen);

      If (InAddEdit) and (Not LastEdit) and (BatchRec) then
      Begin
        OQF.Value:=SerialReq;

        
      end;
    end;
  end; {with..}
end;

procedure TStkSerNo.OQFEnter(Sender: TObject);
begin
  OQF.ReadOnly:=Not Exlocal.LMiscRecs^.SerialRec.BatchRec;
end;


procedure TStkSerNo.LocInFExit(Sender: TObject);
Var
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;

  BalNow     :  Double;

begin
  {$IFDEF SOP}
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn)  and
    (((Sender=LocInF) and (InF.Text<>'')) or ((Sender=LocOutF) and (OutF.Text<>''))) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,'',0));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(MLocF);


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

procedure TStkSerNo.BCF1Exit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str20;

  HookFail,
  AltMod:  Boolean;


begin
  HookFail:=BOff;

  If (Sender is TMaskEdit) and (ActiveControl<>CanCP1Btn) then
  With (Sender as TMaskEdit),ExLocal,LMiscRecs^.SerialRec do
  Begin
    {$IFDEF CU}
      If (Not ReadOnly) then
      Begin
        InBinCode:=Trim(Text);

        HookFail:=Not ValidExitHook(3100,3,ExLocal);

        If (Not HookFail) then
          Text:=InBinCode;
      end;
    {$ENDIF}

  end;

end;



  { ==== Proc to Set up the Serial No. Link ==== }

Procedure SERN_SetLink(InvR   :  InvRec;
                       IdR    :  Idetail;
                   Var DocRef,
                       OrdRef :  Str10;
                   Var DocLNo,
                       OrdLNo :  LongInt;
                   Var LineLoc:  Str10);



Begin

  With IdR do
  Begin

    If (SOPLink<>0) then
    Begin
      DocRef:=SOP_GetSORNo(SopLink);

      DocLNo:=SOPLineNo;

    end;

    DocRef:=InvR.OurRef;


    If (LineNo=StkLineNo) and (ABSLineNo=0) and (IdDocHed=ADJ) and (SOPLineNo<>0) then
      DocLNo:=IdR.SOPLineNo
    else
      DocLNo:=IdR.ABSLineNo;

    If (Syss.UseMLoc) then
      LineLoc:=MLocStk;

  end; {With..}
end; {Proc..}


{ == These two routines duplicated in Revalu2U, for thread safe == }

Function GetStkBNC(TStkFolio  :  LongInt)  :  LongInt;

  Const
    Fnum    =  StockF;
    KPath2  =  StkFolioK;


  Var
    TmpStk  :  StockRec;

    LastStat,
    TmpStat,
    Keypath :  Integer;
    TmpRecAddr
            :  Longint;

    KeyS    :  Str255;


  Begin

    If (Stock.StockFolio=TStkFolio) then
      GetStkBNC:=Stock.NomCodes[4]
    else
    Begin
      LastStat:=Status;
      TmpStk:=Stock;
      Keypath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOff,BOff);

      KeyS:=FullNomKey(TStkFolio);

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Kpath2,KeyS);

      If (StatusOk) then
        GetStkBNC:=Stock.NomCodes[4]
      else
        GetStkBNC:=0;

      TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[Fnum],TmpRecAddr,BOn,BOff);

      Stock:=TmpStk;
      Status:=LastStat;
    end;

  end;


  Function Ser_CalcCrCost(ICr      :  Byte;
                          TMisc    :  MiscRec)  :  Double;


  Var
    UseRate  :  Boolean;
    NewAmnt  :  Double;


  Begin
    UseRate:=UseCoDayRate;
    NewAmnt:=0.0;

    With TMisc.SerialRec do
    Begin
      {$IFDEF MC_On}
        If (Not RevalueStk(GetStkBNC(TMisc.SerialRec.StkFolio))) and (SerCRates[UseRate]<>0.0) then
        Begin
          NewAmnt:=Conv_TCurr(SerCost,SerCRates[UseRate],CurCost,SUseORate,BOff);

          With SyssCurr^.Currencies[ICr] do
            Ser_CalcCrCost:=Conv_TCurr(NewAmnt,CRates[UseRate],ICr,0,BOn);


        end
        else
      {$ENDIF}

          Ser_CalcCrCost:=Currency_ConvFT(SerCost,CurCost,ICr,UseRate);


    end;
  end;


  Procedure SERN_AutoAddNotes(Var MNRec  :  MiscRec;
                                  Mode   :  Byte;
                                  MNote  :  Str255);

  Begin
    With MiscRecs^.SerialRec do
    Begin
      {$IFDEF NP}
        If (NoteFolio=0) then {* Assign Note Folio *}
          NoteFolio:=GetNextCount(SKF,BOn,BOff,0);


        Add_Notes(NoteRCode,NoteCDCode,FullNomKey(NoteFolio),Today,
            MNote,
            NLineCount);

        Inc(NLineCount);
      {$ENDIF}
    end; {With..}
  end;


{ ========= Proc to Set RO-Details from FIFO List ======== }

Procedure SERN_SetUse(Fnum,
                      Keypath  :  Integer;
                  Var SerialR,
                      DocPCost :  Double;
                      InvR     :  InvRec;
                      IdR      :  IDetail;
                      SerRetMode
                               :  Byte);


Var
  Locked  :  Boolean;
  LAddr   :  LongInt;
  mbRet   :  Word;
  GenStr  :  Str255;
  SameDoc : Boolean;

Begin

  Locked:=BOff;  GenStr:='';

  With MiscRecs^.SerialRec do
  Begin
    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,KeyPath,Fnum,BOn,Locked,LAddr);


    If (Ok) and (Locked) then
    Begin

      Sold:=Not Sold;

      If (Sold) then
      Begin

        SERN_SetLink(InvR,IdR,OutDoc,OutOrdDoc,SoldLine,OutOrdLine,OutMLoc);

        DateOut:=IdR.PDate;

        CurSell:=IdR.Currency;
        SerSell:=Round_Up(Calc_StkCP(IdR.NetValue,IdR.QtyMul,IdR.UsePack),Syss.NoNetDec);

        If (IdR.IdDocHed In SalesSplit+StkAdjSplit+WOPSplit+StkRetSplit) then
          DocPCost:=DocPCost+(Round_Up(Ser_CalcCrCost(IdR.Currency,MiscRecs^),Syss.NoCosDec)*DocCnst[IdR.IdDocHed]*DocNotCnst);

        SerialR:=SerialR+(1.0);

        If (SerRetMode=26) then
        Begin
          ReturnSNo:=BOn;

          RetDoc:=InvR.OurRef;
          RetDocLine:=IdR.ABSLineNo;

        end;

        If (IdR.IdDocHed In StkRetPurchSplit) then {* Make a note it has been sent back *}
        Begin
          {$IFDEF NP}
            SERN_AutoAddNotes(MiscRecs^,0,'Serial Item Returned via '+InvR.OurRef+' / '+InvR.YourRef+' '+InvR.TransDesc);
          {$ENDIF}
        end;

      end
      else
      Begin
        If (ReturnSNo and (SerRetMode<>26)) then {* Deny unuse *}
        Begin
          If (Trim(RetDoc)<>'') then
          Begin
            GenStr:='on '+Trim(RetDoc);
          end;

          mbRet:=MessageDlg('This Serial item has been booked as Returned stock '+GenStr+', and cannot be used as normal stock until it has been issued back into stock from the Returns system!',
                     mtWarning,[mbOk],0);
          Sold:=BOn;
        end
        else
          Begin
            //Check if this in doc = OurDoc before we blank OutDoc
            SameDoc := InvR.OurRef = OutDoc;

            Blank(OutDoc,Sizeof(OutDoc));
            Blank(DateOut,Sizeof(DateOut));
            Blank(OutMLoc,Sizeof(OutMLoc));
            SoldLine:=0;
            SerSell:=0;

            If (IdR.IdDocHed In SalesSplit+StkAdjSplit+WOPSplit+StkRetSplit) then
              DocPCost:=DocPCost-(Round_Up(Ser_CalcCrCost(IdR.Currency,MiscRecs^),Syss.NoCosDec)*DocCnst[IdR.IdDocHed]*DocNotCnst);

            SerialR:=SerialR-(1.0);

            //PR: 08/05/2014 ABSEXCH-14447 Set In-Doc, Location, etc
            //PR: 08/05/2014 ABSEXCH-14447 Added check for Lou, so that if user uses wrong serial number then deletes the line
            //                             to rectivy it, we don't use the out doc as the in doc.
            if not SameDoc then
              SERN_SetLink(InvR,IdR,InDoc,InOrdDoc,BuyLine,INOrdLine,InMLoc);

              {If (SerRetMode=26) then {* We cannot cancel this as otherwise we would loose track of it on a back to back repair
              Begin
                ReturnSNo:=BOff;

                Blank(RetDoc,Sizeof(RetDoc));
                RetDocLine:=0;
              end;}
        end

      end;


      SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);


      Report_BError(Fnum,Status);

      Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

    end; {If Locked..}
  end; {With..}

end; {Proc..}


{ ==== Procedure to Unuse a master batch ===== }

Procedure Un_UseBatch(BRef  :  Str20;
                      SFolio,
                      NFolio:  LongInt;
                      QtyU  :  Double;
                      PInLoc:  Str10;
                      Fnum,
                      Keypath,
                      KeyPath2
                            :  Integer);


Var
  KeyS,
  KeyChk  :  Str255;

  FoundOk,
  Locked  :  Boolean;

  TmpStat :  Integer;
  TmpRecAddr,
  LAddr
          :  Longint;

Begin
  FoundOk:=BOff;

  Locked:=BOff;

  TmpStat:=Presrv_BTPos(Fnum,KeyPath2,F[Fnum],TmpRecAddr,BOff,BOff);

  KeyChk:=FullQDKey(MFIFOCode,MSernSub,BRef);
  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
  With MiscRecs^.SerialRec do
  Begin
    FoundOk:=(BatchRec) and (Not BatchChild) and (StkFolio=SFolio) and ((NoteFolio=NFolio) or (NFolio=0)) and ((CheckKey(PInLoc,InMLoc,Length(PInLoc),BOff)) or (Not Syss.UseMLoc));

    If (FoundOk) then
    Begin
      Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,Keys,KeyPath,Fnum,BOn,Locked,LAddr);


      If (Ok) and (Locked) then
      Begin
        QtyUsed:=QtyUsed-QtyU;

        Sold:=(BuyQty-QtyUsed<=0);

        SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);


        Report_BError(Fnum,Status);

        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

      end; {If Locked..}

    end {If Found..}
    else
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

  TmpStat:=Presrv_BTPos(Fnum,KeyPath2,F[Fnum],TmpRecAddr,BOn,BOff);

end; {Proc..}


{ ========= Function to Get Amount of Batch used ======== }

Function InpBSnQty(Var QtyB  :  Double)  :  Boolean;

Var
  GetSer  :  TStkSerNo;

Begin
  Result:=BOff;

  ModalMode:=BOn;
  ModalInp:=BOff;

  GetSer:=TStkSerNo.Create(Application.MainForm);

  ModalMode:=BOff;

  try
    With GetSer do
    Begin
      UQF.Value:=QtyB;

      ExLocal.AssignFromGlobal(MiscF);

      OutId;

      ShowModal;

      Result:= (ModalResult=mrOk);

      If (Result) then
      Begin
        QtyB:=UQF.Value;
      end;
    end;

  finally

    GetSer.Free;


  end; {try..}

end;

Procedure Make_BatchSetUse(Fnum,KeyPath  :  Integer;
                           InvR          :  InvRec;
                           IdR           :  IDetail;
                           QtyB          :  Double;
                           LAddr         :  LongInt;
                             SerRetMode
                                      :  Byte);

Begin
  With MiscRecs^.SerialRec do
  Begin
    QtyUsed:=QtyUsed+QtyB;

    // MH 13/03/2012 v6.10 ABSEXCH-10123: Added rounding to fix issue where 0.0 qty batches are still shown as available
    Sold:=(Round_Up(BuyQty-QtyUsed,Syss.NoQtyDec)<=0);

    SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);

    Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    Report_BError(Fnum,Status);

    Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

    Sold:=BOn;

    SERN_SetLink(InvR,IdR,OutDoc,OutOrdDoc,SoldLine,OutOrdLine,OutMLoc);

    DateOut:=IdR.PDate;

    CurSell:=IdR.Currency;

    SerSell:=Round_Up(Calc_StkCP(IdR.NetValue,IdR.QtyMul,IdR.UsePack),Syss.NoNetDec);


    QtyUsed:=QtyB;

    ChildNFolio:=NoteFolio;

    BatchChild:=BOn;

    SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);

    {If (SerRetMode=26) then
    Begin
      ReturnSNo:=BOn;

      RetDoc:=InvR.OurRef;
      RetDocLine:=IdR.ABSLineNo;
    end;}

    If (IdR.IdDocHed In StkRetPurchSplit) then {* Make a note it has been sent back *}
    Begin
      {$IFDEF NP}
        SERN_AutoAddNotes(MiscRecs^,0,Form_Real(QtyB,0,Syss.NoQtyDec)+'x Batch Item Returned via '+InvR.OurRef+' / '+InvR.YourRef+' '+InvR.TransDesc);
      {$ENDIF}
    end;

    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    Report_BError(Fnum,Status);
  end; {With..}
end; {Proc..}



{ ========= Proc to Set Use Details for Batch ======== }

Procedure Batch_SetUse(Fnum,
                       Keypath,
                       CurrLine :  Integer;
                   Var SerialR,
                       DocPCost :  Double;
                       InvR     :  InvRec;
                       IdR      :  IDetail;
                      SerRetMode
                               :  Byte);



Var
  Locked  :  Boolean;
  QtyAvail,
  QtyB    :  Double;
  Tc      :  Char;
  LAddr   :  LongInt;
  mbRet   :  Word;


Begin

  Tc:=ResetKey;

  Locked:=BOff;

  With MiscRecs^.SerialRec do
  Begin
    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,KeyPath,Fnum,BOn,Locked,LAddr);

    If (Ok) and (Locked) then
    Begin

      If (Not BatchChild) then
      Begin
        If (Not Sold) then
        Begin

          QtyB:=SerialR*DocNotCnst;

          QtyAvail:=(BuyQty-QtyUsed);

          If (QtyB>QtyAvail) then
            QtyB:=QtyAvail;

          If (InpBSnQty(QtyB)) then
          Begin
            Make_BatchSetUse(Fnum,KeyPath,InvR,IdR,QtyB,LAddr,SerRetMode);


            If (IdR.IdDocHed In SalesSplit+StkAdjSplit+WOPSplit+StkRetSplit) then
              DocPCost:=DocPCost+(Round_Up(Ser_CalcCrCost(IdR.Currency,MiscRecs^)*QtyB,Syss.NoCosDec)*DocCnst[IdR.IdDocHed]*DocNotCnst);

            SerialR:=SerialR+Round_Up(QtyB,Syss.NoQtyDec);
          end;
        end;
      end
      else
      Begin
        If (ReturnSNo and (SerRetMode<>26)) then {* Deny unuse *}
        Begin
          mbRet:=MessageDlg('This Batch item has been booked as Returned stock, and cannot be used as normal stock until it has been issued back into stock from the Returns system!',
                     mtWarning,[mbOk],0);
        end
        else
        Begin
          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

          Report_BError(Fnum,Status);

          If (StatusOk) then
          Begin
            If (IdR.IdDocHed In SalesSplit+StkAdjSplit+WOPSplit+StkRetSplit) then
              DocPCost:=DocPCost+(Round_Up(Ser_CalcCrCost(IdR.Currency,MiscRecs^)*
                                   QtyUsed,Syss.NoCosDec)*DocCnst[IdR.IdDocHed]); {v5 reversed sign or credit notes did not calc cost correctly}
                                                                                  {v5.50 Doccnst multipler re-instaed to cope with returned bactes from sales transactions}

              SerialR:=SerialR-Round_Up(QtyUsed,Syss.NoQtyDec);
                                                             {* v6.003 OutLoc replaced by Inloc since returning a Used Batch
                                                                       line where the inloc was not the same as the outloc
                                                                       caused the parent batch record to not be updated *}
              Un_UseBatch(BatchNo,StkFolio,ChildNFolio,QtyUsed,InMLoc,Fnum,MiscBtcK,Keypath);

          end;
        end;
      end;

    end; {If Locked..}
  end; {With..}

end; {Proc..}



{ ========= Proc to Set Ret-Details for Serial No. ======== }

Procedure SERN_SetRet(Fnum,
                      Keypath  :  Integer;
                  Var SerialR,
                      DocPCost :  Double;
                      InvR     :  InvRec;
                      IdR      :  IDetail;
                      RetMode  :  Byte);

Const
  SDesc  :  Array[BOff..BOn] of Str10 = ('Serial','Batch');

Var
  Ok2Cont,
  Locked  :  Boolean;
  LAddr   :  LongInt;
  QtyB    :  Double;

Begin
  QtyB:=1.0;

  Locked:=BOff;  Ok2Cont:=BOn;

  With MiscRecs^.SerialRec do
  Begin
    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,KeyPath,Fnum,BOn,Locked,LAddr);


    If (Ok) and (Locked) then
    Begin
      ReturnSNo:=Not ReturnSNo;

      If (BatchChild) then
        QtyB:=QtyUsed;

      If (ReturnSNo) then
      Begin
        If (BatchChild) then
        Begin
          QtyB:=SerialR;

          Ok2Cont:=(InpBSnQty(QtyB));
        end;

        If (Ok2Cont) then
        Begin
          RetDoc:=InvR.OurRef;
          RetDocLine:=IdR.ABSLineNo;
          BatchRetQty:=QtyB;

          If (IdR.IdDocHed In SalesSplit+StkAdjSplit+WOPSplit+StkRetSplit) then
            DocPCost:=DocPCost-(Round_Up(Ser_CalcCrCost(IdR.Currency,MiscRecs^)*QtyB,Syss.NoCosDec)*DocCnst[IdR.IdDocHed]*DocNotCnst);

          If (RetMode<>26) or (Not (IdR.IdDocHed In StkRetSalessplit)) then
            SerialR:=SerialR-QtyB
          else
            SerialR:=SerialR+QtyB;
        end;
      end
      else
      Begin
        If (BatchChild) then
          QtyB:=BatchRetQty;
          
        If (IdR.IdDocHed In SalesSplit+StkAdjSplit+WOPSplit+StkRetSplit) then
          DocPCost:=DocPCost+(Round_Up(Ser_CalcCrCost(IdR.Currency,MiscRecs^)*QtyB,Syss.NoCosDec)*DocCnst[IdR.IdDocHed]*DocNotCnst);

        If (RetMode<>26) or (Not (IdR.IdDocHed In StkRetSalessplit)) then
          SerialR:=SerialR+QtyB
        else
          SerialR:=SerialR-QtyB;

        {Blank(RetDoc,Sizeof(RetDoc)); {* We still need this reference in case SRN is credited back to stock
        RetDocLine:=0;}
      end;


      If (Ok2Cont) then
      Begin
        SERN_AutoAddNotes(MiscRecs^,0,Form_Real(QtyB,0,Syss.NoQtyDec)+'x '+SDesc[BatchChild]+' Item Returned via '+InvR.OurRef+' / '+InvR.YourRef+' '+InvR.TransDesc);

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);


        Report_BError(Fnum,Status);
      end;

      Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

    end; {If Locked..}
  end; {With..}

end; {Proc..}

{ ==== Function to check if a serial number belongs to the same product only == }

Function CheckSNOExsists(RT,SP     :  Char;
                         StkFolio  :  LongInt;
                         SKey      :  Str20)   :  Boolean;

Var
  FoundOk,
  Loop  :  Boolean;


Begin
  FoundOk:=BOff;

  Loop:=BOff;

  Repeat

    FoundOk:=CheckExsists(FullQDKey(RT,SP,MakeSNKey(StkFolio,Loop,SKey)),MiscF,MIK);

    Loop:=Not Loop;

  Until (Not Loop) or (FoundOk);

  CheckSNOExsists:=FoundOk;
end;

{ ================ Procedrue to Check for Duplicate XXX Records,.. ===}

Function Check4DupliSNO(RT,SP     :  Char;
                        StkFolio  :  LongInt;
                        SKey      :  Str20)   :  Boolean;

Var
  mbRet  :  Word;

Begin
  Result:=CheckSNOExsists(RT,SP,StkFolio,SKey);

  If (Result) then
  Begin
    mbRet:=MessageDlg('That Serial No. already exists!',
                       mtWarning,[mbOk],0);
  end;

end;






Initialization

  ModalMode:=BOff;
  ModalInp:=BOff;

end.
