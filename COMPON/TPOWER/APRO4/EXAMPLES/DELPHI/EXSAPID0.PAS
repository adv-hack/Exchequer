{*********************************************************}
{*                     ExSapiD0.PAS                      *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to access all the built in           *}
{* configuration dialogs in SAPI                         *}
{*********************************************************}

unit ExSapiD0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OoMisc, AdSapiEn, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnSSAbout: TButton;
    btnSSGeneral: TButton;
    btnSSLexicon: TButton;
    btnSSTranslate: TButton;
    btnSRAbout: TButton;
    btnSRGeneral: TButton;
    btnSRLexicon: TButton;
    btnSRTrainGeneral: TButton;
    btnSRTrainMic: TButton;
    ApdSapiEngine1: TApdSapiEngine;
    procedure btnSSAboutClick(Sender: TObject);
    procedure btnSSGeneralClick(Sender: TObject);
    procedure btnSSLexiconClick(Sender: TObject);
    procedure btnSSTranslateClick(Sender: TObject);
    procedure btnSRAboutClick(Sender: TObject);
    procedure btnSRGeneralClick(Sender: TObject);
    procedure btnSRTrainGeneralClick(Sender: TObject);
    procedure btnSRLexiconClick(Sender: TObject);
    procedure btnSRTrainMicClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnSSAboutClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowSSAboutDlg ('SS About');
end;

procedure TForm1.btnSSGeneralClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowSSGeneralDlg ('SS General');
end;

procedure TForm1.btnSSLexiconClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowSSLexiconDlg ('SS Lexicon');
end;

procedure TForm1.btnSSTranslateClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowTranslateDlg ('SS Translate');
end;

procedure TForm1.btnSRAboutClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowSRAboutDlg ('SR About');
end;

procedure TForm1.btnSRGeneralClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowSRGeneralDlg ('SR General');
end;

procedure TForm1.btnSRTrainGeneralClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowTrainGeneralDlg ('SR General Training');
end;

procedure TForm1.btnSRLexiconClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowSRLexiconDlg ('SR Lexicon');
end;

procedure TForm1.btnSRTrainMicClick(Sender: TObject);
begin
  ApdSapiEngine1.ShowTrainMicDlg ('SR Microphone Training');
end;

end.
