Unit BtrDel;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry,

  WiseUtil, ShellApi, {Tlhelp32,} ExtCtrls, StdCtrls, ComCtrls, SETUPBAS
  ;

Type
  TfrmDeleteBetrieve = Class(TSetupTemplate)
    Progress: TProgressBar;
    Animate: TAnimate;
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

{ VM 13/04/2007  delete btrieve files when doing an upgrade v600/sql ... }
Function SCD_DeleteOldBtrieveFiles(Var DLLParams: ParamRec): LongBool; StdCall; export;

Var
  frmDeleteBetrieve: TfrmDeleteBetrieve;

Implementation

Uses
//  GlobVar, VarConst, BtrvU2, EtDateU, EtMiscU, EtStrU, BtKeys1U,
  CompUtil, entlicence, pervinfo, GlobVar, VarConst, VarFPosU, BtrvU2
//  IniFiles,
//  GlobExcH, BtSupU1, TCompObj, SerialU, SysU3, LicRec, WLicFile, VarFPosU,
//  EntLic, LicFuncU, SecSup2U, HelpSupU, ModRels,
//{$IFDEF EXSQL}
//  {SQLUtils,}  // MH 20/09/07: Not used as far as I can tell
//{$ENDIF}
//  ChkSizeF // Data File Size checking routine
  ;

{$R *.dfm}

Function SCD_DeleteOldBtrieveFiles(Var DLLParams: ParamRec): LongBool;
Const
  cBTRIEVEENG = 'w3dbsmgr.exe';
  cARCHIVEDIR = 'Archive';
  cDEFEXT = '.def';
  cLSTEXT = '.lst';
  cHELPDEF = 'HELP.DEF';
  cEXCHDEL = 'ExchDel.Lst';
  cEXBTRDEL = 'BtrDel.Lst';
  cEXCOMPDEL = 'CompDel.lst';
  cUNREGWIN32 = 'UNREG32{';
  cUNREGASM = 'UNREGASM{';
Var
  DLLStatus: LongInt;
  W_InstType, W_MainDir: ANSIString;

(*  bloody rex file would need all this!!!
var
   IObject : IUnknown;
   ISLink : IShellLink;
   IPFile : IPersistFile;
   PIDL : PItemIDList;
   InFolder : array[0..MAX_PATH] of Char;
   TargetName : String;
   LinkName : WideString;
begin
   TargetName := 'C:\EXCHEQR_DEMO\REX.bat';

   IObject := CreateComObject(CLSID_ShellLink) ;
   ISLink := IObject as IShellLink;
   IPFile := IObject as IPersistFile;

   with ISLink do
   begin
     SetPath(pChar(TargetName)) ;
//     SetWorkingDirectory(pChar(ExtractFilePath(TargetName))) ;
   end;

   LinkName := 'C:\EXCHEQR_DEMO\archive\REX.lnk';
   IPFile.Save(PWChar(LinkName), true) ;
*)

