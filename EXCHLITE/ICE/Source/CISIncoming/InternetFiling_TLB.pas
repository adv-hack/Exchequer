unit InternetFiling_TLB;

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
// File generated on 12/03/2018 11:45:44 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\Advanced Enterprise Software Ltd\Exchequer FBI SubSystem\InternetFiling.tlb (1)
// LIBID: {67C620EB-3F2D-46F6-BC15-C554CABF73EE}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
//   (2) v2.0 mscorlib, (C:\Windows\Microsoft.NET\Framework\v2.0.50727\mscorlib.tlb)
// Parent TypeLibrary:
//   (0) v1.0 CISIncoming, (X:\EXCHLITE\ICE\Source\CISIncoming\CISIncoming.tlb)
// Errors:
//   Hint: Parameter 'Class' of IPosting.Submit changed to 'Class_'
//   Hint: Parameter 'Class' of IPosting.BeginPolling changed to 'Class_'
//   Hint: Parameter 'Class' of IPosting.BeginPolling_2 changed to 'Class_'
//   Hint: Parameter 'Class' of IPosting.Delete changed to 'Class_'
//   Hint: Parameter 'Class' of _Posting.Submit changed to 'Class_'
//   Hint: Parameter 'Class' of _Posting.BeginPolling changed to 'Class_'
//   Hint: Parameter 'Class' of _Posting.BeginPolling_2 changed to 'Class_'
//   Hint: Parameter 'Class' of _Posting.Delete changed to 'Class_'
//   Hint: Parameter 'Class' of _Posting.BeginPolling_3 changed to 'Class_'
//   Hint: Parameter 'Class' of _Posting.RequestList changed to 'Class_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, mscorlib_TLB, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  InternetFilingMajorVersion = 8;
  InternetFilingMinorVersion = 8;

  LIBID_InternetFiling: TGUID = '{67C620EB-3F2D-46F6-BC15-C554CABF73EE}';

  DIID_IPosting: TGUID = '{9C6E465B-E15D-4E3C-A65B-E777F89684E7}';
  IID__Posting: TGUID = '{39A3CB9B-850A-3FEE-98A7-97D222461BBA}';
  IID_ICallback: TGUID = '{2BB4A16E-6EA5-4837-80C1-B01DD4345ECD}';
  IID__CallbackContainer: TGUID = '{D3D98F2A-0DAB-3DEF-AA51-7CC21D4EAB0A}';
  CLASS_Posting: TGUID = '{54678DD0-6780-4A74-8786-0CE701FD85A7}';
  CLASS_CallbackContainer: TGUID = '{7C7D8AA9-0B4F-4F0F-A5C3-68E1657AF4C5}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPosting = dispinterface;
  _Posting = interface;
  _PostingDisp = dispinterface;
  ICallback = interface;
  ICallbackDisp = dispinterface;
  _CallbackContainer = interface;
  _CallbackContainerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Posting = _Posting;
  CallbackContainer = _CallbackContainer;


// *********************************************************************//
// DispIntf:  IPosting
// Flags:     (4096) Dispatchable
// GUID:      {9C6E465B-E15D-4E3C-A65B-E777F89684E7}
// *********************************************************************//
  IPosting = dispinterface
    ['{9C6E465B-E15D-4E3C-A65B-E777F89684E7}']
    function AddIRMark(var DocumentXml: WideString; SubmissionType: Integer): WideString; dispid 1610743808;
    function AddIRMark_2(var DocumentXml: WideString; const Namespace: WideString): WideString; dispid 1610743809;
    function Submit(const Class_: WideString; UsesTestGateway: WordBool; 
                    const DocumentXml: WideString): WideString; dispid 1610743810;
    procedure Query(QueryNum: Integer); dispid 1610743811;
    procedure SetConfiguration(const GatewayUrl: WideString); dispid 1610743812;
    function BeginPolling(const callback: ICallback; const CorrelationID: WideString; 
                          const Class_: WideString; UsesTestGateway: WordBool; 
                          const GovTalkUrl: WideString): WideString; dispid 1610743813;
    function BeginPolling_2(const callback: ICallback; const CorrelationID: WideString; 
                            const Class_: WideString; UsesTestGateway: WordBool): WideString; dispid 1610743814;
    function Delete(const CorrelationID: WideString; const Class_: WideString; 
                    UsesTestGateway: WordBool; const GovTalkUrl: WideString): WideString; dispid 1610743815;
    procedure EndPolling(const PollerGuid: WideString); dispid 1610743816;
    procedure RedirectPolling(const PollingGuid: WideString; const Redirect: WideString); dispid 1610743817;
  end;

