Unit VarCnst3;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }





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


Uses
     {$IFDEF EXWIN}
     Graphics,
     WinTypes,
     WinProcs,
     Dialogs,
     {$ENDIF}
     {$IFDEF WIN32}
       {BtrvU2,}
     {$ELSE}
       {BtrvU16,}
     {$ENDIF}
     SysUtils,
     GlobVar,
     VarConst;


Const

  SECTESTMODE =  333; {* For release code parameter --- To Confirm --- *}

  NoSws       =  19; {* 20.2.97 add JB validate / 26.2.97 add multi location *}

  SetUpSw     :  Array[1..NoSws] of String[25] = (
                                        {01}   'Auto_Set_Period',
                                        {02}   'Default_Nominal',
                                        {03}   'Default_Cost_Centre',
                                        {04}   'Default_Department',
                                        {05}   'Auto_Set_Stock_Cost',
                                        {06}   'Deduct_BOM_Stock',
                                        {07}   'Deduct_MultiLoc_Stock',
                                        {08}   'Overwrite_Trans_No',
                                        {09}   'Overwrite_Note_Pad',
                                        {10}   'Use_Ex_Currency',
                                        {11}   'Allow_Trans_Edit',
                                        {12}   'Report_to_Printer',
                                        {13}   'Report_to_File',
                                        {14}   'Exchequer_Path',
					{15}   'Multi_Currency',
                                        {16}   'Default_Currency',
					{17}   'Update_Account_Bal',
                                        {18}   'Update_Stock_Levels',
                                        {19}   'Ignore_JobCost_Validation'
                                              );



     { ==================== System Record ================== }


{$I ExchDll.Inc}

Type

  DictLinkType  =  Record
                     DCr,
                     DPr,
                     DYr   :  Byte;
                   end;

  {CCDepType  =  Array[False..True] of String[3];  {  CC/Dep Type }

  {Date    =  String[6];}

  ExSysRec = Record

             Spare3    :  Array[1..2] of Char;

             Opt       :  Char;

             BatchPath,
             RFileN,
             ExPath    :  Str255;

             ImpDisplay
                       :  Boolean;

             RejectBatch
                       :  Boolean;

             CheckDupli
                       :  Boolean;

             ReverseTrans
                       :  Boolean;
             AutoSetPr :  Boolean;

	     MCMode    :  Boolean;

	     UpAccBal  :  Boolean;

             UpStkBal  :  Boolean;

             DeductBOM :  Boolean;

             DelBatFile:  Boolean;

             UseEOFFlg :  Boolean;

             AutoSetStkCost
                       :  Boolean;

             OverWORef,
             OverWNPad :  Boolean;

             UseExCrRate
                       :  Boolean;

             WarnFError,
             AllowEdit,
             RepPrn,
             RepFile   :  Boolean;

             DefNom    :  LongInt;

             DefCust   :  String[10];
             DefSupp   :  String[10];
             DefCCDep  :  CCDepType;
             DefStk    :  String[20];
             DefVAT    :  Char;
             DefSValTyp:  Char;
             DefCur    :  Byte;

             LastDate  :  Date;

             RPrnNo    :  Integer;

             UserName  :  String[30];

             Expansion :  string[38];

             JBIgnore  :  Boolean;  {* 20.2.97 *}

             UseMLoc   :  Boolean;  {* 27.2.97 *}

           end;



VAR

   ExSyss        :  ExSysRec;

   RemDirNo      :  LongInt;

   {OVExPathName  :  Str80;}

Implementation


{ I VarCnst2.Pas}

Begin


end.
