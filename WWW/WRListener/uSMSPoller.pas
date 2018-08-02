unit uSMSPoller;

interface

uses Classes, Windows, SysUtils, SQLDataset, pvSQLTables;

type
  TSMSPoller = class(TThread)
  private
    oSMS: variant;
    procedure SendPending;
    procedure WriteError(ErrorMsg: string);
  protected
    procedure Execute; override;
  public
    SMSDB: TPvSqlDatabase;
    SMSQuery: TPVQuery;
    SMSUpdate: TPVQuery;
  end;

implementation

uses ComObj, Variants, ActiveX;

const
MaxSize = 1024 * 1024;

//*** Main *********************************************************************

procedure TSMSPoller.Execute;
begin
  try
    Coinitialize(nil);
    oSMS:= CreateOleObject('EnterpriseSMS.SMSSender');
  except
    on E: Exception do WriteError(E.Message);
  end;

  try

    while not Terminated do
    begin
      Sleep(10000);
      Synchronize(SendPending);
    end;

  finally
    oSMS:= UnAssigned;
    CoUninitialize;
  end;
end;

procedure TSMSPoller.SendPending;
var
PulseFile: TextFile;
SMSResult: integer;
begin
  try
    SMSResult:= -1;

    AssignFile(PulseFile, 'C:\Development\WRListener\SMSPulse.txt');
    Rewrite(PulseFile);
    Writeln(PulseFile, 'Last polled SMS Pending: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
    CloseFile(PulseFile);

    with SMSQuery do   
    begin
      SMSDB.Open;
      Close; // There is an embedded query in the SQL property of SMSQuery, 
      Open;  // which is triggered by this close/open pairing.
      if (not eof) then
      begin
        try
          oSMS.Number:= Trim(FieldByName('SMSPhone').AsString);  { SMSQuery.FieldByName }
          oSMS.Message:= Trim(FieldByName('SMSText').AsString);  { SMSQuery.FieldByName }
          SMSResult:= oSMS.Send;
        finally
          with SMSUpdate do
          begin
            // AB 16/09/2003 Added SMSUpdate and SMSQuery to this code to ensure that it is less ambiguous.
            // Possible that the compiler is getting 'confused' cos SMSUpdate and SMSQuery are both the same object type.
            SMSUpdate.ParamByName('psmsid').AsInteger := SMSQuery.FieldByName('SMSID').AsInteger; { SMSQuery.FieldByName }
            SMSUpdate.ParamByName('perror').AsInteger := SMSResult;
            SMSUpdate.ExecSql;
          end;
        end; // try...finally
      end; // if (not eof) then

      try // AB - 2
        SMSQuery.Close;
        SMSUpdate.Close;
        SMSDB.Close;
      except
        on E:Exception do WriteError(E.Message);
      end;

    end; // with SMSQuery do

  except
    on E:Exception do WriteError(E.Message);
  end;
end;

procedure TSMSPoller.WriteError(ErrorMsg: string);
var
ErrorLog: TextFile;
SearchRec: TSearchRec;
FindRec: integer;
DoDelete: boolean;
begin

  FindRec:= FindFirst('C:\Development\WRListener\error.log', faAnyFile, SearchRec);
  DoDelete:= (FindRec = 0) and (SearchRec.Size > MaxSize);
  FindClose(SearchRec);

  if DoDelete then DeleteFile('C:\Development\WRListener\error.log');

  AssignFile(ErrorLog, 'C:\Development\WRListener\error.log');
  if FileExists('C:\Development\WRListener\error.log') then Append(ErrorLog) else Rewrite(ErrorLog);
  Writeln(ErrorLog, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + ' SMS error: ' + ErrorMsg);
  CloseFile(ErrorLog);

end;

//******************************************************************************

end.
