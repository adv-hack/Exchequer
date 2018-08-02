unit StkQtyU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, Math, StrUtils, ExtCtrls, SBSPanel,

  GlobVar,VarConst,ExWrap1U,CmpCtrlU, bkgroup, BorBtns, SysU1,

  //PR: 06/02/2012 ABSEXCH-9795
  QtyBreakVar;


type
  TStkQtyRec = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    QFF: TCurrencyEdit;
    QTF: TCurrencyEdit;
    QBF: TSBSComboBox;
    QUPF: TCurrencyEdit;
    QDF: TCurrencyEdit;
    QVF: TCurrencyEdit;
    QMF: TCurrencyEdit;
    QBCurrF: TSBSComboBox;
    QSCF: Text8Pt;
    SBSPanel1: TSBSBackGroup;
    Label81: Label8;
    QFLab: Label8;
    QTLab: Label8;
    Label84: Label8;
    Label86: Label8;
    Label85: Label8;
    Label87: Label8;
    Label88: Label8;
    Label89: Label8;
    Label82: Label8;
    QSDF: Text8Pt;
    I1TransDateF: TEditDate;
    Label812: Label8;
    I2TransDateF: TEditDate;
    UDF: TBorCheckEx;
    QDTF: TComboBox;
    Label83: Label8;
    Label810: Label8;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure QTFExit(Sender: TObject);
    procedure QDTFExit(Sender: TObject);
    procedure QUPFEnter(Sender: TObject);
    procedure QBFEnter(Sender: TObject);
    procedure QDFEnter(Sender: TObject);
    procedure QVFEnter(Sender: TObject);
    procedure QMFEnter(Sender: TObject);
    procedure QSCFExit(Sender: TObject);
    procedure QBCurrFEnter(Sender: TObject);
    procedure UDFClick(Sender: TObject);
    procedure QDTFClick(Sender: TObject);
    procedure QUPFKeyPress(Sender: TObject; var Key: Char);
    procedure QDFExit(Sender: TObject);
  private
    { Private declarations }
    ISCust,
    IdStored,
    JustCreated  :  Boolean;

    LQBMode      :  Byte;

    SKeypath     :  Integer;


    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Function QType2List(QT  :  Char)  :  Integer;

    Function List2QType(QT  :  Integer)  :  Char;

    Function BType2List(BT  :  Char)  :  Integer;

    Function List2BType(BT  :  Integer)  :  Char;

    Procedure OutId;

    procedure Form2Id;

    procedure SetCaption;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    //PR: 08/02/2012 Function to update qty break recs for customer after parent rec edited ABSEXCH-9795
    procedure UpdateCustomerQtyBreaks;
    procedure DeleteCustomerQtyBreaks;

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    Procedure Reset_OtherDisc(Mode  :  Char);

  public
    { Public declarations }

    StkKeyRef  :  Str255;

    ExLocal    :  TdExLocal;

    //PR: 08/02/2012 ABSEXCH-9795
    ParentDiscountRec : CustDiscType;

    Function CheckDateConflict(Var EMsg    :  Str80;
                                   Fnum,
                                   Keypath :  Integer)  :  Boolean;

    //PR: 07/02/2012 Function to check data conflicts on the new Qty Break record ABSEXCH-9795
    function CheckQtyBreakDateConflict(Var Emsg : Str80) : Boolean;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;


    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(RStock     :  StockRec;
                       RCust      :  CustRec;
                       Edit,
                       VO         :  Boolean);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer;
                            RStock   :  StockRec);

  end;


  Procedure SetQBMode(QBM  :  Byte);

Var //PR: 06/02/2012 Changed to TQtyBreakRec ABSEXCH-9795
  LastQtyB  :  TQtyBreakRec;

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
  VarRec2U,
  CurrncyU,
  ComnUnit,
  ComnU2,
  ColCtrlU,

  SysU2,

  StockU,
  CustR3U,

  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  PayF2U,

  {PayLineU,}

  ThemeFix,

  Saltxl1U,
  AuditNotes;




{$R *.DFM}


Const
  // MH 22/04/09: Added support for Value Based Discounts
  QTAry  :  Array[0..5] of Char = ('B','P','M','U','Q', 'V');

Var
  QBMode    :  Byte;  //1 = Stock QtyBreak, 2 = Cust QtyBreak, 3 = Cust Discount



Procedure SetQBMode(QBM  :  Byte);

Begin
  If (QBMode<>QBM) then
    QBMode:=QBM;
end;


{ ========== Build runtime view ======== }

procedure TStkQtyRec.BuildDesign;


begin


end;


procedure TStkQtyRec.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  QFF.DecPlaces:=Syss.NoQtyDec;
  QTF.DecPlaces:=Syss.NoQtyDec;
  QUPF.DecPlaces:=Syss.NoNetDec;
  QVF.DecPlaces:=Syss.NoNetDec;

  {$IFDEF MC_On}
    Set_DefaultCurr(QBCurrF.Items,BOn,BOff);
    Set_DefaultCurr(QBCurrF.ItemsL,BOn,BOn);
  {$ELSE}
    QBCurrF.Visible:=BOff;
    QUPF.Left:=QDF.Left;
  {$ENDIF}

  Set_DefaultQtyB(QDTF.Items,(LQBMode=3),BOn);
  //Set_DefaultQtyB(QDTF.ItemsL,(LQBMode=3),BOn);

//  QMF.DisplayFormat:=GenPcnt2dMask;
  QMF.DecPlaces:=2;

//  QDF.DisplayFormat:=GenPcnt2dMask;
  QDF.DecPlaces:=2;


  If (LQBMode=3) then {* Customer discount entry *}
  Begin
    QFLab.Visible:=BOff;
    QTLab.Visible:=BOff;
    QFF.Visible:=BOff;
    QTF.Visible:=BOff;
    QSCF.TabStop:=BOn;
    QSCF.Tag:=1;
  end
  else
  Begin
    Label82.Visible:=BOff;
    QSDF.Visible:=BOff;
  end;

  {$IFNDEF LTE}

    UDF.Visible:=(LQBMode<>2);
    I1TransDateF.Visible:=(LQBMode<>2);
    I2TransDateF.Visible:=(LQBMode<>2);
    Label812.Visible:=(LQBMode<>2);
  {$ELSE}
    UDF.Visible:=BOff;
    I1TransDateF.Visible:=BOff;
    I2TransDateF.Visible:=BOff;
    Label812.Visible:=BOff;
  {$ENDIF}


  If (Owner is TStockRec) then
    With TStockRec(Owner) do
    Begin
      Self.SetFieldProperties(QBFPanel);
    end
  else
    If (Owner is TCustRec3) then
    With TCustRec3(Owner) do
    Begin
      Self.SetFieldProperties(CDSPanel);
    end;


  BuildDesign;

end;




procedure TStkQtyRec.FormCreate(Sender: TObject);
begin
  //PR: 08/02/2012 ABSEXCH-9795
  FillChar(ParentDiscountRec, SizeOf(ParentDiscountRec), 0);
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=300;//284;
  ClientWidth:=269;

  LQBMode:=QBMode;

  StkKeyRef:='';
  IsCust:=BOff;

  With TForm(Owner) do
    Self.Left:=Left+2;


  FormDesign;

end;




procedure TStkQtyRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,105);

end;

