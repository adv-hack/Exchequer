unit BTSup1;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{* This Unit is only for 16 bits DLL version instead of using shared units -
   BtKeys1U, BTSupU1, ComnUnit, ComU2, etc.. *}

interface

Uses
  GlobVar,
  {$IFNDEF WIN32}
    VRec2U,
  {$ENDIF}
  VarConst,
  VarCnst3,
  BtrvU16;


Const
  GenRealMask   =  '###,###,##0.00 ;###,###,##0.00-';
  GenQtyMask   =  '0';
  GenPcntMask   =  '0.00%';
  CustKeyLen    =  6;
  StkKeyLen     =  16;
  DocKeyLen     =  9;

Procedure ResetRec(FNum  :  Integer);

Procedure SetDataRecOfs(FNum     :  Integer;
                        Ofset    :  LongInt);

Function FullNHCode(CCode  :  Str20) :  AnyStr;

Function FullNCode(CCode  :  Str10) :  AnyStr;

Function FullNomKey(ncode  :  Longint)  :  Str20;

Function FullIdKey(Ino,Lno  :  Longint)  :  Str20;

Function FullCustCode(CCode  :  Str10)  :  Str10;

Function FullOurRefKey(DCode  :  Str10)  :  Str10;

Function FullStockCode(CCode  :  Str20)  :  Str20;

Function PartNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr   :  Byte)  :  Str30;

Function FullNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr,Yr,
                      Pr   :  Byte)  :  Str30;

Function FullQDKey (RC,ST        :  Char;
                    Login        :  Str30)  :  Str30;


Function AutoSetInvKey(InpKey   :  Str255;
                       IKNo     :  Integer)  :  Str255;

Function MakeFIKey (SFOL         :  LongInt;
                    SDate        :  Str8)  :  Str30;

Function MakeFIDocKey (DNo          :  Str10;
                       SFOL,
                       DLNo         :  LongInt)  :  Str30;

Function CheckKey(KeyRef,Key2Chk  :  Str255;
                  KeyLen          :  Integer;
                  AsIs            :  Boolean) :  Boolean;

Function CheckKeyRange(KeyRef,
                       KeyRef2,
                       Key2Chk  :  Str255;
                       KeyLen   :  Integer;
                       AsIs     :  Boolean) :  Boolean;

Procedure Report_BError(Fnum,
                        ErrNo  :  Integer);

Procedure ShowDrCr(    Amount  :  Real;
                   Var DrCr    :  DrCrType);

Function GetMultiRec(Func      :  Integer;
                     LockType  :  Integer;
                 Var Key2S     :  Str255;
                     KeyPth    :  Integer;
                     Fnum      :  Integer;
                     Wait      :  Boolean;
                 Var Locked    :  Boolean) : Integer;

Function Check4DupliGen(KEyS  :  Str255;
                        Fnum,
                        KeyP  :  Integer;
                        DupliP:  Str80)  :   Boolean;



Function  CheckExsists(KeyR  :  Str255;
                       FileNum,KeyPath
                             :  Integer)  :  Boolean;

Function  CheckRecExsists(KeyR  :  Str255;
                          FileNum,KeyPath
                               :  Integer)  :  Boolean;

Procedure DeleteLinks (Code  :  Str255;
                       Fnum  :  Integer;
                       KLen  :  Integer;
                       KeyPth:  Integer;
                       DelInv:  Boolean);

Procedure Close_Files(ByFile  :  Boolean);

Procedure Report_IOError(IOCode  :  Integer;
                         Fname   :  Str255);

Function Total_Profit_To_Date(NType        :  Char;
                              NCode        :  Str10;
                              PCr,PYr,PPr  :  Byte;
                          Var Purch,PSales,
                              PCleared,
                              PBudget      :  Real;
                              Range        :  Boolean)  :  Real;

Function Profit_To_Date(NType        :  Char;
                        NCode        :  Str10;
                        PCr,PYr,PPr  :  Byte;
                    Var Purch,PSales,
                        PCleared     :  Real;
                        Range        :  Boolean)  :  Real;

Procedure Init_AllSys;


Function FIFO_Mode(CMode  :  Char)  :  Byte;

Function Is_FIFO(CMode  :  Char)  :  Boolean;


Function Calc_PAmount(FullAmount,DiscAmnt  :  Real;
                      DiscCh               :  Char)  :  Real;

Procedure SetDataRecOfsPtr(FileNum  :  Integer;
                           Ofset    :  LongInt;
                       Var DataRec);

Function FullMatchKey (RC,ST        :  Char;
                       Login        :  Str20)  :  Str20;

Function Full_StkBOMKey(SFol,
                        SLNo  :  LongInt)  :  Str20;

Function MakeCDKey (CCode        :  Str10;
                    SCode        :  Str20;
                    QCurr        :  Byte)  :  Str30;

Function FullCDKey (CCode        :  Str10;
                    SFol         :  LongInt)  :  Str30;


Function Get_StkPrice(PBands  :  SaleBandAry;
                      DiscR   :  Real;
                      DiscCh  :  Char;
                      Currency:  Byte;
                      SellU,
                      QtyM    :  Real;
                      UP      :  Boolean)  :  Real;    {* Invct2SU.Pas *}

