unit InternetFiling_TLB;

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
// File generated on 02/11/2006 11:25:05 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Projects\CIS\FBI Components\FBI Release 1.0.5\InternetFiling.tlb (1)
// LIBID: {67C620EB-3F2D-46F6-BC15-C554CABF73EE}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v2.0 mscorlib, (C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\mscorlib.tlb)
//   (3) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// Errors:
//   Hint: Parameter 'Class' of IPosting.Submit changed to 'Class_'
//   Hint: Parameter 'Class' of IPosting.BeginPolling changed to 'Class_'
//   Hint: Parameter 'Class' of IPosting.BeginPolling_2 changed to 'Class_'
//   Hint: Parameter 'Class' of IPosting.Delete changed to 'Class_'
//   Hint: Parameter 'Class' of _Posting.Submit changed to 'Class_'
//   Hint: Parameter 'Class' of _Posting.BeginPolling changed to 'Class_'
//   Hint: Parameter 'Class' of _Posting.BeginPolling_2 changed to 'Class_'
//   Hint: Parameter 'Class' of _Posting.Delete changed to 'Class_'
//   Hint: Parameter 'Class' of _Posting.BeginPolling_3 changed to 'Class_'
//   Hint: Parameter 'Class' of _Posting.RequestList changed to 'Class_'
//   Error creating palette bitmap of (TPosting) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TCallbackContainer) : Server mscoree.dll contains no icons
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
  InternetFilingMajorVersion = 8;
  InternetFilingMinorVersion = 7;

  LIBID_InternetFiling: TGUID = '{67C620EB-3F2D-46F6-BC15-C554CABF73EE}';

  DIID_IPosting: TGUID = '{9C6E465B-E15D-4E3C-A65B-E777F89684E7}';
  IID__Posting: TGUID = '{2E3E748B-94D5-39DE-BDEE-E6BB362B9293}';
  IID_ICallback: TGUID = '{2BB4A16E-6EA5-4837-80C1-B01DD4345ECD}';
  IID__CallbackContainer: TGUID = '{D3D98F2A-0DAB-3DEF-AA51-7CC21D4EAB0A}';
  CLASS_Posting: TGUID = '{54678DD0-6780-4A74-8786-0CE701FD85A7}';
  CLASS_CallbackContainer: TGUID = '{7C7D8AA9-0B4F-4F0F-A5C3-68E1657AF4C5}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPosting = dispinterface;
  _Posting = interface;
  _PostingDisp = dispinterface;
  ICallback = interface;
  ICallbackDisp = dispinterface;
  _CallbackContainer = interface;
  _CallbackContainerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Posting = _Posting;
  CallbackContainer = _CallbackContainer;


// *********************************************************************//
// DispIntf:  IPosting
// Flags:     (4096) Dispatchable
// GUID:      {9C6E465B-E15D-4E3C-A65B-E777F89684E7}
// *********************************************************************//
  IPosting = dispinterface
    ['{9C6E465B-E15D-4E3C-A65B-E777F89684E7}']
    function AddIRMark(var DocumentXml: WideString; SubmissionType: Integer): WideString; dispid 1610743808;
    function Submit(const Class_: WideString; UsesTestGateway: WordBool; 
                    const DocumentXml: WideString): WideString; dispid 1610743809;
    procedure Query(QueryNum: Integer); dispid 1610743810;
    procedure SetConfiguration(const GatewayUrl: WideString); dispid 1610743811;
    function BeginPolling(const callback: ICallback; const CorrelationID: WideString; 
                          const Class_: WideString; UsesTestGateway: WordBool; 
                          const GovTalkUrl: WideString): WideString; dispid 1610743812;
    function BeginPolling_2(const callback: ICallback; const CorrelationID: WideString; 
                            const Class_: WideString; UsesTestGateway: WordBool): WideString; dispid 1610743813;
    function Delete(const CorrelationID: WideString; const Class_: WideString; 
                    UsesTestGateway: WordBool; const GovTalkUrl: WideString): WideString; dispid 1610743814;
    procedure EndPolling(const PollerGuid: WideString); dispid 1610743815;
    procedure RedirectPolling(const PollingGuid: WideString; const Redirect: WideString); dispid 1610743816;
  end;

