{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit NDRVCursor;

interface

uses
  Classes, Controls;

type
  TNDCursor = class
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
  end;

var
  ScreenCursor: TNDCursor;

implementation

uses
  Forms;

procedure TNDCursor.Busy;
begin
  CurrentCursor := crHourGlass;
end;

constructor TNDCursor.Create;
begin
  inherited;
  fCursorList := TList.Create;
end;

destructor TNDCursor.Destroy;
begin
  fCursorList.Free;
  inherited;
end;

function TNDCursor.GetCurrentCursor: TCursor;
begin
  result := Screen.Cursor;
end;

function TNDCursor.GetLevel: Integer;
begin
  result := fCursorList.Count;
end;

procedure TNDCursor.Reset;
begin
  fCursorList.Clear;
  Screen.Cursor := crDefault;
end;

procedure TNDCursor.Restore;
begin
  with fCursorList do begin
    if Count > 0 then begin
      Screen.Cursor := TCursor(fCursorList[Count - 1]);
      Delete(Count - 1);
    end;
  end;
end;

procedure TNDCursor.SetCurrentCursor(const Value: TCursor);
begin
  fCursorList.Add(TObject(Screen.Cursor));
  Screen.Cursor := Value;
end;

initialization
  ScreenCursor := TNDCursor.Create;
finalization
  ScreenCursor.Free;
end.