program PrinterInfo;

uses
  Forms,
  PrinterInfoF in 'PrinterInfoF.pas' {frmPrinterBinInfo};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrinterBinInfo, frmPrinterBinInfo);
  Application.Run;
end.
