{-----------------------------------------------------------------------------
 Unit Name: uCISCallback
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uCISCallback;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, CISIncoming_TLB, StdVcl, InternetFiling_TLB;

Type
  TCISCallBack = Class(TAutoObject, ICISCallBack, ICallback)
  Protected
    Procedure _Unused; Safecall;
    Procedure Response(Const message: WideString); Safecall;
    { Protected declarations }
  End;

Implementation

Uses ComServ;

{-----------------------------------------------------------------------------
  Procedure: _Unused
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISCallBack._Unused;
Begin

End;

{-----------------------------------------------------------------------------
  Procedure: Response
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISCallBack.Response(Const message: WideString);
Begin
  if message <> '' then
  begin
  end; {if message <> '' then}
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TCISCallBack, Class_CISCallBack,
    ciMultiInstance, tmApartment);
End.