Function Calc_IdQty(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;      {* ComnUnit.Pas *}

Function Calc_StkCP(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;

Function NFIFO_GetCost(StockR  :  StockRec;
                      FCurr   :  Byte;
                      QtyCr,
                      QtyM    :  Real;
                      LocFilt :  Str10)  :  Real;

Function GetVATNo(Vcode :  Char)  :  VATType;

Function MakeSNKey (SFOL         :  LongInt;
                    Sold         :  Boolean;
                    SNo          :  Str20)  :  Str30;

Function FullJBCode(JC     :  Str10;
                    Curr   :  Byte;
                    SCode  :  Str20)  :  Str30;

Function  PartCCKey (RC,ST        :  Char)  :  Str20;

Function FullRunNoKey(Rno,Fno  :  Longint)  :  Str20;

Function Part_PostPayInKey(SepCh    :  Char;
                           NomCode  :  LongInt)  :  Str10;

Function Pre_PostPayInKey(SepCh  :  Char;
                          RefNo  :  Str80)  :  Str30;

Function Full_PostPayInKey(SepCh    :  Char;
                           NomCode  :  LongInt;
                           Currency :  Byte;
                           PayRef   :  Str80)  :  Str30;

Procedure Update_UpChange(NewNeed  :  Boolean);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETMiscU,
  ETStrU,
  WinTypes,
  WinProcs,
  BTSFr,
  Controls,
  Dialogs,
  SysUtils,
  Forms,
  BTSup2,
  BTS1,
  FIFOLU;


 Var
   SysCount  :  SysrecTypes;


(*  UpcaseStr converts a string to upper case *)

function UpcaseStr(S : Str80) : Str80;
var
  P : Integer;
begin
  for P := 1 to Length(S) do
    S[P] := Upcase(S[P]);
  UpcaseStr := S;
end;

function UpcaseStrList(S     : Str80;
                       AsIs  : Boolean) : Str80;


Begin
  If (AsIs) then
    UpCaseStrList:=S
  else
    UpCaseStrList:=UpCaseStr(S);
end; {Func..}

{ ================ Procedure to Reset Current Record ============== }

Procedure ResetRec(FNum  :  Integer);

Begin
  Case Fnum of
    CustF    :  FillChar(Cust,FileRecLen[FNum],0);
    InvF     :  FillChar(Inv,FileRecLen[FNum],0);
    IdetailF :  FillChar(Id,FileRecLen[FNum],0);
    NomF     :  FillChar(Nom,FileRecLen[FNum],0);
    StockF   :  FillChar(Stock,FileRecLen[FNum],0);
    NHistF   :  FillChar(NHist,FileRecLen[FNum],0);
    IncF     :  FillChar(Count,FileRecLen[FNum],0);
    PWrdF    :  FillChar(PassWord,FileRecLen[FNum],0);
    MiscF    :  FillChar(MiscRecs^,FileRecLen[FNum],0);
    JMiscF   :  FillChar(JobMisc^,FileRecLen[FNum],0);
    JobF     :  FillChar(JobRec^,FileRecLen[FNum],0);
    JCtrlF   :  FillChar(JobCtrl^,FileRecLen[FNum],0);
    JDetlF   :  FillChar(JobDetl^,FileRecLen[FNum],0);
    MLocF    :  FillChar(MLocCtrl^,FileRecLen[FNum],0);
    SysF     :  FillChar(Syss,FileRecLen[FNum],0);
    ReportF  :  FillChar(RepScr^,FileRecLen[FNum],0);
    {$IFDEF EDLL}
    DictF    :  FillChar(DictRec^,FileRecLen[FNum],0);
    {$ENDIF}
    {$IFDEF RW}
    DictF    :  FillChar(DictRec^,FileRecLen[FNum],0);
    RepGenF  :  FillChar(RepGenRecs^,FileRecLen[FNum],0);
    {$ENDIF}
    {$IFDEF COMP}
    RepGenF  :  FillChar(RepGenRecs^,FileRecLen[FNum],0);
    CompF    :  FillChar(Company^,FileRecLen[FNum],0);
    {$ENDIF}

  end; {Case..}
end;


{ ============ Low Level Proc to Set Data Record for 4-byte offset ========== }

Procedure SetDataRecOfs(FNum     :  Integer;
                        Ofset    :  LongInt);

Begin
  Case FNum  of
    CustF     :  Move(Ofset,Cust,Sizeof(Ofset));
    InvF      :  Move(Ofset,Inv,Sizeof(Ofset));
    IdetailF  :  Move(Ofset,Id,Sizeof(Ofset));
    NomF      :  Move(Ofset,Nom,Sizeof(Ofset));
    StockF    :  Move(Ofset,Stock,Sizeof(Ofset));
    NHistF    :  Move(Ofset,NHist,Sizeof(Ofset));
    IncF      :  Move(Ofset,Count,Sizeof(Ofset));
    PWrdF     :  Move(Ofset,PassWord,Sizeof(Ofset));
    MiscF     :  Move(Ofset,MiscRecs^,Sizeof(Ofset));
    JMiscF    :  Move(Ofset,JobMisc^,Sizeof(Ofset));
    JobF      :  Move(Ofset,JobRec^,Sizeof(Ofset));
    JCtrlF    :  Move(Ofset,JobCtrl^,Sizeof(Ofset));
    JDetlF    :  Move(Ofset,JobDetl^,Sizeof(Ofset));
    MLocF     :  Move(Ofset,MLocCtrl^,Sizeof(Ofset));
    SysF      :  Move(Ofset,Syss,Sizeof(Ofset));
    ReportF   :  Move(Ofset,RepScr^,Sizeof(OfSet));
    {$IFDEF EDLL}
    DictF     :  Move(Ofset,DictRec^,Sizeof(Ofset));
    {$ENDIF}
    {$IFDEF RW}
    DictF     :  Move(Ofset,DictRec^,Sizeof(Ofset));
    RepGenF   :  Move(Ofset,RepGenRecs^,Sizeof(Ofset));
    {$ENDIF}
    {$IFDEF COMP}
    RepGenF   :  Move(Ofset,RepGenRecs^,Sizeof(Ofset));
    CompF     :  Move(Ofset,Company^,Sizeof(Ofset));
    {$ENDIF}

  end; {Case..}

end;



{ ================ Various Key builders ============= }

Function FullCustCode(CCode  :  Str10)  :  Str10;

Begin

  Result:=LJVar(CCode,AccLen);

end;


{ ========= Function to Return Full Nominal Key ========== }

Function FullNomKey(ncode  :  Longint)  :  Str20;


Var
  TmpStr  :  Str20;

Begin
  Blank(TmpStr,Sizeof(TmpStr));

  Move(ncode,TmpStr[1],Sizeof(ncode));

  TmpStr[0]:=Chr(Sizeof(ncode));

  FullNomKey:=TmpStr;
end;




{ ======== Function to Return Full OurRef Key =========== }

Function FullOurRefKey(DCode  :  Str10)  :  Str10;

Begin

  FullOurRefKey:=LJVar(DCode,DocLen);

end; {Func..}



{ ========= Function to Return Detail Key Link ========== }

Function FullIdKey(Ino,Lno  :  Longint)  :  Str20;

Begin
  FullIdKey:=Strip('R',[#0],FullNomKey(Ino)+FullNomKey(Lno));
end;


{ ================ Function to return Stock Code ============= }

Function FullStockCode(CCode  :  Str20)  :  Str20;

Begin

  Result:=LJVar(CCode,StkLen);

end;

Function FullNHCode(CCode  :  Str20) :  AnyStr;

Begin
  FullNHCode:=LJVar(Ccode,NHCodeLen);
end;


{ ========= Function to return full uncapitalised STR Longint Equivalent code ======== }

Function FullNCode(CCode  :  Str10) :  AnyStr;

Begin
  FullNCode:=LJVar(Ccode,AccLen);
end;


Function PartNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr   :  Byte)  :  Str30;

{ ========= Function to return full uncapitalised STR Longint Equivalent code ======== }

Begin
  PartNHistKey:=Typ+FullNHCode(Code)+Chr(Cr);
end;


Function FullNHistKey(Typ  :  Str5;
                      Code :  Str20;
                      Cr,Yr,
                      Pr   :  Byte)  :  Str30;
Begin
  FullNHistKey:=PartNHistKey(Typ,Code,Cr)+Chr(Yr)+Chr(Pr);
end;


{ ========= Function to Return Part Cost Code ========== }


  Function  PartCCKey (RC,ST        :  Char)  :  Str20;


  Begin
    PartCCKey:=Rc+St;
  end;



   { ========= Function to Return Qty Disc Code ========== }


 Function FullQDKey (RC,ST        :  Char;
                     Login        :  Str30)  :  Str30;




 Begin
   FullQDKey:=PartCCKey(Rc,St)+Login;
 end;




  { ========= Function to MAke FIFI Code ========== }


  Function MakeFIKey (SFOL         :  LongInt;
                      SDate        :  Str8)  :  Str30;

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

  TmpPrefix:=Copy(TmpK,1,LenPreFix);

  TmpNo:=Strip('L',['0'],Copy(TmpK,Succ(LenPrefix),(Length(TmpK)-LenPrefix)));

  TmpK:=TmpPrefix+SetPadNo(TmpNo,(IKNo-LenPreFix));

  AutoSetInvKey:=LJVar(TmpK,IKNo);

end; {Function..}




{ ================ Procedure to Compare Search Keys ============= }

Function CheckKey(KeyRef,Key2Chk  :  Str255;
                  KeyLen          :  Integer;
                  AsIs            :  Boolean) :  Boolean;

Begin
  If (Length(Key2Chk)>=KeyLen) then
    CheckKey:=(UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)=UpcaseStrList(Copy(KeyRef,1,KeyLen),AsIs))
  else
    CheckKey:=False;
end;




{ =============== Function to Compare Search Keys by Range ================== }


Function CheckKeyRange(KeyRef,
                       KeyRef2,
                       Key2Chk  :  Str255;
                       KeyLen   :  Integer;
                       AsIs     :  Boolean) :  Boolean;

Begin
  If (KeyRef2='') then
    KeyRef2:=KeyRef;     { Set To Main Compatibility }


  If (Length(Key2Chk)>=KeyLen) then
    CheckKeyRange:=((UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)>=UpcaseStrList(Copy(KeyRef,1,KeyLen),AsIs)) and
                    (UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)<=UpcaseStrList(Copy(KeyRef2,1,KeyLen),AsIs)))
  else
    CheckKeyRange:=False;
