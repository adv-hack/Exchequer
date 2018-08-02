unit SetFuncs;

interface

// NOTE: Dialogs removed as it reduces .DLL size by 220k!
Uses Classes, {Dialogs,} IniFiles, Registry, SysUtils, Windows;

// Returns the current Enterprise directory as configured on
// the workstation.
Function GetEnterpriseDir (Const EnterpriseDir : PChar) : SmallInt; StdCall; Export;

// Adds a COM Plug-In into EntCustm.Ini
Function AddCOMPlugIn (EnterpriseDir, PlugInPath, PlugInDesc : PChar) : SmallInt; StdCall; Export;

// Removes a COM Plug-In from EntCustm.Ini
Function RemoveCOMPlugIn (pEnterpriseDir, pPlugInPath : PChar) : SmallInt; StdCall; Export;

// Adds a Delphi DLL Plug-In into EntCustm.Ini, Note DLLName should be the
// name of the DLL excluding any path and extension information.
Function AddDLLPlugIn (EnterpriseDir, DLLName, PlugInDesc : PChar) : SmallInt; StdCall; Export;

// Removes a DLL Plug-In from EntCustm.Ini
Function RemoveDLLPlugIn (pEnterpriseDir, pPlugInPath : PChar) : SmallInt; StdCall; Export;

// Adds a new entry in the EntTools.Dat ini file to add a new option into the tools menu in enterprise
Function AddToToolsMenu (pName, pCommand, pParams, pStartDir : PChar) : SmallInt; StdCall; Export;

// Is the copy of Exchequer Using MS-SQL
// NF: Added 03/03/2008
Function IsSQLVersion : SmallInt; StdCall; Export;

// Adds a new LST file to REPLFILE.LST for replication purposes
Function AddLSTFileToReplFile(EnterpriseDir, LstFile : PChar) : SmallInt;

// Adds a TCM Plug-In into TCCustom.ini
Function AddTCMPlugIn (EnterpriseDir, PlugInPath : PChar) : SmallInt;

// Adds a new entry in the entsetup.dat ini file to add a new option into the system setup menu in enterprise
Function AddToSysSetupMenu (pName, pCommand, pParams, pStartDir, pPlugInFile : PChar) : SmallInt;

// Removes an entry in the entsetup.dat ini file to remove an option from the system setup menu in enterprise
Function RemoveFromSysSetupMenu(pPlugInFile : PChar) : SmallInt;

implementation
uses
  Dialogs, StrUtil, FileUtil, VAOUtil, SQLUtils;

//---------------------------------------------------------------------------

Function ValidEntSystemDir (EntDir : ShortString) : Boolean;
Begin { ValidEntSystemDir }
  EntDir := IncludeTrailingPathDelimiter (EntDir);

  // Check for system files in specified directory
{$IFDEF EXSQL}
  Result := FileExists (EntDir + 'Entrprse.Dat') And         // Licence file
            FileExists (EntDir + 'Entrprse.Exe') And         // Splash Screen
            FileExists (EntDir + 'EntComp.Dll') And          // MCM Library
            FileExists (EntDir + 'Enter1.Exe') And           // Enterprise
            FileExists (EntDir + 'Excheqr.Sys');             // MH 20/09/07: Modified to check for v6.00 Exchequer System flag file
{$ELSE}
  // Check for system files in specified directory
  Result := FileExists (EntDir + 'Company.Dat') And          // MCM Database
            FileExists (EntDir + 'Entrprse.Exe') And         // Splash Screen
            FileExists (EntDir + 'EntComp.Dll') And          // MCM Library
            FileExists (EntDir + 'Enter1.Exe') And           // Enterprise
            FileExists (EntDir + 'EntCustm.Dll') And         // Customisation Library
            FileExists (EntDir + 'ExchqSS.Dat') And          // System Setup Database
            FileExists (EntDir + 'ExchqNum.Dat') And         // Document Numbers Database
            FileExists (EntDir + 'Cust\Custsupp.Dat');       // Customer/Supplier Database
{$ENDIF}
End; { ValidEntSystemDir }

//---------------------------------------------------------------------------

