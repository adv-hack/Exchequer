unit wfxctl32;

// ************************************************************************ //
// WARNING                                                                  //
// -------                                                                  //
// The types declared in this file were generated from data read from a     //
// Type Library. If this type library is explicitly or indirectly (via      //
// another type library referring to this type library) re-imported, or the //
// 'Refresh' command of the Type Library Editor activated while editing the //
// Type Library, the contents of this file will be regenerated and all      //
// manual modifications will be lost.                                       //
// ************************************************************************ //

// PASTLWTR : $Revision:   1.11.1.75  $
// File generated on 24/11/1999 11:41:12 from Type Library described below.

// ************************************************************************ //
// Type Lib: wfxctl32.tlb
// IID\LCID: {808D9041-49C1-11CE-A7FB-444553540000}\0
// Helpfile: 
// HelpString: WinFax Automation Server
// Version:    1.0
// ************************************************************************ //

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:      //
//   Type Libraries     : LIBID_xxxx                                    //
//   CoClasses          : CLASS_xxxx                                    //
//   DISPInterfaces     : DIID_xxxx                                     //
//   Non-DISP interfaces: IID_xxxx                                      //
// *********************************************************************//
const
  LIBID_wfxctl32: TGUID = '{808D9041-49C1-11CE-A7FB-444553540000}';
  DIID_ISDKFXConverter: TGUID = '{762BDF81-9B9A-11D0-A413-00805F84C89A}';
  CLASS_CSDKFXConverter: TGUID = '{762BDF80-9B9A-11D0-A413-00805F84C89A}';
  DIID_IOleWinFaxApp: TGUID = '{A03325C1-5ADA-11CE-A7FB-008029E0ABE9}';
  CLASS_COleWinFaxApp: TGUID = '{A03325C0-5ADA-11CE-A7FB-008029E0ABE9}';
  DIID_IOleAttachment: TGUID = '{17EAB2A1-70E2-11CE-A7FB-008029E0ABE9}';
  CLASS_COleAttachment: TGUID = '{17EAB2A0-70E2-11CE-A7FB-008029E0ABE9}';
  DIID_IOleAttachments: TGUID = '{18EAB2A1-70E3-11CE-A7FB-008029E0ABE9}';
  CLASS_COleAttachments: TGUID = '{18EAB2A0-70E3-11CE-A7FB-008029E0ABE9}';
  DIID_IOleCoverPage: TGUID = '{17EAB2A1-80E2-11CE-A7FB-008029E0ABE9}';
  CLASS_COleCoverPage: TGUID = '{17EAB2A0-80E2-11CE-A7FB-008029E0ABE9}';
  DIID_IOleCoverPages: TGUID = '{18EAB2A1-80E3-11CE-A7FB-008029E0ABE9}';
  CLASS_COleCoverPages: TGUID = '{18EAB2A0-80E3-11CE-A7FB-008029E0ABE9}';
  DIID_ISDKSend: TGUID = '{34B153E0-696E-11D0-BD29-00805F98AB78}';
  DIID_ISDK_Sink: TGUID = '{6F12F9A0-75FB-11D0-BD2A-00805F98AB78}';
  CLASS_CSDKSend: TGUID = '{66A6D725-51CD-11D0-BD28-00805F98AB78}';
  DIID_ISDKView: TGUID = '{B71B64C1-8EF2-11D0-961C-444553540000}';
  CLASS_CSDKView: TGUID = '{B71B64C0-8EF2-11D0-961C-444553540000}';
  DIID_ISDKPhoneBook: TGUID = '{A67FCC81-9949-11D0-961E-444553540000}';
  CLASS_CSDKPhoneBook: TGUID = '{A67FCC80-9949-11D0-961E-444553540000}';
  DIID_ISDKLog: TGUID = '{2B9E21E1-8F00-11D0-961C-444553540000}';
  CLASS_CSDKLog: TGUID = '{2B9E21E0-8F00-11D0-961C-444553540000}';
  DIID_ISDKScan: TGUID = '{E13DF741-DE57-11D0-A414-00805F84C89A}';
  CLASS_CSDKScan: TGUID = '{E13DF740-DE57-11D0-A414-00805F84C89A}';
  DIID_IHostCtrl: TGUID = '{DA4E5221-FE02-11D0-BD2E-00805F98AB78}';
  CLASS_CHostCtrl: TGUID = '{DA4E5220-FE02-11D0-BD2E-00805F98AB78}';
  DIID_ISDKWinFaxSink: TGUID = '{0A97BB83-FF5A-11D0-BD2E-00805F98AB78}';
  CLASS_CSDKMgr: TGUID = '{54C84661-FC7C-11D0-BD2E-00805F98AB78}';
type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  ISDKFXConverter = dispinterface;
  IOleWinFaxApp = dispinterface;
  IOleAttachment = dispinterface;
  IOleAttachments = dispinterface;
  IOleCoverPage = dispinterface;
  IOleCoverPages = dispinterface;
  ISDKSend = dispinterface;
  ISDK_Sink = dispinterface;
  ISDKView = dispinterface;
  ISDKPhoneBook = dispinterface;
  ISDKLog = dispinterface;
  ISDKScan = dispinterface;
  IHostCtrl = dispinterface;
  ISDKWinFaxSink = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  CSDKFXConverter = ISDKFXConverter;
  COleWinFaxApp = IOleWinFaxApp;
  COleAttachment = IOleAttachment;
  COleAttachments = IOleAttachments;
  COleCoverPage = IOleCoverPage;
  COleCoverPages = IOleCoverPages;
  CSDKSend = ISDKSend;
  CSDKView = ISDKView;
  CSDKPhoneBook = ISDKPhoneBook;
  CSDKLog = ISDKLog;
  CSDKScan = ISDKScan;
  CHostCtrl = IHostCtrl;


// *********************************************************************//
// Declaration of structures, unions and aliases.                       //
// *********************************************************************//
  PWideString1 = ^WideString; {*}
  PSmallint1 = ^Smallint; {*}
  PInteger1 = ^Integer; {*}


// *********************************************************************//
// DispIntf:  ISDKFXConverter
// Flags:     (4096) Dispatchable
// GUID:      {762BDF81-9B9A-11D0-A413-00805F84C89A}
// *********************************************************************//
  ISDKFXConverter = dispinterface
    ['{762BDF81-9B9A-11D0-A413-00805F84C89A}']
    property FXFormat: Integer dispid 1;
    property BitsPerPixel: Smallint dispid 2;
    property Format: Integer dispid 3;
    function ConvertToFX(const lpszSrcFile: WideString; const lpszFXFile: WideString): SCODE; dispid 4;
    function ConvertPageToFX(const lpszSrcFile: WideString; nPage: Smallint; 
                             const lpszFXFile: WideString; var lpszDestFile: WideString): SCODE; dispid 5;
    function ConvertFromFX(const lpszFXFile: WideString; const lpszDestFile: WideString): SCODE; dispid 6;
    function ConvertFromFXToPage(const lpszFXFile: WideString; const lpszDestFile: WideString; 
                                 nPage: Smallint): SCODE; dispid 7;
    function GetFXFileDescription(const lpszFXFile: WideString; var lpszDescription: WideString): SCODE; dispid 8;
    function SetFXFileDescription(const lpszFXFile: WideString; const lpszDescription: WideString): SCODE; dispid 9;
    function UpdateFXHeaderCRC(const lpszFXFile: WideString): SCODE; dispid 10;
    function VerifyFXHeaderCRC(const lpszFXFile: WideString): SCODE; dispid 11;
  end;

// *********************************************************************//
// DispIntf:  IOleWinFaxApp
// Flags:     (4096) Dispatchable
// GUID:      {A03325C1-5ADA-11CE-A7FB-008029E0ABE9}
// *********************************************************************//
  IOleWinFaxApp = dispinterface
    ['{A03325C1-5ADA-11CE-A7FB-008029E0ABE9}']
    function ShowStart: Smallint; dispid 1;
    function ShowNormal: Smallint; dispid 2;
    function ShowMinimized: Smallint; dispid 3;
    function ShowMaximized: Smallint; dispid 4;
    function LeaveRunning(nVisible: Smallint): Smallint; dispid 5;
    function GetVisible: Smallint; dispid 6;
    function SetVisible(nVisible: Smallint): Smallint; dispid 7;
    function FullName: WideString; dispid 8;
    function Name: WideString; dispid 9;
    function Quit: Smallint; dispid 10;
    function GetDeviceList: WideString; dispid 11;
    function AutoReceive(const sDevice: WideString; bOnOff: WordBool): Smallint; dispid 12;
    function GetAutoReceive(const sDevice: WideString; var nStatus: Smallint): Smallint; dispid 13;
  end;

// *********************************************************************//
// DispIntf:  IOleAttachment
// Flags:     (4096) Dispatchable
// GUID:      {17EAB2A1-70E2-11CE-A7FB-008029E0ABE9}
// *********************************************************************//
  IOleAttachment = dispinterface
    ['{17EAB2A1-70E2-11CE-A7FB-008029E0ABE9}']
    property Application_: IDispatch dispid 1;
    function GetNumberOfPages: Smallint; dispid 2;
    function GetMultipage: Smallint; dispid 3;
    function GetFilename(nPage: Smallint): WideString; dispid 4;
    function GetDescription: WideString; dispid 5;
    function GetKeywords: WideString; dispid 6;
    function SetDescription(const sDescription: WideString): Smallint; dispid 7;
    function SetKeywords(const sKeywords: WideString): Smallint; dispid 8;
    function SetMultipage(nMultipage: Smallint): Smallint; dispid 9;
    function SetFileName(const sFileName: WideString): Smallint; dispid 10;
    function AddAttachment: Smallint; dispid 11;
  end;

// *********************************************************************//
// DispIntf:  IOleAttachments
// Flags:     (4096) Dispatchable
// GUID:      {18EAB2A1-70E3-11CE-A7FB-008029E0ABE9}
// *********************************************************************//
  IOleAttachments = dispinterface
    ['{18EAB2A1-70E3-11CE-A7FB-008029E0ABE9}']
    property Application_: IDispatch dispid 1;
    property Count: Smallint dispid 2;
    function Item(nIndex: Smallint): IDispatch; dispid 3;
    function NewAttachment: IDispatch; dispid 4;
  end;

// *********************************************************************//
// DispIntf:  IOleCoverPage
// Flags:     (4096) Dispatchable
// GUID:      {17EAB2A1-80E2-11CE-A7FB-008029E0ABE9}
// *********************************************************************//
  IOleCoverPage = dispinterface
    ['{17EAB2A1-80E2-11CE-A7FB-008029E0ABE9}']
    property Application_: IDispatch dispid 1;
    function GetFilename: WideString; dispid 2;
    function GetDescription: WideString; dispid 3;
    function GetDefault: Smallint; dispid 4;
    function GetOleType: Smallint; dispid 5;
  end;

