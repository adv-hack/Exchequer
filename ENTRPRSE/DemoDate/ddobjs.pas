unit ddobjs;

interface

uses
   VarConst, ddLog, Classes, oGenericBtrieveFile;

type

  TProgressFunc = procedure(const FName : string; RecNo, TotalRecs : longint; var Abort : Boolean) of Object;

  {TDataFileUpdater is the base class from which all other updaters are descended. It defines an
   abstract method UpdateRecord which each descendant will implement to update the appropriate
   date and year fields in the record. Calling the Execute method will call the
   base Execute method which steps through the appropriate file, calls UpdateRecord for each record,
   then saves the record. It also deals with error-logging and progress calls.}
   
  TDataFileUpdater = Class
  private
    FIncrementYears : Integer;
    FOnProgress : TProgressFunc;
    FLogFile : TLogFile;
    FDataPath : string;
    procedure LogIt(const s : string);
  protected
    FileNo : Integer;
    procedure UpdateDate(var s : ShortString);
    procedure UpdateYear(var y : Byte);
    procedure UpdateIndex(var s : ShortString; DatePos : Byte);
    procedure UpdateJulianDate(var ADate : Real);
    procedure UpdateRecord; virtual; abstract;
  public
    procedure Execute; virtual;
    function Test(const s : ShortString; DatePos : Byte = 0) : ShortString;
    function TestJulian(JDate : TDateTime) : TDateTime;
    property IncrementYears : Integer read FIncrementYears write FIncrementYears;
    property OnProgress : TProgressFunc read FOnProgress write FOnProgress;
    property DataPath : string read FDataPath write FDataPath;
    property LogFile : TLogFile read FLogFile write FLogFile;
  end;

  //CustSupp.dat - Customers & Suppliers
  TCustUpdater = Class(TDataFileUpdater)
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;

  //Document.dat - Transactions
  TInvUpdater = Class(TDataFileUpdater)
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;

  //Details.dat - Transaction Lines
  TIDetailUpdater = Class(TDataFileUpdater)
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;

  //Stock.dat - Stock records
  TStockUpdater = Class(TDataFileUpdater)
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;

  //History.dat - History records
  THistoryUpdater = Class(TDataFileUpdater)
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;

  //JobHead.dat - Job records
  TJobUpdater = Class(TDataFileUpdater)
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;

  //ExchQChk.dat (Password) - Notes, BacsCtrl, BankCtrl, CC/Dep records
  TPwrdUpdater = Class(TDataFileUpdater)
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;

  //ExStkChk.dat (Misc) - Discounts, Fifo, Serial records
  TMiscUpdater = Class(TDataFileUpdater)
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;

  //JobMisc.dat (JMisc) - Employees
  TJobMiscUpdater = Class(TDataFileUpdater)
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;

  //JobDet.dat (JDetl) - Job Actuals, Retentions, CIS
  TJobDetlUpdater = Class(TDataFileUpdater)
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;

  //MLoc.dat (MLoc) - Stock Locations
  TMLocUpdater = Class(TDataFileUpdater)
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;

  //System Setup
  TSysUpdater = Class(TDataFileUpdater)
  private
    function GetSysType(const sName : string; var sr : SysRecTypes): Boolean;
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;

  //Object to delete all History records with a year > 2008
  THistoryPruner = Class(TDataFileUpdater)
  public
    procedure Execute; override;
  end;

  THistoryChecker = Class(TDataFileUpdater)
  private
    FFirstPass : Boolean;
  public
    procedure Execute; override;
    property FirstPass : Boolean read FFirstPass write FFirstPass;
  end;

  TBtrieveTester = Class(TDataFileUpdater)
  private
    FBTFile : TGenericBtrieveFile;
    FFilename : string;
  public
    procedure Execute; override;
    property Filename : string read FFilename write FFilename;
  end;

  //MultiBuy.dat - Customers & Suppliers
  TMultiBuyUpdater = Class(TDataFileUpdater)
  protected
    procedure UpdateRecord; override;
  public
    constructor Create;
  end;


var
  FAddList : TStringList;


implementation

