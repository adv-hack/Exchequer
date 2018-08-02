unit MLocSRIU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, TEditVal, bkgroup, BTSupU1,
  SalTxl1U, GlobVar,VarConst,ExWrap1U, SBSPanel;

type
  TMLOCSRec = class(TForm)
    Label828: Label8;
    Label829: Label8;
    SRCPCF: TSBSComboBox;
    SRCPF: TCurrencyEdit;
    SRRPF: TCurrencyEdit;
    SRRPCF: TSBSComboBox;
    SBSBackGroup4: TSBSBackGroup;
    SRMIF: TCurrencyEdit;
    Label827: Label8;
    Label831: Label8;
    SRMXF: TCurrencyEdit;
    Label836: Label8;
    SRISF: TCurrencyEdit;
    SRPOF: TCurrencyEdit;
    Label835: Label8;
    Label837: Label8;
    SRALF: TCurrencyEdit;
    Label838: Label8;
    SRFRF: TCurrencyEdit;
    SROOF: TCurrencyEdit;
    Label834: Label8;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    WIPLab: Label8;
    SalGL: Text8Pt;
    COSGL: Text8Pt;
    WOGL: Text8Pt;
    SVGL: Text8Pt;
    WIPGL: Text8Pt;
    Label88: Label8;
    SRFSF: Text8Pt;
    Label810: Label8;
    SRBLF: TExMaskEdit;
    CCLab: Label8;
    SRCCF: Text8Pt;
    SRDepF: Text8Pt;
    Label85: Label8;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    SRPCK: TCurrencyEdit;
    Label86: Label8;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel6: TBevel;
    LabCur2: TLabel;
    Label3: TLabel;
    LabMg: TLabel;
    SRAWF: TCurrencyEdit;
    Label87: Label8;
    Label89: Label8;
    SRIWF: TCurrencyEdit;
    SRPWF: TCurrencyEdit;
    Label811: Label8;
    Label812: Label8;
    WOPGL: Text8Pt;
    Label813: Label8;
    SRRSF: TCurrencyEdit;
    Label814: Label8;
    SRRUF: TCurrencyEdit;
    Label815: Label8;
    PRetGL: Text8Pt;
    RetGL: Text8Pt;
    Label816: Label8;
    Label818: Label8;
    Label819: Label8;
    Label820: Label8;
    Label821: Label8;
    Label822: Label8;
    Label823: Label8;
    Label824: Label8;
    Label825: Label8;
    SRSP1F: TCurrencyEdit;
    SRSP2F: TCurrencyEdit;
    SRSP3F: TCurrencyEdit;
    SRSP4F: TCurrencyEdit;
    SRSP5F: TCurrencyEdit;
    SRSP6F: TCurrencyEdit;
    SRSP7F: TCurrencyEdit;
    SRSP8F: TCurrencyEdit;
    SRSPC1F: TSBSComboBox;
    SRSPC2F: TSBSComboBox;
    SRSPC3F: TSBSComboBox;
    SRSPC4F: TSBSComboBox;
    SRSPC5F: TSBSComboBox;
    SRSPC6F: TSBSComboBox;
    SRSPC8F: TSBSComboBox;
    SRGP1: TCurrencyEdit;
    SRGP2: TCurrencyEdit;
    SRGP3: TCurrencyEdit;
    SRGP4: TCurrencyEdit;
    SRGP5: TCurrencyEdit;
    SRGP6: TCurrencyEdit;
    SRGP7: TCurrencyEdit;
    SRGP8: TCurrencyEdit;
    SRSPC7F: TSBSComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure SRCCFExit(Sender: TObject);
    procedure SRFSFExit(Sender: TObject);
    procedure WIPGLExit(Sender: TObject);
    procedure SRSBox2Enter(Sender: TObject);
    procedure SRSBox2Exit(Sender: TObject);
    procedure SRMIFExit(Sender: TObject);
    procedure SRSP1FExit(Sender: TObject);
    procedure SRGP8Enter(Sender: TObject);
    procedure SRGP8Exit(Sender: TObject);
    procedure SRBLFSetFocusBack(Sender: TObject; var bSetFocus: Boolean);
    procedure SRBLFMaskError(Sender: TObject);
    procedure SRMIFEnter(Sender: TObject);
    procedure SRMXFEnter(Sender: TObject);
    procedure SRMXFExit(Sender: TObject);
  private
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    LastQtyMin,
    LastQtyMax   :  Double;

    SKeypath     :  Integer;

    CurrCList,
    MargCList,
    PriceCList   :  TDetCtrl;

    GLList       :  Array[1..5] of Text8Pt;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Function CalcGP(BNo  :  Byte)  :  Double;

    Procedure OutId;

    procedure Form2Id;

    procedure SetCaption;
    
    Procedure SetROFields;

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    ExLocal    :  TdExLocal;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(Edit       :  Boolean);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer);

  end;



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
  VarRec2U,
  BTSupU2,
  SBSComp2,
  CmpCtrlU,
  CurrncyU,
  ComnUnit,
  ComnU2,
  SysU2,

  ColCtrlU,

  {SysU2,}
  {$IFDEF SOP}
    MLoc0U,
  {$ENDIF}
  
  InvListU,
  InvLst3U,
  PWarnU,
  {PayF2U,

  {PayLineU,}

  ThemeFix,

  DocSupU1,

  //PR: 15/11/2011
  AuditNotes;

  {Saltxl1U;}




{$R *.DFM}





{ ========== Build runtime view ======== }

procedure TMLocSRec.BuildDesign;


begin
  CurrCList:=TDetCtrl.Create;

  try
    With CurrCList do
    Begin
      AddVisiRec(SRSPC1F,BOff);
      AddVisiRec(SRSPC2F,BOff);
      AddVisiRec(SRSPC3F,BOff);
      AddVisiRec(SRSPC4F,BOff);
      AddVisiRec(SRSPC5F,BOff);
      AddVisiRec(SRSPC6F,BOff);
      AddVisiRec(SRSPC7F,BOff);
      AddVisiRec(SRSPC8F,BOff);
      AddVisiRec(SRCPCF,BOff);
      AddVisiRec(SRRPCF,BOff);
    end;


  except
    CurrCList.Free;
    CurrCList:=nil;

  end; {try..}


  PriceCList:=TDetCtrl.Create;

  try
    With PriceCList do
    Begin
      AddVisiRec(SRSP1F,BOff);
      AddVisiRec(SRSP2F,BOff);
      AddVisiRec(SRSP3F,BOff);
      AddVisiRec(SRSP4F,BOff);
      AddVisiRec(SRSP5F,BOff);
      AddVisiRec(SRSP6F,BOff);
      AddVisiRec(SRSP7F,BOff);
      AddVisiRec(SRSP8F,BOff);
    end;


  except
    PriceCList.Free;
    PriceCList:=nil;

  end; {try..}

  MargCList:=TDetCtrl.Create;

  try
    With MargCList do
    Begin
      AddVisiRec(SRGP1,BOff);
      AddVisiRec(SRGP2,BOff);
      AddVisiRec(SRGP3,BOff);
      AddVisiRec(SRGP4,BOff);
      AddVisiRec(SRGP5,BOff);
      AddVisiRec(SRGP6,BOff);
      AddVisiRec(SRGP7,BOff);
      AddVisiRec(SRGP8,BOff);
    end;


  except
    MargCList.Free;
    MargCList:=nil;

  end; {try..}


end;


procedure TMLocSRec.FormDesign;

Var
  HideCC  :  Boolean;
  n,
  UseDec  :  Byte;

begin

  BuildDesign;

  With CurrCList do
  Begin
    For n:=0 to Pred(Count) do
    Begin
      {$IFDEF MC_On}
        Set_DefaultCurr(TSBSComboBox(IdWinRec(n)).Items,BOff,BOff);
        Set_DefaultCurr(TSBSComboBox(IdWinRec(n)).ItemsL,BOff,BOn);
      {$ELSE}
        TSBSComboBox(IdWinRec(n)).Visible:=BOff;

      {$ENDIF}
    end;
  end; {With..}

  {$IFNDEF MC_On}
    SRCPCF.Visible:=BOff;
    SRRPCF.Visible:=BOff;
    LabCur2.Visible:=BOff;
  {$ENDIF}


  If (Not Syss.ShowStkGP) then
    LabMg.Caption:='MarkUp%';

  SRCPF.DecPlaces:=Syss.NoCosDec;
  SRRPF.DecPlaces:=Syss.NoCosDec;


  SRMIF.DecPlaces:=Syss.NoQtyDec;
  SRMXF.DecPlaces:=Syss.NoQtyDec;
  SRISF.DecPlaces:=Syss.NoQtyDec;
  SRPOF.DecPlaces:=Syss.NoQtyDec;
  SRALF.DecPlaces:=Syss.NoQtyDec;
  SRFRF.DecPlaces:=Syss.NoQtyDec;
  SROOF.DecPlaces:=Syss.NoQtyDec;
  SRPCK.DecPlaces:=Syss.NoQtyDec;

  {$IFDEF WOP}
    SRAWF.Visible:=WOPOn;

  {$ELSE}

    SRAWF.Visible:=BOff;

  {$ENDIF}

  Label87.Visible:=SRAWF.Visible;
  SRIWF.Visible:=SRAWF.Visible;
  SRPWF.Visible:=SRAWF.Visible;
  Label89.Visible:=SRAWF.Visible;
  Label811.Visible:=SRAWF.Visible;
  Label812.Visible:=SRAWF.Visible;
  WOPGL.Visible:=SRAWF.Visible;

  {$IFDEF RET}
    // MH 22/12/2010 v6.6: Corrected check as was checking WOPOn - too much copy and paste from above!
    SRRSF.Visible:=RetMOn;

  {$ELSE}

    SRRSF.Visible:=BOff;

  {$ENDIF}

  Label813.Visible:=SRRSF.Visible;
  Label814.Visible:=SRRSF.Visible;
  SRRUF.Visible:=SRRSF.Visible;
  Label815.Visible:=RetMOn;
  RetGL.Visible:=RetMOn;
  PRetGL.Visible:=RetMOn;


end;


procedure TMLocSRec.SetCaption;

Begin
  With ExLocal, LStock, LMLocCtrl^.MStkLoc do
  Begin
    Caption:='Stock Location Record for Locn : '+lsLocCode+', '+dbFormatName(StockCode,Desc[1]);

  end;


end;


procedure TMLocSRec.FormCreate(Sender: TObject);
begin
  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=389;
  ClientWidth:=589;

  LastQtyMin:=0;
  LastQtyMax:=0;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TLocnList) then
    With TLocnList(Owner) do
      Self.SetFieldProperties(loPanel);

  GLList[1]:=SalGL;
  GLList[2]:=COSGL;
  GLList[3]:=WOGL;
  GLList[4]:=SVGL;
  GLList[5]:=WIPGL;

  
  FormDesign;

