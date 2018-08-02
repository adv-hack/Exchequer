Unit ExpClock;

This unit needs to be converted to be SQL-compatible. It is calling Erase to
delete the swap file -- this must be replaced with SQLUtils.DeleteTable.

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Trans\Document.Dat + Details.Dat + Jobs\JobMisc.Dat -> ClockIn }
{* Export Job Costing Time Sheet Data for Earnie Payroll System *}
{* Options - Wk/Mth No or TSH No Range *}
{* Ex.PayRollNo is Earnie's EmployeeCode *}
{* Validation - Emplyee's Code must be valid, Payroll No must not be blank. *}


Interface

type
  TExportType  = (Clock1,Clock2);


Procedure ExportClockIn(ExportType : TExporttype);

Procedure Show_Log;

{ ================================== }
Implementation
{ ================================== }

Uses

  Crt,
  Dos,
  BTRVU2,
  ETStru,
  GlobVar,
  ComnUnit,
  ComnU2,
  VarConst,
  ETools2,
  ExAsvarU,
  EWinSBS,
  ETMiscU,
  SysU1,
  ETDateU,
  ETPrintU,
  MpMenuU,
  ETPrompt,
  ExLinkU,
  ExLinkU2;

   {$I ExpClock.Inc}

Const

  TFileNam  =  '$ClockIn.SWP';  {Temp.File}

  LFileNam  =  'Export.Log';    {Log File}

  ClockNam  =  'CLOCKIN';       {Payroll's file name}

  WarnType  :  Array[Off..On] of String[10] = ('WARNING! :','ERROR! ..:');

Type

  Str9 = String[9];

Var

  ClockInRec   : ClockInType;
  ClockInFile  : ClockIn_FileDef;

  Choice,
  Status       : Integer;

  Ch,AddCh     : Char;
  KeyF         : String;
  Elded        : Boolean;

  LFile        : Text;


{ ======= Define Temp. File Definition for Employee Code Index ======= }

Procedure DefineClockIn;

Const
  Idx = ClockInF;


Begin
  With ClockInFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(ClockInFile);       { <<** Change }
    Fillchar(ClockInFile,FileSpecLen[Idx],0);    { <<** Change }
    RecLen:=Sizeof(ClockInRec);                  { <<** Change }
    PageSize:=DefPageSize;
    NumIndex:=ClNofKeys;                         { <<** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}


    { 00 -  EmplCode+Rate (ECodeRateK)  }              { <<** Change }

    KeyBuff[1].KeyPos:=2;
    KeyBuff[1].KeyLen:=10;
    KeyBuff[1].KeyFlags:=DupModSeg;

    KeyBuff[2].KeyPos:=12;
    KeyBuff[2].KeyLen:=02;
    KeyBuff[2].KeyFlags:=DupMod+ExtType;
    KeyBuff[2].ExtTypeVal:=BInteger;


    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}

  FileRecLen[Idx]:=Sizeof(ClockInRec);                      { <<** Change }

  Fillchar(ClockInRec,FileRecLen[Idx],0);                   { <<** Change }

  RecPtr[Idx]:=Ptr(Seg(ClockInRec),Ofs(ClockInRec));        { <<** Change }

  FileSpecOfs[Idx]:=Ptr(Seg(ClockInFile),Ofs(ClockInFile)); { <<** Change }

  FileNames[Idx]:=TFileNam;                           { <<** Change }

end; {..}

{ ---------------------------------------------- }
Function SetValidFlag(WErrOn,
                      WarnEr,
                      SetValid  :  Boolean)  :  Boolean;

Begin

  If (SetValid) and (WarnEr) then {* Only set Total Failure of error, not warning *}
    SetValidFlag:=WErrOn
  else
    SetValidFlag:=SetValid;

end;

{ ---------------------------------------------- }

Procedure Write_ErrorLog(WErrOn  :  Boolean;
                         ErrMsg  :  Str255);
Begin

  If (Not WErrOn) then
  Begin
      {$I-}
        WriteLn(LFile,ErrMsg);
      {$I+}
  end;
end;
{ ---------------------------------------------- }

Procedure Warn_ExpDoc(WErrOn,
                      WarnEr  :  Boolean;
                      DocRef  :  Str10;
                      Reason  :  Str255;
                  Var SetValid:  Boolean);
Begin

  Write_ErrorLog(WErrOn,Concat(WarnType[WarnEr],LJVar(DocRef,Succ(ExDocLen)),
                                   ' ',Reason));

  SetValid:=SetValidFlag(WErrOn,WarnEr,SetValid);

end;

{ ---------------------------------------------- }
Function FullJBCode(JC     :  Str10;
                    Curr   :  Byte;
                    SCode  :  Str20)  :  Str30;

Begin
    FullJBCode := LJVar(JC,ExLenJob)+LJVar(SCode,ExLenStk)+Chr(Curr);
end;

{ ---------------------------------------------- }

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

  TmpK:=TmpPrefix+SetPadNo(TmpNo,(Fpos[IKNo].Len-LenPreFix));

  AutoSetInvKey:=LJVar(TmpK,Fpos[IKNo].Len);

end; {Function..}


{ ========= Proc to Show Log file after rebuild ========= }

Procedure Show_Log;

Var
  Abort  :  Boolean;

  TextLn :  Str255;


Begin

  Abort:=Off;

  {$I-}

  Assign(LFile,LFileNam);

  Reset(LFile);

  If (IOResult=0) then
  Begin
    Print_Controller; {in ETPrintU}

    If (Addch<>Esc) then
    Begin

      ReadLn(LFile,TextLn);

      While (IOResult=0) and (Not Abort) and (PrntOk) do
      Begin

        Abort:=EOF(LFile);

        Stppout(PrntOk);

        PrintLn(TextLn);

        ReadLn(LFile,TextLn);

      end; {While..}

      Print_EndControl;

    end; {If Abort..}

    Close(LFile);

    If (IOResult=0) then;

    {$I+}

  end; {If No file found..}

end; {Proc..}



{ ========= Start of ExportClockIn ============= }

Procedure ExportClockIn(ExportType : TExporttype);

Const
   TLen     = 10;

   PayIdent = 20;  {Payroll's constant field}

   Term : CharSet = StdInputSet;

   ExpW : Windx = (15,15,55,9,Ord(MPLoCol),0,1);


Var
   TestFile,
   OFile        : Text;

   TLookKey     : String[19];

   TEmplCode,
   TEmplCodeK,
   TPayNo       : String[10];

   FrTSH,ToTSH,
   TOurRef      : Str9;

   TEmpName,
   LName,
   FName        : String[30];

   TRateAmt,
   TotalHour    : Real;

   TRate,
   TIdentifier,
   TDiscDays,
   WkMthNo      : Integer;

   TmpStr       : String;


   EarnieYN     : Boolean;

   TC,TCh       : Char;

   WkCheck,
   DispLog,
   GlobLocked,
   UpStatus,
   ErCheck,
   ValidHed,
   RLock,
   ValidCheck   : Boolean;

   TimeR        : TimeTyp;

{ ---------------------------------------------- }

Function Open_TmpFile : Boolean;
{* Make & Open BTrieve Temp. File *}

Const

  Fnum  = ClockInF;

Begin

  Status:=Make_File(F[Fnum],FileNames[Fnum],FileSpecOfs[Fnum]^,FileSpecLen[Fnum]);
  Status:=Open_File(F[Fnum],FileNames[Fnum],0);

  If Status<>0 then
     Status_Means(Status);


  Open_TmpFile:=(Status=0);

end;

{ ---------------------------------------------- }

Function Open_TxFile(Var TxFile : Text;
                     Var TxFName: String) : Boolean;
{* Open Text File *}

Var
  TmpIO : Integer;

Begin

  TmpIO:=0;

  {$I-}

  Assign(TxFile,TxFName);  {Clockin file}
  Rewrite(TxFile);

  TmpIO:=IOResult;

  If TmpIO<>0 then
     Report_IOError(TmpIO,TxFName);

  {$I+}

  Open_TxFile:=(TmpIO=0);

end;

{ ---------------------------------------------- }

Procedure Init_ErLog;

Begin

    Write_ErrorLog(Off,'Exchequer Time Sheet Export Log File. (c) IRIS Enterprise Software. '
                     +POutDate(Today)+', '+CurrTimeStr(TimeR));

    Write_ErrorLog(Off,ConstStr('-',80));
    Write_ErrorLog(Off,'');

end;

{ ---------------------------------------------- }

Procedure TSHRange(Var TSHNo : Str9;
                   Var LNo   : Integer);

{* Accept and Display From and To TSH Number *}
Begin

  ProcessInput(TSHNo,fpos[LNo],Term,Tc);

  if (Tc<>Esc) then
  begin

    TSHNo:=AutoSetInvKey(TSHNo,LNo);  {* convert Capital and fill up 0 *}

    ProcessOutput(TSHNo,fpos[LNo]);

  end;

end;


{ ---------------------------------------------- }
Procedure DisplayScreen;
{* Display Screen, get default data from ESys file and Accept Data *}

Const

  DLen     = 6; {for TSH no.}
  ConstTSH = 'TSH';
  Const99  = '999999';

Var
  I,L     : Integer;

  TStr    : String;

  OutNo   : LongInt;

begin

    {* Display Screen *}
    For i:=StartF to EndF do begin
      With FPos[i] do begin
          GotoXy(Fx,Y); Write(Ftxt(i));
      end;
    end;


    {* Check System file to get default fields *}
    ValidCheck:=(CheckRecExsists(SysNames[JobSR],ESysF,SysK));
    If (ValidCheck) then
    begin

      With ESyss.JobSet do
      begin

         ToTSH:=JTSHNoT;
         WkMthNo:=JWkMthNo;
         FName:=JFName;

      end;
    end;


    {* Default.Fr.No=last To No.+1, To.No=999999 *}

    TmpStr:=copy(ToTSH,4,DLen);   {copy fr. last To TSHxxxxxx}
    Val(TmpStr,OutNo,i);          {convert xxxxxx as Value}
    Inc(OutNo);                   {increase Number}
    Str(OutNo:0,TmpStr);          {convert back to String}
    Tstr:=SetPadNo(TmpStr,DLen);  {add 0 infront - SetPadNo - in ETStru.PAS}

    FrTSH:=ConstTSH+TStr;

    ToTSH:=ConstTSH+Const99;

    L:=StartF;

    TextColor(14);
    {TextBackGround(LightRed);}

    TStr:='';

    {* Display default fields *}
    For L:=StartF to EndF do
    begin
      Case L of
        XTSHSNo   :  TStr:=FrTSH;
        XTSHENo   :  TStr:=ToTSH;
        XWkMnNo   :  Move(WkMthNo,TStr,Sizeof(WkMthNo));
        XEarnNo   :  TStr:='Y';
        XFNamNo   :  Tstr:=FName;
      end;

      ProcessOutput(TStr,fpos[L]);

    end;


    L:=StartF;

    {* Accept Data *}
    Repeat

      Case L of
        XTSHSNo   :  TSHRange(FrTSH,L);

        XTSHENo   :  TSHRange(ToTSH,L);

        XWkMnNo   :  ProcessInput(WkMthNo,fpos[L],Term,Tc);

        XEarnNo   :  ProcessInput(EarnieYN,fpos[L],Term,Tc);

        XFNamNo   :  begin
                       ProcessInput(FName,fpos[L],Term,Tc);
                       If (FName='') then FName:=ClockNam;
                     end;
      end;

      L:=Inp_Loop(L,StartF,EndF,Tc);  {* increase L and loop *}

      If ((L=StartF) and (Tc=^M)) then Tc:=F9; {* exit after last field *}

    Until (Tc in [Esc,F9]);
end;


(* ex code *)
procedure GetEqualJoin;
begin
  getfirst(Site,sitekey);
  while getNext(Company,SiteKey) do
  begin
    doSomething(SiteRec,CompanyRec);
  end;
end;



Procedure SetValue(var ClckRecord : ClockInType);
begin

 with ClckRecord do
 case TypeOfEntry of

  Hours :       begin
                  str(NoHour*10:10,value[1]);  {hours * 10}
                  str(Rate:10,Value[2]);{existing rate Number}
                  Str(Factor:10,Value[3]);{factor number}

                end;

  Adjustments : begin
                  str(Payment/Deduction:10,value[1]);
                  str(Payment/AmntAgstDec:10,value[2]);
                  Value[3] := '';

                end;

  Salary      : begin
                  (*
                  Value[1] :=
                  Value[2] :=
                  Value[3] :=
                  *)
                end;

  PSP         : begin
                  (*
                  Value[1] :=
                  Value[2] :=
                  Value[3] :=

                end;

  SMP         : begin
                  (*
                  Value[1] :=
                  Value[2] :=
                  Value[3] :=
                  *)
                end;

 end;

end;



{ ---------------------------------------------- }

Procedure WriteToFile;
{* from Temp. file to Text file *}
Const
  Fnum    = ClockInF;
  Keypath = ECodeRateK;
begin
  Status:=Find_Rec(B_GetFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyF);
  While (Status=0) Do
  Begin

    TEmplCode  := ClockInRec.EmplCode;

    TRate      := ClockInRec.Rate;       {  1 to 12 }

    {* 13.08.99 - modified for CMS Business - NZ *}
    If (EarnieYN) then
      TIdentifier:= (TRate+PayIdent)      { 21 to 32 }
    else
      TIdentifier:=TRate;

    TRateAmt   := (TRate*100);           { (1 to 12)*100 }

    TotalHour  := 0;

    {* to calculate total # of hours per employee per rate *}
    While (Status=0) and (ClockInRec.EmplCode=TEmplCode) and (ClockInRec.Rate=TRate) do
    begin

      TotalHour:=TotalHour+ClockInRec.NoHour; {Total # Hrs per rate per employee}

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyF) ;


    end;

    SetValue(ClockInRec);


    TEmplCode:=LJVar(TEmplCode,TLen);


    if ExportType = clock1 then
    begin
      Writeln(Ofile,TEmplCode:10,TRate:2,TotalHour:10:2); {Factor & Total Time}
      Writeln(Ofile,TEmplCode:10,TIdentifier:2,TRateAmt:10:2); {Rate Code and Std.Code}
    end
    else
    begin
      Writeln(Ofile,TEmplCode:10,TRate:2,TotalHour:10:2); {Factor & Total Time}
      Writeln(Ofile,TEmplCode:10,TIdentifier:2,TRateAmt:10:2); {Rate Code and Std.Code}

    end
  End; {while status=0 of OFile }


end;

{ ---------------------------------------------- }
Procedure UpdateDefault;
{* Update criteria fields into ESysF file. *}

Begin

  If ((Not ErCheck) and (TmpStr<>'')) then
  begin

    RLock:=On;
    EGetMultiSys(Off,RLock,JobSR);  {* Lock the record - in ExLinkU.Pas *}

    If (RLock) then
    begin

      With SyssJob.JobSetUp do
      begin
        JTSHNoF:=FrTSH;
        JTSHNoT:=TmpStr;
        JWkMthNo:=WkMthNo;
        JFName:=FName;
      end;

      EPutMultiSys(JobSR,RLock);    {* Update *}

    end;
  end;  {not ercheck..}

end;

{ ---------------------------------------------- }

Procedure CloseFiles;
{* Close Ex. files, Temp. file and delete Temp. file *}

Var
  I     : Integer;

begin

  For i:=ExFileStart to (ExFileEnd+1) do begin
    Status:=Close_File(F[i]);
  end;

  {$I-}

  Assign(LFile,TFileNam);  {Temp.File}
  Erase(LFile);

  {$I+}

end;

{ ---------------------------------------------- }

Procedure WarnErMsg;
{* Warning to check Log file *}

Begin

  DispLog:=Off;

  If (ErCheck) then
  begin

    Write_ErrorLog(Off,'');
    Write_ErrorLog(Off,'Records marked with an ERROR! not processed.');

    PopShadw(PopGenW);
    WriteCtrPop(2,PopGenW,'Validation errors found!');
    WriteCtrPop(4,PopGenW,'Please Look at the Log File : '+LFileNam);
    WriteCtrPop(PopGenW[4],PopGenW,' <Space> to Continue ');
    TCh:=ReadKey;
    RmWin;
    DispLog:=On;
  end
  else
  begin
    Write_ErrorLog(Off,'');
    Write_ErrorLog(Off,'All records processed.');
  end;

  Write_ErrorLog(Off,ConstStr('-',80));

end;


{ ---------------------------------------------- }


{* Validate Tran.Lines (Details.Dat) and Empl.Pay Rate in JCtrlF and
   Write into Temp.File *}

Procedure ValidLines(TEInv : EInvRec);

Const

  Fnum    = EIdetailF;
  KeyPath = EIdFolioK;

Var

  TmpBudg : String[27];

Begin

  With TEInv do
  begin

    { Header's Folio No. is the key to find the records in DETAILS.DAT }

    KeyF:='';
    KeyF:=FullNomKey(FolioNum);


    Status:=Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyF);


    While ((Status=0) and (FolioNum=EId.FolioRef)) do
    begin

      With EId do
      begin

        {* Check Empl.Pay Rate in JCtrlF File & write into Temp. file *}

        TmpBudg := FullJBCode(FullNomKey(-1),Currency,StockCode);

        ValidCheck:=((CheckRecExsists(JBRCode+JBECode+TmpBudg,JCtrlF,JCK)));

        {* Pay Rate must be 1-10 for Earnie Import *}


        If (ValidCheck) then
        begin

          {* 11.08.99 - allow to export PayRate code 0..99 if Earnie YN = N *}
          ValidCheck:=(Not EarnieYN);

          If (Not ValidCheck) then
            ValidCheck:=(EJobCtrl.EmplPay.PayRRate In [1..10]);

        end;


        If (Not ValidCheck) then
          ClockInRec.Rate:=0
        else
        begin

          ClockInRec.Rate:=EJobCtrl.EmplPay.PayRRate;  {* Pay Rate *}

          ClockInRec.EmplCode:=LJVar(TPayNo,TLen);     {* Payroll No *}

          ClockInRec.NoHour:=(Qty*100);                {* # of Hours *}

          {note by DS, set the other fields for the Job Card Import Earnie32}
          {at the moment not 100% sure what these values are though}

          (*
          ClockInRec.AccountGroup   :=
          ClockInRec.AnalysisString :=
          ClockInRec.Period         :=
          ClockInRec.TypeOfEntry    :=
          ClockInRec.Values         :=
          *)

          {
          ClockInRec.TSHNo:=OurRef;
          ClockInRec.StockCode:=StockCode;
          }

          { Add the record in Temp. Btrieve File }

          Status:=Add_Rec(F[ClockInF],ClockInF,RecPtr[ClockInF]^,0) ;

        end;

        Warn_ExpDoc(ValidCheck,On,OurRef,'Pay Rate not valid for Rate Code - '+LJVar(StockCode,TLen),ValidHed);

      end; {with EId..}

      { Find next details record }

      Status:=Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyF);

    end; {while (EInv.FolioNum=Id.FolioRef) ..}

  end; {with TEInv..}


end; {ValidLines..}



{* ------- Start of Main ExportClockIn ------------- *}

Begin

    OffCursor;


    GetCurrTime(TimeR);  { Get current time }

    { Set the colours for screen }
    SetBorder(LightGray);
    SetCol(White,White);
    PopShadW(ExpW);
    ClrMScr(ExpW,MonCh);


    { Debug is defined in Debug.INC file for internal debug mode }
    If (Debug) then
      Process_File(SetupFN); { to get the Enterprise path }


    {* Open Exchequer Btrieve data files.
       \Exchdev3\Exlink\ExlinkU.Pas  *}

    If (Debug) then
      Open_ExSystem(ExFileStart,ExFileEnd,Syss.ExPath)
    else
      Open_ExSystem(ExFileStart,ExFileEnd,'');


    {* Display screen and Accept user's options *}
    DisplayScreen;


    RmWin;
    PopUp(ScandW);
    WriteCtrPop(2,ScandW,'Please Wait...');


    TmpStr:='';

    ErCheck:=Off;

    LName:=LFileNam;

    {* Define Temp. file $CLOCKIN.SWP *}
    DefineClockIn;


    {* Open Tmp.file *}

    ValidCheck:=Open_TmpFile;


    If (Tc<>Esc) and (ValidCheck) then
    begin

      {* Open "CLOCKIN" Text file *}

      ValidCheck:=Open_TxFile(OFile,FName);

      {* Open Error Log file, "EXPORT.LOG" *}

      If (ValidCheck) then
        ValidCheck:=Open_TxFile(LFile,LName);


      If (ValidCheck) then
      begin

        {* Initialize Headings, etc., in the Error Log File *}
        Init_ErLog;


        { To search the TSH record in the Transaction Header file,
          Enterprise's \Trans\DOCUMENT.DAT (EInvF)
          according to the FROM TSH No. defined by the user }

        KeyF:=FrTSH; { Search Key }

        { EInvOurRefK = Index by Our Ref field }

        Status:=Find_Rec(B_GetGEq, F[EInvF], EInvF, RecPtr[EInvF]^, EInvOurRefK, KeyF);

        { Check Trans. Type and OurRef No. against From OurRef No }

        While ((Status=0) and (EInv.InvDocHed=TSH) and ((EInv.OurRef>=FrTSH) and (EInv.OurRef<=ToTSH))) do
        begin

           ValidCheck:=On;

           WkCheck:=On;

           ValidHed:=On;

           With EInv do {invoice record}
           begin

             TmpStr:=OurRef;

             {* Check for Week/Month No if entered *}
             If (WkMthNo<>0) then
               WkCheck:=(DiscDays=WkMthNo) ;

             If (WkCheck) then
             begin

                {* for Employee Code Index Key *}

                TEmplCodeK:=BatchLink;  { Inv.BatchLink = EmployeeCode }
                TEmplCode:=(LJVar(TEmplCodeK,TLen));

                TPayNo:=#0;
                TEmpName:=#0;

                {* Check Employee Code in JMiscF File *}

                ValidCheck:=(CheckRecExsists(JARCode+JAECode+TEmplCodeK,JMiscF,JMK));
                                            {RecPFix+SubType+EmplCode}

                Warn_ExpDoc(ValidCheck,On,OurRef,TEmplCode+' - Employee Code is not valid',ValidHed);


                { Check Payroll No. }
                If (ValidCheck) then
                begin

                  TPayNo:=EJobMisc.EmplRec.PayNo;       {* Exchequer Payroll No *}
                  TEmpName:=EJobMisc.EmplRec.EmpName;   {* Employee Name *}

                  ValidCheck:=(Not EmptyKey(TPayNo,TLen));

                end;

                Warn_ExpDoc(ValidCheck,On,OurRef,' PayRoll No of '+TEmpName+' is not valid',ValidHed);


                {* Check in Details.Dat for Tran.Lines with EInv.FolioNum
                   and write into Temp.File *}

                If (ValidCheck) then
                   ValidLines(EInv);


             end; { ValidCheck of WkMtn No..}

           end; {with EInv do ..}

           If ((Not ErCheck) and (Not ValidCheck)) then
             ErCheck:=On;

           { Get next Header record }

           Status:=Find_Rec(B_GetNext, F[EInvF], EInvF, RecPtr[EInvF]^, EInvOurRefK, KeyF);

        end; {while status=0 of EInv..}


        KeyF:='';

        {---- testing only - to get actual data -----------}
        {
        Status:=Find_Rec(B_GetFirst,F[ClockInF],ClockInF,RecPtr[ClockInF]^,ECodeRateK,KeyF);
        While (Status=0) Do Begin
           With ClockInRec do  begin
             Writeln(Testfile,EmplCode:10,Rate:5,NoHour:10:2,TshNo:12,StockCode:12);
             Writeln(TestFile,' ');
           end;
           Status:=Find_Rec(B_GetNext,F[ClockInF],ClockInF,RecPtr[ClockInF]^,ECodeRateK,KeyF) ;
        End;
        }
        {---------------------------------------------------}

        {* Write into CLOCKIN Text file *}
        WriteToFile;

        {* Update user's option default fields *}
        UpdateDefault;


        WarnErMsg;


      end; {If ValidCheck of open files..}

      {$I-}

      Close(OFile);
      Close(LFile);


      {Close(TestFile);}  {for testing only}

      {$I+}

      If (DispLog) then
        Show_Log;


    end; {If Tc<>Esc..}

    {-------------------------------------------}


    CloseFiles;  {Ex.Files & Temp.File}

    RmWin;


end; {Proc..ExportClockIn}


End.

