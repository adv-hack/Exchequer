unit vatReturnDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, vatReturnDBManager;

type
  TfrmVAT100ReturnDetail = class(TForm)
    Panel4: TPanel;
    Label1: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Shape19: TShape;
    Shape20: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Shape26: TShape;
    Shape27: TShape;
    lblVatPeriod: TLabel;
    lblBox1: TLabel;
    lblBox2: TLabel;
    lblBox3: TLabel;
    lblBox4: TLabel;
    lblBox5: TLabel;
    lblBox6: TLabel;
    lblBox7: TLabel;
    lblBox8: TLabel;
    lblBox9: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label6: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fReturnRecord : TVATSubmissionRecord;
  public
    { Public declarations }
    procedure SetVATReturn(VATRecord : TVATSubmissionRecord);
  end;

var
  frmVAT100ReturnDetail: TfrmVAT100ReturnDetail;

implementation

uses
  vatUtils;

{$R *.dfm}

procedure TfrmVAT100ReturnDetail.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmVAT100ReturnDetail.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  frmVAT100ReturnDetail := nil;
end;

procedure TfrmVAT100ReturnDetail.SetVATReturn(VATRecord : TVATSubmissionRecord);
begin
  fReturnRecord := VATRecord;

  // Set the field values
  self.lblVatPeriod.Caption        := FormatVatPeriod(fReturnRecord.vatPeriod);

  self.lblBox1.Caption := FormatVatValue_Double(fReturnRecord.vATDueOnOutputs);
  self.lblBox2.Caption := FormatVatValue_Double(fReturnRecord.vATDueOnECAcquisitions);
  self.lblBox3.Caption := FormatVatValue_Double(fReturnRecord.vATTotal);
  self.lblBox4.Caption := FormatVatValue_Double(fReturnRecord.vATReclaimedOnInputs);
  self.lblBox5.Caption := FormatVatValue_Double(fReturnRecord.vATNet);
  self.lblBox6.Caption := FormatVatValue_Int(fReturnRecord.netSalesAndOutputs);
  self.lblBox7.Caption := FormatVatValue_Int(fReturnRecord.netPurchasesAndInputs);
  self.lblBox8.Caption := FormatVatValue_Int(fReturnRecord.  netECSupplies);
  self.lblBox9.Caption := FormatVatValue_Int(fReturnRecord.netECAcquisitions);
end;

end.
