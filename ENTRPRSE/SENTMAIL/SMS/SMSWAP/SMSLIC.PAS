unit smslic;

interface


type
  TSmsWapLicence = Class
  private
    FUserName : String;
    FPassword : String;
    FFileName : String;
    FESN : string;
    function EncodeDecode(const s : string) : string;
    function CalcCheckSum(const s, s1 : string) : longint;
  public
    function ReadFile : SmallInt;
    function WriteFile : Boolean;
    property UserName : string read FUserName write FUserName;
    property Password : string read FPassword write FPassword;
    property FileName : string read FFileName write FFileName;
    property ESN      : string read FESN write FESN;
  end;




implementation

uses
  LicRec, EntLic, LicFuncu, SysUtils, Dialogs, FileUtil;

type

  TLicenceRec = Record
    lrUnused      :  Array[1..4] of Byte;
    lrUserName    :  String[20];
    lrGarbage     :  Array[1..3] of Byte;
    lrPassword    :  String[20];
    lrMoreGarbage :  Array[1..5] of Byte;
    lrCheckSum    :  longint;
    lrESN         :  string[8];
    lrReserved    :  Array[1..491] of Byte;
  end;

  PByte = ^Byte;

function TSmsWapLicence.ReadFile : SmallInt;
var
  F : File;
  ARec : TLicenceRec;
  TempStr : String;
  LRec : EntLicenceRecType;
  i : integer;
  BResult : Boolean;
  TempRes : SmallInt;
begin
{$I-}
  Result := 0;
  AssignFile(F, FFileName);
  FileMode := fmOpenRead;
  Reset(F, 1);
  TempRes := IOResult;
  if TempRes = 0 then
  begin
    BlockRead(F, Arec, SizeOf(ARec));
    TempRes := IOResult;
    BResult := TempRes = 0;
  end
  else
  if not BResult then
    Result := 1;
  CloseFile(F);
  FileMode := fmOpenReadWrite;
{$I+}

  if BResult then
  begin
{$IFDEF SENT}
    BResult := ReadEntLic(GetEnterpriseDirectory + 'Entrprse.dat', LRec);
{$ENDIF}
    if BResult then
    begin

      TempStr := ARec.lrESN;
      FESN := EncodeDecode(TempStr);

{$IFDEF SENT}
      BResult := Length(TempStr) = 8;

      if BResult then
      begin
        for i := 1 to 8 do
          if Ord(FESN[i]) <> LRec.licISN[i] then
          begin
            BResult := False;
            Result := 2;
          end;
      end
      else
        Result := 2;

{$ENDIF}

      if BResult then
      begin
        TempStr := ARec.lrUserName;
        FUserName := EncodeDecode(TempStr);

        TempStr := ARec.lrPassword;
        FPassword := EncodeDecode(TempStr);


        BResult := ARec.lrCheckSum = CalcCheckSum(FUserName, FPassword);
        if not BResult then
          Result := 3;
      end;
    end;
  end;


end;

function TSmsWapLicence.WriteFile : Boolean;
var
  F : File;
  i : integer;
  ARec : TLicenceRec;
  P : ^Byte;
  B : Byte;
begin
  Randomize;

  P := @ARec;

  for i := 0 to SizeOf(ARec) - 1 do
  begin
    B := Random(255);
    PByte(longint(P) + i)^ := B;
  end;

  ARec.lrCheckSum := CalcCheckSum(FUserName, FPassword);

  ARec.lrUserName := EncodeDecode(FUserName);
  ARec.lrPassword := EncodeDecode(FPassword);
  ARec.lrESN := EncodeDecode(FESN);

  AssignFile(F, FFileName);
  Rewrite(F, 1);

{$I-}
  BlockWrite(F, ARec, SizeOf(ARec));
  Result := IOResult = 0;
  CloseFile(F);
{$I+}

end;

function TSmsWapLicence.EncodeDecode(const s : string) : string;
var
  i : integer;
begin
  Result := s;

  for i := 1 to Length(Result) do
    Result[i] := Char(Ord(Result[i]) xor (255 - i));

end;

function TSmsWapLicence.CalcCheckSum(const s, s1 : string) : longint;
var
  i : integer;
begin
  Result := 0;
  for i := 1 to Length(s) do
    Result := Result + Ord(s[i]);

  Result := Result div 2;

  for i := 1 to Length(s1) do
    Result := Result + Ord(s1[i]);

end;


end.
