unit ExpObj;

{Base object for BACS-type exporting.  Implements standard methods for opening,
closing & deleting files and showing reports to the user.  WriteRec
method is abstract and should be implemented by descendents.  TExportControl rec
may need to be extended to meet the needs of descendent classes}

interface

uses CustAbsU, Classes;

const
  flBank   = 1;
  flFile   = 2;
  flRec    = 3;
  flContra = 4;
  flDate   = 5;
  flUserID = 6;
  flNoRecs = 7;
  flSystem = 8;

  wrContra = 0;
  wrPayLine = 1;

  DefaultSortLength = 6;
  DefaultACLength = 8;

  LogFileName = 'Bacs.log';


type

  Str255 = ShortString;

  TExportControl = Record   {used in GetEventData}
     CtrlGL     : LongInt;
     BankGl     : LongInt;
     SalesPurch : Boolean;
     Amount     : Double;
     PayRun     : LongInt;
     PayCurr    : String[3];
     TMode      : Byte;
     PDate      : String[8];
  end;


  TExportObject  = Class
       OutFile : TextFile;
       OutFileName : string;
       RunAborted : Boolean;
       FFailed : SmallInt;
       ProcControl : TExportControl;
       TotalPenceWritten : int64;
       TransactionsWritten : longint;
       IsReceipt    : Boolean;
       AlreadyRejected : Boolean; {to avoid multiple showing of reject dialog}
       RequiredPath : string; {path to put files - set in Create method of wrapper object}
       Log  : TStringList;
       LogFull : Boolean;
       constructor Create;
       destructor Destroy; override;
       function CreateOutFile(const AFileName : string;
                              const EventData :
                              TAbsEnterpriseSystem) : integer; overload; virtual;
       function EraseOutFile : Boolean; virtual;
       function CloseOutFile : integer; virtual;
       function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
                                      virtual;
       function WriteRec(const EventData : TAbsEnterpriseSystem;
                          Mode : word) : Boolean; virtual; abstract;
       function WriteThisRec(const RecString : string) : Boolean; virtual;
       function ZeroesAtFront(AValue : longint; ASize : integer) : Str255;
       function AllDigits(const s : string) : Boolean;
       function IsDigit(c : Char) : Boolean;
       function MakeDigits(const s : string; Size : byte) : string;
       Function Pennies(Inum  :  Real) : LongInt;
       Procedure Str2_Char(const LStr   :  Str255;
                             Var CharAry;
                                 SO     :  Integer);
       Procedure Str2_CharRight(const LStr   :  Str255;
                                  Var CharAry;
                                      SO     :  Integer);
       function CheckPath(const ThePath : string) : string;
       procedure GetEventData(const EventData : TAbsEnterpriseSystem); virtual;
       procedure ShowExportReport(const Cap : string; Messages : TStrings);
       procedure ShowExportMessage(const Cap : string; const Msg1, Msg2 : string);
       function BACS_Safe(TStr  :  Str255)  :  Str255; virtual;
       function JulianDate(const ADate : String) : longint;
       function StandardDate(const ADate : string) : string;
       function RemoveHyphens(const s : string) : string;
       function DirectDebitCode(mode : Byte) : string; virtual;
       function IsBlank(const s : string) : Boolean;
       procedure ErrorReport(const EventData : TAbsEnterpriseSystem; Mode : Byte);
       function GetTarget(const EventData : TAbsEnterpriseSystem) : TAbsCustomer;
       function Pounds(pence : longint) : string;
       function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; virtual;
       procedure CompletionMessage(const EventData : TAbsEnterpriseSystem); virtual;
       function FileNameOnly(const AFileName : string) : string;
       procedure LogIt(const Msg : string);
       procedure SetFailed(FNo : smallint);
       function FailString(Fno : smallint) : string;

       property Failed : smallint read FFailed
                                  write SetFailed;
    end;




implementation

uses
  Dialogs, SysUtils, ExpRep, ExpMsg, Forms;