procedure TStkQtyRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TStkQtyRec.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TStkQtyRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TStkQtyRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TStkQtyRec.Send_UpdateList(Edit   :  Boolean;
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



Function TStkQtyRec.CheckNeedStore  :  Boolean;

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


Procedure TStkQtyRec.SetFieldFocus;

Begin
  Case LQBMode of
    1,2  :  If (QFF.CanFocus) then
              QFF.SetFocus;

    3    :  If (QDTF.CanFocus) then
              QDTF.SetFocus;
  end; {Case..}

end; {Proc..}




Function TStkQtyRec.ConfirmQuit  :  Boolean;

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
                if LQBMode = 3 then
                  StoreId(MiscF,SKeyPath)
                else //PR: 09/02/2012 For 1 & 2 use new qty break file. ABSEXCH-9795
                  StoreId(QtyBreakF, 0);
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


Function TStkQtyRec.QType2List(QT  :  Char)  :  Integer;

Var
  n        :  Byte;
  FoundOk  :  Boolean;


Begin
  FoundOk:=BOff;

  For n:=0 to High(QTAry) do
  Begin
    FoundOk:=(QT=QTAry[n]);
    If (FoundOk) then
      Break;
  end;

  If (FoundOk) then
    Result:=n
  else
    Result:=0;

end;

Function TStkQtyRec.List2QType(QT  :  Integer)  :  Char;

Begin
  If (QT In [Low(QTAry)..High(QTAry)]) then
    Result:=QTAry[QT]
  else
    Result:=QTAry[0];
end;


Function TStkQtyRec.BType2List(BT  :  Char)  :  Integer;


Begin
  If (Not (BT In ['A'..'H'])) then
    Result:=0
  else
    Result:=Ord(BT)-Pred(Ord('A'));

end;

Function TStkQtyRec.List2BType(BT  :  Integer)  :  Char;

Begin
  If (BT=0) then
    Result:=C0
  else
    Result:=Chr(Pred(Ord('A'))+BT);

end;


{ ============== Display Id Record ============ }



procedure TStkQtyRec.SetIdStore(EnabFlag,
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


procedure TStkQtyRec.SetCaption;


Begin
  With ExLocal,LStock,LCust do
  Begin
    Case LQBMode of
      1,2  :  Caption:='Qty Break Record for : '+dbFormatName(StockCode,Desc[1]);
      3    :  Caption:='Discount Record for : '+dbFormatName(CustCode,Company);
    end; {Case..}
  end;
end;

(*  Add is used to add Notes *)

procedure TStkQtyRec.ProcessId(Fnum,
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
      OutId;

      If (LQBMode = 3) {And (ExLocal.LMiscRecs^.CustDiscRec.QBType = QBValueCode)} And Assigned(QDTF.OnClick) Then
        QDTF.OnClick(Self);

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
  With ExLocal,LMiscRecs^ do
  begin

    If (Not Edit) then
    Begin
      Case LQBMode of
        1,2  :  Caption:='Add Quantity Break';
        3    :  Caption:='Add Discount';
      end; {Case..}

      LResetRec(Fnum);

      IsCust:=((ISACust(LCust.CustSupp)) or (LQBMode=1));

      //PR: 06/02/2012 Changed to use new qty break file ABSEXCH-9795
      Case LQBMode of
        1,2  :  With ExLocal.LQtyBreakRec do
                Begin
{                  RecMfix:=QBDiscCode;
                  Subtype:=QBDiscSub;}

                  If (IsCust) then
                    qbBreakType := dtPriceBand
                  else
                    qbBreakType := dtSpecialPrice;

                  If (LCust.CDiscCh In StkBandSet) then
                    qbPriceBand := LCust.CDiscCh
                  else
                    qbPriceBand := 'A';

                  If (LastQtyBreakRec.qbStockFolio = LStock.StockFolio) then
                    qbQtyFrom  := LastQtyBreakRec.qbQtyTo + 1;

                  If (qbQtyFrom<>0) then
                    qbQtyTo := qbQtyFrom + (LastQtyBreakRec.qbQtyTo - LastQtyBreakRec.qbQtyFrom);


                  qbStockFolio:=LStock.StockFolio;

                  If (LQBMode=2) then
                  Begin

                    qbAcCode := LCust.CustCode;

//                    If (LastQtyB^.QStkFolio = LStock.StockFolio) then
                    qbCurrency := LastQtyB.qbCurrency;

                  end;

//                  LastQtyBreakRec := LQtyBreakRec;
                end;

        3    :  With CustDiscRec do
                Begin
                  RecMfix:=CDDiscCode;
                  Subtype:=LCust.CustSupp;

                  If (IsACust(LCust.CustSupp)) then
                    QBType:=QBBandCode
                  else
                    QBType:=QBQtyBCode;

                  If (LCust.CDiscCh In StkBandSet) then
                    QBand:=LCust.CDiscCh
                  else
                    QBand:='A';

                  DCCode:=LCust.CustCode;
                end;
      end; {Case..}


      OutId;

    end;

    LastMisc^:=LMiscRecs^;

    SetIdStore(BOn,ExLocal.LViewOnly);

    UDFClick(Nil);
  end {If Abort..}
  else
    Close;



end; {Proc..}


  Function TStkQtyRec.CheckDateConflict(Var EMsg    :  Str80;
                                            Fnum,
                                            Keypath :  Integer)  :  Boolean;

  Var
    TmpMisc
         :  MiscRec;

    KeyChk,
    KeyS :  Str255;

    FoundConflict
         :  Boolean;

    RecAddr
         :  LongInt;

  Begin
    FoundConflict:=BOff;

    With ExLocal,TmpMisc do
    Begin
      TmpMisc:=LMiscRecs^;

        Case LQBMode of
          1    :  With QtyDiscRec do
                  Begin
                    KeyChk:=MakeQDKey(Copy(StkKeyRef,3,Length(StkKeyRef)-2),QBCurr,TQB);

                  end;
          3    :  With CustDiscRec do
                  Begin
                    KeyChk:=MakeCDKey(DCCode,QStkCode,QBCurr)+HelpKStop;
                  end;
        end; {Case..}

        KeyChk:=PartCCKey(RecMFix,SubType)+KeyChk;

        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundConflict) do
        With LMiscRecs^ do
        Begin
          Case LQBMode of
            1    :  With QtyDiscRec do
                    Begin
                      FoundConflict:=((QStartD<=TmpMisc.QtyDiscRec.QStartD) and (QEndD>=TmpMisc.QtyDiscRec.QEndD))
                            or ((QStartD>=TmpMisc.QtyDiscRec.QStartD) and (QEndD<=TmpMisc.QtyDiscRec.QEndD))
                            or ((Not QUseDates) and (Not TmpMisc.QtyDiscRec.QUseDates));

                      If (FoundConflict) then
                      Begin
                        If (QUseDates) then
                          EMsg:=POutDate(QStartD)+' - '+POutDate(QEndD)
                        else
                          EMsg:='Default Discount';
                      end;
                    end;

            3    :  With CustDiscRec do
                    Begin
                      // Don't compare Value Based Discounts against normal discounts
                      If (TmpMisc.CustDiscRec.QBType <> QBValueCode) And (QBType <> QBValueCode) Then
                      Begin
                        (*
                        FoundConflict := ((CStartD<=TmpMisc.CustDiscRec.CStartD) and (CEndD>=TmpMisc.CustDiscRec.CEndD))
                                         or
                                         ((CStartD>=TmpMisc.CustDiscRec.CStartD) and (CEndD<=TmpMisc.CustDiscRec.CEndD))
                                         or
                                         ((Not CUseDates) and (Not TmpMisc.CustDiscRec.CUseDates));

                        If (FoundConflict) then
                        Begin
                          If (CUseDates) then
                            EMsg:=POutDate(CStartD)+' - '+POutDate(CEndD)
                          else
                            EMsg:='Default Discount';
                        end;
                        *)
                        If CUseDates Then
                          // Only Check dates if in use
                          FoundConflict := ((CStartD>=TmpMisc.CustDiscRec.CStartD) and (CStartD<=TmpMisc.CustDiscRec.CEndD)) // Start date within range
                                           Or
                                           ((CEndD>=TmpMisc.CustDiscRec.CStartD) and (CEndD<=TmpMisc.CustDiscRec.CEndD)) // End Date within range
                                           Or
                                           ((TmpMisc.CustDiscRec.CStartD>=CStartD) and (TmpMisc.CustDiscRec.CStartD<=CEndD)) // Start date within range
                                           Or
                                           ((TmpMisc.CustDiscRec.CEndD>=CStartD) and (TmpMisc.CustDiscRec.CEndD<=CEndD)) // End Date within range
                        Else
                          FoundConflict := (Not CUseDates) and (Not TmpMisc.CustDiscRec.CUseDates);

                        If FoundConflict Then
                        Begin
                          If (CUseDates) then
                            EMsg := POutDate(CStartD) + ' - ' + POutDate(CEndD)
                          else
                            EMsg := 'Default Discount';
                        End; // If FoundConflict
                      End // If (TmpMisc.CustDiscRec.QBType <> QBValueCode) And (QBType <> QBValueCode) Then
                      Else
                      Begin
                        // Only compare VBD's against VBD's
                        If (TmpMisc.CustDiscRec.QBType = QBValueCode) And (QBType = QBValueCode) Then
                        Begin
                          // Only compare if they are either both using or not using dates
                          If (CUseDates = TmpMisc.CustDiscRec.CUseDates) Then
                          Begin
                            If CUseDates Then
                              // Only Check dates if in use
                              FoundConflict := ((CStartD>=TmpMisc.CustDiscRec.CStartD) and (CStartD<=TmpMisc.CustDiscRec.CEndD)) // Start date within range
                                               Or
                                               ((CEndD>=TmpMisc.CustDiscRec.CStartD) and (CEndD<=TmpMisc.CustDiscRec.CEndD)) // End Date within range
                                               Or
                                               ((TmpMisc.CustDiscRec.CStartD>=CStartD) and (TmpMisc.CustDiscRec.CStartD<=CEndD)) // Start date within range
                                               Or
                                               ((TmpMisc.CustDiscRec.CEndD>=CStartD) and (TmpMisc.CustDiscRec.CEndD<=CEndD)); // End Date within range

                            If FoundConflict Or (Not CUseDates) Then
                              // OK if threshold amounts are different
                              FoundConflict := (QSPrice = TmpMisc.CustDiscRec.QSPrice);

                            If FoundConflict then
                            Begin
                              If (CUseDates) then
                                EMsg:={Amount + } POutDate(CStartD) + ' - ' + POutDate(CEndD) + ' -  ' + Format('%0.2f', [QSPrice])
                              else
                                EMsg:='Default Discount for ' + Format('%0.2f', [QSPrice]);
                            End; // If FoundConflict
                          End; // If (CUseDates = TmpMisc.CustDiscRec.CUseDates)
                        End; // If (TmpMisc.CustDiscRec.QBType = QBValueCode) And (QBType = QBValueCode)
                      End; // Else
                    end;
          end; {Case..}

          If (FoundConflict) and (LastEdit) then {*Check its not the same record *}
          Begin
            Status:=GetPos(F[Fnum],Fnum,RecAddr);

            FoundConflict:=(RecAddr<>LastRecAddr[Fnum]);
          end;

          If (Not FoundConflict) then
            Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);

        end;

      LMiscRecs^:=TmpMisc;
    end;

    Result:=FoundConflict;
  end;

Function TStkQtyRec.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

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
  ShowMsg  :  Boolean;

  mbRet    :  Word;


Begin
  New(PossMsg);
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That Stock Code is not valid.';
  PossMsg^[2]:='Currency not Valid.';
  PossMsg^[3]:='From qty must be less than To qty.';
  PossMsg^[4]:='Price band is not valid.';
  PossMsg^[5]:='That date range is not valid.';
  PossMsg^[6]:='That date range conflicts with ';
  PossMsg^[7]:='';

  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal, LMiscRecs^ do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Case LQBMode of
                3  :  With CustDiscRec do
                        Result:=(QBType = QBValueCode) Or GetStock(Self,QStkCode,FoundCode,-1);
                else  Result:=BOn;
              end; {Case..}
            end;

      {$IFDEF MC_On}

        2  :  Case LQBMode of
                 1,2  :  With LQtyBreakRec do  //PR: 07/02/2012 Use new Qty Break record ABSEXCH-9795
                           Result:=(qbCurrency In [CurStart..CurrencyType]);

                 3    :  With CustDiscRec do
                           Result:=(QBCurr In [CurStart..CurrencyType]);
              end; {case..}

      {$ENDIF}

      3  :  Begin
              Case LQBMode of
                 1,2  :  With LQtyBreakRec do  //PR: 07/02/2012 Use new Qty Break record ABSEXCH-9795
                           Result:=(qbQtyFrom <= qbQtyTo);

                 3    :  Result:=BOn;
              end; {case..}
            end;

      4  :  Case LQBMode of
               1,2  :  With LQtyBreakRec do //PR: 07/02/2012 Use new Qty Break record ABSEXCH-9795
                         Result:=((qbPriceBand In StkBandSet) or (qbBreakType <> dtPriceBand));


               3    :  With CustDiscRec do
                         Result:=((QBand In StkBandSet) or (QBType<>QBBandCode) or (QBType<>QBValueCode));
            end; {case..}
        5  :  Case LQBMode of
                 1,2  :  With LQtyBreakRec do //PR: 07/02/2012 Use new Qty Break record ABSEXCH-9795
                           Result:=(Not qbUseDates) or (qbStartDate <= qbEndDate) or ((qbStartDate = '') and (qbEndDate=''));


                 3    :  With CustDiscRec do
                           Result:=(Not CUseDates) or (CStartD<=CEndD) or ((CStartD='') and (CEndD=''));

              end; {case..}

        6  :  Begin
                if LQBMode = 3 then
                  Result := Not CheckDateConflict(ExtraMsg,Fnum,Keypath)
                else //PR: 07/02/2012 Use new function to check new Qty Break record ABSEXCH-9795
                  Result := Not CheckQtyBreakDateConflict(ExtraMsg);

              end;

        // MH 27/07/09: Removed support for negative Special Prices and VBD Thresholds
        7  :  Case LQBMode Of
                 1, 2 :  Begin
                           If (LQtyBreakRec.qbBreakType = dtSpecialPrice) Then
                           Begin
                             // Special Price
                             Result := (LQtyBreakRec.qbSpecialPrice >= 0.0);
                             If (Not Result) Then
                               PossMsg^[7] := 'The Special Price cannot be negative';
                           End; // If (LQtyBreakRec.QBType = QBValueCode)

                           If Result And (LQtyBreakRec.qbBreakType = dtPriceBand) Then
                           Begin
                             // Discount %
                             Result := (LQtyBreakRec.qbDiscountPercent >= 0.0);
                             If (Not Result) Then
                               PossMsg^[7] := 'The Discount Percentage cannot be negative';

                             If Result Then
                             Begin
                               // Discount Value
                               Result := (LQtyBreakRec.qbDiscountAmount >= 0.0);
                               If (Not Result) Then
                                 PossMsg^[7] := 'The Discount Value cannot be negative';
                             End; // If Result
                           End; // If Result And (LQtyBreakRec.QBType = QBBandCode)

                           If Result And (LQtyBreakRec.qbBreakType In [dtMargin, dtMarkup]) Then
                           Begin
                             // Markup / Margin
                             Result := (LQtyBreakRec.qbMarginOrMarkup >= 0.0);
                             If (Not Result) Then
                               PossMsg^[7] := 'The ' + IfThen (LQtyBreakRec.qbBreakType = dtMargin, 'Margin', 'Markup') + ' cannot be negative';
                           End; // If Result And (LQtyBreakRec.QBType In [QBMarginCode, QBMarkupCode])
                         End; // 1, 3

                 3    :  Begin
                           If (CustDiscRec.QBType In [QBPriceCode, QBValueCode]) Then
                           Begin
                             // Special Price / VBD Threshold
                             Result := (CustDiscRec.QSPrice >= 0.0);
                             If (Not Result) Then
                               PossMsg^[7] := 'The ' + IfThen (CustDiscRec.QBType = QBPriceCode, 'Special Price', 'Threshold Value') + ' cannot be negative';
                           End; // If (CustDiscRec.QBType In [QBPriceCode, QBValueCode])

                           If Result And (CustDiscRec.QBType In [QBBandCode, QBValueCode]) Then
                           Begin
                             // Discount %
                             Result := (CustDiscRec.QDiscP >= 0.0);
                             If (Not Result) Then
                               PossMsg^[7] := 'The Discount Percentage cannot be negative';

                             If Result Then
                             Begin
                               // Discount Value
                               Result := (CustDiscRec.QDiscA >= 0.0);
                               If (Not Result) Then
                                 PossMsg^[7] := 'The Discount Value cannot be negative';
                             End; // If Result
                           End; // If Result And (CustDiscRec.QBType In [QBBandCode, QBValueCode])

                           If Result And (CustDiscRec.QBType In [QBMarginCode, QBMarkupCode]) Then
                           Begin
                             // Markup / Margin
                             Result := (CustDiscRec.QMUMG >= 0.0);
                             If (Not Result) Then
                               PossMsg^[7] := 'The ' + IfThen (CustDiscRec.QBType = QBMarginCode, 'Margin', 'Markup') + ' cannot be negative';
                           End; // If Result And (CustDiscRec.QBType In [QBMarginCode, QBMarkupCode])
                         End; // 3
              End; // Case LQBMode
    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(PossMsg^[Test]+ExtraMsg,mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}




procedure TStkQtyRec.StoreId(Fnum,
                            Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpMisc
       :  MiscRec;

  TempQtyBreakRec
       :  TQtyBreakRec;

  FoundCode
       :  Str20;

  KeyS :  Str255;

  //PR: 07/02/2012 ABSEXCH-9795
  QFolio : longint;
Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LMiscRecs^ do
  Begin

//    COk:=CheckCompleted(LastEdit,BOff);


    Cursor:=CrHourGlass;
    //PR: 06/02/2012 Changed to use new qty break file ABSEXCH-9795
    Case LQBMode of
      1,2  :  With LQtyBreakRec do
              Begin
                //DiscQtyCode:=MakeQDKey(Copy(StkKeyRef,3,Length(StkKeyRef)-2),QBCurr,TQB);
                if LQBMode = 1 then
                begin
                  qbAcCode := LJVar('', CustKeyLen);
                  qbFolio := 0;
                end;
                qbQtyToString := FormatBreakQtyTo(qbQtyTo);

                //PR: 08/02/2012 If we're adding a qty break header then set qb folio. ABSEXCH-9795
                if not LastEdit and (LQBMode = 2) then
                begin
                  qbFolio := ParentDiscountRec.QtyBreakFolio;
                  qbUseDates := ParentDiscountRec.CUseDates;
                  qbStartDate := ParentDiscountRec.CStartD;
                  qbEndDate := ParentDiscountRec.CEndD;
                end;

                LastQtyB:= LQtyBreakRec;
              end;
      3    :  With CustDiscRec do
              Begin  //PR: 07/02/2012 If we're adding a qty break header, or editing a different header and
                     //changing it to qty break, then set qb folio. ABSEXCH-9795
                if (List2QType(QDTF.ItemIndex) = 'Q') and (not LastEdit or (QtyBreakFolio = 0)) then
                begin
                  QFolio := GetNextQtyBreakFolio;
                  if QFolio = 0 then
                    raise Exception.Create('Unable to find next Quantity Break folio number')
                  else
                    QtyBreakFolio := QFolio;
                end;

                DiscCode:=MakeCDKey(DCCode,QStkCode,QBCurr)+HelpKStop;
              end;
    end; {Case..}

    //PR: 10/02/2012 Moved from above so that all fields are set before validating ABSEXCH-9795
    COk:=CheckCompleted(LastEdit,BOff);


    If (COk) then
    Begin
      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpMisc:=LMiscRecs^;
          TempQtyBreakRec := LQtyBreakRec;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LMiscRecs^:=TmpMisc;
          LQtyBreakRec := TempQtyBreakRec;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end
      else
      Begin

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        SetCaption;
      end;

      //TW 07/11/2011 Add Edit audit note if update is successful.
      //PR: 22/11/2011 Amended to work with Stock as well as account + deal with add QtyBreak as well as update
      if(status = 0) then
      begin
        if Trim(ExLocal.LCust.CustCode)= '' then
          TAuditNote.WriteAuditNote(anStock, anEdit, ExLocal)
      end;


      Report_BError(Fnum,Status);


      If (StatusOk) and (LQBMode = 3) then
      With CustDiscRec do
      Begin


        {If (QBType<>LastMisc^.CustDiscRec.QBType) and (LastMisc^.CustDiscRec.QBType=QBQtyBCode)  and (LastEdit) then
        Begin

          GetStock(Self,QStkCode,FoundCode,-1);

          KeyS:=FullQDKey(QBDiscCode,LCust.CustSupp,FullCDKey(DCCode,Stock.StockFolio));

          DeleteLinks(KeyS,Fnum,Length(KeyS),Keypath,BOff);

        end; }

        //PR: 08/02/2012 If Stock or date fields changed, call new function to update qty break records ABSEXCH-9795
        if (QBType=QBQtyBCode) then
        begin
          if (QStkCode <> LastMisc^.CustDiscRec.QStkCode) or
             (CUseDates <> LastMisc^.CustDiscRec.CUseDates) or
             (CStartD <> LastMisc^.CustDiscRec.CStartD) or
             (CEndD <> LastMisc^.CustDiscRec.CEndD) then
                UpdateCustomerQtyBreaks;
        end;

        If (LastEdit) then {* Just in case delete or renumber has taken place, refresh *}
        Begin
          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}
        end;


      end;

      Send_UpdateList(LastEdit,18);

      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      IdStored:=BOn;

      SetIdStore(BOff,BOff);

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


{ ========== Procedure to Rename from one folio to another ======== }



procedure TStkQtyRec.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TStkQtyRec.EditLine(RStock     :  StockRec;
                              RCust      :  CustRec;
                              Edit,
                              VO         :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    LViewOnly:=VO;

    LStock:=RStock;
    LCust:=RCust;

    //PR: 07/02/2012 Added handling for new Qty Break file ABSEXCH-9795
    if LQBMode = 3 then
    begin
      AssignFromGlobal(MiscF);
      ProcessId(MiscF,MIK,LastEdit);
    end
    else
    begin
      AssignFromGlobal(QtyBreakF);

      //Save record to calculate default to & from qty
      LastQtyBreakRec := LQtyBreakRec;
      ProcessId(QtyBreakF,qbAcCodeIdx,LastEdit);
    end;

  end;
end;



procedure TStkQtyRec.CanCP1BtnClick(Sender: TObject);
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
        if LQBMode = 3 then
          StoreId(MiscF,SKeypath)
        else
          StoreId(QtyBreakF,0);
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


procedure TStkQtyRec.DeleteBOMLine(Fnum,
                                KeyPath  :  Integer;
                                RStock   :  StockRec);

Var
  MbRet  :  Word;
  GotRec :  Integer;
  FoundCode
         :  Str20;
  KeyS   :  Str255;

Begin
  //PR: 06/02/2012 Changed to use new qty break file ABSEXCH-9795
  if LQBMode in [1, 2] then
  begin
    FNum := QtyBreakF;
    KeyPath := qbAcCodeIdx;
  end;
  
  With ExLocal do
  Begin
    LStock:=RStock;
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

          //TW 07/11/2011 Adds MBD Delete audit note.
          if(status = 0) then
            TAuditNote.WriteAuditNote(anAccount, anEdit);

          Report_BError(Fnum,Status);
        end;

        If (StatusOk) then
        With LMiscRecs^.CustDiscRec do
        Begin
          If (LQBMode=3) then {* Delete any lower q breaks *}
          Begin
{            If (Stock.StockCode<>QStkCode) then
              GetStock(Self,QStkCode,FoundCode,-1);

              KeyS:=FullQDKey(QBDiscCode,LCust.CustSupp,FullCDKey(LCust.CustCode,Stock.StockFolio));

              DeleteLinks(KeyS,Fnum,Length(Keys),Keypath,BOff);
            end;}
            DeleteCustomerQtyBreaks;

          end; //mode = 3

          Send_UpdateList(BOff,19);
        end; //With

      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}









procedure TStkQtyRec.QTFExit(Sender: TObject);
begin
  If (ActiveControl<>CanCP1Btn) and (QTF.Value<QFF.Value) then
  Begin
    ShowMessage('To qty must be greater than From qty.');
    QTF.SetFocus;
  end;
end;


{ ===== Procedure to Reset Other Options ===== }

Procedure TStkQtyRec.Reset_OtherDisc(Mode  :  Char);


Var
  n  :  Byte;



Begin

  For n:=0 to High(QTAry) do
  With ExLocal,LMiscRecs^ do
  Begin

    If (QTAry[n]<>Mode) then
      Case n of

        0  :  Begin
                Case LQBMode of
                  1,2  :  With QtyDiscRec do
                          Begin
                            QBand:=C0;
                            QDiscP:=0;
                            QDiscA:=0;
                          end;
                  3    :  With CustDiscRec do
                          Begin
                            QBand:=C0;
                            QDiscP:=0;
                            QDiscA:=0;
                          end;
                end; {Case..}
              end;

        1  :  Case LQBMode of
                1,2  :  With QtyDiscRec do
                          QSPrice:=0;
                3    :  With CustDiscRec do
                          QSPrice:=0;
              end;{Case..}

        2,3:  Case LQBMode of
                1,2  :  With QtyDiscRec do
                          QMUMG:=0;
                3    :  With CustDiscRec do
                          QMUMG:=0;
              end;{Case..}

        4  :  ; // Qty Break

        // Value Based Discounts - only apply to customers/suppliers
        5  :  If (LQBMode = 3) Then
                With CustDiscRec Do
                Begin
                  QSPrice := 0.0;
                  QDiscP  := 0.0;
                  QDiscA  := 0.0;
                End; // With CustDiscRec Do
      end; {Case..}
  end; {Loop..}

end; {Proc..}


procedure TStkQtyRec.QDTFClick(Sender: TObject);
Var
  DiscountType : Char;
begin
(*
  // Artificially set the modified flag as it is only set on exit of the control and
  // we need to redesign the screen for VBD prior to leaving the control to stop windows
  // getting confused
  //If (Not QDTF.Modified) Then
    //QDTF.Modified := (QDTF.OrigValue <> QDTF.Text);

  //If QDTF.Modified Then
    QDTFExit(Sender);
*)


  DiscountType := List2QType(QDTF.ItemIndex);

  If (DiscountType = QBValueCode) Then
  Begin
    // Reformat screen for VBD
    {$IFDEF MC_ON}
      Label86.Caption := 'Currency';

      // Move currency up to gap left by Band
      QBCurrF.Top := QBF.Top;
    {$ENDIF}

    // Move Unit Price Value into gap left by Currency
    QUPF.Left := QBCurrF.Left;
    QUPF.Width := QDF.Width;
    Label85.Caption := 'Threshold Value';
  End // If (DiscountType = QBValueCode)
  Else
  Begin
    // Restore for other discounts
    Label86.Caption := 'Band';
    QBCurrF.Top := QUPF.Top;
    QUPF.Left := 149;
    QUPF.Width := 106;
  End; // Else

  If (LQBMode = 3) Then
  Begin
    // Disable Stock Code & Description for VBD
    QSCF.ReadOnly := (DiscountType = QBValueCode);
    QSCF.Enabled := Not QSCF.ReadOnly;
    QSCF.Color := IfThen (QSCF.Enabled, QDTF.Color, clBtnFace);
    QSCF.Visible := False; QSCF.Visible := True;  // Bodge to fix painting issue
    Label81.Font.Color := IfThen (QSCF.Enabled, Label84.Font.Color, clBtnShadow);

    Label82.Font.Color := IfThen (QSCF.Enabled, Label84.Font.Color, clBtnShadow);
    QSDF.Enabled := QSCF.Enabled;
  End; // Else

  // Band
  {$IFDEF MC_ON}
  QBF.Visible  := (DiscountType <> QBValueCode);
  {$ENDIF}
  QBF.ReadOnly := (Not QBF.Visible) Or (DiscountType <> QBBandCode) or (ExLocal.LViewOnly) or (Not ExLocal.InAddEdit);
  QBF.Enabled:=Not QBF.ReadOnly;
  QBF.Color := IfThen (QBF.Enabled, QDTF.Color, clBtnFace);
  If QBF.Visible Then
  Begin
    // Bodge to fix painting issue
    QBF.Visible := False;
    QBF.Visible := True;
  End; // If QBF.Visible
  Label86.Font.Color := IfThen (QBF.Enabled {$IFDEF MC_ON}or (DiscountType = QBValueCode){$ENDIF}, Label84.Font.Color, clBtnShadow);

  // Unit Price
  {$IFNDEF MC_ON}
    QUPF.Left := QDTF.Left;
  {$ENDIF}
  QUPF.ReadOnly := Not (DiscountType In [QBValueCode, QBPriceCode]);
  QUPF.Enabled:=Not QUPF.ReadOnly;
  QUPF.Color := IfThen (QUPF.Enabled, QDTF.Color, clBtnFace);
  QUPF.Visible := False; QUPF.Visible := True;  // Bodge to fix painting issue

  {$IFDEF MC_ON}
  // Currency - Available for all
  QBCurrF.Enabled := (LQBMode In [1, 3]);
  QBCurrF.Color := IfThen (QBCurrF.Enabled, QDTF.Color, clBtnFace);
  QBCurrF.Visible := False; QBCurrF.Visible := True;  // Bodge to fix painting issue
  If (DiscountType <> QBValueCode) Then
    Label85.Caption := IfThen(QUPF.Enabled, 'Unit Price', 'Currency');
  Label85.Font.Color := IfThen (QBCurrF.Enabled or QUPF.Enabled, Label84.Font.Color, clBtnShadow);
  {$ELSE}
  Label85.Caption := 'Unit Price';
  {$ENDIF}

  // Discount%
  QDF.ReadOnly := Not (DiscountType In [QBValueCode, QBBandCode]);
  QDF.Enabled:=Not QDF.ReadOnly;
  QDF.Color := IfThen (QDF.Enabled, QDTF.Color, clBtnFace);
  QDF.Visible := False; QDF.Visible := True;  // Bodge to fix painting issue
  Label87.Font.Color := IfThen (QDF.Enabled, Label84.Font.Color, clBtnShadow);
  Label83.Font.Color := IfThen (QDF.Enabled, Label84.Font.Color, clBtnShadow);

  // Discount Amount
  QVF.ReadOnly := QDF.ReadOnly;
  QVF.Enabled:=Not QVF.ReadOnly;
  QVF.Color := IfThen (QVF.Enabled, QDTF.Color, clBtnFace);
  QVF.Visible := False; QVF.Visible := True;  // Bodge to fix painting issue
  Label88.Font.Color := IfThen (QVF.Enabled, Label84.Font.Color, clBtnShadow);

  // Disable Markup/Margin for VBD
  QMF.ReadOnly := Not (DiscountType In [QBMarginCode, QBMarkupCode]);
  QMF.Enabled := Not QMF.ReadOnly;
  QMF.Color := IfThen (QMF.Enabled, QDTF.Color, clBtnFace);
  QMF.Visible := False; QMF.Visible := True;  // Bodge to fix painting issue
  Label89.Font.Color := IfThen (QMF.Enabled, Label84.Font.Color, clBtnShadow);
  Label810.Font.Color := IfThen (QMF.Enabled, Label84.Font.Color, clBtnShadow);
end;


procedure TStkQtyRec.QDTFExit(Sender: TObject);
begin
  If (ActiveControl<>CanCP1Btn) then
  With ExLocal,LMiscRecs^ do
  Begin
    Form2Id;


    Case LQBMode of
      1,2  :  With LQtyBreakRec do //PR: 07/02/2012 ABSEXCH-9795
              Begin
                If (LQBMode=2) and (qbBreakType In [dtMargin, dtMarkup]) and (Not IsACust(LCust.CustSupp)) then
                Begin
                  ShowMessage('That discount type is not allowed for suppliers.');
                  QDTF.SetFocus;
                end
                else
                  //If (QDTF.Modified) then
                  Begin //PR: 07/02/2012 ABSEXCH-9795
                    ResetOtherDiscountFields(LQtyBreakRec, qbBreakType); //QtyBreakVar.pas
                    OutId;
                  end;
              end;
      3   :   With CustDiscRec do
              Begin
                If (QBType In [QBMarginCode,QBMarkUpCode]) and (Not IsACust(LCust.CustSupp)) then
                Begin
                  ShowMessage('That discount type is not allowed for suppliers.');
                  QDTF.SetFocus;
                end
                else
                  //If (QDTF.Modified) then
                  Begin
                    Reset_OtherDisc(QBType);
                    QBFEnter(Sender);
                    OutId;
                  end;
              end;
    end; {Case..}

  end; {With..}
end;

procedure TStkQtyRec.QUPFEnter(Sender: TObject);
begin
  Form2Id;

  With ExLocal.LMiscRecs^ do
    Case LQBMode of
      1,2  :  With ExLocal.LQtyBreakRec do  //PR: 07/02/2012 ABSEXCH-9795
                QUPF.ReadOnly:=(qbBreakType <> dtSpecialPrice) or (ExLocal.LViewOnly) or (Not ExLocal.InAddEdit);

      3    :  With CustDiscRec do
                QUPF.ReadOnly:=(Not (QBType In [QBPriceCode,QBValueCode])) or (ExLocal.LViewOnly) or (Not ExLocal.InAddEdit);
    end; {Case..}
end;



procedure TStkQtyRec.QBFEnter(Sender: TObject);
begin
(*
  Form2Id;

  With ExLocal.LMiscRecs^ do
  Case LQBMode of
      1,2  :  With QtyDiscRec do
              Begin
                QBF.ReadOnly:=(QBType<>QBBandCode) or (ExLocal.LViewOnly) or (Not ExLocal.InAddEdit);

                If (Not QBF.ReadOnly) and (QBand=C0) then
                With ExLocal,LCust do
                Begin
                  If (CDiscCh In StkBandSet) and (QBMode=2) then
                    QBand:=CDiscCh
                  else
                    QBand:='A';

                  OutId;
                end;
              end; {With..}

      3    :  With CustDiscRec do
              Begin
                If (QBType = QBValueCode) Then
                Begin
                  // Reformat screen for VBD
                  Label86.Caption := 'Currency';

                  // Move currency up to gap left by Band
                  QBCurrF.Top := QBF.Top;

                  // Move Unit Price Value into gap left by Currency
                  QUPF.Left := QBCurrF.Left;
                  QUPF.Width := QDF.Width;
                  Label85.Caption := 'Threshold Value';
                End // If (QBType = QBValueCode)
                Else
                Begin
                  // Restore for other discounts
                  Label86.Caption := 'Band';
                  QBCurrF.Top := QUPF.Top;
                  QUPF.Left := 149;
                  QUPF.Width := 106;
                  Label85.Caption := 'Unit Price';
                End; // Else

                // Disable Stock Code for VBD
                QSCF.ReadOnly := (QBType = QBValueCode);
                QSCF.Enabled := Not QSCF.ReadOnly;
                QSCF.Color := IfThen (QSCF.Enabled, QDTF.Color, clBtnFace);
                QSCF.Visible := False; QSCF.Visible := True;  // Bodge to fix painting issue
                Label81.Font.Color := IfThen (QSCF.Enabled, Label88.Font.Color, clBtnShadow);
                Label82.Font.Color := IfThen (QSCF.Enabled, Label88.Font.Color, clBtnShadow);
                QSDF.Enabled := QSCF.Enabled;

                // Disable Markup/Margin for VBD
                QMF.ReadOnly := (QBType = QBValueCode);
                QMF.Enabled := Not QMF.ReadOnly;
                QMF.Color := IfThen (QSCF.Enabled, QDTF.Color, clBtnFace);
                QMF.Visible := False; QMF.Visible := True;  // Bodge to fix painting issue
                Label89.Font.Color := IfThen (QSCF.Enabled, Label88.Font.Color, clBtnShadow);

                // Hide Band for VBD
                QBF.Visible  := (QBType <> QBValueCode);
                QBF.ReadOnly := (Not QBF.Visible) Or (QBType<>QBBandCode) or (ExLocal.LViewOnly) or (Not ExLocal.InAddEdit);

                QBF.Enabled:=Not QBF.ReadOnly;

                If (Not QBF.ReadOnly) and (QBand=C0) then
                  With ExLocal,LCust do
                  Begin
                    If (CDiscCh In StkBandSet) and (QBMode=2) then
                      QBand:=CDiscCh
                    else
                      QBand:='A';

                    OutId;
                  end;
              end;

  end; {Case..}
  *)
end;

procedure TStkQtyRec.QDFEnter(Sender: TObject);
begin
  Form2Id;

  With ExLocal.LMiscRecs^ do
    Case LQBMode of
      1,2  :  With ExLocal.LQtyBreakRec do  //PR: 07/02/2012 ABSEXCH-9795
                QDF.ReadOnly:=(qbBreakType <> dtPriceBand) or (qbDiscountAmount <> 0) or (ExLocal.LViewOnly) or (Not ExLocal.InAddEdit);

      3    :  With CustDiscRec do
                QDF.ReadOnly:=(Not (QBType In [QBBandCode,QBValueCode])) or (QDiscA<>0) or (ExLocal.LViewOnly) or (Not ExLocal.InAddEdit);
    end; {Case..}

end;

procedure TStkQtyRec.QVFEnter(Sender: TObject);
begin
  Form2Id;

  With ExLocal.LMiscRecs^ do
  Case LQBMode of //PR: 06/02/2012 Changed to use new qty break file ABSEXCH-9795
      1,2  :  With ExLocal.LQtyBreakRec do
                QVF.ReadOnly:=(qbBreakType <> dtPriceBand) or (qbDiscountPercent <> 0) or (ExLocal.LViewOnly) or (Not ExLocal.InAddEdit);

      3    :  With CustDiscRec do
                QVF.ReadOnly:=(Not (QBType In [QBBandCode,QBValueCode])) or (QDiscP<>0) or (ExLocal.LViewOnly) or (Not ExLocal.InAddEdit);
  end; {Case..}

end;


procedure TStkQtyRec.QMFEnter(Sender: TObject);
begin
  Form2Id;

  With ExLocal.LMiscRecs^ do
    Case LQBMode of //PR: 06/02/2012 Changed to use new qty break file ABSEXCH-9795
      1,2  :  With ExLocal.LQtyBreakRec do
                QMF.ReadOnly:=(Not (qbBreakType In [dtMargin, dtMarkUp])) or (ExLocal.LViewOnly) or (Not ExLocal.InAddEdit);
      3    :  With CustDiscRec do
                QMF.ReadOnly:=(Not (QBType In [QBMarginCode,QBMarkUpCode])) or (ExLocal.LViewOnly) or (Not ExLocal.InAddEdit);
    end; {Case..}

end;


procedure TStkQtyRec.QSCFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetStock(Self.Owner,FoundCode,FoundCode,99));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(StockF);


        StillEdit:=BOff;

        Text:=FoundCode;

        QSDF.Text:=LStock.Desc[1];

      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;

