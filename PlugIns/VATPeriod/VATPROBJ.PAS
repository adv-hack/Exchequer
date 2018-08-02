unit VatprObj;

interface

uses
  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}
  Classes, VatPrVar, BtrvU2, ComCtrls, Enterprise01_TLB, ComObj, Graphics, GlobVar
  , MiscUtil, APIUtil;

type
  TAccessMode = (amNone, amAdd, amUpdate);

  TVATPeriodOptInfo = Class
    Details : TVATPeriodOptRec;
  end;

  TVATPeriodInfo = Class
    Details : TVATPeriodRec;
  end;

  TVatPeriodObject = Class
  private
    FRec : TVATPeriodRec;
    FOptRec : TVATPeriodOptRec;
    FIndex : Integer;
    FAccessMode : TAccessMode;
    FCompanyDir : String;
    FFilesOpen : Boolean;
    FVar, FOpt : FileVar;
    FSaveKey : String;
    FSaveIndex : integer;
    FSaveType : Char;
    FCurrentPeriodString : String;
    procedure SetCompanyDir(const Value: String);
    function GetCurrentPeriod : String;
    procedure SetCurrentPeriod(const Value: String);
    function GetEndDate : string;
    procedure SetEndDate(const Value: String);
    function GetStartDate : string;
    procedure SetStartDate(const Value: String);
    procedure SetIndex(const Value: Integer);
    function GetPeriod : string;
    procedure SetPeriod(const Value: string);
    function GetOptPeriods : Byte;
    procedure SetOptPeriods(Value : Byte);
    function GetOptAuto : Boolean;
    procedure SetOptAuto(Value : Boolean);
    function UpdateNextStartDate : Integer;
    function GetColor(Index : Integer) : TColor;
    procedure SetColor(Index : Integer; Value : TColor);
    function MakePeriodEndDate(const Year, Period : string) : string;
  public
  //methods
    function GetOptsRec : Integer;
    function SaveOptsRec : Integer;
    function GetEqual(const SearchKey : string; Lock : Boolean = False) : integer;
    function GetList(AList : TListView; var CurrentP : integer) : Boolean;
    procedure GetCompanies(AList : TStrings);
    function Save : integer;
    function Add : integer;
    function Insert : integer;
    function OpenCompany : integer;
    function CloseCurrentPeriod : integer;
    function CopyTable(const ToCo : string) : integer;
    function GetTransactionPeriod(const TranDate : string; Mode : Byte) : string;
    constructor Create;
    destructor Destroy; override;

    function Autofill(LastEndDate : string) : integer;
  //properties
    property CurrentPeriod : String read GetCurrentPeriod write SetCurrentPeriod;
    property EndDate : String read GetEndDate write SetEndDate;
    property StartDate : String read GetStartDate write SetStartDate;
    property Period : string read GetPeriod write SetPeriod;
    property Index : Integer read FIndex write SetIndex;
    property CompanyDir : String read FCompanyDir write SetCompanyDir;
    property CurrentPeriodString : string read FCurrentPeriodString write FCurrentPeriodString;
    property MaxPeriods : Byte read GetOptPeriods write SetOptPeriods;
    property UseAutoFillInPostingHook : Boolean read GetOptAuto write SetOptAuto;

    property BackColor : TColor Index 0 read GetColor write SetColor;
    property TextColor : TColor Index 1 read GetColor write SetColor;
    property CurrColor : TColor Index 2 read GetColor write SetColor;
  end;

var
  VatPeriod : TVatPeriodObject;
  FToolkit : IToolkit;

implementation

uses
  SysUtils, EtDateU, Dialogs, Controls;

const
  KeyLengths : Array[0..1] of Byte = (6, 8);
{ TVatPeriodObject }


function TVatPeriodObject.Add: integer;
begin
  Result := Add_Rec(FVar, VatPeriodF, FRec, FIndex);
end;

function TVatPeriodObject.Insert: integer;
begin
  Result := Add_Rec(FVar, VatPeriodF, FRec, FIndex);
  if Result = 0 then
    UpdateNextStartDate;
end;


function TVatPeriodObject.CloseCurrentPeriod: integer;
var
  Res : integer;
  p, y : integer;
  EDate : string;
  KeyS : string[255];
