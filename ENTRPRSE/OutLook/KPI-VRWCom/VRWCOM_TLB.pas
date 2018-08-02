unit VRWCOM_TLB;

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

// PASTLWTR : $Revision:   1.130.1.0.1.0.1.6  $
// File generated on 28/07/2009 09:31:18 from Type Library described below.

// ************************************************************************  //
// Type Lib: W:\ENTRPRSE\OutLook\KPI-VRWCom\VRWCOM.tlb (1)
// LIBID: {1822FB67-8D2B-46F8-852A-DDCFDFC866A5}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  VRWCOMMajorVersion = 1;
  VRWCOMMinorVersion = 0;

  LIBID_VRWCOM: TGUID = '{1822FB67-8D2B-46F8-852A-DDCFDFC866A5}';

  IID_IReportTree: TGUID = '{4B5C7829-05DB-4D68-B512-59417BF1CE5F}';
  CLASS_ReportTree: TGUID = '{57262593-7D7F-473D-844D-C4EEA2F95039}';
  IID_IReport: TGUID = '{C202C376-1D7E-47AF-80F0-27DE56179FF6}';
  IID_IReportData: TGUID = '{02BA8F57-852D-4205-8FCF-F9660798B638}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IReportTree = interface;
  IReportTreeDisp = dispinterface;
  IReport = interface;
  IReportDisp = dispinterface;
  IReportData = interface;
  IReportDataDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ReportTree = IReportTree;


// *********************************************************************//
// Interface: IReportTree
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4B5C7829-05DB-4D68-B512-59417BF1CE5F}
// *********************************************************************//
  IReportTree = interface(IDispatch)
    ['{4B5C7829-05DB-4D68-B512-59417BF1CE5F}']
    function Get_Datapath: WideString; safecall;
    procedure Set_Datapath(const Value: WideString); safecall;
    function Get_UserID: WideString; safecall;
    procedure Set_UserID(const Value: WideString); safecall;
    function GetFirstReport(var NodeType: WideString; var NodeName: WideString; 
                            var NodeDesc: WideString; var NodeParent: WideString; 
                            var NodeChild: WideString; var Filename: WideString; 
                            var LastRun: WideString; var AllowEdit: WordBool): Integer; safecall;
    function GetGEqual(const ParentID: WideString; var NodeType: WideString; 
                       var NodeName: WideString; var NodeDesc: WideString; 
                       var NodeParent: WideString; var NodeChild: WideString; 
                       var Filename: WideString; var LastRun: WideString; var AllowEdit: WordBool): Integer; safecall;
    function GetNext(var NodeType: WideString; var NodeName: WideString; var NodeDesc: WideString; 
                     var NodeParent: WideString; var NodeChild: WideString; 
                     var Filename: WideString; var LastRun: WideString; var AllowEdit: WordBool): Integer; safecall;
    function RestorePosition(iPos: Integer): Integer; safecall;
    function SavePosition(var iPos: Integer): Integer; safecall;
    function Get_Report: IReport; safecall;
    function Get_ReportData: IReportData; safecall;
    procedure NoPrintPreview; safecall;
    procedure Print; safecall;
    property Datapath: WideString read Get_Datapath write Set_Datapath;
    property UserID: WideString read Get_UserID write Set_UserID;
    property Report: IReport read Get_Report;
    property ReportData: IReportData read Get_ReportData;
  end;

