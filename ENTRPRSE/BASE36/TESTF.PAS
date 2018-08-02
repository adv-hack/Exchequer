unit TestF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    btnTest: TButton;
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses Base36;

procedure TForm1.btnTestClick(Sender: TObject);
Var
  EncStr      : ShortString;
  OK, OK2     : Boolean;
  I, DecNum   : LongInt;
begin
  For I := 1679000 To 1680000 Do Begin
    OK  := Encode36 (I, EncStr);
    OK2 := Decode36 (EncStr, DecNum);

    {If (I <> DecNum) Or (Not OK) Or (Not OK2) Then Begin}
    {If ((I Mod 60) = 4) Then Begin}
      ListBox1.Items.Add (Format ('%7d   %4s   %7d   %1d  %1d',
                                  [I,
                                   EncStr,
                                   DecNum,
                                   Ord(OK),
                                   Ord(OK2)]));
    //End; { If }

    If ((I Mod 25) = 0) Then btnTest.Caption := IntToStr(I);
  End; { For }

  btnTest.Caption := '&Test';
  ShowMessage ('Done');
end;

end.
