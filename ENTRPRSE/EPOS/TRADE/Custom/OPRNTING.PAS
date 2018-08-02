unit oPrnting;

Interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, EPOSCnst, oPrntDet;

type
  TTradeTCMSetupPrinting = class(TAutoIntfObject, ITradeTCMSetupPrinting)
  private
    lSetupRec : TEposSetupRec;

    FReceiptO : TTradeTCMSetupPrintDet;
    FReceiptI : ITradeTCMSetupPrintDet;

    FInvoiceO : TTradeTCMSetupPrintDet;
    FInvoiceI : ITradeTCMSetupPrintDet;

    FOrderO : TTradeTCMSetupPrintDet;
    FOrderI : ITradeTCMSetupPrintDet;
  protected
    function Get_prReceipt: ITradeTCMSetupPrintDet; safecall;
    function Get_prInvoice: ITradeTCMSetupPrintDet; safecall;
    function Get_prOrder: ITradeTCMSetupPrintDet; safecall;
  public
    Constructor Create(SetupRec : TEposSetupRec);
    Destructor Destroy; override;
  End; { TTradeTCMSetupPrinting }

implementation

uses ComServ;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeTCMSetupPrinting.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeTCMSetupPrinting);

  lSetupRec := SetupRec;

  with lSetupRec do begin

    FReceiptO := TTradeTCMSetupPrintDet.Create(ReceiptPrinter, ReceiptFormName
    ,RecPrintPaper, RecPrintBin);
    FReceiptI := FReceiptO;

    FInvoiceO := TTradeTCMSetupPrintDet.Create(InvoicePrinter, InvoiceFormName
    , InvPrintPaper, InvPrintBin);
    FInvoiceI := FInvoiceO;

    FOrderO := TTradeTCMSetupPrintDet.Create(OrderPrinter, OrderFormName
    , OrderPrintPaper, OrderPrintBin);
    FOrderI := FOrderO;

  end;{with}

End; { Create }

Destructor TTradeTCMSetupPrinting.Destroy;
Begin { Destroy }

  FReceiptO := nil;
  FReceiptI := nil;

  FInvoiceO := nil;
  FInvoiceI := nil;

  FOrderO := nil;
  FOrderI := nil;

  Inherited;
End; { Destroy }

function TTradeTCMSetupPrinting.Get_prInvoice: ITradeTCMSetupPrintDet;
begin
  Result := FInvoiceI;
end;

function TTradeTCMSetupPrinting.Get_prOrder: ITradeTCMSetupPrintDet;
begin
  Result := FOrderI;
end;

function TTradeTCMSetupPrinting.Get_prReceipt: ITradeTCMSetupPrintDet;
begin
  Result := FReceiptI;
end;

end.
