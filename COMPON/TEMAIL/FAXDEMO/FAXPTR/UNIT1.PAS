unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Quickrep, Menus;

type
  TForm1 = class(TForm)
    QuickReport1: TQuickReport;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    PrintPreview1: TMenuItem;
    QRBand1: TQRBand;
    Image1: TImage;
    QRShape2: TQRShape;
    QRMemo1: TQRMemo;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    Field1: TQRLabel;
    Field2: TQRLabel;
    Field3: TQRLabel;
    Field4: TQRLabel;
    QRLabel10: TQRLabel;
    addressmemo: TQRMemo;
    QRMemo6: TQRMemo;
    Field5: TQRLabel;
    QRShape1: TQRShape;
    sigimage: TImage;
    DataBox1: TListBox;
    QRShape3: TQRShape;
    QRLabel6: TQRLabel;
    procedure PrintPreview1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    shutdown : boolean;
    procedure AppIdle(Sender: TObject; var Done: Boolean);
    procedure MergeData;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.PrintPreview1Click(Sender: TObject);
begin
  quickreport1.preview;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Print1Click(Sender: TObject);
begin
  quickreport1.print;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.windowstate := wsMinimized;
  shutdown := false;
  if paramstr(1) <> '' then
  begin
    databox1.clear;
    databox1.items.loadfromfile(paramstr(1));
    MergeData;
    if paramstr(2) = '/p' then
    begin
      quickreport1.print;
      shutdown := true;
    end;
  end;
  Application.OnIdle := AppIdle;
end;


procedure TForm1.AppIdle(Sender: TObject; var Done: Boolean);
begin
  if Shutdown = true then close;
  Done := True;
end;

procedure TForm1.MergeData;
begin
  {Fax Header}
  Field1.caption := databox1.items[0]; {TO:}
  Field2.caption := databox1.items[1]; {FAX NO:}
  Field3.caption := formatdatetime('dd mmmm yyyy',now); {DATE:}
  Field4.caption := 'Fred Bloggs'; {FROM:}
  Field5.caption := 'Fred Bloggs'; {FROM:}
  {Customer Address Block}
  addressMemo.clear;
  addressMemo.lines.add(databox1.items[2]);
  addressMemo.lines.add(databox1.items[3]);
  addressMemo.lines.add(databox1.items[4]);
  addressMemo.lines.add(databox1.items[5]);
  addressMemo.lines.add(databox1.items[6]);
  addressMemo.lines.add(databox1.items[7]);
  addressMemo.lines.add(databox1.items[8]);
  {Load BMP files}
  sigimage.picture.loadfromfile('c:\faxdemo\bmp\sig.bmp');
  image1.picture.loadfromfile('c:\faxdemo\bmp\logo.bmp');
end;

end.
