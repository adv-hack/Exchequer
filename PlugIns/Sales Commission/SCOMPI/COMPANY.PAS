unit Company;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

function GetCompanyCode(const Path : shortstring) : string;

implementation

uses
  Forms, SysUtils;

const MaxCompanies = 200;

type
  TCompanyType = Record
    CompCode   : String [6];     { Company Code  }
    CompName   : String [45];    { Company Name  }
    CompPath   : String [100];   { Company Path - Short DOS 8.3 Format }

    CompSpare  : Array [1..100] Of Char;
  End; { TCompanyType }



Function EX_GETCOMPANY(    COMPDIR    : PCHAR;
                           PARRAY     : POINTER;
                       VAR PARRAYSIZE : LONGINT) : SMALLINT;
                       Stdcall; External 'EntComp.dll';

function Compare(s1, s2 : string) : Boolean;
begin
  s1 := UpperCase(Trim(s1));
  s2 := UpperCase(Trim(s2));

  if s1[Length(s1)] = '\' then
    Delete(s1, Length(s1), 1);

  if s2[Length(s2)] = '\' then
    Delete(s2, Length(s2), 1);


  if s1 = s2 then
    Result := True
  else
    Result := False;
end;

function GetCompanyCode(const Path : shortstring) : string;
//Find company code for the data in path parameter which is taken from setup.ssdatapath
//Use Ex_GetCompany in EntComp.dll to load all companies into an
//array then iterate through until we get a match
var
  CompanyArray : Array[1..MaxCompanies] of TCompanyType;
  CompDir : PChar;
  ProgramPath : string;
  Res : Longint;
  i : integer;
  CompanyCount : longint;
begin
  Result := '';
  ProgramPath := ExtractFilePath(Application.EXEName);
  GetMem(CompDir, Length(ProgramPath) + 1);
  Try
    FillChar(CompDir^, Length(ProgramPath) + 1, #0);

    StrPCopy(CompDir, ProgramPath);

    CompanyCount := SizeOf(CompanyArray);

    Res := EX_GETCOMPANY(Compdir, @CompanyArray, CompanyCount);

    if Res = 0 then
    begin
      for i := 1 to CompanyCount do
      begin
        if Compare(Path, CompanyArray[i].CompPath) then
        begin
          Result := CompanyArray[i].CompCode;
          Break;
        end;
      end;
    end;
  Finally
    FreeMem(CompDir, Length(ProgramPath) + 1);
  End;
end;

end.
