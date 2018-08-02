unit DbAccessFilter;

interface

uses
  Classes, // delphi
  GlobVar, // exchequer
  GuiEng, // PR Code
  CtrlPrms, GlobalTypes; // my own

type
  TAccessFilter = class(TObject)
  private
    KeyS : Str255;

    FFileNumber : SmallInt;
    FIndexNumber : SmallInt;

    FRowList : TStringList;
    FSortedFieldNames : TStringList;
    FTotalsTracker : TStringList;
    FFmlIndexs : TStringList;

    FReportAborted : Boolean;

    DBEngine : TReportWriterEngine;

    FProgressEvent : TProgressMonitorEvent;

    PreviousFieldIdx,
    CurrentFieldIdx : SmallInt;

    procedure CheckRecord(Count, Total : Integer; var Abort : Boolean);
    function GetSortedFields : boolean;
  public
    bExternalCaller : Boolean;
    bSilentRunning : Boolean;
    DataString : string;

    constructor Create(const ReportConstruct : TReportConstructInfo; const ProgressEvent : TProgressMonitorEvent);
    destructor Destroy; override;

    procedure BuildSelection(const DBSelectionList : TList);
    procedure BuildDataSet;
    function GeneratePrintableData(const ReportCtrlType : TCtrlType; const CtrlParams : PCtrlParams; const BitMapImageList : TStringList = nil) : TPrintBaseParams;
    procedure UpdateTotals(const UpdateTotalMethod : TTotalUpdateMethod;
                           const FormulaParams : TPrintFormulaParams;
                           const siCurrentReportLine : SmallInt = -1 );
  published
    property RawReportData : TStringList read FRowList;
    property SortedFields : boolean read GetSortedFields;
    property SortedFieldNames : TStringList read FSortedFieldNames;
    property ReportAborted : Boolean read FReportAborted;
  end;

implementation

uses
  Controls, Windows, Forms, SysUtils, Dialogs, Graphics, // delphi
  ExBTTH1U, ExWrap1U, VarConst, BtrvU2, // exchequer
  RangeFiltersF, RangeFilterDetF; // my own

type
  TDependancy = (STAND_ALONE, DEPENDANT);

  TTotalObj = class(TObject)
    ssFormulaName : ShortString;
    Dependancy : TDependancy;

    dbFormulaTotal : Double;
    dbLeftTotal,
    dbRightTotal : Double;

    siLinkedFml : SmallInt;
    slLinkedFml : TStringList;
  public
    constructor Create;
    destructor Destroy; Override;
  end;

constructor TTotalObj.Create;
begin
  inherited Create;

  ssFormulaName := '';
  dbFormulaTotal := 0;
  Dependancy := STAND_ALONE;
  siLinkedFml := 0;
  slLinkedFml := TStringList.Create;
end;

destructor TTotalObj.Destroy;
begin
  while (slLinkedFml.Count > 0) do
    slLinkedFml.Delete(0);
  slLinkedFml.Free;

  inherited Destroy;
end;

//=========================================================================

constructor TAccessFilter.Create(const ReportConstruct : TReportConstructInfo; const ProgressEvent : TProgressMonitorEvent);
var
  FSpec            : FileSpec;
  iFileNo, iStatus : SmallInt;
  sKey             : ShortString;
begin
  inherited Create;

  FFileNumber := ReportConstruct.byMainFileNum; // siFileNumber;
  FIndexNumber := ReportConstruct.byIndexID; //  siIndexNumber;

  FProgressEvent := ProgressEvent;

  FRowList := TStringList.Create;
  FSortedFieldNames := TStringList.Create;
  FTotalsTracker := TStringList.Create;
  FFmlIndexs := TStringList.Create;

  FReportAborted := FALSE;

// HM 01/03/05: Removed this section because as far as I can tell the object is
// never used or destroyed, therefore it was leaking memory and file handles.
//
//  New(RepExLocal);
//  with RepExLocal^ do
//  begin
//    try
//      Create(14);
//
//      Open_System ( 1, 15);
//      Open_System ( 17, 17); // 17 = DictF
//
//    except
//      RepExLocal := nil;
//      ShowMessage('Unable to create Report Btrieve thread 14.');
//
//    end; {try..}
//
//  end;

  CurrentFieldIdx := 0;
  PreviousFieldIdx := 0;

  bExternalCaller := FALSE;

//iStatus := Find_Rec(B_GetFirst, F[CustF], CustF, RecPtr[CustF]^, 0, SKey);
//ShowMessage ('(' + IntToStr(iStatus) + ') ' + Cust.CustCode + ' - ' + Cust.Company);

  DBEngine := TReportWriterEngine.Create;
  DBEngine.OnCheckRecord := CheckRecord;

  DBEngine.FileNo := FFileNumber;
  DBEngine.IndexNo := FIndexNumber;

  with ReportConstruct.TestModeParams do
  begin
    DBEngine.TestMode := TestMode;
    DBEngine.SampleCount := SampleCount;
    DBEngine.RefreshFirst := RefreshStart;
    DBEngine.RefreshLast := RefreshEnd;
  end;

  DBEngine.ClearFields;
end;

//------------------------------

destructor TAccessFilter.Destroy;
Var
  iFile : SmallInt;
begin
  DBEngine.Free;

  if (assigned(FFmlIndexs)) then
  begin
    while (FFmlIndexs.Count > 0) do
      FFmlIndexs.Delete(0);
    FFmlIndexs.Free;
  end;

  if (assigned(FTotalsTracker)) then
  begin
    while (FTotalsTracker.Count > 0) do
    begin
      TTotalObj(FTotalsTracker.Objects[0]).Free;
      FTotalsTracker.Delete(0);
    end;
    FTotalsTracker.Free;
  end;

  if (assigned(FSortedFieldNames)) then
  begin
    while (FSortedFieldNames.Count > 0) do
    begin
      TSortObj(FSortedFieldNames.Objects[0]).Free;
      FSortedFieldNames.Delete(0);
    end;
    FSortedFieldNames.Free;
  end;

  if (assigned(FRowList)) then
  begin
    while (FRowList.Count > 0) do
    begin
      TDBRowObj(FRowList.Objects[0]).Free;
      FRowList.Delete(0);
    end;
    FRowList.Free;
  end;

  inherited Destroy;
end;

//-------------------------------------------------------------------------

procedure TAccessFilter.CheckRecord(Count, Total : Integer; var Abort : Boolean);
var
  rSinglePercent : Real;
  wPercentageComplete : Word;
begin
  rSinglePercent := (Total / 100);
  wPercentageComplete := Round((Count / rSinglePercent));

  if (assigned(FProgressEvent)) then
    FProgressEvent(wPercentageComplete, Abort);  

  FReportAborted := Abort;

  Application.ProcessMessages;
end;

procedure TAccessFilter.BuildSelection(const DBSelectionList : TList);
const
  START_TOKEN = '[';
  END_TOKEN = ']';
type
  TParseType = (INDEX_REPLACE, FORMULA_EXPAND);
var
  ssFieldNames : ShortString;
  SelectionIndex, SelectionCount : SmallInt;
  ssSortOrder : ShortString;
  siSortOrder : SmallInt;
  siSortInsertPos : SmallInt;
  oSortObj : TSortObj;

  //frmRangeFilterList : TfrmRangeFilterList;
  //slInputParams : TStringList;
  //oInputParams : TInputParamObj;
  //siObjIdx : SmallInt;
  siListIdx{, siListCount} : SmallInt;

  siFormulaCount, siFormulaNameIdx : SmallInt;
  ssExtractedFormula : ShortString;
  siStrIdx : SmallInt;
  siStartTokenPos, siEndTokenPos : SmallInt;
  ssDependantFmlName : ShortString;
  bCaptionFound, bExchangeMade : Boolean;
  ssSelection{, ssCalculation, ssPrintFilter} : ShortString;
  oRangeFilter : TRangeFilter;
  iCharPos : SmallInt;

  //TotalObj : TTotalObj;

