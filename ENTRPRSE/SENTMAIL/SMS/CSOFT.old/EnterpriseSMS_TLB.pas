unit EnterpriseSMS_TLB;

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
// File generated on 27/04/2006 14:44:43 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\SENTMAIL\SMS\CSOFT\ENTSMS.tlb (1)
// LIBID: {BCB1EC6C-9890-4CB7-843F-5829130EE539}
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
  EnterpriseSMSMajorVersion = 1;
  EnterpriseSMSMinorVersion = 0;

  LIBID_EnterpriseSMS: TGUID = '{BCB1EC6C-9890-4CB7-843F-5829130EE539}';

  IID_ISMSSender: TGUID = '{5FE8B11C-33EC-44FA-9BF8-9811D98616A6}';
  CLASS_SMSSender: TGUID = '{98E91789-0E67-4E70-B759-74F4CA649BF3}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ISMSSender = interface;
  ISMSSenderDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SMSSender = ISMSSender;


// *********************************************************************//
// Interface: ISMSSender
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5FE8B11C-33EC-44FA-9BF8-9811D98616A6}
// *********************************************************************//
  ISMSSender = interface(IDispatch)
    ['{5FE8B11C-33EC-44FA-9BF8-9811D98616A6}']
    function Get_Version: WideString; safecall;
    function Send: Smallint; safecall;
    function Setup: Smallint; safecall;
    procedure Reset; safecall;
    function Get_Number: WideString; safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Get_Message: WideString; safecall;
    procedure Set_Message(const Value: WideString); safecall;
    function AreYouReady: WordBool; safecall;
    procedure Abort; safecall;
    function GetErrorDesc(ErrorNo: Integer): WideString; safecall;
    property Version: WideString read Get_Version;
    property Number: WideString read Get_Number write Set_Number;
    property Message: WideString read Get_Message write Set_Message;
  end;

// *********************************************************************//
// DispIntf:  ISMSSenderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5FE8B11C-33EC-44FA-9BF8-9811D98616A6}
// *********************************************************************//
  ISMSSenderDisp = dispinterface
    ['{5FE8B11C-33EC-44FA-9BF8-9811D98616A6}']
    property Version: WideString readonly dispid 1;
    function Send: Smallint; dispid 2;
    function Setup: Smallint; dispid 3;
    procedure Reset; dispid 4;
    property Number: WideString dispid 5;
    property Message: WideString dispid 6;
    function AreYouReady: WordBool; dispid 7;
    procedure Abort; dispid 8;
    function GetErrorDesc(ErrorNo: Integer): WideString; dispid 9;
  end;

// *********************************************************************//
// The Class CoSMSSender provides a Create and CreateRemote method to          
// create instances of the default interface ISMSSender exposed by              
// the CoClass SMSSender. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSMSSender = class
    class function Create: ISMSSender;
    class function CreateRemote(const MachineName: string): ISMSSender;
  end;

implementation

uses ComObj;

class function CoSMSSender.Create: ISMSSender;
begin
  Result := CreateComObject(CLASS_SMSSender) as ISMSSender;
end;

class function CoSMSSender.CreateRemote(const MachineName: string): ISMSSender;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SMSSender) as ISMSSender;
end;

end.
