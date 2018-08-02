unit ELITE_COM_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.130.3.0.1.0  $
// File generated on 27/06/2006 09:13:58 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\IRIS Software Ltd\IRIS Licensing Network Client\Iris Account Office Licensing COM.tlb (1)
// LIBID: {D287AC1D-91D3-444C-8FF2-B689D52E9FA5}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v2.0 mscorlib, (C:\WINNT\Microsoft.NET\Framework\v2.0.50727\mscorlib.tlb)
//   (3) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// Errors:
//   Hint: Parameter 'Until' of IEliteCom.ActivateFromWS changed to 'Until_'
//   Error creating palette bitmap of (TLicensingInterface) : Server mscoree.dll contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, Graphics, mscorlib_TLB, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  Iris_Account_Office_Licensing_COMMajorVersion = 1;
  Iris_Account_Office_Licensing_COMMinorVersion = 0;

  LIBID_Iris_Account_Office_Licensing_COM: TGUID = '{D287AC1D-91D3-444C-8FF2-B689D52E9FA5}';

  DIID_IEliteCom: TGUID = '{5FAF6D4C-590E-426F-9BC5-DE3DD823EA1B}';
  CLASS_LicensingInterface: TGUID = '{28917157-6C6B-4A86-BA99-DB1F6294E749}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IEliteCom = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  LicensingInterface = IEliteCom;


// *********************************************************************//
// DispIntf:  IEliteCom
// Flags:     (4096) Dispatchable
// GUID:      {5FAF6D4C-590E-426F-9BC5-DE3DD823EA1B}
// *********************************************************************//
  IEliteCom = dispinterface
    ['{5FAF6D4C-590E-426F-9BC5-DE3DD823EA1B}']
    function GetSQLServerVersion(const Instance: WideString): WideString; dispid 1610743808;
    function InitialiseLicenceMasterDB: WordBool; dispid 1610743809;
    function InitialiseICEDB: WordBool; dispid 1610743810;
    function SaveSQLServerName(const SQLServerName: WideString): WordBool; dispid 1610743811;
    function SaveWebServiceURL(const WebServiceURL: WideString): WordBool; dispid 1610743812;
    function SaveSQLServerNameForLocalDB(const SQLServerName: WideString; 
                                         const DBLocation: WideString): WordBool; dispid 1610743813;
    function DecodeCDKey(const CDKey: WideString): WideString; dispid 1610743814;
    function GetLicenceCodes(const CDKey: WideString): WideString; dispid 1610743815;
    function DecodeLicenceCode(const CDKeyText: WideString; const LicenceCodeText: WideString): WideString; dispid 1610743816;
    function ClearLicenceLimits: WordBool; dispid 1610743817;
    function AddLicenceLimit(RestrictionID: Integer; LimitID: Integer; const LimitValue: WideString): WordBool; dispid 1610743818;
    function ValidateLicence(const CDKeyText: WideString; const LicenceCode: WideString): WordBool; dispid 1610743819;
    function LicenceLimitsCount: Integer; dispid 1610743820;
    function ActivateFromWS(const CDKey: WideString; CheckStatus: WordBool; const Until_: WideString): WideString; dispid 1610743821;
    function ActivateCDKey(const CDKey: WideString; const ActivationCode: WideString): WideString; dispid 1610743822;
    function InitialiseLocalDatabase: WordBool; dispid 1610743823;
    function GetLicenceRestrictionsWS(const CDKey: WideString; const LicenceCode: WideString): WideString; dispid 1610743824;
  end;

// *********************************************************************//
// The Class CoLicensingInterface provides a Create and CreateRemote method to          
// create instances of the default interface IEliteCom exposed by              
// the CoClass LicensingInterface. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoLicensingInterface = class
    class function Create: IEliteCom;
    class function CreateRemote(const MachineName: string): IEliteCom;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TLicensingInterface
// Help String      : 
// Default Interface: IEliteCom
// Def. Intf. DISP? : Yes
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TLicensingInterfaceProperties= class;
{$ENDIF}
  TLicensingInterface = class(TOleServer)
  private
    FIntf:        IEliteCom;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TLicensingInterfaceProperties;
    function      GetServerProperties: TLicensingInterfaceProperties;
{$ENDIF}
    function      GetDefaultInterface: IEliteCom;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IEliteCom);
    procedure Disconnect; override;
    function GetSQLServerVersion(const Instance: WideString): WideString;
    function InitialiseLicenceMasterDB: WordBool;
    function InitialiseICEDB: WordBool;
    function SaveSQLServerName(const SQLServerName: WideString): WordBool;
    function SaveWebServiceURL(const WebServiceURL: WideString): WordBool;
    function SaveSQLServerNameForLocalDB(const SQLServerName: WideString; 
                                         const DBLocation: WideString): WordBool;
    function DecodeCDKey(const CDKey: WideString): WideString;
    function GetLicenceCodes(const CDKey: WideString): WideString;
    function DecodeLicenceCode(const CDKeyText: WideString; const LicenceCodeText: WideString): WideString;
    function ClearLicenceLimits: WordBool;
    function AddLicenceLimit(RestrictionID: Integer; LimitID: Integer; const LimitValue: WideString): WordBool;
    function ValidateLicence(const CDKeyText: WideString; const LicenceCode: WideString): WordBool;
    function LicenceLimitsCount: Integer;
    function ActivateFromWS(const CDKey: WideString; CheckStatus: WordBool; const Until_: WideString): WideString;
    function ActivateCDKey(const CDKey: WideString; const ActivationCode: WideString): WideString;
    function InitialiseLocalDatabase: WordBool;
    function GetLicenceRestrictionsWS(const CDKey: WideString; const LicenceCode: WideString): WideString;
    property DefaultInterface: IEliteCom read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TLicensingInterfaceProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TLicensingInterface
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TLicensingInterfaceProperties = class(TPersistent)
  private
    FServer:    TLicensingInterface;
    function    GetDefaultInterface: IEliteCom;
    constructor Create(AServer: TLicensingInterface);
  protected
  public
    property DefaultInterface: IEliteCom read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'IRIS';

