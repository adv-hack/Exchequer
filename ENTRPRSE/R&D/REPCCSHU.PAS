unit RepCCShu;



interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,VarRec2U,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,
  RpDefine,RpDevice,
  Report3U,
  Report4U,
  Report5U,
  uReportParams;


type
  TCCDepSchedule  =  Record
                       AbortInp,
                       AbortCC,
                       AbortDp,
                       CCMatch,
                       DpMatch,
                       FirstCCGo,
                       FirstDpGo,
                       NoMoreCC,
                       NoMoreDp,
                       
                       NTagMode
                                 :  Boolean;

                       SchTit    :  Str80;

                       B_Func,
                       TmpKPath,
                       KeyPath,
                       TmpStat   :  Integer;

                       TmpRecAddr,
                       TmpRecAddr2,
                       TmpRecAddr3
                                 :  LongInt;

                       TPWrd     :  PasswordRec;

                       CCDpInp   :  CCdepType;

                       KeyS,
                       KeyCCChk,
                       KeyDpChk  :  Str255;


                     end;

  TDocReportPtr     =  ^TDocReport;

  TQCCDepReport      =  Object(TThreadQueue)

                          private
                             GotOneCC    :  Boolean;
                             mRDevRec    :  TSBSPrintSetupInfo;
                             mRFont      :  TFont;
                             mROrient    :  TOrientation;


                             CCDepSched  :  TCCDepSchedule;
                             mReportMode :  Integer;
                             mPMode      :  Byte;
                             fDocReport  :  TDocReportPtr;
                             fDocRepParam:  DocRepPtr;

                             bPrintParams : Boolean;
                             oPrintParams : TReportParameters;


                            Procedure RepThreadDelay(dt  :  Word;
                                                     SAPM:  Boolean);

                            Procedure Initialize_CCSchedule(InpCCDp     :  CCDepType;
                                                            TagMode     :  Boolean);

                            Function Run_CCSchedule(Var  InpCCDp    :  CCDepType)  :   Boolean;

                            procedure PassParameters(const pRep : Pointer);
                            procedure StoreParameters(const pRep : Pointer); 

                          public
                            fLoopCCDep   :  CCDepType;

                            Property QCRepParam  :  DocRepPtr Read fDocRepParam write fDocRepParam;

                            Property Report2Run  :  TDocReportPtr  Read fDocReport write fDocReport;


                            Constructor Create(AOwner  :  TObject);

                            Destructor  Destroy; Virtual;

                            {* All thesde procedure muist be overriden for each instance, otherwise the shared
                               routines will be using the wrong instance of QReportParam & Report2Run

                               In addition, This object will call GetReportInput from inside a thread.
                               GetReportInput is normally called outside of the thread, so any modes
                               which are being called by the scheduler would need to ensure that titles
                               using getcust/getcc/dep used MTExlocal when available to query Btrieve*}

                            Procedure SetSpecial(Direction  :  Boolean); Virtual;

                            Procedure SetLoopCCDep(Direction  :  Boolean); Virtual;

                            Function WantMore  :  Boolean; Virtual;

                            Function ReportAssigned  :  Boolean; Virtual;

                            Function PrimeReport  :  Boolean; Virtual;

                            Function CloneReport  :  Boolean; Virtual;


                            Procedure Create_ThreadInst; Virtual;


                            Procedure Process; Virtual;
                            Procedure Finish;  Virtual;

                            Function Start  :  Boolean; Virtual;



                        end; {Class..}

  TNomReportPtr        =  ^TNomReport;

  TQCCDepTBReport      =  Object(TQCCDepReport)

                          private
                             fNomReport  :  TNomReportPtr;

                             fNomRepParam:  NomRepRecPtr;


                          public
                            Property Report2Run  :  TNomReportPtr  Read fNomReport Write fNomReport;

                            Property QCRepParam  :  NomRepRecPtr Read fNomRepParam write fNomRepParam;

                            Constructor Create(AOwner  :  TObject);

                            Destructor  Destroy; Virtual;

                            {* All thesde procedure muist be overriden for each instance, otherwise the shared
                               routines will be using the wrong instance of QReportParam & Report2Run*}

                            Procedure SetSpecial(Direction  :  Boolean); Virtual;

                            Procedure SetLoopCCDep(Direction  :  Boolean); Virtual;

                            Function WantMore  :  Boolean; Virtual;

                            Function ReportAssigned  :  Boolean; Virtual;

                            Function PrimeReport  :  Boolean; Virtual;

                            Function CloneReport  :  Boolean; Virtual;

                            Procedure Create_ThreadInst; Virtual;

                            Function Start  :  Boolean; Virtual;


                        end; {Class..}


  TCCDepReportPtr      =  ^TCCDepReport;

  TQCCDepCDReport      =  Object(TQCCDepTBReport)

                          private
                             fCCDepReport  :  TCCDepReportPtr;


                          public
                            Property Report2Run  :  TCCDepReportPtr Read fCCDepReport Write fCCDepReport;

                            Constructor Create(AOwner  :  TObject);

                            Destructor  Destroy; Virtual;

                            {* All thesde procedure muist be overriden for each instance, otherwise the shared
                               routines will be using the wrong instance of QReportParam & Report2Run*}

                            Procedure SetSpecial(Direction  :  Boolean); Virtual;

                            Function ReportAssigned  :  Boolean; Virtual;

                            Function PrimeReport  :  Boolean; Virtual;

                            Function CloneReport  :  Boolean; Virtual;

                            Procedure Create_ThreadInst; Virtual;

                            Function Start  :  Boolean; Virtual;


                        end; {Class..}




  Procedure AddCCDepReportThread(LMode    :  Byte;
                                 IMode    :  Byte;
                                 IRepParam:  DocRepPtr;
                                 AOwner   :  TObject);


  Procedure AddTBCCDepReportThread(LMode    :  Byte;
                                   IRepParam:  NomRepRecPtr;
                                   AOwner   :  TObject);

  Procedure AddCDCCDepReportThread(LMode    :  Byte;
                                   IRepParam:  NomRepRecPtr;
                                   AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Forms,
  ETDateU,
  ETStrU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  BTSupU1,
  CurrncyU,
  SysU1,
  SysU2,
  DocSupU1,

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  ExThrd2U,
  //PR: 22/10/2009
  ReportU,
  BtSupU2,

  StrUtil;


    { ========== TQCCDepReport methods =========== }

  Constructor TQCCDepReport.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=3;
    fCanAbort:=BOn;

    fOwnMT:=BOff; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;

    GotOneCC:=BOff;

    Report2Run:=nil;

    FillChar(mRDevRec,Sizeof(mRDevRec),0);

    New(fDocRepParam);

    FillChar(QCRepParam^,Sizeof(QCRepParam^),0);

    With mRDevRec do
    Begin
      DevIdx:=-1;
      Preview:=BOn;
      NoCopies:=1;
    end;


    mRFont:=TFont.Create;

    try
      mRFont.Assign(Application.MainForm.Font);
    except
      mRFont.Free;
      mRFont:=nil;
    end;

    mROrient:=RPDefine.PoPortrait;

    oPrintParams := TReportParameters.Create;
  end;

  Destructor TQCCDepReport.Destroy;

  Begin
    If (Assigned(oPrintParams)) then
      oPrintParams.Free;

    If (Assigned(mRFont)) then
      mRFont.Free;

    Dispose(fDocRepParam);

    Inherited Destroy;
  end;


  procedure TQCCDepReport.RepThreadDelay(dt  :  Word;
                                         SAPM:  Boolean);

  Var
    ThTimeS,
    thTimeN   :  TDateTime;

    thGap     :  Double;

  Begin
    thTimeS:=Now;

    thGap:=dt/1e8;

    Repeat
      thTimeN:=Now-ThTimeS;

      If (SAPM) then
        Application.ProcessMessages;

    Until (thTimeN>thgap);

  end;


  Procedure TQCCDepReport.Initialize_CCSchedule(InpCCDp     :  CCDepType;
                                                TagMode     :  Boolean);


  Begin
    Blank(CCDepSched,Sizeof(CCDepSched));

    With CCDepSched, MTExLocal^ do
    Begin
      Keypath:=  PWK;

      NTagMode:=TagMode;

      CCDpInp:=InpCCDp;

      AbortInp:=BOff;
      AbortCC:=BOn;
      AbortDp:=BOn;
      CCMatch:=BOff;
      DpMatch:=BOff;
      NoMoreCC:=BOff;
      NoMoreDp:=BOn;

      FirstCCGo:=BOn;
      FirstDpGo:=BOn;

      AbortCC:=(Not Has_CCWildChar(CCDpInp[BOn])) and (Not NTagMode);
      AbortDp:=(Not Has_CCWildChar(CCDpInp[BOff])) and (Not NTagMode);


      KeyCCChk:=PartCCKey(CostCCode,CSubCode[BOn]);
      KeyDpChk:=PartCCKey(CostCCode,CSubCode[BOff]);


      KeyS:=KeyCCChk;


      TPWrd:=LPassWord;
    end;

  end;


  Function TQCCDepReport.Run_CCSchedule(Var  InpCCDp    :  CCDepType)  :   Boolean;

  Const
    Fnum     =  PWrdF;

  Var
    TriedAgain  :  Boolean;

  Begin
    With CCDepSched,MTExLocal^ do
    Begin
      Repeat
        CCMatch:=BOff;     TriedAgain:=BOn;

        If (Not AbortCC) and (NoMoreDp or AbortDp) then
        Begin
          NoMoreDp:=BOff;
          FirstDpGo:=BOn;

          Repeat

            If (FirstCCGo) then
              B_Func:=B_GetGEq
            else
            Begin
              TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr2,BOn,BOff);

              B_Func:=B_GetNext;
            end;

            FirstCCGo:=BOff;

            LStatus:=LFind_Rec(B_Func,Fnum,Keypath,KeyS);


            TmpStat:=LPresrv_BTPos(Fnum,KeyPath,LocalF^[Fnum],TmpRecAddr2,BOff,BOff);

            AbortInp:=((Not LStatusOk) or (Not CheckKey(KeyCCChk,KeyS,Length(KeyCCChk),BOff))) or (ThreadRec^.THAbort);


            If (Not AbortInp) then  {* Check for match, or check for tagged records *}
              CCMatch:=((Match_WildChar(LPassWord.CostCtrRec.PCostC,CCDpInp[BOn],BOff,BOff))
                        and ((LPassWord.CostCtrRec.CCTag) or (Not NTagMode)));

            If (CCMatch) then
              InpCCDp[BOn]:=LPassWord.CostCtrRec.PCostC; {* Not a wild card so pass it on as found *}

          Until (AbortInp) or (CCMatch);

          GotOneCC:=(GotOneCC or CCMatch);

          {* v5.01 If we are searching for tagged only, and no cc's tagged, then override abort, and search for dp *}
          If (AbortInp) and (Not CCMatch) and (NTagMode) and (CCDpInp[BOn]='') and (Not GotOneCC) then
          Begin
            AbortInp:=NoMoreDp or AbortDp;
            AbortCC:=BOn;
          end;
        end
        else
          If (AbortCC) then
            InpCCDp[BOn]:=CCDpInp[BOn]; {* Not a wild card so pass it on as input *}



        KeyS:=KeyDpChk;

        DpMatch:=BOff;


        If (Not AbortDp) and (Not AbortInp) then
        Repeat

          If (FirstDpGo) then
            B_Func:=B_GetGEq
          else
          Begin
            TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr3,BOn,BOff);


            B_Func:=B_GetNext;
          end;

          FirstDpGo:=BOff;

          LStatus:=LFind_Rec(B_Func,Fnum,Keypath,KeyS);

          TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr3,BOff,BOff);


          NoMoreDp:=((Not LStatusOk) or (Not CheckKey(KeyDpChk,KeyS,Length(KeyDpChk),BOff))) or (ThreadRec^.THAbort);


          If (Not NoMoreDp) then {* Check for matching / with / without tag *}

            DpMatch:=((Match_WildChar(LPassWord.CostCtrRec.PCostC,CCDpInp[BOff],BOff,BOff))
                    and ((LPassWord.CostCtrRec.CCTag) or (Not NTagMode)));


          If (DpMatch) then
            InpCCDp[BOff]:=LPassWord.CostCtrRec.PCostC {* Not a wild card so pass it on as found *}
          else
            TriedAgain:=AbortCC;

            //If (Not ThreadRec^.THAbort) and (Not CCMatch) and (Not AbortCC) and (Not AbortInp) and (NoMoreDp) then {* We need to call ourselves again for the next CC *}
            //  Result:=Run_CCSchedule(InpCCDp);


        Until (AbortInp) or (NoMoreDp) or (DpMatch)
        else
        Begin
          InpCCDp[BOff]:=CCDpInp[BOff]; {* Not a wild card so pass it on as input *}
          NoMoreDp:=BOn;
        end;


      Until (CCMatch) or (DpMatch) or (AbortCC and AbortDp) or (ThreadRec^.THAbort) or (AbortInp) or (TriedAgain);

      Result:=CCMatch or (Not NoMoreDp);


    end; {With..}
  end;



  Procedure TQCCDepReport.SetSpecial(Direction  :  Boolean);

  Begin
    If (Direction) then
    With Report2Run^ do
    Begin
      ReportMode:=mReportMode;
      PMode:=mPMode;
    end
    else
    With Report2Run^ do
    Begin
      mReportMode:=ReportMode;
      mPMode:=PMode;

    end;
  end; {Proc..}


  Procedure TQCCDepReport.SetLoopCCDep(Direction  :  Boolean);

  Begin
    If (Direction) then
    With QCRepParam^ do
    Begin
      Move(RCCDep,fLoopCCDep,Sizeof(fLoopCCDep));
    end
    else
    With QCRepParam^ do
    Begin
      Move(fLoopCCDep,RCCDep,Sizeof(RCCDep));
    end;
  end; {Proc..}


  Function TQCCDepReport.WantMore  :  Boolean;

  Begin
    Result:=(mReportMode =2) or (mReportMode=3);
  end; {Proc..}


  Procedure TQCCDepReport.Create_ThreadInst;

  Begin
    New(fDocReport,Create(Self.fMyOwner));

  end;


  Function TQCCDepReport.ReportAssigned  :  Boolean;

  Begin
    Result:=Assigned(Report2Run);
  end; {Proc..}


  Function TQCCDepReport.PrimeReport  :  Boolean;

  Begin
    Result:=BOn;

    With BackThread do
    Begin
      try
        Report2Run^.CRepParam^:=QCRepParam^;

        Report2Run^.RepTitle2:='';

        {In addition, This object will call GetReportInput from inside a thread.
         GetReportInput is normally called outside of the thread, so any modes
         which are being called by the scheduler would need to ensure that titles
         using getcust/getcc/dep used MTExlocal when available to query Btrieve*}

        {$IFDEF EXSQL}
          if SQLUtils.UsingSQL then
            Report2Run^.ReOpen_LocalThreadfiles;
        {$ENDIF}

        Report2Run^.GetReportInput;

        {$IFDEF EXSQL}
          if SQLUtils.UsingSQL then
            Report2Run^.Reset_LocalThreadfiles;
        {$ENDIF}

        AddTask(Report2Run,Report2Run^.ThTitle);


      except
        Dispose(Report2Run,Destroy);
        Report2Run:=nil;
        Result:=BOff;

      end;
    end;

  end; {Proc..}



  Function TQCCDepReport.CloneReport  :  Boolean;

  Begin
    Result:=BOn;

    try
     Begin

       Report2Run^.RDevRec:=mRDevRec;
       Report2Run^.RFont.Assign(mRFont);
       Report2Run^.ROrient:=mROrient;



       Report2Run^.InitRep1;

       SetSpecial(BOn);


       Report2Run^.MTExLocal:=Self.MTExLocal;

       PassParameters(Report2Run);
     end;
     except
       Dispose(Report2Run,Destroy);
       Report2Run:=nil;

       Result:=BOff;
     end;

  end; {Proc..}





  Procedure TQCCDepReport.Process;

  Var
    RunAgain  :  Boolean;
    ReportNo  :  Integer;
  Begin
    InMainThread:=BOn;

    RunAgain:=BOff;

    Inherited Process;

    ReportNo := 1;

    ShowStatus(0,'Multiple CC/Dep. Print Run');


    If (ReportAssigned) then
    With BackThread do
    Begin

      Run_CCSchedule(fLoopCCDep);


      SetLoopCCDep(BOff);


      Repeat

        If PrimeReport then
        {$B-}
          RunAgain:=WantMore and Run_CCSchedule(fLoopCCDep);

          SetLoopCCDep(BOff);

        {$B+}


        If (RunAgain) then
        Begin
          Create_ThreadInst;

          RunAgain:=CloneReport;

          //PR: 21/07/2017 ABSEXCH-18591 Add incremental number to filename
          //for multiple files writing to xlsx or html
          if RunAgain and (mRDevRec.fePrintMethod in [5, 7]) then
          begin
            Report2Run^.RDevRec.feXMLFileDir :=
              IncrementFilename(mRDevRec.feXMLFileDir, ReportNo);
            inc(ReportNo);

          end;

        end;

      Until (Not RunAgain) or (ThreadRec^.THAbort) or (Not ReportAssigned) or (Not WantMore);

      {$IFDEF EXSQL}
      Reset_LocalThreadFiles;
      {$ENDIF}

    end;

  end;


  Procedure TQCCDepReport.Finish;
  Begin

    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

  end;




  Function TQCCDepReport.Start  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Result:=BOff;


    If (Assigned(Report2Run)) then
    Begin
      Result:=Report2Run^.Start;

      If (Result) then {* Take copies of all the main variables prior to the first run *}
      Begin
        QCRepParam^:=Report2Run^.CRepParam^;
        mRDevRec:=Report2Run^.RDevRec;

        SetLoopCCDep(BOn);

        try
          mRFont.Assign(Report2Run^.RFont);
        except
          mRFont.Free;
          mRFont:=nil;
        end;


        mROrient:=Report2Run^.ROrient;

        StoreParameters(Report2Run);
        
      {$IFDEF EXSQL}
      if SQLUtils.UsingSQL then
      begin
        if (not Assigned(LPostLocal)) then
          Result := Create_LocalThreadFiles;

        If (Result) then
          MTExLocal := LPostLocal;


        OutputDebugString(PChar('CC Rep ClientID = ' + IntToStr(MTExLocal^.ExClientID.TaskID)));
      end
      else
      {$ENDIF}
        MTExLocal:=Report2Run^.MTExLocal;

        If (Assigned(MTExLocal)) then
          With QCRepParam^ do
            Initialize_CCSchedule(fLoopCCDep,CCDpTag);

      end;

      {$IFDEF EXSQL}
      if Result and SQLUtils.UsingSQL then
        Reset_LocalThreadFiles;
      {$ENDIF}


    end;

  end;




  Procedure AddCCDepReportThread(LMode    :  Byte;
                                 IMode    :  Byte;
                                 IRepParam:  DocRepPtr;
                                 AOwner   :  TObject);

  Var
    LQCCDep_Report :  ^TQCCDepReport;

  //PR: 22/10/2009 Function to add this report's parameters to the report's PrintParameters object.
  procedure AddParameters(var EntTest : TGenReport);
  const
    CommitStrings : Array[0..2] of String[27] = ('Show Actuals only', 'Combine Committed & Actuals', 'Show Committed only');
  begin
    if Assigned(EntTest.oPrintParams) then
    begin

      if LMode in [rmNominalAuditTrail, rmDocumentAuditTrail] then
      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'Folio Number Range';
        Value := Format('%d to %d', [IRepParam.FolStart, IRepParam.FolEnd]);
      end;

      if LMode <> rmDocumentAuditTrail then
      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'General Ledger Range';
        Value := FormatGLRange(IRepParam.ReconCode, IRepParam.NomToo);
      end;


      {$IFDEF MC_ON}
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Report for Currency';
        Value := TxLatePound(CurrDesc(IRepParam.RCr), True);
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Translate to Currency';
        Value := TxLatePound(CurrDesc(IRepParam.RTxCr), True);
      end;
      {$ENDIF}

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Period/Year Range';
        if IRepParam.ByDate then
          Value := 'N/A'
        else
