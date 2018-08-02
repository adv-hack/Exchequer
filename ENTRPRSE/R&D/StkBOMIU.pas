unit StkBOMIU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel,

  GlobVar,VarConst,ExWrap1U,CmpCtrlU,SBSOutL, bkgroup, BorBtns;


type
  TBOMRec = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    SCodeF: Text8Pt;
    DescF: Text8Pt;
    CostF: TCurrencyEdit;
    QtyF: TCurrencyEdit;
    SBSPanel1: TSBSBackGroup;
    Label81: Label8;
    Label83: Label8;
    Label85: Label8;
    Label82: Label8;
    CBFreeI: TBorCheck;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SCodeFExit(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
  private
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    BOMLValue    :  Double;

    
    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Procedure OutId;

    procedure Form2Id;

    Procedure BOMMoveEmUp(KeyChk,
                          KeyS,
                          KeyLimit:  Str255;
                          IncBy   :  LongInt;
                          Fnum,
                          KeyPath :  Integer);

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    procedure SetFreeIss;

    Function BOMWithBOM(BOM2Chk,
                        ThisBom  :  StockRec)  :  Boolean;

    Function ChkWithBOM(BOM2Chk,
                        ThisBom  :  StockRec)  :  Boolean;

    procedure SetHelpContextIDs; // NF: 22/06/06

  public
    { Public declarations }

    StockR     :  StockRec;

    ExLocal    :  TdExLocal;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit,
                        InsMode    :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSOutLineB) ;


    procedure EditLine(RStock     :  StockRec;
                       Edit,
                       InsMode    :  Boolean);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer;
                            RStock   :  StockRec);

  end;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
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

  {SysU2,}
  MiscU,

  StockU,

  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  PayF2U,
  PWarnU,
  {PayLineU,}

  {$IFDEF SOP}
    SysU2,
  {$ENDIF}


  InvFSu3U,
  ExThrd2U,
  Saltxl1U,
  AuditNotes;




{$R *.DFM}




{ ========== Build runtime view ======== }

procedure TBOMRec.BuildDesign;


begin
  {$IFDEF LTE}

    CBFreeI.Visible:=BOff;

  {$ENDIF}

end;


procedure TBOMRec.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  QtyF.DecPlaces:=Syss.NoQtyDec;
  CostF.DecPlaces:=Syss.NoCosDec;

  CBFreeI.Visible:=FullWOP;

  BuildDesign;

end;




procedure TBOMRec.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  BOMLValue:=0.0;

  Height:=200;
  Width:=278;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TStockRec) then
    With TStockRec(Owner) do
      Self.SetFieldProperties(NLOLine);

  FormDesign;

  SetHelpContextIDs; // NF: 22/06/06 Fix for incorrect Context IDs
end;




procedure TBOMRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,102);

end;

