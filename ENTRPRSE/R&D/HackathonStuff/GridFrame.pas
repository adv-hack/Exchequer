unit GridFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseFrame, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Menus, ActnList;

type
  TfrDataGrid = class(TfrBase)
    pnlMain: TPanel;
    vMain: TcxGridDBTableView;
    lvlMain: TcxGridLevel;
    grdMain: TcxGrid;
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
begin
  inherited;
  if AutoloadColumn then
  begin
    vMain.BeginUpdate;
    vMain.DataController.CreateAllItems;
    vMain.EndUpdate;
  end;
end;

procedure TfrDataGrid.SetAutoloadColumn(const Value: Boolean);
begin
  FAutoloadColumn := Value;
end;

end.
