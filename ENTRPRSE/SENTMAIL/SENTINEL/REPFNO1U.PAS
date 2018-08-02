Unit RepFNO1U;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 25/07/95                      }
{                                                              }
{           Rep Gen Fast NDX Object Control Unit I             }
{                                                              }
{               Copyright (C) 1995 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,
     ExBtTh1U,
     ElVar,
     RepObjIU;

Type

  FastNDXOPtr      =  ^FastNDXObj;

  FastNDXObj       =  Object

                        PFnum,
                        PKeypath,
                        SFnum,
                        SKeypath    :  Integer;

                        { HM 18/08/98: Used to save index record pos }
                        WantRest    : Boolean;
                        SFLinkAddr  : LongInt;

                        Mode        :  Byte;

                        KeyLinkS,
                        KeyLink,
                        KeyChk,
                        KeyChkE     :  Str255;

                        Range       : Array[1..2] of Str255;

                        LinkRec3,
                        StillLink,
                        LinkUp,
                        GetInp      :  Boolean;

                        LinkAddr,
                        InpNo       :  LongInt;

                        InpObj      :  RepLInpPtr;

                        {OutF        : Text;}

                        Constructor Init(IM        : Byte;
                                         IRef      : LongInt;
                                         RunName   : Str10;
                                         MTExLocal : tdPostExLocalPtr);

                        Destructor   Done;


                        Procedure Prime_FastNDX;

                        Function LinkResult  :  Str255;

                        Function LinkLink    :  Str255;

                        Function JumpLink  :  Str255;

                        Function JumpPath  :  Integer;

                        Function Find_FastNDX(B_Func  :  Integer;
                                              KeyS    :  Str255)  :  Integer;

                        Procedure Jump_NDXStart(LAddr  :  LongInt);

                        Function RelLink : Boolean;

                      end; {Object..}


     function GetRangeValue(R : TElertRangeRec; Before : Boolean) : ShortString; overload;
     function GetRangeValue(R : TElertRangeRec) : ShortString; overload;
     procedure SplitPeriod(const p : ShortString; var mm, yy : word);

  var
    CurrPeriod : String;

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   ETStrU,
   ETMiscU,
   ETDateU,
   BtrvU2,
   BtSupU1,
   BtKeys1U,
   VarFposU,
   RwOpenF,
   RpCommon,
   SentEx1U,
   SysUtils;


  procedure SplitPeriod(const p : ShortString; var mm, yy : word);
  var
    i  : integer;
    s1, s2 : ShortString;
  begin
    i := Pos('/', p);
    if i > 0 then
    begin
      s1 := Copy(p, 1, i - 1);
      s2 := Copy(p, i + 1, Length(p));
    end
    else
    begin
      s2 := Copy(p, 1, 3);
      s1 := Copy(p, 4, 2);
    end;

    mm := StrToInt(s1);
    yy := StrToInt(s2);
  end;

  function GetRangeValue(R : TElertRangeRec; Before : Boolean) : ShortString;
  var                                      
    pm, py : Word;
    Off, i : SmallInt;
    PDate : String[10];

    function Sign(Value : longint) : ShortInt;
    begin
      if Value = 0 then
        Result := 0
      else
      if Value > 0 then
        Result := 1
      else
      if Value < 0 then
        Result := -1;
    end;

  begin
    Case R.egType of
      evDate    :  if UpperCase(Trim(R.egString)) = 'TODAY' then
                   begin
                     if Before then
                       Result := CalcDueDate(FormatDateTime('yyyymmdd', Date), R.egOffset)
                     else
                       Result := R.egString;
                   end
                   else
                   begin
                     if Before then
                       Result := R.egString
                     else
                      Result := CalcDueDate(R.egString, R.egOffset);
                   end;

      evPeriod  :  begin
                      if UpperCase(Trim(R.egString)) = 'CURRENT PERIOD' then
                        PeriodStr(CurrPeriod, pm, py)
                      else
                        SplitPeriod(R.egString, pm, py);
//                        PeriodStr(R.egString, pm, py);
                      off := Sign(R.egOffset);
                      for i := 1 to abs(R.egOffset) do
                      begin
                        pm := pm + off;
                        if pm > GlobPeriodsInYr then
                        begin
                          pm := 1;
                          inc(py);
                        end
                        else
                        if pm < 1 then
                        begin
                          pm := GlobPeriodsInYr;
                          dec(py);
                        end;
                      end;
                      if py > 1000 then
                        Result := IntToStr(py - 1900) + IntToStr(pm)
                      else
                        Result := IntToStr(py) + IntToStr(pm);
                    end;
       evCurrency : begin //PR: 07/04/2011 ABSEXCH-2702 Report Engine expects currency 1 as #1 rather then '1'
                      Result := '' + Char(StrToInt(R.egString));
                    end;
     else
       Result := R.egString;
    end;//case
  end;

   { ---------------------------------------------------------------- }

   {  FastNDXObj Methods }

   { ---------------------------------------------------------------- }




  Constructor FastNDXObj.Init(IM        : Byte;
                              IRef      : LongInt;
                              RunName   : Str10;
                              MTExLocal : tdPostExLocalPtr);

  Begin
    {Assign (OutF, 'c:\fastndx.txt');
    Rewrite (OutF);}

    LinkRec3:=BOff;

    WantRest := False;
    SFLinkAddr := 0;

    Mode:=IM;

    //PR 15/04/2003 This was commented out so inputs weren't getting picked up properly
    InpNo:=IRef;

{    If (InpNo>0) then
    Begin
      New(InpObj,Init(RunName));

      InpObj^.InitInpFObj(RepGenF,RGK,MtExLocal);
    end;}

    PFnum:=0;
    SFnum:=0;
    PKeypath:=0;
    SKeypath:=0;

    Blank(KeyChk,Sizeof(KeyChk));

    Blank(KeyChkE,Sizeof(KeyChkE));

    Blank(KeyLink,Sizeof(KeyLink));

    Blank(KeyLinkS,Sizeof(KeyLinkS));


    GetInp:=BOff;

    //check whether report has inputs

    with TdSentExLocalPtr(MTExLocal)^.LElertRec do
    begin
      if elActions.eaReport or elActions.eaCSV then
      begin
        if (elRangeStart.egType <> evNull) and elRangeStart.egInput then
        begin
          Range[1] := Trim(GetRangeValue(elRangeStart, True));
          Range[2] := Trim(GetRangeValue(elRangeEnd, True));
          elRangeStart.egString  := Trim(GetRangeValue(elRangeStart, False));
          elRangeEnd.egString := Trim(GetRangeValue(elRangeEnd, False));
          GetInp := Bon;
        end
        else
        begin
          Range[1] := StringOfChar(#0, 255);
          Range[2] := StringOfChar(#255, 255);
        end;
      end
      else
      begin
        Range[1] := Trim(GetRangeValue(elRangeStart, True));
        Range[2] := Trim(GetRangeValue(elRangeEnd, True));
      end;
    end;

    Prime_FastNDX;

    LinkUp:=(PFnum<>SFnum);

    StillLink:=BOff;



  end;


  Destructor FastNDXObj.Done;


  Begin
    {Close (OutF);}

  {  If (InpNo>0) then
      Dispose(InpObj,Done);}

  end;



  Procedure FastNDXObj.Prime_FastNDX;

  Var

    FStr    :  Str255;
    TStr    :  Array[1..2] of Str255;

    IVType,
    n       :  Byte;

    HasErr  :  Boolean;

  Begin


    LinkRec3:=(Mode In [32..49]);


    Case Mode of


      1
         :  Begin

              PFnum:=InvF;

              SFnum:=PFnum;

              SKeypath:=InvOurRefK;

              GetInp:=BOn;
            end;

      2
         :  Begin

              PFnum:=InvF;

              SFnum:=PFnum;

              SKeypath:=InvCustK;

              GetInp:=BOn;
            end;

      3..8
         :  Begin
              PFnum:=InvF;

              SFnum:=PFnum;

              SKeypath:=InvRNoK;

              GetInp:=(Mode In [4, 53]);

              Case Mode of

                3, 52  :  KeyChk:=FullNomKey(0);

                5, 54 :  KeyChk:=FullNomKey(OrdUSRunNo);
                6, 55 :  KeyChk:=FullNomKey(OrdPSRunNo);
                7, 56 :  KeyChk:=FullNomKey(OrdUPRunNo);
                8, 57 :  KeyChk:=FullNomKey(OrdPPRunNo);

              end;

              KeyChkE:=KeyChk;

            end;

      9
         :  Begin

              PFnum:=InvF;

              SFnum:=PFnum;

              SKeypath:=InvFolioK;

              GetInp:=BOn;
            end;

      10
         :  Begin

              PFnum:=InvF;

              SFnum:=PFnum;

              SKeypath:=InvYrRefK;

              GetInp:=BOn;
            end;

      11
         :  Begin

              PFnum:=InvF;

              SFnum:=PFnum;

              SKeypath:=InvLYRefK;

              GetInp:=BOn;
            end;


      12
         :  Begin {* Doc Date *}

              PFnum:=InvF;

              SFnum:=PFnum;

              SKeypath:=InvDateK;

              GetInp:=BOn;
            end;


      13
         :  Begin {* Doc Date *}

              PFnum:=InvF;

              SFnum:=PFnum;

              SKeypath:=InvYrPrK;

              GetInp:=BOn;

            end;


      14,32
          : Begin

              PFnum:=IdetailF;

              SFnum:=PFnum;

              SKeypath:=IdFolioK;

              GetInp:=BOn;
            end;

      15,16,
      33,34
         :  Begin

              PFnum:=IdetailF;

              SFnum:=PFnum;

              SKeypath:=IdRunK;

              GetInp:=(Mode In [16,34]);

              If (Mode In [15,33]) then
                KeyChk:=FullNomKey(0);

              KeyChkE:=KeyChk;
            end;

      17..25,
      35..43
         :  Begin
              PFnum:=IdetailF;

              SFnum:=PFnum;

              SKeypath:=IdAnalK;

              Case Mode of

                17,35 :  KeyChk:=StkLineType[SIN];
                18,36 :  KeyChk:=StkLineType[SOR];
                19,37 :  KeyChk:=StkLineType[SDN];
                20,38 :  KeyChk:=StkLineType[PIN];
                21,39 :  KeyChk:=StkLineType[POR];
                22,40 :  KeyChk:=StkLineType[PDN];
                23,41 :  KeyChk:=StkLineType[SQU];
                24,42 :  KeyChk:=StkLineType[PQU];
                25,43 :  KeyChk:=StkLineType[ADJ];

              end;

              KeyChkE:=KeyChk;

            end;

      26,44
           :  Begin

              PFnum:=IdetailF;

              SFnum:=PFnum;

              SKeypath:=IdNomK;

              GetInp:=BOn;
            end;

      27,45
           :  Begin

              PFnum:=IdetailF;

              SFnum:=PFnum;

              SKeypath:=IdStkK;

              GetInp:=BOn;
            end;

      28,46
           :  Begin

              PFnum:=IdetailF;

              PKeypath:=IdFolioK;

              SFnum:=InvF;

              SKeypath:=InvCustK;

              GetInp:=BOn;
            end;




      29,47
           :  Begin

              PFnum:=IdetailF;

              PKeypath:=IdFolioK;

              SFnum:=InvF;

              SKeypath:=InvOurRefK;

              GetInp:=BOn;
            end;

      30,48
            : Begin

              PFnum:=IdetailF;

              PKeypath:=IdFolioK;

              SFnum:=InvF;

              SKeypath:=InvDateK;

              GetInp:=BOn;
            end;


      31,49
            : Begin

              PFnum:=IdetailF;

              PKeypath:=IdFolioK;

              SFnum:=InvF;

              SKeypath:=InvYrPrK;

              GetInp:=BOn;
            end;

      { TH - Outstanding }
      50  : Begin
              PFnum:=InvF;

              SFnum:=InvF;

              SKeypath:=InvOSK;

              GetInp:=BOn;
            End;

      { TL Unreconciled, Reconciled }
      51,52
          : Begin
              PFnum:=IDetailF;

              SFnum:=IDetailF;

              SKeypath:=IDReconK;

              GetInp:=BOn;

              { Set keys as precaution - won't get set if no input line }
              KeyChk  := #0#0#0#0 + Chr(Mode-51) + #0;
              KeyChkE := FullNomKey(MaxLongInt) + Chr(Mode-51) + #0;
            End;
      {$IFDEF EN550CIS}
      {Transaction CIS Voucher Date}
      53  : begin
              PFnum:=InvF;

              SFnum:=InvF;

              SKeypath:= InvCISK;

              GetInp:=BOn;
            end;
      {$ENDIF}
    end; {Case..}

    { Adjust print file for Job Retentions }
    {If (Mode In [50..62]) Then
      PFnum:=JDetlF;}

    //PR 15/04/03: Having 'and inpno > 0' commented out meant that for Mode = 50 (Outstanding Idx)
    //values weren't getting set correctly.
//    If (GetInp) {and (InpNo>0)} then
    If (GetInp) and (InpNo>0) then
    Begin

      For n:=1 to 2 do

      Begin
//        FStr:=RepInpCode+Form_Int(InpNo,0)+'['+Form_Int(n,0)+']';

        TStr[n]:=Strip('R',[#32],{InpObj^.GetInpField(FStr,IVType,HasErr)}Range[n]);

        If (Mode In [4,9,14,16,26,32,34,44]) then {* Convert to Normal LongInt *}
          TStr[n]:=FullNomKey(IntStr(TStr[n]))
        Else
          If (Mode = 51) Then
            { TL Unreconciled }
            TStr[n]:=FullNomKey(IntStr(TStr[n])) + #0 + #0
          Else
            If (Mode = 52) Then
              { TL Reconciled }
              TStr[n]:=FullNomKey(IntStr(TStr[n])) + #1 + #0;

        If (Mode In [13,31,49]) then begin
          { HM 25/01/99: Modified to use 3 digit years }
          if TStr[n][1] in [#0,#255] then
            TStr[n] := Copy(TStr[n], 1, 2)
          else
            TStr[n]:=Chr(IntStr(Copy(TStr[n],1,3)))+Chr(IntStr(Copy(TStr[n],4,2)));
          {TStr[n]:=Chr(IntStr(Copy(TStr[n],1,2)))+Chr(IntStr(Copy(TStr[n],3,2)));}
        End; { If }
      end;

      KeyChk:=TStr[1];
      KeyChkE:=TStr[2];

    end;



  end; {Proc..}


  Function FastNDXObj.LinkResult  :  Str255;
  Begin
    Result:='';

    Case Mode of

      1,29,47
         :  Result:=Inv.OurRef;

      2,28,46
         :  Result:=Inv.CustCode;

      3..8
         :  Result:=FullNomKey(Inv.RunNo);

      9
         :  Result:=FullNomKey(Inv.FolioNum);

      10
         :  Result:=Inv.YourRef;

      11
         :  Result:=Inv.TransDesc;

      12,30,48
         :  Result:=Inv.TransDate;

      13,31,49
         :  With Inv do
              Result:=Chr(AcYr)+Chr(AcPr);

      14,32
         :  Result:=FullNomKey(Id.FolioRef);

      15,16,
      33,34
         :  Result:=FullNomKey(Id.PostedRun);

      17..25,
      35..43
         :  Result:=Id.LineType;

      26,44
         :  Result:=FullNomKey(Id.NomCode);

      27,45
         :  Result:=FullStockCode(Id.StockCode);

      50 :  Result := Inv.AllocStat;

      51,52
         :  Result := FullNomKey(Id.NomCode) + Chr(Id.Reconcile) + Chr(Id.NomMode);
      {$IFDEF EN550CIS}
      53 :  Result := Inv.CISDate;
      {$ENDIF}
    end; {Case..}

  end; {Func..}


  Function FastNDXObj.LinkLink  :  Str255;
  Begin
    Result:='';

    Case Mode of

      1  :  ;

      28..31,
      46..49
         :  Result:=FullNomKey(Inv.FolioNum);
    end; {Case..}
  end; {Func..}

  Function FastNDXObj.JumpLink  :  Str255;
  Begin
    Result:='';

    Case Mode of

      1  :  ;

      28..31,
      46..49
         :  Result:=FullNomKey(Id.FolioRef);

    end; {Case..}
  end; {Func..}



  Function FastNDXObj.JumpPath  :  Integer;
  Begin
    Result:=0;

    Case Mode of

      1  :  ;

      28..31,
      46..49
         :  Result:=InvFolioK;


    end; {Case..}
  end; {Func..}



  { Does Relation link to load related record for printing }
  Function FastNDXObj.RelLink : Boolean;
  Const
    FNum    = JDetlF;
    KeyPath = JDLookK;
  Var
    KeyS    : Str255;
    LocStat : Integer;
  Begin
    Result := True;
    {PR 2/05/2007: Function was using and checking Id.LineNo rather than Id.AbsLineNo so would only work
     where they were both the same. Changed it to use AbsLineNo.}
    Case Mode Of
      { Job Actuals - retrieve equivalent Actual line for Id line }
      32..49  : Begin
                  KeyS := PartCCKey(JBRCode, JBECode) +
                          FullNomKey(Id.FolioRef) +
                          FullNomKey(Id.AbsLineNo) +
                          '!';

                  LocStat := Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

                  Result := (LocStat = 0) And
                            (Id.FolioRef = JobDetl^.JobActual.LineFolio) And
                            (Id.AbsLineNo = JobDetl^.JobActual.LineNo);
                End; { 32..49 - Job Actuals }
    End; { Case }
  End;


  { ======= Function to Process file via NDX ======== }


  Function FastNDXObj.Find_FastNDX(B_Func  :  Integer;
                                   KeyS    :  Str255)  :  Integer;


  Var

    TmpStat,
    B_Func2 :  Integer;

    ChkStr  :  Str255;

    LinkFail:  Boolean;

    RepLoop : Boolean;

  Begin
    Result:=0;

    TmpStat:=0;

    B_Func2:=B_Func;

    Repeat

      LinkFail:=BOn;

      If (Not StillLink) then
      Begin
        If WantRest Then Begin
          { Restore }
          TmpStat:=Presrv_BTPos(SFnum,SKeypath,F[SFnum],SFLinkAddr,BOn,BOff);
        End; { If }

        Result:=Find_Rec(B_Func,F[SFnum],SFnum,RecPtr[SFnum]^,SKeypath,KeyS);

        If (Result=0) then
        Begin
          { store }
          WantRest := True;
          TmpStat:=Presrv_BTPos(SFnum,SKeypath,F[SFnum],SFLinkAddr,BOff,BOff);


          ChkStr:=LinkResult;

          Result:=Ord(Not CheckKeyRange(KeyChk,KeyChkE,ChkStr,Length(KeyChk),BOn));

          KeyLink:=LinkLink;

          KeyLinkS:=KeyLink+FullNomKey(FirstAddrD);

          B_Func2:=B_GetGEq;
        end;
      end;




      If (Result=0) Then Begin
        LinkFail:=BOff;

        { Do Relational link where required }
        If LinkUp then Begin
          { Search and Print Files are different }
          Keys:=KeyLinkS;

          If (StillLink) then {* Restore position *}
            TmpStat:=Presrv_BTPos(PFnum,PKeypath,F[PFnum],LinkAddr,BOn,BOff);

          Repeat

            RepLoop := False;

            { Get record from print file }
            Result:=Find_Rec(B_Func2,F[PFnum],PFnum,RecPtr[PFnum]^,PKeypath,KeyS);

            { Check its the correct record }
            StillLink:=((Result=0) and (CheckKey(KeyLink,KeyS,Length(KeyLink),BOn)));

            If StillLink And LinkRec3 Then Begin
              { do any links to other records }

              RepLoop:=Not RelLink;

              If RepLoop Then
                B_Func2:=B_GetNext;
            End; { If }

          Until (Not LinkRec3) Or (Not StillLink) Or (Not RepLoop);

          If (StillLink) then
            TmpStat:=Presrv_BTPos(PFnum,PKeypath,F[PFnum],LinkAddr,BOff,BOff);

          Result:=Ord(Not StillLink);

          KeyLinkS:=KeyS;

          B_Func:=B_GetNext;
        End { If }
        Else
          { Search and print files are the same }
          If LinkRec3 Then Begin
            Result:=Ord(Not RelLink);

            KeyLinkS:=KeyS;

            B_Func:=B_GetNext;
          End; { If }
      End; { If }

    Until (Result=0) or ((Not LinkUp) And (Not LinkRec3)) Or (LinkFail);
  end;


  { ======== Proc to Locate StartPos and prime ========== }


  Procedure FastNDXObj.Jump_NDXStart(LAddr  :  LongInt);


  Var
    KeyS      :  Str255;

    JPath,
    TmpStat   :  Integer;

    TmpAddr   :  LongInt;


  Begin

    JPath:=JumpPath;
    KeyS:=JumpLink;

    Status:=Find_Rec(B_GetEq,F[SFnum],SFnum,RecPtr[SFnum]^,JPath,KeyS);


    If (StatusOk) then
    Begin
      TmpStat:=Presrv_BTPos(SFnum,JPath,F[SFnum],TmpAddr,BOff,BOff);

      {* Re-establish correct position *}

      TmpStat:=Presrv_BTPos(SFnum,SKeyPath,F[SFnum],TmpAddr,BOn,BOff);

      LinkAddr:=LAddr;

      StillLink:=BOn;

      KeyLink:=LinkLink;
      KeyLinkS:=KeyLink;


    end;



  end;

  function GetRangeValue(R : TElertRangeRec) : ShortString;
  var
    pm, py : Word;
    Off, i : SmallInt;
    PDate : String[10];

    function Sign(Value : longint) : ShortInt;
    begin
      if Value = 0 then
        Result := 0
      else
      if Value > 0 then
        Result := 1
      else
      if Value < 0 then
        Result := -1;
    end;

  begin
    Case R.egType of
      evDate    :  if UpperCase(Trim(R.egString)) = 'TODAY' then
                      Result := CalcDueDate(FormatDateTime('yyyymmdd', Date), R.egOffset)
                   else
                      Result := CalcDueDate(R.egString, R.egOffset);

      evPeriod  :  begin
                      if UpperCase(Trim(R.egString)) = 'CURRENT PERIOD' then
                        PeriodStr(CurrPeriod, pm, py)
                      else
                       SplitPeriod(R.egString, pm, py);
//                        PeriodStr(R.egString, pm, py);
                      off := Sign(R.egOffset);
                      for i := 1 to abs(R.egOffset) do
                      begin
                        pm := pm + off;
                        if pm > GlobPeriodsInYr then
                        begin
                          pm := 1;
                          inc(py);
                        end
                        else
                        if pm < 1 then
                        begin
                          pm := GlobPeriodsInYr;
                          dec(py);
                        end;
                      end;
                      if py > 1000 then
                        Result := IntToStr(py - 1900) + IntToStr(pm)
                      else
                        Result := IntToStr(py) + IntToStr(pm);
                    end;
       evCurrency : begin //PR: 07/04/2011 ABSEXCH-2702 Report Engine expects currency 1 as #1 rather then '1'
                      Result := '' + Char(StrToInt(R.egString));
                    end;
     else
       Result := R.egString;
    end;//case
  end;



end. {Unit..}

