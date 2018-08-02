unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OoMisc, AdPort, Spin;

type
  TForm1 = class(TForm)
    cmbComNo: TComboBox;
    Button1: TButton;
    edSend: TEdit;
    edChar: TSpinEdit;
    btnSendChar: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    ApdComPort1: TApdComPort;
    Button8: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btnSendCharClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ApdComPort1.ComNumber := cmbComNo.ItemIndex + 1;
  ApdComPort1.Baud := 9600;
  ApdComPort1.Open := TRUE;
  ApdComPort1.PutString(edSend.Text);
  ApdComPort1.Open := FALSE;
end;

procedure TForm1.btnSendCharClick(Sender: TObject);
begin
  ApdComPort1.ComNumber := cmbComNo.ItemIndex + 1;
  ApdComPort1.Baud := 9600;
  ApdComPort1.Open := TRUE;
  ApdComPort1.PutString(Char(edChar.Value));
  ApdComPort1.Open := FALSE;
end;

procedure TForm1.Button2Click(Sender: TObject);
const
  sTheString ='Neil';
var
  iStrLen, iPos : integer;
begin
  ApdComPort1.ComNumber := cmbComNo.ItemIndex + 1;
  ApdComPort1.Baud := 9600;
  ApdComPort1.Open := TRUE;
  iStrLen := Length(sTheString);
  For iPos := 1 to (40 - iStrLen - 1) do begin
    ApdComPort1.PutString(Char(12));
    ApdComPort1.PutString(Char(11));
    ApdComPort1.PutString(StringOfChar(' ', iPos - 1));
    ApdComPort1.PutString(sTheString);
//    ApdComPort1.PutString(StringOfChar(' ', 20 - iPos - iStrLen  + 1));
//    ApdComPort1.PutString(StringOfChar(' ', 19));
    Sleep(500);
  end;{for}
  ApdComPort1.Open := FALSE;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Button4Click(Sender: TObject);
// 11 = Home
// 12 = Clear
begin
  ApdComPort1.ComNumber := cmbComNo.ItemIndex + 1;
  ApdComPort1.Baud := 9600;
  ApdComPort1.Open := TRUE;
  ApdComPort1.PutString(Char(11));
  ApdComPort1.Open := FALSE;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  ApdComPort1.ComNumber := cmbComNo.ItemIndex + 1;
  ApdComPort1.Baud := 9600;
  ApdComPort1.Open := TRUE;
  ApdComPort1.PutString(Char(27) + '=' + Char(3));
  ApdComPort1.Open := FALSE;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  ApdComPort1.ComNumber := cmbComNo.ItemIndex + 1;
  ApdComPort1.Baud := 9600;
  ApdComPort1.Open := TRUE;
  ApdComPort1.PutString(Char(27) + '=' + Char(2));
  ApdComPort1.Open := FALSE;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  ApdComPort1.ComNumber := cmbComNo.ItemIndex + 1;
  ApdComPort1.Baud := 9600;
  ApdComPort1.Open := TRUE;
  ApdComPort1.PutString(Char(27) + '=' + Char(1));
  ApdComPort1.Open := FALSE;
end;

procedure TForm1.Button8Click(Sender: TObject);
const
  sTest = '1234567890abcdefghijabcdefghij1234567890';
var
  iPos : integer;
begin
  ApdComPort1.ComNumber := cmbComNo.ItemIndex + 1;
  ApdComPort1.Baud := 9600;
  ApdComPort1.Open := TRUE;
  ApdComPort1.PutString(Char(12));
  For iPos := 1 to length(sTest) do begin
    ApdComPort1.PutString(sTest[iPos]);
    sleep(1);
  end;
  ApdComPort1.Open := FALSE;
end;

end.
