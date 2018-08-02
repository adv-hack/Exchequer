unit BtKeys1U;


interface

Uses
  GlobVar,
  {$IFNDEF BTRVSQL_DLL}
  VarConst,
  {$ELSE}
  CompilableVarRec,
  {$ENDIF}
  VarRec2U,

  BtrvU2;

{$IFDEF SOPDLL}
  {$UNDEF EXDLL}
{$ENDIF}

Const
  CustKeyLen    =  6;
  CustKey2Len   =  20;
  CustCompLen   =  45;
  CustTTLen     =  80;
  CustACTLen    =  4;
  StkKeyLen     =  16;
  StkDesKLen    =  35;
  DocKeyLen     =  9;

  DocYRef1Len   =  20;
  DocYRef2Len   =  20;
  DocDesLen     =  50;
  LoginKeyLen   =  10;
  SNoKeyLen     =  20;
  BNoKeyLen     =  10;
  BinKeyLen     =  10;
  CCKeyLen      =  3;
  CCDpKeyLen    =  7;
  CCDescLen     =  20;
  MLocKeyLen    =  3;
  MLDescKeyLen  =  45;
  CustVATLen    =  20;
  NomKeyLen     =  6;
  NomDesLen     =  40;
  NomAltCLen    =  50;
  BankALen      =  35;  //PR: 25/07/2013 Extend for SEPA
  BankSLen      =  15;
  BankRLen      =  28;
  BankMLen      =  30;
  LDateKeyLen   =  8;
  JobKeyLen     =  10;
  AnalKeyLen    =  10;
  EmplKeyLen    =  06;
  PIKeyLen      =  10;
  QtyDiscKeyLen =  07; {? If the length of the qty ever changes, this will need to change as well for Qty breaks/Cust QB to be stored correctly.!!}
  BinLocLen     =  10;
  UStkLen       =  10;
  PWKeyLen      =  09; {Length of encypted password}

  VNomKeyLen    =  50;

  CustPhoneLen  =  30;
  CustRefNoLen  =  10;
  PostCodeLen   =  20;
  EmailAddrLen  =  100;
  BarCodeLen    =  20;
  JobDescLen    =  30;
  AnalDescLen   =  20;

  LongCustCodeLen
                =  30; //PR: 21/08/2013 MRD1.1.01


Function FullNomKey(ncode  :  Longint)  :  Str20;

Function UnFullNomKey(sString : string) : LongInt;

Function FullCustCode(CCode  :  Str10) :  AnyStr;

Function FullCustCode2(CCode  :  Str20) :  AnyStr;

Function FullCompKey(CCode  :  Str50) :  AnyStr;

Function FullCVATKey(CCode  :  Str30) :  AnyStr;

Function FullPostCode(CCode  :  Str20) :  AnyStr;

Function FullEmailAddr(CCode  :  Str100) :  AnyStr;

Function FullRefNo(CCode : Str10) : AnyStr;

Function FullCustPhone(CCode : Str30) : AnyStr;

Function FullDayBkKey(Rno,Fno  :  Longint;
                      DPrefix  :  Str5)  :  Str20;

Function FullRunNoKey(Rno,Fno  :  Longint)  :  Str20;

Function FullOurRefKey(DCode  :  Str10)  :  Str10;

Function FullLedgerKey(CCode  :  Str20;
                       CSup   :  Char;
                       NCode  :  Boolean)  :  Str20;


Function FullNCode(CCode  :  Str10) :  AnyStr;

Function FullNHCode(CCode  :  Str20) :  AnyStr;

Function FullIDPostKey(Cno,Rno      :  Longint;
                       PNm,PCr,
                       PYr,PPr      :  Byte)  :  Str20;

Function FullPWordKey (RC,ST        :  Char;
                       Login        :  Str20)  :  Str20;

Function PartPLockKey (Mode         :  Byte)  :  Str20;

Function FullPLockKey (RC,ST        :  Char;
                       Mode         :  Byte)  :  Str20;

Function  PartHelpKey (RC,ST        :  Char;
                       HelpNo       :  Longint)  :  Str20;

Function  FullHelpKey (RC,ST        :  Char;
                       HelpNo,
                       HelpOrd      :  LongInt)  :  Str20;

Function  PartCCKey (RC,ST        :  Char)  :  Str20;

Function FullCCKey (RC,ST        :  Char;
                    Login        :  Str20)  :  Str20;

Function FullCCDepKey (Login        :  Str5)  :  Str5;

{$IFNDEF BTRVSQL_DLL}
Function Show_CCFilt(lc      :  Str10;
                     ccMode  :  Boolean)  :  Str80;
{$ENDIF}

Function Show_CommitMode(ccMode  :  Byte)  :  Str80;

Function PartNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr   :  Byte)  :  Str30;

Function FullNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr,Yr,
                      Pr   :  Byte)  :  Str30;

Procedure Extract_NHistfromNKey(NKey  :  Str255;
                            Var NHR   :  HistoryRec);

Function AutoSetInvKey(InpKey   :  Str255;
                       IKNo     :  Integer)  :  Str255;

Function Pay_RunNo(DocHed :  DocTypes;
                   PayRun :  LongInt)  :  Str10;

Function FullStockCode(CCode  :  Str20) :  AnyStr;

Function FullBarCode(CCode  :  Str20) :  AnyStr;


Function PrimeNVCode(RC,ST        :  Char;
                     VN           :  LongInt;
                     UsePF        :  Boolean)  :  Str255;


Function FullNVCode(RC,ST        :  Char;
                    VN           :  LongInt;
                    VC           :  Str50;
                    UsePF        :  Boolean)  :  Str255;

Function FullNVIdx(RC,ST        :  Char;
                   VN,VIdx      :  LongInt;
                   UsePF        :  Boolean)  :  Str255;

Function PostNVIdx(VN,VIdx      :  LongInt)  :  Str255;

Function FullNVCatIdx(RC,ST        :  Char;
                      VN,VIdx,VCat :  LongInt;
                      UsePF        :  Boolean)  :  Str255;