end;


{ ============= Function to Report Btrieve Error ============= }

Procedure Report_BError(Fnum,
                        ErrNo  :  Integer);
Var
  ErrStr  :  Str255;
  mbRet   :  Word;

Begin

  If (ErrNo<>0) then
  Begin
    ErrStr:=Set_StatMes(ErrNo);

    mbRet:=MessageDlg('Error in file : '+FileNAmes[Fnum]+#13+'Error '+Form_Int(ErrNo,0)+', '+#13+ErrStr,
           mtError,[mbOk],0);
  end;
end; {Proc..}


{ ============= Procedure to Return debit / Credit ============= }

Procedure ShowDrCr(    Amount  :  Real;
                   Var DrCr    :  DrCrType);


Begin
  Blank(DrCr,SizeOf(DrCr));

  DrCr[(Amount<0)]:=ABS(Amount);
end;



{ ============ Lock via a DirectCall ============ }

Function Lock_Direct(Func  :  Integer;
                     Fnum  :  Integer;
                     KeyPth:  Integer)  :  Integer;


Var
  LockCode  :  Integer;
  RecAddr   :  LongInt;



Begin
  LockCode:=GetPos(F[Fnum],Fnum,RecAddr);

  If (LockCode=0) then
  Begin
    SetDataRecOfs(Fnum,RecAddr);

    LockCode:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth,Func);
  end;

  Lock_Direct:=LockCode;