// Returns the current Enterprise directory as configured on
// the workstation.
//
// Return Values:-
//
//   0        OK
//   1001     Unknown Exception, see EnterpriseDir for details
//   1002     Unable to Find Enterprise Directory
//   1003     EnterpriseDir PChar too short
Function GetEnterpriseDir (Const EnterpriseDir : PChar) : SmallInt;
//Var
//  sNetworkPath, TmpStr : String;
//  EntWReplINI : TInifile;
Begin { GetEnterpriseDir }
  // HM 17/08/04: Modified for VAO Support
  Result := 0;
  try
    StrPCopy (EnterpriseDir, VAOInfo.vaoCompanyDir);
  except
    On E : Exception Do MessageDlg('EntSetup.DLL has raised an exception in GetEnterpriseDir'#13#13 + E.Message
    + #13#13'Please check that Exchequer is correctly registered on your system.', mtError, [mbOK], 0);
  end;{try}

(***
  Result := 1002;

  Try
    // Look in Registry to identify the enterprise directory from registered OLE/COM Objects
    With TRegistry.Create Do
      Try
        // Require Read-Only rights to the Registry
        Access := KEY_READ;

        // Firstly check for a registered OLE Server
        RootKey := HKEY_CLASSES_ROOT;

        //--------------------------------------

        If KeyExists('Enterprise.OLEServer\Clsid') Then
          { Key exists - Open key and get the CLSID (aka OLE/COM Server GUID) }
          If OpenKey('Enterprise.OLEServer\Clsid', False) Then Begin
            If KeyExists('') Then Begin
              { Read CLSID stored in default entry }
              TmpStr := ReadString ('');
              CloseKey;

              { Got CLSID - find entry in CLSID Section and check for registered .EXE }
              If KeyExists ('Clsid\'+TmpStr+'\LocalServer32') Then
                { Got Server details - read .EXE details and check it exists }
                If OpenKey('Clsid\'+TmpStr+'\LocalServer32', False) Then Begin
                  TmpStr := ReadString ('');

                  If FileExists (TmpStr) Then Begin
                    { Got OLE Server - Check for full system }
                    TmpStr := ExtractFilePath(TmpStr);

                    // For local program files, use the network directory.
                    if fileExists(TmpStr + 'ENTWREPL.INI') then begin
                      EntWReplINI := TInifile.Create(TmpStr + 'ENTWREPL.INI');
                      sNetworkPath := EntWReplINI.ReadString('UpdateEngine', 'NetworkDir', TmpStr);
                      if (Trim(sNetworkPath) <> '') and DirectoryExists(IncludeTrailingBackslash(sNetworkPath))
                      then TmpStr := IncludeTrailingBackslash(sNetworkPath);
                      EntWReplINI.Free;
                    end;{if}

                    If ValidEntSystemDir (TmpStr) Then Begin
                      { Valid directory - check pchar is long enough to store it }
                      If (Length(TmpStr) <= StrBufSize(EnterpriseDir)) Then Begin
                        Result := 0;
                        StrPCopy (EnterpriseDir, TmpStr);
                      End { If }
                      Else
                        // Pchar parameter not long enough
                        Result := 1003;
                    End; { If ValidEntSystemDir }
                  End; { If FileExists (ClsId) }
                End; { If OpenKey(... }
            End; { If KeyExists('') }

            CloseKey;
          End; { If OpenKey('Enterprise.OLEServer\Clsid' }

        //--------------------------------------

        If (Result <> 0) Then
          // OLE Server not registered - try ????

        //--------------------------------------

        If (Result = 0) Then
          // Check for Local Program Files - data may be in a different directory
          If FileExists (EnterpriseDir + 'ENTWREPL.INI') Then
            With TIniFile.Create (EnterpriseDir + 'ENTWREPL.INI') Do
              Try
                // Read the path which points to the enterprise network dir - usually blank
                TmpStr := ReadString ('UpdateEngine', 'NetworkDir', '');
                If (Trim(TmpStr) <> '') Then Begin
                  // Got a network dir - check the path is valid before returning it
                  TmpStr := IncludeTrailingBackslash (TmpStr);
                  If ValidEntSystemDir (TmpStr) Then Begin
                    // Valid Enterprise directory - return path
                    If (Length(TmpStr) <= StrBufSize(EnterpriseDir)) Then Begin
                      Result := 0;
                      StrPCopy (EnterpriseDir, TmpStr);
                    End { If }
                    Else
                      // Pchar parameter not long enough
                      Result := 1003;
                  End; { If ValidEntSystemDir}
                End; { If (Trim(TmpStr) <> '') }
              Finally
                Free;
              End;
      Finally
        Free;
      End;
  Except
    On E : Exception Do Begin
      // Return exception message in Enterprise Dir
      TmpStr := E.Message;
      If (Length(TmpStr) > StrBufSize(EnterpriseDir)) Then SetLength(TmpStr, StrBufSize(EnterpriseDir));
      StrPCopy (EnterpriseDir, TmpStr);

      Result := 1001;
    End; { On E : Exception }
  End; { Try..Except }
***)
End; { GetEnterpriseDir }

//---------------------------------------------------------------------------

// Adds a COM Plug-In into EntCustm.Ini
//
// Return Values:-
//
//   1001     Unknown Exception, see EnterpriseDir for details
//   1002     EnterpriseDir is not a valid Enterprise system
//   1003     PlugInPath does not point to a valid COM Plug-In
Function AddCOMPlugIn (EnterpriseDir, PlugInPath, PlugInDesc : PChar) : SmallInt;
Var
  oCOMClients              : TStringList;
  lEntDir, lPlugIn, TmpStr : String;
  I                        : SmallInt;
  Added                    : Boolean;
Begin { AddCOMPlugIn }
  Result := 0;

  Try
    // Make local copies of PChars - VB leaves loadsa trailing spaces
    lEntDir := IncludeTrailingPathDelimiter(Trim(EnterpriseDir));
    lPlugIn := UpperCase(Trim(PlugInPath));
    ReplaceStr(lPlugIn, '\\', '\');
    ReplaceStr(lPlugIn, '\\\', '\');
    ReplaceStr(lPlugIn, '\\\\', '\');

    //--------------------------------------

    // Check EnterpriseDir is valid
    If Not ValidEntSystemDir (lEntDir) Then
      Result := 1002;

    //--------------------------------------

    If (Result = 0) Then Begin
      // Check PlugInPath is valid
      If FileExists (lPlugIn) Then Begin
        // Check it is a .EXE
        If (ExtractFileExt (lPlugIn) <> '.EXE') Then
          Result := 1003;
      End { If FileExists (lPlugIn }
      Else
        // Error - PlugInPath is invalid
        Result := 1003;
    End; { If (Result = 0) }

    //--------------------------------------

    If (Result = 0) Then Begin
      // AOK - Open EntCustm.Ini and add into the [COMClients] section
      With TIniFile.Create (lEntDir + 'EntCustm.Ini') Do
        Try
          // Added flag indicates whether the Plug-In has been added into EntCustm.Ini
          Added := False;

          //--------------------------------------

          // Load existing clients and check to see if it is already installed
          oCOMClients := TStringList.Create;
          Try
            ReadSectionValues ('ComClients', oCOMClients);
            If (oCOMClients.Count > 0) Then
              For I := 0 to Pred(oCOMClients.Count) Do
                // Check to see if the FileNames match
                If (UpperCase(ExtractFileName (oComClients.Values[oComClients.Names[I]])) = ExtractFileName(lPlugIn)) Then Begin
                  // Filenames match - replace old entry with new
                  WriteString ('ComClients', oComClients.Names[I], lPlugIn);
                  Added := True;
                  Break;
                End; { If (UpperCase(ExtractFileName (... }
          Finally
            oCOMClients.Free;
          End;

          //--------------------------------------

          If (Not Added) Then
            // Run through COM Clients until we find a free slot, if there are over
            // 999 Plug-In's already installed they have more serious problems :-)
            For I := 1 To 999 Do
              // Check to see if the value exists
              If (Not ValueExists('ComClients', IntToStr(I))) Then Begin
                // Doesn't exist - Add it and finish the loop
                WriteString ('ComClients', IntToStr(I), lPlugIn);
                Break;
              End; { If (Not ValueExists ... }

          //--------------------------------------

          // Add Plug-In description into the .INI file for later usage
          TmpStr := ExtractFileName (lPlugIn);
          If (Pos ('.EXE', TmpStr) > 0) Then Delete (TmpStr, Pos ('.EXE', TmpStr), Length(TmpStr));
          WriteString ('PlugInDesc', TmpStr, Trim(PlugInDesc));
        Finally
          Free;
        End;
    End; { If (Result = 0) }
  Except
    On E : Exception Do Begin
      // Return exception message in Enterprise Dir
      TmpStr := E.Message;
      If (Length(TmpStr) > StrBufSize(EnterpriseDir)) Then SetLength(TmpStr, StrBufSize(EnterpriseDir));
      StrPCopy (EnterpriseDir, TmpStr);

      Result := 1001;
    End; { On E : Exception }
  End; { Try..Except }
End; { AddCOMPlugIn }


Function RemoveCOMPlugIn(pEnterpriseDir, pPlugInPath : PChar) : SmallInt;
// Removes a COM Plug-In from EntCustm.Ini
var
  iPos : integer;
  sEntDir, sPlugIn : ANSIstring;
  slCOMClients : TStringList;

begin
  // Make local copies of PChars - VB leaves loadsa trailing spaces
  Result := 0;
  sPlugIn := UpperCase(Trim(pPlugInPath));
  sEntDir := IncludeTrailingPathDelimiter(Trim(pEnterpriseDir));

  // Load existing client list, Find Client and remove.
  slCOMClients := TStringList.Create;
  Try
    With TIniFile.Create (sEntDir + 'EntCustm.Ini') Do begin
      ReadSectionValues ('ComClients', slCOMClients);
      If (slCOMClients.Count > 0) Then
        begin

          {delete all comclients with the specified path}
          iPos := 0;
          while iPos < slCOMClients.Count Do begin
            // Check to see if the FileNames match
            If (UpperCase(slCOMClients.Values[slCOMClients.Names[iPos]]) = sPlugIn) Then
              begin
                // Found Plug-In - Delete from list
                slCOMClients.Delete(iPos);
                Result := 0;
              end
            else Inc(iPos);
          end;{while}

          {Renumber and Write Section back to Ini File}
          EraseSection('ComClients');
          with slCOMClients do begin
            For iPos := 0 to Count - 1 do begin
              WriteString('ComClients', IntToStr(iPos + 1), Values[Names[iPos]]);
            end;{for}
          end;{with}

        end
      else Result := 0;
    end;{with}

    RemoveFromSysSetupMenu(PChar(ExtractFileName(sPlugIn)));

  Finally
    slCOMClients.Free;
  End;
end;

//---------------------------------------------------------------------------

// Adds a Delphi DLL Plug-In into EntCustm.Ini, Note DLLName should be the
// name of the DLL excluding any path and extension information.
//
// Return Values:-
//
//   1001     Unknown Exception, see EnterpriseDir for details
//   1002     EnterpriseDir is not a valid Enterprise system
//   1003     DLLName does not point to a valid Delphi DLL Plug-In
Function AddDLLPlugIn (EnterpriseDir, DLLName, PlugInDesc : PChar) : SmallInt;
Var
  lEntDir, lDllName, TmpStr : ShortString;
  DPUName, LastName         : String[8];
  Added                     : Boolean;
Begin { AddDLLPlugIn }
  Result := 0;

  Try
    // Make local copies of PChars - VB leaves loadsa trailing spaces
    lEntDir := IncludeTrailingPathDelimiter(Trim(EnterpriseDir));
    lDllName := UpperCase(Trim(DLLName));

    //--------------------------------------

    // Check EnterpriseDir is valid
    If Not ValidEntSystemDir (lEntDir) Then
      Result := 1002;

    //--------------------------------------

    If (Result = 0) Then Begin
      // Check PlugInPath is valid
      If Not FileExists (lEntDir + lDLLName + '.DLL') Then
        // Error - DllName is invalid
        Result := 1003;
    End; { If (Result = 0) }

    //--------------------------------------

    If (Result = 0) Then
      // AOK - Open EntCustm.Ini and add into the [HookChain] section
      With TIniFile.Create (lEntDir + 'EntCustm.Ini') Do
        Try
          // Added flag indicates whether the Plug-In has been added into EntCustm.Ini
          Added := False;

          //--------------------------------------

          LastName := 'ENTCUSTM';
          DPUName := UpperCase(ReadString('HookChain', LastName, ''));
          While (Trim(DPUName) <> '') Do Begin
            // Read next step in chain

            If (DPUName = lDLLName) Then Begin
              // Got Match - No need to add into chain
              Added := True;

              // Finish Loop
              Break;
            End { If (DPUName = lDLLName) }
            Else
              // Not match - move to next
              LastName := DPUName;

            DPUName := UpperCase(ReadString('HookChain', LastName, ''));
          End; { While (Trim(DPUName) <> '') }

          //--------------------------------------

          If (Not Added) Then
            // Add to end of chain
            WriteString('HookChain', LastName, lDLLName);

          //--------------------------------------

          // Add Plug-In description into the .INI file for later usage
          WriteString ('PlugInDesc', lDLLName, Trim(PlugInDesc));
        Finally
          Free;
        End;
  Except
    On E : Exception Do Begin
      // Return exception message in Enterprise Dir
      TmpStr := E.Message;
      If (Length(TmpStr) > StrBufSize(EnterpriseDir)) Then SetLength(TmpStr, StrBufSize(EnterpriseDir));
      StrPCopy (EnterpriseDir, TmpStr);

      Result := 1001;
    End; { On E : Exception }
  End; { Try..Except }
End; { AddDLLPlugIn }

Function RemoveDLLPlugIn (pEnterpriseDir, pPlugInPath : PChar) : SmallInt;
// Removes a DLL Plug-In from EntCustm.Ini
var
  iPos : integer;
  sPrevPlugIn, sEntDir, sPlugIn : ANSIstring;
  slChain : TStringList;
begin
  // Make local copies of PChars - VB leaves loadsa trailing spaces
  Result := 0;
  sPlugIn := UpperCase(Trim(pPlugInPath));
  sEntDir := IncludeTrailingPathDelimiter(Trim(pEnterpriseDir));

  // Load existing client list, Find Client and remove.
  slChain := TStringList.Create;
  Try
    With TIniFile.Create (sEntDir + 'EntCustm.Ini') Do begin
      ReadSectionValues ('HookChain', slChain);
      If (slChain.Count > 0) Then
        begin

          {delete all comclients with the specified path}
          iPos := 0;
          while iPos < slChain.Count Do begin
            // Check to see if the FileNames match
            If (UpperCase(slChain.Values[slChain.Names[iPos]]) = sPlugIn) Then
              begin
                // Found Plug-In - Delete from list
                slChain.Delete(iPos);
                Result := 0;
              end
            else Inc(iPos);
          end;{while}

          {Write New Section back to Ini File}
          EraseSection('HookChain');
          with slChain do begin
            sPrevPlugIn := 'ENTCUSTM';
            For iPos := 0 to Count - 1 do begin
              WriteString('HookChain', sPrevPlugIn, Values[Names[iPos]]);
              sPrevPlugIn := Values[Names[iPos]];
            end;{for}
          end;{with}

        end
      else Result := 0;
    end;{with}

    RemoveFromSysSetupMenu(PChar(ExtractFileName(sPlugIn)));
  Finally
    slChain.Free;
  End;
end;

//---------------------------------------------------------------------------

Function AddToToolsMenu (pName, pCommand, pParams, pStartDir : PChar) : SmallInt;
// Adds a new item into the Enterprise Tools menu
//
// Return Values:-
//
//   0        OK
//   1001 - 1003 Errors from GetEnterpriseDir
//   1100 - File to run from the tools menu, does not exist.
const
  sINIFileName = 'ENTTOOLS.DAT';
var
  iPos, iNextOptionNo : integer;
  sOptTitle : string;
  pEnterpriseDir : PChar;
  slTitles : TStringList;
  bFound : boolean;
begin
  If FileExists(pCommand) then
    begin
      pEnterpriseDir := StrAlloc(255);
      Result := GetEnterpriseDir(pEnterpriseDir);

      if Result = 0 then begin
        With TIniFile.Create(pEnterpriseDir + sINIFileName) do begin
          Try

            {does the title we want to add, already exist ?}
            slTitles := TStringList.Create;
            ReadSection ('ToolsTitles', slTitles);
            bFound := FALSE;
            for iPos := 0 to slTitles.Count - 1 do begin
              if ReadString('ToolsTitles', slTitles[iPos], '') = pName then bFound := TRUE;
            end;{for}
            slTitles.Free;

            if not bFound then begin
              {get next option number}
              iNextOptionNo := ReadInteger('ToolsMenu','Options',0) + 1;
              sOptTitle := 'Opt' + IntToStr(iNextOptionNo);

              {write new values to the inifile}
              WriteInteger('ToolsMenu','Options',iNextOptionNo);
              WriteString('ToolsTitles',sOptTitle,pName);
              WriteString('ToolsCmds',sOptTitle,pCommand);
              WriteString('ToolsParams',sOptTitle,pParams);
              WriteString('ToolsStartup',sOptTitle,pStartDir);
            end;{if}

          finally
            Free;
          end;{try}
        end;{with}
      end;{if}

      StrDispose(pEnterpriseDir);
    end
  else Result := 1100; {File to run from the tools menu, does not exist}
end;

Function AddLSTFileToReplFile(EnterpriseDir, LstFile : PChar) : SmallInt;
Var
  sReplFile, sEntDir, sLstFile, TmpStr : ShortString;
  slReplFile : TStringList;

  function RemoveTrade(sDir : string) : string;
  var
    iPos : integer;
  begin{RemoveTrade}
    iPos := Pos('\TRADE\',UpperCase(sDir));
    if iPos = 0 then Result := sDir
    else Result := Copy(sDir,1,iPos);
  end;{RemoveTrade}

Begin { AddLSTFileToReplFile }
  Result := 0;

  Try
    // Make local copies of PChars - VB leaves loadsa trailing spaces
    sEntDir := IncludeTrailingPathDelimiter(Trim(EnterpriseDir));
    sLstFile := UpperCase(Trim(LstFile));
    sReplFile := sEntDir + 'REPLFILE.LST';

    // Check EnterpriseDir is valid
    If Not ValidEntSystemDir(RemoveTrade(sEntDir)) Then Result := 1002
    else begin
      // Check to see if the LST file actually exists
      if not FileExists(sEntDir + sLstFile) then Result := 1003
      else begin
        slReplFile := TStringList.Create;

        // Only load it if the file exists
        if FileExists(sReplFile) then slReplFile.LoadFromFile(sReplFile);

        // only add it if it is not already there
        if slReplFile.IndexOf(sLstFile) = -1 then AddLineToFile(sLstFile, sReplFile);

        slReplFile.Free;
      end;{if}
    end;{if}

  Except
    On E : Exception Do Begin
      // Return exception message in Enterprise Dir
      TmpStr := E.Message;
      If (Length(TmpStr) > StrBufSize(EnterpriseDir)) Then SetLength(TmpStr, StrBufSize(EnterpriseDir));
      StrPCopy (EnterpriseDir, TmpStr);

      Result := 1001;
    End; { On E : Exception }
  End; { Try..Except }
End; { AddLSTFileToReplFile }

// Adds a COM Plug-In into EntCustm.Ini
//
// Return Values:-
//
//   1001     Unknown Exception, see EnterpriseDir for details
//   1002     EnterpriseDir is not a valid Enterprise system
//   1003     PlugInPath does not point to a valid COM Plug-In
Function AddTCMPlugIn (EnterpriseDir, PlugInPath : PChar) : SmallInt;
Var
  slTCMClients              : TStringList;
  sEntDir, sPlugIn, TmpStr : String;
  I                        : SmallInt;
  Added                    : Boolean;
Begin { AddTCMPlugIn }
  Result := 0;

  Try
    // Make local copies of PChars - VB leaves loadsa trailing spaces
    sEntDir := IncludeTrailingPathDelimiter(Trim(EnterpriseDir));
    sPlugIn := Trim(PlugInPath);

    //--------------------------------------

    // Check EnterpriseDir is valid
    If Not ValidEntSystemDir (sEntDir) Then
      Result := 1002;

    //--------------------------------------

(*    If (Result = 0) Then Begin
      // Check PlugInPath is valid
      If FileExists (sPlugIn) Then Begin
        // Check it is a .EXE
        If (ExtractFileExt (sPlugIn) <> '.EXE') Then
          Result := 1003;
      End { If FileExists (sPlugIn }
      Else
        // Error - PlugInPath is invalid
        Result := 1003;
    End; { If (Result = 0) }*)

    //--------------------------------------

    If (Result = 0) Then Begin
      // AOK - Open EntCustm.Ini and add into the [PlugIns] section
      With TIniFile.Create (sEntDir + '\TRADE\TCCustom.Ini') Do
      begin
        Try
          // Added flag indicates whether the Plug-In has been added into EntCustm.Ini
          Added := False;

          //--------------------------------------

          // Load existing clients and check to see if it is already installed
          slTCMClients := TStringList.Create;
          Try
            ReadSectionValues ('PlugIns', slTCMClients);
            If (slTCMClients.Count > 0) Then begin
              For I := 0 to Pred(slTCMClients.Count) Do
              begin
                // Check to see if the FileNames match
                If (slTCMClients.Values[slTCMClients.Names[I]] = sPlugIn) Then
                Begin
                  // Filenames match - replace old entry with new
                  WriteString ('PlugIns', slTCMClients.Names[I], sPlugIn);
                  Added := True;
                  Break;
                End; { If (UpperCase(ExtractFileName (... }
              end;{for}
            end;{if}
          Finally
            slTCMClients.Free;
          End;{try}

          //--------------------------------------

          If (Not Added) Then
          begin
            // Run through COM Clients until we find a free slot, if there are over
            // 999 Plug-In's already installed they have more serious problems :-)
            For I := 1 To 999 Do
            begin
              // Check to see if the value exists
              If (Not ValueExists('PlugIns', IntToStr(I))) Then
              Begin
                // Doesn't exist - Add it and finish the loop
                WriteString ('PlugIns', IntToStr(I), sPlugIn);
                Break;
              End; { If (Not ValueExists ... }
            end;{for}
          end;{if}

        Finally
          Free;
        End;
      end;
    End; { If (Result = 0) }
  Except
    On E : Exception Do Begin
      // Return exception message in Enterprise Dir
      TmpStr := E.Message;
      If (Length(TmpStr) > StrBufSize(EnterpriseDir)) Then SetLength(TmpStr, StrBufSize(EnterpriseDir));
      StrPCopy (EnterpriseDir, TmpStr);

      Result := 1001;
    End; { On E : Exception }
  End; { Try..Except }
End; { AddTCMPlugIn }

Function AddToSysSetupMenu(pName, pCommand, pParams, pStartDir, pPlugInFile : PChar) : SmallInt;
// Adds a new item into the Enterprise Tools menu
//
// Return Values:-
//   0        OK
//   1001 - 1003 Errors from GetEnterpriseDir
//   1100 - File to run from the tools menu, does not exist.
const
  sINIFileName = 'EntSetup.DAT';
var
  pEnterpriseDir : PChar;
begin
  If FileExists(pCommand) then
    begin
      pEnterpriseDir := StrAlloc(255);
      Result := GetEnterpriseDir(pEnterpriseDir);

      if Result = 0 then begin
        With TIniFile.Create(pEnterpriseDir + sINIFileName) do begin
          Try

            // Read all titles
(*            slTitles := TStringList.Create;
            ReadSections(slTitles);

            // does the title we want to add, already exist ?
            bFound := FALSE;
            for iPos := 0 to slTitles.Count - 1 do begin
              if slTitles[iPos] = pName then bFound := TRUE;
            end;{for}
            slTitles.Free;

            if not bFound then begin*)
              {write new values to the inifile}
              WriteString(pName,'Command',pCommand);
              WriteString(pName,'Params',pParams);
              WriteString(pName,'StartUpDir',pStartDir);
              WriteString(pName,'PlugInFile',pPlugInFile);
//            end;{if}

          finally
            Free;
          end;{try}
        end;{with}
      end;{if}

      StrDispose(pEnterpriseDir);
    end
  else Result := 1100; {File to run from the tools menu, does not exist}
end;

Function RemoveFromSysSetupMenu(pPlugInFile : PChar) : SmallInt;
// Adds a new item into the Enterprise Tools menu
//
// Return Values:-
//   0        OK
//   1001 - 1003 Errors from GetEnterpriseDir
const
  sINIFileName = 'EntSetup.DAT';
var
  iPos : integer;
  pEnterpriseDir : PChar;
  slTitles : TStringList;
//  bFound : boolean;
begin
//  If FileExists(pCommand) then
//    begin
      pEnterpriseDir := StrAlloc(255);
      Result := GetEnterpriseDir(pEnterpriseDir);

      if Result = 0 then begin
        With TIniFile.Create(pEnterpriseDir + sINIFileName) do begin
          Try

            // Read all titles
            slTitles := TStringList.Create;
            ReadSections(slTitles);

            // if PlugInFile found in any of the sections, delete the section
//            bFound := FALSE;
            for iPos := 0 to slTitles.Count - 1 do begin
              if ReadString(slTitles[iPos],'PlugInFile','') = pPlugInFile
              then EraseSection(slTitles[iPos]);
            end;{for}
            slTitles.Free;

          finally
            Free;
          end;{try}
        end;{with}
      end;{if}

      StrDispose(pEnterpriseDir);
//    end
//  else Result := 1100; {File to run from the tools menu, does not exist}
end;

Function IsSQLVersion : SmallInt; StdCall; Export;
begin
  if UsingSQL then Result := 1
  else Result := 0;
end;


end.
