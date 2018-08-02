unit ExPagin2;

interface

uses
{$ifndef WIN32 }
  WinTypes, WinProcs,
{$else }
  Windows,
{$endif }
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, OoMisc, AdPacket;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Memo1: TMemo;
    Panel3: TPanel;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Panel4: TPanel;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    ApdDataPacket1: TApdDataPacket;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Changed: Boolean;
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

procedure TForm3.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  OpenDialog1.InitialDir := ExtractFilePath(Edit1.Text);
  OpenDialog1.FileName := ExtractFileName(Edit1.Text);
  if OpenDialog1.Execute then begin
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
    Edit1.Text := OpenDialog1.FileName;
  end;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  Changed := TRUE;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Changed := FALSE;
end;

end.