procedure TStkQtyRec.QBCurrFEnter(Sender: TObject);
begin
  {$IFDEF MC_On}
     QBCurrF.ReadOnly:=(LQBMode=2); {* Currency cannot be changed when via customer mode *}
  {$ENDIF}
end;

procedure TStkQtyRec.UDFClick(Sender: TObject);
begin
  If UDF.Visible Then
  Begin
    If (UDF.Checked) and (I1TransDateF.DateValue='') and (Assigned(Sender)) then
    Begin
      I1TransDateF.DateValue:=Today;
      I2TransDateF.DateValue:=Today;

    end;

    I1TransDateF.ReadOnly:=Not UDF.Checked;
    //I1TransDateF.TabStop:=Not I1TransDateF.ReadOnly;
    I1TransDateF.Enabled:=Not I1TransDateF.ReadOnly;
    I1TransDateF.Color := IfThen (I1TransDateF.Enabled, QDTF.Color, clBtnFace);
    I1TransDateF.Visible := False; I1TransDateF.Visible := True;  // Bodge to fix painting issue

    I2TransDateF.ReadOnly:=I1TransDateF.ReadOnly;
    //I2TransDateF.TabStop:=Not I1TransDateF.ReadOnly;
    I2TransDateF.Enabled:=Not I2TransDateF.ReadOnly;
    I2TransDateF.Color := IfThen (I2TransDateF.Enabled, QDTF.Color, clBtnFace);
    I2TransDateF.Visible := False; I2TransDateF.Visible := True;  // Bodge to fix painting issue
  End; // If UDF.Visible
