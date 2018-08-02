unit CodeFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, StrUtil, TEditVal, ExtCtrls, APIUtil;

type
  TfCode = class(TFrame)
    lName: TLabel;
    edCode1: TCurrencyEdit;
    edCode2: TCurrencyEdit;
    edCode3: TCurrencyEdit;
    edCode4: TCurrencyEdit;
    edCode5: TCurrencyEdit;
    edCode6: TCurrencyEdit;
    edCode7: TCurrencyEdit;
    edCode8: TCurrencyEdit;
    Shape1: TShape;
    procedure edCodeExit(Sender: TObject);
  private
    { Private declarations }
  public
    procedure FillCodes(Codes : string8);
    procedure GetCodes(var Codes : string8);
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TfCode }

procedure TfCode.FillCodes(Codes: string8);
begin
  if length(Codes) > 0 then edCode1.Value := Ord(Codes[1]);
  if length(Codes) > 1 then edCode2.Value := Ord(Codes[2]);
  if length(Codes) > 2 then edCode3.Value := Ord(Codes[3]);
  if length(Codes) > 3 then edCode4.Value := Ord(Codes[4]);
  if length(Codes) > 4 then edCode5.Value := Ord(Codes[5]);
  if length(Codes) > 5 then edCode6.Value := Ord(Codes[6]);
  if length(Codes) > 6 then edCode7.Value := Ord(Codes[7]);
  if length(Codes) > 7 then edCode8.Value := Ord(Codes[8]);
end;

procedure TfCode.GetCodes(var Codes: string8);

  function GetChar(rValue : integer) : Char;
  var
    iByte : byte;
  begin
    iByte := Trunc(rValue);
    Result := CHR(iByte);
  end;

var
  iNewLength : byte;
begin
{
  Codes := '';
  Codes[1] := GetChar(edCode1.Value);
  Codes[2] := GetChar(edCode2.Value);
  Codes[3] := GetChar(edCode3.Value);
  Codes[4] := GetChar(edCode4.Value);
  Codes[5] := GetChar(edCode5.Value);
  Codes[6] := GetChar(edCode6.Value);
  Codes[7] := GetChar(edCode7.Value);
  Codes[8] := GetChar(edCode8.Value);
}
  // Define new length
  iNewLength := 0;
  if StrToIntDef(edCode1.Text, 0) <> 0 then iNewLength := 1;
  if StrToIntDef(edCode2.Text, 0) <> 0 then iNewLength := 2;
  if StrToIntDef(edCode3.Text, 0) <> 0 then iNewLength := 3;
  if StrToIntDef(edCode4.Text, 0) <> 0 then iNewLength := 4;
  if StrToIntDef(edCode5.Text, 0) <> 0 then iNewLength := 5;
  if StrToIntDef(edCode6.Text, 0) <> 0 then iNewLength := 6;
  if StrToIntDef(edCode7.Text, 0) <> 0 then iNewLength := 7;
  if StrToIntDef(edCode8.Text, 0) <> 0 then iNewLength := 8;

  // Add all 8 bytes into the string
  Codes := GetChar(StrToIntDef(edCode1.Text, 0)) + GetChar(StrToIntDef(edCode2.Text, 0))
  + GetChar(StrToIntDef(edCode3.Text, 0)) + GetChar(StrToIntDef(edCode4.Text, 0))
  + GetChar(StrToIntDef(edCode5.Text, 0)) + GetChar(StrToIntDef(edCode6.Text, 0))
  + GetChar(StrToIntDef(edCode7.Text, 0)) + GetChar(StrToIntDef(edCode8.Text, 0));

  // trim string to correct length
  Codes := Copy(Codes,1,iNewLength);
end;

procedure TfCode.edCodeExit(Sender: TObject);
begin
  if StrToIntDef(TCurrencyEdit(Sender).Text, 0) > 255
  then begin
    TCurrencyEdit(Sender).Value := 0;
    MsgBox('An invalid code has been entered, and will be deleted.',mtError,[mbOK],mbOK,'Invalid Code');
  end;
end;

end.
