unit SQL_DaybookPosting;

interface
uses Windows, Classes, SysUtils, Dialogs,Forms, DB, ADODB, VarConst, SQLCallerU,IndeterminateProgressF,
    ADOConnect, SQLUtils, GlobVar, Controls,BTSupU3;

{SS 30/01/2016 2017-R1: ABSEXCH-13159:Ability to post single items from Daybook without putting other transactions on Hold.
- Unit is used to execute daybook posting stored procedure.}


type
  TSQLDayBookPosting = class(TObject)
  { PL 13/02/2017 2017-R1 ABSEXCH-18331 :  added a msg to show the handled
    exception Which is created when execution of stored procedure throws error
    in SQL_DaybookPosting. }
  private
    FErrorMsg: String;
  protected
    FCompanyCode: string;
    FSQLCaller : TSQLCaller;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    //Execute esp_PostDaybook stored procedure for daybook posting.
    function ExecDayBookPost(aPostTransactionTypes : DocSetType;
                             var aPostRunNo : Integer;
                             aPostingYear:Integer;
                             aPeriod:Integer;
                             aPostingMode : Integer;
                             aSeparateControl : Integer;
                             aLoginName : Str255
                             ) : Integer;

    //Execute esp_PostTransactionList stored procedure for single daybook posting
    function ExecTransactionPost(aPostTransaction : Str255;
                                 var aPostRunNo : Integer;
                                 aPostingYear:Integer;
                                 aPeriod:Integer;
                                 aSeparateControl : Integer;
                                 aLoginName : Str255
                                 ): Integer;


    //Get excluded trasaction list which are not posted during the posting.
    function ExecPostRunExclusionReport(aPostRunNo : Integer ; aTransList : TStringList) : Integer;

    //Execute esp_PostRunSummaryReport stored procedure. 
    function ExecPostRunSummaryReport(aPostRunNo : Integer ; var aPostSummary : PostingSummaryArray) : Integer;
    { PL 13/02/2017 2017-R1 ABSEXCH-18331 :  added a msg to show the handled
      exception Which is created when execution of stored procedure throws error
      in SQL_DaybookPosting. }      
    Property ErrorMsg : String read FErrorMsg;
  end;

              

implementation

uses TypInfo,SQLRep_Config;

const
  cFldOurReference     = 'OurReference';
  cFldExclusionReason  = 'ExclusionReason';
  cFldPostAnalysisType = 'PostAnalysisType';

  cFldBFwdValue = 'BFwdValue';
  cFldRunValue  = 'RunValue';
  cFldCFwdValue = 'CFwdValue';


  
{SS 09/02/2016 2017-R1:ABSEXCH-18134:Incorporate the new Stored Procedures into the Exchequer Daybook Posting Process.}
//Convert DocTypes in to String. 
function DSetToStr(DSet: DocSetType): string;
const
  Delims: array[Boolean] of string = ('', ',');
var
  SetItem: DocTypes;
Begin
  Result := '';
  for SetItem := Low(SetItem) to High(SetItem) do
    if SetItem in DSet then
      Result := Result + Delims[Length(Result) > 0] + DocCodes[SetItem];
end;


{ TSQLDayBookPosting }

constructor TSQLDayBookPosting.Create;
var
  ConnectionString,
  lPassword: WideString;
begin
  inherited Create;
  // Create the SQL Caller instance
  FSQLCaller := TSQLCaller.Create(nil);

  // Determine the company code
  FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);

  // Set up the ADO Connection for the SQL Caller
  //SQLUtils.GetConnectionString(FCompanyCode, False, ConnectionString);
  //VA:27/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  SQLUtils.GetConnectionStringWOPass(FCompanyCode, False, ConnectionString, lPassword);
  FSQLCaller.ConnectionString := ConnectionString;
  FSQLCaller.Connection.Password := lPassword;

  //SS:09/06/2017:2017-R1:ABSEXCH-18759:If an error occurs during posting, the error is not returned to Exchequer and depending on the error nothing is posted.
  FSQLCaller.RaiseSuppressedException := True; 
  
  //SS 31/03/2017 2017-R1:ABSEXCH-18509:Daybook Posting Failing on Large Datasets.
  // Set the time-outs to as defined in ini File
  FSQLCaller.Connection.CommandTimeout := SQLReportsConfiguration.SQLDayBookPostingTimeoutInSeconds;
  FSQLCaller.StoredProcedure.CommandTimeout := SQLReportsConfiguration.SQLDayBookPostingTimeoutInSeconds;

  FErrorMsg:='';

