{*********************************************************}
{* ABBREVIA: UCONTENT.PAS                                *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit UContent;



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,

  AbZBrows, AbArcTyp, AbBrowse, AbBase;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    AbZipBrowser1: TAbZipBrowser;
    Label1: TLabel;
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
var
  i : Integer;
begin
  ListBox1.Clear;
  if OpenDialog1.Execute then begin
    try
      with AbZipBrowser1 do begin
        FileName := OpenDialog1.FileName;
        if Count > 0 then
          for i := 0 to pred( Count ) do
            ListBox1.Items.Add( Items[i].FileName );
      end;
    except
      ListBox1.Items.Add( OpenDialog1.FileName + ' is not a valid archive.' );
    end;
  end;
end;

end.
