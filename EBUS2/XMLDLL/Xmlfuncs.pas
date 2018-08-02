unit XMLFUNCS;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, Forms;
  
type
  xmlInitInfoType = record
    xiDataPath    : string[255]; // Path to enterprise data
    xiCcyVer      : smallint;    // Currency Version: 0=Prof,1=Euro,2=Global
    xiSpare       : array [1..500] Of char;
  end; // xmlInitInfoType

  xmlXMLInfoType = record
    xtSaveDir     : string[255]; // Path to write XML document to
    xtXSLLocation : string[255]; // XSL URL to embed within XML document
    xtOurRef      : string[10];
    xtSpare       : array [1..500] of char;
  end; // xmlXMLInfoType

  xmlHTMLInfoType = record
    xtLoadDir      : string[255]; // Path and name of XML file to process
    xtSaveDir      : string[255]; // Path to write HTML document to
    xtXSLLocation  : string[255]; // XSL location to read to convert XML to HTML
    xtSpare        : array [1..500] of char;
  end; // xmlHTMInfoType

  xmlXMLExportInfoType = record
    xeSaveFileName : string[255]; // Path and file name to write XML document to
    xeOurRefList   : TStrings;    // List of OurRefs for exporting outstanding orders etc.
    xeSpare        : array [1..500] of char;
  end; // xmlXMLExportInfoType

{$IFDEF USEDLL}
  // Link via the DLL i.e. when using the DLL
  function xmlInitDLL(var InitInfo : xmlInitInfoType) : smallint; stdcall; external 'ENTXML.DLL';
  function xmlCloseDLL : SmallInt;  stdcall; external 'ENTXML.DLL';
  function xmlCreateXMLFile(var XMLInfo : xmlXMLInfoType) : smallint; stdcall; external 'ENTXML.DLL';
  function xmlCreateHTMFile(var InitInfo : xmlInitInfoType;
                            var HTMLInfo : xmlHTMLInfoType) : smallint; Stdcall; external 'ENTXML.DLL';
  function xmlCreateExport(var XMLExportInfo : xmlXMLExportInfoType) : smallint; stdcall; external 'ENTXML.DLL';
{$ELSE}
  // Compile in direct e.g. when building DLL
  function xmlInitDLL(var InitInfo : xmlInitInfoType) : smallint; stdcall;
  function xmlCloseDLL : smallint;  stdcall;
  function xmlCreateXMLFile(var XMLInfo : xmlXMLInfoType) : smallint;  stdcall;

  function xmlCreateHTMFile(var InitInfo : xmlInitInfoType;
                            var HTMLInfo : xmlHTMLInfoType) : smallint; stdcall;

  function xmlCreateExport(var XMLExportInfo : xmlXMLExportInfoType) : smallint; stdcall;
{$ENDIF}

implementation

{$IFNDEF USEDLL}

uses
  Dialogs, SysUtils, UseDLLU, FileCtrl, XMLTrans, XMLOrd, XMLInv, MSXML_TLB,
  XMLUtil, Crypto, EBusUtil, EBusVar, ActiveX, StrUtil, Windows;

  {$I Exdllbt.inc}
  {$I Exchdll.inc}

const
  STATUS_NOT_IMPLEMENTED = -1;
  STATUS_OK = 0;
  STATUS_INVALID_OUTPUT_DIR = 1;
  STATUS_INVALID_TRANS_TYPE = 2;
  STATUS_TOOLKIT_ERROR = 3;
  STATUS_INVALID_OUTPUT_FILE = 4;
  STATUS_NO_TRANSACTIONS = 5;

var
  CompanyDataPath : string; // Path to enterprise data

 _UseBasda309 : function : Boolean;

//-----------------------------------------------------------------------------------

function xmlInitDLL(var InitInfo : xmlInitInfoType) : smallInt;
const
  CODE = #61 + #242 + #152 + #185 + #179 + #168 + #169 + #179 + #245 + #48 + #173;
var
  MultiCurrency : boolean;
  DataDir : array[0..255] of char;
  pCode : array[0..255] of char;
  hSysSetupDLL : THandle;
