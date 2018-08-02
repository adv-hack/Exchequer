unit RwOpenF;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ This module is used to automatically open any files }
{ needed by the report writer which are not normally  }
{ opened by Enterprise:                               }
{                                                     }
{     17  Data Dictionary                             }
{     18  Reports                                     }
{                                                     }

interface

Uses GlobVar,
     VarConst,
     BtrvU2,
     VarRec2U;

{$H-}   { Huge strings off }

 {$I VarRecRP.Pas}

Const
  RepGrpLen = 10;
  ExportSig =  'ExRepExp';   { Used in the import/export routines }

Type
  PrintNotifyType = Record
    RepName  : String[10];   {  Rep Code }
  End; { PrintNotifyType }
  PrintNotifyPtr = ^PrintNotifyType;

Var
  DictRec     : ^DataDictRec;
  DictFile    : ^DataDict_FileDef;

  RepGenRecs  : ^RepGenRec;
  RepGenFile  : ^RepGen_FileDef;

  ExVersionNo : SmallInt;
  ExMultiCcy  : Boolean;

  RepRunCount : LongInt;

  GroupRepRec : ^RepGenRec;

  PrntOk      : Boolean;


Procedure Close_RW_Files;

Function FullRepCode(CCode  :  Str10) :  AnyStr;

Function FullDictCode(CCode  :  Str10) :  AnyStr;

implementation

Uses
  Dialogs,
  SysUtils,
  VarFPosU,
  EtStrU,
{$IFDEF EX600}
  FileUtil,
{$ENDIF}
  Forms;

Const
  VerParamStr = '/EXV:';

Var
  ExitSave : Pointer;
{$IFDEF EX600}
  StoredSetDrive: string;
{$ENDIF}

Procedure DefineDataDict;

Const
  Idx = DictF;

