
{ ============ Open/Close Files ============ }

Procedure Open_SetUp(DFnam  :  Str255;
                     Mode   :  Byte;
                 Var TmpIO  :  Integer);

Var
  LoopCnt  :  Integer;

Begin

  TmpIO:=0;

  FileMode:=66;

  {$I-}

  AssignFile(SetUpF,DFnam);
  LoopCnt:=0;

  Case Mode of

    0  :  Begin
            Repeat


              Reset(SetUpF);
              TmpIO:=IOResult;

              Inc(LoopCnt);

            Until (TmpIO<>32) or (LoopCnt>999);

          end;

    1  :  begin
            ReWrite(SetUpF);
            TmpIO:=IOResult;
          end;

  end; {Case..}



  {$I+}

end;

Function TClose_SetUp  :  Integer;
var
  TmpIO  :  Integer;
Begin

  TmpIO:=0;
  {$I-}
  Close(SetUpF);
  {$I+}

  If (IOResult<>0) then
    TmpIO:=12346;

  TClose_SetUp:=TmpIO;
  
end;


Procedure Close_SetUp;

Begin
  {$I-}

  Close(SetUpF);

  {$I+}

  If (IOResult<>0) then ;
end;



{ ====== Procedure to Interpret SetUp Lines ====== }

Procedure Read_SetLine(LineNo  :  Longint;
                       Line    :  Str255);

Const
  SWON  :  Array[FALSE..TRUE] of String[3] = ('OFF','ON');

Var
  GenStr  :  Str255;


Begin

  GenStr:='';

  With ExSyss do
  Case LineNo of

    1   :   AutoSetPr:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

    2   :   DefNom:=IntStr(ExtractWords(2,1,Line));

    3,4
        :   DefCCDep[(LineNo=3)]:=ExtractWords(2,1,Line);

    5   :   AutoSetStkCost:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

    6   :   DeductBOM:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

    7   :   UseMLoc:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

    8   :   OverWORef:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

    9   :   OverWNPad:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

    10  :   UseExCrRate:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

    11  :   AllowEdit:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

    12  :   Begin

              RepPrn:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

              RPrnNo:=IntStr(ExtractWords(3,1,Line));
            end;

    13  :   Begin

              RepFile:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

              RFileN:=ExtractWords(3,1,Line);
            end;

    14  :   ExPath:=ExtractWords(2,1,Line);

    15  :   MCMode:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

    16  :   DefCur:=IntStr(ExtractWords(2,1,Line));

    17  :   UpAccBal:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

    18  :   UpStkBal:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

    19  :   JBIgnore:=(UpCaseStr(ExtractWords(2,1,Line))=SWON[BOn]);

  end; {Case..}

end; {Proc..}



{ ====== Procedure to Store SetUp Lines ====== }

Procedure Write_SetLine(LineINo :  Byte;
                    Var TmpIO   :  Integer);

Const
  SWONBO  :  Array[BOff..BOn] of String[3] = ('OFF','ON');


Var
  GenStr  :  Str255;


Begin

  {$I-}

  GenStr:='';


  Case LineINo of

    1   :   GenStr:=SWONBO[ExSyss.AutoSetPr];

    2   :   GenStr:=Form_Int(ExSyss.DefNom,0);

    3,4
        :   GenStr:=ExSyss.DefCCDep[(LineINo=3)];

    5   :   GenStr:=SWONBO[ExSyss.AutoSetStkCost];

    6   :   GenStr:=SWONBO[ExSyss.DeductBOM];

    7   :   GenStr:=SWONBO[ExSyss.UseMLoc];

    8   :   GenStr:=SWONBO[ExSyss.OverWORef];

    9   :   GenStr:=SWONBO[ExSyss.OverWNPad];

    10  :   GenStr:=SWONBO[ExSyss.UseExCrRate];

    11  :   GenStr:=SWONBO[ExSyss.AllowEdit];

    12  :   Begin

              GenStr:=SWONBO[ExSyss.RepPrn]+Spc(2)+Form_Int(ExSyss.RPrnNo,0);

            end;

    13  :   Begin

              GenStr:=SWONBO[ExSyss.RepFile]+Spc(2)+ExSyss.RFileN;

            end;

    14  :   GenStr:=ExSyss.ExPath;

    15  :   GenStr:=SWONBO[ExSyss.MCMode];

    16  :   GenStr:=Form_Int(ExSyss.DefCur,0);

    17  :   GenStr:=SWONBO[ExSyss.UpAccBal];

    18  :   GenStr:=SWONBO[ExSyss.UpStkBal];

    19  :   GenStr:=SWONBO[ExSyss.JBIgnore];

  end; {Case..}

  WriteLn(SetUpF,LJVar(SetUpSw[LineINo],Sizeof(SetUpSw[1])),'  ',GenStr);

  {$I+}

  TmpIO:=IOResult;

end; {Proc..}


Function Store_SetUp(DFName  :  Str255)  :  Integer;

Var
  Line  :  Str255;
  IOFlg :  Boolean;
  N     :  Byte;

Begin

  Open_SetUp(DFName,1,Result);

  If (Result=0) then
  Begin
    For n:=1 to NoSws do
      If (Result=0) then
        Write_SetLine(N,Result);

    Close_SetUp;

  end; {IF Opned Ok..}

end; {Proc..}


{ ====== Process SetUp File ====== }

Function Process_File(DFName  :  Str255)  :  Integer;

Var
  Line  :  Str255;

  ChkStat,
  TmpIO :  Integer;
  FoundOk,
  TmpBo,
  Abort
        :  Boolean;
  N     :  LongInt;

Begin

  FoundOk:=BOff;  N:=0;

  Result:=0;
  ChkStat:=0;


  Open_SetUp(DFName,0,Result);

  If (Result=0) then
  Begin
    {$I-}

    ReadLn(SetUpF,Line);

    Abort:=EOF(SetUpF);

    TmpIO:=IOResult;

    While (TmpIO=0) and (Not Abort) do
    Begin

      Abort:=EOF(SetUpF);

      N:=1;  FoundOk:=BOff;

      While (N<=NoSws) and (Not FoundOk) do
      Begin

        FoundOk:=Match_Glob(Succ(Length(Line)),SetUpSW[N],Line,TmpBo);

        If (Not FoundOk) then
          Inc(n);

      end; {While..}

      If (FoundOk) then
        Read_SetLine(N,Line);

      ReadLn(SetUpF,Line);

      TmpIO:=IOResult;

    end; {While..}

    If (TmpIO<>0) then
     Result:=TmpIO;

    ChkStat:=TClose_SetUp;

  end; {IF Opned Ok..}

  (*
  else
    Result:=Store_SetUp(DFname);
  *)

  {$I+}

  If (Result=0) and (ChkStat<>0) then
    Result:=ChkStat;

end; {Proc..}
