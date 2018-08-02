{*******************************************************}
{                                                       }
{       RichView                                        }
{       Document owned by some item (for example, text  }
{       for footnote and endnote                        }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVSubData;

interface

{$I RV_Defs.inc}

uses Classes, Controls, Graphics,
     RVItem, RVStyle, CRVData, RVRTFErr,
     {$IFNDEF RVDONOTUSESEQ}
     RVSeqItem,
     {$ENDIF}
     {$IFNDEF RVDONOTUSELISTS}
     RVMarker,
     {$ENDIF}
     RVUndo, RVTypes;

{$IFNDEF RVDONOTUSESEQ}

type
  TRVSubData = class (TCustomRVData)
    private
      FFlags: TRVFlags;
      FOwner: TCustomRVItemInfo;
    protected
      FSeqList: TRVSeqList;
      {$IFNDEF RVDONOTUSELISTS}
      FMarkers: TRVMarkerList;
      procedure DestroyMarkers; override;
      {$ENDIF}
      procedure DestroySeqList; override;
      function GetURL(id: Integer): String; override;
      function GetFlags: TRVFlags; override;
      procedure SetFlags(const Value: TRVFlags); override;
    public
      MainRVData: TCustomRVData;
      constructor Create(AOwner: TCustomRVItemInfo; AMainRVData: TCustomRVData);
      procedure ControlAction2(RVData: TCustomRVData; ControlAction: TRVControlAction;
        ItemNo: Integer; var Control:  TControl); override;
      function GetParentData: TCustomRVData; override;
      function GetRootData: TCustomRVData; override;
      function GetAbsoluteParentData: TCustomRVData; override;
      function GetAbsoluteRootData: TCustomRVData; override;
      procedure MovingToUndoList(AContainerUndoItem: TRVUndoInfo);
      procedure MovingFromUndoList;
      function GetSeqList(AllowCreate: Boolean): TRVSeqList; override;
      {$IFNDEF RVDONOTUSELISTS}
      function GetMarkers(AllowCreate: Boolean): TRVMarkerList; override;
      {$ENDIF}
      {$IFNDEF RVDONOTUSERTFIMPORT}
      function LoadRTFFromStream(Stream: TStream):Boolean;
      function LoadRTF(const FileName: String):Boolean;
      {$ENDIF}
      {$IFNDEF RVDONOTUSERTF}
      function SaveRTFToStream(Stream: TStream; const Path: String): Boolean;
        {$IFDEF RICHVIEWDEF4} reintroduce;{$ENDIF}
      function SaveRTF(const FileName: String): Boolean;
     {$ENDIF}
     {$IFNDEF RVDONOTUSERVF}
     function LoadRVFFromStream(Stream: TStream):Boolean;
     function LoadRVF(const FileName: String):Boolean;
     function SaveRVFToStream(Stream: TStream):Boolean;
     function SaveRVF(const FileName: String):Boolean;
     function AppendRVFFromStream(Stream: TStream; ParaNo: Integer):Boolean;
     procedure DoneStyleMappings(AsSubDoc: Boolean); override;
     {$ENDIF}
     property Owner: TCustomRVItemInfo read FOwner;
  end;

{$ENDIF}

implementation

{$IFNDEF RVDONOTUSESEQ}

{============================== TRVSubData ====================================}
constructor TRVSubData.Create(AOwner: TCustomRVItemInfo; AMainRVData: TCustomRVData);
begin
  inherited Create;
  FOwner := AOwner;
  MainRVData := AMainRVData;
  FFlags := [ rvflTrim, rvflMouseXYAlwaysCorrect, rvflCanUseCustomPPI ];
end;
{------------------------------------------------------------------------------}
function TRVSubData.GetURL(id: Integer): String;
begin
  Result := '';
end;
{------------------------------------------------------------------------------}
function TRVSubData.GetFlags: TRVFlags;
begin
  Result := FFlags;
end;
{------------------------------------------------------------------------------}
procedure TRVSubData.SetFlags(const Value: TRVFlags);
begin
  FFlags := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVSubData.ControlAction2(RVData: TCustomRVData;
  ControlAction: TRVControlAction; ItemNo: Integer; var Control: TControl);
begin

end;
{------------------------------------------------------------------------------}
function TRVSubData.GetAbsoluteParentData: TCustomRVData;
begin
  Result := MainRVData.GetAbsoluteRootData;
end;
{------------------------------------------------------------------------------}
function TRVSubData.GetAbsoluteRootData: TCustomRVData;
begin
  Result := MainRVData.GetAbsoluteRootData;
end;
{------------------------------------------------------------------------------}
function TRVSubData.GetParentData: TCustomRVData;
begin
  Result := MainRVData.GetAbsoluteRootData;
end;
{------------------------------------------------------------------------------}
function TRVSubData.GetRootData: TCustomRVData;
begin
  Result := MainRVData.GetAbsoluteRootData;
end;
{------------------------------------------------------------------------------}
procedure TRVSubData.MovingFromUndoList;
var i: Integer;
begin
  for i := 0 to Items.Count-1 do
    GetItem(i).MovingFromUndoList(i,Self);
end;
{------------------------------------------------------------------------------}
procedure TRVSubData.MovingToUndoList(AContainerUndoItem: TRVUndoInfo);
var i: Integer;
begin
  for i := 0 to Items.Count-1 do
    GetItem(i).MovingToUndoList(i, Self, AContainerUndoItem);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELISTS}
