unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TByteArr = array of byte;

  TForm1 = class(TForm)
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button2Click(Sender: TObject);
  private
    function StrToByte(const AValue: String): TByteArr;
    function GetHaseValue(const AValue: String): String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Mem_util, Hash, SHA3_256;

{$R *.dfm}

{ TForm1 }

function TForm1.StrToByte(const AValue: String): TByteArr;
begin
  SetLength(Result, Length(AValue));
  if Length(Result) > 0 then
    Move(AValue[1], Result[0], Length(Result));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Edit2.Text := '';
  Edit2.Text := GetHaseValue(Edit1.Text);
end;

function TForm1.GetHaseValue(const AValue: String): String;
var
  lBufByte: TByteArr;
  //Context: THashContext;
  Digest: TSHA3_256Digest;
begin
  //Convert String in to Bytes
  lBufByte := StrToByte(AValue);

  SHA3_256Full(Digest, lBufByte, Length(lBufByte));

  //HexStr is in mem_utils unit from the same CRC/Hash library
  Result := HexStr(@Digest, SizeOf(Digest));

  //Online Output check
  //http://emn178.github.io/online-tools/sha3_256.html
end;

end.
