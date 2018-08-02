unit CISEDITU;

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

TSend_CISEDI      =  Object(TEntPost)

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


                       Function Init_EDIFile(FPath     :  Str255)  :  Boolean;

                       Procedure Close_EDIFile;

                       Procedure Write_EDILine(EDILine  :  Str255;
                                               Term,
                                               AddCRLF   :  Boolean;
                                           Var TMPIO     :  Integer);

                       Procedure Write_EDIUNB(VMode   :  Byte;
                                          Var TmpIO   :  Integer);

                       Procedure Write_EDIUNH(VMode   :  Byte;
                                          Var TmpIO   :  Integer);

                       Procedure Write_Voucher(VMode   :  Byte;
                                           Var TmpIO   :  Integer);

                       Procedure Write_EOYSC(LastVoucher :  JobDetlRec;
                                             ShowTotals  :  Boolean;
                                             Var TmpIO   :  Integer);

                       Procedure Write_EDICNT(VMode   :  Byte;
                                          Var TmpIO   :  Integer);

                       Procedure Write_EDIUNZ(Var TmpIO   :  Integer);

                       Function Generate_CISEDIVouchers  :  Boolean;

                       Function Generate_CISEDIEOY :  Boolean;

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


Procedure AddCISEDI2Thread(AOwner    :  TObject;
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

  {$IFDEF FRM}
     PrintFrm,
     RPDefine,
  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  IntMU,
  CISSup1U,
  SCRTCH2U,
  CommsInt,
  ExBtTh1U,
  ExpVED2U,
  ExThrd2U;




  { ========== TSend_CISEDI methods =========== }

  Constructor TSend_CISEDI.Create(AOwner  :  TObject);

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


  Destructor TSend_CISEDI.Destroy;

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



  { ====== Procedure to manage the control of Producing EDI File ==== }


Function TSend_CISEDI.Init_EDIFile(FPath     :  Str255)  :  Boolean;

Var
  n        :  Byte;

  TmpIO    :  Integer;


Begin

  {$I-}

  Try
    GetDir(0,PopDir);

    MTExLocal^.LReport_IOError(IOResult,PopDir);

  except;
    PopDir:=SetDrive;

  end;

  With CRepParam^ do
  Begin
    Assign(VEDIF,BuildPath(FPath)+CISFName);

    ReWrite(VEDIF);

    TmpIO:=IOResult;

    MTExLocal^.LReport_IOError(TmpIO,CISFName);
  end;

  Init_EDIFile:=(TmpIO=0);

  {$I+}


end; {Proc..}

Procedure TSend_CISEDI.Close_EDIFile;

Begin
  {$I-}

    Close(VEDIF);

    MTExLocal^.LReport_IOError(IOResult,CRepParam^.CISFName);

    Try
      ChDir(PopDir);


    except;
      ChDir(SetDrive);
    end;

    MTExLocal^.LReport_IOError(IOResult,PopDir);



  {$I+}

end;




Procedure TSend_CISEDI.Write_EDILine(EDILine  :  Str255;
                                     Term,
                                     AddCRLF   :  Boolean;
                                 Var TMPIO     :  Integer);


Var
  n      :  Byte;
  TC     :  Char;

Begin
  {$I-}

  If (TmpIO=0) then
  Begin
    For n:=1 to Length(EDILine) do
    Begin
      Write(VEDIF,EDILine[n]);

      TmpIO:=IOResult;

      If (TMPIO<>0) then
        Break;
    end;

    If (Term) and (TMPIO=0) then
    Begin
      TC:=#39;

      Write(VEDIF,TC);

      TMPIO:=IOResult;
    end;

    If (AddCRLF) and (TMPIO=0) then
    Begin
      TC:=#13;

      Write(VEDIF,TC);

      TMPIO:=IOResult;

      TC:=#10;

      Write(VEDIF,TC);

      TMPIO:=IOResult;
    end;

    MTExLocal^.LReport_IOError(TmpIO,EDIFName(BOff,0));
  end;

  {$I+}

end;




{ ========== Write Specific Lines for ESL Export ========= }

Procedure TSend_CISEDI.Write_EDIUNB(VMode   :  Byte;
                                Var TmpIO   :  Integer);

Var
  TimeR
         :  TimeTyp;

  GenStr :  Str255;

Begin
  GenStr:='';

  With CRepParam^, SyssCIS^.CISRates do
  Begin
    Case VMode of
      0..2 :  Begin
                Write_EDILine('UNB+UNOA:1+'+VEDIFmtStrUC(IVANUID)+'+'+VEDIFmtStrUC(IVANIRID),BOff,BOff,TmpIO);

                GetCurrTime(TimeR);

                Write_EDILine('+'+ShortDate(Today)+':'+SetN(TimeR.HH)+SetN(TimeR.MM)+'+1+'+VEDIFmtStrUC(IVANPW)+'+CIS',BOff,BOff,TmpIO);

                If (ITestMode) then
                  Write_EDILine(ConstStr('+',4)+'1',BOn,IUseCRLF,TmpIO)
                else
                  Write_EDILine('',BOn,IUseCRLF,TmpIO);

              end;

    end; {Case..}


  end; {With..}


end;


Procedure TSend_CISEDI.Write_EDIUNH(VMode   :  Byte;
                                Var TmpIO   :  Integer);

Const
  CISSeg  :  Array[0..2] of Str10 = ('CISTPV','CISCGV','CISEOY');

Begin
  With CRepParam^, SyssCIS^.CISRates do
  Begin
    NoSegs:=0; VoucherCount:=0;

    Case VMode of
      0..2
         :  Begin
              Write_EDILine('UNH+'+Form_Int(EMsgCount,0)+'+'+CISSeg[VMode]+':1:97B:IR:INLR01',BOn,IUseCRLF,TmpIO);

              Case VMode of
                0  :  Write_EDILine('BGM+25E',BOn,IUseCRLF,TmpIO);
                1  :  Write_EDILine('BGM+23E',BOn,IUseCRLF,TmpIO);
                2  :  Write_EDILine('BGM+36E',BOn,IUseCRLF,TmpIO);
              end; {Case..}

              Write_EDILine('DTM+97:'+Today+':102',BOn,IUseCRLF,TmpIO);

              Case VMode of
                2  :  Write_EDILine('DTM+325:'+Copy(RepEDate,1,4)+':602',BOn,IUseCRLF,TmpIO);
                else  Write_EDILine('DTM+325:'+Copy(RepEDate,1,6)+':610',BOn,IUseCRLF,TmpIO);
              end;

              Write_EDILine('NAD+FC+'+VEDIFmtStrUC(CISTaxRef)+':167+'+VEDIFmtStrUC(Trim(Syss.UserName)),BOn,IUseCRLF,TmpIO);

              Write_EDILine('RFF+EI:'+VEDIFmtStrUC(IIREDIRef),BOn,IUseCRLF,TmpIO);

              Write_EDILine('CUX+2:GBP:11',BOn,IUseCRLF,TmpIO);

              NoSegs:=NoSegs+7;
            end;

    end; {case..}
  end; {With..}


end;




Procedure TSend_CISEDI.Write_Voucher(VMode   :  Byte;
                                 Var TmpIO   :  Integer);

Var
  VCert,
  VSerialNo   :  Str20;

  VL,
  VS          :  Byte;

  KeyJF       :  Str255;


Begin
  With CRepParam^, SyssCIS^.CISRates, MTExLocal^, LJobDetl^.JobCISV do
  Begin
    VSerialNo:=Copy(Today,1,4);

    VCert:=Strip('A',['A'..'Z',#32],CISCertNo);

    VL:=Length(VCert);

    If (VL<6) then
      VS:=1
    else
      VS:=VL-5;

    VSerialNo:=VSerialNo+SetPadNo(Copy(VCert,VS,VL),6);

    Inc(VoucherCount);

    Write_EDILine('LIN+'+Form_Int(VoucherCount,0)+'++'+VEDIFmtStrUC(VSerialNo)+':VSN',BOn,IUseCRLF,TmpIO);


    KeyJF:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(Copy(CISvCode1,1,EmplKeyLen)));

    If (Not LGetMainRec(JMiscF,KeyJF)) then
      LResetRec(JMiscF);

    KeyJF:=FullCustCode(Copy(CISVSDate,1,CustKeyLen));

    If (Not LGetMainRec(CustF,KeyJF)) then
      LResetRec(CustF);

    If (Trim(CISVNINo)<>'') then
      VSerialNo:=CISVNINo
    else
      With LJobMisc^.EmplRec do
        If (Trim(ENINo)<>'') then
          VSerialNo:=ENINo
        else
        Begin
          VSerialNo:='NONE';
          Write_PostLogDD('Warning. Sub Contractor '+dbFormatName(EmpCode,EmpName)+' on '+GetIntMsg(4)+' '+Trim(VCert)+
                        ' does not have a valid NI No. The '+GetIntMsg(4)+' HAS been included regardless.',BOn,CISCertKey(CISCertNo),9);

        end;


    With LJobMisc^.EmplRec do
    Begin
      Write_EDILine('NAD+EV+'+VEDIFmtStrUC(VSerialNo)+':167+'+VEDIFmtStrUC(Trim(EmpName)),BOff,BOff,TmpIO);


      VSerialNo:=CISVCert;

      If (Trim(VSerialNo)='') then
      Begin
        VSerialNo:=CertNo;

        Write_PostLogDD('Warning. Sub Contractor '+dbFormatName(EmpCode,EmpName)+' on '+GetIntMsg(4)+' '+Trim(VCert)+
                        ' does not have a valid Certificate No. The '+GetIntMsg(4)+' HAS been included regardless.',BOn,CISCertKey(CISCertNo),9);

      end;

      Vs:=0;

      If (VMode=0) then
      Begin
        Write_EDILine(':'+VEDIFmtStrUC(Trim(LCust.Company)),BOff,BOff,TmpIO);

        For vl:=1 to High(Addr) do
        Begin
          If (Trim(Addr[vl])<>'') then
          Begin
            Write_EDILine(':'+VEDIFmtStrUC(Trim(Addr[vl])),BOff,BOff,TmpIO);

            Inc(Vs);
          end;

          If (Vs>2) then
            Break;
        end;

        Write_EDILine(ConstStr('+',5)+VEDIFmtStrUC(LCust.PostCode),BOn,IUseCRLF,TmpIO);

        Write_EDILine('RFF+AHP:'+VEDIFmtStrUC(Trim(VSerialNo)),BOn,IUseCRLF,TmpIO);
      end
      else
      Begin
        Write_EDILine('',BOn,IUseCRLF,TmpIO);
        Write_EDILine('RFF+AID:'+VEDIFmtStrUC(Trim(VSerialNo)),BOn,IUseCRLF,TmpIO);
      end;



    end; {With..}

    Write_EDILine('MOA+128:'+Form_Real(TruncGross(CISvGrossTotal),0,0),BOn,IUseCRLF,TmpIO);

    NoSegs:=NoSegs+4;

    If (VMode=0) then
    Begin
      Write_EDILine('MOA+186:'+Form_Real(CalcCISJDMaterial(LJobDetl^),0,0),BOn,IUseCRLF,TmpIO);
      Write_EDILine('MOA+125:'+Form_Real(TruncGross(CISTaxableTotal),0,0),BOn,IUseCRLF,TmpIO);
      Write_EDILine('MOA+124:'+Form_Real(CISvTaxDue*100,0,0),BOn,IUseCRLF,TmpIO);

      NoSegs:=NoSegs+3;
    end;


  end; {With..}


end;


Procedure TSend_CISEDI.Write_EOYSC(LastVoucher :  JobDetlRec;
                                   ShowTotals  :  Boolean;
                                   Var TmpIO   :  Integer);

Var
  VCert,
  VSerialNo   :  Str20;

  VL,
  VS          :  Byte;

  KeyJF       :  Str255;


Begin
  With CRepParam^, SyssCIS^.CISRates, MTExLocal^, LastVoucher.JobCISV do
  Begin
    KeyJF:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(Copy(CISvCode1,1,EmplKeyLen)));

    If (Not LGetMainRec(JMiscF,KeyJF)) then
      LResetRec(JMiscF);

    If (Assigned(CISReport)) then
    With CISReport^ do
      If ((CISCType>=Low(VTots)) and (CISCType<=High(VTots))) then
        Inc(VTots[CISCType].Counter);

    Inc(ThisCount);
    Inc(TotalCount);

    With LJobMisc^.EmplRec do
    Begin
      Write_EDILine('NAD+EV++'+VEDIFmtStrUC(Trim(EmpName)),BOn,IUseCRLF,TmpIO);


      VSerialNo:=CISVCert;

      If (Trim(VSerialNo)='') then
      Begin
        VSerialNo:=CertNo;

        Write_PostLogDD('Warning. Sub Contractor '+dbFormatName(EmpCode,EmpName)+' on '+GetIntMsg(4)+' '+Trim(VCert)+
                        ' does not have a valid Certificate No. The '+GetIntMsg(4)+' HAS been included regardless.',BOn,CISCertKey(CISCertNo),9);

      end;

      If (CISCType=4) then
        Write_EDILine('RFF+AHP:'+VEDIFmtStrUC(Trim(VSerialNo)),BOn,IUseCRLF,TmpIO)
      else
        Write_EDILine('RFF+AID:'+VEDIFmtStrUC(Trim(VSerialNo)),BOn,IUseCRLF,TmpIO);

    end; {With..}

    NoSegs:=NoSegs+2;

    If (ShowTotals) then
    With CISReport^.VTots[CISCType] do
    Begin
      Write_EDILine('MOA+128:'+Form_Real(Gross,0,0),BOn,IUseCRLF,TmpIO);

      If (CISCType=4) then
      Begin
        Write_EDILine('MOA+186:'+Form_Real(Materials,0,0),BOn,IUseCRLF,TmpIO);
        Write_EDILine('MOA+124:'+Form_Real(Tax*100,0,0),BOn,IUseCRLF,TmpIO);

        NoSegs:=NoSegs+2;
      end;

      Write_EDILine('CNT+ZZZ:'+Form_Int(Counter,0),BOn,IUseCRLF,TmpIO);

      NoSegs:=NoSegs+2;
    end; {Showtotals}
  end; {With..}


end;



Procedure TSend_CISEDI.Write_EDICNT(VMode   :  Byte;
                                Var TmpIO   :  Integer);

Var
  n  :  Byte;

Begin
  With CRepParam^, SyssCIS^.CISRates do
  Begin
    Case VMode of
      0,1  :  Begin
                NoSegs:=NoSegs+2;
                Write_EDILine('CNT+2:'+Form_Int(VoucherCount,0),BOn,IUseCRLF,TmpIO);
                Write_EDILine('UNT+'+Form_Int(NoSegs,0)+'+'+Form_Int(EMsgCount,0),BOn,IUseCRLF,TmpIO);

              end;


      2    :  If (Assigned(CISReport)) then
              With CISReport^ do
              Begin

                For n:=Low(VTots) to Pred(High(VTots)) do
                Begin
                  With VTots[High(VTots)] do
                  Begin
                    Gross:=Gross+VTots[n].Gross;
                    Materials:=Materials+VTots[n].Materials;
                    Tax:=Tax+VTots[n].Tax;
                    Counter:=Counter+VTots[n].Counter;
                  end;
                end; {Loop..}

                With VTots[High(VTots)] do
                Begin

                  Write_EDILine('MOA+128:'+Form_Real(Gross,0,0),BOn,IUseCRLF,TmpIO);

                  If (Materials+Tax<>0.0) then
                  Begin
                    Write_EDILine('MOA+186:'+Form_Real(Materials,0,0),BOn,IUseCRLF,TmpIO);
                    Write_EDILine('MOA+124:'+Form_Real(Tax*100,0,0),BOn,IUseCRLF,TmpIO);

                    NoSegs:=NoSegs+2;
                  end; {If..}

                  NoSegs:=NoSegs+3;

                  Write_EDILine('CNT+2:'+Form_Int(Counter,0),BOn,IUseCRLF,TmpIO);
                  Write_EDILine('UNT+'+Form_Int(NoSegs,0)+'+'+Form_Int(EMsgCount,0),BOn,IUseCRLF,TmpIO);

                end; {With..}
              end; {Case..}
    end; {case..}
  end; {With..}


end;


Procedure TSend_CISEDI.Write_EDIUNZ(Var TmpIO   :  Integer);


Begin
  Write_EDILine('UNZ+'+Form_Int(EMsgCount,0)+'+1',BOn,SyssCIS^.CISRates.IUseCRLF,TmpIO);
end;




Function TSend_CISEDI.Generate_CISEDIVouchers  :  Boolean;


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


Begin

  TMPIO:=0; NewExport:=BOn;  VMode:=WizMode;  TotalCount:=0;

  Loop:=BOff;
  KeyChk:=FullNomKey(CISReport^.ThisScrt^.Process);


  With CRepParam^, MTExLocal^ do
  Begin

    Ok2Cont:=(Not ThreadRec^.THAbort);

    Write_EDIUNB(WizMode,TMPIO);

    Repeat
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

        TmpInclude:=(((CISCType=4) and (VMode=0)) or ({$IFDEF DBD} (CISCType<>4) {$ELSE} (CISCType=5) {$ENDIF} and (VMode=1)))
                     and (Ok2Cont);

        If (TmpInclude) then
        Begin
          TmpInclude:=(CISvGrossTotal>=0);

          If (Not TmpInclude) then
          Begin
            KeyJF:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(Copy(CISvCode1,1,EmplKeyLen)));

            If (Not LGetMainRec(JMiscF,KeyJF)) then
              LResetRec(JMiscF);

            With LJobMisc^.EmplRec do
              Write_PostLogDD('Warning. '+GetIntMsg(4)+' '+Trim(CISCertNo)+' is a correction entry for Sub Contractor '+dbFormatName(EmpCode,EmpName)+'.',BOn,CISCertKey(CISCertNo),9);

            Write_PostLogDD('This '+GetIntMsg(4)+' HAS NOT been included. A separate manual return must be completed for this '+GetIntMsg(4)+'.',BOn,CISCertKey(CISCertNo),9);

          end;
        end;

        If (TmpInclude) then
        Begin
          If (NeedHed) then
          Begin
            Inc(EMsgCount);
            Write_EDIUNH(VMode,TMPIO);
            NeedHed:=BOff;

          end;

          If (TMPIO=0) then
            Write_Voucher(VMode,TmpIO);

          With LJobMisc^.EmplRec do
            ShowStatus(1,'Processing '+dbFormatName(EmpCode,EmpName));

          Inc(ThisCount);
          Inc(TotalCount);
        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        AbortPrint:=Not LStatusOk;
      end; {While..}

      If (ThisCount>0) then
        Write_EDICNT(VMode,TmpIO);

      Inc(VMode);

    Until (VMode>1) or (ThreadRec^.THAbort);

    TmpInclude:=(TmpIO=0);

    If (TmpInclude) then
    Begin
      Write_PostLog(CCCISName^+' EDI export. The file '+BuildPath(SyssCIS^.CISRates.IDirPath)+CISFName+' has been created.',BOn);

      If (TotalCount=0) then
      Begin
        If (Not CouldHave) then
        Begin

          {* Terminate as Nil Return *}

          Begin
            Write_PostLog('No records were found to export. DO NOT SEND THE FILE!',BOn);
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
        Write_PostLog('A total of '+Form_Int(TotalCount,0)+' records have been placed in the EDI file.',BOn);
        Write_PostLog('Please send this file as soon as possible.',BOn);
      end;


      Write_EDIUNZ(TmpIO);
    end
    else
      Begin
        Write_PostLog(CCCISName^+' EDI export. The file '+BuildPath(SyssCIS^.CISRates.IDirPath)+CISFName+' generated error '+Form_Int(TMpIO,0)+'. '+IOError(TmpIO),BOn);
        Write_PostLog('Do not send this file until the problem has been corrected.',BOn);
      end;

    Result:=TmpInclude and Ok2Cont;

  end; {With..}