end;




{ ======= Lower Level Routine to Atempt a Record Lock ========= }

Function Try_Lock(Func      :  Integer;
                  LockType  :  Integer;
              Var Key2S     :  Str255;
                  KeyPth    :  Integer;
                  Fnum      :  Integer)  :  Integer;


Begin

   If (Func<>B_GetDirect) then
    Try_Lock:=Find_Rec(Func+LockType,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth,Key2s)
  else
    Try_Lock:=Lock_Direct(LockType,Fnum,KeyPth);

end; {Func..}



{ ======= General Routine to Atempt a Record Lock ========= }

Function GetMultiRec(Func      :  Integer;
                     LockType  :  Integer;
                 Var Key2S     :  Str255;
                     KeyPth    :  Integer;
                     Fnum      :  Integer;
                     Wait      :  Boolean;
                 Var Locked    :  Boolean) : Integer;

Var
  Bcode,
  Fcode    :  Integer;
  MbRet    :  Word;
  TmpForm  :  TBTWaitLock;
  Msg      :  TMsg;

Begin
  Locked:=BOff; Fcode:=0;

  TmpForm:=NIL;

  BCode:=Try_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum);

  If (Bcode<>0) then
  Case Bcode of

       22      : Begin
                   Locked:=(VariFile[Fnum]);
                   If (Locked) then
                     Bcode:=0;
                 end;

       (*
       84,85
               :  If (Wait) then
                  Begin

                   Try

                     TmpForm:=AltCreateMessageDialog('Record in use by another station!...'+#13+
                                                     'Waiting for other station to finish.',
                                                     mtInformation,[]);

                     TmpForm.Left:=(Screen.Width-TmpForm.Width);
                     TmpForm.Top:=(Screen.Height-TmpForm.Height);

                     TmpForm.Show;
                     TmpForm.Update;

                     Repeat

                       BCode:=Try_Lock(Func,B_SingWLock+LockType,Key2S,Keypth,Fnum);

                       If (PeekMessage(Msg,0,0,0,pm_Remove)) then
                       Begin
                         If Not IsDialogMessage(TmpForm.Handle,Msg) then
                         Begin
                           TmpForm.Show;
                           TmpForm.Update;
                         end;
                       end;

                     Until (BCode=0);

                   Finally

                     TmpForm.Free;

                   end;

                   Locked:=(BCode=0);
                 end;
       *)
       84,85  {$IFDEF Su_On}

              :  Begin
                   mbRet:=MessageDlg('Network Violation! - Closing System',
                                      mtError,[mbOk],0);

                   Halt;
                 end;

              {$ELSE}


              :  If (Not Wait) then
                 Begin
                   {* Establish if record found at all *}

                   Fcode:=Find_Rec(Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth,Key2s);

                   Repeat

                     mbRet:=MessageDlg('Record in use by another station!',
                                        MtConfirmation,[mbRetry,mbCancel],0);

                     BCode:=Try_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum);

                   Until (MbRet=IdCancel) or (Bcode=0);

                   Locked:=(Bcode=0);

                   {* Set record found *}
                   Bcode:=Fcode;

                 end
                 else
                 Begin

                   TmpForm:=TBTWaitLock.Create(Application.Mainform);

                   Try

                     TMpForm.Init_Test(Func,Fnum,Keypth,LockType,Key2S,RecCPtr(RecPtr[Fnum]));

                     BCode:=(TmpForm.ShowModal - mrOk);

                   Finally

                     TmpForm.Free;

                   end;

                   Locked:=(Bcode=0);

                 end;

               {$ENDIF}


  end {Case..}
  else
    Locked:=BOn;

  {If (Bcode<>0) and (Debug) then Status_Means(Bcode);}


  Addch:=#0; {* Reset Lock Key *}


  GetMultiRec:=BCode;
end;





{ ================ Procedrue to Check for Duplicate XXX Records,.. ===}

Function Check4DupliGen(KEyS  :  Str255;
                        Fnum,
                        KeyP  :  Integer;
                        DupliP:  Str80)  :   Boolean;

Var
  Sure  :  Boolean;
  TmpCh :  Char;
  Count :  Byte;

  TmpStat,
  TmpKPath
        :  Integer;
  TmpRecAddr
        :  LongInt;

  TmpFn :  FileVar;

  MbRet :  Word;

Begin
  TmpFn:=F[Fnum];

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);


  Status:=Find_Rec(B_GetEq+B_KeyOnly,TmpFn,Fnum,RecPtr[Fnum]^,KeyP,KeyS);

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

  If (Status=0) then
  Begin
    mbRet:=MessageDlg('That '+DupliP+' already exists!',
                       mtWarning,[mbOk],0);

  end
  else If (Debug) and (Status<>4) then Status_Means(Status);

  Check4DupliGen:=(Status=0);

end;







{ =========== Function to Check Exsistance of Given Code without disturbing record ========= }


Function  CheckExsists(KeyR  :  Str255;
                       FileNum,KeyPath
                             :  Integer)  :  Boolean;

