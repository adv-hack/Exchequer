Unit SecSup2U;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 09/01/02                      }
{                                                              }
{                 Security Release Code Support                }
{                                                              }
{               Copyright (C) 2002 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarRec2U,
     ETDateU;

Const
  MaxSecyLen  = 5;
  MaxNoSecy   = 9;         { Duplicated in multcomp\DaliyPW.Pas }
  MaxSecNo    = 99999;
  MaxUsrRel   = 85446;
  UsrSeed     = 147;
  MaxModRel   = 99850;
  ModSeed     = 148;
  PIGSeed     = 149;
  PIMSeed     = 150;

  NoMods      = 18;
  
  MCMDPOffSet = 87;
  MCMDPOffSet2= 88;
  Vec1DPOffSet= 89; {Daily password offset for Vectron}
  DailyPW2    = 69;
  MaxDaysSecy = 30;

  OneYrMaxDaysSecy = 365;
  SecXtra365Code   = 130;

  AbsMaxDays  = 370;

  SecDistCode = 346;

  ExOldVer        =  '2.24';
  ExNewVer1       =  '2.25';
  ExNewVer2       =  '4.31';

  ExNewVer        =  '5.00';

  v1SecRelCode= 456;
  v1SecXtra30Code
              = 123;

  v2SecRelCode= 457;
  v2SecXtra30Code
              = 124;

  v3SecRelCode= 458;
  v3SecXtra30Code
              = 125;

{$IFDEF 430RC}

  {Added for Windows Card system 4.30 release codes}
  SecRelCode  = 457;
  SecXtra30Code = 124;

{$ELSE}
  SecRelCode  = 459;
  SecXtra30Code = 126;
{$ENDIF}

{ == Vectron specific Codes == }

  Vec1SecRelCode =     460;
  Vec1SecXtra30Code =  127;


Function Set_Security   :  LongInt;

Function Set_TodaySecurity  :  LongInt;

Function Calc_TodaySecurityLasts  :  LongDate;

Function Get_TodaySecurity  :  Str20;

Function Calc_SecStr(SecNo    :  LongInt;
                     Release  :  Boolean)  :  Str20;

Function Calc_Security(SecStr  :  Str20;
                       Release :  Boolean)  :  LongInt;

Function DeCode_Usrs(SecStr,RelStr  :  Str20)  :  LongInt;

Function Gen_UsrRelCode(SecStr  :  Str20;
                        NoUsrs  :  LongInt)  :  Str20;

Function ISN2Str(EXISN     : ISNArrayType)  :  Str255;

Procedure Str2ISN(ExISNStr  :  Str50;
              Var EXISN     :  ISNArrayType);

Function PI_CheckSum(PISno  :  LongInt)  :  LongInt;

  // HM 25/01/01: Published for Hook Security Checks in MCM
Function ISN_CheckSum(EXISN     : ISNArrayType)  :  Integer;

Function Get_ISNSecurity(EXISN     : ISNArrayType)  :  Str20;

{ HM 04/06/99: Published existing function for use with Single-CD }

Function Gen_ModRelCode(SecStr  :  Str20;
                        TDay    :  Boolean)  :  Str20;

Function Get_ModuleSecurity(ModNo     :  Byte;
                            RelMode   :  Boolean)  :  Str20;

Function Calc_ESN_CheckSum(ESN          :  ISNArrayType;
                           ModuleNo,
                           PIChecksum   :  SmallInt)  :  Integer;

Function Generate_ESN_BaseSecurity(ESN          :  ISNArrayType;
                                   ModuleNo,
                                   PIChecksum,
                                   EncodeNo     :  SmallInt)  :  Str20;

Function Generate_ESN_BaseRelease(SecCode  :  Str20;
                                  ModuleNo,
                                  PIChecksum
                                           :  SmallInt;
                                  Gen30Day :  Byte;
                                  SecVer   :  Str20)  :  Str20;

Function Compare_ESN_BaseSecurity(SecCode,
                                  RelCode     :  Str20;
                                  ModuleNo    :  SmallInt;
                                  Gen30Day    :  Byte;
                                  SecVer      :  Str20)  :  Boolean;

{ HM 10/01/02: Needed for Plug-In Security System }
Function CalcNewRelDate (NumDays : Integer) : Real;


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
    ETStrU,
    ETMiscU;



{ ======= Function to Return Security Mode Value ======= }
Function Ret_SecMode(X,Y       :  Integer;
                     Release   :  Boolean)  :  Str5;

{ *** Duplicated in multcomp\DaliyPW.Pas ***}

Var
  SecAry  :  Array[0..MaxNoSecy,0..MaxNoSecy] of String[2];

  N       :  Byte;

Begin

  Blank(SecAry,SizeOf(SecAry));

  If (X In [0..MaxNoSecy]) and (Y In [0..MaxNoSecy]) then
  Begin

    n:=0;
         {00}               {01}               {02}               {03}               {04}
{00}SecAry[n,0]:='HA'; SecAry[n,1]:='EL'; SecAry[n,2]:='BH'; SecAry[n,3]:='YL'; SecAry[n,4]:='PC';
         {05}               {06}               {07}               {08}               {09}
{00}SecAry[n,5]:='3S'; SecAry[n,6]:='95'; SecAry[n,7]:='3I'; SecAry[n,8]:='BM'; SecAry[n,9]:='AA';

    n:=1;
         {00}               {01}               {02}               {03}               {04}
{01}SecAry[n,0]:='XM'; SecAry[n,1]:='RS'; SecAry[n,2]:='MK'; SecAry[n,3]:='YD'; SecAry[n,4]:='W3';
         {05}               {06}               {07}               {08}               {09}
{01}SecAry[n,5]:='CD'; SecAry[n,6]:='XR'; SecAry[n,7]:='XT'; SecAry[n,8]:='GT'; SecAry[n,9]:='HH';

    n:=2;
         {00}               {01}               {02}               {03}               {04}
{02}SecAry[n,0]:='CD'; SecAry[n,1]:='JD'; SecAry[n,2]:='SW'; SecAry[n,3]:='GD'; SecAry[n,4]:='SR';
         {05}               {06}               {07}               {08}               {09}
{02}SecAry[n,5]:='FI'; SecAry[n,6]:='E5'; SecAry[n,7]:='20'; SecAry[n,8]:='RO'; SecAry[n,9]:='ZZ';

    n:=3;
         {00}               {01}               {02}               {03}               {04}
{03}SecAry[n,0]:='LK'; SecAry[n,1]:='RD'; SecAry[n,2]:='NW'; SecAry[n,3]:='SD'; SecAry[n,4]:='AV';
         {05}               {06}               {07}               {08}               {09}
{03}SecAry[n,5]:='AB'; SecAry[n,6]:='QS'; SecAry[n,7]:='MS'; SecAry[n,8]:='ZX'; SecAry[n,9]:='LL';

    n:=4;
         {00}               {01}               {02}               {03}               {04}
{04}SecAry[n,0]:='AP'; SecAry[n,1]:='MH'; SecAry[n,2]:='TQ'; SecAry[n,3]:='KD'; SecAry[n,4]:='MI';
         {05}               {06}               {07}               {08}               {09}
{04}SecAry[n,5]:='EW'; SecAry[n,6]:='AW'; SecAry[n,7]:='SS'; SecAry[n,8]:='CV'; SecAry[n,9]:='SQ';

    n:=5;
         {00}               {01}               {02}               {03}               {04}
{05}SecAry[n,0]:='DR'; SecAry[n,1]:='RA'; SecAry[n,2]:='GU'; SecAry[n,3]:='AC'; SecAry[n,4]:='AT';
         {05}               {06}               {07}               {08}               {09}
{05}SecAry[n,5]:='FS'; SecAry[n,6]:='37'; SecAry[n,7]:='JS'; SecAry[n,8]:='SA'; SecAry[n,9]:='ZQ';

    n:=6;
         {00}               {01}               {02}               {03}               {04}
{06}SecAry[n,0]:='OD'; SecAry[n,1]:='GS'; SecAry[n,2]:='MA'; SecAry[n,3]:='SC'; SecAry[n,4]:='DX';
         {05}               {06}               {07}               {08}               {09}
{06}SecAry[n,5]:='ES'; SecAry[n,6]:='41'; SecAry[n,7]:='JA'; SecAry[n,8]:='FI'; SecAry[n,9]:='GG';


    n:=7;
         {00}               {01}               {02}               {03}               {04}
{07}SecAry[n,0]:='DJ'; SecAry[n,1]:='RG'; SecAry[n,2]:='SX'; SecAry[n,3]:='MB'; SecAry[n,4]:='SZ';
         {05}               {06}               {07}               {08}               {09}
{07}SecAry[n,5]:='OC'; SecAry[n,6]:='35'; SecAry[n,7]:='GG'; SecAry[n,8]:='LA'; SecAry[n,9]:='F0';


    n:=8;
         {00}               {01}               {02}               {03}               {04}
{08}SecAry[n,0]:='SB'; SecAry[n,1]:='AJ'; SecAry[n,2]:='KT'; SecAry[n,3]:='BD'; SecAry[n,4]:='PP';
         {05}               {06}               {07}               {08}               {09}
{08}SecAry[n,5]:='P5'; SecAry[n,6]:='G7'; SecAry[n,7]:='EM'; SecAry[n,8]:='16'; SecAry[n,9]:='69';

    n:=9;
         {00}               {01}               {02}               {03}               {04}
{09}SecAry[n,0]:='NS'; SecAry[n,1]:='SN'; SecAry[n,2]:='TK'; SecAry[n,3]:='TD'; SecAry[n,4]:='QQ';
         {05}               {06}               {07}               {08}               {09}
{09}SecAry[n,5]:='II'; SecAry[n,6]:='TT'; SecAry[n,7]:='ZN'; SecAry[n,8]:='KN'; SecAry[n,9]:='66';


    Case Release of
      BOff  :  Ret_SecMode:=SecAry[X,Y];
      BOn   :  Ret_SecMode:=SecAry[Y,X];
    end; {Case..}
  end
  else
    Ret_SecMode:='??';

end;





{ ===== Function to return random initial security code ===== }

Function Set_Security   :  LongInt;

Var
  Sec      :  LongInt;
  SecStr   :  Str5;
  n        :  Byte;


Begin

  SecStr:='';

  Sec:=0;

  Randomize;

  For n:=1 to MaxNoSecy do
    SecStr:=SecStr+Form_Int(Random(9),0);

  Sec:=IntStr(SecStr);

  If (Sec>(MaxSecNo-SecRelCode)) then
    Sec:=(MaxSecNo-SecRelCode);

  Set_Security:=Sec;

end; {Func..}




{ ==== Function to Set Security for Today ==== }

Function Set_TodaySecurity  :  LongInt;

{ *** Duplicated in multcomp\DaliyPW.Pas ***}

Var
  JulToday  :  LongInt;
  JulStr    :  Str10;

  Rd,Rm,Ry  :  Word;

Begin
  DateStr(Today,Rd,Rm,Ry);

  If (Ry>=2000) then
    JulToday:=Round(CalJul(Rd,Rm,Ry))
  else
    JulToday:=Round(CalJul(Rd,Rm,ConvTxYrVal(Ry,BOn)));

  JulStr:=Form_Int(JulToday,0);

  JulStr:=Copy(JulStr,Length(JulStr)-4,4);

  Set_TodaySecurity:=IntStr(JulStr);

end;


{ ==== Function to work out how long the daily password will last ==== }

Function Calc_TodaySecurityLasts  :  LongDate;


Var
  n,
  JulToday  :  LongInt;
  JulStr,
  TStr      :  Str10;

  TomD      :  LongDate;

  Rd,Rm,Ry  :  Word;

Begin
  TStr:=Form_Int(Set_TodaySecurity,0);

  For n:=1 to 32 do
  Begin
    TomD:=CalcDueDate(Today,n);

    DateStr(TomD,Rd,Rm,Ry);

    If (Ry>=2000) then
      JulToday:=Round(CalJul(Rd,Rm,Ry))
    else
      JulToday:=Round(CalJul(Rd,Rm,ConvTxYrVal(Ry,BOn)));

    JulStr:=Form_Int(JulToday,0);

    JulStr:=Copy(JulStr,Length(JulStr)-4,4);

    If (JulStr<>TStr) then
      Break;

  end; {Loop..}

  Result:=TomD;

end;




{ ===== Function to Retrun Security String ===== }


Function Calc_SecStr(SecNo    :  LongInt;
                     Release  :  Boolean)  :  Str20;

{ *** Duplicated in multcomp\DaliyPW.Pas ***}

Var
  SecStr,
  SecEncStr  :  Str20;
  Sl,n       :  Byte;


Begin

  SecStr:=Form_Int(SecNo,0);

  Sl:=Length(SecStr);

  SecEncStr:='';


  For n:=1 to Sl do
    SecEncStr:=SecEncStr+Ret_SecMode(n,IntStr(SecStr[n]),Release);

  Calc_SecStr:=SecEncStr;

end; {Func..}


{ ===== Function to Get Sec Code Equiv of Todays Security ===== }

Function Get_TodaySecurity  :  Str20;

{ *** Duplicated in multcomp\DaliyPW.Pas ***}

Begin

  Get_TodaySecurity:=Calc_SecStr(Set_TodaySecurity,BOn);

end;

{ ================ Procedure to Compare Search Keys ============= }
{ Own copy made here as we want to avoid dragging BTSUpU1 into this unit since it is shared out in other apps}

Function SecCheckKey(KeyRef,Key2Chk  :  AnyStr;
                     KeyLen          :  Integer;
                     AsIs            :  Boolean) :  Boolean;

Begin
  If (Length(Key2Chk)>=KeyLen) then
    SecCheckKey:=(UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)=UpcaseStrList(Copy(KeyRef,1,KeyLen),AsIs))
  else
    SecCheckKey:=False;
