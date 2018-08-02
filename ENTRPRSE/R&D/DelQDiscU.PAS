unit DelQDiscU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, BTSupU3, bkgroup, BorBtns, TEditVal, Mask,
  Animate, SBSPanel, GlobVar;

type
  TDelQBInpR = class(TRepInpMsg)
    Label81: Label8;
    ACFF: Text8Pt;
    Label86: Label8;
    I1TransDateF: TEditDate;
    Label87: Label8;
    I2TransDateF: TEditDate;
    DelAll1: TBorCheckEx;
    DelExp1: TBorCheckEx;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure DelExp1Click(Sender: TObject);
  private
    { Private declarations }
    RepMode    :  Byte;

    CRepParam  :  BinRepPtr;

    procedure SetHelpContextIDs; // NF: 11/05/06
  public
    { Public declarations }
    CustFilt  :  Str20;
  end;

Var
  QBRNo  :  Byte;

  procedure Del_Discount(IdMode  :  Byte;
                         CFilt   :  Str10;
                         AOwner  :  TComponent);

  function ConfirmDeleteAllDiscounts(Sender : TWinControl;
                                     bCustSupp,
                                     bUseDateRange,
                                     bHasStockCode : Boolean; var sMsg : AnsiString; var mType : TMsgDlgType) : Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  VarConst,
  BTKeys1U,
  ComnU2,
  BTSupU1,
  InvListU,
  RevalueU,
  SysU1,
  SysU2,
  GenWarnU,
  BTSupU2;


{$R *.DFM}

function ConfirmDeleteAllDiscounts(Sender : TWinControl;
                                   bCustSupp,
                                   bUseDateRange,
                                   bHasStockCode : Boolean; var sMsg : AnsiString; var mType : TMsgDlgType) : Boolean;
Const
  DType  :  Array[False..True] of Str20 = ('Stock','Account');

begin
  if bUseDateRange or bHasStockCode then
  begin
    if (not bCustSupp) or (not bHasStockCode) then  //Stock or CustSupp no StockCode
      sMsg := 'Discounts expiring within the given date range will be deleted for ALL ' + DType[bCustSupp] + ' codes not just this one'
    else
    if (not bUseDateRange) then  //CustSupp w StockCode no Date
      sMsg := 'Discounts for the given Stock Code/Group  will be deleted ' +
              'for ALL ' + DType[bCustSupp] + ' codes not just this one'
    else //CustSupp with StockCode and Date
      sMsg := 'Discounts for the given Stock Code/Group which expire within the given date range' +
             ' will be deleted for ALL ' + DType[bCustSupp] + ' codes not just this one';
    mType := mtWarning;
  end
  else
  begin
    sMsg := 'You have chosen to delete ALL discounts for ALL ' +DType[bCustSupp]+ ' codes. Are you sure?';
    mType := mtError;
  end;

  Result := (CustomDlg(Sender,'Please Confirm!','Delete for All '+ DType[bCustSupp] + ' codes.', sMsg + #13 + #13 +
                             'Please confirm this is correct.',
                             mType,
                             [mbYes,mbNo],
                             mType = mtError)=mrOk);

end;

procedure TDelQBInpR.FormCreate(Sender: TObject);


Var
  HideLoc  :  Boolean;

begin
  inherited;

  ClientHeight:=183;
  ClientWidth:=299;

  RepMode:=QBRNo;

  Animated1.Visible:=BOff;

  If (RepMode=0) then
  Begin
    Label81.Visible:=BOff;
    ACFF.Visible:=BOff;
  end;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  I1TransDateF.DateValue:=Today;
  I2TransDateF.DateValue:=MaxUntilDate;

  SetLastValues;

  DelExp1Click(Nil);

  SetHelpContextIDs; // NF: 11/05/06 Fix for incorrect Context IDs
end;

procedure TDelQBInpR.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;





procedure TDelQBInpR.ACFFExit(Sender: TObject);
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

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetStock(Self,FoundCode,FoundCode,99));


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
end;



procedure TDelQBInpR.DelExp1Click(Sender: TObject);
begin
  If (DelExp1.Checked) and (I1TransDateF.DateValue='') and (Assigned(Sender)) then
  Begin
    I1TransDateF.DateValue:=Today;
    I2TransDateF.DateValue:=Today;

  end;

  I1TransDateF.ReadOnly:=Not DelExp1.Checked;
  I1TransDateF.TabStop:=Not I1TransDateF.ReadOnly;

  I2TransDateF.ReadOnly:=I1TransDateF.ReadOnly;
  I2TransDateF.TabStop:=Not I1TransDateF.ReadOnly;

  If (Not DelExp1.Checked) then
    I1TransDateF.Color:=clBtnFace
  else
    I1TransDateF.Color:=clWhite;

  I2TransDateF.Color:=I1TransDateF.Color;


end;


procedure TDelQBInpR.OkCP1BtnClick(Sender: TObject);

Var
  Ok2Cont  :  Boolean;
  sMsg : string;
  mType : TMsgDlgType;
begin
  If (Sender=OkCP1Btn) and (DelAll1.Checked) then
  Begin
    Ok2Cont:= ConfirmDeleteAllDiscounts(Self,
                                        RepMode > 0, //Customer or Supplier rather than stock
                                        DelExp1.Checked, //Use Date Range
                                        Trim(ACFF.Text) <> '', //Has a stock code
                                        sMsg, mType);


  end
  else
    Ok2Cont:=(Sender=OkCP1Btn);

  If OK2Cont then
  With CRepParam^ do
  Begin
    OKCP1Btn.Enabled:=BOff;

    If (RepMode=1) then
    Begin
      StockFilt:=FullStockCode(ACFF.Text);


      LocFilt:=CustFilt;

    end
    else
    Begin
      StockFilt:=CustFilt;

      If (Stock.StockCode<>StockFilt) then
        Global_GetMainRec(StockF,StockFilt);


    end;

    If (Is_FullStkCode(StockFilt)) then
      StkFolioFilt:=Stock.StockFolio;

    SDate:=I1TransDateF.DateValue;
    EDate:=I2TransDateF.DateValue;

    AllAccs:=DelAll1.Checked;
    UseDates:=DelExp1.Checked;

    AddDelDiscRec2Thread(Owner,RepMode,CRepParam);
  end;

  inherited;

end;

procedure TDelQBInpR.SetHelpContextIDs;
// NF: 11/05/06 Fix for incorrect Context IDs
begin
  HelpContext := 1726;
  DelExp1.HelpContext := 1727;
  DelAll1.HelpContext := 1728;
  OkCP1Btn.HelpContext := 1729;
  ClsCP1Btn.HelpContext := 1730;
  ACFF.HelpContext := 2082 // NF: 24/07/06
end;

  procedure Del_Discount(IdMode  :  Byte;
                         CFilt   :  Str10;
                         AOwner  :  TComponent);

  const
    DeleteAllMsg : Array[0..1] of String = ('Stock', 'Account');
  Var
    RepInpMsg1  :  TDelQBInpR;

  Begin
    QBRNo:=IdMode;

    RepInpMsg1:=TDelQBInpR.Create(AOwner);

    Try
      RepInpMsg1.CustFilt:=CFilt;
      RepInpMsg1.DelAll1.Caption := 'Delete for All ' + DeleteAllMsg[IdMode] + ' Records';
    except
      RepInpMsg1.Free;
    end; {Try..}

  end;




end.
