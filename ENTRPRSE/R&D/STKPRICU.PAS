unit StkPricU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal,
  GlobVar,VarConst,ExWrap1U,SalTxl1U;


type
  TPrices = class(TForm)
    ClsCP1Btn: TButton;
    OKCP1Btn: TButton;
    P1F: TCurrencyEdit;
    P2F: TCurrencyEdit;
    P3F: TCurrencyEdit;
    P4F: TCurrencyEdit;
    P5F: TCurrencyEdit;
    P6F: TCurrencyEdit;
    P7F: TCurrencyEdit;
    P8F: TCurrencyEdit;
    C1F: TSBSComboBox;
    C2F: TSBSComboBox;
    C3F: TSBSComboBox;
    C4F: TSBSComboBox;
    C5F: TSBSComboBox;
    C6F: TSBSComboBox;
    C7F: TSBSComboBox;
    C8F: TSBSComboBox;
    SRGP1: TCurrencyEdit;
    SRGP2: TCurrencyEdit;
    SRGP3: TCurrencyEdit;
    SRGP4: TCurrencyEdit;
    SRGP5: TCurrencyEdit;
    SRGP6: TCurrencyEdit;
    SRGP7: TCurrencyEdit;
    SRGP8: TCurrencyEdit;
    Label828: Label8;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    Label87: Label8;
    Label88: Label8;
    LabCur2: TLabel;
    Label4: TLabel;
    LabMg: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure P1FExit(Sender: TObject);
    procedure SRGP1Enter(Sender: TObject);
    procedure SRGP1Exit(Sender: TObject);
    procedure OKCP1BtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }

    ExLocal  :  TdExLocal;

    CurrCList,
    MargCList,
    PriceCList
             :  TDetCtrl;

    ADL1F    :  TLabel;

    InitX,
    InitY    :  Integer;

    InOutPrice,
    PrevHState
             :  Boolean;


    LocCode  :  Str10;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
                                     
    procedure BuildCtrlLists;

    Function CalcGP(BNo  :  Byte)  :  Double;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Procedure SetDelStore(EnabFlg,
                           SetCol  :  Boolean);


    procedure Form2Price;

  public
    { Public declarations }

    procedure OutPrices(Lc  :  Str10);

    Procedure PrimeForm(VO    :  Boolean;
                        LC    :  Str10;
                        Col1  :  TColor;
                        Fon1  :  TFont);

    Procedure RefreshForm(VO   :  Boolean;
                          Mode :  Byte);



  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  VarRec2U,
  CmpCtrlU,
  CurrncyU,
  BTSupU1,
  BTSupU2,
  SysU2,
  ComnUnit,
  PWarnU,
  Mask,
  {$IFDEF SOP}
    InvLst3U,
  {$ENDIF}

  ThemeFix,
  SBSComp2,
  BTKeys1U;

{$R *.DFM}


procedure TPrices.BuildCtrlLists;


Begin
  CurrCList:=TDetCtrl.Create;

  ADL1F:=TLabel.Create(Self);

  try
    With CurrCList do
    Begin
      AddVisiRec(C1F,BOff);
      AddVisiRec(C2F,BOff);
      AddVisiRec(C3F,BOff);
      AddVisiRec(C4F,BOff);
      AddVisiRec(C5F,BOff);
      AddVisiRec(C6F,BOff);
      AddVisiRec(C7F,BOff);
      AddVisiRec(C8F,BOff);
    end;


  except
    CurrCList.Free;
    CurrCList:=nil;

  end; {try..}


  PriceCList:=TDetCtrl.Create;

  try
    With PriceCList do
    Begin
      AddVisiRec(P1F,BOff);
      AddVisiRec(P2F,BOff);
      AddVisiRec(P3F,BOff);
      AddVisiRec(P4F,BOff);
      AddVisiRec(P5F,BOff);
      AddVisiRec(P6F,BOff);
      AddVisiRec(P7F,BOff);
      AddVisiRec(P8F,BOff);
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


end; {Proc..}


Function TPrices.CalcGP(BNo  :  Byte)  :  Double;

Begin
  With ExLocal,LStock,SaleBands[BNo] do
  Begin

    If (SalesPrice<>0) and ChkAllowed_In(143) then
      Result:=Stock_Gp(LStock.CostPrice,Currency_ConvFT(SalesPrice,Currency,LStock.PCurrency,UseCoDayRate),
            LStock.BuyUnit,LStock.SellUnit,Ord(Syss.ShowStkGP),LStock.CalcPack)
    else
      Result:=0;

  end; {With..}
