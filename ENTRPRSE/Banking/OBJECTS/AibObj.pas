unit AibObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$IFDEF BBM}
  {$H-}
{$ENDIF}

uses
  CustAbsU, ExpObj, Aib01, AibOpts, {$IFDEF EX600}Enterprise04_TLB{$ELSE}Enterprise01_TLB{$ENDIF}, ComObj, SecCodes;

type
     TAibEftObj = Class(TExportObject)
       protected
        {AIB files have headers & trailers - we'll populate
        these in the create method of the object, apart from
        User trailer which has sums & counts to include.  That can
        be done in the close file method.  Headers are written to file
        in the CreateOutFile method}
         VolHeader   : TAIBVolHeaderRec;
         FileHeader  : TAIBFileHeaderRec;
         UserHeader  : TAIBUserHeaderRec;
         UserTrailer : TAIBUserTrailerRec;
         FToolkit : IToolkit;
         function GetVolID(const EventData : TAbsEnterpriseSystem) : string;
         function GetFileNo : string;
         function ConvertToOutCurr(Value : Double) : Double;
         {$IFDEF BBM}
         function GetIniFileName : Ansistring; virtual;
         {$ELSE}
         function GetIniFileName : string; virtual;
         {$ENDIF}
       public
         EFTIniFile : string;
         EFTRec : TEftOptionsRec;
         procedure ReadIniFile(const EventData : TAbsEnterpriseSystem); virtual;
         procedure SetHeader(const EventData : TAbsEnterpriseSystem); virtual;
         constructor Create(const EventData : TAbsEnterpriseSystem);
         destructor Destroy; override;
         function CreateOutFile(const AFileName : string;
                                const EventData :
                                TAbsEnterpriseSystem) : integer; override;
         function CreateOutFileOnly(const AFileName : string;
                                    const EventData : TAbsEnterpriseSystem) : integer;
         function CloseOutFile : integer; override;
         function WriteRec(const EventData : TAbsEnterpriseSystem;
                            Mode : word) : Boolean; override;
         function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
                                      override;

     end;

var
  AibEftObj : TAibEftObj;



implementation

uses
  SysUtils, Dialogs, Forms{$IFNDEF Multibacs}, ActiveX{$ENDIF};

const
  {$IFDEF EX600}
  sTkClassName = 'Enterprise04.Toolkit';
  {$ELSE}
  sTkClassName = 'Enterprise01.Toolkit';
  {$ENDIF}

function TAibEftObj.ConvertToOutCurr(Value : Double) : Double;
begin
  if EftRec.OutCurr = 1 then
    Result := Value
  else
  begin
    Result := FToolkit.Functions.entConvertAmount(Value, 1, EftRec.OutCurr, 0);
    Result := FToolkit.Functions.entRound(Result, 2);
  end;
end;



constructor TAibEftObj.Create(const EventData : TAbsEnterpriseSystem);
var
  TempString, DateString : String;
  TempInt : longint;
  IsHobs : Boolean;
  a, b, c : integer;
  Res : longint;
begin
  inherited Create;

(*  IsHobs := False;

  if ClassName = 'TBankIrExportObject' then
     EFTIniFile := DefaultBIEFTIniFile
  else
  if ClassName = 'TAibEftObj' then
  begin
     EFTIniFile := DefaultAIBEFTIniFile;
     {$IFNDEF MultiBacs}
     CoInitialize(nil);
     {$ENDIF}
  end
  else
  if ClassName = 'TUlsterBankExportObject' then
     EFTIniFile := DefaultUlsterBankIniFile
  else
  if ClassName = 'TBankScotHobsExportObject' then
    IsHobs := True;

  if not IsHobs then
  begin
    EFTIniFile := CheckPath(EventData.Setup.ssDataPath) + EFTIniFile;
    if not GetEftOptions(EFTIniFile, EftRec, False) then
      Failed := flUserID;
  end
  else
    EftRec.OutCurr := 1;

  if EftRec.OutCurr <> 1 then
  begin
    FToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
    if FToolkit.Enterprise.enCurrencyVersion <> enProfessional then
    begin
      if Assigned(FToolkit) then
      begin
        EncodeOpCode(97, a, b, c);
        FToolkit.Configuration.SetDebugMode(a, b, c);
        FToolkit.Configuration.DataDirectory := EventData.Setup.ssDataPath;
        Res := FToolkit.OpenToolkit;
        if Res <> 0 then
          ShowMessage('Error opening COM Toolkit:'#13#13 +
                       QuotedStr(FToolkit.LastErrorString));
      end
      else
        ShowMessage('Unable to create COM Toolkit');
    end
    else
      EftRec.OutCurr := 1;
  end;             *)


  //Moved to SetHeader

