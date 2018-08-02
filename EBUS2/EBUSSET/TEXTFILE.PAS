unit TextFile;

{ prutherford440 09:49 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, StrUtil;

type
  TTextFiles = (tfOrderOK, tfOrderFail, tfInvoiceOK, tfInvoiceFail);

const
  aMemoNames : array [tfOrderOK..tfInvoiceFail] of string = ('memOrderOK', 'memOrderFail', 'memInvoiceOK', 'memInvoiceFail');

type
  TfrmEditTextFiles = class(TForm)
    pcTextFiles: TPageControl;
    tsOrderOK: TTabSheet;
    tsOrderFail: TTabSheet;
    tsInvoiceOK: TTabSheet;
    tsInvoiceFail: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    memOrderOK: TMemo;
    memOrderFail: TMemo;
    memInvoiceOK: TMemo;
    memInvoiceFail: TMemo;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public
    aFilenames : array [tfOrderOK..tfInvoiceFail] of string12;
    { Public declarations }
  end;

var
  frmEditTextFiles: TfrmEditTextFiles;

implementation
uses
  SysSetup;

{$R *.DFM}

procedure TfrmEditTextFiles.FormShow(Sender: TObject);
var
  FilePos : TTextFiles;
  sFilename : string;
  AControl : TControl;
begin
  for FilePos := tfOrderOK to tfInvoiceFail do begin
    sFilename := (frmSystemSetup.sTextFileDir + aFilenames[FilePos]);
    AControl := pcTextFiles.Pages[Ord(FilePos)].FindChildControl(aMemoNames[FilePos]);
    if FileExists(sFilename) then
      begin
        if (AControl <> nil) and (AControl is TMemo) then TMemo(AControl).Lines.LoadFromFile(sFilename);
      end
    else begin
      pcTextFiles.Pages[Ord(FilePos)].Enabled := FALSE;
      AControl.Enabled := FALSE;
    end;{if}
  end;{for}

  pcTextFiles.ActivePageIndex := 0;
end;

procedure TfrmEditTextFiles.Button2Click(Sender: TObject);
var
  FilePos : TTextFiles;
  sFilename : string;
  AControl : TControl;
begin
  for FilePos := tfOrderOK to tfInvoiceFail do begin
    sFilename := (frmSystemSetup.sTextFileDir + aFilenames[FilePos]);
    if FileExists(sFilename) then begin
      AControl := pcTextFiles.Pages[Ord(FilePos)].FindChildControl(aMemoNames[FilePos]);
      if (AControl <> nil) and (AControl is TMemo) then TMemo(AControl).Lines.SaveToFile(sFilename);
    end;{if}
  end;{for}

  ModalResult := mrOK;
end;

end.
