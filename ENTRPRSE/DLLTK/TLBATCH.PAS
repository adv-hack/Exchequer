unit TLBatch;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Dialogs, SysUtils, GlobVar, VarConst, VarCnst3;

{$IFNDEF WIN32}
  This section has been deliberately added to stop this module
  being compiled into the 16-bit Toolkit DLL.
{$ENDIF}


Function EX_INITSTRUCTURE (Var Struct : Pointer; Const StructSize : LongInt) : SmallInt; StdCall; Export;

Function  EX_CREATETLARRAY  (Const MaxLines : LongInt; Var TLArrayInfo : TLArrayInfoType) : SMALLINT; StdCall; Export;
Function  EX_ADDTLARRAYLINE (Var TLArrayInfo : TLArrayInfoType; Const TL : TBatchTLRec) : SMALLINT; StdCall; Export;
Procedure EX_DESTROYTLARRAY (Const TLArrayInfo : TLArrayInfoType); StdCall; Export;

Function EX_GETTLARRAY (    P           : Pointer;         // Transaction Header
                            PSize       : LongInt;         // SizeOf (P)
                        Var TLArrayInfo : TLArrayInfoType; // Array Info Record
                            SearchKey   : PChar;
                            SearchPath  : SmallInt;
                            SearchMode  : SmallInt;
                            Lock        : WordBool) : SmallInt; StdCall; Export;

Function EX_GETTLARRAYLINE(Const TLArrayInfo  : TLArrayInfoType;
                                 PTL          : Pointer;         // Transaction Line - TBatchTLRec
                                 PTLSize      : LongInt;         // SizeOf (PTL)
                                 LineNo       : LongInt) : SmallInt; StdCall; Export;

Function EX_EDITTLARRAYLINE(Var   TLArrayInfo : TLArrayInfoType;
                            Const TL          : TBatchTLRec;
                            Const ArrayLineNo : longint) : SMALLINT; StdCall; Export;

implementation

Uses DllTH_UP, DLLerrU;

