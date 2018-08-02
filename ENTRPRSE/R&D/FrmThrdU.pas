Unit FrmThrdU;

{$I DEFOVR.INC}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 22/01/96                      }
{                   SOP Process Control Unit                   }
{                                                              }
{                                                              }
{               Copyright (C) 1996 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

Interface

Uses
  Classes,
  GlobVar,
  VarConst,
  BTSupU3,
  RPDevice,
  ExBtTh1U,
  JobSup2U,
  SCRTCH2U;

Type
    TPostLog  =  Class; // PKR. Forward reference

    
    TPFormList  =  Class(TList)

                  VisiRec    :  PFormRepPtr;

                  Destructor Destroy; override;

                  Procedure AddVisiRec(PDevRec    :  TSBSPrintSetupInfo;
                                       DMode      :  Integer;
                                       QRForm     :  Str10;
                                       F1,K1,
                                       F2,K2      :  Integer;
                                       Key1,Key2  :  Str255);

                  Procedure DestroyVisi;

                  Function IdRec(Start  :  Integer)  :  PFormRepPtr;

                  Function HasItems  :  Boolean;

                end; {TPieList..}

    TeCommFrmList  =  Class(TPFormList)


                  Procedure AddeCommVisiRec(Const ecPrnInfo    : TSBSPrintSetupInfo;
                                            Const ecDefMode    : Integer;
                                            Const ecFormName   : ShortString;
                                            Const ecMFN, MKP   : Integer;
                                            Const ecMKeyRef    : Str255;
                                            Const ecTFN, TKP   : Integer;
                                            Const ecTKeyRef    : Str255;
                                            Const ecDescr,
                                                  ecWinTitle   : ShortString;
                                            Const ecAddBatchInfo
                                                               : StaCtrlRec);


                end; {TeCommFrmList..}


    TPrintForm      =  Object(TThreadQueue)

                             private
                                 Procedure StartPrintJob;

                                 Procedure Print_SingleForm;
                             public
                               ChildProcess,
                               PORMode     :  Boolean;

                               FormRepPtr  :  PFormRepPtr;

                               eCommFrmList
                                           :  TeCommFrmList;



                               Constructor Create(AOwner  :  TObject);

                               Destructor  Destroy; Virtual;

                               Procedure Process; Virtual;
                               Procedure Finish;  Virtual;

                               Function Start(CIDMode  :  Integer)  :  Boolean;


                           end; {Class..}


    TBatchStatuses     = (bsNone, bsCreated, bsPopulated);
    TPrintPORForm      =  Object(TPrintForm)

                             private
                               // PKR. 04/12/2015. ABSEXCH-15333. Send PORs to correct email addresses.
                               errorLog : TPostLog; /// Error log used to record traders with no email address configured

                               Procedure Print_PORRun;

                             public
                               ThisScrt    :  Scratch2Ptr;

                               //PR: 21/03/2014 ABSEXCH-14853
                               ScratchProcessID : Integer;

                               Constructor Create(AOwner  :  TObject);

                               Destructor  Destroy; Virtual;

                               Procedure Process; Virtual;
                               Procedure Finish;  Virtual;

                               // PKR. 03/12/2015. ABSEXCH-15333. Send PORs to correct email addresses.
                               Function Send_FrmPrint(ecPrnInfo : TSBSPrintSetupInfo;
                                                      Const ecDefMode      : Integer;
                                                      Const ecFormName     : ShortString;
                                                      Const ecMFN, MKP     : Integer;
                                                      Const ecMKeyRef      : Str255;
                                                      Const ecTFN, TKP     : Integer;
                                                      Const ecTKeyRef      : Str255;
                                                      Const ecDescr        : ShortString;
                                                      Const ecAddBatchInfo : StaCtrlRec;
                                                      Const ProcessErr     : Boolean;
                                                      Const ecCommMode     : Byte) : Boolean;
                           end; {Class..}

    TPrintBPForm      =  Object(TPrintForm)

                             private
                               Procedure Print_PPYRun;



                             public
                               RepKey  :  Str255;
                               BaseObj :  Boolean;

                               Function  Send_FrmPrint(  ecPrnInfo    : TSBSPrintSetupInfo;
                                                   Const ecDefMode    : Integer;
                                                   Const ecFormName   : ShortString;
                                                   Const ecMFN, MKP   : Integer;
                                                   Const ecMKeyRef    : Str255;
                                                   Const ecTFN, TKP   : Integer;
                                                   Const ecTKeyRef    : Str255;
                                                   Const ecDescr      : ShortString;
                                                   Const ecAddBatchInfo
                                                                      : StaCtrlRec;
                                                   Const ProcessErr   : Boolean;
                                                   Const ecCommMode   : Byte)   :   Boolean;

                               function RightFEAcc(Const SFiltBy,StatDMode  :  Byte)  :  Boolean;

                               Constructor Create(AOwner  :  TObject);

                               Destructor  Destroy; Virtual;

                               Procedure Process; Virtual;
                               Procedure Finish;  Virtual;


                           end; {Class..}

{$IFDEF JC}

      TPrintJCSBForm      =  Object(TPrintBPForm)

                               private
                                 Procedure Print_SelfBillRun;

                               public

                                 Constructor Create(AOwner  :  TObject);

                                 Destructor  Destroy; Virtual;

                                 Procedure Process; Virtual;

                             end; {Class..}
      TPrintJCJAForm      =  Object(TPrintBPForm)

                               private
                                 jpAppCtrlRec  :  tJAppWizRec;

                                 Function LGetJobMisc(ACode  :  Str10;
                                                      GMode  :  Byte)  :  Boolean;

                                 Procedure Print_JAppsRun;

                               public

                                 Constructor Create(AOwner  :  TObject);

                                 Destructor  Destroy; Virtual;

                                 Procedure Process; Virtual;

                             end; {Class..}




{$ENDIF}

    TPrintFormList      =  Object(TPrintForm)

                             private
                               TheList  :  TPFormList;

                               Procedure Print_TheList;

                             public

                               Constructor Create(AOwner  :  TObject);

                               Destructor  Destroy; Virtual;

                               Procedure Process; Virtual;
                               Procedure Finish;  Virtual;


                           end; {Class..}


    TPrintDocRange      =  Object(TPrintBPForm)

                             private

                               Function  DPCheck  :  Boolean;

                               Function DPInclude(KeyS  :  Str255)  :  Boolean;

                               Procedure Process_DPSort;

                               Procedure Print_DocRange;

                             public
                               ThisScrt    :  Scratch2Ptr;

                               Constructor Create(AOwner  :  TObject);

                               Destructor  Destroy; Virtual;

                               Procedure Process; Virtual;
                               Procedure Finish;  Virtual;


                           end; {Class..}

{$IFDEF FRM}
    { == Object to control Creation of posting log report == }

    TPostLog  =  Class(TStringList)

                   Constructor Create;

                   Destructor Destroy; override;

                   private
                     fGot2Print  :  Boolean;

                   public
                      Procedure Write_MsgDD(S  :  String;
                                            DK :  Str255;
                                            DM :  Byte);

                     Procedure Write_Msg(S  :  String);

                     Procedure PrintLog(Const PostRepCtrl  :  PostRepPtr;
                                        Const RepTitle     :  Str255); overload;


                     // CJS 2014-09-25 - v7.x Order Payments - T061 - Delivery Run Exception Report
                     Procedure PrintLog(PrintParam: TSBSPrintSetupInfo;
                                        const RepTitle: Str255); overload;

                     Property Got2Print  :  Boolean read fGot2Print write fGot2Print;

                 end; {Class}


{$ENDIF}

    Procedure Add2PrintQueue(DevRec :  TSBSPrintSetupInfo;
                             DM     :  Byte;
                             FN     :  Str10;
                             PF,PK,
                             FF,FK  :  Integer;
                             KP,KR  :  Str255);

    Procedure AddSta2PrintQueue(DevRec :  TSBSPrintSetupInfo;
                            DM     :  Byte;
                            FN     :  Str10;
                            PF,PK,
                            FF,FK  :  Integer;
                            KP,KR  :  Str255;
                            StaCtrl:  StaCtrlRecType);

    Procedure Start_PORThread( AOwner     :  TObject;
                               MTEx       :  tdPostExLocalPtr;
                               TScrt      :  Scratch2Ptr;
                               FormRep    :  PFormRepPtr);

    Procedure Start_PPYThread( AOwner     :  TObject;
                               MatchK     :  Str255;
                               FormRep    :  PFormRepPtr);


    Procedure Start_DocRange( AOwner     :  TObject;
                              FormRep    :  PFormRepPtr);

    Procedure Print_BatchList( AOwner     :  TObject;
                               RList      :  TPFormList);

    {$IFDEF JC}

      procedure PrintJCDoc(PInv,PBS  :  Boolean;
                           JInv      :  Str10);

      Procedure Start_JCSBThread( AOwner     :  TObject;
                                  FormRep    :  PFormRepPtr);

      Procedure Start_JCJAThread( AOwner       :  TObject;
                                  FormRep      :  PFormRepPtr;
                                  jpAppPrnRec  :  tJAppWizRec);
    {$ENDIF}

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   RPDefine,
   SysUtils,
   Graphics,
   Forms,
   Dialogs,
   ETMiscU,
   ETDateU,
   BtrvU2,
   ComnUnit,
   ComnU2,
   ETStrU,
   CurrncyU,

   InvListU,
   MiscU,
   PrintFrm,

   {$IFDEF FRM}
     DLLInt,

     PrntDlg2,
     ExWrap1U,

     ReportHU,

   {$ENDIF}


   SysU1,
   SysU2,
   BTSupU1,
   BTKeys1U,

   {$IFDEF JC}
     ReValU2U,
     VARJCSTU,
     
   {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

   ExThrd2U;



   { ====================== TPFormList Methods ===================== }

Destructor TPFormList.Destroy;

Begin
  DestroyVisi;

  Inherited;
end;


Procedure TPFormList.AddVisiRec(PDevRec    :  TSBSPrintSetupInfo;
                                DMode      :  Integer;
                                QRForm     :  Str10;
                                F1,K1,
                                F2,K2      :  Integer;
                                Key1,Key2  :  Str255);



Var
  Idx  :  Integer;

Begin
  New(VisiRec);

  try
    With VisiRec^ do
    Begin
      FillChar(VisiRec^,Sizeof(VisiRec^),0);

      RForm:=QRForm;
      DefMode:=DMode;
      PKeyRef:=Key1;
      KeyRef:=Key2;
      PFnum:=F1;
      PKeyPath:=K1;
      Fnum:=F2; KeyPath:=K2;
      PParam.PDevRec:=PDevRec;
    end;

    Idx:=Add(VisiRec);

  except

    Dispose(VisiRec);

  end; {Except..}

end; {Proc..}


Procedure TPFormList.DestroyVisi;

Var
  n  :  Integer;


Begin

  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    try
      If (VisiRec<>Nil) then
        Dispose(VisiRec);

    Except
    end; {except..}
  end; {Loop..}
end; {Proc..}


Function TPFormList.IdRec(Start  :  Integer)  :  PFormRepPtr;

Begin

  If (Start>Pred(Count)) then
    Start:=Pred(Count);

  Result:=List[Start];

end;


Function TPFormList.HasItems  :  Boolean;

Begin
  Result:=(Count>0);
end;


{ ---------------------------------------------------------------------}


Procedure TeCommFrmList.AddeCommVisiRec(Const ecPrnInfo    : TSBSPrintSetupInfo;
                                        Const ecDefMode    : Integer;
                                        Const ecFormName   : ShortString;
                                        Const ecMFN, MKP   : Integer;
                                        Const ecMKeyRef    : Str255;
                                        Const ecTFN, TKP   : Integer;
                                        Const ecTKeyRef    : Str255;
                                        Const ecDescr,
                                              ecWinTitle   : ShortString;
                                        Const ecAddBatchInfo
                                                           : StaCtrlRec);



Var
  Idx  :  Integer;

Begin
  New(VisiRec);

  try
    With VisiRec^ do
    Begin
      FillChar(VisiRec^,Sizeof(VisiRec^),#0);

      RForm:=ecFormName;
      DefMode:=ecDefMode;

      PKeyRef:=ecMKeyRef;
      KeyRef:=ecTKeyRef;

      PFnum:=ecMFN;
      PKeyPath:=MKP;

      Fnum:=ecTFN; KeyPath:=TKP;

      PParam.PDevRec:=ecPrnInfo;

      Descr:=ecDescr;
      WinTitle:=ecWinTitle;

      If (Assigned(ecAddBatchInfo)) then
        AddBatchInfo:=ecAddBatchInfo^;

    end;

    Idx:=Add(VisiRec);

  except

    Dispose(VisiRec);

  end; {Except..}

end; {Proc..}


{ ---------------------------------------------------------------------}



    { ========== TPrintForm methods =========== }

  Constructor TPrintForm.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    PORMode:=BOff;

    ChildProcess:=BOff;

    fTQNo:=2;
    fCanAbort:=BOn;

     fOwnMT:=BOff; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;

    fPrintJob:=BOn;

    eCommFrmList:=nil;

    New(FormRepPtr);

    FillChar(FormRepPtr^,Sizeof(FormRepPtr^),0);

    With FormRepPtr^ do
    Begin
      With PParam,PDevRec do
      Begin
        PBatch:=BOn;
        Preview:=BOn;
        NoCopies:=1;
        Orient:=RPDefine.poPortrait;
        UFont:=Nil;
      end;
    end; {With..}
  end;


  Destructor TPrintForm.Destroy;

  Begin

    Dispose(FormRepPtr);

    Inherited Destroy;


  end;



  Procedure TPrintForm.StartPrintJob;
  Begin
    With FormRepPtr^,PParam,MTExLocal^ do
    Begin
      If (Not BatchStart) then {* Need to create batch *}
      Begin
        {InPrint:=BOff; {* Force in print off otherwise, batch will not work *}

        {$IFDEF FRM}

        //  Params are ProcessError and IgnoreInP (Ignore InPrint)
        pfInitNewBatch(BOff, BOn);

        {$ENDIF}

        {InPrint:=BOn;}

        BatchStart:=BOn;
      end;
   end; {With..}
  end; {Proc..}


  Procedure TPrintForm.Print_SingleForm;
  Var
    Ok2Print,
    FoundOk :  Boolean;

  Begin
    With FormRepPtr^,PParam,MTExLocal^ do
    Begin
      StartPrintJob;

      ShowStatus(1,'Generating Print Run:-');
      ShowStatus(2,'Printing Form '+RForm);

      {$IFDEF FRM}

        Ok2Print:=pfAddBatchForm(PDevRec,DefMode,RForm,
                                 PFnum,PKeyPath,PKeyRef,
                                 Fnum,Keypath,KeyRef,
                                 PDevRec.feJobTitle,
                                 @AddBatchInfo,
                                 BOff);

        {If (DefMode In [1,13,14,23]) then {* Set DocPrinted on Invoice or Credit Note *
        EL: 30/06/1998. Setting printed status moved into SBSForm.DLL v4.23e

          LSet_PrintedStatus(((Not PDevRec.Preview) and (Ok2Print)),(DefMode in [13,14]),LInv);}

      {$ENDIF}

    end; {With..}
  end; {Proc..}




  Procedure TPrintForm.Process;

  Begin
    InMainThread:=BOn;

    Inherited Process;

    If (Not PORMode) then
    Begin
      ShowStatus(0,'Print Queue');

      Print_SingleForm;
    end;

  end;


  Procedure TPrintForm.Finish;

  Var
    TParam  :  ^TPrintParam;
    TNo     :  LongInt;

  Begin
    TNO:=0;

    If (Not ChildProcess) then
    With MTExLocal^ do
    Begin
      If (Assigned(LThPrintJob)) and (Not ThreadRec^.ThAbortPrint) then {* Call back to Synchronise method *}
      Begin
        New(TParam);

        TParam^:=FormRepPtr^.PParam;

        {$IFDEF FRM}  {* Ex431 Connect eComm jobs list here *}
          If (Assigned(eCommFrmList)) then
            TParam^.eCommLink:=eCommFrmList;
        {$ENDIF}


        ShowStatus(1,'');

        ShowStatus(2,'Printing to Printer...');

        ThreadRec^.THAbort:=BOn; {* Force abort, as control now handed over to DLL *}


        LThPrintJob(nil,LongInt(@TParam^),0);

        {Repeat
          Inc(TNo); AV test so thread waited until PP was closed

        Until (Not ThreadRec^.THInPreview);}
      end
      else
      Begin
        {$IFDEF FRM}
          If (Assigned(eCommFrmList)) then
            eCommFrmList.Destroy;
        {$ENDIF}
      end;
    end;

    Inherited Finish;

    {Overridable method}

    InPrint:=BOff;

    InMainThread:=BOff;

  end;




  Function TPrintForm.Start(CIDMode  :  Integer)  :  Boolean;
  Begin
    Result := True;
    Begin
      If (Not Assigned(MTExLocal)) then { Open up files here }
      Begin
        {$IFDEF EXSQL}
        if SQLUtils.UsingSQL then
        begin
          // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
          if (not Assigned(LPostLocal)) then
            Result := Create_LocalThreadFiles;

          If (Result) then
            MTExLocal := LPostLocal;

        end
        else
        {$ENDIF}
        begin
          If (Not Assigned(RepExLocal)) then { Open up Global files here, as one batch after another can cause file collision }
            Result:=Create_ReportFiles;

          If (Result) then
            MTExLocal:=RepExLocal;

          {New(MTExLocal,Create(27));

          try
            With MTExLocal^ do
              Open_System(CustF,PWrdF);

          except
            Dispose(MTExLocal,Destroy);
            MTExLocal:=nil;

          end; {Except}
        end;
      end;
    end;
    Result:=Assigned(MTExLocal);

    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}

  end;





  Procedure AddForm2Thread(AOwner   :  TObject;
                           FormRep  :  PFormRepPtr);


  Var
    LCheck_Stk :  ^TPrintForm;
    CIDMode    :  Integer;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin
          If (Assigned(FormRep)) then
            CIDMode:=Pred(FormRep^.DefMode)
          else
            CIDMode:=0;

          If (Start(CIDMode)) and (Create_BackThread) then
          Begin
            If (Assigned(FormRep)) then
            Begin
              FormRepPtr^:=FormRep^;
              FormRepPtr^.PParam.RepCaption:='Print '+FormRepPtr^.PKeyRef{FormRepPtr^.RForm};
            end;

            With BackThread do
              AddTask(LCheck_Stk,FormRepPtr^.PParam.RepCaption);
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;

Procedure Add2PrintQueue(DevRec :  TSBSPrintSetupInfo;
                         DM     :  Byte;
                         FN     :  Str10;
                         PF,PK,
                         FF,FK  :  Integer;
                         KP,KR  :  Str255);

Var
  LCheck_Stk :  PFormRepPtr;

Begin
  New(LCheck_Stk);

  try
    FillChar(LCheck_Stk^,Sizeof(LCheck_Stk^),0);

    With LCheck_Stk^, PParam, PDevRec do
    Begin
      PBatch:=BOn;
      PDevRec:=DevRec;

      PFnum:=PF; PKeypath:=PK;
      Fnum:=FF; Keypath:=FK;
      KeyRef:=KR;
      PKeyRef:=KP;
      DefMode:=DM;
      RForm:=FN;

      AddForm2Thread(Application.MainForm,LCheck_Stk);


    end; {With..}

  finally

    Dispose(LCheck_Stk);

  end; {try..}
end;


Procedure AddSta2PrintQueue(DevRec :  TSBSPrintSetupInfo;
                            DM     :  Byte;
                            FN     :  Str10;
                            PF,PK,
                            FF,FK  :  Integer;
                            KP,KR  :  Str255;
                            StaCtrl:  StaCtrlRecType);

Var
  LCheck_Stk :  PFormRepPtr;

Begin
  New(LCheck_Stk);

  try
    FillChar(LCheck_Stk^,Sizeof(LCheck_Stk^),0);

    With LCheck_Stk^, PParam, PDevRec do
    Begin
      PBatch:=BOn;
      PDevRec:=DevRec;

      PFnum:=PF; PKeypath:=PK;
      Fnum:=FF; Keypath:=FK;
      KeyRef:=KR;
      PKeyRef:=KP;
      DefMode:=DM;
      RForm:=FN;

      AddBatchInfo:=StaCtrl;

      AddForm2Thread(Application.MainForm,LCheck_Stk);


    end; {With..}

  finally

    Dispose(LCheck_Stk);

  end; {try..}
end;



    { ========== TPrintPORForm methods =========== }

  Constructor TPrintPORForm.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    // PKR. 03/12/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
    {$IFDEF FRM}
      try
        eCommFrmList:=TeCommFrmList.Create;
      except
        eCommFrmList.Destroy;
        eCommFrmList:=nil;
      end; {try..}
    {$ENDIF}

    PORMode:=BOn;

    // PKR. 03/12/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
    errorLog := TPostLog.Create;
  end;


  Destructor TPrintPORForm.Destroy;
  Begin
    // PKR. 03/12/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
    // Destroy the log
    If (Assigned(errorLog)) then
      FreeAndNil(errorLog);

    Inherited Destroy;
  end;


  //----------------------------------------------------------------------------
  // Process the Stock Re-order run to generate the Purchase Orders
  Procedure TPrintPORForm.Print_PORRun;
  Const
    RFnum =ReportF;

    RKeyPath =RpK;

  Var
    LRForm  :  Str255;

    RecAddr :  LongInt;

    Ok2Print :  Boolean;

    KeyR,
    KeyRef  :  Str255;
    useSuppDef : Boolean;  // Using supplier default method
  Begin
    Ok2Print := BOn;
    RecAddr := 0;
    useSuppDef := false;

    // If we have a scratch file...
    If (Assigned(ThisScrt)) then
    begin
      With FormRepPtr^, PParam, MTExLocal^ do
      begin
        // If not print-only, then set the UseSuppDef flag. fePrintMethod is set to anything but 0 to indicate this.
        if PDevRec.feTypes = 63 then
        begin
          useSuppDef := (PDevRec.fePrintMethod <> 0);
        end;

        MTExLocal.Open_System(CustF,PWrdF);
        //PR: 24/08/2012 ABSEXCH-12650 Open scratchfile before creating scratch object
        MTExLocal.Open_System(ReportF,ReportF);

        //PR: 24/08/2012 ABSEXCH-12650 Call new constructor so that records added to the scratchfile don't get deleted.
        //PR: 21/03/2014 ABSEXCH-14853 Pass stored scratchfile process id in so we find the correct records
        New(ThisScrt, InitWithOpenTable(ScratchProcessId, MTExLocal, False));

        LRForm:=RForm;

        ShowStatus(1,'Generating Purchase Order Print Run:-');

        KeyRef:=FullNomKey(ThisScrt^.Process);
        KeyR:=KeyRef;

        // Loop through the records in the scratch file

        // Get a record from the scratch file
        LStatus:=LFind_Rec(B_GetGEq,RFnum,RKeyPath,KeyR);

        // Start a print batch
        FormRepPtr^.BatchStart := false;
        StartPrintJob;

        // POR Processing Loop
        // PKR. 14/12/2015. ABSEXCH-15333. Removed condition (Ok2Print) to stop it failing when cancelling the run.
        While (LStatusOk) and (CheckKey(KeyRef,KeyR,Length(KeyRef),BOn)) and ((Not ThreadRec^.THAbort)) do
        begin
          With LInv do
          Begin
            ThisScrt^ .Get_Scratch(LRepScr^);

            LStatus:=LGetPos(RFnum, RecAddr);

            ShowStatus(2,'Printing Order '+OurRef);

            // Is the Supplier different from the previous record?
            If (LCust.CustCode <> CustCode) then
            begin
              // Get the supplier record.
              LGetMainRec(CustF,CustCode);

              // PKR. 11/12/2015. ABSEXCH-15333. Re-order list to email all generated PORs to relevant suppliers.
              // PKR. 11/02/2016. ABSEXCH-17279. Re-introduce print-to-screen option for Re-order list when sending to printer only.
//              PDevRec.Preview := false; // Not supported for a one-shot batch run
              if (useSuppDef) then
              begin
                // Get the supplier default method
                PDevRec.fePrintMethod := LCust.InvDMode;
              end
              else
              begin
                // Print only
                PDevRec.fePrintMethod := 0;
              end;

              // PKR. 25/11/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
              PDevRec.feEmailTo := '';     // Clear the To: fields
              PDevRec.feEmailToAddr := '';
              PDevRec.feEmailMsg := '';    // Clear down the message, so we don't get it multiple times.
              // Set up the email Subject
              PDevRec.feEmailSubj := 'Purchase Order - ' + OurRef + '. From '+Syss.UserName;

              if (PDevRec.fePrintMethod <> 0) then
              begin
                // Get the email address from the trader record, or the contacts/roles records.
                SetEcommsFromCust_TransRole(LCust, PDevRec, MTExLocal, true, LInv);
              end;
            end;

            // PKR. 25/11/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
            // If email method or xml method, and no email address, log an error
            ok2Print := true;

            if (useSuppDef) then
            begin
              if ((PDevRec.fePrintMethod = 2) or (PDevRec.fePrintMethod = 4)) and
                 ((Trim(PDevRec.feEmailTo) = '') or (Pos('@', PDevRec.feEmailTo) < 1)) then
              begin
                // Log the error.
                errorLog.Write_Msg(Format('WARNING.  %s was not emailed to %s (%s).',
                                          [OurRef, LCust.Company, LCust.CustCode]));
                errorLog.Write_Msg('No email address found on trader record or in trader contacts list.');
                errorLog.Write_Msg('');  // Add a blank line to separate entries.

                // Set the flag to indicate that we've logged something.
                errorLog.Got2Print := true;

                // Set the flag for this record so that we don't process it.
                if (PDevRec.fePrintMethod = 2) then
                begin
                  ok2Print := false;
                end
                else
                begin
                  // fePrintMethod = 4 (email and print)
                  // Still need to print if both email and printed required.
                  ok2Print := true;
                  LCust.InvDMode := 0; // Couldn't get an email address, so print only.
                end;
              end;
            end;

            // PKR. 07/12/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
            // If we got an email address, (or we're printing only)
            if (ok2Print) then
            begin
              If (LCust.FDefPageNo>0) then
                RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[25]
              else
                RForm:=LRForm;

              {$IFDEF FRM}
              // PKR. 03/12/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
              // POR run can include multiple email destinations, so use a batch-of-batches to
              //  implement it.
              // PKR. 11/12/2015. ABSEXCH-15333. Can now have multiple destination types.
              // Send_FrmPrint is driven by LCust.InvDMode, so is used only for Use Supplier Default.
              if (useSuppDef) then
              begin
                // PKR. Copied from PrintBPForm.  Same parameters as for pfAddBatchForm
                // with the addition of ecCommMode to control how it's handled.
                Ok2Print := Send_FrmPrint(PDevRec,
                                          DEFDEFMode[InvDocHed],
                                          RForm,
                                          InvF,
                                          InvOurRefK,
                                          OurRef,
                                          IdetailF,
                                          IdFolioK,
                                          FullNomKey(FolioNum),
                                          '',
                                          NIL,
                                          BOff,
                                          LCust.InvDMode);
              end
              else
              begin
                // Printing only. PDevRec.fePrintMethod is already set to Printer.
                Ok2Print:=pfAddBatchForm(PDevRec,
                                         DEFDEFMode[InvDocHed],
                                         RForm,
                                         InvF,
                                         InvOurRefK,
                                         OurRef,
                                         IdetailF,
                                         IdFolioK,
                                         FullNomKey(FolioNum),
                                         '',
                                         NIL,
                                         BOff);
              end;

              {* Set DocPrinted on Invoice or Credit Note *}
              LSet_PrintedStatus(((Not PDevRec.Preview) and (Ok2Print)),BOff,LInv);

              {$ENDIF} // IFDEF FRM
            end; {if ok to continue}

            // PKR. Copied from PrintBPForm.
            {v5.71 re establish the position prior to the update}
            LSetDataRecOfs(RFnum, RecAddr);
            LStatus:=LGetDirect(RFnum, RKeyPath,0);

            // Get the next record from the scratch file
            LStatus:=LFind_Rec(B_GetNext,RFnum,RKeyPath,KeyR);
          end; {With..}
        end; {while...}

        // PKR. 25/11/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
        // Done with the list of orders.
        // If there were any errors, print the log
        if (errorLog.Got2Print) then
        begin
          // We already picked up the printer details from the print dialog
          // This needs to go to preview as it is for the user only.
          PDevRec.feJobtitle := 'Stock Re-order error log';
          PDevRec.fePrintMethod := 0; // Printer
          PDevRec.feCoverSheet := '';
          PDevRec.Preview := true;
          PDevRec.NoCopies := 1;

          errorLog.PrintLog(PDevRec, 'Stock Re-Order Error Log');
        end;
      end; {With..}
    end; // If we have a scratch file
  end; {Proc..}


  //----------------------------------------------------------------------------
  // PKR. 03/12/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
  // This function is a modified version of the one in TPrintBPForm
  Function  TPrintPORForm.Send_FrmPrint( ecPrnInfo      : TSBSPrintSetupInfo;
                                   Const ecDefMode      : Integer;           
                                   Const ecFormName     : ShortString;       
                                   Const ecMFN, MKP     : Integer;           
                                   Const ecMKeyRef      : Str255;            
                                   Const ecTFN, TKP     : Integer;           
                                   Const ecTKeyRef      : Str255;
                                   Const ecDescr        : ShortString;       
                                   Const ecAddBatchInfo : StaCtrlRec;        
                                   Const ProcessErr     : Boolean;           
                                   Const ecCommMode     : Byte) : Boolean;
  var
    savePrintMethod : byte;
  Begin
    Result := false;

  {$IFDEF FRM}
    // The supplier default might be [print & email] or [print & fax], so we need to do both.
    // Printing
    If (ecCommMode In [0,3,4]) then
    Begin
      // Force printing (saving the current mode, which might be email+print or fax+print).
      savePrintMethod := ecPrnInfo.fePrintMethod;
      ecPrnInfo.fePrintMethod := 0;

      Result := pfAddBatchForm(ecPRnInfo, ecDefMode, ecFormName,
                                          ecMFN, MKP, ecMKeyRef,
                                          ecTFN, TKP, ecTKeyRef,
                                          ecDescr,
                                          ecAddBatchInfo,
                                          ProcessErr);

      // Restore the print method.
      ecPrnInfo.fePrintMethod := savePrintMethod;
    end;

    // Non-printing
    If (ecCommMode In [1..4]) and (Assigned(eCommFrmList)) then
    begin
      With eCommFrmList, MTExLocal^ do
      Begin
        Try
          Case ecCommMode of
           1, 2 : ecPrnInfo.fePrintMethod:=ecCommMode;  // fax or email
           3, 4 : ecPrnInfo.fePrintMethod:=ecCommMode-2; // fax or email with hard copy
          end;

          If (ecPrnInfo.fePrintMethod = 1) then {* Set Fax destination Printer *}
            ecPrnInfo.DevIdx:=pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN)
          else
            If (ecPrnInfo.fePrintMethod=2) then {* Set Email destination printer *}
            begin
              With ecPrnInfo do
              Begin
                DevIdx:=pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.EmailPrnN);

                // MH 14/02/14 v7.0.9 ABSEXCH-15061: Modified as was causing multiple semi-colon's on the end which was crashing MAPI
                //                                   Copied from TGenReport.Send_FrmPrint
                //PR: 19/05/2014 ABSEXCH-15327 All names and addresses should now be in feEmailTo
                While (Length(feEmailTo) > 0) And (feEmailTo[Length(feEmailTo)] = ';') Do
                  System.Delete (feEmailTo, Length(feEmailTo), 1);
                feEmailTo := feEmailTo + ';';

                If (UserProfile^.EmailAddr='') or (Not UserProfile^.Loaded) then
                  feEmailFromAd:= SyssEDI2^.EDI2Value.EmAddress
                else
                  feEmailFromAd:= UserProfile^.EmailAddr;

                If (UserProfile^.UserName='') or (Not UserProfile^.Loaded) then
                  feEmailFrom:= SyssEDI2^.EDI2Value.EmName
                else
                  feEmailFrom:= UserProfile^.UserName;
              end; // with ecPrnInfo
            end; // if fePrintMethod = 2

          AddeCommVisiRec(ecPrnInfo,
                         ecDefMode,
                         ecFormName,
                         ecMFN, MKP,
                         ecMKeyRef,
                         ecTFN, TKP,
                         ecTKeyRef,
                         ecDescr,
                         dbFormatName(LCust.CustCode,LCust.Company),
                         ecAddBatchInfo);
          Result := true;
        except
          Result := false;
        end;
      end;
    end;
    {$ENDIF}
  end;


  //----------------------------------------------------------------------------
  Procedure TPrintPORForm.Process;

  Begin
    Inherited Process;

    ShowStatus(0,'Print Purchase Order Run');

    Print_PORRun;

  end;


  //----------------------------------------------------------------------------
  Procedure TPrintPORForm.Finish;


  Begin
    If (Assigned(ThisScrt)) then
      Dispose(ThisScrt,Done);
                           {Off}
    Inherited Finish;

  end;



//==============================================================================
// This is called after the Stock Reorder list has been scanned, and a scratch file
// of records to process has been created.
  Procedure Start_PORThread( AOwner     :  TObject;
                             MTEx       :  tdPostExLocalPtr;
                             TScrt      :  Scratch2Ptr;
                             FormRep    :  PFormRepPtr);


  Var
    LCheck_Stk :  ^TPrintPORForm;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin
          MTExLocal:=MTEx;
          ThisScrt:=TScrt;

          //PR: 24/08/2012 ABSEXCH-12650 Close files in use as they need to be reopened in the
          //print thread for the emulator.
          MTExLocal.Close_Files;

          //PR: 21/03/2014 ABSEXCH-14853 Save scratchfile process id as we'll need it in the thread
          ScratchProcessId := ThisScrt.Process;
          Dispose(ThisScrt, Done);

          If (Start(0)) and (Create_BackThread) then
          Begin
            If (Assigned(FormRep)) then
            Begin
              FormRepPtr^:=FormRep^;
              FormRepPtr^.PParam.RepCaption:='Print Order Run';
            end;

            // Add the task to the thread queue.
            With BackThread do
              AddTask(LCheck_Stk,FormRepPtr^.PParam.RepCaption);
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;




    { ========== TPrintBPForm methods =========== }

  Constructor TPrintBPForm.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    PORMode:=BOn;

    BaseObj:=BOn;


  end;


  Destructor TPrintBPForm.Destroy;

  Begin

    Inherited Destroy;

  end;




  {* Procedure to direct Form print to normal Add Batch routine, or eComms list *}
  {******** This routine replicated in ReportU for statement printing }


  Function  TPrintBPForm.Send_FrmPrint(  ecPrnInfo    : TSBSPrintSetupInfo;
                                   Const ecDefMode    : Integer;
                                   Const ecFormName   : ShortString;
                                   Const ecMFN, MKP   : Integer;
                                   Const ecMKeyRef    : Str255;
                                   Const ecTFN, TKP   : Integer;
                                   Const ecTKeyRef    : Str255;
                                   Const ecDescr      : ShortString;
                                   Const ecAddBatchInfo
                                                      : StaCtrlRec;
                                   Const ProcessErr   : Boolean;
                                   Const ecCommMode   : Byte)   :   Boolean;


Begin
  Result:=BOff;

  {$IFDEF FRM}
     If (ecCommMode In [0,3,4]) or (Not Assigned(eCommFrmList)) or (ecPrnInfo.Preview) then
     Begin
       Result:=pfAddBatchForm(ecPRnInfo,ecDefMode,ecFormName,
                                         ecMFN,MKP,ecMKeyRef,
                                         ecTFN,TKP,ecTKeyRef,
                                         ecDescr,
                                         ecAddBatchInfo,
                                         ProcessErr);


     end;

     If (ecCommMode In [1..5]) and (Assigned(eCommFrmList)) and (Not ecPrnInfo.Preview) then
     With eCommFrmList, MTExLocal^ do
     Begin
       Try
         Case ecCommMode of
           1,2  :  ecPrnInfo.fePrintMethod:=ecCommMode;
           3,4  :  ecPrnInfo.fePrintMethod:=ecCommMode-2;
           //PR: 27/04/2016 ABSEXCH-10939 Add support for xml (to file only)
           5    : begin
                    ecPrnInfo.fePrintMethod := 3; //eBis XML
                    ecPrnInfo.feXMLType := 0; //File
                  end;
         end;

         If (ecPrnInfo.fePrintMethod=1) then {* Set Fax destination Printer *}
           ecPrnInfo.DevIdx:=pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN)
         else
           If (ecPrnInfo.fePrintMethod=2) then {* Set Email destination printer *}
           With ecPrnInfo do
           Begin
             DevIdx:=pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.EmailPrnN);

             //feEmailTo:=feEmailTo+';'+feEmailToAddr+';';

             // MH 14/02/14 v7.0.9 ABSEXCH-15061: Modified as was causing multiple semi-colon's on the end which was crashing MAPI
             //                                   Copied from TGenReport.Send_FrmPrint
             //PR: 19/05/2014 ABSEXCH-15327 All names and addresses should now be in feEmailTo
             // feEmailTo:=feEmailTo+';'+feEmailToAddr;
             While (Length(feEmailTo) > 0) And (feEmailTo[Length(feEmailTo)] = ';') Do
               System.Delete (feEmailTo, Length(feEmailTo), 1);
             feEmailTo := feEmailTo + ';';

             If (UserProfile^.EmailAddr='') or (Not UserProfile^.Loaded) then
               feEmailFromAd:= SyssEDI2^.EDI2Value.EmAddress
             else
               feEmailFromAd:= UserProfile^.EmailAddr;

             If (UserProfile^.UserName='') or (Not UserProfile^.Loaded) then
               feEmailFrom:= SyssEDI2^.EDI2Value.EmName
             else
               feEmailFrom:= UserProfile^.UserName;


           end;

         //PR: 27/04/2016 ABSEXCH-10939 If xml only allow if eBusiness licenced
         if (ecCommMode < 5) or eBusModule then
           AddeCommVisiRec(ecPrnInfo,
                           ecDefMode,
                           ecFormName,
                           ecMFN, MKP,
                           ecMKeyRef,
                           ecTFN, TKP,
                           ecTKeyRef,
                           ecDescr,
                           dbFormatName(LCust.CustCode,LCust.Company),
                           ecAddBatchInfo);
         Result:=BOn;

       except
         Result:=BOff;
       end;


     end;


  {$ENDIF}
end;



function TPrintBPForm.RightFEAcc(Const SFiltBy,StatDMode  :  Byte)  :  Boolean;


Begin
  {0 = Include All
   1 = Hard Copy versions
   2 = Fax Only
   3 = Email Only}

  Result:=(SFiltBy=0) or ((SFiltBy=1) and (StatDMode In [0,3,4]))
         or ((SFiltBy=2) and (StatDMode=1))
         or ((SFiltBy=3) and (StatDMode=2))
         //PR: 27/04/2016 ABSEXCH-10939 Add xml 
         or ((SFiltBy = 4) and (StatDMode = 5) and eBusModule);

end;






  Procedure TPrintBPForm.Print_PPYRun;

  Const
    RFnum =InvF;

    RKeyPath =InvBatchK;

    FMode  :  Array[BOff..BOn] of Byte = (5,14);


  Var
    LRForm  :  Str255;

    RecAddr :  LongInt;

    n       :  Byte;

    IsC,
    Ok2Print,
    FoundOk :  Boolean;

    KeyR,
    KeyRef  :  Str255;

    LocalPDevRec
            :  TSBSPrintSetupInfo;

    PapCust    :  CustRec;




  Begin
    Ok2Print:=BOn;

    With FormRepPtr^,PParam,MTExLocal^do
    Begin
      PapCust:=LCust;

      StartPrintJob;

      LRForm:=RForm;

      ShowStatus(1,'Generating Batch Print Run:-');


      KeyRef:=RepKey;
      KeyR:=KeyRef;


      LStatus:=LFind_Rec(B_GetGEq,RFnum,RKeyPath,KeyR);

      While (LStatusOk) and (CheckKey(KeyRef,KeyR,Length(KeyRef),BOn)) and ((Not ThreadRec^.THAbort)) and (Ok2Print) do
      With LInv do
      Begin
        ShowStatus(2,'Printing '+OurRef);

        If (LCust.CustCode<>CustCode) then {* Get Cust record for form def switch over *}
          LGetMainRec(CustF,CustCode);

        IsC:=IsACust(LCust.CustSupp);

        If (LCust.FDefPageNo>0) then
          RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[FMode[IsC]]
        else
          RForm:=LRForm;

        {$IFDEF FRM}
          PapCust:=Link_CustHO(LCust.RemitCode);

          Blank(PDevRec.feEmailMsg,Sizeof(PDevRec.feEmailMsg));
          Blank(PDevRec.feFaxMsg,Sizeof(PDevRec.feFaxMsg));

          // MH 14/02/14 v7.0.9 ABSEXCH-15061: Switch to pickup the roles
          //SetEcommsFromCust(PapCust,PDevRec,MTExLocal,BOn);
          SetEcommsFromCust_TransRole(PapCust,PDevRec,MTExLocal,BOn, LInv);
          // MH 14/02/14 v7.0.9 ABSEXCH-15061: Have to switch the fields around as the Print To dialog is being skipped
          //PR: 19/05/2014 ABSEXCH-15327 All names and addresses should now be in feEmailTo so remove switch

          PDevRec.feEmailsubj:='Payment notification from '+Syss.UserName;

          PDevRec.feFaxMsg:=PDevRec.feEmailsubj+#10+#13+PDevRec.feFaxMsg;
          PDevRec.feEmailMsg:=PDevRec.feEmailsubj+#10+#13+PDevRec.feEmailMsg;

          If (RightFEAcc(SFiltX,LCust.StatDMode)) then
            Ok2Print:=Send_FrmPrint(PDevRec,2,RForm,
                         InvF,InvOurRefK,OurRef,
                         PWrdF,HelpNDXK,FullMatchKey(MatchTCode,MatchSCode,OurRef),
                         '',
                         NIL,
                         BOff,
                         PapCust.StatDMode);

           {* Set DocPrinted on Invoice or Credit Note *}
            {LSet_PrintedStatus(((Not PDevRec.Preview) and (Ok2Print)),BOff,LInv);}

        {$ENDIF}

        LStatus:=LFind_Rec(B_GetNext,RFnum,RKeyPath,KeyR);

      end; {With..}
    end; {With..}
  end; {Proc..}




  Procedure TPrintBPForm.Process;

  Begin
    Inherited Process;

    ShowStatus(0,'Print Batch Run');

    {$IFDEF FRM}
      try
        eCommFrmList:=TeCommFrmList.Create;
      except
        eCommFrmList.Destroy;
        eCommFrmList:=nil;
      end; {try..}
    {$ENDIF}




    If (BaseObj) then
      Print_PPYRun;

  end;


  Procedure TPrintBPForm.Finish;


  Begin

    Inherited Finish;

  end;



  Procedure Start_PPYThread( AOwner     :  TObject;
                             MatchK     :  Str255;
                             FormRep    :  PFormRepPtr);


  Var
    LCheck_Stk :  ^TPrintBPForm;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin

          RepKey:=MatchK;

          If (Start(0)) and (Create_BackThread) then
          Begin
            If (Assigned(FormRep)) then
            Begin
              FormRepPtr^:=FormRep^;
              FormRepPtr^.PParam.RepCaption:='Print Batch Run';
            end;

            With BackThread do
              AddTask(LCheck_Stk,FormRepPtr^.PParam.RepCaption);
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


{$IFDEF JC}
      { ========== TPrintJCSBForm methods =========== }

  Constructor TPrintJCSBForm.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    BaseObj:=BOff;
  end;


  Destructor TPrintJCSBForm.Destroy;

  Begin

    Inherited Destroy;

  end;



  Procedure TPrintJCSBForm.Print_SelfBillRun;

  Const
    RFnum =InvF;

    RKeyPath =InvRNoK;


  Var
    LRForm  :  Str255;

    RecAddr :  LongInt;

    n       :  Byte;

    B_Func  :  Integer;

    IsC,
    Ok2Print,
    FoundOk :  Boolean;

    KeyR,
    KeyRef  :  Str255;

    LocalPDevRec
            :  TSBSPrintSetupInfo;



  Begin
    Ok2Print:=BOn;  B_Func:=B_GetNext;

    With FormRepPtr^,PParam,MTExLocal^ do
    Begin
      StartPrintJob;

      LRForm:=RForm;

      ShowStatus(1,'Generating Self Billing Print Run:-');


      KeyRef:=FullNomKey(JCSelfBillRunNo)+DocCodes[PIN][1];
      KeyR:=KeyRef;


      LStatus:=LFind_Rec(B_GetGEq,RFnum,RKeyPath,KeyR);

      While (LStatusOk) and (CheckKey(KeyRef,KeyR,Length(KeyRef),BOn)) and ((Not ThreadRec^.THAbort)) and (Ok2Print) do
      With LInv do
      Begin
        B_Func:=B_GetNext;

        ShowStatus(2,'Printing '+OurRef);

        If (LCust.CustCode<>CustCode) then {* Get Cust record for form def switch over *}
          LGetMainRec(CustF,CustCode);

        IsC:=IsACust(LCust.CustSupp);

        If (LCust.FDefPageNo>0) then
          RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[47]
        else
          RForm:=LRForm;

        {$IFDEF FRM}


          SetEcommsFromCust(LCust,PDevRec,MTExLocal,BOn);

          PDevRec.feEmailsubj:='Self Billing Invoice from '+Syss.UserName;


          PDevRec.feFaxMsg:=PDevRec.feEmailsubj+#10+#13+PDevRec.feFaxMsg;
          PDevRec.feEmailMsg:=PDevRec.feEmailsubj+#10+#13+PDevRec.feEmailMsg;

          If (RightFEAcc(SFiltX,LCust.StatDMode)) then
            Ok2Print:=Send_FrmPrint(PDevRec,1,RForm,
                         InvF,InvOurRefK,OurRef,
                         IdetailF,IdFolioK,FullNomKey(FolioNum),
                         '',
                         NIL,
                         BOff,
                         LCust.StatDMode);

           {* Set DocPrinted on Invoice or Credit Note *}
           LSet_PrintedStatus(((Not PDevRec.Preview) and (Ok2Print)),BOff,LInv);

           If (Ok2Print) then {Reset Run Nos}
           Begin

             RunNo:=0;  {* Reset Header *}

             LStatus:=LPut_Rec(RFnum,RKeyPath);

             LReport_BError(Fnum,LStatus);

             If (LStatusOk) then
             Begin
               Reset_NomTxfrLines(LInv,MTExLocal); {* Reset Lines *}
               B_Func:=B_GetGEq;
             end;

           end;


        {$ENDIF}

        LStatus:=LFind_Rec(B_Func,RFnum,RKeyPath,KeyR);

      end; {With..}
    end; {With..}
  end; {Proc..}




  Procedure TPrintJCSBForm.Process;

  Begin
    Inherited Process;

    Print_SelfBillRun;
    
  end;


  Procedure Start_JCSBThread( AOwner     :  TObject;
                              FormRep    :  PFormRepPtr);


  Var
    LCheck_Stk :  ^TPrintJCSBForm;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin

          If (Start(0)) and (Create_BackThread) then
          Begin
            If (Assigned(FormRep)) then
            Begin
              FormRepPtr^:=FormRep^;
              FormRepPtr^.PParam.RepCaption:='Self Billing Run';
            end;

            With BackThread do
              AddTask(LCheck_Stk,FormRepPtr^.PParam.RepCaption);
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;




    { ========== TPrintJCJAForm methods =========== }

    Constructor TPrintJCJAForm.Create(AOwner  :  TObject);

    Begin
      Inherited Create(AOwner);

      BaseObj:=BOff;
    end;


    Destructor TPrintJCJAForm.Destroy;

    Begin

      Inherited Destroy;

    end;


    { == Similar routine available for reports in Report1U; LRepGetJobMisc == }

    Function TPrintJCJAForm.LGetJobMisc(ACode  :  Str10;
                                        GMode  :  Byte)  :  Boolean;

    Const
      Fnum     = JMiscF;
      Keypath  = JMK;


    Var
      KeyChk  :  Str255;


    Begin
      KeyChk:=FullJAKey(JARCode,JASubAry[GMode],ACode);

      With MTExLocal^ do
      Begin
        LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyChk);

        Result:=LStatusOk;
      end;

    end;


    Procedure TPrintJCJAForm.Print_JAppsRun;

    Const
      RFnum =InvF;

      RKeyPath =InvRNoK;


    Var
      LRForm  :  Str255;

      RecAddr2,
      RecAddr :  LongInt;

      DM,DM2,
      n       :  Byte;

      B_Func  :  Integer;

      LOk,
      IsC,
      Ok2Print,
      FoundOk :  Boolean;

      KeyR,
      KeyRef  :  Str255;

      LocalPDevRec
              :  TSBSPrintSetupInfo;



    Procedure Add_PrintJob;
    Begin
      {$IFDEF FRM}
        With FormRepPtr^,PParam,MTExLocal^,LInv,jpAppCtrlRec do
        Begin

          SetEcommsFromCust(LCust,PDevRec,MTExLocal,BOn);

          PDevRec.feEmailsubj:='Application Certificate from '+Syss.UserName;

          PDevRec.feFaxMsg:=PDevRec.feEmailsubj+#10+#13+PDevRec.feFaxMsg;
          PDevRec.feEmailMsg:=PDevRec.feEmailsubj+#10+#13+PDevRec.feEmailMsg;

          If (RightFEAcc(SFiltX,LCust.StatDMode)) then
            Ok2Print:=Send_FrmPrint(PDevRec,1,RForm,
                         InvF,InvOurRefK,OurRef,
                         IdetailF,IdFolioK,FullNomKey(FolioNum),
                         '',
                         NIL,
                         BOff,
                         LCust.StatDMode);

           {* Set DocPrinted on Invoice or Credit Note *}
           LSet_PrintedStatus(((Not PDevRec.Preview) and (Ok2Print)),BOff,LInv);
        end; {With..}
      {$ENDIF}
    end;

    Procedure Find_PrintMatch(InvR  :  InvRec);

    Const
      Fnum2     =  PWrdF;
      Keypath2  =  PWK;

    Var
      KeyM,
      KeyI,
      KeyChkM   :  Str255;

      TmpStat,
      TmpKPath   :  Integer;

      
      TmpRecAddr
                :  LongInt;

      KeepRForm :  String;


    Begin
      With FormRepPtr^,PParam,MTExLocal^ do
      Begin
        KeepRForm:=RForm;

