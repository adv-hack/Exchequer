unit entPrevX_TLB;

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
// File generated on 30/10/2002 09:58:22 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\FormTK\ACTIVEX\ENTPREVX.tlb (1)
// LIBID: {88C4D149-11DE-4857-8AAC-C1EBD3A072D4}
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

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  entPrevXMajorVersion = 1;
  entPrevXMinorVersion = 0;

  LIBID_entPrevX: TGUID = '{88C4D149-11DE-4857-8AAC-C1EBD3A072D4}';

  IID_IentPreviewX: TGUID = '{71E87F6F-5487-4A35-B999-08EFDF6D369A}';
  DIID_IentPreviewXEvents: TGUID = '{EEE020DB-A1D4-4891-A362-E5D48A0EA975}';
  CLASS_entPreviewX: TGUID = '{E731B405-F5E6-4932-9C91-02F559A6BBCB}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TxHelpType
type
  TxHelpType = TOleEnum;
const
  htKeyword = $00000000;
  htContext = $00000001;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IentPreviewX = interface;
  IentPreviewXDisp = dispinterface;
  IentPreviewXEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  entPreviewX = IentPreviewX;


// *********************************************************************//
// Interface: IentPreviewX
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {71E87F6F-5487-4A35-B999-08EFDF6D369A}
// *********************************************************************//
  IentPreviewX = interface(IDispatch)
    ['{71E87F6F-5487-4A35-B999-08EFDF6D369A}']
    function Get_Active: WordBool; safecall;
    procedure Set_Active(Value: WordBool); safecall;
    function Get_CurrentPage: Integer; safecall;
    procedure Set_CurrentPage(Value: Integer); safecall;
    function Get_Filename: WideString; safecall;
    procedure Set_Filename(const Value: WideString); safecall;
    function Get_Pages: Integer; safecall;
    function Get_Zoom: Double; safecall;
    procedure Set_Zoom(Value: Double); safecall;
    function Get_ZoomInc: Integer; safecall;
    procedure Set_ZoomInc(Value: Integer); safecall;
    function Get_ZoomPage: Double; safecall;
    procedure Set_ZoomPage(Value: Double); safecall;
    function Get_ZoomPageWidth: Double; safecall;
    procedure Set_ZoomPageWidth(Value: Double); safecall;
    procedure FirstPage; safecall;
    procedure PreviousPage; safecall;
    procedure NextPage; safecall;
    procedure LastPage; safecall;
    procedure ZoomIn; safecall;
    procedure ZoomOut; safecall;
    function Get_DoubleBuffered: WordBool; safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    function Get_AlignDisabled: WordBool; safecall;
    function Get_VisibleDockClientCount: Integer; safecall;
    function DrawTextBiDiModeFlagsReadingOnly: Integer; safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    procedure InitiateAction; safecall;
    function IsRightToLeft: WordBool; safecall;
    function UseRightToLeftReading: WordBool; safecall;
    function UseRightToLeftScrollBar: WordBool; safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_Cursor: Smallint; safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    function Get_HelpType: TxHelpType; safecall;
    procedure Set_HelpType(Value: TxHelpType); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const Value: WideString); safecall;
    procedure SetSubComponent(IsSubComponent: WordBool); safecall;
    procedure AboutBox; safecall;
    property Active: WordBool read Get_Active write Set_Active;
    property CurrentPage: Integer read Get_CurrentPage write Set_CurrentPage;
    property Filename: WideString read Get_Filename write Set_Filename;
    property Pages: Integer read Get_Pages;
    property Zoom: Double read Get_Zoom write Set_Zoom;
    property ZoomInc: Integer read Get_ZoomInc write Set_ZoomInc;
    property ZoomPage: Double read Get_ZoomPage write Set_ZoomPage;
    property ZoomPageWidth: Double read Get_ZoomPageWidth write Set_ZoomPageWidth;
    property DoubleBuffered: WordBool read Get_DoubleBuffered write Set_DoubleBuffered;
    property AlignDisabled: WordBool read Get_AlignDisabled;
    property VisibleDockClientCount: Integer read Get_VisibleDockClientCount;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property Cursor: Smallint read Get_Cursor write Set_Cursor;
    property HelpType: TxHelpType read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
  end;

// *********************************************************************//
// DispIntf:  IentPreviewXDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {71E87F6F-5487-4A35-B999-08EFDF6D369A}
// *********************************************************************//
  IentPreviewXDisp = dispinterface
    ['{71E87F6F-5487-4A35-B999-08EFDF6D369A}']
    property Active: WordBool dispid 1;
    property CurrentPage: Integer dispid 2;
    property Filename: WideString dispid 3;
    property Pages: Integer readonly dispid 4;
    property Zoom: Double dispid 5;
    property ZoomInc: Integer dispid 6;
    property ZoomPage: Double dispid 7;
    property ZoomPageWidth: Double dispid 8;
    procedure FirstPage; dispid 9;
    procedure PreviousPage; dispid 10;
    procedure NextPage; dispid 11;
    procedure LastPage; dispid 12;
    procedure ZoomIn; dispid 13;
    procedure ZoomOut; dispid 14;
    property DoubleBuffered: WordBool dispid 15;
    property AlignDisabled: WordBool readonly dispid 16;
    property VisibleDockClientCount: Integer readonly dispid 17;
    function DrawTextBiDiModeFlagsReadingOnly: Integer; dispid 19;
    property Enabled: WordBool dispid -514;
    procedure InitiateAction; dispid 20;
    function IsRightToLeft: WordBool; dispid 21;
    function UseRightToLeftReading: WordBool; dispid 24;
    function UseRightToLeftScrollBar: WordBool; dispid 25;
    property Visible: WordBool dispid 26;
    property Cursor: Smallint dispid 27;
    property HelpType: TxHelpType dispid 28;
    property HelpKeyword: WideString dispid 29;
    procedure SetSubComponent(IsSubComponent: WordBool); dispid 31;
    procedure AboutBox; dispid -552;
  end;

