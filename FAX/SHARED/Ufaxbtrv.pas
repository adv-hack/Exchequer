unit UFaxBtrv;

{ nfrewer440 10:20 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$IFNDEF VER130}
  {$ALIGN 1}  { Variable Alignment Disabled }
{$ENDIF}


interface

uses
  VarConst, GlobVar, APIUtil;

// Btrieve fax file handling routines
function  OpenFaxFile(DisplayError : boolean) : boolean; stdcall
function  OpenFaxFileWithPath(DisplayError : boolean; Path : shortstring) : boolean; stdcall;
procedure CloseFaxFile;
procedure MakeFaxFile;

// Fax counter handling routines
function  SetNextFaxCounter : integer;

// Assigns an incrementing unqiue reference
function  GetUniqueRef : shortstring;

// Fax server parameter handling routines
function  ReadFaxParams(Params : PFaxParams) : integer;
function  WriteFaxParams(Params : PFaxParams) : boolean;

// Fax detail handling routines
procedure UnlockFaxDetails(LockPos : longint);
function  FindFaxDetails(KeyS : str255; KeyType : char; Details : PFaxDetails) : boolean;
function  FindAndLockFaxDetails(KeyS : str255; KeyType : char; Details : PFaxDetails;
                                  var LockPos : longint) : boolean;
function InsertFaxDetails(Details : PFaxDetails) : longint;
function InsertFaxDetailsEx(Details : PFaxDetails; sFileName : string = '') : longint;
function UpdateFaxDetails(KeyType : char; Details : PFaxDetails; LockPos : longint) : boolean;
function DeleteFaxDetails(KeyType : char) : boolean;
function FindFirstFaxDetails(Details : PFaxDetails) : boolean;
function FindNextFaxDetails(Details : PFaxDetails) : boolean;

// Fax server running marker handling routines
procedure LogFaxServerAsRunning(Running : boolean);
function  CheckFaxServerRunning : boolean;
procedure LogIt(const s : string);


implementation

uses
  BtrvU2, Dialogs, Sysutils, FaxUtils, VarFPosU{, IniFiles}, DateUtils, Forms, Windows;

var
  LogF : TextFile;
  LogFName : string;

procedure RandomSleep(Res : Integer);
begin
  if Res = 78 then
    Sleep(1 + Random(100));
end;

procedure LogIt(const s : string);
begin
{$IFDEF Debug}
  if FileExists(LogFName) then
    Append(LogF)
  else
    Rewrite(LogF);
  Try
    WriteLn(LogF, FormatDateTime('hh:nn:ss:zzz', Time) + '> ' + s);
  Finally
    CloseFile(LogF);
  End;
{$ENDIF}
end;

procedure MakeFaxFile;
var
  Status : integer;
begin
  Status := Make_File(F[FaxF],SetDrive+FileNames[FaxF],FileSpecOfs[FaxF]^,FileSpecLen[FaxF]);

  if Status = 0 then
    MessageDlg(FileNames[FaxF]+' created OK', mtInformation, [mbOK], 0)
  else
    ShowBtrieveError('Could not create ' + FileNames[FaxF], Status);
end;

//-----------------------------------------------------------------------

procedure InitialiseFaxCounter;
const
  FNum = FaxF;
begin
  FillChar(FaxRec^,SizeOf(FaxRec^),#0);
  with FaxRec^, FaxCounter do
  begin
    FaxRecType := 'C';
    FaxCurCounter := 1;
  end;
  Add_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);
end; // InitialiseFaxCounter

//-----------------------------------------------------------------------
(*
function SetNextFaxCounter : integer;
const
  FNum = FaxF;
var
  Keys    : str255;
  LockPos : longint;
begin
  with FaxRec^, FaxCounter do
  begin
    // Find record using a wait lock
    KeyS := 'C';
    if Find_Rec(B_GetEq+B_MultWLock, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS) = 0 then
    begin // Found counter record
      GetPos(F[FNum], FNum, LockPos);
      inc(FaxCurCounter);
      Put_Rec(F[FNum], FNum, RecPtr[FNum]^, 0); // Update counter
      UnLockMultiSing(F[FNum], FNum, LockPos);
    end
    else // No counter record found
      InitialiseFaxCounter;

   Result := FaxCurCounter;
  end; // with
end; // SetNextFaxCounter
*)