end;


{ ======== Function to Match Mode part of sec code ======== }

Function Match_SecMode(Key       :  Integer;
                       ModStr    :  Str5;
                       Release   :  Boolean)  :  Integer;



Var
  n         :  Byte;
  FoundOk   :  Boolean;


Begin
  n:=0;

  FoundOk:=BOff;

  While (n<=MaxNoSecy) and (Not FoundOk) do
  Begin

    FoundOk:=(SecCheckKey(Ret_SecMode(Key,n,Release),ModStr,Length(ModStr),BOff));

    If (Not FoundOk) then
      Inc(n);

  end; {While..}

  If (Not FoundOk) then
    Match_SecMode:=0
  else
    Match_SecMode:=n;

end; {Func..}



{ ====== Function to Calc security no. form encoded Str ====== }


Function Calc_Security(SecStr  :  Str20;
                       Release :  Boolean)  :  LongInt;


Var
  Sl,m,n     :  Byte;

  SecEncStr  :  Str20;


Begin

  Sl:=Length(SecStr);

  m:=1; n:=1;

  SecEncStr:='';

  While (m<=Sl) and (n<=MaxNoSecy) do
  Begin
    SecEncStr:=SecEncStr+Form_Int(Match_SecMode(n,Copy(SecStr,m,2),Release),0);

    Inc(n);

    m:=m+2;

  end; {While..}

  Calc_Security:=IntStr(SecEncStr);

