{*********************************************************}
{* ABBREVIA: UMAKESFX.PAS                                *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit umakesfx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,

  AbArcTyp, AbSelfEx, AbBase;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    AbMakeSelfExe1: TAbMakeSelfExe;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure AbMakeSelfExe1GetStubExe(Sender: TObject;
      var aFilename: string; var Abort: Boolean);
    procedure AbMakeSelfExe1GetZipFile(Sender: TObject;
      var aFilename: string; var Abort: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses
  AbZipTyp;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if AbMakeSelfExe1.Execute then
   ShowMessage(AbMakeSelfExe1.SelfExe + ' has been created');
end;

procedure TForm1.AbMakeSelfExe1GetStubExe(Sender: TObject;
  var aFilename: string; var Abort: Boolean);
begin
  OpenDialog1.Title := 'Select executable stub';
  OpenDialog1.Filename := '';
  OpenDialog1.Filter := 'Exe files|*.exe';
  Abort := not OpenDialog1.Execute;
  if not Abort then
    aFileName := OpenDialog1.Filename;
end;

procedure TForm1.AbMakeSelfExe1GetZipFile(Sender: TObject;
  var aFilename: string; var Abort: Boolean);
begin
  OpenDialog1.Title := 'Select Zip File';
  OpenDialog1.Filename := '';
  OpenDialog1.Filter := 'Zip files|*.zip';
  Abort := not OpenDialog1.Execute;
  if not Abort then
    aFileName := OpenDialog1.Filename;
end;

end.