{$IFDEF STK}

  Function FullStkAnal(LTyp   :  Char;
                       PDate  :  LongDate;
                       RefNo  :  Str20)  :  Str30;

  Function FullStockTree(CCode,SCCode  :  Str20) :  AnyStr;

  Function SOP_RunNo(SOPRunNo  :  LongInt;
                     DocHed    :  DocTypes)  :  Str10;

  Function FullIdType(LTyp  :  Char;
                      SCode :  Str20)  :  Str30;

  Function QUO_DelDate(DocHed :  DocTypes;
                       DDate  :  LongDate)  :  Str15;

  {$IFDEF PF_On}

    Function MakeFIKey (SFOL         :  LongInt;
                        SDate        :  LongDate)  :  Str30;

    Function MakeFIDocKey (DNo          :  Str10;
                           SFOL,
                           DLNo         :  LongInt)  :  Str30;

    Function MakeSNKey (SFOL         :  LongInt;
                        Sold         :  Boolean;
                        SNo          :  Str20)  :  Str30;

    Function FullBinCode(BC  :  Str10)  :  Str10;


    Function FullBinCode2(SFOL  :  LongInt;
                          Sold  :  Boolean;
                          Loc   :  Str10;
                          Prity :  Str10;
                          IDate :  LongDate;
                          BC    :  Str10)  :  Str50;

    Function FullBinCode3(SFOL  :  LongInt;
                          Loc   :  Str10;
                          BC    :  Str10)  :  Str50;

    Function MakeQDKey (DiscCode     :  Str20;
                        QCurr        :  Byte;
                        QQty         :  Real)  :  Str20;

    Function MakeCDKey (CCode        :  Str10;
                        SCode        :  Str20;
                        QCurr        :  Byte)  :  Str30;

    Function FullCDKey (CCode        :  Str10;
                        SFol         :  LongInt)  :  Str30;

    Function Full_StkBOMKey(SFol,
                            SLNo  :  LongInt)  :  Str20;

    {$IFDEF SOP}

      Function Full_SupStkKey(SFol  :  LongInt;
                              SCode :  Str20 )  :  Str30;
    {$ENDIF}


  {$ENDIF}

  Function CalcKeyHist(StockFolio  :  LongInt;
                       lc          :  Str10)  :  Str255;

  {$IFNDEF EXDLL}
  Function CalcKeyHistPOn(StockFolio  :  LongInt;
                          lc          :  Str10)  :  Str255;

  Function CalcKeyHistMve(StockFolio  :  LongInt;
                          lc          :  Str10)  :  Str255;
  {$ENDIF}

{$ENDIF}

Function FullCompoKey(CCode  :  Str80;
                      UCode  :  Str10) :  AnyStr;


Function FullCustType(CCode  :  Str10;
                      CSup   :  Char) :  AnyStr;


Function FullJACode(JA  :  Str10)  :  Str10;

Function FullAnalDesc (AD : Str20) : Str20;

{$IFDEF PF_On}

Function FullJAKey (RC,ST        :  Char;
                    Login        :  Str20)  :  Str20;

{$ENDIF}

Function FullJobCode(JCode  :  Str20)  :  Str20;

Function FullJobDesc(JCode  :  Str30)  :  Str30;

Function FullJBCode(JC    :  Str10;
                    Curr  :  Byte;
                    SCode :  Str20)  :  Str30;

Function FullJDLedgerKey(JC   :   Str10;
                         P,I  :   Boolean;
                         Cu   :   Byte;
                         JD   :   LongDate)  :  Str30;

Function FullJDRunKey(JC      :   Str10;
                      RN      :   Longint;
                      JD      :   LongDate)  :  Str30;

Function FullJDLookKey(RN,FN   :   Longint)  :  Str20;

Function FullJDHistKey(JC   :   Str10;
                       JSC  :   Longint)  :  Str20;


Function FullIdKey(Ino,Lno  :  Longint)  :  Str20;

Function FullMatchKey (RC,ST        :  Char;
                       Login        :  Str20)  :  Str20;

Function FullJDEmplKey(JC,EC   :   Str10;
                       Matched :   Boolean)  :  Str30;

Function FullEmpCode(JA  :  Str10)  :  Str20;

Function FullJAPEmplKey(OS  :   Boolean;
                        EC  :   Str10;
                        JCTMode
                            :   Boolean)  :  Str30;

Function FullJAPJobKey(OS        :   Boolean;
                       JC        :   Str10;
                       JCTMode,
                       SalMode   :   Boolean)  :  Str30;

Function IS_PayInLine(PayRef  :  Str20)  :  Boolean;

Function FullPayInKey(RefNo  :  Str20)  :  Str20;


Function Pre_PostPayInKey(SepCh  :  Char;
                          RefNo  :  Str80)  :  Str30;

Function Part_PostPayInKey(SepCh    :  Char;
                           NomCode  :  LongInt)  :  Str10;

Function Full_PostPayInKey(SepCh    :  Char;
                           NomCode  :  LongInt;
                           Currency :  Byte;
                           PayRef   :  Str80)  :  Str30;

Function Extract_PayRef2(PayRef  :  Str20)  :  Str10;

Function Extract_PayRef1(PayRef  :  Str20)  :  Str10;


Function CalcCCKeyHistOn(NomFolio  :  LongInt;
                           lc        :  Str10)  :  Str255;

Function CalcCCKeyHist(NomFolio  :  LongInt;
                       lc        :  Str10)  :  Str255;

Function PostCCKey(CCOn  :  Boolean;
                   CCode :  Str10)  :  Str20;

Function CalcCCKeyHistP(NomFolio  :  LongInt;
                        lm        :  Boolean;
                        lc        :  Str10)  :  Str255;

Function CalcCCKeyHistPOn(NomFolio  :  LongInt;
                              lm        :  Boolean;
                              lc        :  Str10)  :  Str255;


Function CalcCCDepKey(IsCC   :  Boolean;
                      CCDep  :  CCDepType)  :  Str10;

{$IFDEF Pf_On}

    Function FullQDKey (RC,ST        :  Char;
                        Login        :  Str50)  :  Str50;


{$ENDIF}