constructor TExportObject.Create;
begin
  inherited Create;
  Log := TStringList.Create;
  Log.Add('Run Date: ' + DateToStr(Date));
  Log.Add('Start Time: ' + TimeToStr(Time));
  LogFull := False;
  TotalPenceWritten := 0;
  Failed := 0;
  RunAborted := False;
  TransactionsWritten := 0;
  AlreadyRejected := False;
end;

destructor TExportObject.Destroy;
begin
  LogIt('Run complete');
  Try
    Log.SaveToFile(RequiredPath + LogFileName);
  Finally
    Log.Free;
  End;
  inherited Destroy;
end;

function TExportObject.CreateOutFile(const AFileName : string;
                                     const EventData :
                                     TAbsEnterpriseSystem) : integer;
begin
{$I-}
  GetEventData(EventData);
  IsReceipt := ProcControl.SalesPurch;
  RequiredPath := CheckPath(EventData.Setup.ssDataPath);
  OutFileName := AFilename;
  AssignFile(OutFile, AFileName);
  Rewrite(OutFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to create file ' + AFileName,
                        'This run has been aborted')
  else
    LogIt('File created: ' + AFileName);
{$I+}
end;

function TExportObject.CloseOutFile : integer;
begin
{$I-}
  CloseFile(OutFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to close file ' + OutFileName, '')
  else
    LogIt('File closed: ' + OutFileName);
{$I+}
end;

function TExportObject.EraseOutFile : Boolean;
{assumes that the file has been closed}
begin
  Result := DeleteFile(OutFileName);
  if not Result then {could still be open so let's try just in case}
  begin
    if CloseOutFile = 0 then
     Result := DeleteFile(OutFileName);
  end;
  if not Result  then
    ShowExportMessage('Warning','Unable to erase file ' + OutFileName, '')
  else
    LogIt('File erased: ' + OutFileName);
end;


procedure TExportObject.GetEventData(const EventData : TAbsEnterpriseSystem);
begin
  With EventData, ProcControl do
  begin
    PayRun := Stock.stStockFolio;
    CtrlGL := Stock.stSalesGL;
    BankGl := Stock.stCosgl;
    SalesPurch := Stock.stReOrderFlag;
    Amount := entRound(Stock.stQtyFreeze, 2);
    PayCurr := Stock.stLocation;
    TMode := Stock.stReOrderCur;
    PDate := Stock.stLastUsed;
  end;
end;

function TExportObject.AllDigits(const s : string) : Boolean;
var
  i : integer;
begin
  Result := True;
  for i := 1 to Length(s) do
  begin
    if not (s[i] in ['0'..'9']) then
    begin
      Result := False;
      Break;
    end;
  end;
end;



Procedure TExportObject.Str2_Char(const LStr   :  Str255;
                                    Var CharAry;
                                        SO     :  Integer);
var
  TempStr : Str255;
  MoveSize : integer;
begin
  TempStr := Copy(LStr, 1, SO);
  if Length(TempStr) < SO then
    MoveSize := Length(TempStr)
  else
    MoveSize := SO;
  Move(TempStr[1], CharAry, MoveSize);
end;

Procedure TExportObject.Str2_CharRight(const LStr   :  Str255;
                                         Var CharAry;
                                             SO     :  Integer);
{same as Str2_Char but right justified with leading spaces}
var
  TempStr : Str255;
begin
  TempStr := Copy(LStr, 1, SO);
  while Length(TempStr) < SO do
  begin
    Application.ProcessMessages;
    TempStr := Copy('              ', 1, SO - Length(TempStr)) + TempStr;
  end;
  Move(TempStr[1], CharAry, SO);
end;

function TExportObject.ZeroesAtFront(AValue : longint; ASize : integer) : Str255;
begin
  Result := Format('%.*d',[ASize, AValue]);
end;

Function TExportObject.Pennies(Inum  :  Real) : LongInt;
Begin
  Pennies:=Round(Inum * 100);
end;

function TExportObject.CheckPath(const ThePath : string) : string;
{takes in a path and adds a backslash at the end if necessary}
var
  i : integer;
begin
  i := Length(ThePath);

  if (i = 0) or (ThePath[i] <> '\') then
    Result := ThePath + '\'
  else
    Result := ThePath;
end;

function TExportObject.MakeDigits(const s : string; Size : byte) : string;
var
  i, j : integer;
begin
  Result := s;
  j := Length(s);
  if j < Size then
    for i := 1 to (Size - j) do
      Result := '0' + Result;

  for i := 1 to Length(Result) do
    if not (Result[i] in ['0','1'..'9']) then
      Result[i] := '0';
end;

procedure TExportObject.ShowExportReport(const Cap : string; Messages : TStrings);
{Display a multi-line report to the user, using a memo}
var
  frmExportReport : TfrmExportReport;
begin
  frmExportReport := TfrmExportReport.Create(Application);
  with frmExportReport do
  begin
   Try
    Caption := cap;
    ReportMemo.Lines.AddStrings(Messages);
    ShowModal;
   Finally
    Free;
   End;
  end;
end;

procedure TExportObject.ShowExportMessage(const Cap : string; const Msg1, Msg2 : string);
{Display a one or two line message to the user, adjusting the width of the dialog according
to the length(s) of the message(s)}
var
  frmExportMsg: TfrmExportMsg;
  BiggerLabel : integer;
begin
  frmExportMsg := TfrmExportMsg.Create(Application);
  with frmExportMsg do
  begin
   Try
    Caption := Cap;
    Label1.Caption := Msg1;
    Label2.Caption := Msg2;
    BiggerLabel := Label2.Width;
    if Label1.Width > Label2.Width then
      BiggerLabel := Label1.Width;
    Width := BiggerLabel + 48;
    if Width < (Button1.Width + 96) then
    begin
      Width := Button1.Width + 96;
    end;
    Label1.Left := (Width div 2) - (Label1.Width div 2);
    Label2.Left := (Width div 2) - (Label2.Width div 2);

    Button1.Left := (Width div 2) - (Button1.Width div 2);
    if Msg2 = '' then
    begin
      Height := Height - 24;
      Button1.Top := Button1.Top - 24;
      Label2.Visible := False;
    end;
    ShowModal;
    LogIt('Message: ' + Cap + ' | ' + Msg1 + ' | ' + Msg2);
   Finally
    Free;
   End;
  end;
end;

Function TExportObject.BACS_Safe(TStr  :  Str255)  :  Str255;
Const
  BACSAll :  Set of Char = [#32,'&','-','.','/','0'..'9','A'..'Z'];

Var
  L,n  :  Byte;

Begin
  L:=Length(TStr);

  For n:=1 to L do
  Begin
    TStr[n]:=Upcase(Tstr[n]);
    If (Not (TStr[n] In BACSAll)) then
      TStr[n]:=#32;
  end;

  BACS_Safe:=TStr;
end;

function TExportObject.ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
{check if bank a/c & sort code are available & don't include invalid chars. This method
uses default sort & account lengths of 6 & 8.  If these are different in a descendent
then this method must be overriden}
var
  TempStr : string;
  Target : TAbsCustomer;
begin
  Result := True;
  GetEventData(EventData);
  with EventData do
  begin
    Target := GetTarget(EventData);

    if Target.acPayType <> 'B' then
    begin
      Result := False;
      LogIt(Target.acCompany + ': PayType not set to Bacs');
      Exit;
    end;
    TempStr := Target.acBankAcc;
    if (Length(TempStr) <> DefaultACLength) or not AllDigits(TempStr) then
    begin
      Result := False;
      LogIt(Target.acCompany + ': Invalid account - ' + TempStr);
      Exit;
    end;
    TempStr := Target.acBankSort;
    if (Length(TempStr) <> DefaultSortLength) or not AllDigits(TempStr) then
    begin
      LogIt(Target.acCompany + ': Invalid sort code - ' + TempStr);
      Result := False;
      Exit;
    end;
  end; {with EventData}
end;


function TExportObject.WriteThisRec(const RecString : string) : Boolean;
begin
{$I-}
  WriteLn(OutFile, RecString);
  Result := (IOResult = 0);
  if not Result then
  begin
    ShowExportMessage('Warning','Unable to write record ' + IntToStr(TransactionsWritten)
                  + ' to file', 'This run has been aborted');
    Failed := flFile;
  end;
{$I+}
end;


function TExportObject.JulianDate(const ADate : String) : longint;
var
  TempString : string;
  YearStart, DateInQuestion : TDateTime;
  StoreDateFormat : string;
  StoreDateSeparator : Char;
begin
  YearStart := 0;
  DateInQuestion := 0;
  if Length(ADate) < 8 then
  begin
    Result := 0;
    Exit;
  end;
  StoreDateFormat := ShortDateFormat;
  StoreDateSeparator := DateSeparator;
  ShortDateFormat := 'dd/mm/yyyy';
  DateSeparator := '/';
  TempString := Copy(ADate, 7, 2) + '/' +
                Copy(ADate, 5, 2) + '/' +
                Copy(ADate, 1, 4);
  Try
    DateInQuestion := StrToDate(TempString);
  Except
    DateInQuestion := 0;
  End;

  if DateInQuestion <> 0 then
  begin
   Try
     YearStart := StrToDate('01/01/' + Copy(ADate, 1, 4));
   Except
     YearStart := 0;
   End;
  end;

  ShortDateFormat := StoreDateFormat;
  DateSeparator := StoreDateSeparator;

  if (YearStart > 0) and (DateInQuestion > 0) then
   Result := Succ(Round(DateInQuestion - YearStart))
  else
   Result := 0;

end;


function TExportObject.RemoveHyphens(const s : string) : string;
var
  i : integer;
begin
  Result := s;
  i := 1;
  while i < Length(Result) do
    if Result[i] = '-' then
      Delete(Result, i, 1)
    else
      inc(i);
end;

function TExportObject.DirectDebitCode(mode : Byte) : string;
{Note: there are four possible codes for direct debits: 01,17,18,19.  Mode is
the customer.acDirDebMode}

begin
  Case Mode of
     0  : Result := '01';
     1  : Result := '17';
     2  : Result := '18';
     3  : Result := '19';
   else
   begin
     Result := 'NA';
     LogIt('Unknown direct debit mode: ' + IntToStr(mode));
   end;
  end;
end;

function TExportObject.IsBlank(const s : string) : Boolean;
var
  i, j : integer;
begin
  Result := True;
  i := 1;
  j := Length(s);
  while Result and (i < j) do
  begin
    Application.ProcessMessages;
    Result := (s[i] = ' ');
    inc(i);
  end;
end;

procedure TExportObject.ErrorReport(const EventData : TAbsEnterpriseSystem; Mode : Byte);
{we're not using mode yet but it could come in handy}
var
  TheList : TStringList;
  Target  : TAbsCustomer;
begin
  TheList := TStringList.Create;
  with TheList, EventData do
  begin
    GetEventData(EventData);
    Target := GetTarget(EventData);

    Try
      Add(Setup.ssUserName);
      Add('Batch processing run no. ' + IntToStr(ProcControl.PayRun));
      Add('');
      Add('Run aborted');
      Add('');
      if Failed = flBank then
        Add('Check bank details for ' + Target.acCode + ', ' +
                                       Target.acCompany)
      else
        Add('Details will be shown on the Batch Payment Status report');
      Add('');
      Add('Press ''Close'' to continue');
      ShowExportReport('Batch processing run no. ' + IntToStr(ProcControl.PayRun),
                                  TheList);
    Finally
      TheList.Free;
    End;
  end; {TheList}
end;

function TExportObject.GetTarget(const EventData : TAbsEnterpriseSystem) : TAbsCustomer;
begin
  with EventData do
  begin
    if IsReceipt then   {isreceipt is set when we open the outfile}
      Result := Customer
    else
      Result := Supplier;
  end;
end;

function TExportObject.Pounds(pence : longint) : string;
{show value in pence as pounds - bfi approach : just put a '.' in before the last two digits}
begin
  Result := ZeroesAtFront(pence, 3); {i.e. minimum final string of 0.00}
  Insert('.', Result, Length(Result) - 1);
end;

function TExportObject.ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean;
{check user bank a/c & sort code}
var
  TempStr : string;
begin
  LogIt('Validate system');
  with EventData.Setup do
  begin
    TempStr := ssUserAcc;
    if (Length(TempStr) <> DefaultACLength) or not AllDigits(TempStr) then
    begin
      Result := False;
      failed := flBank;
      Exit;
    end;
    TempStr := ssUserSort;
    if (Length(TempStr) <> DefaultSortLength) or not AllDigits(TempStr) then
    begin
      Result := False;
      failed := flBank;
      Exit;
    end;
  end; {with EventData.Setup}
end;

procedure TExportObject.CompletionMessage(const EventData : TAbsEnterpriseSystem);
var
  ReportMemo : TStringList;
  TotalValue : Real;
begin
  if Failed = 0 then
  with EventData do
  begin
     ReportMemo := TStringList.Create;
     Try
       ReportMemo.Add(Setup.ssUserName);
       ReportMemo.Add('Batch processing run no. ' + IntToStr(ProcControl.PayRun));
       ReportMemo.Add('');
       ReportMemo.Add('Total number of transactions: ' + IntToStr(TransactionsWritten));
       TotalValue := TotalPenceWritten / 100;
       ReportMemo.Add('Value: ' + TrimRight(ProcControl.PayCurr) +
            Format('%.2n',[TotalValue]));
       ReportMemo.Add('');

       ReportMemo.Add('Batch process completed successfully');
       ReportMemo.Add('Written to file: ' + OutFileName);
       ReportMemo.Add('');
       ReportMemo.Add('Press ''Close'' to continue printing reports');
       ShowExportReport('Batch processing run no. ' + IntToStr(ProcControl.PayRun),
                         ReportMemo);
     Finally
      ReportMemo.Free;
     End;
  end;
end;

function TExportObject.FileNameOnly(const AFileName : string) : string;
var
  i : integer;
begin
  i := Length(AFileName);
  while (i > 0) and (AFileName[i] <> '\') do dec(i);
  if i > 0 then
    Result := Copy(AFileName, i + 1, Length(AFileName))
  else
    Result := AFileName;
end;


function TExportObject.IsDigit(c : Char) : Boolean;
begin
  Result := c in ['0'..'9'];
end;

function TExportObject.StandardDate(const ADate : string) : string;
{converts yyyymmdd to standard dd/mm/yy}
begin
  if Length(ADate) <> 8 then
    Result := 'N/A'
  else
    Result := Copy(ADate, 7, 2) + '/' +
              Copy(ADate, 5, 2) + '/' +
              Copy(ADate, 3, 2);
end;

procedure TExportObject.LogIt(const Msg : string);
begin
  if Assigned(Log) and not LogFull then
  begin
   Try
    Log.Add(TimeToStr(Time) + ':' + 'Tr:' +
             IntToStr(TransactionsWritten) + ': ' + Msg);
   Except
    LogFull := True;
   End;
  end;
end;

procedure TExportObject.SetFailed(FNo : smallint);
begin
  FFailed := FNo;
  Logit('Failed: ' + FailString(FNo));
end;

function TExportObject.FailString(Fno : smallint) : string;
begin
  Case FNo of
    1 : Result := 'Invalid Bank details';
    2 : Result := 'File error';
    3 : Result := 'Invalid record';
    4 : Result := 'Invalid contra';
    5 : Result := 'Invalid Date';
    6 : Result := 'Invalid UserID';
    7 : Result := 'No Records';
    8 : Result := 'Invalid system details';
  end;
end;



end.
