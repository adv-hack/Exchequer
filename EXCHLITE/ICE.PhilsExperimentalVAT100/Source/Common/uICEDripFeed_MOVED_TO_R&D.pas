unit uICEDripFeed;

interface

uses SysUtils, Classes,
  // Exchequer units
  GlobVar,
  GmXML,
  EntLicence
  ;

{
  TICEDripFeed provides access to the Drip Feed details stored for the
  current company.

  There is a GetDripFeed function which returns an instance of TICEDripFeed
  loaded with the information for the current company. See the comments
  accompanying this function for more details.
}

type
  TICEDripFeed = class(TObject)
  private
    FIsActive: Boolean;
    FStartYear: Byte;
    FStartPeriod: Byte;
    FEndYear: Byte;
    FEndPeriod: Byte;
    FErrorMessage: string;
    FErrorCode: Byte;
    FDatapath: string;
    FVersionCode: Integer;
    FIAOEdition: TelProductType;
    FUseCompression: Boolean;
    function GetIsValid: Boolean;
    procedure SetDatapath(const Value: string);
    function GetIsValidForSaving: Boolean;
    procedure Write(XML: TgmXML; WithCompression: Boolean = True);
  public
    { Constructor for the TICEDripFeed object -- sets up the default parameters,
      and attempts to open and read the drip-feed file, if it exists. }
    constructor Create;

    { FileVersion returns the version number of the specified drip-feed
      information file, in single-number format (e.g. v1.00 is returned
      as 100). Returns -1 if the file is not a valid drip-feed file. }
    function FileVersion(Filespec: string): Integer;

    { Load will open the drip-feed information file and read the details from
      it. It assumes that the file has already been validated using IsValid,
      so it does not check the validity of the path or file. If the load fails,
      this function will return False -- check the ErrorCode and ErrorMessage
      for more details. }
    function Load: Boolean;

    { Save stores the current details into the drip-feed information file. It
      assumes that the file has already been validated using IsValidForSaving,
      so it does not check the validity of the path or file. If the save fails,
      this function will return False -- check the ErrorCode and ErrorMessage
      for more details. }
    function Save: Boolean;

    { ErrorMessage holds a description of the last error found, if any, when
      checking the status of this object. It is set/cleared by GetIsValid and
      GetIsValidForSaving. }
    property ErrorMessage: string read FErrorMessage;

    { ErrorCode holds an identifying code for the last error found, if any,
      when checking the status of this object. It is set by GetIsValid and
      GetIsValidForSaving. }
    property ErrorCode: Byte read FErrorCode;

    { IsActive is True if the company is currently in drip-feed mode. }
    property IsActive: Boolean read FIsActive write FIsActive;

    { IsValid holds True if the current status of this object is valid -- i.e.,
      it has a datapath set, and the datapath points to a valid directory which
      holds a valid DripFeed information file. If IsValid returns False,
      the ErrorCode property will identify the type of problem found (see the
      ERR_DF_ constants), and the ErrorMessage property will hold a description
      of the problem. }
    property IsValid: Boolean read GetIsValid;

    { IsValidForSaving holds true if the TICEDripFeed object has sufficient
      information for saving the details to the drip-feed file, and the
      ICS directory exists. }
    property IsValidForSaving: Boolean read GetIsValidForSaving;

    { StartYear, StartPeriod, EndYear, and EndPeriod indicate the period range
      which is covered by the drip-feed mode. Only transactions within this
      range will be considered for drip-feed export. }
    property StartYear: Byte read FStartYear write FStartYear;
    property StartPeriod: Byte read FStartPeriod write FStartPeriod;
    property EndYear: Byte read FEndYear write FEndYear;
    property EndPeriod: Byte read FEndPeriod write FEndPeriod;

    { Datapath is the path to the ICS folder for the company, which holds the
      client-sync files. By default this is the company path + 'ICS'. }
    property Datapath: string read FDatapath write SetDatapath;

    { VersionCode holds the version number of the drip-feed file, in single-
      number format (e.g. v1.00 is held as 100). }
    property VersionCode: Integer read FVersionCode;

    { IAOEdition holds the IAO Edition identifier that the drip-feed file
      was created under. }
    property IAOEdition: TelProductType read FIAOEdition write FIAOEdition;

    { UseCompression determines whether or not the drip-feed file should be
      compressed when it is saved. By default this is True -- it should only
      be set to False for debugging purposes (note that when reading the
      drip-feed file, it is always assumed to be compressed). }
    property UseCompression: Boolean read FUseCompression write FUseCompression;

  end;
  EICEDripFeed = class(Exception)
  end;

