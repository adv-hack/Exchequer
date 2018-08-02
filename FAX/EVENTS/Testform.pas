unit Testform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FmPrint_TLB, FmPrintEvents;

type
  TForm1 = class(TForm)
    Events1: TFmPrintIFmPrinterEvents;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Events1PrintComplete(Sender: TObject);
  private
    { Private declarations }
    fmPrinter1 : TfmPrinter;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  fmPrinter1 := TfmPrinter.Create(Self);
  fmPrinter1.PrinterName := 'Exchequer Fax Printer';
  Events1.Connect(fmPrinter1.ControlInterface);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  fmPrinter1.Free;
end;

procedure TForm1.Events1PrintComplete(Sender: TObject);
begin
  ShowMessage('OK');
end;

end.
