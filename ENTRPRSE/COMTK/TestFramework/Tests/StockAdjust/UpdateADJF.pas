unit UpdateADJF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    FCurrency : Boolean;
  public
    { Public declarations }
    procedure RunTest; override;
    procedure UpdateTSH;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.UpdateTSH;
var
  TransO : ITransaction;
begin
  oToolkit.Transaction.Index := thIdxOurRef;
  FResult := oToolkit.Transaction.GetLessThanOrEqual('ADJZZZZZZ');

  if FResult = 0 then
  begin
    TransO := oToolkit.Transaction.Update;

    if Assigned(TransO) then
    begin
      TransO.thLines[1].tlQty := -500;

      // Save the Transaction - True = auto calculate totals
      FResult := TransO.Save(True);
    end
    else
      FResult := -1;
  End; // With TransO

  // Remove reference to Transaction Object to destroy it
  TransO := Nil;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  UpdateTSH;
end;

end.
