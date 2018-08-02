constructor TFormDetails.Create(AControl: TSBSController);
begin
  Inherited Create;

  { Take copy of pointer to parent page control }
  FController := AControl;
  fhDefaultFont := TFont.Create;
  ChangesMade := False;
  Loading := False;

  { Set SystemInfo Font Handle }
  SystemInfo.DefaultFont := fhDefaultFont;

  { Initialise to default settings }
  InitDefaultForm;
end;

destructor TFormDetails.Destroy;
begin
  { Release bitmap control }
  fhDefaultFont.Free;

  Inherited Destroy;
end;

Procedure TFormDetails.InitDefaultForm;
Var
  I : Integer;
begin
  ftFormType  := ftForm;
  ftFormDescr := '';
  ftFormPath  := '';

  ftPaperWidth   := 210;
  ftPaperHeight  := 297;
  ftTopMargin    := 20;
  ftBottomMargin := 20;
  ftLeftMargin   := 10;
  ftRightMargin  := 10;


  ftSections    := [stPageHead, stBodyHead,
                    stBody, stBodyFoot,
                    stPageFoot];
  ftOrientation := fdoPortrait;
  ftCopies      := 1;

  { page header: 15% }
  { body header: 20% }
  { body:        55% }
  { body footer:  5% }
  { page footer: 10% }
  ftHeaderSep   := Trunc(ftPaperHeight * 0.15 * FController.Paper.psScaling);
  ftBodyHeadSep := Trunc(ftPaperHeight * 0.35 * FController.Paper.psScaling);
  ftBodySep     := Trunc(ftPaperHeight * 0.85 * FController.Paper.psScaling);
  ftBodyFootSep := Trunc(ftPaperHeight * 0.90 * FController.Paper.psScaling);

  With fhDefaultFont Do Begin
    Color := clBlack;
    Name  := 'Arial';
    Pitch := fpDefault;
    Size  := 9;
    Style := [];
  End; { With }

  For I := Low(SVStrs) To High (SVStrs) Do
    SVStrs [I] := '';

  ftContinue := '';
  fhSerNo := 0;
  fhSerNoWidth := 0;

  // HM v4.32 06/02/01: Added support for printing hidden ADJ lines
  fhPrintAdjBom := 0;

  // HM v4.32 -6/02/01: Added support for sorting normal documents
  fhDocSortMode := 0;

  // HM v5.52 28/08/03: Added support for Multi-Bins
  fhShowBins   := False;
  fhShowUseBy  := False;
  fhShowInpSNo := False;

  // HM 03/11/03 v5.52: Added flag to sort Picking Lists in StockCode+BinPriority order
  fhStockOrder := False;

  // HM 14/01/04: v5.60 Added flag to control whether Additional Description Lines are shown on Picking Lists
  fhShowAddDesc := False;

  // MH 04/09/06: IAO/v5.71 - Added additional flags for picking lists
  fhShowDescOnly := False;  // Include non-stock/description only lines in single picking lists
  fhInclNewLines := False;  // Include TL's with 0 Picking Run Number

  If Assigned (FController) Then Begin
    { Get rid of any loaded controls }
    FController.ClearSelectList;
    FController.ClearControlList;
    FController.ClearHistoryList;

    { Move page to top left }
    If Assigned (FController.Page) Then Begin
      FController.Page.VertScrollBar.Position := 0;
      FController.Page.HorzScrollBar.Position := 0;
    End; { If }
  End; { If }

  ChangesMade := False;
end;

Procedure TFormDetails.InitDefaultLabel;
Var
  I : Integer;