begin
  //End date for period has been set so save it before finding current period rec
  EDate := FRec.EndDate;
  Res := Find_Rec(B_GetFirst, FOpt, VatPeriodOptF, FOptRec, 0, Keys);
  BtrvErr(Res, 'loading current period record');

  if Res = 0 then
  begin
    p := StrToInt(FOptRec.Period);
    y := StrToInt(FOptRec.Year);

    inc(p);
    if p > FOptRec.OptNoOfPeriods then
    begin
      p := 1;
      inc(y);
    end;

    FOptRec.Period := IntToStr(p);
    if p < 10 then
      FOptRec.Period := '0' + IntToStr(p);
    FOptRec.Year := IntToStr(y);
    FOptRec.EndDate := EDate;
    Res := Put_Rec(FOpt, VatPeriodOptF, FOptRec, 0);
    BtrvErr(Res, 'saving current period record');
  end;
end;

function TVatPeriodObject.CopyTable(const ToCo: string): integer;
var
  iPos, iOpenStatus, i, iResult : integer;
  FDirTo, sToCompanyPath, FNameTo, FOptName2 : string;
  FileFrom, FileTo : TFileStream;
  Overwrite : Boolean;
  VATPeriodRec : TVATPeriodRec;
  VATPeriodOptRec : TVATPeriodOptRec;
  VATPERRecs, VATOPTRecs : TList;
  Keys : Str255;
  VATPeriodOptInfo : TVATPeriodOptInfo;
  VATPeriodInfo : TVATPeriodInfo;
  CIdRec  :  ClientIdType;
