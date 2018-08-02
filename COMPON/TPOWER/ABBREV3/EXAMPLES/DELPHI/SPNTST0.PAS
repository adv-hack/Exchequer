unit spntst0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,

  {IpStrms,}
  {StStrms,}

  AbBufStm, AbBase, AbBrowse, AbZBrows, AbZipper, AbZipKit,
  AbSpanSt, ExtCtrls;

type
  TForm1 = class(TForm)
    AbZipKit1: TAbZipKit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button3: TButton;
    Bevel1: TBevel;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DoRequestImage(Sender: TObject; ImageNumber: Integer;
      var ImageName: String; var Abort: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  Span: TAbSpanStream;
  SrcFile : TFileStream;
  Src, Dest : string;
begin
  OpenDialog1.FileName := '*.*';
  OpenDialog1.Title := 'Select Source File';
  if OpenDialog1.Execute then begin
    Src := OpenDialog1.FileName;

    OpenDialog1.Title := 'Specify Destination File';
    if OpenDialog1.Execute then begin
      Dest := OpenDialog1.FileName;
      Span := TAbSpanStream.Create(Dest, fmCreate);
      SrcFile := TFileStream.Create(Src, fmOpenRead);

      Span.CopyFrom(SrcFile, SrcFile.Size);

      Span.Free;
      SrcFile.Free;

    end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Span: TAbSpanStream;
  DestFile : TFileStream;
  Src, Dest : string;
begin
  OpenDialog1.FileName := '*.*';
  OpenDialog1.Title := 'Select Source File';
  if OpenDialog1.Execute then begin
    Src := OpenDialog1.FileName;

    SaveDialog1.Title := 'Specify Destination File';
    if SaveDialog1.Execute then begin
      Dest := SaveDialog1.FileName;
      Span := TAbSpanStream.Create(Src, fmOpenRead);
      Span.SpanType := stLocal;

      Span.OnRequestImage := DoRequestImage;
      DestFile := TFileStream.Create(Dest, fmCreate);

      DestFile.CopyFrom(Span, 3145728{Span.Size});

      Span.Free;
      DestFile.Free;
    end;
  end;
end;

procedure TForm1.DoRequestImage(Sender: TObject;
  ImageNumber: Integer; var ImageName: String; var Abort: Boolean);
begin
  Abort := not OpenDialog1.Execute;
  if not Abort then
    ImageName := OpenDialog1.FileName;
end;

end.
