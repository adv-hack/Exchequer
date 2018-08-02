unit CouttObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  MultiObj, Coutts01, CustAbsU;

type
  TCouttsExportObject = Class(TMultiFileExportObject)
    protected
      FExcludeHeader : Boolean;
      HeaderRec : TCouttsHeaderRec;
      PayRecs : Array[1..MaxCreditLines] of TCouttsPayLine;
      OldPayCount : integer;
      function WriteData(const EventData : TAbsEnterpriseSystem) : Boolean; override;
      procedure InitialiseHeader(const EventData : TAbsEnterpriseSystem);
    public
      constructor Create(const EventData : TAbsEnterpriseSystem);
      function WriteRec(const EventData : TAbsEnterpriseSystem;
                           Mode : word) : Boolean; override;

    end;


implementation

uses
  SysUtils, ExpObj, IniFiles;

constructor TCouttsExportObject.Create(const EventData : TAbsEnterpriseSystem);
var
  Ini : TIniFile;
begin
  inherited Create;
  RecsPerFile := MaxCreditLines;
  FMaxFiles := MaxFiles;
  FDigitCount := 5;
  Ext := DefaultExt;

  //read ini file
  Ini := TIniFile.Create(IncludeTrailingBackslash(EventData.Setup.ssDataPath) + CouttsIniFileName);
  Try
    FExcludeHeader := Ini.ReadBool('Settings','ExcludeHeader',False);
  Finally
    Ini.Free;
  End;

  InitialiseHeader(EventData);
end;

procedure TCouttsExportObject.InitialiseHeader(const EventData : TAbsEnterpriseSystem);
begin
  FillChar(HeaderRec, SizeOf(HeaderRec), 0);
  GetEventData(EventData);
  with EventData, HeaderRec do
  begin
    RefNo    := ProcControl.PDate + IntToStr(FileCount) + IntToStr(ProcControl.PayRun);
    CompAcc  := UserBankAcc;
    CompSort := UserBankSort;
    PayDate  := StandardDate(ProcControl.PDate);
  end;
  PayCount := 1;
end;

function TCouttsExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                                 Mode : word) : Boolean;
var
  Target : TAbsCustomer;
begin
  Result := True;
  Target := GetTarget(EventData);
  if Mode = wrContra then
  begin
    if OldPayCount > 0 then
      Result := WriteBatch(EventData);
  end
  else
  begin
    with EventData, PayRecs[PayCount] do
    begin
      RefNo      := HeaderRec.RefNo;
      DestAcc    := Target.acBankAcc;
      DestSort   := Target.acBankSort;
      DestName   := Target.acCompany;
      Amount     := Pennies(Transaction.thTotalInvoiced);
      if not IsBlank(Bacs_Safe(Target.acBankRef)) then
        DestRef := Bacs_Safe(Target.acBankRef)
      else
        DestRef := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

      TotalPenceWritten := TotalPenceWritten + Amount;
    end;
    inc(TransactionsWritten);
    OldPayCount := PayCount;
    inc(PayCount);
    if PayCount > MaxCreditLines then
    begin
      Result := WriteBatch(EventData);
      PayCount := 1;
      OldPayCount := 0;
    end;
  end; {with}
end;

function TCouttsExportObject.WriteData(const EventData : TAbsEnterpriseSystem): boolean;
var
  OutString : string;
  i : integer;
begin
{$I-}
  InitialiseHeader(EventData);
  if not FExcludeHeader then
  begin
    with HeaderRec do
    begin
      OutString :=  RefNo + ';' +
                    CompAcc + ';' +
                    CompSort + ';' +
                    PayDate;

      Result := WriteThisRec(OutString);
    end;
  end;
  If Result then
  begin
    for i := 1 to OldPayCount do
    begin
      with PayRecs[i] do
      begin
        OutString :=     HeaderRec.RefNo + ';' +
                         Bacs_Safe(TrimRight(DestName)) + ';' +
                         DestSort + ';' +
                         DestAcc + ';' +
                         Pounds(Amount) + ';' +
                         Bacs_Safe(DestRef);

        Result := WriteThisRec(OutString);
      end; {with}
    end; {for i}
  end;
  InitialiseHeader(EventData);

end; {write batch}




end.
