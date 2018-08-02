unit SHA3HashUtil;

{Functions to wrap around the Wolfgang Ehrhardt Lib. http://www.wolfgang-ehrhardt.de/crchash_en.html}

interface

type
  TByteArr = array of byte;

  function StrToByte(const AValue: String): TByteArr;
  function StrToSHA3Hase(const AValue: String): String;

implementation

uses Mem_util, Hash, SHA3_256;

//------------------------------------------------------------------------------

function StrToByte(const AValue: String): TByteArr;
begin
  SetLength(Result, Length(AValue));
  if Length(Result) > 0 then
    Move(AValue[1], Result[0], Length(Result));
end;

//------------------------------------------------------------------------------

function StrToSHA3Hase(const AValue: String): String;
var
  lBufByte: TByteArr;
  lDigest: TSHA3_256Digest;
begin
  //Convert String in to Bytes
  lBufByte := StrToByte(AValue);

  SHA3_256Full(lDigest, lBufByte, Length(lBufByte));

  //HexStr is in mem_utils unit from the same CRC/Hash library
  Result := HexStr(@lDigest, SizeOf(lDigest));

  //Online Output check
  //http://emn178.github.io/online-tools/sha3_256.html
end;

//------------------------------------------------------------------------------

end.
