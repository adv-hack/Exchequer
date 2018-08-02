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


{$H-}
Unit GlobVar;



{ Global Unit for Variables Needed to Be referenced throughout the System }

Interface

{Type
  Integer  =  SmallInt;}

Const
  BOn             =  TRUE;
  BOff            =  FALSE;


  { ===== Debug Mode Flag =======}
  {$I Debug.Inc}  
      

  NoTotals        =  6;
  NoAgedTyps      =  8;

  MaxMenuItems    =  100;  {* Menu Exclusion and Help Code Limit *}




Type
  Str1    =  String[1];
  Str3	  =  String[3];
  Str5    =  String[5];
  Str8    =  String[8];
  Str10   =  String[10];
  Str15   =  String[15];
  Str20   =  String[20];
  Str25   =  String[25];
  Str30   =  String[30];
  Str40   =  String[40];
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


  ExclMenuT  =  Array[1..MaxMenuItems] of Boolean;

  HelpMenuT  =  Array[1..MaxMenuItems] of Longint;




  (*  character set type *)

  CharSet=  set of Char;



  const
    NofAddrLines= 5;




Const


  //RB 29/06/2017 2017-R2 ABSEXCH-18914: SQL connection fixes from Delphi end.
  CONNECTION_FAILURE = 'Connection failure';
  //RB 14/06/2017 2017-R2 ABSEXCH-18914: SQL connection fixes from Delphi end.
  //Constant for particular Connection related exception
  ERR_CONN_FAILURE = -2147467259;

  {* Sys Array Consts *}

  YNSet	  :  Set of Char =['Y','N'];
  AlphaSet:  Set of Char =['A'..'Z'];
  NumSet  :  Set of Char =['0'..'9'];





  { =============== Std Basic Menu Control Keys ============== }

  StdMPKeys           =         [^H,'+',#32];



  WildChars           = ['*','?'];     {  WildCard Characters }




  SBSLogo         =  '-SBS- Consultants (c) 1986,95';

  SBSCopyRite     =  '(c) -SBS- Consultants (UK) Ltd. 1989-1995.';

  C0              =  #0;   { Char 0  }

  NDxWeight       =  #255;




  { ===== Use SBS Mono Shadow ======= }

  SBSMonoOn       =  BOn;

  SBSPass         =  '..SBS..';

  SBSPass2        =  'UK585';

  SBSDoor	  =  'SYSTEM';

  PSwitch         =  '/P:';

  DumpSwitch      =  '/DF:OFF';

  ResetBtSwitch   =  '/NU:';

  NoXLogoSwitch   =  '/NL:';

  AutoPWSwitch    =  '/PL:';

  AccelSwitch     =  '/AC:';

  RemDirSwitch    =  '/DIR:';

  CoDirSwitch    =  '/CODIR:';

  JBFieldSwitch   =  '/USE_JFIELDS:';
  CUInfoSSWitch   =  '/USE_INFOS:';
  CUBentlySwitch  =  '/USE_BENTLEY:';


  SwapDefaultNam  =  'SBS';

  { ======== Btrieve Owner Code ==== }

  ExBTOWNER  =  'V600';



  DefaultCountry  =  '044';   {* Set to UK INT STD Code *}

  MinDiskSpace    : Longint   =   1000000;    {* Default min free disk space maybe overridden *}

  MinLInt         : LongInt   =   -2147483647; {* Smallest Integer *}
  MaxLInt         : LongInt   =    2147483647; {* Largest Integer *}





  { ============ Color Globals ========= }
  Ink             =  7;
  Paper           =  6;
  Border          =  6;



{ -------------------------------------------------------------------- }

{  Keybord lookup}

{ -------------------------------------------------------------------- }

  HmKy    = #199;               EndKy   = #207;  { cursor control keys }
  UpKy    = #200;               DnKy    = #208;
  CUpky   = #288;               CDnky   = #292;
  PgUpKy  = #201;               PgDnKy  = #209;
  CPgUpky = #260;               CPgDnky = #146;
  LKy     = #203;               InsKy   = #210;
  RKy     = #205;               DelKy   = #211;
  CDelky  = #294;               ADelky  = #314;
  CRKy    = #244;               CLKy    = #243;
  F1      = #187;  SF1 =#212;   F6      = #192;  SF6  =  #217; { function keys }
  F2      = #188;               F7      = #193;
  F3      = #189;  SF3 =#214;   F8      = #194;
  F4      = #190;               F9      = #195;
  F5      = #191;               F10     = #196;  SF10 =  #221; CtlF10  =  #231;

  AltF1   = #232;
  AltF4   = #235;               AltF6   = #237;
  AltF5   = #236;

  Esc     = #27;                ResetKey= #0;
  Tab     = ^I;                 CtlEndKy= #245;

  AltJ    = #164;               CtrlPgUp= #132;  {* Does not work! *}
  AltZ    = #172;               CtrlPgDn= #246;
  AltC    = #174;



  PopKeysSet  :  CharSet = [F1..F10,SF1,AltF1,SF10,CtlF10,AltC];


    { =========== General Input Keys ============= }

  StdInputSet            =[^E,^M,^I,^X,^Z,^B,Upky,Dnky,F9,Esc,AltZ];


dayary : array[1..7] of String[9] =
  ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

monthary : array[0..12] of String[9] =
('********','January','February','March','April','May','June','July','August','September'
,'October','November','December');

Monthdays : array[1..12] of integer =
(31,29,31,30,31,30,31,31,30,31,30,31);

rd        : array[1..4] of String[2] = ('st','nd','rd','th');



Var

  FlDate        : Str25;     {Full System Date..}

  BlindOn       : Boolean;   {Flag for Displaying A Field with the '_' char}

  GlobLocked    : Boolean;   {Flag for Checking Locked Status }

  Date_Inp_On   : Boolean;   {Flag for Switching Date Input On}

  NoSelect      : Boolean;   {Flag for Select }

  Elded         : Boolean;   { Global Edit Flag }

  WarpSet       : Boolean;   { Determine if Warp Set }

  Status        : Integer;   {General Btrieve Flag }

  SBSIN         : Boolean;   {Flg Denoting Level of Access}

  DumpFileOFF   : Boolean;   { Prevent Opening of Print to Screen Dump File }

  ResetBtOnExit : Boolean;   { Issue Btreive reset instead of Stop on Exit - Used for linking from another apps }

  NoXLogo       : Boolean;   { Don't Show X Logo }

  AccelMode,
  BTReadOnly    : Boolean;

  BeepSwitch    : Boolean;   {* Global Switch to Turn off Sound *}

  RemDirOn      : Boolean;   {* Switch denoting remote directory is in operation *}


  SBSParam,
  LoginParam,
  PopCalcMemory : Str20;

  Addch,Prdch,
  Ch            : Char;

  KeyF          : ShortString;

  dd,mm,yy      : Integer;     { Global Todays Date }

  TotFiles      : Integer;  { Total No of Files }

  ExitSave      : Pointer;  { Temp Storage of real ExitProc Value }

  PopKeys       : Boolean;  { Allow PopKeys to Work }

  InPrint       : Boolean;  { Is System in the middle of printing... ? }

  ExHelpNo      : LongInt;  {* Master Help Index No. *}

  DiskFull      : Boolean;  {* Disk Full Flag *}

  CurrentCountry: String[3];{* Global Currenct Country Code *}






  { ========= Output Printer ==============}
  { Options are 1= Network Printer }
  { or 2 = Lpt2 = Local Printer }

  Default_Printer : Byte;




Implementation


Begin


  ExitSave:=Nil;

  Elded:=BOff;


  FLdate:='-SBS- Time';

  BlindOn:=BOff;
  NoSelect:=BOff;
  Date_Inp_On:=BOff;

  Default_Printer:=1;

  TotFiles:=0;

  ExHelpNo:=0;

  PopKeys:=BOn;

  InPrint:=BOff;

  Addch:=ResetKey;
  Ch:=Addch;
  Prdch:=Ch;

  SBSIn:=BOff;

  DumpFileOff:=BOff;

  ResetBtOnExit:=BOff;

  NoXLogo:=BOff;

  AccelMode:=BOff;

  DiskFull:=BOff;

  WarpSet:=BOff;

  PopCalcMemory:='';  {* Reset PopCalc Holding Memory *}


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