//  function AlwaysAskParams : boolean;
//  var
//    siItemCount, siItemIdx : SmallInt;
//  begin
//    siItemCount := (slInputParams.Count - 1);
//
//    Result := FALSE; siItemIdx := 0;
//    while ((not Result) and (siItemIdx <= siItemCount)) do
//    begin
//      Result := TInputParamObj(slInputParams.Objects[siItemIdx]).InputParams.bAlwaysAsk;
//      Inc(siItemIdx);
//    end;
//  end;

  //------------------------------

  // FML[Calc_Days] > 30 AND FML[Calc_Days] < 60
  // FML[Formula2] * 2
  function ParseDependancy(const ssFormula : ShortString; const ParseType : TParseType = INDEX_REPLACE) : ShortString;
  var
    ssExpandedFormula,
    ssParsedFormula : ShortString;
    siFormulaIdx : SmallInt;
    siStartTokenPos, siEndTokenPos : SmallInt;
    siStrIdx : SmallInt;
    ssDependantFmlName : ShortString;
  begin
    ssParsedFormula := ssFormula;

    siStrIdx := 1;
    while (siStrIdx <= Length(ssParsedFormula)) do
    begin
      if (ssParsedFormula[siStrIdx] = START_TOKEN) then
      begin
        siStartTokenPos := siStrIdx;
        Inc(siStrIdx);
        ssDependantFmlName := '';
        // HM 16/03/05: Added Length check as the expansion of formulae can push the ] off the end
        // of a short string meaning this loop carried on past the end of the string.
        while (ssParsedFormula[siStrIdx] <> END_TOKEN) And (siStrIdx <= Length(ssParsedFormula)) do
        begin
          ssDependantFmlName := ssDependantFmlName + ssParsedFormula[siStrIdx];
          Inc(siStrIdx);
        end;
        siEndTokenPos := siStrIdx;

        if (Length(ssDependantFmlName) > 0) then
          case ParseType of
            INDEX_REPLACE :
              begin
                siFormulaIdx := FFmlIndexs.IndexOf(ssDependantFmlName);
                if (siFormulaIdx > -1) then
                begin
                  // converts siEndTokenPos from a position to a count value
                  siEndTokenPos := ((siEndTokenPos - siStartTokenPos) + 1);
                  Delete(ssParsedFormula, siStartTokenPos, siEndTokenPos);
                  Insert(Chr(10) + IntToStr(siFormulaIdx), ssParsedFormula, siStartTokenPos);
                  Delete(ssParsedFormula, Pos('FML',ssParsedFormula), 3);
                  // REMEMBER siEndToken is a count here.
                  siStrIdx := (siStartTokenPos + siEndTokenPos);
                end; // if (siFormulaIdx > -1) then...
              end;
            FORMULA_EXPAND :
              begin
                siFormulaNameIdx := 0;
                while siFormulaNameIdx <= SelectionCount do
                begin
                  if PCtrlParams(DBSelectionList.Items[siFormulaNameIdx]).cpCtrlType = REPORT_FORMULA then
                    if (PCtrlParams(DBSelectionList.Items[siFormulaNameIdx]).FormulaParams.cpFormulaName = ssDependantFmlName) then
                    begin
                      ssExpandedFormula := PCtrlParams(DBSelectionList.Items[siFormulaNameIdx]).FormulaParams.cpFormulaDefinition;

                      // HM 07/03/05: Remove leading ~ or " as they screw up the expanded formulae
                      If (Length(ssExpandedFormula) > 0) And (ssExpandedFormula[1] In ['"', '~']) Then
                        Delete (ssExpandedFormula, 1, 1);

                      // if the ssExpandedFormula contained other FML[] fields itself then these need to be found and expanded.
                      // Warning : This could get recursive!!
                      // This is essentially the problem with the REORDERa.ERF file that Joan has sent.
                      If (Pos('FML', ssExpandedFormula) > 0) Then
                      Begin
                        ssExpandedFormula := ParseDependancy(ssExpandedFormula, FORMULA_EXPAND);
                        //ssParsedFormula := ssExpandedFormula;
                      End; // if (Pos('FML', ssExpandedFormula) > 0)
                      //Else
                      //Begin

                      // HM 05/04/05: Changed this section as it was previously working incorrectly
                      // on the Else only, this meant that it all fell apart if there was an embedded
                      // formula as the entire original formala was overwritten.

                      // converts siEndTokenPos from a position to a count value
                      siEndTokenPos := ((siEndTokenPos - siStartTokenPos) + 1);
                      Delete(ssParsedFormula, siStartTokenPos, siEndTokenPos);
                      // HM 07/03/05: Modified so brackets are not inserted for string formulae - as they break the parser!
                      If (ssParsedFormula[1] <> '"') Then
                        Insert('('+ssExpandedFormula+')', ssParsedFormula, siStartTokenPos)
                      Else
                        Insert(ssExpandedFormula, ssParsedFormula, siStartTokenPos);
                      Delete(ssParsedFormula, Pos('FML',ssParsedFormula), 3);

                      // REMEMBER siEndToken is a count here.
                      siStrIdx := (siStartTokenPos + siEndTokenPos);
                    end;

                  Inc(siFormulaNameIdx);
                end; // while siFormulaNameIdx <= SelectionCount do...

              end; // FORMULA_EXPAND
          end; // case ParseType of...

      end // if (ssParsedFormula[siStrIdx] = START_TOKEN) then...
      else
        Inc(siStrIdx);
    end; // while (siStrIdx <= Length(ssParsedFormula)) do...

    Result := ssParsedFormula;
//ShowMessage ('ParseDependancy: ' + ssFormula + #13 + 'To: ' + ssParsedFormula);
  end;

  //------------------------------

  Procedure AddInputField (InpField : TRWInputObject; InputDets : TInputLineRecord);
  Begin // AddInputField
    InpField.Name := InputDets.ssName;
    InpField.InputType := Byte(InputDets.siType);
    case InputDets.siType of
      1 : // date
        begin
          // MH 21/03/05: Reformat from Andy's DDMMYYYY to standard YYYYMMDD
          // on the fly to avoid breaking existing reports
          If (Length(InputDets.ssFromValue) = 8) Then
            InpField.DateFrom := Copy(InputDets.ssFromValue, 5, 4) + Copy(InputDets.ssFromValue, 3, 2) + Copy(InputDets.ssFromValue, 1, 2);
          If (Length(InputDets.ssToValue) = 8) Then
            InpField.DateTo := Copy(InputDets.ssToValue, 5, 4) + Copy(InputDets.ssToValue, 3, 2) + Copy(InputDets.ssToValue, 1, 2);
        end;
      2 : // period
        begin
          // tried DateFrom/To, ValueFrom/To and StringFrom/To
          // also tried Copy(s,1,2) to extract the period value from the string
          // string example, 01/2002, period being the first two characters.
          //InpField.DateFrom := InputDets.ssFromValue;
          //InpField.DateTo := InputDets.ssToValue;

          Try
            If (Trim(InputDets.ssFromValue) <> '') And (Length(InputDets.ssFromValue) = 6) Then
            Begin
              InpField.PeriodFrom := StrToInt(Copy (InputDets.ssFromValue, 1, 2));
              InpField.YearFrom := StrToInt(Copy (InputDets.ssFromValue, 3, 4));
            End; // If (Trim(InputDets.ssFromValue) <> '') And (Length(InputDets.ssFromValue) = 6)
          Except
            On Exception Do
              MessageDlg ('Invalid From Period/Year value (' + InputDets.ssFromValue + ') for Input Field ' + InputDets.ssName, mtError, [mbOk], 0);
          End; // Try..Except

          Try
            If (Trim(InputDets.ssToValue) <> '') And (Length(InputDets.ssToValue) = 6) Then
            Begin
              InpField.PeriodTo := StrToInt(Copy (InputDets.ssToValue, 1, 2));
              InpField.YearTo := StrToInt(Copy (InputDets.ssToValue, 3, 4));
            End; // If (Trim(InputDets.ssToValue) <> '') And (Length(InputDets.ssToValue) = 6)
          Except
            On Exception Do
              MessageDlg ('Invalid To Period/Year value (' + InputDets.ssFromValue + ') for Input Field ' + InputDets.ssName, mtError, [mbOk], 0);
          End; // Try..Except
        end;
      3 : // value
        begin
          // HM 21/03/05: Modified as for -ve values the sign is on the right
          // which causes an exception!
          If (Pos ('-', InputDets.ssFromValue) > 0) Then
          Begin
            Delete (InputDets.ssFromValue, Pos ('-', InputDets.ssFromValue), 1);
            InputDets.ssFromValue := '-' + InputDets.ssFromValue;
          End; // If (Pos ('-', InputDets.ssFromValue) > 0)

          // MH 22/03/05: Modified to strip out thousands separators as they
          // also cause an exception.  I'm glad this was so thoroughly tested
          // when it was written or just think how crap it could have been!!!
          While (Pos (ThousandSeparator, InputDets.ssFromValue) > 0) Do
            Delete (InputDets.ssFromValue, Pos (ThousandSeparator, InputDets.ssFromValue), 1);

          InpField.ValueFrom := StrToFloat(InputDets.ssFromValue);

          //------------------------------

          If (Pos ('-', InputDets.ssToValue) > 0) Then
          Begin
            Delete (InputDets.ssToValue, Pos ('-', InputDets.ssToValue), 1);
            InputDets.ssToValue := '-' + InputDets.ssToValue;
          End; // If (Pos ('-', InputDets.ssFromValue) > 0)

          // MH 22/03/05: Modified to strip out thousands separators as they
          // also cause an exception.  I'm glad this was so thoroughly tested
          // when it was written or just think how crap it could have been!!!
          While (Pos (ThousandSeparator, InputDets.ssToValue) > 0) Do
            Delete (InputDets.ssToValue, Pos (ThousandSeparator, InputDets.ssToValue), 1);

          InpField.ValueTo := StrToFloat(InputDets.ssToValue);
        end;
      5 : // currency
        begin
          If (Length(InputDets.ssFromValue) > 0) Then
            InpField.CurrencyFrom := Ord(InputDets.ssFromValue[1]);

          If (Length(InputDets.ssToValue) > 0) Then
            InpField.CurrrencyTo := Ord(InputDets.ssToValue[1]);
        end;
      4,   // ASCII
      6,   // document no
      7,   // customer code
      8,   // supplier code
      9,   // nominal code
      10,  // stock code
      11,  // cost centre code
      12,  // department code
      13,  // location code
      17,  // Job Code
      18 : // Bin Code
        begin
          InpField.StringFrom := InputDets.ssFromValue;
          InpField.StringTo := InputDets.ssToValue;
        end;
    end; // case InputDets.siType of..
  End; // AddInputField

  //------------------------------

