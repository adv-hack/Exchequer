unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TEditVal, StdCtrls, TCustom, ExtCtrls, AddRec, ComObj, Enterprise01_TLB,
   EnterpriseBeta_TLB;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    ceCustSupp: TCurrencyEdit;
    ceStock: TCurrencyEdit;
    ceTrans: TCurrencyEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbSize: TSBSComboBox;
    Panel2: TPanel;
    btnGo: TSBSButton;
    btnClose: TSBSButton;
    lblRecType: Label8;
    lblRecProgress: Label8;
    Label4: TLabel;
    cbCompany: TSBSComboBox;
    Label5: TLabel;
    btnGLs: TSBSButton;
    procedure btnCloseClick(Sender: TObject);
    procedure cbSizeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnGLsClick(Sender: TObject);
  private
    { Private declarations }
    oToolkit : IToolkit;
    Running : Boolean;
    procedure AddAllRecords;
    procedure LoadCompanyList;
    procedure SetRecTypeLabel(const RecType : string);
    procedure AddRecords(Adder : TBaseAdder);
    procedure SetButtons(Enable : Boolean);
  public
    { Public declarations }
    procedure ShowProgress(Sender : TObject; CurrentRecord, TotalRecords : Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  CtkUtil, GLF;

const
  DbSizes : Array[0..2, 0..2] of Integer = ((500, 500, 1000),
                                            (1500, 1500, 3000),
                                            (4500, 4500, 9000));

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.ShowProgress(Sender: TObject; CurrentRecord, TotalRecords : Integer);
begin
  lblRecProgress.Caption := Format('Adding record %d of %d', [CurrentRecord, TotalRecords]);
  lblRecProgress.Refresh;
  Application.ProcessMessages;
end;

procedure TForm1.cbSizeChange(Sender: TObject);
var
  i : integer;
begin
  i := cbSize.ItemIndex;
  ceCustSupp.Value := DbSizes[i, 0];
  ceStock.Value := DbSizes[i, 1];
  ceTrans.Value := DbSizes[i, 2];
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Running := False;
  cbSizeChange(Self);
  oToolkit := CreateToolkitWithBackDoor;
  LoadCompanyList;
end;

procedure TForm1.AddAllRecords;
var
  AcAdder : TAccountAdder;
  StAdder : TStockAdder;
  TrAdder : TTransAdder;
begin
  AcAdder := TAccountAdder.Create;
  Try
    AcAdder.AccountType := atCustomer;
    AcAdder.RecordsToAdd := Trunc(ceCustSupp.Value);
    SetRecTypeLabel('customer');
    AddRecords(AcAdder);

    AcAdder.AccountType := atSupplier;
    SetRecTypeLabel('supplier');
    AddRecords(AcAdder);
  Finally
    AcAdder.Free;
  End;

  StAdder := TStockAdder.Create;
  Try
    StAdder.RecordsToAdd := Trunc(ceStock.Value);
    SetRecTypeLabel('stock');
    AddRecords(StAdder);
  Finally
    StAdder.Free;
  End;

  TrAdder := TTransAdder.Create;
  Try
    TrAdder.RecordsToAdd := Trunc(ceTrans.Value);
    TrAdder.NumberOfAccounts := Trunc(ceCustSupp.Value);
    SetRecTypeLabel('transaction');
    AddRecords(TrAdder);
  Finally
    TrAdder.Free;
  End;


end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  GLObject.Save;
  GLObject.Free;
  oToolkit := nil;
end;

procedure TForm1.LoadCompanyList;
//Loads list of company codes into company combobox
var
  i : integer;
begin
  with oToolkit.Company do
    for i := 1 to cmCount do
      cbCompany.Items.Add(cmCompany[i].coCode);
  cbCompany.ItemIndex := 0;
end;

procedure TForm1.btnGoClick(Sender: TObject);
var
  Res : Integer;
begin
  SetButtons(False);
  Try
    oToolkit.Configuration.DataDirectory :=
       CompanyPathFromCode(oToolkit, cbCompany.Items[cbCompany.ItemIndex]);
    oToolkit.Configuration.AutoSetPeriod := True;
    oToolkit.Configuration.OverwriteTransactionNumbers := True;
    oToolkit.Configuration.DefaultCurrency := 1;
    oToolkit.Configuration.AutoSetStockCost := True;


    Res := oToolkit.OpenToolkit;
    if Res = 0 then
    Try
      AddAllRecords;
      ShowMessage('Process Complete');
    Finally
      oToolkit.CloseToolkit;
    End
    else
      ShowMessage('Error opening COM toolkit: ' + QuotedStr(oToolkit.LastErrorString));
  Finally
    lblRecType.Caption := '';
    lblRecProgress.Caption := '';
    Application.ProcessMessages;
    SetButtons(True);
  End;
end;

procedure TForm1.AddRecords(Adder: TBaseAdder);
begin
  Adder.Toolkit := oToolkit;
  Adder.OnProgress := ShowProgress;
  Adder.Execute;
end;

procedure TForm1.SetRecTypeLabel(const RecType: string);
begin
  lblRecType.Caption := Format('Adding %s records. Please wait...', [RecType]);
  lblRecType.Refresh;
  Application.ProcessMessages;
end;

procedure TForm1.btnGLsClick(Sender: TObject);
begin
  with TfrmGLs.Create(Self) do
  Try
    LoadCodes;
    ShowModal;
    if ModalResult = mrOK then
      SaveCodes;
  Finally
    Free;
  End;
end;

procedure TForm1.SetButtons(Enable: Boolean);
begin
  btnGo.Enabled := Enable;
  btnGLs.Enabled := Enable;
  btnClose.Enabled := Enable;
  Running := not Enable;
end;

end.
