unit ExWrap;

interface

uses
  ExpObj, CustAbsU;

const
{Export objects}
  exBacs1    = 0;
  exAIB      = 1;
  exBnkIre   = 2;
  exIdeal    = 3;
  exHex      = 4;
  exBacstel  = 5;
  exNatwest  = 6;
  exBacsNc   = 7;
  exPcPayCsv = 8;
  exPcPayAsc = 9;
  exCoutts   = 10;


{File types allowed}
  ftaCreditOnly = 0;
  ftaDebitOnly  = 1;
  ftaBoth       = 2;

type

  TExportWrapper = Class
    Exporter    : TExportObject;
    constructor Create(const EventData : TAbsEnterpriseSystem; WhichObject : Byte);
    destructor Destroy; override;
    function StartUp(const EventData : TAbsEnterpriseSystem) : Boolean;
    function CreateFile(const EventData : TAbsEnterpriseSystem;
                        const AFileName : String) : Boolean;
    function Validate(const EventData : TAbsEnterpriseSystem) : Boolean;
    function Write(const EventData : TAbsEnterpriseSystem) : Boolean;
    function Contra(const EventData : TAbsEnterpriseSystem) : Boolean;
    function Close(const EventData : TAbsEnterpriseSystem) : Boolean;
    function Reject(const EventData : TAbsEnterpriseSystem) : Boolean;
    function Erase(const EventData : TAbsEnterpriseSystem) : Boolean;
    function Complete(const EventData : TAbsEnterpriseSystem) : Boolean;
  end;

  function HandleBatchHooks(const EventData : TAbsEnterpriseSystem;
                                   HID : longint;
                                 WhichObject : Word;
                              FileTypesAllowed : Byte;
                            const PayFile, RecFile : string) : Boolean;

var
  ExportWrapper : TExportWrapper;

implementation

uses
  Bacs00, AibObj, BankIObj, HexObj, Bacstobj, NatWObj, IdealObj, Dialogs,
  BacNcObj, PcCsvObj, CouttObj;

constructor TExportWrapper.Create(const EventData : TAbsEnterpriseSystem; WhichObject : Byte);
begin
  inherited Create;
  with EventData do
  begin
  {Don't want a try/except block here as any exception will be handled by
  the lines below where exportwrapper itself is created}
      case WhichObject of
        exBacs1   : Exporter := TBacs1Obj.Create;
        exAIB     : Exporter := TAibEftObj.Create(EventData);
        exBnkIre  : Exporter := TBankIrExportObject.Create(EventData);
        exIdeal   : Exporter := TIdealExportObject.Create(EventData);
        exHex     : Exporter := THexagonExportObject.Create(EventData);
        exBacstel : Exporter := TBacstelExportObject.Create;
        exNatwest : Exporter := TNatWestExportObject.Create;
        exBacsNc  : Exporter := TBacsNcExportObject.Create;
        exPcPayCsv : Exporter := TPcPayCsvExportObject.Create;
        exPcPayAsc : Exporter := TBacsNcExportObject.Create; {re-use of bacsnc}
        exCoutts   : Exporter := TCouttsExportObject.Create(EventData);
      end; {case}
      BoResult := True;
      with Exporter do
      begin
        RequiredPath := CheckPath(EventData.Setup.ssDataPath);
        BoResult := ValidateSystem(EventData);
        if Failed > 0 then
           BoResult := False;
        if not BoResult then
          ShowExportMessage('Error','Check system bank details','Run aborted');
      end;

  end;
end;

destructor TExportWrapper.Destroy;
begin
  Exporter.Free;
  inherited Destroy;
end;