//          Value := Format('%.2d/%d to %.2d/%d', [IRepParam.RPr, IRepParam.RYr + 1900, IRepParam.RPr2, IRepParam.RYr2 + 1900]);
          Value := Format('%s to %s', [PPR_OutPr(IRepParam.RPr, IRepParam.RYr), PPR_OutPr(IRepParam.RPr2, IRepParam.RYr2)]);
      end;

      if not (LMode in [rmNominalAuditTrail, rmDocumentAuditTrail]) then
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Date Range';
        if not IRepParam.ByDate then
          Value := 'N/A'
        else
          Value := POutDate(IRepParam.SDate) + ' to ' + POutDate(IRepParam.EDate);
      end;

      if Syss.UseCCDep and (LMode <> rmDocumentAuditTrail) then
      begin
        with EntTest.oPrintParams.AddParam do
        begin
          Name :=  'Cost Centre';
          Value := IRepParam.RCCDep[True];
        end;

        with EntTest.oPrintParams.AddParam do
        begin
          Name :=  'Department';
          Value := IRepParam.RCCDep[False];
        end;

        with EntTest.oPrintParams.AddParam do
        begin
          Name :=  'Tag';
          Value := IRepParam.CCDpTag;
        end;
      end; //If UseCCDept

      if CommitAct and (LMode = rmGLHistory) then
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Committed/Actual';
        Value := CommitStrings[IRepParam.CommitMode];
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'Account No';
        Value := IRepParam.CustFilt;
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'Document Type';
        Value := IRepParam.DocWanted;
      end;

      EntTest.bPrintParams := True;
    end;
  end;

  Begin

    If (Create_BackThread) then
    Begin
      New(LQCCDep_Report,Create(AOwner));

      try
        With LQCCDep_Report^ do
        Begin
          Create_ThreadInst;

          try
            With Report2Run^ do
            Begin
              ReportMode:=LMode;
              PMode:=IMode;

              SetSpecial(BOff);

              If (Assigned(IRepParam)) then
              Begin
                CRepParam^:=IRepParam^;


                if Assigned(Report2Run) and (LMode in [rmGLHistory, rmNominalAuditTrail, rmDocumentAuditTrail])
                                        and IRepParam.PrintParameters then
                AddParameters(Report2Run^);
              end;

            end;
          except
            Dispose(Report2Run,Destroy);
            Report2Run:=nil;
          end; {Try..}

          If (Start) and (Create_BackThread) then
          Begin

            With BackThread do
              AddTask(LQCCDep_Report,'CC/Dep Schedule');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);

            Dispose(Report2Run,Destroy);
            Dispose(LQCCDep_Report,Destroy);
          end;
        end; {with..}

      except
        Dispose(LQCCDep_Report,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


  { ========== TQCCDepTBReport methods =========== }

  Constructor TQCCDepTBReport.Create(AOwner  :  TObject);

  Begin
    New(fNomRepParam);

    Inherited Create(AOwner);

  end;

  Destructor TQCCDepTBReport.Destroy;

  Begin

    Inherited Destroy;

    Dispose(fNomRepParam);
  end;


  Procedure TQCCDepTBReport.SetSpecial(Direction  :  Boolean);

  Begin
    If (Direction) then
    With Report2Run^ do
    Begin
      ReportMode:=mReportMode;
    end
    else
    With Report2Run^ do
    Begin
      mReportMode:=ReportMode;
    end;
  end; {Proc..}


  Procedure TQCCDepTBReport.SetLoopCCDep(Direction  :  Boolean);

  Begin
    If (Direction) then
    With QCRepParam^ do
    Begin
      Move(NCCDep,fLoopCCDep,Sizeof(fLoopCCDep));
    end
    else
    With QCRepParam^ do
    Begin
      Move(fLoopCCDep,NCCDep,Sizeof(NCCDep));
    end;
  end; {Proc..}



  Function TQCCDepTBReport.WantMore  :  Boolean;

  Begin
    Result:=Bon;
  end; {Proc..}


    Function TQCCDepTBReport.ReportAssigned  :  Boolean;

  Begin
    Result:=Assigned(Report2Run);
  end; {Proc..}


  Function TQCCDepTBReport.PrimeReport  :  Boolean;

  Begin
    Result:=BOn;

    With BackThread do
    Begin
      try
        Report2Run^.CRepParam^:=QCRepParam^;

        Report2Run^.RepTitle2:='';

        {In addition, This object will call GetReportInput from inside a thread.
         GetReportInput is normally called outside of the thread, so any modes
         which are being called by the scheduler would need to ensure that titles
         using getcust/getcc/dep used MTExlocal when available to query Btrieve*}

        Report2Run^.GetReportInput;

        AddTask(Report2Run,Report2Run^.ThTitle);


      except
        Dispose(Report2Run,Destroy);
        Report2Run:=nil;
        Result:=BOff;

      end;
    end;

  end; {Proc..}



  Function TQCCDepTBReport.CloneReport  :  Boolean;

  Begin
    Result:=BOn;

    try
     Begin

       Report2Run^.RDevRec:=mRDevRec;
       Report2Run^.RFont.Assign(mRFont);
       Report2Run^.ROrient:=mROrient;

       Report2Run^.InitRep1;

       SetSpecial(BOn);


       Report2Run^.MTExLocal:=Self.MTExLocal;

       PassParameters(Report2Run);
     end;
     except
       Dispose(Report2Run,Destroy);
       Report2Run:=nil;

       Result:=BOff;
     end;

  end; {Proc..}



  Procedure TQCCDepTBReport.Create_ThreadInst;

  Begin
    New(fNomReport,Create(Self.fMyOwner));

  end;


    Function TQCCDepTBReport.Start  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Result:=BOff;


    If (Assigned(Report2Run)) then
    Begin
      Result:=Report2Run^.Start;

      If (Result) then {* Take copies of all the main variables prior to the first run *}
      Begin
        QCRepParam^:=Report2Run^.CRepParam^;
        mRDevRec:=Report2Run^.RDevRec;

        SetLoopCCDep(BOn);

        try
          mRFont.Assign(Report2Run^.RFont);
        except
          mRFont.Free;
          mRFont:=nil;
        end;


        mROrient:=Report2Run^.ROrient;

        MTExLocal:=Report2Run^.MTExLocal;

        if Report2Run^.bPrintParams and Assigned(Report2Run^.oPrintParams) then
        begin
          oPrintParams.Assign(Report2Run^.oPrintParams);
          bPrintParams := True;
        end;

        If (Assigned(MTExLocal)) then
          With QCRepParam^ do
            Initialize_CCSchedule(fLoopCCDep,CCDpTag);

      end;


    end;

  end;




  Procedure AddTBCCDepReportThread(LMode    :  Byte;
                                   IRepParam:  NomRepRecPtr;
                                   AOwner   :  TObject);

  Var
    LQCCDep_Report :  ^TQCCDepTBReport;

  //PR: 22/10/2009 Function to add this report's parameters to the report's PrintParameters object.
  procedure AddParameters(var EntTest : TGenReport);
  const
    CommitStrings : Array[0..2] of String[27] = ('Show Actuals only', 'Combine Committed & Actuals', 'Show Committed only');
  begin
    if Assigned(EntTest.oPrintParams) then
    begin
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Period/Year';
        Value := PPR_OutPr(IRepParam.RPr, IRepParam.RYr);
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'Comparative YTD';
        Value := (LMode in [10, 80]); //Double check this
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'General Ledger Range';
        if (IRepParam.PALS = 0) and (IRepParam.PALE = 0) then
          Value := 'All'
        else
        if (IRepParam.PALE = 0) then
          Value := IntToStr(IRepParam.PALS) + ' to End'
        else
          Value := Format('%d to %d', [IRepParam.PALS, IRepParam.PALE]);
        Value := FormatGLRange(IRepParam.PALS, IRepParam.PALE);
      end;

      {$IFDEF MC_ON}
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Report for Currency';
        Value := TxLatePound(CurrDesc(IRepParam.FCr), True);
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Translate to Currency';
        Value := TxLatePound(CurrDesc(IRepParam.FTxCr), True);
      end;
      {$ENDIF}

      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'Report to Level';
        if IRepParam.RepLimit = 255 then
          Value := 'All'
        else
          Value := IntToStr(IRepParam.RepLimit);
      end;

      if CommitAct then
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Committed/Actual';
        Value := CommitStrings[IRepParam.CommitMode];
      end;

      if Syss.UseCCDep then
      begin
        with EntTest.oPrintParams.AddParam do
        begin
          Name :=  'Cost Centre';
          Value := IRepParam.NCCDep[True];
        end;

        with EntTest.oPrintParams.AddParam do
        begin
          Name :=  'Department';
          Value := IRepParam.NCCDep[False];
        end;

        with EntTest.oPrintParams.AddParam do
        begin
          Name :=  'Tag';
          Value := IRepParam.CCDpTag;
        end;
      end; //If UseCCDept

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Include Zero Balances';
        Value := IRepParam.IncludeAll;
      end;

      EntTest.bPrintParams := True;
    end;
  end;

  Begin

    If (Create_BackThread) then
    Begin
      New(LQCCDep_Report,Create(AOwner));

      try
        With LQCCDep_Report^ do
        Begin
          Create_ThreadInst;

          try
            With Report2Run^ do
            Begin
              ReportMode:=LMode;

              SetSpecial(BOff);

              If (Assigned(IRepParam)) then
              Begin
                CRepParam^:=IRepParam^;


              if Assigned(Report2Run) and (LMode in rmTrialBalanceSet) and IRepParam.PrintParameters then
                AddParameters(Report2Run^);
              end;

            end;
          except
            Dispose(Report2Run,Destroy);
            Report2Run:=nil;
          end; {Try..}

          If (Start) and (Create_BackThread) then
          Begin

            With BackThread do
              AddTask(LQCCDep_Report,'CC/Dep Schedule');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);

            Dispose(Report2Run,Destroy);
            Dispose(LQCCDep_Report,Destroy);
          end;
        end; {with..}

      except
        Dispose(LQCCDep_Report,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


  { ========== TQCCDepCDReport methods =========== }

  Constructor TQCCDepCDReport.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

  end;

  Destructor TQCCDepCDReport.Destroy;

  Begin

    Inherited Destroy;
  end;


  Procedure TQCCDepCDReport.SetSpecial(Direction  :  Boolean);

  Begin
    If (Direction) then
    With Report2Run^ do
    Begin
      ReportMode:=mReportMode;
    end
    else
    With Report2Run^ do
    Begin
      mReportMode:=ReportMode;
    end;
  end; {Proc..}



  Function TQCCDepCDReport.ReportAssigned  :  Boolean;

  Begin
    Result:=Assigned(Report2Run);
  end; {Proc..}


  Function TQCCDepCDReport.PrimeReport  :  Boolean;

  Begin
    Result:=BOn;

    With BackThread do
    Begin
      try
        Report2Run^.CRepParam^:=QCRepParam^;

        Report2Run^.RepTitle2:='';

        {In addition, This object will call GetReportInput from inside a thread.
         GetReportInput is normally called outside of the thread, so any modes
         which are being called by the scheduler would need to ensure that titles
         using getcust/getcc/dep used MTExlocal when available to query Btrieve*}

        Report2Run^.GetReportInput;

        AddTask(Report2Run,Report2Run^.ThTitle);


      except
        Dispose(Report2Run,Destroy);
        Report2Run:=nil;
        Result:=BOff;

      end;
    end;

  end; {Proc..}



  Function TQCCDepCDReport.CloneReport  :  Boolean;

  Begin
    Result:=BOn;

    try
     Begin

       Report2Run^.RDevRec:=mRDevRec;
       Report2Run^.RFont.Assign(mRFont);
       Report2Run^.ROrient:=mROrient;

       Report2Run^.InitRep1;

       SetSpecial(BOn);


       Report2Run^.MTExLocal:=Self.MTExLocal;

       if bPrintParams and Assigned(oPrintParams) then
       begin
         Report2Run^.oPrintParams.Assign(oPrintParams);
         Report2Run^.bPrintParams := True;
       end;

     end;
     except
       Dispose(Report2Run,Destroy);
       Report2Run:=nil;

       Result:=BOff;
     end;

  end; {Proc..}



  Procedure TQCCDepCDReport.Create_ThreadInst;

  Begin
    New(fCCDepReport,Create(Self.fMyOwner));

  end;


    Function TQCCDepCDReport.Start  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Result:=BOff;


    If (Assigned(Report2Run)) then
    Begin
      Result:=Report2Run^.Start;


      If (Result) then {* Take copies of all the main variables prior to the first run *}
      Begin
        QCRepParam^:=Report2Run^.CRepParam^;
        mRDevRec:=Report2Run^.RDevRec;

        SetLoopCCDep(BOn);

        try
          mRFont.Assign(Report2Run^.RFont);
        except
          mRFont.Free;
          mRFont:=nil;
        end;


        mROrient:=Report2Run^.ROrient;

        MTExLocal:=Report2Run^.MTExLocal;

        StoreParameters(Report2Run);

        If (Assigned(MTExLocal)) then
          With QCRepParam^ do
            Initialize_CCSchedule(fLoopCCDep,CCDpTag);


      end;


    end;

  end;




  Procedure AddCDCCDepReportThread(LMode    :  Byte;
                                   IRepParam:  NomRepRecPtr;
                                   AOwner   :  TObject);

  Var
    LQCCDep_Report :  ^TQCCDepCDReport;

  Begin

    If (Create_BackThread) then
    Begin

      New(LQCCDep_Report,Create(AOwner));

      try
        With LQCCDep_Report^ do
        Begin

          Create_ThreadInst;

      
          try
            With Report2Run^ do
            Begin
              ReportMode:=LMode;

              SetSpecial(BOff);

              If (Assigned(IRepParam)) then
              Begin
                CRepParam^:=IRepParam^;


              end;

            end;
          except
            Dispose(Report2Run,Destroy);
            Report2Run:=nil;
          end; {Try..}

          If (Start) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LQCCDep_Report,'CC/Dep Schedule');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);

            Dispose(Report2Run,Destroy);
            Dispose(LQCCDep_Report,Destroy);
          end;
        end; {with..}

      except
        Dispose(LQCCDep_Report,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;




procedure TQCCDepReport.PassParameters(const pRep: Pointer);
var
  pGenRep : ^TGenReport;
begin
  pGenRep := pRep;
  if bPrintParams and Assigned(oPrintParams) then
  begin
    pGenRep^.oPrintParams.Assign(oPrintParams);
    pGenRep^.bPrintParams := True;
  end;

end;

procedure TQCCDepReport.StoreParameters(const pRep: Pointer);
var
  pGenRep : ^TGenReport;
begin
  pGenRep := pRep;
  if pGenRep^.bPrintParams and Assigned(pGenRep^.oPrintParams) then
  begin
    oPrintParams.Assign(pGenRep^.oPrintParams);
    bPrintParams := True;
  end;
end;

Initialization



Finalization

end.