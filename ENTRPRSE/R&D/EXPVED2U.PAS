Unit ExpVED2U;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 14/10/93                      }
{                      Export CC Sheduler                      }
{                                                              }
{                                                              }
{               Copyright (C) 1992 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst;



Var
  VEDIF     :   File of Char;
  VEDILogF  :   Text;

Const
  CAEFName   =  'KEDCSD';




Function BuildPath(Pa  :  Str255)  : Str255;


Function RetVATRegNo(VReg  :  Str30)  :  Str30;

Function  EDIFName(TestMode  :  Boolean;
                   VMode     :  Byte)  :  Str255;


Function VEDIMethodID(EM,VM  :  Byte)  :  Str80;


Function VEDIFmtStr(S        :  Str255)  :  Str255;

Function VEDIFmtStrUC(S        :  Str255)  :  Str255;

Function  ShortDate(LDate  :  LongDate)  :  Str10;


Function  EDICISFName(TestMode  :  Boolean;
                      VMode     :  Byte;
                      EDate     :  LongDate)  :  Str255;

Function  XMLCISFName(VMode     :  Byte;
                      EDate     :  LongDate)  :  Str255;

Function CEDIMethodID(EM,VM  :  Byte)  :  Str80;


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   VarRec2U,
   {VarFPosU,}
   ETMiscU,
   ETStrU,
   ETDateU,
   ComnUnit,
   ComnU2,
   BtrvU2,
   CurrncyU,
   SysU1,
   SysU2,
   BTSUpU1;


Const
  ErrLogName = 'LOGS\EXVATEDI.LOG';



{ ==== Funtion to add '\' to path if necessary == }

Function BuildPath(Pa  :  Str255)  : Str255;

Begin
  If (Pa[Length(pa)]<>'\') then
    BuildPath:=Pa+'\'
  else
    BuildPath:=Pa;

end;






Function VEDIVANID(VM  :  Byte)  :  Str80;


Begin
  Case VM of

    1,4
       :  Result:='5013546006194';
    2  :  Result:='HMCE';
    3  :  Result:='GBCUS CUS001';
    else  Result:='MHS!HMCE';
  end; {Case..}

end;

{ ======== Return ID based on EDIMethod ======== }

Function VEDIMethodID(EM,VM  :  Byte)  :  Str80;



Begin

  Case EM of
    1  : Result:=VEDIVANID(VM);
    2  : Result:='OTHER';
    else Result:='DISK';

  end; {Case..}


end;

{ == Filter out any illegal character sets == }

Function ConvVEDIFmtStr(S        :  Str255;
                        UPC      :  Boolean)  :  Str255;

Const
  EDIFACTSET  :  Set of Char = [#39,'+',':','?'];

Begin


  Result:=Strip('A',EDIFactSet,S);

  If (UPC) then
    Result:=UpCaseStr(Result);
end;



Function VEDIFmtStr(S        :  Str255)  :  Str255;


Begin
  VEDIFmtStr:=ConvVEDIFmtStr(S,BOff);
end;


Function VEDIFmtStrUC(S        :  Str255)  :  Str255;


Begin
  VEDIFmtStrUC:=ConvVEDIFmtStr(S,BOn);
end;


{ == Function to Retuen the short date version == }

Function  ShortDate(LDate  :  LongDate)  :  Str10;

Begin

  ShortDate:=Copy(LDate,3,6);

end;



{ ** Function to Extract The Correct VAT Element by taking from Pos 3 onwards **}

Function RetVATRegNo(VReg  :  Str30)  :  Str30;


Begin
  Result:=VEDIFmtStr(Strip('A',[#32],UpCaseStr(Copy(VReg,3,Length(VReg)-2))));
end;



{* Return file name based on TestMode/VAT Reg No. *}

Function  EDIFName(TestMode  :  Boolean;
                   VMode     :  Byte)  :  Str255;

Const
  EDIUKName  :  Array[BOff..BOn] of Str20 = (CAEFName+'.TRX',CAEFName+'.TST');

  EDIIEName  :  Array[0..2] of Char = ('V','S','S');


Begin
  Result:='';

  If (CurrentCountry<>IECCode) then
  Begin
    Result:=EDIUKName[TestMode];

  end
  else
  Begin
    Result:=RETVATRegNo(Copy(Syss.UserVATReg,1,8))+'.'+EDIIEName[VMode]+'E0';

  end;

end;


{* Return file name based on TestMode/OUT PUT MODE. *}

Function  EDICISFName(TestMode  :  Boolean;
                      VMode     :  Byte;
                      EDate     :  LongDate)  :  Str255;

Const
  EDIUKName  :  Array[0..2] of Str20 = ('CISV','','CEOY');



Begin
  If (VMode=2) then
    Result:=EDIUKName[VMode]+Copy(EDate,1,4)
  else
    Result:=EDIUKName[VMode]+Copy(ShortDate(EDate),3,2)+Copy(ShortDate(EDate),1,2);

  If (TestMode) then
    Result:=Result+'.TST'
  else
    Result:=Result+'.TRX';
end;




{* Return file name based on TestMode/OUT PUT MODE. *}

Function  XMLCISFName(VMode     :  Byte;
                      EDate     :  LongDate)  :  Str255;



Begin
  Result:='CIS'+Copy(ShortDate(EDate),3,2)+Copy(ShortDate(EDate),1,2);

  Result:=Result+'.XML'
end;



Function CEDIVANID(VM  :  Byte)  :  Str80;


Begin
  Case VM of

    4
       :  Result:='5013546096166';
    3  :  Result:='GBEDS GBEDS003';
    else  Result:='INLANDREVENUE';
  end; {Case..}

end;

{ ======== Return ID based on EDIMethod ======== }

Function CEDIMethodID(EM,VM  :  Byte)  :  Str80;



Begin

  Case EM of
    1  : Result:=CEDIVANID(VM);
    2  : Result:='OTHER';
    else Result:='DISK';

  end; {Case..}


end;




end.

