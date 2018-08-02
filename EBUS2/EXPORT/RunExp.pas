unit RunExp;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  UseDLLU, CSVUtils, EbusVar, StrUtil, eBusCnst, UseTKit;

type
  TAccountInfo = class
    bIncludeOnWeb : boolean;
  end;


const
  FTP_LOG_FILENAME = 'FTPLog.Txt';

procedure NumberFiles(HedFileName, LinesFileName : string;
                      var NewHedFileName, NewLineFileName, sDestDir : string;
                      etExportType : TExportType);

function RunExport(sCompanyCode : shortstring; sExportCode : string20;
                   ExportRec : TEBusExport;
                   bNotify : boolean) : boolean;

implementation
uses
  ExprtCSV, APIUtil, Dialogs, eBusUtil, SysUtils, DragCust, DragStk, Export,
  FileUtil, CommsInt, Classes, Forms, Controls, eBusBtrv, MathUtil, XMLCust,
  XMLStock, FTP, XMLInt, TKUtil, COMExprt, FileCtrl, MiscUtil;

procedure NumberFiles(HedFileName, LinesFileName : string;
                      var NewHedFileName, NewLineFileName, sDestDir : string;
                      etExportType : TExportType);
var
  iPos, iNumberLen, iNewNumber, iHedNumberLen, iLinesNumberLen : integer;
begin
  {Work Out File Numbering}
  iHedNumberLen := HowManyCharInString('*', HedFileName, TRUE);
  if LinesFileName = '' then iLinesNumberLen := 100
  else iLinesNumberLen := HowManyCharInString('*', LinesFileName, TRUE);
  iNumberLen := LesserOf(iHedNumberLen, iLinesNumberLen);

  if iNumberLen = 0 then
    begin
      {no file numbering}
      NewHedFileName := sDestDir + HedFileName;
      NewLineFileName := sDestDir + LinesFileName;
    end
  else begin
    {file numbering}
    case etExportType of
      {stock}
      etStockHeader, etStockLocation : begin
        with TEBusStockCounter.Create(TRUE) do begin
          OpenFile;
          iNewNumber := GetNextValue;
          if Length(IntToStr(iNewNumber + 1)) > iNumberLen then SetValue(0);
          CloseFile;
          Free;
        end;{with}
      end;

      {customer}
      etAccount : begin
        with TEBusCustomerCounter.Create(TRUE) do begin
          OpenFile;
          iNewNumber := GetNextValue;
          if Length(IntToStr(iNewNumber + 1)) > iNumberLen then SetValue(0);
          CloseFile;
          Free;
        end;{with}
      end;

      {stock group}
      etStockGroup : begin
        with TEBusStockGrpCounter.Create(TRUE) do begin
          OpenFile;
          iNewNumber := GetNextValue;
          if Length(IntToStr(iNewNumber + 1)) > iNumberLen then SetValue(0);
          CloseFile;
          Free;
        end;{with}
      end;

      {transactions}
      etTXHeader, etTXLines : begin
        with TEBusTransactionCounter.Create(TRUE) do begin
          OpenFile;
          iNewNumber := GetNextValue;
          if Length(IntToStr(iNewNumber + 1)) > iNumberLen then SetValue(0);
          CloseFile;
          Free;
        end;{with}
      end;
    end;{case}

    iPos := Pos('*', HedFileName);
    NewHedFileName := sDestDir + Copy(HedFileName,1,iPos - 1)
    + PadString(psLeft,IntToStr(iNewNumber),'0',iHedNumberLen)
    + Copy(HedFileName,iPos + iHedNumberLen, 255);

    if iLinesNumberLen = 100 then NewLineFileName := ''
    else begin
      NewLineFileName := sDestDir + Copy(LinesFileName,1,iPos - 1)
      + PadString(psLeft,IntToStr(iNewNumber),'0',iLinesNumberLen)
      + Copy(LinesFileName,iPos + iLinesNumberLen, 255);
    end;{if}
  end;{if}
end;

