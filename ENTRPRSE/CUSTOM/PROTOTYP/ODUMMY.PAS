// Dummy Interface for EnterpriseTrade.Customisation COM Object
unit oDummy;

{$WARN SYMBOL_PLATFORM OFF}

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl;

type
  TDummy = class(TAutoObject, IDummy)
  private
  protected
    // IDummy
  public
    procedure Initialize; override;
  end;

implementation

uses ComServ, SysUtils;

//---------------------------------------------------------------------------

Procedure TDummy.Initialize;
Begin { Initialize }
  inherited Initialize;

  Raise Exception.Create ('EnterpriseTrade.Customisation is not implemented');
End; { Initialize }

initialization
  TAutoObjectFactory.Create(ComServer, TDummy, Class_Customisation, ciSingleInstance, tmApartment);
end.
