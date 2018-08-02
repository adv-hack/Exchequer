unit CISXMLTU;

{$I DEFOVR.Inc}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons,
  GlobVar,VARRec2U,VarConst,BtrvU2,BTSupU1,ExWrap1U, BTSupU3, BorBtns,

  {$IFDEF FRM}
    RPDevice,
    FrmThrdU,
  {$ENDIF}

  RepJCE2U,

  PostingU;


Type   { CIS EDI OutPut Files }

TSend_CISXML      =  Object(TEntPost)

                     private
                       TotalCount,
                       ThisCount :  LongInt;

                       VEDIF     :   File of Char;

                       PopDir    :   String;

                       CISReport :   ^TJCCISReport1;

                       DontSendFile,
                       NewExport,
                       CouldHave :   Boolean;

                       NoSegs,
                       EMsgCount,
                       VoucherCount
                                 :   LongInt;


                       Function FixInvXMLChars(S  :  String)  :  String;

                       Function Generate_CISXMLVouchers  :  Boolean;

                     public
                       {$IFDEF FRM}
                         PDevRec    :  TSBSPrintSetupInfo;
                       {$ENDIF}

                       CRepParam :   JobCRep1Ptr;

                       WizMode   :   Byte;


                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start  :  Boolean;

                   end; {Class..}


Procedure AddCISXML2Thread(AOwner    :  TObject;
                           VMode     :  Byte;
                           VRepParam :  JobCRep1Ptr);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU2,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  {ReportHU,}
  SysU1,
  SysU2,
  SysU3,
  JobSup1U,
  {$IFDEF FRM}
     PrintFrm,
     RPDefine,
  {$ENDIF}

  IntMU,
  CISSup1U,
  SCRTCH2U,
  CommsInt,
  ExBtTh1U,
  ExpVED2U,
  CISWrite,
  // VDM and MH: 13/03/2007  consts for submitter type
  CISXCnst,

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}
  
  ExThrd2U;




  { ========== TSend_CISXML methods =========== }

  Constructor TSend_CISXML.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOn;

    fPriority:=tpNormal;
    fSetPriority:=BOn;

    IsParentTo:=BOn;

    New(CISReport,Create(AOwner));

    {$IFDEF FRM}
      FillChar(PDevRec,Sizeof(PDevRec),0);

      With PDevRec do
      Begin
        DevIdx:=-1;
        Preview:=BOn;
        NoCopies:=1;
      end;


    {$ENDIF}

    CouldHave:=BOff;
    DontSendFile:=BOff;
    NewExport:=BOn;
    EMsgCount:=0;
    VoucherCount:=0;
    NoSegs:=0;


    New(CRepParam);

    Try
      FillChar(CRepParam^,Sizeof(CRepParam^),0);
    except
      Begin
        Dispose(CRepParam);
        CRepParam:=nil;
      end;
    end; {try..}

  end;


  Destructor TSend_CISXML.Destroy;

  Begin

    {Free possibly causing application error when this finishes?}
    {SMemo.Free;}

    If (Assigned(CISReport)) then
    Begin
      Dispose(CISReport,Destroy);
      CISReport:=nil; {This points to the local CRepParam, so destroying it, destroys the local one.}
      Self.CRepParam:=nil;
    end
    else
      If (Assigned(CRepParam)) then
      Begin
        Dispose(CRepParam);
        CRepParam:=nil;
      end;


    Inherited Destroy;
  end;



{ == Function to tidy up any invalid XML chars == }

Function TSend_CISXML.FixInvXMLChars(S  :  String)  :  String;