const
  { Error codes }
  ERR_DF_OK               = 0;    // All ok
  ERR_DF_NO_DATAPATH      = 1;    // ICE Data path not specified
  ERR_DF_INVALID_DATAPATH = 2;    // ICE Data path not found
  ERR_DF_NO_FILE          = 3;    // Drip-feed file not found
  ERR_DF_INVALID_FILE     = 4;    // Drip-feed file is invalid
  ERR_DF_LOAD_FAILED      = 5;    // Failed to read drip-feed file
  ERR_DF_SAVE_FAILED      = 6;    // Failed to save drip-feed file

  { Drip-feed file name }
  DRIPFEED_FILE = 'DRIPFEED.DAT';

  { Version string -- stored at the start of the file for identification. The
    first bytes of the file indicate the version number (100 = v1.00), the
    other bytes are a random identifier (actually, 'I','C','E', but with 100
    added to each character). }
  VER_NUMBER  = 100;
  VER_FILE_ID = #173#167#183;

{ ----------------------------------------------------------------------------
  GetDripFeed:

  Returns an instance of the TICEDripFeed class, loaded with the information
  for the current company.

  The IsActive property will indicate whether the company is in drip-feed mode
  or not.

  The ErrorCode property should be checked for the following errors:

  ERR_DF_NO_DATAPATH : the Company datapath could not be obtained from SetDrive.
  ERR_DF_INVALID_FILE: a Drip-Feed file was found, but was invalid or corrupt.
  ERR_DF_LOAD_FAILED : a Drip-Feed file was found, but could not be loaded.

  Other non-zero error codes simply indicate that the company either does not
  have the client-sync installed, or that they have not yet done the bulk export
  and therefore drip-feed mode has not been set up. In these cases, IsActive
  will always be False.

  If IsActive is True, the period range information will be found in the
  StartYear, StartPeriod, EndYear, and EndPeriod properties.

  Note that a new instance is returned for every call to GetDripFeed (it is
  not returning a singleton), so these must be freed after use.
  ---------------------------------------------------------------------------- }

function GetDripFeed: TICEDripFeed;

implementation

uses ZLib, Forms, DateUtils;

function GetDripFeed: TICEDripFeed;
begin
  Result := TICEDripFeed.Create;
end;

procedure ExpandStream(inpStream, outStream: TStream);
{ Uses ZLib to uncompress the data from inpStream, outputting the uncompressed
  results in outStream. Used by the TIceDripFeed.Load routine. }
var
  InpBuf,OutBuf: Pointer;
  OutBytes,sz: integer;
begin
  InpBuf := nil;
  OutBuf := nil;
  sz := inpStream.size-inpStream.Position;
  if sz > 0 then try
    GetMem(InpBuf,sz);
    inpStream.Read(InpBuf^,sz);
    DecompressBuf(InpBuf,sz,0,OutBuf,OutBytes);
    outStream.Write(OutBuf^,OutBytes);
  finally
    if InpBuf <> nil then FreeMem(InpBuf);
    if OutBuf <> nil then FreeMem(OutBuf);
  end;
  outStream.Position := 0;
end;

// ============================================================================
// TICEDripFeed
// ============================================================================

constructor TICEDripFeed.Create;
begin
  inherited Create;
  { Set the current version number. }
  FVersionCode := VER_NUMBER;
  { Set the default file-compression state }
  FUseCompression := True;
  { Read the product type (Exchequer / IAO Client / IAO Practice) }
  FIAOEdition := EnterpriseLicence.elProductType;
  { Default IsActive to False }
  FIsActive := False;
  { Set the default ICE path. The IAO installer will have created this path. If
    it does not exist, it will be assumed that the Client-Sync is not being
    used by the current company. }
  if (SetDrive <> '') then
  begin
    Datapath := IncludeTrailingPathDelimiter(SetDrive) + 'ICS\';
    if IsValid then
      Load;
  end
  else
    FDatapath := '';
