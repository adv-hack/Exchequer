unit jcobj;

interface

uses
  JCVar, BtrvU2;

type
  TJCBaseObject = Class  //Ancestor class - don't implement
  protected
    FFileNo       :  integer;
    FIndex        :  Byte;
    FLockPos      :  longint;
    function BuildSearchKey(const Key : string) : ShortString; virtual; abstract;
    procedure SetIndex(Value : Byte);
  public
    function FindRec(const SearchKey : string; SearchType : integer;
                      Lock : Boolean = False) : integer;
    function AddRec : integer;
    function PutRec : integer;
    function DelRec : integer;
    function OpenFile : integer;
    function CloseFile : integer;
    function LockRecord : integer;
    function UnLockRecord : integer;
    property Index : Byte read FIndex write SetIndex;
  end;

  TMCMObject = Class(TJCBaseObject)
  private
    FMCMPointer : PMCMRecType;
  protected
    function BuildSearchKey(const Key : string) : ShortString; override;
    function GetCoCode : string;
    procedure SetCoCode(const Value : string);
    function GetPayID : string;
    procedure SetPayID(const Value : string);
    function GetCoName : string;
    procedure SetCoName(const Value : string);
    function GetFileName : string;
    procedure SetFileName(const Value : string);
  public
    constructor Create;
    property CoCode : string read GetCoCode write SetCoCode;
    property PayID : string read GetPayID write SetPayID;
    property CoName : string read GetCoName write SetCoName;
    property FileName : string read GetFileName write SetFileName;
  end;

  TEmpObject = Class(TJCBaseObject)
  private
    FEmpPointer : PEmpRecType;
  protected
    function GetCoCode : string;
    procedure SetCoCode(const Value : string);
    function GetEmpCode : string;
    procedure SetEmpCode(const Value : string);
    function GetAcGroup : string;
    procedure SetAcGroup(const Value : string);
    function GetEmpName : string;
    procedure SetEmpName(const Value : string);
    function BuildSearchKey(const Key : string) : ShortString; override;
  public
    constructor Create;
    property CoCode : string read GetCoCode write SetCoCode;
    property EmpCode : string read GetEmpCode write SetEmpCode;
    property EmpName : string read GetEmpName write SetEmpName;
    property AccGroup : string read GetAcGroup write SetAcGroup;
  end;


implementation

uses
  JCFuncs, {$IFDEF EXSQL}SQLUtils,{$ENDIF} SysUtils;


function TJCBaseObject.FindRec(const SearchKey : string; SearchType : integer;
                                     Lock : Boolean = False) : integer;
var
  KeyS : ShortString;
begin
  KeyS := BuildSearchKey(SearchKey);
  Result := Find_Rec(SearchType, F[FFileNo],FFileNo,RecPtr[FFileNo]^, FIndex, KeyS);

  if Lock and (Result = 0) then
    Result := LockRecord;
end;

function TJCBaseObject.AddRec : integer;
begin
  Result := Add_rec(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex);
end;

function TJCBaseObject.PutRec : integer;
begin
  Result := Put_rec(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex);
end;

function TJCBaseObject.DelRec : integer;
begin
  Delete_Rec(F[FFileNo], FFileNo, FIndex);
end;

procedure TJCBaseObject.SetIndex(Value : Byte);
begin
  FIndex := Value;
end;

function TJCBaseObject.OpenFile : Integer;
var
  OpenStatus : SmallInt;

begin
//Change from creating data files - we'll supply blank files in install to
//avoid problems with permissions

  OpenStatus := 0;
{$IFDEF EXSQL}
  if not TableExists(FileNames[FFileNo]) then
{$ELSE}
  if not FileExists(FileNames[FFileNo]) then
{$ENDIF}
  begin
    OpenStatus := Make_File(F[FFileNo],FileNames[FFileNo], FileSpecOfs[FFileNo]^,FileSpecLen[FFileNo]);
  end;

  if OpenStatus = 0 then
  begin
    OpenStatus := Open_File(F[FFileNo], FileNames[FFileNo], 0);
  end;


  Result := OpenStatus;  //if open failed then exception is raised by calling proc
