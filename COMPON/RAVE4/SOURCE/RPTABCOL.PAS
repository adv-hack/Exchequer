{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

{*************************************************************************}
{                            class TTableColumn                           }
{*************************************************************************}

  constructor TTableColumn.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);

    Init;
    FMemoBuf := TMemoBuf.Create;
    FSplitRow := true;
  end;  { Create }

  destructor TTableColumn.Destroy;

  begin { Destroy }
    FMemoBuf.Free;

    inherited Destroy;
  end;  { Destroy }

  procedure TTableColumn.Init;

  begin { Init }
    FSubTotal := 0.0;
    FPageTotal := 0.0;
    FGrandTotal := 0.0;
    IsDefault := false;
  end;  { Init }

  procedure TTableColumn.HeaderBeforeEvent;

  begin { HeaderBeforeEvent }
    If Assigned(FOnHeaderBefore) then begin
      FOnHeaderBefore(self);
    end; { if }
  end;  { HeaderBeforeEvent }

  procedure TTableColumn.HeaderSetupEvent;

  begin { HeaderSetupEvent }
    If Assigned(FOnHeaderSetup) then begin
      FOnHeaderSetup(self);
    end; { if }
  end;  { HeaderSetupEvent }

  procedure TTableColumn.HeaderHeightEvent(var Height: double;
                                           var MinHeight: double);

  begin { HeaderHeightEvent }
    If Assigned(FOnHeaderHeight) then begin
      FOnHeaderHeight(self,Height,MinHeight);
    end; { if }
  end;  { HeaderHeightEvent }

  procedure TTableColumn.HeaderPrintEvent(var Height: double;
                                          var MinHeight: double);

  begin { HeaderPrintEvent }
    If Assigned(FOnHeaderPrint) then begin
      FOnHeaderPrint(self,Height,MinHeight);
    end; { if }
  end;  { HeaderPrintEvent }

  procedure TTableColumn.HeaderAfterEvent;

  begin { HeaderAfterEvent }
    If Assigned(FOnHeaderAfter) then begin
      FOnHeaderAfter(self);
    end; { if }
  end;  { HeaderAfterEvent }

  procedure TTableColumn.RowBeforeEvent;

  begin { RowBeforeEvent }
    If Assigned(FOnRowBefore) then begin
      FOnRowBefore(self);
    end; { if }
  end;  { RowBeforeEvent }

  procedure TTableColumn.RowSetupEvent;

  begin { RowSetupEvent }
    If Assigned(FOnRowSetup) then begin
      FOnRowSetup(self);
    end; { if }
  end;  { RowSetupEvent }

  procedure TTableColumn.RowHeightEvent(var Height: double;
                                        var MinHeight: double);

  begin { RowHeightEvent }
    If Assigned(FOnRowHeight) then begin
      FOnRowHeight(self,Height,MinHeight);
    end; { if }
  end;  { RowHeightEvent }

  procedure TTableColumn.RowPrintEvent(var Height: double;
                                       var MinHeight: double);

  begin { RowPrintEvent }
    If Assigned(FOnRowPrint) then begin
      FOnRowPrint(self,Height,MinHeight);
    end; { if }
  end;  { RowPrintEvent }

  procedure TTableColumn.RowAfterEvent;

  begin { RowAfterEvent }
    If Assigned(FOnRowAfter) then begin
      FOnRowAfter(self);
    end; { if }
  end;  { RowAfterEvent }

  procedure TTableColumn.FooterBeforeEvent;

  begin { FooterBeforeEvent }
    If Assigned(FOnFooterBefore) then begin
      FOnFooterBefore(self);
    end; { if }
  end;  { FooterBeforeEvent }

  procedure TTableColumn.FooterSetupEvent;

  begin { FooterSetupEvent }
    If Assigned(FOnFooterSetup) then begin
      FOnFooterSetup(self);
    end; { if }
  end;  { FooterSetupEvent }

  procedure TTableColumn.FooterHeightEvent(var Height: double;
                                           var MinHeight: double);

  begin { FooterHeightEvent }
    If Assigned(FOnFooterHeight) then begin
      FOnFooterHeight(self,Height,MinHeight);
    end; { if }
  end;  { FooterHeightEvent }

  procedure TTableColumn.FooterPrintEvent(var Height: double;
                                          var MinHeight: double);

  begin { FooterPrintEvent }
    If Assigned(FOnFooterPrint) then begin
      FOnFooterPrint(self,Height,MinHeight);
    end; { if }
  end;  { FooterPrintEvent }

  procedure TTableColumn.FooterAfterEvent;

  begin { FooterAfterEvent }
    If Assigned(FOnFooterAfter) then begin
      FOnFooterAfter(self);
    end; { if }
  end;  { FooterAfterEvent }

  procedure TTableColumn.AddTotalEvent;

  begin { AddTotalEvent }
    If Assigned(FOnAddTotal) then begin
      FOnAddTotal(self);
    end; { if }
  end;  { AddTotalEvent }

  procedure TTableColumn.InitPageEvent;

  begin { InitPageEvent }
    If Assigned(FOnInitPage) then begin
      FOnInitPage(self);
    end; { if }
  end;  { InitPageEvent }

  procedure TTableColumn.InitMasterEvent;

  begin { InitMasterEvent }
    If Assigned(FOnInitMaster) then begin
      FOnInitMaster(self);
    end; { if }
  end;  { InitMasterEvent }

  procedure TTableColumn.OverflowEvent;

  begin { OverflowEvent }
    If Assigned(FOnOverflow) then begin
      FOnOverflow(self);
    end; { if }
  end;  { OverflowEvent }

  procedure TTableColumn.SetParent(Value: TTablePrinter);

  begin { SetParent }
    If Value <> FParent then begin
      If Assigned(FParent) then begin
        FParent.TableColumnList.Remove(self); { Remove from old FParent }
      end; { if }
      FParent := Value;
      If Assigned(FParent) then begin
        FParent.TableColumnList.Add(self); { Add to new FParent }
      end; { if }
    end; { if }
  end;  { SetParent }

  function TTableColumn.GetAsInteger: integer;

  begin { GetAsInteger }
    Result := Round(AsFloat);
  end;  { GetAsInteger }

  procedure TTableColumn.SetAsInteger(Value: integer);

  begin { SetAsInteger }
    MemoBuf.Text := IntToStr(Value);
  end;  { SetAsInteger }

  function TTableColumn.GetAsFloat: double;

  var
    ErrCode: integer;
    F1: double;
    S1: string;
    I1: integer;

  begin { GetAsFloat }
    S1 := MemoBuf.Text;
    I1 := 1;
    While I1 <= Length(S1) do begin
      If not (S1[I1] in ['0'..'9',DecimalSeparator,'-']) then begin
        Delete(S1,I1,1);
      end else begin
        Inc(I1);
      end; { else }
    end; { while }
    If (DecimalSeparator <> '.') and (Pos(DecimalSeparator,S1) > 0) then begin
      S1[Pos(DecimalSeparator,S1)] := '.';
    end; { if }
    Val(S1,F1,ErrCode);
    If ErrCode = 0 then begin
      Result := F1;
    end else begin
      Result := 0.0;
    end; { else }
  end;  { GetAsFloat }

  procedure TTableColumn.SetAsFloat(Value: double);

  begin { SetAsFloat }
    MemoBuf.Text := FloatToStr(Value);
  end;  { SetAsFloat }

  procedure TTableColumn.AddTotal;

  var
    F1: double;

  begin { AddTotal }
    If not Assigned(FOnAddTotal) and Totals then begin
      F1 := AsFloat;
      FSubTotal := FSubTotal + F1;
      FPageTotal := FPageTotal + F1;
      FGrandTotal := FGrandTotal + F1;
    end; { if }
    AddTotalEvent;
  end;  { AddTotal }

  procedure TTableColumn.InitPage;

  begin { InitPage }
    If not Assigned(FOnInitPage) then begin
      FPageTotal := 0.0;
    end; { if }
    InitPageEvent;
  end;  { InitPage }

  procedure TTableColumn.InitMaster;

  begin { InitMaster }
    If not Assigned(FOnInitMaster) then begin
      FSubTotal := 0.0;
    end; { else }
    InitMasterEvent;
  end;  { InitMaster }

  procedure TTableColumn.FillMemoBuf;

  begin { FillMemoBuf }
    Case OutputType of
      otText: begin
        MemoBuf.Text := '';
      end;
      otHeadings: begin
        MemoBuf.Text := Heading;
      end;
      otPageTotals: begin
        If DisplayFormat = '' then begin
          MemoBuf.Text := FloatToStr(PageTotal);
        end else begin
          MemoBuf.Text := FormatFloat(DisplayFormat,PageTotal);
        end; { else }
      end;
      otSubTotals: begin
        If DisplayFormat = '' then begin
          MemoBuf.Text := FloatToStr(SubTotal);
        end else begin
          MemoBuf.Text := FormatFloat(DisplayFormat,SubTotal);
        end; { else }
      end;
      otGrandTotals: begin
        If DisplayFormat = '' then begin
          MemoBuf.Text := FloatToStr(GrandTotal);
        end else begin
          MemoBuf.Text := FormatFloat(DisplayFormat,GrandTotal);
        end; { else }
      end;
    end; { case }
  end;  { FillMemoBuf }

  procedure TTableColumn.AddLine(    ColStream: TStream;
                                 var ColHeader: TColHeader;
                                     S1: string;
                                     ThisJustify: TPrintJustify);

  var
    ColText: TColText;

  begin { AddLine }
    With ColText do begin
      Justify := ThisJustify;
      Height := ReportPrinter.LineHeight;
      Len := Length(S1);
    end; { with }
    ColStream.WriteBuffer(ColText,SizeOf(ColText));
    If S1 <> '' then begin
      ColStream.WriteBuffer(S1[1],Length(S1));
    end; { if }
    With ColHeader do begin
      Inc(Lines);
      Inc(DataSize,SizeOf(ColText) + Length(S1));
      Height := Height + ReportPrinter.LineHeight;
    end; { with }
  end;  { AddLine }

  procedure TTableColumn.ProcessOverflow(    ColStream: TStream;
                                         var ColHeader: TColHeader;
                                             AvailWidth: double);

  var
    S1: string;
    I1: integer;
    NewWord: string;
    EOL: boolean;
    TestSize: double;
    SaveMemoPos: longint;

  begin { ProcessOverflow }
    With ReportPrinter,TableItem do begin
      Case OverflowMethod of
        omTruncateWord,omTruncateChar: begin
          SaveMemoPos := MemoBuf.Pos;
          MemoBuf.PrintEnd := AvailWidth;
          S1 := GetMemoLine(MemoBuf,EOL);
          If MemoBuf.Pos >= MemoBuf.Size then begin { One line that fits }
            AddLine(ColStream,ColHeader,S1,Justify);
          end else begin { Truncate line }
            AvailWidth := AvailWidth - TextWidth(OverflowAppend);
            MemoBuf.Pos := SaveMemoPos;
            MemoBuf.PrintEnd := AvailWidth;
            S1 := GetMemoLine(MemoBuf,EOL);
            If (OverflowMethod = omTruncateChar) and not EOL then begin { Add more }
              NewWord := MemoBuf.GetWord;
              If NewWord <> #13 then begin
                S1 := S1 + NewWord;
                I1 := Length(S1) - 1;
                While (TextWidth(Copy(S1,1,I1)) > AvailWidth) and (I1 > 0) do begin
                  Dec(I1);
                end; { while }
                S1 := Copy(S1,1,I1);
              end; { if }
            end; { if }
            While (S1 <> '') and (S1[Length(S1)] = ' ') do begin
              Delete(S1,Length(S1),1);
            end; { while }
            AddLine(ColStream,ColHeader,S1 + OverflowAppend,Justify);
          end; { else }
        end;
        omReplace: begin
        { Create largest string of OverflowChar that will fit }
          S1 := GetMemoLine(MemoBuf,EOL);
          If MemoBuf.Pos < MemoBuf.Size then begin { Still stuff in there }
            If Length(OverflowReplace) = 1 then begin
              S1 := OverflowReplace;
              While TextWidth(S1) < AvailWidth do begin
                S1 := S1 + OverflowReplace;
              end; { while }
              Delete(S1,1,1); { Delete character that broke the camel's back }
            end else begin
              S1 := OverflowReplace;
            end; { else }
          end; { if }
          AddLine(ColStream,ColHeader,S1,Justify);
        end;
        omWrap,omUser: begin
          If OverflowMethod = omUser then begin { Let user modify }
            OverflowEvent;
          end; { if }

        { Wrap the text into multiple lines }
          With MemoBuf do begin
            While Pos < Size do begin
              S1 := GetMemoLine(MemoBuf,EOL);
              If EOL and (Justify = pjBlock) then begin
                AddLine(ColStream,ColHeader,S1,pjLeft);
              end else begin
                AddLine(ColStream,ColHeader,S1,self.Justify);
              end; { else }
            end; { while }
          end; { with }
        end;
        omShrink: begin
          S1 := MemoBuf.Text;
          TestSize := FontSize;
          If ReportPrinter is TReportFiler then begin
           (ReportPrinter as TReportFiler).HoldOutput := true;
          end; { if }
          While (TextWidth(S1) > AvailWidth) and (TestSize > MinFontSize) do begin
            TestSize := TestSize - 0.1;
            FontSize := TestSize;
          end; { while }
          If ReportPrinter is TReportFiler then begin
            (ReportPrinter as TReportFiler).HoldOutput := false;
          end; { if }
          ColHeader.FontSize := FontSize;
          I1 := Length(S1);
          While (TextWidth(Copy(S1,1,I1)) > AvailWidth) and (I1 > 0) do begin
            Dec(I1);
          end; { while }
          AddLine(ColStream,ColHeader,Copy(S1,1,I1),Justify);
        end;
      end; { case }

    { Figure out minimum height }
      If SplitRow then begin
        ColHeader.MinHeight := LineHeight;
      end else begin
        ColHeader.MinHeight := ColHeader.Height;
      end; { else }
    end; { with }
  end;  { ProcessOverflow }

  procedure TTableColumn.GetRow(    ColStream: TStream;
                                var ColHeader: TColHeader);

  var
    AvailWidth: double;

  begin { GetRow }
  { Save all data into ColStream and return size }
    With ReportPrinter,TableItem do begin
      Case OutputType of
        otText: begin
          RowBeforeEvent;
        end;
        otHeadings: begin
          HeaderBeforeEvent;
        end;
        otPageTotals,otSubTotals,otGrandTotals: begin
          FooterBeforeEvent;
        end;
      end; { case }

    { Setup text line }
      If FUseParentFont then begin
        AssignFont(FParent.Font);
      end else begin
        AssignFont(Font);
      end; { else }
      AdjustLine;
      AvailWidth := Width - (Margin * 2.0);

    { Setup the memo buffer }
      MemoBuf.PrintStart := 0;
      MemoBuf.PrintEnd := AvailWidth;

      FillMemoBuf;

      Case OutputType of
        otText: begin
          RowSetupEvent;
          AddTotal;
        end;
        otHeadings: begin
          HeaderSetupEvent;
        end;
        otPageTotals,otSubTotals,otGrandTotals: begin
          FooterSetupEvent;
        end;
      end; { case }

    { Add MemoBuf to ColStream }
      ProcessOverflow(ColStream,ColHeader,AvailWidth);

    { Let user override height }
      Case OutputType of
        otText: begin
          RowHeightEvent(ColHeader.Height,ColHeader.MinHeight);
        end;
        otHeadings: begin
          HeaderHeightEvent(ColHeader.Height,ColHeader.MinHeight);
        end;
        otPageTotals,otSubTotals,otGrandTotals: begin
          FooterHeightEvent(ColHeader.Height,ColHeader.MinHeight);
        end;
      end; { case }
    end; { with }
  end;  { GetRow }

  procedure TTableColumn.PrintRow(    ColStream: TStream;
                                  var ColHeader: TColHeader;
                                      Height: double);

  var
    BeginPos: longint;
    EndPos: longint;
    ColText: TColText;
    S1: string;
    Line: integer;
    X1,Y1: double;
    PrintHeight: double;
    RemainHeight: double;
    RemainMinHeight: double;
    RemainLine: smallint;
    PrintMode: boolean;
    MinHeight: double;

  begin { PrintRow }
    If ((OutputType = otText) and Assigned(FOnRowPrint)) or
     ((OutputType = otHeadings) and Assigned(FOnHeaderPrint)) or
     ((OutputType in [otPageTotals,otSubTotals,otGrandTotals]) and
     Assigned(FOnFooterPrint)) and not IsDefault then begin
      TableItem.SaveColStream := ColStream;
      TableItem.SaveColHeader := ColHeader;
      TableItem.SaveHeight := Height;
      MinHeight := ColHeader.MinHeight;
      Case OutputType of
        otText: begin
          RowPrintEvent(Height,MinHeight);
        end;
        otHeadings: begin
          HeaderPrintEvent(Height,MinHeight);
        end;
        otPageTotals,otSubTotals,otGrandTotals: begin
          FooterPrintEvent(Height,MinHeight);
        end;
      end; { case }
      ColHeader := TableItem.SaveColHeader;
      ColHeader.Height := Height;
      ColHeader.MinHeight := MinHeight;
    end else begin
      With ReportPrinter,TableItem do begin
        PrintBox;

      { Setup font and vertical cursor position }
        If FUseParentFont then begin
          AssignFont(FParent.Font);
        end else begin
          AssignFont(Font);
        end; { else }
        AdjustLine;

      { Figure out how much height we can print and remaining amount }
        PrintHeight := 0.0;
        RemainHeight := 0.0;
        RemainMinHeight := 0.0;
        RemainLine := ColHeader.Lines + 1;
        PrintMode := true;
        BeginPos := ColStream.Position;
        For Line := 1 to ColHeader.Lines do begin
          ColStream.ReadBuffer(ColText,SizeOf(ColText));
          SetLength(S1,ColText.Len);
          If ColText.Len > 0 then begin
            ColStream.ReadBuffer(S1[1],ColText.Len);
          end; { if }
          If Line >= ColHeader.StartLine then begin
            PrintMode := PrintMode and ((PrintHeight + ColText.Height) <= (Height +
             0.00001));
            If PrintMode then begin
              PrintHeight := PrintHeight + ColText.Height;
            end; { if }
            If not PrintMode then begin
              If Line < RemainLine then begin
                RemainLine := Line;
                RemainMinHeight := ColText.Height;
              end; { if }
              RemainHeight := RemainHeight + ColText.Height;
            end; { if }
          end; { if }
        end; { for }
        EndPos := ColStream.Position;
        ColStream.Position := BeginPos;

      { Place vertical cursor }
        X1 := SectionLeft;
        Y1 := SectionTop;
        Case FJustifyVert of
          pjTop: begin
            LineTop := Y1;
          end;
          pjMiddle: begin
            LineTop := Y1 + (Height - PrintHeight) / 2.0;
          end;
          pjBottom: begin
            LineTop := Y1 + (Height - PrintHeight);
          end;
        end; { case }

        ColHeader.Height := 0.0;
        For Line := 1 to ColHeader.Lines do begin
        { Read data }
          NewPara;
          ColStream.ReadBuffer(ColText,SizeOf(ColText));
          SetLength(S1,ColText.Len);
          If ColText.Len > 0 then begin
            ColStream.ReadBuffer(S1[1],ColText.Len);
          end; { if }
          If Line >= ColHeader.StartLine then begin
            If ColHeader.FontSize > 0 then begin
              FontSize := ColHeader.FontSize;
            end; { if }
            If ColText.Height <> LineHeight then begin
              LineHeight := ColText.Height;
              AdjustLine;
            end; { if }
            If LinesLeft <= 0 then Break;

          { Print data }
            Case ColText.Justify of
              pjCenter: begin
                PrintCenter(S1,X1 + (Width / 2.0));
              end;
              pjLeft: begin
                PrintLeft(S1,X1 + Margin);
              end;
              pjRight: begin
                PrintRight(S1,X1 + Width - Margin);
              end;
              pjBlock: begin
                PrintBlock(S1,X1 + Margin,Width - (Margin * 2.0));
              end;
            end; { case }
            SoftLine;
          end; { if }
        end; { for }
        ColStream.Position := EndPos;
        ColHeader.Height := RemainHeight;
        ColHeader.StartLine := RemainLine;
        ColHeader.MinHeight := RemainMinHeight;
      end; { with }
    end; { else }
    Case OutputType of
      otText: begin
        RowAfterEvent;
      end;
      otHeadings: begin
        HeaderAfterEvent;
      end;
      otPageTotals,otSubTotals,otGrandTotals: begin
        FooterAfterEvent;
      end;
    end; { case }
  end;  { PrintRow }

  procedure TTableColumn.PrintDefault;

  begin { PrintDefault }
    IsDefault := true;
    PrintRow(TableItem.SaveColStream,TableItem.SaveColHeader,TableItem.SaveHeight);
    IsDefault := false;
  end;  { PrintDefault }