implementation

uses ComObj;

class function CoLicensingInterface.Create: IEliteCom;
begin
  Result := CreateComObject(CLASS_LicensingInterface) as IEliteCom;
end;

class function CoLicensingInterface.CreateRemote(const MachineName: string): IEliteCom;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_LicensingInterface) as IEliteCom;
end;

procedure TLicensingInterface.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{28917157-6C6B-4A86-BA99-DB1F6294E749}';
    IntfIID:   '{5FAF6D4C-590E-426F-9BC5-DE3DD823EA1B}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TLicensingInterface.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IEliteCom;
  end;
end;

procedure TLicensingInterface.ConnectTo(svrIntf: IEliteCom);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TLicensingInterface.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TLicensingInterface.GetDefaultInterface: IEliteCom;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TLicensingInterface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TLicensingInterfaceProperties.Create(Self);
{$ENDIF}
end;

destructor TLicensingInterface.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TLicensingInterface.GetServerProperties: TLicensingInterfaceProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TLicensingInterface.GetSQLServerVersion(const Instance: WideString): WideString;
begin
  Result := DefaultInterface.GetSQLServerVersion(Instance);
end;

function TLicensingInterface.InitialiseLicenceMasterDB: WordBool;
begin
  Result := DefaultInterface.InitialiseLicenceMasterDB;
end;

function TLicensingInterface.InitialiseICEDB: WordBool;
begin
  Result := DefaultInterface.InitialiseICEDB;
end;

function TLicensingInterface.SaveSQLServerName(const SQLServerName: WideString): WordBool;
begin
  Result := DefaultInterface.SaveSQLServerName(SQLServerName);
end;

function TLicensingInterface.SaveWebServiceURL(const WebServiceURL: WideString): WordBool;
begin
  Result := DefaultInterface.SaveWebServiceURL(WebServiceURL);
end;

function TLicensingInterface.SaveSQLServerNameForLocalDB(const SQLServerName: WideString; 
                                                         const DBLocation: WideString): WordBool;
begin
  Result := DefaultInterface.SaveSQLServerNameForLocalDB(SQLServerName, DBLocation);
end;

function TLicensingInterface.DecodeCDKey(const CDKey: WideString): WideString;
begin
  Result := DefaultInterface.DecodeCDKey(CDKey);
end;

function TLicensingInterface.GetLicenceCodes(const CDKey: WideString): WideString;
begin
  Result := DefaultInterface.GetLicenceCodes(CDKey);
end;

function TLicensingInterface.DecodeLicenceCode(const CDKeyText: WideString; 
                                               const LicenceCodeText: WideString): WideString;
begin
  Result := DefaultInterface.DecodeLicenceCode(CDKeyText, LicenceCodeText);
end;

function TLicensingInterface.ClearLicenceLimits: WordBool;
begin
  Result := DefaultInterface.ClearLicenceLimits;
end;

function TLicensingInterface.AddLicenceLimit(RestrictionID: Integer; LimitID: Integer; 
                                             const LimitValue: WideString): WordBool;
begin
  Result := DefaultInterface.AddLicenceLimit(RestrictionID, LimitID, LimitValue);
end;

function TLicensingInterface.ValidateLicence(const CDKeyText: WideString; 
                                             const LicenceCode: WideString): WordBool;
begin
  Result := DefaultInterface.ValidateLicence(CDKeyText, LicenceCode);
end;

function TLicensingInterface.LicenceLimitsCount: Integer;
begin
  Result := DefaultInterface.LicenceLimitsCount;
end;

function TLicensingInterface.ActivateFromWS(const CDKey: WideString; CheckStatus: WordBool; 
                                            const Until_: WideString): WideString;
begin
  Result := DefaultInterface.ActivateFromWS(CDKey, CheckStatus, Until_);
end;

function TLicensingInterface.ActivateCDKey(const CDKey: WideString; const ActivationCode: WideString): WideString;
begin
  Result := DefaultInterface.ActivateCDKey(CDKey, ActivationCode);
end;

function TLicensingInterface.InitialiseLocalDatabase: WordBool;
begin
  Result := DefaultInterface.InitialiseLocalDatabase;
end;

function TLicensingInterface.GetLicenceRestrictionsWS(const CDKey: WideString; 
                                                      const LicenceCode: WideString): WideString;
begin
  Result := DefaultInterface.GetLicenceRestrictionsWS(CDKey, LicenceCode);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TLicensingInterfaceProperties.Create(AServer: TLicensingInterface);
begin
  inherited Create;
  FServer := AServer;
end;

function TLicensingInterfaceProperties.GetDefaultInterface: IEliteCom;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TLicensingInterface]);
end;

end.