end;

procedure TPrices.OutPrices(Lc  :  Str10);

Var
  n  :  Integer;

Begin
  With ExLocal,LStock do
  Begin
    If (Not Syss.ShowStkGP) then
      LabMg.Caption:='MarkUp%';

    AssignFromGlobal(StockF);

      {$IFDEF SOP}

        Stock_LocPSubst(LStock,Lc);

      {$ENDIF}


    Caption:='Prices: '+dbFormatName(StockCode,Desc[1]);


    For n:=1 to NofSUBnds do
    With SaleBands[n] do
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

  end;
end;

procedure TPrices.Form2Price;

Var
  n  :  Byte;
  I  :  Integer;


Begin
  With ExLocal,LStock do
  Begin
    For n:=1 to NofSUBnds do
    With SaleBands[n] do
    Begin
      {$IFDEF MC_On}
        I:=TSBSComboBox(CurrCList.IdWinRec(Pred(n))).ItemIndex;
        If (I>-1) then
          Currency:=Succ(I)
        else
          Currency:=1;
      {$ENDIF}

      SalesPrice:=TCurrencyEdit(PriceCList.IdWinRec(Pred(n))).Value
    end; {Loop..}

  end;
end;

procedure TPrices.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Send_UpdateList(BOff,210);
end;

procedure TPrices.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AcTion:=CaFree;
end;

{ == Procedure to Send Message to Get Record == }

Procedure TPrices.Send_UpdateList(Edit   :  Boolean;
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
    WParam:=Mode;
    LParam:=Ord(Edit);
  end;
                                             
  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


Procedure TPrices.WMSysCommand(Var Message  :  TMessage);


Begin
  With Message do
    Case WParam of
      61441..61448,{All points resize block}
      SC_Maximize  :  Begin
                        Self.ClientHeight:=InitY;
                        Self.ClientWidth:=InitX;

                        WParam:=0;
                      end;

    end; {Case..}

  Inherited;
end;


procedure TPrices.FormCreate(Sender: TObject);

Var
  nv  :  Integer;

begin
  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  InitX:=274;//262;
  InitY:=258;//245;

  ClientHeight:=InitY;
  ClientWidth:=InitX;

  InOutPrice:=BOff;
  BuildCtrlLists;

  try
    With CurrCList do
    Begin

      For nv:=0 to Pred(Count) do
    {$IFDEF MC_On}
      Begin
        Set_DefaultCurr(TSBSComboBox(IdWinRec(nv)).Items,BOff,BOff);
        Set_DefaultCurr(TSBSComboBox(IdWinRec(nv)).ItemsL,BOff,BOn);
      end;
    {$ELSE}
      TSBSComboBox(IdWinRec(nv)).Visible:=BOff;
    {$ENDIF}
    end;

  except
    CurrCList.Free;
    CurrCList:=nil;

  end; {try..}

  ExLocal.Create;

  LastValueObj.GetAllLastValuesFull(Self);

end;

procedure TPrices.FormDestroy(Sender: TObject);
begin

  ExLocal.Destroy;

  ADL1F.Free;

  If (CurrCList<>nil) then
    CurrCList.Free;

  If (PriceCList<>nil) then
    PriceCList.Free;

  If (MargCList<>nil) then
    MargCList.Free;

end;

procedure TPrices.OKCP1BtnClick(Sender: TObject);
begin
  // MH 04/01/2011 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
  //                                   fields which processes the text and updates the value
  If (ActiveControl <> OkCP1Btn) Then
    // Move focus to OK button to force any OnExit validation to occur
    OkCP1Btn.SetFocus;

  // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
  If (ActiveControl = OkCP1Btn) Then
  Begin
    Form2Price;

    ExLocal.AssignToGlobal(StockF);

    LastValueObj.UpdateAllLastValuesFull(Self);

    Close;
  End; // If (ActiveControl = OkCP1Btn)
end;


procedure TPrices.ClsCP1BtnClick(Sender: TObject);
begin
  Stock:=ExLocal.LastStock; {Reset Stock to pre edit position}
  Close;
end;


procedure TPrices.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

end;

procedure TPrices.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);

end;

Procedure TPrices.SetDelStore(EnabFlg,
                              SetCol  :  Boolean);

Var
  Loop  :  Integer;