end; {Func..}


{ == Display ISN == }

Function ISN2Str(EXISN     : ISNArrayType)  :  Str255;


Var
  n       :  Byte;

Begin
  Result:='';

  For n:=Low(EXISN) to High(EXISN)-2 do
  Begin
    Result:=Result+SetPadNo(Form_Int(EXISN[n],0),3);

    If (n<>High(EXISN)-2) then
      Result:=Result+'-';
  end;

end;

Procedure Str2ISN(ExISNStr  :  Str50;
              Var EXISN     :  ISNArrayType);

Var
  n  :  Byte;
Begin
  FillChar(EXISN,Sizeof(EXISN),0);

  For n:=Low(EXISN) to HIGH(EXISN)-2 do
  Begin
    EXISN[n]:=IntStr(Copy(ExISNStr,1+(Pred(n)*4),3));

  end;

end;


Procedure PIStr2ISN(PIStr     :  Str50;
                Var EXISN     :  ISNArrayType);

Var
  n  :  Byte;
Begin
  FillChar(EXISN,Sizeof(EXISN),0);

  For n:=Low(EXISN) to HIGH(EXISN) do
  Begin
    EXISN[n]:=IntStr(Copy(PIStr,1+Pred(n),1));

  end;

end;


Function ISN_CheckSum(EXISN     : ISNArrayType)  :  Integer;

