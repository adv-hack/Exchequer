unit VarConst;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Controls, Forms, COMObj, GlobVar, BtrvU2, {$IFNDEF ChangeComp}Enterprise01_TLB, ContDet,{$ENDIF} SysUtils
  ,Dialogs, ComCtrls, FileUtil;

const
  ContactF = 1;

  CoNumOfKeys = 2;
  CoNumSegments = 5;

  CoCodeIdx = 0;
  CoUniqueIdx = 1;


type

  EContactError = Class(Exception);

  // Note: This structure is duplicated in \ENTRPRSE\Conversion\v70 SQL Converter\Converter\DataWriteObjs\oContactDataWrite.pas
  // for the SQL Data Migration - please ensure any changes to this structure are duplicated
  TContactRecType = Record
    coCompany    : String[6];     // Enterprise Company Code
    coAccount    : String[10];    // Enterprise Parent Account Code

    coCode       : String[20];    // Unique Contact Code
    coTitle      : String[10];    // Title - 'Mr', 'Mrs', 'Miss', 'Ms',etc…
    coFirstName  : String[30];    // Christian Name - 'Mark', 'Kevin', etc…
    coSurname    : String[30];
    coPosition   : String[30];    // Job Title
    coSalutation : String[20];    // Method Of Address - 'Jon', 'Mr Frewer'
    coContactNo  : String[30];    // Telephone Number
    coDate       : String[8];     // Added Date in YYYYMMDD format
    coFaxNumber  : String[30];    // Fax Number
    coEmailAddr  : String[100];   // Email Address
    coAddress1   : String[35];    // Delivery Address #1
    coAddress2   : String[35];    // Delivery Address #2
    coAddress3   : String[35];    // Delivery Address #3
    coAddress4   : String[35];    // Delivery Address #4
    coPostCode   : String[10];    // PostCode

    coSpare      : Array [1..512] Of Char;
  End; { ContactRecType }
  // Note: This structure is duplicated in \ENTRPRSE\Conversion\v70 SQL Converter\Converter\DataWriteObjs\oContactDataWrite.pas
  // for the SQL Data Migration - please ensure any changes to this structure are duplicated

  TContactFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..CoNumSegments] of KeySpec;
    AltColt : AltColtSeq;
  end;

var
  ContactRec  : TContactRecType;
  ContactFile : TContactFileDef;

{$IFNDEF ChangeComp}
function BuildCodeIndex(const Company, Account, Code : ShortString) : ShortString;
function BuildUniqueIndex(const Company, Code : ShortString) : ShortString;

procedure DetailsToRec(const Company, AccountCode : shortString;
                       const DetailsForm : TfrmContactDetails);

function CheckIndex(s, s1 : shortString) : Boolean;

//function NextContactCode(const Company, Surname : shortstring; bSQL : boolean) : Shortstring;
{$ENDIF} // ChangeComp


implementation

{$IFNDEF ChangeComp}
uses
  EtstrU;

Procedure DefineContactFile;
Const
  Idx = ContactF;
Begin
  With ContactFile do
  begin
    FileSpecLen[Idx]:=Sizeof(ContactFile);
    Fillchar(ContactFile,FileSpecLen[Idx],0);

    RecLen:=Sizeof(TContactRecType);
    PageSize:=DefPageSize;                     { 1024 bytes }
    NumIndex:=coNumOfKeys;

    Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }


    // CoCodeIdx : Index 0  - coCompany + coAccount + coCode
    KeyBuff[1].KeyPos:= BtKeyPos(@ContactRec.coCompany[1], @ContactRec);
    KeyBuff[1].KeyLen:= SizeOf(ContactRec.coCompany) - 1;
    KeyBuff[1].KeyFlags:=DupModSeg;

    KeyBuff[2].KeyPos:= BtKeyPos(@ContactRec.coAccount[1],@ContactRec);
    KeyBuff[2].KeyLen:= SizeOf(ContactRec.coAccount) - 1;
    KeyBuff[2].KeyFlags:=DupModSeg;

    KeyBuff[3].KeyPos:= BtKeyPos(@ContactRec.coCode[1], @ContactRec);
    KeyBuff[3].KeyLen:= SizeOf(ContactRec.coCode) - 1;
    KeyBuff[3].KeyFlags:=DupMod;

    // CoUniqueIdx : Index 1 - coCompany + coCode}
    KeyBuff[4].KeyPos:= BtKeyPos(@ContactRec.coCompany[1], @ContactRec);
    KeyBuff[4].KeyLen:= SizeOf(ContactRec.coCompany) - 1;
    KeyBuff[4].KeyFlags:=DupModSeg;

    KeyBuff[5].KeyPos:= BtKeyPos(@ContactRec.coCode[1], @ContactRec);
    KeyBuff[5].KeyLen:= SizeOf(ContactRec.coCode) - 1;
    KeyBuff[5].KeyFlags:=DupMod;


    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  End; { With }

  FileRecLen[Idx]:=Sizeof(ContactRec);
  Fillchar(ContactRec,FileRecLen[Idx],0);

  RecPtr[Idx]:=@ContactRec;
  FileSpecOfs[Idx]:=@ContactFile;

  FileNames[Idx]:= GetEnterpriseDirectory + 'Contact.dat';

