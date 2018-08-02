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

// {$R MES044.RES}

{ ===== Return Msg from String Table ====== }

Function  GetIntMsg(MNo  :  Integer)  :  Str255;

Var
  KeyS    :  Array[0..254] of Char;
  PC      :  PChar;
  RetLen  :  Integer;

Begin
  Result:='ERROR';

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

      CCInt:=IntStr(Strip('B',[#32],CurrentCountry));
{
      If ((CCInt In [27,44,61,64,65]) or (CCInt=353)) and (CCInt<>IntMsgOfSet) then
      Begin
        If (CCInt<=65) then
          IntMsgOfSet:=CCInt*1000
        else
          IntMsgOfSet:=CCInt*100;

        CCVATName^:=GetIntMsg(1);
        UseDefault:=BOff;

        CCCISName^:=GetIntMsg(3);

      end;
}
    end;


    If (UseDefault) then
    Begin
      CurrentCountry:='044';

      IntMsgOfSet:=44000;

      CCVATName^:='VAT';  //GetIntMsg(1);

      CCCISName^:='CIS';  //GetIntMsg(3);

    end;
  end;

end;

Initialization



end. {Unit..}