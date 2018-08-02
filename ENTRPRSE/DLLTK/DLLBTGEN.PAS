unit DLLBTGen;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

// Generic Btrieve routines

interface

FUNCTION EX_BTRIEVEFINDREC(P      : POINTER;
                           PSIZE  : LONGINT) : SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF}
                           EXPORT;

FUNCTION EX_BTRIEVEGETPOS(FILENUM       : SMALLINT;
                         VAR POSITION   : LONGINT) : SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
                         EXPORT;


FUNCTION EX_BTRIEVESETPOS(FILENUM    : SMALLINT;
                          POSITION   : LONGINT;
                          SEARCHPATH : SMALLINT) : SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF}
                          EXPORT;

FUNCTION EX_BTRIEVERECCOUNT(FILENUM  : SMALLINT;
                            VAR RECCOUNT : LONGINT) : SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF}
                           EXPORT;

implementation

uses
  GlobVar, Dialogs, SysUtils, BtrvU2, VarConst, DLLErrU;

type
  {$I ExDLLBG.INC }

const
  CRLF = #13#10;


FUNCTION EX_BTRIEVEFINDREC(P      : POINTER;
                           PSIZE  : LONGINT) : SMALLINT;
var

  KeyS : string[255];
  MaxSize : integer;

  function CheckOK(var ErrorCode: smallint) : boolean;
  begin
    Result := true;
    if not Assigned(P) then
    begin
      ErrorCode := 32767;
      Result := false;
  end
  else
    if PSize <> SizeOf(TBtrieveFindRec) then
    begin
      ErrorCode := 32766;
      Result := false;
    end;
  end;

  procedure ShowTestMessage;
  begin
    with TBtrieveFindRec(P^) do
      ShowMessage ('Ex_BtrieveFindRec:' + CRLF +
                   'P^.FileNum: ' + IntToStr(FileNum) + CRLF +
                   'P^.SearchKey: ' + SearchKey + CRLF +
                   'P^.SearchPath: ' + IntToStr(SearchPath) + CRLF +
                   'P^.SearchMode: ' + IntToStr(SearchMode));
  end;

begin // EX_BTRIEVEFINDREC
{  Closed on 10.10.2000
  if not CheckOK(Result) then
    exit;
}
  LastErDesc:='';
  Result:=0;

  if CheckOK(Result) then
  begin

    if TestMode then
      ShowTestMessage;

    with TBtrieveFindRec(P^) do
    begin
      KeyS := SearchKey;
      Result := Find_Rec(SearchMode, F[FileNum], FileNum, RecPtr[FileNum]^, SearchPath, KeyS);
      SearchKey := KeyS;
      if Result = 0 then
      begin
        FillChar(RecordInfo, SizeOf(RecordInfo),#0);
        MaxSize := SizeOf(RecordInfo);
        if FileRecLen[FileNum] < MaxSize then
          MaxSize := FileRecLen[FileNum];
        move(RecPtr[FileNum]^, RecordInfo, MaxSize);
      end;
    end;

  end; {if Check ..}

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(101,Result);

end; // EX_BTRIEVEFINDREC

//-----------------------------------------------------------------------

FUNCTION EX_BTRIEVEGETPOS(FILENUM       : SMALLINT;
                          VAR POSITION   : LONGINT) : SMALLINT;
// Post : Position = Current Btrieve file position
begin
  LastErDesc:='';

  if TestMode then
    ShowMessage('Ex_BtrieveGetPos:' + CRLF +
                'FileNum: ' + IntToStr(FileNum));
  Result := GetPos(F[FileNum], FileNum, Position);

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(102,Result);

end; // EX_BTRIEVEGETPOS

//-----------------------------------------------------------------------

FUNCTION EX_BTRIEVESETPOS(FILENUM    : SMALLINT;
                          POSITION   : LONGINT;
                          SEARCHPATH : SMALLINT) : SMALLINT;
begin // EX_BTRIEVESETPOS

  LastErDesc:='';

  if TestMode then
    ShowMessage('Ex_BtrieveSetPos: ' + CRLF +
                'FileNum: ' + IntToStr(FileNum) + CRLF +
                'SearchPath: ' + IntToStr(SearchPath));

  FillChar(RecPtr[FileNum]^, FileRecLen[FileNum], #0);
  Move(Position, RecPtr[FileNum]^, SizeOf(Position));
  Result := GetDirect(F[FileNum], FileNum, RecPtr[FileNum]^, SearchPath, 0);

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(103,Result);

end; // EX_BTRIEVESETPOS

//-----------------------------------------------------------------------

FUNCTION EX_BTRIEVERECCOUNT(FILENUM      : SMALLINT;
                            VAR RECCOUNT : LONGINT) : SMALLINT;
begin
  LastErDesc:='';

  if TestMode then
    ShowMessage('Ex_BtrieveRecCount: ' + CRLF +
                  'FileNum : ' + IntToStr(FileNum));

  Result := 0;
  // Check for valid Enterprise files : CustF, InvF, IDetailF, NomF, StockF
  // PWrdF, MiscF, JobF
  if not FileNum in [1..5,8,9,11] then
    Result := 30001;

  RecCount := Used_Recs(F[FileNum], FileNum);

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(124,Result);

end; // EX_BTRIEVERECCOUNT

//-----------------------------------------------------------------------

end.