begin
  InitDefaultForm;

  ftFormType  := ftLabel;

  ftLbTop       := 9;  { top of label 1 }
  ftLbLeft      := 6;  { left of label 1 }
  ftLbWidth     := 98;  { label width }
  ftLbHeight    := 38;  { label height }
  ftLbCols      := 2;  { labels across }
  ftLbRows      := 7;  { labels down }
  ftLbColGap    := 2;  { Horizontal gap between labels }
  ftLbRowGap    := 2;  { Vertical gap between labels }

  {ftTopMargin    := ftLbTop;
  ftBottomMargin := ftPaperHeight - ftLbTop - ftLbHeight;
  ftLeftMargin   := ftLbLeft;
  ftRightMargin  := ftPaperWidth - ftLbLeft - ftLbWidth;}

  ChangesMade := False;
end;

Procedure TFormDetails.SetPaperWidth(Value : Word);
Begin
  If (Value <> fhPaperWidth) Then Begin
    fhPaperWidth := Value;
    {FController.FPage.Paper.psPaperWidth := Value;}
    FController.UpdateBitmap;
    ChangesMade := True;
  End; { If }
End;

Procedure TFormDetails.SetPaperHeight(Value : Word);
Begin
  If (Value <> fhPaperHeight) Then Begin
    fhPaperHeight := Value;
    {FController.FPage.Paper.psPaperHeight := Value;}
    FController.UpdateBitmap;
    ChangesMade := True;
  End; { If }
End;

Procedure TFormDetails.SetTopMargin(Value : Word);
Begin
  If (Value <> fhTopWaste) Then Begin
    fhTopWaste := Value;
    {FController.FPage.Paper.psTop := Value;}
    FController.UpdateBitmap;
    ChangesMade := True;
  End; { If }
End;

Procedure TFormDetails.SetBottomMargin(Value : Word);
Begin
  If (Value <> fhBottomWaste) Then Begin
    fhBottomWaste := Value;
    {FController.FPage.Paper.psBottom := Value;}
    FController.UpdateBitmap;
    ChangesMade := True;
  End; { If }
End;

Procedure TFormDetails.SetLeftMargin(Value : Word);
Begin
  If (Value <> fhLeftWaste) Then Begin
    fhLeftWaste := Value;
    {FController.FPage.Paper.psLeft := Value;}
    FController.UpdateBitmap;
    ChangesMade := True;
  End; { If }
End;

Procedure TFormDetails.SetRightMargin(Value : Word);
Begin
  If (Value <> fhRightWaste) Then Begin
    fhRightWaste := Value;
    FController.UpdateBitmap;
    ChangesMade := True;
  End; { If }
End;

Procedure TFormDetails.SetFormType(Value : fdFormTypeType);
Begin
  If (Value <> fhFormType) Then Begin
    fhFormType := Value;
    ChangesMade := True;
  End; { If }
End;

Function TFormDetails.GetWorkingHeight : LongInt;
begin
  If (ftOrientation = fdoPortrait) Then
    Result := ftPaperHeight - ftTopMargin - ftBottomMargin
  Else
    Result := ftPaperWidth - ftLeftMargin - ftRightMargin
End;

Function TFormDetails.GetWorkingWidth : LongInt;
begin
  If (ftOrientation = fdoPortrait) Then
    Result := ftPaperWidth - ftLeftMargin - ftRightMargin
  Else
    Result := ftPaperHeight - ftTopMargin - ftBottomMargin;
End;

Procedure TFormDetails.SetDefaultFont(Value : TFont);
begin
  fhDefaultFont.Assign (Value);
  ChangesMade := True;
end;

Procedure TFormDetails.SetOrientation(Value : fdOrientationType);
Begin
  If (fhOrientation <> Value) Then Begin
    ChangesMade := True;
    fhOrientation := Value;
    FController.UpdateBitmap;
  End; { If }
End;

