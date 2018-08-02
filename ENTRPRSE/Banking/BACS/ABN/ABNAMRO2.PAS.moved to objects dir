unit ABNAMRO2;

{ prutherford440 15:08 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }



interface

Uses Controls, Forms, StdCtrls, {TEditVal,} CustWinU, IniFiles, CustAbsU;

Type
  TBankDetails =  Record
                    EntGLCode  :  LongInt;
                    SWIFTCode  :  ANSIString;
                    BANKName   :  ANSIString;
                    BANKTOWN   :  ANSIString;
                    ISOCountry :  ANSIString;
                    BANKCountry:  ANSIString;
                    BANKACNo   :  ANSIString;
                    BankXChange:  ANSIString;
                    ISOCurrency:  ANSIString;
                  end;

  TABNControl  =  Record
                    DomesticCGL  :  Array[FALSE..TRUE] of LongInt;
                    TestMode     :  Boolean;
                    DomesticDir  :  Array[FALSE..TRUE] of ANSIString;
                    ForeignMode  :  Boolean;
                    CtrlGL       :  LongInt;
                    BankGL       :  LongInt;
                    SalesPurch   :  Boolean;
                    Amount       :  Double;
                    PayCurr      :  String[3];
                    TMode        :  Byte;
                    PayRun       :  LongInt;
                    PDate        :  String[8];
                    FileCounter  :  LongInt;
                    PayFileName  :  ANSIString;
                    PayDesc      :  ShortString;
                    BankMatch    :  SmallInt;
                    Banks        :  Array[1..100] of TBankDetails;
                    
                  end; {Record..}


  TClieOp     =  Record
                    InfoCode      :  Array[1..4] of Char;
                    VariantCode   :  Char;

                    Case Smallint of
                            {Header Info}
                      1  :  (CreationDate  :  Array[1..6] of Char;
                             FileName      :  Array[1..8] of Char;
                             SenderID      :  Array[1..5] of Char;
                             FileID        :  Array[1..4] of Char;
                             DupCode       :  Char;
                             Filler1       :  Array[1..21] of Char;
                             CRLF          :  Array[1..2] of Char;);

                             {File Close Info}

                      2  :  (Filler2       :  Array[1..45] of Char;
                             CRLF2         :  Array[1..2] of Char;);


                            {Batch Header Info}
                      3  :  (TransGroup    :  Array[1..2] of Char;
                             IPACNo        :  Array[1..10] of Char;
                             SerialNo      :  Array[1..4] of Char;
                             DelCurr       :  Array[1..3] of Char;
                             Filler3       :  Array[1..26] of Char;
                             CRLF3         :  Array[1..2] of Char;);


                             {Fixed Description Info}
                      4  :  (FixedDesc     :  Array[1..32] of Char;
                             Filler4       :  Array[1..13] of Char;
                             CRLF4         :  Array[1..2] of Char;);


                             {Instructing party info}
                      5  :  (NAW           :  Char;
                             ReqDate       :  Array[1..6] of Char;
                             IPN           :  Array[1..35] of Char;
                             TestCode      :  Char;
                             Filler5       :  Array[1..2] of Char;
                             CRLF5         :  Array[1..2] of Char;);


                             {Batch close info}
                      6  :  (TotalAmount   :  Array[1..18] of Char;
                             TotalACNos    :  Array[1..10] of Char;
                             NoTrans       :  Array[1..7] of Char;
                             Filler6       :  Array[1..10] of Char;
                             CRLF6         :  Array[1..2] of Char;);


                              {Transaction info}
                      7  :  (TransType     :  Array[1..4] of Char;
                             Amount        :  Array[1..12] of Char;
                             PayerACNo     :  Array[1..10] of Char;
                             PayeeACNo     :  Array[1..10] of Char;
                             Filler7       :  Array[1..9] of Char;
                             CRLF7         :  Array[1..2] of Char;);


                             {Name of Payer info}
                      8  :  (PayerName     :  Array[1..35] of Char;
                             Filler8       :  Array[1..10] of Char;
                             CRLF8         :  Array[1..2] of Char;);


                             {Address of Payer info}
                      9  :  (PayerAddr     :  Array[1..35] of Char;
                             Filler9       :  Array[1..10] of Char;
                             CRLF9         :  Array[1..2] of Char;);

                             {Payment ID info}
                     10  :  (PayerID       :  Array[1..16] of Char;
                             Filler10      :  Array[1..29] of Char;
                             CRLF10        :  Array[1..2] of Char;);



                             {Description info}
                     11  :  (Description   :  Array[1..32] of Char;
                             Filler11      :  Array[1..13] of Char;
                             CRLF11        :  Array[1..2] of Char;);


                            {Name of Payee info}
                     12  :  (BenefitName    :  Array[1..35] of Char;
                             Filler12       :  Array[1..10] of Char;
                             CRLF12        :  Array[1..2] of Char;);


                             {Address of Payee info}
                     13  :  (PayeeAddr      :  Array[1..35] of Char;
                             Filler13       :  Array[1..10] of Char;
                             CRLF13        :  Array[1..2] of Char;);



                  end;

  TCliopRecs   =  Record
                     Header,
                     FileClose,
                     BatchHed,
                     FixedDesc,
                     InstParty,
                     BatchClose,
                     TransInfo,
                     PayerName,
                     PayerAddr,
                     PayId,
                     DescInfo,
                     PayeeName,
                     PayeeAddr

                               :  TCLieop;
                  end;

  TEntClieOp   =  Record
                    EInfoCode      :  SmallInt;
                    EVariantCode   :  Char;

                    Case SmallInt of

                            {Header Info}
                      1  :  (ECreationDate  :  String[6];
                             EFileName      :  String[8];
                             ESenderID      :  String[5];
                             EFileID        :  String[4];
                             EDupCode       :  Byte;);


                            {File Close Info}

                      2  :  ();

                            {Batch Header Info}
                      3  :  (ETransGroup    :  Byte;
                             EIPACNo        :  String[10];
                             ESerialNo      :  LongInt;
                             EDelCurr       :  String[3]);

                             {Fixed Description Info}
                      4  :  (EFixedDesc     :  String[32];);

                             {Instructing party info}
                      5  :  (ENAW           :  Char;
                             EReqDate       :  String[6];
                             EIPN           :  String[35];
                             ETestCode      :  Char;);


                             {Batch close info}
                      6  :  (ETotalAmount   :  Double;
                             ETotalACNos    :  Double;
                             ENoTrans       :  LongInt;);


                             {Transaction info}
                      7  :  (ETransType     :  String[4];
                             EAmount        :  Double;
                             EPayerACNo     :  String[10];
                             EPayeeACNo     :  String[10];);

                             {Name of Payer info}
                      8  :  (EPayerName     :  String[35];);

                             {Address of Payer info}
                      9  :  (EPayerAddr     :  String[35];);

                             {Payment Ud info}
                     10  :  (EPayerID       :  String[16];);

                             {Description info}
                     11  :  (EDescription   :  String[32];);

                            {Name of Payee info}
                     12  :  (EBenefitName    :  String[35];);

                             {Address of Payee info}
                     13  :  (EPayeeAddr      :  String[35];);


                  end;

  TEntCliopRecs   =  Record
                       EHeader,
                       EFileClose,
                       EBatchHed,
                       EFixedDesc,
                       EInstParty,
                       EBatchClose,
                       ETransInfo,
                       EPayerName,
                       EPayerAddr,
                       EPayId,
                       EDescInfo,
                       EPayeeName,
                       EPayeeAddr

                                 :  TEntCLieop;
                    end;


  TBTL91    =  Record
                 Code  :  Array[1..2] of Char;

                 Case SmallInt of

                            {Leading Record}

                      1  :  (ExBank    :  Array[1..4] of Char;
                             MedCode   :  Char;
                             VerNo     :  Array[1..2] of Char;
                             FCDate    :  Array[1..8] of Char;
                             BatchNo   :  Array[1..3] of Char;
                             PrinName  :  Array[1..35] of Char;
                             PrinAddr  :  Array[1..35] of Char;
                             PrinTown  :  Array[1..35] of Char;
                             PrinCountry
                                       :  Array[1..35] of Char;
                             BusSect   :  Array[1..4] of Char;
                             ProcDate  :  Array[1..8] of Char;
                             Spare1    :  Array[1..20] of Char;
                             CRLF1     :  Array[1..2] of Char;);



                            {Payments Record}

                      2  :  (OrderNo  :  Array[1..4] of Char;
                             ISOPCurr :  Array[1..3] of Char;
                             ACNo     :  Array[1..10] of Char;
                             ISOOCurr :  Array[1..3] of Char;
                             Amount   :  Array[1..15] of Char;
                             ProcDate2:  Array[1..8] of Char;
                             DOMCCode :  Char;
                             CORCCode :  Char;
                             PayMethod:  Char;
                             ProcCode :  Char;
                             CQCCode  :  Char;
                             CQFCode  :  Char;
                             PayInsC1 :  Array[1..2] of Char;
                             PayInsC2 :  Array[1..2] of Char;
                             PayInsC3 :  Array[1..2] of Char;
                             PayInsC4 :  Array[1..2] of Char;
                             PayCatC1 :  Char;
                             NatP1C   :  Array[1..40] of Char;
                             NatP2C   :  Array[1..40] of Char;
                             DNBRegNo :  Array[1..8] of Char;
                             Spare2   :  Array[1..2] of Char;
                             ArtNo    :  Array[1..2] of Char;
                             TradNo   :  Array[1..4] of Char;
                             Spare3   :  Array[1..36] of Char;
                             CRLF2    :  Array[1..2] of Char;);



                             {Sub Record 2}

                      3  :  (OrderNo2 :  Array[1..4] of Char;
                             BenAcNo  :  Array[1..34] of Char;
                             BenName  :  Array[1..35] of Char;
                             BenAddr  :  Array[1..35] of Char;
                             BenTown  :  Array[1..35] of Char;
                             BenISOCountry
                                      :  Array[1..2] of Char;
                             BenCountry
                                      :  Array[1..35] of Char;
                             Spare4   :  Array[1..10] of Char;
                             CRLF3    :  Array[1..2] of Char;);



                             {Sub Record 3}

                      4  :  (OrderNo3 :  Array[1..4] of Char;
                             BenSWIFT :  Array[1..11] of Char;
                             BenBank  :  Array[1..35] of Char;
                             BenBAddr :  Array[1..35] of Char;
                             BenBTown :  Array[1..35] of Char;
                             BenBISOCountry
                                      :  Array[1..2] of Char;
                             BenBCountry
                                      :  Array[1..35] of Char;
                             Spare5   :  Array[1..33] of Char;
                             CRLF4    :  Array[1..2] of Char;);


                             {Sub Record 4}

                      5  :  (OrderNo4 :  Array[1..4] of Char;
                             PayRef1  :  Array[1..35] of Char;
                             PayRef2  :  Array[1..35] of Char;
                             PayRef3  :  Array[1..35] of Char;
                             PayRef4  :  Array[1..35] of Char;
                             Spare6   :  Array[1..46] of Char;
                             CRLF5    :  Array[1..2] of Char;);


                             {Totals Record }

                      6  :  (TotCurr  :  Array[1..3] of Char;
                             TotAmount:  Array[1..15] of Char;
                             TotCount :  Array[1..4] of Char;
                             Spare7   :  Array[1..168] of Char;
                             CRLF6    :  Array[1..2] of Char;);


                             {Terminal Totals Record }

                      7  :  (TotRecs  :  Array[1..6] of Char;
                             TotOrders:  Array[1..4] of Char;
                             DESHash  :  Array[1..24] of Char;
                             Spare8   :  Array[1..156] of Char;
                             CRLF7    :  Array[1..2] of Char;);



               end;


  TBTL91Recs   =  Record
                     LeadRec,
                     Payments,
                     SubRec1,
                     SubRec2,
                     SubRec3,
                     SubRec4,
                     TotalsRec,
                     TerminalRec

                               :  TBTL91;
                  end;


  TEntBTL91    =  Record
                     ECode  :  SmallInt;

                     Case SmallInt of

                            {Leading Record}

                      1  :  (EExBank    :  String[4];
                             EMedCode   :  Char;
                             EVerNo     :  SmallInt;
                             EFCDate    :  String[8];
                             EBatchNo   :  SmallInt;
                             EPrinName  :  String[35];
                             EPrinAddr  :  String[35];
                             EPrinTown  :  String[35];
                             EPrinCountry
                                       :  String[35];
                             EBusSect   :  LongInt;
                             EProcDate  :  String[8];);

                            {Payments Record}

                      2  :  (EOrderNo  :  LongInt;
                             EISOPCurr :  String[3];
                             EACNo     :  String[10];
                             EISOOCurr :  String[3];
                             EAmount   :  Double;
                             EProcDate2:  String[8];
                             EDOMCCode :  Byte;
                             ECORCCode :  Byte;
                             EPayMethod:  Byte;
                             EProcCode :  Byte;
                             ECQCCode  :  Char;
                             ECQFCode  :  Char;
                             EPayInsC1 :  String[2];
                             EPayInsC2 :  String[2];
                             EPayInsC3 :  String[2];
                             EPayInsC4 :  String[2];
                             EPayCatC1 :  Char;
                             ENatP1C   :  String[40];
                             ENatP2C   :  String[40];
                             EDNBRegNo :  String[8];
                             EArtNo    :  String[2];
                             ETradNo   :  String[4];);

                             {Sub Record 2}

                      3  :  (EOrderNo2 :  LongInt;
                             EBenAcNo  :  String[34];
                             EBenName  :  String[35];
                             EBenAddr  :  String[35];
                             EBenTown  :  String[35];
                             EBenISOCountry
                                      :  String[2];
                             EBenCountry
                                      :  String[35];);

                             {Sub Record 3}

                      4  :  (EOrderNo3 :  LongInt;
                             EBenSWIFT :  String[11];
                             EBenBank  :  String[35];
                             EBenBAddr :  String[35];
                             EBenBTown :  String[35];
                             EBenBISOCountry
                                      :  String[2];
                             EBenBCountry
                                      :  String[35];);

                             {Sub Record 4}

                      5  :  (EOrderNo4 :  LongInt;
                             EPayRef1  :  String[35];
                             EPayRef2  :  String[35];
                             EPayRef3  :  String[35];
                             EPayRef4  :  String[35];);

                             {Totals Record }

                      6  :  (ETotCurr  :  String[3];
                             ETotAmount:  Double;
                             ETotCount :  LongInt;);

                              {Terminal Totals Record }

                      7  :  (ETotRecs  :  LongInt;
                             ETotOrders:  LongInt;);



                  end;


  TEntBTL91Recs   =  Record
                       ELeadRec,
                       EPayments,
                       ESubRec1,
                       ESubRec2,
                       ESubRec3,
                       ESubRec4,
                       ETotalsRec,
                       ETerminalRec

                                 :  TEntBTL91;
                    end;

  TCLieOpFile  =  File of TClieOP;
  TBTL91File   =  File of TBTL91;

  CharSet      =  Set of Char;


  Function  ProperPath(PPath  :  String)  :  String;

  Procedure Report_IOError(IOErr  :  Integer;
                           Dir    :  ANSIString);

  Procedure Str2_Char(    LStr   :  ShortString;
                      Var CharAry;
                          SO     :  Integer);

  Function Form_ZInt (Inum    :  LongInt;
                      Dig     :  Integer)  :  ShortString;

  Function Form_ZFloat(Inum    :  Double;
                       Dig     :  Integer)  :  ShortString;

  Function Form_ZFloat2(Inum    :  Double;
                        Dig     :  Integer)  :  ShortString;

  Function Form_ZPad(TmpStr  :  ShortString;
                     Dig     :  Integer)  :  ShortString;

  Function Pennies(Inum  :  Real) : LongInt;

  Function BACS_Safe(TStr  :  ShortString)  :  ShortString;

  Procedure SetCRLF(Var ECRLF);


  Function Today(Mode  :  Byte)  :  ShortString;

  Function Date2CLieOp(NDate  :  ShortString)  :  ShortString;

  Function Strip(L  :  char;
                 C  :  CharSet;
                 Str:  String):String;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses SysUtils, Dialogs;



  { == format path with '\' ==}

  Function  ProperPath(PPath  :  String)  :  String;

  Begin
    If (PPath<>'') and (PPath[Length(PPath)]<>'\') then
      Result:=PPath+'\'
    else
      Result:=PPath;

  end;


  Procedure Report_IOError(IOErr  :  Integer;
                           Dir    :  ANSIString);


  Begin
    If (IOErr<>0) then
      ShowMessage('An input/output error has been detected.'+#13+
                  'Report error '+IntToStr(IOErr)+#13+
                  'in '+Dir);


  end;

(*  ConstStr returns a Str255 with N characters of value C *)

function ConstStr(C :  Char; N : Integer) : ShortString;
var
  S : ShortString;
begin
  if N < 0 then
    N := 0;
  S[0] := Chr(N);
  FillChar(S[1],N,C);
  ConstStr := S;
end;

{ Pad Text Prompt Str to Given No. of Places }

Function LJVar(Str2Pad  :  ShortString;
               PadLen   :  Integer) :  ShortString;


Begin
  If (Length(Str2Pad)<PadLen) then
    LJVar:=Str2Pad+ConstStr(' ',(PadLen-Length(Str2Pad)))
  else
    LJVar:=Copy(Str2Pad,1,PadLen);
end;

    { =========== Function to Convert Char Array to String ========= }

  Procedure Str2_Char(    LStr   :  ShortString;
                      Var CharAry;
                          SO     :  Integer);

  Var
    TmpStr    :  ShortString;
    n         :  Byte;

  Begin
    TmpStr:=BACS_Safe(LJVar(LStr,SO));

    Move(TmpStr[1],CharAry,SO);

  end;{Func..}



  { =========== Function to Convert Char Array to String ========= }

  Procedure Str2_ZChar(    LStr   :  ShortString;
                       Var CharAry;
                           SO     :  Integer);

  Var
    TmpStr    :  ShortString;
    n         :  Byte;

  Begin
    n:=Length(LStr);

    TmpStr:=ConstStr('0',SO-n)+BACS_Safe(LStr);

    Move(TmpStr[1],CharAry,SO);

  end;{Func..}



  { ====== Function to Format an Integer No. & return in Str Format ===== }

  Function Form_ZInt (Inum    :  LongInt;
                      Dig     :  Integer)  :  ShortString;


  Var
    TmpStr  :  ShortString;


  Begin

    TmpStr:='';


    Str(Inum:0,TmpStr);

    TmpStr:=ConstStr('0',Dig-Length(TmpStr))+TmpStr;

    Form_ZInt:=TmpStr;
  end;


    { ====== Function to Format an Integer No. & return in Str Format ===== }

  Function Form_ZFloat(Inum    :  Double;
                       Dig     :  Integer)  :  ShortString;


  Var
    TmpStr  :  ShortString;


  Begin

    TmpStr:='';


    TmpStr:=Formatfloat(ConstStr('0',Dig),Inum);

    TmpStr:=ConstStr('0',Dig-Length(TmpStr))+TmpStr;

    Form_ZFloat:=TmpStr;
  end;

  Function Form_ZFloat2(Inum    :  Double;
                        Dig     :  Integer)  :  ShortString;


  Var
    TmpStr  :  ShortString;


  Begin

    TmpStr:='';


    TmpStr:=Formatfloat(ConstStr('0',Dig),Inum);

    TmpStr:=ConstStr('0',Dig-Length(TmpStr))+TmpStr;

    While Length(TmpStr) > Dig do Delete(TmpStr, 1, 1);

    Form_ZFloat2:=TmpStr;
  end;

      { ====== Function to Format an Integer No. & return in Str Format ===== }

  Function Form_ZPad(TmpStr  :  ShortString;
                     Dig     :  Integer)  :  ShortString;




  Begin


    Result:=ConstStr('0',Dig-Length(TmpStr))+TmpStr;

  end;

  { ==== Function to convert Real No into Pennies Equivalent ==== }


  Function Pennies(Inum  :  Real) : LongInt;

  Begin
    Pennies:=Round(Inum * 100);
  end;


  { ===== Function to Filter an NON BACS legal Chars ====== }


  Function BACS_Safe(TStr  :  ShortString)  :  ShortString;

  Const
    BACSAll :  Set of Char = [#32,'&','-','.','/','0'..'9','A'..'Z'];


  Var
    L,n  :  Byte;



  Begin

    L:=Length(TStr);

    For n:=1 to L do
    Begin

      TStr[n]:=Upcase(Tstr[n]);

      If (Not (TStr[n] In BACSAll)) then
        TStr[n]:=#32;

    end;

    BACS_Safe:=TStr;

  end;

  Procedure SetCRLF(Var ECRLF);

  Const
    CRLF  :  Array[1..2] of Char = (#13,#10);

  Begin
    Move(CRLF,ECRLF,Sizeof(ECRLF));

  end;


  { == Function to return today in long and short year format == }

  Function Today(Mode  :  Byte)  :  ShortString;

  Var
    Month,Year,Day  :  Word;
    MStr,DStr       :  String[2];

  Begin
    DecodeDate(Now,Year,Month,Day);


    MStr:=IntTostr(Month);

    If (Month<10) then
      MStr:='0'+MStr;

    DStr:=IntToStr(Day);

    If (Day<10) then
      DStr:='0'+DStr;

    If (Mode=1) then
      Result:=IntToStr(Year)+MStr+DStr
    else
      Result:=DStr+MStr+Copy(IntToStr(Year),3,2);


  end;

  Function Date2CLieOp(NDate  :  ShortString)  :  ShortString;
  Begin
    Result:=Copy(NDate,7,2)+Copy(NDate,5,2)+Copy(NDate,3,2);
  end;


    { Function to Remove all occurrences of 'C' char in Str Str255....


  Legal Values for L are...:-


  L    =   Left of Str Only
  R    =   Right of "   "
  B    =   Beginning & End of Str, ie L & R
  A    =   Remove all Occurrences of Char C

}

Function Strip(L  :  char;
               C  :  CharSet;
               Str:  String):String;

var I :  byte;
begin
    Case Upcase(L) of
    'L' : begin       {Left}
              While (Str[1] In C) and (Length(Str)<>0) do
                    Delete(Str,1,1);
          end;
    'R' : begin       {Right}
              While  (Str[length(Str)] In C) and (Length(Str)<>0)  do
                    Delete(Str,length(Str),1);
          end;
    'B' : begin       {Both left and right}
              While (Str[1] In C) and (Str<>'')  do
                    Delete(Str,1,1);
              While (Str[length(Str)] In C) and (Length(Str)<>0) do
                    Delete(Str,length(Str),1);
          end;
    'A' : begin       {All}
              I := 1;
              Repeat
                   If Str[I] In C then
                      Delete(Str,I,1)
                   else
                      I := succ(I);
              Until (I > length(Str)) or (Length(Str)=0);
          end;
    end;
    Strip := Str;
end;  {Func Strip}


Initialization


Finalization


end.
