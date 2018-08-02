unit VRWClipboardManagerU;

interface

uses SysUtils, Windows, Classes, StdCtrls, ExtCtrls, ClipBrd,
  VRWReportIF, VRWClipboardManagerIF;

type
  TVRWClipboardStream = class(TObject)
  private
    FStream: TMemoryStream;
  public

    destructor Destroy; override;

    { Closes the current stream. }
    procedure Close;

    { Opens the stream. }
    procedure Open; virtual;

    { The stream which is used to hold the control properties for writing
      to or reading from the clipboard. It can hold multiple controls. }
    property Stream: TMemoryStream read FStream;

  end;

  TVRWClipboardReader = class(TVRWClipboardStream)
  public

    { Opens the stream and reads the contents from the clipboard. }
    procedure Open; override;

    { Reads the next control from the stream. }
    function Read: TVRWControlProperties;

    { Reads an image for IVRWImageControls }
    procedure ReadImage(Control: IVRWImageControl);

  end;

  TVRWClipboardWriter = class(TVRWClipboardStream)
  public

    { Writes the stream to the clipboard. }
    procedure Commit;

    { Writes the control to the stream. }
    procedure Write(Control: IVRWControl);

  end;

  TVRWClipboardManager = class(TInterfacedObject, IVRWClipboardManager)
  private

    { Controls which are waiting to be copied to the clipboard are stored in
      the Pending clipboard stream. }
    FPending: TVRWClipboardWriter;

    { Controls which have been retrieved from the clipboard ready for pasting
      into the report are stored in the Incoming clipboard stream. }
    FIncoming: TVRWClipboardReader;

    { Clears the internal list of controls. }
    procedure ClearPending;

    { Pastes the control into the report.

      If IntoRegion is specified, the control will be pasted into this region,
      otherwise it will be pasted into its original region. If its original
      region cannot be (this can only happen if the region was a section header
      or section footer) the control will be pasted into the first section
      header or footer. If there are no sections at all, the control will be
      pasted into the report lines region. }
    procedure PasteControl(Properties: TVRWControlProperties;
      IntoReport: IVRWReport; IntoRegion: IVRWRegion; OnPaste: TVRWOnPasteControl);

    { Adds the control to the list of controls waiting to be copied to the
      clipboard }
    procedure AddToPending(Control: IVRWControl);

  public

    constructor Create;

    destructor Destroy; override;

    { Clears all controls from list of pending items. }
    procedure ClearClipboard;

    { Adds the control to the list of pending items. }
    procedure CopyToClipboard(Control: IVRWControl);

    { Copies all the pending items to the clipboard, and clears the list }
    procedure CommitClipboard;

    { Pastes the control(s) from the clipboard. See PasteControl() for more
      details. }
    procedure PasteFromClipboard(Report: IVRWReport; IntoRegion: IVRWRegion = nil; OnPaste: TVRWOnPasteControl = nil);

    { Returns True if there are any controls on the clipboard }
    function CanPaste: Boolean;

  end;

implementation

{ TVRWClipboard }

var
  CF_VRWCONTROL_PROPERTIES: Cardinal;

procedure TVRWClipboardManager.AddToPending(Control: IVRWControl);
begin
  FPending.Open;
  FPending.Write(Control);
end;

procedure TVRWClipboardManager.ClearClipboard;
begin
  ClearPending;
end;

procedure TVRWClipboardManager.ClearPending;
begin
  FPending.Close;
end;

procedure TVRWClipboardManager.CommitClipboard;
begin
  FPending.Commit;
  FPending.Close;
end;

procedure TVRWClipboardManager.CopyToClipboard(Control: IVRWControl);
begin
  AddToPending(Control);
end;

constructor TVRWClipboardManager.Create;
begin
  inherited Create;
  FPending := TVRWClipboardWriter.Create;
  FIncoming := TVRWClipboardReader.Create;
end;

destructor TVRWClipboardManager.Destroy;
begin
  FIncoming.Free;
  FPending.Free;
  inherited;
end;

procedure TVRWClipboardManager.PasteFromClipboard(Report: IVRWReport;
  IntoRegion: IVRWRegion; OnPaste: TVRWOnPasteControl);
var
  Properties: TVRWControlProperties;
begin
  FIncoming.Close;
  FIncoming.Open;
  Properties := FIncoming.Read;
  while (Properties.FvcType <> ctUnknown) do
  begin
    PasteControl(Properties, Report, IntoRegion, OnPaste);
    Properties := FIncoming.Read;
  end;
end;

procedure TVRWClipboardManager.PasteControl(Properties: TVRWControlProperties;
  IntoReport: IVRWReport; IntoRegion: IVRWRegion; OnPaste: TVRWOnPasteControl);
var
  RegionName: ShortString;
  Control: IVRWControl;