// *********************************************************************//
// Interface: _Posting
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {39A3CB9B-850A-3FEE-98A7-97D222461BBA}
// *********************************************************************//
  _Posting = interface(IDispatch)
    ['{39A3CB9B-850A-3FEE-98A7-97D222461BBA}']
    function Get_ToString: WideString; safecall;
    function Equals(obj: OleVariant): WordBool; safecall;
    function GetHashCode: Integer; safecall;
    function GetType: _Type; safecall;
    function AddIRMark(var DocumentXml: WideString; SubmissionType: Integer): WideString; safecall;
    function AddIRMark_2(var DocumentXml: WideString; const Namespace: WideString): WideString; safecall;
    function Submit(const Class_: WideString; UsesTestGateway: WordBool; 
                    const DocumentXml: WideString): WideString; safecall;
    procedure Query(QueryNum: Integer); safecall;
    procedure SetConfiguration(const GatewayUrl: WideString); safecall;
    function BeginPolling(const callback: ICallback; const CorrelationID: WideString; 
                          const Class_: WideString; UsesTestGateway: WordBool; 
                          const GovTalkUrl: WideString): WideString; safecall;
    function BeginPolling_2(const callback: ICallback; const CorrelationID: WideString; 
                            const Class_: WideString; UsesTestGateway: WordBool): WideString; safecall;
    function Delete(const CorrelationID: WideString; const Class_: WideString; 
                    UsesTestGateway: WordBool; const GovTalkUrl: WideString): WideString; safecall;
    procedure EndPolling(const PollerGuid: WideString); safecall;
    procedure RedirectPolling(const PollingGuid: WideString; const Redirect: WideString); safecall;
    function BeginPolling_3(const callback: ICallback; const CorrelationID: WideString; 
                            const Class_: WideString; UsesTestGateway: WordBool; 
                            const GovTalkUrl: WideString; PollingIntervalWholeSeconds: Integer): WideString; safecall;
    function RequestList(const CorrelationID: WideString; const Class_: WideString; 
                         UsesTestGateway: WordBool; const GovTalkUrl: WideString): IUnknown; safecall;
    property ToString: WideString read Get_ToString;
  end;

// *********************************************************************//
// DispIntf:  _PostingDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {39A3CB9B-850A-3FEE-98A7-97D222461BBA}
// *********************************************************************//
  _PostingDisp = dispinterface
    ['{39A3CB9B-850A-3FEE-98A7-97D222461BBA}']
    property ToString: WideString readonly dispid 0;
    function Equals(obj: OleVariant): WordBool; dispid 1610743809;
    function GetHashCode: Integer; dispid 1610743810;
    function GetType: _Type; dispid 1610743811;
    function AddIRMark(var DocumentXml: WideString; SubmissionType: Integer): WideString; dispid 1610743812;
    function AddIRMark_2(var DocumentXml: WideString; const Namespace: WideString): WideString; dispid 1610743813;
    function Submit(const Class_: WideString; UsesTestGateway: WordBool; 
                    const DocumentXml: WideString): WideString; dispid 1610743814;
    procedure Query(QueryNum: Integer); dispid 1610743815;
    procedure SetConfiguration(const GatewayUrl: WideString); dispid 1610743816;
    function BeginPolling(const callback: ICallback; const CorrelationID: WideString; 
                          const Class_: WideString; UsesTestGateway: WordBool; 
                          const GovTalkUrl: WideString): WideString; dispid 1610743817;
    function BeginPolling_2(const callback: ICallback; const CorrelationID: WideString; 
                            const Class_: WideString; UsesTestGateway: WordBool): WideString; dispid 1610743818;
    function Delete(const CorrelationID: WideString; const Class_: WideString; 
                    UsesTestGateway: WordBool; const GovTalkUrl: WideString): WideString; dispid 1610743819;
    procedure EndPolling(const PollerGuid: WideString); dispid 1610743820;
    procedure RedirectPolling(const PollingGuid: WideString; const Redirect: WideString); dispid 1610743821;
    function BeginPolling_3(const callback: ICallback; const CorrelationID: WideString; 
                            const Class_: WideString; UsesTestGateway: WordBool; 
                            const GovTalkUrl: WideString; PollingIntervalWholeSeconds: Integer): WideString; dispid 1610743822;
    function RequestList(const CorrelationID: WideString; const Class_: WideString; 
                         UsesTestGateway: WordBool; const GovTalkUrl: WideString): IUnknown; dispid 1610743823;
  end;

