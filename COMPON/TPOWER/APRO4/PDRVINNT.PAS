{*********************************************************}
{*                   PDRVINNT.PAS 4.03                   *}
{*      Copyright (c) TurboPower Software 1997-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$X+,I-,T-}
{$H-,J-}

unit PDrvInNT;
  {- Fax printer driver installation unit for NT}

interface

const
  DriverFileName     = 'APFPDENT.DLL';
  Monitor40FileName  = 'APFMON40.DLL';
  Monitor40Name      = 'APFMON40';
  Monitor35FileName  = 'APFMON35.DLL';
  Monitor35Name      = 'APFMON35';
  FilterName         = 'APFAXCNV.DLL';
  Environment        = 'Windows NT x86';
  PortName           = 'PRINTFAX:';
  DriverName         = 'TPS APW Fax Printer';
  ProcessorName      = 'WinPrint';
  PrinterName        = 'Print to Fax'; {NF: 31/10/2001}

function InstallDriver32(SourcePath : string) : boolean;
  { Attempt to install the print driver.}

implementation

uses
  Windows,
  WinSpool,
  SysUtils,
  Messages,
  OoMisc,
  PDrvInst,
  PDrvUnNT,
  APIUtil, {NF: 31/10/2001}
  Dialogs, {NF: 31/10/2001}
  AdExcept;

type
  PPrinterStrings = ^TPrinterStrings;
  TPrinterStrings =
    record
      pPortName       : ShortString;
      pComment        : ShortString;
      pSepFile        : ShortString;
      pServerName     : ShortString;
      pPrintProcessor : ShortString;
      pDataType       : ShortString;
      pDriverFileBase : ShortString;
      SourceDirectory : ShortString;
    end;
var
  PrinterStrings      : PPrinterStrings;


{-------------------------------------------------}
{ Copy the printer driver to the system directory }
{-------------------------------------------------}

procedure CopyDriver(lpszSrcFilename,lpszDestDir : pChar);
  { Copy the fax printer driver to the windows system directory }
var
  lpszDestFilename: PChar;
  lpszSrcDir      : PChar;
  lpszCurDir      : PChar;
  lpszTempFile    : PChar;
  TempFileLen     : DWORD;

begin
  with PrinterStrings^ do begin
    lpszSrcDir := StrAlloc(Max_Path);
    lpszTempFile := StrAlloc(Max_Path);
    try
      lpszDestFilename := lpszSrcFilename;
      StrPCopy(lpszSrcDir, SourceDirectory);
      lpszCurDir := nil;
      TempFileLen := Max_Path;

      DrvInstallExtError := VerInstallFile(0, lpszSrcFilename,
                                           lpszDestFilename,
                                           lpszSrcDir, lpszDestDir,
                                           lpszCurDir,
                                           lpszTempFile, TempFileLen);


      if DrvInstallExtError <> 0 then
        if (DrvInstallExtError AND (VIF_FILEINUSE or VIF_SRCOLD)) = 0 then
          if (DrvInstallExtError and VIF_CANNOTREADSRC) <> 0 then
            begin
              ErrorFile := lpszSrcFilename; {NF:}
              raise NotFoundException.Create(StrPas(lpszSrcFilename) + ' not found');
            end
          else
            raise CantCopyException.Create('');

    finally
      StrDispose(lpszTempFile);
      StrDispose(lpszSrcDir);
    end;
  end;
end;

procedure RegisterPrinter;
  { Register the new printer driver to Windows }
var
  KeyBuf      : PChar;
  ValBuf      : PChar;
  PrntInfo    : PPrinterInfo2;
  DrvrInfo    : PDriverInfo2;
  MonitorInfo : PMonitorInfo2;
  DriverDir   : PChar;
  iLastError, SizeNeeded  : DWord; {NF: 31/10/2001}
  TempStr     : ShortString;
  StrBuf1     : array[0..255] of Char;
  Osi         : TOSVersionInfo;
  H           : THandle;
  bMonitorAddOK, MonitorFound: Boolean; {NF: 31/10/2001}