begin
  SelectionCount := (DBSelectionList.Count - 1);

  DBEngine.ClearFields;
  DBEngine.ClearInputs;

  ssFieldNames := '';
  FRowList.Clear;
  FSortedFieldNames.Clear;
  FTotalsTracker.Clear;
  FFmlIndexs.Clear;

  // Pre-process DBSelectionList
  // Exchange items in the list so that all dependant Selects, Formulas and Print Ifs are
  // after the formula etc that they are dependant on.
  SelectionIndex := 0;
  while (SelectionIndex <= SelectionCount) do
  begin
    for siFormulaCount := 1 to 2 do
    begin
      case PCtrlParams(DBSelectionList.Items[SelectionIndex]).cpCtrlType of
        REPORT_DB_FIELD :
          begin
            case siFormulaCount of
              1 : ssExtractedFormula := PCtrlParams(DBSelectionList.Items[SelectionIndex]).DBFieldParams.cpSelectCriteria;
              2 : ssExtractedFormula := PCtrlParams(DBSelectionList.Items[SelectionIndex]).DBFieldParams.cpPrintIfCriteria;
            end;
          end; // REPORT_DB_FIELD
        REPORT_FORMULA :
          begin
            case siFormulaCount of
              1 : ssExtractedFormula := ''; // Don't do this to Formula definitions.
              2 : ssExtractedFormula := PCtrlParams(DBSelectionList.Items[SelectionIndex]).FormulaParams.cpPrintIfCriteria;
            end;
          end; // REPORT_FORMULA
      end; // case PCtrlParams(DBSelectionList.Items[SelectionIndex]).cpCtrlType of...

      siStrIdx := Pos('FML',ssExtractedFormula);
      if (siStrIdx > 0) then
      while (siStrIdx <= Length(ssExtractedFormula)) do
      begin
        if (ssExtractedFormula[siStrIdx] = START_TOKEN) then
        begin
          siStartTokenPos := siStrIdx;
          Inc(siStrIdx);
          ssDependantFmlName := '';
          while (ssExtractedFormula[siStrIdx] <> END_TOKEN) do
          begin
            ssDependantFmlName := ssDependantFmlName + ssExtractedFormula[siStrIdx];
            Inc(siStrIdx);
          end;
          siEndTokenPos := siStrIdx;

          if (Length(ssDependantFmlName) > 0) then
          begin
            siListIdx := 0; bExchangeMade := FALSE;
            while (siListIdx <= SelectionCount) and (not bExchangeMade) do
            begin
              bCaptionFound := FALSE;
              case PCtrlParams(DBSelectionList.Items[siListIdx]).cpCtrlType of
                REPORT_DB_FIELD :
                  begin
                    bCaptionFound := (Pos(ssDependantFmlName, PCtrlParams(DBSelectionList.Items[siListIdx]).DBFieldParams.cpDBFieldName) > 0);
                  end;
                REPORT_FORMULA :
                  begin
                    bCaptionFound := (Pos(ssDependantFmlName, PCtrlParams(DBSelectionList.Items[siListIdx]).FormulaParams.cpFormulaName) > 0);
                  end;
              end;

              if bCaptionFound then
              begin
                if (siListIdx > SelectionIndex) then
                begin
                  DBSelectionList.Exchange(SelectionIndex, siListIdx);
                  bExchangeMade := TRUE;
                end;
              end;

              Inc(siListIdx);
            end; // while (siListIdx <= SelectionCount) and (not bExchangeMade) do...

          end; // if (Length(ssDependantFmlName) > 0 ) then...

        end // if (ssExtractedFormula[siStrIdx] = START_TOKEN) then...
        else
          Inc(siStrIdx);

      end; // while (siStrIdx <= Length(ssExtractedFormula)) do...
    end; // for siFormulaCount := 1 to 2 do...

    Inc(SelectionIndex);

  end; // while (SelectionIndex <= SelectionCount) do...

  // Load the Range Filters list and display it if there are any fields that
  // are marked as 'Ask'.  Use the list to update the RF formula fields as
  // well.  NOTE: Under Sentimail the Silent Running flag is set so this
  // window isn't shown
  With TfrmRangeFilters.Create(Application) Do
  Begin
    Try
      DialogMode := rflmPrintTime;

      // check if the Report Index Range Filter is defined
      If RangeFilterSet(@ReportConstructInfo.IndexInput) And ReportConstructInfo.IndexInput.bAlwaysAsk Then
      Begin
        AddRangeFilter('Index Filter', 255, @ReportConstructInfo.IndexInput);
      End; // If RangeFilterSet(@ReportConstructInfo.IndexInput) And ReportConstructInfo.IndexInput.bAlwaysAsk

      // Run through the list of control to extract references to the DB Fields
      For SelectionIndex := 0 To SelectionCount Do
      Begin
        With PCtrlParams(DBSelectionList.Items[SelectionIndex])^ Do
        Begin
          If (cpCtrlType = REPORT_DB_FIELD) Then
          Begin
            // Check that the range filter is defined
            If RangeFilterSet(@DBFieldParams.cpInputLine) And DBFieldParams.cpInputLine.bAlwaysAsk Then
            begin
              AddRangeFilter(DBFieldParams.cpDBFieldName, 255, @DBFieldParams.cpInputLine);
            End; // If RangeFilterSet(@DBFieldParams.cpInputLine) And DBFieldParams.cpInputLine.bAlwaysAsk
          End; // If (cpCtrlType = REPORT_DB_FIELD)
        End; // With PCtrlParams(DBSelectionList.Items[SelectionIndex])^
      End; // For SelectionIndex

      If (mulRangeFilters.DesignColumns[0].Items.Count > 0) Then
      Begin
        // Show the form if applicable to the mode
        If (Not bSilentRunning) Then
        Begin
          ShowModal;
        End; // If (Not bSilentRunning)

        // update any RF formulae with the final values
        For SelectionIndex := 0 To SelectionCount Do
        Begin
          With PCtrlParams(DBSelectionList.Items[SelectionIndex])^ Do
          Begin
            If (cpCtrlType = REPORT_FORMULA) Then
            Begin
              // Check for Range filter info command - RF[xxx] - should be
              // prefixed with " but might not be
              iCharPos := Pos('RF',UpperCase(FormulaParams.cpFormulaDefinition));
              If (iCharPos = 1) Or (iCharPos = 2) Then
              Begin
                // Run through the list of Range Filters and search for their names
                // in the formula.  MH: definately the lazy way to do it - should extract
                // the name and do it directly
                For siListIdx := 0 To (mulRangeFilters.DesignColumns[1].Items.Count - 1) Do
                Begin
                  // Extract the TRangeFilter object from the first column of the multilist
                  oRangeFilter := TRangeFilter(mulRangeFilters.DesignColumns[0].Items.Objects[siListIdx]);
                  Try
                    If (Pos(UpperCase(oRangeFilter.rfDesc), UpperCase(FormulaParams.cpFormulaDefinition)) > 0) Then
                    begin
                      FormulaParams.cpFormulaDefinition := oRangeFilter.rfDesc + ' from ' +
                                                           oRangeFilter.rfRangeFromString + ' to ' +
                                                           oRangeFilter.rfRangeToString;
                      Break;
                    End; // If (Pos(UpperCase(oRangeFilter.rfDesc), UpperCase(FormulaParams.cpFormulaDefinition)) > 0)
                  Finally
                    oRangeFilter := NIL;
                  End; // Try..Finally
                End; // For siListIdx
              End; // If (iCharPos = 1) Or (iCharPos = 2)
            End; // If (cpCtrlType = REPORT_FORMULA)
          End; // With PCtrlParams(DBSelectionList.Items[SelectionIndex])^
        End; // For SelectionIndex
      End; // If (mulRangeFilters.DesignColumns[0].Items.Count > 0)
    Finally
      Free;
    End; // Try..Finally
  End; // With TfrmRangeFilters.Create(Application)

  // HM 10/30/05: Add Indexing Report Filter if range is set
  If RangeFilterSet(@ReportConstructInfo.IndexInput) Then
  Begin
    ReportConstructInfo.IndexInput.ssName := 'RepIdxInputFilter';
    AddInputField (DBEngine.AddInput, ReportConstructInfo.IndexInput);
    DBEngine.InputLink := ReportConstructInfo.IndexInput.ssName;
  End; // If RangeFilterSet(@ReportConstructInfo.IndexInput)



  for SelectionIndex := 0 to SelectionCount do
    case PCtrlParams(DBSelectionList.Items[SelectionIndex]).cpCtrlType of
      REPORT_DB_FIELD :
        begin
          with DBEngine.AddField, PCtrlParams(DBSelectionList.Items[SelectionIndex]).DBFieldParams do
          begin
            ssFieldNames := ssFieldNames + IntToStr(Index) + '-' + cpDBFieldName + ReportRowFieldDelimiter;

            cpFieldIdx := Index;

            VarName := cpDBFieldName;
            DecPlaces := cpVarNoDecs;

            ssSelection := '';
            if (Length(cpSelectCriteria) > 0) then
              ssSelection := ParseDependancy(cpSelectCriteria);