uses
  BtrvU2, SysUtils, DateUtils, VarRec2U, EtDateU, MultiBuyVar, SQLUtils;

{ TDataFileUpdater }

procedure TDataFileUpdater.Execute;
{Steps through data file, calls UpdateRecord method for each record then saves the record.}
var
  Res : Integer;
  KeyS : String[255];
  count, TotalRecs : longint;
  Abort : Boolean;
begin
  if not FileExists(Trim(FDataPath + Filenames[FileNo])) then Exit;
  //Find number of records in file
  Res := Open_File(F[FileNo], FDataPath + Filenames[FileNo], -2);
  if Res = 0 then
  begin
    TotalRecs := Used_Recs(F[FileNo], FileNo);
    Close_File(F[FileNo]);
  end;

  //Open file and step through
  Res := Open_File(F[FileNo], FDataPath + Filenames[FileNo], 0);

  if Res = 0 then
  begin
    Count := 1;
    Abort := False;
    Res := Find_Rec(B_StepFirst, F[FileNo], FileNo, RecPtr[FileNo]^, 0, KeyS);

    while (Res = 0) and not Abort do
    begin
      UpdateRecord;
      Res := Put_Rec(F[FileNo], FileNo, RecPtr[FileNo]^, 0);
      if Res <> 0 then
        LogIt('Btrieve error ' + IntToStr(Res) + ' writing record back to file ' + FDataPath + FileNames[FileNo]);

      if Assigned(FOnProgress) then
        FOnProgress(FileNames[FileNo], Count, TotalRecs, Abort);
      inc(Count);

      Res := Find_Rec(B_StepNext, F[FileNo], FileNo, RecPtr[FileNo]^, 0, KeyS);
    end;

    Close_File(F[FileNo]);
  end
  else
    LogIt('Unable to open file ' + QuotedStr(FDataPath + Filenames[FileNo]) + '. Btrieve Error ' + IntToStr(Res));
end;

procedure TDataFileUpdater.LogIt(const s: string);
begin
  if Assigned(FLogFile) then
    FLogFile.Add(s);
end;

function TDataFileUpdater.Test(const s: ShortString; DatePos : Byte = 0): ShortString;
begin
  Result := s;
  if DatePos = 0 then
    UpdateDate(Result)
  else
    UpdateIndex(Result, DatePos);
end;

function TDataFileUpdater.TestJulian(JDate: TDateTime): TDateTime;
var
  ADate : Real;
  yy, mm, dd : Word;
begin
  DecodeDate(JDate, yy, mm, dd);
  ADate := CalJul(dd, mm, yy);
  UpdateJulianDate(ADate);
  JulCal(ADate, dd, mm, yy);
  Result := EncodeDate(yy, mm, dd);
end;

procedure TDataFileUpdater.UpdateDate(var s: ShortString);
var
  dt : TDateTime;
  yy, mm, dd : Word;
  ys, ms, ds : string;

  function  AllNumbers(const s1 : string) : Boolean;
  var
    i : integer;
  begin
    Result := Length(s1) > 0;
    for i := 1 to Length(s1) do
      if not (s1[i] in ['0'..'9']) then
      begin
        Result := False;
        Break;
      end;
  end;

begin
  if (Length(s) = 8) and AllNumbers(s) then
  begin
    yy := StrToInt(Copy(s, 1, 4));
    mm := StrToInt(Copy(s, 5, 2));
    dd := StrToInt(Copy(s, 7, 2));

    if TryEncodeDate(yy, mm, dd, dt) then
    begin
      dt := IncYear(dt, FIncrementYears);

      DecodeDate(dt, yy, mm, dd);


      s := Format('%.4d%.2d%.2d', [yy, mm, dd]);
    end;
  end;
end;

procedure TDataFileUpdater.UpdateIndex(var s: ShortString; DatePos: Byte);
{For updating dates embedded in index strings. DatePos is the position in the
 string of the first char of the date. Date expected to always be 8 chars}
var
  TempS : ShortString;
begin
  TempS := Copy(s, DatePos, 8);
  UpdateDate(TempS);
  s := Copy(s, 1, DatePos - 1) + TempS + Copy(s, DatePos + 8, Length(s));
