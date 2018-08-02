Unit IntMU;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 12/01/96                      }
{                                                              }
{                International Message Controller              }
{                                                              }
{               Copyright (C) 1996 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar;


Function  GetIntMsg(MNo  :  Integer)  :  Str255;

Procedure SetIntMessage;

Var
  IntMsgOfSet  :  LongInt;

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Windows,
   SysUtils,
   VarConst,
   ETMiscU,
   ETStrU;

{$R MES044.RES}

{ ===== Return Msg from String Table ====== }

Function  GetIntMsg(MNo  :  Integer)  :  Str255;

Var
  KeyS    :  Array[0..254] of Char;
  PC      :  PChar;
  RetLen  :  Integer;

Begin
  PC:=StrPCopy(KeyS,'');

  RetLen:=LoadString(HInstance,MNo+IntMsgOfSet,PC,255);

  Result:=StrPas(PC);

end; {Func..}


Procedure SetIntMessage;
Var
  CCInt        :  LongInt;
  UseDefault   :  Boolean;

Begin
  CCInt:=0;

  UseDefault:=(Syss.USRCntryCode<>CurrentCountry);

  With Syss do
  Begin
    If (IntStr(Strip('B',[#32],Syss.USRCntryCode))>0) then
    Begin

      CurrentCountry:=Syss.USRCntryCode;

//CurrentCountry := SingCCode; // '065' - Singapore Country code
//CurrentCountry := NZCCode;   // '064' - New Zealand Country Code
//CurrentCountry := AUSCCode;  // '061' - Australia Country Code
//CurrentCountry := UKCCode;   // '044' - UK Country code
//CurrentCountry := IECCode;   // '353' - Ireland Country code
//CurrentCountry := SACCode;   // '027' - South Africa Country code

      CCInt:=IntStr(Strip('B',[#32],CurrentCountry));

      If ((CCInt In [27,44,61,64,65]) or (CCInt=353)) and (CCInt<>IntMsgOfSet) then
      Begin
// MH 17/07/07: Modified offsets because of clashes with Delphi 6.02 or misc components
//              preventing things compiling due to clashes
//        If (CCInt<=65) then
//          IntMsgOfSet:=CCInt*1000
//        else
//          IntMsgOfSet:=CCInt*100;

        Case CCInt Of
          27  : IntMsgOfSet := 27000;   // South Africa
          44  : IntMsgOfSet := 28000;   // UK
          61  : IntMsgOfSet := 29000;   // Australia
          64  : IntMsgOfSet := 30000;   // New Zealand
          65  : IntMsgOfSet := 31000;   // Singapore
          353 : IntMsgOfSet := 32000;   // EIRE
        Else
          // FUBAR - use UK so that it works
          IntMsgOfSet := 28000;   // UK
        End; // Case CCInt

        CCVATName^:=GetIntMsg(1);
        UseDefault:=BOff;

        CCCISName^:=GetIntMsg(3);

      end;
    end;


    If (UseDefault) then
    Begin
      {* Default to UK name *}
      CurrentCountry:='044';

      // MH 17/07/07: Modified offsets because of clashes with Delphi 6.02 or misc components
      //              preventing things compiling due to clashes
      //IntMsgOfSet:=44000;
      IntMsgOfSet := 28000;   // UK

      CCVATName^:=GetIntMsg(1);

      CCCISName^:=GetIntMsg(3);

    end;
  end;
end;

Initialization



end.