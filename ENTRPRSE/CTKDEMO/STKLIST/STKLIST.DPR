program StkList;

uses
  Forms,
  StkListF in 'StkListF.pas' {frmStockList},
  StkDetlF in 'StkDetlF.pas' {frmStockDetail},
  StkSelct in 'StkSelct.pas' {frmStkSelect},
  Stkloclf in 'Stkloclf.pas' {frmStkLocList},
  StkLocDF in 'Stklocdf.pas' {frmStkLocDetl},
  QtyBrkF in 'x:\ENTRPRSE\COMTK\CustList\QtyBrkF.pas' {frmQtyBreak},
  BOMDetF in 'BOMDetF.pas' {frmBOMDetails},
  SerDetF in 'SerDetF.pas' {frmSerialDet};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Enterprise COM Toolkit Demo - Stock List';
  Application.CreateForm(TfrmStockList, frmStockList);
  Application.Run;
end.
