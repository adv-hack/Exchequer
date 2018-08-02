Unit DEFSup6U;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 25/09/95                      }
{              Definition Processor Support Unit V             }
{                                                              }
{                                                              }
{               Copyright (C) 1995 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GlobType, GlobVar, VarConst;

Const
  JJSet      =    ['X','R','L','N','C'];

  { ========== Var Id Prefix ========== }

  RecPfx     =   'R';
  StaPfx     =   'S';
  QuoPfx     =   'Q';
  LabPFx     =   'L';
  StkPFx     =   'K';
  NtePFx     =   'N';
  JobPFx     =   'J';
  FxPFx      =   '!';

  VarChr     =    '&';

  RJChar     =    'R';  {Right Justify Trigger}
  LJChar     =    'L';  {Left     "       "   }
  NJChar     =    'N';  {No       "       "   }
  CJChar     =    'C';  {Center   "       "   }
  XJChar     =    'X';  {Leave alone      "  !}


Procedure DoCcyConvFunc (Var NamLn, Field, Justify : Str255; Const FLen : Byte);


Implementation


Uses DataDict, DicLinkU, DicLnk2U, PrintU, ETMiscU, ETDateU, ETStrU, SerialNo,
     CurrncyU, BtKeys1U, ComnU2, NoteSupU, InvListU, DocSupU1, SysU1, SysU2,
     ComnUnit, PCCUtils, PrnCodes, EPrntDef, PrntForm, PrntPrev, BTSupU1,
     BtrvU2, FormFile, PrevPCC;


(*
{ ====== Procedure to Calculate displacement Based on Var Prefix ====== }
Function SetNexTNam(NamLn  :  Str255)  :  Integer;

Var
  NextNo  :  Integer;

Begin
  NamLn:=Strip('B',[VARChr],ExtractWords(1,1,NamLn));

  NextNo:=0;

  Case NamLn[1] of
    RecPfx  :  NextNo:= 2000;
    StaPfx  :  NextNo:= 3000;
    QuoPfx  :  NextNo:= 4000;
    LabPfx  :  NextNo:= 5000;
    StkPfx  :  NextNo:= 6000;
    NtePfx  :  NextNo:= 7000;
    JobPfx  :  NextNo:= 8000;

  end; {Case..}

  SetNextNam:=NextNo+IntStr(Copy(NamLn,2,Pred(Length(NamLn))));
end;
*)

(*
{ ========= Check for any special Justification Switches within line ======= }
Function OverRideJustfy(NamLn,GField  :  Str255)  :  Str255;

Var
  Justfy  :  Str255;
  OrigLen :  Byte;

Begin
  OrigLen:=Length(GField);

  JustFy:=ExtractWords(2,1,NamLn);

  If (Justfy[1] In JJSet) then
  Begin
    If (Justfy[1]<>XJChar) then
      GField:=Strip('B',[#32],GField);

    Case Justfy[1] of
      LJChar  :  GField:=LJVar(GField,OrigLen);
      RJChar  :  GField:=RJVar(GField,OrigLen);
      CJChar  :  GField:=PadCenter(GField,OrigLen,#32);
    end; {Case..}
  end; {If Modification needed}

  OverRideJustfy:=GField;
end; {Func..}
*)

(*
Procedure SetFieldFmt(NamLn     :  Str255;
                      FLen,
                      CP,SP     :  Byte;
                  Var FieldCtrl :  FieldCtrlType);

Var
  C4UDF,
  SNoDecs   :  Str80;


Begin

  Blank(FieldCtrl,Sizeof(FieldCtrl));

  SNoDecs:='';

  With FieldCtrl do
  Begin
    UFlen:=Flen;

    C4UDF:=ExtractWords(CP,1,NamLn);

    SNoDecs:=ExtractWords(SP,1,NamLn);

    UDDecP:=((C4UDF[1] In JJSet) and (SNoDecs[1] In ['0'..'9']));

    If (UDDecP) then
      UDDecNo:=IntStr(SNoDecs[1]);
  end;
end; {Func..}
*)

(*
{ ====== Function to Execute the euro conversion routine == }
Function FxEuroConv(ECLine  :  Str255;
                    Flen    :  Byte)  :  Str255;

Var
  Dnum    :  Double;

  FxParam :  Array[1..6] of Str100;

  n,
  Idx     :  Integer;

  Result  :  Str255;

  FieldCtrl
          :  FieldCtrlType;

  IMask   :  InpDiskDesc;


Begin
  Result:='';

  Blank(FieldCtrl,Sizeof(FieldCtrl));

  Blank(FxParam,Sizeof(FxParam));

  With FieldCtrl do
    UFlen:=Flen;


  For n:=1 to 5 do
  Begin
    FxParam[n]:=Strip('B',[#32],ExtractWords(n,1,ECLine));

    If (n<4) then
    Begin
      If (IntStr(FxParam[n])=0) and (FxParam[n]<>'0') then {* Its possibly a variable }
        FxParam[n]:=Strip('B',[#32],SetField(SetNexTNam(FxParam[n]),FieldCtrl));

    end;

  end;


  SetFieldFmt(ECLine,FLen,4,5,FieldCtrl);

  Dnum:=Currency_ConvFT(RealStr(FxParam[1]),IntStr(FxParam[2]),IntStr(FxParam[3]),UseCoDayRate);

  Blank(IMask,Sizeof(IMask));

  Def_OverRLen(FieldCtrl,IMask,BmCBlNo);

  Result:=PPR(Dnum,IMask);          {* Converted Result *}


  FxEuroConv:=OverRideJustfy('X '+FxParam[4],Result);
end;
*)


// Currency Amount Conversion Function:-
//
//   !X aaaaaaaa bbbbbbbb c d e
//
//  !X           Function Identifier
//  aaaaaaaa    Amount - Field or Constant
//  bbbbbbbb    From Currency - Field or Constant
//  c           To Currency - Field or Constant
//  d           justification:- L, C, R, B e.g. RB
//  e           decimal places
//
Procedure DoCcyConvFunc (Var NamLn, Field, Justify : Str255; Const FLen : Byte);
Var
  FxParam  : Array[1..6] of Str100;
  Dnum     : Double;
  I, Decs  : Byte;
Begin { DoCcyConvFunc }
  { Extract Parameters from FULL function string }
  For I := 1 to 5 Do Begin
    { Extract parameter }
    FxParam[I]:=Strip('B',[#32],ExtractWords(Succ(I),1,NamLn));

    { Translate justification and decimals in first pass as needed for second }
    Case I Of
      4 : Begin { Justification }
            If Not (FxParam[I][1] In JJSet) Then Begin
              Justify := #32;
            End
            Else
              Justify := FxParam[I];
          End; { Justification }
      5 : Begin { Decimals }
            If Not (FxParam[I][1] In ['0'..'9']) Then Begin
              { Invalid Decimal Palaces specified }
              Decs := -1
            End { If }
            Else
              { Valid Decs specified }
              Decs:=IntStr(FxParam[I]);
          End; { Decimals }
    End; { Case }
  end;

  For I := 1 to 3 Do Begin
    { Get actual value of referenced field - check not a constant first }
    If (IntStr(FxParam[I]) = 0) And (FxParam[I] <> '0') Then Begin
      { Lookup in data dictionary }
      FxParam[I] := Trim(GetFieldText(FxParam[I],Decs,Justify,Flen).StrResult);
    End; { If (IntStr(FxParam[I]) = 0) And (FxParam[I] <> '0') }
  End; { If (I < 4)  }

  


End; { DoCcyConvFunc }



end. {Unit..}


