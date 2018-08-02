unit mru;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, Menus, SysUtils, Windows;

Const
  FaxFormMru = 10;

Type
  TMRU = Class(TObject)
  Private
    { Used to maintain the list of strings }
    MRUList        : TStringList;

    { Name of file containing the strings }
    IniName        : ShortString;

    { Menu Item containing children to be used }
    MRUMenu, MRUSepBar : TMenuItem;
  Public
    Constructor Create(Const MRUName            : ShortString;
                             ParentMenu, SepBar : TMenuItem);
    Destructor Destroy; Override;

    Procedure AddToMRU(NewStr : ShortString);
    Procedure DeleteMRUItem(DelStr : ShortString);

    Procedure HideAllMenuItems;
    Procedure UpdateList;
    Procedure UpdateMRUMenu;
  End; { TMRU }

  TFormsMRU = Class(TObject)
  Public
    Cache  : Array [1..4] Of TStringList;
    Items  : Array [1..FaxFormMru] Of TMenuItem;
    SepBar : TMenuItem;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure AddMruEntry (Const MruList : Byte; NewEntry : ShortString);
    Procedure BuildCacheList (Const MruList : Byte);
  End;

implementation

Uses GlobType;


Constructor TMRU.Create(Const MRUName            : ShortString;
                              ParentMenu, SepBar : TMenuItem);
Var
  TmpStr   : ShortString;
  I        : Byte;
Begin { Create }
  Inherited Create;

  IniName   := SystemInfo.ExDataPath+MRUName;
  MRUMenu   := ParentMenu;
  MRUSepBar := SepBar;

  MRUList := TStringList.Create;
  If FileExists(IniName) Then Begin
    MRUList.LoadFromFile(IniName);

    { Get rid of any blank entries }
    If (MRUList.Count > 0) Then Begin
      I := 0;
      While (I < MRUList.Count) Do Begin
        If (Trim(MRUList[I]) = '') Then Begin
          MRUList.Delete(I);
        End { If }
        Else
          Inc(I);
      End; { While }
    End; { If }
  End; { If }

  UpdateMRUMenu;
End; { Create }


Destructor TMRU.Destroy;
Begin { Destroy }
  MRUList.Clear;
  MRUList.Destroy;

  Inherited Destroy;
End; { Destroy }


Procedure TMRU.HideAllMenuItems;
Var
  I : Byte;
Begin { HideAllMenuItems }
  With MRUMenu Do Begin
    { Remove any existing children }
    For I := 0 To Pred(Count) Do Begin
      Items[I].Visible := False;
    End; { For }
  End; { With MRUMenu }
End; { HideAllMenuItems }


Procedure TMRU.UpdateMRUMenu;
Var
  I : Byte;
Begin { UpdateMRUMenu }
  With MRUMenu Do Begin
    { Hide all menus }
    HideAllMenuItems;

    { Re-Add Current entries in }
    If (MRUList.Count > 0) Then Begin
      For I := 0 To Pred(Count) Do Begin
        { Exit if no more items }
        If (I > Pred(MRUList.Count)) Then System.Break;

        With Items[I] Do Begin
          Caption := MRUList[I];
          Visible := True;
        End; { With }
      End; { If }
    End; { If }

    Visible := (MRUList.Count > 0);
    If Assigned(MRUSepBar) Then MRUSepBar.Visible := Visible;
  End; { With MRUMenu }
End; { UpdateMRUMenu }


Procedure TMRU.UpdateList;
Begin { UpdateList }
  MRUList.SaveToFile(IniName);
End; { UpdateList }


Procedure TMRU.AddToMRU(NewStr : ShortString);
Var
  I : Byte;
Begin { AddToMRU }
  NewStr := Trim(UpperCase(NewStr));

  If (NewStr <> '') Then Begin
    { Add new string }
    MRUList.Insert(0, NewStr);

    If (MRUList.Count > 1) Then Begin
      { Remove any other occurrances of it from lower in list }
      I := 1;
      While (I < MRUList.Count) Do Begin
        If (Trim(UpperCase(MRUList[I])) = NewStr) Then Begin
          MRUList.Delete(I);
        End { If }
        Else
          Inc(I);
      End; { While }
    End; { If }

    { Remove any unwanted additional items }
    While (MRUList.Count > MRUMenu.Count) Do Begin
      MRUList.Delete(MRUMenu.Count);
    End; { While }

    { Update Reopen menu }
    UpdateMRUMenu;
  End; { If }
