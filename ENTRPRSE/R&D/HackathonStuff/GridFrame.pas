unit GridFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseFrame, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxGridCommon,
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
    procedure aColumnCustExecute(Sender: TObject);
  private
    FAutoloadColumn: Boolean;
    procedure SetAutoloadColumn(const Value: Boolean);
    { Private declarations }
  public
    { Public declarations }

    constructor Create(AOwner: TComponent); override;

    procedure Init(); override;
    procedure ExpandAll(); override;
    procedure CollapseAll(); override;
    procedure ApplyBestFit(); override;


    procedure InitGridColumns();

    property AutoloadColumn : Boolean read FAutoloadColumn write SetAutoloadColumn;
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

procedure TfrDataGrid.InitGridColumns;

var
  I: Integer;
  AItem: TcxCustomGridTableItem;
begin
  inherited;
  if AutoloadColumn then
  begin
    if vMain.DataController.DataSource.DataSet = nil then Exit;
    
    ShowHourglassCursor;
    try
      vMain.BeginUpdate;
      try
        with vMain.DataController.DataSource.DataSet  do
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
        vMain.EndUpdate;
      end;
    finally
      HideHourglassCursor;
    end;
  end;
end;



procedure TfrDataGrid.SetAutoloadColumn(const Value: Boolean);
begin
  FAutoloadColumn := Value;
end;

procedure TfrDataGrid.aColumnCustExecute(Sender: TObject);
begin
  inherited;
//
//vMain.OptionsCustomize.
end;

end.