end;

Function TSend_CISEDI.Generate_CISEDIEOY :  Boolean;


Const
  Fnum      =  ReportF;
  Keypath   =  RpK;

  VSCode    :  Array[4..6] of Char = ('T','C','G');

Var
  KeyChk,
  KeyS      :  Str255;

  AbortPrint,
  TmpInclude,
  Loop,
  Ok2Cont   :  Boolean;

  TMPIO     :  Integer;


  LastVT    :  Byte;
  LastSC    :  Str10;
  LastVoucher
            :  JobDetlRec;


Begin

  TMPIO:=0; TotalCount:=0;

  Loop:=BOff;
  KeyChk:=FullNomKey(CISReport^.ThisScrt^.Process);


  With CRepParam^, MTExLocal^ do
  Begin
    Inc(EMsgCount);

    Ok2Cont:=(Not ThreadRec^.THAbort);

    Write_EDIUNB(WizMode,TMPIO);

    If (TMPIO=0) then
      Write_EDIUNH(WizMode,TMPIO);

    KeyS:=KeyChk;

    ThisCount:=0;  LastVT:=0; LastSC:='';

    Blank(LastVoucher,Sizeof(LastVoucher));

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    AbortPrint:=Not LStatusOk;


    While (Not AbortPrint) and (Ok2Cont) and (Checkkey(KeyChk,KeyS,Length(KeyChk),BOn)) and (TMPIO=0) do
    With LJobDetl^.JobCISV do
    Begin
      If (CISReport^.ThisScrt<>NIL) then {* Get Id Link *}
        CISReport^.ThisScrt^.Get_Scratch(LRepScr^);

      Ok2Cont:=(Not ThreadRec^.THAbort);

      TmpInclude:=(CISvGrossTotal>=0) and (Ok2Cont);

      If (TmpInclude) then
      Begin
        If (LastSC<>Copy(CISVSDate,1,CustKeyLen)) or (LastVT<>CISCType) then {Trigger entry}
        Begin
          If (LastSC<>'') and (LastVT<>0) then
            Write_EOYSC(LastVoucher,(LastVT<>CISCType),TmpIO);

          LastVT:=CISCType;
          LastSC:=Copy(CISVSDate,1,CustKeyLen);

          If (TMPIO=0) then
          Begin
            Write_EDILine('RFF+SCT:'+VSCode[LastVT],BOn,SyssCIS^.CISRates.IUseCRLF,TmpIO);
            Inc(NoSegs);
          end;  
        end;

        LastVoucher:=LJobDetl^;

        With LJobMisc^.EmplRec do
          ShowStatus(1,'Processing '+dbFormatName(EmpCode,EmpName));

      end; {If include Voucher..}

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      AbortPrint:=Not LStatusOk;
    end; {While..}

    If (ThisCount>0) then
      Write_EOYSC(LastVoucher,BOn,TmpIO);

    Write_EDICNT(WizMode,TmpIO);

    TmpInclude:=(TMPIO=0);

    If (TmpInclude) then
    Begin
      Write_PostLog(CCCISName^+' EDI end of year export. The file '+BuildPath(SyssCIS^.CISRates.IDirPath)+CISFName+' has been created.',BOn);

      If (TotalCount=0) then
      Begin
        If (Not CouldHave) then
        Begin

          {* Terminate as Nil Return *}
          Write_PostLog('No records found to export, so a nil return has been created.',BOn);
          Write_PostLog('Although no records were found this file should still be sent.',BOn);

        end;

      end
      else
      Begin
        Write_PostLog('A total of '+Form_Int(TotalCount,0)+' records have been placed in the EDI file.',BOn);
        Write_PostLog('Please send this file as soon as possible.',BOn);
      end;


      Write_EDIUNZ(TmpIO);
    end
    else
    Begin
      Write_PostLog(CCCISName^+' EDI end of year export. The file '+BuildPath(SyssCIS^.CISRates.IDirPath)+CISFName+' generated error '+Form_Int(TMpIO,0)+'. '+IOError(TmpIO),BOn);
      Write_PostLog('Do not send this file until the problem has been corrected.',BOn);
    end;

    Result:=TmpInclude and Ok2Cont;
  end; {With..}

