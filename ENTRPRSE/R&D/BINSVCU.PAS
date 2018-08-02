unit BINSVCU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, BTSupU1, Mask,
  TEditVal, VarConst, BTSupU3, BorBtns;

type
  TStockBinInp = class(TRepInpMsg)
    BorRadio1: TBorRadio;
    BorRadio2: TBorRadio;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
  private
    { Private declarations }


  public
    { Public declarations }
    OldStkRec,
    NewStkRec  :  StockRec;


  end;

procedure BinCreateCtrl(OStk,
                        NStk     :  StockRec;
                        AOwner   :  TComponent);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  SysU1,
  SysU2,

  PrintFrm,
  Event1U,
  BTSupU2,
  RevalueU;

{$R *.DFM}






procedure TStockBinInp.FormCreate(Sender: TObject);


begin
  inherited;
  ClientHeight:=144;
  ClientWidth:=299;



  SetLastValues;
end;

procedure TStockBinInp.OkCP1BtnClick(Sender: TObject);


begin

  If (Sender=OkCP1Btn) then
  Begin
    AddStkBinFill2Thread(Owner,OldStkRec,NewStkRec,'',1+Ord(BorRadio2.Checked));
  end;

  inherited;

end;


procedure BinCreateCtrl(OStk,
                        NStk     :  StockRec;
                        AOwner   :  TComponent);

Var
  RepInpMsg1  :  TStockBinInp;

Begin

  RepInpMsg1:=TStockBinInp.Create(AOwner);

  try
    With RepInpMsg1 do
    Begin
      OldStkRec:=OStk; NewStkRec:=NStk;

    end;
  except;
    RepInpMsg1.Free;
  end;

end;






end.