End; { AddToMRU }


Procedure TMRU.DeleteMRUItem(DelStr : ShortString);
Var
  I : Byte;
Begin { DeleteMRUItem }
  DelStr := Trim(UpperCase(DelStr));

  If (DelStr <> '') And (MRUList.Count > 0) Then Begin
    { Remove any other occurrances of it from lower in list }
    I := 0;
    While (I < MRUList.Count) Do Begin
      If (Trim(UpperCase(MRUList[I])) = DelStr) Then Begin
        MRUList.Delete(I);
      End { If }
      Else
        Inc(I);
    End; { While }

    { Update Reopen menu }
    UpdateMRUMenu;
  End; { If }
End; { DeleteMRUItem }

{---------------------------------------------------------------------------}

Constructor TFormsMRU.Create;
Var
  I : Integer;
Begin { TFormsMRU.Create }
  inherited Create;

  For I := Low(Cache) To High(Cache) Do
    Cache[I] := TStringList.Create;

  For I := Low(Items) To High(Items) Do
    Items[I] := Nil;
End; { TFormsMRU.Create }

Destructor TFormsMRU.Destroy;
Var
  I : Integer;
Begin { TFormsMRU.Destroy }
  For I := Low(Cache) To High(Cache) Do
    Cache[I].Destroy;

  Inherited Destroy;
End; { TFormsMRU.Destroy }

Procedure TFormsMRU.AddMruEntry (Const MruList : Byte; NewEntry : ShortString);
Var
  Idx : Integer;
Begin { TFormsMRU.AddMruEntry }
  NewEntry := UpperCase(Trim(NewEntry));

  { Check its a valid list number }
  If (MruList >= 1) And (MruList <= High(Cache)) And (NewEntry <> '') Then Begin
    // Delete any pre-existing entries for this form
    Idx := Cache[MruList].IndexOf(NewEntry);
    While (Idx >= 0) Do
    Begin
      Cache[MruList].Delete(Idx);
      Idx := Cache[MruList].IndexOf(NewEntry);
    End; // While (Idx >= 0)

    { Insert at first position }
    Cache[MruList].Insert (0, NewEntry);

//    { Check it doesn't already exist }
//    I := 1;
//    While (I < Pred(Cache[MruList].Count)) Do Begin
//      If (Cache[MruList][I] = NewEntry) Then Begin
//        { Delete entry as now at top of list }
//        Cache[MruList].Delete(I);
//      End { If }
//      Else
//        Inc(I);
//    End; { While }

    { If > FaxFormMru entries then delete }
    While (Cache[MruList].Count > FaxFormMru) Do
      Cache[MruList].Delete(Pred(Cache[MruList].Count));
  End; { If }
End; { TFormsMRU.AddMruEntry }

Procedure TFormsMRU.BuildCacheList (Const MruList : Byte);
Var
  I : Integer;
Begin { TFormsMRU.BuildCacheList }
  { Check its a valid list number }
  If (MruList >= 1) And (MruList <= High(Cache)) Then Begin
    For I := Low(Items) To High(Items) Do Begin
      { Check menu option is setup }
      If Assigned(Items[I]) Then Begin
        { Check we have a cached item }
        If (Cache[MruList].Count >= I) Then Begin
          Items[I].Caption := Cache[MruList][Pred(I)];
          Items[I].Visible := True;
        End { If }
        Else Begin
          { Disable menu option }
          Items[I].Caption := '';
          Items[I].Visible := False;
        End; { Else }
      End; { If }
    End; { For }

    If Assigned(SepBar) And Assigned(Items[1]) Then
      SepBar.visible := Items[1].Visible;
  End; { If }
End; { TFormsMRU.AddMruEntry }

end.
