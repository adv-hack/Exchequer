{*********************************************************}
{*                     EXPNDX0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Demonstrates how to use the PrinterIndex property of  *}
{*     a TPrinter object to select the APFFAX printer    *}
{*     driver programmatically as the current printer.   *}
{*********************************************************}

unit ExPNdx0;

interface

uses
  WinTypes,
  WinProcs,
  SysUtils,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Printers,
  StdCtrls,
  Buttons,
  ExtCtrls,
  OOMisc;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    BitBtn2: TBitBtn;
    RadioGroup1: TRadioGroup;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
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

procedure TForm1.RadioGroup1Click(Sender: TObject);
var
   Device, Name, Port: array[0..100] of Char;
   DevMode: THandle;
   PrinterName : string;
begin
  with Printer do begin
    if Printers.Count < 1 then begin
      MessageDlg('There are no printer drivers available...',mtinformation,[mbok],0);
      Exit;
    end;

    Case Radiogroup1.Itemindex of
       {sets printer to the Default Windows Printer...}
       0: Printerindex := -1;

       1: begin
       { The following line of code does not fully initialize the selected   }
       { printer as the current printer (when it is not the Default Printer) }
       { using the Printerindex property. Output seems to be based on the    }
       { Default Windows Printer. }
            if IsWinNT then
              { NT/2K printer name is just the printer name }
              PrinterName := ApdDef32PrinterName
            else
              {9x/ME printer name is the printer name and the port }
              PrinterName := ApdDef16PrinterName + ' on ' + ApdDefPrinterPort + ':';
            PrinterIndex := Printers.IndexOf(PrinterName);

       { Adding the following lines including the GetPrinter and SetPrinter  }
       { methods seem to force the selected printer (when it is not the      }
       { Default Printer) to be fully initialized as the current printer and }
       { output is printed properly. }
           GetPrinter(Device, Name, Port, DevMode);
           SetPrinter(Device, Name, Port, 0);
       end;
    end;
    Edit1.text := Printers[Printerindex];
  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Print;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.ShowHint := True;
  Edit1.text := Printer.Printers[Printer.Printerindex];
end;

end.
