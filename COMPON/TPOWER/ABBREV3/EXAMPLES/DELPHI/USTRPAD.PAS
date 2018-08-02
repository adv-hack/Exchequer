{*********************************************************}
{* ABBREVIA: USTRPAD.PAS                                 *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit Ustrpad;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Memo2: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    ZnfName : string;
    TxtName : string;
    ZnfStream : TFileStream;
    TxtStream : TStream;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  AbUnzPrc,
  AbZipPrc;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ZnfName := ChangeFileExt(Application.ExeName, '.zst');
  TxtName := ExtractFileName( ChangeFileExt(Application.ExeName, '.pad') );
  ChDir( ExtractFilePath( Application.ExeName ) );
  if FileExists( ZnfName ) then begin
    TxtStream := TMemoryStream.Create;
    try
      ZnfStream := TFileStream.Create( ZnfName,
                                       fmOpenRead or fmShareExclusive );
      try
        InflateStream( ZnfStream, TxtStream );
      finally
        ZnfStream.Free;
      end;
      TxtStream.Position := 0;
      Memo1.Lines.LoadFromStream( TxtStream );
    finally
      TxtStream.Free;
    end;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TxtStream := TMemoryStream.Create;
  try
    Memo1.Lines.SaveToStream( TxtStream );
    TxtStream.Position := 0;
    if FileExists( ZnfName ) then
      ZnfStream := TFileStream.Create( ZnfName,
                                       fmOpenWrite or fmShareExclusive )
    else
      ZnfStream := TFileStream.Create( ZnfName,
                                       fmCreate or fmShareExclusive );
    try
      DeflateStream( TxtStream, ZnfStream );
    finally
      ZnfStream.Free;
    end;
  finally
    TxtStream.Free;
  end;
end;

end.
