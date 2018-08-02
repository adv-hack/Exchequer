unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileProcess, AppEvnts, ComCtrls, Buttons, StrUtils;

type
  Tmainform = class(TForm)
    PageControl1: TPageControl;
    connStrSheet: TTabSheet;
    utilSheet: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    editLoginFile: TEdit;
    btnBrowse: TButton;
    btnOpen: TButton;
    memoConnStr: TMemo;
    btnSave: TButton;
    btnSaveAs: TButton;
    btnTest: TButton;
    OpenDialog: TOpenDialog;
    ApplicationEvents: TApplicationEvents;
    SaveDialog: TSaveDialog;
    btnClose: TButton;
    Label5: TLabel;
    Label7: TLabel;
    decodeUtilbtn: TBitBtn;
    plainTextEdit: TMemo;
    encodedEdit: TMemo;
    Label4: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    decodeKeyEdit: TEdit;
    Label9: TLabel;
    encodeSheet: TTabSheet;
    Label10: TLabel;
    Label11: TLabel;
    encodeKeyEdit: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    plainTextMemo: TMemo;
    encodeBtn: TBitBtn;
    Label14: TLabel;
    encodedMemo: TMemo;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnTestClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure decodeUtilbtnClick(Sender: TObject);
    procedure encodeBtnClick(Sender: TObject);
  private
    { Private declarations }
    fp : TLoginFileProcessor;
    connStr : string;

    function ReassembleString : string;
  public
    { Public declarations }
  end;

var
  mainform: Tmainform;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
procedure Tmainform.btnBrowseClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    editLoginFile.Text := OpenDialog.FileName;
  end;
end;

//------------------------------------------------------------------------------
procedure Tmainform.btnOpenClick(Sender: TObject);
var
  exploder : TStringList;
  index    : integer;
begin
  // Open the selected file
  if fileExists(editLoginFile.Text) then
  begin
    fp.SetFilename(editLoginFile.Text);
    fp.SetTargetProtocol('tcp:');

    fp.CreateLogFile(ExtractFilepath(editLoginFile.Text));
    
    fp.ReadConfigFile;
    if fp.DecodeKey = '' then
      fp.DecodeKey := kStr;

    // Decode and Decrypt the Connection String
    fp.DecodeConnectionString;

    connStr := fp.GetConnectionString;
    connStr := StringReplace(connStr, ' ', '####', [rfReplaceAll]);

    exploder := TStringList.Create;
    exploder.Delimiter := ';';
    exploder.DelimitedText := connStr;

    for index := 0 to exploder.Count-1 do
    begin
      exploder[index] := StringReplace(exploder[index], '####',' ',  [rfReplaceAll]);
    end;
    
    memoConnStr.Lines.Assign(exploder);
    memoConnStr.Modified := false;    
  end;
end;

//------------------------------------------------------------------------------
procedure Tmainform.FormCreate(Sender: TObject);
begin
  fp := TLoginFileProcessor.Create;
end;

//------------------------------------------------------------------------------
procedure Tmainform.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
procedure Tmainform.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
begin
  btnOpen.Enabled   := FileExists(editLoginFile.Text);
  btnSave.Enabled   := Trim(memoConnStr.Text) <> '';
  btnSaveAs.Enabled := Trim(memoConnStr.Text) <> '';
  btnTest.Enabled   := Trim(memoConnStr.Text) <> '';
end;

//------------------------------------------------------------------------------
function Tmainform.ReassembleString : string;
var
  index   : integer;
  sqlConn : string;
begin
  // Reassemble the string
  sqlConn := '';
  for index := 0 to memoConnStr.Lines.Count-1 do
  begin
    sqlConn := sqlConn + Trim(memoConnStr.Lines[index]);
    if index < (memoConnStr.Lines.Count-1) then
      sqlConn := sqlConn + ';'
  end;
  
  result := sqlConn;
end;

//------------------------------------------------------------------------------
procedure Tmainform.btnSaveClick(Sender: TObject);
begin
  connStr := ReassembleString;

  fp.SetConnectionString(connStr);
  
  // Encrypt and Encode the Connection string
  fp.EncryptConnectionString;

  // Save the Connection String back to the file
  fp.SaveConnectionString;

  // Save the default to its file (including the colon)
  fp.SaveDefaultProtocol;

  ShowMessage('Connection string saved');
  
  memoConnStr.Modified := false;
end;

//------------------------------------------------------------------------------
procedure Tmainform.btnSaveAsClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    fp.SetFilename(SaveDialog.FileName);
    btnSaveClick(Sender);
  end;
end;

//------------------------------------------------------------------------------
procedure Tmainform.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if memoConnStr.Modified then
  begin
    if MessageDlg('Connection string has been modified. Save?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      btnSaveClick(Sender);
    end;
    CanClose := true;
  end;
end;

//------------------------------------------------------------------------------
procedure Tmainform.btnTestClick(Sender: TObject);
begin
  // Test the current connection string
  connStr := ReassembleString;

  fp.SetConnectionString(connStr);
  
  // If the connection string is bad, it can take 30 seconds to timeout
  Screen.Cursor := crHourglass;
  
  if fp.TestConnectionString then
  begin
    ShowMessage('Connected successfully using this connection string');
  end
  else
  begin
    ShowMessage('Failed to connect using this connection string');
  end;

  Screen.Cursor :=- crDefault;
end;

//------------------------------------------------------------------------------
procedure Tmainform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fp.Free;
end;

procedure Tmainform.decodeUtilbtnClick(Sender: TObject);
begin
  // Strip and CRLF that have been inadvertently pasted in
  encodedEdit.Text := StringReplace(encodedEdit.Text, chr(13)+chr(10), '', [rfReplaceAll]);

  if trim(decodeKeyEdit.Text) <> '' then
    fp.DecodeKey := decodeKeyEdit.Text
  else
    fp.DecodeKey := ReverseString(kStr);

  fp.EncodedConnectionString := encodedEdit.Text;

  fp.DecodeConnectionString;

  plainTextEdit.Text := fp.ConnectionString;
end;

procedure Tmainform.encodeBtnClick(Sender: TObject);
begin
  //
  fp.SetConnectionString(plainTextMemo.Text);

  // Encrypt and Encode the string
  if trim(encodeKeyEdit.Text) <> '' then
    fp.DecodeKey := encodeKeyEdit.Text
  else
    fp.DecodeKey := ReverseString(kStr);

  fp.EncryptConnectionString;

  encodedMemo.Text := fp.EncodedConnectionString;
end;

end.
