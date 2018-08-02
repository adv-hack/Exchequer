unit FmPrint_TLB;

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
// File generated on 28/10/2008 14:34:03 from Type Library described below.

// ************************************************************************  //
// Type Lib: \\p004448\share\EXCHPR3\FAXSRV\FmPrint4.OCX (1)
// LIBID: {2C228B97-82DC-41C2-81C9-22F7C90FCC65}
// LCID: 0
// Helpfile: \\p004448\share\EXCHPR3\FAXSRV\faxman4.chm
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  FmPrintMajorVersion = 1;
  FmPrintMinorVersion = 0;

  LIBID_FmPrint: TGUID = '{2C228B97-82DC-41C2-81C9-22F7C90FCC65}';

  IID_IPrintJob: TGUID = '{896F47D3-2678-49FD-A10F-7A7015E258BF}';
  CLASS_PrintJob: TGUID = '{3B9E36B0-6459-46FC-A382-13C79A7664C8}';
  IID_IDefaultSettings: TGUID = '{15B443F9-9CC9-474B-982C-36FBD6D2DEA4}';
  CLASS_DefaultSettings: TGUID = '{65A87952-612C-4722-BC22-71F8EB5C98A8}';
  DIID__IFmPrinterEvents: TGUID = '{98C1D999-7B4E-4403-9CED-CE4B9B2D80D2}';
  IID_IFmPrinter: TGUID = '{98C1D998-7B4E-4403-9CED-CE4B9B2D80D2}';
  CLASS_FmPrinter: TGUID = '{CE1191A2-543E-4E06-A9D1-ADCBFCD5D368}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum PrintJobStatus
type
  PrintJobStatus = TOleEnum;
const
  OK = $00000000;
  Failed = $00000001;

// Constants for enum PaperSizes
type
  PaperSizes = TOleEnum;
const
  Letter = $00000001;
  A4 = $00000002;
  Legal = $00000003;

// Constants for enum Orientations
type
  Orientations = TOleEnum;
const
  Portrait = $00000001;
  Landscape = $00000002;

// Constants for enum Resolutions
type
  Resolutions = TOleEnum;
const
  Low = $00000001;
  High = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPrintJob = interface;
  IPrintJobDisp = dispinterface;
  IDefaultSettings = interface;
  IDefaultSettingsDisp = dispinterface;
  _IFmPrinterEvents = dispinterface;
  IFmPrinter = interface;
  IFmPrinterDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  PrintJob = IPrintJob;
  DefaultSettings = IDefaultSettings;
  FmPrinter = IFmPrinter;


// *********************************************************************//
// Interface: IPrintJob
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {896F47D3-2678-49FD-A10F-7A7015E258BF}
// *********************************************************************//
  IPrintJob = interface(IDispatch)
    ['{896F47D3-2678-49FD-A10F-7A7015E258BF}']
    function Get_FileName: WideString; safecall;
    function Get_DocumentName: WideString; safecall;
    function Get_Pages: Integer; safecall;
    function Get_Status: PrintJobStatus; safecall;
    property FileName: WideString read Get_FileName;
    property DocumentName: WideString read Get_DocumentName;
    property Pages: Integer read Get_Pages;
    property Status: PrintJobStatus read Get_Status;
  end;

// *********************************************************************//
// DispIntf:  IPrintJobDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {896F47D3-2678-49FD-A10F-7A7015E258BF}
// *********************************************************************//
  IPrintJobDisp = dispinterface
    ['{896F47D3-2678-49FD-A10F-7A7015E258BF}']
    property FileName: WideString readonly dispid 1;
    property DocumentName: WideString readonly dispid 2;
    property Pages: Integer readonly dispid 3;
    property Status: PrintJobStatus readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IDefaultSettings
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {15B443F9-9CC9-474B-982C-36FBD6D2DEA4}
// *********************************************************************//
  IDefaultSettings = interface(IDispatch)
    ['{15B443F9-9CC9-474B-982C-36FBD6D2DEA4}']
    function Get_PaperSize: PaperSizes; safecall;
    procedure Set_PaperSize(pVal: PaperSizes); safecall;
    function Get_Orientation: Orientations; safecall;
    procedure Set_Orientation(pVal: Orientations); safecall;
    function Get_Resolution: Resolutions; safecall;
    procedure Set_Resolution(pVal: Resolutions); safecall;
    function Get_PrinterName: WideString; safecall;
    property PaperSize: PaperSizes read Get_PaperSize write Set_PaperSize;
    property Orientation: Orientations read Get_Orientation write Set_Orientation;
    property Resolution: Resolutions read Get_Resolution write Set_Resolution;
    property PrinterName: WideString read Get_PrinterName;
  end;

