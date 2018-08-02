{*********************************************************}
{* ABBREVIA: EXTCAB.PAS                                  *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit CabExt1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,

  AbArcTyp, AbCBrows, ComCtrls, AbCabExt, AbCabTyp, AbBase, AbBrowse, AbMeter, AbUtils;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Label1: TLabel;
    Button2: TButton;
    AbMeter1: TAbMeter;
    AbCabExtractor1: TAbCabExtractor;
    AbVCLMeterLink1: TAbVCLMeterLink;
    procedure Button1Click(Sender: TObject);
    procedure AbCabExtractor1ConfirmProcessItem(Sender: TObject;
      Item: TAbArchiveItem; ProcessType: TAbProcessType;
      var Confirm: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
  MainCaption = 'Cabinet Extractor';

var
  AbortFlag : Boolean;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    with AbCabExtractor1 do begin
      FileName := OpenDialog1.FileName;
      BaseDirectory := ExtractFilePath(FileName);
      Cursor := crHourglass;
      try
        ExtractFiles('*.*');
      except  {swallow exception if aborted}
      end;
      Cursor := crDefault;
    end;
  end;
  Caption := MainCaption;
  AbortFlag := False;
end;

procedure TForm1.AbCabExtractor1ConfirmProcessItem(Sender: TObject;
  Item: TAbArchiveItem; ProcessType: TAbProcessType; var Confirm: Boolean);
begin
  Caption := 'Extracting ' + Item.Filename;
  Confirm := not AbortFlag;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  AbortFlag := True;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AbCabExtractor1.FileName := '';
end;

end.
