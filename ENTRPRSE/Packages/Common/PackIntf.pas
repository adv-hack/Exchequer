unit PackIntf;

interface

const
  ppShowEBanking = 1;
  ppReconcileWiz = 2;
  ppReconcileRep = 3;
  ppShowAddNomWizard = 4;


procedure PackageProcedure(WhichProc : Byte; const AppPath, DataPath, UserID : AnsiString);

implementation

uses
  Classes, SysUtils, Windows;

const
  NumOfProcedures = 4;
  NumOfPackages = 3;

  PackageNames : Array[1..NumOfPackages] of string[20] = ('EBanking.bpl', 'BankRec.bpl', 'AddNom.bpl');
  ProcNames    : Array[1..NumOfProcedures] of PChar = ('ShowEBankList', 'ShowReconcileWiz',
                                                            'ShowReconcileReport', 'ShowAddNomWizard');

                                                      //  Proc    Package
  CrossRef : Array[1..NumOfProcedures, 1..2] of Integer = ((1,       1),
                                                           (2,       2),
                                                           (3,       2),
                                                           (4,       3));
type
  TPackageProc = procedure (const DataPath, UserID : AnsiString);

var
  Packages : Array[1..NumOfPackages] of HModule;
  Procs    : Array[1..NumOfProcedures] of TPackageProc;

function GetPackageFromProc(WhichProc : Byte) : Byte;
var
  i : integer;
begin
  for i := 1 to NumOfProcedures do
    if CrossRef[i, 1] = WhichProc then
    begin
      Result := CrossRef[i, 2];
      Break;
    end;
end;

function PackageLoad(WhichProc : Byte; const AppPath : string) : Integer;
//WhichProc refers to the procedure
var
  WhichPackage : Byte;
  ErrorStr : string;
begin
  Try
    Result := 0;
    WhichPackage := GetPackageFromProc(WhichProc);
    if Packages[WhichPackage] = 0 then //Hasn't been loaded yet
    begin
      Packages[WhichPackage] := LoadPackage(IncludeTrailingPathDelimiter(AppPath) + PackageNames[WhichPackage]);
      if Packages[WhichPackage] = 0 then
      begin
        Result := 1;
        ErrorStr := 'Unable to load package ' + PackageNames[WhichPackage];
      end;
    end;

    if (Result = 0) and (@Procs[WhichProc] = nil) then
      Procs[WhichProc] := GetProcAddress(Packages[WhichPackage], ProcNames[WhichProc]);

    if @Procs[WhichProc] = nil then
    begin
      Result := 2;
      ErrorStr := 'Unable to find procedure address for ' + ProcNames[WhichProc];
    end;
  Except
    on E:Exception do
    begin
      Result := 3;
      ErrorStr := 'Exception: ' + E.Message;
    end;
  End;

  if Result <> 0 then
    Raise Exception.Create('Error during LoadPackage: ' + QuotedStr(ErrorStr));
end;

procedure PackageProcedure(WhichProc : Byte; const AppPath, DataPath, UserID : AnsiString);
begin
  if (WhichProc > 0) and (WhichProc <= NumOfProcedures) then
  begin
    if PackageLoad(WhichProc, AppPath) = 0 then
      Procs[WhichProc](DataPath, UserID);
  end
  else
    raise Exception.Create('Invalid package number (' + IntToStr(WhichProc) + ')');

end;

procedure InitializePackages;
var
  i : integer;
begin
  for i := 1 to NumOfPackages do
    Packages[i] := 0;
  for i := 1 to NumOfProcedures do
    Procs[i] := nil;
end;

procedure FinalizePackages;
var
  i : integer;
begin
  for i := 1 to NumOfPackages do
    if Packages[i] <> 0 then
      UnloadPackage(Packages[i]);

end;

Initialization
  InitializePackages;

Finalization
  FinalizePackages;

end.
