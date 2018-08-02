unit RSyncF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal;

type
  TForm1 = class(TForm)
    ccyISN1: TCurrencyEdit;
    ccyISN2: TCurrencyEdit;
    ccyISN3: TCurrencyEdit;
    ccyISN4: TCurrencyEdit;
    ccyISN5: TCurrencyEdit;
    ccyISN6: TCurrencyEdit;
    Button1: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses RSyncU;

procedure TForm1.Button1Click(Sender: TObject);
Var
  TheDate                   : Double;
  RSync, pRSync             : ShortString;
  I, E1, E2, E3, E4, E5, E6 : LongInt;
begin
  TheDate := EncodeDate (1999, 1, 1);

  E1 := Trunc(ccyISN1.Value);
  E2 := Trunc(ccyISN2.Value);
  E3 := Trunc(ccyISN3.Value);
  E4 := Trunc(ccyISN4.Value);
  E5 := Trunc(ccyISN5.Value);
  E6 := Trunc(ccyISN6.Value);

  pRSync := '';
  ListBox1.Clear;
  For I := 1 to 1000 Do Begin
    RSync := CalcRSysnc (TheDate, E1, E2, E3, E4, E5, E6);

    If (RSync <> pRSync) Then Begin
      ListBox1.Items.Add (FormatDateTime ('DD/MM/YYY',TheDate) + #9 + RSync);;
      pRSync := RSync;
    End; { If }

    TheDate := theDate + 1;
  End; { For I }
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ListBox1.Items.SaveToFile('c:\rsync.txt');
end;

end.
