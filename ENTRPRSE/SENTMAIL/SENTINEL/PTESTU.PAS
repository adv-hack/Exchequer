unit ptestu;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Str200 = AnsiString;

  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


function ReplaceFormulae(var FString : Str200;
                         const Evaluate : Boolean) : Boolean;
var
  s, s1, s2 : AnsiString;
  i, j, k : integer;
  b : Byte;
  BracketCount : SmallInt;
  NeedRecurse : Boolean;

  procedure ProcessResult(var AString : AnsiString);
  var
    h : integer;
  begin
    //Remove commas
    h := 1;
    while (h < Length(AString)) do
    begin
      if AString[h] = ',' then
        Delete(AString, h, 1)
      else
        inc(h);
    end;
    //move minus sign from back to front
    if AString[Length(AString)] = '-' then
      AString := '-' + Copy(AString, 1, Length(AString) - 1);
  end;

  function BracketString(const s : AnsiString) : AnsiString;
  begin
    if Length(s) > 0 then
      Result := '(' + s + ')'
    else
      Result := s;
  end;

begin
  IsEvaluation := Evaluate;
  Result := True;
  i := 1;
  j := i;
  BracketCount := 0;
  s := '';
  Result := True;
  while (i < Length(FString)) and Result do
  begin
    Application.ProcessMessages;
    while (i < Length(FString)) and (FString[i] <> '(') do inc(i);

    if FString[i] = '(' then
     inc(BracketCount);

    if i = 1 then
      s := s + Copy(FString, j + 1, i - j)
    else
    if i = Length(FString) then
      s := s + Copy(FString, j, i - j + 1)
    else
      s := s + Copy(FString, j, i - j);


    j := i;

    while (i < Length(FString)) and (BracketCount <> 0) do
    begin
      inc(i);
      if FString[i] = '(' then
      begin
        inc(BracketCount);
        NeedRecurse := True;
      end;

      if FString[i] = ')' then
        dec(BracketCount);
    end;


    if i <= Length(FString) then
    begin
      s1 := Copy(FString, j + 1, i - j - 1);

      if NeedRecurse then
        xReplaceFormulae(s1, False);


      if (Length(s1) > 0) and
         (Pos('=', s1) = 0) and
         (Pos('>', s1) = 0) and
         (Pos('<', s1) = 0) and
         (Pos(' AND ', s1) = 0) and
         (Pos(' OR ', s1) = 0) then
      begin

        s2 := SetFormula(s1, 2, b, IsEvaluation);

        Result := not FormulaErr;

        ProcessResult(s2);

        s := s + s2;
      end
      else
        s := s + BracketString(s1);

      j := i + 1;

    end;

  end;

  if Result then
    FString := s;
end;



procedure TForm1.Button1Click(Sender: TObject);
var
  s : AnsiString;
begin
  s := Edit1.Text;
  xReplaceFormulae(s, false);
  Edit2.Text := s;
end;

end.
