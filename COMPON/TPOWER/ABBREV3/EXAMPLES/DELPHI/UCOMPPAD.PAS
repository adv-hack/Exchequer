{*********************************************************}
{* ABBREVIA: UCOMPPAD.PAS                                *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit ucomppad;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ExtCtrls,

  AbZBrows, AbZipper, AbZipKit, AbArcTyp, AbBrowse, AbBase;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    AbZipKit1: TAbZipKit;
    Panel1: TPanel;
    Memo2: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    ZnfName : string;
    TxtName : string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ZnfName := ChangeFileExt(Application.ExeName, '.zip');
  TxtName := ExtractFileName( ChangeFileExt(Application.ExeName, '.txt') );
  with AbZipKit1 do begin
    BaseDirectory := ExtractFilePath( Application.ExeName );
    ChDir( BaseDirectory );
    FileName := ZnfName;
    if Count > 0 then begin
      ExtractFiles( TxtName );
      Memo1.Lines.LoadFromFile( TxtName );
    end;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Memo1.Lines.SaveToFile( TxtName );
  with AbZipKit1 do begin
    if Count = 0 then
      AddFiles( TxtName, 0 )
    else
      FreshenFiles( TxtName );
    Save;
  end;
  DeleteFile( TxtName );
end;

end.
