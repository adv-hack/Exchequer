unit sbsprint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TSBSPrintDialog = class(TPrintDialog)
  private
    { Private declarations }
    FPrinter : Integer;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean; override;
  published
    { Published declarations }
    property PrinterNo: Integer read FPrinter;
  end;

  TSBSPrinterSetupDialog = class(TPrinterSetupDialog)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    function Execute : Boolean; override;
  published
    { Published declarations }
  end;

Var
  InitialPrinters : Integer;

procedure Register;

implementation

Uses Printers;

procedure Register;
begin
  RegisterComponents('SBS', [TSBSPrintDialog, TSBSPrinterSetupDialog]);
end;



constructor TSBSPrintDialog.Create(AOwner: TComponent);
Begin
  Inherited Create (AOwner);

  FPrinter   := 0;
  Collate    := False;
  Copies     := 1;
  Options    := [poWarning];
  PrintRange := prAllPages;
End;

function TSBSPrintDialog.Execute: Boolean;
Var
  ADevice, ADriver, APort: PCHAR;
  ADeviceMode: THandle;
  I: Integer;
begin
  FPrinter := -1;

  Result := Inherited Execute;

  If Result Then Begin
    FPrinter := Printer.PrinterIndex;

    ADevice := StrAlloc (200);
    ADriver := StrAlloc (200);
    APort   := StrAlloc (200);
    Printer.GetPrinter (ADevice, ADriver, APort, ADeviceMode);

    With Printer Do
      If (InitialPrinters > 0) And (Printer.PrinterIndex > (InitialPrinters-1)) Then
        For I := 0 To (InitialPrinters - 1) Do
          If (Pos (ADevice, Printers[I]) = 1) Then Begin
            FPrinter := I;
            Break;
          End; { If }

    StrDispose (ADevice);
    StrDispose (ADriver);
    StrDispose (APort);
  End; { If }
End;


function TSBSPrinterSetupDialog.Execute : Boolean;
Var
  ADevice, ADriver, APort: PCHAR;
  ADeviceMode: THandle;
  I: Integer;
begin
  Result := Inherited Execute;

  If (Printer.PrinterIndex > (InitialPrinters-1)) Then Begin
    ADevice := StrAlloc (200);
    ADriver := StrAlloc (200);
    APort   := StrAlloc (200);
    Printer.GetPrinter (ADevice, ADriver, APort, ADeviceMode);

    With Printer Do
      If (InitialPrinters > 0) Then
        For I := 0 To (InitialPrinters - 1) Do
          If (Pos (ADevice, Printers[I]) = 1) Then Begin
            Printer.PrinterIndex := I;
            Break;
          End; { If }

    StrDispose (ADevice);
    StrDispose (ADriver);
    StrDispose (APort);
  End; { If }
End;

Initialization
  InitialPrinters := Printer.Printers.Count;
end.