begin
  with PrinterStrings^ do begin
    pPortName       := PortName;
    pComment        := '';
    pSepFile        := '';
    pServerName     := '';
    pPrintProcessor := ProcessorName;
    pDataType       := 'RAW';

    if DrvInstallError <> ecOk then
      exit;

    KeyBuf := StrAlloc(256);
    ValBuf := StrAlloc(256);

    try

      DriverDir := StrAlloc(255);
      try
        GetPrinterDriverDirectory(nil, nil, 1, DriverDir, 255, SizeNeeded);
        TempStr := AddBackSlash(StrPas(DriverDir));

        DrvInstallError := ecOK;
        CopyDriver(DriverFileName,DriverDir);

      finally
        StrDispose(DriverDir);
      end;


      GetMem(DrvrInfo, sizeof(TDriverInfo2));
      try
        FillChar(DrvrInfo^, sizeof(TDriverInfo2), 0);

        DrvrInfo^.pName       := StrAlloc(255);
        DrvrInfo^.pDriverPath := StrAlloc(255);
        DrvrInfo^.pDataFile   := StrAlloc(255);
        DrvrInfo^.pConfigFile := StrAlloc(255);
        DrvrInfo^.pEnvironment := StrAlloc(255);                       
        try
          DrvrInfo^.cVersion := $1;
          StrPCopy(DrvrInfo^.pName, DriverName);
          StrPCopy(DrvrInfo^.pDatafile, TempStr + DriverFileName);
          DrvrInfo^.pEnvironment := Environment;
          StrPCopy(DrvrInfo^.pDriverPath, TempStr + 'RASDD.DLL');
          StrPCopy(DrvrInfo^.pConfigFile, TempStr + 'RASDDUI.DLL');

          if not AddPrinterDriver(nil, 2, DrvrInfo) then begin {NF: 31/10/2001}
            iLastError := GetLastError;                                 {|}
            case iLastError of                                          {|}
              0 : {no error};                                           {|}
              5 : begin                                                 {|}
                DrvInstallError := ecCannotAddPrinter;                  {|}
                MsgBox('You have insufficient rights to add printer drivers to this workstation.'{|}
                + CHR(13) + 'Please contact your administrator to resolve this issue.'{|}
                ,mtError,[mbOK],mbOK,'Insufficient Rights');            {|}
              end;                                                      {|}

              1795 : {ERROR_PRINTER_DRIVER_ALREADY_INS} ;               {|}

              else begin                                                {|}
                DrvInstallError := ecCannotAddPrinter;                  {|}
                MsgBox('Failed to add printer driver. Error Code : ' + IntToStr(iLastError){|}
                ,mtError,[mbOK],mbOK,'Driver Install Error');           {|}
              end;                                                      {|}
            end;{case}                                                  {|}
          end;{if}                                                      {|}
        finally                                                         {|}
          StrDispose(DrvrInfo^.pName);                                  {|}
          StrDispose(DrvrInfo^.pDriverPath);                            {|}
          StrDispose(DrvrInfo^.pDataFile);                              {|}
          StrDispose(DrvrInfo^.pConfigFile);                            {|}
