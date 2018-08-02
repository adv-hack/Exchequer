Unit ClubU;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$I DEFOVR.Inc}

{$O+,F+}

{**************************************************************}
{                                                              }
{         ====----> East Dorset Golf Club Ltd <----====        }
{                                                              }
{                      Created : 24/06/92                      }
{                                                              }
{                                                              }
{             Import via Club Systems Controller               }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

Interface

Uses
  GlobVar, VarConst, BTSupU1, BTKeys1U, CardProc, EXWrap1U, NeilProc, Dialogs, SysUtils
  , Forms, Controls, Progress, Windows;

Procedure Process_ClubFile(Mode  :  Byte);
{$IFDEF CS}
  Procedure Write_ClubFile(Mode  :  Byte);
  Procedure Process_ClubPayFile(Mode  :  Byte);
  Procedure Set_CSRead;
{$ENDIF}


Implementation
Uses
  {Crt, Dos, EWinSBS, ETPrompt, ETPrintU, ComnUnit, ComnU2, LedgerU, Utility, SysU1, }

  {$IFDEF CS}
    Club2000,
    Club2Exp,
  {$ENDIF}

  BtrvU2, ETMiscU, ETStrU, ETDateU, MainF;

Const

  ClubExpCode     =    'L2';  {* Memb Type for Expulsions *}
  ClubNewCode     =    'L1';  {* Memb Type for New / Ammendments *}
  TotClubFields   =    13;
  ClubFName       =    'Card.Dat';
  ClubAllName     =    'AllMem.Dat';
  DSoftName       =    'DSOFT.IMP';
  Club94Name      =    'FREEMF.DAT';
  Club94Lock      =    'LOCKON.DAT';
  Club94Change    =    'CHANGES.DAT';
  Club94Pay       =    'FREEPST.DAT';
  SBSSig          =    'S';
  CSNegCnst       =    64516;
  CSMaxCnst       =    32257;
  CSTitles        :    Array[0..9] of String[4] = (
                                                {0} '',
                                                {1} 'Mr',
                                                {2} 'Mrs',
                                                {3} 'Miss',
                                                {4} 'Ms',
                                                {5} 'Dr',
                                                {6} 'Rev',
                                                {7} 'Prof',
                                                {8} 'Sir',
                                                {9} 'Lady'
                                                   );
Type
  ImportRec  =  Record
                  MembCat  :  String[5];
                  CardNo   :  String[10];
                  Title    :  String[8];
                  FirstNm  :  String[10];
                  Surname  :  String[30];
                  Addr     :  AddrTyp;
                  Phone    :  String[25];
                  Fax      :  String[25];
                  Drange   :  Real;
                  Bal      :  Real;
                  ChrisNm  :  String[15];
                  DMembNo  :  String[5];
                  SpecTit  :  Boolean;
                  CSAddr   :  LongInt;
                  CSChange :  Boolean;
                end; {Rec..}

  ImportPayRec =  Record
                  DMembNo  :  String[5];
                  CSAddr   :  LongInt;
                  PayValue :  Real;
                end; {Rec..}

  DSoftRec  =  Record
                 MembNo    :  Array[1..4] of Char;
                 CardNo    :  Array[1..6] of Char;
                 MembName  :  Array[1..25] of Char;
                 SpecFlag  :  Char;
                 FullName  :  Array[1..30] of Char;
                 MembType  :  Array[1..2] of Char;
                 Addr      :  Array[1..4] of
                                Array[1..25] of Char;
                 TelHm     :  Array[1..14] of Char;
                 TelWk     :  Array[1..14] of Char;
                 CRLF      :  Array[1..2] of Char;
               end;

  Club94Rec  =  Record
           {001}  MembCode  :  Array[1..4] of Char;
           {005}  RecCount  :  Char;
           {006}  MembName  :  Array[1..20] of Char;
           {026}  Addr      :  Array[1..4] of
                                 Array[1..20] of Char;
           {106}  TelHm     :  Array[1..12] of Char;
           {118}  MemType   :  Char;
           {119}  JoinDate  :  Array[1..3] of Char;
           {122}  PayFlag   :  Array[1..3] of Char;
           {125}  Balance   :  Array[1..3] of Char;
           {128}  BillDate  :  Array[1..3] of Char;
           {131}  PaidDate  :  Array[1..3] of Char;
           {134}  Num1      :  Array[1..2] of Char;
           {136}  Birthdate :  Array[1..3] of Char;
           {139}  TitleCode :  Char;
           {140}  WorkPhone :  Array[1..12] of Char;
           {152}  Text1     :  Array[1..3] of
                                 Array[1..20] of Char;
           {212}  Flags     :  Array[1..10] of Char;
           {222}  SpouseInit:  Array[1..2] of Char;
           {224}  SpouseMTyp:  Char;
           {225}  FamInit2  :  Array[1..2] of Char;
           {227}  FamMTyp2  :  Char;
           {228}  FamInit3  :  Array[1..2] of Char;
           {230}  FamMTyp3  :  Char;
           {231}  FamInit4  :  Array[1..2] of Char;
           {233}  FamMTyp4  :  Char;
           {234}  FamInit5  :  Char;
           {235}  RecChange :  Char;
           {236}  FamMTyp5  :  Char;
           {237}  Num2      :  Array[1..2] of Char;
           {239}  Value1    :  Array[1..3] of Char;
           {242}  Value2    :  Array[1..3] of Char;
           {245}  Value3    :  Array[1..3] of Char;
           {248}  Date1     :  Array[1..3] of Char;
           {251}  Date2     :  Array[1..3] of Char;
           {254}  CRLF      :  Array[1..2] of Char;
                end;

  Club94PayRec  =  Record
              {001}  MembCode  :  Array[1..4] of Char;
              {005}  TitleCode :  Char;
              {006}  MembName  :  Array[1..20] of Char;
              {026}  Membtype  :  Char;
              {027}  DatePaid  :  Array[1..3] of Char;
              {030}  PayValue  :  Array[0..9] of
                                    Array[1..3] of Char;
              {060}  HedRecCnt :  Array[1..2] of Char;
              {062}  Spare     :  Array[1..7] of Char;
              {069}  RecLink   :  Array[1..2] of Char;
              {071}  CRLF      :  Array[1..2] of Char;
                   end;

