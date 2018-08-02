{*********************************************************}
{*                    EXFPRN10.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*     Prints an Async Professional Fax (APF) file.      *}
{*********************************************************}

unit EXFPRN10;

interface

uses
  WinTypes,
  WinProcs,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  AdFaxPrn,
  AdFPStat, OoMisc;

type
  TForm1 = class(TForm)
    fnLabel: TLabel;
    ApdFaxPrinter1: TApdFaxPrinter;
    ApdFaxPrinterStatus1: TApdFaxPrinterStatus;
    FileNameEdit: TEdit;
    FileNameButton: TButton;
    OpenDialog1: TOpenDialog;
    PrintButton: TButton;
    ExitButton: TButton;
    procedure FileNameButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FileNameButtonClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'APF Files (*.APF)|*.APF';
  if OpenDialog1.Execute then
    FileNameEdit.Text := OpenDialog1.FileName;
end;

procedure TForm1.PrintButtonClick(Sender: TObject);
begin
  try
    ApdFaxPrinter1.FileName := FileNameEdit.Text;
    ApdFaxPrinter1.PrintFax;
  finally
  end;
end;

procedure TForm1.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

end.
