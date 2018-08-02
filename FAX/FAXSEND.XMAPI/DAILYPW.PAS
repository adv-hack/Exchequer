unit DailyPW;

interface

Uses GlobVar;

{ ===== Function to Get Sec Code Equiv of Todays Security ===== }
Function Get_TodaySecurity : Str20;


implementation

Uses ETDateU, ETMiscU, ETStrU;


Const
  MaxNoSecy   = 9;


{ ==== Function to Set Security for Today ==== }
Function Set_TodaySecurity  :  LongInt;
Var
  JulToday  :  LongInt;
  JulStr    :  Str10;
  Rd,Rm,Ry  :  Word;
Begin { Set_TodaySecurity }
  DateStr(Today,Rd,Rm,Ry);

  If (Ry>=2000) then
    JulToday:=Round(CalJul(Rd,Rm,Ry))
  else
    JulToday:=Round(CalJul(Rd,Rm,ConvTxYrVal(Ry,BOn)));

  JulStr:=Form_Int(JulToday,0);

  JulStr:=Copy(JulStr,Length(JulStr)-4,4);

  Set_TodaySecurity:=IntStr(JulStr);
end; { Set_TodaySecurity }


{ ======= Function to Return Security Mode Value ======= }
Function Ret_SecMode(X,Y       :  Integer;
                     Release   :  Boolean)  :  Str5;
Var
  SecAry  :  Array[0..MaxNoSecy,0..MaxNoSecy] of String[2];
  N       :  Byte;
Begin { Ret_SecMode }
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
end; { Ret_SecMode }


{ ===== Function to Return Security String ===== }
Function Calc_SecStr(SecNo    :  LongInt;
                     Release  :  Boolean)  :  Str20;
Var
  SecStr, SecEncStr  :  Str20;
  Sl,n               :  Byte;
Begin { Calc_SecStr }
  SecStr:=Form_Int(SecNo,0);

  Sl:=Length(SecStr);

  SecEncStr:='';

  For n:=1 to Sl do
    SecEncStr:=SecEncStr+Ret_SecMode(n,IntStr(SecStr[n]),Release);

  Calc_SecStr:=SecEncStr;
end; { Calc_SecStr }


{ ===== Function to Get Sec Code Equiv of Todays Security ===== }
Function Get_TodaySecurity : Str20;
Begin { Get_TodaySecurity }
  Get_TodaySecurity:=Calc_SecStr(Set_TodaySecurity,BOn);
end; { Get_TodaySecurity }


end.
