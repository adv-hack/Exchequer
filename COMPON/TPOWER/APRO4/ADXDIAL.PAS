{*********************************************************}
{*                   ADXDIAL.PAS 4.03                    *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit ADXDial;

interface

uses
  SysUtils,
  WinTypes,
  WinProcs,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls;

type
  TDialDialog = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Number: TEdit;
    Dial: TButton;
    Cancel: TButton;
    procedure DialClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DialDialog: TDialDialog;

implementation

{$R *.DFM}

procedure TDialDialog.DialClick(Sender: TObject);
begin
  ModalResult := idOk;
end;

procedure TDialDialog.CancelClick(Sender: TObject);
begin
  ModalResult := idCancel;
end;

end.
