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
// File generated on 08/04/2002 16:25:19 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\SENTMAIL\SMS\SMSWAP\SMSWAP.tlb (1)
// LIBID: {2BC37B8C-5BF1-4FD9-ADCF-5FFC35934E35}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
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

  LIBID_EnterpriseSMS: TGUID = '{2BC37B8C-5BF1-4FD9-ADCF-5FFC35934E35}';

  IID_ISMSSender: TGUID = '{29EF1954-E1F2-445A-91D9-9E9C19DC931E}';
  CLASS_SMSSender: TGUID = '{CBF169A1-3D89-425E-9030-13BF5CBF28A5}';
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
// GUID:      {29EF1954-E1F2-445A-91D9-9E9C19DC931E}
// *********************************************************************//
  ISMSSender = interface(IDispatch)
    ['{29EF1954-E1F2-445A-91D9-9E9C19DC931E}']
    function Send: Integer; safecall;
    function Setup: Integer; safecall;
    procedure Abort; safecall;
    function GetErrorDesc(ErrorNo: Integer): WideString; safecall;
    procedure Reset; safecall;
    function AreYouReady: WordBool; safecall;
    function Get_Version: WideString; safecall;
    function Get_Number: WideString; safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Get_Message: WideString; safecall;
    procedure Set_Message(const Value: WideString); safecall;
    property Version: WideString read Get_Version;
    property Number: WideString read Get_Number write Set_Number;
    property Message: WideString read Get_Message write Set_Message;
  end;

// *********************************************************************//
// DispIntf:  ISMSSenderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {29EF1954-E1F2-445A-91D9-9E9C19DC931E}
// *********************************************************************//
  ISMSSenderDisp = dispinterface
    ['{29EF1954-E1F2-445A-91D9-9E9C19DC931E}']
    function Send: Integer; dispid 2;
    function Setup: Integer; dispid 3;
    procedure Abort; dispid 4;
    function GetErrorDesc(ErrorNo: Integer): WideString; dispid 5;
    procedure Reset; dispid 6;
    function AreYouReady: WordBool; dispid 7;
    property Version: WideString readonly dispid 8;
    property Number: WideString dispid 9;
    property Message: WideString dispid 10;
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
