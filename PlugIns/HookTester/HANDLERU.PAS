unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  Enterprise01_TLB, CTKUtil, Math, ComObj, APIUtil, CustWinU, CustAbsU, Classes
  , ActiveX, Controls, Types, Inifiles;

var
  slCustomText, slHookPoints : TStringList;
  TextIniFile, Inifile : TInifile;
//  bFilter : boolean;

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  Account, Job, TransactionLine, Transaction, HookProc, Dialogs, SysUtils
  , ChainU, PIMisc, Forms, Stock, SerialBatch, MultiBin, Email, SystemInfo;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
const
  sPlugInName = 'Hook Tester Plug-In';
  {$IFDEF EX600}
    sVersionNo = 'v6.XX.017';
  {$ELSE}
    sVersionNo = 'v5.XX.017';
  {$ENDIF}
var
  iEID : byte;
  iHook, iPos : integer;
  slAboutText : TStringList;
begin
  CustomOn := True;

  Inifile := TInifile.Create(ExtractFilePath(application.exename) + 'HookTest.ini');
  TextInifile := TInifile.Create(ExtractFilePath(application.exename) + 'HookText.ini');
//  Inifile := TInifile.Create('HookTest.ini');
  slHookPoints := TStringList.Create;
  slCustomText := TStringList.Create;

  Inifile.ReadSections(slHookPoints);
  TextInifile.ReadSections(slCustomText);

  With TAbsCustomHandlers01(CustomHandlers) Do Begin
    { Set About Message }
    slAboutText := TStringList.Create;
    PIMakeAboutText(sPlugInName, sVersionNo + ' (DLL)', slAboutText);
    for iPos := 0 to slAboutText.Count - 3 do AddAboutString(slAboutText[iPos]);

    // Detect if Custom button1 is already in use.
{      iHookId := -1;
    if (not HookPointEnabled(wiTransaction, 14)) then iHookId := 14
    else begin
      iHookId := 24;
    end;}

    AddAboutString('   [Hook Points]');
    for iPos := 0 to slHookPoints.Count-1 do begin
      SetHandlerStatus(GetWindowID(slHookPoints[iPos]), GetHandlerID(slHookPoints[iPos]), EventEnabled);
      AddAboutString('   ' + slHookPoints[iPos]);
    end;

    AddAboutString('');
    AddAboutString('   [Custom Text]');
    for iPos := 0 to slCustomText.Count-1 do begin
      AddAboutString('   ' + slCustomText[iPos]);
    end;

    AddAboutString('');
    AddAboutString(slAboutText[slAboutText.Count - 2]);
    AddAboutString(slAboutText[slAboutText.Count - 1]);

    slAboutText.Free;
  End; { With }

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);

End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  slHookPoints.Free;
  slCustomText.Free;

  Inifile.Free;
  TextIniFile.Free;

  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
