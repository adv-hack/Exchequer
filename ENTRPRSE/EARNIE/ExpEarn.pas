unit ExpEarn;

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses UseDllU,
     ComCtrls,  dialogs,
     ExtCtrls, Spin, {eFuncInt,}
     sysutils,CmnEarnie32,contnrs,classes,forms,logFileRtn, StdCtrls,
  Controls;
{$I ExDllBt.inc}
{$I ExchDll.inc}

type
  TExportType = (Classic,bonus,timesheet,Earnie,JobCard);

  str10 = string[10];
  str20 = string[20];
  str30 = string[30];
  str255 = string[255];


  //this is an object to hold all the data needed for export
  //not a record due to using tObjectList to hold the data and manipulate it
  TExportRec = class(TObject)
  public
    EmpCode       :  String[10]; {Employee Code}
    Rate          :  Integer;    {Rate}
    NoHour        :  Real;       {hundreds of hours }
    AccountGroup  :  string[25];
    AnalysisString:  String[100];
    Period        :  String[2];
    TypeOfEntry   :  Char;
    Factor        :  integer;
    Payment       :  Real;
    Deduction     :  Real;
    AmntAgstDec   :  Real;

    Value         :  array[1..3] of string;
  end;

  TfrmDoExport = class(TForm)
    Progress: TProgressBar;
    Shape3: TShape;
    Label1: TLabel;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
  private
    Function GetEmployee(EmployeeCode : Str255;var EmpRec : TBatchEmplRec) : Boolean;
    Function GetRecord(List : TList;var index : integer;var exportRec : TexportRec) : Boolean;
    Function GetTotalHoursForEmployee(RecList : TObjectList) : TObjectList;
  public
    procedure ExportToEarnie(FrTSH,toTSH : String;WkMnthNo : integer;ExportType : TExportType;EarnieYN : Boolean;filename,logfilename : String);  //assume we have the options now
  end;

var
  //global variable set if user clicks cancel when processing
  AbortExport : Boolean;

  function ByEmployeeCodeAndPayrollNo(Item1, Item2: Pointer): Integer; {Sort function for TList.sort}
  Function GetTransRecord(Const SearchMode : SmallInt;LockRec : WordBool;var rec :TBatchTHRec;var invLines : TBatchLinesRec;keyVal : String;KeyNo : integer) : Boolean;


implementation

{$R *.DFM}

const
  ExLenJob=10;ExLenStk=16;

{ ---------------------------------------------- }

//function to return an employee from the btrieve list
Function TfrmDoExport.GetEmployee(EmployeeCode : Str255;var EmpRec : TBatchEmplRec) : Boolean;
var
  SearchKey  : Pchar;
  res        : integer;
begin
  try
    result := false;
    SearchKey := StrAlloc(255);
    StrPCopy(SearchKey,EmployeeCode);
    //call the dll function ex_getJobEmployee
    res := ex_GetJobEmployee(@EmpRec,sizeof(EmpRec),SearchKey,0,B_getGEq,false);
    if res = 0 then
      result := true;
  except
    result := false;
  end
end;

//function to return a transaction record from btrieve list
Function  GetTransRecord(Const SearchMode : SmallInt;LockRec : WordBool;var rec :TBatchTHRec;var invLines : TBatchLinesRec;keyVal : String;KeyNo : integer) : Boolean;
var
  SearchKey  : PChar;
  Res        : SmallInt;