function SetNextFaxCounter : integer;
const
  FNum = FaxF;
var
  Keys    : str255;
  LockPos : longint;
  Res, UpdateResult : Integer;
  dtTimeOut : TDateTime;
  TimedOut : Boolean;
begin
  OutputDebugString('   ');
  OutputDebugString('================ SetNextFaxCounter.Start');
  OutputDebugString('   ');
  repeat
    with FaxRec^, FaxCounter do
    begin
      // Find record using a wait lock
      KeyS := 'C';
      Res := 84;
      TimedOut := False;
      dtTimeOut := IncSecond(Now, 60);
      while not (Res in [0, 4]) and not TimedOut do
      begin
        Res := Find_Rec(B_GetEq+B_MultNWLock, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
        LogIt('SetNextFaxCounter - Find_Rec: ' + IntToStr(Res));
        TimedOut := Now > dtTimeOut;
        if Res <> 0 then
          Sleep(100);
      end;

      if TimedOut then
        FaxCurCounter := 0
      else
      begin
        if Res = 0 then
        begin // Found counter record
          GetPos(F[FNum], FNum, LockPos);
          inc(FaxCurCounter);
          UpdateResult := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, 0); // Update counter
          UnLockMultiSing(F[FNum], FNum, LockPos);
          RandomSleep(UpdateResult);
        end
        else // No counter record found
          InitialiseFaxCounter;
      end;
     LogIt('SetNextFaxCounter - Result: ' + IntToStr(FaxCurCounter));
     Result := FaxCurCounter;
    end; // with
  until UpdateResult <> 78;
  OutputDebugString('   ');
  OutputDebugString('================ SetNextFaxCounter.End');
  OutputDebugString('   ');
end; // SetNextFaxCounter


//-----------------------------------------------------------------------

function OpenFaxFile(DisplayError : boolean) : boolean;
const
  FNum = FaxF;
var
  Status : integer;
  iPos, BVer,BRev  :  Integer;
  BTyp       :  Char;
begin
  Status := Open_File(F[FNum], SetDrive + FileNames[FNum], 0);

  {$IFDEF DEBUG}
    if status = 0 then begin
      For iPos := 0 to 3 do begin
        Status := GetBtrvStat(F[Fnum],BVer,BRev, BTyp, iPos);
        ShowMessage('BVer : ' + IntToStr(BVer) + ' / BRev : ' + IntToStr(BRev) + ' / BTyp : ' + BTyp);
      end;{for}
    end;{if}
  {$ENDIF}

  Result := Status = 0;
  if not Result and DisplayError then
    ShowBtrieveError('Could not open fax Btrieve file ' + FaxName,Status);
end; // OpenFaxFile

//-----------------------------------------------------------------------

function OpenFaxFileWithPath(DisplayError : boolean; Path : shortstring) : boolean;
begin
  SetDrive := Path;
  Result := OpenFaxFile(DisplayError);
end;

//-----------------------------------------------------------------------

procedure CloseFaxFile;
const
  FNum = FaxF;
begin
  Close_File(F[FNum]);
end;

//-----------------------------------------------------------------------

function ReadFaxParams(Params : PFaxParams) : integer;
// Pre  : Params = pointer to allocated structure of type TFaxParams
// Post : Returns Btrieve error status (0 = OK)
const
  FNum = FaxF;
var
  KeyS : str255;
begin
  KeyS := 'P';
  Result := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
  if Result = 0 then
    Params^ := FaxRec^.FaxParams;
end; // ReadFaxParams

//-----------------------------------------------------------------------

function WriteFaxParams(Params : PFaxParams) : boolean;
// Post : Returns true if record written OK
const
  FNum = FaxF;
var
  KeyS : str255;
  LockPos : longint;
begin
  KeyS := 'P';

  // Search for parameters record
  if Find_Rec(B_GetEq+B_MultNWLock, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS) = 0 then
  begin // if found params record and locked it, update it
    GetPos(F[FNum], FNum, LockPos);
    FaxRec^.FaxParams := Params^;
    Result := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, 0) = 0;
    UnLockMultiSing(F[FNum], FNum, LockPos);
  end
  else
  begin // Not found params record, so insert new record
    FillChar(RecPtr[FNum]^,SizeOf(RecPtr[FNum]^),0);
    FaxRec^.FaxRecType := 'P';
    FaxRec^.FaxParams := Params^;
    Result := Add_Rec(F[FNum], FNum, RecPtr[FNum]^, 0) = 0;
  end;