Var
  n       :  Integer;

  Inum    :  Integer;

Begin
  Result:=0;
  Inum:=0;

  For n:=Low(EXISN) to High(EXISN)-2 do
    Inum:=Inum+EXISN[n];

  Result := Inum Mod 9;

  If (Result<0) or (Result>9) then
    Result:=9;

end;


Function Calc_PICheckSum(EXISN     : ISNArrayType)  :  Integer;

Var
  n       :  Integer;

  Inum    :  Integer;

  CSStr   :  Str20;


Begin
  Result:=0;
  Inum:=0;

  For n:=Low(EXISN) to High(EXISN)-2 do
    Inum:=Inum+(EXISN[n]*n);

  If (Inum>90) then
  Begin
    CSStr:=Form_Int(Inum,0);

    Result:=IntStr(Copy(CSStr,Length(CSStr)-1,2));
  end
  else
    Result:=Inum;

  If (Result<0) or (Result>90) then
    Result:=9;

end;


Function PI_CheckSum(PISno  :  LongInt)  :  LongInt;

Var
  PIESN   :  ISNArrayType;

begin

  PIStr2ISN(SetPadNo(Form_Int(PISNo,0),High(PIESN)-2),PIESN);

  Result:=Calc_PICheckSum(PIESN);
end;