//          StrDispose(DrvrInfo^.pEnvironment);                           {|}
        end;                                                            {|}
      finally                                                           {|}
        FreeMem(DrvrInfo, sizeof(TDriverInfo2));                        {|}
      end;                                                              {|}
      {Add Monitor (This is the 'Port' I think)}                        {|}
      GetMem(MonitorInfo, sizeof(TMonitorInfo2));                       {|}
      try                                                               {|}
        FillChar(MonitorInfo^, sizeof(TMonitorInfo2), 0);               {|}

        MonitorInfo^.pName     := StrAlloc(255);                        {|}
        MonitorInfo^.pDLLName     := StrAlloc(255);                     {|}
        MonitorInfo^.pEnvironment := StrAlloc(255); {NF: 31/10/2001}    {|}
        try                                                             {|}
          GetSystemDirectory(StrBuf1, 256);                             {|}

          Osi.dwOSVersionInfoSize := sizeof(Osi);                       {|}
          GetVersionEx(Osi);                                            {|}

          MonitorFound := FileExists(StrPas(StrBuf1)+'\'+FilterName);   {|}

          if MonitorFound then begin                                    {|}
            if (Osi.dwMajorVersion = 3) and (Osi.dwMinorVersion <= 51) then{|}
              begin                                                     {|}
                MonitorFound := FileExists(StrPas(StrBuf1)+'\'+Monitor35FileName);{|}
                StrPCopy(MonitorInfo^.pName, Monitor35Name);            {|}
                StrPCopy(MonitorInfo^.pDLLName, Monitor35FileName);     {|}
              end                                                       {|}
            else begin                                                  {|}
              MonitorFound := FileExists(StrPas(StrBuf1)+'\'+Monitor40FileName);{|}
              StrPCopy(MonitorInfo^.pName, Monitor40Name);              {|}
              StrPCopy(MonitorInfo^.pDLLName, Monitor40FileName);       {|}
            end;{if}                                                    {|}
{            MonitorInfo^.pEnvironment := nil;}                         {|}
            StrPCopy(MonitorInfo^.pEnvironment, Environment);           {|}
          end;{if}                                                      {|}

          if not MonitorFound then begin                                {|}
            if (Osi.dwMajorVersion = 3) and (Osi.dwMinorVersion <= 51) then{|}
              begin                                                     {|}
                DrvInstallError := ecOK;                                {|}
                CopyDriver(Monitor35FileName,StrBuf1);                  {|}
                StrPCopy(MonitorInfo^.pName, Monitor35Name);            {|}
                StrPCopy(MonitorInfo^.pDLLName, Monitor35FileName);     {|}
              end                                                       {|}
            else begin                                                  {|}
              CopyDriver(Monitor40FileName,StrBuf1);                    {|}
              StrPCopy(MonitorInfo^.pName, Monitor40Name);              {|}
              StrPCopy(MonitorInfo^.pDLLName, Monitor40FileName);       {|}
            end;{if}                                                    {|}
            CopyDriver(FilterName,StrBuf1);                             {|}
            StrPCopy(MonitorInfo^.pEnvironment, Environment);           {|}
          end;{if}                                                      {|}

          if AddMonitor(nil,2,MonitorInfo) then bMonitorAddOK := TRUE   {|}
          else begin                                                    {|}
            iLastError := GetLastError;                                 {|}
{            bMonitorAddOK := iLastError > 2500;}                       {|}
            bMonitorAddOK := iLastError = 3006; {already installed}     {|}
          end;{if}                                                      {|}

        finally                                                         {|}
          StrDispose(MonitorInfo^.pName);                               {|}
          StrDispose(MonitorInfo^.pDLLName);                            {|}
          StrDispose(MonitorInfo^.pEnvironment);                        {|}
        end;                                                            {|}
      finally                                                           {|}
        FreeMem(MonitorInfo, sizeof(TMonitorInfo2));                    {|}
      end;                                                              {|}

      if bMonitorAddOK then                                             {|}
        begin                                                           {|}
          {Add Printer}                                                 {|}
          GetMem(PrntInfo, sizeof(TPrinterInfo2));                      {|}
          try                                                           {|}
            FillChar(PrntInfo^, sizeof(TPrinterInfo2), 0);              {|}

            PrntInfo^.pServerName     := StrAlloc(255);                 {|}
            PrntInfo^.pPrinterName    := StrAlloc(255);                 {|}
            PrntInfo^.pPortName       := StrAlloc(255);                 {|}
            PrntInfo^.pDriverName     := StrAlloc(255);                 {|}
            PrntInfo^.pComment        := StrAlloc(255);                 {|}
            PrntInfo^.pPrintProcessor := StrAlloc(255);                 {|}
            PrntInfo^.pDataType       := StrAlloc(255);                 {|}
            try                                                         {|}
              StrPCopy(PrntInfo^.pServerName, pServerName);             {|}
              PrntInfo^.pServerName := nil;                             {|}
              StrPCopy(PrntInfo^.pPrinterName, PrinterName);            {|}
              StrPCopy(PrntInfo^.pPortName, pPortName);                 {|}
              StrPCopy(PrntInfo^.pDriverName, DriverName);              {|}
              StrPCopy(PrntInfo^.pComment, pComment);                   {|}
              StrPCopy(PrntInfo^.pPrintProcessor, pPrintProcessor);     {|}
              StrPCopy(PrntInfo^.pDataType, pDataType);                 {|}

              H := AddPrinter(nil, 2, PrntInfo);                        {|}
              if H = 0 then                                             {|}
                begin                                                   {|}
                  iLastError := GetLastError;                           {|}
                  case iLastError of                                    {|}
                    0 : {No Error};                                     {|}

                    5 : begin                                           {|}
                      DrvInstallError := ecCannotAddPrinter;            {|}
                      MsgBox('You have insufficient rights to add a printer to this workstation.'{|}
                      + CHR(13) + 'Please contact your administrator to resolve this issue.'{|}
                      ,mtError,[mbOK],mbOK,'Insufficient Rights');      {|}
                    end;

                    1801 : begin                                        {|}
                      DrvInstallError := ecCannotAddPrinter;            {|}
                      MsgBox('The Exchequer Fax Client has been unable to find the port PRINTFAX: .' + #13{|}
                      + 'This error can be fixed by deleting the driver ''TPS APW Fax Printer''' + #13 + #13{|}
                      + ', rebooting, and re-running the fax client.'   {|}
                      ,mtError,[mbOK],mbOK,'PRINTFAX: port not found'); {|}
                    end;                                                {|}

                    ERROR_PRINTER_ALREADY_EXISTS : ;{do nothing}        {|}

                    else begin                                          {|}
                      DrvInstallError := ecCannotAddPrinter;            {|}
                      MsgBox('Failed to add printer. Error Code : ' + IntToStr(iLastError) {|}
                      ,mtError,[mbOK],mbOK,'Driver Install Error');     {|}
                    end;                                                {|}
                  end;{if}                                              {|}
                end                                                     {|}
              else ClosePrinter(H);                                     {|}

            finally                                                     {|}
              StrDispose(PrntInfo^.pServerName);                        {|}
              StrDispose(PrntInfo^.pPrinterName);                       {|}
              StrDispose(PrntInfo^.pPortName);                          {|}
              StrDispose(PrntInfo^.pDriverName);                        {|}
              StrDispose(PrntInfo^.pComment);                           {|}
              StrDispose(PrntInfo^.pPrintProcessor);                    {|}
              StrDispose(PrntInfo^.pDataType);                          {|}
            end;                                                        {|}
          finally                                                       {|}
            FreeMem(PrntInfo, sizeof(TPrinterInfo2));                   {|}
          end;                                                          {|}
        end                                                             {|}
      else DrvInstallError := -8093 {monitor could not be added}; {NF: 31/10/2001}

    finally
      StrDispose(KeyBuf);
      StrDispose(ValBuf);
    end;
  end;
end;

{----------------------------------------------------}
{ Check if the printer driver installed successfully }
{----------------------------------------------------}

function InstalledOk : Boolean;
  { Try to create an IC for the print driver to see if it installed ok }
var
  PrinterIC    : HDC;
  zDriverFile  : PChar;
  zPortName    : PChar;
  Instance     : THandle;
  DriverDir    : PChar;
  SizeNeeded   : DWord;
  TempStr      : ShortString;
begin
  InstalledOk := False;

  with PrinterStrings^ do begin

    DriverDir := StrAlloc(255);
    try
      GetPrinterDriverDirectory(nil, nil, 1, DriverDir, 255, SizeNeeded);
      TempStr := AddBackSlash(StrPas(DriverDir));

      zDriverFile := StrAlloc(255);
      zPortName := StrAlloc(255);
      try

        StrPCopy(zDriverFile,TempStr+StrPas(DriverFileName));
        Instance := LoadLibrary(zDriverFile);
        if Instance = 0 then
          raise Exception.CreateFmt('Unable to load driver DLL. Reason:%d',[GetLastError]);
        try
          StrPCopy(zDriverFile, pDriverFileBase);
          StrPCopy(zPortName, pPortName);

          PrinterIC := CreateIC('WINSPOOL', PrinterName, zPortName, nil);

          InstalledOk := (PrinterIC <> 0);
          if PrinterIC <> 0 then begin
            DeleteDC(PrinterIC);
            DrvInstallError := ecOK;
          end;
        finally
          FreeLibrary(Instance);
        end;
      finally
        StrDispose(zPortName);
        StrDispose(zDriverFile);
      end;

    finally
      StrDispose(DriverDir);
    end;


  end;
end;

{---------------------------------------}
{ Main printer driver installation code }
{---------------------------------------}

function InstallDriver32(SourcePath : string) : boolean;
  { Attempt to install the print driver.  Return True if successful. }
var
  SizeNeeded : DWORD; {NF: 31/10/2001}
  SysDir : array[0..255] of Char; {NF: 31/10/2001}
  Filename : ShortString;
begin
  Result := False;

  with PrinterStrings^ do begin

    DrvInstallError := ecOk;

    Filename := StrPas(DriverFileName);
    Filename := ExpandFilename(Filename);
    pDriverFileBase := JustName(Filename);
    SourceDirectory := SourcePath;

    try
      DrvInstallError := InstallNTUniDrvFiles;
      if (DrvInstallError = ecOk) or
         (DrvInstallError = ecUniAlreadyInstalled) then begin
        DrvInstallError := ecOk;
        RegisterPrinter;
      end;
    except
      on NotFoundException do
        DrvInstallError := ecDrvDriverNotFound;
      on CantCopyException do
        DrvInstallError := ecDrvCopyError;
    end;

    if (DrvInstallError = ecOk) then
      Result := InstalledOk;
  end;

end;

function WinNTFaxDriverInstalledOK : boolean; {NF: 31/10/2001}
begin {NF: 31/10/2001}
  Result := InstalledOK; {NF: 31/10/2001}
end; {NF: 31/10/2001}

initialization
  GetMem(PrinterStrings, sizeof(TPrinterStrings));
  FillChar(PrinterStrings^, sizeof(TPrinterStrings), 0);

finalization
  FreeMem(PrinterStrings);
end.

