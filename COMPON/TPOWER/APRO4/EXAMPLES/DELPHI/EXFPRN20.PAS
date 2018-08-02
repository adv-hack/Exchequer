{*********************************************************}
{*                    EXFPRN20.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*     Prints an Async Professional Fax (APF) file.      *}
{*       Slightly more complex than EXFPRN1.             *}
{*********************************************************}

unit EXFPRN20;

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
    ApdFaxPrinterLog1: TApdFaxPrinterLog;
    FileNameEdit: TEdit;
    FileNameButton: TButton;
    OpenDialog1: TOpenDialog;
    PrintButton: TButton;
    PrintSetupButton: TButton;
    ExitButton: TButton;
    FaxHeaderCheck: TCheckBox;
    FaxFooterCheck: TCheckBox;
    FaxHeaderEdit: TEdit;
    FaxFooterEdit: TEdit;
    procedure FileNameButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure PrintSetupButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure FaxHeaderEditChange(Sender: TObject);
    procedure FaxFooterEditChange(Sender: TObject);
    procedure FaxHeaderCheckClick(Sender: TObject);
    procedure FaxFooterCheckClick(Sender: TObject);
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

procedure TForm1.PrintSetupButtonClick(Sender: TObject);
begin
  try
    ApdFaxPrinter1.FileName := FileNameEdit.Text;
    ApdFaxPrinter1.PrintSetup;
  finally
  end;
end;

procedure TForm1.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FaxHeaderEditChange(Sender: TObject);
begin
  ApdFaxPrinter1.FaxHeader.Caption := FaxHeaderEdit.Text;
end;

procedure TForm1.FaxFooterEditChange(Sender: TObject);
begin
  ApdFaxPrinter1.FaxFooter.Caption := FaxFooterEdit.Text;
end;

procedure TForm1.FaxHeaderCheckClick(Sender: TObject);
begin
  ApdFaxPrinter1.FaxHeader.Enabled := FaxHeaderCheck.Checked;
end;

procedure TForm1.FaxFooterCheckClick(Sender: TObject);
begin
  ApdFaxPrinter1.FaxFooter.Enabled := FaxFooterCheck.Checked;
end;

end.
