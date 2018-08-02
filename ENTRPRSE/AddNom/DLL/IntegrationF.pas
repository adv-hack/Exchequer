unit IntegrationF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uExDatasets, uComTKDataset, ExtCtrls, uMultiList,
  uDBMultiList;

type
  TfrmIntegration = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    DBMultiList1: TDBMultiList;
    ComTKDataset1: TComTKDataset;
    btnCustomers: TButton;
    btnStock: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCustomersClick(Sender: TObject);
    procedure GetCustomerFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure btnStockClick(Sender: TObject);
    procedure GetStockFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
  private
    { Private declarations }
    procedure KillDozer;
    function PrepareForData : Boolean;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses Enterprise01_TLB;

Var
  oToolkit : IToolkit;

procedure TfrmIntegration.FormCreate(Sender: TObject);
begin
  ClientHeight := 204;
  ClientWidth := 460;
end;

procedure TfrmIntegration.KillDozer;
begin
  // Must do check otherwise can get weird error
  If DBMultiList1.Active Then DBMultiList1.Active := False;
  ComTKDataset1.ToolkitObject := NIL;
  oToolkit := NIL;
end;

procedure TfrmIntegration.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  KillDozer;
end;

procedure TfrmIntegration.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // This doesn't seem to get called but CloseQuery & FormDestroy are
  KillDozer;
  Action := caFree;
end;

procedure TfrmIntegration.FormDestroy(Sender: TObject);
begin
  KillDozer;
end;

function TfrmIntegration.PrepareForData : Boolean;
Var
  lRes : LongInt;
Begin // PrepareForData
  DBMultiList1.Active := False;

  If (Not Assigned(oToolkit)) Then
  Begin
    oToolkit := CoToolkit.Create;
    // Needs to pickup path from customisation object
    oToolkit.Configuration.DataDirectory := ExtractFilePath(Application.Exename);
    lRes := oToolkit.OpenToolkit;
    If (lRes <> 0) Then
    Begin
      ShowMessage ('OpenToolkit: ' + IntToStr(lRes));
      oToolkit := NIL;
    End; // If (lRes <> 0)
  End; // (Not Assigned(oToolkit))

  Result := Assigned(oToolkit);
End; // PrepareForData

procedure TfrmIntegration.btnCustomersClick(Sender: TObject);
begin
  If PrepareForData Then
  Begin
    ComTKDataset1.ToolkitObject := oToolkit.Customer As IBtrieveFunctions2;
    ComTKDataset1.OnGetFieldValue := GetCustomerFieldValue;
    DBMultiList1.Active := True;
  End; // If PrepareForData
end;

procedure TfrmIntegration.GetCustomerFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
begin
  With ID As IAccount Do
  Begin
    Case FieldName[1] Of
      '0' : FieldValue := acCode;
      '1' : FieldValue := acCompany;
    End; // Case FieldValue[1]
  End; // With ID As IAccount
end;

procedure TfrmIntegration.btnStockClick(Sender: TObject);
begin
  If PrepareForData Then
  Begin
    ComTKDataset1.ToolkitObject := oToolkit.Stock As IBtrieveFunctions2;
    ComTKDataset1.OnGetFieldValue := GetStockFieldValue;
    DBMultiList1.Active := True;
  End; // If PrepareForData
end;

procedure TfrmIntegration.GetStockFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
begin
  With ID As IStock Do
  Begin
    Case FieldName[1] Of
      '0' : FieldValue := stCode;
      '1' : FieldValue := stDesc[1];
    End; // Case FieldValue[1]
  End; // With ID As IAccount
end;

end.
