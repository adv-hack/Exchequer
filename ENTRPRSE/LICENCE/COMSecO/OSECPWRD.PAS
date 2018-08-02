unit oSecPwrd;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exchequer_TLB, StdVcl;

type
  TSecPwords = class(TAutoObject, ISecPwords)
  protected
    { Protected declarations }
    function Get_Version: WideString; safecall;
    function Get_PlugInToday: WideString; safecall;
    function Get_PlugInTomorrow: WideString; safecall;

    // Local Methods
    function Generate_Security(Const PWDate : TDateTime; Const PWNo : SmallInt) : WideString;
  end;

implementation

uses ComServ, SysUtils, ETDateU, VarRec2U, SecSup2U;

//--------------------------------------------------------------------------

function TSecPwords.Get_Version: WideString;
begin
  Result := 'v1.20';
end;

//--------------------------------------------------------------------------

function TSecPwords.Generate_Security(Const PWDate : TDateTime; Const PWNo : SmallInt) : WideString;
Var
  DummyESN : ISNArrayType;
begin
  // Initialise a dummy ESN
  FillChar (DummyESN, SizeOf(DummyESN), #0);

  // Setup the date used by the security routines  p
  SecBaseDate := PWDate;

  // calculate the security code
  Result := Generate_ESN_BaseSecurity(DummyESN,PWNo,0,0);
end;

//--------------------------------------------------------------------------

function TSecPwords.Get_PlugInToday: WideString;
begin { Get_PlugInToday }
  Result := Generate_Security(Now, 248);
end; { Get_PlugInToday }

//--------------------------------------------------------------------------

function TSecPwords.Get_PlugInTomorrow: WideString;
begin { Get_PlugInTomorrow }
  Result := Generate_Security(Now + 1, 248);
end; { Get_PlugInTomorrow }

//--------------------------------------------------------------------------

initialization
  TAutoObjectFactory.Create(ComServer, TSecPwords, Class_SecPwords,
    ciMultiInstance, tmApartment);
end.
