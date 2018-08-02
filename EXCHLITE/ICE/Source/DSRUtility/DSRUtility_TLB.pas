unit DSRUtility_TLB;

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
// File generated on 26/01/2007 11:38:32 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\DSRUtility\DSRUtility.tlb (1)
// LIBID: {841D3CD4-49E1-4A82-A0F9-B1E19C29F870}
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
  DSRUtilityMajorVersion = 1;
  DSRUtilityMinorVersion = 0;

  LIBID_DSRUtility: TGUID = '{841D3CD4-49E1-4A82-A0F9-B1E19C29F870}';

  IID_IDSRUtil: TGUID = '{693EF98A-2F37-4B43-A485-29F86714DBE7}';
  CLASS_DSRUtil: TGUID = '{77ACA094-01A5-4FB8-B85B-D3D0AB91E9E6}';
  IID_DSRFileHeader: TGUID = '{DEA33FEF-146F-4540-9846-97AC76993AD9}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSRUtil = interface;
  IDSRUtilDisp = dispinterface;
  DSRFileHeader = interface;
  DSRFileHeaderDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSRUtil = IDSRUtil;


// *********************************************************************//
// Interface: IDSRUtil
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {693EF98A-2F37-4B43-A485-29F86714DBE7}
// *********************************************************************//
  IDSRUtil = interface(IDispatch)
    ['{693EF98A-2F37-4B43-A485-29F86714DBE7}']
    function Compress(const pFileIn: WideString; const pFileOut: WideString): WordBool; safecall;
    function Decompress(const pFileIn: WideString; const pFileOut: WideString): WordBool; safecall;
    function EnCrypt(const pFileIn: WideString; const pFileOut: WideString): WordBool; safecall;
    function Decrypt(const pFileIn: WideString; const pFileOut: WideString): WordBool; safecall;
    function GetXml(const pFileName: WideString): WideString; safecall;
    function CreateDSRFiles(const pHeader: DSRFileHeader; const pFileName: WideString; 
                            const pXML: WideString): WideString; safecall;
    function GetDBServer: WideString; safecall;
    function IsCISTest: WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDSRUtilDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {693EF98A-2F37-4B43-A485-29F86714DBE7}
// *********************************************************************//
  IDSRUtilDisp = dispinterface
    ['{693EF98A-2F37-4B43-A485-29F86714DBE7}']
    function Compress(const pFileIn: WideString; const pFileOut: WideString): WordBool; dispid 1;
    function Decompress(const pFileIn: WideString; const pFileOut: WideString): WordBool; dispid 2;
    function EnCrypt(const pFileIn: WideString; const pFileOut: WideString): WordBool; dispid 3;
    function Decrypt(const pFileIn: WideString; const pFileOut: WideString): WordBool; dispid 4;
    function GetXml(const pFileName: WideString): WideString; dispid 5;
    function CreateDSRFiles(const pHeader: DSRFileHeader; const pFileName: WideString; 
                            const pXML: WideString): WideString; dispid 6;
    function GetDBServer: WideString; dispid 7;
    function IsCISTest: WordBool; dispid 8;
  end;

// *********************************************************************//
// Interface: DSRFileHeader
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DEA33FEF-146F-4540-9846-97AC76993AD9}
// *********************************************************************//
  DSRFileHeader = interface(IDispatch)
    ['{DEA33FEF-146F-4540-9846-97AC76993AD9}']
    function Get_BatchId: WideString; safecall;
    function Get_Version: WideString; safecall;
    function Get_ExCode: WideString; safecall;
    function Get_CompGuid: WideString; safecall;
    function Get_CheckSum: LongWord; safecall;
    function Get_Order: LongWord; safecall;
    function Get_Total: LongWord; safecall;
    function Get_Split: LongWord; safecall;
    function Get_SplitTotal: LongWord; safecall;
    function Get_SplitCheckSum: LongWord; safecall;
    function Get_Flags: Word; safecall;
    function Get_Mode: Shortint; safecall;
    property BatchId: WideString read Get_BatchId;
    property Version: WideString read Get_Version;
    property ExCode: WideString read Get_ExCode;
    property CompGuid: WideString read Get_CompGuid;
    property CheckSum: LongWord read Get_CheckSum;
    property Order: LongWord read Get_Order;
    property Total: LongWord read Get_Total;
    property Split: LongWord read Get_Split;
    property SplitTotal: LongWord read Get_SplitTotal;
    property SplitCheckSum: LongWord read Get_SplitCheckSum;
    property Flags: Word read Get_Flags;
    property Mode: Shortint read Get_Mode;
  end;

// *********************************************************************//
// DispIntf:  DSRFileHeaderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DEA33FEF-146F-4540-9846-97AC76993AD9}
// *********************************************************************//
  DSRFileHeaderDisp = dispinterface
    ['{DEA33FEF-146F-4540-9846-97AC76993AD9}']
    property BatchId: WideString readonly dispid 4;
    property Version: WideString readonly dispid 5;
    property ExCode: WideString readonly dispid 6;
    property CompGuid: WideString readonly dispid 7;
    property CheckSum: LongWord readonly dispid 8;
    property Order: LongWord readonly dispid 9;
    property Total: LongWord readonly dispid 10;
    property Split: LongWord readonly dispid 11;
    property SplitTotal: LongWord readonly dispid 12;
    property SplitCheckSum: LongWord readonly dispid 13;
    property Flags: {??Word}OleVariant readonly dispid 14;
    property Mode: {??Shortint}OleVariant readonly dispid 15;
  end;

// *********************************************************************//
// The Class CoDSRUtil provides a Create and CreateRemote method to          
// create instances of the default interface IDSRUtil exposed by              
// the CoClass DSRUtil. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRUtil = class
    class function Create: IDSRUtil;
    class function CreateRemote(const MachineName: string): IDSRUtil;
  end;

implementation

uses ComObj;

class function CoDSRUtil.Create: IDSRUtil;
begin
  Result := CreateComObject(CLASS_DSRUtil) as IDSRUtil;
end;

class function CoDSRUtil.CreateRemote(const MachineName: string): IDSRUtil;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRUtil) as IDSRUtil;
end;

end.