// *********************************************************************//
// DispIntf:  IDefaultSettingsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {15B443F9-9CC9-474B-982C-36FBD6D2DEA4}
// *********************************************************************//
  IDefaultSettingsDisp = dispinterface
    ['{15B443F9-9CC9-474B-982C-36FBD6D2DEA4}']
    property PaperSize: PaperSizes dispid 1;
    property Orientation: Orientations dispid 2;
    property Resolution: Resolutions dispid 3;
    property PrinterName: WideString readonly dispid 4;
  end;

// *********************************************************************//
// DispIntf:  _IFmPrinterEvents
// Flags:     (4096) Dispatchable
// GUID:      {98C1D999-7B4E-4403-9CED-CE4B9B2D80D2}
// *********************************************************************//
  _IFmPrinterEvents = dispinterface
    ['{98C1D999-7B4E-4403-9CED-CE4B9B2D80D2}']
    procedure PrintComplete; dispid 1;
  end;

// *********************************************************************//
// Interface: IFmPrinter
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {98C1D998-7B4E-4403-9CED-CE4B9B2D80D2}
// *********************************************************************//
  IFmPrinter = interface(IDispatch)
    ['{98C1D998-7B4E-4403-9CED-CE4B9B2D80D2}']
    function IsPrinterInstalled: WordBool; safecall;
    function InstallPrinter(ApplicationPath: OleVariant): WordBool; safecall;
    function PrinterDefaults: IDispatch; safecall;
    function Get_LogPrinterInstallation: WordBool; safecall;
    procedure Set_LogPrinterInstallation(pVal: WordBool); safecall;
    function Get_PrinterName: WideString; safecall;
    procedure Set_PrinterName(const pVal: WideString); safecall;
    function Get_PrintJobCount: Integer; safecall;
    function GetNextPrintJob: IDispatch; safecall;
    function Get_LastErrorString: WideString; safecall;
    function Get_LastError: Integer; safecall;
    function Get_PrintFilesPath: WideString; safecall;
    procedure Set_PrintFilesPath(const pVal: WideString); safecall;
    property LogPrinterInstallation: WordBool read Get_LogPrinterInstallation write Set_LogPrinterInstallation;
    property PrinterName: WideString read Get_PrinterName write Set_PrinterName;
    property PrintJobCount: Integer read Get_PrintJobCount;
    property LastErrorString: WideString read Get_LastErrorString;
    property LastError: Integer read Get_LastError;
    property PrintFilesPath: WideString read Get_PrintFilesPath write Set_PrintFilesPath;
  end;

// *********************************************************************//
// DispIntf:  IFmPrinterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {98C1D998-7B4E-4403-9CED-CE4B9B2D80D2}
// *********************************************************************//
  IFmPrinterDisp = dispinterface
    ['{98C1D998-7B4E-4403-9CED-CE4B9B2D80D2}']
    function IsPrinterInstalled: WordBool; dispid 1;
    function InstallPrinter(ApplicationPath: OleVariant): WordBool; dispid 2;
    function PrinterDefaults: IDispatch; dispid 3;
    property LogPrinterInstallation: WordBool dispid 4;
    property PrinterName: WideString dispid 5;
    property PrintJobCount: Integer readonly dispid 6;
    function GetNextPrintJob: IDispatch; dispid 7;
    property LastErrorString: WideString readonly dispid 8;
    property LastError: Integer readonly dispid 9;
    property PrintFilesPath: WideString dispid 10;
  end;

