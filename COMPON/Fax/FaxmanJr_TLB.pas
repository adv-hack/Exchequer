unit FaxmanJr_TLB;

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
// File generated on 12/03/2010 10:45:55 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\FaxManJr2.2\Distrib\FMJR10.dll (1)
// LIBID: {07728B40-6223-11D2-BA57-00002149093D}
// LCID: 0
// Helpfile: C:\Program Files\FaxManJr2.2\Distrib\faxmanjr.chm
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// Errors:
//   Hint: TypeInfo 'FaxmanJr' changed to 'FaxmanJr_'
//   Hint: Member 'Class' of 'IFaxManJr' changed to 'Class_'
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  FaxmanJrMajorVersion = 1;
  FaxmanJrMinorVersion = 0;

  LIBID_FaxmanJr: TGUID = '{07728B40-6223-11D2-BA57-00002149093D}';

  DIID__FaxManJrEvents: TGUID = '{FAE5F620-4CA5-11D1-BA12-00002149093D}';
  IID_IFaxStatusObj: TGUID = '{154E5B72-8874-11D2-BA61-00002149093D}';
  IID_IFaxManJr: TGUID = '{07728B4F-6223-11D2-BA57-00002149093D}';
  CLASS_FaxmanJr_: TGUID = '{07728B50-6223-11D2-BA57-00002149093D}';
  IID_IFaxFinder: TGUID = '{A5929EC4-74CF-11D2-BA5E-00002149093D}';
  CLASS_FaxFinder: TGUID = '{A5929EC5-74CF-11D2-BA5E-00002149093D}';
  IID_IDeviceDesc: TGUID = '{A5929EC6-74CF-11D2-BA5E-00002149093D}';
  CLASS_DeviceDesc: TGUID = '{A5929EC7-74CF-11D2-BA5E-00002149093D}';
  CLASS_FaxStatusObj: TGUID = '{154E5B73-8874-11D2-BA61-00002149093D}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum _FAXSTATE
type
  _FAXSTATE = TOleEnum;
const
  FAXST_ERROR = $00000000;
  FAXST_OK = $00000001;
  FAXST_INIT = $00000002;
  FAXST_WAITFORSEND = $00000003;
  FAXST_SEND_INIT = $00000004;
  FAXST_SEND_DIALING = $00000005;
  FAXST_SEND_WAIT_FCON = $00000006;
  FAXST_SEND_FCON = $00000007;
  FAXST_SEND_WAIT_FCSI = $00000008;
  FAXST_SEND_FCSI = $00000009;
  FAXST_SEND_WAIT_FDIS = $0000000A;
  FAXST_SEND_FDIS = $0000000B;
  FAXST_SEND_WAIT_CONNECT = $0000000C;
  FAXST_SEND_FDCS = $0000000D;
  FAXST_SENDING = $0000000E;
  FAXST_PAGE_END = $0000000F;
  FAXST_PORTSHUT = $00000010;
  FAXST_ABORT = $00000011;
  FAXST_COMPLETE = $00000012;
  FAXST_INITRX = $00000013;
  FAXST_WAITFORRX = $00000014;
  FAXST_ANSWERING = $00000015;
  FAXST_RX_NEGOTIATE = $00000016;
  FAXST_RXDATA = $00000017;
  FAXST_RX_PAGE_END = $00000018;
  FAXST_FAXJOB_DONE = $00000019;
  FAXST_SEND_10 = $0000001A;
  FAXST_SEND_20 = $0000001B;
  FAXST_SEND_30 = $0000001C;
  FAXST_SEND_40 = $0000001D;
  FAXST_SEND_50 = $0000001E;
  FAXST_SEND_60 = $0000001F;
  FAXST_SEND_70 = $00000020;
  FAXST_SEND_80 = $00000021;
  FAXST_SEND_90 = $00000022;
  FAXST_SEND_100 = $00000023;
  FAXST_RING = $00000024;

// Constants for enum _FAXERROR
type
  _FAXERROR = TOleEnum;
const
  FAXERR_OK = $00000000;
  FAXERR_ACK = $00000001;
  FAXERR_BADFAXMODEM = $00000002;
  FAXERR_INIT = $00000003;
  FAXERR_FDIS = $00000004;
  FAXERR_FLID = $00000005;
  FAXERR_DIAL = $00000006;
  FAXERR_FCON_ERR = $00000007;
  FAXERR_FCSI = $00000008;
  FAXERR_NEG_FDIS = $00000009;
  FAXERR_BADSTATE = $0000000A;
  FAXERR_BUSY = $0000000B;
  FAXERR_NODIALTONE = $0000000C;
  FAXERR_NOCONNECT = $0000000D;
  FAXERR_CANCEL = $0000000E;
  FAXERR_FPTS = $0000000F;
  FAXERR_FHNG = $00000010;
  FAXERR_FDCS = $00000011;
  FAXERR_ERROR = $00000012;
  FAXERR_FILE = $00000013;
  FAXERR_VERSION = $00000014;
  FAXERR_TIMEOUT = $00000015;
  FAXERR_NO_MPS_RESP = $00000016;
  FAXERR_NO_EOP_RESP = $00000017;
  FAXERR_NOTRAIN = $00000018;
  FAXERR_PORTINIT = $00000019;
  FAXERR_KILLED = $0000001A;
  FAXERR_NOANSWER = $0000001B;
  FAXERR_NO_DEL = $000003E8;
  FAXERR_NO_DIL = $000003E9;
  FAXERR_BAD_FORMAT = $000003EA;
  FAXERR_READ_ERR = $000003EB;
  FAXERR_WRITE_ERR = $000003EC;

// Constants for enum _GENERIC_FAX_ERROR
type
  _GENERIC_FAX_ERROR = TOleEnum;
const
  GEN_FAXERR_OK = $000007D0;
  GEN_FAXERR_INIT = $000007D1;
  GEN_FAXERR_DIAL = $000007D2;
  GEN_FAXERR_CONNECT = $000007D3;
  GEN_FAXERR_PHASE_B = $000007D4;
  GEN_FAXERR_BUSY = $000007D5;
  GEN_FAXERR_NODIALTONE = $000007D6;
  GEN_FAXERR_NOCONNECT = $000007D7;
  GEN_FAXERR_CANCEL = $000007D8;
  GEN_FAXERR_ERROR = $000007D9;
  GEN_FAXERR_FILE = $000007DA;
  GEN_FAXERR_PHASE_C = $000007DB;
  GEN_FAXERR_PHASE_D = $000007DC;
  GEN_FAXERR_NOTRAIN = $000007DD;
  GEN_FAXERR_PORTINIT = $000007DE;
  GEN_FAXERR_KILLED = $000007DF;
  GEN_FAXERR_NO_DEL = $00000BB8;
  GEN_FAXERR_NO_DIL = $00000BB9;
  GEN_FAXERR_BAD_FORMAT = $00000BBA;
  GEN_FAXERR_READ_ERR = $00000BBB;
  GEN_FAXERR_WRITE_ERR = $00000BBC;

