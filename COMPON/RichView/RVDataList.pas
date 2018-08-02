
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Some classes used as ancestors for classes      }
{       representing RichView document not linked with  }
{       RichView control (table cells)                  }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVDataList;

interface
uses Classes, Windows, Graphics, Controls,
     RVClasses, CRVData, CRVFData, RVBack,
     RVItem, RVStyle, RVScroll, RVTypes;
{$I RV_Defs.inc}

type
  TRVDataList = class;

  TRVItemFormattedData  = class (TCustomRVFormattedData)
    protected
      FList: TRVDataList;
      function GetFlags: TRVFlags; override;
      procedure SetFlags(const Value: TRVFlags); override;      
    public
      constructor Create(AList: TRVDataList);
      procedure ShowRectangle(Left, Top, Width, Height: Integer); override;
      procedure ScrollTo(Y: Integer; Redraw: Boolean); override;
      procedure HScrollTo(X: Integer); override;
      function GetVSmallStep: Integer; override;
      function GetParentData: TCustomRVData; override;
      function GetRootData: TCustomRVData; override;
      function GetAbsoluteParentData: TCustomRVData; override;
      function GetAbsoluteRootData: TCustomRVData; override;
      function GetURL(id: Integer): String; override;
      function GetAreaWidth: Integer; override;
      function GetAreaHeight: Integer; override;
      function GetMinTextWidth: Integer; override;
      function GetMaxTextWidth: Integer; override;
      function GetLeftMargin: Integer; override;
      function GetRightMargin: Integer; override;
      function GetTopMargin: Integer; override;
      function GetBottomMargin: Integer; override;
      procedure AdjustVScrollUnits; override;
      procedure SetDocumentAreaSize(Width,Height: Integer; UpdateH: Boolean); override;
      function GetBackground: TRVBackground; override;

      function IsAssignedRVMouseDown: Boolean; override;
      function IsAssignedRVMouseUp: Boolean; override;
      function IsAssignedJump: Boolean; override;
      function IsAssignedCheckpointVisible: Boolean; override;

      function  GetFirstItemVisible: Integer; override;
      function  GetLastItemVisible: Integer; override;

      procedure DoRVMouseMove(id: Integer); override;
      procedure DoRVMouseDown(Button: TMouseButton; Shift: TShiftState; ItemNo, X, Y: Integer); override;
      procedure DoRVMouseUp(Button: TMouseButton; Shift: TShiftState; ItemNo, X, Y: Integer); override;
      procedure DoCheckpointVisible(CheckpointData: TCheckpointData); override;
      procedure ControlAction2(RVData: TCustomRVData; ControlAction: TRVControlAction;
        ItemNo: Integer; var Control: TControl); override;

      procedure DoJump(id: Integer); override;
      function GetNormalCursor: TCursor; override;
  end;

  TRVDataList = class (TRVList)
    protected
      Flags: TRVFlags;
      function GetParentRVData: TCustomRVData; virtual;
    public
      constructor Create(AParentRVData: TCustomRVData);
  end;

implementation
uses RVStr;

procedure RaiseNS;
begin
  raise ERichViewError.Create(errTRVItemFormattedDataNS);
end;

{================================ TRVItemFormattedData ========================}
constructor TRVItemFormattedData.Create(AList: TRVDataList);
begin
  inherited Create;
  FList := AList;
end;
{------------------------------------------------------------------------------}
function TRVItemFormattedData.GetParentData: TCustomRVData;
begin
  Result := FList.GetParentRVData;
end;
{------------------------------------------------------------------------------}
function TRVItemFormattedData.GetRootData: TCustomRVData;
begin
  Result := GetParentData.GetRootData;
end;
{------------------------------------------------------------------------------}
function TRVItemFormattedData.GetAbsoluteParentData: TCustomRVData;
begin
  Result := FList.GetParentRVData;
end;
{------------------------------------------------------------------------------}
function TRVItemFormattedData.GetAbsoluteRootData: TCustomRVData;
begin
  Result := GetAbsoluteParentData.GetAbsoluteRootData;
end;
{------------------------------------------------------------------------------}
procedure TRVItemFormattedData.ShowRectangle(Left, Top, Width,
  Height: Integer);
var RVData: TCustomRVData;
    x,y: Integer;
