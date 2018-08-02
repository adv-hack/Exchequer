unit EExport_TLB;

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
// File generated on 2/1/2006 08:23:16 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\Export\EExport.tlb (1)
// LIBID: {A6003C84-CB57-4545-B3DB-0B0423CD2B6F}
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
  EExportMajorVersion = 1;
  EExportMinorVersion = 0;

  LIBID_EExport: TGUID = '{A6003C84-CB57-4545-B3DB-0B0423CD2B6F}';

  IID_IENTExport: TGUID = '{CB2BF873-E9F7-4A67-8583-ABB4A873277C}';
  CLASS_ENTExport: TGUID = '{DD19A409-26FA-4D30-96C6-8E4DB2E7F55E}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IENTExport = interface;
  IENTExportDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ENTExport = IENTExport;


// *********************************************************************//
// Interface: IENTExport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CB2BF873-E9F7-4A67-8583-ABB4A873277C}
// *********************************************************************//
  IENTExport = interface(IDispatch)
    ['{CB2BF873-E9F7-4A67-8583-ABB4A873277C}']
    function DoExport(const pDataPath: WideString; const pParam1: WideString; 
                      const pParam2: WideString; const pXML: WideString; const pXSL: WideString; 
                      const pXSD: WideString; pUserReference: LongWord): LongWord; safecall;
    function Get_XmlList(Index: Integer): WideString; safecall;
    function Get_XmlCount: Integer; safecall;
    property XmlList[Index: Integer]: WideString read Get_XmlList;
    property XmlCount: Integer read Get_XmlCount;
  end;

// *********************************************************************//
// DispIntf:  IENTExportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CB2BF873-E9F7-4A67-8583-ABB4A873277C}
// *********************************************************************//
  IENTExportDisp = dispinterface
    ['{CB2BF873-E9F7-4A67-8583-ABB4A873277C}']
    function DoExport(const pDataPath: WideString; const pParam1: WideString; 
                      const pParam2: WideString; const pXML: WideString; const pXSL: WideString; 
                      const pXSD: WideString; pUserReference: LongWord): LongWord; dispid 1;
    property XmlList[Index: Integer]: WideString readonly dispid 2;
    property XmlCount: Integer readonly dispid 3;
  end;

// *********************************************************************//
// The Class CoENTExport provides a Create and CreateRemote method to          
// create instances of the default interface IENTExport exposed by              
// the CoClass ENTExport. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoENTExport = class
    class function Create: IENTExport;
    class function CreateRemote(const MachineName: string): IENTExport;
  end;

implementation

uses ComObj;

class function CoENTExport.Create: IENTExport;
begin
  Result := CreateComObject(CLASS_ENTExport) as IENTExport;
end;

class function CoENTExport.CreateRemote(const MachineName: string): IENTExport;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ENTExport) as IENTExport;
end;

end.