(*  Function _KillTask(Const pExeName: String): Integer;
  Var
    ContinueLoop: BOOL;
    FSnapshotHandle: THandle;
    FProcessEntry32: TProcessEntry32;
  Begin
    Result := 0;
    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
    ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

    While Integer(ContinueLoop) <> 0 Do
    Begin
      If ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
        UpperCase(pExeName)) Or (UpperCase(FProcessEntry32.szExeFile) =
        UpperCase(pExeName))) Then
      Begin
        Result := Integer(TerminateProcess(
          OpenProcess(PROCESS_TERMINATE,
          BOOL(0),
          FProcessEntry32.th32ProcessID),
          0));
        Break;
      End;
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    End;

    CloseHandle(FSnapshotHandle);
  End; {Function _KillTask(Const pExeName: String): Integer;}
 *)

  Function CheckForWGE(Var DLLParams: ParamRec): Boolean;
  Var
    oRegistry: TRegistry;
    sDBPath, sWGEPath: ShortString;
    GotWGE: Boolean;
  Begin // SCD_CheckForKosherWGE
    oRegistry := TRegistry.Create;
    Try
      oRegistry.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
      oRegistry.RootKey := HKEY_Local_Machine;

      GotWGE := False;

      If
        oRegistry.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL Workgroup\InstallInfo', False) Then
      Begin
        // A workgroup engine is installed - extract path and check for some basic files to comfirmicate
        sDBPath := oRegistry.ReadString('InstallDir'); // e.g. C:\PVSW
        If (sDBPath <> '') Then
        Begin
          sDBPath := IncludeTrailingPathDelimiter(sDBPath);

          // Check it isn't the Exchequer directory and that there is a valid BIN subdirectory
          GotWGE := Not FileExists(sDBPath + 'Enter1.Exe') And
            DirectoryExists(sDBPath + 'Bin');
          If GotWGE Then
          Begin
            sWGEPath := sDBPath + 'Bin\';
            GotWGE := FileExists(sWGEPath + 'BTRVDD.DLL')
                      And FileExists(sWGEPath + 'DBU_UI.DLL')
                      And FileExists(sWGEPath + 'jsbdosws.dll')
                      And FileExists(sWGEPath + 'poledb.dll')
                      And FileExists(sWGEPath + 'w3mkde.dll')
                      And FileExists(sWGEPath + 'wbtrcall.dll')
                      And FileExists(sWGEPath + 'wbtrv32.dll');
          End; // If GotWGE
        End; // If (sWGEPath <> '') And DirectoryExists(sWGEPath)
      End; // If oRegistry.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL Workgroup\InstallInfo', False)
    Finally
      oRegistry.Free;
    End; // Try..Finally

    Result := GotWGE;
  End; // SCD_CheckForKosherWGE

  Function _MoveDir(Const pFromDir, pToDir: String): Boolean;
  Var
    fos: TSHFileOpStruct;
  Begin
    ZeroMemory(@fos, SizeOf(fos));
    With fos Do
    Begin
      wFunc := FO_MOVE;
      fFlags := FOF_SILENT Or FOF_NOCONFIRMATION Or FOF_FILESONLY;
      pFrom := PChar(pFromDir + #0);
      pTo := PChar(pToDir);
    End;
    Result := (0 = ShFileOperation(fos));
  End;

  Procedure DeleteList(Const pMainDir, pFileList: String);
  Var
    lLst: TStringList;
    lCont, iOpenBracket : Integer;
    lFileName,
    lDir: String;
  Begin
//ShowMessage ('DeleteList(MainDir=' + pMainDir + ', FileList=' + pFileList + ')');
    If FileExists(pFileList) Then
    Begin
      lLst := TStringList.Create;
      lDir := IncludeTrailingPathDelimiter(pMainDir + cARCHIVEDIR);

      ForceDirectories(lDir);

      Try
        lLst.LoadFromFile(pFileList);
      Except
      End;

      If Assigned(frmDeleteBetrieve) Then
        frmDeleteBetrieve.Progress.Position := 0;

    {check number of commands}
      If lLst.Count > 0 Then
        For lCont := 0 To lLst.Count - 1 Do
        Begin
          If Trim(lLst[lCont]) <> '' Then
          Begin
            {create destinarion directory}
            Try
              If Not DirectoryExists(lDir + extractfilepath(llst[lCont])) Then
                ForceDirectories(lDir + extractfilepath(llst[lCont]));
            Except
            End;

            Try
              // unreg win32 dlls
              if Pos(cUNREGWIN32, Uppercase(lLst[lCont])) > 0 then
              begin
                // get the filename {}
                iOpenBracket := Pos('{', lLst[lCont]) + 1;
                lFileName := Copy(lLst[lCont], iOpenBracket, Pos('}', lLst[lCont]) - iOpenBracket);
                lFileName := IncludeTrailingPathDelimiter(pMainDir) + lFileName;
//ShowMessage ('>' + lLst[lCont] + '<'#13 +
//             '{: ' + IntToStr(iOpenBracket) + #13 +
//             '}: ' + IntToStr(Pos('}', lLst[lCont]) - 1) + #13 +
//             'lFileName: ' + lFileName);

                If FileExists(lFileName) Then
                Begin
                  //ShellExecute(0, nil, pChar('regsvr32'), pChar('/u ' + lFileName), pChar(ExtractFilePath(lFileName)), SW_HIDE)
                  if Uppercase(ExtractFileExt(lFileName)) = '.EXE' then
                    WinExec(pChar(lFileName + ' /unregserver'), sw_hide)
                  else
                    WinExec(pChar('regsvr32 /u ' + lFileName), sw_hide);

                  // MH 05/10/07: Modified from 100ms to 1s as files were being deleted before RegSvr32 got to them!
                  Sleep(1000);

                  // MH: Shouldn't this be archiving?
                  DeleteFile(lFileName);
                End; // If FileExists(lFileName)
              end
              // unreg .net dlls
              else if Pos(cUNREGASM, Uppercase(lLst[lCont])) > 0 then
              begin
                // get the filename {}
                lFileName := Copy(lLst[lCont], Pos('{', lLst[lCont]) + 1, Pos('}', lLst[lCont]) - 1);
                lFileName := IncludeTrailingPathDelimiter(pMainDir) + lFileName;

                //ShellExecute(0, nil, pChar('regasm'), pChar('/u ' + lFileName), pChar(ExtractFilePath(lFileName)), SW_HIDE)
                WinExec(pChar('regasm /u ' + lFileName), sw_hide);

                Sleep(100);

                // MH: Shouldn't this be archiving?
                DeleteFile(lFileName);
              end
              else
                {look for .def and .lst files}
              If Lowercase(ExtractFileExt(pMainDir + lLst[lCont])) = cDEFEXT Then
              Begin
                  {move help.det to a destination directory}
                If Uppercase(ExtractFileName(pMainDir + lLst[lCont])) = cHELPDEF
                  Then
                  _MoveDir(pMAinDir + lLst[lCont], lDir +
                    ExtractFilePath(lLst[lCont]))
                Else If FileExists(ChangeFileExt(pMainDir + lLst[lCont],
                  cLSTEXT)) Then // only moves the file if .def and .lst exist
                Begin
                    {move .def file to a destination directory}
                  _MoveDir(pMainDir + lLst[lCont], lDir +
                    ExtractFilePath(lLst[lCont]));
                    {move .lst file to a destination directory}
                  _MoveDir(ChangeFileExt(pMainDir + lLst[lCont], cLSTEXT), lDir +
                    ExtractFilePath(lLst[lCont]));
                End; {if FileExists(ChangeFileExt(W_MainDir + lLst[lCont], cLSTEXT) then}
              End
              Else
                _MoveDir(pMainDir + lLst[lCont], lDir +
                  ExtractFilePath(lLst[lCont]));
            Except
            End; {If Trim(lLst[lCont]) <> '' Then}
          End; {If Trim(lLst[lCont]) <> '' Then}

          {update progress bar}
          Try
            If Assigned(frmDeleteBetrieve) Then
              frmDeleteBetrieve.Progress.Position := Trunc((lCont / lLst.Count) *
                100);
          Finally
          End;

          Application.ProcessMessages;
          Sleep(5);
        End; {For lCont := 0 To lLst.Count - 1 Do}

      lLst.Free;
    End; {if FileExists(W_MainDir + 'btrdel.lst') then}
  End;

  procedure DeleteCompanyFiles(Const pMainDir: String);
  Const
    FNum = CompF;
    KeyPath : Integer = CompCodeK;
  Var
    KeyS    : Str255;
    lCompPath: TStringList;
    lCont: Integer;
    lStatus: Integer;
  begin
    { Check Btrieve is running - often comes in handy :-) }
    If Check4BtrvOk Then
    Begin
      { Open Company.Dat in Main Directory }
      LStatus := Open_File(F[CompF], W_MainDir + FileNames[CompF], 0);
      If (LStatus = 0) Then
      Begin
        lCompPath:= TStringList.Create;
        Try
          { Load Companies into list }
          KeyS := cmCompDet;
          lStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
//ShowMessage ('DeleteCompanyFiles lStatus=' + IntToStr(lStatus));
          While (lStatus = 0) And (Company^.RecPFix = cmCompDet) Do
          Begin
            lCompPath.Add(Trim(Company^.CompDet.CompPath));
            lStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
          End; { While }

          Close_File(F[CompF]);

          if lCompPath.Count > 0 then
            for lCont:= 0 to lCompPath.Count - 1 do
              DeleteList(IncludeTrailingPathDelimiter(lCompPath[lCont]), pMainDir + cEXCOMPDEL);
        Finally
          lCompPath.Free;
        End; // Try..Finally
      End; // If (LStatus = 0)
    End; // If Check4BtrvOk
  end; {procedure DeleteCompanyFiles(Const pMainDir: String);}

Begin
  Result := False;

  frmDeleteBetrieve := TfrmDeleteBetrieve.Create(Nil);

  With frmDeleteBetrieve Do
  Begin
    Show;

    Animate.Active := True;

    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    FixPath(W_MainDir);
    W_MainDir := IncludeTrailingPathDelimiter(W_MainDir);

    // Get Installation Type from WISE - A=Install, B=Upgrade, C=Add Company
    GetVariable(DLLParams, 'V_INSTTYPE', W_InstType);

    // Only delete files for Upgrades
    If (UpperCase(Trim(W_InstType)) = 'B') Then
      {check main directory exists}
      If DirectoryExists(W_MainDir) Then
        Try
          // remove obsolete Exchequer files
          DeleteList(W_MainDir, W_MainDir + cEXCHDEL);

          // remove btrieve/pervasive.sql files
          If (EnterpriseLicence.elWorkgroupLicence <> wgeVersion8) or
             (not (PervasiveInfo.WorkgroupVersion In [wv8, wv86, wv87])) or
              (CheckForWGE(DLLParams)) Then
                DeleteList(W_MainDir, W_MainDir + cEXBTRDEL);

          // delete a list of files by company
          DeleteCompanyFiles(W_MainDir);
        Except
        End; {If DirectoryExists(W_MainDir) Then}

    Animate.Active := False;
    Progress.Position := 0;

    frmDeleteBetrieve.Free;

  End; {With frmDeleteBetrieve Do}
End;

End.