// HM 07/03/05: Modified to use separate RangeFilter string on field
//            if ((Length(ssSelection) > 0) and (Length(cpParsedInputLine) > 0)) then
//              Filter := TrimRight(ssSelection) + ' AND ' + trim(cpParsedInputLine)
//            else if (Length(ssSelection) > 0) then
//              Filter := TrimRight(ssSelection)
//            else if (Length(cpParsedInputLine) > 0) then
//              Filter := cpParsedInputLine;
            Filter := TrimRight(ssSelection);

            // HM 10/30/05: Added check on Report Filter as cpParsedInputLine appears to get set even
            // when the range filter hasn't been!
            If RangeFilterSet(@cpInputLine) Then
            Begin
              RangeFilter := cpParsedInputLine;
            End; // If RangeFilterSet(@PCtrlParams(DBSelectionList.Items[SelectionIndex]).DBFieldParams.cpInputLine)

            if (Pos('FML', cpPrintIfCriteria) > 0) then
              PrintFilter := ParseDependancy(cpPrintIfCriteria)
            else
              PrintFilter := cpPrintIfCriteria;

            if (Length(cpSortOrder) > 0) then
            begin
              SortOrder := cpSortOrder;

              ssSortOrder := cpSortOrder;
              while (not(ssSortOrder[Length(ssSortOrder)] in ['0'..'9'])) do
                Delete(ssSortOrder, Length(ssSortOrder), 1);

              siSortOrder := StrToInt(ssSortOrder);

              oSortObj := TSortObj.Create;
              oSortObj.FieldName := cpDBFieldName;
              oSortObj.PageBreak := cpPageBreak;

              siSortInsertPos := (siSortOrder - 1);
              while (FSortedFieldNames.Count < siSortInsertPos) do
                FSortedFieldNames.AddObject('', nil);
              FSortedFieldNames.InsertObject(siSortInsertPos, cpDBFieldName, oSortObj);
            end;

            PeriodField := cpPeriodField;

            if cpPeriodField then
            begin
              Period := trim(cpPeriod);
              Year := trim(cpYear);
              Currency := cpCurrency;
            end;

            CalcField := FALSE;

          end;

          // HM 10/30/05: Modified check on Report Filter as the original generates false positives
          If RangeFilterSet(@PCtrlParams(DBSelectionList.Items[SelectionIndex]).DBFieldParams.cpInputLine) Then
          //if (PCtrlParams(DBSelectionList.Items[SelectionIndex]).DBFieldParams.cpInputLine.ssName <> '') then
          begin
            AddInputField (DBEngine.AddInput, PCtrlParams(DBSelectionList.Items[SelectionIndex]).DBFieldParams.cpInputLine);
          end;
        end; // REPORT_DB_FIELD
      REPORT_FORMULA :
        begin
          with PCtrlParams(DBSelectionList.Items[SelectionIndex]).FormulaParams do
          begin
            if ((cpTotalType = NO_TOTAL) or (cpTotalType = CALC_FIELD)) then
              if (length(trim(cpFormulaDefinition)) > 0) then
                if (Pos('RF',UpperCase(trim(cpFormulaDefinition))) <> 1) then
                begin
                  with DBEngine.AddField do
                  begin
                    ssFieldNames := ssFieldNames + IntToStr(Index) + '-' + cpFormulaName + ReportRowFieldDelimiter;

                    cpFieldIdx := Index;

                    CalcField := TRUE;
                    DecPlaces := cpDecimalPlaces;

                    if (Pos('FML',cpFormulaDefinition) > 0) then
                      Calculation := ParseDependancy(cpFormulaDefinition, FORMULA_EXPAND)
                    else
                      Calculation := trim(cpFormulaDefinition);

                    if (Pos('FML', cpPrintIfCriteria) > 0) then
                      PrintFilter := ParseDependancy(cpPrintIfCriteria)
                    else
                      PrintFilter := trim(cpPrintIfCriteria);

                    while (FFmlIndexs.Count < Index) do
                      FFmlIndexs.Add('');
                    FFmlIndexs.Insert(Index, cpFormulaName);

                    if (Length(cpSortOrder) > 0) then
                      SortOrder := trim(cpSortOrder);

                    // HM 09/03/05: Added Period/Year/Currency support for Formulae
                    PeriodField := True;
                    Period := trim(cpPeriod);
                    Year := trim(cpYear);
                    Currency := cpCurrency;
                  end; // with DBEngine.AddField do...

                end;
          end; // with PCtrlParams(DBSelectionList.Items[SelectionIndex]).FormulaParams do...
        end; // REPORT_FORMULA
    end; // case PCtrlParams(DBSelectionList.Items[SelectionIndex]).cpCtrlType of...

  FRowList.InsertObject(0, ssFieldNames, nil);

end;

procedure TAccessFilter.BuildDataSet;
var
  DataToRetrieve : Boolean;
  FieldIdx, FieldCount, RowCount : Integer;
  ssFieldValue : ShortString;
  oDBRowObj : TDBRowObj;
  oDrillDown : TDrillDownObj;
  bPrintIf : Boolean;
begin
  DBEngine.Execute;

  FieldCount := (DBEngine.FieldCount - 1);
  DataToRetrieve := DBEngine.GetFirst;

  if DataToRetrieve then
  begin
    ReportConstructInfo.TestModeParams.FirstRecPos := DBEngine.FirstPos;
    ReportConstructInfo.TestModeParams.LastRecPos := DBEngine.LastPos;
  end;

  RowCount := 1;
  while DataToRetrieve do
  begin
    oDBRowObj := TDBRowObj.Create;

    for FieldIdx := 0 to FieldCount do
    begin
      bPrintIf := DBEngine.Fields[FieldIdx].Print;

      if bPrintIf then
      begin
        ssFieldValue := DBEngine.Fields[FieldIdx].Value;
        if (Length(ssFieldValue) > 0) then
          if ((ssFieldValue[Length(ssFieldValue)]) = '-') and
             (ssFieldValue[1] in ['0'..'9']) then
            ssFieldValue := '-' + Copy(ssFieldValue, 1, (Length(ssFieldValue) - 1));

        oDBRowObj.ssRowString := oDBRowObj.ssRowString + ssFieldValue + ReportRowFieldDelimiter
      end
      else
        oDBRowObj.ssRowString := oDBRowObj.ssRowString + ' ' + ReportRowFieldDelimiter;

      if bPrintIf then
        if (assigned(DbEngine.Fields[FieldIdx].DrillDownInfo)) then
        begin
          oDrillDown := TDrillDownObj.Create;
          with oDrillDown, DBEngine.Fields[FieldIdx] do
          begin
            ddLevelNo := DrillDownInfo.LevelNo;
            ddMode := DrillDownInfo.Mode;
            ddKeyString := DrillDownInfo.KeyString;
            ddFileNo := DrillDownInfo.FileNo;
            ddIndexNo := DrillDownInfo.IndexNo;
          end;
          oDBRowObj.slDrillDownInfo.AddObject(trim(DBEngine.Fields[FieldIdx].VarName), oDrillDown);
        end;
    end; // for FieldIdx := 0 to FieldCount do...

    FRowList.InsertObject(RowCount, oDBRowObj.ssRowString, oDBRowObj);
    Inc(RowCount);

    DataToRetrieve := DBEngine.GetNext;
  end; // while DataToRetrieve do...
end;

function TAccessFilter.GeneratePrintableData(const ReportCtrlType : TCtrlType; const CtrlParams : PCtrlParams;
                                             const BitMapImageList : TStringList = nil) : TPrintBaseParams;
var
  siBMPIdx : SmallInt;
  RowCount, RowIdx : LongInt;
  stBMPStream : TMemoryStream;
  icoTempIcon : TIcon;

  siCurrentFieldCount,
  siCurrentFieldStart,
  siCurrentFieldEnd : SmallInt;
  ssExtractedField,
  ssTemp,
  ssCurrentField : ShortString;

  siActualFieldIdx,
  siOriginalIdx,
  siDelimiterPos : SmallInt;

  ssCurrentFieldCount,
  ssFieldList : ShortString;

  ssFieldIdxName,
  ssFieldIdx,
  ssFieldName : ShortString;

  FieldIdxMatch, NameMatch : BOOLEAN;
