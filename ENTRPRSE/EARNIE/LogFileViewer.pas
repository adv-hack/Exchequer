unit LogFileViewer;

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, ImgList, ToolWin;

type
  TFrmLogFileViewer = class(TForm)
    PrintDialog1: TPrintDialog;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    Button_Close: TButton;
    ToolbarImages: TImageList;
    RichEdit1: TRichEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ToolButton1Click(Sender: TObject);
    procedure Button_CloseClick(Sender: TObject);

  private
    { Private declarations }
    fLogFileName : String;
  protected
    Procedure SetLogFIleName(Value : String);
  public
    { Public declarations }
    constructor Create(aOwner : TComponent;LogFileName : String);
    property LogFileName : string read fLogFileName write SetLogFIleName;
  end;

var
  FrmLogFileViewer: TFrmLogFileViewer;

implementation

{$R *.DFM}

constructor TFrmLogFileViewer.Create(aOwner : TComponent;LogFileName : String);
begin
  inherited create(AOwner);
  self.logFileName := logFileName;
end;

Procedure TFrmLogFileViewer.SetLogFIleName(Value : String);
const
 cNoCurrentLogFile = 'No Log File Currently Exists';
begin
  if FileExists(Value) then
  begin
    fLogFileName := value;
    RichEdit1.Lines.LoadFromFile(value);
  end
  else
    RichEdit1.lines.add(cNoCurrentLogFile);
end;

procedure TFrmLogFileViewer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmLogFileViewer.ToolButton1Click(Sender: TObject);
begin
  RichEdit1.Print('');
end;

procedure TFrmLogFileViewer.Button_CloseClick(Sender: TObject);
begin
  close;
end;

end.