Procedure TFormDetails.SetSections(Value : TPageStructureSet);
Begin
  {If (Value <> fhSections) Then Begin}
    fhSections  := [stPageHead, stBodyHead,
                    stBody, stBodyFoot,
                    stPageFoot];
    {fhSections := Value;}
    ChangesMade := True;

    ResetSections;
  {End; { If }
End;

Procedure TFormDetails.ResetSections;
begin
  If FController.PageHandleSet Then
    With FController.FPage Do Begin
      FSections[1].SetEnable (stPageHead In fhSections);
      FSections[2].SetEnable (stBodyHead In fhSections);
      FSections[3].SetEnable (stBody In fhSections);
      FSections[4].SetEnable (stBodyFoot In fhSections);
    End; { With }
end;

Function TFormDetails.ValidateName : Boolean;
begin
  { Check its not blank }
  Result := (fhFormDescr <> '');
end;

Function TFormDetails.ValidatePath : Boolean;
begin
  { Check its not blank }
  Result := (fhFormPath <> '');

  { Check its unique }
end;

{ Copies a Strings record into the form details }
Procedure TFormDetails.StrRecToDetails (Const StrRec : fdFormStringsType);
Var
  I : Integer;
begin
  With StrRec Do Begin
    For I := Low(fsSVStrs) To High(fsSVStrs) Do
      SVStrs[I] := fsSvStrs[I];
  End; { With }
end;

{ Copies the form details into a Strings record }
Procedure TFormDetails.DetailsToStrRec (Var StrRec : fdFormStringsType);
Var
  I : Integer;
begin
  FillChar (StrRec, SizeOf (StrRec), #0);
  With StrRec Do Begin
    For I := Low(fsSVStrs) To High(fsSVStrs) Do
      fsSVStrs[I] := SvStrs[I];
  End; { With }
end;

{ Copies a Header record into the form details }
Procedure TFormDetails.HedRecToDetails (Const HedRec : fdHeaderRecType);
begin
  Loading := True;

  ftFormType     := HedRec.fhFormType;
  ftFormDescr    := HedRec.fhFormDescr;
  ftCopies       := HedRec.fhCopies;
  ftPaperWidth   := HedRec.fhPaperWidth;
  ftPaperHeight  := HedRec.fhPaperHeight;
  ftTopMargin    := HedRec.fhTopWaste;
  ftLeftMargin   := HedRec.fhLeftWaste;
  ftRightMargin  := HedRec.fhRightWaste;
  ftBottomMargin := HedRec.fhBottomWaste;
  ftSections     := HedRec.fhSections;
  ftOrientation  := HedRec.fhOrientation;
  ftBodyFootSep  := HedRec.fhBodyFootSep; { Set backwards otherwise it don't work }
  ftBodySep      := HedRec.fhBodySep;
  ftBodyHeadSep  := HedRec.fhBodyHeadSep;
  ftHeaderSep    := HedRec.fhHeaderSep;

  With HedRec.fhFont Do Begin
    ftDefaultFont.Name   := ffName;
    ftDefaultFont.Size   := ffSize;
    ftDefaultFont.Color  := ffColor;
    ftDefaultFont.Style  := ffStyle;
    ftDefaultFont.Pitch  := ffPitch;
    ftDefaultFont.Height := ffHeight;
  End; { With }

  ftContinue   := HedRec.fhContinue;
  fhSerNo      := HedRec.fhSerialNo;
  fhSerNoWidth := HedRec.fhSNoWidth;
  fhShowInpSNo := HedRec.fhInpSNo;

  ftPrinter    := HedRec.fhPrinter;
  ftBinId      := HedRec.fhBinNo;
  ftPaperId    := HedRec.fhPaperNo;

  ftLbTop      := HedRec.fhLblTop;
  ftLbLeft     := HedRec.fhLblLeft;
  ftLbWidth    := HedRec.fhLblWidth;
  ftLbHeight   := HedRec.fhLblHeight;
  ftLbCols     := HedRec.fhLblCols;
  ftLbRows     := HedRec.fhLblRows;
  ftLbColGap   := HedRec.fhLblColGap;
  ftLbRowGap   := HedRec.fhLblRowGap;
  ftPurpose    := HedRec.fhPurpose;

  { I think I should be doing something here with the details               }
  { 20/02/96: Can't think what this comment means?                          }
  { 17/04/96: Still Can't                                                   }
  { 29/10/96: Dimebar?                                                      }
  { 03/02/97: ?                                                             }
  { HM 06/02/01: The above comments worry me, what idiot wrote this system? }


  // HM v4.32 06/02/01: Added support for printing hidden ADJ lines
  fhPrintAdjBom := HedRec.fhPrintAdjBom;

  // HM v4.32 -6/02/01: Added support for sorting normal documents
  fhDocSortMode := HedRec.fhDocSortMode;

  // HM 28/08/03: Extended Serial no support and added Multi-Bin Support
  fhShowBins    := HedRec.fhShowBins;
  fhShowUseBy   := HedRec.fhShowUseBy;

  // HM 03/11/03 v5.52: Added flag to sort Picking Lists in StockCode+BinPriority order
  fhStockOrder  := HedRec.fhStockOrder;

  // HM 14/01/04: v5.60 Added flag to control whether Additional Description Lines are shown on Picking Lists
  fhShowAddDesc := HedRec.fhShowAddDesc;

  // MH 18/04/06: IAO/v55.71 - Added flag to stop the form updating the last letter info for Debt Chase Letters
  fhSuppressDL  := HedRec.fhSuppressDL;

  // MH 04/09/06: IAO/v5.71 - Added additional flags for picking lists
  fhShowDescOnly := HedRec.fhShowDescOnly;  // Include non-stock/description only lines in single picking lists
  fhInclNewLines := HedRec.fhInclNewLines;  // Include TL's with 0 Picking Run Number

  // MH 13/03/09: v6.01 - Added additional additional flags for picking lists
  fhExplodeBoMs := HedRec.fhExplodeBoMs;   // Explode Hidden Bill of Materials Line into Picking Lists


  Loading := False;
end;

{ Copies form details into a Header record }
Procedure TFormDetails.DetailsToHedRec (Var HedRec : fdHeaderRecType);
begin
  FillChar (HedRec, SizeOf(HedRec), #0);

  HedRec.fhFormType := ftFormType;

  HedRec.fhFormDescr := ftFormDescr;
  HedRec.fhCopies    := ftCopies;

  HedRec.fhPaperWidth  := ftPaperWidth;
  HedRec.fhPaperHeight := ftPaperHeight;
  HedRec.fhTopWaste    := ftTopMargin;
  HedRec.fhLeftWaste   := ftLeftMargin;
  HedRec.fhRightWaste  := ftRightMargin;
  HedRec.fhBottomWaste := ftBottomMargin;
  HedRec.fhSections    := ftSections;
  HedRec.fhOrientation := ftOrientation;
  HedRec.fhHeaderSep   := ftHeaderSep;
  HedRec.fhBodyHeadSep := ftBodyHeadSep;
  HedRec.fhBodySep     := ftBodySep;
  HedRec.fhBodyFootSep := ftBodyFootSep;

  With HedRec.fhFont Do Begin
    ffName  := ftDefaultFont.Name;
    ffSize  := ftDefaultFont.Size;
    ffColor := ftDefaultFont.Color;
    ffStyle := ftDefaultFont.Style;
    ffPitch := ftDefaultFont.Pitch;
    ffHeight:= ftDefaultFont.Height;
  End; { With }

  HedRec.fhContinue := ftContinue;
  HedRec.fhSerialNo := fhSerNo;
  HedRec.fhSNoWidth := fhSerNoWidth;
  HedRec.fhInpSNo   := fhShowInpSNo;

  HedRec.fhPrinter  := ftPrinter;
  HedRec.fhBinNo    := ftBinId;
  HedRec.fhPaperNo  := ftPaperId;

  HedRec.fhLblTop    := ftLbTop;
  HedRec.fhLblLeft   := ftLbLeft;
  HedRec.fhLblWidth  := ftLbWidth;
  HedRec.fhLblHeight := ftLbHeight;
  HedRec.fhLblCols   := ftLbCols;
  HedRec.fhLblRows   := ftLbRows;
  HedRec.fhLblColGap := ftLbColGap;
  HedRec.fhLblRowGap := ftLbRowGap;
  HedRec.fhPurpose   := ftPurpose;

  // HM v4.32 06/02/01: Added support for printing hidden ADJ lines
  HedRec.fhPrintAdjBom := fhPrintAdjBom;

  // HM v4.32 -6/02/01: Added support for sorting normal documents
  HedRec.fhDocSortMode := fhDocSortMode;

  // HM 28/08/03: Extended Serial no support and added Multi-Bin Support
  HedRec.fhShowBins    := fhShowBins;
  HedRec.fhShowUseBy   := fhShowUseBy;

  // HM 03/11/03 v5.52: Added flag to sort Picking Lists in StockCode+BinPriority order
  HedRec.fhStockOrder  := fhStockOrder;

  // HM 14/01/04: v5.60 Added flag to control whether Additional Description Lines are shown on Picking Lists
  HedRec.fhShowAddDesc := fhShowAddDesc;

  // MH 18/04/06: IAO/v55.71 - Added flag to stop the form updating the last letter info for Debt Chase Letters
  HedRec.fhSuppressDL  := fhSuppressDL;

  // MH 04/09/06: IAO/v5.71 - Added additional flags for picking lists
  HedRec.fhShowDescOnly := fhShowDescOnly;  // Include non-stock/description only lines in single picking lists
  HedRec.fhInclNewLines := fhInclNewLines;  // Include TL's with 0 Picking Run Number

  // MH 13/03/09: v6.01 - Added additional additional flags for picking lists
  HedRec.fhExplodeBoMs := fhExplodeBoMs;  // Explode Hidden Bill of Materials Line into Picking Lists
end;

{ Returns the class for the passed control }
Function TFormDetails.GetRepClass (TheControl : TControl) : fdRepClassType;
Var
  CtrlTop : LongInt;
begin
  If (Not (TheControl Is TSBSDragDbTable)) And (fhFormType <> ftLabel) Then Begin
    { Not a Table and Not a Label }
    CtrlTop := TheControl.Top + FController.FPage.VertScrollBar.Position;

    Result := fdrPageFoot;

    If (stBodyFoot In fhSections) And (CtrlTop < ftBodyFootSep) Then
      Result := fdrPageBodyFoot;

    If (stBody In fhSections) And (CtrlTop < ftBodySep) Then
      Result := fdrPageBody;

    If (stBodyHead In fhSections) And (CtrlTop < ftBodyHeadSep) Then
      Result := fdrPageBodyHead;

    If (stPageHead In fhSections) And (CtrlTop < ftHeaderSep) Then
      Result := fdrPageHead;
  End { If }
  Else Begin
    { Table or Label }
    Result := fdrPageBody;
  End; { Else }
end;

Procedure TFormDetails.SetHeaderSep(Value : Word);
begin
  fhHeaderSep := Value;

  If FController.PageHandleSet Then
    With FController.FPage Do
      If (FSections[1].Top <> Value) Then
        If Loading Then
          FSections[1].Top := Value - VertScrollBar.Position
        Else
          FSections[1].Top := FSections[1].TopOk(Value - VertScrollBar.Position);
end;

Procedure TFormDetails.SetBodyHeadSep(Value : Word);
begin
  fhBodyHeadSep := Value;

  If FController.PageHandleSet Then
    With FController.FPage Do
      If (FSections[2].Top <> Value) Then
        If Loading Then
          FSections[2].Top := Value - VertScrollBar.Position
        Else
          FSections[2].Top := FSections[2].TopOk(Value - VertScrollBar.Position);
end;

Procedure TFormDetails.SetBodySep(Value : Word);
begin
  fhBodySep := Value;

  If FController.PageHandleSet Then
    With FController.FPage Do
      If (FSections[3].Top <> Value) Then
        If Loading Then
          FSections[3].Top := Value - VertScrollBar.Position
        Else
          FSections[3].Top := FSections[3].TopOk(Value - VertScrollBar.Position);
end;

Procedure TFormDetails.SetBodyFootSep(Value : Word);
begin
  fhBodyFootSep := Value;

  If FController.PageHandleSet Then
    With FController.FPage Do
      If (FSections[4].Top <> Value) Then
        If Loading Then
          FSections[4].Top := Value - VertScrollBar.Position
        Else
          FSections[4].Top := FSections[4].TopOk(Value - VertScrollBar.Position);
end;

Procedure TFormDetails.SetDefPrinter(Value : ShortString);
begin
  If (fhPrinter <> Value) Then Begin
    ChangesMade := True;
    fhPrinter := Value;
  End; { If }
end;

Procedure TFormDetails.SetBinId(Value : LongInt);
begin
  If (fhBinId <> Value) Then Begin
    ChangesMade := True;
    fhBinId := Value;
  End; { If }
end;


Procedure TFormDetails.SetPaperId(Value : LongInt);
begin
  If (fhPaperId <> Value) Then Begin
    ChangesMade := True;
    fhPaperId := Value;
  End; { If }
end;


Procedure TFormDetails.SetLbTop(Value : Word);
begin
  If (fhLbTop <> Value) Then Begin
    ChangesMade := True;
    fhLbTop := Value;

    RecalcLabelMargins;
  End; { If }
end;

Procedure TFormDetails.SetLbLeft(Value : Word);
begin
  If (fhLbLeft <> Value) Then Begin
    ChangesMade := True;
    fhLbLeft := Value;

    RecalcLabelMargins;
  End; { If }
end;

Procedure TFormDetails.SetLbWidth(Value : Word);
begin
  If (fhLbWidth <> Value) Then Begin
    ChangesMade := True;
    fhLbWidth := Value;

    RecalcLabelMargins;
  End; { If }
end;

Procedure TFormDetails.SetLbHeight(Value : Word);
begin
  If (fhLbHeight <> Value) Then Begin
    ChangesMade := True;
    fhLbHeight := Value;

    RecalcLabelMargins;
  End; { If }
end;

Procedure TFormDetails.SetLbCols(Value : Byte);
begin
  If (fhLbCols <> Value) Then Begin
    ChangesMade := True;
    fhLbCols := Value;
  End; { If }
end;

Procedure TFormDetails.SetLbRows(Value : Byte);
begin
  If (fhLbRows <> Value) Then Begin
    ChangesMade := True;
    fhLbRows := Value;
  End; { If }
end;

Procedure TFormDetails.SetLbColGap(Value : Word);
begin
  If (fhLbColGap <> Value) Then Begin
    ChangesMade := True;
    fhLbColGap := Value;
  End; { If }
end;

Procedure TFormDetails.SetLbRowGap(Value : Word);
begin
  If (fhLbRowGap <> Value) Then Begin
    ChangesMade := True;
    fhLbRowGap := Value;
  End; { If }
end;

Procedure TFormDetails.RecalcLabelMargins;
Begin
  If (ftFormType = ftLabel) Then
    If (ftOrientation = fdoPortrait) Then Begin
      { Portrait }
      ftTopMargin    := fhLbTop;
      ftBottomMargin := ftPaperHeight - fhLbTop - fhLbHeight;
      ftLeftMargin   := fhLbLeft;
      ftRightMargin  := ftPaperWidth - fhLbLeft - fhLbWidth;
    End { If }
    Else Begin
      { Landscape }
      ftTopMargin    := ftPaperHeight - fhLbLeft - fhLbWidth;
      ftBottomMargin := fhLbLeft;
      ftLeftMargin   := fhLbTop;
      ftRightMargin  := ftPaperWidth - fhLbTop - fhLbHeight;
    End; { Else }
End;

Procedure TFormDetails.SetPurpose(Value : Byte);
Begin
  If (fhPurpose <> Value) Then Begin
    ChangesMade := True;
    fhPurpose := Value;
  End; { If }
End;