// *********************************************************************//
// Interface: ICallback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2BB4A16E-6EA5-4837-80C1-B01DD4345ECD}
// *********************************************************************//
  ICallback = interface(IDispatch)
    ['{2BB4A16E-6EA5-4837-80C1-B01DD4345ECD}']
    procedure Response(const message: WideString); safecall;
    procedure _Unused; safecall;
  end;

// *********************************************************************//
// DispIntf:  ICallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2BB4A16E-6EA5-4837-80C1-B01DD4345ECD}
// *********************************************************************//
  ICallbackDisp = dispinterface
    ['{2BB4A16E-6EA5-4837-80C1-B01DD4345ECD}']
    procedure Response(const message: WideString); dispid 1610743808;
    procedure _Unused; dispid 1610743809;
  end;

// *********************************************************************//
// Interface: _CallbackContainer
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {D3D98F2A-0DAB-3DEF-AA51-7CC21D4EAB0A}
// *********************************************************************//
  _CallbackContainer = interface(IDispatch)
    ['{D3D98F2A-0DAB-3DEF-AA51-7CC21D4EAB0A}']
    function Get_ToString: WideString; safecall;
    function Equals(obj: OleVariant): WordBool; safecall;
    function GetHashCode: Integer; safecall;
    function GetType: _Type; safecall;
    procedure Response(const message: WideString); safecall;
    property ToString: WideString read Get_ToString;
  end;

// *********************************************************************//
// DispIntf:  _CallbackContainerDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {D3D98F2A-0DAB-3DEF-AA51-7CC21D4EAB0A}
// *********************************************************************//
  _CallbackContainerDisp = dispinterface
    ['{D3D98F2A-0DAB-3DEF-AA51-7CC21D4EAB0A}']
    property ToString: WideString readonly dispid 0;
    function Equals(obj: OleVariant): WordBool; dispid 1610743809;
    function GetHashCode: Integer; dispid 1610743810;
    function GetType: _Type; dispid 1610743811;
    procedure Response(const message: WideString); dispid 1610743812;
  end;

// *********************************************************************//
// The Class CoPosting provides a Create and CreateRemote method to          
// create instances of the default interface _Posting exposed by              
// the CoClass Posting. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPosting = class
    class function Create: _Posting;
    class function CreateRemote(const MachineName: string): _Posting;
  end;

// *********************************************************************//
// The Class CoCallbackContainer provides a Create and CreateRemote method to          
// create instances of the default interface _CallbackContainer exposed by              
// the CoClass CallbackContainer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCallbackContainer = class
    class function Create: _CallbackContainer;
    class function CreateRemote(const MachineName: string): _CallbackContainer;
  end;

implementation

uses ComObj;

class function CoPosting.Create: _Posting;
begin
  Result := CreateComObject(CLASS_Posting) as _Posting;
end;

class function CoPosting.CreateRemote(const MachineName: string): _Posting;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Posting) as _Posting;
end;

class function CoCallbackContainer.Create: _CallbackContainer;
begin
  Result := CreateComObject(CLASS_CallbackContainer) as _CallbackContainer;
end;

class function CoCallbackContainer.CreateRemote(const MachineName: string): _CallbackContainer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CallbackContainer) as _CallbackContainer;
end;

end.