begin
  Result := nil;
  case ReportCtrlType of
    REPORT_TEXT :
      begin
        Result := TPrintTextParams.Create;
        with TPrintTextParams(Result), CtrlParams^.TextParams do
        begin
          szText := StrPCopy(szText, CtrlParams^.TextParams.cpCaption);

          ftTextFont.Name := cpFont.Name;
          ftTextFont.Size := cpFont.Size;
          ftTextFont.Style := TFontStyles(cpFont.Style);
          ftTextFont.Color := cpFont.Color;
        end;
      end; // REPORT_TEXT
    REPORT_LINE :
      begin
        Result := TPrintLineParams.Create;
        with TPrintLineParams(Result) do
        begin
          with CtrlParams^ do
          begin
            LineOrientation := LineParams.LineOrientation;
            
            case LineParams.LineOrientation of
              VERTICAL :
                begin
                  LineExtents.Left := cpRegionPoint.X;
                  LineExtents.Top := cpRegionPoint.Y;
                  LineExtents.Right := cpRegionPoint.X;
                  LineExtents.Bottom := (cpRegionPoint.Y + cpCtrlHeight);
                end;
              HORIZONTAL :
                begin
                  LineExtents.Left := cpRegionPoint.X;
                  LineExtents.Top := cpRegionPoint.Y;
                  LineExtents.Right := (cpRegionPoint.X + cpCtrlWidth);
                  LineExtents.Bottom := cpRegionPoint.Y;
                end;
            end; // case LineOrientation of...
          end; // with CtrlParams^ do...

          with CtrlParams^.LineParams do
          begin
            LineWidth := PenParams.Width;
            LineColor := PenParams.Color;
            LineStyle := TPenStyle(PenParams.Style);
          end; // with CtrlParams^.LineParams do...

        end; // with TPrintLineParams(Result) do...
      end; // REPORT_LINE
    REPORT_IMAGE :
      begin
        Result := TPrintImageParams.Create;
        if (assigned(BitMapImageList)) then
        begin
          siBMPIdx := BitMapImageList.IndexOf(CtrlParams^.ImageParams.BitMapFolio);
          if (siBMPIdx > -1) then
          begin
            stBMPStream := TMemoryStream.Create;
            try
              stBMPStream.WriteBuffer(TRawBMPStore(BitMapImageList.Objects[siBmpIdx]).pBMP^, TRawBMPStore(BitMapImageList.Objects[siBmpIdx]).iBMPSize);

              stBMPStream.Position := 0;
              TPrintImageParams(Result).bmImage.LoadFromStream(stBMPStream);
            finally
              stBMPStream.Free;
            end; // try..finally
          end;
        end;
      end; // REPORT_IMAGE
    REPORT_FORMULA :
      begin
        Result := TPrintFormulaParams.Create;
        with TPrintFormulaParams(Result), CtrlParams^.FormulaParams do
        begin
          if (length(trim(cpFormulaDefinition)) > 0) then
          begin
            // do this for all formulas. Only really needed for COUNT_FIELD and TOTAL_FIELD
            // but it gives me some future proving.
            // Also there is nothing to do here for COUNT_FIELD formulas, because they are just counting rows.
            ssFmlName := cpFormulaName;
            ssFormulaDefinition := trim(cpFormulaDefinition);
            byDecPlaces := cpDecimalPlaces;
            ssFieldFormat := cpFieldFormat;
            bPrintField := cpPrintField;
            case cpTotalType of
              TOTAL_FIELD :
                begin
                  RowCount := (FRowList.Count - 1);
                  for RowIdx := 0 to RowCount do
                    TPrintFormulaParams(Result).lstDataSet.Add(FRowList.Strings[RowIdx]);
                end;
              // HM 07/03/05: Added Calc_Field as the results from the engine were being ignored
              CALC_FIELD,
              NO_TOTAL :
                begin
                  RowCount := (FRowList.Count - 1);

                  // get field list from FRowList.Strings[0]
                  ssFieldList := FRowList.Strings[0];

                  siActualFieldIdx := 0;

                  ssFieldIdxName := Copy(ssFieldList, 1, (Pos(ReportRowFieldDelimiter, ssFieldList) - 1));
                  Delete(ssFieldList, 1, Pos(ReportRowFieldDelimiter, ssFieldList));
                  ssFieldIdx := Copy(ssFieldIdxName, 1, (Pos('-', ssFieldIdxName) - 1));
                  Delete(ssFieldIdxName, 1, Pos('-', ssFieldIdxName));
                  ssFieldName := ssFieldIdxName;

                  while (ssFieldName <> cpFormulaName) do
                  begin
                    Inc(siActualFieldIdx);
                    ssFieldIdxName := Copy(ssFieldList, 1, (Pos(ReportRowFieldDelimiter, ssFieldList) - 1));
                    Delete(ssFieldList, 1, Pos(ReportRowFieldDelimiter, ssFieldList));
                    ssFieldIdx := Copy(ssFieldIdxName, 1, (Pos('-', ssFieldIdxName) - 1));
                    Delete(ssFieldIdxName, 1, Pos('-', ssFieldIdxName));
                    ssFieldName := ssFieldIdxName;
                  end;

                  for RowIdx := 0 to RowCount do
                  begin
                    siCurrentFieldCount := 0;
                    ssCurrentField := FRowList.Strings[RowIdx];
                    siCurrentFieldStart := 1;
                    siCurrentFieldEnd := (Pos(ReportRowFieldDelimiter, ssCurrentField) - 1);

                    while (siCurrentFieldCount < siActualFieldIdx) do
                    begin
                      siCurrentFieldStart := (siCurrentFieldEnd + 2);
                      Delete(ssCurrentField, 1, Pos(ReportRowFieldDelimiter, ssCurrentField));
                      siCurrentFieldEnd := siCurrentFieldEnd + Pos(ReportRowFieldDelimiter, ssCurrentField);
                      Inc(siCurrentFieldCount);
                    end;

                    TPrintFormulaParams(Result).lstDataSet.Add(Copy(FRowList.Strings[RowIdx],
                                                     siCurrentFieldStart,((siCurrentFieldEnd - siCurrentFieldStart)+1)));
                  end; // for RowIdx := 0 to RowCount do...

                  inc(CurrentFieldIdx);

                end; // NO_TOTAL
              RANGE_FILTER_FIELD :
                begin
                  TPrintFormulaParams(Result).szTotalText :=
                                StrPCopy(TPrintFormulaParams(Result).szTotalText,'Range Filter - ' + ssFormulaDefinition);
                end; // RANGE_FILTER_FIELD 
            end; // case cpTotalType of...
          end
          else
          begin
            if (cpTotalType <> NO_TOTAL) then
              szTotalText := StrPCopy(szTotalText, cpCaption)
            else
              TPrintFormulaParams(Result).lstDataSet.Add(cpCaption);
          end; // if (length(trim(cpFormulaDefinition)) > 0) then...else...

          TotalType := cpTotalType;

          ftTextFont.Name := cpFont.Name;
          ftTextFont.Size := cpFont.Size;
          ftTextFont.Style := TFontStyles(cpFont.Style);
          ftTextFont.Color := cpFont.Color;
        end; // with TPrintFormulaParams(Result), CtrlParams^.FormulaParams do...
      end; // REPORT_FORMULA
    REPORT_DB_FIELD :
      begin
        Result := TPrintDataSet.Create;

        with TPrintDataSet(Result), CtrlParams^.DBFieldParams do
        begin
          ftTextFont.Name := cpFont.Name;
          ftTextFont.Size := cpFont.Size;
          ftTextFont.Style := TFontStyles(cpFont.Style);
          ftTextFont.Color := cpFont.Color;

          DBVarName := cpDBFieldName;
          ssSelectionCriteria := cpSelectCriteria;
          ssPrintIf := cpPrintIfCriteria;
          DBVarType := cpVarType;
          DBFieldLen := cpVarLen;
          DBNoDecs := cpVarNoDecs;

          DataFormatting.ssFieldFormat := cpFieldFormat;
          DataFormatting.ssSortOrder := cpSortOrder;
          DataFormatting.bPrintField := cpPrintField;
          DataFormatting.bSubTotal := cpSubTotal;
          DataFormatting.PageBreakOnChange := cpPageBreak;

          ssParsedInputLine := cpParsedInputLine;

          // get field list from FRowList.Strings[0]
          ssFieldList := FRowList.Strings[0];

          siActualFieldIdx := 0;

          FieldIdxMatch := FALSE; NameMatch := FALSE;
          repeat
            ssFieldIdxName := Copy(ssFieldList, 1, (Pos(ReportRowFieldDelimiter, ssFieldList) - 1));
            Delete(ssFieldList, 1, Pos(ReportRowFieldDelimiter, ssFieldList));
            ssFieldIdx := Copy(ssFieldIdxName, 1, (Pos('-', ssFieldIdxName) - 1));
            Delete(ssFieldIdxName, 1, Pos('-', ssFieldIdxName));
            ssFieldName := ssFieldIdxName;

            if (not FieldIdxMatch) then
              FieldIdxMatch := (StrToInt(ssFieldIdx) = cpFieldIdx);

            if (not NameMatch) and FieldIdxMatch then
              NameMatch := (cpDbFieldName = ssFieldName);
              
            if (FieldIdxMatch) and (NameMatch) then
              siActualFieldIdx := (cpFieldIdx - 1);
              
          until (NameMatch) and (FieldIdxMatch);

        end; // with TPrintDataSet(Result), CtrlParams^.DBFieldParams do...

        // TPrintDataSet(Result).lstDataSet is a TStringList that will contain the resulting rows of data
        // for this particular REPORT_DB_FIELD control.
        RowCount := (FRowList.Count - 1);
        for RowIdx := 0 to RowCount do
        begin
          siCurrentFieldCount := 0;
          ssCurrentField := FRowList.Strings[RowIdx];
          siCurrentFieldStart := 1;
          siCurrentFieldEnd := (Pos(ReportRowFieldDelimiter, ssCurrentField) - 1);

          while (siCurrentFieldCount < siActualFieldIdx) do
          begin
            if (Length(ssCurrentField) > Pos(ReportRowFieldDelimiter, ssCurrentField)) then
            begin
              siCurrentFieldStart := (siCurrentFieldEnd + 2);
              Delete(ssCurrentField, 1, Pos(ReportRowFieldDelimiter, ssCurrentField));
              siCurrentFieldEnd := siCurrentFieldEnd + Pos(ReportRowFieldDelimiter, ssCurrentField);
            end;
            Inc(siCurrentFieldCount);
          end;

          ssExtractedField :=
                     Copy(FRowList.Strings[RowIdx], siCurrentFieldStart, ((siCurrentFieldEnd - siCurrentFieldStart)+1));

          TPrintDataSet(Result).siFieldNumber := CurrentFieldIdx;

          if Length(ssExtractedField) = 0 then
            TPrintDataSet(Result).lstDataSet.Add('')
          else
            TPrintDataSet(Result).lstDataSet.Add(ssExtractedField);
        end; // for RowIdx := 0 to RowCount do...

        inc(CurrentFieldIdx);
        
      end; // REPORT_DB_FIELD
  end; // case ReportCtrlType of...

  if (assigned(Result)) then
  begin
    with TPrintBaseParams(Result) do
    begin
      ControlType := CtrlParams^.cpCtrlType;
      with CtrlParams^ do
      begin
        ControlBorder := Rect( (cpRegionPoint.X - 2),
                               (cpRegionPoint.Y - 2),
                               (cpRegionPoint.X + cpCtrlWidth + 2),
                               (cpRegionPoint.Y + cpCtrlHeight + 2) );
      end; // with CtrlParams^ do...
    end; // with TPrintBaseParams(Result) do...
  end; // if (assigned(Result)) then...

