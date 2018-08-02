Unit RepFNO1U;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
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

                        LinkRec3,
                        StillLink,
                        LinkUp,
                        GetInp      :  Boolean;

                        LinkAddr,
                        InpNo       :  LongInt;

                        InpObj      :  RepLInpPtr;

                        {OutF        : Text;}
                        WantThisRec : Boolean;

                        InputStart, InputEnd : Str255;

                        Constructor Init(IM        : Byte;
                                         IRef      : LongInt;
                                         RunName   : Str10;
                                         MTExLocal : tdPostExLocalPtr;
                                         InpStart, InpEnd : Str255);

                        Destructor   Done;


                        Procedure Prime_FastNDX;

                        Function LinkResult  :  Str255;

                        Function LinkLink    :  Str255;

                        Function JumpLink  :  Str255;

                        Function JumpPath  :  Integer;
                        
                        //PR: 01/04/2015 ABSEXCH-16312 Made KeyS var parameter
                        Function Find_FastNDX(B_Func  :  Integer;
                                              var KeyS    :  Str255)  :  Integer;

                        Procedure Jump_NDXStart(LAddr  :  LongInt);

                        Function RelLink : Boolean;


                      end; {Object..}




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
   RpCommon;






   { ---------------------------------------------------------------- }

   {  FastNDXObj Methods }

   { ---------------------------------------------------------------- }




  Constructor FastNDXObj.Init(IM        : Byte;
                              IRef      : LongInt;
                              RunName   : Str10;
                              MTExLocal : tdPostExLocalPtr;
                              InpStart, InpEnd : Str255);

  Begin
    {Assign (OutF, 'c:\fastndx.txt');
    Rewrite (OutF);}

    LinkRec3:=BOff;

    WantRest := False;
    SFLinkAddr := 0;

    Mode:=IM;

    InpNo:=IRef;

    If (InpNo>0) then
    Begin
{      New(InpObj,Init(RunName));

      InpObj^.InitInpFObj(RepGenF,RGK,MtExLocal);}
      InputStart := InpStart;
      InputEnd := InpEnd;
    end
    else
    begin
      InputStart := '';
      InputEnd := '';
    end;

    PFnum:=0;
    SFnum:=0;
    PKeypath:=0;
    SKeypath:=0;

    Blank(KeyChk,Sizeof(KeyChk));

    Blank(KeyChkE,Sizeof(KeyChkE));

    Blank(KeyLink,Sizeof(KeyLink));

    Blank(KeyLinkS,Sizeof(KeyLinkS));


    GetInp:=BOff;

    Prime_FastNDX;

    LinkUp:=(PFnum<>SFnum);

    StillLink:=BOff;



  end;


  Destructor FastNDXObj.Done;


  Begin
    {Close (OutF);}

{    If (InpNo>0) then
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

    //PR: 07/01/2014 ABSEXCH-14854 Change to use new indexes.
    //PR: 21/01/2014 Still need to set for Job Actual file.
    LinkRec3:=(Mode In [32..49]) and not (Mode in [28, 29, 31]);


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

      //PR: 07/01/2014 ABSEXCH-14854 Change to use new indexes.
      28,46
           :  Begin

              PFnum:=IdetailF;

              PKeypath:=IdCustCodeK;

              SFnum:=PfNum;

              SKeypath:=PKeypath;

              GetInp:=BOn;
            end;




      //PR: 07/01/2014 ABSEXCH-14854 Change to use new indexes.
      29,47
           :  Begin

              PFnum:=IdetailF;

              PKeypath := IdDocPRefK;

              SFnum:=PfNum;

              SKeypath:=PKeypath;

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


      //PR: 07/01/2014 ABSEXCH-14854 Change to use new indexes.
      31,49
            : Begin

              PFnum:=IdetailF;

              PKeypath := IdYrPrK;

              SFnum:=PfNum;

              SKeypath:=PKeypath;

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

    If (GetInp) and (InpNo>0) then
    Begin

      For n:=1 to 2 do

      Begin
{        FStr:=RepInpCode+Form_Int(InpNo,0)+'['+Form_Int(n,0)+']';

        TStr[n]:=Strip('R',[#32],InpObj^.GetInpField(FStr,IVType,HasErr));}
        Case n of
          1 : TStr[n] := InputStart;
          2 : TStr[n] := InputEnd;
        end;

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

      1  :  Result:=Inv.OurRef;

      2  :  Result:=Inv.CustCode;

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

      13 :  With Inv do
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

      28,46
         :  Result := Id.CustCode;

      29,47
         :  Result := Id.DocPRef;

      31,49
         :  With Id do
              Result:=Chr(PYr)+Chr(PPr);


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

      //PR: 07/01/2014 ABSEXCH-14854 Removed values which use new indexes.
      30,
      48
         :  Result:=FullNomKey(Inv.FolioNum);
    end; {Case..}
  end; {Func..}

  Function FastNDXObj.JumpLink  :  Str255;
  Begin
    Result:='';

    Case Mode of

      1  :  ;

      //PR: 07/01/2014 ABSEXCH-14854 Removed values which use new indexes.
      30,
      48
         :  Result:=FullNomKey(Id.FolioRef);

    end; {Case..}
  end; {Func..}



  Function FastNDXObj.JumpPath  :  Integer;
  Begin
    Result:=0;

    Case Mode of

      1  :  ;

      //PR: 07/01/2014 ABSEXCH-14854 Removed values which use new indexes.
      30,
      48
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

  //PR: 01/04/2015 ABSEXCH-16312 Made KeyS var parameter
  Function FastNDXObj.Find_FastNDX(B_Func  :  Integer;
                                   var KeyS    :  Str255)  :  Integer;


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

    if Result = 0 then
    begin
      Case Mode of
        19,37 : WantThisRec := ID.IdDocHed = SDN;
        22,40 : WantThisRec := ID.IdDocHed = PDN;

        //PR: 27/03/2014 ABSEXCH-15214 Ignore any control lines.
        28,29,46,47,31,49
              : WantThisRec := Id.FolioRef <> 0;
        else
          WantThisRec := True;
      end; //Case
    end;
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



end. {Unit..}

