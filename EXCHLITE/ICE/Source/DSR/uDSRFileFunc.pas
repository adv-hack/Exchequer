{-----------------------------------------------------------------------------
 Unit Name: uDSRFileFunc
 Author:    vmoura
 Purpose:
 History:

 slit file
   example
    1.xml is just one file
    2.001 is file number two split number one
    2.002 file number two, split number two and so on...

-----------------------------------------------------------------------------}
Unit uDSRFileFunc;

Interface

Uses Classes, uConsts;

Function _CreateDSRFile(Var pHeader: TDSRFileHeader; Const pFile: String; pXML:
  WideString): TStringList;

Function _WriteDSRXml(Var pHeader: TDSRFileHeader; Const pFile: String; pXML:
  WideString): Boolean;

Procedure _WriteDSRFile(Var pHeader: TDSRFileHeader; Const pInFile, pOutFile:
  String);

Function _DSRFileCheckDecompress(Const pFile: String): Boolean;

Function _GetHeaderFromFile(Var pHeader: TDSRFileHeader; Const pFile: String):
  Boolean;
Function _GetNACKFromFile(Var pNack: TNACK; Const pFile: String): Boolean;
Function _GetACKFromFile(Var pAck: TACK; Const pFile: String): Boolean;
Function _GetSyncReqFromFile(Var pSync: TSyncRequest; Const pFile: String):
  Boolean;

Function _SetHeaderToFile(pHeader: TDSRFileHeader; Const pFile: String):
  Boolean;
Function _GetXmlFromFile(Const pFile: String): WideString;

Function _CombineFiles(Const pFileName: String; Const pResultFile: String):
  Boolean;
Function _SplitFile(Const pFileName: String): String;
Function _CheckFileComplete(pHeader: TDSRFileHeader; Const pFileName: String):
  Boolean;
Function _CheckBatchComplete(pHeader: TDSRFileHeader; Const pPath: String):
  Boolean;
Function _CheckBatchCompleteEx(pHeader: TDSRFileHeader; Const pPath: String):
  Boolean; overload;

Function _CheckBatchCompleteEx(pFile: TStringList): Boolean; overload;

Function _FindMissingOrder(pHeader: TDSRFileHeader; Const pPath: String):
  Longword;

Function _GetFileByOrder(Const pPath: String; pOrder: Longword; Const
  pReturnFirst: Boolean = False): String;

Implementation

Uses Sysutils, Windows,
  uCommon, uXmlBaseClass;

{-----------------------------------------------------------------------------
  Procedure: _CreateDSRFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CreateDSRFile(Var pHeader: TDSRFileHeader; Const pFile: String; pXML:
  WideString): TStringList;
Var
  lTemp: String;
Begin
  Result := TStringList.Create;

  { create a temporary file}
  lTemp := ExtractFilePath(pFile) + _CreateGuidStr;

  Try
    { create a temp file using that xml}
    _CreateXmlFile(lTemp, pXml);

    { encrypt and compress the temp file}
    If _CompressAndEncrypt(lTemp) Then
    Begin
      {go ahead if the dsr can process this file}
      If _DSRFileCheckDecompress(lTemp) Then
      Begin
        _WriteDSRFile(pHeader, lTemp, pFile);

        If Not _IsValidXml(_GetXmlFromFile(pFile)) Then
          _DelFile(pFile);
      End
      Else
      Begin
        _LogMSG('_CreateDSRFile :- Error checking encrypting integrity...');
        _DelFile(lTemp);
      End;
    End
    Else
    Begin
      _LogMSG('_CreateDSRFile :- Error compressing and encrypting file...');
      _DelFile(lTemp);
    End;
  Except
    On e: exception Do
    Begin
      _LogMSG('_CreateDSRFile (1):- Error creating XML File. Error: ' +
        e.message);
      _DelFile(lTemp);
    End;
  End; // assigned

  _DelFile(lTemp);

  {something went wrong. try creating this file using a xml object stead. if i really can't
  create the xml, then there are something really wrong and i have to delete the output}
  If Not (_FileSize(pFile) > 0) Then
    If Not _WriteDSRXml(pHeader, pFile, pXML) Then
      _DelFile(pFile);

  {check the result}
  If Not (_FileSize(pFile) > 0) Then
  Begin
    _DelFile(pFile);
    If Assigned(Result) Then
      FreeAndNil(Result);
  End
  Else
  Begin
    { break down the file if bigger them 1MB}
    If _FileSize(pFile) > MBYTE Then
    Begin
      Result.CommaText := _SplitFile(pFile);
      //Delete the original file
      _DelFile(pFile);
    End
    Else
      Result.Add(pFile);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _DSRFileCheckDecompress
  Author:    vmoura
 check if is possible to decompress this file whithout bother the original file
-----------------------------------------------------------------------------}
Function _DSRFileCheckDecompress(Const pFile: String): Boolean;
Var
  lAux: String;
