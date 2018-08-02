{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 18/10/92                      }
{                                                              }
{                  Variable Record Definitions                 }
{                                                              }
{               Copyright (C) 1992 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

Const
  MaxNomTots     =  30;

{ ================ Data Dictionary Control File ============= }
Const
  // MH 05/06/06: Changed to 18 as NomViews is now 17.
  //DictF     =     17;
  DictF     =     18;

  DINofKeys =     2;

  DIK       =     0;
  DISecK    =     1;

  DINofSegs =     4;



Type
    { ================ Data Dictionary Record ================ }


    DataVarType  = Record
               {002}  VarName   :  String[10];   {  Variable Key }
               {012}  Spare     :  Array[1..4] of Byte;
               {017}  VarPadNo  :  String[10];   {  Padded version of variable no.}
               {028}  VarDesc   :  String[30];   {  Variable Full Description }
               {058}  VarNo     :  LongInt;      {  Variable Cross Ref Link }
               {063}  RepDesc   :  String[30];   {  Report Header Field }
               {093}  AvailFile :  LongInt;      {  Cross Link display list }
               {097}  AvailVer  :  LongInt;      {  Available version }
               {101}  PrSel     :  Boolean;      {  Period Select type }
               {102}  VarType   :  Byte;         {  Variable Type }
               {103}  VarLen    :  Byte;         {  Variable Std Length }
               {104}  VarNoDec  :  Byte;         {  No Dec Places }
               {105}  VarDec    :  Boolean;      {  Dec set by user }
               {106}  VarDecType:  Byte;         {  Dec Type ie Cost price/Sell Price }
               {108}  Format    :  String[30];   {  Format Mask }
               {138}  NLineCount:  LongInt;      {  Note Line Count }
               {142}  InputType :  Byte;         {  Required Input Type }
               {143}  AvailFile2:  LongInt;      {  Extended Cross Link display }
                      Spare2    :  Array[1..107] of Byte;
                    end;


    { ================ Data Cross Reference Record ================ }


    DataXRefType  = Record
               {002}  VarKey    :  String[14];   {  ExVersion + File No + Variable Name}
               {017}  VarName   :  String[10];   {  Variable Full Description }
               {027}  Spare     :  Array[1..20] of Byte;
    {$IFDEF EXWIN}
               {047}  VarFileNo :  SmallInt;     {  File Variable Belongs in}
               {049}  VarExVers :  SmallInt;     {  Ex Version Var belongs in }
    {$ELSE}
               {047}  VarFileNo :  Integer;      {  File Variable Belongs in}
               {049}  VarExVers :  Integer;      {  Ex Version Var belongs in }
    {$ENDIF}
               {051}  Spare2    :  Array[1..204] of Byte;
                    end;


    DNotesType    =  Record
              {002}   NoteNo    :  String[14];   { Folio/CustCode + NType + LineNo}

              {017}   NoteDate  :  LongDate;

              {025}   Spare3    :  Array[1..7] of Byte;

              {032}   Spare4    :  Array[1..5] of Byte;

              {037}   Spare5    :  Array[1..11] of Byte;

              {049}   NoteAlarm :  LongDate;

              {058}   NoteFolio :  String[10];

              {068}   NType     :  Char;

              {069}   LineNo    :  LongInt;

              {074}   NoteLine  :  String[100]; { Note Line }

              {175}   NoteUser  :  String[10];  { Note owner }

              {185}   Spare2    :  Array[1..70] of Byte;
                    end;




        { ================ Notes Record db List =============== }



    DataDictPtr  =  ^DataDictRec;


    DataDictRec  =  Record
                      RecPfix   :  Char;         {  Record Prefix }
                      SubType   :  Char;         {  Subsplit Record Type }



 {$IFDEF EXWIN}
                      Case SmallInt of
 {$ELSE}
                      Case Integer of
 {$ENDIF}

                        1  :  (DataVarRec    :  DataVarType);
                        2  :  (DataXRefRec   :  DataXRefType);
                        3  :  (DNotesRec     :  DNotesType);


                    end;


    DataDict_FilePtr   =   ^DataDict_FileDef;

    DataDict_FileDef   =   Record
 {$IFDEF EXWIN}
                             RecLen,
                             PageSize,
                             NumIndex  :  SmallInt;
                             NotUsed   :  LongInt;
                             Variable  :  SmallInt;
 {$ELSE}
                             RecLen,
                             PageSize,
                             NumIndex  :  Integer;
                             NotUsed   :  LongInt;
                             Variable  :  Integer;
 {$ENDIF}
                             Reserved  :  array[1..4] of Char;
                             KeyBuff   :  array[1..DINofSegs] of KeySpec;
                             AltColt   :  AltColtSeq;
                           end;

{$IFNDEF DICTEDIT}
{ ================ Stock Misc File ============= }

Const
  // MH 05/06/06: Changed to 19 as NomViews is now 17 and DictF is 18.
  //RepGenF   =     18;
  RepGenF   =     19;

  RGNofKeys =     2;

  RGK       =     0;
  RGNdxK    =     1;

  RGNofSegs =     4;



Type
    ReportFontType = Record
    {01}  fName  :  String[32];       { Font Name }
    {34}  fSize  :  SmallInt;         { Font Size }
    {36}  fColor :  LongInt;          { TColor - Font Color }
    {40}  fStyle :  Byte;             { TFontStyles - Bold, Italic, etc }
    {41}  fPitch :  Byte;             { TFontPitch - }
    End; { ReportFontType }

    FieldFontType = Record
    {01}  fColor :  LongInt;          { TColor - Font Color }
    {05}  fStyle :  Byte;             { TFontStyles - Bold, Italic, etc }
    End; { FieldFontType }

    { ================ Report Header Record ================ }

    ReportHedType  = Record
               {002}  ReportKey :  String[20];   {  Report Group+Report Code}
               {023}  RepGroup  :  String[10];   {  Directory Group }
               {033}  Spare2    :  Array[1..15] of Char;
               {049}  RepName   :  String[10];   {  Rep Code }
               {060}  RepDesc   :  String[130];  {  Rep Title }
         {$IFDEF EXWIN}
               {190}  DriveFile :  SmallInt;     {  Driving Fnum }
               {192}  DrivePath :  SmallInt;     {  Driving Path }
               {194}  MaxWidth  :  SmallInt;     {  Current Report Width}
               {196}  MaxCount  :  LongInt;      {  Include Max Items }
               {200}  RepDest   :  SmallInt;     {  Report default destination }
         {$ELSE}
               {190}  DriveFile :  Integer;      {  Driving Fnum }
               {192}  DrivePath :  Integer;      {  Driving Path }
               {194}  MaxWidth  :  Integer;      {  Current Report Width}
               {196}  MaxCount  :  LongInt;      {  Include Max Items }
               {200}  RepDest   :  Integer;      {  Report default destination }
         {$ENDIF}
               {203}  RepSelect :  String[100];  {  Overall selection criteria }
               {303}  RLineCount:  LongInt;      {  Count of variables / next No. }
               {307}  HLineCount:  LongInt;      {  No Headings Count }
               {312}  LastRun   :  LongDate;         {  LAst Report Run Date }
               {321}  LastOpo   :  String[10];   {  Last Operator }
               {331}  RepType   :  Char;         {  Report / Group Item }
         {$IFDEF EXWIN}
               {332}  RepPgLen  :  SmallInt;     {  Report Page Length }
         {$ELSE}
               {332}  RepPgLen  :  Integer;      {  Report Page Length }
         {$ENDIF}
               {334}  ILineCount:  LongInt;      {  No Input Vars Count }
               {338}  TotLevels :  Byte;         {  No Nested Totals }
               {339}  NLineCount:  LongInt;      {  Note Line Count }
               {344}  LastPath  :  String[50];   {  Store last file name used }
               {394}  SampleNo  :  LongInt;      {  No of selected records to include in Report Test Mode }
               {398}  TestMode  :  Boolean;      {  Test Mode Flag }
               {399}  MLineCount:  LongInt;      {  Nominal Line Count }
               {403}  CurrBreak :  Byte;         {  Record of last Break No. }
               {404}  FirstPos  :  LongInt;      {  Record pos of first selected record }
               {408}  RefreshPos:  Boolean;      {  Start looking from FirstPos ? }
               {409}  LastPos   :  LongInt;      {  Record pos of last selected record }
               {413}  RefreshEnd:  Boolean;      {  Abort when last pos encountered }
               {414}  FirstTot  :  LongInt;      {  Count at first pos }
               {418}  HPrintEff :  LongInt;      {  Header Printing Effect }
               {422}  FNDXInpNo :  LongInt;      {  FastNDX Input LinkUp }
               {426}  DefFont   :  ReportFontType;{ Default Font for Windows Report }
               {467}  PaprOrient:  Char;         { Paper Orientations - (P)ortrait or (L)andscape }
               {468}  ColSpace  :  Byte;         { Space between columns in millimeters }

                      { HM 28/02/00: v4.31 Mods }
               {469}  PWord     :  String[8];    { Security Password }
               {478}  PrnInpData:  Boolean;      { Print Input Data Page }

               {479}  CSVTotals :  Boolean;
                      Spare     :  Array[1..31] of Byte;
                    end;


    { ================ Report Detail Record ================ }


    ReportDetailType  = Record
               {002}  ReportKey :  String[20];   {  RepName +Var Type + LineRef}
               {023}  RepName   :  String[10];   {  Parent Code }
               {033}  RepVarNo  :  LongInt;      {  Field No. }
               {037}  VarType   :  Char;         {  R/I/H }
               {038}  VarLen    :  Byte;         {  Variable length }
               {039}  PrintVar  :  Boolean;      {  Print this variable }
               {040}  SubTot    :  Boolean;      {  Sub Total }
               {042}  SortOrd   :  String[2];    {  Sort Order ie 1A }
               {044}  PrintEff  :  LongInt;      {  Weighted byte of print effect }
               {049}  VarRef    :  String[10];   {  Variable Lookup }
               {059}  Break     :  Byte;         {  Break Type Line, PAge }
               {061}  RepLDesc  :  String[30];   {  Report Heading }
               {092}  Format    :  String[30];   {  Format Mask }
{$IFDEF GUI} // HM 07/03/05: Changed for Visual Report Writer
               {123}  RecSelect :  String[255];  {  Record Selection }
               {224}  PrintSelect
                                :  String[255];  {  Print Selection }
                      RangeFilter: String[255];  // HM 07/03/05: Added for VRW

{$ELSE}
               {123}  RecSelect :  String[100];  {  Record Selection }
               {224}  PrintSelect
                                :  String[100];  {  Print Selection }
{$ENDIF}
               {324}  Summary   :  Boolean;      {  Summary Report }

               {325}  CalcField :  Boolean;      {  Is a calculated field }

               {326}  VarNumPFix:  Char;         {  R Types can be I or R }

               {327}  RepLIType :  Byte;         {  Report Input Type 1..10 }

               {329}  RepPadNo  :  String[10];   {  Padded Line Refernce }

               {340}  RepLPr    :  CCDepType;    {  Special Period/Year Input }

               {346}  PrSel     :  Boolean;      {  Period selection required }

               {347}  NoDecs    :  Byte;         {  No Dec places for a real }

               {348}  RepLCr    :  Byte;         {  Period Select Currency }

               {349}  ReCalcBTot:  Boolean;      {  Calculate Value at the end }

               {350}  ApplyPSumm:  Boolean;      {  Apply Print Select condition to Summary }

               {351}  CDrCr     :  Boolean;      {  Show as Dr/Cr calc field only }

               {352}  SpareBool :  Boolean;      {  Use Default Report Font }
               {353}  WinFont   :  FieldFontType;{ Default Font for Windows Report }
               {358}  MMWidth   :  SmallInt;     { Column Width in miliimeters }

               {360}  InputType :  Byte;         {  Type of input field needed }
               {361}  InputLink :  Byte;         {  Link to input field }

               {361}  Spare     :  Array[1..47] of Byte;

               {409}  Case Byte of
{$IFDEF GUI} // HM 07/03/05: Changed for Visual Report Writer
               {410}    1  :  (VarSubSplit  :  String[255]);  {  Calculation / Sub Split }
{$ELSE}
               {410}    1  :  (VarSubSplit  :  String[100]);  {  Calculation / Sub Split }
{$ENDIF}
                        2  :  (ASCStr       :  Array[1..2] of String[30]); {Input Values}
                        3  :  (DRange       :  Array[1..2] of LongDate);
                        4  :  (VRange       :  Array[1..2] of Real);
                        5  :  (PrRange      :  Array[1..2,1..2] of Byte);
                        6  :  (PrIRange     :  Array[1..4] of Byte);
                        7  :  (CrRange      :  Array[1..2] of Byte);

                    end;


    { ================ Report Nominal Detail Record ================ }


    ReportNomType  = Record
               {002}  ReportKey :  String[20];   {  RepName + LineRef}
               {023}  RepName   :  String[10];   {  Parent Code }
               {033}  RepVarNo  :  LongInt;      {  Field No. }
               {037}  VarType   :  Char;         {  R/I/H }
               {038}  PrintVar  :  Boolean;      {  Print this variable }
               {039}  Break     :  Byte;         {  Break Type Line, PAge }
               {040}  CalcField :  Boolean;      {  Calculated Line}
               {041}  SubTot    :  Boolean;      {  Sub Total Field }
               {042}  Spare1    :  Array[1..6] of Byte;
               {049}  NomRef    :  String[10];   {  Nominal Lookup }
               {060}  RepLDesc  :  String[50];   {  Report Heading }
               {111}  VarSubSplit
                                :  String[100];  {  Calculation String }
               {211}  NomTotals :  Array[1..MaxNomTots] of Real; {* Temp Storage of Calculations *}
               {392}  RepPadNo  :  String[10];   {  Padded Line Refernce }


               {402}  Spare     :  Array[1..109] of Byte;
                    end;


    RNotesType    =  Record
              {002}   NoteNo    :  String[20];   { Folio/CustCode + NType + LineNo}

              {023}   NoteDate  :  LongDate;

              {029}   Spare3    :  Byte;

              {032}   Spare4    :  Array[1..5] of Byte;

              {037}   Spare5    :  Array[1..11] of Byte;

              {049}   NoteAlarm :  LongDate;

              {058}   NoteFolio :  String[10];

              {068}   NType     :  Char;

              {069}   LineNo    :  LongInt;

              {074}   NoteLine  :  String[100]; { Note Line }

              {175}   NoteUser  :  String[10];  { Note owner }

              {185}   Spare2    :  Array[1..326] of Byte;
                    end;

    RepCmdType = Record
               {002}  ReportKey :  String[20];   {  RepName +Var Type + LineRef}
               {023}  RepName   :  String[10];   {  Parent Code }
                      Command   :  String[255];
                      Spare     :  Array[1..200] of Byte;
                 end;





    RepGenPtr  =  ^RepGenRec;


    RepGenRec  =  Record
                    RecPfix   :  Char;         {  Record Prefix }
                    SubType   :  Char;         {  Subsplit Record Type }


             {$IFDEF EXWIN}
                      Case SmallInt of
             {$ELSE}
                      Case Integer of
             {$ENDIF}

                        1  :  (ReportHed  :  ReportHedType);
                        2  :  (ReportDet  :  ReportDetailType);
                        3  :  (ReportNom  :  ReportNomType);
                        4  :  (RNotesRec  :  RNotesType);
                        5  :  (RCommand   :  RepCmdType);

                    end;


    RepGen_FilePtr   =   ^RepGen_FileDef;


    RepGen_FileDef   =   Record
                           RecLen,
                           PageSize,
 {$IFDEF EXWIN}
                           NumIndex  :  SmallInt;
                           NotUsed   :  LongInt;
                           Variable  :  SmallInt;
 {$ELSE}
                           NumIndex  :  Integer;
                           NotUsed   :  LongInt;
                           Variable  :  Integer;
 {$ENDIF}
                           Reserved  :  array[1..4] of Char;
                           KeyBuff   :  array[1..RGNofSegs] of KeySpec;
                           AltColt   :  AltColtSeq;
                         end;
{$ENDIF} { DICTEDIT }
