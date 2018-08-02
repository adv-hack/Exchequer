{*********************************************************}
{* ABBREVIA: SLFSTBV1.PAS                                *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit Slfstbv1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, 

  AbZBrows, AbUnZper, AbArcTyp, AbBrowse, AbBase, AbUtils;

type
  TForm1 = class(TForm)
    Button1: TButton;
    AbUnZipper1: TAbUnZipper;
    Memo1: TMemo;
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
  AbUnzipper1.FileName := ExtractFilePath(Application.ExeName) + 'abtest.exe';
  AbUnzipper1.ArchiveType := atSelfExtZip;

  AbUnzipper1.ExtractFiles( '*.*' );
end;

end.