// Constants for enum Resolution
type
  Resolution = TOleEnum;
const
  Low = $00000000;
  High = $00000001;

// Constants for enum FAX_DEV_CLASS
type
  FAX_DEV_CLASS = TOleEnum;
const
  FAX_0 = $00000000;
  FAX_1 = $00000001;
  FAX_2 = $00000002;
  FAX_20 = $00000003;
  FAX_21 = $00000004;

// Constants for enum FAX_DEV_TECH
type
  FAX_DEV_TECH = TOleEnum;
const
  FAXTECH_CLASSX = $00000001;
  FAXTECH_BROOKTROUT = $00000002;
  FAXTECH_GAMMAFAX = $00000004;

// Constants for enum __MIDL___MIDL_itf_newjr_0000_0001
type
  __MIDL___MIDL_itf_newjr_0000_0001 = TOleEnum;
const
  FAXJR_ERR_NO_FILELIST = $00007D00;
  FAXJR_ERR_PORT = $00007D01;
  FAXJR_ERR_CLASS = $00007D02;
  FAXJR_ERR_PORT_IN_USE = $00007D03;
  FAXJR_ERR_NO_FAXDEVICE = $00007D04;
  FAXJR_ERR_NO_DETECT_OBJECT = $00007D05;
  FAXJR_ERR_BAD_RINGCOUNT = $00007D06;
  FAXJR_ERR_NO_THREAD = $00007D07;

// Constants for enum __MIDL___MIDL_itf_newjr_0000_0002
type
  __MIDL___MIDL_itf_newjr_0000_0002 = TOleEnum;
const
  EVENT_STATUS = $00000001;
  EVENT_NEGOTIATION = $00000002;
  EVENT_PAGES = $00000003;
  EVENT_STARTTIME = $00000004;
  EVENT_ENDTIME = $00000005;
  EVENT_COMPLETE = $00000006;
  EVENT_RECEIVE_FILENAME = $00000007;
  EVENT_TIMEOUT = $00000008;

// Constants for enum _DEVICE_STAT
type
  _DEVICE_STAT = TOleEnum;
const
  DEV_READY = $00000001;
  DEV_SENDING = $00000002;
  DEV_LISTENING = $00000003;
  DEV_RECEIVING = $00000004;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _FaxManJrEvents = dispinterface;
  IFaxStatusObj = interface;
  IFaxStatusObjDisp = dispinterface;
  IFaxManJr = interface;
  IFaxManJrDisp = dispinterface;
  IFaxFinder = interface;
  IFaxFinderDisp = dispinterface;
  IDeviceDesc = interface;
  IDeviceDescDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FaxmanJr_ = IFaxManJr;
  FaxFinder = IFaxFinder;
  DeviceDesc = IDeviceDesc;
  FaxStatusObj = IFaxStatusObj;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//

  FAXJR_ERRORS = __MIDL___MIDL_itf_newjr_0000_0001; 
  STATUS_EVENT_TYPES = __MIDL___MIDL_itf_newjr_0000_0002; 

// *********************************************************************//
// DispIntf:  _FaxManJrEvents
// Flags:     (4096) Dispatchable
// GUID:      {FAE5F620-4CA5-11D1-BA12-00002149093D}
// *********************************************************************//
  _FaxManJrEvents = dispinterface
    ['{FAE5F620-4CA5-11D1-BA12-00002149093D}']
    procedure Status(const pStatObj: IFaxStatusObj); dispid 1;
    procedure Message(const bsMsg: WideString; bNewLine: Smallint); dispid 2;
    procedure NegotiatedParms(const pStatObj: IFaxStatusObj); dispid 3;
    procedure Pages(const pStatObj: IFaxStatusObj); dispid 4;
    procedure StartTime(const pStatObj: IFaxStatusObj); dispid 5;
    procedure EndTime(const pStatObj: IFaxStatusObj); dispid 6;
    procedure CompletionStatus(const pStatObj: IFaxStatusObj); dispid 7;
    procedure Ring(out pnAction: Smallint); dispid 8;
    procedure ReceiveFileName(const pStatObj: IFaxStatusObj); dispid 9;
  end;

// *********************************************************************//
// Interface: IFaxStatusObj
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {154E5B72-8874-11D2-BA61-00002149093D}
// *********************************************************************//
  IFaxStatusObj = interface(IDispatch)
    ['{154E5B72-8874-11D2-BA61-00002149093D}']
    function Get_RemoteID: WideString; safecall;
    procedure Set_RemoteID(const pVal: WideString); safecall;
    function Get_ConnectSpeed: Integer; safecall;
    procedure Set_ConnectSpeed(pVal: Integer); safecall;
    function Get_LastEventType: Smallint; safecall;
    procedure Set_LastEventType(pVal: Smallint); safecall;
    function Get_NegotiatedResolution: Smallint; safecall;
    procedure Set_NegotiatedResolution(pVal: Smallint); safecall;
    function Get_CurrentStatus: Integer; safecall;
    procedure Set_CurrentStatus(pVal: Integer); safecall;
    function Get_StartTime: Integer; safecall;
    procedure Set_StartTime(pVal: Integer); safecall;
    function Get_EndTime: Integer; safecall;
    procedure Set_EndTime(pVal: Integer); safecall;
    function Get_ReceiveFileName: WideString; safecall;
    procedure Set_ReceiveFileName(const pVal: WideString); safecall;
    function Get_Pages: Smallint; safecall;
    procedure Set_Pages(pVal: Smallint); safecall;
    function Get_ErrorCode: Integer; safecall;
    procedure Set_ErrorCode(pVal: Integer); safecall;
    function Get_ErrorDesc: WideString; safecall;
    procedure Set_ErrorDesc(const pVal: WideString); safecall;
    function Get_PagesCompleted: Smallint; safecall;
    procedure Set_PagesCompleted(pVal: Smallint); safecall;
    function Get_CurrentStatusDesc: WideString; safecall;
    procedure Set_CurrentStatusDesc(const pVal: WideString); safecall;
    property RemoteID: WideString read Get_RemoteID write Set_RemoteID;
    property ConnectSpeed: Integer read Get_ConnectSpeed write Set_ConnectSpeed;
    property LastEventType: Smallint read Get_LastEventType write Set_LastEventType;
    property NegotiatedResolution: Smallint read Get_NegotiatedResolution write Set_NegotiatedResolution;
    property CurrentStatus: Integer read Get_CurrentStatus write Set_CurrentStatus;
    property StartTime: Integer read Get_StartTime write Set_StartTime;
    property EndTime: Integer read Get_EndTime write Set_EndTime;
    property ReceiveFileName: WideString read Get_ReceiveFileName write Set_ReceiveFileName;
    property Pages: Smallint read Get_Pages write Set_Pages;
    property ErrorCode: Integer read Get_ErrorCode write Set_ErrorCode;
    property ErrorDesc: WideString read Get_ErrorDesc write Set_ErrorDesc;
    property PagesCompleted: Smallint read Get_PagesCompleted write Set_PagesCompleted;
    property CurrentStatusDesc: WideString read Get_CurrentStatusDesc write Set_CurrentStatusDesc;
  end;

