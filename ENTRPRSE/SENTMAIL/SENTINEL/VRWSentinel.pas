unit VRWSentinel;
{$ALIGN 1}  { Variable Alignment Disabled }
interface

uses
  ExBtTh1U, RptEngDll, VRWReportIF, Classes, Dialogs,  ElVar, Enterprise04_TLB, WorkSta2, Windows, SentU;

type
  TSentinelVisualReporter = Class(TSentinel)
  private
    RepName : ShortString;
    function OutputType(const ElRec : TElertRec) : TReportFileFormat;
    function Start : Boolean; virtual;
    function Process : Boolean;
    procedure Finish(ProcessedOK : Boolean);
    procedure Progress(Count, Total : integer; Var Abort : Boolean);
    procedure StartSecondPass(Count, Total : integer; Var Abort : Boolean);
{    function Lock : SmallInt;
    function Unlock : SmallInt;}

    //PR: 22/08/2012 Added function to copy VRW pdf file from Windows Temp dir to Exchequer swap dir. ABSEXCH-12574
    function CopyFileToSwapDir(sFileName : AnsiString) : Boolean;
  public
    oReport : IVRWReport3;
    OutputFile : ShortString;
    CSVFName : AnsiString;
    FLockPosition : longint;
    FLockCount : Integer;
    ParamList : TList;
    OldRangeStart,
    OldRangeEnd : TElertRangeRec;
    FToolkit : IToolkit;
    FProcessDescription : string;
    OutputFormat : TReportFileFormat;  //PR: 15/02/2011


    constructor Create(ClientID : SmallInt); //PR: 21/09/2009 Memory Leak Change
    procedure Run(TestMode : Boolean = False; RepQuery : Boolean = False); override;

    property ReportName : ShortString read RepName write RepName;
  end;

implementation

uses
  SysUtils, ElObjs, ExWrap1U, Btrvu2, BtSupU1, GlobVar, RepFNO1U, NewParam, DebugLog,
  ComObj, ActiveX, CtkUtil04, LocalU, GlobalTypes, ApiUtil;


function ParamVal(const s : shortString; Atype : Byte; OffSet : SmallInt) : ShortString;
var
  R : TElertRangeRec;
