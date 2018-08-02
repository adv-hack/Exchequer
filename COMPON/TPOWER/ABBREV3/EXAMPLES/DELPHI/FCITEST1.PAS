unit FCITest1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AbCabKit{, TestCab};

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  OpenDialog1.Filename := '*.cab';
  if OpenDialog1.Execute then begin
    Memo1.Clear;
    MakeCab(OpenDialog1.Filename);
    Memo1.Lines.Assign(TestCab.AuditTrail);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i : Integer;
begin
  OpenDialog1.Filename := '*.*';
  if OpenDialog1.Execute then
    if OpenDialog1.Files.Count > 0 then
      for i := 0 to Pred(OpenDialog1.Files.Count) do begin
        try
          AddFile(OpenDialog1.Files[i]);
        finally
        end;
      end;
  Memo1.Lines.Assign(TestCab.AuditTrail);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  CloseArchive;
  Memo1.Lines.Assign(TestCab.AuditTrail);
end;

end.