procedure TRVSubData.DestroyMarkers;
begin
  FMarkers.Free;
  FMarkers := nil;
end;
{------------------------------------------------------------------------------}
function TRVSubData.GetMarkers(AllowCreate: Boolean): TRVMarkerList;
begin
  if (FMarkers=nil) and AllowCreate then begin
    FMarkers := TRVMarkerList.Create;
    FMarkers.PrevMarkerList := GetPrevMarkers;
  end;
  Result := FMarkers;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVSubData.DestroySeqList;
begin
  FSeqList.Free;
  FSeqList := nil;
end;
{------------------------------------------------------------------------------}
function TRVSubData.GetSeqList(AllowCreate: Boolean): TRVSeqList;
begin
  if (FSeqList=nil) and AllowCreate then begin
    FSeqList := TRVSeqList.Create;
  end;
  Result := FSeqList;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTFIMPORT}
function TRVSubData.LoadRTF(const FileName: String): Boolean;
begin
   Result := inherited LoadRTF(FileName)=rtf_ec_OK;
end;
{------------------------------------------------------------------------------}
function TRVSubData.LoadRTFFromStream(Stream: TStream): Boolean;
begin
   Result := inherited LoadRTFFromStream(Stream)=rtf_ec_OK;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTF}
function TRVSubData.SaveRTF(const FileName: String): Boolean;
begin
  Result := inherited SaveRTF(FileName, False, clNone, nil);
end;
{------------------------------------------------------------------------------}
function TRVSubData.SaveRTFToStream(Stream: TStream;
  const Path: String): Boolean;
begin
  Result := inherited SaveRTFToStream(Stream, Path, False,
    0, clNone, nil, nil, nil, nil, nil, nil, 0.0, True, False, nil, nil);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERVF}
function TRVSubData.LoadRVF(const FileName: String): Boolean;
var Color: TColor;
begin
  Color := clNone;
  Result := inherited LoadRVF(FileName, Color, nil, nil);
end;
{------------------------------------------------------------------------------}
function TRVSubData.LoadRVFFromStream(Stream: TStream): Boolean;
var Color: TColor;
begin
  Clear;
  Result := inherited InsertRVFFromStream(Stream,0, Color, nil, nil, False);
end;
{------------------------------------------------------------------------------}
function TRVSubData.SaveRVF(const FileName: String): Boolean;
begin
  Result := inherited SaveRVF(FileName, False, clNone, nil, nil, False);
end;
{------------------------------------------------------------------------------}
function TRVSubData.SaveRVFToStream(Stream: TStream): Boolean;
begin
  Result := inherited SaveRVFToStream(Stream, False, clNone, nil, nil, True);
end;
{------------------------------------------------------------------------------}
function TRVSubData.AppendRVFFromStream(Stream: TStream; ParaNo: Integer):Boolean;
var Color: TColor;
begin
  Color := clNone;
  Result := inherited AppendRVFFromStream(Stream, ParaNo, Color, nil);
end;
{------------------------------------------------------------------------------}
procedure TRVSubData.DoneStyleMappings(AsSubDoc: Boolean);
begin
  if not AsSubDoc then
    GetAbsoluteRootData.DoneStyleMappings(AsSubDoc);
end;
{$ENDIF}
{$ENDIF}

end.