begin
  RVData := GetRootData;
  if (RVData<>nil) and (RVData is TCustomRVFormattedData) then begin
    GetOrigin(x,y);
    TCustomRVFormattedData(RVData).ShowRectangle(x+Left,y+Top,Width,Height);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVItemFormattedData.AdjustVScrollUnits;
begin
   // ?
end;
{------------------------------------------------------------------------------}
procedure TRVItemFormattedData.DoCheckpointVisible(
  CheckpointData: TCheckpointData);
begin
  // ?
end;
{------------------------------------------------------------------------------}
procedure TRVItemFormattedData.DoJump(id: Integer);
begin
  // ?
end;
{------------------------------------------------------------------------------}
procedure TRVItemFormattedData.DoRVMouseDown(Button: TMouseButton;
  Shift: TShiftState; ItemNo, X, Y: Integer);
begin
  // ?
end;
{------------------------------------------------------------------------------}
procedure TRVItemFormattedData.DoRVMouseMove(id: Integer);
begin
  // ?
end;
{------------------------------------------------------------------------------}
procedure TRVItemFormattedData.DoRVMouseUp(Button: TMouseButton;
  Shift: TShiftState; ItemNo, X, Y: Integer);
begin
  // ?
end;
{------------------------------------------------------------------------------}
function TRVItemFormattedData.GetFlags: TRVFlags;
begin
  Result := FList.Flags;
end;
{------------------------------------------------------------------------------}
procedure TRVItemFormattedData.SetFlags(const Value: TRVFlags);
begin
  RaiseNS;
end;
{------------------------------------------------------------------------------}
function TRVItemFormattedData.GetLeftMargin: Integer;
begin
  // ?
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRVItemFormattedData.GetTopMargin: Integer;
begin
  // ?
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRVItemFormattedData.GetRightMargin: Integer;
begin
  // ?
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRVItemFormattedData.GetBottomMargin: Integer;
begin
  // ?
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRVItemFormattedData.GetAreaWidth: Integer;
begin
  Result := 0;
end;

function TRVItemFormattedData.GetAreaHeight: Integer;
begin
  Result := 0;
end;

function TRVItemFormattedData.GetBackground: TRVBackground;
begin
  //?
  Result := nil;
end;

function TRVItemFormattedData.GetMaxTextWidth: Integer;
begin
  Result := 0;
end;

function TRVItemFormattedData.GetMinTextWidth: Integer;
begin
  Result := 0;
end;

function TRVItemFormattedData.GetNormalCursor: TCursor;
begin
    Result := TCustomRVFormattedData(GetRootData).GetNormalCursor;
end;

function TRVItemFormattedData.GetURL(id: Integer): String;
begin
  Result := TRVItemFormattedData(GetRootData).GetURL(id);
end;

function TRVItemFormattedData.IsAssignedCheckpointVisible: Boolean;
begin
  Result := False;
end;

function TRVItemFormattedData.IsAssignedJump: Boolean;
begin
  Result := False;
end;

function TRVItemFormattedData.IsAssignedRVMouseDown: Boolean;
begin
  Result := False;
end;

function TRVItemFormattedData.IsAssignedRVMouseUp: Boolean;
begin
  Result := False;
end;


procedure TRVItemFormattedData.ScrollTo(Y: Integer; Redraw: Boolean);
begin

end;

function TRVItemFormattedData.GetVSmallStep: Integer;
begin
  Result := 0;
end;

procedure TRVItemFormattedData.HScrollTo(X: Integer);
begin

end;

procedure TRVItemFormattedData.SetDocumentAreaSize(Width, Height: Integer;
  UpdateH: Boolean);
begin

end;

procedure TRVItemFormattedData.ControlAction2(RVData: TCustomRVData;
  ControlAction: TRVControlAction; ItemNo: Integer; var Control: TControl);
begin

end;
{------------------------------------------------------------------------------}
function TRVItemFormattedData.GetFirstItemVisible: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRVItemFormattedData.GetLastItemVisible: Integer;
begin
  Result := Items.Count-1;
end;
{================================= TRVDataList ================================}
constructor TRVDataList.Create(AParentRVData: TCustomRVData);
begin
  inherited Create;
  Flags := [ {rvflUseJumps, rvflShareContents, rvflUseExternalLeading,} rvflTrim,
              rvflMouseXYAlwaysCorrect, rvflCanUseCustomPPI ];
end;

{------------------------------------------------------------------------------}
function TRVDataList.GetParentRVData: TCustomRVData;
begin
  Result := nil;
end;
end.