Var
  KeyS     :  Str255;
  TmpFn    :  FileVar;

  TmpStat,
  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;


Begin
  KeyS:=KeyR;

  TmpFn:=F[FileNum];

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);


  CEStatus:=Find_Rec(B_GetGEq+B_KeyOnly,TmpFn,FileNum,RecPtr[FileNum]^,KeyPath,KeyS);

  CheckExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

end;



{ =========== Function to Check Exsistance of Given Code and return record if found ========= }


Function  CheckRecExsists(KeyR  :  Str255;
                          FileNum,KeyPath
                               :  Integer)  :  Boolean;

Var
  KeyS     :  Str255;
  TmpFn    :  FileVar;

  TmpStat,
  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;



Begin
  KeyS:=KeyR;

  TmpFn:=F[FileNum];

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);


  CEStatus:=Find_Rec(B_GetGEq,TmpFn,FileNum,RecPtr[FileNum]^,KeyPath,KeyS);

  If (TestMode) and (CEStatus<>0) then
    ShowMessage('CheckRecExists failed with '+Form_Int(CEStatus,0)); {remove}

  If (CEStatus<>0) then
    ResetRec(FileNum);

  CheckRecExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

end;





{ ================== Procedure to Delete all Records Matching a give Code ============= }



Procedure DeleteLinks (Code  :  Str255;
                       Fnum  :  Integer;
                       KLen  :  Integer;
                       KeyPth:  Integer;
                       DelInv:  Boolean);

Var
  KeyS  :  Str255;
  Locked:  Boolean;

Begin
  KeyS:=Code;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);

                                            {* Mod so that Direct reciept lines do not get deleted on an invoice update *}

  While (Status=0) and (CheckKey(Code,KeyS,KLen,BOn)) and ((Not DelInv) or ((DelInv) and (Id.LineNo<> RecieptCode))) do
  Begin

    Status:=GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyPth,Fnum,BOn,Locked);

    If (StatusOk) and (Locked) then
      Status:=Delete_Rec(F[Fnum],Fnum,KeyPth);

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);


  end;
end;



{ ============= Close All Open Files ============= }

Procedure Close_Files(ByFile  :  Boolean);


Var
  Choice  :  Byte;

Begin

  For Choice:=1 to TotFiles do
    Status:=Close_File(F[Choice]);

{$I-}
  If (Debug) or (ByFile) or (ResetBtOnExit) then
    Status:=Reset_B
  else
    Status:=Stop_B;

  If (Debug) then
    Status_Means(Status);

  {$I+}
end;




{ ========== Function to calculate line total ========= }

Function InvLTotal(Idr       :  IDetail;
                   UseDisc   :  Boolean)  :  Double;

Var
  DiscValue  :  Double;

Begin

  With Idr do
  Begin
    If (UseDisc) then
      DiscValue:=Round_Up(Pcnt(Discount)*NetValue,2)
    else
      DiscValue:=0;

    Result:=Round_Up(Qty*(Netvalue-DiscValue),2);

  end; {With..}

end; {Func..}


{ ========== Function to calculate line Cost ========= }

Function InvLCost(Idr       :  IDetail)  :  Double;


Begin

  With Idr do
  Begin

    Result:=Round_Up(Qty*CostPrice,2);

  end; {With..}

end; {Func..}




{ =========== Report IOError =========== }


Procedure Report_IOError(IOCode  :  Integer;
                         Fname   :  Str255);


Const
  IOMess1  =  ' WARNING! - I/O Error ';
  IOMess3  =  ' in file';


Var
  mbRet  :  Word;

Begin
  If (IOCode<>0) then
  Begin

    MbRet:=MessageDlg(IOMess1+#13+IOError(IOCode)+IOMEss3+#13+Fname,mtError,[mbOk],0);
  end;

end;


{ ========= Procecdure to Inc/Dec Pr  ======== }

Procedure AdjPr(Var PYr,PPr  :  Byte;
                    ID       :  Boolean);

Begin
  If (ID) then
    If (PPr=Syss.PrInYr) then
    Begin
      Pyr:=AdjYr(PYr,BOn);
      PPr:=1;
    end
    else
      Inc(PPr)
  else
    If (PPr=1) then
    Begin
      Pyr:=AdjYr(PYr,BOff);
      PPr:=Syss.PrInYr;
    end
    else
      Dec(PPr);

end;


{ ============== Get Profit To Current Period ============== }

Function Total_Profit_To_Date(NType        :  Char;
                              NCode        :  Str10;
                              PCr,PYr,PPr  :  Byte;
                          Var Purch,PSales,
                              PCleared,
                              PBudget      :  Real;
                              Range        :  Boolean)  :  Real;


Const
  Fnum  =  NHistF;
  NPath =  NHK;



Var
  NHKey,NHChk,
  NHKey2       :  Str255;
  Bal          :  Double;



Begin
  Purch:=0; PSales:=0; PCleared:=0;  PBudget:=0; Bal:=0;

  NHChK:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

  If (Range) then
    NHKey:=FullNHistKey(NType,NCode,PCr,AdjYr(PYr,BOff),YTD)
  else
    NHKey:=NHChk;

  If (NType In YTDSet+[NomHedCode,CustHistCde,CustHistPCde]) then  {** Get Last Valid YTD **}
  Begin
    NHKey2:=NHKey;
    Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NHKey2);

    If (StatusOk) and (CheckKey(NHChk,NHKey2,Length(NHChk)-2,BOn)) and (NHist.Pr=YTD) then
      NHKey:=NHKey2;
  end;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NHKey);


  While (StatusOK) and (NHKey<=NHChk) do
  With NHist do
  Begin

    If ((NType<>CustHistCde) or (Not (Pr In [YTD,YTDNCF]))) then
    Begin
      Purch:=Purch+Purchases;
      PSales:=PSales+Sales;
    end;

    Bal:=Bal+(Purchases-Sales);

    PCleared:=PCleared+Cleared;

    PBudget:=PBudget+Budget;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NHKey);
  end;


  Total_Profit_To_Date:=Bal;

