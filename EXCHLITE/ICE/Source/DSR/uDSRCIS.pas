{-----------------------------------------------------------------------------
 Unit Name: uDSRCIS
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDSRCIS;

Interface

Uses Classes, Sysutils, Windows;

Type
  {cis reforms}
  TDSRCIS = Class(TThread)
  Private
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End;

Implementation

Uses uDSRSettings, uAdoDSR, uConsts, uCommon, uSystemConfig, uInterfaces;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRCIS.Create;
Begin
  Inherited Create(True);
  FreeOnTerminate := True;
  Priority := tpLower;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRCIS.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRCIS.Execute;

Var
  lComp: TCompany; // company object
  lOut: OleVariant; // companies stored
  lCont, lTotal, lPackId: Integer; // counters
  lDb: TADODSR; // database
  lOldFile, lNewFile: String;
  lPack: TPackageInfo;
Begin
  lDb := Nil;
  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: Exception Do
      _LogMSG('TDSRCIS.Execute :- Error connecting the Database. Error: ' +
        e.message)
  End; {try}

  If Assigned(lDb) And lDB.Connected Then
  Try
    {get companies from db}
    lOut := lDB.GetCompanies;
    lTotal := _GetOlevariantArraySize(lOut);
    For lCont := 0 To lTotal - 1 Do
    Begin
      {create company object}
      lComp := _CreateCompanyObj(lOut[lCont]);
      If lComp <> Nil Then
      Begin
        {double check if company exists and is active}
        If lComp.Active And _DirExists(lComp.Directory) And Not Terminated Then
        Begin
        {if cis return xml exists, create a temp entry that will be picked up latter by the
        producer/sender thread}
          lOldFile := _GetCISFile(IncludeTrailingPathDelimiter(lComp.Directory) + cCISXMLDIR);
          //lNewFile := IncludeTrailingPathDelimiter(lComp.Directory) + cCISXMLDIR + '\' + cCISMONTHLYRETFILEPROCESS;

          lNewFile := ExtractFilePath(lOldFile) + '\' + cCISMONTHLYRETFILEPROCESS;


          {check if the old file exists}
          If (lOldFile <> '') and (_FileSize(lOldFile) > 0) Then
          Begin
            lPackId := 0;
            lPack := nil;
            lPack := lDb.GetExportPackage(lComp.Id, cCISMONTHLYEXPORT);

            if lPack <> nil then
              lPackId := lPack.Id;

            {copy old file to avoid threads to process the file once more}
            If CopyFile(pChar(lOldFile), pChar(lNewFile), False) Then
              _DelFile(lOldFile)
            Else
              MoveFile(pChar(lOldFile), pChar(lNewFile));

            If _FileSize(lNewFile) > 0 Then
              _DelFile(lOldFile);

            lDb.UpdateOutBox(_CreateGuid, // guid
              lComp.Id, // company id
              cCISMONTHLYRETSUBJECT, // subject
              lComp.Desc, // from: company descrition
              cCISRECIPIENT, // to: ggw gateway
              lPackId, // pack_id
              1, // total
              '', // param 1
              '', // param 2
              cPENDING, // pending message
              Ord(rmCIS), // type of message (cis)
              dbDoAdd); // add to database
          End; {if _FileSize(lComp.Directory + '') > 0 then}
        End; {If lComp.Active And _DirExists(lComp.Directory) Then}

        FreeAndNil(lComp);
      End; {if lComp <> nil then}
    End; {for lCont:= 0 to lTotal - 1 do}
  Except
    On E: Exception Do
    Begin
      _LogMSG('TDSRCIS.Execute :- Error processing CIS files. Error: ' + e.Message);
      If Assigned(lDb) And lDb.Connected Then
        lDb.UpdateIceLog('TDSRCIS.Execute', 'Error processing CIS files. Error: ' +
          e.Message);
    End; {begin}
  End; {if fDB.Connected then}

  If Assigned(lDb) Then
    FreeAndNil(lDb);

  Terminate;
End;

End.

