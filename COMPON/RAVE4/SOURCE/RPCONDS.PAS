{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPConDS;

interface

{$I RPVER.PAS }

uses
  Windows, SysUtils, Classes, Forms, RPDefine, RPCon, DB {$IFNDEF LEVEL3}, DBTables{$ENDIF};

type
  TRPCustomDataSetConnection = class(TRPCustomConnection)
  protected
    StateSaved: boolean;
    InitActive: boolean;
    SaveFilter: string;
    SaveFiltered: boolean;
    SaveBookmark: TBookmark;
    FirstEOFCheck: boolean;
    function GetDataSet: TDataSet; virtual; abstract;
  public
    procedure DoFirst; override;
    procedure DoNext; override;
    function DoEOF: boolean; override;
    procedure DoGetCols; override;
    procedure DoGetRow; override;
    procedure DoSetFilter; override;
    procedure DoOpen; override;
    procedure DoRestore; override;
  end; { TRPCustomDataSetConnection }

  TRPDataSetConnection = class(TRPCustomDataSetConnection)
  protected
    FDataSet: TDataSet;
    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure SetDataSet(Value: TDataSet);
    function GetDataSet: TDataSet; override;
  published
    property DataSet: TDataSet read FDataSet write SetDataSet default nil;
  end; { TRPDataSetConnection }

implementation

(*****************************************************************************}
( class TRPCustomDataSetConnection
(*****************************************************************************)

  procedure TRPCustomDataSetConnection.DoFirst;

  begin { DoFirst }
    GetDataSet.First;
  end;  { DoFirst }

  procedure TRPCustomDataSetConnection.DoNext;

  begin { DoNext }
    GetDataSet.Next;
  end;  { DoNext }

  function TRPCustomDataSetConnection.DoEOF: boolean;

  begin { DoEOF }
    If FirstEOFCheck then begin
      Result := GetDataSet.EOF and GetDataSet.BOF;
      FirstEOFCheck := false;
    end else begin
      Result := GetDataSet.EOF;
    end; { else }
  end;  { DoEOF }

  procedure TRPCustomDataSetConnection.DoGetCols;

  var
    I1: integer;
    RPDataType: TRPDataType;

  begin { DoGetCols }
    With GetDataSet do begin
      For I1 := 0 to FieldCount - 1 do begin
        With Fields[I1] do begin
          RPDataType := TRPDataSetType[DataType];
          If DisplayName = FieldName then begin
            WriteField(FieldName,RPDataType,DataSize,'','');
          end else begin
            WriteField(FieldName,RPDataType,DataSize,DisplayName,'');
          end; { else }
        end; { with }
      end; { for }
    end; { with }
  end;  { DoGetCols }

  procedure TRPCustomDataSetConnection.DoGetRow;

  type
    TGraphicHeader = record
      Count: word; { Fixed at 1 }
      HType: word; { Fixed at $0100 }
      Size: longint; { Size not including header }
    end; { TGraphicHeader }

  var
    I1: integer;
    I2: integer;
    Stream: TMemoryStream;
    P1: pointer;
    Header: TGraphicHeader;

  begin { DoGetRow }
    With GetDataSet do begin
      For I1 := 0 to FieldCount - 1 do begin
        With Fields[I1] do begin
          If not CurrentFieldDef.Included or IsNull then begin
            WriteNullData;
          end else begin
            Case TRPDataSetType[DataType] of
               dtString: begin
                WriteStrData(DisplayText,AsString);
              end;
              dtInteger: begin
                WriteIntData(DisplayText,AsInteger);
              end;
              dtBoolean: begin
                WriteBoolData(DisplayText,AsBoolean);
              end;
              dtFloat: begin
                WriteFloatData(DisplayText,AsFloat);
              end;
              dtCurrency: begin
                WriteCurrData(DisplayText,AsCurrency);
              end;
              dtBCD: begin
                WriteBCDData(DisplayText,AsCurrency);
              end;
              dtDate, dtTime, dtDateTime: begin
                WriteDateTimeData(DisplayText,AsDateTime);
              end;
              dtBlob, dtMemo, dtGraphic: begin
                Stream := TMemoryStream.Create;
                try
                 (Fields[I1] as TBlobField).SaveToStream(Stream);
                  P1 := Stream.Memory;
                  I2 := Stream.Size;
                  If TRPDataSetType[DataType] = dtGraphic then begin
                    Move(P1^,Header,SizeOf(Header));
                    If (Header.Count = 1) and (Header.HType = $0100) and
                     (Header.Size = (I2 - SizeOf(Header))) then begin
                      P1 := pointer(PChar(P1) + 8);
                      I2 := I2 - 8;
                    end; { if }
                  end; { if }
                  WriteBlobData(P1^,I2);
                finally
                  Stream.Free;
                end; { tryf }
              end;
              dtInt64: begin
                WriteInt64Data(DisplayText,(Fields[I1] as TLargeIntField).AsLargeInt);
              end;
            end; { case }
          end; { else }
        end; { with }
      end; { for }
    end; { with }
  end;  { DoGetRow }

  procedure TRPCustomDataSetConnection.DoSetFilter;

  var
    CalcFilter: string;

  begin { DoSetFilter }
    CalcFilter := '';
    While GetFilterItem do begin
      If CalcFilter <> '' then begin
        CalcFilter := CalcFilter + ' and ';
      end; { if }
      CalcFilter := CalcFilter + '[' + FilterFieldName + '] ' + FilterFieldOp +
       ' ' + QuotedStr(FilterFieldData);
    end; { while }
    With GetDataSet do begin
      Filter := CalcFilter;
      FilterOptions := [foNoPartialCompare];
      Filtered := (Filter <> '');
    end; { with }
  end;  { DoSetFilter }

  procedure TRPCustomDataSetConnection.DoOpen;

  begin { DoOpen }
    FirstEOFCheck := true;
    With GetDataSet do begin
      InitActive := Active;
      If Active then begin
        SaveBookmark := GetBookmark;
      end; { if }
      DisableControls;
      SaveFilter := Filter;
      SaveFiltered := Filtered;
      If not Active then begin
        Active := true;
        First;
      end; { if }
    end; { with }
    StateSaved := true;
  end;  { DoOpen }

  procedure TRPCustomDataSetConnection.DoRestore;

  begin { DoRestore }
    If StateSaved then begin
      With GetDataSet do begin
        Active := InitActive;
        EnableControls;
        Filter := SaveFilter;
        Filtered := SaveFiltered;
        If InitActive then begin
          GotoBookmark(SaveBookmark);
          FreeBookmark(SaveBookmark);
        end; { if }
      end; { with }
      StateSaved := false;
    end; { if }
  end;  { DoRestore }

(*****************************************************************************}
( class TRPDataSetConnection
(*****************************************************************************)

  procedure TRPDataSetConnection.Notification(AComponent: TComponent;
                                              Operation: TOperation);

  begin { Notification }
    inherited Notification(AComponent,Operation);
    If (Operation = opRemove) and (AComponent = FDataSet) then begin
      FDataSet := nil;
    end; { if }
  end;  { Notification }

  procedure TRPDataSetConnection.SetDataSet(Value: TDataSet);

  begin { SetDataSet }
    FDataSet := Value;
    If Assigned(Value) then begin
      Value.FreeNotification(self);
    end; { if }
  end;  { SetDataSet }

  function TRPDataSetConnection.GetDataSet: TDataSet;

  begin { GetDataSet }
    Result := FDataSet;
  end;  { GetDataSet }

end.