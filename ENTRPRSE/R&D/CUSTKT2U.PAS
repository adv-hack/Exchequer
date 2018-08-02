unit CuStkT2U;

interface

{$I DEFOVR.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, TEditVal, bkgroup, BTSupU1,
  SalTxl1U, GlobVar,VarConst,ExWrap1U, SBSPanel, VarRec2U;

type
  TCuStkT2 = class(TForm)
    Id3Panel: TSBSPanel;
    Id3SCodeLab: Label8;
    SBSPanel4: TSBSPanel;
    VATCCLab3: Label8;
    Label826: Label8;
    id3LocLab: Label8;
    Label83: Label8;
    Label846: Label8;
    SBSPanel1: TSBSPanel;
    Id3QtyLab: Label8;
    Id3UPLab: Label8;
    Id3DiscLab: Label8;
    Id3LTotLab: Label8;
    Label81: Label8;
    Label82: Label8;
    Label84: Label8;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    Bevel1: TBevel;
    T2SCodeF: Text8Pt;
    Id3SBox: TScrollBox;
    T2Desc1F: Text8Pt;
    T2Desc2F: Text8Pt;
    T2Desc3F: Text8Pt;
    T2Desc4F: Text8Pt;
    T2Desc5F: Text8Pt;
    T2Desc6F: Text8Pt;
    T2JCodeF: Text8Pt;
    T2JAnalF: Text8Pt;
    T2LocF: Text8Pt;
    T2NomF: Text8Pt;
    T2NDesc: Text8Pt;
    T2DepF: Text8Pt;
    T2CCF: Text8Pt;
    T2LTF: TSBSComboBox;
    T2Qty: TCurrencyEdit;
    T2UPriceF: TCurrencyEdit;
    T2DiscF: Text8Pt;
    T2LTotF: TCurrencyEdit;
    T2VATF: TSBSComboBox;
    T2CostF: TCurrencyEdit;
    T2Marg: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure T2Desc1FKeyPress(Sender: TObject; var Key: Char);
    procedure T2SCodeFExit(Sender: TObject);
    procedure T2JCodeFExit(Sender: TObject);
    procedure T2JAnalFExit(Sender: TObject);
    procedure T2CCFExit(Sender: TObject);
    procedure T2LocFExit(Sender: TObject);
    procedure T2NomFExit(Sender: TObject);
    procedure T2QtyEnter(Sender: TObject);
    procedure T2QtyExit(Sender: TObject);
    procedure T2CostFChange(Sender: TObject);
    procedure T2UPriceFExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure T2CostFEnter(Sender: TObject);
    procedure T2CostFExit(Sender: TObject);
    procedure T2VATFExit(Sender: TObject);
    procedure T2QtyKeyPress(Sender: TObject; var Key: Char);
    procedure T2VATFDropDown(Sender: TObject);
  private
    IgnoreExit,
    InDispRec,
    InOutId,
    RecDone,
    IdStored,
    BadQty,
    StopPageChange,
    JustCreated,
    FUnitPriceChanged
                 :  Boolean;

    SKeypath     :  Integer;

    LastQtyValue,
    LastCostValue:  Double;

    DescCList    :  Array[1..6] of Text8Pt;

    
    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;


    Procedure OutId;

    procedure Form2Id;

    procedure SetCaption;

    Procedure CKMoveEmUp(KeyChk,
                         KeyS,
                         KeyLimit:  Str255;
                         IncBy   :  LongInt;
                         Fnum,
                         KeyPath :  Integer);

    procedure tsCheck_LowCost;

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    ExLocal    :  TdExLocal;

    TeleSHed   :  MLocPtr;

    StkMode    :  Byte;

    PreAdd,
    NewRec     :  Boolean;

    procedure SetDescRO;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(Edit       :  Boolean);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer);

  end;


  Function Have_TSLine(ExLocal :  TdExLocal;
                       OSCode  :  Str20;
                       GetRec  :  Boolean)  :  Boolean;


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

  ColCtrlU,

  {SysU2,}
  {MLoc0U,}
  InvListU,
  InvLst2U,
  InvCtSuU,

  MiscU,
  InvFSu3U,
  DiscU3U,
  InvCT2Su,
  {InvLst3U,}

  {$IFDEF CU}
    Event1U,

  {$ENDIF}

  {$IFDEF VAT}
    GIRateU,
  {$ENDIF}

  ThemeFix,

  CuStkA4U,
  CuStkA2U,
  CuStkA3U,
  CuStkA5U,
  CuStkL1U;





{$R *.DFM}





procedure TCuStkT2.SetCaption;

Begin
  With ExLocal, LStock, LCust, LMLocCtrl^.cuStkRec do
  Begin
    Caption:=dbFormatName(StockCode,Desc[1])+'.TeleSales Record for : '+dbFormatName(CustCode,Company);

  end;


end;


procedure TCuStkT2.FormDesign;