// *********************************************************************//
// Interface: _Posting
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2E3E748B-94D5-39DE-BDEE-E6BB362B9293}
// *********************************************************************//
  _Posting = interface(IDispatch)
    ['{2E3E748B-94D5-39DE-BDEE-E6BB362B9293}']
    function Get_ToString: WideString; safecall;
    function Equals(obj: OleVariant): WordBool; safecall;
    function GetHashCode: Integer; safecall;
    function GetType: _Type; safecall;
    function AddIRMark(var DocumentXml: WideString; SubmissionType: Integer): WideString; safecall;
    function Submit(const Class_: WideString; UsesTestGateway: WordBool; 
                    const DocumentXml: WideString): WideString; safecall;
    procedure Query(QueryNum: Integer); safecall;
    procedure SetConfiguration(const GatewayUrl: WideString); safecall;
    function BeginPolling(const callback: ICallback; const CorrelationID: WideString; 
                          const Class_: WideString; UsesTestGateway: WordBool; 
                          const GovTalkUrl: WideString): WideString; safecall;
    function BeginPolling_2(const callback: ICallback; const CorrelationID: WideString; 
                            const Class_: WideString; UsesTestGateway: WordBool): WideString; safecall;
    function Delete(const CorrelationID: WideString; const Class_: WideString; 
                    UsesTestGateway: WordBool; const GovTalkUrl: WideString): WideString; safecall;
    procedure EndPolling(const PollerGuid: WideString); safecall;
    procedure RedirectPolling(const PollingGuid: WideString; const Redirect: WideString); safecall;
    function BeginPolling_3(const callback: ICallback; const CorrelationID: WideString; 
                            const Class_: WideString; UsesTestGateway: WordBool; 
                            const GovTalkUrl: WideString; PollingIntervalWholeSeconds: Integer): WideString; safecall;
    function RequestList(const CorrelationID: WideString; const Class_: WideString; 
                         UsesTestGateway: WordBool; const GovTalkUrl: WideString): IUnknown; safecall;
    property ToString: WideString read Get_ToString;
  end;

// *********************************************************************//
// DispIntf:  _PostingDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2E3E748B-94D5-39DE-BDEE-E6BB362B9293}
// *********************************************************************//
  _PostingDisp = dispinterface
    ['{2E3E748B-94D5-39DE-BDEE-E6BB362B9293}']
    property ToString: WideString readonly dispid 0;
    function Equals(obj: OleVariant): WordBool; dispid 1610743809;
    function GetHashCode: Integer; dispid 1610743810;
    function GetType: _Type; dispid 1610743811;
    function AddIRMark(var DocumentXml: WideString; SubmissionType: Integer): WideString; dispid 1610743812;
    function Submit(const Class_: WideString; UsesTestGateway: WordBool; 
                    const DocumentXml: WideString): WideString; dispid 1610743813;
    procedure Query(QueryNum: Integer); dispid 1610743814;
    procedure SetConfiguration(const GatewayUrl: WideString); dispid 1610743815;
    function BeginPolling(const callback: ICallback; const CorrelationID: WideString; 
                          const Class_: WideString; UsesTestGateway: WordBool; 
                          const GovTalkUrl: WideString): WideString; dispid 1610743816;
    function BeginPolling_2(const callback: ICallback; const CorrelationID: WideString; 
                            const Class_: WideString; UsesTestGateway: WordBool): WideString; dispid 1610743817;
    function Delete(const CorrelationID: WideString; const Class_: WideString; 
                    UsesTestGateway: WordBool; const GovTalkUrl: WideString): WideString; dispid 1610743818;
    procedure EndPolling(const PollerGuid: WideString); dispid 1610743819;
    procedure RedirectPolling(const PollingGuid: WideString; const Redirect: WideString); dispid 1610743820;
    function BeginPolling_3(const callback: ICallback; const CorrelationID: WideString; 
                            const Class_: WideString; UsesTestGateway: WordBool; 
                            const GovTalkUrl: WideString; PollingIntervalWholeSeconds: Integer): WideString; dispid 1610743821;
    function RequestList(const CorrelationID: WideString; const Class_: WideString; 
                         UsesTestGateway: WordBool; const GovTalkUrl: WideString): IUnknown; dispid 1610743822;
  end;

