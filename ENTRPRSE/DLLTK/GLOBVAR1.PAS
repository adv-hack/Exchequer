{**************************************************************}
{                                                              }
{           ====----> General Global Vars Unit <----===        }
{                                                              }
{                      Created : 23/07/90                      }
{                                                              }
{                                                              }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


{ H-}
Unit Globvar1;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }




{ Global Unit for Variables Needed to Be referenced throughout the System }

Interface

{Type
  Integer  =  SmallInt;}
Type
  ShortString = String;
Const

  BOn             =  TRUE;
  BOff            =  FALSE;

  { ===== Debug Mode Flag =======}
  {$I Debug.Inc}

    { ============= General Qty Break Settings ============= }

  QBPriceCode    =  'P';  {* Special Price *}
  QBBandCode     =  'B';  {* Band Price    *}
  QBMarginCode   =  'M';  {* Margin on Cost *}
  QBMarkupCode   =  'U';  {* Markup on Cost *}
  QBQtyBCode     =  'Q';  {* Customer Qty Break *}

  QBDiscCode     =  'D';
  QBDiscSub      =  'Q';

  { ============= General Customer Discount Settings ============= }

  CDDiscCode     =  'C';

  PcntCh         =  '%';

  NoTotals        =  6;
  NoAgedTyps      =  8;

  {MaxMenuItems    =  100;  {* Menu Exclusion and Help Code Limit *}

{ ============= Add for BOM and Serial No ========= }



   BillMatTCode   = 'B';  { BOM RecPfix Code }
   BillMatSCode   = 'M';  { BOM SubType Code }


Type
  {Str1    =  String[1];}
  {Str3	  =  String[3];}
  Str5    =  String[5];
  Str8    =  String[8];
  Str10   =  String[10];
  Str15   =  String[15];
  Str20   =  String[20];
  Str25   =  String[25];
  Str30   =  String[30];
  {Str40   =  String[40];}
  Str50   =  String[50];
  Str80   =  String[80];
  Str100  =  String[100];
  Str255  =  String[255];
  AnyStr  =  String[255];
  Date    =  String[6];
  LongDate=  String[8];

  Windx     =  Array[1..7] of Byte;
  AddrTyp   =  Array[1..5] of String[30];
  GenAry    =  Array[1..2300] of Char;

  Totals    =  Array[1..NoTotals] of Real;

  AgedTyp   =  Array[0..NoAgedTyps] of Real;


  TimeTyp   =  Record
                 HH  :  Integer;
                 MM  :  Integer;
                 SS  :  Integer;

               end;


  {ExclMenuT  =  Array[1..MaxMenuItems] of Boolean;}

  {HelpMenuT  =  Array[1..MaxMenuItems] of Longint;}




  (*  character set type *)

  CharSet=  set of Char;

  {TIntSet            =   Set of Byte;}

  DocEditNListType    =  Array[0..10] of LongInt;



const

    NofAddrLines= 5;
    DocLen         =  09;
    AccLen         =  6;
    AccNamLen      =  30;
    VNoLen         =  6;  {Max Lint length*}
    PrLen          =  3;
    MLocLen        =  3;
    MLocNamLen     =  45; { Location Name Length }
    StkLen         =  16;
    LoginLen       =  10;
    NHTypLen       =  1;
    CCDpLen        =  3;
    BinLen         =  10; {* For Bin Location *}
    {MaxInvLines    =  200;}

    { ========= For Import =========== 25/07/97 }

    CheckMode   = 100;
    ImportMode  = 200;

    { ============= Multi Location ============== }

    MLocFixCode   :  Array[False..True] of String[2] = ('CD','CC');


    { ============= Custom Settings =========== }


    btCustTCode     =  'U';
    btCustSCode     =  'C';


Const

  {* Sys Array Consts *}

  {
  YNSet	  :  Set of Char =['Y','N'];
  AlphaSet:  Set of Char =['A'..'Z'];
  NumSet  :  Set of Char =['0'..'9'];
  }

  { =============== Std Basic Menu Control Keys ============== }

  {StdMPKeys       = [^H,'+',#32];}



  WildChars       = ['*','?'];     {  WildCard Characters }

  {
  SBSLogo         =  '-SBS- Consultants (c) 1986,95';
  SBSCopyRite     =  '(c) -SBS- Consultants (UK) Ltd. 1989-1995.';
  }

  C0              =  #0;   { Char 0  }

  NDxWeight       =  #255;




  { ===== Use SBS Mono Shadow ======= }

  {SBSMonoOn       =  BOn;}

  SBSPass         =  '..SBS..';

  {SBSPass2        =  'UK585';}
  {SBSDoor	  =  'SYSTEM';}

  PSwitch         =  '/P:';

  DumpSwitch      =  '/DF:OFF';

  ResetBtSwitch   =  '/NU:';

  NoXLogoSwitch   =  '/NL:';

  AutoPWSwitch    =  '/PL:';

  AccelSwitch     =  '/AC:';

  RemDirSwitch    =  '/DIR:';

  {SwapDefaultNam  =  'SBS';}

  DefaultCountry  =  '044';   {* Set to UK INT STD Code *}

  MUDelay2Switch  =  '/MUDELAY2:';
  MUNoCheckSwitch =  '/MUNOCHECK:';

  CUInfoSSWitch   =  '/USE_INFOS:';
  CUBentlySwitch  =  '/USE_BENTLY:';


  {MinDiskSpace    : Longint   =   1000000;    {* Default min free disk space maybe overridden *}
  MinLInt         : LongInt   =   -2147483647; {* Smallest Integer *}
  MaxLInt         : LongInt   =    2147483647; {* Largest Integer *}


  NofChaseLtrs    =   3;            {* Max No of Chase Letters *}
  { ============ Color Globals ========= }
  {Ink             =  7;
  Paper           =  6;
  Border          =  6;}
{ -------------------------------------------------------------------- }

{  Keybord lookup}

{ -------------------------------------------------------------------- }

 {HmKy    = #199; }            {EndKy   = #207;}
  UpKy    = #200;               DnKy    = #208;
 {CUpky   = #288; }            {CDnky   = #292;}
 {PgUpKy  = #201; }            {PgDnKy  = #209;}
 {CPgUpky = #260; }            {CPgDnky = #146;
 {LKy     = #203; }            {InsKy   = #210;
 {RKy     = #205; }            {DelKy   = #211;
 {CDelky  = #294; }            {ADelky  = #314;
 {CRKy    = #244; }            {CLKy    = #243;
{ F1      = #187;  SF1 =#212;   F6      = #192;  SF6  =  #217;
  F2      = #188;               F7      = #193;
  F3      = #189;  SF3 =#214;   F8      = #194;  }
{ F4      = #190; }             F9      = #195;
{ F5      = #191;               F10     = #196;  SF10 =  #221; CtlF10  =  #231;

  AltF1   = #232;
  AltF4   = #235;               AltF6   = #237;
  AltF5   = #236;
}
  Esc     = #27;

  ResetKey= #0;
{ Tab     = ^I;
  CtlEndKy= #245;

  AltJ    = #164;
  CtrlPgUp= #132;
  CtrlPgDn= #246;
  AltC    = #174;
}
  AltZ    = #172;

  {opKeysSet  = [F1..F10,SF1,AltF1,SF10,CtlF10,AltC];}


    { =========== General Input Keys ============= }

  StdInputSet    =[^E,^M,^I,^X,^Z,^B,Upky,Dnky,F9,Esc,AltZ];


{ayary : array[1..7] of String[9] =
  ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');}

monthary : array[0..12] of String[9] =
('********','January','February','March','April','May','June','July','August','September'
,'October','November','December');

{onthdays : array[1..12] of integer =
(31,29,31,30,31,30,31,31,30,31,30,31);}

rd        : array[1..4] of String[2] = ('st','nd','rd','th');


Var

 { FlDate        : Str25;     {Full System Date..}

  BlindOn       : Boolean;   {Flag for Displaying A Field with the '_' char}

  GlobLocked    : Boolean;   {Flag for Checking Locked Status }

  Date_Inp_On   : Boolean;   {Flag for Switching Date Input On}

  NoSelect      : Boolean;   {Flag for Select }

  Elded         : Boolean;   { Global Edit Flag }

  {WarpSet       : Boolean;   { Determine if Warp Set }

  Status        : Integer;   {General Btrieve Flag }

  SBSIN         : Boolean;   {Flg Denoting Level of Access}

  DumpFileOFF   : Boolean;   { Prevent Opening of Print to Screen Dump File }

  ResetBtOnExit : Boolean;   { Issue Btreive reset instead of Stop on Exit - Used for linking from another apps }

  NoXLogo       : Boolean;   { Don't Show X Logo }

  AccelMode,
  BTReadOnly    : Boolean;

  BeepSwitch    : Boolean;   {* Global Switch to Turn off Sound *}

  RemDirOn      : Boolean;   {* Switch denoting remote directory is in operation *}

  MUDelay2      : Boolean;   {* Switch denoting an increase in the Multi user delay *}

  MUNoCheck     : Boolean;   {* Switch denoting no use of the automatic Multi user reset check *}

  AllowHotKey   : Boolean;

  JBCostName,
  RepWrtName,
  ExVersParam,
  AccelParam    : ^Str20;


  SBSParam,
  LoginParam    : Str20;
  {PopCalcMemory : Str20;}

  Addch,{Prdch,}
  Ch            : Char;

  KeyF          : {Short}Str255;

  dd,mm,yy      : Integer;     { Global Todays Date }

  TotFiles      : Integer;  { Total No of Files }

  ExitSave      : Pointer;  { Temp Storage of real ExitProc Value }

  {PopKeys       : Boolean;  { Allow PopKeys to Work }

  InPrint       : Boolean;  { Is System in the middle of printing... ? }

  {ExHelpNo      : LongInt;  {* Master Help Index No. *}

  {DiskFull      : Boolean;  {* Disk Full Flag *}

  SilentLock    : Boolean;  {* Not to display Lock Message Dialogue *}

  CheckRelease  : Boolean;  {* Check Status for Release Code *}

  OVExPath      : Boolean;  {* Override Exchdll.ini's Ex.Path *}

  OVMCMode      : Boolean;  {* Override Exchdll.ini's MC Mode *}

  CurrentCountry: String[3];{* Global Currenct Country Code *}

  InSRC          :   Array[BOff..BOn] of Boolean;

  ViewPr,
  ViewYr        : ^Byte;   {Nom/Stk Tree View periods}

  DocEditedNow   : Byte;

  DocEditNowList: ^DocEditNListType;

  TestMode      : Boolean; { Displays messages containing parameters if true }

  JBFieldSwitch : Str10;

  SetUpFN       : Str255;

  ErrorLogF,
  SetUpF        : Text;


  { ========== PopUp Flags ========== }

  DefPrintLock,
  InHelp,
  InHelpNdx,
  InCust,
  InNom,
  InVATP,
  InCtrl,
  InCurr,
  InPopKy,
  InChangePr,
  InStock,
  InStockEnq,
  InMainThread,
  InModalDialog,
  InSysSS,
  InBuildPP,
  InFindDoc,
  InGLCC,
  InDocNum       :   Boolean;         {  Flags to Show if Popup Active  }

(*  global variables *)
  Ok,
  NoAbort,
  BatchEdit,
  JBCostOn,
  SWInfoSOn,      
  SWBentlyOn,
  JBFieldOn,
  EuroVers
                : Boolean;

  Lnum          : LongInt;

  RungExVer,
  RepRunCount   : LongInt;

  GotPassWord,
  GotSecurity   : Boolean; {Flag to determine if Password & Security has been got!}



  { ========= Output Printer ==============}
  { Options are 1= Network Printer }
  { or 2 = Lpt2 = Local Printer }

  {Default_Printer : Byte;}


Implementation


Begin


  ExitSave:=Nil;

  Elded:=BOff;


  {FLdate:='-SBS- Time';}

  BlindOn:=BOff;
  NoSelect:=BOff;
  Date_Inp_On:=BOff;

  {Default_Printer:=1;}

  TotFiles:=0;

  {ExHelpNo:=0;}

  {PopKeys:=BOn;}

  InPrint:=BOff;

  Addch:=ResetKey;
  Ch:=Addch;
  {Prdch:=Ch;}

  SBSIn:=BOff;

  DumpFileOff:=BOff;

  ResetBtOnExit:=BOff;

  NoXLogo:=BOff;

  AccelMode:=BOff;

  {DiskFull:=BOff;}

  SilentLock:=BOff;

  CheckRelease:=BOn;

  OVExPath:=BOff;

  OVMCMode:=BOff;

  {WarpSet:=BOff;}

  MUDelay2:=BOff;

  MUNoCheck:=BOff;

  AllowHotKey:=BOn;

  {PopCalcMemory:='';  {* Reset PopCalc Holding Memory *}

  EuroVers     := BOff;
  DefPrintLock := BOff;
  BatchEdit    := BOff;
  InStock      := BOff;
  InStockEnq   := BOff;
  JBCostOn     := BOff;
  JBFieldOn    := BOff;

  TestMode := False;

  CurrentCountry:=DefaultCountry;

  { ========================= Define file mode =========================== }


  {

    File Mode


    7 6 5 4 3 2 1 0
    ~~~~~~~~~~~~~~~
    I S S S R A A A

                      I  -  Inheritance
                      S  -  Share Access
                      R  -  Reserved
                      A  -  File Access
  }


  FileMode:=66;

  

end.