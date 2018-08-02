unit CheckPrinterF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ImgList;

type
  TfrmInvalidPrinter = class(TForm)
    IconImage24Bit: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblDefaultPrinter: TLabel;
    IconImage16Col: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function CheckPrintersOK : Boolean;

implementation

{$R *.DFM}

Uses RPDevice, GfxUtil;


// Checks the RpDev.DeviceIndex to see if a valid default printer
// was found.  Returns True if OK to run Enterprise, False to shutdown.
Function CheckPrintersOK : Boolean;
var
  frmInvalidPrinter : TfrmInvalidPrinter;
  DeviceBuf         : PChar;
Begin { CheckPrintersOK }
  // Default Printer is invalid if DeviceIndex = -2
  Result := (RpDev.DeviceIndex <> -2);

  If (Not Result) Then Begin
    DeviceBuf := StrAlloc(255);
    Try
      GetProfileString('WINDOWS','DEVICE','',DeviceBuf, 255);

      // Invalid Default Printer - Display Warning dialog
      With TfrmInvalidPrinter.Create (Application) Do
        Try
          lblDefaultPrinter.Caption := Copy (DeviceBuf, 1, Pos (',', DeviceBuf) - 1);

          Result := (ShowModal = mrOK);
        Finally
          Free;
        End;
    Finally
      StrDispose(DeviceBuf);
    End;
  End; { If (Not Result) }
End; { CheckPrintersOK }

procedure TfrmInvalidPrinter.FormCreate(Sender: TObject);
begin
  Case ColorMode(Canvas) of
    cm256Colors, cm16Colors, cmMonochrome : begin
      IconImage16Col.Visible := TRUE;
      IconImage24Bit.Visible := FALSE;
      IconImage24Bit.Picture := nil;
    end;

    else begin
      IconImage16Col.Visible := FALSE;
      IconImage24Bit.Visible := TRUE;
      IconImage16Col.Picture := nil;
    end;
  end;{case}
end;

end.
