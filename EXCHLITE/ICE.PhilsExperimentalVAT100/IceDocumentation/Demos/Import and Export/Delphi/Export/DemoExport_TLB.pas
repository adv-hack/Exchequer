unit DemoExport_TLB;

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
// File generated on 1/25/2006 09:15:33 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Projects\Ice\IceDocumentation\Demos\Import and Export\Delphi\Export\DemoExport.tlb (1)
// LIBID: {C654C64A-4C79-4110-8671-26CA9DD62986}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
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
  DemoExportMajorVersion = 1;
  DemoExportMinorVersion = 0;

  LIBID_DemoExport: TGUID = '{C654C64A-4C79-4110-8671-26CA9DD62986}';

  IID_INewExport: TGUID = '{13781019-DC57-4260-941D-871DCC7F4F98}';
  CLASS_NewExport: TGUID = '{EE30F27F-4086-4E95-8A1A-A0E2ECCFD3DA}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  INewExport = interface;
  INewExportDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  NewExport = INewExport;


// *********************************************************************//
// Interface: INewExport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {13781019-DC57-4260-941D-871DCC7F4F98}
// *********************************************************************//
  INewExport = interface(IDispatch)
    ['{13781019-DC57-4260-941D-871DCC7F4F98}']
    function DoExport(pCompany: LongWord; const pPath: WideString; pMultiCurr: Shortint; 
                      const pParam1: WideString; const pParam2: WideString; const pXML: WideString; 
                      const pXSL: WideString; const pXSD: WideString; pUserReference: LongWord): LongWord; safecall;
    function Get_XmlList(Index: Integer): WideString; safecall;
    function Get_XmlCount: Integer; safecall;
    property XmlList[Index: Integer]: WideString read Get_XmlList;
    property XmlCount: Integer read Get_XmlCount;
  end;

// *********************************************************************//
// DispIntf:  INewExportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {13781019-DC57-4260-941D-871DCC7F4F98}
// *********************************************************************//
  INewExportDisp = dispinterface
    ['{13781019-DC57-4260-941D-871DCC7F4F98}']
    function DoExport(pCompany: LongWord; const pPath: WideString; 
                      pMultiCurr: {??Shortint}OleVariant; const pParam1: WideString; 
                      const pParam2: WideString; const pXML: WideString; const pXSL: WideString; 
                      const pXSD: WideString; pUserReference: LongWord): LongWord; dispid 1;
    property XmlList[Index: Integer]: WideString readonly dispid 3;
    property XmlCount: Integer readonly dispid 4;
  end;

// *********************************************************************//
// The Class CoNewExport provides a Create and CreateRemote method to          
// create instances of the default interface INewExport exposed by              
// the CoClass NewExport. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNewExport = class
    class function Create: INewExport;
    class function CreateRemote(const MachineName: string): INewExport;
  end;

implementation

uses ComObj;

class function CoNewExport.Create: INewExport;
begin
  Result := CreateComObject(CLASS_NewExport) as INewExport;
end;

class function CoNewExport.CreateRemote(const MachineName: string): INewExport;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NewExport) as INewExport;
end;

end.