procedure TBOMRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TBOMRec.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TBOMRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TBOMRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TBOMRec.Send_UpdateList(Edit   :  Boolean;
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



Function TBOMRec.CheckNeedStore  :  Boolean;

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


Procedure TBOMRec.SetFieldFocus;

Begin
  SCodeF.SetFocus;

end; {Proc..}




Function TBOMRec.ConfirmQuit  :  Boolean;

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
                StoreId(PwrdF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(PwrdF,LastRecAddr[PWrdF]);

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

Procedure TBOMRec.OutId;

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  KeyS      :  Str255;


Begin
  With ExLocal,LPassWord.BillMatRec do
  Begin

    KeyS:=BillLink;

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    FoundOk:=StatusOk;

    If (Not StatusOk) then
      ResetRec(Fnum);

    AssignFromGlobal(StockF);

    SCodeF.Text:=Strip('R',[#32],LStock.StockCode);

    DescF.Text:=LStock.Desc[1];

    QtyF.Value:=QtyUsed;

    BOMLValue:=QtyCost;

    If (PChkAllowed_In(143)) then
      CostF.Value:=QtyCost
    else
      CostF.Value:=0.0;

    CBFreeI.Checked:=FreeIssue;

  end;

end;


procedure TBOMRec.Form2Id;

Begin

  With EXLocal,LPassWord.BillMatRec do
  Begin
    QtyUsed:=QtyF.Value;

    QtyCost:=BOMLValue;

    FullStkCode:=FullStockCode(SCodeF.Text);

    FreeIssue:=CBFreeI.Checked;
  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TBOMRec.ProcessId(Fnum,
                            Keypath     :  Integer;
                            Edit,InsMode
                                        :  Boolean);

Var
  CurrRLine,
  KeyS  :  Str255;


Begin

  Addch:=ResetKey;

  KeyS:=''; CurrRLine:='';

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
  With ExLocal,LPassWord,BillMatRec do
  begin
    LastIns:=InsMode;

    If (Not Edit) then
    Begin
      CurrRLine:=Password.BillMatRec.StockLink; {* this is correct, as LId not set on an insert *}

      LResetRec(Fnum);

      RecPfix:=BillMatTCode;
      SubType:=BillMatSCode;


      StockLink:=Full_StkBOMKey(StockR.StockFolio,StockR.BLineCount);

      If (InsMode) and (CheckKey(CurrRLine,StockLink,4,BOn)) then {*Set line to prevsious line*}
        StockLink:=CurrRLine;

      QCurrency:=StockR.PCurrency;

    end;


    LastPassWord:=LPassWord;

    OutId;

    If (Edit) then
      SetFreeIss;

  end; {If Abort..}

end; {Proc..}




Function TBOMRec.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  2;
  Fnum         =  StockF;
  Keypath      =  StkFolioK;


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
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That Stock Code is not valid.';
  PossMsg^[2]:='That Stock Code would cause a looped Bill of Material';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LPassWord.BillMatRec do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              KeyS:=BillLink;

              Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

              Result:=(StatusOk and (Stock.StockFolio<>StockR.StockFolio));

            end;

      2  :  Begin
              If (Stock.StockType=StkBillCode) then
                Result:=Not BOMWithBOM(Stock,StockR);
            end;

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}



{ ============ Procedure to Insert/Delete List Lines =========== }

Procedure TBOMRec.BOMMoveEmUp(KeyChk,
                              KeyS,
                              KeyLimit:  Str255;
                              IncBy   :  LongInt;
                              Fnum,
                              KeyPath :  Integer);


Var
  FoundOk,
  Locked       :  Boolean;

  Err          :  Byte;

  TmpKPath,
  TmpStat      :  Integer;

  LastLine,
  KLNoStr,
  BomLineStr   :  Str255;

  KLimitLno,
  BOMStkFolio,
  LoopCount,
  BomLineNo    :  LongInt;


  LAddr,
  TmpRecAddr   :  LongInt;





Begin

  FoundOk:=BOff; Locked:=BOff;

  Blank(KLNoStr,SizeOf(KLNoStr));

  KLNoStr:=Copy(KeyLimit,3,4);

  Move(KLNoStr[1],BOMStkFolio,Sizeof(BOMStkFolio));

  Blank(KLNoStr,SizeOf(KLNoStr));

  KLNoStr:=Copy(KeyLimit,7,Length(KeyLimit)-4);

  ConvNumBase(KLNoStr,16,Err,KLimitLNo);

  LoopCount:=0;

  KeyLimit:=Strip('R',[#0],KeyLimit);

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  LastLine:=KeyS;
                                                                                         {* Modded v4.30c to check actual line nos
                                                                                            as otherwise lines 255 or above fail *}
  While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) and (KeyS>=KeyLimit) and ((KeyS<>LastLine) or (LoopCount=0)) do
  Begin
    Inc(LoopCount);
    
    FoundOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

    If (FoundOk) and (Locked) then
    With Password.BillMatRec do
    Begin
      Blank(BOMLineStr,SizeOf(BOMLineStr));

      BOMLineStr:=Copy(StockLink,5,Length(StockLink)-4);

      ConvNumBase(BOMLineStr,16,Err,BOMLineNo);

      If (BOMLineNo<=(65535-IncBy)) and (Err=0) then
      Begin
        BOMLineNo:=BOMLineNo+IncBy;

        StockLink:=Full_StkBOMKey(BOMStkFolio,BOMLineNo);

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);
      end;

      Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
    end;

    Status:=Find_Rec(B_GetPrev,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
  end; {While..}


  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  If (LoopCount>0) then
  Begin
    Blank(KLNoStr,SizeOf(KLNoStr));

    KLNoStr:=Copy(LastLine,7,Length(KeyLimit)-4);

    ConvNumBase(KLNoStr,16,Err,KLimitLNo);

    If (KLimitLNo>=StockR.BLineCount) and (Err=0) then {* Check next no goes beyond last record *}
      StockR.BLineCount:=KLimitLNo+2;
  end;

end; {Loop..}



procedure TBOMRec.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk : Boolean;
  TmpPWrd : PassWordRec;
  KeyS :  Str255;
  ExLocal2 : TdExLocal;
Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LPassWord do
  Begin

    COk:=CheckCompleted(LastEdit,BOff);


    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpPWrd:=LPassWord;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LPassWord:=TmpPWrd;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);


      end
      else
      Begin
        If (LastIns) then
        Begin
          TmpPWrd:=LPassWord;


          BOMMoveEmUp(RecPFix+SubType+FullNomKey(StockR.StockFolio),
                 RecPFix+SubType+Full_StkBOMKey(StockR.StockFolio,65535),
                 RecPFix+SubType+BillMatRec.StockLink,
                 1,
                 Fnum,KeyPath);

          LPassWord:=TmpPWrd;

        end;


        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        Inc(StockR.BLineCount);
      end;



      //TW 08/11/2011 Add Edit audit note if update is successful using a temporary object
      //              to store the parent stock item.
      ExLocal2.Create();
      ExLocal2.LStock := StockR;

      if(status = 0) then
        TAuditNote.WriteAuditNote(anStock, anEdit, ExLocal2);

      ExLocal2.Destroy;
      Report_BError(Fnum,Status);

      If (StatusOk) then
      Begin
        With LastPassWord.BillMatRec do
          Calc_BillCost(QtyUsed,QtyCost,BOff,StockR,QtyTime);

        With LPassword.BillMatRec do
          Calc_BillCost(QtyUsed,QtyCost,BOn,StockR,QtyTime);
      end;

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


procedure TBOMRec.SetFieldProperties(Field  :  TSBSOutLineB) ;

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


procedure TBOMRec.EditLine(RStock     :  StockRec;
                           Edit,
                           InsMode    :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    StockR:=RStock;

    ProcessId(PWrdF,PWK,LastEdit,InsMode);
  end;
end;



{*** This routine has been replicated within RevalueU ***}

Function TBOMRec.BOMWithBOM(BOM2Chk,
                            ThisBom  :  StockRec)  :  Boolean;



Const
  Fnum      =  PWrdF;
  Keypath   =  HelpNdxK;

  Fnum2     =  StockF;
  Keypath2  =  StkFolioK;




Var
  FoundOk   :  Boolean;

  TmpKPath,
  TmpKPath2,
  TmpStat   :  Integer;

  TmpRecAddr,
  TmpRecAddr2
            :  LongInt;

  KeyS,
  KeyChk,
  KeyStk    :  Str255;


  TmpPWrd   :  PassWordRec;

  TmpStock  :  StockRec;

Begin

  FoundOk:=BOff;

  TmpStock:=Stock;
  TmpPWrd:=PassWord;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  TmpStat:=Presrv_BTPos(Fnum2,TmpKPath2,F[Fnum2],TmpRecAddr2,BOff,BOff);

  KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(ThisBom.StockFolio)));


  KeyS:=KeyChk;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
  With Password.BillMatRec do
  Begin

    KeySTk:=Copy(StockLink,1,Sizeof(TmpRecAddr));

    Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);


    If (StatusOk) then
    Begin

      FoundOk:=(Stock.StockFolio=BOM2Chk.StockFolio);

      If (Not FoundOk) and (Stock.StockType=StkBillCode) then
        FoundOk:=BOMWithBOM(BOM2Chk,Stock);

    end;

    If (Not FoundOk) then
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  Stock:=TmpStock;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  TmpStat:=Presrv_BTPos(Fnum2,TmpKPath2,F[Fnum2],TmpRecAddr2,BOn,BOff);

  PassWord:=TmpPWrd;

  BOMWithBOM:=FoundOk;

end; {Proc..}



Function TBOMRec.ChkWithBOM(BOM2Chk,
                            ThisBom  :  StockRec)  :  Boolean;
Var
  FoundOk   :  Boolean;


Begin
  FoundOk:=BOff;

  If (ThisBom.StockType=StkBillCode) then
  Begin
    FoundOk:=BOMWithBom(ThisBOM,BOM2Chk);

    If (FoundOk) then
    Begin
      Set_BackThreadMVisible(BOn);

      ShowMessage(Trim(BOM2Chk.StockCode)+' is already contained in '+
                        Trim(ThisBOM.StockCode));


      Set_BackThreadMVisible(BOff);
    end;
  end;

  ChkWithBOM:=FoundOk;

end;


procedure TBOMRec.SetFreeIss;

Begin
  With ExLocal,LStock do
  Begin
    
      CBFreeI.Visible:={$IFDEF SOP}(Not Is_SerNo(StkValType)) and {$ENDIF} (StockType<>StkBillCode);

    
  end;
end;

procedure TBOMRec.SCodeFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  Dupli,
  AltMod     :  Boolean;



begin
  Dupli := False;
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetStock(Self.Owner,FoundCode,FoundCode,3));

      If (FoundOk) then
      Begin
        Dupli:=Stock.StockFolio=StockR.StockFolio;

        FoundOk:=Not Dupli;

        If (FoundOk) then
          FoundOk:=Not ChkWithBOM(StockR,Stock);
      end;

      If (FoundOk) then {* Credit Check *}
      With ExLocal,LPassWord,BillMatRec do
      Begin

        AssignFromGlobal(StockF);

        BillLink:=FullNomKey(LStock.StockFolio);

        BOMLValue:=Round_Up(Calc_StkCP(Currency_ConvFT(LStock.CostPrice,LStock.PCurrency,QCurrency,
                              UseCoDayRate),LStock.BuyUnit,LStock.CalcPack),Syss.NoCosDec);

        If (PChkAllowed_In(143)) then
          CostF.Value:=BOMLValue;


        DescF.Text:=LStock.Desc[1];

        With LStock do
          QtyTime:=BOMProdTime+ProdTime;

        SetFreeIss;

      end;


      If (FoundOk) then
      Begin

        StopPageChange:=BOff;

        StillEdit:=BOff;

        Text:=FoundCode;


      end
      else
      Begin
        If (Dupli) then
        Begin
          Set_BackThreadMVisible(BOn);

          ShowMessage('A Bill of Material item cannot be added to itself!');

          Set_BackThreadMVisible(BOff);
        end;

        StopPageChange:=BOn;

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;

procedure TBOMRec.CanCP1BtnClick(Sender: TObject);
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
        StoreId(PWrdF,SKeypath);
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


procedure TBOMRec.DeleteBOMLine(Fnum,
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
        With LPassword.BillMatRec do
        Begin

          //PR: 05/01/2012 Add audit note when deleting BOM component from stock item. ABSEXCH-12357
          with TAuditNote.Create(EntryRec^.Login, @F[PwrdF]) do
          Try
            AddNote(anStock, StockR.StockFolio, anEdit);
          Finally
            Free;
          End;

          Calc_BillCost(QtyUsed,QtyCost,BOff,StockR,QtyTime);

          Send_UpdateList(BOff,17);



        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}

procedure TBOMRec.SetHelpContextIDs;
// NF: 22/06/06
begin
  // Fix incorrect IDs
  HelpContext := 1880;
  SCodeF.HelpContext := 1881;
  DescF.HelpContext := 1882;
  CostF.HelpContext := 1883;
  QtyF.HelpContext := 1884;
  CBFreeI.HelpContext := 1885;
end;


end.
