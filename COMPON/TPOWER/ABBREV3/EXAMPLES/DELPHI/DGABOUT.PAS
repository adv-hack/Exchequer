{*********************************************************}
{* ABBREVIA: DGABOUT.PAS                                 *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit dgAbout;

interface

uses
  Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TdlgAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Panel2: TPanel;
    lnTitleShadow: TLabel;
    lblTitle: TLabel;
    Label5: TLabel;
    Label86: TLabel;
    Label85: TLabel;
    Label84: TLabel;
    OKButton: TButton;
    Version: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgAboutBox: TdlgAboutBox;

implementation

{$R *.DFM}

uses
  AbConst;

procedure TdlgAboutBox.FormCreate(Sender: TObject);
begin
  Version.Caption := 'Abbrevia ' + AbVersion;
end;





end.

