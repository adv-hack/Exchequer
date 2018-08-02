unit gs6_encrxm;
interface
uses
   SysHalc, SysUtils;

function Encryption(const Key: string; BufferIn, BufferOut: PByteArray; ReadOrWrite, Size: Integer): Integer;

implementation

function Encryption(const Key: string; BufferIn, BufferOut: PByteArray; ReadOrWrite, Size: Integer): Integer;
var
   i: integer;
   k: integer;
begin
   Result := 0;
   if (Length(Key) = 0) then
   begin
      if BufferIn <> BufferOut then
         Move(BufferIn^,BufferOut^,Size);
      exit;
   end;
   if ReadOrWrite = 0 then  {Read operation, so decrypt}
   begin
      k := 1;
      for i := 0 to Size-1 do
      begin
         BufferOut^[i] := BufferIn^[i] xor (byte(Key[k]) or (i and $FF));
         inc(k);
         if k > length(Key) then k := 1;
      end;
      Result := -1;   {Decrypted}
   end
   else
   begin                    {write operation, so encrypt}
      k := 1;
      for i := 0 to Size-1 do
      begin
         BufferOut^[i] := BufferIn^[i] xor (byte(Key[k]) or (i and $FF));
         inc(k);
         if k > length(Key) then k := 1;
      end;
      Result := 1;       {Encrypted}
   end;
end;

end.