var
  iLine, iPos : integer;
  sStrResult, sIntResult, sTemp : string;

  procedure ShowJob(Job: TAbsJob3; iHandlerID : integer);
  var
    FrmJob : TFrmJob;
  begin{ShowJob}
    with TFrmJob.Create(application) do begin
      LJob := Job;
      LHandlerID := iHandlerID;
      showmodal;
      Release;
    end;{with}
  end;{ShowJob}

  procedure ShowStock(Stock: TAbsStock3; iHandlerID : integer);
  var
    FrmStock : TFrmStock;
  begin{ShowStock}
    with TFrmStock.Create(application) do begin
      LStock := Stock;
      LHandlerID := iHandlerID;
      showmodal;
      Release;
    end;{with}
  end;{ShowStock}

  procedure ShowStrResult(strResult : string; iHandlerID : integer);
  begin{ShowStrResult}
    MsgBox('strResult = ' + QuotedStr(strResult), mtInformation, [mbOK], mbOK
    , IntToStr(iHandlerID));
  end;{ShowStrResult}

  procedure ShowTransaction(TX: TAbsInvoice5; iHandlerID : integer);
  var
    FrmTransaction : TFrmTransaction;
  begin{ShowTransaction}
    with TFrmTransaction.Create(application) do begin
      LTX := TX;
      LHandlerID := iHandlerID;
      showmodal;
      Release;
    end;{with}
  end;{ShowTransaction}

  procedure ShowAccount(Account: TAbsCustomer2; iHandlerID : integer);
  var
    FrmAccount : TFrmAccount;
  begin{ShowAccount}
    with TFrmAccount.Create(application) do begin
      LAccount := Account;
      LHandlerID := iHandlerID;
      showmodal;
      Release;
    end;{with}
  end;{ShowAccount}

  procedure ShowTransactionLine(TXLine: TAbsInvLine5; iHandlerID : integer);
  var
    FrmTransaction : TFrmTransaction;
  begin{ShowTransaction}
    with TFrmTransactionLine.Create(application) do begin
      LTXLine := TXLine;
      LHandlerID := iHandlerID;
      showmodal;
      Release;
    end;{with}
  end;{ShowTransactionLine}

  procedure ShowSerialBatch(SerialBatch : TAbsBatchSerial3; iHandlerID : integer);
  var
    FrmSerialBatch : TFrmSerialBatch;
  begin{ShowTransaction}
    with TFrmSerialBatch.Create(application) do begin
      LSerialBatch := SerialBatch;
      LHandlerID := iHandlerID;
      showmodal;
      Release;
    end;{with}
  end;{ShowSerialBatch}

  procedure ShowMultiBin(MultiBin : TAbsMultiBin2; iHandlerID : integer);
  var
    FrmMultiBin : TFrmMultiBin;
  begin{ShowTransaction}
    with TFrmMultiBin.Create(application) do begin
      LMultiBin := MultiBin;
      LHandlerID := iHandlerID;
      showmodal;
      Release;
    end;{with}
  end;{ShowMultiBin}

  procedure ShowEmail(Email : TAbsPaperlessEmail; iHandlerID : integer);
  var
    FrmMultiBin : TFrmMultiBin;
  begin{ShowTransaction}
    with TFrmEmail.Create(application) do begin
      LEmail := Email;
      LHandlerID := iHandlerID;
      showmodal;
      Release;
    end;{with}
  end;{ShowEmail}

  procedure ShowSystem(System : TAbsEnterpriseSystem04);
  var
    FrmMultiBin : TFrmMultiBin;
  begin{ShowTransaction}
    with TFrmSystem.Create(application) do begin
      LSystem := System;
      showmodal;
      Release;
    end;{with}
  end;{ShowEmail}

var
  oToolkit : IToolkit;
  oTXUpdate : ITransaction;
  iStatus : integer;

Begin
  // A 'Hook Event' has occured

  With TAbsEnterpriseSystem04(EventData) Do Begin

