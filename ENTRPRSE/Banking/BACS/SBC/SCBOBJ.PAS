unit ScbObj;

{ prutherford440 15:13 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{Each line of the main export file has to have the total amount & number of payments in it,
so we can't write any line until we've received all of them.  The basic strategy, then, is
to write each record to a temporary file, then, at the contra hook, read the temporary file
and write the export file.  Things are made slightly more complicated by an optional details
file which lists the invoices covered by each payment.  As this is optional we'll leave it
for now and add it if there's time later}
interface

uses
  ExpObj, Sbc01;

type
  TSCBExportObject = Class(TExportObject)
    protected
      DetailFile : TextFile;
      TempFile   : File of TSCBExportRec;
      DetailFileName, TempFileName : string;
    public
      PayFileType : TScbPayFileType;
      Separator : Char;
      function WriteRec(const EventData : TAbsEnterpriseSystem;
                                   Mode : word) : Boolean; override;
      function CreateOutFile(const FileName1, FileName2, Filename3 : string;
                              const EventData :
                              TAbsEnterpriseSystem) : integer; reintroduce; overload;
      function CloseOutFile : integer; override;

    end;


implementation

uses
  ExpMsg;

function TSCBExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                              Mode : word) : Boolean;
var
  OutRec : TSCBExportRec;
  Target : TAbsCustomer;
begin
  Target := EventData.Supplier;
  GetEventData(EventData);
  FillChar(OutRec, SizeOf(OutRec), #32);
  with EventData, OutRec do
  begin
    CompName       := Setup.ssUserName;
    TotalPayNo     := 0; {for now}
    TotalPayAmount := 0; {for now}
    DebitAC        := UserBankAcc;
    DebitDate      := ProcControl.PDate; {??? do we want the run date or something else?}
    CreditDate     := ProcControl.PDate; {??    as above}
    BenName1       := Target.acName;
{don't have BenName2}
    if AllDigits(BenFax) then
      BenFax       := Target.acFax;
    BenAdd1 := Target.acAddress[1];
    BenAdd2 := Target.acAddress[2];
    BenAdd3 := Target.acAddress[3];
    if AllDigits(Target.acBankAcc) then
      BenBankCode  := Target.acBankAcc
    else
    begin
      ShowExportMessage('Error','Invalid Bank code for ' + BenName1,
                          'This run has been aborted');
      BoResult := False;
      Exit;
    end;

    BenBankName := Target.acBankRef;
    BenBranch := Target.acBankSort;




end;

function TSCBExportObject.CreateOutFile(const FileName1, FileName2, FileName3 : string;
                                        const EventData :
                                             TAbsEnterpriseSystem) : integer;
begin
  inherited CreateOutFile(Filename1, EventData);
  DetailFileName := FileName2;
{$I-}
  AssignFile(DetailFile, DetailFileName);
  Rewrite(DetailFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to create file ' + DetailFileName,
                        'This run has been aborted');
  TempFileName := FileName3;
  AssignFile(TempFile, TempFileName);
  Rewrite(TempFile, 1);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to create file ' + TempFileName,
                        'This run has been aborted');
{$I+}
end;

function TSCBExportObject.CloseOutFile : integer;
begin
  Inherited CloseOutFile;
{$I-}
  CloseFile(DetailFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to close file ' + DetailFileName, '');
  CloseFile(TempFile);
  Result := IOResult;
  if Result <> 0 then
    ShowExportMessage('Warning','Unable to close file ' + TempFileName, '');
{$I+}
end;




end.