{$IFDEF STK}
   Function Full_MLocKey(lc  :  Str10)  :  Str10;

  {$IFDEF SOP}

      Function Full_MLocSKey(lc  :  Str10;
                             sc  :  Str20)  :  Str30;

      Function Full_MLoclKey(lc  :  Str10;
                             sc  :  Str20)  :  Str30;

      Function Full_MLocPostKey(nc  :  Longint;
                                lc  :  Str10)  :  Str10;

      Function Quick_MLKey(lc  :  Str10)  :  Str20;

      Function CommitKey  :  Str255;

      Function CommitGLKey(NomFolio  :  LongInt)  :  Str255;

      Function CommitGLCCKey(NomFolio  :  LongInt;
                             Lc        :  Str10)  :  Str255;


      Function CommitGLCCKeyOn(NomFolio  :  LongInt;
                               Lc        :  Str10)  :  Str255;


    {$ENDIF}



{$ENDIF}

Function IsACust(CChar  :  Char)  :  Boolean;

 Function FullBACSKey (CCode        :  Str10;
                       SFol         :  LongInt)  :  Str30;

Function dbFormatName(Code,
                      Desc  :  Str255)  :  Str255;

Function dbFormatSlash(Code,
                      Desc  :  Str255)  :  Str255;


{$IFDEF COMP}
  {$DEFINE ICMP}
{$ENDIF}
{$IFDEF OLE}
  {$DEFINE ICMP}
{$ENDIF}

{$IFDEF ICMP}
  Function FullCompCode(CCode : Str10) : Str10;
  Function FullCompCodeKey(PFix, CCode : Str10) : Str10;
  Function FullCompPath(CPath : ShortString) : ShortString;
  Function FullCompPathKey(PFix, CPath : ShortString) : ShortString;
{$ENDIF}

//PR: 21/08/2013 MRD1.1.01 Build methods for new custsupp indexes
function FullSubTypeAcCodeKey(SubType : Char; const Code : ShortString) : ShortString;
function FullSubTypeLongAcCodeKey(SubType : Char; const Code : ShortString) : ShortString;
function FullSubTypeNameKey(SubType : Char; const Code : ShortString) : ShortString;
function FullSubTypeAltCodeKey(SubType : Char; const Code : ShortString) : ShortString;
function FullLongAcCodeKey(const Code : ShortString) : ShortString;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETMiscU,
  ETDateU;





{ ========= Function to return full customer code ======== }

Function FullCustCode(CCode  :  Str10) :  AnyStr;

Begin
  FullCustCode:=UpcaseStr(LJVar(Ccode,CustKeyLen));
end;


{ ========= Function to return full customer code2 ======== }

Function FullCustCode2(CCode  :  Str20) :  AnyStr;

Begin
  FullCustCode2:=UpcaseStr(LJVar(Ccode,CustKey2Len));
end;

{ ========= Function to return full customer code ======== }

Function FullCompKey(CCode  :  Str50) :  AnyStr;

Begin
  FullCompKey:=LJVar(Ccode,CustCompLen);
end;


{ ========= Function to return full customer code ======== }

Function FullCVATKey(CCode  :  Str30) :  AnyStr;

Begin
  FullCVATKey:=LJVar(Ccode,CustVATLen);
end;


Function FullPostCode(CCode  :  Str20) :  AnyStr;
Begin // FullPostCode
  Result := UpcaseStr(LJVar(Ccode, PostCodeLen));
End; // FullPostCode

Function FullEmailAddr(CCode  :  Str100) :  AnyStr;
Begin // FullEmailAddr
  Result := LJVar(Ccode, EmailAddrLen);
End; // FullEmailAddr

Function FullRefNo(CCode : Str10) : AnyStr;
Begin // FullRefNo
  Result := LJVar(Ccode, CustRefNoLen);
End; // FullRefNo

Function FullCustPhone(CCode : Str30) : AnyStr;
Begin // FullCustPhone
  Result := LJVar(Ccode, CustPhoneLen);
End; // FullCustPhone


Function FullNomKey(ncode  :  Longint)  :  Str20;


Var
  TmpStr  :  Str20;

Begin
  FillChar(TmpStr,Sizeof(TmpStr),0);

  Move(ncode,TmpStr[1],Sizeof(ncode));

  TmpStr[0]:=Chr(Sizeof(ncode));

  FullNomKey:=TmpStr;
end;


Function UnFullNomKey(sString : string) : LongInt;
Begin
  Result := 0;
  Move(sString[1],Result,Sizeof(result));
end;

{ ========= Function to Return Detail Key Link ========== }

Function FullDayBkKey(Rno,Fno  :  Longint;
                      DPrefix  :  Str5)  :  Str20;


Begin
  FullDayBkKey:=FullNomKey(Rno)+LJVar(DPrefix,1)+FullNomKey(Fno);
end;


{ ========= Function to Return Detail Key/Run No. Link ========== }

Function FullRunNoKey(Rno,Fno  :  Longint)  :  Str20;


Begin
  FullRunNoKey:=FullNomKey(Rno)+FullNomKey(Fno);
end;


{ ======== Function to Return Full OurRef Key =========== }

Function FullOurRefKey(DCode  :  Str10)  :  Str10;

Begin

  FullOurRefKey:=LJVar(DCode,DocKeyLen);

end; {Func..}

                          

{ ================ Return Full Ledger Key ================ }

Function FullLedgerKey(CCode  :  Str20;
                       CSup   :  Char;
                       NCode  :  Boolean)  :  Str20;

Var
  TmpStr  :  Str5;

Begin
  Blank(TmpStr,Sizeof(TmpStr));

  Move(NCode,TmpStr[1],Sizeof(NCode));

  TmpStr[0]:=Char(Sizeof(Ncode));

  FullLedgerKey:=FullCustType(CCode,CSup)+TmpStr;
end;


{ ========= Function to return full uncapitalised STR Longint Equivalent code ======== }

Function FullNCode(CCode  :  Str10) :  AnyStr;

Begin
  FullNCode:=LJVar(Ccode,CustKeyLen);
end;



{ ========= Function to return full uncapitalised STR Longint Equivalent code ======== }

Function FullNHCode(CCode  :  Str20) :  AnyStr;

Begin
  FullNHCode:=LJVar(Ccode,NHCodeLen);
end;



{ ========= Function to Return Control Code Posting ========== }