end;


destructor TSQLDayBookPosting.Destroy;
begin
  FreeAndNil(FSQLCaller);
  
  inherited Destroy;
end;


{SS 17/02/2017 2017-R1:ABSEXCH-18134:Incorporate the new Stored Procedures into the Exchequer Daybook Posting Process.}
//Execute esp_PostDaybook stored procedure for daybook posting.

function TSQLDayBookPosting.ExecDayBookPost(aPostTransactionTypes: DocSetType; var aPostRunNo : Integer; aPostingYear, aPeriod, aPostingMode,
                                             aSeparateControl: Integer; aLoginName: Str255):Integer;
var
  lCursor : TCursor;
  lQuery: string;
  lParamList : TStringList;
  lPostRunNo : String;
  lDocTypes : String;
begin
  Result := -1;
  lDocTypes := DSetToStr(aPostTransactionTypes);
  aPostRunNo := 0;

  lCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  
  lParamList := TStringList.Create;
  try
    //Initialize stored procedure parameters.       
    lParamList.Values['@iv_PostTransactionTypes']:=  lDocTypes;
    lParamList.Values['@iv_PostingYear']         :=  IntToStr(aPostingYear);
    lParamList.Values['@iv_PostingPeriod']       :=  IntToStr(aPeriod);
    lParamList.Values['@iv_PostingMode']         :=  IntToStr(aPostingMode);
    lParamList.Values['@iv_SeparateControl']     :=  IntToStr(aSeparateControl);
    lParamList.Values['@iv_LoginName']           :=  aLoginName;


    lQuery :=  '[' + FCompanyCode + ']'+'.esp_PostDaybook ';

    Result :=  FSQLCaller.ExecStoredProcedure(lQuery,lParamList);

    if Result = 0 then
    begin
      if FSQLCaller.StoredProcedure.Active then
        aPostRunNo := FSQLCaller.StoredProcedure.Fields[0].AsInteger;
    end else
      FErrorMsg := FSQLCaller.ErrorMsg;
      
  finally
    lParamList.Free;
    Screen.Cursor := lCursor;
  end;
end;



{SS 09/02/2016 2017-R1: ABSEXCH-13159:Ability to post single items from Daybook without putting other transactions on Hold.
- Method to get excluded trasaction list during the posting.}

function TSQLDayBookPosting.ExecPostRunExclusionReport(aPostRunNo: Integer; aTransList : TStringList):Integer;
var
  lCursor : TCursor;
  lQuery: string;
  lParamList : TStringList;
  lRes : Integer;
  lFldOurRef,lFldReason : TField;
begin
  Result := -1;
  lCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  lParamList := TStringList.Create;
  try
    //Initialize stored procedure parameters.
    lParamList.Values['@iv_RunNo']     := IntToStr(aPostRunNo);
    
    lQuery :=  '[' + FCompanyCode + ']'+'.esp_PostRunExclusionReport ';

    Result :=  FSQLCaller.ExecStoredProcedure(lQuery,lParamList);
    
    if (Result = 0)  and FSQLCaller.StoredProcedure.Active then
    begin
      aTransList.Clear;

      lFldOurRef := FSQLCaller.StoredProcedure.FindField(cFldOurReference);
      lFldReason := FSQLCaller.StoredProcedure.FindField(cFldExclusionReason);

      if (not Assigned(lFldOurRef)) or (not Assigned(lFldReason)) then Exit;

      //Add excluded trasaction in to the list.
      with FSQLCaller,StoredProcedure do
      begin
        First;
        while not StoredProcedure.Eof do
        begin
          aTransList.Add(lFldOurRef.AsString +  '=' + lFldOurRef.AsString + ' ' + lFldReason.AsString);

          Next;
        end;
      end;  //with 
    end else
      FErrorMsg := FSQLCaller.ErrorMsg;

  finally
    lParamList.Free;
    Screen.Cursor := lCursor;
  end;                       
end;


{SS 09/02/2016 2017-R1: ABSEXCH-13159:Ability to post single items from Daybook without putting other transactions on Hold.
- Execute esp_PostRunSummaryReport stored procedure. }

