unit EnterpriseTrade_TLB;

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
// File generated on 14/08/2002 16:41:18 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\CUSTOM\PROTOTYP\EntTrade.tlb (1)
// LIBID: {AEAD9E18-FC21-48F7-B716-8ABA1A4CB77C}
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
  EnterpriseTradeMajorVersion = 1;
  EnterpriseTradeMinorVersion = 0;

  LIBID_EnterpriseTrade: TGUID = '{AEAD9E18-FC21-48F7-B716-8ABA1A4CB77C}';

  IID_ITradeConnectionPoint: TGUID = '{8AE10444-4EE7-4487-89B1-1995B5D06C2E}';
  IID_ITradeFunctions: TGUID = '{51A850EC-D45D-4D7A-BF98-692AB243F31F}';
  IID_ITradeSystemSetup: TGUID = '{E5797518-DC56-4CB3-AFE1-2C250CF6C1EB}';
  IID_ITradeVersion: TGUID = '{59CBCFF0-E3CD-4FD2-9FD0-8960432675B3}';
  IID_IDummy: TGUID = '{9FB0ED62-92CD-4E37-963F-FFC2BCB0CB89}';
  IID_ITradeClient: TGUID = '{DBE4FF07-1118-450F-8D83-5A2426115F36}';
  IID_ITradeEventData: TGUID = '{C3D93895-03AC-4FFE-A117-7948A6E53377}';
  IID_ITradeCustomText: TGUID = '{F6F696FF-1872-4748-9876-52395B64E4B1}';
  CLASS_Customisation: TGUID = '{C79C869B-1EA7-4E4D-93B0-9026BC56DC7B}';
  IID_ITradeEventTransaction: TGUID = '{41D740ED-BCED-4E0A-B3C2-37186F9BBC2A}';
  IID_ITradeConfiguration: TGUID = '{7B6B2EE4-A062-461A-9734-0E541F7A5172}';
  IID_ITradeUserProfile: TGUID = '{93037A36-68A8-49E5-8350-C2FE526CB0A1}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TTradeWindowIds
type
  TTradeWindowIds = TOleEnum;
const
  twiSystem = $00000000;
  twiLogin = $00000001;
  twiTransaction = $00000002;
  twiTransactionLine = $00000003;
  twiSerialNumbers = $00000004;
  twiTender = $00000005;

// Constants for enum TTradeHookStatus
type
  TTradeHookStatus = TOleEnum;
const
  thsDisabled = $00000000;
  thsEnabled = $00000001;
  thsEnabledOther = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ITradeConnectionPoint = interface;
  ITradeConnectionPointDisp = dispinterface;
  ITradeFunctions = interface;
  ITradeFunctionsDisp = dispinterface;
  ITradeSystemSetup = interface;
  ITradeSystemSetupDisp = dispinterface;
  ITradeVersion = interface;
  ITradeVersionDisp = dispinterface;
  IDummy = interface;
  IDummyDisp = dispinterface;
  ITradeClient = interface;
  ITradeClientDisp = dispinterface;
  ITradeEventData = interface;
  ITradeEventDataDisp = dispinterface;
  ITradeCustomText = interface;
  ITradeCustomTextDisp = dispinterface;
  ITradeEventTransaction = interface;
  ITradeEventTransactionDisp = dispinterface;
  ITradeConfiguration = interface;
  ITradeConfigurationDisp = dispinterface;
  ITradeUserProfile = interface;
  ITradeUserProfileDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Customisation = IDummy;


