unit AibObj;

interface

uses
  CustAbsU, ExpObj, Aib01, AibOpts;

type
     TAibEftObj = Class(TExportObject)
       protected
        {AIB files have headers & trailers - we'll populate
        these in the create method of the object, apart from
        User trailer which has sums & counts to include.  That can
        be done in the close file method.  Headers are written to file
        in the CreateOutFile method}
         VolHeader   : TAIBVolHeaderRec;
         FileHeader  : TAIBFileHeaderRec;
         UserHeader  : TAIBUserHeaderRec;
         UserTrailer : TAIBUserTrailerRec;
         function GetVolID : string;
         function GetFileNo : string;
       public
         EFTIniFile : string;
         EFTRec : TEftOptionsRec;
         constructor Create(const EventData : TAbsEnterpriseSystem);
         function CreateOutFile(const AFileName : string;
                                const EventData :
                                TAbsEnterpriseSystem) : integer; override;
         function CloseOutFile : integer; override;
         function WriteRec(const EventData : TAbsEnterpriseSystem;
                            Mode : word) : Boolean; override;
     end;

var
  AibEftObj : TAibEftObj;



implementation

uses
  SysUtils, Dialogs, Forms;



constructor TAibEftObj.Create(const EventData : TAbsEnterpriseSystem);
var
  TempString, DateString : String;
  TempInt : longint;