// *********************************************************************//
// DispIntf:  IentPreviewXEvents
// Flags:     (4096) Dispatchable
// GUID:      {EEE020DB-A1D4-4891-A362-E5D48A0EA975}
// *********************************************************************//
  IentPreviewXEvents = dispinterface
    ['{EEE020DB-A1D4-4891-A362-E5D48A0EA975}']
    procedure OnPageChanged; dispid 1;
    procedure OnPreviewActivated; dispid 2;
    procedure OnPreviewStopped; dispid 3;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TentPreviewX
// Help String      : entPreviewX Control
// Default Interface: IentPreviewX
// Def. Intf. DISP? : No
// Event   Interface: IentPreviewXEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TentPreviewX = class(TOleControl)
  private
    FOnPageChanged: TNotifyEvent;
    FOnPreviewActivated: TNotifyEvent;
    FOnPreviewStopped: TNotifyEvent;
    FIntf: IentPreviewX;
    function  GetControlInterface: IentPreviewX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure FirstPage;
    procedure PreviousPage;
    procedure NextPage;
    procedure LastPage;
    procedure ZoomIn;
    procedure ZoomOut;
    function DrawTextBiDiModeFlagsReadingOnly: Integer;
    procedure InitiateAction;
    function IsRightToLeft: WordBool;
    function UseRightToLeftReading: WordBool;
    function UseRightToLeftScrollBar: WordBool;
    procedure SetSubComponent(IsSubComponent: WordBool);
    procedure AboutBox;
    property  ControlInterface: IentPreviewX read GetControlInterface;
    property  DefaultInterface: IentPreviewX read GetControlInterface;
    property Pages: Integer index 4 read GetIntegerProp;
    property DoubleBuffered: WordBool index 15 read GetWordBoolProp write SetWordBoolProp;
    property AlignDisabled: WordBool index 16 read GetWordBoolProp;
    property VisibleDockClientCount: Integer index 17 read GetIntegerProp;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp;
    property Visible: WordBool index 26 read GetWordBoolProp write SetWordBoolProp;
  published
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property Active: WordBool index 1 read GetWordBoolProp write SetWordBoolProp stored False;
    property CurrentPage: Integer index 2 read GetIntegerProp write SetIntegerProp stored False;
    property Filename: WideString index 3 read GetWideStringProp write SetWideStringProp stored False;
    property Zoom: Double index 5 read GetDoubleProp write SetDoubleProp stored False;
    property ZoomInc: Integer index 6 read GetIntegerProp write SetIntegerProp stored False;
    property ZoomPage: Double index 7 read GetDoubleProp write SetDoubleProp stored False;
    property ZoomPageWidth: Double index 8 read GetDoubleProp write SetDoubleProp stored False;
    property Cursor: Smallint index 27 read GetSmallintProp write SetSmallintProp stored False;
    property HelpType: TOleEnum index 28 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property HelpKeyword: WideString index 29 read GetWideStringProp write SetWideStringProp stored False;
    property OnPageChanged: TNotifyEvent read FOnPageChanged write FOnPageChanged;
    property OnPreviewActivated: TNotifyEvent read FOnPreviewActivated write FOnPreviewActivated;
    property OnPreviewStopped: TNotifyEvent read FOnPreviewStopped write FOnPreviewStopped;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

implementation

uses ComObj;

procedure TentPreviewX.InitControlData;
const
  CEventDispIDs: array [0..2] of DWORD = (
    $00000001, $00000002, $00000003);
  CControlData: TControlData2 = (
    ClassID: '{E731B405-F5E6-4932-9C91-02F559A6BBCB}';
    EventIID: '{EEE020DB-A1D4-4891-A362-E5D48A0EA975}';
    EventCount: 3;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$00000000*);
    Flags: $00000008;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnPageChanged) - Cardinal(Self);
end;

procedure TentPreviewX.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IentPreviewX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TentPreviewX.GetControlInterface: IentPreviewX;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TentPreviewX.FirstPage;
begin
  DefaultInterface.FirstPage;
end;

procedure TentPreviewX.PreviousPage;
begin
  DefaultInterface.PreviousPage;
end;

procedure TentPreviewX.NextPage;
begin
  DefaultInterface.NextPage;
end;

procedure TentPreviewX.LastPage;
begin
  DefaultInterface.LastPage;
end;

procedure TentPreviewX.ZoomIn;
begin
  DefaultInterface.ZoomIn;
end;

procedure TentPreviewX.ZoomOut;
begin
  DefaultInterface.ZoomOut;
end;

function TentPreviewX.DrawTextBiDiModeFlagsReadingOnly: Integer;
begin
  Result := DefaultInterface.DrawTextBiDiModeFlagsReadingOnly;
end;

procedure TentPreviewX.InitiateAction;
begin
  DefaultInterface.InitiateAction;
end;

function TentPreviewX.IsRightToLeft: WordBool;
begin
  Result := DefaultInterface.IsRightToLeft;
end;

function TentPreviewX.UseRightToLeftReading: WordBool;
begin
  Result := DefaultInterface.UseRightToLeftReading;
end;

function TentPreviewX.UseRightToLeftScrollBar: WordBool;
begin
  Result := DefaultInterface.UseRightToLeftScrollBar;
end;

procedure TentPreviewX.SetSubComponent(IsSubComponent: WordBool);
begin
  DefaultInterface.SetSubComponent(IsSubComponent);
end;

procedure TentPreviewX.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TentPreviewX]);
end;

end.
