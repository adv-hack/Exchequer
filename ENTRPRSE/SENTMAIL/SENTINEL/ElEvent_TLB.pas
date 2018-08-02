unit ElEvent_TLB;

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
// File generated on 20/10/2003 11:05:56 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\SENTMAIL\SENTINEL\Sentimail.tlb (1)
// LIBID: {E338D718-81F3-4C10-B609-912488B4D0B3}
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
  ElEventMajorVersion = 1;
  ElEventMinorVersion = 0;

  LIBID_ElEvent: TGUID = '{E338D718-81F3-4C10-B609-912488B4D0B3}';

  IID_ISentimailEvent: TGUID = '{1519E4AF-221B-43FF-8837-E7206EAC6650}';
  CLASS_SentimailEvent: TGUID = '{5F2AEB35-E289-4A1F-8452-5FFD065FF805}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TEventDataType
type
  TEventDataType = TOleEnum;
const
  edtCustomer = $00000000;
  edtSupplier = $00000001;
  edtTransaction = $00000002;
  edtStock = $00000003;
  edtJob = $00000004;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ISentimailEvent = interface;
  ISentimailEventDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SentimailEvent = ISentimailEvent;


// *********************************************************************//
// Interface: ISentimailEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1519E4AF-221B-43FF-8837-E7206EAC6650}
// *********************************************************************//
  ISentimailEvent = interface(IDispatch)
    ['{1519E4AF-221B-43FF-8837-E7206EAC6650}']
    function Get_seWindowID: Integer; safecall;
    procedure Set_seWindowID(Value: Integer); safecall;
    function Get_seHandlerID: Integer; safecall;
    procedure Set_seHandlerID(Value: Integer); safecall;
    function Get_seKey: WideString; safecall;
    procedure Set_seKey(const Value: WideString); safecall;
    function Get_seDataType: TEventDataType; safecall;
    procedure Set_seDataType(Value: TEventDataType); safecall;
    function Save: Integer; safecall;
    function Get_seDataPath: WideString; safecall;
    procedure Set_seDataPath(const Value: WideString); safecall;
    property seWindowID: Integer read Get_seWindowID write Set_seWindowID;
    property seHandlerID: Integer read Get_seHandlerID write Set_seHandlerID;
    property seKey: WideString read Get_seKey write Set_seKey;
    property seDataType: TEventDataType read Get_seDataType write Set_seDataType;
    property seDataPath: WideString read Get_seDataPath write Set_seDataPath;
  end;

// *********************************************************************//
// DispIntf:  ISentimailEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1519E4AF-221B-43FF-8837-E7206EAC6650}
// *********************************************************************//
  ISentimailEventDisp = dispinterface
    ['{1519E4AF-221B-43FF-8837-E7206EAC6650}']
    property seWindowID: Integer dispid 1;
    property seHandlerID: Integer dispid 2;
    property seKey: WideString dispid 3;
    property seDataType: TEventDataType dispid 4;
    function Save: Integer; dispid 5;
    property seDataPath: WideString dispid 6;
  end;

// *********************************************************************//
// The Class CoSentimailEvent provides a Create and CreateRemote method to          
// create instances of the default interface ISentimailEvent exposed by              
// the CoClass SentimailEvent. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSentimailEvent = class
    class function Create: ISentimailEvent;
    class function CreateRemote(const MachineName: string): ISentimailEvent;
  end;

implementation

uses ComObj;

class function CoSentimailEvent.Create: ISentimailEvent;
begin
  Result := CreateComObject(CLASS_SentimailEvent) as ISentimailEvent;
end;

class function CoSentimailEvent.CreateRemote(const MachineName: string): ISentimailEvent;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SentimailEvent) as ISentimailEvent;
end;

end.
