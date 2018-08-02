unit oSysSetup;

Interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, oTCMSys, oEntSys, EPOSCnst;

type
  TTradeSystemSetup = class(TAutoIntfObject, ITradeSystemSetup)
  private
    FTCMSetupO : TTradeTCMSetup;
    FTCMSetupI : ITradeTCMSetup;

    FEntSetupO : TTradeEntSetup;
    FEntSetupI : ITradeEntSetup;

    oEventData : TObject;

    FDataChanged : Boolean;

//    Function GetDataChanged : Boolean;

  protected
    function Get_ssTradeCounter: ITradeTCMSetup; safecall;
    function Get_ssEnterprise: ITradeEntSetup; safecall;
  public
    LSetupRecord : TEposSetupRec;

    // DataChanged flag indicates whether Plug-Ins made any changes to
//    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create;
    Destructor Destroy; override;
//    Procedure Assign(const EventData: TObject; ASetupRecord : TEposSetupRec);
  End; { TTradeSystemSetup }

implementation

uses ComServ;

{-------------------------------------------------------------------------------------------------}
(*
procedure TTradeSystemSetup.Assign(const EventData: TObject; ASetupRecord : TEposSetupRec);
begin
  // Reset Datachanged flag for new event
  FDataChanged := False;

  oEventData := EventData;
  LSetupRecord := ASetupRecord;

  // Assign sub-objects
//  FTCMSetupO.Assign(oEventData);
end;
*)
Constructor TTradeSystemSetup.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeSystemSetup);

  FTCMSetupO := TTradeTCMSetup.create;
  FTCMSetupI := FTCMSetupO;

  FEntSetupO := TTradeEntSetup.create;
  FEntSetupI := FEntSetupO;
End; { Create }

Destructor TTradeSystemSetup.Destroy;
Begin { Destroy }

  FTCMSetupO := nil;
  FTCMSetupI := nil;

  FEntSetupO := nil;
  FEntSetupI := nil;

  Inherited;
End; { Destroy }
{
function TTradeSystemSetup.GetDataChanged: Boolean;
begin
  Result := FDataChanged or FTCMSetupO.DataChanged;
end;
}
function TTradeSystemSetup.Get_ssEnterprise: ITradeEntSetup;
begin
  Result := FEntSetupI;
end;

function TTradeSystemSetup.Get_ssTradeCounter: ITradeTCMSetup;
begin
  Result := FTCMSetupI
end;

end.
