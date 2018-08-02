unit EBusTKit;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  GlobVar, VarConst, BtrvU2;

function EnumToOurRefCode(const Enum : DocTypes) : string;
function EBusOurRefCodeToEnum(const OurRefCode : string;
                              var IsEBusPrefix : boolean) : DocTypes;
function InEbusinessMode : boolean;
function SwitchToEBusinessFiles(ToEBus : boolean) : smallint;

procedure SetEBusinessMode(Value : boolean);
procedure SetFileNames(ToEbus : boolean);

implementation

uses
  InitDLLU;

var
  EBusinessMode : boolean;

Const
  {$I FilePath.Inc}

//-----------------------------------------------------------------------

function InEbusinessMode : boolean;
begin
  Result := EBusinessMode;
end;

//-----------------------------------------------------------------------

procedure SetEBusinessMode(Value : boolean);
begin
  EBusinessMode := Value;
end;

//-----------------------------------------------------------------------

function EnumToOurRefCode(const Enum : DocTypes) : string;
begin
  case Enum of
    SOR : Result := 'ESO';
    SIN : Result := 'ESI';
    POR : Result := 'EPO';
    PIN : Result := 'EPI';
    SCR : Result := 'ESC';
    PCR : Result := 'EPC';
  end;
end;

//-----------------------------------------------------------------------

function EBusOurRefCodeToEnum(const OurRefCode : string;
                              var IsEBusPrefix : boolean) : DocTypes;
begin
  Result := WIN; // Value selected as marker only
  if OurRefCode = 'ESO' then
    Result := SOR;
  if OurRefCode = 'ESI' then
    Result := SIN;
  if OurRefCode = 'EPO' then
    Result := POR;
  if OurRefCode = 'EPI' then
    Result := PIN;
  if OurRefCode = 'ESC' then
    Result := SCR;
  if OurRefCode = 'EPC' then
    Result := PCR;
  IsEBusPrefix := Result <> WIN;
end;

//-----------------------------------------------------------------------

procedure SetFileNames(ToEbus : boolean);
begin
  if ToEBus then
  begin
    FileNames[InvF] := PathEBus + 'EbusDoc.dat';
    FileNames[IdetailF] := PathEBus + 'EbusDetl.dat';
  end
  else
  begin
    FileNames[InvF] := Path2 + DocName;
    FileNames[IdetailF] := Path2 + DetailName;
  end;
end;

//-----------------------------------------------------------------------

function SwitchToEBusinessFiles(ToEBus : boolean) : smallint;
begin
  SetEBusinessMode(ToEbus);
  SetFileNames(ToEbus);
  DClose_Files([InvF, IDetailF], false, false);
  Result := Open_Sys([InvF, IDetailF]);
end;

//-----------------------------------------------------------------------

initialization
  SetEBusinessMode(false);

end.
