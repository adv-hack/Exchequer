unit PrinterUtil;

interface
uses
  Types;

  function GetPrinterPortFromName(sName : string) : string;
  function GetPrinterNameFromPort(sPortToFind : string) : string;


implementation
uses
  Dialogs, WinSpool, SysUtils, Printers;

function GetPrinterPortFromName(sName : string) : string;
var
  hPrinter : THandle;
  Needed : DWord;
  PInfo : PPrinterInfo2;
  asPrinterName : string;
begin
  try
    asPrinterName := Trim(sName);
    OpenPrinter(PChar(asPrinterName), hPrinter, nil);
    GetPrinter(hPrinter, 2, nil, 0, @Needed);
    PInfo := AllocMem(Needed);
    GetPrinter(hPrinter, 2, PInfo, Needed, @Needed);
    Result := Trim(PInfo.pPortName);
    FreeMem(PInfo);
  except
    on E:Exception do
      ShowMessage('GetPrinterPortFromName(' + sName + ') failed with the message :' +#13#13 + E.Message);
  end;{try}
end;

function GetPrinterNameFromPort(sPortToFind : string) : string;
var
  iPos : integer;
  sPort : string;
begin
  Result := '';
  For iPos := 0 to Printer.Printers.Count-1 do
  begin
    sPort := GetPrinterPortFromName(Printer.Printers[iPos]);
    if sPort = sPortToFind then
    begin
      Result := Printer.Printers[iPos];
      Break;
    end;{if}
  end;{for}
end;


end.