begin
  inherited Create;
  EFTIniFile := CheckPath(EventData.Setup.ssDataPath) + DefaultEFTIniFile;
  if not GetEftOptions(EFTIniFile, EftRec, True) then
    Failed := flUserID;
  with EventData do
  begin
    FillChar(VolHeader, SizeOf(TAIBVolHeaderRec), ' ');
    FillChar(FileHeader, SizeOf(TAIBFileHeaderRec), ' ');
    FillChar(UserHeader, SizeOf(TAIBUserHeaderRec), ' ');
    FillChar(UserTrailer, SizeOf(TAIBUserTrailerRec), ' ');
    GetEventData(EventData);
    with VolHeader do
    begin
      Str2_Char('VOL', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      Str2_Char(GetVolID, VolID, SizeOf(VolID));
      Str2_Char(EFTRec.UserID, OwnerID02, SizeOf(OwnerID02));
      Version     := '.';
    end;

    with FileHeader do
    begin
      Str2_Char('HDR', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      FileID1     := 'A';
{Authorized User ID as above}
      Str2_Char(EftRec.UserID, FileID2, SizeOf(FileID2));
      FileID3     := 'S';
      TempInt := JulianDate(ProcControl.PDate);
      if TempInt > 0 then
        DateString := ' ' + ZeroesAtFront(TempInt, 5)
      else
      begin
        ShowMessage('Invalid process date');
        Failed := flDate;
      end;
      Str2_Char(DateString, CreateDate, SizeOf(CreateDate));
      Delimiter   := '.';
    end;

    with UserHeader do
    begin
      Str2_Char('UHL', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      Str2_Char(DateString, ProcDate, SizeOf(ProcDate));
{For currency assume IEP unless Euro is specified}
      if Ord(ProcControl.PayCurr[1]) = 128 then {euro symbol we hope}
        TempString := '01'
      else
        TempString := '00';
{Check if we have multi-currency or euro version - if not then must be iep}
      if CurrencyVer = 0 then
        TempString := '00';
      Str2_Char(TempString, Currency, SizeOf(Currency));
      Str2_Char('000000', Reserved1, SizeOf(Reserved1));
      Str2_Char('1 DAILY  ', WorkCode, SizeOf(WorkCode));
      {can't set fileno here as i'm using payrun and that doesn't seem to
      be available yet - it appears to be 0 at the moment, yet when i do
      geteventdata again below in writerec it is the correct number}
{Leave userDef as spaces for the moment}
      Delimiter   := '.';
    end;

    with UserTrailer do
    begin
      Str2_Char('UTL', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      Delimiter   := '.';
    end;
  end; {with EventData}
end; {create}





function TAibEftObj.WriteRec(const EventData : TAbsEnterpriseSystem;
                             Mode : Word) : Boolean;
var
  OutRec : TAIBDataRec;
  TempStr : Str255;
  pence : longint;
  OutString : string;
  Target : TAbsCustomer;
begin
  GetEventData(EventData);

  FillChar(OutRec, SizeOf(OutRec), 32);
  with EventData, OutRec do
  begin
    if IsReceipt then
      Target := Customer
    else
      Target := Supplier;

    Case Mode of

    Contra : begin
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(DestAcc)), DestAcc, SizeOf(DestAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(DestSort)), DestSort, SizeOf(DestSort));
               AccType := '0';
               if IsReceipt then
                 TranCode := '99'
               else
                 TranCode := '17';
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(CompAcc)), CompAcc, SizeOf(CompAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(CompSort)), CompSort, SizeOf(CompSort));
               TempStr := '0000';
               Str2_Char(TempStr, Reserved1, SizeOf(Reserved1));
               TempStr := ZeroesAtFront(TotalPenceWritten, SizeOf(AmountP));
               Str2_Char(TempStr, AmountP, SizeOf(AmountP));
               TempStr := 'EFT ' + IntToStr(ProcControl.PayRun);
               Str2_Char(TempStr, CompName, SizeOf(CompName));
               TempStr := 'CONTRA';
               Str2_Char(TempStr, CompRef, SizeOf(CompRef));
               Str2_Char(Bacs_Safe(Setup.ssUserName), DestName, SizeOf(DestName));
              end;
    PayLine : begin
               Str2_Char(Target.acBankSort, DestSort, SizeOf(DestSort));
               Str2_Char(Target.acBankAcc, DestAcc, SizeOf(DestAcc));
               AccType := '0';
               {Note: there are four possible codes for direct debits: 01,17,18,19}
               if IsReceipt then
               begin
                 Case Target.acDirDebMode of
                   0  : TranCode := '01';
                   1  : TranCode := '17';
                   2  : TranCode := '18';
                   3  : TranCode := '19';
                 end; {Case}
               end
               else {Payment}
                 TranCode := '99';
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(CompAcc)), CompAcc, SizeOf(CompAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(CompSort)), CompSort, SizeOf(CompSort));
               TempStr := '0000';
               Str2_Char(TempStr, Reserved1, SizeOf(Reserved1));
               Pence := Pennies(Transaction.thTotalInvoiced);
               TempStr := ZeroesAtFront(Pence, SizeOf(AmountP));
               Str2_Char(TempStr, AmountP, SizeOf(AmountP));
               Str2_Char(Bacs_Safe(Setup.ssUserName), CompName, SizeOf(CompName));

               Str2_Char(Bacs_Safe(Target.acCompany), DestName, SizeOf(DestName));
               Str2_Char(Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun),
                           CompRef, SizeOf(CompRef));
               TotalPenceWritten := TotalPenceWritten + Pence;
               inc(TransactionsWritten);
             end; {not contra}
    end; {case}


  end; {with}
  {write record here}
  with OutRec do
  begin
    OutString :=  DESTSort +
                  DESTAcc   +
                  AccType +
                  TranCode  +
                  CompSort  +
                  CompAcc   +
                  Reserved1    +
                  AmountP   +
                  CompName  +
                  CompRef   +
                  DestName;
  end;
  Result := WriteThisRec(OutString);
end;



function TAibEftObj.CloseOutFile : integer;
var
  TempStr, OutString : string;
