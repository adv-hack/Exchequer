unit IdxObj;

interface

uses
  VarConst, BtrvU2, Classes, Contnrs;


type
  TIndexObject = Class
  private
    FIndexSpec : KeySpec;
    FKeyNumber : Integer;
    function GetKeyFlags: Integer;
    function GetKeyLength: Integer;
    function GetKeyPosition: Integer;
    procedure SetKeyFlags(const Value: Integer);
    procedure SetKeyLength(const Value: Integer);
    procedure SetKeyPosition(const Value: Integer);
    function GetExtendedType: Integer;
    procedure SetExtendedType(const Value: Integer);
  public
    constructor Create;
    function GetKeySpec : KeySpec;
    property KeyPosition : Integer read GetKeyPosition write SetKeyPosition;
    property KeyLength : Integer read GetKeyLength write SetKeyLength;
    property KeyFlags : Integer read GetKeyFlags write SetKeyFlags;
    property ExtendedType : Integer read GetExtendedType write SetExtendedType;
  end;

  TAddIndex = Class
  private
    FSegmentList : TObjectList;
    FFileName : string;
    FDataDirectory : string;
    FFileBlock : FileVar;
    FKeyNumber : Integer;
    FFileNumber : Integer;
    FIndexNumber : Integer;
    FAltColSeq : Boolean;
    function GetDataDirectory: string;
    function GetFileName: string;
    function GetKeyNumber: Integer;
    procedure SetDataDirectory(const Value: string);
    procedure SetFileName(const Value: string);
    procedure SetKeyNumber(const Value: Integer);
    function OpenFile : Integer;
    function CloseFile : Integer;
    function CreateIndex : Integer;
  public
    constructor Create;
    destructor Destroy;
    function AddSegment : TIndexObject;
    function Execute : Integer;
    function IndexExists : Boolean; virtual;
    procedure Clear;

    property KeyNumber : Integer read GetKeyNumber write SetKeyNumber;
    property FileNumber : Integer read FFileNumber write FFileNumber;
    property IndexNumber : Integer read FIndexNumber write FIndexNumber;
    property FileName : string read GetFileName write SetFileName;
    property DataDirectory : string read GetDataDirectory write SetDataDirectory;
    property UseAltColSeq : Boolean read FAltColSeq write FAltColSeq;
  end;

  //PR: 13/03/2014 ABSEXCH-ABSEXCH-15102 One-off descendant class to replace indexes added in 708.
  TAddIndex709 = Class(TAddIndex)
  public
    function IndexExists : Boolean; override;
  end;

  //PR: 23/12/2014 Added for LAMEX utility to drop and re-create index
  TDropIndex = Class(TAddIndex)
  public
    function DropIndex(IndexNo : Integer) : integer;
  end;

implementation

uses
  GlobVar;

const

  //BTDLLPath  =  'WBTRV32.DLL';
  B_CreateIndex = 31;
  B_DropIndex = 32;
  B_Stat = 15;


(* MH 15/02/2010: Removed static link as causing SQL Edition to load (fail to) WBtrv32.Dll
                  during upgrades

  FUNCTION BTRCALL(
                   operation : WORD;
               VAR posblk;
               VAR databuf;
               VAR datalen   : WORD;
               VAR keybuf;
                   keylen    : BYTE;
                   keynum    : Integer
                   ) : SmallInt; FAR; StdCall;
                   external  BTDLLPath name 'BTRCALL';
*)

{ TIndexObject }


constructor TIndexObject.Create;
begin
  FillChar(FIndexSpec, SizeOf(FIndexSpec), 0);
end;

function TIndexObject.GetExtendedType: Integer;
begin
  Result := FIndexSpec.ExtTypeVal;
end;

function TIndexObject.GetKeyFlags: Integer;
begin
  Result := FIndexSpec.KeyFlags;
end;

function TIndexObject.GetKeyLength: Integer;
begin
  Result := FIndexSpec.KeyLen;
end;

function TIndexObject.GetKeyPosition: Integer;
begin
  Result := FIndexSpec.KeyPos;
end;

function TIndexObject.GetKeySpec: KeySpec;
begin
  Result := FIndexSpec;
end;

procedure TIndexObject.SetExtendedType(const Value: Integer);
begin
  FIndexSpec.ExtTypeVal := Value;
end;

procedure TIndexObject.SetKeyFlags(const Value: Integer);
begin
  FIndexSpec.KeyFlags := Value;
end;

procedure TIndexObject.SetKeyLength(const Value: Integer);
begin
  FIndexSpec.KeyLen := Value
end;

procedure TIndexObject.SetKeyPosition(const Value: Integer);
begin
  FIndexSpec.KeyPos := Value;
end;

{ TAddIndex }

function TAddIndex.AddSegment: TIndexObject;
begin
  Result := TIndexObject.Create;
  FSegmentList.Add(Result);
end;

procedure TAddIndex.Clear;
begin
  FSegmentList.Clear;
  FAltColSeq := False;
end;

function TAddIndex.CloseFile: Integer;
begin
  Result := Close_File(FFileBlock);