Begin
  DescCList[1]:=t2Desc1F;
  DescCList[2]:=t2Desc2F;
  DescCList[3]:=t2Desc3F;
  DescCList[4]:=t2Desc4F;
  DescCList[5]:=t2Desc5F;
  DescCList[6]:=t2Desc6F;


  Set_DefaultVAT(t2VATF.Items,BOn,BOff);
  Set_DefaultVAT(t2VATF.ItemsL,BOn,BOn);

  Set_DefaultDocT(t2LTF.Items,BOff,BOff);
  Set_DefaultDocT(t2LTF.ItemsL,BOff,BOff);

  If (Not JBCostOn) then
  Begin
    t2JCodeF.Visible:=BOff;
    t2JAnalF.Visible:=BOff;
    Label846.Visible:=BOff;
  end;

  If (Not Syss.UseCCDep) then
  Begin
    t2CCF.Visible:=BOff;
    t2DepF.Visible:=BOff;
    VatCCLab3.Visible:=BOff;
  end;


  If (Not Syss.UseMLoc) then
  Begin
    t2LocF.Visible:=BOff;
    id3LocLab.Visible:=BOff;
  end;

  If (Not Show_CMG(SIN)) then
  Begin
    t2CostF.Visible:=BOff;
    t2Marg.Visible:=BOff;
    Label82.Visible:=BOff;
    Label84.Visible:=BOff;
  end;

  T2Qty.DecPlaces:=Syss.NoQtyDec;
  
  T2UPriceF.DecPlaces:=Syss.NoNetDec;
  
  Label81.Caption:=CCVATName^;
  
end;


procedure TCuStkT2.FormCreate(Sender: TObject);
begin
  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;
  NewRec:=BOff;
  PreAdd:=BOff;

  LastCostValue:=0.0;

  RecDone:=BOff;
  InOutId:=BOff;
  InDispRec:=BOff;
  IgnoreExit:=BOn;
  BadQty:=BOff;

  FUnitPriceChanged := BOff;

  LastQtyValue:=0;

  ClientHeight:=228;
  ClientWidth:=577;

  With TForm(Owner) do
    Self.Left:=Left+2;

  FormDesign;

  If (Owner is TTeleSFrm) then
    With TTeleSFrm(Owner) do
      Self.SetFieldProperties(D1RefPanel);


end;




procedure TCuStkT2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,104);

end;

procedure TCuStkT2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TCuStkT2.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TCuStkT2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If (Key=13) and (ExLocal.InAddEdit) and (t2Qty.focused) then
  Begin
    RecDone:=BOn;
  end;

  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);


end;

procedure TCuStkT2.FormKeyPress(Sender: TObject; var Key: Char);
begin


  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Function Have_TSLine(ExLocal :  TdExLocal;
                       OSCode  :  Str20;
                       GetRec  :  Boolean)  :  Boolean;

Var
  KeyS,
  KeyChk  :  Str255;

Begin
  With ExLocal,LMLocCtrl^,CuStkRec do
  Begin
    KeyChk:=PartCCKey(MatchTCode,MatchSCode)+Full_CuStkKey(csCustCode,OSCode);

    If (GetRec) then
    Begin
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[MLocF],MLocF,LRecPtr[MLocF]^,MLSecK,KeyS);

      Result:=StatusOk and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff));
    end
    else
    Begin
      Result:=CheckExsists(KeyChk,MLocF,MLSecK);
    end;
  end;
end;

Procedure TCuStkT2.WMCustGetRec(Var Message  :  TMessage);


Var
  StackQty  :  Double;
  OpoLineCtrl  :  TOpoLineCtrl;


Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      3  :  StoreId(MLocF,SKeypath);

      4  :  IgnoreExit:=BOff;

       1101..1102,1105
             :  Begin
                  New(OpoLineCtrl,Create(Pointer(LParam)));

                  try
                    With OpoLineCtrl^ do
                    Begin
                      If (MapToStkWarn) and ((T2SCodeF.Text<>OStockCode) or (WParam=1105)) then
                      Begin
                        StackQty:=T2Qty.Value;

                        If (StackQty=0.0) then
                          StackQty:=1.0;

                        {$B-}
                        If (WParam<>1105) and (Not Have_TSLine(ExLocal,OStockCode,BOff)) then
                        {$B+}
                        Begin


                          T2SCodeF.OrigValue:=T2SCodeF.Text;

                          T2SCodeF.Text:=OStockCode;

                          T2SCodeF.Modified:=BOn;


                          T2SCodeFExit(T2SCodeF);


                        end
                        else
                        If (Have_TSLine(ExLocal,OStockCode,BOn)) then
                        Begin
                          {Replace and edit other line}
                          ProcessId(MLocF,MLK,BOn);


                        end;

                        If (OSetQty) and (OLineQty>0.0) then
                        Begin
                          T2Qty.Value:=(StackQty*OLineQty);

                          T2QtyExit(T2Qty);
                        end else
                        begin
                          //SS 29/08/2016 2016-R3:ABSEXCH-17075:Stock Equivalents - Negative Stock qty.
                          T2Qty.Value:= StackQty;
                          T2QtyExit(T2Qty);
                        end;
                      end;
                    end;
                  finally
                    Dispose(OpoLineCtrl,Destroy);

                  end; {try..}

                end;


    end; {Case..}

  end;
  Inherited;
