unit ExampleMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    sJobFile : string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  uUpdatePaths, frmViewFile;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    PrepareExampleJobFile(OpenDialog1.Filename);
    ShowMessage('Job file processed');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  PrepareDefaultSettingsFile;
  ShowMessage('Default Settings file processed');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    DecryptJobFile(OpenDialog1.Filename);
    Try
      with TfrmViewJobFile.Create(nil) do
      Try
        lbJobFile.Items.LoadFromFile(OpenDialog1.Filename);
        ShowModal;
      Finally
        Free;
      End;

    Finally

    End;
  end
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName) + 'ImportJobs';
end;

end.