end;




procedure TMLocSRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,103);

end;

procedure TMLocSRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TMLocSRec.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

  If (CurrCList<>nil) then
    CurrCList.Free;

  If (PriceCList<>nil) then
    PriceCList.Free;

  If (MargCList<>nil) then
    MargCList.Free;

end;



procedure TMLocSRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TMLocSRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Procedure TMLocSRec.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      38  :  ;

    end; {Case..}

  end;
  Inherited;
end;



{ == Procedure to Send Message to Get Record == }

Procedure TMLocSRec.Send_UpdateList(Edit   :  Boolean;
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



Function TMLocSRec.CheckNeedStore  :  Boolean;

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


Procedure TMLocSRec.SetFieldFocus;

Begin
  SRMIF.SetFocus;

end; {Proc..}



Procedure TMLocSRec.SetROFields;

Var
  n     :  Byte;
  SetB  :  Boolean;

Begin

  With ExLocal.LMLocCtrl^.MStkLoc do
  Begin
    SRCCF.ReadOnly:=Not LocOCCDep(lsLocCode);
    SRDepF.ReadOnly:=SRCCF.ReadOnly;

    SRCCF.TabStop:=Not SRCCF.ReadOnly;
    SRDepF.TabStop:=Not SRCCF.ReadOnly;

    SetB:=LocONom(lsLocCode);

    For n:=Low(GLList) to High(GLList) do
    Begin
      GLList[n].ReadOnly:=Not SetB;
      GLList[n].TabStop:=Not GLList[n].ReadOnly;
    end;

    SetB:=LocOPrice(lsLocCode);

    For n:=1 to NofSUBnds do
    Begin
      {$IFDEF MC_On}
        TSBSComboBox(CurrCList.IdWinRec(Pred(n))).ReadOnly:=Not SetB;
        TSBSComboBox(CurrCList.IdWinRec(Pred(n))).TabStop:=SetB;
      {$ENDIF}

      TCurrencyEdit(PriceCList.IdWinRec(Pred(n))).ReadOnly:=Not SetB;
      TCurrencyEdit(PriceCList.IdWinRec(Pred(n))).TabStop:=SetB;

      TCurrencyEdit(MargCList.IdWinRec(Pred(n))).ReadOnly:=Not SetB;
      TCurrencyEdit(MargCList.IdWinRec(Pred(n))).TabStop:=SetB;
    end; {Loop..}

    SRFSF.ReadOnly:=Not LocOSupp(lsLocCode);
    SRFSF.TabStop:=Not SRFSF.ReadOnly;


    If (Not PChkAllowed_In(143)) or (Not PChkAllowed_In(313)) then {* Set Cost & Re-Order proce to R/O if GP not set, or no cost price edit allowed *}
    Begin
      SRCPF.ReadOnly:=BOn; SRCPF.TabStop:=BOff;

      If (Not PChkAllowed_In(143)) then
      Begin
        SRRPF.ReadOnly:=BOn; SRRPF.TabStop:=BOff;
      end;

    end;
  end;
end; {Proc..}



Function TMLocSRec.ConfirmQuit  :  Boolean;

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



Function TMLocSRec.CalcGP(BNo  :  Byte)  :  Double;

Begin
  With ExLocal,LMLocCtrl^.MStkLoc,lsSaleBands[BNo] do
  Begin

    If (SalesPrice<>0) and PChkAllowed_In(143) then
      Result:=Stock_Gp(lsCostPrice,Currency_ConvFT(SalesPrice,Currency,lsPCurrency,UseCoDayRate),
            LStock.BuyUnit,LStock.SellUnit,Ord(Syss.ShowStkGP),LStock.CalcPack)
    else
      Result:=0;

  end; {With..}
end;

{ ============== Display Id Record ============ }

Procedure TMLocSRec.OutId;

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  n         :  Byte;

  CrDr       :   DrCrDType;

  Cleared,
  ThisPr,
  ThisYTD,
  LastYTD,
  Budget1,
  Budget2,
  Commit,

  Dnum       :   Double;

  KeyS      :  Str255;


Begin
  SetCaption;

  Blank(CrDr,Sizeof(CrDr));

  ThisPr:=0; ThisYTD:=0; LastYTD:=0;  Cleared:=0;

  Budget1:=0;

  Budget2:=0;

  Commit:=0;

  With ExLocal,LMLocCtrl^,MStkLoc do
  Begin
    LastQtyMin:=lsQtyMin;
    LastQtyMax:=lsQtyMax;


    If (JustCreated) or (ActiveControl=SRMIF) then
      SRMIF.Value:=LastQtyMin
    else
      SRMIF.Value:=CaseQty(LStock,lsQtyMin);
      
    SRMIF.Modified:=BOff;
    SRMXF.Value:=CaseQty(LStock,lsQtyMax);
    SRISF.Value:=CaseQty(LStock,lsQtyInStock);


    With Syss,LStock do
        Cleared:=Profit_to_Date(Calc_AltStkHCode(StockType),
                                CalcKeyHist(StockFolio,lsLocCode),0,Cyr,CPr,CrDr[BOff],CrDr[BOn],Commit,BOn);

    SRPOF.Value:=CaseQty(LStock,Commit);


    SRALF.Value:=CaseQty(LStock,AllocMLocStock(MStkLoc));
    SRFRF.Value:=CaseQty(LStock,FreeMLocStock(MStkLoc));
    SROOF.Value:=CaseQty(LStock,lsQtyOnOrder);

    {$IFDEF WOP}
      SRAWF.Value:=CaseQty(LStock,lsQtyAllocWOR);
      SRIWF.Value:=CaseQty(LStock,lsQtyIssueWOR);
      SRPWF.Value:=CaseQty(LStock,lsQtyPickWOR);

    {$ENDIF}

    {$IFDEF RET}
      SRRSF.Value:=CaseQty(LStock,lsQtyReturn);
      SRRUF.Value:=CaseQty(LStock,lsQtyPReturn);

    {$ENDIF}

    For n:=Low(GLList) to High(GLList) do
    Begin
      GLList[n].Text:=Form_BInt(lsDefNom[n],0);
    end;

    WOPGL.Text:=Form_BInt(lsWOPWIPGL,0);

    RETGL.Text:=Form_BInt(lsReturnGL,0);
    PRETGL.Text:=Form_BInt(lsPReturnGL,0);

    For n:=1 to NofSUBnds do
    With lsSaleBands[n] do
    Begin
      {$IFDEF MC_On}
        TSBSComboBox(CurrCList.IdWinRec(Pred(n))).ItemIndex:=Pred(Currency);
      {$ENDIF}

      TCurrencyEdit(PriceCList.IdWinRec(Pred(n))).DecPlaces:=Syss.NoNetDec;
      TCurrencyEdit(PriceCList.IdWinRec(Pred(n))).Value:=SalesPrice;

      With TCurrencyEdit(MargCList.IdWinRec(Pred(n))) do
      Begin
        Value:=CalcGP(n);
      end;

    end; {Loop..}

    SRCCF.Text:=lsCCDep[BOn];
    SRDepF.Text:=lsCCDep[BOff];

    SRFSF.Text:=lsSupplier;
    SRBLF.Text:=lsBinLoc;

    {$IFDEF MC_On}
      SRCPCF.ItemIndex:=Pred(lsPCurrency);
      SRRPCF.ItemIndex:=Pred(lsROCurrency);
    {$ENDIF}

    If PChkAllowed_In(143) then
    Begin
      SRCPF.Value:=lsCostPrice;
      SRRPF.Value:=lsROPrice;
    end
    else
    Begin
      SRCPF.Value:=0.0;
      SRRPF.Value:=0.0;
    end;


  end;

  JustCreated:=BOff;

  SetROFields;

end;


procedure TMLocSRec.Form2Id;

Var
  n :  Byte;

Begin

  With EXLocal,LMLocCtrl^,MStkLoc do
  Begin
    lsQtyMin:=LastQtyMin;
    lsQtyMax:=LastQtyMax;

    {lsQtyMin:=SRMIF.Value;
    lsQtyMax:=SRMXF.Value;}

    lsSupplier:=SRFSF.Text;

    For n:=Low(GLList) to High(GLList) do
    Begin
      lsDefNom[n]:=IntStr(GLList[n].Text);
    end;

    lsWOPWIPGL:=IntStr(WOPGL.Text);

    lsReturnGL:=IntStr(RETGL.Text);
    lsPReturnGL:=IntStr(PRETGL.Text);

    For n:=1 to NofSUBnds do
    With lsSaleBands[n] do
    Begin
      {$IFDEF MC_On}
        Currency:=Succ(TSBSComboBox(CurrCList.IdWinRec(Pred(n))).ItemIndex);
      {$ENDIF}

      SalesPrice:=TCurrencyEdit(PriceCList.IdWinRec(Pred(n))).Value
    end; {Loop..}


    {$IFDEF MC_On}
      lsPCurrency:=Succ(SRCPCF.ItemIndex);
      lsROCurrency:=Succ(SRRPCF.ItemIndex);
    {$ENDIF}

    If PChkAllowed_In(143) then
    Begin
      lsCostPrice:=SRCPF.Value;
      lsROPrice:=SRRPF.Value;
    end;

    lsCCDep[BOn]:=SRCCF.Text;
    lsCCDep[BOff]:=SRDepF.Text;

    lsBinLoc:=SRBLF.Text;


  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TMLocSRec.ProcessId(Fnum,
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
  With ExLocal,LMLocCtrl^,MStkLoc do
  begin
    With SRBLF do {Enforce edit mask if its a multi bin item}
    Begin

      If (Not ReadOnly) then
      Begin
        If (ExLocal.LStock.MultiBinMode) and (Syss.BinMask<>'') then
          EditMask:=Syss.BinMask+';1;_'
        else
          EditMask:='';
      end;
    end;



    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPfix:=CostCCode;
      Subtype:=CSubCode[BOff];

    end;

    LastMLoc^:=LMLocCtrl^;

    OutId;

  end {If Abort..}
  else
    Close;

end; {Proc..}



Function TMLocSRec.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  8;

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

  PossMsg^[1]:='The Cost Price currency is not valid.';
  PossMsg^[2]:='One of the Sales Price currencies is not valid.';
  PossMsg^[3]:='The Re-Order Price currency is not valid.';
  PossMsg^[4]:='One of the General Ledger Control Codes is not valid.';
  PossMsg^[5]:='The default Cost Centre Code is not valid.';
  PossMsg^[6]:='The default Department Code is not valid.';
  PossMsg^[7]:='The WOP Work in progress G/L Code is not valid.';
  PossMsg^[8]:='The Stock Return G/L Code is not valid.';


  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LMLocCtrl^.MStkLoc do
  Begin
    Case Test of

    {$IFDEF MC_On}

      1  :
               Result:=(lsPCurrency In [Succ(CurStart)..CurrencyType]);

    {$ENDIF}

    {$IFDEF MC_On}

      2  :
             If LocOPrice(lsLocCode) then
               For n:=1 to MaxStkPBands do
               Begin
                 Result:=((lsSaleBands[n].Currency In [Succ(CurStart)..CurrencyType]));

                 If (Not Result) then
                   Break;
               end;

    {$ENDIF}

    {$IFDEF MC_On}

      3  :
               Result:=(lsROCurrency In [Succ(CurStart)..CurrencyType]);

    {$ENDIF}


      4  :  Begin
              If LocONom(lsLocCode) then
              Begin

                {$IFNDEF PF_On}

                   For n:=1 to Pred(NofSNoms) do

                {$ELSE}

                   For n:=1 to NofSNoms do

                {$ENDIF}
                   Begin
                     Result:=GetNom(Self,Form_Int(lsDefNom[n],0),FoundLong,-1);

                     If (Not Result) then
                      Break;
                   end;
              end;

            end;

      5,6
         :  Result:=(EmptyKey(lsCCDep[(Test=5)],CCKeyLen) or GetCCDep(Self,lsCCDep[(Test=5)],FoundCode,(Test=5),-1));


      7  :  Begin
               Result:=Not WOPOn or (Not LocONom(lsLocCode));

               If (Not Result) then
               Begin

                 Result:=GetNom(Self,Form_Int(lsWOPWIPGL,0),FoundLong,-1);
               end;

             end;


     8   :  Begin
              Result:=Not RETMOn or (Not LocONom(lsLocCode));

              If (Not Result) then
              Begin

                Result:=GetNom(Self,Form_Int(lsReturnGL,0),FoundLong,-1) and GetNom(Self,Form_Int(lsPReturnGL,0),FoundLong,-1);
              end;

            end;


    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (Not MainChk) then
    mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}





procedure TMLocSRec.StoreId(Fnum,
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


  With ExLocal,LMLocCtrl^,MStkLoc do
  Begin
    COk:=CheckCompleted(LastEdit,BOff);



    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      lsMinFlg:=((FreeMLocStock(MStkLoc)<lsQtyMin)) and (lsQtyMin<>0);

      lsSupplier:=FullCustCode(lsSupplier);

      lsTempSupp:=lsSupplier;

      {* Update last edited flag *}

      lsLastUsed:=Today;
      lsLastTime:=TimeNowStr;

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

      end;

      //PR: 15/11/2011 Add audit note to indicate stock record has been changed by editing stock location record
      if Status = 0 then
      with TAuditNote.Create(EntryRec.Login, @F[PWrdF]) do
      Try
        AddNote(anStockLocation, Stock.StockFolio, anEdit);
      Finally
        Free;
      End;

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


procedure TMLocSRec.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TMLocSRec.EditLine(Edit       :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ProcessId(MLocF,MLK,LastEdit);
  end;
end;


procedure TMLocSRec.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult=mrOk) then
      Begin
        // MH 22/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
        //                                   fields which processes the text and updates the value
        If (ActiveControl <> OkCP1Btn) Then
          // Move focus to OK button to force any OnExit validation to occur
          OkCP1Btn.SetFocus;

        // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
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


procedure TMLocSRec.DeleteBOMLine(Fnum,
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

          Send_UpdateList(BOff,17);


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}




procedure TMLOCSRec.SRCCFExit(Sender: TObject);

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
          (Syss.UseCCDep)  and (FoundCode<>'') and (Not Has_CCWildChar(FoundCode))  and (Not ReadOnly) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetCCDep(Self,FoundCode,FoundCode,IsCC,2));


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





procedure TMLOCSRec.WIPGLExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (ExLocal.InAddEdit)  and (Not ReadOnly) then
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

        StopPageChange:=BOff;

        Text:=Form_Int(FoundLong,0);


      end
      else
      Begin
        StopPageChange:=BOn;

        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;






procedure TMLOCSRec.SRFSFExit(Sender: TObject);
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

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOff,0));

      If (FoundOk) then
      Begin

        StopPageChange:=BOff;

        StillEdit:=BOff;

        Text:=FoundCode;

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