end;



{ == Procedure to Send Message to Get Record == }

Procedure TCuStkT2.Send_UpdateList(Edit   :  Boolean;
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



Function TCuStkT2.CheckNeedStore  :  Boolean;

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


Procedure TCuStkT2.SetFieldFocus;

Begin
  t2SCodeF.SetFocus;

end; {Proc..}





Function TCuStkT2.ConfirmQuit  :  Boolean;

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




procedure TCuStkT2.SetDescRO;

Var
  n  :  Byte;


Begin
  With ExLocal do
  Begin
    For n:=Low(DescCList) to high(DescCList) do
    Begin
      DescCList[n].ReadOnly:=LStock.ShowAsKit;
      DescCList[n].TabStop:=Not DescCList[n].ReadOnly;
    end;

  end;
  
  
end;


{ ============== Display Id Record ============ }

Procedure TCuStkT2.OutId;

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  n         :  Byte;

  KeyS      :  Str255;

  Dnum,
  Dnum2     :  Double;


Begin
  InOutId:=BOn;

  try
    SetCaption;

    With ExLocal,LMLocCtrl^,CuStkRec do
    Begin

      t2SCodeF.Text:=Trim(CsStockCode);

      For n:=Low(DescCList) to High(DescCList) do
        DescCList[n].Text:=csDesc[n];

      t2JCodeF.Text:=Trim(csJobCode);
      t2JAnalF.Text:=Trim(csJACode);
      t2LocF.Text:=Trim(csLocCode);

      t2LTF.ItemIndex:=csLineType;

      t2CCF.Text:=csCCDep[BOn];
      t2DepF.Text:=csCCDep[BOff];

      t2Qty.Value:=CaseQty(LStock,csQty);
      t2NomF.Text:=Form_BInt(csNomCode,0);

      If (csNomCode<>0) then
      Begin
        If (csNomCode<>LNom.NomCode)  then
          LGetMainRecPos(NomF,FullNomKey(csNomCode));

        t2NDesc.Text:=LNom.Desc;

      end;


      t2UPriceF.Value:=csNetValue;
      t2DiscF.Text:=PPR_PamountStr(csDiscount,csDiscCh);

      TL2ID(LId,CuStkRec);

      Dnum:=InvLTotal(LId,BOn,0);

      t2LTotF.Value:=Dnum;

      if (csVATCode In VATSet) then
      begin
        if (csVATCode = VATMCode) then					// SSK 27/06/2017 2017-R1 ABSEXCH-13530: changes for Inclusive VAT ('I')
          t2VATF.ItemIndex := GetVATIndex(VATICode)
        //VA:20/03/2018:2018-R2:ABSEXCH-19882:Telesales > Default VAT code is not displayed in transaction lines for EC member.
        else if (csVATCode in [VATEECCode, VATECDCode]) then
          t2VATF.ItemIndex := GetVATCIndex(csVATCode,Bon)
        else
          t2VATF.ItemIndex := GetVATIndex(csVATCode);

      end;

      Dnum2:=csQty*csCost;

      LastCostValue:=csCost;

      t2CostF.Value:=Dnum2;

      t2Marg.Value:=Calc_Pcnt(Dnum,Dnum-Dnum2);


    end;
  finally
    InOutId:=BOff;
  end;

end;


procedure TCuStkT2.Form2Id;

Var
  n     :  Byte;
  Rnum  :  Real;

Begin

  With EXLocal,LMLocCtrl^,CuStkRec do
  Begin
    CsStockCode:=FullStockCode(t2SCodeF.Text);

    For n:=Low(DescCList) to High(DescCList) do
      csDesc[n]:=DescCList[n].Text;

    If (JBCostOn) and (Not EmptyKey(t2JCodeF.Text,JobKeyLen)) then
      csJobCode:=FullJobCode(t2JCodeF.Text);

    If (JBCostOn) and (Not EmptyKey(t2JAnalF.Text,JobKeyLen)) then
      csJACode:=FullJACode(t2JAnalF.Text);

    If (Syss.UseMLoc) and (Not EmptyKey(t2LocF.Text,MLocKeyLen)) then
      csLocCode:=t2LocF.Text;

    csLineType:=t2LTF.ItemIndex;

    If (Syss.UseCCDep) and (Not EmptyKeyS(t2CCF.Text,CCKeyLen,BOff)) then
      csCCDep[BOn]:=FullCCDepKey(t2CCF.Text);

    If (Syss.UseCCDep) and (Not EmptyKeyS(t2DepF.Text,CCKeyLen,BOff)) then
      csCCDep[BOff]:=FullCCDepKey(t2DepF.Text);

    TL2ID(LId,CuStkRec);

    csQty:=Case2Ea(LId,LStock,t2Qty.Value);

    csNomCode:=IntStr(t2NomF.Text);


    csNetValue:=t2UPriceF.Value;

    Rnum:=csDiscount;

    ProcessInputPAmount(Rnum,csDiscCh,t2DiscF.Text);

    csDiscount:=Rnum;

    With t2VATF do
       if (ItemIndex > -1) then
       begin
         if (Items[ItemIndex][1] = 'I') then               // SSK 19/06/2017 2017-R1 ABSEXCH-13530 : changed for Inclusive Vat
         begin
           if not (csVATCode = VATMCode) then
             csVATCode := Items[ItemIndex][1];
         end
         else
           csVATCode := Items[ItemIndex][1];
       end;

    csCost:=LastCostValue;


  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TCuStkT2.ProcessId(Fnum,
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


      If (Not LMLocCtrl^.CuStkRec.csEntered) then
        LinkStk2TS(TeleSHed,LMLocCtrl^.CuStkRec,LStock,LCust,0);

      With TeleSHed^.TeleSRec,LMLocCtrl^,CuStkRec do
        SendSuperOpoStkEnq(csStockCode,csLocCode,tcCustCode,tcCurr,-1,0);

    end;

    
    If (Not Ok) or (Not GlobLocked) then
      AddCh:=Esc;
  end;


  If (Addch<>Esc) then
  With ExLocal,LMLocCtrl^,CuStkRec do
  begin

    UseNext:=Get_LastLineNo(LCust.CustCode);

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPfix:=MatchTCode;
      Subtype:=MatchSCode;

      LastQtyValue:=0;

      csLineNo:=UseNext;
      csCustCode:=LCust.CustCode;
      csLocCode:=TeleSHed^.TeleSRec.tcLocCode;

      csCode1:=Full_CuStkLKey(csCustCode,csLineNo);

      If (StkMode=2) then
      Begin
        csStockCode:=LStock.StockCode;
        csStkFolio:=LStock.StockFolio;
        PreAdd:=BOn;
      end;
    end
    else
    Begin
      LastQtyValue:=csQty*csQtyMul;

    end;

    LastMLoc^:=LMLocCtrl^;

    OutId;

  end {If Abort..}
  else
    Close;

end; {Proc..}



Function TCuStkT2.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

  Const
    NofMsgs      =  12;

  Type
    PossMsgType  = Array[1..NofMsgs] of Str80;

  Var
    PossMsg  :  ^PossMsgType;

    ShowMsg  :  Boolean;

    Test     :  Byte;

    mbRet    :  Word;

    FoundCode2
             :  Str10;

    FoundCode:  Str20;

    FoundLong:  LongInt;


  Begin
    ShowMsg := False;
    New(PossMsg);

    FillChar(PossMsg^,Sizeof(PossMsg^),0);

    PossMsg^[1]:='That Account Code is not valid.';
    PossMsg^[2]:='The Cost Centre Code is not valid.';
    PossMsg^[3]:='The Department Code is not valid.';
    PossMsg^[4]:='The Location Code is not valid.';
    PossMsg^[5]:='The Job Costing Code is not valid.';
    PossMsg^[6]:='The Job Costing Analysis Code is not valid.';
    PossMsg^[7]:='The '+CCVATName^+' Code is not valid.';
    PossMsg^[8]:='The Stock Code is not valid.';
    PossMsg^[9]:='The G/L is not valid.';
    PossMsg^[10]:='That stock/account code combination is not valid.';
    PossMsg^[11]:='An additional check is made via an external hook';
    PossMsg^[12]:='The Quantity required is not valid. Negative Stock is not allowed';



    Test:=1;

    Result:=BOn;


    While (Test<=NofMsgs) and (Result) do
    With ExLocal,LMLocCtrl^,CuStkRec do
    Begin
      {$B-}

      ShowMsg:=BOn;

      Case Test of

        1  :  Begin
                Result:=(Not EmptyKey(csCustCode,CustKeyLen));

                If (Result) then
                  Result:=(CheckRecExsists(csCustCode,CustF,CustCodeK));

                If (Result) then
                  Result:=Cust.CustSupp=SetFilterFromDoc(SIN);

              end;

        2  :  Result:=(Not Syss.UseCCDep) or GetCCDep(Self,csCCDep[BOn],FoundCode,BOn,-1);

        3  :  Result:=(Not Syss.UseCCDep) or GetCCDep(Self,csCCDep[BOff],FoundCode,BOff,-1);

        4  :  Result:=(Not Syss.UseMLoc) or ((Not EmptyKey(csLocCode,MLocKeyLen)) and (GetMLoc(Self,csLocCode,FoundCode2,'',-1)));

        5  :  Result:=(EmptyKey(csJobCode,JobCodeLen)) or (GetJob(Self,csJobCode,FoundCode,-1));

        6  :  Result:=(EmptyKey(csJobCode,JobCodeLen)) or (GetJobMisc(Self,csJACode,FoundCode,2,-1));

        7  :  Result:=(csVATCode In VATSet);

        8  :  Begin
                Result:=(Not EmptyKey(csStockCode,StkKeyLen));

                If (Result) then
                  Result:=(CheckRecExsists(csStockCode,StockF,StkCodeK));
              end;  


        9  :  Result:=(GetNom(Self,Form_Int(csNomCode,0),FoundLong,-1));

       10  :  If (Not LastEdit) or (LastMLoc^.CuStkRec.csStockCode<>csStockCode) then
                Result:=Not CheckExsists(PartCCKey(RecPFix,SubType)+Full_CuStkKey(csCustCode,csStockCode),MLocF,MLSecK)
              else
                Result:=BOn;

       11  :  Begin {* Opportunity for hook to validate this line as well *}
                 {$IFDEF CU}

                   Result:=ValidExitHook(4000,21,ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;


      12  :  Begin
              {$IFDEF STK}
                Result:=Not BadQty;
              {$ELSE}

                Result:=BOn;

              {$ENDIF}
            end;

      


      end;{Case..}

      {$B+}

      If (Result) then
        Inc(Test);

    end; {While..}

    If (Not Result) and (ShowMsg) then
      mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

    Dispose(PossMsg);

end; {Func..}



Procedure TCuStkT2.CKMoveEmUp(KeyChk,
                              KeyS,
                              KeyLimit:  Str255;
                              IncBy   :  LongInt;
                              Fnum,
                              KeyPath :  Integer);


Var
  FoundOk,
  Locked    :  Boolean;

  TmpKPath,
  TmpStat   :  Integer;

  LAddr,
  TmpRecAddr
            :  LongInt;





Begin

  FoundOk:=BOff; Locked:=BOff;

  TmpKPath:=GetPosKey;

  With ExLocal do
  Begin
    LAddr:=LastRecAddr[Fnum];

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);


    Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);


    While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) and (KeyS>=KeyLimit) do
    Begin
      Application.ProcessMessages;

      FoundOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

      With LMLocCtrl^.CuStkRec do
      If (FoundOk) and (Locked) and (csLineNo>0) then
      Begin
        LGetRecAddr(Fnum);

        csLineNo:=csLineNo+IncBy;

        csCode1:=Full_CuStkLKey(csCustCode,csLineNo);

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

        Status:=UnLockMLock(Fnum,LastRecAddr[Fnum]);
      end;

      Status:=Find_Rec(B_GetPrev,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);
    end; {While..}

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    LastRecAddr[Fnum]:=LAddr;

  end; {With..}