{    if (WinID = wiBACS) and (HandlerID = 170)
    then bFilter := MsgBox('Filter ?', mtconfirmation, [mbYes, mbNo], mbYes, 'Filter') = mrYes;

    if (WinID = wiBACS) and (HandlerID = 172)
    then boResult := TRUE;

    if (WinID = wiBACS) and (HandlerID = 174)
    then begin
      if bFilter then boResult := EventData.Transaction.thOurRef = 'PIN000886'
      else boResult := TRUE;
    end;{if}


    for iPos := 0 to slHookPoints.Count-1 do begin
      if (GetWindowID(slHookPoints[iPos]) = WinID) and (GetHandlerID(slHookPoints[iPos]) = HandlerID)
      then begin
        // Hook Executed Message
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowMessage','TRUE')) = 'TRUE'
        then ShowMessage('Hook Executed : ' + slHookPoints[iPos]);

        // Show StrResult
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowStrResult','FALSE')) = 'TRUE'
        then begin
          ShowStrResult(strResult, WinID + HandlerID);
        end;{if}

        // Show Job
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowJob','FALSE')) = 'TRUE'
        then begin
          ShowJob(TAbsJob3(Job), WinID + HandlerID);
        end;{if}

        // Show Stock
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowStock','FALSE')) = 'TRUE'
        then begin
          ShowStock(Stock3, WinID + HandlerID);
        end;{if}

        // Show TX
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowTX','FALSE')) = 'TRUE'
        then begin
          ShowTransaction(TAbsInvoice5(Transaction), WinID + HandlerID);
        end;{if}

        // Show Customer
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowCustomer','FALSE')) = 'TRUE'
        then begin
          ShowAccount(TABSCustomer2(EventData.Customer), WinID + HandlerID);
        end;{if}

        // Show Supplier
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowSupplier','FALSE')) = 'TRUE'
        then begin
          ShowAccount(TABSCustomer2(EventData.Supplier), WinID + HandlerID);
        end;{if}

        // Show TX Line
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowTXLine','FALSE')) = 'TRUE'
        then begin
          ShowTransactionLine(TAbsInvLine5(Transaction.thLines.thCurrentLine), WinID + HandlerID);
        end;{if}

        // Show TX Line 1
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowTXLine1','FALSE')) = 'TRUE'
        then begin
          if Transaction.thLines.thLineCount = 0 then ShowMessage('ShowTXLine1 : Transaction.thLines.thLineCount = 0')
          else ShowTransactionLine(TAbsInvLine5(Transaction.thLines.thLine[1]), WinID + HandlerID);
        end;{if}

        // Show Serial/Batch details
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowSerial','FALSE')) = 'TRUE'
        then begin
          ShowSerialBatch(TAbsBatchSerial3(BatchSerial), WinID + HandlerID);
        end;{if}

        // Show MultiBin details
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowMultiBin','FALSE')) = 'TRUE'
        then begin
          ShowMultiBin(TAbsMultiBin2(Bin), WinID + HandlerID);
        end;{if}

        // Show Email details
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowEmail','FALSE')) = 'TRUE'
        then begin
          ShowEmail(Paperless.Email, WinID + HandlerID);
        end;{if}

        // Show System details
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowSystem','FALSE')) = 'TRUE'
        then begin
          ShowSystem(TAbsEnterpriseSystem04(EventData){, WinID + HandlerID});
        end;{if}

        // Ask for boResult
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'Ask4boResult','FALSE')) = 'TRUE'
        then begin
          boResult := MsgBox('Set boResult to :',mtConfirmation,[mbYes,mbNo],mbYes,
          slHookPoints[iPos] + ' : Set boResult') = mrYes;
        end;{if}

        // Set boResult
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'SetBoResult','')) = 'TRUE'
        then boResult := TRUE;
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'SetBoResult','')) = 'FALSE'
        then boResult := FALSE;

        // Ask for IntResult
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'Ask4IntResult','FALSE')) = 'TRUE'
        then begin
          sIntResult := IntToStr(IntResult);
          if InputQuery('Set IntResult', 'Set IntResult to :', sIntResult) then
          begin
            IntResult := StrToIntDef(sIntResult, 0);
          end;{if}
        end;{if}

        // Set IntResult
        if Inifile.ReadString(slHookPoints[iPos],'SetIntResult','') <> '' then
        begin
          IntResult := Inifile.ReadInteger(slHookPoints[iPos],'SetIntResult',0);
        end;{if}

        // Ask for ValidStatus
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'Ask4ValidStatus','FALSE')) = 'TRUE'
        then begin
          ValidStatus := MsgBox('Set ValidStatus to :',mtConfirmation,[mbYes,mbNo],mbYes,
          slHookPoints[iPos] + ' : Set ValidStatus') = mrYes;
        end;{if}

        // Show StrResult
{        if uppercase(Inifile.ReadString(slHookPoints[iPos],'ShowStrResult','FALSE')) = 'TRUE'
        then begin
          MsgBox('StrResult : ' + StrResult, mtInformation, [mbOK,mbOK], mbOK
          , slHookPoints[iPos] + ' : ShowStrResult');
        end;{if}

        // Ask for StrResult
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'Ask4StrResult','FALSE')) = 'TRUE'
        then begin
          sStrResult := StrResult;
          if InputQuery('Set StrResult', 'Set StrResult to :', sStrResult) then
          begin
            StrResult := sStrResult;
          end;{if}
        end;{if}

        // Set StrResult
        if Inifile.ReadString(slHookPoints[iPos],'SetStrResult','') <> '' then
        begin
          StrResult := Inifile.ReadString(slHookPoints[iPos],'SetStrResult','');
        end;{if}

        // Test Updating the Transaction using the Toolkit
        if uppercase(Inifile.ReadString(slHookPoints[iPos],'TestUpdateTX','FALSE')) = 'TRUE' then
        begin
          CoInitialize(nil);
          oToolkit := OpenToolkit(EventData.Setup.ssDataPath, TRUE);
          if Assigned(oToolkit) then
          begin
            oToolkit.Transaction.Index := thIdxOurRef;
            iStatus := oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex(EventData.Transaction.thOurRef));
            if iStatus = 0 then
            begin
              oTXUpdate := oToolkit.Transaction.Update;
              if Assigned(oTXUpdate) then
              begin
                iStatus := oTXUpdate.Save(FALSE);
                if iStatus = 0 then
                begin
                  ShowMessage('Transaction Updated Successfully.');
                end
                else
                begin
                  ShowTKError('Error Saving Updated Transaction : ' + EventData.Transaction.thOurRef, iStatus);
                end;{if}
              end
              else
              begin
                ShowMessage('oTXUpdate = nil');
              end;{if}
            end
            else
            begin
              ShowTKError('Error Finding Transaction : ' + EventData.Transaction.thOurRef, iStatus);
            end;{if}
          end;{if}
          CoUnInitialize;
        end;{if}
      end;{if}
    end;{for}
  end;{with}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
