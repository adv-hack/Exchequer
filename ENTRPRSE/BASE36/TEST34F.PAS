unit Test34F;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    ListBox1: TListBox;
    btnTest: TButton;
    Button1: TButton;
    procedure btnTestClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

Uses Base34;

procedure TForm2.btnTestClick(Sender: TObject);
Var
  EncStr           : ShortString;
  OK, OK2, OK3     : Boolean;
  I, DecNum        : LongInt;
begin
  For I := 0 To 2000{1336335} Do Begin
  // 2 - Need to randomize the characters so they aren't sequential

    OK  := Encode34LI (I, EncStr);
    OK2 := Decode34LI (EncStr, DecNum);
    OK3 := I = DecNum;

    //If (Not OK) or (Not OK2) Or (Not OK3) Then
    //If (Not OK) or (Not OK2) Or (Not OK3) Or (I Mod 5 = 0) Then
      ListBox1.Items.Add (Format ('%7d   %4s   %7d   %1d  %1d  %1d',
                                  [I,
                                   EncStr,
                                   DecNum,
                                   Ord(OK),
                                   Ord(OK2),
                                   Ord(OK3)]));

    If ((I Mod 100) = 0) Then btnTest.Caption := IntToStr(I);
  End; { For }

  btnTest.Caption := '&Test';
  ShowMessage ('Done');
end;

procedure TForm2.Button1Click(Sender: TObject);
Var
  I : Byte;

  Function TwoToThe (Const Power:Byte): LongInt;
  Var
    I : Byte;
  Begin { TwoToThe }
    Result := 1;

    If (Power>1) Then
      For I := 2 To Power Do
        Result := Result * 2;
  End; { TwoToThe }

begin
  For I := 1 To 32 Do
    ListBox1.Items.Add (Format ('%2d   %10d',
                                [I, TwoToThe(I)]));
end;

end.
