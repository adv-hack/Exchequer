unit RemotingClientLib_TLB;

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

// PASTLWTR : 1.2
// File generated on 26/01/2006 11:19:51 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Development\IRIS Communications Engine (ICE)\RemotingClientLib\RemotingClientLib\bin\Debug\RemotingClientLib.tlb (1)
// LIBID: {3510A152-41E2-44AE-8739-98B76DED3973}
// LCID: 0
// Helpfile: 
// HelpString: DSR Remoting Client
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v2.0 mscorlib, (C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\mscorlib.tlb)
// Errors:
//   Error creating palette bitmap of (TDSRClient) : List index out of bounds (1)
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
  RemotingClientLibMajorVersion = 1;
  RemotingClientLibMinorVersion = 0;

  LIBID_RemotingClientLib: TGUID = '{3510A152-41E2-44AE-8739-98B76DED3973}';

  IID_IDSRClient: TGUID = '{5AB13540-BD08-42AD-B8A2-9392CF3D0AFE}';
  CLASS_DSRClient: TGUID = '{AF030C57-798F-4A36-B997-E12FD0207680}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSRClient = interface;
  IDSRClientDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSRClient = IDSRClient;


// *********************************************************************//
// Interface: IDSRClient
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AB13540-BD08-42AD-B8A2-9392CF3D0AFE}
// *********************************************************************//
  IDSRClient = interface(IDispatch)
    ['{5AB13540-BD08-42AD-B8A2-9392CF3D0AFE}']
    function DSR_Export(const MachineName: WideString; PortNumber: Integer; pCompany: LongWord; 
                        pGuid: TGUID; const pSubj: WideString; const pFrom: WideString; 
                        const pTo: WideString; const pMsgBody: WideString; 
                        const pParam1: WideString; const pParam2: WideString; pPackageId: LongWord): LongWord; safecall;
    function DSR_Import(const MachineName: WideString; PortNumber: Integer; pCompany: LongWord; 
                        pGuid: TGUID; pPackageId: LongWord): LongWord; safecall;
    function DSR_GGW_PreparePacket(const MachineName: WideString; PortNumber: Integer; 
                                   pCompany: LongWord; pGuid: TGUID; const pSubj: WideString; 
                                   const pFrom: WideString; const pTo: WideString; 
                                   const pMsgBody: WideString; pOrder: Smallint; pTotal: Smallint; 
                                   const pXml: WideString; const pXsl: WideString; 
                                   const pIRMark: WideString): LongWord; safecall;
    function DSR_GGW_SendPacket(const MachineName: WideString; PortNumber: Integer; 
                                pCompany: LongWord; pGuid: TGUID; const pIRMark: WideString): LongWord; safecall;
    function DSR_DeleteInboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                    pCompany: LongWord; pGuid: TGUID): LongWord; safecall;
    function DSR_DeleteOutboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                     pCompany: LongWord; pGuid: TGUID): LongWord; safecall;
    function DSR_GetInboxMessages(const MachineName: WideString; PortNumber: Integer; 
                                  pCompany: LongWord; pPackageId: LongWord; pStatus: Shortint; 
                                  pDate: TDateTime; pMaxRecords: LongWord; out pMessages: OleVariant): LongWord; safecall;
    function DSR_GetOutboxMessages(const MachineName: WideString; PortNumber: Integer; 
                                   pCompany: LongWord; pPackageId: LongWord; pStatus: Shortint; 
                                   pDate: TDateTime; pMaxRecords: LongWord; 
                                   out pMessages: OleVariant): LongWord; safecall;
    function DSR_NewInboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                 pMaxRecords: LongWord; out pMessages: OleVariant): LongWord; safecall;
    function DSR_TotalOutboxMessages(const MachineName: WideString; PortNumber: Integer; 
                                     pCompany: LongWord; out pMsgCount: LongWord): LongWord; safecall;
    function DSR_TranslateErrorCode(const MachineName: WideString; PortNumber: Integer; 
                                    pErrorCode: LongWord): WideString; safecall;
    function DSR_GGW_GetPending(const MachineName: WideString; PortNumber: Integer; 
                                pCompany: LongWord; pDate: TDateTime; pMaxRecords: LongWord; 
                                out pMessages: OleVariant): LongWord; safecall;
    function DSR_ResendOutboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                     pGuid: TGUID): LongWord; safecall;
    function DSR_SetExportPackage(const MachineName: WideString; PortNumber: Integer; 
                                  const pDescription: WideString; pGuid: TGUID; 
                                  const pXml: WideString; const pXsl: WideString; 
                                  const pXsd: WideString; pUserReference: Word): LongWord; safecall;
    function DSR_SetImportPackage(const MachineName: WideString; PortNumber: Integer; 
                                  const pDescription: WideString; pGuid: TGUID; 
                                  const pXml: WideString; const pXsl: WideString; 
                                  const pXsd: WideString; pUserReference: Word): LongWord; safecall;
    function DSR_GetExportPackages(const MachineName: WideString; PortNumber: Integer; 
                                   out pPackage: OleVariant): LongWord; safecall;
    function DSR_GetImportPackages(const MachineName: WideString; PortNumber: Integer; 
                                   out pPackage: OleVariant): LongWord; safecall;
    function DSR_DeleteExportPackage(const MachineName: WideString; PortNumber: Integer; 
                                     pID: LongWord): LongWord; safecall;
    function DSR_DeleteImportPackage(const MachineName: WideString; PortNumber: Integer; 
                                     pID: LongWord): LongWord; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDSRClientDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5AB13540-BD08-42AD-B8A2-9392CF3D0AFE}
