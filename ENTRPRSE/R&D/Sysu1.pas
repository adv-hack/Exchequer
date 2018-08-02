Unit SysU1;

{$I DEFOVR.Inc}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 03/08/90                      }
{                                                              }
{                    System Controller Unit                    }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,VarConst ;


Function GetNextCount(DocHed     :  DocTypes;
                      Increment,
                      UpLast     :  Boolean;
                      NewValue   :  Real)  :  LongInt;

Function FullDocNum(DocHed    :  DocTypes;
                    Increment :  Boolean)  :  Str20;

Procedure SetNextDocNos(Var  InvR  :  InvRec;
                             SetOn :  Boolean);

Function FullAutoDocNum(DocHed    :  DocTypes;
                        Increment :  Boolean)  :  Str20;


Procedure SetNextAutoDocNos(Var  InvR  :  InvRec;
                                 SetOn :  Boolean);

Function SetNextSFolio(DocHed     :  DocTypes;
                       SetOn      :  Boolean;
                       SMode      :  Byte)  :  LongInt;

Function SetNextJFolio(DocHed     :  DocTypes;
                       SetOn      :  Boolean;
                       SMode      :  Byte)  :  LongInt;


{$IFDEF STK}

  Function SetNextSOPRunNo(DocHed     :  DocTypes;
                           SetOn      :  Boolean;
                           SMode      :  Byte)  :  LongInt;

{$ENDIF}

{$IF Defined(WOP) or Defined(RET)}

  Function SetNextWOPRunNo(DocHed     :  DocTypes;
                           SetOn      :  Boolean;
                           SMode      :  Byte)  :  LongInt;
{$IFEND}

Function SuspendDoc(HoldStatus  :  Byte)  :  Boolean;


Function DocNotes(HoldStatus  :  Byte)  :  Boolean;


Function GetHoldType(HoldStatus  :  Byte)  :  Byte;

Function DisplayHold(HoldFlg  :  Byte)  :  Str10;

Function Disp_HoldPStat(HoldFlg,
                        Tag      :  Byte;
                        PrintS,
                        Cert,
                        Picked   :  Boolean)  :  Str20;

//GS 06/10/2011 ABSEXCH-11367: added a default param to the method declairation
//allowing bypassing the updating of the batch records
Procedure SetHold(Var  Mode     :  Byte;
                       Fnum,
		       Keypath  :  Integer;
		       Update   :  Boolean;
                  Var  InvR     :  InvRec;
                       UpdateBatchRecords: Boolean = True);


{$IFDEF JC}

  Procedure SetJobHold(Var  Mode     :  Byte;
                           Fnum,
                           Keypath  :  Integer;
                           Update   :  Boolean;
                      Var  JobR     :  JobDetlRec);

{$ENDIF}

Function Get_CurCustBal(ICust  :  CustRec)  :  Double;

Function Check_MDCCC(CtrlNom  :  LongInt)  :  LongInt;

{ ======= Procedure to update the Account Balances =========== }

Procedure UpdateBal(UInv   :  InvRec;
                    BalAdj :  Real;
                    CosAdj,
                    NetAdj :  Real;
                    Deduct :  Boolean;
                    Mode   :  Byte);



Function OnHold(HoldStatus  :  Byte) :  Boolean;


Function Last_YTD(NType             :  Char;
                  NCode             :  Str20;
                  PCr,PYr,PPr       :  Byte;
                  Fnum,NPath        :  Integer;
                  Direc             :  Boolean)  :  Boolean;


Procedure Add_NHist(NType           :  Char;
                    NCode           :  Str20;
                    PCr,PYr,PPr     :  Byte;
                    Fnum,NPath      :  Integer);

Procedure Post_To_Hist(NType         :  Char;
                       NCode         :  Str20;
                       PPurch,PSales,
                       PCleared
                                     :  Real;
                       PCr,PYr,PPr   :  Byte;
                   Var PrevBal       :  Double);

Procedure Post_To_CYTDHist(NType          :  Char;
                           NCode          :  Str20;
                           PPurch,PSales,
                           PCleared       :  Real;
                           PCr,PYr,PPr    :  Byte);



Function IOVATCode(DocHed  :  DocTypes;
                   NIOCode :  Char)  :  Char;


Function DocTypeFCode(DocStr  :  Str5)  :  DocTypes;

Function Pr2Fig(FYr,FPr  :  Byte)  :  LongInt;

Function TrueChar(TF  :  Boolean)  :  Char;


Procedure AllocateAged(Var  AgedAry  :  AgedTyp;
                            AgedDate,
                            AsAtDate :  LongDate;
                            Amount   :  Real);





Function Calc_NewVATPeriod(LastVDate  :  LongDate;
                           NoMnths    :  Integer)  :  LongDate;

Function CalcVATDate(DDate  :  LongDate)  :  LongDate;


Function GetLocalPr(Mode  :  Byte)  :  tLocalPeriod;


Function Continue_ExcelName(FName  :  AnsiString;
                            FMode,
                            SeqNo  :  Byte;
                            ASuffix: String='')  :  ANSIString;


//PR: 08/02/2012 Function to find the next qty break folio from the doc nos file. Adapted from GetNextCount ABSEXCH-9795
function GetNextQtyBreakFolio : Integer;


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Forms,
   Windows,
   SysUtils,
   BtrvU2,
   ETMiscU,
   ETStrU,
   ETDateU,
   VARRec2U,
   ComnUnit,
   BTKeys1U,
   BTSupU1,
//   BPyItemU,
   CurrncyU,
   {$IFDEF EXSQL}
     SQLUtils,
   {$ENDIF}
   {$IFDEF PERIODDEBUG}
     EParentU,
   {$ENDIF}
   {$IF Defined(CU)}
     // MH 16/03/2015 v7.0.10 ABSEXCH-15482: Added hook points for change of Customer/Supplier Status
     ExWrap1U,
     Event1U,
   {$IFEND}
   BTSFrmU1,

  //PR: 06/02/2012
  QtyBreakVar;

{ === This entire suit of next nos is duplicated inside ExBTth1u for threadsafe === }

{ =============== Procedure to GetNext Available Number ============== }

Function GetNextCount(DocHed     :  DocTypes;
                      Increment,
                      UpLast     :  Boolean;
                      NewValue   :  Real)  :  LongInt;

Const
  Fnum     :  Integer  =  IncF;
  Keypath  :  Integer  =  IncK;

Var
  Key2F  :  Str255;
  TmpOk  :  Boolean;
  Lock   :  Boolean;
  TmpStatus
         :  Integer;
  LAddr,
  Cnt,NewCnt
         :  LongInt;



Begin
  Lock:=BOff;  Cnt:=0;  NewCnt:=0; TmpStatus:=0;

  Blank(Key2F,Sizeof(Key2F));

  Key2F:=DocNosXlate[DocHed];

  TmpOk:=GetMultiRecAddr(B_GetEq,B_MultLock,Key2F,Keypath,Fnum,BOn,Lock,LAddr);

  If (TmpOk) and (Lock) then
  With Count do
  Begin

    Move(NextCount[1],Cnt,Sizeof(Cnt));

    If (Increment)then
    Begin
      NewCnt:=Cnt+IncxDocHed[DocHed];
      Move(NewCnt,NextCount[1],Sizeof(NewCnt));
    end;

    If (UpLast) then
      LastValue:=NewValue;

    If (Increment) or (UpLast) then
      TmpStatus:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    Report_BError(Fnum,TmpStatus);

    TmpStatus:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
  end;

  GetNextCount:=Cnt;
end;



{ ========== Return Full DocNum ============= }
{* v5.61.002. Extended to add A-Z suffix if count >999999 and less than 2,229,977 *}