end;

// ----------------------------------------------------------------------------

function TICEDripFeed.FileVersion(Filespec: string): Integer;
var
  FileIn: TFileStream;
  Buffer: array[0..Length(VER_FILE_ID) - 1] of Char;
  VersionCode: Integer;
begin
  FileIn := TFileStream.Create(Filespec, fmOpenRead, fmShareDenyNone);
  try
    { Read the version }
    FileIn.Read(VersionCode, SizeOf(VersionCode));
    { Read the first chunk of the file after the version byte -- this should
      hold the identifier }
    FileIn.Read(Buffer, Length(Buffer));
    { Check the file identifier bytes }
    if (Buffer = VER_FILE_ID) then
      { Ok -- valid file, return the version number }
      Result := VersionCode
    else
      { Invalid file }
      Result := -1;
  finally
    FileIn.Free;
  end;
end;

// ----------------------------------------------------------------------------

function TICEDripFeed.GetIsValid: Boolean;
begin
  FErrorMessage := '';
  FErrorCode    := ERR_DF_OK;
  { IsValidForSaving checks the minimum requirements. If it is successful,
    we can check the other validation requirements. }
  if IsValidForSaving then
  begin
    { Drip-feed file must exist in ICS directory }
    if not FileExists(Datapath + DRIPFEED_FILE) then
    begin
      FErrorCode    := ERR_DF_NO_FILE;
      FErrorMessage := 'Drip-feed file not found in ' + Datapath;
    end
    { First few bytes of the drip-feed file must match the file identifier }
    else if FileVersion(Datapath + DRIPFEED_FILE) = -1 then
    begin
      FErrorCode    := ERR_DF_INVALID_FILE;
      FErrorMessage := 'Drip-feed file invalid or corrupt in ' + Datapath;
    end;
  end;
  Result := (FErrorCode = ERR_DF_OK);
end;

// ----------------------------------------------------------------------------

function TICEDripFeed.GetIsValidForSaving: Boolean;
begin
  FErrorMessage := '';
  FErrorCode    := ERR_DF_OK;
  { Datapath must be specified }
  if (Datapath = '') then
  begin
    FErrorCode    := ERR_DF_NO_DATAPATH;
    FErrorMessage := 'No drip-feed directory specified';
  end
  { ICS directory must exist }
  else if not DirectoryExists(Datapath) then
  begin
    FErrorCode    := ERR_DF_INVALID_DATAPATH;
    FErrorMessage := 'Drip-feed directory "' + Datapath + '" not found';
  end;
  Result := (FErrorCode = ERR_DF_OK);
end;

// ----------------------------------------------------------------------------

function TICEDripFeed.Load: Boolean;
var
  XML: TgmXML;
  InputStream: TFileStream;
  ResultStream: TMemoryStream;
  Node: TGmXmlNode;
  Version: array[0..Length(VER_FILE_ID) - 1] of Byte;
  isOpen: Boolean;
  StartTime: TDateTime;
const
  RETRY_TIME = 5000;  // 5000 milliseconds (5 seconds).
begin
  ResultStream := nil;
  isOpen := False;
  StartTime := Now;
  Result := True;
  while not isOpen do
  begin
    try
      { Try to open the drip-feed file }
      InputStream := TFileStream.Create(Datapath + DRIPFEED_FILE, fmOpenRead, fmShareDenyNone);
      isOpen := True;
    except
      { If the open fails, this could be because the file is currently being
        written to, so we will retry for a few seconds. }
      on EFOpenError do
      begin
        Application.ProcessMessages;
        if (MilliSecondsBetween(Now, StartTime) > RETRY_TIME) then
        begin
          Result := False;
          FErrorCode    := ERR_DF_LOAD_FAILED;
          FErrorMessage := 'Failed to open file';
          Exit;
        end;
      end;
    end;
  end;
  XML := TgmXML.Create(nil);
  try
    { Read the version code }
    InputStream.Read(FVersionCode, SizeOf(FVersionCode));
    { Step over the file identifier (IsValid will already have checked that
      it is valid) }
    InputStream.Read(Version, Length(VER_FILE_ID));
    { Expand the compressed file into ResultStream }
    ResultStream := TMemoryStream.Create;
    ExpandStream(InputStream, ResultStream);
    { Read the uncompressed XML data from ResultStream }
    ResultStream.Position := 0;
    XML.LoadFromStream(ResultStream);
    { Parse the XML file, extracting the drip-feed details from it }
    Node := XML.Nodes.Root;
    FIsActive    := Node.Children.NodeByName['isactive'].AsBoolean;
    FStartYear   := Node.Children.NodeByName['startyear'].AsInteger;
    FStartPeriod := Node.Children.NodeByName['startperiod'].AsInteger;
    FEndYear     := Node.Children.NodeByName['endyear'].AsInteger;
    FEndPeriod   := Node.Children.NodeByName['endperiod'].AsInteger;
    FIAOEdition  := TelProductType(Node.Children.NodeByName['iaoedition'].AsInteger);
  finally
    if Assigned(ResultStream) then
      ResultStream.Free;
    InputStream.Free;
    XML.Free;
  end;
