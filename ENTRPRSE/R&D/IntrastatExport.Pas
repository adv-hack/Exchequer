unit IntrastatExport;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses Dialogs,    Windows,  DB,       Graphics,   SysUtils,    Contnrs,   StrUtils,
     RpDevice,   GlobVar,  VarConst, BTSupU3,    SQLCallerU,  SQLRep_BaseReport,
     ReportU,    BtrvU2,   Scrtch2U, ExBtTh1u,   Classes,     IntrastatDataSearch,
     ExpVED2U;

type
  // Main report class fields added as the export does not inherited from reports

  TExportSettings = record
    ReportMode          : Byte;
    CMode               : Byte;    // Original Field from Report 1 - Dispatch, 2 - Arrival
    ExportChoice        : AnsiString;
    CompanyCode         : AnsiString;
    ConnectionString    : WideString;  //VA:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    SDate               : LongDate;
    Edate               : LongDate;
    VATChk              : Char;
    Summary             : Boolean;
    DirectoryName       : AnsiString;
    ParamDate           : String[4];
    LastCommod          : Str255;
    ThisCommod          : Str255;
    TotITem             : LongInt;
    ItemRun             : LongInt;
    AggCommod           : TAggSSD;
    RepTot              : AgedTyp;
    AggTot              : AgedTyp;
  end;


  TIntrastatExport = object(TThreadQueue)
  private
    ThisScrt            : Scratch2Ptr;
    ExportSettings      : TExportSettings;
    CSVArrivalFile      : AnsiString;
    CSVDispathFile      : AnsiString;
    UseStringList       : Boolean;
    TextFileData        : TextFile;
    DoesDataExist       : Boolean;

    // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
    fDataSearch         : TIntrastatDataSearch;

    function NothingToExportMessage : AnsiString;
    procedure NoRecordsFound;
    procedure Generate_CSVFile;
  public

    CSVLines : TStringList;

    Constructor Create(AOwner  :  TObject);

    Destructor  Destroy; Virtual;

    function ActivateCRepParam : Boolean;
    function ChkRepAbort  : Boolean;
    Function ConvertToShortDate(LDate  :  LongDate)  :  Str10;

    Procedure Process; Virtual;
    Procedure Finish;  Virtual;
  End;


Procedure AddISVATExportThread(RepMode          : Byte;
                               StartDate        : LongDate;
                               Enddate          : LongDate;
                               VATCheck         : Char;
                               Summary          : Boolean;
                               DirName          : AnsiString;
                               ParamDate        : AnsiString;
                               AOwner           : TObject);

implementation

uses SQLUtils,  RpDefine,    Comnu2,    ETDateU,    ETMiscU,   ETStrU,
     BTKeys1U,  CurrncyU,    SysU1,     ExThrd2U,   BTSupU1,   BTSupU2,
     SalTxl1U,  ComnUnit,    SQLRep_Config,         EntLoggerClass,
     ExWrap1U;


// =============================================================================
// This is the process called from RepInpEU

Procedure AddISVATExportThread(RepMode         : Byte;
                               StartDate       : LongDate;
                               Enddate         : LongDate;
                               VATCheck        : Char;
                               Summary         : Boolean;
                               DirName         : AnsiString;
                               ParamDate       : AnsiString;
                               AOwner          : TObject);
var
   IntExport       : ^TIntrastatExport;
   s_day, s_year   : String[2];
