{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

{*************************************************************************}
{                            class TTableItem                             }
{*************************************************************************}

  constructor TTableItem.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    FShadeColor := clBlack;
    FShadePercent := 0;
    FMargin := 0.05;
    FOverflowMethod := omTruncateChar;
    FOverflowAppend := '';
    FOverflowReplace := '*';
    FMinFontSize := 6;
    FFont := TFont.Create;
    FPen := TPen.Create;
    FUseParentFont := true;
    FUseParentPen := true;
    FWidth := 1.0;
    FJustify := pjLeft;
    FJustifyVert := pjTop;
    FBoxLines := blAll;
  end;  { Create }

  destructor TTableItem.Destroy;

  begin { Destroy }
    SetParent(nil);
    FFont.Free;
    FPen.Free;

    inherited Destroy;
  end;  { Destroy }

  function TTableItem.HasParent: boolean;

  begin { HasParent }
    Result := true;
  end;  { HasParent }

  procedure TTableItem.ReadState(Reader: TReader);

  begin { ReadState }
    If Reader.Parent is TTablePrinter then begin
      SetParent(Reader.Parent as TTablePrinter);
    end; { if }
    inherited ReadState(Reader);
  end;  { ReadState }

  procedure TTableItem.Loaded;

  begin { Loaded }
    If UseParentFont then begin
      FFont.Assign(TablePrinter.Font);
    end; { if }
  end;  { Loaded }

{ Property Get/Set routines }

  procedure TTableItem.SetDescription(Value: TComponentName);

  var
    OldDesc: TComponentName;
    NewDesc: TComponentName;

  begin { SetDescription }
    OldDesc := DescToName(FDescription);
    NewDesc := DescToName(Value);
    If NewDesc = '' then Exit;
    If (OldDesc <> '') and (OldDesc <> NewDesc) and (Copy(Name,
     Length(Name) - Length(OldDesc) + 1,Length(OldDesc)) = OldDesc) then begin
      Name := Copy(Name,1,Length(Name) - Length(OldDesc)) + NewDesc;
    end; { if }
    FDescription := Value;
  end;  { SetDescription }

  function TTableItem.IsFontStored: boolean;

  begin { IsFontStored }
    Result := not FUseParentFont;
  end;  { IsFontStored }

  procedure TTableItem.ParentFontChanged;

  begin { ParentFontChanged }
    If UseParentFont then begin
      FFont.Assign(TablePrinter.Font);
    end; { if }
  end;  { ParentFontChanged }

  procedure TTableItem.SetFont(Value: TFont);

  begin { SetFont }
    FUseParentFont := false;
    FFont.Assign(Value);
  end;  { SetFont }

  function TTableItem.IsPenStored: boolean;

  begin { IsPenStored }
    Result := not FUseParentPen;
  end;  { IsPenStored }

  procedure TTableItem.SetPen(Value: TPen);

  begin { SetPen }
    UseParentPen := false;
    FPen.Assign(Value);
  end;  { SetPen }

  procedure TTableItem.SetShadePercent(Value: byte);

  begin { SetShadePercent }
    If Value > 100 then begin
      FShadePercent := 100;
    end else begin
      FShadePercent := Value;
    end; { else }
  end;  { SetShadePercent }

  procedure TTableItem.SetWidth(Value: double);

  begin { SetWidth }
    If ReportPrinter <> nil then begin
      FWidth := ReportPrinter.XU2I(Value);
    end else begin
      FWidth := Value;
    end; { else }
  end;  { SetWidth }

  function TTableItem.GetWidth: double;

  begin { GetWidth }
    If ReportPrinter <> nil then begin
      Result := ReportPrinter.XI2U(FWidth);
    end else begin
      Result := FWidth;
    end; { else }
  end;  { GetWidth }

  procedure TTableItem.SetMargin(Value: double);

  begin { SetMargin }
    If ReportPrinter <> nil then begin
      FMargin := ReportPrinter.XU2I(Value);
    end else begin
      FMargin := Value;
    end; { else }
  end;  { SetMargin }

  function TTableItem.GetMargin: double;

  begin { GetMargin }
    If ReportPrinter <> nil then begin
      Result := ReportPrinter.XI2U(FMargin);
    end else begin
      Result := FMargin;
    end; { else }
  end;  { GetMargin }

  procedure TTableItem.SetMargin100(Value: double);

  begin { SetMargin }
    FMargin := Value / 100.0;
  end;  { SetMargin }

  function TTableItem.GetMargin100: double;

  begin { GetMargin }
    Result := FMargin * 100.0;
  end;  { GetMargin }

  procedure TTableItem.SetOverflowMethod(Value: TOverflowMethod);

  begin { SetOverflowMethod }
    FOverflowMethod := Value;
  end;  { SetOverflowMethod }

  function TTableItem.GetOverflowMethod: TOverflowMethod;

  begin { GetOverflowMethod }
    Result := FOverflowMethod;
  end;  { GetOverflowShading }

  function TTableItem.GetReportPrinter: TBaseReport;

  begin { GetReportPrinter }
    Result := FParent.ReportPrinter;
  end;  { GetReportPrinter }

  procedure TTableItem.PrintBox;

  var
    BkMode: integer;
    BoxLineVal: integer;
    X1: double;
    Y1: double;
    Width: double;
    Height: double;

  begin { PrintBox }
    With ReportPrinter do begin
      X1 := SectionLeft;
      Y1 := SectionTop;
      Height := SectionBottom - SectionTop;
      Width := SectionRight - SectionLeft;

      If ShadePercent > 0 then begin
      { Create new brush and pen }
        Canvas.Brush.Color := ShadeToColor(ShadeColor,ShadePercent);
        Canvas.Brush.Style := bsSolid;
        Canvas.Pen.Color := clBlack;
        Canvas.Pen.Style := psClear;

      { Draw rectangle }
        BkMode := GetBkMode(Canvas.Handle);
        SetBkMode(Canvas.Handle,TRANSPARENT);
        TabRectangle(X1,Y1,X1 + Width,Y1 + Height);
        SetBkMode(Canvas.Handle,BkMode);
      end; { if }

    { Draw Box Sides }
      If FUseParentPen then begin
        Canvas.Pen.Assign(FParent.Pen);
      end else begin
        Canvas.Pen.Assign(FPen);
      end; { else }
      BoxLineVal := Ord(FBoxLines);
      If (BoxLineVal and BOXLINELEFT) > 0 then begin { Draw left line }
        MoveTo(X1,Y1);
        LineTo(X1,Y1 + Height);
      end; { if }
      If (BoxLineVal and BOXLINEBOTTOM) > 0 then begin { Draw bottom line }
        MoveTo(X1,Y1 + Height);
        LineTo(X1 + Width,Y1 + Height);
      end; { if }
      If (BoxLineVal and BOXLINERIGHT) > 0 then begin { Draw right line }
        MoveTo(X1 + Width,Y1 + Height);
        LineTo(X1 + Width,Y1);
      end; { if }
      If (BoxLineVal and BOXLINETOP) > 0 then begin { Draw top line }
        MoveTo(X1 + Width,Y1);
        LineTo(X1,Y1);
      end; { if }
    end; { with }
  end;  { PrintBox }
