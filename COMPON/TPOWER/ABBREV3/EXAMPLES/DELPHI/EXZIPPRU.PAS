{*********************************************************}
{* ABBREVIA: EXZIPPRU.PAS                                *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit ExZippru;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl,

  AbArcTyp, AbZipOut, AbZBrows, AbZipper, AbBrowse, AbBase, AbMeter, AbUtils;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    Label1: TLabel;
    AbZipper1: TAbZipper;
    Button3: TButton;
    AbMeter1: TAbMeter;
    AbVCLMeterLink1: TAbVCLMeterLink;
    procedure Button1Click(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure AbZipper1ConfirmProcessItem(Sender: TObject;
      Item: TAbArchiveItem; ProcessType: TAbProcessType;
      var Confirm: Boolean);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  DirectoryListBox1Change(nil);
  AbZipper1.LogFile := ExtractFilePath(Application.ExeName) + 'Log.txt';
end;

procedure TForm1.DirectoryListBox1Change(Sender: TObject);
begin
  AbZipper1.BaseDirectory := DirectoryListBox1.Directory;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  OpenDialog1.Filename := '*.zip';
  OpenDialog1.InitialDir := DirectoryListBox1.Directory;
  if OpenDialog1.Execute then
    AbZipper1.Filename := OpenDialog1.Filename;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  AbZipper1.AddFiles('*.*', 0);
  Caption := 'ExZipper';
end;

procedure TForm1.AbZipper1ConfirmProcessItem(Sender: TObject;
  Item: TAbArchiveItem; ProcessType: TAbProcessType; var Confirm: Boolean);
begin
  Caption := 'adding ' + Item.Filename;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Cursor := crHourGlass;
  AbZipper1.CloseArchive;
  Cursor := crDefault;
end;

end.