begin
  with InitInfo do
  begin
    MultiCurrency := xiCcyVer <> 0;
    StrPCopy(DataDir, IncludeTrailingBackSlash(xiDataPath));
    CompanyDataPath := DataDir;
    ChangeCryptoKey(720605);
    StrPCopy(pCode, Decode(CODE));
    Ex_SetReleaseCode(pCode);

    Result := Ex_InitDLLPath(DataDir, MultiCurrency);
    if Result = 0 then
      Result := Ex_InitDLL;
  end; // with

  If (Result<>0) then
    ShowMessage('xmlInitDLL failed, report error '+InttoStr(Result))
  else
  begin
    hSysSetupDLL := LoadLibrary('eBusSet.dll');
    if hSysSetupDLL > HInstance_Error then
    Try
       _UseBasda309 := GetProcAddress(hSysSetupDLL, 'UseBasda309');
      if Assigned(_UseBasda309) then
        bUseBasda309 := _UseBasda309;
    Finally
      FreeLibrary(hSysSetupDLL);
    End;
  end;
end; // xmlInitDLL

//-----------------------------------------------------------------------------------

function xmlCloseDLL : SmallInt;
begin
  // Was Ex_CloseDLL
  Result := Ex_CloseData;
end;

//-----------------------------------------------------------------------------------

function xmlCreateXMLFile(var XMLInfo : xmlXMLInfoType) : SmallInt;
var
  XmlTrans : TWriteXMLTransaction;
  TransType : string[3];

  function CheckParams : integer;
  const
    MAX_VALID_TRANS = 5;
    VALID_TRANS : array[1..MAX_VALID_TRANS] of string = ('POR', 'SIN', 'SOR', 'PIN', 'SCR');
  var
    Found : boolean;
    i : integer;
  begin
    with XMLInfo do
    begin
      Result := STATUS_OK;
      if Trim(xtSaveDir) <> '' then
      begin // Blank save directory OK i.e. current directory
        xtSaveDir := IncludeTrailingBackSlash(ExtractFilePath(xtSaveDir));
        // Check output directory exists
        if not DirectoryExists(xtSaveDir) then
          Result := STATUS_INVALID_OUTPUT_DIR;
      end;

      if Result = STATUS_OK then
      begin // Check valid transaction type
        Found := false;
        i := 1;
        while (i <= MAX_VALID_TRANS) and not Found do
        begin
          Found := Found or (TransType = VALID_TRANS[i]);
          inc(i);
        end;
        if not Found then
          Result := STATUS_INVALID_TRANS_TYPE;
      end;
    end;
  end;

begin
  TransType := UpperCase(copy(XMLInfo.xtOurRef,1,3));
  Result := CheckParams;
  if Result <> 0 then exit;

  if (TransType  = 'POR') or (TransType = 'SOR') then
  begin
    XmlTrans := TWriteXMLOrder.Create;
    // To have hard coded style sheets uncomment following line
    XMLTrans.XSLLocation := 'xml-stylesheet type="text/xsl" href="excheqr.xsl"';
  end
  else
  begin
    XmlTrans := TWriteXMLInvoice.Create;
    // To have hard coded style sheets uncomment following line
    XMLTrans.XSLLocation := 'xml-stylesheet type="text/xsl" href="excheqr.xsl"';
  end;

  with XMlTrans, XMLInfo do
    try
      try
        // To have hard coded style sheets comment following line
        // XSLLocation := xtXSLLocation;
        DataPath := CompanyDataPath;
        CreateXML(xtOurRef);
        // e.g. POR001234 -> PO001234.XML i.e. 8.3 file name
        xtSaveDir := xtSaveDir + copy(xtOurRef,1,2) + copy(xtOurRef,4,6) + '.XML';
        SaveToFile(xtSaveDir, true);
      except
        on E:Exception do
          begin
            ShowMessage(E.Message);
            Result := STATUS_TOOLKIT_ERROR;
          end;
      end;
    finally
      Free;
    end;
end;

//-----------------------------------------------------------------------------------

function xmlCreateHTMFile(var InitInfo : xmlInitInfoType;
                          var HTMLInfo : xmlHTMLInfoType) : smallint;
// Pre  : HTMLInfo.xtSaveDir = Path to write generated HTML file to
// Post : HTMLInfo.xtSaveDir = Path and file name of generated HTML file
var
  XmlDoc,
  StyleSheet,
  HTMLOutput : IXMLDOMDocument;