end;

procedure TStkQtyRec.QUPFKeyPress(Sender: TObject; var Key: Char);
begin
  If (Key = '-') Then
    Key := #0;
end;

// CJS 21/03/2011 ABSEXCH-11089
procedure TStkQtyRec.QDFExit(Sender: TObject);
begin
  if (QDF.Value > 100.00) then
    QDF.Value := 100.00;
end;

procedure TStkQtyRec.Form2Id;
begin
  Case LQBMode of
    1,2  : //PR: 06/02/2012 Changed to use new qty break file ABSEXCH-9795
       With EXLocal.LQtyBreakRec do
  Begin
    qbQtyFrom := QFF.Value;
    qbQtyTo := QTF.Value;

    qbBreakType := TBreakType(QDTF.ItemIndex);

    If QBF.Enabled Then
      qbPriceBand := List2BType(QBF.ItemIndex + 1)
    Else
      qbPriceBand := C0;

    {$IFDEF MC_On}
      If (QBCurrF.ItemIndex >= 0) then
        qbCurrency := QBCurrF.ItemIndex;
    {$ENDIF}

    qbSpecialPrice := IfThen (QUPF.Enabled, QUPF.Value, 0.0);
    qbDiscountPercent := IfThen (QDF.Enabled, QDF.Value, 0.0);
    qbDiscountAmount := IfThen (QVF.Enabled, QVF.Value, 0.0);
    qbMarginOrMarkup := IfThen (QMF.Enabled, QMF.Value, 0.0);

    qbUseDates := UDF.Checked;
    qbStartDate := LJVar(I1TransDateF.DateValue, 8);
    qbEndDate := LJVar(I2TransDateF.DateValue, 8);
  end; {with..}
    3  :  With EXLocal.LMiscRecs^.CustDiscRec do
            Begin
              QBType:=List2QType(QDTF.ItemIndex);

              QStkCode := FullStockCode(IfThen (QSCF.Enabled, QSCF.Text, ''));

              If QBF.Enabled Then
                QBand := List2BType(QBF.ItemIndex + 1)
              Else
                QBand := C0;

              {$IFDEF MC_On}
                If (QBCurrF.ItemIndex>=0) then
                  QBCurr:=QBCurrF.ItemIndex;
              {$ENDIF}

              QSPrice := IfThen (QUPF.Enabled, QUPF.Value, 0.0);
              QDiscP := IfThen (QDF.Enabled, QDF.Value, 0.0);
              QDiscA := IfThen (QVF.Enabled, QVF.Value, 0.0);
              QMUMG := IfThen (QMF.Enabled, QMF.Value, 0.0);

              CUseDates:=UDF.Checked;
              CStartD:=I1TransDateF.DateValue;
              CEndD:=I2TransDateF.DateValue;

            end; {with..}
  end; {Case..}

