{ ============== TDNMList Methods =============== }


Function TDNMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With Count do
  Begin
    DumStr:=CountTyp;
  end; {With..}


  SetCheckKey:=DumStr;
end;




Function TDNMList.SetFilter  :  Str255;

{$IFDEF LTE}
Const
  DTExclList   :  Array[1..12] of String[3] = ('EPC','EPI','EPO','ESC','ESI','ESO','PRN','SOA','SRN','TSH','WOR','WIN');
  DTJCExclList :  Array[1..7] of String[3] = ('JBF','JCT','JPA','JPT','JRN','JSA','JST');
{$ENDIF}

Var
  LChk  :  LongInt;
  n     :  Byte;

Begin

  Move(Count.NextCount[1],LChk,Sizeof(LChk));

  If (LChk<0) then  {* Stop -ve Counts from being displayed *}
    LChk:=-1
  else
  Begin
    {$IFDEF LTE}
      For n:=Low(DTExclList) to High(DTExclList) do
      Begin
        If (CheckKey(DTExclList[n],Count.CountTyp,Length(DTExclList[n]),BOff)) then
        Begin
          LChk:=-1;
          Break;
        end;
      end; {Loop..}
      
        {$IFDEF JC}
          If (LChk<>-1) and (JbCostOn) then
          Begin
            For n:=Low(DTJCExclList) to High(DTJCExclList) do
              If (CheckKey(DTJCExclList[n],Count.CountTyp,Length(DTJCExclList[n]),BOff)) then
              Begin
                LChk:=-1;
                Break;
              end;


          end;
        {$ENDIF}
    {$ENDIF}
  end;

  Result:=FullNomKey(LChk);
end;


Function TDNMList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;



{ ========== Generic Function to Return Formatted Display for List ======= }


Function TDNMList.OutLine(Col  :  Byte)  :  Str255;

Var
  NextNo :  LongInt;
  DocHed :  DocTypes;
  GenStr :  Str255;

Begin

  With Count do
  Begin

    Case Col of

       0  :  Begin
               Result:=CountTyp
             end;
       1  :  Begin
               DocHed:=DocTypeFCode(CountTyp);

               If (Not CheckKey(CountTyp,DocCodes[DocHed],Length(CountTyp),NoUpCaseCheck)) then
                 GenStr:=ExternMsg
               else
                 GenStr:=DocNames[DocHed];

               Result:=GenStr;
             end;

       2  :  Begin
               Move(NextCount[1],NextNo,Sizeof(NextNo));

               Result:=FormatFloat(GenRNDMask,NextNo);
             end;

       else
             Result:='';
     end; {Case..}


   end; {With..}
end;




