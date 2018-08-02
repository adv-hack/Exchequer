unit FBICallback;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, FBITestHarness_TLB, StdVcl, InternetFiling_TLB;

type
  TFBI_Callback = class(TAutoObject, IFBI_Callback, ICallback)
  protected
    { Protected declarations }
    procedure Response(const message: WideString); safecall;
    procedure _Unused; safecall;
  end;

implementation

uses ComServ, frmMainImp;

{ TTFBI_Callback }

procedure TFBI_Callback.Response(const message: WideString);
begin
    frmMain.Memo1.Lines.Add(message);
end;

procedure TFBI_Callback._Unused;
begin
    //
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFBI_Callback, Class_FBI_Callback,
    ciMultiInstance, tmFree);
end.
