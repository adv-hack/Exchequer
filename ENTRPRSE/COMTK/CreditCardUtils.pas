unit CreditCardUtils;

interface

//PR: 20/11/2014 Order Payments - function to specify if Credit Card plug-in is installed.
function CreditCardPluginInstalled(const CoCode : string) : Boolean;

implementation

uses
  oCreditCardGateway, oMCMSec, VarConst, VarCnst3;

//Object to store whether the Credit Card plugin is installed or not.
type
  TCCPluginStatus = class
    IsAvailable : Boolean;
    constructor Create(const CoCode : string);
  end;

var
  FCCPlugInStatus : TCCPlugInStatus;


function CreditCardPluginInstalled(const CoCode : string) : Boolean;
begin
  //If this is the first time we check CC installed, create object
  if not Assigned(FCCPlugInStatus) then
    FCCPlugInStatus := TCCPlugInStatus.Create(CoCode);

  Result := FCCPlugInStatus.IsAvailable;
end;

{ TCCPluginStatus }

constructor TCCPluginStatus.Create(const CoCode : string);
var
  Res : Integer;
begin
  inherited Create;

  //Load MCM security and check if the plug-in is installed
  with TMCMSecurity.Create (ssToolkit, SyssMod^.ModuleRel.CompanyID, ExSyss.BatchPath) do
  Try
    if Loaded then
    begin
      //Check licence
      Res := CheckPlugInLicence (CreditCardGatewayPlugInCode);

      //full or 30-day licence
      CreditCardPaymentGateway.ccpgLicenced := (Res = 1) Or (Res = 2);

      //Set company code
      CreditCardPaymentGateway.ccpgCompanyCode := CoCode;

      //set status
      IsAvailable := CreditCardPaymentGateway.ccpgInstalled and CreditCardPaymentGateway.ccpgLicenced;
    end
    else  //Can't load security - eek
      IsAvailable := False;
  Finally
    Free;
  End;
end;

Initialization

  FCCPluginStatus := nil;

Finalization
  if Assigned(FCCPlugInStatus) then
    FCCPlugInStatus.Free;

end.
