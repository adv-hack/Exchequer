Unit VarFPOSU;




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


Uses GlobVar;


Const
    { ============= General Bank Settings ============= }

  MBANKHed      =  'M';  {* Bank Match Header }
  MBANKSUB      =  'E';
  MBankMSub     =  'M';  {* Manual Bank Recon Screen *}
  MBANKCTL      =  'T';  {* Bank Ctrl File *}




  {$I VARCmn3U.PAS}

Var
  RunPurge,
  GotDailyPW    :  Boolean;

  rPurgeMode    :  Byte;
  ExMainCoPath  :  ^Str255;

Procedure GetBTParam2;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  SysUtils;


  { ================== Procedure to Return Any Parameters ================= }

  Procedure GetBTParam2;

  Var
    n  :  Word;


  Begin

    If (ParamCount>0) then
      For n:=1 to ParamCount do
      Begin

        If (Not GotDailyPW) then
          GotDailyPW:=(UpperCase(ParamStr(n))='/GDP:');

        If (Not RunPurge) then
        Begin
          RunPurge:=(UpperCase(ParamStr(n))='/RP:');

          If (RunPurge) then
            rPurgeMode:=StrToInt(ParamStr(n+1));
        end;


      end; {Loop..}

  end; {Proc..}




Begin
  GotDailyPW:=BOff;

  RunPurge:=BOff;
  rPurgeMode:=0;

  GetBTParam2;

  New(ExMainCoPath);

  FillChar(ExMainCoPath^,Sizeof(ExMainCoPath^),0);



end.