unit Tables;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , AdminProc, APIUtil, BespokeXML, Dialogs, StdCtrls, ExtCtrls, uMultiList
  , MiscUtil;

type
  TfrmTables = class(TForm)
    mlTables: TMultiList;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    Button1: TButton;
    btnView: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure mlTablesRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure mlTablesCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure btnViewClick(Sender: TObject);
  private
    procedure EnableDisable;
  public
    { Public declarations }
    DatabaseInfo : TDatabaseInfo;
    procedure FillTableListFrom(lTables : TList);
    procedure FillTableList;
  end;

var
  frmTables: TfrmTables;

implementation

uses TableDetails;

{$R *.dfm}

{ TfrmTables }

procedure TfrmTables.FillTableListFrom(lTables: TList);
var
  iPos : integer;
  TableInfo : TTableInfo;
begin
  For iPos := 0 to lTables.Count-1 do
  begin
    TableInfo := TTableInfo.create;
    TableInfo.CopyFrom(TTableInfo(lTables[iPos]));
    TableInfo.GetStatus;
    mlTables.DesignColumns[0].Items.AddObject(TableInfo.Name, TableInfo);
  end;{for}
  if mlTables.ItemsCount > 0 then mlTables.Selected := 0;
  EnableDisable;
end;

procedure TfrmTables.FillTableList;
var
  iPos : integer;
begin
  For iPos := 0 to DatabaseInfo.Tables.Count-1 do
  begin
    TTableInfo(DatabaseInfo.Tables[iPos]).GetStatus;
    mlTables.DesignColumns[0].Items.Add(TTableInfo(DatabaseInfo.Tables[iPos]).Name);
  end;{for}
  if mlTables.ItemsCount > 0 then mlTables.Selected := 0;
  EnableDisable;
end;

procedure TfrmTables.FormDestroy(Sender: TObject);
begin
  mlTables.ClearItems;
end;

procedure TfrmTables.mlTablesRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
//if btnEdit.Enabled then btnEditClick(btnEdit);
  btnViewClick(btnView);
end;

procedure TfrmTables.btnAddClick(Sender: TObject);
var
//  asOriginalName : ANSIstring;
  iResult : integer;
  TableInfo : TTableInfo;
begin
  frmTableDetails := TfrmTableDetails.Create(self);
  frmTableDetails.FormMode := fmAdd;
  frmTableDetails.TableInfo := TTableInfo.Create;
  frmTableDetails.TableInfo.ParentCode := DatabaseInfo.Code;
  frmTableDetails.TableInfo.ParentDatabase := DatabaseInfo.Database;
//  asOriginalName := frmTableDetails.TableInfo.Name;
  if frmTableDetails.ShowModal = mrOK then
  begin
    frmTableDetails.TableInfo.Name := trim({Uppercase(}frmTableDetails.edName.Text){)};
