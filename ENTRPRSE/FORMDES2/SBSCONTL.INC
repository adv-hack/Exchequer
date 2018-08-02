constructor TSBSController.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);

  ControlList := TSBSList.CreateList('Controls');
  HistoryList := TSBSList.CreateList('History');
  SelectList  := TSBSList.CreateList('Select');

  FPaper := TSBSPaperSize.Create (Self);
  FGrid  := TSBSPaperGrid.Create (Self);
  FFormDetails := TFormDetails.Create (Self);
End;

destructor TSBSController.Destroy;
begin
  { Destroy any controls remaining }
  ClearHistoryList;
  HistoryList.Free;

  SelectList.Free;
  ClearSelectList;

  FFormDetails.Free;
  FGrid.Free;
  FPaper.Free;

  ClearControlList;
  ControlList.Free;

  inherited Destroy;
end;

procedure TSBSController.Loaded;
Var
  ErrStr, MsgStr : ANSIString;
begin
  FormDetails.ResetSections;

  If (Not (csDesigning In ComponentState)) Then Begin
    { Run-Time }
    ErrStr := '';

    If (FTextMenu = Nil) Then ErrStr := 'Text Menu';
    If (FBitmapMenu = Nil) Then ErrStr := 'Bitmap Menu';
    If (FBoxMenu = Nil) Then ErrStr := 'Box Menu';
    If (FLineMenu = Nil) Then ErrStr := 'Line Menu';
    If (FPageNoMenu = Nil) Then ErrStr := 'PageNo Menu';
    If (FDbFieldMenu = Nil) Then ErrStr := 'Field Menu';
    If (FDbTableMenu = Nil) Then ErrStr := 'Table Menu';
    If (FDbFormulaMenu = Nil) Then ErrStr := 'Formula Menu';
    If (FPage = Nil) Then ErrStr := 'Page handle';

    If (ErrStr <> '') Then Begin
      MsgStr := 'ERROR: ' + ErrStr + ' not set';
      Application.MessageBox (PCHAR(ErrStr),
                              'TSBSController',
                              (MB_ICONSTOP Or MB_OK));
    End; { If }
  End; { If }
end;

procedure TSBSController.Assign(Source: TPersistent);
begin
  if Source is TSBSController then begin
    Page            := TSBSController(Source).Page;
    Popup_Text      := TSBSController(Source).Popup_Text;
    Popup_Bitmap    := TSBSController(Source).Popup_Bitmap;
    Popup_Box       := TSBSController(Source).Popup_Box;
    Popup_Line      := TSBSController(Source).Popup_Line;
    Popup_DbField   := TSBSController(Source).Popup_Dbfield;
    Popup_DbTable   := TSBSController(Source).Popup_DbTable;
    Popup_DbFormula := TSBSController(Source).Popup_DbFormula;
    Popup_Pageno    := TSBSController(Source).Popup_Pageno;

    CurrControl := TSBSController(Source).CurrControl;
    ControlList := TSBSController(Source).ControlList;
    HistoryList := TSBSController(Source).HistoryList;

    Exit;
  end; { If }

  inherited Assign(Source);
end;

