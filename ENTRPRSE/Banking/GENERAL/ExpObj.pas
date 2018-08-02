unit ExpObj;

{ prutherford440 15:10 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{Base object for BACS-type exporting.  Implements standard methods for opening,
closing & deleting files and showing reports to the user.  WriteRec
method is abstract and should be implemented by descendents.  TExportControl rec
may need to be extended to meet the needs of descendent classes.

TExportControl is now a class so that we can inherit from it in order to extend
it if necessary}

//TODO: Separate parts of ValidateRec & ValidateSystem into ValidateSortCode, ValidateAccNo, etc to allow better handling of
//      odd formats in descendants

interface

{$H-}

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
  flCurrency = 9;
  flTooManyRecs = 10; //Santander allows 9999 lines per file
  flDDMode = 11;
  flDDMandate = 12;
  flDDMandateDate = 13;
  flAddress = 14;

  wrContra = 0;
  wrPayLine = 1;


  LogFileName = 'Bacs.log';
  VAOIniFilename = 'VAOBacs.ini';

type

  Str255 = ShortString;

  TExportControl = Class   {used in GetEventData}
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
       FileRejected : Boolean;
       RequiredPath : string; {path to put files - set in Create method of wrapper object}
       Log, RejectList  : TStringList;
       LogPath : string;
       LogFull : Boolean;
       //PR: 02/10/2012 Extended lengths of sort/acc/ref.
       //PR: 17/09/2013 ABSEXCH-14620 Removed lengths.
       UserBankSort : String;
       UserBankAcc  : String; //extended to 11 chars for First National Bank
       UserBankRef  : String;
       HookName : string;
       DataPath, EntPath : string;
       DefaultSortLength,
       DefaultACLength : Byte;
       constructor Create;
       destructor Destroy; override;
       function EuroFormat(const Value : string) : string;  overload; virtual;
       function EuroFormat(const Value : Double) : string; overload; virtual;
       function LJVar(const s : string; c : integer) : string;
       function RJVar(const s : string; c : integer) : string;
       function CreateOutFile(const AFileName : string;
                              const EventData :
                              TAbsEnterpriseSystem) : integer;  overload; virtual;
       function CreateOutFile(const AFileName : AnsiString;
                              const EventData :
                              TAbsEnterpriseSystem) : integer;  overload; virtual;
       function EraseOutFile : Boolean; virtual;
       function CloseOutFile : integer; virtual;
       function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
                                      virtual;
       function WriteRec(const EventData : TAbsEnterpriseSystem;
                          Mode : word) : Boolean; virtual; abstract;
       function WriteThisRec(const RecString : string) : Boolean; overload;
       function WriteThisRec(const RecString : AnsiString) : Boolean; overload;
       function ZerosAtFront(AValue : Int64; ASize : integer) : Str255;  overload;
       function ZerosAtFront(const AValue : string; ASize : integer) : Str255; overload;
       //PR: 04/10/2012 Added extra overload for floating point numbers
       function ZerosAtFront(AValue : Double; ASize : integer) : Str255;  overload;
       function AllDigits(const s : string) : Boolean;
       function AllDigitsWithHyphen(const ACode : string) : Boolean; overload;
       function AllDigitsWithHyphen(const ACode: String; AHyphenPos: Integer) : Boolean; overload;
       function IsDigit(c : Char) : Boolean;
       function MakeDigits(const s : string; Size : byte) : string;
       Function Pennies(Inum  :  Real) : int64;
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
       function JulianDateStr(const ADate : String) : string;
       function StandardDate(const ADate : string) : string;
       function RemoveHyphens(const s : string) : string;
       function DirectDebitCode(mode : Byte) : string; virtual;
       function IsBlank(const s : string) : Boolean;
       procedure ErrorReport(const EventData : TAbsEnterpriseSystem; Mode : Byte);
       function GetTarget(const EventData : TAbsEnterpriseSystem) : TAbsCustomer;
       function Pounds(pence : longint) : string; overload;
       function Pounds(pence : longint; ASize : Integer) : string; overload;
       function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; virtual;
       procedure CompletionMessage(const EventData : TAbsEnterpriseSystem); virtual;
       function FileNameOnly(const AFileName : string) : string;
       procedure LogIt(const Msg : string);
       procedure SetFailed(FNo : smallint);
       function FailString(Fno : smallint) : string;
       procedure RejectRecord(const EventData : TAbsEnterpriseSystem);
       function YYMMDD(const ADate : string) : string;
       function DDMMYY(const ADate : string) : string;
       function DDMMYYYY(const ADate : string) : string;
       function MMDDYYYY(const ADate : string) : string;
       function GetSortCode(const s : string) : string; virtual;
       function DQuotedStr(const s : string) : string; virtual;
       function DQuotedStrEx(const s : string; FollowingComma : Boolean = True) : string; virtual;
       procedure Initialize; virtual;
       function FormatSortCode(SortCode : string) : string; virtual;
       function DayOfYear(const ADate : string) : Integer;
       property Failed : smallint read FFailed
                                  write SetFailed;

    end;




implementation

uses
  Dialogs, SysUtils, ExpRep, ExpMsg, Forms, FileUtil, IniFiles, StrUtils, DateUtils;

constructor TExportObject.Create;
begin
  inherited Create;
  ProcControl := TExportControl.Create;
  Log := TStringList.Create;
  RejectList := TStringList.Create;
  LogPath := '';
  DefaultSortLength := 6;
  DefaultACLength := 8;
{  Try
    Log.LoadFromFile(RequiredPath + LogFileName);
  Except;
  End;
  if Log.Count > 5000 then
  begin
    Log.SaveToFile(RequiredPath + ChangeFileExt(LogFileName, '.bak'));
    Log.Clear;
  end;
  Log.Add('BACS Export log');
  Log.Add('Run Date: ' + DateToStr(Date));
  Log.Add('Start Time: ' + TimeToStr(Time));
  LogFull := False;}
  TotalPenceWritten := 0;
  Failed := 0;
  RunAborted := False;
  TransactionsWritten := 0;
  FileRejected := False;
end;

destructor TExportObject.Destroy;
begin
  if Trim(LogPath) <> '' then
  Try
    LogIt('Run complete');
    Log.SaveToFile(LogPath + LogFileName);
  Finally
    Log.Free;
    RejectList.Free;
  End;
  if Assigned(ProcControl) then
    ProcControl.Free;
  inherited Destroy;
end;

function TExportObject.LJVar(const s : string; c : integer) : string;
begin
  Result := Copy(s + StringOfChar(' ', c), 1, c);
end;

function TExportObject.RJVar(const s : string; c : integer) : string;
begin
  Result := Copy(s, 1, c);
  if Length(Result) < c then
    Result := StringOfChar(' ', c - Length(Result)) + Result;
end;

function TExportObject.CreateOutFile(const AFileName : string;
                                     const EventData :
                                     TAbsEnterpriseSystem) : integer;
var
  VAOPath : string;
  LRequiredPath : String;
begin
{$I-}
  GetEventData(EventData);
  IsReceipt := ProcControl.SalesPurch;
  LRequiredPath := CheckPath(EventData.Setup.ssDataPath);
  with TIniFile.Create(LRequiredPath + VAOIniFilename) do
  Try
    VAOPath := CheckPath(ReadString('Paths','Output',''));
  Finally
    Free;
  End;
  OutFileName := AFilename;
  if VAOPath <> '' then
    OutFileName := VAOPath + ExtractFilename(OutFilename);
  AssignFile(OutFile, OutFileName);
  Rewrite(OutFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to create file ' + OutFileName,
                        'This run has been aborted')
  else
    LogIt('File created: ' + AFileName);
{$I+}
end;

function TExportObject.CreateOutFile(const AFileName : AnsiString;
                                     const EventData :
                                     TAbsEnterpriseSystem) : integer;
var
  s : string;
begin
  s := AFilename;
  Result := CreateOutFile(s, EventData);
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
    Try
      Amount := entRound(Stock.stQtyFreeze, 2);
    Except
      Amount := 0;
    end;
    PayCurr := Stock.stLocation;
    TMode := Stock.stReOrderCur;
    PDate := Stock.stLastUsed;
  end;
end;

function TExportObject.AllDigits(const s : shortstring) : Boolean;
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

function TExportObject.ZerosAtFront(AValue : Int64; ASize : integer) : Str255;
begin
  //This functionality only works for ASize <= 16
  //  Result := Format('%.*d',[ASize, AValue]);
  //Replace with this:
  Result := IntToStr(AValue);
  Result := StringOfChar('0', ASize - Length(Result)) + Result;
end;

function TExportObject.ZerosAtFront(const AValue : string; ASize : integer) : Str255;
begin
  Result := ZerosAtFront(StrToInt64(AValue), ASize);
end;

Function TExportObject.Pennies(Inum  :  Real) : int64;
Begin
  Result :=Round(Inum * 100);
end;

function TExportObject.CheckPath(const ThePath : string) : string;
{takes in a path and adds a backslash at the end if necessary}
var
  i : integer;
begin
  Result := Trim(ThePath);
  if Result <> '' then
    Result := IncludeTrailingBackslash(ThePath);
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
    Caption := Hookname + ' - ' + cap;
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
    end;
    TempStr := Target.acBankAcc;
    if (Length(TempStr) <> DefaultACLength) or not AllDigits(TempStr) then
    begin
      Result := False;
      LogIt(Target.acCompany + ': Invalid account - ' + TempStr);
    end;
    TempStr := FormatSortCode(Target.acBankSort);
    if (Length(TempStr) <> DefaultSortLength) or not AllDigits(TempStr) then
    begin
      LogIt(Target.acCompany + ': Invalid sort code - ' + TempStr);
      Result := False;
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

function TExportObject.WriteThisRec(const RecString : AnsiString) : Boolean;
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

//PR: 17/07/2013 ABSEXCH-14356 Julian Date was 1 day less than it should be. Rewrite function to use DayOfTheYear library function.
function TExportObject.JulianDate(const ADate : String) : longint;
var
  dd, mm, yy : word;
  dt : TDateTime;
begin
  //date comes in yyyymmdd format - convert to ints.
  dd := StrToInt(Copy(ADate, 7, 2));
  mm := StrToInt(Copy(ADate, 5, 2));
  yy := StrToInt(Copy(ADate, 1, 4));

  if TryEncodeDate(yy, mm, dd, dt) then
    Result := DayOftheYear(dt)
  else
    Result := 0;

  if Result > 0 then //first two digits should be last 2 digits of year
    Result := Result + (StrToInt(Copy(ADate, 3, 2))) * 1000;
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
      begin
        Add('Check bank details for:');
        AddStrings(RejectList);
        Add('');
        Add('Details will be shown in ' + LogPath + LogFileName);
      end
      else
      if Failed = flAddress then
      begin
        Add('Check Address details for:');
        AddStrings(RejectList);
        Add('');
        Add('Details will be shown in ' + LogPath + LogFileName);
      end
      else
      begin
        Add(FailString(failed));
        Add('');
        Add('Details will be shown in ' + LogPath + LogFileName);
      end;
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
  Result := ZerosAtFront(pence, 3); {i.e. minimum final string of 0.00}
  Insert('.', Result, Length(Result) - 1);
end;

function TExportObject.ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean;
{check user bank a/c & sort code}
var
  TempStr : Shortstring;
begin
  Result := True;
  with EventData.Setup do
  begin
    TempStr := UserBankAcc;
    if (Length(TempStr) <> DefaultACLength) or not AllDigits(TempStr) then
    begin
      Result := False;
      failed := flBank;
    end;
    TempStr := FormatSortCode(UserBankSort);
    if (Length(TempStr) <> DefaultSortLength) or not AllDigits(TempStr) then
    begin
      Result := False;
      failed := flBank;
    end;
  end; {with EventData.Setup}
  if Result then
    LogIt('Validate system - successful');

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
    Log.SaveToFile(LogPath + LogFileName);
   Except
    LogFull := True;
   End;
  end;
end;

procedure TExportObject.SetFailed(FNo : smallint);
begin
  FFailed := FNo;
  if Failed > 0 then
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
    9 : Result := 'Invalid Currency';
   10 : Result := 'Too many payment lines';
   11 : Result := 'Invalid direct debit mode for SEPA';
   14 : Result := 'Invaild Address';
    else
      Result := 'Unknown problem';
  end;
end;

procedure TExportObject.RejectRecord(const EventData : TAbsEnterpriseSystem);
var
  Target : TAbsCustomer;
begin
  FileRejected := True;
  GetEventData(EventData);
  if ProcControl.SalesPurch then
    Target := EventData.Customer
  else
    Target := EventData.Supplier;
  RejectList.Add(Target.acCode + ', ' + Target.acCompany);
end;

function TExportObject.YYMMDD(const ADate : string) : string;
begin
  if Length(ADate) <> 8 then
    Result := '001201'
  else
    Result := Copy(ADate, 3, 6);
end;

function TExportObject.GetSortCode(const s : string) : string;
//Removes '-' characters from string;
var
  i : integer;
begin
  i := 1;
  Result := s;
  while i < Length(s) do
  begin
    if Result[i] = '-' then
      Delete(Result, i, 1)
    else
      inc(i);
  end;
end;

function TExportObject.DQuotedStr(const s : string) : string;
begin
  Result := '"' + s + '"';
end;




function TExportObject.JulianDateStr(const ADate: String): string;
begin
  Result  := ZerosAtFront(JulianDate(ADate), 5);
end;

procedure TExportObject.Initialize;
begin
  LogPath := DataPath + 'Logs\';
  if FileExists(LogPath + LogFileName) then
    Log.LoadFromFile(LogPath + LogFileName);
  if Log.Count > 5000 then
  begin
    Log.SaveToFile(LogPath + ChangeFileExt(LogFileName, '.bak'));
    Log.Clear;
  end;
  Log.Add('BACS Export log');
  Log.Add('Run Date: ' + DateToStr(Date));
  Log.Add('Start Time: ' + TimeToStr(Time));
  LogFull := False;

end;

function TExportObject.DDMMYY(const ADate: string): string;
begin
  Result := Copy(ADate, 7, 2) +
            Copy(ADate, 5, 2) +
            Copy(ADate, 3, 2);
end;

function TExportObject.DDMMYYYY(const ADate: string): string;
begin
  Result := Copy(ADate, 7, 2) +
            Copy(ADate, 5, 2) +
            Copy(ADate, 1, 4);
end;

function TExportObject.Pounds(pence, ASize: Integer): string;
begin
  Result := ZerosAtFront(pence, ASize - 1); //-1 to leave room for decimal point.
  Insert('.', Result, Length(Result) - 1);
end;

function TExportObject.FormatSortCode(SortCode: string): string;
begin
  Result := SortCode;
end;

function TExportObject.EuroFormat(const Value: string): string;
begin
  //Remove any commas between 1000s
  Result := AnsiReplaceStr(Value, ',', '');
  //Replace decimal point with a comma
  Result := AnsiReplaceStr(Result, '.', ',');
end;

function TExportObject.DQuotedStrEx(const s: string;
  FollowingComma: Boolean): string;
begin
  Result := '"' + s + '"';
  if FollowingComma then
    Result := Result + ',';
end;

function TExportObject.MMDDYYYY(const ADate: string): string;
begin
  Result := Copy(ADate, 5, 2) + '/' +
            Copy(ADate, 7, 2) + '/' +
            Copy(ADate, 1, 4);
end;

//PR: 04/10/2012 Added extra overload for floating point numbers
function TExportObject.ZerosAtFront(AValue: Double;
  ASize: integer): Str255;
var
  iValue : Int64;
begin
  iValue := Trunc(AValue * 100);
  Result := ZerosAtFront(iValue, ASize - 1);
  Insert('.', Result, Length(Result) - 1);
end;

//Accepts date in yyyymmdd format and returns day of the year
function TExportObject.DayOfYear(const ADate: string): Integer;
var
  mm, dd, yy : Word;
  dt : TDateTime;
begin
  yy := StrToInt(Copy(ADate, 1, 4));
  mm := StrToInt(Copy(ADate, 5, 2));
  dd := StrToInt(Copy(ADate, 7, 2));

  dt := EncodeDate(yy, mm, dd);

  Result := DayOfTheYear(dt);
end;

function TExportObject.EuroFormat(const Value: Double): string;
begin
  Result := EuroFormat(Format('%9.2f', [Value]));
end;

////Validate : Sort code can be NN-NN-NN format.
function TExportObject.AllDigitsWithHyphen(const ACode: string): Boolean;
var
  i : Smallint;
begin
  Result := True;
  for i := 1 to Length(ACode) do
  begin
    if not (ACode[i] in ['-','0'..'9']) then
    begin
      Result := False;
      Break;
    end;
  end;
  if Result and ((ACode[3] <> '-') or (ACode[6] <> '-')) then
  begin
    Result := False;
  end;
end;

function TExportObject.AllDigitsWithHyphen(const ACode: String; AHyphenPos: Integer) : Boolean;
var
  i,
  lPosition: Smallint;
begin
  Result := True;
  for i := 1 to Length(ACode) do
  begin
    if not (ACode[i] in ['-','0'..'9']) then
    begin
      Result := False;
      Break;
    end;
  end;

  lPosition := LastDelimiter('-', ACode);

  if Result and (lPosition <> 5) then
  begin
    Result := False;
  end;
end;

end.