Begin
  With DictFile^ do
  Begin
    FileSpecLen[Idx]:=Sizeof(DictFile^);                      { <<<<<<<<******** Change }
    Fillchar(DictFile^,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(DictRec^);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;
    NumIndex:=DINofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}


    { 00 - (RecPfix+SubType) + VarName (DIK)  }                     { <<<<<<<<******** Change }

    KeyBuff[1].KeyPos:=1;
    KeyBuff[1].KeyLen:=2;
    KeyBuff[1].KeyFlags:=DupModSeg;

    KeyBuff[2].KeyPos:=4;
    KeyBuff[2].KeyLen:=14;
    KeyBuff[2].KeyFlags:=DupMod;


    { 01 - (RecPfix+SubType) +  Var Desc [1..10] (DISecK)  }                     { <<<<<<<<******** Change }

    KeyBuff[3].KeyPos:=1;
    KeyBuff[3].KeyLen:=2;
    KeyBuff[3].KeyFlags:=DupModSeg+Mank;

    KeyBuff[4].KeyPos:=19;
    KeyBuff[4].KeyLen:=10;
    KeyBuff[4].KeyFlags:=DupMod+Mank;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(DictRec^);                             { <<<<<<<<******** Change }

  Fillchar(DictRec^,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  {$IFDEF EXWIN}
    RecPtr[Idx]:=@DictRec^;
    FileSpecOfs[Idx]:=@DictFile^;
  {$ELSE}
    RecPtr[Idx]:=Ptr(Seg(DictRec^),Ofs(DictRec^));                 { <<<<<<<<******** Change }
    FileSpecOfs[Idx]:=Ptr(Seg(DictFile^),Ofs(DictFile^));    { <<<<<<<<******** Change }
  {$ENDIF}

  FileNames[Idx]:=Path5+RepDictNam;                         { <<<<<<<<******** Change }


  {$IFNDEF EXWIN}
    If (Debug) then Begin
      Writeln('Dict : .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
    end;
  {$ENDIF}

end; {..}

    Procedure Define_PVar;
    Begin

      {* If any of these data files change, alter GetDataFile Menu exclusions *}
      DataFilesL^[1]:='Customer';
      DataFilesL^[2]:='Supplier';
      DataFilesL^[3]:='Document Header';
      DataFilesL^[4]:='Document Details';
      DataFilesL^[5]:='Nominal';
      DataFilesL^[6]:='Stock';
      DataFilesL^[7]:='Cost Centre';
      DataFilesL^[8]:='Department';
      DataFilesL^[9]:='Fixed Asset Register';
      DataFilesL^[10]:='Bill Of Materials';     {*431RW HM 29/03/00: Added }
      DataFilesL^[11]:='Job Costing';
      DataFilesL^[12]:='Multi Loc Stock';
      DataFilesL^[13]:='User List';
      DataFilesL^[14]:='Discount Matrix';       {*431RW HM 03/04/00: Added }
      DataFilesL^[15]:='Job Notes';             {*431RW HM 29/03/00: Added }
      DataFilesL^[16]:='Serial/Batch';

      { MH - 06/05/97: New Files added }
      DataFilesL^[17]:='Analysis Codes';
      DataFilesL^[18]:='Job Types';
      DataFilesL^[19]:='Time Rates';
      DataFilesL^[20]:='FIFO';                  {*431RW HM 29/03/00: Added }
      DataFilesL^[21]:='Employees';
      DataFilesL^[22]:='Job Records';
      DataFilesL^[23]:='Job Actuals';
      DataFilesL^[24]:='Job Retentions';
      DataFilesL^[25]:='Job Budgets';
      DataFilesL^[26]:='Locations';
      DataFilesL^[27]:='Stock Locations';

      {$IFDEF RW}
      { HM 25/01/99: Matched Payments added }
      DataFilesL^[28]:='Matched Payments';

      {*431RW HM 03/04/00: Added more files }
      DataFilesL^[29]:='Customer Notes';
      DataFilesL^[30]:='Supplier Notes';
      DataFilesL^[31]:='Stock Notes';
      DataFilesL^[32]:='Trans Notes';
      {$ENDIF}

      {$IFNDEF EDLL}
      // HM 17/01/03: Added CIS Vouchers for Win RW
      DataFilesL^[33]:='CIS Vouchers';
      {$ENDIF}

      {$IFNDEF EDLL}
      // HM 08/09/03: Added Multi-Bin support for Win RW (v5.52)
      DataFilesL^[34]:='Multi-Bins';
      {$ENDIF}

      {$IFNDEF EDLL}
      //PR: 11/03/09: Added AltStock Codes
      DataFilesL^[35]:='Alt Stock Codes';
      //PR: 10/06/09: Added Multi-Buy Discounts
      DataFilesL^[36]:='Multi-Buy Discounts';

      //PR: 10/02/2012: Added Qty Breaks ABSEXCH-9795
      DataFilesL^[37]:='Qty Breaks';

      //PR: 30/01/2014 ABSEXCH-14974
      DataFilesL^[38] := 'A/C Contact Roles';

      //PR: 14/10/2014 Order Payments (OPVATPay.Dat)
      DataFilesL^[39] := 'Order Payments';
      {$ENDIF}


      ExVersL^[1]:='STD';
      ExVersL^[2]:='STD+STK';
      ExVersL^[3]:='Prof';
      ExVersL^[4]:='Prof+STK';
      ExVersL^[5]:='Prof+SPOP';
      ExVersL^[6]:='Prof+SPOP+JC';
      ExVersL^[7]:='MC';
      ExVersL^[8]:='MC+STK';
      ExVersL^[9]:='MC+SPOP';

      ExVersL^[11]:='MC+SPOP+JC';


      DataTypesL^[1]:='String';
      DataTypesL^[2]:='Real';
      DataTypesL^[3]:='Double';
      DataTypesL^[4]:='Date';
      DataTypesL^[5]:='Char';
      DataTypesL^[6]:='Longint';
      DataTypesL^[7]:='Integer';
      DataTypesL^[8]:='Byte';
      DataTypesL^[9]:='Currency';
      DataTypesL^[10]:='Period';
      DataTypesL^[11]:='Yes/No';
      DataTypesL^[12]:='Time';

      DataTCharL^[1]:='S';
      DataTCharL^[2]:='R';
      DataTCharL^[3]:='P';
      DataTCharL^[4]:='D';
      DataTCharL^[5]:='C';
      DataTCharL^[6]:='L';
      DataTCharL^[7]:='I';
      DataTCharL^[8]:='B';
      DataTCharL^[9]:='U';
      DataTCharL^[10]:='E';
      DataTCharL^[11]:='Y';
      DataTCharL^[12]:='T';

      DecTypesL^[1]:='Cost Price';
      DecTypesL^[2]:='Sale Price';
      DecTypesL^[3]:='Qty';

      BreakTypL^[1]:='No';
      BreakTypL^[2]:='On';
      BreakTypL^[3]:='Line';
      BreakTypL^[4]:='Page';


      RepHedTypesL^[1]:='Group Heading';
      RepHedTypesL^[2]:='Line Based Report';
      RepHedTypesL^[3]:='Nominal Based Report';

      OutPutL^[1]:='Printer';
      OutPutL^[2]:='CDF';

      RepInpTypesL^[1]:='Date';
      RepInpTypesL^[2]:='Period';
      RepInpTypesL^[3]:='Value';
      RepInpTypesL^[4]:='ASCII';
      RepInpTypesL^[5]:='Currency';
      RepInpTypesL^[6]:='Document No.';
      RepInpTypesL^[7]:='Customer Code';
      RepInpTypesL^[8]:='Supplier Code';
      RepInpTypesL^[9]:='Nominal Code';
      RepInpTypesL^[10]:='Stock Code';
      RepInpTypesL^[11]:='Cost Centre Code';
      RepInpTypesL^[12]:='Department Code';
      RepInpTypesL^[13]:='Location Code';
      RepInpTypesL^[14]:='Serial No.';
      RepInpTypesL^[15]:='Batch No.';
      RepInpTypesL^[16]:='Fixed Asset No.';
      RepInpTypesL^[17]:='Job Code';

      PrintEffectL^[1]:='12 CPI (Elite)';
      PrintEffectL^[2]:='10 CPI (Pica)';
      PrintEffectL^[3]:='15 CPI (Condensed)';
      PrintEffectL^[4]:='Enlarged';
      PrintEffectL^[5]:='Verticly Enlarged';
      PrintEffectL^[6]:='Emphasised';
      PrintEffectL^[7]:='Double Strike';
      PrintEffectL^[8]:='Underlined';
      PrintEffectL^[9]:='Italics';
      PrintEffectL^[10]:='';
      PrintEffectL^[11]:='High Quality';

      { Document Header }
      FastNDXHedL^[3,0]:='Sequential';
      FastNDXHedL^[3,1]:='Document No.';     FastNDXOrdL^[3,1]:=1;
      FastNDXHedL^[3,2]:='Account Code';     FastNDXOrdL^[3,2]:=2;
      FastNDXHedL^[3,3]:='Unposted Docs';    FastNDXOrdL^[3,3]:=3;
      FastNDXHedL^[3,4]:='Posted Docs';      FastNDXOrdL^[3,4]:=4;
      FastNDXHedL^[3,5]:='O/S SOR/SDN';      FastNDXOrdL^[3,5]:=5;
      FastNDXHedL^[3,6]:='Hist SOR';         FastNDXOrdL^[3,6]:=6;
      FastNDXHedL^[3,7]:='O/S POR/PDN';      FastNDXOrdL^[3,7]:=7;
      FastNDXHedL^[3,8]:='Hist POR';         FastNDXOrdL^[3,8]:=8;
      FastNDXHedL^[3,9]:='Folio Number';     FastNDXOrdL^[3,9]:=9;
      FastNDXHedL^[3,10]:='Your Ref (Short)';FastNDXOrdL^[3,10]:=10;
      FastNDXHedL^[3,11]:='Your Ref (Long)'; FastNDXOrdL^[3,11]:=11;
      FastNDXHedL^[3,12]:='Document Date';   FastNDXOrdL^[3,12]:=12;
      FastNDXHedL^[3,13]:='Document Period'; FastNDXOrdL^[3,13]:=13;
      FastNDXHedL^[3,14]:='Outstanding';     FastNDXOrdL^[3,14]:=50;

      { Document Lines }
      FastNDXHedL^[4,0]:='Sequential';
      FastNDXHedL^[4,1]:='Folio Number';        FastNDXOrdL^[4,1]:=14;
      FastNDXHedL^[4,2]:='Unposted Docs';       FastNDXOrdL^[4,2]:=15;
      FastNDXHedL^[4,3]:='Posted Docs';         FastNDXOrdL^[4,3]:=16;
      FastNDXHedL^[4,4]:='Stk Sales (Exc SOR)'; FastNDXOrdL^[4,4]:=17;
      FastNDXHedL^[4,5]:='O/S SOR';             FastNDXOrdL^[4,5]:=18;
      FastNDXHedL^[4,6]:='O/S SDN';             FastNDXOrdL^[4,6]:=19;
      FastNDXHedL^[4,7]:='Stk Purch (Exc POR)'; FastNDXOrdL^[4,7]:=20;
      FastNDXHedL^[4,8]:='O/S POR';             FastNDXOrdL^[4,8]:=21;
      FastNDXHedL^[4,9]:='O/S PDN';             FastNDXOrdL^[4,9]:=22;
      FastNDXHedL^[4,10]:='SQU';                FastNDXOrdL^[4,10]:=23;
      FastNDXHedL^[4,11]:='PQU';                FastNDXOrdL^[4,11]:=24;
      FastNDXHedL^[4,12]:='ADJ';                FastNDXOrdL^[4,12]:=25;
      FastNDXHedL^[4,13]:='Nominal Code Posted';FastNDXOrdL^[4,13]:=26;
      FastNDXHedL^[4,14]:='Stock Code';         FastNDXOrdL^[4,14]:=27;
      FastNDXHedL^[4,15]:='Account Code';       FastNDXOrdL^[4,15]:=28;
      FastNDXHedL^[4,16]:='Document No.';       FastNDXOrdL^[4,16]:=29;
      FastNDXHedL^[4,17]:='Document Date';      FastNDXOrdL^[4,17]:=30;
      FastNDXHedL^[4,18]:='Document Period';    FastNDXOrdL^[4,18]:=31;
      {$IFDEF RW}
      FastNDXHedL^[4,19]:='Unreconciled';       FastNDXOrdL^[4,19]:=51;
      FastNDXHedL^[4,20]:='Reconciled';         FastNDXOrdL^[4,20]:=52;
      {$ENDIF}

      { Job Actuals Indices }
      FastNDXHedL^[23,0]:='Sequential';
      FastNDXHedL^[23,1]:='Folio Number';        FastNDXOrdL^[23,1]:=32;
      FastNDXHedL^[23,2]:='Unposted Docs';       FastNDXOrdL^[23,2]:=33;
      FastNDXHedL^[23,3]:='Posted Docs';         FastNDXOrdL^[23,3]:=34;
      FastNDXHedL^[23,4]:='Stk Sales (Exc SOR)'; FastNDXOrdL^[23,4]:=35;
      FastNDXHedL^[23,5]:='O/S SOR';             FastNDXOrdL^[23,5]:=36;
      FastNDXHedL^[23,6]:='O/S SDN';             FastNDXOrdL^[23,6]:=37;
      FastNDXHedL^[23,7]:='Stk Purch (Exc POR)'; FastNDXOrdL^[23,7]:=38;
      FastNDXHedL^[23,8]:='O/S POR';             FastNDXOrdL^[23,8]:=39;
      FastNDXHedL^[23,9]:='O/S PDN';             FastNDXOrdL^[23,9]:=40;
      FastNDXHedL^[23,10]:='SQU';                FastNDXOrdL^[23,10]:=41;
      FastNDXHedL^[23,11]:='PQU';                FastNDXOrdL^[23,11]:=42;
      FastNDXHedL^[23,12]:='ADJ';                FastNDXOrdL^[23,12]:=43;
      FastNDXHedL^[23,13]:='Nominal Code Posted';FastNDXOrdL^[23,13]:=44;
      FastNDXHedL^[23,14]:='Stock Code';         FastNDXOrdL^[23,14]:=45;
      FastNDXHedL^[23,15]:='Account Code';       FastNDXOrdL^[23,15]:=46;
      FastNDXHedL^[23,16]:='Document No.';       FastNDXOrdL^[23,16]:=47;
      FastNDXHedL^[23,17]:='Document Date';      FastNDXOrdL^[23,17]:=48;
      FastNDXHedL^[23,18]:='Document Period';    FastNDXOrdL^[23,18]:=49;
    end; {Proc..}

Function FullRepCode(CCode  :  Str10) :  AnyStr;
Begin
  Result:=UpcaseStr(LJVar(Ccode,10));
end;

Function FullDictCode(CCode  :  Str10) :  AnyStr;
Begin
  Result:=UpcaseStr(LJVar(Ccode,8));
End;

{ Processes the command line parameters }
Procedure ProcessParams;
Var
  Tmp1       : ShortString;
  I, ErrCode : Integer;
Begin
  If (ParamCount > 0) Then
    For I := 1 To ParamCount Do Begin
      { Check for Exch Version flag }
      If (Copy (ParamStr(I), 1, Length(VerParamStr)) = VerParamStr) Then Begin
        { Got Exchequer version value }
        Tmp1 := Copy (ParamStr(I), (Length(VerParamStr) + 1), (Length(ParamStr(I)) - Length(VerParamStr)));
        Val (Tmp1, ExVersionNo, ErrCode);
      End; { If }
    End; { For }

  ExMultiCcy := (ExVersionNo >= 7);
End;


{ Closes any files opened in this module }
Procedure Close_RW_Files; Far;
Begin
  { restore ExitProc chain }
  ExitProc := ExitSave;

  { Close Btrieve files }
//  Close_Files(BOn);

  { de-allocate memory }
  FreeMem (DictRec, SizeOf (DictRec^));
  FreeMem (DictFile, SizeOf (DictFile^));
  FreeMem (RepGenRecs, SizeOf (RepGenRecs^));
  FreeMem (RepGenFile, SizeOf (RepGenFile^));
  FreeMem (GroupRepRec, SizeOf (GroupRepRec^));
End;


Procedure DefineRepGenRecs;
Const
  Idx = RepGenF;

Begin
  With RepGenFile^ do
  Begin
    FileSpecLen[Idx]:=Sizeof(RepGenFile^);                      { <<<<<<<<******** Change }
    Fillchar(RepGenFile^,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(RepGenRecs^);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;
    NumIndex:=RGNofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}


    { 00 - (RecMfix+SubType) + ReportKey (RGK)  }                     { <<<<<<<<******** Change }

    KeyBuff[1].KeyPos:=1;
    KeyBuff[1].KeyLen:=2;
    KeyBuff[1].KeyFlags:=DupModSeg;

    KeyBuff[2].KeyPos:=4;
    KeyBuff[2].KeyLen:=20;
    KeyBuff[2].KeyFlags:=DupMod;


    { 01 - (RecPfix+SubType) + VarName (MiscNdxK)  }                     { <<<<<<<<******** Change }

    KeyBuff[3].KeyPos:=1;
    KeyBuff[3].KeyLen:=2;
    KeyBuff[3].KeyFlags:=DupModSeg+Mank;

    KeyBuff[4].KeyPos:=51;
    KeyBuff[4].KeyLen:=10;
    KeyBuff[4].KeyFlags:=DupMod+Mank;


    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}

  FileRecLen[Idx]:=Sizeof(RepGenRecs^);                             { <<<<<<<<******** Change }

  Fillchar(RepGenRecs^,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  {$IFDEF EXWIN}
    RecPtr[Idx]:=@RepGenRecs^;
    FileSpecOfs[Idx]:=@RepGenFile^;
  {$ELSE}
    RecPtr[Idx]:=Ptr(Seg(RepGenRecs^),Ofs(RepGenRecs^));                 { <<<<<<<<******** Change }
    FileSpecOfs[Idx]:=Ptr(Seg(RepGenFile^),Ofs(RepGenFile^));    { <<<<<<<<******** Change }
  {$ENDIF}

  FileNames[Idx]:=Path5+RepRepNam;                         { <<<<<<<<******** Change }


  {$IFNDEF EXWIN}
    If (Debug) then
    Begin
      Writeln('RGen File: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
    end;
  {$ENDIF }
end; {..}


Initialization
  { setup an ExitProc to automatically close an open files }
  ExitSave := ExitProc;
  ExitProc := @Close_RW_Files;

  ExVersionNo := 1;
  ProcessParams;

  { allocate memory for file records }
  GetMem (DictRec, SizeOf (DictRec^));
  GetMem (DictFile, SizeOf (DictFile^));
  GetMem (GroupRepRec, SizeOf (GroupRepRec^));
  GetMem (RepGenFile, SizeOf(RepGenFile^));
  GetMem (RepGenRecs, SizeOf(RepGenRecs^));

  { Define Btrieve structures }
  DefineDataDict;
  DefineRepGenRecs;
  Define_PVar;

  { open files }
  TotFiles := RepGenF;
  if (Trim(SetDrive) = '') then
    SetDrive := ExtractFilePath(Application.ExeName);
{$IFNDEF REP_ENGINE}
  Open_System(SysF, SysF);
  {$IFDEF EX600}

    { Open DICTNARY.DAT in the main company }
    StoredSetDrive := SetDrive;
    SetDrive := GetEnterpriseDirectory;
    try
      Open_System(DictF,DictF);               // Data Dictionary
    finally
      SetDrive := StoredSetDrive;
    end;

  {$ELSE}
    Open_System(DictF,DictF);               // Data Dictionary
  {$ENDIF}
{$ENDIF REP_ENGINE}
Finalization

end.