// *********************************************************************//
  IDSRClientDisp = dispinterface
    ['{5AB13540-BD08-42AD-B8A2-9392CF3D0AFE}']
    function DSR_Export(const MachineName: WideString; PortNumber: Integer; pCompany: LongWord; 
                        pGuid: {??TGUID}OleVariant; const pSubj: WideString; 
                        const pFrom: WideString; const pTo: WideString; const pMsgBody: WideString; 
                        const pParam1: WideString; const pParam2: WideString; pPackageId: LongWord): LongWord; dispid 1610743808;
    function DSR_Import(const MachineName: WideString; PortNumber: Integer; pCompany: LongWord; 
                        pGuid: {??TGUID}OleVariant; pPackageId: LongWord): LongWord; dispid 1610743809;
    function DSR_GGW_PreparePacket(const MachineName: WideString; PortNumber: Integer; 
                                   pCompany: LongWord; pGuid: {??TGUID}OleVariant; 
                                   const pSubj: WideString; const pFrom: WideString; 
                                   const pTo: WideString; const pMsgBody: WideString; 
                                   pOrder: Smallint; pTotal: Smallint; const pXml: WideString; 
                                   const pXsl: WideString; const pIRMark: WideString): LongWord; dispid 1610743810;
    function DSR_GGW_SendPacket(const MachineName: WideString; PortNumber: Integer; 
                                pCompany: LongWord; pGuid: {??TGUID}OleVariant; 
                                const pIRMark: WideString): LongWord; dispid 1610743811;
    function DSR_DeleteInboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                    pCompany: LongWord; pGuid: {??TGUID}OleVariant): LongWord; dispid 1610743812;
    function DSR_DeleteOutboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                     pCompany: LongWord; pGuid: {??TGUID}OleVariant): LongWord; dispid 1610743813;
    function DSR_GetInboxMessages(const MachineName: WideString; PortNumber: Integer; 
                                  pCompany: LongWord; pPackageId: LongWord; 
                                  pStatus: {??Shortint}OleVariant; pDate: TDateTime; 
                                  pMaxRecords: LongWord; out pMessages: OleVariant): LongWord; dispid 1610743814;
    function DSR_GetOutboxMessages(const MachineName: WideString; PortNumber: Integer; 
                                   pCompany: LongWord; pPackageId: LongWord; 
                                   pStatus: {??Shortint}OleVariant; pDate: TDateTime; 
                                   pMaxRecords: LongWord; out pMessages: OleVariant): LongWord; dispid 1610743815;
    function DSR_NewInboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                 pMaxRecords: LongWord; out pMessages: OleVariant): LongWord; dispid 1610743816;
    function DSR_TotalOutboxMessages(const MachineName: WideString; PortNumber: Integer; 
                                     pCompany: LongWord; out pMsgCount: LongWord): LongWord; dispid 1610743817;
    function DSR_TranslateErrorCode(const MachineName: WideString; PortNumber: Integer; 
                                    pErrorCode: LongWord): WideString; dispid 1610743818;
    function DSR_GGW_GetPending(const MachineName: WideString; PortNumber: Integer; 
                                pCompany: LongWord; pDate: TDateTime; pMaxRecords: LongWord; 
                                out pMessages: OleVariant): LongWord; dispid 1610743819;
    function DSR_ResendOutboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                     pGuid: {??TGUID}OleVariant): LongWord; dispid 1610743820;
    function DSR_SetExportPackage(const MachineName: WideString; PortNumber: Integer; 
                                  const pDescription: WideString; pGuid: {??TGUID}OleVariant; 
                                  const pXml: WideString; const pXsl: WideString; 
                                  const pXsd: WideString; pUserReference: {??Word}OleVariant): LongWord; dispid 1610743821;
    function DSR_SetImportPackage(const MachineName: WideString; PortNumber: Integer; 
                                  const pDescription: WideString; pGuid: {??TGUID}OleVariant; 
                                  const pXml: WideString; const pXsl: WideString; 
                                  const pXsd: WideString; pUserReference: {??Word}OleVariant): LongWord; dispid 1610743822;
    function DSR_GetExportPackages(const MachineName: WideString; PortNumber: Integer; 
                                   out pPackage: OleVariant): LongWord; dispid 1610743823;
    function DSR_GetImportPackages(const MachineName: WideString; PortNumber: Integer; 
                                   out pPackage: OleVariant): LongWord; dispid 1610743824;
    function DSR_DeleteExportPackage(const MachineName: WideString; PortNumber: Integer; 
                                     pID: LongWord): LongWord; dispid 1610743825;
    function DSR_DeleteImportPackage(const MachineName: WideString; PortNumber: Integer; 
                                     pID: LongWord): LongWord; dispid 1610743826;
  end;

