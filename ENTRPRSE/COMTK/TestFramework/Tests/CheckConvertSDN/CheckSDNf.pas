unit CheckSDNf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise04_TLB, TESTFORMTEMPLATE, StdCtrls;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.RunTest;
begin
  with oToolkit.Transaction as ITransaction2 do
  begin
    //Find the transaction we want to convert
    Index := thIdxOurRef;
    FResult := GetLessThanOrEqual(BuildOurRefIndex('SDN999999'));

    if FResult = 0 then
    begin
      with Convert(dtSIN) do
      begin
        FResult := Check;

      end; //with Convert
    end;
  end; // with oToolkit.Transaction
end;

end.
 