begin
  Result := mrCancel;

  // Find Company to copy to
  FNameTo := '';
  for i := 1 to FToolkit.Company.cmCount do
  begin
    if FToolkit.Company.cmCompany[i].coName = ToCo then
    begin
      FNameTo := Trim(FToolkit.Company.cmCompany[i].coPath) + VatPeriodFileName;
      FOptName2 := Trim(FToolkit.Company.cmCompany[i].coPath) + VatPeriodOptFileName;
      sToCompanyPath := Trim(FToolkit.Company.cmCompany[i].coPath);
      Break;
    end;{if}
  end;{for}

  if FNameto <> '' then
  begin
    // NF: 24/07/2008 Updated to be SQL compatible
    if UsingSQL then
    begin
      // SQL Version

      // Read All VATPER Records into a list
      VATPERRecs := TList.Create;
      FillChar(Keys, SizeOf(Keys), #0);
      iResult := Find_Rec(B_GetFirst, FVar, VatPeriodF, VATPeriodRec, 0, Keys);
      while (iResult = 0) do
      begin
        VATPeriodInfo := TVATPeriodInfo.Create;
        VATPeriodInfo.Details := VATPeriodRec;
        VATPERRecs.Add(VATPeriodInfo);
        iResult := Find_Rec(B_GetNext, FVar, VatPeriodF, VATPeriodRec, 0, Keys);
      end;{while}

      // Read All VATOPT Records into a list
      VATOPTRecs := TList.Create;
      FillChar(Keys, SizeOf(Keys), #0);
      iResult := Find_Rec(B_GetFirst, FOpt, VatPeriodOptF, VATPeriodOptRec, 0, Keys);
      while (iResult = 0) do
      begin
        VATPeriodOptInfo := TVATPeriodOptInfo.Create;
        VATPeriodOptInfo.Details := VATPeriodOptRec;
        VATOPTRecs.Add(VATPeriodOptInfo);
        iResult := Find_Rec(B_GetNext, FOpt, VatPeriodOptF, VATPeriodOptRec, 0, Keys);
      end;{while}

      // Close Current Company Files
      Close_File(FVar);
      Close_File(FOpt);

      // Get Client ID Rec for Company to copy to, and open company
      Prime_ClientIdRec(CIdRec, 'PI', 1);
      SQLUtils.OpenCompany(sToCompanyPath, @CIdRec);

      // Create VATPRD for Company to copy to (if necessary)
      iOpenStatus := 0;
      if not TableExists(FNameTo, @CIdRec) then
      begin
        iOpenStatus := Make_FileCID(FVar, FNameTo
        , FileSpecOfs[VatPeriodF]^,FileSpecLen[VatPeriodF], @CIdRec);
        if iOpenStatus <> 0 then
        begin
          MsgBox('Error Creating VATPRD in ' + FNameTo + #13#13'Error code : '
          + IntToStr(iOpenStatus), mtError, [mbOK], mbOK, 'Create VATPRD Error');
        end;{if}
      end;{if}

      // Open VATPRD
      if iOpenStatus = 0 then
      begin iOpenStatus := Open_FileCID(FVar, FNameTo, 0, @CIdRec);
        if iOpenStatus <> 0 then
        begin
          MsgBox('Error Opening VATPRD in ' + FNameTo + #13#13'Error code : '
          + IntToStr(iOpenStatus), mtError, [mbOK], mbOK, 'Open VATPRD Error');
        end;{if}
      end;{if}

      // Add Records to VATPRD
      For iPos := 0 to VATPERRecs.Count-1 do
      begin
        iResult := Add_RecCID(FVar, VatPeriodF, TVATPeriodInfo(VATPERRecs[iPos]).Details, 0, @CIdRec);
        if iResult <> 0 then
        begin
          MsgBox('Error Adding a record to VATPRD in ' + FNameTo + #13#13'Error code : '
          + IntToStr(iResult), mtError, [mbOK], mbOK, 'Add VATPRD Error');
        end;{if}
      end;{for}

      // Close VATPRD
      Close_FileCID(FVar, @CIdRec);

      // Create VATOPT for Company to copy to (if necessary)
      iOpenStatus := 0;
      if not TableExists(FOptName2, @CIdRec) then
      begin
        iOpenStatus := Make_FileCID(FOpt, FOptName2
        , FileSpecOfs[VatPeriodOptF]^,FileSpecLen[VatPeriodOptF], @CIdRec);

        if iOpenStatus <> 0 then
        begin
          MsgBox('Error Creating VATOPT in ' + FOptName2 + #13#13'Error code : '
          + IntToStr(iOpenStatus), mtError, [mbOK], mbOK, 'Create VATOPT Error');
        end;{if}
      end;{if}

      // Open VATOPT
      if iOpenStatus = 0 then
      begin
        iOpenStatus := Open_FileCID(FOpt, FOptName2, 0, @CIdRec);
        if iOpenStatus <> 0 then
        begin
          MsgBox('Error Opening VATOPT in ' + FOptName2 + #13#13'Error code : '
          + IntToStr(iOpenStatus), mtError, [mbOK], mbOK, 'Open VATOPT Error');
        end;{if}
      end;{if}

      // Add Records to VATOPT
      For iPos := 0 to VATOPTRecs.Count-1 do
      begin
        iResult := Add_RecCID(FOpt, VatPeriodOptF, TVATPeriodOptInfo(VATOPTRecs[iPos]).Details, 0, @CIdRec);
        if iResult <> 0 then
        begin
          MsgBox('Error Adding a record to VATOPT in ' + FNameTo + #13#13'Error code : '
          + IntToStr(iResult), mtError, [mbOK], mbOK, 'Add VATOPT Error');
        end;{if}
      end;{for}

      // Close VATOPT
      Close_FileCID(FOpt, @CIdRec);
      FFilesOpen := FALSE;

      // Clear up
      ClearList(VATPERRecs);
      VATPERRecs.Free;
      ClearList(VATOPTRecs);
      VATOPTRecs.Free;

      // Re-open files for current company, so we are back to where we started.
      OpenCompany;
    end
    else
    begin
      // Btrieve Version - Just copy the files.

      // Create VATPER Dir
      FDirTo := Trim(FToolkit.Company.cmCompany[i].coPath) + 'VATPER';
      if not ForceDirectories(FDirTo) then
        raise Exception.Create('Unable to create VATPER sub-directory in ' +
                                Trim(FToolkit.Company.cmCompany[i].coPath));
      if FileExists(FNameto) then
      begin
        Result := MessageDlg('Company ' + ToCo + ' already contains a Vat Period Table.'#13
        + 'Do you want to overwrite this table?', mtConfirmation, mbYesNoCancel, 0)
      end
      else
      begin
        Result := mrYes;
      end;{if}

      if Result = mrYes then
      begin
        // Copy VATPER.DAT
        FileFrom := TFileStream.Create(FCompanyDir + VatPeriodFileName, fmOpenRead or fmShareDenyNone);
        FileTo := TFileStream.Create(FNameTo, fmCreate or fmShareDenyNone);
        Try
          if FileTo.CopyFrom(FileFrom, 0) <> FileFrom.Size
          then Result := -1;
        Finally
          FileFrom.Free;
          FileTo.Free;
        End;{try}

        // Copy VATOPT.DAT
        FileFrom := TFileStream.Create(FCompanyDir + VatPeriodOptFileName, fmOpenRead or fmShareDenyNone);
        FileTo := TFileStream.Create(FOptName2, fmCreate or fmShareDenyNone);
        Try
          if FileTo.CopyFrom(FileFrom, 0) <> FileFrom.Size then
            Result := -1;
        Finally
          FileFrom.Free;
          FileTo.Free;
        End;{try}

      end;{if}
    end;{if}
  end;{if}
end;

constructor TVatPeriodObject.Create;
begin
  inherited Create;
  FIndex := -1;
  FillChar(FRec, SizeOf(FRec), #0);
  FillChar(FOptRec, SizeOf(FRec), #0);
  FFilesOpen := False;
  FAccessMode := amNone;
//  FToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
end;

destructor TVatPeriodObject.Destroy;
begin
  if FFilesOpen then
  begin
    Close_File(FVar);
    Close_File(FOpt);
  end;
//  FToolkit := nil;
  inherited;
end;

function TVatPeriodObject.GetEqual(const SearchKey : string; Lock : Boolean = False): integer;
var
  KeyS : string[255];
  BtrOp : SmallInt;
begin
  BtrOp := B_GetEq;
  if Lock then
  begin
    BtrOp := BtrOp + B_SingLock;
    FAccessMode := amUpdate;
  end
  else
    FAccessMode := amNone;

  FillChar(KeyS[1], 255, #32);
  KeyS := Copy(SearchKey + StringOfChar(' ', 8), 1, KeyLengths[FIndex]);
  FillChar(FRec, SizeOf(FRec), #0);
  Result := Find_Rec(B_GetEq, FVar,VatPeriodF, FRec, FIndex, KeyS);
  if Result <> 0 then
    FAccessMode := amNone;
end;

function TVatPeriodObject.GetList(AList: TListView; var CurrentP : integer): Boolean;
var
  KeyS : string[255];
  Res : Integer;
begin
  Res := Find_Rec(B_GetFirst, FOpt,VatPeriodOptF, FOptRec, 0, KeyS);
  if Res = 0 then
    FCurrentPeriodString := FOptRec.Year + FOptRec.Period;

  AList.Items.Clear;
  Res := Find_Rec(B_GetFirst, FVar,VatPeriodF, FRec, 0, KeyS);

  While Res = 0 do
  begin
    with AList.Items.Add do
    begin
      Caption := FRec.Period;
      SubItems.Add(FRec.Year);
      SubItems.Add(POutDate(GetStartDate));
      SubItems.Add(POutDate(GetEndDate));
      if SubItems[0] + Caption = VatPeriod.CurrentPeriodString then
        CurrentP := AList.Items.Count - 1;
    end;
    Res := Find_Rec(B_GetNext, FVar,VatPeriodF, FRec, 0, KeyS);
  end;
end;

function TVatPeriodObject.OpenCompany: integer;
var
  OpenStatus : Integer;
  KeyS : String[255];
begin
  if not FFilesOpen then
  begin
    OpenStatus := 0;
//  {$IFDEF CreateFiles}
{    if not FileExists(FCompanyDir + VatPeriodFileName) then
    begin
      OpenStatus :=
         Make_File(FVar,FCompanyDir + VatPeriodFileName, FileSpecOfs[VatPeriodF]^,FileSpecLen[VatPeriodF]);
    end;
    if not FileExists(FCompanyDir + VatPeriodOptFileName) then
    begin
      OpenStatus :=
         Make_File(FOpt,FCompanyDir + VatPeriodOptFileName, FileSpecOfs[VatPeriodOptF]^,FileSpecLen[VatPeriodOptF]);
    end;}

    // Create VATPRD ?
    if not TableExists(FCompanyDir + VatPeriodFileName) then
    begin
      OpenStatus := Make_File(FVar,FCompanyDir + VatPeriodFileName
      , FileSpecOfs[VatPeriodF]^,FileSpecLen[VatPeriodF]);
    end;{if}

    // Create VATOPT ?
    if not TableExists(FCompanyDir + VatPeriodOptFileName) then
    begin
      OpenStatus := Make_File(FOpt,FCompanyDir + VatPeriodOptFileName
      , FileSpecOfs[VatPeriodOptF]^,FileSpecLen[VatPeriodOptF]);
    end;{if}

//  {$ENDIF}

    if OpenStatus = 0 then
    begin
      OpenStatus := Open_File(FVar, FCompanyDir + VatPeriodFileName, 0);
      OpenStatus := OpenStatus or Open_File(FOpt, FCompanyDir + VatPeriodOptFileName, 0);
    end;

    if OpenStatus = 0 then
      FFilesOpen := True;

    BtrvErr(OpenStatus, 'opening period file');

    if FFilesOpen then
    begin
      OpenStatus := Find_Rec(B_GetFirst, FOpt, VatPeriodOptF, FOptRec, 0, KeyS);
      if (OpenStatus <> 0) then
      begin
        FillChar(FOptRec, SizeOf(FOptRec), #0);
        FOptRec.OptNoOfPeriods := 12;
        FOptRec.OptUseAuto := False;
        FOptRec.Year := '';
        FOptRec.Period := '';
        FOptRec.EndDate := '';
        FOptRec.BackColor := clTeal;
        FOptRec.TextColor := clWhite;
        FOptRec.CurrColor := clAqua;
        OpenStatus := Add_Rec(FOpt, VatPeriodOptF, FOptRec, 0);
        BtrvErr(OpenStatus, 'creating Options record');
      end;
    end;
  end;

end;

function TVatPeriodObject.Save: integer;
begin
  Result := Put_Rec(FVar, VatPeriodF, FRec, FIndex);
  UpdateNextStartDate;
  BtrvErr(Result, 'saving period record');
end;

procedure TVatPeriodObject.SetCompanyDir(const Value: String);
begin
  FCompanyDir := IncludeTrailingBackSlash(Value);
end;

function TVatPeriodObject.GetCurrentPeriod : string;
var
  Res : Integer;
  KeyS : String[255];
begin
  Res := Find_Rec(B_GetFirst, FOpt,VatPeriodOptF,FOptRec, 0, KeyS);
  if (Res = 0) then
    Result := FOptRec.Period + '/' + FOptRec.Year;
//  BtrvErr(Res, 'finding current period record');
end;

procedure TVatPeriodObject.SetCurrentPeriod(const Value: String);
var
  Res : integer;
  KeyS : String[255];
  EDate : string;
begin
  EDate := FRec.EndDate;
  Res := Find_Rec(B_GetFirst + B_SingLock, FOpt, VatPeriodOptF, FOptRec, 0, KeyS);

  if Res = 0 then
  begin
    FOptRec.Year := Copy(Value, 1, 4);
    FOptRec.Period := Copy(Value, 5, 2);
    FOptRec.EndDate := EDate;
    Res := Put_Rec(FOpt, VatPeriodOptF, FOptRec, 0);
    BtrvErr(Res, 'saving current period record');
    if Res = 0 then
      FCurrentPeriodString := Value;
  end;
end;

function TVatPeriodObject.GetEndDate : string;
begin
  Result := FRec.EndDate;
end;

procedure TVatPeriodObject.SetEndDate(const Value: String);
begin
  FRec.EndDate := Value;
end;

procedure TVatPeriodObject.SetIndex(const Value: Integer);
begin
  FIndex := Value;
end;

function TVatPeriodObject.GetStartDate : string;
begin
  Result := Frec.StartDate;
end;

procedure TVatPeriodObject.SetStartDate(const Value: String);
begin
  FRec.StartDate := Value;
end;


function TVatPeriodObject.GetPeriod : string;
begin
  Result := FRec.Year + FRec.Period;
end;

procedure TVatPeriodObject.SetPeriod(const Value: string);
begin
  Frec.Year := Copy(Value, 1, 4);
  FRec.Period := Copy(Value, 5, 2);
end;

function TVatPeriodObject.GetTransactionPeriod(const TranDate : string; Mode : Byte) : string;
//Mode - 0 = if Match then return EndDate else return CurrentPeriod
//     - 1 = if Match and EndDate >= CurrentPeriod then return EndDate else return CurrentPeriod
var
  Res, BtOp : integer;
  KeyS : String[255];
  CurrentP : string;
  y : integer;
begin
  Result := '';
  Res := Find_Rec(B_GetFirst, FOpt,VatPeriodOptF,FOptRec, 0, KeyS);
  if Res <> 0 then
    raise Exception.Create('Unable to find Current VAT Period record');

{  FIndex := 1;
  Res := GetEqual(FRec.Year + FRec.Period);

  if Res <> 0 then
     raise Exception.Create('Invalid Current VAT Period');}

//  CurrentP := FOptRec.EndDate;
  CurrentP := MakePeriodEndDate(FOptRec.Year, FOptRec.Period);

  KeyS := TranDate + StringOfChar(' ', 255);
  Res := Find_Rec(B_GetGEq, FVar, VatPeriodF, FRec, 1{endDate}, KeyS);
(*  if (Res = 0) and (((Mode = 0) or (FRec.EndDate >= CurrentP)) or
                   ((Mode = 1) and (FRec.StartDate <= TranDate))) then *)
  if (Res = 0) and ((Mode = 0) or ((Mode = 1)and (FRec.EndDate >= FOptRec.EndDate))) then
    Result := MakePeriodEndDate(FRec.Year, FRec.Period)
  else
  begin
    if (Mode = 1) and (Res in [4, 9]) and FOptRec.OptUseAuto then
    begin
      y := 1; //try 3 years of autofill - if more than that then probably something wrong
      while (Res <> 0) and (y < 4) do
      begin
        Res := Find_Rec(B_GetLast, FVar, VatPeriodF, FRec, 1{endDate}, KeyS);

        Res :=  AutoFill(POutDate(FRec.EndDate));
        if Res = 0 then
        begin
          KeyS := TranDate + StringOfChar(' ', 255);
          Res := Find_Rec(B_GetGEq, FVar, VatPeriodF, FRec, 1{endDate}, KeyS);
        end;

        if (Res = 0) and (FRec.StartDate <= TranDate) then
//          Result := FRec.EndDate
          Result := MakePeriodEndDate(FRec.Year, FRec.Period)
        else
          Result := CurrentP;

        inc(y);
      end;
    end
    else
      Result := CurrentP;
  end;

end;


procedure TVatPeriodObject.GetCompanies(AList : TStrings);
var
  i : integer;
begin
  if Assigned(FToolkit) then
  begin
    for i := 1 to FToolkit.Company.cmCount do
      if Trim(FToolkit.Company.cmCompany[i].coPath) <> Trim(FCompanyDir) then
        AList.Add(FToolkit.Company.cmCompany[i].coName);
  end
  else
    raise Exception.Create('COM Toolkit not assigned');
end;

function TVatPeriodObject.GetOptPeriods : Byte;
begin
  Result := FOptRec.OptNoOfPeriods
end;

procedure TVatPeriodObject.SetOptPeriods(Value : Byte);
begin
  FOptRec.OptNoOfPeriods  := Value;
end;

function TVatPeriodObject.SaveOptsRec : Integer;
begin
  Result := Put_Rec(FOpt, VatPeriodOptF, FOptRec, 0);
end;

function TVatPeriodObject.GetOptAuto : Boolean;
begin
  Result := FOptRec.OptUseAuto
end;

procedure TVatPeriodObject.SetOptAuto(Value : Boolean);
begin
  FOptRec.OptUseAuto := Value;
end;


function TVatPeriodObject.GetOptsRec : Integer;
var
  Res : integer;
  KeyS : String[255];
begin
  Result := Find_Rec(B_GetFirst + B_SingLock, FOpt, VatPeriodOptF, FOptRec, 0, KeyS);
end;

function TVatPeriodObject.UpdateNextStartDate : Integer;
var
  EDate, SDate : TDate;
  Res : Integer;
  KeyS : String[255];
begin
  KeyS := FRec.Year + Frec.Period;
  Result := Find_Rec(B_GetEq, FVar, VatPeriodF, FRec, 0, KeyS);

  if (Result = 0) then
  begin
    EDate := StrToDateTime(POutDate(FRec.EndDate)) + 1;

    if (Result = 0) then
    begin
      Result := Find_Rec(B_GetNext + B_SingLock, FVar, VatPeriodF, FRec, 0, KeyS);

      if (Result = 0) then
      begin
        FRec.StartDate := FormatDateTime('YYYYMMDD', EDate);
        Result := Put_Rec(FVar, VatPeriodF, FRec, 0);
      end;
      if Result <> 9 then
        BtrvErr(Result, 'updating next Start Date');
    end;
  end;
end;

function TVatPeriodObject.Autofill(LastEndDate : string) : integer;
var
  Res, i, NoOfPeriods : Integer;
  KeyS : String[255];
  Periods : Array[1..12] of TVatPeriodRec;
  EnoughPeriods : Boolean;
  sd : TDate;
  SDate : string;

  function IncOneYear(const AYear : string) : string;
  var
    y : integer;
  begin
    y := StrToInt(AYear);
    inc(y);
    Result := IntToStr(y);
  end;

  procedure NextYear(var ARec : TVatPeriodRec);
  var
    s  : string;
  begin
    ARec.Year := IncOneYear(ARec.Year);

    s := ARec.StartDate;
    s := IncOneYear(Copy(s, 1, 4)) + Copy(s, 5, 4);
    ARec.StartDate := s;

    s := ARec.EndDate;
    s := IncOneYear(Copy(s, 1, 4)) + Copy(s, 5, 4);
    ARec.EndDate := s;
  end;

begin
  Result := 0;
  EnoughPeriods := True;
  FillChar(Periods, SizeOf(Periods), #0);
  NoOfPeriods := MaxPeriods;
  Res := Find_Rec(B_GetLast, FVar, VatPeriodF, FRec, 0, KeyS);
  if Res = 0 then
  begin
    for i := NoOfPeriods downto 1 do
    begin
      Periods[i] := FRec;

      Res := Find_Rec(B_GetPrev, FVar, VatPeriodF, FRec, 0, KeyS);

      if (Res <> 0) and (i > 1) then
      begin
        EnoughPeriods := False;
        Break;
      end;
    end;

    if EnoughPeriods then
    begin
      for i := 1 to NoOfPeriods do
      begin
        NextYear(Periods[i]);
        if (i = 1) then
        begin
          sd := StrToDateTime(LastEndDate) + 1;
          SDate := FormatDateTime('YYYYMMDD', sd);
          if Periods[1].StartDate <> SDate then
            Periods[1].StartDate := SDate;
          if SDate >= Periods[1].EndDate then
          begin
            ShowMessage('Incompatable dates. Unable to complete Autofill');
            Result := -2;
            Break;
          end;
        end;
        Res := Add_Rec(FVar, VatPeriodF, Periods[i], 0);
        BtrvErr(Res, 'adding new period during Autofill');
      end;
    end
    else
    begin
      ShowMessage('There must be at least one year of periods before Autofill can be used');
      Res := -1;
    end;
  end
  else
    ShowMessage('There must be at least one year of periods before Autofill can be used');
end;

function TVatPeriodObject.GetColor(Index : Integer) : TColor;
begin
  Case Index of
    0  :  Result := FOptRec.BackColor;
    1  :  Result := FOptRec.TextColor;
    2  :  Result := FOptRec.CurrColor;
  end;
end;

procedure TVatPeriodObject.SetColor(Index : Integer; Value : TColor);
begin
  Case Index of
    0  :  FOptRec.BackColor := Value;
    1  :  FOptRec.TextColor := Value;
    2  :  FOptRec.CurrColor := Value;
  end;
end;

function TVatPeriodObject.MakePeriodEndDate(const Year, Period : string) : string;
var
  p, d : integer;
begin
  p := StrToInt(Period);
  d := MonthDays[p];
  if d = 29 then d := 28;
  Result := Year + Period + IntToStr(d);
end;



Initialization
  DefineVatPeriod;
  DefineVatPeriodOpt;
  VatPeriod := TVatPeriodObject.Create;

Finalization
  VatPeriod.Free;

end.
