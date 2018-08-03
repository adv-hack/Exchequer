unit GridFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseFrame, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxGridCommon,cxExportGrid4Link,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,cxGridDBDataDefinitions,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Menus, ActnList, ADODB;

type
  TfrDataGrid = class(TfrBase)
    pnlMain: TPanel;
    vMain: TcxGridDBTableView;
    lvlMain: TcxGridLevel;
    grdMain: TcxGrid;
    aColumnCust: TAction;
    aExportToExcel: TAction;
    aExportToHtml: TAction;
    aExportToXML: TAction;
    aExportToText: TAction;
    SaveDialog: TSaveDialog;
    N2: TMenuItem;
    ExportToExcel1: TMenuItem;
    ExportToHTML1: TMenuItem;
    ExportToText1: TMenuItem;
    ExportToXML1: TMenuItem;
    lvlDetail: TcxGridLevel;
    vDetail: TcxGridDBTableView;
    aShowDetail: TAction;
    mniShowDetail: TMenuItem;
    N3: TMenuItem;
    procedure aExportToTextExecute(Sender: TObject);
    procedure aExportToXMLExecute(Sender: TObject);
    procedure aExportToHtmlExecute(Sender: TObject);
    procedure aExportToExcelExecute(Sender: TObject);
    procedure aShowDetailExecute(Sender: TObject);
  private
    FAutoloadColumn: Boolean;
    FOnSetDetail: TNotifyEvent;
    procedure SetAutoloadColumn(const Value: Boolean);

    { Private declarations }
  public
    { Public declarations }

    constructor Create(AOwner: TComponent); override;
    procedure InitColumns(aView: TcxGridDBTableView);
    procedure Init(); override;
    procedure ExpandAll(); override;
    procedure CollapseAll(); override;
    procedure ApplyBestFit(); override;
    procedure RefreshGrid(); override;


    procedure InitGridColumns();

    property AutoloadColumn : Boolean read FAutoloadColumn write SetAutoloadColumn;
    property OnSetDetail : TNotifyEvent read FOnSetDetail write FOnSetDetail;  
  end;

var
  frDataGrid: TfrDataGrid;

implementation

{$R *.dfm}

{ TfrDataGrid }

procedure TfrDataGrid.ApplyBestFit;
begin
  inherited;
  vMain.BeginUpdate;
  try
    vMain.ApplyBestFit();
  finally
   vMain.EndUpdate;
  end;
end;

procedure TfrDataGrid.CollapseAll;
begin
  inherited;
  vMain.ViewData.Collapse(True);

end;

constructor TfrDataGrid.Create(AOwner: TComponent);
begin
  inherited;
  FAutoloadColumn := True;

end;

procedure TfrDataGrid.ExpandAll;
begin
  inherited;
  vMain.ViewData.Expand(True);
end;

procedure TfrDataGrid.Init;
begin
  inherited;
//

end;


procedure TfrDataGrid.InitColumns(aView : TcxGridDBTableView );
var
  I: Integer;
  AItem: TcxCustomGridTableItem;
begin
  inherited;
  if aView.DataController.DataSource = nil then Exit;
  if aView.DataController.DataSource.DataSet = nil then Exit;

  if AutoloadColumn then
  begin
    if aView.DataController.DataSource.DataSet = nil then Exit;

    ShowHourglassCursor;
    try
      aView.BeginUpdate;
      try
        with aView.DataController.DataSource.DataSet  do
          for I := 0 to FieldCount - 1 do
          begin
            if Fields[I].Visible then
            begin
              AItem := vMain.CreateItem;
              with AItem do
              begin
                with DataBinding as TcxGridItemDBDataBinding do
                  FieldName := Fields[I].FieldName;
                Name := CreateUniqueName(GridView.Owner, GridView, AItem,
                  ScxGridPrefixName, Fields[I].FieldName);
                Visible := Fields[I].Visible;
              end;
            end;
          end;
      finally
        aView.EndUpdate;
      end;
    finally
      HideHourglassCursor;
    end;
  end;
end;



procedure TfrDataGrid.InitGridColumns;
var
  I: Integer;
  AItem: TcxCustomGridTableItem;
begin
  inherited;
  if AutoloadColumn then
  begin
    InitColumns(vMain);
  end;
end;



procedure TfrDataGrid.SetAutoloadColumn(const Value: Boolean);
begin
  FAutoloadColumn := Value;
end;

procedure TfrDataGrid.aExportToTextExecute(Sender: TObject);
begin
  inherited;
  SaveDialog.Filter := 'Text file|*.txt';
  SaveDialog.DefaultExt := '.txt';
  SaveDialog.Execute;

  if SaveDialog.FileName <> EmptyStr then
  begin
    ExportGrid4ToText(SaveDialog.FileName,grdMain);
  end;

end;

procedure TfrDataGrid.aExportToXMLExecute(Sender: TObject);
begin
  inherited;
  SaveDialog.Filter := 'XML file|*.xml';
  SaveDialog.DefaultExt := '.xml';
  SaveDialog.Execute;

  if SaveDialog.FileName <> EmptyStr then
  begin
    ExportGrid4ToXML(SaveDialog.FileName,grdMain);
  end;
end;

procedure TfrDataGrid.aExportToHtmlExecute(Sender: TObject);
begin
  inherited;
  SaveDialog.Filter := 'HTML file|*.html';
  SaveDialog.DefaultExt := '.html';
  SaveDialog.Execute;

  if SaveDialog.FileName <> EmptyStr then
  begin
    ExportGrid4ToHTML(SaveDialog.FileName,grdMain);
  end;
end;

procedure TfrDataGrid.aExportToExcelExecute(Sender: TObject);

begin
  inherited;
  SaveDialog.Filter := 'Excel Worksheets (*.xls, *.xlsx)|*.xls;*.xlsx';
  SaveDialog.DefaultExt := '.xls';
  SaveDialog.Execute;

  if SaveDialog.FileName <> EmptyStr then
  begin
    ExportGrid4ToExcel(SaveDialog.FileName,grdMain);
  end;
end;

procedure TfrDataGrid.aShowDetailExecute(Sender: TObject);
begin
  inherited;
  lvlDetail.Visible := not lvlDetail.Visible;
  mniShowDetail.Checked := lvlDetail.Visible;

  if Assigned(FOnSetDetail) and lvlDetail.Visible then
  begin
    FOnSetDetail(Self)
  end else
  begin
    vDetail.DataController.DataSource := nil;
  end;

end;

procedure TfrDataGrid.RefreshGrid;
var
  lRecNo : Integer;
begin
  inherited;
  if vMain.DataController.DataSource = nil then Exit;
  if vMain.DataController.DataSource.DataSet = nil then Exit;

  with vMain.DataController.DataSource,DataSet do
  begin
    lRecNo := RecNo;
    Close;
    Open;
    if DataSet.RecordCount >= lRecNo then
      DataSet.RecNo := lRecNo;
  end;
end;

end.