end;



Procedure TSend_CISEDI.Process;
Var
  AbortPrint,
  CompressedOk  :  Boolean;
  UsePath       :  String;

  Begin
    InMainThread:=BOn;

    CompressedOk:=BOff;  AbortPrint:=BOff;

    Inherited Process;

    ShowStatus(0,CRepParam^.EDIHedTit+' EDI Export');

    With CRepParam^, SyssCIS^.CISRates do
    Begin
      UsePath:=IDirPath;

      Write_PostLog('',BOff); {Initialise the exceptions log}

      Try
        If (Init_EDIFile(UsePath)) then

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
              0  :  Generate_CISEDIVouchers;

              2  :  Generate_CISEDIEOY;

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
            Write_PostLog(CCCISName^+' EDI export completed.',BOn);

            {If (VCompress) and (Not DontSendFile) then
              CompressedOk:=CompressEDIFile(VDirPath,VTestMode,VEDIMethod,VSendEmail);


            If (VSendEmail) and (VEDIMethod=2) and (Not DontSendFile) then {* We need to send it directly
              SendEDIEmail(CompressedOk);}
          end
          else
            Write_PostLog(CCCISName^+' EDI export ABORTED!',BOn);

        end
        else
          Write_PostLog(CCCISName^+' EDI export. Export file creation failed.',BOn);

      Finally;
        Close_EDIFile;


      end; {Try.}


    end; {With..}

  end;


  Procedure TSend_CISEDI.Finish;
  Begin
    {$IFDEF Rp}
      {$IFDEF FRM}
        If (Assigned(PostLog)) then
          PostLog.PrintLog(PostRepCtrl,CCCISName^+' EDI Export Log.');

      {$ENDIF}
    {$ENDIF}



    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

  end;




  Function TSend_CISEDI.Start  :  Boolean;

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
          MTExLocal := LPostLocal;

      end
      else
      {$ENDIF}
      begin
        If (Not Assigned(PostExLocal)) then { Open up files here }
          Result:=Create_ThreadFiles;

        If (Result) then
        Begin
          MTExLocal:=PostExLocal;
        end;
      end;

      If (Assigned(CISReport)) then
        CISReport^.MTExLocal:=MTExLocal;

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


Procedure AddCISEDI2Thread(AOwner    :  TObject;
                           VMode     :  Byte;
                           VRepParam :  JobCRep1Ptr);


  Var
    LCheck_Batch :  ^TSend_CISEDI;

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
              AddTask(LCheck_Batch,CCCISName^+' EDI');
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