function TExportWrapper.StartUp(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
end;

function TExportWrapper.CreateFile(const EventData : TAbsEnterpriseSystem;
                                   const AFileName : String) : Boolean;
begin
  if Exporter <> nil then
  with Exporter, EventData do
  begin
    if Failed = 0 then
    begin
     Result := (CreateOutFile(RequiredPath + AFileName,
                  EventData) = 0);
     if not Result then
           Failed := flFile;
    end;
  end;
end;

function TExportWrapper.Validate(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  if Exporter <> nil then
  with Exporter, EventData do
  begin
{   if Failed = 0 then}
   begin
     Result := ValidateRec(EventData);
     if not Result then
        Failed := flBank;
   end;
  end;
end;

function TExportWrapper.Write(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  if Exporter <> nil then
  with Exporter, EventData do
  begin
{   if Failed = 0 then}
   begin
     Result := WriteRec(EventData, wrPayline);
     if not Result then
        Failed := flRec;
   end;
  end;
end;

function TExportWrapper.Contra(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  if Exporter <> nil then
  with Exporter, EventData do
  begin
{   if Failed = 0 then}
   begin
     Result := WriteRec(EventData, wrContra);
     if not Result then
        Failed := flRec;
   end;
  end;
end;

function TExportWrapper.Close(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  if Exporter <> nil then
  with Exporter, EventData do
  begin
     Result := (CloseOutFile = 0);
     if not Result then
        Failed := flFile
     else
     if TransactionsWritten = 0 then
        Failed := flNoRecs;
  end;
end;

function TExportWrapper.Reject(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := True;
  if Exporter <> nil then
  with Exporter, EventData do
  begin
    if not AlreadyRejected then
    begin
      AlreadyRejected := True;
      ErrorReport(EventData, 0);
    end;
  end;
end;

function TExportWrapper.Erase(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := True;
  if Exporter <> nil then
  with Exporter, EventData do
  begin
     BoResult := EraseOutFile;
     Result := BoResult;
  end;
end;

function TExportWrapper.Complete(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := True;
  if Exporter <> nil then
  with Exporter do
    CompletionMessage(EventData);

end;


{--------------------------------------------------------------------------------------------}

function HandleBatchHooks(const EventData : TAbsEnterpriseSystem;
                                 HID : longint;
                                 WhichObject : Word;
                              FileTypesAllowed : Byte;
                          const PayFile, RecFile : string) : Boolean;
var
  DefaultOutFileName : string;
Begin
  { Handle Hook Events here }
  with EventData do
  begin
    Case  HID of
      1   :  begin
               Try
                 ExportWrapper := TExportWrapper.Create(EventData, WhichObject);
               Except
                 ShowMessage('Unable to create EFT process. Run aborted');
                 BoResult := False;
               End;
             end;
     10   :  begin
               if ExportWrapper <> nil then
                with ExportWrapper, ExportWrapper.Exporter do
                begin
                  GetEventData(EventData);
                  Case FileTypesAllowed of
                    ftaCreditOnly    :  begin
                                          if ProcControl.SalesPurch then
                                          begin
                                            BoResult := False;
                                            ExportWrapper.Free;
                                          end
                                          else
                                          begin
                                            DefaultOutFileName := PayFile;
                                            BoResult := CreateFile(EventData,
                                                 DefaultOutFileName);
                                          end;
                                        end;
                    ftaDebitOnly     :  begin {not needed yet but worth doing?}
                                          if not ProcControl.SalesPurch then
                                          begin
                                            BoResult := False;
                                            ExportWrapper.Free;
                                          end
                                          else
                                          begin
                                            DefaultOutFileName := PayFile;
                                            BoResult := CreateFile(EventData,
                                                 DefaultOutFileName);
                                          end;
                                        end;
                    ftaBoth          :  begin
                                          if ProcControl.SalesPurch then
                                            DefaultOutFileName := RecFile
                                          else
                                            DefaultOutFileName := PayFile;
                                          BoResult := CreateFile(EventData, DefaultOutFileName);
                                        end;
                    end;{case}
                end;
             end;
     20   :  begin
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                 BoResult := Validate(EventData);
               end;
             end;
     30   :  begin
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                 BoResult := Write(EventData);
               end;
             end;
     31   :  begin
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                 BoResult := Contra(EventData);
               end;
             end;
     50   :  begin
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                 Close(EventData);
                 BoResult := True;
               end;
             end;
     60   :  begin
              {reject epf file - what do we need to do here? May as well tell user}
{               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                 Reject(EventData);
               end;}
             end;
     70   :  begin
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                Erase(EventData);
               end;
             end;
     80   :  begin
               if ExportWrapper <> nil then
               with ExportWrapper do
               begin
                 Complete(EventData);
                 Free;
               end;
             end;
     end; {case}
     Result := BoResult;
  end; {if winid...}
end;






end.
