unit rpcommon;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses GlobVar, VarConst;

Const
  { ============= General Data Dictionary Settings ============= }
  DataDicCode    =  'D';
  DataDicVar     =  'V';
  DataDicXRef    =  'X';
  DataDicNdx     =  'N';

  ReportGenCode  =  'R';
  RepHedTyp      =  'H';
  RepLineTyp     =  'L';
  RepNoteType    =  'N';
  RepCommandType =  'C';

  RepGroupCode   =  'H';
  RepInpCode     =  'I';
  RepRepCode     =  'R';
  RepNomCode     =  'N';
  RepNoteCode    =  'D';

  DDNmNoLen      =  8;
  DDNoNoLen      =  6;
  RFNmNoLen      =  6;
  RHGrNoLen      =  10;
  RHNaNoLen      =  10;


Function FullRepNamKey (Login        :  Str30)  :  Str30;
Function FullRepKey (RC,ST        :  Char;
                     Login        :  Str30)  :  Str30;
Function FullRepKey_RGK (RC,ST        :  Char;
                         Login        :  Str30)  :  Str30;
Function FullRepKey_NDX (RC,ST        :  Char;
                         Login        :  Str30)  :  Str30;
Function  PartCCKey (RC,ST        :  Char)  :  Str20;
Function FullDictVKey (Login        :  Str20)  :  Str20;
Function FullDictKey (RC,ST        :  Char;
                      Login        :  Str20)  :  Str20;
Function FullDictNoKey (RC,ST        :  Char;
                        Login        :  Str20)  :  Str20;
Function FullRepGroupKey(GRPS,
                         RPNS  :  Str30)  :  Str30;
Function FullRepHedKey (RC,ST        :  Char;
                        Login        :  Str30)  :  Str30;
Function PartRepLineKey (VType        :  Char;
                         VNo          :  Str30)  :  Str30;
Function FullRepLineKey (Login        :  Str30;
                         VType        :  Char;
                         VNo          :  Str30)  :  Str30;


implementation

Uses ETStrU;

{ ========= Function to Return Report Gen Code ========== }
Function FullRepNamKey (Login        :  Str30)  :  Str30;
Begin
  {*EX32}
  FullRepNamKey:=LJVar(Login,RHNaNoLen);
end;


Function FullRepKey (RC,ST        :  Char;
                     Login        :  Str30)  :  Str30;
Begin
  FullRepKey:=PartCCKey(Rc,St)+FullRepNamKey(Login);
end;


{ Build a full key for index 0 (RGK): RecPFix + SubType + ReportKey }
Function FullRepKey_RGK (RC,ST        :  Char;
                         Login        :  Str30)  :  Str30;
Begin
  Result := PartCCKey(Rc,St)+LJVar(Login,20);
end;


{ Build a full key for index 1 (RNdxK): RecPFix + SubType + RepName }
Function FullRepKey_NDX (RC,ST        :  Char;
                         Login        :  Str30)  :  Str30;
Begin
  Result := PartCCKey(Rc,St)+LJVar(Login,10);
end;


{ ========= Function to Return Part Cost Code ========== }
Function  PartCCKey (RC,ST        :  Char)  :  Str20;
Begin
  PartCCKey:=Rc+St;
end;


{ ========= Function to Return Dictionary Code ========== }
Function FullDictVKey (Login        :  Str20)  :  Str20;
Begin
  FullDictVKey:=LJVar(Login,DDNmNoLen);
end;


{ ========= Function to Return Dictionary Code ========== }
Function FullDictKey (RC,ST        :  Char;
                      Login        :  Str20)  :  Str20;
Begin
  FullDictKey:=PartCCKey(Rc,St)+FullDictVKey(Login);
end;


{ ========= Function to Return Dictionary Variable Code ========== }
Function FullDictNoKey (RC,ST        :  Char;
                        Login        :  Str20)  :  Str20;
Begin
  FullDictNoKey:=PartCCKey(Rc,St)+LJVar(Login,DDNoNoLen);
end;


Function FullRepGroupKey(GRPS,
                         RPNS  :  Str30)  :  Str30;
Begin
  FullRepGroupKey:=LJVar(GRPS,RHGrNoLen)+FullRepNamKey(RPNS);
end;


{ ========= Function to Return Report Hed Code ========== }
Function FullRepHedKey (RC,ST        :  Char;
                        Login        :  Str30)  :  Str30;
Begin
  FullRepHedKey:=PartCCKey(Rc,St)+LJVar(Login,RHNaNoLen+RHNaNoLen);
end;


{ ========= Function to Return Report Variable line ========== }
Function PartRepLineKey (VType        :  Char;
                         VNo          :  Str30)  :  Str30;
Begin
  PartRepLineKey:=LJVar(VNo,RHNaNoLen)+VType;
end;


{ ========= Function to Return Report Variable line ========== }
Function FullRepLineKey (Login        :  Str30;
                         VType        :  Char;
                         VNo          :  Str30)  :  Str30;
Begin
  FullRepLineKey:=PartRepLineKey(VType,Login)+LJVar(VNo,RFNmNoLen);
end;

end.
