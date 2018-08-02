unit UpdateTransF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    FStockCode : string;
    FQty : Double;
    FValue : Double;
    FAction : Word;
    FSerialPrefix : string;
    DocType : TDocTypes;
  protected
    procedure RunTest; override;
    procedure UpdateTrans;
  public
    { Public declarations }
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}


{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.UpdateTrans;
var
  TransO : ITransaction;
  i : integer;
begin
  with oToolkit do
  begin
    Transaction.Index := thIdxOurRef;
    FResult := Transaction.GetLessThanOrEqual(FExtraParam + 'ZZZZZZ');
    if FResult = 0 then
    begin
      TransO := Transaction.Update;

      if Assigned(TransO) then
      begin
        for i := 1 to TransO.thLines.thLineCount do
        begin
          TransO.thLines[i].tlJobCode := 'TAI-IN1';
          TransO.thLines[i].tlAnalysisCode := 'B-ELECENG';
        end;

        FResult := TransO.Save(True);
      end
      else
        FResult := -1;
    end;
  end;

  // Remove reference to Transaction Object to destroy it
  TransO := nil;
end;


procedure TfrmTestTemplate1.RunTest;
begin
  UpdateTrans;
end;

end.
