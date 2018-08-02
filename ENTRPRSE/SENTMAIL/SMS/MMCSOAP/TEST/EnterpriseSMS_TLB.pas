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
// File generated on 21/11/2001 12:32:05 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\SENTMAIL\SMS\MMCSOAP\TEST\SMSMMC.tlb (1)
// LIBID: {69F8ACDD-90A3-4FDB-B5F7-62956A3204E9}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (E:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (E:\WINNT\System32\STDVCL40.DLL)
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

  LIBID_EnterpriseSMS: TGUID = '{69F8ACDD-90A3-4FDB-B5F7-62956A3204E9}';

  IID_ISMSSender: TGUID = '{1FD75845-C231-4E43-8C25-6CD24D8636BE}';
  CLASS_SMSSender: TGUID = '{8731BB8A-682B-4ADA-9CD3-D0D218E16688}';
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
// GUID:      {1FD75845-C231-4E43-8C25-6CD24D8636BE}
// *********************************************************************//
  ISMSSender = interface(IDispatch)
    ['{1FD75845-C231-4E43-8C25-6CD24D8636BE}']
    function Get_Version: WideString; safecall;
    procedure Set_Number(const Param1: WideString); safecall;
    procedure Set_Message(const Param1: WideString); safecall;
    function Get_NumberSentTo: WideString; safecall;
    function Send: Integer; safecall;
    function Setup: Integer; safecall;
    procedure Abort; safecall;
    function GetErrorDesc(ErrorNo: Integer): WideString; safecall;
    property Version: WideString read Get_Version;
    property NumberSentTo: WideString read Get_NumberSentTo;
  end;

// *********************************************************************//
// DispIntf:  ISMSSenderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1FD75845-C231-4E43-8C25-6CD24D8636BE}
// *********************************************************************//
  ISMSSenderDisp = dispinterface
    ['{1FD75845-C231-4E43-8C25-6CD24D8636BE}']
    property Version: WideString readonly dispid 1;
    property Number: WideString writeonly dispid 4;
    property Message: WideString writeonly dispid 6;
    property NumberSentTo: WideString readonly dispid 9;
    function Send: Integer; dispid 10;
    function Setup: Integer; dispid 11;
    procedure Abort; dispid 5;
    function GetErrorDesc(ErrorNo: Integer): WideString; dispid 7;
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