//        If (LCust.FDefPageNo>=0) then
          RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[DM2];

        TmpKPath:=RKeypath;

        TmpStat:=LPresrv_BTPos(RFnum,TmpKPath,LocalF^[RFnum],TmpRecAddr,BOff,BOff);

        KeyChkM:=FullMatchKey(MatchTCode,MatchSCode,InvR.OurRef);
        KeyM:=KeyChkM;

        LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeyM);

        While (LStatusOk) and (CheckKey(KeyChkM,KeyM,Length(KeyChkM),BOn)) and ((Not ThreadRec^.THAbort)) {and (Ok2Print)} do
        With LPassword.MatchPayRec do
        Begin
          KeyI:=PayRef;

          LStatus:=LFind_Rec(B_GetEq,RFnum,InvOurRefK,KeyI);

          If (LStatusOk) and (LInv.InvDocHed In JAPJAPSplit) then
          Begin
            Add_PrintJob;

          end;

          LStatus:=LFind_Rec(B_GetNext,Fnum2,KeyPath2,KeyM);

        end; {While..}

        TmpStat:=LPresrv_BTPos(RFnum,TmpKPath,LocalF^[RFnum],TmpRecAddr,BOn,BOff);

        LInv:=InvR;

        RForm:=KeepRForm;
      end; {With..}
    end;

    Begin
      Ok2Print:=BOn;  B_Func:=B_GetNext; LOK:=BOff;

      With FormRepPtr^,PParam,MTExLocal^,jpAppCtrlRec do
      Begin
        StartPrintJob;

        LRForm:=RForm;


        ShowStatus(1,'Generating Application Print Run:-');

        KeyRef:=FullNomKey(awPRun)+DocCodes[awCertDT][1];

        KeyR:=KeyRef;


        LStatus:=LFind_Rec(B_GetGEq,RFnum,RKeyPath,KeyR);

        While (LStatusOk) and (CheckKey(KeyRef,KeyR,Length(KeyRef),BOn)) and ((Not ThreadRec^.THAbort)) {and (Ok2Print)} do
        With LInv do
        Begin
          B_Func:=B_GetNext;

          LStatus:=LGetPos(RFnum,RecAddr2);

          ShowStatus(2,'Printing '+OurRef);

          If (LCust.CustCode<>CustCode) then {* Get Cust record for form def switch over *}
            LGetMainRec(CustF,CustCode);

          IsC:=IsACust(LCust.CustSupp);

          If (InvDocHed In PurchSplit) then
          Begin
            LOk:=LGetJobMisc(FullEmpCode(LInv.CISEmpl),3);

            With LJobMisc^.EmplRec do
              If (LOk) and (GSelfBill) then
                DM:=47
              else
                DM:=22;

            RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[DM];


            DM2:=60;

            {DM2:=DM;}

          end
          else
          Begin
            RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[6];

            DM2:=61;

            {DM2:=6;}
          end;

          {$IFDEF FRM}

            try

             If (awPrintCert) then
               Find_PrintMatch(LInv);

             If (awPrintInv) then
               Add_PrintJob
             else
               Ok2Print:=BOn;

            finally
             {If (Ok2Print) then {Reset Run Nos}

             {v5.61 re establish the position prior to the update}
             LSetDataRecOfs(RFnum,RecAddr2);

             LStatus:=LGetDirect(RFnum,RKeyPath,0);

             If (LStatusOk) then
             Begin


               RunNo:=0;

               CustSupp:=TradeCode[(InvDocHed In SalesSplit)];

               Set_DocAlcStat(LInv);  {* Set Allocation Status *}

               LStatus:=LPut_Rec(RFnum,RKeyPath);

               LReport_BError(RFnum,LStatus);

               If (LStatusOk) then
               With LInv do
               Begin
                 If (Not Syss.UpBalOnPost) then
                   UpdateBal(LInv,(ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                          (ConvCurrICost(LInv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                          (ConvCurrINet(LInv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                          BOff,2);

                  B_Func:=B_GetGEq;
               end;

             end;
           end; {try..}

          {$ENDIF}

          LStatus:=LFind_Rec(B_Func,RFnum,RKeyPath,KeyR);

        end; {With..}
      end; {With..}
    end; {Proc..}




    Procedure TPrintJCJAForm.Process;

    Begin
      Inherited Process;

      Print_JAppsRun;
    end;


    Procedure Start_JCJAThread( AOwner       :  TObject;
                                FormRep      :  PFormRepPtr;
                                jpAppPrnRec  :  tJAppWizRec);


    Var
      LCheck_Stk :  ^TPrintJCJAForm;

    Begin

      If (Create_BackThread) then
      Begin
        New(LCheck_Stk,Create(AOwner));

        try
          With LCheck_Stk^ do
          Begin

            If (Start(0)) and (Create_BackThread) then
            Begin
              If (Assigned(FormRep)) then
              Begin
                FormRepPtr^:=FormRep^;
                FormRepPtr^.PParam.RepCaption:='Certificate Run';
              end;

              jpAppCtrlRec:=jpAppPrnRec;

              With BackThread do
                AddTask(LCheck_Stk,FormRepPtr^.PParam.RepCaption);
            end
            else
            Begin
              Set_BackThreadFlip(BOff);
              Dispose(LCheck_Stk,Destroy);
            end;
          end; {with..}

        except
          Dispose(LCheck_Stk,Destroy);

        end; {try..}
      end; {If process got ok..}

    end;





{$ENDIF}


      { ========== TPrintFormList methods =========== }

  Constructor TPrintFormList.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    TheList:=nil;

    PORMode:=BOn;
  end;


  Destructor TPrintFormList.Destroy;

  Begin
    If (Assigned(TheList)) then
    Begin
      TheList.Free;
      TheList:=nil;
    end;

    Inherited Destroy;

  end;




  Procedure TPrintFormList.Print_TheList;

  Var
    n          :  Integer;
    Ok2Print   :  Boolean;


  Begin
    If (Assigned(TheList)) then
    With TheList do
    Begin
      ShowStatus(1,'Generating Batch Print Run:-');

      StartPrintJob;

      For n:=0 to Pred(Count) do
      With IdRec(n)^ do
      Begin
        ShowStatus(2,'Printing '+PKeyRef);

        {$IFDEF FRM}

          Ok2Print:=pfAddBatchForm(PParam.PDevRec,DefMode,RForm,
                                   PFnum,PKeyPath,PKeyRef,
                                   Fnum,KeyPath,KeyRef,
                                   'Print Batch of Documents.',
                                   NIL,
                                   BOff);

           {* Set DocPrinted on Invoice or Credit Note *}
            {LSet_PrintedStatus(((Not PDevRec.Preview) and (Ok2Print)),BOff,LInv);}

        {$ENDIF}


        If (ThreadRec^.THAbort) or (Not Ok2Print) then
          Break;
      end;
    end;

  end; {Proc..}




  Procedure TPrintFormList.Process;

  Begin
    Inherited Process;

    ShowStatus(0,'Print Batch Run');

    Print_TheList;

  end;


  Procedure TPrintFormList.Finish;


  Begin

    Inherited Finish;

  end;



  Procedure Print_BatchList( AOwner     :  TObject;
                             RList      :  TPFormList);


  Var
    LCheck_Stk :  ^TPrintFormList;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin

          If (Assigned(RList)) then
            TheList:=RList;

          If (Start(0)) and (Create_BackThread) then
          Begin
            If (Assigned(TheList)) then
            Begin
              
              If (TheList.HasItems) then
              Begin
                FormRepPtr^.PParam.RepCaption:='Print Batch Run';
                FormRepPtr^.PParam.PDevRec:=TheList.IdRec(0)^.PParam.PDevRec;
              end;
            end;

            With BackThread do
              AddTask(LCheck_Stk,FormRepPtr^.PParam.RepCaption);
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;



    { ========== TPrintDocRange methods =========== }

  Constructor TPrintDocRange.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    BaseObj:=BOff;

    ThisScrt:=nil;

    PORMode:=BOn;
  end;


  Destructor TPrintDocRange.Destroy;

  Begin

    Inherited Destroy;


  end;


    { ====== Function to Test end of loop ====== }


  Function TPrintDocRange.DPInclude(KeyS  :  Str255)  :  Boolean;


  Begin
    Result := False;
    With FormRepPtr^ do
    Case ReportMode of

      1  :  Result:=CheckKey(CoKey,KeyS,3,BOff);  {* Only check first 3 chars for doc type *}

      2  :  Result:=CheckKey(CoKey,KeyS,Length(CoKey),BOff);

    end; {Case..}


  end; {Func..}


  { ======= Function to Check for Document inclusion ======== }

  Function  TPrintDocRange.DPCheck  :  Boolean;

  Begin

    With FormRepPtr^ do
    Begin
      UseCustomForm:=BOff;

      With MTExLocal^,LInv do
        Result:=((TransDate>=Sdate) and (TransDate<=Edate)) and ((RCr=Currency) or (RCr=0)) and ((NomAuto) or (InvDocHed In BatchSet)) 
                 and ((InvDocHed In DefPrnSet) or (ReportMode<>2)) and ((ReportMode<>2) or ((OurRef>=CStart) and (OurRef<=CEnd)));

      {$IFDEF CU}
        If (Result) and (UseCustomFilter) then {Apply any external filters}
        Begin
          UseCustomForm:=LExecuteHookEvent(2000,104,MTExLocal^);
          Result:=UseCustomForm;
        end;
      {$ENDIF}
    end;  


  end;


  Procedure TPrintDocRange.Process_DPSort;

  Var
    RecAddr  :  LongInt;
    KeyR     :  Str255;

  Begin


    With MTExLocal^,FormRepPtr^ do
    Begin
      KeyR:=CoKey;

      RecAddr:=0;


      ShowStatus(2,'Please Wait... Sorting Documents');

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyR);

      While (LStatusOk) and ((Not ThreadRec^.THAbort)) and (DPInclude(KeyR)) and (LInv.OurRef<=CEnd) do
      With LInv do
      Begin

        If (DPCheck) then
        Begin

          LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

          ThisScrt^.Add_Scratch(Fnum,Keypath,RecAddr,CustCode,'');

        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyR);

      end; {While..}
    end; {With..}
  end;




  Procedure TPrintDocRange.Print_DocRange;


  Var
    LRForm  :  Str255;

    RFnum,
    RKeyPath:  Integer;

    RecAddr2,
    RecAddr :  LongInt;

    n,PM    :  Byte;

    Ok2Print,
    FoundOk :  Boolean;

    KeyR,
    KeyRef  :  Str255;

    iDeliveryMode : Byte;

  Begin
    Ok2Print:=BOn;  RecAddr2:=0;

    With FormRepPtr^,PParam,MTExLocal^ do
    Begin
      ShowStatus(1,'Generating Documents:-');


      If (AccSort) then
      Begin

        New(ThisScrt,Init(10,MTExLocal,BOff));

        Process_DPSort;

        RFnum:=ReportF;

        RKeypath:=RPK;

        CoKey:=FullNomKey(10);
      end
      else
      Begin
        RFnum:=Fnum;
        RKeyPath:=Keypath;

      end;

      KeyR:=CoKey;


      StartPrintJob;

      LRForm:=RForm;

      LStatus:=LFind_Rec(B_GetGEq,RFnum,RKeyPath,KeyR);

      While (LStatusOk) and (Ok2Print) and (DPInclude(KeyR))
              and ((Not ThreadRec^.THAbort))
              and (((LInv.OurRef<=CEnd) or (ReportMode=2)) or ((AccSort) and (CheckKey(CoKey,KeyR,Length(CoKey),BOn)))) do
      With LInv do
      Begin

        If (AccSort) then {* preserve *}
        Begin

          ThisScrt^.Get_Scratch(LRepScr^);
        end;

        If (DPCheck) then
        Begin
          LStatus:=LGetPos(RFnum,RecAddr2);


          ShowStatus(2,'Printing Document '+OurRef);

          If (LCust.CustCode<>CustCode) then {* Get Cust record for form def switch over *}
            LGetMainRec(CustF,CustCode);

          {* Need to override as we do not really know which doc types being printed *}
          {* If required, a flag could be used on RepInpPU to force the input form to be used *}

          {$IFNDEF SENT} {Sentimail has its own version of thExLocal which las LCtrlStr missing}
            If (UseCustomForm) and (LCtrlStr<>'') and (UseCustomFilter) then
              RForm:=LCtrlStr
            else
          {$ENDIF}
          Begin
            If (Not UseOwnForm) then
            begin
              {$IFDEF EXSQL}
              if SQLUtils.UsingSQL and Assigned(MTExLocal)  then
                RForm:=LGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[EntDefPrnMode[InvDocHed]]
              else
              {$ENDIF}
                RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[EntDefPrnMode[InvDocHed]]

            end
            else
              RForm:=LRForm;
          end;

          {$IFDEF FRM}
            PDevRec.feFaxMsg:='';
            PDevRec.feEmailMsg:='';

            If (UsePaperless) then
              // MH 13/10/2014 v7.0.12 ABSEXCH-15413: Modified to support Contact Roles
              //SetEcommsFromCust(LCust,PDevRec,MTExLocal,BOn)
              SetEcommsFromCust_TransRole(LCust, PDevRec, MTExLocal, BOn, LInv)
            else
              InitEmailText (PDevRec);

            PDevRec.feEmailsubj:=DocNames[InvDocHed]+' '+OurRef+' from '+Syss.UserName;

            PDevRec.feFaxMsg:=PDevRec.feEmailsubj+#10+#13+PDevRec.feFaxMsg;
            PDevRec.feEmailMsg:=PDevRec.feEmailsubj+#10+#13+PDevRec.feEmailMsg;

            // MH 06/05/08: Modified to use Remittance Delivery Mode for PPY's because of problems
            // at Garden & Leisure
            If (LInv.InvDocHed = PPY) Then
              iDeliveryMode := LCust.StatDMode
            Else
              iDeliveryMode := LCust.InvDMode;

            If (UsePaperLess) then
              // MH 06/05/08: Modified to use Remittance Delivery Mode for PPY's because of problems
              // at Garden & Leisure
              PM:=iDeliveryMode
              //PM:=LCust.InvDMode
            else
              PM:=0;

            // MH 06/05/08: Modified to use Remittance Delivery Mode for PPY's because of problems
            // at Garden & Leisure
            //If (Not UsePaperLess) or (RightFEAcc(SFiltX,LCust.InvDMode)) then
            If (Not UsePaperLess) or (RightFEAcc(SFiltX,iDeliveryMode)) then
            Begin  // MH 14/10/2014 v7.0.12 ABSEXCH-15727: Added Begin/End so the printed flag only gets set if it is printed
              Ok2Print:=Send_FrmPrint(PDevRec,DEFDEFMode[InvDocHed],RForm,
                           InvF,InvOurRefK,OurRef,
                           IdetailF,IdFolioK,FullNomKey(FolioNum),
                           '',
                           NIL,
                           BOff,
                           PM);

              {Ok2Print:=pfAddBatchForm(PDevRec,DEFDEFMode[InvDocHed],RForm,
                                       InvF,InvOurRefK,OurRef,
                                       IdetailF,IdFolioK,FullNomKey(FolioNum),
                                       '',
                                       NIL,
                                       BOff);}

              {* Set DocPrinted on Invoice or Credit Note *}
              LSet_PrintedStatus(((Not PDevRec.Preview) and (Ok2Print)),BOff,LInv);
            End; // If (Not UsePaperLess) or (RightFEAcc(SFiltX,iDeliveryMode))
          {$ENDIF}

          {v5.71 re establish the position prior to the update}
          LSetDataRecOfs(RFnum,RecAddr2);

          LStatus:=LGetDirect(RFnum,RKeyPath,0);

        end;{ If..}

        LStatus:=LFind_Rec(B_GetNext,RFnum,RKeyPath,KeyR);

      end; {With..}
    end; {While..}
  end; {Proc..}




  Procedure TPrintDocRange.Process;

  Begin
    Inherited Process;

    ShowStatus(0,'Print Document Range');

    Print_DocRange;

  end;


  Procedure TPrintDocRange.Finish;


  Begin
    If (Assigned(ThisScrt)) then
      Dispose(ThisScrt,Done);

    Inherited Finish;

  end;




  Procedure Start_DocRange( AOwner     :  TObject;
                            FormRep    :  PFormRepPtr);


  Var
    LCheck_Stk :  ^TPrintDocRange;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin

          If (Start(0)) and (Create_BackThread) then
          Begin
            If (Assigned(FormRep)) then
            With FormRepPtr^ do
            Begin
              FormRepPtr^:=FormRep^;
              FormRepPtr^.PParam.RepCaption:='Print Doc Range';

              Fnum:=InvF;
              ReportMode:=1;

              If (EmptyKey(CEnd,DocKeyLen)) then
                CEnd:=NdxWeight;

              If (EmptyKey(CustFilt,CustKeyLen)) then
              Begin

                Keypath:=InvOurRefK;

                CoKey:=CStart;


              end
              else
              Begin

                CoKey:=CustFilt;

                Keypath:=InvCustK;

                ReportMode:=2;

                If (EmptyKey(CEnd,DocKeyLen)) then
                  CEnd:=NdxWeight;

              end;

            end;

            With BackThread do
              AddTask(LCheck_Stk,FormRepPtr^.PParam.RepCaption);
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;

{$IFDEF FRM}

  { == Object to control Creation of posting log report == }

   { ====================== TPostLog Methods ===================== }


  Constructor TPostLog.Create;

  Begin
    Inherited Create;

    fGot2Print:=BOff;
  end;



  Destructor TPostLog.Destroy;

  Begin

    Inherited Destroy;
  end;


  Procedure TPostLog.Write_MsgDD(S  :  String;
                                 DK :  Str255;
                                 DM :  Byte);
  Var
    DPtr  :  tMemoDDRec;

  Begin
    If (Trim(DK)<>'') then
    Begin
      DPtr:=tMemoDDRec.Create;

      Blank(DPtr.DDKey,Sizeof(DPtr.DDKey));

      With DPtr do
      Begin
        DDKey:=DK;
        DDMode:=DM;
      end;

      AddObject(S,DPtr);
    end
    else
      Add(S);
  end;

  Procedure TPostLog.Write_Msg(S  :  String);

  Begin
    Write_MsgDD(S,'',0);

  end;


  Procedure TPostLog.PrintLog(Const PostRepCtrl  :  PostRepPtr;
                              Const RepTitle     :  Str255);
  Begin
    If (Got2Print) then
    With PostRepCtrl^ do
    Begin
      {* Auto add the posting routine to the Thread Queue *}

      With PParam.PDevRec do
      Begin
        feXMLFileDir:=Continue_ExcelName(feXMLFileDir,fePrintMethod,1);

      end;

      AddMemoRep2Thread(PParam.PDevRec,Self,RepTitle,Application.MainForm);
    end;
  end;

  // CJS 2014-09-25 - v7.x Order Payments - T061 - Delivery Run Exception Report
  Procedure TPostLog.PrintLog(PrintParam: TSBSPrintSetupInfo; const RepTitle: Str255);
  begin
    With PrintParam do
    Begin
      feXMLFileDir:=Continue_ExcelName(feXMLFileDir,fePrintMethod,1);
    end;
    AddMemoRep2Thread(PrintParam,Self,RepTitle,Application.MainForm);
  end;

{$ENDIF}


{$IFDEF JC}

  procedure PrintJCDoc(PInv,PBS  :  Boolean;
                       JInv      :  Str10);

  {$IFDEF FRM}
    Var
      PDevRec    :  TSBSPrintSetupInfo;
      UFont      :  TFont;
      Orient     :  TOrientation;
      Ok2Print   :  Boolean;
      RForm      :  Str10;
      WinDesc    :  Str255;
      RMode      :  Byte;
      ThisFList  :  TPFormList;
      ExLocal    :  TdExLocal;


    Begin
      UFont:=nil;

      Orient:=poPortrait;

      WinDesc:='';


      FillChar(PDevRec,Sizeof(PDevRec),0);

      With PDevRec do
      Begin
        DevIdx:=-1;
        Preview:=BOn;
        NoCopies:=1;
      end;


      ExLocal.Create;

      Try
        With ExLocal,LInv  do
        If (LGetMainRecPosKey(InvF,InvOurRefK,JInv)) then
        Begin
          If (LCust.CustCode<>CustCode) then
            LGetMainRecPos(CustF,CustCode);

          SetEcommsfromCust(LCust,PDevRec,Nil,BOn);

          If (PInv) then
            WinDesc:=DocNames[LInv.InvDocHed]+' '+JInv+'. ';

          If (PBS) then
            WinDesc:=WinDesc+' and Backing sheet. ';

          PDevRec.feEmailSubj:=WinDesc+'. From '+Syss.UserName;

          If (PBS) then
            PDevRec.feTypes:=8;  {* Block XML Tab if we are also sending the backing sheet*}

          With LCust do
          Begin
            If (LInv.InvDocHed In [SIN,SCR,SRI,SRF,SQU,SOR,SDN,PCR,POR]) then
            Begin
              Case InvDMode of
                1,2  :  PDevRec.fePrintMethod:=InvDMode;
                3,4  :  PDevRec.fePrintMethod:=InvDMode-2;
                5    :  PDevRec.fePrintMethod:=3; {XML}
              end;

            end;
          end;


          RMode:=EntDefPrnMode[InvDocHed];

          RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[RMode];

          Set_BackThreadMVisible(BOn);

          Ok2Print:=pfSelectFormPrinter(PDevRec,BOn,RForm,UFont,Orient);

          Set_BackThreadMVisible(BOff);

          If (Ok2Print) then
          Begin
            ThisFList:=TPFormList.Create;

            Try
              If (PInv) then
                ThisFList.AddVisiRec(PDevRec,DEFDEFMode[InvDocHed],RForm,InvF,InvOurRefK,IdetailF,IdFolioK,
                                     OurRef,FullNomKey(FolioNum));

              If (PBS) then
              Begin
                RMode:=36;

                RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[RMode];

                ThisFList.AddVisiRec(PDevRec,24,RForm,InvF,InvOurRefK,JDetlF,JDLedgerK,
                                     OurRef,PartCCKey(JBRCode,JBECode)+FullJobCode(LInv.DJobCode)+#1);
              end;

              If (ThisFList.HasItems) then
                Print_BatchList(Application.MainForm,ThisFList);

            except
              ThisFList.Free;
              ThisFList:=nil;

            end; {Try..}
          end;

        
        end;

      Finally
        Exlocal.Destroy;

      end; {try..}
    end;

  {$ELSE}


Begin

    end;
  {$ENDIF}
{$ENDIF}


end.
