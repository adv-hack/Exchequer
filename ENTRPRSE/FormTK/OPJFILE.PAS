unit oPJFile;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB, Enterprise01_TLB, RpDevice;

Type
  TEFPrintJobFileInfo = class(TAutoIntfObject, IEFPrintJobFileInfo)
  private
    // Local Reference to parent PrintJob object
    FPrintJob : TObject;

    // Attachment Printer number
    FAttachPrnNo : Integer;
  protected
    // IEFPrintJobFileInfo
    function Get_fiAttachmentType: TEFAttachmentType; safecall;
    function Get_fiAttachmentPrinterIndex: Integer; safecall;

    // Local methods
  public
    Constructor Create (Const PrintJob : TObject);
    Destructor  Destroy; override;

    procedure Initialise;
  End; { TEFPrintJobFileInfo }

implementation

Uses ComServ,
     VarConst,         // Exchequer Global Constants/Types/Variables
     oPrntJob,         // TEFPrintJob object
     LogUtil;

//-----------------------------------------------------------------------------

Constructor TEFPrintJobFileInfo.Create (Const PrintJob : TObject);
Begin { Create }
  OutputDebug('TEFPrintJobFileInfo.Create Start');

  Inherited Create (ComServer.TypeLib, IEFPrintJobFileInfo);

  FPrintJob := PrintJob;

  Initialise;
  OutputDebug('TEFPrintJobFileInfo.Create End');
End;

//----------------------------------------

Destructor TEFPrintJobFileInfo.Destroy;
Begin { Destroy }
  // Local Reference to parent PrintJob object
  FPrintJob := NIL;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

procedure TEFPrintJobFileInfo.Initialise;
Var
  I : Integer;
begin
  With SyssEDI2^.EDI2Value, FPrintJob as TEFPrintJob Do Begin
    // Email Attachment Types
    PrintJobSetupInfo.feEmailAtType := emAttchMode;

    // Email Attachment Printer
    FAttachPrnNo := -1;
    If (RpDev.Printers.Count > 0) Then
      For I := 0 To Pred(RpDev.Printers.Count) Do
        If (UpperCase(Trim(EmailPrnN)) = UpperCase(Trim(RpDev.Printers[I]))) Then Begin
          FAttachPrnNo := I;
          Break;
        End; { If }
  End; { With SyssEDI2^.EDI2Value }
end;

//-----------------------------------------------------------------------------

function TEFPrintJobFileInfo.Get_fiAttachmentPrinterIndex: Integer;
begin
  Result := FAttachPrnNo;
end;

//----------------------------------------

function TEFPrintJobFileInfo.Get_fiAttachmentType: TEFAttachmentType;
begin
  With FPrintJob as TEFPrintJob Do
    Case PrintJobSetupInfo.feEmailAtType Of
      0 : Result := atInternalEDF;
      1 : Result := atAdobePDF;
      2 : Result := atInternalPDF;
    Else
      Raise Exception.Create ('IEFPrintJobFileInfo.fiAttachmentType: Unhandled Attachment Type (' + IntToStr(PrintJobSetupInfo.feEmailAtType) + ')');
    End; { Case feEmailAtType }
end;

//-----------------------------------------------------------------------------

end.