procedure TMLOCSRec.SRSBox2Enter(Sender: TObject);
begin
  With SRSPC1F do
   If (Visible) and (CanFocus) then
     SetFocus
   else
     With SRSP1F do
     If (Visible) and (CanFocus) then
       SetFocus;
end;

procedure TMLOCSRec.SRSBox2Exit(Sender: TObject);
begin
  If (Sender is TScrollBox) then
    TScrollBox(Sender).VertScrollBar.Position:=0;
end;

procedure TMLOCSRec.SRMIFEnter(Sender: TObject);
begin
  With ExLocal do
    If (InAddEdit) then
    Begin
      SRMIF.Value:=LastQtyMin;
    end;

end;


procedure TMLOCSRec.SRMIFExit(Sender: TObject);
begin
    With ExLocal do
    If (InAddEdit) then
    Begin
      LastQtyMin:=SRMIF.Value;
      SRMIF.Value:=CaseQty(LStock,LastQtyMin);
    end;

  SRMIF.FloatModified:=(LastQtyMin<>ExLocal.LMLocCtrl^.MStkLoc.lsQtyMin);
end;


procedure TMLOCSRec.SRMXFEnter(Sender: TObject);
begin
  With ExLocal do
    If (InAddEdit) then
    Begin
      SRMXF.Value:=LastQtyMax;
    end;

