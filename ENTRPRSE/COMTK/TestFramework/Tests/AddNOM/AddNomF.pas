unit AddNomF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FLines : TStringList;
    procedure LoadLines(const oTrans : ITransaction);
  protected
    procedure RunTest; override;
    procedure AddNominal;
  public
    { Public declarations }
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

uses
  CtkUtil04, TestConst;

const
  F_GLCODE = 0;
  F_CURRENCY = 1;
  F_DAILY_RATE = 2;
  F_COMPANY_RATE = 3;
  F_VALUE = 4;

  S_INI_FILE_NAME = 'AddNom.csv';

  S_COST_CENTRE = 'AAA';
  S_DEPARTMENT = 'AAA';

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddNominal;
var
  TransO : ITransaction;
  Res    : SmallInt;
begin
  FLines := TStringList.Create;
  Try
    FLines.LoadFromFile(FExtraParam);
  Except
    FWParam := E_FILE_NOT_FOUND;
  End;

  if FWParam = E_SUCCESS then
  begin
    // Create an Add Transaction object for a NOM
    TransO := oToolkit.Transaction.Add(dtNMT);

    with TransO do
    begin
      thTransDate := '20110602';
      // Bring in any NOM defaults
      ImportDefaults;

      LoadLines(TransO);

      // Save the Transaction - True = auto calculate totals
      FResult := Save(True);
    end; // With TransO

    // Remove reference to Transaction Object to destroy it
    TransO := nil;
  end; //if FWParam = E_SUCCESS
end;

procedure TfrmTestTemplate1.RunTest;
begin
  AddNominal;
end;

procedure TfrmTestTemplate1.FormDestroy(Sender: TObject);
begin
  if Assigned(FLines) then
    FLines.Free;
  inherited;
end;

procedure TfrmTestTemplate1.LoadLines(const oTrans : ITransaction);
var
  i : Integer;
  AList : TStringList;
begin
  AList := TStringList.Create;
  Try
    for i := 1 to FLines.Count - 1 do
    begin
      AList.Clear;
      AList.CommaText := FLines[i];

      With oTrans.thLines.Add Do Begin
        // Description
        tlDescr := 'Line ' + IntToStr(i + 1);

        // GL Code
        tlGLCode := StrToInt(AList[F_GLCODE]);

        tlCurrency := StrToInt(AList[F_CURRENCY]);
        tlDailyRate := StrToFloat(AList[F_DAILY_RATE]);
        tlCompanyRate := StrToFloat(AList[F_COMPANY_RATE]);
        tlNetValue := StrToFloat(AList[F_VALUE]);

        // Miscellaneous
        tlCostCentre := S_COST_CENTRE;
        tlDepartment := S_DEPARTMENT;

        // Save Line into Transaction
        Save;
      End; // With thLines.Add

    end;
  Finally
    AList.Free;
  End;
end;

end.
