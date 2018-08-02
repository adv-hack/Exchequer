unit bitmpopt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TForm_BitmapOptions = class(TForm)
    OpenDialog1: TOpenDialog;
    ScrollBox1: TScrollBox;
    Image_Bitmap: TImage;
    Button_Ok: TButton;
    Button_Cancel: TButton;
    Button3: TButton;
    procedure Image_BitmapDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button_OkClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Ok : Boolean;
  end;

var
  Form_BitmapOptions: TForm_BitmapOptions;

implementation

{$R *.DFM}

procedure TForm_BitmapOptions.FormCreate(Sender: TObject);
begin
  Ok := False;
end;

procedure TForm_BitmapOptions.Button_OkClick(Sender: TObject);
begin
  If (OpenDialog1.FileName <> '') Then Begin
    Ok := True;
    Close;
  End { If }
  Else
    MessageDlg ('A Bitmap must be loaded before the details can be saved',
                mtError,
                [mbOk],
                0);
end;

procedure TForm_BitmapOptions.Button_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_BitmapOptions.Image_BitmapDblClick(Sender: TObject);
begin
  OpenDialog1.Execute;

  If (OpenDialog1.FileName <> '') Then
    Image_Bitmap.Picture.LoadFromFile (OpenDialog1.FileName);
end;

end.