Begin
  Result := False;
  lAux := ExtractFilePath(pFile) + _CreateGuidStr;
  CopyFile(pChar(pFile), pChar(lAux), False);
  If _FileSize(lAux) > 0 Then
    Result := _DecryptAndDecompress(lAux);
  _DelFile(lAux);
End;

{-----------------------------------------------------------------------------
  Procedure: _WriteDSRXml
  Author:    vmoura

  this function does almost the same as createdsrfile.
  the diference here who is loading the xml is a msxml component that will
  try to check if this file is valid or not
-----------------------------------------------------------------------------}
Function _WriteDSRXml(Var pHeader: TDSRFileHeader; Const pFile: String; pXML:
  WideString): Boolean;
Var
  lDoc: TXMLDoc;
  lTemp, lOut: String;
Begin
  Result := False;
  lDoc := Nil;
  Try
    lDoc := TXMLDoc.Create;
  Except
  End; {try}

  If Assigned(lDoc) Then
  Try
    {load is already checking this file}
    If lDoc.LoadXml(pXML) Then
    Begin
      lTemp := ExtractFilePath(pFile) + _CreateGuidStr;
      lOut := ExtractFilePath(pFile) + _CreateGuidStr;

      {create temp file based on that this xml is working fine}
      Try
        lDoc.Save(lTemp);
      Except
        _DelFile(lTemp);
      End; {try}

      If _FileSize(lTemp) > 0 Then
      Try
        If _CompressAndEncrypt(lTemp) Then
        Begin
          {go ahead if the dsr can process this file}
          If _DSRFileCheckDecompress(lTemp) Then
          Begin
            _WriteDSRFile(pHeader, lTemp, pFile);

              {double check if the file is valid. This is using the same function that will
              open the file to be imported.}
            Result := _IsValidXml(_GetXmlFromFile(pFile));

            If Not Result Then
              _DelFile(pFile);
          End
          Else
            _LogMSG('_WriteDSRXml :- Error checking encrypting integrity...');
        End
        Else
          _LogMSG('_WriteDSRXml :- Error compressing and encrypting file...');
      Finally
        _DelFile(lTemp);
      End; {if _FileSize(pFile) then}
    End; {if lDoc.LoadXml(pXML) then}
  Finally
    If Assigned(lDoc) Then
      FreeAndNil(lDoc);
  End; {If Assigned(lDoc) Then}

  If _FileSize(lTemp) > 0 Then
    _DelFile(lTemp);
End;