end;

procedure TDataFileUpdater.UpdateJulianDate(var ADate: Real);
var
  yy, mm, dd : Word;
  dt : TDateTime;
begin
  JulCal(ADate, dd, mm, yy);
  if TryEncodeDate(yy, mm, dd, dt) then
  begin
    dt := IncYear(dt, FIncrementYears);
    DecodeDate(dt, yy, mm, dd);
    ADate := CalJul(dd, mm, yy);
  end;
end;

procedure TDataFileUpdater.UpdateYear(var y: Byte);
begin
  Inc(y, FIncrementYears);
end;

{ TCustUpdater }

constructor TCustUpdater.Create;
begin
  inherited Create;
  FileNo := CustF;
end;

procedure TCustUpdater.UpdateRecord;
begin
  UpdateDate(Cust.CCDSDate);
  UpdateDate(Cust.CCDEDate);
  UpdateDate(Cust.LastUsed);
end;

{ TInvUpdater }

constructor TInvUpdater.Create;
begin
  inherited Create;
  FileNo := InvF;
end;

procedure TInvUpdater.UpdateRecord;
begin
  UpdateYear(Inv.AcYr);
  UpdateYear(Inv.UnYr);

  UpdateDate(Inv.DueDate);
  UpdateDate(Inv.TransDate);
  UpdateDate(Inv.VatPostDate);

  UpdateDate(Inv.PostDate);
  UpdateDate(Inv.UntilDate);
  UpdateDate(Inv.CISDate);
end;

{ TIDetailUpdater }

constructor TIDetailUpdater.Create;
begin
  inherited Create;
  FileNo := IDetailF;
end;

procedure TIDetailUpdater.UpdateRecord;
begin
  UpdateYear(ID.PYr);

  UpdateDate(ID.ReconDate);
  UpdateDate(ID.PDate);
end;

{ TStockUpdater }

constructor TStockUpdater.Create;
begin
  inherited Create;
  FileNo := StockF;
end;

procedure TStockUpdater.UpdateRecord;
begin
  UpdateDate(Stock.RODate);
  UpdateDate(Stock.LastUsed);
end;

{ THistoryUpdater }

constructor THistoryUpdater.Create;
begin
  inherited Create;
  FileNo := NHistF;
end;

procedure THistoryUpdater.UpdateRecord;
begin
  UpdateYear(NHist.Yr);
end;

{ TJobUpdater }

constructor TJobUpdater.Create;
begin
  inherited Create;
  FileNo := JobF;
end;

procedure TJobUpdater.UpdateRecord;
begin
  UpdateDate(JobRec.StartDate);
  UpdateDate(JobRec.EndDate);
  UpdateDate(JobRec.RevEDate);
end;

{ TPwrdUpdater }

constructor TPwrdUpdater.Create;
begin
  inherited Create;
  FileNo := PwrdF;
end;

procedure TPwrdUpdater.UpdateRecord;
var
  i : integer;
begin
  Case Password.RecPfix of
    MBankHed : begin
                 Case Password.SubType of
                   MBankSub : ;
                   MBankCtl : UpdateDate(Password.BankCRec.EntryDate);
                 end;
               end;

    MBACSCode : begin
                  Case Password.SubType of
                    MBACSCTL : begin
                                 UpdateDate(Password.BacsCRec.TagAsDate);
                                 UpdateDate(Password.BacsCRec.TagRunDate);
                                 UpdateYear(Password.BacsCRec.TagRunYr);
                               end;
                    MBACSUSR : UpdateDate(Password.BacsURec.StartDate);
                  end;
                end;
    NoteTCode : begin
                  UpdateDate(Password.NotesRec.NoteDate);
                  UpdateDate(Password.NotesRec.NoteAlarm);
                end;
    CostCCode : UpdateDate(Password.CostCtrRec.LastAccess);
{    PostUCode : if Password.SubType = 'V' then
                begin
                  UpdateJulianDate(Password.VSecureRec.UsrRelDate);
                  UpdateJulianDate(Password.VSecureRec.RelDate);
                  for i := 1 to 10 do
                    UpdateJulianDate(Password.VSecureRec.ModRelDate[i]);
                end;
 }
  end;

