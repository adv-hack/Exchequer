unit init;

{ markd6 14:23 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

implementation

Uses Forms, Windows, Dialogs, SysUtils, BtrvU2;


Procedure Wait4;
Var
  WaitTime : LongInt;

  { Returns time in seconds }
  Function TimeVal : LongInt;
  Var
    Hour, Min, Sec, MSec : Word;
  begin
    DecodeTime(Now, Hour, Min, Sec, MSec);

    Result := Sec + (60 * (Min + (Hour * 60)));
  end;

Begin
  WaitTime := TimeVal + 4;
  Repeat
    Application.ProcessMessages;
  Until TimeVal > WaitTime;
End;

begin
  If Check4BtrvOk Then MessageBeep (0);

  Wait4;
end.
