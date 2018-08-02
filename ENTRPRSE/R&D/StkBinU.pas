unit StkBINU;

{$I DEFOVR.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Mask,

  GlobVar,VarConst,VARRec2U,ExWrap1U,CmpCtrlU, bkgroup;


type
  TStkBinNo = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    ODF: TEditDate;
    InF: Text8Pt;
    InCF: TSBSComboBox;
    UCF: TCurrencyEdit;
    OutF: Text8Pt;
    OutCF: TSBSComboBox;
    USF: TCurrencyEdit;
    SNoF: TExMaskEdit;
    BNoF: Text8Pt;
    OQF: TCurrencyEdit;
    AQF: TCurrencyEdit;
    CQF: TCurrencyEdit;
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
    CapLab: Label8;
    LocInF: Text8Pt;
    LocOutF: Text8Pt;
    InLocLab: Label8;
    OutLocLab: Label8;
    Label83: Label8;
    UBF1: TEditDate;
    UseLab: Label8;
    UQF: TCurrencyEdit;
    UOMF: Text8Pt;
    Label84: Label8;
    PmCBF: TSBSComboBox;
    Label86: Label8;
    Label813: Label8;
    TagF: TCurrencyEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BNoFExit(Sender: TObject);
    procedure LocInFExit(Sender: TObject);
    procedure BNoFEnter(Sender: TObject);
    procedure SNoFExit(Sender: TObject);
    procedure SNoFMaskError(Sender: TObject);
    procedure SNoFSetFocusBack(Sender: TObject; var bSetFocus: Boolean);
  private
    { Private declarations }

    MoveMode,
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

    StopAutoLoc:  Boolean;

    StockR     :  StockRec;

    DocCostP   :  Double;

      {* Used to control variation of behavior when returning sales stock, as this is stock we get back temporarily.
         25 = Add in location for  already sold stock to be returned. Mark as held by quarrantine , which will prevent it from being unused
         26 = Un sell, and return to stock, reseting any returned stock flag *}

    SerRetMode,
    SerMode    :  Byte;

    BinAddTo,
    BinReq     :  Double;

    ExLocal    :  TdExLocal;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;


    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(RStock     :  StockRec;
                       Edit,
                       VO         :  Boolean);

    Function Check_Duplicate_Bin(BC,
                                 LC  :  Str10;
                                 QuietMode
                                     :  Boolean)  :  Boolean;

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer;
                            RStock   :  StockRec);

  end;




Procedure Set_BINModalMode(MM,CI  :  Boolean);


Procedure Un_UseBin(BRef  :  Str20;
                    SFolio:  LongInt;
                    LCode :  Str10;
                    QtyU  :  Double;
                    Fnum,
                    Keypath,
                    KeyPath2
                          :  Integer;
                    BChild:  MLocRec;
                Var ShowParent
                          :  Boolean);


Procedure Make_BinSetUse(Fnum,KeyPath  :  Integer;
                         InvR          :  InvRec;
                         IdR           :  IDetail;
                         QtyB          :  Double;
                         LAddr         :  LongInt);


Procedure Bin_SetUse(Fnum,
                     Keypath,
                     CurrLine :  Integer;
                 Var SerialR,
                     DocPCost :  Double;
                     InvR     :  InvRec;
                     IdR      :  IDetail;
                 Var ShowParent
                              :  Boolean);


Function CheckBINExsists(RT,SP     :  Char;
                         StkFolio  :  LongInt;
                         LCode     :  Str10;
                         SKey      :  Str20)   :  Boolean;

{ === Auto Pick/ return from Bins === }

Procedure Auto_PickBin(Var  Idr  :  IDetail;
                            InvR :  InvRec;
                       Var  QtyP :  Real;
                       Var  IBQty
                                 :  Double;
                            Mode :  Byte);



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  StockProc, // NF:
  BorBtns,
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  BTSupU1,
  BTSupU2,
  SBSComp2,
  
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

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  PayF2U,
  InvCTSuU,
  PWarnU,
  {PayLineU,}

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,
  {$ENDIF}

  ThemeFix,

  StkSerNU,

  Saltxl1U;




{$R *.DFM}



Var
  ModalMode,
  ModalInp  :  Boolean;


Procedure Set_BINModalMode(MM,CI  :  Boolean);

Begin
  ModalMode:=MM;
  ModalInp:=CI;

end;

{ ========== Build runtime view ======== }

procedure TStkBinNo.BuildDesign;


begin


end;


procedure TStkBinNo.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  UCF.DecPlaces:=Syss.NoCosDec;
  USF.DecPlaces:=Syss.NoNetDec;
  OQF.DecPlaces:=Syss.NoQtyDec;
  AQF.DecPlaces:=Syss.NoQtyDec;
  UQF.DecPlaces:=Syss.NoQtyDec;
  CQF.DecPlaces:=Syss.NoQtyDec;

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

  {SNoF.MaxLength:=SNoKeyLen;
  BNoF.MaxLength:=BNoKeyLen;}
  InF.MaxLength:=DocKeyLen;
  OutF.MaxLength:=DocKeyLen;

  If (FormStyle=fsNormal) and (Not CompInp) then
  Begin
    UseLab.Visible:=BOn;
    UQF.Visible:=BOn;
    ActiveControl:=UQF;
  end;

  If (Syss.BinMask<>'') then
  Begin
    SNoF.EditMask:=Syss.BinMask+';1;_';
  end;

  BuildDesign;

