unit formutil;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, GlobType;

Type
  ListReferenceObject = Class (TObject)
    IsField      : Boolean;        { Is this a field that can be added to the formula? }
    RememberOp   : Boolean;        { remember this operation and add after any other fields added }
    DisableRemem : Boolean;        { Disable the automatic remember for this field }
    AddToFormula : String;         { String to add into formula }
    CursorOffset : Byte;           { Place to position the text cursor within AddToFormula }
    AddDialog    : TNotifyEvent;   { event to run when adding field }
  End; { TFormDefListObjType }

  ListRefFlagsType = (NoRemember, Field, Popup, Remember, NoTrim);
  ListRefFlagsSet = Set Of ListRefFlagsType;

Procedure CursorToPointer;
Procedure CursorToHourglass (Var PrevCur : TCursor);
Procedure RestoreCursor     (Const PrevCur : TCursor);
Procedure CursorForDialog;
Procedure CursorFromDialog;

Procedure FontToRec (      TheFont : TFont;
                     Var   TheRec  : fdFontDefType);
Procedure FontRecToFont (      TheFont : TFont;
                         Const TheRec  : fdFontDefType);
{$IFNDEF RW}
  Procedure FontToVisFont(NormFont, VisFont : TFont);
  Procedure SetVisFontHeight (VisFont : TFont; PointSize : Integer);
{$ENDIF}

Procedure AddObjectToList (Var   TheList    : TListBox;
                           Const ThePointer : Pointer;
                           Const Level      : Byte;
                                 ListStr1   : String;
                                 ListStr2   : String;
                           {Const IsValid    : Boolean;}
                                 FormStr    : String;
                           Const CursOffs   : Byte;
                           Const Flags      : ListRefFlagsSet;
                           Const AddEvent   : TNotifyEvent);

Procedure FilenameKeyFilter (Var Key : Char);

Function PathToShort (Const FPath : ShortString) : ShortString;
Function SplitFileName (FName : ShortString) : SplitFnameType;

Function ExVerIsStandard : Boolean; Export;
Function ExVerIsProf : Boolean; Export;
Function ExVerIsMultiCcy : Boolean; Export;
Function ExVerIsStock : Boolean; Export;
Function ExVerIsSPOP : Boolean; Export;

procedure GlobFormKeyPress(Sender        : TObject;
                       var Key           : Char;
                           ActiveControl :  TWinControl;
                           Handle        :  THandle);

procedure GlobFormKeyDown(Sender        : TObject;
                      var Key           : Word;
                          Shift         : TShiftState;
                          ActiveControl :  TWinControl;
                          Handle        :  THandle);

Function GetColorName (Const TheColor  : TColor;
                       Var   ColorName : ShortString) : Boolean;

Function GetBitmapPath (Const BitmapPath, DefPath : String;
                        Var   ActualPath          : String) : Boolean;

Function AlignToFlag (Const Align : TAlignment) : Word;

Procedure CanvasDrawText (Const TheCanvas : TCanvas;
                          Const DrawStr   : ShortString;
                          Var   DrawRect  : TRect;
                          Const DrawFlags : Word);

{========================================================================}

implementation

Uses BorBtns,
     TEditVal,
     Grids,
     ComCtrls,
     Outline,
     {$IFNDEF RW}
       PageComp,
     {$ENDIF}
     {$IFNDEF FDES}
       //GlobVar,
       //VarConst,
       //SBSComp2,
       //BTSupU1,
     {$ENDIF}
     SBSOutL;

Procedure CursorToHourglass (Var PrevCur : TCursor);
begin
  PrevCur := Screen.Cursor;
  Screen.Cursor := crHourglass;
end;

Procedure RestoreCursor (Const PrevCur : TCursor);
begin
  Screen.Cursor := PrevCur;
end;

Procedure CursorForDialog;
begin
  Screen.Cursor := crDefault;
end;

Procedure CursorFromDialog;
begin
  Screen.Cursor := crHourglass;
end;

Procedure CursorToPointer;
begin
  Screen.Cursor := crDefault;
end;

Procedure FontRecToFont (      TheFont    : TFont;
                         Const TheRec     : fdFontDefType);
