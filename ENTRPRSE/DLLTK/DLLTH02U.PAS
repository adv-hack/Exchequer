unit DLLTH02U;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{* 31.01.2000 - This unit is for Ex_StoreTrans only *}


interface

Uses
  Classes, Dialogs, GlobVar,
  {$IFDEF WIN32}
    VarRec2U,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst,  VarCnst3;

FUNCTION EX_STORETRANS(P,
                       PL         :  POINTER;
                       PSIZE,
                       PLSIZE     :  LONGINT;
                       SEARCHPATH :  SMALLINT;
                       SEARCHMODE :  SMALLINT) : SMALLINT;
                       {$IFDEF WIN32} STDCALL {$ENDIF}
                       EXPORT;


{* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ *}
implementation
{* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ *}
Uses
  SysUtils, WinProcs, ETStrU, ETDateU, ETMiscU, MiscU,
{$IFDEF WIN32}
  BtrvU2,    BTSupU1,   SysU2,     SysU3,    ComnU2,
  ComnUnit,  CurrncyU,  BtKeys1U,  InvCtSuU,
{$ELSE}
  BtrvU16, BtSup1, BtSup2,
{$ENDIF}
  FIFOLU, BTS1,
  DLLTH01U;

Const

  THVATCode :  Array[0..20] of Char =
  ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');

{* --------------------------------------------------------------------- *}




end.