end;

procedure TAccessFilter.UpdateTotals(const UpdateTotalMethod : TTotalUpdateMethod;
                                     const FormulaParams : TPrintFormulaParams;
                                     const siCurrentReportLine : SmallInt = -1 );
var
  // for formula fields
  ssFieldList,
  ssFormulaDef,
  ssIntermediateCount,
  ssIntermediateTotal : ShortString;

  siIdx,
  siTtlIdx,
  siFMLIdx,
  siFieldStart,
  siIntermediateCount : SmallInt;

  dbIntermediateValue,
  dbIntermediateTotal : Double;

  ssExtractedField,
  ssCurrentRowContent : ShortString;

  siRowPos,
  siExtractFieldNumber,
  siThousandSeperatorPos : SmallInt;

  siOperatorPos : SmallInt;
  ssOperator : ShortString;
  ssLeftParameter,
  ssRightParameter : ShortString;
  dbLeftParamValue,
  dbRightParamValue,
  dbCalcTotal : Double;
  ssCalcTotal : ShortString;

  siFmlCount, siFmlIndex,
  siThisFormulaIdx : SmallInt;

  siTotalsCount, siTotalsIdx : SmallInt;

  TotalObj : TTotalObj;

begin
  // update total and count formula fields here.
  // FRowList.Insert(0, ssFieldNames);
  // First entry in FRowList is a string listing the field names extracted from the Enterprise database
  // Each field name is delimited by ReportRowFieldDelimiter (tilde) in GlobalTypes.Pas;
  with FormulaParams do
    if (TotalType = COUNT_FIELD) or (TotalType = TOTAL_FIELD) then
    begin
      if (siFieldNumber = 0) then
      begin
        ssFormulaDef := ssFormulaDefinition;

        if (Pos('DBF', ssFormulaDef) > 0) then
        begin
          ssFieldList := FRowList.Strings[0];

          while (Pos('[',ssFormulaDef) > 0) do
          begin
            Delete(ssFormulaDef, 1, Pos('[',ssFormulaDef)); // remove upto and including [
            Delete(ssFormulaDef, Length(ssFormulaDef), 1); // remove trailing ] ...thus leaving the field name
          end;

          // HM 03/03/05: Added loop to remove trailing brackets as above section can leave a trailing ']'
          While (Length(ssFormulaDef) > 0) And (ssFormulaDef[Length(ssFormulaDef)] In [')', ']']) Do
            Delete(ssFormulaDef, Length(ssFormulaDef), 1); // remove trailing ] ...thus leaving the field name

          TotalObj := TTotalObj.Create;
          TotalObj.ssFormulaName := ssFmlName;
          FTotalsTracker.AddObject(ssFmlName, TotalObj);

          // find field name in field list and count up the delimiters to get the field number
          siFieldStart := Pos(ssFormulaDef, ssFieldList);
          if (siFieldStart > 0) then
          begin
            for siIdx := 1 to siFieldStart do
              if (ssFieldList[siIdx] = ReportRowFieldDelimiter) then
                Inc(siFieldNumber);
            Inc(siFieldNumber);
          end; // if (siFieldStart > 0) then...

        end // if (Pos('DBF', ssFormulaDef) > 0) then...
        else if (Pos('FML', ssFormulaDef) > 0) then
        begin
          ssFieldList := FRowList.Strings[0];

          Delete(ssFormulaDef, 1, Pos('[',ssFormulaDef)); // remove upto and including [
          Delete(ssFormulaDef, Length(ssFormulaDef), 1); // remove trailing ] ...thus leaving the field name

          // HM 03/03/05: Added loop to remove trailing brackets as above section can leave a trailing ']'
          While (Length(ssFormulaDef) > 0) And (ssFormulaDef[Length(ssFormulaDef)] In [')', ']']) Do
            Delete(ssFormulaDef, Length(ssFormulaDef), 1); // remove trailing ] ...thus leaving the field name

          TotalObj := TTotalObj.Create;
          TotalObj.ssFormulaName := ssFmlName;
          if (Pos(ssFormulaDef, ssFieldList) > 0) then
          begin
            TotalObj.Dependancy := STAND_ALONE;
            TotalObj.siLinkedFml := -1;
            FTotalsTracker.AddObject(ssFmlName, TotalObj);

            // find field name in field list and count up the delimiters to get the field number
            siFieldStart := Pos(ssFormulaDef, ssFieldList);
            if (siFieldStart > 0) then
            begin
              for siIdx := 1 to siFieldStart do
                if (ssFieldList[siIdx] = ReportRowFieldDelimiter) then
                  Inc(siFieldNumber);
              Inc(siFieldNumber);
            end; // if (siFieldStart > 0) then...
          end // if (Pos(ssFormulaDef, ssFieldList) > 0) then...
          else
          begin
            TotalObj.Dependancy := DEPENDANT;
            TotalObj.siLinkedFml := FTotalsTracker.IndexOf(ssFormulaDef);
            FTotalsTracker.AddObject(ssFmlName, TotalObj);

            // This is really only here to stop it coming into this piece of code again.
            siFieldNumber := (FTotalsTracker.IndexOf(ssFormulaDef) + 1);
          end; // if (Pos(ssFormulaDef, ssFieldList) > 0) then...else...
          
        end; // else if (Pos('FML', ssFormulaDef) > 0) then...
      end; // if (siFieldNumber = 0) then...

      case TotalType of
        COUNT_FIELD :
          begin
            case UpdateTotalMethod of
              RESET_TOTAL : szTotalText := StrPCopy(szTotalText, '0');
              UPDATE_TOTAL :
                // Only update the field count formula when there is a legitimate line number.
                if (siCurrentReportLine > -1) then
                begin
                  siIntermediateCount := StrToInt(StrPas(szTotalText));
                  Inc(siIntermediateCount);
                  ssIntermediateCount := IntToStr(siIntermediateCount);
                  szTotalText := StrPCopy(szTotalText, ssIntermediateCount);
                end;
            end; // case UpdateTotalMethod of...
          end; // COUNT_FIELD
        TOTAL_FIELD :
          begin
            case UpdateTotalMethod of
              RESET_TOTAL :
                begin
                  szTotalText := StrPCopy(szTotalText, '0');
                  // take the name of this formula and look up in TotalTracker
                  siThisFormulaIdx := FTotalsTracker.IndexOf(ssFmlName);
                  if (siThisFormulaIdx > -1) then
                  begin
                    siFmlCount := (FTotalsTracker.Count - 1); siFmlIndex := 0;
                    while (siFmlIndex <= siFmlCount) do
                    begin
                      if (TTotalObj(FTotalsTracker.Objects[siFmlIndex]).Dependancy = DEPENDANT) then
                        if (TTotalObj(FTotalsTracker.Objects[siFmlIndex]).slLinkedFml.Count > 0) then
                        begin
                          for siTtlIdx := 0 to (TTotalObj(FTotalsTracker.Objects[siFmlIndex]).slLinkedFml.Count - 1) do
                            with TTotalObj(FTotalsTracker.Objects[siFmlIndex]) do
                              if (siThisFormulaIdx = StrToInt(slLinkedFml[siTtlIdx])) then
                                case siTtlIdx of
                                  0 : dbLeftTotal := dbLeftTotal +
                                        TTotalObj(FTotalsTracker.Objects[siThisFormulaIdx]).dbFormulaTotal;
                                  1 : dbRightTotal := dbRightTotal +
                                        TTotalObj(FTotalsTracker.Objects[siThisFormulaIdx]).dbFormulaTotal;
                                end;
                        end
                        else
                        begin
                          if (siThisFormulaIdx = TTotalObj(FTotalsTracker.Objects[siFmlIndex]).siLinkedFml) then
                            with FTotalsTracker do
                              TTotalObj(Objects[siFmlIndex]).dbFormulaTotal :=
                                TTotalObj(Objects[siFmlIndex]).dbFormulaTotal +
                                  TTotalObj(Objects[siThisFormulaIdx]).dbFormulaTotal;
                        end;
                      Inc(siFmlIndex);
                    end; // while (siFmIdx <= siFmlCount) do...

                    // once the formula total has been carried over to it's dependants it needs resetting.
                    TTotalObj(FTotalsTracker.Objects[siThisFormulaIdx]).dbFormulaTotal := 0;

                  end; // if (siThisFormulaIdx > -1) then...
                end;
              UPDATE_TOTAL :
                begin
                  // MH 27/04/05: Added check that the field actually exists otherwise get range check error
                  If (siFieldNumber <> 0) Then
                  Begin
                    dbIntermediateTotal := 0; dbIntermediateValue := 0;
                    ssExtractedField := ''; ssIntermediateTotal := '';
                    if (Pos('DBF', ssFormulaDefinition) > 0) then
                    begin
                      if (siCurrentReportLine > -1) then
                      begin
                        ssCurrentRowContent := lstDataSet.Strings[siCurrentReportLine];
                        siExtractFieldNumber := 1; siRowPos := 1;
                        while (siExtractFieldNumber <> siFieldNumber) do
                        begin
                          if (ssCurrentRowContent[siRowPos] = ReportRowFieldDelimiter) then
                            Inc(siExtractFieldNumber);
                          Inc(siRowPos);
                        end;

                        if (siRowPos > Pos(ReportRowFieldDelimiter, ssCurrentRowContent)) then
                          Delete(ssCurrentRowContent, 1, (siRowPos - 1));

                        ssExtractedField := Copy(ssCurrentRowContent, 1, (Pos(ReportRowFieldDelimiter, ssCurrentRowContent) - 1));

                        // move minus sign to the right hand side.
                        if (ssExtractedField[Length(ssExtractedField)] = '-') then
                        begin
                          Delete(ssExtractedField, Length(ssExtractedField), 1);
                          ssExtractedField := '-' + ssExtractedField;
                        end;

                        // filter out the thousand seperator, cos StrToFloat doesn't like that!!
                        siThousandSeperatorPos := Pos(ThousandSeparator, ssExtractedField);
                        while (siThousandSeperatorPos > 0) do
                        begin
                          Delete(ssExtractedField, siThousandSeperatorPos, 1);
                          siThousandSeperatorPos := Pos(ThousandSeparator, ssExtractedField);
                        end;

                        try
                          dbIntermediateValue := StrToFloat(ssExtractedField);
                        except on EConvertError do
                          dbIntermediateValue := 0;
                        end;

                        ssIntermediateTotal := StrPas(szTotalText);

                        // filter out the thousand seperator, cos StrToFloat doesn't like that!!
                        siThousandSeperatorPos := Pos(ThousandSeparator, ssIntermediateTotal);
                        while (siThousandSeperatorPos > 0) do
                        begin
                          Delete(ssIntermediateTotal, siThousandSeperatorPos, 1);
                          siThousandSeperatorPos := Pos(ThousandSeparator, ssIntermediateTotal);
                        end;

                        try
                          dbIntermediateTotal := StrToFloat(ssIntermediateTotal);
                        except on EConvertError do
                          dbIntermediateTotal := 0;
                        end;

                        dbIntermediateTotal := dbIntermediateTotal + dbIntermediateValue;

                        try
                          ssIntermediateTotal := FloatToStrF(dbIntermediateTotal, ffNumber, 15, byDecPlaces);
                        except on EConvertError do
                          ssIntermediateTotal := 'Conversion Error';
                        end;

                        if (ssIntermediateTotal <> 'Conversion Error') then
                        begin
                          ssFormulaDef := ssFormulaDefinition;

                          Delete(ssFormulaDef, 1, Pos('[',ssFormulaDef)); // remove upto and including [
                          Delete(ssFormulaDef, Length(ssFormulaDef), 1); // remove trailing ] leaving the field name

                          siFMLIdx := FTotalsTracker.IndexOf(ssFmlName);
                          if (siFMLIdx > -1) then
                            TTotalObj(FTotalsTracker.Objects[siFMLIdx]).dbFormulaTotal := dbIntermediateTotal;
                        end; // if (ssIntermidateTotal <> 'Conversion Error') then...

                      end; // if (siCurrentReportLine > -1) then...
                    end // if (Pos('DBF', ssFormulaDefinition) > 0) then...
                    else if (Pos('FML',ssFormulaDefinition) > 0) then
                    begin
                      siFMLIdx := FTotalsTracker.IndexOf(ssFmlName); // ssFmlName is part of FormulaParams
                      if (siFMLIdx > -1) then
                      begin
                        if (TTotalObj(FTotalsTracker.Objects[siFMLIdx]).Dependancy = DEPENDANT) then
                        begin
                          dbIntermediateTotal := TTotalObj(FTotalsTracker.Objects[siFMLIdx]).dbFormulaTotal;

                          try
                            ssIntermediateTotal := FloatToStrF(dbIntermediateTotal, ffNumber, 15, byDecPlaces);
                          except on EConvertError do
                            ssIntermediateTotal := 'Convertion Error';
                          end;

                        end // if (TTotalObj(FTotalsTracker.Objects[siFMLIdx]).Dependancy = DEPENDANT) then...
                        else
                        begin
                          if (siCurrentReportLine > -1) then
                          begin
                            ssCurrentRowContent := lstDataSet.Strings[siCurrentReportLine];
                            siExtractFieldNumber := 1; siRowPos := 1;
                            while (siExtractFieldNumber <> siFieldNumber) do
                            begin
                              if (ssCurrentRowContent[siRowPos] = ReportRowFieldDelimiter) then
                                Inc(siExtractFieldNumber);
                              Inc(siRowPos);
                            end;

                            if (siRowPos > Pos(ReportRowFieldDelimiter, ssCurrentRowContent)) then
                              Delete(ssCurrentRowContent, 1, (siRowPos - 1));

                            ssExtractedField := Copy(ssCurrentRowContent, 1, (Pos(ReportRowFieldDelimiter, ssCurrentRowContent) - 1));

                            // move minus sign to the right hand side.
                            if (ssExtractedField[Length(ssExtractedField)] = '-') then
                            begin
                              Delete(ssExtractedField, Length(ssExtractedField), 1);
                              ssExtractedField := '-' + ssExtractedField;
                            end;

                            // filter out the thousand seperator, cos StrToFloat doesn't like that!!
                            siThousandSeperatorPos := Pos(ThousandSeparator, ssExtractedField);
                            while (siThousandSeperatorPos > 0) do
                            begin
                              Delete(ssExtractedField, siThousandSeperatorPos, 1);
                              siThousandSeperatorPos := Pos(ThousandSeparator, ssExtractedField);
                            end;

                            try
                              dbIntermediateValue := StrToFloat(ssExtractedField);
                            except on EConvertError do
                              dbIntermediateValue := 0;
                            end;

                            ssIntermediateTotal := StrPas(szTotalText);

                            // filter out the thousand seperator, cos StrToFloat doesn't like that!!
                            siThousandSeperatorPos := Pos(ThousandSeparator, ssIntermediateTotal);
                            while (siThousandSeperatorPos > 0) do
                            begin
                              Delete(ssIntermediateTotal, siThousandSeperatorPos, 1);
                              siThousandSeperatorPos := Pos(ThousandSeparator, ssIntermediateTotal);
                            end;

                            try
                              dbIntermediateTotal := StrToFloat(ssIntermediateTotal);
                            except on EConvertError do
                              dbIntermediateTotal := 0;
                            end;

                            dbIntermediateTotal := dbIntermediateTotal + dbIntermediateValue;

                            try
                              ssIntermediateTotal := FloatToStrF(dbIntermediateTotal, ffNumber, 15, byDecPlaces);
                            except on EConvertError do
                              ssIntermediateTotal := 'Conversion Error';
                            end;

                            if (ssIntermediateTotal <> 'Conversion Error') then
                            begin
                              ssFormulaDef := ssFormulaDefinition;

                              Delete(ssFormulaDef, 1, Pos('[',ssFormulaDef)); // remove upto and including [
                              Delete(ssFormulaDef, Length(ssFormulaDef), 1); // remove trailing ] ...thus leaving field name

                              siFMLIdx := FTotalsTracker.IndexOf(ssFmlName);
                              if (siFMLIdx > -1) then
                                TTotalObj(FTotalsTracker.Objects[siFMLIdx]).dbFormulaTotal := dbIntermediateTotal;
                            end; // if (ssIntermidateTotal <> 'Conversion Error') then...

                          end; // if (siCurrentReportLine > -1) then...
                        end; // if (TTotalObj(FTotalsTracker.Objects[siFMLIdx]).Dependancy = DEPENDANT) then...else...
                      end; // if (siFMLIdx > -1) then...
                    end; // else if (Pos('FML',ssFormulaDefinition) > 0) then...

                    if (Length(ssIntermediateTotal) > 0) then
                      szTotalText := StrPCopy(szTotalText, ssIntermediateTotal);
                  end // If (siFieldNumber <> 0)
                  else
                    // Totalled Field doesn't exist - return 0
                    szTotalText := StrPCopy(szTotalText, '0');
                end;
            end; // case UpdateTotalMethod of...
          end; // TOTAL_FIELD
      end; // case TOTAL_TYPE of...
    end // if (TotalType = COUNT_FIELD) or (TotalType = TOTAL_FIELD) then...
    else if (TotalType = CALC_FIELD) then
    begin