end;

{ TMiscUpdater }

constructor TMiscUpdater.Create;
begin
  inherited Create;
  FileNo := MiscF;
end;

procedure TMiscUpdater.UpdateRecord;
begin
  Case MiscRecs.RecMfix of
    CDDiscCode : begin  //Account discounts
                   UpdateDate(MiscRecs.CustDiscRec.CStartD);
                   UpdateDate(MiscRecs.CustDiscRec.CEndD);
                 end;
    QBDiscCode : begin //Quantity breaks
                   UpdateDate(MiscRecs.QtyDiscRec.QStartD);
                   UpdateDate(MiscRecs.QtyDiscRec.QEndD);
                 end;
    MFIFOCode  : begin //Fifo records
                   if MiscRecs.SubType = MSernSub then //SerialRec
                   begin
                     UpdateDate(MiscRecs.SerialRec.DateIn);
                     UpdateDate(MiscRecs.SerialRec.DateOut);
                     UpdateDate(MiscRecs.SerialRec.DateUseX);
                   end
                   else
                   if MiscRecs.SubType = 'S' then //Fifo
                   begin 
                     UpdateDate(MiscRecs.FIFORec.FIFODate);
                     UpdateIndex(MiscRecs.FIFORec.FIFOCode, 5);
                   end;
                 end;
    AllocTCode : begin //something to do with back to backs?
                   if MiscRecs.SubType = AllocB2BICode then
                   begin
                     UpdateDate(MiscRecs.B2BInpDefRec.B2BInpVal.WCompDate);
                     UpdateDate(MiscRecs.B2BInpDefRec.B2BInpVal.WStartDate);
                   end;
                 end;
    'W'        : begin //Letters/links
                   if MiscRecs.btLetterRec.Version = DocWord95 then
                     UpdateDate(MiscRecs.btLetterRec.LtrDate)
                   else
                     UpdateDate(MiscRecs.btLinkRec.LtrDate);
                 end;
    MBankHed   : begin
                   if MiscRecs.SubType = MBankSub then
                   begin
                     UpdateDate(MiscRecs.BankMRec.EntryDate);
                   end;
                 end;
    MBACSCode  : begin
                   if MiscRecs.SubType = MBACSALSub then
                   begin
                     UpdateDate(MiscRecs.AllocSRec.ariTransDate);
                     UpdateDate(MiscRecs.AllocSRec.ariDueDate);
                   end;
                 end;
  end;
end;

{ TJobMiscUpdater }

constructor TJobMiscUpdater.Create;
begin
  inherited Create;
  FileNo := JMiscF;
end;

procedure TJobMiscUpdater.UpdateRecord;
begin
  if (JobMisc.RecPfix = JARCode) and (JobMisc.SubType = JAECode) then
  begin
    UpdateDate(JobMisc.EmplRec.CertExpiry);
  end;
end;

{ TJobDetlUpdater }
constructor TJobDetlUpdater.Create;
begin
  inherited Create;
  FileNo := JDetlF;
end;

procedure TJobDetlUpdater.UpdateRecord;
begin
  if (JobDetl.RecPfix = JBRCode) and (JobDetl.SubType = JBECode) then
  begin //Job actuals
    UpdateDate(JobDetl.JobActual.JDate);
    UpdateIndex(JobDetl.JobActual.LedgerCode, 14);
    UpdateIndex(JobDetl.JobActual.RunKey, 15);
    UpdateYear(JobDetl.JobActual.ActYr);
  end
  else
  if (JobDetl.RecPfix = JARCode) and (JobDetl.SubType = JBPCode) then
  begin //Job Retentions
    UpdateDate(JobDetl.JobReten.RetDate);
    UpdateDate(JobDetl.JobReten.OrigDate);
    UpdateIndex(JobDetl.JobReten.RetenCode, 13);
    UpdateIndex(JobDetl.JobReten.SpareNDX3, 15);
  end
  else
  if (JobDetl.RecPfix = JATCode) and (JobDetl.SubType = JBSCode) then
  begin //CIS Vouchers
    UpdateIndex(JobDetl.JobCISV.CISvCode1, 7);
    UpdateIndex(JobDetl.JobCISV.CISvCode2, 1);
    UpdateIndex(JobDetl.JobCISV.CISvDateS, 1);
    UpdateIndex(JobDetl.JobCISV.CISVSDate, 7);
  end;
