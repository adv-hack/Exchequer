unit FileProcess;

interface

uses
  SysUtils,
  StrUtils,
  Classes,
  XMLDoc,
  XMLIntf,
  ActiveX,
  EncdDecd,
  Wcrypt2,
  crypto,
  globals,
  GmXML,ExchConnect;

const
  kStr = '!siri@eimw'; // This has been reversed to prevent casual hacking
  
type
  TLoginFileProcessor = class
  private
    // Input data
    xmlFile      : string;
    protocol     : string;
    overrideDefault : boolean;

    theKey       : string;

    // Connection string
    encConnStr   : string;
    connStr      : string;
    expConnStr : TStringList; // separated into fields

    // Extracted data
    dataSource   : string;
    currProtocol : string;
    dataSourceIndex : integer;

    logFilename : string;
    logFile     : TextFile;

    // Default
    defaultProtocol : string; // Must prevail unless override is set
  public
    destructor Destroy; override;
    function  ParseCommandLine : boolean;
    function  ReadConfigFile : boolean;
    procedure DecodeConnectionString;
    procedure ExplodeConnectionString;
    procedure ExtractDataSource;
    procedure ExtractCurrentProtocol;
    procedure ReadProtocolFile;
    procedure UpdateDefaultProtocol;
    procedure ReassembleConnectionString;
    procedure EncryptConnectionString;
    procedure SaveConnectionString;
    procedure SaveDefaultProtocol;
    function  TestConnectionString : Boolean;

    procedure SetFilename(aFilename : string);
    procedure SetTargetProtocol(aProtocol : string);
    function  GetConnectionString : string;
    procedure SetConnectionString(aString : string);
    procedure SetDefaultProtocol(aProtocol : string);
    procedure CreateLogFile(path : string);
    procedure LogMessage(aMsg : string);

    property EncodedConnectionString : string read encConnStr write encConnStr;
    property ConnectionString : string read connStr write connStr;
    property DecodeKey : string read thekey write theKey;
  end;

implementation

uses
  ADODB;

//------------------------------------------------------------------------------
destructor TLoginFileProcessor.Destroy;
begin
  inherited;
end;

//------------------------------------------------------------------------------
function TLoginFileProcessor.ParseCommandLine : boolean;
var
  index : integer;
begin
  Result := true;
  for index := 0 to ParamCount do
  begin
    if Pos('/f:', ParamStr(index)) > 0 then
    begin
      // Found the filename, so extract it
      xmlFile := Copy(ParamStr(index), 4, length(ParamStr(index))-3);
      if not FileExists(xmlFile) then
      begin
        Result := false;
      end;
    end;

    if Pos('/p:', ParamStr(index)) > 0 then
    begin
      // Found the protocol
      protocol := Copy(ParamStr(index), 4, length(ParamStr(index))-3);
      if Pos(':', protocol) <= 0 then
        protocol := protocol + ':';

      if (protocol <> 'tcp:') and (protocol <> 'np:') then
        Result := false;
    end;

    if Pos('/o', ParamStr(index)) > 0 then
    begin
      // Found the override switch
      overrideDefault := true;
    end;
  end;

  CreateLogFile(ExtractFilePath(xmlFile));
      
  if (Trim(protocol) = '') then
    LogMessage('No protocol specified');

  if (Trim(xmlFile) = '') then
    LogMessage('No Login XML file specified');

  if not FileExists(xmlFile) then
    LogMessage('Specified XML file, ' + xmlFile + ', does not exist');
end;

//------------------------------------------------------------------------------
procedure TLoginFileProcessor.CreateLogFile(path : string);
begin
  if path <> '' then
  begin
    ForceDirectories(path + 'LOGS');
    logFilename := path + 'LOGS\SQLString.log'
  end
  else
  begin
    ForceDirectories('LOGS');
    logFilename := 'LOGS\SQLString.log';
  end;
end;

//------------------------------------------------------------------------------
// Read the Configuration file
function TLoginFileProcessor.ReadConfigFile : Boolean;
var
  XML            : TGMXML;
  RootNode, Node : TgmXMLNode;
  iNode          : Integer;
begin
  Result := true;
  
  encConnStr := '';
  if FileExists(xmlFile) then
  begin
    try
      XML := TGMXML.Create(nil);
      try
        XML.LoadFromFile(xmlFile);
        RootNode := XML.Nodes.Root;
        if (Lowercase(RootNode.Name) = 'login') then
        begin
          for iNode := 0 to RootNode.Children.Count - 1 do
          begin
            Node := RootNode.Children.Node[iNode];
            if (Lowercase(Node.Name) = 'connection') then
            begin
              encConnStr := Node.AsString;
              // Remove any carriage returns that might have crept in
              encConnStr := StringReplace(encConnStr, chr(10), '', [rfReplaceAll]);
              encConnStr := StringReplace(encConnStr, chr(13), '', [rfReplaceAll]);
              break;
            end;
          end;
        end;
      finally
        // Make sure the object is freed
        XML.Free;
      end;
    except
      // An exception occurred reading the XML file
      Result := false;
      LogMessage('Error reading XML file, ' + xmlFile);
    end;
  end;
