unit tablfunc;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Graphics, GlobType, StdCtrls, SysUtils, WinTypes,
     RpBase;

Type
  ElementTypes = (Hdr,
                  Hdr_TopLine,
                  Hdr_LeftLine,
                  Hdr_RightLine,
                  Hdr_ColSepLine,
                  Tbl_TopLine,
                  Tbl_BottomLine,
                  Tbl_LeftLine,
                  Tbl_RightLine,
                  Tbl_ColSepLine,
                  Tbl_RowSepLine);

  SizeElementTypes = (HdrFontHeight, RowFontHeight);

Const
  ElementStr : Array[ElementTypes] of String[40] = (
  { Hdr }                   'Header',
  { Hdr_TopLine }           'Header - Top Border Line',
  { Hdr_LeftLine }          'Header - Left Border Line',
  { Hdr_RightLine }         'Header - Right Border Line',
  { Hdr_ColSepLine }        'Header - Column Separating Lines',
  { Tbl_TopLine }           'Table - Top Border Line',
  { Tbl_BottomLine }        'Table - Bottom Border Line',
  { Tbl_LeftLine }          'Table - Left Border Line',
  { Tbl_RightLine }         'Table - Right Border Line',
  { Tbl_ColSepLine }        'Table - Column Separating Lines',
  { Tbl_RowSepLine }        'Table - Row Separating Lines');

  EnabledMap : Array[ElementTypes] of Byte = (1, 2, 3, 4, 11, 5, 6, 7, 8, 9, 10);
  WidthMap   : Array[ElementTypes] of Byte = (0, 1, 2, 3, 10, 4, 5, 6, 7, 8,  9);
  ColourMap  : Array[ElementTypes] of Byte = (0, 1, 2, 3, 10, 4, 5, 6, 7, 8,  9);
  FontMap    : Array[ElementTypes] of Byte = (1, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0);
  SizeMap    : Array[SizeElementTypes] of Byte = (1, 2);

Type
  ElementRecType = Record
    elFields     : Array [1..4] Of Boolean; { Specified whether following fields are used }
    elEnabled    : Boolean;
    elLineWidth  : Byte;
    elColour     : TColor;
    elFont       : fdFontDefType;
  End; { ElementRecType }

  TableObject = Class(TObject)
  Private
    TableRec : fdTableRecType;
    {Function GetEnabled (Const Idx : Byte) : Boolean;}
    {Function GetWidth   (Const Idx : Byte) : Byte;}
    {Function GetColour  (Const Idx : Byte) : TColor;}
    Function GetFont (Const Idx : Byte) : fdFontDefType;
    function GetEnabled(Index: ElementTypes): Boolean;
    procedure SetEnabled(Index: ElementTypes; Value: Boolean);
    function GetPenWidth(Index: ElementTypes): Byte;
    procedure SetPenWidth(Index: ElementTypes; Value: Byte);
    function GetColour(Index: ElementTypes): TColor;
    procedure SetColour(Index: ElementTypes; Value: TColor);
    function GetSize(Index: SizeElementTypes): Integer;
    procedure SetSize(Index: SizeElementTypes; Value: Integer);
  Public
    Procedure InitTable;
    Function GetTableRec : fdTableRecType;
    Procedure SetTableRec (Const TheTable : fdTableRecType);
    Procedure AddElementsToList (Var List_Elements : TListBox);
    Function  GetElementRec (Const ElNo : ElementTypes) : ElementRecType;
    Procedure SetElementRec (Const ElNo : ElementTypes;
                             Var   ElemRec : ElementRecType);
    {Function Enabled (Const ElNo : ElementTypes) : Boolean;}
    {Function PenWidth (Const ElNo : ElementTypes) : Byte;}
    {Function PenColour (Const ElNo : ElementTypes) : TColor;}
    Function Font (Const ElNo : ElementTypes) : fdFontDefType;
    Procedure SetFont (Const ElNo : ElementTypes; Const TheFont : fdFontDefType);
    Procedure DrawLine (Const TheCanvas              : TCanvas;
                        Const ElemIdx                : ElementTypes;
                        Const FromX, FromY, ToX, ToY : Integer);
    Procedure RepDrawLine (Const TheReport              : TBaseReport;
                           Const ElemIdx                : ElementTypes;
                           Const FromX, FromY, ToX, ToY : Integer);
    Function FontHeight (Const TheCanvas : TCanvas;
                         Const ElemIdx   : ElementTypes;
                         Const WantVisi  : Boolean) : Integer;
    Function RepFontHeight (Const TheReport : TBaseReport;
                            Const ElemIdx   : ElementTypes) : Integer;
    Procedure SetPen (Const ThePen  : TPen;
                      Const ElemIdx : ElementTypes);

    property Enabled [Index : ElementTypes] : Boolean read GetEnabled write SetEnabled;
    property PenWidth [Index : ElementTypes] : Byte read GetPenWidth write SetPenWidth;
    property PenColour [Index : ElementTypes] : TColor read GetColour write SetColour;
    property Sizes [Index : SizeElementTypes] : Integer read GetSize write SetSize;
  End; { TableObject }