end;

{ TMLocUpdater }

constructor TMLocUpdater.Create;
begin
  inherited Create;
  FileNo := MLocF;
end;

procedure TMLocUpdater.UpdateRecord;
begin
  Case MLocCtrl.RecPfix of
    CostCCode  : if MLocCtrl.SubType = CSubCode[False] then
                    UpdateDate(MLocCtrl.MStkLoc.lsLastUsed);

    NoteTCode  : if (MLocCtrl.SubType in [NoteCCode,'1','2','3']) then
                    UpdateDate(MLocCtrl.SdbStkRec.sdLastUsed);

    MatchTCode : Case MLocCtrl.SubType of
                  MatchSCode : UpdateDate(MLocCtrl.CuStkRec.csLastDate);
                  PostLCode  : begin
                                 UpdateDate(MLocCtrl.TeleSRec.tcTDate);
                                 UpdateDate(MLocCtrl.TeleSRec.tcDelDate);
                               end;
                 end; //case

{    PassUCode  : if MLocCtrl.SubType = 'D' then
                 begin
                   UpdateDate(MLocCtrl.PassDefRec.PWExpDate);
                   UpdateYear(MLocCtrl.PassDefRec.UCYr);
                 end;
 }
    MBACSCode  : if MLocCtrl.SubType = MBACSCTL then
                 begin
                   UpdateDate(MLocCtrl.AllocCRec.arcTagRunDate);
                   UpdateDate(MLocCtrl.AllocCRec.arcTransDate);
                   UpdateYear(MLocCtrl.AllocCRec.arcTagRunYr);
                 end;

    BRRecCode  : if MLocCtrl.SubType = MSernSub then
                 begin
                   UpdateDate(MLocCtrl.brBinRec.brDateIn);
                   UpdateDate(MLocCtrl.brBinRec.brDateOut);
                   UpdateDate(MLocCtrl.brBinRec.brDateUseX);
                   UpdateIndex(MLocCtrl.brBinRec.brCode2, 19);
                 end;

    LteBankRCode
               : Case MLocCtrl.Subtype of
                   '1'  : begin  //Reconciliation Header
                            UpdateDate(MLocCtrl.BnkRHRec.brStatDate);
                            UpdateDate(MLocCtrl.BnkRHRec.brCreateDate);
                            UpdateDate(MLocCtrl.BnkRHRec.brReconDate);
                          end;
                   '2'  : begin //Reconciliation Line
                            UpdateDate(MLocCtrl.BnkRDRec.brLineDate);
                            UpdateDate(MLocCtrl.BnkRDRec.brTransDate);
                          end;
                   '3'  : begin //Bank Account Record
                            UpdateDate(MLocCtrl.BACSDbRec.brLastUseDate);
                          end;
                   '4'  : begin //Statement Header
                            UpdateDate(MLocCtrl.eBankHRec.ebStatDate);
                          end;
                   '5'  : begin //Statement Line
                            UpdateDate(MLocCtrl.eBankLRec.ebLineDate);
                          end;
                 end;


  end; //case
end;

{ TSysUpdater }

constructor TSysUpdater.Create;
begin
  inherited Create;
  FileNo := SysF;
end;

function TSysUpdater.GetSysType(const sName: string; var sr : SysRecTypes): Boolean;
var
  sr2 : SysRecTypes;
begin
  Result := False;
  for sr2 := SysR to CISR do
    if SysNames[sr2] = sName then
    begin
      sr := sr2;
      Result := True;
      Break;
    end;
end;

procedure TSysUpdater.UpdateRecord;
var
  sr : SysRecTypes;
  i : integer;