// *********************************************************************//
// Interface: ICallback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2BB4A16E-6EA5-4837-80C1-B01DD4345ECD}
// *********************************************************************//
  ICallback = interface(IDispatch)
    ['{2BB4A16E-6EA5-4837-80C1-B01DD4345ECD}']
    procedure Response(const message: WideString); safecall;
    procedure _Unused; safecall;
  end;

// *********************************************************************//
// DispIntf:  ICallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2BB4A16E-6EA5-4837-80C1-B01DD4345ECD}
// *********************************************************************//
  ICallbackDisp = dispinterface
    ['{2BB4A16E-6EA5-4837-80C1-B01DD4345ECD}']
    procedure Response(const message: WideString); dispid 1610743808;
    procedure _Unused; dispid 1610743809;
  end;

// *********************************************************************//
// Interface: _CallbackContainer
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {D3D98F2A-0DAB-3DEF-AA51-7CC21D4EAB0A}
// *********************************************************************//
  _CallbackContainer = interface(IDispatch)
    ['{D3D98F2A-0DAB-3DEF-AA51-7CC21D4EAB0A}']
    function Get_ToString: WideString; safecall;
    function Equals(obj: OleVariant): WordBool; safecall;
    function GetHashCode: Integer; safecall;
    function GetType: _Type; safecall;
    procedure Response(const message: WideString); safecall;
    property ToString: WideString read Get_ToString;
  end;

// *********************************************************************//
// DispIntf:  _CallbackContainerDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {D3D98F2A-0DAB-3DEF-AA51-7CC21D4EAB0A}
// *********************************************************************//
  _CallbackContainerDisp = dispinterface
    ['{D3D98F2A-0DAB-3DEF-AA51-7CC21D4EAB0A}']
    property ToString: WideString readonly dispid 0;
    function Equals(obj: OleVariant): WordBool; dispid 1610743809;
    function GetHashCode: Integer; dispid 1610743810;
    function GetType: _Type; dispid 1610743811;
    procedure Response(const message: WideString); dispid 1610743812;
  end;

// *********************************************************************//
// The Class CoPosting provides a Create and CreateRemote method to          
// create instances of the default interface _Posting exposed by              
// the CoClass Posting. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPosting = class
    class function Create: _Posting;
    class function CreateRemote(const MachineName: string): _Posting;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TPosting
// Help String      : 
// Default Interface: _Posting
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TPostingProperties= class;
{$ENDIF}
  TPosting = class(TOleServer)
  private
    FIntf:        _Posting;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TPostingProperties;
    function      GetServerProperties: TPostingProperties;
{$ENDIF}
    function      GetDefaultInterface: _Posting;
  protected
    procedure InitServerData; override;
    function Get_ToString: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _Posting);
    procedure Disconnect; override;
    function Equals(obj: OleVariant): WordBool;
    function GetHashCode: Integer;
    function GetType: _Type;
    function AddIRMark(var DocumentXml: WideString; SubmissionType: Integer): WideString;
    function Submit(const Class_: WideString; UsesTestGateway: WordBool; 
                    const DocumentXml: WideString): WideString;
    procedure Query(QueryNum: Integer);
    procedure SetConfiguration(const GatewayUrl: WideString);
    function BeginPolling(const callback: ICallback; const CorrelationID: WideString; 
                          const Class_: WideString; UsesTestGateway: WordBool; 
                          const GovTalkUrl: WideString): WideString;
    function BeginPolling_2(const callback: ICallback; const CorrelationID: WideString; 
                            const Class_: WideString; UsesTestGateway: WordBool): WideString;
    function Delete(const CorrelationID: WideString; const Class_: WideString; 
                    UsesTestGateway: WordBool; const GovTalkUrl: WideString): WideString;
    procedure EndPolling(const PollerGuid: WideString);
    procedure RedirectPolling(const PollingGuid: WideString; const Redirect: WideString);
    function BeginPolling_3(const callback: ICallback; const CorrelationID: WideString; 
                            const Class_: WideString; UsesTestGateway: WordBool; 
                            const GovTalkUrl: WideString; PollingIntervalWholeSeconds: Integer): WideString;
    function RequestList(const CorrelationID: WideString; const Class_: WideString; 
                         UsesTestGateway: WordBool; const GovTalkUrl: WideString): IUnknown;
    property DefaultInterface: _Posting read GetDefaultInterface;
    property ToString: WideString read Get_ToString;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TPostingProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TPosting
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TPostingProperties = class(TPersistent)
  private
    FServer:    TPosting;
    function    GetDefaultInterface: _Posting;
    constructor Create(AServer: TPosting);
  protected
    function Get_ToString: WideString;
  public
    property DefaultInterface: _Posting read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoCallbackContainer provides a Create and CreateRemote method to          