end; {Loop..}



procedure TCuStkT2.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;

  OrigPass,
  OldPass,
  TmpMLoc
           :  MLocRec;

  ChkCode,
  OneLCode,
  LastLCode,
  KeyN,OldCode
           :  Str255;

  KeyS     :  Str255;

  mbRet    :  Word;

  UseNext  :  LongInt;



Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LMLocCtrl^,cuStkRec do
  Begin
    COk:=CheckCompleted(LastEdit,BOff);



    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      csCode1:=Full_CuStkLKey(csCustCode,csLineNo);
      csCode2:=Full_CuStkKey(csCustCode,csStockCode);
      csCode3:=Full_CuStkKey2(csCustCode,csStockCode);

      If (LastMLoc^.CuStkRec.csLineNo<>csLineNo) then
      Begin
        OrigPass:=LMLocCtrl^;

        ChkCode:=PartCCKey(RecPFix,SubType)+csCustCode;

        LastLCode:=Strip('B',[#0],PartCCKey(RecPFix,SubType)+Full_CuStkLKey(csCustCode,65535));

        OneLCode:=Strip('B',[#0],PartCCKey(RecPFix,SubType)+Full_CuStkLKey(csCustCode,csLineNo));

        CKMoveEmUp(ChkCode,
                   LastLCode,
                   OneLCode,
                   1,
                   MLocF,MLK);

        LMLocCtrl^:=OrigPass;

      end;

      csEntered:=(csQty<>0);

      Tl2Id(LId,CuStkRec);

      CalcVAT(LId,TeleSHed^.TeleSRec.TcSetDisc);

      csVAT := LId.VAT;    // SSK 19/06/2017 2017-R1 ABSEXCH-13530 : rounded up to 2 decimal places

      csVATCode:=LId.VATCode;
      csNetValue:=LId.NetValue;


      Calc_TeleTots(TeleSHed,LastMLoc^.CuStkRec,-1);

      Calc_TeleTots(TeleSHed,LMLocCtrl^.CuStkRec,1);


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
        If (NewRec) then {* It was an edit, but new combo was added *}
        Begin
          OrigPass:=LMLocCtrl^;

          UseNext:=Get_LastLineNo(csCustCode);

          LMLocCtrl^:=OrigPass;

          csLineNo:=UseNext;

          csCode1:=Full_CuStkLKey(csCustCode,csLineNo);
        end;


        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end;

      Report_BError(Fnum,Status);


      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      IdStored:=BOn;

      If (LastEdit and NewRec) then {Remove old history}
      With LastMLoc^ do
        cu_DeleteCStkHistory(csCustCode,csStkFolio,BOff);


      Send_UpdateList(LastEdit,16);

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TCuStkT2.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TCuStkT2.EditLine(Edit       :  Boolean);


begin
  With ExLocal do
  Begin
    InDispRec:=BOn;

    try
      LastEdit:=Edit;

      ProcessId(MLocF,MLK,LastEdit);

    finally

      InDispRec:=BOff;
    end;
  end;
end;


procedure TCuStkT2.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      If (Not BadQty) then
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


procedure TCuStkT2.DeleteBOMLine(Fnum,
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
        With LMLocCtrl^,cuStkRec do
        Begin

          Calc_TeleTots(TeleSHed,CuStkRec,-1);

          cu_DeleteCStkHistory(csCustCode,csStkFolio,BOff);

          Send_UpdateList(BOff,17);


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}


procedure TCuStkT2.T2Desc1FKeyPress(Sender: TObject; var Key: Char);
begin
  If (Sender is Text8pt) then
  With Text8pt(Sender) do
  Begin
    If (SelStart>=MaxLength) then {* Auto wrap around *}
      SetNextLine(Self,Sender,T2Desc6F,Parent,Key);
  end;

end;

procedure TCuStkT2.T2SCodeFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt),ExLocal,LMLocCtrl^,CuStkRec do
  Begin
    AltMod:=(Modified or PreAdd);

    {$IFDEF CU} {* Call hooks here *}
      If (Not ReadOnly) and (ExLocal.InAddEdit) then
      Begin
        FoundCode:=Text;

        Text:=TextExitHook(4000,58,Text,ExLocal);

        AltMod:=(AltMod or (FoundCode<>Text));
      end;  

      {$ENDIF}



    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (Not InOutId)  and (Not InDispRec) then
    Begin
      PreAdd:=BOff;

      StillEdit:=BOn;

      FoundOk:=(GetStock(Self.Owner,FoundCode,FoundCode,3));


      If ((Not LastEdit) or (LastMLoc^.cuStkRec.csStockCode<>FoundCode)) and (InAddEdit) and (FoundOk) then
      Begin
        FoundOk:=(Not Check4DupliGen(PartCCKey(MatchTCode,MatchSCode)+Full_CuStkKey(csCustCode,FoundCode),MLocF,MLSecK,'Stock/Account combination'));

        NewRec:=FoundOk;
      end;

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(StockF);

        SetDescRO;


        StillEdit:=BOff;

        With TeleSHed^.TeleSRec do
          SendSuperOpoStkEnq(FoundCode,csLocCode,tcCustCode,tcCurr,-1,0);


        LinkStk2TS(TeleSHed,LMLocCtrl^.CuStkRec,LStock,LCust,1);

        csStkFolio:=LStock.StockFolio;

        {$IFDEF CU} {* Call any pre store hooks here *}
           GenTSHooks(4000,70,ExLocal,TeleSHed^);
        {$ENDIF}


        OutId;

        Text:=FoundCode;

        //HV and R Jha 06/01/2016, JIRA-17075, Issue in TeleSales screen,

        // CJS 2016-05-31 - ABSEXCH-17480 - Adding new item in Telesales does not default to Qty box
        // Reinstated the previously commented-out code
        If (NewRec) then
          t2Qty.SetFocus;
          
      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;



procedure TCuStkT2.T2JCodeFExit(Sender: TObject);
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

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) and (JBCostOn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJob(Self.Owner,FoundCode,FoundCode,4));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin
          AssignFromGlobal(JobF);

          Text:=FoundCode;

        end
        else
        Begin

          SetFocus;
        end; {If not found..}

      end
      else
        If (FoundCode='') then {* Reset Janal code *}
          T2JAnalF.Text:='';

    end;
  {$ENDIF}
end;


procedure TCuStkT2.T2JAnalFExit(Sender: TObject);
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

      If (((AltMod) or (FoundCode='')) and (Not EmptyKey(T2JCodeF.Text,JobCodeLen))) and (ActiveControl<>CanCP1Btn) and (JBCostOn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self.Owner,FoundCode,FoundCode,2,Anal_FiltMode(SIN)));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(JMiscF);

          Text:=FoundCode;


        end
        else
        Begin
          SetFocus;
        end; {If not found..}
      end;

    end;
  {$ENDIF}

end;

procedure TCuStkT2.T2CCFExit(Sender: TObject);
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

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (ActiveControl<>OkCP1Btn)
          and (Syss.UseCCDep)  then
      Begin

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


        end
        else
        Begin

          SetFocus;
        end; {If not found..}
      end;

    end; {with..}
  {$ENDIF}
end;


procedure TCuStkT2.T2LocFExit(Sender: TObject);
Var
  SCode      :  Str20;
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;


begin

  {$IFDEF SOP}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      Scode:=ExLocal.LId.StockCode;

      If (((AltMod) or ((FoundCode='') and Syss.UseMLoc)) and (ActiveControl<>CanCP1Btn) and (ActiveControl<>OkCP1Btn)
          and  (((Syss.UseMLoc) and (Is_FullStkCode(SCode))) or (Syss.UseLocDel)))  and (Not InOutId) and (Not InDispRec) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,SCode,77*Ord(Syss.UseMLoc)));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin
          Text:=FoundCode;

          Form2Id;

          {* If invoice and negative stock not allowed, reset qty *}
          If (TeleSHed^.TeleSRec.TcGenMode =1) and (CheckNegStk) then
          Begin
            LMLocCtrl^.CuStkRec.csQty:=0.0;
            LastQtyValue:=0.0;
          end;

          LinkStk2TS(TeleSHed,LMLocCtrl^.CuStkRec,LStock,LCust,1);

          OutId;
        end
        else
        Begin
          StopPageChange:=BOn;

          SetFocus;
        end; {If not found..}
      end;

    end; {with..}
  {$ENDIF}
