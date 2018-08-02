{*********************************************************}
{* Abbrevia: AbHexVw.pas 3.02                            *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* Abbrevia: Hex View utility                            *}
{*********************************************************}

unit AbHexVw;

interface

uses
  Classes,
{$IFDEF UsingCLX}
  QStdCtrls, QGraphics,
{$ELSE}
  StdCtrls, Graphics, 
{$ENDIF}
  SysUtils;
type
  THexView = class(TMemo)
  protected
    FBlockSize : Integer;
  public
    procedure SetStream(Strm : TStream);
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property Stream : TStream write SetStream;
    property BlockSize : Integer read FBlockSize write FBlockSize;
  end;

implementation

constructor THexView.Create(AOwner : TComponent);
begin
  Inherited Create(AOwner);
  Font.Style := Font.Style + [fsBold];
  ReadOnly := True;
  ScrollBars := ssVertical;
  WordWrap := False;
  WantTabs := True;
  FBlockSize := 512;
end;

destructor THexView.Destroy;
begin
  inherited Destroy;
end;

procedure THexView.SetStream(Strm : TStream);
var
  Buff : Array[0..15] of Byte;
  i, j : Integer;
  Str : String;
  StrList : TStringList;
begin
  Strm.Seek(0, soFromBeginning);
  StrList := TStringList.Create;
  Clear;
  while Strm.Position < Strm.Size do begin
    if ((Strm.Position mod FBlockSize) = 0) then
      StrList.Add('===========================================================');
    Str := '';

    for j := 0 to 15 do
      Buff[j] := Byte(chr(0));
    Strm.Read(Buff, 16);
    Str := Str + Format('%4.4X', [strm.Position - $10]) + ':' + #9;

    for i := 0 to 15 do begin
      Str := Str + Format('%2.2X', [Buff[i]]) + ' ';
      if i = 7 then Str := Str + #9;
    end;
    Str := Str + #9;
    for i := 0 to 15 do begin
      if (Buff[i] < $30) then
        Buff[i] := byte('.');
      Str := Str + Char(Buff[i]);
    end;
    StrList.Add(Str);
  end;
  SetLines(StrList);
  StrList.Free;
end;

end.