// *********************************************************************//
// DispIntf:  IReportTreeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4B5C7829-05DB-4D68-B512-59417BF1CE5F}
// *********************************************************************//
  IReportTreeDisp = dispinterface
    ['{4B5C7829-05DB-4D68-B512-59417BF1CE5F}']
    property Datapath: WideString dispid 1;
    property UserID: WideString dispid 2;
    function GetFirstReport(var NodeType: WideString; var NodeName: WideString; 
                            var NodeDesc: WideString; var NodeParent: WideString; 
                            var NodeChild: WideString; var Filename: WideString; 
                            var LastRun: WideString; var AllowEdit: WordBool): Integer; dispid 3;
    function GetGEqual(const ParentID: WideString; var NodeType: WideString; 
                       var NodeName: WideString; var NodeDesc: WideString; 
                       var NodeParent: WideString; var NodeChild: WideString; 
                       var Filename: WideString; var LastRun: WideString; var AllowEdit: WordBool): Integer; dispid 4;
    function GetNext(var NodeType: WideString; var NodeName: WideString; var NodeDesc: WideString; 
                     var NodeParent: WideString; var NodeChild: WideString; 
                     var Filename: WideString; var LastRun: WideString; var AllowEdit: WordBool): Integer; dispid 5;
    function RestorePosition(iPos: Integer): Integer; dispid 6;
    function SavePosition(var iPos: Integer): Integer; dispid 7;
    property Report: IReport readonly dispid 8;
    property ReportData: IReportData readonly dispid 9;
    procedure NoPrintPreview; dispid 10;
    procedure Print; dispid 11;
  end;

// *********************************************************************//
// Interface: IReport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C202C376-1D7E-47AF-80F0-27DE56179FF6}
// *********************************************************************//
  IReport = interface(IDispatch)
    ['{C202C376-1D7E-47AF-80F0-27DE56179FF6}']
    function Get_Datapath: WideString; safecall;
    procedure Set_Datapath(const Value: WideString); safecall;
    procedure Print; safecall;
    procedure Read(const Filename: WideString); safecall;
    function Init: Integer; safecall;
    property Datapath: WideString read Get_Datapath write Set_Datapath;
  end;

// *********************************************************************//
// DispIntf:  IReportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C202C376-1D7E-47AF-80F0-27DE56179FF6}
// *********************************************************************//
  IReportDisp = dispinterface
    ['{C202C376-1D7E-47AF-80F0-27DE56179FF6}']
    property Datapath: WideString dispid 1;
    procedure Print; dispid 2;
    procedure Read(const Filename: WideString); dispid 3;
    function Init: Integer; dispid 4;
  end;

// *********************************************************************//
// Interface: IReportData
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {02BA8F57-852D-4205-8FCF-F9660798B638}
// *********************************************************************//
  IReportData = interface(IDispatch)
    ['{02BA8F57-852D-4205-8FCF-F9660798B638}']
    function Get_Datapath: WideString; safecall;
    procedure Set_Datapath(const Value: WideString); safecall;
    function Get_UserID: WideString; safecall;
    procedure Set_UserID(const Value: WideString); safecall;
    function Get_Index: Integer; safecall;
    procedure Set_Index(Value: Integer); safecall;
    function FindByName(const ReportName: WideString): Integer; safecall;
    property Datapath: WideString read Get_Datapath write Set_Datapath;
    property UserID: WideString read Get_UserID write Set_UserID;
    property Index: Integer read Get_Index write Set_Index;
  end;

// *********************************************************************//
// DispIntf:  IReportDataDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {02BA8F57-852D-4205-8FCF-F9660798B638}
// *********************************************************************//
  IReportDataDisp = dispinterface
    ['{02BA8F57-852D-4205-8FCF-F9660798B638}']
    property Datapath: WideString dispid 1;
    property UserID: WideString dispid 2;
    property Index: Integer dispid 3;
    function FindByName(const ReportName: WideString): Integer; dispid 4;
  end;

// *********************************************************************//
// The Class CoReportTree provides a Create and CreateRemote method to          
// create instances of the default interface IReportTree exposed by              
// the CoClass ReportTree. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoReportTree = class
    class function Create: IReportTree;
    class function CreateRemote(const MachineName: string): IReportTree;
  end;

implementation

uses ComObj;

class function CoReportTree.Create: IReportTree;
begin
  Result := CreateComObject(CLASS_ReportTree) as IReportTree;
end;

class function CoReportTree.CreateRemote(const MachineName: string): IReportTree;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ReportTree) as IReportTree;
end;

end.
