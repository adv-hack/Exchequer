unit VarConst;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}
  Controls, Forms, COMObj, {Enterprise01_TLB,} GlobVar, BtrvU2, SysUtils
  ,Dialogs, Messages, ComCtrls, APIUtil, Enterprise01_TLB;

  procedure ShowBTError(iStatus : integer; sFunction, sFileName : string);
  Procedure OpenFiles;
  Procedure CloseFiles;
//  Function FullNomKey(ncode  :  Longint)  :  Str20;

//type
//  TFormMode = (fmAdd, fmEdit, fmView);
//  EContactError = Class(Exception);

type
  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

const
  IDX_DUMMY_CHAR = '!';
  WM_InPrint = WM_USER + $103;

var
  oToolkit : IToolkit;
  CompanyRec : TCompanyRec;

/////////////////////////
///  Sales Code Type  ///
/////////////////////////
const
  SalesCodeTypeF = 1;

  sctNumOfKeys = 2;
  sctNumSegments = 3;

  sctFolioIdx = 0;
  sctDescriptionIdx = 1;

type
  // Note: This structure has been duplicated in ENTRPRSE\Conversion\v70 SQL Converter\Converter\DataWriteObjs\oSCTypeDataWrite.Pas
  // for the SQL Data Migration - ensure any changes to this structure are duplicated
  TSalesCodeTypeRec = record
    sctFolioNo          : LongInt;
    sctDescription      : string[10];
    sctDummyChar        : char;
    sctSpare            : Array [1..200] of Char;
  end;{TSalesCodeTypeRec}
  // Note: This structure has been duplicated in ENTRPRSE\Conversion\v70 SQL Converter\Converter\DataWriteObjs\oSCTypeDataWrite.Pas
  // for the SQL Data Migration - ensure any changes to this structure are duplicated

  TSalesCodeTypeFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..sctNumSegments] of KeySpec;
    AltColt : AltColtSeq;
  end;

/////////////////////
///  Sales Codes  ///
/////////////////////
const
  SalesCodeF = 2;

  scNumOfKeys = 4;
  scNumSegments = 5;

  scFolioIdx = 0;
  scCodeIdx = 1;
  scDescriptionIdx = 2;
  scSupplierIdx = 3;

type
  // Note: This structure has been duplicated in ENTRPRSE\Conversion\v70 SQL Converter\Converter\DataWriteObjs\oSaleCodeDataWrite.Pas
  // for the SQL Data Migration - ensure any changes to this structure are duplicated
  TSalesCodeRec = record
    scFolioNo           : LongInt;
    scSalesCode         : string[10];
    scDescription       : string[60];
    scSalesCodeType     : LongInt;
    scDefCommissionBasis       : Byte;  // 0 = Total Value, 1 = Margin
    scStatus            : Byte;         // 0 = Inactive, 1 = Active
    scEntSupplierCode   : string[6];
    scEntGLCode         : LongInt;
    scEntCostCentre     : String[3];
    scEntDepartment     : String[3];
    scEntInvCurrency    : Byte;
    scDefCommission     : double;
    scDefCommissionType : byte;         // 0 = Percentage, 1 = Amount
    scDummyChar         : char;
    scSpare             : Array [1..500] of Char;
  end;{TSalesCodeTypeRec}
  // Note: This structure has been duplicated in ENTRPRSE\Conversion\v70 SQL Converter\Converter\DataWriteObjs\oSaleCodeDataWrite.Pas
  // for the SQL Data Migration - ensure any changes to this structure are duplicated

  TSalesCodeFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..scNumSegments] of KeySpec;
    AltColt : AltColtSeq;
  end;

////////////////////
///  Commission  ///
////////////////////
const
  CommissionF = 3;

  cmNumOfKeys = 5;
  cmNumSegments = 12;

  cmFolioIdx = 0;
  cmSalesCodeIdx = 1;
  cmReportIdx = 2;
  cmProductIdx = 3;
  cmProdGroupIdx = 4;

