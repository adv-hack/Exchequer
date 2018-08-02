{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPCursor;

interface

uses
  Classes, Controls;

type
  TRPCursor = class
  private
    fCursorList: TList;
    //
    function GetLevel: Integer;
    procedure SetCurrentCursor(const Value: TCursor);
    function GetCurrentCursor: TCursor;
  public
    procedure Busy;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Reset;
    procedure Restore;
    //
    property CurrentCursor: TCursor read GetCurrentCursor write SetCurrentCursor;
    property Level: Integer read GetLevel;
  end; { TRPCursor }

var
  ScreenCursor: TRPCursor;

implementation

uses
  Forms;

procedure TRPCursor.Busy;
begin
  CurrentCursor := crHourGlass;
end;

constructor TRPCursor.Create;
begin
  inherited;
  fCursorList := TList.Create;
end;

destructor TRPCursor.Destroy;
begin
  fCursorList.Free;
  inherited;
end;

function TRPCursor.GetCurrentCursor: TCursor;
begin
  result := Screen.Cursor;
end;

function TRPCursor.GetLevel: Integer;
begin
  result := fCursorList.Count;
end;

procedure TRPCursor.Reset;
begin
  fCursorList.Clear;
  Screen.Cursor := crDefault;
end;

procedure TRPCursor.Restore;
begin
  with fCursorList do begin
    if Count > 0 then begin
      Screen.Cursor := TCursor(fCursorList[Count - 1]);
      Delete(Count - 1);
    end;
  end;
end;

procedure TRPCursor.SetCurrentCursor(const Value: TCursor);
begin
  fCursorList.Add(TObject(Screen.Cursor));
  Screen.Cursor := Value;
end;

initialization
  ScreenCursor := TRPCursor.Create;
finalization
  ScreenCursor.Free;
end.