// *********************************************************************//
// DispIntf:  IOleCoverPages
// Flags:     (4096) Dispatchable
// GUID:      {18EAB2A1-80E3-11CE-A7FB-008029E0ABE9}
// *********************************************************************//
  IOleCoverPages = dispinterface
    ['{18EAB2A1-80E3-11CE-A7FB-008029E0ABE9}']
    property Application_: IDispatch dispid 1;
    property Count: Smallint dispid 2;
    function Item(nIndex: Smallint): IDispatch; dispid 3;
    function RefreshDB: WordBool; dispid 4;
  end;

// *********************************************************************//
// DispIntf:  ISDKSend
// Flags:     (4096) Dispatchable
// GUID:      {34B153E0-696E-11D0-BD29-00805F98AB78}
// *********************************************************************//
  ISDKSend = dispinterface
    ['{34B153E0-696E-11D0-BD29-00805F98AB78}']
    property Application_: IDispatch dispid 1;
    function SetTo(const sTo: WideString): Smallint; dispid 2;
    function SetNumber(const sNumber: WideString): Smallint; dispid 3;
    function SetSubject(const sSubject: WideString): Smallint; dispid 4;
    function SetCoverText(const sCoverText: WideString): Smallint; dispid 5;
    function Send(need_entryIDs: Smallint): Smallint; dispid 6;
    function Cancel: Smallint; dispid 7;
    function SetCompany(const sCompany: WideString): Smallint; dispid 8;
    function SetKeywords(const sKeywords: WideString): Smallint; dispid 9;
    function SetBillingCode(const sBillingCode: WideString): Smallint; dispid 10;
    function SetTime(const sTime: WideString): Smallint; dispid 11;
    function SetDate(const sDate: WideString): Smallint; dispid 12;
    function SetOffPeak(nOffPeak: Smallint): Smallint; dispid 13;
    function SetHold(nHold: Smallint): Smallint; dispid 14;
    function SetPriority(nPriority: Smallint): Smallint; dispid 15;
    function SetUsePrefix(nUsePrefix: Smallint): Smallint; dispid 16;
    function SetUseCreditCard(nUseCreditCard: Smallint): Smallint; dispid 17;
    function SetResolution(nResolution: Smallint): Smallint; dispid 18;
    function SetDeleteAfterSend(nDeleteAfterSend: Smallint): Smallint; dispid 19;
    function AddAttachment(nIndex: Smallint): Smallint; dispid 20;
    function AddAttachmentFile(const sFile: WideString): Smallint; dispid 21;
    function SetQuickCover(nQuickCover: Smallint): Smallint; dispid 22;
    function SetCoverPage(nIndex: Smallint): Smallint; dispid 23;
    function SetCoverFile(const sCoverFile: WideString): Smallint; dispid 24;
    function SetDialPrefix(const sDialPrefix: WideString): Smallint; dispid 25;
    function SetBCC(nBCC: Smallint): Smallint; dispid 26;
    function SetUseCover(nUseCover: Smallint): Smallint; dispid 27;
    function SetPreviewFax(nPreviewFax: Smallint): Smallint; dispid 28;
    function GetEntryID(index: Smallint): WideString; dispid 29;
    function IsEntryIDReady(index: Smallint): Smallint; dispid 30;
    function IsError: Smallint; dispid 31;
    procedure Done; dispid 32;
    function AddRecipient: Smallint; dispid 33;
    function SetAreaCode(const sAreaCode: WideString): Smallint; dispid 34;
    function SetCountryCode(const sCountryCode: WideString): Smallint; dispid 35;
    function SetExtension(const sExtension: WideString): Smallint; dispid 36;
    function ShowSendScreen(nShowSndScreen: Smallint): Smallint; dispid 37;
    function SetPrintFromApp(nPrintDriverJob: Smallint): Smallint; dispid 38;
    function IsReadyToPrint: Smallint; dispid 39;
    function ShowCallProgess(nCallProgress: Smallint): Smallint; dispid 40;
    function LeaveRunning: Smallint; dispid 41;
    function GetAttachmentCount: Smallint; dispid 42;
    function RemoveAllAttachments: Smallint; dispid 43;
    function GetRecipientCount: Smallint; dispid 44;
    function RemoveRecipient(recipient: Smallint): Smallint; dispid 45;
    function RemoveAllRecipients: Smallint; dispid 46;
    function ResetGeneralSettings: Smallint; dispid 47;
    function SetCurrentRecipient(recipient: Smallint): Smallint; dispid 48;
    function ResetCurrentRecipient: Smallint; dispid 49;
    function GetTypeCount: Smallint; dispid 50;
    function GetType(atype: Smallint): WideString; dispid 51;
    function SetType(atype: Smallint): Smallint; dispid 52;
    function SetTypeByName(const Name: WideString): Smallint; dispid 53;
    function SetUserGroupEntryID(const entryID: WideString): Smallint; dispid 54;
    function GetLastError: Integer; dispid 55;
    function EnableBillingCodeKeyWords(enable: Smallint): Smallint; dispid 56;
    function AddStreamFileName(const filename: WideString): Smallint; dispid 57;
    function MakeAttachment(const sKeyword: WideString; const sDirectory: WideString; 
                            nConversion: Smallint): Smallint; dispid 58;
    function SetDeviceName(const sDeviceName: WideString): Smallint; dispid 59;
    function SetScannerMode(nMode: Smallint): Smallint; dispid 60;
    function SetClientID(const clientID: WideString): Smallint; dispid 61;
    function SetClientEntryID(const cliententryId: WideString): Smallint; dispid 62;
    function SetClientCookie(cookie: Integer): Smallint; dispid 63;
    function ShowCallProgress(nCallProgress: Smallint): Smallint; dispid 64;
  end;

// *********************************************************************//
// DispIntf:  ISDK_Sink
// Flags:     (4096) Dispatchable
// GUID:      {6F12F9A0-75FB-11D0-BD2A-00805F98AB78}
// *********************************************************************//
  ISDK_Sink = dispinterface
    ['{6F12F9A0-75FB-11D0-BD2A-00805F98AB78}']
    procedure EntryIDReady(const entryID: WideString; index: Smallint); dispid 1;
    procedure ReceivedEvent(const entryID: WideString); dispid 2;
    procedure Status(const entryID: WideString); dispid 3;
  end;

// *********************************************************************//
// DispIntf:  ISDKView
// Flags:     (4096) Dispatchable
// GUID:      {B71B64C1-8EF2-11D0-961C-444553540000}
// *********************************************************************//
  ISDKView = dispinterface
    ['{B71B64C1-8EF2-11D0-961C-444553540000}']
    property Application_: IDispatch dispid 1;
    property error: Smallint dispid 2;
    function ViewFax(const messageID: WideString): Smallint; dispid 3;
    function PlayVoice(const messageID: WideString): Smallint; dispid 4;
    function ViewBFT(const messageID: WideString): Smallint; dispid 5;
  end;

// *********************************************************************//
// DispIntf:  ISDKPhoneBook
// Flags:     (4096) Dispatchable
// GUID:      {A67FCC81-9949-11D0-961E-444553540000}
// *********************************************************************//
  ISDKPhoneBook = dispinterface
    ['{A67FCC81-9949-11D0-961E-444553540000}']
    property Application_: IDispatch dispid 1;
    property error: Smallint dispid 2;
    function GetFolderListFirst(standardFolder: Smallint; const folderID: WideString): WideString; dispid 3;
    function GetFolderListNext: WideString; dispid 4;
    function GetUserGroupFirst(standardFolder: Smallint; const folderID: WideString): WideString; dispid 5;
    function GetUserGroupNext: WideString; dispid 6;
    function SetFolderDisplayName(const sFolder: WideString; const sName: WideString): Smallint; dispid 7;
    function GetFolderDisplayName(const folderID: WideString): WideString; dispid 8;
    function SetGroupDisplayName(const folderID: WideString; const displayname: WideString): Smallint; dispid 9;
    function GetGroupDisplayName(const groupID: WideString): WideString; dispid 10;
    function CompareFolderEntryIDs(const ID1: WideString; const ID2: WideString): WordBool; dispid 11;
    function CompareUserGroupEntryIDs(const ID1: WideString; const ID2: WideString): WordBool; dispid 12;
    function SetUserDisplayName(const userID: WideString; const displayname: WideString): Smallint; dispid 13;
    function GetUserDisplayName(const userID: WideString): WideString; dispid 14;
    function SetUserTitle(const userID: WideString; const title: WideString): Smallint; dispid 15;
    function GetUserTitle(const userID: WideString): WideString; dispid 16;
    function SetUserFirstName(const userID: WideString; const firstName: WideString): Smallint; dispid 17;
    function GetUserFirstName(const userID: WideString): WideString; dispid 18;
    function SetUserLastName(const userID: WideString; const lastName: WideString): Smallint; dispid 19;
    function GetUserLastName(const userID: WideString): WideString; dispid 20;
    function SetUserCompany(const userID: WideString; const company: WideString): Smallint; dispid 21;
    function GetUserCompany(const userID: WideString): WideString; dispid 22;
    function SetUserAddress1(const userID: WideString; const address1: WideString): Smallint; dispid 23;
    function GetUserAddress1(const userID: WideString): WideString; dispid 24;
    function SetUserAddress2(const userID: WideString; const address2: WideString): Smallint; dispid 25;
    function GetUserAddress2(const userID: WideString): WideString; dispid 26;
    function SetUserCity(const userID: WideString; const city: WideString): Smallint; dispid 27;
    function GetUserCity(const userID: WideString): WideString; dispid 28;
    function SetUserState(const userID: WideString; const state: WideString): Smallint; dispid 29;
    function GetUserState(const userID: WideString): WideString; dispid 30;
    function SetUserCountry(const userID: WideString; const country: WideString): Smallint; dispid 31;
    function GetUserCountry(const userID: WideString): WideString; dispid 32;
    function SetUserPostalCode(const userID: WideString; const code: WideString): Smallint; dispid 33;
    function GetUserPostalCode(const userID: WideString): WideString; dispid 34;
    function GetType(const eventID: WideString): Smallint; dispid 35;
    function SetUserFaxCountry(const userID: WideString; const number: WideString): Smallint; dispid 36;
    function GetUserFaxCountry(const userID: WideString): WideString; dispid 37;
    function SetUserFaxArea(const userID: WideString; const number: WideString): Smallint; dispid 38;
    function GetUserFaxArea(const userID: WideString): WideString; dispid 39;
    function SetUserFaxLocal(const userID: WideString; const number: WideString): Smallint; dispid 40;
    function GetUserFaxLocal(const userID: WideString): WideString; dispid 41;
    function SetUserFaxExtension(const userID: WideString; const number: WideString): Smallint; dispid 42;
    function GetUserFaxExtension(const userID: WideString): WideString; dispid 43;
    function SetUserFaxAltCountry(const userID: WideString; const number: WideString): Smallint; dispid 44;
    function GetUserFaxAltCountry(const userID: WideString): WideString; dispid 45;
    function SetUserFaxAltArea(const userID: WideString; const number: WideString): Smallint; dispid 46;
    function GetUserFaxAltArea(const userID: WideString): WideString; dispid 47;
    function SetUserFaxAltLocal(const userID: WideString; const number: WideString): Smallint; dispid 48;
    function GetUserFaxAltLocal(const userID: WideString): WideString; dispid 49;
    function SetUserFaxAltExtension(const userID: WideString; const number: WideString): Smallint; dispid 50;
    function GetUserFaxAltExtension(const userID: WideString): WideString; dispid 51;
    function SetUserCSID(const userID: WideString; const csid: WideString): Smallint; dispid 52;
    function GetUserCSID(const userID: WideString): WideString; dispid 53;
    function SetUserVoiceCountry(const userID: WideString; const number: WideString): Smallint; dispid 54;
    function GetUserVoiceCountry(const userID: WideString): WideString; dispid 55;
    function SetUserVoiceArea(const userID: WideString; const number: WideString): Smallint; dispid 56;
    function GetUserVoiceArea(const userID: WideString): WideString; dispid 57;
    function SetUserVoiceLocal(const userID: WideString; const number: WideString): Smallint; dispid 58;
    function GetUserVoiceLocal(const userID: WideString): WideString; dispid 59;
    function SetUserVoiceExtension(const userID: WideString; const number: WideString): Smallint; dispid 60;
    function GetUserVoiceExtension(const userID: WideString): WideString; dispid 61;
    function SetUserCellCountry(const userID: WideString; const number: WideString): Smallint; dispid 62;
    function GetUserCellCountry(const userID: WideString): WideString; dispid 63;
    function SetUserCellArea(const userID: WideString; const number: WideString): Smallint; dispid 64;
    function GetUserCellArea(const userID: WideString): WideString; dispid 65;
    function SetUserCellLocal(const userID: WideString; const number: WideString): Smallint; dispid 66;
    function GetUserCellLocal(const userID: WideString): WideString; dispid 67;
    function SetUserCellExtension(const userID: WideString; const number: WideString): Smallint; dispid 68;
    function GetUserCellExtension(const userID: WideString): WideString; dispid 69;
    function AddFolder(standardFolder: Smallint; const folderID: WideString; 
                       const folderName: WideString; const comment: WideString): WideString; dispid 70;
    function AddUser(standardFolder: Smallint; const folderID: WideString; 
                     const firstName: WideString; const lastName: WideString; 
                     const company: WideString): WideString; dispid 71;
    function AddGroup(standardFolder: Smallint; const folderID: WideString; 
                      const groupName: WideString): WideString; dispid 72;
    function DeleteFolder(const folderID: WideString): Smallint; dispid 73;
    function DeleteUser(const userID: WideString): Smallint; dispid 74;
    function DeleteGroup(const groupID: WideString): Smallint; dispid 75;
  end;