type

  TCommissionType = (ctCustomer, ctCustomerProduct, ctCustomerPGroup, ctProduct, ctPGroup);

  // Note: This structure has been duplicated in ENTRPRSE\Conversion\v70 SQL Converter\Converter\DataWriteObjs\oCommssnDataWrite.Pas
  // for the SQL Data Migration - ensure any changes to this structure are duplicated
  TCommissionRec = record
    cmFolioNo  : LongInt;
    cmSalesCodeFolioNo  : LongInt;
    cmBy              : LongInt; // 0 = Customer
                                // 1 = Customer + Product
                                // 2 = Customer + Product Group
                                // 3 = Product
                                // 4 = Product Group
    cmCustCode          : string[6];
    cmProductCode       : string[16];
    cmPGroupCode        : string[16];

    cmByQty             : boolean;
    cmQtyFrom           : double;
    cmQtyTo             : double;

    cmByCurrency        : boolean;
    cmCurrency          : LongInt;

    cmByDate            : boolean;
    cmStartDate         : string[8];
    cmEndDate           : string[8];

    cmCommissionBasis   : Byte;         // 0 = Total Value, 1 = Margin
    cmCommission        : double;
    cmCommissionType    : byte;         // 0 = Percentage, 1 = Amount

    cmDummyChar         : char;
    cmSpare             : Array [1..300] of Char;
  end;{TSalesCodeTypeRec}
  // Note: This structure has been duplicated in ENTRPRSE\Conversion\v70 SQL Converter\Converter\DataWriteObjs\oCommssnDataWrite.Pas
  // for the SQL Data Migration - ensure any changes to this structure are duplicated

  TCommissionFileDef = Record
    RecLen,
    PageSize,
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    reserved : array[1..4] of Char;
    KeyBuff  : Array[1..cmNumSegments] of KeySpec;
    AltColt : AltColtSeq;
  end;

var
  SalesCodeFile : TSalesCodeFileDef;
  SalesCodeTypeFile : TSalesCodeTypeFileDef;
  CommissionFile : TCommissionFileDef;


implementation

uses
  EtstrU;