{-----------------------------------------------------------------------------
  Procedure: _WriteDSRFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _WriteDSRFile(Var pHeader: TDSRFileHeader; Const pInFile, pOutFile:
  String);
Var
  lMemory: TMemoryStream;
  lFile: TFileStream;
  lCheckSum, lSize: Longword;
Begin
  lMemory := Nil;
  lFile := Nil;

  lMemory := TMemoryStream.Create;
  Try
    lMemory.LoadFromFile(pInFile);

    pHeader.CheckSum := 0;
    pHeader.Split := 0;
    pHeader.SplitTotal := 0;
    pHeader.SplitCheckSum := 0;
    lCheckSum := 0;

{ calc the check sum of the temp file}
    lSize := lMemory.Size;

    _CalcCRC32(lMemory.Memory, lSize, lCheckSum);
    pHeader.CheckSum := lCheckSum;

    lMemory.Position := 0;
{create the new file adding the header first}
    Try
      lFile := TFileStream.Create(pOutFile, fmCreate);
      Try
        lFile.Write(pHeader, SizeOf(TDSRFileHeader));
        lFile.Write(lMemory.Memory^, lSize);
      Except
        On e: Exception Do
        Begin
          _LogMSG('_WriteDSRFile :- Error creating XML file...');
          If Assigned(lFile) Then
            FreeAndNil(lFile);
          _DelFile(pOutFile);
        End; {begin}
      End; {try}
    Finally
      If Assigned(lFile) Then
        FreeAndNil(lFile);
    End; {try}
  Finally
    If Assigned(lMemory) Then
      FreeAndNil(lMemory);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetHeaderFromFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetHeaderFromFile(Var pHeader: TDSRFileHeader; Const pFile: String):
  Boolean;
Var
  lFile: TFileStream;
Begin
  Result := False;
  lFile := Nil;

  If _FileSize(pFile) > 0 Then
  Begin
    FillChar(pHeader, SizeOf(TDSRFileHeader), 0);

    Try
      lFile := TFileStream.Create(pFile, fmOpenRead, fmShareDenyNone);
    Except
      On e: exception Do
      Begin
        lFile := Nil;
        _LogMSG('_GetHeaderFromFile :- Error loading file. Error: ' +
          e.Message);
      End;
    End;

    If Assigned(lFile) Then
    Begin
      lFile.Position := 0;
      Try
        Result := lFile.Read(pHeader, SizeOf(TDSRFileHeader)) > 0;
      Finally
        FreeAndNil(lFile);
      End; {try}
    End; { assigned}
  End; { _FileSize}
End;

{-----------------------------------------------------------------------------
  Procedure: _GetNACKFromFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetNACKFromFile(Var pNack: TNACK; Const pFile: String): Boolean;
Var
  lFile: TFileStream;
Begin
  Result := False;
  lFile := Nil;

  If _FileSize(pFile) > 0 Then
  Begin
    FillChar(pNack, SizeOf(TNACK), 0);

    Try
      lFile := TFileStream.Create(pFile, fmOpenRead, fmShareDenyNone);
    Except
      On e: exception Do
      Begin
        lFile := Nil;
        _LogMSG('_GetNACKFromFile :- Error loading file. Error: ' + e.Message);
      End;
    End;

    If Assigned(lFile) Then
    Begin
      lFile.Position := 0;
      lFile.Seek(SizeOf(TDSRFileHeader), soFromBeginning);
      Try
        Result := lFile.Read(pNack, SizeOf(TNACK)) > 0;
      Finally
        FreeAndNil(lFile);
      End;
    End; { assigned}
  End; { _FileSize}
End;

{-----------------------------------------------------------------------------
  Procedure: _GetACKFromFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetACKFromFile(Var pAck: TACK; Const pFile: String): Boolean;
Var
  lFile: TFileStream;
Begin
  Result := False;
  lFile := Nil;

  If _FileSize(pFile) > 0 Then
  Begin
    FillChar(pAck, SizeOf(TACK), 0);

    Try
      lFile := TFileStream.Create(pFile, fmOpenRead, fmShareDenyNone);
    Except
      On e: exception Do
      Begin
        lFile := Nil;
        _LogMSG('_GetACKFromFile :- Error loading file. Error: ' + e.Message);
      End;
    End;

    If Assigned(lFile) Then
    Begin
      lFile.Position := 0;
      lFile.Seek(SizeOf(TDSRFileHeader), soFromBeginning);
      Try
        Result := lFile.Read(pAck, SizeOf(TACK)) > 0;
      Finally
        FreeAndNil(lFile);
      End;
    End; { assigned}
  End; { _FileSize}
End;

{-----------------------------------------------------------------------------
  Procedure: _GetSyncReqFromFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetSyncReqFromFile(Var pSync: TSyncRequest; Const pFile: String):
  Boolean;
Var
  lFile: TFileStream;
Begin
  Result := False;
  lFile := Nil;

  If _FileSize(pFile) > 0 Then
  Begin
    FillChar(pSync, SizeOf(TSyncRequest), 0);

    Try
      lFile := TFileStream.Create(pFile, fmOpenRead, fmShareDenyNone);
    Except
      On e: exception Do
      Begin
        lFile := Nil;
        _LogMSG('_GetSyncReqFromFile :- Error loading file. Error: ' + e.Message);
      End; {begin}
    End; {try}

    If Assigned(lFile) Then
    Begin
      lFile.Position := 0;
      lFile.Seek(SizeOf(TDSRFileHeader), soFromBeginning);
      Try
        Result := lFile.Read(pSync, SizeOf(TSyncRequest)) > 0;
      Finally
        FreeAndNil(lFile);
      End;
    End; { assigned}
  End; { _FileSize}
End;

{-----------------------------------------------------------------------------
  Procedure: _SetHeaderToFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _SetHeaderToFile(pHeader: TDSRFileHeader; Const pFile: String):
  Boolean;
Var
  lFile: TFileStream;
Begin
  Result := False;
  lFile := Nil;

  If _FileSize(pFile) > 0 Then
  Begin
    Try
      lFile := TFileStream.Create(pFile, fmOpenReadWrite);
    Except
      On e: exception Do
      Begin
        lFile := Nil;
        _LogMSG('_SetHeaderToFile :- Error loading file. Error: ' + e.Message);
      End;
    End;

    If Assigned(lFile) Then
    Begin
      lFile.Position := 0;
      Try
        Result := lFile.Write(pHeader, SizeOf(TDSRFileHeader)) > 0;
      Except
        On e: exception Do
          _LogMSG('_SetHeaderToFile :- Error writing data to file. Error: ' +
            e.Message);
      End;

      FreeAndNil(lFile);
    End; { assigned}
  End { _FileSize}
  Else
    _LogMSG('_SetHeaderToFile :- File does not exist. File: ' + Copy(pFile, 1,
      MAX_PATH));
End;

{-----------------------------------------------------------------------------
  Procedure: _GetXmlFromFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetXmlFromFile(Const pFile: String): WideString;
  Function _GetXml(Const pFileName: String): WideString;
  Var
    lStr: TStringList;
  Begin
    Result := '';
    lStr := TStringList.Create;
    Try
      lStr.LoadFromFile(pFileName);
      Result := lStr.Text;
    Except
    End;

    //FreeAndNil(lStr);
    lStr.Free;
  End; {function}

Var
  lCrc: Longword;
  lAux: String;
  lMemSize: Int64;
  lHeader: TDSRFileHeader;
  lTemp: TMemoryStream;
  lFile: TFileStream;
//  lXml,
  lMemToCalc: Pointer;
  lFileReady: Boolean;
  lRead: Integer;
Begin
  Result := '';

  If _FileSize(pFile) > 0 Then
  Try
    Try
      lFile := TFileStream.Create(pFile, fmOpenRead, fmShareDenyNone);
    Except
      On E: exception Do
      Begin
        _LogMSG('_GetXmlFromFile :- An exception has occurred. Error pos(1): ' +
          e.Message);
        lFile := Nil;
      End; {begin}
    End; {try}

    If Assigned(lFile) Then
    Begin
      {retrieve the dsr header of the file}
      FillChar(lHeader, SizeOf(TDSRFileHeader), 0);
      lRead := 0;
      Try
        lFile.Position := 0;
        lRead := lFile.Read(lHeader, SizeOf(TDSRFileHeader));
      Except
        On E: exception Do
          _LogMSG('_GetXmlFromFile :- An exception has occurred. Error pos(2): '
            + e.Message);
      End;

      { the batch is ok and it is not a splitted file}
      If (lRead > 0) And (Trim(lHeader.BatchId) <> '') And
        (lHeader.Split = 0) And (lHeader.Mode In [Ord(rmNormal), Ord(rmSync),
        Ord(rmBulk), Ord(rmDripFeed)]) Then
      Begin
        lMemSize := lFile.Size - SizeOf(TDSRFileHeader);

        If lMemSize > 0 Then
        Begin
          //lXml := AllocMem(lMemSize);

          Try
            Try
              lFile.Position := 0;
              {load the xml into the temp memory}
              lFile.Seek(SizeOf(TDSRFileHeader), soFromBeginning);
              //lFile.Read(lXml^, lMemSize);

              lTemp := TMemoryStream.Create;
              //lTemp.Write(lXml^, lMemSize);
              lTemp.CopyFrom(lFile, lMemSize);
            Except
              On e: exception Do
              Begin
                _LogMSG('_GetXmlFromFile :- Error reading temp XML. Error pos(3): '
                  + e.message);
                If Assigned(lTemp) Then
                  FreeAndNil(lTemp);
              End; {begin}
            End; {try}
          Finally
            If assigned(lFile) Then
              FreeAndNil(lFile);
            //FreeMem(lXml);
          End;
        End; {If lMemSize > 0 Then}

        { create a temp file to check the crc and decrypt and decompress after}
        If (lTemp <> Nil) And (lTemp.Size > 0) Then
        Begin
          lTemp.Position := 0;
          lMemSize := lTemp.Size;
          lCRC := 0;

          {check the crc of the message}
          //lMemToCalc := AllocMem(lMemSize);
          GetMem(lMemToCalc, lMemSize);
          Try
            {leave the memorystream untouched}
            //CopyMemory(lMemToCalc, lTemp.Memory, lMemSize);
            Move(lTemp.Memory^, lMemToCalc^, lMemSize);

            Try
              _CalcCRC32(lMemToCalc, lMemSize, lCrc);
            Except
              On e: exception Do
                _LogMSG('_GetXmlFromFile :- Error calcCRC32. Error pos(4): ' +
                  e.Message);
            End;
          Finally
            FreeMem(lMemToCalc);
          End;

            {file header and the checksum for the xml are the same}
          If lHeader.CheckSum = lCrc Then
          Begin
            lAux := ExtractFilePath(pFile) + _CreateGuidStr;

            Try
              lTemp.SaveToFile(lAux);
            Except
              On E: exception Do
                _LogMSG('_GetXmlFromFile :- An exception has occurred. Error pos(5): '
                  + e.Message);
            End; {try}

            FreeAndNil(lTemp);
            lFileReady := False;

           { get the xml only }
            If _FileSize(lAux) > 0 Then
            Begin
              Try
                lFileReady := _DecryptAndDecompress(lAux);
              Except
                On E: exception Do
                Begin
                  lFileReady := False;
                  _LogMSG('_GetXmlFromFile :- Error DecryptAndDecompress. Error pos(6): '
                    + e.Message);
                End; {begin}
              End; {try}
            End
            Else
              _LogMSG('_GetXmlFromFile :- Error saving encrypted file...');

              {if something wrong happened, try to load as a xml}
            If Not lFileReady Then
            Try
              lFileReady := _IsValidXml(lAux);
            Except
              On E: exception Do
              Begin
                _LogMSG('_GetXmlFromFile :- Error _IsValidXml. Error pos(7): ' +
                  e.Message);
                lFileReady := False;
              End; {begin}
            End; {Try}

            If lFileReady Then
              Result := _GetXml(lAux);

            _DelFile(lAux);
          End; {If lHeader.CheckSum = lCrc }
        End; {if lTemp.size > 0}

        If Assigned(lTemp) Then
          FreeAndNil(lTemp);
      End {(lHeader.Guid <> '') and (lHeader.Split = 0)}
      Else
      Begin
        If Assigned(lFile) Then
          FreeAndNil(lFile);

        {try loading the xml in this worst scenario}
        Result := '';
        Try
          If _IsValidXml(pFile) Then
            Result := _GetXml(pFile);
        Except
          On E: exception Do
            _LogMSG('_GetXmlFromFile :- An exception has occurred. Error pos(8): '
              + e.Message);
        End; {try}
      End; {begin}
    End; // assigned
  Except
    On E: exception Do
      _LogMSG('_GetXmlFromFile :- An exception has occurred processing file ' + pFile
        + '. Error pos(9): ' + e.Message);
  End; // _FileSize

  If Assigned(lFile) Then
    FreeAndNil(lFile);

  If Result = '' Then
    If Not _ValidExtension(pFile) Then {check for a valid dsr file}
      _LogMSG('_GetXmlFromFile :- The file ' + pFile + ' is not valid...');
End;

{-----------------------------------------------------------------------------
  Procedure: _SplitFile
  Author:    vmoura

  get a file bigger than Mbyte and split it
  the result will be a string of files as stringlist.commatext
-----------------------------------------------------------------------------}
Function _SplitFile(Const pFileName: String): String;
Var
  lFiles: TStringlist;
  i: Word;
  fs, sStream: TFileStream;
  SplitFileName: String;
  lHeader: TDSRFileHeader;
  lSplitSize: Int64;
  lFileSize: Int64;
  lBuffer: pChar;
Begin
  lFiles := TStringlist.Create;
  fs := TFileStream.Create(pFileName, fmOpenRead Or fmShareDenyWrite);
  FillChar(lHeader, SizeOf(TDSRFileHeader), 0);
  fs.Position := 0;
  // read the dsr header
  fs.Read(lHeader, SizeOf(TDSRFileHeader));
  lSplitSize := MBYTE;
  // the original size of the file
  lFileSize := fs.Size - SizeOf(TDSRFileHeader);
  // write the number of split into the header
  lHeader.SplitTotal := Trunc(lFileSize / lSplitSize) + 1;

  Try
    For i := 1 To Trunc(lFileSize / lSplitSize) + 1 Do
    Begin
      lHeader.SplitCheckSum := 0;
      // split number
      lHeader.Split := i;
      SplitFileName := ChangeFileExt(pFileName, '.' + FormatFloat('000', i));

      // create the nil file
      sStream := TFileStream.Create(SplitFileName, fmCreate Or
        fmShareExclusive);

      If lFileSize - fs.Position < lSplitSize Then
        lSplitSize := (lFileSize + SizeOf(TDSRFileHeader)) - fs.Position;

        // get the split buffer from the main file
      GetMem(lBuffer, lSplitSize);

      Try
        fs.Read(lBuffer^, lSplitSize);
        // calc the checksum for this buffer
        _CalcCRC32(lBuffer, lSplitSize, lHeader.SplitCheckSum);
        sStream.Write(lHeader, SizeOf(TDSRFILEHEADER));

        sStream.Write(lBuffer^, lSplitSize);
      Finally
        FreeAndNil(sStream);
        FreeMem(lBuffer);
        // add the new file to the list
        If _FileSize(SplitFileName) > 0 Then
          lFiles.Add(SplitFileName)
        Else
           // Always clear if something gets wrong
          lFiles.Clear;
      End; // try
    End; // for
  Finally
    FreeAndNil(fs);

    If lFiles.Count > 0 Then
      Result := lFiles.CommaText;

    FreeAndNil(lFiles);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: _CombineFiles
  Author:    vmoura

  1) Search for a file according to a given name
  2) get the header
  3) look for split files
  4) start to rebuild the original file
      if all files are there, the check sum will confirm whether those files are ok
-----------------------------------------------------------------------------}
Function _CombineFiles(Const pFileName: String; Const pResultFile: String):
  Boolean;
Var
  lCrc: Longword;
  lMem: pChar;
  SearchRec: TSearchRec;
  lMainHeader,
    lHeader: TDSRFileHeader;
  lBuffer: TMemoryStream;
  sStream: TFileStream;
  lRes: Integer;
  lDir,
    lFile: String;
  lCont,
    lTotalFiles,
    lMemSize: Integer;
Begin
  Result := False;

  // create the memory buffer
  lBuffer := TMemoryStream.Create;
  FillChar(lMainHeader, SizeOf(TDSRFileHeader), 0);
  lDir := ExtractFilePath(pFileName);
  lFile := Copy(pFileName, 1, Pos(ExtractFileExt(pFileName), pFileName) - 1) +
    '.*';
  lRes := FindFirst(lFile, faAnyFile, SearchRec);
  lTotalFiles := 0;
  // first get the first header of the initial file
  If lRes = 0 Then
  Begin
    lCrc := 0;
     // load the first file
    Try
      sStream := TFileStream.Create(lDir + SearchRec.Name, fmOpenRead Or
        fmShareDenyWrite);
      sStream.Position := 0;
    // load the first header found to get the right information
      sStream.Read(lMainHeader, SizeOf(TDSRFileHeader));
      lMemSize := sStream.Size - SizeOf(TDSRFileHeader);
      GetMem(lMem, lMemSize);
      sStream.Read(lMem^, lMemSize);
      _CalcCRC32(lMem, lMemSize, lCrc);
      FreeMem(lMem);
    Finally
      If Assigned(sStream) Then
        FreeAndNil(sStream);
    End;

    // check the first split check sum against the buffer
    If lMainHeader.SplitCheckSum = lCrc Then
    Begin
      { this will be the original file, so, i can remove
        split values and checksum
      }
      lTotalFiles := lMainHeader.SplitTotal;
      lMainHeader.Split := 0;
      lMainHeader.SplitCheckSum := 0;
      lMainHeader.SplitTotal := 0;
      { starting to join the original file using the main header as a guid
      the reason to get all files again is to avoid to work with buffer positions.
      }
      lBuffer.Write(lMainHeader, SizeOf(TDSRFileHeader));
      If lTotalFiles > 0 Then
      Begin
        // get the total splitted files to load them in a right order...
        For lCont := 1 To lTotalFiles Do
        Begin
          lFile := Copy(pFileName, 1, Pos(ExtractFileExt(pFileName), pFileName)
            - 1) + '.' + FormatFloat('000', lCont);

          If _FileSize(lFile) > 0 Then
          Begin
            FillChar(lHeader, SizeOf(TDSRFileHeader), 0);
            Try
              sStream := TFileStream.Create(lFile, fmOpenRead Or
                fmShareDenyWrite);
              sStream.Position := 0;
              lMemSize := sStream.Size - SizeOf(TDSRFileHeader);
              sStream.Read(lHeader, SizeOf(TDSRFileHeader));

            // check the file params and if these splits belong to the same file
              If (Lowercase(lHeader.Version) = Lowercase(lMainHeader.Version))
                And (lHeader.Order = lMainHeader.Order) And
                (Lowercase(lHeader.BatchId) = Lowercase(lMainHeader.BatchId))
                And (lHeader.Split > 0) And (lheader.SplitTotal > 0) Then
              Begin
                lCrc := 0;
                GetMem(lMem, lMemSize);
                sStream.Read(lMem^, lMemSize);
                _CalcCRC32(lMem, lMemSize, lCrc);

                If lHeader.SplitCheckSum = lCrc Then
                Begin
                  lRes := 0;
                  lBuffer.Write(lMem^, lMemSize);
                End
                Else
                Begin
                  lRes := 1;
                  Break;
                End;

                FreeMem(lMem);
              End; {all checks against the main header}
            Finally
              If Assigned(sStream) Then
                FreeAndNil(sStream);
            End; {try ... finally}
          End
          Else
          Begin
            lRes := 1;
            Break;
          End; {If _FileSize(lFile) > 0 Then}
        End; {For lCont := 1 To lTotalFiles Do}
      End; {lTotalFiles > 0}
    End {lMainHeader.SplitCheckSum = lCrc}
    Else
      lRes := 1;
  End; {lRes = 0}

  // if everything is ok, i still have to check the original checksum file
  If lRes = 0 Then
  Begin
    // the lCrc must be clear everytime i have to use it
    lCrc := 0;
    // put the buffer position on the beginning of the file
    lBuffer.Seek(SizeOf(TDSRFileHeader), soFromBeginning);
    lMemSize := lBuffer.size - SizeOf(TDSRFileHeader);
    GetMem(lMem, lMemSize);
    lBuffer.Read(lMem^, lMemSize);
    _CalcCRC32(lMem, lMemSize, lCrc);
    // if the original file is ok
    If lMainHeader.CheckSum = lCrc Then
    Try
      lBuffer.SaveToFile(pResultFile);
    Finally
      // delete all the splitted files
      If _FileSize(pResultFile) > 0 Then
      Begin
        Result := True;
        If lTotalFiles > 0 Then
        Begin
          // get the total splitted files to load them in a right order...
          For lCont := 1 To lTotalFiles Do
          Begin
            lFile := Copy(pFileName, 1, Pos(ExtractFileExt(pFileName), pFileName)
              - 1) + '.' + FormatFloat('000', lCont);
            _DelFile(lFile);
          End; {For}
        End; {If lTotalFiles > 0 Then}
      End; {_FileSize(FileName)}
    End; {finally}

    FreeMem(lMem);
  End;

  Sysutils.FindClose(SearchRec);
  FreeAndNil(lBuffer);
End;

{-----------------------------------------------------------------------------
  Procedure: _CheckFileComplete
  Author:    vmoura

  get the check sum of the main file and try to verify if that is ok
-----------------------------------------------------------------------------}
Function _CheckFileComplete(pHeader: TDSRFileHeader; Const pFileName: String):
  Boolean;
Var
  lMemory: TMemoryStream;
  lCrc: Longword;
  lMem: pChar;
  lMemSize: Integer;
Begin
  lCrc := 0;
  lMemory := TMemoryStream.Create;
  Try
    lMemory.LoadFromFile(pFileName);
    lMemSize := lMemory.size - SizeOf(TDSRFileHeader);
    GetMem(lMem, lMemSize);
    lMemory.Seek(SizeOf(TDSRFileHeader), soFromBeginning);
    lMemory.Read(lMem^, lMemSize);
    _CalcCRC32(lMem, lMemSize, lCrc);
    FreeMem(lMem);
  Finally
    If Assigned(lMemory) Then
      FreeAndNil(lMemory);
  End; {try}

  Result := pHeader.CheckSum = lCrc;
End;

{-----------------------------------------------------------------------------
  Procedure: _CheckBatchComplete
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CheckBatchComplete(pHeader: TDSRFileHeader; Const pPath: String):
  Boolean;
Var
  lCont: Integer;
  lFile: String;
Begin
  Result := True;
  For lCont := 1 To pHeader.Total Do
  Begin
    {look up for files of that batch}
    lFile := IncludeTrailingPathDelimiter(pPath) + inttostr(lCont) + cXmlExt;
    // whether there is a file missing, the batch is not completed yet
    If Not (_FileSize(lFile) > 0) Then
    Begin
      Result := False;
      Break;
    End; {If Not (_FileSize('') > 0) Then}
  End; {For lCont := 1 To pHeader.Total Do}
End;

{-----------------------------------------------------------------------------
  Procedure: _CheckBatchCompleteEx
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CheckBatchCompleteEx(pHeader: TDSRFileHeader; Const pPath: String):
  Boolean;
Var
  lCont: Integer;
  lFile: String;
  lDSRHeader: TDSRFileHeader;
Begin
  Result := True;
  For lCont := 1 To pHeader.Total Do
  Begin
    {look up for files of that batch}
    lFile := IncludeTrailingPathDelimiter(pPath) + inttostr(lCont) + cXmlExt;
    FillChar(lDSRHeader, SizeOf(TDSRFileHeader), 0);
    _GetHeaderFromFile(lDSRHeader, lFile);

    {// whether there is a file missing and the crc of the file is not completed}
    If Not ((_FileSize(lFile) > 0) And _CheckFileComplete(lDSRHeader, lFile)) Then
    Begin
      Result := False;
      Break;
    End; {If Not (_FileSize('') > 0) Then}
  End; {For lCont := 1 To pHeader.Total Do}
End;

{-----------------------------------------------------------------------------
  Procedure: _CheckBatchCompleteEx
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CheckBatchCompleteEx(pFile: TStringList): Boolean;
Var
  lCont: Integer;
  lFile: String;
  lDSRHeader: TDSRFileHeader;
Begin
  Result := True;
  If Assigned(pFile) Then
  Begin
    For lCont := 0 To pFile.Count - 1 Do
    Begin
    {look up for files of that batch}
      lFile := pFile[lCont];
      FillChar(lDSRHeader, SizeOf(TDSRFileHeader), 0);
      _GetHeaderFromFile(lDSRHeader, lFile);
    // whether there is a file missing and the crc of the file is not completed
      If Not ((_FileSize(lFile) > 0) And _CheckFileComplete(lDSRHeader, lFile)) Then
      Begin
        Result := False;
        Break;
      End; {If Not (_FileSize('') > 0) Then}
    End; {For lCont := 1 To pHeader.Total Do}
  End
  Else
    Result := False;
End;

{-----------------------------------------------------------------------------
  Procedure: _FindMissingOrder
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _FindMissingOrder(pHeader: TDSRFileHeader; Const pPath: String):
  Longword;
Var
  lCont: Integer;
  lFile: String;
Begin
  Result := 0;
  For lCont := 1 To pHeader.Total Do
  Begin
    {look up for files of that batch}
    lFile := IncludeTrailingPathDelimiter(pPath) + inttostr(lCont) + cXmlExt;
    // whether there is a file missing, the batch is no completed yet
    If Not (_FileSize(lFile) > 0) Then
    Begin
      Result := lCont;
      Break;
    End; {If Not (_FileSize('') > 0) Then}
  End; {For lCont := 1 To pHeader.Total Do}
End;

{-----------------------------------------------------------------------------
  Procedure: _GetFileByOrder
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetFileByOrder(Const pPath: String; pOrder: Longword; Const
  pReturnFirst: Boolean = False): String;
Const
  cMISSINGCOUNT = 200;
Var
  lRes: Integer;
  lDSRHEader: TDSRFileHeader;
  SearchRec: TSearchRec;
  lFiles: TStringList;
  lPath: String;
  lCont: integer;
Begin
  Result := '';
  lFiles := TStringList.Create;
  lPath := IncludeTrailingPathDelimiter(pPath);
  lRes := FindFirst(IncludeTrailingPathDelimiter(pPath) + '*.*', faAnyFile,
    SearchRec);

(*  While lRes = 0 Do
  Begin
    {load the header of the file}
    FillChar(lDSRHEader, SizeOF(TDSRFileHeader), #0);
    If _GetHeaderFromFile(lDSRHEader, lPath + SearchRec.Name) Then
      If lDSRHEader.Order >= pOrder Then {check if this file is the first one to be added to the send list}
      Begin
        lFiles.Add(lPath + SearchRec.Name);
        Inc(lFileCount);

        If (lFileCount >= cMISSINGCOUNT) Or pReturnFirst Then
          Break;

        Inc(lOrder); {get the next file}
        if lOrder > lDSRHEader.Total then
          Break;
      End; {If lDSRHEader.Order = pOrder Then}

    lRes := FindNext(SearchRec);
  End; {While lRes = 0 Do}

  Sysutils.FindClose(SearchRec);*)

  {load all files to the string list first}
  While lRes = 0 Do
  Begin
    If (SearchRec.Name <> '.') And (SearchRec.Name <> '..') And
      (lowercase(SearchRec.Name) <> lowercase(cDSRLOCKFILE)) Then
      lFiles.Add(lPath + SearchRec.Name);

    lRes := FindNext(SearchRec);
  End; {While lRes = 0 Do}

  Sysutils.FindClose(SearchRec);
  {search for files that match the search criteria}
  For lCont := lFiles.Count - 1 Downto 0 Do
  Begin
    FillChar(lDSRHEader, SizeOF(TDSRFileHeader), 0);
    If _GetHeaderFromFile(lDSRHEader, lFiles[lCont]) Then
      If (lDSRHEader.Order < pOrder) Or (lDSRHEader.Order > (pOrder + cMISSINGCOUNT))
        Then
        lFiles.Delete(lCont);
  End; {For lCont := lFiles.Count - 1 Downto 0 Do}

  If lFiles.Count > 0 Then
    Result := lFiles.CommaText;

  FreeAndNil(lFiles);
End;

End.

