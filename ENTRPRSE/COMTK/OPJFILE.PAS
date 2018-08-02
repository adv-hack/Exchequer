unit oPJFile;

interface

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},// COM Toolkit Type Library
     EnterpriseForms_TLB,      // Forms Toolkit Type Library
     ExceptIntf;

Type
  TPrintJobFileInfo = class(TAutoIntfObjectEx, IPrintJobFileInfo)
  private
    // Local reference to File Info sub-object within the Forms TK PrintJob object
    FFTKFile : IEFPrintJobFileInfo;
  protected
    // IPrintJobFileInfo
    function Get_fiAttachmentType: TEmailAttachMethod; safecall;
    function Get_fiAttachmentPrinterIndex: Integer; safecall;
  public
    Constructor Create (Const FTKFile : IEFPrintJobFileInfo);
    Destructor Destroy; override;
  End; { TPrintJobFileInfo }

implementation

uses ComServ,
     Miscfunc;     // Miscellaneous Types and routines for COMTK

//-----------------------------------------------------------------------------

Constructor TPrintJobFileInfo.Create (Const FTKFile : IEFPrintJobFileInfo);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IPrintJobFileInfo);

  FFTKFile := FTKFile;
End; { Create }

//----------------------------------------

Destructor TPrintJobFileInfo.Destroy;
Begin { Destroy }
  FFTKFile := NIL;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

function TPrintJobFileInfo.Get_fiAttachmentPrinterIndex: Integer;
begin
  Result := FFTKFile.fiAttachmentPrinterIndex;
end;

//----------------------------------------

function TPrintJobFileInfo.Get_fiAttachmentType: TEmailAttachMethod;
begin
  Case FFTKFile.fiAttachmentType Of
  {$IFNDEF WANTEXE}
    EnterpriseForms_TLB.atInternalEDF : Result := Enterprise01_TLB.eamInternal;
    EnterpriseForms_TLB.atAdobePDF    : Result := Enterprise01_TLB.eamAcrobat;
    EnterpriseForms_TLB.atInternalPDF : Result := Enterprise01_TLB.eamInternalPDF;
  {$ELSE}
    EnterpriseForms_TLB.atInternalEDF : Result := Enterprise04_TLB.eamInternal;
    EnterpriseForms_TLB.atAdobePDF    : Result := Enterprise04_TLB.eamAcrobat;
    EnterpriseForms_TLB.atInternalPDF : Result := Enterprise04_TLB.eamInternalPDF;
  {$ENDIF}
  Else
    Raise EUnknownValue.Create ('Unknown Attachment Type (' + IntToStr(Ord(FFTKFile.fiAttachmentType)) + ')');
  End; { Case FFTKFile.fiAttachmentType }
end;

//-----------------------------------------------------------------------------

end.