// *********************************************************************//
// DispIntf:  IFaxStatusObjDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {154E5B72-8874-11D2-BA61-00002149093D}
// *********************************************************************//
  IFaxStatusObjDisp = dispinterface
    ['{154E5B72-8874-11D2-BA61-00002149093D}']
    property RemoteID: WideString dispid 1;
    property ConnectSpeed: Integer dispid 2;
    property LastEventType: Smallint dispid 3;
    property NegotiatedResolution: Smallint dispid 4;
    property CurrentStatus: Integer dispid 5;
    property StartTime: Integer dispid 6;
    property EndTime: Integer dispid 7;
    property ReceiveFileName: WideString dispid 8;
    property Pages: Smallint dispid 9;
    property ErrorCode: Integer dispid 10;
    property ErrorDesc: WideString dispid 11;
    property PagesCompleted: Smallint dispid 12;
    property CurrentStatusDesc: WideString dispid 13;
  end;

// *********************************************************************//
// Interface: IFaxManJr
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {07728B4F-6223-11D2-BA57-00002149093D}
// *********************************************************************//
  IFaxManJr = interface(IDispatch)
    ['{07728B4F-6223-11D2-BA57-00002149093D}']
    function Get_FaxNumber: WideString; safecall;
    procedure Set_FaxNumber(const pVal: WideString); safecall;
    function Get_FaxName: WideString; safecall;
    procedure Set_FaxName(const pVal: WideString); safecall;
    function Get_FaxSubject: WideString; safecall;
    procedure Set_FaxSubject(const pVal: WideString); safecall;
    function Get_UserName: WideString; safecall;
    procedure Set_UserName(const pVal: WideString); safecall;
    function Get_FaxBanner: WideString; safecall;
    procedure Set_FaxBanner(const pVal: WideString); safecall;
    function Get_FaxCoverPage: WideString; safecall;
    procedure Set_FaxCoverPage(const pVal: WideString); safecall;
    function Get_FaxComments: WideString; safecall;
    procedure Set_FaxComments(const pVal: WideString); safecall;
    function Get_UserCompany: WideString; safecall;
    procedure Set_UserCompany(const pVal: WideString); safecall;
    function Get_FaxCompany: WideString; safecall;
    procedure Set_FaxCompany(const pVal: WideString); safecall;
    function Get_UserFaxNumber: WideString; safecall;
    procedure Set_UserFaxNumber(const pVal: WideString); safecall;
    function Get_UserVoiceNumber: WideString; safecall;
    procedure Set_UserVoiceNumber(const pVal: WideString); safecall;
    function Get_FaxUserData: WideString; safecall;
    procedure Set_FaxUserData(const pVal: WideString); safecall;
    function Get_LocalID: WideString; safecall;
    procedure Set_LocalID(const pVal: WideString); safecall;
    function Get_FaxFiles: WideString; safecall;
    procedure Set_FaxFiles(const pVal: WideString); safecall;
    function Get_Port: Smallint; safecall;
    procedure Set_Port(pVal: Smallint); safecall;
    procedure SendFax; safecall;
    function Get_Class_: FAX_DEV_CLASS; safecall;
    procedure Set_Class_(pVal: FAX_DEV_CLASS); safecall;
    function Get_DeviceReset: WideString; safecall;
    procedure Set_DeviceReset(const pVal: WideString); safecall;
    function Get_DeviceInit: WideString; safecall;
    procedure Set_DeviceInit(const pVal: WideString); safecall;
    function Get_FaxResolution: Resolution; safecall;
    procedure Set_FaxResolution(pVal: Resolution); safecall;
    procedure CancelFax; safecall;
    function Get_ReceiveDir: WideString; safecall;
    procedure Set_ReceiveDir(const pVal: WideString); safecall;
    procedure Receive(nRingCnt: Smallint); safecall;
    procedure ImportFiles(const pszOutFile: WideString; const pszInFiles: WideString); safecall;
    procedure Listen; safecall;
    function Get_Status: _DEVICE_STAT; safecall;
    procedure Set_CommHandle(Param1: Integer); safecall;
    procedure WaitForEvent(lWaitTime: Integer); safecall;
    function Get_StatusObject: IFaxStatusObj; safecall;
    property FaxNumber: WideString read Get_FaxNumber write Set_FaxNumber;
    property FaxName: WideString read Get_FaxName write Set_FaxName;
    property FaxSubject: WideString read Get_FaxSubject write Set_FaxSubject;
    property UserName: WideString read Get_UserName write Set_UserName;
    property FaxBanner: WideString read Get_FaxBanner write Set_FaxBanner;
    property FaxCoverPage: WideString read Get_FaxCoverPage write Set_FaxCoverPage;
    property FaxComments: WideString read Get_FaxComments write Set_FaxComments;
    property UserCompany: WideString read Get_UserCompany write Set_UserCompany;
    property FaxCompany: WideString read Get_FaxCompany write Set_FaxCompany;
    property UserFaxNumber: WideString read Get_UserFaxNumber write Set_UserFaxNumber;
    property UserVoiceNumber: WideString read Get_UserVoiceNumber write Set_UserVoiceNumber;
    property FaxUserData: WideString read Get_FaxUserData write Set_FaxUserData;
    property LocalID: WideString read Get_LocalID write Set_LocalID;
    property FaxFiles: WideString read Get_FaxFiles write Set_FaxFiles;
    property Port: Smallint read Get_Port write Set_Port;
    property Class_: FAX_DEV_CLASS read Get_Class_ write Set_Class_;
    property DeviceReset: WideString read Get_DeviceReset write Set_DeviceReset;
    property DeviceInit: WideString read Get_DeviceInit write Set_DeviceInit;
    property FaxResolution: Resolution read Get_FaxResolution write Set_FaxResolution;
    property ReceiveDir: WideString read Get_ReceiveDir write Set_ReceiveDir;
    property Status: _DEVICE_STAT read Get_Status;
    property CommHandle: Integer write Set_CommHandle;
    property StatusObject: IFaxStatusObj read Get_StatusObject;
  end;

