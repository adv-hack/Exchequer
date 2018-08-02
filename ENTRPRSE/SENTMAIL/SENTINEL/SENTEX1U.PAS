unit SentEx1u;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ExWrap1U, ElVar, ExBtTh1U;

{  type

   TdSentExLocalPtr = ^TdSentExLocal;

   TdSentExLocal = Object(TdPostExLocal)
     LElertRec     : TElertRec;
     LElertLineRec : TElertLineRec;

     constructor Create(CIdNo  :  SmallInt);
   end;}


implementation

{constructor TdSentExLocal.Create(CIdNo  :  SmallInt);
begin
  inherited Create(CIdNo);

  LRecPtr[ElertF]:=@LElertRec;
  LRecPtr[LineF]:=@LElertLineRec;
end;}


end.