{ free's any controls in the controllist }
Procedure TSBSController.ClearControlList;
Var
  ListObj : TSBSDragControl;
begin
  While (ControlList.Count > 0) Do Begin
    { Take copy of object }
    ListObj := TSBSDragControl(ControlList.Items[0]);

    { Remove object from list }
    ControlList.Delete (0);

    { Deallocate object }
    ListObj.Free;
  End; { While }
end;

Procedure TSBSController.ClearHistoryList;
Var
  ListObj : TSBSDragControl;
begin
  While (HistoryList.Count > 0) Do Begin
    { Take copy of object }
    ListObj := TSBSDragControl(HistoryList.Items[0]);

    { Remove object from list }
    HistoryList.Delete (0);

    { Deallocate object }
    ListObj.Free;
  End; { While }
end;

{ deletes any entries in the group selection list }
Procedure TSBSController.ClearSelectList;
Begin
  While (SelectList.Count > 0) Do Begin
    TSBSDragControl(SelectList.Items[0]).Invalidate;
    SelectList.Delete (0);
  End; { While }
End;

{ called by child control when its destroyed, to keep list in sync }
Procedure TSBSController.DeallocateControl (Sender: TControl);
begin
  If (ControlList.IndexOf(Sender) > -1) Then
    ControlList.Delete (ControlList.IndexOf(Sender));

  If (HistoryList.IndexOf(Sender) > -1) Then
    HistoryList.Delete (HistoryList.IndexOf(Sender));
end;

{ Sets the variable that ID's the current control }
Procedure TSBSController.SetCurrControl (Sender: TControl);
begin
  If (ControlList.IndexOf(Sender) > -1) Then
    CurrControl := Sender;
end;

Procedure TSBSController.DeleteControl (Sender: TControl);
Var
  TempControl : TSBSDragControl;
  Index       : SmallInt;
begin
  Index := ControlList.IndexOf(Sender);

  If (Index > -1) Then Begin
    { Take local copy }
    TempControl := ControlList.Items[Index];
    TempControl.DelTime := Now;

    { Hide control }
    TempControl.Hide;

    { Move into temporary list }
    ControlList.Delete (Index);
    HistoryList.Add (TempControl);

    ChangeMade;
  End; { If }
end;

{ Deletes any selected controls }
Procedure TSBSController.DeleteSelected;
Var
  I : Integer;
begin
  If (SelectList.Count > 0) Then
    For I := 0 To (SelectList.Count - 1) Do
      DeleteControl (TControl(SelectList.Items[I]));
end;

{ Displays the options dialog for the current control }
Function TSBSController.ControlOptions : Boolean;
begin
  Result := TSBSDragControl(CurrControl).OptionsDialog;
end;

Procedure TSBSController.ControlFont;
Begin
  With TSBSDragControl(CurrControl) Do Begin
    FontDialog;
    RedrawVisible;

    ChangeMade;
  End; { With }
End;

procedure TSBSController.ChangeZOrder;
begin
  If Assigned (FOnZOrder) Then
    FOnZOrder (Self);
end;

{ Resets the Z-Order for controls in the controls list }
Procedure TSBSController.SetZOrders;
Var
  I : SmallInt;
begin
  If (ControlList.Count > 0) Then Begin
    ChangeMade;

    LockWindowUpdate(Application.MainForm.Handle);
    Try
      { put controls into correct order }
      For I := 0 to (ControlList.Count - 1) Do
        TControl (ControlList.Items[I]).BringToFront;

      { repaint them }
      For I := 0 to (ControlList.Count - 1) Do
        TControl (ControlList.Items[I]).Invalidate;
    Finally
      LockWindowUpdate(0);
    End;
  End; { If }

  Page.SetSeparatorsToBack;
end;

{ moves the current control to the front of the Z-Order }
Procedure TSBSController.ControlToFront;
Var
  Index : SmallInt;
begin
  { Find Control }
  Index := ControlList.IndexOf(CurrControl);

  If (Index > -1) Then Begin
    { Move to end of control list }
    ControlList.Move (Index, ControlList.Count - 1);

    { tell windows to move it to the front }
    CurrControl.BringToFront;

    { need to redraw to cover any controls formerly on top }
    TSBSDragControl(CurrControl).Paint;

    ChangeMade;
  End; { If }

  { put separator bars to back }
  Page.SetSeparatorsToBack;
end;

{ moves the current control to the back of the Z-Order }
Procedure TSBSController.ControlToBack;
Var
  Index : SmallInt;
begin
  { Find Control }
  Index := ControlList.IndexOf(CurrControl);

  If (Index > -1) Then Begin
    { Move to end of control list }
    ControlList.Move (Index, 0);

    { tell windows to move it to the back }
    CurrControl.SendToBack;

    { need to redraw any controls on top, when we move to the back }
    TSBSDragControl(CurrControl).Paint;

    ChangeMade;
  End; { If }

  { put separator bars to back }
  Page.SetSeparatorsToBack;
end;

{ repositions and sizes the current control to fit the grid }
Procedure TSBSController.AlignControl;
begin
  Grid.SnapControlToGrid (CurrControl, True, 1);
  ChangeMade;
end;

{ returns starting coords for a new control }
procedure TSBSController.NewControlPos (TheControl : TControl);
begin
  { position centrally in client area }
  If (TheControl.Width >= Page.ClientWidth) Then
    { no room to place inside client }
    TheControl.Left := Round(Page.ClientWidth * 0.1)
  Else Begin
    TheControl.Left := ((Page.ClientWidth - TheControl.Width) Div 2);
  End; { Else }

  If (TheControl.Height >= Page.ClientHeight) Then
    { no room to place inside client }
    TheControl.Top := Round(Page.ClientHeight * 0.1)
  Else
    TheControl.Top := ((Page.ClientHeight - TheControl.Height) Div 2);
End;

procedure TSBSController.ScreenRectToClient (Var OrigRect : TRect);
begin
  OrigRect.Top := Page.ScreenToClient(Point(OrigRect.Left, OrigRect.Top)).Y;
  OrigRect.Left := Page.ScreenToClient(Point(OrigRect.Left, OrigRect.Top)).X;
  OrigRect.Right := Page.ScreenToClient(Point(OrigRect.Right, OrigRect.Bottom)).X;
  OrigRect.Bottom := Page.ScreenToClient(Point(OrigRect.Right, OrigRect.Bottom)).Y;
end;

Function TSBSController.FindControlId (Const FindId : String10) : Boolean;
Var
  I : SmallInt;
Begin
  Result := False;

  { Run throught the other controls to check its unique }
  If (ControlList.Count > 0) Then
    For I := 0 To (ControlList.Count - 1) Do
      If (TSBSDragControl(ControlList.Items[I]).ControlId = FindId) Then Begin
        Result := True;
        Break;
      End; { If }

  { check the deleted controls as well - so we can just restore them }
  If (Not Result) Then
    If (HistoryList.Count > 0) Then
      For I := 0 To (HistoryList.Count - 1) Do
        If (TSBSDragControl(HistoryList.Items[I]).ControlId = FindId) Then Begin
          Result := True;
          Break;
        End; { If }
End;

Procedure TSBSController.SetControlId (Var   Control : TControl;
                                       Const Prefix  : String10);
Var
  NewControl : TSBSDragControl;
  CId        : String10;
  IdNo       : SmallInt;
begin
  NewControl := TSBSDragControl(Control);
  IdNo := 0;
  Repeat
    Inc(IdNo);
    CId := Prefix + IntToStr(IdNo);
  Until (Not FindControlId (CId)) Or (IdNo > 999);

  NewControl.ControlId := CId;
end;

procedure TSBSController.CreateNewControl (ControlType : TSBSControlType);
Var
  NewControl : TSBSDragControl;
begin
  { Clear out any controls previously deleted }
  {ClearHistoryList;}

  NewControl := Nil;

  { Create new control }
  Case ControlType Of
    ctText      : Begin
                    NewControl := TSBSDragText.Create (Self);
                    NewControl.PopupMenu := FTextMenu;
                    NewControl.OnOptions := OnTextOptions;
                    NewControl.HelpContext := Help_Text;
                    TSBSDragText(NewControl).Font.Assign (FormDetails.ftDefaultFont);
                  End;
    ctBitmap    : Begin
                    NewControl := TSBSDragBitmap.Create (Self);
                    NewControl.PopupMenu := FBitmapMenu;
                    NewControl.OnOptions := OnBitmapOptions;
                    NewControl.HelpContext := Help_Bitmap;
                  End;
    ctBox       : Begin
                    NewControl := TSBSDragBox.Create (Self);
                    NewControl.PopupMenu := FBoxMenu;
                    NewControl.OnOptions := OnBoxOptions;
                    NewControl.HelpContext := Help_Box;
                  End;
    ctLine      : Begin
                    NewControl := TSBSDragLine.Create (Self);
                    NewControl.PopupMenu := FLineMenu;
                    NewControl.OnOptions := OnLineOptions;
                    NewControl.HelpContext := Help_Line;
                  End;
    ctDbField   : Begin
                    NewControl := TSBSDragDbField.Create (Self);
                    NewControl.PopupMenu := FDbFieldMenu;
                    NewControl.OnOptions := OnFieldOptions;
                    NewControl.HelpContext := Help_Field;
                    TSBSDragDbField(NewControl).Font.Assign (FormDetails.ftDefaultFont);
                  End;
    ctDbTable   : Begin
                    NewControl := TSBSDragDbTable.Create (Self);
                    NewControl.PopupMenu := FDbTableMenu;
                    NewControl.OnOptions := OnTableOptions;
                    NewControl.HelpContext := Help_Table;
                    TSBSDragDbTable(NewControl).SetDefaultFont (FormDetails.ftDefaultFont);
                  End;
    ctDbFormula : Begin
                    NewControl := TSBSDragFormula.Create (Self);
                    NewControl.PopupMenu := FDbFormulaMenu;
                    NewControl.OnOptions := OnFormulaOptions;
                    NewControl.HelpContext := Help_Formula;
                    TSBSDragFormula(NewControl).Font.Assign (FormDetails.ftDefaultFont);
                  End;
    ctPage      : Begin
                    NewControl := TSBSDragPage.Create (Self);
                    NewControl.PopupMenu := FPageNoMenu;
                    NewControl.OnOptions := OnPageNoOptions;
                    NewControl.HelpContext := Help_PageNo;
                    TSBSDragPage(NewControl).Font.Assign (FormDetails.ftDefaultFont);
                  End;
    ctGroup     : Begin
                    NewControl := TSBSDragGroup.Create (Self);
                    NewControl.PopupMenu := FGroupMenu;
                    NewControl.OnOptions := OnGroupOptions;
                    NewControl.HelpContext := Help_Group;
                  End;
  End; { Case }

  If (NewControl <> Nil) Then Begin
    SetControlId (TControl(NewControl), NewControl.GetIdPrefix);
    NewControl.Controller := Self;
    NewControlPos (NewControl);     { need to position, else can cause problems }

    If NewControl.OptionsDialog Then Begin
      { User has Okayed the options }
      {RedrawVisible;}
      NewControl.Visible := False;
      NewControl.Parent := FPage;
      NewControl.SetInitialSize;
      NewControlPos (NewControl);
      Grid.SnapControlToGrid (NewControl, False, 0);
      NewControl.Visible := True;
      ControlList.Add (NewControl);
      CurrControl := NewControl;
      NewControl.MoveToFront;
      NewControl.SetFocus;
      ChangeMade;
      SelectControl (NewControl, False);
    End { If }
    Else
      { Users has cancelled - destroy the control }
      If Assigned (NewControl) Then
        NewControl.Free;
  End; { If }
end;

{ Repaints the area covered by the control, and any controls over it }
{ Called when Drag controls are dropped in position                  }
{Procedure TSBSController.PaintControlPage (TheControl : TControl);}
Procedure TSBSController.PaintControlPage (TheControlRect : TRect);
Var
  TempControl                   : TSBSDragControl;
  PageRect, aRect, ControlRect  : TRect;
  I                             : SmallInt;
begin
  FPage.PaintRect (TheControlRect);

  If (ControlList.Count > 0) Then
    For I := 0 To (ControlList.Count - 1) Do Begin
      TempControl := TSBSDragControl(ControlList.Items[I]);

      If IntersectRect (aRect, TheControlRect, TempControl.BoundsRect) Then
        TempControl.Paint;
    End; { For }
end;

{ Paints any controls on top of, and positioned over the passed control }
Procedure TSBSController.PaintTopControls (PaintControl : TControl);
Var
  Index, I       : SmallInt;
  aRect          : TRect;
begin
  { Find Control }
  Index := ControlList.IndexOf(PaintControl);

  If (Index > -1) And (Index < (ControlList.Count - 1)) Then
    For I := (Index + 1) To (ControlList.Count - 1) Do
      If IntersectRect (aRect, PaintControl.BoundsRect, TControl (ControlList.Items[I]).BoundsRect) Then Begin
        TSBSDragControl (ControlList.Items[I]).Paint;
      End; { If }
end;

{ Paints any controls that intersect with the passed control }
{ Called by separator bars when they paint                     }
Procedure TSBSController.PaintControlRects (PaintControl : TControl);
Var
  TheControl : TControl;
  DestRect   : TRect;
  I          : SmallInt;
begin
  If (ControlList.Count > 0) Then Begin
    { Check controls to see if they intersect }
    For I := 0 To (ControlList.Count - 1) Do Begin
      TheControl := TControl(ControlList.Items[I]);
      If IntersectRect (DestRect, PaintControl.BoundsRect, TheControl.BoundsRect) Then
        TSBSDragControl (ControlList.Items[I]).Paint;
    End; { For }
  End; { If }
end;

{ Paints any controls that intersect with the passed control }
Procedure TSBSController.PaintControlFores (TheControlRect : TRect);
Var
  TheControl : TControl;
  DestRect   : TRect;
  I          : SmallInt;
begin
  If (ControlList.Count > 0) Then Begin
    { Check controls to see if they intersect }
    For I := 0 To (ControlList.Count - 1) Do Begin
      TheControl := TControl(ControlList.Items[I]);
      If IntersectRect (DestRect, TheControlRect, TheControl.BoundsRect) Then
        TSBSDragControl (ControlList.Items[I]).PaintForeGround;
    End; { For }
  End; { If }
end;

procedure TSBSController.SetPaper(Value: TSBSPaperSize);
begin
  If PaperHandleSet Then Begin
    Paper.Assign(Value);
    Page.Invalidate;
  End;
end;

procedure TSBSController.SetGrid(Value: TSBSPaperGrid);
begin
  If GridHandleSet Then Begin
    Grid.Assign(Value);
    Page.Invalidate;
  End;
end;

Procedure TSBSController.UpdateBitmap;
begin
  If PageHandleSet Then
    FPage.FBitmap.UpdateBitmap;
end;

Function TSBSController.PaperHandleSet : Boolean;
begin
  Result := Assigned(FPaper);
End;

Function TSBSController.GridHandleSet : Boolean;
begin
  Result := Assigned(FGrid);
End;

Function TSBSController.PageHandleSet : Boolean;
begin
  Result := Assigned(FPage);
End;

procedure TSBSController.CreateControl (Const ControlDef : FormDefRecType;Const AddToSel : Boolean);
Var
  NewControl : TSBSDragControl;
begin
  { Clear out any controls previously deleted }
  {ClearHistoryList;}

  NewControl := Nil;

  { Create new control }
  Case ControlDef.fdFieldClass Of
    fdcText       : Begin
                      NewControl := TSBSDragText.Create (Self);
                      NewControl.PopupMenu := FTextMenu;
                      NewControl.Controller := Self;
                      NewControl.OnOptions := OnTextOptions;
                      NewControl.HelpContext := Help_Text;
                      TSBSDragText(NewControl).InitByDefRec (ControlDef);
                    End;
    fdcBitmap     : Begin
                      NewControl := TSBSDragBitmap.Create (Self);
                      NewControl.PopupMenu := FBitmapMenu;
                      NewControl.Controller := Self;
                      NewControl.OnOptions := OnBitmapOptions;
                      NewControl.HelpContext := Help_Bitmap;
                      TSBSDragBitmap(NewControl).InitByDefRec (ControlDef);
                    End;
    fdcLine       : Begin
                      NewControl := TSBSDragLine.Create (Self);
                      NewControl.PopupMenu := FLineMenu;
                      NewControl.Controller := Self;
                      NewControl.OnOptions := OnLineOptions;
                      NewControl.HelpContext := Help_Line;
                      TSBSDragLine(NewControl).InitByDefRec (ControlDef);
                    End;
    fdcBox        : Begin
                      NewControl := TSBSDragBox.Create (Self);
                      NewControl.PopupMenu := FBoxMenu;
                      NewControl.Controller := Self;
                      NewControl.OnOptions := OnBoxOptions;
                      NewControl.HelpContext := Help_Box;
                      TSBSDragBox(NewControl).InitByDefRec (ControlDef);
                    End;
    fdcPage       : Begin
                      NewControl := TSBSDragPage.Create (Self);
                      NewControl.PopupMenu := FPageNoMenu;
                      NewControl.Controller := Self;
                      NewControl.OnOptions := OnPageNoOptions;
                      NewControl.HelpContext := Help_PageNo;
                      TSBSDragPage(NewControl).InitByDefRec (ControlDef);
                    End;
    fdcDbfield    : Begin
                      NewControl := TSBSDragDbField.Create (Self);
                      NewControl.PopupMenu := FDbFieldMenu;
                      NewControl.Controller := Self;
                      NewControl.OnOptions := OnFieldOptions;
                      NewControl.HelpContext := Help_Field;
                      TSBSDragDbField(NewControl).InitByDefRec (ControlDef);
                    End;
    fdcTable      : Begin
                      NewControl := TSBSDragDbTable.Create (Self);
                      NewControl.PopupMenu := FDbTableMenu;
                      NewControl.Controller := Self;
                      NewControl.OnOptions := OnTableOptions;
                      NewControl.HelpContext := Help_Table;
                      TSBSDragDbTable(NewControl).InitByDefRec (ControlDef);
                      LastTable := TSBSDragDbTable(NewControl);
                    End;
    fdcFieldCol,
    fdcFormulaCol : If Assigned (LastTable) Then Begin
                      TSBSDragDbTable(LastTable).InitColumnByDefRec (ControlDef);
                    End; { If }
    fdcFormula    : Begin
                      NewControl := TSBSDragFormula.Create (Self);
                      NewControl.PopupMenu := FDbFormulaMenu;
                      NewControl.Controller := Self;
                      NewControl.OnOptions := OnFormulaOptions;
                      NewControl.HelpContext := Help_Formula;
                      TSBSDragFormula(NewControl).InitByDefRec (ControlDef);
                    End;
    fdcGroup      : Begin
                      NewControl := TSBSDragGroup.Create (Self);
                      NewControl.PopupMenu := FGroupMenu;
                      NewControl.Controller := Self;
                      NewControl.OnOptions := OnGroupOptions;
                      NewControl.HelpContext := Help_Group;
                      TSBSDragGroup(NewControl).InitByDefRec (ControlDef);
                   End;
  End; { Case }

  If (NewControl <> Nil) Then Begin
    { Check its got a unique ControlId }
    If FindControlId (NewControl.ControlId) Then
      SetControlId (TControl(NewControl), NewControl.GetIdPrefix);

    { Add to form }
    NewControl.Parent := FPage;
    ControlList.Add (NewControl);
    CurrControl := NewControl;
    NewControl.MoveToFront;

    If AddToSel Then SelectControl (NewControl, True);
  End; { If }
end;

procedure TSBSController.ChangeMade;
begin
  FormDetails.ChangesMade := True;
end;

{ repaints the visible area of the page }
Procedure TSBSController.RedrawVisible;
begin
  PaintControlPage (FPage.ClientRect);
end;

Procedure TSBSController.EditIf;
begin
  If Assigned (CurrControl) And Assigned (FOnIf) Then
    FOnIf (CurrControl, Nil);
end;

Procedure TSBSController.EditCopy;
Var
  Data               : THandle;
  SendRec            : ^FormDefClipType;
  TableControl       : TSBSDragDbTable;
  Items, I, J, RecNo : SmallInt;

  Function MemSize (Const Items : SmallInt) : LongInt;
  Begin
    Result := SizeOf (SmallInt) + (Items * SizeOf (FormDefRecType));
  End;

Begin
  If (SelectList.Count > 0) Then Begin
    { calc number of records we need to put into the list }
    Items := 0;
    TableControl := Nil;
    For I := 0 To (SelectList.Count -1) Do Begin
      Inc (Items);

      If (TControl(SelectList.Items[I]) Is TSBSDragDbTable) Then Begin
        { need to add space for columns }
        TableControl := TSBSDragDbTable(SelectList.Items[I]);

        Items := Items + TableControl.Columns.Count;
      End; { If }
    End; { For }

    If (Items <= 50) Then Begin
      { Get global memory }
      Data := GlobalAlloc (GMEM_MOVEABLE, MemSize(Items));
      Try
        SendRec := GlobalLock (Data);
        Try
          SendRec^.NoItems := Items;

          RecNo := 1;
          For I := 0 To (SelectList.Count -1) Do Begin
            SendRec^.Items[RecNo] := TSBSDragControl(SelectList.Items[I]).GetDefRec;
            Inc (RecNo);

            If Assigned(TableControl) And (TControl(SelectList.Items[I]) = TableControl) Then
              For J := 0 To (TableControl.Columns.Count - 1) Do Begin
                SendRec^.Items[RecNo] := TFormDefListObjType(TableControl.Columns.Items[J]).FormDef;
                Inc (RecNo);
              End; { For }
          End; { For }

          ClipBoard.SetAsHandle (CF_DragControl, Data);
        Finally
          GlobalUnlock (Data);
        End;
      Except
        GlobalFree (Data);
        Raise;
      End;
    End { If }
    Else
      { Error - only 50 controls can be copied at once }
      MessageDlg ('Only 50 controls can be copied at one time, please reduce the ' +
                  'number of controls selected and try again', mtWarning, [mbOk], 0);
  End; { If }
End;

Procedure TSBSController.EditPaste;
Var
  Data    : THandle;
  I       : SmallInt;
  SendRec : ^FormDefClipType;
  LocalSend : FormDefClipType;
  TempRec : FormDefRecType;
begin
  { Get global memory }
  Data := ClipBoard.GetAsHandle (CF_DragControl);
  Try
    ClearSelectList;

    If (Data = 0) Then Exit;

    SendRec := GlobalLock (Data);
    Try
      If (SendRec^.NoItems > 0) Then Begin
        LocalSend.NoItems := SendRec^.NoItems;
        For I := 1 To SendRec^.NoItems Do Begin
          { have to copy into a local var otherwise the global memory gets }
          { completely screwed up when its used, handy huh!!!              }
          LocalSend.Items[I] := SendRec^.Items[I];
        End; { For }

        Try
          LockWindowUpdate(Application.MainForm.Handle);          { disable window painting }

          For I := 1 To LocalSend.NoItems Do
            CreateControl (LocalSend.Items[I], True);
        Finally
          LockWindowUpdate(0);               { enable window painting }
        End;
      End; { If }
    Finally
      GlobalUnlock (Data);
    End;
  Except
    GlobalFree (Data);
    Raise;
  End;
End;

Procedure TSBSController.EditCut;
Var
  I : SmallInt;
Begin
  { Copy into clipboard }
  EditCopy;

  { delete from form }
  DeleteSelected;
  {If (SelectList.Count > 0) Then
    For I := 0 To (SelectList.Count - 1) Do
      DeleteControl (TControl(SelectList.Items[I]));}
End;

Procedure TSBSController.Control1;
Begin
  If Assigned (CurrControl) Then Begin
    If CurrControl Is TSBSDragGroup Then
      With CurrControl As TSBSDragGroup Do Begin
        AddNewRow;
      End; { With }
  End; { If }
End;

Procedure TSBSController.Control2;
Begin
  If Assigned (CurrControl) Then Begin
    If CurrControl Is TSBSDragGroup Then
      With CurrControl As TSBSDragGroup Do Begin
        DeleteRow;
      End; { With }
  End; { If }
End;


Function TSBSController.GetGroup (Const TheControl : TControl) : String10;
Var
  Group : TSBSDragGroup;
  I     : SmallInt;
begin
  Result := '';

  For I := 0 To (ControlList.Count - 1) Do Begin
    If (TSBSDragControl(ControlList.Items[I]) Is TSBSDragGroup) And
       (ControlList.Items[I] <> TheControl) Then Begin
      Group := TSBSDragGroup(ControlList.Items[I]);

      If (Group.BoundsRect.Top <= TheControl.BoundsRect.Top) And
         (TheControl.BoundsRect.Top <= Group.BoundsRect .Bottom) And
         (Group.BoundsRect.Left <= TheControl.BoundsRect.Left) And
         (TheControl.BoundsRect.Left <= Group.BoundsRect.Right) Then Begin
        Result := Group.ControlId;
        {ShowMessage (TSBSDragControl(TheControl).ControlId + ': ' + Group.ControlId);}
      End; { If }
    End; { If }
  End; { For }
end;

Procedure TSBSController.SelectArea (Const SelectRect : TRect);
Var
  aRect : TRect;
  I     : SmallInt;
Begin
  ClearSelectList;

  If (ControlList.Count > 0) Then
    For I := 0 To (ControlList.Count - 1) Do
      If IntersectRect (aRect, SelectRect, TSBSDragControl(ControlList.Items[I]).BoundsRect) Then Begin
        { This control has been selected }
        SelectList.Add (ControlList.Items[I]);
        TControl(ControlList.Items[I]).Invalidate;
        TSBSDragControl(ControlList.Items[I]).SetFocus;
      End; { If }
End;

Function TSBSController.IsSelected (Const TheControl : TControl) : Boolean;
Begin
  Result := (SelectList.IndexOf(TheControl) > -1);
End;

Procedure TSBSController.SelectControl (Const TheControl : TControl;
                                        Const Append     : Boolean);
Begin
  If (Not Append) Then ClearSelectList;

  SelectList.Add (TheControl);
  TheControl.Invalidate;
End;

Procedure TSBSController.DeSelectControl (Const TheControl : TControl);
Begin
  If (SelectList.IndexOf(TheControl) > -1) Then Begin
    SelectList.Delete (SelectList.IndexOf(TheControl));
    TheControl.Invalidate;
  End; { If }
End;

Procedure TSBSController.SelectMove (Const TheControl : TControl;
                                     Const XOff, YOff : SmallInt;
                                     Const Mode       : Byte);
Var
  I : SmallInt;
Begin
  If (SelectList.Count > 0) Then Begin
    If (Mode = 3) Then LockWindowUpdate (Application.MainForm.Handle);
    Try
      { move the controls }
      If (Mode In [1..4, 6]) Then
        For I := 0 To (SelectList.Count - 1) Do
          If (TControl(SelectList.Items[I]) <> TheControl) Then
            TSBSDragControl(SelectList.Items[I]).SelectMove(XOff, YOff, Mode);

      { repaint them }
      If (Mode In [3, 4]) Then
        For I := 0 To (SelectList.Count - 1) Do
          If (TControl(SelectList.Items[I]) <> TheControl) Then
            TSBSDragControl(SelectList.Items[I]).Invalidate;

      { delete them }
      If (Mode = 5) Then
        DeleteSelected;
        {For I := 0 To (SelectList.Count - 1) Do
          If (TControl(SelectList.Items[I]) <> TheControl) Then
            DeleteControl (TSBSDragControl(SelectList.Items[I]));}
    Finally
      If (Mode = 3) Then LockWindowUpdate (0);
    End;
  End; { If }
End;

{ returns true if the passed control is the only one selected }
Function TSBSController.JustMe (Const TheControl : TControl) : Boolean;
Begin
  Result := (SelectList.Count = 1) And (SelectList.IndexOf(TheControl) > -1);
End;

{ Returns True if the passed control is entirely covered by a bitmap }
Function TSBSController.BmpCovered (Const TheControl : TControl) : Boolean;
Var
  Control1, Control2 : TSBSDragControl;
  Index, I           : SmallInt;
Begin
  Result := False;

  Control1 := TSBSDragControl(TheControl);

  { Find passed Control }
  Index := ControlList.IndexOf(Control1);

  If (Index > -1) And (Index < (ControlList.Count - 1)) Then Begin
    { Found Control }
    For I := (Index + 1) To (ControlList.Count - 1) Do Begin
      { Detect whether control is a bitmap }
      Control2 := TSBSDragControl(ControlList.Items[I]);

      Result := Control2.IsOpaque And
                (Control1.BoundsRect.Left >= Control2.BoundsRect.Left) And
                (Control1.BoundsRect.Right <= Control2.BoundsRect.Right) And
                (Control1.BoundsRect.Top >= Control2.BoundsRect.Top) And
                (Control1.BoundsRect.Bottom <= Control2.BoundsRect.Bottom);

      If Result Then
        Break;
    End; { For }
  End; { If }
End;



