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
  {$IFNDEF RW}
  JobSup2U,
  {$ENDIF}

  SCRTCH2U;


Type
    TPFormList  =  Class(TList)

                  VisiRec    :  PFormRepPtr;

                  Destructor Destroy;

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


    TPrintPORForm      =  Object(TPrintForm)

                             private
                               Procedure Print_PORRun;

                             public
                               ThisScrt    :  Scratch2Ptr;

                               Constructor Create(AOwner  :  TObject);

                               Destructor  Destroy; Virtual;

                               Procedure Process; Virtual;
                               Procedure Finish;  Virtual;


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
      {$IFNDEF RW}
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

       {$ENDIF RW}


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

                   Destructor Destroy;

                   private
                     fGot2Print  :  Boolean;

                   public
                      Procedure Write_MsgDD(S  :  String;
                                            DK :  Str255;
                                            DM :  Byte);

                     Procedure Write_Msg(S  :  String);

                     Procedure PrintLog(Const PostRepCtrl  :  PostRepPtr;
                                        Const RepTitle     :  Str255);

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
      {$IFNDEF RW}
      procedure PrintJCDoc(PInv,PBS  :  Boolean;
                           JInv      :  Str10);

      Procedure Start_JCSBThread( AOwner     :  TObject;
                                  FormRep    :  PFormRepPtr);

      Procedure Start_JCJAThread( AOwner       :  TObject;
                                  FormRep      :  PFormRepPtr;
                                  jpAppPrnRec  :  tJAppWizRec);
      {$ENDIF RW}
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
     {$IFNDEF RW}
     ReValU2U,
     {$ENDIF}
     VARJCSTU,
     
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
      FillChar(VisiRec^,Sizeof(VisiRec^),0);

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

          pfInitNewBatch(BOff,BOn);

        {$ENDIF}

        {InPrint:=BOn;}

        BatchStart:=BOn;
      end;
   end; {With..}
  end; {Proc..}


  Procedure TPrintForm.Print_SingleForm;


  Var
   { RForm   :  Str255;}

    RecAddr :  LongInt;

    n       :  Byte;

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

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin

    Begin
      If (Not Assigned(MTExLocal)) then { Open up files here }
      Begin
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
    Result:=Assigned(MTExLocal);
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

    PORMode:=BOn;
  end;


  Destructor TPrintPORForm.Destroy;

  Begin

    Inherited Destroy;


  end;




  Procedure TPrintPORForm.Print_PORRun;

  Const
    RFnum =ReportF;

    RKeyPath =RpK;


  Var
    LRForm  :  Str255;

    RecAddr :  LongInt;

    n       :  Byte;

    Ok2Print,
    FoundOk :  Boolean;

    KeyR,
    KeyRef  :  Str255;



  Begin
    Ok2Print:=BOn;

    If (Assigned(ThisScrt)) then
    With FormRepPtr^,PParam,MTExLocal^do
    Begin
      StartPrintJob;

      LRForm:=RForm;

      ShowStatus(1,'Generating Purchase Order Print Run:-');


      KeyRef:=FullNomKey(ThisScrt^.Process);
      KeyR:=KeyRef;


      LStatus:=LFind_Rec(B_GetGEq,RFnum,RKeyPath,KeyR);

      While (LStatusOk) and (CheckKey(KeyRef,KeyR,Length(KeyRef),BOn)) and ((Not ThreadRec^.THAbort)) and (Ok2Print) do
      With LInv do
      Begin
        ThisScrt^ .Get_Scratch(LRepScr^);

        ShowStatus(2,'Printing Order '+OurRef);

        If (LCust.CustCode<>CustCode) then {* Get Cust record for form def switch over *}
          LGetMainRec(CustF,CustCode);

        If (LCust.FDefPageNo>0) then
          RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[25]
        else
          RForm:=LRForm;

        {$IFDEF FRM}

          Ok2Print:=pfAddBatchForm(PDevRec,1,RForm,
                                   InvF,InvOurRefK,OurRef,
                                   IdetailF,IdFolioK,FullNomKey(FolioNum),
                                   '',
                                   NIL,
                                   BOff);

           {* Set DocPrinted on Invoice or Credit Note *}

            {LSet_PrintedStatus(((Not PDevRec.Preview) and (Ok2Print)),BOff,LInv);}

        {$ENDIF}

        LStatus:=LFind_Rec(B_GetNext,RFnum,RKeyPath,KeyR);

      end; {With..}
    end; {With..}
  end; {Proc..}




  Procedure TPrintPORForm.Process;

  Begin
    Inherited Process;

    ShowStatus(0,'Print Purchase Order Run');

    Print_PORRun;

  end;


  Procedure TPrintPORForm.Finish;


  Begin
    If (Assigned(ThisScrt)) then
      Dispose(ThisScrt,Done);
                           {Off}
    Inherited Finish;

  end;




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

          If (Start(0)) and (Create_BackThread) then
          Begin
            If (Assigned(FormRep)) then
            Begin
              FormRepPtr^:=FormRep^;
              FormRepPtr^.PParam.RepCaption:='Print Order Run';
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

     If (ecCommMode In [1..4]) and (Assigned(eCommFrmList)) and (Not ecPrnInfo.Preview) then
     With eCommFrmList, MTExLocal^ do
     Begin
       Try
         Case ecCommMode of
           1,2  :  ecPrnInfo.fePrintMethod:=ecCommMode;
           3,4  :  ecPrnInfo.fePrintMethod:=ecCommMode-2;
         end;

         If (ecPrnInfo.fePrintMethod=1) then {* Set Fax destination Printer *}
           ecPrnInfo.DevIdx:=pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN)
         else
           If (ecPrnInfo.fePrintMethod=2) then {* Set Email destination printer *}
           With ecPrnInfo do
           Begin
             DevIdx:=pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.EmailPrnN);

             feEmailTo:=feEmailTo+';'+feEmailToAddr+';';

             If (UserProfile^.EmailAddr='') or (Not UserProfile^.Loaded) then
               feEmailFromAd:= SyssEDI2^.EDI2Value.EmAddress
             else
               feEmailFromAd:= UserProfile^.EmailAddr;

             If (UserProfile^.UserName='') or (Not UserProfile^.Loaded) then
               feEmailFrom:= SyssEDI2^.EDI2Value.EmName
             else
               feEmailFrom:= UserProfile^.UserName;


           end;

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
         or ((SFiltBy=3) and (StatDMode=2));

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


          SetEcommsFromCust(PapCust,PDevRec,MTExLocal,BOn);

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
               {$IFNDEF RW}
               Reset_NomTxfrLines(LInv,MTExLocal); {* Reset Lines *}
               {$ENDIF}
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



