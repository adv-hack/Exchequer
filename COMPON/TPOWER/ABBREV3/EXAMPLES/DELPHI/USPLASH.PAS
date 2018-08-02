{*********************************************************}
{* ABBREVIA: USPLASH.PAS                                 *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit usplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TSplash = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Splash: TSplash;

implementation

{$R *.DFM}

procedure TSplash.Timer1Timer(Sender: TObject);
begin
  Close;
end;

end.