{$IFNDEF PREV561001}

  Function FullDocNum(DocHed    :  DocTypes;
                      Increment :  Boolean)  :  Str20;


  Const
    ExtendSuffix  :  Array[0..22] of Char = ('A','B','C','D','E','F','G','H','J','K','L','M','N','P','Q','R','T','U','V','W','X','Y','Z');

  Var
    SIdx
          :  Byte;

    VR    :  Integer;
    Lcnt,
    SVal  :  LongInt;

    SSufix:  Str5;
    StrLnt:  Str255;


  Begin
    LCnt:=0; StrLnt:=''; SSufix:='';

    Lcnt:=GetNextCount(DocHed,Increment,BOff,0);

    Str(Lcnt:0,StrLnt);

    If (Length(StrLnt)>6) then
    Begin
      Val(Copy(StrLnt,1,2),SVal,Vr);

      If (Vr=0) and (SVal<33) and (SVal>=10) then
      Begin
        SSufix:=ExtendSuffix[SVal-10];

        StrLnt:=Copy(StrLnt,3,5);

        Val(StrLnt,SVal,Vr);

        If (Vr=0) then
        Begin
          Str(SVal:0,StrLnt);
        end;

      end;

    end;

    FullDocNum:=DocCodes[DocHed]+SSufix+SetPadNo(StrLnt,(DocKeyLen-Length(DocCodes[DocHed])-Length(SSufix)));
  end;


{$ELSE}

  Function FullDocNum(DocHed    :  DocTypes;
                      Increment :  Boolean)  :  Str20;


  Var
    Lcnt  :  LongInt;
    StrLnt:  Str255;


  Begin
    LCnt:=0; StrLnt:='';

    Lcnt:=GetNextCount(DocHed,Increment,BOff,0);

    Str(Lcnt:0,StrLnt);

    FullDocNum:=DocCodes[DocHed]+SetPadNo(StrLnt,(DocKeyLen-Length(DocCodes[DocHed])));
  end;

{$ENDIF}


{ ======== Procedure to set next doc & Folio Nos ======= }
{ ** Duplicated in ExbTh1U *}


Procedure SetNextDocNos(Var  InvR  :  InvRec;
                             SetOn :  Boolean);

Var
  FolioTyp  :  DocTypes;

  NotDupli  :  Boolean;
  UsedInv   :  InvRec;
  NORef     :  Str20;
  NFolio    :  LongInt;


