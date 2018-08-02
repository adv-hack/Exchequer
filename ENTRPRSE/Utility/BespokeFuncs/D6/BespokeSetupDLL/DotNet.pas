unit DotNet;

interface

Type
  // Generic interface for objects which implement a specific import type
  IDotNetInfo = Interface
    ['{E8035277-0293-49DA-AE03-BABF5DCA80C4}']
    // --- Internal Methods to implement Public Properties ---
    Function GetNet11Installed : Boolean;
    Function GetNet20Installed : Boolean;
    Function GetNet35Installed : Boolean;

    // ------------------ Public Properties ------------------
    Property Net11Installed : Boolean Read GetNet11Installed;
    Property Net20Installed : Boolean Read GetNet20Installed;
    Property Net35Installed : Boolean Read GetNet35Installed;

    // ------------------- Public Methods --------------------
  End; // IDotNetInfo

Function DotNetInfo : IDotNetInfo;

implementation

Uses Registry, Windows;

Const
  BaseDotNetKey = '\SOFTWARE\Microsoft\NET Framework Setup\NDP\';
  DotNet11Key = 'v1.1.4322';
  //DotNet20Key = 'v2.0.50215';  // Beta version of Framework
  DotNet20Key = 'v2.0.50727';  // Beta version of Framework
  DotNet35Key = 'v3.5';  
  InstallValue = 'Install';

Type
  TDotNetInfo = Class(TInterfacedObject, IDotNetInfo)
  Private
    FGot11 : Boolean;
    FGot20 : Boolean;
    FGot35 : Boolean;
  Protected
    // IDotNetInfo
    Function GetNet11Installed : Boolean;
    Function GetNet20Installed : Boolean;
    Function GetNet35Installed : Boolean;

  Public
    Constructor Create;

  End; // TDotNetInfo

//=========================================================================

Function DotNetInfo : IDotNetInfo;
Begin // DotNetInfo
  Result := TDotNetInfo.Create;
End; // DotNetInfo

//=========================================================================

Constructor TDotNetInfo.Create;
Begin // Create
  Inherited Create;

  FGot11 := False;
  FGot20 := False;
  FGot35 := FALSE;

  With TRegistry.Create Do
  Begin
    Try
      Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
      RootKey := HKEY_LOCAL_MACHINE;

      // Check for presence of .NET Framework 1.1
      If KeyExists(BaseDotNetKey + DotNet11Key) Then
      Begin
        OpenKey (BaseDotNetKey + DotNet11Key, False);
        If ValueExists(InstallValue) Then
        Begin
          FGot11 := (ReadInteger(InstallValue) = 1);
        End; // If ValueExists(InstallValue)
      End; // If KeyExists(BaseDotNetKey + DotNet11Key)

      // Check for presence of .NET Framework 2.0
      If KeyExists(BaseDotNetKey + DotNet20Key) Then
      Begin
        OpenKey (BaseDotNetKey + DotNet20Key, False);
        If ValueExists(InstallValue) Then
        Begin
          FGot20 := (ReadInteger(InstallValue) = 1);
        End; // If ValueExists(InstallValue)
      End; // If KeyExists(BaseDotNetKey + DotNet20Key)

      // Check for presence of .NET Framework 2.0
      If KeyExists(BaseDotNetKey + DotNet35Key) Then
      Begin
        OpenKey (BaseDotNetKey + DotNet35Key, False);
        If ValueExists(InstallValue) Then
        Begin
          FGot35 := (ReadInteger(InstallValue) = 1);
        End; // If ValueExists(InstallValue)
      End;{if}
    Finally
      Free;
    End; // Try..Finally
  End; // With TRegistry.Create
End; // Create

//-------------------------------------------------------------------------

Function TDotNetInfo.GetNet11Installed : Boolean;
Begin // GetNet11Installed
  Result := FGot11;
End; // GetNet11Installed

//------------------------------

Function TDotNetInfo.GetNet20Installed : Boolean;
Begin // GetNet20Installed
  Result := FGot20;
End; // GetNet20Installed

//-------------------------------------------------------------------------

Function TDotNetInfo.GetNet35Installed : Boolean;
Begin // GetNet20Installed
  Result := FGot35;
End; // GetNet20Installed

//-------------------------------------------------------------------------

end.