begin
  RegionName := Properties.FvcRegionName;
  if (IntoRegion = nil) then
  begin
    { Search the report for a region which matches the original region name
      of the pasted control. }
    IntoRegion := IntoReport.vrRegions.rlRegions[RegionName];
    if (IntoRegion = nil) then
    begin
      { If no region is found, this must mean that the region is a section
        header or footer, and does not match with the sections in the
        report. Determine whether it is a header or footer, and search for
        the first section region. }
      if (Pos('Footer', RegionName) > 0) then
        RegionName := 'Section Footer 1'
      else
        RegionName := 'Section Header 1';
      { Now search for this region. If it cannot be found, there are no
        sections in the report, so select the Report Lines region instead. }
      IntoRegion := IntoReport.vrRegions.rlRegions[RegionName];
      if (IntoRegion = nil) then
        IntoRegion := IntoReport.vrRegions.rlRegions['Report Lines'];
    end;
  end;
  if (IntoRegion <> nil) then
  begin
    { Create a new control }
    Control := IntoRegion.rgControls.Add(IntoReport, Properties.FvcType);
    try
      Properties.FvcName := Control.vcName;
      if Supports(Control, IVRWFormulaControl) then
        Properties.FvcFormulaName := IntoReport.CreateUniqueFormulaName;
      Properties.FvcRegionName := IntoRegion.rgName;
      Control.SetProperties(Properties);
      { Adjust the positioning }
      Control.vcTop  := Control.vcTop + 1;
      Control.vcLeft := Control.vcLeft + 1;
      if Supports(Control, IVRWImageControl) then
      begin
        FIncoming.ReadImage(Control as IVRWImageControl);
      end;
      if Assigned(OnPaste) then
        OnPaste(Control);
    finally
      Control := nil;
    end;
  end;
end;

{ TVRWClipboardStream }

procedure TVRWClipboardStream.Close;
begin
  if (FStream <> nil) then
    FreeAndNil(FStream);
end;

destructor TVRWClipboardStream.Destroy;
begin
  Close;
  inherited;
end;

procedure TVRWClipboardStream.Open;
begin
  if (FStream = nil) then
    FStream := TMemoryStream.Create;
end;

{ TVRWClipboardReader }

procedure TVRWClipboardReader.Open;
var
  hMem: THandle;
  pMem: Pointer;
begin
  inherited;
  hMem := Clipboard.GetAsHandle(CF_VRWCONTROL_PROPERTIES);
  if hMem <> 0 then
  begin
    pMem := GlobalLock(hMem);
    if pMem <> nil then
    begin
      try
        Stream.Write(pMem^, GlobalSize(hMem));
        Stream.Position := 0;
      finally
        GlobalUnlock(hMem);
      end;
    end { If }
    else
      raise Exception.Create('Open: could not lock global handle ' +
                             'obtained from clipboard!');
  end; { If }
end;

function TVRWClipboardReader.Read: TVRWControlProperties;
begin
  if Stream.Read(Result, SizeOf(Result)) < SizeOf(Result) then
    Result.FvcType := ctUnknown;
end;

procedure TVRWClipboardReader.ReadImage(Control: IVRWImageControl);
var
  ImageSize: Integer;
begin
  { Read the size of the image from the incoming clipboard stream }
  Stream.Read(ImageSize, SizeOf(ImageSize));
  { Read the actual image data from the incoming clipboard stream }
  Control.vcImageStream.CopyFrom(Stream, ImageSize);
  { Now copy the data to the TImage component }
  Control.vcImageStream.Position := 0;
  Control.vcImage.Picture.Bitmap.LoadFromStream(Control.vcImageStream);
  Control.ReadImageBuffer;
end;

{ TVRWClipboardWriter }

procedure TVRWClipboardWriter.Commit;
var
  hMem: THandle;
  pMem: Pointer;
begin
  Stream.Position := 0;
  hMem := GlobalAlloc(GHND or GMEM_DDESHARE, Stream.Size);
  if hMem <> 0 then
  begin
    pMem := GlobalLock(hMem);
    if pMem <> nil then
    begin
      try
        Stream.Read(pMem^, Stream.Size);
        Stream.Position := 0;
      finally
        GlobalUnlock(hMem);
      end;
      Clipboard.Clear;
      Clipboard.Open;
      try
        Clipboard.SetAsHandle(CF_VRWCONTROL_PROPERTIES, hMem);
      finally
        Clipboard.Close;
      end;
    end { If }
    else
    begin
      GlobalFree(hMem);
      OutOfMemoryError;
    end;
  end { If }
  else
    OutOfMemoryError;
end;

procedure TVRWClipboardWriter.Write(Control: IVRWControl);
var
  Properties: TVRWControlProperties;
  ImageSize: Integer;
begin
  Properties := Control.GetProperties;
  Stream.Write(Properties, SizeOf(Properties));
  if Supports(Control, IVRWImageControl) then
  begin
    ImageSize := (Control as IVRWImageControl).vcBMPStore.iBMPSize;
    Stream.Write(ImageSize, SizeOf(ImageSize));
    Stream.CopyFrom((Control as IVRWImageControl).vcImageStream, ImageSize);
  end;
end;

function TVRWClipboardManager.CanPaste: Boolean;
begin
  Result := Clipboard.HasFormat(CF_VRWCONTROL_PROPERTIES);
end;

initialization

  CF_VRWCONTROL_PROPERTIES := RegisterClipboardFormat('CF_VRWCONTROL_PROPERTIES');

end.