Begin
  TheFont.Name   := TheRec.ffName;
  TheFont.Color  := TheRec.ffColor;
  TheFont.Style  := TheRec.ffStyle;
  TheFont.Pitch  := TheRec.ffPitch;
  TheFont.Height := TheRec.ffHeight;
  TheFont.Size   := TheRec.ffSize;
end;

Procedure FontToRec (      TheFont    : TFont;
                     Var   TheRec     : fdFontDefType);
Begin
  TheRec.ffName   := TheFont.Name;
  TheRec.ffSize   := TheFont.Size;
  TheRec.ffColor  := TheFont.Color;
  TheRec.ffStyle  := TheFont.Style;
  TheRec.ffPitch  := TheFont.Pitch;
  TheRec.ffHeight := TheFont.Height;
end;

{$IFNDEF RW}
  { Copies the normal font intoo the visual font and adjusts the size }
  Procedure FontToVisFont(NormFont, VisFont : TFont);
  begin
    { Copy font across }
    VisFont.Assign (NormFont);

    { reset height }
    SetVisFontHeight (VisFont, NormFont.Size);
  end;

  { Copies the normal font into the visual font and adjusts the size }
  Procedure SetVisFontHeight (VisFont : TFont; PointSize : Integer);
  Const
    PointsPerMM = 0.352778;   { 25.4 / 72 }
  Var
    Controller : TSBSController;
  begin
    If Assigned (SystemInfo.ControllerHandle) Then Begin
      Controller := TSBSController(SystemInfo.ControllerHandle);

      If Controller.PaperHandleSet Then
        { Calculate pixel height }
        VisFont.Height := -Round (PointsPerMM * PointSize * Controller.Paper.psScaling);
    End { If }
    Else
      { Don't have access to correct scaling so we'll wing it and hope }
      VisFont.Height := -Round (PointsPerMM * PointSize * DefaultPixPerMM);
  end;
{$ENDIF}

Procedure AddObjectToList (Var   TheList    : TListBox;
                           Const ThePointer : Pointer;
                           Const Level      : Byte;
                                 ListStr1   : String;
                                 ListStr2   : String;
                           {Const IsValid    : Boolean;}
                                 FormStr    : String;
                           Const CursOffs   : Byte;
                           Const Flags      : ListRefFlagsSet;
                           Const AddEvent   : TNotifyEvent);
Var
  ListRefObj : ListReferenceObject;
  TheObj     : TObject;
  {ThePopup   : TPopupMenu;}
  {MenuObj    : TMenuItem;}

  Function LevelStr : String;
  Var
    I : Integer;
  Begin { LevelStr }
    Result := '';

    If (Level > 0) Then
      For I := 1 To ((Level - 1) * 4) Do
        Result := Result + ' ';
  End;  { LevelStr }