// *********************************************************************//
// DispIntf:  IFaxManJrDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {07728B4F-6223-11D2-BA57-00002149093D}
// *********************************************************************//
  IFaxManJrDisp = dispinterface
    ['{07728B4F-6223-11D2-BA57-00002149093D}']
    property FaxNumber: WideString dispid 1;
    property FaxName: WideString dispid 2;
    property FaxSubject: WideString dispid 3;
    property UserName: WideString dispid 4;
    property FaxBanner: WideString dispid 5;
    property FaxCoverPage: WideString dispid 6;
    property FaxComments: WideString dispid 7;
    property UserCompany: WideString dispid 8;
    property FaxCompany: WideString dispid 9;
    property UserFaxNumber: WideString dispid 10;
    property UserVoiceNumber: WideString dispid 11;
    property FaxUserData: WideString dispid 12;
    property LocalID: WideString dispid 13;
    property FaxFiles: WideString dispid 14;
    property Port: Smallint dispid 15;
    procedure SendFax; dispid 16;
    property Class_: FAX_DEV_CLASS dispid 17;
    property DeviceReset: WideString dispid 18;
    property DeviceInit: WideString dispid 19;
    property FaxResolution: Resolution dispid 21;
    procedure CancelFax; dispid 28;
    property ReceiveDir: WideString dispid 29;
    procedure Receive(nRingCnt: Smallint); dispid 30;
    procedure ImportFiles(const pszOutFile: WideString; const pszInFiles: WideString); dispid 32;
    procedure Listen; dispid 33;
    property Status: _DEVICE_STAT readonly dispid 36;
    property CommHandle: Integer writeonly dispid 37;
    procedure WaitForEvent(lWaitTime: Integer); dispid 38;
    property StatusObject: IFaxStatusObj readonly dispid 39;
  end;

// *********************************************************************//
// Interface: IFaxFinder
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A5929EC4-74CF-11D2-BA5E-00002149093D}
// *********************************************************************//
  IFaxFinder = interface(IDispatch)
    ['{A5929EC4-74CF-11D2-BA5E-00002149093D}']
    function Get_Item(nIndex: Smallint): IDeviceDesc; safecall;
    function Get_DeviceCount: Smallint; safecall;
    procedure AutoDetect; safecall;
    property Item[nIndex: Smallint]: IDeviceDesc read Get_Item; default;
    property DeviceCount: Smallint read Get_DeviceCount;
  end;

// *********************************************************************//
// DispIntf:  IFaxFinderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A5929EC4-74CF-11D2-BA5E-00002149093D}
// *********************************************************************//
  IFaxFinderDisp = dispinterface
    ['{A5929EC4-74CF-11D2-BA5E-00002149093D}']
    property Item[nIndex: Smallint]: IDeviceDesc readonly dispid 0; default;
    property DeviceCount: Smallint readonly dispid 1;
    procedure AutoDetect; dispid 2;
  end;

// *********************************************************************//
// Interface: IDeviceDesc
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A5929EC6-74CF-11D2-BA5E-00002149093D}
// *********************************************************************//
  IDeviceDesc = interface(IDispatch)
    ['{A5929EC6-74CF-11D2-BA5E-00002149093D}']
    function Get_Port: Smallint; safecall;
    function Get_bClass1: Integer; safecall;
    function Get_bClass2: Integer; safecall;
    function Get_bClass20: Integer; safecall;
    function Get_bClass21: Integer; safecall;
    procedure _Init(nPort: Smallint; nDevFlags: Smallint); safecall;
    property Port: Smallint read Get_Port;
    property bClass1: Integer read Get_bClass1;
    property bClass2: Integer read Get_bClass2;
    property bClass20: Integer read Get_bClass20;
    property bClass21: Integer read Get_bClass21;
  end;

// *********************************************************************//
// DispIntf:  IDeviceDescDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A5929EC6-74CF-11D2-BA5E-00002149093D}
// *********************************************************************//
  IDeviceDescDisp = dispinterface
    ['{A5929EC6-74CF-11D2-BA5E-00002149093D}']
    property Port: Smallint readonly dispid 1;
    property bClass1: Integer readonly dispid 2;
    property bClass2: Integer readonly dispid 3;
    property bClass20: Integer readonly dispid 4;
    property bClass21: Integer readonly dispid 6;
    procedure _Init(nPort: Smallint; nDevFlags: Smallint); dispid 5;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TFaxmanJr
