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
  flContra = 3;
  flDate   = 4;
  flUserID = 5;

  Contra = 0;
  PayLine = 1;

  DefaultSortLength = 6;
  DefaultACLength = 8;


type

  Str255 = ShortString;

  TExportControl = Record
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
       Failed : SmallInt;
       ProcControl : TExportControl;
       TotalPenceWritten : longint;
       TransactionsWritten : integer;
       IsReceipt    : Boolean;
       constructor Create;
       destructor Destroy; override;
       function CreateOutFile(const AFileName : string;
                              const EventData :
                              TAbsEnterpriseSystem) : integer; virtual;
       function EraseOutFile : Boolean; virtual;
       function CloseOutFile : integer; virtual;
       function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
                                      virtual;
       function WriteRec(const EventData : TAbsEnterpriseSystem;
                          Mode : word) : Boolean; virtual; abstract;
       function WriteThisRec(const RecString : string) : Boolean; virtual;
       function ZeroesAtFront(AValue : longint; ASize : integer) : Str255;
       function AllDigits(const s : string) : Boolean;
       function MakeDigits(const s : string; Size : byte) : string;
       Function Pennies(Inum  :  Real) : LongInt;
       Procedure Str2_Char(const LStr   :  Str255;
                             Var CharAry;
                                 SO     :  Integer);
       function CheckPath(const ThePath : string) : string;
       procedure GetEventData(const EventData : TAbsEnterpriseSystem); virtual;
       procedure ShowExportReport(const Cap : string; Messages : TStrings);
       procedure ShowExportMessage(const Cap : string; const Msg1, Msg2 : string);
       function BACS_Safe(TStr  :  Str255)  :  Str255; virtual;
       function JulianDate(const ADate : String) : longint;


    end;




implementation

uses
  Dialogs, SysUtils, ExpRep, ExpMsg, Forms;

constructor TExportObject.Create;
begin
  inherited Create;
  TotalPenceWritten := 0;
  Failed := 0;
  RunAborted := False;
  TransactionsWritten := 0;
end;

destructor TExportObject.Destroy;
begin
  inherited Destroy;
end;

function TExportObject.CreateOutFile(const AFileName : string;
                                     const EventData :
                                     TAbsEnterpriseSystem) : integer;
begin
{$I-}
  GetEventData(EventData);
  IsReceipt := ProcControl.SalesPurch;
  OutFileName := AFilename;
  AssignFile(OutFile, AFileName);
  Rewrite(OutFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to create file ' + AFileName,
                        'This run has been aborted');
{$I+}
end;

function TExportObject.CloseOutFile : integer;
begin
{$I-}
  CloseFile(OutFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to close file ' + OutFileName, '');
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
    ShowExportMessage('Warning','Unable to erase file ' + OutFileName, '');
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
    if not (s[i] in ['0','1'..'9']) then
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
    if ProcControl.SalesPurch then
      Target := Customer
    else
      Target := Supplier;

    if Target.acPayType <> 'B' then
    begin
      Result := False;
      Exit;
    end;
    TempStr := Target.acBankAcc;
    if (Length(TempStr) <> DefaultACLength) or not AllDigits(TempStr) then
    begin
      Result := False;
      Exit;
    end;
    TempStr := Target.acBankSort;
    if (Length(TempStr) <> DefaultSortLength) or not AllDigits(TempStr) then
    begin
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









end.