end; // WriteFaxParams

//-----------------------------------------------------------------------

function SetKeyDetails(KeyType : char; var KeyS : str255; var KeyByte : byte) : boolean;
// Pre  : KeyType = 'A' => APF name; 'D' => Document name
//        KeyS = key string to search for
// Post : KeyS padded to length of whole key with spaces
//        KeyByte becomes appropraite key number (1 or 2)
begin
  KeyType := UpCase(KeyType);
  Result := KeyType in ['D','A'];
  if Result then
  begin
    if KeyType = 'D' then
    begin
      // Add 'D' for details record
      KeyS := 'D' + SpacePad(KeyS,SizeOf(FaxRec^.FaxDetails.FaxDocName)-1);
      KeyByte := 1;
    end
    else
    begin
      // Add 'D' for details record
      KeyS := ExtractFileName(KeyS);
      KeyS := 'D' + SpacePad(KeyS,SizeOf(FaxRec^.FaxDetails.FaxAPFName)-1);
      KeyByte := 2;
    end;
  end;
end; // SetKeyDetails

//-----------------------------------------------------------------------

procedure UnlockFaxDetails(LockPos : longint);
const
  FNum = FaxF;
begin
  UnLockMultiSing(F[FNum], FNum, LockPos);
end;

//-----------------------------------------------------------------------

function FindAndLockFaxDetails(KeyS : str255; KeyType : char; Details : PFaxDetails;
                          var LockPos : longint) : boolean;
// Pre : KeyType = 'A' => Search using APF name
//       KeyType = 'D' => Search using Document name
const
  FNum = FaxF;
var
  KeyByte : byte;
  Status : integer;
begin
  OutputDebugString('   ');
  OutputDebugString('================ FindAndLockFaxDetails.Start');
  OutputDebugString('   ');

  Result := false;
  if not SetKeyDetails(KeyType,KeyS,KeyByte) then exit;

  // Could put a retry in here to avoid lock contention
  Status := Find_Rec(B_GetEq+B_MultNWLock, F[FNum], FNum, RecPtr[FNum]^, KeyByte, KeyS);
  Result := Status = 0;
  if Result then
  begin
    GetPos(F[FNum], FNum, LockPos);
    Details^ := FaxRec^.FaxDetails;
  end;
  OutputDebugString('   ');
  OutputDebugString('================ FindAndLockFaxDetails.End');
  OutputDebugString('   ');
end; // FindAndLockFaxDetails


//-----------------------------------------------------------------------

function FindFaxDetails(KeyS : str255; KeyType : char; Details : PFaxDetails) : boolean;
var
  iStatus : integer;
  KeyByte : byte;
begin
  LogIt('FindFaxDetails - KeyS: ' + KeyS);
  Result := false;
  if not SetKeyDetails(KeyType,KeyS,KeyByte) then exit;
  iStatus := Find_Rec(B_GetEq, F[FaxF], FaxF, RecPtr[FaxF]^, KeyByte, KeyS);
  LogIt('FindFaxDetails - Find_Rec: ' + IntToStr(iStatus));
  Result := iStatus = 0;
  if Result then
    Details^ := FaxRec^.FaxDetails
  else
    FillChar(Details^,SizeOf(Details^),#0);
end; // FindFaxDetails

//-----------------------------------------------------------------------

function UpdateFaxDetails(KeyType : char; Details : PFaxDetails; LockPos : longint) : boolean;
const
  FNum = FaxF;
var
  Dum : str255;
  KeyByte : byte;
  Res : Integer;
begin
  Result := false;
  if not SetKeyDetails(KeyType,Dum,KeyByte) then exit;

  Repeat
  // Perform a get direct using previously stored position
    move(LockPos,RecPtr[FNum]^,sizeof(LockPos));
    GetDirect(F[FNum], FNum, RecPtr[FNum]^,KeyByte, 0);
    // Update the record and unlock it
    with FaxRec^ do
    begin
      FaxDetails := Details^;
      FaxDetails.FaxDocName := SpacePad(FaxDetails.FaxDocName,SizeOf(FaxDetails.FaxDocName)-1);
      FaxDetails.FaxAPFName := SpacePad(FaxDetails.FaxAPFName,SizeOf(FaxDetails.FaxAPFName)-1);
    end;
    Res := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, KeyByte);
    Result := Res = 0;
    UnLockMultiSing(F[FNum], FNum, LockPos);
    RandomSleep(Res);
  until Res <> 78;
