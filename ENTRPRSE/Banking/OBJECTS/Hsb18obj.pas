unit Hsb18obj;

interface

uses
  CustAbsU, ExpObj, Aib01;

const
  HSBCIniFilename = 'Hsbc18.ini';

type

  THSBC18Object = Class(TExportObject)
  private
    FUserID : string[6];
    CreditTotal, DebitTotal,
    CreditCount, DebitCount : Int64;
  protected
    function Spaces(Count : Integer) : string;
    function GetUserID : string;
    function SerialNo : string;
    function CreationDate : string;
    function ExpiryDate : string;
    function BacsDate : string;
    function FileNo : string;
    function LoadUserID(const Filepath : string) : Boolean;

    function GetReserved : string;

    function VolHeader : string;
    function Header1 : string;
    function Header2 : String;
    function UHL1 : String;
    function EOF1 : string;
    function EOF2 : string;
    function UTL1 : string;
  public
    function CreateOutFile(const AFileName : string;
                           const EventData :
                           TAbsEnterpriseSystem) : integer; override;
    function CloseOutFile : integer; override;

    function WriteRec(const EventData : TAbsEnterpriseSystem;
                        Mode : word) : Boolean; override;
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;

  end;

implementation

uses
  SysUtils, IniFiles, EtDateU, MultIni;

{ THSBC18Object }


function THSBC18Object.BacsDate: string;
begin
  Result := ' ' + ZerosAtFront(JulianDate(ProcControl.PDate), 5);
end;

function THSBC18Object.CloseOutFile: integer;
begin
  {$I-}
  WriteLn(OutFile, EOF1);
  WriteLn(OutFile, EOF2);
  WriteLn(OutFile, UTL1);
  Result := IOResult;
  {$I+}
  if Result = 0 then
    Result := inherited CloseOutFile
  else
    CloseFile(OutFile);
end;

function THSBC18Object.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  Result := inherited CreateOutFile(AFileName, EventData);

  if Result = 0 then
  begin
    {$I-}
    WriteLn(OutFile, VolHeader);
    WriteLn(OutFile, Header1);
    WriteLn(OutFile, Header2);
    WriteLn(OutFile, UHL1);
    Result := IOResult;
    {$I+}
  end;


end;

function THSBC18Object.CreationDate: string;
begin
  Result := ' ' + ZerosAtFront(JulianDate(FormatDateTime('yyyymmdd', Date)), 5);
end;

function THSBC18Object.EOF1: string;
begin
  Result := Format('%s%s%s%s%s%s%s%s%s%s', ['EOF1A', GetUserID, 'S  1', GetUserID, SerialNo,
                                             '00010001000101', CreationDate, ExpiryDate,
                                             '0000000', Spaces(20)]);
end;

function THSBC18Object.EOF2: string;
begin
  Result := Format('%s%s%s%s', ['EOF2F0200000100', Spaces(35), '00', Spaces(28)]);
end;

function THSBC18Object.ExpiryDate: string;
begin
  Result := ' ' + ZerosAtFront(JulianDate(CalcDueDate(ProcControl.PDate, 6)), 5);
end;

function THSBC18Object.FileNo: string;
begin
  Result := ZerosAtFront(ProcControl.PayRun mod (999 + 1), 3);
end;

function THSBC18Object.Header1: string;
begin
  Result := Format('%s%s%s%s%s%s%s%s%s%s', ['HDR1A', GetUserID, 'S  1', GetUserID, SerialNo,
                                             '00010001000101', CreationDate, ExpiryDate,
                                             '0000000', Spaces(20)]);
end;

function THSBC18Object.Header2: String;
begin
  Result := Format('%s%s%s%s', ['HDR2F0200000100', Spaces(35), '00', Spaces(28)]);
end;

function THSBC18Object.LoadUserID(const Filepath : string): Boolean;
begin
  //PR: 04/01/2012 Allow blank user id.
  Result := True;
  FUserID := UserID;
  if Trim(FUserID) = '' then
  with TIniFile.Create(DataPath + HsbcIniFilename) do
  Try
    FUserID := ReadString('Settings', 'UserID', '');
  Finally
    Free;
  End;
end;

function THSBC18Object.SerialNo: string;
begin
  Result := ZerosAtFront(ProcControl.PayRun, 6);
end;

function THSBC18Object.Spaces(Count: Integer): string;
begin
  Result := StringOfChar(' ', Count);
