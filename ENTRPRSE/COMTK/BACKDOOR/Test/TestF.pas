unit TestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edtNum: TEdit;
    Button1: TButton;
    edtNum1: TEdit;
    edtNum3: TEdit;
    edtNum2: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses SecCodes;

procedure TForm1.Button1Click(Sender: TObject);
Var
  OpCode : Integer;
  Long1, Long2, Long3 : LongInt;
begin
  OpCode := StrToIntDef(edtNum.Text, 0);
  If (OpCode > 0) And (OpCode <= 220) Then
  Begin
    // Converts an OpCode into three encoded Long Integers which can be
    // internally validated and decoded using the DecodeOpCode function below
    EncodeOpCode (OpCode, Long1, Long2, Long3);
    edtNum1.Text := IntToStr(Long1);
    edtNum2.Text := IntToStr(Long2);
    edtNum3.Text := IntToStr(Long3);
  End; // If (OpCode > 0) And (OpCode <= 220)
end;

end.