// Help String      : FaxMan Jr. Class
// Default Interface: IFaxManJr
// Def. Intf. DISP? : No
// Event   Interface: _FaxManJrEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TFaxmanJrStatus = procedure(Sender: TObject; const pStatObj: IFaxStatusObj) of object;
  TFaxmanJrMessage = procedure(Sender: TObject; const bsMsg: WideString; bNewLine: Smallint) of object;
  TFaxmanJrNegotiatedParms = procedure(Sender: TObject; const pStatObj: IFaxStatusObj) of object;
  TFaxmanJrPages = procedure(Sender: TObject; const pStatObj: IFaxStatusObj) of object;
  TFaxmanJrStartTime = procedure(Sender: TObject; const pStatObj: IFaxStatusObj) of object;
  TFaxmanJrEndTime = procedure(Sender: TObject; const pStatObj: IFaxStatusObj) of object;
  TFaxmanJrCompletionStatus = procedure(Sender: TObject; const pStatObj: IFaxStatusObj) of object;
  TFaxmanJrRing = procedure(Sender: TObject; out pnAction: Smallint) of object;
  TFaxmanJrReceiveFileName = procedure(Sender: TObject; const pStatObj: IFaxStatusObj) of object;

  TFaxmanJr = class(TOleControl)
  private
    FOnStatus: TFaxmanJrStatus;
    FOnMessage: TFaxmanJrMessage;
    FOnNegotiatedParms: TFaxmanJrNegotiatedParms;
    FOnPages: TFaxmanJrPages;
    FOnStartTime: TFaxmanJrStartTime;
    FOnEndTime: TFaxmanJrEndTime;
    FOnCompletionStatus: TFaxmanJrCompletionStatus;
    FOnRing: TFaxmanJrRing;
    FOnReceiveFileName: TFaxmanJrReceiveFileName;
    FIntf: IFaxManJr;
    function  GetControlInterface: IFaxManJr;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_StatusObject: IFaxStatusObj;
  public
    procedure SendFax;
    procedure CancelFax;
    procedure Receive(nRingCnt: Smallint);
    procedure ImportFiles(const pszOutFile: WideString; const pszInFiles: WideString);
    procedure Listen;
    procedure WaitForEvent(lWaitTime: Integer);
    property  ControlInterface: IFaxManJr read GetControlInterface;
    property  DefaultInterface: IFaxManJr read GetControlInterface;
    property Status: TOleEnum index 36 read GetTOleEnumProp;
    property CommHandle: Integer index 37 write SetIntegerProp;
    property StatusObject: IFaxStatusObj read Get_StatusObject;
  published
    property FaxNumber: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property FaxName: WideString index 2 read GetWideStringProp write SetWideStringProp stored False;
    property FaxSubject: WideString index 3 read GetWideStringProp write SetWideStringProp stored False;
    property UserName: WideString index 4 read GetWideStringProp write SetWideStringProp stored False;
    property FaxBanner: WideString index 5 read GetWideStringProp write SetWideStringProp stored False;
    property FaxCoverPage: WideString index 6 read GetWideStringProp write SetWideStringProp stored False;
    property FaxComments: WideString index 7 read GetWideStringProp write SetWideStringProp stored False;
    property UserCompany: WideString index 8 read GetWideStringProp write SetWideStringProp stored False;
    property FaxCompany: WideString index 9 read GetWideStringProp write SetWideStringProp stored False;
    property UserFaxNumber: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property UserVoiceNumber: WideString index 11 read GetWideStringProp write SetWideStringProp stored False;
    property FaxUserData: WideString index 12 read GetWideStringProp write SetWideStringProp stored False;
    property LocalID: WideString index 13 read GetWideStringProp write SetWideStringProp stored False;
    property FaxFiles: WideString index 14 read GetWideStringProp write SetWideStringProp stored False;
    property Port: Smallint index 15 read GetSmallintProp write SetSmallintProp stored False;
    property Class_: TOleEnum index 17 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property DeviceReset: WideString index 18 read GetWideStringProp write SetWideStringProp stored False;
    property DeviceInit: WideString index 19 read GetWideStringProp write SetWideStringProp stored False;
    property FaxResolution: TOleEnum index 21 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property ReceiveDir: WideString index 29 read GetWideStringProp write SetWideStringProp stored False;
    property OnStatus: TFaxmanJrStatus read FOnStatus write FOnStatus;
    property OnMessage: TFaxmanJrMessage read FOnMessage write FOnMessage;
    property OnNegotiatedParms: TFaxmanJrNegotiatedParms read FOnNegotiatedParms write FOnNegotiatedParms;
    property OnPages: TFaxmanJrPages read FOnPages write FOnPages;
    property OnStartTime: TFaxmanJrStartTime read FOnStartTime write FOnStartTime;
    property OnEndTime: TFaxmanJrEndTime read FOnEndTime write FOnEndTime;
    property OnCompletionStatus: TFaxmanJrCompletionStatus read FOnCompletionStatus write FOnCompletionStatus;
    property OnRing: TFaxmanJrRing read FOnRing write FOnRing;
    property OnReceiveFileName: TFaxmanJrReceiveFileName read FOnReceiveFileName write FOnReceiveFileName;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TFaxFinder
// Help String      : FaxFinder Class
// Default Interface: IFaxFinder
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TFaxFinder = class(TOleControl)
  private
    FIntf: IFaxFinder;
    function  GetControlInterface: IFaxFinder;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_Item(nIndex: Smallint): IDeviceDesc;
  public
    procedure AutoDetect;
    property  ControlInterface: IFaxFinder read GetControlInterface;
    property  DefaultInterface: IFaxFinder read GetControlInterface;
    property Item[nIndex: Smallint]: IDeviceDesc read Get_Item; default;
    property DeviceCount: Smallint index 1 read GetSmallintProp;
  published
  end;

// *********************************************************************//
// The Class CoDeviceDesc provides a Create and CreateRemote method to          
// create instances of the default interface IDeviceDesc exposed by              
// the CoClass DeviceDesc. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDeviceDesc = class
    class function Create: IDeviceDesc;
    class function CreateRemote(const MachineName: string): IDeviceDesc;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDeviceDesc
// Help String      : DeviceDesc Class
// Default Interface: IDeviceDesc
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDeviceDescProperties= class;
{$ENDIF}
  TDeviceDesc = class(TOleServer)
  private
    FIntf:        IDeviceDesc;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDeviceDescProperties;
    function      GetServerProperties: TDeviceDescProperties;
{$ENDIF}
    function      GetDefaultInterface: IDeviceDesc;
  protected
    procedure InitServerData; override;
    function Get_Port: Smallint;
    function Get_bClass1: Integer;
    function Get_bClass2: Integer;
    function Get_bClass20: Integer;
    function Get_bClass21: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDeviceDesc);
    procedure Disconnect; override;
    procedure _Init(nPort: Smallint; nDevFlags: Smallint);
    property DefaultInterface: IDeviceDesc read GetDefaultInterface;
    property Port: Smallint read Get_Port;
    property bClass1: Integer read Get_bClass1;
    property bClass2: Integer read Get_bClass2;
    property bClass20: Integer read Get_bClass20;
    property bClass21: Integer read Get_bClass21;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDeviceDescProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TDeviceDesc
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TDeviceDescProperties = class(TPersistent)
  private
    FServer:    TDeviceDesc;
    function    GetDefaultInterface: IDeviceDesc;
    constructor Create(AServer: TDeviceDesc);
  protected
    function Get_Port: Smallint;
    function Get_bClass1: Integer;
    function Get_bClass2: Integer;
    function Get_bClass20: Integer;
    function Get_bClass21: Integer;
  public
    property DefaultInterface: IDeviceDesc read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoFaxStatusObj provides a Create and CreateRemote method to          