// *********************************************************************//
// The Class CoDSRClient provides a Create and CreateRemote method to          
// create instances of the default interface IDSRClient exposed by              
// the CoClass DSRClient. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRClient = class
    class function Create: IDSRClient;
    class function CreateRemote(const MachineName: string): IDSRClient;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDSRClient
// Help String      : 
// Default Interface: IDSRClient
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDSRClientProperties= class;
{$ENDIF}
  TDSRClient = class(TOleServer)
  private
    FIntf:        IDSRClient;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDSRClientProperties;
    function      GetServerProperties: TDSRClientProperties;
{$ENDIF}
    function      GetDefaultInterface: IDSRClient;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDSRClient);
    procedure Disconnect; override;
    function DSR_Export(const MachineName: WideString; PortNumber: Integer; pCompany: LongWord; 
                        pGuid: TGUID; const pSubj: WideString; const pFrom: WideString; 
                        const pTo: WideString; const pMsgBody: WideString; 
                        const pParam1: WideString; const pParam2: WideString; pPackageId: LongWord): LongWord;
    function DSR_Import(const MachineName: WideString; PortNumber: Integer; pCompany: LongWord; 
                        pGuid: TGUID; pPackageId: LongWord): LongWord;
    function DSR_GGW_PreparePacket(const MachineName: WideString; PortNumber: Integer; 
                                   pCompany: LongWord; pGuid: TGUID; const pSubj: WideString; 
                                   const pFrom: WideString; const pTo: WideString; 
                                   const pMsgBody: WideString; pOrder: Smallint; pTotal: Smallint; 
                                   const pXml: WideString; const pXsl: WideString; 
                                   const pIRMark: WideString): LongWord;
    function DSR_GGW_SendPacket(const MachineName: WideString; PortNumber: Integer; 
                                pCompany: LongWord; pGuid: TGUID; const pIRMark: WideString): LongWord;
    function DSR_DeleteInboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                    pCompany: LongWord; pGuid: TGUID): LongWord;
    function DSR_DeleteOutboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                     pCompany: LongWord; pGuid: TGUID): LongWord;
    function DSR_GetInboxMessages(const MachineName: WideString; PortNumber: Integer; 
                                  pCompany: LongWord; pPackageId: LongWord; pStatus: Shortint; 
                                  pDate: TDateTime; pMaxRecords: LongWord; out pMessages: OleVariant): LongWord;
    function DSR_GetOutboxMessages(const MachineName: WideString; PortNumber: Integer; 
                                   pCompany: LongWord; pPackageId: LongWord; pStatus: Shortint; 
                                   pDate: TDateTime; pMaxRecords: LongWord; 
                                   out pMessages: OleVariant): LongWord;
    function DSR_NewInboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                 pMaxRecords: LongWord; out pMessages: OleVariant): LongWord;
    function DSR_TotalOutboxMessages(const MachineName: WideString; PortNumber: Integer; 
                                     pCompany: LongWord; out pMsgCount: LongWord): LongWord;
    function DSR_TranslateErrorCode(const MachineName: WideString; PortNumber: Integer; 
                                    pErrorCode: LongWord): WideString;
    function DSR_GGW_GetPending(const MachineName: WideString; PortNumber: Integer; 
                                pCompany: LongWord; pDate: TDateTime; pMaxRecords: LongWord; 
                                out pMessages: OleVariant): LongWord;
    function DSR_ResendOutboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                     pGuid: TGUID): LongWord;
    function DSR_SetExportPackage(const MachineName: WideString; PortNumber: Integer; 
                                  const pDescription: WideString; pGuid: TGUID; 
                                  const pXml: WideString; const pXsl: WideString; 
                                  const pXsd: WideString; pUserReference: Word): LongWord;
    function DSR_SetImportPackage(const MachineName: WideString; PortNumber: Integer; 
                                  const pDescription: WideString; pGuid: TGUID; 
                                  const pXml: WideString; const pXsl: WideString; 
                                  const pXsd: WideString; pUserReference: Word): LongWord;
    function DSR_GetExportPackages(const MachineName: WideString; PortNumber: Integer; 
                                   out pPackage: OleVariant): LongWord;
    function DSR_GetImportPackages(const MachineName: WideString; PortNumber: Integer; 
                                   out pPackage: OleVariant): LongWord;
    function DSR_DeleteExportPackage(const MachineName: WideString; PortNumber: Integer; 
                                     pID: LongWord): LongWord;
    function DSR_DeleteImportPackage(const MachineName: WideString; PortNumber: Integer; 
                                     pID: LongWord): LongWord;
    property DefaultInterface: IDSRClient read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDSRClientProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TDSRClient
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TDSRClientProperties = class(TPersistent)
  private
    FServer:    TDSRClient;
    function    GetDefaultInterface: IDSRClient;
    constructor Create(AServer: TDSRClient);
  protected
  public
    property DefaultInterface: IDSRClient read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = '(none)';

  dtlOcxPage = '(none)';

