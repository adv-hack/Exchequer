unit LblDlg1U;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, GlobType;

type
  LabelPosList = Array [1..1000] Of TRect;
  XRefList     = Array [1..1000] Of SmallInt;

  TBaseLabelDialog = class(TForm)
    Image_Labels: TImage;
    Procedure PaintLabel(Sender: TObject);
    procedure Image_LabelsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Image_LabelsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    BackBuffer   : TBitmap;
    LastX, LastY : LongInt;
    NumLabels    : SmallInt;
    LabelPos     : ^LabelPosList;
    XRefs        : ^XRefList;
    Function GetActiveLabel : SmallInt;
    Procedure SetActiveLabel(Value : SmallInt);
  public
    { Public declarations }
    FActiveLabel : SmallInt;
    HeaderRec    : fdHeaderRecType;
    Property ActiveLabel : SmallInt read GetActiveLabel write SetActiveLabel;
  end;

{var
  BaseLabelDialog: TBaseLabelDialog;}

implementation

{$R *.DFM}

procedure TBaseLabelDialog.FormCreate(Sender: TObject);
begin
  BackBuffer := TBitmap.Create;
  With BackBuffer Do Begin
    Height := Image_Labels.Height;
    Width := Image_Labels.Width;
  End; { With }

  NumLabels := 0;
  GetMem (LabelPos, SizeOf (LabelPos^));
  FillChar (LabelPos^, SizeOf (LabelPos^), #0);
  GetMem (XRefs, SizeOf (XRefs^));
  FillChar (XRefs^, SizeOf (XRefs^), #0);

  ActiveLabel := 1;
end;

procedure TBaseLabelDialog.FormDestroy(Sender: TObject);
begin
  GetMem (XRefs, SizeOf (XRefs^));
  FreeMem (LabelPos, SizeOf (LabelPos^));
  BackBuffer.Free;
end;

Procedure TBaseLabelDialog.PaintLabel(Sender: TObject);
Var
  TempInt,
  TopOfs, LeftOfs,
  scLblW, scLblH,
  vImTop, hImLeft,
  ScaleHeight, ScaleWidth,
  ScaleTopMarg, ScaleBottomMarg,
  ScaleLeftMarg, ScaleRightMarg : LongInt;
  PageScale                     : Double;
  I, J                          : Byte;

  Function ToScale (Num, Add : LongInt) : LongInt;
  Begin
    Result := Trunc((Num / PageScale) + Add);
  End;

  Procedure LabelNo (LblId, LabelNo : LongInt);
  Var
    XOfs, YOfs : LongInt;
    LabelStr   : String;
  Begin
    With BackBuffer.Canvas do Begin
      LabelStr := IntToStr(LabelNo);

      XOfs := Round(((LabelPos^[LblId].Right - LabelPos^[LblId].Left) - TextWidth (LabelStr)) / 2);
      YOfs := Round(((LabelPos^[LblId].Bottom - LabelPos^[LblId].Top) - TextHeight (LabelStr)) / 2);

      TextOut (LabelPos^[LblId].Left + XOfs, LabelPos^[LblId].Top + YOfs, LabelStr);
    End; { With }
  End;

begin
  If Self.Visible And Assigned (Image_Labels) Then Begin
    With BackBuffer.Canvas do Begin
      { Calculate a Page Scale to map the page onto the image }
      {PageScale := Trunc (HeaderRec.fhPaperHeight / (Image_Label.Height * 0.9)) + 1;}
      PageScale := HeaderRec.fhPaperHeight / (Image_Labels.Height * 0.9);

      { Calculate the scale sizes }
      ScaleHeight := Round((HeaderRec.fhPaperHeight / PageScale) + 2); { + 1 for each border }
      ScaleWidth := Round((HeaderRec.fhPaperWidth / PageScale) + 2); { + 1 for each border }

      If (HeaderRec.fhOrientation = fdoLandScape) Then Begin
        TempInt     := ScaleHeight;
        ScaleHeight := ScaleWidth;
        ScaleWidth  := TempInt;
      End; { If }

      { Fill Background }
      Pen.Color := clBtnFace;
      Brush.Color := clBtnFace;
      FillRect (ClientRect);

      vImTop  := (Image_Labels.Height - ScaleHeight) Div 2;
      hImLeft := (Image_Labels.Width - ScaleWidth) Div 2;

      { Draw Shadow }
      Pen.Color := clBtnShadow;
      Brush.Color := clBtnShadow;
      Rectangle (hImLeft + 5,
                 vImTop + 5,
                 (hImLeft  + ScaleWidth) + 5,
                 (vImTop + ScaleHeight) + 5);

      { Draw Page }
      Pen.Color := clBlack;
      Brush.Color := clWhite;
      Rectangle (hImLeft,
                 vImTop,
                 (hImLeft  + ScaleWidth),
                 (vImTop + ScaleHeight));

      { Draw Labels }
      NumLabels := 0;
      Pen.Color := clSilver;
      Brush.Color := clWhite;
      scLblW := ToScale (HeaderRec.fhLblWidth, 0); { + 1 for each border }
      scLblH := ToScale (HeaderRec.fhLblHeight, 0); { + 1 for each border }
      If (HeaderRec.fhOrientation = fdoPortrait) Then Begin
        TopOfs := vImTop + ToScale(HeaderRec.fhLblTop, 0);
        For I := 1 To HeaderRec.fhLblRows Do Begin
          LeftOfs := hImLeft + ToScale(HeaderRec.fhLblLeft, 0);

          For J := 1 to HeaderRec.fhLblCols Do Begin
            { Set colour for active label }
            If (FActiveLabel = Succ(NumLabels)) Then Pen.Color := clRed Else Pen.Color := clSilver;

            { Draw Label }
            Rectangle (LeftOfs,
                       TopOfs,
                       LeftOfs + scLblW,
                       TopOfs + scLblH);

            Inc (NumLabels);
            With LabelPos^[NumLabels] Do Begin
              Left   := LeftOfs;
              Top    := TopOfs;
              Right  := LeftOfs + scLblW;
              Bottom := TopOfs + scLblH;
            End; { With }

            XRefs^[NumLabels] := NumLabels;

            LabelNo (NumLabels, NumLabels);

            LeftOfs := LeftOfs + scLblW + ToScale(HeaderRec.fhLblColGap, 0);
          End; { For }

          TopOfs := TopOfs + scLblH + ToScale(HeaderRec.fhLblRowGap, 0);
        End; { For }

        { Draw Arrow to indicate direction paper enters printer }
        Pen.Color := clNavy;
        MoveTo (10, Round((Image_Labels.Height / 2) + 26));
        LineTo (10, Round((Image_Labels.Height / 2) - 26));
        LineTo ( 9, Round((Image_Labels.Height / 2) - 25));
        LineTo (11, Round((Image_Labels.Height / 2) - 25));
        LineTo (12, Round((Image_Labels.Height / 2) - 24));
        LineTo ( 8, Round((Image_Labels.Height / 2) - 24));
        LineTo ( 7, Round((Image_Labels.Height / 2) - 23));
        LineTo (13, Round((Image_Labels.Height / 2) - 23));
        LineTo (14, Round((Image_Labels.Height / 2) - 22));
        LineTo (6,  Round((Image_Labels.Height / 2) - 22));
        LineTo (7,  Round((Image_Labels.Height / 2) - 22));
      End { If }
      Else Begin
        { Landscape }
        LeftOfs := hImLeft + ToScale(HeaderRec.fhLblLeft, 0);
        For I := 1 To HeaderRec.fhLblCols Do Begin
          TopOfs := vImTop + ToScale(HeaderRec.fhLblLeft, 0);

          For J := 1 to HeaderRec.fhLblRows Do Begin
            { Set colour for active label }
            If (FActiveLabel = Succ(NumLabels)) Then Pen.Color := clRed Else Pen.Color := clSilver;

            { Draw Label }
            Rectangle (LeftOfs,
                       TopOfs,
                       LeftOfs + scLblW,
                       TopOfs + scLblH);

            Inc (NumLabels);
            With LabelPos^[NumLabels] Do Begin
              Left   := LeftOfs;
              Top    := TopOfs;
              Right  := LeftOfs + scLblW;
              Bottom := TopOfs + scLblH;
            End; { With }

            XRefs^[NumLabels] := ((HeaderRec.fhLblCols - I) * HeaderRec.fhLblRows) + J;

            LabelNo (NumLabels, XRefs^[NumLabels]);

            TopOfs := TopOfs + scLblH + ToScale(HeaderRec.fhLblRowGap, 0);
          End; { For }

          LeftOfs := LeftOfs + scLblW + ToScale(HeaderRec.fhLblColGap, 0);
        End; { For }

        { Draw Arrow to indicate direction paper enters printer }
        Pen.Color := clNavy;
        LeftOfs := Round(Image_Labels.Width / 2);
        TopOfs := Image_Labels.Height - 10;
        MoveTo (LeftOfs - 26, TopOfs);
        LineTo (LeftOfs + 26, TopOfs);
        LineTo (LeftOfs + 25, TopOfs - 1);
        LineTo (LeftOfs + 25, TopOfs + 1);
        LineTo (LeftOfs + 24, TopOfs + 2);
        LineTo (LeftOfs + 24, TopOfs - 2);
        LineTo (LeftOfs + 23, TopOfs - 3);
        LineTo (LeftOfs + 23, TopOfs + 3);
        LineTo (LeftOfs + 22, TopOfs + 4);
        LineTo (LeftOfs + 22, TopOfs - 4);
        LineTo (LeftOfs + 22, TopOfs - 5);
      End; { Else }
    End; { With }

    { Copy BackBuffer image on to the window image }
    Image_Labels.Canvas.CopyMode := cmSrcCopy;
    Image_Labels.Canvas.CopyRect (Image_Labels.ClientRect, BackBuffer.Canvas, Image_Labels.ClientRect);
  End; { If }
end;

procedure TBaseLabelDialog.Image_LabelsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LastX := X;
  LastY := Y;
end;

procedure TBaseLabelDialog.Image_LabelsClick(Sender: TObject);
Var
  I, Tmp : SmallInt;
begin
  { Select active label }
  Tmp := FActiveLabel;
  If (NumLabels > 0) Then
    For I := 1 To NumLabels Do
      With LabelPos^[I] Do
        If (Left <= LastX) And (LastX <= Right) And
           (Top <= LastY) And (LastY <= Bottom) Then
          FActiveLabel := I;

  If (Tmp <> FActiveLabel) Then
    PaintLabel(Self);
end;

procedure TBaseLabelDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
  TmpActive : LongInt;
begin
  If (ssAlt In Shift) Then
    With HeaderRec Do Begin
      TmpActive := FActiveLabel;

      Case Key Of
        VK_END   : If (fhOrientation = fdoPortrait) Then
                     FActiveLabel := NumLabels
                   Else
                     FActiveLabel := fhLblRows;
        VK_HOME  : If (fhOrientation = fdoPortrait) Then
                     FActiveLabel := 1
                   Else
                     FActiveLabel := Succ(Pred(HeaderRec.fhLblCols) * HeaderRec.fhLblRows);
        VK_LEFT  : If (fhOrientation = fdoPortrait) Then Begin
                     If ((FActiveLabel Mod fhLblCols) <> 1) Then
                       Dec(FActiveLabel);
                   End { If }
                   Else Begin
                     If (FActiveLabel > fhLblRows) Then
                       FActiveLabel := FActiveLabel - fhLblRows;
                   End; { Else }
        VK_UP    : If (fhOrientation = fdoPortrait) Then Begin
                     If (FActiveLabel > fhLblCols) Then
                       FActiveLabel := FActiveLabel - fhLblCols;
                   End { If }
                   Else Begin
                     If ((FActiveLabel Mod fhLblRows) <> 1) Then
                       Dec(FActiveLabel);
                   End; { Else }
        VK_RIGHT : If (fhOrientation = fdoPortrait) Then Begin
                     If ((FActiveLabel Mod fhLblCols) <> 0) Then
                       Inc(FActiveLabel);
                   End { If }
                   Else Begin
                     If (FActiveLabel <= (NumLabels - fhLblRows)) Then
                       FActiveLabel := FActiveLabel + fhLblRows;
                   End; { Else }
        VK_DOWN  : If (fhOrientation = fdoPortrait) Then Begin
                     If (FActiveLabel <= (NumLabels - fhLblCols)) Then
                       FActiveLabel := FActiveLabel + fhLblCols;
                   End { If }
                   Else Begin
                     If ((FActiveLabel Mod fhLblRows) <> 0) Then
                       Inc(FActiveLabel);
                   End; { Else }
      End; { Case }

      { repaint page if changed }
      If (TmpActive <> FActiveLabel) Then Begin
        PaintLabel(Self);
        Key := 0;
      End; { If }
    End; { With }
end;

Function TBaseLabelDialog.GetActiveLabel : SmallInt;
Begin
  Result := XRefs^[FActiveLabel];
End;

Procedure TBaseLabelDialog.SetActiveLabel(Value : SmallInt);
Begin
  FActiveLabel := Value;
End;

end.
