{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

{*************************************************************************}
{                            class TTableSection                          }
{*************************************************************************}

  constructor TTableSection.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    FText := '';
    FSectionType := stNone;
    FSection := TReportSection.Create;
    FOutputType := otText;
  end;  { Create }

  destructor TTableSection.Destroy;

  begin { Destroy }
    FSection.Free;

    inherited Destroy;
  end;  { Destroy }

  procedure TTableSection.BeforeEvent;

  begin { BeforeEvent }
    If Assigned(FOnBefore) then begin
      FOnBefore(self);
    end; { if }
  end;  { BeforeEvent }

  procedure TTableSection.SetupEvent;

  begin { SetupEvent }
    If Assigned(FOnSetup) then begin
      FOnSetup(self);
    end; { if }
  end;  { SetupEvent }

  procedure TTableSection.PrintEvent;

  begin { PrintEvent }
    If Assigned(FOnPrint) then begin
      FOnPrint(self);
    end; { if }
  end;  { PrintEvent }

  procedure TTableSection.AfterEvent;

  begin { AfterEvent }
    If Assigned(FOnAfter) then begin
      FOnAfter(self);
    end; { if }
  end;  { AfterEvent }

  procedure TTableSection.SetParent(Value: TTablePrinter);

  begin { SetParent }
    If Value <> FParent then begin
      If Assigned(FParent) and (FSectionType <> stNone) then begin
        FParent.FTableSection[FSectionType] := nil; { Remove from old FParent }
      end; { if }
      FParent := Value;
      If Assigned(FParent) and (FSectionType <> stNone) then begin
        FParent.FTableSection[FSectionType] := self; { Add to new FParent }
      end; { if }
    end; { if }
  end;  { SetParent }

{ Property Get/Set routines }

  procedure TTableSection.SetSectionType(Value: TSectionType);

  begin { SetSectionType }
    If FSectionType = stNone then begin
      FSectionType := Value;
      If Assigned(FParent) and (FSectionType <> stNone) then begin
        FParent.FTableSection[FSectionType] := self; { Add to new FParent }
      end; { if }
    end; { if }
  end;  { SetSectionType }

  procedure TTableSection.SetSection(Value: TReportSection);

  begin { SetSection }
    FSection.Assign(Value);
  end;  { SetSection }

  procedure TTableSection.PrintDefault;

  var
    Width: double;
    Height: double;

  begin { PrintDefault }
    With ReportPrinter do begin
      Case OutputType of
        otText: begin
          PrintBox;

          Width := SectionRight - SectionLeft;
          Height := SectionBottom - SectionTop;
          Case FJustifyVert of
            pjTop: begin
              LineTop := SectionTop;
            end;
            pjMiddle: begin
              LineMiddle := SectionTop + (Height / 2.0);
            end;
            pjBottom: begin
              LineBottom := SectionTop + Height;
            end;
          end; { case }

          Case Justify of
            pjCenter: begin
              PrintCenter(Text,SectionLeft + (Width / 2.0));
            end;
            pjLeft: begin
              PrintLeft(Text,SectionLeft + Margin);
            end;
            pjRight: begin
              PrintRight(Text,SectionLeft + Width - Margin);
            end;
            pjBlock: begin
              PrintBlock(Text,SectionLeft + Margin,Width - (Margin * 2.0));
            end;
          end; { case }
        end;
        otHeadings..otGrandTotals: begin
          TablePrinter.PrintSection(self);
        end;
      end; { case }
    end; { with }
  end;  { PrintDefault }

  procedure TTableSection.Print;

  var
    SaveBottom: double;

  begin { Print }
    BeforeEvent;
    With ReportPrinter do begin
      If Section.TopMethod <> dmSpecial then begin
        PushPos;
      end; { if }

      If OutputType = otText then begin
        If FUseParentFont then begin
          Canvas.Font := FParent.Font;
        end else begin
          Canvas.Font := Font;
        end; { else }
        AdjustLine;
        If (Section.MinHeight = 0) and not (SectionType in [stPageHeader,
         stPageFooter]) then begin
          Section.MinHeight := 1;
          Section.HeightMethod := hmLines;
        end; { if }
        Section.SetupSection(ReportPrinter);
        If Section.MinHeight = 0 then begin
          SectionBottom := SectionTop + LineHeight;
        end else if Section.HeightMethod = hmLines then begin
          SectionBottom := SectionTop + Section.MinHeight * LineHeight;
        end else begin
          SectionBottom := SectionTop + Section.MinHeight;
        end; { else }
        SetupEvent;
      end; { if }
      SaveBottom := SectionBottom;

    { Print Text }
      If not Assigned(FOnPrint) then begin
        PrintDefault;
      end; { else }
      PrintEvent;

    { Move LineTop for next section }
      If OutputType = otText then begin
        LineTop := SaveBottom;
      end; { if }

      If Section.TopMethod <> dmSpecial then begin
        PopPos;
      end; { if }
    end; { with }
    AfterEvent;
  end;  { Print }
