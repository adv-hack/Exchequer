unit testcom1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComObj, Timesheets_tlb, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    FODD: IODDTimesheets;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 FODD := CreateOLEObject('IRISTimesheets.ODDTimesheets') as IODDTimesheets;
 FODD.Startup('EXCHODDTIM000201', '!f%h&4hj(%Fgh£^%');
end;

end.