begin
  if GetSysType(Syss.IDCode, sr) then
  Case sr of
    SysR  :  begin
               UpdateYear(Syss.AuditYr);
               UpdateYear(Syss.CYr);
               UpdateDate(Syss.MonWk1);
               UpdateDate(Syss.TrigDate);
               UpdateDate(Syss.AuditDate);
{               UpdateJulianDate(Syss.RelDate);
               UpdateJulianDate(Syss.UsrRelDate);}
             end;
    VATR  :  begin
               UpdateDate(Syss.VATRates.LastECSalesDate);
               UpdateDate(Syss.VATRates.VATReturnDate);
               UpdateDate(Syss.VATRates.CurrPeriod);
             end;
{    ModRR :  begin
               for i := 1 to 25 do
                 UpdateJulianDate(Syss.Modules.RelDates[i]);
             end;}
    CISR  :  begin
               UpdateDate(Syss.CISRates.CISReturnDate);
               UpdateDate(Syss.CISRates.CurrPeriod);
               UpdateDate(Syss.CISRates.JCertExpiry);
             end;

  end;
end;

{ THistoryPruner }

procedure THistoryPruner.Execute;
{Steps through data file, calls UpdateRecord method for each record then saves the record.}
var
  Res, Res1 : Integer;
  KeyS : String[255];
  count, TotalRecs : longint;
  Abort : Boolean;
  NewHistF : FileVar;
begin
  //Find number of records in file
  FileNo := NHistF;
  Res := Open_File(F[FileNo], FDataPath + Filenames[FileNo], -2);
  if Res = 0 then
  begin
    TotalRecs := Used_Recs(F[FileNo], FileNo);
    Close_File(F[FileNo]);
  end;

  //Open file and step through
  Res := Open_File(F[FileNo], FDataPath + Filenames[FileNo], 0);

  if Res = 0 then
  begin
    Count := 1;
    Abort := False;
    Res := Find_Rec(B_StepFirst, F[FileNo], FileNo, RecPtr[FileNo]^, 0, KeyS);

    while (Res = 0) and not Abort do
    begin
      if NHist.Yr > 108 then
        Res := Delete_Rec(F[FileNo], FileNo, 0);
      if Res <> 0 then
        LogIt('Btrieve error ' + IntToStr(Res) + ' deleting record in ' + FDataPath + FileNames[FileNo]);

      if Assigned(FOnProgress) then
        if (Count div 100) * 100 = Count then
          FOnProgress(FileNames[FileNo], Count, TotalRecs, Abort);
      inc(Count);

      Res := Find_Rec(B_StepNext, F[FileNo], FileNo, RecPtr[FileNo]^, 0, KeyS);
    end;

    Close_File(F[FileNo]);

  end
  else
    LogIt('Unable to open file ' + FDataPath + Filenames[FileNo] + ' Btrieve Error ' + IntToStr(Res));
end;

procedure THistoryChecker.Execute;
{Steps through data file, calls UpdateRecord method for each record then saves the record.}
var
  Res, j : Integer;
  KeyS : String[255];
  count, TotalRecs : longint;
  Abort : Boolean;
  CurrentKey : String;

  function SameKeys(const CurrentK, NewK : string) : Boolean;
  begin
    Result := Copy(CurrentK, 1, 24) = Copy(NewK, 1, 24);
  end;

  function FormatCode(const s : string) : string;
  var
    i : integer;
  begin
    Result := '';
    i := 1;
    while i <= Length(s) do
    begin
      if (Ord(s[i]) > 31) and (Ord(s[i]) < 126) then
        Result := Result + s[i]
      else
        Result := Result + '#' + IntToStr(Ord(s[i]));
      inc(i);
    end;
    Result := QuotedStr(Result);
  end;

