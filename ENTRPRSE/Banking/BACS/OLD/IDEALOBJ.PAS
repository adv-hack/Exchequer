unit IdealObj;

interface

uses
  ExpObj, Ideal01, IdealOpt, CustAbsU;

type
  TIdealExportObject = Class(TExportObject)
    protected
      ControlRec     : TIdealControlRec;
      SummaryRec     : TIdealSummaryRec;
      IdealIniFile   : String;
      IdealRec       : TIdealOptsRec;
      Hash           : longint;
      UserHashNo     : longint;
    public
      constructor Create(const EventData : TAbsEnterpriseSystem);
      function CreateOutFile(const AFileName : string;
                            const EventData :
                             TAbsEnterpriseSystem) : integer; override;
      function WriteRec(const EventData : TAbsEnterpriseSystem;
                            Mode : word) : Boolean; override;
      function StartHash(const AccNo : string) : Boolean;
      function AddToHash(const AccNo : string) : Boolean;
      function GetBank(const SortCode : string) : string;
      function GetBranch(const SortCode : string) : string;
      function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
      function ValidateSortCode(const SortCode : string) : Boolean;
    end;

var
  IdealExportObject : TIdealExportObject;


implementation

uses
  SysUtils;


constructor TIdealExportObject.Create(const EventData : TAbsEnterpriseSystem);
begin
  inherited Create;
  with EventData do
  begin
    FillChar(ControlRec, SizeOf(ControlRec), #32);
    FillChar(SummaryRec, SizeOf(SummaryRec), #32);
    IdealIniFile := CheckPath(EventData.Setup.ssDataPath) + DefaultIdealIniFile;
    if not GetIdealOptions(IdealIniFile, IdealRec) then
      Failed := flUserID
    else
    begin
      GetEventData(EventData);
      With ControlRec do
      begin
        Str2_Char(Copy(ProcControl.PDate, 3, 6), ValDate, SizeOf(ValDate));
        if not ValidateSortCode(UserBankSort) then
        begin
          ShowExportMessage('Error','Check system bank sort no','Run aborted');
          Failed := flBank;
          Exit;
        end;
        Str2_Char(GetBank(UserBankSort),BankNo, SizeOf(BankNo));
        Str2_Char(GetBranch(UserBankSort),
                                BranchNo, SizeOf(BranchNo));
        if not AllDigits(RemoveHyphens(UserBankAcc)) then
        begin
          ShowExportMessage('Error','Check system bank account no','Run aborted');
          Failed := flBank;
          Exit;
        end;
        Str2_Char(RemoveHyphens(UserBankAcc), BankAcc, SizeOf(BankAcc));
        if not StartHash(UserBankAcc) then
        begin
          ShowExportMessage('Error in StartHash','Check system bank account no','Run aborted');
          Failed := flBank;
          Exit;
        end;
        Str2_Char(Setup.ssUserName, UserName, SizeOf(UserName));
        {can't set sequence number here as we're using the batch run number for it. Set
        it in CreateOutputFile}
        Str2_Char(IdealRec.UserID, UserID, SizeOf(UserID));
        RecType := '0';
      end;{with ControlHeader}
    end; {if getidealoptions}
  end; {with eventdata}
end;

function TIdealExportObject.CreateOutFile(const AFileName : string;
                                          const EventData :
                                           TAbsEnterpriseSystem) : integer;
var
  OutString : string;
begin
  Result := Inherited CreateOutFile(AFileName, EventData);

  if Result = 0 then
  begin
    GetEventData(EventData);
    with ControlRec do
    begin
      Str2_Char(ZeroesAtFront(1 + (ProcControl.PayRun mod 99999), SizeOf(SeqNo)),
                   SeqNo, SizeOf(SeqNo));

      OutString := ValDate+
                 Filler1  +
                 BankNo   +
                 BranchNo +
                 BankAcc  +
                 Filler2  +
                 UserName +
                 SeqNo  +
                 UserID  +
                 Filler3 +
                 RecType;

    end;

    if not WriteThisRec(OutString) then
      Result := -1;

  end; {result := 0}


end;

function TIdealExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                   Mode : word) : Boolean;
var
  OutRec : TIdealAdviceRec;
  Target : TAbsCustomer;
  pence : longint;
  OutString, TempStr : string;
begin
  FillChar(OutRec, SizeOf(OutRec), #32);
  with EventData do
  begin
    Target := GetTarget(EventData);
    if Mode = wrContra then
    begin
     {no contra as such - we need to write the summary record}
     with SummaryRec do
     begin
      if IsReceipt then
      begin
       TempStr := ZeroesAtFront(TotalPenceWritten, SizeOf(TotalDr));
       Str2_Char(TempStr, TotalDr, SizeOf(TotalDr));
       TempStr := ZeroesAtFront(TransactionsWritten, SizeOf(CountDr));
       Str2_Char(TempStr, CountDr, SizeOf(CountDr));
       TempStr := ZeroesAtFront(0, SizeOf(TotalCr));
       Str2_Char(TempStr, TotalCr, SizeOf(TotalCr));
       TempStr := ZeroesAtFront(0, SizeOf(CountCr));
       Str2_Char(TempStr, CountCr, SizeOf(CountCr));
      end
      else {payment}
      begin
       TempStr := ZeroesAtFront(0, SizeOf(TotalDr));
       Str2_Char(TempStr, TotalDr, SizeOf(TotalDr));
       TempStr := ZeroesAtFront(0, SizeOf(CountDr));
       Str2_Char(TempStr, CountDr, SizeOf(CountDr));
       TempStr := ZeroesAtFront(TotalPenceWritten, SizeOf(TotalCr));
       Str2_Char(TempStr, TotalCr, SizeOf(TotalCr));
       TempStr := ZeroesAtFront(TransactionsWritten, SizeOf(CountCr));
       Str2_Char(TempStr, CountCr, SizeOf(CountCr));
      end;
      Str2_Char(ZeroesAtFront(Hash, SizeOf(HashTotal)), HashTotal, SizeOf(HashTotal));
      RecType := '9';

      {can't use writethisrec because last record has to miss out CF/LR}
      {$I-}
        OutString :=  CountCr +
                TotalCr   +
                Filler1   +
                CountDr   +
                TotalDr   +
                Filler2   +
                HashTotal +
                Filler3   +
                RecType;
        Write(OutFile, OutString);
        Result := (IOResult = 0);
      {$I+}
     end; {with summaryrec}
    end {is contra}
    else
    begin {payline}
     with OutRec do
     begin
      {receiving bank no - 4 digits - ???}
      {receiving branch no - 3 digits - ??? - are these 2 together the sort code?
      In which case we need to know how to separate them out - try this for now}
      Str2_Char(ZeroesAtFront(StrToInt(GetBank(Target.acBankSort)),SizeOf(RecBankNo)),
                RecBankNo, SizeOf(RecBankNo));
      Str2_Char(ZeroesAtFront(StrToInt(GetBranch(Target.acBankSort)),SizeOf(RecBranchNo)),
                RecBranchNo, SizeOf(RecBranchNo));
      Str2_Char(Target.acBankAcc, RecAccNo, SizeOf(RecAccNo));
      Str2_Char(Target.acCompany, RecAccName, SizeOf(RecAccName));
      if not AddToHash(Target.acBankAcc) then
      begin
        ShowExportMessage('Error','Check bank details for ' + Target.acCompany,
                    'Run aborted');
        Result := False;
        Exit;
      end;
      if IsReceipt then
        Str2_Char('30', TranCode, SizeOf(TranCode))
      else {put 20 for now until i can check}
        Str2_Char('20', TranCode, SizeOf(TranCode));

      Pence := Pennies(Transaction.thTotalInvoiced);
      Str2_Char(ZeroesAtFront(Pence, SizeOf(Amount)), Amount, SizeOf(Amount));

      Str2_Char(ZeroesAtFront(ProcControl.PayRun, 3), Particulars, SizeOf(Particulars));
      Str2_CharRight(Transaction.thOurRef, Reference, SizeOf(Reference));
      RecType := '1';

      OutString := RecBankNo +
          RecBranchNo +
          RecAccNo    +
          RecAccName  +
          TranCode    +
          Amount      +
          Filler      +
          Particulars  +
          Reference    +
          RecType;

      Result := WriteThisRec(OutString);

      TotalPenceWritten := TotalPenceWritten + Pence;
      inc(TransactionsWritten);

     end; {with OutRec}
    end; {not Contra}

  end; {with EventData}



end;

function TIdealExportObject.StartHash(const AccNo : string) : Boolean;
{Set Hash variable to zero and calculate the integer based on user's bank a/c}
var
  d6, d5 : longint;
  s : string;
begin
  Result := True;
  Hash := 0;
  s := Copy(AccNo + '00000000000', 1, 11); {adds trailing zeros}
  Try
    d6  := StrToInt(Copy(s, 1, 6));
    d5  := StrToInt(Copy(s, 7, 5));
    UserHashNo := d6 - d5;
  Except
    Result := False;
  End;
end;

function TIdealExportObject.AddToHash(const AccNo : string) : Boolean;
var
  d6, d5, HashNo : longint;
  s : string;
begin
  Result := True;
  s := Copy(AccNo + '00000000000', 1, 11); {adds trailing zeros}
  Try
    d6  := StrToInt(Copy(s, 1, 6));
    d5  := StrToInt(Copy(s, 7, 5));
    HashNo := d6 - d5;
    HashNo := Abs(HashNo - UserHashNo);
    Hash := Hash + HashNo;
  Except
    Result := False;
  End;
end;

function TIdealExportObject.GetBank(const SortCode : string) : string;
begin
  Result := Copy(SortCode, 1, 4);
end;

function TIdealExportObject.GetBranch(const SortCode : string) : string;
begin
  Result := Copy(SortCode, 6, 3);
  while Length(Result) < 3 do Result := '0' + Result;
end;

function TIdealExportObject.ValidateRec(const EventData :
                                       TAbsEnterpriseSystem) : Boolean;
var
  Target : TAbsCustomer;
begin
  Target := GetTarget(EventData);
  with Target do
  begin
    Result := ValidateSortCode(acBankSort);
  end;{with Target}

end;

function TIdealExportObject.ValidateSortCode(const SortCode : string) : Boolean;
{Singapore uses BankNo (4) and Branch(up to 3).  We'll insist that they're put into
the Sort Code field separated by '-'}
var
  TempStr : string;
begin
  Result := True;
  if Length(SortCode) < 6 {4 + '-' + minimum 1 digit for branch}then
  begin
    Result := False;
    Exit;
  end;
  if SortCode[5] <> '-' then
  begin
    Result := False;
    Exit;
  end;
  TempStr := GetBank(SortCode);
  if not AllDigits(TempStr) or (Length(Tempstr) <> 4) then
  begin
    Result := False;
    Exit;
  end;
  TempStr := GetBranch(SortCode);
  if not AllDigits(TempStr) or (Length(Tempstr) <> 3) then
  begin
    Result := False;
    Exit;
  end;
end;


end.
