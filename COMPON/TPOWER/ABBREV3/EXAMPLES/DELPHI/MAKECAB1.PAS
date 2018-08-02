{*********************************************************}
{* ABBREVIA: MAKECAB1.PAS                                *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit MakeCab1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Gauges, ExtCtrls, ComCtrls,

  AbArcTyp, AbCBrows, AbCabMak, AbCabTyp, AbMeter, AbBrowse, AbBase;

type
  TForm1 = class(TForm)
    AddBtn: TButton;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    CreateBtn: TButton;
    CloseBtn: TButton;
    Panel1: TPanel;
    NewFolderBtn: TButton;
    Label2: TLabel;
    NewCabBtn: TButton;
    AbMeter1: TAbMeter;
    AbMakeCab1: TAbMakeCab;
    AbVCLMeterLink1: TAbVCLMeterLink;
    procedure AddBtnClick(Sender: TObject);
    procedure CreateBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure NewFolderBtnClick(Sender: TObject);
    procedure NewCabBtnClick(Sender: TObject);
    procedure AbMakeCab1ArchiveItemProgress(Sender: TObject;
      Item: TAbArchiveItem; Progress: Byte; var Abort: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  MainCaption = 'Make Cabinet Archive';

procedure TForm1.CreateBtnClick(Sender: TObject);
begin
  OpenDialog1.Filename := '*.Cab';
  OpenDialog1.Title := 'Name of 1st cabinet';
  if OpenDialog1.Execute then begin
    Panel1.Caption := 'Creating ' + OpenDialog1.FileName;
    AbMakeCab1.OpenArchive(OpenDialog1.FileName);
    Caption := AbMakeCab1.FileName;
    Panel1.Caption := 'Idle';
  end;
end;

procedure TForm1.AddBtnClick(Sender: TObject);
var
  i : Integer;
  SC : TCursor;
  FileList : TStringList;

begin
  OpenDialog1.Filename := '*.*';
  OpenDialog1.Title := 'Add files to cabinet';
  if OpenDialog1.Execute then
    if (OpenDialog1.Files.Count > 0) then begin
      SC := Cursor;
      Cursor := crHourglass;
      FileList := TStringList.Create;
      try
        FileList.Assign(OpenDialog1.Files);
        for i := 0 to Pred(FileList.Count) do
          AbMakeCab1.AddFiles(FileList.Strings[i], 0);
      finally
        FileList.Free;
      end;
      Cursor := SC;
      Panel1.Caption := 'Idle';
    end;
end;

procedure TForm1.CloseBtnClick(Sender: TObject);
begin
  Panel1.Caption := 'Closing ' + AbMakeCab1.FileName;
  AbMakeCab1.CloseArchive;
  Caption := MainCaption;
  Panel1.Caption := 'Idle';
end;

procedure TForm1.NewFolderBtnClick(Sender: TObject);
begin
  AbMakeCab1.StartNewFolder;
end;

procedure TForm1.NewCabBtnClick(Sender: TObject);
begin
  AbMakeCab1.StartNewCabinet;
end;

procedure TForm1.AbMakeCab1ArchiveItemProgress(Sender: TObject;
  Item: TAbArchiveItem; Progress: Byte; var Abort: Boolean);
begin
  Panel1.Caption := 'Adding ' + ExtractFilename(Item.Filename);
  Abort := False;
end;

end.