end;




procedure TCuStkT2.T2NomFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (ActiveControl<>OkCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,2));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(NomF);

      end;


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=Form_Int(FoundLong,0);

        T2NDesc.Text:=Nom.Desc;
      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;



procedure TCuStkT2.T2QtyEnter(Sender: TObject);
begin
  With Exlocal, LMLocCtrl.CuStkRec do
    If (Not InOutId)  and (Not InDispRec) then
    Begin
      {If (csEntered) then
        LastQtyValue:=csQty
      else
        LastQtyValue:=0.0;}
    end;
end;

procedure TCuStkT2.tsCheck_LowCost;

Begin
  With ExLocal,LMLocCtrl^,CuStkRec do
    If (csNetValue<csCost) then
    Begin
      TL2Id(LId,CuStkRec);
      TH2Inv(LInv,TeleSHed^.TeleSRec,BOn);

      Check_LowCost(LId,LInv,LStock);
    end;


end;


procedure TCuStkT2.T2QtyExit(Sender: TObject);


Var
  Flg,
  FLowStk     :  Boolean;
  FoundCode   :  Str20;
  NewControl  :  TWinControl;
  IdR         :  Idetail;

  Rnum,
  Rnum2       :  Real;


begin

  Form2Id;

  FLowStk:=Boff;

  TL2Id(Idr,ExLocal.LMLocCtrl^.CuStkRec);

  If (ActiveControl<>CanCP1Btn)  and (Not InOutId)  and (Not InDispRec)  and ((Not IgnoreExit) or ((Not ExLocal.LastEdit) and (ExLocal.InAddEdit))) then
  With TCurrencyEdit(Sender),ExLocal,LMLocCtrl^,CuStkRec do
  Begin

    {$IFDEF CU} {* Call any pre store hooks here *}
       If (Not ReadOnly) and (ExLocal.InAddEdit) then
          csQty:=ValueExitHook(4000,25,csQty,ExLocal);
    {$ENDIF}


  {$IFDEF PF_On}

     If (Not EmptyKey(csStockCode,StkKeyLen)) then
     Begin

       If (LastQtyValue<>csQty) or (BadQty) then
       Begin

         Flg:=BOn;

         Rnum:=csNetValue;
         Rnum2:=csDiscount;

         Calc_StockPrice(LStock,LCust,TeleSHed^.TeleSRec.TcCurr,Calc_IdQty(csQty,csQtyMul,csUsePack),TeleSHed^.TeleSRec.TcTDate, 
                         Rnum,Rnum2,csDiscCh,csLocCode,Flg,0);

         csNetValue:=Rnum;
         csDiscount:=Rnum2;

         {$IFDEF CU} {* Call any pre store hooks here *}
           GenTSHooks(4000,71,ExLocal,TeleSHed^);
         {$ENDIF}

         // MH 25/06/2009: Modified to check Free Stock instead of In Stock quantities
         //Check_StockCtrl(csStockCode,(csQty*csQtyMul),2,FLowStk,SIN,IdR,Self.Handle);
         Check_StockCtrl(csStockCode,(csQty*csQtyMul),1,FLowStk,SIN,IdR,Self.Handle);

         //HV and R Jha 06/01/2016, JIRA-17075, Issue in TeleSales screen, When selecting stock and receiving an insufficient stock warning the system offers the option to use equivalent stock. When the alternative stock is selected the system does not test or validate in stock quantity and this can cause stock to go negative.
         If (TeleSHed^.TeleSRec.TcGenMode <>1) then {If non invoice, allow past stk warning}
           FLowStk:=BOff;

         BadQty:=(FLowStk and (csQty*csQtyMul<>0.0));
         LastQtyValue := csQty*csQtyMul;

         If (FLowStk) and (CanFocus) then {* Force adjustment *}
           SetFocus
         else
           tsCheck_LowCost;
       end;

       Form2Id; //HV and R Jha 06/01/2016, JIRA-17075, Issue in TeleSales screen, When selecting stock and receiving an insufficient stock warning the system offers the option to use equivalent stock. When the alternative stock is selected the system does not test or validate in stock quantity and this can cause stock to go negative.
       OutId;


      If (RecDone) and (Not BadQty) then
         SendMessage(Self.Handle,WM_CustGetRec,3,0);
     end;

   {$ENDIF}

  end; {With..}


