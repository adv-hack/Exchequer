program FileList;
{$APPTYPE CONSOLE}
uses
   Windows, SysUtils, gs6_Shel;

var
   MyTable: TgsDBFTable;

procedure WaitForKey;
var
   sh: THandle;
   bf: array[0..80] of char;
   {$IFDEF VER120}
   bc: longword;
   {$ELSE}
   bc: integer;
   {$ENDIF}
begin
   sh := GetStdHandle(STD_INPUT_HANDLE);
   FillChar(bf,SizeOf(bf),#0);
   SetConsoleMode(sh,0);
   repeat
      ReadConsole(sh,@bf,1,bc,nil);
   until bf[0] <> #0;
end;

procedure Main;
begin
   MyTable := TgsDBFTable.Create('Master.DBF',true,true); {ReadWrite and Shared}
   MyTable.Index('MASTER.MDX','SYMBOL');
   MyTable.First;
   while not MyTable.EOF do
   begin
      Writeln(MyTable.StringGet('SYMBOL'),
              '':10-length(MyTable.StringGet('SYMBOL')),
              MyTable.StringGet('CO_NAME'));
      MyTable.Next;
   end;

   {Demonstrate moving to a specific record}
   MyTable.RecNo := 5;
   Writeln('Here is record 5 again:');
   Writeln(MyTable.StringGet('SYMBOL'),
           '':10-length(MyTable.StringGet('SYMBOL')),
           MyTable.StringGet('CO_NAME'));

   {Demonstrate finding a specific record}
   if MyTable.Find('VG',true,true) then     {Exact match and find nearest}
   begin
      Writeln('Here is record with symbol "VG":');
      Writeln(MyTable.StringGet('SYMBOL'),
              '':10-length(MyTable.StringGet('SYMBOL')),
              MyTable.StringGet('CO_NAME'));
   end
   else
      Writeln('Could not find record with symbol "VG":');


   MyTable.Free;
end;

begin
   try
      Main;
   except
      on E: Exception do
      begin
         Writeln(E.Message);
      end;
   end;
   Write('Press any key to terminate.');
   WaitForKey;
end.