end;

function THSBC18Object.UHL1: String;
begin
  Result := Format('%s%s%s%s%s%s%s', ['UHL1', BacsDate, '999999    000000001 DAILY  ', FileNo, Spaces(7),
                                      'AUD0010', Spaces(26)]);
end;

function THSBC18Object.GetUserID: string;
begin
  Result := LJVar(FUserID, 6);
end;

function THSBC18Object.UTL1: string;
begin
  CreditCount := 0;
  DebitCount := 0;
  CreditTotal := 0;
  DebitTotal := 0;

  if IsReceipt then
  begin
    DebitCount := TransactionsWritten;
    DebitTotal := TotalPenceWritten;
    CreditTotal := TotalPenceWritten;
    CreditCount := 1; //Contra
  end
  else
  begin
    CreditCount := TransactionsWritten;
    CreditTotal := TotalPenceWritten;
    DebitTotal := TotalPenceWritten;
    DebitCount := 1; //Contra
  end;
  Result := Format('%s%s%s%s%s%s', ['UTL1', ZerosAtFront(DebitTotal, 13), ZerosAtFront(CreditTotal, 13),
                                     ZerosAtFront(DebitCount, 7), ZerosAtFront(CreditCount, 7),
                                     Spaces(36)]);
end;

function THSBC18Object.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := Inherited ValidateSystem(EventData);

  if Result then
  begin
    //PR: 04/01/2012 if User Id is not available then we set Field 6 to 'HSBC  '.
    LoadUserID(IncludeTrailingBackslash(EventData.Setup.ssDataPath));
  end;
end;

function THSBC18Object.VolHeader: string;
begin
  Result := Format('%s%s%s%s%s%s', ['VOL1', SerialNo, GetReserved, GetUserID, Spaces(32), '1']);
end;

function THSBC18Object.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  TempStr : Str255;
  pence : longint;
  OutString : AnsiString;
  Target : TAbsCustomer;
  ContraTypeCode, TypeCode : String;
begin

  GetEventData(EventData);

  with EventData do
  begin
    if IsReceipt then
    begin
      Target := Customer;
      ContraTypeCode := '99';
    end
    else
    begin
      Target := Supplier;
      ContraTypeCode := '17';
    end;

    if Mode = wrContra then
    begin
     OutString :=
      Format('%s%s%s%s%s%s%s%s%s%s%s', [GetSortCode(UserBankSort), UserBankAcc,
                                         '0', ContraTypeCode,
                                        GetSortCode(UserBankSort), UserBankAcc,
                                        Spaces(4), ZerosAtFront(TotalPenceWritten, 11),
                                        LJVar(IntToStr(ProcControl.PayRun), 18),
                                        'CONTRA' + Spaces(12), LJVar(Bacs_Safe(Setup.ssUserName), 18)])
    end
    else
    begin
      //PR: 18/06/2013 ABSEXCH-14187 Take reference from customer/supplier bank ref field rather than system bank ref.
      if not IsBlank(Bacs_Safe(Target.acBankRef)) then
        TempStr := Bacs_Safe(Target.acBankRef)
      else
        TempStr := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

     Pence := Pennies(ProcControl.Amount);

     if IsReceipt then
       TypeCode := DirectDebitCode(Target.acDirDebMode)
     else
       TypeCode := '99';

     OutString :=
      Format('%s%s%s%s%s%s%s%s%s%s%s', [GetSortCode(Target.acBankSort), Target.acBankAcc,
                                                '0', TypeCode,
                                                GetSortCode(UserBankSort), UserBankAcc,
                                                Spaces(4), ZerosAtFront(Pence, 11),
                                                LJVar(Bacs_Safe(Setup.ssUserName), 18),
                                                LJVar(Bacs_Safe(TempStr), 18),
                                                LJVar(Bacs_Safe(Target.acCompany), 18)]);

      TotalPenceWritten := TotalPenceWritten + Pence;
      inc(TransactionsWritten);

    end;

    Result := WriteThisRec(OutString);

  end;

end;

//PR: 04/01/2012 If no user Id then set Field 6 to 'HSBC  '
function THSBC18Object.GetReserved: string;
begin
  if FUserId = '' then
    Result := Spaces(21) + 'HSBC  ' + Spaces(4)
  else
    Result := Spaces(31);
end;

end.