end; // UpdateFaxDetails

//-----------------------------------------------------------------------
//PR: 16/09/2009 Faxes from outside Exchequer weren't having their APFName field updated with the TiFF filename.
function DoInsertFaxDetails(Details : PFaxDetails; sFileName : string = '') : longint;
const
  FNum = FaxF;
var
  SenderEmail : array[0..100] of char;
  FaxFrom : array[0..80] of char;
  TimeOutCount : longint;
  sAPFKey : String[12];
{  Win2kFaxIni : TIniFile;}
begin
  if sFileName = '' then
    sAPFKey := APFPrefix + GetUniqueRef
  else
    sAPFKey := sFileName;
{  showmessage('FaxDocName : ' + Details^.FaxDocName + #13 + 'FaxUserDesc : ' + Details^.FaxUserDesc);}
  FillChar(RecPtr[FNum]^,SizeOf(RecPtr[FNum]^),0);
  with FaxRec^ do
  begin
    FaxRecType := 'D';
    FaxDetails := Details^;
    FaxDetails.FaxDocName := SpacePad(FaxDetails.FaxDocName,SizeOf(FaxDetails.FaxDocName)-1);
    FaxDetails.FaxAPFName := sAPFKey;
    LogIt('InsertFaxDetails. FaxDocName = ' + Trim(FaxDetails.FaxDocName) + ' FaxAPFName = ' + Trim(FaxDetails.FaxAPFName));
    // Key position of FaxAPFName is manual key with chr(0) as the null value
    if not (length(Trim(FaxDetails.FaxAPFName)) = 0) then FaxDetails.FaxAPFName
    := SpacePad(FaxDetails.FaxAPFName,SizeOf(FaxDetails.FaxAPFName)-1);

    with FaxDetails do begin
      FaxUserName := WinGetUserName;
{      FaxCancel := FALSE;}
      FaxHold := FALSE;

      {Get Email Address from INI File}
      UserDefaults(FaxFrom, SenderEmail, iniRead);
{      if SenderEmail <> '' then FaxSenderEmail := SenderEmail; {else use enterprises Email Address}
      FaxSenderEmail := SenderEmail;

      FaxBusyRetries := 0;
    end;{with}
    Result := Add_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);
    TimeOutCount := 0;
    while (Result = 5) and (TimeoutCount < 5) do
    begin
      Sleep(100);
      inc(TimeoutCount);
      Result := Add_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);
      LogIt('InsertFaxDetails - Retry Add_Rec: ' + IntToStr(Result));
    end;
{    if Result <> 0 then
      raise Exception.Create('Unable to Add Fax Details record. Error ' + IntToSTr(Result));}
    LogIt('InsertFaxDetails - Add_Rec: ' + IntToStr(Result));
    {$IFDEF FAXBTRV}
      {new Windows 2000 fix}
{      if GetWindowsVersion = wv2000 then begin
        Win2kFaxIni := TInifile.create(SetDrive + 'WIN2KFAX.INI');
        Win2kFaxIni.WriteString(Uppercase(FaxRec^.FaxDetails.FaxUserName + ':' + WinGetComputerName),'UniqueKey'
        ,FaxRec^.FaxDetails.FaxDocName);
      end;{if}
    {$ENDIF}
  end;{with}
end; // InsertFaxDetails


function InsertFaxDetailsEx(Details : PFaxDetails; sFileName : string = '') : longint;
begin
  Result := DoInsertFaxDetails(Details, sFilename);
end;

function InsertFaxDetails(Details : PFaxDetails) : longint;
begin
  Result := DoInsertFaxDetails(Details, '');
end;


//-----------------------------------------------------------------------

function DeleteFaxDetails(KeyType : char) : boolean;
// Pre : KeyType = 'D' = Document name key
//       KeyType = 'A' = APF file name key
const
  FNum = FaxF;
var
  KeyByte : byte;
begin
  if KeyType = 'D' then
    KeyByte := 1
  else
    KeyByte := 2;
  Result := Delete_Rec(F[FNum], FNum, KeyByte) = 0;
end; // DeleteFaxDetails

//-----------------------------------------------------------------------

function CheckFaxServerRunning : boolean;
// Post : Returns true if the fax sever is deemed to be running due to the presence
//        of a locked record with 'S' in key position 0
const
  FNum = FaxF;
var
  KeyS : Str255;
  iStatus : integer;
  LockPos : longint;
begin
  Result := False;
  KeyS := 'S';
  iStatus := Find_Rec(B_GetEq{+B_MultNWLock}, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
  // If 'S' record absent or not locked server not running
{  Result := not (Status in [0, 4]);
  if Status = 0 then begin // If this call locked the 'S' record, unlock it
    GetPos(F[FNum], FNum, LockPos);
    UnLockMultiSing(F[FNum], FNum, LockPos);
  end;}
  if iStatus = 0 then
  begin
    Result := Abs(MinutesBetween(FaxRec.FaxDetails.FaxSenderTimeStamp, Time)) <= 5;
    GetPos(F[FNum], FNum, LockPos);
    UnLockMultiSing(F[FNum], FNum, LockPos);
  end;
end; // CheckFaxServerRunning
(*
function CheckFaxServerRunning : boolean;
// Post : Returns true if the fax sever is deemed to be running due to the presence
//        of a locked record with 'S' in key position 0
const
  FNum = FaxF;
var
  KeyS : Str255;
  Status : integer;
  LockPos : longint;
begin
  KeyS := 'S';
  Status := Find_Rec(B_GetEq+B_MultNWLock, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
  // If 'S' record absent or not locked server not running
  Result := not (Status in [0, 4]);
  if Status = 0 then begin // If this call locked the 'S' record, unlock it
    GetPos(F[FNum], FNum, LockPos);
    UnLockMultiSing(F[FNum], FNum, LockPos);
  end;
end; // CheckFaxServerRunning
*)
//-----------------------------------------------------------------------

procedure LogFaxServerAsRunning(Running : boolean);
// Pre  : Running = true => Fax server enabled, locked 'S' record present
//        Running = false => Fax server disabled, 'S' record unlocked
const
  FNum = FaxF;
var
  KeyS : Str255;
  LockPos : longint;
  iStatus : integer;
begin
  LogIt('LogFaxServerAsRunning.Start');
  KeyS := 'S';
  iStatus := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
  if iStatus = 4 then // 'S' record absent
  begin  // Add 'S' record and lock it
    FillChar(FaxRec^,SizeOf(FaxRec^),#0);
    FaxRec^.FaxRecType := 'S';
    Add_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);
    iStatus := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
  end;

  if iStatus = 0 then
  begin
    if Running then
      FaxRec^.FaxDetails.FaxSenderTimeStamp := Time
    else
      FaxRec^.FaxDetails.FaxSenderTimeStamp := 0;

    iStatus := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);
  end;
  LogIt('LogFaxServerAsRunning.End');
end; // LogFaxServerAsRunning

(*
procedure LogFaxServerAsRunning(Running : boolean);
// Pre  : Running = true => Fax server enabled, locked 'S' record present
//        Running = false => Fax server disabled, 'S' record unlocked
const
  FNum = FaxF;
var
  KeyS : Str255;
  LockPos : longint;
  Status : integer;
begin
  KeyS := 'S';
  if Running then
  begin
    Status := Find_Rec(B_GetEq+B_MultNWLock, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
    if Status = 4 then // 'S' record absent
    begin  // Add 'S' record and lock it
      FillChar(FaxRec^,SizeOf(FaxRec^),#0);
      FaxRec^.FaxRecType := 'S';
      Add_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);
      Find_Rec(B_GetEq+B_MultNWLock, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
    end;
  end
  else
  begin
    // If no longer running find the 'S' record and unlock it
    Status := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
    if Status = 0 then
    begin
      GetPos(F[FNum], FNum, LockPos);
      UnLockMultiSing(F[FNum], FNum, LockPos);
    end;
  end;
end; // LogFaxServerAsRunning
*)
//-----------------------------------------------------------------------

function FindFirstFaxDetails(Details : PFaxDetails) : boolean;
const
  FNum = FaxF;
var
  KeyS : str255;
begin
  KeyS := 'D';
  Result := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS) = 0;
  if Result then
    Details^ := FaxRec^.FaxDetails
  else
    FillChar(Details^,SizeOf(Details^),#0);
end;

//-----------------------------------------------------------------------

function FindNextFaxDetails(Details : PFaxDetails) : boolean;
const
  FNum = FaxF;
var
  KeyS : str255;
begin
  KeyS := 'D';
  Result := Find_Rec(B_GetNext, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS) = 0;
  if Result and (FaxRec^.FaxRecType = 'D') then
    Details^ := FaxRec^.FaxDetails
  else
    FillChar(Details^,SizeOf(Details^),#0);
end; // FindNextFaxDetails

//-----------------------------------------------------------------------

procedure InitialiseUniqueRef;
const
  FNum = FaxF;
begin
  FillChar(FaxRec^,SizeOf(FaxRec^),#0);
  with FaxRec^, FaxRef do
  begin
    FaxRecType := 'U';
    FaxUniqueRef := '000001';
  end;
  Add_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);
end; // InitialiseFaxRef

//-----------------------------------------------------------------------

function GetUniqueRef : shortstring;
// Post : Returns a unique reference code
const
  FNum = FaxF;
var
  Keys    : str255;
  LockPos : longint;
  Res, UpdateResult : Integer;
  dtTimeOut : TDateTime;
  TimedOut : Boolean;

  procedure SetNextRef;
  // Notes : Using references as defined gives 36^6 -1 = 2176782335 combinations
  const
    REF_CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    MAX_SIZE = SizeOf(FaxRec^.FaxRef.FaxUniqueRef) -1;
  var
    CharPos : array[1..MAX_SIZE] of byte;
    Posn : byte;
    Done : boolean;
  begin
    with FaxRec^.FaxRef do
    begin
      for Posn := 1 to MAX_SIZE do
        CharPos[Posn] := Pos(FaxUniqueRef[Posn], REF_CHARS);

      Done := false;
      Posn := MAX_SIZE;
      while not Done and (Posn > 0) do
      begin
        CharPos[Posn] := CharPos[Posn] + 1;
        if CharPos[Posn] > length(REF_CHARS) then
        begin
          CharPos[Posn] := 1;
          dec(Posn);
        end
        else
          Done := true;
      end; // while
      for Posn := 1 to MAX_SIZE do
        FaxUniqueRef[Posn] := REF_CHARS[CharPos[Posn]];
    end; // with
  end; // SetNextRef

begin
  OutputDebugString('   ');
  OutputDebugString('================ GetUniqueRef.Start');
  OutputDebugString('   ');

  Repeat
    with FaxRec^, FaxRef do
    begin
      // Find record using a wait lock
      KeyS := 'U';


      //PR: 17/09/2009 - need to initialise Res to 0 as otherwise some systems crash
      Res := 84;
      TimedOut := False;
      dtTimeOut := IncSecond(Now, 60);
      while not (Res in [0, 4]) and not TimedOut do
      begin
        Res := Find_Rec(B_GetEq+B_MultNWLock, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);

        TimedOut := Now > dtTimeOut;
        if Res <> 0 then
          Sleep(100);
      end;
      if TimedOut then
        FaxUniqueRef := ''
      else
      begin
        if Res = 0 then
        begin // Found unique reference record
          GetPos(F[FNum], FNum, LockPos);
          SetNextRef;
          UpdateResult := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, 0); // Update reference
          UnLockMultiSing(F[FNum], FNum, LockPos);
          RandomSleep(UpdateResult);
        end
        else // No ref record found
          InitialiseUniqueRef;
      end;
     Result := FaxUniqueRef;
  end; // with
  until UpdateResult <> 78;

  OutputDebugString('   ');
  OutputDebugString('================ GetUniqueRef.End');
  OutputDebugString('   ');
end; // GetUniqueRef

//-----------------------------------------------------------------------
initialization
  LogFName := ChangeFileExt(Application.ExeName, '.log');
  AssignFile(LogF, LogFName);
  Randomize;
finalization

end.

