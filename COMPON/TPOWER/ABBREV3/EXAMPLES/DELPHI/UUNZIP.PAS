{*********************************************************}
{* ABBREVIA: UUNZIP.PAS                                  *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit Uunzip;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,

  AbZBrows, AbUnZper, AbArcTyp, AbMeter, AbBrowse, AbBase;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    AbUnZipper1: TAbUnZipper;
    Memo1: TMemo;
    AbMeter1: TAbMeter;
    AbMeter2: TAbMeter;
    Label1: TLabel;
    Label2: TLabel;
    AbVCLMeterLink1: TAbVCLMeterLink;
    AbVCLMeterLink2: TAbVCLMeterLink;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    with AbUnzipper1 do begin
      FileName := OpenDialog1.FileName;
      BaseDirectory := ExtractFilePath( FileName );
      ExtractFiles( '*.*' );
    end;
  end;
end;

end.