end;

constructor TAddIndex.Create;
begin
  FSegmentList := TObjectList.Create;
  FAltColSeq := False;
end;

function TAddIndex.CreateIndex: Integer;
var
  DataBuf : Pointer;
  i, DataLen : Integer;
  LocalKeySpec : KeySpec;
  DummyKeyBuffer : string[1];
  RecPos : longint;
begin
  if FAltColSeq then
    DataLen := SizeOf(LocalKeySpec) * FSegmentList.Count + 265
  else
    DataLen := SizeOf(LocalKeySpec) * FSegmentList.Count;
  GetMem(DataBuf, DataLen);
  Try
    FillChar(DummyKeyBuffer, SizeOf(DummyKeyBuffer), 0);
    FillChar(DataBuf^, DataLen, 0);
    for i := 0 to FSegmentList.Count - 1 do
    begin
      LocalKeySpec := TIndexObject(FSegmentList[i]).GetKeySpec;
      RecPos := longint(DataBuf) + (SizeOf(KeySpec) * i);

      Move(LocalKeySpec, Pointer(RecPos)^, SizeOf(LocalKeySpec));
    end;

    //If we're using AltColSeq then move it into the record - it should pick up the one already
    //in the file but doesn't seem to be doing so.
    if FAltColSeq then
    begin
      RecPos := RecPos + SizeOf(KeySpec);
      Move(UpperAlt, Pointer(RecPos)^, SizeOf(UpperAlt));
    end;

    Result := Btrv(B_CreateIndex, FFileBlock, DataBuf^, DataLen, DummyKeyBuffer[1], 0, 0);
  Finally
    FreeMem(DataBuf);
  End
end;

destructor TAddIndex.Destroy;
begin
  FSegmentList.Free;
end;

function TAddIndex.Execute: Integer;
begin
  Result := OpenFile;

  if Result = 0 then
  begin
    Try
      if IndexExists then
        Result := 0
      else
        Result := CreateIndex;
    Finally
      CloseFile;
    End;
  end
  else
    Result := Result + 30000;
end;

function TAddIndex.GetDataDirectory: string;
begin
  Result := FDataDirectory;
end;

function TAddIndex.GetFileName: string;
begin
  Result := FFileName;
end;

function TAddIndex.GetKeyNumber: Integer;
begin
  Result := FKeyNumber;
end;

function TAddIndex.IndexExists: Boolean;
var
  Res : Integer;
  AFileSpec : FileSpec;
begin
  OpenFile;
  Res := GetFileSpec(FFileBlock, FFileNumber, AFileSpec);
  Result := (Res = 0) and (AFileSpec.NumIndex >= FIndexNumber + 1);
end;

function TAddIndex.OpenFile: Integer;
var
  sFileName : Str255;
begin
  sFileName := FFileName;
  Result := Open_File(FFileBlock, sFileName, 0);
end;

procedure TAddIndex.SetDataDirectory(const Value: string);
begin
  FDataDirectory := Value;
end;

procedure TAddIndex.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TAddIndex.SetKeyNumber(const Value: Integer);
begin
  FKeyNumber := Value;
end;


{ TAddIndex709 }
//Specific check for v7.0.9 Check whether index is original (including FolioRef) or new (including OurRef).
function TAddIndex709.IndexExists: Boolean;
Type
  DatBufType = Record
    FS       : FileSpec;
    Ks       : array[1..32] of KeySpec;
    AltColt  : AltColtSeq;
  End; { DatBufType }
var
  DumRecLen,DumKeyNum  :  Integer;
  KeyBuff              :  Str255;
  DatBuf               :  DatBufType;
  Res, i, DataLen : Integer;

begin
  DumRecLen := SizeOf(DatBufType);
  DumKeyNum := 0;

  FillChar (DatBuf, SizeOf(DatBuf), #0);

  DumRecLen:=FileSpecLen[FFileNumber];

  OpenFile;

  Res := Btrv(15,FFileBlock,DatBuf,DumRecLen,KeyBuff[1],DumKeyNum,0);
  Result := (Res = 0) and (DatBuf.Fs.NumIndex >= FIndexNumber + 1);

  if Result then
  begin //Segment 28 will be a longint if it needs updating; if so, drop the index and return false
    DataLen := 1;
    if DatBuf.Ks[28].KeyLen = 4 then
    begin
      for i := 10 to 12 do
        Res := Btrv(B_DropIndex, FFileBlock, KeyBuff[1], DataLen, KeyBuff[1], i, 0);

      Result := False;
    end;
  end;
end;

{ TDropIndex }

function TDropIndex.DropIndex(IndexNo: Integer): integer;
var
  KeyBuff         :  Str255;
  Res, DataLen : Integer;
begin
  Result := OpenFile;
  if Result = 0 then
  Try
    DataLen := 1;
    Result := Btrv(B_DropIndex, FFileBlock, KeyBuff[1], DataLen, KeyBuff[1], IndexNo, 0);
  Finally
    CloseFile;
  End
  else
    Result := Result + 1000;
end;

end.
