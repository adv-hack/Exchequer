unit XLUtils_TLB;

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
// File generated on 14/03/2018 12:44:49 from Type Library described below.

// ************************************************************************  //
// Type Lib: \\L17190\GitHub\ExchequerCore\ENTRPRSE\Utility\ExcelExport\XLUtils\XLUtils\bin\Release\XLUtils.tlb (1)
// LIBID: {0A0DE34B-BF92-4C36-874A-57B02224CB32}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
//   (2) v2.4 mscorlib, (C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorlib.tlb)
//   (3) v4.0 StdVCL, (C:\Windows\SysWOW64\stdvcl40.dll)
// Errors:
//   Error creating palette bitmap of (TExcelUtilities) : Server mscoree.dll contains no icons
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
  XLUtilsMajorVersion = 11;
  XLUtilsMinorVersion = 0;

  LIBID_XLUtils: TGUID = '{0A0DE34B-BF92-4C36-874A-57B02224CB32}';

  IID_IExchequerExcelUtilities: TGUID = '{3BB9C24D-6ACC-4FF9-9D89-480886FB5EF2}';
  CLASS_ExcelUtilities: TGUID = '{62290D17-E73A-42DA-98FD-3A8107B878AD}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum XlHAlign
type
  XlHAlign = TOleEnum;
const
  XlHAlign_xlHAlignCenter = $FFFFEFF4;
  XlHAlign_xlHAlignCenterAcrossSelection = $00000007;
  XlHAlign_xlHAlignDistributed = $FFFFEFEB;
  XlHAlign_xlHAlignFill = $00000005;
  XlHAlign_xlHAlignGeneral = $00000001;
  XlHAlign_xlHAlignJustify = $FFFFEFDE;
  XlHAlign_xlHAlignLeft = $FFFFEFDD;
  XlHAlign_xlHAlignRight = $FFFFEFC8;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IExchequerExcelUtilities = interface;
  IExchequerExcelUtilitiesDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ExcelUtilities = IExchequerExcelUtilities;


// *********************************************************************//
// Interface: IExchequerExcelUtilities
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3BB9C24D-6ACC-4FF9-9D89-480886FB5EF2}
// *********************************************************************//
  IExchequerExcelUtilities = interface(IDispatch)
    ['{3BB9C24D-6ACC-4FF9-9D89-480886FB5EF2}']
    function Get_Version: WideString; safecall;
    function Get_ExcelAPIAvailable: WordBool; safecall;
    function ConnectToExcel: WordBool; safecall;
    procedure CreateWorksheet(const WorksheetTitle: WideString); safecall;
    procedure AddColumnTitle(const ColumnTitle: WideString; const MetaData: WideString); safecall;
    procedure AddColumnData(const ColumnData: WideString; const MetaData: WideString); safecall;
    procedure AddColumnDataNumber(const Number: WideString; const NumberFormat: WideString; 
                                  const MetaData: WideString); safecall;
    procedure NewRow; safecall;
    procedure DisconnectFromExcel; safecall;
    property Version: WideString read Get_Version;
    property ExcelAPIAvailable: WordBool read Get_ExcelAPIAvailable;
  end;

// *********************************************************************//
// DispIntf:  IExchequerExcelUtilitiesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3BB9C24D-6ACC-4FF9-9D89-480886FB5EF2}
// *********************************************************************//
  IExchequerExcelUtilitiesDisp = dispinterface
    ['{3BB9C24D-6ACC-4FF9-9D89-480886FB5EF2}']
    property Version: WideString readonly dispid 1610743808;
    property ExcelAPIAvailable: WordBool readonly dispid 1610743809;
    function ConnectToExcel: WordBool; dispid 1610743810;
    procedure CreateWorksheet(const WorksheetTitle: WideString); dispid 1610743811;
    procedure AddColumnTitle(const ColumnTitle: WideString; const MetaData: WideString); dispid 1610743812;
    procedure AddColumnData(const ColumnData: WideString; const MetaData: WideString); dispid 1610743813;
    procedure AddColumnDataNumber(const Number: WideString; const NumberFormat: WideString; 
                                  const MetaData: WideString); dispid 1610743814;
    procedure NewRow; dispid 1610743815;
    procedure DisconnectFromExcel; dispid 1610743816;
  end;

// *********************************************************************//
// The Class CoExcelUtilities provides a Create and CreateRemote method to          
// create instances of the default interface IExchequerExcelUtilities exposed by              
// the CoClass ExcelUtilities. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExcelUtilities = class
    class function Create: IExchequerExcelUtilities;
    class function CreateRemote(const MachineName: string): IExchequerExcelUtilities;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TExcelUtilities