implementation

uses ComObj;

class function CoDSRClient.Create: IDSRClient;
begin
  Result := CreateComObject(CLASS_DSRClient) as IDSRClient;
end;

class function CoDSRClient.CreateRemote(const MachineName: string): IDSRClient;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRClient) as IDSRClient;
end;

procedure TDSRClient.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{AF030C57-798F-4A36-B997-E12FD0207680}';
    IntfIID:   '{5AB13540-BD08-42AD-B8A2-9392CF3D0AFE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDSRClient.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDSRClient;
  end;
end;

procedure TDSRClient.ConnectTo(svrIntf: IDSRClient);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDSRClient.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDSRClient.GetDefaultInterface: IDSRClient;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TDSRClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDSRClientProperties.Create(Self);
{$ENDIF}
end;

destructor TDSRClient.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDSRClient.GetServerProperties: TDSRClientProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TDSRClient.DSR_Export(const MachineName: WideString; PortNumber: Integer; 
                               pCompany: LongWord; pGuid: TGUID; const pSubj: WideString; 
                               const pFrom: WideString; const pTo: WideString; 
                               const pMsgBody: WideString; const pParam1: WideString; 
                               const pParam2: WideString; pPackageId: LongWord): LongWord;
begin
  Result := DefaultInterface.DSR_Export(MachineName, PortNumber, pCompany, pGuid, pSubj, pFrom, 
                                        pTo, pMsgBody, pParam1, pParam2, pPackageId);