end;


//------------------------------------------------------------------------------
// Decode and Decrypt the Connection String
procedure TLoginFileProcessor.DecodeConnectionString;
var
  decStr : string;
  buffer : array of Byte;
  index  : integer;
  bLen   : integer;
  aStr   : string; // encrypt/decrypt key
begin
  // Base64 decode the encoded connection string  
  decStr := DecodeString(encConnStr);

  // Get the length of the resulting buffer
  bLen := Length(decStr);
  SetLength(buffer, bLen);

  // Convert the string to a byte array
  for index := 0 to bLen-1 do
  begin
    buffer[index] := byte(decStr[index+1]);
  end;
  
  // Decrypt the encrypted connection string
  if DecodeKey = '' then
    DecodeKey := ReverseString(kStr);

  aStr := DecodeKey;
  CryptText(buffer, aStr, false); // (false = decrypt)

  // Convert the buffer back to a string
  decStr := '';
  for index := 0 to Length(buffer)-1 do
  begin
    decStr := decStr + chr(buffer[index]);
  end;

  connStr := decStr;
end;

//------------------------------------------------------------------------------
// Explode the connection string
procedure TLoginFileProcessor.ExplodeConnectionString;
var
  index : integer;
begin
  if expConnStr = nil then
  begin
    expConnStr := TStringList.Create;
  end;
  // Temporarily replace the spaces as we only want to explode on ';'
  // and the TStringList Delimiter includes space as well.  (This is fixed in
  // later versions of Delphi, with the StrictDelimiter property)
  connStr := StringReplace(connStr, ' ', '####', [rfReplaceAll]);

  expConnStr.Delimiter := ';';
  expConnStr.DelimitedText := connStr;

  // Change the spaces back
  for index := 0 to expConnStr.Count-1 do
  begin
    expConnStr[index] := StringReplace(expConnStr[index], '####', ' ', [rfReplaceAll]);
  end;
end;

//------------------------------------------------------------------------------
// Get the Data Source element
procedure TLoginFileProcessor.ExtractDataSource;
var
  index : integer;
  ePos  : integer;
begin
  for index := 0 to expConnStr.Count-1 do
  begin
    if Pos('data source', Lowercase(expConnStr[index])) > 0 then
    begin
      // Found the Data Source
      ePos := Pos('=', expConnStr[index]);
      dataSource := Copy(expConnStr[index], ePos+1, Length(expConnStr[index])-ePos);
      dataSourceIndex := index;
      break;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Get the Data Source protocol
procedure TLoginFileProcessor.ExtractCurrentProtocol;
var
  cPos : integer;
begin
  cPos := Pos(':', dataSource);
  if cPos > 0 then
  begin
    // Found a colon, so it must follow a protocol (tcp: or np:)
    currProtocol := Copy(dataSource, 1, cPos);
    dataSource   := StringReplace(dataSource, currProtocol, '', []);
  end;
end;

//------------------------------------------------------------------------------
// Read the Default Protocol
procedure TLoginFileProcessor.ReadProtocolFile;
(*
<ExchequerSQLSettings>
	<Protocol>tcp:</Protocol>
</ExchequerSQLSettings>
*)
var
  XML: TGMXML;
  RootNode, Node: TgmXMLNode;
  iNode: Integer;
  filename : string;
begin
  defaultProtocol := '';

  // If the file doesn't exist, it doesn't matter.  If it does, then process it.
  if fileExists(filename) then
  begin
    try
      XML := TGMXML.Create(nil);
      try
        filename := ExtractFilePath(xmlFile) + 'ExchSQLSettings.xml';
        if fileExists(filename) then
        begin
          XML.LoadFromFile(filename);
          RootNode := XML.Nodes.Root;
          if (Lowercase(RootNode.Name) = 'exchequersqlsettings') then
          begin
            for iNode := 0 to RootNode.Children.Count - 1 do
            begin
              Node := RootNode.Children.Node[iNode];
              if (Lowercase(Node.Name) = 'protocol') then
              begin
                  defaultProtocol := Node.AsString;
                break;
              end;
            end;
          end;
        end;
      finally
        XML.Free;
      end;
    except
      // An exception occurred reading the XML file
      LogMessage('Error reading XML file, ' + filename);
    end;
  end;
end;


//------------------------------------------------------------------------------
// If the Default is set, then use it
procedure TLoginFileProcessor.UpdateDefaultProtocol;
begin
  if defaultProtocol = '' then
  begin
    defaultProtocol := protocol;
  end
  else
  begin
    // We have a default protocol, so we only override it if the switch was set
    if overrideDefault then
    begin
      defaultProtocol := protocol;
    end;
  end;
  expConnStr[dataSourceIndex] := 'Data Source=' + defaultProtocol + dataSource;
