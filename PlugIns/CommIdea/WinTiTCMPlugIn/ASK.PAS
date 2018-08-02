unit ASK;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IAeverButton;

type
  TFrmCheckSig = class(TForm)
    btnOK: TIAeverButton;
    Label1: TLabel;
    Label2: TLabel;
    IAeverButton1: TIAeverButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCheckSig: TFrmCheckSig;

implementation
uses
  GfxUtil, JPeg;

{$R *.dfm}

procedure TFrmCheckSig.FormCreate(Sender: TObject);
var
  TmpJPEG : TJPEGImage;
  bitFormBackground : TBitmap;
begin
  if ColorMode(canvas) in [cm64Bit, cm32Bit, cm24Bit, cm16Bit] then begin
    {Load Background JPEG}
    TmpJPEG := TJPEGImage.Create;
    bitFormBackground := TBitmap.create;
    if LoadJPEGFromRes('FORMBAK2', TmpJPEG) then begin
      bitFormBackground.Assign(TmpJPEG);
      DrawFormBackground(self, bitFormBackground);
    end;{if}
    TmpJPEG.Free;
    bitFormBackground.Free;
  end;{if}
end;

end.