function TSQLDayBookPosting.ExecPostRunSummaryReport(aPostRunNo: Integer;
  var aPostSummary: PostingSummaryArray): Integer;
var
  lCursor : TCursor;
  lQuery: string;
  lParamList : TStringList;
  lRes,TL,n : Integer;
  SalesOn :  Boolean;
  lFldBFwdValue,lFldRunValue,lFldCFwdValue : TField;
begin
  Result := -1;
  TL := 0;
  lCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  lParamList := TStringList.Create;
  try
    //Initialize stored procedure parameter.
    lParamList.Values['@iv_RunNo']     := IntToStr(aPostRunNo);
    
    lQuery :=  '[' + FCompanyCode + ']'+'.esp_PostRunSummaryReport ';

    Result :=  FSQLCaller.ExecStoredProcedure(lQuery,lParamList);
    if (Result = 0)  and (FSQLCaller.StoredProcedure.Active) and (not FSQLCaller.StoredProcedure.IsEmpty) then
    begin

      lFldBFwdValue := FSQLCaller.StoredProcedure.FindField(cFldBFwdValue);
      lFldRunValue  := FSQLCaller.StoredProcedure.FindField(cFldRunValue);
      lFldCFwdValue := FSQLCaller.StoredProcedure.FindField(cFldCFwdValue);


      For SalesOn:=BOff to BOn do
      Begin

        for n:=1 to MaxPostingAnalysisTypes do
        begin
          with aPostSummary[SalesOn,n] do
          begin
            DocumentType := PostingAnalysisDocTypes[SalesOn,n];
            if FSQLCaller.StoredProcedure.Locate(cFldPostAnalysisType,DocCodes[DocumentType],[]) then
            begin
              Totals[1] := lFldBFwdValue.Value;
              Totals[2] := lFldRunValue.Value;
              Totals[3] := lFldCFwdValue.Value;
            end;
          end; //With
        end;  //for n:=1 to MaxPostingAnalysisTypes do

      End; //For SalesOn:=BOff to BOn do
    end else
    begin
    { PL 13/02/2017 2017-R1 ABSEXCH-18331 :  added a msg to show the handled
      exception Which is created when execution of stored procedure throws error
      in SQL_DaybookPosting. }
      FErrorMsg := FSQLCaller.ErrorMsg;
      Result := -1;
    end;
    
  finally
    lParamList.Free;
    Screen.Cursor := lCursor;
  end;
end;


{SS 02/02/2017 2017-R1: ABSEXCH-13159:Ability to post single items from Daybook without putting other transactions on Hold.
- Execute esp_PostTransactionList stored procedure for single daybook posting.}

function TSQLDayBookPosting.ExecTransactionPost(aPostTransaction: Str255; var aPostRunNo : Integer; aPostingYear, aPeriod,
                                                 aSeparateControl: Integer; aLoginName: Str255):Integer;
var
  lCursor : TCursor;
  lQuery: string;
  lParamList : TStringList;
  lRes : Integer;
begin
  Result := -1;
  lCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  lParamList := TStringList.Create;
  
  try    
    //Initialize stored procedure parameters.
    lParamList.Values['@iv_PostOurRefs']     :=  aPostTransaction;
    lParamList.Values['@iv_PostingYear']     :=  IntToStr(aPostingYear);
    lParamList.Values['@iv_PostingPeriod']   :=  IntToStr(aPeriod);
    lParamList.Values['@iv_SeparateControl'] :=  IntToStr(aSeparateControl);
    lParamList.Values['@iv_LoginName']       :=  aLoginName;


    lQuery :=  '[' + FCompanyCode + ']'+'.esp_PostTransactionList ';

    Result :=  FSQLCaller.ExecStoredProcedure(lQuery,lParamList);

    // Return Posted run no.
    if Result = 0 then
    begin
      if FSQLCaller.StoredProcedure.Active then
        aPostRunNo := FSQLCaller.StoredProcedure.Fields[0].AsInteger;
    end else
      { PL 13/02/2017 2017-R1 ABSEXCH-18331 :  added a msg to show the handled
      exception Which is created when execution of stored procedure throws error
      in SQL_DaybookPosting.}
      FErrorMsg := FSQLCaller.ErrorMsg;    

  finally
    lParamList.Free;
    Screen.Cursor := lCursor;
  end;
end;


end.