begin
{$I-}
  with UserTrailer do
  begin
   if IsReceipt then
   begin
    TempStr := ZeroesAtFront(0, SizeOf(TotalDr));
    Str2_Char(TempStr, TotalDr, SizeOf(TotalDr));
    TempStr := ZeroesAtFront(0, SizeOf(CountDr));
    Str2_Char(TempStr, CountDr, SizeOf(CountDr));
    TempStr := ZeroesAtFront(TotalPenceWritten, SizeOf(TotalCr));
    Str2_Char(TempStr, TotalCr, SizeOf(TotalCr));
    TempStr := ZeroesAtFront(TransactionsWritten, SizeOf(CountCr));
    Str2_Char(TempStr, CountCr, SizeOf(CountCr));
   end
   else {payment}
   begin
    TempStr := ZeroesAtFront(TotalPenceWritten, SizeOf(TotalDr));
    Str2_Char(TempStr, TotalDr, SizeOf(TotalDr));
    TempStr := ZeroesAtFront(TransactionsWritten, SizeOf(CountDr));
    Str2_Char(TempStr, CountDr, SizeOf(CountDr));
    TempStr := ZeroesAtFront(0, SizeOf(TotalCr));
    Str2_Char(TempStr, TotalCr, SizeOf(TotalCr));
    TempStr := ZeroesAtFront(0, SizeOf(CountCr));
    Str2_Char(TempStr, CountCr, SizeOf(CountCr));
   end;

    OutString := LabelID +
                 LabelNo +
                 TotalDr +
                 TotalCr +
                 CountDr +
                 CountCr +
                 Reserved +
                 Delimiter;
  end;

  WriteLn(OutFile, OutString);


  CloseFile(OutFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to close file ' + OutFileName, '');
{$I+}
end;

function TAibEftObj.GetVolID : string;
var
  s : string;

  Procedure CheckForZeros(var st : string);
  var
    i : Integer;
    OK : Boolean;
  begin
    OK := False;
    i := 1;
    while (i < Length(s)) and not OK do
    begin
      if (s[i] <> ' ') and (s[i] <> '0') then
        OK := True;
      inc(i);
    end;
    if Not OK then
      s[1] := 'X';
  end;

begin
  s :=  Copy(EFTRec.VolPrefix, 1, 4);
  {can't have all zeros in a volume id}
  if (EFTRec.VolNo = 0) then
  begin
    if (Length(s) = 0) then
      s := 'X'
    else
      CheckForZeros(s);
  end;

  Result := s + ZeroesAtFront(longint(EFTRec.VolNo), 6 - Length(s));
end;

function TAibEftObj.GetFileNo : string;
begin
  Result := ZeroesAtFront(ProcControl.PayRun mod (MaxFileNo + 1), 3);
end;

function TAibEftObj.CreateOutFile(const AFileName : string;
                                  const EventData : TAbsEnterpriseSystem) : integer;
var
  OutString : string;
begin

  Result := inherited CreateOutFile(AFileName, EventData);

  with UserHeader do
    Str2_Char(GetFileNo, FileNo, SizeOf(FileNo));


  if Result = 0 then
  begin
  {file should now be open for writing so we can write headers}
{$I-}
   with VolHeader do
   begin
     OutString :=  LabelID    +
                   LabelNo    +
                   VolID      +
                   Access     +
                   Reserved1  +
                   OwnerID01  +
                   OwnerID02  +
                   OwnerID03  +
                   Reserved2  +
                   NA1        +
                   Reserved3  +
                   PhysLength +
                   NA2        +
                   Reserved4  +
                   Version;

     WriteLn(OutFile, OutString);
   end; {with VolHeader}

   with FileHeader do
   begin
     OutString :=  LabelID    +
                   LabelNo    +
                   Reserved1  +
                   FileID1    +
                   FileID2    +
                   FileID3    +
                   FileID4    +
                   NA1        +
                   RecFormat  +
                   NA2        +
                   SectionNo  +
                   CreateDate +
                   NA3        +
                   ExpDate    +
                   VerifyCopy +
                   NA4        +
                   Delimiter;
     WriteLn(OutFile, OutString);
   end; {with FileHeader}

   with UserHeader do
   begin
     OutString := LabelID   +
                  LabelNo   +
                  ProcDate  +
                  RecID     +
                  Currency  +
                  Reserved1 +
                  WorkCode  +
                  FileNo    +
                  Reserved2 +
                  UserDef   +
                  Delimiter;
     WriteLn(OutFile, OutString);
   end; {with UserHeader}
   Result := IOResult;
  end; {if Result = 0}
{$I+}
end; {CreateOutFile}






end.