begin
//Need to put parameter into TElertRangeRec record to use getrangevalue func
  FillChar(R, SizeOf(R), #0);
  Case AType of
    1  : R.egType := evDate;
    2  : R.egType := evPeriod;
    5  : R.egType := evCurrency;
    else
      R.egType := evString;
  end;//case
  R.egString := s;
  R.egOffset := OffSet;
  Result := GetRangeValue(R);
end;


procedure TSentinelVisualReporter.Finish(ProcessedOK : Boolean);
var
  ELObj : TElertObject;
  i, Res : integer;
  tmpName : string;
begin
 with FExLocal^, LElertRec do
 begin
   ElObj := TElertObject.CreateNoFile;
   Try
     inc(elTriggered);
     if not ProcessedOK then
     begin //Try running it again
       elStatus := Ord(esIdle);
       elRunNow := True;
     end
     else
     if elActions.eaCSV then
     begin
       elStatus := 0;
       if elCSVToFolder then elStatus := elStatus or 1;
       if elCSVByFTP then elStatus := elStatus or 2;
       if elCSVByEmail then elStatus := elStatus or 4;
       elStatus := Ord(Pred(esCopyReadyToGo)) + elStatus;
     end
     else
     if elActions.eaRepEmail and elActions.eaRepFax then
       elStatus := Ord(esReportBothReadyToGo)
     else
     if elActions.eaRepEmail then
       elStatus := Ord(esReportEmailReadyToGo)
     else
     if elActions.eaRepFax then
       elStatus := Ord(esFaxReadyToGo)
     else
       elStatus := Ord(esIdle); //shouldn't happen

     elLastDateRun := Now;
     ElObj.SetDataPointer(@LElertRec);
     elNextRunDue := ElObj.GetNextRunDue(True);
   Finally
     if ProcessedOK then
       LogIt(spConveyor, 'Sentinel complete. Status = ' + IntToStr(elStatus));
     elWorkStation := BlankWorkstation;
     ResetQueryTick(LElertRec);
     if ProcessedOK then //PR: 13/05/2011 Don't reference oReport unless ProcessedOK - could cause AccessViolation
     begin
       //PR: 22/08/2012 ABSEXCH-12574 If the format is pdf, then we need to take the file name from the report object.
       if elActions.eaCSV and (OutputFormat <> INTERNAL_PDF_FILE) then
         elRepFile := elCSVFilename
       else
       begin
         elRepFile := ExtractFileName(oReport.vrReportFilename);

         //PR: 22/08/2012 ABSEXCH-12574 If pdf then the temp file will be .edf rather than .tmp
         if OutputFormat = INTERNAL_PDF_FILE then
         begin
           tmpName := ChangeFileExt(oReport.vrReportFilename, '.edf');

           //Copy the file from the windows temp folder to the Swap folder so the CSV Conveyor can pick it up.
           if not CopyFileToSwapDir(oReport.vrReportFilename) then
             LogIt(spVisualReport, 'Unable to move pdf file to swap folder');
         end
         else
           tmpName := ChangeFileExt(oReport.vrReportFilename, '.tmp');

         //PR: 15/02/2011 If adobe then the output file won't be in the SWAP folder, so
         //we need to store the correct folder in the record
         if OutputFormat =ADOBE_PDF_FILE then
         begin
           elRepFolder := ExtractFilePath(oReport.vrReportFilename);
           elExRepFormat := 255;
         end;
         LogIt(spConveyor, 'Report Filename: ' + oReport.vrReportFilename);
       end;
     end; //If ProcessedOK

     Res := Save;
     if Res <> 0 then
       LogIt(spConveyor, 'LPut_Rec returned ' + IntToStr(Res));
     ElObj.Free;
      oReport := nil;
     if FileExists(tmpName) then
       DeleteFile(tmpName);
     if ProcessedOK and (Res = 0) then
     begin
        LogIt(spQuery, S_FINISHED);
        FRanOK := True;
     end
     else
     begin
       if ProcessedOK then
         LogIt(spQuery, 'Unable to save record: ' + IntToStr(Res));
     end;
   End;
  end;

  FToolkit := nil;
  CoUninitialize;
end;

function TSentinelVisualReporter.Process : Boolean;
var
  ID : AnsiString;
  rwOptions : TOptionArray;
begin
  Result := False;
  if Start then
  begin
    if DebugModeOn then
    begin
      ID := 'Sentinel VRW Report Create. ThreadID: ' + IntToStr(GetCurrentThreadID);
      OutputDebugString(PChar(ID));
    end;

    Try
      //PR: 15/02/2011 Tell the vrw engine not to display any messages
      rwOptions := oReport.vrPrintMethodParams.pmMiscOptions;
      rwOptions[Integer(GEN_NO_MESSAGES)] := True;
      oReport.vrPrintMethodParams.pmMiscOptions := rwOptions;

      //PR: 18/09/2013 ABSEXCH-14630 Pass user id into report engine
      oReport.CheckSecurity(FUser);
      oReport.Print('', True);
      Result := True;
      LogIt(spReport, 'Report Printed');
    Except
      on E:Exception do
      begin
        LogIt(spConveyor, 'Exception in VRWReport.Print: ' + E.Message);
        raise;
      end;
    End;
  end;
end;

function TSentinelVisualReporter.Start : Boolean;
const
  TotalReadTries = 4;
var
  KeyS : Str255;
  Status, Res : SmallInt;
  Params : TReportParamRec;
  i : integer;
  o1, o2 : SmallInt;
  Control: IVRWControl;
  //PR: 03/06/2010 Change to IVRWBaseInputField to allow InputFields as well as Range Filters
  ThisFilter : IVRWBaseInputField;
  IndexFilter : Boolean;

  iReadTries : Integer;

  function FindRangeFilter(const s : string) : Boolean;
  var
    j : integer;
  begin
    Result := False;
    for j := 0 to oReport.vrControls.clCount - 1 do
    begin
      Control := oReport.vrControls.clItems[j];
     { Only field controls can have a range filter }
     if Supports(Control, IVRWFieldControl) then
     with Control as IVRWFieldControl do
       if Trim(vcRangeFilter.rfName) = Trim(s) then
       begin
         Result := True;
         Break;
       end;
     end;
  end;

  //PR: 03/06/2010 Added function to find input field for parameter
  function FindInputField(const s : string) : Boolean;
  var
    j : integer;
  begin
    Result := False;
    with oReport.vrInputFields do
      for j := 0 to rfCount - 1 do
        if Trim(rfItems[j].rfName) = Trim(s) then
        begin
          Result := True;
          ThisFilter := rfItems[j];
          Break;
        end;
  end;

  function ChangeDateFormat(const ADate : string) : string;
  begin
    Result := Copy(ADate, 7, 2) + Copy(ADate, 5, 2) + Copy(ADate, 1, 4);
  end;

  function ChangePeriodFormat(APeriod : string) : string;
  var
    pp, yy : string;
  begin
    if APeriod[1] = '1' then //2000 or later
    begin
      yy := '20' + Copy(APeriod, 2, 2);
      Delete(APeriod, 1, 3);
    end
    else
    begin
      yy := '19' + Copy(APeriod, 1, 2);
      Delete(APeriod, 1, 2);
    end;

    if Length(APeriod) = 1 then
      APeriod := '0' + APeriod;

    Result := APeriod + yy;
  end;


begin
  iReadTries := 0;
  Randomize;
  Result := False;
  FProcessDescription := 'Preparing';
  CoInitialize(nil);
  FToolkit := CreateToolkitWithBackDoor;
  FToolkit.Configuration.DataDirectory := DataPath;
  FToolkit.OpenToolkit;
  with FToolkit do
    CurrPeriod := IntToStr(SystemSetup.ssCurrentYear + 1900) + IntToStr(SystemSetup.ssCurrentPeriod);

  IndexFilter := True;
  oReport := GetVRWReport as IVRWReport3;
  if not Assigned(oReport) then
  begin
    LogIt(spReport, 'oReport = nil');
    Result := False;
    Exit;
  end;
  oReport.vrOnPrintRecord := Progress;
  oReport.vrOnSecondPass := StartSecondPass;
  oReport.vrDataPath := DataPath;

  //PR: 06/04/2011 We have had a couple of failures where the report engine couldn't read a report file.
  //As the file certainly existed, this could be some clash with another process
  //There is no locking involved, so try a few times at random intervals before giving up.
  while iReadTries < TotalReadTries do
  Try
    oReport.Read(DataPath + 'Reports\' + RepName + '.erf');
    Result := True;
    iReadTries := TotalReadTries;
  Except
    on E:Exception do
    begin
      inc(iReadTries);
      if iReadTries >= TotalReadTries then
      begin
        Result := False;
        LogIt(spReport, 'Exception reading report: ' + E.Message);
      end;
      Wait(1000 + Random(2000));
    end;
  End;

  if Result then
  begin
    with FExLocal^ do
    begin
    //need to set RDevRec.feEmailAttType here and save it in Sentinel
      LSetDrive := DataPath;
      Open_System(ElertF, LineF);
      KeyS := LJVar(FUser, 10) + LJVar(FElertName, 30);
      Res := LFind_Rec(B_GetEq, ElertF, 0, KeyS);

      if Res = 0 then
        Res := Lock;

      if Res = 0 then
      begin
{        oReport.SetReportTypeLocation(OutputType(LElertRec), '');
        oReport.SilentRunning := True;}
        OutputFormat := OutputType(LElertRec);
        if (OutputFormat in [EDF_FILE..EDZ_FILE]) then
        begin
          oReport.vrPrintMethodParams.pmPrintMethod := Ord(OutputFormat);
        end
        else
        begin
          oReport.vrPrintMethodParams.pmPrintMethod := Ord(OutputFormat);
          oReport.vrPrintMethodParams.pmXMLFileDir := DataPath + 'swap\' + LElertRec.elCSVFileName;
          //PR: 24/10/2016 v2017 R1 ABSEXCH-17766 If Excel format and we haven't already changed to xlsx, or
          //                                      filename is already 12 chars, then add x to end
          if (LElertRec.elExRepFormat = 3) and (Pos('.xlsx', LElertRec.elCSVFileName) = 0) then
            oReport.vrPrintMethodParams.pmXMLFileDir := oReport.vrPrintMethodParams.pmXMLFileDir + 'x';
        end;

        KeyS := pxElOutput + LJVar(FUser, 10) + LJVar(FElertName, 30) + #0#0 + otParams;

        Status := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

        while (Status = 0) and
        (LElertLineRec.Prefix = pxElOutput) and
        (Trim(LElertLineRec.Output.eoElertName) = Trim(ElertName)) and
        (Trim(LElertLineRec.Output.eoUserID) = Trim(FUser)) and
        (LElertLineRec.Output.eoOutputType = otParams) do
        begin
  {Replace parameter with ones from sentinel.  If param is 'Today' or 'Current Period' then
  we increment the parameter by offset before running the report, else we increment it
  after running the report}
          if IndexFilter and RangeFilterSet(oReport.vrRangeFilter) then
            ThisFilter := oReport.vrRangeFilter
          else  //PR: 03/06/2010 Call new function to find input field for parameter
          if FindInputField(LElertLineRec.Output.eoRfName) then
          begin
            //No need to do anything - ThisFilter is assigned in FindInputField
          end
          else
          if FindRangeFilter(LElertLineRec.Output.eoRfName) then
            ThisFilter := (Control as IVRWFieldControl).vcRangeFilter
          else
            ThisFilter := nil;

          IndexFilter := False;
          Params.ParamType := LElertLineRec.Output.eoEntParamType;
          if not IsToday(LElertLineRec.Output.eoLine1, LElertLineRec.Output.eoEntParamType) then
            o1 := 0
          else
            o1 := LElertLineRec.Output.eoOffStart;

          if not IsToday(LElertLineRec.Output.eoLine2, LElertLineRec.Output.eoEntParamType) then
            o2 := 0
          else
            o2 := LElertLineRec.Output.eoOffEnd;

          Params.Params[1] := ParamVal(LElertLineRec.Output.eoLine1,
                               LElertLineRec.Output.eoEntParamType,
                               o1);
          Params.Params[2] := ParamVal(LElertLineRec.Output.eoLine2,
                                LElertLineRec.Output.eoEntParamType,
                               o2);

          if Params.ParamType = 1 then
          begin
            //Chris's object is expecting Date in ddmmyyyy format which it then converts to yyyymmdd
            Params.Params[1] := ChangeDateFormat(Params.Params[1]);
            Params.Params[2] := ChangeDateFormat(Params.Params[2]);
          end
          else
          if Params.ParamType = 2 then
          begin
            //Chris's object is expecting Period in ppyyyy format rather than yyypp format
            Params.Params[1] := ChangePeriodFormat(Params.Params[1]);
            Params.Params[2] := ChangePeriodFormat(Params.Params[2]);
          end;

          OldRangeStart := LElertRec.elRangeStart;
          OldRangeEnd := LElertRec.elRangeEnd;


          if LElertLineRec.Output.eoEntParamType in [1, 2] then
          begin
            if not IsToday(LElertLineRec.Output.eoLine1, LElertLineRec.Output.eoEntParamType) then
              LElertLineRec.Output.eoLine1 :=
                                ParamVal(LElertLineRec.Output.eoLine1,
                                LElertLineRec.Output.eoEntParamType,
                                LElertLineRec.Output.eoOffStart);
            if not IsToday(LElertLineRec.Output.eoLine2, LElertLineRec.Output.eoEntParamType) then
              LElertLineRec.Output.eoLine2 := ParamVal(LElertLineRec.Output.eoLine2,
                                LElertLineRec.Output.eoEntParamType,
                                LElertLineRec.Output.eoOffEnd);

            //PR: 06/03/2012 ABSEXCH-11836 Period parameters come back from ParamVal in old report writer format
            // - yyyy(p)p  - change to pp/yyyy
            //PR: 26/06/2012 ABASEXCH-13038 If the period is 'Current Period' then we don't want to change it
            //(IsToday function checks for 'current period' string)
            if (LElertLineRec.Output.eoEntParamType = 2) and
               not IsToday(LElertLineRec.Output.eoLine2, LElertLineRec.Output.eoEntParamType) then
            begin
              //Use ChangePeriodFormat to convert to ppyyyy
              LElertLineRec.Output.eoLine1 := ChangePeriodFormat(LElertLineRec.Output.eoLine1);
              LElertLineRec.Output.eoLine2 := ChangePeriodFormat(LElertLineRec.Output.eoLine2);

              //Insert '/'
              Insert('/', LElertLineRec.Output.eoLine1, 3);
              Insert('/', LElertLineRec.Output.eoLine2, 3);

            end;
            LPut_Rec(LineF, ellIdxOutputType);
          end;

          if Assigned(ThisFilter) then
          begin
            ThisFilter.rfType := Params.ParamType;
            ThisFilter.rfFromValue := Params.Params[1];
            ThisFilter.rfToValue := Params.Params[2];
          end;
          Status := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);
       end; //while
     end
     else
       Result := False; //If lock
    end; // with MTExLocal^
  end; //If Result

end;

procedure TSentinelVisualReporter.Progress(Count, Total : integer; Var Abort : Boolean);
var
  PercentComplete : Integer;
  dCount, dTotal : Double;
  iMod : Integer;
begin
  //Only log at intervals, to keep the log file small, making it less intensive for the engine to load
  //in order to show progress
  if Total > 2000 then
    iMod := Total div 100
  else
    iMod := 20;

  if (Count mod iMod) = 0 then
  begin
    dCount := Count;
    dTotal := Total;
    if Total <> 0 then
      PercentComplete := Trunc((dCount / dTotal) * 100)
    else //???
      PercentComplete := (Count mod 100) + 1;

      SendProgress(PercentComplete,  FProcessDescription + ' report ' + QuotedStr(RepName), '',
                     Format(FProcessDescription + ' record %d of %d', [Count, Total]));
  end;
end;
(*
function TSentinelVisualReporter.Lock : SmallInt;
Var
//  SaveInfo : TElertFileSavePos;
  lRes     : LongInt;
begin
  With FExLocal^ Do Begin

    // Save Record Position into LockPos so we can later use it for unlocking
    Result := LGetPos (ElertF, FLockPosition);
    If (Result = 0) Then Begin
      // Copy locked record position into data record
     SetDataRecOfsPtr (ElertF, FLockPosition, LRecPtr[ElertF]^);
      // Reread and lock record
      Result := LGetDirect(ElertF, 0, B_SingLock + B_SingNWLock);
      If (Result = 0) Then
        // Record Locked
        Inc (FLockCount);
    End { If (Result = 0) };

  End; { With FBtrIntf^ }
end;

function TSentinelVisualReporter.UnLock : SmallInt;
var
  KeyS : Str255;
begin
  If (FLockCount > 0) Then Begin
    // Copy locked record position into data record
    SetDataRecOfsPtr(ElertF, FLockPosition, FExLocal^.LRecPtr[ElertF]^);

    // Unlock Record
    FillChar (KeyS, Sizeof(KeyS), #0);
    Result := FExLocal^.LFind_Rec(B_Unlock, ElertF, 0, KeyS);
    If (Result <> 0) Then Inc (Result, 30000);

    Dec(FLockCount);
  End; { If (FLockCount > 0) }
end;
*)
function TSentinelVisualReporter.OutputType(const ElRec : TElertRec) : TReportFileFormat;

  function GetEntFormat : TReportFileFormat;
  var
    Res : Integer;
    AttMethod : Byte;
//    FToolkit : IToolkit;
  begin
    Result := EDF_FILE;
    if Assigned(FToolkit) then
    Try
      Case FToolkit.SystemSetup.ssPaperless.ssAttachMethod of
        eamInternal :  Result := EDF_FILE;
        eamAcrobat  :  Result := ADOBE_PDF_FILE;
        eamInternalPDF : Result := INTERNAL_PDF_FILE;
      end;
    Finally
    End;
  end;
begin
  if ElRec.elActions.eaCSV then
  begin
    if ElRec.elDBF then
      Result := DBF_FILE
    else
    if ElRec.elExRepFormat = 3 then
      Result := XLS_FILE
    else
    if ElRec.elExRepFormat = 2 then
      Result := HTML_FILE
    else
    //PR: 21/08/2012 ABSEXCH-12574 Add Adobe PDF
    if ElRec.elExRepFormat = 4 then
      Result := INTERNAL_PDF_FILE
    else
      Result := CSV_FILE;
  end
  else
  begin
    with TElertWorkstationSetup.Create do
    Try
      Case OutputFormat of
        0 : Result := GetEntFormat;
        1 : Result := EDF_FILE;
        2 : Result := INTERNAL_PDF_FILE;
        else
          Result := EDF_FILE;
      end; //Case

    Finally
      Free;
    End;
    if (Result = EDF_FILE) and ElRec.elCompressReport then
      Result := EDZ_FILE;
  end;
end;


procedure TSentinelVisualReporter.StartSecondPass(Count, Total: integer;
  var Abort: Boolean);
begin
  FProcessDescription := 'Printing';
end;



constructor TSentinelVisualReporter.Create(ClientID: SmallInt);
var
  ID : AnsiString;
begin
  inherited Create;
  FClientID := ClientID;  //PR: 21/09/2009 Memory Leak Change
  New(FExLocal, Create(FClientID));
  FPurpose := spConveyor;
  if DebugModeOn then
  begin
    DebugMessage('Creating sentinel');
    ID := 'Sentinel Conveyor Create. ThreadID: ' + IntToStr(GetCurrentThreadID) + '. ClientID: ' + IntToStr(Integer(@FExLocal.ExClientId));
    OutputDebugString(PChar(ID));
  end;
end;

procedure TSentinelVisualReporter.Run(TestMode, RepQuery: Boolean);
var
  ProcessedOK : Boolean;
begin
  ProcessedOK := False;
  Try
    ProcessedOK := Process;
  Finally
    Finish(ProcessedOK);
  End;
end;

//PR: 22/08/2012 Added function to copy VRW pdf file from Windows Temp dir to Exchequer swap dir. ABSEXCH-12574
function TSentinelVisualReporter.CopyFileToSwapDir(
  sFileName: AnsiString): Boolean;
var
  sTo : AnsiString;
begin
  sTo := FDataPath + 'SWAP\' + ExtractFileName(sFilename);
  Result := CopyFile(PChar(sFileName), PChar(sTo), False);
end;

end.
