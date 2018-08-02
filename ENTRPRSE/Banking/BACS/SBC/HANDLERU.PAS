unit HandlerU;

{ prutherford440 15:13 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses CustWinU, CustAbsU, ChainU, ExpObj;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Dialogs, SysUtils, Forms, Classes, ScbObj, Scb01;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

  BacsHook = EnterpriseBase + 2050;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Begin
  CustomOn := True;

  { Enable Hooks and Set About Message here }
  with CustomHandlers do
  begin
    AddAboutString ('SCB Custom Hook.');
    AddAboutString ('Creates SCB Format File.');

    AddAboutString ('Copyright Exchequer Software Ltd. 1986 - 2000.');
    AddAboutString ('Version: 1.00');

    SetHandlerStatus(BacsHook, 1, EventEnabled);
    SetHandlerStatus(BacsHook, 10, EventEnabled);
    SetHandlerStatus(BacsHook, 20, EventEnabled);
    SetHandlerStatus(BacsHook, 30, EventEnabled);
    SetHandlerStatus(BacsHook, 31, EventEnabled);
    SetHandlerStatus(BacsHook, 50, EventEnabled);
    SetHandlerStatus(BacsHook, 60, EventEnabled);
    SetHandlerStatus(BacsHook, 70, EventEnabled);
    SetHandlerStatus(BacsHook, 80, EventEnabled);
  end;
  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
var
  TotalValue : Double;
  ReportMemo : TStringList;
  StoreCurrencyString : string;
  DefaultOutFileName : string;

Begin
  { Handle Hook Events here }
  with EventData do
  if WinID = BacsHook then
  begin
    Case  HandlerID of
      1   :  begin
               Try
                 SCBExportObject := TSCBExportObject.Create(EventData);
                 BoResult := True;
                 if SCBExportObject.Failed > 0 then
                 begin
                   ShowMessage('Run aborted');
                   SCBExportObject.Free;
                   BoResult := False;
                 end;
               Except
                 ShowMessage('Unable to create EFT process. Run aborted');
                 BoResult := False;
               End;
             end;
     10   :  begin
               if SCBExportObject <> nil then
                with SCBExportObject do
                begin
                  GetEventData(EventData);
                  if ProcControl.SalesPurch then
                    DefaultOutFileName := DefaultRecFileName
                  else
                    DefaultOutFileName := DefaultPayFileName;
                  BoResult := (CreateOutFile(CheckPath(Setup.ssDataPath) + DefaultOutFileName,
                               EventData) = 0);
                  if not BoResult then
                    Failed := flFile;
                end;
             end;
     20   :  begin
               if SCBExportObject <> nil then
               with SCBExportObject do
               begin
                if Failed = 0 then
                begin
                 BoResult := ValidateRec(EventData);
                 if not BoResult then
                   Failed := flBank;
                end;
               end;
             end;
     30   :  begin
               if SCBExportObject <> nil then
               with SCBExportObject do
               begin
                if Failed = 0 then
                begin
                 BoResult := WriteRec(EventData, PayLine);
                end;
               end;
             end;
     31   :  begin
               if SCBExportObject <> nil then
               with SCBExportObject do
               begin
                if Failed = 0 then
                begin
                 BoResult := WriteRec(EventData, Contra);
                end;
               end;
             end;
     50   :  begin
               if SCBExportObject <> nil then
               with SCBExportObject do
               begin
                 BoResult := (CloseOutFile = 0);
                 if not BoResult then
                   Failed := flFile;
               end;
             end;
     60   :  begin
              {reject epf file - what do we need to do here? May as well tell user}
               if SCBExportObject <> nil then
               with SCBExportObject do
               begin
                 ReportMemo := TStringList.Create;
                 with ReportMemo do
                 begin
                  Try
                   Add(Setup.ssUserName);
                   Add('Batch processing run no. ' + IntToStr(ProcControl.PayRun));
                   Add('');
                   Add('Run aborted');
                   Add('');
                   Add('Details will be shown on the Batch Payment Status report');
                   Add('');
                   Add('Press ''Close'' to continue');
                   ShowExportReport('Batch processing run no. ' + IntToStr(ProcControl.PayRun),
                                      ReportMemo);
                  Finally
                   Free;
                  End;
                 end; {with ReportMemo}
               end; {with SCBExportObject}
             end;
     70   :  begin
               if SCBExportObject <> nil then
               with SCBExportObject do
               begin
                 BoResult := EraseOutFile;
               end;
             end;
     80   :  begin
               if SCBExportObject <> nil then
                with SCBExportObject do
                begin
                 Try
                  if Failed = 0 then
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
                 Finally
                  Free;
                 End;
                end; {with SCBExportObject}
             end;
     end; {case}
  end; {if winid...}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
