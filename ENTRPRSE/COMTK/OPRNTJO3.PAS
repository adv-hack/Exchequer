unit oPrntJo3;

interface

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, EnterpriseForms_TLB,
     ExceptIntf;

Type
  TPrintJobFaxInfo = class(TAutoIntfObjectEx, IPrintJobFaxInfo)
  private
    FPrintJob : TObject;
  protected
    // IPrintJobFaxInfo

  public
    Constructor Create (Const PrintJob : TObject);
    Destructor Destroy; override;
  End; { TPrintJobFaxInfo }

implementation

uses ComServ;

Constructor TPrintJobFaxInfo.Create (Const PrintJob : TObject);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IPrintJobFaxInfo);

  FPrintJob := PrintJob;
End; { Create }

//----------------------------------------

Destructor TPrintJobFaxInfo.Destroy;
Begin { Destroy }
  FPrintJob := NIL;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

end.
