{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPDBTabl;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Controls, TypInfo,
  Graphics, Dialogs, Forms, DB, DBTables, RPDefine, RPBase, RPSystem, RPTable;

type
  TDBTablePrinter = class;
  TFieldName = string[40];

{*************************************************************************}
{                           class TDBTableColumn                          }
{*************************************************************************}
  TDBTableColumn = class(TTableColumn)
  protected
    FFieldName: TFieldName;
    FLookupDataSet: TDataSet;
    FLookupKey: TFieldName;
    FLookupDisplay: TFieldName;

    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure SetLookupDataSet(Value: TDataSet);
    procedure FillMemoBuf; override;
  published
    property FieldName: TFieldName read FFieldName write FFieldName;
    property LookupDataSet: TDataSet read FLookupDataSet write SetLookupDataSet;
    property LookupKey: TFieldName read FLookupKey write FLookupKey;
    property LookupDisplay: TFieldName read FLookupDisplay write FLookupDisplay;
  end; { TDBTableColumn }

{*************************************************************************}
{                           class TDBTablePrinter                         }
{*************************************************************************}
  TDBTablePrinter = class(TTablePrinter)
  protected
    FDataSet: TDataSet;
    FMasterKey: TFieldName;
    FDetailKey: TFieldName;

    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure SetDataSet(Value: TDataSet);
    procedure InitMaster(var Valid: boolean;
                             Master: TTablePrinter); override;
    procedure InitTable(var Valid: boolean); override;
    procedure GetNextRow(var Valid: boolean); override;

  public
    function CreateColumn(Description: TComponentName): TTableColumn; override;

  published
    property MasterKey: TFieldName read FMasterKey write FMasterKey;
    property DetailKey: TFieldName read FDetailKey write FDetailKey;
    property DataSet: TDataSet read FDataSet write SetDataSet;
  end; { TDBTablePrinter }

implementation

{*************************************************************************}
{                           class TDBTableColumn                          }
{*************************************************************************}

  procedure TDBTableColumn.Notification(AComponent: TComponent;
                                        Operation: TOperation);

  begin { Notification }
    inherited Notification(AComponent,Operation);
    If (Operation = opRemove) and (AComponent = FLookupDataSet) then begin
      LookupDataSet := nil;
    end; { if }
  end;  { Notification }

  procedure TDBTableColumn.SetLookupDataSet(Value: TDataSet);

  begin { SetLookupDataSet }
    FLookupDataSet := Value;
    If Assigned(Value) then begin
      Value.FreeNotification(self);
    end; { if }
  end;  { SetLookupDataSet }

  procedure TDBTableColumn.FillMemoBuf;

  var
    TP: TDBTablePrinter;
    Field: TField;
    Stream: TMemoryStream;

    procedure ProcessField;

    begin { ProcessField }
      Case Field.DataType of
        ftMemo: begin
          Stream := TMemoryStream.Create;
          try
            (Field as TMemoField).SaveToStream(Stream);
            MemoBuf.SetData(Stream.Memory^,Stream.Size);
          finally
            Stream.Free;
          end; { try }
        end;
        ftSmallint, ftInteger, ftWord: begin
          If DisplayFormat = '' then begin
            MemoBuf.Text := Field.AsString;
          end else begin
            MemoBuf.Text := FormatFloat(DisplayFormat,Field.AsInteger);
          end; { else }
        end;
        ftFloat, ftCurrency, ftBCD: begin
          If DisplayFormat = '' then begin
            MemoBuf.Text := Field.AsString;
          end else begin
            MemoBuf.Text := FormatFloat(DisplayFormat,Field.AsFloat);
          end; { else }
        end;
        ftDate, ftTime, ftDateTime: begin
          If DisplayFormat = '' then begin
            MemoBuf.Text := Field.AsString;
          end else begin
            MemoBuf.Text := FormatDateTime(DisplayFormat,Field.AsDateTime);
          end; { else }
        end;
        else begin
          MemoBuf.Text := Field.AsString;
        end;
      end; { case }
    end;  { ProcessField }

  begin { FillMemoBuf }
    If OutputType = otText then begin
      TP := FParent as TDBTablePrinter;
      If Assigned(FLookupDataSet) then begin
        With FLookupDataSet as TTable do begin
          If not Active then begin
            Open;
          end; { if }
          IndexFieldNames := LookupKey;
          SetKey;
          FieldByName(LookupKey).Assign(TP.DataSet.FieldByName(FieldName));
          If GotoKey then begin
            Field := FieldByName(LookupDisplay);
            ProcessField;
          end else begin
            MemoBuf.Text := '';
          end; { else }
        end; { with }
      end else begin
        If FieldName = '' then begin
          MemoBuf.Text := '';
        end else begin
          Field := TP.DataSet.FieldByName(FieldName);
          ProcessField;
        end; { else }
      end; { else }
    end else begin
      inherited FillMemoBuf;
    end; { else }
  end;  { FillMemoBuf }

{*************************************************************************}
{                           class TDBTablePrinter                         }
{*************************************************************************}

  procedure TDBTablePrinter.Notification(AComponent: TComponent;
                                         Operation: TOperation);

  begin { Notification }
    inherited Notification(AComponent,Operation);
    If (Operation = opRemove) and (AComponent = FDataSet) then begin
      FDataSet := nil;
    end; { if }
  end;  { Notification }

  procedure TDBTablePrinter.SetDataSet(Value: TDataSet);

  begin { SetDataSet }
    FDataSet := Value;
    If Assigned(Value) then begin
      Value.FreeNotification(self);
    end; { if }
  end;  { SetDataSet }

  function TDBTablePrinter.CreateColumn(Description: TComponentName): TTableColumn;

  begin { CreateColumn }
    Result := TDBTableColumn.Create(Owner);
    Result.Description := Description;
    Result.Name := Name + DescToName(Description);
    AssignParent(Result);
  end;  { CreateColumn }

  procedure TDBTablePrinter.InitMaster(var Valid: boolean;
                                           Master: TTablePrinter);

  var
    TP: TDBTablePrinter;

    procedure FillFields(Table1: TTable;
                         Key1: string;
                         Table2: TTable;
                         Key2: string);

    var
      SubKey1: string[40];
      SubKey2: string[40];
      SemiPos: integer;

    begin { FillFields }
      While (Key1 <> '') and (Key2 <> '') do begin
        SemiPos := Pos(';',Key1);
        If SemiPos > 0 then begin
          SubKey1 := Copy(Key1,1,SemiPos - 1);
          Delete(Key1,1,SemiPos);
        end else begin
          SubKey1 := Key1;
          Key1 := '';
        end; { else }

        SemiPos := Pos(';',Key2);
        If SemiPos > 0 then begin
          SubKey2 := Copy(Key2,1,SemiPos - 1);
          Delete(Key2,1,SemiPos);
        end else begin
          SubKey2 := Key2;
          Key2 := '';
        end; { else }
        Table1.FieldByName(SubKey1).Assign(Table2.FieldByName(SubKey2));
      end; { while }
    end;  { FillFields }

  begin { InitMaster }
    inherited InitMaster(Valid,Master);
    If not Assigned(FOnInitMaster) or IsDefault then begin
      Valid := false;
      If Master is TDBTablePrinter then begin
        TP := Master as TDBTablePrinter;
        With DataSet as TTable do begin
          If not Active then begin
            Open;
          end; { if }
          IndexFieldNames := DetailKey;
          CancelRange;
          SetRangeStart;
          FillFields(DataSet as TTable,DetailKey,TP.DataSet as TTable,MasterKey);
          SetRangeEnd;
          FillFields(DataSet as TTable,DetailKey,TP.DataSet as TTable,MasterKey);
          ApplyRange;
          Valid := true;
        end; { with }
      end; { if }
    end; { else }
  end;  { InitMaster }

  procedure TDBTablePrinter.InitTable(var Valid: boolean);

  begin { InitTable }
    If Assigned(FOnInitTable) and not IsDefault then begin
      inherited InitTable(Valid);
    end else begin
      If not DataSet.Active then begin
        DataSet.Open;
      end; { if }
      DataSet.First;
      Valid := not DataSet.EOF;
    end; { else }
  end;  { InitTable }

  procedure TDBTablePrinter.GetNextRow(var Valid: boolean);

  begin { GetNextRow }
    If Assigned(FOnGetNextRow) and not IsDefault then begin
      inherited GetNextRow(Valid);
    end else begin
      DataSet.Next;
      Valid := not DataSet.EOF;
    end; { else }
  end;  { GetNextRow }

end.