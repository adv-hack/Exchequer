{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

{$T-}

unit RPDevice;

interface

uses
  {$IFDEF Linux}
  QGraphics, QDialogs, QForms, QPrinters, MiscKylix, Types, Qt,
  {$ELSE}
  WinSpool, WinTypes, WinProcs, Messages, CommDlg, Graphics, Dialogs, Forms, Printers,
  {$ENDIF}
  SysUtils, Classes, RPDefine;

{ Special notes on using RPDev: TRPBaseDevice directly:
  * When modifying RPDev.DevMode directly you must call ResetHandle for
    the changes to take effect.
  * Use RPDev.PrinterSetupDialog to show the user a printer setup dialog
  * Use RPDev.SaveToPrinter to copy the printer settings from RPDev to
    Delphi's Printer object
  * Use RPDev.LoadFromPrinter to copy the printer settings from Delphi's
    Printer object to RPDev
}
Const
  feType_Printer = 1;
  feType_Fax     = 2;
  feType_Email   = 4;

  MaxSupportedPages = 32000;

type
  {$ALIGN OFF}
  {$LONGSTRINGS ON}

  TRpDevStrListEnum = (rpDevStrBins, rpDevStrPapers, rpDevStrPrinters);

  // NOTE: This structure cannot be changed in size without a simultaneous release of
  //       Sentimail and SBSForm.Dll
  TSentimailData = Record
    sdFileName   : String[255];

    sdSpare      : Array [1..700] Of Byte;
  End; { TSentimailData }
  pSentimailData = ^TSentimailData;

  // NOTE: This structure can be changed in size dynamically as all the code referencing
  //       it is compiled into the Forms Toolkit.
  TFormToolkitData = Record
    ftdTempFile    : String[255];
    ftdPages       : Integer;
    ftdFaxDesc     : String[80];
  End; { TFormToolkitData }
  pFormToolkitData = ^TFormToolkitData;

  TSBSPrintSetupInfo = Record
    DevIdx    : Integer;       { DeviceIndex in RpDev }

    FormNo    : Integer;       { Windows Form Id }
    FormName  : String;        { Windows Form Description }
    {FormName  : ShortString;        { Windows Form Description }

    BinNo     : Integer;       { Windows Bin Id }
    BinName   : String;        { Windows Bin Description }
    {BinName   : ShortString;        { Windows Bin Description }

    { Vars used internally in printing routines - not part of RpDev }
    Preview    : Boolean;       { True = Preview, False = Print }
    NoCopies   : SmallInt;      { Copies of form to print }
    pbLabel1   : SmallInt;      { Start of Label 1 Pos }
    TestMode   : Boolean;       { Indicates test mode }
    LabelMode  : Boolean;       { Tells PrntFrm Label Mode }
    ChequeMode : Boolean;       { Enables Cheque No processing fields }
    fePrintMethod   : Byte;         { Flag: 0=Printer, 1=Fax, 2=Email, 3=XML, 4=File, 5=Excel, 6=Text, 7=HTML} {*en431 XML}
    feBatch         : Boolean;      { Flag: Printing a batch - disable To details as specified later }
    feTypes         : LongInt;      { Flag: 2=Allow Fax, 4=AllowEmail, 8=AllowXML, 16=AllowExcel, 32=HTML }

    feCoverSheet    : String[8];    { Cover Sheet }

    feFaxMethod     : Byte;         { Fax: Send method:- 0=Enterprise, 1=MAPI,  }
    feFaxPrinter    : SmallInt;     { Fax: Selected Printer }
    feFaxFrom       : String[50];   { Fax: From Name }
    feFaxFromNo     : String[30];   { Fax: From Fax Number }
    feFaxTo         : String[50];   { Fax: To Name }
    feFaxToNo       : String[30];   { Fax: To Fax Number }
    feFaxMsg        : AnsiString;   { Fax: Message (max 255) }

    feEmailMAPI     : Boolean;      { Email: Send using MAPI }
    feEmailFrom     : String[50];   { Email: From Name }
    feEmailFromAd   : String[50];   { Email: From Address }
    feEmailTo       : AnsiString;   { Email: Name }
    feEmailToAddr   : AnsiString;   { Email: Addr}
    feEmailCc       : AnsiString;
    feEmailBcc      : AnsiString;
    feEmailSubj     : AnsiString;   { Email: Subject }
    feEmailMsg      : AnsiString;   { Email: Message (max 255) }
    feEmailAttach   : AnsiString;   { Email: Attachments (for future use - maybe) }
    feEmailPriority : Byte;         { Email: Priority - 0=Low, 1=Normal, 2=High }
    feEmailReader   : Boolean;      { Email: Attach Acrobat/Exchequer Reader }
    { HM 30/01/01: Changed Boolean to Byte to support increased PK-ZIP'ing options }
    {feEmailZIP      : Boolean;      { Email: ZIP Attachment as self-extracting .EXE }
    feEmailZIP      : Byte;         { Email: ZIP Attachment as self-extracting .EXE }
    feEmailAtType   : Byte;         { Email: Attachment methodology:- 0-RPPro, 1-Adobe, 2-RAVE PDF, 3-RAVE HTML }

    feJobtitle      : String[80];   { Job title for Enterprise Faxing }

    feFaxPriority   : Byte;         { Fax: Priority:- 0=Urgent, 1=Normal, 2=OffPeak }

    {*en431 XML}
    feXMLType       : Byte;         { XML Method: 0=File, 1=Email }
    feXMLCreateHTML : Boolean;      { XML: Also create HTML file }
    feXMLFileDir    : ANSIString;   { XML: Path to save .XML File in }

    { HM 30/01/01: added new field to store the intelligent name for form attachments }
    feEmailFName    : String[30];   { Email form attachment name }

    { HM 09/11/01: Added to return filename to Sentimail }
    feDataPtr       : Pointer;

    // HM 20/11/01: Added support for User Profiles
    feUserId        : String[10];

    // EL 08/05/01: Added support for Paperless as part of SPOP
    feInvMode       : Boolean;

    // HM 01/08/03: Added array of miscellaneous booleans for storing misc options from print dialog }
    //    Print to Excel: 1=Open XLS automatically, 2=Hide Page Headers/Footers, 3=Hide Totals
    //    Print to HTMl: 1=Open .HTML automatically
    //EL 25/03/2004 10 =When printing a form which is account based, override cover sheets from account details
    // MH 06/09/05: Extended array for Visual Report Writer which needed 12+ options
    {$IFNDEF REP_ENGINE}
    feMiscOptions   : Array [1..10] Of Boolean;
    {$ELSE}
    feMiscOptions   : Array [1..30] Of Boolean;
    {$ENDIF}

    // HM 04/11/04: Added 'Disable Printed Status' flag so that Authoris-e can stop FDes from setting the Printed Status on transactions
    feDisablePrnStatus : Boolean;

    //PR 02/02/2007: Added field to allow printing to file and copying the file to a specified path & filename
    feOutputFileName : String[255];
    Spare : Array [1..273] Of Byte;  {*en431 XML}
  End; { TSBSPrintSetupInfo }
  PSBSPrintSetupInfo = ^TSBSPrintSetupInfo;

  TPrintDialogRec = record
    Collate: boolean;
    Copies: integer;
    FromPage: integer;
    ToPage: integer;
    MinPage: integer;
    MaxPage: integer;
    Options: TPrintDialogOptions;
    PrintToFile: boolean;
    PrintRange: TPrintRange;
  end; { TPrintDialogRec }

  TBrushBuf = record
    Color: TColor;
    Style: TBrushStyle;
    Bitmap: TBitmap;
  end; { TBrushBuf }

  TFontBuf = record
    Name: TFontName;
    Size: integer;
    Color: TColor;
    Style: TFontStyles;
  end; { TFontBuf }

  TPenBuf = record
    PenMode: TPenMode;
    Style: TPenStyle;
    Width: integer;
    Color: TColor;
  end; { TPenBuf }

  TRPBaseDevice = class
  protected
    FTitle: TTitleString; { Title of report for print manager }
    FPrinting: boolean; { Is this device printing? }
    FAborted: boolean; { Has the print job been aborted? }
    FOrientation: TOrientation;
    FCopies: integer;
    FDuplex: TDuplex;
    FCollate: boolean;
    FPageHeight: integer;
    FPageWidth: integer;
    FBin: string;
    FPaper: string;

    function GetCanvas: TCanvas; virtual; abstract;
    function GetXDPI: integer; virtual;
    function GetYDPI: integer; virtual;
    function GetWaste: TRect; virtual;

  { Capability methods }
    function GetBins: TStrings; virtual;
    function GetPapers: TStrings; virtual;
    function GetFonts: TStrings; virtual;
    function GetPrinters: TStrings; virtual;
    function GetOrientation: TOrientation; virtual;
    procedure SetOrientation(Value: TOrientation); virtual;
    function GetMaxCopies: longint; virtual;
    procedure SetCopies(Value: integer); virtual;
    function GetCopies: integer; virtual;
    procedure SetDuplex(Value: TDuplex); virtual;
    function GetDuplex: TDuplex; virtual;
    procedure SetCollate(Value: boolean); virtual;
    function GetCollate: boolean; virtual;
    function GetPageHeight: integer; virtual;
    function GetPageWidth: integer; virtual;
  public
    constructor Create;

  { Output methods }
    function TextWidth(Value: string): integer; virtual;
    procedure RawOut(var ABuffer;
                         ALength: word); virtual;

  { Job methods }
    procedure BeginDoc; virtual;
    procedure BeginDocSelect; virtual;
    procedure EndDoc; virtual;
    procedure Abort; virtual;
    procedure NewPage; virtual;
    procedure NewPageSelect(PageValid: boolean); virtual;

  { Capability methods }
    function SelectBin(BinName: string;
                       Exact: boolean): boolean; virtual;
    function SelectPaper(PaperName: string;
                         Exact: boolean): boolean; virtual;
    procedure GetCustomExtents(var MinExtent: TPoint;
                               var MaxExtent: TPoint); virtual;
    function SetPaperSize(Size: integer;
                          Width: integer;
                          Height: integer): boolean; virtual;

  { Support methods }
    function SupportBin(BinNum: integer): boolean; virtual;
    function SupportPaper(PaperNum: integer): boolean; virtual;
    function SupportOrientation: boolean; virtual;
    function SupportDuplex: boolean; virtual;
    function SupportCollate: boolean; virtual;

  { Job properties }
    property Title: TTitleString read FTitle write FTitle;
    property Printing: boolean read FPrinting;
    property Aborted: boolean read FAborted;

  { Device properties }
    property Canvas: TCanvas read GetCanvas;
    property XDPI: integer read GetXDPI;
    property YDPI: integer read GetYDPI;
    property Waste: TRect read GetWaste;

  { Capability properties }
    property Bins: TStrings read GetBins;
    property Papers: TStrings read GetPapers;
    property Fonts: TStrings read GetFonts;
    property Printers: TStrings read GetPrinters;
    property Orientation: TOrientation read GetOrientation write SetOrientation;
    property MaxCopies: longint read GetMaxCopies;
    property Copies: integer read GetCopies write SetCopies;
    property Duplex: TDuplex read GetDuplex write SetDuplex;
    property Collate: boolean read GetCollate write SetCollate;
    property PageWidth: integer read GetPageWidth;
    property PageHeight: integer read GetPageHeight;
  end; { TRPBaseDevice }

  TRPRenderDevice = class(TRPBaseDevice)
  protected
    FBitmap: TBitmap;
    FCanvas: TCanvas;

    function GetCanvas: TCanvas; override;
    procedure SetCanvas(Value: TCanvas);
    function GetXDPI: integer; override;
    function GetYDPI: integer; override;
  public
    constructor Create;
    destructor Destroy; override;

  { Output methods }
    function TextWidth(Value: string): integer; override;

  { Job methods }
    procedure BeginDoc; override;
    procedure BeginDocSelect; override;
    procedure EndDoc; override;
    procedure Abort; override;
    procedure NewPage; override;
    procedure NewPageSelect(PageValid: boolean); override;

  { Capability methods }
(*
    function SelectBin(BinName: string;
                       Exact: boolean): boolean; virtual;
    function SelectPaper(PaperName: string;
                         Exact: boolean): boolean; virtual;
    procedure GetCustomExtents(var MinExtent: TPoint;
                               var MaxExtent: TPoint); virtual;
    function SetPaperSize(Size: integer;
                          Width: integer;
                          Height: integer): boolean; virtual;
*)
    property Canvas: TCanvas read GetCanvas write SetCanvas;
  end; { TRPRenderDevice }

  TRPPrinterDevice = class(TRPBaseDevice)
  protected
    FDeviceName: PChar; { Current device name }
    FDriverName: PChar; { Current driver name }
    FOutputName: PChar; { Current output port name }
    DC: HDC; { Handle of device DC }
    FDriverHandle: THandle; { Stores handle of printer driver }
    FDeviceMode: THandle; { Handle to TDevMode memory }
    {$IFDEF Linux}
    //!!PORT!! PDevMode = PDeviceMode AGAIN!!!
    {$ELSE}
    FDevMode: WinTypes.PDevMode; { Pointer to TDevMode memory }
    {$ENDIF}
    FDeviceState: TDeviceState; { Current state of printer device }
    FFontList: TStrings; { List of available fonts }
    FPrinterList: TStrings; { List of installed printers }
    FBinList: TStrings; { List of available bins }
    FPaperList: TStrings; { List of available paper sizes }
    FDeviceIndex: integer; { Current driver index, -2 for none }
    FOutputFile: PChar; { Alternate output file }
    FCanvas: TCanvas; { Canvas attached to this device }
    CanvasActive: boolean; { Is the canvas active }
    FDevModeChanged: boolean; { Has DevMode changed since last ResetDC? }
    SaveBrush: TBrushBuf; { Used by ReleaseCanvas and RecoverCanvas }
    SaveFont: TFontBuf; { Used by ReleaseCanvas and RecoverCanvas }
    SavePen: TPenBuf; { Used by ReleaseCanvas and RecoverCanvas }
    OnPage: boolean; { Are we currently printing a page }
    KeepDevMode: boolean; { Keep current TDevMode settings for new printer }
    FInvalidPrinter: boolean; { Current printer is invalid or no printers }

  { Internal methods }
    procedure CheckPrinting;
    procedure CheckNotPrinting;
    function GetWord(var Line: PChar): PChar;
    function FindPrinter(Device: PChar;
                         Driver: PChar;
                         Output: PChar): integer;

  { Job methods }
    function GetOutputFile: string;
    procedure SetOutputFile(Value: string);

  { Device methods }
    function GetDeviceIndex: integer;
    procedure SetDeviceIndex(Value: integer);
    procedure SetDeviceState(Value: TDeviceState);
    function GetHandle: HDC;
    function GetCanvas: TCanvas; override;
    {$IFDEF Linux}
    //!!PORT!! Relies on PDevMode
    {$ELSE}
    function GetDevMode: WinTypes.PDevMode;
    {$ENDIF}
    function GetDriverName: string;
    function GetOutputName: string;
    function GetDeviceName: string;
    procedure OpenDevice(NewIndex: integer);
    procedure CloseDevice;
    procedure ResetDevice;
    procedure ReleaseCanvas;
    procedure RecoverCanvas;
    function GetXDPI: integer; override;
    function GetYDPI: integer; override;
    function GetWaste: TRect; override;

  { Capability methods }
    function GetBins: TStrings; override;
    function GetPapers: TStrings; override;
    function GetFonts: TStrings; override;
    function GetPrinters: TStrings; override;
    function GetOrientation: TOrientation; override;
    procedure SetOrientation(Value: TOrientation); override;
    function GetMaxCopies: longint; override;
    procedure SetCopies(Value: integer); override;
    function GetCopies: integer; override;
    procedure SetDuplex(Value: TDuplex); override;
    function GetDuplex: TDuplex; override;
    procedure SetCollate(Value: boolean); override;
    function GetCollate: boolean; override;
    function GetPageHeight: integer; override;
    function GetPageWidth: integer; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveToPrinter;
    procedure LoadFromPrinter;
    function PrinterSetupDialog: boolean;
    function PrintDialog(var PrintDialogRec: TPrintDialogRec): boolean;
    function SimplePrintDialog(var FirstPage: integer;
                               var LastPage: integer): boolean;
    procedure ResetHandle(Force: boolean);

    { User-Defined methods }
    function SBSSetupInfo : TSBSPrintSetupInfo;
    procedure SetPrnSetup(PrnSetup : TSBSPrintSetupInfo);
    Function WalkList (TheList : TStrings; ReqNum : Integer) : String;
    Function WalkListIdx (TheList : TStrings; ReqNum : Integer) : Integer;
    function CheckForDriver(SearchDriver : string) : boolean;
    function SBSSetupInfo2(Const BaseInfo : TSBSPrintSetupInfo) : TSBSPrintSetupInfo;

  { Output methods }
    function TextWidth(Value: string): integer; override;
    procedure RawOut(var ABuffer;
                         ALength: word); override;

  { Job methods }
    procedure BeginDoc; override;
    procedure BeginDocSelect; override;
    procedure EndDoc; override;
    procedure Abort; override;
    procedure NewPage; override;
    procedure NewPageSelect(PageValid: boolean); override;

  { Capability methods }
    function SelectBin(BinName: string;
                       Exact: boolean): boolean; override;
    function SelectPaper(PaperName: string;
                         Exact: boolean): boolean; override;
    function SelectPrinter(PrinterName: string;
                           Exact: boolean): boolean;
    procedure GetCustomExtents(var MinExtent: TPoint;
                               var MaxExtent: TPoint); override;
    function SetPaperSize(Size: integer;
                          Width: integer;
                          Height: integer): boolean; override;
    function InvalidPrinter: boolean;

  { Support methods }
    function SupportBin(BinNum: integer): boolean; override;
    function SupportPaper(PaperNum: integer): boolean; override;
    function SupportOrientation: boolean; override;
    function SupportDuplex: boolean; override;
    function SupportCollate: boolean; override;

  { Job properties }
    property OutputFile: string read GetOutputFile write SetOutputFile;

  { Device properties }
    property Device: string read GetDeviceName;
    property Driver: string read GetDriverName;
    property Output: string read GetOutputName;
    {$IFDEF Linux}
    //!!PORT!! Relies on PDevMode
    {$ELSE}
    property DevMode: WinTypes.PDevMode read GetDevMode;
    {$ENDIF}
    property Handle: HDC read GetHandle;
    property DeviceIndex: integer read GetDeviceIndex write SetDeviceIndex;
    property State: TDeviceState read FDeviceState write SetDeviceState;
    property DevModeChanged: boolean read FDevModeChanged write FDevModeChanged;
  end; { TRPPrinterDevice }
  TRPDevice = TRPPrinterDevice; // Compatibility typecast

  TRPPrinterCanvas = class(TCanvas)
    RPDevice: TRPPrinterDevice;
    constructor Create(Device: TRPPrinterDevice);
    procedure CreateHandle; override;
  end; { TRPCanvas }

  {$IFDEF Linux}
  //!!PORT!! Relies on PDeviceMode
  {$ELSE}
  function DeviceCapabilities(DeviceName: PChar;
                              Port: PChar;
                              Index: word;
                              Output: PChar;
                              DevMode: PDeviceMode): integer; stdcall;
  {$ENDIF}
  function GlobalDevice: TRPBaseDevice;
  function RPDev: TRPPrinterDevice;
  function SetNewDevice(NewDevice: TRPBaseDevice): TRPBaseDevice;


Var
  // Flag used by the Form Printing Toolkit so that the PrinterSetupDialog method
  // attaches the setup dialog to the active app rather than the hidden form that
  // it has.
  UseGetForeground : Boolean = False;

implementation

uses
  RPFont;

(*****************************************************************************}
( class TRPBaseDevice
(*****************************************************************************)

constructor TRPBaseDevice.Create;
begin
  inherited Create;
  FCopies := 1;
  FOrientation := RPDefine.poLandscape;
  FPageWidth := Round(8.5 * XDPI);
  FPageHeight := Round(11.0 * YDPI);
end;

function TRPBaseDevice.GetBins: TStrings;
begin
  Result := nil;
end;

function TRPBaseDevice.GetPapers: TStrings;
begin
  Result := nil;
end;

function TRPBaseDevice.GetFonts: TStrings;
begin
  Result := nil;
end;

function TRPBaseDevice.GetPrinters: TStrings;
begin
  Result := nil;
end;

function TRPBaseDevice.GetOrientation: TOrientation;
begin
  Result := FOrientation;
end;

procedure TRPBaseDevice.SetOrientation(Value: TOrientation);
begin
  FOrientation := Value;
end;

function TRPBaseDevice.GetMaxCopies: longint;
begin
  Result := 1;
end;

procedure TRPBaseDevice.SetCopies(Value: integer);
begin
  FCopies := Value;
end;

function TRPBaseDevice.GetCopies: integer;
begin
  Result := FCopies;
end;

procedure TRPBaseDevice.SetDuplex(Value: TDuplex);
begin
  FDuplex := Value;
end;

function TRPBaseDevice.GetDuplex: TDuplex;
begin
  Result := FDuplex;
end;

procedure TRPBaseDevice.SetCollate(Value: boolean);
begin
  FCollate := Value;
end;

function TRPBaseDevice.GetCollate: boolean;
begin
  Result := FCollate;
end;

function TRPBaseDevice.GetPageHeight: integer;
begin
  Result := FPageHeight;
end;

function TRPBaseDevice.GetPageWidth: integer;
begin
  Result := FPageWidth;
end;

{ Output methods }

function TRPBaseDevice.TextWidth(Value: string): integer;
begin
  Result := 0;
end;

procedure TRPBaseDevice.RawOut(var ABuffer;
                                   ALength: word);
begin
end;

{ Job methods }

procedure TRPBaseDevice.BeginDoc;
begin
end;

procedure TRPBaseDevice.BeginDocSelect;
begin
end;

procedure TRPBaseDevice.EndDoc;
begin
end;

procedure TRPBaseDevice.Abort;
begin
end;

procedure TRPBaseDevice.NewPage;
begin
end;

procedure TRPBaseDevice.NewPageSelect(PageValid: boolean);
begin
end;

{ Capability methods }

function TRPBaseDevice.SelectBin(BinName: string;
                                 Exact: boolean): boolean;
begin
  FBin := BinName;
  Result := true;
end;

function TRPBaseDevice.SelectPaper(PaperName: string;
                                   Exact: boolean): boolean;
begin
  FPaper := PaperName;
  Result := true;
end;

procedure TRPBaseDevice.GetCustomExtents(var MinExtent: TPoint;
                                         var MaxExtent: TPoint);
begin
end;

function TRPBaseDevice.SetPaperSize(Size: integer;
                                    Width: integer;
                                    Height: integer): boolean;
begin
  Result := true;
  If (Width <> 0) and (Height <> 0) then begin
    FPageWidth := Round((Width / 254) * XDPI);
    FPageHeight := Round((Height / 254) * YDPI);
  end else begin
  //!!! Set width and height based on Size value
    FPageWidth := Round(8.5 * XDPI);
    FPageHeight := Round(11.0 * YDPI);
  end; { else }
end;

{ Support methods }

function TRPBaseDevice.SupportBin(BinNum: integer): boolean;
begin
  Result := true;
end;

function TRPBaseDevice.SupportPaper(PaperNum: integer): boolean;
begin
  Result := true;
end;

function TRPBaseDevice.SupportOrientation: boolean;
begin
  Result := true;
end;

function TRPBaseDevice.SupportDuplex: boolean;
begin
  Result := true;
end;

function TRPBaseDevice.SupportCollate: boolean;
begin
  Result := true;
end;

function TRPBaseDevice.GetXDPI: integer;
begin { GetXDPI }
  Result := 96;
end;  { GetXDPI }

function TRPBaseDevice.GetYDPI: integer;
begin { GetYDPI }
  Result := 96;
end;  { GetYDPI }

function TRPBaseDevice.GetWaste: TRect;
begin { GetWaste }
  FillChar(Result,SizeOf(Result),0);
end;  { GetWaste }

(*****************************************************************************}
( TRPRenderDevice
(*****************************************************************************)

constructor TRPRenderDevice.Create;
begin
  inherited;
  FPrinting := true;
  FBitmap := TBitmap.Create;
  FCanvas := FBitmap.Canvas;
end;

destructor TRPRenderDevice.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

function TRPRenderDevice.GetCanvas: TCanvas;
begin
  Result := FCanvas;
end;

procedure TRPRenderDevice.SetCanvas(Value: TCanvas);

begin
  If not Assigned(Value) then begin
    If not Assigned(FBitmap) then begin
      FBitmap := TBitmap.Create;
      FCanvas := FBitmap.Canvas;
    end; { if }
  end else begin
    If Assigned(FBitmap) then begin
      FBitmap.Free;
      FBitmap := nil;
    end; { if }
    FCanvas := Value;
  end; { else }
end;

function TRPRenderDevice.GetXDPI: integer;
begin
  Result := RPFont.BaseSize;
end;

function TRPRenderDevice.GetYDPI: integer;
begin
  Result := RPFont.BaseSize;
end;

function TRPRenderDevice.TextWidth(Value: string): integer;
begin
  Result := FontManager.TextWidth(Canvas.Font,Value);
end;

{ Job methods }

procedure TRPRenderDevice.BeginDoc;
begin
end;

procedure TRPRenderDevice.BeginDocSelect;
begin
end;

procedure TRPRenderDevice.EndDoc;
begin
end;

procedure TRPRenderDevice.Abort;
begin
end;

procedure TRPRenderDevice.NewPage;
begin
end;

procedure TRPRenderDevice.NewPageSelect(PageValid: boolean);
begin
end;

  { Capability methods }
(*
    function SelectBin(BinName: string;
                       Exact: boolean): boolean; virtual;
    function SelectPaper(PaperName: string;
                         Exact: boolean): boolean; virtual;
    procedure GetCustomExtents(var MinExtent: TPoint;
                               var MaxExtent: TPoint); virtual;
    function SetPaperSize(Size: integer;
                          Width: integer;
                          Height: integer): boolean; virtual;
*)


(*****************************************************************************}
( Printer device items
(*****************************************************************************)

{$IFDEF Linux}
//!!PORT!!
{$ELSE}
function DeviceCapabilities; external winspl name {Trans-}'DeviceCapabilitiesA';
{$ENDIF}

{*************************************************************************}
{                       class TRPPrinterCanvas                            }
{*************************************************************************}

constructor TRPPrinterCanvas.Create(Device: TRPPrinterDevice);

begin { Create }
  inherited Create;
  RPDevice := Device;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Font.PixelsPerInch := GetDeviceCaps(RPDevice.Handle,LOGPIXELSY);//!!!
  {$ENDIF}
end;  { Create }

procedure TRPPrinterCanvas.CreateHandle;

begin { CreateHandle }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Handle := RPDevice.Handle; { Pass handle for RPDevice object }//!!!
  {$ENDIF}
end;  { CreateHandle }

{*************************************************************************}
{                          class TRPDeviceItem                            }
{*************************************************************************}

{ This class is used to hold the printer information from FPrinterList }

type
TRPDeviceItem = class
  FDeviceName: PChar;
  FDriverName: PChar;
  FOutputName: PChar;

  constructor Create(DeviceName: PChar;
                     DriverName: PChar;
                     OutputName: PChar);
  destructor Destroy; override;
end; { TRPDeviceItem }

constructor TRPDeviceItem.Create(DeviceName: PChar;
                                 DriverName: PChar;
                                 OutputName: PChar);
begin { Create }
  inherited Create;
  FDeviceName := StrNew(DeviceName);
  FDriverName := StrNew(DriverName);
  FOutputName := StrNew(OutputName);
end;  { Create }

destructor TRPDeviceItem.Destroy;

begin { Destroy }
  StrDispose(FOutputName);
  StrDispose(FDriverName);
  StrDispose(FDeviceName);
  inherited Destroy;
end;  { Destroy }

{*************************************************************************}
{                         class TRPPrinterDevice                          }
{*************************************************************************}

constructor TRPPrinterDevice.Create;

begin { Create }
  FDeviceIndex := -2;
  inherited Create;
end;  { Create }

destructor TRPPrinterDevice.Destroy;

var
  I1: integer;

begin { Destroy }
  State := dsNone;
  CloseDevice;
  If Assigned(FPrinterList) then begin
    For I1 := 1 to FPrinterList.Count do begin
      FPrinterList.Objects[I1 - 1].Free;
    end; { for }
    FPrinterList.Free;
  end; { if }
  StrDispose(FOutputFile);
  FCanvas.Free;

  inherited Destroy;
end;  { Destroy }

{******************}
{ Internal Methods }
{******************}

procedure TRPPrinterDevice.CheckPrinting;

begin { CheckPrinting }
  If not FPrinting then begin
    RaiseError(Trans('Invalid method call.  Device is not printing.'));
  end; { if }
end;  { CheckPrinting }

procedure TRPPrinterDevice.CheckNotPrinting;

begin { CheckNotPrinting }
  If FPrinting then begin
    RaiseError(Trans('Invalid method call.  Device already printing.'));
  end; { if }
end;  { CheckNotPrinting }

function TRPPrinterDevice.GetWord(var Line: PChar): PChar;

begin { GetWord }
  If not Assigned(Line) then begin
    Result := nil;
    Exit;
  end; { if }
  While Line^ = ' ' do begin
    Inc(Line);
  end; { while }
  Result := Line;
  Line := StrPos(Line,',');
  If Assigned(Line) then begin
    Line^ := #0;
    Inc(Line);
  end; { if }
end;  { GetWord }

function TRPPrinterDevice.FindPrinter(Device: PChar;
                                      Driver: PChar;
                                      Output: PChar): integer;

var
  I1: integer;

begin { FindPrinter }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := -1;
  With FPrinterList do begin
    If Count = 0 then Exit;
    For I1 := 0 to Count - 1 do begin
      With Objects[I1] as TRPDeviceItem do begin
        If Win32Platform = VER_PLATFORM_WIN32_NT then begin
          If AnsiStrIComp(Device,FDeviceName) = 0 then begin
            Result := I1;
            Exit;
          end; { if }
        end else begin
          If (AnsiStrIComp(Device,FDeviceName) = 0) and
           (AnsiStrIComp(Output,FOutputName) = 0) then begin
            Result := I1;
            Exit;
          end; { if }
        end; { else }
      end; { with }
    end; { for }
  end; { with }
  {$ENDIF}
end;  { FindPrinter }

{ Output methods }

function TRPPrinterDevice.TextWidth(Value: string): integer;
var
  TextExtent: TSize;
begin
  If Value = '' then begin
    Result := 1;
  end else begin
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    GetTextExtentPoint32(Canvas.Handle,@Value[1],Length(Value),TextExtent);
    {$ENDIF}
    If TextExtent.cX = 0 then begin
      TextExtent.cX := 1;
    end; { if }
    Result := TextExtent.cX;
  end; { else }
end;

procedure TRPPrinterDevice.RawOut(var ABuffer;
                                      ALength: word);
var
  Buffer: PChar;
begin
  GetMem(Buffer,ALength + SizeOf(word));
  try
    Move(ALength,Buffer^,SizeOf(ALength));
    Move(ABuffer,(Buffer+SizeOf(ALength))^,ALength);
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    Escape(Handle,PASSTHROUGH,0,Buffer,nil);
    {$ENDIF}
  finally
    FreeMem(Buffer,ALength + SizeOf(word));
  end; { tryf }
end;

{****************}
{ Device methods }
{****************}

procedure TRPPrinterDevice.LoadFromPrinter;

var
  NewDevice: PChar;
  NewDriver: PChar;
  NewPort: PChar;
  NewDeviceMode: THandle;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  NewDevMode: WinTypes.PDevMode;
  {$ENDIF}
begin { LoadFromPrinter }
  GetMem(NewDevice,256);
  GetMem(NewDriver,256);
  GetMem(NewPort,256);
  try
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    Printer.GetPrinter(NewDevice,NewDriver,NewPort,NewDeviceMode);
    SelectPrinter(StrPas(NewDevice),true);
    NewDevMode := GlobalLock(NewDeviceMode);
    try
      Move(NewDevMode^,DevMode^,SizeOf(WinTypes.TDevMode));
    finally
      GlobalUnlock(NewDeviceMode);
    end; { tryf }
    {$ENDIF}
    DevModeChanged := true;
  finally
    FreeMem(NewPort,256);
    FreeMem(NewDriver,256);
    FreeMem(NewDevice,256);
  end; { tryf }
end;  { LoadFromPrinter }

procedure TRPPrinterDevice.SaveToPrinter;

begin { SaveToPrinter }
  If FDeviceName = nil then Exit;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Printer.SetPrinter(FDeviceName,FDriverName,FOutputName,FDeviceMode);
  {$ENDIF}
  CloseDevice;
end;  { SaveToPrinter }

{$IFDEF Linux}
//!!PORT!!
{$ELSE}
function DialogHook(Wnd: HWnd;
                    Msg: UINT;
                    WParam: WPARAM;
                    LParam: LPARAM): UINT; stdcall;

var
  Width: integer;
  Rect: TRect;

begin { DialogHook }
  Result := 0;
  try
    Case Msg of
      WM_INITDIALOG: begin
        GetWindowRect(Wnd,Rect);
        Width := Rect.Right - Rect.Left;
        SetWindowPos(Wnd,0,(GetSystemMetrics(SM_CXSCREEN) - Width) div 2,
         (GetSystemMetrics(SM_CYSCREEN) - Rect.Bottom + Rect.Top) div 3,
         0,0,SWP_NOACTIVATE + SWP_NOSIZE + SWP_NOZORDER);
        Result := 1;
      end;
    end; { case }
  except
    Application.HandleException(nil);
  end; { tryx }
end;  { DialogHook }
{$ENDIF}

function TRPPrinterDevice.PrinterSetupDialog: boolean;

var
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  PrintDlgRec: TPrintDlg;
  DevNames: PDevNames;
  DeviceNames: THandle;
  {$ENDIF}
  S1: PChar;
  S2: string;

begin { PrinterSetupDialog }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}

  State := dsIC;

{ Allocate DevNames structure }
  Result := false;
  DeviceNames := GlobalAlloc(GHND,SizeOf(TDevNames) + Length(Driver) +
   Length(Device) + Length(Output) + 5);
  try
    DevNames := GlobalLock(DeviceNames);
    try
      S1 := PChar(DevNames) + SizeOf(TDevNames);
      With DevNames^ do begin
        wDriverOffset := longint(S1) - longint(DevNames);
        S1 := StrECopy(S1,PChar(Driver)) + 1;
        wDeviceOffset := longint(S1) - longint(DevNames);
        S1 := StrECopy(S1,PChar(Device)) + 1;
        wOutputOffset := longint(S1) - longint(DevNames);
        StrCopy(S1,PChar(Output));
      end; { with }
    finally
      GlobalUnlock(DeviceNames);
    end; { tryf }

    FillChar(PrintDlgRec,SizeOf(PrintDlgRec),0);
    PrintDlgRec.hInstance := HInstance;
    With PrintDlgRec do begin
      lStructSize := Sizeof(PrintDlgRec);
      // HM 17/07/02: Added for Form Printing toolkit
      If UseGetForeground Then
        // Connect to active window in active application
        hWndOwner := GetForegroundWindow
      Else
        // connect to active window in current app
        hWndOwner := GetFocus;
      //hWndOwner := GetFocus;
      hDevMode := FDeviceMode;
      hDevNames := DeviceNames;
      Flags := PD_ENABLESETUPHOOK or PD_PRINTSETUP;
      lpfnSetupHook := DialogHook;
      GlobalUnlock(FDeviceMode);
      If PrintDlg(PrintDlgRec) then begin { Successful }
        FDeviceMode := hDevMode;
        If FDeviceMode = 0 then begin
          FDevMode := nil;
        end else begin
          FDevMode := GlobalLock(FDeviceMode);
        end; { else }
        DevNames := GlobalLock(hDevNames);
        try
          If Win32Platform = VER_PLATFORM_WIN32_NT then begin
            S2 := StrPas(PChar(DevNames) + DevNames^.wDeviceOffset);
          end else begin
            S2 := StrPas(PChar(DevNames) + DevNames^.wDeviceOffset) +
             {Trans-}' on ' + StrPas(PChar(DevNames) + DevNames^.wOutputOffset);
          end; { else }

          KeepDevMode := true;
          SelectPrinter(S2,true);
          Result := true;
        finally
          GlobalUnlock(hDevNames);
        end; { tryf }
      end; { if }
    end; { with }
  finally
    GlobalUnlock(DeviceNames);
    GlobalFree(PrintDlgRec.hDevNames);
    DevModeChanged := true;
  end; { tryf }
  {$ENDIF}
end;  { PrinterSetupDialog }

function TRPPrinterDevice.PrintDialog(var PrintDialogRec: TPrintDialogRec): boolean;
{$IFDEF Linux}
//!!PORT!!
{$ELSE}

const
  APrintRange: array[TPrintRange] of Integer =
   (PD_ALLPAGES, PD_SELECTION, PD_PAGENUMS);
var
  PrintDlgRec: TPrintDlg;
  DevNames: PDevNames;
  DeviceNames: THandle;
  S1: PChar;
  S2: string;
{$ENDIF}

begin { PrintDialog }
{$IFDEF Linux}
//!!PORT!!
{$ELSE}

  State := dsIC;

{ Allocate DevNames structure }
  Result := false;
  DeviceNames := GlobalAlloc(GHND,SizeOf(TDevNames) + Length(Driver) +
   Length(Device) + Length(Output) + 5);
  try
    DevNames := GlobalLock(DeviceNames);
    try
      S1 := PChar(DevNames) + SizeOf(TDevNames);
      With DevNames^ do begin
        wDriverOffset := longint(S1) - longint(DevNames);
        S1 := StrECopy(S1,PChar(Driver)) + 1;
        wDeviceOffset := longint(S1) - longint(DevNames);
        S1 := StrECopy(S1,PChar(Device)) + 1;
        wOutputOffset := longint(S1) - longint(DevNames);
        StrCopy(S1,PChar(Output));
      end; { with }
    finally
      GlobalUnlock(DeviceNames);
    end; { tryf }

    FillChar(PrintDlgRec,SizeOf(PrintDlgRec),0);
    PrintDlgRec.hInstance := HInstance;
    With PrintDlgRec do begin
      lStructSize := Sizeof(PrintDlgRec);
      hWndOwner := GetFocus;
      hDevMode := FDeviceMode;
      hDevNames := DeviceNames;
      Flags := PD_ENABLESETUPHOOK or PD_ENABLEPRINTHOOK or
       PD_USEDEVMODECOPIES;
      With PrintDialogRec do begin
        Case PrintRange of
          prAllPages: Flags := Flags or PD_ALLPAGES;
          prSelection: Flags := Flags or PD_SELECTION;
          prPageNums: Flags := Flags or PD_PAGENUMS;
        end; { case }
        If Collate then begin
          Flags := Flags or PD_COLLATE;
        end; { if }
        If not (poPrintToFile in Options) then begin
          Flags := Flags or PD_HIDEPRINTTOFILE;
        end; { if }
        If not (poPageNums in Options) then begin
          Flags := Flags or PD_NOPAGENUMS;
        end; { if }
        If not (poSelection in Options) then begin
          Flags := Flags or PD_NOSELECTION;
        end; { if }
        If (poDisablePrintToFile in Options) then begin
          Flags := Flags or PD_DISABLEPRINTTOFILE;
        end; { if }
        If poHelp in Options then begin
          Flags := Flags or PD_SHOWHELP;
        end; { if }
        If not (poWarning in Options) then begin
          Flags := Flags or PD_NOWARNING;
        end; { if }
        If PrintToFile then begin
          Flags := Flags or PD_PRINTTOFILE;
        end; { if }
        nFromPage := FromPage;
        nToPage := ToPage;
        nMinPage := MinPage;
        nMaxPage := MaxPage;
        If Assigned(FDevMode) then begin
          nCopies := FDevMode^.dmCopies;
        end else begin
          nCopies := 1;
        end; { else }
      end; { with }
      lpfnPrintHook := DialogHook;
      lpfnSetupHook := DialogHook;
      GlobalUnlock(FDeviceMode);
      If PrintDlg(PrintDlgRec) then begin { Successful }
        FDeviceMode := hDevMode;
        If FDeviceMode = 0 then begin
          FDevMode := nil;
        end else begin
          FDevMode := GlobalLock(FDeviceMode);
        end; { else }
        DevNames := GlobalLock(hDevNames);
        try
          If Win32Platform = VER_PLATFORM_WIN32_NT then begin
            S2 := StrPas(PChar(DevNames) + DevNames^.wDeviceOffset);
          end else begin
            S2 := StrPas(PChar(DevNames) + DevNames^.wDeviceOffset) +
             {Trans-}' on ' + StrPas(PChar(DevNames) + DevNames^.wOutputOffset);
          end; { else }
          KeepDevMode := true;
          SelectPrinter(S2,true);
          Result := true;
        finally
          GlobalUnlock(hDevNames);
        end; { tryf }
        With PrintDialogRec do begin
          Collate := (Flags and PD_COLLATE) <> 0;
          PrintToFile := (Flags and PD_PRINTTOFILE) <> 0;
          If (Flags and PD_SELECTION) <> 0 then begin
            PrintRange := prSelection;
          end else if (Flags and PD_PAGENUMS) <> 0 then begin
            PrintRange := prPageNums;
          end else begin
            PrintRange := prAllPages;
          end; { else }
          FromPage := nFromPage;
          ToPage := nToPage;
          If Assigned(FDevMode) then begin
            Copies := FDevMode^.dmCopies;
          end else begin
            Copies := 1;
          end; { else }
        end; { with }
      end; { if }
    end; { with }
  finally
    GlobalUnlock(DeviceNames);
    GlobalFree(PrintDlgRec.hDevNames);
    DevModeChanged := true;
  end; { tryf }
{$ENDIF}
end;  { PrintDialog }

function TRPPrinterDevice.SimplePrintDialog(var FirstPage: integer;
                                            var LastPage: integer): boolean;

var
  PrintDialogRec: TPrintDialogRec;

begin { SimplePrintDialog }
  FillChar(PrintDialogRec,SizeOf(PrintDialogRec),0);
  With PrintDialogRec do begin
    Collate := self.Collate;
    Copies := self.Copies;
    FromPage := FirstPage;
    ToPage := LastPage;
    MinPage := 1;
    MaxPage := LastPage;
    Options := [poWarning];
    PrintToFile := false;
    PrintRange := prAllPages;
  end; { with }
  Result := self.PrintDialog(PrintDialogRec);
  With PrintDialogRec do begin
    self.Collate := Collate;
    SetCopies(Copies);
    If PrintRange = prPageNums then begin
      FirstPage := FromPage;
      LastPage := ToPage;
    end else if PrintRange = prAllPages then begin
      FirstPage := 1;
      LastPage := MaxSupportedPages;
    end; { else }
  end; { with }
end;  { SimplePrintDialog }

function TRPPrinterDevice.GetDeviceIndex: integer;

begin { GetDeviceIndex }
  If FDeviceIndex < 0 then begin
    FDeviceIndex := -2;
    SetDeviceIndex(-1);
  end; { if }
  Result := FDeviceIndex;
end;  { GetDeviceIndex }

procedure TRPPrinterDevice.SetDeviceIndex(Value: integer);

const
  DeviceBufSize = 256;

var
  DeviceBuf: PChar;
  DevicePtr: PChar;
  DeviceName: PChar;
  DriverName: PChar;
  OutputName: PChar;
  NewIndex: integer;

begin { SetDeviceIndex }
  CheckNotPrinting;
{$IFDEF Linux}
//!!PORT!!
{$ELSE}

  FInvalidPrinter := false;
  If (Value <> FDeviceIndex) and (Value < Printers.Count) then begin
    If Value < 0 then begin { Set to default printer }
      GetMem(DeviceBuf,DeviceBufSize);
      try
        GetProfileString({Trans-}'WINDOWS',{Trans-}'DEVICE','',DeviceBuf,
         DeviceBufSize);
        If DeviceBuf^ = #0 then begin
          NewIndex := FPrinterList.Count - 1;
        end else begin
          DevicePtr := DeviceBuf;
          DeviceName := GetWord(DevicePtr);
          DriverName := GetWord(DevicePtr);
          OutputName := GetWord(DevicePtr);
          NewIndex := FindPrinter(DeviceName,DriverName,OutputName);
          If NewIndex < 0 then begin
            NewIndex := FPrinterList.Count - 1;
          end; { if }
        end; { else }
      finally
        FreeMem(DeviceBuf,DeviceBufSize);
      end; { tryf }
    end else begin { Get printer from FPrinterList }
      NewIndex := Value;
    end; { else }
    If NewIndex >= 0 then begin
      OpenDevice(NewIndex);
    end; { if }
  end; { if }

{$ENDIF}
end;  { SetDeviceIndex }

procedure TRPPrinterDevice.SetDeviceState(Value: TDeviceState);

var
  RPDeviceItem: TRPDeviceItem;

begin { SetDeviceState }
{$IFDEF Linux}
//!!PORT!!
{$ELSE}
  If not ((FDeviceState = dsDC) and (Value = dsIC)) and
   (Value <> FDeviceState) then begin
    If DC <> 0 then begin
      ReleaseCanvas;
      DeleteDC(DC);
      DC := 0;
    end; { if }

    If (Value <> dsNone) and not InvalidPrinter then begin
      GetDeviceIndex;
      RPDeviceItem := TRPDeviceItem(Printers.Objects[FDeviceIndex]);
      With RPDeviceItem do begin
        If Value = dsIC then begin
          // MH 07/02/2011 v6.6 ABSEXCH-10547: Modified call to comply with Windows API documentation - desperate attempt to fix printer issues
          DC := CreateIC(FDriverName,FDeviceName,NIL{FOutputName},FDevMode);
        end else begin
          // MH 07/02/2011 v6.6 ABSEXCH-10547: Modified call to comply with Windows API documentation - desperate attempt to fix printer issues
          DC := CreateDC(FDriverName,FDeviceName,NIL{FOutputName},FDevMode);
        end; { else }
        If DC = 0 then begin
          RaiseError(Trans(Format({Trans+}'Invalid Printer - %0:s on %1:s (%2:s)',
           [StrPas(FDeviceName),StrPas(FOutputName),StrPas(FDriverName)])));
        end; { if }
        If FCanvas <> nil then begin
          FCanvas.Handle := DC;
        end; { if }
      end; { with }
    end; { if }
    FDeviceState := Value;
  end; { if }
{$ENDIF}
end;  { SetDeviceState }

function TRPPrinterDevice.GetHandle: HDC;

begin { GetHandle }
  State := dsIC;
  Result := DC;
end;  { GetHandle }

function TRPPrinterDevice.GetCanvas: TCanvas;

begin { GetCanvas }
  If FCanvas = nil then begin
    FCanvas := TRPPrinterCanvas.Create(self);
  end; { if }
  Result := FCanvas;
end;  { GetCanvas }

{$IFDEF Linux}
//!!PORT!!
{$ELSE}
function TRPPrinterDevice.GetDevMode: WinTypes.PDevMode;

begin { GetDevMode }
  If InvalidPrinter then begin
    Result := nil;
  end else begin
    GetDeviceIndex;
    Result := FDevMode;
  end; { else }
end;  { GetDevMode }
{$ENDIF}

function TRPPrinterDevice.GetDriverName: string;

begin { GetDriverName }
  if Assigned(FDriverName) then begin
    Result := StrPas(FDriverName);
  end else begin
    Result := '';
  end; { else }
end;  { GetDriverName }

function TRPPrinterDevice.GetOutputName: string;

begin { GetOutputName }
  if Assigned(FOutputName) then begin
    Result := StrPas(FOutputName);
  end else begin
    Result := '';
  end; { else }
end;  { GetOutputName }

function TRPPrinterDevice.GetDeviceName: string;

begin { GetDeviceName }
  if Assigned(FDeviceName) then begin
    Result := StrPas(FDeviceName);
  end else begin
    Result := '';
  end; { else }
end;  { GetDeviceName }

procedure TRPPrinterDevice.CloseDevice;

begin { CloseDevice }
{ Close out old device first }
  State := dsNone;
  If FDeviceMode <> 0 then begin
    If not KeepDevMode then begin
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      GlobalUnlock(FDeviceMode);
      GlobalFree(FDeviceMode);
      FDeviceMode := 0;
      FDevMode := nil;
      {$ENDIF}
      DevModeChanged := false;
    end; { if }
    FDeviceIndex := -2;
  end; { if }
  If FDriverHandle <> 0 then begin
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    ClosePrinter(FDriverHandle);
    {$ENDIF}
    FDriverHandle := 0;
  end; { if }
  FFontList.Free;
  FFontList := nil;
  FBinList.Free;
  FBinList := nil;
  FPaperList.Free;
  FPaperList := nil;

  StrDispose(FDeviceName);
  FDeviceName := nil;
  StrDispose(FDriverName);
  FDriverName := nil;
  StrDispose(FOutputName);
  FOutputName := nil;
end;  { CloseDevice }

procedure TRPPrinterDevice.OpenDevice(NewIndex: integer);

var
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  TempDevMode: WinTypes.PDevMode;
  {$ENDIF}
  DevSize: integer;

begin { OpenDevice }
  If NewIndex = FDeviceIndex then Exit;

  CloseDevice;

{ Get the selected RPDeviceItem }
  FDeviceIndex := NewIndex;
  FDeviceName := StrNew(TRPDeviceItem(FPrinterList.Objects[FDeviceIndex]).
   FDeviceName);
  FDriverName := StrNew(TRPDeviceItem(FPrinterList.Objects[FDeviceIndex]).
   FDriverName);
  FOutputName := StrNew(TRPDeviceItem(FPrinterList.Objects[FDeviceIndex]).
   FOutputName);

{ Get printer driver handle }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If not OpenPrinter(FDeviceName,FDriverHandle,nil) then begin
    FDriverHandle := 0;
  end; { if }

  If (FDriverHandle > 0) and not KeepDevMode then begin
  { Figure out DevSize }
    GetMem(TempDevMode,SizeOf(TDevMode));
    try
      DevSize := DocumentProperties(0,FDriverHandle,FDeviceName,TempDevMode^,
       TempDevMode^,0);
    finally
      FreeMem(TempDevMode,SizeOf(TDevMode));
    end; { tryf }

    If DevSize > 0 then begin
    { Allocate space for FDeviceMode }
      FDeviceMode := GlobalAlloc(GMEM_MOVEABLE or GMEM_ZEROINIT,DevSize);
      If FDeviceMode <> 0 then begin
        FDevMode := GlobalLock(FDeviceMode);
        DevModeChanged := false;

      { Load up FDevMode with TDevMode information }
        If DocumentProperties(0,FDriverHandle,FDeviceName,FDevMode^,
         FDevMode^,DM_OUT_BUFFER) < 0 then begin { Error getting data }
          CloseDevice;
        end; { if }
      end; { if }
    end; { if }
  end; { if }
  KeepDevMode := false;
  {$ENDIF}
end;  { OpenDevice }

procedure TRPPrinterDevice.ResetDevice;

begin { ResetDevice }
  State := dsNone;
  If FDriverHandle <> 0 then begin
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    ClosePrinter(FDriverHandle);
    {$ENDIF}
    FDriverHandle := 0;
  end; { if }
  FFontList.Free;
  FFontList := nil;
  FBinList.Free;
  FBinList := nil;
  FPaperList.Free;
  FPaperList := nil;

{ Get printer driver handle }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If not OpenPrinter(FDeviceName,FDriverHandle,nil) then begin
    FDriverHandle := 0;
  end; { if }
  If FDriverHandle = 0 then begin
    CloseDevice;
  end; { if }
  {$ENDIF}
end;  { ResetDevice }

procedure TRPPrinterDevice.ReleaseCanvas;

begin { ReleaseCanvas }
  CanvasActive := (FCanvas <> nil);
  If not CanvasActive then Exit;

{ Save off Font, Pen and Brush }
  With Canvas do begin
    With SaveBrush do begin
      Color := Brush.Color;
      Style := Brush.Style;
      If (Brush.Bitmap = nil) or Brush.Bitmap.Empty then begin
        Bitmap := nil;
      end else begin
        Bitmap := TBitmap.Create;
        Bitmap.Assign(Brush.Bitmap);
      end; { if }
    end; { with }
    With SavePen do begin
      Color := Pen.Color;
      PenMode := Pen.Mode;
      Style := Pen.Style;
      Width := Pen.Width;
    end; { with }
    With SaveFont do begin
      Name := Font.Name;
      Size := Font.Size;
      Color := Font.Color;
      Style := Font.Style;
    end; { with }
  end; { with }

{ Release canvas }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  FCanvas.Handle := 0;
  FCanvas.Pen.Handle := GetStockObject(BLACK_PEN);
  FCanvas.Font.Handle := GetStockObject(SYSTEM_FONT);
  FCanvas.Brush.Handle := GetStockObject(BLACK_BRUSH);
  {$ENDIF}
end;  { ReleaseCanvas }

procedure TRPPrinterDevice.RecoverCanvas;

begin { RecoverCanvas }
  If not CanvasActive then Exit;

{ Recover canvas }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  FCanvas.Handle := DC;
  FCanvas.Font.PixelsPerInch := GetDeviceCaps(DC,LOGPIXELSY);

{ Recover Font, Pen and Brush }
  With Canvas do begin
    With SaveBrush do begin
      Brush.Color := Color;
      Brush.Style := Style;
      If Bitmap <> nil then begin
        Brush.Bitmap.Assign(Bitmap);
        Bitmap.Free;
      end; { if }
    end; { with }
    With SavePen do begin
      Pen.Color := Color;
      Pen.Mode := PenMode;
      Pen.Style := Style;
      Pen.Width := Width;
    end; { with }
    With SaveFont do begin
      Font.Name := Name;
      Font.Size := Size;
      Font.Color := Color;
      Font.Style := Style;
    end; { with }
  end; { with }
  {$ENDIF}
end;  { RecoverCanvas }

{*************}
{ Job Methods }
{*************}

function TRPPrinterDevice.GetOutputFile: string;

begin { GetOutputFile }
  Result := StrPas(FOutputFile);
end;  { GetOutputFile }

procedure TRPPrinterDevice.SetOutputFile(Value: string);

begin { SetOutputFile }
  CheckNotPrinting;

  StrDispose(FOutputFile);
  If Value = '' then begin
    FOutputFile := nil;
  end else begin
    FOutputFile := StrPCopy(StrAlloc(Length(Value) + 1),Value);
  end; { else }
end;  { SetOutputFile }

{$IFDEF Linux}
//!!PORT!!
{$ELSE}
function AbortProc(Prn: HDC;
                   Error: integer): BOOL; stdcall;

begin { AbortProc }
  Application.ProcessMessages;
  Result := not RPDev.Aborted;
end;  { AbortProc }
{$ENDIF}

procedure TRPPrinterDevice.BeginDoc;

begin { BeginDoc }
  BeginDocSelect;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  StartPage(DC);
  {$ENDIF}
  OnPage := true;
end;  { BeginDoc }

procedure TRPPrinterDevice.BeginDocSelect;

var
  TempTitle: string;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  DocInfo: TDocInfo;
  {$ENDIF}
begin { BeginDocSelect }
  CheckNotPrinting;
  ResetHandle(false);
  State := dsDC;
  FPrinting := true;
  FAborted := false;
  Canvas.Refresh;
  TempTitle := Title + #0;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  With DocInfo do begin
    cbSize := SizeOf(DocInfo);
    lpszDocName := @TempTitle[1];
    lpszOutput := FOutputFile;
    lpszDataType := nil;
    fwType := 0;
  end; { with }
  SetAbortProc(DC,AbortProc);
  StartDoc(DC,DocInfo);
  {$ENDIF}
  OnPage := false;
end;  { BeginDocSelect }

procedure TRPPrinterDevice.EndDoc;

begin { EndDoc }
  CheckPrinting;
  If OnPage then begin
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    EndPage(DC);
    {$ENDIF}
  end; { if }
  If not Aborted then begin
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    WinProcs.EndDoc(DC);
    {$ENDIF}
  end; { if }
  State := dsNone;
  FPrinting := false;
  FAborted := false;
end;  { EndDoc }

procedure TRPPrinterDevice.Abort;

begin { Abort }
  CheckPrinting;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  AbortDoc(DC);
  {$ENDIF}
  FAborted := true;
  EndDoc;
end;  { Abort }

procedure TRPPrinterDevice.ResetHandle(Force: boolean);

begin { ResetHandle }
  If ((State = dsIC) and DevModeChanged) or Force then begin
    DevModeChanged := false;
    ReleaseCanvas;
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    If Assigned(FDevMode) then begin
      ResetDC(DC,FDevMode^);
    end; { if }
    {$ENDIF}
    RecoverCanvas;
  end; { if }
end;  { ResetHandle }

procedure TRPPrinterDevice.NewPage;

begin { NewPage }
  CheckPrinting;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  EndPage(DC);
  {$ENDIF}
  If DevModeChanged then begin
    ResetHandle(true);
  end; { if }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  StartPage(DC);
  {$ENDIF}
end;  { NewPage }

procedure TRPPrinterDevice.NewPageSelect(PageValid: boolean);

begin { NewPage }
  CheckPrinting;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If OnPage then begin
    EndPage(DC);
  end; { if }
  {$ENDIF}
  If DevModeChanged then begin
    ResetHandle(true);
  end else begin
    FCanvas.Refresh;
  end; { else }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If PageValid then begin
    StartPage(DC);
  end; { if }
  {$ENDIF}
  OnPage := PageValid;
end;  { NewPage }

{********************}
{ Capability Methods }
{********************}

{ Paper Bin Methods }

function TRPPrinterDevice.GetBins: TStrings;

type
  TBinName = array[1..24] of char;
  TBinBuf = array[1..512] of TBinName;
  TBinNumBuf = array[1..512] of word;

var
  Bins: integer;
  Bin: integer;
  BinBuf: ^TBinBuf;
  BinNumBuf: ^TBinNumBuf;
  BinNum: longint;

begin { GetBins }
  If FBinList = nil then begin
    State := dsIC;
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    Bins := DeviceCapabilities(FDeviceName,FOutputName,DC_BINNAMES,nil,nil);
    {$ENDIF}
    FBinList := TStringList.Create;
    GetMem(BinBuf,Bins * SizeOf(TBinName));
    GetMem(BinNumBuf,Bins * SizeOf(word));
    try
      try
        {$IFDEF Linux}
        //!!PORT!!
        {$ELSE}
        If DeviceCapabilities(FDeviceName,FOutputName,DC_BINNAMES,
         PChar(BinBuf),nil) >= 0 then begin
          DeviceCapabilities(FDeviceName,FOutputName,DC_BINS,
           PChar(BinNumBuf),nil);
          For Bin := 1 to Bins do begin
            BinNum := BinNumBuf^[Bin];
            FBinList.AddObject(StrPas(@BinBuf^[Bin,1]),pointer(BinNum));
          end; { for }
        end; { if }
        {$ENDIF}
      finally
        FreeMem(BinNumBuf,Bins * SizeOf(word));
        FreeMem(BinBuf,Bins * SizeOf(TBinName));
      end; { tryf }
    except
      FBinList.Free;
      FBinList := nil;
      Raise;
    end; { tryx }
  end; { if }
  Result := FBinList;
end;  { GetBins }

function TRPPrinterDevice.SelectBin(BinName: string;
                                    Exact: boolean): boolean;

var
  Bin: integer;
  Found: boolean;
  BinNum: longint;

begin { SelectBin }
{ Look for BinName in FBinList }
  GetBins;
  Found := false;
  For Bin := 1 to FBinList.Count do begin
    If Exact then begin
      Found := (FBinList[Bin - 1] = BinName);
    end else begin
      Found := (Pos(AnsiUpperCase(BinName),AnsiUpperCase(FBinList[Bin - 1])) > 0);
    end; { else }
    If Found then begin
      BinNum := longint(FBinList.Objects[Bin - 1]);
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      If DevMode <> nil then begin
        If FDevMode^.dmDefaultSource <> BinNum then begin
          FDevMode^.dmDefaultSource := BinNum;
          FDevMode^.dmFields := FDevMode^.dmFields or DM_DEFAULTSOURCE;
          DevModeChanged := true;
        end; { if }
      end else begin
        Found := false;
      end; { else }
      {$ENDIF}
      Break;
    end; { if }
  end; { for }
  Result := Found;
end;  { SelectBin }

function TRPPrinterDevice.SupportBin(BinNum: integer): boolean;

var
  Bin: integer;
  Found: boolean;

begin { SupportBin }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := (DevMode <> nil) and ((DevMode^.dmFields and DM_DEFAULTSOURCE) > 0);
  {$ENDIF}
  If Result then begin
  { Look for BinNum in FBinList }
    GetBins;
    Found := false;
    For Bin := 1 to FBinList.Count do begin
      Found := (longint(FBinList.Objects[Bin - 1]) = BinNum);
      If Found then begin
        Break;
      end; { if }
    end; { for }
    Result := Found;
  end; { if }
end;  { SupportBin }

{ Paper Size Methods }

function TRPPrinterDevice.GetPapers: TStrings;

type
  TPaperName = array[1..64] of char;
  TPaperBuf = array[1..512] of TPaperName;
  TPaperNumBuf = array[1..512] of word;

var
  Papers: integer;
  Paper: integer;
  PaperBuf: ^TPaperBuf;
  PaperNumBuf: ^TPaperNumBuf;
  PaperNum: longint;

begin { GetPapers }
  If FPaperList = nil then begin
    State := dsIC;
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    Papers := DeviceCapabilities(FDeviceName,FOutputName,DC_PAPERNAMES,nil,nil);
    {$ENDIF}
    FPaperList := TStringList.Create;
    GetMem(PaperBuf,Papers * SizeOf(TPaperName));
    GetMem(PaperNumBuf,Papers * SizeOf(word));
    try
      try
        {$IFDEF Linux}
        //!!PORT!!
        {$ELSE}
        If DeviceCapabilities(FDeviceName,FOutputName,DC_PAPERNAMES,
         PChar(PaperBuf),nil) >= 0 then begin
          DeviceCapabilities(FDeviceName,FOutputName,DC_PAPERS,
           PChar(PaperNumBuf),nil);
          For Paper := 1 to Papers do begin
            PaperNum := PaperNumBuf^[Paper];
            FPaperList.AddObject(StrPas(@PaperBuf^[Paper,1]),pointer(PaperNum));
          end; { for }
        end; { if }
        {$ENDIF}
      finally
        FreeMem(PaperNumBuf,Papers * SizeOf(word));
        FreeMem(PaperBuf,Papers * SizeOf(TPaperName));
      end; { tryf }
    except
      FPaperList.Free;
      FPaperList := nil;
      Raise;
    end; { tryx }
  end; { if }
  Result := FPaperList;
end;  { GetPapers }

function TRPPrinterDevice.SelectPaper(PaperName: string;
                                      Exact: boolean): boolean;

var
  Paper: integer;
  Found: boolean;
  PaperNum: longint;

begin { SelectPaper }
  CheckNotPrinting;

{ Look for PaperName in FPaperList }
  GetPapers;
  Found := false;
  For Paper := 1 to FPaperList.Count do begin
    If Exact then begin
      Found := (FPaperList[Paper - 1] = PaperName);
    end else begin
      Found := (Pos(AnsiUpperCase(PaperName),AnsiUpperCase(FPaperList[Paper - 1])) > 0);
    end; { else }
    If Found then begin
      PaperNum := longint(FPaperList.Objects[Paper - 1]);
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      If DevMode <> nil then begin
        If FDevMode^.dmPaperSize <> PaperNum then begin
          FDevMode^.dmPaperSize := PaperNum;
          FDevMode^.dmFields := FDevMode^.dmFields or DM_PAPERSIZE;
          DevModeChanged := true;
        end; { if }
      end else begin
        Found := false;
      end; { else }
      {$ENDIF}
      Break;
    end; { if }
  end; { for }
  Result := Found;
end;  { SelectPaper }

function TRPPrinterDevice.SupportPaper(PaperNum: integer): boolean;

var
  Paper: integer;
  Found: boolean;

begin { SupportPaper }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := (DevMode <> nil) and ((DevMode^.dmFields and DM_PAPERSIZE) > 0);
  {$ENDIF}
  If Result then begin
  { Look for PaperNum in FPaperList }
    GetPapers;
    Found := false;
    For Paper := 1 to FPaperList.Count do begin
      Found := (longint(FPaperList.Objects[Paper - 1]) = PaperNum);
      If Found then begin
        Break;
      end; { if }
    end; { for }
    Result := Found;
  end; { if }
end;  { SupportPaper }

{ Misc capability methods }

{$IFDEF Linux}
//!!PORT!!
{$ELSE}
function EnumFontsProc(var LogFont: TLogFont;
                       var TextMetric: TTextMetric;
                           FontType: integer;
                           Data: pointer): integer; stdcall;

begin { EnumFontsProc }
  TStrings(Data).Add(StrPas(LogFont.lfFaceName));
  Result := 1;
end;  { EnumFontsProc }
{$ENDIF}

function TRPPrinterDevice.GetFonts: TStrings;

  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
var
  EnumProc: TFarProc;
  {$ENDIF}
begin { GetFonts }
  If FFontList = nil then begin
    State := dsIC;
    FFontList := TStringList.Create;
    try
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      EnumProc := @EnumFontsProc;
      EnumFonts(DC,nil,EnumProc,pointer(FFontList));
      {$ENDIF}
    except
      FFontList.Free;
      FFontList := nil;
      Raise;
    end; { tryx }
  end; { if }
  Result := FFontList;
end;  { GetFonts }

function TRPPrinterDevice.GetPrinters: TStrings;

const
  DeviceBufInc = 1024;
  DriverBufSize = 256;

var
  Flags: DWORD;
  Level: DWORD;
  Needed: DWORD;
  Returned: DWORD;
  PrinterInfo: PChar;
  PrinterInfos: PChar;
  Port: PChar;
  Ports: PChar;
  I1: integer;

begin { GetPrinters }
  If FPrinterList = nil then begin { Init FPrinterList }
    FPrinterList := TStringList.Create;
    Result := FPrinterList;
    try
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      If Win32Platform = VER_PLATFORM_WIN32_NT then begin
        Level := 4;
        Flags := PRINTER_ENUM_LOCAL or PRINTER_ENUM_CONNECTIONS;
      end else begin
        Level := 5;
        Flags := PRINTER_ENUM_LOCAL;
      end; { else }
      {$ENDIF}
      Needed := 0;
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      EnumPrinters(Flags,nil,Level,nil,0,Needed,Returned);
      {$ENDIF}
      If Needed = 0 then Exit;

      GetMem(PrinterInfos,Needed);
      try
        {$IFDEF Linux}
        //!!PORT!!
        {$ELSE}
        If not EnumPrinters(Flags,nil,Level,PrinterInfos,Needed,Needed,Returned) then begin
          Exit;
        end; { if }
        PrinterInfo := PrinterInfos;
        For I1 := 0 to Returned - 1 do begin
          If Win32Platform = VER_PLATFORM_WIN32_NT then begin
            With PPrinterInfo4(PrinterInfo)^ do begin
              FPrinterList.AddObject(pPrinterName,
               TRPDeviceItem.Create(pPrinterName,nil,nil));
              Inc(PrinterInfo,SizeOf(TPrinterInfo4));
            end; { with }
          end else begin
            With PPrinterInfo5(PrinterInfo)^ do begin
              Ports := pPortName;
              Port := GetWord(Ports);
              While Assigned(Port) do begin
                FPrinterList.AddObject(Format({Trans-}'%s on %s',[pPrinterName,Port]),
                 TRPDeviceItem.Create(pPrinterName,nil,Port));
                Port := GetWord(Ports);
              end; { while }
              Inc(PrinterInfo,SizeOf(TPrinterInfo5));
            end; { with }
          end; { else }
        end; { for }
        {$ENDIF}
      finally
        FreeMem(PrinterInfos,Needed);
      end; { tryf }
    except
      FPrinterList.Free;
      FPrinterList := nil;
      Raise;
    end; { tryx }
  end; { if }
  Result := FPrinterList;
end;  { GetPrinters }

function TRPPrinterDevice.SelectPrinter(PrinterName: string;
                                        Exact: boolean): boolean;

var
  Printer: integer;
  Found: boolean;

begin { SelectPrinter }
  CheckNotPrinting;

{ Look for PrinterName in FPrinterList }
  GetPrinters;
  Found := false;
  For Printer := 1 to FPrinterList.Count do begin
    With TRPDeviceItem(FPrinterList.Objects[Printer - 1]) do begin
      If Exact then begin
        If Pos({Trans-}' on ',PrinterName) > 0 then begin
          Found := (PrinterName = (StrPas(FDeviceName) + {Trans-}' on ' +
           StrPas(FOutputName)));
        end else begin
          Found := (StrPas(FDeviceName) = PrinterName);
        end; { else }
      end else begin
        Found := (Pos(AnsiUpperCase(PrinterName),
         AnsiUpperCase(StrPas(FDeviceName) + {Trans-}' on ' + StrPas(FOutputName))) > 0);
      end; { else }
    end; { with }
    If Found then begin
      SetDeviceIndex(Printer - 1);
      Break;
    end; { if }
  end; { for }
  Result := Found;
end;  { SelectPrinter }

{ Orientation methods }

function TRPPrinterDevice.GetOrientation: TOrientation;

begin { GetOrientation }
  State := dsIC;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If DevMode <> nil then begin
    Result := TOrientation(FDevMode^.dmOrientation - 1);
  end else begin
    Result := TOrientation(poPortrait);
  end; { else }
  {$ENDIF}
end;  { GetOrientation }

procedure TRPPrinterDevice.SetOrientation(Value: TOrientation);
begin { SetOrientation }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If (DevMode <> nil) and (Value <> poDefault) and
   (FDevMode^.dmOrientation <> (Ord(Value) + 1)) then begin
    FDevMode^.dmOrientation := Ord(Value) + 1;
    FDevMode^.dmFields := FDevMode^.dmFields or DM_ORIENTATION;
    DevModeChanged := true;
  end; { if }
  {$ENDIF}
end;  { SetOrientation }

function TRPPrinterDevice.SupportOrientation: boolean;

begin { SupportOrientation }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := (DevMode <> nil) and ((DevMode^.dmFields and DM_ORIENTATION) > 0);
  {$ENDIF}
end;  { SupportOrientation }

{ Copies methods }

function TRPPrinterDevice.GetMaxCopies: longint;

begin { GetMaxCopies }
  If InvalidPrinter then begin
    Result := 1;
    Exit;
  end; { if }
  State := dsIC;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := DeviceCapabilities(FDeviceName,FOutputName,DC_COPIES,nil,nil);
  {$ENDIF}
end;  { GetMaxCopies }

procedure TRPPrinterDevice.SetCopies(Value: integer);

begin { SetCopies }
  CheckNotPrinting;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If (DevMode <> nil) and (Value > 0) and (Value < MaxCopies) and
   (Value <> FDevMode^.dmCopies) then begin
    FDevMode^.dmCopies := Value;
    FDevMode^.dmFields := FDevMode^.dmFields or DM_COPIES;
    DevModeChanged := true;
  end; { if }
  {$ENDIF}
end;  { SetCopies }

function TRPPrinterDevice.GetCopies: integer;

begin { GetCopies }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If DevMode <> nil then begin
    Result := FDevMode^.dmCopies;
    If Result = 0 then begin { Some printers return 0 ?!? }
      Result := 1;
    end; { if }
  end else begin
    Result := 1;
  end; { else }
  {$ENDIF}
end;  { GetCopies }

{ Duplex methods }

function TRPPrinterDevice.GetDuplex: TDuplex;

begin { GetDuplex }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If (DevMode <> nil) and (FDevMode^.dmDuplex in [1..3]) then begin
    Result := TDuplex(FDevMode^.dmDuplex - 1);
  end else begin
    Result := dupSimplex;
  end; { else }
  {$ENDIF}
end;  { GetDuplex }

procedure TRPPrinterDevice.SetDuplex(Value: TDuplex);

begin { SetDuplex }
  CheckNotPrinting;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If (DevMode <> nil) and SupportDuplex and
   (FDevMode^.dmDuplex <> (Ord(Value) + 1)) then begin
    FDevMode^.dmDuplex := Ord(Value) + 1;
    FDevMode^.dmFields := FDevMode^.dmFields or DM_DUPLEX;
    DevModeChanged := true;
  end; { if }
  {$ENDIF}
end;  { SetDuplex }

function TRPPrinterDevice.SupportDuplex: boolean;

begin { SupportDuplex }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := (DevMode <> nil) and ((DevMode^.dmFields and DM_DUPLEX) > 0);
  {$ENDIF}
end;  { SupportDuplex }

{ Collate methods }

function TRPPrinterDevice.GetCollate: boolean;

begin { GetCollate }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If DevMode <> nil then begin
    Result := FDevMode^.dmCollate = DMCOLLATE_TRUE;
  end else begin
    Result := false;
  end; { else }
  {$ENDIF}
end;  { GetCollate }

procedure TRPPrinterDevice.SetCollate(Value: boolean);

begin { SetCollate }
  CheckNotPrinting;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If (DevMode <> nil) and SupportCollate then begin
    If Value <> (FDevMode^.dmCollate = DMCOLLATE_TRUE) then begin
      If Value then begin
        FDevMode^.dmCollate := DMCOLLATE_TRUE;
      end else begin
        FDevMode^.dmCollate := DMCOLLATE_FALSE;
      end; { else }
      FDevMode^.dmFields := FDevMode^.dmFields or DM_COLLATE;
      DevModeChanged := true;
    end; { if }
  end; { if }
  {$ENDIF}
end;  { SetCollate }

function TRPPrinterDevice.SupportCollate: boolean;

begin { SupportCollate }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := (DevMode <> nil) and ((DevMode^.dmFields and DM_COLLATE) > 0);
  {$ENDIF}
end;  { SupportCollate }

{ Page size methods }

function TRPPrinterDevice.GetPageHeight: integer;

begin { GetPageHeight }
  State := dsIC;
  ResetHandle(false);
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := GetDeviceCaps(DC,VertRes);
  {$ENDIF}
end;  { GetPageHeight }

function TRPPrinterDevice.GetPageWidth: integer;

begin { GetPageWidth }
  State := dsIC;
  ResetHandle(false);
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := GetDeviceCaps(DC,HorzRes);
  {$ENDIF}
end;  { GetPageWidth }

procedure TRPPrinterDevice.GetCustomExtents(var MinExtent: TPoint;
                                            var MaxExtent: TPoint);

var
  L1: longint;

begin { GetCustomExtents }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  L1 := DeviceCapabilities(FDeviceName,FOutputName,DC_MINEXTENT,nil,nil);
  If L1 = -1 then begin
    MinExtent.X := 1;
    MinExtent.Y := 1;
  end else begin
    MinExtent.X := LoWord(L1);
    MinExtent.Y := HiWord(L1);
  end; { else }
  If MinExtent.Y = 0 then begin
    MinExtent.Y := MinExtent.X;
  end; { if }
  L1 := DeviceCapabilities(FDeviceName,FOutputName,DC_MAXEXTENT,nil,nil);
  If L1 = -1 then begin
    MaxExtent.X := 32767;
    MaxExtent.Y := 32767;
  end else begin
    MaxExtent.X := LoWord(L1);
    MaxExtent.Y := HiWord(L1);
  end; { else }
  If MaxExtent.Y = 0 then begin
    MaxExtent.Y := MaxExtent.X;
  end; { if }
  {$ENDIF}
end;  { GetCustomExtents }

function TRPPrinterDevice.SetPaperSize(Size: integer;
                                       Width: integer;
                                       Height: integer): boolean;

var
  MinExtent: TPoint;
  MaxExtent: TPoint;

begin { SetPaperSize }
  CheckNotPrinting;

  Result := false;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If DevMode = nil then Exit;
  If (Width <> 0) and (Height <> 0) then begin
    If SupportPaper(DMPAPER_USER) and ((FDevMode^.dmPaperSize <> DMPAPER_USER) or
     (FDevMode^.dmPaperWidth <> Width) or
     (FDevMode^.dmPaperLength <> Height)) then begin
    { See if values are within min and max extents }
      GetCustomExtents(MinExtent,MaxExtent);
      If (Width >= MinExtent.X) and (Width <= MaxExtent.X) and
       (Height >= MinExtent.Y) and (Height <= MaxExtent.Y) then begin
        FDevMode^.dmPaperSize := DMPAPER_USER;
        FDevMode^.dmPaperWidth := Width;
        FDevMode^.dmPaperLength := Height;
        FDevMode^.dmFields := FDevMode^.dmFields or DM_PAPERSIZE or
         DM_PAPERWIDTH or DM_PAPERLENGTH;
        DevModeChanged := true;
        Result := true;
      end; { if }
    end; { if }
  end else begin
    If SupportPaper(Size) and ((FDevMode^.dmPaperSize <> Size) or
     (FDevMode^.dmPaperWidth <> 0) or (FDevMode^.dmPaperLength <> 0)) then begin
      FDevMode^.dmPaperSize := Size;
      FDevMode^.dmPaperWidth := 0;
      FDevMode^.dmPaperLength := 0;
      FDevMode^.dmFields := FDevMode^.dmFields or DM_PAPERSIZE or
       DM_PAPERWIDTH or DM_PAPERLENGTH;
      DevModeChanged := true;
      Result := true;
    end; { if }
  end; { else }
  {$ENDIF}
end;  { SetPaperSize }

function TRPPrinterDevice.InvalidPrinter: boolean;

begin { InvalidPrinter }
  Result := FInvalidPrinter or (Printers.Count = 0) or (DeviceIndex < 0);
  FInvalidPrinter := Result;
end;  { InvalidPrinter }

function TRPPrinterDevice.GetXDPI: integer;
begin { GetXDPI }
  State := dsIC;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := GetDeviceCaps(Handle,LOGPIXELSX);
  {$ENDIF}
If Result = 0 then Result := 100; //!!!
end;  { GetXDPI }

function TRPPrinterDevice.GetYDPI: integer;
begin { GetYDPI }
  State := dsIC;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := GetDeviceCaps(Handle,LOGPIXELSY);
  {$ENDIF}
If Result = 0 then Result := 100; //!!!
end;  { GetYDPI }

function TRPPrinterDevice.GetWaste: TRect;
var
  PrintOffset: TPoint;
  PageSize: TPoint;
begin { GetWaste }
  State := dsIC;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  PrintOffset.X := GetDeviceCaps(Handle,PHYSICALOFFSETX);
  PrintOffset.Y := GetDeviceCaps(Handle,PHYSICALOFFSETY);
  PageSize.X := GetDeviceCaps(Handle,PHYSICALWIDTH);
  PageSize.Y := GetDeviceCaps(Handle,PHYSICALHEIGHT);
  Result.Left := PrintOffset.X;
  Result.Right := (PageSize.X - (GetDeviceCaps(Handle,HORZRES) + PrintOffset.X));
  Result.Top := PrintOffset.Y;
  Result.Bottom := (PageSize.Y - (GetDeviceCaps(Handle,VERTRES) + PrintOffset.Y));
  {$ENDIF}
end;  { GetWaste }


Function TRPDevice.WalkList (TheList : TStrings; ReqNum : Integer) : String;
Var
  I : Integer;
Begin
  Result := '';

  If (TheList.Count > 0) Then
    For I := 0 To Pred (TheList.Count) Do
      If (LongInt(TheList.Objects[I]) = ReqNum) Then Begin
        { Found it }
        Result := TheList[I];
        Break;
      End; { If }
End;

// HM 27/06/02: Added for Form Printing Toolkit - Returns index of found item
Function TRPDevice.WalkListIdx (TheList : TStrings; ReqNum : Integer) : Integer;
Var
  I : Integer;
Begin
  Result := -1;

  If (TheList.Count > 0) Then
    For I := 0 To Pred (TheList.Count) Do
      If (LongInt(TheList.Objects[I]) = ReqNum) Then Begin
        { Found it }
        Result := I;
        Break;
      End; { If }
End;

function TRPDevice.SBSSetupInfo2(Const BaseInfo : TSBSPrintSetupInfo) : TSBSPrintSetupInfo;
begin
  Result := BaseInfo;
  With Result Do Begin
    DevIdx := DeviceIndex;

    // HM 11/01/05: Added this clause as one site was getting Access
    // Violations in SBSSetupInfo and most other RPDev code checks whether
    // it is assigned or not
    If Assigned(DevMode) Then    
    Begin
      FormNo   := DevMode^.dmPaperSize;
      FormName := WalkList(RpDev.Papers, FormNo);

      BinNo    := DevMode.dmDefaultSource;
      BinName  := WalkList(RpDev.Bins, BinNo);
    End; // If Assigned(DevMode)

    { .. }
  End; { With }
end;

function TRPDevice.SBSSetupInfo : TSBSPrintSetupInfo;
Var
  TempPrnInfo : TSBSPrintSetupInfo;
begin
  FillChar (TempPrnInfo, SizeOf (TempPrnInfo), #0);
  Result := SBSSetupInfo2(TempPrnInfo);
end;

procedure TRPDevice.SetPrnSetup(PrnSetup : TSBSPrintSetupInfo);
Begin
  { Device Index }
  DeviceIndex := PrnSetup.DevIdx;

  { Form }
  If (Trim (PrnSetup.FormName) <> '') Then SelectPaper (PrnSetup.FormName, True);

  { Bin }
  If (Trim (PrnSetup.BinName) <> '') Then SelectBin (PrnSetup.BinName, True);
End;

function TRPDevice.CheckForDriver(SearchDriver : string) : boolean;
// Pre  : SearchDriver = name of the print driver to check for
// Post : Returns true if found
var
  i : integer;
begin
  Result := false;
  for i := 0 to Printers.Count -1 do
    Result := Result or ((Printers.Objects[i] as TRPDeviceItem).FDriverName = SearchDriver);
end;



{ Persistent device object management routines }

var
  FRPDev: TRPBaseDevice;

function GlobalDevice: TRPBaseDevice;

begin { GlobalDevice }
  If FRPDev = nil then begin
    FRPDev := TRPPrinterDevice.Create;
  end; { if }
  Result := FRPDev;
end;  { GlobalDevice }

function RPDev: TRPPrinterDevice;

begin { RPDev }
  GlobalDevice;
  If FRPDev is TRPPrinterDevice then begin
    Result := TRPPrinterDevice(FRPDev);
  end else begin
    Result := nil;
  end; { else }
end;  { RPDev }

function SetNewDevice(NewDevice: TRPBaseDevice): TRPBaseDevice;

begin { SetNewDevice }
  Result := FRPDev;
  FRPDev := NewDevice;
end;  { SetNewDevice }

initialization
//ShowMessage ('TSBSPrintSetupInfo: ' + IntToStr(SizeOf(TSBSPrintSetupInfo)));

  FRPDev := nil;
finalization
  If FRPDev <> nil then begin
    FRPDev.Free;
  end; { if }
end.