begin
  try
    try
      result := false;
      SearchKey := StrAlloc(255);
      fillchar(SearchKey^,sizeof(SearchKey),#0);

      StrPCopy(SearchKey,KeyVal);
      //call dll function
      Res := Ex_GETTRANS(@Rec,@InvLines,
                          Sizeof(Rec),
                          SizeOf(InvLines),
                          SearchKey,
                          KeyNo,
                          SearchMode,
                          LockRec);
      If Res = 0 then
      Begin
        result := true;
      end;
    except
      result := false;
    end

  finally
    StrDispose( SearchKey );
  end;
end;

//this function gets passed into a TList.Sort method
function ByEmployeeCodeAndPayrollNo(Item1, Item2: Pointer): Integer; {Sort function for TList.sort}
var
  Exp1,
  Exp2 : TExportRec;

  function LJVar(const s : string) : string;
  begin
    Result := Copy(s + StringOfChar(' ', 10), 1, 10);
  end;

begin
  try
    result := 0;
    if AbortExport = true then exit;

    Exp1 := TExportRec(Item1);
    Exp2 := TExportRec(Item2);

    if (LJVar(Exp1.EmpCode) + IntToStr(Exp1.Rate)) < (LJVar(Exp2.EmpCode) + IntToStr(Exp2.Rate)) then result := -1;
    if (LJVar(Exp1.EmpCode) + IntToStr(Exp1.Rate)) > (LJVar(Exp2.EmpCode) + IntToStr(Exp2.Rate)) then result := 1;
    if (LJVar(Exp1.EmpCode) + IntToStr(Exp1.Rate)) = (LJVar(Exp2.EmpCode) + IntToStr(Exp2.Rate)) then result := 0;

  except
    result := 0;  //equal dont sort
  end;
end;

//this function is used in a while loop (getTotalHoursForEmployee - see below) as an end of file test
Function TfrmDoExport.GetRecord(List : TList;var index : integer;var exportRec : TexportRec) : Boolean;
begin
  //the list passed in here contains TExportRecs
  result := false;
  try
    if index < List.count then
    begin
      exportRec := TExportRec(List[index]);
      //move the index on to the next potential item in the list
      inc(index);
      Result := true;
    end;
  except
    result := false;
  end;
end;


//function to accumulate all the hours for a employee
Function TfrmDoExport.GetTotalHoursForEmployee(RecList : TObjectList) : TObjectList;
var
  ExportRec : TExportRec;
  AccumExpRec : TExportRec;
  EmpCode : String;
  Rate    : Integer;
  cnt : integer;
  TotList : TObjectList;
  Eof : Boolean;

begin
  totList := TObjectList.create;
  try

    RecList.pack;

    cnt := 0;

    //check that there are more than one record
    Eof := not GetRecord(RecList,Cnt,ExportRec);
    if not eof then
    begin
      //create a record which will enable us to accumulate hours for an employee
      AccumExpRec := TExportRec.create;

      AccumExpRec.EmpCode := ExportRec.EmpCode;
      AccumExpRec.Rate    := ExportRec.Rate;
      AccumExprec.NoHour  := 0;

      EmpCode := AccumExpRec.EmpCode;
      Rate    := AccumExpRec.Rate;

      //remember when this procedure is called the list is sorted by employeecode and payroll number
      While not (Eof) do
      begin
        //looping for all records in the list for a certain employee code
        While (EmpCode = ExportRec.EmpCode) and  not(eof)do
        begin
          //looping for all records in the list for a certain payroll number
          While (EmpCode = ExportRec.EmpCode) and (Rate = ExportRec.Rate) and  not(eof)do
          begin
            AccumExprec.NoHour :=
              AccumExprec.NoHour + ExportRec.NoHour;

             //get the next export rec in the list
             eof := Not GetRecord(RecList,Cnt,ExportRec);
          end;
          //add this record to the list
          TotList.add(AccumExpRec);
          Rate := ExportRec.rate;

          //we have exited the loop due to a change of either employeecode or rate so
          //need to create a new accumulated record type
          //note the list when it is freed will free these objects as well
          if not(Eof) then
          begin
            AccumExpRec := TExportRec.create;
            AccumExpRec.EmpCode := ExportRec.EmpCode;
            AccumExpRec.Rate    := ExportRec.Rate;
            AccumExprec.NoHour  := 0;
          end;
        end;
        //set a new employee code
        EmpCode :=ExportRec.EmpCode;
      end;
    end;
    //assign the result to now accumulated list (i.e the hours for each employee/rate has been totalled
    Result := TotList;
  except
    //the problem with this function is it returns an object
    //so if something goes wrong what result will be returned? Nil i think
  end;
end;

procedure TfrmDoExport.ExportToEarnie(FrTSH,toTSH : String;WkMnthNo : integer;ExportType : TExportType;EarnieYN : Boolean;filename,logfilename : String);  //assume we have the options now
const
  TSH = 'TSH';
  TLen     = 10;
  PayIdent = 20;  {Payroll's constant field}
  TransactionNoKey = 0;

var
  Keyf          : String;
  tranRec       : TBatchTHRec;
  TranLinesRec  : TBatchLinesRec;
  status        : Boolean;
  tmpStr        : String;
  employeeRec   : TBatchEmplRec ;
  factor,rate   : integer;
  ExportList    : TObjectList;
  ExportRec     : TExportRec;
  log           : TextFile;
  Counter       : Integer;

  Procedure ExportDetailsToFile(Filename   : String;
                                ExportList : TObjectList;
                                exportType : TexportType;
                                WkMnthNo   : string);
  var
    i : integer;
    TxtFile : TextFile;

  begin
    Try
      AssignFile(TxtFile,Filename);
      System.Rewrite(txtFile);

      for i := 0 to ExportList.Count-1 do
      begin
        if AbortExport = true then exit;
        with TExportRec(ExportList[i]) do
        begin
          case ExportType of

            //yes bizzarely these choices all do the same thing
            earnie,classic,bonus :
            begin
            //PR 25/10/02 Field 2 should always be ' 1' in first line & '21' in second
              Write(TxtFile,EmpCode);
              Write(TxtFile,StringOfChar(' ',10-length(EmpCode)));
//              Writeln(TxtFile,(rate):2,noHour:8:0);
              Writeln(TxtFile,' 1',noHour:8:0);

              Write(TxtFile,EmpCode);
              Write(TxtFile,StringOfChar(' ',10-length(EmpCode)));
              Writeln(TxtFile,'21',((Rate)*100.00):8:0);
//              Writeln(TxtFile,IntToStr(rate + 20),((Rate)*100.00):8:0);

            end;

            //this is the new spec for intex 
            JobCard :
            begin
              Write(TxtFile,i);
              Write(TxtFile,',');
              Write(TxtFile,EmpCode);
              Write(TxtFile,StringOfChar(' ',25-length(EmpCode)));
              write(TxtFile,StringOfChar(' ',100)); {Analysis String}

              if Length(WkMnthNo) < 2 then wkMnthNo := '0' + WkMnthNo;
                Write(TxtFile,wkMnthNo); {Week month No}

              Write(txtFile,'H'); //Hard Coded to hours

              //values 1 to 3

              Write(TxtFile,StringOfChar(' ',10-length(Floattostr(nohour))));
              Write(TxtFile,FloattoStr((NoHour)));

              Write(TxtFile,StringOfChar(' ',10-length(Inttostr(rate))));
              Write(TxtFile,InttoStr(rate));

              Write(TxtFile,StringOfChar(' ',10-length(Inttostr(factor))));
              Writeln(TxtFile,InttoStr(factor));
            end;
          end;
        end;
      end;
    finally
      closeFile(TxtFile);
    end;
  end;{ExportDetailsToFile}

  Function  GetEmployeePayDetails(Currency : SmallInt;EmpCode,TimeRateCode : String;EarnieYn : Boolean;var factor,rate : integer) : boolean;
  const
    globalRate = '';
  Var
    JobRateRec : TBatchJobRateRec;

    function GetJobTimeRate(Currency : SmallInt;EmpCode,Ratecode : String; var JobRate : TBatchJobRateRec) : Boolean;var
      Status     : Integer;
    //function to return an employee time rate record
    begin
      try
        result := false;
        fillchar(JobRate,Sizeof(JobRate),0);

        JobRate.JEmpCode := EmpCode;
        JobRate.JRateCode := RateCode;
        JobRate.CostCurr := Currency;

        //call dll function
        status :=  EX_getjobtimerate(@JobRate,sizeof(JobRate),0,b_geteq,false);
        if status = 0 then result := true;
      except
        result := false;
      end;
    end;{GetJobTimeRate}

  Begin
    Result := false;
    Rate   := 0;
    try             //global rate returned if empcode parameter is blank
      if GetJobTimeRate(currency,globalRate,TimeRateCode,jobRateRec) then
      begin
        if EarnieYN = true then
        begin
          if (JobRateRec.PayRate In [1..99]) then
          begin
            Rate := JobRateRec.PayRate;
            Factor := JobRateRec.PayFactor;
            Result := true;
          end
        end
        else
        begin
          Rate := JobRateRec.PayRate;
          Factor := JobRateRec.PayFactor;
          Result := true;
        end;
      end;
    Except
      result := false;
    end;
  end;{GetEmployeePayDetails}

  function CheckWeek(DiscDays,WkMnthNo : Integer) : Boolean;
  begin
    try
      result := true;
      If (WkMnthNo<>0)then
      if (DiscDays <> WkMnthNo) then result := false;
    except
      result := false;
    end
  end;{CheckWeek}

begin {exporttoearnie}


  Progress.Min := 0;
  Progress.Max := 0;
  Progress.Position := 0;
  { Search Key = 1st transaction number (ourref)}
  KeyF:= FrTSH;
  {loop through all the matching transaction header records}
  status :=  GetTransRecord(B_GetGEq,false,tranRec,tranLinesRec,Keyf,TransactionNoKey); {Get first transaction record matching key}
  While ((Status=true) and (TranRec.TransDocHed=TSH) and (TranRec.OurRef>=FrTSH) and (TranRec.OurRef<=ToTSH) and (AbortExport = false))   do
  begin
    Progress.Max := Progress.Max + 1;
    { Get next Header record }
    Status:= GetTransRecord(B_GetNext,false,tranRec,tranLinesRec,Keyf,TransactionNoKey);
  end; {while status=0 of EInv..}


  ExportList := TObjectList.create; //to hold all the records for sorting/grouping later
  try
    //open the logfile;
    assignfile(log,logFileName);
    Rewrite(log);
    WriteHeader(log);


    { Search Key = 1st transaction number (ourref)}
    KeyF:= FrTSH;
    {loop through all the matching transaction header records}
    status :=  GetTransRecord(B_GetGEq,false,tranRec,tranLinesRec,Keyf,TransactionNoKey); {Get first transaction record matching key}
    While ((Status=true) and (TranRec.TransDocHed=TSH) and (TranRec.OurRef>=FrTSH) and (TranRec.OurRef<=ToTSH) and (AbortExport = false))   do
    begin
      Application.processMessages;
      With TranRec do {invoice record}
      begin
        TmpStr:=OurRef;
        {* Check for Week/Month No if entered *}
        if CheckWeek(discDays,WkMnthNo) then
        begin
          { get the employee}
          if GetEmployee(EmpCode,EmployeeRec) then
          begin
            If (length(EmployeeRec.PayNo) > 0) then
              begin
                //this needs to loop through all the transaction line records
                for Counter := 1 to TranRec.LineCount do begin
                  if GetEmployeePayDetails(TranRec.Currency,TranRec.EmpCode,tranLinesRec[Counter].StockCode,EarnieYN,factor,rate) then
                    begin

                      //at this stage all the checks are complete we can
                      //generate a new record to add the list

                      if Rate = 0 then WriteError(log,PayDetailsErr,OurRef)
                      else begin
                        ExportRec := TExportRec.create;
                        try
                          ExportRec.EmpCode := EmployeeRec.PayNo; //employeecode
                          ExportRec.Rate := Rate;
                          ExportRec.NoHour := TranLinesRec[Counter].Qty*100;
                          ExportRec.Factor := factor;
                          ExportList.Add(ExportRec);
                        except
                          WriteError(log,PayRateZero,OurRef);
                        end;{try}
                      end;{if}
                    end
                  else begin
                    WriteError(log,PayDetailsErr,OurRef);
                  end;
                end;
              end
            else begin
              WriteError(log,PayRollNoErr ,OurRef);
            end;
          end
          else
          begin
            WriteError(log,GetEmployeeErr,OurRef);
          end;
        end
        else
        begin
          //write error to log file
          WriteError(log,CheckWeekErr,OurRef);
        end;
      end; {with EInv do ..}
      { Get next Header record }
      Status:= GetTransRecord(B_GetNext,false,tranRec,tranLinesRec,Keyf,TransactionNoKey);

      Progress.Position := Progress.Position + 1;
    end; {while status=0 of EInv..}


    //global variable abort export is set if user clicks on abort button on main screen
    //at this stage the exportlist potentially has a number of transaction records for exporting

    if not (AbortExport) and (ExportList.Count > 0) then
    begin
      //sort the list by employee code and payroll no
      ExportList.Sort(ByEmployeeCodeAndPayrollNo);
      //accumulate the total hours for the employee
      ExportList := GetTotalHoursForEmployee(ExportList);
      //export the new list to file according to spec
      if ExportList.Count > 0 then  //make sure that we have some data after the totalling of hours (i.e. it didn't screw up)
        ExportDetailsToFile(Filename,ExportList,ExportType,inttostr(WkMnthNo));
    end;
  finally
    //free the export list
    ExportList.free;
    //finish of the log file with a footer
    WriteFooter(Log);
    //close the logfile
    CloseFile(log);
  end;
end;

procedure TfrmDoExport.btnCancelClick(Sender: TObject);
begin
  if abortExport = false then
  begin
    //if MessageDlg('Are you sure you wish to abort ?',mtinformation,[mbyes,mbno],0) = mryes then
    begin
      abortExport := true;
      btnCancel.enabled := false;
    end;
  end;
end;

end.