Procedure OpenFiles;
var
  iFileNo, iOpenStatus : integer;
  SalesCodeRec  : TSalesCodeRec;
  SalesCodeTypeRec  : TSalesCodeTypeRec;
  CommissionRec : TCommissionRec;

  procedure DefineSCTypeFile;
  begin{DefineSCTypeFile}
    with SalesCodeTypeFile do begin
      FileSpecLen[SalesCodeTypeF]:=Sizeof(SalesCodeTypeFile);
      Fillchar(SalesCodeTypeFile,FileSpecLen[SalesCodeTypeF],0);

      RecLen:=Sizeof(TSalesCodeTypeRec);
      PageSize:=DefPageSize;                     { 1024 bytes }
      NumIndex:=sctNumOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 - sctFolioNo + sctDummyChar
      KeyBuff[1].KeyPos := BtKeyPos(@SalesCodeTypeRec.sctFolioNo, @SalesCodeTypeRec);
      KeyBuff[1].KeyLen := SizeOf(SalesCodeTypeRec.sctFolioNo);
      KeyBuff[1].KeyFlags := ModSeg + ExtType;
      KeyBuff[1].ExtTypeVal := BInteger;
      KeyBuff[2].KeyPos := BtKeyPos(@SalesCodeTypeRec.sctDummyChar, @SalesCodeTypeRec);
      KeyBuff[2].KeyLen := 1;
      KeyBuff[2].KeyFlags := Modfy + AltColSeq;

      // Index 1 - sctDescription
      KeyBuff[3].KeyPos := BtKeyPos(@SalesCodeTypeRec.sctDescription[1], @SalesCodeTypeRec);
      KeyBuff[3].KeyLen := SizeOf(SalesCodeTypeRec.sctDescription) - 1;
      KeyBuff[3].KeyFlags := Modfy + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    end; { With }

    FileRecLen[SalesCodeTypeF]:=Sizeof(SalesCodeTypeRec);
    Fillchar(SalesCodeTypeRec,FileRecLen[SalesCodeTypeF],0);

    RecPtr[SalesCodeTypeF]:=@SalesCodeTypeRec;
    FileSpecOfs[SalesCodeTypeF]:=@SalesCodeTypeFile;

    FileNames[SalesCodeTypeF]:= CompanyRec.Path + 'SalesCom\SCType.dat';
  end;{DefineSCTypeFile}

  Procedure DefineSalesCodeFile;
  Begin{DefineSalesCodeFile}
    With SalesCodeFile do
    begin
      FileSpecLen[SalesCodeF]:=Sizeof(SalesCodeFile);
      Fillchar(SalesCodeFile,FileSpecLen[SalesCodeF],0);

      RecLen:=Sizeof(TSalesCodeRec);
      PageSize:=DefPageSize;                     { 1024 bytes }
      NumIndex:=scNumOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 - scFolioIdx
      // scFolioNo + sctDummyChar
      KeyBuff[1].KeyPos := BtKeyPos(@SalesCodeRec.scFolioNo, @SalesCodeRec);
      KeyBuff[1].KeyLen := SizeOf(SalesCodeRec.scFolioNo);
      KeyBuff[1].KeyFlags := ModSeg + ExtType;
      KeyBuff[1].ExtTypeVal := BInteger;
      KeyBuff[2].KeyPos := BtKeyPos(@SalesCodeRec.scDummyChar, @SalesCodeRec);
      KeyBuff[2].KeyLen := 1;
      KeyBuff[2].KeyFlags := Modfy + AltColSeq;

      // Index 1 - scSalesCode
      // scSalesCode
      KeyBuff[3].KeyPos := BtKeyPos(@SalesCodeRec.scSalesCode[1], @SalesCodeRec);
      KeyBuff[3].KeyLen := SizeOf(SalesCodeRec.scSalesCode) - 1;
      KeyBuff[3].KeyFlags := Modfy + AltColSeq;

      // Index 2 - scDescriptionIdx
      // scDescription
      KeyBuff[4].KeyPos := BtKeyPos(@SalesCodeRec.scDescription[1], @SalesCodeRec);
      KeyBuff[4].KeyLen := SizeOf(SalesCodeRec.scDescription) - 1;
      KeyBuff[4].KeyFlags := DupMod + AltColSeq;

      // Index 3 - scSupplierIdx
      KeyBuff[5].KeyPos := BtKeyPos(@SalesCodeRec.scEntSupplierCode[1], @SalesCodeRec);
      KeyBuff[5].KeyLen := SizeOf(SalesCodeRec.scEntSupplierCode) - 1;
      KeyBuff[5].KeyFlags := DupMod + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    End; { With }

    FileRecLen[SalesCodeF]:=Sizeof(SalesCodeRec);
    Fillchar(SalesCodeRec,FileRecLen[SalesCodeF],0);

    RecPtr[SalesCodeF]:=@SalesCodeRec;
    FileSpecOfs[SalesCodeF]:=@SalesCodeFile;

    FileNames[SalesCodeF]:= CompanyRec.Path + 'SalesCom\SaleCode.dat';
  end;{DefineSalesCodeFile}

  Procedure DefineCommissionFile;
  Begin{DefineCommissionFile}
    With CommissionFile do
    begin
      FileSpecLen[CommissionF]:=Sizeof(CommissionFile);
      Fillchar(CommissionFile,FileSpecLen[CommissionF],0);

      RecLen:=Sizeof(TCommissionRec);
      PageSize:=DefPageSize;                     { 1024 bytes }
      NumIndex:=cmNumOfKeys;

      Variable:=B_Variable+B_Compress+B_BTrunc;  { Used for max compression }

      // Index 0 - cmFolioIdx
      // cmFolioNo + cmDummyChar
      KeyBuff[1].KeyPos := BtKeyPos(@CommissionRec.cmFolioNo, @CommissionRec);
      KeyBuff[1].KeyLen := SizeOf(CommissionRec.cmFolioNo);
      KeyBuff[1].KeyFlags := ModSeg + ExtType;
      KeyBuff[1].ExtTypeVal := BInteger;
      KeyBuff[2].KeyPos := BtKeyPos(@CommissionRec.cmDummyChar, @CommissionRec);
      KeyBuff[2].KeyLen := 1;
      KeyBuff[2].KeyFlags := Modfy + AltColSeq;

      // Index 1 - cmSalesCodeIdx
      // cmSalesCodeFolioNo + cmBy + cmCustCode + cmProductCode + cmPGroupCode
      KeyBuff[3].KeyPos := BtKeyPos(@CommissionRec.cmSalesCodeFolioNo, @CommissionRec);
      KeyBuff[3].KeyLen := SizeOf(CommissionRec.cmSalesCodeFolioNo);
      KeyBuff[3].KeyFlags := DupModSeg + ExtType;
      KeyBuff[3].ExtTypeVal := BInteger;

      KeyBuff[4].KeyPos := BtKeyPos(@CommissionRec.cmBy, @CommissionRec);
      KeyBuff[4].KeyLen := SizeOf(CommissionRec.cmBy);
      KeyBuff[4].KeyFlags := DupModSeg + ExtType;
      KeyBuff[4].ExtTypeVal := BInteger;

      KeyBuff[5].KeyPos := BtKeyPos(@CommissionRec.cmCustCode[1], @CommissionRec);
      KeyBuff[5].KeyLen := SizeOf(CommissionRec.cmCustCode) - 1;
      KeyBuff[5].KeyFlags := DupModSeg + AltColSeq;

      KeyBuff[6].KeyPos := BtKeyPos(@CommissionRec.cmProductCode[1], @CommissionRec);
      KeyBuff[6].KeyLen := SizeOf(CommissionRec.cmProductCode) - 1;
      KeyBuff[6].KeyFlags := DupModSeg + AltColSeq;

      KeyBuff[7].KeyPos := BtKeyPos(@CommissionRec.cmPGroupCode[1], @CommissionRec);
      KeyBuff[7].KeyLen := SizeOf(CommissionRec.cmPGroupCode) - 1;
      KeyBuff[7].KeyFlags := DupMod + AltColSeq;

      // Index 2 - cmReportIdx
      // cmCustCode + cmProductCode + cmPGroupCode
      KeyBuff[8].KeyPos := BtKeyPos(@CommissionRec.cmCustCode[1], @CommissionRec);
      KeyBuff[8].KeyLen := SizeOf(CommissionRec.cmCustCode) - 1;
      KeyBuff[8].KeyFlags := DupModSeg + AltColSeq;

      KeyBuff[9].KeyPos := BtKeyPos(@CommissionRec.cmProductCode[1], @CommissionRec);
      KeyBuff[9].KeyLen := SizeOf(CommissionRec.cmProductCode) - 1;
      KeyBuff[9].KeyFlags := DupModSeg + AltColSeq;

      KeyBuff[10].KeyPos := BtKeyPos(@CommissionRec.cmPGroupCode[1], @CommissionRec);
      KeyBuff[10].KeyLen := SizeOf(CommissionRec.cmPGroupCode) - 1;
      KeyBuff[10].KeyFlags := DupMod + AltColSeq;

      // Index 3 - cmProductIdx
      // cmProductCode
      KeyBuff[11].KeyPos := BtKeyPos(@CommissionRec.cmProductCode[1], @CommissionRec);
      KeyBuff[11].KeyLen := SizeOf(CommissionRec.cmProductCode) - 1;
      KeyBuff[11].KeyFlags := DupMod + AltColSeq;

      // Index 4 - cmProdGroupIdx
      // cmPGroupCode
      KeyBuff[12].KeyPos := BtKeyPos(@CommissionRec.cmPGroupCode[1], @CommissionRec);
      KeyBuff[12].KeyLen := SizeOf(CommissionRec.cmPGroupCode) - 1;
      KeyBuff[12].KeyFlags := DupMod + AltColSeq;

      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
    End; { With }

    FileRecLen[CommissionF]:=Sizeof(CommissionRec);
    Fillchar(CommissionRec,FileRecLen[CommissionF],0);

    RecPtr[CommissionF]:=@CommissionRec;
    FileSpecOfs[CommissionF]:=@CommissionFile;

    FileNames[CommissionF]:= CompanyRec.Path + 'SalesCom\Commssn.dat';
  end;{DefineCommissionFile}