Begin
  NotDupli:=BOn;

  UsedInv:=InvR;
  NORef:='ERROR!';
  NFolio:=0;

  Begin
    Repeat
      NORef:=FullDocNum(UsedInv.InvDocHed,SetOn);

      If (SetOn) then
        NotDupli:=(Not CheckExsists(NORef,InvF,InvOurRefK));

    Until (Not SetOn) or (NotDupli);

    If (UsedInv.InvDocHed In BatchSet+QuotesSet+StkAdjSplit+PSOPSet+TSTSplit+JAPSplit+StkRetSplit) then
      FolioTyp:=AFL
    else
      FolioTyp:=FOL;

    Repeat
      NFolio:=GetNextCount(FolioTyp,SetOn,BOff,0);

      If (SetOn) then
        NotDupli:=(Not CheckExsists(Strip('R',[#0],FullNomKey(NFolio)),InvF,InvFolioK));

    Until (Not SetOn) or (NotDupli);

  end;

  With UsedInv do
  Begin
    OurRef:=NORef;
    FolioNum:=NFolio;
  end;

  InvR:=UsedInv;

end;




{ ========== Return Full Automatic Daybook DocNum ============= }


Function FullAutoDocNum(DocHed    :  DocTypes;
                        Increment :  Boolean)  :  Str20;


Var
  Lcnt  :  LongInt;
  StrLnt:  Str255;


Begin
  LCnt:=0; StrLnt:='';

  Lcnt:=GetNextCount(ADC,Increment,BOff,0);

  Str(Lcnt:0,StrLnt);

  FullAutoDocNum:=DocCodes[DocHed]+SetPadNo(StrLnt,(Pred(DocKeyLen)-Length(DocCodes[DocHed])))+AutoPrefix;
end;




{ ======== Procedure to set next auto doc & Folio Nos ======= }
{ ** Duplicated in ExbTh1U *}


Procedure SetNextAutoDocNos(Var  InvR  :  InvRec;
                                 SetOn :  Boolean);
Var
  NotDupli  :  Boolean;
  UsedInv   :  InvRec;
  NORef     :  Str20;
  NFolio    :  LongInt;


Begin
  NotDupli:=BOn;

  UsedInv:=InvR;
  NORef:='ERROR!';
  NFolio:=0;

  Begin
    Repeat
      NORef:=FullAutoDocNum(UsedInv.InvDocHed,SetOn);

      If (SetOn) then
        NotDupli:=(Not CheckExsists(NORef,InvF,InvOurRefK));

    Until (Not SetOn) or (NotDupli);

    Repeat
      NFolio:=GetNextCount(AFL,SetOn,BOff,0);

      If (SetOn) then
        NotDupli:=(Not CheckExsists(Strip('R',[#0],FullNomKey(NFolio)),InvF,InvFolioK));

    Until (Not SetOn) or (NotDupli);

  end;

  With UsedInv do
  Begin
    OurRef:=NORef;
    FolioNum:=NFolio;
  end;

  InvR:=UsedInv;
end;

Function SetNextSFolio(DocHed     :  DocTypes;
                       SetOn      :  Boolean;
                       SMode      :  Byte)  :  LongInt;


Var
  NotDupli  :  Boolean;


Begin
  NotDupli:=BOn;

  Repeat
    Result:=GetNextCount(DocHed,SetOn,BOff,0);

    If (SetOn) then
    Case SMode of
      0  :  NotDupli:=(Not CheckExsists(Strip('R',[#0],FullNomKey(Result)),StockF,StkFolioK));
      1  :  NotDupli:=(Not CheckExsists(Strip('R',[#0],PartCCKey(NoteTCode,NoteCCode)+FullNomKey(Result)),MLocF,MLSuppK));
      else  NotDupli:=BOff;
    end;

  Until (Not SetOn) or (NotDupli);

end;


Function SetNextJFolio(DocHed     :  DocTypes;
                       SetOn      :  Boolean;
                       SMode      :  Byte)  :  LongInt;


Var
  NotDupli  :  Boolean;


Begin
  NotDupli:=BOn;

  Repeat
    Result:=GetNextCount(DocHed,SetOn,BOff,0);

    If (SetOn) then
    Case SMode of
      0  :  NotDupli:=(Not CheckExsists(Strip('R',[#0],FullNomKey(Result)),JobF,JobFolioK));
      else  NotDupli:=BOff;
    end;

  Until (Not SetOn) or (NotDupli);

end;


{$IFDEF STK}

  { ======== Procedure to set next doc & Folio Nos ======= }

  Function SetNextSOPRunNo(DocHed     :  DocTypes;
                           SetOn      :  Boolean;
                           SMode      :  Byte)  :  LongInt;

  Var
    NotDupli  :  Boolean;


  Begin
    NotDupli:=BOn;

    Result:=0;

    Begin

      Repeat
        Result:=GetNextCount(SDG,SetOn,BOff,0);

        If (SetOn) then
          NotDupli:=(Not CheckExsists(SOP_RunNo(Result,DocHed),InvF,InvBatchK));

      Until (Not SetOn) or (NotDupli);

    end;

  end;
{$ENDIF}


{$IF Defined(WOP) or Defined(RET)}

  { ======== Procedure to set next doc & Folio Nos ======= }

  Function SetNextWOPRunNo(DocHed     :  DocTypes;
                           SetOn      :  Boolean;
                           SMode      :  Byte)  :  LongInt;

  Var
    NotDupli  :  Boolean;


  Begin
    NotDupli:=BOn;

    Result:=0;

    Begin

      Repeat
        Result:=GetNextCount(WIN,SetOn,BOff,0);

        If (SetOn) then
          NotDupli:=(Not CheckExsists(SOP_RunNo(Result,DocHed),InvF,InvBatchK));

      Until (Not SetOn) or (NotDupli);

    end;

  end;
{$IFEND}





{ ============== True if Doc Suspended ================ }

Function SuspendDoc(HoldStatus  :  Byte)  :  Boolean;

Begin
  SuspendDoc:=(HoldStatus and HoldSuspend =HoldSuspend);
end;


{ ============== True if Doc got notes ================ }

Function DocNotes(HoldStatus  :  Byte)  :  Boolean;

Begin
  DocNotes:=(HoldStatus and HoldNotes=HoldNotes);
end;


{ ============== Return Hold Order =============== }

Function GetHoldType(HoldStatus  :  Byte)  :  Byte;

Begin
  GetHoldType:=(HoldStatus-(HoldStatus And (HoldSuspend+HoldNotes)));
end;




{ ============== Return Hold Status as Str Message ============= }

Function DisplayHold(HoldFlg  :  Byte)  :  Str10;

Var
  HO  :  Byte;

Begin
  If (SuspendDoc(HoldFlg)) then
    DisplayHold:=SuspendStatus
  else
    If ((DocNotes(HoldFlg)) and (GetHoldType(HoldFlg)=0)) then
      DisplayHold:=NoteStatus
    else
    Begin

      HO:=GetHoldType(HoldFlg);

      If (HO In [0..HoldC]) then
        DisplayHold:=HoldStatus[HO]
      else
        DisplayHold:='';
    end;

end; {Func..}




Function Disp_HoldPStat(HoldFlg,
                        Tag      :  Byte;
                        PrintS,
                        Cert,
                        Picked   :  Boolean)  :  Str20;

Var
  TmpStr      :  Str20;
  StatCount   :  Byte;


Function AddSlash(T,S  :  Str50) :  Str20;


Begin
  Result:=T;

  If (T<>'') then
    Result:=Result+'/';


  Result:=Result+S;
end;

Begin
  StatCount:=0;

  TmpStr:='';

  StatCount:=(Ord(Tag<>0)+Ord(Picked)+Ord(PrintS)+Ord(Cert)+ 
             Ord(HoldFlg AND HOLDSUSPEND<>0)+Ord(HOLDFLG AND HOLDNOTES<>0)
             +Ord(HOLDFLG and (Not HOLDNOTES AND Not HOLDSUSPEND)<>0));

  If (StatCount<=1) then
  Begin

    If (Tag<>0) then
      TmpStr:='Tag '+SetN(Tag)
    else
      If (HoldFlg<>0) then
        TmpStr:=DisplayHold(HoldFlg)
      else
        If (Picked) then
          TmpStr:='Pick Run'
        else
          If (PrintS) then
            TmpStr:='Printed'
            else
              If (Cert) then
                TmpStr:='Certified'
  end
  else
  Begin
    If (Tag<>0) then
      TmpStr:='T'+Form_Int(Tag,0);


    If (HoldFlg<>0) then
    Begin
      StatCount:=HoldFlg AND (NOT HoldNotes) AND (Not HoldSuspend);

      If (StatCount>0) then
        TmpStr:=AddSlash(TmpStr,Copy(DisplayHold(StatCount),1,1));

      If ((HoldFlg AND HoldSUSPEND)=HoldSUSPEND) then
        TmpStr:=AddSlash(TmpStr,Copy(DisplayHold(HOLDSUSPEND),1,1));

      If ((HoldFlg AND HoldNotes)=HoldNotes) then
        TmpStr:=AddSlash(TmpStr,Copy(DisplayHold(HoldNotes),1,1));
    end;

    If (Picked) then
      TmpStr:=AddSlash(TmpStr,'Pk');

    If (PrintS) then
      TmpStr:=AddSlash(TmpStr,'Pr');

    If (Cert) then
      TmpStr:=AddSlash(TmpStr,'Crt');
  end;

  Disp_HoldPStat:=TmpStr;

end; {Func..}

function UpdateBatchPayments(Mode, OldFlag: Byte; var InvR: InvRec): Boolean;
type
  TTagStyle = (tsUnknown, tsIndividual, tsByAccount);
var
  TagStyle: TTagStyle;
  IsTagged: Boolean;
  WasTagged: Boolean;
  DocThen: Double;
  AgingDate: LongDate;
  AgingColumn: Integer;
  TaggedAmount: Double;
  Multiplier: Double;
  UsingAuthorisation: Boolean;
  PrevStatus: Byte;

  // ...........................................................................
  function Get_StaChkDate: LongDate;
  { Function to return Inv Date or Due Date depending on System Setup. Copied
    from DocSupU1.pas and amended. }
  begin
    if ((Syss.StaUIDate) and (InvR.InvDocHed In SalesSplit)) or
       ((Syss.PurchUIDate) and (InvR.InvDocHed In PurchSplit)) then
      Result := InvR.TransDate
    else
      Result := InvR.DueDate;
  end;
  // ...........................................................................
  function FullBACSCtrlKey(SPMode: Boolean): Str20;
  { Copied from BPyItemU.pas }
  begin
    Result := PartCCKey(MBACSCode, MBACSCTL) + HelpKStop +
              FullNomKey(FirstAddrD - Ord(SPMode)) + HelpKStop;
  end;
  // ...........................................................................
  function BatchPaymentControlExists: Boolean;
  var
    Key: Str255;
    FuncRes: Integer;
    SalesMode: Boolean;
  begin
    Result := False;
    SalesMode := (InvR.InvDocHed In SalesSplit);
    Key := FullBACSCtrlKey(SalesMode);
    FuncRes := Find_Rec(B_GetEq, F[PwrdF], PWrdF, RecPtr[PWrdF]^, 0, Key);
    Result := (FuncRes = 0);
  end;
  // ...........................................................................
  function BatchPaymentAccountExists: Boolean;
  var
    Key: Str255;
    FuncRes: Integer;
  begin
    Result := False;
    Key := PartCCKey(MBACSCode, MBACSSub) +
           FullNomKey(Password.BACSCRec.TagRunNo) +
           LJVar(InvR.CustCode, 6);
    FuncRes := Find_Rec(B_GetGEq, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, Key);
    Result := ((FuncRes = 0) and (MiscRecs.BACSSRec.TagCustCode = InvR.CustCode));
  end;
  // ...........................................................................
  function WriteBatchPaymentControl: Integer;
  begin
    Result := Put_Rec(F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0);
  end;
  // ...........................................................................
  function WriteBatchPaymentAccount: Integer;
  begin
    Result := Put_Rec(F[MiscF], MiscF, RecPtr[MiscF]^, MIK);
  end;
  // ...........................................................................
  function FolioInRange: Boolean;
  begin
    Result := (InvR.FolioNum <= Password.BACSCRec.LastInv);
  end;
  // ...........................................................................
  function ColumnIsTagged(Column: Integer): Boolean;
  begin
    Result := MiscRecs.BACSSRec.HasTagged[Column];
  end;
  // ...........................................................................
  function Compare_Dates(ToDate, DlDate: Str10; DrvMode: Byte; Interval: Integer): LongInt;
  begin
    Result := 0;
    case DrvMode of
      1: Result := NoDays(Todate, DlDate);
      2: Result := Round(DivwChk(NoDays(ToDate, DlDate), 7));
      else
         Result := MonthDiff(ToDate, DlDate);
    end;
    if (Result < 0) and (Result > (Interval * -1)) then  {* Force a not due as otherwise truncing will nullify it *}
      Result := Interval * -1;
  end;
  // ...........................................................................
  function AgedPos(AgedDate, AsAtDate: LongDate; DrvMode: Byte; Interval: Integer): Integer;
  begin
    Result := Trunc(DivWChk(Compare_Dates(AgedDate, AsAtDate, DrvMode, Interval), Interval));
    if (Result = 0) then {* Include all due now in Col1 *}
      Result := 1
    else
      If (Result < 0) then
        Result := 0
      else
        If (Result > Pred(NoBacsTot)) then
          Result := Pred(NoBacsTot);
  end;
  // ...........................................................................
  procedure CancelHold;
  begin
    if not UsingAuthorisation then
    begin
      // Add the value to the relevant Outstanding Amount field, and to
      // the grand total field.
      MiscRecs.BACSSRec.TotalOS[0] := MiscRecs.BACSSRec.TotalOS[0] + TaggedAmount;
      MiscRecs.BACSSRec.TotalOS[AgingColumn] := MiscRecs.BACSSRec.TotalOS[AgingColumn] + TaggedAmount;
      // Add the value to the total due for the aging period
      Password.BACSCRec.TotalTag[AgingColumn] := Password.BACSCRec.TotalTag[AgingColumn] + TaggedAmount;
      if (WasTagged) and (TagStyle <> tsByAccount) then
      begin
        // Add the value to the Total Tagged field in the Control
        // record.
        Password.BACSCRec.TotalTag[0] := Password.BACSCRec.TotalTag[0] + TaggedAmount;
        { If the system is using individual tagging }
        if (TagStyle = tsIndividual) then
        begin
          InvR.Tagged := 1;
          // Add the value to the relevant Total field, and to the grand
          // total field.
          MiscRecs.BACSSRec.TotalTagged[0] := MiscRecs.BACSSRec.TotalTagged[0] + TaggedAmount;
          MiscRecs.BACSSRec.TotalTagged[AgingColumn] := MiscRecs.BACSSRec.TotalTagged[AgingColumn] + TaggedAmount;
        end;
      end
      else if (IsTagged) and (TagStyle = tsByAccount) then
      begin
        InvR.Untagged := True;
        // Add the value to the excluded amount for the account and
        // aging period
        MiscRecs.BACSSRec.TotalEx[AgingColumn] := MiscRecs.BACSSRec.TotalEx[AgingColumn] + TaggedAmount;
      end;
    end;
  end;

begin
  Result := True;
  { Check for a Batch Payment Control record against the currency and
    transaction type (sales or purchase). }
  if BatchPaymentControlExists then
  begin
    { Check the Batch Payment Account records for a match with the account
      code. }
    if BatchPaymentAccountExists then
    begin
      { Check folio against LastInv. }
      if (FolioInRange) then
      begin
        { Determine the correct aging date }
        AgingDate := Get_StaChkDate;
        AgingColumn := AgedPos(AgingDate,
                               Password.BACSCRec.TagASDate,
                               Password.BACSCRec.AgeType,
                               Password.BACSCRec.AgeInt) + 1;

        { Is this specific transaction tagged? }
        IsTagged := False;
        WasTagged := False;
        if (InvR.Tagged = 1) then
        begin
          IsTagged := True;
          TagStyle := tsIndividual;
        end
        else if (ColumnIsTagged(AgingColumn)) then
        begin
          IsTagged := True;
          TagStyle := tsByAccount;
        end
        else if (InvR.BatchThen <> 0.0) then
        begin
          WasTagged := True;
          TagStyle := tsIndividual;
        end;

        TaggedAmount := BaseTotalOS(InvR);
        if (InvR.Currency<>Password.BACSCRec.PayCurr) then
          TaggedAmount := Currency_ConvFT(TaggedAmount, 0,
                                          Password.BACSCRec.PayCurr,
                                          UseCoDayRate);
        if (TagStyle = tsIndividual) then
        begin
          if (InvR.Currency<>Password.BACSCRec.PayCurr) then
            TaggedAmount := Currency_ConvFT(InvR.BatchThen, 0,
                                            Password.BACSCRec.PayCurr,
                                            UseCoDayRate)
          else
            TaggedAmount := InvR.BatchNow;
        end;

        UsingAuthorisation := (Syss.AuthMode In ['A','M']) and (not (InvR.InvDocHed In SalesSplit));
        PrevStatus := OldFlag AND (NOT HoldNotes) AND (NOT HoldSuspend);

        case Mode of
          201:  // HoldSQ:  // Hold for query
            if (PrevStatus <> HoldQ) then
            begin
              if (not UsingAuthorisation) or (PrevStatus = HoldP) then // Previously authorised
              begin
                // Remove from total amount due in the aging period
                Password.BACSCRec.TotalTag[AgingColumn] := Password.BACSCRec.TotalTag[AgingColumn] - TaggedAmount;
                // Remove from grand total outstanding for the account, and from
                // the aging period total outstanding for the account
                MiscRecs.BACSSRec.TotalOS[0] := MiscRecs.BACSSRec.TotalOS[0] - TaggedAmount;
                MiscRecs.BACSSRec.TotalOS[AgingColumn] := MiscRecs.BACSSRec.TotalOS[AgingColumn] - TaggedAmount;
                if (TagStyle = tsIndividual) then
                begin
                  InvR.Tagged := 0;
                  // Remove from total amount tagged
                  Password.BACSCRec.TotalTag[0] := Password.BACSCRec.TotalTag[0] - TaggedAmount;
                  // Remove from the total amount tagged for the account, and
                  // from the total amount tagged for the aging period for the
                  // account
                  MiscRecs.BACSSRec.TotalTagged[0] := MiscRecs.BACSSRec.TotalTagged[0] - TaggedAmount;
                  MiscRecs.BACSSRec.TotalTagged[AgingColumn] := MiscRecs.BACSSRec.TotalTagged[AgingColumn] - TaggedAmount;
                end
                else if (InvR.Untagged) then
                begin
                  // Remove from total amount tagged
                  Password.BACSCRec.TotalTag[0] := Password.BACSCRec.TotalTag[0] - TaggedAmount;
                  // Remove from the excluded amount for the aging period for
                  // the account (there is no grand total, even though a field
                  // exists for it)
                  MiscRecs.BACSSRec.TotalEx[AgingColumn] := MiscRecs.BACSSRec.TotalEx[AgingColumn] - TaggedAmount;
                end;
              end;
            end;
          HoldSA:  // Hold until allocated
            if (PrevStatus <> HoldSA) then
            begin
              if UsingAuthorisation and (PrevStatus = HoldP) then // Previously authorised
              begin
                Password.BACSCRec.TotalTag[AgingColumn] := Password.BACSCRec.TotalTag[AgingColumn] - TaggedAmount;
                // Subtract the value from the relevant Outstanding Amount field, and to
                // the grand total field.
                MiscRecs.BACSSRec.TotalOS[AgingColumn] := MiscRecs.BACSSRec.TotalOS[AgingColumn] - TaggedAmount;
                MiscRecs.BACSSRec.TotalOS[0] := MiscRecs.BACSSRec.TotalOS[0] - TaggedAmount;
                if (TagStyle = tsIndividual) then
                begin
                  InvR.Tagged := 0;
                  Password.BACSCRec.TotalTag[0] := Password.BACSCRec.TotalTag[0] - TaggedAmount;
                  MiscRecs.BACSSRec.TotalTagged[0] := MiscRecs.BACSSRec.TotalTagged[0] - TaggedAmount;
                  MiscRecs.BACSSRec.TotalTagged[AgingColumn] := MiscRecs.BACSSRec.TotalTagged[AgingColumn] - TaggedAmount;
                end
                else if (InvR.Untagged) then
                begin
                  Password.BACSCRec.TotalTag[0] := Password.BACSCRec.TotalTag[0] - TaggedAmount;
                  MiscRecs.BACSSRec.TotalEx[AgingColumn] := MiscRecs.BACSSRec.TotalEx[AgingColumn] - TaggedAmount;
                end;
              end
              else if (PrevStatus = HoldQ) then // Previously held for query
              begin
                CancelHold;
              end;
            end;
          HoldSP:  // Authorise
            begin
              if (UsingAuthorisation and (PrevStatus <> HoldP)) or
                 ((not UsingAuthorisation) and (PrevStatus = HoldQ)) then
              begin
                // Add the value to the relevant Outstanding Amount field, and to
                // the grand total field.
                MiscRecs.BACSSRec.TotalOS[AgingColumn] := MiscRecs.BACSSRec.TotalOS[AgingColumn] + TaggedAmount;
                MiscRecs.BACSSRec.TotalOS[0] := MiscRecs.BACSSRec.TotalOS[0] + TaggedAmount;
                // Add the value to the relevant Total Amount field in the Control
                // record.
                Password.BACSCRec.TotalTag[AgingColumn] := Password.BACSCRec.TotalTag[AgingColumn] + TaggedAmount;
                if (WasTagged or IsTagged) and (TagStyle <> tsByAccount) then
                begin
                  // Add the value to the Total Tagged field in the Control
                  // record.
                  Password.BACSCRec.TotalTag[0] := Password.BACSCRec.TotalTag[0] + TaggedAmount;
                  { If the system is using individual tagging }
                  if (TagStyle = tsIndividual) then
                  begin
                    InvR.Tagged := 1;
                    // Add the value to the relevant Total field, and to the grand
                    // total field.
                    MiscRecs.BACSSRec.TotalTagged[AgingColumn] := MiscRecs.BACSSRec.TotalTagged[AgingColumn] + TaggedAmount;
                    MiscRecs.BACSSRec.TotalTagged[0] := MiscRecs.BACSSRec.TotalTagged[0] + TaggedAmount;
                  end;
                end
                else if (IsTagged) and (TagStyle = tsByAccount) then
                begin
                  InvR.Untagged := True;
                  MiscRecs.BACSSRec.TotalEx[AgingColumn] := MiscRecs.BACSSRec.TotalEx[AgingColumn] + TaggedAmount;
                  //MiscRecs.BACSSRec.TotalEx[0] := MiscRecs.BACSSRec.TotalEx[0] + TaggedAmount;
                end;
              end;
            end;
          HoldDel:  // Remove hold status
            begin
              if (PrevStatus = HoldP) and UsingAuthorisation then // Previously authorised
              begin
                MiscRecs.BACSSRec.TotalOS[0] := MiscRecs.BACSSRec.TotalOS[0] - TaggedAmount;
                MiscRecs.BACSSRec.TotalOS[AgingColumn] := MiscRecs.BACSSRec.TotalOS[AgingColumn] - TaggedAmount;
                Password.BACSCRec.TotalTag[AgingColumn] := Password.BACSCRec.TotalTag[AgingColumn] - TaggedAmount;
                if IsTagged or WasTagged then
                begin
                  InvR.Tagged := 0;
                  Password.BACSCRec.TotalTag[0] := Password.BACSCRec.TotalTag[0] - TaggedAmount;
                  MiscRecs.BACSSRec.TotalTagged[0] := MiscRecs.BACSSRec.TotalTagged[0] - TaggedAmount;
                  MiscRecs.BACSSRec.TotalTagged[AgingColumn] := MiscRecs.BACSSRec.TotalTagged[AgingColumn] - TaggedAmount;
                end;
              end
              else if (PrevStatus = HoldQ) then // Previously held for query
              begin
                CancelHold;
              end;
            end;
        else
          // Other modes are not relevant
        end;
      end;
      Result := False;
      Status := WriteBatchPaymentAccount;
      if (Status <> 0) then
        Report_BError(MiscF, Status)
      else
      begin
        Status := WriteBatchPaymentControl;
        if (Status <> 0) then
          Report_BError(PWrdF, Status)
        else
          Result := True;
      end;
    end;
  end;
end;

{ ================== Set Hold Status on Documents ================== }
//GS 06/10/2011 ABSEXCH-11367: added a default param to the method
//allowing bypassing the updating of the batch records
Procedure SetHold(Var  Mode     :  Byte;
                       Fnum,
		       Keypath  :  Integer;
		       Update   :  Boolean;
                  Var  InvR     :  InvRec;
                       UpdateBatchRecords: Boolean = True);

  // ...........................................................................
  procedure SendUpdateMessage;
  var
    Dummy: LongInt;
    i: Integer;
    WindowCount: Integer;
    RecAddr: LongInt;
    Ndx: Integer;
  begin
    //EnumWindows(@UpdateBatchPaymentDisplay, Longint(@Dummy));
    WindowCount := Application.MainForm.MDIChildCount;
    for i := 0 to WindowCount - 1 do
    begin
      if (Application.MainForm.MDIChildren[i].ClassName = 'TBatchItems') then
      begin
        if (Password.BACSCRec.UseOSNdx) then
          Ndx := InvOSK
        else
          Ndx := InvCustK;
        // Preserve the record position
        Status := GetPos(F[InvF], InvF, RecAddr);
        Report_BError(InvF, Status);
        // Tell the Batch Payments List window to refresh
        SendMessage(Application.MainForm.MDIChildren[i].Handle, WM_CustGetRec, 71, 0);
        // Restore the record position
        SetDataRecOfs(InvF, RecAddr);
        Status := GetDirect(F[InvF], InvF, RecPtr[InvF]^, Ndx, 0);
      end
      else if (Application.MainForm.MDIChildren[i].ClassName = 'TBatchPay') then
      begin
        // Tell the Batch Payments Control window to refresh
        SendMessage(Application.MainForm.MDIChildren[i].Handle, WM_CustGetRec, 71, 0);
      end;
    end;
  end;
  // ...........................................................................
  function Authorised:  Boolean;
  begin
    with InvR do
    begin
      Result := ((InvDocHed in SalesSplit) or (not (Syss.AuthMode In ['A','M']))
                or (GetHoldType(HoldFlg)=HoldP));
    end;
  end;
  // ...........................................................................

Var
  OldFlg  :  Byte;
  OkToSave: Boolean;
  {$IF Defined(CU)}
    // MH 16/03/2015 v7.0.10 ABSEXCH-15482: Added hook points for change of Customer/Supplier Status
    ExLocal : TdExLocal;
  {$IFEND}
Begin
  OkToSave := False;
  With InvR do
  Begin
    OldFlg:=HoldFlg;

    Case Mode of
                   {* Set Normal Hold mode 1..5 *}
      201..HoldSC
                :  Begin
                     HoldFlg:=((HoldFlg And (HoldSuspend+HoldNotes))+(Mode-200));

                     if (InvDocHed In SalesSplit+PurchSplit-PSOPSet) then
                     begin
                       //GS 06/10/2011 ABSEXCH-11367: added conditional statement for
                       //allowing bypassing the updating of the batch records
                       if UpdateBatchRecords then
                       begin
                         OkToSave := UpdateBatchPayments(Mode, OldFlg, InvR);
                       end;
                     end;
                   end;

                   {* Set Suspend Hold, preserve perv setting *}
      221       :  HoldFlg:=GetHoldType(HoldFlg)+(HoldFlg And HoldNotes)+HoldSuspend;

                   {* Delete Normal hold, keep Suspend if set *}
      HoldDel   :  Begin
                     HoldFlg:=(HoldFlg And (HoldSuspend+HoldNotes));

                     If (InvDocHed In SalesSplit+PurchSplit-PSOPSet) then
                     begin
                       //GS 06/10/2011 ABSEXCH-11367: added conditional statement for
                       //allowing bypassing the updating of the batch records
                       if UpdateBatchRecords then
                       begin
                         OkToSave := UpdateBatchPayments(Mode, OldFlg, InvR);
                       end;
                     end;
                   end;


                   {* Delete Suspend hold, keep Mode if set *}
      223       :  HoldFlg:=GetHoldType(HoldFlg)+(HoldFlg And HoldNotes);

                   {* Set Hold Notes *}
      232       :  HoldFlg:=GetHoldType(HoldFlg)+(HoldFlg And HoldSuspend)+HoldNotes;

                   {* Delete Notes Hold *}
      233       :  HoldFlg:=GetHoldType(HoldFlg)+(HoldFlg And HoldSuspend);
    end; {Case..}

    If (Update) then
    Begin
      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      Report_BError(Fnum,Status);

      {$IF Defined(CU)}
        // MH 16/03/2015 v7.0.10 ABSEXCH-15482: Added hook points for change of Customer/Supplier Status
        If (Status = 0) Then
        Begin
          // 193 - Transaction Hold Flag changed by User
          ExLocal.Create;
          ExLocal.LInv := InvR;
          GenHooks(2000, 193, ExLocal);
          ExLocal.Destroy;
        End; // if (status = 0)
      {$IFEND}
    end;
    {$IFDEF ENTER1}
    //PR: 23/02/2012 This was causing a crash in the Conversion Dll - restrict it to Enter1. ABSEXCH-12579
    if OkToSave then
      SendUpdateMessage;
    {$ENDIF}
    Mode:=4;
  end; {With..}
end; {SetHold..}


{$IFDEF JC}

  { ================== Set Hold Status on Documents ================== }

  Procedure SetJobHold(Var  Mode     :  Byte;
                           Fnum,
                           Keypath  :  Integer;
                           Update   :  Boolean;
                      Var  JobR     :  JobDetlRec);

  Begin
    With JobR.JobActual do
    Begin
      Case Mode of
                     {* Set Normal Hold mode 1..5 *}
        201..HoldSC
                  :  HoldFlg:=((HoldFlg And (HoldSuspend+HoldNotes))+(Mode-200));

                     {* Set Suspend Hold, preserve perv setting *}
        221       :  HoldFlg:=GetHoldType(HoldFlg)+(HoldFlg And HoldNotes)+HoldSuspend;

                     {* Delete Normal hold, keep Suspend if set *}
        HoldDel   :  HoldFlg:=(HoldFlg And (HoldSuspend+HoldNotes));

                     {* Delete Suspend hold, keep Mode if set *}
        223       :  HoldFlg:=GetHoldType(HoldFlg)+(HoldFlg And HoldNotes);

                     {* Set Hold Notes *}
        232       :  HoldFlg:=GetHoldType(HoldFlg)+(HoldFlg And HoldSuspend)+HoldNotes;

                     {* Delete Notes Hold *}
        233       :  HoldFlg:=GetHoldType(HoldFlg)+(HoldFlg And HoldSuspend);
      end; {Case..}

      If (Update) then
      Begin
        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);
      end;

      Mode:=4;
    end; {With..}
  end; {SetHold..}


{$ENDIF}
{ ==================== Function Get Current Pr Cust Balance =================== }

Function Get_CurCustBal(ICust  :  CustRec)  :  Double;

Var
  CrDr     :  DrCrDType;
  Cleared  :  Double;

Begin
  Cleared:=0;

  With Syss do
    With ICust do
      Get_CurCustBal:=Profit_to_Date(CustHistCde,CustCode,0,GetLocalPr(0).Cyr,99,CrDr[BOff],CrDr[BOn],Cleared,BOn)+Cleared;

end; {Func..}



{ == Proc to check if MDC Ctrl code is in fact one of the nominated codes == }

Function Check_MDCCC(CtrlNom  :  LongInt)  :  LongInt;

Begin
  If (CtrlNom=Syss.NomCtrlCodes[Debtors]) or (CtrlNom=Syss.NomCtrlCodes[Creditors]) then
    Check_MDCCC:=0
  else
    Check_MDCCC:=CtrlNom;

end;


{* An exact copy of this is in ExBtTH1U for thread safe operation *}
{* Another copy is in BTS1.Pas in the Toolkit *}

{ ======= Procedure to update the Account Balances =========== }

Procedure UpdateBal(UInv   :  InvRec;
                    BalAdj :  Real;
                    CosAdj,
                    NetAdj :  Real;
                    Deduct :  Boolean;
                    Mode   :  Byte);


{*  Mode definitions  *}

{   0 - Update both U & V & W type Cust balances }
{   1 - Update Only     V   "    "      "    }
{   2 - Update Only U & W   "    "      "    }

Var
  FCust  :  Str255;
  Cnst   :  Integer;
  PBal   :  Double;
  CrDr   :  DrCrType;
  StartCode
         :  Char;

  LOk,
  Locked :  Boolean;

  LAddr  :  LongInt;
  bDeduct : Boolean;
Begin
  With UInv do
  Begin


    Blank(CrDr,Sizeof(CrDr));  PBal:=0;

    StartCode:=CustHistCde;

    FCust:=FullCustCode(CustCode);

    If (Not EmptyKey(FCust,CustKeyLen)) then
    Begin
      {$IFDEF EXSQL}
// MH 15/07/2010 v6.3.1 ABSEXCH-10035: Disabled mod as possible cause of error 78's
//      If SQLUtils.UsingSQL Then
//      Begin
//        // Account Last date used set by trigger
//        Locked:=BOff;
//        LOk:=BOff;
//
//        // Position on Customer just in case that behaviour is required from calling code
//        Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, FCust);
//      End // If SQLUtils.UsingSQLAlternateFuncs
//      Else
      {$ENDIF}
      Begin
        Locked:=BOn;

        If (Try_Lock(B_GetEq,B_SingNWLock+B_MultLock,FCust,CustCodeK,CustF,RecPtr[CustF])=0) then
          LOk:=GetMultiRecAddr(B_GetEq,B_MultLock,FCust,CustCodeK,CustF,BOff,Locked,LAddr)
        else
          LOk:=BOff;
      End;

      {If (Ok) and (Locked) then} {v5.52 Alter this to a non wait lock as we are only locking to update the last used flag.
                                         Having a lock here can cuase a deadlock if check is being run on an account by one
                                         user, whilst another has the same accounts transaction locked }
      Begin

        If (Deduct) then
        Begin
          Cnst:=-1;
          BalAdj:=BalAdj*Cnst;

          CosAdj:=CosAdj*Cnst;

          NetAdj:=NetAdj*Cnst;
        end
        else
          Cnst:=1;

        BalAdj:=(BalAdj*Cnst);

        ShowDrCr(BalAdj,CrDr);

        If (InvDocHed In DirectSet) then      {* If Direct Put Same Amount on other Side to record turnover *}
          CrDr[(Not (BalAdj<0))]:=ABS(BalAdj);

        If (Deduct) then
          For bDeduct:=BOff to BOn do
            CrDr[bDeduct]:=Round_Up((CrDr[bDeduct]*Cnst),2);



        Case Mode of
          0  :  Deduct:=BOn;

          1  :  Begin
                  StartCode:=CustHistPCde;
                  Deduct:=BOff;
                end;

          2  :  Deduct:=BOff;
        end; {Case..}


        {*EN420}

        If (AfterPurge(AcYr,0)) then {* Only update balances for live period *}
        Repeat

          Post_To_Hist(StartCode,FCust,CrDr[BOff],CrDr[BOn],0,0,AcYr,AcPr,PBal);

          Post_To_CYTDHist(StartCode,FCust,CrDr[BOff],CrDr[BOn],0,0,AcYr,YTD);

          If (Not Deduct) then {* Post Hist for MD/C and 0, as Dr/Cr Ctrl accounts *}
          Begin
            Post_To_Hist(StartCode,FCust+FullNomKey(Check_MDCCC(CtrlNom)),CrDr[BOff],CrDr[BOn],0,0,AcYr,AcPr,PBal);

            Post_To_CYTDHist(StartCode,FCust+FullNomKey(Check_MDCCC(CtrlNom)),CrDr[BOff],CrDr[BOn],0,0,AcYr,YTD);
          end;

           {v5.60. This opened up to suppliers so we can get the net t/o figures shown}
          If (StartCode=CustHistCde) and (InvDocHed In StkOutSet+StkInSet)  then  {* Post to GP Screen *}
          Begin

            Post_To_Hist(CustHistGpCde,FCust,NetAdj,CosAdj,0,0,AcYr,AcPr,PBal);

                                                                        {* Post to Non C/F YTD *}
            Post_To_Hist(CustHistGpCde,FCust,NetAdj,CosAdj,0,0,AcYr,YTDNCF,PBal);

          end;


          StartCode:=CustHistPCde;

          Deduct:=Not Deduct;

        Until (Deduct);

        { == Get Actual Customer Rec == }

        If (LOk) and (Locked) then {* Only update if customer record was not already locked, to avoid deadlocks *}
        With Cust do
        Begin

          {* Update last edited flag *}

          LastUsed:=Today;
          TimeChange:=TimeNowStr;

          Status:=Put_Rec(F[CustF],CustF,RecPtr[CustF]^,CustCodeK);

          Report_BError(CustF,Status);

          Status:=UnLockMultiSing(F[CustF],CustF,LAddr);
        end;
      end; {If Locked..}
    end; {If Blank Cust..}
  end; {With..}
end;


{ ============== Hold Management Routines ============= }

Function OnHold(HoldStatus  :  Byte) :  Boolean;

Begin
  OnHold:=((HoldStatus<>0) and (Not (HoldStatus In [HoldP,HoldNotes])) and (HoldStatus<>(HoldP+HoldNotes)));
end;



{* An exact copy of these routines is present within ExWrap1U for thread version control *}
{* Any changes to be reflected there as well
   Last_YTD,
   Add_NHist,
   Post_to_Hist,
   Post_to_CYTDHist

*}



 { =============== Function to return last valid YTD ============= }

 Function Last_YTD(NType             :  Char;
                   NCode             :  Str20;
                   PCr,PYr,PPr       :  Byte;
                   Fnum,NPath        :  Integer;
                   Direc             :  Boolean)  :  Boolean;


 Var
   KeyChk,
   KeyS    :   Str255;
   B_Func  :   Integer;

   TmpBo   :   Boolean;

   CEStatus:   Integer;

 Begin

   CEStatus:=0;

   TmpBo:=BOff;

   If (Not Direc) then
     B_Func:=B_GetLessEq
   else
     B_Func:=B_GetGEq;

   KeyChk:=PartNHistKey(NType,NCode,PCr);

   KeyS:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

   CEStatus:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,KeyS);

   TmpBo:=((CEStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and
              (((NHist.Yr<=PYr) and (Not Direc)) or ((NHist.Yr>=PYr) and (Direc))) and
              ((NHist.Pr=PPr) or (Direc)));

   If (TmpBo) and (Direc) then {* Check for the exact YTD as this returns next History which will be a period *}

     TmpBo:=CheckRecExsists(FullNHistKey(NType,NCode,PCr,NHist.Yr,PPr),NHistF,NHK);

   Last_YTD:=TmpBo;

 end; {Func..}



 { =============== Proc to Add a New History Record =============== }

 Procedure Add_NHist(NType           :  Char;
                     NCode           :  Str20;
                     PCr,PYr,PPr     :  Byte;
                     Fnum,NPath      :  Integer);

 Var
   LastPurch,
   LastSales,
   LastCleared:  Real;

   Tries,
   TryMax,
   N          :  LongInt;


 Begin
   LastPurch:=0; LastSales:=0; LastCleared:=0;

   N:=0;  Tries:=0; TryMax:=1000;

   {$B-}

   If (PYr>0) then
   Begin

     If (PPr=YTD) and (Last_YTD(NType,NCode,PCr,AdjYr(PYr,BOff),PPr,Fnum,NPath,BOff)) then
     With NHist do
     Begin

       N:=(PYr-Yr);

       If (N>1) then  {* Add YTD In between *}
         For N:=AdjYr(Yr,BOn) to AdjYr(PYr,BOff) do
           Add_NHist(NType,NCode,PCr,N,PPr,Fnum,NPath);

       LastPurch:=Purchases;
       LastSales:=Sales;

       If (NType In [CustHistCde,StkStkQCode,StkDLQCode,StkBillQCode,JobGrpCode,JobJobCode]) then  {* This mod necessary,
                                                         as otherwise qty adjustments or account comitted which transend years
                                                         missed *}
         LastCleared:=Cleared;
     end;




     {$B+}


     With NHist do
     Begin

       ResetRec(Fnum);

       ExClass:=NType;

       Code:=FullNHCode(NCode);

       Cr:=PCr;  Yr:=PYr; Pr:=PPr;

       Sales:=LastSales;  Purchases:=LastPurch;

       Cleared:=LastCleared;

       Repeat
         Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Npath);

         Inc(Tries);

       Until (Not (Status In [84,85])) or (Tries>TryMax);

       Report_BError(Fnum,Status);

     end; {With..}
   end
   else
   Begin
     If (Debug) then;
   end;
 end; {Proc..}





 { =============== Procedure to Post Actual History Record =============== }

 Procedure Post_To_Hist(NType         :  Char;
                        NCode         :  Str20;
                        PPurch,PSales,
                        PCleared
                                      :  Real;
                        PCr,PYr,PPr   :  Byte;
                    Var PrevBal       :  Double);

 Const
   Fnum  =  NHistF;
   NPath =  NHK;


 Var
   NKey       :  Str255;
   QtyNoDecs  :  Byte;

   Tries,TryMax,
   LAddr      :  LongInt;

   {$IFDEF EXSQL}
     FuncRes: Integer;
     Buffer: Str20;
     LStatus : LongInt;
   {$ENDIF}
 Begin
   {$IFDEF EXSQL}
   if SQLUtils.UsingSQLAlternateFuncs then
   begin
     Buffer := StringOfChar(#32, 20);
     Move(NCode[1], Buffer[1], Length(NCode));
     FuncRes := SQLUtils.PostToHistory(NType, Buffer, PPurch, PSales, PCleared, 0, 0, PCr, PYr, PPr, Syss.NoQtyDec, PrevBal, LStatus, NIL);
     if (FuncRes <> 0) and (LStatus = 0) then
       LStatus := FuncRes;
     if (LStatus <> 0) then
       Report_ErrorStr(SQLUtils.LastSQLError);
   end
   else
   {$ENDIF}
   begin
     Blank(NKey,Sizeof(NKey));  PrevBal:=0;

     NKey:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

     QtyNoDecs:=2; Tries:=0; TryMax:=1000;

     Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NKey);



     If (Not StatusOK) then
       Add_NHist(NType,NCode,PCr,PYr,PPr,Fnum,NPath);


     Blank(NKey,Sizeof(NKey));

     NKey:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

     Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,NKey,NPath,Fnum,BOn,GlobLocked,LAddr);

     If (Ok) and (GlobLocked) then
     With NHist do
     Begin
       {* Adjust Rounding on Stock Qty Calculations, Cleared = Qty count *}
       If (ExClass In StkProdSet+[StkGrpCode,StkDescCode,StkStkQCode,StkBillQCode,CuStkHistCode]+[CommitHCode,JobGrpCode,JobJobCode]) then
         QtyNoDecs:=Syss.NoQtyDec;

       PrevBal:=Purchases-Sales;

       Purchases:=Purchases+Round_Up(PPurch,2);

       Sales:=Sales+Round_Up(PSales,2);

       Cleared:=Cleared+Round_Up(PCleared,QtyNoDecs);

       Repeat
         Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Npath);

         Inc(Tries);

       Until (Not (Status In [84,85])) or (Tries>TryMax);

       Report_Berror(Fnum,Status);

       Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
     end
     else
       If (Not Ok) then
         Status:=4
       else
         Status:=84;

     Report_BError(Fnum,Status);
   end;
 end; {Proc..}





 { ================ Recursivley Post to YTD & Future Year to dates ============== }

 Procedure Post_To_CYTDHist(NType          :  Char;
                            NCode          :  Str20;
                            PPurch,PSales,
                            PCleared       :  Real;
                            PCr,PYr,PPr    :  Byte);

 Var
   Rnum   :  Double;
 {$IFDEF EXSQL}
   FuncRes: Integer;
   Buffer: Str20;
   LStatus : LongInt;
 {$ENDIF}
 Begin
   {$IFDEF EXSQL}
   if SQLUtils.UsingSQLAlternateFuncs then
   begin
     Buffer := StringOfChar(#32, 20);
     Move(NCode[1], Buffer[1], Length(NCode));
     FuncRes := SQLUtils.PostToYearDate(NType, Buffer, PPurch, PSales, PCleared, 0, 0, PCr, PYr, PPr, Syss.NoQtyDec, LStatus, NIL);
     if (FuncRes <> 0) and (LStatus = 0) then
       LStatus := FuncRes;
     if (LStatus <> 0) then
       Report_ErrorStr(SQLUtils.LastSQLError);
   end
   else
   {$ENDIF}
   begin
     Rnum:=0;

     Post_To_Hist(NType,NCode,PPurch,PSales,PCleared,PCr,PYr,PPr,Rnum);

     If (Last_YTD(NType,NCode,PCr,AdjYr(PYr,BOn),PPr,NHistF,NHK,BOn)) then
       Post_To_CYTDHist(NType,NCode,PPurch,PSales,PCleared,PCr,NHist.Yr,PPr);
   end;
 end;










{ ====== Return I/O depending on doc type for VAT Purposes ======= }

Function IOVATCode(DocHed  :  DocTypes;
                   NIOCode :  Char)  :  Char;
Begin
  If (DocHed=NMT) and ((NIOCode=IOVATCh[BOff]) or (NIOCode=IOVATCh[BOn])) then
    Result:=NIOCode
  else
    Result:=IOVATCh[(DocHed In SalesSplit)];
end;



{ ============= Return Doc TYpe from Doc Code ============= }


Function DocTypeFCode(DocStr  :  Str5)  :  DocTypes;

Var
  LastDT,
  n       :  DocTypes;
  Finish  :  Boolean;


Begin
  n:=SIN;

  Finish:=BOff;

  LastDT:=JPA;

  {$B-}

  While (Not Finish) and (N<=LastDT) and (Not CheckKey(DocStr,DocCodes[n],Length(DocStr),BOff)) do
    If (N<>LastDT) then
      n:=Succ(n)
    else
      Finish:=BOn;

  DocTypeFCode:=n;
end; {Func.}


{ =============== Convert Yr/Pr into YrPr Value =========== }

Function Pr2Fig(FYr,FPr  :  Byte)  :  LongInt;

Begin
  {$IFDEF EXSQL}
    // MH 15/08/2008: Modified to duplicate the previous behavior if YTD/YYTDNCF pass in as period
    //2Fig := (FYr * 100) + FPr;

    If (FPr > 99) Then
      Result := (FYr * 1000) + FPr
    Else
      Result := (FYr * 100) + FPr;
  {$ELSE}
    Pr2Fig:=IntStr(SetN(FYr)+SetN(FPr));
  {$ENDIF}
end;


{ =============== Display a True Value as '*', FALSE as ' ' =========== }

Function TrueChar(TF  :  Boolean)  :  Char;

Begin
  If (TF) then
    TRUEChar:='*'
  else
    TRUEChar:=#32;
end;


{ =============== Procedure to Calculate Aged Analysis Months Dates ============= }

Procedure AllocateAged(Var  AgedAry  :  AgedTyp;
                            AgedDate,
                            AsAtDate :  LongDate;
                            Amount   :  Real);

Var
  Diff      :  Integer;

Begin
  Diff:=MonthDiff(AgedDate,AsAtDate);

  Case Diff of

     0..3    :  AgedAry[Diff+1]:=AgedAry[Diff+1]+Amount;
     else       If (Diff>=0) then
                  AgedAry[5]:=AgedAry[5]+Amount
                else
                  AgedAry[0]:=AgedAry[0]+Amount;

  end;

  If (Diff>=0) then
    AgedAry[6]:=AgedAry[6]+Amount;

  AgedAry[7]:=AgedAry[6]+AgedAry[0];
end;






Function Calc_NewVATPeriod(LastVDate  :  LongDate;
                           NoMnths    :  Integer)  :  LongDate;

Var
  Vd,Vm,Vy  :  Word;

Begin
  DateStr(LastVDate,Vd,Vm,Vy);

  AdjMnth(Vm,Vy,NoMnths);

  Vd:=Monthdays[Vm];

  If (Vm=2) then  {* Make Feb 28th..}
    Vd:=Pred(Vd);

  Calc_NewVATPeriod:=StrDate(Vy,Vm,Vd);
end;

Function AdjLeap(DDate  :  LongDate)  :  LongDate;

Var
  Vd,Vm,Vy  :  Word;

Begin

  DateStr(DDate,Vd,Vm,Vy);

  If (Vm=2) and (Vd=29) then
    Vd:=Pred(Vd);

  AdjLeap:=StrDate(Vy,Vm,Vd);

end;


{ ============== Return VAT Period ============== }

Function CalcVATDate(DDate  :  LongDate)  :  LongDate;

Var
  VDate  :  LongDate;

Begin
  With SyssVAT.VATRates do
  Begin

    If (CurrPeriod<>'') then
      VDate:=CurrPeriod
    else
      VDate:=Today;

    DDate:=AdjLeap(DDate); {* Force a leap year into 28th VAT return*}


    If (DDate>VDate) then
      While (DDate>VDate) and (VATInterval<>0) do
        VDate:=Calc_NewVATPeriod(VDate,VATInterval);

  end; {With..}

  CalcVATDate:=VDate;

end; {Func..}


{ === Function to return Local period === }

Function GetLocalPr(Mode  :  Byte)  :  tLocalPeriod;

Begin
  Blank(Result,Sizeof(Result));

  With UserProfile^ do
    If (Mode=0) then
    Begin
      {$IFDEF PERIODFIX}
      If (oUserPeriod.Period = 0) or (oUserPeriod.Year = 0) then
      {$ELSE}
      If (UCPr=0) or (UCYr=0) then
      {$ENDIF}
      Begin
        Result.CPr:=Syss.CPr;
        Result.CYr:=Syss.CYr;
        Result.DispPrAsMonths:=Syss.DispPrAsMonths;
      end
      else
      Begin
        {$IFDEF PERIODFIX}
          Result.CPr:=oUserPeriod.Period;
          Result.CYr:=oUserPeriod.Year;
          Result.DispPrAsMonths:=oUserPeriod.DisplayAsMonths;
        {$ELSE}
          Result.CPr:=UCPr;
          Result.CYr:=UCYr;
          Result.DispPrAsMonths:=UDispPrMnth;
        {$ENDIF}
      end;
    end {With..}
    else
    Begin
      {$IFDEF PERIODDEBUG}
        MainForm.CheckPeriods('GetLocalPr (' + Syss.IDCode + ')');
      {$ENDIF}

      {$IFDEF PERIODFIX}
        oUserPeriod.SetPeriodYear(Syss.CPr, Syss.CYr);
        oUserPeriod.DisplayAsMonths:=Syss.DispPrAsMonths;
      {$ELSE}
        UCPr:=Syss.CPr;
        UCYr:=Syss.CYr;
        UDispPrMnth:=Syss.DispPrAsMonths;
      {$ENDIF}
    end;
end;

{* Proc to override the excel file name with a numbered sequence continuation name so that multiple thread jobs can share the same file name *}

Function Continue_ExcelName(FName  :  AnsiString;
                            FMode,
                            SeqNo  :  Byte;
                            ASuffix: string = '')  :  ANSIString;

Var
  n     :  Byte;
  DStr,
  FStr,
  CStr  :  Str255;
Begin
  Result:= FName;
  // FMode is 5 for Excel
  // FMode is 7 for HTML
  // TG 22/02/2017: 17704 - If printing revaluation report to html, report is overwritten by following posting report
  If (FMode=5) or (FMode=7) then {We are o/p to Excel so engage sequence}
  Begin
    DStr:=ExtractFilePath(FName);
    FStr:=ExtractFileName(FName);
    n:=Pos('.',FStr);
    If (n<>0) then
    Begin
      if ASuffix <> '' then
        CStr:=DStr+Copy(FStr,1,Pred(n))+ASuffix+Copy(FStr,n,Succ(Length(FStr)-n))
      else
        CStr:=DStr+Copy(FStr,1,Pred(n))+SetN(SeqNo)+Copy(FStr,n,Succ(Length(FStr)-n));
      Result:=CStr;
    end;
  end;

end;


//PR: 08/02/2012 Function to find the next qty break folio from the doc nos file. Adapted from GetNextCount ABSEXCH-9795
function GetNextQtyBreakFolio : Integer;
Const
  Fnum     :  Integer  =  IncF;
  Keypath  :  Integer  =  IncK;

Var
  Key2F  :  Str255;
  TmpOk  :  Boolean;
  Lock   :  Boolean;
  TmpStatus
         :  Integer;
  LAddr,
  Cnt,NewCnt
         :  LongInt;



Begin
  Lock:=BOff;  Cnt:=0;  NewCnt:=0; TmpStatus:=0;
  Key2F:=S_QTY_BREAK_FOLIO_KEY;

  TmpOk:=GetMultiRecAddr(B_GetEq,B_MultLock,Key2F,Keypath,Fnum,BOn,Lock,LAddr);

  if not TmpOK then //add record
  begin
    FillChar(Count, SizeOf(Count), 0);
    Count.CountTyp := S_QTY_BREAK_FOLIO_KEY;

    //PR: 17/02/2012 Set initial value to 1 rather than 0.
    Count.NextCount := FullNomKey(1);

    TmpStatus := Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    Report_BError(Fnum, TmpStatus);

    //Retry get
    TmpOk:=GetMultiRecAddr(B_GetEq,B_MultLock,Key2F,Keypath,Fnum,BOn,Lock,LAddr);
  end;

  If (TmpOk) and (Lock) then
  With Count do
  Begin

    Move(NextCount[1],Cnt,Sizeof(Cnt));

    NewCnt := Cnt;
    Inc(Cnt);
    Move(Cnt, NextCount[1], Sizeof(Cnt));

    TmpStatus:=Put_Rec(F[Fnum], Fnum, RecPtr[Fnum]^, Keypath);

    Report_BError(Fnum, TmpStatus);

    TmpStatus:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
  end;

  Result := NewCnt;
end;



end.