end;

procedure TMLOCSRec.SRMXFExit(Sender: TObject);
begin
  With ExLocal do
    If (InAddEdit) then
    Begin
      LastQtyMax:=SRMXF.Value;
      SRMXF.Value:=CaseQty(LStock,LastQtyMax);
    end;
end;


procedure TMLOCSRec.SRSP1FExit(Sender: TObject);
Var
  n     :  Integer;

begin
  If (ExLocal.InAddEdit) then
  With TCurrencyEdit(Sender) do
  Begin
    n:=PriceCList.FindxName(Name);

    If (n<>-1) then
    Begin
      Form2Id;

      TCurrencyEdit(MargCList.IdWinRec(n)).Value:=CalcGP(Succ(n));
    end;
  end;
end;


procedure TMLOCSRec.SRGP8Enter(Sender: TObject);
Var
  n  :  Integer;
begin
  If (ExLocal.InAddEdit) then
  With TCurrencyEdit(Sender) do
  Begin
    n:=MargCList.FindxName(Name);

    If (n<>-1) then
      ReadOnly:=(TCurrencyEdit(PriceCList.IdWinRec(n)).Value<>0.0);


  end;
end;



procedure TMLOCSRec.SRGP8Exit(Sender: TObject);
Var
  n     :  Integer;
  Cr    :  Byte;

  Dnum  :  Double;