end; {Func..}



{ ============== Get Profit To Current Period ============== }

Function Profit_To_Date(NType        :  Char;
                        NCode        :  Str10;
                        PCr,PYr,PPr  :  Byte;
                    Var Purch,PSales,
                        PCleared     :  Real;
                        Range        :  Boolean)  :  Real;


Var
  PBudget  :  Real;


Begin

  PBudget:=0;

  Profit_To_Date:=Total_Profit_to_Date(NType,NCode,PCr,PYr,PPr,Purch,PSales,PCleared,PBudget,Range);


end; {Func..}






{ =========== Get MultiUser System File =========== }


Procedure GetMultiSys(Wait         :  Boolean;
                      Var  Locked  :  Boolean;
                           SysMode :  SysRecTypes);

Var
  TempSys  :  Sysrec;
  Key2F    :  Str255;


Begin

  TempSys:=Syss;

  Key2F:=SysNames[SysMode];


  If (Not Locked) then
  Begin
    Status:=Find_Rec(B_GetEq,F[SysF],SysF,RecPtr[SysF]^,0,Key2F);

    Locked:=BOn;

    If (Debug) then Status_Means(Status);

  end
  else
    Status:=GetMultiRec(B_GetEq,B_MultLock,Key2F,0,SysF,Wait,Locked);


  If (StatusOk) and (Locked) then
  Begin
    Status:=GetPos(F[SysF],SysF,SysAddr[SysMode]);

    Case SysMode of
      SysR  :  TempSys:=Syss;
      VATR  :  Move(Syss,SyssVAT^,Sizeof(SyssVAT^));
      CurR  :  Move(Syss,SyssCurr^,Sizeof(SyssCurr^));
      GCuR  :  Move(Syss,SyssGCuR^,Sizeof(SyssGCuR^));
      ModRR :  Move(Syss,SyssMod^,Sizeof(SyssMod^));
      DEFR  :  Move(Syss,SyssDEF^,Sizeof(SyssDEF^));
      {$IFDEF WSJ}
      JobSR :  Move(Syss,SyssJob^,Sizeof(SyssJob^));
      {$ENDIF}
      FormR :  Move(Syss,SyssForms^,Sizeof(SyssForms^));
    end;
  end; {If Ok..}

  Syss:=TempSys;
end;





{ =========== Put MultiUser System File =========== }

Procedure PutMultiSys(SysMode  :  SysRecTypes;
                      UnLock   :  Boolean);

Var
  TempSys  :  SysRec;

Begin
  TempSys:=Syss;

  ResetRec(SysF);

  SetDataRecOfs(SysF,SysAddr[SysMode]);

  Status:=GetDirect(F[SysF],SysF,RecPtr[SysF]^,0,0);

  If (StatusOk) then
  Begin


    Case SysMode of
      DEFR  :  Move(SyssDEF^,Syss,Sizeof(SyssDEF^));
      VATR  :  Move(SyssVAT^,Syss,Sizeof(SyssVAT^));
      CurR  :  Move(SyssCurr^,Syss,Sizeof(SyssCurr^));
      GCuR  :  Move(SyssGCuR^,Syss,Sizeof(SyssGCUR^));
      SysR  :  Syss:=TempSys;
      ModRR :  Move(SyssMod^,Syss,Sizeof(SyssMod^));
      {$IFDEF WSJ}
      JobSR :  Move(SyssJob^,Syss,Sizeof(SyssJob^));
      {$ENDIF}
      FormR :  Move(SyssForms^,Syss,Sizeof(SyssForms^));
    end;{Case..}


    Status:=Put_Rec(F[SysF],SysF,RecPtr[SysF]^,0);
  end;


  Report_BError(SysF,Status);

  If (UnLock) and (StatusOk) then
  Begin
    Status:=UnlockMultiSing(F[SysF],SysF,SysAddr[SysMode]);

    If (Debug) then
      Status_Means(Status);
  end;

  Syss:=TempSys;

end;




{ ================== Read-In all 3 system files ================== }

Procedure Init_AllSys;

Var
  TmpIO  :  Integer;

Begin

  For SysCount:=SysR to FormR do
  Begin
    GlobLocked:=BOff;
    GetMultiSys(BOff,GlobLocked,SysCount);
  end;

end;


  { ======= Function to Return Stock Valuation Mode ====== }

  Function FIFO_Mode(CMode  :  Char)  :  Byte;

  Var
    ModeVal  :  Byte;


  Begin
    ModeVal:=0;

    Case CMode of

      'C'  :  ModeVal:=1;
      'F'  :  ModeVal:=2;
      'L'  :  ModeVal:=3;
      'A'  :  ModeVal:=4;
      'R'  :  ModeVal:=5;
      'S'  :  ModeVal:=6;

    end; {Case..}

    FIFO_Mode:=ModeVal;

  end; {Func..}


      { ====== Is FIFO ====== }

  Function Is_FIFO(CMode  :  Char)  :  Boolean;

  Begin

    Is_FIFO:=(FIFO_Mode(CMode) In [2..3]);

  end;

  { ================== Function to Calculate Discount Amount ============== }