//      siOperatorPos : SmallInt;
//      ssOperator : ShortString;
//      ssLeftParameter,
//      ssRightParameter : ShortString;
//      dbLeftParamValue,
//      dbRightParamValue,                                                
//      dbCalcTotal : Double;
//      ssCalcTotal : ShortString;

      if (siFieldNumber = 0) then
      begin
        siOperatorPos := 0;
        if (Length(ssFormulaDefinition) > 0) then
          while (not IsDelimiter('+-\*', ssFormulaDefinition, siOperatorPos)) do
            Inc(siOperatorPos);

        if (siOperatorPos > 0) then
        begin
          // extract the operator
          ssFormulaDef := ssFormulaDefinition;
          ssOperator := Copy(ssFormulaDef, siOperatorPos, 1);

          // find the two parameters.
          ssLeftParameter := trim(Copy(ssFormulaDef, 1, (siOperatorPos - 1)));
          ssRightParameter := trim(Copy(ssFormulaDef, (siOperatorPos + 1), (Length(ssFormulaDef) - siOperatorPos)));

          Delete(ssLeftParameter, 1, Pos('[',ssLeftParameter)); // remove upto and including [
          // remove trailing ] ...thus leaving field name
          while (Length(ssLeftParameter) > 0) and (ssLeftParameter[Length(ssLeftParameter)] <> ']') do
            Delete(ssLeftParameter, Length(ssLeftParameter), 1);
          Delete(ssLeftParameter, Length(ssLeftParameter), 1);

          Delete(ssRightParameter, 1, Pos('[',ssRightParameter)); // remove upto and including [
          // remove trailing ] ...thus leaving field name
          while (Length(ssRightParameter) > 0) and (ssRightParameter[Length(ssRightParameter)] <> ']') do
            Delete(ssRightParameter, Length(ssRightParameter), 1);
          Delete(ssRightParameter, Length(ssRightParameter), 1);

          TotalObj := TTotalObj.Create;
          TotalObj.ssFormulaName := ssFmlName;
          TotalObj.Dependancy := DEPENDANT;

          TotalObj.slLinkedFml.Add(IntToStr(FTotalsTracker.IndexOf(ssLeftParameter)));
          TotalObj.slLinkedFml.Add(IntToStr(FTotalsTracker.IndexOf(ssRightParameter)));

          // Setting siFieldNumber like this is really only here to stop it coming into this piece of code again.
          siFieldNumber := FTotalsTracker.AddObject(ssFmlName, TotalObj);

        end; // if (siOperatorPos > 0) then...
      end;

      case UpdateTotalMethod of
        RESET_TOTAL :
          begin
            szTotalText := StrPCopy(szTotalText, '0');
            // take the name of this formula and look up in TotalTracker
            siThisFormulaIdx := FTotalsTracker.IndexOf(ssFmlName);
            if (siThisFormulaIdx > -1) then
              with TTotalObj(FTotalsTracker.Objects[siThisFormulaIdx]) do
              begin
                dbLeftTotal := 0;
                dbRightTotal := 0;
              end;
          end;
        UPDATE_TOTAL :
          begin
            // find the operator in the formula definition
            siOperatorPos := 0;
            if (Length(ssFormulaDefinition) > 0) then
              while (not IsDelimiter('+-\*', ssFormulaDefinition, siOperatorPos)) do
                Inc(siOperatorPos);

            if (siOperatorPos > 0) then
            begin
              // extract the operator
              ssFormulaDef := ssFormulaDefinition;
              ssOperator := Copy(ssFormulaDef, siOperatorPos, 1);

              // find the two parameters.
              ssLeftParameter := trim(Copy(ssFormulaDef, 1, (siOperatorPos - 1)));
              ssRightParameter := trim(Copy(ssFormulaDef, (siOperatorPos + 1), (Length(ssFormulaDef) - siOperatorPos)));

              // if one or more parameters is a formula then look it up in the FTotalsTracker list
              if (Pos('FML', ssLeftParameter) > 0) then
              begin
                Delete(ssLeftParameter, 1, Pos('[',ssLeftParameter)); // remove upto and including [
                Delete(ssLeftParameter, Length(ssLeftParameter), 1); // remove trailing ] ...thus leaving field name

                siFMLIdx := FTotalsTracker.IndexOf(ssLeftParameter);
                if (siFMLIdx > -1) then
                  dbLeftParamValue := TTotalObj(FTotalsTracker.Objects[siFMLIdx]).dbFormulaTotal +
                                                            TTotalObj(FTotalsTracker.Objects[siFieldNumber]).dbLeftTotal;
              end
              else
              begin
                try
                  dbLeftParamValue := StrToFloat(ssLeftParameter);
                except on EConvertError do
                  dbLeftParamValue := 0;
                end;
              end; // if (Pos('FML' ssLeftParameter) > 0) then...

              if (Pos('FML', ssRightParameter) > 0) then
              begin
                Delete(ssRightParameter, 1, Pos('[',ssRightParameter)); // remove upto and including [
                Delete(ssRightParameter, Length(ssRightParameter), 1); // remove trailing ] ...thus leaving field name

                siFMLIdx := FTotalsTracker.IndexOf(ssRightParameter);
                if (siFMLIdx > -1) then
                  dbRightParamValue := TTotalObj(FTotalsTracker.Objects[siFMLIdx]).dbFormulaTotal +
                                                           TTotalObj(FTotalsTracker.Objects[siFieldNumber]).dbRightTotal;
              end
              else
              begin
                try
                  dbRightParamValue := StrToFloat(ssRightParameter);
                except on EConvertError do
                  dbRightParamValue := 0;
                end;
              end; // if (Pos('FML' ssRightParameter) > 0) then...

              case ssOperator[1] of
                '+' : dbCalcTotal := (dbLeftParamValue + dbRightParamValue);
                '-' : dbCalcTotal := (dbLeftParamValue - dbRightParamValue);
                '/' : if (dbRightParamValue > 0) then
                        dbCalcTotal := (dbLeftParamValue / dbRightParamValue)
                      else
                        dbCalcTotal := 0;
                '*' : dbCalcTotal := (dbLeftParamValue * dbRightParamValue);
                else
                  dbCalcTotal := 0;
              end;

              try
                ssCalcTotal := FloatToStrF(dbCalcTotal, ffNumber, 15, byDecPlaces);
              except on EConvertError do
                ssCalcTotal := '0';
              end;

              szTotalText := StrPCopy(szTotalText, ssCalcTotal);
            end
            else
              szTotalText := StrPCopy(szTotalText,'CALC_FIELD');
          end;
      end; // case UpdateTotalMethod of...
    end; // else if (TotalType = CALC_FIELD) then...
end;

function TAccessFilter.GetSortedFields : boolean;
begin
  Result := (FSortedFieldNames.Count > 0);
end;

end.