begin
  ListRefObj := ListReferenceObject.Create;
  If (Not (NoTrim In Flags)) Then FormStr := Trim (FormStr);
  ListStr1 := Trim (ListStr1);
  ListStr2 := Trim (ListStr2);
  With ListRefObj Do Begin
    IsField       := Field In Flags;
    RememberOp    := Remember In Flags;
    DisableRemem  := NoRemember In Flags;
    If (FormStr <> '') Then
      AddToFormula := FormStr     { String to add into formula }
    Else
      AddToFormula := ListStr1;   { String to add into formula }
    AddDialog    := AddEvent;     { Event handle for add event }
    CursorOffset := CursOffs      { Place to position the text cursor within AddToFormula }
  End; { With }

  TheList.Items.AddObject (LevelStr + ListStr1 + #9 + ListStr2, ListRefObj);

  If Assigned (ThePointer) And (Popup In Flags) Then Begin
    { We have a pointer - check its a popup menu }
    TheObj := ThePointer;
    If TheObj Is TPopupMenu Then Begin
      { Get the menu }
      {ThePopup := TPopupMenu(TheObj);}

      { Add to popup menu }
      { HOW??? }
      (*MenuObj := TMenuItem.Create (ThePopup);
      With MenuObj Do Begin
        Caption := ListStr1;
        Enabled := True;
        Visible := True;
      End; { With }
      ThePopup.Items[0] := MenuObj; *)
    End; { If }
  End; { If }
end;

{ Filter routine for keypresses in the form open/save/select dialog }
{ and the system setup - form definitions dialog }
Procedure FilenameKeyFilter (Var Key : Char);
begin
  { Should be kept in syc with the open/save dialog }
  If Not (Key In [#8, 'a'..'z', 'A'..'Z', '0'..'9', '!', '$', '^', '_', '&', '£']) Then Begin
    Key := #0
  End; { If }
end;


(*******8
Function SplitFileName (Const FName : String) : SplitFnameType;
Var
  Path1, Path2  : String;
  DotPos, PLen  : Integer;

  Function ConstStr (Const TheChar : Char; It : Byte) : String;
  Var
    I : LongInt;
  Begin
    Result := '';
    If (I > 0) Then
      For I := 1 To It Do
        Result := Result + TheChar;
  End;

begin
  With Result Do Begin
    Path      := '';
    Name      := '';
    Extension := '';
    Filename  := '';

    DotPos := Pos ('.', FName);
    If (DotPos > 0) Then Begin
      Name := Copy (FName, 1, Pos ('.', FName) - 1);

      If (DotPos < Length (FName)) Then
        Extension := Copy (FName, Pos ('.', FName) + 1, 3);
    End { If }
    Else
      Name := FName;

    Path := Name;
    While (Pos ('\', Name) > 0) Do
      Delete (Name, 1, Pos ('\', Name));
    Delete (Path, (Length(Path) - Length(Name) + 1), Length(Name));

    Path := UpperCase(Path);
    If (Trim(Path) <> '') Then Begin
      { Convert path to shortname format }
      Path1 := Path;
      Path2 := ConstStr (#0, 70);
      PLen := GetShortPathName (PCHAR(Path1), PCHAR(Path2), Length (Path2));
      If (PLen > 0) Then
        Path := Trim(Path2);
    End; { If }

    Name      := UpperCase(Name);
    Extension := UpperCase(Extension);
    FileName  := Name + '.' + Extension;
    PathName  := Path + FileName;
  End; { With }
end;     *************)
Function PathToShort (Const FPath : ShortString) : ShortString;
Var
  Temp1, Temp2 : PChar;
  PLen         : SmallInt;
Begin
  Result := FPath;

  If (Trim(FPath) <> '') Then Begin
    Temp1 := StrAlloc (250);
    Temp2 := StrAlloc (250);

    StrPCopy (Temp1, Trim(FPath));
    PLen := GetShortPathName (Temp1, Temp2, StrBufSize (Temp2));
    If (PLen > 0) Then
      Result := Trim(StrPas(Temp2));

    StrDispose (Temp1);
    StrDispose (Temp2);
  End; { If }
End;

Function SplitFileName (FName : ShortString) : SplitFnameType;
begin
  With Result Do Begin
    { Convert to uppercase format }
    FName := UpperCase(FName);

    { extract various elements of filename }
    Path      := UpperCase(PathToShort(ExtractFilePath(FName)));
    Name      := UpperCase(ExtractFileName(FName));
    Extension := UpperCase(ExtractFileExt(FName));
    Filename  := UpperCase(ExtractFileName(FName));

    { remove extension from name }
    If (Pos (Extension, Name) = (Length(Name) - Length (Extension) + 1)) Then
      Delete (Name, Pos (Extension, Name), Length (Extension));

    { remove leading '.' from extension }
    If (Length(Extension) > 0) And (Extension[1] = '.') Then
      Delete (Extension, 1, 1);

    PathName  := Path + FileName;
  End; { With }
end;


{ Exchequer Version Number:    1      Standard                           }
{                              2      Standard with Stock                }
{                              3      Professional                       }
{                              4      Professional with Stock            }
{                              5      Professional with Stock and SPOP   }
{                              6      Professional with Stock/SPOP/JC    }
{                              7      Multi-Currency                     }
{                              8      Multi-Currency with Stock          }
{                              9      Multi-Currency with Stock and SPOP }
{                              11     Multi-Currency with Stock/SPOP/JC  }
{                              21     Form Designer Single-Currency      }
{                              22     Form Designer Multi-Currency       }
Function ExVerIsStandard : Boolean;
begin
  Result := (SystemInfo.ExVersionNo In [1, 2]);
end;

Function ExVerIsProf : Boolean;
begin
  Result := (SystemInfo.ExVersionNo In [3..5]);
end;

Function ExVerIsMultiCcy : Boolean;
begin
  Result := (SystemInfo.ExVersionNo In [7..11]);
end;

Function ExVerIsStock : Boolean;
begin
  Result := (SystemInfo.ExVersionNo In [2, 4, 8]);
end;

Function ExVerIsSPOP : Boolean;
begin
  Result := (SystemInfo.ExVersionNo In [5, 9]);
end;


procedure GlobFormKeyPress(Sender        : TObject;
                       var Key           : Char;
                           ActiveControl :  TWinControl;
                           Handle        :  THandle);
Var
  IrqKey  :  Boolean;
begin
  IrqKey := TxlateCR;

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do Begin
      IrqKey:=(IrqKey and (Not InDropDown));
    end
    else
      If Not (ActiveControl is TCurrencyEdit) Then
        If (ActiveControl is TStringGrid) or
           (ActiveControl is TUpDown) or
           (ActiveControl is TBorCheck) or
           (ActiveControl is TListBox) or
           (ActiveControl is TListView) or
           (ActiveControl is TOutline) or
           (ActiveControl is TMemo) or
           (ActiveControl is TSBSOutLineB) then {* switched off so it does not interfere with a list *}
          IrqKey:=False;

  If ((Key=#13) Or (Key=#10)) and (IrqKey) then Begin
    Key:=#0;
  end;
end;


procedure GlobFormKeyDown(Sender        : TObject;
                      var Key           : Word;
                          Shift         : TShiftState;
                          ActiveControl :  TWinControl;
                          Handle        :  THandle);
Var
  IrqKey  :  Boolean;
  TComp   :  TComponent;

  procedure ClickOk(Sender  :  TObject;
              Var VKey    :  Word);
  Var
    FForm  :  TForm;
    n      :  Integer;
  Begin { ClickOk }
    If (Sender is TForm) then
      With TForm(Sender) do Begin
        For n:=0 to Pred(ComponentCount) do
          If (Components[n] is TButton) then
            With TButton(Components[n]) do
              If ((Caption='&OK') or (ModalResult=mrOk)) and (Enabled) and (Visible) and (CanFocus) then Begin
                VKey:=0;
                Click;
                Exit
              End; { If }
      End; { With TForm(Sender) }
  End; { ClickOk }

begin
  // HM 13/04/99: Updated on EL's request
  //IrqKey:=((Shift<>[ssCtrl]) and (Shift<>[ssAlt]) and (Shift<>[ssShift]));
  IrqKey:=((Not (ssCtrl In Shift)) and (Not (ssAlt In Shift)) and (Not (ssShift In Shift)));

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do Begin
      IrqKey:=(IrqKey and (Not InDropDown));
    end
  else
    If Not (ActiveControl is TCurrencyEdit) Then
      If (ActiveControl is TStringGrid) or
         (ActiveControl is TUpDown) or
         (ActiveControl is TBorCheck) or
         (ActiveControl is TListBox) or
         (ActiveControl is TListView) or
         (ActiveControl is TOutline) or
         (ActiveControl is TMemo) or
         (ActiveControl is TSBSOutLineB) then {* Could combine with a switch, as there maybe cases where a
                                                                                   a string grid is used without the list... *}
        IrqKey:=False;

  If (IrqKey) then
    Case Key of
      VK_Up  :  Begin
                  PostMessage(Handle,wm_NextDlgCtl,1,0);
                  Key:=0;
                end;
      VK_Return,
      VK_Down
             :  Begin
                  If (Key=VK_Return) and (Not TxLateCr) then
                    Exit;


                  //If (Not (ActiveControl is TBorCheck)) or (Key=VK_Return) then Begin
                  If ((Not (ActiveControl is TBorCheck)) and (Not(ActiveControl is TBorRadio))) or (Key=VK_Return) then begin
                    PostMessage(Handle,wm_NextDlgCtl,0,0);
                    Key:=0;
                  end
                  else
                    Key:=Vk_Tab;
                end;
    end;

  If (Key In [VK_F2..VK_F10]) then {* Pass on hot key *}
    PostMessage(Application.MainForm.Handle,wm_KeyDown,Key,0);

{$IFNDEF FDES}
(*
  If (Key In [VK_F2..VK_F12]) and (Not (ssAlt In Shift)) and (AllowHotKey) then
  Begin
    If (Key=VK_F9) then
    Begin
      If (ActiveControl is TComponent) then
      Begin
        TComp:=TComponent(ActiveControl);
        LastValueObj.GetValue(TComp);
        PostMessage(Handle,wm_NextDlgCtl,0,0);
      end;
    end
    else
      PostMessage(Application.MainForm.Handle,wm_KeyDown,Key,Ord((ssShift In Shift)));
  end;

  If (Key In [VK_Prior,VK_Next]) and (ssCtrl In Shift) and (AllowHotKey) then {* Select Next/Prev page of tabbed notebook *}
    PostMessage(Handle,wm_CustGetRec,175,Ord(Key=VK_Prior));

  If (Key In [VK_Home,VK_End]) and (ssAlt In Shift) and (AllowHotKey) then {* Jump straight to list body *}
    PostMessage(Handle,wm_CustGetRec,176,Ord(Key=VK_Home));
*)
{$ENDIF}

  If ((Key=VK_Return) and (ssCtrl In Shift)) then
    ClickOK(Sender,Key);
end;

{ Returns the name of the color if known }
Function GetColorName (Const TheColor  : TColor;
                       Var   ColorName : ShortString) : Boolean;
begin
  ColorName := '';
  Case TheColor Of
    clAqua    : ColorName := 'Aqua';
    clBlack   : ColorName := 'Black';
    clBlue    : ColorName := 'Blue';
    clDkGray  : ColorName := 'DkGray';
    clFuchsia : ColorName := 'Fuchsia';
    {clGray    = clLtGray}
    clGreen   : ColorName := 'Green';
    clLime    : ColorName := 'Lime';
    clLtGray  : ColorName := 'LtGray';
    clMaroon  : ColorName := 'Maroon';
    clNavy    : ColorName := 'Navy';
    clOlive   : ColorName := 'Olive';
    clPurple  : ColorName := 'Purple';
    clRed     : ColorName := 'Red';
    {clSilver  = clLtGray}
    clTeal    : ColorName := 'Teal';
    clWhite   : ColorName := 'White';
    clYellow  : ColorName := 'Yellow';
  End; { Case }

  Result := (ColorName <> '');
end;

Function GetBitmapPath (Const BitmapPath, DefPath : String;
                        Var   ActualPath          : String) : Boolean;
Var
  FileInfo : SplitFNameType;
begin
  Result := False;

  If FileExists (BitmapPath) Then Begin
    Result := True;
    ActualPath := BitmapPath;
  End; { If }

  If (Not Result) Then Begin
    FileInfo := SplitFileName(BitmapPath);

    { Find bitmap - look in directory containing the form definition }
    If (Trim(DefPath) <> '') Then Begin
      { Get path of form def }
      ActualPath := SplitFileName(DefPath).Path + FileInfo.FileName;
      Result := FileExists (ActualPath);
    End; { If }

    If (Not Result) Then Begin
      { Check in Forms\ Directory }
      ActualPath := SystemInfo.ExDataPath + FormsPath + FileInfo.FileName;
      Result := FileExists (ActualPath);
    End; { If }

    If (Not Result) Then Begin
      { Check in Exchequer Directory }
      ActualPath := SystemInfo.ExDataPath + FileInfo.FileName;
      Result := FileExists (ActualPath);
    End; { If }
  End; { If }
end;

Function AlignToFlag (Const Align : TAlignment) : Word;
Begin
  Case Align Of
    taLeftJustify  : Result := DT_LEFT;
    taRightJustify : Result := DT_RIGHT;
    taCenter       : Result := DT_CENTER;
  Else
    Result := DT_LEFT;
  End; { Case }
End;

{ Draws Transparent Text onto a canvas }
Procedure CanvasDrawText (Const TheCanvas : TCanvas;
                          Const DrawStr   : ShortString;
                          Var   DrawRect  : TRect;
                          Const DrawFlags : Word);
Var
  TheStr   : PChar;
  TmpStyle : TBrushStyle;
Begin
  TheStr := StrAlloc (Length (DrawStr) + 1);
  StrPCopy (TheStr, DrawStr);

  TmpStyle := TheCanvas.Brush.Style;
  TheCanvas.Brush.Style := bsClear;

  DrawText (TheCanvas.Handle, TheStr, Length (TheStr), DrawRect, DrawFlags);

  TheCanvas.Brush.Style := TmpStyle;

  StrDispose(TheStr);
End;


end.
