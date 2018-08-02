unit testf;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Setupbas, ExtCtrls, StdCtrls, Buttons;

type
  TSetupTemplate1 = class(TSetupTemplate)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    SpeedButton1: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    H, W, L, T : LongInt;
  end;

var
  SetupTemplate1: TSetupTemplate1;

implementation

{$R *.DFM}

procedure TSetupTemplate1.Button1Click(Sender: TObject);
begin
  inherited;

  Button3Click(Sender);

  AutoResize (1,1);
end;

procedure TSetupTemplate1.Button2Click(Sender: TObject);
begin
  inherited;

  Button3Click(Sender);

  AutoResize (2,0);
end;

procedure TSetupTemplate1.Button3Click(Sender: TObject);
begin
  inherited;

  Height := H;
  Width  := W;
  Left   := L;
  Top    := T;
end;

procedure TSetupTemplate1.FormCreate(Sender: TObject);
begin
  inherited;

  H := Height;
  W := Width;
  L := Left;
  T := Top;

  AutoResize (1,1);
end;

procedure TSetupTemplate1.SpeedButton1Click(Sender: TObject);
begin
  inherited;

  ShowMessage('Image1.Height: ' + IntToStr(Image1.Height));
end;

end.