// *********************************************************************//
// Interface: ITradeConnectionPoint
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8AE10444-4EE7-4487-89B1-1995B5D06C2E}
// *********************************************************************//
  ITradeConnectionPoint = interface(IDispatch)
    ['{8AE10444-4EE7-4487-89B1-1995B5D06C2E}']
    function Get_piCustomisationSupport: WideString; safecall;
    procedure Set_piCustomisationSupport(const Value: WideString); safecall;
    function Get_piName: WideString; safecall;
    procedure Set_piName(const Value: WideString); safecall;
    function Get_piVersion: WideString; safecall;
    procedure Set_piVersion(const Value: WideString); safecall;
    function Get_piAuthor: WideString; safecall;
    procedure Set_piAuthor(const Value: WideString); safecall;
    function Get_piSupport: WideString; safecall;
    procedure Set_piSupport(const Value: WideString); safecall;
    function Get_piCopyright: WideString; safecall;
    procedure Set_piCopyright(const Value: WideString); safecall;
    function Get_piHookPoints(WindowId: TTradeWindowIds; HandlerId: Integer): TTradeHookStatus; safecall;
    procedure Set_piHookPoints(WindowId: TTradeWindowIds; HandlerId: Integer; 
                               Value: TTradeHookStatus); safecall;
    function Get_piCustomText(WindowId: TTradeWindowIds; TextId: Integer): TTradeHookStatus; safecall;
    procedure Set_piCustomText(WindowId: TTradeWindowIds; TextId: Integer; Value: TTradeHookStatus); safecall;
    function Get_Functions: ITradeFunctions; safecall;
    function Get_SystemSetup: ITradeSystemSetup; safecall;
    function Get_Version: ITradeVersion; safecall;
    function Get_UserProfile: ITradeUserProfile; safecall;
    property piCustomisationSupport: WideString read Get_piCustomisationSupport write Set_piCustomisationSupport;
    property piName: WideString read Get_piName write Set_piName;
    property piVersion: WideString read Get_piVersion write Set_piVersion;
    property piAuthor: WideString read Get_piAuthor write Set_piAuthor;
    property piSupport: WideString read Get_piSupport write Set_piSupport;
    property piCopyright: WideString read Get_piCopyright write Set_piCopyright;
    property piHookPoints[WindowId: TTradeWindowIds; HandlerId: Integer]: TTradeHookStatus read Get_piHookPoints write Set_piHookPoints;
    property piCustomText[WindowId: TTradeWindowIds; TextId: Integer]: TTradeHookStatus read Get_piCustomText write Set_piCustomText;
    property Functions: ITradeFunctions read Get_Functions;
    property SystemSetup: ITradeSystemSetup read Get_SystemSetup;
    property Version: ITradeVersion read Get_Version;
    property UserProfile: ITradeUserProfile read Get_UserProfile;
  end;

// *********************************************************************//
// DispIntf:  ITradeConnectionPointDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8AE10444-4EE7-4487-89B1-1995B5D06C2E}
// *********************************************************************//
  ITradeConnectionPointDisp = dispinterface
    ['{8AE10444-4EE7-4487-89B1-1995B5D06C2E}']
    property piCustomisationSupport: WideString dispid 1;
    property piName: WideString dispid 2;
    property piVersion: WideString dispid 3;
    property piAuthor: WideString dispid 4;
    property piSupport: WideString dispid 5;
    property piCopyright: WideString dispid 6;
    property piHookPoints[WindowId: TTradeWindowIds; HandlerId: Integer]: TTradeHookStatus dispid 7;
    property piCustomText[WindowId: TTradeWindowIds; TextId: Integer]: TTradeHookStatus dispid 8;
    property Functions: ITradeFunctions readonly dispid 9;
    property SystemSetup: ITradeSystemSetup readonly dispid 10;
    property Version: ITradeVersion readonly dispid 11;
    property UserProfile: ITradeUserProfile readonly dispid 12;
  end;

// *********************************************************************//
// Interface: ITradeFunctions
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {51A850EC-D45D-4D7A-BF98-692AB243F31F}
// *********************************************************************//
  ITradeFunctions = interface(IDispatch)
    ['{51A850EC-D45D-4D7A-BF98-692AB243F31F}']
    function Get_fnTradehWnd: Integer; safecall;
    procedure entActivateClient(ClientHandle: Integer); safecall;
    property fnTradehWnd: Integer read Get_fnTradehWnd;
  end;

// *********************************************************************//
// DispIntf:  ITradeFunctionsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {51A850EC-D45D-4D7A-BF98-692AB243F31F}
// *********************************************************************//
  ITradeFunctionsDisp = dispinterface
    ['{51A850EC-D45D-4D7A-BF98-692AB243F31F}']
    property fnTradehWnd: Integer readonly dispid 1;
    procedure entActivateClient(ClientHandle: Integer); dispid 5;
  end;

// *********************************************************************//
// Interface: ITradeSystemSetup
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E5797518-DC56-4CB3-AFE1-2C250CF6C1EB}
// *********************************************************************//
  ITradeSystemSetup = interface(IDispatch)
    ['{E5797518-DC56-4CB3-AFE1-2C250CF6C1EB}']
  end;

// *********************************************************************//
// DispIntf:  ITradeSystemSetupDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E5797518-DC56-4CB3-AFE1-2C250CF6C1EB}
// *********************************************************************//
  ITradeSystemSetupDisp = dispinterface
    ['{E5797518-DC56-4CB3-AFE1-2C250CF6C1EB}']
  end;