(*  with EventData do
  begin
    FillChar(VolHeader, SizeOf(TAIBVolHeaderRec), ' ');
    FillChar(FileHeader, SizeOf(TAIBFileHeaderRec), ' ');
    FillChar(UserHeader, SizeOf(TAIBUserHeaderRec), ' ');
    FillChar(UserTrailer, SizeOf(TAIBUserTrailerRec), ' ');
    GetEventData(EventData);
    with VolHeader do
    begin
      Str2_Char('VOL', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      Version     := '.';
    end;

    with FileHeader do
    begin
      Str2_Char('HDR', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      FileID1     := 'A';
{Authorized User ID as above}
      Str2_Char(EftRec.UserID, FileID2, SizeOf(FileID2));
      FileID3     := 'S';
      TempInt := JulianDate(ProcControl.PDate);
      if TempInt > 0 then
        DateString := ' ' + ZerosAtFront(TempInt, 5)
      else
      begin
        ShowMessage('Invalid process date');
        Failed := flDate;
      end;
{      Str2_Char(DateString, CreateDate, SizeOf(CreateDate));}
      Delimiter   := '.';
    end;

    with UserHeader do
    begin
      Str2_Char('UHL', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      Str2_Char(DateString, ProcDate, SizeOf(ProcDate));

      Str2_Char(ZerosAtFront(0,SizeOf(ZFiller1)),ZFiller1,SizeOf(ZFiller1));
      Str2_Char('93', ReceiverID, SizeOf(ReceiverID));

{For currency assume IEP unless Euro is specified}
      if (Ord(ProcControl.PayCurr[1]) = 128) or {euro symbol we hope}
         (ProcControl.PayCurr = 'EUR') then
        TempString := '01'
      else
        TempString := '00';
{Check if we have multi-currency or euro version - if not then must be iep}
      if CurrencyVer = 0 then
        TempString := '00';
      Str2_Char(TempString, Currency, SizeOf(Currency));
      Str2_Char('000000', Reserved1, SizeOf(Reserved1));
      Str2_Char('1 DAILY  ', WorkCode, SizeOf(WorkCode));
      {can't set fileno here as i'm using payrun and that doesn't seem to
      be available yet - it appears to be 0 at the moment, yet when i do
      geteventdata again below in writerec it is the correct number}
{Leave userDef as spaces for the moment}
      Delimiter   := '.';
    end;

    with UserTrailer do
    begin
      Str2_Char('UTL', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      Delimiter   := '.';
    end;
  end; {with EventData} *)
end; {create}





function TAibEftObj.WriteRec(const EventData : TAbsEnterpriseSystem;
                             Mode : Word) : Boolean;
var
  OutRec : TAIBDataRec;
  TempStr : Str255;
  pence : longint;
  OutString : string;
  Target : TAbsCustomer;
begin
  GetEventData(EventData);

  FillChar(OutRec, SizeOf(OutRec), 32);
  with EventData, OutRec do
  begin
    if IsReceipt then
      Target := Customer
    else
      Target := Supplier;

    Case Mode of

   wrContra : begin
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(DestAcc)), DestAcc, SizeOf(DestAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(DestSort)), DestSort, SizeOf(DestSort));
               AccType := '0';
               if IsReceipt then
                 TranCode := '99'
               else
                 TranCode := '17';
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(CompAcc)), CompAcc, SizeOf(CompAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(CompSort)), CompSort, SizeOf(CompSort));
               TempStr := '0000';
               Str2_Char(TempStr, Reserved1, SizeOf(Reserved1));
               TempStr := ZerosAtFront(TotalPenceWritten, SizeOf(AmountP));
               Str2_Char(TempStr, AmountP, SizeOf(AmountP));
               TempStr := 'EFT ' + IntToStr(ProcControl.PayRun);
               Str2_Char(TempStr, CompName, SizeOf(CompName));
               TempStr := 'CONTRA';
               Str2_Char(TempStr, CompRef, SizeOf(CompRef));
               Str2_Char(Bacs_Safe(Setup.ssUserName), DestName, SizeOf(DestName));
              end;
  wrPayLine : begin
               Str2_Char(Target.acBankSort, DestSort, SizeOf(DestSort));
               Str2_Char(Target.acBankAcc, DestAcc, SizeOf(DestAcc));
               AccType := '0';
               if IsReceipt then
                 TempStr := DirectDebitCode(Target.acDirDebMode)
               else {Payment}
                 TempStr := '99';
               Str2_Char(TempStr, TranCode, SizeOf(TranCode));
               Str2_Char(MakeDigits(UserBankAcc, SizeOf(CompAcc)), CompAcc, SizeOf(CompAcc));
               Str2_Char(MakeDigits(UserBankSort, SizeOf(CompSort)), CompSort, SizeOf(CompSort));
               TempStr := '0000';
               Str2_Char(TempStr, Reserved1, SizeOf(Reserved1));
               Pence := Pennies(ConvertToOutCurr(ProcControl.Amount));
               TempStr := zerosAtFront(Pence, SizeOf(AmountP));
               Str2_Char(TempStr, AmountP, SizeOf(AmountP));
               Str2_Char(Bacs_Safe(Setup.ssUserName), CompName, SizeOf(CompName));

               Str2_Char(Bacs_Safe(Target.acCompany), DestName, SizeOf(DestName));
               if not IsBlank(Bacs_Safe(Target.acBankRef)) then
                 TempStr := Bacs_Safe(Target.acBankRef)
               else
                 TempStr := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);

               Str2_Char(TempStr, CompRef, SizeOf(CompRef));
               TotalPenceWritten := TotalPenceWritten + Pence;
               inc(TransactionsWritten);
             end; {not contra}
    end; {case}


  end; {with}
  {write record here}
  with OutRec do
  begin
    OutString :=  DESTSort +
                  DESTAcc   +
                  AccType +
                  TranCode  +
                  CompSort  +
                  CompAcc   +
                  Reserved1    +
                  AmountP   +
                  CompName  +
                  CompRef   +
                  DestName;
  end;
  Result := WriteThisRec(OutString);
