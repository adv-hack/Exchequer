{*********************************************************}
{*                     EXVIEW0.PAS                       *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Views an Async Professional Fax (APF) file.  See the  *}
(*   ViewFax project for a more inclusive example.       *)
{*********************************************************}

unit Exview0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, AdFView, OoMisc;

type
  TForm1 = class(TForm)
    ApdFaxViewer1: TApdFaxViewer;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  if OpenDialog1.Execute then
    ApdFaxViewer1.FileName := OpenDialog1.FileName
  else
    Halt(1);
end;

end.