// *********************************************************************//
// Interface: ITradeVersion
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {59CBCFF0-E3CD-4FD2-9FD0-8960432675B3}
// *********************************************************************//
  ITradeVersion = interface(IDispatch)
    ['{59CBCFF0-E3CD-4FD2-9FD0-8960432675B3}']
  end;

// *********************************************************************//
// DispIntf:  ITradeVersionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {59CBCFF0-E3CD-4FD2-9FD0-8960432675B3}
// *********************************************************************//
  ITradeVersionDisp = dispinterface
    ['{59CBCFF0-E3CD-4FD2-9FD0-8960432675B3}']
  end;

// *********************************************************************//
// Interface: IDummy
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9FB0ED62-92CD-4E37-963F-FFC2BCB0CB89}
// *********************************************************************//
  IDummy = interface(IDispatch)
    ['{9FB0ED62-92CD-4E37-963F-FFC2BCB0CB89}']
  end;

// *********************************************************************//
// DispIntf:  IDummyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9FB0ED62-92CD-4E37-963F-FFC2BCB0CB89}
// *********************************************************************//
  IDummyDisp = dispinterface
    ['{9FB0ED62-92CD-4E37-963F-FFC2BCB0CB89}']
  end;

// *********************************************************************//
// Interface: ITradeClient
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DBE4FF07-1118-450F-8D83-5A2426115F36}
// *********************************************************************//
  ITradeClient = interface(IDispatch)
    ['{DBE4FF07-1118-450F-8D83-5A2426115F36}']
    procedure OnConfigure(const Config: ITradeConfiguration); safecall;
    procedure OnStartup(const BaseData: ITradeConnectionPoint); safecall;
    procedure OnCustomEvent(const EventData: ITradeEventData); safecall;
    procedure OnCustomText(const CustomText: ITradeCustomText); safecall;
    procedure OnShutdown; safecall;
  end;

// *********************************************************************//
// DispIntf:  ITradeClientDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DBE4FF07-1118-450F-8D83-5A2426115F36}
// *********************************************************************//
  ITradeClientDisp = dispinterface
    ['{DBE4FF07-1118-450F-8D83-5A2426115F36}']
    procedure OnConfigure(const Config: ITradeConfiguration); dispid 1;
    procedure OnStartup(const BaseData: ITradeConnectionPoint); dispid 2;
    procedure OnCustomEvent(const EventData: ITradeEventData); dispid 3;
    procedure OnCustomText(const CustomText: ITradeCustomText); dispid 4;
    procedure OnShutdown; dispid 5;
  end;

// *********************************************************************//
// Interface: ITradeEventData
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C3D93895-03AC-4FFE-A117-7948A6E53377}
// *********************************************************************//
  ITradeEventData = interface(IDispatch)
    ['{C3D93895-03AC-4FFE-A117-7948A6E53377}']
    function Get_edWindowId: TTradeWindowIds; safecall;
    function Get_edHandlerId: Integer; safecall;
    function Get_Customer: Integer; safecall;
    function Get_Stock: Integer; safecall;
    function Get_Transaction: ITradeEventTransaction; safecall;
    property edWindowId: TTradeWindowIds read Get_edWindowId;
    property edHandlerId: Integer read Get_edHandlerId;
    property Customer: Integer read Get_Customer;
    property Stock: Integer read Get_Stock;
    property Transaction: ITradeEventTransaction read Get_Transaction;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventDataDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C3D93895-03AC-4FFE-A117-7948A6E53377}
// *********************************************************************//
  ITradeEventDataDisp = dispinterface
    ['{C3D93895-03AC-4FFE-A117-7948A6E53377}']
    property edWindowId: TTradeWindowIds readonly dispid 1;
    property edHandlerId: Integer readonly dispid 2;
    property Customer: Integer readonly dispid 3;
    property Stock: Integer readonly dispid 4;
    property Transaction: ITradeEventTransaction readonly dispid 5;
  end;

// *********************************************************************//
// Interface: ITradeCustomText
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F6F696FF-1872-4748-9876-52395B64E4B1}
// *********************************************************************//
  ITradeCustomText = interface(IDispatch)
    ['{F6F696FF-1872-4748-9876-52395B64E4B1}']
    function Get_ctWindowId: TTradeWindowIds; safecall;
    function Get_ctTextId: Integer; safecall;
    function Get_ctText: WideString; safecall;
    procedure Set_ctText(const Value: WideString); safecall;
    property ctWindowId: TTradeWindowIds read Get_ctWindowId;
    property ctTextId: Integer read Get_ctTextId;
    property ctText: WideString read Get_ctText write Set_ctText;
  end;

