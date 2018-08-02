unit DotNet;

interface

Type
  // Generic interface for objects which implement a specific import type
  // PKR. 21/03/2016. ABSEXCH-17351. Credit Card add-in will be disabled if .NET 4.6 or higher is installed.
  // Extended interface to include higher versions of .NET.
  // Changed comparisons to look for version code or higher.
  IDotNetInfo = Interface
    ['{E8035277-0293-49DA-AE03-BABF5DCA80C4}']
    // --- Internal Methods to implement Public Properties ---
    Function GetNet11Installed : Boolean;
    Function GetNet20Installed : Boolean;
    Function GetNet450Installed : Boolean;
    // PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in/Payments Portal.
    Function GetNet451Installed : Boolean;
    Function GetNet452Installed : Boolean;
    Function GetNet460Installed : Boolean;
    Function GetNet461Installed : Boolean;

    // ------------------ Public Properties ------------------
    Property Net11Installed : Boolean Read GetNet11Installed;
    Property Net20Installed : Boolean Read GetNet20Installed;
    Property Net450Installed : Boolean read GetNet450Installed;
    // PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in/Payments Portal.
    Property Net451Installed : Boolean Read GetNet451Installed;
    Property Net452Installed : Boolean read GetNet452Installed;
    Property Net460Installed : Boolean read GetNet460Installed;
    Property Net461Installed : Boolean read GetNet461Installed;

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
  InstallValue = 'Install';

  // PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in/Payments Portal.
  // From .NET 4.0, Microsoft changed the way they store .NET version info in the Registry.
  // All versions of .NET 4 (eg 4.5, 4.6) fall under the v4 Key.
  // The actual version number is determined by the 'Release' value under the \Full key.
  // Eg. \SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full   : REG_DWORD Release = 378675
  DotNet4Key = 'v4\Full';
  ReleaseValue    = 'Release';
  DotNet450       = 378389; // .NET 4.5
  DotNet451RelW81 = 378675; // .NET 4.5.1 under Windows 8.1
  DotNet451Rel    = 378758; // .NET 4.5.1 under Windows 8, 7 and Vista
  DotNet452Rel    = 379893; // .NET 4.5.2
  DotNet46Prev    = 381029; // .NET 4.6 preview
  DotNet46W10     = 393295; // 4.6 on Windows 10
  DotNet46Rel     = 393297; // 4.6 on other Windows versions
  DotNet461W10    = 394254; // 4.6.1 on Windows 10
  DotNet461Rel    = 394271; // 4.6.1 on other Windows versions
  DotNet462Prev   = 394747; // 4.6.2 Preview on W10 (394748 on other versions)
Type
  TDotNetInfo = Class(TInterfacedObject, IDotNetInfo)
  Private
    FGot11 : Boolean;
    FGot20 : Boolean;
    // PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in/Payments Portal.
    FGot450 : Boolean;
    FGot451 : Boolean;
    FGot452 : Boolean;
    FGot460 : Boolean;
    FGot461 : Boolean;
  Protected
    // IDotNetInfo
    Function GetNet11Installed : Boolean;
    Function GetNet20Installed : Boolean;
    // PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in/Payments Portal.
    Function GetNet450Installed : Boolean;
    Function GetNet451Installed : Boolean;
    Function GetNet452Installed : Boolean;
    Function GetNet460Installed : Boolean;
    Function GetNet461Installed : Boolean;
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
var
  dotNet4Release : integer;
Begin // Create
  Inherited Create;

  // PKR. 21/03/2016. ABSEXCH-17351. Credit Cards will be disabled if .NET 4.6 or higher is installed.
  FGot11 := False;
  FGot20 := False;
  FGot450 := False;
  FGot451 := False;
  FGot452 := False;
  FGot460 := False;
  FGot461 := False;

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
        CloseKey;
      End; // If KeyExists(BaseDotNetKey + DotNet11Key)

      // Check for presence of .NET Framework 2.0
      If KeyExists(BaseDotNetKey + DotNet20Key) Then
      Begin
        OpenKey (BaseDotNetKey + DotNet20Key, False);
        If ValueExists(InstallValue) Then
        Begin
          FGot20 := (ReadInteger(InstallValue) = 1);
        End; // If ValueExists(InstallValue)
        CloseKey;
      End; // If KeyExists(BaseDotNetKey + DotNet20Key)

      // PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in/Payments Portal.
      // Check for presence of .NET Framework 4.5.1 (or 4.5.2 or 4.6 preview)
      if KeyExists(BaseDotNetKey + DotNet4Key) then
      begin
        OpenKey (BaseDotNetKey + DotNet4Key, False);
        if ValueExists(ReleaseValue) then
        begin
          dotNet4Release := ReadInteger(ReleaseValue);

          // PKR. 21/03/2016. ABSEXCH-17351. Credit Cards will be disabled if .NET 4.6 or higher is installed.
          // Compare Release value is greater than or equal to the specified version.
          // NOTE: This will fail again if/when .NET v5 is released because we can't predict what Microsoft will
          // store in the Registry, and where.
          if (dotNet4Release >= DotNet450) then FGot450 := true;
          // Note. DotNet451RelW81 is the lowest number for .NET 4.5.1, so safest value to compare against.
          if (dotNet4Release >= DotNet451RelW81) then FGot451 := true;
          if (dotNet4Release >= DotNet452Rel) then FGot452 := true;
          if (dotNet4Release >= DotNet46Prev) then FGot460 := true;
          if (dotNet4Release >= DotNet461W10) then FGot461 := true;
        end;
        CloseKey;
      end;
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

//------------------------------
Function TDotNetInfo.GetNet450Installed : Boolean;
begin
  Result := FGot450;
end;

// PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in/Payments Portal.
Function TDotNetInfo.GetNet451Installed : Boolean;
Begin // GetNet451Installed
  Result := FGot451;
End; // GetNet451Installed

Function TDotNetInfo.GetNet452Installed : Boolean;
begin
  Result := FGot452;
end;

Function TDotNetInfo.GetNet460Installed : Boolean;
begin
  Result := FGot460;
end;

Function TDotNetInfo.GetNet461Installed : Boolean;
begin
  Result := FGot461;
end;

//-------------------------------------------------------------------------
end.