begin
  If (ExLocal.InAddEdit) then
  With TCurrencyEdit(Sender) do
  If (Value<>0) and (Not ReadOnly) then
  Begin
    n:=MargCList.FindxName(Name);

    If (n<>-1) then
    With ExLocal,LMLocCtrl^.MStkLoc do
    Begin
      Form2Id;

      Cr:=lsSaleBands[Succ(n)].Currency;

      If (ChkAllowed_In(143)) then
        Dnum:=MakeStock_GP(Currency_ConvFT(Calc_StkCP(lsCostPrice,LStock.BuyUnit,LStock.CalcPack),
                                                   lsPCurrency,Cr,UseCoDayRate),
                                                   Value,
                                                   LStock.SellUnit,Ord(Syss.ShowStkGp),LStock.CalcPack)
      else
        Dnum:=0.0;

      TCurrencyEdit(PriceCList.IdWinRec(n)).Value:=Dnum;
    end;
  end;
end;

procedure TMLOCSRec.SRBLFSetFocusBack(Sender: TObject;
  var bSetFocus: Boolean);
begin
  bSetFocus:=(ActiveControl <> CanCp1Btn);
end;

procedure TMLOCSRec.SRBLFMaskError(Sender: TObject);
begin
    if (ActiveControl <> CanCp1Btn) then
    ShowMessage('That Bin Code does not match the Bin Code mask. Please re-enter');

end;




Initialization

end.
