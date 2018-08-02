unit ConfigF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmBacsConfig = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    edtVal: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ReadIniFile;
    procedure WriteIniFile;
  protected
    fDataDirectory : string;
  public
    { Public declarations }
    IniFileName, Section, Key : string;
  end;

var
  frmBacsConfig: TfrmBacsConfig;

implementation

{$R *.dfm}

uses
  IniFiles, FileUtil;

procedure TfrmBacsConfig.Button1Click(Sender: TObject);
begin
  WriteIniFile;
  Close;
end;

procedure TfrmBacsConfig.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmBacsConfig.ReadIniFile;
begin
  with TIniFile.Create(fDataDirectory + IniFileName) do
  Try
    edtVal.Text := ReadString(Section, Key, '');
  Finally
    Free;
  End;
end;

procedure TfrmBacsConfig.WriteIniFile;
begin
  with TIniFile.Create(fDataDirectory + IniFileName) do
  Try
    WriteString(Section, Key, edtVal.Text);
  Finally
    Free;
  End;
end;


procedure TfrmBacsConfig.FormCreate(Sender: TObject);
begin
  fDataDirectory := IncludeTrailingBackslash(ParamStr(1));
  ReadIniFile;
end;

end.
