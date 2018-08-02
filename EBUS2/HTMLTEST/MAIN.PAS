unit Main;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BrwseDir, Buttons;

type
  xmlHTMLInfoType = record
    xtLoadDir      : string[255]; // Path and name of XML file to process
    xtSaveDir      : string[255]; // Path to write HTML document to
    xtXSLLocation  : string[255]; // XSL location to read to convert XML to HTML
    xtSpare        : array [1..500] of char;
  end; // xmlHTMInfoType

  TForm1 = class(TForm)
    edXML: TEdit;
    Button1: TButton;
    edXSL: TEdit;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edOutputPath: TEdit;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
  MSXML_TLB, FileCtrl;


{$R *.DFM}

procedure PostProcessHTML(DocName : string);
// Pre   : DocName = Name of file representing xml document to load
// Notes : The Microsoft XML COM object produces HTML which includes empty
//         tags and certain entities which are not processed correctly by non-
//         Interner Explorer browsers.  These need to be replaced with values
//         that are generally acceptable.
//         The affected tags are: area, base, basefont, br, col, frame, hr,
//         img, input, isindex, link, meta and param
type
  TTagReplace =
    record
      T1 : string;
      T2 : string;
    end;
const
  MAX_TAGS = 2;
  REPLACEMENT_TAGS : array [1..MAX_TAGS] of TTagReplace =
    ((T1: '/>'; T2: '>'), (T1: chr(194); T2 : '&nbsp;'));
var
  Doc : string;
  i : integer;
begin
  with TStringList.Create do
    try
      LoadFromFile(DocName);
      Doc := Text;
      for i := 1 to MAX_TAGS do
        Doc := StringReplace(Doc, REPLACEMENT_TAGS[i].T1, REPLACEMENT_TAGS[i].T2,
          [rfReplaceAll, rfIgnoreCase]);
      Text := Doc;
      SaveToFile(DocName);
    finally
      Free;
    end;
end; // LoadXMLDocument


procedure TForm1.Button1Click(Sender: TObject);
begin
  OpenDialog1.Filter := 'XML files |*.XML|All files |*.*';
  if OpenDialog1.Execute then edXML.Text := OpenDialog1.Filename;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  OpenDialog1.Filter := 'XSL files |*.XSL|All files |*.*';
  if OpenDialog1.Execute then edXSL.Text := OpenDialog1.Filename;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  with TFrmDirBrowse.Create(self) do begin
    try
      if Showmodal = mrOK then edOutputPath.Text := IncludeTrailingBackslash(lDir.Caption);
    finally
      release;
    end;{try}
  end;{with}
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  close;
end;

function xmlCreateHTMFile(var HTMLInfo : xmlHTMLInfoType) : smallint;
// Pre  : HTMLInfo.xtSaveDir = Path to write generated HTML file to
// Post : HTMLInfo.xtSaveDir = Path and file name of generated HTML file
var
  XmlDoc,
  StyleSheet,
  HTMLOutput : IXMLDOMDocument;

  function LoadXMLDocument(DocName : string; var XMLDoc : IXMLDOMDocument) : boolean;
  // Pre   : DocName = Name of file representing xml document to load
  // Post  : XMLDoc  = DOM document instance generated
  //         Returns true if document loaded OK
  // Notes : If an xml document has processing instructions in it, for example specifying
  //         an XSL style-sheet, but the style-sheet is unavailable then the document won't
  //         load.  To circumvent this pre-read into a StringList, parse out all the
  //         processing instructions and pass the result onto the XML COM object.
  const
    PROCESS_INST_START = '<?';
    PROCESS_INST_END = '?>';
  var
    StartPos,
    EndPos    : integer;
    Doc       : string;
  begin
    with TStringList.Create do
      try
        LoadFromFile(DocName);
        Doc := Text;
        // Remove all processing instructions
        StartPos := Pos(PROCESS_INST_START, Doc);
        while StartPos > 0 do
        begin
          EndPos := Pos(PROCESS_INST_END, Doc);
          System.Delete(Doc, StartPos, EndPos - StartPos + 2);
          StartPos := Pos(PROCESS_INST_START, Doc);
        end;

        // Remove any extraneous characters from end of file -
        // seem to appear when XML document sent as E-mail attachment
        EndPos := Length(Doc);
        StartPos := Length(Doc);
        while Doc[StartPos] <> '>' do
          dec(StartPos);
        System.Delete(Doc,StartPos+1,EndPos);

        XMLDoc := CoDOMDocument.Create;
        XMLDoc.async := false;
        Result := XMLDoc.LoadXML(TrimLeft(Doc));
      finally
        Free;
      end;
  end; // LoadXMLDocument

begin
  try
    with HTMLInfo do
    begin
     // ShowMessage(xtLoadDir);
      Result := 0;
      LoadXMLDocument(xtLoadDir, XmlDoc);
      StyleSheet := CoDOMDocument.Create;
      HTMLOutput := CoDOMDocument.Create;

      if Trim(xtSaveDir) = '' then
        xtSaveDir := ExtractFilePath(xtLoadDir)
      else
        xtSaveDir := IncludeTrailingBackSlash(xtSaveDir);

      if not DirectoryExists(ExtractFilePath(xtSaveDir)) then
        Result := 1
      else
      begin
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
      Result := 3;
    end;
  end;
end;



procedure TForm1.Button5Click(Sender: TObject);
var
  xmlHTMLInfo : xmlHTMLInfoType;
begin
  screen.cursor := crHourglass;
  with xmlHTMLInfo do begin
    xtLoadDir := edXML.Text;
    xtSaveDir := edOutputPath.Text;
    xtXSLLocation := edXSL.Text;
  end; // xmlHTMInfoType
  xmlCreateHTMFile(xmlHTMLInfo);
  screen.cursor := crDefault;
end;

end.
