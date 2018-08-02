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
      ubAcc,
      ubBank,
      ubBranch       : string;
      targetAcc,
      targetBank,
      targetBranch   : string;
    public
      constructor Create(const EventData : TAbsEnterpriseSystem);
      function CreateOutFile(const AFileName : string;
                            const EventData :
                             TAbsEnterpriseSystem) : integer; override;
      function WriteRec(const EventData : TAbsEnterpriseSystem;
                            Mode : word) : Boolean; override;
      function StartHash(const AccNo : string) : Boolean;
      function AddToHash(const AccNo : string) : Boolean;
      function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
      function GetBankDetails(const RefNo : string;
                              var Acc, Bank, Branch : string) : Boolean;
      function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
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
      if not GetBankDetails(UserBankRef + '-' +
                             UserBankSort, ubAcc, ubBank, ubBranch) then
      begin
        ShowExportMessage('Error','Check system bank reference no','Run aborted');
        Failed := flBank;
        Exit;
      end;

      With ControlRec do
      begin
        Str2_Char(Copy(ProcControl.PDate, 3, 6), ValDate, SizeOf(ValDate));
{        if not ValidateSortCode(UserBankSort) then
        begin
          ShowExportMessage('Error','Check system bank sort no','Run aborted');
          Failed := flBank;
          Exit;
        end;}
        Str2_Char(ubBank,BankNo, SizeOf(BankNo));
        Str2_Char(ubBranch,BranchNo, SizeOf(BranchNo));
{        if not AllDigits(RemoveHyphens(UserBankAcc)) then
        begin
          ShowExportMessage('Error','Check system bank account no','Run aborted');
          Failed := flBank;
          Exit;
        end;}
{        Str2_Char(RemoveHyphens(UserBankAcc), BankAcc, SizeOf(BankAcc));}
        Str2_Char(RemoveHyphens(ubAcc), BankAcc, SizeOf(BankAcc));
        if not StartHash(ubAcc) then
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
      Str2_Char(ZeroesAtFront(StrToInt(targetBank),SizeOf(RecBankNo)),
                RecBankNo, SizeOf(RecBankNo));
      Str2_Char(ZeroesAtFront(StrToInt(targetBranch),SizeOf(RecBranchNo)),
                RecBranchNo, SizeOf(RecBranchNo));
      Str2_Char(targetAcc, RecAccNo, SizeOf(RecAccNo));
      Str2_Char(Target.acCompany, RecAccName, SizeOf(RecAccName));
      if not AddToHash(targetAcc) then
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


function TIdealExportObject.ValidateRec(const EventData :
                                       TAbsEnterpriseSystem) : Boolean;
var
  Target : TAbsCustomer;
begin
  Target := GetTarget(EventData);
  with Target do
  begin
    Result := GetBankDetails(acBankRef + '-' +
                             acBankSort, targetAcc, targetBank, targetBranch);
  end;{with Target}

end;


function TIdealExportObject.GetBankDetails(const RefNo : string;
                                           var Acc, Bank, Branch : string) : Boolean;
{a/c no can be up to 11 digits, bank is 4, branch can be up to 3.  We'll have them either
in the bank name or bank ref + sort separated by '-'; Result is false if we can't parse all 3
or if any are more than the max characters}
var
  i, j : integer;
begin
  Result := True;
  i := 1;
  while (i < Length(RefNo)) and (RefNo[i] <> '-') do inc(i);
  if (i >= Length(RefNo)) then
    Result := False
  else
  begin
    Acc := Copy(RefNo, 1, i - 1);
    inc(i);
    j := i;
    while (i < Length(RefNo)) and (RefNo[i] <> '-') do inc(i);
    if (i >= Length(RefNo)) then
      Result := False
    else
    begin
      Bank := Copy(RefNo, j, i - j);
      Branch := Copy(RefNo, i + 1, Length(RefNo));
      if Not (AllDigits(Acc) and AllDigits(Bank) and AllDigits(Branch)) then
        Result := False;
      if (Length(Acc) < 1) or (Length(Bank) < 1) or (Length(Branch) < 1) or
         (Length(Acc) > 11) or (Length(Bank) > 4) or (Length(Branch) > 3) then
        Result := False;
      {branch needs to be 3 chars}
      While Length(Branch) < 3 do Branch := '0' + Branch;
    end;
  end;
end;

function TIdealExportObject.ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean;
{We've checked the system details during create - if they weren't correct then failed will
be flBank}
begin
  Result := (Failed = 0);
end;







end.