begin
  try
    with HTMLInfo do
    begin
      CompanyDataPath := IncludeTrailingBackSlash(InitInfo.xiDataPath);

      Result := STATUS_OK;
      LoadXMLDocument(xtLoadDir, XmlDoc);
      StyleSheet := CoDOMDocument.Create;
      HTMLOutput := CoDOMDocument.Create;

      if Trim(xtSaveDir) = '' then
        xtSaveDir := ExtractFilePath(xtLoadDir)
      else
        xtSaveDir := IncludeTrailingBackSlash(xtSaveDir);

      if not DirectoryExists(ExtractFilePath(xtSaveDir)) then
        Result := STATUS_INVALID_OUTPUT_DIR
      else
      begin
        // To have hard coded stylesheets uncomment following section

        If (xtXSLLocation='') or (Not FileExists(xtXSLLocation)) then
        Begin

          if AnsiSameText('SI', copy(ExtractFileName(xtLoadDir),1,2)) then
            xtXSLLocation := CreatePath([CompanyDataPath, EBUS_DIR, EBUS_XML_DIR,
              EBUS_XSL_DIR]) + EBus_XSL_DefXSL
          else
            xtXSLLocation := CreatePath([CompanyDataPath, EBUS_DIR, EBUS_XML_DIR,
              EBUS_XSL_DIR]) + EBus_XSL_DefXSL;
        end;

        StyleSheet.Load(xtXSLLocation);
        HTMLOutput.validateOnParse := true;  // parse results into a result DOM Document
        XMLDoc.transformNodeToObject(Stylesheet, HTMLOutput);
        xtSaveDir := ChangeFileExt(xtSaveDir + ExtractFileName(xtLoadDir), '.HTM');


        HTMLOutput.Save(xtSaveDir);

        PostProcessHTML(xtSaveDir);

      end;

    end;
  except
    on E:Exception do
    begin
      ShowMessage(E.Message);
      Result := STATUS_TOOLKIT_ERROR;
    end;
  end;
end;

//-----------------------------------------------------------------------------------

function xmlCreateExport(var XMLExportInfo : xmlXMLExportInfoType) : smallint; stdcall;
var
  OutputStream : TFileStream; // Output stream to file

  procedure ProcessTransactions;
  var
    TransStream : TMemoryStream;     // Stream to store the current transaction
    XmlTrans : TWriteXMLTransaction;
    TransType : string[3];
    i : integer;
  begin
    with XMLExportInfo do
    begin
      for i := 0 to xeOurRefList.Count -1 do
      begin
        TransType := UpperCase(copy(xeOurRefList.Strings[i], 1, 3));

        // Only process PINs, SINs, PORs and SORs
        XmlTrans := nil;
        if (TransType  = 'POR') or (TransType = 'SOR') then
          XmlTrans := TWriteXMLOrder.Create;
        if (TransType  = 'PIN') or (TransType = 'SIN') then
          XmlTrans := TWriteXMLInvoice.Create;

        if assigned(XMLTrans) then
          with XMlTrans do
          try
            try
              DataPath := CompanyDataPath;
              // NoXMLHeader := i > 0;
              CreateXML(xeOurRefList.Strings[i]);
              TransStream := TMemoryStream.Create;
              try
                SaveToStream(TransStream, true);
                OutputStream.CopyFrom(TransStream, 0); // Copy the whole stream
              finally
                TransStream.Free;
              end;
            except
              Result := STATUS_TOOLKIT_ERROR;
            end;
          finally
            Free;
          end; // XMLTrans
      end; // for
    end; // with
  end; // ProcessTransactions

begin // xmlCreateExport
  Result := STATUS_OK;
  if not (assigned(XMLExportInfo.xeOurRefList) or (XMLExportInfo.xeOurRefList.Count > 0)) then
    // Unassigned TStrings or empty list
    Result := STATUS_NO_TRANSACTIONS
  else
  begin
    try
      OutputStream := nil;
      OutputStream := TFileStream.Create(XMLExportInfo.xeSaveFileName, fmCreate);
    except
      // If the file cannot be created the call to the constructor of TFileStream raises
      // an exception
      Result := STATUS_INVALID_OUTPUT_FILE;
    end;
    if assigned(OutputStream) then
    try
      ProcessTransactions;
    finally
      OutputStream.Free;
    end;
  end;
end; // xmlCreateExport

{$ENDIF}
end.
