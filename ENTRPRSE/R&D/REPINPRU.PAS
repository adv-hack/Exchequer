unit RepInpRU;

{$I DEFOVR.Inc}
          
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, BTSupU3, bkgroup, BorBtns, TEditVal, Mask,
  Animate, SBSPanel;

type
  TRepInpMsgR = class(TRepInpMsg)
    Label81: Label8;
    Label83: Label8;
    ACFF: Text8Pt;
    SxSF: TSBSComboBox;
    DocFiltF: Text8Pt;
    Label810: Label8;
    LocLab: Label8;
    LocF: Text8Pt;
    Label86: Label8;
    I1TransDateF: TEditDate;
    Label87: Label8;
    I2TransDateF: TEditDate;
    Label82: Label8;
    FxLBCB: TSBSComboBox;
    AgeInt: TCurrencyEdit;
    Label84: Label8;
    Label85: Label8;
    OrdFiltF: Text8Pt;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure LocFExit(Sender: TObject);
    procedure OrdFiltFExit(Sender: TObject);
    procedure DocFiltFEnter(Sender: TObject);
    procedure AgeIntKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    RepMode    :  Byte;

    CRepParam  :  BinRepPtr;

  public
    { Public declarations }
  end;

Var
  SLRNo  :  Byte;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  GlobVar,
  VarConst,
  BTKeys1U,
  ComnU2,
  BTSupU1,
  InvListU,
  ReportU,
  RepBNSKU,
  SysU1,
  SysU2,

  BTSupU2;


{$R *.DFM}



procedure TRepInpMsgR.FormCreate(Sender: TObject);


Var
  HideLoc  :  Boolean;

begin
  inherited;

  ClientHeight:=242;
  ClientWidth:=299;

  RepMode:=SLRNo;

  If (RepMode=1) then
    SxSF.ItemIndex:=1
  else
    SxSF.ItemIndex:=0;

  FxLBCB.ItemIndex:=0;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  I1TransDateF.DateValue:=Today;
  I2TransDateF.DateValue:=MaxUntilDate;


  {$IFNDEF SOP}

    HideLoc:=BOn;

    Label85.Visible:=BOff;
    OrdFiltF.Visible:=BOff;

  {$ELSE}

    HideLoc:=(Not Syss.UseMLoc);

  {$ENDIF}


  If (HideLoc) then
  Begin
    LocF.Visible:=BOff;
    LocLab.Visible:=BOff;
  end;


  Case RepMode of
    1  :  Begin
            Label86.Visible:=BOff;
            I1TransDateF.visible:=BOff;
            I2TransDateF.visible:=BOff;
            Label87.Visible:=BOff;

          end;

    3  :  Begin
            Caption:='Bin History Report';

            Label85.Visible:=BOff;
            OrdFiltF.Visible:=BOff;

          end;


  end; {Case..}

  SetLastValues;
end;

procedure TRepInpMsgR.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;





procedure TRepInpMsgR.ACFFExit(Sender: TObject);
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




procedure TRepInpMsgR.LocFExit(Sender: TObject);
Var
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

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetMLoc(Self,FoundCode,FoundCode,'',0));


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

procedure TRepInpMsgR.OrdFiltFExit(Sender: TObject);
Const
  Fnum     =   InvF;

  Keypath  =   InvOurRefK;

Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  GenStr     :  Str255;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundCode:=AutoSetInvKey(Text,0);

      GenStr:=FoundCode;

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,GenStr);

      FoundOk:=StatusOk;

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


procedure TRepInpMsgR.DocFiltFEnter(Sender: TObject);
begin
  inherited;
  DocFiltF.ReadOnly:=(OrdFiltF.Text<>'');
end;

procedure TRepInpMsgR.OkCP1BtnClick(Sender: TObject);

begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        StockFilt:=FullStockCode(ACFF.Text);

        If (Is_FullStkCode(StockFilt)) and (Stock.StockType<>StkGrpCode) then
          StkFolioFilt:=Stock.StockFolio;

        BinFilt:=DocFiltF.Text;

        LocFilt:=LocF.Text;

        SDate:=I1TransDateF.DateValue;
        EDate:=I2TransDateF.DateValue;

        TagFilt:=Round(AgeInt.Value);

        AnalOrd:=FxLBCB.ItemIndex;

        OrdRef:=OrdFiltF.Text;

        AddBIN1Rep2Thread(RepMode+SxSF.ItemIndex,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;




procedure TRepInpMsgR.AgeIntKeyPress(Sender: TObject; var Key: Char);
begin
  If (Key = '-') Then
    Key := #0;
end;

end.
