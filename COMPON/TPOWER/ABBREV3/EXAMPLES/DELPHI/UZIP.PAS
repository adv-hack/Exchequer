{*********************************************************}
{* ABBREVIA: UZIP.PAS                                    *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit Uzip;

interface

uses
  Windows,  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Gauges, 

  AbZipper, AbArcTyp, AbZBrows, AbMeter, AbBrowse, AbBase;

type
  TForm1 = class(TForm)
    AbZipper1: TAbZipper;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
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
  if OpenDialog1.Execute then
    AbZipper1.AddFiles( OpenDialog1.FileName, 0 );
end;

end.
