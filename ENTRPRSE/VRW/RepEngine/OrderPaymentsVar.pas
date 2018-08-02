unit OrderPaymentsVar;


{$IFNDEF RW}
 Only to be used with the RW define
{$ENDIF}

interface
{$ALIGN 1}
uses
  oOPVATPayBtrieveFile;

const
  OrderPaymentsF = 31;


  procedure DefineOrderPaymentsFile;

var
  OrderPaymentVatRec : OrderPaymentsVATPayDetailsRecType; //Global record
  OPLinkTransaction : string; //OurRef of the transaction currently linked to the OP rec

implementation

uses
  BtrvU2, GlobVar;

procedure DefineOrderPaymentsFile;
begin
{$IFNDEF REPWRT}
  Filenames[OrderPaymentsF] := 'TRANS\OPVATPAY.DAT';

  RecPtr[OrderPaymentsF] := @OrderPaymentVATRec;

  FileRecLen[OrderPaymentsF] := SizeOf(OrderPaymentVATRec);

  FileSpecLen[OrderPaymentsF] := SizeOf(OrderPaymentsVATPayDetailsBtrieveFileDefinitionType);

{$ENDIF}
end;


end.
