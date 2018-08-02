{-----------------------------------------------------------------------------
 Unit Name: uCompression
 Author:    vmoura
 Purpose:

 Compress and Decompress files using the ZLIB component
-----------------------------------------------------------------------------}

Unit uCompression;

Interface

Uses
  uConsts;

Type
  TCompression = Class
  Private
    Class Function DoCompressionFile(pOption: TFileOptions; Const pFileIn:
      String; Const pFileOut: String = ''): Boolean; Virtual;
  Public
    Class Function Compress(Const pFileIn: String; Const pFileOut: String = ''):
      Boolean; Virtual;
    Class Function DeCompress(Const pFileIn: String; Const pFileOut: String =
      ''): Boolean; Virtual;
  End;

Implementation

uses Windows, Classes, Sysutils,
   uCommon,
   zLib 
   ;

{ TCompression }

{-----------------------------------------------------------------------------
  Procedure: Compress
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TCompression.Compress(Const pFileIn: String; Const pFileOut:
  String = ''): Boolean;
Begin
  Result := DoCompressionFile([soDoCompress], pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: DeCompress
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TCompression.DeCompress(Const pFileIn: String; Const pFileOut:
  String = ''): Boolean;
Begin
  Result := DoCompressionFile([soDoDecompress], pFileIn, pFileOut);
End;

{-----------------------------------------------------------------------------
  Procedure: DoCompressionFile
  Author:    vmoura

  general function to compress and decompress files
  using zlib class

-----------------------------------------------------------------------------}
Class Function TCompression.DoCompressionFile(pOption: TFileOptions; Const
  pFileIn, pFileOut: String): Boolean;
Var
  lInMem: TMemoryStream;
  lOutMem: TFileStream;
  lPtr: Pointer;
  lOutBytes: Integer;
  lFileOut: String;
  lCompress: TCompressionStream;
Begin
  // initializate variables...
  Result := False;

  lPtr := Nil;
  lInMem := Nil;
  lOutMem := Nil;
  lCompress := Nil;

  { test if pFilein and pFileout are diferent}
  If pFileOut <> '' Then
  Begin
    If _FileSize(pFileout) > 0 Then
      _DelFile(pFileout);
    lFileOut := pFileOut;
  End
  Else { if they are equal, create a temp file}
    lFileOut := ExtractFilePath(pFileIn) + _CreateGuidStr + ExtractFileExt(pFileIn);

  Try
    // create and load streans to load the requested file
    lInMem := TMemoryStream.Create;
    lOutMem := TFileStream.Create(lFileOut, fmCreate);
    lOutMem.Position := 0;
    
    lInMem.LoadFromFile(pFileIn);
    lInMem.Position := 0;

    If soDoDecompress In pOption Then
    Begin // if decompress, decompress it to a buffer and save
      Try
        DecompressBuf(lInMem.Memory, lInMem.Size, 0, lPtr, lOutBytes);
      Except
        lOutBytes := 0;
        lPtr := Nil;
      End; {try}

      // i will only write something if i didnt get any exception above...
      If lOutBytes > 0 Then
        lOutMem.Write(lPtr^, lOutBytes);
    End
    Else If soDoCompress In pOption Then
    Begin // if compress, just save it...
      lCompress := TCompressionStream.Create(clDefault, lOutMem);

      Try
        lInMem.SaveToStream(lCompress);
      Except
        {$IFDEF DEBUG}
         on e:exception do
           _LogMSG('TCompression.DoCompressionFile :- Error compressing file. Error: ' + e.Message);
        {$ENDIF}
      End;
    End;
  Finally
    Try
      If Assigned(lPtr) Then
        FreeMem(lPtr);
    Except
      lPtr := Nil;
    End;

    If Assigned(lInMem) Then
      FreeAndNil(lInMem);

    If Assigned(lCompress) Then // i need first release the compress stuff
      FreeAndNil(lCompress);

    If Assigned(lOutMem) Then
      FreeAndNil(lOutMem);

    // teste the output file
    If _FileSize(lFileOut) > 0 Then
    Begin

      If pFileOut = '' Then // only one file
      Begin
        If CopyFile(pchar(lfileOut), pChar(pFileIn), False) Then
        Begin // try to copy to same name
          _DelFile(lFileOut);
          Result := True;
        End // copy file
        Else If _DelFile(pFileIn) Then
          // if somethig happens, try delete and just rename the file name
          If RenameFile(lFileOut, pFileIn) Then
            Result := True;
      End
      Else
        Result := True;
    End
    Else If _FileSize(lFileOut) > 0 Then // remove garbage is something gets wrong
      _DelFile(lFileOut)
  End;
End;

End.