// create instances of the default interface IFaxStatusObj exposed by              
// the CoClass FaxStatusObj. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFaxStatusObj = class
    class function Create: IFaxStatusObj;
    class function CreateRemote(const MachineName: string): IFaxStatusObj;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TFaxStatusObj
// Help String      : FaxStatusObj Class
// Default Interface: IFaxStatusObj
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TFaxStatusObjProperties= class;
{$ENDIF}
  TFaxStatusObj = class(TOleServer)
  private
    FIntf:        IFaxStatusObj;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TFaxStatusObjProperties;
    function      GetServerProperties: TFaxStatusObjProperties;
{$ENDIF}
    function      GetDefaultInterface: IFaxStatusObj;
  protected
    procedure InitServerData; override;
    function Get_RemoteID: WideString;
    procedure Set_RemoteID(const pVal: WideString);
    function Get_ConnectSpeed: Integer;
    procedure Set_ConnectSpeed(pVal: Integer);
    function Get_LastEventType: Smallint;
    procedure Set_LastEventType(pVal: Smallint);
    function Get_NegotiatedResolution: Smallint;
    procedure Set_NegotiatedResolution(pVal: Smallint);
    function Get_CurrentStatus: Integer;
    procedure Set_CurrentStatus(pVal: Integer);
    function Get_StartTime: Integer;
    procedure Set_StartTime(pVal: Integer);
    function Get_EndTime: Integer;
    procedure Set_EndTime(pVal: Integer);
    function Get_ReceiveFileName: WideString;
    procedure Set_ReceiveFileName(const pVal: WideString);
    function Get_Pages: Smallint;
    procedure Set_Pages(pVal: Smallint);
    function Get_ErrorCode: Integer;
    procedure Set_ErrorCode(pVal: Integer);
    function Get_ErrorDesc: WideString;
    procedure Set_ErrorDesc(const pVal: WideString);
    function Get_PagesCompleted: Smallint;
    procedure Set_PagesCompleted(pVal: Smallint);
    function Get_CurrentStatusDesc: WideString;
    procedure Set_CurrentStatusDesc(const pVal: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFaxStatusObj);
    procedure Disconnect; override;
    property DefaultInterface: IFaxStatusObj read GetDefaultInterface;
    property RemoteID: WideString read Get_RemoteID write Set_RemoteID;
    property ConnectSpeed: Integer read Get_ConnectSpeed write Set_ConnectSpeed;
    property LastEventType: Smallint read Get_LastEventType write Set_LastEventType;
    property NegotiatedResolution: Smallint read Get_NegotiatedResolution write Set_NegotiatedResolution;
    property CurrentStatus: Integer read Get_CurrentStatus write Set_CurrentStatus;
    property StartTime: Integer read Get_StartTime write Set_StartTime;
    property EndTime: Integer read Get_EndTime write Set_EndTime;
    property ReceiveFileName: WideString read Get_ReceiveFileName write Set_ReceiveFileName;
    property Pages: Smallint read Get_Pages write Set_Pages;
    property ErrorCode: Integer read Get_ErrorCode write Set_ErrorCode;
    property ErrorDesc: WideString read Get_ErrorDesc write Set_ErrorDesc;
    property PagesCompleted: Smallint read Get_PagesCompleted write Set_PagesCompleted;
    property CurrentStatusDesc: WideString read Get_CurrentStatusDesc write Set_CurrentStatusDesc;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TFaxStatusObjProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TFaxStatusObj
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TFaxStatusObjProperties = class(TPersistent)
  private
    FServer:    TFaxStatusObj;
    function    GetDefaultInterface: IFaxStatusObj;
    constructor Create(AServer: TFaxStatusObj);
  protected
    function Get_RemoteID: WideString;
    procedure Set_RemoteID(const pVal: WideString);
    function Get_ConnectSpeed: Integer;
    procedure Set_ConnectSpeed(pVal: Integer);
    function Get_LastEventType: Smallint;
    procedure Set_LastEventType(pVal: Smallint);
    function Get_NegotiatedResolution: Smallint;
    procedure Set_NegotiatedResolution(pVal: Smallint);
    function Get_CurrentStatus: Integer;
    procedure Set_CurrentStatus(pVal: Integer);
    function Get_StartTime: Integer;
    procedure Set_StartTime(pVal: Integer);
    function Get_EndTime: Integer;
    procedure Set_EndTime(pVal: Integer);
    function Get_ReceiveFileName: WideString;
    procedure Set_ReceiveFileName(const pVal: WideString);
    function Get_Pages: Smallint;
    procedure Set_Pages(pVal: Smallint);
    function Get_ErrorCode: Integer;
    procedure Set_ErrorCode(pVal: Integer);
    function Get_ErrorDesc: WideString;
    procedure Set_ErrorDesc(const pVal: WideString);
    function Get_PagesCompleted: Smallint;
    procedure Set_PagesCompleted(pVal: Smallint);
    function Get_CurrentStatusDesc: WideString;
    procedure Set_CurrentStatusDesc(const pVal: WideString);
  public
    property DefaultInterface: IFaxStatusObj read GetDefaultInterface;
  published
    property RemoteID: WideString read Get_RemoteID write Set_RemoteID;
    property ConnectSpeed: Integer read Get_ConnectSpeed write Set_ConnectSpeed;
    property LastEventType: Smallint read Get_LastEventType write Set_LastEventType;
    property NegotiatedResolution: Smallint read Get_NegotiatedResolution write Set_NegotiatedResolution;
    property CurrentStatus: Integer read Get_CurrentStatus write Set_CurrentStatus;
    property StartTime: Integer read Get_StartTime write Set_StartTime;
    property EndTime: Integer read Get_EndTime write Set_EndTime;
    property ReceiveFileName: WideString read Get_ReceiveFileName write Set_ReceiveFileName;
    property Pages: Smallint read Get_Pages write Set_Pages;
    property ErrorCode: Integer read Get_ErrorCode write Set_ErrorCode;
    property ErrorDesc: WideString read Get_ErrorDesc write Set_ErrorDesc;
    property PagesCompleted: Smallint read Get_PagesCompleted write Set_PagesCompleted;
    property CurrentStatusDesc: WideString read Get_CurrentStatusDesc write Set_CurrentStatusDesc;
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

implementation

uses ComObj;

