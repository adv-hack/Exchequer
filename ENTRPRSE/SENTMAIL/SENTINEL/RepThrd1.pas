unit RepThrd1;
{$ALIGN 1}  { Variable Alignment Disabled }
interface

uses
  ExBtTh1U, RptEngDll, VRWReportIF, Classes, Dialogs,  ElVar, Enterprise04_TLB, WorkSta2, Windows;

type
  TGUIReportThread = Object(TThreadQueue)
    oReport : IVRWReport3;
    RepName, DataPath : ShortString;
    OutputFile : ShortString;
    ElertName,
    UserID : ShortString;
    CSVFName : AnsiString;
    FLockPosition : longint;
    FLockCount : Integer;
    ParamList : TList;
    MemStream : TMemoryStream;
    OldRangeStart,
    OldRangeEnd : TElertRangeRec;
    FToolkit : IToolkit;
    FProcessDescription : string;
    OutputFormat : TReportFileFormat;  //PR: 15/02/2011

    Destructor  Destroy; Virtual;
    function OutputType(const ElRec : TElertRec) : TReportFileFormat;
    function Start : Boolean; virtual;
    procedure Process; virtual;
    procedure Finish; virtual;
    procedure Progress(Count, Total : integer; Var Abort : Boolean);
    procedure StartSecondPass(Count, Total : integer; Var Abort : Boolean);
    function Lock : SmallInt;
    function Unlock : SmallInt;

  end;

implementation

uses
  SysUtils, ElObjs, ExWrap1U, Btrvu2, BtSupU1, GlobVar, RepFNO1U, NewParam, DebugLog,
  ComObj, ActiveX, CtkUtil04, LocalU, GlobalTypes;

{ TReportThread }
{type
  PInputLinePrms = ^TInputLinePrms;}

function ParamVal(const s : shortString; Atype : Byte; OffSet : SmallInt) : ShortString;
var
  R : TElertRangeRec;