// *********************************************************************//
// DispIntf:  ITradeCustomTextDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F6F696FF-1872-4748-9876-52395B64E4B1}
// *********************************************************************//
  ITradeCustomTextDisp = dispinterface
    ['{F6F696FF-1872-4748-9876-52395B64E4B1}']
    property ctWindowId: TTradeWindowIds readonly dispid 1;
    property ctTextId: Integer readonly dispid 2;
    property ctText: WideString dispid 3;
  end;

// *********************************************************************//
// Interface: ITradeEventTransaction
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {41D740ED-BCED-4E0A-B3C2-37186F9BBC2A}
// *********************************************************************//
  ITradeEventTransaction = interface(IDispatch)
    ['{41D740ED-BCED-4E0A-B3C2-37186F9BBC2A}']
    function Get_Edit1: WideString; safecall;
    procedure Set_Edit1(const Value: WideString); safecall;
    function Get_Edit2: WideString; safecall;
    procedure Set_Edit2(const Value: WideString); safecall;
    function Get_Edit3: WideString; safecall;
    procedure Set_Edit3(const Value: WideString); safecall;
    property Edit1: WideString read Get_Edit1 write Set_Edit1;
    property Edit2: WideString read Get_Edit2 write Set_Edit2;
    property Edit3: WideString read Get_Edit3 write Set_Edit3;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventTransactionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {41D740ED-BCED-4E0A-B3C2-37186F9BBC2A}
// *********************************************************************//
  ITradeEventTransactionDisp = dispinterface
    ['{41D740ED-BCED-4E0A-B3C2-37186F9BBC2A}']
    property Edit1: WideString dispid 1;
    property Edit2: WideString dispid 2;
    property Edit3: WideString dispid 3;
  end;

// *********************************************************************//
// Interface: ITradeConfiguration
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7B6B2EE4-A062-461A-9734-0E541F7A5172}
// *********************************************************************//
  ITradeConfiguration = interface(IDispatch)
    ['{7B6B2EE4-A062-461A-9734-0E541F7A5172}']
    function Get_cfEnterpriseDirectory: WideString; safecall;
    function Get_cfDataDirectory: WideString; safecall;
    function Get_cfLocalTradeDirectory: WideString; safecall;
    property cfEnterpriseDirectory: WideString read Get_cfEnterpriseDirectory;
    property cfDataDirectory: WideString read Get_cfDataDirectory;
    property cfLocalTradeDirectory: WideString read Get_cfLocalTradeDirectory;
  end;

// *********************************************************************//
// DispIntf:  ITradeConfigurationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7B6B2EE4-A062-461A-9734-0E541F7A5172}
// *********************************************************************//
  ITradeConfigurationDisp = dispinterface
    ['{7B6B2EE4-A062-461A-9734-0E541F7A5172}']
    property cfEnterpriseDirectory: WideString readonly dispid 2;
    property cfDataDirectory: WideString readonly dispid 3;
    property cfLocalTradeDirectory: WideString readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ITradeUserProfile
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {93037A36-68A8-49E5-8350-C2FE526CB0A1}
// *********************************************************************//
  ITradeUserProfile = interface(IDispatch)
    ['{93037A36-68A8-49E5-8350-C2FE526CB0A1}']
  end;

// *********************************************************************//
// DispIntf:  ITradeUserProfileDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {93037A36-68A8-49E5-8350-C2FE526CB0A1}
// *********************************************************************//
  ITradeUserProfileDisp = dispinterface
    ['{93037A36-68A8-49E5-8350-C2FE526CB0A1}']
  end;

// *********************************************************************//
// The Class CoCustomisation provides a Create and CreateRemote method to          
// create instances of the default interface IDummy exposed by              
// the CoClass Customisation. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCustomisation = class
    class function Create: IDummy;
    class function CreateRemote(const MachineName: string): IDummy;
  end;

implementation

uses ComObj;

class function CoCustomisation.Create: IDummy;
begin
  Result := CreateComObject(CLASS_Customisation) as IDummy;
end;

class function CoCustomisation.CreateRemote(const MachineName: string): IDummy;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Customisation) as IDummy;
end;

end.
