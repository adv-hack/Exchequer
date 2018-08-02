Unit EposCnst;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


Interface

{$H-}

{Uses
  Graphics, WinTypes, GlobVar, VARRec2U, BtrvU2;}

Uses
  {Graphics, WinTypes, GlobVar, VARRec2U, }BtrvU2, GlobVar, VarConst;


Const
  {$I FILEPATH.INC}

  EposF       =  17;

  EposNofKeys =  1;
  EposIndexK   =  0;

  EposNofSegs =  2;
  cmSetup     = 'S';


Type
  TEposSetupRec = record
    EposIndex : String[30];
    Spare  : Array [1..3970] Of Char;
  End;{EposSetupRec}

  TEposRec = record
    RecPFix  : Char;
    Case Byte Of
      1 : (EposSetup : TEposSetupRec);
      2 : (Misc    : Array [1..4000] Of Char);
  End;{EPOSRec}

  TEpos_FileDef = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..EposNofSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  End;{Epos_FileDef}

var
   EposRec : TEposRec;
   EposFile : TEpos_FileDef;

Implementation

Procedure DefineEpos;
Begin
  With EposFile do begin
    FileSpecLen[EposF]:=Sizeof(EposFile);
    Fillchar(EposFile,FileSpecLen[EposF],0);
    RecLen:=Sizeof(EposRec);
    PageSize:=DefPageSize;
    NumIndex:=EposNofKeys;
    Variable:=B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

    { Key Definitons }

    { Index 0: tsType + tsIndex1}
    With KeyBuff [1] Do Begin
      KeyPos     := BtKeyPos(@EposRec.RecPFix, @EposRec);
      KeyLen     := sizeof(EposRec.RecPFix);
      KeyFlags   := DupModSeg;
    End; { With }
    With KeyBuff [2] Do Begin
      KeyPos     := BtKeyPos(@EposRec.EposSetup.EposIndex, @EposRec);
      KeyLen     := sizeof(EposRec.EposSetup.EposIndex) - 1;
      KeyFlags   := DupMod;
    End; { With }
    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}

  FileRecLen[EposF]:=Sizeof(EposRec);
  Fillchar(EposRec,FileRecLen[EposF],0);
  RecPtr[EposF]:=@EposRec;
  FileSpecOfs[EposF]:=@EposFile;
{*****************************************************************************************************}
{*****************************************************************************************************
  HARD CODED - NEEDS TO BE READ FROM INI FILE}
  FileNames[EposF]:=PathEpos + 'TRADEC01.DAT';
{*****************************************************************************************************}
{*****************************************************************************************************}
end; {..}


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

(*Uses Dialogs,{$IFDEF OLE} Forms, ETStru, {$ENDIF} SysUtils, {$IFDEF JC} VarJCstU, {$ENDIF} VARFposU;*)

Initialization
  DefineEPOS;
  Open_System(EPOSF, EPOSF);

end.