Function FullIDPostKey(Cno,Rno      :  Longint;
                       PNm,PCr,
                       PYr,PPr      :  Byte)  :  Str20;




Begin
  FullIdPostKey:=FullNomKey(Cno)+Chr(PNm)+Chr(PCr)+Chr(PYr)+Chr(PPr)+FullNomKey(Rno);
end;


{ ========= Function to Return Password Code ========== }


Function FullPWordKey (RC,ST        :  Char;
                       Login        :  Str20)  :  Str20;




Begin
  FullPWordKey:=Rc+St+LJVar(Login,LoginKeyLen);
end;


{ ========= Function to Return Posting Lock Code ========== }


Function PartPLockKey (Mode         :  Byte)  :  Str20;




Begin
  PartPLockKey:='POST'+Chr(Mode)+HelpKStop;
end;



{ ========= Function to Return Posting Lock Code ========== }


Function FullPLockKey (RC,ST        :  Char;
                       Mode         :  Byte)  :  Str20;




Begin
  FullPLockKey:=Rc+St+PartPLockKey(Mode);
end;

{ ========= Function to Return Part Help Code ========== }


Function  PartHelpKey (RC,ST        :  Char;
                       HelpNo       :  Longint)  :  Str20;




Begin
  PartHelpKey:=Rc+St+FullNomKey(HelpNo);
end;


{ ========= Function to Return Help Code ========== }


Function  FullHelpKey (RC,ST        :  Char;
                       HelpNo,
                       HelpOrd      :  LongInt)  :  Str20;




Begin
  FullHelpKey:=PartHelpKey(Rc,St,HelpNo)+FullNomKey(HelpOrd)+HelpKStop;
end;







{ ========= Function to Return Part Cost Code ========== }


Function  PartCCKey (RC,ST        :  Char)  :  Str20;

Begin
  PartCCKey:=Rc+St;
end;



{ ========= Function to Return CostCenter Code ========== }


Function FullCCKey (RC,ST        :  Char;
                    Login        :  Str20)  :  Str20;




Begin
  FullCCKey:=PartCCKey(Rc,St)+LJVar(Login,CCKeyLen);
end;

{ ========= Function to Return CostCenter Code ========== }


Function FullCCDepKey (Login        :  Str5)  :  Str5;




Begin
  Result:=LJVar(Login,CCKeyLen);
end;


{ ========= Function to return full uncapitalised STR Longint Equivalent code ======== }

Function FullCompoKey(CCode  :  Str80;
                      UCode  :  Str10) :  AnyStr;

Begin
  FullCompoKey:=LJVar(Ccode,10)+LJVar(UCode,10); {***** needs updating ***}
end;


{ ========= Function to return heading title depending on mode ======== }
{$IFNDEF BTRVSQL_DLL}
Function Show_CCFilt(lc      :  Str10;
                     ccMode  :  Boolean)  :  Str80;
Const
  CCTit  :  Array[BOff..BOn] of Str5 = ('Dep','CC');

Begin

  Result:='';

  If (Syss.PostCCNom) and (Syss.UseCCDep) then
  Begin

    If (Length(lc)<=ccKeyLen) then
    Begin
      If (Not EmptyKeyS(lc,ccKeyLen,BOff)) then
      Begin

        Result:=' - '+CCTit[CCMode]+' : '+lc+'. ';
      end
    end
    else
    Begin
      Result:=' - '+CCTit[CCMode]+' : '+Copy(lc,1,ccKeyLen)+'. '+CCTit[Not CCMode]+' : '+Copy(lc,5,ccKeyLen)+'. ';
    end;
  end;

end; {Proc..}
{$ENDIF}

{ ========= Function to return heading title depending on mode ======== }

Function Show_CommitMode(ccMode  :  Byte)  :  Str80;
Const
  CCTit  :  Array[1..2] of Str50 = ('Act+Commit','Commit Only');

Begin

  Result:='';

  If (CCmode In [1,2]) then
  Begin

    Result:=' - '+CCTit[CCMode]+'. ';
  end;

end; {Proc..}



{ ========= Function to Return Part Nominal History Key ========== }

Function PartNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr   :  Byte)  :  Str30;


Begin
  PartNHistKey:=Typ+FullNHCode(Code)+Chr(Cr);
end;



{ ========= Function to Return Full Nominal History Key ========== }

Function FullNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr,Yr,
                      Pr   :  Byte)  :  Str30;


Begin
  FullNHistKey:=PartNHistKey(Typ,Code,Cr)+Chr(Yr)+Chr(Pr);
end;


{ ========= Proc to Return Nhist Key from Full Key ========= }

Procedure Extract_NHistfromNKey(NKey  :  Str255;
                            Var NHR   :  HistoryRec);

Var
  Point  :  Byte;

Begin
  With NHR do
  Begin
    Point:=1;

    ExClass:=NKey[Point];

    Point:=Point+{Fpos[Ntyp2No].Len}1;

    Code:=Copy(NKey,Point,NHCodeLen);

    Point:=Point+NHCodeLen;

    Cr:=Ord(NKey[Point]);

    Inc(Point);

    Yr:=Ord(NKey[Point]);

    Inc(Point);

    Pr:=Ord(NKey[Point]);

    Inc(Point);
  end; {With..}
end; {Proc..}


  { == Functions to control storing of Nom View records == }

  Function PrimeNVCode(RC,ST        :  Char;
                       VN           :  LongInt;
                       UsePF        :  Boolean)  :  Str255;

  Begin

    Result:=FullNomKey(VN);

    If (UsePF) then
      Result:=PartCCKey(RC,ST)+Result;

  end;

  Function FullNVCode(RC,ST        :  Char;
                      VN           :  LongInt;
                      VC           :  Str50;
                      UsePF        :  Boolean)  :  Str255;

  Begin
    Result:=PrimeNVCode(RC,ST,VN,UsePF)+LJVar(VC,VNomKeyLen);

  end;


  Function FullNVIdx(RC,ST        :  Char;
                     VN,VIdx      :  LongInt;
                     UsePF        :  Boolean)  :  Str255;

  Begin
    Result:=PrimeNVCode(RC,ST,VN,UsePF)+Dec2Hex(VIdx);

  end;


  Function PostNVIdx(VN,VIdx      :  LongInt)  :  Str255;

  Begin
    Result:=#1+#1+FullNomKey(VN)+Dec2Hex(VIdx);

  end;

  Function FullNVCatIdx(RC,ST        :  Char;
                        VN,VIdx,VCat :  LongInt;
                        UsePF        :  Boolean)  :  Str255;

  Begin
    Result:=PrimeNVCode(RC,ST,VN,UsePF)+Dec2Hex(VCat)+Dec2Hex(VIdx);

  end;