procedure TFaxmanJr.InitControlData;
const
  CEventDispIDs: array [0..8] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005, $00000006,
    $00000007, $00000008, $00000009);
  CControlData: TControlData2 = (
    ClassID: '{07728B50-6223-11D2-BA57-00002149093D}';
    EventIID: '{FAE5F620-4CA5-11D1-BA12-00002149093D}';
    EventCount: 9;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnStatus) - Cardinal(Self);
end;

procedure TFaxmanJr.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IFaxManJr;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TFaxmanJr.GetControlInterface: IFaxManJr;
begin
  CreateControl;
  Result := FIntf;
end;

function TFaxmanJr.Get_StatusObject: IFaxStatusObj;
begin
    Result := DefaultInterface.StatusObject;
end;

procedure TFaxmanJr.SendFax;
begin
  DefaultInterface.SendFax;
end;

procedure TFaxmanJr.CancelFax;
begin
  DefaultInterface.CancelFax;
end;

procedure TFaxmanJr.Receive(nRingCnt: Smallint);
begin
  DefaultInterface.Receive(nRingCnt);
end;

procedure TFaxmanJr.ImportFiles(const pszOutFile: WideString; const pszInFiles: WideString);
begin
  DefaultInterface.ImportFiles(pszOutFile, pszInFiles);
end;

procedure TFaxmanJr.Listen;
begin
  DefaultInterface.Listen;
end;

procedure TFaxmanJr.WaitForEvent(lWaitTime: Integer);
begin
  DefaultInterface.WaitForEvent(lWaitTime);
end;

procedure TFaxFinder.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{A5929EC5-74CF-11D2-BA5E-00002149093D}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TFaxFinder.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IFaxFinder;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TFaxFinder.GetControlInterface: IFaxFinder;
begin
  CreateControl;
  Result := FIntf;
end;

function TFaxFinder.Get_Item(nIndex: Smallint): IDeviceDesc;
begin
    Result := DefaultInterface.Item[nIndex];
end;

procedure TFaxFinder.AutoDetect;
begin
  DefaultInterface.AutoDetect;
end;

class function CoDeviceDesc.Create: IDeviceDesc;
begin
  Result := CreateComObject(CLASS_DeviceDesc) as IDeviceDesc;
end;

class function CoDeviceDesc.CreateRemote(const MachineName: string): IDeviceDesc;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DeviceDesc) as IDeviceDesc;
end;

procedure TDeviceDesc.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{A5929EC7-74CF-11D2-BA5E-00002149093D}';
    IntfIID:   '{A5929EC6-74CF-11D2-BA5E-00002149093D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDeviceDesc.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDeviceDesc;
  end;
end;

procedure TDeviceDesc.ConnectTo(svrIntf: IDeviceDesc);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDeviceDesc.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDeviceDesc.GetDefaultInterface: IDeviceDesc;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TDeviceDesc.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDeviceDescProperties.Create(Self);
{$ENDIF}
end;

destructor TDeviceDesc.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDeviceDesc.GetServerProperties: TDeviceDescProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TDeviceDesc.Get_Port: Smallint;
begin
    Result := DefaultInterface.Port;
end;

function TDeviceDesc.Get_bClass1: Integer;
begin
    Result := DefaultInterface.bClass1;
end;

function TDeviceDesc.Get_bClass2: Integer;
begin
    Result := DefaultInterface.bClass2;
end;

function TDeviceDesc.Get_bClass20: Integer;
begin
    Result := DefaultInterface.bClass20;
end;

function TDeviceDesc.Get_bClass21: Integer;
begin
    Result := DefaultInterface.bClass21;
end;

procedure TDeviceDesc._Init(nPort: Smallint; nDevFlags: Smallint);
begin
  DefaultInterface._Init(nPort, nDevFlags);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDeviceDescProperties.Create(AServer: TDeviceDesc);
begin
  inherited Create;
  FServer := AServer;
end;

function TDeviceDescProperties.GetDefaultInterface: IDeviceDesc;
begin
  Result := FServer.DefaultInterface;
end;

function TDeviceDescProperties.Get_Port: Smallint;
begin
    Result := DefaultInterface.Port;
end;

function TDeviceDescProperties.Get_bClass1: Integer;
begin
    Result := DefaultInterface.bClass1;
end;

function TDeviceDescProperties.Get_bClass2: Integer;
begin
    Result := DefaultInterface.bClass2;
end;

function TDeviceDescProperties.Get_bClass20: Integer;
begin
    Result := DefaultInterface.bClass20;
end;

function TDeviceDescProperties.Get_bClass21: Integer;
begin
    Result := DefaultInterface.bClass21;
end;

{$ENDIF}

class function CoFaxStatusObj.Create: IFaxStatusObj;
begin
  Result := CreateComObject(CLASS_FaxStatusObj) as IFaxStatusObj;
end;

class function CoFaxStatusObj.CreateRemote(const MachineName: string): IFaxStatusObj;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FaxStatusObj) as IFaxStatusObj;
end;

procedure TFaxStatusObj.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{154E5B73-8874-11D2-BA61-00002149093D}';
    IntfIID:   '{154E5B72-8874-11D2-BA61-00002149093D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFaxStatusObj.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFaxStatusObj;
  end;
end;

procedure TFaxStatusObj.ConnectTo(svrIntf: IFaxStatusObj);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFaxStatusObj.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFaxStatusObj.GetDefaultInterface: IFaxStatusObj;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TFaxStatusObj.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TFaxStatusObjProperties.Create(Self);
{$ENDIF}
end;

destructor TFaxStatusObj.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TFaxStatusObj.GetServerProperties: TFaxStatusObjProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TFaxStatusObj.Get_RemoteID: WideString;
begin
    Result := DefaultInterface.RemoteID;
end;