End;


function BuildCodeIndex(const Company, Account, Code : ShortString) : ShortString;
begin
  Result := LJVar(Company, 6) + LJVar(Account, 10) + LJVar(Code, 20);
end;


function BuildUniqueIndex(const Company, Code : ShortString) : ShortString;
begin
  Result := LJVar(Company, 6) + LJVar(Code, 20);
end;


function BuildCompanyIndex(const s : ShortString) : ShortString;
begin
  Result := LJVar(s, 6);
end;

function BuildAccountIndex(const s : ShortString) : ShortString;
begin
  Result := LJVar(s, 10);
end;

procedure DetailsToRec(const Company, AccountCode : shortString;
                       const DetailsForm : TfrmContactDetails);

  function TodaysDate : shortstring;
  begin
    Result := FormatDateTime('yyyymmdd', SysUtils.Date);
  end;

begin
  with DetailsForm, ContactRec do
  begin
     coCompany := LJVar(Company, 6);
     coAccount := LJVar(AccountCode, 10);
     coCode := LJVar(edtCode.Text, 20);

     coTitle := LJVar(edtTitle.Text, 10);
     coFirstName := LJVar(edtFirstName.Text, 30);
     coSurname := LJVar(edtSurname.Text, 30);
     coPosition := LJVar(edtPosition.Text, 30);
     coSalutation := LJVar(edtSalutation.Text, 20);
     coContactNo := LJVar(edtContactNo.Text, 30);
     coFaxNumber := LJVar(edtFaxNumber.Text, 30);
     coEmailAddr := LJVar(edtEmailAddr.Text, 100);
     coDate := TodaysDate;

//     coAddress1 := LJVar(edAddress1.Text, 35);
//     coAddress2 := LJVar(edAddress2.Text, 35);
//     coAddress3 := LJVar(edAddress3.Text, 35);
//     coAddress4 := LJVar(edAddress4.Text, 35);
     coAddress1 := LJVar(edAddress1.Text, 30);
     coAddress2 := LJVar(edAddress2.Text, 30);
     coAddress3 := LJVar(edAddress3.Text, 30);
     coAddress4 := LJVar(edAddress4.Text, 30);
     coPostCode := LJVar(edPostCode.Text, 10);

  end;
end;

function CheckIndex(s, s1 : ShortString) : Boolean;
begin
  if UpperCase(Trim(s)) = UpperCase(Trim(s1)) then
    Result := True
  else
    Result := False;
end;

(*
function NextContactCode(const Company, Surname : shortstring; bSQL : boolean) : Shortstring;
//Add three digit number to surname and increment until it's unique for this
//company
var
  LStatus : smallInt;
  KeyS : Str255;
  i : integer;
begin
  if bSQL then
  begin
    // MS-SQL
    Result := SQLDataModule.SQLGetNextContactCode(Surname);
  end
  else
  begin
    // Pervasive
    i := 1;
    Repeat
      Result := Copy(UpperCase(Surname), 1, 17) + Copy('000', 1, 3 - Length(IntToStr(i)))
                         + IntToStr(i);
      KeyS := BuildUniqueIndex(Company, Result);
      LStatus := Find_Rec(B_GetEq, F[ContactF],ContactF,RecPtr[ContactF]^,CoUniqueIdx, KeyS);
      inc(i);
    Until LStatus <> 0;

    if LStatus <> 4 {Record not found} then
    begin
      Raise EContactError.Create('Btrieve error ' + IntToStr(LStatus) + ' while creating Contact Code');
    end;{if}
  end;
end;
*)

Initialization
  DefineContactFile;
//  ShowMessage(IntToStr(SizeOf(TContactRecType)));

{$ENDIF} // ChangeComp
end.