Begin
  If (Create_BackThread) then
  Begin
     New(IntExport,Create(AOwner));

    try
      With IntExport^ do
      Begin
        ExportSettings.ReportMode     := RepMode;

        if RepMode = 100 Then
        Begin
           ExportSettings.ExportChoice := 'D';
           ExportSettings.CMode        := 1;
        end
        else
           if RepMode = 200 Then
           Begin
              ExportSettings.ExportChoice := 'A';
              ExportSettings.CMode        := 2;
           End;

       ExportSettings.SDate          := StartDate;
       ExportSettings.Edate          := Enddate;
       ExportSettings.VATChk         := VATCheck;
       ExportSettings.Summary        := Summary;
       ExportSettings.DirectoryName  := DirName;

       s_day                         := Copy(ParamDate,1,2);
       s_year                        := Copy(ParamDate,5,6);
       ExportSettings.ParamDate      := s_day+s_year;

       CSVArrivalFile      := DirName +'\IntrastatArrivalsExp.CSV';
       CSVDispathFile      := DirName +'\IntrastatDispatchExp.CSV';

       // ABSEXCH-13459 An Error I/O 103 was coming up because the following if then clause was missing
       // 25/09/2012
       {$IFDEF EXSQL}
          if SQLUtils.UsingSQL then
            GetConnectionString(ExportSettings.CompanyCode, False, ExportSettings.ConnectionString);
       {$ENDIF}

       If (Create_BackThread) then
       Begin
         With BackThread do
           AddTask(IntExport, '');
       end
       else
       Begin
          Set_BackThreadFlip(BOff);
          Dispose(IntExport,Destroy);
       end;
     end; {with..}

    except
      Dispose(IntExport,Destroy);

    end; {try..}
  end; {If process got ok..}
end;

// =============================================================================
// This functions converts the date in the appropriate format required for the export
function TIntrastatExport.ConvertToShortDate(LDate  :  LongDate)  :  Str10;
var
  s_day   : String[2];
  s_month : String[2];
  s_year  : String[2];
Begin
   s_day   :=Copy(LDate,7,8);
   s_month :=Copy(LDate,5,6);
   s_year  :=Copy(LDate,3,4);
   ConvertToShortDate:=s_day+s_month+s_year;
end;

// =============================================================================

function TIntrastatExport.ActivateCRepParam : Boolean;
Begin
 result := ChkRepAbort;
End;

// =============================================================================

function TIntrastatExport.ChkRepAbort  :  Boolean;
Begin
  Result := False;
  If (Assigned(ThreadRec)) then
    Result:= Not ThreadRec^.THAbort;
end;

// =============================================================================

