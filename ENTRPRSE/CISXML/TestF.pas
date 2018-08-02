unit TestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CISWrite, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  with TCISXMLReturn.Create do
  Try
    ProductVersion := '5.71';
    SenderID := 'ABCDEFGH';
    SenderAuthentication := '1234';
    TaxOfficNumber := '888';
    TaxOfficeReference := 'IJKLMNOP';
    VendorID := 'QRST';
    ContractorUTR := '123456789';
    ContractorAORef := '987654321';
    Year := 2006;
    Month := 8;

    EmploymentStatus := True;
    SubContractorVerification := False;
    
    with SubContractors.Add do
    begin
//      TradingName := 'Aardvark';
      Surname := 'Rutherford';
      Forename1 := 'Paul';
      Forename2 := 'Samuel';
      UTR := '123459876';
      NINO := 'TY460304B';
      VerificationNumber := '554433';
      TotalPayments := 746.25;
      TotalDeducted := 123.45;
      CostOfMaterials := 201.00;
    end;
    WriteXMLToFile('c:\cistest.xml');
//    ShowMessage('IR Mark: ' + QuotedStr(IRMark));
  Finally
    Free;
  End;
end;

end.
