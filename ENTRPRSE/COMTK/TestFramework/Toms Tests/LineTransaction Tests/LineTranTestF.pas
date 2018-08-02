unit LineTranTestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, enterprise04_tlb;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
  public
    { Public declarations }
  protected
      procedure RunTest; override;
      procedure ChangeToolkitSettings; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

procedure TfrmTestTemplate1.ChangeToolkitSettings;
begin
  case StrToInt(FExtraParam) of
    30204 : oToolkit.Configuration.AutoSetPeriod := false;
    30107 : oToolkit.Configuration.DefaultVATCode := '';
  end;
end;

procedure TfrmTestTemplate1.RunTest;
var
  Res : integer;
  oTrans : ITransaction;
  flag : boolean;
begin
   flag := true;
   with oToolkit.Transaction do
   begin
      oTrans := Add(dtSOR);
      with oTrans do
      begin
        thAcCode := 'ABAP01';

        ImportDefaults;
        thTransDate := FormatDateTime('yyyymmdd', Date);

        with thLines.Add do
        begin
          tlStockCode := 'BAT-9PP3-ALK';
          tlQty := 20;
          tlGLCode := 52010;
          tlNetValue := 100;
          tlCostCentre := 'AAA';
          tlDepartment := '#01';
          tlLocation := 'AAA';

          case StrToInt(FExtraParam) of
            30202 : thAcCode := 'notAnAccountCode';
            30203 : thTransDate := '20119999';
            30204 : thPeriod := 99;
            30200 : tlVatCode := 'fixme';
            30211 : thJobCode := 'NotaJobCode';
            30212 : thAnalysisCode := 'NotAnalysisCode';
            30104 : tlGLCode := 0;
            30105 : tlCostCentre := 'NotACostCenter';
                   //tlDepartment := 'NotADepartment';
            30106 : tlStockCode := 'STO-CKCO-DEEE';
            30107 : tlVatCode := '?';
            30108 : tlDiscFlag := '!';
            30109 : flag := false;
            30111 : begin
                      tlJobCode := 'ThisIsntAJobCode';
                      tlAnalysisCode := 'B-DIRECT'
                    end;
            30115 : tlLocation := 'NotALocation';
            30121 : tlVATCode := 'fixme';//fixme
            30126 : begin
                      tlJobCode := 'TAI-IN1';
                      tlAnalysisCode := 'B-DIRECT';
                    end;
            else
             ShowMessage(Format('Unrecognised input %d/%s',[StrToInt(FExtraParam), FExtraParam]));
          end;
          Save;
        end;
      end;

    FResult := oTrans.Save(flag);
   end;
end;
end.
