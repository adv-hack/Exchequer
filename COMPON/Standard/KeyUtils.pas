unit KeyUtils;

interface

Uses Classes, ComCtrls, Controls, {Grids, }StdCtrls, TEditVal,
     {uMultiList, uScrollBar, }Messages, Windows, Forms, SysUtils;

Const
  WM_CustGetRec = WM_User+$1;

// Standard routine used on Forms for converting Enter keypresses into Tabs,
// requires KeyPreview = True on the form.  Example:-
//
//    procedure TfrmProductDetails.FormKeyPress(Sender: TObject; var Key: Char);
//    begin
//      GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
//    end;
//
Procedure GlobFormKeyPress(    Sender        : TObject;
                           Var Key           : Char;
                               ActiveControl : TWinControl;
                               Handle        : THandle);

// Standard routine used on Forms for converting Enter keypresses into Tabs,
// requires KeyPreview = True on the form.  Example:-
//
//    procedure TfrmProductDetails.FormKeyDown(Sender: TObject; var Key: Word;
//      Shift: TShiftState);
//    begin
//      GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
//    end;
//
procedure GlobFormKeyDown (    Sender        : TObject;
                           Var Key           : Word;
                               Shift         : TShiftState;
                               ActiveControl : TWinControl;
                               Handle        : THandle);

// Checks the control type and returns TRUE if we should convert the ENTER
// characters to TAB characters for the control, and FALSE if the control
// needs the ENTER characters ffor its own processing
Function ReplaceEntersForControl (Const ActiveControl : TWinControl) : Boolean;


implementation

//-------------------------------------------------------------------------

Function IsMultiListComponent (Const ActiveControl : TWinControl) : Boolean;
Begin // IsMultiListComponent
  Result := (ActiveControl.ClassName = 'TMultiList') Or
            (ActiveControl.ClassName = 'TDBMultiList') Or
            (ActiveControl.ClassName = 'TCustomScrollBar') Or
            (ActiveControl.ClassName = 'TMLCaptureEdit');
End; // IsMultiListComponent

//------------------------------

// Checks the control type and returns TRUE if we should convert the ENTER
// characters to TAB characters for the control, and FALSE if the control
// needs the ENTER characters ffor its own processing
Function ReplaceEntersForControl (Const ActiveControl : TWinControl) : Boolean;
Begin // ReplaceEntersForControl
  Result := Assigned(ActiveControl);

  If Result Then
  Begin
    If (ActiveControl is TSBSComboBox) then
    Begin
      With (ActiveControl as TSBSComboBox) Do
      Begin
        Result := (Not InDropDown);
      End; // With (ActiveControl as TSBSComboBox)
    End // If (ActiveControl is TSBSComboBox)
    Else
    Begin
      If (ActiveControl is TUpDown) or

// HM 02/09/04: Extended routines to handle memo's intelligently
//         ((ActiveControl is TMemo) and (Not (ActiveControl is TCurrencyEdit))) or  // NOTE: CurrencyEdit inherites from TMemo

// MH 01/09/04: In order to reduce the components overhead I have stopped it
// compiling in the Grids package which saves ~55k from each app.
         //(ActiveControl is TStringGrid) or
         (ActiveControl.ClassName = 'TStringGrid') Or

// MH 01/09/04: In order to reduce the components overhead I have stopped it
// compiling in the MultiList package which saves ~150k from each app.
//       (ActiveControl is TMultiList) or
//       (ActiveControl is TCustomScrollBar) Then
         IsMultiListComponent (ActiveControl) Then
      Begin
        Result := FALSE;
      End; // If (ActiveControl is ...
    End; // Else
  End; // If Result
End; // ReplaceEntersForControl

//-------------------------------------------------------------------------

// Standard routine used on Forms for converting Enter keypresses into Tabs,
// requires KeyPreview = True on the form.  Example:-
//
//    procedure TfrmProductDetails.FormKeyPress(Sender: TObject; var Key: Char);
//    begin
//      GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
//    end;
//
Procedure GlobFormKeyPress(    Sender        : TObject;
                           Var Key           : Char;
                               ActiveControl : TWinControl;
                               Handle        : THandle);