// create instances of the default interface _CallbackContainer exposed by              
// the CoClass CallbackContainer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCallbackContainer = class
    class function Create: _CallbackContainer;
    class function CreateRemote(const MachineName: string): _CallbackContainer;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TCallbackContainer
// Help String      : 
// Default Interface: _CallbackContainer
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TCallbackContainerProperties= class;
{$ENDIF}
  TCallbackContainer = class(TOleServer)
  private
    FIntf:        _CallbackContainer;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TCallbackContainerProperties;
    function      GetServerProperties: TCallbackContainerProperties;
{$ENDIF}
    function      GetDefaultInterface: _CallbackContainer;
  protected
    procedure InitServerData; override;
    function Get_ToString: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _CallbackContainer);
    procedure Disconnect; override;
    function Equals(obj: OleVariant): WordBool;
    function GetHashCode: Integer;
    function GetType: _Type;
    procedure Response(const message: WideString);
    property DefaultInterface: _CallbackContainer read GetDefaultInterface;
    property ToString: WideString read Get_ToString;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TCallbackContainerProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TCallbackContainer
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TCallbackContainerProperties = class(TPersistent)
  private
    FServer:    TCallbackContainer;
    function    GetDefaultInterface: _CallbackContainer;
    constructor Create(AServer: TCallbackContainer);
  protected
    function Get_ToString: WideString;
  public
    property DefaultInterface: _CallbackContainer read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

implementation

uses ComObj;

class function CoPosting.Create: _Posting;
begin
  Result := CreateComObject(CLASS_Posting) as _Posting;
end;

class function CoPosting.CreateRemote(const MachineName: string): _Posting;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Posting) as _Posting;
end;

procedure TPosting.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{54678DD0-6780-4A74-8786-0CE701FD85A7}';
    IntfIID:   '{2E3E748B-94D5-39DE-BDEE-E6BB362B9293}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TPosting.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _Posting;
  end;
end;

procedure TPosting.ConnectTo(svrIntf: _Posting);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TPosting.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TPosting.GetDefaultInterface: _Posting;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TPosting.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TPostingProperties.Create(Self);
{$ENDIF}
end;

destructor TPosting.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TPosting.GetServerProperties: TPostingProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TPosting.Get_ToString: WideString;
begin
    Result := DefaultInterface.ToString;
end;

function TPosting.Equals(obj: OleVariant): WordBool;
begin
  Result := DefaultInterface.Equals(obj);
end;

function TPosting.GetHashCode: Integer;
begin
  Result := DefaultInterface.GetHashCode;
end;

function TPosting.GetType: _Type;
begin
  Result := DefaultInterface.GetType;
end;

function TPosting.AddIRMark(var DocumentXml: WideString; SubmissionType: Integer): WideString;
begin
  Result := DefaultInterface.AddIRMark(DocumentXml, SubmissionType);
end;

function TPosting.Submit(const Class_: WideString; UsesTestGateway: WordBool; 
                         const DocumentXml: WideString): WideString;
begin
  Result := DefaultInterface.Submit(Class_, UsesTestGateway, DocumentXml);
end;

procedure TPosting.Query(QueryNum: Integer);
begin
  DefaultInterface.Query(QueryNum);
end;

procedure TPosting.SetConfiguration(const GatewayUrl: WideString);
begin
  DefaultInterface.SetConfiguration(GatewayUrl);
end;

function TPosting.BeginPolling(const callback: ICallback; const CorrelationID: WideString; 
                               const Class_: WideString; UsesTestGateway: WordBool; 
                               const GovTalkUrl: WideString): WideString;