end;




procedure TStkBinNo.FormCreate(Sender: TObject);
begin
  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=264;
  ClientWidth:=383;

  SerRetMode:=0;

  DocCostP:=0;
  SerMode:=4;
  BINReq:=0;
  BinAddTo:=0;
  MoveMode:=BOff;

  StopAutoLoc:=BOff;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TStockRec) then
    With TStockRec(Owner) do
    Begin
      Self.SetFieldProperties(SNoPanel);

      If (BinUseMode) then
        SerMode:=5;

      Self.SerRetMode:=SerRetMode;

      MoveMode:=BinMoveMode;
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




procedure TStkBinNo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,106);

end;

procedure TStkBinNo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TStkBinNo.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TStkBinNo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TStkBinNo.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TStkBinNo.Send_UpdateList(Edit   :  Boolean;
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



Function TStkBinNo.CheckNeedStore  :  Boolean;

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


Procedure TStkBinNo.SetFieldFocus;

Begin
  If (SNoF.CanFocus) then
    SNoF.SetFocus;
end; {Proc..}




Function TStkBinNo.ConfirmQuit  :  Boolean;

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
                  Status:=UnLockMLock(MLocF,LastRecAddr[MiscF]);

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

Procedure TStkBinNo.OutId;

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  KeyS      :  Str255;


Begin
  With ExLocal,LMLocCtrl^.brBinRec do
  Begin
    SNoF.Text:=Strip('R',[#32],brBinCode1);
    BNoF.Text:=Strip('R',[#32],brPriority);

    InF.Text:=brInDoc;
    OutF.Text:=brOutDoc;

    {$IFDEF MC_On}
       If (brCurCost>0) then
         IncF.ItemIndex:=Pred(brCurCost);

       If (brCurSell>0) then
         OutcF.ItemIndex:=Pred(brCurSell);
    {$ENDIF}

    LocInF.Text:=brInMLoc;
    LocOutF.Text:=brOutMLoc;

    If PChkAllowed_In(143) then
      UCF.Value:=brBinCost
    else
      UCF.Value:=0.0;


    USF.Value:=brBinSell;

    ODF.DateValue:=brDateIn;
    UBF1.DateValue:=brDateUseX;

    OQF.Value:=brBuyQty;
    AQF.Value:=brBuyQty-brQtyUsed;
    CQF.Value:=brBinCap;

    UOMF.Text:=brUOM;

//    If (brHoldFlg>=0) then
      PmcbF.ItemIndex:=brHoldFlg;

    TagF.Value:=brTagNo;

  end;
end;


procedure TStkBinNo.Form2Id;

Begin

  With EXLocal,LMLocCtrl^.brBinRec do
  Begin
    brBinCode1:=FullBinCode(UpCaseStr(SNoF.Text));
    brPriority:=LJVar(UpCaseStr(BNof.Text),BNoKeyLen);

    brInDoc:=UpCaseStr(InF.Text);
    brOutDoc:=UpCaseStr(OutF.Text);

    {$IFDEF MC_On}
      If (IncF.ItemIndex>=0) then
        brCurCost:=Succ(IncF.ItemIndex);

      If (OutcF.ItemIndex>=0) then
        brCurSell:=Succ(OutcF.ItemIndex);

      If (brCurCost<>LastMLoc^.brBinRec.brCurCost) then
      Begin
        brSerCRates:=SyssCurr^.Currencies[brCurCost].CRates;
        SetTriRec(brCurCost,brSUseORate,brSerTriR);
      end;
    {$ENDIF}

    brDateIn:=ODF.DateValue;
    brDateUseX:=UBF1.DateValue;

    If PChkAllowed_In(143) then
      brBinCost:=UCF.Value;
      
    brBinSell:=USF.Value;


    brInMLoc:=LocInF.Text;
    brOutMLoc:=LocOutF.Text;

    brBuyQty:=OQF.Value;
    brBinCap:=CQF.Value;

    brUOM:=UOMF.Text;

    If (PmCbF.ItemIndex>=0) then
      brHoldFlg:=PmCbF.ItemIndex;

    brTagNo:=Round(TagF.Value);

    If (SerMode=5) and (LastEdit) then
      BinAddTo:=UQF.Value;

  end; {with..}

end; {Proc..}





procedure TStkBinNo.SetIdStore(EnabFlag,
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


procedure TStkBinNo.SetCaption;


Begin
  With ExLocal,LMLocCtrl^.brBinRec do
  Begin
    Caption:='Bin Record : '+Strip('B',[#32],brBinCode1);

  end;
end;

(*  Add is used to add Notes *)

procedure TStkBinNo.ProcessId(Fnum,
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
  With ExLocal,LMLocCtrl^,brBinRec do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPfix:=BRRecCode;
      SubType:=MSERNSub;
      
      brStkFolio:=StockR.StockFolio;
      brBatchRec:=BOn;
      brUOM:=StockR.UnitP;

      If (Not StopAutoLoc) and ((SerMode<>5) or (CheckKey(Trim(StockR.DefMLoc),LId.MLocStk,Length(Trim(StockR.DefMLoc)),BOff))) then
        brBinCode1:=StockR.BinLoc; {* This needs working on, as if already there present as edit? *}

      If (SerMode=5) then
      Begin
        SERN_SetLink(LInv,LId,brInDoc,brInOrdDoc,brBuyLine,brInOrdLine,brInMLoc);

        brCurCost:=LInv.Currency;

        brBINCost:=DocCostP;

        brSerCRates:=LInv.CXRate;
        brSerTriR:=LInv.CurrTriR;
        brDateIn:=Today;


        If (brSerCRates[BOff]=0.0) then
        Begin
          brSerCRates[BOff]:=SyssCurr^.Currencies[brCurCost].CRates[BOff];
          SetTriRec(brCurCost,brSUseORate,brSerTriR);
        end;

        If (LId.IdDocHed In StkRetSalesSplit) and (SerRetMode=25) then {* Auto set to quarrantine stock *}
          brHoldFlg:=2;

        With LId do
        If (Not EmptyKey(JobCode,JobKeyLen)) and (Not EmptyKey(AnalCode,AnalKeyLen)) and (Not (IdDocHed In StkAdjSplit)) then {Force serial to be out as well}
        Begin
          brOutDoc:=brInDoc; brOutOrdDoc:=brInOrdDoc;
          brOutOrdLine:=brInOrdLine;
          brSoldLine:=brBuyLine;

          brDateOut:=LId.PDate;

          brCurSell:=brCurCost;
          brBinSell:=brBinCost;


          brOutMLoc:=brInMLoc;

        end;


      end
      else
      Begin
        {$IFDEF MC_On}
          brCurCost:=1;
          brCurSell:=1;
        {$ENDIF}
      end;


    end;

    LastMLoc^:=LMLocCtrl^;

    If (SerMode=5) then
    Begin
      If (Not Edit) then
        brBuyQty:=BinReq
      else
      If (BinReq>0) or (MoveMode) then
      Begin
        OutId;
        UseLab.Visible:=BOn;
        UseLab.Caption:='Add Qty';
        UQF.Visible:=BOn;
        ActiveControl:=UQF;
        UQF.Value:=BinReq;
      end
      else
        UQF.Value:=0.0;

    end;




    OutId;

  end; {If Abort..}

  SetIdStore(BOn,ExLocal.LViewOnly);

end; {Proc..}




Function TStkBinNo.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  8;
  Fnum         =  MLocF;
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
  ShowMsg := False;
  TmpBo := False;
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That Bin Code. exists already for this product!';
  PossMsg^[2]:='You must complete the Bin code.!';
  PossMsg^[3]:='Cost Currency not Valid.';
  PossMsg^[4]:='Sales Currency not Valid.';
  PossMsg^[5]:='In Location not Valid.';
  PossMsg^[6]:='Out Location not Valid.';
  PossMsg^[7]:='The Capacity of this Bin has been exceeded';
  PossMsg^[8]:='This Bin is on Hold';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal, LMLocCtrl^,brBinRec do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=(Not EmptyKey(brBINCode1,BINKeyLen));

              If (Result) and (Not EmptyKey(brBinCode1,SNoKeyLen)) and (Not Edit) then
                Result:=Not Check_Duplicate_Bin(brBinCode1,brInMLoc,BOn);

                {CheckBINExsists(RecPfix,SubType,brStkFolio,brInMLoc,brBincode1);}

            end;

      2  :  Result:=(Not (EmptyKey(brBinCode1,BinKeyLen)));


      {$IFDEF MC_On}

        3  :  Result:=(brCurCost In [CurStart..CurrencyType]);

        4  :  Result:=(brCurSell In [CurStart..CurrencyType]);


      {$ENDIF}

      {$IFDEF SOP}
        5,6  :  If (Syss.UseMLoc) then
                Begin
                  Case Test of
                    5  :  Begin
                            FoundCode:=brInMLoc;
                            TmpBo:=EmptyKey(brInDoc,DocKeyLen);
                          end;
                    6  :  Begin
                            FoundCode:=brOutMLoc;
                            TmpBo:=EmptyKey(brOutDoc,DocKeyLen);
                          end;
                  end; {Case..}


                    If (Not TmpBo) then
                      TmpBo:=Global_GetMainRec(MLocF,Quick_MLKey(FoundCode));

                    Result:=TmpBo;
                end;
      {$ENDIF}


      7  :  Result:=(brBinCap=0.0) or ((brBuyQty-brQtyUsed+BinAddTo)<=brBinCap);

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
  Begin
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

    If (Test=7) then
      Result:=BOn; {Warning only}
  end;

  Dispose(PossMsg);

end; {Func..}




procedure TStkBinNo.StoreId(Fnum,
                            Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpMLoc
       :  MLocRec;

  AdjBrQty
       :  Double;

  KeyS :  Str255;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LMLocCtrl^,brBinRec do
  Begin
    If (LastEdit) and (LastMLoc^.brBinRec.brBinCode1<>brBinCode1) then
    Begin
      COk:=Not Check_Duplicate_Bin(brBinCode1,brInMLoc,BOff);
    end
    else
      COk:=BOn;


    If (COk) then
      COk:=CheckCompleted(LastEdit,BOff);


    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      With LId do
        If (Not EmptyKey(JobCode,JobKeyLen)) and (Not EmptyKey(AnalCode,AnalKeyLen)) and (Not EmptyKey(brOutDoc,DocKeyLen))
        and (Not (IdDocHed In StkAdjSplit)) and (Not LastEdit) then {Force serial to be out as well}
       Begin
          brQtyUsed:=brBuyQty;

        end;

      AdjBrQty:=brBuyQty;

      If (SerMode=5) and (LastEdit) then
      Begin
        {* By removing quarrantine status in sales ret stk mode, we are really just moving status *}

        If (brHoldFlg=0) and (brHoldFlg<>LastMLoc^.brBinRec.brHoldFlg) and (SerRetMode=26) then
          AdjBrQty:=brBuyQty+BinAddTo
        else
        Begin
          brBuyQty:=brBuyQty+BinAddTo;

          AdjBrQty:=brBuyQty;

        end;

      end;


      brSold:=(((Not EmptyKey(brOutDoc,DocKeyLen)) and (Not brBatchRec)) or
              ((brBuyQty-brQtyUsed<=0) and (brBatchRec))) ;

      brCode2:=FullBinCode2(brStkFolio,brSold,brInMLoc,brPriority,brDateIn,brBinCode1);

      brCode3:=FullBinCode3(brStkFolio,brInMLoc,BrBinCode1);

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


        SetCaption;
      end;

      Report_BError(Fnum,Status);

      If (StatusOk) then
      Begin
        If (brBatchRec) and (SerMode=5) then
          BinReq:=Round_Up(BinReq-AdjbrQty+LastMLoc^.brBinRec.brBuyQty,Syss.NoQtyDec);

        If (Self.Owner is tStockRec) and (Not StopAutoLoc) then {Call back so default loc is not suggested all the time once it has been suggested or added once }
          TStockRec(Self.Owner).stkStopAutoLoc:=(Trim(brBinCode1)=Trim(StockR.BinLoc));
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


procedure TStkBinNo.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TStkBinNo.EditLine(RStock     :  StockRec;
                             Edit,
                             VO         :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    LViewOnly:=VO;

    StockR:=RStock;

    AssignFromGlobal(MLocF);

    ProcessId(MLocF,MLSecK,LastEdit);
  end;
end;



procedure TStkBinNo.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) and ((FormStyle<>fsNormal) or (CompInp)) then
    Begin
      // MH 13/01/2011 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date, Period/Year and number
      //                                   fields which processes the text and updates the value
      If (ActiveControl <> OkCP1Btn) And OkCP1Btn.CanFocus Then
        OkCP1Btn.SetFocus;

      If (ActiveControl = OkCP1Btn) Then
        StoreId(MLocF,SKeypath);
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


Function TStkBinNo.Check_Duplicate_Bin(BC,
                                       LC  :  Str10;
                                       QuietMode
                                           :  Boolean)  :  Boolean;

Const
  Fnum     =  MLocF;
  Keypath  =  MLSuppK;

Var
  FoundOk  :  Boolean;

  KeyS,
  KeyChk   :  Str255;

  TmpKeypath,
  TmpStat :  Integer;

  TmpRecAddr
          :  LongInt;

  TmpMLoc
         :  MLocRec;


Begin
  TmpKeyPath:=GetPosKey;

  TmpMLoc:=ExLocal.LMLocCtrl^;

  TmpStat:=Presrv_BTPos(Fnum,TmpKeypath,F[Fnum],TmpRecAddr,BOff,BOff);

  
  FoundOk:=BOff;

  With ExLocal do
  Begin
    KeyChk:=FullQDKey(BRRecCode,MSERNSub,FullBinCode3(LMLocCtrl^.brBinRec.brStkFolio,LC,BC));

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With LMLocCtrl^.brBinRec do
    Begin

      FoundOk:=(brBatchRec) and (Not brBatchChild);

      If (Not FoundOk) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);

    end;

    If (FoundOk) and (Not QuietMode) then
    Begin
      ShowMessage('Bin Code '+Trim(BC)+' already exists for this product.');

    end;

    TmpStat:=Presrv_BTPos(Fnum,TmpKeypath,F[Fnum],TmpRecAddr,BOn,BOff);

    LMLocCtrl^:=TmpMLoc;
  end; {With..}

  Result:=FoundOk;
end;


procedure TStkBinNo.DeleteBOMLine(Fnum,
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


        end;

        If (StatusOk) then
        With LMiscRecs^.SerialRec do
        Begin
          {If (BatchRec) and (SerMode=5) then
          Begin
            If (Not BatchChild) then
              SerialReq:=Round_Up(SerialReq+BuyQty,Syss.NoQtyDec)
            else
            Begin
              SerialReq:=Round_Up(SerialReq+(QtyUsed*DocNotCnst),Syss.NoQtyDec);

              Un_UseBatch(BatchNo,StkFolio,ChildNFolio,QtyUsed,Fnum,MiscBtcK,KeyPath);
            end;
          end
          else
           SerialReq:=Round_Up(SerialReq+Ord(SerMode=5),Syss.NoQtyDec);}

          Send_UpdateList(BOff,19);


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}


procedure TStkBinNo.SNoFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str20;

  HookFail,
  AltMod:  Boolean;


begin
  HookFail:=BOff;

  If (Sender is TMaskEdit) and (ActiveControl<>CanCP1Btn) then
  With (Sender as TMaskEdit),ExLocal,LMLocCtrl^,brBinRec do
  Begin
    {$IFDEF CU}
      If (Not ReadOnly) then
      Begin
        brBinCode1:=Trim(Text);

        HookFail:=Not ValidExitHook(3100,2,ExLocal);

        If (Not HookFail) then
          Text:=brBinCode1;
      end;
    {$ENDIF}

    If (Not HookFail) then
    Begin
      AltMod:=Modified; {* For some reason altmod not set when entering alapha cvahrs! *}

      Form2Id;

      Text:=UpCaseStr(Text);

      CCode:=LJVar(Text,BinKeyLen);

      If ((Not LastEdit) or (LastMLoc^.brBinRec.brBinCode1<>CCode)) and (InAddEdit) and (Not EmptyKey(CCode,BinKeyLen)) then
      Begin
        {COk:=(Not Check4DupliGen(FullQDKey(RecMfix,SubType,CCode),MiscF,MiscNDXK,'Serial No. ('+Strip('B',[#32],CCode)+')'));}

        COk:=Not Check_Duplicate_Bin(CCode,brInMLoc,BOff);


        If (Not COk) then
        Begin

          If (CanFocus) then
            SetFocus;
        end

      end;
    end
    else
      If (CanFocus) then
        SetFocus;
  end;

end;

procedure TStkBinNo.SNoFMaskError(Sender: TObject);
begin
  if (ActiveControl <> CanCp1Btn) then
    ShowMessage('That Bin Code does not match the Bin Code mask. Please re-enter');
end;

procedure TStkBinNo.SNoFSetFocusBack(Sender: TObject;
  var bSetFocus: Boolean);
begin
  bSetFocus:=(ActiveControl <> CanCp1Btn);
end;

procedure TStkBinNo.BNoFEnter(Sender: TObject);
begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin

  {$IFDEF CUXXX will require separate hook for the b4 entry and also needs firing from onActive event as otherwise does not trigger when form first created}
    If (Not ReadOnly) and (Not ExLocal.LastEdit) then
      Text:=TextExitHook(3100,2,Trim(Text),ExLocal);
  {$ENDIF}
  end;
end;



procedure TStkBinNo.BNoFExit(Sender: TObject);

begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    Text:=UpCaseStr(Text);

  end; {with..}
end;

procedure TStkBinNo.LocInFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and
    ((Sender=LocInF) or ((Sender=LocOutF) and (OutF.Text<>''))) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,'',0));


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

{ ===== Bin management routines ========================================================================== }

  Function Bin_CalcCrCost(ICr      :  Byte;
                          TMLoc    :  MLocRec)  :  Double;


  Var
    UseRate  :  Boolean;
    NewAmnt  :  Double;


  Begin
    UseRate:=UseCoDayRate;
    NewAmnt:=0.0;

    With TMLoc.brBinRec do
    Begin
      {$IFDEF MC_On}
        If (Not RevalueStk(GetStkBNC(TMLoc.brBinRec.brStkFolio))) and (brSerCRates[UseRate]<>0.0) then
        Begin
          NewAmnt:=Conv_TCurr(brBinCost,brSerCRates[UseRate],brCurCost,brSUseORate,BOff);

          With SyssCurr^.Currencies[ICr] do
            Bin_CalcCrCost:=Conv_TCurr(NewAmnt,CRates[UseRate],ICr,0,BOn);


        end
        else
      {$ENDIF}

          Bin_CalcCrCost:=Currency_ConvFT(brBinCost,brCurCost,ICr,UseRate);


    end;
  end;





{ ==== Procedure to Unuse a Bin Record ===== }
{If the original Parent Bin record no longer exists because we are not retaining Bin History, then
a new parent is manufactured from the child details
Bref : Bin Ref we want to unuse.
Sfolio : Stock Folio Ref of stock record bin belongs to
Lcode : Location code bin resides at.
Fnum,Keypath  : MlocF, MLSuppK
Keypath2 : Current MlocF Key, used to preserve position
Bchild :  Bin Child Record
ShowParent : Routine being called from inside Bin list, so screen refresh required if True}


Procedure Un_UseBin(BRef  :  Str20;
                    SFolio:  LongInt;
                    LCode :  Str10;
                    QtyU  :  Double;
                    Fnum,
                    Keypath,
                    KeyPath2
                          :  Integer;
                    BChild:  MLocRec;
                Var ShowParent
                          :  Boolean);


Var
  KeyS,
  KeyChk  :  Str255;

  FoundOk,
  UpdateParent,
  Locked  :  Boolean;

  TmpStat :  Integer;
  TmpRecAddr,
  LAddr
          :  Longint;

Begin
  FoundOk:=BOff;

  Locked:=BOff; UpdateParent:=ShowParent;  ShowParent:=BOff;

  TmpStat:=Presrv_BTPos(Fnum,KeyPath2,F[Fnum],TmpRecAddr,BOff,BOff);

  KeyChk:=FullQDKey(brRecCode,MSernSub,FullBinCode3(SFolio,LCode,BRef));

  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
  With MLocCtrl^.brBinRec do
  Begin

    FoundOk:=(brBatchRec) and (Not brBatchChild) and (brStkFolio=SFolio) and (CheckKey(LCode,brInMLoc,Length(LCode),BOff))
    and (brInDoc=BChild.brBinRec.brInDoc)
    and (brBuyLine=BChild.brBinRec.brBuyLine);

    If (FoundOk) then
    Begin
      Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,Keys,KeyPath,Fnum,BOn,Locked,LAddr);


      If (Ok) and (Locked) then
      Begin
        brQtyUsed:=brQtyUsed-QtyU;

        If (brQtyUsed<0) then
          brQtyUsed:=0;

        brSold:=(brBuyQty-brQtyUsed<=0);

        brCode2:=FullBinCode2(brStkFolio,brSold,brInMLoc,brPriority,brDateIn,brBinCode1);

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);

        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

      end; {If Locked..}

    end {If Found..}
    else
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

  If (Not FoundOk) then {* Recreate parent from child *}
  With MLocCtrl^.brBinRec do
  Begin
    MLocCtrl^:=BChild;
    brBuyQty:=QtyU;
    brQtyUsed:=0.0;
    brBatchChild:=BOff;

    brSold:=BOff;

    brCode2:=FullBinCode2(brStkFolio,brSold,brInMLoc,brPriority,brDateIn,brBinCode1);

    Blank(brOutDoc,Sizeof(brOutDoc));
    Blank(brOutOrdDoc,Sizeof(brOutOrdDoc));

    brSoldLine:=0; brOutOrdLine:=0;
    brBinSell:=0.0;
    Blank(brDateOut,Sizeof(brDateOut));

    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    Report_BError(Fnum,Status);

    ShowParent:=StatusOk;
  end; {If Locked..}


  If (Not ShowParent) or (Not UpdateParent) then
    TmpStat:=Presrv_BTPos(Fnum,KeyPath2,F[Fnum],TmpRecAddr,BOn,BOff);

end; {Proc..}


{ ========= Function to Get Amount of Batch used ======== }

Function InpBinQty(Var QtyB  :  Double)  :  Boolean;

Var
  GetBin  :  TStkBinNo;

Begin
  Result:=BOff;

  ModalMode:=BOn;
  ModalInp:=BOff;

  GetBin:=TStkBinNo.Create(Application.MainForm);

  ModalMode:=BOff;

  try
    With GetBin do
    Begin
      UQF.Value:=QtyB;

      ExLocal.AssignFromGlobal(MLocF);

      OutId;

      ShowModal;

      Result:= (ModalResult=mrOk);

      If (Result) then
      Begin
        QtyB:=UQF.Value;
      end;
    end;

  finally

    GetBin.Free;


  end; {try..}

end;


{ == Use stock from a Bin record. Auto delete the parent if stock exhausted and we are not retaining history == }

Procedure Make_BinSetUse(Fnum,KeyPath  :  Integer;
                         InvR          :  InvRec;
                         IdR           :  IDetail;
                         QtyB          :  Double;
                         LAddr         :  LongInt);
Var
  ParentDeleted  :  Boolean;

Begin
  With MLocCtrl^.brBinRec do
  Begin
    ParentDeleted:=BOff;

    brQtyUsed:=brQtyUsed+QtyB;

    brSold:=(Round_Up(brBuyQty-brQtyUsed,Syss.NoQtyDec)<=0);

    brCode2:=FullBinCode2(brStkFolio,brSold,brInMLoc,brPriority,brDateIn,brBinCode1);

    GetStkBNC(brStkFolio);

    If (brSold) and (Not (CheckKey(Stock.BinLoc,brBinCode1,Length(Stock.BinLoc),BOff))) and (Not Syss.KeepBinHist) then {Destroy the original}
    Begin
      Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);
      ParentDeleted:=StatusOk;
    end
    else
      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    Report_BError(Fnum,Status);

    If (Not ParentDeleted) then
      Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

    brSold:=BOn;

    SERN_SetLink(InvR,IdR,brOutDoc,brOutOrdDoc,brSoldLine,brOutOrdLine,brOutMLoc);

    brDateOut:=IdR.PDate;

    brCurSell:=IdR.Currency;

    brBinSell:=Round_Up(Calc_StkCP(IdR.NetValue,IdR.QtyMul,IdR.UsePack),Syss.NoNetDec);


    brQtyUsed:=QtyB;

    brBatchChild:=BOn;

    If (IdR.IdDocHed In StkRetPurchSplit) then
      brHoldFlg:=2; {Auto place on quarrantine so it cannot be unused by normal means}

    brCode2:=FullBinCode2(brStkFolio,brSold,brInMLoc,brPriority,brDateIn,brBinCode1);

    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    Report_BError(Fnum,Status);
  end; {With..}
end; {Proc..}




{ == Use stock from a Bin record. Auto delete the parent if stock exhausted and we are not retaining history ==
Fnum,Keypath  :  MlocF, MLSecK
CurrLine  :  Not Used
SerialR   :  Total qty of Bins/ required. Returns used. An initial negative SerialR indicates we are returning Stock
DocPCost  :  Total cost of Bins picked. Kept for future use, not currently used.
InvR  :   Header transaction record requiring Bin
IdR   :   Line record requiring Bin
ShowParent : Routine being called from inside Bin list, so screen refresh required if True}


Procedure Bin_SetUse(Fnum,
                     Keypath,
                     CurrLine :  Integer;
                 Var SerialR,
                     DocPCost :  Double;
                     InvR     :  InvRec;
                     IdR      :  IDetail;
                 Var ShowParent
                              :  Boolean);



Var
  Locked  :  Boolean;
  QtyAvail,
  QtyB    :  Double;
  Tc      :  Char;
  LAddr   :  LongInt;


Begin

  Tc:=ResetKey;

  Locked:=BOff;  {ShowParent:=BOff;}

  With MLocCtrl^.brBinRec do
  Begin
    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,KeyPath,Fnum,BOn,Locked,LAddr);


    If (Ok) and (Locked) then
    Begin

      If (Not brBatchChild) then
      Begin
        If (Not brSold) then
        Begin

          QtyB:=SerialR*DocNotCnst;

          QtyAvail:=(brBuyQty-brQtyUsed);

          If (QtyB>QtyAvail) then
            QtyB:=QtyAvail;

          If (InpBinQty(QtyB)) then
          Begin
            Make_BinSetUse(Fnum,KeyPath,InvR,IdR,QtyB,LAddr);


            If (IdR.IdDocHed In SalesSplit+StkAdjSplit+WOPSplit) then
              DocPCost:=DocPCost+(Round_Up(Bin_CalcCrCost(IdR.Currency,MLocCtrl^)*QtyB,Syss.NoCosDec)*DocCnst[IdR.IdDocHed]*DocNotCnst);

            SerialR:=SerialR+Round_Up(QtyB,Syss.NoQtyDec);
          end;
        end;
      end
      else
      Begin
        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

        Report_BError(Fnum,Status);

        If (StatusOk) then
        Begin
          If (IdR.IdDocHed In SalesSplit+StkAdjSplit+WOPSplit) then
            DocPCost:=DocPCost+(Round_Up(Bin_CalcCrCost(IdR.Currency,MLocCtrl^)*
                                 brQtyUsed,Syss.NoCosDec)*DocCnst[IdR.IdDocHed]); {v5 reversed sign or credit notes did not calc cost correctly}
                                                                                {v5.50 Doccnst multipler re-instaed to cope with returned bactes from sales transactions}

          SerialR:=SerialR-Round_Up(brQtyUsed,Syss.NoQtyDec);

          Un_UseBin(brBinCode1,brStkFolio,brInMLoc,brQtyUsed,Fnum,MLSuppK,Keypath,MLocCtrl^,ShowParent);

        end;

      end;

    end; {If Locked..}
  end; {With..}

end; {Proc..}



{ == General routine to detect presence of Bin record without disturbing any global records or file position }

{ ==== Function to check if a BINCode belongs to the same product only == }

Function CheckBINExsists(RT,SP     :  Char;
                         StkFolio  :  LongInt;
                         LCode     :  Str10;
                         SKey      :  Str20)   :  Boolean;

Var
  FoundOk,
  Loop  :  Boolean;


Begin
  FoundOk:=BOff;


  FoundOk:=CheckExsists(FullQDKey(RT,SP,FullBinCode3(StkFolio,LCode,SKey)),MLocF,MLSuppK);

  Result:=FoundOk;
end;




{ === Auto Pick/ return from Bins ===
Will automatically scan Bins and either take stock from or return it to Bin records.

IdR   :   Line record requiring Bin
InvR  :   Header transaction record requiring Bin
QtyP  :   Quantity required to be picked/returned
IBQty :   Quantity actually picked/returned. Used to set Idr.BinQty;
Mode  :   0 Pick stock. 1 Return stock} 


Procedure Auto_PickBin(Var  Idr  :  IDetail;
                            InvR :  InvRec;
                       Var  QtyP :  Real;
                       Var  IBQty
                                 :  Double;
                            Mode :  Byte);
Const
  Fnum    =  MLocF;
  Keypath =  MLSecK;

Var
  Locked,
  UseRec,
  LoopCtrl,
  FoundOk :  Boolean;

  B_Func,
  B_Start,
  TmpStat,
  Keypath2:  Integer;

  LAddr,
  TmpRecAddr
          :  Longint;

  KeyS,
  KeyChk  :  Str255;

  QtyAvail,
  QtyB,
  BinCount:  Double;

  TMLoc   :  MLocRec;

Begin
  B_Start:=B_GetGEq;
  B_Func:=B_GetNext;

  FoundOk:=BOff;  UseRec:=BOff;  Locked:=BOff; LoopCtrl:=(InvR.Tagged=0);

  KeyPath2:=GetPosKey;

  TMLoc:=MLocCtrl^;

  TmpStat:=Presrv_BTPos(Fnum,KeyPath2,F[Fnum],TmpRecAddr,BOff,BOff);


  Try

    If (QtyP<>0) and (Is_FullStkCode(IdR.StockCode)) then
    Begin
      If (Stock.StockCode<>IdR.StockCode) then
      Begin
        KeyS:=IdR.StockCode;

        Global_GetMainRec(StockF,KeyS);

      end;

      If (Stock.MultiBinMode) and (Stock.StockType in StkProdSet) then
      Begin

//        If (Syss.FiltSNoBinLoc) then
        If FilterSerialBinByLocation(Syss.FiltSNoBinLoc, InvR.InvDocHed in SalesSplit
        , ChemilinesStockLocHookEnabled) then // NF:
        Begin
          KeyChk:=FullQDKey(brRecCode,MSernSub,FullNomKey(Stock.StockFolio)+Full_MLocKey(IdR.MLocStk)+Chr(Mode));
        end
        else
          KeyChk:=FullQDKey(brRecCode,MSernSub,FullNomKey(Stock.StockFolio));

        BinCount:=QtyP;

        Repeat

          KeyS:=KeyChk;

          Case Mode of
            0  :  Begin
                    B_Start:=B_GetGEq;
                    B_Func:=B_GetNext;
                  end;
            1  :  Begin
                    B_Start:=B_GetLessEq;
                    B_Func:=B_GetPrev;
                    KeyS:=KeyS+NdxWeight;
                  end;
          end; {Case..}


          QtyB:=0.0; QtyAvail:=0.0;

          Status:=Find_Rec(B_Start,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

          While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
          With MLocCtrl^.brBinRec do
          Begin
            {Application.ProcessMessages; v5.61 removed as some form of corruption was occurring here}

            Case Mode of {Auto use by priority index with additional hold flag filtering }
              0  :  Begin
                      B_Func:=B_GetNext;

                      UseRec:=((Not brSold) and (Not brBatchChild) and (Not (brHoldFlg In [1,2])));

                      If (UseRec) and (Not LoopCtrl) then
                      Begin
                        UseRec:=((brHoldFlg=3) and (brTagNo=InvR.Tagged));
                      end;


                      If (UseRec) then
                      Begin
                        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,KeyPath,Fnum,BOn,Locked,LAddr);

                        If (Ok) and (Locked) then
                        Begin
                          QtyB:=BinCount;

                          QtyAvail:=(brBuyQty-brQtyUsed);

                          If (QtyB>QtyAvail) then
                            QtyB:=QtyAvail;

                          Make_BinSetUse(Fnum,KeyPath,InvR,IdR,QtyB,LAddr);

                          {*v5.61 possible rounding failure here causing loop overload *}
                          BinCount:=Round_Up(BinCount-Round_Up(QtyB,Syss.NoQtyDec),Syss.NoQtyDec);

                          With IdR do
                            If (IdDocHed In WOPSplit) and (LineNo<>1) then {* We are building it, so we need to add it in *}
                              QtyB:=(QtyB*-1);

                          IBQty:=IBQty+Round_Up(QtyB,Syss.NoQtyDec);

                          B_Func:=B_Start;
                        end;
                      end;
                    end;

              1  :  Begin
                      B_Func:=B_GetPrev;

                      With InvR,IdR do
                        UseRec:=(brSold) and (brBatchChild) and
                        ((CheckKey(OurRef,brOutOrdDoc,Length(OurRef),BOff)) and (brOutOrdLine=ABSLineNo)
                        and (IdDocHed In OrderSet+[WOR])) or
                        ((CheckKey(OurRef,brOutDoc,Length(OurRef),BOff)) and (brSoldLine=ABSLineNo));


                      If (UseRec) then
                      Begin
                        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,KeyPath,Fnum,BOn,Locked,LAddr);

                        If (Ok) and (Locked) then
                        Begin
                          QtyB:=brQtyUsed;

                          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

                          Report_BError(Fnum,Status);

                          UseRec:=BOff;

                          Un_UseBin(brBinCode1,brStkFolio,brInMLoc,brQtyUsed,Fnum,MLSuppK,Keypath,MLocCtrl^,UseRec);

                          {*v5.61 possible rounding failure here causing loop overload *}
                          BinCount:=Round_Up(BinCount-Round_Up(QtyB,Syss.NoQtyDec),Syss.NoQtyDec);

                          With IdR do
                            If (IdDocHed In WOPSplit) and (LineNo<>1) then {* We are building it, so we need to add it in *}
                              QtyB:=(QtyB*-1);

                          IBQty:=IBQty-Round_Up(QtyB,Syss.NoQtyDec);

                          B_Func:=B_Start;
                        end;
                      end;

                    end;

            end; {Case..}

            FoundOk:=(Round_Up(BinCount,Syss.NoQtyDec)<=0.0);  {*v5.61 possible rounding failure here causing loop overload *}

            If (Not FoundOk) then
              Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

          end; {While loop..}

          LoopCtrl:=Not LoopCtrl;

        Until (Mode<>0) or (FoundOk) or (Not LoopCtrl);

        If (Mode=0) and (Not FoundOk) and (BinCount>0) then {* Adjust qty picked up to what has been allocated *}
        With IdR do
        Begin
          Stock_Deduct(IdR,InvR,BOff,BOn,3); {* Reverse picked qty *}

          QtyPick:=QtyPick-BinCount;

          If (QtyPick<0.0) then
            QtyPick:=0.0;

          Stock_Deduct(IdR,InvR,BOn,BOn,3); {* Adjust picked qty *}

          QtyP:=QtyPick;
        end;

      end; {If Stock not multi bin type..}
    end; {If Qty <>0 ..}
  Finally
    TmpStat:=Presrv_BTPos(Fnum,KeyPath2,F[Fnum],TmpRecAddr,BOn,BOff);

    MLocCtrl^:=TMLoc;

  end; {Try.}
end; {Proc..}





Initialization

  ModalMode:=BOff;
  ModalInp:=BOff;

end.