// *********************************************************************//
// DispIntf:  ISDKLog
// Flags:     (4096) Dispatchable
// GUID:      {2B9E21E1-8F00-11D0-961C-444553540000}
// *********************************************************************//
  ISDKLog = dispinterface
    ['{2B9E21E1-8F00-11D0-961C-444553540000}']
    property Application_: IDispatch dispid 1;
    property error: Smallint dispid 2;
    function GetUnreadReceivedFaxCount: Integer; dispid 3;
    function GetFolderListFirst(standardFolder: Smallint; const folderID: WideString): WideString; dispid 4;
    function GetFolderListNext: WideString; dispid 5;
    function GetMessageListFirst(standardFolder: Smallint; const folderID: WideString): WideString; dispid 6;
    function GetMessageListNext: WideString; dispid 7;
    function DeleteMessage(const messageID: WideString): Smallint; dispid 8;
    function DeleteFolder(const folderID: WideString): Smallint; dispid 9;
    function AddFolder(standardFolder: Smallint; const folderID: WideString; 
                       const folderName: WideString; const comment: WideString): WideString; dispid 10;
    function GetMessageDisplayName(const messageID: WideString): WideString; dispid 11;
    function SetMessageDisplayName(const messageID: WideString; const displayname: WideString): Smallint; dispid 12;
    function GetMessageTo(const messageID: WideString): WideString; dispid 13;
    function SetMessageTo(const messageID: WideString; const ato: WideString): Smallint; dispid 14;
    function GetMessageNumber(const messageID: WideString): WideString; dispid 15;
    function SetMessageNumber(const messageID: WideString; const number: WideString): Smallint; dispid 16;
    function GetMessageSubject(const messageID: WideString): WideString; dispid 17;
    function SetMessageSubject(const messageID: WideString; const subject: WideString): Smallint; dispid 18;
    function GetMessageCompany(const messageID: WideString): WideString; dispid 19;
    function SetMessageCompany(const messageID: WideString; const company: WideString): Smallint; dispid 20;
    function GetMessageKeywords(const messageID: WideString): WideString; dispid 21;
    function SetMessageKeywords(const messageID: WideString; const keywords: WideString): Smallint; dispid 22;
    function GetMessageBillingCode(const messageID: WideString): WideString; dispid 23;
    function SetMessageBillingCode(const messageID: WideString; const billingCode: WideString): Smallint; dispid 24;
    function GetMessageAttachmentCount(const messageID: WideString): Smallint; dispid 25;
    function GetFolderDisplayName(const folderID: WideString): WideString; dispid 26;
    function SetFolderDisplayName(const folderID: WideString; const displayname: WideString): Smallint; dispid 27;
    function GetUnreadReceivedVoiceCount: Integer; dispid 28;
    function GetMessageHold(const messageID: WideString): Smallint; dispid 29;
    function GetMessageDate(const messageID: WideString): WideString; dispid 30;
    function GetMessageTime(const messageID: WideString): WideString; dispid 31;
    function GetType(const eventID: WideString): Smallint; dispid 32;
    function CompareFolderEntryIDs(const ID1: WideString; const ID2: WideString): WordBool; dispid 33;
    function CompareMessageEntryIDs(const ID1: WideString; const ID2: WideString): WordBool; dispid 34;
    function GetMessageStatus(const messageID: WideString): Smallint; dispid 35;
    function GetMessageFirstFile(const folderID: WideString; const messageID: WideString): WideString; dispid 36;
    function GetMessageNextFile: WideString; dispid 37;
    function GetMessageCSID(const messageID: WideString): WideString; dispid 38;
    function GetMessagePageCount(const messageID: WideString): Smallint; dispid 39;
    function SetMessageHold(const messageID: WideString): Smallint; dispid 40;
    function SetMessageRelease(const messageID: WideString): Smallint; dispid 41;
    function GetUnreadReceiveList: WideString; dispid 42;
    function SetMessageTimeShort(const messageID: WideString; time: Smallint): Smallint; dispid 43;
    function SetMessageDateShort(const messageID: WideString; date: Smallint): Smallint; dispid 44;
    function GetMessagePropertyShort(const messageID: WideString; propertyTag: Integer): Smallint; dispid 45;
    function GetMessagePropertyString(const messageID: WideString; propertyTag: Integer): WideString; dispid 46;
    function GetMultiMessageReceiveData(const messageIDList: WideString): WideString; dispid 47;
    function ClientFinishedSendProcessing(const HostEID: WideString): Smallint; dispid 48;
    function ClientFinishedReceiveProcessing(const HostEID: WideString): Smallint; dispid 49;
    function SetReadFileName(const filename: WideString; var size: Integer): Smallint; dispid 50;
    function GetMessageTimeShort(const messageID: WideString): Smallint; dispid 51;
    function GetMessageDateShort(const messageID: WideString): Smallint; dispid 52;
    procedure SetMessageReadState(const messageID: WideString; bRead: WordBool); dispid 53;
    function GetMessageResolution(const messageID: WideString): Smallint; dispid 54;
    function GetMessageErrorCode(const messageID: WideString): Smallint; dispid 55;
    function GetMessageDuration(const messageID: WideString): Integer; dispid 56;
    function GetMessageBaudRate(const messageID: WideString): Smallint; dispid 57;
    function GetMessageUsedECM(const messageID: WideString): Smallint; dispid 58;
    function GetMessagePropertyBinary(const messageID: WideString; propertyTag: Integer): OleVariant; dispid 59;
    function GetMessagePropertyLong(const messageID: WideString; propertyTag: Integer): Integer; dispid 60;
    function GetMessageDeviceNameUsed(const messageID: WideString): WideString; dispid 61;
    function GetMessageRetries(const messageID: WideString): Smallint; dispid 62;
    function DeleteEventandFiles(const messageID: WideString): Smallint; dispid 63;
    function CancelMessage(const messageID: WideString): Smallint; dispid 64;
  end;

// *********************************************************************//
// DispIntf:  ISDKScan
// Flags:     (4096) Dispatchable
// GUID:      {E13DF741-DE57-11D0-A414-00805F84C89A}
// *********************************************************************//
  ISDKScan = dispinterface
    ['{E13DF741-DE57-11D0-A414-00805F84C89A}']
    property Application_: IDispatch dispid 1;
    function ScanAndSend: SCODE; dispid 2;
    function ScanToAttachment(var pnPages: Smallint; var lpszBasePath: WideString; 
                              var lpszExtension: WideString): SCODE; dispid 3;
    function ScanToFile(var pnPages: Smallint; var lpszBasePath: WideString; 
                        var lpszExtension: WideString): SCODE; dispid 4;
    function IsScanningEnabled: SCODE; dispid 5;
    function SelectScanner: SCODE; dispid 6;
  end;

// *********************************************************************//
// DispIntf:  IHostCtrl
// Flags:     (4096) Dispatchable
// GUID:      {DA4E5221-FE02-11D0-BD2E-00805F98AB78}
// *********************************************************************//
  IHostCtrl = dispinterface
    ['{DA4E5221-FE02-11D0-BD2E-00805F98AB78}']
    function IsAHost: WordBool; dispid 1;
    function IsHostVerifyPasswordOSInfo(const password: WideString; var error: Smallint; 
                                        var majorver: Integer; var minorver: Integer; 
                                        var platformId: Integer): WordBool; dispid 2;
  end;