end;

function TDSRClient.DSR_Import(const MachineName: WideString; PortNumber: Integer; 
                               pCompany: LongWord; pGuid: TGUID; pPackageId: LongWord): LongWord;
begin
  Result := DefaultInterface.DSR_Import(MachineName, PortNumber, pCompany, pGuid, pPackageId);
end;

function TDSRClient.DSR_GGW_PreparePacket(const MachineName: WideString; PortNumber: Integer; 
                                          pCompany: LongWord; pGuid: TGUID; 
                                          const pSubj: WideString; const pFrom: WideString; 
                                          const pTo: WideString; const pMsgBody: WideString; 
                                          pOrder: Smallint; pTotal: Smallint; 
                                          const pXml: WideString; const pXsl: WideString; 
                                          const pIRMark: WideString): LongWord;
begin
  Result := DefaultInterface.DSR_GGW_PreparePacket(MachineName, PortNumber, pCompany, pGuid, pSubj, 
                                                   pFrom, pTo, pMsgBody, pOrder, pTotal, pXml, 
                                                   pXsl, pIRMark);
end;

function TDSRClient.DSR_GGW_SendPacket(const MachineName: WideString; PortNumber: Integer; 
                                       pCompany: LongWord; pGuid: TGUID; const pIRMark: WideString): LongWord;
begin
  Result := DefaultInterface.DSR_GGW_SendPacket(MachineName, PortNumber, pCompany, pGuid, pIRMark);
end;

function TDSRClient.DSR_DeleteInboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                           pCompany: LongWord; pGuid: TGUID): LongWord;
begin
  Result := DefaultInterface.DSR_DeleteInboxMessage(MachineName, PortNumber, pCompany, pGuid);
end;

function TDSRClient.DSR_DeleteOutboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                            pCompany: LongWord; pGuid: TGUID): LongWord;
begin
  Result := DefaultInterface.DSR_DeleteOutboxMessage(MachineName, PortNumber, pCompany, pGuid);
end;

function TDSRClient.DSR_GetInboxMessages(const MachineName: WideString; PortNumber: Integer; 
                                         pCompany: LongWord; pPackageId: LongWord; 
                                         pStatus: Shortint; pDate: TDateTime; 
                                         pMaxRecords: LongWord; out pMessages: OleVariant): LongWord;
begin
  Result := DefaultInterface.DSR_GetInboxMessages(MachineName, PortNumber, pCompany, pPackageId, 
                                                  pStatus, pDate, pMaxRecords, pMessages);
end;

function TDSRClient.DSR_GetOutboxMessages(const MachineName: WideString; PortNumber: Integer; 
                                          pCompany: LongWord; pPackageId: LongWord; 
                                          pStatus: Shortint; pDate: TDateTime; 
                                          pMaxRecords: LongWord; out pMessages: OleVariant): LongWord;
begin
  Result := DefaultInterface.DSR_GetOutboxMessages(MachineName, PortNumber, pCompany, pPackageId, 
                                                   pStatus, pDate, pMaxRecords, pMessages);
