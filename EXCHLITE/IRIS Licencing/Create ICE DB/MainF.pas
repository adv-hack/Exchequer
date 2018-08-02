unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    btnJustDoIt: TButton;
    Memo1: TMemo;
    procedure btnJustDoItClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses ELITE_Com_TLB;

procedure TForm1.btnJustDoItClick(Sender: TObject);
Var
  oLicencing : IEliteCom;
begin
  oLicencing := CoLicensingInterface.Create;
  Try
    If oLicencing.InitialiseICEDB Then
      ShowMessage ('InitialiseICEDB: OK')
    Else
      ShowMessage ('InitialiseICEDB: Failed');
  Finally
    oLicencing := NIL;
  End; // Try..Finally
end;

end.
