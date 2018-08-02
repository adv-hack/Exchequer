unit Flags;

interface

uses
  Classes, ElVar, Btrvu2;


type
  TBtFileType = Class
    FV : FileVar;
  end;

  TSentimailFlags = Class
  private
    FClientID : ClientIdType;
    FList : TStringList;
    FFileOpen : Boolean;
    procedure SetFlag(WhichFlag : Byte; WhichFile : integer; SetOn : Boolean);
  public
    Constructor Create(const EntPath : string);
    Destructor Destroy; override;
    procedure SetFlags(WhichFlags : Word);
    procedure Clear;
  end;

var
  SentimailFlags : TSentimailFlags;


implementation

uses
  SentU, sysUtils;

function SystemKey(WhichFlag : Char) : Str255;
  function InstKey(i : SmallInt) : ShortString;
  var
    s : ShortString;
  begin
    s := StringOfChar(' ', SizeOf(i));
    Move(i, s[1], sizeOf(i));
    Result := s;
  end;
begin
  FillChar(Result, SizeOf(Result), #0);
  //PR: 22/07/2009 How did this ever work?!! The key string was wrong. Now corrected.
  Result := pxSysRec + LJVar('ZZZZZZZZZZ', UIDSize) +
            LJVar('System', 30) + InstKey(0) + WhichFlag + #0#0#0#0'!';
end;



Constructor TSentimailFlags.Create(const EntPath : string);
var
  F : TBtFileType;
  x, i : Byte;
  Res : integer;
begin
  inherited Create;

  FClientID.AppId[1] := 'E';
  FClientID.AppId[1] := 'X';
  FClientID.TaskId := 99;
  FList := TStringList.Create;
  F := TBtFileType.Create;
  FList.AddObject(Trim(EntPath), F);
  Res := Open_FileCID(F.FV, EntPath + SysFileName, 0, @FClientID);
//  Res := Open_File(F.FV, EntPath + SysFileName, 0);
  FFileOpen := Res = 0;
end;

Destructor TSentimailFlags.Destroy;
begin
  Clear;
  if Assigned(FList) then
    FList.Free;
  inherited Destroy;
end;

procedure TSentimailFlags.SetFlags(WhichFlags : Word);
var
  F : TBtFileType;
  x, i : Byte;
  Res : integer;
  WantThis : Boolean;
begin
  if Assigned(FList) then
  begin

    if FFileOpen then
    begin
      x := 1;
      for i := 1 to 8 do
      begin
        WantThis := WhichFlags and x = x;
        SetFlag(i, FList.Count - 1, WantThis);
        x := x shl 1;
      end;
    end;

  end;
end;

procedure TSentimailFlags.Clear;
var
  i : integer;
begin
  for i := 0 to FList.Count - 1 do
  begin
//    Close_File(TBtFileType(FList.Objects[i]).FV);
    Close_FileCID(TBtFileType(FList.Objects[i]).FV, @FClientID);
    TBtFileType(FList.Objects[i]).Free;
  end;
  FList.Clear;
end;
(* PR 23/10/2008 - change to use Timestamp rather than locking to avoid SQL Emulator locking issue (Pivotal 33441)
procedure TSentimailFlags.SetFlag(WhichFlag : Byte; WhichFile : integer; SetOn : Boolean);
var
  KeyS : Str255;
  Res : SmallInt;
  K : Char;
  F : FileVar;
  c : longint;
  RecAddr : longint;
  AddrOK : Boolean;
begin
    K := Char(WhichFlag + 48);
    KeyS := SystemKey(K);
    Res := Find_RecCID(B_GetEq, TBtFileType(FList.Objects[WhichFile]).FV, LineF,
                         LineRec, ellIdxOutputType, KeyS, @FClientID);
{    Res := Find_Rec(B_GetEq, TBtFileType(FList.Objects[WhichFile]).FV, LineF,
                         LineRec, ellIdxOutputType, KeyS);}

    if (Res = 4) then
    begin
      FillChar(LineRec, SizeOf(TElertLineRec), #0);
      LineRec.Prefix := pxSysRec;
      LineRec.Output.eoUserID := 'ZZZZZZZZZZ';
      LineRec.Output.eoElertName := LJVar('System', 30);
      LineRec.Output.eoOutputType := K;
      Res := Add_RecCID(TBtFileType(FList.Objects[WhichFile]).FV, LineF, LineRec, ellIdxOutputType, @FClientID);
//      Res := Add_Rec(TBtFileType(FList.Objects[WhichFile]).FV, LineF, LineRec, ellIdxOutputType);
    end;

    if (Res = 0) then
    begin
      Res := Find_RecCID(B_GetEq + B_MultNWLock, TBtFileType(FList.Objects[WhichFile]).FV, LineF,
           LineRec, ellIdxOutputType, KeyS, @FClientID);
{      Res := Find_Rec(B_GetEq + B_MultNWLock, TBtFileType(FList.Objects[WhichFile]).FV, LineF,
           LineRec, ellIdxOutputType, KeyS);}

      if Res = 0 then
      begin
        c := LineRec.Output.eoEngineCounter;
//        inc(c);
        if SetOn then
        begin
//          LineRec.Output.eoEngineCounter := c;
{          Put_RecCID(TBtFileType(FList.Objects[WhichFile]).FV,
                  LineF, LineRec, ellIdxOutputType, @FClientID);}
//          Put_Rec(TBtFileType(FList.Objects[WhichFile]).FV,
//                  LineF, LineRec, ellIdxOutputType);
        end
        else
        begin  //unlock record
          AddrOK := GetPosCID(TBtFileType(FList.Objects[WhichFile]).FV,
                  LineF, RecAddr, @FClientID) = 0;
          if AddrOK then
            UnLockMulTiSingCID(TBtFileType(FList.Objects[WhichFile]).FV,
                    LineF, RecAddr, @FClientID);
{          AddrOK := GetPos(TBtFileType(FList.Objects[WhichFile]).FV,
                  LineF, RecAddr) = 0;
          if AddrOK then
            UnLockMulTiSing(TBtFileType(FList.Objects[WhichFile]).FV,
                    LineF, RecAddr);}
        end;
      end;
//      ShowMessage('Record ' + WhichFlag + ' locked');
    end;

  end;
*)

procedure TSentimailFlags.SetFlag(WhichFlag : Byte; WhichFile : integer; SetOn : Boolean);
var
  KeyS : Str255;
  Res : SmallInt;
  K : Char;
  F : FileVar;
  c : longint;
  RecAddr : longint;
  AddrOK : Boolean;
begin
  K := Char(WhichFlag + 48);
  KeyS := SystemKey(K);
  Res := Find_RecCID(B_GetEq, TBtFileType(FList.Objects[WhichFile]).FV, LineF,
                       LineRec, ellIdxOutputType, KeyS, @FClientID);

  if (Res = 4) then
  begin
    FillChar(LineRec, SizeOf(TElertLineRec), #0);
    LineRec.Prefix := pxSysRec;
    LineRec.Output.eoUserID := 'ZZZZZZZZZZ';
    LineRec.Output.eoElertName := LJVar('System', 30);
    LineRec.Output.eoOutputType := K;
    LineRec.Output.eoTermChar := '!';
  end;

  if SetOn then
    LineRec.Output.SysTimeStamp := Now
  else
    LineRec.Output.SysTimeStamp := 0;

  if Res = 4 then
    Res := Add_RecCID(TBtFileType(FList.Objects[WhichFile]).FV, LineF, LineRec, ellIdxOutputType, @FClientID)
  else
    Res := Put_RecCID(TBtFileType(FList.Objects[WhichFile]).FV, LineF, LineRec, ellIdxOutputType, @FClientID)

end;



end.