Var
  ImpF : TextFile;
  ClubF : File of Club94Rec;
  ClubPayF : File of Club94PayRec;
  SuperIO : Integer;

{$IFDEF CS}

  { =========== Function to Convert Char Array to String ========= }
  Function Char_2Str(Var CharAry; SO : Integer) : Str255;
  Var
    TmpStr    :  Str255;
  Begin
    TmpStr:='';
    Move(CharAry,TmpStr[1],SO);
    TmpStr[0]:=Char(Ord(SO));
    Char_2Str:=Strip('B',[#32],TmpStr);
  end;{Func..}

  { =========== Function to Convert Char Array to String ========= }
  Function Char_2StrNP(Var CharAry; SO : Integer) : Str255;
  Var
    TmpStr    :  Str255;
  Begin
    TmpStr:='';
    Move(CharAry,TmpStr[1],SO);
    TmpStr[0]:=Char(Ord(SO));
    Char_2StrNP:=TmpStr;
  end;{Func..}

  { ========= Function to 'Modify Packed values... Substitute #10 for #254, #26 for #255 ======== }
  Function Pack_Subst(PackStr : Str255; UnPack : Boolean) : Str255;
  Const
    PackSubst  :  Array[1..2,FALSE..TRUE] of Char = ((#10,#254),(#26,#255));
  Var
    n         :  Byte;
    TmpStr    :  Str255;
  Begin
    TmpStr:=PackStr;
    n:=POS(PackSubst[1,UnPack],TmpStr);
    While (n<>0) do begin
      TmpStr[n]:=PackSubst[1,Not UnPack];
      n:=POS(PackSubst[1,UnPack],TmpStr);
    end;

    n:=POS(PackSubst[2,UnPack],TmpStr);

    While (n<>0) do begin
      TmpStr[n]:=PackSubst[2,Not UnPack];
      n:=POS(PackSubst[2,UnPack],TmpStr);
    end;

    Pack_Subst:=TmpStr;
  end; {Func..}

  { ======== Functions to pack/unpack CS Numbers ======= }
  Function Pack_Int(Inum : LongInt; PackLen : Byte) : Str5;
  Var
    C1,C2  :  LongInt;
    TmpStr :  Str5;
  Begin
    TmpStr:='';
    If (Inum<0) then Inum:=Inum+CSNegCnst;

    If (Inum<256) and (PackLen=1) then TmpStr:=Chr(Inum)
    else Begin
      C1:=Trunc(Inum/254);
      C2:=Inum-(C1*254);
      TmpStr:=Chr(C1)+Chr(C2);
    end;

    TmpStr:=Pack_Subst(TmpStr,FALSE);
    Pack_Int:=TmpStr;
  end; {Func..}


  Function UnPack_Int(PackStr : Str5; DecOn : Boolean) : LongInt;
  Var
    TmpInum,
    OPack      :  LongInt;
  Begin
    TmpInum:=0;
    PackStr:=Pack_Subst(PackStr,TRUE);
    If (Length(PackStr)>0) then Begin
      If (Length(PackStr)=1) then TmpInum:=Ord(PackStr[1])
      else Begin
        OPack:=Ord(PackStr[1]);
        TmpInum:=OPack*254;
        TmpInum:=TmpInum+Ord(PackStr[2]);
      end;

      If (TmpInum>CSMaxCnst) and (Not DecOn) then TmpInum:=TmpInum-CSNegCnst;
    end;
    UnPack_Int:=TmpInum;
  end; {Func..}

  { ======== Procedure to Update Input Checking Record ======== }
  Procedure Put_ImpCheck(DefNo : LongInt; ExLocal : TdExLocal);
  Var
    FileRec     :  Club94Rec;

    { ======== Procedure to Update CS Rec ======== }
    Procedure PutIFPos(Var CSRec  :  Club94Rec);
    Var
      n  :  Byte;

      { =========== Function to Convert Char Array to String ========= }
      Procedure Str2_Char(LStr : Str255; Var CharAry; SO : Integer);
      Var
        TmpStr    :  Str255;
      Begin{Str2_Char}
        TmpStr:=LJVar(LStr,SO);
        Move(TmpStr[1],CharAry,SO);
      end;{Str2_Char}

      Function Pack_Real(Rnum  :  Real)  :  Str5;
      Var
        DeNom,
        Frac    :  LongInt;
      Begin{Pack_Real}
        If (Rnum<0) then Rnum:=Rnum+CSNegCnst;
        DeNom:=Trunc(Rnum);
        Frac:=Round((Rnum-DeNom)*100);
        Pack_Real:=Pack_Int(DeNom,2)+Pack_Int(Frac,1);
      end;{Pack_Real}

    Begin{PutIFPos}
      With CSRec do begin
        Str2_Char(Pack_Int(IntStr(Strip('B',[#32],ExLocal.LCust.CustCode)),2),Num2,Sizeof(Num2));
        Str2_Char(Pack_Real(ExLocal.LCust.CurrBalance),Value2,Sizeof(Value2));
        For n:=1 to 4 do Str2_Char(ExLocal.LCust.Addr[n],Addr[n],Sizeof(Addr[n]));
        Str2_Char(ExLocal.LCust.Phone,TelHm,Sizeof(TelHm));
        Str2_Char(ExLocal.LCust.Fax,WorkPhone,Sizeof(WorkPhone));
        RecChange:=#32;
      end;
    end;{PutIFPos}

  Begin{Put_ImpCheck}
    {$I-}
    FillChar(FileRec,Sizeof(FileRec),0);
    Seek(ClubF,Pred(DefNo));
    If (IOResult=0) then
    Begin
      Read(ClubF,FileRec);  {* Get Disk Record *}
      If (IOREsult=0) then Seek(ClubF,Pred(DefNo));  {* Re-establish position, moved by read *}
      If (IOResult=0) then begin
        PutIFPos(FileRec);
        Write(ClubF,FileRec);
      end;
    end;

    Report_IOError(IOResult,Syss.MergePath+Club94Name);
    {$I+}
  end;{Put_ImpCheck}


  { =========== Procedure to Open the Club Systems File ============== }
  Procedure Open_ClubFile(Mode : Byte; Var TmpIO : Integer);
  Var
    FName : PathStr;
  Begin
    {$I-}
    FName:=Club94Name;
    AssignFile(ClubF, Syss.MergePath+FName);
    Reset(ClubF);
    TmpIO:=IOResult;
    {$I+}
  End;

  { ============== Close Club File ============= }
  Procedure Close_ClubFile(Mode  :  Byte);
  Begin
    {$I-}
    CloseFile(ClubF);
    {$I+}
  end;

  { =========== Procedure to Open the Club Systems File ============== }
  Function  FilePres(FName : PathStr) : Boolean;
  Var
    LockF  :  File of Char;
    TmpIO  :  Integer;
    TmpBo  :  Boolean;
  Begin
    Ch:=#0;
    AssignFile(LockF,FName);
    {$I-}
    Reset(LockF);
    TmpIO:=IOResult;
    If (TmpIO=0) then Read(LockF,Ch);
    If (IOResult=0) then;
    {$I+}
    TmpBo:=(TmpIO<>2);  {* File not Found *}
    If (TmpBo) then TmpBo:=(Ch<>SBSSig);{* If file present, then check if our own file!! *}
    SuperIO:=TmpIO;
    If (TmpIO=0) then CloseFile(LockF);
    FilePres:=TmpBo;
  end;

  Function  MakeFile(FName  :  PathStr)  :  Boolean;
  Var
    LockF  :  File of Char;
    TmpIO  :  Integer;
    TmpBo  :  Boolean;
    Ch     :  Char;
  Begin{MakeFile}
    AssignFile(LockF,FName);
    Ch:=SBSSig;
    {$I-}
    ReWrite(LockF);
    TmpIO:=IOResult;
    If (TmpIO=0) then Write(LockF,Ch);
    TmpIO:=IOResult;
    If (TmpIO=0) then CloseFile(LockF);
    TmpIO:=IOResult;

    {$I+}
    TmpBo:=(TmpIO=0);  {* File Created OK*}
    SuperIO:=TmpIO;
    MakeFile:=TmpBo;
  end;{MakeFile}


  Function  EraseFile(FName  :  PathStr)  :  Boolean;
  Var
    LockF  :  File;
    TmpIO  :  Integer;
    TmpBo  :  Boolean;
  Begin
    Begin
      AssignFile(LockF,FName);
      {$I-}
      Erase(LockF);
      TmpIO := IOResult;
      {$I+}
    end;
    TmpBo:=(TmpIO=0);  {* File Erase OK*}
    SuperIO:=TmpIO;
    EraseFile:=TmpBo;
  end;

  { =============== Process CDF ================== }
  Procedure Process_ClubFile(Mode  :  Byte);
  Var
    IOChk    :  Integer;
    ImpClub  :  ImportRec;
    CSRec    :  Club94Rec;
    CSLRecNo :  LongInt;
    FrmProgress : TFrmProgress;

    { ============== Procedure to Precess One Line from CDF ========= }
    Procedure Process_Field(CSRec : Club94Rec; RecNo : LongInt; Var ImpClub : ImportRec);
    Var
      Fno,
      LPos      :  Byte;
      FStr      :  Str255;
    Begin{Process_Field}
      Blank(ImpClub,Sizeof(ImpClub));
      With ImpClub do begin
        CardNo:=Form_Int(UnPack_Int(Char_2StrNP(CSRec.Num2,Sizeof(CSRec.Num2)),FALSE),0);
        LPos:=UnPack_Int(CSRec.TitleCode,FALSE);
        If (LPos In [0..9]) then Title:=CSTitles[LPos];
        For Fno:=1 to 4 do Addr[Fno]:=Char_2Str(CSRec.Addr[Fno],Sizeof(CSRec.Addr[Fno]));
        Phone:=Char_2Str(CSRec.TelHm,Sizeof(CSRec.TelHm));
        Fax:=Char_2Str(CSRec.WorkPhone,Sizeof(CSRec.WorkPhone));
        DMembNo:=Strip('B',[#26],Char_2Str(CSRec.MembCode,Sizeof(CSRec.MembCode)));
        FStr:=Char_2Str(CSRec.MembName,Sizeof(CSRec.MembName));
        LPos:=WordCnt(FStr);
        Surname:=ExtractWords(LPos,1,FStr);
        If (LPos>1) then FirstNm:=ExtractWords(1,Pred(LPos),FStr);
        CSChange:=(CSRec.RecChange='X');
        CSAddr:=RecNo;
      end; {With..}
    end;{Process_Field}

    { ============== Convert ImpClub to Cust format ============== }
    Procedure TxfrImp2Cust(ImpClub : ImportRec; Mode : Byte);
    Const
      Fnum     =  CustF;
      Keypath  =  CustCodeK;
    Var
      KeyS  :  Str255;
      n     :  Byte;
      COk, Abort, UpTill :  Boolean;
      ExLocal : TdExLocal;
      iStatus : smallint;
    Begin{TxfrImp2Cust}
      COk := FALSE;
      Abort := FALSE;
      UpTill := FALSE;

      ExLocal.Create;

      If (IntStr(ImpClub.CardNo)<>0) and (ImpClub.DMembNo<>'') then begin
        KeyS:=FullCustCode(ImpClub.CardNo);
        iStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath,KeyS);
{       With ExLocal.LCust do begin}
          COk := iStatus = 0;
          If (Not COk) then
            begin
              ExLocal.LResetRec(Fnum);
              { Bomb out if no more abs numbers are free }
              If Not CheckAbsFree Then Exit;
            End { If }
          else begin
            ExLocal.LGetRecAddr(CustF);
  {          ExLocal.AssignFromGlobal(CustF); {makes a local copy of the global variable}
  {         ExLocal.LGetRecAddr(CustF);}
          end;{if}
{        end;{with}
      end;{if}

      With ExLocal, LCust do begin
  {        OCust:=Cust;}

        CustCode:=FullCustCode(ImpClub.CardNo);
        Title:=ImpClub.Title;

        { MH 25/07/96: Changed for lowercase flag }
        FirstName:=ImpClub.FirstNm;
        If (Not Syss.ImpLowerCase) Then FirstName:=UpCaseStr(FirstName);

        ChrisName:=Copy(ImpClub.ChrisNm,1,11);

        { MH 25/07/96: Changed for lowercase flag }
        Company:=LJVar(ImpClub.Surname,SizeOf(ImpClub.Surname) - 1);
        If (Not Syss.ImpLowerCase) Then Company:=UpCaseStr(Company);

        ClubNo:=LJVar(ImpClub.DMembNo, SizeOf(ImpClub.DMembNo) -1);
        For n:=1 to 5 do Addr[n]:=ImpClub.Addr[n];
        Phone:=ImpClub.Phone;
        Fax:=ImpClub.Fax;
        SpecTit:=ImpClub.SpecTit;
        CSRecNo:=ImpClub.CSAddr;

        If (Not COk) then TillNo:=Get_NextTillNo(TRUE);

        Case Mode of
          2,4
               :   Begin
                     BBallBal:=ImpClub.DRange;
                     LastDisc:=Syss.MarkUp;
                     If (Mode=4) and (IntStr(ImpClub.CardNo)=0) and (Debug) then
                     Begin
                       CustCode:=FullCustCode(Form_Int(Syss.DummyFolio,0));
                       Inc(Syss.DummyFolio);
                       PutMultiSys;
                     end;
                   end;

          3    :   Begin
                     If (ImpClub.MembCat=ClubExpCode) then
                         Begin
                           Set_CustHold(ExLocal,2,Fnum,KeyPath,FALSE);
                           UpTill := TRUE;
                         end
                         else
                           If (ImpClub.MembCat=ClubNewCode) and (Hold>0) then
                           Begin
                             Cancel_Hold(ExLocal, Fnum,Keypath,FALSE);
                             UpTill := TRUE;
                           end;
                       end;

          7     :    Begin
                       UpTill:=TRUE;
                     end;

        end; {Case..}

        If (COk) then  {* See if record Changed *}
        Begin
          Abort:=((Not ImpClub.CSChange) and (Mode<>7));
        end;


        If (Not Abort) then begin
          If (COk) then iStatus:=Put_Rec(F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath)
          else iStatus:=Add_Rec(F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath);

          Report_BError(Fnum, iStatus);
          Put_ImpCheck(CSRecNo, ExLocal);  {* Mark CS Record as processed *}

          {$IFDEF ECR_On}
            If (iStatus = 0) then
            Begin
              ExLocal.LGetRecAddr(Fnum);
              If (Not UpTill) then Cust2Till(ExLocal.LCust{,COk,0});
              If (Mode In [2,4]) then PutECRBal(ExLocal.LCust,ImpClub.Bal,0);{ * Add opening balance to Till *}
            end; {If Ok..}
          {$ENDIF}
        end; {If Abort..}
      end; {With..}
      ExLocal.Destroy;
    end;{TxfrImp2Cust}

  Begin{Process_ClubFile}
    screen.cursor := crHourglass;
    SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);
    try
      FrmProgress := TFrmProgress.Create(Application);
      FrmProgress.Show;
      If (Not Syss.Club2000) Then
        Begin
          IOChk:=0;
          CSLRecNo:=0;
          if (Not FilePres(Syss.MergePath+Club94Lock)) then begin
            if (MakeFile(Syss.MergePath+Club94Lock)) then begin
              {$I-}
              IOChk:=SuperIO;
              if (IOChk=0) then Open_ClubFile(Mode,IOChk);

              if (IOChk=0) then begin
                FrmProgress.lStatus.Caption := 'Transferring Members From Membership System';
                Repeat
                  If (Not EOF(ClubF)) and (IOResult=0) and (TAsyncOk) then
                  Begin
                    Read(ClubF,CSREc);
                    Inc(CSLRecNo);
                    Process_Field(CSRec,CSLRecNo,ImpClub);
                    TxfrImp2Cust(ImpClub,Mode);
                    With ImpClub do FrmProgress.lName.Caption := Title + ' ' + FirstNm
                    + ' ' + Surname;
                  end; {If Ok to process..}
                Until (EOF(ClubF) or (IOResult<>0) or (Not TAsyncOk));
  {              FrmImportProgress.Hide;}
                Close_ClubFile(Mode);
              end; {If Ok..}

              {$I+}

              If (EraseFile(Syss.MergePath+Club94Lock)) then
              Begin
                GlobLocked := TRUE;
                GetMultiSys(TRUE,GlobLocked);
                Syss.UpRead := FALSE;
                PutMultiSys;
              end;{if}
            end;{if}
          end;{if}
        end
      else ImportClub2000; { Import from the Club 2000 file }
      FrmProgress.Close;
    finally
      FrmProgress.Release;
    end;{try}
    SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);
    screen.cursor := crDefault;
  end;{Process_ClubFile}

  { =============== Process CDF ================== }
  Procedure Write_ClubFile(Mode  :  Byte);
  Const
    Fnum     =  CustF;
    Keypath  =  CustEditK;
  Var
    IOChk    :  Integer;
    B_Func   :  Integer;
    KeyS     :  Str255;
    Ok : boolean;
    ExLocal : TdExLocal;
    iStatus : smallint;
    FrmProgress : TFrmProgress;
  Begin
    screen.cursor := crHourglass;
    If (Not Syss.Club2000) Then
      Begin
        IOChk:=0;
        KeyS:='';
{        B_Func:=B_GetGEq;}
        If (Not FilePres(Syss.MergePath+Club94Lock)) then begin
          If (MakeFile(Syss.MergePath+Club94Lock)) then begin
            {$I-}
            IOChk:=SuperIO;
                    If (IOChk=0) then Open_ClubFile(Mode,IOChk);

            If (IOChk=0) then begin
              SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);
              try
                FrmProgress := TFrmProgress.Create(application);
                FrmProgress.lStatus.Caption := 'Transferring Members to Membership System';
                KeyS:='';

                ExLocal.Create;

                iStatus := Find_Rec(B_GetGEq,F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath,KeyS);

                While (iStatus = 0) do begin
                  With ExLocal, LCust do begin
                    GlobLocked := FALSE;
                    Ok:=GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyPAth,Fnum,TRUE,GlobLocked);
                    LGetRecAddr(CustF);
                    If (Ok) and (GlobLocked) and (ChangeFlag=3) and (CSRecNo<>0) then
                      Begin
                        Put_ImpCheck(CSRecNo, ExLocal);  {* Mark CS Record as processed & Update *}
                        FrmProgress.lStatus.Caption := CardFullName(ExLocal.LCust,TRUE, TRUE);
                        ChangeFlag:=0;
                        iStatus:=Put_Rec(F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath);
                        Report_BError(FNum, iStatus);
                        B_Func:=B_GetGEq;
                      end
                    else B_Func:=B_GetNext;
                  end;{with}
                  iStatus:=Find_Rec(B_Func,F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath,KeyS);
                end; {While..}
                Close_ClubFile(Mode);
                FrmProgress.Close;
              finally
                FrmProgress.Release;
              end;{try}
              ExLocal.Destroy;
              SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);
            end;{if}

            {$I+}
            If (EraseFile(Syss.MergePath+Club94Lock)) then
            Begin
              GlobLocked:=TRUE;
              GetMultiSys(TRUE,GlobLocked);
              Syss.UpWrite := FALSE;
              PutMultiSys;
            end;
          end;
        end;
      End { If }
    Else ExportClub2000;{ Do the Export for Club 2000 }
    screen.cursor := crDefault;
  end;{Write_ClubFile}


  Procedure Set_CSRead;

    { ===== Function to see if changes made ====== }
    Function ClubChanges :  Boolean;
    Var
      TmpBo  :  Boolean;
    Begin
      TmpBo:=FilePres(Syss.MergePath+Club94Change);
      If (TmpBo) then TmpBo:=EraseFile(Syss.MergePath+Club94Change);
      ClubChanges:=TmpBo;
    end;

  Begin{Set_CSRead}
    GlobLocked:=TRUE;
    GetMultiSys(TRUE,GlobLocked);
    If (Not Syss.UpRead) then Begin
      If (Not Syss.Club2000) Then Syss.UpRead:=ClubChanges
      Else Syss.UpRead:=GotClubFile; { Check for CSCHANGE.DAT file in club directory }
    End; { If }
    PutMultiSys;
  end;{Set_CSRead}

  { =============== Process CDF ================== }
  Procedure Process_ClubPayFile(Mode  :  Byte);
  Var
    IOChk    :  Integer;
    ImpClub  :  ImportPayRec;
    CSRec    :  Club94PayRec;
    CSLRecNo, CSRecCount :  LongInt;
    ExLocal : TdExLocal;
    FrmProgress : TFrmProgress;

    { =========== Procedure to Open the Club Systems File ============== }
    Procedure Open_ClubPayFile(Mode : Byte; Var TmpIO : Integer);
    Var
      FName  :  PathStr;
    Begin
      FName:=Club94Pay;
      {$I-}
      AssignFile(ClubPayF,Syss.MergePath+FName);
      Reset(ClubPayF);
      {$I+}
      TmpIO:=IOResult;
    end;

    { ============== Close Club File ============= }
    Procedure Close_ClubPayFile(Mode  :  Byte);
    Begin
      {$I-}
      CloseFile(ClubPayF);
      If (IOResult=0) then;
      {$I+}
    end;

    { ============== Procedure to Precess One Line from CDF ========= }
    Procedure Process_PayField(CSRec : Club94PayRec; Var ImpClub : ImportPayRec);

      Function UnPack_Real(PackStr  :  Str5)  :  Real;
      Var
        DeNom,
        Frac,
        TStr    :   Str5;
        Rnum    :   Real;
      Begin
        Rnum:=0;
        If (Length(PackStr)=3) then Begin
          DeNom:=Copy(PackStr,1,2);
          Frac:=Copy(PackStr,3,1);
          TStr:=Form_Int(UnPack_Int(DeNom,TRUE),0)+'.'+Form_Int(UnPack_Int(Frac,TRUE),0);
          Rnum:=RealStr(TStr);
          If (Rnum>CSMaxCnst) then Rnum:=Rnum-CSNegCnst;
        end;
        UnPack_Real:=Rnum;
      end;{UnPack_Real}

    Begin{Process_PayField}
      Blank(ImpClub,Sizeof(ImpClub));
  {    LPos:=0;}
      With ImpClub do begin
        DMembNo:=Strip('B',[#26],Char_2Str(CSRec.MembCode,Sizeof(CSRec.MembCode)));
        CSAddr:=UnPack_Int(Char_2StrNP(CSRec.RecLink,Sizeof(CSRec.RecLink)),FALSE);
  {      If (Syss.CSValNo In [0..9]) then LPos:=Syss.CSValNo
        else LPos:=7;}
        PayValue:=UnPack_Real(Char_2StrNP(CSRec.PayValue[Syss.CSValNo],Sizeof(CSRec.PayValue[Syss.CSValNo])));
      end; {With..}
    end;{Process_PayField}

    { ============== Convert ImpClub to Cust format ============== }
    Procedure TxfrImp2Inv(ImpClub : ImportPayRec; Mode : Byte);
    Const
      Fnum     =  CustF;
      Keypath  =  CustClubK;
    Var
      KeyChk, KeyS  :  Str255;
      COk : Boolean;
      PostNet, PostVAT :  Real;
      iStatus : smallint;
    Begin{TxfrImp2Inv}
      COk := FALSE;
      PostVAT := 0;
      PostNet := 0;
      if (ImpClub.DMembNo<>'') then
{      with ExLocal.LCust do begin}
        KeyChk:=ImpClub.DMembNo;
        KeyS:=LJVar(KeyChk,SizeOf(KeyChk) - 1{Fpos[MemNo].Len});

        {* Search for Exact Card Record *}
        iStatus := Find_Rec(B_GetGEq,F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath,KeyS);

        While (iStatus= 0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),FALSE)) and (Not COk) do begin
          ExLocal.LGetRecAddr(FNum);
          COk := (ExLocal.LCust.CSRecNo = ImpClub.CSAddr);
          If (Not COk) then begin
            iStatus := Find_Rec(B_GetNext,F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath,KeyS);
{            ExLocal.AssignFromGlobal(CustF); {makes a local copy of the global variable}
{            ExLocal.LGetRecAddr(CustF);}
          end;{if}
        end; {While..}

        If (COk) and (ImpClub.PayValue<>0) then begin {* See if record Changed *}
          Gen_Inv(ExLocal,0,ImpClub.PayValue,0,0,PostNet,PostVAT,1, isUnknown);
          {* Do not add Nom Txfr, as assume income is going into accounts separately *}
        end;
{      end; {With..}
    end;{TxfrImp2Inv}

  Begin{Process_ClubPayFile}
    If (Not Syss.Club2000) Then Begin
      ExLocal.Create;
      IOChk:=0;
      CSLRecNo:=0;
      CSRecCount:=0;
      If (MakeFile(Syss.MergePath+Club94Lock)) then begin
        IOChk:=SuperIO;
        If (IOChk=0) then Open_ClubPayFile(Mode,IOChk);

        {$I-}
        If (IOChk=0) then Read(ClubPayF,CSRec);

        If (Not EOF(ClubPayF)) and (IOResult=0) and (IOChk=0) then begin
          CSRecCount:=UnPack_Int(Char_2StrNP(CSRec.HedRecCnt,Sizeof(CSRec.HedRecCnt)),FALSE);
{          If (SBSIn) then begin
            Writeln('** File count ',CSRecCount:0,' Last stored count ',Syss.CSLPayAddr:0);
          end;}

          If (CSRecCount<>Syss.CSLPayAddr) then begin
            If (CSRecCount<Syss.CSLPayAddr) then CSLRecNo:=2 {* Its a new file...} {* Start at record 2 *}
            else CSLRecNo:=Succ(Syss.CSLPayAddr); {* Start at next processed record *}

            SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);
            try
              FrmProgress := TFrmProgress.Create(application);
              FrmProgress.Show;
              FrmProgress.lStatus.Caption := 'Transferring Member Card Payments';
              Repeat
                If (Not EOF(ClubPayF)) and (IOResult=0) and (TAsyncOk) then begin
                  Read(ClubPayF,CSRec);
                  Process_PayField(CSRec,ImpClub);
                  TxfrImp2Inv(ImpClub,Mode);
                  Inc(CSLRecNo);
                  With ExLocal.LCust do FrmProgress.lName.Caption := Title + ' ' + FirstName + ' ' + Company;
                end; {If Ok to process..}
              Until (EOF(ClubPayF) or (IOResult<>0) or (Not TAsyncOk));
              FrmProgress.Close;
            finally
              FrmProgress.Release;
            end;{try}
            SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);
            Close_ClubPayFile(Mode);
          end; {If Ok..}
        end;

        {$I+}

        If (EraseFile(Syss.MergePath+Club94Lock)) then
        Begin
          GlobLocked:=TRUE;
          GetMultiSys(TRUE,GlobLocked);
          If (CSLRecNo>0) then
          With Syss do begin
            UpPost := FALSE;
            If (CSLRecNo>CSRecCount) then CSLPayAddr:=CSRecCount
            else CSLPayAddr:=CSLRecNo;
          end;
          PutMultiSys;
        end;
      end;
      ExLocal.Destroy;
    End; { If }
    screen.cursor := crDefault;
  end;{Process_ClubPayFile}

{$ELSE}

  { West Hills } {WH}

  { =============== Process CDF ================== }
  Procedure Process_ClubFile
  (Mode  :  Byte);
  Var
    LineTxt  :  Str255;
    IOChk    :  Integer;
    ImpClub  :  ImportRec;
    ExLocal : TdExLocal;
    FrmProgress : TFrmProgress;

    { ============== Procedure to Precess One Line from CDF ========= }
    Procedure Process_Field(LineTxt : Str255; Var ImpClub : ImportRec);
    Var
      LineLen,
      Fno,
      CurPos,
      LPos      :  Byte;
      SearchStr,
      FStr      :  Str255;

      Procedure SetImpRec(FStr : Str255; Fno : Integer; Var ImpClub : ImportRec);
      Var
        Idx  :  Byte;

        { ========= Convert Odd Club -ve Handling ========= }
        Function SetClubReal(CBal  :  Str20)  :  Real;
        Var
          Dcnst  :  Integer;
        Begin
          If (Pos('-',CBal)<>0) then DCnst:=-1
          else DCnst:=1;
          SetClubReal:=Round_Up(RealStr(Strip('A',['-'],CBal))*DCnst,2);
        end;{SetClubReal}

      Begin{SetImpRec}
        With ImpClub do
        Case Fno  of
          1  :  MembCat:=FStr;
          2  :  CardNo:=FStr;
          3  :  Begin
                  Title:=ExtractWords(1,1,FStr);
                  FirstNm:=ExtractWords(2,Pred(WordCnt(FStr)),FStr);
                end;
          4  :  Surname:=FStr;

          5..8
             :  Begin
                  Idx:=Fno-4;
                  Addr[Idx]:=FStr;
                end;
          9  :  Phone:=FStr;
          10 :  Fax:=FStr;
          11 :  DRange:=SetClubReal(FStr);
          12 :  Bal:=SetClubReal(FStr);
          13 :  ChrisNm:=Copy(FStr,1,Pred(Sizeof(ChrisNm)));
        end; {Case..}
      end;{SetImpRec}

    Begin{Process_Field}
      Blank(ImpClub,Sizeof(ImpClub));
      Fno:=1;
      {CurPos:=0;}  LPos:=0;
      LineLen:=Length(LineTxt);
      If (LineLen>0) then
      Repeat
        SearchStr:=Copy(LineTxt,Succ(LPos),(LineLen-LPos));
        CurPos:=Pos(',',SearchStr);
        FStr:=Strip('B',[',','"',#32],Copy(SearchStr,1,CurPos));
        SetImpRec(FStr,Fno,ImpClub);
        Inc(Fno);
        LPos:=LPos+CurPos;
      Until (Fno>TotClubFields) or (SearchStr='') or (Succ(LPos)>=LineLen);
    end;{Process_Field}

    { ============== Convert ImpClub to Cust format ============== }
    Procedure TxfrImp2Cust(ImpClub : ImportRec; Mode : Byte);
    Const
      Fnum     =  CustF;
      Keypath  =  CustCodeK;
    Var
      KeyS  :  Str255;
      n     :  Byte;
      COk, Abort, UpTill :  Boolean;
    Begin{TxfrImp2Cust}
      COk := FALSE;
      UpTill := FALSE;
{      ExLocal.Create;
      ExLocal.AssignFromGlobal(CustF); {makes a local copy of the global variable}
{      ExLocal.LGetRecAddr(CustF);}

      With ExLocal.LCust do begin
        If (ImpClub.CardNo<>'0') then begin
          KeyS := FullCustCode(ImpClub.CardNo);
          iStatus := Find_Rec(B_GetEq,F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath,KeyS);
          COk := iStatus = 0;
        end;

        Abort:=(ImpClub.CardNo='9999'); {* Ignore maintenence Member *}

        If COk then LGetRecAddr(CustF)
        else LResetRec(Fnum);

        CustCode:=FullCustCode(ImpClub.CardNo);
        Title:=ImpClub.Title;
        FirstName:=UpCaseStr(ImpClub.FirstNm);
        ChrisName:=Copy(ImpClub.ChrisNm,1,11);
        Company:=LJVar(UpCaseStr(ImpClub.Surname),SizeOf(ImpClub.Surname) - 1{Fpos[CompNo].Len});
        ClubNo:=Copy(ExtractWords(1,1,FirstName),1,1)+Copy(Company,1,3);

        For n:=1 to 4 do Addr[n]:=ImpClub.Addr[n];

        Phone:=ImpClub.Phone;
        Fax:=ImpClub.Fax;

        If (Not COk) then TillNo:=Get_NextTillNo;

        If (ImpClub.CardNo='0') and ((Mode In [3,7]) or ((Mode In [4,2]) and (Not Debug))) then begin
          MsgBox('Member : '+FirstName+' '+Company+' has no card number' + CHR(13)
          + 'This member will not be added to the tills.' + CHR(13)
          + 'Please return to Club Systems and correct.' ,mtWarning,[mbOK],mbOK,'Add Member');
          Abort := TRUE;
        end;

        Case Mode of
          2,4
               :   Begin
                     BBallBal:=ImpClub.DRange;
                     LastDisc:=Syss.MarkUp;
                     If (Mode=4) and (ImpClub.CardNo='0') and (Debug) then
                     Begin
                       CustCode:=FullCustCode(Form_Int(Syss.DummyFolio,0));
                       Inc(Syss.DummyFolio);
                       PutMultiSys;
                     end;
                   end;

          3    :   Begin
                     If (ImpClub.MembCat=ClubExpCode) then
                         Begin
                           Set_CustHold(ExLocal, 2, Fnum, KeyPath, FALSE);
                           UpTill := TRUE;
                         end
                         else
                           If (ImpClub.MembCat=ClubNewCode) and (Hold>0) then
                           Begin
                             Cancel_Hold(ExLocal, Fnum, Keypath, FALSE);
                             UpTill := TRUE;
                           end;
                       end;

          7     :    Begin
                       UpTill := TRUE;
                     end;
        end; {Case..}


        If (Not Abort) then begin

          If (COk) then iStatus:=Put_Rec(F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath)
          else iStatus:=Add_Rec(F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypath);

          Report_BError(FNum, iStatus);

        {$IFDEF ECR_On}
          If (iStatus = 0) then begin
            ExLocal.LGetRecAddr(FNum);
            If (Not UpTill) then Cust2Till(ExLocal.LCust{,COk,0});
            If (Mode In [2,4]) then PutECRBal(ExLocal.LCust,ImpClub.Bal,0);{* Add opening balance to Till *}
          end; {If Ok..}
        {$ENDIF}
        end; {If Abort..}
      end; {With..}
    end;{TxfrImp2Cust}

    { =========== Procedure to Open the Club Systems File ============== }
    Procedure Open_ClubFile(Mode : Byte; Var TmpIO : Integer);
    Var
      FName  :  PathStr;
      sFileName : string;
    Begin{Open_ClubFile}
      If (Mode In [2,4,7]) then FName:=ClubAllName
      else FName:=ClubFName;

      AssignFile(ImpF,Syss.MergePath+FName);
      {$I-}
      Reset(ImpF);
      TmpIO:=IOResult;
      {$I+}
    end;{Open_ClubFile}

    { ============== Close Club File ============= }
    Procedure Close_ClubFile(Mode  :  Byte);
    Begin{Close_ClubFile}
      {$I-}
      CloseFile(ImpF);
      {$I+}
      If (IOResult=0) and (Mode=3) then Erase(ImpF);
      If (IOResult=0) then;
    end;{Close_ClubFile}

  Begin{Process_ClubFile}
    screen.cursor := crHourglass;
    SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);
    ExLocal.Create;
    try
      FrmProgress := TFrmProgress.Create(application);
      FrmProgress.Show;

      {$I-}
      IOChk:=0;
      LineTxt:='';
      Open_ClubFile(Mode,IOChk);
      If (IOChk=0) then begin
        FrmProgress.lStatus.Caption := 'Transferring Members from Club Systems';
        Repeat
          If (Not EOF(ImpF)) and (IOResult=0) and (TAsyncOk) then
          Begin
            ReadLn(ImpF,LineTxt);
            If (LineTxt<>'') then begin
              Process_Field(LineTxt,ImpClub);
              TxfrImp2Cust(ImpClub,Mode);
            end;

            With ImpClub do FrmProgress.lName.Caption := Title+' '+FirstNm+' '+Surname;
          end; {If Ok to process..}
        Until (EOF(ImpF) or (IOResult<>0) or (Not TAsyncOk));
        Close_ClubFile(Mode);
        FrmProgress.Close;
      finally
        FrmProgress.Release;
      end;{try}
    end; {If Ok..}
    ExLocal.Destroy;
    SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);
    screen.cursor := crDefault;
    {$I+}
  end;{Process_ClubFile}
{$ENDIF}

Begin
  SuperIO:=0;

end.