// *********************************************************************//
// DispIntf:  ISDKWinFaxSink
// Flags:     (4096) Dispatchable
// GUID:      {0A97BB83-FF5A-11D0-BD2E-00805F98AB78}
// *********************************************************************//
  ISDKWinFaxSink = dispinterface
    ['{0A97BB83-FF5A-11D0-BD2E-00805F98AB78}']
    procedure EntryIDReady(const HostEID: WideString; const ClientEID: WideString); dispid 5;
    procedure EventReceived(const entryID: WideString); dispid 1;
    procedure JobCompleted(const entryID: WideString; Status: Integer); dispid 2;
    procedure JobGoneActive(const entryID: WideString); dispid 3;
    procedure HostShuttingDown; dispid 4;
    function GetIdentifier: WideString; dispid 6;
  end;

  CoCSDKFXConverter = class
    class function Create: ISDKFXConverter;
    class function CreateRemote(const MachineName: string): ISDKFXConverter;
  end;

  CoCOleWinFaxApp = class
    class function Create: IOleWinFaxApp;
    class function CreateRemote(const MachineName: string): IOleWinFaxApp;
  end;

  CoCOleAttachment = class
    class function Create: IOleAttachment;
    class function CreateRemote(const MachineName: string): IOleAttachment;
  end;

  CoCOleAttachments = class
    class function Create: IOleAttachments;
    class function CreateRemote(const MachineName: string): IOleAttachments;
  end;

  CoCOleCoverPage = class
    class function Create: IOleCoverPage;
    class function CreateRemote(const MachineName: string): IOleCoverPage;
  end;

  CoCOleCoverPages = class
    class function Create: IOleCoverPages;
    class function CreateRemote(const MachineName: string): IOleCoverPages;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TCSDKSend
// Help String      : 
// Default Interface: ISDKSend
// Def. Intf. DISP? : Yes
// Event   Interface: ISDK_Sink
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TCSDKSendEntryIDReady = procedure(Sender: TObject; const entryID: WideString; index: Smallint) of object;
  TCSDKSendReceivedEvent = procedure(Sender: TObject; const entryID: WideString) of object;
  TCSDKSendStatus = procedure(Sender: TObject; const entryID: WideString) of object;

  TCSDKSend = class(TOleControl)
  private
    FOnEntryIDReady: TCSDKSendEntryIDReady;
    FOnReceivedEvent: TCSDKSendReceivedEvent;
    FOnStatus: TCSDKSendStatus;
    FIntf: ISDKSend;
    function  GetControlInterface: ISDKSend;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function SetTo(const sTo: WideString): Smallint;
    function SetNumber(const sNumber: WideString): Smallint;
    function SetSubject(const sSubject: WideString): Smallint;
    function SetCoverText(const sCoverText: WideString): Smallint;
    function Send(need_entryIDs: Smallint): Smallint;
    function Cancel: Smallint;
    function SetCompany(const sCompany: WideString): Smallint;
    function SetKeywords(const sKeywords: WideString): Smallint;
    function SetBillingCode(const sBillingCode: WideString): Smallint;
    function SetTime(const sTime: WideString): Smallint;
    function SetDate(const sDate: WideString): Smallint;
    function SetOffPeak(nOffPeak: Smallint): Smallint;
    function SetHold(nHold: Smallint): Smallint;
    function SetPriority(nPriority: Smallint): Smallint;
    function SetUsePrefix(nUsePrefix: Smallint): Smallint;
    function SetUseCreditCard(nUseCreditCard: Smallint): Smallint;
    function SetResolution(nResolution: Smallint): Smallint;
    function SetDeleteAfterSend(nDeleteAfterSend: Smallint): Smallint;
    function AddAttachment(nIndex: Smallint): Smallint;
    function AddAttachmentFile(const sFile: WideString): Smallint;
    function SetQuickCover(nQuickCover: Smallint): Smallint;
    function SetCoverPage(nIndex: Smallint): Smallint;
    function SetCoverFile(const sCoverFile: WideString): Smallint;
    function SetDialPrefix(const sDialPrefix: WideString): Smallint;
    function SetBCC(nBCC: Smallint): Smallint;
    function SetUseCover(nUseCover: Smallint): Smallint;
    function SetPreviewFax(nPreviewFax: Smallint): Smallint;
    function GetEntryID(index: Smallint): WideString;
    function IsEntryIDReady(index: Smallint): Smallint;
    function IsError: Smallint;
    procedure Done;
    function AddRecipient: Smallint;
    function SetAreaCode(const sAreaCode: WideString): Smallint;
    function SetCountryCode(const sCountryCode: WideString): Smallint;
    function SetExtension(const sExtension: WideString): Smallint;
    function ShowSendScreen(nShowSndScreen: Smallint): Smallint;
    function SetPrintFromApp(nPrintDriverJob: Smallint): Smallint;
    function IsReadyToPrint: Smallint;
    function ShowCallProgess(nCallProgress: Smallint): Smallint;
    function LeaveRunning: Smallint;
    function GetAttachmentCount: Smallint;
    function RemoveAllAttachments: Smallint;
    function GetRecipientCount: Smallint;
    function RemoveRecipient(recipient: Smallint): Smallint;
    function RemoveAllRecipients: Smallint;
    function ResetGeneralSettings: Smallint;
    function SetCurrentRecipient(recipient: Smallint): Smallint;
    function ResetCurrentRecipient: Smallint;
    function GetTypeCount: Smallint;
    function GetType(atype: Smallint): WideString;
    function SetType(atype: Smallint): Smallint;
    function SetTypeByName(const Name: WideString): Smallint;
    function SetUserGroupEntryID(const entryID: WideString): Smallint;
    function GetLastError: Integer;
    function EnableBillingCodeKeyWords(enable: Smallint): Smallint;
    function AddStreamFileName(const filename: WideString): Smallint;
    function MakeAttachment(const sKeyword: WideString; const sDirectory: WideString; 
                            nConversion: Smallint): Smallint;
    function SetDeviceName(const sDeviceName: WideString): Smallint;
    function SetScannerMode(nMode: Smallint): Smallint;
    function SetClientID(const clientID: WideString): Smallint;
    function SetClientEntryID(const cliententryId: WideString): Smallint;
    function SetClientCookie(cookie: Integer): Smallint;
    function ShowCallProgress(nCallProgress: Smallint): Smallint;
    property  ControlInterface: ISDKSend read GetControlInterface;
  published
    property Application_: IDispatch index 1 read GetIDispatchProp write SetIDispatchProp stored False;
    property OnEntryIDReady: TCSDKSendEntryIDReady read FOnEntryIDReady write FOnEntryIDReady;
    property OnReceivedEvent: TCSDKSendReceivedEvent read FOnReceivedEvent write FOnReceivedEvent;
    property OnStatus: TCSDKSendStatus read FOnStatus write FOnStatus;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TCSDKView
// Help String      : 
// Default Interface: ISDKView
// Def. Intf. DISP? : Yes
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TCSDKView = class(TOleControl)
  private
    FIntf: ISDKView;
    function  GetControlInterface: ISDKView;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function ViewFax(const messageID: WideString): Smallint;
    function PlayVoice(const messageID: WideString): Smallint;
    function ViewBFT(const messageID: WideString): Smallint;
    property  ControlInterface: ISDKView read GetControlInterface;
  published
    property Application_: IDispatch index 1 read GetIDispatchProp write SetIDispatchProp stored False;
    property error: Smallint index 2 read GetSmallintProp write SetSmallintProp stored False;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TCSDKPhoneBook
// Help String      : 
// Default Interface: ISDKPhoneBook
// Def. Intf. DISP? : Yes
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TCSDKPhoneBook = class(TOleControl)
  private
    FIntf: ISDKPhoneBook;
    function  GetControlInterface: ISDKPhoneBook;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function GetFolderListFirst(standardFolder: Smallint; const folderID: WideString): WideString;
    function GetFolderListNext: WideString;
    function GetUserGroupFirst(standardFolder: Smallint; const folderID: WideString): WideString;
    function GetUserGroupNext: WideString;
    function SetFolderDisplayName(const sFolder: WideString; const sName: WideString): Smallint;
    function GetFolderDisplayName(const folderID: WideString): WideString;
    function SetGroupDisplayName(const folderID: WideString; const displayname: WideString): Smallint;
    function GetGroupDisplayName(const groupID: WideString): WideString;
    function CompareFolderEntryIDs(const ID1: WideString; const ID2: WideString): WordBool;
    function CompareUserGroupEntryIDs(const ID1: WideString; const ID2: WideString): WordBool;
    function SetUserDisplayName(const userID: WideString; const displayname: WideString): Smallint;
    function GetUserDisplayName(const userID: WideString): WideString;
    function SetUserTitle(const userID: WideString; const title: WideString): Smallint;
    function GetUserTitle(const userID: WideString): WideString;
    function SetUserFirstName(const userID: WideString; const firstName: WideString): Smallint;
    function GetUserFirstName(const userID: WideString): WideString;
    function SetUserLastName(const userID: WideString; const lastName: WideString): Smallint;
    function GetUserLastName(const userID: WideString): WideString;
    function SetUserCompany(const userID: WideString; const company: WideString): Smallint;
    function GetUserCompany(const userID: WideString): WideString;
    function SetUserAddress1(const userID: WideString; const address1: WideString): Smallint;
    function GetUserAddress1(const userID: WideString): WideString;
    function SetUserAddress2(const userID: WideString; const address2: WideString): Smallint;
    function GetUserAddress2(const userID: WideString): WideString;
    function SetUserCity(const userID: WideString; const city: WideString): Smallint;
    function GetUserCity(const userID: WideString): WideString;
    function SetUserState(const userID: WideString; const state: WideString): Smallint;
    function GetUserState(const userID: WideString): WideString;
    function SetUserCountry(const userID: WideString; const country: WideString): Smallint;
    function GetUserCountry(const userID: WideString): WideString;
    function SetUserPostalCode(const userID: WideString; const code: WideString): Smallint;
    function GetUserPostalCode(const userID: WideString): WideString;
    function GetType(const eventID: WideString): Smallint;
    function SetUserFaxCountry(const userID: WideString; const number: WideString): Smallint;
    function GetUserFaxCountry(const userID: WideString): WideString;
    function SetUserFaxArea(const userID: WideString; const number: WideString): Smallint;
    function GetUserFaxArea(const userID: WideString): WideString;
    function SetUserFaxLocal(const userID: WideString; const number: WideString): Smallint;
    function GetUserFaxLocal(const userID: WideString): WideString;
    function SetUserFaxExtension(const userID: WideString; const number: WideString): Smallint;
    function GetUserFaxExtension(const userID: WideString): WideString;
    function SetUserFaxAltCountry(const userID: WideString; const number: WideString): Smallint;
    function GetUserFaxAltCountry(const userID: WideString): WideString;
    function SetUserFaxAltArea(const userID: WideString; const number: WideString): Smallint;
    function GetUserFaxAltArea(const userID: WideString): WideString;
    function SetUserFaxAltLocal(const userID: WideString; const number: WideString): Smallint;
    function GetUserFaxAltLocal(const userID: WideString): WideString;
    function SetUserFaxAltExtension(const userID: WideString; const number: WideString): Smallint;
    function GetUserFaxAltExtension(const userID: WideString): WideString;
    function SetUserCSID(const userID: WideString; const csid: WideString): Smallint;
    function GetUserCSID(const userID: WideString): WideString;
    function SetUserVoiceCountry(const userID: WideString; const number: WideString): Smallint;
    function GetUserVoiceCountry(const userID: WideString): WideString;
    function SetUserVoiceArea(const userID: WideString; const number: WideString): Smallint;
    function GetUserVoiceArea(const userID: WideString): WideString;
    function SetUserVoiceLocal(const userID: WideString; const number: WideString): Smallint;
    function GetUserVoiceLocal(const userID: WideString): WideString;
    function SetUserVoiceExtension(const userID: WideString; const number: WideString): Smallint;
    function GetUserVoiceExtension(const userID: WideString): WideString;
    function SetUserCellCountry(const userID: WideString; const number: WideString): Smallint;
    function GetUserCellCountry(const userID: WideString): WideString;
    function SetUserCellArea(const userID: WideString; const number: WideString): Smallint;
    function GetUserCellArea(const userID: WideString): WideString;
    function SetUserCellLocal(const userID: WideString; const number: WideString): Smallint;
    function GetUserCellLocal(const userID: WideString): WideString;
    function SetUserCellExtension(const userID: WideString; const number: WideString): Smallint;
    function GetUserCellExtension(const userID: WideString): WideString;
    function AddFolder(standardFolder: Smallint; const folderID: WideString; 
                       const folderName: WideString; const comment: WideString): WideString;
    function AddUser(standardFolder: Smallint; const folderID: WideString; 
                     const firstName: WideString; const lastName: WideString; 
                     const company: WideString): WideString;
    function AddGroup(standardFolder: Smallint; const folderID: WideString;
                      const groupName: WideString): WideString;
    function DeleteFolder(const folderID: WideString): Smallint;
    function DeleteUser(const userID: WideString): Smallint;
    function DeleteGroup(const groupID: WideString): Smallint;
    property  ControlInterface: ISDKPhoneBook read GetControlInterface;
  published
    property Application_: IDispatch index 1 read GetIDispatchProp write SetIDispatchProp stored False;
    property error: Smallint index 2 read GetSmallintProp write SetSmallintProp stored False;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TCSDKLog