{$IFNDEF RW}
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

        If (LCust.FDefPageNo>=0) then
          RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[DM2];

        TmpKPath:=RKeypath;

        TmpStat:=LPresrv_BTPos(RFnum,TmpKPath,LocalF^[RFnum],TmpRecAddr,BOff,BOff);

        KeyChkM:=FullMatchKey(MatchTCode,MatchSCode,InvR.OurRef);
        KeyM:=KeyChkM;

        LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeyM);

        While (LStatusOk) and (CheckKey(KeyChkM,KeyM,Length(KeyChkM),BOn)) and ((Not ThreadRec^.THAbort)) and (Ok2Print) do
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

        While (LStatusOk) and (CheckKey(KeyRef,KeyR,Length(KeyRef),BOn)) and ((Not ThreadRec^.THAbort)) and (Ok2Print) do
        With LInv do
        Begin
          B_Func:=B_GetNext;


          Begin
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

              If (LCust.FDefPageNo>=0) then
                RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[DM]
              else
                RForm:=LRForm;


              DM2:=60;

              {DM2:=DM;}

            end
            else
            Begin
              If (LCust.FDefPageNo>=0) then
                RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[6];

              DM2:=61;

              {DM2:=6;}
            end;

            {$IFDEF FRM}
               If (awPrintCert) then
                 Find_PrintMatch(LInv);

               If (awPrintInv) then
                 Add_PrintJob
               else
                 Ok2Print:=BOn;

             end;

             If (Ok2Print) then {Reset Run Nos}
             Begin

               RunNo:=0;

               CustSupp:=TradeCode[(InvDocHed In SalesSplit)];

               Set_DocAlcStat(LInv);  {* Set Allocation Status *}

               LStatus:=LPut_Rec(RFnum,RKeyPath);

               LReport_BError(Fnum,LStatus);

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

   {$ENDIF RW}



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
        Result:=((TransDate>=Sdate) and (TransDate<=Edate)) and ((RCr=Currency) or (RCr=0))
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

    RecAddr :  LongInt;

    n,PM    :  Byte;

    Ok2Print,
    FoundOk :  Boolean;

    KeyR,
    KeyRef  :  Str255;



  Begin
    Ok2Print:=BOn;

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
              RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[EntDefPrnMode[InvDocHed]]
            else
              RForm:=LRForm;
          end;

          {$IFDEF FRM}
            PDevRec.feFaxMsg:='';
            PDevRec.feEmailMsg:='';

            If (UsePaperless) then
              SetEcommsFromCust(LCust,PDevRec,MTExLocal,BOn)
            else
              InitEmailText (PDevRec);

            PDevRec.feEmailsubj:=DocNames[InvDocHed]+' '+OurRef+' from '+Syss.UserName;

            PDevRec.feFaxMsg:=PDevRec.feEmailsubj+#10+#13+PDevRec.feFaxMsg;
            PDevRec.feEmailMsg:=PDevRec.feEmailsubj+#10+#13+PDevRec.feEmailMsg;

            If (UsePaperLess) then
              PM:=LCust.InvDMode
            else
              PM:=0;

            If (Not UsePaperLess) or (RightFEAcc(SFiltX,LCust.InvDMode)) then
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

          {$ENDIF}
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
      AddMemoRep2Thread(PParam.PDevRec,Self,RepTitle,Application.MainForm);
    end;

  end;

{$ENDIF}


{$IFDEF JC}
  {$IFNDEF RW}
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
  {$ENDIF RW}
{$ENDIF}


end. {Unit..}