begin
  Result := DefaultInterface.BeginPolling(callback, CorrelationID, Class_, UsesTestGateway, 
                                          GovTalkUrl);
end;

function TPosting.BeginPolling_2(const callback: ICallback; const CorrelationID: WideString; 
                                 const Class_: WideString; UsesTestGateway: WordBool): WideString;
begin
  Result := DefaultInterface.BeginPolling_2(callback, CorrelationID, Class_, UsesTestGateway);
end;

function TPosting.Delete(const CorrelationID: WideString; const Class_: WideString; 
                         UsesTestGateway: WordBool; const GovTalkUrl: WideString): WideString;
begin
  Result := DefaultInterface.Delete(CorrelationID, Class_, UsesTestGateway, GovTalkUrl);
end;

procedure TPosting.EndPolling(const PollerGuid: WideString);
begin
  DefaultInterface.EndPolling(PollerGuid);
end;

procedure TPosting.RedirectPolling(const PollingGuid: WideString; const Redirect: WideString);
begin
  DefaultInterface.RedirectPolling(PollingGuid, Redirect);
end;

function TPosting.BeginPolling_3(const callback: ICallback; const CorrelationID: WideString; 
                                 const Class_: WideString; UsesTestGateway: WordBool; 
                                 const GovTalkUrl: WideString; PollingIntervalWholeSeconds: Integer): WideString;
begin
  Result := DefaultInterface.BeginPolling_3(callback, CorrelationID, Class_, UsesTestGateway, 
                                            GovTalkUrl, PollingIntervalWholeSeconds);
end;

function TPosting.RequestList(const CorrelationID: WideString; const Class_: WideString; 
                              UsesTestGateway: WordBool; const GovTalkUrl: WideString): IUnknown;
begin
  Result := DefaultInterface.RequestList(CorrelationID, Class_, UsesTestGateway, GovTalkUrl);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TPostingProperties.Create(AServer: TPosting);
begin
  inherited Create;
  FServer := AServer;
end;

function TPostingProperties.GetDefaultInterface: _Posting;
begin
  Result := FServer.DefaultInterface;
end;

function TPostingProperties.Get_ToString: WideString;
begin
    Result := DefaultInterface.ToString;
end;

{$ENDIF}

class function CoCallbackContainer.Create: _CallbackContainer;
begin
  Result := CreateComObject(CLASS_CallbackContainer) as _CallbackContainer;
end;

class function CoCallbackContainer.CreateRemote(const MachineName: string): _CallbackContainer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CallbackContainer) as _CallbackContainer;
end;

procedure TCallbackContainer.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{7C7D8AA9-0B4F-4F0F-A5C3-68E1657AF4C5}';
    IntfIID:   '{D3D98F2A-0DAB-3DEF-AA51-7CC21D4EAB0A}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCallbackContainer.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _CallbackContainer;
  end;
end;

procedure TCallbackContainer.ConnectTo(svrIntf: _CallbackContainer);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCallbackContainer.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCallbackContainer.GetDefaultInterface: _CallbackContainer;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TCallbackContainer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TCallbackContainerProperties.Create(Self);
{$ENDIF}
end;

destructor TCallbackContainer.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TCallbackContainer.GetServerProperties: TCallbackContainerProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TCallbackContainer.Get_ToString: WideString;
begin
    Result := DefaultInterface.ToString;
end;

function TCallbackContainer.Equals(obj: OleVariant): WordBool;
begin
  Result := DefaultInterface.Equals(obj);
end;

function TCallbackContainer.GetHashCode: Integer;
begin
  Result := DefaultInterface.GetHashCode;
end;

function TCallbackContainer.GetType: _Type;
begin
  Result := DefaultInterface.GetType;
end;

procedure TCallbackContainer.Response(const message: WideString);
begin
  DefaultInterface.Response(message);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TCallbackContainerProperties.Create(AServer: TCallbackContainer);
begin
  inherited Create;
  FServer := AServer;
end;

function TCallbackContainerProperties.GetDefaultInterface: _CallbackContainer;
begin
  Result := FServer.DefaultInterface;
end;

function TCallbackContainerProperties.Get_ToString: WideString;
begin
    Result := DefaultInterface.ToString;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TPosting, TCallbackContainer]);
end;

end.