Procedure TIntrastatExport.Process;
Begin
  {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      ReOpen_LocalThreadfiles;
  {$ENDIF}

  if (UseStringList = False) Then
  Begin
    if (ExportSettings.ExportChoice = 'A') Then
       AssignFile(TextFileData, CSVArrivalFile)
    else
       if (ExportSettings.ExportChoice = 'D') Then
          AssignFile(TextFileData, CSVDispathFile);

    Rewrite(TextFileData);
  End;

  New(MTExLocal, Create(14));
  MTExLocal.Open_System(CustF, StockF);
  New(ThisScrt,Init(14,MTExLocal,BOff));
  InitStatusMemo(4);

  Try

    With ExportSettings do
    Begin
      LastCommod := NdxWeight;

      // This function is called from IntraDataSearch which is generic searching code
      // for the Intrastat reports

      TotItem := fDataSearch.Scan_4Items(ExportSettings.CMode, ExportSettings.SDate, ExportSettings.Edate,
                                         ExportSettings.VATChk, ExportSettings.Summary,
                                         ThisScrt, MTExLocal, ActivateCRepParam,
                                         False);
    end;

    Inherited Process;
    Generate_CSVFile;

  finally
    Dispose(ThisScrt,Done);
    ThisScrt := nil;

    if UseStringList Then
    Begin

      if ExportSettings.ExportChoice = 'A' Then
         CSVLines.SaveToFile(CSVArrivalFile)
      else
        if ExportSettings.ExportChoice = 'D' Then
           CSVLines.SaveToFile(CSVDispathFile)
    End;

  end; {try..}
end;

// =============================================================================

Procedure TIntrastatExport.Finish;
Begin
  Inherited Finish;
end;

// =============================================================================

Constructor TIntrastatExport.Create(AOwner  :  TObject);
Begin
  Inherited Create(AOwner);

  fTQNo:=3;
  fCanAbort:=BOff;

  UseStringList := False;

  fOwnMT:=False; {* This must be set if MTExLocal is created/destroyed by thread *}

  MTExLocal:=nil;

  if UseStringList Then
     CSVLines := TStringList.Create;

  // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
  fDataSearch := TIntrastatDataSearch.Create;
end;


// =============================================================================

Destructor TIntrastatExport.Destroy;
Begin

  if UseStringList Then
  Begin
     if (Assigned(CSVLines)) then
        FreeAndNil(CSVLines);
  End
  Else
     CloseFile(TextFileData);

  // CJS 2014-05-02 - ABSEXCH-15192 - Delivery charges on ESL and Intrastat reports
  if Assigned(fDataSearch) then
    FreeAndNil(fDataSearch);

  Inherited Destroy;
end;

// =============================================================================

procedure TIntrastatExport.Generate_CSVFile;
const
  RFnum    = ReportF; // Scratch file
  RKeyPath = RpK;     // Scratch file index
var
  LineCount       : LongInt;

  IncludeLine     : Boolean;
  TmpInclude      : Boolean;
  KeyChk          : Str255;
  KeyCS           : Str255;
  KeyS2           : Str255;
  KeyR            : Str255;
  KeyRef          : Str255;
  AbortPrint,
  Ok2Cont         : Boolean;
  ExpAbort        : Boolean;
  TmpStat         : Integer;
  NoDataMsg       : String[100];
  NetMassDecimal  : Double;

  procedure Write_AgentHeaderRecord;
  var
     AgentFlag      : String[8];
     AgentVAT       : String[9];
     AgentBranchID  : String[3];
     AgentName      : String[30];
     Comma          : String[1];
     VersionID      : String[5];
     Line           : String;
  begin
     AgentFlag      := '';     AgentFlag     := 'A'; // Always Set to A
     AgentVAT       := '';     AgentVAT      := Copy(MTExLocal^.LCust.VATRegNo, 1, 9); // States only to show 9
     AgentBranchID  := '';     AgentBranchID := 'Bra'; // Dont know what field
     AgentName      := '';     //AgentName     := CompanyName; // Dont know what field
     Comma          := '';     Comma         := ',';
     VersionID      := '';     VersionID     := 'CSV02';  // Always CSV02
     Line           := '';

     Line := AgentFlag + Comma + AgentVAT + Comma + AgentBranchID + Comma + AgentName + Comma;
     Line := Line + Comma + Comma + Comma + Comma;  // It states it requires four empty fields
     Line := Line + VersionID;

     if UseStringList Then
        CSVLines.Add(Line)
     else
        WriteLn(TextFileData, Line)

  end;

  procedure Write_TraderHeaderRecord;
  var
     TraderFlag      : String[8];
     TraderVAT       : String[9];
     TraderBranchID  : String[3];
     TraderName      : String[30];
     ReturnFlag      : String[30];
     TypeFlag        : String[1];
     CompletionDate  : String[6];
     Period          : String[4];
     Comma           : String[1];
     VersionID       : String[5];
     TmpVatReg       : String;
     Line            : String;
  begin
     TmpVatReg       := '';
     TraderFlag      := '';     TraderFlag     := 'T'; // Always Set to T

     TmpVatReg:=RetVATRegNo(Syss.UserVATReg);

     TraderVAT       := '';     TraderVAT      := Copy(TmpVatReg, 1, 9); // States only to show 9
     TraderBranchID  := '';     TraderBranchID := ''; // Dont know what field

     // ABSEXCH-13687. If an ampersand exists in the company name this must be change to an and
     // TraderName   := '';     TraderName     := Copy(Syss.UserName,1,30); //TraderName   := CompanyName; // Dont know what field

     TraderName      := '';     TraderName := Trim(StringReplace(VEDIFmtStr(Syss.UserName), ' & ', ' and ', [rfReplaceAll]));
     TraderName      := StringReplace(TraderName, '&', ' and ', [rfReplaceAll]);
     ReturnFlag      := '';

     if MTExLocal^.LId.LineNo > 0 Then     // Return Flag N = Nil Return X = Live Data
        ReturnFlag     := 'X'
     else
        ReturnFlag     := 'N';
     TypeFlag        := '';     TypeFlag       := ExportSettings.ExportChoice; // ‘A’ or ‘D’   Arrivals / Dispatches Flag
     CompletionDate  := '';     CompletionDate := ConvertToShortDate(Today); // Date file created ddmmyy
     Period          := '';     Period         := ExportSettings.ParamDate; // Period Number mmyy
     Comma           := '';     Comma          := ',';
     VersionID       := '';     VersionID      := 'CSV02';  // Always CSV02
     Line            := '';

     Line := TraderFlag + Comma + TraderVAT + Comma + TraderBranchID + Comma + UpperCase(TraderName) + Comma;
     Line := Line + ReturnFlag + Comma + TypeFlag + Comma + CompletionDate + Comma + Period + Comma;  // It states it requires four empty fields
     Line := Line + VersionID;

     if UseStringList Then
        CSVLines.Add(Line)
     else
        WriteLn(TextFileData, Line)
  end;

  procedure Write_LineRecord;
  var
    CommodityCode  : String[8];
    Value          : String[14];
    DeliveryTerms  : String[3];
    NatureOfTrans  : Byte;
    NetMass        : Double;
    NetMassCheck   : Double;
    SNetMassDecimal : String;
    e_suppunits    : Extended;
    d_uweight      : Double;
    SuppUnits      : String[11];
    CountryOfOrgin : String[2];
    ReferenceNum   : String[11];
    s_netmass      : String[11];
    Line           : string;
    comma          : string;
    Rnum           : Real;
    LineTot        : Real;
    LineAgg        : TAggSSD;
    TmpLineAgg     : TAggSSD;

  begin
    Blank(LineAgg,Sizeof(LineAgg));

    With MTExLocal^ do
    Begin
        With LId do
        Begin
          With LineAgg do
          Begin
             // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
             If (LId.SSDUseLine) then
                 CommodityCode := Copy(LId.SSDCommod, 1, 8)
             else
                 CommodityCode := Copy(LStock.CommodCode, 1, 8);
          End;

          Rnum:=DetLTotal(LId,BOn,BOff,0.0)*LineCnst(LId.Payment);  {* -ves not allowed, must use +ve only! *}
                                                            {* v2.30 Inv.OrigRates used so it is expressed in orig Co Rate *}
                                                            {v5.52. On UK Intrastat round up to nearest 1}

          // CJS 2014-05-14 - ABSEXCH-15343 - Delivery Charges on Intrastat CSV Export
          Rnum := Rnum + fDataSearch.CalculateDeliveryCharge(LId);

          LineTot:=ForceNearestWhole(Conv_VATCurr(Rnum,LInv.VATCRate[UseCoDayRate],
                                       XRate(LInv.OrigRates,BOff,LCust.Currency),LCust.Currency,LInv.UseORate),2);

          Value          := FloatToStr(LineTot);        // Value 1-14
          DeliveryTerms  := UpperCase (LInv.DelTerms);   // Delivery Terms 0 or 3
          NatureOfTrans  := LInv.TransNat;

          d_uweight      := 0.0;
          d_uweight      := LWeight;


          // Jira ABSEXCH-13438 - Net Mass was incorrect
          if (ExportSettings.ExportChoice = 'D') Then // Dispatches
          Begin
             If (d_uweight = 0.0) then {* EL: Subs stock record weight if line weight zero Exv6.01*}
                 d_uweight := LStock.SWeight;

                 {v5.52. On UK Intrastat round up to nearest 1}

                 {ABSEXCH-13549 The only issue was the rounding above 1 kg}

                 NetMassCheck := (Calc_IdQty(Qty,QtyMul,UsePack)*d_uweight);

                 NetMassDecimal := 0;
                 NetMassDecimal := Frac(NetMassCheck);

                 if (NetMassCheck) <= 1 Then
                    NetMass := ForceNearestWhole(Calc_IdQty(Qty,QtyMul,UsePack)*d_uweight,2)
                 else
                   if NetMassDecimal < 0.50 Then
                      NetMass   := Int(NetMassCheck)
                   else
                        NetMass := ForceNearestWhole(Calc_IdQty(Qty,QtyMul,UsePack)*d_uweight,2);

                 s_netmass := FloatToStr(NetMass);
          End
          Else
            if (ExportSettings.ExportChoice = 'A') Then // Arrivals
            Begin
               If (d_uweight = 0.0) then {* EL: Subs stock record weight if line weight zero Exv6.01*}
                   d_uweight := LStock.PWeight;

                 {v5.52. On UK Intrastat round up to nearest 1}

                 {ABSEXCH-13549 The only issue was the rounding above 1 kg}
                 NetMassCheck := (Calc_IdQty(Qty,QtyMul,UsePack)*d_uweight);

                 NetMassDecimal := 0;
                 NetMassDecimal := Frac(NetMassCheck);

                 if (NetMassCheck) <= 1 Then
                    NetMass   := ForceNearestWhole(Calc_IdQty(Qty,QtyMul,UsePack)*d_uweight,2)
                 else
                   if NetMassDecimal < 0.50 Then
                      NetMass   := Int(NetMassCheck)
                   else
                      NetMass   := ForceNearestWhole(Calc_IdQty(Qty,QtyMul,UsePack)*d_uweight,2);

                  s_netmass := FloatToStr(NetMass);
            End;

          // Jira ABSEXCH-13438 - Unit of Supplement was incorrect
          if (LStock.UnitSupp <> '') Then
          Begin
             e_suppunits := 0;
             e_suppunits := DivWChk((Qty*QtyMul),LStock.SuppSUnit);
             // ABSEXCH-13458 UnitSupp ie the description is no longer required by HMRC so line below has been altered
             // SuppUnits   := FloatToStr(e_suppunits) + ' ' + UpperCase (LStock.UnitSupp);
             SuppUnits   := FloatToStr(e_suppunits);
          End
          Else
             SuppUnits   := '0';

          CountryOfOrgin := Copy (LCust.VATRegNo,1,2);
          ReferenceNum   := Copy (LInv.OurRef,1,11);
          Line    := '';
          comma   := ',';

          Line := CommodityCode + comma + Value + comma + DeliveryTerms + comma + SETN(NatureOfTrans) + comma;
          Line := Line + s_netmass + comma + SuppUnits + comma + UpperCase(CountryOfOrgin) + comma + UpperCase(ReferenceNum);

          if UseStringList Then
             CSVLines.Add(Line)
          else
             WriteLn(TextFileData, Line)
        End;
    End;
  end;

begin
    // Before we deal with the data we need to initialise the flag
    DoesDataExist := False;

    with MTExLocal^ do
    begin
      // Set up the search key for the first relevant scratch file record
      KeyRef := FullNomKey(ThisScrt^.Process);
      KeyR   := KeyRef;

      Write_TraderHeaderRecord;

      // Loop through all the scratch file records
      LStatus := LFind_Rec(B_GetGEq, RFnum, RKeyPath, KeyR);

      While (LStatusOk) and (CheckKey(KeyRef, KeyR, Length(KeyRef), BOn)) and
            ((Not ThreadRec^.THAbort)) do
      Begin

        // Set the flag to show data has been found
        DoesDataExist := True;

        // Retrieve the actual record (the Scratch file system knows which table
        // its records relate to).
        ThisScrt^.Get_Scratch(LRepScr^);

        // LId will now hold the Transaction Line record.
        // Locate the related Transaction Header, Stock, and Customer/Supplier records.

        With LId do
        Begin
           If (LStock.StockCode<>StockCode) then
                  LGetMainRec(StockF,LId.StockCode);

           KeyCS:=FullNomKey(FolioRef);

           LStatus:=LFind_Rec(B_GetEq,InvF,InvFolioK,KeyCS);

           If (LInv.CustCode<>LCust.CustCode) then
               LGetMainRec(CustF,LInv.CustCode);

           // Do the output for this line

            Write_LineRecord;
        End;
        // Find the next scratch file record.

        LStatus:=LFind_Rec(B_GetNext,RFnum,RKeyPath,KeyR);
      end;
    end;

    // As we are in a threadQueue the follwowing had to be done to be able to
    // show a message on the screen to show that repor found no records so should
    // not be sent to HMRC

    if (DoesDataExist = False) Then
       TQThreadObj.runsync(NoRecordsFound);
End;

// =============================================================================

function TIntrastatExport.NothingToExportMessage : AnsiString;
var
   s_exporttype : String[100];
Begin
  if (ExportSettings.ExportChoice = 'A') Then
     s_exporttype := 'Arrivals'
  else
     if (ExportSettings.ExportChoice = 'D') Then
        s_exporttype := 'Dispatches';

  Result := 'No records were found to export for this Intrasat '+ s_exporttype +' report and period. Please DO NOT SEND THIS FILE!';
End;

// =============================================================================

procedure TIntrastatExport.NoRecordsFound;
Begin
   Showmessage(NothingToExportMessage);
End;

End.

