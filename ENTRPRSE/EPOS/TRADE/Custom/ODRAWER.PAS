unit oDrawer;

Interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, EPOSCnst, StdVcl;

type
  TTradeTCMSetupCashDrawer = class(TAutoIntfObject, ITradeTCMSetupCashDrawer)
  private
    lSetupRec : TEposSetupRec;
  protected
    function Get_cdOpenOnCash: WordBool; safecall;
    function Get_cdOpenOnCheque: WordBool; safecall;
    function Get_cdOpenOnCard: WordBool; safecall;
    function Get_cdOpenOnAccount: WordBool; safecall;
    function Get_cdKickOutCodes: WideString; safecall;
    function Get_cdComPortNo: Integer; safecall;
    function Get_cdBaudRate: TTradeBaudRate; safecall;
    procedure OpenCashDrawer(COMPort: Integer; BaudRate: TTradeBaudRate;
                               const KickOutCodes: WideString); safecall;
  public
    Constructor Create(SetupRec : TEposSetupRec);
    Destructor Destroy; override;
  End; { TTradeTCMSetupCashDrawer }

implementation

uses
  ComServ, EPOSProc;

{-------------------------------------------------------------------------------------------------}

procedure TTradeTCMSetupCashDrawer.OpenCashDrawer(COMPort: Integer;
  BaudRate: TTradeBaudRate; const KickOutCodes: WideString);
var
  iBaudRate : integer;
begin
  Case BaudRate of
    br9600 : iBaudRate := 9600;
    br19200 : iBaudRate := 19200;
    br38400 : iBaudRate := 38400;
    br57600 : iBaudRate := 57600;
    br115200 : iBaudRate := 115200;
  end;{case}

  OpenCashDrawer(COMPort, iBaudRate, KickOutCodes);
end;

Constructor TTradeTCMSetupCashDrawer.Create(SetupRec : TEposSetupRec);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeTCMSetupCashDrawer);
  lSetupRec := SetupRec;
End; { Create }

Destructor TTradeTCMSetupCashDrawer.Destroy;
Begin { Destroy }
  Inherited;
End; { Destroy }

function TTradeTCMSetupCashDrawer.Get_cdBaudRate: TTradeBaudRate;
begin
  case lSetupRec.CashDrawerBaudRate of
    0 : Result := br9600;
    1 : Result := br19200;
    2 : Result := br38400;
    3 : Result := br57600;
    4 : Result := br115200;
  end;{Case}
end;

function TTradeTCMSetupCashDrawer.Get_cdComPortNo: Integer;
begin
  Result := lSetupRec.CashDrawerCOM;
end;

function TTradeTCMSetupCashDrawer.Get_cdKickOutCodes: WideString;
begin
  Result := lSetupRec.CashDrawerKick;
end;

function TTradeTCMSetupCashDrawer.Get_cdOpenOnAccount: WordBool;
begin
  Result := lSetupRec.CashDrawerOpenOn[pbAccount];
end;

function TTradeTCMSetupCashDrawer.Get_cdOpenOnCard: WordBool;
begin
  Result := lSetupRec.CashDrawerOpenOn[pbCard];
end;

function TTradeTCMSetupCashDrawer.Get_cdOpenOnCash: WordBool;
begin
  Result := lSetupRec.CashDrawerOpenOn[pbCash];
end;

function TTradeTCMSetupCashDrawer.Get_cdOpenOnCheque: WordBool;
begin
  Result := lSetupRec.CashDrawerOpenOn[pbCheque];
end;

end.