end;




procedure TCuStkT2.T2CostFChange(Sender: TObject);
begin
  If (Not InOutId) and (Not InDispRec) then
    Form2Id;
end;

procedure TCuStkT2.T2CostFEnter(Sender: TObject);
begin
  If (Not InOutId) and (Not InDispRec) then
    t2CostF.Value:=LastCostValue;

end;

procedure TCuStkT2.T2CostFExit(Sender: TObject);
begin
  If (Not InOutId) and (Not InDispRec) then
  Begin
    LastCostValue:=t2CostF.Value;

    T2UPriceFExit(Sender);
  end;

end;

procedure TCuStkT2.T2UPriceFExit(Sender: TObject);

  function IsUnitPriceChanged: boolean;
  var
    orgNetVal : real;
  begin
     With EXLocal,LMLocCtrl^,CuStkRec do
     begin
       orgNetVal := Round_Up(ExLocal.LMLocCtrl^.CuStkRec.csNetValue, 2);
       result := Round_Up((abs(orgNetVal - T2UPriceF.value)), 2)>0.00;
     end;
  end;

begin
  If (Not InOutId) and (Not InDispRec) then
  Begin

    if (Sender = T2UPriceF) and ((ExLocal.LMLocCtrl^.CuStkRec.csVATCode = VATICode) or (ExLocal.LMLocCtrl^.CuStkRec.csVATCode = VATMCode)) then
    begin
      FUnitPriceChanged := IsUnitPriceChanged;
      if FUnitPriceChanged then
      begin
        MessageDlg('You have edited the Unit Price of a VAT Inclusive transaction,' + #13
                      + 'please reselect the VAT code', mtInformation, [mbOk], 0);
        T2VATF.setfocus;
        SendMessage(T2VATF.handle, CB_SHOWDROPDOWN, Integer(True), 0);
      end;
    end;

    Form2Id;

    If (Sender=T2UPriceF) then
      tsCheck_LowCost
    else
    With EXLocal,LMLocCtrl^,CuStkRec do
    Begin
      If  (csDiscCh In StkBandSet) then
      Begin
        csNetValue:=Get_StkPrice(LStock.SaleBands,csDiscount,csDiscCh,TeleSHed^.TeleSRec.TcCurr,LStock.SellUnit,
                                     csQtyMul,csUsePack);

      end;

    end;

    OutId;
  end;