// *********************************************************************//
// The Class CoPrintJob provides a Create and CreateRemote method to          
// create instances of the default interface IPrintJob exposed by              
// the CoClass PrintJob. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPrintJob = class
    class function Create: IPrintJob;
    class function CreateRemote(const MachineName: string): IPrintJob;
  end;

// *********************************************************************//
// The Class CoDefaultSettings provides a Create and CreateRemote method to          
// create instances of the default interface IDefaultSettings exposed by              
// the CoClass DefaultSettings. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDefaultSettings = class
    class function Create: IDefaultSettings;
    class function CreateRemote(const MachineName: string): IDefaultSettings;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TFmPrinter
// Help String      : FmPrinter Class
// Default Interface: IFmPrinter
// Def. Intf. DISP? : No
// Event   Interface: _IFmPrinterEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TFmPrinter = class(TOleControl)
  private
    FOnPrintComplete: TNotifyEvent;
    FIntf: IFmPrinter;
    function  GetControlInterface: IFmPrinter;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function IsPrinterInstalled: WordBool;
    function InstallPrinter: WordBool; overload;
    function InstallPrinter(ApplicationPath: OleVariant): WordBool; overload;
    function PrinterDefaults: IDispatch;
    function GetNextPrintJob: IDispatch;
    property  ControlInterface: IFmPrinter read GetControlInterface;
    property  DefaultInterface: IFmPrinter read GetControlInterface;
    property PrintJobCount: Integer index 6 read GetIntegerProp;
    property LastErrorString: WideString index 8 read GetWideStringProp;
    property LastError: Integer index 9 read GetIntegerProp;
  published
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property LogPrinterInstallation: WordBool index 4 read GetWordBoolProp write SetWordBoolProp stored False;
    property PrinterName: WideString index 5 read GetWideStringProp write SetWideStringProp stored False;
    property PrintFilesPath: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property OnPrintComplete: TNotifyEvent read FOnPrintComplete write FOnPrintComplete;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

implementation

uses ComObj;

class function CoPrintJob.Create: IPrintJob;
begin
  Result := CreateComObject(CLASS_PrintJob) as IPrintJob;
end;

class function CoPrintJob.CreateRemote(const MachineName: string): IPrintJob;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PrintJob) as IPrintJob;
end;

class function CoDefaultSettings.Create: IDefaultSettings;
begin
  Result := CreateComObject(CLASS_DefaultSettings) as IDefaultSettings;
end;

class function CoDefaultSettings.CreateRemote(const MachineName: string): IDefaultSettings;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DefaultSettings) as IDefaultSettings;
end;

procedure TFmPrinter.InitControlData;
const
  CEventDispIDs: array [0..0] of DWORD = (
    $00000001);
  CLicenseKey: array[0..17] of Word = ( $0046, $006D, $0050, $0072, $0069, $006E, $0074, $0065, $0072, $0020, $006C
    , $0069, $0063, $0065, $006E, $0073, $0065, $0000);
  CControlData: TControlData2 = (
    ClassID: '{CE1191A2-543E-4E06-A9D1-ADCBFCD5D368}';
    EventIID: '{98C1D999-7B4E-4403-9CED-CE4B9B2D80D2}';
    EventCount: 1;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnPrintComplete) - Cardinal(Self);
end;

procedure TFmPrinter.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IFmPrinter;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TFmPrinter.GetControlInterface: IFmPrinter;
begin
  CreateControl;
  Result := FIntf;
end;

function TFmPrinter.IsPrinterInstalled: WordBool;
begin
  Result := DefaultInterface.IsPrinterInstalled;
end;

function TFmPrinter.InstallPrinter: WordBool;
begin
  Result := DefaultInterface.InstallPrinter(EmptyParam);
end;

function TFmPrinter.InstallPrinter(ApplicationPath: OleVariant): WordBool;
begin
  Result := DefaultInterface.InstallPrinter(ApplicationPath);
end;

function TFmPrinter.PrinterDefaults: IDispatch;
begin
  Result := DefaultInterface.PrinterDefaults;
end;

function TFmPrinter.GetNextPrintJob: IDispatch;
begin
  Result := DefaultInterface.GetNextPrintJob;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TFmPrinter]);
end;

end.
