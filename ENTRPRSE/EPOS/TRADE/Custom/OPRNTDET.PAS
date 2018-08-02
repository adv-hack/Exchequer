unit oPrntDet;

Interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, EPOSCnst, StdVcl, RPDevice;

type
  TPrinterDetails = Record
    PrinterName : string;
    FormName : string;
    PaperID : Integer;
    BinID : Integer;
  end;

  TTradeTCMSetupPrintDet = class(TAutoIntfObject, ITradeTCMSetupPrintDet)
  private
    lPrinterDetails : TPrinterDetails;
  protected
    function Get_pdFormName: WideString; safecall;
    function Get_pdPrinterName: WideString; safecall;
    function Get_pdPaper: WideString; safecall;
    function Get_pdBin: WideString; safecall;
  public
    Constructor Create(sPrinterName, sFormName : String; iPaperID, iBinID : Integer);
    Destructor Destroy; override;
  End; { TTradeTCMSetupPrintDet }

implementation

uses ComServ;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeTCMSetupPrintDet.Create(sPrinterName, sFormName : String
; iPaperID, iBinID : Integer);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeTCMSetupPrintDet);

  with lPrinterDetails do begin
    PrinterName := sPrinterName;
    FormName := sFormName;
    PaperID := iPaperID;
    BinID := iBinID;
  end;{with}

End; { Create }

Destructor TTradeTCMSetupPrintDet.Destroy;
Begin { Destroy }
  Inherited;
End; { Destroy }


function TTradeTCMSetupPrintDet.Get_pdBin : WideString;
var
  iPos : integer;
begin
  Result := '';
  RpDev.SelectPrinter(lPrinterDetails.PrinterName, FALSE);
  for iPos := 0 to RpDev.Bins.Count - 1 do begin
    if LongInt(RpDev.Bins.Objects[iPos]) = lPrinterDetails.BinID then begin
      Result := RpDev.Bins[iPos];
      Break;
    end;{if}
  end;{for}
end;

function TTradeTCMSetupPrintDet.Get_pdFormName: WideString;
begin
  Result := lPrinterDetails.FormName;
end;

function TTradeTCMSetupPrintDet.Get_pdPaper : WideString;
var
  iPos : integer;
begin
  Result := '';
  RpDev.SelectPrinter(lPrinterDetails.PrinterName, FALSE);
  for iPos := 0 to RpDev.Papers.Count - 1 do begin
    if LongInt(RpDev.Papers.Objects[iPos]) = lPrinterDetails.PaperID then begin
      Result := RpDev.Papers[iPos];
      Break;
    end;{if}
  end;{for}
end;

function TTradeTCMSetupPrintDet.Get_pdPrinterName: WideString;
begin
  Result := lPrinterDetails.PrinterName;
end;

end.