Begin

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is TMaskEdit) or (Components[Loop] is TSBSComboBox) or (Components[Loop] is TCurrencyEdit) then
    Begin
      If (SetCol) then
      With TGlobControl(Components[Loop]) do
      Begin
        Font.Assign(ADL1F.Font);
        Color:=ADL1F.Color;

        {* b5471.032. EL: Sent to prevent miscoloring bug under XP when the color is grayed out. *}
        If (Self.Components[Loop] is TWinControl) then
          PostMessage(TWinControl(Self.Components[Loop]).Handle, WM_MOUSEMOVE, 0, 0);

      end;

      If (TGlobControl(Components[Loop]).Tag=1) then
      Begin
        If (Self.Components[Loop] is TSBSComboBox) then
          With TSBSComboBox(Self.Components[Loop]) do
          Begin
            ReadOnly:= EnabFlg;
            TabStop:=Not ReadOnly;
          end
          else
            If (Self.Components[Loop] is TCurrencyEdit) then
            With TCurrencyEdit(Self.Components[Loop]) do
            Begin
              ReadOnly:= EnabFlg;
              TabStop:=Not ReadOnly;
            end;
      end;
    end;

  end;

end;

Procedure TPRices.PrimeForm(VO    :  Boolean;
                            LC    :  Str10;
                            Col1  :  TColor;
                            Fon1  :  TFont);

Begin
  With ADL1F do
  Begin
    Color:=Col1;
    Font.Assign(Fon1);
  end;

  OKCP1Btn.Visible:=BOn;

  OKCP1Btn.Left:=Round(Self.Width/2)-(OKCP1Btn.Width+5);
  ClsCp1Btn.Left:=Round(Self.Width/2)+5;
  ClsCp1Btn.Caption:='&Cancel';

  ExLocal.InAddEdit:=Not VO;

  LocCode:=LC;

  RefreshForm(VO,0);;

end;


Procedure TPRices.RefreshForm(VO   :  Boolean;
                              Mode :  Byte);


Begin
  InOutPrice:=BOn;

  OKCP1Btn.Enabled:=Not VO;

  SetDelStore(VO,(Mode=0));

  ExLocal.AssignFromGlobal(StockF);

  ExLocal.LastStock:=Stock;

  OutPrices(LocCode);

  If (P1F.CanFocus) then
  With P1F do
  Begin
    SetFocus;
    SelectAll;
  end;

  Show;

  InOutPrice:=BOff;


end;






procedure TPrices.P1FExit(Sender: TObject);
Var
  n     :  Integer;

begin
  If (ExLocal.InAddEdit) and (Not InOutPrice)  then
  With TCurrencyEdit(Sender) do
  Begin
    n:=PriceCList.FindxName(Name);

    If (n<>-1) then
    With ExLocal,LStock do
    Begin
      Form2Price;

      TCurrencyEdit(MargCList.IdWinRec(n)).Value:=CalcGP(Succ(n));
    end;
  end;
end;

procedure TPrices.SRGP1Enter(Sender: TObject);
Var
  n  :  Integer;
begin
  If (ExLocal.InAddEdit) and (Not InOutPrice) then
  With TCurrencyEdit(Sender) do
  Begin
    n:=MargCList.FindxName(Name);

    If (n<>-1) then
      ReadOnly:=(TCurrencyEdit(PriceCList.IdWinRec(n)).Value<>0.0) or (Not ChkAllowed_In(143));


  end;
end;

procedure TPrices.SRGP1Exit(Sender: TObject);
Var
  n     :  Integer;
  Cr    :  Byte;

  Dnum  :  Double;

begin
  If (ExLocal.InAddEdit) and (Not InOutPrice)  then
  With TCurrencyEdit(Sender) do
  If (Value<>0) and (Not ReadOnly) then
  Begin
    n:=MargCList.FindxName(Name);

    If (n<>-1) then
    With ExLocal,LStock do
    Begin
      Form2Price;

      Cr:=SaleBands[Succ(n)].Currency;

      Dnum:=MakeStock_GP(Currency_ConvFT(Calc_StkCP(LStock.CostPrice,LStock.BuyUnit,LStock.CalcPack),
                                                 LStock.PCurrency,Cr,UseCoDayRate),
                                                 Value,
                                                 LStock.SellUnit,Ord(Syss.ShowStkGp),LStock.CalcPack);

      TCurrencyEdit(PriceCList.IdWinRec(n)).Value:=Dnum;
    end;
  end;
end;



end.
