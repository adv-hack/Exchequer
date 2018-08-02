unit DSRExport_TLB;

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
// File generated on 03/11/2006 17:02:04 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Projects\Ice\Bin\PLUGINS\dsrexport.dll (1)
// LIBID: {DFDBC0F7-8EC6-4B89-9C62-E848913457BE}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Parent TypeLibrary:
//   (0) v1.0 CISExp, (X:\EXCHLITE\ICE\Source\Export\CIS\CISExp.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

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
  DSRExportMajorVersion = 1;
  DSRExportMinorVersion = 0;

  LIBID_DSRExport: TGUID = '{DFDBC0F7-8EC6-4B89-9C62-E848913457BE}';

  IID_IExportBox: TGUID = '{B8588DFD-DC3E-4B45-AC8C-A09EAF79FB6D}';
  CLASS_ExportBox: TGUID = '{BDFFCEDD-37A4-4021-8E00-96685D008338}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IExportBox = interface;
  IExportBoxDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ExportBox = IExportBox;


// *********************************************************************//
// Interface: IExportBox
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B8588DFD-DC3E-4B45-AC8C-A09EAF79FB6D}
// *********************************************************************//
  IExportBox = interface(IDispatch)
    ['{B8588DFD-DC3E-4B45-AC8C-A09EAF79FB6D}']
    function DoExport(const pCompanyCode: WideString; const pDataPath: WideString; 
                      const pXMLPath: WideString; pParam1: OleVariant; pParam2: OleVariant; 
                      pParam3: OleVariant; pParam4: OleVariant; pUserReference: LongWord): LongWord; safecall;
    function Get_XmlList(Index: Integer): WideString; safecall;
    function Get_XmlCount: Integer; safecall;
    property XmlList[Index: Integer]: WideString read Get_XmlList;
    property XmlCount: Integer read Get_XmlCount;
  end;

// *********************************************************************//
// DispIntf:  IExportBoxDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B8588DFD-DC3E-4B45-AC8C-A09EAF79FB6D}
// *********************************************************************//
  IExportBoxDisp = dispinterface
    ['{B8588DFD-DC3E-4B45-AC8C-A09EAF79FB6D}']
    function DoExport(const pCompanyCode: WideString; const pDataPath: WideString; 
                      const pXMLPath: WideString; pParam1: OleVariant; pParam2: OleVariant; 
                      pParam3: OleVariant; pParam4: OleVariant; pUserReference: LongWord): LongWord; dispid 1;
    property XmlList[Index: Integer]: WideString readonly dispid 2;
    property XmlCount: Integer readonly dispid 3;
  end;

// *********************************************************************//
// The Class CoExportBox provides a Create and CreateRemote method to          
// create instances of the default interface IExportBox exposed by              
// the CoClass ExportBox. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExportBox = class
    class function Create: IExportBox;
    class function CreateRemote(const MachineName: string): IExportBox;
  end;

implementation

uses ComObj;

class function CoExportBox.Create: IExportBox;
begin
  Result := CreateComObject(CLASS_ExportBox) as IExportBox;
end;

class function CoExportBox.CreateRemote(const MachineName: string): IExportBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExportBox) as IExportBox;
end;

end.
