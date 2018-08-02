unit BtKeys1U;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }



interface

Uses
  StrUtil,
  GlobVar,
  VarConst,
  BtrvU2;

  function FullCustCode(CCode : Str10) : AnyStr;
  function FullCustType(CCode : Str10; CSup : Char) : AnyStr;
  Function FullNomKey(ncode  :  Longint)  :  Str20;
  Function SmallIntToKey(ncode : smallint) : String2;

Const
  CardKeyLen =  6;
  CardClubNoLen =  6;
  CustKeyLen = 6;
(*  CustCompLen   =  30;
  CustTTLen     =  80;
  CustACTLen    =  4;
  StkKeyLen     =  16;
  StkDesKLen    =  35;
  DocKeyLen     =  9;
  DocYRef1Len   =  10;
  DocYRef2Len   =  20;
  DocDesLen     =  50;
  LoginKeyLen   =  10;
  SNoKeyLen     =  20;
  BNoKeyLen     =  10;
  CCKeyLen      =  3;
  CCDescLen     =  20;
  MLocKeyLen    =  3;
  MLDescKeyLen  =  45;
  CustVATLen    =  20;
  NomKeyLen     =  6;
  NomDesLen     =  30;
  BankALen      =  8;
  BankSLen      =  6;
  BankRLen      =  18;
  BankMLen      =  30;
  LDateKeyLen   =  8;
  JobKeyLen     =  10;
  AnalKeyLen    =  10;
  EmplKeyLen    =  06;
  PIKeyLen      =  10;
  QtyDiscKeyLen =  07; {? If the length of the qty ever changes, this will need to change as well for Qty breaks/Cust QB to be stored correctly.!!}
  BinLocLen     =  10;
  UStkLen       =  10;
  *)

Implementation

Uses
  ETStrU,
  ETMiscU,
  ETDateU;

function FullCustCode(CCode : Str10) : AnyStr;
begin
  FullCustCode:=UpcaseStr(LJVar(Ccode,CustKeyLen));
end;

function FullCustType(CCode : Str10; CSup : Char) : AnyStr;
begin
  FullCustType:=FullCustCode(CCode)+CSup;
end;

Function FullNomKey(ncode  :  Longint)  :  Str20;
Var
  TmpStr  :  Str20;
Begin
  FillChar(TmpStr,Sizeof(TmpStr),0);
  Move(ncode,TmpStr[1],Sizeof(ncode));
  TmpStr[0]:=Chr(Sizeof(ncode));
  FullNomKey:=TmpStr;
end;

Function SmallIntToKey(ncode : smallint) : String2;
Var
  TmpStr  :  String2;
Begin
  FillChar(TmpStr,Sizeof(TmpStr),0);
  Move(ncode,TmpStr[1],Sizeof(ncode));
  TmpStr[0]:=Chr(Sizeof(ncode));
  SmallIntToKey := TmpStr;
end;


end.
