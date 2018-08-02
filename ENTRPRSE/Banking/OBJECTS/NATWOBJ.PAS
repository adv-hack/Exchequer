unit NatWObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$H-}

uses
  CustAbsU, NatW01, ExpObj;

type
   TNatWestExportObject = Class(TExportObject)
     protected
       Options   : TNatWestOptionsRec;
       procedure ReadIniFile;
       function BankRef(const Target : TAbsCustomer) : String;
       function RemAdvice(const Target : TAbsCustomer) : Char;
       function UDField(const Target : TAbsCustomer) : String;
       function ReadBenName(const Target : TAbsCustomer) : String;
     public
       function WriteRec(const EventData : TAbsEnterpriseSystem;
                                    Mode : word) : Boolean; override;
       function CreateOutFile(const AFileName : string;
                              const EventData :
                              TAbsEnterpriseSystem) : integer; override;
       function CloseOutFile : integer; override;
       function TruncateOutFile : boolean;


   end;

var

  NatWestExportObject : TNatWestExportObject;


implementation

Uses
  SysUtils,  IniFiles, Classes;


function TNatwestExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                                  Mode : word) : Boolean;
var
  OutRec : TNatWestPayRec;
  TempStr : string;
  pence : longint;
  OutString : string;
  Target : TAbsCustomer;
begin
  GetEventData(EventData);
  FillChar(OutRec, SizeOf(OutRec), 0);
  with EventData, OutRec do
  begin
    Target := GetTarget(EventData);

    Case Mode of

    wrContra :  begin
                {nothing to do}
                  Result := True;
                end;
   wrPayLine :  begin
                  Date := StandardDate(ProcControl.PDate);
                  CompRef       := BankRef(Target);//Options.BankRef;
                  CompAcc       := UserBankAcc;
                  CompACType    := '00';
                  CompSort      := RemoveHyphens(UserBankSort);
                  DestName      := ReadBenName(Target);
                  DestAcc       := Target.acBankAcc;
                  DestACType    := '00';
                  DestSort      := Target.acBankSort;

                  if not IsBlank(Bacs_Safe(Target.acBankRef)) then
                    DestRef := Bacs_Safe(Target.acBankRef)
                  else
//                    DestRef := Transaction.thOurRef + '/' + IntToStr(ProcControl.PayRun);
                    DestRef := '';

                  Amount := Pennies(Transaction.thTotalInvoiced);
                  RemAdvReq     := RemAdvice(Target);//Options.Advice[1];

                  TotalPenceWritten := TotalPenceWritten + Amount;
                  inc(TransactionsWritten);

                  {write record here}

                  with OutRec do
                  begin
                    OutString :=
                    Date         + Sep +
                    CompRef      + Sep +
                    CompAcc      + Sep +
                    CompACType   + Sep +
                    CompSort     + Sep +
                    TrimRight(DestName)+ Sep +
                    DestAcc      + Sep +
                    DestACType   + Sep +
                    DestSort     + Sep +
                    DestRef      + Sep +
                    Pounds(Amount)+ Sep +
                    RemAdvReq;
                  end;
                  Result := WriteThisRec(OutString);

                end;
    end; {case}


  end; {with}
end;


procedure TNatwestExportObject.ReadIniFile;
var
  TheIni : TIniFile;
begin
  TheIni := TIniFile.Create(DataPath + IniFileName);
  Try
    with Options do
    begin
      BankRef := TheIni.ReadInteger('Autopay','BankRef',0);
      BenName := TheIni.ReadInteger('Autopay','BenName',0);
      Advice  := {TheIni.ReadString('Autopay','AdviceRequired','N');}'N';
    end;
  Finally
    TheIni.Free;
  End;
end;

function TNatwestExportObject.CreateOutFile(const AFileName : string;
                                            const EventData :
                                     TAbsEnterpriseSystem) : integer;
begin
  ReadIniFile;
  if Options.BankRef = 0 then
  begin
    ShowExportMessage('Error','Field for Bank Reference number not specified','Run aborted');
    Result := -1;
    Failed := flUserID;
  end
  else
  begin
    Result := Inherited CreateOutFile(AFilename, EventData);
    WriteThisRec(NatWestFileHeader);
  end;
end;

function TNatwestExportObject.CloseOutFile : integer;
{last record shouldn't have a CR/LF after it.  As we don't have a contra or a trailer we
don't know the last record when we have it.  So there are 2 obvious approaches:
1.  Write records in arrears.  2.  Write the file as normal, then lose the last two bytes.
I'll try approach 2 for now as the file format has been tested and is correct apart from the
cr/lf - approach 2 changes things as little as possible}
begin
  Result := inherited CloseOutFile;
  if Result = 0 then
    if not TruncateOutFile then
      Result := -1;
end;

function TNatwestExportObject.TruncateOutFile : Boolean;
{Delete the last two bytes from the file}
var
  OutF : TFileStream;
begin
  Result := True;
  Try
   OutF := TFileStream.Create(OutfileName, fmOpenReadWrite or fmShareExclusive);
   Try
     OutF.Size := OutF.Size - 2;
   Finally
     OutF.Free;
   End;
  Except
   Result := False;
  End;
end;


function TNatwestExportObject.BankRef(const Target : TAbsCustomer) : String;
begin
  Result := Copy(UDField(Target), 1, 4);
end;

function TNatwestExportObject.RemAdvice(const Target : TAbsCustomer) : Char;
var
  s : string;
begin
  Result := 'N';
  s := UpperCase(UDField(Target));

  if Length(s) > 0 then
    Result := s[Length(s)];

  if not (Result in ['N','Y']) then
    Result := 'N';
end;

function TNatwestExportObject.UDField(const Target : TAbsCustomer) : String;
var
  i : integer;
begin
  i := Options.BankRef;
  Case i of
    1 :  Result := Target.acUserDef1;
    2 :  Result := Target.acUserDef2;
    3 :  Result := Target.acUserDef3;
    4 :  Result := Target.acUserDef4;
  end; //case

  Result := Trim(Result);
end;

function TNatwestExportObject.ReadBenName(const Target : TAbsCustomer) : String;
var
  i : integer;
begin
  i := Options.BenName;
  Case i of
    1 :  Result := Target.acUserDef1;
    2 :  Result := Target.acUserDef2;
    3 :  Result := Target.acUserDef3;
    4 :  Result := Target.acUserDef4;
    else
      Result := Target.acCompany
  end; //case

  Result := Bacs_Safe(Trim(Result));
end;




end.