Function Calc_PAmount(FullAmount,DiscAmnt  :  Real;
                      DiscCh               :  Char)  :  Real;


Begin
  If (DiscCh=PcntChr) then
    Calc_PAmount:=(FullAmount*DiscAmnt)
  else
    Calc_PAmount:=DiscAmnt;
end;


Procedure SetDataRecOfsPtr(FileNum  :  Integer;
                           Ofset    :  LongInt;
                       Var DataRec);
Begin

  Move(Ofset,DataRec,Sizeof(Ofset));

end;

{ ========= Function to Return Match Doc Code ========== }


Function FullMatchKey (RC,ST        :  Char;
                       Login        :  Str20)  :  Str20;

Begin
  FullMatchKey:=Rc+St+LJVar(Login,DocKeyLen);
end;



{ ======= Return Full BOM Ndx ======== }


Function Full_StkBOMKey(SFol,
                        SLNo  :  LongInt)  :  Str20;


Begin

  Full_StkBOMKey:=FullNomKey(SFOL)+Dec2Hex(SLNo);

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

{ ==== Function to Return Correct Stock Selling Price based on band ==== }

Function Get_StkPrice(PBands  :  SaleBandAry;
                      DiscR   :  Real;
                      DiscCh  :  Char;
                      Currency:  Byte;
                      SellU,
                      QtyM    :  Real;
                      UP      :  Boolean)  :  Real;



Var
  Rnum  :  Real;
  FCurr :  Byte;


Begin

  Rnum:=0;

  FCurr:=0;

  If (DiscCh In StkBandSet) then
  With PBands[Succ(Ord(DiscCh)-Ord('A'))] do
  Begin
    Rnum:=SalesPrice;
    FCurr:=Currency;
  end
  else
  Begin
    Rnum:=PBands[1].SalesPrice;
    FCurr:=PBands[1].Currency;
  end;


  Rnum:=Calc_IdQty(Calc_StkCP(Currency_ConvFT(Rnum,FCurr,Currency,UseCoDayRate),SellU,UP),QtyM,Not UP);

  Rnum:=Round_Up(Rnum,Syss.NoNetDec);


  Get_StkPrice:=Rnum;

end; {Func..}

{ =========== Function to Return Qty, or Qty Mul ======== }

Function Calc_IdQty(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;


Begin

  If (UP) then
    Calc_IdQty:=Q*QM
  else
    Calc_IdQty:=Q;

end; {Func..}

{ =========== Function to Return Unit Cost Price ======== }

Function Calc_StkCP(Q,QM  :  Double;
                    UP    :  Boolean)  :  Double;


Begin

  If (Not UP) then
    Calc_StkCP:=DivWChk(Q,QM)
  else
    Calc_StkCP:=Q;

end; {Func..}


{ ======== Procedure to Scan FIFO and Process / Return Cost Price ======= }
{ This function is replicated within RevalU2U for thread safe operation  }


Function FIFO_CalcCrCost(StockR  :  StockRec;
                         TMisc   :  MiscRec)  :  Double;


Var
  UseRate  :  Boolean;
  NewAmnt  :  Double;


Begin
  UseRate:=UseCoDayRate;
  NewAmnt:=0.0;

  With TMisc.FIFORec do
  Begin
    {$IFDEF MC_On}
      If (Not RevalueStk(StockR.NomCodes[4])) and (FIFOCRates[UseRate]<>0.0) then
      Begin
        NewAmnt:=Conv_TCurr(FIFOCost,FIFOCRates[UseRate],FIFOCurr,BOff);

        {* Changed Conv_TCurr 15.07.98 *}
        With SyssCurr^.Currencies[StockR.PCurrency] do
          FIFO_CalcCrCost:=Conv_TCurr(NewAmnt,CRates[UseRate],StockR.PCurrency,BOn);


      end
      else
    {$ENDIF}

        FIFO_CalcCrCost:=Currency_ConvFT(FIFOCost,FIFOCurr,StockR.PCurrency,UseRate);


  end;
end;


Procedure FIFO_SQL(StockR  :  StockRec;
               Var QtyCr,
                   CPrice  :  Real;
                   Fnum,
                   Keypath :  Integer;
                   Mode,
                   FMode   :  Byte;
                   LocFilt :  Str10);




Var
  AVQty,
  AVPrice,
  AVCalc,
  TmpQty,
  QtyUsed,
  QtyNeed    :  Real;

  KeyS,
  KeyChk     :  Str255;

  TmpId      :  IDetail;

  B_Start,
  B_Func     :  Integer;

  FoundSome  :  Boolean;


Begin

  AVQty:=0; AVPrice:=0;  AVCalc:=0;

  QtyUsed:=QtyCr;

  QtyNeed:=QtyCr*DocNotCnst;

  TmpQty:=0;

  FoundSome:=BOff;

  Blank(TmpId,Sizeof(TmpId));

  B_Start:=B_GetGEq;

  B_Func:=B_GetNext;

  Case Mode of

    0..2
         :  Begin

              KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,FullNomKey(StockR.StockFolio));

              KeyS:=KeyChk;

              If (FMode=3) then {* Its LIFO *}
              Begin

                KeyS:=KeyS+NdxWeight;

                B_Start:=B_GetLessEq;
                B_Func:=B_GetPrev;

              end;

              Status:=Find_Rec(B_Start,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

              While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (QtyUsed<>0) do
              With MiscRecs^.FIFORec do
              Begin

                {* Average Calculations... Only use +ve FIFO Lines *}

                {$B-}

                If (Not Syss.UseMLoc) or (CheckKey(FIFOMLoc,LocFilt,Length(LocFilt),BOff)) then
                Begin

                {$B+}

                  If (Not FoundSome) then
                    FoundSome:=BOn;

                  If (Mode=2) then
                    TmpQty:=QtyLeft
                  else
                  Begin
                    If (QtyLeft>0) then
                      TmpQty:=QtyLeft
                    else
                      TmpQty:=0;

                    If (TmpQty>(QtyUsed*DocNotCnst)) then
                      TmpQty:=(QtyLeft-(QtyLeft-(QtyUsed*DocNotCnst)));
                  end;


                  AvQty:=AvQty+TmpQty;

                  {* Convert currency *}

                  {AvCalc:=(TmpQty*Currency_ConvFT(FIFOCost,FIFOCurr,StockR.PCurrency,UseCoDayRate));}

                  AvCalc:=(TmpQty*FIFO_CalcCrCost(StockR,MiscRecs^));

                  AvPrice:=AvPrice+AvCalc;

                  Case Mode of

                    0  :  FIFO_Edit(TmpId,QtyUsed,0,Fnum,Keypath,Mode,BOff,BOn);
                    1  :  Begin

                            QtyUsed:=QtyUsed+QtyLeft;

                            If (QtyUsed>0) then
                              QtyUsed:=0;
                          end;
                  end;
                end;

                If (QtyUsed<>0) then
                  Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

              end; {While..}

              Case Mode of

                2  :  If (FoundSome) then
                        CPrice:=Round_Up(DivWChk(AvPrice,AvQty),Syss.NoCosDec);

                else  Begin

                        AvCalc:=QtyNeed;

                        If (QtyNeed>AVQty) then
                          AVPrice:=AVPrice+((QtyNeed-AVQty)*CPrice)
                        else
                          If (QtyNeed<AVQty) then
                            AvCalc:=AvQty;

                        CPrice:=Round_Up(DivWChk(AvPrice,AvCalc),Syss.NoCosDec);
                      end;

              end;{case..}
            end;

  end; {Case..}

  QtyCr:=QtyUsed;

end; {Proc..}


{ ========== Return Cost Price based on averages ========= }


Function NFIFO_GetCost(StockR  :  StockRec;
                      FCurr   :  Byte;
                      QtyCr,
                      QtyM    :  Real;
                      LocFilt :  Str10)  :  Real;

Var
  Rnum     :  Real;

  TmpKPath,
  TmpStat  :  Integer;

  TmpRecAddr
           :  LongInt;

  TmpMisc  :  MiscRec;


Begin

  TmpMisc:=MiscRecs^;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOff,BOff);

  Rnum:=Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,StockR.CalcPack);

  QtyCr:=QtyCr*DocNotCnst;

  If (Is_FIFO(StockR.StkValType)) then
    FIFO_SQL(StockR,QtyCr,Rnum,MiscF,MIK,1,FIFO_Mode(StockR.StkValType),LocFilt);


  NFIFO_GetCost:=Currency_ConvFT(Calc_IdQty(Rnum,QtyM,Not StockR.CalcPack),StockR.PCurrency,FCurr,UseCoDayRate);

  TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOn,BOff);

  MiscRecs^:=TmpMisc;