end;

procedure TStkQtyRec.OutId;
Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  KeyS      :  Str255;

  Idx : SmallInt;
Begin
  Case LQBMode of
    1,2 //PR: 06/02/2012 Changed to use new qty break file ABSEXCH-9795
     :  With ExLocal,LQtyBreakRec do
        Begin
          // Reformat dialog depending on discount type
          QDTF.ItemIndex := Ord(qbBreakType);
          QDTFClick(Self);

          QSCF.Text:=Strip('R',[#32],LStock.StockCode);

          QFF.Value := qbQtyFrom;
          QTF.Value := qbQtyTo;

          If QBF.Enabled Then
          Begin
            Idx := BType2List(qbPriceBand);
            QBF.ItemIndex := IfThen (Idx = 0, 0, Idx - 1)
          End
          Else
            QBF.ItemIndex := -1;

          {$IFDEF MC_On}
//             If (qbCurrency >= 0) then
               QBCurrF.ItemIndex := qbCurrency;
          {$ENDIF}

          If QUPF.Enabled Then
            QUPF.Value := qbSpecialPrice
          Else
            QUPF.Value := 0.0;

          If QDF.Enabled Then
            QDF.Value := qbDiscountPercent
          Else
            QDF.Value := 0.0;

          If QVF.Enabled Then
            QVF.Value := qbDiscountAmount
          Else
            QVF.Value := 0.0;

          If QMF.Enabled Then
            QMF.Value := qbMarginOrMarkup
          Else
            QMF.Value := 0.0;

          UDF.Checked := qbUseDates;
          UDFClick(Self);
          I1TransDateF.DateValue := qbStartDate;
          I2TransDateF.DateValue := qbEndDate;

        end;
    3    :
        With ExLocal,LMiscRecs^.CustDiscRec do
        Begin
          // Reformat dialog depending on discount type
          QDTF.ItemIndex:=QType2List(QBType);
          QDTFClick(Self);

          QSCF.Text:=Strip('R',[#32],QStkCode);

          If (LStock.StockCode<>QStkCode) then
          Begin
            LGetMainRecPos(StockF,QStkCode);
          end;

          QSDF.Text:=ExLocal.LStock.Desc[1];

          If QBF.Enabled Then
          Begin
            Idx := BType2List(QBand);
            QBF.ItemIndex := IfThen (Idx = 0, 0, Idx - 1)
          End
          Else
            QBF.ItemIndex := -1;

          {$IFDEF MC_On}
//             If (QBCurr>=0) then
               QBCurrF.ItemIndex := QBCurr;
          {$ENDIF}

          If QUPF.Enabled Then
            QUPF.Value := QSPrice
          Else
            QUPF.Value := 0.0;

          If QDF.Enabled Then
            QDF.Value:=QDiscP
          Else
            QDF.Value := 0.0;

          If QVF.Enabled Then
            QVF.Value:=QDiscA
          Else
            QVF.Value := 0.0;

          If QMF.Enabled Then
            QMF.Value:=QMUMG
          Else
            QMF.Value := 0.0;

          UDF.Checked:=CUseDates;
          UDFClick(Self);
          I1TransDateF.DateValue:=CStartD;
          I2TransDateF.DateValue:=CEndD;
        end;
  end; {Case..}

end;

//PR: 07/02/2012 Function to check data conflicts on the new Qty Break record ABSEXCH-9795
function TStkQtyRec.CheckQtyBreakDateConflict(var Emsg: Str80): Boolean;
Var
  TmpQtyBreak :  TQtyBreakRec;

  KeyChk,
  KeyS :  Str255;

  FoundConflict
       :  Boolean;

  RecAddr
       :  LongInt;

  KeyPath : Integer;

  function FloatRangeClash(Start1, End1, Start2, End2 : Double) : Boolean;
  begin
    Result := (Start1 >= Start2) and (Start1 <= End2) or
              (End1 >= Start2) and (End1 <= End2);
  end;

  function QtyRangeClash : Boolean;
  begin
    with ExLocal.LQtyBreakRec do
      Result := FloatRangeClash(TmpQtyBreak.qbQtyFrom, TmpQtyBreak.qbQtyTo,
                                qbQtyFrom, qbQtyTo)
                or
                FloatRangeClash(qbQtyFrom, qbQtyTo,
                                TmpQtyBreak.qbQtyFrom, TmpQtyBreak.qbQtyTo);
  end;


  function SameDates : Boolean;
  begin
    with ExLocal.LQtyBreakRec do
      Result := (qbStartDate = TmpQtyBreak.qbStartDate) and (qbEndDate = TmpQtyBreak.qbEndDate) or
                (not qbUseDates and not TmpQtyBreak.qbUseDates);
  end;

  function RangeClash(const Start1, End1, Start2, End2 : string) : Boolean;
  begin
    Result := (Start1 > Start2) and (Start1 < End2) or
              (End1 > Start2) and (End1 < End2);
  end;

  function DateRangeClash : Boolean;
  begin
    with ExLocal.LQtyBreakRec do
      Result := RangeClash(TmpQtyBreak.qbStartDate, TmpQtyBreak.qbEndDate,
                           qbStartDate, qbEndDate)
                or
                RangeClash(qbStartDate, qbEndDate,
                           TmpQtyBreak.qbStartDate, TmpQtyBreak.qbEndDate);
  end;

Begin
  FoundConflict:=BOff;

  With ExLocal do
  Begin
    TmpQtyBreak := LQtyBreakRec;

    With LQtyBreakRec do
    Begin

      if LQBMode = 1 then
      begin
        //PR: 09/07/2012 ABSEXCH-13085 Add false parameter to QtyBreakStartKey call so that it keeps zeros and matches currency
        KeyChk := QtyBreakStartKey(qbAcCode, qbStockFolio, False) + Char(qbCurrency);
        KeyPath := qbAcCodeIdx;
      end
      else
      begin
        KeyChk := FullNomKey(qbFolio);
        KeyPath := qbFolioIdx;
      end;

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq, F[QtyBreakF], QtyBreakF, LRecPtr[QtyBreakF]^, KeyPath, KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundConflict) do
      Begin
        { CJS 2012-07-05: ABSEXCH-13126 - Qty Breaks validation error}
        if (qbCurrency = TmpQtyBreak.qbCurrency) then
        begin
          //SSK 07/10/2016 2017-R1 ABSEXCH-15983: allow the dates to clash so long as the qty range doesn't and allow the quantities to clash so long as the dates don't
          if SameDates then
            FoundConflict := QtyRangeClash
          else
            FoundConflict := DateRangeClash and QtyRangeClash;
        end;

        If (FoundConflict) then
        Begin
          If (qbUseDates) then
            EMsg:=POutDate(qbStartDate)+' - '+POutDate(QbEndDate)
          else
            EMsg:='Default Discount (Quantity range)';
        end;

        If (FoundConflict) and (LastEdit) then {*Check its not the same record *}
        Begin
          Status:=GetPos(F[QtyBreakF], QtyBreakF, RecAddr);

          FoundConflict:=(RecAddr<>LastRecAddr[QtyBreakF]);
        end;

        If (Not FoundConflict) then
          Status:=Find_Rec(B_GetNext, F[QtyBreakF], QtyBreakF, LRecPtr[QtyBreakF]^, KeyPath, KeyS);

      end;

      LQtyBreakRec := TmpQtyBreak;
    end;  //With LQtyBreakRec
  end;  //With ExLocal

  Result:=FoundConflict;
end;

//PR: 08/02/2012 Function to update qty break recs for customer after parent rec edited ABSEXCH-9795
procedure TStkQtyRec.UpdateCustomerQtyBreaks;
var
  NewFolio     :  LongInt;

  FoundCode    :  Str20;
  KeyS,KeyChk  :  Str255;

  Res : Integer;
begin
  NewFolio := 0;
  If (GetStock(Self, ExLocal.LMiscRecs.CustDiscRec.QStkCode, FoundCode,-1)) then
    NewFolio:=Stock.StockFolio;

  if NewFolio <> 0 then
  begin
    KeyS := FullNomKey(ExLocal.LMiscRecs.CustDiscRec.QtyBreakFolio);

    Res := Find_Rec(B_GetGEq,F[QtyBreakF], QtyBreakF, RecPtr[QtyBreakF]^, qbFolioIdx, KeyS);

    while (Res = 0) and (QtyBreakRec.qbFolio = ExLocal.LMiscRecs.CustDiscRec.QtyBreakFolio) do
    begin
      //Update Stock folio and effective date fields.
      with ExLocal.LMiscRecs.CustDiscRec do
      begin
        QtyBreakRec.qbStockFolio := NewFolio;
        QtyBreakRec.qbUseDates := CUseDates;
        QtyBreakRec.qbStartDate := CStartD; //PR: 13/10/2014 ABSEXCH-14114 qbStartDate was being set to CEndD
        QtyBreakRec.qbEndDate := CEndD;
      end;

      Res := Put_Rec(F[QtyBreakF], QtyBreakF, RecPtr[QtyBreakF]^, qbFolioIdx);

      Report_BError(QtyBreakF, Res);

      Res := Find_Rec(B_GetNext,F[QtyBreakF], QtyBreakF, RecPtr[QtyBreakF]^, qbFolioIdx, KeyS);

      Application.ProcessMessages;
    end;

  end

end;

procedure TStkQtyRec.DeleteCustomerQtyBreaks;
var
  KeyS,KeyChk  :  Str255;
  Res : Integer;
begin
  KeyS := FullNomKey(ExLocal.LMiscRecs.CustDiscRec.QtyBreakFolio);

  Res := Find_Rec(B_GetGEq,F[QtyBreakF], QtyBreakF, RecPtr[QtyBreakF]^, qbFolioIdx, KeyS);

  //PR: 28/06/2012 ABSEXCH-13087 Added check that Account codes match to avoid stock qty breaks being deleted if CustDiscRec.QtyBreakFolio = 0
  while (Res = 0) and (QtyBreakRec.qbFolio = ExLocal.LMiscRecs.CustDiscRec.QtyBreakFolio)
                  and (QtyBreakRec.qbAcCode = ExLocal.LMiscRecs.CustDiscRec.DCCode) do
  begin
    Delete_Rec(F[QtyBreakF], QtyBreakF, qbFolioIdx);

    Res := Find_Rec(B_GetGEq,F[QtyBreakF], QtyBreakF, RecPtr[QtyBreakF]^, qbFolioIdx, KeyS);
  end;
end;

Initialization


QBMode:=0;

//New(LastQtyB);

//FillChar(LastQtyB^,Sizeof(LastQtyB^),0);

Finalization

//  Dispose(LastQtyB);

end.
