unit HTMLView;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, IpHtml, IpMsg, IpUtils, IpBroker, StdCtrls;

type
  TfrmHTMLTransViewer = class(TForm)
    IpHtmlPanel1: TIpHtmlPanel;
    IpHtmlDataProvider1: TIpHtmlDataProvider;
    pnlRight: TPanel;
    btnClose: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure IpHtmlDataProvider1GetImage(Sender: TIpHtmlNode;
      const URL: String; var Picture: TPicture);
  private
    fOurRef,
    fXMLFileName,
    fHTMLFileName : string;
    procedure DeleteTempHTMLFile;
    procedure SetXMLFileName(const Value : string);
    procedure LoadHTML;
    procedure SetString(Index : integer; const Value: string);
  protected
    property XMLFileName  : string read fXMLFileName write SetXMLFileName;
    property OurRef       : string index 1 read fOurRef write SetString;
    property HTMLFileName : string index 2 read fHTMLFileName write SetString;
  public
    procedure RefreshHTML(const Ref, FileName: string);
  end;

var
  frmHTMLTransViewer: TfrmHTMLTransViewer;

implementation

{$R *.DFM}

uses
  XMLFuncs, FileUtil, AdmnUtil, EbusUtil, BTSupU1, TKUtil;

//-----------------------------------------------------------------------

procedure TfrmHTMLTransViewer.SetXMLFileName(const Value : string);
begin
  DeleteTempHTMLFile;
  fXMLFileName := Value;
  Caption := Format('%s : [%s]',[OurRef, ExtractFileName(XMLFileName)]);
  LoadHTML;
end;

//-----------------------------------------------------------------------

procedure TfrmHTMLTransViewer.SetString(Index: integer; const Value: string);
begin
  case Index of
    1: fOurRef := Value;
    2: fHTMLFileName := Value;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmHTMLTransViewer.RefreshHTML(const Ref, FileName: string);
begin
  OurRef := Ref;
  XMLFileName := FileName;
end;

//-----------------------------------------------------------------------

procedure TfrmHTMLTransViewer.DeleteTempHTMLFile;
// Notes : Clears the generated HTML file from the swap directory
begin
  if HTMLFileName <> '' then
    SysUtils.DeleteFile(HTMLFileName);
end;

//-----------------------------------------------------------------------

procedure TfrmHTMLTransViewer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  DeleteTempHTMLFile;
  SendMessage((Owner as TForm).Handle, WM_CustGetRec, EBUS_FORM_CLOSE, FORM_HTML_VIEW);
end;

//-----------------------------------------------------------------------

procedure TfrmHTMLTransViewer.LoadHTML;
// Notes : The save method of IXMLDOMDocument can use a stream (IStream) to return
//         its data (as well as to a file specified by a string). Delphi's IStreams
//         unit contains adapter classes which include the interface to IStream.
//         For simplicity, currently this routine imports the HTML from file.
var
  HTML : TIpHtml;
  FileStream : TFileStream;
  InitInfo : xmlInitInfoType;
  HTMLInfo : xmlHTMLInfoType;
begin
  HTMLInfo.xtLoadDir := XMLFileName;
  HTMLInfo.xtSaveDir := GetEntSwapDir(CurCompSettings.CompanyPath);
  InitInfo.xiDataPath := CurCompSettings.CompanyPath;
  InitInfo.xiCCyVer := GetMultiCurrencyCode;
  xmlInitDLL(InitInfo);
  if xmlCreateHTMFile(HTMLInfo) = 0 then
  begin
    fHTMLFileName := HTMLInfo.xtSaveDir;
    FileStream := TFileStream.Create(HTMLFileName, fmShareDenyNone or fmOpenRead);
    HTML := TIpHtml.Create;
    HTML.LoadFromStream(FileStream);
    IpHtmlPanel1.SetHTML(HTML);
    FileStream.Free;
  end;
end; // TfrmHTMLTransViewer.LoadHTML

//-----------------------------------------------------------------------

procedure TfrmHTMLTransViewer.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmHTMLTransViewer.IpHtmlDataProvider1GetImage(
  Sender: TIpHtmlNode; const URL: String; var Picture: TPicture);
var
  FileName : string;
begin
  // At the moment the <img> tag in the generated HTML assumes image files are in the same
  // directory as the HTML file.
  // Also, ExtractFileName is semi-precuationary. Should be using another method?
  FileName := ExtractFilePath(HTMLFileName) + ChangeFileExt(ExtractFileName(URL), '.bmp');
  if FileExists(FileName) then
  begin
    Picture := TPicture.Create;
    Picture.LoadFromFile(Filename)
  end
  else
    Picture := nil;
end;

end.
