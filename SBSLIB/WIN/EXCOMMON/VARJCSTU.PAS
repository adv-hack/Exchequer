Unit VarJCstU;

{$ALIGN 1}


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 31/07/90                      }
{                                                              }
{               Global variables & Type definitions            }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}



Interface



const



{* File Constants *}


{$I FilePath.Inc}


Const

  { == Additional Job Costing Constants == }

    {$IFDEF EXWIN}
      NofSysAnals    =  17;
    {$ELSE}
      NofSysAnals    =  10; {For DOS version this limit must stay}
    {$ENDIF}

    OrigSysAnals   =  10;
    SysAnlsProfit  =  99;
    SysAnlsEnd     =  6;
    SysAnlsBal     =  7;
    SysAnlsRev     =  1;
    SysAnlsWIP     =  8;
    {Sale Retention = 9
     Purch    "    = 10}

    SysSubLab      =  11;
    SysMat2        =  12;
    SysOH2         =  13;
    SysDeductSales =  14;
    SysAppSal      =  15;
    SysAppPur      =  16;
    SysDeductPurch =  17;


  NofCHTypes     =  04;
  NofEmplTypes   =  03;
  NofXTypes      =  4;
  NofJCStat      =  05;

  {$IFDEF EXWIN}
    NofJALTypes  =  13;

    JALDedLineNo   =  -2;
    JALRetLineNo   =  -3;

  {$ENDIF}

  JCSelfBillRunNo =  -19;
  TSTTempRunNo    = -18;
  CloseJobRunNo   = -17;




  JXRevCode     =  'R';
  JXOHCode      =  'O';
  JXMATCode     =  'M';
  JXLabCode     =  'L';

  JobXCode      :  Array[0..NofXTypes] of Char = (#0,JXRevCode,JXOHCode,JXMATCode,JXLAbCode);

  EmplSubCode   =  02;
  PRateCode     =  -1;

Type

  JobStatType    =  Array[0..NofJCStat] of String[20];

  JobXDescType   =  Array[0..NofXTypes] of String[10];

  JobChType      =  Array[0..NofCHTypes] of String[20];

  EmplTypes      =  Array[0..NofEmplTypes] of String[20];

  {$IFDEF EXWIN}
    tJALTypes      =  Array[5..NofJALTypes+4] of String[20];
    tJALLTTypes    =  Array[0..NofJALTypes+4] of Double;


  {$ENDIF}

Var

  JobStatusL  : ^JobStatType;

  JobXDesc    : ^JobXDescType;

  JobChTDescL : ^JobChType;

  EmplTDescL  : ^EmplTypes;

  {$IFDEF EXWIN}
     JALTypes  :  ^tJALTypes;
  {$ENDIF}


Procedure Define_PVar;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


{ ========== Procedure to Set Constant Variables ======== }



Procedure Define_PVar;

Begin


  JobStatusL^[1]:='Quotation';
  JobStatusL^[2]:='Active';
  JobStatusL^[3]:='Suspended';
  JobStatusL^[4]:='Completed';
  JobStatusL^[5]:='Closed';

  JobXDesc^[1]:='Revenue';
  JobXDesc^[2]:= 'Overheads';
  JobXDesc^[3]:='Materials';
  JobXDesc^[4]:='Labour';

  JobCHTDescL^[1]:='Time & Materials';
  JobCHTDescL^[2]:='Fixed Price';
  JobCHTDescL^[3]:='Cost Plus %';
  JobCHTDescL^[4]:='Non-Productive Job';

  EmplTDescL^[1]:='Production';
  EmplTDescL^[2]:='Sub-Contract';
  EmplTDescL^[3]:='Overhead';

  {$IFDEF EXWin}
    JALTypes^[5]:='Materials 1';
    JALTypes^[6]:='Materials 2';
    JALTypes^[7]:='Labour 1';
    JALTypes^[8]:='Labour 2';
    JALTypes^[9]:='Retentions 1';
    JALTypes^[10]:='Retentions 2';
    JALTypes^[11]:='Deductions 1';
    JALTypes^[12]:='Deductions 2';
    JALTypes^[13]:='Deductions 3';
    JALTypes^[14]:='CITB';
    JALTypes^[15]:='CIS';
    JALTypes^[16]:='Misc 1';
    JALTypes^[17]:='Misc 2';
  {$ENDIF}

end;



Begin



end.