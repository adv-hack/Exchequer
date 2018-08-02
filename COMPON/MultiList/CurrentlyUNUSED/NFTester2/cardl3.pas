unit cardl3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExDatasets, uBTGlobalDataset, ExtCtrls, uMultiList,
  uDBMultiList, VarConst, BTrvu2, uBtrieveDataset, StdCtrls;

type
  TFrmCardList3 = class(TForm)
    BTGlobalDataset1: TBTGlobalDataset;
    DBMultiList2: TDBMultiList;
    BtrieveDataset1: TBtrieveDataset;
    Button1: TButton;
    DBMultiList1: TDBMultiList;
    procedure BTGlobalDataset1GetFieldValue(Sender: TObject;
      PData: Pointer; FieldName: String; var FieldValue: String);
    procedure BTGlobalDataset1GetDataRecord(Sender: TObject;
      var TheDataRecord: Pointer);
    procedure BTGlobalDataset1GetBufferSize(Sender: TObject;
      var TheBufferSize: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BTGlobalDataset1GetFileVar(Sender: TObject;
      var TheFileVar: pFileVar);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCardList3: TFrmCardList3;

implementation

{$R *.dfm}

procedure TFrmCardList3.BTGlobalDataset1GetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with CustRec(pData^) do begin
    case FieldName[1] of
      'N' : FieldValue := CustCode;
      'D' : FieldValue := company;
    end;
  end;{with}
end;


procedure TFrmCardList3.BTGlobalDataset1GetDataRecord(Sender: TObject;
  var TheDataRecord: Pointer);
begin
  TheDataRecord := RecPtr[CustF];
end;

procedure TFrmCardList3.BTGlobalDataset1GetBufferSize(Sender: TObject;
  var TheBufferSize: Integer);
begin
  TheBufferSize := FileRecLen[CustF];
end;

procedure TFrmCardList3.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TFrmCardList3.BTGlobalDataset1GetFileVar(Sender: TObject;
  var TheFileVar: pFileVar);
begin
  TheFileVar := @F[CustF];
end;

end.