begin
  FileNo := NHistF;
  CurrentKey := '';
  //Find number of records in file
  Res := Open_File(F[FileNo], FDataPath + Filenames[FileNo], -2);
  if Res = 0 then
  begin
    TotalRecs := Used_Recs(F[FileNo], FileNo);
    Close_File(F[FileNo]);
  end;

  //Open file and step through
  Res := Open_File(F[FileNo], FDataPath + Filenames[FileNo], 0);

  if Res = 0 then
  begin
    Count := 1;
    Abort := False;
    if FirstPass then
    begin
      Res := Find_Rec(B_GetFirst, F[FileNo], FileNo, RecPtr[FileNo]^, 0, KeyS);

      while (Res = 0) and not Abort do
      begin
        if SameKeys(CurrentKey, KeyS) then
          FAddList.Add(KeyS);

        CurrentKey := KeyS;

        if Assigned(FOnProgress) then
          FOnProgress(FileNames[FileNo], Count, TotalRecs, Abort);
        inc(Count);

        Res := Find_Rec(B_GetNext, F[FileNo], FileNo, RecPtr[FileNo]^, 0, KeyS);
      end;
    end
    else
    begin
      for j := 0 to FAddList.Count - 1 do
      begin
        KeyS := FAddList[j];
        Res := Find_Rec(B_GetGEq, F[FileNo], FileNo, RecPtr[FileNo]^, 0, KeyS);
        if (Res = 0) and SameKeys(KeyS, FAddList[j])then
        begin
          LogIt('Duplicate Key: ' + FormatCode(Copy(KeyS, 1, 24)));
          LogIt('Code = ' + FormatCode(NHist.Code));
          LogIt(Format ('Class = %d, Year = %d, Period = %d, Currency = %d', [Ord(NHist.ExCLass),
                                                                                             NHist.Yr,
                                                                                             NHist.Pr,
                                                                                             NHist.Cr]));
          LogIt(Format('Sales = %8.2f, Purch = %8.2f, Budget = %8.2f, Cleared = %8.2f', [NHist.Sales,
                                                                                         NHist.Purchases,
                                                                                         NHist.Budget,
                                                                                         NHist.Cleared]));

          Res := Find_Rec(B_GetNext, F[FileNo], FileNo, RecPtr[FileNo]^, 0, KeyS);
          inc(Count);
          LogIt('  ');
          LogIt('Code = ' + FormatCode(NHist.Code));
          LogIt(Format ('Class = %d, Year = %d, Period = %d, Currency = %d', [Ord(NHist.ExCLass),
                                                                                             NHist.Yr,
                                                                                             NHist.Pr,
                                                                                             NHist.Cr]));
          LogIt(Format('Sales = %8.2f, Purch = %8.2f, Budget = %8.2f, Cleared = %8.2f', [NHist.Sales,
                                                                                         NHist.Purchases,
                                                                                         NHist.Budget,
                                                                                         NHist.Cleared]));
          LogIt('=================================');
          LogIt('    ');
        end;
      end;
      Close_File(F[FileNo]);
    end;


  end
  else
    LogIt('Unable to open file ' + FDataPath + Filenames[FileNo] + ' Btrieve Error ' + IntToStr(Res));
end;


{ TBtrieveTester }

procedure TBtrieveTester.Execute;
var
  Res : Integer;
  TotalRecs, Count : longint;
  Abort : Boolean;
begin
  Count := 0;
  FBTFile := TGenericBtrieveFile.Create;
  Abort := False;
  Try
    Res := FBTFile.OpenFile(FDataPath + 'Trans\History.dat', False, 'V600 ');
    if Res = 0 then
    Try
      TotalRecs := FBTFile.GetRecordCount;
      Res := FBTFile.GetFirst;

      while (Res = 0) and not Abort do
      begin
        inc(Count);
        if Assigned(FOnProgress) then
          FOnProgress(FDataPath + 'Trans\History.dat', Count, TotalRecs, Abort);

        Res := FBTFile.GetNext;
      end;
    Finally
      FBTFile.CloseFile;
    End;
  Finally
    FBTFile.Free;
  End;
end;

{ TMultiBuyUpdater }

constructor TMultiBuyUpdater.Create;
begin
  inherited Create;
  FileNo := MultiBuyF;
end;

procedure TMultiBuyUpdater.UpdateRecord;
begin
  UpdateDate(MultiBuyDiscount.mbdStartDate);
  UpdateDate(MultiBuyDiscount.mbdEndDate);
end;

end.
