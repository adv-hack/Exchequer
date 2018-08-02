unit BacssOBJ;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ExpObj, CustAbsU;

const
  IniFileName = 'BACSess.ini';

type
  TBacsessRec = Record
    DestSort : string[6];
    DestAcc  : string[8];
    DestName : string[18];
    Ref      : string[18];
    Amount   : longint;
    AcNo     : Char;
  end;

  TBacsessExportObject = Class(TExportObject)
  private
     FAcNoField : Integer;
     FAcNo : Char;
  public
     procedure Initialize; override;
     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
     function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
  end;

implementation

uses
  SysUtils, IniFiles, FileUtil;

procedure TBacsessExportObject.Initialize;
begin
  inherited;
  with TIniFile.Create(DataPath + IniFileName) do
  Try
    FAcNoField := ReadInteger('Settings', 'ACNoField', 4);
    if (FAcNoField < 1) or (FAcNoField > 4) then
      FAcNoField := 4;
  Finally
    Free;
  End;
end;

function TBacsessExportObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  s : string;
  Target : TAbsCustomer;
begin
  Result := Inherited ValidateRec(EventData);
  Target := GetTarget(EventData);
  Case FAcNoField of
    1 : s := Target.acUserDef1;
    2 : s := Target.acUserDef2;
    3 : s := Target.acUserDef3;
    4 : s := Target.acUserDef4;
  end;

  if (Length(s) < 1) or not ( s[1] in ['0'..'9']) then
  begin
    Result := False;
    LogIt(Target.acCompany + ': No Account No set in User Field ' + IntToStr(FAcNoField));
  end
  else
    FAcNo := s[1];

end;

function TBacsessExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;
var
  OutRec  : TBacsessRec;
  OutString : string;
  Target : TAbsCustomer;
begin
  Result := True;
  if Mode = wrPayLine then {don't want the contra}
  begin
    Target := GetTarget(EventData);
    FillChar(OutRec, SizeOf(OutRec), #0);
    GetEventData(EventData);
    with EventData, OutRec do
    begin
      DestSort := Target.acBankSort;
      DestAcc  := Target.acBankAcc;
      DestName := TrimRight(Bacs_Safe(Target.acCompany));
      if not IsBlank(Bacs_Safe(Target.acBankRef)) then
        Ref := TrimRight(Bacs_Safe(Target.acBankRef))
      else
        Ref := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

//      AcNo := Target.acUserDef4[1];
      AcNo := FAcNo;
      Amount := Pennies(Transaction.thTotalInvoiced);
      TotalPenceWritten := TotalPenceWritten + Amount;
      inc(TransactionsWritten);

      OutString := DestName + ';' +
                   Ref + ';' +
                   DestSort + ';' +
                   DestAcc + ';' +
                   Pounds(Amount) + ';' +
                   AcNo;

      if IsReceipt then
        OutString := OutString + ';' + DirectDebitCode(Target.acDirDebMode);

      Result := WriteThisRec(OutString);
    end; {with eventdata, outrec}
  end; {if mode = wrpayline}
end;



end.