{ == Function to Generate an ISN based Security Code == }

Function Get_ISNSecurity(EXISN     : ISNArrayType)  :  Str20;

Begin
  Get_ISNSecurity:=Get_ModuleSecurity(ISN_CheckSum(EXISN),BOff);

end;

Function DeCode_Usrs(SecStr,RelStr  :  Str20)  :  LongInt;

Var
  SecNo,
  RelNo,
  Lnum    :  LongInt;

Begin

  SecNo:=Calc_Security(SecStr,BOff);

  If (SecNo>MaxUsrRel) then
    SecNo:=MaxUsrRel;

  RelNo:=Calc_Security(RelStr,BOn);

  Lnum:=RelNo-SecNo;

  If ((Lnum Mod UsrSeed)=0) and (Lnum<>0) then
    DeCode_Usrs:=Lnum Div UsrSeed
  else
    DeCode_Usrs:=1;


end; {Func.,.}


{ ===== Functions for setting and resetting Number of users ===== }

Function Gen_UsrRelCode(SecStr  :  Str20;
                        NoUsrs  :  LongInt)  :  Str20;

Var
  SecNo  :  LongInt;


Begin

  SecNo:=Calc_Security(SecStr,BOff);

  If (SecNo>MaxUsrRel) then
    SecNo:=MaxUsrRel;

  SecNo:=SecNo+(NoUsrs*UsrSeed);

  Gen_UsrRelCode:=Calc_SecStr(SecNo,BOn);


end; {Func..}


{ ===== Functions for setting and resetting Module release ===== }

Function Gen_ModRelCode(SecStr  :  Str20;
                        TDay    :  Boolean)  :  Str20;

Var
  SecNo  :  LongInt;


