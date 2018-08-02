{*********************************************************}
{* ABBREVIA: CABFIND1.PAS                                *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit CabFind1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, Buttons, ExtCtrls,

  AbArcTyp, AbBrowse, AbCBrows, AbBase;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    Memo2: TMemo;
    Label2: TLabel;
    AbCabBrowser1: TAbCabBrowser;
    Button1: TButton;
    Button2: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    Aborted: Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Aborted := True;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  Button1.Enabled := Length( Edit1.Text ) > 0;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i : Integer;
  CurFile : string;
begin
  Button1.Enabled := False;
  Memo1.Clear;
  try
    Button2.Enabled := True;
    Aborted := False;
    {look in the file list box for the file}
    for i := 0 to pred( FileListBox1.Items.Count ) do begin
      Application.ProcessMessages;
      if Aborted then
        break;
      if CompareText( Edit1.Text, FileListBox1.Items[i] ) = 0 then begin
        Memo1.Lines.Add( 'Found in ' + FileListBox1.Directory );
        break;
      end;
      {now add search of zip and self extracting files}
      CurFile := UpperCase( FileListBox1.Items[i] );
      if ( Pos( '.CAB', CurFile ) > 0 ) then begin
        try
          AbCabBrowser1.FileName := FileListBox1.Items[i];
          if AbCabBrowser1.FindFile(Edit1.Text) >= 0 then
            Memo1.Lines.Add( 'Found in ' + FileListBox1.Items[i] );
        except
        end;
      end;
    end;
  finally
    Memo1.Lines.Add( 'Done!' );
    Edit1.Enabled := True;
    Button1.Enabled := True;
    Button2.Enabled := False;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Aborted := True;
end;

end.