Function EX_INITSTRUCTURE (Var Struct : Pointer; Const StructSize : LongInt) : SmallInt;
Begin { Ex_InitStructure }
  LastErDesc:='';

  Result := 0;

  Try
    FillChar (Struct, StructSize, #0);
  Except
    On Exception Do Result := 1;
  End;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(206,Result);

End; { Ex_InitStructure }

{----------------------------------------------------------------------------}

// 1000        Error: Too many lines requested
// 1001        Error: Miscellaneous Exception
// 1002        Error: Out of Memory
Function EX_CREATETLARRAY (Const MaxLines : LongInt; Var TLArrayInfo : TLArrayInfoType) : SMALLINT;
Begin { Ex_CreateTLArray }
  LastErDesc:='';
  Result := 0;

  Try
    FillChar (TLArrayInfo, SizeOf (TLArrayInfo), #0);
    With TLArrayInfo Do Begin
      If (MaxLines > 0) And (MaxLines <= 10000) Then Begin
        NumTL    := 0;                            // Number of lines added into array
        UsedSize := 0;                            // Total Memory used by added lines
        MaxTL    := MaxLines;                     // Maximum number of lines that can be stored
        TLSize   := SizeOf(TBatchTLRec) * MaxTL;  // Total memory allocated for TLArray

        GetMem (TLArray, TLSize);
      End { If }
      Else Begin
        { Error: Too many lines requested }
        Result := 1000;
      End; { Else }
    End; { With }
  Except
    On EOutOfMemory Do
      Result := 1002;

    On Exception Do
      Result := 1001;
  End;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(207,Result);

End; { Ex_CreateTLArray }


{-----------------------------------------------------------------------------}

// 1000             Error: Array is full
// 1001             Error: Array not setup
// 1002             Error: Exception
Function EX_ADDTLARRAYLINE (Var TLArrayInfo : TLArrayInfoType; Const TL : TBatchTLRec) : SMALLINT;
Var
  DummyTL : ^TBatchTLRec;
Begin { Ex_AddTLArrayLine }
  LastErDesc:='';
  Result := 0;

  Try
    With TLArrayInfo Do Begin
      // Check Array has been allocated
      If Assigned(TLArray) Then Begin
        // Check some items are free
        If (MaxTL > 0) And (NumTL < MaxTL) Then Begin
          { Copy record into the array at the correct position }
          DummyTL := POINTER(LONGINT(TLArray) + UsedSize);
          DummyTL^ := TL;

          { Increase number of records }
          UsedSize := UsedSize + SizeOf(TBatchTLRec);
          Inc (NumTL)
        End { If }
        Else Begin
          { Error: Array is full }
          Result := 1000;
        End; { Else }
      End { If }
      Else Begin
        { Error: Array not setup }
        Result := 1001;
      End; { Else }
    End; { With TLBatch }
  Except
    On Exception Do
      Result := 1002;
  End;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(208,Result);

End; { Ex_AddTLArrayLine }

{-----------------------------------------------------------------------------}

function EX_EDITTLARRAYLINE(var   TLArrayInfo : TLArrayInfoType;
                            const TL          : TBatchTLRec;
                            const ArrayLineNo : longint) : SMALLINT;
// Post : Return values - 0    OK
//                        1000 Array not setup
//                        1001 Index out of bounds
//                        1002 Generic exception
var
  ArrayElement : ^TBatchTLRec;
begin
  LastErDesc:='';

  Result := 0;
  with TLArrayInfo do
  try
    if not Assigned(TLArray) then
      Result := 1000;
    if (Result = 0) and ((ArrayLineNo <= 0) or (ArrayLineNo > NumTL)) then
      Result := 1001;

    if Result = 0 then
    begin
      ArrayElement := pointer(longint(TLArray) + (Sizeof(TBatchTLRec) * (ArrayLineNo -1)));
      ArrayElement^ := TL;
    end;
  except
    on Exception do
      Result := 1003;
  end;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(212,Result);

end;

{-----------------------------------------------------------------------------}

Procedure EX_DESTROYTLARRAY (Const TLArrayInfo : TLArrayInfoType);
Begin { Ex_DestroyTLArray }

  LasterDesc:='';

  Try
    If Assigned(TLArrayInfo.TLArray) Then
      FreeMem (TLArrayInfo.TLArray, TLArrayInfo.TLSize);
  Except
    { Error during Ex_DestroyTLArray }
    On Ex:Exception Do
      MessageDlg ('The following error occurred in Ex_DestroyTLArray: ' + #13#13 +
                  Ex.Message, mtError, [mbOk], 0);
  End;
End; { Ex_DestroyTLArray }


{-----------------------------------------------------------------------------}

// 1000             Error: Unknown Exception
// 1001             Error: Array not setup
Function EX_GETTLARRAY (    P           : Pointer;         // Transaction Header
                            PSize       : LongInt;         // SizeOf (P)
                        Var TLArrayInfo : TLArrayInfoType; // Array Info Record
                            SearchKey   : PChar;
                            SearchPath  : SmallInt;
                            SearchMode  : SmallInt;
                            Lock        : WordBool) : SmallInt;
Var
  TH : ^TBatchTHRec;
Begin { EX_GETTLARRAY }
  LastErDesc:='';
  Result := 0;

  Try
    With TLArrayInfo Do Begin
      // Check Array has been allocated
      If Assigned(TLArray) Then Begin
        // Check space was allocated
        If (MaxTL > 0) Then Begin
          // Re-initialise data section
          FillChar (TLArray^, TLSize, #0);
          NumTL := 0;
          UsedSize := 0;

          { Call standard EX_GETTRANS function passing the TL Array instead of a TBatchLinesRec }
          Result := EX_GETTRANS(P,
                                TLArray,
                                PSize,
                                TLSize,
                                SearchKey,
                                SearchPath,
                                SearchMode,
                                Lock);

          TH := P;
          NumTL := TH.LineCount;
          UsedSize := TH.LineCount * SizeOf (TBatchTLRec);
        End { If (MaxTL > 0) }
        Else
          Result := 1001;
      End { If Assigned(TLArray) }
      Else
        Result := 1001;
    End; { With TLArrayInfo }
  Except
    On Exception Do
      Result := 1000;
  End;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(210,Result);

End; { EX_GETTLARRAY }


{-----------------------------------------------------------------------------}


// 1000             Error: Unknown Exception
// 1001             Error: Array not setup
// 1002             Invalid Line Number
// 1003             Invalid PTL/PTLSize parameter
Function EX_GETTLARRAYLINE(Const TLArrayInfo : TLArrayInfoType;
                                 PTL         : Pointer;         // Transaction Line - TBatchTLRec
                                 PTLSize     : LongInt;         // SizeOf (PTL)
                                 LineNo      : LongInt) : SmallInt;
Var
  pArrayTL : ^TBatchTLRec;
  RecPos   : LongInt;
Begin { EX_GETTLARRAYLINE }
  LastErDesc:='';

  Result := 0;

  Try
    With TLArrayInfo Do Begin
      // Check PTL is valid
      If Assigned(PTL) And (PTLSize = SizeOf(TBatchTLRec)) Then Begin
        // Check Array has been allocated
        If Assigned(TLArray) Then Begin
          // Check space was allocated
          If (MaxTL > 0) Then Begin
            // Check we have enough records
            If (NumTL >= LineNo) Then Begin
              { Calculate position of desired record }
              RecPos := SizeOf(TBatchTLRec) * Pred(LineNo);

              { Check position is within allocated structure }
              If (RecPos < UsedSize) And (RecPos < TLSize) Then Begin
                { AOK - Return record }
                pArrayTL := POINTER(LONGINT(TLARRAY) + RecPos);
                Move (pArrayTL^, PTL^, PTLSize);
              End { If (RecPos < UsedSize) And (RecPos < TLSize) }
              Else
                { Line doesn't exist }
                Result := 1002;
            End { If (NumTL >= LineNo) }
            Else
              { Invalid Line Number }
              Result := 1002;
          End { If (MaxTL > 0) }
          Else
            Result := 1001;
        End { If Assigned(TLArray) }
        Else
          Result := 1001;
      End { If Assigned(PTL) And (PTLSize = SizeOf(TBatchTLRec)) }
      Else
        Result := 1003;
    End; { With TLArrayInfo }
  Except
    On Exception Do
      Result := 1000;
  End;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(211,Result);

End; { EX_GETTLARRAYLINE }

end.