Begin

  SecNo:=Calc_Security(SecStr,BOn);

  If (SecNo>MaxModRel) then
    SecNo:=MaxModRel;

  SecNo:=SecNo+ModSeed+Ord(TDay);

  Gen_ModRelCode:=Calc_SecStr(SecNo,BOn);


end; {Func..}



Function Get_ModuleSecurity(ModNo     :  Byte;
                            RelMode   :  Boolean)  :  Str20;

Var
  TStr  :  Str255;

  SecNo :  LongInt;

  l,n   :  Byte;

Begin
  SecNo:=Set_Security;

  TStr:=Form_Int(SecNo,0);

  l:=Length(TStr);

  If (ModNo>9) then
    n:=2
  else
    n:=1;

  TStr:=Copy(TStr,1,l-n)+Form_Int(ModNo,0);

  SecNo:=IntStr(TStr);

  Get_ModuleSecurity:=Calc_SecStr(SecNo,RelMode);

end;


{v5 Routines to give ESN based security codes for all options

Calculate the ending checksum

Parameters:-
 ESN       :  ESN code to be used when calculating checksum

 ModuleNo:-

   0        :  Generate Security code for main Enterprise Security
   1..99    :  All modules, security and user counts

   241      :  Vectron Full Security;
   242      :  Vectron 30 Day Secuurity;
   243      :  Vectron Daily Password;
   244      :  Alternative daily password for use only if normal daily password has been blocked.
   245      :  MCM main daily password
   246      :  MCM Company count 30 days.
   247      :  Enterprise User Count 30 days
   248      :  MCM Daily Password, only allows access to plug-in security
   249      :  Distributor security code, will embed no of releases within the code
   250      :  Plugin User Count
   251      :  Enterprise daily password
   252      :  Plug-ins based on id checksum
   253      :  MCM Company Count
   254      :  Enterprise user count, full
 1001..1099 :  Module 1-99 30 day user count

 PICheckSum : Checksum based on Plug-In (252) serial no to be combined with ESN to give valid code
              The checksum is calucalted by converting the 6 digit element of the PI checksum
              into an ESN using PIStr2ESN, and then calling ISB_CheckSum with the resultant PIESNNo

}


Function Calc_ESN_CheckSum(ESN          :  ISNArrayType;
                           ModuleNo,
                           PIChecksum   :  SmallInt)  :  Integer;
Var
  PsuedoModNo  :  SmallInt;

Begin
  Result:=0; PsuedoModNo:=0;

  Case ModuleNo of
    1..99,
    1001..1099
            :  Begin
                 If (ModuleNo>1000) then
                   PsuedoModNo:=ModuleNo-1000
                 else
                   PsuedoModNo:=ModuleNo;

                 Result:=PsuedoModNo+ISN_CheckSum(ESN)+Ord(ModuleNo>1000);
               end;

            {MCM Company count 30 days}
    246,
    253     :  Begin
                 Result:=2+Ord(ModuleNo=246)+ISN_CheckSum(ESN);
               end;

        {User count 30 days}
    247     :  Begin
                 Result:=1+ISN_CheckSum(ESN);
               end;

                {Distributor release based on no of releases}
    249     :  Begin
                 Result:=0;
               end;

            {Plug-in User Count}
    250     :  Begin
                 Result:=PIChecksum+ISN_CheckSum(ESN)+1;
               end;


        {Plug-in module based on check sum}
    252     :  Begin
                 Result:=PIChecksum+ISN_CheckSum(ESN);
               end;

        {All other security which needs to be ESN based}

    else  Result:=ISN_CheckSum(ESN);

  end; {Case..}


end;

{
Generate_ESN_BaseSecurity

 encodeNo   : Used with moduleno 249 & 250 to embed number of releases
}

Function Generate_ESN_BaseSecurity(ESN          :  ISNArrayType;
                                   ModuleNo,
                                   PIChecksum,
                                   EncodeNo     :  SmallInt)  :  Str20;
Var
  PsuedoModNo  :  SmallInt;