end;

//------------------------------------------------------------------------------
// Reassemble the Connection String
procedure TLoginFileProcessor.ReassembleConnectionString;
var
  index : integer;
  lCount : integer;
begin
  connStr := '';
  lCount := expConnStr.Count;
  for index := 0 to lCount - 1 do
  begin
    connStr := connStr + expConnStr[index];
    if index < (lCount - 1) then
      connStr := connStr + ';'
  end;
end;

//------------------------------------------------------------------------------
// Encrypt and Encode the Connection string
procedure TLoginFileProcessor.EncryptConnectionString;
var
  buffer : array of Byte;
  index  : integer;
  bLen   : integer;
  eConnStr : string;
  aStr     : string; // encrypt/decrypt key
begin
  blen := Length(connStr);
  Setlength(buffer, bLen);

  for index := 0 to bLen-1 do
    buffer[index] := byte(connStr[index+1]);

  if DecodeKey = '' then
    DecodeKey := ReverseString(kStr);
  aStr := DecodeKey;
  CryptText(buffer, aStr, true);

  eConnStr := '';
  for index := 0 to blen-1 do
  begin
    eConnStr := eConnStr + chr(buffer[index]);
  end;
  
  // Encode it to Base64
  encConnStr := EncodeString(eConnStr);
end;

//------------------------------------------------------------------------------
// Save the Connection String back to the file
procedure TLoginFileProcessor.SaveConnectionString;
var
  XML            : TGMXML;
begin
  try
    XML := TGMXML.Create(nil);
    try
      with XML.Nodes do
      begin
        AddOpenTag('login');
        AddLeaf('connection').AsString := encConnStr;
        AddCloseTag;
      end;

      XML.SaveToFile(xmlFile);
    finally
      XML.Free;
    end;
  except
    // An exception occurred creating or saving the XML file
    LogMessage('Error creating XML file, ' + xmlFile);
  end;
end;


//------------------------------------------------------------------------------
// Save the Connection String back to the file
procedure TLoginFileProcessor.SaveDefaultProtocol;
var
  XML            : TGMXML;
begin
  try
    XML := TGMXML.Create(nil);
    try
      with XML.Nodes do
      begin
        AddOpenTag('ExchequerSQLSettings');
        AddLeaf('Protocol').AsString := defaultProtocol;
        AddCloseTag;
      end;

      XML.SaveToFile(ExtractFilePath(xmlFile) + 'ExchSQLSettings.xml');
    finally
      XML.Free;
    end;
  except
    // An exception occurred creating or saving the XML file
    LogMessage('Error creating XML file, ' + xmlFile);
  end;
end;


//------------------------------------------------------------------------------
// Test the connection to verify that it works.
function TLoginFileProcessor.TestConnectionString : Boolean;
var
  ADOConn  : TExchConnection;
begin
  Result := true;
  
  CoInitialize(nil);
  ADOConn := TExchConnection.Create(nil);   //VA:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  try
    // Set the connection string
    ADOConn.ConnectionString := connStr;
    
    // Disable the login prompt
    ADOConn.LoginPrompt := False;

    // Try to open the connection
    ADOConn.Open;

    ADOConn.Close;
  except
    on e: EADOError do
    begin
      // Didn't work.
      Result := false;
      LogMessage('Database error:');
      LogMessage(e.Message);
    end
  else
    begin
      Result := false;
      LogMessage('Connection failed using : ' + connStr);
    end;
  end;
  
  ADOConn.Free;
  CoUninitialize;
end;

//------------------------------------------------------------------------------
procedure TLoginFileProcessor.SetFilename(aFilename : string);
begin
  xmlFile := aFilename;
end;

//------------------------------------------------------------------------------
procedure TLoginFileProcessor.SetTargetProtocol(aProtocol : string);
begin
  protocol := aProtocol;
end;

//------------------------------------------------------------------------------
procedure TLoginFileProcessor.SetDefaultProtocol(aProtocol : string);
begin
  defaultProtocol := aProtocol;
end;

//------------------------------------------------------------------------------
function TLoginFileProcessor.GetConnectionString : string;
begin
  Result := connStr;
end;

//------------------------------------------------------------------------------
procedure TLoginFileProcessor.SetConnectionString(aString : string);
begin
  connStr := aString;
end;

//------------------------------------------------------------------------------
procedure TLoginFileProcessor.LogMessage(aMsg : string);
var
  msgStr : string;
begin
  AssignFile(logFile, logFilename);
  if fileExists(logFilename) then
  begin
    Append(logFile);
  end
  else
  begin
    Rewrite(logFile);
  end;

  msgStr := Format('%s : %s', [DateTimeToStr(Now), aMsg]);
  
  writeln(logFile, msgStr);
  flush(logFile);
  CloseFile(logFile);
end;

end.
