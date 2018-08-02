unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExDatasets, uSQLDatasets, ExtCtrls, uMultiList, uDBMultiList,
  uBtrieveDataset, DB, pvtables, sqldataset, uBTRecords, StdCtrls;

type
  TForm1 = class(TForm)
    SQLList: TDBMultiList;
    SQLDatasets1: TSQLDatasets;
    BtrieveDataset1: TBtrieveDataset;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    BTrieveList: TDBMultiList;
    procedure BtrieveDataset1GetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure Button2Click(Sender: TObject);
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

procedure TForm1.BtrieveDataset1GetFieldValue(Sender: TObject; PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with TCustRec(PData^) do
  begin
    case StrToIntDef(FieldName, -1) of
      0: FieldValue:= CustCode;
      1: FieldValue:= Company;
      2: FieldValue:= Contact;
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  BtrieveDataset1.SearchKey:= 'C';
  BtrieveList.RefreshDB;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  BtrieveDataset1.SearchKey:= 'S';
  BtrieveList.RefreshDB;
end;

end.