//    frmTableDetails.TableInfo.CreationScript.Assign(frmTableDetails.memCreate.Lines);

    iResult := frmTableDetails.TableInfo.Add;

    if iResult = 0 then
    begin
      TableInfo := TTableInfo.Create;
      TableInfo.CopyFrom(frmTableDetails.TableInfo);

      mlTables.DesignColumns[0].Items.AddObject(frmTableDetails.TableInfo.Name, TableInfo);
      mlTables.Selected := mlTables.ItemsCount-1;
      EnableDisable;

      DatabaseInfo.Tables.Add(frmTableDetails.TableInfo);
    end
    else
    begin
      MsgBox('An error occurred when calling TableInfo.Add :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'TableInfo.Add Error');
    end;{if}
  end
  else
  begin
    frmTableDetails.TableInfo.Free;
  end;{if}
  frmTableDetails.Release;
end;

procedure TfrmTables.btnEditClick(Sender: TObject);
var
  asOriginalName : ANSIstring;
  iPos, iResult : integer;
begin
  frmTableDetails := TfrmTableDetails.Create(self);
  frmTableDetails.FormMode := fmEdit;
//  frmTableDetails.TableInfo := TTableInfo(mlTables.DesignColumns[0].Items.Objects[mlTables.Selected]);
  frmTableDetails.TableInfo := TTableInfo(DataBaseInfo.Tables[mlTables.Selected]);
  asOriginalName := frmTableDetails.TableInfo.Name;
  if frmTableDetails.ShowModal = mrOK then
  begin
    iResult := frmTableDetails.TableInfo.Update(trim(frmTableDetails.edName.Text));

    if iResult = 0 then
    begin
      mlTables.DesignColumns[0].Items[mlTables.Selected] := frmTableDetails.TableInfo.Name;

{      For iPos := 0 to DatabaseInfo.Tables.Count-1 do
      begin
        if TTableInfo(DatabaseInfo.Tables[iPos]).Name = asOriginalName then
        begin
          TTableInfo(DatabaseInfo.Tables[iPos]).CopyFrom(frmTableDetails.TableInfo);
        end;{if}
{      end;{for}

      EnableDisable;
    end
    else
    begin
      MsgBox('An error occurred when calling TableInfo.Update :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'TableInfo.Update Error');
    end;{if}

  end
  else
  begin
    //
  end;{if}
  frmTableDetails.Release;
end;

procedure TfrmTables.btnDeleteClick(Sender: TObject);
var
  iPos, iResult : integer;
begin
  if MsgBox('Are you sure you want to delete this Table from the list ?'#13#13
  + 'Doing so may stop your Exchequer Plug-Ins from operating correctly.'#13#13
  + 'Note : This only deletes the reference to this Table, not the SQL Table itself.'
  , mtWarning, [mbYes, mbNo], mbNo, 'Delete Table') = mrYes then
  begin

//    iResult := DeleteBespokeDatabase(PChar(TTableInfo(mlTables.DesignColumns[0].Items.Objects[mlTables.Selected]).Code));

//    iResult := TTableInfo(mlTables.DesignColumns[0].Items.Objects[mlTables.Selected]).Delete;
    iResult := TTableInfo(DataBaseInfo.Tables[mlTables.Selected]).Delete;

    if iResult = 0 then
    begin
{      For iPos := 0 to DatabaseInfo.Tables.Count-1 do
      begin
        if TTableInfo(DatabaseInfo.Tables[iPos]).Name = TTableInfo(mlTables.DesignColumns[0].Items.Objects[mlTables.Selected]).Name then
        TTableInfo(DataBaseInfo.Tables[mlTables.Selected])
        begin
          TTableInfo(DatabaseInfo.Tables[iPos]).Free;
          DatabaseInfo.Tables.Delete(iPos);
        end;{if}
{      end;{for}

//      mlTables.DesignColumns[0].Items.Objects[mlTables.Selected].Free;
      DatabaseInfo.Tables.Delete(mlTables.Selected);

      mlTables.DesignColumns[0].Items.Delete(mlTables.Selected);
      if mlTables.ItemsCount > 0 then mlTables.Selected := 0;
      EnableDisable;
    end
    else
    begin
      MsgBox('An error occurred when calling TTableInfo.Delete :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'TTableInfo.Delete Error');
    end;{if}
  end;{if}
end;

procedure TfrmTables.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmTables.EnableDisable;
begin
  btnAdd.Enabled := bLoggedIn;
  btnEdit.Enabled := (mlTables.Selected >= 0) and (mlTables.ItemsCount > 0) and bLoggedIn;
  btnView.Enabled := (mlTables.Selected >= 0) and (mlTables.ItemsCount > 0);
  btnDelete.Enabled := btnEdit.Enabled;
end;

procedure TfrmTables.mlTablesCellPaint(Sender: TObject; ColumnIndex, RowIndex: Integer; var OwnerText: String; var TextFont: TFont; var TextBrush: TBrush; var TextAlign: TAlignment);
var
  TableInfo : TTableInfo;
begin
//  TableInfo := TTableInfo(mlTables.DesignColumns[0].Items.Objects[RowIndex]);
  TableInfo := TTableInfo(DataBaseInfo.Tables[RowIndex]);
  if (TableInfo.Status = SQL_CREATED) then
  begin
    if RowIndex = mlTables.Selected then TextFont.Color := clWhite
    else TextFont.Color := clBlack;
  end
  else
  begin
    TextFont.Color := clRed;
  end;{if}
end;

procedure TfrmTables.btnViewClick(Sender: TObject);
var
  asOriginalName : ANSIstring;
  iPos, iResult : integer;
begin
  frmTableDetails := TfrmTableDetails.Create(self);
  frmTableDetails.FormMode := fmView;
//  frmTableDetails.TableInfo := TTableInfo(mlTables.DesignColumns[0].Items.Objects[mlTables.Selected]);
  frmTableDetails.TableInfo := TTableInfo(DataBaseInfo.Tables[mlTables.Selected]);
  asOriginalName := frmTableDetails.TableInfo.Name;
  frmTableDetails.ShowModal;
  frmTableDetails.Release;
end;

end.