// Help String      : 
// Default Interface: IExchequerExcelUtilities
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TExcelUtilitiesProperties= class;
{$ENDIF}
  TExcelUtilities = class(TOleServer)
  private
    FIntf:        IExchequerExcelUtilities;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TExcelUtilitiesProperties;
    function      GetServerProperties: TExcelUtilitiesProperties;
{$ENDIF}
    function      GetDefaultInterface: IExchequerExcelUtilities;
  protected
    procedure InitServerData; override;
    function Get_Version: WideString;
    function Get_ExcelAPIAvailable: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IExchequerExcelUtilities);
    procedure Disconnect; override;
    function ConnectToExcel: WordBool;
    procedure CreateWorksheet(const WorksheetTitle: WideString);
    procedure AddColumnTitle(const ColumnTitle: WideString; const MetaData: WideString);
    procedure AddColumnData(const ColumnData: WideString; const MetaData: WideString);
    procedure AddColumnDataNumber(const Number: WideString; const NumberFormat: WideString; 
                                  const MetaData: WideString);
    procedure NewRow;
    procedure DisconnectFromExcel;
    property DefaultInterface: IExchequerExcelUtilities read GetDefaultInterface;
    property Version: WideString read Get_Version;
    property ExcelAPIAvailable: WordBool read Get_ExcelAPIAvailable;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TExcelUtilitiesProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TExcelUtilities
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TExcelUtilitiesProperties = class(TPersistent)
  private
    FServer:    TExcelUtilities;
    function    GetDefaultInterface: IExchequerExcelUtilities;
    constructor Create(AServer: TExcelUtilities);
  protected
    function Get_Version: WideString;
    function Get_ExcelAPIAvailable: WordBool;
  public
    property DefaultInterface: IExchequerExcelUtilities read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

implementation

uses ComObj;

class function CoExcelUtilities.Create: IExchequerExcelUtilities;
begin
  Result := CreateComObject(CLASS_ExcelUtilities) as IExchequerExcelUtilities;
end;

class function CoExcelUtilities.CreateRemote(const MachineName: string): IExchequerExcelUtilities;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExcelUtilities) as IExchequerExcelUtilities;
end;

procedure TExcelUtilities.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{62290D17-E73A-42DA-98FD-3A8107B878AD}';
    IntfIID:   '{3BB9C24D-6ACC-4FF9-9D89-480886FB5EF2}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TExcelUtilities.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IExchequerExcelUtilities;
  end;
end;

procedure TExcelUtilities.ConnectTo(svrIntf: IExchequerExcelUtilities);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TExcelUtilities.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TExcelUtilities.GetDefaultInterface: IExchequerExcelUtilities;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TExcelUtilities.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TExcelUtilitiesProperties.Create(Self);
{$ENDIF}
end;

destructor TExcelUtilities.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TExcelUtilities.GetServerProperties: TExcelUtilitiesProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TExcelUtilities.Get_Version: WideString;
begin
    Result := DefaultInterface.Version;
end;

function TExcelUtilities.Get_ExcelAPIAvailable: WordBool;
begin
    Result := DefaultInterface.ExcelAPIAvailable;
end;

function TExcelUtilities.ConnectToExcel: WordBool;
begin
  Result := DefaultInterface.ConnectToExcel;
end;

procedure TExcelUtilities.CreateWorksheet(const WorksheetTitle: WideString);
begin
  DefaultInterface.CreateWorksheet(WorksheetTitle);
end;

procedure TExcelUtilities.AddColumnTitle(const ColumnTitle: WideString; const MetaData: WideString);
begin
  DefaultInterface.AddColumnTitle(ColumnTitle, MetaData);
end;

procedure TExcelUtilities.AddColumnData(const ColumnData: WideString; const MetaData: WideString);
begin
  DefaultInterface.AddColumnData(ColumnData, MetaData);
end;

procedure TExcelUtilities.AddColumnDataNumber(const Number: WideString; 
                                              const NumberFormat: WideString; 
                                              const MetaData: WideString);
begin
  DefaultInterface.AddColumnDataNumber(Number, NumberFormat, MetaData);
end;

procedure TExcelUtilities.NewRow;
begin
  DefaultInterface.NewRow;
end;

procedure TExcelUtilities.DisconnectFromExcel;
begin
  DefaultInterface.DisconnectFromExcel;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TExcelUtilitiesProperties.Create(AServer: TExcelUtilities);
begin
  inherited Create;
  FServer := AServer;
end;

function TExcelUtilitiesProperties.GetDefaultInterface: IExchequerExcelUtilities;
begin
  Result := FServer.DefaultInterface;
end;

function TExcelUtilitiesProperties.Get_Version: WideString;
begin
    Result := DefaultInterface.Version;
end;

function TExcelUtilitiesProperties.Get_ExcelAPIAvailable: WordBool;
begin
    Result := DefaultInterface.ExcelAPIAvailable;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TExcelUtilities]);
end;

end.