Begin // GlobFormKeyPress
  If ((Key = #13) Or (Key = #10)) And ReplaceEntersForControl(ActiveControl) Then
  Begin
    Key := #0;
  End; // If ((Key = #13) Or (Key = #10)) And ReplaceEntersForControl(ActiveControl)
End; // GlobFormKeyPress

//-------------------------------------------------------------------------

// Standard routine used on Forms for converting Enter keypresses into Tabs,
// requires KeyPreview = True on the form.  Example:-
//
//    procedure TfrmProductDetails.FormKeyDown(Sender: TObject; var Key: Word;
//      Shift: TShiftState);
//    begin
//      GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
//    end;
//
procedure GlobFormKeyDown (    Sender        : TObject;
                           Var Key           : Word;
                               Shift         : TShiftState;
                               ActiveControl : TWinControl;
                               Handle        : THandle);

  //------------------------------

  Procedure ClickOk(Sender : TObject; Var VKey : Word);
  Var
    n : Integer;
  Begin // ClickOk
    If (Sender is TForm) Then
    begin
      With Sender As TForm Do
      Begin
        For n := 0 to Pred(ComponentCount) Do
        Begin
          If (Components[n] is TButton) Then
          Begin
            With Components[n] As TButton Do
            Begin
              If ((Caption = 'OK') Or (Caption = '&OK') Or (ModalResult = mrOk)) And
                 Enabled And Visible And CanFocus Then
              Begin
                VKey := 0;
                Click;
                Exit;
              End; // If ((Caption = 'OK') Or ...
            End; // With Components[n] As TButton
          End; // If (Components[n] is TButton)
        End; //For n
      End; // With Sender As TForm
    End; // If (Sender is TForm)
  End; // ClickOk

  //------------------------------

  // Returns TRUE if the Cursor Up/Down should be replaced with Tabs for the
  // ActiveControl.
  Function ReplaceUpDownsForControl(Const ActiveControl : TWinControl; Const CursorUp : Boolean) : Boolean;
  Var
    CRLFPos : LongInt;
  Begin // ReplaceUpDownsForControl
    If (ActiveControl Is TMemo) Then
    Begin
      With (ActiveControl As TMemo) Do
      Begin
        // Always replace up/downs with Tab if no lines or one line
        Result := (Lines.Count <= 1) Or (Trim(Text) = '');

        If (Not Result) Then
        Begin
          // Examine the contents of the memo to determine whether we want to Tab
          If CursorUp Then
          Begin
            // Return TRUE if we are on the top line of the memo
            CRLFPos := Pos(#13#10, Text);
            Result := (CRLFPos = 0) Or (SelStart <= CRLFPos);
          End // If CursorUp
          Else
          Begin
            // Return TRUE if we are on the bottom line of the memo
            CRLFPos := LastDelimiter (#10, Text);
            Result := (CRLFPos = 0) Or (SelStart >= CRLFPos);
          End; // Else
        End; // If (Not Result)
      End // If
    End // If (ActiveControl Is TMemo)
    Else
    Begin
      If (ActiveControl Is TComboBox) Then
      Begin
        Result := Not (ActiveControl As TComboBox).DroppedDown;
      End // If (ActiveControl Is TComboBox)
      Else
        Result := Not ((ActiveControl is TListBox) Or
                       (ActiveControl is TListView) Or
                       (ActiveControl.ClassName = 'TVirtualStringTree') Or
                       (ActiveControl.ClassName = 'TTreeView') Or
                       (ActiveControl.ClassName = 'TCheckListBox') Or
                       (ActiveControl.ClassName = 'TShellTreeView2005') Or
                       IsMultiListComponent(ActiveControl))
    End; // Else
  End; // ReplaceUpDownsForControl

  //------------------------------

Begin // GlobFormKeyDown
  If (Shift = []) And ReplaceEntersForControl(ActiveControl) Then
  Begin
    Case Key of
      VK_UP      : If ReplaceUpDownsForControl(ActiveControl, True) Then
                   Begin
                     PostMessage(Handle,wm_NextDlgCtl,1,0);
                     Key:=0;
                   End; // VK_UP

//      VK_RETURN,
//      VK_DOWN    : Begin
////                     If ((Not (ActiveControl is TBorCheck)) and (Not(ActiveControl is TBorRadio))) or
////                        (Key=VK_Return) then
////                     Begin
////                       PostMessage(Handle,wm_NextDlgCtl,0,0);
////                       Key:=0;
////                     end
////                     else
////                       Key:=Vk_Tab;
//                     PostMessage(Handle,wm_NextDlgCtl,0,0);
//                     Key:=0;
//                   End; // VK_RETURN, VK_DOWN

      VK_RETURN  : Begin
                     PostMessage(Handle,wm_NextDlgCtl,0,0);
                     Key:=0;
                   End; // VK_RETURN, VK_DOWN

      VK_DOWN    : If ReplaceUpDownsForControl(ActiveControl, False) Then
                   Begin
                     PostMessage(Handle,wm_NextDlgCtl,0,0);
                     Key:=0;
                   End; // VK_RETURN, VK_DOWN
    End; // Case Key
  End; // If (Shift = []) And ReplaceEntersForControl(ActiveControl)

// For Enterprise Global Hotkeys - not reqd in custom apps:-
//
//  If (Key In [VK_F2..VK_F12]) and (Not (ssAlt In Shift)) and (AllowHotKey) then
//  Begin
//    If (Key=VK_F9) then
//    Begin
//      If (ActiveControl is TComponent) then
//      Begin
//        TComp:=TComponent(ActiveControl);
//        LastValueObj.GetValue(TComp);
//        PostMessage(Handle,wm_NextDlgCtl,0,0);
//      end;
//    end
//    else
//      if Assigned(Application.MainForm) then PostMessage(Application.MainForm.Handle,wm_KeyDown,Key,Ord((ssShift In Shift)));
//  end;

// For old style btrieve lists - not reqd in custom apps:-
//
//  If (ActiveControl is TScrollButton) then {Don't go any further}
//    Exit;

  If (Key In [VK_Prior,VK_Next]) And (ssCtrl In Shift) Then
    // Select Next/Prev page of tabbed notebook
    PostMessage(Handle, WM_CustGetRec, 175, Ord(Key=VK_Prior));

  If (Key In [VK_Home,VK_End]) and (ssAlt In Shift)  then
    // Jump straight to list body
    PostMessage(Handle, WM_CustGetRec, 176, Ord(Key=VK_Home));

  If (Key=VK_Return) and (ssCtrl In Shift) then
    // Ctrl + Enter - Click OK button automatically
    ClickOK(Sender, Key);
End; // GlobFormKeyDown

//-------------------------------------------------------------------------

end.
