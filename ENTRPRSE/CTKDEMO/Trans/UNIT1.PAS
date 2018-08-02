unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComObj, Enterprise01_TLB;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    oTK      : IToolkit;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
Var
  Res : SmallInt;
begin
  oTK := CreateOLEObject ('Enterprise01.Toolkit') As IToolkit;

  With oTK Do Begin
    Configuration.DataDirectory := 'e:\ent432';//'m:\Dev500\';

    Res := OpenToolkit;
    If (Res = 0) Then
      With Transaction Do Begin
        Res := GetEqual (BuildOurRefIndex('ADJ000080')); //ADJ000084'));
        If (Res = 0) Then
          Functions.entBrowseObject(Transaction, True)
        Else
          ShowMessage ('GetEqual: ' + IntToStr(Res));
      End { With Transaction }
    Else
      ShowMessage ('OpenToolkit: ' + IntToStr(Res));

    CloseToolkit;
  End; { With }

  oTK := NIL;
end;

end.
 