unit Halcn6rg;
interface

uses
  SysHalc, SysUtils, Classes,
  {$IFDEF WIN32}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, Halcn6Nv,
  {$ENDIF}
  {$IFDEF LINUX}
  Types, QGraphics, QControls, QForms, QDialogs,
  {$ENDIF}
  DB, Halcn6db;


procedure Register;

implementation
uses DBConsts,
     {$IFDEF LINUX}
     DesignIntf,
     DesignEditors,
     {$ELSE}
        {$IFDEF VER140}
        DesignIntf,
        DesignEditors,
        {$ELSE}
           {$IFDEF WIN32}
           DsgnIntf,
           {$ENDIF}
        {$ENDIF}
     {$ENDIF}
     Halcn6pr, Halcn6id, TypInfo;

type
{ TgsStringProperty }

  TgsStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

function TgsStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paMultiSelect];
end;

procedure TgsStringProperty.GetValueList(List: TStrings);
begin
   List.Clear;
end;

procedure TgsStringProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

{ TTableNameProperty }
type
  TTableNameProperty = class(TgsStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TTableNameProperty.GetValueList(List: TStrings);
begin
   (GetComponent(0) as THalcyonDataSet).GetTableNames(List);
end;

{ TIndexFileProperty }
type
  TIndexFileProperty = class(TClassProperty)
  public
    function  GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

function TIndexFileProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog] - [paSubProperties];
end;

function TIndexFileProperty.GetValue: string;
begin
   Result := '(TIndexFiles)';
end;

procedure TIndexFileProperty.Edit;
var
  Frm : TIndexForm;
begin
  Frm := TIndexForm.Create(Application);
  try
    (GetComponent(0) as THalcyonDataSet).GetIndexNames(Frm.SrcList.Items);
    if Frm.SrcList.Items.Count > 0 then
    begin
       Frm.DstList.Items.Assign((GetComponent(0) as THalcyonDataSet).GetIndexList);
       if Frm.ShowModal = mrOK then
       begin
         (GetComponent(0) as THalcyonDataSet).SetIndexList(Frm.DstList.Items);
         SetValue('(TIndexFiles)');
         Designer.Modified;
       end;
    end;
 finally
    Frm.Free;
  end;
end;

{ TIndexDefProperty }

type
  TIndexDefProperty = class(TgsStringProperty)
  public
    function  GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

function TIndexDefProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TIndexDefProperty.GetValue: string;
begin
   Result := '(TIndexDefs)';
end;

procedure TIndexDefProperty.Edit;
var
  Frm : TIndexDescDef;
  DSet: THalcyonDataset;
begin
  Frm := TIndexDescDef.Create(Application);
  try
    DSet := (GetComponent(0) as THalcyonDataSet);
    Frm.DataSet := DSet;
    Frm.ShowModal;
    SetValue('(TIndexDefs)');
    Designer.Modified;
  finally
    Frm.Free;
  end;
end;

{ TIndexTagProperty }

type
  TIndexTagProperty = class(TgsStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TIndexTagProperty.GetValueList(List: TStrings);
begin
   (GetComponent(0) as THalcyonDataSet).GetIndexTagList(List);
end;

{ TDatabaseNameProperty }

type
  TDatabaseNameProperty = class(TgsStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TDatabaseNameProperty.GetValueList(List: TStrings);
begin
  (GetComponent(0) as THalcyonDataSet).GetDatabaseNames(List);
end;

{ TDataSourceProperty }

type
  TDataSourceProperty = class(TComponentProperty)
  private
    FCheckProc: TGetStrProc;
    procedure CheckComponent(const Value: string);
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

procedure TDataSourceProperty.CheckComponent(const Value: string);
var
  J: Integer;
  DataSource: TDataSource;
begin
  DataSource := TDataSource(Designer.GetComponent(Value));
  for J := 0 to PropCount - 1 do
    if TDataSet(GetComponent(J)).IsLinkedTo(DataSource) then
      Exit;
  FCheckProc(Value);
end;

procedure TDataSourceProperty.GetValues(Proc: TGetStrProc);
begin
  FCheckProc := Proc;
  inherited GetValues(CheckComponent);
end;

{ TgsMasterFieldProperty }

type
  TgsMasterFieldProperty = class(TgsStringProperty)
  public
    function GetDataSourcePropName: string; virtual;
    procedure GetValueList(List: TStrings); override;
  end;

function TgsMasterFieldProperty.GetDataSourcePropName: string;
begin
  Result := 'DataSource';
end;

procedure TgsMasterFieldProperty.GetValueList(List: TStrings);
var
  Instance: TComponent;
  MDataSource: TDataSource;
begin
  Instance := TComponent(GetComponent(0));
  if (Instance <> nil) and (Instance.InheritsFrom(THalcyonDataSet)) then
  begin
    MDataSource := THalcyonDataSet(Instance).MasterSource;
    if (MDataSource <> nil) and (MDataSource.DataSet <> nil) then
    begin
        MDataSource.DataSet.GetFieldNames(List);
    end;
  end;
end;

procedure Register;
begin
  RegisterComponents('Halcyon6', [THalcyonDataSet, TCreateHalcyonDataSet]);
  {$IFDEF WIN32}
  RegisterComponents('Halcyon6', [THalcyonNavigator]);
  {$ENDIF}
  RegisterPropertyEditor(TypeInfo(string), THalcyonDataSet, 'TableName', TTableNameProperty);
  RegisterPropertyEditor(TypeInfo(TStrings), THalcyonDataSet, 'IndexFiles', TIndexFileProperty);
  RegisterPropertyEditor(TypeInfo(TIndexDefs), THalcyonDataSet, 'IndexDefs', TIndexDefProperty);
  RegisterPropertyEditor(TypeInfo(string), THalcyonDataSet, 'IndexName', TIndexTagProperty);
  RegisterPropertyEditor(TypeInfo(string), THalcyonDataSet, 'DatabaseName', TDatabaseNameProperty);
  RegisterPropertyEditor(TypeInfo(string), THalcyonDataset, 'MasterFields', TgsMasterFieldProperty);
  RegisterPropertyEditor(TypeInfo(TDataSource), THalcyonDataset, 'MasterSource', TDataSourceProperty);

end;

end.