end;

function TDSRClient.DSR_NewInboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                        pMaxRecords: LongWord; out pMessages: OleVariant): LongWord;
begin
  Result := DefaultInterface.DSR_NewInboxMessage(MachineName, PortNumber, pMaxRecords, pMessages);
end;

function TDSRClient.DSR_TotalOutboxMessages(const MachineName: WideString; PortNumber: Integer; 
                                            pCompany: LongWord; out pMsgCount: LongWord): LongWord;
begin
  Result := DefaultInterface.DSR_TotalOutboxMessages(MachineName, PortNumber, pCompany, pMsgCount);
end;

function TDSRClient.DSR_TranslateErrorCode(const MachineName: WideString; PortNumber: Integer; 
                                           pErrorCode: LongWord): WideString;
begin
  Result := DefaultInterface.DSR_TranslateErrorCode(MachineName, PortNumber, pErrorCode);
end;

function TDSRClient.DSR_GGW_GetPending(const MachineName: WideString; PortNumber: Integer; 
                                       pCompany: LongWord; pDate: TDateTime; pMaxRecords: LongWord; 
                                       out pMessages: OleVariant): LongWord;
begin
  Result := DefaultInterface.DSR_GGW_GetPending(MachineName, PortNumber, pCompany, pDate, 
                                                pMaxRecords, pMessages);
end;

function TDSRClient.DSR_ResendOutboxMessage(const MachineName: WideString; PortNumber: Integer; 
                                            pGuid: TGUID): LongWord;
begin
  Result := DefaultInterface.DSR_ResendOutboxMessage(MachineName, PortNumber, pGuid);
end;

function TDSRClient.DSR_SetExportPackage(const MachineName: WideString; PortNumber: Integer; 
                                         const pDescription: WideString; pGuid: TGUID; 
                                         const pXml: WideString; const pXsl: WideString; 
                                         const pXsd: WideString; pUserReference: Word): LongWord;
begin
  Result := DefaultInterface.DSR_SetExportPackage(MachineName, PortNumber, pDescription, pGuid, 
                                                  pXml, pXsl, pXsd, pUserReference);
end;

function TDSRClient.DSR_SetImportPackage(const MachineName: WideString; PortNumber: Integer; 
                                         const pDescription: WideString; pGuid: TGUID; 
                                         const pXml: WideString; const pXsl: WideString; 
                                         const pXsd: WideString; pUserReference: Word): LongWord;
begin
  Result := DefaultInterface.DSR_SetImportPackage(MachineName, PortNumber, pDescription, pGuid, 
                                                  pXml, pXsl, pXsd, pUserReference);
end;

function TDSRClient.DSR_GetExportPackages(const MachineName: WideString; PortNumber: Integer; 
                                          out pPackage: OleVariant): LongWord;
begin
  Result := DefaultInterface.DSR_GetExportPackages(MachineName, PortNumber, pPackage);
end;

function TDSRClient.DSR_GetImportPackages(const MachineName: WideString; PortNumber: Integer; 
                                          out pPackage: OleVariant): LongWord;
begin
  Result := DefaultInterface.DSR_GetImportPackages(MachineName, PortNumber, pPackage);
end;

function TDSRClient.DSR_DeleteExportPackage(const MachineName: WideString; PortNumber: Integer; 
                                            pID: LongWord): LongWord;
begin
  Result := DefaultInterface.DSR_DeleteExportPackage(MachineName, PortNumber, pID);
end;

function TDSRClient.DSR_DeleteImportPackage(const MachineName: WideString; PortNumber: Integer; 
                                            pID: LongWord): LongWord;
begin
  Result := DefaultInterface.DSR_DeleteImportPackage(MachineName, PortNumber, pID);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDSRClientProperties.Create(AServer: TDSRClient);
begin
  inherited Create;
  FServer := AServer;
end;

function TDSRClientProperties.GetDefaultInterface: IDSRClient;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TDSRClient]);
end;

end.