end; {Func..}

{ =========== Return Vat Rate No. ============ }

Function GetVATNo(Vcode :  Char)  :  VATType;


Var
  n         :  VATType;
  FoundYet  :  Boolean;


Begin
  n:=Rate3;

  FoundYet:=(Vcode In VATEqRt3);

  If (Not FoundYet) then
  Begin

    n:=Rate4;

    FoundYet:=(VCode In VATEqRt4);

  end;



  If (Not FoundYet) then
  Begin

    n:=Standard;

    FoundYet:=(Vcode In VATEqStd);

  end;


  If (Vcode<>C0) and (Not FoundYet) then
  Begin
    While (n<=VEnd) and (Not FoundYet) do
    With SyssVAT^.VATRates do
    Begin

      FoundYet:=(Vcode=VAT[n].Code);
      Inc(n);
    end;

    If (FoundYet) then
      Dec(n);
  end;

  If (Not FoundYet) then
    n:=Spare8;


  GetVATNo:=n;

end; {Func..}


{ ========= Function to MAke SERN Code ========== }

Function MakeSNKey (SFOL         :  LongInt;
                    Sold         :  Boolean;
                    SNo          :  Str20)  :  Str30;
Begin

  MakeSNKey:=FullNomKey(SFOL)+Chr(Ord(Sold))+SNo;

end;


{ ====== Function to Manage Job Budg Code ===== }

Function FullJBCode(JC     :  Str10;
                    Curr   :  Byte;
                    SCode  :  Str20)  :  Str30;
Begin
    FullJBCode := LJVar(JC,JobCodeLen)+LJVar(SCode,StkLen)+Chr(Curr);
end;



{ ========= Function to Return Detail Key/Run No. Link ========== }

Function FullRunNoKey(Rno,Fno  :  Longint)  :  Str20;


Begin
  FullRunNoKey:=FullNomKey(Rno)+FullNomKey(Fno);
end;


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

{ ======== Procedure to Warn_Costings changed ======== }

Procedure Update_UpChange(NewNeed  :  Boolean);

Var
  Locked  :  Boolean;

Begin

  If (Syss.AutoBillUp) and (NewNeed<>Syss.NeedBMUp) then
  Begin
    Locked:=BOn;

    GetMultiSys(BOn,Locked,SYSR);

    Syss.NeedBMUp:=NewNeed;

    PutMultiSys(SysR,BOn);
  end;

end;




end. {BtSup1..}