begin
  // initialise filenames array
  FillChar(FileNames^, SizeOf(FileNames^),#0);

  // define file structures
  DefineSCTypeFile;
  DefineSalesCodeFile;
  DefineCommissionFile;

  {$IFDEF EXSQL}
    {$IFDEF SALESCOMADMIN}
      OpenCompany(CompanyRec.Path);
    {$ENDIF}
  {$ENDIF}

  // open files
  iOpenStatus := 0;
  for iFileNo := 1 to MaxFiles do begin
    if Trim(FileNames[iFileNo]) <> '' then begin
      iOpenStatus := 0;

      {$IFDEF EXSQL}
        if not TableExists(FileNames[iFileNo])
      {$ELSE}
        if not FileExists(FileNames[iFileNo])
      {$ENDIF}
        then begin
          iOpenStatus := Make_File(F[iFileNo],FileNames[iFileNo], FileSpecOfs[iFileNo]^,FileSpecLen[iFileNo]);
          ShowBTError(iOpenStatus, 'Make_File', FileNames[iFileNo]);
        end;{if}
      {...}

      if iOpenStatus = 0 then begin
        iOpenStatus := Open_File(F[iFileNo], FileNames[iFileNo], 0);
        ShowBTError(iOpenStatus, 'Open_File', FileNames[iFileNo]);
      end;
    end;{if}
  end;{for}
end;

procedure CloseFiles;
var
  iFileNo : integer;
begin
  for iFileNo := 1 to MaxFiles do begin
    if Trim(FileNames[iFileNo]) <> '' then Close_File(F[iFileNo]);
  end;{for}
end;

procedure ShowBTError(iStatus : integer; sFunction, sFileName : string);
begin
  if iStatus <> 0 then begin
    MsgBox('Btrieve Error ' + IntToStr(iStatus) + ' occurred whilst executing the command '
    + QuotedStr(sFunction) + ' on the file ' + QuotedStr(sFileName)
    , mtError, [mbOK], mbOK, 'Btrieve Error');
  end;
end;

Initialization
{  ShowMessage(IntToStr(SizeOf(TCommissionRec)));
  ShowMessage(IntToStr(SizeOf(TSalesCodeRec)));
  ShowMessage(IntToStr(SizeOf(TSalesCodeTypeRec)));}



end.