end;



function TAibEftObj.CloseOutFile : integer;
var
  TempStr, OutString : string;
begin
{$I-}
  with UserTrailer do
  begin
   if IsReceipt then
   begin
    TempStr := zerosAtFront(TotalPenceWritten, SizeOf(TotalDr));
    Str2_Char(TempStr, TotalDr, SizeOf(TotalDr));
    TempStr := zerosAtFront(TransactionsWritten, SizeOf(CountDr));
    Str2_Char(TempStr, CountDr, SizeOf(CountDr));
    TempStr := zerosAtFront(TotalPenceWritten, SizeOf(TotalCr));
    Str2_Char(TempStr, TotalCr, SizeOf(TotalCr));
    TempStr := zerosAtFront(1, SizeOf(CountCr));
    Str2_Char(TempStr, CountCr, SizeOf(CountCr));
   end
   else {payment}
   begin
    TempStr := zerosAtFront(TotalPenceWritten, SizeOf(TotalDr));
    Str2_Char(TempStr, TotalDr, SizeOf(TotalDr));
    TempStr := zerosAtFront(1, SizeOf(CountDr));
    Str2_Char(TempStr, CountDr, SizeOf(CountDr));
    TempStr := zerosAtFront(TotalPenceWritten, SizeOf(TotalCr));
    Str2_Char(TempStr, TotalCr, SizeOf(TotalCr));
    TempStr := zerosAtFront(TransactionsWritten, SizeOf(CountCr));
    Str2_Char(TempStr, CountCr, SizeOf(CountCr));
   end;

    OutString := LabelID +
                 LabelNo +
                 TotalDr +
                 TotalCr +
                 CountDr +
                 CountCr +
                 Reserved +
                 Delimiter;
  end;

  WriteThisRec(OutString);


  CloseFile(OutFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to close file ' + OutFileName, '');
{$I+}
end;

function TAibEftObj.GetVolID(const EventData : TAbsEnterpriseSystem) : string;
var
  s : string;
begin
  GetEventData(EventData);
  s := GetFileNo;
  Result := Copy('000000', 1, 6 - Length(s)) + s;
end;

function TAibEftObj.GetFileNo : string;
begin
  Result := ZerosAtFront(ProcControl.PayRun mod (MaxFileNo + 1), 3);
end;

function TAibEftObj.CreateOutFile(const AFileName : string;
                                  const EventData : TAbsEnterpriseSystem) : integer;
var
  OutString : string;
begin

  Result := inherited CreateOutFile(AFileName, EventData);

  ReadIniFile(EventData);
  SetHeader(EventData);

  with UserHeader do
    Str2_Char(GetFileNo, FileNo, SizeOf(FileNo));

  with VolHeader do
  begin
    Str2_Char(GetVolID(EventData), VolID, SizeOf(VolID));
    Str2_Char(EFTRec.UserID, OwnerID02, SizeOf(OwnerID02));
  end;


  if Result = 0 then
  begin
  {file should now be open for writing so we can write headers}
{$I-}
   with VolHeader do
   begin
     OutString :=  LabelID    +
                   LabelNo    +
                   VolID      +
                   Access     +
                   Reserved1  +
                   OwnerID01  +
                   OwnerID02  +
                   OwnerID03  +
                   Reserved2  +
                   NA1        +
                   Reserved3  +
                   PhysLength +
                   NA2        +
                   Reserved4  +
                   Version;

     WriteLn(OutFile, OutString);
   end; {with VolHeader}

   with FileHeader do
   begin
     OutString :=  LabelID    +
                   LabelNo    +
                   Reserved1  +
                   FileID1    +
                   FileID2    +
                   FileID3    +
                   FileID4    +
                   NA1        +
                   RecFormat  +
                   NA2        +
                   SectionNo  +
                   CreateDate +
                   NA3        +
                   ExpDate    +
                   VerifyCopy +
                   NA4        +
                   Delimiter;
     WriteLn(OutFile, OutString);
   end; {with FileHeader}

   with UserHeader do
   begin
     OutString := LabelID   +
                  LabelNo   +
                  ProcDate  +
                  ZFiller1  +
                  ReceiverID     +
                  Filler1   +
                  Currency  +
                  Reserved1 +
                  WorkCode  +
                  FileNo    +
                  Reserved2 +
                  UserDef   +
                  Delimiter;
     WriteLn(OutFile, OutString);
   end; {with UserHeader}
   Result := IOResult;
  end; {if Result = 0}
{$I+}
end; {CreateOutFile}

function TAibEftObj.ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
var
  Target : TAbsCustomer;
begin
  Result := inherited ValidateRec(EventData);
  if Result then
  begin
   {check for zero amount in transaction.  I don't whether a UK BACS file would be
   rejected for a zero amount.  If so then we could do this check in the ExportObject}
  {I'm not sure if it's possible for a zero transaction to get this far, but it can't hurt
  to test for it}
    with EventData do
    begin
     if Pennies(Transaction.thTotalInvoiced) = 0 then
     begin
       If IsReceipt then
         Target := Customer
       else
         Target := Supplier;
       Result := False;
       ShowExportMessage('Error','Zero transaction for ' + Target.acCompany,
                            'Run aborted');
     end;
    end;
  end;
end; {method}







destructor TAibEftObj.Destroy;
begin
  if Assigned(FToolkit) then
  begin
    FToolkit.CloseToolkit;
    FToolkit := nil;
  end;
  inherited;
end;

procedure TAibEftObj.ReadIniFile(const EventData : TAbsEnterpriseSystem);
var
  IsHobs : Boolean;
  a, b, c : integer;
  Res : longint;

begin
  IsHobs := False;
  GetIniFilename;
(*  if (ClassName = 'TBankIrExportObject') or
     (ClassName = 'TBankIrExportObjectEx') then
     EFTIniFile := DefaultBIEFTIniFile
  else
  if ClassName = 'TAibEftObj' then
  begin
     EFTIniFile := DefaultAIBEFTIniFile;
     {$IFNDEF MultiBacs}
     CoInitialize(nil);
     {$ENDIF}
  end
  else
  if ClassName = 'TUlsterBankExportObject' then
     EFTIniFile := DefaultUlsterBankIniFile
  else *)
  if ClassName = 'TBankScotHobsExportObject' then
    IsHobs := True;

  if not IsHobs then
  begin
    EFTIniFile := CheckPath(EventData.Setup.ssDataPath) + EFTIniFile;
    if not GetEftOptions(EFTIniFile, EftRec, False, IsReceipt) then
      Failed := flUserID;
  end
  else
    EftRec.OutCurr := 1;

  if EftRec.OutCurr <> 1 then
  begin
    FToolkit := CreateOLEObject(sTkClassName) as IToolkit;
    if FToolkit.Enterprise.enCurrencyVersion <> enProfessional then
    begin
      if Assigned(FToolkit) then
      begin
        EncodeOpCode(97, a, b, c);
        FToolkit.Configuration.SetDebugMode(a, b, c);
        FToolkit.Configuration.DataDirectory := EventData.Setup.ssDataPath;
        Res := FToolkit.OpenToolkit;
        if Res <> 0 then
          ShowMessage('Error opening COM Toolkit:'#13#13 +
                       QuotedStr(FToolkit.LastErrorString));
      end
      else
        ShowMessage('Unable to create COM Toolkit');
    end
    else
      EftRec.OutCurr := 1;
  end;
end;

procedure TAibEftObj.SetHeader(const EventData : TAbsEnterpriseSystem);
var
  TempString, DateString : String;
  TempInt : longint;
begin
  with EventData do
  begin
    FillChar(VolHeader, SizeOf(TAIBVolHeaderRec), ' ');
    FillChar(FileHeader, SizeOf(TAIBFileHeaderRec), ' ');
    FillChar(UserHeader, SizeOf(TAIBUserHeaderRec), ' ');
    FillChar(UserTrailer, SizeOf(TAIBUserTrailerRec), ' ');
    GetEventData(EventData);
    with VolHeader do
    begin
      Str2_Char('VOL', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      Version     := '.';
    end;

    with FileHeader do
    begin
      Str2_Char('HDR', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      FileID1     := 'A';
{Authorized User ID as above}
      Str2_Char(EftRec.UserID, FileID2, SizeOf(FileID2));
      FileID3     := 'S';
      TempInt := JulianDate(ProcControl.PDate);
      if TempInt > 0 then
        DateString := ' ' + ZerosAtFront(TempInt, 5)
      else
      begin
        ShowMessage('Invalid process date');
        Failed := flDate;
      end;
{      Str2_Char(DateString, CreateDate, SizeOf(CreateDate));}
      Delimiter   := '.';
    end;

    with UserHeader do
    begin
      Str2_Char('UHL', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      Str2_Char(DateString, ProcDate, SizeOf(ProcDate));

      Str2_Char(ZerosAtFront(0,SizeOf(ZFiller1)),ZFiller1,SizeOf(ZFiller1));
      Str2_Char('93', ReceiverID, SizeOf(ReceiverID));

{For currency assume IEP unless Euro is specified}
//PR: 13/01/2009 - Change to always use 01
(*      if (Ord(ProcControl.PayCurr[1]) = 128) or {euro symbol we hope}
         (ProcControl.PayCurr = 'EUR') then *)
        TempString := '01';
{      else
        TempString := '00';}
{Check if we have multi-currency or euro version - if not then must be iep}
      if CurrencyVer = 0 then
        TempString := '00';
      Str2_Char(TempString, Currency, SizeOf(Currency));
      Str2_Char('000000', Reserved1, SizeOf(Reserved1));
      Str2_Char('1 DAILY  ', WorkCode, SizeOf(WorkCode));
      {can't set fileno here as i'm using payrun and that doesn't seem to
      be available yet - it appears to be 0 at the moment, yet when i do
      geteventdata again below in writerec it is the correct number}
{Leave userDef as spaces for the moment}
      Delimiter   := '.';
    end;

    with UserTrailer do
    begin
      Str2_Char('UTL', LabelID, SizeOf(LabelID));
      LabelNo     := '1';
      Delimiter   := '.';
    end;
  end; {with EventData}
end;

function TAibEftObj.CreateOutFileOnly(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  Result := inherited CreateOutFile(AFilename, EventData);
end;

{$IFDEF BBM}
function TAibEftObj.GetIniFileName: AnsiString;
{$ELSE}
function TAibEftObj.GetIniFileName: String;
{$ENDIF}
begin
  EFTIniFile := DefaultAIBEFTIniFile;
end;

end.