end;

function TJCBaseObject.CloseFile : Integer;
begin
   Result := Close_File(F[FFileNo]);
end;

function TJCBaseObject.LockRecord : Integer;
begin
  Result := GetPos(F[FFileNo], FFileNo, FLockPos);

  if Result = 0 then
  begin
    Move(FLockPos, RecPtr[FFileNo]^, SizeOf(FLockPos));
    Result := GetDirect(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex,
                       B_SingLock + B_SingNWLock);
  end;
end;

function TJCBaseObject.UnlockRecord : Integer;
var
  KeyS : String[255];
begin
   FillChar(KeyS, SizeOf(KeyS), #0);
   Move(FLockPos, RecPtr[FFileNo]^, SizeOf(FLockPos));
   Result := Find_Rec(B_Unlock, F[FFileNo], FFileNo, RecPtr[FFileNo]^,
                        0, KeyS);
end;


//=======================================================================================
constructor TMCMObject.Create;
begin
  inherited Create;
  FFileNo := MCMF;
  FMCMPointer := PMCMRecType(RecPtr[FFileNo]);
end;

function TMCMObject.BuildSearchKey(const Key : string) : ShortString;
begin
  Case Index of
    0  : Result := LJVar(Key, 6);  //CoCode
    1, 2
       : Result := Key;           //PayID
  end;
end;

function TMCMObject.GetCoCode : string;
begin
  Result := FMCMPointer^.CoCode;
end;

procedure TMCMObject.SetCoCode(const Value : string);
begin
  FMCMPointer^.CoCode := LJVar(Value, 6);
end;

function TMCMObject.GetPayID : string;
begin
  Result := FMCMPointer^.PayID;
end;

procedure TMCMObject.SetPayID(const Value : string);
begin
  FMCMPointer^.PayID := LJVar(Value, 3);
end;

function TMCMObject.GetCoName : string;
begin
  Result := FMCMPointer^.CoName;
end;

procedure TMCMObject.SetCoName(const Value : string);
begin
  FMCMPointer^.CoName := Value;
end;

function TMCMObject.GetFileName : string;
begin
  Result := FMCMPointer^.FileName;
end;

procedure TMCMObject.SetFileName(const Value : string);
begin
  FMCMPointer^.FileName := Value;
end;

//=======================================================================================
constructor TEmpObject.Create;
begin
  inherited Create;
  FFileNo := EmpF;
  FEmpPointer := PEmpRecType(RecPtr[FFileNo]);
end;

function TEmpObject.BuildSearchKey(const Key : string) : ShortString;
begin
  Case Index of
    0,
    1  : Result := LJVar(Key, 12);  //CoCode + EmpCode;
    2  : Result := LJVar(Key, 25);  //AcGroup
  end;

end;

function TEmpObject.GetCoCode : string;
begin
  Result := FEmpPointer^.CoCode;
end;

procedure TEmpObject.SetCoCode(const Value : string);
begin
  FEmpPointer^.CoCode := LJVar(Value, 6);
end;

function TEmpObject.GetEmpCode : string;
begin
  Result := FEmpPointer^.EmpCode;
end;

procedure TEmpObject.SetEmpCode(const Value : string);
begin
  FEmpPointer^.EmpCode := LJVar(Value, 6);
end;

function TEmpObject.GetAcGroup : string;
begin
  Result := FEmpPointer^.AcGroup;
end;

procedure TEmpObject.SetAcGroup(const Value : string);
begin
  FEmpPointer^.AcGroup := LJVar(Value, 25);
end;

function TEmpObject.GetEmpName : string;
begin
  Result := FEmpPointer^.EmpName;
end;

procedure TEmpObject.SetEmpName(const Value : string);
begin
  FEmpPointer^.EmpName := Value;
end;


end.