Begin

  Result:=''; PsuedoModNo:=0;

  Case ModuleNo of

        {Module 1-99 Security + Usercounts}
    1..99,
    1001..1099
            :  Begin
                 If (ModuleNo>1000) then
                   PsuedoModNo:=ModuleNo-1000
                 else
                   PsuedoModNo:=ModuleNo;

                 Result:=Get_ModuleSecurity(Calc_ESN_CheckSum(ESN,ModuleNo,PIChecksum),(EnCodeNo=0));
               end;

                  {Vectron Daily password}
    243     :  Begin
                 Result:=Calc_SecStr(Set_TodaySecurity-Vec1DPOffSet,BOn);
               end;


              {Daily password2, for use if normal one blocked}
    244     :  Begin
                 Result:=Calc_SecStr(Set_TodaySecurity-DailyPW2,BOn);
               end;

                {MCM Main Daily password}
    245     :  Begin
                 Result:=Calc_SecStr(Set_TodaySecurity-MCMDPOffSet2,BOn);
               end;

            {MCM Company count 30 days}
    246,
    253     :  Begin
                 Result:=Get_ModuleSecurity(Calc_ESN_CheckSum(ESN,ModuleNo,PIChecksum),BOff);
               end;

        {User count 30 days}
    247     :  Begin
                 Result:=Get_ModuleSecurity(Calc_ESN_CheckSum(ESN,ModuleNo,PIChecksum),BOff);
               end;

            {MCM Daily password}
    248     :  Begin
                 Result:=Calc_SecStr(Set_TodaySecurity-MCMDPOffSet,BOn);
               end;

                {Distributor release based on no of releases}
    249     :  Begin
                 Result:='Not coded yet!';
               end;

            {Plug-in User Count}
    250     :  Begin
                 Result:=Get_ModuleSecurity(Calc_ESN_CheckSum(ESN,ModuleNo,PIChecksum),BOff);
               end;

            {Enterprise Daily password}
    251     :  Begin
                 Result:=Get_TodaySecurity;
               end;

        {Plug-in module based on check sum}
    252     :  Begin
                 Result:=Get_ModuleSecurity(Calc_ESN_CheckSum(ESN,ModuleNo,PIChecksum),BOff);
               end;
        {All other security which needs to be ESN based}

    else      Result:=Get_ISNSecurity(ESN);


  end; {Case..}

end;


{ == Generate expected release codes == }

Procedure SelectMainOffSet(Var SecSetM,
                               SecSetY,
                               SecSetF          :  LongInt;
                               SecVer           :  Str20);

Begin
  SecSetY:=0;

  If (SecVer<ExNewVer1) then
  Begin
    SecSetM:=v1SecXtra30Code;
    SecSetF:=v1SecRelCode;
  end
  else
    If (SecVer<ExNewVer2) then
    Begin
      SecSetM:=v2SecXtra30Code;
      SecSetF:=v2SecRelCode;
    end
    else
      If (SecVer<ExNewVer) then
      Begin
        SecSetM:=v3SecXtra30Code;
        SecSetF:=v3SecRelCode;
      end
      else
      Begin
        SecSetM:=SecXtra30Code;
        SecSetF:=SecRelCode;

        SecSetY:=SecXtra365Code;

      end;
end; {Proc}

{v5.61.  Gen30Day changed to byte as follows

0 = 30 day code not required.
1 = 30 day required as previously
2 = 365 day code required

}

Function Generate_ESN_BaseRelease(SecCode  :  Str20;
                                  ModuleNo,
                                  PIChecksum
                                           :  SmallInt;
                                  Gen30Day :  Byte;
                                  SecVer   :  Str20)  :  Str20;
Var
  FullExSecy,
  Use30,
  Use365,
  UseFull
                :  LongInt;

