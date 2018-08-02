unit AuditNoteReportDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, REPINP1U, ANIMATE, ExtCtrls, SBSPanel, StdCtrls, bkgroup,
  ComCtrls, SQLRep_BaseReport, GlobVar, Mask, TEditVal;

type
  //ordinal types for specifying the reports content
  TAuditNoteReportType = (anrCustomer = 0, anrSupplier = 1, anrTransaction = 2, anrStock = 3, anrJob = 4);
  //ordinal types for setting the reports 'sort mode'
  TSortType = (stCodeAndDate = 0, stDateAndCode = 1);
  //ordinal types for setting the report mode (is this a pervasive or SQL database report?)
  TReportMode = (rmPervasive = 0, rmSQL = 1);
  //the audit notes report object
  TAuditNoteReport = Object(TSQLRep_BaseReport)
  private
    //fields that configure the report
    FReportTypeString: Str255;
    FReportMode: TReportMode;
    FFromDate: TDate;
    FToDate: TDate;
    FSortType: TSortType;
    FReportType: TAuditNoteReportType;
    //set the columns on the report
    Procedure RepSetTabs; Virtual;
    //output a line onto the report
    Procedure PrintLine(Date, Time, OwnerCode, Note: String);
    //the method that prints the body of the report
    Procedure RepPrint(Sender : TObject); Virtual;
    //these methods determine what lines are displayed on the report using 'PrintLine'
    //SQL and pervasive have their own routines as they retrieve their data differently;
    //and pervasive needs more post-processing of the data
    Procedure RepPrintSQLReport;
    procedure RepPrintPervReport;
    //the method that prints the reports column-header titles
    Procedure RepPrintPageHeader; Virtual;
    //sets the reports title
    Function GetReportInput  :  Boolean; Virtual;
  public
    //some required logging method? specifies what is written to the SQL log to identify this report
    Function SQLLoggingArea : String; Virtual;
  end;

  {$WARNINGS OFF}
  //the audit notes report dialog
  TRepInpMsg2 = class(TRepInpMsg)
    grpFilter: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    cbDateFilterEnabled: TCheckBox;
    grpSort: TGroupBox;
    radSortDate: TRadioButton;
    radSortCode: TRadioButton;
    dpFromDate: TEditDate;
    dpToDate: TEditDate;
    procedure cbDateFilterEnabledClick(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
  private
    FFromDate: TDateTime;
    FToDate: TDateTime;
    FReportTypeString: Str255;
    FReportMode: TReportMode;
    FReportType: TAuditNoteReportType;
    FPageTitle: Str255;
    procedure AddReportToThread;
    { Private declarations }
  public
    //when the report dialog is created, a report type must be specified by supplying an ordinal value
    //see the 'type' definition for available options
    Constructor Create(ReportType: TAuditNoteReportType; Owner: TComponent);
    { Public declarations }
  end;
  {$WARNINGS ON}

implementation

Uses
  ExThrd2U, RPDefine, ReportU, SQLCallerU, DB, SQLRep_Config, SQLUtils, ExWrap1U, VarConst,
  AuditNotes, NoteSupU, Btrvu2, VarRec2U, SCRTCH1U, BtKeys1U, ExBtTh1u, ADOConnect;
{$R *.dfm}

{ TRepInpMsg2 }

//function for formatting a database date string to a standard date strings
Function FormatDateString(DateString: String): String;
var
  FormattedDate: String;
begin
  //format the string by rearranging characters and adding '/'
  FormattedDate := Copy(DateString, 7, 2) + '/' +
                   Copy(DateString, 5, 2) + '/' +
                   Copy(DateString, 1, 4);
  //return the new string
  Result := FormattedDate;
end;

//function for converting TDateTime into a database date string
Function FormatDate(DateObject: TDateTime; ReportMode: TReportMode): String;
var
  FormattedDate: String;
  Day,
  Month,
  Year: Word;
begin
  //get the date filter values
  if DateObject > 0 then
  begin
    //convert the TDateTime objects into a SQL date string
    DecodeDate(DateObject, Year, Month, Day);
    FormattedDate := IntToStr(Year);
    if Month <= 9 then
    begin
      FormattedDate := FormattedDate + '0';
    end;
    FormattedDate := FormattedDate + IntToStr(Month);
    if Day <= 9 then
    begin
      FormattedDate := FormattedDate + '0';
    end;
    FormattedDate := FormattedDate + IntToStr(Day);
  end
  else
  begin
    if ReportMode = rmSQL then
    begin
      FormattedDate := '''''';
    end;

    if ReportMode = rmPervasive then
    begin
      FormattedDate := '';
    end;
  end;

  Result := FormattedDate;
end;

constructor TRepInpMsg2.Create(ReportType: TAuditNoteReportType;
  Owner: TComponent);
begin
  //store the report type argument - used to determine what audit note report will be printed
  FReportType := ReportType;
  //store the report mode argument - determines if we are retrieving data from SQL or Pervasive
  if UsingSQL then
  begin
    FReportMode := rmSQL;
  end
  else
  begin
    FReportMode := rmPervasive;
  end; //end if

  //determine what title to give to the report by examining the type argument
  Case ReportType of
    anrCustomer: FPageTitle := 'Customer';
    anrSupplier: FPageTitle := 'Supplier';
    anrTransaction: FPageTitle := 'Transaction';
    anrStock: FPageTitle := 'Stock';
    anrJob: FPageTitle := 'Job';
  end; //end case

  FReportTypeString := FPageTitle;

  //construct the report title
  FPageTitle := FPageTitle + ' Audit Note Report';

  //call the parent create method
  Inherited Create(Owner);
end;

procedure TRepInpMsg2.cbDateFilterEnabledClick(Sender: TObject);
begin
  //toggle the availability of the date picker controls inline with the state of the
  //'enable filter' checkbox
  inherited;
  dpFromDate.Enabled := cbDateFilterEnabled.Checked;
  dpToDate.Enabled := cbDateFilterEnabled.Checked;
end;

procedure TRepInpMsg2.OkCP1BtnClick(Sender: TObject);
begin
  //if the user has inputted incorrect filter dates, then abort
  if dpFromDate.DateValue > dpToDate.DateValue then
  begin
    MessageDlg('Unable to generate report; Date filter "From" date is greater than the "To" date!', mtError, [mbOK], 0);
  end
  else
  begin
    //..otherwise proceed to generate the report
    AddReportToThread;
    inherited;
  end;//end if
end;

procedure TRepInpMsg2.ClsCP1BtnClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TRepInpMsg2.AddReportToThread;
var
  AuditNoteReport: ^TAuditNoteReport;
Begin

  //standard routine for adding a report to a thread
  If (Create_BackThread) then
  Begin
    //create an instance of the report using a deprecated instantiation method
    New(AuditNoteReport,Create(self.Owner));

    try
      //configure the report object
      With AuditNoteReport^ do
      Begin
        //pass filter values to the report object
        if cbDateFilterEnabled.Checked then
        begin
          self.FFromDate := StrToDate(FormatDateString(dpFromDate.DateValue));
          self.FToDate := StrToDate(FormatDateString(dpToDate.DateValue));
          AuditNoteReport^.FFromDate := self.FFromDate;
          AuditNoteReport^.FToDate := self.FToDate;
        end
        else
        begin
          AuditNoteReport^.FFromDate := 0;
          AuditNoteReport^.FToDate := 0;
        end;//end if

        //pass the report title and the report type
        AuditNoteReport^.FReportType := self.FReportType;
        AuditNoteReport^.thTitle := self.FPageTitle;
        AuditNoteReport^.FReportTypeString := self.FReportTypeString;

        AuditNoteReport^.FReportMode := self.FReportMode;

        //pass the 'sorting' option
        if radSortDate.Checked then
        begin
          AuditNoteReport^.FSortType := stDateAndCode;
        end
        else
        begin
          AuditNoteReport^.FSortType := stCodeAndDate;
        end;//end if

        //add the report to the thread object
        If (Create_BackThread) and (Start) then
        Begin
          With BackThread do
          begin
            AddTask(AuditNoteReport, FPageTitle);
          end//end with
        end
        else
        Begin
          Set_BackThreadFlip(False);
          Dispose(AuditNoteReport,Destroy);
        end;//end if
      end;//end with
    except
      Dispose(AuditNoteReport,Destroy);
    end;//end try
  end;//end if

end;

{ TAuditNoteReport }

function TAuditNoteReport.GetReportInput: Boolean;
begin
  //if there is a date range filter in place, modify the report title to display it
  if (FFromDate > 0) and (FToDate > 0) then
  begin
    ThTitle := ThTitle + ': ' + DateToStr(FFromDate) + ' To ' + DateToStr(FToDate);
  end;//end if

  //set the reports title
  RepTitle := ThTitle;
  PageTitle := RepTitle;
  Result := True;
end;

procedure TAuditNoteReport.PrintLine(Date, Time, OwnerCode, Note: String);
begin
  //print a line to the body of the report
  self.SendLine(#9 + Date +
                #9 + Time +
                #9 + OwnerCode +
                #9 + Note);
end;

procedure TAuditNoteReport.RepPrint(Sender: TObject);
begin
  //choose a data retrieval method for the report, based on the database being used by exchequer
  if UsingSQL then
  begin
    RepPrintSQLReport;
  end
  else
  begin
    RepPrintPervReport;
  end;//end if
end;

procedure TAuditNoteReport.RepPrintSQLReport;
var
  SqlCaller: TSQLCaller;
  SqlQuery: AnsiString;
  FromDate: String;
  ToDate: String;
  ConnectionString,
  lPassword: WideString;  //SS:28/10/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  Day,
  Month,
  Year: Word;
  CompanyCode: String;
  Date,
  Time,
  Code,
  Line: TStringField;
  FormattedDate: String;
  RecordCount: Integer;


begin
  //initialise the record counter
  ICount := 0;

  //convert the TDateTime objects into SQL date strings
  FromDate := FormatDate(FFromDate, FReportMode);
  ToDate := FormatDate(FToDate, FReportMode);

  //start the report logger
  oReportLogger.StartReport;
  
  //retrieve the active company code
  CompanyCode := GetCompanyCode(SetDrive);

  //attempt to retrieve the connection string
  //If (GetConnectionString(CompanyCode, False, ConnectionString) = 0) Then
  //SS:28/10/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  If (GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword) = 0) Then
  begin
    // Create a SQL Query object to use for executing the stored procedure
    //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
    SqlCaller := TSQLCaller.Create(GlobalAdoConnection);
    try
      SqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;
      // Build the SQL Query for calling the stored procedure
      SqlQuery := '[COMPANY].isp_Report_AuditHistoryNote_Online ' +
                  '@intOwnerType=' + IntToStr(Ord(FReportType)) + ', ' +
                  '@datStartDate=' + FromDate + ', ' +
                  '@datEndDate=' + ToDate + ', ' +
                  '@intOrderBy=' + IntToStr(Ord(FSortType));

      //execute the query
      oReportLogger.StartQuery(SqlQuery);
      SqlCaller.Select(SqlQuery, CompanyCode);
      oReportLogger.FinishQuery;

      try
        //if records were found; process the data
        if (SqlCaller.ErrorMsg = '') then
        begin
          if (SqlCaller.Records.RecordCount > 0) then
          begin
            //log the number of records found
            oReportLogger.QueryRowCount(SqlCaller.Records.RecordCount);
            //go to the first record
            SQLCaller.Records.First;

            //extract the values from the current SQL record
            Date := SqlCaller.Records.FieldByName('NoteDate') as TStringField;
            Time := SqlCaller.Records.FieldByName('NoteTime') as TStringField;
            Code := SqlCaller.Records.FieldByName('OwnerCode') as TStringField;
            Line := SqlCaller.Records.FieldByName('NoteLine') as TStringField;

            //loop through each record
            if SqlCaller.Records.RecordCount > 0 then
            begin
              //goto the next record, if it exists, and if the user has not clicked the abort button
              While (SQLCaller.Records.Eof = False) and (ThreadRec^.THAbort = False) do
              begin

                //format the SQL date into a normal string date
                FormattedDate := FormatDateString(Date.Value);

                //determine if we need a new page on the report
                If (RepFiler1.LinesLeft<=5) then
                begin
                  ThrowNewPage(5);
                end;//end if

                //increment the record counter
                Inc(ICount);

                //print a line to the body of the report
                PrintLine(FormattedDate, Time.Value, Code.Value, Line.Value);

                if ThreadRec^.THUpBar = 0 then
                begin
                  InitProgress(SqlCaller.Records.RecordCount);
                end;

                UpdateProgress(ICount);

                //go to the next record
                SQLCaller.Records.Next;
              end;//end while
              //print the footer of the report
              PrintEndPage;
            end;//end if
          end //end if
          else if (sqlCaller.ErrorMsg <> '') then
          begin
            WriteSQLErrorMsg (sqlCaller.ErrorMsg);
          end;
        end;
      finally
        sqlCaller.Close;
      end;//end try
    finally
      sqlCaller.Free;
    end;//end try
  end;//end if
end;

procedure TAuditNoteReport.RepPrintPervReport;
const
  NOTE_PREFIX = 'N';
  NOTE_TYPE = '3';
var
  NoteTime: String;
  FromDate: String;
  ToDate: String;
  PassedDateFilter: Boolean;
  PassedTraderFilter: Boolean;
  Status : Smallint;
  KeyString : Str255;
  RecordSubtype: Char;
  oScratch : ScratchFile;
  iIndex, iStatus, pCount : smallint;
  sCheck, sKey : Str255;
  iRecAddress : LongInt;
  DocumentNumber: String;
  FolioNumber: Integer;
  SearchKey: Str255;
  TraderRecordFilter: Char;
  FilterTraderRecords: Boolean;

  //inline function for extracting the 'time' value from a notes description line
  Function GetTimeFromNoteLine(NoteLine: String): String;
  var
    TimeString: String;
  begin
    //the time value is assumed to be the final 10 characters of the note line:
    //extract the last 10 characters from the noteline; this should contain the time value
    TimeString := Copy(NoteLine, (Length(NoteLine) - 7), 8);
    Result := TimeString;
  end;

begin
  RecordSubType := 'A';
  TraderRecordFilter := 'C';
  iIndex := 0;
  //reset progress bar
  ThreadRec^.PTotal := 0;
  ThreadRec^.PCount := 0;
  ThreadRec^.THUpBar := 0;
  InitProgress(-1);

  FilterTraderRecords := False;
  //initialise the pervasive 'scratch' file,
  //using the ordinal val of the report type as the process ID
  oScratch.Init(Ord(FReportType));
  //initialise the search key
  FillChar(sKey,sizeof(sKey),#0);

  //determine the record subtype value based on the report type
  Case FReportType of
    anrCustomer:
    begin
      RecordSubtype := 'A';
      TraderRecordFilter := 'C';
      FilterTraderRecords := True;
    end;
    anrSupplier:
    begin
      RecordSubtype := 'A';
      TraderRecordFilter := 'S';
      FilterTraderRecords := True;
    end;
    anrTransaction : RecordSubtype := 'D';
    anrStock       : RecordSubtype := 'S';
    anrJob         : RecordSubtype := 'J';
  end;//end case

  //construct a key string
  KeyString := PartNoteKey(NOTE_PREFIX, RecordSubtype, '');

  //initialise the record count
  ICount := 0;
  pCount := 0;
  //attempt to find a note record
  iStatus := MtExLocal.LFind_Rec(B_GetGEq, PwrdF, PWK, KeyString);
  try

    //convert the 'date filter' values into a useable format, target values of zero indicate that date filtering is disabled
    if (FToDate > 0) and (FFromDate > 0) then
    begin
      //convert TDateTime objects into pervasive date strings
      FromDate := FormatDate(FFromDate, FReportMode);
      ToDate := FormatDate(FToDate, FReportMode);
    end;//end if

    //while we are able to find records OK, and the user has not aborted..
    while (iStatus = 0) and                                     //if we fetched a record OK..
          (ThreadRec^.THAbort = False) and                      //and the user has not clicked the abort button..
          (MtExLocal.LPassword.RecPfix = NOTE_PREFIX) and       //and the fetched record has the correct 'prefix' ('N')..
          (MtExLocal.LPassword.SubType = RecordSubtype) do      //and the fetched record has the correct 'sub type' ('A')..
    begin
      Inc(ICount);
      //if the found note record is specifically an andit note record (NType = 3) then
      //process the record, otherwise find the next note record in the file
      if MtExLocal.LPassword.NotesRec.NType = NOTE_TYPE then
      begin
        //configure the progress bar; if the max-value is zero, then initialise the max-value
        if ThreadRec^.PTotal = 0 then
        begin
          //get the total number of records in the 'password' file, use the result as the max-value for the progress bar
          InitProgress(Used_RecsCId(MtExLocal.LocalF^[PWrdF], PWrdF, MtExLocal.ExClientId));
        end
        else
        begin
          //increment the value of the thread progress bar
          UpdateProgress(ICount);
        end;//end if

        //default the filter boolean value
        PassedDateFilter := True;
        PassedTraderFilter := True;

        //apply date filter, target values of zero indicate that date filtering is disabled
        if (FToDate > 0) and (FFromDate > 0) then
        begin
          //see if this audit note record fails the date filter
          if (MtExLocal.LPassword.NotesRec.NoteDate < FromDate) or
             (MtExLocal.LPassword.NotesRec.NoteDate > ToDate) then
          begin
            PassedDateFilter := False;
          end;//end if
        end;//end if

        //if we are compiling a list of trader records; filter by trader type
        //as we only want customers OR suppliers, not both.
        //to do this we need to retrieve the note records associated customer record,
        //and examine that records "CustSupp" value
        if  FilterTraderRecords then
        begin
          SearchKey := FullCustCode(MtExLocal.LPassword.NotesRec.NoteFolio);
          iStatus := MtExLocal.LFind_Rec(B_GetGEq, CustF, CustCodeK, SearchKey);
            if (iStatus <> 0) or (MtExLocal.LCust.CustSupp <> TraderRecordFilter) then
            begin
              PassedTraderFilter := False;
            end;//end if
        end;//end if

        //if this record has passed the date filter..
        if (PassedDateFilter = True) and (PassedTraderFilter = True) then
        begin
          With MtExLocal^, MtExLocal.LPassword.NotesRec do
          begin
            //get the record address of this record
            iStatus:=LGetPos(PwrdF, iRecAddress);
            //get the time substring from the note string
            NoteTime := copy(MtExLocal.LPassword.NotesRec.NoteLine, Length(Trim(MtExLocal.LPassword.NotesRec.NoteLine)) - 7, 8);
            //and store the records address in the scratch table
            //the record address is stored with an index value; this changes depending on the selected sorting option
            if FSortType = stCodeAndDate then
            begin
              oScratch.Add_Scratch(PwrdF, iIndex, iRecAddress, DocumentNumber + NoteDate + NoteTime, 'N/A');
            end
            else if FSortType = stDateAndCode then
            begin
              oScratch.Add_Scratch(PwrdF, iIndex, iRecAddress, NoteDate + NoteTime + DocumentNumber, 'N/A');
            end;//end if
          end;//end with
          Inc(pCount);
        end;//end if
      end;//end if
      //attempt to retrieve the next record
      iStatus := MtExLocal.LFind_Rec(B_GetNext, PwrdF, PWK, KeyString);
    end;//end while

    //Reset ICount
    ICount := 0;

    sCheck := fullNomKey(Ord(FReportType));
    sKey := sCheck;



    iStatus := Find_Rec(B_GetGEq, F[oScratch.SFnum], oScratch.SFnum, RecPtr[oScratch.SFnum]^, oScratch.SKeypath, sKey);

    if iStatus = 0 then
    begin
      
      //reset progress bar
      ThreadRec^.PTotal := 0;
      ThreadRec^.PCount := 0;
      ThreadRec^.THUpBar := 0;
      InitProgress(-1);
      //reconfigure the thread progressbar, now that we know exactly how many records we want to print on the report
      InitProgress(pCount);
    end;

    while (iStatus = 0) and (RepScr^.RecAddr <> 0) and (ThreadRec^.THAbort = False) do
    begin
      //determine if we need a new page on the report
      If (RepFiler1.LinesLeft<=5) then
      begin
        ThrowNewPage(5);
      end;//end if

      oScratch.Get_Scratch(RepScr^);
      
      //now we need to branch off and get the document number.. (e.g. SIN00034)
      with MtExLocal^,  Password.NotesRec do
      begin
        Case FReportType of
          anrCustomer,
          anrSupplier:
          begin
            DocumentNumber := NoteFolio;
          end;
          anrTransaction:
          begin
            MtExLocal.Open_System(InvF, InvF);
            SearchKey := FullNomKey(UnFullNomKey(NoteFolio));
            MtExLocal.LFind_Rec(B_GetGEq, InvF, InvFolioK, SearchKey);
            if LInv.FolioNum = UnFullNomKey(NoteFolio) then
            begin
              DocumentNumber := LInv.OurRef;
            end;
          end;
          anrStock:
          begin
            MtExLocal.Open_System(StockF, StockF);
            SearchKey := FullNomKey(UnFullNomKey(NoteFolio));
            MtExLocal.LFind_Rec(B_GetGEq, StockF, StkFolioK, SearchKey);
            if LStock.StockFolio = UnFullNomKey(NoteFolio) then
            begin
              DocumentNumber := LStock.StockCode;
            end;
          end;
          anrJob:
          begin
            MtExLocal.Open_System(JobF, JobF);
            SearchKey := FullNomKey(UnFullNomKey(NoteFolio));
            MtExLocal.LFind_Rec(B_GetGEq, JobF, JobFolioK, SearchKey);
            if LJobRec.JobFolio = UnFullNomKey(NoteFolio) then
            begin
              DocumentNumber := LJobRec.JobCode;
            end;
          end;
        end;//end case
      end;//end with

      //print a line to the body of the report
      with Password.NotesRec do
      begin
        PrintLine(FormatDateString(NoteDate), GetTimeFromNoteLine(NoteLine), DocumentNumber, NoteLine);
      end;//end with

      //increment the record count and the thread progress bar
      Inc(ICount);
      UpdateProgress(ICount);
      iStatus := Find_Rec(B_GetNext, F[oScratch.SFnum], oScratch.SFnum, RecPtr[oScratch.SFnum]^, oScratch.SKeypath, sKey);
    end; //end while

  Finally
    //destroy the scratch file object
    oScratch.Done;
  End;//end try

  //print the footer of the report
  PrintEndPage;
end;


procedure TAuditNoteReport.RepPrintPageHeader;
begin
  //print the column header on the report
  DefFont(0,[fsBold]);
  PrintLine('Date', 'Time', Trim(FReportTypeString) + ' Code', 'Audit Note');
  DefFont(0,[]);
end;

procedure TAuditNoteReport.RepSetTabs;
Begin // RepSetTabs
  //set up the columns of the report
  With RepFiler1 do
  Begin
    ClearTabs;
    SetTab (MarginLeft, pjLeft, 20, 4, 0, 0); //Date
    SetTab (NA, pjLeft, 35, 4, 0, 0); //Time
    SetTab (NA, pjLeft, 40, 4, 0, 0); //Owner Code
    SetTab (NA, pjLeft,80, 4, 0, 0); //Note
  end;//end with

  SetTabCount;
End; // RepSetTabs

function TAuditNoteReport.SQLLoggingArea: String;
begin
  //the string that is inserted in the SQL log file
  Result := 'AuditNotesReport';
end;

end.