begin
//Need to put parameter into TElertRangeRec record to use getrangevalue func
  FillChar(R, SizeOf(R), #0);
  Case AType of
    1  : R.egType := evDate;
    2  : R.egType := evPeriod;
    else
      R.egType := evString;
  end;//case
  R.egString := s;
  R.egOffset := OffSet;
  Result := GetRangeValue(R);
end;


procedure TGUIReportThread.Finish;
var
  ELObj : TElertObject;
  i : integer;
begin
// LogIt(spReport, 'Start RepCtrlObj.Finish ' + Trim(ElertName));
 with MTExLocal^, LElertRec do
 begin
   ElObj := TElertObject.CreateNoFile;
   Try
     if Not ThreadRec^.THAbort then
     begin
       inc(elTriggered);
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

(*       if elActions.eaCSV then
       begin
         elRepFile := ExtractFileName(CSVFName);
{         if elExRepFormat = 2 then
           ConvertEDFToHTML(RepFiler1.FileName, ExtractFilePath(RepFiler1.FileName) + elRepFile)
         else
         if elExRepFormat = 3 then
           ConvertEDFToXLS(RepFiler1.FileName, ExtractFilePath(RepFiler1.FileName) + elRepFile);
         if FileExists(RepFiler1.FileName) then
           DeleteFile(RepFiler1.FileName);}
       end
       else ;
        // elRepFile := ExtractFileName(RepFiler1.FileName); *)
     end
     else
       elStatus := Ord(esIdle);
     elLastDateRun := Now;
     ElObj.SetDataPointer(@LElertRec);
     elNextRunDue := ElObj.GetNextRunDue(True);
   Finally
     elWorkStation := BlankWorkstation;
     ResetQueryTick(LElertRec);
     if elActions.eaCSV then
       elRepFile := elCSVFilename
     else
     begin
       elRepFile := ExtractFileName(oReport.vrReportFilename);

       //PR: 15/02/2011 If adobe then the output file won't be in the SWAP folder, so
       //we need to store the correct folder in the record
       if OutputFormat =ADOBE_PDF_FILE then
       begin
         elRepFolder := ExtractFilePath(oReport.vrReportFilename);
         elExRepFormat := 255;
       end;
       LogIt(spConveyor, 'Report Filename: ' + oReport.vrReportFilename);
     end;
     LPut_Rec(ElertF, 0);
     ElObj.Free;
     inherited Finish;
     if Assigned(MemStream) then
      MemStream.Free;
{     if Assigned(ParamList) then
     begin
       for i := 0 to ParamList.Count - 1 do
         if Assigned(ParamList[i]) then
           Dispose(PInputLinePrms(ParamList[i]));}
 //    end;
      oReport := nil;
//     LogIt(spReport, 'End RepCtrlObj.Finish ' + Trim(ElertName));
     Dispose(MTExLocal, Destroy); //PR: 21/09/2009 Memory Leak Change
   End;
  end;
      FToolkit := nil;
      CoUninitialize;

end;

procedure TGUIReportThread.Process;
var
  ID : AnsiString;
  rwOptions : TOptionArray;
begin
  if Start then
  begin
    if DebugModeOn then
    begin
      ID := 'Sentinel VRW Report Create. ThreadID: ' + IntToStr(GetCurrentThreadID);
      OutputDebugString(PChar(ID));
    end;
    LogIt(spReport, 'TGUIReportThread.Process');
    FLocalFilesOpen := True;
    inherited Process;
    LogIt(spReport, 'TGUIReportThread.Process - after inherited');
    Try
      //PR: 15/02/2011 Tell the vrw engine not to display any messages
      rwOptions := oReport.vrPrintMethodParams.pmMiscOptions;
      rwOptions[Integer(GEN_NO_MESSAGES)] := True;
      oReport.vrPrintMethodParams.pmMiscOptions := rwOptions;
      oReport.Print('', True);
    Except
      on E:Exception do
        LogIt(spConveyor, 'Exception in VRWReport.Print: ' + E.Message);
    End;
    LogIt(spReport, 'TGUIReportThread.Process - after print');
  end;
end;

function TGUIReportThread.Start : Boolean;
var
  KeyS : Str255;
  Status, Res : SmallInt;
  Params : TReportParamRec;
//  ParamRec : ^TInputLinePrms;
  i : integer;
  o1, o2 : SmallInt;
  Control: IVRWControl;
  //PR: 03/06/2010 Change to IVRWBaseInputField to allow InputFields as well as Range Filters
//  ThisFilter : IVRWRangeFilter;
  ThisFilter : IVRWBaseInputField;
  IndexFilter : Boolean;
//  OutputFormat : TReportFileFormat;  //PR: 15/02/2011 Moved to private section of object to allow use by other methods.

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
    FProcessDescription := 'Preparing';
    CoInitialize(nil);
//    FToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
    FToolkit := CreateToolkitWithBackDoor;
    FToolkit.Configuration.DataDirectory := DataPath;
    FToolkit.OpenToolkit;
    with FToolkit do
      CurrPeriod := IntToStr(SystemSetup.ssCurrentYear + 1900) + IntToStr(SystemSetup.ssCurrentPeriod);
  LogIt(spReport, 'TGUIReportThread.Start');
  IndexFilter := True;
  oReport := GetVRWReport as IVRWReport3;
  if Assigned(oReport) then
    LogIt(spReport, 'GetVRWReport OK')
  else
  begin
    LogIt(spReport, 'oReport = nil');
    Result := False;
    Exit;
  end;
  oReport.vrOnPrintRecord := Progress;
  oReport.vrOnSecondPass := StartSecondPass;
  oReport.vrDataPath := DataPath;
  Try
    LogIt(spReport, 'Read Report: ' + DataPath + 'Reports\' + RepName + '.erf');
    oReport.Read(DataPath + 'Reports\' + RepName + '.erf');
    Result := True;
  Except
    on E:Exception do
    begin
      Result := False;
      LogIt(spReport, 'Exception reading report: ' + E.Message);
    end;
  End;
  if Result then
  begin
    LogIt(spReport, 'Report read OK');
//    MemStream := TMemoryStream.Create;
    New(MTExLocal, Create(27));
    with MTExLocal^ do
    begin
    //need to set RDevRec.feEmailAttType here and save it in Sentinel
      LSetDrive := DataPath;
      Open_System(ElertF, LineF);
      KeyS := LJVar(UserID, 10) + LJVar(ElertName, 30);
      Res := LFind_Rec(B_GetEq, ElertF, 0, KeyS);

      if Res = 0 then
        Res := Lock;

      if Res = 0 then
      begin
{        oReport.SetReportTypeLocation(OutputType(LElertRec), '');
        oReport.SilentRunning := True;}
        OutputFormat := OutputType(LElertRec);
        if OutputFormat in [EDF_FILE..EDZ_FILE] then
        begin
          oReport.vrPrintMethodParams.pmPrintMethod := Ord(OutputFormat);
//          oReport.vrPrintMethodParams.pmEmailAtType := Ord(OutputFormat);
        end
        else
        begin

          oReport.vrPrintMethodParams.pmPrintMethod := Ord(OutputFormat);
          oReport.vrPrintMethodParams.pmXMLFileDir := DataPath + 'swap\' + LElertRec.elCSVFileName;
        end;

        KeyS := pxElOutput + LJVar(UserID, 10) + LJVar(ElertName, 30) + #0#0 + otParams;

        Status := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

        while (Status = 0) and
        (LElertLineRec.Prefix = pxElOutput) and
        (Trim(LElertLineRec.Output.eoElertName) = Trim(ElertName)) and
        (Trim(LElertLineRec.Output.eoUserID) = Trim(UserID)) and
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

             //put first parameter into range rec
{         if not Assigned(ParamList) or (ParamList.Count = 0) then
             begin
               LElertRec.elRangeStart.egString := Params.Params[1];
               LElertRec.elRangeStart.egType := TElertRangeValType(LElertLineRec.Output.eoEntParamType);
               LElertRec.elRangeEnd.egString := Params.Params[2];
               LElertRec.elRangeStart.egInput := True;
               LElertRec.elRangeEnd.egInput := True;
             end;}


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
     end; //If lock
    end; // with MTExLocal^
  end; //If Result
  if Result then
    LogIt(spReport, 'TGUIReportThread.Start - Finish. Result = True')
  else
    LogIt(spReport, 'TGUIReportThread.Start - Finish. Result = False');

end;

procedure TGUIReportThread.Progress(Count, Total : integer; Var Abort : Boolean);
var
  PercentComplete : Integer;
  dCount, dTotal : Double;
begin
  dCount := Count;
  dTotal := Total;
  if Total <> 0 then
    PercentComplete := Trunc((dCount / dTotal) * 100)
  else //???
    PercentComplete := (Count mod 100) + 1;

  if PercentComplete <= 1 then
  begin
    InitProgress(100);
    InitStatusMemo(3);
  end;
//  ShowStatus(2, 'Processing report ' + QuotedStr(RepName));

  UpdateProgress(PercentComplete,  FProcessDescription + ' report ' + QuotedStr(RepName), '',
                 Format('Processing record %d of %d', [Count, Total]));
end;

function TGUIReportThread.Lock : SmallInt;
Var
//  SaveInfo : TElertFileSavePos;
  lRes     : LongInt;
begin
  With MTExLocal^ Do Begin
    // Save position in global file
  //  SaveMainPos(SaveInfo);

    // Save Record Position into LockPos so we can later use it for unlocking
    Result := LGetPos (ElertF, FLockPosition);
    If (Result = 0) Then Begin
      // Copy locked record position into data record
     SetDataRecOfsPtr (ElertF, FLockPosition, LRecPtr[ElertF]^);
      // Reread and lock record
   //   Result := LGetDirect(F[ElertF], ElertF, RecPtr[ElertF]^, 0, B_SingLock + B_SingNWLock);
      Result := LGetDirect(ElertF, 0, B_SingLock + B_SingNWLock);
      If (Result = 0) Then
        // Record Locked
        Inc (FLockCount);
    End { If (Result = 0) };

    // restore position in global file
   // RestoreMainPos(SaveInfo);
  End; { With FBtrIntf^ }
end;

function TGUIReportThread.UnLock : SmallInt;
var
  KeyS : Str255;
begin
  Result := 0;
  If (FLockCount > 0) Then Begin
    // Copy locked record position into data record
    SetDataRecOfsPtr(ElertF, FLockPosition, MTExLocal^.LRecPtr[ElertF]^);

    // Unlock Record
    FillChar (KeyS, Sizeof(KeyS), #0);
    Result := MTExLocal^.LFind_Rec(B_Unlock, ElertF, 0, KeyS);
    If (Result <> 0) Then Inc (Result, 30000);

    Dec(FLockCount);
  End; { If (FLockCount > 0) }
end;

function TGUIReportThread.OutputType(const ElRec : TElertRec) : TReportFileFormat;

  function GetEntFormat : TReportFileFormat;
  var
    Res : Integer;
    AttMethod : Byte;
//    FToolkit : IToolkit;
  begin
    Result := EDF_FILE;
    if Assigned(FToolkit) then
    Try
{      if (FToolkit.Status = tkOpen) and
         (UpperCase(Trim(FToolkit.Configuration.DataDirectory)) <>
           UpperCase(Trim(DataPath))) then
      begin
        FToolkit.CloseToolkit;

        FToolkit.Configuration.DataDirectory := DataPath;
        Res := FToolkit.OpenToolkit;
      end
      else
      if (FToolkit.Status <> tkOpen) then
      begin
        FToolkit.Configuration.DataDirectory := DataPath;
        Res := FToolkit.OpenToolkit;
      end
      else}
        Res := 0;

      if Res = 0 then
      begin
        Case FToolkit.SystemSetup.ssPaperless.ssAttachMethod of
          eamInternal :  Result := EDF_FILE;
          eamAcrobat  :  Result := ADOBE_PDF_FILE;
          eamInternalPDF : Result := INTERNAL_PDF_FILE;
        end;
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


procedure TGUIReportThread.StartSecondPass(Count, Total: integer;
  var Abort: Boolean);
begin
  FProcessDescription := 'Printing';
end;

destructor TGUIReportThread.Destroy;
begin
  QueryLock.Enter;
  Try
    QueryInUse := False;
  Finally
    QueryLock.Leave;
  End;
end;


end.