end;


procedure TCuStkT2.FormActivate(Sender: TObject);
begin
  If (JustCreated) then
  Begin
    JustCreated:=BOff;


  end;

   OpoLineHandle:=Self.Handle;

end;


procedure TCuStkT2.T2VATFExit(Sender: TObject);
Var
  Flg         :  Boolean;                                    

  FoundCode   :  Str20;

  BalNow      :  Double;

  AltMod      :  Boolean;

  mbRet       :  Word;
begin
  Begin

    Form2Id;

    If (Sender is TSBSComboBox) then
    With (Sender as TSBSComboBox) do
    Begin
      if (T2VATF.Items[T2VATF.ItemIndex][1] = 'I') then
        AltMod := true
      else
        AltMod := Modified;

      If (ActiveControl<>CanCP1Btn) and (AltMod) then
      With ExLocal,LMLocCtrl^,CuStkRec do
      Begin
        {$IFDEF VAT}
          If ((csVATCode = VATICode) or (csVATCode = VATMCode)) and (Sender = T2VatF) then     // SSK 29/05/2017 2017-R1 ABSEXCH-13530: changes for Inclusive VAT ('I') then
          begin
            if not FUnitPriceChanged then
              mbRet := MessageDlg('Please ensure the U/Price is correct before applying' + #13 +
                            'an update to the Inclusive VAT(I) code', mtWarning, [mbOk, mbCancel], 0)
            else
              mbRet := mrOk;

            With TSBSComboBox(Sender) do
              if mbRet = mrOk then
              begin
                GetIRate(Parent.ClientToScreen(ClientPos(Left,Top+23)),Color,Font,Self.Parent,LViewOnly,csVATIncFlg);
                csVATCode := VATICode;
              end
              else

          end;

        {$ENDIF}


         OutId;

      end; {With..}
    end; {With..}
  end; {If..}
end;

procedure TCuStkT2.T2QtyKeyPress(Sender: TObject; var Key: Char);
begin
  If (Key = '-') Then Key := #0;
end;

procedure TCuStkT2.T2VATFDropDown(Sender: TObject);
begin
  // SSK 22/06/2017 2017-R1 ABSEXCH-13530 : this change will avoid selection of 'M' through keyboard
  if T2VATF.ItemIndex <> -1 then              //VA:20/03/2018:2018-R2:ABSEXCH-19882:Telesales > Default VAT code is not displayed in transaction lines for EC member.
  begin
    if T2VATF.Items[T2VATF.ItemIndex][1] in ['I', 'M'] then
      T2VATF.ItemIndex := 0;
  end;

end;

Initialization

end.