// Help String      : 
// Default Interface: ISDKLog
// Def. Intf. DISP? : Yes
// Event   Interface:
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TCSDKLog = class(TOleControl)
  private
    FIntf: ISDKLog;
    function  GetControlInterface: ISDKLog;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function GetUnreadReceivedFaxCount: Integer;
    function GetFolderListFirst(standardFolder: Smallint; const folderID: WideString): WideString;
    function GetFolderListNext: WideString;
    function GetMessageListFirst(standardFolder: Smallint; const folderID: WideString): WideString;
    function GetMessageListNext: WideString;
    function DeleteMessage(const messageID: WideString): Smallint;
    function DeleteFolder(const folderID: WideString): Smallint;
    function AddFolder(standardFolder: Smallint; const folderID: WideString;
                       const folderName: WideString; const comment: WideString): WideString;
    function GetMessageDisplayName(const messageID: WideString): WideString;
    function SetMessageDisplayName(const messageID: WideString; const displayname: WideString): Smallint;
    function GetMessageTo(const messageID: WideString): WideString;
    function SetMessageTo(const messageID: WideString; const ato: WideString): Smallint;
    function GetMessageNumber(const messageID: WideString): WideString;
    function SetMessageNumber(const messageID: WideString; const number: WideString): Smallint;
    function GetMessageSubject(const messageID: WideString): WideString;
    function SetMessageSubject(const messageID: WideString; const subject: WideString): Smallint;
    function GetMessageCompany(const messageID: WideString): WideString;
    function SetMessageCompany(const messageID: WideString; const company: WideString): Smallint;
    function GetMessageKeywords(const messageID: WideString): WideString;
    function SetMessageKeywords(const messageID: WideString; const keywords: WideString): Smallint;
    function GetMessageBillingCode(const messageID: WideString): WideString;
    function SetMessageBillingCode(const messageID: WideString; const billingCode: WideString): Smallint;
    function GetMessageAttachmentCount(const messageID: WideString): Smallint;
    function GetFolderDisplayName(const folderID: WideString): WideString;
    function SetFolderDisplayName(const folderID: WideString; const displayname: WideString): Smallint;
    function GetUnreadReceivedVoiceCount: Integer;
    function GetMessageHold(const messageID: WideString): Smallint;
    function GetMessageDate(const messageID: WideString): WideString;
    function GetMessageTime(const messageID: WideString): WideString;
    function GetType(const eventID: WideString): Smallint;
    function CompareFolderEntryIDs(const ID1: WideString; const ID2: WideString): WordBool;
    function CompareMessageEntryIDs(const ID1: WideString; const ID2: WideString): WordBool;
    function GetMessageStatus(const messageID: WideString): Smallint;
    function GetMessageFirstFile(const folderID: WideString; const messageID: WideString): WideString;
    function GetMessageNextFile: WideString;
    function GetMessageCSID(const messageID: WideString): WideString;
    function GetMessagePageCount(const messageID: WideString): Smallint;
    function SetMessageHold(const messageID: WideString): Smallint;
    function SetMessageRelease(const messageID: WideString): Smallint;
    function GetUnreadReceiveList: WideString;
    function SetMessageTimeShort(const messageID: WideString; time: Smallint): Smallint;
    function SetMessageDateShort(const messageID: WideString; date: Smallint): Smallint;
    function GetMessagePropertyShort(const messageID: WideString; propertyTag: Integer): Smallint;
    function GetMessagePropertyString(const messageID: WideString; propertyTag: Integer): WideString;
    function GetMultiMessageReceiveData(const messageIDList: WideString): WideString;
    function ClientFinishedSendProcessing(const HostEID: WideString): Smallint;
    function ClientFinishedReceiveProcessing(const HostEID: WideString): Smallint;
    function SetReadFileName(const filename: WideString; var size: Integer): Smallint;
    function GetMessageTimeShort(const messageID: WideString): Smallint;
    function GetMessageDateShort(const messageID: WideString): Smallint;
    procedure SetMessageReadState(const messageID: WideString; bRead: WordBool);
    function GetMessageResolution(const messageID: WideString): Smallint;
    function GetMessageErrorCode(const messageID: WideString): Smallint;
    function GetMessageDuration(const messageID: WideString): Integer;
    function GetMessageBaudRate(const messageID: WideString): Smallint;
    function GetMessageUsedECM(const messageID: WideString): Smallint;
    function GetMessagePropertyBinary(const messageID: WideString; propertyTag: Integer): OleVariant;
    function GetMessagePropertyLong(const messageID: WideString; propertyTag: Integer): Integer;
    function GetMessageDeviceNameUsed(const messageID: WideString): WideString;
    function GetMessageRetries(const messageID: WideString): Smallint;
    function DeleteEventandFiles(const messageID: WideString): Smallint;
    function CancelMessage(const messageID: WideString): Smallint;
    property  ControlInterface: ISDKLog read GetControlInterface;
  published
    property Application_: IDispatch index 1 read GetIDispatchProp write SetIDispatchProp stored False;
    property error: Smallint index 2 read GetSmallintProp write SetSmallintProp stored False;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TCSDKScan
// Help String      : 
// Default Interface: ISDKScan
// Def. Intf. DISP? : Yes
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TCSDKScan = class(TOleControl)
  private
    FIntf: ISDKScan;
    function  GetControlInterface: ISDKScan;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function ScanAndSend: SCODE;
    function ScanToAttachment(var pnPages: Smallint; var lpszBasePath: WideString; 
                              var lpszExtension: WideString): SCODE;
    function ScanToFile(var pnPages: Smallint; var lpszBasePath: WideString; 
                        var lpszExtension: WideString): SCODE;
    function IsScanningEnabled: SCODE;
    function SelectScanner: SCODE;
    property  ControlInterface: ISDKScan read GetControlInterface;
  published
    property Application_: IDispatch index 1 read GetIDispatchProp write SetIDispatchProp stored False;
  end;

  CoCHostCtrl = class
    class function Create: IHostCtrl;
    class function CreateRemote(const MachineName: string): IHostCtrl;
  end;

procedure Register;

implementation

uses ComObj;

class function CoCSDKFXConverter.Create: ISDKFXConverter;
begin
  Result := CreateComObject(CLASS_CSDKFXConverter) as ISDKFXConverter;
end;

class function CoCSDKFXConverter.CreateRemote(const MachineName: string): ISDKFXConverter;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CSDKFXConverter) as ISDKFXConverter;
end;

class function CoCOleWinFaxApp.Create: IOleWinFaxApp;
begin
  Result := CreateComObject(CLASS_COleWinFaxApp) as IOleWinFaxApp;
end;

class function CoCOleWinFaxApp.CreateRemote(const MachineName: string): IOleWinFaxApp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_COleWinFaxApp) as IOleWinFaxApp;
end;

class function CoCOleAttachment.Create: IOleAttachment;
begin
  Result := CreateComObject(CLASS_COleAttachment) as IOleAttachment;
end;

class function CoCOleAttachment.CreateRemote(const MachineName: string): IOleAttachment;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_COleAttachment) as IOleAttachment;
end;

class function CoCOleAttachments.Create: IOleAttachments;
begin
  Result := CreateComObject(CLASS_COleAttachments) as IOleAttachments;
end;

class function CoCOleAttachments.CreateRemote(const MachineName: string): IOleAttachments;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_COleAttachments) as IOleAttachments;
end;

class function CoCOleCoverPage.Create: IOleCoverPage;
begin
  Result := CreateComObject(CLASS_COleCoverPage) as IOleCoverPage;
end;

class function CoCOleCoverPage.CreateRemote(const MachineName: string): IOleCoverPage;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_COleCoverPage) as IOleCoverPage;
end;

class function CoCOleCoverPages.Create: IOleCoverPages;
begin
  Result := CreateComObject(CLASS_COleCoverPages) as IOleCoverPages;