{ ========= Function to return full customer type code ======== }

Function FullCustType(CCode  :  Str10;
                      CSup   :  Char) :  AnyStr;

Begin
  FullCustType:=FullCustCode(CCode)+CSup;
end;


{$IFDEF PF_On}

// CJS - 02/02/2010 - There are copies of MakeFIKey and MakeFIDocKey in the
// SQLRedirectorU.pas file in BtrvSQL.DLL.

  { ========= Function to MAke FIFI Code ========== }


  Function MakeFIKey (SFOL         :  LongInt;
                      SDate        :  LongDate)  :  Str30;




  Begin

    MakeFIKey:=FullNomKey(SFOL)+SDate;

  end;


  { ========= Function to MAke FIFI Doc Code ========== }


  Function MakeFIDocKey (DNo          :  Str10;
                         SFOL,
                         DLNo         :  LongInt)  :  Str30;




  Begin

    MakeFIDocKey:=FullOurRefKey(DNo)+FullNomKey(SFOL)+FullNomKey(DLNo)+HelpKStop;

  end;


    { ========= Function to MAke SERN Code ========== }


  Function MakeSNKey (SFOL         :  LongInt;
                      Sold         :  Boolean;
                      SNo          :  Str20)  :  Str30;




  Begin

    MakeSNKey:=FullNomKey(SFOL)+Chr(Ord(Sold))+SNo;

  end;



{$ENDIF}





{ ==============  Function to Return an intelligent guess on finding a document =========== }

Function AutoSetInvKey(InpKey   :  Str255;
                       IKNo     :  Integer)  :  Str255;


Var
  TmpK,TmpNo  :  Str255;
  TmpPrefix   :  Str5;
  LenPrefix   :  Byte;