end;

// ----------------------------------------------------------------------------

function TICEDripFeed.Save: Boolean;
{
  XML format:

    <dripfeed>
      <isactive/>
      <iaoedition/>
      <startyear/>
      <startperiod/>
      <endyear/>
      <endperiod/>
    </dripfeed>
}
var
  XML: TgmXML;
begin
  { Write the details to XML }
  Result := False;
  XML := TgmXML.Create(nil);
  try
    try
      XML.Encoding := 'ISO-8859-1';
      XML.Nodes.AddOpenTag('dripfeed');
      XML.Nodes.AddLeaf('isactive').AsBoolean    := FIsActive;
      XML.Nodes.AddLeaf('iaoedition').AsInteger  := Ord(FIAOEdition);
      XML.Nodes.AddLeaf('startyear').AsInteger   := FStartYear;
      XML.Nodes.AddLeaf('startperiod').AsInteger := FStartPeriod;
      XML.Nodes.AddLeaf('endyear').AsInteger     := FEndYear;
      XML.Nodes.AddLeaf('endperiod').AsInteger   := FEndPeriod;
      XML.Nodes.AddCloseTag;
      { Save the XML to file }
      FErrorCode := 0;
      Write(XML, UseCompression);
      Result := (FErrorCode = 0);
    except
      on E:Exception do
      begin
        FErrorCode    := ERR_DF_SAVE_FAILED;
        FErrorMessage := 'Could not create drip-feed file "' +
                         Datapath + DRIPFEED_FILE + '" : ' +
                         E.Message;
      end;
    end;
  finally
    XML.Free;
  end;
end;

// ----------------------------------------------------------------------------

procedure TICEDripFeed.SetDatapath(const Value: string);
begin
  FDatapath := IncludeTrailingPathDelimiter(Value);
  { If possible, load any existing file }
  if IsValid then
    Load
  else
    FIsActive := False;
end;

// ----------------------------------------------------------------------------

procedure TICEDripFeed.Write(XML: TgmXML; WithCompression: Boolean);
var
  Stream: TFileStream;
  CompressionStream: TCompressionStream;
begin
  CompressionStream := nil;
  try
    Stream := TFileStream.Create(Datapath + DRIPFEED_FILE, fmCreate or fmShareExclusive);
    try
      { Write the version number }
      Stream.Write(VersionCode, SizeOf(VersionCode));
      { Write the file identifier }
      Stream.Write(VER_FILE_ID, Length(VER_FILE_ID));
      if WithCompression then
      begin
        { Write the XML, compressed }
        CompressionStream := TCompressionStream.Create(clDefault, Stream);
        XML.SaveToStream(CompressionStream);
      end
      else
      begin
        { Write the XML, uncompressed }
        XML.SaveToStream(Stream);
      end;
    finally
      if Assigned(CompressionStream) then
        CompressionStream.Free;
      Stream.Free;
    end;
  except
    on E:Exception do
    begin
      FErrorCode    := ERR_DF_SAVE_FAILED;
      FErrorMessage := 'Could not create drip-feed file "' +
                       Datapath + DRIPFEED_FILE + '" : ' +
                       E.Message;
    end;
  end;
end;

// ----------------------------------------------------------------------------

end.