end;

class function CoCOleCoverPages.CreateRemote(const MachineName: string): IOleCoverPages;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_COleCoverPages) as IOleCoverPages;
end;

procedure TCSDKSend.InitControlData;
const
  CEventDispIDs: array [0..2] of DWORD = (
    $00000001, $00000002, $00000003);
  CControlData: TControlData2 = (
    ClassID: '{66A6D725-51CD-11D0-BD28-00805F98AB78}';
    EventIID: '{6F12F9A0-75FB-11D0-BD2A-00805F98AB78}';
    EventCount: 3;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnEntryIDReady) - Cardinal(Self);
end;

procedure TCSDKSend.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ISDKSend;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TCSDKSend.GetControlInterface: ISDKSend;
begin
  CreateControl;
  Result := FIntf;
end;

function TCSDKSend.SetTo(const sTo: WideString): Smallint;
begin
  Result := ControlInterface.SetTo(sTo);
end;

function TCSDKSend.SetNumber(const sNumber: WideString): Smallint;
begin
  Result := ControlInterface.SetNumber(sNumber);
end;

function TCSDKSend.SetSubject(const sSubject: WideString): Smallint;
begin
  Result := ControlInterface.SetSubject(sSubject);
end;

function TCSDKSend.SetCoverText(const sCoverText: WideString): Smallint;
begin
  Result := ControlInterface.SetCoverText(sCoverText);
end;

function TCSDKSend.Send(need_entryIDs: Smallint): Smallint;
begin
  Result := ControlInterface.Send(need_entryIDs);
end;

function TCSDKSend.Cancel: Smallint;
begin
  Result := ControlInterface.Cancel;
end;

function TCSDKSend.SetCompany(const sCompany: WideString): Smallint;
begin
  Result := ControlInterface.SetCompany(sCompany);
end;

function TCSDKSend.SetKeywords(const sKeywords: WideString): Smallint;
begin
  Result := ControlInterface.SetKeywords(sKeywords);
end;

function TCSDKSend.SetBillingCode(const sBillingCode: WideString): Smallint;
begin
  Result := ControlInterface.SetBillingCode(sBillingCode);
end;

function TCSDKSend.SetTime(const sTime: WideString): Smallint;
begin
  Result := ControlInterface.SetTime(sTime);
end;

function TCSDKSend.SetDate(const sDate: WideString): Smallint;
begin
  Result := ControlInterface.SetDate(sDate);
end;

function TCSDKSend.SetOffPeak(nOffPeak: Smallint): Smallint;
begin
  Result := ControlInterface.SetOffPeak(nOffPeak);
end;

function TCSDKSend.SetHold(nHold: Smallint): Smallint;
begin
  Result := ControlInterface.SetHold(nHold);
end;

function TCSDKSend.SetPriority(nPriority: Smallint): Smallint;
begin
  Result := ControlInterface.SetPriority(nPriority);
end;

function TCSDKSend.SetUsePrefix(nUsePrefix: Smallint): Smallint;
begin
  Result := ControlInterface.SetUsePrefix(nUsePrefix);
end;

function TCSDKSend.SetUseCreditCard(nUseCreditCard: Smallint): Smallint;
begin
  Result := ControlInterface.SetUseCreditCard(nUseCreditCard);
end;

function TCSDKSend.SetResolution(nResolution: Smallint): Smallint;
begin
  Result := ControlInterface.SetResolution(nResolution);
end;

function TCSDKSend.SetDeleteAfterSend(nDeleteAfterSend: Smallint): Smallint;
begin
  Result := ControlInterface.SetDeleteAfterSend(nDeleteAfterSend);
end;

function TCSDKSend.AddAttachment(nIndex: Smallint): Smallint;
begin
  Result := ControlInterface.AddAttachment(nIndex);
end;

function TCSDKSend.AddAttachmentFile(const sFile: WideString): Smallint;
begin
  Result := ControlInterface.AddAttachmentFile(sFile);
end;

function TCSDKSend.SetQuickCover(nQuickCover: Smallint): Smallint;
begin
  Result := ControlInterface.SetQuickCover(nQuickCover);
end;

function TCSDKSend.SetCoverPage(nIndex: Smallint): Smallint;
begin
  Result := ControlInterface.SetCoverPage(nIndex);
end;

function TCSDKSend.SetCoverFile(const sCoverFile: WideString): Smallint;
begin
  Result := ControlInterface.SetCoverFile(sCoverFile);
end;

function TCSDKSend.SetDialPrefix(const sDialPrefix: WideString): Smallint;
begin
  Result := ControlInterface.SetDialPrefix(sDialPrefix);
end;

function TCSDKSend.SetBCC(nBCC: Smallint): Smallint;
begin
  Result := ControlInterface.SetBCC(nBCC);
end;

function TCSDKSend.SetUseCover(nUseCover: Smallint): Smallint;
begin
  Result := ControlInterface.SetUseCover(nUseCover);
end;

function TCSDKSend.SetPreviewFax(nPreviewFax: Smallint): Smallint;
begin
  Result := ControlInterface.SetPreviewFax(nPreviewFax);
end;

function TCSDKSend.GetEntryID(index: Smallint): WideString;
begin
  Result := ControlInterface.GetEntryID(index);
end;

function TCSDKSend.IsEntryIDReady(index: Smallint): Smallint;
begin
  Result := ControlInterface.IsEntryIDReady(index);
end;

function TCSDKSend.IsError: Smallint;
begin
  Result := ControlInterface.IsError;
end;

procedure TCSDKSend.Done;
begin
  ControlInterface.Done;
end;

function TCSDKSend.AddRecipient: Smallint;
begin
  Result := ControlInterface.AddRecipient;
end;

function TCSDKSend.SetAreaCode(const sAreaCode: WideString): Smallint;
begin
  Result := ControlInterface.SetAreaCode(sAreaCode);
end;

function TCSDKSend.SetCountryCode(const sCountryCode: WideString): Smallint;
begin
  Result := ControlInterface.SetCountryCode(sCountryCode);
end;

function TCSDKSend.SetExtension(const sExtension: WideString): Smallint;
begin
  Result := ControlInterface.SetExtension(sExtension);
end;

function TCSDKSend.ShowSendScreen(nShowSndScreen: Smallint): Smallint;
begin
  Result := ControlInterface.ShowSendScreen(nShowSndScreen);
end;

function TCSDKSend.SetPrintFromApp(nPrintDriverJob: Smallint): Smallint;
begin
  Result := ControlInterface.SetPrintFromApp(nPrintDriverJob);
end;

function TCSDKSend.IsReadyToPrint: Smallint;
begin
  Result := ControlInterface.IsReadyToPrint;
end;

function TCSDKSend.ShowCallProgess(nCallProgress: Smallint): Smallint;
begin
  Result := ControlInterface.ShowCallProgess(nCallProgress);
end;

function TCSDKSend.LeaveRunning: Smallint;
begin
  Result := ControlInterface.LeaveRunning;
end;

function TCSDKSend.GetAttachmentCount: Smallint;
begin
  Result := ControlInterface.GetAttachmentCount;
end;

function TCSDKSend.RemoveAllAttachments: Smallint;
begin
  Result := ControlInterface.RemoveAllAttachments;
end;

function TCSDKSend.GetRecipientCount: Smallint;
begin
  Result := ControlInterface.GetRecipientCount;
end;

function TCSDKSend.RemoveRecipient(recipient: Smallint): Smallint;
begin
  Result := ControlInterface.RemoveRecipient(recipient);
end;

function TCSDKSend.RemoveAllRecipients: Smallint;
begin
  Result := ControlInterface.RemoveAllRecipients;
end;

function TCSDKSend.ResetGeneralSettings: Smallint;
begin
  Result := ControlInterface.ResetGeneralSettings;
end;

function TCSDKSend.SetCurrentRecipient(recipient: Smallint): Smallint;
begin
  Result := ControlInterface.SetCurrentRecipient(recipient);
end;

function TCSDKSend.ResetCurrentRecipient: Smallint;
begin
  Result := ControlInterface.ResetCurrentRecipient;
end;

function TCSDKSend.GetTypeCount: Smallint;
begin
  Result := ControlInterface.GetTypeCount;
end;

function TCSDKSend.GetType(atype: Smallint): WideString;
begin
  Result := ControlInterface.GetType(atype);
end;

function TCSDKSend.SetType(atype: Smallint): Smallint;
begin
  Result := ControlInterface.SetType(atype);
end;

function TCSDKSend.SetTypeByName(const Name: WideString): Smallint;
begin
  Result := ControlInterface.SetTypeByName(Name);
end;

function TCSDKSend.SetUserGroupEntryID(const entryID: WideString): Smallint;
begin
  Result := ControlInterface.SetUserGroupEntryID(entryID);
end;

function TCSDKSend.GetLastError: Integer;
begin
  Result := ControlInterface.GetLastError;
end;

function TCSDKSend.EnableBillingCodeKeyWords(enable: Smallint): Smallint;
begin
  Result := ControlInterface.EnableBillingCodeKeyWords(enable);
end;

function TCSDKSend.AddStreamFileName(const filename: WideString): Smallint;
begin
  Result := ControlInterface.AddStreamFileName(filename);
end;

function TCSDKSend.MakeAttachment(const sKeyword: WideString; const sDirectory: WideString; 
                                  nConversion: Smallint): Smallint;
begin
  Result := ControlInterface.MakeAttachment(sKeyword, sDirectory, nConversion);
end;

function TCSDKSend.SetDeviceName(const sDeviceName: WideString): Smallint;
begin
  Result := ControlInterface.SetDeviceName(sDeviceName);
end;

function TCSDKSend.SetScannerMode(nMode: Smallint): Smallint;
begin
  Result := ControlInterface.SetScannerMode(nMode);
end;

function TCSDKSend.SetClientID(const clientID: WideString): Smallint;
begin
  Result := ControlInterface.SetClientID(clientID);
end;

function TCSDKSend.SetClientEntryID(const cliententryId: WideString): Smallint;
begin
  Result := ControlInterface.SetClientEntryID(cliententryId);
end;

function TCSDKSend.SetClientCookie(cookie: Integer): Smallint;
begin
  Result := ControlInterface.SetClientCookie(cookie);
end;

function TCSDKSend.ShowCallProgress(nCallProgress: Smallint): Smallint;
begin
  Result := ControlInterface.ShowCallProgress(nCallProgress);
end;

procedure TCSDKView.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{B71B64C0-8EF2-11D0-961C-444553540000}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TCSDKView.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ISDKView;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TCSDKView.GetControlInterface: ISDKView;
begin
  CreateControl;
  Result := FIntf;
