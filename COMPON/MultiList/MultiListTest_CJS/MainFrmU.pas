unit MainFrmU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExDatasets, uSQLDatasets, ExtCtrls, uMultiList, uDBMultiList,
  StdCtrls, uBtrieveDataset, GlobVar, DB, ADODB, VarConst;

type
  TForm1 = class(TForm)
    DBMultiList1: TDBMultiList;
    OpenBtn: TButton;
    Label1: TLabel;
    SearchTxt: TEdit;
    SearchBtn: TButton;
    SQLDatasets1: TSQLDatasets;
    TimeToOpenSQLLbl: TLabel;
    DBMultiList2: TDBMultiList;
    Button1: TButton;
    BtrieveDataset1: TBtrieveDataset;
    SelectAllBtn: TButton;
    procedure OpenBtnClick(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure BtrieveDataset1GetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure Button1Click(Sender: TObject);
    procedure SelectAllBtnClick(Sender: TObject);
    procedure SQLDatasets1GetFieldValue(Sender: TObject; Dataset: TDataSet;
      FieldName: String; var FieldValue: Variant);
    procedure SQLDatasets1GetDisplayValue(Sender: TObject;
      Dataset: TDataSet; FieldName: String; var FieldValue: Variant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses DateUtils, SQLUtils;

{$R *.dfm}

procedure TForm1.OpenBtnClick(Sender: TObject);
var
  StartTime, FinishTime: TDateTime;
  Duration: Integer;
  ConnectionString: string;
begin
  if DBMultiList1.Active then
  begin
    TimeToOpenSQLLbl.Caption := '';
    DBMultiList1.Active := False;
    OpenBtn.Caption := '&Open';
  end
  else
  begin
    StartTime := Now;
    SQLUtils.GetCommonConnectionString(ConnectionString);
    SQLDatasets1.ConnectionString := ConnectionString;
    DBMultiList1.Active := True;
    FinishTime := Now;
    Duration := MilliSecondsBetween(FinishTime, StartTime);
    TimeToOpenSQLLbl.Caption := Format('Time to open: %d', [Duration]);
    OpenBtn.Caption := '&Close';
  end;
end;

procedure TForm1.SearchBtnClick(Sender: TObject);
begin
  DBMultiList1.SearchColumn(DBMultiList1.Col, True, SearchTxt.Text);
end;

procedure TForm1.BtrieveDataset1GetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  case StrToInt(FieldName) of
    0: FieldValue := CustRec(PData^).CustCode;
    1: FieldValue := CustRec(PData^).Company;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  DBMultiList2.Active := True;
end;

procedure TForm1.SelectAllBtnClick(Sender: TObject);
begin
  DBMultilist1.MultiSelectAll;
end;

procedure TForm1.SQLDatasets1GetFieldValue(Sender: TObject;
  Dataset: TDataSet; FieldName: String; var FieldValue: Variant);
begin
  if (FieldName = 'thNetValue') then
  begin
    FieldValue := FormatFloat('0.00', Dataset.FieldByName(FieldName).AsVariant);
  end
  else
    FieldValue := Dataset.FieldByName(FieldName).AsVariant;
end;

procedure TForm1.SQLDatasets1GetDisplayValue(Sender: TObject;
  Dataset: TDataSet; FieldName: String; var FieldValue: Variant);
begin
  try
    if (FieldName = 'thTransDate') then
    begin
      FieldValue := Dataset.FieldByName(FieldName).AsVariant;
      FieldValue := Copy(FieldValue, 7, 2) + '\' +
                    Copy(FieldValue, 5, 2) + '\' +
                    Copy(FieldValue, 1, 4);
    end
    else if (FieldName = 'thNetValue') then
    begin
      FieldValue := FormatFloat('0.00', Dataset.FieldByName(FieldName).AsVariant);
    end
    else
      FieldValue := Dataset.FieldByName(FieldName).AsVariant;
  except
    on E:Exception do
      FieldValue := 'Field look-up failed';
  end;
end;

end.