Function RunExport(sCompanyCode : shortstring; sExportCode : string20;
                   ExportRec : TEBusExport; bNotify : boolean) : boolean;
var
  sDestinationDir, sLineFileName, sHedFileName, sMapFileDir : string;
  ExportCSV : TExportCSV;
  bCreateWhilstWriting : boolean;

  procedure WriteToExportLog(ExportType : TExportType; const ErrorMsg : ansistring);
  var
    LogFileDir,
    LogFileName,
    ExportDesc  : string;
    LogFile : TextFile;

    function Title(const TitleStr : string; NewLine : boolean = true) : string;
    const
      FIRST_COLUMN_WIDTH = 13;
    begin
      if NewLine then
        Result := #13#10
      else
        Result := '';
      Result := Result + PadString(psRight, TitleStr + ':', ' ', FIRST_COLUMN_WIDTH);
    end;

  begin // WriteToExportLog
    with TEBusExportLogCounter.Create(true) do
      try
        OpenFile;
        LogFileName := Format('%.8d', [GetNextValue]) + '.LOG';
        CloseFile;
      finally
        Free;
      end;

    LogFileDir := GetCompanyDirFromCode(sCompanyCode) +
      IncludeTrailingBackslash(EBUS_DIR) +
      IncludeTrailingBackslash(EBUS_LOGS_DIR) +
      IncludeTrailingBackslash(EBUS_LOGS_EXPORT_DIR);

    if DirectoryExists(LogFileDir) then
    begin
      LogFileName := LogFileDir + LogFileName;

      ExportDesc := Title('Description', false) + ExportRec.ExptDescription;
      ExportDesc := ExportDesc + Title('Date') + FormatDateTime('dddd, dd/mm/yyyy', Now);
      ExportDesc := ExportDesc + Title('Time') + FormatDateTime('hh:mm:ss', Now);
      ExportDesc := ExportDesc + Title('User') + WinGetUserName;
      ExportDesc := ExportDesc + Title('Computer') + WinGetComputerName;
      ExportDesc := ExportDesc + Title('Type');

      case ExportType of
        etCOMPricing : ExportDesc := ExportDesc + 'COM Pricing'
      else
        ExportDesc := ExportDesc + 'Unknown'
      end;
      ExportDesc := ExportDesc + Title('Message') + #13#10 + ErrorMsg;
    end;

    AssignFile(LogFile, LogFileName);
    try
      rewrite(LogFile);
      try
        writeln(LogFile, ExportDesc);
      finally
        CloseFile(LogFile);
      end;
    except on
      EInOutError do ;
    end;
  end; // WriteToExportLog

  function StartFileLock(etExportType : TExportType) : string;
  var
    sLockFile : string;
    sExt : string3;
  begin
    with ExportRec do begin
      case etExportType of
        {customer}
        etAccount : begin
          sLockFile := ExptCustLockFile;
          sExt := ExptCustLockExt;
          bCreateWhilstWriting := ExptCustLockMethod = 0;
        end;

        {stock}
        etStockHeader, etStockLocation : begin
          sLockFile := ExptStockLockFile;
          sExt := ExptStockLockExt;
          bCreateWhilstWriting := ExptStockLockMethod = 0;
        end;

        {stock group}
        etStockGroup : begin
          sLockFile := ExptStockGrpLockFile;
          sExt := ExptStockGrpLockExt;
          bCreateWhilstWriting := ExptStockGrpMethod = 0;
        end;

        {transactions}
        etTXHeader, etTXLines : begin
          sLockFile := ExptTransLockFile;
          sExt := ExptTransLockExt;
          bCreateWhilstWriting := ExptTransLockMethod = 0;
        end;
      end;{case}
    end;{with}

    if sLockFile = '' then
      begin
        Result := ExtractFilename(sHedFileName);
        Check83ValidFileWithExt(Result, sExt);
        Result := sDestinationDir + Result;
      end
    else Result := sDestinationDir + sLockFile;

    if bCreateWhilstWriting then CreateFile(Result);
  end;

  Procedure RunCSVExport(MapFileRec : TMapFileRec; ExportRec : TEBusExport);
  begin
    FillChar(ExportCSV,sizeof(ExportCSV),#0);
    with ExportRec do begin

      case MapFileRec.ExportType of
        etStockHeader : begin
          {Stock Export}
          ExportCSV := TExportStockCSV.Create;
          with ExportCSV as TExportStockCSV do begin
            CompanyCode := sCompanyCode;
            MapFileName := sMapFileDir + ExptCSVStockMAPFile;
            CSVHedFileName := sHedFileName;
            CSVLineFileName := sLineFileName;
            IgnoreWebIncludeFlag := ExptIgnoreStockWebInc > 0;
//            ExportUpdatedLocations := ExptUpdatedStockLocation > 0;
            ExportMode := TRecExportMode(ExptStock);
            ProdGroupFilter := ExptStockFilter;
            WebCatFilter := ExptStockWebFilter;
            WebCatFilterFlag := ExptStockWebFilterFlag;
          end;{with}
        end;

        etAccount : begin
          {Customer Export}
          ExportCSV := TExportAccountCSV.Create;
          with ExportCSV as TExportAccountCSV do begin
            CompanyCode := sCompanyCode;
            MapFileName := sMapFileDir + ExptCSVCustMAPFile;
            CSVHedFileName := sHedFileName;
            CSVLineFileName := sLineFileName;
            IgnoreWebIncludeFlag := ExptIgnoreCustWebInc > 0;
            ExportMode := TRecExportMode(ExptCustomers);
            AccTypeFilter := ExptCustAccTypeFilter;
            AccTypeFilterFlag := ExptCustAccTypeFilterFlag;
          end;{with}
        end;

        etStockGroup : begin
          {Stock Group Export}
          ExportCSV := TExportStockGroupCSV.Create;
          with ExportCSV do begin
            CompanyCode := sCompanyCode;
            MapFileName := sMapFileDir + ExptCSVStockGrpMAPFile;
            CSVHedFileName := sHedFileName;
            CSVLineFileName := sLineFileName;
            IgnoreWebIncludeFlag := ExptIgnoreStockGrpWebInc > 0;
            ExportMode := TRecExportMode(ExptStockGroups);
          end;{with}
        end;

        etTXHeader : begin
          {Outstanding Transactions Export}
          ExportCSV := TExportTXCSV.Create;
          with ExportCSV do begin
            CompanyCode := sCompanyCode;
            MapFileName := sMapFileDir + ExptCSVTransMAPFile;
            CSVHedFileName := sHedFileName;
            CSVLineFileName := sLineFileName;
            OSTXFilter[1] := ExportRec.ExptIncCurSalesOrders > 0;
            OSTXFilter[2] := ExportRec.ExptIncCurSalesTrans > 0;
            OSTXFilter[3] := ExportRec.ExptIncCurPurchOrders > 0;
            OSTXFilter[4] := ExportRec.ExptIncCurPurchTrans > 0;
          end;{with}
        end;

        else ExportCSV := nil;
      end;{case}

      if Assigned(ExportCSV) then
        begin
          with ExportCSV, MapFileRec do begin
            ExportLastRun := ExptLastExportAt;
            Delimiter := Delimiters[FieldDelimiter];
            Separator := Separators[FieldSeparator];
            ExportCSV.HeaderRow := TCSVHeader(MapFileRec.HeaderRow);
            cTransport := ExptTransportType;
            Success := ProcessExport;
          end;{with}
        end
      else MsgBox('The CSV mapping file is invalid', mtError, [mbOK], mbOK, 'Invalid CSV Mapping File');
    end;{with}
  end;{RunCSVExport}

  function RunXMLExport(etExportType : TExportType) : boolean;
  var
    iResult : integer;
    sDataPath : string;

    procedure ExportXMLTransactions;
    var
      SearchCode : array[0..255] of char;
      Status : integer;
      TXHeader : TBatchTHRec;
      slAccounts, TXs : TStringList;

      function TXHedOK : boolean;
      var
        iIndex : integer;
        AccountInfo : TAccountInfo;
        AccountRec : TBatchCURec;
        pCustKey : PChar;
        asCustKey : ANSIString;
      begin
        Result := FALSE;
        with TXHeader do begin
          if (TransDocHed = 'SOR') and (ExportRec.ExptIncCurSalesOrders > 0)
          then Result := TRUE
          else begin
            if (TransDocHed = 'POR') and (ExportRec.ExptIncCurPurchOrders > 0) then Result := TRUE
            else begin
              if (AllocStat = 'C') and (ExportRec.ExptIncCurSalesTrans > 0) then Result := TRUE
              else begin
                if (AllocStat = 'S') and (ExportRec.ExptIncCurPurchTrans > 0) then Result := TRUE
              end;{if}
            end;
          end;{if}

          //NF: 30/09/06 - Looks up the customer, to see if the include on web flag is set.
          if Result then
          begin
            iIndex := slAccounts.IndexOf(CustCode);
            if iIndex = -1 then
            begin
              // not found in list, so look it up in database
              asCustKey := CustCode;
              pCustKey := PChar(asCustKey);
              Status := EX_GETACCOUNT(@AccountRec, SizeOf(AccountRec), pCustKey, 0, B_GetEq, 0, FALSE);
              if Status = 0 then
              begin
                // Add To List;
                AccountInfo := TAccountInfo.Create;
                AccountInfo.bIncludeOnWeb := AccountRec.AllowWeb > 0;
                slAccounts.AddObject(CustCode, AccountInfo);
                Result := AccountInfo.bIncludeOnWeb;
              end;{if}
            end else
            begin
              // found in list
              Result := TAccountInfo(slAccounts.Objects[iIndex]).bIncludeOnWeb;
            end;
          end;{if}
        end;{with}
      end;{TXHedOK}

    begin{ExportXMLTransactions}

      TXs := TStringList.Create;
      slAccounts := TStringList.Create;

      {gets all OS not orders}
      FillChar(SearchCode, SizeOf(SearchCode), 0);
      Status := EX_GETTRANSHED(@TXHeader, SizeOf(TXHeader), SearchCode, 11, B_GetFirst,FALSE);
      while Status = 0 do begin
        if TXHedOK then TXs.Add(TXHeader.OurRef);
        Status := EX_GETTRANSHED(@TXHeader, SizeOf(TXHeader), SearchCode, 11, B_GetNext,FALSE);
      end;{while}

      {gets all OS Sales Orders}
      Status := EX_GETTHBYRUNNO(@TXHeader, SizeOf(TXHeader), -40, B_GetGEq,FALSE);
      while (Status = 0) and (TXHeader.RunNo = -40) do begin
        if TXHedOK then TXs.Add(TXHeader.OurRef);
        Status := EX_GETTHBYRUNNO(@TXHeader, SizeOf(TXHeader), -40, B_GetNext,FALSE);
      end;{while}

      {gets all OS Purchase Orders}
      Status := EX_GETTHBYRUNNO(@TXHeader, SizeOf(TXHeader), -50, B_GetGEq,FALSE);
      while (Status = 0) and (TXHeader.RunNo = -50) do begin
        if TXHedOK then TXs.Add(TXHeader.OurRef);
        Status := EX_GETTHBYRUNNO(@TXHeader, SizeOf(TXHeader), -50, B_GetNext,FALSE);
      end;{while}

      // Clear-up Accounts list
      ClearList(slAccounts);
      slAccounts.Free;

      EX_CLOSEDATA; {Close Toolkit - because ENTXML.DLL opens it}

      with TXMLInterface.Create do begin
        try
          try
            DataPath := sDataPath;
            CurrVer := GetMultiCurrencyCode;
            XMLPath := sDestinationDir + ExportRec.ExptTransFileName;

            if LoadXMLDLL = 0 then CreateXMLExportFile(TXs);
          except on E:Exception do
            ShowMessage('TXMLInterface Exception : ' + E.Message);
          end;{try}
        finally
          Free;
        end;{try}
      end;{with}

      {reopen toolkit - so this behaves just like the other exports}
      SetToolkitPath(sDataPath);
      iResult := Ex_InitDLL;

      TXs.Free;
    end;{ExportXMLTransactions}

  begin{RunXMLExport}


    {open toolkit}
    sDataPath := GetCompanyDirFromCode(Trim(sCompanyCode));
    SetToolkitPath(sDataPath);
    iResult := Ex_InitDLL;

    if iResult <> 0 then ShowMessage('Ex_InitDLL Error : ' + IntToStr(iResult))
    else begin
      with ExportRec do begin
        case etExportType of
          etStockHeader, etStockLocation : begin
            with TWriteXMLStock.Create do begin
              try
                ExportLastRun := ExptLastExportAt;
                IgnoreWebIncludeFlag := ExptIgnoreStockWebInc > 0;
//                ExportUpdatedLocations := ExptUpdatedStockLocation > 0;
                ExportMode := TRecExportMode(ExptStock);
                ProdGroupFilter := ExptStockFilter;
                WebCatFilter := ExptStockWebFilter;
                WebCatFilterFlag := ExptStockWebFilterFlag;
                CreateXML;
                SaveToFile(sHedFileName, true);
              finally
                Free;
              end;{try}
            end;{with}
          end;

          etAccount : begin
            with TWriteXMLCustomer.Create do begin
              try
                ExportLastRun := ExptLastExportAt;
                IgnoreWebIncludeFlag := ExptIgnoreCustWebInc > 0;
                ExportMode := TRecExportMode(ExptCustomers);
                AccTypeFilter := ExptCustAccTypeFilter;
                AccTypeFilterFlag := ExptCustAccTypeFilterFlag;
                CreateXML;
                SaveToFile(sHedFileName, true);
              finally
                Free;
              end;{try}
            end;{with}
          end;

          etStockGroup : begin
            with TWriteXMLStockGroup.Create do begin
              try
                IgnoreWebIncludeFlag := ExptIgnoreStockGrpWebInc > 0;
                ExportMode := TRecExportMode(ExptStockGroups);
                CreateXML;
                SaveToFile(sHedFileName, true);
              finally
                Free;
            end;{with}
          end;

              end;{try}
          etTXHeader, etTXLines : begin
            ExportXMLTransactions;
          end;
        end;{case}
      end;{with}

//      Ex_CloseData;
      Ex_CloseDLL;

    end;{if}
    Result := iResult = 0;
  end;

  function RunCOMPricingExport : boolean;
  var
    DataPath : string;
    Status : integer;
  begin
    DataPath := GetCompanyDirFromCode(Trim(sCompanyCode));
    SetToolkitPath(DataPath);
    Status := Ex_InitDLL;
    // Raise exception and log ?
    if Status <> 0 then
      ShowMessage('Ex_InitDLL Error : ' + IntToStr(Status) + #13#13 + EX_GETLASTERRORDESC)
    else
      with TExportCOMFiles.Create do
        try
          CompanyDir := GetCompanyDirFromCode(sCompanyCode);
          ExportDir := sDestinationDir;
          LastRun := ExportRec.ExptLastExportAt;
          if ExportRec.ExptIncCOMPricing = 1 then
            UpdateMode := updOverwrite
          else
            UpdateMode := updUpdate;

          IgnoreCustWebIncludeFlag := ExportRec.ExptIgnoreCOMCustInc = 1;
          IgnoreStockWebIncludeFlag := ExportRec.ExptIgnoreCOMStockInc = 1;
          Result := RunCOMExport = 0;
          if not Result then
            WriteToExportLog(etCOMPricing, ErrorMsg);
       finally
         Free;
//         Ex_CloseData;
         Ex_CloseDLL;
       end;
  end; // function RunCOMPricingExport

  function ExportFile(ExportType : TExportType; ExportRec : TEBusExport; sCSVMapFilename : string) : boolean;
  var
{    slFiles : TStringList;}
    CSVMapRec : TMapFileRec;
    sLockFileName : string;
{    iResult : integer;}

    Function TransportFile : boolean;
    begin
      Result := FALSE;
      with ExportRec do begin
        case ExptTransportType of
          'F' : begin
            {FTP The File}
            with ToFTP.Create(sCompanyCode, ExportType) do begin
              if LoadedOK then begin
                LogFilename := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + FTP_LOG_FILENAME;
                if SendFile(sHedFileName) = 0 then
                  begin
                    Result := SendFile(sLineFileName) = 0;
                  end
                else begin
                  Result := FALSE;
                end;{if}
              end;{if}
              Free;
            end;{with}
          end;

    (*      'E' : begin
            {Email the file}

            slAttachments := TStringList.Create;
            slAttachments.Add

            with TEntEmail.Create do begin
              Attachments := slAttachments;
              Message :=
              Priority := 1;
              Recipients : TStringList
              Property Sender : ShortString Read FSender Write FSender;
              SenderName := 'Exchequer eBusiness Module';
              SMTPServer :=
              Subject :=
              UseMAPI :=

              Send;
            end;{with}
          end;*)
        end;{case}
      end;{with}
    end;{TransportFile}

    function ZipFile(var sFileToZip : string): smallint;
    var
      sZipFilename : string;
    begin
      if sFileToZip <> '' then begin
        with TEntZip.Create do begin
{          Files := TStringList.Create;}
          Files.Add(sFileToZip);

          DOSPaths := TRUE;
          OverwriteExisting := TRUE;
          Recurse := FALSE;
          RemoveDots := TRUE;
          StripDrive := TRUE;
          StripPath := TRUE;

          sZipFilename := ExtractFileName(sFileToZip);
          Check83ValidFileWithExt(sZipFilename, 'ZIP');
          sZipFilename := ExtractFileDir(sFileToZip) + '\' + sZipFilename;
          ZipName := sZipFilename;

          Result := Save;
          if Result = 0 then begin
            DeleteFile(sFileToZip);
            sFileToZip := sZipFilename;
          end;{if}

          Free;
        end;{with}
      end;{if}
    end;{ZipFile}

  begin{ExportFile}
    Result := FALSE;

    with ExportRec do begin
      {FTP / Email Directory to put files in := Enterprise's "Swap" Directory}
      if ExptTransportType in ['F', 'E'] then sDestinationDir := GetEntSwapDir(GetCompanyDirFromCode(Trim(sCompanyCode)));

      case ExportType of
        etStockHeader : begin
          if ExptTransportType = 'D' then sDestinationDir := GetFileRecord(sCompanyCode, sExportCode).FileStockDir;
          NumberFiles(ExptStockFileName, ExptStockLocFileName, sHedFileName, sLineFileName
          , sDestinationDir, ExportType);
        end;

        etAccount : begin
          if ExptTransportType = 'D' then sDestinationDir := GetFileRecord(sCompanyCode, sExportCode).FileCustomerDir;
          NumberFiles(ExptCustFileName, '', sHedFileName, sLineFileName
          , sDestinationDir, ExportType);
        end;

        etStockGroup : begin
          if ExptTransportType = 'D' then sDestinationDir := GetFileRecord(sCompanyCode, sExportCode).FileStockGroupDir;
          NumberFiles(ExptStockGroupFileName, '', sHedFileName, sLineFileName
          , sDestinationDir, ExportType);
        end;

        etTXHeader : begin
          if ExptTransportType = 'D' then sDestinationDir := GetFileRecord(sCompanyCode, sExportCode).FileTransDir;
          NumberFiles(ExptTransFileName, ExptTransLinesFileName, sHedFileName, sLineFileName
          , sDestinationDir, ExportType);
        end;

        etCOMPricing : begin
          if ExptTransportType = 'D' then sDestinationDir := GetFileRecord(sCompanyCode, sExportCode).FileCOMPriceDir;
         (* NumberFiles(ExptStockFileName, ExptStockLocFileName, sHedFileName, sLineFileName
          , sDestinationDir, ExportType); *)
        end;
      end;{case}

      if ExportType = etCOMPricing then
        begin
          Result := RunCOMPricingExport;
          sHedFileName := sDestinationDir + 'ENTPRCO.ZIP';
        end
      else begin
        sLockFilename := StartFileLock(ExportType);
        if not bCreateWhilstWriting then DeleteFile(sLockFileName);

        case ExptDataType of
          'C' : begin
            CSVMapRec := GetMapFileRec(sCSVMapFilename);
            RunCSVExport(CSVMapRec, ExportRec);
            Result := ExportCSV.Success;
            sHedFilename := ExportCSV.CSVHedFileName;
            ExportCSV.Free;
          end;

          'X' : begin
            {XML}
            Result := RunXMLExport(ExportType);
          end;

          'D' : begin
            {Dragnet}
            Result := TRUE;
            case ExportType of
              etStockHeader : DoDragnetStockExport;
              etAccount : DoDragnetCustExport;
            end;{case}
          end;
        end;{case}

        if Result then begin
          if (ExportRec.ExptZipFiles = 1) then begin
            Result := ZipFile(sHedFilename) = 0;
            if Result and (ExptDataType = 'C') and (CSVMapRec.ExportFormat in [efBothSeparate, efBothTogether])
            then Result := ZipFile(sLineFilename) = 0;
          end;{if}
        end;{if}

        if bCreateWhilstWriting then DeleteFile(sLockFileName)
        else CreateFile(sLockFileName);
      end;

      {send file}
      if ExptTransportType in ['F', 'E'] then Result := TransportFile;

    end;{with}
  end;{ExportFile}

  procedure RunPostExportCommand;
{  var
    iPos : integer;
    sFilename : string;}
  begin{RunPostExportCommand}
    with ExportRec do begin
      ExptCommandLine := Trim(ExptCommandLine);
{       iPos := Pos(' ',ExptCommandLine);
      if iPos = 0 then sFilename := ExptCommandLine
      else sFilename := Copy(ExptCommandLine,1,iPos - 1);
      if FileExists(sFilename) then }RunApp(ExptCommandLine, FALSE);
    end;{with}
  end;{RunPostExportCommand}

begin{RunExport}
  Screen.Cursor := crHourglass;
  sMapFileDir := GetMapFileDir;
  Result := TRUE;
  with ExportRec do begin
    if (ExptCustomers > 0) then
      Result := ExportFile(etAccount, ExportRec, sMapFileDir + ExptCSVCustMAPFile);
    if Result and (ExptStock > 0) then
      Result := ExportFile(etStockHeader, ExportRec, sMapFileDir + ExptCSVStockMAPFile);
    if Result and (ExptStockGroups > 0) then
      Result := ExportFile(etStockGroup, ExportRec, sMapFileDir + ExptCSVStockGrpMAPFile);
    if Result and ((ExptIncCurSalesTrans > 0) or (ExptIncCurSalesOrders > 0) or (ExptIncCurPurchTrans > 0)
    or (ExptIncCurPurchOrders > 0)) then Result := ExportFile(etTXHeader, ExportRec, sMapFileDir + ExptCSVTransMAPFile);
    if Result and (ExptIncCOMPricing > 0) then
      Result := ExportFile(etCOMPricing, ExportRec, '');

    {runs the "after export" command line}
    if Result then RunPostExportCommand;
  end;{with}

  if bNotify then begin
    if Result then MsgBox('The export was completed successfully.',mtInformation, [mbOK], mbOK, 'Export')
    else MsgBox('The export was not completed successfully.',mtWarning, [mbOK], mbOK, 'Export');
  end;{if}
  Screen.Cursor := crDefault;
end;{RunExport}

end.
