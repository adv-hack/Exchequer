{*********************************************************}
{*                   ADABOUT.PAS 4.03                    *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F-,V-,P-,T-,B-}

unit AdAbout;
{- component about box}
interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,  StdCtrls, ExtCtrls, OoMisc, ShellAPI;

type
  TApdAboutForm = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Button1: TButton;
    Label15: TLabel;
    Label16: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label15Click(Sender: TObject);
    procedure Label16Click(Sender: TObject);
  end;

var
  ApdAboutForm: TApdAboutForm;

implementation

{$R *.DFM}

procedure TApdAboutForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TApdAboutForm.FormCreate(Sender: TObject);
begin
  Label2.Caption := ApVersionStr;
end;

procedure TApdAboutForm.Label5Click(Sender: TObject);
begin
  if ShellExecute(0, 'open', 'http://www.turbopower.com', '', '', SW_SHOWNORMAL) <= 32 then
    ShowMessage('Unable to start web browser. Make sure you have it properly set-up on your system.');
end;

procedure TApdAboutForm.Label6Click(Sender: TObject);
begin
  if ShellExecute(0, 'open', 'news://news.turbopower.com', '', '', SW_SHOWNORMAL) <= 32 then
   ShowMessage('Unable to start web browser. Make sure you have it properly set-up on your system.');
end;

procedure TApdAboutForm.Label5MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Left := (Sender as TLabel).Left + 1;
end;

procedure TApdAboutForm.Label5MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Left := (Sender as TLabel).Left - 1;
end;

procedure TApdAboutForm.Label15Click(Sender: TObject);
begin
  if ShellExecute(0, 'open', 'http://www.turbopower.com/updates/', '', '', SW_SHOWNORMAL) <= 32 then
    ShowMessage('Unable to start web browser. Make sure you have it properly set-up on your system.');
end;

procedure TApdAboutForm.Label16Click(Sender: TObject);
begin
  if ShellExecute(0, 'open', 'http://www.turbopower.com/tpslive/', '', '', SW_SHOWNORMAL) <= 32 then
    ShowMessage('Unable to start web browser. Make sure you have it properly set-up on your system.');
end;
            
end.