implementation

Uses FormUtil;

{ Initialise the default table appearance }
Procedure TableObject.InitTable;
Var
  I : Integer;
begin
  FillChar (TableRec, SizeOf (TableRec), #0);
  With TableRec Do Begin
    For I := Low(frEnable) To High(frEnable) Do
      frEnable[I] := True;

    For I := Low(frPenWidth) To High(frPenWidth) Do
      frPenWidth[I] := 2;

    For I := Low(frColour) To High(frColour) Do
      frColour[I] := clBlack;

    Enabled[Hdr_TopLine] := False;
    Enabled[Hdr_LeftLine] := False;
    Enabled[Hdr_RightLine] := False;
    Enabled[Hdr_ColSepLine] := False;
    Enabled[Tbl_ColSepLine] := False;
    Enabled[Tbl_RowSepLine] := False;

    PenWidth[Tbl_ColSepLine] := 1;
    PenWidth[Tbl_RowSepLine] := 1;

    PenColour[Tbl_ColSepLine] := clGray;
    PenColour[Tbl_RowSepLine] := clGray;
  End; { With }
end;

Function TableObject.FontHeight (Const TheCanvas : TCanvas;
                                 Const ElemIdx   : ElementTypes;
                                 Const WantVisi  : Boolean) : Integer;
var
  TheRect : TRect;
  TmpFont : fdFontDefType;
begin { TableObject.FontHeight }
  { Take temporary copy of previous font }
  FontToRec (TheCanvas.Font, TmpFont);

  { Copy in specified font }
  FontRecToFont (TheCanvas.Font, Font(ElemIdx));
  If WantVisi Then SetVisFontHeight (TheCanvas.Font, TheCanvas.Font.Size);

  { Get size of font }
  TheRect := Rect (1, 1, 2, 2);
  DrawText (TheCanvas.Handle, 'M', 1, TheRect, (DT_CALCRECT Or DT_SINGLELINE));

  { restore temporary copy of previous font }
  FontRecToFont (TheCanvas.Font, TmpFont);

  Result := (TheRect.Bottom - TheRect.Top);
End;  { TableObject.FontHeight }

Function TableObject.RepFontHeight (Const TheReport : TBaseReport;
                                    Const ElemIdx   : ElementTypes) : Integer;
var
  TheRect : TRect;
  TmpFont : fdFontDefType;
begin { TableObject.RepFontHeight }
  { Take temporary copy of previous font }
  FontToRec (TheReport.Canvas.Font, TmpFont);

  { Copy in specified font }
  TheReport.SetFont (Font(ElemIdx).ffName, Font(ElemIdx).ffSize);

  { Get size of font }
  TheRect := Rect (1, 1, 2, 2);
  DrawText (TheReport.Canvas.Handle, 'M', 1, TheRect, (DT_CALCRECT Or DT_SINGLELINE));

  { restore temporary copy of previous font }
  TheReport.SetFont (TmpFont.ffName, TmpFont.ffSize);

  Result := (TheRect.Bottom - TheRect.Top);
End;  { TableObject.RepFontHeight }

Procedure TableObject.SetPen (Const ThePen  : TPen;
                              Const ElemIdx : ElementTypes);
begin
  ThePen.Width := PenWidth[ElemIdx];
  ThePen.Color := PenColour[ElemIdx];
  ThePen.Mode  := pmCopy;
  ThePen.Style := psSolid;
end;


Procedure TableObject.DrawLine (Const TheCanvas              : TCanvas;
                                Const ElemIdx                : ElementTypes;
                                Const FromX, FromY, ToX, ToY : Integer);
  begin
    If Enabled[ElemIdx] Then
      With TheCanvas Do Begin
        SetPen (TheCanvas.Pen, ElemIdx);

        MoveTo (FromX, FromY);
        LineTo (ToX, ToY);
      End; { If }
  End;

Procedure TableObject.RepDrawLine (Const TheReport              : TBaseReport;
                                   Const ElemIdx                : ElementTypes;
                                   Const FromX, FromY, ToX, ToY : Integer);
  begin
    If Enabled[ElemIdx] Then Begin
      TheReport.SetPen (PenColour[ElemIdx], psSolid, -PenWidth[ElemIdx], pmCopy);
      TheReport.MoveTo (FromX, FromY);
      TheReport.LineTo (ToX, ToY);
    End; { If }
  End;

Procedure TableObject.SetTableRec (Const TheTable : fdTableRecType);
begin
  TableRec := TheTable;
end;

Function TableObject.GetTableRec : fdTableRecType;
begin
  Result := TableRec;
End;

function TableObject.GetEnabled(Index: ElementTypes): Boolean;
Var
  Offset : Integer;
begin
  With TableRec Do Begin
    OffSet := EnabledMap[Index];

    If (OffSet In [Low(frEnable)..High(frEnable)]) Then
      Result := frEnable[OffSet];
  End; { With }
end;

procedure TableObject.SetEnabled(Index: ElementTypes; Value: Boolean);
Var
  Offset : Integer;
begin
  With TableRec Do Begin
    OffSet := EnabledMap[Index];

    If (OffSet In [Low(frEnable)..High(frEnable)]) Then
      frEnable[OffSet] := Value;
  End; { With }
end;

function TableObject.GetPenWidth(Index: ElementTypes): Byte;
Var
  Offset : Integer;
begin
  With TableRec Do Begin
    OffSet := WidthMap[Index];

    If (OffSet In [Low(frPenWidth)..High(frPenWidth)]) Then
      Result := frPenWidth[OffSet];
  End; { With }
end;

procedure TableObject.SetPenWidth(Index: ElementTypes; Value: Byte);
Var
  Offset : Integer;
begin
  With TableRec Do Begin
    OffSet := WidthMap[Index];

    If (OffSet In [Low(frPenWidth)..High(frPenWidth)]) Then
      frPenWidth[OffSet] := Value;
  End; { With }
end;

function TableObject.GetSize(Index: SizeElementTypes): Integer;
Var
  Offset : Integer;
begin
  With TableRec Do Begin
    OffSet := SizeMap[Index];

    If (OffSet In [Low(frSizes)..High(frSizes)]) Then
      Result := frSizes[OffSet];
  End; { With }
end;

procedure TableObject.SetSize(Index: SizeElementTypes; Value: Integer);
Var
  Offset : Integer;
begin
  With TableRec Do Begin
    OffSet := SizeMap[Index];

    If (OffSet In [Low(frSizes)..High(frSizes)]) Then
      frSizes[OffSet] := Value;
  End; { With }
end;


function TableObject.GetColour(Index: ElementTypes): TColor;
Var
  Offset : Integer;
begin
  With TableRec Do Begin
    OffSet := ColourMap[Index];

    If (OffSet In [Low(frColour)..High(frColour)]) Then
      Result := frColour[OffSet];
  End; { With }
end;

procedure TableObject.SetColour(Index: ElementTypes; Value: TColor);
Var
  Offset : Integer;
begin
  With TableRec Do Begin
    OffSet := ColourMap[Index];

    If (OffSet In [Low(frColour)..High(frColour)]) Then
      frColour[OffSet] := Value;
  End; { With }
end;

Function TableObject.GetFont (Const Idx : Byte) : fdFontDefType;
begin
  With TableRec Do
    If (Idx In [Low(frFonts)..High(frFonts)]) Then
      Result := frFonts[Idx];
end;

Function TableObject.Font (Const ElNo : ElementTypes) : fdFontDefType;
begin
  Result := GetFont(FontMap[ElNo]);
end;

Procedure TableObject.SetFont (Const ElNo : ElementTypes; Const TheFont : fdFontDefType);
Var
  Offset : Integer;
begin
  With TableRec Do Begin
    OffSet := FontMap[ElNo];

    If (OffSet In [Low(frFonts)..High(frFonts)]) Then
      frFonts[OffSet] := TheFont;
  End; { With }
end;

Procedure TableObject.AddElementsToList (Var List_Elements : TListBox);
Var
  I : ElementTypes;
begin
  For I := Low (I) To High(I) Do
    List_Elements.Items.Add (ElementStr[I]);

  If (List_Elements.Items.Count > 0) Then
    List_Elements.ItemIndex := 0;
end;

Function TableObject.GetElementRec (Const ElNo : ElementTypes) : ElementRecType;
begin
  With Result Do Begin
    elFields[1]  := (EnabledMap[ElNo] <> 0);
    elFields[2]  := (WidthMap[ElNo] <> 0);
    elFields[3]  := (ColourMap[ElNo] <> 0);
    elFields[4]  := (FontMap[ElNo] <> 0);
    elEnabled    := Enabled[ElNo];
    elLineWidth  := PenWidth[ElNo];
    elColour     := PenColour[ElNo];
    elFont       := Font (ElNo);
  End; { With }
end;

Procedure TableObject.SetElementRec (Const ElNo    : ElementTypes;
                                     Var   ElemRec : ElementRecType);
begin
  With ElemRec, TableRec Do Begin
    { Set show/hide flag }
    If elFields[1] Then
      frEnable [EnabledMap[ElNo]] := elEnabled;

    { Set width }
    If elFields[2] Then
      frPenWidth [EnabledMap[ElNo]] := elLineWidth;

    { Set colour }
    If elFields[3] Then
      frColour [EnabledMap[ElNo]] := elColour;

    { set font }
    If elFields[4] Then
      frFonts [EnabledMap[ElNo]] := elFont;
  End; { With }
end;


end.
