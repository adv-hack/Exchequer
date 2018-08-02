unit ShbBObj;

interface

uses
  ExpObj, CustAbsU, Classes;

type
  TShbBacsExporter = Class(TExportObject)
    FUserID : string;
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                          Mode : word) : Boolean; override;
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
  end;

implementation

uses
  SysUtils, IniFiles, Dialogs, Controls, MultIni;

{ TShbBacsExporter }
const
  Filler = '099';
  OurSort = '405162';
  Filler2 = '    '; //4 spaces

function TShbBacsExporter.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  IniFilename : string;
begin
  Result := Inherited ValidateSystem(EventData);
  if Result then
  begin
    FUserID := UserID;
    if Trim(FUserID) = '' then
    begin
      IniFilename := IncludeTrailingBackslash(EventData.Setup.ssDataPath) + 'SHBBacs.ini';
      with TIniFile.Create(IniFilename) do
      Try
        FUserID := ReadString('Settings','ClientID','');
      Finally
        Free;
      End;
      Result := FUserID <> '';
      if not Result then
      {$IFDEF MultiBacs}
        ShowExportMessage('SHB BACS Export', 'No Client ID defined', '');
      {$ELSE}
        ShowExportMessage('SHB BACS Export', 'Unable to read Client ID from ' + IniFilename, '');
      {$ENDIF}
    end;
  end;
end;

function TShbBacsExporter.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  OutS : String;
  Pence : longint;
  Target : TAbsCustomer;
begin
  GetEventData(EventData);
  with EventData do
  begin
    if IsReceipt then
      Target := Customer
    else
      Target := Supplier;

    Case Mode of
      wrPayLine : begin
                    Pence := Pennies(ProcControl.Amount);
                    TotalPenceWritten := TotalPenceWritten + Pence;
                    Inc(TransactionsWritten);

                    OutS := Target.acBankSort + Target.acBankAcc + Filler + OurSort +
                      Setup.ssUserAcc + Filler2 + ZerosAtFront(Pence, 11) +
                      LJVAR(FUserID, 18) +
                      LJVar(Bacs_Safe(Target.acBankRef), 18) +
                      LJVar(Bacs_Safe(Target.acCompany), 18) +
                      RJVar(ZerosAtFront(IntToStr(JulianDate(ProcControl.PDate)), 5), 6);
                  end;
      wrContra  : begin
                    OutS := OurSort + Setup.ssUserAcc + Filler + OurSort +
                      Setup.ssUserAcc + Filler2 + ZerosAtFront(TotalPenceWritten, 11) +
                      LJVAR(FUserID, 18) +
                      LJVar('CONTRA', 18) +
                      LJVar('', 18) +
                      RJVar(ZerosAtFront(IntToStr(JulianDate(ProcControl.PDate)), 5), 6);
                  end;
    end; //Case
  end;
  Result := WriteThisRec(OutS);
end;

end.