end;

function TCSDKView.ViewFax(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.ViewFax(messageID);
end;

function TCSDKView.PlayVoice(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.PlayVoice(messageID);
end;

function TCSDKView.ViewBFT(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.ViewBFT(messageID);
end;

procedure TCSDKPhoneBook.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{A67FCC80-9949-11D0-961E-444553540000}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TCSDKPhoneBook.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ISDKPhoneBook;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TCSDKPhoneBook.GetControlInterface: ISDKPhoneBook;
begin
  CreateControl;
  Result := FIntf;
end;

function TCSDKPhoneBook.GetFolderListFirst(standardFolder: Smallint; const folderID: WideString): WideString;
begin
  Result := ControlInterface.GetFolderListFirst(standardFolder, folderID);
end;

function TCSDKPhoneBook.GetFolderListNext: WideString;
begin
  Result := ControlInterface.GetFolderListNext;
end;

function TCSDKPhoneBook.GetUserGroupFirst(standardFolder: Smallint; const folderID: WideString): WideString;
begin
  Result := ControlInterface.GetUserGroupFirst(standardFolder, folderID);
end;

function TCSDKPhoneBook.GetUserGroupNext: WideString;
begin
  Result := ControlInterface.GetUserGroupNext;
end;

function TCSDKPhoneBook.SetFolderDisplayName(const sFolder: WideString; const sName: WideString): Smallint;
begin
  Result := ControlInterface.SetFolderDisplayName(sFolder, sName);
end;

function TCSDKPhoneBook.GetFolderDisplayName(const folderID: WideString): WideString;
begin
  Result := ControlInterface.GetFolderDisplayName(folderID);
end;

function TCSDKPhoneBook.SetGroupDisplayName(const folderID: WideString; 
                                            const displayname: WideString): Smallint;
begin
  Result := ControlInterface.SetGroupDisplayName(folderID, displayname);
end;

function TCSDKPhoneBook.GetGroupDisplayName(const groupID: WideString): WideString;
begin
  Result := ControlInterface.GetGroupDisplayName(groupID);
end;

function TCSDKPhoneBook.CompareFolderEntryIDs(const ID1: WideString; const ID2: WideString): WordBool;
begin
  Result := ControlInterface.CompareFolderEntryIDs(ID1, ID2);
end;

function TCSDKPhoneBook.CompareUserGroupEntryIDs(const ID1: WideString; const ID2: WideString): WordBool;
begin
  Result := ControlInterface.CompareUserGroupEntryIDs(ID1, ID2);
end;

function TCSDKPhoneBook.SetUserDisplayName(const userID: WideString; const displayname: WideString): Smallint;
begin
  Result := ControlInterface.SetUserDisplayName(userID, displayname);
end;

function TCSDKPhoneBook.GetUserDisplayName(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserDisplayName(userID);
end;

function TCSDKPhoneBook.SetUserTitle(const userID: WideString; const title: WideString): Smallint;
begin
  Result := ControlInterface.SetUserTitle(userID, title);
end;

function TCSDKPhoneBook.GetUserTitle(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserTitle(userID);
end;

function TCSDKPhoneBook.SetUserFirstName(const userID: WideString; const firstName: WideString): Smallint;
begin
  Result := ControlInterface.SetUserFirstName(userID, firstName);
end;

function TCSDKPhoneBook.GetUserFirstName(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserFirstName(userID);
end;

function TCSDKPhoneBook.SetUserLastName(const userID: WideString; const lastName: WideString): Smallint;
begin
  Result := ControlInterface.SetUserLastName(userID, lastName);
end;

function TCSDKPhoneBook.GetUserLastName(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserLastName(userID);
end;

function TCSDKPhoneBook.SetUserCompany(const userID: WideString; const company: WideString): Smallint;
begin
  Result := ControlInterface.SetUserCompany(userID, company);
end;

function TCSDKPhoneBook.GetUserCompany(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserCompany(userID);
end;

function TCSDKPhoneBook.SetUserAddress1(const userID: WideString; const address1: WideString): Smallint;
begin
  Result := ControlInterface.SetUserAddress1(userID, address1);
end;

function TCSDKPhoneBook.GetUserAddress1(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserAddress1(userID);
end;

function TCSDKPhoneBook.SetUserAddress2(const userID: WideString; const address2: WideString): Smallint;
begin
  Result := ControlInterface.SetUserAddress2(userID, address2);
end;

function TCSDKPhoneBook.GetUserAddress2(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserAddress2(userID);
end;

function TCSDKPhoneBook.SetUserCity(const userID: WideString; const city: WideString): Smallint;
begin
  Result := ControlInterface.SetUserCity(userID, city);
end;

function TCSDKPhoneBook.GetUserCity(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserCity(userID);
end;

function TCSDKPhoneBook.SetUserState(const userID: WideString; const state: WideString): Smallint;
begin
  Result := ControlInterface.SetUserState(userID, state);
end;

function TCSDKPhoneBook.GetUserState(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserState(userID);
end;

function TCSDKPhoneBook.SetUserCountry(const userID: WideString; const country: WideString): Smallint;
begin
  Result := ControlInterface.SetUserCountry(userID, country);
end;

function TCSDKPhoneBook.GetUserCountry(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserCountry(userID);
end;

function TCSDKPhoneBook.SetUserPostalCode(const userID: WideString; const code: WideString): Smallint;
begin
  Result := ControlInterface.SetUserPostalCode(userID, code);
end;

function TCSDKPhoneBook.GetUserPostalCode(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserPostalCode(userID);
end;

function TCSDKPhoneBook.GetType(const eventID: WideString): Smallint;
begin
  Result := ControlInterface.GetType(eventID);
end;

function TCSDKPhoneBook.SetUserFaxCountry(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserFaxCountry(userID, number);
end;

function TCSDKPhoneBook.GetUserFaxCountry(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserFaxCountry(userID);
end;

function TCSDKPhoneBook.SetUserFaxArea(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserFaxArea(userID, number);
end;

function TCSDKPhoneBook.GetUserFaxArea(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserFaxArea(userID);
end;

function TCSDKPhoneBook.SetUserFaxLocal(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserFaxLocal(userID, number);
end;

function TCSDKPhoneBook.GetUserFaxLocal(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserFaxLocal(userID);
end;

function TCSDKPhoneBook.SetUserFaxExtension(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserFaxExtension(userID, number);
end;

function TCSDKPhoneBook.GetUserFaxExtension(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserFaxExtension(userID);
end;

function TCSDKPhoneBook.SetUserFaxAltCountry(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserFaxAltCountry(userID, number);
end;

function TCSDKPhoneBook.GetUserFaxAltCountry(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserFaxAltCountry(userID);
end;

function TCSDKPhoneBook.SetUserFaxAltArea(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserFaxAltArea(userID, number);
end;

function TCSDKPhoneBook.GetUserFaxAltArea(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserFaxAltArea(userID);
end;

function TCSDKPhoneBook.SetUserFaxAltLocal(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserFaxAltLocal(userID, number);
end;

function TCSDKPhoneBook.GetUserFaxAltLocal(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserFaxAltLocal(userID);
end;

function TCSDKPhoneBook.SetUserFaxAltExtension(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserFaxAltExtension(userID, number);
end;

function TCSDKPhoneBook.GetUserFaxAltExtension(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserFaxAltExtension(userID);
end;

function TCSDKPhoneBook.SetUserCSID(const userID: WideString; const csid: WideString): Smallint;
begin
  Result := ControlInterface.SetUserCSID(userID, csid);
end;

function TCSDKPhoneBook.GetUserCSID(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserCSID(userID);
end;

function TCSDKPhoneBook.SetUserVoiceCountry(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserVoiceCountry(userID, number);
end;

function TCSDKPhoneBook.GetUserVoiceCountry(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserVoiceCountry(userID);
end;

function TCSDKPhoneBook.SetUserVoiceArea(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserVoiceArea(userID, number);
end;

function TCSDKPhoneBook.GetUserVoiceArea(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserVoiceArea(userID);
end;

function TCSDKPhoneBook.SetUserVoiceLocal(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserVoiceLocal(userID, number);
end;

function TCSDKPhoneBook.GetUserVoiceLocal(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserVoiceLocal(userID);
end;

function TCSDKPhoneBook.SetUserVoiceExtension(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserVoiceExtension(userID, number);
end;

function TCSDKPhoneBook.GetUserVoiceExtension(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserVoiceExtension(userID);
end;

function TCSDKPhoneBook.SetUserCellCountry(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserCellCountry(userID, number);
end;

function TCSDKPhoneBook.GetUserCellCountry(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserCellCountry(userID);
end;

function TCSDKPhoneBook.SetUserCellArea(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserCellArea(userID, number);
end;

function TCSDKPhoneBook.GetUserCellArea(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserCellArea(userID);
end;

function TCSDKPhoneBook.SetUserCellLocal(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserCellLocal(userID, number);
end;

function TCSDKPhoneBook.GetUserCellLocal(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserCellLocal(userID);
end;

function TCSDKPhoneBook.SetUserCellExtension(const userID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetUserCellExtension(userID, number);
end;

function TCSDKPhoneBook.GetUserCellExtension(const userID: WideString): WideString;
begin
  Result := ControlInterface.GetUserCellExtension(userID);
end;

function TCSDKPhoneBook.AddFolder(standardFolder: Smallint; const folderID: WideString; 
                                  const folderName: WideString; const comment: WideString): WideString;
begin
  Result := ControlInterface.AddFolder(standardFolder, folderID, folderName, comment);
end;

function TCSDKPhoneBook.AddUser(standardFolder: Smallint; const folderID: WideString; 
                                const firstName: WideString; const lastName: WideString; 
                                const company: WideString): WideString;
begin
  Result := ControlInterface.AddUser(standardFolder, folderID, firstName, lastName, company);
end;

function TCSDKPhoneBook.AddGroup(standardFolder: Smallint; const folderID: WideString; 
                                 const groupName: WideString): WideString;
begin
  Result := ControlInterface.AddGroup(standardFolder, folderID, groupName);
end;

function TCSDKPhoneBook.DeleteFolder(const folderID: WideString): Smallint;
begin
  Result := ControlInterface.DeleteFolder(folderID);
end;

function TCSDKPhoneBook.DeleteUser(const userID: WideString): Smallint;
begin
  Result := ControlInterface.DeleteUser(userID);
end;

function TCSDKPhoneBook.DeleteGroup(const groupID: WideString): Smallint;
begin
  Result := ControlInterface.DeleteGroup(groupID);
end;

procedure TCSDKLog.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{2B9E21E0-8F00-11D0-961C-444553540000}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TCSDKLog.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ISDKLog;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TCSDKLog.GetControlInterface: ISDKLog;
begin
  CreateControl;
  Result := FIntf;
end;

function TCSDKLog.GetUnreadReceivedFaxCount: Integer;
begin
  Result := ControlInterface.GetUnreadReceivedFaxCount;
end;

function TCSDKLog.GetFolderListFirst(standardFolder: Smallint; const folderID: WideString): WideString;
begin
  Result := ControlInterface.GetFolderListFirst(standardFolder, folderID);
end;

function TCSDKLog.GetFolderListNext: WideString;
begin
  Result := ControlInterface.GetFolderListNext;
end;

function TCSDKLog.GetMessageListFirst(standardFolder: Smallint; const folderID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageListFirst(standardFolder, folderID);
end;

function TCSDKLog.GetMessageListNext: WideString;
begin
  Result := ControlInterface.GetMessageListNext;
end;

function TCSDKLog.DeleteMessage(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.DeleteMessage(messageID);
end;

function TCSDKLog.DeleteFolder(const folderID: WideString): Smallint;
begin
  Result := ControlInterface.DeleteFolder(folderID);
end;

function TCSDKLog.AddFolder(standardFolder: Smallint; const folderID: WideString; 
                            const folderName: WideString; const comment: WideString): WideString;
begin
  Result := ControlInterface.AddFolder(standardFolder, folderID, folderName, comment);
end;

function TCSDKLog.GetMessageDisplayName(const messageID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageDisplayName(messageID);
end;

function TCSDKLog.SetMessageDisplayName(const messageID: WideString; const displayname: WideString): Smallint;
begin
  Result := ControlInterface.SetMessageDisplayName(messageID, displayname);
end;

function TCSDKLog.GetMessageTo(const messageID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageTo(messageID);
end;

function TCSDKLog.SetMessageTo(const messageID: WideString; const ato: WideString): Smallint;
begin
  Result := ControlInterface.SetMessageTo(messageID, ato);
end;

function TCSDKLog.GetMessageNumber(const messageID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageNumber(messageID);
end;

function TCSDKLog.SetMessageNumber(const messageID: WideString; const number: WideString): Smallint;
begin
  Result := ControlInterface.SetMessageNumber(messageID, number);
end;

function TCSDKLog.GetMessageSubject(const messageID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageSubject(messageID);
end;

function TCSDKLog.SetMessageSubject(const messageID: WideString; const subject: WideString): Smallint;
begin
  Result := ControlInterface.SetMessageSubject(messageID, subject);
end;

function TCSDKLog.GetMessageCompany(const messageID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageCompany(messageID);
end;

function TCSDKLog.SetMessageCompany(const messageID: WideString; const company: WideString): Smallint;
begin
  Result := ControlInterface.SetMessageCompany(messageID, company);
end;

function TCSDKLog.GetMessageKeywords(const messageID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageKeywords(messageID);
end;

function TCSDKLog.SetMessageKeywords(const messageID: WideString; const keywords: WideString): Smallint;
begin
  Result := ControlInterface.SetMessageKeywords(messageID, keywords);
end;

function TCSDKLog.GetMessageBillingCode(const messageID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageBillingCode(messageID);
end;

function TCSDKLog.SetMessageBillingCode(const messageID: WideString; const billingCode: WideString): Smallint;
begin
  Result := ControlInterface.SetMessageBillingCode(messageID, billingCode);
end;

function TCSDKLog.GetMessageAttachmentCount(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.GetMessageAttachmentCount(messageID);
end;

function TCSDKLog.GetFolderDisplayName(const folderID: WideString): WideString;
begin
  Result := ControlInterface.GetFolderDisplayName(folderID);
end;

function TCSDKLog.SetFolderDisplayName(const folderID: WideString; const displayname: WideString): Smallint;
begin
  Result := ControlInterface.SetFolderDisplayName(folderID, displayname);
end;

function TCSDKLog.GetUnreadReceivedVoiceCount: Integer;
begin
  Result := ControlInterface.GetUnreadReceivedVoiceCount;
end;

function TCSDKLog.GetMessageHold(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.GetMessageHold(messageID);
end;

function TCSDKLog.GetMessageDate(const messageID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageDate(messageID);
end;

function TCSDKLog.GetMessageTime(const messageID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageTime(messageID);
end;

function TCSDKLog.GetType(const eventID: WideString): Smallint;
begin
  Result := ControlInterface.GetType(eventID);
end;

function TCSDKLog.CompareFolderEntryIDs(const ID1: WideString; const ID2: WideString): WordBool;
begin
  Result := ControlInterface.CompareFolderEntryIDs(ID1, ID2);
end;

function TCSDKLog.CompareMessageEntryIDs(const ID1: WideString; const ID2: WideString): WordBool;
begin
  Result := ControlInterface.CompareMessageEntryIDs(ID1, ID2);
end;

function TCSDKLog.GetMessageStatus(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.GetMessageStatus(messageID);
end;

function TCSDKLog.GetMessageFirstFile(const folderID: WideString; const messageID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageFirstFile(folderID, messageID);
end;

function TCSDKLog.GetMessageNextFile: WideString;
begin
  Result := ControlInterface.GetMessageNextFile;
end;

function TCSDKLog.GetMessageCSID(const messageID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageCSID(messageID);
end;

function TCSDKLog.GetMessagePageCount(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.GetMessagePageCount(messageID);
end;

function TCSDKLog.SetMessageHold(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.SetMessageHold(messageID);
end;

function TCSDKLog.SetMessageRelease(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.SetMessageRelease(messageID);
end;

function TCSDKLog.GetUnreadReceiveList: WideString;
begin
  Result := ControlInterface.GetUnreadReceiveList;
end;

function TCSDKLog.SetMessageTimeShort(const messageID: WideString; time: Smallint): Smallint;
begin
  Result := ControlInterface.SetMessageTimeShort(messageID, time);
end;

function TCSDKLog.SetMessageDateShort(const messageID: WideString; date: Smallint): Smallint;
begin
  Result := ControlInterface.SetMessageDateShort(messageID, date);
end;

function TCSDKLog.GetMessagePropertyShort(const messageID: WideString; propertyTag: Integer): Smallint;
begin
  Result := ControlInterface.GetMessagePropertyShort(messageID, propertyTag);
end;

function TCSDKLog.GetMessagePropertyString(const messageID: WideString; propertyTag: Integer): WideString;
begin
  Result := ControlInterface.GetMessagePropertyString(messageID, propertyTag);
end;

function TCSDKLog.GetMultiMessageReceiveData(const messageIDList: WideString): WideString;
begin
  Result := ControlInterface.GetMultiMessageReceiveData(messageIDList);
end;

function TCSDKLog.ClientFinishedSendProcessing(const HostEID: WideString): Smallint;
begin
  Result := ControlInterface.ClientFinishedSendProcessing(HostEID);
end;

function TCSDKLog.ClientFinishedReceiveProcessing(const HostEID: WideString): Smallint;
begin
  Result := ControlInterface.ClientFinishedReceiveProcessing(HostEID);
end;

function TCSDKLog.SetReadFileName(const filename: WideString; var size: Integer): Smallint;
begin
  Result := ControlInterface.SetReadFileName(filename, size);
end;

function TCSDKLog.GetMessageTimeShort(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.GetMessageTimeShort(messageID);
end;

function TCSDKLog.GetMessageDateShort(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.GetMessageDateShort(messageID);
end;

procedure TCSDKLog.SetMessageReadState(const messageID: WideString; bRead: WordBool);
begin
  ControlInterface.SetMessageReadState(messageID, bRead);
end;

function TCSDKLog.GetMessageResolution(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.GetMessageResolution(messageID);
end;

function TCSDKLog.GetMessageErrorCode(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.GetMessageErrorCode(messageID);
end;

function TCSDKLog.GetMessageDuration(const messageID: WideString): Integer;
begin
  Result := ControlInterface.GetMessageDuration(messageID);
end;

function TCSDKLog.GetMessageBaudRate(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.GetMessageBaudRate(messageID);
end;

function TCSDKLog.GetMessageUsedECM(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.GetMessageUsedECM(messageID);
end;

function TCSDKLog.GetMessagePropertyBinary(const messageID: WideString; propertyTag: Integer): OleVariant;
begin
  Result := ControlInterface.GetMessagePropertyBinary(messageID, propertyTag);
end;

function TCSDKLog.GetMessagePropertyLong(const messageID: WideString; propertyTag: Integer): Integer;
begin
  Result := ControlInterface.GetMessagePropertyLong(messageID, propertyTag);
end;

function TCSDKLog.GetMessageDeviceNameUsed(const messageID: WideString): WideString;
begin
  Result := ControlInterface.GetMessageDeviceNameUsed(messageID);
end;

function TCSDKLog.GetMessageRetries(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.GetMessageRetries(messageID);
end;

function TCSDKLog.DeleteEventandFiles(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.DeleteEventandFiles(messageID);
end;

function TCSDKLog.CancelMessage(const messageID: WideString): Smallint;
begin
  Result := ControlInterface.CancelMessage(messageID);
end;

procedure TCSDKScan.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{E13DF740-DE57-11D0-A414-00805F84C89A}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TCSDKScan.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ISDKScan;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TCSDKScan.GetControlInterface: ISDKScan;
begin
  CreateControl;
  Result := FIntf;
end;

function TCSDKScan.ScanAndSend: SCODE;
begin
  Result := ControlInterface.ScanAndSend;
end;

function TCSDKScan.ScanToAttachment(var pnPages: Smallint; var lpszBasePath: WideString; 
                                    var lpszExtension: WideString): SCODE;
begin
  Result := ControlInterface.ScanToAttachment(pnPages, lpszBasePath, lpszExtension);
end;

function TCSDKScan.ScanToFile(var pnPages: Smallint; var lpszBasePath: WideString; 
                              var lpszExtension: WideString): SCODE;
begin
  Result := ControlInterface.ScanToFile(pnPages, lpszBasePath, lpszExtension);
end;

function TCSDKScan.IsScanningEnabled: SCODE;
begin
  Result := ControlInterface.IsScanningEnabled;
end;

function TCSDKScan.SelectScanner: SCODE;
begin
  Result := ControlInterface.SelectScanner;
end;

class function CoCHostCtrl.Create: IHostCtrl;
begin
  Result := CreateComObject(CLASS_CHostCtrl) as IHostCtrl;
end;

class function CoCHostCtrl.CreateRemote(const MachineName: string): IHostCtrl;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CHostCtrl) as IHostCtrl;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TCSDKSend, TCSDKView, TCSDKPhoneBook, TCSDKLog, 
    TCSDKScan]);
end;

end.