Begin

  Result:=''; FullExSecy:=0;

  {* Adjust offset on main code depending on version *}

  SelectMainOffSet(Use30,Use365,UseFull,SecVer);

  If (Gen30Day>0)

  and (Not (ModuleNo In [1..99,241..243])) then
  Begin
      FullExSecy:=Calc_Security(SecCode,BOff)+(Use30*Ord(Gen30Day=1))+(Use365*Ord(Gen30Day=2));
    
    Result:=Calc_SecStr(FullExSecy,BOn);

  end
  else
  Case ModuleNo of
        {Main Release Code}
    0       :  Begin
                 FullExSecy:=Calc_Security(SecCode,BOff)+UseFull;

                 Result:=Calc_SecStr(FullExSecy,BOn);
               end;

        {Module 1-99 Security}
    1..99   :  Begin
                 Result:=Gen_ModRelCode(SecCode,(Gen30Day=1) );
               end;
                    {Vectron Full release code}
    241     :  Begin
                 FullExSecy:=Calc_Security(SecCode,BOff)+Vec1SecRelCode;

                 Result:=Calc_SecStr(FullExSecy,BOn);
               end;

                {Vectron 30 day release code}
    242     :  Begin
                 FullExSecy:=Calc_Security(SecCode,BOff)+Vec1SecXtra30Code;

                 Result:=Calc_SecStr(FullExSecy,BOn);
               end;

              {Vectron Daily password}
    243     :  Begin
                 Result:=Calc_SecStr(Set_TodaySecurity-Vec1DPOffSet,BOn);
               end;

              {Daily password2, for use if normal one blocked}
    244     :  Begin
                 Result:=Calc_SecStr(Set_TodaySecurity-DailyPW2,BOn);
               end;

        {MCM Main Daily password}
    245     :  Begin
                 Result:=Calc_SecStr(Set_TodaySecurity-MCMDPOffSet2,BOn);
               end;

            {MCM Daily password}
    248     :  Begin
                 Result:=Calc_SecStr(Set_TodaySecurity-MCMDPOffSet,BOn);
               end;

                {Distributor release based on no of releases}
    249     :  Begin
                 FullExSecy:=Calc_Security(SecCode,BOff)+SecDistCode;

                 Result:=Calc_SecStr(FullExSecy,BOn);
               end;

    250     :  ; {Use Decode_Usrs}

            {Enterprise Daily password}
    251     :  Begin
                 {No Release Code Required}
               end;

        {Plug-in module based on check sum}
    252     :  Begin
                 FullExSecy:=Calc_Security(SecCode,BOff)+PIMSeed;

                 Result:=Calc_SecStr(FullExSecy,BOn);
               end;

    254     :  ; {Use Decode_Usrs}

    1001..1099
            :  ; {Use Decode_Usrs}


  end; {Case..}

end;


{* Compare stored ReCode with manufactured relCode *}

Function Compare_ESN_BaseSecurity(SecCode,
                                  RelCode     :  Str20;
                                  ModuleNo    :  SmallInt;
                                  Gen30Day    :  Byte;
                                  SecVer      :  Str20)  :  Boolean;

Begin
  Result:=(RelCode=Generate_ESN_BaseRelease(SecCode,ModuleNo,0,Gen30Day,SecVer));

end;



{ HM 10/01/02: Needed for Plug-In Security System }
Function CalcNewRelDate (NumDays : Integer) : Real;
Var
  RelDateStr        :  LongDate;
  RelDOW, RelMoveX  :  Byte;
  Rd, Rm, Ry        :  Word;
Begin { CalcNewRelDate }
  RelDateStr:=CalcDueDate(Today, NumDays);

  RelDOW:=DayofWeek(RelDateStr);

  Case RelDOW of {* Its at the weekend/Bank hols ... move to mid week *}

   0,1   :  RelMoveX:=2;
   5,6   :  RelMoveX:=(4-(RelDOW-5));

   else     RELMoveX:=0;

  end; {Case..}

  If (RelMoveX>0) then
    RelDateStr:=CalcDueDate(RelDateStr,RelMoveX);

  DateStr(RelDateStr,Rd,Rm,Ry);

  Result := CalJul(Rd,Rm,Ry);
End; { CalcNewRelDate }


end.