Begin
  TmpPrefix:='';
  TmpNo:='';

  TmpK:=UpcaseStr(Strip('B',[#32],InpKey));

  LenPrefix:=Length(DocCodes[SIN]);

  If (TmpK[Succ(LenPrefix)] In ['A'..'Z']) then
    LenPrefix:=Succ(LenPrefix);

  TmpPrefix:=Copy(TmpK,1,LenPreFix);

  TmpNo:=Strip('L',['0'],Copy(TmpK,Succ(LenPrefix),(Length(TmpK)-LenPrefix)));

  TmpK:=TmpPrefix+SetPadNo(TmpNo,(DocKeyLen-LenPreFix));

  AutoSetInvKey:=LJVar(TmpK,DocKeyLen);

end; {Function..}


{ ======= Function to Return Psuedo Delivery Date on Orders ====== }

Function Pay_RunNo(DocHed :  DocTypes;
                   PayRun :  LongInt)  :  Str10;


Begin

  Pay_RunNo:=DocCodes[DocHed]+FullNomKey(PayRun)+HelpKStop;

end; {Func..}


{ ========= Function to return full Stock code ======== }

Function FullStockCode(CCode  :  Str20) :  AnyStr;

Begin
  FullStockCode:=UpcaseStr(LJVar(Ccode,StkKeyLen));
end;

Function FullBarCode(CCode  :  Str20) :  AnyStr;
Begin // FullBarCode
  Result := UpcaseStr(LJVar(Ccode,BarCodeLen));
End; // FullBarCode


{$IFDEF STK}

  { =========== Full StkAnal =========== }


  Function FullStkAnal(LTyp   :  Char;
                       PDate  :  LongDate;
                       RefNo  :  Str20)  :  Str30;

  Begin

    FullStkAnal:=LTyp+FullStockCode(RefNo)+ConstStr(#0,4)+PDate;

  end; {Func..}





  { ========= Function to return full Stock Tree code ======== }

  Function FullStockTree(CCode,SCCode  :  Str20) :  AnyStr;

  Begin                                 {* Adjust this depending on length of Stock code -20 *}
    FullStockTree:=FullStockCode(CCode)+ConstStr(#0,4)+FullStockCode(SCCode)+ConstStr(#0,4);
  end;


  { ======= Function to Return Psuedo Delivery Date on Orders ====== }

  Function QUO_DelDate(DocHed :  DocTypes;
                       DDate  :  LongDate)  :  Str15;


  Begin

    QUO_DelDate:=DocCodes[DocHed]+DDate;

  end; {Func..}


  { ======= Function to Return Psuedo Delivery Date on Orders ====== }

  Function SOP_RunNo(SOPRunNo  :  LongInt;
                     DocHed    :  DocTypes)  :  Str10;


  Begin

    SOP_RunNo:=FullNomKey(SOPRunNo)+DocCodes[DocHed];

  end; {Func..}


  

  { ====== Function to Return Full Id Type ====== }

  Function FullIdType(LTyp  :  Char;
                      SCode :  Str20)  :  Str30;


  Begin

    FullIdType:=LTyp+FullStockCode(Scode);

  end;




  {$IFDEF PF_On}

    { ========= Function to MAke Qty Disc Code ========== }


    Function MakeQDKey (DiscCode     :  Str20;
                        QCurr        :  Byte;
                        QQty         :  Real)  :  Str20;




    Begin
      MakeQDKey:=DiscCode+Chr(QCurr)+Form_Real(QQty,QtyDiscKeyLen,Syss.NoQtyDec);

    end;


    { ========= Function to MAke Customer Disc Code ========== }


    Function MakeCDKey (CCode        :  Str10;
                        SCode        :  Str20;
                        QCurr        :  Byte)  :  Str30;




    Begin

      MakeCDKey:=FullCustCode(CCode)+FullStockCode(SCode)+Chr(QCurr);

    end;

      { ========= Function to MAke Customer Disc Code ========== }


    Function FullCDKey (CCode        :  Str10;
                        SFol         :  LongInt)  :  Str30;




    Begin

      FullCDKey:=FullCustCode(CCode)+FullNomKey(SFol);

    end;





    { ======= Return Full BOM Ndx ======== }


    Function Full_StkBOMKey(SFol,
                            SLNo  :  LongInt)  :  Str20;


    Begin

      Full_StkBOMKey:=FullNomKey(SFOL)+Dec2Hex(SLNo);

    end;

  {$ENDIF}

  {$IFDEF SOP}

    { ======= Return Full SupStk  ======== }


    Function Full_SupStkKey(SFol  :  LongInt;
                            SCode :  Str20 )  :  Str30;


    Begin

      Full_SupStkKey:=FullNomKey(SFOL)+FullStockCode(SCode);

    end;

  {$ENDIF}




{$ENDIF}



{ ========= Function to Manage Job Anal Code ========== }

  Function FullJACode(JA  :  Str10)  :  Str10;

  Begin

    FullJACode:=LJVar(JA,JobKeyLen);

  end;


  Function FullAnalDesc (AD : Str20) : Str20;
  Begin // FullAnalDesc
    Result := UpCaseStr(LJVar(AD,AnalDescLen));
  End; // FullAnalDesc



{$IFDEF PF_On}

  Function FullJAKey (RC,ST        :  Char;
                      Login        :  Str20)  :  Str20;




  Begin
    FullJAKey:=PartCCKey(Rc,St)+FullJACode(Login);
  end;


{$ENDIF}
  { ====== Function to Return Full JobCode ====== }

  Function FullJobCode(JCode  :  Str20)  :  Str20;

  Begin

    FullJobCode:=LJVar(JCode,JobKeyLen);

  end;

  Function FullJobDesc(JCode  :  Str30)  :  Str30;
  Begin // FullJobDesc
    Result := LJVar(JCode, JobDescLen);
  End; // FullJobDesc



  { ========= Function to Manage Job Budg Code ========== }

  Function FullJBCode(JC    :  Str10;
                      Curr  :  Byte;
                      SCode :  Str20)  :  Str30;

    { Use local FullStockCode as JobCosting doesn't convert to uppercase }
    { If standard FullStockCode is loaded Prifit Totals (99) cannot be   }
    { loaded.                                                            }
    Function FullStkCode(CCode  :  Str20) :  AnyStr;
    Begin
      Result:=LJVar(Ccode,StkKeyLen);
    end;

  Begin

    FullJBCode:=FullJACode(JC)+FullStkCode(SCode)+Chr(Curr);

  end;



  { ======= Job Actual Functions ======== }

  Function FullJDLedgerKey(JC   :   Str10;
                           P,I  :   Boolean;
                           Cu   :   Byte;
                           JD   :   LongDate)  :  Str30;


  Begin

    FullJDLedgerKey:=FullJobCode(JC)+Chr(Ord(P))+Chr(Cu)+Chr(Ord(I))+JD;

  end;


Function FullJDRunKey(JC      :   Str10;
                      RN      :   Longint;
                      JD      :   LongDate)  :  Str30;


Begin

  FullJDRunKey:=FullNomKey(RN)+FullJobCode(JC)+JD;

end;



Function FullJDLookKey(RN,FN   :   Longint)  :  Str20;


Begin

  FullJDLookKey:=FullNomKey(RN)+FullNomKey(FN)+HelpKStop;

end;


Function FullJDHistKey(JC   :   Str10;
                       JSC  :   Longint)  :  Str20;


Begin

  FullJDHistKey:=FullJobCode(JC)+FullNomKey(JSC);

end;



  { ========= Function to Manage Job Anal Code ========== }

  Function FullEmpCode(JA  :  Str10)  :  Str20;

  Begin

    FullEmpCode:=JA+#0#0#0#0;

  end;


Function FullJDEmplKey(JC,EC   :   Str10;
                       Matched :   Boolean)  :  Str30;


Begin
  FullJDEmplKey:=FullJobCode(EC)+Chr(Ord(Matched))+FullJobCode(JC);
end;


Function FullJAPEmplKey(OS  :   Boolean;
                        EC  :   Str10;
                        JCTMode
                            :   Boolean)  :  Str30;


Begin
  Result:=Chr(6-Ord(JCTMode))+FullEmpCode(EC)+Chr(Ord(OS));
end;

Function FullJAPJobKey(OS        :   Boolean;
                       JC        :   Str10;
                       JCTMode,
                       SalMode   :   Boolean)  :  Str30;


Begin
  Result:=Chr(8-Ord(JCTMode)-(2*Ord(SalMode)))+FullJobCode(JC)+Chr(Ord(OS));
end;




{ ========= Function to Return Detail Key Link ========== }

Function FullIdKey(Ino,Lno  :  Longint)  :  Str20;

Begin
  FullIdKey:=Strip('R',[#0],FullNomKey(Ino)+FullNomKey(Lno));
end;


{ ========= Function to Return Match Doc Code ========== }


Function FullMatchKey (RC,ST        :  Char;
                       Login        :  Str20)  :  Str20;




Begin
  FullMatchKey:=Rc+St+LJVar(Login,DocKeyLen);
end;


{$IFDEF PF_On}

   { ========= Function to Return Qty Disc Code ========== }


    Function FullQDKey (RC,ST        :  Char;
                        Login        :  Str50)  :  Str50;




    Begin
      FullQDKey:=PartCCKey(Rc,St)+Login;
    end;



{$ENDIF}



{ ============= Paying in Control Strings ============= }


{ =========== Padded PayInKey =========== }


Function FullPayInKey(RefNo  :  Str20)  :  Str20;

Begin

  FullPayInKey:=LJVar(RefNo,PIKeyLen);

end; {Func..}




{ ============ Function to determine if line is a paymode line ========== }

Function IS_PayInLine(PayRef  :  Str20)  :  Boolean;

Begin

  IS_PayInLine:=((Length(PayRef)>0) and (PayRef[1] In [PayInCode,PayOutCode]));

end; {Func..}




Function Pre_PostPayInKey(SepCh  :  Char;
                          RefNo  :  Str80)  :  Str30;

Begin

  Pre_PostPayInKey:=SepCh+FullPayInKey(RefNo);

end; {Func..}


Function Part_PostPayInKey(SepCh    :  Char;
                           NomCode  :  LongInt)  :  Str10;


Begin

  Part_PostPayInKey:=SepCh+FullNomKey(NomCode);

end;



Function Full_PostPayInKey(SepCh    :  Char;
                           NomCode  :  LongInt;
                           Currency :  Byte;
                           PayRef   :  Str80)  :  Str30;



Begin

  Full_PostPayInKey:=Part_PostPayInKey(SepCh,ABS(NomCode))+Pre_PostPayInKey(Chr(Currency),PayRef);

end; {Func..}



{ ============== Function to Extract the PayRef from a completed Key ============== }

Function Extract_PayRef2(PayRef  :  Str20)  :  Str10;

Var
  SepCh     :  Char;
  NomCode   :  LongInt;
  Currency  :  Byte;
  RefNo     :  Str10;


  Count     :  Byte;



  Begin

    Count:=1;

    If (Length(PayRef)=Length(Full_PostPayInKey(#0,0,0,''))) then
    Begin

      SepCh:=PayRef[Count];

      Count:=Count+Sizeof(SepCh);

      Move(PayRef[Count],NomCode,Sizeof(NomCode));

      Count:=Count+Sizeof(NomCode);

      Currency:=Ord(Payref[Count]);

      Count:=Count+Sizeof(Currency);

      RefNo:=Copy(PayRef,Count,Pred(Sizeof(RefNo)));

    end
    else
      RefNo:='';

    Extract_PayRef2:=RefNo;

  end; {Func..}


{ ============== Function to Extract the PayRef from a completed Key ============== }

Function Extract_PayRef1(PayRef  :  Str20)  :  Str10;

Var
  SepCh     :  Char;
  RefNo     :  Str10;


  Count     :  Byte;



  Begin

    Count:=1;

    If (Length(PayRef)=Length(Pre_PostPayInKey(#0,''))) then
    Begin

      SepCh:=PayRef[Count];

      Count:=Count+Sizeof(SepCh);

      RefNo:=Copy(PayRef,Count,Pred(Sizeof(RefNo)));

    end
    else
      RefNo:='';

    Extract_PayRef1:=RefNo;

  end; {Func..}


  Function CalcCCKeyHistOn(NomFolio  :  LongInt;
                           lc        :  Str10)  :  Str255;

  Begin

    CalcCCKeyHistOn:=Copy(lc,1,1)+FullNomKey(NomFolio)+Copy(lc,2,Pred(Length(lc)))
  end;

Function CalcCCKeyHist(NomFolio  :  LongInt;
                       lc        :  Str10)  :  Str255;

Begin

  If (Not EmptyKeyS(lc,ccKeyLen,BOff)) and (Syss.PostCCNom) then
    CalcCCKeyHist:=CalcCCKeyHistOn(NomFolio,Lc)
  else
    CalcCCKeyHist:=FullNomKey(NomFolio);
end;


Function CalcCCKeyHistPOn(NomFolio  :  LongInt;
                              lm        :  Boolean;
                              lc        :  Str10)  :  Str255;

Begin

  CalcCCKeyHistpOn:=CalcCCKeyHistOn(NomFolio,PostCCKey(lm,lc));
end;

Function PostCCKey(CCOn  :  Boolean;
                   CCode :  Str10)  :  Str20;

Var
  UseLen  :  Byte;

Begin
  If (Length(CCode)>ccKeyLen) then
    UseLen:=ccdpKeyLen
  else
    UseLen:=ccKeyLen;

  If (Not EmptyKeyS(CCode,UseLen,BOff)) then
    PostCCKey:=CSubCode[CCOn]+LJVar(CCode,UseLen)
  else
    PostCCKey:='';
end;


Function CalcCCKeyHistP(NomFolio  :  LongInt;
                        lm        :  Boolean;
                        lc        :  Str10)  :  Str255;

Begin

  CalcCCKeyHistp:=CalcCCKeyHist(NomFolio,PostCCKey(lm,lc));
end;


Function CalcCCDepKey(IsCC   :  Boolean;
                      CCDep  :  CCDepType)  :  Str10;
Begin
  If (Not EmptyKeyS(CCDep[BOff],ccKeyLen,BOff)) and (Not EmptyKeyS(CCDep[BOn],ccKeyLen,BOff)) and (Syss.PostCCDCombo) then
  Begin
    Result:=LJVar(CCDep[IsCC],ccKeyLen)+Chr(1+Ord(IsCC))+LJVar(CCDep[Not IsCC],ccKeyLen);
  end
  else
    Result:=CCDep[IsCC];
end;


{$IFDEF STK}

// CJS: Full_MLocKey, Full_MLocLKey and Full_MLocSKey are duplicated in
//      ExchSQL\BtrvSQL\SQLRedirector.pas

    { ======= Return Full MLoc Key ======== }


    Function Full_MLocKey(lc  :  Str10)  :  Str10;


    Begin

      Full_MLocKey:=LJVar(LC,MLocKeyLen);

    end;


  {$IFDEF SOP}


    { ======= Return Full Stk MLoc Key ======== }


    Function Full_MLocLKey(lc  :  Str10;
                           sc  :  Str20)  :  Str30;


    Begin

      Full_MLocLKey:=Full_MLocKey(lc)+FullStockCode(sc);

    end;

    
    { ======= Return Full Loc MLoc Key ======== }


    Function Full_MLocSKey(lc  :  Str10;
                           sc  :  Str20)  :  Str30;


    Begin

      Full_MLocSKey:=FullStockCode(sc)+Full_MLocKey(lc);

    end;


    Function Full_MLocPostKey(nc  :  Longint;
                              lc  :  Str10)  :  Str10;


    Begin
          {* 'L'oc used so this history is not picked up by normal history *}
      Full_MLocPostKey:='L'+FullNomKey(nc)+Full_MLocKey(lc);

    end;


    Function Quick_MLKey(lc  :  Str10)  :  Str20;

    Begin

      Result:=CostCCode+CSubCode[BOn]+Full_MlocKey(lc);

    end;

    { == Commitment History Keys == }

    Function CommitKey  :  Str255;

    Begin
      Result := 'CMT'+ConstStr(#2,2)+'!';
    end;

    { == Commited G/L Key == }

    Function CommitGLKey(NomFolio  :  LongInt)  :  Str255;

    Begin
      Result:=CommitKey+FullNomKey(NomFolio);

    end;

    { == Commited Cc/Dep Key == }

    Function CommitGLCCKey(NomFolio  :  LongInt;
                           Lc        :  Str10)  :  Str255;

    Begin
      Result:=CommitKey+CalcCCKeyHist(NomFolio,Lc);

    end;

    { == Commited Cc/Dep Key == }

    Function CommitGLCCKeyOn(NomFolio  :  LongInt;
                             Lc        :  Str10)  :  Str255;

    Begin
      Result:=CommitKey+CalcCCKeyHistOn(NomFolio,Lc);

    end;


  {$ENDIF}

  Function CalcKeyHist(StockFolio  :  LongInt;
                       lc          :  Str10)  :  Str255;

  Begin

    {$IFDEF SOP}
      If (Not EmptyKey(lc,MLocKeyLen)) and (Syss.UseMLoc) then
        CalcKeyHist:=Full_MLocPostKey(StockFolio,lc)
      else
        CalcKeyHist:=FullNomKey(StockFolio);
    {$ELSE}
      CalcKeyHist:=FullNomKey(StockFolio);

    {$ENDIF}
  end;

  {$IFNDEF EXDLL}
    Function CalcKeyHistPOn(StockFolio  :  LongInt;
                            lc          :  Str10)  :  Str255;
    Begin
      {$IFDEF SOP}
        CalcKeyHistPOn:=Full_MLocPostKey(StockFolio,lc)
      {$ELSE}
        CalcKeyHistPOn:=FullNomKey(StockFolio);
      {$ENDIF}
    end;


    Function CalcKeyHistMve(StockFolio  :  LongInt;
                            lc          :  Str10)  :  Str255;

    Begin

      {$IFDEF SOP}
        If (Not EmptyKey(lc,MLocKeyLen)) then
          CalcKeyHistMve:=Full_MLocPostKey(StockFolio,lc)
        else
          CalcKeyHistMve:=FullNomKey(StockFolio);
      {$ELSE}
        CalcKeyHistMve:=FullNomKey(StockFolio);

      {$ENDIF}
    end;
  {$ENDIF}

  { == Functions to make Bin Codes == }

  Function FullBinCode(BC  :  Str10)  :  Str10;

  Begin
    Result:=LJVar(UpCaseStr(BC),BinKeyLen);

  end;


  Function FullBinCode2(SFOL  :  LongInt;
                        Sold  :  Boolean;
                        Loc   :  Str10;
                        Prity :  Str10;
                        IDate :  LongDate;
                        BC    :  Str10)  :  Str50;

  Begin
    Result:=FullNomKey(SFOL)+Full_MLocKey(Loc)+Chr(Ord(Sold))+FullBinCode(Prity)+IDate+FullBinCode(BC);

  end;


  Function FullBinCode3(SFOL  :  LongInt;
                        Loc   :  Str10;
                        BC    :  Str10)  :  Str50;

  Begin
    Result:=Full_MLocKey(Loc)+FullNomKey(SFOL)+FullBinCode(BC);

  end;


{$ENDIF}


{ ========= Function returns True if char is custcode ========= }

Function IsACust(CChar  :  Char)  :  Boolean;

Begin
  IsACust:=((CChar=TradeCode[BOn]) or (CChar=Succ(TradeCode[BOn])));
end;


  { ========= Function to Make Full BacsKey ======== }


 Function FullBACSKey (CCode        :  Str10;
                       SFol         :  LongInt)  :  Str30;
 Begin

   FullBACSKey:=FullNomKey(SFol)+FullCustCode(CCode);

 end;

{ ======== Function to take a code & desc, strip spaces, and show with , ====== }

Function dbFormatName(Code,
                      Desc  :  Str255)  :  Str255;

Begin

  Result:=Strip('B',[#32],Code);

  If (Result<>'') and (Strip('B',[#32],Desc)<>'') then
    Result:=Result+', '; {'•,';}

  Result:=Result+Strip('B',[#32],Desc);
end; {Func..}

{ ======== Function to take a code & desc, strip spaces, and show with , ====== }

Function dbFormatSlash(Code,
                      Desc  :  Str255)  :  Str255;

Begin

  Result:=Strip('B',[#32],Code);

  If (Result<>'') and (Strip('B',[#32],Desc)<>'') then
    Result:=Result+' / '; {'•,';}

  Result:=Result+Strip('B',[#32],Desc);
end; {Func..}



{$IFDEF ICMP}
  Function FullCompCode(CCode : Str10) : Str10;
  Begin
    Result := UpcaseStr(LJVar(Ccode, CompCodeLen));
  End;

  Function FullCompCodeKey(PFix, CCode : Str10) : Str10;
  Begin
    Result := PFix + FullCompCode(CCode);
  End;

  Function FullCompPath(CPath : ShortString) : ShortString;
  Begin
    Result := UpcaseStr(LJVar(CPath, CompPathLen));
  End;

  Function FullCompPathKey(PFix, CPath : ShortString) : ShortString;
  Begin
    Result := PFix + FullCompPath(CPath);
  End;
{$ENDIF}

//PR: 21/08/2013 MRD1.1.01 Build methods for new custsupp indexes
function FullSubTypeAcCodeKey(SubType : Char; const Code : ShortString) : ShortString;
begin
  Result := SubType + FullCustCode(Code);
end;

function FullSubTypeLongAcCodeKey(SubType : Char; const Code : ShortString) : ShortString;
begin
  Result := SubType + LJVar(Code, LongCustCodeLen);
end;

function FullSubTypeNameKey(SubType : Char; const Code : ShortString) : ShortString;
begin
  Result := SubType + FullCompKey(Code);
end;

function FullSubTypeAltCodeKey(SubType : Char; const Code : ShortString) : ShortString;
begin
  Result := SubType + FullCustCode2(Code);
end;

function FullLongAcCodeKey(const Code : ShortString) : ShortString;
begin
  Result := LJVar(Code, LongCustCodeLen);
end;



end.
