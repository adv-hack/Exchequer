unit IPUtil;

interface

type
  TIPBlocks = array[1..4] of byte;

  function GetIPBlock(iBlockNo : byte; sIPAddress : string) : integer;
  function GetStringFromIPBlocks(IPBlocks : TIPBlocks) : string;
  function GetIPBlocksFromString(sIPAddress : string) : TIPBlocks;
  function IPAddressMatch(Address1, Address2 : TIPBlocks) : boolean;

implementation
uses
  SysUtils;
  
function GetIPBlock(iBlockNo : byte; sIPAddress : string) : integer;
var
  iCurrBlock, iPos : integer;
  sResult : string;
begin
  // init
  iCurrBlock := 1;
  sResult := '';

  // go through each char in the string
  For iPos := 1 to Length(sIPAddress) do
  begin
    if sIPAddress[iPos] = '.' then inc(iCurrBlock)
    else begin
      if iBlockNo = iCurrBlock
      then sResult := sResult + sIPAddress[iPos];
    end;{if}
  end;{for}
  Result := StrToIntDef(sResult, 0);
end;

function GetStringFromIPBlocks(IPBlocks : TIPBlocks) : string;
begin
  Result := IntToStr(IPBlocks[1]) + '.' + IntToStr(IPBlocks[2]) + '.'
  + IntToStr(IPBlocks[3]) + '.' + IntToStr(IPBlocks[4]);
end;

function GetIPBlocksFromString(sIPAddress : string) : TIPBlocks;
var
  iPos : integer;
begin
  For iPos := 1 to 4
  do Result[iPos] := GetIPBlock(iPos, sIPAddress);
end;

function IPAddressMatch(Address1, Address2 : TIPBlocks) : boolean;
begin
  Result := (Address1[1] = Address2[1])
  and (Address1[2] = Address2[2])
  and (Address1[3] = Address2[3])
  and (Address1[4] = Address2[4]);
end;



end.