procedure TFaxStatusObj.Set_RemoteID(const pVal: WideString);
  { Warning: The property RemoteID has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RemoteID := pVal;
end;

function TFaxStatusObj.Get_ConnectSpeed: Integer;
begin
    Result := DefaultInterface.ConnectSpeed;
end;

procedure TFaxStatusObj.Set_ConnectSpeed(pVal: Integer);
begin
  Exit;
end;

function TFaxStatusObj.Get_LastEventType: Smallint;
begin
    Result := DefaultInterface.LastEventType;
end;

procedure TFaxStatusObj.Set_LastEventType(pVal: Smallint);
begin
  Exit;
end;

function TFaxStatusObj.Get_NegotiatedResolution: Smallint;
begin
    Result := DefaultInterface.NegotiatedResolution;
end;

procedure TFaxStatusObj.Set_NegotiatedResolution(pVal: Smallint);
begin
  Exit;
end;

function TFaxStatusObj.Get_CurrentStatus: Integer;
begin
    Result := DefaultInterface.CurrentStatus;
end;

procedure TFaxStatusObj.Set_CurrentStatus(pVal: Integer);
begin
  Exit;
end;

function TFaxStatusObj.Get_StartTime: Integer;
begin
    Result := DefaultInterface.StartTime;
end;

procedure TFaxStatusObj.Set_StartTime(pVal: Integer);
begin
  Exit;
end;

function TFaxStatusObj.Get_EndTime: Integer;
begin
    Result := DefaultInterface.EndTime;
end;

procedure TFaxStatusObj.Set_EndTime(pVal: Integer);
begin
  Exit;
end;

function TFaxStatusObj.Get_ReceiveFileName: WideString;
begin
    Result := DefaultInterface.ReceiveFileName;
end;

procedure TFaxStatusObj.Set_ReceiveFileName(const pVal: WideString);
  { Warning: The property ReceiveFileName has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ReceiveFileName := pVal;
end;

function TFaxStatusObj.Get_Pages: Smallint;
begin
    Result := DefaultInterface.Pages;
end;

procedure TFaxStatusObj.Set_Pages(pVal: Smallint);
begin
  Exit;
end;

function TFaxStatusObj.Get_ErrorCode: Integer;
begin
    Result := DefaultInterface.ErrorCode;
end;

procedure TFaxStatusObj.Set_ErrorCode(pVal: Integer);
begin
  Exit;
end;

function TFaxStatusObj.Get_ErrorDesc: WideString;
begin
    Result := DefaultInterface.ErrorDesc;
end;

procedure TFaxStatusObj.Set_ErrorDesc(const pVal: WideString);
  { Warning: The property ErrorDesc has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ErrorDesc := pVal;
end;

function TFaxStatusObj.Get_PagesCompleted: Smallint;
begin
    Result := DefaultInterface.PagesCompleted;
end;

procedure TFaxStatusObj.Set_PagesCompleted(pVal: Smallint);
begin
  Exit;
end;

function TFaxStatusObj.Get_CurrentStatusDesc: WideString;
begin
    Result := DefaultInterface.CurrentStatusDesc;
end;

procedure TFaxStatusObj.Set_CurrentStatusDesc(const pVal: WideString);
  { Warning: The property CurrentStatusDesc has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.CurrentStatusDesc := pVal;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TFaxStatusObjProperties.Create(AServer: TFaxStatusObj);
begin
  inherited Create;
  FServer := AServer;
end;

function TFaxStatusObjProperties.GetDefaultInterface: IFaxStatusObj;
begin
  Result := FServer.DefaultInterface;
end;

function TFaxStatusObjProperties.Get_RemoteID: WideString;
begin
    Result := DefaultInterface.RemoteID;
end;

procedure TFaxStatusObjProperties.Set_RemoteID(const pVal: WideString);
  { Warning: The property RemoteID has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RemoteID := pVal;
end;

function TFaxStatusObjProperties.Get_ConnectSpeed: Integer;
begin
    Result := DefaultInterface.ConnectSpeed;
end;

procedure TFaxStatusObjProperties.Set_ConnectSpeed(pVal: Integer);
begin
  Exit;
end;

function TFaxStatusObjProperties.Get_LastEventType: Smallint;
begin
    Result := DefaultInterface.LastEventType;
end;

procedure TFaxStatusObjProperties.Set_LastEventType(pVal: Smallint);
begin
  Exit;
end;

function TFaxStatusObjProperties.Get_NegotiatedResolution: Smallint;
begin
    Result := DefaultInterface.NegotiatedResolution;
end;

procedure TFaxStatusObjProperties.Set_NegotiatedResolution(pVal: Smallint);
begin
  Exit;
end;

function TFaxStatusObjProperties.Get_CurrentStatus: Integer;
begin
    Result := DefaultInterface.CurrentStatus;
end;

procedure TFaxStatusObjProperties.Set_CurrentStatus(pVal: Integer);
begin
  Exit;
end;

function TFaxStatusObjProperties.Get_StartTime: Integer;
begin
    Result := DefaultInterface.StartTime;
end;

procedure TFaxStatusObjProperties.Set_StartTime(pVal: Integer);
begin
  Exit;
end;

function TFaxStatusObjProperties.Get_EndTime: Integer;
begin
    Result := DefaultInterface.EndTime;
end;

procedure TFaxStatusObjProperties.Set_EndTime(pVal: Integer);
begin
  Exit;
end;

function TFaxStatusObjProperties.Get_ReceiveFileName: WideString;
begin
    Result := DefaultInterface.ReceiveFileName;
end;

procedure TFaxStatusObjProperties.Set_ReceiveFileName(const pVal: WideString);
  { Warning: The property ReceiveFileName has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ReceiveFileName := pVal;
end;

function TFaxStatusObjProperties.Get_Pages: Smallint;
begin
    Result := DefaultInterface.Pages;
end;

procedure TFaxStatusObjProperties.Set_Pages(pVal: Smallint);
begin
  Exit;
end;

function TFaxStatusObjProperties.Get_ErrorCode: Integer;
begin
    Result := DefaultInterface.ErrorCode;
end;

procedure TFaxStatusObjProperties.Set_ErrorCode(pVal: Integer);
begin
  Exit;
end;

function TFaxStatusObjProperties.Get_ErrorDesc: WideString;
begin
    Result := DefaultInterface.ErrorDesc;
end;

procedure TFaxStatusObjProperties.Set_ErrorDesc(const pVal: WideString);
  { Warning: The property ErrorDesc has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ErrorDesc := pVal;
end;

function TFaxStatusObjProperties.Get_PagesCompleted: Smallint;
begin
    Result := DefaultInterface.PagesCompleted;
end;

procedure TFaxStatusObjProperties.Set_PagesCompleted(pVal: Smallint);
begin
  Exit;
end;

function TFaxStatusObjProperties.Get_CurrentStatusDesc: WideString;
begin
    Result := DefaultInterface.CurrentStatusDesc;
end;

procedure TFaxStatusObjProperties.Set_CurrentStatusDesc(const pVal: WideString);
  { Warning: The property CurrentStatusDesc has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.CurrentStatusDesc := pVal;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents('ActiveX',[TFaxmanJr, TFaxFinder]);
  RegisterComponents(dtlServerPage, [TDeviceDesc, TFaxStatusObj]);
end;

end.