Const
  CC  :  Array[1..5,BOff..BOn] of String[6] = (('&','&amp;'),('<','&lt;'),('>','&gt;'),('"','&quot;'),('''','&#39;'));

Var
  n,m   :  Byte;

  TStr  :  String;

Begin
  Result:=S;

  For n:=1 to High(CC) do
  Begin
    m:=Pos(CC[n,BOff],S);

    If (m<>0) then
    Begin
      TStr:=Copy(S,1,Pred(m))+CC[n,BOn]+Copy(S,Succ(m),Length(S));
    end;

  end;

end;

Function TSend_CISXML.Generate_CISXMLVouchers  :  Boolean;


Const
  Fnum      =  ReportF;
  Keypath   =  RpK;

Var
  KeyChk,
  KeyJF,
  KeyS      :  Str255;

  NeedHed,
  AbortPrint,
  TmpInclude,
  Loop,
  Ok2Cont   :  Boolean;

  VMode     :  Byte;

  TMPIO     :  Integer;

  CXMLSReturn
            :  TCISXMLReturn;


Function Write_SubRecord  :  Integer;  {Write once per Subcontractor return}

Var
  ValidStat  :  Boolean;

  wc         :  Integer;

Begin
  Result:=0; ValidStat:=BOn;

  Try
    {* If we are to fail due to validation errors, then do not add in the object node *}


    With MTExLocal^, LJobDetl^.JobCISV, LJobMisc^ do
    Begin
      If (Not CISValid_UTR(CISVNINO)) then
      Begin
        {* Report error in log, and abort this record *}

        {ValidStat:=BOff;    Note in log, and mark as could have records
        CouldHave:=BOn;}

      end;

      If (Not CISValid_NINO(EmplRec.ENINo)) then
      Begin

        {* Report error in log, and abort this record *}

        {ValidStat:=BOff;    Note in log, and mark as could have records
        CouldHave:=BOn;}

      end;

      If (Not CISValid_coReg(CISVCert)) then
      Begin

        {* Report error in log, and abort this record *}

        {ValidStat:=BOff;    Note in log, and mark as could have records
        CouldHave:=BOn;}

      end;

      If (CISVerNo<>'') and (Not CISValid_VerNo(CISVerno)) then
      Begin

        {* Report error in log, and abort this record *}

        {ValidStat:=BOff;    Note in log, and mark as could have records
        CouldHave:=BOn;}

      end;

    end;

    If (Assigned(CXMLSReturn)) and (ValidStat) then
    With CXMLSReturn,Subcontractors.Add, MTExLocal^, LJobDetl^.JobCISV, LJobMisc^ do
    Begin
      wc:=WordCnt(EmplRec.EmpName);

      If (EmplRec.CISSubType<2) then
      Begin
        Surname :=FixInvXMLChars(EmplRec.Surname);

        If (wc>1) then
          Forename1 := FixInvXMLChars(ExtractWords(1,1,EmplRec.EmpName));

        If (wc>2) then
          Forename2 := FixInvXMLChars(ExtractWords(2,1,EmplRec.EmpName));
      end
      else
      Begin

        If (LCust.CustCode<>EmplRec.Supplier) then
          If (Not LGetMainRec(CustF, FullCustCode(EmplRec.Supplier))) then
            LCust.Company:=''; {* Reset it, if it cannot be found*}

        TradingName:=FixInvXMLChars(LCust.Company);
      end;

      UTR :=CISVNINO;
      NINO := EmplRec.ENINo;
      CRN:=CISVCert;
      VerificationNumber := CISVerNo;

      TotalPayments := TruncGross(CISvGrossTotal);
      TotalDeducted := CISvTaxDue;

      // CJS 2014-02-20 - ABSEXCH-11760 - CIS Return - Cost Of Materials rounding
      CostOfMaterials := TruncGross(CalcCISJDMaterial(LJobDetl^));

      UnmatchedRate:=(CISHTax=1);

      Inc(ThisCount);     {* If validation ends up being hard, we need to amend record count based on validation sucess. *}
      Inc(TotalCount);

      If (Not CISValid_UTR(UTR)) then
      With EmplRec do
      Begin
        Write_PostLogDD('Warning. Sub Contractor '+dbFormatName(EmpCode,EmpName)+' UTR '+Trim(UTR)+
                        ' does not have a valid UTR. This entry HAS been included regardless.',BOn,CISCertKey(CISCertNo),9);

      end;


      If (Not CISValid_NINO(NINO)) then
      With EmplRec do
      Begin
        Write_PostLogDD('Warning. Sub Contractor '+dbFormatName(EmpCode,EmpName)+' NINO '+Trim(NINO)+
                        ' does not have a valid NINO. This entry HAS been included regardless.',BOn,CISCertKey(CISCertNo),9);

      end;

      If (Not CISValid_coReg(CRN)) then
      With EmplRec do
      Begin
        Write_PostLogDD('Warning. Sub Contractor '+dbFormatName(EmpCode,EmpName)+' CRN '+Trim(CRN)+
                        ' does not have a valid CRN. This entry HAS been included regardless.',BOn,CISCertKey(CISCertNo),9);

      end;


      If (VerificationNumber<>'') and (Not CISValid_VerNo(VerificationNumber)) then
      With EmplRec do
      Begin
        Write_PostLogDD('Warning. Sub Contractor '+dbFormatName(EmpCode,EmpName)+' Verification No. '+Trim(CRN)+
                        ' does not have a valid Verification No. This entry HAS been included regardless.',BOn,CISCertKey(CISCertNo),9);

      end;


    end;

  except
    Result:=2;
  end;
end;


Function Write_ContractorRecord  :  Integer;  {* Write once per file }

Var
  RDay, RMonth,RYear  :  Word;

Begin
  Result:=0;

  CXMLSReturn:=TCISXMLReturn.Create;

  Try
    With CXMLSReturn, CRepParam^, SyssCIS^.CISRates, SyssCIS340^.CIS340 do
    Begin
      ProductVersion := CurrVersion;
      SenderID := IGWUId;
      SenderAuthentication := IGWIRef;
      TaxOfficNumber := IGWTO;
      TaxOfficeReference := IGWTR;

      {VendorID := 'QRST';} {* EL: This field needs to be hardwired once the correct reference is known *}

      ContractorUTR := CISCUTR;
      ContractorAORef := CISACCONo;

      DateStr(RepEDate,RDay,RMonth,RYear);

      // VMD and MH: 13/03/2007 setting IRSender Object {submitter field}}
      case IGSubType of
//        {cstNA} 0: IRSender := '';
        {cstIndividual} 0: IRSender := cIRSenderIndividual;
        {cstCompany} 1: IRSender := cIRSenderCompany;
        {cstAgent} 2: IRSender := cIRSenderAgent;
        {cstBureau} 3: IRSender := cIRSenderBureau;
        {cstPartnership} 4: IRSender := cIRSenderPartnership;
        {cstTrust} 5:  IRSender := cIRSenderTrust;
        {cstEmployer} 6: IRSender := '';
        {cstGovernment} 7: IRSender := cIRSenderGovernment;
        {cstActingInCapacity} 8: IRSender := '';
        {cstOther} 9: IRSender := cIRSenderOther;
      end;

      Year := RYear;
      Month := RMonth;;

      EmploymentStatus := IXConfEmp;
      SubContractorVerification := IXVerSub;
      Inactivity:=IXNoPay;
      TestMessage:=ITestMode;


      If (Not CISValid_AccOff(CISACCONo)) then
      Begin
        Write_PostLog('Your Accounts Office Reference '+Trim(CISACCONo)+', is not valid. This return may be rejected by HMRC. Please correct.',BOn);

        {* Set Ok2Cont to False if the file needs to be abandoned because of this *}
      end;

      If (Not CISValid_UTR(CISCUTR)) then
      Begin
        Write_PostLog('Your UTR Reference '+Trim(CISCUTR)+', is not valid. This return may be rejected by HMRC. Please correct.',BOn);

        {* Set Ok2Cont to False if the file needs to be abandoned because of this *}
      end;

    end;

  except
    Result:=2;
    Freeandnil(CXMLSReturn);
  end;
end;


Begin

  TMPIO:=0; NewExport:=BOn;  VMode:=WizMode;  TotalCount:=0;

  Loop:=BOff;
  KeyChk:=FullNomKey(CISReport^.ThisScrt^.Process);


  With CRepParam^, MTExLocal^ do
  Begin

    Try

      TMPIO:=Write_ContractorRecord; {Initialize object and set up base header properties}


      Ok2Cont:=(Not ThreadRec^.THAbort);

      KeyS:=KeyChk;

      NeedHed:=BOn;  ThisCount:=0;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      AbortPrint:=Not LStatusOk;



      While (Not AbortPrint) and (Ok2Cont) and (Checkkey(KeyChk,KeyS,Length(KeyChk),BOn)) and (TMPIO=0) do
      With LJobDetl^.JobCISV do
      Begin
        If (CISReport^.ThisScrt<>NIL) then {* Get Id Link *}
          CISReport^.ThisScrt^.Get_Scratch(LRepScr^);

        Ok2Cont:=(Not ThreadRec^.THAbort);

        TmpInclude:=BOn;

        If (TmpInclude) then
        Begin
          KeyJF:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(Copy(CISvCode1,1,EmplKeyLen)));

          If (Not LGetMainRec(JMiscF,KeyJF)) then
            LResetRec(JMiscF);

        end;

        If (TmpInclude) then
        Begin

          TmpIO:=Write_SubRecord; {For each statement write a return}

          With LJobMisc^.EmplRec do
            ShowStatus(1,'Processing '+dbFormatName(EmpCode,EmpName));

          
        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        AbortPrint:=Not LStatusOk;
      end; {While..}

      Try
        If (Assigned(CXMLSReturn)) and (Ok2Cont) then
        With CXMLSReturn do
        Begin
          NilIndicator:=(TotalCount=0); {Detect nil return based on record count}
          WriteXMLToFile(BuildPath(SyssCIS340^.CIS340.IXMLDirPath)+CISFName);

        end;
      except;
        Freeandnil(CXMLSReturn);
        TMPIO:=2;
      end; {try..}

      TmpInclude:=(TmpIO=0);

      If (TmpInclude) then
      Begin
        Write_PostLog(CCCISName^+' XML export. The file '+BuildPath(SyssCIS340^.CIS340.IXMLDirPath)+CISFName+' has been created.',BOn);

        If (TotalCount=0) then
        Begin
          If (Not CouldHave) then
          Begin

            {* Terminate as Nil Return *}

            Begin
              Write_PostLog('No records were found to export. and a Nil Return has been generated!',BOn);
              DontSendFile:=BOn;
            end;
          end
          else
          Begin
            Write_PostLog('No records found to export.',BOn);
            Write_PostLog('However, there were errors in the data, which when corrected may',BOn);
            Write_PostLog('provide enough data for a valid submission. Please correct and try again.',BOn);
          end;

        end
        else
        Begin
          Write_PostLog('A total of '+Form_Int(TotalCount,0)+' records have been placed in the XML file.',BOn);
          Write_PostLog('Please send this file as soon as possible.',BOn);
        end;

      end
      else
        Begin
          Write_PostLog(CCCISName^+' XML export. The file '+BuildPath(SyssCIS340^.CIS340.IXMLDirPath)+CISFName+' generated error '+Form_Int(TMpIO,0)+'. '+IOError(TmpIO),BOn);
          Write_PostLog('Do not send this file until the problem has been corrected.',BOn);
        end;

      Result:=TmpInclude and Ok2Cont;

    finally
      If (Assigned(CXMLSReturn)) then
        FreeandNil(CXMLSReturn);

    end; {try..}
  end; {With..}

end;




Procedure TSend_CISXML.Process;
Var
  AbortPrint,
  CompressedOk  :  Boolean;
  UsePath       :  String;

  Begin
    InMainThread:=BOn;

    CompressedOk:=BOff;  AbortPrint:=BOff;

    Inherited Process;

    ShowStatus(0,CRepParam^.EDIHedTit+' XML Export');

    With CRepParam^, SyssCIS340^.CIS340 do
    Begin
      UsePath:=IXMLDirPath;

      Write_PostLog('',BOff); {Initialise the exceptions log}

      Try

        {$I-}

        Try
          GetDir(0,PopDir);

          MTExLocal^.LReport_IOError(IOResult,PopDir);

        except;
          PopDir:=SetDrive;

        end;

        {$I+}


        Begin
          CISReport^.CRepParam:=CRepParam;

          Try
            With CISReport^ do
            Begin
              New(ThisScrt,Init(21,MTExLocal,BOff));

              Build_CISVouchers(21,AbortPrint);
            end;

            If (Not AbortPrint) then
            Case WizMode of
              0  :  Generate_CISXMLVouchers;

            end; {Case..}

          Finally
            If (Assigned(CISReport^.ThisScrt)) then
            With CISReport^ do
            Begin
              Dispose(ThisScrt,Done);
              ThisScrt:=nil;
            end;

          end; {Try..}


          If (Not ThreadRec^.THAbort) then
          Begin
            Write_PostLog(CCCISName^+' XML export completed.',BOn);

            {If (VCompress) and (Not DontSendFile) then
              CompressedOk:=CompressEDIFile(VDirPath,VTestMode,VEDIMethod,VSendEmail);


            If (VSendEmail) and (VEDIMethod=2) and (Not DontSendFile) then {* We need to send it directly
              SendEDIEmail(CompressedOk);}
          end
          else
            Write_PostLog(CCCISName^+' XML export ABORTED!',BOn);

        end;

      Finally;
        {$I-}

        Try
          ChDir(PopDir);


        except;
          ChDir(SetDrive);
        end;

        MTExLocal^.LReport_IOError(IOResult,PopDir);

        {$I+}

      end; {Try.}


    end; {With..}

  end;


  Procedure TSend_CISXML.Finish;
  Begin
    {$IFDEF Rp}
      {$IFDEF FRM}
        If (Assigned(PostLog)) then
          PostLog.PrintLog(PostRepCtrl,CCCISName^+' XML Export Log.');

      {$ENDIF}
    {$ENDIF}



    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

  end;




  Function TSend_CISXML.Start  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;
    RForm  :  Str10;
    UFont  :  TFont;

    Orient :  TOrientation;


  Begin
    Result:=BOn;  UFont:=nil;


    {$IFDEF FRM}
      If (Result) then
      Begin
        UFont:=TFont.Create;

        try
          UFont.Assign(Application.MainForm.Font);
        

          Orient:=poPortrait;

          Set_BackThreadMVisible(BOn);

          RForm:='';

          Result:=pfSelectPrinter(PDevRec,UFont,Orient);

          Set_BackThreadMVisible(BOff);

        Finally
          UFont.Free;
          UFont:=nil;
        end;

      end;

    {$ENDIF}

    If (Result) then
    Begin
      {$IFDEF EXSQL}
      if SQLUtils.UsingSQL then
      begin
        // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
        if (not Assigned(LPostLocal)) then
          Result := Create_LocalThreadFiles;

        If (Result) then
        begin
          MTExLocal := LPostLocal;

          If (Assigned(CISReport)) then
            CISReport^.MTExLocal:=MTExLocal;
        end;

      end
      else
      {$ENDIF}
      begin
        If (Not Assigned(PostExLocal)) then { Open up files here }
          Result:=Create_ThreadFiles;

        If (Result) then
        Begin
          MTExLocal:=PostExLocal;

          If (Assigned(CISReport)) then
            CISReport^.MTExLocal:=MTExLocal;

        end;
      end;
    end;
    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}
  end;

{ ============== }


Procedure AddCISXML2Thread(AOwner    :  TObject;
                           VMode     :  Byte;
                           VRepParam :  JobCRep1Ptr);


  Var
    LCheck_Batch :  ^TSend_CISXML;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Batch,Create(AOwner));

      try
        With LCheck_Batch^ do
        Begin
          CRepParam^:=VRepParam^;
          WizMode:=VMode;

          If (Start) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LCheck_Batch,CCCISName^+' XML');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Batch,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Batch,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;




end.