unit BIExObj;

interface

uses
  BankIObj, CustAbsU;

type

  {$I BnkI01.inc}

  TBankIrExportObjectEx = Class(TBankIrExportObject)
    FileHeader1, FileTrailer1 : TBankIreFileHeaderRec1;
    FileHeader2, FileTrailer2 : TBankIreFileHeaderRec2;
    UserHeaderEx : TBankIreUserHeaderRec;
    procedure SetHeader(const EventData : TAbsEnterpriseSystem); override;
    function CreateOutFile(const AFileName : string;
                           const EventData : TAbsEnterpriseSystem) : integer; override;
    function CloseOutFile : integer; override;
  end;


implementation

{ TBankIrExportObjectEx }
uses
  EtDateU, Dialogs, ExpObj;

function RecToString(const ARec) : ShortString;
const
  REC_LEN = 80;
begin
  Result := StringOfChar(' ' , REC_LEN);
  Move(ARec, Result[1], REC_LEN);
end;


function TBankIrExportObjectEx.CloseOutFile: integer;
begin
  Move(FileHeader1, FileTrailer1, SizeOf(FileTrailer1));
  with FileTrailer1 do
  begin
    Str2_Char('EOF', LabelID, SizeOf(LabelID));
    LabelNo := '1';
  end;

  Move(FileHeader2, FileTrailer2, SizeOf(FileTrailer2));
  with FileTrailer2 do
  begin
    Str2_Char('EOF', LabelID, SizeOf(LabelID));
    LabelNo := '2';
  end;

{$I-}
  WriteLn(OutFile, RecToString(FileTrailer1));
  WriteLn(OutFile, RecToString(FileTrailer2));
{$I+}
  Result := IOResult;

  if Result = 0 then
    Result := inherited CloseOutFile
  else
    CloseFile(OutFile); //ensure that file is closed
end;

function TBankIrExportObjectEx.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
var
  OutString : string;
begin
  Result := CreateOutFileOnly(AFileName, EventData);

  if Result = 0 then
  begin
    ReadIniFile(EventData);
    SetHeader(EventData);

    with UserHeader do
      Str2_Char(GetFileNo, FileNo, SizeOf(FileNo));

    with VolHeader do
    begin
      Str2_Char(GetVolID(EventData), VolID, SizeOf(VolID));
      Str2_Char(EFTRec.UserID, OwnerID02, SizeOf(OwnerID02));
    end;

    with FileHeader1 do
    begin
      Move(VolHeader.VolID, SetID, SizeOf(SetID));
      Move(VolHeader.OwnerID02, FileID2, SizeOf(FileID2));
    end;

  {file should now be open for writing so we can write headers}
{$I-}
    WriteLn(OutFile, RecToString(VolHeader));
    WriteLn(OutFile, RecToString(FileHeader1));
    WriteLn(OutFile, RecToString(FileHeader2));
    WriteLn(OutFile, RecToString(UserHeaderEx));
{$I+}
    Result := IOResult;
  end;
end;

procedure TBankIrExportObjectEx.SetHeader(
  const EventData: TAbsEnterpriseSystem);
var
  TempString, DateString : String;
  TempInt : longint;

  function MakeDate(const ADate : string) : string;
  var
    i : Integer;
  begin
    i := JulianDate(ADate);
    if i > 0 then
      Result := ' ' + ZerosAtFront(i, 5)
    else
    begin
      ShowMessage('Invalid process date');
      Failed := flDate;
    end;
  end;

begin
  GetEventData(EventData);
  inherited SetHeader(EventData);

  FillChar(FileHeader1, SizeOf(FileHeader1), ' ');
  FillChar(FileHeader2, SizeOf(FileHeader2), ' ');
  FillChar(UserHeaderEx, SizeOf(UserHeaderEx), ' ');
  FillChar(FileTrailer1, SizeOf(FileTrailer1), ' ');
  FillChar(FileTrailer2, SizeOf(FileTrailer2), ' ');

  with EventData do
  begin
    with VolHeader do
    begin
      Filler2[33] := '1';
    end;


    with FileHeader1 do
    begin
      Str2_Char('HDR', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      FileID1     := 'A';
     {Authorized User ID as above}
      Str2_Char(EftRec.UserID, FileID2, SizeOf(FileID2));
      FileID3     := 'S';
      DateString := MakeDate(ProcControl.PDate);
      Str2_Char(DateString, CrDate, SizeOf(CrDate));
      DateString := MakeDate(CalcDueDate(ProcControl.PDate, 7));
      Str2_Char(DateString, ExpDate, SizeOf(ExpDate));

      Str2_Char('0001', FileSect, SizeOf(FileSect));
      Str2_Char('0001', FileSeq, SizeOf(FileSeq));

      Str2_Char('0000000', BlockCount, SizeOf(BlockCount));

    end;

    with FileHeader2 do
    begin
      Str2_Char('HDR', LabelID, SizeOf(LabelID));
      LabelNo     := '2';
      RecFormat   := 'F';

      Str2_Char('00000', BlockLen, SizeOf(BlockLen));
      Str2_Char('00100', RecLen, SizeOf(RecLen));

      Str2_Char('00', Offset, SizeOf(Offset));

    end;

    //EOF records will be populated in CreateOutFile


    with UserHeaderEx do
    begin
      Str2_Char('UHL', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      Move(FileHeader1.CrDate, ProcDate, SizeOf(ProcDate));
      Str2_Char('999999', ReceiverID, SizeOf(ReceiverID));
      Str2_Char('00', Currency, SizeOf(Currency));

      Str2_Char(ZerosAtFront(0,SizeOf(ZFiller2)),ZFiller2,SizeOf(ZFiller2));
      Str2_Char('1 DAILY  ', WorkCode, SizeOf(WorkCode));
      Str2_Char(GetFileNo, FileNumber, SizeOf(FileNumber));
    end;

    with UserTrailer do
    begin
      Filler1[36] := ' '; {replace '.' with space}
    end;

  end;
end;

end.
