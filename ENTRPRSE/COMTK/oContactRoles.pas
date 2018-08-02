unit oContactRoles;

{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     SysConst, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarConst,
     ContactsManager, oContactRoleBtrieveFile, ExceptIntf;

type
  TSystemSetupContactRole = class(TAutoIntfObjectEx, ISystemSetupContactRole)
  private
    FRole : ContactRoleRecType;
  protected
    function Get_crRoleId: Integer; safecall;
    function Get_crDescription: WideString; safecall;
    function Get_crAppliesToCustomer: WordBool; safecall;
    function Get_crAppliesToSupplier: WordBool; safecall;
  public
    constructor Create(const Role : ContactRoleRecType);
  end;

  TSystemSetupContactRolesList = class(TAutoIntfObjectEx, ISystemSetupContactRolesList)
  private
    FContactsManager : TContactsManager;
  protected
    function Get_crlRole(Index: Integer): ISystemSetupContactRole; safecall;
    function Get_crlCount: Integer; safecall;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TLimitedSystemSetupContactRolesList = class(TAutoIntfObjectEx, ISystemSetupContactRolesList)
  private
    FContactsManager : TContactsManager;
    FAccountContact : TAccountContact;
  protected
    function Get_crlRole(Index: Integer): ISystemSetupContactRole; safecall;
    function Get_crlCount: Integer; safecall;
  public
    constructor Create(const AContact: TAccountContact; const AContactsManager : TContactsManager);
    destructor Destroy; override;
  end;




implementation

uses
  ComServ, MiscFunc;

{ TSystemSetupContactRole }

constructor TSystemSetupContactRole.Create(const Role : ContactRoleRecType);
begin
  Inherited Create (ComServer.TypeLib, ISystemSetupContactRole);
  FRole := Role;
end;

function TSystemSetupContactRole.Get_crAppliesToCustomer: WordBool;
begin
  Result := FRole.crRoleAppliesToCustomer;
end;

function TSystemSetupContactRole.Get_crAppliesToSupplier: WordBool;
begin
  Result := FRole.crRoleAppliesToSupplier;
end;

function TSystemSetupContactRole.Get_crDescription: WideString;
begin
  Result := FRole.crRoleDescription;
end;

function TSystemSetupContactRole.Get_crRoleId: Integer;
begin
  Result := FRole.crRoleId;
end;

{ TSystemSetupContactRolesList }

constructor TSystemSetupContactRolesList.Create;
begin
  Inherited Create (ComServer.TypeLib, ISystemSetupContactRolesList);
  FContactsManager := NewContactsManager;
end;

destructor TSystemSetupContactRolesList.Destroy;
begin
  FContactsManager.Free;
  inherited;
end;

function TSystemSetupContactRolesList.Get_crlCount: Integer;
begin
  Result := FContactsManager.GetNumRoles;
end;

function TSystemSetupContactRolesList.Get_crlRole(
  Index: Integer): ISystemSetupContactRole;
begin
  //Index is 1 based, so need to decrement to access zero-based array in contacts manager
  if (Index > 0) and (Index <= Get_crlCount) then
    Result := TSystemSetupContactRole.Create(FContactsManager.GetRole(Index - 1)) as ISystemSetupContactRole
  else
    raise EInvalidIndex.Create('Invalid Role Index (' + IntToStr(Index) + ')');
end;


{ TLimitedSystemSetupContactRolesList }

constructor TLimitedSystemSetupContactRolesList.Create(const AContact: TAccountContact;
  const AContactsManager : TContactsManager);
var
  i, iRoleCount : integer;
begin
  Inherited Create (ComServer.TypeLib, ISystemSetupContactRolesList);
  FContactsManager := AContactsManager;
  FAccountContact := AContact;
end;

destructor TLimitedSystemSetupContactRolesList.Destroy;
begin
  inherited;
end;

function TLimitedSystemSetupContactRolesList.Get_crlCount: Integer;
begin
  Result := Length(FAccountContact.assignedRoles);
end;

function TLimitedSystemSetupContactRolesList.Get_crlRole(
  Index: Integer): ISystemSetupContactRole;
begin
  if (Index > 0) and (Index <= Get_crlCount) then
    Result := TSystemSetupContactRole.Create(FAccountContact.assignedRoles[Index - 1]) as ISystemSetupContactRole
  else
    raise EInvalidIndex.Create('Invalid Role Index (' + IntToStr(Index) + ')');
end;


end.
