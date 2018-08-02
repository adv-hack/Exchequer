unit ProgramGroups;

interface

Uses Classes, Windows;

Type
  // Loads the list of existing Program Groups into the ProgramGroups property
  // for use in setup dialogs when requesting where to put the icons.
  TProgramGroups = Class(TObject)
  Private
    FGroups : TStringList;
    Procedure LoadGroups (RootKey : HKey; PropName : ShortString);
  Public
    Property ProgramGroups : TStringList Read FGroups;
    Constructor Create;
    Destructor Destroy; Override;
  End; // TProgramGroups

implementation

Uses Registry, SysUtils;

//=========================================================================

Constructor TProgramGroups.Create;
Begin // Create
  FGroups := TStringList.Create;

  LoadGroups (HKEY_CURRENT_USER, 'Programs');
  LoadGroups (HKEY_LOCAL_MACHINE, 'Common Programs');

  FGroups.Sort;
End; // Create

//------------------------------

Destructor TProgramGroups.Destroy;
Begin // Destroy
  FreeAndNIL(FGroups);
End; // Destroy

//-------------------------------------------------------------------------

Procedure TProgramGroups.LoadGroups (RootKey : HKey; PropName : ShortString);
Var
  oRegistry : TRegistry;
  GroupDir  : ShortString;
  NetFInfo  : TSearchRec;
  SrchRes   : Integer;
Begin // LoadGroups
  oRegistry := TRegistry.Create;
  Try
    oRegistry.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
    oRegistry.RootKey := RootKey;

    If oRegistry.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False) Then
    Begin
      GroupDir := IncludeTrailingPathDelimiter(oRegistry.ReadString(PropName));
      If DirectoryExists(GroupDir) Then
      Begin
        // Do a search for subdirectories and add them into the groups list
        SrchRes := FindFirst(GroupDir + '*.*', faDirectory, NetFInfo);
        Try
          While (SrchRes = 0) Do
          Begin
            If ((NetFInfo.Attr AND faDirectory) = faDirectory) And (NetFInfo.Name[1] <> '.') Then
            Begin
              If (FGroups.IndexOf (NetFInfo.Name) = -1) Then
              Begin
                FGroups.Add (NetFInfo.Name);
              End; // If (FGroups.IndexOf (NetFInfo.Name) = -1)
            End; // If ((NetFInfo.Attr AND faDirectory) = faDirectory)

            SrchRes := FindNext(NetFInfo);
          End; // While (SrchRes = 0)
        Finally
          FindClose (NetFInfo);
        End; // Try..Finally
      End; // If DirectoryExists(GroupDir)
    End; // If oRegistry.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False)
  Finally
    FreeAndNIL(oRegistry);
  End; // Try..Finally
End; // LoadGroups

//=========================================================================

end.
